/* 


Keyboard Keys Used  
1 = black
2 = green
u = servo up
i = servo 'down' = primed

w = forward
s = backward
a = left
d = right  

p = print procedure
e = exit  
  
*/

import processing.serial.*; 
import ddf.minim.*;
PrintWriter output;

// Important Manipulatable Factors
int xSteps = 20;         // number of 'steps' on x-axis - right / left
int ySteps = 20;         // number of 'steps' on y-axis - forward / backward
int size = 5;            // Width of the shape
int moveCounter = 20;    // Number of robot 'steps'


// Setup Factors
 int boxHeight = 15;
 int boxWidth = 25;
 int controlBoxSize = 200;

 float boxX;
 float boxY;

// Object Functions
 float xpos, ypos;    // Starting position of shape    

 int xmovement = 0;    // x-coor movement of the object (step)
 int ymovement = 0;    // y-coor movement of the object (step)

 int colR = 0;    // used to determine object fill color
 int colG = 0;
 int colB = 0;
 
 int penMode = 0;  // Test for 'up' or 'down' mode

// Arduino Related 
 Serial port; 

// Text
 PFont fontA;

   
void setup() {
  size(600, 400);       
  background(255);    
  boxX = width/2.0;
  boxY = height/2.0;
  rectMode(RADIUS);   

// Object Functions
  frameRate(30);
  smooth();
  
// Set the starting position of the shape - centered (for now)
  xpos = width/2-130;
  ypos = height/2-15;

// Arduino Related  
  println(Serial.list()); 
  port = new Serial(this, Serial.list()[0], 9600); 

// Text  
  fontA = loadFont("Courier-15.vlw");
  textFont(fontA, 15);

// Procedure
  // Create a new text file in the sketch directory --> title of file = "Procedure.txt"
  output = createWriter("Procedure.txt"); 


/* 

Draw the GUI

*/

// ***Control Box***
  fill(123);
  rect(width-30, height, controlBoxSize, height);


// **Pick a Color**

// Color Box - Black
  fill(0);
  rect(boxX+180, boxY-180, boxWidth+70, boxHeight);
  

// Color Box - Green
  fill(0, 255, 0);
  rect(boxX+180, boxY-140, boxWidth+70, boxHeight);
 

// **Pen Up/Down**

// Pen Up
  fill(255);
  rect(boxX+130, boxY-100, boxWidth+20, boxHeight);
  fill(0);
  textAlign(CENTER, CENTER);
  text("Pen Up", boxX+130, boxY-100);

// Pen Down
  fill(255);
  rect(boxX+230, boxY-100, boxWidth+20, boxHeight);
  fill(0);
  textAlign(CENTER, CENTER);
  text("Pen Down", boxX+230, boxY-100);

// **Movement Controls**
  
// Forward
  fill(0, 200, 200);
  rect(boxX+180, boxY-50, boxWidth+20, boxHeight+5);
  fill(0);
  textAlign(CENTER, CENTER);
  text("Forward", boxX+180, boxY-50);

// Left
  fill(0, 200, 200);
  rect(boxX+130, boxY, boxWidth+20, boxHeight+5);
  fill(0);
  textAlign(CENTER, CENTER);
  text("Left", boxX+130, boxY);

// Backward
  fill(0, 200, 200);
  rect(boxX+180, boxY+50, boxWidth+20, boxHeight+5);
  fill(0);
  textAlign(CENTER, CENTER);
  text("Backward", boxX+180, boxY+50);

// Right
  fill(0, 200, 200);
  rect(boxX+230, boxY, boxWidth+20, boxHeight+5);
  fill(0);
  textAlign(CENTER, CENTER);
  text("Right", boxX+230, boxY);


// Print Procedure Button
  fill(255);
  rect(boxX+180, boxY+100, boxWidth+70, boxHeight);
  fill(0);
  textAlign(CENTER, CENTER);
  text("Print Procedure", boxX+180, boxY+100);  


// Exit Button
  fill(255);
  rect(boxX+180, boxY+150, boxWidth+70, boxHeight);
  fill(0);
  textAlign(CENTER, CENTER);
  text("Exit Program", boxX+180, boxY+150);  


} // End void setup

