class paddle
{
   int x,y,r,r2;

   paddle(int _x, int _y, int _r, int _r2)
   {
      x = _x;
      y = _y;
      r = _r;
      r2 = _r2;
   }

   void display()
   {
     fill(255);
     stroke(0);
     strokeWeight(2);
     ellipse(x,y,r,r2);
   }

   void move(int _moveX, int _moveY)
   {
      x = _moveX;
      y = _moveY;
 
      if (x + r> width) 
      {   
        x = width - r/2;
      }
    
      else if(x - r/2 < 0) 
      { 
        x = r/2;
      }
    
     if (y + r/2 > height) 
     {
        y = height - r/2;   
     } 
    
     else if (y - r/2 < 0) 
     {
        y = r/2;  
     }
  }

}