function patches = samplegrayIMAGES(patchsize,numpatches,IMAGES)
% sampleIMAGESpatches
pic=size(IMAGES);

patches = zeros(patchsize*patchsize, numpatches);

n=patchsize*patchsize;
for i=1:numpatches
    nimg=randi(pic(1,3));
    nx=randi(pic(1,1)-patchsize+1);
    ny=randi(pic(1,2)-patchsize+1);
    patches(:,i)=reshape(IMAGES(nx:nx+patchsize-1,ny:ny+patchsize-1,nimg),[n,1]);
end


end


