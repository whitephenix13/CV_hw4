function [ best_m_mat, best_t_mat ] = ransac(N, P, T)
% T is a 4 * size(matches,2) which represents x1,y1,x2,y2 for all
% matching pairs
picked_index = zeros(P,1);
best_count = -1;
best_m_mat = zeros(4,1);
bets_t_mat = zeros(2,1);
for i=1:N
    % randomly picked P different pairs
    perm = randperm(size(T,2));
    picked_index = perm(1:P);
    A = zeros(2 * P, 6);
    b = zeros(2 * P, 1);
    for j=1:P
        % build A matrix for each point
        A(2*j-1,1) = T(1,picked_index(j));
        A(2*j-1,2) = T(2,picked_index(j));
        A(2*j-1,5) = 1;
        A(2*j,3) = T(1,picked_index(j));
        A(2*j,4) = T(2,picked_index(j));
        A(2*j,6) = 1; 
        % build b matrix for each point
        b(2*j-1,1) = T(3,picked_index(j));
        b(2*j,1) = T(4,picked_index(j));
    end
    x = pinv(A)*b;
    m_mat = reshape(x(1:4),[2 2])';
    t_mat = x(5:6);
    transform_T = zeros(2,size(T,2));
    for k=1:size(T,2)
       transform_T(1:2,k) = m_mat * T(1:2,k) + t_mat;
    end
    
    % plot?
    count = 0;
    for j=1:P
        points = zeros(2,2);
        points(1,:) = transform_T(1:2,j)';
        points(2,:) = T(3:4,j)';
        if(pdist(points,'euclidean') <= 10)
            count = count + 1;
        end
    end
    if(count > best_count)
        best_count = count;
        best_m_mat = reshape(x(1:4), [2 2])';
        best_t_mat = x(5:6);
    end
end
end