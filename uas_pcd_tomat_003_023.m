function varargout = uas_pcd_tomat_003_023(varargin)
% varargout : fungsi mengembalikan sejumlah keluaran yang bervariasi.
% varargin : fungsi menerima sejumlah masukan yang bervariasi.

gui_Singleton = 1;
% GUI ini bersifat singleton, hanya satu instance dari GUI yang dapat berjalan pada satu waktu.

gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uas_pcd_tomat_003_023_OpeningFcn, ...
                   'gui_OutputFcn',  @uas_pcd_tomat_003_023_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

function uas_pcd_tomat_003_023_OpeningFcn(hObject, eventdata, handles, varargin)
% Pilih keluaran baris perintah default untuk uas_pcd_tomat_003_023
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

function varargout = uas_pcd_tomat_003_023_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)

[filename,pathname] = uigetfile('*.jpg');
Img = imread(fullfile(pathname,filename));
handles.I = Img;
guidata(hObject,handles)
axes(handles.axes1)
imshow(Img)
title(filename);

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
Img = handles.I;

% Mencari nilai HSI dengan memisahkan komponen RGB dari citra
RGB     = im2double(Img);
Red     = RGB(:,:,1);   % Mengambil komponen merah dari citra RGB
Green   = RGB(:,:,2);   % Mengambil komponen hijau dari citra RGB
Blue    = RGB(:,:,3);   % Mengambil komponen biru dari citra RGB

% Mencari nilai Hue
atas=1/2*((Red-Green)+(Red-Blue));
bawah=((Red-Green).^2+((Red-Blue).*(Green-Blue))).^0.5;
teta = acosd(atas./(bawah));    % Menghitung teta 
if Blue >= Green    
    H = 360 - teta;
else
    H = teta;
end

H = H/360;
[r c] = size(H);
for i=1 : r
    for j=1 : c
        z = H(i,j); % Mengambil nilai hue pada posisi (i, j)
        z(isnan(z)) = 0; % isnan adalah is Not a Number artinya jika bukan angka dia akan memberi 0
        H(i,j) = z; % Menyimpan kembali nilai yang telah diubah ke dalam matriks H
    end
end

% Menghitung komponen saturasi (S) 
S=1-(3./(sum(RGB,3))).*min(RGB,[],3);

[r c] = size(S);
for i=1 : r
    for j=1 : c
        z = S(i,j);
        z(isnan(z)) = 0;
        S(i,j) = z;
    end
end

% Menghitung komponen intensitas (I)
I=(Red+Green+Blue)/3;
% Menjumlahkan nilai dari ketiga komponen warna RGB Membagi jumlah tersebut dengan 3 
% untuk mendapatkan rata-rata kecerahan, atau intensitas, dari ketiga komponen warna.

% Menghitung rata - rata dari semua elemen dalam matriks 2D.
MeanR = mean2(Red);
MeanG = mean2(Green);
MeanB = mean2(Blue);
MeanH = mean2(H);
MeanS = mean2(S);
MeanI = mean2(I);

% Menghitung Varians (Variance)
VarRed = var(Red(:)); VarGreen = var(Green(:)); VarBlue = var(Blue(:));
VarH = var(H(:)); VarS = var(S(:)); VarI = var(I(:)); 
%Red(:) Mengubah matriks Red menjadi vektor kolom, sehingga var dapat menghitung variansnya.

% Menghitung Rentang (Range)
RangeR = ((max(max(Red)))-(min(min(Red))));
RangeG = ((max(max(Green)))-(min(min(Green))));
RangeB = ((max(max(Blue)))-(min(min(Blue))));
RangeH = ((max(max(H)))-(min(min(H))));
RangeS = ((max(max(S)))-(min(min(S))));
RangeI = ((max(max(I)))-(min(min(I))));
% max(max(X)): Menghitung nilai maksimum dalam matriks X
% min(min(X)): Menghitung nilai minimum dalam matriks X

% stndar deviasi
MaxRed= max(Red);
MaxGreen = max(Green);
MaxBlue = max(Blue);
MaxH = max(H);
MaxS = max(S);
MaxI = max(I);

% Mengambil Data dari Tabel GUI
data = get(handles.uitable2,'Data'); % Mengambil data dari komponen (uitable2), menyimpan ke dalam variabel data. 

