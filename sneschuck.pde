#include <Wire.h>
#include "nunchuck_funcs.h"
#include "digitalWriteFast.h"

byte joyx,joyy,zbut,cbut,accy;

#define CLOCK 2 // set the clock pin (YELLOW)
#define LATCH 3 // set the latch pin (ORANGE)
#define DATA 4 // set the data pin (RED)

volatile int mode = 0;
volatile int dataBuf[17];

void latchRising()
{
  mode = 1;
  if(dataBuf[1] == HIGH)
  {
    digitalWriteFast2(DATA, HIGH);
  }
  else
  {
    digitalWriteFast2(DATA, LOW);
  }
}

void clockRising()
{
  mode++;
  if(dataBuf[mode] == HIGH)
  {
    digitalWriteFast2(DATA, HIGH);
  }
  else
  {
    digitalWriteFast2(DATA, LOW);
  }
    
  if(mode == 16)
  {
    digitalWriteFast2(DATA, HIGH);
  }
} 

/* SETUP */
void setup()
{
  int loop;
  for(loop = 0;loop<17;loop++)
    dataBuf[loop] = HIGH;
  pinMode(LATCH,INPUT);
  pinMode(CLOCK,INPUT);
  pinModeFast2(DATA,OUTPUT);
  digitalWriteFast2(DATA, HIGH);
  attachInterrupt(0, clockRising, RISING);
  attachInterrupt(1, latchRising, RISING);
  
  Serial.begin(115200);
  
  nunchuck_setpowerpins();
  nunchuck_init(); // send the initilization handshake
}

/* PROGRAM */
void loop()
{ 
  nunchuck_get_data();
  
  joyx  = nunchuck_joyx(); // ranges from approx 70 - 182
  
  if(joyx<83) // LEFT
    dataBuf[7] = LOW;
  else
    dataBuf[7] = HIGH;
    
  if(joyx>177) // RIGHT
    dataBuf[8] = LOW;
  else
    dataBuf[8] = HIGH;
  
  joyy  = nunchuck_joyy(); // ranges from approx 65 - 173
  
  if(joyy>182) // UP
    dataBuf[5] = LOW;
  else
    dataBuf[5] = HIGH;
 
  if(joyy<89) // DOWN
    dataBuf[6] = LOW;
  else
    dataBuf[6] = HIGH;
  
  zbut = nunchuck_zbutton();
  
  // hack for random pausing
  if(zbut && dataBuf[5] == HIGH)
    dataBuf[1] = LOW;
  else
    dataBuf[1] = HIGH;
    
  cbut = nunchuck_cbutton();
  
  // hack for random pausing
  if(cbut && dataBuf[5] == HIGH)
    dataBuf[2] = LOW;
  else
    dataBuf[2] = HIGH;
    
  accy = nunchuck_accely();

  // if we hold the wiimote up and press C+Z, then hit START
  if((accy < 80) && cbut && zbut)
  {
    dataBuf[4] = LOW;
    dataBuf[1] = HIGH;
    dataBuf[1] = HIGH;
  }

  delay(30);
  dataBuf[4] = HIGH;
  //nunchuck_print_data();
} 
