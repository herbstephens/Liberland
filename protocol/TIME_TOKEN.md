# TIME Token — Full Utility Specification

**VERSION 1.0 — March 2026**

---

## Overview

TIME is a blockchain-based economic primitive that denominates human work and existence in time rather than capital. It is the only token whose issuance is denominated in human existence rather than compute, liquidity, or capital investment.

**1 TIME = 1 hour of human existence**

---

## Issuance Mechanics

### Birthright TIME
- **Amount:** 1 TIME × number of days lived since birth
- **Issued:** As a retroactive lump sum upon World ID verification
- **Requirement:** Verified World ID (iris biometric, ZK proof) — one issuance per unique human
- **Source:** Protocol Bitcoin reserve — not redistributed from other holders
- **Nature:** Homestead claim — recognition that existence precedes market valuation

### Work TIME
- **Amount:** Up to 23 TIME per day
- **Minted:** When payment for work is received — **payment IS the mint event**
- **Requirement:** Verified Work Smart Contract with World ID parties on both sides
- **Proof:** Work NFT minted simultaneously — soulbound, immutable
- **Nature:** Earned, not assigned — the market validates the work

### Daily Ceiling
- **Maximum:** 24 TIME per day (1 birthright + 23 work)
- **Effect:** Enforces a 24:1 maximum inequality ratio at the protocol level
- **Mechanism:** Hard cap in the smart contract — cannot be overridden

---

## Utility Functions

### 1. Store of Value
- 100% Bitcoin-backed reserve
- TIME is redeemable against BTC at the protocol rate
- Reserve maintained by clearinghouse fee revenue
- Not a stablecoin — Bitcoin-backed, not pegged

### 2. Exchange Medium
- Human-to-human (H2H) transactions: **0.00% fee, permanently**
- Work contract settlement: clearinghouse fee applies (configurable, e.g. 5% of tax)
- Bridge transactions: 0.2% fee
- Minting: 0.5% fee
- Redemption: 0.1% fee

### 3. Governance Staking
- **Stake TIME on officials** — your stake is your vote of confidence
- **Unstake at any time** — continuous recall, no fixed election cycles
- **Stake TIME on laws** — legislative participation weighted by conviction, not wealth
- **Quadratic voting** — √TIME = votes, compressing the power of concentrated holdings
- **Effect:** Whale resistance built into the math; a holder with 100× more TIME has only 10× more votes

### 4. Identity Anchor
- TIME balance is a proxy for verified human existence
- Cannot accumulate meaningful TIME without World ID verification
- One human = one birthright stream = one governance identity
- Sybil attacks require physical iris duplication — practically impossible

### 5. Work History / Reputation
- Every Work Contract settlement mints a **Work NFT** to the seller
- Work NFT is soulbound — non-transferable
- Properties: worker address, employer address, amount, timestamp, jurisdiction
- Effect: An immutable, on-chain CV that no employer can alter or remove
- Extensible: MarriageProof, VolunteerProof, CredentialProof built on same primitive

### 6. Clearinghouse / Tax Routing
- Each Work Smart Contract carries `declared_jurisdiction` (ISO 3166-2)
- On settlement:
  - 50% of collected tax routes to buyer's declared jurisdiction
  - 50% routes to seller's declared jurisdiction
  - Liberland retains infrastructure fee (Stream 2)
  - If either party declares Liberland: that share goes to Liberland treasury (Stream 1)
- Unregistered jurisdictions: share accumulates in interest-bearing escrow

### 7. UBI Layer
- Birthright TIME constitutes a Universal Basic Income denominated in time, not fiat
- Rate: 1 TIME/day — equivalent to 1 hour of the holder's time, valued by the market
- Not means-tested, not conditional on behavior
- Not funded by redistribution — funded by protocol issuance backed by BTC reserve
- Globally accessible to any verified human regardless of nationality or location

---

## What TIME Is Explicitly NOT

| Not This | Because |
|---|---|
| A speculative asset | Soulbound, earned, capped — no secondary market velocity |
| A stablecoin | Bitcoin-backed but not pegged to fiat |
| A governance token in the VC sense | Quadratic voting prevents whale dominance |
| A UBI handout | Birthright issuance requires World ID; work TIME requires payment |
| A corporate token | Corporations cannot hold birthright TIME — they are infrastructure users |
| An inflationary currency | Daily ceiling caps total issuance; reserve backs redemption |

---

## Cross-Chain Deployment

| Chain | Role |
|---|---|
| **World Chain** | Authoritative registry for World ID nullifiers |
| **NEAR** | Governance layer, Political AI Agent, Rust smart contracts |
| **Logos L1** | Parallel society OS deployment |
| **Ethereum** | Mirror deployment, ENS integration |
| **Liberland Blockchain** | Bridge node in the clearinghouse model |

---

## Token Economics Summary

```
Daily issuance per human:
  Birthright:  1 TIME  (existence)
  Work max:   23 TIME  (labor, verified by payment)
  ─────────────────────
  Daily max:  24 TIME

Inequality ratio:      24:1 maximum (protocol-enforced)
Reserve:               100% Bitcoin-backed
H2H fee:               0.00% (permanent)
Clearinghouse fee:     ~5% of tax collected (configurable)
Minting fee:           0.50%
Redemption fee:        0.10%
Bridge fee:            0.20%
```

---

## The Founding Insight

Every economic system in history has denominated value in something: gold, fiat currency, compute cycles, liquidity provision. TIME Protocol denominates value in the one thing that every human being possesses equally at birth and cannot buy more of:

**Time.**

Not the market value of time — that varies. The existence of time — the 24 hours each human being is issued per day, regardless of where they were born, what language they speak, or what capital they have accumulated.

The 24 TIME/day ceiling is not an arbitrary limit. It is a statement: no human being's day is worth more than 24 hours. No algorithm, no inheritance, no corporate structure changes that.

---

*See also: [`WORK_CONTRACT.md`](./WORK_CONTRACT.md) · [`WORLD_ID.md`](./WORLD_ID.md) · [`UBI.md`](./UBI.md)*
