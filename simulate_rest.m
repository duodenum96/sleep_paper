%% Simulate resting state (no sine input), calculate ACW to test convergence
cd C:\Users\user\Desktop\brain_stuff\philipp\sleeppaper
init

acws_vis = zeros([1 nsim]);
acws_somato = zeros([1 nsim]);
acws_gs = zeros([1 nsim]);

acws = zeros([nroi nsim]);

for i = 1:nsim
    % Input noise to V1
    noise = noises(i, :);
    p.I_ext_E  = zeros([nroi ntime]);
    p.I_ext_E(1,:) = noise;
    [v_E, time] = chaudhuri(p);
%     [bold, time] = hrfconv(v_E, time, p.dt);
    % Normalize bold to convert to percent change
%     bold = bold ./ mean(bold, 2);

%     visbold = mean(bold(visual, :));
%     somatobold = mean(bold(somato, :));
%     gsbold = mean(bold);

    % v_E = v_E ./ mean(v_E, 2);
    % 
    % visvE = mean(v_E(visual, :));
    % somatovE = mean(v_E(somato, :));
    % gsvE = mean(v_E);
    % 
    % acws_vis(i) = acw(visvE, 1/p.dt);
    % acws_somato(i) = acw(somatovE, 1/p.dt);
    % acws_gs(i) = acw(gsvE, 1/p.dt);

    for j = 1:nroi
        acws(j, i) = acw(v_E(j, :), 1/p.dt);
    end

    disp(i)
end

save('data\restacws.mat', 'acws')