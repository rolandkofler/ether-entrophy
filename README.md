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
2. **Oracle RNG** an external *oracle* via an *oracle provider*, for example [oraclize.it](http://oraclize.it) and [RealityKeys.com](http://RealityKeys.com).
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
In the advanced form you collect more entropy by XOR-ing different random variables:
```
uint256 r1 = uint256(block.blockhash(block.number-1));
uint256 r2 = uint256(block.blockhash(block.number-2));
assembly {
    result := xor(r1, r2)
}
```
see [BlockHash2RNG.sol](BlockHash2RNG.sol).  


1. **Randomness** - Pseudorandom
2. **Security of the solution** - random value can be seen by everbody, 'bets' must happen before the block is mined. Miners can attack the solution by refusing to mine if the amount earned is bigger than the mining revenue. There are even derivates that use the bitcoin blockchain because BTC mining fee is higher. But this arises new security concerns with the channel to the Bitcoin blockchain.
2. **Cost of adoption** - virtually zero, only the cost of running the function in the contract.
3. **Cost of failure** - the amount at stake, it should be smaller than the mining reward (5 ETH + tx fees) therefore.
4. **Performance** - uint256 number, splittable on a few dozen smaller values

Advantage: no external source needed.  
Disadvantage: Needs in most caseses a block hash from the future to be secure, see [BlockHashRNG3.sol](BlockHashRNG3.sol).   
#### Oracle RNG

```
// Ethereum + Solidity
// This code sample & more @ dev.oraclize.it

import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";

contract SimpleDice is usingOraclize {
  mapping (bytes32 => address) bets;
    
  function __callback(bytes32 myid, string result) {
    if (msg.sender != oraclize_cbAddress()) throw;
    if ((parseInt(result) > 3)&&(bets[myid].send(2)))
      log0('win'); // winner AND send didn't fail!
    else log0('lose'); // loser OR sending failed
  }
    
  function bet() {
    // we accept just test bets worth 1 Wei :)
    if ((msg.value != 1)||(this.balance < 2)) throw;
    rollDice();
  }
    
  function rollDice() private {
    bytes32 myid = oraclize_query("WolframAlpha",
                    "random number between 1 and 6");
    bets[myid] = msg.sender;
  }
}
```
[SimpleDice by Oraclize.it](https://ethereum.github.io/browser-solidity/#gist=138f23b50a568912cb5747c678d6b1d5&version=soljson-latest.js)

1. **Randomness** - truly random
2. **Security of the solution** - it depends on an external oracle service. This service can have an outage (Oraclize.it runs on high available AWS nodes), shutdown or hacked.
2. **Cost of adoption** - Fees to the oracle provider, for example querying Random.org from Oracelize.it costs per query 0.01$ (+0.04$ for TLS notary secured connection).
3. **Cost of failure** - the amount at stake.
4. **Performance** - limited by the provider of the oracle, potentially virtualy unlimited.


#### Collective RNG

[RNGDAO](https://github.com/randao/randao/blob/master/README.en.md) is an example of a collective effort based Random Number Generator. People get payed to submit random values and their aggregated random number is revealed only after some time.

1. **Randomness** - depends on the sources the collective uses
2. **Security of the solution** - no risk of collution due to the protocol, risk of non-randomness because source is not provable.
2. **Cost of adoption** - collective needs to be payed for every round
3. **Cost of failure** - the amount at stake.
4. **Performance** - needs a few blocks until the protocol settles the final number. Applicability limited and not suited if there are not 2 steps.

# Combination of multiple sources of randomness 
To mitigate an outage of the solutions that rely on external sources of randomness, it would be possible to fall back to the Block Hash solutions

# References
https://ethereum.stackexchange.com/questions/419/when-can-blockhash-be-safely-used-for-a-random-number-when-would-it-be-unsafe
https://www.reddit.com/r/ethereum/comments/4rf03b/why_ethereumlotteryio_uses_bitcoin_blocks_as_a/
https://ethereum.stackexchange.com/questions/191/how-can-i-securely-generate-a-random-number-in-my-smart-contract
https://github.com/randao/randao/blob/master/README.en.md
