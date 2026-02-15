// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

// Importamos los contratos del "Banco" (Aave)
import "aave-v3-core/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";
import "aave-v3-core/contracts/interfaces/IPoolAddressesProvider.sol";
import "aave-v3-core/contracts/dependencies/openzeppelin/contracts/IERC20.sol";

contract FlashLoanBot is FlashLoanSimpleReceiverBase {
    address public owner;

    // Conectamos nuestro bot con la dirección oficial de Aave
    constructor(address _addressProvider)
        FlashLoanSimpleReceiverBase(IPoolAddressesProvider(_addressProvider))
    {
        owner = msg.sender;
    }

    // --- PARTE 1: PEDIR EL DINERO ---
    // Esta función la llamas TÚ desde la terminal
    function solicitarPrestamo(address token, uint256 cantidad) external {
        address receiverAddress = address(this);
        bytes memory params = ""; 
        uint16 referralCode = 0;

        POOL.flashLoanSimple(
            receiverAddress,
            token,
            cantidad,
            params,
            referralCode
        );
    }

    // --- PARTE 2: GASTAR Y DEVOLVER ---
    // Esta función la llama AAVE automáticamente cuando te ingresa el dinero
    function executeOperation(
        address asset,
        uint256 amount,
        uint256 premium,
        address initiator,
        bytes calldata params
    ) external override returns (bool) {
        
        // 1. AQUÍ TUS OPERACIONES DE ARBITRAJE
        // (En este momento tienes el millón de dólares en el saldo del contrato)

        // 2. Calcular cuánto hay que devolver (Prestado + Comisión 0.09%)
        uint256 cantidadADevolver = amount + premium;

        // 3. Firmar el cheque para que Aave se cobre
        IERC20(asset).approve(address(POOL), cantidadADevolver);

        return true;
    }
}