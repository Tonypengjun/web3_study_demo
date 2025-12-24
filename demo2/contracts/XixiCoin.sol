// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
// 标准ERC20代币
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// 如果需要铸造功能
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract XixiCoin is ERC20, ERC20Burnable, Ownable {
    constructor(uint256 initialSupply) 
    ERC20("XixiCoin", "XIC")
    Ownable(msg.sender)  {
        _mint(msg.sender, initialSupply * 10 ** decimals());
    }
    
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}
