function sunset_mountains
%SUNSET_MOUNTAINS Plots mountains.
%Tutorial: http://research.wmz.ninja/articles/2016/12/matlab-plots-can-be-beautiful-ii.html

% set up figure
figure;
canvas_width = 1200;
canvas_height = 800;

% generation parameters
base_sin_period = 1.5 * canvas_width; % controls the number of summits
base_amp = 0.15 * canvas_height; % controls altitude variation
base_noise_var = 4; % controls the noise strength
bm_ratio = 0.15; % controls the amplitude of the Brownian motion 
decay = 0.8; % controls the decaying factor for farther mountains
n_mountain = 12; % # of mountains
% color configurations
mountain_color = [216 171 132] / 255;
sun_center_color = [254 243 105] / 255;
sun_edge_color = [248 130 6] / 255;
sky_color = [239 185 127] / 255;

% draw the background (sky)
rectangle('Position', [0 0 canvas_width canvas_height], ...
    'EdgeColor', 'none', 'FaceColor', sky_color); hold on;
% draw the mountains, from the farthest one to the nearest one
for ii = n_mountain:-1:1
    y = ii / (n_mountain + 3) * canvas_height;
    % give lighter colors for farther mountains
    color = ii / n_mountain / 1.5 * mountain_color;
    % reduce the amount of superimposed Brownian motion and noise for father
    % mountains
    amp = base_amp * decay^(ii - 1);
    noise_var = base_noise_var * decay^(ii - 1);
    % give more summits to farther mountains
    sin_period = base_sin_period * (1.0 - (ii - 1) / n_mountain);
    draw_mountain_range(y, sin_period, amp, noise_var, 800, color);
end
% draw the sunlight
draw_sunlight(sun_center_color, sun_edge_color, 0.03);
% update axis config
axis('equal');
axis([0 canvas_width 0 canvas_height]);
axis('off');
set(gca, 'Position', [0 0 1 1]);

% nested functions
function draw_mountain_range(y, sin_period, amp, noise_var, n, color)
x_grid = linspace(0, canvas_width, n);
phase_offset = y / canvas_height * 4 * pi;
thetas = x_grid * 2 * pi / sin_period;
% use the sum of two sine functions as the base curve
base = sin(phase_offset + thetas);
base = base + sin(phase_offset + 0.3 * thetas);
base = base * amp;
% add Brownian motion
bm = cumsum(sqrt(bm_ratio * amp) * randn(1, n));
% add Gaussian noise
final_curve = y + base + bm + noise_var * randn(1, n);
% prepare vertices for the fill functions
vertices = [...
    0 0;...
    x_grid' final_curve';...
    canvas_width 0;...
    0 0];
% draw the current mountain
fill(vertices(:,1), vertices(:,2), color, 'EdgeColor', 'none');
end

function draw_sunlight(c_color, e_color, randomness)
n_tri = 20; % number of triangles
theta = linspace(-pi / 2, 0, n_tri + 1)';
diag_length = sqrt(canvas_height^2 + canvas_width^2);
% adding some randomness to the radius to mimic the effect of sunlight
radius = diag_length * (1.0 + max(min(randomness * randn(n_tri + 1, 1), 1), -1));
% building the drawing parameters for patch
S.EdgeColor = 'none';
S.FaceColor = 'interp';
S.FaceAlpha = 'interp';
S.AlphaDataMapping = 'none';
S.Vertices = [...
    0 canvas_height;...
    radius .* cos(theta) canvas_height + radius .* sin(theta)];
S.Faces = [ones(n_tri, 1) (3:(n_tri + 2))' (2:(n_tri + 1))'];
S.FaceVertexCData = [c_color; repmat(e_color, n_tri + 1, 1)];
S.FaceVertexAlphaData = [1; 0.0*ones(n_tri + 1, 1)];
patch(S);
end

end

