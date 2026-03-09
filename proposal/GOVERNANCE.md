# Governance — TIME-Staked Quadratic Democracy

---

## The Problem with Every Governance System Built So Far

Every governance system collapses toward one of two failure modes:

**Plutocracy:** Votes are weighted by capital. Those with more money have more power. One dollar, one vote. Corporations, which can accumulate capital without limit, eventually dominate. This is what Citizens United accelerated.

**Mob rule:** Votes are equal regardless of stake or knowledge. One person, one vote, with no mechanism to express conviction or penalize disengagement. Susceptible to capture by whoever can most cheaply mobilize the least-informed voters.

TIME Protocol's governance model avoids both failure modes through a single mathematical insight.

---

## Quadratic Voting — The Core Mechanism

In standard voting: 1 unit of capital = 1 vote. Power scales linearly with wealth.

In quadratic voting: votes = √(TIME staked). Power scales with the square root of wealth.

**The effect:**

| TIME Staked | Linear Votes | Quadratic Votes | Power Ratio vs 1 TIME |
|---|---|---|---|
| 1 TIME | 1 | 1 | 1× |
| 4 TIME | 4 | 2 | 2× |
| 9 TIME | 9 | 3 | 3× |
| 100 TIME | 100 | 10 | 10× |
| 576 TIME (24 TIME/day × 24 days) | 576 | 24 | 24× |

A holder with 576× more TIME than another has only 24× more voting power. The protocol-level 24:1 TIME inequality cap means the maximum governance power ratio is also bounded — no holder can have more than √(24×base) times the voting power of the minimum holder.

**Whale resistance is mathematical, not constitutional.** It cannot be lobbied away. It is in the contract.

---

## Staking on Officials — Continuous Recall

In TIME Protocol governance, there are no fixed election cycles. Instead:

- Citizens **stake TIME on officials** at any time
- The stake represents expressed confidence — *this person represents my interests*
- Citizens **unstake at any time** — immediate, no waiting period
- An official's legitimacy is the live aggregate of TIME staked on them

**The result:** An official who loses the confidence of their constituency does not wait four years to be removed. They lose staked TIME in real time. Their governance authority diminishes continuously as confidence diminishes.

This is more sensitive to actual performance than any fixed-cycle election. And unlike recall petitions — which require expensive signature campaigns — unstaking is a single transaction.

**Liberland's current LLD staking model is already the conceptual precursor to this.** TIME Protocol formalizes it with soulbound mechanics and quadratic weighting.

---

## Staking on Laws — Legislative Participation

Citizens may also stake TIME directly on proposed laws, policies, and protocol parameters. The mechanics:

- **Propose:** Any verified citizen may submit a governance proposal
- **Stake:** Citizens stake TIME on proposals — for or against
- **Threshold:** Proposal passes when net staked TIME (for minus against) exceeds a protocol-defined threshold
- **Conviction:** Longer stake duration multiplies voting weight — the longer you commit, the more your conviction counts
- **Cost of changing mind:** Unstaking before duration resets conviction multiplier — creating a genuine cost to flip-flopping

**The result:** Laws are passed not by whoever shows up on election day, but by whoever has the most skin in the game over time. Governance reflects sustained conviction, not momentary mobilization.

---

## What This Means for Liberland Specifically

Liberland's current governance runs on LLD staking with 90-day election cycles. This is already far ahead of most democratic systems. TIME Protocol extends it:

| Current Liberland (LLD) | TIME Protocol Governance |
|---|---|
| 90-day fixed cycles | Continuous staking/unstaking |
| Linear stake weighting | Quadratic stake weighting |
| LLD — speculative token | TIME — soulbound, human-verified |
| Vulnerable to whale capture | 24:1 ceiling caps governance power ratio |
| No conviction multiplier | Conviction staking rewards sustained belief |
| Citizens only | Corporations explicitly excluded |

---

## The Corporations Cannot Govern Clause

TIME Protocol makes explicit what Citizens United failed to preserve:

**Corporations cannot hold birthright TIME. Corporations cannot stake on governance. Corporations cannot vote.**

This is not ideological. It is structural. TIME issuance requires World ID verification — iris biometric, zero-knowledge proof, one issuance per unique human. A corporation cannot have an iris. A corporation cannot be issued birthright TIME. A corporation cannot stake what it does not have.

The governance exclusion of corporations is not a policy that can be reversed by a future administration. It is a mechanical property of the protocol.

This is the distinction that Citizens United failed to make. TIME Protocol makes it permanent.

---

## The Political AI Agent

Deployed on NEAR, the TIME Protocol Political AI Agent provides each citizen with a governance interface that:

- Surfaces active proposals sorted by TIME staked
- Shows which officials have the most/least staked confidence
- Recommends governance actions based on the citizen's own staking history
- Discovers, via on-chain analysis, *who actually governs each person* — which officials' decisions affect their work contracts and transaction history

The Political AI Agent does not vote on your behalf. It makes the governance layer legible — translating a complex on-chain state into a clear picture of where power actually sits and what it is doing.

This is democracy as information infrastructure, not as periodic ceremony.

---

*See also: [`protocol/TIME_TOKEN.md`](../protocol/TIME_TOKEN.md) · [`proposal/CITIZENSHIP.md`](./CITIZENSHIP.md)*
