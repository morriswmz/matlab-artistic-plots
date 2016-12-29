function light_dots
%LIGHT_DOTS Generates light dots.
%Tutorials: TBA

canvas_width = 800;
canvas_height = 600;

sin_period = 1.2 * canvas_width;
init_phase = unifrnd(0, pi*2);
amp = 0.15 * canvas_height;
base_radius = floor(0.09 * canvas_width);
x_randomness = 10;
y_randomness = 50;

hf = figure('Color', 'black', ...
    'Position', [100 100 canvas_width canvas_height], ...
    'Visible', 'on');
axis('equal');
set(gca, 'Position', [0 0 1 1]);
axis([0 canvas_width 0 canvas_height]);
axis('off');

draw_layer_and_blend(6, 0.3, 0.6, base_radius, 0.3, 1, 50);
draw_layer_and_blend(32, 0.6, 0.9, base_radius, 0.2, 12, 40);
draw_layer_and_blend(16, 0.65, 1.0, base_radius / 3, 0.1, 1, 2);
draw_layer_and_blend(16, 0.70, 1.0, base_radius / 4, 0.1, 1, 1);
draw_layer_and_blend(24, 0.75, 1.0, base_radius / 6, 0.2, 1, 1);
draw_random_circles(48, 0.95, 0.8, base_radius / 12, 0.3, 1);

function draw_layer_and_blend(n, alpha, sat, r, r_rnd, ratio, sigma)
draw_random_circles(n, alpha, sat, r, r_rnd, ratio);
frame = getframe(gca);
blurred_im = imgaussfilt(frame2im(frame), sigma);
im_size = size(blurred_im);
clf(hf);
image(linspace(0, canvas_width, im_size(1)), ...
    linspace(0, canvas_height, im_size(2)), blurred_im);
axis('equal');
axis([0 canvas_width 0 canvas_height]);
set(gca, 'Position', [0 0 1 1]);
axis('off');
end

function draw_random_circles(n, alpha, sat, r, r_rnd, ratio)
xs = linspace(0, canvas_width, n)' + x_randomness * randn(n, 1);
curve = amp * sin(init_phase + xs / sin_period * 2 * pi);
ys = curve + canvas_height / 2 + y_randomness * randn(n, 1);
colors = hsv2rgb([min(max(xs / canvas_width, 0), 1) sat*ones(n, 1) ones(n, 1)]);
rs = r * (1.0 + min(max(r_rnd * randn(n, 1), -1), 1));
for ii = 1:n
    w = rs(ii) / ratio;
    xywh = [xs(ii) - w ys(ii) - rs(ii) 2 * w 2 * rs(ii)];
    rectangle('Position', xywh, 'Curvature', [1 1], ...
        'FaceColor', [colors(ii,:) 0.8*alpha], ...
        'EdgeColor', [colors(ii,:) alpha], ...
        'LineWidth', 1);
end
end

end

