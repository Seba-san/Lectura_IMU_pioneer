/*
 * Bus.h
 *
 *  Created on: Apr 16, 2019
 *      Author: seba
 */

#ifndef BUS_H_
#define BUS_H_





#endif /* BUS_H_ */
//#include "Bus.cpp"
#include <Arduino.h>

union tx_dato {
	uint16_t Dato16;
	uint8_t  Dato8[2];
};
union tiempo {
	unsigned long Tiempo4;
	uint16_t  tiempo1[2];
};


void enviar (uint16_t* ptr, int cantidad){
	tx_dato Envi;
	for (int i=1;i<cantidad+1;i++){
		Envi.Dato16=*ptr;
		Serial.write(Envi.Dato8[1]);
		Serial.write(Envi.Dato8[0]);
		ptr++;
	}
}


void sincronizacion (void){

	uint16_t a = 0xFEEF;
	enviar(&a,1);// cabecera
	tiempo t;
	t.Tiempo4=micros();
	enviar(&t.tiempo1[0],1);// timestamp


}
