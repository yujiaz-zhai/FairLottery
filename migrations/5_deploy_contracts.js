const ShuangSeQiu = artifacts.require("ShuangSeQiu");

module.exports = function(deployer) {
  deployer.deploy(ShuangSeQiu, 0 ,0, 0, 0);
};
