pragma solidity 0.4.24;

import "./Operator.sol";
import "./SafeERC20.sol";
import "./IERC20.sol";



contract Contributor is Operator {

  using SafeERC20 for IERC20;

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