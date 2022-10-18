clear; clc; close all;

global plength lengthv lengthh
df = readmatrix('I3SYSTEM_test_12th_500nm_WlensH_v1_aver7x7_rot_GUI.csv');
plength = 0.02;     %   pixel size
lengthv = 50;       %   vertical length
lengthh = 50;       %   horizontal length

%% ====== rotation ====== %%
df_r = imrotate(df, -6);
writematrix(df_r, 'rotation.csv');

%% ====== scale ====== %%
make = zeros(size(df_r,1), floor((size(df_r,1)-size(df_r,2))/2));
make1 = zeros(size(df_r,1), ceil((size(df_r,1)-size(df_r,2))/2));
df1 = horzcat(make, df_r, make1);

%% ====== main ====== %%
plot3d(df1)
plot2d(df_r)