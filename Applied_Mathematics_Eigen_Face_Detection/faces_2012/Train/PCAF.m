function[eigVec,MDT]=PCAF(Pathname)

All_features_train=dir(strcat(Pathname,'*.jpg'));
IMG = imread(All_features_train(1).name); % reading the all images in the training database
Mt=zeros(size(All_features_train,1),size(IMG,1)*size(IMG,2)); % making zeros for training image size
for i=1:length(All_features_train) % intialising the loop
    filename=sprintf('Train (%d).jpg',i);
    a=imread(filename);
    Grayscaleimage=rgb2gray(a);% coverting image in Training set to gray scale
    Mt(i,:)=reshape(Grayscaleimage',1,((size(a,1)*size(a,2)))); % converting image into vector form
end
p=size(All_features_train,1); 
Sigma_prime=(1/(p-1))*Mt'*Mt;% covariance matices
[eigVec eigval]=eigs(Sigma_prime); % computing eigen vectors and eigen values
MDT=Mt*eigVec; % Multiplying all training images with eigen vector to get training database