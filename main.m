% implementation based on the function here
% https://github.com/vlfeat/vlfeat/blob/master/toolbox/demo/vl_demo_sift_match.m
run('vlfeat-0.9.20/toolbox/vl_setup')

test = 'image_stitching'; % image_alignment image_stitching
if(strcmp(test,'image_alignment'))
    Ia = imread('boat1.pgm');
    Ib = imread('boat2.pgm');
    [fa, da] = vl_sift (single(Ia));
    [fb, db] = vl_sift (single(Ib));

    [matches, score] = vl_ubcmatch (da, db);
    % getting the best match
    [temp,originalpos] = sort( score, 'descend' );
    sel = originalpos(1:10);
    figure(1) ; clf ;
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

    T = zeros(4,size(matches,2));
    for i=1:size(matches,2)
    T(1:2,i) = fa(1:2,matches(1,i));
    T(3:4,i) = fb(1:2,matches(2,i));
    end

    figure(2)
    [m, t] = ransac(100, 20, T);
    % TODO m has to be transposed in a
    a = [m';t'];
    result = [a';0,0,1]';
    trans = maketform('affine',result);
    newIa = imtransform(Ia,trans);
    imshow(newIa,[]);
    title('Built in matlab');
    figure(3)
    [t_image, global_shift] = transform_image(Ia, m', t);
    imshow(t_image,[]);
    title('custom image transform');
elseif(strcmp(test,'image_stitching'))
    Ima = imread('right.jpg');
    Imb = imread('left.jpg');
    Ia = rgb2gray(Ima);
    Ib = rgb2gray(Imb);
    % zero pad Ia and Ib
    [Xa, Ya] = size(Ia);
    [Xb, Yb] = size(Ib);
    padX = Xb - Xa;
    padY = Yb - Ya;
    Ia = padarray(Ia, [padX padY], 'post');
    [fa, da] = vl_sift (single(Ia));
    [fb, db] = vl_sift (single(Ib));
    
    [matches, score] = vl_ubcmatch (da, db);
    [temp,originalpos] = sort( score, 'descend' );
    sel = originalpos(1:15);

    figure(1) ; clf ;
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
    
    T = zeros(4,size(matches,2));
    %get (x,y,x',y') coordinate of matching point and store them in T 
    for i=1:size(matches,2)
        T(1:2,i) = fa(1:2,matches(1,i));
        T(3:4,i) = fb(1:2,matches(2,i));
    end
    figure(2)
    [m, t] = ransac(100, 20, T);
    [t_image, global_shift] = transform_image(Ia, m', t);
    new_imageA = padarray(t_image, [global_shift(2), global_shift(1)], 'pre');
    new_imageB = padarray(Ib, [size(new_imageA,1) - size(Ib,1), size(new_imageA,2) - size(Ib,2)], 'post');
    new_imageFinal = max(new_imageA, double(new_imageB));
    imshow(new_imageFinal,[]);
end