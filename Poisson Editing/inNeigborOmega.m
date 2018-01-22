function output = inNeigborOmega(i,j,list)
output = 0;
p_i = list(:,i);
p_j = list(:,j);
% check if p_j in neighborhood of p_i
if p_j(1) == p_i(1)
    if p_j(2) == p_i(2) - 1
        output = 1;
    elseif p_j(2) == p_i(2) +1
        output = 1;
    end
  
elseif p_j(2) == p_i(2)
    if p_j(1) == p_i(1) -1
        output = 1;
    elseif p_j(1) == p_i(1) +1
        output = 1;
    end
end
end