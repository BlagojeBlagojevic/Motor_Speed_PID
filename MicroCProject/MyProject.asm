
_init:

;MyProject.c,21 :: 		void init()
;MyProject.c,23 :: 		GIE_bit = 1;
	BSF        GIE_bit+0, BitPos(GIE_bit+0)
;MyProject.c,24 :: 		PEIE_bit = 1;
	BSF        PEIE_bit+0, BitPos(PEIE_bit+0)
;MyProject.c,25 :: 		INTE_bit = 1;
	BSF        INTE_bit+0, BitPos(INTE_bit+0)
;MyProject.c,26 :: 		TMR1IE_bit = 1;
	BSF        TMR1IE_bit+0, BitPos(TMR1IE_bit+0)
;MyProject.c,27 :: 		TRISB0_bit = 1;
	BSF        TRISB0_bit+0, BitPos(TRISB0_bit+0)
;MyProject.c,28 :: 		TRISB4_bit = 1;
	BSF        TRISB4_bit+0, BitPos(TRISB4_bit+0)
;MyProject.c,29 :: 		TRISB5_bit = 1;
	BSF        TRISB5_bit+0, BitPos(TRISB5_bit+0)
;MyProject.c,30 :: 		INTEDG_bit = 1;
	BSF        INTEDG_bit+0, BitPos(INTEDG_bit+0)
;MyProject.c,31 :: 		TMR1CS_bit = 0;
	BCF        TMR1CS_bit+0, BitPos(TMR1CS_bit+0)
;MyProject.c,32 :: 		TMR1H = 0;
	CLRF       TMR1H+0
;MyProject.c,33 :: 		TMR1L = 0;
	CLRF       TMR1L+0
;MyProject.c,34 :: 		T1CKPS0_bit = 1;
	BSF        T1CKPS0_bit+0, BitPos(T1CKPS0_bit+0)
;MyProject.c,35 :: 		T1CKPS1_bit = 1;
	BSF        T1CKPS1_bit+0, BitPos(T1CKPS1_bit+0)
;MyProject.c,36 :: 		err = v_des;
	MOVF       _v_des+0, 0
	MOVWF      _err+0
	MOVF       _v_des+1, 0
	MOVWF      _err+1
	MOVF       _v_des+2, 0
	MOVWF      _err+2
	MOVF       _v_des+3, 0
	MOVWF      _err+3
;MyProject.c,37 :: 		err_bef = err * 0.25;
	MOVF       _v_des+0, 0
	MOVWF      R0+0
	MOVF       _v_des+1, 0
	MOVWF      R0+1
	MOVF       _v_des+2, 0
	MOVWF      R0+2
	MOVF       _v_des+3, 0
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
	MOVWF      _err_bef+0
	MOVF       R0+1, 0
	MOVWF      _err_bef+1
	MOVF       R0+2, 0
	MOVWF      _err_bef+2
	MOVF       R0+3, 0
	MOVWF      _err_bef+3
;MyProject.c,38 :: 		TMR1ON_bit=1;
	BSF        TMR1ON_bit+0, BitPos(TMR1ON_bit+0)
;MyProject.c,39 :: 		UART1_Init(9600);
	MOVLW      51
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;MyProject.c,40 :: 		Lcd_Init();
	CALL       _Lcd_Init+0
;MyProject.c,41 :: 		}
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

;MyProject.c,42 :: 		void interrupt()
;MyProject.c,44 :: 		if(TMR1IF_bit)        //0.25   *4
	BTFSS      TMR1IF_bit+0, BitPos(TMR1IF_bit+0)
	GOTO       L_interrupt0
;MyProject.c,46 :: 		TMR1H= 0x00;
	CLRF       TMR1H+0
;MyProject.c,47 :: 		TMR1L = 0x00;
	CLRF       TMR1L+0
;MyProject.c,48 :: 		v1 = count;                           //60*4/240=1 OKO JEDNE ROTACIJE REZOLUCIJA
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
;MyProject.c,49 :: 		speed_text[0]=(int)v1/100+48;
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
	MOVWF      _speed_text+0
