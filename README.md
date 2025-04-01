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

To develop and test the arbitrage smart contract, follow these steps:

1. **Install Node.js and npm**  
   Required for running Hardhat and project dependencies.

2. **Install VSCode Solidity Extensions**  
   Recommended: [solidity by Juan Blanco](https://marketplace.visualstudio.com/items?itemName=JuanBlanco.solidity) for syntax highlighting and IntelliSense.

3. **Install Hardhat**  
   Hardhat is the development environment used to compile, deploy, and test the Solidity contracts.

   ```bash
   npm install --save-dev hardhat
   ```

   For detailed setup and verification, see the [arbitrage_contract README](./arbitrage_contract/README.md).

4. **Install dotenv**  
   Used to manage environment secrets in development:

   ```bash
   npm install dotenv
   ```

5. **Configure environment secrets**  
   Create a `.env` file inside the `arbitrage_contract` directory containing:

   ```
   INFURA_API_KEY=your_infura_key_here
   ```

Ensure that these are set before attempting to deploy or test contracts.
