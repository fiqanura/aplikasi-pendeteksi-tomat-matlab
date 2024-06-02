input_gambar = input('C:/Users/fiqan/OneDrive/Desktop/UAS_PCD_003_023/Data/matang.jpg'); 
A= imread (input_gambar); 
I= im2double(A);
nilai_red= I(:,:,1); 
nilai_green= I(:,:,2); 
nilai_blue= I(:,:,3); 
%disp (nilai_red)
%disp(nilai_green)
disp(nilai_blue)