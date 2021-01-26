function [ num_classes,trainall,train_sec_idx ] = load_CF_data_3to15( data_name,root_path )
%%
%Loading label, training sample and test sample for classification
%load_CF_data( data_name,root_path )
%% input
%data_name: Hyperspectral dataset name
%root_path: Where the data folder is located
%% output
%num_classes: class number
%trainall: indexes and labels of the labeled samples
%train_sec_idx: the indexes of the training samples which are randomly sselected. 
%%
if strcmp( 'Indiana',data_name)||strcmp( 'indiana',data_name)
    path_trainall = strcat(root_path, '\data\Indiana\original_data\trainall_3to15.mat');
    path_train = strcat(root_path, '\data\Indiana\original_data\Indiana_train_sec_idx_3to15.mat');
    load(path_trainall);
    load(path_train);
    trainall = trainall_3to15;
    train_sec_idx = train_sec_idx_3to15;
    num_classes = 16;
    fprintf('Successfully loaded the Indiana labels and training set:3-15\n');
elseif strcmp( 'Botswana',data_name)||strcmp( 'botswana',data_name)
    path_trainall = strcat(root_path, '\data\Botswana\original_data\trainall_3to15.mat');
    path_train = strcat(root_path, '\data\Botswana\original_data\Botswana_train_sec_idx_3to15.mat');
    load(path_trainall);
    load(path_train);
    trainall = trainall_3to15;
    train_sec_idx = train_sec_idx_3to15;
    num_classes  = 14;
    fprintf('Successfully loaded the Botswana labels and training set:3-15\n');
elseif strcmp( 'Houston',data_name)||strcmp( 'houston',data_name)
    path_trainall = strcat(root_path, '\data\Houston\original_data\trainall_3to15.mat');
    path_train = strcat(root_path, '\data\Houston\original_data\Houston_train_sec_idx_3to15.mat');
    path_contest_gt_va= strcat(root_path,'\data\Houston\original_data\contest_gt_va.tif');
    path_Houston_Tr = strcat(root_path,'\data\Houston\original_data\Houston_Tr.mat');
    file_Tr = load(path_Houston_Tr);
    load(path_trainall);
    load(path_train);
    trainall = trainall_3to15;
    train_sec_idx = train_sec_idx_3to15;
    file_gt = imread(path_contest_gt_va);
    map = file_Tr .TR + double(file_gt/17);
    labels = unique(map);
    labels = labels(2:end);
    num_classes = length(labels);
    fprintf('Successfully loaded the Houston labels and training set:3-15\n');
elseif strcmp( 'paviaU',data_name)||strcmp( 'PaviaU',data_name)||strcmp( 'Paviau',data_name)||strcmp( 'paviau',data_name)
    path_trainall = strcat(root_path, '\data\PaviaU\original_data\trainall_3to15.mat');
    path_train = strcat(root_path, '\data\PaviaU\original_data\PaviaU_train_sec_idx_3to15.mat');
    path_PaviaU_gt = strcat(root_path,'\data\PaviaU\original_data\PaviaU_gt');
    file_gt = load(path_PaviaU_gt);
    load(path_trainall);
    load(path_train);
    trainall = trainall_3to15;
    train_sec_idx = train_sec_idx_3to15;
    labels = double(file_gt.paviaU_gt);
    labels = unique(labels);
    labels = labels(2:end);
    num_classes = length(labels);
    fprintf('Successfully loaded the PaviaU labels and training set:3-15\n');
elseif strcmp( 'salinas',data_name)||strcmp( 'Salinas',data_name)
    path_trainall = strcat(root_path, '\data\Salinas\original_data\trainall_3to15.mat');
    path_train = strcat(root_path, '\data\Salinas\original_data\Salinas_train_sec_idx_3to15.mat');
    path_Salinas_gt = strcat(root_path,'\data\Salinas\original_data\Salinas_gt');
    file_gt = load(path_Salinas_gt);
    load(path_trainall);
    load(path_train);
    trainall = trainall_3to15;
    train_sec_idx = train_sec_idx_3to15;
    labels = unique(file_gt.salinas_gt);
    labels = labels(2:end);
    num_classes = length(labels);
    fprintf('Successfully loaded the Salinas labels and training set:3-15\n');
else
    fprintf('Loaded data_name error.');
end
end


