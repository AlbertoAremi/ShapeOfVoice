% LaFormaDeTuVoz.m
% Alberto Moreno Simón 17 05 2018
% Read Audio file, *.wav or *.mp3, show spectrogram and generate a STL file with spectrogram 

% Used surf2stl() of Bill McDonald
% Used audioread() of Dan Ellis

[filename pathname] = uigetfile('*.wav','File Selector'); %Select File
fullpathname = strcat(pathname,filename);   %Path of File
% [d,sr] = wavread(fullpathname);   %Read Wav File
[d,sr] = audioread(fullpathname);   %Read Mp3 File

d=(d(:,1));
% plot(CanalIzq);
numeroMuestras=length(d);   %Number of Sample
t=1:1:numeroMuestras;

% ----------  Show Spectrogram ------------------------------
 % spectrogram(d,128,120,128,1E3); % Display the spectrogram    
[y,f,t,p] = spectrogram(d,256,125,1024,4E3,'yaxis'); 

newP=10*log10(abs((y.^2)));   %See at logarirmic
% miP=10*y.^2;                  % See at linear
% miP=10*log10(abs(y));

surf(t,f,newP,'EdgeColor','none');   colormap('jet'); shading interp; %Show figure
axis xy; axis tight; view(0,90);     % Configure figure   
xlabel('Time');                      %   
ylabel('Frequency (Hz)');            %   

%  ---------  Application of filters for edge smoothing -----------------
figure();
humbral=1;
sesgado=(((newP)>humbral).*newP)+(newP<=humbral).*humbral;
surf(t,f,sesgado,'EdgeColor','none');   colormap('jet'); shading interp;
axis xy; axis tight; view(0,90);  % See at 2D
xlabel('Time');
ylabel('Frequency (Hz)');

figure()
filtromediana= medfilt2(sesgado);
surf(t,f,filtromediana,'EdgeColor','none');   colormap('jet'); shading interp;
axis xy; axis tight; view(0,90);
xlabel('Time');
ylabel('Frequency (Hz)');


[filtroSuperiorCorteTiempo , filtroSuperiorCorteFrecuencia]= size(filtromediana);

filtroInferiorCorteFrecuencia=100;
% filtroSuperiorCorteFrecuencia=100;
filtroInferiorCorteTiempo=1;
% filtroSuperiorCorteTiempo=

figure()
audiocortado=filtromediana(filtroInferiorCorteTiempo:filtroSuperiorCorteTiempo,filtroInferiorCorteFrecuencia:filtroSuperiorCorteFrecuencia);
surf(f(filtroInferiorCorteTiempo:filtroSuperiorCorteTiempo),t(filtroInferiorCorteFrecuencia:filtroSuperiorCorteFrecuencia),audiocortado','EdgeColor','none');   colormap('jet'); shading interp;
axis xy; axis tight; view(0,90);
xlabel('Time');
ylabel('Frequency (Hz)');

% filtro2=medfilt2(sesgado,[5 4]);

% ------------ Create STL file ------------------------------------------------------

% miStl=strcat(filename,'.stl');  %Use same name with STL extension
% surf2stl('filtromediana.stl',t,f',filtromediana); %Create STL
% surf2stl('filtro2.stl',t,f',filtro2);