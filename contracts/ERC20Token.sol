// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * Example of ERC20 Token
 * @author kchn9
 */
contract ERC20Token is ERC20 {
    constructor(
        string memory _name, 
        string memory _symbol, 
        uint256 _tokenAmount
    ) ERC20(_name, _symbol) {
        _mint(msg.sender, _tokenAmount * (10 ** 18));
    }
}