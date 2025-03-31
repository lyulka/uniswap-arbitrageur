// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ArbitrageContract {
    string public message;

    constructor() {
        message = "Hello, World!";
    }

    function hello() external view returns (string memory) {
        return message;
    }
}