close all;

path = fileparts(mfilename('fullpath')); 
delete(sprintf('%s/Output/Stimulus/*.xlsx', path));
addpath(sprintf('%s/Includes', path));

[filenames, path] = uigetfile({'*.abf'}, 'Select file(s)', 'MultiSelect', 'on');

if ~iscell(filenames) %if filenames is not an array
    filenames = {filenames}
end

number_of_files = length(filenames); 

RMP_all = zeros (1, number_of_files);

for i = 1:number_of_files
    fullname = strcat(path, filenames(i));
    data = abfload(char(fullname));
    duration_cut=5; %change here from what duration (s) resting membrane potential is determined
    
    if isempty(data)
        continue
    end
    
    filter = 10000;
    duration=duration_cut*filter;
    data = data (1:duration);
    
    fullname = sprintf('%s %d:%d', filenames{1});
    [RMP]=Analysis_RMP_pub(data, duration);
   
 RMP_all(i)=RMP;
 
end
    
    [ignore primary_filename] = fileparts(char(filenames(1)));
    
    if number_of_files>1
    excel_name = sprintf('%s\\RMP_%s_and_more.xlsx', path, primary_filename) %it tells the full path of the file
else
    excel_name = sprintf('%s\\RMP_%s.xlsx', path, primary_filename) 
    end

    column_header={'File','RMP'};
    warning('off', 'MATLAB:xlswrite:AddSheet');
    xlswrite(excel_name, column_header,'Sheet1','A1');
    xlswrite(excel_name, RMP_all','Sheet1', 'B2'); 
    xlswrite(excel_name, filenames','Sheet1', 'A2');
    
    'Finished.'
    