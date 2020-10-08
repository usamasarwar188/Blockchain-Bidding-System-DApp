pragma solidity >=0.4.21 <0.6.0;




// contract Product{

// }


contract BiddingStorage {


struct User{
    string name;
    string pass;
    bool isSet;


}



struct Bid{
    uint256  bidId;
    address  bidUserAddress;
    uint256  bidAmount;
}

struct Product{
    uint256  id;
    string  name;
    string  specs;
    bool  onBid;
    uint256  minBid;
    //Bid[]  bidlist;
    mapping  (uint256 => Bid) bids;
    uint256 n_bid;
    uint256  maxBid;

}




    // string[] public choices;
    // mapping(address => string) public votes;
    // mapping(address => string) public allowedAddresses;
    // mapping(string => uint256) public voteChoices;

    // address[] public voters;
    // uint256 public n_choices;
    // uint256 public n_voters;
    // uint256 public choiceThresh;
    // address payable public owner;
    // uint256 public voteCount;
    // uint256 public voteThresh;
    // uint256 public maxVotes;
    // uint256 public winningChoice;

    mapping(address => User) public users;
    Product[] public products;

    mapping  (uint256 => Product ) public productMap;
    uint256 public n_prods;
    mapping  (uint256 => address) public prodOwners;
    //mapping(uint256 => Bid)
    mapping  (address => Product[]) public userProds;
    mapping  (address => mapping(uint256 => Product)) public userAllProds;
    constructor() public {
        // owner = msg.sender;
        // // choiceThresh = _choiceThresh;
        // // voteThresh = _voteThresh;
        // voteCount = 0;
        // n_choices = 0;
        // n_voters = 0;
        // maxVotes = 0;
        n_prods = 0;
    }



    function acceptBid(uint256 prodId,uint256 bidId)public {
        Product storage prod = userAllProds[msg.sender][prodId];
        address bidderAddr = prod.bids[bidId].bidUserAddress;

        prodOwners[prodId] = bidderAddr;
        userAllProds[bidderAddr][prodId] = prod;
        delete userAllProds[msg.sender][prodId];
    }

    function addProduct(string memory name, string memory specs)public{
        Product memory prod;
        prod.id = n_prods;
        prod.name = name;
        prod.specs = specs;
        prod.n_bid = 0;
        prod.onBid = false;

        productMap[prod.id] = prod;

        products.push(prod);

        prodOwners[prod.id] = msg.sender;

        userProds[msg.sender].push(prod);

        userAllProds[msg.sender][prod.id] = prod;
        n_prods += 1;
    }


    function setProdForBid(uint256 prodId, uint256 minBid)public{
        for (uint i = 0; i < userProds[msg.sender].length ; i++){
            if (prodId == userProds[msg.sender][i].id){
                userProds[msg.sender][i].onBid = true;
                userProds[msg.sender][i].minBid = minBid;
                break;

            }
        }

        userAllProds[msg.sender][prodId].onBid = true;
        userAllProds[msg.sender][prodId].minBid = minBid;

    }


    function addMyBid(uint256 prodId, uint256 amount)public{
        Bid memory bid;
        bid.bidId = 1;
        bid.bidUserAddress = msg.sender;
        bid.bidAmount = amount;

        address  prOwner = prodOwners[prodId];

        if (amount>userAllProds[prOwner][prodId].minBid){
            uint256 n = userAllProds[prOwner][prodId].n_bid;

            userAllProds[prOwner][prodId].bids[n] = bid;
            // userAllProds[prOwner][prodId].bidlist.push(bid);

            if (amount > userAllProds[prOwner][prodId].maxBid){
                userAllProds[prOwner][prodId].maxBid = amount;
            }

            userAllProds[prOwner][prodId].n_bid += 1;
        }
    }

    function getBid(uint256 prodId, uint bidId)public view returns (uint256){
        Product storage prod = userAllProds[msg.sender][prodId];
        return prod.bids[bidId].bidAmount;
    }

    //function acceptBid()



}