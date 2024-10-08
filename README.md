# ADJUSTMENT OF PID PARAMETERS IN CONTROL SYSTEMS AND DIGITAL PID REGULATOR DESIGN USING PIC16F887A

## 1. Introduction

Many industrial processes can be described as slow aperiodic processes with a delay.
We model such processes using a first-order aperiodic transfer function with dead time, which is described by the expression:
(1) $G(s) = \frac{K}{(1+sT)}\cdot{e^-(s*τ)}$.

The characteristic values ​​of this function are the coefficient
static gain `K`, time constant `T` and transport
delay `τ`. The most common type of control with this class of process is `PI` or `PID` control.
This paper will be based on the description of this class of processes and an overview of methods for designing `PID` controllers.
This paper will also describe the process of designing a digital `PID` controller for the speed of a DC motor using `pic16f877A` MCU and a rotary encoder.

## 2. Basic concepts of automatic control system regulation


This part explains the key concepts of automatic management and control, which form the basis of PID controller operation.

### 2.1 Definition of control

Control or regulation is the process of managing a system or process so that it achieves the desired behavior. This entails constantly monitoring the output of the system and comparing it with the desired value (reference value), and then adjusting the input accordingly to reduce the difference between the actual and the desired value.

- **System input**: A signal that is fed into a system to control its behavior. In industrial processes this can be, for example, electrical voltage, engine fuel or fluid flow.

- **System output**: A measured quantity that is obtained as a result of a controlled process, e.g. temperature, speed, pressure, position, etc.

- **Reference value (setpoint)**: It is the target value or desired outcome of the system. For example, in a temperature control system, the reference value may be a certain temperature that we want to achieve and maintain.

### 2.2 Importance of control

Control plays a key role in many engineering disciplines and industrial processes. Without a proper control system, many processes would be unstable or deviate from the desired performance. Therefore, the importance of control is significant in the following aspects:

- **Stability**: The control system makes it possible to achieve stability in systems that would otherwise be prone to oscillation or collapse. Stability means that the system, after a disturbance, will tend to return to the desired state.

- **Accuracy**: Control systems allow the system output to precisely follow the desired reference value, minimizing errors. Without effective control, the process could be inaccurate and far from the desired goal.

- **Response to changes and disturbances**: During operation, many systems are affected by external changes (eg changes in ambient temperature) or internal disturbances (eg variations in input signals). The control system enables adaptation to these changes and maintenance of stable working conditions.

- **Efficiency and Optimization**: Control is used to improve system efficiency, reduce unnecessary losses and achieve optimal use of resources, which is important in industrial processes, robotics, energy production and transportation.

### 2.3 Examples of control systems

Some examples of control systems are:

- **Temperature control** in industrial furnaces or air conditioners. The system uses sensors to measure the current temperature and a controller that adjusts heaters or cooling (PWM from capacitors) to maintain the desired temperature.

- **Speed ​​control** in car engines or vehicles with automatic steering. These systems automatically regulate engine power to maintain a constant speed regardless of load or road conditions.

- **Position control** in robotics, where the goal is to precisely control the position of the robot or the robot arm in order to achieve the desired point or path.



### 2.4 Division of control algorithms

Feedback control and non-feedback control are the two main control approaches in automated systems. They differ in how the process reacts to deviations from desired values.

#### 2.4.1 Control without feedback

In non-feedback control, also known as open-loop control, the output of the system is not measured or used to adjust the input signals. In this case, the controller does not receive feedback on the current state of the system, but manages the process based on predefined instructions or models.

