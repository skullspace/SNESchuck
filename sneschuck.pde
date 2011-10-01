#include <Wire.h>
#include "digitalWriteFast.h"
#include "nunchuck_funcs.h"

byte joyx,joyy,zbut,cbut,accy;

#define P1_B       7
#define P1_Y       1
#define P1_SELECT  5
#define P1_START   4
#define P1_UP      3
#define P1_DOWN    2
#define P1_LEFT    6
#define P1_RIGHT   0

#define P1_A       7
#define P1_X       9
#define P1_L       10
#define P1_R       11

/* SETUP */
void setup()
{
  pinMode(P1_B, OUTPUT);
  pinMode(P1_Y, OUTPUT);
  pinMode(P1_SELECT, OUTPUT);
  pinMode(P1_START, OUTPUT);
  pinMode(P1_UP, OUTPUT);
  pinMode(P1_DOWN, OUTPUT);
  pinMode(P1_LEFT, OUTPUT);
  pinMode(P1_RIGHT, OUTPUT);
  
  pinMode(P1_A, OUTPUT);
  pinMode(P1_X, OUTPUT);
  pinMode(P1_L, OUTPUT);
  pinMode(P1_R, OUTPUT);
  
  digitalWriteFast2(P1_B, HIGH);
  digitalWriteFast2(P1_Y, HIGH);
  digitalWriteFast2(P1_SELECT, HIGH);
  digitalWriteFast2(P1_START, HIGH);
  digitalWriteFast2(P1_UP, HIGH);
  digitalWriteFast2(P1_DOWN, HIGH);
  digitalWriteFast2(P1_LEFT, HIGH);
  digitalWriteFast2(P1_RIGHT, HIGH);
  
  digitalWriteFast2(P1_A, HIGH);
  digitalWriteFast2(P1_X, HIGH);
  digitalWriteFast2(P1_L, HIGH);
  digitalWriteFast2(P1_R, HIGH); 
   
  //Serial.begin(115200);
  
  nunchuck_setpowerpins();
  nunchuck_init(); // send the initilization handshake
}

/* PROGRAM */
void loop()
{ 
  nunchuck_get_data();
  
  joyx  = nunchuck_joyx(); // ranges from approx 70 - 182
  
  if(joyx<83) // LEFT
  {
    digitalWriteFast2(P1_LEFT, LOW);
  }
  else
  {
    digitalWriteFast2(P1_LEFT, HIGH);
  }
    
  if(joyx>177) // RIGHT
  {
    digitalWriteFast2(P1_RIGHT, LOW);
  }
  else
  {
    digitalWriteFast2(P1_RIGHT, HIGH);
  }
  
  joyy  = nunchuck_joyy(); // ranges from approx 65 - 173
  
  if(joyy>182) // UP
  {
    digitalWriteFast2(P1_UP, LOW);
  }
  else
  {
    digitalWriteFast2(P1_UP, HIGH);
  }
 
  if(joyy<89) // DOWN
  {
    digitalWriteFast2(P1_DOWN, LOW);
  }
  else
  {
    digitalWriteFast2(P1_DOWN, HIGH);
  }
  
  
  
  zbut = nunchuck_zbutton();
  cbut = nunchuck_cbutton();
  accy = nunchuck_accely();
  
  if(accy > 105)
  {
    if(zbut)
    {
      digitalWriteFast2(P1_B, LOW);
    }
    else
    {
      digitalWriteFast2(P1_B, HIGH);
    }
    
    if(cbut)
    {
      digitalWriteFast2(P1_Y, LOW);
    }
    else
    {  
      digitalWriteFast2(P1_Y, HIGH);
    }
    
    digitalWriteFast2(P1_START, HIGH);
    digitalWriteFast2(P1_SELECT, HIGH);
  }
  // if we hold the wiimote up and press C+Z, then hit START
  else
  {
    if(cbut)
    {
      digitalWriteFast2(P1_START, LOW);
    }
    else
    {
      digitalWriteFast2(P1_START, HIGH);
    }
  
    if(zbut)
    {
      digitalWriteFast2(P1_SELECT, LOW);
    }
    else
    {
      digitalWriteFast2(P1_SELECT, HIGH);
    }
    
    digitalWriteFast2(P1_Y, HIGH);
    digitalWriteFast2(P1_B, HIGH);
  }

  delay(10);
  //nunchuck_print_data();
} 
