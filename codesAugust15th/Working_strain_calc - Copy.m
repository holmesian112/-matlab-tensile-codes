clear
clc
%%
% Specify the filenames
filenames = {'1.6CR_dataset_01.xlsx','1.6CR_unknown_dataset_02.xlsx', '1.6CR_unknown_dataset_03.xlsx'}; % Add more filenames as needed
%%
% Loop through each filename
for k = 1:length(filenames)
    % Read the original data from the current Excel file
    [~, ~, raw] = xlsread(filenames{k});
    
    % Extract X and Y coordinates from the raw data
    X = cell2mat(raw(7:end, 9));
    Y = cell2mat(raw(7:end, 10));
    
    % Initialize variables
    num_points = size(X, 1);
    num_pairs = floor(num_points / 2);
    strain = zeros(num_pairs, 1);
    
    % Calculate original distance between the first pair of points
    original_distance = sqrt((X(2) - X(1))^2 + (Y(2) - Y(1))^2);
    
    % Calculate distance and strain for each pair of points
    for i = 1:num_pairs
        
		% Indices for the pair of points
        idx1 = 2*i - 1;
        idx2 = 2*i;
        
        % Calculate distance between the pair of points
        distance = sqrt((X(idx2) - X(idx1))^2 + (Y(idx2) - Y(idx1))^2);
        
        % Calculate strain
        strain(i) = (distance - original_distance) / original_distance;
	

	end
	

	strain = strain(~isnan(strain) & strain >= 0);

	% xlswrite(filenames{1,k}, strain, 1, ['K7:K' num2str(num_pairs+1)])
	
end


	
%% Write back to Excel file --> leave commented but copy/paste into command and modify
    % xlswrite(filenames{k}, raw);
	% 
    % % Append strain data as a new column to the Excel file
    % strain_column = [{'Strain'}; num2cell(strain)]; % Add title
    % xlswrite(filenames{k}, strain_column, 1, ['D1:D' num2str(num_pairs+1)]); 
	% xlswrite("0mM2C_4.xlsx", strain, 1, ['D1:D' num2str(num_pairs+1)])


