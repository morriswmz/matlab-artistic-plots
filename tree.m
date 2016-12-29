function tree
%TREE Draws a tree.
%Tutorial: http://research.wmz.ninja/articles/2016/12/matlab-plots-can-be-beautiful-i.html

% set up figure
figure;
canvas_width = 800;
canvas_height = 600;
set(gcf, 'Position', [100 100 800 600]);

% thickness of the tree trunk
base_thickness = 16;
% length of the tree trunk
base_length = 200;
% determines how fast the length and thickness of the branches decay
branch_decay_factor = 0.680;
% determines the randomness of branch_decay_factor
branch_decay_randomness = 0.2;
% determines the direction of the new branch, 0 = same direction
branch_angle = deg2rad(25);
% determines the randomness of branch_angle
branch_angle_randomness = 0.4;
% color of the tree trunk and branches
branch_color = [51 25 0]/255;
% minimum length of the branches
min_branch_length = base_length * branch_decay_factor^7;
% determines how far the leaves can deviate from the branch tips
leaf_offset = 8;
% gives the leaves a random color
leaf_color = hsv2rgb([unifrnd(0, 1) 1 1]);

% drawing logic
leaf_locations = zeros(1024, 2);
leaf_count = 0;
% draw trunk, adding an extra y offset to make the junction look better
line([canvas_width/2 canvas_width/2], [0 100+base_thickness], ...
    'LineWidth', base_thickness, 'Color', branch_color);
% draw branches
draw_branch_at(canvas_width/2, 100, ...
    branch_decay_factor * base_thickness, branch_decay_factor * base_length, 1j);
% draw leaves
leaf_locations = leaf_locations(1:leaf_count, :);
% draw three layers of leaves to get a nicer look
draw_leaves(100, 0.6, 0.03, 0.1);
draw_leaves(40, 0.3, 0.1, 0.3);
draw_leaves(10, 0.2, 0.6, 0.2);

axis('equal');
axis([0 canvas_width 0 canvas_height]);
axis('off');
set(gca, 'Position', [0 0 1 1]);

% nested functions
function can_branch = draw_branch_at(x, y, thickness, len, direction)
% check length
if len < min_branch_length
    % add leaf here
    leaf_count = leaf_count + 1;
    leaf_locations(leaf_count, :) = [x y];
    can_branch = false;
    return;
end
% generate branch angles
theta_1 = branch_angle * (1.0 + branch_angle_randomness * max(min(randn(), 1), -1));
theta_2 = -branch_angle * (1.0 + branch_angle_randomness * max(min(randn(), 1), -1));
% we use a unit length complex number to represent the directional
% vector here, and rotation is done via complex number multiplication
new_dir_1 = direction * (cos(theta_1) + 1j*sin(theta_1));
new_dir_2 = direction * (cos(theta_2) + 1j*sin(theta_2));
% compute end locations of the new branches
new_x_1 = x + real(new_dir_1) * len;
new_y_1 = y + imag(new_dir_1) * len;
new_x_2 = x + real(new_dir_2) * len;
new_y_2 = y + imag(new_dir_2) * len;
% when drawing, draw a litte longer to make the junctions look better
extra_x_1 = real(new_dir_1) * thickness;
extra_y_1 = imag(new_dir_1) * thickness;
extra_x_2 = real(new_dir_2) * thickness;
extra_y_2 = imag(new_dir_2) * thickness;
% draw the two branches
line([x new_x_1+extra_x_1], [y new_y_1+extra_y_1], ...
    'LineWidth', thickness, 'Color', branch_color);
line([x new_x_2+extra_x_2], [y new_y_2+extra_y_2], ...
    'LineWidth', thickness, 'Color', branch_color);
% make new branches
decay = branch_decay_factor * (1.0 + branch_decay_randomness * max(min(randn(), 1), -1));
new_length = decay * len;
new_thickness = decay * thickness;
if ~draw_branch_at(new_x_1, new_y_1, new_thickness, new_length, new_dir_1) || ...
   ~draw_branch_at(new_x_2, new_y_2, new_thickness, new_length, new_dir_2)
    % we have already branched here, but cannot further branch
    % add a leaf at the starting location of the current branch
    leaf_count = leaf_count + 1;
    leaf_locations(leaf_count, :) = [x y];
end
can_branch = true;
end

function draw_leaves(leave_size, leave_size_variance, alpha, alpha_variance)
for ii = 1:leaf_count
    % add randomness to size and transparency
    cur_size = leave_size * (1.0 + leave_size_variance * max(min(randn(), 1), -1));
    cur_alpha = alpha * (1.0 + alpha_variance * randn());
    cur_alpha = max(min(cur_alpha, 1), 0);
    cur_color = [leaf_color cur_alpha];
    % compute and add variance to the location of the current leaf
    loc = leaf_locations(ii,:) - cur_size/2;
    theta = unifrnd(0, 2*pi);
    offset = unifrnd(0, leaf_offset);
    loc = loc + [cos(theta) sin(theta)] * offset;
    % draw the current leaf
    rect = [loc cur_size cur_size];
    rectangle('Position', rect, 'FaceColor', cur_color, ...
        'EdgeColor', 'none', 'LineWidth', 1, 'Curvature', [1 1]);
end
end

end



