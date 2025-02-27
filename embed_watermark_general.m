

function embedded_image = embed_watermark_general(original_image, watermark_image)
% embed_watermark_general - Nhúng thủy vân vào ảnh gốc (ảnh xám hoặc ảnh màu)
% original_image: Hình ảnh gốc (xám hoặc màu)
% watermark_image: Hình ảnh thủy vân (xám hoặc màu)
% embedded_image: Hình ảnh đã nhúng thủy vân

    % Nếu ảnh thủy vân là ảnh màu, chuyển sang mức xám
    if size(watermark_image, 3) == 3
        watermark_image = rgb2gray(watermark_image);
        
    end

    % Kiểm tra nếu ảnh gốc là ảnh màu
    if size(original_image, 3) == 3
        % Nhúng thủy vân vào từng kênh màu
        R = embed_watermark_channel(original_image(:, :, 1), watermark_image);
        G = embed_watermark_channel(original_image(:, :, 2), watermark_image);
        B = embed_watermark_channel(original_image(:, :, 3), watermark_image);

        % Kết hợp lại thành ảnh màu
        embedded_image = cat(3, R, G, B);
    else
        % Nhúng thủy vân trực tiếp vào ảnh xám
        embedded_image = embed_watermark_channel(original_image, watermark_image);
        
        
        %end
    end
end

function embedded_channel = embed_watermark_channel(original_channel, watermark_image)
% embed_watermark_channel - Nhúng thủy vân vào một kênh màu hoặc ảnh xám
% original_channel: Một kênh màu của ảnh gốc hoặc ảnh xám
% watermark_image: Ảnh thủy vân mức xám
% embedded_channel: Kênh màu hoặc ảnh xám đã nhúng thủy vân

    % Điều chỉnh kích thước hình ảnh thủy vân để khớp với kích thước kênh gốc
    [F1, F2] = size(original_channel);
    %watermark_image = imresize(watermark_image, [F1, F2]);

    % Chuyển đổi ảnh gốc và thủy vân sang nhị phân 8-bit
    original_binary = dec2bin(original_channel(:), 8);
    watermark_binary = dec2bin(watermark_image(:), 8);

    % Lấy MSB của ảnh thủy vân
    watermark_MSB = watermark_binary(:, 1:4);

    % Sử dụng bản đồ Logistic cải tiến để tạo vị trí ngẫu nhiên
    mu = 5.9998732541; % Giá trị tham số điều khiển
    j = 5;             % Tham số mức làm tròn
    x0 = 0.7;          % Giá trị khởi tạo
    num_pixels = numel(original_channel);

    chaotic_sequence = zeros(1, num_pixels);
    chaotic_sequence(1) = x0;

    for n = 1:num_pixels - 1
        xn = chaotic_sequence(n);
        chaotic_value = mu * xn * (1 - xn) * 10^j;
        chaotic_sequence(n+1) = ceil(chaotic_value) - chaotic_value;
    end

    % Chuyển đổi chuỗi thành vị trí trong khoảng [1, num_pixels]
    chaotic_positions = mod(floor(chaotic_sequence * num_pixels), num_pixels) + 1;

    % Nhúng 4 bit MSB của ảnh thủy vân vào 4 bit LSB của ảnh gốc
    embedded_binary = original_binary;
    num_to_embed = size(watermark_image);  % Đảm bảo số lượng phù hợp
    save('num_to_em.mat', 'num_to_embed');
    
    key = zeros(num_to_embed(1)^2, 1);
    for idx = 1:num_to_embed(1)^2
        pos = chaotic_positions(idx);
        
        %lấy giá trị cho key
        key(idx) = pos;
        % Lấy 4 bit MSB của watermark (đảm bảo watermark_MSB có ít nhất 4 bit)
        watermark_bits = watermark_MSB(idx, :); 
        
       % Thay thế 4 LSB của ảnh gốc bằng 4 bit MSB của watermark
        embedded_binary(pos, 5:8) = watermark_bits;  % Nhúng các bit MSB vào 4 bit LSB của ảnh gốc
        
    end
    
    %lưu khóa
    save('key', 'key');
   
    % Chuyển đổi lại thành ảnh
    embedded_channel_decimal = bin2dec(embedded_binary);
    embedded_channel = reshape(uint8(embedded_channel_decimal), size(original_channel));
end