% Mengisi Tabel dengan Nilai Rata-Rata (Mean)
data{1,1} = num2str(MeanR);
data{2,1} = num2str(MeanG);
data{3,1} = num2str(MeanB);
data{4,1} = num2str(MeanH);
data{5,1} = num2str(MeanS);
data{6,1} = num2str(MeanI);
% Mengisi Tabel dengan Nilai Varians (Variance)
data{1,2} = num2str(VarRed);
data{2,2} = num2str(VarGreen);
data{3,2} = num2str(VarBlue);
data{4,2} = num2str(VarH);
data{5,2} = num2str(VarS);
data{6,2} = num2str(VarI);
% Mengisi Tabel dengan Nilai Rentang (Range)
data{1,3} = num2str(RangeR);
data{2,3} = num2str(RangeG);
data{3,3} = num2str(RangeB);
data{4,3} = num2str(RangeH);
data{5,3} = num2str(RangeS);
data{6,3} = num2str(RangeI);
% rgb hsi
data{1,4} = num2str(MaxRed);
data{2,4} = num2str(MaxGreen);
data{3,4} = num2str(MaxBlue);
data{4,4} = num2str(MaxH);
data{5,4} = num2str(MaxS);
data{6,4} = num2str(MaxI);

% Menampilkan Data dalam Tabel GUI
set(handles.uitable2,'Data',data,'ForegroundColor',[0 0 0]);

% Membaca Data Training dari File Excel
training1 = xlsread('C:/Users/fiqan/OneDrive/Desktop/UAS_PCD_003_023/Data Training.xls');

% Mengatur Data Training dan Kelompok Kelas
group = training1(:,25);
training = [training1(:,1) training1(:,2) training1(:,3) training1(:,4) training1(:,5) training1(:,6) training1(:,7) training1(:,8) training1(:,9) training1(:,10) training1(:,11) training1(:,12) training1(:,13) training1(:,14) training1(:,15) training1(:,16) training1(:,17) training1(:,18)];
        
% Membuat Vektor Fitur untuk Prediksi
Z=[MeanR MeanG MeanB MeanH MeanS MeanI VarRed VarGreen VarBlue VarH VarS VarI RangeR RangeG RangeB RangeH RangeS RangeI];

% Membuat Model K-Nearest Neighbors (KNN) dan Melakukan Prediksi
Mdl = fitcknn(training, group);
hasil = predict(Mdl, Z); % Fungsi memprediksi kelas dari data fitur Z menggunakan model KNN Mdl

% Menentukan Kelas Kematangan dan Menampilkan Hasil
if hasil == 1
    b = 'MATANG';
elseif hasil == 2
    b = 'SETENGAH-MATANG';
elseif hasil == 3
    b = 'MENTAH';
end
set(handles.edit2,'string',b);


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
image_folder = 'C:/Users/fiqan/OneDrive/Desktop/UAS_PCD_003_023/matang';
% Mengambil semua file gambar dengan ekstensi .jpg dalam folder image_folder
filenames = dir(fullfile(image_folder, '*.jpg')); 
total_images = numel(filenames); % Variabel yang menyimpan jumlah total gambar dalam folder
% Matriks kosong yang akan digunakan untuk menyimpan vektor fitur dari setiap gambar
Z1=[];

for n = 1:total_images % Loop yang berjalan dari 1 hingga jumlah total gambar
  % Menggabungkan path folder dan nama file untuk mendapatkan path lengkap dari gambar
  full_name= fullfile(image_folder, filenames(n).name);
  Img = imread(full_name); 

% Cari nilai HSI dengan memisahkan komponen warna RGB
RGB     = im2double(Img);
Red     = RGB(:,:,1);   % mengekstrak komponen warna merah dari gambar
Green   = RGB(:,:,2);   % mengekstrak komponen warna hijau dari gambar
Blue    = RGB(:,:,3);   % mengekstrak komponen warna biru dari gambar

% Menghitung bagian atas dan bawah dari persamaan hue
atas=1/2*((Red-Green)+(Red-Blue));
bawah=((Red-Green).^2+((Red-Blue).*(Green-Blue))).^0.5;
% Menghitung nilai teta
teta = acosd(atas./(bawah));
% Menentukan nilai Hue berdasarkan kondisi
if Blue >= Green
    H = 360 - teta;
else
    H = teta;
end

H = H/360;
[r c] = size(H);
for i=1 : r
    for j=1 : c
        z = H(i,j); % Mengambil nilai hue pada posisi (i, j)
        z(isnan(z)) = 0; % isnan adalah is Not a Number artinya jika bukan angka dia akan memberi 0
        H(i,j) = z; % Menyimpan kembali nilai yang telah diubah ke dalam matriks H
    end
