function [ ...
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
] = parse_pub(data, duration, stimulus_artifacts, sweeps, filter)

thresh_AP = -50; %set threshold to pass to be considered as firing an AP

AP_times = zeros(sweeps, 1);
AP_max = -1000;
declining = 0;
AP_times_number = 0;
AP_sizes = zeros(10, 1);
AP_min_list = zeros(10, 1);
hw_list = zeros(sweeps, 1);
ap_threshold_list = zeros(sweeps, 1);
max_second_derivatives=zeros(sweeps, 1);
RMP = zeros (sweeps, 1);
width = zeros(sweeps,1);

for j = 1:sweeps
    sweep_data = data(1:duration, j); 
    RMP (j) = mean(sweep_data (1:1770));
    
    start_i = -1;
    finish_i = -1;
    width_start = -1;
    width_finish = -1;
    
    for i = 1:duration
        if sweep_data(i) > thresh_AP || (declining == 0 && AP_max > thresh_AP)
            if declining == 0
                if start_i == -1
                    for ii = i:-1:6
                        start_i = ii;
                        if sweep_data(ii) - sweep_data(ii-1) <= 0
                            break;
                        end
                    end
                end
                
                if sweep_data(i) > -20 && width_start == -1
                    width_start = i;
                end
               
                if sweep_data(i) > AP_max
                    AP_max = sweep_data(i);
                else
                    declining = 1;
                    AP_times_number = AP_times_number + 1;
                    AP_times(j) = i - 1;
                    AP_sizes(j) = AP_max;
                end
            end
        else            
            if declining == 1 && sweep_data(i) > sweep_data(i-1) && AP_times_number > 0
                declining = 0;
                AP_min_list(j) = sweep_data(i-1);
                AP_hh = AP_sizes(j) - (AP_sizes(j) - AP_min_list(j)) / 2;
                AP_max = -10000;
                
                if finish_i == -1
                    for ii = i:duration
                        finish_i = ii;
                        if sweep_data(ii) - sweep_data(ii-1) >= 0
                            break;
                        end
                    end
                end
            end
        end
        
        if declining == 1 && sweep_data(i) < -20 && width_finish == -1
            width_finish = i - 1;
        end
    end
    
    width(j) = width_finish - width_start;
    
    if start_i < 1 || finish_i < 1
        AP_times(j) = stimulus_artifacts(j);
        continue;
    end
    
    half_start_i = -1;
    for i = 1:(duration - 1)
        if half_start_i == -1 && sweep_data(i) <= AP_hh && sweep_data(i+1) >= AP_hh
            half_start_i = i;
        end
        
        if half_start_i ~= -1 && sweep_data(i) >= AP_hh && sweep_data(i+1) <= AP_hh
            half_finish_i = i;
            hw_list(j) = half_finish_i - half_start_i;
            break;
        end
    end
    
    min_threshold = 1; % 10V/s
    dvdt = diff(sweep_data(1:duration))./(diff(1:duration)/10)';
    
    for k = 2:(duration-1)
        if dvdt(k) > min_threshold
            ap_threshold_list(j) = sweep_data(k-1);
            break;
        end
    end
    
    max_second_derivatives(j) = 0;
    for k = start_i:finish_i
        if dvdt(k+1) - dvdt(k) > max_second_derivatives(j)
            max_second_derivatives(j) = dvdt(k+1) - dvdt(k);
        end
    end
end

AP_sizes = AP_sizes(1:sweeps);
AP_min_list = AP_min_list(1:sweeps);
AP_actual_sizes = AP_sizes-AP_min_list;
Latency = (AP_times-stimulus_artifacts')./filter;

end