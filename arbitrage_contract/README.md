# Arbitrage Contract (`ArbitrageContract.sol`)

## Arbitrage Requests

To save on gas costs, we encode arbitrage instructions provided by the operator into a compact bytes payload called an "Arbitrage Request", which is provided to ArbitrageContract's arbitrage method in a `bytes calldata` argument and carried through subsequent flash swap callbacks (i.e., `uniswapV2Call` and `uniswapV3FlashCallback`).

### Encoding Format

|Field|Offset|Length (bytes)|Description|
|---|---|---|---|
|Input Amount|0|16|The exact amount of WETH to "input" into the first swap (uint128, big endian). The expected output must be computed using pool reserves.|
|Minimum Profit|16|16|Minimum required profit in WETH (uint128, big endian).|
|Hop(s)|32|N×21|A list of encoded hops, one per swap in the arbitrage path. N must be an even number.|

#### Hop Format (21 bytes per hop)

Each hop is encoded as:
- **1 byte (flags):**
  - Bit 7 (MSB): `isV3` (1 if Uniswap V3, 0 if Uniswap V2)
  - Bit 6: `direction` (1 if selling token1, 0 if selling token0)
  - Bits 0–5: unused
- **20 bytes:** `pool` address to execute the swap against.

### Decoder (`ArbitrageRequestDecoder.sol`)

The utility functions defined in the ArbitrageRequestDecoder library help with incrementally decoding ArbitrageRequests. Incremental decoding further reduces the gas costs of calling ArbitrageContract by minimizing the number of bytes that need to be decoded from an ArbitrageRequest to only what is absolutely necessary in the logic of the currently executing function. The breakdown of what information each external function in ArbitrageContract needs out of an ArbitrageRequest is as follows:
- `arbitrage`: Input Amount (to initiate the first swap), Hop[0] (to determine the first pool and direction), and Hop[1] (to forward tokens directly to the next pool).
- `uniswapV2Call` & `uniswapV3FlashCallback`: Minimum Required Profit (to assert arbitrage success), Hop[0] (to repay the initial flash loan), Hop[1..N] (to execute the remaining arbitrage path).
