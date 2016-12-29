function silk
%SILK Silk.
%Tutorial: TBA.
figure('Color', 'white');

canvas_width = 800;
canvas_height = 400;

step_size = 3;
radius = 60;
radius_var = 1;
n_step = floor((canvas_width + radius*4) / step_size);
start_x = -radius*2;
noise_gen = perlin_noise_gen(32);

for ii = 1:n_step
    center_x = start_x + step_size * ii;
    circ = create_circle(radius, radius_var, 360, ii/n_step, noise_gen, 32);
    circ_color = [hsv2rgb([ii/n_step 0.6 0.9]) 0.4];
    line(circ(:,1) + center_x, circ(:,2) + canvas_height/2, ...
        'Color', circ_color, 'LineWidth', 0.1);
end

axis('equal');
axis([0 canvas_width 0 canvas_height]);
axis('off');
set(gca, 'Position', [0 0 1 1]);

end

function circ = create_circle(radius, variation, n, t, noise_gen, noise_gen_size)
theta = linspace(0, pi*2, n)' + t * 0.1*pi;
x = linspace(0, noise_gen_size / 2, n)';
y = t * noise_gen_size / 4;
v = noise_gen(x, repmat(y, n, 1), noise_gen_size / 1);
delta = variation * (v + 1.0) * radius; 
circ = bsxfun(@times, [cos(theta) sin(theta)], radius + delta);
end