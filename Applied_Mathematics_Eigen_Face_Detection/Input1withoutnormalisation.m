function[distance]=Input1withoutnormalisation(ipim,eigv,trainims)
Ip=reshape(ipim',1,(size(ipim,1)*size(ipim,2))); % changing input image into vector form
Ip=double(Ip);
Ipeigvec=Ip*eigv; % multiplying input image with eigen vector
distance=dist(Ipeigvec,trainims');% calculating distance and returns distance value to main