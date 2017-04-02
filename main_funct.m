%

%Train pedestrian
disp('Train pedestrians en curso...');
path = './train/pedestrians/';
list = dir( './train/pedestrians/*.png');
datasetTrainPedestrians = [];
for k = 1:numel(list)
    im = imread([path list(k).name]);
    hog = hog_features(im);
    datasetTrainPedestrians = [datasetTrainPedestrians; hog];
end

%Train background
disp('Train background en curso...');
path = './train/background/';
list = dir( './train/background/*.png');
datasetTrainBackground = [];
for k = 1:numel(list)
    im = imread([path list(k).name]);
    hog = hog_features(im);
    datasetTrainBackground = [datasetTrainBackground; hog];
end

%Test pedestrians
disp('Test pedestrians en curso...');
path = './test/pedestrians/';
list = dir( './test/pedestrians/*.png');
datasetTestPedestrians = [];
for k = 1:numel(list)
    im = imread([path list(k).name]);
    hog = hog_features(im);
    datasetTestPedestrians = [datasetTestPedestrians; hog];
end

%Test background
disp('Test background en curso...');
path = './test/background/';
list = dir( './test/background/*.png');
datasetTestBackground = [];
for k = 1:numel(list)
    im = imread([path list(k).name]);
    hog = hog_features(im);
    datasetTestBackground = [datasetTestBackground; hog];
end

csvwrite('testBackground.csv', datasetTestBackground);
csvwrite('testPedestrian.csv', datasetTestPedestrians);
csvwrite('trainBackground.csv', datasetTrainBackground);
csvwrite('trainPedestrian.csv', datasetTrainPedestrians);