;MyProject.c,50 :: 		speed_text[1]=(((int)v1)/10)%10+48;
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
	MOVWF      _speed_text+1
;MyProject.c,51 :: 		speed_text[2]=(int)v1%10+48;
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
	MOVWF      _speed_text+2
;MyProject.c,55 :: 		UART1_Write_Text(speed_text);
	MOVLW      _speed_text+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;MyProject.c,56 :: 		count = 0;
	CLRF       _count+0
	CLRF       _count+1
;MyProject.c,57 :: 		err = v_des - v1;
	MOVF       _v1+0, 0
	MOVWF      R4+0
	MOVF       _v1+1, 0
	MOVWF      R4+1
	MOVF       _v1+2, 0
	MOVWF      R4+2
	MOVF       _v1+3, 0
	MOVWF      R4+3
	MOVF       _v_des+0, 0
	MOVWF      R0+0
	MOVF       _v_des+1, 0
	MOVWF      R0+1
	MOVF       _v_des+2, 0
	MOVWF      R0+2
	MOVF       _v_des+3, 0
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
	MOVWF      _err+0
	MOVF       FLOC__interrupt+13, 0
	MOVWF      _err+1
	MOVF       FLOC__interrupt+14, 0
	MOVWF      _err+2
	MOVF       FLOC__interrupt+15, 0
	MOVWF      _err+3
;MyProject.c,58 :: 		err_der = (der - err) * 0.25;
	MOVF       FLOC__interrupt+12, 0
	MOVWF      R4+0
	MOVF       FLOC__interrupt+13, 0
	MOVWF      R4+1
	MOVF       FLOC__interrupt+14, 0
	MOVWF      R4+2
	MOVF       FLOC__interrupt+15, 0
	MOVWF      R4+3
	MOVF       _der+0, 0
	MOVWF      R0+0
	MOVF       _der+1, 0
	MOVWF      R0+1
	MOVF       _der+2, 0
	MOVWF      R0+2
	MOVF       _der+3, 0
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
	MOVWF      _err_der+0
	MOVF       FLOC__interrupt+9, 0
	MOVWF      _err_der+1
	MOVF       FLOC__interrupt+10, 0
	MOVWF      _err_der+2
	MOVF       FLOC__interrupt+11, 0
	MOVWF      _err_der+3
;MyProject.c,59 :: 		der = err;
	MOVF       FLOC__interrupt+12, 0
	MOVWF      _der+0
	MOVF       FLOC__interrupt+13, 0
	MOVWF      _der+1
	MOVF       FLOC__interrupt+14, 0
	MOVWF      _der+2
	MOVF       FLOC__interrupt+15, 0
	MOVWF      _der+3
;MyProject.c,60 :: 		err_bef = err_bef + (err);
	MOVF       _err_bef+0, 0
	MOVWF      R0+0
	MOVF       _err_bef+1, 0
	MOVWF      R0+1
	MOVF       _err_bef+2, 0
	MOVWF      R0+2
	MOVF       _err_bef+3, 0
	MOVWF      R0+3
	MOVF       FLOC__interrupt+12, 0
	MOVWF      R4+0
	MOVF       FLOC__interrupt+13, 0
	MOVWF      R4+1
	MOVF       FLOC__interrupt+14, 0
	MOVWF      R4+2
	MOVF       FLOC__interrupt+15, 0
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
	MOVWF      _err_bef+0
	MOVF       FLOC__interrupt+5, 0
	MOVWF      _err_bef+1
	MOVF       FLOC__interrupt+6, 0
	MOVWF      _err_bef+2
	MOVF       FLOC__interrupt+7, 0
	MOVWF      _err_bef+3
;MyProject.c,61 :: 		pom = (err * kp + (err_bef * ki) + kd * err_der);          // za toliko odsupa 1/4 nije 0.26777 otprilike     +pom*0.027
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
;MyProject.c,62 :: 		PWM = (char)(pom );
	CALL       _double2byte+0
	MOVF       R0+0, 0
	MOVWF      _PWM+0
