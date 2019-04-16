#include <Arduino.h>
#include "Bus.h"

uint16_t Vector[]={65523,65524,65525,65526,65527,65528,65529,65530,65531,65532,65533,65534,65535}; // Supongo que solo se enviaran 24 bytes por vuelta

void setup() {
	Serial.begin(460800);//460800
	//9600, 19200, 38400, 57600, 115200, 230400, 460800, 921600
	//sincronizacion();
}

void loop() {
	sincronizacion();
	enviar(&Vector[0],13);
	//delayMicroseconds(500);
}


