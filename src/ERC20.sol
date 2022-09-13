//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ERC20 {

    mapping(address => uint256) private balances;
    mapping(address => mapping(address => uint256)) private allowances;
    uint256 private _totalSupply;

    string private _name;
    string private _symbol;
    uint8 private _decimal;

    constructor () {
        _name = "DREAM";
        _symbol = "DRM";
        _decimal = 18;
        _totalSupply = 100 ether;
        balances[msg.sender] = 100 ether;
    }

    function name() public view returns (string memory) {
        return _name;
    }


    function symbol() public view returns (string memory) {
        return _symbol;
    }


    function decimals() public view returns (uint8) {
        return _decimal;
    }


    function totalSupply() public view returns (uint256){
        return _totalSupply;
    }


    function balanceOf(address _owner) public view returns (uint256){
        return balances[_owner];
    }


    function transfer(address _to, uint256 _value) external returns (bool success){
        require(msg.sender != address(0), "transfer from the zero address");
        require(_to != address(0), "transfer to the zero address");
        require(balances[msg.sender] >= _value, "value exceeds balance");

        unchecked {
            balances[msg.sender] -= _value;
            balances[_to] += _value;
        }

        emit Transfer(msg.sender, _to, _value);
    }


    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success) {
        require(msg.sender != address(0), "transfer from the zero address");
        require(_from != address(0), "transfer from the zero address");
        require(_to != address(0), "transfer to the zero address");
        
        uint256 currentAllowance = allowance(_from, msg.sender);
        require(currentAllowance >= _value, "insufficient allowance");

        unchecked {
            allowances[_from][msg.sender] -= _value;
            //allowances[msg.sender][_from] -= _value;
        }

        require(balances[_from] >= _value, "value exceeds balance");

        unchecked {
            balances[_from] -= _value;
            balances[_to] += _value;
        }

        emit Transfer(_from, _to, _value);
    }
    

    function approve(address _to, uint256 _value) public returns (bool success) {
        // to에게 value 만큼 인출 허용
        allowances[msg.sender][_to] = _value;
    }

    function allowance(address _owner, address _to) public view returns (uint256) {
        // [state] allowances 사용
        // to가 인출 허용받은 토큰량 반환

        return allowances[_owner][_to];

    }

    function _mint(address _owner, uint256 _value) internal returns (bool success) {
        require(_owner != address(0));
        
        _totalSupply += _value;
        balances[_owner] += _value;

        emit Transfer(address(0), _owner, _value);
    }

    function _burn(address _owner, uint _value) internal returns (bool success) {
        require(_owner != address(0));

        _totalSupply -= _value;
        balances[_owner] -= _value;

        emit Transfer(_owner, address(0), _value);
    }

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}
