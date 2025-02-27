

function r = analyse_correlation(img1, img2)
    I1 = double(img1);
    I2 = double(img2);

    mu1 = mean(I1(:));
    mu2 = mean(I2(:));

    % Tính toán tử số và mẫu số trong công thức tương quan
    numerator = sum((I1(:) - mu1) .* (I2(:) - mu2));  % Tử số
    denominator = sqrt(sum((I1(:) - mu1).^2) * sum((I2(:) - mu2).^2));  

    % Hệ số tương quan
    r = numerator / denominator;
end