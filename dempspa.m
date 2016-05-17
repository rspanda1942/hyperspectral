%% load data set and ground ture
clear;
%% 

% load ('D:\Freserch\Data\Hyperspectral\paviaU.mat') ;
% load ('D:\Freserch\Data\Hyperspectral\paviaU_gt.mat');

% load DC.mat ;
% load DC_gt2.mat;

% 
load Indian_pines_corrected.mat ;
load Indian_pines_gt.mat;
%% get all sample
[row , col , ban] = size( data );
gt = reshape( groundT , row * col , 1);
data = reshape( data , row * col , ban);
gt = double(gt);
%% data preprocessing

data = bsxfun(@minus, data, min(data , [] , 1));
data = bsxfun(@rdivide, data, max(data , [] , 1) - min(data , [] , 1));
data = bsxfun(@minus, data, mean(data));
Rawdata = data;
%% 
prinal = 3;
coeff = pca(data);
data = data * coeff ;
data=data(:,1:prinal);

%% 
patchDim = 61;     %%
patchNum = 20000;
patches = samplegrayIMAGES(patchDim,patchNum,reshape(data , row ,col, prinal)) ;

meanPatch = mean(patches, 2);
patches = bsxfun(@minus, patches, meanPatch);
% ZCAWhite = eye(patchDim*patchDim);
display_network(patches(:,1:100));
%% 

% ZCA 
epsilon = 15.1;	       % epsilon for ZCA whitening  15.5

sigma = patches * patches' / size(patches,2);    
[u, s, v] = svd(sigma);
ZCAWhite = u * diag(1 ./ sqrt(diag(s) + epsilon)) * u';
patches = ZCAWhite * patches;

display_network(patches(:,1:100));

%% 
C = 200;  % 
iteration = 100;
on = 0;
% [center , count]= sphKmeans(patches, C, iteration);
[center  , count]= dropsphKmeans(patches, C, 0.5,iteration , on);
sss3=find(count>10);
centernew=center(:,sss3);
display_network(centernew);


%% 

W = centernew' * ZCAWhite;
b_w = - W * meanPatch;

convimage = reshape(data , row ,col, prinal) ;
convimage = padarray(convimage,[fix(patchDim/2) fix(patchDim/2)],'symmetric'); 
convolvedImage = zeros(row , col ,size(W ,1) * size(convimage,3));

nn=1;
for ii = 1: size(convimage,3)
    for jj = 1: size(W ,1)
        
        feature = reshape(W(jj, :), patchDim, patchDim);
        feature = flipud(fliplr(squeeze(feature)));
        convolved = conv2(convimage(:,:,ii), feature, 'valid');       
        convolved = convolved + b_w(jj);
%         convolved = 1 ./ (1 + exp(-convolved));
        convolvedImage(:,:,nn) = convolved;
        nn=nn+1;
    end
    ii
end

bbb=size(convolvedImage,3);
data = reshape(convolvedImage, row*col,bbb);
data = 1 ./ (1 + exp(-data));
%% 
Fdata = [Rawdata data];

[trainS  , textS ]= RandTrainSample(gt , 50);

model = svmtrain(gt(trainS,:),Fdata(trainS,:),'-t 0 -c 2000 -g 0.01');
[predict_label,accuracy] = svmpredict(gt(textS,:),Fdata(textS,:),model);
% pingding3(gt(textS,:),predict_label)  ;

