% Info útil:
%https://www.mathworks.com/help/matlab/serial-port-devices.html
% Formato de la trama
%[Cabecera][Timestamp (us)][13 x datos]
% son todos enteros sin signo de 16bits
Cantidades.lectura=50; % Datos leidos por bloque.
Cantidades.datos=15; % Datos por trama
Cantidades.tiempo=20; % Tiempo de lectura en segundos. Este tiempo determina el tamaño del archivo .mat
t=tic;
while isempty(seriallist) && toc(t)<10
    pause(0.1)
end
if toc(t)>10
    warning('timeout: no se detecta puerto conectado')
else
    disp('Puerto abierto')
    puerto=seriallist
    s=serial(puerto,'BaudRate',460800); % a 460800 bps tarda 600us entre tramas (520us son por el serial)
    %9600, 19200, 38400, 57600, 115200, 230400, 460800, 921600
    s.ByteOrder = 'bigEndian';
    s.Terminator='';
    s.InputBufferSize=Cantidades.datos*5e3*2;
    fopen(s)
    disp('conectado')
end

%%
% Esta celda sirve para leer los datos del serial y almacenarlos con un
% timestamp.
% Recomendación: Leer varias tramas a la vez, si se lee de a una no dan los tiempos.
clc
t=tic();
Datos=[];
while toc(t)<Cantidades.tiempo
    if s.BytesAvailable>0
        if s.BytesAvailable>(s.InputBufferSize-Cantidades.datos*2)
           warning('buffer saturado. Se limpia el buffer, hay pérdida de datos.')
             flushinput(s)
        end
    end
    if s.BytesAvailable>Cantidades.datos*Cantidades.lectura
        A = fread(s,Cantidades.datos*Cantidades.lectura,'uint16'); % lee el binario directamente
        A=sincronismo(s,A,Cantidades);
        datos=reshape(A,Cantidades.datos,[]);
        Datos=[Datos datos];       
    end   
end
formato='yyyymmddHHMMSSFFF';
nombre=datestr(now,formato);
save(['./' nombre '.mat'],'Datos')
Datos(:,end)
disp('listo')
%%
% Con esta linea de codigo se cierra el puerto serial.
try
    fclose(s);
    clear s
end
disp('Puerto Cerrado')
