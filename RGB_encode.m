function rgb_encode = RGB_encode(image, phase)
    R = double(image(:, :, 1)); % Kênh đỏ
    G = double(image(:, :, 2)); % Kênh xanh lá
    B = double(image(:, :, 3)); % Kênh xanh dương

    R_enc = chaotic_encode(R, phase, 1);  % Mã hóa kênh đỏ
    G_enc = chaotic_encode(G, phase, 2);  % Mã hóa kênh xanh lá
    B_enc = chaotic_encode(B, phase, 3);  % Mã hóa kênh xanh dương

    % Kết hợp lại các kênh đã mã hóa
    rgb_encode = cat(3, uint8(R_enc), uint8(G_enc), uint8(B_enc));
end