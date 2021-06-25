function [RMP] = Analysis_RMP_pub(data, duration)

    if nargin < 5 
        filter = 10000; %change the filter here
    end

    if nargin < 6
        filename = 'Data file'; 
    end

    if nargin < 7
        output_folder = 'Default'; 
    end
   
        RMP = mean(data);
end