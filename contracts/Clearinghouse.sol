// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title Clearinghouse
 * @notice Liberland Global Tax Clearinghouse
 * @dev Routes tax to declared jurisdictions; retains infrastructure fee for Liberland
 *
 *      DUAL REVENUE STREAMS:
 *      Stream 1 — Jurisdiction Revenue: parties declaring "LL" (Liberland) send their
 *                 50% share directly to Liberland's national treasury
 *      Stream 2 — Infrastructure Fee: Liberland retains LIB_FEE_BPS of all tax collected
 *                 on every transaction, regardless of declared jurisdictions
 *
 *      50/50 SPLIT: buyer jurisdiction gets 50% of routed tax; seller gets 50%
 *      ESCROW: unregistered jurisdictions accumulate with interest until they register
 *
 * @author Democracy Earth Foundation
 * @custom:liberland Proposed for adoption as Liberland's clearinghouse layer, 2026
 */

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

interface ITimeToken {
    function mintWorkTime(address worker, uint256 amount, bytes32 workContractId) external;
    function isVerifiedHuman(address) external view returns (bool);
}

interface IWorkNFT {
    function mint(address worker, uint256 amount, uint256 timestamp, bytes32 contractId) external;
}

contract Clearinghouse is Ownable, ReentrancyGuard {

    // ── CONSTANTS ──────────────────────────────────────────────────────────────

    bytes32 public constant LIBERLAND = keccak256("LL");  // Liberland jurisdiction code

    uint256 public constant TX_RATE_BPS = 1;              // 1 basis point transaction tax (default)
    uint256 public constant LIB_FEE_BPS = 500;            // 5% of tax to Liberland (Stream 2)
    uint256 public constant JURISDICTION_CHANGE_DELAY = 30 days; // prevent gaming

    uint256 public constant ESCROW_INTEREST_BPS_PER_YEAR = 300; // 3% annual interest on escrow

    // ── STATE ──────────────────────────────────────────────────────────────────

    ITimeToken public timeToken;
    IWorkNFT public workNFT;

    address public liberlandTreasury;

    // Government registry: jurisdiction hash => registered wallet address
    mapping(bytes32 => address) public jurisdictionWallet;
    mapping(bytes32 => bool) public jurisdictionRegistered;

    // Escrow for unregistered jurisdictions
    mapping(bytes32 => uint256) public escrowBalance;
    mapping(bytes32 => uint256) public escrowLastUpdated;

    // Work contracts
    struct WorkContract {
        address worker;
        address employer;
        bytes32 jurisdiction;       // ISO 3166-2 encoded — worker's declared jurisdiction
        uint256 pendingJurisdiction;
        uint256 jurisdictionChangeAt;
        bool active;
    }

    mapping(bytes32 => WorkContract) public workContracts;

    // Clearinghouse stats
    uint256 public totalTransactionVolume;
    uint256 public totalTaxCollected;
    uint256 public totalLibStream1;     // Jurisdiction revenue
    uint256 public totalLibStream2;     // Infrastructure fee revenue
    uint256 public totalRoutedToGovs;

    // ── EVENTS ─────────────────────────────────────────────────────────────────

    event TransactionSettled(
        bytes32 indexed contractId,
        address buyer,
        address seller,
        uint256 amount,
        uint256 tax,
        uint256 libFee,
        bytes32 buyerJurisdiction,
        bytes32 sellerJurisdiction
    );

    event TaxRouted(bytes32 indexed jurisdiction, uint256 amount, bool toEscrow);
    event GovernmentRegistered(bytes32 indexed jurisdiction, address wallet);
    event EscrowReleased(bytes32 indexed jurisdiction, address wallet, uint256 amount);
    event WorkContractCreated(bytes32 indexed contractId, address worker, bytes32 jurisdiction);
    event JurisdictionChangeQueued(bytes32 indexed contractId, bytes32 newJurisdiction, uint256 effectiveAt);

    // ── GOVERNMENT REGISTRY ────────────────────────────────────────────────────

    /**
     * @notice Register a government wallet to receive jurisdiction tax shares
     * @dev Any government may register — free, permissionless
     * @param jurisdictionCode ISO 3166-2 code (e.g. "DE-BE", "US-CA") as bytes32
     * @param wallet Address to receive tax routing
     */
    function registerJurisdiction(
        bytes32 jurisdictionCode,
        address wallet
    ) external {
        require(wallet != address(0), "Invalid wallet");
        // Note: Anyone can register. Legitimacy is social, not technical.
        // In practice, a government will register its own jurisdiction.
        // A malicious registrant would be overridden by protocol governance.

        bool wasUnregistered = !jurisdictionRegistered[jurisdictionCode];
        jurisdictionWallet[jurisdictionCode] = wallet;
        jurisdictionRegistered[jurisdictionCode] = true;

        emit GovernmentRegistered(jurisdictionCode, wallet);

        // Release any accumulated escrow
        if (wasUnregistered && escrowBalance[jurisdictionCode] > 0) {
            _releaseEscrow(jurisdictionCode, wallet);
        }
    }

    /**
     * @notice Release escrowed funds to a newly registered jurisdiction
     */
    function _releaseEscrow(bytes32 jurisdiction, address wallet) internal {
        uint256 balance = escrowBalance[jurisdiction];
        if (balance == 0) return;

        // Apply interest
        uint256 daysHeld = (block.timestamp - escrowLastUpdated[jurisdiction]) / 1 days;
        uint256 interest = (balance * ESCROW_INTEREST_BPS_PER_YEAR * daysHeld) / (10000 * 365);
        uint256 total = balance + interest;

        escrowBalance[jurisdiction] = 0;

        // Transfer (in production: ERC-20 transfer of TIME or stablecoin)
        // Placeholder for actual token transfer
        emit EscrowReleased(jurisdiction, wallet, total);
    }

    // ── WORK CONTRACT ──────────────────────────────────────────────────────────

    /**
     * @notice Create a Work Smart Contract
     * @param worker The verified human worker
     * @param jurisdiction The worker's declared tax jurisdiction (ISO 3166-2 as bytes32)
     */
    function createWorkContract(
        address worker,
        bytes32 jurisdiction
    ) external returns (bytes32 contractId) {
        require(timeToken.isVerifiedHuman(worker), "Worker must be verified human");
        require(timeToken.isVerifiedHuman(msg.sender), "Employer must be verified human");

        contractId = keccak256(abi.encodePacked(worker, msg.sender, block.timestamp));

        workContracts[contractId] = WorkContract({
            worker: worker,
            employer: msg.sender,
            jurisdiction: jurisdiction,
            pendingJurisdiction: 0,
            jurisdictionChangeAt: 0,
            active: true
        });

        emit WorkContractCreated(contractId, worker, jurisdiction);
    }

    /**
     * @notice Queue a jurisdiction change (30-day delay to prevent gaming)
     */
    function queueJurisdictionChange(
        bytes32 contractId,
        bytes32 newJurisdiction
    ) external {
        WorkContract storage wc = workContracts[contractId];
        require(wc.worker == msg.sender || wc.employer == msg.sender, "Not party to contract");
        require(wc.active, "Contract not active");

        wc.pendingJurisdiction = uint256(newJurisdiction);
        wc.jurisdictionChangeAt = block.timestamp + JURISDICTION_CHANGE_DELAY;

        emit JurisdictionChangeQueued(contractId, newJurisdiction, wc.jurisdictionChangeAt);
    }

    // ── SETTLEMENT ─────────────────────────────────────────────────────────────

    /**
     * @notice Settle a work transaction — the core clearinghouse function
     * @dev Called when payment for work is received
     *      Payment IS the mint event for Work TIME
     *
     * @param contractId The Work Smart Contract identifier
     * @param amount Transaction amount (in TIME or stablecoin)
     * @param buyerJurisdiction Buyer's declared jurisdiction
     */
    function settle(
        bytes32 contractId,
        uint256 amount,
        bytes32 buyerJurisdiction
    ) external nonReentrant {
        WorkContract storage wc = workContracts[contractId];
        require(wc.active, "Contract not active");

        // Apply pending jurisdiction change if delay has passed
        if (wc.jurisdictionChangeAt > 0 && block.timestamp >= wc.jurisdictionChangeAt) {
            wc.jurisdiction = bytes32(wc.pendingJurisdiction);
            wc.pendingJurisdiction = 0;
            wc.jurisdictionChangeAt = 0;
        }

        bytes32 sellerJurisdiction = wc.jurisdiction;

        // ── STEP 1: Collect tax ────────────────────────────────────────────────
        uint256 tax = (amount * TX_RATE_BPS) / 10000;
        uint256 netToSeller = amount - tax;

        // ── STEP 2: Stream 2 — Liberland infrastructure fee ───────────────────
        uint256 libFee = (tax * LIB_FEE_BPS) / 10000;
        uint256 routed = tax - libFee;

        // ── STEP 3: Split 50/50 by jurisdiction ───────────────────────────────
        uint256 buyerShare = routed / 2;
        uint256 sellerShare = routed - buyerShare; // handles odd wei

        // ── STEP 4: Route buyer jurisdiction share ────────────────────────────
        uint256 libStream1 = 0;
        if (buyerJurisdiction == LIBERLAND) {
            // Stream 1: buyer declared Liberland
            libStream1 += buyerShare;
        } else {
            _routeToJurisdiction(buyerJurisdiction, buyerShare);
        }

        // ── STEP 5: Route seller jurisdiction share ───────────────────────────
        if (sellerJurisdiction == LIBERLAND) {
            // Stream 1: seller declared Liberland
            libStream1 += sellerShare;
        } else {
            _routeToJurisdiction(sellerJurisdiction, sellerShare);
        }

        // ── STEP 6: Liberland treasury receives Stream 1 + Stream 2 ──────────
        uint256 libTotal = libFee + libStream1;
        // treasury.deposit(libTotal); // actual transfer in production

        // ── STEP 7: Mint Work TIME to seller (payment = mint event) ──────────
        // Convert payment amount to TIME (simplified: 1:1 for illustration)
        uint256 workTimeAmount = _paymentToWorkTime(netToSeller);
        timeToken.mintWorkTime(wc.worker, workTimeAmount, contractId);

        // ── STEP 8: Mint Work NFT ──────────────────────────────────────────────
        workNFT.mint(wc.worker, amount, block.timestamp, contractId);

        // ── ACCOUNTING ─────────────────────────────────────────────────────────
        totalTransactionVolume += amount;
        totalTaxCollected += tax;
        totalLibStream1 += libStream1;
        totalLibStream2 += libFee;
        totalRoutedToGovs += (buyerShare + sellerShare - libStream1);

        emit TransactionSettled(
            contractId, msg.sender, wc.worker,
            amount, tax, libFee,
            buyerJurisdiction, sellerJurisdiction
        );
    }

    /**
     * @notice Route a tax share to a jurisdiction's registered wallet or escrow
     */
    function _routeToJurisdiction(bytes32 jurisdiction, uint256 amount) internal {
        if (jurisdictionRegistered[jurisdiction]) {
            // Route to registered government wallet
            // In production: ERC-20 transfer to jurisdictionWallet[jurisdiction]
            emit TaxRouted(jurisdiction, amount, false);
        } else {
            // Accumulate in interest-bearing escrow
            if (escrowBalance[jurisdiction] == 0) {
                escrowLastUpdated[jurisdiction] = block.timestamp;
            }
            escrowBalance[jurisdiction] += amount;
            emit TaxRouted(jurisdiction, amount, true);
        }
    }

    /**
     * @notice Convert payment amount to Work TIME (implementation-specific)
     * @dev In production: uses TIME/USD oracle or fixed rate
     */
    function _paymentToWorkTime(uint256 paymentAmount) internal pure returns (uint256) {
        // Placeholder: 1 TIME per hour of minimum wage equivalent
        // Real implementation uses oracle price feed
        return paymentAmount / 1e18; // simplified
    }

    // ── VIEW FUNCTIONS ─────────────────────────────────────────────────────────

    function getEscrowWithInterest(bytes32 jurisdiction) external view returns (uint256) {
        uint256 balance = escrowBalance[jurisdiction];
        if (balance == 0) return 0;
        uint256 daysHeld = (block.timestamp - escrowLastUpdated[jurisdiction]) / 1 days;
        uint256 interest = (balance * ESCROW_INTEREST_BPS_PER_YEAR * daysHeld) / (10000 * 365);
        return balance + interest;
    }

    function getStats() external view returns (
        uint256 volume,
        uint256 taxCollected,
        uint256 stream1,
        uint256 stream2,
        uint256 routedToGovs
    ) {
        return (
            totalTransactionVolume,
            totalTaxCollected,
            totalLibStream1,
            totalLibStream2,
            totalRoutedToGovs
        );
    }

    // ── ADMIN ──────────────────────────────────────────────────────────────────

    function setTimeToken(address _timeToken) external onlyOwner {
        timeToken = ITimeToken(_timeToken);
    }

    function setWorkNFT(address _workNFT) external onlyOwner {
        workNFT = IWorkNFT(_workNFT);
    }

    function setLiberlandTreasury(address _treasury) external onlyOwner {
        liberlandTreasury = _treasury;
    }
}
