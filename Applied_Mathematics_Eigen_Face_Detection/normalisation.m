close all;
clear all;
Database_path='C:\Users\CHINNI\Desktop\APPLIED MATHS_PROJECT\faces_2012\'; % database for both test and train images
Testimages=[Database_path,'\Test\'];
Trainimages=[Database_path,'\Train\'];
TestImages=dir([Testimages '*.jpg']);
TestImages={TestImages.name};
TrainImages=dir([Trainimages '*.jpg']);
TrainImages={TrainImages.name};
%PredefinedFeatures = [9 32; 25 29;11 35;10 47; 23 46];% for Abraham1
PredefinedFeatures = [22 31;52 32;38 40;22 49;47 50];  %for kristina3
%  PredefinedFeatures = [11 24;36 22;22 31;14 43;33 42]; % for anthony2
error = 100;
  count = 0;
 %% 
 % facial features
 trainFeatures = dir([Trainimages '/*.txt']);
 trainFeaturesText = {trainFeatures.name};
 n1 = length(trainFeaturesText);  
 
 testFeatures = dir([Testimages '/*.txt']);
 testFeatures = {testFeatures .name};
 n2 = length(testFeatures);  
 
 N = n1 + n2;      %total images
 
 %% creating path
 NPathtrain = [ Database_path,'\Normalised\TrainImage\'];   % Normalised path for train image
 NPathtest = [ Database_path,'\Normalised\TestImage\'];    % Normalised path for test image
if(exist([NPathtrain]) ~= 7)
  mkdir(NPathtrain);
else
    rmdir(NPathtrain,'s');  
     mkdir(NPathtrain); 
end
if(exist([NPathtest]) ~= 7)  
    % create path
    mkdir(NPathtest);
else
    rmdir(NPathtest,'s');  
    mkdir(NPathtest);
end
 %% get facial features
 % train image 
 for i = 1:n1
     facialFeatures(:,:,i) = load([Trainimages,'/',trainFeaturesText{i}]);   
 end
 %test image
for i = 1:n2
    facialFeatures(:,:,i+n1) = load([Testimages,'/',testFeatures{i}]);
end
%%
  Fbar = zeros(5,2);  %average features
  Fpre = zeros(5,2); %prev features
 
  %% calculation of best transformed features position 
  while error>0.00000001
      Fsum = zeros(5,2);     %stores zeros with 5x2
      Initial = PredefinedFeatures ; % for initially determined features
      
      for i=1:N     %for all test and train images
          
          if(i==1 && count~=0)        
              Features = Fbar;    
          else
             Features = facialFeatures(:,:,i);   
          end
          
        Fi = [Features ones(5,1)];  %facial features
   
         Afinemat = Fi\Initial;       % calculating affine trax matrix based on Fp and Facial features       
         Fd = Fi*Afinemat;       %aligned features
         
        if i==1
            Initial = Fd ;  % Fd will be used as Fp for remaing faces
            Fsum = 0;
        else
            Fsum = Fsum + Fd; %sum of 
        end   
      end
      Fbar = Fsum/(N-1);  % calculating avergae value
      error = norm(Fbar - Fpre); % calulatiing error between succesive iterations
      count = count +1;
      Fpre = Fbar; % set prev = current
  end
  Ftotal = Fbar
%% afffine transformation
  trainmat = zeros(n1,64*64);
  testmat = zeros(n2,64*64); 
 for i = 1:N
     
     if i<=n1
         imageFile = [Trainimages,TrainImages{i}]; % train image filename
     else
         imageFile = [Testimages,TestImages{i-n1}]; % test image filename
     end
       im = imread(imageFile); % read image
         
        FeaturesLoaded = facialFeatures(:,:,i); 
        im = double(im);
        
        Fi = [FeaturesLoaded ones(5,1)];  
        Asvd = Fi\Ftotal;                       
        TransMatrix = [Asvd';[0 0 1]];  % affine transformation matrix
        
        X = zeros(1,64*64);
        Y = zeros(1,64*64);
        Z = zeros(64,64);
        for r= 1: 64
            for c= 1: 64
                ip = [r;c;1];
                output=  TransMatrix\ip;   % inverse transformation
                X((r-1)*64 + c) = output(1); 
                Y((r-1)*64 + c) = output(2);
                Z(c,r)=im(c,r);
            end
        end
 % interpolation some pixels will have decimals to avoid that using
 % interpt2
       interpolation = uint8(interp2(Z,X,Y,'cubic'));
        for r = 1:64
            for c = 1:64
                imO(c,r) = interpolation((r-1)*64 + c) ;
            end
        end
   %adapthisteq for equalization pixel intensity
        imO = adapthisteq(uint8(imO));   
 %    image into vector
        x = reshape(imO',1,64*64);  
%
        if(i<=n1)
            trainmat(i,:) = double(x);
            %saving normalised images
             imageFileop = [NPathtrain TrainImages{i}]; 
        else
            testmat(i-n1,:) = double(x);
             %saving normalised images
            imageFileop = [NPathtest TestImages{i-n1}];
        end
      imwrite(uint8(imO),imageFileop,'jpg');  % save normalised image 
 end
 display('Finished Normalization');
 