%

function hog = hog_features(patch)
    %patch: image dir 128x64
    
    %%hog data:
    %   -cell size = 8x8
    %   -nº intervals: 9
    %   -Block size: 2x2
    
    [magnitud,orientacion] = gradiente(patch);
    histogramas = calcula_histogramas(magnitud,orientacion);
    hog = norm_bloque(histogramas);
    
end