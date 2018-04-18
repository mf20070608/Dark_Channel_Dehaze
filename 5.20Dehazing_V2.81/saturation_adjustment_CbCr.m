% �������ȱ仯���㱥�Ͷȵ���ϵ�� ��HSY��ʽͼ��ģ�ͣ� 
% Y1 ���� ԭʼ����ͼYͨ��
% Y2 ���� ֱ��ͼ����������ͼYͨ��
% Xi, Yi, Ki, ���� Hue0-359�������ζ�Ӧ��valY�ֶ�������߶������꼰б��
% Sampmax  %���Ͷ�����������
% Srate  %�����󱥺Ͷȵ�Ȩ�� 0~1֮��
% Sfactor   %�����󱥺Ͷ�����ǿ����
% Cb2 ��� �������ȱ仯�������ͶȺ��Cb2
% Cr2 ��� �������ȱ仯�������ͶȺ��Cr2
function [Cb2, Cr2] = saturation_adjustment_CbCr(Y1, Y2, Cb1, Cr1, Xi, Yi, Ki, Sampmax, Srate, Sfactor)
    
    [row, column]=size(Y1);
    Y1=double(Y1);
    Y2=double(Y2);
    Cb1=double(Cb1);
    Cr1=double(Cr1);
    Cb2=zeros(row,column);
    Cr2=zeros(row,column);
    Ksat=zeros(row,column);
    
    Hue=zeros(256,256);
    for i=1:row
        for j=1:column
            % ������� arctan��y/x��=y/(y+x)*90
            if Cb1(i,j)==128 && Cr1(i,j)==128
                Hue(i,j)=0;
            elseif Cb1(i,j)>=128 && Cr1(i,j)>=128
                    Hue(i,j)=floor((Cr1(i,j)-128)/(Cr1(i,j)+Cb1(i,j)-256)*90);
            elseif Cb1(i,j)>=128 && Cr1(i,j)<128
                Hue(i,j)=-floor((128-Cr1(i,j))/(-Cr1(i,j)+Cb1(i,j))*90)+360;
            elseif Cb1(i,j)<128 && Cr1(i,j)>=128
                Hue(i,j)=-floor((Cr1(i,j)-128)/(Cr1(i,j)-Cb1(i,j))*90)+180;
            else %Cb1(i,j)<128 && Cr1(i,j)<128
                Hue(i,j)=floor((128-Cr1(i,j))/(256-Cr1(i,j)-Cb1(i,j))*90)+180;
            end
            if Hue(i,j)==360
                Hue(i,j)=0;
            end
            
            % Hue0-359�������ζ�Ӧ��valY���߶����
            for m=1:length(Ki)
                if Hue(i,j)<Xi(m+1) && Hue(i,j)>=Xi(m)
                    y=round(Ki(m)*(Hue(i,j)-Xi(m)))+Yi(m);
                end
            end
            
            if Y1(i,j)==0||Y1(i,j)==255
                Ksat(i,j)=1;     % ԭ��������0����255���򱥺Ͷȱ��ֲ��䣬
                                     % �������Y1 Y2���Ӧ�����ζ�������y�Ĵ�С��ϵ �ֶμ��� ������㹫ʽ���£��ο��ĵ�˵����
            elseif Y1(i,j)<=y && Y2(i,j)<=y
                Ksat(i,j)=Y2(i,j)/Y1(i,j);
            elseif Y1(i,j)<=y && Y2(i,j)>y
                Ksat(i,j)=((255-Y2(i,j))*y)/((255-y)*Y1(i,j));
            elseif Y1(i,j)>y && Y2(i,j)<=y
                Ksat(i,j)=((255-y)*Y2(i,j))/((255-Y1(i,j))*y);
            else 
                Ksat(i,j)=(255-Y2(i,j))/(255-Y1(i,j));
            end
            
%             S2(i,j)=min([S1(i,j)*Sampmax,S2(i,j)]);     % ���Ʊ��Ͷȱ仯���ܳ���ԭ�����Ͷ���ֵ������
            if Ksat(i,j)>Sampmax
                Ksat(i,j)=Sampmax;
            end
%             S2(i,j)=S1(i,j)*(1-Srate)+S2(i,j)*Srate;    % ����Ȩ��ֵSrate 0-1֮�� �仯��ı��Ͷȿ���ԭ���Ͷ�S1����������S2֮��Ȩ�� 
            Ksat(i,j)=1-Srate+Ksat(i,j)*Srate;
%             S2(i,j)=Sfactor*S2(i,j);    % �ʵ�����ǿ������ı��Ͷ�S2����ǿ����ΪSfactor�� һ��ȡ1-1.5֮��
            Ksat(i,j)=Sfactor*Ksat(i,j); 
%             S2(i,j)=max(S1(i,j),S2(i,j));   % ���ĳ���ص㴦������ı��ͶȽ����ˣ���S2<S1,������ԭ�ȵı��Ͷ�
            if Ksat(i,j)<1
                Ksat(i,j)=1;
            end
        end
    end
    
    Cb2=uint8(Ksat.*(Cb1-128)+128);
    Cr2=uint8(Ksat.*(Cr1-128)+128);

end
