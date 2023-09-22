%% Initialize the project (paths and variables)
clear, clc, close all

% For replicability. This number was chosen after extremely careful 
% considerations which have nothing to do with so-called "shits and giggles".
rng(666)
projectfolder = 'C:\Users\duodenum\Desktop\brain_stuff\sleep_paper\sleep_paper';
addpath(genpath(projectfolder))

% Configure python
pyenv(Version="C:\Users\duodenum\miniconda3\envs\py39\python.exe");

datafold = [projectfolder,  '\data\'];
resultsfold = [projectfolder, '\results\'];
figuresfold = [projectfolder, '\figures\'];

nsim = 30; % Change this value before final figures
nroi = 29;
freq = 5;
%% Chaudhuri Default Parameters
p = [];

p.tau_E = 20;         % Intrinsic time constant(ms)
p.tau_I = 10;
p.beta_E = 0.066;     % Slope of firing rate (Hz / pA)
p.beta_I = 0.351;
p.w_EE = 24.3;        % Excitatory to excitatory coupling (pA / Hz)
p.w_EI = 19.7;        % Inhibitory to excitatory
p.w_IE = 12.2;
p.w_II = 12.5;
p.mu_EE = 33.7;       % Fixed parameter that control excitatory input (pA / Hz)
p.mu_IE = 25.3;
p.eta = 0.68;         % Scaling parameter for hierarchy
p.dt = 1;           % Time steps (ms)
p.tspan = 300;

timevector = 0:p.dt:p.tspan/p.dt*1000;
ntime = length(timevector);
% Load pkl file for hierarchy
fid = py.open([datafold, '\subgraph_data.pkl'],'rb');
h = py.pickle.load(fid, pyargs('encoding', 'latin1'));
h = struct(h); h = double(h.hier_vals.tolist()); p.h = h' / max(h);

% Input noise to V1
noise = 1e-5 * randn([nroi ntime, 2]);
p.I_ext_E  = zeros([nroi ntime]);
p.noise = noise;

% SC matrix and ROIs
scpath = [datafold, '\SC.xlsx'];
opts = detectImportOptions(scpath);
opts.VariableTypes = [{'char'}, {'char'}, {'double'}, {'double'}];
SC_raw = readtable(scpath, opts);

rois = {'V1', 'V2', 'V4', 'DP', 'MT', '8m', '5', '8l', 'TEO', '2', 'F1', 'STPc', '7A', '46d', '10', '9/46v','9/46d', 'F5', 'TEpd', 'PBr', '7m', '7B', 'F2', ...
    'STPi', 'ProM', 'F7', '8B', 'STPr', '24c'};
visual = [1 2 3 5 4 9 6 19 13 12];
nvis = length(visual);
somato = [7 10 11 15 16 17 18 22 23 27];
nsomato = length(somato);

J = zeros(nroi);

% I'd be really interested in seeing the vectorized version of the
% following chunk if someone smarter than me can branch the github and do
% it.
for i = 1:nroi
    for j = 1:nroi
        index = find(strcmp(SC_raw{:,1}, rois{i}) & strcmp(SC_raw{:,2}, rois{j}));
        if isempty(index) == 0
            J(i,j) = SC_raw{index,3};
        end
    end
end
p.J = J;
% Just to check
% [v_E, time] = chaudhuri(p);

% Ensure noises stay the same
noises = randn([nsim ntime]);