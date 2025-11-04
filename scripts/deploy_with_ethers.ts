// This script can be used to deploy the "Storage" contract using ethers.js library.
// Please make sure to compile "./contracts/1_Storage.sol" file before running this script.
// And use Right click -> "Run" from context menu of the file to run the script. Shortcut: Ctrl+Shift+S

import { deploy } from './ethers-lib'

(async () => {
  try {
    const tokenEspera = await deploy('TokenEspera', [])
    console.log(`address: ${tokenEspera.address}`)

    const listaEspera = await deploy('ListaEspera', [tokenEspera.address])
    console.log(`address: ${listaEspera.address}`)

    await tokenEspera.changeOwner(listaEspera.address);
    
  } catch (e) {
    console.log(e.message)
  }
})()