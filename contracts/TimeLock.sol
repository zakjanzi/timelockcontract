
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';

contract Timelock {
  uint public constant duration = 365 days; //duration of the time lock
  uint public immutable end; //the end date that will be computed upon deploying of contract
  address payable public immutable owner; //owner's address


//the constructor is the function that will be called when we deploy the contract
  constructor(address payable _owner) { //the owner that will receive the funds
    end = block.timestamp + duration; //time of current block + the duration we hardcoded before
    owner = _owner; //initializing the owner variable
  }


// a function that deposits erc20 token (specifying the address and the amount)
  function deposit(address token, uint amount) external {
    IERC20(token).transferFrom(msg.sender, address(this), amount); //a pointer to the erc20 smart contract.
  }

  //The transferFrom() function used above transfers the tokens from an owner's account to the receiver account, 
  //but only if the transaction initiator has sufficient allowance that has been previously approved by the owner to the transaction initiator.

  receive() external payable {} //a receive function to receive ether


//the function to withdraw the crypto after the end of the time lock (specifiying the address and the amount)
  function withdraw(address token, uint amount) external {
    //a couple of sanity checks first
    require(msg.sender == owner, 'only owner');
    require(block.timestamp >= end, 'too early');

    if(token == address(0)) { 
      owner.transfer(amount);
    } else {
      IERC20(token).transfer(owner, amount);
    }
  }
}