// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title TimeToken
 * @notice TIME Protocol — Human-Native Economic Primitive
 * @dev ERC-20 extension with soulbound birthright mechanics
 *      1 TIME = 1 hour of human existence
 *      Issuance requires World ID verification
 *      Soulbound: non-transferable except through WorkContract settlement or H2H exchange
 *
 * @author Democracy Earth Foundation
 * @custom:liberland Proposed for adoption as Liberland's native economic layer, 2026
 */

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface IWorldID {
    function verifyProof(
        uint256 root,
        uint256 groupId,
        uint256 signalHash,
        uint256 nullifierHash,
        uint256 externalNullifierHash,
        uint256[8] calldata proof
    ) external view;
}

contract TimeToken is ERC20, Ownable {

    // ── CONSTANTS ──────────────────────────────────────────────────────────────

    uint256 public constant MAX_DAILY_TIME = 24 ether;       // 24 TIME/day ceiling
    uint256 public constant BIRTHRIGHT_DAILY = 1 ether;      // 1 TIME/day of existence
    uint256 public constant MAX_WORK_DAILY = 23 ether;       // 23 TIME/day from work
    uint256 public constant SECONDS_PER_DAY = 86400;

    // Fee basis points (out of 10000)
    uint256 public constant MINT_FEE_BPS = 50;               // 0.5% minting fee
    uint256 public constant REDEEM_FEE_BPS = 10;             // 0.1% redemption fee
    uint256 public constant BRIDGE_FEE_BPS = 20;             // 0.2% bridge fee

    // ── STATE ──────────────────────────────────────────────────────────────────

    IWorldID public immutable worldId;
    address public clearinghouse;
    address public treasury;

    mapping(address => bool) public isVerifiedHuman;
    mapping(address => uint256) public birthTimestamp;       // Unix timestamp of birth
    mapping(address => uint256) public birthrightClaimed;    // Total birthright TIME claimed
    mapping(uint256 => bool) public nullifierUsed;           // World ID nullifier registry
    mapping(address => uint256) public dailyWorkMinted;      // Work TIME minted today
    mapping(address => uint256) public lastWorkDay;          // Last day work TIME was minted

    // ── EVENTS ─────────────────────────────────────────────────────────────────

    event HumanVerified(address indexed human, uint256 birthTimestamp, uint256 birthrightAmount);
    event WorkTimeMinted(address indexed worker, uint256 amount, bytes32 workContractId);
    event BirthrightClaimed(address indexed human, uint256 amount);
    event TreasuryDeposit(uint256 amount, string streamType);

    // ── CONSTRUCTOR ────────────────────────────────────────────────────────────

    constructor(
        address _worldId,
        address _treasury
    ) ERC20("TIME", "TIME") Ownable(msg.sender) {
        worldId = IWorldID(_worldId);
        treasury = _treasury;
    }

    // ── WORLD ID VERIFICATION ──────────────────────────────────────────────────

    /**
     * @notice Register as a verified human and claim birthright TIME
     * @param birthTimestamp_ Unix timestamp of birth date
     * @param nullifierHash World ID nullifier — unique per human
     * @param proof World ID ZK proof
     */
    function verifyAndClaimBirthright(
        uint256 birthTimestamp_,
        uint256 nullifierHash,
        uint256 root,
        uint256[8] calldata proof
    ) external {
        require(!isVerifiedHuman[msg.sender], "Already verified");
        require(!nullifierUsed[nullifierHash], "Nullifier already used — one human, one birthright");
        require(birthTimestamp_ < block.timestamp, "Birth must be in the past");

        // Verify World ID proof
        worldId.verifyProof(
            root,
            1,                          // groupId
            uint256(uint160(msg.sender)), // signal: wallet address
            nullifierHash,
            uint256(keccak256(abi.encodePacked("liberland.time.birthright"))),
            proof
        );

        nullifierUsed[nullifierHash] = true;
        isVerifiedHuman[msg.sender] = true;
        birthTimestamp[msg.sender] = birthTimestamp_;

        // Calculate retroactive birthright: 1 TIME per day lived
        uint256 daysLived = (block.timestamp - birthTimestamp_) / SECONDS_PER_DAY;
        uint256 birthrightAmount = daysLived * BIRTHRIGHT_DAILY;

        birthrightClaimed[msg.sender] = birthrightAmount;
        _mint(msg.sender, birthrightAmount);

        emit HumanVerified(msg.sender, birthTimestamp_, birthrightAmount);
        emit BirthrightClaimed(msg.sender, birthrightAmount);
    }

    /**
     * @notice Claim daily birthright TIME accrual (ongoing, post-verification)
     */
    function claimDailyBirthright() external {
        require(isVerifiedHuman[msg.sender], "Not verified");
        uint256 lastClaim = birthrightClaimed[msg.sender];
        uint256 totalOwed = ((block.timestamp - birthTimestamp[msg.sender]) / SECONDS_PER_DAY) * BIRTHRIGHT_DAILY;
        uint256 unclaimed = totalOwed - lastClaim;
        require(unclaimed > 0, "Nothing to claim");

        birthrightClaimed[msg.sender] = totalOwed;
        _mint(msg.sender, unclaimed);
        emit BirthrightClaimed(msg.sender, unclaimed);
    }

    // ── WORK TIME MINTING ──────────────────────────────────────────────────────

    /**
     * @notice Mint Work TIME — called by WorkContract on payment settlement
     * @dev Payment IS the mint event. Only clearinghouse/WorkContract may call.
     * @param worker The verified human receiving Work TIME
     * @param amount Amount of TIME to mint (max 23 TIME/day)
     * @param workContractId Reference to the originating work contract
     */
    function mintWorkTime(
        address worker,
        uint256 amount,
        bytes32 workContractId
    ) external {
        require(msg.sender == clearinghouse, "Only clearinghouse");
        require(isVerifiedHuman[worker], "Worker not verified");
        require(amount <= MAX_WORK_DAILY, "Exceeds 23 TIME/day work cap");

        // Reset daily counter if new day
        uint256 today = block.timestamp / SECONDS_PER_DAY;
        if (lastWorkDay[worker] < today) {
            dailyWorkMinted[worker] = 0;
            lastWorkDay[worker] = today;
        }

        require(
            dailyWorkMinted[worker] + amount <= MAX_WORK_DAILY,
            "Daily work TIME cap reached"
        );

        dailyWorkMinted[worker] += amount;
        _mint(worker, amount);

        emit WorkTimeMinted(worker, amount, workContractId);
    }

    // ── TRANSFER OVERRIDES (soulbound mechanics) ────────────────────────────────

    /**
     * @notice Override transfer — only H2H between verified humans, or clearinghouse
     * @dev Enforces soulbound property: TIME cannot be transferred to unverified addresses
     */
    function _update(
        address from,
        address to,
        uint256 amount
    ) internal override {
        // Minting (from == 0) and burning always allowed
        if (from == address(0) || to == address(0)) {
            super._update(from, to, amount);
            return;
        }

        // Clearinghouse operations always allowed
        if (from == clearinghouse || to == clearinghouse) {
            super._update(from, to, amount);
            return;
        }

        // H2H: both parties must be verified humans
        require(isVerifiedHuman[from], "Sender not a verified human");
        require(isVerifiedHuman[to], "Recipient not a verified human");

        super._update(from, to, amount);
    }

    // ── ADMIN ──────────────────────────────────────────────────────────────────

    function setClearinghouse(address _clearinghouse) external onlyOwner {
        clearinghouse = _clearinghouse;
    }

    function setTreasury(address _treasury) external onlyOwner {
        treasury = _treasury;
    }
}
