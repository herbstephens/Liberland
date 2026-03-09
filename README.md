# Liberland × TIME Protocol

**A Blueprint for the World's First Human-Native Economy**

> *"The question is not whether Liberland can become something extraordinary. It already has the ingredients. The question is whether its leadership will choose to build a new model — or replicate the oldest and most discredited one."*
> — Herb Stephens, Democracy Earth Foundation, 2026

---

## What This Repository Is

This is a complete technical and philosophical blueprint for the adoption of **TIME Protocol** as the economic, governance, and citizenship layer of the Free Republic of Liberland.

It was developed in 2026 by **Herb Stephens**, Co-Founder of [Democracy Earth Foundation](https://democracy.earth), following direct engagement with Liberland's founder and President, Vít Jedlička.

**This repository exists for two purposes:**

1. **A technical blueprint** — everything a future Liberland administration would need to implement TIME Protocol as the nation's foundational economic layer.

2. **A public record** — documentation that this proposal was made, the terms on which it was made, and the reasons it was declined by the current administration. See [`RECORD.md`](./RECORD.md).

This is not written in anger. It is written in conviction — that the blueprint here is correct, that Liberland's moment will come, and that whoever leads Liberland when it does will want to find this repository waiting for them.

---

## The Core Proposal in Three Sentences

**Give Liberland's 735,000 human citizenship applicants verified economic identity through TIME Protocol — one TIME per day of existence, earned and governed by the people who actually live and breathe.** Let corporations use Liberland's infrastructure at a fair, transparent, automatic fee — not at zero. Make Liberland the world's tax clearinghouse: routing every government's share to them automatically, earning a small fee for running the rails, and proving by operation that radical transparency outperforms radical secrecy.

---

## Repository Structure

```
liberland/
├── README.md                   ← You are here — overview and public record statement
├── RECORD.md                   ← The historical record: what was proposed, and why it was declined
│
├── proposal/
│   ├── README.md               ← Executive summary of the full proposal
│   ├── CITIZENSHIP.md          ← Human-only citizenship: the foundational distinction
│   ├── CLEARINGHOUSE.md        ← Dual-stream tax clearinghouse model
│   ├── GOVERNANCE.md           ← TIME-staked quadratic voting and recall
│   └── ECONOMICS.md            ← Revenue model: Stream 1 + Stream 2
│
├── protocol/
│   ├── TIME_TOKEN.md           ← Full TIME token utility specification
│   ├── WORK_CONTRACT.md        ← Work Smart Contract with jurisdiction field
│   ├── WORLD_ID.md             ← Identity layer: World ID integration
│   └── UBI.md                  ← Birthright TIME: why this is not charity
│
├── implementation/
│   ├── ROADMAP.md              ← Four-phase implementation plan
│   ├── TECHNICAL.md            ← Stack: World Chain, NEAR, Logos, Ethereum
│   └── BRIDGES.md              ← Cross-chain architecture
│
├── contracts/
│   ├── TimeToken.sol           ← ERC-20 extension with soulbound mechanics
│   ├── WorkContract.sol        ← Work Smart Contract with clearinghouse routing
│   └── Clearinghouse.sol       ← Government registry and dual-stream routing
│
└── record/
    ├── CORRESPONDENCE.md       ← Timeline of engagement with Liberland leadership
    └── OBJECTIONS.md           ← The two objections raised, and responses to each
```

---

## The TIME Protocol — A Primer

TIME Protocol is a blockchain-based economic primitive that denominates human work in time rather than capital.

| Mechanism | Value |
|---|---|
| **Birthright TIME** | 1 TIME × days lived since birth — issued on World ID verification |
| **Work TIME** | Up to 23 TIME/day — minted when payment for work is received |
| **Daily ceiling** | 24 TIME maximum — enforces 24:1 inequality cap at protocol level |
| **H2H fee** | 0.00% — permanent, for human-to-human transactions |
| **Reserve** | 100% Bitcoin-backed |
| **Identity** | World ID (iris biometric, zero-knowledge proof) — Sybil-resistant |
| **Governance** | Stake TIME on officials and laws; quadratic voting (√TIME = votes) |

**The foundational insight:** TIME is the only token whose issuance is denominated in human existence rather than capital, compute, or liquidity. You cannot buy birthright TIME. You can only live to earn it.

---

## Why Liberland

Liberland is the only jurisdiction on Earth with all of the following properties simultaneously:

- **No legacy tax system to dismantle** — no IRS, no HMRC, no entrenched bureaucracy
- **Blockchain-native governance** — elections already run on-chain via LLD staking
- **Bitcoin-aligned reserves** — 99% BTC holdings; Bitcoin-model taxation is philosophically native
- **Libertarian founding principles** — a micro-fee on transactions is the most libertarian tax possible
- **735,000 human applicants** — the largest voluntary citizenship waitlist in history
- **No geographic constraint** — the citizen base is global, bounded only by protocol adoption

The combination of these properties will not exist in any other jurisdiction for decades, if ever. This is a window. The question is whether it will be used.

---

## The Distinction That Matters

**Citizens United (2010)** told us that corporations are persons — that money is speech, and that corporate political spending cannot be limited. Within 14 years, this had produced a political system where corporate dark money, routed through low-disclosure jurisdictions, had become the dominant force in democratic elections.

The lesson of Citizens United is not that corporations deserve rights. It is that when you grant entities with unlimited capital, no mortality, and no stake in the outcome the same standing as human beings — **the humans lose.**

TIME Protocol makes the foundational distinction structural:

- **Humans** receive birthright TIME. Humans govern. Humans are sovereign.
- **Corporations** may use Liberland's clearinghouse infrastructure at a fair, transparent fee.
- The fee is small — far smaller than any existing tax regime.
- But it is not zero. Because zero is not a price. **Zero is a transfer — from the corporation to the humans who pay what the corporation doesn't.**

---

## Contact

**Herb Stephens**  
Co-Founder, Democracy Earth Foundation  
herb@democracy.earth | herbstephens.eth  

**Democracy Earth Foundation**  
democracy.earth | [@DemocracyEarth](https://twitter.com/democracyearth)

---

*This repository is public. Its contents are dedicated to the public record. Anyone may fork, extend, or implement what is documented here. The ideas belong to the humans who need them.*

*First committed: March 2026.*
