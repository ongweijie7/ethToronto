// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2; //required to return string[]

contract Ownership {
  address public ownerAddress;
  struct Gun {
    string serialNumber;
    address owner; 
  }

  mapping(string => Gun) private serialNumToGun; //maps serial number to gun
  mapping(address => string[]) private addressToGuns; //maps address to guns

  event GunRegistered(string serialNumber, address indexed owner);
  event OwnershipTransferred(bytes32 indexed hashedSerial, address indexed oldOwner, address indexed newOwner);

  constructor() public {
    ownerAddress = msg.sender;
  }

  function registerGun(string memory serialNumber) public {
    require(bytes(serialNumToGun[serialNumber].serialNumber).length == 0, "Item already registered");

    serialNumToGun[serialNumber] = Gun(serialNumber, msg.sender);
    addressToGuns[msg.sender].push(serialNumber);

    emit GunRegistered(serialNumber, msg.sender);
  }

  function transferOwnership(string memory serialNumber, address newOwnerAddress) public {
    require(serialNumToGun[serialNumber].owner == msg.sender, "You are not the owner of this item");
    require(bytes(serialNumToGun[serialNumber].serialNumber).length != 0, "Item must be registered before transferring ownership");

    address oldOwnerAddress = serialNumToGun[serialNumber].owner;
    serialNumToGun[serialNumber].owner = newOwnerAddress;

    string[] storage oldOwnerGuns = addressToGuns[oldOwnerAddress]; //getting the array of guns owned by old owner
    string[] storage newOwnerGuns = addressToGuns[newOwnerAddress]; //getting the array of guns owned by new owner

    for (uint256 i = 0; i < oldOwnerGuns.length; i++) {
        if (keccak256(abi.encodePacked(oldOwnerGuns[i])) == keccak256(abi.encodePacked(serialNumber))) {
            oldOwnerGuns[i] = oldOwnerGuns[oldOwnerGuns.length - 1];
            oldOwnerGuns.pop();
            break;
        }
    }

    newOwnerGuns.push(serialNumber);
    bytes32 serialHashed = keccak256(abi.encodePacked(serialNumber));
    emit OwnershipTransferred(serialHashed, oldOwnerAddress, newOwnerAddress);
  }

  function getGunsByOwner(address owner) public view returns (string[] memory) {
    return addressToGuns[owner];
  }

  function getOwner(string memory serialNumber) public view returns (address) {
    return serialNumToGun[serialNumber].owner;
  }

  function getHashedSerialNum(string memory serial) public pure returns (bytes32) {
    return keccak256(abi.encodePacked(serial));
  }
}