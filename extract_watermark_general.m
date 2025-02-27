%ex = imread('E:\MatLab\WORKSPACE\myproject\embeded_image\1.png');
%figure;
%imshow(extract_watermark(ex), []);
%title('Extracted Watermark');

function extracted_logo = extract_watermark(embedded_image)
% extract_watermark_general - Trích xuất thủy vân từ ảnh đã nhúng (ảnh xám hoặc ảnh màu)
% embedded_image: Ảnh đã nhúng thủy vân (xám hoặc màu)
% extracted_logo: Ảnh thủy vân trích xuất
    
    % Kích thước ảnh
    [h, w, channels] = size(embedded_image);
    
    % Nếu là ảnh màu, xử lý từng kênh R, G, B
    if channels == 3
        % Trích xuất thủy vân từ từng kênh
        R = extracting(embedded_image(:, :, 1)); % Kênh đỏ
        G = extracting(embedded_image(:, :, 2)); % Kênh xanh lá
        B = extracting(embedded_image(:, :, 3)); % Kênh xanh dương
        
        % Tổng hợp thủy vân (có thể chọn 1 kênh hoặc trung bình)
        extracted_logo = (R + G + B) / 3;
    else
        % Nếu là ảnh xám, xử lý trực tiếp
        extracted_logo = extracting(embedded_image);
    end     
end

function extracted_image = extracting(image)
    % Tải dữ liệu cho key
    loaded_data = load('key.mat');
    key = loaded_data.key;
    
    num_to_em = load('num_to_em.mat', 'num_to_embed');
    N = num_to_em.num_to_embed(1);

    % Khởi tạo ảnh thủy vân trích xuất
    extracted_image = zeros(N, N);
    current_channel = dec2bin(image(:), 8);  % Không cần tách kênh
  
    for idx = 1:N*N
        % Lấy tọa độ pixel từ chaotic_positions
        pos = key(idx);
            
        Get_MSG = current_channel(pos, 5:8);
        extracted_pixel_bin = [Get_MSG, '0000'];
        extracted_image(idx) = bin2dec(extracted_pixel_bin);
    end   
end
