class Puck{
 int x,y,diam; 
 float spring = 0.08;  
 float friction = -0.7;
 int vy = 0, vx = 0;
 ArrayList<paddle> paddles;
 int score1 = 0;
 int score2 = 0;
 boolean goal = false;
  
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
          float minDist = (p1.r/2) + (p1.r/2);
          
          // If our paddles hit the puck
          if (distance < minDist) 
          {    
              // Some rough blocking clode to control sound over playing
              for(int j = 0; j< 5000; j++)
              {
                test.rewind();
                test.play(); 
              }

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
    
    // Ensure it doesnt go off the X axis UNLESS its a goal
    if (puckX + diam/2 > width) 
    {
       
      if( puckY < 205 || puckY > 395)
      {
        wallHit.rewind();
        wallHit.play();
        puckX = width - diam/2;
        vx *= friction; 
      }
      else
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
    
    else if (puckX - diam/2 < 0) 
    {
      
      if( puckY < 205 || puckY > 395)
      {
        wallHit.rewind();
        wallHit.play(); 
        puckX = diam/2;
        vx *= friction; 
      }
      else
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
    
    // Ensure it doesnt go off the Y axis
    if (puckY + diam/2 > height) 
    {
      wallHit.rewind();
      wallHit.play(); 
      puckY = height - diam/2;
      vy *= friction; 
    } 
    
    else if (puckY - diam/2 < 0) 
    {
      wallHit.rewind();
      wallHit.play(); 
      puckY = diam/2;
      vy *= friction;
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