void draw() {

// Robot Inactive When No Input
port.write('n');
 
  
// Change the position of the object
  xpos = xpos + xmovement;
  ypos = ypos + ymovement;
    
// Draw the shape
  if(penMode == 1){    // Only draw the shape with a colored fill if the pen is down
    fill(colR, colG, colB);
  }
  else{
    fill(255);        // If pen is up -- object color will be same as draw space
  }   
  noStroke();
  ellipse(xpos+size/2, ypos+size/2, size, size);

// Set to original position  
  ymovement = 0;
  xmovement = 0;

/* 
Set boundaries
*/

// If hits right wall
  if (xpos > width-size){
    println("Can't go further");
    xpos = width-size;
  }
  
// If hits top wall
  if (ypos < 0) {
    ypos = ypos-ypos;
    println("Can't go further");
  }
  
// If hits bottom wall
  if (ypos > height-size){
    println("Can't go further");
    ypos = height-size;
  }

// Unknown explanation but doesn't seem to require a left side boundary

} // End void draw


void mousePressed() {
// Color Box - Black
  if (mouseX > (boxX+180)-(boxWidth+70) && mouseX < (boxX+180)+(boxWidth+70) &&
  mouseY > boxY-180-boxHeight && mouseY < boxY-180+boxHeight){
    if(penMode == 1){
      // Set turtle fill to black
      output.println("blackPinOn();");
      port.write('1');
      println("set to black");
      colR = 0;
      colG = 0;
      colB = 0;
    }
    else{
      println("pen not in use");
    }
  } // Black Pen Color End
  

// Color Box - Green
  if (mouseX > (boxX+180)-(boxWidth+70) && mouseX < (boxX+180)+(boxWidth+70) &&
  mouseY > boxY-140-boxHeight && mouseY < boxY-140+boxHeight){
    if(penMode == 1){
      // Set turtle fill to green
      output.println("greenPinOn();");
      port.write('2');
      println("set to green");
      colR = 0;
      colG = 255;
      colB = 0;  
    }
    else{
      println("pen not in use");
    } 
  } // Green Pen Color End

  
// Pen Up
  if(mouseX > (boxX+130)-(boxWidth+20) && mouseX < (boxX+130)+(boxWidth+20)
   && mouseY > boxY-100-boxHeight && mouseY < boxY-100+boxHeight){
     // set servo to 'up' position
     output.println("servoUp();");
     port.write('u');
     println("pen up");
     penMode = 0;
   } // Pen Up End
  
// Pen Down
  if(mouseX > (boxX+230)-(boxWidth+20) && mouseX < (boxX+230)+(boxWidth+20)
   && mouseY > boxY-100-boxHeight && mouseY < boxY-100+boxHeight){
     // set servo to 'down' position
     output.println("pinLEDon();");
     port.write('i');
     println("pen ready");
     penMode = 1;
   } // Pen Down End
 
// Forward Button
  if(mouseX > (boxX+180)-(boxWidth+20) && mouseX < (boxX+180)+(boxWidth+20)
   && mouseY > (boxY-50)-(boxHeight+5) && mouseY < (boxY-50)+(boxHeight+5)){
       // If hits top wall
       if (ypos <= 0) {
          ypos = ypos-ypos;
          println("Can't go further");
//          output.println("doNothing();");
        }   
      else{
          // move forward
          output.println("moveForward();");
          println("Move Forward 10");           
          ymovement = -ySteps;
          for(int i = 0; i < moveCounter; i++){
            port.write('w');
          }
       }   
   } // Forward Button End

// Backward Button
  if(mouseX > (boxX+180)-(boxWidth+20) && mouseX < (boxX+180)+(boxWidth+20)
   && mouseY > (boxY+50)-(boxHeight+5) && mouseY < (boxY+50)+(boxHeight+5)){
        // If hits bottom wall
        if (ypos >= height-size){
            println("Can't go further");
            ypos = height-size;
            ymovement = 0;
          }
        else{
            // move backward
            output.println("moveBackward();");
            println("Move Backward 10"); 
            ymovement = ySteps;
            for(int i = 0; i < moveCounter; i++){
              port.write('s');
            }
        }
   } // Backward Button End

// Right Button
  if(mouseX > (boxX+230)-(boxWidth+20) && mouseX < (boxX+230)+(boxWidth+20)
   && mouseY > boxY-boxHeight+5 && mouseY < boxY+boxHeight+5){
         if (xpos >= width-200-(size*2)){
            println("Can't go further");
            xpos = width-200-(size*2);
            xmovement = 0;
          }
          else{
             // turn right
             output.println("turnRight();");
             println("Move Right 10");
             xmovement = xSteps;
             for(int i = 0; i < moveCounter; i++){
               port.write('d');
             }
          }
   } // Right Button End

// Left Button
  if(mouseX > (boxX+130)-(boxWidth+20) && mouseX < (boxX+130)+(boxWidth+20)
   && mouseY > boxY-boxHeight+5 && mouseY < boxY+boxHeight+5){
          // If hits left wall
          if (xpos <= 0) {
              println("Can't go further");
              xpos = xpos-xpos;
              xmovement = 0;
          }
          else{
               // turn left
               output.println("turnLeft();");
               println("Turn Left 10");
               xmovement = -xSteps;
               for(int i = 0; i < moveCounter; i++){
                 port.write('a');
               }
          }     
   } // Left Button End

  
// Procedure Button
     if(mouseX > (boxX+180)-(boxWidth+70) && mouseX < (boxX+180)+(boxWidth+70) &&
  mouseY > boxY+100-boxHeight && mouseY < boxY+100+boxHeight){
         output.flush(); // Writes the remaining data to the file
         output.close(); // Finishes the file
//       exit(); // Stops the program
     } // Procedure Button End - Print Procedure

    
// Exit Button
     if(mouseX > (boxX+180)-(boxWidth+70) && mouseX < (boxX+180)+(boxWidth+70) &&
  mouseY > boxY+150-boxHeight && mouseY < boxY+150+boxHeight){
       exit(); // Stops the program
  } // Exit Button End
    
 
// mousePressed Close  
}


