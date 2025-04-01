# Uniswap Arbitrageur

This project implements an arbitrage system that executes flash swaps between Uniswap V2 and Uniswap V3 pools to capture profitable opportunities. It consists of an on-chain smart contract (**arbitrage-contract**) that handles flash-swap callbacks and multi-hop swap execution, and an off-chain client (**arbitrage-client**) that reads arbitrage JSON-encoded requests supplied by a human operator, encodes them into a compact payload, and submits transactions that call a deployed arbitrage-contract via Ethereum JSON-RPC.

## Components

This project is comprised of two components, each corresponding to a folder in this repository:
- **arbitrage-contract**: a Solidity smart contract that:
  - Exposes a `startArbitrage` method to initiate the flash swap by calling a Uniswap V2 or V3 pair contract with an encoded arbitrage request.
  - Implements `uniswapV2Call` and `uniswapV3Call` callback functions to decode the arbitrage request, execute a series of swaps (each using the previous swap’s output as input), and finally assert that the net profit meets a minimum threshold before repaying the flash swap.
- **arbitrage-client**: a Rust program that:
  - Reads an arbitrage request from a JSON file.
  - Encodes the request into a byte payload that includes the initial input amount, expected profit, and a series of swap hops (each with a selector, direction, and pool address).
  - Sends the payload via Ethereum JSON-RPC to the deployed arbitrage contract and prints status updates and final results to the console.

## Development Environment

### Solidity Environment Setup

- Install Node.js and npm.
- Install VSCode Solidity Extensions.
- Install Hardhat.
- More on how to set up Hardhat and how to check whether your installation is ready in the [arbitrage_contract README](./arbitrage_contract/README.md).
- npm install dotenv.

- Add `INFURA_API_KEY` and `PRIVATE_KEY` secrets in arbitrage_contract/.env file.

### Rust Environment Setup

- Install the Cargo toolchain.
- Install the Rust Analyzer extension on VSCode.

### Integration

- Develop and test your Solidity contracts locally using Hardhat’s network or another local blockchain simulator.
- Configure your Rust client to interact with the local blockchain via Ethereum JSON-RPC (e.g., using Hardhat’s default RPC URL).
- Ensure that the two components communicate correctly by deploying the arbitrage contract and having the client submit test transactions.