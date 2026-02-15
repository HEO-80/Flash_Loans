// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "../src/FlashLoanBot.sol";
import "aave-v3-core/contracts/dependencies/openzeppelin/contracts/IERC20.sol";

contract FlashLoanBotTest is Test {
    FlashLoanBot public bot;
    
    // DIRECCIONES REALES DE ETHEREUM (Las usaremos en la copia local)
    // DAI (Stablecoin): El dinero que pediremos
    address constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    // Aave Pool Addresses Provider (El "directorio" del banco)
    address constant AAVE_PROVIDER = 0x2f39d218133AFaB8F2B819B1066c7E434Ad94E9e;

    function setUp() public {
        // Desplegamos nuestro bot dentro de la simulación
        bot = new FlashLoanBot(AAVE_PROVIDER);
    }

    function testFlashLoan() public {
        // Vamos a pedir 1 MILLÓN de DAI
        uint256 amountToBorrow = 1_000_000 * 1e18; 
       
        // --- PREPARACIÓN DEL TRUCO ---
        // Como nuestro bot aún no gana dinero con arbitraje real,
        // no tiene fondos para pagar la comisión del 0.09% a Aave.
        // Usamos 'deal' para inyectarle 2000 DAI mágicamente y que pueda pagar.
        //deal(DAI, address(bot), 2000 * 1e18);
        deal(DAI, address(bot), 10000 * 1e18);

        // Comprobamos que el bot tiene el dinero para la comisión
        uint256 saldoInicial = IERC20(DAI).balanceOf(address(bot));
        console.log("Saldo para comisiones:", saldoInicial);

        // --- MOMENTO DE LA VERDAD ---
        // Ejecutamos la solicitud. Si esto no falla, es que Aave nos prestó el dinero,
        // lo tuvimos en la mano, y lo devolvimos correctamente.
        bot.solicitarPrestamo(amountToBorrow);
        
        console.log("EXITO: Prestamo de 1 Millon pedido y devuelto!");
    }
}

//forge test --match-path test/FlashLoanBot.t.sol -vv --fork-url https://eth-mainnet.g.alchemy.com/v2/xWz8OndQ0A-LfRt8sdxB3