void keyPressed() {
// Set Color to Black  
    if(key == '1'){
      if(penMode == 1){
        // Set turtle fill to black
        output.println("blackPinOn();");
        port.write('1');
        println("Black fill");
        colR = 0;
        colG = 0;
        colB = 0;
      }
      else{
        println("pen not in use");
      }          
    } // Key 1 End - Black

// Set Color to Green    
    if(key == '2'){
      if(penMode == 1){
        // Set turtle fill to green
        output.println("greenPinOn();");
        port.write('2');
        println("Green fill");
        colR = 0;
        colG = 255;
        colB = 0;
      }
      else{
        println("pen not in use");
      }    
    } // Key 2 End - Green


    if(key == 'u' || key == 'U'){
      // Servo Up
      output.println("servoUp();");
      port.write('u');
      println("Pen Up");
      penMode = 0;
    }

    if(key == 'i' || key == 'I'){
      // Servo Primed
      output.println("pinLEDon();");
      port.write('i');
      println("Pen Ready");
      penMode = 1;
    }

    if(key == 'w' || key == 'W'){
       // If hits top wall
       if (ypos <= 0) {
          ypos = ypos-ypos;
          println("Can't go further");
    }   
      else{
          // move forward
          output.println("moveForward();");
          println("Move Forward 10");  
          ymovement = -ySteps;
          for(int i = 0; i < moveCounter; i++){
            port.write('w');
          }
      }
    } // Key W End - Forward
  
    if(key == 's' || key == 'S'){
        // If hits bottom wall
        if (ypos >= height-size){
            println("Can't go further");
            ypos = height-size;
            ymovement = 0;
          }
        else{
            // move backward
            output.println("moveBackward();");
            println("Move Backward 10");
            ymovement = ySteps;
            for(int i = 0; i < moveCounter; i++){
              port.write('s');
            }
        }
    } // Key S End - Backward

     if(key == 'd' || key == 'D'){
         if (xpos >= width-200-(size*2)){
            println("Can't go further");
            xpos = width-200-(size*2);
            xmovement = 0;
          }
          else{
             // turn right
             output.println("turnRight();");
             println("Move Right 10");
             xmovement = xSteps;
             for(int i = 0; i < moveCounter; i++){
               port.write('d');
             }
          }
    } // Key D End - Right
  
    if(key == 'a' || key == 'A'){
          // If hits left wall
          if (xpos <= 0) {
              println("Can't go further");
              xpos = xpos-xpos;
              xmovement = 0;
          }
          else{
               // turn left
               output.println("turnLeft();");
               println("Turn Left 10");
               xmovement = -xSteps;
               for(int i = 0; i < moveCounter; i++){
                 port.write('a');
               }
          }     
    } // Key A End - Left
  
 
     if(key == 'p' || key == 'P'){
         output.flush(); // Writes the remaining data to the file
         output.close(); // Finishes the file
//         exit(); // Stops the program
     } // Key P End - Print Procedure
  
     
     if(key == 'e' || key == 'E'){
         exit(); // Stops the program
     } // Key E End - Exit       
     
     
// keyPressed Close    
}