![Open-loop-feedback-system](https://github.com/user-attachments/assets/bc35853e-f066-4217-887f-fda838df1c20)

`Figure 1. An example of an open loop process and its controller`



#### Examples of non-feedback control:

- **Microwave oven**: When we set the cooking time, the microwave will emit microwaves for a predetermined time regardless of whether the food is fully cooked or not. The system does not measure the temperature or the condition of the food, but only performs a predetermined task.

- **Automatic Watering**: An open loop garden watering system waters the garden forward by time interval, regardless of whether water is really needed or not (soil moisture is not measured).

#### Advantages and disadvantages:

- **Advantages**:
 - Simple implementation.
 - Cheaper technology because no sensors are needed.

- **Flaws**:
 - Lack of adaptability to conditions in real time.
 - The system can give bad results if the conditions change.

#### 2.4.2 Feedback control (Closed loop)

In **feedback control**, also known as **closed-loop control**, the output of the system is continuously measured and used as feedback to adjust the input signal. The controller compares the current output value with the desired (reference) value and adjusts the input to minimize the error between these two values.

![Screenshot_2](https://github.com/user-attachments/assets/2de4cf42-36d4-4f54-9ff4-2857c6be01e6)

`Figure 2. An example of a closed loop process and its controller`

#### Examples of feedback control:

- **Thermostat for temperature control**: The thermostat measures the current temperature in the room and, based on that, turns the heating on or off in order to maintain the desired temperature.

- **Car speed control (cruise control)**: The cruise control uses sensors to measure the car's speed and constantly adjusts the engine power even if it does not maintain the set speed, regardless of changes in the terrain (eg uphill or downhill).

- **Automatic Voltage Regulator**: Used in generators or electrical networks to maintain a constant output voltage. When it detects a change in voltage, it automatically adjusts the operation of the generator to bring the voltage back to the desired value.

#### Advantages and disadvantages:
- **Advantages**:
 - The system can adjust its behavior in real time to maintain a stable output.
 - Greater accuracy and efficiency in achieving management goals.

- **Flaws**:
 - Complex implementation, which requires sensors and additional electronics.
 - Calibration and adjustment are required for the system to work properly.


The most common type of closed loop control is the `PID` controller.



## 3. Closed-loop controllers (PID)

![pid](https://github.com/user-attachments/assets/fa66188c-8cee-4b8a-9f76-66232099308b)

`Figure 3. Example of a PID controller`

A **PID controller** is a type of control system that uses three components - proportional, integrative and derivative - to adjust the input signal and reduce the error between the desired and actual system output values. This control strategy enables stability, accuracy and quick response to changes in the process.



#### 3.1 Basic structure of PID controller

The PID controller combines the following components:

- **Proportional part (P)**: This part controls the instantaneous error between the reference value and the system output. The proportional signal is directly proportional to the magnitude of the error. If the error is large, the control signal will be larger to correct the error faster.


 (2) $u_P(t) = K_p \cdot e(t)$

 Where $K_p$ is the proportional coefficient, and $e(t)$ is the current error (the difference between the reference value and the actual value).

- **Integrative part (I)**: This component accumulates error over time. Its purpose is to correct permanent or long-term errors that the proportional part cannot completely eliminate, such as small but persistent differences between the desired and actual values.


 (3) $u_I(t) = K_i \cdot \int_0^t e(\tau) d\tau$

 Where $K_i$ is the integrative coefficient, and the error integration is performed over time.

- **Derivative part (D)**: The derivative part predicts future changes based on the rate of change of the error. This part is important for stabilizing the system and preventing oscillations, because it reacts to changes in error before they become too large.


 (4) $u_D(t) = K_d \cdot \frac{d e(t)}{dt}$

 Where $K_d$ is the derivative coefficient, and $\frac{d e(t)}{dt}$ represents the rate of change of the error.

#### 3.2 Mathematical model of the PID controller

The general function that describes the operation of a PID controller is:

(5) $u(t) = K_p \cdot e(t) + K_i \cdot \int_0^t e(\tau) d\tau + K_d \cdot \frac{d e(t)}{dt}$


Where are:
- $u(t)$: controller output size (signal going to the system),
- $e(t)$: current error (difference between reference and actual value),
- $K_p$: proportional coefficient (how quickly the controller reacts to the current error),
- $K_i$: integrative coefficient (how long the controller accumulates the error),
- $K_d$: derivative coefficient (how quickly the controller reacts to changes in error).

#### 3.3 Influence of PID components on system performance

**Proportional part (P)**: Larger $K_p$ leads to faster response, but too large $K_p$ can cause oscillations.

 ![PID_varyingP](https://github.com/user-attachments/assets/5cca48b3-6d4c-4220-ab82-b3c70f7c90c0)

`Figure 4. An example of the system's response depending on the proportional gain`



**Integrative part (I)**: Larger $K_i$ can eliminate static error, but too large $K_i$ can cause too long response time or instability.

 ![ki](https://github.com/user-attachments/assets/3fbd9762-ef43-42b2-862c-95fb8e6d365e)

`Figure 5. An example of the response of the system is the dependence on the gain Kp Ki Kd`




**Derivative part (D)**: The derivative part calms the system and prevents oscillations, but too large $K_d$ can cause hypersensitivity to noise in the signal.

 ![kd](https://github.com/user-attachments/assets/5161cbe2-414a-438b-8841-3f03f6aca365)

`Figure 6. An example of the response of the system is the dependence on the gain Kp Ki Kd`

## 4. Methods for tuning PID controllers

PID controller adjustment, known as **tuning**, refers to determining the optimal values ​​for three coefficients: **proportional coefficient** $K_p$, **integral coefficient** $K_i$, and **derivative coefficient** $ K_d$. A well-tuned PID controller can significantly improve system performance, while a poorly tuned one can cause oscillations, over-reaction or delays in the system.

There are several methods for tuning a PID controller, and the most commonly used methods are presented below:

### 4.1 Ziegler-Nichols method

The **Ziegler-Nichols method** is one of the most popular empirical methods for tuning PID controllers. There are two variants of this method: **reaction curves** (for systems with a delay) and the **continuous oscillations** method.

#### 4.1.1 Continuous oscillation method

This method is used when the system has no delay or the delay is negligible. The procedure is as follows:

1. **Turn off the integral and derivative part** of the controller (set $K_i = 0$ and $K_d = 0$ ).
2. Gradually increase the value of the proportional coefficient $K_p$ until the system begins to oscillate stably (amplitudes of oscillations remain constant).
3. Record the value of $K_p$ when stable oscillations appear. That value is called the **ultimate proportional coefficient** $K_u$, and the oscillation period $T_u$ is the duration of one complete oscillation.
4. Set the values ​​of $K_p$, $K_i$ and $K_d$ using the following table (classic Ziegler-Nichols settings):



| Mode Of Control | $K_p$      | $K_i$      | $K_d$      |
|----------------|-----------------------|-----------------------|-----------------------|
| P (Proporcionalni)  | $0.5 \cdot K_u$     | --                    | --                    |
| PI (Proporcionalni + Integrativni) | $0.45 \cdot K_u$    | $0.54 \cdot \frac{K_p}{T_u}$ | --                    |
| PID (Proporcionalni + Integrativni + Derivativni) | $0.6 \cdot K_u$    | $1.2 \cdot \frac{K_p}{T_u}$   | $\frac{3}{40} \cdot K_p \cdot T_u$ |


`Table 2. Table with parameters for the PID controller according to the Ziegler-Nichols method `


#### 4.1.2 Reaction curve method

This method is used when the system has a significant delay in response. The procedure is as follows:

1. Set the controller in open loop mode and apply a step signal to the input.
2. Record the response of the system and determine two key characteristics: the delay time $\tau$ (the time until the response begins) and the time constant $T_d$ (the time required for the output to reach 63% of the final value).
3. Use the values ​​from the table to determine the coefficients:

| Mode Of Conrol | $K_p$      | $K_i$      | $K_d$      |
|----------------|-----------------------|-----------------------|-----------------------|
| P (Proporcionalni)  | $0.63 \cdot \frac{\tau}{T_d}$     | --                    | --                    |
| PI (Proporcionalni + Integrativni) | $0.567 \cdot \frac{\tau}{T_d}$    | $3.3 \cdot T_d$ | --                    |
| PID (Proporcionalni + Integrativni + Derivativni) | $0.756 \cdot \frac{\tau}{T_d}$    | $2 \cdot T_d$   | $0.5 \cdot T_d$  |

`Table 2. Table with parameters for the PID controller by the reaction curve method `



### 4.2 Trial and Error Method

The **Trial and Error Method** is a more intuitive approach where engineers adjust the values ​​of $K_p$, $K_i$, and $K_d$ through a series of tests and experiments until they achieve satisfactory performance.

The procedure is as follows:

1. **Start with the proportional part**: Set $K_i = 0$ and $K_d = 0$, and slowly increase $K_p$ until the system starts to oscillate. Then slightly reduce the values ​​of $K_p$ until a stable system is reached.
2. **Add integral part**: Gradually increase $K_i$ to eliminatethey made a constant mistake. Be careful not to cause too much oscillation or too long a response.
3. **Add derivative part**: Increase $K_d$ to reduce oscillations and improve stability, take care that the derivative part does not cause hypersensitivity to noise in the signal.

The advantage of this method is that it can be easily used with little mathematical knowledge, but it requires a lot of time and testing. This method is suitable for systems where the variables are intuitive and easily predictable.

### 4.3 Software Setup Methods

Several software tools are available today that can automatically tune a PID controller based on simulations or a real system. These tools use mathematical optimization algorithms, such as:

- **MATLAB PID Tuner**: MATLAB offers a built-in PID controller tuning tool that uses a system model and optimizes coefficients based on given performance goals (speed of response, precision, stability).

- **LabVIEW PID tuning**: A tool that uses real system data and simulations for automatic controller tuning.

- **Python PID tuning libraries**: There are libraries like `python-control` in Python, which allow system simulation and optimization of PID parameters.

The advantage of these methods is the speed and accuracy of the settings, but it requires access to the appropriate software and knowledge of how it works.

### 4.4 Cohen-Coon method

The **Cohen-Coon method** is an analytical approach that is similar to the Ziegler-Nichols method, but gives better results for systems with delays. The setup procedure is as follows:

1. Record the reaction of the system to the excitation step (as in the reaction curve).
2. Calculate the parameters $L$ (delay time) and $T$ (time constant).
3. Use Cohen-Coon formulas for PID controller coefficients from the table:

| Mode Of Control | $K_p$      | $K_i$      | $K_d$        |
|----------------|-----------------------|-----------------------|-----------------------|
| P (Proporcionalni)  | $\frac{3 * T + L}{3 * L * K}$     | --                    | --                    |
| PI (Proporcionalni + Integrativni) |$\frac{10.8 * T + L}{12 * L * K}$ | $\frac{L * (30 * T + 3 * L)}{9 * T +20 * L}$                    | --         |
| PID (Proporcionalni + Integrativni + Derivativni) | $\frac{16 * T + 3 * L}{12 * L * K}$| $\frac{L * (32 * T + 6 * L)}{13 * T + 8 * L}$| $\frac{4 * L * T}{11 * T + 2 * L}$ |


`Table 2. Table with parameters for the PID controller according to the Cohen-Coon method `

Where $K$ is the system gain, $L$ is the delay, and $T$ is the time constant. This method is more accurate for systems that have significant delays and is better for adjusting the derivative component.



Choosing the right method for tuning a PID controller depends on the type of system, complexity, and application requirements. Empirical methods such as Ziegler-Nichols offer a quick and easy way to achieve a functional system, while software tools provide more precise and optimized results.

## 5. Description of components

### 5.1 DC motor
A DC motor (direct current motor) is an electromechanical device that converts electrical energy into mechanical energy using direct current (DC - Direct Current). The basic principle of operation of a DC motor is based on the appearance of the Lorentz force acting on a conductor through which current flows in the presence of a magnetic field. This force causes the rotor (the moving component of the engine) to rotate.

#### 5.1.1 Main parts of a DC motor:
1. **Rotor (armature)**: The moving part of the motor, usually consisting of conductors through which current flows. This part rotates within the magnetic field.
2. **Stator**: The stationary part of the motor, usually containing permanent magnets or electromagnets, which create a magnetic field.
3. **Collector (commutator)**: A mechanical device that changes the direction of the current through the rotor so that continuous rotation is ensured.
4. **Brushes**: Conductors that transmit electric current to the rotating part of the motor via the collector.


![dc-motor](https://github.com/user-attachments/assets/6633510b-d77f-45d2-a07b-0492a294350d)

`Figure 7 DC Motor`

#### 5.1.2 Working principle:
When current is passed through the rotor windings, in the presence of the stator's magnetic field, a force is generated that drives the rotor. The collector reverses the direction of current in the rotor each time the motor turns 180 degrees, allowing the rotor to continuously rotate in the same direction. Brushes enable contact between stationary and moving parts, transferring current to the rotor windings.

#### 5.1.3 Types of DC motors:
1. **Series Motor**: The rotor and stator windings are connected in series. This type of motor has a high starting torque and is used in applications such as electric cars.
2. **Parallel (shunt) motor**: The stator and rotor windings are connected in parallel. It has a stable speed and is used in machines that require constant speed, such as fans and pumps.
3. **Compound motor**: Combination of series and parallel motor. It provides a good balance between torque and speed.

#### 5.1.4 Advantages of DC motor:
- **Easy speed control**: The speed of the DC motor can be easily controlled by meansnom of voltage or current.
- **High torque**: They are suitable for applications that require high torque at low speeds.
- **Simple construction**: They have a relatively simple construction compared to AC motors.

#### 5.1.5 Disadvantages of DC motors:
- **Need for maintenance**: Due to brushes and collectors, DC motors require regular maintenance.
- **Efficiency**: Due to brush losses, they are not as efficient as some AC motors.

#### 5.1.6 DC motor transfer function

To obtain the transfer function of a DC motor, we must analyze the mechanical and electrical properties of the motor. The transfer function represents the relationship between the output (eg rotor angular velocity) and the input (eg supply voltage). Let's take a simple model of a DC motor, where the following notations are used:


![dc_model](https://github.com/user-attachments/assets/46b4239d-61d1-46fd-aec4-e335e5008e0a)

- $e_a$: Motor voltage (input)
- $I_a$: Motor current (input)
- $R_a$: Resistance
- $L_a$: Inductance
- $\omega(t)$: Rotor angular velocity (output)
- $T_m$: Mechanical moment
- $J$: Rotor inertia
- $B$: Viscous friction in the system
- $K_b$: Back electromotive force constant (EMF)
- $K_t$: Motor torque constant

##### Electric part:
The electrical part of the DC motor is described by Kirchhoff's law:


(6) $e_a(t) = L_a \frac{dI_a(t)}{dt} + R_a I_a(t) + K_b \omega(t)$


##### Mechanical part:
The mechanical part refers to the rotation of the rotor and can be described using Newton's law of rotation:


(7) $T_m(t) = J \frac{d\omega(t)}{dt} + B \omega(t)$

Given that torque is proportional to current:


(8) $T_m(t) = K_t I_a(t)$


To analyze the system in the Laplace domain, we apply the Laplace transform to the previous equations, assuming that all initial conditions are zero.

##### Electrical equation in the Laplace domain:

(9) $e_a(s) = (L_a s + R_a) I_a(s) + K_b \omega(s)$


#### Mechanical equation in the Laplace domain:

(10) $K_t I_a(s) = (J s + B) \omega(s)$


From (10), we can express the current $I_a(s)$ as:


(11) $I_a(s) = \frac{(J s + B)}{K_t} \omega(s)$


Let's replace $I_a(s)$ in (9):


(12) $e_a(s) = (L_a s + R_a) \frac{(J s + B)}{K_t} \omega(s) + K_b \omega(s)$


By factoring we get:


(13) $V_a(s) = \left[ \frac{(L_a s + R_a)(J s + B)}{K_t} + K_b \right] \omega(s)$

The transfer function $\frac{\omega(s)}{V_a(s)}$ can be expressed as:


(14) $\frac{\omega(s)}{e_a(s)} = \frac{K_t}{(L_a s + R_a)(J s + B) + K_t K_b}$

In practice, the transfer function of a DC motor is presented in the form of:
(15) $\frac{K}{\tau s + 1}$.


### 5.2 Rotary encoder

A rotary encoder is an electromechanical device that measures the angular position, speed or direction of rotation of rotating objects. Rotary encoders convert mechanical motion into an electrical signal, which is then used for control and measurement in various automated systems, such as robots, CNC machines, and industrial motors.

### 5.2.1 Types of rotary encoders:
Rotary encoders can be classified into two main categories:

1. **Incremental encoder**:
 - These encoders generate a pulse signal that indicates a change in position, but do not provide absolute information about the current position. They count pulses to track angular position or velocity.
 - They are used in applications where the relative change of position or speed meets the system requirements.
 - At the output of the encoder, each pulse corresponds to a certain number of degrees of rotation.
 - An additional signal can indicate the direction of rotation.

2. **Absolute encoder**:
 - Absolute encoders provide a unique digital code for each angular position, providing absolute information about the exact position, regardless of previous positions.
 - The advantage of absolute encoders is that they retain the position data even when the power is interrupted or the rotation stops.
 - They are used in applications where it is necessary to maintain the exact position at all times, such as precision machines and robots.

### 5.2.3 Operating principle of rotary encoders:
Most rotary encoders use an optical, magnetic or capacitive principle to generate a pulse or code:

1. **Optical encoders**:
 - These encoders have a disk with transparent and opaque segments, through which light passes. When the disc rotates, the light sensor detects the interruption of light and generates an electrical signal.
 - The disk can be divided into many slots, so the number of slots defines the resolution of the encoder. Higher resolution enables more precise measurements.

2. **Magnetic encoders**:
 - Magnetic encoders use a magnetic disc and Hall sensors to detect changes in the magnetic field. Magnetic encoders are more robust than optical encoders and are often used in environments where there is dust, moisture or high temperature.

3. **Capacitive encoders**:
 - Capacitive encoders work on the principle of changing the capacitance between electrodes placed on a rotating disc and a static plate. These encoders are relatively new and are used in applications where small dimensions and high precision are required.

### 5.2.4 Applications of rotary encoders:
- **Robotics**: Encoders enable the slaveabducts to follow the angular position of their joints and movement control.
- **CNC machines**: Precise measurement of tool position to achieve precise cuts.
- **Industrial motors**: The speed and position of the shafts are monitored in order to control the operation of the motor.
- **Elevators**: Use encoders for accurate positioning of the elevator cabin.

### 5.2.5 Encoder characteristics:
- **Resolution**: Indicates the number of pulses or steps that the encoder can generate for one rotation. Higher resolution means more accurate measurement.
- **Direction of rotation**: Some encoders can recognize the direction of rotation, so they can distinguish between clockwise and counterclockwise rotation.
- **Frequency**: The frequency of the output signal, which is related to the rotation speed.

Rotary encoders are a key part in many control systems, where precise measurements and accurate position or speed feedback are essential.

## 6. System description

### 6.1 Physical part
A DC motor is used to convert electrical energy into mechanical energy, and in order to precisely control the speed, a rotary encoder is used. The rotary encoder generates pulse signals, which are proportional to the rotation of the motor, and these signals serve as feedback for the microprocessor.

The PID controller implemented on the PIC16F877A microprocessor uses this data to calculate the current error (difference between desired and actual speed/position + PID controller) and generates the appropriate control signal for the driver. The driver provides the required voltage and current (In this case, the voltage for the DC motor is 12V and the driver is an H-bridge with built-in dead time).

### 6.2 Software Part


#### **Initializing Peripheral Devices**

The code starts by defining the PINs for the LCD screen, and then sets the initial parameters for the PID controller: $K_p = 45$, $K_i = 108$, and $K_d = 0$ (How we got there is explained in Chapter 7. ). Next, variables are initialized to track motor speed and errors:

```c
float kp = 45;
float ki = 108;
float kd = 0;
int count = 0;
float v1 = 0.0,v_des = 100.0, err, err_bef = 0.0f, err_der = 0, der = 0, pom;
```

The function `init()' serves to initialize the system:
- Global interapt (GIE_bit) and peripheral interapt (PEIE_bit) are enabled.
- Timer1 is set in counting mode with a rescaler for counting pulses generated by the encoder.
- UART initialization enables communication with the computer.
- LCD initialization prepares the screen to display engine speed.

```c
void init() {
 GIE_bit = 1;
 PEIE_bit = 1;
 INTE_bit = 1;
 TMR1IE_bit = 1;
 // Timer and UART setup
 UART1_Init(9600);
 Lcd_Init();
}
```

#### **Interapt Routine**

The Interapt routine (`interrupt()`) is used to monitor the motor speed and implement the PID algorithm. When Timer1 generates an interrupt, the encoder reads the motor speed and the PID controller calculates the required correction.

- **Speed ​​reading**: The motor speed is obtained through the number of encoder pulses in a given time interval.
- **Error calculation**: The error $err$ is the difference between the desired speed v_des and the actual speed v1.
- **PID output**: PID output is calculated based on proportional, integral and derivative error. This output is used to control the PWM signal sent to the motor.

```c
void interrupt() {
 if(TMR1IF_bit) {
 v1 = count;
 err = v_des - v1; // Proportional error
 err_der = (der - err) * 0.25; // Derivative error
 der = err;
 err_bef += err; // Integral error
 pom = (err * kp + (err_bef * ki) + kd * err_der); // PID output
 PWM = (char)(pom);

 // Motor control according to error direction
 if(err > 0) {
 PWM1_Set_Duty(PWM);
 PWM2_Set_Duty(0);
 } else {
 PWM1_Set_Duty(0);
 PWM2_Set_Duty(PWM);
 }
 TMR1IF_bit = 0;
 }
 if(INTF_bit && !TMR1IF_bit) {
 count++; // Count encoder pulses
 INTF_bit = 0;
 }
}
```

#### **Main Loop**

In the main loop of the program there is logic for setting the PID coefficients and the desired motor speed. This is accomplished by reading data through the UART.

- **TUNE modes**: The system supports different operating modes, marked with the variable `TUNE` (compile time variable). Depending on the `TUNE` value, the user can change the motor speed or the PID coefficients $K_p$, $K_i$, and $K_d$.

- **Set desired speed**: If `TUNE == 0`, the user can set the desired speed via the serial port, and the system will adjust the motor speed to maintain it.

```c
if (UART1_Data_Ready() == 1) {
 UART1_Read_Text(speed, "OK", 6);
 v_des = ((speed[0] - '0') * 100 + (speed[1] - '0') * 10 + (speed[2] - '0') * 1);
}
```

- **Adjusting PID coefficients**: If `TUNE` is changed to other values ​​(1, 2 or 3), the user can adjust the coefficients $K_p$, $K_i$ or $K_d$ in real time.

```c
if (UART1_Data_Ready() == 1) {
 UART1_Read_Text(speed, "OK", 6);
 kp = (float)((speed[0] - '0') * 100 + (speed[1] - '0') * 10 + (speed[2] - '0') * 1);
}
```
#### **PWM control**

In the `main()` function, after initialization, PWM modules are started which generate PWM signals to control the speed of the motor. The PWM frequency is set to 500 Hz due to simulation limitations in Proteus, but can be set to higher values ​​in real applications.

```c
#define FREQ 500
PWM1_Init(FREQ);
PWM2_Init(FREQ);
PWM1_Start();
PWM2_Start();
```



The code is designed to control the speed of a DC motor with feedback from a rotary encoder. By using a PID controller, the system can precisely regulate the motor speed in real time, while the user can set the desired values ​​and control parameters via serial communication.

### 7. Tuning the PID controller using the Ziegler-Nichols method

We will use the Ziegler-Nichols method to adjust the PID controller.

#### 7.1. **Determining the critical proportional constant $K_u$ and the oscillation period $T_u$**

The first step in the Ziegler-Nichols method is to find the critical proportional constant $K_u$, which brings the system to the stability limit, i.e. of a system that oscillates with a constant amplitude without any corrections.

1. **Set the system with proportional controller only**, while $K_i = 0$ and $K_d = 0$.
2. **Compile the code with `TUNE == 1` to be able to tune $K_p$

3. **Increase $K_p$ gradually** until the system starts to oscillate with a constant amplitude. This is the critical value of $K_u$. In our case, we obtained stable oscillations for $K_p$ = 100.
![Screenshot_4](https://github.com/user-attachments/assets/57cda3da-efc6-44da-9e48-8347a108725c)



5. After the oscillation is achieved, **record the oscillation period $T_u$**, that is, the duration of one complete cycle of oscillations. That time is 0.5s.


From the Ziegler-Nichols table for a classic PID controller, the values ​​for $K_p$, $K_i$ and $K_d$ are obtained as follows:

- **$K_p$** for PI controller: $K_p = 0.45 \times K_u = 0.45 \times 100 = 45$
- **$K_i$**: $K_i = K_p / (0.83 \times T_u) = 45 / (0.83 \times 0.5) = 108$

So the set values ​​are:
- $K_p = 45$
- $K_i = 108$

These values ​​enable stable control of the system.
