contract BlockHashRNG {
    
    function random() constant returns (uint256 result) {
        uint256 r1 = uint256(block.blockhash(block.number-1));
        uint256 r2 = uint256(block.blockhash(block.number-2));
        assembly {
            result := xor(r1, r2)
        }
        
    }
}
