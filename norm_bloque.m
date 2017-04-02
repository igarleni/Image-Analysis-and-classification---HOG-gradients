%

function hog = norm_bloque(histogramas)
    %IN:
    %   -histogramas: 16x8x9
    %OUT:
    %   -hog:
    
    %normalize histograms and concatenate them = HOG
    histSize = size(histogramas);
    nBox = histSize(1:2)-1;
    hog = [];
    %hog = zeros(1:nBox(1) * nBox(2) * 4 * 9);
    for i = 1:nBox(1)
        for j = 1:nBox(2)
            histogramsToNormalize = zeros(36);
            histogramsToNormalize = histogramsToNormalize(1:36);
            histogramsToNormalize(1:9) = squeeze(histogramas(i,j,:))';
            histogramsToNormalize(10:18) = squeeze(histogramas(i+1,j,:))';
            histogramsToNormalize(19:27) = squeeze(histogramas(i,j+1,:))';
            histogramsToNormalize(28:36) = squeeze(histogramas(i+1,j+1,:))';
            L2Norm = norm(histogramsToNormalize);
            if L2Norm == 0
                L2Norm = 0.001;
            end
            hog = [hog,histogramsToNormalize/L2Norm];
        end
    end
end

%https://es.coursera.org/learn/deteccion-objetos/lecture/uAEKB/l4-4-hog-calculo-del-descriptor