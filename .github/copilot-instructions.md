## Repo snapshot

This is a small Foundry (Forge) Solidity project. Key paths:

- `src/` - Solidity source files (contracts). Example: `src/funding.sol` contains `IFunding` and `Funding` contract.
- `test/` - Forge tests. Example: `test/funding.t.sol` (placeholder/test template present).
- `lib/forge-std` - Standard Forge testing utilities used across tests (imports like `forge-std/Test.sol`).
- `foundry.toml` - Build/test settings (src/out/libs configured).

## Big picture

Purpose: a lightweight donations/funding contract that tracks donation targets, creators, and contributions.

Architecture:

- Contracts are small and single-responsibility. `Funding` stores donations in a `mapping(uint256 => Donation)` and exposes `createDonation`, `getDonation`, and `donate`.
- Tests use the Forge testing framework (`forge test`) and `forge-std` helpers.

Why: The project follows common Foundry patterns — minimal contracts, use Forge for fast compile/test cycles, and `lib/forge-std` for testing utilities.

## Developer workflows (explicit)

- Build: `forge build`
- Test: `forge test -vv` (verbose output helps when diagnosing compiler/test errors)
- Format: `forge fmt`
- Run a single test file: `forge test --match-path test/funding.t.sol`

If tests fail locally, run `forge test -vv` and copy the full terminal output (including stack traces and compiler messages) when asking for help. This repo currently doesn't include CI config; follow the same commands in CI.

## Project-specific patterns & conventions

- Solidity version pin: contracts use `pragma solidity ^0.8.30` (check individual files). Keep compiler version aligned in Foundry config if you change the pragma.
- Storage: donations are stored in `mapping(uint256 => Donation)` with `totalDonations` incrementing to assign IDs.
- Events: `DonationCreated` and `DonationMade` are emitted on create and donate flows — expect tests to assert events.
- Access and roles: simple `owner` pattern exists in `Funding` constructor; no Ownable import used. Constructors may accept `owner` addresses explicitly.
- Guards: helper `checkDonation` performs input validation and internal checks (note: it uses `msg.sender` semantics).

## Common pitfalls observed (concrete examples from this repo)

- Constructor mismatch: `Funding`'s constructor requires an `address _owner`. Tests or scripts that `new Funding()` without args will fail to compile — ensure instantiation passes an address. Search for `new Funding` if you see "constructor expected" errors.
- Event arg types: event signatures include `string description`; when asserting events in tests, make sure string comparisons in tests match exactly or use `vm.expectEmit` patterns from `forge-std`.
- Public storage vs getters: `mapping` is private and a `getDonation(uint256)` is provided; tests should call this getter, not try to access mapping directly.
- Reentrancy/ETH handling: current `Funding` contract stores amounts but does not accept ETH transfers — donation amounts are tracked off-chain or as bookkeeping values. If tests expect ETH transfers, adjust the contract to be payable and handle transfers.

## How to ask for help (what to paste)

When filing an issue or asking an AI for help, include:

1. The command you ran (`forge test -vv`), and the complete terminal output (full compiler errors and stack traces).
2. The file and line number reported by the compiler (e.g., `src/funding.sol:45:5`).
3. The small set of files you recently changed (a git diff is ideal).

Example minimal bug report payload:

```
Command: forge test -vv
Output: <paste full output>
Relevant files: src/funding.sol, test/funding.t.sol
Recent change: git diff -- src/funding.sol
```

## Quick references to look at in this repo

- `src/funding.sol` — donation data model and flows (create/donate/get)
- `lib/forge-std` — test helpers and patterns (`Test.sol`, `Vm.sol`) used by tests
- `foundry.toml` — compiler/test configuration

## If you are an AI coding agent

- Prefer small, local edits and run `forge test -vv` after changes.
- Preserve existing function signatures unless tests indicate they must change (e.g., constructor args).
- When suggesting fixes, point to exact lines in files (e.g., `src/funding.sol:42-56`) and provide a minimal patch.

---

If you'd like, I can merge this into an existing `.github/copilot-instructions.md` or expand any section with exact examples (e.g., common failing errors and fixes). Also paste the terminal error you saw and I will diagnose it next.
