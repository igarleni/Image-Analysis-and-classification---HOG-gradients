%

function [magnitud,orientacion] = gradiente(patch)
    %IN:
    %   -patch: image 128x64
    %OUT:
    %   -magnitud: matrix 128x64 with gradient of each pixel
    %   -orientacion: matrix 128x64 with gradient direction
    patch = double(patch);
    imSize = size(patch);
    magnitud = zeros(imSize(1),imSize(2));
    orientacion = zeros(imSize(1),imSize(2));
    imSize(1) = imSize(1) - 1;
    imSize(2) = imSize(2) - 1;
    for i = 2:imSize(1)
        for j = 2:imSize(2)
            magnitudTemp = double([0,0,0]);
            orientacionTemp = double([0,0,0]);
            for k = 1:imSize(3)
                dx = patch(i+1, j, k) - patch(i-1, j, k);
                dy = patch(i, j+1, k) - patch(i, j-1, k);
                magnitudTemp(k) = sqrt(double(dx^2 + dy^2));
                orientacionTemp(k) = atan2(dy,dx);
            end
            indexMax = find(magnitudTemp==max(magnitudTemp));
            indexMax = indexMax(1);
            magnitud(i,j) = magnitudTemp(indexMax(1));
            orientacion(i,j) = orientacionTemp(indexMax) * 180/pi ;
        end
    end
    
end