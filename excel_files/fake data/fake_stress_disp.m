%% fake data testbest

clear; clc; format compact; close all;
set(0,'DefaultFigureWindowStyle','docked');
set(0,'DefaultFigureNumberTitle','off');


files_2PA = {...
	["2PA_UT_01.xlsx","2PA_UT_02.xlsx"],...
	["2PA_2mM_01.xlsx", "2PA_2mM_02.xlsx"],...
	["2PA_5mM_01.xlsx", "2PA_5mM_02.xlsx"],...
	};
files_11PA = {...	
	["11PA_UT_01.xlsx","11PA_UT_02.xlsx"],...
	["11PA_2mM_01.xlsx", "11PA_2mM_02.xlsx"],...
	["11PA_5mM_01.xlsx", "11PA_5mM_02.xlsx"],...
	};
files_16PA = {...
	["16PA_UT_01.xlsx","16PA_UT_02.xlsx"],...
	["16PA_2mM_01.xlsx", "16PA_2mM_02.xlsx"],...
	["16PA_5mM_01.xlsx", "16PA_5mM_02.xlsx"],...
	};
%%

num2PA_sets = length(files_2PA);
num11PA_sets = length(files_11PA);
num16PA_sets = length(files_16PA);


% preallocate cells to store area, displacement, force, and stress for each sample set
area = cell(1, num2PA_sets);
displacement = cell(1, num2PA_sets);
force = cell(1, num2PA_sets);
stress = cell(1, num2PA_sets);

%% loop through each set of samples and generate stress-disp curves from xlsx data
for j = 1:num2PA_sets

    numSamples = length(files_2PA{j});
    
	% generate figure for current set of samples
	figure();

    for i = 1:numSamples

		% extract data from spreadsheet
        data = xlsread(files_2PA{j}{i});
        area{j}{i} = data(1, 5) / 1E6; % area converted to m^2
        displacement{j}{i} = data(:, 3); % displacement == travel distance of tester 
        force{j}{i} = data(:, 2); % Newtons
        
		% calculate stress in kPa
		stress{j}{i} = (force{j}{i} / area{j}{i}) / 1000; % kPa
        
		% generate one plot for each set (row of files cell array)
        plot(displacement{j}{i}, stress{j}{i}, 'LineWidth', 1.25);
        hold on

	end

end



%% GLOBAL FORMATTING FOR ALL FIGURES GENERATED

for k = 1:num2PA_Sets

	figure(k); % brings figure to focus

	ax = gca; 
		grid minor; box on;
		ax.XLabel.String = 'Displacement (mm)'; 
		ax.YLabel.String = 'Stress (kPa)';

end


%% FORMATTING 2PA_UT FIGURE 

f1 = figure(1);	f1.Name = '2PA_UT with 1.2 NCO:OH';
ax = gca;	
	% ax.YLim = [-750 8250];
	title('Untreated 1.2 NCO:OH Samples');
legend('2PA\_UT\01', '2PA\_UT\02','Location','northwest');

% formatting 2PA_2mM FIGURE
f2 = figure(2);	f2.Name = '2PA_UT';
ax = gca;
	% ax.YLim = [0 175];
	title('Untreated 1.2 NCO:OH Samples');

legend('1.2CR\_UT\_01', '2P\_UT\_2mM')










