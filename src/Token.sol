// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import 'lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol';

contract TokenA is ERC20 {
    constructor() ERC20("Kwagarelly Token", "KWAG") {
        _mint(msg.sender, 1000000 * 10 ** decimals());
    }
}

contract TokenB is ERC20 {
    constructor() ERC20("Blocklab Token", "BLT") {
        _mint(msg.sender, 1000000 * 10 ** decimals()); 
    }
}