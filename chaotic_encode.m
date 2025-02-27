function E_channel = chaotic_encode(X, phase, channel)
    % Step 1: Rotate the image counterclockwise
    X1 = rot90(X, 1);
    
    % Step 2: Substitute pixel values using S-box
    S_box = [
        1 163 2 177 156 29 54 86 71 136 141 125 93 225 83 105;
        179 57 196 36 61 81 77 23 182 135 231 210 47 5 70 181;
        180 42 240 202 242 145 162 32 154 143 46 7 66 68 158 236;
        87 6 92 161 45 148 15 129 103 113 72 251 189 95 108 10;
        209 97 78 241 194 21 216 126 127 151 153 176 48 101 0 168;
        188 79 170 34 28 233 25 224 99 247 65 245 102 96 8 33;
        131 31 183 218 237 50 249 206 200 186 185 89 107 62 4 110;
        244 19 134 220 172 184 140 133 73 226 191 27 212 215 122 248;
        159 175 229 164 217 195 207 75 43 123 44 137 246 214 144 16;
        69 90 118 165 230 119 253 40 104 9 121 243 223 22 239 219;
        254 38 146 157 142 64 234 232 60 98 120 3 138 13 58 155;
        228 49 197 187 192 35 111 205 208 139 213 39 30 171 255 152;
        147 124 173 149 150 132 252 199 222 59 91 203 84 174 106 24;
        235 55 201 53 37 12 198 204 130 11 112 221 20 76 17 67;
        115 211 100 114 41 190 193 238 117 82 169 14 51 94 63 250;
        109 18 227 74 178 52 88 85 166 80 56 26 160 167 128 116
    ];

    [J, I] = size(X);
    
   
    linear_indices = X1 + 1;  % Pixel từ 0-255 tương ứng chỉ số 1-256 trong S-box

    S_box_linear = S_box(:);
    X2 = S_box_linear(linear_indices);

    % Step 3: Convert to row matrix
    X3 = reshape(X2', 1, I * J);
    
    % Step 4: Generate chaotic sequence Z using improved logistic map
    K = 100; 
    mu = 3.82; 
    z0 = 0.7; 
    j = 5; 

    n = I * J + 2 * K; 
    Z = zeros(0, n);
    Z(1) = z0; 
    for i = 1:n
        logistic_value = mu * Z(i) * (1 - Z(i)) * 10^j; % Sử dụng công thức logistic
        logistic_scaled = ceil(logistic_value);
        Z(i+1) = logistic_scaled - logistic_value;
    end

    % Step 5: sort and mapping
 
    Z_sorted = sort(Z(K+1:end-K), 'descend');
    Z1 = Z_sorted(1:I * J); % Select I * J elements

    Z1_final = zeros(1,I * J);
    for n = 1:I * J
        Z1_final(n) = round(Z1(n) * (I*J));
    end
    
    % Step 6: create x-
    X_bar = zeros(1, I*J);
    for j = 1:I*J
        X_bar(j) = X3(I*J - Z1_final(j)); 
    end

    % Step 7: Compute sequence Y
    l = 3; % Number of decimal places
    Y = mod(ceil(X_bar * 10^l), 256);
    
    %save KEY
    phase = num2str(phase);
    channel = num2str(channel);
    save([strcat('Key_', phase,'_', channel, '.mat')], 'X3', 'Z1_final', 'Y');
    
    
    % Step 8: Compute row matrix Ē
    E_bar = zeros(1, I * J);
    for j = 1:I * J - 1
        E_bar(j) = bitxor(Y(j+1), mod(Y(j) + X_bar(j), 256)); % XOR and mod
    end

    % Step 9: Convert to 2D matrix
    E_channel = reshape(E_bar, J, I)'; % Reshape to 2D
end