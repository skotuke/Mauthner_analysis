close all;

path = fileparts(mfilename('fullpath'));
addpath(sprintf('%s/common', path));

[filenames, path] = uigetfile({'*.abf'}, 'Select file(s)', 'MultiSelect', 'on');
if ~iscell(filenames) % if filenames is not an array
    filenames = {filenames};%make it into one element array
end

number_of_files = length(filenames); 
m = 1;

% Set the distance (um) between the stimulating and recording electrodes here.
% This value has to be adjusted for each individual fish.
distance = 1722/1000000;

% For how many sweeps do you want to preprovision arrays (use number from the 
% file with most sweeps in it)
sweeps = 10;

% Set the filter frequency here. 
filter = 100000; 
use_virtual_sweeps = 0;

% Stimulus artifact timing can be adjusted here (s).If use_virtual_sweeps is 0, you can set one artifact, which will be taken
% be used in every sweep. 
stimulus_artifact = 0.17813 * filter; 

% If you have all the action potentials in one sweep, you can instead set
% the list of artifacts in the list above. To use it, you need to set
% use_virtual_sweeps to 1.
%virtual_sweeps = virtual_sweeps_30hz;

k_rows = 4;
k_spot = 0;
k_figure = 0;

AP_times_all = zeros(sweeps, number_of_files);
AP_actual_sizes_all = zeros(sweeps, number_of_files);
Latency_all = zeros(sweeps, number_of_files);
speed_all = zeros(sweeps, number_of_files);
hw_list_all = zeros(sweeps, number_of_files);
max_second_derivatives_all=zeros(sweeps, number_of_files);
RMP_all = zeros(sweeps, number_of_files);
CV_all = zeros(sweeps, number_of_files);
Latency_all_means = zeros(1, number_of_files);
Latency_all_std = zeros(1, number_of_files);
width_list_all = zeros(sweeps, number_of_files);

for i = 1:number_of_files
     
    filename = filenames(i);
    fullname = strcat(path, filenames(i));
    data = abfload(char(fullname));
    
    if isempty(data)
        continue % data could not be loaded
    end
    
    % Preview file
    duration = size(data, 1);
    sweeps = size(data, 3);
    duration_s = (1 / filter):(1 / filter):(duration / filter);
    
    if use_virtual_sweeps
       sweeps = length(virtual_sweeps); 
       raw_data = data(1:duration, 1);
       data = zeros(duration, sweeps);
       
       for vs = 1:sweeps
          data(1:duration, vs) = raw_data;
          data(1:ceil(virtual_sweeps(vs)), vs) = raw_data(ceil(virtual_sweeps(vs)));
          if vs < sweeps
              data(ceil(virtual_sweeps(vs + 1)):duration, vs) = raw_data(ceil(virtual_sweeps(vs + 1)));    
          end
       end
       
       stimulus_artifacts = virtual_sweeps;
    else 
        stimulus_artifacts(1:sweeps) = stimulus_artifact; 
    end
    
    
    k_figure = k_figure + 1;
    total_length = floor(duration * sweeps / filter);
    
    [ ...
        AP_times, ...
        AP_actual_sizes, ...
        Latency, ...
        AP_times_number, ...
        hw_list, ...
        max_second_derivatives, ...
        RMP, ...
        width, ...
        width_start, ...
        width_finish ...
    ] = parse_pub(data, duration, stimulus_artifacts, sweeps, filter);
    m = m + 1;
    
    AP_times_all (:,i) = AP_times(1:sweeps);
    AP_actual_sizes_all (:,i) = AP_actual_sizes;
    
    Latency_all (:,i) = Latency (1:sweeps);
    speed_all (:,i) = distance./Latency;
    for k = 1:length(Latency)
        if speed_all(k,i) == Inf
            speed_all(k,i) = 0;
        end
    end    
    
    CV(:,i) = std(Latency_all)/mean(Latency_all);
    hw_list_all(:,i) = hw_list(1:sweeps)./filter*1000;
    width_list_all(:,i) = width(1:sweeps)./filter*1000;
    max_second_derivatives_all(:,i) = max_second_derivatives (1:sweeps)*filter/1000;
    end

AP_actual_sizes_all( :, ~any(AP_actual_sizes_all,1) ) = [];%deletes columns with 0s
Latency_all( :, ~any(Latency_all,1) ) = [];%deletes columns with 0s
speed_all( :, ~any(speed_all,1) ) = [];%deletes columns with 0s
CV( :, ~any(CV,1) ) = [];%deletes columns with 0s
hw_list_all( :, ~any(hw_list_all,1) ) = [];%deletes columns with 0s
width_list_all( :, ~any(width_list_all,1) ) = [];%deletes columns with 0s
max_second_derivatives_all( :, ~any(max_second_derivatives_all,1) ) = []; %deletes columns with 0s

[ignore primary_filename] = fileparts(char(filenames(1)));

if number_of_files>1
    excel_name = sprintf('%s\\AP velocity_%s_and_more.xlsx', path, primary_filename) %it tells the full path of the file
else
    excel_name = sprintf('%s\\AP velocity_%s.xlsx', path, primary_filename) %it tells the full path of the file
end

if use_virtual_sweeps == 1;
    filenames(:,[7 9 11]) = []; %deletes the columns 7 9 11 where 300, 500 and 1000 Hz are
end 

warning('off', 'MATLAB:xlswrite:AddSheet');
row_header={'1', '2', '3', '4', '5', '6', '7', '8', '9', '10', ' ', 'Length(m)'};
row_header2={'1', '2', '3', '4', '5', '6', '7', '8', '9', '10'};
xlswrite(excel_name, row_header2', 'Latency','A4');
xlswrite(excel_name, [filenames], 'Latency', 'B3');
xlswrite(excel_name, Latency_all*1000, 'Latency', 'B4');
xlswrite(excel_name, row_header', 'Velocity','A4');
xlswrite(excel_name, [filenames], 'Velocity', 'B3');
xlswrite(excel_name, speed_all, 'Velocity', 'B4');
xlswrite(excel_name, distance, 'Velocity','B15');
xlswrite(excel_name, distance, 'Velocity','B15');
xlswrite(excel_name, row_header2', 'AP sizes','A4');
xlswrite(excel_name, [filenames], 'AP sizes', 'B3');
xlswrite(excel_name, AP_actual_sizes_all, 'AP sizes', 'B4');
xlswrite(excel_name, row_header2', 'AP HW','A4');
xlswrite(excel_name, [filenames], 'AP HW', 'B3');
xlswrite(excel_name, hw_list_all, 'AP HW', 'B4');

'Finished.'