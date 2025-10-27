// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TokenEspera is ERC20 {
    constructor() ERC20("Token Espera", "ESP") {

    }

    function comprarToken() external {
        uint256 numeroTokens = balanceOf(msg.sender) + 1;

        _mint(msg.sender, numeroTokens * 10**18);
    }

    function transfer(address, uint256) public pure override returns (bool) {
        revert("Usa transferForMember");
    }

     function transferFrom(address, address, uint256) public pure override returns (bool) {
        revert("Usa transferForMember");
    }
   
}