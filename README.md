# Fund Me (Foundry Project)

A simple Ethereum smart contract project built with [Foundry](https://book.getfoundry.sh/).  
The main contract, `FundMe`, allows users to fund the contract with ETH, and the owner can withdraw the funds.  
It uses a `PriceConverter` utility to ensure minimum funding amounts in USD.

## Project Structure

- `src/FundMe.sol` — Main contract for funding and withdrawals.
- `src/PriceConverter.sol` — Library for ETH/USD price conversion.
- `script/DeployFundMe.s.sol` — Script to deploy the `FundMe` contract.
- `script/Interaction.s.sol` — Scripts to interact with the contract (fund and withdraw).
- `test/unit/FundMeTest.t.sol` — Unit tests for the `FundMe` contract.
- `test/Interaction/FundMeTestInteraction.t.sol` — Interaction tests.
- `test/mocks/MockV3Aggregator.sol` — Mock contract for price feeds.

## Prerequisites

- [Foundry](https://book.getfoundry.sh/getting-started/installation) installed (`forge`, `anvil`, etc.)
- Node.js and npm (if using scripts that require them)
- An Ethereum RPC URL and private key for deployment

## Setup

1. **Install dependencies:**
   ```sh
   forge install
   ```

2. **Build contracts:**
   ```sh
   forge build
   ```

## Testing

Run all tests (unit and interaction):

```sh
forge test
```

## Deployment

Deploy the `FundMe` contract using the provided script:

```sh
forge script script/DeployFundMe.s.sol --rpc-url <YOUR_RPC_URL> --private-key <YOUR_PRIVATE_KEY> --broadcast
```

## Interacting with the Contract

### Fund the Contract

```sh
forge script script/Interaction.s.sol:FundFundMe --rpc-url <YOUR_RPC_URL> --private-key <YOUR_PRIVATE_KEY> --broadcast
```

### Withdraw Funds

```sh
forge script script/Interaction.s.sol:WithdrawFundMe --rpc-url <YOUR_RPC_URL> --private-key <YOUR_PRIVATE_KEY> --broadcast
```

## Formatting

Format your contracts with:

```sh
forge fmt
```

## Gas Snapshots

To generate gas usage reports:

```sh
forge snapshot
```

## Additional Resources

- [Foundry Book](https://book.getfoundry.sh/)
- [Chainlink Price Feeds](https://docs.chain.link/data-feeds/price-feeds/addresses)

---

**Note:**  
- Update `<YOUR_RPC_URL>` and `<YOUR_PRIVATE_KEY>` with your own credentials.
- Review and customize scripts in the `script/` directory as needed for your deployment environment.

---

Happy building!
