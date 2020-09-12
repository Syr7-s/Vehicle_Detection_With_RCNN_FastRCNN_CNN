

function varargout = ProjeArayuz(varargin)




gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ProjeArayuz_OpeningFcn, ...
                   'gui_OutputFcn',  @ProjeArayuz_OutputFcn, ...
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
% End initialization code - DO NOT EDIT


% --- Executes just before ProjeArayuz is made visible.
function ProjeArayuz_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ProjeArayuz (see VARARGIN)

% Choose default command line output for ProjeArayuz
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
   iconum1 = imread ( 'hosgeldiniz.png' );
   iconum = imresize (iconum1,[64,64]);
   uiwait(msgbox("RCNN, Fast RCNN ve CNN ile resim �zerinde ara� tespiti","Ara� tespit uygulamas�na Ho�geldiniz.","custom",iconum));
% UIWAIT makes ProjeArayuz wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ProjeArayuz_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global resim
[dosyaAdi,dosyaYolu] = uigetfile({'*.jpg';'*.png';'*.bmp'});
if dosyaAdi==0
    msgbox(sprintf('L�tfen Bir Resim Se�iniz.'),'HATA','Error')
end
axes(handles.axes1)
resim=imread(fullfile(dosyaYolu,dosyaAdi));
imshow(resim);
set(handles.edit3,'String','Bir resim se�ildi.')


% --- Executes on button press in rcnnTestBtn.
function rcnnTestBtn_Callback(hObject, eventdata, handles)
% hObject    handle to rcnnTestBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



global resim
% %global indis
% %load('vehicleTrainingDataResult.mat');
try 
    rcnn1 = evalin('base', 'rcnn');
    [bbox, score, label] = detect(rcnn1, resim, 'MiniBatchSize', 32);

    [score, idx] = max(score);

    bbox = bbox(idx, :);
    annotation = sprintf('%s: (Confidence = %f)', label(idx), score);

    detectedImg = insertObjectAnnotation(resim, 'rectangle', bbox, annotation);

    figure();
    imshow(detectedImg);
    set(handles.edit3,'String','RCNN a�� test ediliyor.')
catch MException
    f1=msgbox(MException.message+"Test isleminde bir hata olustu.Uygulamayi sonland�r�n�z."," Hata Olustu...","error");
    
end





% --- Executes on button press in rcnnBtnYukle.
function rcnnBtnYukle_Callback(hObject, eventdata, handles)
% hObject    handle to rcnnBtnYukle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try 
    evalin('base',"load('rcnnNetwork.mat')")
    set(handles.edit3,'String','Rcnn A�� y�kleniyor')
catch MException
    f1=msgbox(MException.message+"RCNN a� yuklenmesinde bir sorun olustu.Uygulamay� sonland�r�n�z."," Hata Olustu...","error");
end
% --- Executes on button press in pushbutton6.
% --- Executes on button press in fastRcnnYukleBtn.
function fastRcnnYukleBtn_Callback(hObject, eventdata, handles)
% hObject    handle to fastRcnnYukleBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    evalin('base',"load('fasterRcnnNetwork.mat')")
    set(handles.edit3,'String','FasterRcnn A�� y�kleniyor')
catch MException
    f1=msgbox(MException.message+"RCNN a� yuklenmesinde bir sorun olustu.Uygulamay� sonland�r�n�z."," Hata Olustu...","error");
end
% --- Executes on button press in fastRcnnTestBtn.
function fastRcnnTestBtn_Callback(hObject, eventdata, handles)
% hObject    handle to fastRcnnTestBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --- Executes on button press in temizleBtn.
global resim
% %global indis
% %load('vehicleTrainingDataResult.mat');
try
    frcnn1 = evalin('base', 'fasterrcnn');
    [bbox, score, label] = detect(frcnn1, resim, 'MiniBatchSize', 32);

    [score, idx] = max(score);

    bbox = bbox(idx, :);
    annotation = sprintf('%s: (Confidence = %f)', label(idx), score);

    detectedImg = insertObjectAnnotation(resim, 'rectangle', bbox, annotation);

    figure();
    imshow(detectedImg);
    set(handles.edit3,'String','Faster Rcnn A�� Test ediliyor')
catch MException
    f1=msgbox(MException.message+"Fast RCNN  a� test i�leminde bir sorun olustu.Uygulamay� sonland�r�n�z."," Hata Olustu...","error");
end

function temizleBtn_Callback(hObject, eventdata, handles)
% hObject    handle to temizleBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try 
    evalin('base','clear fasterrcnn layers options rcnn vehicleTrainingData accuricy allImages ans cnn Pred testImages trainingImages')
    set(handles.edit3,'String','Workspace temizleniyor')
    set(handles.edit4,'String','.....');
