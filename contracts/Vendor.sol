// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC20Token.sol"; // ABI
import "@openzeppelin/contracts/access/Ownable.sol";

contract Vendor is Ownable {

    ERC20Token token;
    function setTokenAddress(address _tokenAddress) external onlyOwner {
        token = ERC20Token(_tokenAddress);
    }

    /// @notice Amount of tokens user may buy for 1ETH, 1 ETH = 100 tokens - represented in 10^18 interger of 18 decimals
    uint256 constant public tokensPerEth = 100;

    /// @notice Buys 
    function buyToken() payable public {
        require(msg.value >= 1 ether / tokensPerEth, "Vendor: msg.value - not sufficient funds"); 
        uint256 amountOfTokens_ = msg.value * tokensPerEth;
        token.transfer(msg.sender, amountOfTokens_);
    }
}