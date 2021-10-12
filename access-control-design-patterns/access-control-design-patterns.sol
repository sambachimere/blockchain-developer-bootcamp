pragma solidity ^0.5.0;

contract C1 {
  uint private internalNum;
}

contract C2 {
  constructor() payable public {
    owner = msg.sender;
  }

  modifier onlyOwner() {
    require(msg.sender == owner, "Not authorized.");
    _;
  }

  function withdraw(uint _amount) onlyOwner public {
    owner.transfer(_amount);
  }
}

contract C3 {
  enum Stages = { Deposits, Withdraws }
  Stages stage = Stages.Deposits;
  mapping(address => uint) balances;
  uint creationTime = now;

  function deposit() payable public {
    require(stage == Stages.Deposits && msg.value > 0);
    balances[msg.sender] += msg.value;
  }

  function withdraw() public {
    if(stage != Stages.Withdraws && now >= creationTime + 30 days) {
      stage = Stages.Withdraws;
    }
    require(stage == Stages.Withdraws && balances[msg.sender] > 0);
    uint amount = balances[msg.sender];
    balances[msg.sender] = 0;
    msg.sender.transfer(amount);
  } 
}

contract CircuitBreaker {
    bool public stopped = false;

    modifier stopInEmergency { require(!stopped); _; } 
    modifier onlyInEmergency { require(stopped); _; }

    function deposit() stopInEmergency public { ... }
    function withdraw() onlyInEmergency public { ... }
}

contract C4 {
    bool isStopped = false;
    address owner;
    constructor() payable public {
            owner = msg.sender;
    }

    function stopContract() public {
            require(msg.sender == owner);
            isStopped = true;
    }

    function resumeContract() public {
            require(msg.sender == owner)
            isStopped = false;
    }

    function emergencyWithdraw() public {
            require(msg.sender == owner && isStopped);
            owner.transfer(this.balance);
    }
}























