clear all;clc

path=cd;
addpath('.\function');
addpath('.\GaborFunction');

%% Parameter Settings
data_name = 'Salinas';
data_resolution = 3.7;
si=25;
parameters_K = {[2,2,2,2],[1,1,1,1],[2,1,2,2],[2,2,1,2],[1,2,2,2]};
fixed_sample_num = [3:15];
ite_num = 10;
root_path = 'F:\zqq\FG_SuULDA';

path_dir = [root_path,'\data\',data_name,'\feature_data'];
if ~exist(path_dir) 
    mkdir(path_dir )         
end 


%% Loading data
[cube_data,R,C,B]=load_cubedata( data_name,root_path );
[num_classes,trainall,train_sec_idx] = load_CF_data_3to15(data_name,root_path );
num_pixel = R*C;


%% Parallel computing
% if parpool('local')<=0
%     parpool('open','local',8);
% else
%     disp('Already initialized'); 
% end


%% Superpixel segmentation
supixel_num = floor(R*C/(1000*(0.7^sqrt(data_resolution))));
channels = supixel_num- 1;
label_ers = mymex_ers(cube_data,supixel_num);
label_ers = reshape(label_ers,[R*C 1]);


%% Constructing multi-scale gabor features
feature_data = Create3DGabor(cube_data, label_ers, channels, si, parameters_K);


%% SVM CLASSIFICATION
for num_fixed_sample = 1:length(fixed_sample_num)
   
    labeled_num = size(trainall,2);
    SPARSE.rate = zeros(num_classes+2, ite_num);
    SPARSE.kappa = zeros(1,ite_num);
    SPARSE.predict_test_label = cell(ite_num,1);
    SPARSE.predict_all_label = cell(ite_num,1);
    SPARSE.elapsed_time = zeros(ite_num,1);
%     SPARSE.predict_all_test_label = cell(ite_num,1);
    
    for ite = 1:ite_num
        tstart = tic;
        fprintf('========================================================\n');
        fprintf('Iteration  %i...\n',ite);
        % training data
        gallery_indexes = train_sec_idx{num_fixed_sample,ite};
        gallery_idx_samples = trainall(:,gallery_indexes);
        gallery_labels=gallery_idx_samples(2,:);
        gallery_labels=gallery_labels';
        gallery_feature = feature_data(:,gallery_idx_samples(1,:));
        % testing data
        probe_indexes = setdiff(1:labeled_num,gallery_indexes);
        probe_idx_samples = trainall(:,probe_indexes);
        probe_labels=probe_idx_samples(2,:);
        probe_feature = feature_data(:,probe_idx_samples(1,:));
        
        % cross validation
        best_accuracy = 0;
        k_fold = 10;
        chose_c = -10
        for c=-10:10
            Expc = 2^c;
            param_str = sprintf('-t 0 -c %f',Expc);
            fprintf('%s', param_str);
            indices=crossvalind('Kfold',size(gallery_feature,2),k_fold);
            tmp_accuracy=zeros(k_fold,1);
            parfor k=1:k_fold
                test=find(indices==k);train=find(indices~=k);
                model = lib_svmtrain(gallery_labels(train,1),gallery_feature(:,train)', param_str);
                [predict_label, accuracy, prob_estimates] = ...
                    lib_svmpredict(gallery_labels(test,1),gallery_feature(:,test)', model);
                tmp_accuracy(k)=accuracy(1);
            end
            mean_accuracy=mean(tmp_accuracy);
            clear tmp_accuracy;
            if best_accuracy < mean_accuracy
                chose_c = c;
                best_accuracy = mean_accuracy;
            end
        end
        
        % Testing
        Expc = 2^chose_c;
        fprintf('The optimal penalty factor is %i\n', Expc);
        param_str = sprintf('-t 0 -c %f',Expc);
        fprintf('%s', param_str);
        model = lib_svmtrain(gallery_labels, gallery_feature', param_str);
        [p_results, accuracy, dec_values] = lib_svmpredict(probe_labels', probe_feature', model);
        class=p_results';
        %-------- Add background points -------------------------
%         all_test_indexs = setdiff(1:num_pixel, gallery_idx_samples(1,:));
%         all_test_labels = ones(1,size(all_test_indexs,2));
%         all_test_feature = feature_data(:,all_test_indexs);
%         [all_results, ~, ~] = lib_svmpredict(all_test_labels', all_test_feature', model);
%         all_class=all_results';
        %-------- Add background points -------------------------
        fprintf('The model with the optimal penalty factor of %iwas trained \n', Expc);
        
        % CA, OA£¬AA, KAPPA
        [OA_class,kappa_class,AA_class,CA_class] = calcError( probe_idx_samples(2,:), ...
            class, 1: num_classes);
        OA_class
        SPARSE.rate(1:num_classes, ite) =CA_class;
        SPARSE.rate(num_classes+1, ite) = OA_class;
        SPARSE.rate(num_classes+2, ite) =AA_class;
        SPARSE.kappa(ite) = kappa_class;
        SPARSE.elapsed_time(ite) = toc(tstart);
        predict_test_label = [probe_idx_samples(2,:);class];
        SPARSE.predict_test_label{ite,1} = predict_test_label;
        %-------- Add background points -------------------------
%         SPARSE.predict_all_test_label{ite,1} = all_class;
        %-------- Add background points -------------------------
        SPARSE.predict_all_label{ite,1} = class;
    end
    SVM_result{1,num_fixed_sample} = SPARSE;
end
save_dir = [path_dir,'\SVM_result'];
save(save_dir,'SVM_result' );