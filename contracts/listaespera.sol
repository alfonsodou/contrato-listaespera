// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import './tokenespera.sol';

contract ListaEspera {
    address     public  owner = 0xF55301514c27489Fde7C9cd9A3EA8044E7E04579;
    TokenEspera public  token;
    address[]   public  inscritos;
    bool        private bloqueado; // Semáforo para funciones críticas

    constructor(TokenEspera token_) {
        token = token_;
    }

    function inscribirse() external noReentrancy {
        require(msg.sender != owner, "El propietario no puede estar en la lista");
        require(!yaEstaInscrito(msg.sender), "Ya estas inscrito");


        inscritos.push(msg.sender);

        token.transfer(owner, 1);
    }

    function yaEstaInscrito(address _usuario) public view returns (bool) {
        require(_usuario != owner, "El propietario no puede estar en la lista");

        for(uint256 i = 0; i < inscritos.length; i++) {
            if (inscritos[i] == _usuario) {
                return true;
            }
        }

        return false;
    }

    function numeroEnLista(address _usuario) public view returns (bool, uint256) {
        require(_usuario != owner, "El propietario no puede estar en la lista");
        
        uint256 indice = 0;
        bool encontrado = false;
        for(uint256 i = 0; (i < inscritos.length) && (!encontrado); i++) {
            if (inscritos[i] == _usuario) {
                indice = i;
                encontrado = true;
                break;
            }
        }

        return (encontrado, indice);
    }

   function comprarToken() external {
        uint256 numeroTokens = token.balanceOf(msg.sender) + (10**18);

        token.mint(msg.sender, numeroTokens);
    }

    function transferForMember(address from, address to, uint256 amount) external returns (bool) {
        require(token.balanceOf(from) >= amount, "Saldo insuficiente");

        token.transferFrom(from, to, amount);

        return true;
    }

    function getBalance() view external returns (uint256) {
        return token.balanceOf(msg.sender);
    }

    // Modificador para prevenir ataques de reentrada
    modifier noReentrancy() {
        if (bloqueado) revert();
        bloqueado = true;
        _;
        bloqueado = false;
    }
}