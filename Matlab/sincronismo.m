function A=sincronismo(s,A,Cantidades)
% Esta funcion se encarga de sincronizar los datos a través de de la
% cabecera
        if A(1)~=hex2dec('feef')
           warning('No coincide la cabecera. Comienza el proceso de busqueda asumiendo pérdida de datos.')
               elo=0;
            while elo~=1               
                for i=1:Cantidades.datos
                    A = fread(s,1,'uint16');
                    if A==hex2dec('feef')
                        A = fread(s,Cantidades.datos-1,'uint16');
                        A = fread(s,Cantidades.datos*Cantidades.lectura,'uint16'); % lee el binario directamente
                        elo=1;
                        disp('sincronizado.')
                        return;                        
                    end
                end
                if elo==2
                    elo=1;
                    error('No se puedo sincronizar. Reiniciar la comunicación.')
                end
                if elo==0
                    A = fread(s,1,'uint8');
                    elo=2;
                end                
            end
        end


end