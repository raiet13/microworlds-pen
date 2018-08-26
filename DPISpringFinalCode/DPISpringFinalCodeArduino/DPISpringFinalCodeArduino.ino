
#include <Servo.h>      // include the servo library

// Servo - Pen
Servo leftservoMotor, rightservoMotor;
int servoPin1 = 2;      // ServoMotor1 == left
int servoPin2 = 4;      // ServoMotor2 == right

// Special Buttons - Color
int blackPin = 6;
int greenPin = 7;

// Motor
const int motor1Pin1 = 11;    // H-bridge leg 1 (pin 2, 1A) -  
const int motor1Pin2 = 9;    // H-bridge leg 2 (pin 7, 2A)

const int motor2Pin1 = 10;    // H-bridge leg 1 (pin 10, 3A) - 
const int motor2Pin2 = 12;    // H-bridge leg 2 (pin 15, 4A)

int incomingByte;      // a variable to read incoming serial data into


void setup() {
  // initialize serial communication:
  Serial.begin(9600);
 
  // Servo -- At Rest ('up' position)
  leftservoMotor.attach(servoPin2);
  leftservoMotor.write(140);
 
  rightservoMotor.attach(servoPin1);
  rightservoMotor.write(100);

   // Motor 1 - 
   pinMode(motor1Pin1, OUTPUT);
   pinMode(motor1Pin2, OUTPUT); 

   // Motor 2 - 
   pinMode(motor2Pin1, OUTPUT);
   pinMode(motor2Pin2, OUTPUT); 

}

void loop() {
  // see if there's incoming serial data:
  if (Serial.available() > 0) {
    // read the oldest byte in the serial buffer:
    incomingByte = Serial.read();

    if (incomingByte == '1') {
      blackPinOn();
      servoBlack();
      Serial.println("Set to Black");      
     }   

    if (incomingByte == '2') {
      greenPinOn();
      servoGreen(); 
      Serial.println("Set to Green");      
    }
    
    if (incomingByte == 'u'){
       servoUp();
       pinLEDoff();
       Serial.println("Pen Up");
    }
    
    if (incomingByte == 'i'){
       pinLEDon();
       Serial.println("Pens Ready");
    }

    if (incomingByte == 'w') {
      moveForward();
      Serial.println("Move Foward");      
    }   

      if (incomingByte == 's') {
        moveBackward();
        Serial.println("Move Backward");
      }    

      if (incomingByte == 'd') {
        turnRight(); 
        Serial.println("Turn Right");      
      }
  
      if (incomingByte == 'a') {
        turnLeft();
        Serial.println("Turn Left");      
      } 
      
      if (incomingByte == 'n') {
        doNothing();
      }


  } // Serial Available Close
} // void loop Close


 void blackPinOn(){
    digitalWrite(blackPin, HIGH);
    digitalWrite(greenPin, LOW);
  }

 void greenPinOn(){
    digitalWrite(greenPin, HIGH);
    digitalWrite(blackPin, LOW);
  }

void servoUp(){
   leftservoMotor.write(140);
   rightservoMotor.write(100);
 }
 
void servoGreen(){ 
   leftservoMotor.write(140);
   rightservoMotor.write(70);      // Green Pen Down
}

void servoBlack(){
   leftservoMotor.write(180);     // Black Pen Down
   rightservoMotor.write(100);
 }


// To indicate pen is 'up' -- not drawing
 void pinLEDoff(){
    digitalWrite(blackPin, LOW);
    digitalWrite(greenPin, LOW);
 }

// To indicate pen is 'down' -- pick color
 void pinLEDon(){
    digitalWrite(blackPin, HIGH);
    digitalWrite(greenPin, HIGH);
 }


// Movement Functions
void moveForward(){
      digitalWrite(motor1Pin1, HIGH);
      digitalWrite(motor1Pin2, LOW);  
      
      digitalWrite(motor2Pin1, LOW);  
      digitalWrite(motor2Pin2, HIGH);   
}

void moveBackward(){
      digitalWrite(motor1Pin1, LOW); 
      digitalWrite(motor1Pin2, HIGH);  
      
      digitalWrite(motor2Pin1, HIGH); 
      digitalWrite(motor2Pin2, LOW); 
}

void turnLeft(){
      digitalWrite(motor1Pin1, HIGH);  
      digitalWrite(motor1Pin2, LOW);  

      digitalWrite(motor2Pin1, HIGH);  
      digitalWrite(motor2Pin2, LOW);  
}

void turnRight(){        
      digitalWrite(motor1Pin1, LOW); 
      digitalWrite(motor1Pin2, HIGH);   
      
      digitalWrite(motor2Pin1, LOW);
      digitalWrite(motor2Pin2, HIGH);  
}

void doNothing(){    // Tells both wheels to not spin so that the other states won't stick
      digitalWrite(motor1Pin1, LOW);
      digitalWrite(motor1Pin2, LOW);  
      
      digitalWrite(motor2Pin1, LOW);  
      digitalWrite(motor2Pin2, LOW);  
}

