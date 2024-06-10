const DAI = artifacts.require("DAI");
const ARB = artifacts.require("ARB");
const LiquidityProvider = artifacts.require("LiquidityProvider");

module.exports = async function (deployer) {
  await deployer.deploy(DAI);
  await deployer.deploy(ARB);

  const daiInstance = await DAI.deployed();
  const arbInstance = await ARB.deployed();

  await deployer.deploy(
    LiquidityProvider,
    "UNISWAP_V3_POSITION_MANAGER_ADDRESS", // Replace with actual Uniswap V3 Position Manager address
    daiInstance.address,
    arbInstance.address
  );
};
