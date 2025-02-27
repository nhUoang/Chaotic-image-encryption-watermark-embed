function rgb_decode = RGB_Decode(image, phase)
    R = double(image(:, :, 1)); 
    G = double(image(:, :, 2)); 
    B = double(image(:, :, 3)); 
    
    R_enc = chaotic_reverse(R, phase, 1);  
    G_enc = chaotic_reverse(G, phase, 2);
    B_enc = chaotic_reverse(B, phase, 3);  

    rgb_decode = cat(3, uint8(R_enc), uint8(G_enc), uint8(B_enc));
end