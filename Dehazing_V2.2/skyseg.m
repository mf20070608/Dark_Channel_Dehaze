function output = skyseg(input)

% SKYSEGMENTATION
%
% Updated: 03/28/2016
% Credit to : Cheng Qingrong

%q = guidedfilter_color(I, p, r, eps);
%����Ϊ�����˲��˹���ԭͼ��
%����͸����ͼ��


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