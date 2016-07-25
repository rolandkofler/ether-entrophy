// Do NOT consider this code SECURE
contract BlockHashRNG3 {
    
    uint256 private lastRNGBlock=0;
    uint8 private numberOfBlocksToWait=1;
    
    
    event LogResult(uint256 r);
    event LogBlock(uint256 b);
    /** Step one of two.
     1. initiate Random Number Generator.
    */
    function initiate() {
        lastRNGBlock= block.number+numberOfBlocksToWait;
        LogBlock(lastRNGBlock);
    }
    
    /** Step two of two.
     2. generate the random number
    */
    function random() {
        var blck = lastRNGBlock;
        if(lastRNGBlock==0) throw; // 0 is a marker that initiate didnt happen
        lastRNGBlock=0; // set 0 to say you have to initiate.
        var result = uint256(block.blockhash(blck));
        LogResult(result);
    }
    
}
