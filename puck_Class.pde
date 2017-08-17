class Puck{
 int x,y,diam; 
 float spring = 0.08;
 float spr = 0.02;
 float friction = -0.7;
 float vy = 0, vx = 0;
 ArrayList<paddle> paddles;
 int score1 = 0;
 int score2 = 0;
 boolean goal = false;
 int centerX = 500;
 int centerY = 300;
 int radius = 300;
  
 Puck(int _x, int _y, int _diam, ArrayList _paddles)
 {
  x = _x;
  y = _y;
  diam = _diam;
  paddles = _paddles; 
 }
 
 void display()
 {     
   fill(255,200,0);
   strokeWeight(.1);
   ellipse(puckX,puckY,diam,diam);
 }
 
 void hit()
 {
      for(int i = 0; i < paddles.size(); i++)
      {
          // Modified code from Processing.org
          float dx = paddles.get(i).x - puckX; //paddles x co-ords to be changed
          float dy = paddles.get(i).y - puckY;  //paddles y co-ords to be changed
          float distance = sqrt(dx*dx + dy*dy);
          float minDist = (p1.r/2) + (p1.r/4);
          
          float ddx = centerX - puckX; //paddles x co-ords to be changed
          float ddy = centerY - puckY;  //paddles y co-ords to be changed
          float ddistance = sqrt(ddx*ddx + ddy*ddy);
          float maxDist = (radius) - (diam/2);
          
          if (ddistance > maxDist)
          {
              wallHit.rewind();
              wallHit.play();
              float ang = atan2(ddy, ddx);
              float tarX = puckX + cos(ang) * (maxDist);
              float tarY = puckY + sin(ang) * (maxDist);
              float aax = (tarX - puckX) * spr;
              float aay = (tarY - puckY) * spr;
             
              vx += aax;
              vy += aay;
              vx *= 0.5;
              vy *= 0.5;
          }
          
          // If our paddles hit the puck
          if (distance < minDist) 
          {    
              // Some rough blocking clode to control sound over playing
              for(int j = 0; j< 5000; j++)
              {
                test.rewind();
                test.play(); 
              }
            //  println("dx "+dx+" dy "+dy);
              float angle = atan2(dy, dx);
              float targetX = puckX + cos(angle) * (minDist);
              float targetY = puckY + sin(angle) * (minDist);
              float ax = (targetX - puckX) * spring;
              float ay = (targetY - puckY) * spring;
     
              vx -= ax;
              vy -= ay;
                       
          }
    
          // Adds movement to puck 
          puckX += vx;
          puckY += vy;
     } 
    float K= vy/vx;
     
    float C = puckY-puckX*K;
    // println("B "+ C); 
    float AA = K*K +1;
    float BB = 2*K*(C-height/2)-width;
    float CC = width*width/4+(height/2-C)*(height/2-C)-height*height/4;
    
    float sdelta = sqrt(BB*BB-4*AA*CC);
    float xx = (-BB+sdelta)/(2*AA);
    if(vx<=0)
    {
         xx = (-BB-sdelta)/(2*AA);
    }
    
    if(xx>= centerX+height/2-20 && abs(pre_xx-xx)>=2 )
    {
        myPort.write("1");
        println("ready to boom..."+(xx-centerX));
    }
    
    else if(xx<= centerX-height/2+20 && abs(pre_xx-xx)>=2 )
    {
        myPort.write("1");
        println("ready to boom..."+(xx-centerX));
    }
      
    
    pre_xx = xx;
    // Ensure it doesnt go off the X axis UNLESS its a goal
    if (puckX <=230) 
    {
      {
        score2++;
        score.rewind();
        score.play(); 
        puckX = width/2;
        puckY = height/2;
        vy = 0;
        vx = 0; 
      }
    }

    else if (puckX >=770) 
    { 
      {
        score1++;
        score.rewind();
        score.play(); 
        puckX = width/2;
        puckY = height/2;
        vy = 0;
        vx = 0; 
      }
    }
    
    
    
    
 } 

// Get methods
 int score1()
 {
   return score1;
 } 
 
 int score2()
 {
   return score2;
 } 
 
}