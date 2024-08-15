%% HEADER BLOCK

% Title: Toughness.m
% Author: Ian Holmes
% Email: Ian.Holmes01@student.csulb.edu, holmes.ian51@gmail.com
% 
%					Date Created: 26 July 2024
%					Date Last Modified: 26 July 2024
%
%   Description:
%       This code uses built-in numerical integration methods to calculate the toughness
%       of the material from the tensile test datasets. The toughness is equivalent to the
%       area under the stress-displacement curves. Data is loaded from .xlsx files in the
%       same exact way as done in WORKING_stress_displacement_plots.m script to calculate
%       stress. This code will generate a figure for the stress-displacement curves but
%       also generate outputs for the toughness and create a figure for these results as
%       well. This script is just to provide clear separation between the working code for
%       the plots and ongoing toughness calculations.
%       
%   See also:   
%		1. WORKING_stress_displacement_plots.m


%% %%%%%%%%%%%%%%%%%%%%%%%%%%         BEGIN CODE      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

format compact; format shortG;
clear; clc; close all;

%% IMPORT .XLSX DATASETS INTO CELL 

files = {...
	["1.6CR_UT_01.xlsx", "1.6CR_UT_02.xlsx", "1.6CR_UT_03.xlsx"],
	["unknown_sample_01.xlsx", "unknown_sample_02.xlsx"],
	}; 
	% ["1.2CR_UT_01.xlsx", "1.6CR_UT_02.xlsx"],
	% modify to include future test data results

% NOTE: creates a 2x1 cell --> row 1 = untreated datasets and row 2 = unknown datasets

%% ITERATE THROUGH DATASETS FOR STRESS AND DISPLACEMENT DATA

num_sets = length(files);  

% initialize empty 1x2 cells for each variable
	area{1,num_sets} = [];
	displacement{1,num_sets} = [];
	force{1,num_sets} = [];
	stress{1,num_sets} = [];
	toughness{1, num_sets} = [];

% iterate through each "category" (untreated, unknown, etc)
for j = 1:num_sets
	
	num_dataFiles = length(files{j});
	% initialize separate figures -- untreated vs unknown -- (UNCOMMENT TO SHOW)
	% figure(j);

	% now iterate through each .xlsx dataset spreadsheet
	for i = 1:num_dataFiles

		% extract raw data values for cross-section area, displacement, and force
		data = xlsread(files{j}{i}); % creates big matrix will all excel file data
		area{j}{i} = data(1,3) / 1E+06; % divided by 1E+06 to convert from sq. mm to m^2 
		displacement{j}{i} = data(7:end, 3); % disp == travel distance of mark-10 in mm
		force{j}{i} = data(7:end, 2); % defined by raw mark-10 data given in Newtons

		% calculate stress == force/area & divide by 1,000 to convert from Pa to kPa
		stress{j}{i} = (1E-03) * (force{j}{i} / area{j}{i});

		% removing NaN values from stress and displacement data
		displacement{j}{i} = displacement{j}{i}(~isnan(displacement{j}{i}));
		stress{j}{i} = stress{j}{i}(~isnan(stress{j}{i}));

		% calculate toughness inside loop --> convert displacement to meters
		toughness{j}{i} = trapz(1E-03 * (displacement{j}{i}), stress{j}{i}); % J/m^3
		
		% UNCOMMENT TO MAKE STRESS DISP PLOTS
		% plot stress-displacement curves --> separate figures for untreated/unknown
			plot(displacement{j}{i}, stress{j}{i}, 'LineWidth', 1.5)
			hold on;

	end

end

%% UNCOMMENT TO GENERATE STRESS - DISPLACEMENT FIGURE FORMATTING


% untreated samples
f1 = figure(1);
	f1.Name = 'Untreated Stress Displacement Curves';
ax = gca;
	grid minor; box on;
	ax.XLabel.String = 'Displacement (mm)'; ax.XLabel.FontSize = 13;
	ax.YLabel.String = 'Stress (kPa)'; ax.YLabel.FontSize = 13;	
	ax.YLim = [-750 8250];
title('Untreated 1.6 NCO:OH Samples', 'FontSize', 14);
	t.FontSize = 14;
legend('Sample 01', 'Sample 04', 'Sample 05', 'Fontsize', 11, 'Location','northwest');

% unknown samples
f2 = figure(2);
	f2.Name = 'Unknown Stress Displacement Curves';
ax = gca;
	grid minor; box on;
	ax.XLabel.String = 'Displacement (mm)'; ax.XLabel.FontSize = 13;
	ax.YLabel.String = 'Stress (kPa)'; ax.YLabel.FontSize = 13;
	ax.YLim = [-100 5000];
title('Unknown NCO:OH Ratio and Concentrations', 'FontSize', 14);
legend('Sample 02', 'Sample 03', 'Fontsize', 11, 'Location','northwest')
	


%% TOUGHNESS FIGURES -- SCATTER AND ERROR BARS
% close all;
% clc;
% create vectors of toughness values by converting cells (UT = untreated & UK = unknown)
UT_toughness = cell2mat(toughness{1,1})
UN_toughness = cell2mat(toughness{1,2})

% find average toughnesses
ave_UT_toughness = mean(UT_toughness)
std_UT_toughness = std(UT_toughness);

% find standard deviation of toughnesses
ave_UN_touhgness = mean(UN_toughness)
std_UN_toughness = std(UN_toughness);


% generate figure to plot toughness results
f3 = figure(3); f3.Name = 'Toughness Results';
f3.WindowStyle = 'docked';
hold on; grid minor; box on;

% separate categorically
x = categorical({'Untreated', 'Unknown'});

% plot untreated
s1 = scatter(x(1), ave_UT_toughness, 175, 'x', 'black');
e1 = errorbar(x(1), ave_UT_toughness, std_UT_toughness, 'LineWidth', 0.75);

% plot unknown
s2 = scatter(x(2), ave_UN_touhgness, 50, 'bo', 'filled');
e2 = errorbar(x(2), ave_UN_touhgness, std_UN_toughness, 'LineWidth', 0.75);

% format figure
title('Material Toughness (J/m^{3}) of Tensile Test Samples', 'FontSize', 13);
ax = gca;
	ax.YLabel.String = 'Toughness (J/m^{3})';
	ax.YLabel.FontSize = 12;
	ax.XAxis.FontSize = 12;
	ax.XLabel.String = 'Concentration';








%%%%%%%%%%%%%%%%%%%%%%%%%%%%         END CODE        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%