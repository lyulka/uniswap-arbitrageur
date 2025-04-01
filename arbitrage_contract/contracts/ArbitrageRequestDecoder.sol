// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title A lightweight decoder for the "ArbitrageRequest" format.
library ArbitrageRequestDecoder {
    struct Hop {
        bool isV3;
        bool direction;
        address pool;
    }

    /// @notice Decode the initial input amount from the arbitrage request.
    /// @param data The full arbitrage request calldata.
    /// @return inputAmount The amount of WETH to flash loan in the first hop.
    function decodeInputAmount(bytes calldata data)
        internal
        pure
        returns (uint128 inputAmount)
    {
        inputAmount = uint128(bytes16(data[0:MIN_PROFIT_OFFSET]));
    }

    /// @notice Decode the minimum acceptable profit from the arbitrage request.
    /// @param data The full arbitrage request calldata.
    /// @return minProfit The minimum acceptable WETH profit to avoid reverting.
    function decodeMinProfit(bytes calldata data)
        internal
        pure
        returns (uint128 minProfit)
    {
        minProfit = uint128(bytes16(data[MIN_PROFIT_OFFSET:HEADER_LENGTH]));
    }

    /// @notice Decode a specific hop in the arbitrage path.
    /// @param data The full arbitrage request calldata.
    /// @param hopIndex The index of the hop to decode (0-based).
    /// @return hop A struct containing hop type (v2/v3), direction, and pool address.
    function decodeHop(bytes calldata data, uint256 hopIndex)
        internal
        pure
        returns (Hop memory hop)
    {
        uint256 offset = HEADER_LENGTH + hopIndex * HOP_LENGTH;
        uint8 flags = uint8(data[offset]);
        hop.isV3 = (flags & IS_V3_MASK) != 0;
        hop.direction = (flags & DIRECTION_MASK) != 0;
        hop.pool = address(bytes20(data[offset + 1:offset + HOP_LENGTH]));
    }

    /// @notice Return the number of hops in the arbitrage path.
    /// @param data The full arbitrage request calldata.
    /// @return The number of 21-byte hops found in the data.
    function countHops(bytes calldata data) internal pure returns (uint256) {
        return (data.length - HEADER_LENGTH) / HOP_LENGTH;
    }

    /// Length of the fixed-size Input Amount + Min Profit "header" of an ArbitrageRequest.
    uint256 internal constant HEADER_LENGTH = 32;

    /// Offset of the minProfit field within the ArbitrageRequest header.
    uint256 internal constant MIN_PROFIT_OFFSET = 16;

    /// Length of a Hop.
    uint256 internal constant HOP_LENGTH = 21;
    
    /// Bitmask for extracting the "isV3" flag (MSB of the flags byte).
    uint8 internal constant IS_V3_MASK = 0x80;

    /// Bitmask for extracting the "direction" flag (second MSB of the flags byte).
    uint8 internal constant DIRECTION_MASK = 0x40;
}