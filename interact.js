const ownership = artifacts.require("ownership");


module.exports = async function(callback) {
  try {
    // Deploy the contract
    const instance = await ownership.deployed();
    await instance.registerGun('12134')
    // const weapons = await instance.getGunsByOwner('0xD9189aFDA0D081591FDCBd92565e17fFaD083FEb');
    // const owner = await instance.getOwner('123456');
    // console.log(weapons)
    // console.log('the ownder is', owner)
    callback();
  } catch (error) {
    console.error("Error executing script:", error);
    callback(error);
  }
}
