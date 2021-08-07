
/** 
 *  SourceUnit: /home/rudresh/Workspace/Fiverr/Tamer/cybercoin/smart-contracts/Logistics/consumer.sol
*/
            
pragma solidity ^0.4.24;

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable  {
    address public owner;

    event OwnershipRenounced(address indexed previousOwner);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
     * account.
     */
    constructor() public {
        owner = msg.sender;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    /**
     * @dev Allows the current owner to relinquish control of the contract.
     * @notice Renouncing to ownership will leave the contract without an owner.
     * It will not be possible to call the functions with the `onlyOwner`
     * modifier anymore.
     */
    function renounceOwnership() public onlyOwner {
        emit OwnershipRenounced(owner);
        owner = address(0);
    }

    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param _newOwner The address to transfer ownership to.
     */
    function transferOwnership(address _newOwner) public onlyOwner {
        _transferOwnership(_newOwner);
    }

    /**
     * @dev Transfers control of the contract to a newOwner.
     * @param _newOwner The address to transfer ownership to.
     */
    function _transferOwnership(address _newOwner) internal {
        require(_newOwner != address(0));
        emit OwnershipTransferred(owner, _newOwner);
        owner = _newOwner;
    }
}




/** 
 *  SourceUnit: /home/rudresh/Workspace/Fiverr/Tamer/cybercoin/smart-contracts/Logistics/consumer.sol
*/
            

/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure.
 * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
    function safeTransfer(
        IERC20 _token,
        address _to,
        uint256 _value
    ) internal {
        require(_token.transfer(_to, _value));
    }

    function safeTransferFrom(
        IERC20 _token,
        address _from,
        address _to,
        uint256 _value
    ) internal {
        require(_token.transferFrom(_from, _to, _value));
    }

    function safeApprove(
        IERC20 _token,
        address _spender,
        uint256 _value
    ) internal {
        require(_token.approve(_spender, _value));
    }
}



/** 
 *  SourceUnit: /home/rudresh/Workspace/Fiverr/Tamer/cybercoin/smart-contracts/Logistics/consumer.sol
*/
            
////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT

pragma solidity 0.4.24;

////import './Ownable.sol';

contract Operator is Ownable {
    address private _operator;

    event OperatorTransferred(address indexed previousOperator, address indexed newOperator);

    constructor() public {
        _operator = msg.sender;
        emit OperatorTransferred(address(0), _operator);
    }

    function operator() public view returns (address) {
        return _operator;
    }

    modifier onlyOperator() {
        require(_operator == msg.sender, 'operator: caller is not the operator');
        _;
    }

    function isOperator() public view returns (bool) {
        return msg.sender == _operator;
    }

    function transferOperator(address newOperator_) public onlyOwner {
        _transferOperator(newOperator_);
    }

    function _transferOperator(address newOperator_) internal {
        require(newOperator_ != address(0), 'operator: zero address given for new operator');
        emit OperatorTransferred(address(0), newOperator_);
        _operator = newOperator_;
    }
}




/** 
 *  SourceUnit: /home/rudresh/Workspace/Fiverr/Tamer/cybercoin/smart-contracts/Logistics/consumer.sol
*/
            
pragma solidity ^0.4.24;

/**
 * @title IERC20
 * @dev Interface to ERC20 token
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * ////IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    function mint(address to, uint256 amount) external;

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


/** 
 *  SourceUnit: /home/rudresh/Workspace/Fiverr/Tamer/cybercoin/smart-contracts/Logistics/consumer.sol
*/

pragma solidity 0.4.24;

////import "./IERC20.sol";
////import "./Operator.sol";

////import "./SafeERC20.sol";


