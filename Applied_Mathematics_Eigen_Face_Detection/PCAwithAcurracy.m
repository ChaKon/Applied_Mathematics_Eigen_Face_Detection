%%
clc; clear all; close all;
train_path = 'C:\Users\CHINNI\Desktop\APPLIED MATHS_PROJECT\faces_2012\Normalised\TrainImage\';
test_path = 'C:\Users\CHINNI\Desktop\APPLIED MATHS_PROJECT\faces_2012\Normalised\TestImage\';
train_files = dir([train_path '*.jpg']);
test_files = dir([test_path '*.jpg']);

IMG = imread([train_path train_files(1).name]);
p = length(train_files);
D = zeros(p, size(IMG,1)*size(IMG,2));

for i=1:p
    a = imread([train_path train_files(i).name]);
    D(i,:) = reshape(a', 1, size(a,1)*size(a,2));
end
k = 80;

% S = (D*D')/(p-1);
% [PM, E] = eigs(S, k);
% PM = D'*PM;

S = (D'*D)/(p-1);
[EigVec, EigVal] = eigs(S, k);

Mt = zeros(p, k);
Lm = {};
for i=1:p
    b = imread([train_path train_files(i).name]);
    Mt(i,:) = double(reshape(b', 1, size(b,1)*size(b,2))) * EigVec;
    label = strrep(train_files(i).name, '.jpg', '');
    Lm(i) = {label(1:end-1)};
end

% testing
error = 0;
for i=1:length(test_files)
    b = imread([test_path test_files(i).name]);
    vectimg = reshape(b', 1, size(b,1)*size(b,2));
    MDT = double(vectimg) * EigVec;
    vdiff = zeros(p,1);
    
    for j=1:p
        vdiff(j) = dist(MDT, Mt(j,:)');
    end
    
    % error counting
    label = Lm(find(vdiff==min(vdiff)));
    error = error + (isempty(strfind(test_files(i).name, cell2mat(label))));
    % printing
    disp([test_files(i).name, ' is recognized as ', cell2mat(label)]);
end

disp('The accuracy of the system is: '); 
accuracy = (1 - (error/length(test_files)))*100