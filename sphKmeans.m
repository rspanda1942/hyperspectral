function [center , counts ]= sphKmeans(X, k, iterations)

C=k;  % 聚类个数
center = normrnd(0,0.1,size(X,1),C);
center = normalize(center);
BATCH_SIZE=50000;
% counts = zeros(k, 1);

for jj=1:iterations
    
    counts = zeros(k, 1);
    

    Scenter = zeros(size(X,1),C);
    fprintf('K-means iteration %d / %d\n', jj, iterations);
    
    for i=1:BATCH_SIZE:size(X,2) %X输入的样本个数，分成小块
        lastIndex=min(i+BATCH_SIZE-1, size(X,2));%lastIndex=10000,20000,30000,...

        temp=X(:,i:lastIndex);
        
        cc=center'*temp;
        
        [aa bb]=max(abs(cc));

         sss=zeros(k,size(temp,2));
         sss1=zeros(k,size(temp,2));
         
         for ii=1:size(temp,2)
         sss(bb(ii),ii)=center(:,bb(ii))'*temp(:,ii);
         sss1(bb(ii),ii)=1;
         end

         counts=sum(sss1,2)+counts;
         
         Scenter=temp*sss' + Scenter;
        
    end
         
         center=center + Scenter;
         
        center = normalize(center);
    displayColorNetworkNew(center);
    drawnow;
    
    
end


