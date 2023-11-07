## Code for the paper "Unconscious brain dynamics – auditory inputs modulate intrinsic neuronal timescales during sleep"

# Requirements

I used this on MATLAB R2023a. Haven't tested on previous versions but it doesn't include anything fancy so should work on earlier versions as well. The figures are generated with R version 4.2.0 and ggplot2.

# Installation

Simply download the package and add it to your MATLAB path via addpath(genpath(...)) function. Use init.m to setup. 

# Demo

You can change whatever you would like in init.m (see lines 21-35 for example which sets the parameters for the model). The parameters are represented in the struct p. Then one can simply use

`[v_E, time] = chaudhuri(p);`

to generate firing rate of excitatory populations (v_E) and a time vector for plotting. This is very fast, on my laptop it usually takes less than a second. 

# Replicating the figures in the paper

The pipeline:

```
init
simulate_rest % simulates tau_E = 20 situation with no input 
simulate_rest2 % simulates tau_E = 60 situation with no input
simulate_sine2 % simulates tau_E = 20 with oscillatory input
ggfigure.r
```
