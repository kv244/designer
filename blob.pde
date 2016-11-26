class blob extends iComponent{
   ///
  @Override
  public int[] getDrawFrom(){
    int[] points = {this.x, this.y};
    return points;
  }
  
  ///
  @Override
  public int[] getDrawTo(){
    int[] points = {this.x, this.y};
    return points;
  }
 
 /// 
 blob(int x, int y){
   super(x, y);
   type = "BLOB_1.0";
   this.sx = 30;
   this.sy = 40;
 }
 
 /// TODO fix for circle
 /// distance or something
 /// EllipseMode should be corner
 /// Also check sizex, y
 @Override
 public boolean isIn(int x, int y){
   if(((x > this.x) && (x < this.x + this.sy)) &&
      ((y > this.y) && (y < this.y + this.sx)))
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
    ellipse(x, y, sy, sx);
    //text(this.name, this.x, this.y - this.sy);
    strokeWeight(1); // restore
  }
}