;MyProject.c,63 :: 		if(err > 0)
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
;MyProject.c,65 :: 		PWM1_Set_Duty(PWM);
	MOVF       _PWM+0, 0
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
;MyProject.c,71 :: 		PWM2_Set_Duty(PWM);
	MOVF       _PWM+0, 0
	MOVWF      FARG_PWM2_Set_Duty_new_duty+0
	CALL       _PWM2_Set_Duty+0
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
L__interrupt9:
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
L__interrupt12:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;MyProject.c,87 :: 		void main()
;MyProject.c,89 :: 		PWM1_Init(FREQ);
	BSF        T2CON+0, 0
	BSF        T2CON+0, 1
	MOVLW      249
	MOVWF      PR2+0
	CALL       _PWM1_Init+0
;MyProject.c,90 :: 		PWM2_Init(FREQ);
	BSF        T2CON+0, 0
	BSF        T2CON+0, 1
	MOVLW      249
	MOVWF      PR2+0
	CALL       _PWM2_Init+0
;MyProject.c,91 :: 		PWM2_Start();
	CALL       _PWM2_Start+0
;MyProject.c,92 :: 		PWM1_Start();
	CALL       _PWM1_Start+0
;MyProject.c,93 :: 		init();
	CALL       _init+0
;MyProject.c,95 :: 		while(1)
L_main6:
;MyProject.c,98 :: 		if (UART1_Data_Ready() == 1) {
	CALL       _UART1_Data_Ready+0
	MOVF       R0+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_main8
;MyProject.c,99 :: 		UART1_Read_Text(speed, "OK", 6);//speed[4] = '\0';
	MOVLW      _speed+0
	MOVWF      FARG_UART1_Read_Text_Output+0
	MOVLW      ?lstr1_MyProject+0
	MOVWF      FARG_UART1_Read_Text_Delimiter+0
	MOVLW      6
	MOVWF      FARG_UART1_Read_Text_Attempts+0
	CALL       _UART1_Read_Text+0
;MyProject.c,100 :: 		v_des = ((speed[0] - '0') * 100 + (speed[1] - '0') * 10 + (speed[2] - '0') * 1);
	MOVLW      48
	SUBWF      _speed+0, 0
	MOVWF      R0+0
	CLRF       R0+1
	BTFSS      STATUS+0, 0
	DECF       R0+1, 1
	MOVLW      100
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Mul_16X16_U+0
	MOVF       R0+0, 0
	MOVWF      FLOC__main+0
	MOVF       R0+1, 0
	MOVWF      FLOC__main+1
	MOVLW      48
	SUBWF      _speed+1, 0
	MOVWF      R0+0
	CLRF       R0+1
	BTFSS      STATUS+0, 0
	DECF       R0+1, 1
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Mul_16X16_U+0
	MOVF       R0+0, 0
	ADDWF      FLOC__main+0, 0
	MOVWF      R2+0
	MOVF       FLOC__main+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      R0+1, 0
	MOVWF      R2+1
	MOVLW      48
	SUBWF      _speed+2, 0
	MOVWF      R0+0
	CLRF       R0+1
	BTFSS      STATUS+0, 0
	DECF       R0+1, 1
	MOVF       R2+0, 0
	ADDWF      R0+0, 1
	MOVF       R2+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      R0+1, 1
	CALL       _int2double+0
	MOVF       R0+0, 0
	MOVWF      _v_des+0
	MOVF       R0+1, 0
	MOVWF      _v_des+1
	MOVF       R0+2, 0
	MOVWF      _v_des+2
	MOVF       R0+3, 0
	MOVWF      _v_des+3
;MyProject.c,101 :: 		speed[0] = '\0';
	CLRF       _speed+0
;MyProject.c,102 :: 		}
L_main8:
;MyProject.c,124 :: 		}
	GOTO       L_main6
;MyProject.c,126 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
