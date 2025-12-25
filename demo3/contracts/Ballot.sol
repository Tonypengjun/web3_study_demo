// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title 委托投票
 * @author 
 * @notice 
 */
contract Ballot {

  //选民结构体
  struct Voter {
    uint256 weight; // 权重
    bool voted;     // 是否已投票
    address delegate; // 委托人
    uint256 vote;   // 投票的提案ID
  }

  //提案结构体
  struct Proposal {
    string name;   // 提案名称
    uint256 voteCount; // 得票数
  }

  address public chairperson; // 主席地址

  mapping(address => Voter) public voters; // 选民映射
  Proposal[] public proposals; // 提案数组

  constructor(string[] memory _proposals) {
    chairperson = msg.sender; // 设置主席为合约部署者
    voters[chairperson].weight = 1; // 主席权重为1

    // 初始化提案
    for (uint256 i = 0; i < _proposals.length; i++) {
      proposals.push(Proposal({name: _proposals[i], voteCount: 0}));
    }
    // proposals.push(Proposal({name: "Proposal 2", voteCount: 0}));
    // proposals.push(Proposal({name: "Proposal 3", voteCount: 0}));
  }

   //只有主席才能赋予选民投票权
  function giveRightToVote(address voter) public {
    require(
      msg.sender == chairperson,
      "Only chairperson can give right to vote."
    );
    require(
      !voters[voter].voted,
      "The voter already voted."
    );
    require(voters[voter].weight == 0);
    voters[voter].weight = 1;
  }

  //授权 to 地址的选民代表自己投票
  function delegate(address to) public {
    Voter storage sender = voters[msg.sender]; // 获取委托人
    require(!sender.voted, "You already voted.");   // 已投票不能再委托       
    require(to != msg.sender, "Self-delegation is disallowed."); // 不能自我委托
    // 查找最终的委托人
    while (voters[to].delegate != address(0)) {
      to = voters[to].delegate;
      // 防止循环委托
      require(to != msg.sender, "Found loop in delegation.");   
    }
    sender.voted = true;
    sender.delegate = to;
    Voter storage delegate_ = voters[to];
    if (delegate_.voted) {
      // 如果最终委托人已投票，直接增加其提案的票数
      proposals[delegate_.vote].voteCount += sender.weight;
    } else {
      // 如果最终委托人未投票，增加其权重
      delegate_.weight += sender.weight;
    }
  }

  //投票给指定提案
  function vote (uint256 proposal) public {
    Voter storage sender = voters[msg.sender];
    require(sender.weight != 0, "Has no right to vote.");
    require(!sender.voted, "Already voted.");
    sender.voted = true;
    sender.vote = proposal;
    proposals[proposal].voteCount += sender.weight;   
  }

  //计算获胜提案的ID
  function winningProposal() public view returns (uint256 winningProposal_) {
    uint256 winningVoteCount = 0;
    for (uint256 p = 0; p < proposals.length; p++) {
      if (proposals[p].voteCount > winningVoteCount) {
        winningVoteCount = proposals[p].voteCount;
        winningProposal_ = p;
      }
    }
    return winningProposal_;
  }

   //获取获胜提案的名称
  function winnerName() public view returns (string memory winnerName_) {
    winnerName_ = proposals[winningProposal()].name;    
    return winnerName_;
  }

}
