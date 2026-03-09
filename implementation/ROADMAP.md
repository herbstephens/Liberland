# Implementation Roadmap

**Four Phases from Adoption to Global Infrastructure**

---

## Phase 1 — Foundation (2026)

### Actions
- [ ] Liberland formally adopts TIME Protocol as its economic layer by constitutional amendment or presidential decree
- [ ] World ID integration activated for citizenship applications — 735,000 applicants invited to verify
- [ ] `jurisdiction` field added to Work Smart Contract standard
- [ ] Clearinghouse contract deployed on World Chain (authoritative registry)
- [ ] Government Wallet Registry launched — open to all 193 UN member states
- [ ] Liberland treasury address published publicly — all inflows visible in real time
- [ ] LLD ↔ TIME bridge deployed for existing LLD holders
- [ ] Stream 2 infrastructure fee set at 5% of tax collected
- [ ] Birthright TIME issuance begins for verified citizens

### Milestones
- First 10,000 verified Liberland citizens with TIME allocations
- First government (target: a sympathetic jurisdiction) registers wallet
- First clearinghouse transaction routed — public on-chain
- First Work NFT minted to a Liberland citizen

### Key Contracts
- `TimeToken.sol` — ERC-20 with soulbound birthright mechanics
- `WorkContract.sol` — settlement with jurisdiction routing
- `Clearinghouse.sol` — government registry and dual-stream routing

---

## Phase 2 — Demonstration (2027)

### Actions
- [ ] One full year of live clearinghouse data collected and published
- [ ] Annual report: compliance rate, evasion rate, enforcement staff
- [ ] Present to OECD, IMF, and G20 — not as proposal, as working model
- [ ] First bilateral government acknowledgment of clearinghouse routing
- [ ] Political AI Agent (NEAR) deployed for Liberland citizen governance interface
- [ ] First Liberland election conducted via TIME staking with quadratic weighting

### Target Metrics (End of Phase 2)
- Verified citizens: 50,000+
- Governments registered: 20+
- Annual clearinghouse volume: $1B+
- Compliance rate: 100% (structural — cannot be otherwise)
- Enforcement staff: 0

### The Demonstration Statement
> *"We have 50,000 verified human citizens paying into a transparent, auditable protocol. We routed tax to 20 governments automatically. Compliance: 100%. Evasion: 0%. Enforcement: 0 people. This is not a proposal. This is a running system. What is your compliance rate?"*

---

## Phase 3 — Scale (2028–2030)

### Actions
- [ ] 100,000+ verified citizens
- [ ] 100+ governments registered in the wallet registry
- [ ] TIME Protocol adopted as the standard for at least one additional jurisdiction
- [ ] Liberland applies for UN observer status — clearinghouse routing as evidence of legitimacy
- [ ] Work NFT history accepted as legal employment record in at least one jurisdiction
- [ ] Cross-chain bridges live on all target chains (World Chain, NEAR, Logos, Ethereum)

### Revenue Projections (Phase 3)
At 3bp transaction rate, 5% fee, 5% citizen share of parties:
- Stream 1: $3B/year
- Stream 2: $3B/year
- Combined: $6B/year
- Per capita: $8,163/year for 735,000 citizens

---

## Phase 4 — Legitimacy (2031+)

### Vision
Liberland is recognized as a sovereign state by at least a coalition of jurisdictions — not because of military power or territory, but because:

1. It routes more tax to more governments more reliably than any bilateral enforcement mechanism
2. It has more verifiable democratic participation than most member states
3. It has a higher tax compliance rate than every nation it serves
4. Every finance ministry on Earth is a registered counterparty

### The Challenge to Every Other Nation
*"Show us your compliance rate. Show us your transparency. Show us your enforcement cost per dollar collected. We will show you ours — and route your share to you automatically, for a fee smaller than your audit budget."*

---

## Technical Prerequisites

See [`TECHNICAL.md`](./TECHNICAL.md) for full stack specification.

**Minimum viable stack for Phase 1:**
- World Chain node (or API access for World ID nullifier verification)
- Solidity contracts: `TimeToken.sol`, `WorkContract.sol`, `Clearinghouse.sol`
- NEAR account for governance agent deployment
- Public-facing government registry UI
- Citizen verification flow (World ID → birthright TIME issuance)

---

*See also: [`TECHNICAL.md`](./TECHNICAL.md) · [`BRIDGES.md`](./BRIDGES.md) · [`contracts/`](../contracts/)*
