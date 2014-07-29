close all;
clear all;
directory_path_train='D:\Education\Projects\Applied Mathematics\PCA Project\faces_2012\faces_2012\normalized\TrainImage'; % file path
[eigVec,MDT]=PCAF(directory_path_train); % function to do PCA
filename = uigetfile('*.jpg','Select a face from test set','D:\Education\Projects\Applied Mathematics\faces_2012\faces_2012\TestImage\'); %Asking used to choose file
testf=imread(filename); % Reading input image choosen by the user
testface=rgb2gray(testf); % converting input image from RGB to Gray
[distance]=Input(testface,eigVec,MDT); % computing distance betwwen input image and database
smalldis=min(distance); % Taking the minimum distance from input and training database
ind=find(distance == smalldis); % Finding the indices of the recognised image from Training database
figure;
imshow(testf) % Displaying the input image on the console
cd('D:\Education\Projects\Applied Mathematics\PCA Project\faces_2012\faces_2012\normalized\TrainImage'); %changing directory
d=strcat('Train (',int2str(ind),').jpg');
figure;
imshow(d)% displaying the recognised image on the console
cd('D:\Education\Projects\Applied Mathematics\PCA Project\faces_2012\faces_2012\normalized\TestImage/') %changing directory
error=0;
