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
   this.sx = 25;
   this.sy = 15;
   ellipseMode(RADIUS);
 }
 
 /// TODO fix for circle
 /// distance or something
 /// EllipseMode should be corner
 /// Also check sizex, y
 @Override
 public boolean isIn(int px, int py){
   int calcY = width - this.y;

   if((
     ((px - this.x)^2 / this.sx ) + ((py - calcY)^2 / this.sy)
   ) <= 1)
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
    ellipse(this.x, this.y, this.sx, this.sy);
    //text(this.name, this.x, this.y - this.sy);
    strokeWeight(1); // restore
  }
}