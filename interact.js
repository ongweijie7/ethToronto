const ownership = artifacts.require("ownership");


module.exports = async function(callback) {
  try {
    // Deploy the contract
    const instance = await ownership.deployed();
    await instance.registerItem('1234568')
    const weapons = await instance.getGunsByOwner('0xD9189aFDA0D081591FDCBd92565e17fFaD083FEb');
    console.log(weapons)
    callback();
  } catch (error) {
    console.error("Error executing script:", error);
    callback(error);
  }
}
