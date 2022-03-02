
_init:

;MyProject.c,20 :: 		void init()
;MyProject.c,22 :: 		GIE_bit=1;
	BSF        GIE_bit+0, BitPos(GIE_bit+0)
;MyProject.c,23 :: 		PEIE_bit=1;
	BSF        PEIE_bit+0, BitPos(PEIE_bit+0)
;MyProject.c,24 :: 		INTE_bit=1;
	BSF        INTE_bit+0, BitPos(INTE_bit+0)
;MyProject.c,25 :: 		TMR1IE_bit=1;
	BSF        TMR1IE_bit+0, BitPos(TMR1IE_bit+0)
;MyProject.c,26 :: 		TRISB0_bit=1;
	BSF        TRISB0_bit+0, BitPos(TRISB0_bit+0)
;MyProject.c,27 :: 		TRISB4_bit=1;
	BSF        TRISB4_bit+0, BitPos(TRISB4_bit+0)
;MyProject.c,28 :: 		TRISB5_bit=1;
	BSF        TRISB5_bit+0, BitPos(TRISB5_bit+0)
;MyProject.c,29 :: 		INTEDG_bit=1;
	BSF        INTEDG_bit+0, BitPos(INTEDG_bit+0)
;MyProject.c,30 :: 		TMR1CS_bit=0;
	BCF        TMR1CS_bit+0, BitPos(TMR1CS_bit+0)
;MyProject.c,31 :: 		TMR1H=0;
	CLRF       TMR1H+0
;MyProject.c,32 :: 		TMR1L=0;
	CLRF       TMR1L+0
;MyProject.c,33 :: 		T1CKPS0_bit=1;
	BSF        T1CKPS0_bit+0, BitPos(T1CKPS0_bit+0)
;MyProject.c,34 :: 		T1CKPS1_bit=1;
	BSF        T1CKPS1_bit+0, BitPos(T1CKPS1_bit+0)
;MyProject.c,35 :: 		greska=v_zeljeno;
	MOVF       _v_zeljeno+0, 0
	MOVWF      _greska+0
	MOVF       _v_zeljeno+1, 0
	MOVWF      _greska+1
	MOVF       _v_zeljeno+2, 0
	MOVWF      _greska+2
	MOVF       _v_zeljeno+3, 0
	MOVWF      _greska+3
;MyProject.c,36 :: 		greska_prije=greska*0.25;
	MOVF       _v_zeljeno+0, 0
	MOVWF      R0+0
	MOVF       _v_zeljeno+1, 0
	MOVWF      R0+1
	MOVF       _v_zeljeno+2, 0
	MOVWF      R0+2
	MOVF       _v_zeljeno+3, 0
	MOVWF      R0+3
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      0
	MOVWF      R4+2
	MOVLW      125
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      _greska_prije+0
	MOVF       R0+1, 0
	MOVWF      _greska_prije+1
	MOVF       R0+2, 0
	MOVWF      _greska_prije+2
	MOVF       R0+3, 0
	MOVWF      _greska_prije+3
;MyProject.c,37 :: 		TMR1ON_bit=1;
	BSF        TMR1ON_bit+0, BitPos(TMR1ON_bit+0)
;MyProject.c,38 :: 		UART1_Init(9600);
	MOVLW      51
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;MyProject.c,39 :: 		Lcd_Init();
	CALL       _Lcd_Init+0
;MyProject.c,40 :: 		}
L_end_init:
	RETURN
; end of _init

_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;MyProject.c,41 :: 		void interrupt()
;MyProject.c,44 :: 		if(TMR1IF_bit)        //0.25   *4
	BTFSS      TMR1IF_bit+0, BitPos(TMR1IF_bit+0)
	GOTO       L_interrupt0
;MyProject.c,46 :: 		TMR1H=0x00;
	CLRF       TMR1H+0
;MyProject.c,47 :: 		TMR1L=0x00;
	CLRF       TMR1L+0
;MyProject.c,48 :: 		v1=count;                           //60*4/240=1 OKO JEDNE ROTACIJE REZOLUCIJA
	MOVF       _count+0, 0
	MOVWF      R0+0
	MOVF       _count+1, 0
	MOVWF      R0+1
	CALL       _int2double+0
	MOVF       R0+0, 0
	MOVWF      _v1+0
	MOVF       R0+1, 0
	MOVWF      _v1+1
	MOVF       R0+2, 0
	MOVWF      _v1+2
	MOVF       R0+3, 0
	MOVWF      _v1+3
