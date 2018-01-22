function output = isAtBoundary(pixel, ROI)
% This function return 1 if the pixel is in the boundaries of omega, 0 else

output = 0;
% First, we extract the neighborhood of the current pixel
% component of neighborhood extracted from the ROI (contains only 0 and 1) and neighborhood is a
% 3x3 matrix, but we won't use the corner pixels
i = pixel(2);
j = pixel(1);
neighborhood = ROI(i-1:i+1,j-1:j+1);
% since the neighborhood is from ROI : if the neighborhood is entirely in
% Omega, then the sum of the 4 neighbors should be 1, else not.
sum = neighborhood(1,2) + neighborhood(2,1) + neighborhood(2,3) + neighborhood(3,2);
if sum < 4
    output = 1;
end

end