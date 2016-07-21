# Random Generators for Ethereum contracts
## What source of entrophy suites your project?
by Roland Kofler
### Motivation
Contracts often require random numbers, for example *games of chance* require a random variable to select a winner. Because (1) Ethereum contracts are fully deterministic without any inherent randomness and (2) the internal state of a contract as well as the entire blockchain history is visible to the public, the a secure source of entrophy is not trivial for such applications. 
### What are the options?
1. the last mined block's hash as a source of randomness: `block.blockhash(block.number-1)`
2. an external *oracle* via an *oracle provider*, for example oraclize.it and *RealityKeys.com*
3. a contract oracle involving custom work 
4. any refinement and combination of these solutions.

### What are the criteras for chosing a specific solution?

https://ethereum.stackexchange.com/questions/419/when-can-blockhash-be-safely-used-for-a-random-number-when-would-it-be-unsafe