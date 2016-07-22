# Random Generators for Ethereum contracts
## What source of entropy suites your project?
by Roland Kofler

### Motivation

Contracts often require random numbers, for example, *games of chance* require a randomly selected winner. Because (1) Ethereum contracts are fully deterministic without any inherent randomness and (2) the internal state of a contract as well as the entire blockchain history is visible to the public, the secure source of entropy is not trivial for such applications. 

### What is *randomness*?

> Randomness is the lack of pattern or predictability in events. A random sequence of events, symbols or steps has no order and does not follow an intelligible pattern or combination.  

[from Wikipedia](https://en.wikipedia.org/wiki/Randomness)

In Information theory randomness is the lack of information in a communication channel and the measure of this absence of information is called *entropy*. 
Two facts are important for practical applications:

1. it is not possible to prove empirically that a source of randomness is really random. Because randomness is the absence of any information one can only show that there is information in the variable. In the spirit of the scientific method, one can only disprove randomness.
2. Randomness generated within a (computer-) system is never truly random, but by knowing the seed state and the generator it is possible to predict such random numbers. Such a generator is called *pseudo-random* and often cheaper to obtain than true randomness, at the cost of less security. 

### What are the options?
1. **Block hash PRNG** - the last mined block's hash as a source of randomness: `block.blockhash(block.number-1)`
2. **Oracle RNG** an external *oracle* via an *oracle provider*, for example [oraclize.it]() and [RealityKeys.com]().
3. **Collab PRNG** a collaborative *proof of x* implementation.
4. any refinement and combination of these solutions.

### What are the criteria for choosing a specific solution?
The possible influencing factors are described in the following list:

1. **Randomness** - is the source random or pseudorandom?  How much entrophy has the psyeudo-random solution? 
2. **Security of the solution** - how secure is the channel from the source of randomness to the blockchain?
2. **Cost of adoption** - what are the cost of maintaining the random generator?
3. **Cost of failure** - what are the possible losses if the source or the channel fails to deliver random numbers?
4. **Performance** - how often is it possible to optain random numbers?

### Presenting the pure solutions

#### Block hash PRNG
> Providing random numbers within a deterministic system is, naturally, an impossible task. However, we can approximate with pseudo-random numbers by utilizing data which is generally unknowable at the time of transacting. Such data might include the block’s hash, the block’s timestamp, and the block’s beneficiary address. In order to make it hard for a malicious miner to control those values, one should use the BLOCKHASH operation in order to use hashes of the previous 256 blocks as pseudo-random numbers. For a series of such numbers, a trivial solution would be to add some constant amount and hashing the result.

Ethereum Yellow Paper, Gavin Wood http://gavwood.com/paper.pdf

##### Implementation 
Simplest form: `block.blockhash(block.number-1)`, see [BlockHashRNG.sol](BlockHashRNG.sol).  
In the advanceded form you collect more entropy by XOR-ing different random variables:
```
uint256 r1 = uint256(block.blockhash(block.number-1));
uint256 r2 = uint256(block.blockhash(block.number-2));
assembly {
    result := xor(r1, r2)
}
```
see [BlockHash2RNG.sol](BlockHash2RNG.sol).  

#### 

https://ethereum.stackexchange.com/questions/419/when-can-blockhash-be-safely-used-for-a-random-number-when-would-it-be-unsafe