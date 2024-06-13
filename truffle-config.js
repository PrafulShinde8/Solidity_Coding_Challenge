

module.exports = {
  /* Other configurations */
  plugins: ["truffle-plugin-import"],
  api_keys: {
    etherscan: "Your Etherscan API key",
  },
  networks: {
    networks: {
      development: {
        host: "127.0.0.1",
        port: 7545,
        network_id: "*", // Match any network id
      },
    },

  compilers: {
    solc: {
      version: "^0.7.0",
    },
  },
  contracts_directory: "./src/contracts",
},
};