;MyProject.c,49 :: 		brzina[0]=(int)v1/100+48;
	CALL       _double2int+0
	MOVF       R0+0, 0
	MOVWF      FLOC__interrupt+0
	MOVF       R0+1, 0
	MOVWF      FLOC__interrupt+1
	MOVLW      100
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       FLOC__interrupt+0, 0
	MOVWF      R0+0
	MOVF       FLOC__interrupt+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_S+0
	MOVLW      48
	ADDWF      R0+0, 0
	MOVWF      _brzina+0
;MyProject.c,50 :: 		brzina[1]=(((int)v1)/10)%10+48;
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       FLOC__interrupt+0, 0
	MOVWF      R0+0
	MOVF       FLOC__interrupt+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_S+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16x16_S+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVLW      48
	ADDWF      R0+0, 0
	MOVWF      _brzina+1
;MyProject.c,51 :: 		brzina[2]=(int)v1%10+48;
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       FLOC__interrupt+0, 0
	MOVWF      R0+0
	MOVF       FLOC__interrupt+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_S+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVLW      48
	ADDWF      R0+0, 0
	MOVWF      _brzina+2
;MyProject.c,52 :: 		Lcd_Out(1,1,"BRZINA: ");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_MyProject+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;MyProject.c,53 :: 		Lcd_Out(2,1,brzina);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _brzina+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;MyProject.c,54 :: 		UART1_Write_Text(brzina);
	MOVLW      _brzina+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;MyProject.c,55 :: 		count=0;
	CLRF       _count+0
	CLRF       _count+1
;MyProject.c,56 :: 		greska=v_zeljeno-v1;
	MOVF       _v1+0, 0
	MOVWF      R4+0
	MOVF       _v1+1, 0
	MOVWF      R4+1
	MOVF       _v1+2, 0
	MOVWF      R4+2
	MOVF       _v1+3, 0
	MOVWF      R4+3
	MOVF       _v_zeljeno+0, 0
	MOVWF      R0+0
	MOVF       _v_zeljeno+1, 0
	MOVWF      R0+1
	MOVF       _v_zeljeno+2, 0
	MOVWF      R0+2
	MOVF       _v_zeljeno+3, 0
	MOVWF      R0+3
	CALL       _Sub_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      FLOC__interrupt+12
	MOVF       R0+1, 0
	MOVWF      FLOC__interrupt+13
	MOVF       R0+2, 0
	MOVWF      FLOC__interrupt+14
	MOVF       R0+3, 0
	MOVWF      FLOC__interrupt+15
	MOVF       FLOC__interrupt+12, 0
	MOVWF      _greska+0
	MOVF       FLOC__interrupt+13, 0
	MOVWF      _greska+1
	MOVF       FLOC__interrupt+14, 0
	MOVWF      _greska+2
	MOVF       FLOC__interrupt+15, 0
	MOVWF      _greska+3
;MyProject.c,57 :: 		greska_izvod=(izvod-greska)*0.25;
	MOVF       FLOC__interrupt+12, 0
	MOVWF      R4+0
	MOVF       FLOC__interrupt+13, 0
	MOVWF      R4+1
	MOVF       FLOC__interrupt+14, 0
	MOVWF      R4+2
	MOVF       FLOC__interrupt+15, 0
	MOVWF      R4+3
	MOVF       _izvod+0, 0
	MOVWF      R0+0
	MOVF       _izvod+1, 0
	MOVWF      R0+1
	MOVF       _izvod+2, 0
	MOVWF      R0+2
	MOVF       _izvod+3, 0
	MOVWF      R0+3
	CALL       _Sub_32x32_FP+0
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      0
	MOVWF      R4+2
	MOVLW      125
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      FLOC__interrupt+8
	MOVF       R0+1, 0
	MOVWF      FLOC__interrupt+9
	MOVF       R0+2, 0
	MOVWF      FLOC__interrupt+10
	MOVF       R0+3, 0
	MOVWF      FLOC__interrupt+11
	MOVF       FLOC__interrupt+8, 0
	MOVWF      _greska_izvod+0
	MOVF       FLOC__interrupt+9, 0
	MOVWF      _greska_izvod+1
	MOVF       FLOC__interrupt+10, 0
	MOVWF      _greska_izvod+2
	MOVF       FLOC__interrupt+11, 0
	MOVWF      _greska_izvod+3
