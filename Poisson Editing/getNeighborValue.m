function [v, top, left, right, bot] = getNeighborValue(pixel, im)
i = pixel(1);
j = pixel(2);
v = im(i,j);
top = im(i-1,j);
left = im(i, j-1);
right = im(i ,j+1);
bot = im(i+1,j);
end