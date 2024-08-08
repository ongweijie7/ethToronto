// import { artifacts } from "truffle";

const Ownership = artifacts.require("Ownership");

module.exports = function (deployer) {
  // Deploy the contract with an initial value of 100
  deployer.deploy(Ownership);
};
