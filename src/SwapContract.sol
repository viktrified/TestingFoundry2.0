// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "./lib/Errors.sol";

contract SwapContract {
    address public owner;
    address public tokenKWAG;
    address public tokenBLT;

    struct Swapper {
        bool hasSwaped;
        uint numberOfSwaps;
    }

    mapping(address => Swapper) swappers;

    constructor(address _tokenKWAG, address _tokenBLT) {
        tokenKWAG = _tokenKWAG;
        tokenBLT = _tokenBLT;
        owner = msg.sender;
    }

    function swapToken(uint _amount, address _token) external {
        if (_token != tokenKWAG && _token != tokenBLT)
            revert Errors.InvalidToken();
        if (IERC20(_token).balanceOf(msg.sender) <= _amount)
            revert Errors.InsufficientBalance();

        IERC20(_token).transferFrom(msg.sender, address(this), _amount);

        if (_token == tokenKWAG) {
            if (IERC20(tokenBLT).balanceOf(address(this)) < _amount * 3)
                revert Errors.InsufficientBLT();
            IERC20(tokenBLT).transfer(msg.sender, _amount * 3);
        } else {
            if (IERC20(tokenKWAG).balanceOf(address(this)) < _amount * 2)
                revert Errors.InsufficientKWAG();
            IERC20(tokenKWAG).transfer(msg.sender, _amount * 2);
        }

        swappers[msg.sender].hasSwaped = true;
        swappers[msg.sender].numberOfSwaps++;
    }

    function getSwapper(
        address _user
    ) external view returns (bool hasSwaped, uint256 numberOfSwaps) {
        Swapper memory swapper = swappers[_user];
        return (swapper.hasSwaped, swapper.numberOfSwaps);
    }
}
