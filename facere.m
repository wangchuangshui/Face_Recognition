
function a=facere(im)
% Yale人脸数据库，15个人，每人11幅图像，样本数量15*11。
people_count=15;%类别数
face_count_per_people=11;%每类样本数
%每类训练样本比例,70%时识别正确率为96.67%,设置为75%识别正确率可达100%
training_ratio=.70;
% 能量，即较大特征值之和占所有特征值之和的比例。
energy=0.9;
% 每类训练样本数
training_count=floor(face_count_per_people*training_ratio);
%训练样本数据，每行是一个样本
training_samples=[];
if ~exist('scores.mat')
% 训练
for i=1:people_count
    for j=1:training_count
        img=im2double(imread(['D:\ruanjian\bin\ceshi\video_detecting_and_tracking\' sprintf('%03d',i) '\' sprintf('%02d',j) '.jpg']));
        img=imresize(img,[128 128]); % 图像缩放至至128*128
        %若是彩色图像，则灰度化
        if ndims(img)==3
            img=rgb2gray(img);
        end
        training_samples=[training_samples;img(:)'];
    end
end
%求取训练样本均值，每行一个样本，每列一类特征
mu=mean(training_samples);

%调用princomp函数
%coeff是主成分系数矩阵，即变换（投影）矩阵
%scores是训练样本投影后的矩阵
%latent是协方差矩阵的特征值，降序排列
%tsquare, which contains Hotelling's T2 statistic for each data point.
[coeff,scores,latent,tsquare]=pca(training_samples);

%寻找占了energy比例的下标，即主成分就取到这么多维
idx=find(cumsum(latent)./sum(latent)>energy,1);
coeff=coeff(:,1:idx);  %取出的主成分系数矩阵
scores=scores(:,1:idx);%训练样本投影矩阵
save('scores');
 end
% 测试
load('scores.mat', 'scores')
load('scores.mat', 'idx')
load('scores.mat', 'coeff')
load('scores.mat', 'mu')
%         img=im2double(imread(im));
img=im2double(im);
        img=imresize(img,[128 128]);
        if ndims(img)==3
            img=rgb2gray(img);
        end
        %测试样本减去训练样本均值，然后投影，得到投影后的样本表示
        score=(img(:)'-mu)*coeff;
        %计算测试样本和每个训练样本之间的欧式距离（这儿只计算平方值即可）
        %然后利用最近邻分类器对测试样本进行分类
        [~,idx]=min(sum((scores-repmat(score,size(scores,1),1)).^2,2));
        [~,b]=sort(sum((scores-repmat(score,size(scores,1),1)).^2,2));
        [a,~]=sort(sum((scores-repmat(score,size(scores,1),1)).^2,2));
           m=ceil(idx/training_count);
           name={'wangchuang','zhaohui','Charles','Mark','Bill','Vincent','William','Joseph','James','Henry','Gary',' Martin','Bill Clinton'};
           
%            a=['The People Number is ',num2str(m)];
 a=['The Name Of This People Is ',name{1,m}];
end