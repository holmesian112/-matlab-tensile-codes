%%	HEADER BLOCK

%   DESCRIPTION:
%       THIS CODE PROCESSES THE STRESS AND DISPLACEMENT DATA FOR EACH SAMPLE TO 
%       CALCULATE THE ULTIMATE STRENGTH OF EACH SAMPLE. THE VALUES NEEDED ARE:
%           1. AREA OF EACH CROSS-SECTION
%           2. STRESS -- LOADING CURVES TO FIND THE MAX STRESS VALUE
%           3. DISPLACEMENTS -- USE TO FIND CORRESPONDING STRAIN FOR MAX STRESS

% %%%%%%%%%%%%%%%%%%%%%%%%%%%         BEGIN CODE      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; clc; close all; format compact;


%% IMPORT XLSX DATA
untreated_files = {...
    ["1.6CR_dataset_01.xlsx", "1.6CR_dataset_04.xlsx", "1.6CR_dataset_05.xlsx"],
    }; % update this as future tests are done
unknown_files = {...
	["1.6CR_unknown_dataset_02.xlsx", "1.6CR_unknown_dataset_03.xlsx"],
	}; % unknown files
%% PROCESS UNTREATED SAMPLE DATA 

numSets = cellfun(@length, untreated_files); % finds number of cells INSIDE "files" (1x1 cell)

for j = 1:length(untreated_files)
    % length(files) = 1 (files=1x1 cell)
    currentFile = untreated_files{j};
    currentNum = numSets(j);

    % initialize empty cells/arrays with length according to number of data for each sample
    areas = cell(1, currentNum); 
    strengths = zeros(1, currentNum);
    displacement = zeros(1, currentNum);

    % iterate through each cell inside files{1,1} to find string of excel name
    % and load each sample dataset
    for i = 1:currentNum

        data = xlsread(currentFile{i});

        % areas are defined in 'C1' of each spreadsheet == data(1,3) in units mm^2
		areas{i} = data(1,3) / 1E6; % creates cell size 1x(number of files)
		strengths(i) = (max(data(7:end, 2)) / areas{i}) / 1000; % kPa 

		% find index values of the max/ultimate strength values
		[~, maxStrengthIndex] = max(data(7:end, 2));

		% corresponding displacements for each max strength and create array of them
		displacement(i) = data(maxStrengthIndex, 3);
	end
	
	% find average and std for strength values and displacements
	average_strength(j) = mean(strengths);
	std_strengths(j) = std(strengths);
	average_displacement(j) = mean(displacement);
	std_displacement(j) = std(displacement);
end
%% PROCESS UNKNOWN DATASETS
num_unknown_Sets = cellfun(@length, unknown_files); % finds number of cells INSIDE "files" (1x1 cell)

for j = 1:length(unknown_files)
    % length(files) = 1 (files=1x1 cell)

    currentFile = unknown_files{j};
    currentNum = num_unknown_Sets(j);

    % initialize empty cells/arrays with length according to number of data for each sample
    unknown_areas = cell(1, currentNum); 
    unknown_strengths = zeros(1, currentNum);
    unknown_displacement = zeros(1, currentNum);

    % iterate through each cell inside files{1,1} to find string of excel name
    % and load each sample dataset
    for i = 1:currentNum

        data = xlsread(currentFile{i});

        % areas are defined in 'C1' of each spreadsheet == data(1,3) in units mm^2
		unknown_areas{i} = data(1,3) / 1E6; % creates cell size 1x(number of files)
		unknown_strengths(i) = (max(data(7:end, 2)) / unknown_areas{i}) / 1000; % kPa 

		% find index values of the max/ultimate strength values
		[~, maxStrengthIndex] = max(data(7:end, 2));

		% corresponding displacements for each max strength and create array of them
		unknown_displacement(i) = data(maxStrengthIndex, 3);

	end
	
	% find average and std for strength values and displacements
	unknown_average_strength(j) = mean(unknown_strengths);
	unknown_std_strengths(j) = std(unknown_strengths);
	unknown_average_displacement(j) = mean(unknown_displacement);
	unknown_std_displacement(j) = std(unknown_displacement);
end
%% GENERATE SCATTER PLOTS FOR ULTIMATE STRENGTH CALCULATIONS

fig = figure(); hold on; grid on; box on;

x = categorical({'Untreated', 'Unknown'});
x = reordercats(x, {'Untreated', 'Unknown'});

% plotting untreated concentrations
scatter(x(1), average_strength/1000, 125,'x', 'red');
errorbar(x(1), average_strength/1000, std_strengths/1000, 'LineWidth', 1.25)

% plotting unknown concentrations
scatter(x(2), unknown_average_strength/1000, 100, 'kd');
errorbar(x(2), unknown_average_strength/1000, unknown_std_strengths/1000, 'LineWidth',1.25)


% FORMATTING
grid on; box on;
ax = gca;
ax.XLabel.String = 'Concentration (mM)';
ax.XLabel.FontSize = 14;
ax.YLabel.String = 'Ultimate Strength (MPa)';
ax.YLabel.FontSize = 14;




%% WRITE RESULTS IN COMMAND WINDOW
clc
fprintf('The ultimate strength (kPa) of the untreated HTPB-TiO2 samples was: \n');

strengths
fprintf('\n');
fprintf('The ultimate strengths (kPa) of the unknown HTPB-TiO2 samples was: \n');
unknown_strengths