end

% Menghitung Komponen Saturasi 
S=1-(3./(sum(RGB,3))).*min(RGB,[],3);
[r c] = size(S);
for i=1 : r
    for j=1 : c
        z = S(i,j);
        z(isnan(z)) = 0;
        S(i,j) = z;
    end
end
% sum(RGB, 3): Menjumlahkan nilai RGB di sepanjang dimensi ketiga (kanal warna), menghasilkan jumlah komponen warna untuk setiap piksel.
% min(RGB, [], 3): Mengambil nilai minimum dari komponen warna merah, hijau, dan biru untuk setiap piksel.
% 3 ./ (sum(RGB, 3)): Menghitung inversi dari rata-rata komponen warna untuk setiap piksel.
% 1 - ...: Mengurangkan hasil perkalian dari inversi rata-rata komponen warna dengan nilai minimum dari 1 untuk mendapatkan nilai saturasi.

% Menghitung komponen Intensitas
I=(Red+Green+Blue)/3;
% Menjumlahkan nilai dari ketiga komponen warna RGB Membagi jumlah tersebut dengan 3 
% untuk mendapatkan rata-rata kecerahan, atau intensitas, dari ketiga komponen warna.

% Menghitung rata - rata dari semua elemen dalam matriks 2D.
MeanR = mean2(Red);
MeanG = mean2(Green);
MeanB = mean2(Blue);
MeanH = mean2(H);
MeanS = mean2(S);
MeanI = mean2(I);
% Menghitung Varians (Variance)
VarRed = var(Red(:)); % Red(:)Mengubah matriks Red menjadi vktr kolom, sehingga var dapat menghitung variansnya
VarGreen = var(Green(:)); 
VarBlue = var(Blue(:));
VarH = var(H(:)); 
VarS = var(S(:)); 
VarI = var(I(:));
% Menghitung rentang (Range)
RangeR = ((max(max(Red)))-(min(min(Red))));
RangeG = ((max(max(Green)))-(min(min(Green))));
RangeB = ((max(max(Blue)))-(min(min(Blue))));
RangeH = ((max(max(H)))-(min(min(H))));
RangeS = ((max(max(S)))-(min(min(S))));
RangeI = ((max(max(I)))-(min(min(I))));
% max(max(X)): Menghitung nilai maksimum dalam matriks X
% min(min(X)): Menghitung nilai minimum dalam matriks X

% Menghitung Standar Deviasi
sdR = std2(Red);
sdG = std2(Green);
sdB = std2(Blue);
sdH = std2(H);
sdS = std2(S);
sdI = std2(I);
% standar deviasi dari masing komponen warna RGB dan komponen HSI

% Menyusun Vektor Fitur
Z=[MeanR MeanG MeanB MeanH MeanS MeanI VarRed VarGreen VarBlue VarH VarS VarI RangeR RangeG RangeB RangeH RangeS RangeI sdR sdG sdB sdH sdS sdI 1];
Z1=[Z1;Z];
end

image_folder = 'C:/Users/fiqan/OneDrive/Desktop/UAS_PCD_003_023/setengah_matang';
filenames = dir(fullfile(image_folder, '*.jpg'));
total_images = numel(filenames);

for n = 1:total_images
  full_name= fullfile(image_folder, filenames(n).name);
  Img = imread(full_name); 

% Mencari Nilai HSI
RGB     = im2double(Img);
Red     = RGB(:,:,1);
Green   = RGB(:,:,2);
Blue    = RGB(:,:,3);
% Menghitung Hue
atas=1/2*((Red-Green)+(Red-Blue));
bawah=((Red-Green).^2+((Red-Blue).*(Green-Blue))).^0.5;
teta = acosd(atas./(bawah));
if Blue >= Green
    H = 360 - teta;
else
    H = teta;
end

H = H/360;
[r c] = size(H);
for i=1 : r
    for j=1 : c
        z = H(i,j);
        z(isnan(z)) = 0;
        H(i,j) = z;
    end
end

% Menghitung Saturasi
S=1-(3./(sum(RGB,3))).*min(RGB,[],3);
[r c] = size(S);
for i=1 : r
    for j=1 : c
        z = S(i,j);
        z(isnan(z)) = 0;
        S(i,j) = z;
    end
end

