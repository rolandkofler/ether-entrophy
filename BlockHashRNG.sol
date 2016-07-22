contract BlockHashRNG {
    
    function random() constant returns (uint) {
        return uint(block.blockhash(block.number-1));
    }
 
}