catch MException
    f1=msgbox(MException.message+"Temizleme Isleminde bir sorun olustu.Uygulamay� sonland�r�n�z."," Hata Olustu...","error");
end
% --- Executes on button press in cnnAgYukleBtn.
function cnnAgYukleBtn_Callback(hObject, eventdata, handles)
% hObject    handle to cnnAgYukleBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    evalin('base',"load('cnnNetwork.mat')")
    set(handles.edit3,'String','CNN A�� y�kleniyor')
catch MException
    f1=msgbox(MException.message+"CNN a� yuklenmesinde bir sorun olustu.Uygulamay� sonland�r�n�z."," Hata Olustu...","error");
end


% --- Executes on button press in testResmiOlusturBtn.
function testResmiOlusturBtn_Callback(hObject, eventdata, handles)
% hObject    handle to testResmiOlusturBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% Yar� otomatik kesme
% [TestAdi TestYolu] = uigetfile ('*.jpg','Test Resmi Se�iniz');            % Test resmi se�. 
% I=imread([TestYolu TestAdi]);
global resim
N=input('Ka� nesne var: ');
imshow(resim)
%% Kesme i�i
 x=ginput(N*2)
 x=int16(x);
 %Kesmek istedi�iniz nesnemin sol �st kenar� ile sa�
 %alt kenar�na t�klayarak nesneyi bir matrise atm�� olursunuz.
 i=1;
for j=1:2:size(x,1)-1;
    K=resim(x(j,2):x(j+1,2),x(j,1):x(j+1,1));%K�rp�lan nesne
   
    K=K(:,:,[1 1 1]);
    
    K=imresize(K,[50 50]);% T�m k�rp�lan resimlerin boyutlar�n� e�it
    ext=' kesilenResim.jpg';
    name=num2str(i);
    name=fullfile(strcat(name,ext));
   
    imwrite(K,name) 
     i=i+1;
     
    %Her k�rp�lan resmi sakla
end
set(handles.edit3,'String','Kesme islemi yap�l�yor')
% --- Executes on button press in cnnAgTestBtn.
function cnnAgTestBtn_Callback(hObject, eventdata, handles)
% hObject    handle to cnnAgTestBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --- Executes on button press in cikisYapBtn.
global resim
try
    mycnn = evalin('base', 'cnn');
    resim=imresize(resim,[50,50])
    size(resim)

    [Pred scores]=classify(mycnn,resim);

    if(Pred=="vehiclesDataset-50x50")
        set(handles.edit4,'String','bu bir ara�');
    elseif(Pred=="aracOlmayanResimler")
        set(handles.edit4,'String','ara� olmayan resim');
    end
    set(handles.edit3,'String','Kesilen Test resim CNN A�� ile test ediliyor')
catch MException
    f1=msgbox(MException.message+"CNN a� test isleminde  bir sorun olustu.Uygulamay� sonland�r�n�z."," Hata Olustu...","error");
end   
% --- Executes on button press in bilgilendirmeBtn.
function bilgilendirmeBtn_Callback(hObject, eventdata, handles)
% hObject    handle to bilgilendirmeBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
f1=msgbox('Uygulamada ilk olarak hangi a�� ile i�lem yapmak istiyorsan�z o a�� y�kleyiniz(RCNN-Fast RCNN).A�lar� yukledikten sonra resim se� butonuna t�klayark bir TestResimleri klasorunden bir test resim se�iniz. Bu i�lemden sonra RCNN ve Fast RCNN a��ndan hangisi yuklediyseniz test et butonuna t�klayarak resmi test edebilirsiniz.CNN a��nda i�lem yapmak i�in ilk olarak test Resmi butonuna t�klan�r ve a��lan pencereden bir resim se�ilir ve size resimden ka� nesne kesece�iniz sorulur.Resimden par�a kestikten sonra kesilen par�alar 50x50x3 olarak boyutland�r�l�r.Bu boyutland�rmadan sonra resim se� butonuna t�klan�r ve kesilen resimdeki par�a se�ilir.CNN a�� butonuna t�klayarak a�� y�kleyiniz. Ard�ndan da test butonuna t�klay�n�z. !!!Temizle Butonuna t�klayarak i�lem yapt���n�z a�a ait bilgileri temizleyin.','LDA Modeli...','help');

function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function cikisYapBtn_Callback(hObject, eventdata, handles)
% hObject    handle to cikisYapBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
closereq();

% --- Executes on button press in pushbutton4.



