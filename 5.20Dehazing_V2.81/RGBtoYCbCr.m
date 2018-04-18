% RGBת��ΪYUV��ͬʱ������ɫ��Hue�����Ͷ�Sat
% rgbImg - ���� RGB��ʽͼ�� 0-255 8bit
% HueLUT - ���� ɫ�Ȳ��ұ� 0-359�� 9bit
% SatLUT - ���� ���ͶȲ��ұ� 0-180 8bit
% Y, Cb, Cr - ��� 0-255 8bit
% Hue - ɫ����� 0-359�� 9bit
% Sat - ���Ͷ���� 0-180 8bit
function [Y, Cb, Cr] = RGBtoYCbCr(rgbImg, nbit)
    
    R=rgbImg(:,:,1);
    G=rgbImg(:,:,2);
    B=rgbImg(:,:,3);
    [row, column, dim]=size(rgbImg);    % row-ͼ������ column-���� dim-ά��|����RGBͼ��dim=3
    
    R=double(R);
    G=double(G);
    B=double(B);
    
%     Y=round((round(2^nbit*0.299)*R+round(2^nbit*0.587)*G+round(2^nbit*0.114)*B)/2^nbit);    % round-��������ȡ��
%     Cb=round((-round(2^nbit*0.1687)*R-round(2^nbit*0.3313)*G+round(2^nbit*0.5)*B)/2^nbit)+128;
%     Cr=round((round(2^nbit*0.5)*R-round(2^nbit*0.4187)*G-round(2^nbit*0.0813)*B)/2^nbit)+128;
    
    Y=round((77*R+150*G+29*B)/2^nbit);    % round-��������ȡ��
    Cb=round((-43*R-85*G+128*B)/2^nbit)+128;
    Cr=round((128*R-107*G-21*B)/2^nbit)+128;
    
    Y=uint8(Y);     % ������������ȡ�����ӷ����ܻ�ʹY/Cb/Cr����255��uint8�ı����ݸ�ʽ�൱�ڽ�����255����ȡ255��С��0����ȡ0
    Cb=uint8(Cb);
    Cr=uint8(Cr);
    
end
