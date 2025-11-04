// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TokenEspera is ERC20 {
    address public owner;
    uint256 public constant MAX_SUPPLY = 10000 * 10**18;

    constructor() ERC20("Token Espera", "ESP") {
        owner = msg.sender;
    }

    function changeOwner(address newOwner) external {
        require(msg.sender == owner, "Tienes que ser el propietario");
        require(newOwner != address(0), "Direccion invalida");

        owner = newOwner;
    }

    function transfer(address to, uint256 amount) public override returns (bool) {
        require(msg.sender == owner, "Solo el propietario puede transferir");
        return super.transfer(to, amount);
    }

     function transferFrom(address from, address to, uint256 amount) public override returns (bool) {
        require(msg.sender == owner, "Solo el propietario puede transferir");
        return super.transferFrom(from, to, amount);
    }

    function mint(address to,  uint256 amount) external {
        require(msg.sender == owner, "Solo el propietario puede mintear");
        require(totalSupply() + amount <= MAX_SUPPLY, "No se puede superar el maximo de suministro");

        _mint(to, amount);
    }
}