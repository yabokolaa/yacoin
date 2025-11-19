# Yacoin

Yacoin is a simple example token project backed by a Clarity smart contract and a Clarinet
local-development setup.

## Repository layout

- `/yacoin-clarinet` – Clarinet project containing the `yacoin` smart contract
  - `Clarinet.toml` – Clarinet project configuration
  - `contracts/yacoin.clar` – Yacoin fungible-token style contract
  - `settings/` – network configuration for Devnet/Testnet/Mainnet
  - `tests/` – place for automated tests (TypeScript + Vitest)

## Requirements

- [Clarinet](https://github.com/hirosystems/clarinet) (already initialized here)
- Node.js (for running the generated TypeScript test tooling, if desired)

## Working with the Clarinet project

From the repo root:

```bash
cd yacoin-clarinet
clarinet check
```

This will:

- type-check and analyze the `yacoin` contract
- report any Clarity syntax or static-analysis issues

You can also open a Clarinet console to experiment with contract calls:

```bash
cd yacoin-clarinet
clarinet console
```

Within the console you can call the contract functions directly, for example:

```clarity
(contract-call? .yacoin mint u1000 tx-sender)
(contract-call? .yacoin transfer u1000 tx-sender 'SP2C2...RECIPIENT)
(read-only (get-balance-of tx-sender))
```

> Replace `SP2C2...RECIPIENT` with a real Stacks principal and adjust amounts as
> needed.

## Contract interface

The `yacoin` contract exposes:

- **Read-only functions**
  - `get-name` – returns the token name (`"Yacoin"`)
  - `get-symbol` – returns the token symbol (`"YAC"`)
  - `get-decimals` – returns the decimal precision (`u6`)
  - `get-total-supply` – returns the total minted supply so far
  - `get-balance-of (who principal)` – returns the balance for a given principal

- **Public functions**
  - `mint (amount uint) (recipient principal)` – mints `amount` tokens to
    `recipient` and increases `total-supply`
  - `transfer (amount uint) (sender principal) (recipient principal)` – transfers
    `amount` tokens from `sender` to `recipient`.

> Note: in this simplified example, `mint` is permissionless (anyone can mint).
> For a production deployment you would typically restrict minting to an admin
> principal or the contract itself.

## Running tests

The Clarinet project is scaffolded with a TypeScript + Vitest setup. To use it,
run:

```bash
cd yacoin-clarinet
npm install
npm test
```

You can then add tests under `yacoin-clarinet/tests` to exercise the `yacoin`
contract behavior.
