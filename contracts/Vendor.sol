// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC20Token.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Vendor is Ownable {

    /// @notice 
    event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);

    /// @notice Amount of tokens user may buy for 1ETH, 1 ETH = 100 tokens - represented in 10^18 interger of 18 decimals
    uint256 constant public tokensPerEth = 100;

    /// @notice Token ABI representation
    ERC20Token token;

    /// @notice Setter for ERC20Token address secured by onlyOwner modifier
    /// @param _tokenAddress blockchain address of token
    function setTokenAddress(address _tokenAddress) external onlyOwner {
        token = ERC20Token(_tokenAddress);
    }

    /// @param _tokenAddress blockchain address of token
    constructor(address _tokenAddress) {
        token = ERC20Token(_tokenAddress);
    }

    /// @notice Buys tokens for fixed price
    function buyToken() payable public {
        require(msg.value >= 1 ether / tokensPerEth, "Vendor: msg.value - not sufficient funds"); 
        uint256 amountOfTokens_ = msg.value * tokensPerEth;
        bool success = token.transfer(msg.sender, amountOfTokens_);
        require(success, "Vendor: Token transfer failed");
        emit BuyTokens(msg.sender, msg.value, amountOfTokens_);
    }

    receive() payable external {
        buyToken();
    }

    /// @notice Withdraws paid funds
    function withdraw() public onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}