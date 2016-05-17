function [trainS  , textS ]= RandTrainSample(label , percent)
% label = n * 1
Numlab=max(label);  %类别个数
Train=[];  %train
Ttext=[];  %text

  for i=1:Numlab
  labT=find(label==i);
  news=randperm(size(labT,1))';
  te=fix(size(news,1)*percent);

    if percent > 1
       te = percent;
    end

    if percent > size(labT,1)
       te=15;
    end

  labT2=labT(news(1:te));
  labT3=labT(news(te+1:end));

  Train=[Train;labT2];
  Ttext=[Ttext;labT3];
  end

trainS = Train;
textS = Ttext;
end