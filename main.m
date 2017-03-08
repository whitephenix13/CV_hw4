% implementation based on the function here
% https://github.com/vlfeat/vlfeat/blob/master/toolbox/demo/vl_demo_sift_match.m
run('vlfeat-0.9.20/toolbox/vl_setup')

Ia = imread('boat1.pgm');
Ib = imread('boat2.pgm');
[fa, da] = vl_sift (single(Ia));
[fb, db] = vl_sift (single(Ib));

[matches, score] = vl_ubcmatch (da, db);

% getting the best match
[temp,originalpos] = sort( score, 'descend' );
sel = originalpos(1:5);

figure(2) ; clf ;
imshow(cat(2, Ia, Ib),[]) ;

xa = fa(1,matches(1,sel)) ; %matches(1,:)
xb = fb(1,matches(2,sel)) + size(Ia,2) ; %matches(2,:)
ya = fa(2,matches(1,sel)) ;
yb = fb(2,matches(2,sel)) ;

hold on ;
h = line([xa ; xb], [ya ; yb]) ;
set(h,'linewidth', 1, 'color', 'b') ;

vl_plotframe(fa(:,matches(1,sel))) ;
fb(1,:) = fb(1,:) + size(Ia,2) ;
vl_plotframe(fb(:,matches(2,sel))) ;
axis image off ;