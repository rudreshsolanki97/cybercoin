pragma solidity 0.4.24;

import "./IERC20.sol";
import "./Operator.sol";

import "./SafeERC20.sol";


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
