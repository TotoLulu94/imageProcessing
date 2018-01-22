close all;

% Import image
im1 = imresize( double(imread('images/nenuphar.jpg'))/255, 0.3);
im1Gray = imresize(double(rgb2gray(imread('images/nenuphar.jpg')))/255, 0.3);

% Select the Region 
ROI = roipoly(im1);

figure; set(gcf,'Color',[1 1 1]);
subplot(1,3,1); imshow(im1); axis off; axis image;

% work seperately on each channel
im1_R = im1(:,:,1);
im1_G = im1(:,:,2);
im1_B = im1(:,:,3);

% Import gradient
new_im1R = importGradient(im1Gray, im1_R, ROI, ROI);
new_im1G = importGradient(im1Gray, im1_G, ROI, ROI);
new_im1B = importGradient(im1Gray, im1_B, ROI, ROI);

new_im1 = cat(3, new_im1R, new_im1G, new_im1B);
subplot(1,3,2); imshow(new_im1); axis off; axis image;

new_im2R = importGradient(im1_R, im1_R*0.5, ROI, ROI);
new_im2G = importGradient(im1_G, im1_G*1.2, ROI, ROI);
new_im2B = importGradient(im1_B, im1_B*1.8, ROI, ROI);

new_im2 = cat(3, new_im2R, new_im2G, new_im2B);
subplot(1,3,3); imshow(new_im2); axis off; axis image;


