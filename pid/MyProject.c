sbit LCD_RS at RD4_bit;
sbit LCD_EN at RD5_bit;
sbit LCD_D4 at RD0_bit;
sbit LCD_D5 at RD1_bit;
sbit LCD_D6 at RD2_bit;
sbit LCD_D7 at RD3_bit;
sbit LCD_RS_Direction at TRISD4_bit;
sbit LCD_EN_Direction at TRISD5_bit;
sbit LCD_D4_Direction at TRISD0_bit;
sbit LCD_D5_Direction at TRISD1_bit;
sbit LCD_D6_Direction at TRISD2_bit;
sbit LCD_D7_Direction at TRISD3_bit;
float kp=20;
float ki=0.5;
float kd=0;
int count=0;
float v1=0.0,v_zeljeno=100.0,greska,greska_prije=0,greska_izvod=0,izvod=0,pom;      //V_ZELJENEO MAX=360 RPM TU SE POSAVLJA BRZINA
char faktor_ispune=0,count1=0;
char brzina[]="000RPM ",primljena_brzina[]="000";
void init()
{
 GIE_bit=1;
 PEIE_bit=1;
 INTE_bit=1;
 TMR1IE_bit=1;
 TRISB0_bit=1;
 TRISB4_bit=1;
 TRISB5_bit=1;
 INTEDG_bit=1;
 TMR1CS_bit=0;
 TMR1H=0;
 TMR1L=0;
 T1CKPS0_bit=1;
 T1CKPS1_bit=1;
 greska=v_zeljeno;
 greska_prije=greska*0.25;
 TMR1ON_bit=1;
 UART1_Init(9600);
 Lcd_Init();
}
void interrupt()
{

  if(TMR1IF_bit)        //0.25   *4
  {
   TMR1H=0x00;
   TMR1L=0x00;
   v1=count;                           //60*4/240=1 OKO JEDNE ROTACIJE REZOLUCIJA
   brzina[0]=(int)v1/100+48;
   brzina[1]=(((int)v1)/10)%10+48;
   brzina[2]=(int)v1%10+48;
   Lcd_Out(1,1,"BRZINA: ");
   Lcd_Out(2,1,brzina);
   UART1_Write_Text(brzina);
   count=0;
   greska=v_zeljeno-v1;
   greska_izvod=(izvod-greska)*0.25;
   izvod=greska;
   greska_prije=greska_prije+(greska*0.25);
   pom=(greska*kp+(greska_prije*ki)+kd*greska_izvod);          // za toliko odsupa 1/4 nije 0.26777 otprilike     +pom*0.027
   faktor_ispune=(char)(pom);

  if(greska>0)
  {
    PWM1_Set_Duty(faktor_ispune);
    PWM2_Set_Duty(0);
  }            //
  else
  { 
   PWM1_Set_Duty(0);
   //PWM2_Set_Duty(faktor_ispune);
  }
   TMR1IF_bit=0;
  }
   if(INTF_bit&&!TMR1IF_bit)
  {
   count++;
   INTF_bit=0;
  }
}
void main()
{
  PWM1_Init(500);
  PWM2_Init(500);
  PWM2_Start();
  PWM1_Start();
  init();
 while(1)
 {
 }
 }