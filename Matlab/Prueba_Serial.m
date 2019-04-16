% Info útil:
%https://www.mathworks.com/help/matlab/serial-port-devices.html
% Formato de la trama
%[Cabecera][Timestamp (us)][13 x datos]
% son todos enteros sin signo de 16bits
Cantidad_lectura=10; % Datos leidos por bloque.
Cantidad_datos=15; % Datos por trama
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
    s.InputBufferSize=Cantidad_datos*5e3*2;
    fopen(s)
            disp('conectado')    
end

%%

% Recomendación: Leer varias tramas a la vez, si se lee de a una no dan los tiempos.
clc
t=tic();
i=1;err=0;
while toc(t)<10  
    if s.BytesAvailable>0
        if s.BytesAvailable>(s.InputBufferSize-Cantidad_datos*2)
            error('buffer saturado, perdida de datos. Reiniciar la comunicación')            
        end
    end
    if s.BytesAvailable>Cantidad_datos*Cantidad_lectura
        A = fread(s,Cantidad_datos*Cantidad_lectura,'uint16'); % lee el binario directamente
        Datos=reshape(A,Cantidad_datos,[]);
        i=i+1;
    end
    
end
disp('listo')
%%
s
try
    fclose(s);
    clear s
end
disp('Puerto Cerrado')

%%
for i=1:size(Datos,2)-1
    Datos(2,i)-Datos(2,i+1)
end