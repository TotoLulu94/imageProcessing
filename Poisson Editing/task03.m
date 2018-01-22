close all;
%% import images 
im1RGB = double(imread('images/tourEiffel.jpg'))/255;
im2RGB = double(imread('images/nenuphar.jpg'))/255;
im2RGB = imresize(im2RGB, 0.2);

% im1 = double(rgb2gray(imread('images/tourEiffel.jpg')))/255;
% im2 = double(rgb2gray(imread('images/deathStar.jpg')))/255;
% im2 = imresize(im2, 0.4);


%Select the region to import from the first image
[BW, xi, yi] = roipoly(im2RGB);
xi = xi - min(xi);
xi = xi - min(xi);

% Select the region in which we import the image
[c,r,~] = impixel(im1RGB) ;
xi = xi + c;
yi = yi + r;

% returns the new ROI
ROI = roipoly(im1RGB, xi, yi) ;

[N,M,~] = size(im1RGB);
[N2,M2,~] = size(im2RGB);

% create binary mask to decide what do we keep or not from the original
% image
mask = ones(N,M,3) - ROI;
im_without_roiRGB = im1RGB.*mask;

figure; set(gcf,'Color',[1 1 1]);
subplot(2,2,1); imshow(im1RGB); axis off; axis image;
subplot(2,2,2); imshow(im2RGB); axis off; axis image;
subplot(2,2,3); imshow(im_without_roiRGB); axis off; axis image;

new_imR = importGradient(im1RGB(:,:,1), im2RGB(:,:,1), ROI, BW);
new_imG = importGradient(im1RGB(:,:,2), im2RGB(:,:,2), ROI, BW);
new_imB = importGradient(im1RGB(:,:,3), im2RGB(:,:,3), ROI, BW);

new_im = cat(3, new_imR, new_imG, new_imB);

subplot(2,2,4); imshow(new_im); axis off; axis image;
figure; imshow(new_im); axis off; axis image;