pragma solidity ^0.4.15;
import "./itMaps.sol";
/**
 * The ERC20 contract does this and that...
 */
contract ERC20 {
	
	using itMaps for itMaps.itMapAddressUint;
	
	itMaps.itMapAddressUint tokensBalances;

	mapping (address => mapping (address => uint256)) allowed; /*??*/
	
	
	uint8 public constant decimals = 4;
	uint256 public totalSupply = 1000000;
	string public constant symbol = "Iterable";

	address public firstOwner;
	address public secondOwner;
	uint256 public balanceFirstOwner;
	uint256 public balanceSecondOwner;


	event Burn(address indexed from,uint256 value);
	event Approval(address indexed owner, address indexed spender, uint256 value);
	event Transfer(address indexed from, address indexed to, uint256 value);

	function ERC20 () {	
		firstOwner = msg.sender;
		secondOwner = 0xa2AE05Ebea4359ad1884d559844E9fb80A6b3931;

		balanceFirstOwner = totalSupply/4;
		balanceSecondOwner = totalSupply - balanceFirstOwner;

		tokensBalances.insert(firstOwner,balanceFirstOwner);
		tokensBalances.insert(secondOwner,balanceSecondOwner);
	}	
	function balanceOfTokens(address _addressOwner) constant returns(uint256 _balances){	
		_balances = tokensBalances.get(_addressOwner);
		return _balances;
	}
	function transferToken(address _to, uint256 _amount) returns(bool success){
		if((tokensBalances.get(msg.sender) >= _amount)&&(_amount >0)){
			tokensBalances.insert(_to, tokensBalances.get(_to) + _amount);
			tokensBalances.insert(msg.sender,(tokensBalances.get(msg.sender) - _amount));
			Transfer(msg.sender, _to, _amount);
			return true;
		}		
		else{
			return false;
		}
	}
	function approveToken(address _spender, uint256 _amount) returns(bool success) {
		allowed[msg.sender][_spender] = _amount;
		Approval(msg.sender, _spender,_amount);
		return true;
	}
	function transferFromToken(address _from, address _to, uint256 _amount) returns(bool success) {
		if((tokensBalances.get(_from) >= _amount) && 
			(allowed[_from][msg.sender] >= _amount) && 
			(_amount >0)){
				tokensBalances.insert(_from, tokensBalances.get(_from)-_amount);
				allowed[_from][msg.sender]-=_amount;
				tokensBalances.insert(_to, tokensBalances.get(_to)+_amount);
				Transfer(_from,_to,_amount);
				return true;
		}
		else{
			return false;
		}
	}
	function allowance(address _owner, address _spender)constant returns(uint256 balance) {
		return allowed[_owner][_spender];
	}
	function burn(uint256 _value) returns(bool success) {
		if(tokensBalances.get(msg.sender) >= _value){
			tokensBalances.insert(msg.sender, tokensBalances.get(msg.sender)-_value);
			totalSupply -=_value;
			Burn(msg.sender,_value);
			return true;
		}
		else{
			return false;
		}
	}
	function burnFrom (address _owner, uint256 _value) returns(bool success) {
		if((tokensBalances.get(_owner) >= _value) && (allowed[_owner][msg.sender] >= _value)){
			tokensBalances.insert(_owner,tokensBalances.get(_owner)-_value);
			allowed[_owner][msg.sender] -=_value;
			totalSupply -= _value;
			Burn(_owner,_value);
			return true;
		}
		else{
			return false;
		}
	}
	
}