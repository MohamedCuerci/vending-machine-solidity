let BeerVending = artifacts.require("BeerVending")

module.exports = function(deployer) {
    deployer.deploy(BeerVending);
}
