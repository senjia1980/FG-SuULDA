function [ out_put ] = data_normalized( cell_data )
n_cell  = size(cell_data,2);
out_put = [];

for i = 1:n_cell
    [w,h,r] = size(cell_data{i});
    data = cell_data{i};
    if isreal(data)
        data = reshape(data,[w * h r]);
        data = mapminmax(data,0,1);
        out_put= cat(2, out_put, data);
    end
end