contract Consumer is Operator {

  using SafeERC20 for IERC20;

  struct payment {
    uint256 lastPayment;
    uint256 totalAmount;
    uint256 lastAmount;
  }

  mapping (address=>mapping(string=>string)) consumer_subscription_analysis;
  mapping (address=>string[]) consumer_subscription;
  mapping (address => mapping(string => payment)) consumer_payment;
  mapping (string => uint256) hash_sub_count;

  string[] public registered_malware;
  uint256 public ONE_DAY =  86400;

  IERC20 token;
  uint256 public subCost = 1 ether;
  uint256 public subPeriod = 30;

  modifier requireMalwareRegistered(string ipfshash) {
    (bool found,) = getMalwareIndex(ipfshash);
    require(found, "malware not registered");
    _;
  }

  modifier requireMalwareNotRegistered(string ipfshash) {
    (bool found,) = getMalwareIndex(ipfshash);
    require(!found, "malware registered");
    _;
  }

  modifier requireNotSubscribed(string ipfshash) {
    (bool found,) = getSubIndex(msg.sender, ipfshash);
    require(!found, "already subscribed");
    _;
  }

  modifier requireSubscribed(string ipfshash) {
    (bool found,) = getSubIndex(msg.sender, ipfshash);
    require(found, "not subscribed");
    _;
  }
  
  modifier checkSubscription(string ipfshash) {
    (bool found, uint256 index) = getSubIndex(msg.sender, ipfshash);
    require(found, "not subscribed");
    require(consumer_payment[msg.sender][ipfshash].lastPayment+ONE_DAY*subPeriod>block.timestamp, "expired");
      _;
  }

  function checkAndUpdateSubscription(string ipfshash) public {
    (bool found, uint256 index) = getSubIndex(msg.sender, ipfshash);
    if (!found) return;
    if (consumer_payment[msg.sender][ipfshash].lastPayment+ONE_DAY*subPeriod<block.timestamp) {
      delete consumer_subscription_analysis[msg.sender][ipfshash];
      consumer_subscription[msg.sender][index] = consumer_subscription[msg.sender][consumer_subscription[msg.sender].length-1];
      delete consumer_subscription[msg.sender][consumer_subscription[msg.sender].length-1];
      consumer_subscription[msg.sender].length--;
    }
    
  }

  constructor(IERC20 _token) public {
    token = _token;
  }

  function subscribe(string ipfsHash) public {
    (bool found,) = getMalwareIndex(ipfsHash);
    require(found, "malware doesnt exists");
    token.safeTransferFrom(msg.sender, address(this) ,subCost);
    
    consumer_payment[msg.sender][ipfsHash].lastPayment = block.timestamp;
    consumer_payment[msg.sender][ipfsHash].lastAmount = subCost;

    if (consumer_payment[msg.sender][ipfsHash].lastPayment>0) {
      consumer_payment[msg.sender][ipfsHash].totalAmount += subCost;
    }
    
    consumer_subscription[msg.sender].push(ipfsHash);
  }

  function getMalwareIndex(string malware) public view returns(bool,uint256) {
    for (uint256 i=0;i<registered_malware.length;i++) {
      if (compareStrings(registered_malware[i],malware)) {
        return (true, i);
      }
    }
    return (false, 0);
  }

  function getSubIndex(address consumer, string ipfshash) public view returns(bool,uint256) {
    for (uint256 i=0;i<consumer_subscription[consumer].length;i++) {
      if (compareStrings(consumer_subscription[consumer][i],ipfshash)) {
        return (true, i);
      }
    }
    return (false, 0);
  }

  function access(string ipfsHash) checkSubscription(ipfsHash) requireSubscribed(ipfsHash) public view returns(string) {
    return consumer_subscription_analysis[msg.sender][ipfsHash];
  }

  function compareStrings(string memory a, string memory b) public pure returns (bool) {
    return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
  }

  // operator

  function addAnalysis(address consumer, string ipfsHash, string analysis) public {
    consumer_subscription_analysis[consumer][ipfsHash] = analysis;
  }

  function registerMalware(string ipfsHash) requireMalwareNotRegistered(ipfsHash) public {
    registered_malware.push(ipfsHash);
  }

  // owner

  function setSubCost(uint256 newCost) public onlyOwner {
    subCost = newCost;
  }
  
  function withdrawTokens(address beneficiary_, uint256 amount_) public onlyOwner {
      require(amount_ > 0, 'token amount has to be greater than 0');
      token.safeTransfer(beneficiary_, amount_);
      
  }

  function withdrawXdc(address beneficiary_, uint256 amount_) public onlyOwner {
      require(amount_ > 0, 'xdc amount has to be greater than 0');
      beneficiary_.transfer(amount_);
  }
  
  function setSubPeriod(uint256 newPeriod) public onlyOwner {
    subPeriod = newPeriod;
  }
  
}

