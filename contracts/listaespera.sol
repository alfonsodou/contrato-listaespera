// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import './tokenespera.sol';

contract ListaEspera {
    address     public  owner = 0xF55301514c27489Fde7C9cd9A3EA8044E7E04579;
    TokenEspera public  token;
    address[]   public  inscritos;
    bool        private bloqueado; // Semáforo para funciones críticas
    uint256     public constant COST_REGISTER = 10**18;    

    constructor(TokenEspera token_) {
        token = token_;
    }

    function inscribirse() external {
        require(!yaEstaInscrito(msg.sender), "Ya estas inscrito");
        require(token.balanceOf(msg.sender) > COST_REGISTER, "Saldo insuficiente");

        inscritos.push(msg.sender);

        bool result = token.transferFrom(msg.sender, owner, COST_REGISTER);
        require(result, "Error al realizar la transferencia");
    }

    function yaEstaInscrito(address _usuario) public view returns (bool) {
        for(uint256 i = 0; i < inscritos.length; i++) {
            if (inscritos[i] == _usuario) {
                return true;
            }
        }

        return false;
    }

    function numeroEnLista() public view returns (uint256) {     
        uint256 indice = 0;
        bool encontrado = false;
        for(uint256 i = 0; (i < inscritos.length) && (!encontrado); i++) {
            if (inscritos[i] == msg.sender) {
                indice = i;
                encontrado = true;
                break;
            }
        }

        if (!encontrado) {
            return 0;
        } else {
            return indice + 1;
        }
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

    function retirarUsuario() external {
        
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