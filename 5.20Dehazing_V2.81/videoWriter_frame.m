WriterObj = VideoWriter('riverside_output.avi','Uncompressed AVI');
frame_number = 489;
WriterObj.FrameRate = 24;
open(WriterObj)
for i = 1: frame_number
    image_name = strcat('D:\����\����\����\ȥ��\��Ƶȥ��\test\riverside\input_frame\',num2str(i),'.png');
    image = imread(image_name);
    writeVideo(WriterObj,image);
end
close(WriterObj)