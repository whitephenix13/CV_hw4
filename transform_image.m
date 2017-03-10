function [transformed_image,global_shift] = transform_image(image, m, t)
% estimate transformed image size by looking at how coners are tranformed
[imX, imY] = size(image);
TL_corner = [1,1];
TR_corner = [size(image,1),1];
BL_corner = [1,size(image,2)];
BR_corner = [size(image,1),size(image,2)];

TL_corner_transformed = m * TL_corner' + t;
TR_corner_transformed = m * TR_corner' + t;
BL_corner_transformed = m * BL_corner' + t;
BR_corner_transformed = m * BR_corner' + t;

xs = [TL_corner_transformed(1),TR_corner_transformed(1),BL_corner_transformed(1),BR_corner_transformed(1)];
ys = [TL_corner_transformed(2),TR_corner_transformed(2),BL_corner_transformed(2),BR_corner_transformed(2)];

x_size = round(max(xs)) - round(min(xs));
y_size = round(max(ys)) - round(min(ys));

% we assume that the point which transform is (min(xs),min(ys)) will now be
% (1,1) hence we have a global transformation of (min(xs)-1,min(ys)-1)
global_shift = [round(min(xs)-1);round(min(ys)-1)];

transformed_image = zeros(x_size,y_size);
for x=1:x_size
    for y=1:y_size
        inv_pixel = round(m \ ([x;y] + global_shift - t));
        %inv_pixel
        % check if coordinates inside the previous image
        if ((inv_pixel(1) > 0) && (inv_pixel(1) <= imX) && (inv_pixel(2) > 0) && (inv_pixel(2) <= imY))
            transformed_image(x,y) = image(inv_pixel(1),inv_pixel(2));
        else
            % leave the pixel black
        end
    end
end

end