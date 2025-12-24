// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Coin {

  //铸币人
  address public minter;
  //资产
  mapping(address => uint) public balances;

  // 轻量级轻客户端可以通过事件有效地针对变化来做出反应。
  event Sent(address from, address to, uint amount);

  constructor() {
    minter = msg.sender;
  }
  function mint(address receiver, uint amount) public {
    require(msg.sender == minter);
    balances[receiver] += amount;
  }


  function send(address receiver, uint amount) public {
    //判断交易的合法性
    require(amount > 0, "Amount must be greater than 0.");
    //判断当前账户余额是否足够
    require(amount <= balances[msg.sender], "Insufficient balance."); 
    balances[msg.sender] -= amount;
    balances[receiver]   += amount;
    emit Sent(msg.sender , receiver , amount);
  }
}
