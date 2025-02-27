
function X = chaotic_reverse(E_channel, phase, channel)
    % Step 1: Convert from 2D matrix to row matrix (inverse of Step 8)
    [J, I] = size(E_channel);
    E_bar = reshape(E_channel', 1, I * J);
    
    
    % Step 2: load key
    if phase == 1  
        if channel == 0
            loaded_key = load('Key_1_0.mat');

            Z1 = loaded_key.Z1_final;
            Y = loaded_key.Y;
            sub_X3 = loaded_key.X3;
        elseif channel == 1
            loaded_key = load('Key_1_1.mat');

            Z1 = loaded_key.Z1_final;
            Y = loaded_key.Y;
            sub_X3 = loaded_key.X3;
        elseif channel == 2
            loaded_key = load('Key_1_2.mat');

            Z1 = loaded_key.Z1_final;
            Y = loaded_key.Y;
            sub_X3 = loaded_key.X3;  
        else channel == 3
            loaded_key = load('Key_1_3.mat');

            Z1 = loaded_key.Z1_final;
            Y = loaded_key.Y;
            sub_X3 = loaded_key.X3;  
        end
    else
        if channel == 0
            loaded_key = load('Key_2_0.mat');

            Z1 = loaded_key.Z1_final;
            Y = loaded_key.Y;
            sub_X3 = loaded_key.X3;
        
        elseif channel == 1
            loaded_key = load('Key_2_1.mat');

            Z1 = loaded_key.Z1_final;
            Y = loaded_key.Y;
            sub_X3 = loaded_key.X3;
          
        elseif channel == 2
            loaded_key = load('Key_2_2.mat');

            Z1 = loaded_key.Z1_final;
            Y = loaded_key.Y;
            sub_X3 = loaded_key.X3;
          
        else channel == 3
            loaded_key = load('Key_2_3.mat');

            Z1 = loaded_key.Z1_final;
            Y = loaded_key.Y;
            sub_X3 = loaded_key.X3;
        end  
    end
    
    %reverse step 8 to get X_bar
    M = zeros(1, I * J);
    X_bar = zeros(1, I*J);
    for j = 1:I * J - 1
        M(j) = bitxor(Y(j+1), E_bar(j)); % XOR 
        if M(j) < Y(j)
            M(j) = M(j) + 256;
        end
        X_bar(j) = M(j) - Y(j);
    end
    
    
    %reverse step 6
    X3 = zeros(1, I*J);
    for j = 1:I*J
        X3(I*J - Z1(j)) = X_bar(j);
    end
    
    
    
    for i=1:I*J
        if X3(i) == 0
            X3(i) = sub_X3(i);
        end
    end
    
    %X2 = reshape(X3, J, I)';
    
    %reverse of Step 2
    % Dữ liệu ban đầu: S-box 16x16
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

    % Làm phẳng S-box
    S_box_linear = S_box(:);
    
    linear_indices  = zeros(1, I * J);
    
    for i = 1:I * J
       linear_indices(i) = find(S_box_linear == X3(i));
    end
    
    X1_sub = reshape(linear_indices, I , J)';
    X1 = X1_sub - 1;
    % Step 7: Rotate clockwise (inverse of Step 1)
    X = rot90(X1, -1);
end
