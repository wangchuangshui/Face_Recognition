
function a=facere(im)
% Yale�������ݿ⣬15���ˣ�ÿ��11��ͼ����������15*11��
people_count=15;%�����
face_count_per_people=11;%ÿ��������
%ÿ��ѵ����������,70%ʱʶ����ȷ��Ϊ96.67%,����Ϊ75%ʶ����ȷ�ʿɴ�100%
training_ratio=.70;
% ���������ϴ�����ֵ֮��ռ��������ֵ֮�͵ı�����
energy=0.9;
% ÿ��ѵ��������
training_count=floor(face_count_per_people*training_ratio);
%ѵ���������ݣ�ÿ����һ������
training_samples=[];
if ~exist('scores.mat')
% ѵ��
for i=1:people_count
    for j=1:training_count
        img=im2double(imread(['D:\ruanjian\bin\ceshi\video_detecting_and_tracking\' sprintf('%03d',i) '\' sprintf('%02d',j) '.jpg']));
        img=imresize(img,[128 128]); % ͼ����������128*128
        %���ǲ�ɫͼ����ҶȻ�
        if ndims(img)==3
            img=rgb2gray(img);
        end
        training_samples=[training_samples;img(:)'];
    end
end
%��ȡѵ��������ֵ��ÿ��һ��������ÿ��һ������
mu=mean(training_samples);

%����princomp����
%coeff�����ɷ�ϵ�����󣬼��任��ͶӰ������
%scores��ѵ������ͶӰ��ľ���
%latent��Э������������ֵ����������
%tsquare, which contains Hotelling's T2 statistic for each data point.
[coeff,scores,latent,tsquare]=pca(training_samples);

%Ѱ��ռ��energy�������±꣬�����ɷ־�ȡ����ô��ά
idx=find(cumsum(latent)./sum(latent)>energy,1);
coeff=coeff(:,1:idx);  %ȡ�������ɷ�ϵ������
scores=scores(:,1:idx);%ѵ������ͶӰ����
save('scores');
 end
% ����
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
        %����������ȥѵ��������ֵ��Ȼ��ͶӰ���õ�ͶӰ���������ʾ
        score=(img(:)'-mu)*coeff;
        %�������������ÿ��ѵ������֮���ŷʽ���루���ֻ����ƽ��ֵ���ɣ�
        %Ȼ����������ڷ������Բ����������з���
        [~,idx]=min(sum((scores-repmat(score,size(scores,1),1)).^2,2));
        [~,b]=sort(sum((scores-repmat(score,size(scores,1),1)).^2,2));
        [a,~]=sort(sum((scores-repmat(score,size(scores,1),1)).^2,2));
           m=ceil(idx/training_count);
           name={'wangchuang','zhaohui','Charles','Mark','Bill','Vincent','William','Joseph','James','Henry','Gary',' Martin','Bill Clinton'};
           
%            a=['The People Number is ',num2str(m)];
 a=['The Name Of This People Is ',name{1,m}];
end