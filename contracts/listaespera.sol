// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import './tokenespera.sol';

contract ListaEspera {
    address public  owner = 0xF55301514c27489Fde7C9cd9A3EA8044E7E04579;
    TokenEspera public token;

    mapping (address => uint256) usuarios;

    constructor(TokenEspera token_) {
        token = token_;
    }
}