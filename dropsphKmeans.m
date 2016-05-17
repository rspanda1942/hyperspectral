function [center  , counts ]= dropsphKmeans(X, k, dropnum,iterations , on)

C=k;  % 聚类个数

center = normrnd(0,0.1,size(X,1),C);

% center = X(:,1:C);

center = normalize(center);
BATCH_SIZE=20000;
counts = zeros(k, 1);
dropn=fix(dropnum*C);

% dropsn=fix(0.8*size(X1,2));

for jj=1:iterations
    
%      dcounts = zeros(dropn, 1);
%     drops=randperm(size(X1,2));
%     X=X1(:,drops(1:dropsn));
    
    drop=randperm(C);
    dcenter=center(:,drop(1:dropn));
    
    
    
    Scenter = zeros(size(X,1),dropn);
    fprintf('K-means iteration %d / %d\n', jj, iterations);
    
    for i=1:BATCH_SIZE:size(X,2) %X输入的样本个数，分成小块
        lastIndex=min(i+BATCH_SIZE-1, size(X,2));%lastIndex=10000,20000,30000,...

        temp=X(:,i:lastIndex);
        
        cc=dcenter'*temp;
        
        [aa bb]=max(abs(cc));

         sss=zeros(dropn,size(temp,2));
         sss1=zeros(dropn,size(temp,2));
         
         for ii=1:size(temp,2)
         sss(bb(ii),ii)=dcenter(:,bb(ii))'*temp(:,ii);
         sss1(bb(ii),ii)=1;
         end

         counts(drop(1:dropn),1)=sum(sss1,2)+counts(drop(1:dropn),1);
         
         Scenter=temp*sss' + Scenter;
        
    end
         
         dcenter=dcenter + Scenter;
         center(:,drop(1:dropn))=center(:,drop(1:dropn))+dcenter;
         
         center = normalize(center);
         
         if on==1
         
         displayColorNetwork(center);
         drawnow;
         
         end
    
end