% Menghitung Intensitas
I=(Red+Green+Blue)/3;

%Menghitung Rata", Variance, Range
MeanR = mean2(Red);
MeanG = mean2(Green);
MeanB = mean2(Blue);
MeanH = mean2(H);
MeanS = mean2(S);
MeanI = mean2(I);
VarRed = var(Red(:)); 
VarGreen = var(Green(:)); 
VarBlue = var(Blue(:));
VarH = var(H(:)); 
VarS = var(S(:)); 
VarI = var(I(:));
RangeR = ((max(max(Red)))-(min(min(Red))));
RangeG = ((max(max(Green)))-(min(min(Green))));
RangeB = ((max(max(Blue)))-(min(min(Blue))));
RangeH = ((max(max(H)))-(min(min(H))));
RangeS = ((max(max(S)))-(min(min(S))));
RangeI = ((max(max(I)))-(min(min(I))));

% Menghitung Standar Deviasi
sdR = std2(Red);
sdG = std2(Green);
sdB = std2(Blue);
sdH = std2(H);
sdS = std2(S);
sdI = std2(I);


Z=[MeanR MeanG MeanB MeanH MeanS MeanI VarRed VarGreen VarBlue VarH VarS VarI RangeR RangeG RangeB RangeH RangeS RangeI sdR sdG sdB sdH sdS sdI 2];
Z1=[Z1;Z];
end

image_folder = 'C:/Users/fiqan/OneDrive/Desktop/UAS_PCD_003_023/mentah';
filenames = dir(fullfile(image_folder, '*.jpg'));
total_images = numel(filenames);

for n = 1:total_images
  full_name= fullfile(image_folder, filenames(n).name);
  Img = imread(full_name); 
  
% Mencari nilai HSI
RGB     = im2double(Img);
Red     = RGB(:,:,1);
Green   = RGB(:,:,2);
Blue    = RGB(:,:,3);

% Hue
atas=1/2*((Red-Green)+(Red-Blue));
bawah=((Red-Green).^2+((Red-Blue).*(Green-Blue))).^0.5;
teta = acosd(atas./(bawah));
if Blue >= Green
    H = 360 - teta;
else
    H = teta;
end

H = H/360;
[r c] = size(H);
for i=1 : r
    for j=1 : c
        z = H(i,j);
        z(isnan(z)) = 0;
        H(i,j) = z;
    end
end

% Menghitung Saturasi
S=1-(3./(sum(RGB,3))).*min(RGB,[],3);
[r c] = size(S);
for i=1 : r
    for j=1 : c
        z = S(i,j);
        z(isnan(z)) = 0;
        S(i,j) = z;
    end
end
% Menghitung Intensitas
I=(Red+Green+Blue)/3;

% Menhitung rata", Variance, Range
MeanR = mean2(Red);
MeanG = mean2(Green);
MeanB = mean2(Blue);
MeanH = mean2(H);
MeanS = mean2(S);
MeanI = mean2(I);
VarRed = var(Red(:)); 
VarGreen = var(Green(:)); 
VarBlue = var(Blue(:));
VarH = var(H(:)); 
VarS = var(S(:)); 
VarI = var(I(:));
RangeR = ((max(max(Red)))-(min(min(Red))));
RangeG = ((max(max(Green)))-(min(min(Green))));
RangeB = ((max(max(Blue)))-(min(min(Blue))));
RangeH = ((max(max(H)))-(min(min(H))));
RangeS = ((max(max(S)))-(min(min(S))));
RangeI = ((max(max(I)))-(min(min(I))));

% Menghitung Standar Deviasi
sdR = std2(Red);
sdG = std2(Green);
sdB = std2(Blue);
sdH = std2(H);
sdS = std2(S);
sdI = std2(I);

Z=[MeanR MeanG MeanB MeanH MeanS MeanI VarRed VarGreen VarBlue VarH VarS VarI RangeR RangeG RangeB RangeH RangeS RangeI sdR sdG sdB sdH sdS sdI 3];
Z1=[Z1;Z];
end

xlswrite('C:/Users/fiqan/OneDrive/Desktop/UAS_PCD_003_023/Data Trainingg.xls',Z1);
set(handles.edit1,'string','Training Color Done');
% Menulis Data ke File Excel
% teks yang ditampilkan oleh edit1 yaitu Training Color Done

function edit1_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit2_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when entered data in editable cell(s) in uitable2.
function uitable2_CellEditCallback(hObject, eventdata, handles)
