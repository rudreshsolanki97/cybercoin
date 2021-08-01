
/** 
 *  SourceUnit: /home/rudresh/Workspace/Fiverr/Tamer/cybercoin/smart-contracts/Logistics/contributor.sol
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
 *  SourceUnit: /home/rudresh/Workspace/Fiverr/Tamer/cybercoin/smart-contracts/Logistics/contributor.sol
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
 *  SourceUnit: /home/rudresh/Workspace/Fiverr/Tamer/cybercoin/smart-contracts/Logistics/contributor.sol
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
 *  SourceUnit: /home/rudresh/Workspace/Fiverr/Tamer/cybercoin/smart-contracts/Logistics/contributor.sol
*/

pragma solidity 0.4.24;

////import "./Operator.sol";
////import "./IERC20.sol";

contract Contributor is Operator {


  struct malware {
    address contributor;
    uint256 uploadDate;
    string ipfsHash;


    uint256 rewards;
    uint256 lastRewardAt;    
    uint256 totalRewards;
   
    bool status;
  }

  mapping (string=>malware) malwares;
  string[] public hashes;

  uint256 public ONE_DAY =  86400;
  uint256 public ONE_YEAR = ONE_DAY*365;

  IERC20 public token;

  event TokenDistributed(string ipfsHash,address contributor,  uint256 amount);
  event MalwareAdded(string ipfsHash, address contributor );
  event MalwareStatusUpdate(string ipfsHash, bool status);
  event MalwareRewardUpdate(string ipfsHash, uint256 amount);


  modifier malwareDoesNotExists(string _ipfsHash) {
    require(malwares[_ipfsHash].contributor==address(0), "contributor: malware already exists");
    _;
  }

  modifier malwareExists(string _ipfsHash) {
    require(malwares[_ipfsHash].contributor!=address(0), "contributor: malware does not exists");
    _;
  }

  constructor(IERC20 _token) public {
    token = _token;
  }

  function addMalware(address _contributor, string _ipfsHash, uint256 _uploadDate) malwareDoesNotExists(_ipfsHash) public onlyOperator {
    malwares[_ipfsHash].contributor = _contributor;
    malwares[_ipfsHash].uploadDate = _uploadDate;
    malwares[_ipfsHash].ipfsHash = _ipfsHash;


    malwares[_ipfsHash].rewards = 0;
    malwares[_ipfsHash].lastRewardAt = block.timestamp;    
    malwares[_ipfsHash].totalRewards = 0;

    malwares[_ipfsHash].status = false;

    hashes.push(_ipfsHash);

    emit MalwareAdded(_ipfsHash, _contributor);
  }

  function updateRewards(string _hash, uint256 _rewards) public onlyOperator {
    malwares[_hash].rewards = _rewards;
    emit MalwareRewardUpdate(_hash, _rewards);
  }

  function updateStatus(string _hash, bool _status) public onlyOperator {
    malwares[_hash].status = _status;
    emit MalwareStatusUpdate(_hash, _status);
  }

  function earned(string ipfsHash) public view returns(uint256) {
    if (malwares[ipfsHash].status!=true) {
      return 0;
    }
    uint256 dayCount = (block.timestamp - malwares[ipfsHash].lastRewardAt)/ONE_DAY;
    uint256 rewardPerDay = malwares[ipfsHash].rewards/365;
    return rewardPerDay*dayCount;
  }

  function hashCount() public view returns(uint256 count) {
      count=hashes.length;
  }

  function distributeRewards() public {
    for (uint256 i=0;i<hashes.length;i++) {
      string memory ipfsHash = hashes[i];
      uint256 earnings = earned(ipfsHash);
      if (malwares[ipfsHash].status==true && earnings > 0) {
        token.mint(malwares[ipfsHash].contributor, earnings);
        emit TokenDistributed(ipfsHash, malwares[ipfsHash].contributor, earnings);
      }
    }

  }

}
