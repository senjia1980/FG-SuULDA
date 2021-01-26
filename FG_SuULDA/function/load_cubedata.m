function [ cube_data,Rows,Cols,B ] = load_cubedata( data_name,root_path )
%%
%loading 3D hyperspectral data
%eg: data_name='Indiana'; root_path='E:\FG_SuULDA';
%load_cubedata( data_name,root_path )
%%
%input
%data_name£ºHyperspectral dataset name
%root_path£ºWhere the data folder is located
%%
%output
%cubedata:R*C*B 3d hyperspectral data

%%
if strcmp( 'Indiana',data_name)||strcmp( 'indiana',data_name)
    file_name = strcat(root_path, '\data\Indiana\original_data\Indiana185_Ref.mat');
    load(file_name);
    Rows = Lines;Cols = Columns;B = L;
    cube_data=reshape(x',[Rows Cols B]);
    fprintf('The cube_data was loaded successfully:\n');
    fprintf('Indiana: depth=%d,  Rows*Cols£º%d*%d\n',B,Rows,Cols);
elseif strcmp( 'paviaU',data_name)||strcmp( 'PaviaU',data_name)||strcmp( 'Paviau',data_name)||strcmp( 'paviau',data_name)
    file_name = strcat(root_path, '\data\PaviaU\original_data\paviaU.mat');
    load(file_name);
    [Rows,Cols,B] = size(paviaU);
    cube_data = paviaU;
    fprintf('The cube_data was loaded successfully:\n');
    fprintf('PaviaU: depth=%d,  Rows*Cols£º%d*%d\n',B,Rows,Cols);
elseif strcmp( 'Houston',data_name)||strcmp( 'houston',data_name)
    file_name = strcat(root_path, '\data\Houston\original_data\2013_IEEE_GRSS_DF_Contest_CASI.tif');
    cube_data = imread(file_name);
    cube_data = double(cube_data);
    [Rows,Cols,B] = size(cube_data);
    fprintf('The cube_data was loaded successfully:\n');
    fprintf('Houston: depth=%d,  Rows*Cols£º%d*%d\n',B,Rows,Cols);
elseif strcmp( 'salinas',data_name)||strcmp( 'Salinas',data_name)
    file_name = strcat(root_path, '\data\Salinas\original_data\Salinas.mat');
    load(file_name);
    [Rows,Cols,B] = size(salinas);
    cube_data = salinas;
    fprintf('The cube_data was loaded successfully:\n');
    fprintf('Salinas: depth=%d,  Rows*Cols£º%d*%d\n',B,Rows,Cols);
elseif strcmp('Botswana',data_name)||strcmp('Botswana',data_name)
    file_name = strcat(root_path, '\data\Botswana\original_data\Botswana.mat');
    load(file_name);
    [Rows,Cols,B] = size(Botswana);
    cube_data = Botswana;
    fprintf('The cube_data was loaded successfully:\n');
    fprintf('Botswana: depth=%d,  Rows*Cols£º%d*%d\n',B,Rows,Cols);
else
    fprintf('Loaded data_name error.');
    
end
end

