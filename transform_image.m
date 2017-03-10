function [image_1_1,tranformed_im,global_shift] = transform_image(image, m, t)
% estimate transformed image size by looking at how coners are tranformed
t(1) = t(1) - size(image,2);
[imH, imW] = size(image);
TL_corner = [1,1];
TR_corner = [imW,1];
BL_corner = [1,imH];
BR_corner = [imW,imH];

TL_corner_transformed = m * TL_corner' + t
TR_corner_transformed = m * TR_corner' + t
BL_corner_transformed = m * BL_corner' + t
BR_corner_transformed = m * BR_corner' + t

xs = [TL_corner_transformed(1),TR_corner_transformed(1),BL_corner_transformed(1),BR_corner_transformed(1)];
ys = [TL_corner_transformed(2),TR_corner_transformed(2),BL_corner_transformed(2),BR_corner_transformed(2)];

x_size = round(max(xs)) - round(min(xs));
y_size = round(max(ys)) - round(min(ys));

% we assume that the point which transform is (min(xs),min(ys)) will now be
% (1,1) hence we have a global transformation of (min(xs)-1,min(ys)-1)
global_shift = [round(min(xs)-1);round(min(ys)-1)];

image_1_1 = zeros(y_size,x_size);
tranformed_im = zeros(ceil(max(ys)),ceil(max(xs)));
for x=1:x_size
    for y=1:y_size
        inv_pixel = round(m \ ([x;y] + global_shift - t));
        %inv_pixel
        % check if coordinates inside the previous image
        if ((inv_pixel(1) > 0) && (inv_pixel(1) <= imW) && (inv_pixel(2) > 0) && (inv_pixel(2) <= imH))
            image_1_1(y,x) = image(inv_pixel(2),inv_pixel(1));
        else
            % leave the pixel black
        end
    end
end
for y=1: ceil(max(ys))
    for x= 1:ceil(max(xs))
        inv_pixel_test = round(m\ ([x;y] - t));
        if ((inv_pixel_test(1) > 0) && (inv_pixel_test(1) <= imW) && (inv_pixel_test(2) > 0) && (inv_pixel_test(2) <= imH))
            tranformed_im(y,x) = image(inv_pixel_test(2),inv_pixel_test(1));
        else
            % leave the pixel black
        end
    end
end
end