;MyProject.c,58 :: 		izvod=greska;
	MOVF       FLOC__interrupt+12, 0
	MOVWF      _izvod+0
	MOVF       FLOC__interrupt+13, 0
	MOVWF      _izvod+1
	MOVF       FLOC__interrupt+14, 0
	MOVWF      _izvod+2
	MOVF       FLOC__interrupt+15, 0
	MOVWF      _izvod+3
;MyProject.c,59 :: 		greska_prije=greska_prije+(greska*0.25);
	MOVF       FLOC__interrupt+12, 0
	MOVWF      R0+0
	MOVF       FLOC__interrupt+13, 0
	MOVWF      R0+1
	MOVF       FLOC__interrupt+14, 0
	MOVWF      R0+2
	MOVF       FLOC__interrupt+15, 0
	MOVWF      R0+3
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      0
	MOVWF      R4+2
	MOVLW      125
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	MOVF       _greska_prije+0, 0
	MOVWF      R4+0
	MOVF       _greska_prije+1, 0
	MOVWF      R4+1
	MOVF       _greska_prije+2, 0
	MOVWF      R4+2
	MOVF       _greska_prije+3, 0
	MOVWF      R4+3
	CALL       _Add_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      FLOC__interrupt+4
	MOVF       R0+1, 0
	MOVWF      FLOC__interrupt+5
	MOVF       R0+2, 0
	MOVWF      FLOC__interrupt+6
	MOVF       R0+3, 0
	MOVWF      FLOC__interrupt+7
	MOVF       FLOC__interrupt+4, 0
	MOVWF      _greska_prije+0
	MOVF       FLOC__interrupt+5, 0
	MOVWF      _greska_prije+1
	MOVF       FLOC__interrupt+6, 0
	MOVWF      _greska_prije+2
	MOVF       FLOC__interrupt+7, 0
	MOVWF      _greska_prije+3
;MyProject.c,60 :: 		pom=(greska*kp+(greska_prije*ki)+kd*greska_izvod);          // za toliko odsupa 1/4 nije 0.26777 otprilike     +pom*0.027
	MOVF       FLOC__interrupt+12, 0
	MOVWF      R0+0
	MOVF       FLOC__interrupt+13, 0
	MOVWF      R0+1
	MOVF       FLOC__interrupt+14, 0
	MOVWF      R0+2
	MOVF       FLOC__interrupt+15, 0
	MOVWF      R0+3
	MOVF       _kp+0, 0
	MOVWF      R4+0
	MOVF       _kp+1, 0
	MOVWF      R4+1
	MOVF       _kp+2, 0
	MOVWF      R4+2
	MOVF       _kp+3, 0
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      FLOC__interrupt+0
	MOVF       R0+1, 0
	MOVWF      FLOC__interrupt+1
	MOVF       R0+2, 0
	MOVWF      FLOC__interrupt+2
	MOVF       R0+3, 0
	MOVWF      FLOC__interrupt+3
	MOVF       FLOC__interrupt+4, 0
	MOVWF      R0+0
	MOVF       FLOC__interrupt+5, 0
	MOVWF      R0+1
	MOVF       FLOC__interrupt+6, 0
	MOVWF      R0+2
	MOVF       FLOC__interrupt+7, 0
	MOVWF      R0+3
	MOVF       _ki+0, 0
	MOVWF      R4+0
	MOVF       _ki+1, 0
	MOVWF      R4+1
	MOVF       _ki+2, 0
	MOVWF      R4+2
	MOVF       _ki+3, 0
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	MOVF       FLOC__interrupt+0, 0
	MOVWF      R4+0
	MOVF       FLOC__interrupt+1, 0
	MOVWF      R4+1
	MOVF       FLOC__interrupt+2, 0
	MOVWF      R4+2
	MOVF       FLOC__interrupt+3, 0
	MOVWF      R4+3
	CALL       _Add_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      FLOC__interrupt+0
	MOVF       R0+1, 0
	MOVWF      FLOC__interrupt+1
	MOVF       R0+2, 0
	MOVWF      FLOC__interrupt+2
	MOVF       R0+3, 0
	MOVWF      FLOC__interrupt+3
	MOVF       _kd+0, 0
	MOVWF      R0+0
	MOVF       _kd+1, 0
	MOVWF      R0+1
	MOVF       _kd+2, 0
	MOVWF      R0+2
	MOVF       _kd+3, 0
	MOVWF      R0+3
	MOVF       FLOC__interrupt+8, 0
	MOVWF      R4+0
	MOVF       FLOC__interrupt+9, 0
	MOVWF      R4+1
	MOVF       FLOC__interrupt+10, 0
	MOVWF      R4+2
	MOVF       FLOC__interrupt+11, 0
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	MOVF       FLOC__interrupt+0, 0
	MOVWF      R4+0
	MOVF       FLOC__interrupt+1, 0
	MOVWF      R4+1
	MOVF       FLOC__interrupt+2, 0
	MOVWF      R4+2
	MOVF       FLOC__interrupt+3, 0
	MOVWF      R4+3
	CALL       _Add_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      _pom+0
	MOVF       R0+1, 0
	MOVWF      _pom+1
	MOVF       R0+2, 0
	MOVWF      _pom+2
	MOVF       R0+3, 0
	MOVWF      _pom+3
