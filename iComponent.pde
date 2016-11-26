/// Component functionality - superclass

class iComponent implements iDrawable {
  int x, y; // position
  int sx, sy; // size
  String name;
  boolean selected;
  ArrayList<iComponent> connections;
  ArrayList<iComponent> connectingToMe;
  String type;
 
  iComponent(int x, int y){
    this.setXY(x, y);
    connections = new ArrayList<iComponent>();
    connectingToMe = new ArrayList<iComponent>();
  }
  public void setName(String name){ this.name = name; }
  
  public String getName(){ return this.name; }
  
  public int getSizeX(){ return this.sx; }
  public int getSizeY(){ return this.sy; }
  public int getX(){ return this.x; }
  public int getY(){ return this.y; }
  public ArrayList<iComponent> getConnections(){ return this.connections; }
  public String getType(){ return this.type; }
  public void connectTo(iComponent c){ connections.add(c); }
  
  public ArrayList<iComponent> getConnectingToMe(){
    return connectingToMe;
  }
  
  public void setConnectedToMe(iComponent com){
    connectingToMe.add(com);
  }
  
  public void setSelected(boolean selected){
    this.selected = selected;
  }
  
  public void setXY(int x, int y){
    this.x = x;
    this.y = y;
  }  
  
  /// TODO still not ok
  public void render(){}
  public boolean isOverlap(ArrayList<iComponent> a){ return false; }
  public boolean isIn(int x, int y){ return false; }
  public int[] getDrawTo(){ return null; }
  public int[] getDrawFrom(){ return null; }
}