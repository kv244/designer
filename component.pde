/// Rectangle
class rectangle extends iComponent{

  ///
  @Override
  public int[] getDrawFrom(){
    int px = x + sx;
    int py = y + (int)(sy/2);
    int[] points = {px, py};
    return points;
  }
  
  ///
  @Override
  public int[] getDrawTo(){
    int px = x;
    int py = y + (int)(sy/2);
    int[] points = {px, py};
    return points;
  }
 
 /// 
 rectangle(int x, int y){
   super(x, y);
   type = "RECT_1.0";
   this.sx = 60;
   this.sy = 20;
 }
 
 ///
 @Override
 public boolean isIn(int x, int y){
   if(((x > this.x) && (x < this.x + this.sx)) &&
      ((y > this.y) && (y < this.y + this.sy)))
   return true;
   else
     return false;
 }
 
 
 /// NOT IMPLEMENTED
 @Override
 public boolean isOverlap(ArrayList<iComponent> com) {
   return false;
 }

 ///
 @Override 
 public void render(){
    stroke(0, 0, 255);
    if(this.selected == true)
      strokeWeight(3);
    else
      strokeWeight(1);
      
    //textSize(8);
    rect(x, y, sx, sy);
    //text(this.name, this.x, this.y - this.sy);
    strokeWeight(1); // restore
  }
 
}