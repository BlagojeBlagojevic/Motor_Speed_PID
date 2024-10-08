#line 1 "C:/Users/BLAGI/Desktop/ev/4a/MIKS/pid/MicroCProject/MyProject.c"
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
float kp = 45;
float ki = 108;
float kd = 0;
int count = 0;
float v1 = 0.0,v_des = 100.0, err, err_bef = 0.0f, err_der = 0, der = 0, pom;
char PWM = 0, count1 = 0;
char speed_text[] = "000RPM ", rec_speed[] = "000";
char speed[10];
void init()
{
 GIE_bit = 1;
 PEIE_bit = 1;
 INTE_bit = 1;
 TMR1IE_bit = 1;
 TRISB0_bit = 1;
 TRISB4_bit = 1;
 TRISB5_bit = 1;
 INTEDG_bit = 1;
 TMR1CS_bit = 0;
 TMR1H = 0;
 TMR1L = 0;
 T1CKPS0_bit = 1;
 T1CKPS1_bit = 1;
 err = v_des;
 err_bef = err * 0.25;
 TMR1ON_bit=1;
 UART1_Init(9600);
 Lcd_Init();
}
void interrupt()
{
 if(TMR1IF_bit)
 {
 TMR1H= 0x00;
 TMR1L = 0x00;
 v1 = count;
 speed_text[0]=(int)v1/100+48;
 speed_text[1]=(((int)v1)/10)%10+48;
 speed_text[2]=(int)v1%10+48;



 UART1_Write_Text(speed_text);
 count = 0;
 err = v_des - v1;
 err_der = (der - err) * 0.25;
 der = err;
 err_bef = err_bef + (err);
 pom = (err * kp + (err_bef * ki) + kd * err_der);
 PWM = (char)(pom );
 if(err > 0)
 {
 PWM1_Set_Duty(PWM);
 PWM2_Set_Duty(0);
 }
 else
 {
 PWM1_Set_Duty(0);
 PWM2_Set_Duty(PWM);
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
 PWM1_Init( 500 );
 PWM2_Init( 500 );
 PWM2_Start();
 PWM1_Start();
 init();

 while(1)
 {

 if (UART1_Data_Ready() == 1) {
 UART1_Read_Text(speed, "OK", 6);
 v_des = ((speed[0] - '0') * 100 + (speed[1] - '0') * 10 + (speed[2] - '0') * 1);
 speed[0] = '\0';
 }
#line 124 "C:/Users/BLAGI/Desktop/ev/4a/MIKS/pid/MicroCProject/MyProject.c"
 }

 }
