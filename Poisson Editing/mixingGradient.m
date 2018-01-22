function new_im = mixingGradient(im1, im2, ROI, BW)

[N,M] = size(im1);
[N2,M2] = size(im2);

mask = ones(N,M) - ROI;
im_without_ROI = im1.*mask; % Image without the region

% number of pixel in Omega
numPixelOmega = sum(sum(ROI));

% initialize A and B 
A = zeros(numPixelOmega);
B = zeros(numPixelOmega,1);

% store the pixel of Omega and numbered it
listPixelOmega = zeros(2,numPixelOmega); % stores coordinate
index = 1;
% row order
for i=1:N
    for j=1:M
        if ROI(i,j) > 0
            % j <-> column so absisces 
            listPixelOmega(1,index) = j; % x
            listPixelOmega(2,index) = i; % y
            index = index +1;
        end
    end
end

% Compute the vector having the guidance field v
numPixelImport = sum(sum(BW));
v = zeros(1,numPixelImport);

% store the coordinate of the pixel we import from the source image
listPixelImport = zeros(2,numPixelImport); % stores coordinate
index = 1;
% row order
for i=1:N2
    for j=1:M2
        if BW(i,j) == 1
            % j <-> column so absisces 
            listPixelImport(1,index) = j; % x
            listPixelImport(2,index) = i; % y
            index = index +1;
        end
    end
end

% normally, we should have numPixelImport = numPixelOmega
for i=1:min(numPixelImport, numPixelOmega)
    pixelF = [listPixelOmega(2,i) listPixelOmega(1,i)];
    pixelG = [listPixelImport(2,i) listPixelImport(1,i)];
    [centerF, topF, leftF, rightF, botF] = getNeighborValue(pixelF, im1);
    [centerG, topG, leftG, rightG, botG] = getNeighborValue(pixelG, im2);
  
    if abs(centerF - topF) > abs(centerG - topG)
        v(i) = v(i) + centerF - topF ;
    else
        v(i) = v(i) + centerG - topG;
    end
    
    if abs(centerF - leftF) > abs(centerG - leftG)
        v(i) = v(i) + centerF - leftF ;
    else
        v(i) = v(i) + centerG - leftG;
    end
    
    if abs(centerF - rightF) > abs(centerG - rightG)
        v(i) = v(i) + centerF - rightF ;
    else
        v(i) = v(i) + centerG - rightG;
    end
    
    if abs(centerF - botF) > abs(centerG - botG)
        v(i) = v(i) + centerF - botF ;
    else
        v(i) = v(i) + centerG - botG;
    end
end
% don't understand why it can happends
if numPixelImport < numPixelOmega
    add = zeros(1, numPixelOmega - numPixelImport);
    v = [v add];
end 

%% Filling A and B, then resolve AX = B
for i=1:numPixelOmega
    
    % fill A
    
    for j=1:numPixelOmega
        % First fill the diagonal of A :
        if i == j
            % the diagonal elements are 4 except when omega contains pixels
            % which are at the border of S
            % Here S is an image (square) so 2 <= |Np| <= 4
            b = listPixelOmega(1,i);
            a = listPixelOmega(2,i);
            % if on borders
            if a == 1 || a ==N || b == 1 || b == M
                if a == 1 || a == N
                    if b == 1 || b == M
                        A(i,j) = 2;
                    else 
                        A(i,j) = 3;
                    end
                elseif b == 1 || b == M
                    A(i,j) = 3;
                end
            else
                A(i,j) = 4;
            end  
        else
            % check if in Omega
            if ROI(listPixelOmega(2,j),listPixelOmega(1,j)) == 1
                % inNeighborOmega(a,b) returns 1 if b in Neighborhood(a) , 0 else 
                if inNeigborOmega(i,j, listPixelOmega) == 1
                    A(i,j) = -1;
                end
            end
        end
    end
    
    % fill B
    % check is at the boundary of Omega, else 0
    pixel = listPixelOmega(:,i);
    test = isAtBoundary(pixel, ROI);
    b = listPixelOmega(1,i);
    a = listPixelOmega(2,i);
    S = v(i);
    if test == 1
        % if pixel on the boundary, we're just summing the value of its
        % neighbors which are in the outer boundary : S\Omega
       
        % outer boundary if its value in ROI is 0
        % top neighbor
        if ROI(a-1,b) == 0
            S = S + im1(a-1,b);
        end
        %bottom neighbor
        if ROI(a+1,b) == 0
            S = S + im1(a+1,b);
        end
        % left neighbor
        if ROI(a,b-1) == 0
            S = S + im1(a,b-1);
        end
        %right neighbor
        if ROI(a,b+1) == 0
            S = S + im1(a,b+1);
        end
        
    end
    B(i,1) = S;
    
end

A = sparse(A);

% Compute solution X
X = A\B;

% fill the domain Omega
% go through all the pixels and do something only if in the ROI :
new_im = im_without_ROI;
index = 1;
% Fill by row order.
for i=1:N
    for j=1:M
        % if in ROI : (ROI should contain only 0 and 1.)
        if ROI(i,j) > 0 
            new_im(i,j) = X(index);
            index = index+1;
        end
    end
end

end