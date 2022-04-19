// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC20Token.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * Vendor contract that implements possibility to exhange ETH for any ERC20
 * @author kchn9
 */
contract Vendor is Ownable {

    /// @notice Emitted whenever user buy tokens successfully
    event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
    /// @notice Emitted whenever user buy tokens successfully
    event SellTokens(address seller, uint256 amountofETH, uint256 amountOfTokens);

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
    /// @dev Emits BuyTokens(address, uint256, uint256) if successful
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

    /**
     * @notice Sells allowed[!] amount of token - user need to call ERC20.approve(spender, amount) before selling!
     * @param _tokenAmount Amount of tokens to sell
     */
    function sellToken(uint256 _tokenAmount) public {
        require(_tokenAmount > 0, "Vendor: Amount cannot be 0");

        uint256 tokenValue = _tokenAmount * 1 ether;
        uint256 ethValue = tokenValue / tokensPerEth;
        require(ethValue <= address(this).balance, "Vendor: contract has not enough funds");

        bool transferSuccess = token.transferFrom(msg.sender, address(this), tokenValue);
        require(transferSuccess, "Vendor: Token transfer failed");

        payable(msg.sender).transfer(ethValue);
        emit SellTokens(msg.sender, ethValue, tokenValue);
    }

    /// @notice Withdraws paid funds
    function withdraw() public onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}