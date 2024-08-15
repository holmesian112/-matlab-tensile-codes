%% TANGENT MODULUS CALCULATIONS
clear; 
clc;
format compact;
close all;


%% load files for datasets that have been processed and include strain data in 'K'
filenames = {...
	["1.6CR_dataset_01.xlsx","1.6CR_unknown_dataset_02.xlsx", "1.6CR_unknown_dataset_03.xlsx"],
	}; 

%%
numSets = length(filenames);
target_strain = 0.10; % 10 percent strain location --> can be adjusted 



tangentSlopes = cell(1,numSets); % initialize empty cell 

% fist, iterate through sets then iterate through each file

numSets = length(filenames);

for j = 1:numSets

    numFiles = length(filenames{j});
    % figure();
	tangentSlopes{j}= [];

    for i = 1:numFiles

		    data = xlsread(filenames{j}{i});
			areas = data(1,3) / 1E6;
			length_strain_column = data(3,11);

			strain = data(7:length_strain_column, 11);
			force = data(7:end, 2);

			stress = (force/areas) / 1000;

			% tangentslope
			[~, index] = min(abs(strain - target_strain));
			tangentSlopes{j} = [tangentSlopes{j}, stress(index) / strain(index)];

	
	end

end

tangentSlopes
averagetanSlope = cellfun(@mean, tangentSlopes)/1000
tanSTD = cellfun(@std, tangentSlopes)/1000

figure();

x1 = categorical({'Untreated'});
scatter(x1, averagetanSlope, 75, 'red','d', 'filled');
hold on
grid minor
errorbar(x1, averagetanSlope, tanSTD, 'k.', 'Linewidth', 0.75, 'HandleVisibility','off');
t = title('Tangent Modulus at 10% strain');
ax = gca;
ax.YLim = [0 15];
ax.YLabel.String = 'Tangent Modulus (MPa)';

