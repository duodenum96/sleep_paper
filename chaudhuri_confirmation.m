%% Simulate resting state (no sine input), calculate ACW to test convergence
cd C:\Users\duodenum\Desktop\brain_stuff\sleep_paper\sleep_paper
init

nsim = 5;

acws_vis = zeros([nroi nsim]);
acws_somato = zeros([nroi nsim]);

for i = 1:nsim
    % Input noise to V1
    stimtarget = 1;
    noise = noises(stimtarget, :);
    p.I_ext_E  = zeros([nroi ntime]);
    p.I_ext_E(1,:) = noise;
    [v_E, time] = chaudhuri(p);

    for j = 1:nroi
        acws_vis(j, i) = acw(v_E(j, :), 1/p.dt);
    end
    
    % Input noise to region 2
    stimtarget = 10;
    noise = noises(stimtarget, :);
    p.I_ext_E  = zeros([nroi ntime]);
    p.I_ext_E(stimtarget,:) = noise;
    [v_E, time] = chaudhuri(p);

    for j = 1:nroi
        acws_somato(j, i) = acw(v_E(j, :), 1/p.dt);
    end
end

meanvis = mean(acws_vis, 2) / 1000;
meansomato = mean(acws_somato, 2) / 1000;

close all
figure;
subplot(1, 2, 1)
stem(visual, meanvis(visual), 'k', 'filled')
hold on
stem(somato, meanvis(somato), 'r', 'filled')
xticks([])
ylabel('ACW-0')
title('Stimulation on V1')

subplot(1, 2, 2)
stem(visual, meansomato(visual), 'k', 'filled')
hold on
stem(somato, meansomato(somato), 'r', 'filled')
xticks([])
ylabel('ACW-0')
title('Stimulation on Region 2')
legend({'Visual', 'Somatosensory'}, 'Box', 'off')