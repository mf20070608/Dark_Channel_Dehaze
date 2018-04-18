clear all,close all,clc;

tic;%�������ִ��ʱ��
%����ͼ����ʾ
I_ori=imread('D:\����\����\����\ȥ��\��Ƶȥ��\test\cross\input_frame\1.png');
I=double(I_ori)/255;%double ���Ӷȼ���
I_hsv = rgb2hsv(I_ori);
v = I_hsv(:,:,3);
figure;
imshow(I_ori);
title('����ͼ��');
kenlRatio = .01;
 %��ȡͼ��ߴ�
[h,w,c]=size(I);

%����ͼ��İ�ԭɫ
dark_or=ones(h,w);
dark_ori=ones(h,w);
t=ones(h,w);
dehaze=zeros(h,w,c);
dark_extend=ones(h+14,w+14);
window=7;%ɨ�貽��
%���������ɫͨ������Сֵ
for i=1:h
    for j=1:w
        dark_extend(i+window,j+window)=min(I(i,j,:));
    end
end
%�ڷ��������������ԭɫ
for i=1+window:h+window
    for j=1+window:w+window
        A=dark_extend(i-window:i+window,j-window:j+window);
        dark_ori(i-window,j-window)=min(min(A));
    end
end
figure;
imshow(dark_ori);
title('��ԭɫͼ��');
G=rgb2gray(I);
s=0;
s=double(s);
for i=1:1:h
    for j=1:1:w
        s=s+G(i,j);
    end
end
average=s/(h*w);
[Gmag, Gdir] = imgradient(G,'prewitt');
B2=medfilt2(Gmag,[5,5]);  
subplot(2,4,8),imshow(B2);
%for a=1:1:h
%    for b=1:1:w
%        if B2(a,b)<0.01&&G(a,b)>1.5*average;
%            Q(a,b)=1;
%        else
%            Q(a,b)=0;
%        end
            
%    end
%end
%imshow(Q);
figure; imshowpair(Gmag, Gdir, 'montage');
[height,width] = size(Gmag);%���ͼ��ĸ߶ȺͿ��
%for s=1:1:height
%   for d=1:1:width
%        if Gmag(s,d)>0.05
%            H(s,d)=1;
            
%        else
%           H(s,d)=0;
%        end
%    end
%end

% imshow(H);
%imwrite(H,'d.bmp','bmp') ;
% for s=1:1:height
%    for d=1:1:width
%        if H(s,d)==0
%            dark_or(s,d)=0;
%        else
%            dark_or(s,d)=dark_ori(s,d);
%        end
%    end
% end
%imshow(dark_or);




 

%m=0; n=0 ;x=0;v=0;
%for j=1:1:h
%    for k=1:1:w
%        if dark_or(j,k)>0.75
            
%            m=m+1;
%        end
%        if dark_or(j,k)<0.75&&dark_or(j,k)>0.5
            
%            n=n+1;
%        end
%        if dark_or(j,k)<0.5&&dark_or(j,k)>0.25
            
%            x=x+1;
%        end
%        if dark_or(j,k)<0.25
            
%            v=v+1;
%        end
%    end
%end
%m=m/(w*h);n=n/(w*h);x=x/(w*h);v=v/(w*h);
%if (m+n)<0.002
%    disp(' ��ȼ�Ϊ ����');
%end
%if (m+n)<0.04&&(m+n)>0.002
%    disp(' ��ȼ�Ϊ ����');
%end
%if (m+n)>0.04&&(m+n)<0.1
%    disp(' ��ȼ�Ϊ ��Ũ')
%end
%if (m+n)>0.1&&(m+n)<0.3
%    disp('��ȼ�Ϊ Ũ��');
%end
%if (m+n)>0.3
%     disp('��ȼ�Ϊ ��Ũ��');
%end
%I1 = double(I_ori)/255;
p =double(G)/2;

r = floor(max([3, w*kenlRatio, h*kenlRatio]));
eps = 10^-6;

q = guidedfilter_color(I, p, r, eps);%���鲻Ҫ�� color filter

figure();
imshow([I, repmat(p, [1, 1, 3]), repmat(q, [1, 1, 3])], [0, 1]);
[Gma, Gdi] = imgradient(q,'prewitt');     
imshow(Gma);
B2=medfilt2(Gma,[5,5]); %ʹ����ֵ�˲�
for a=1:1:h
    for b=1:1:w
        if B2(a,b)<0.01&&G(a,b)>1.3*average;
            Q(a,b)=1;
        else
            Q(a,b)=0;
        end
            
    end
end
%Q=medfilt2(Q,[6,6]);
imshow(Q);
%���������
for t=1:h
    for y=1:w
        if Q(t,y)==0
            dark_or(t,y)=dark_ori(t,y);
        end
        if Q(t,y)==1
            dark_or(t,y)=0;
        end
            
    end
end
[dark_sort,index]=sort(dark_or(:),'ascend');
 dark_chose=dark_sort(1:round(0.001*w*h));
 for i=1:round(0.001*w*h)
     [x,y] = ind2sub([480,640],index(i)); %����ת��Ϊ�±�
     I_chose(i)= v(x,y); %��ͨ������������Щpixel��intensity
     %I_chose(i)=I(index(i));
 end
 A_v = max(I_chose);
 [x0,y0] = find(v==A_v);
 A = A_v;
%A = max(I_chose);
%A=220/255;
w_1=0.9;
%t=ones(w,h);
t=1-w_1*q/A;
%t=max(min(t,1),0);
figure;
imshow(t);
title('ԭʼ͸����ͼ');
%��ԭ������ߣ��õ�����ͼ��
t0=0.1;%͸����������t0
%t1=1;

for i=1:c
    for j=1:h
        for l=1:w
            if Q(j,l)==0;
            dehaze(j,l,i)=(I(j,l,i)-A*0.95)/max(t(j,l),t0)+A;
            else
                dehaze(j,l,i)=(I(j,l,i)-A)/0.8+A;
            end
        end
    end
end
figure;
imshow(dehaze);

title('ȥ���ͼ��');
toc%��ʾ����ִ��ʱ��