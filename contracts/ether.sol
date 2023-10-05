// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

// Safe Math Library
library SafeMath {
    function safeAdd(uint a, uint b) internal pure returns (uint c) {
        c = a + b;
        require(c >= a, "SafeMath: Addition overflow");
    }
    function safeSub(uint a, uint b) internal pure returns (uint c) {
        require(b <= a, "SafeMath: Subtraction overflow");
        c = a - b;
    }
    function safeMul(uint a, uint b) internal pure returns (uint c) {
        if (a == 0) {
            return 0;
        }
        c = a * b;
        require(c / a == b, "SafeMath: Multiplication overflow");
    }
    function safeDiv(uint a, uint b) internal pure returns (uint c) {
        require(b > 0, "SafeMath: Division by zero");
        c = a / b;
    }
}

// ERC Token Standard #20 Interface
interface ERC20Interface {
    function totalSupply() external view returns (uint);
    function balanceOf(address tokenOwner) external view returns (uint balance);
    function allowance(address tokenOwner, address spender) external view returns (uint remaining);
    function transfer(address to, uint tokens) external returns (bool success);
    function approve(address spender, uint tokens) external returns (bool success);
    function transferFrom(address from, address to, uint tokens) external returns (bool success);
    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

// Contract function to receive approval and execute function in one call
interface ApproveAndCallFallBack {
    function receiveApproval(address from, uint256 tokens, address token, bytes calldata data) external;
}

// Actual token contract
contract NSFASToken is ERC20Interface {
    using SafeMath for uint;

    string public symbol = "NSFAS";
    string public name = "NSFAS Token";
    uint8 public decimals = 2;
    uint public _totalSupply;
    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;

    constructor() public {
    // Constructor logic here
    symbol = "NSFAS";
    name = "NSFAS Token";
    decimals = 2;
    _totalSupply = 100000;
    balances[0x4Fe9d2f546A5A4130Aa5B65244549147BF9f8f85] = _totalSupply;
    emit Transfer(address(0), 0x4Fe9d2f546A5A4130Aa5B65244549147BF9f8f85, _totalSupply);
}


    function totalSupply() public view  returns (uint) {
        return _totalSupply;
    }

    function balanceOf(address tokenOwner) public view returns (uint balance) {
        return balances[tokenOwner];
    }

    function transfer(address to, uint tokens) public returns (bool success) {
        require(to != address(0), "ERC20: Transfer to the zero address");
        balances[msg.sender] = balances[msg.sender].safeSub(tokens);
        balances[to] = balances[to].safeAdd(tokens);
        emit Transfer(msg.sender, to, tokens);
        return true;
    }

    function approve(address spender, uint tokens) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }

    function transferFrom(address from, address to, uint tokens) public returns (bool success) {
        require(to != address(0), "ERC20: Transfer to the zero address");
        balances[from] = balances[from].safeSub(tokens);
        allowed[from][msg.sender] = allowed[from][msg.sender].safeSub(tokens);
        balances[to] = balances[to].safeAdd(tokens);
        emit Transfer(from, to, tokens);
        return true;
    }

    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }

    function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
        approve(spender, tokens);
        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
        return true;
    }
}


