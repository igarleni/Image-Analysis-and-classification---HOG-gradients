%

function histogramas = calcula_histogramas(magnitud,orientacion)
    %IN:
    %   -magnitud: matrix 128x64 with gradient of each pixel
    %   -orientacion: matrix 128x64 with gradient direction
    %OUT:
    %   histogramas: cell size = 8x8p, number of intervals = 9. 128/8=16, 64/8=8. Then,
    %   histogramas = matrix 16x8x9
    
    imSize = size(magnitud);
    
    %3 data each pixel: main interval ID, neighbor ID and weight to main interval
    %(weigh to neighbor = 1 - weightMain
    pixelData = zeros(imSize(1),imSize(2),3);
    
    histogramas = zeros(imSize(1)/8,imSize(2)/8,9);
    
    imSize(1) = imSize(1) - 1;
    imSize(2) = imSize(2) - 1;
    
    %transform direction to invervals
    for i = 2:imSize(1)
        for j = 2:imSize(2)
            ratio = abs(orientacion(i,j))/20;
            percentExtra = ratio - fix(ratio);
            weightToMain = 1 - abs(percentExtra - 0.5);
            if (percentExtra > 0.5)
                neighborInterval = mod(fix(ratio) + 1,9);
            else
                neighborInterval = mod(fix(ratio) - 1,9);
            end
            
            pixelData(i,j,1) =   mod(fix(ratio),9); %main Interval ID
            pixelData(i,j,2) = neighborInterval; %neighbor Interval ID
            pixelData(i,j,3) = weightToMain; %weight to main Interval
            
        end
    end
    
    %Calculate Histograms
    histSize = size(histogramas);
    for i = 2:imSize(1)
        for j = 2:imSize(2)
            %Main cell (where the pixel is)
            indexXcell = fix(i / histSize(1) + 1);
            indexYcell = fix(j / histSize(2) + 1);
            cellCenterX = indexXcell*8 - 4;
            cellCenterY = indexYcell*8 - 4;
            influenceX = abs(cellCenterX - i) / 8;
            influenceY = abs(cellCenterY - j) / 8;
            histogramas(indexXcell, indexYcell, pixelData(i,j,1)+1) = histogramas(indexXcell, indexYcell, pixelData(i,j,1)+1) + pixelData(i,j,3) * magnitud(i,j) * influenceX;
            histogramas(indexXcell, indexYcell, pixelData(i,j,2)+1) = histogramas(indexXcell, indexYcell, pixelData(i,j,2)+1) + (1 - pixelData(i,j,3))* magnitud(i,j) * influenceY;
            %Neighbor cells
            if ((cellCenterX - i) > 0)
                if ((cellCenterY - j) > 0)
                    %cuadrante abajo izquierda
                    if(indexYcell > 1)
                        %(i,j-1)
                        neighborY = indexYcell - 1;
                        neighborCenterY = neighborY*8 - 4;
                        neighborInfluenceY = abs(neighborCenterY - j) / 8;
                        histogramas(indexXcell, neighborY, pixelData(i,j,1)+1) = histogramas(indexXcell, neighborY, pixelData(i,j,1)+1) + pixelData(i,j,3) * magnitud(i,j) * influenceX;
                        histogramas(indexXcell, neighborY, pixelData(i,j,2)+1) = histogramas(indexXcell, neighborY, pixelData(i,j,2)+1) + (1 - pixelData(i,j,3))* magnitud(i,j) * neighborInfluenceY;
                    end
                    if (indexXcell > 1)
                        %(i-1,j)
                        neighborX = indexXcell - 1;
                        neighborCenterX = neighborX*8 - 4;
                        neighborInfluenceX = abs(neighborCenterX - j) / 8;
                        histogramas(neighborX, indexYcell, pixelData(i,j,1)+1) = histogramas(neighborX, indexYcell, pixelData(i,j,1)+1) + pixelData(i,j,3) * magnitud(i,j) * neighborInfluenceX;
                        histogramas(neighborX, indexYcell, pixelData(i,j,2)+1) = histogramas(neighborX, indexYcell, pixelData(i,j,2)+1) + (1 - pixelData(i,j,3))* magnitud(i,j) * influenceY;
                    end
                    if((indexXcell > 1) && (indexYcell > 1))
                        %(i-1,j-1)
                        neighborY = indexYcell - 1;
                        neighborCenterY = neighborY*8 - 4;
                        neighborInfluenceY = abs(neighborCenterY - j) / 8;
                        neighborX = indexXcell - 1;
                        neighborCenterX = neighborX*8 - 4;
                        neighborInfluenceX = abs(neighborCenterX - j) / 8;
                        histogramas(neighborX, neighborY, pixelData(i,j,1)+1) = histogramas(neighborX, neighborY, pixelData(i,j,1)+1) + pixelData(i,j,3) * magnitud(i,j) * neighborInfluenceX;
                        histogramas(neighborX, neighborY, pixelData(i,j,2)+1) = histogramas(neighborX, neighborY, pixelData(i,j,2)+1) + (1 - pixelData(i,j,3))* magnitud(i,j) * neighborInfluenceY;
                    end
                else
                    %cuadrante arriba izquierda
                    if(indexYcell < histSize(2))
                        %(i,j+1)
                        neighborY = indexYcell + 1;
                        neighborCenterY = neighborY*8 - 4;
                        neighborInfluenceY = abs(neighborCenterY - j) / 8;
                        histogramas(indexXcell, neighborY, pixelData(i,j,1)+1) = histogramas(indexXcell, neighborY, pixelData(i,j,1)+1) + pixelData(i,j,3) * magnitud(i,j) * influenceX;
                        histogramas(indexXcell, neighborY, pixelData(i,j,2)+1) = histogramas(indexXcell, neighborY, pixelData(i,j,2)+1) + (1 - pixelData(i,j,3))* magnitud(i,j) * neighborInfluenceY;
                    end
                    if (indexXcell > 1)
                        %(i-1,j)
                        neighborX = indexXcell - 1;
                        neighborCenterX = neighborX*8 - 4;
                        neighborInfluenceX = abs(neighborCenterX - j) / 8;
                        histogramas(neighborX, indexYcell, pixelData(i,j,1)+1) = histogramas(neighborX, indexYcell, pixelData(i,j,1)+1) + pixelData(i,j,3) * magnitud(i,j) * neighborInfluenceX;
                        histogramas(neighborX, indexYcell, pixelData(i,j,2)+1) = histogramas(neighborX, indexYcell, pixelData(i,j,2)+1) + (1 - pixelData(i,j,3))* magnitud(i,j) * influenceY;
                    end
                    if((indexXcell > 1) && (indexYcell < histSize(2)))
                        %(i-1,j+1)
                        neighborY = indexYcell + 1;
                        neighborCenterY = neighborY*8 - 4;
                        neighborInfluenceY = abs(neighborCenterY - j) / 8;
                        neighborX = indexXcell - 1;
                        neighborCenterX = neighborX*8 - 4;
                        neighborInfluenceX = abs(neighborCenterX - j) / 8;
                        histogramas(neighborX, neighborY, pixelData(i,j,1)+1) = histogramas(neighborX, neighborY, pixelData(i,j,1)+1) + pixelData(i,j,3) * magnitud(i,j) * neighborInfluenceX;
                        histogramas(neighborX, neighborY, pixelData(i,j,2)+1) = histogramas(neighborX, neighborY, pixelData(i,j,2)+1) + (1 - pixelData(i,j,3))* magnitud(i,j) * neighborInfluenceY;
                    end
                end
            else
                if ((cellCenterY - j) > 0)
                    %cuadrante abajo derecha
                    if(indexYcell > 1)
                        %(i,j-1)
                        neighborY = indexYcell - 1;
                        neighborCenterY = neighborY*8 - 4;
                        neighborInfluenceY = abs(neighborCenterY - j) / 8;
                        histogramas(indexXcell, neighborY, pixelData(i,j,1)+1) = histogramas(indexXcell, neighborY, pixelData(i,j,1)+1) + pixelData(i,j,3) * magnitud(i,j) * influenceX;
                        histogramas(indexXcell, neighborY, pixelData(i,j,2)+1) = histogramas(indexXcell, neighborY, pixelData(i,j,2)+1) + (1 - pixelData(i,j,3))* magnitud(i,j) * neighborInfluenceY;
                    end
                    if (indexXcell < histSize(1))
                        %(i+1,j)
                        neighborX = indexXcell + 1;
                        neighborCenterX = neighborX*8 - 4;
                        neighborInfluenceX = abs(neighborCenterX - j) / 8;
                        histogramas(neighborX, indexYcell, pixelData(i,j,1)+1) = histogramas(neighborX, indexYcell, pixelData(i,j,1)+1) + pixelData(i,j,3) * magnitud(i,j) * neighborInfluenceX;
                        histogramas(neighborX, indexYcell, pixelData(i,j,2)+1) = histogramas(neighborX, indexYcell, pixelData(i,j,2)+1) + (1 - pixelData(i,j,3))* magnitud(i,j) * influenceY;
                    end
                    if((indexXcell < histSize(1)) && (indexYcell > 1))
                        %(i+1,j-1)
                        neighborY = indexYcell - 1;
                        neighborCenterY = neighborY*8 - 4;
                        neighborInfluenceY = abs(neighborCenterY - j) / 8;
                        neighborX = indexXcell + 1;
                        neighborCenterX = neighborX*8 - 4;
                        neighborInfluenceX = abs(neighborCenterX - j) / 8;
                        histogramas(neighborX, neighborY, pixelData(i,j,1)+1) = histogramas(neighborX, neighborY, pixelData(i,j,1)+1) + pixelData(i,j,3) * magnitud(i,j) * neighborInfluenceX;
                        histogramas(neighborX, neighborY, pixelData(i,j,2)+1) = histogramas(neighborX, neighborY, pixelData(i,j,2)+1) + (1 - pixelData(i,j,3))* magnitud(i,j) * neighborInfluenceY;
                    end
                else
                    %cuadrante arriba derecha
                    if(indexYcell < histSize(2))
                        %(i,j+1)
                        neighborY = indexYcell + 1;
                        neighborCenterY = neighborY*8 - 4;
                        neighborInfluenceY = abs(neighborCenterY - j) / 8;
                        histogramas(indexXcell, neighborY, pixelData(i,j,1)+1) = histogramas(indexXcell, neighborY, pixelData(i,j,1)+1) + pixelData(i,j,3) * magnitud(i,j) * influenceX;
                        histogramas(indexXcell, neighborY, pixelData(i,j,2)+1) = histogramas(indexXcell, neighborY, pixelData(i,j,2)+1) + (1 - pixelData(i,j,3))* magnitud(i,j) * neighborInfluenceY;
                    end
                    if (indexXcell < histSize(1))
                        %(i+1,j)
                        neighborX = indexXcell + 1;
                        neighborCenterX = neighborX*8 - 4;
                        neighborInfluenceX = abs(neighborCenterX - j) / 8;
                        histogramas(neighborX, indexYcell, pixelData(i,j,1)+1) = histogramas(neighborX, indexYcell, pixelData(i,j,1)+1) + pixelData(i,j,3) * magnitud(i,j) * neighborInfluenceX;
                        histogramas(neighborX, indexYcell, pixelData(i,j,2)+1) = histogramas(neighborX, indexYcell, pixelData(i,j,2)+1) + (1 - pixelData(i,j,3))* magnitud(i,j) * influenceY;
                    end
                    if((indexXcell < histSize(1)) && (indexYcell < histSize(2)))
                        %(i+1,j+1)
                        neighborY = indexYcell + 1;
                        neighborCenterY = neighborY*8 - 4;
                        neighborInfluenceY = abs(neighborCenterY - j) / 8;
                        neighborX = indexXcell + 1;
                        neighborCenterX = neighborX*8 - 4;
                        neighborInfluenceX = abs(neighborCenterX - j) / 8;
                        histogramas(neighborX, neighborY, pixelData(i,j,1)+1) = histogramas(neighborX, neighborY, pixelData(i,j,1)+1) + pixelData(i,j,3) * magnitud(i,j) * neighborInfluenceX;
                        histogramas(neighborX, neighborY, pixelData(i,j,2)+1) = histogramas(neighborX, neighborY, pixelData(i,j,2)+1) + (1 - pixelData(i,j,3))* magnitud(i,j) * neighborInfluenceY;
                    end
                end
            end
            
            %Histogram cell = sum (gradientMagnitude * weightInterval *
            %weightPixelPos)
        end
    end
end