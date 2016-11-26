public interface iDrawable{
  public boolean isIn(int x, int y);
  public boolean isOverlap(ArrayList<iComponent> com);
  public  void render();
  public int[] getDrawTo();
  public int[] getDrawFrom();
}