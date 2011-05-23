#include <Wire.h>
#include "nunchuck_funcs.h"

byte joyx,joyy,zbut,cbut;

int clock = 2; // set the clock pin (RED)
int latch = 3; // set the latch pin (ORANGE)
int data  = 4; // set the data pin (YELLOW)

volatile int mode = 0;
volatile int dataBuf[17];

void latchRising()
{
  mode = 1;
  digitalWrite(data, dataBuf[1]);
}

void clockRising()
{
  digitalWrite(data, dataBuf[++mode]);
  if(mode == 16)
    digitalWrite(data, LOW);
} 

/* SETUP */
void setup()
{
  int loop;
  for(loop = 0;loop<17;loop++)
    dataBuf[loop] = HIGH;
  pinMode(latch,INPUT);
  pinMode(clock,INPUT);
  pinMode(data,OUTPUT);
  digitalWrite(data, LOW);
  attachInterrupt(0, clockRising, RISING);
  attachInterrupt(1, latchRising, RISING);
  
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
  
  if(zbut)
    dataBuf[1] = LOW;
  else
    dataBuf[1] = HIGH;
    
  cbut = nunchuck_cbutton();
  
  if(cbut)
    dataBuf[2] = LOW;
  else
    dataBuf[2] = HIGH;

  delay(30);
} 