;MyProject.c,61 :: 		faktor_ispune=(char)(pom);
	CALL       _double2byte+0
	MOVF       R0+0, 0
	MOVWF      _faktor_ispune+0
;MyProject.c,63 :: 		if(greska>0)
	MOVF       FLOC__interrupt+12, 0
	MOVWF      R4+0
	MOVF       FLOC__interrupt+13, 0
	MOVWF      R4+1
	MOVF       FLOC__interrupt+14, 0
	MOVWF      R4+2
	MOVF       FLOC__interrupt+15, 0
	MOVWF      R4+3
	CLRF       R0+0
	CLRF       R0+1
	CLRF       R0+2
	CLRF       R0+3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt1
;MyProject.c,65 :: 		PWM1_Set_Duty(faktor_ispune);
	MOVF       _faktor_ispune+0, 0
	MOVWF      FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;MyProject.c,66 :: 		PWM2_Set_Duty(0);
	CLRF       FARG_PWM2_Set_Duty_new_duty+0
	CALL       _PWM2_Set_Duty+0
;MyProject.c,67 :: 		}            //
	GOTO       L_interrupt2
L_interrupt1:
;MyProject.c,70 :: 		PWM1_Set_Duty(0);
	CLRF       FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;MyProject.c,72 :: 		}
L_interrupt2:
;MyProject.c,73 :: 		TMR1IF_bit=0;
	BCF        TMR1IF_bit+0, BitPos(TMR1IF_bit+0)
;MyProject.c,74 :: 		}
L_interrupt0:
;MyProject.c,75 :: 		if(INTF_bit&&!TMR1IF_bit)
	BTFSS      INTF_bit+0, BitPos(INTF_bit+0)
	GOTO       L_interrupt5
	BTFSC      TMR1IF_bit+0, BitPos(TMR1IF_bit+0)
	GOTO       L_interrupt5
L__interrupt8:
;MyProject.c,77 :: 		count++;
	INCF       _count+0, 1
	BTFSC      STATUS+0, 2
	INCF       _count+1, 1
;MyProject.c,78 :: 		INTF_bit=0;
	BCF        INTF_bit+0, BitPos(INTF_bit+0)
;MyProject.c,79 :: 		}
L_interrupt5:
;MyProject.c,80 :: 		}
L_end_interrupt:
L__interrupt11:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;MyProject.c,81 :: 		void main()
;MyProject.c,83 :: 		PWM1_Init(500);
	BSF        T2CON+0, 0
	BSF        T2CON+0, 1
	MOVLW      249
	MOVWF      PR2+0
	CALL       _PWM1_Init+0
;MyProject.c,84 :: 		PWM2_Init(500);
	BSF        T2CON+0, 0
	BSF        T2CON+0, 1
	MOVLW      249
	MOVWF      PR2+0
	CALL       _PWM2_Init+0
;MyProject.c,85 :: 		PWM2_Start();
	CALL       _PWM2_Start+0
;MyProject.c,86 :: 		PWM1_Start();
	CALL       _PWM1_Start+0
;MyProject.c,87 :: 		init();
	CALL       _init+0
;MyProject.c,88 :: 		while(1)
L_main6:
;MyProject.c,90 :: 		}
	GOTO       L_main6
;MyProject.c,91 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
