/*
Stuart Murphy 
Interactive Media - 10056828
Air Hockey Project
23/04/2016


revised by Dage, Tyrone
date: 2017/08/16
*/

// Use sounds credit to freesounds.org
import ddf.minim.*;
import processing.serial.*;
ArrayList<paddle> paddles = new ArrayList();
Serial myPort;  // Create object from Serial class

float pre_xx=0;
float pre_puckX, pre_puckY;
boolean firstContact = false;   
   
// Class Types
Puck puck;
paddle p1,p2;

// Booleans
boolean paused = false;
boolean inPlay = false;
boolean menu = true;

// First Menu variables
String title = "AIR HOCKEY";
String creater = "Created by Stuart Murphy\nRevised by Dage, Tyrone";
String s = "Play";

// Paddle Variables
int rad = 90;

// Puck Variables 
int puckX;
int puckY;
int diam = 40;

// Declare type
PFont scoreBoard;

// Button Variables
float bx;
float by;
int buttonW = 75;
int buttonH = 40;
boolean overBox = false;
int opacity;

int player2MoveX = 800;
int player2MoveY = 500;
int keyMove = 20;

// Sounds

AudioSnippet test, wallHit, score, victory;
Minim minim;

void setup()
{
  size(1000,600);
  
  // Place puck at center
  puckX = width/2;
  puckY = height/2;
  puck = new Puck(puckX,puckY,diam,paddles);
  
  // Create 2 paddles
  p1 = new paddle(0,height/2,rad,rad);
  p2 = new paddle(player2MoveX,player2MoveY,rad,rad);
  
  // Add them to an array
  paddles.add(p1);
  paddles.add(p2);
   
  // Sort font
  scoreBoard = loadFont("OCRAStd-48.vlw");
  textFont(scoreBoard);
  
  // Set button location
  bx = width/2;
  by = height/1.5;
  
  minim = new Minim(this);
  test = minim.loadSnippet("clap.mp3");
  wallHit = minim.loadSnippet("wall.mp3");
  score = minim.loadSnippet("score.wav");
  victory = minim.loadSnippet("victory.wav");
  
  
  //String portName = Serial.list()[0]; //change the 0 to a 1 or 2 etc. to match your port
  //myPort = new Serial(this, portName, 9600);
  
   //myPort = new Serial(this, Serial.list()[4], 9600);
   //myPort.bufferUntil('\n'); 
}

void draw()
{  
  // Booleans switch between menu, in play and pause
  if(menu)
  {
    background(0,108,255);
    cursor(HAND);
    rectMode(RADIUS); 
    
    // Main title with text
    textAlign(CENTER);
    textSize(50);
    fill(255);
    text(title, width/2, height/4); 
    textSize(15);
    fill(255);
    text(creater, width/2, height/2);
   
    // Play Button
    if (mouseX > bx-buttonW && mouseX < bx+buttonW && 
        mouseY > by-buttonH && mouseY < by+buttonH) 
    {
      overBox = true;  
      stroke(255); 
      opacity = 255;
      fill(255,0,0,opacity);     
    } 
    else 
    {
      stroke(153);
      opacity = 180;
      fill(255,0,0,opacity);
      overBox = false;
    }

  // Draw the button
  rect(bx, by, buttonW, buttonH, 10);
  
  // Text Inside Button  
  textFont(scoreBoard, buttonH); 
  
  float tS=buttonH;
  while(textWidth(s)>buttonW)
  {
       tS-=1;
       textSize(tS);
       //println(textWidth(s));
  }
  fill(200,opacity);
  
  //draw the text in the middle of the rect 
  text(s,bx,by); 
  }
  
  // In game mode
  if (!menu)
  { 
    noCursor();
    if(!paused)
    {
      background(0,108,255);
 
      // Field Dots
      float x = 0;
      while(x<width)
      {
        float y = 0;
        while(y<height)
        {
          fill(0);
          strokeWeight(.5);
          stroke(0);
          ellipse(x+10, y+10, .1,.1);
          y = y+20;
        } 
        x = x+20;
     }
     
     // Field Line Design
     stroke(255);
     strokeWeight(5);
     line(width/2,0,width/2,height);
     //strokeWeight(5);
     line(0,0,width,0);
     line(0,height,width,height);
     line(0,0,0,height);
     line(width,0,width,height);
     noFill();
     ellipse(width/2,height/2,250,250);
     
     // Display paddle
     p1.display(); 
     p2.display();   
     
     // Move paddle
     p1.move(mouseX,mouseY);
     p2.move(player2MoveX,player2MoveY); //where joystick values should go
       
     // Restrict paddle at halfway
     if(p1.x>width/2-(rad/2))
     { 
       p1.x=width/2-(rad/2);
     }
     
     if(p2.x<width/2-(rad/2))
     { 
       p2.x=width/2-(rad/2);
     }
    
     // Draw Puck
     puck.display();
    ellipseMode(CENTER);
    fill(0,0,0,50);
    stroke(0);
    ellipse(width/2, height/2, height, height);
    
     // Puck Strike
     puck.hit();
    
     // Goals
     rectMode(CENTER);
     fill(255,0,0,180);
     rect(200,height/2,50,200,5); 
     fill(255,0,0,180);
     rect(width-200,height/2,50,200,5); 
    
     // Scoreboard 
     textAlign(CENTER);
     textSize(20);
     fill(0);
     int score1 = puck.score1();
     text("Player 1\n"+score1, 7*width/16-10, 60); 
     int score2 = puck.score2();
     text("Player 2\n"+score2, width*9/16+10, 60);
  
     if(score1 == 5 || score2 == 5)
     {   
       if(score1>score2)
       {
         victory.rewind();
         victory.play(); 
         title="YOU WIN";
         creater="";
         s="Again?";
         puck.score1 = 0;
         puck.score2 = 0;
         menu = true;
       } 
       else
       {
         victory.rewind();
         victory.play(); 
         title="YOU LOSE";
         creater="";
         s="Again?";
         puck.score1 = 0;
         puck.score2 = 0;
         menu = true;
       }
     } 
    }
    // Pause Screen
    else
    {
      fill(0,1);
      rectMode(CORNER);
      rect(0,0,width,height); 
      
      textSize(60);
      textAlign(CENTER);
      fill(0);
      text("PAUSED",width/2, height/2); 
    } 
  
  }  
}

void keyPressed()
{
    if (key == ' ') 
    {
      paused=!paused;
    } 
    
    // Due to no joypad sensor. these keys control player 2
    if (key == CODED) 
    {
      if (keyCode == UP) 
      {
        player2MoveY-=keyMove;
        if(player2MoveY<rad/2)
        {
          player2MoveY = rad/2;
        }
      } else if (keyCode == DOWN ) 
      {
        player2MoveY+=keyMove;
        if(player2MoveY>height-(rad/2))
        {
          player2MoveY = height-(rad/2);
        }
      }
      
      else if (keyCode == LEFT) 
      {
        player2MoveX-=keyMove;
        if(player2MoveX<width/2+(rad/2))
        {
          player2MoveX = width/2+(rad/2);
        }
      } else if (keyCode == RIGHT ) 
      {
        player2MoveX+=keyMove;
        if(player2MoveX>width-(rad/2))
        {
          player2MoveX = width-(rad/2);
        }
      }   
  }  
}

void mousePressed() 
{
  if(overBox) 
  { 
    menu=false;
  }
}


  