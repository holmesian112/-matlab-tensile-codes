%% HEADER BLOCK

% Title: WORKING_stress_displacement_plots.m
% Author: Ian Holmes
% Email: Ian.Holmes01@student.csulb.edu, holmes.ian51@gmail.com
% 
%					Date Created: 16 July 2024
%					Date Last Modified: 18 July 2024
%	
%   Description:
%       This script is written to automate the processing of data received from
%       the tensile testing of HTPB-TiO2. This code imports a series of .xlsx
%       files, each corresponding to raw data measured by the Mark-10 for the
%       tensile test of each sample (currently there are only 3 sets of test
%       data to work with). The raw data includes the load (N), the 
%       travel distance of the mark-10 (mm), and the time history (s). 
%       The cross-sectional area of each specimen was measured using calipers,
%       along with the initial length. For each sample and set of data, a 
%       plot of stress vs displacement will be generated for determining
%       material properties.
% 
%%   See also:
%       1.  BasicGraphs.m -- written by Hakob to perform the same operation, but
%           is automated for dozens of sets of test data all at once. 
%       2.  
% 

%% %%%%%%%%%%%%%%%%%%%%%%%%%%         BEGIN CODE      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
format compact;
clear; clc;
close all;

%% IMPORT XLSX DATA 
% must use "..."
files = {...
    ["1.6CR_UT_01.xlsx", "1.6CR_UT_02.xlsx", "1.6CR_UT_03.xlsx"],
	["1.2CR_UT_01.xlsx", "1.2CR_UT_02.xlsx"],
	["unknown_sample_01.xlsx", "unknown_sample_02.xlsx"],
	};
    
%% iterate through raw data files and generate stress-displacement curves
numSets = length(files);

for j = 1:numSets

    numFiles = length(files{j});
    figure();


    for i = 1:numFiles

        data = xlsread(files{j}{i});

        Areas{j}{i} = data(1, 3) / 1E6; % area converted to m^2
        Displacement{j}{i} = data(7:end, 3); % displacement == travel distance of tester 
        Force{j}{i} = data(7:end, 2); % Newtons
        Stress{j}{i} = (Force{j}{i} / Areas{j}{i}) / 1000; % kPa
        
        plot(data(7:end, 3), Stress{j}{i}, 'LineWidth', 1.25);
        hold on

    end

end
%% Formatting Plots
f1 = figure(1);
	f1.Name = '1.6CR Untreated Stress Displacement';
ax = gca;
	grid minor; box on;
	ax.XLabel.String = 'Displacement (mm)'; ax.XLabel.FontSize = 13;
	ax.YLabel.String = 'Stress (kPa)'; ax.YLabel.FontSize = 13;	
	ax.YLim = [-750 8250];
title('Untreated 1.6 NCO:OH Samples', 'FontSize', 14);
	t.FontSize = 14;
legend('1.6CR\_UT\_01', '1.6CR\_UT\_02','1.6CR\_UT\_03', 'Fontsize', 11, ...
	'Location','northwest');
%%
f2 = figure(2);
	f2.Name = '1.2CR Untreated Stress Displacement';
ax=gca;
	grid minor; box on;
	ax.XLabel.String = 'Displacement (mm)'; ax.XLabel.FontSize = 13;
	ax.YLabel.String = 'Stress (kPa)'; ax.YLabel.FontSize = 13;	
title('Untreated 1.2 NCO:OH Samples', 'FontSize', 14);
	t.FontSize = 14;
legend('1.2CR\_UT\_01', '1.2CR\_UT\_02', 'Fontsize', 11, 'Location','northwest');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%         END CODE        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%