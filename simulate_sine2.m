%% Simulate with sine wave, calculate acw
cd C:\Users\user\Desktop\brain_stuff\philipp\sleeppaper
init


nfreq = length(freq);
A = 4;
timevector = linspace(0, 300, ntime);

acws = zeros([nfreq nroi nsim]);
p.tau_E = 60;
for i = 1:nsim
    % Input noise to V1
    noise = noises(i, :);
    
    for f = 1:nfreq
        fi = freq(f);
        
        sine = A * sin(2*pi*fi*timevector);
        p.I_ext_E  = zeros([nroi ntime]);
        p.I_ext_E(1,:) = noise + sine;
        [v_E, time] = chaudhuri(p);
        % [bold, time] = hrfconv(v_E, time, p.dt);
            % visvE = mean(v_E(visual, :));
            % somatovE = mean(v_E(somato, :));
            % gsvE = mean(v_E);
            % 
            % acws_vis(i, f) = acw(visvE, 1/p.dt);
            % acws_somato(i, f) = acw(somatovE, 1/p.dt);
            % acws_gs(i, f) = acw(gsvE, 1/p.dt);
        for j = 1:nroi
            acws(f, j, i) = acw(v_E(j, :), 1/p.dt);
        end
    end
    disp(i)
end

save('data\sineacws2.mat','acws', 'freq')