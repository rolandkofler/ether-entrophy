# Random Generators for Ethereum contracts
## What source of entrophy suites your project?
summary here
### Motivation
Contracts often require random numbers, for example *games of chance* require a random variable to select a winner. Because (1) Ethereum contracts are fully deterministic without any inherent randomness and (2) the internal state of a contract as well as the entire blockchain history is visible to the public, the a secure source of entrophy is not trivial for such applications. 
### What are the options?
1. The last mined block's hash as a source of randomness: `block.blockhash(block.number-1)`
2. An external *oracle* via an *oracle provider*, for example oraclize.it and *RealityKeys.com*

https://ethereum.stackexchange.com/questions/419/when-can-blockhash-be-safely-used-for-a-random-number-when-would-it-be-unsafe