function f = perlin_noise_gen(n)
%PERLIN_NOISE_GEN Creates a tileable perlin noise generator.
% References:
% http://gamedev.stackexchange.com/questions/23625/how-do-you-generate-tileable-perlin-noise
% http://eastfarthing.com/blog/2015-04-21-noise/

% init permuataion array
perm = randperm(n);
perm = [perm perm]';
theta = linspace(0, pi*2, n+1);
dirs_1 = cos(theta(1:end-1))';
dirs_2 = sin(theta(1:end-1))';
function val = surflet(x, y, gx, gy, period)
    dx = abs(x - gx);
    dy = abs(y - gy);
    poly_x = 1 - dx.^3.*(dx.*(6*dx - 15) + 10);
    poly_y = 1 - dy.^3.*(dy.*(6*dy - 15) + 10);
    hashed = perm(perm(mod(gx, period) + 1) + mod(gy, period) + 1);
    grad = (x-gx).*dirs_1(hashed) + (y-gy).*dirs_2(hashed);
    val = poly_x .* poly_y .* grad;
end
function val = noise(x, y, period)
    if period > n || period <= 0 || floor(period) ~= period
        error('Period must be a positive integer less than or equal to %d', n);
    end
    gx = floor(x);
    gy = floor(y);
    val = surflet(x, y, gx, gy, period) + ...
        surflet(x, y, gx + 1, gy, period) + ...
        surflet(x, y, gx, gy + 1, period) + ...
        surflet(x, y, gx + 1, gy + 1, period);
end
f = @noise;
end

