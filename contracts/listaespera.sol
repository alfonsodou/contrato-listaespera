// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import './tokenespera.sol';

contract ListaEspera {
    address     public  owner = 0xF55301514c27489Fde7C9cd9A3EA8044E7E04579;
    TokenEspera public  token;
    address[]   public  inscritos;
    bool        private bloqueado; // Semáforo para funciones críticas
    uint256     public constant COST_REGISTER = 10**18;    
    uint256     public constant COST_UNREGISTER = COST_REGISTER / 2;    

    // Eventos personalizados
    event ComprarToken(address user, uint256 amount);
    event Registrar(address user, uint256 position);
    event UnregisterAdmin(address user);
    event Unregister(address user, uint256 amount);

    /**
     * @notice Crea la lista de espera
     * @param token_ Token ERC20
     */
    constructor(TokenEspera token_) {
        token = token_;
    }

    /**
    * @notice Inscribirse en la lista de espera
    */
    function inscribirse() external {
        // Checks
        require(!yaEstaInscrito(msg.sender), "Ya estas inscrito");
        require(token.balanceOf(msg.sender) >= COST_REGISTER, "Saldo insuficiente");

        // Efects
        inscritos.push(msg.sender);

        // Interactions
        bool result = token.transferFrom(msg.sender, owner, COST_REGISTER);
        require(result, "Error al realizar la transferencia");

        emit Registrar(msg.sender, inscritos.length);
    }

    /** 
    * @notice Comprobación si ya está inscrito
    * @param _usuario Dirección del usuario a comprobar
    */
    function yaEstaInscrito(address _usuario) public view returns (bool) {
        for(uint256 i = 0; i < inscritos.length; i++) {
            if (inscritos[i] == _usuario) {
                return true;
            }
        }

        return false;
    }

    /*
    * @notice Obtener posición en la lista
    */
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

    /*
    * @notice Comprar Token
    */
   function comprarToken() external {
        // Checks
        uint256 numeroTokens = token.balanceOf(msg.sender) + (10**18);

        // Effects

        // Interactions
        token.mint(msg.sender, numeroTokens);

        emit ComprarToken(msg.sender, numeroTokens);
    }

    /*
    * @notice Transferencia de tokens
    * @param from Origen
    * @param to Destino
    * @param amount Cantidad de token
    */
    function transferForMember(address from, address to, uint256 amount) external returns (bool) {
        // Checks
        require(token.balanceOf(from) >= amount, "Saldo insuficiente");

        // Effects

        // Interactions
        token.transferFrom(from, to, amount);

        return true;
    }

    /*
    * @notice Retirar primer usuario de la lista
    */
    function retirarUsuarioAdmin() external returns (bool) {
        // Checks
        require(msg.sender == owner, "Solo el propietario puede retirar usuarios de la lista");
        require(inscritos.length > 0, "No hay nadie inscrito todavia");

        // Effects
        address usuario = inscritos[0];

        // Movemos los elementos hacia la izquierda
        for(uint256 i = 0; i < inscritos.length - 1; i++) {
            inscritos[i] = inscritos[i +1];
        }
        // Eliminamos el último elemento que ahora está repetido
        inscritos.pop();

        // Interactions
        token.transferFrom(owner, usuario, COST_REGISTER);        

        emit UnregisterAdmin(usuario);

        return true;
    }

    /*
    * @notice Retira usuario
    */
    function retirarUsuario() external returns (bool) {
        // Checks
        require(yaEstaInscrito(msg.sender), "No estas inscrito");

        // Effects
        uint256 index = numeroEnLista();

        // Movemos los elementos hacia la izquierda desde la posición a eliminar
        for(uint256 i = index; i < inscritos.length - 1; i++) {
            inscritos[i] = inscritos[i +1];
        }
        // Eliminamos el último elemento que ahora está repetido
        inscritos.pop();        

        // Interactions
        token.transferFrom(owner, msg.sender, COST_UNREGISTER);

        emit Unregister(msg.sender, COST_UNREGISTER);

        return true;
    }

    /*
    * @notice Obtiene la cantida de tokens del usuario
    */
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