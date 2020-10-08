const BiddingStorage= artifacts.require("BiddingStorage");

module.exports = function(deployer) {
  deployer.deploy(BiddingStorage);
};
