close all;
clear all;
directory_path_train='C:\Users\CHINNI\Desktop\APPLIED MATHS_PROJECT\faces_2012\Normalised\TrainImage\'; % file path
directory_path_test='C:\Users\CHINNI\Desktop\APPLIED MATHS_PROJECT\faces_2012\Normalised\TestImage\';
train_files = dir([directory_path_train '*.jpg']);
test_files = dir([directory_path_test '*.jpg']);
[eigVec,Mt]=PCAF(train_files,directory_path_train); % function to do PCA
filename = uigetfile('*.jpg','Select a face from test set','C:\Users\CHINNI\Desktop\APPLIED MATHS_PROJECT\faces_2012\Normalised\TestImage\'); %Asking used to choose file
testf=imread([directory_path_test filename]); % Reading input image choosen by the user
%testface=rgb2gray(testf); % converting input image from RGB to Gray
[distance]=Input(testf,eigVec,Mt); % computing distance betwwen input image and database
smalldis=min(distance); % Taking the minimum distance from input and training database
ind=find(distance == smalldis); % Finding the indices of the recognised image from Training database
figure;
imshow(testf) % Displaying the input image on the console
cd('C:\Users\CHINNI\Desktop\APPLIED MATHS_PROJECT\faces_2012\Normalised\TrainImage\'); %changing directory
%d=strcat('Train (',int2str(ind),').jpg');

label = train_files(find(distance== smalldis));
%  X =([strfind(test_files(ind).name, cell2mat(label.name))]);
for m = 1:81
TF = strcmp(label.name,train_files(m).name);

if (TF == 1)
    outputname = train_files(m).name;
end
end
display(outputname);
%d=train_files(ind).name;
 figure;
imshow(label.name)% displaying the recognised image on the console
cd('C:\Users\CHINNI\Desktop\APPLIED MATHS_PROJECT\faces_2012\Normalised\TestImage\') %changing directory
