/*
  Keys:
  d to add rectangle √
    other letters for other components
  ! for delete √
  click to select a line then x to delete it
  s to save √
  drag to move component √
  connect: press z (no double click); z a second time to link √
  
  TODO:
  Fix deletes - read first: !, @, ~
   @ causes it to lock; still freezes
  Fix circle (see TODO at blob)
  
  Implement properties (click and add to component) --> save
    refactor to replace interface - see notes in Superclass √
  Implement load
   
  Improve: 
  show name?
  dont allow overlapping - use isOverlap?

  Better deletion of connections (select line)
  Message window doesn't handle multiline well
 
  Look at other TODOs
 
  */

/// imports
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.DocumentBuilder;
import org.w3c.dom.Attr;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Comment;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import java.util.*;
import java.text.*;

/// vars
ArrayList<iComponent> components;
iComponent selected;
boolean connecting;
iComponent connectFrom, connectTo;
static final String version = "0.20";
static final int sizeTextWindow = 70;
static final String helpMessage = "Designer " + version + 
  " d to drop a square, z to select/connect, drag component with mouse,! to delete selected, " + 
  " c to drop a circle, s to save, @ delete incoming, ~ delete outgoing connections.";
int currY; // current line printed to in the message window
boolean help;
int index; // current object added to canvas
boolean onePrintConn;
String hitWhich, dragWhich;
iComponent lineFrom, lineTo;

/// 
void setup(){
  size(600, 450); 
  background(255);
  noFill();
  
  components = new ArrayList<iComponent>();
  selected = null;
  connecting = false;
  connectFrom = connectTo = null;
  currY = height - sizeTextWindow;
  help = false; // only show help message once
  index = 0;
  onePrintConn = false;
  hitWhich = "";
  dragWhich = "";
  lineFrom = null; lineTo = null;
 
}

/// 
void draw(){

  fill(128, 255, 128); 
  stroke(0);
  rect(0, 0, 600, height - sizeTextWindow);
  noFill();
  rect(0, height - sizeTextWindow, 600, sizeTextWindow);
  
  if(!help){
    cprint(helpMessage);
    help = true;
  }
  
  for(iComponent com:components){ 
      com.render();
      
      // draw existing links 
      ArrayList<iComponent> conn = com.getConnections(); 
      for(iComponent com2:conn){
        bLine(com.getDrawFrom()[0], com.getDrawFrom()[1], 
          com2.getDrawTo()[0], com2.getDrawTo()[1]);
      }
  }    
  
  // draw currently dragging line
  if(connecting == true){
    if(onePrintConn == false){
      cprint("Connecting from " + selected.getName());
      onePrintConn = true;
    }
   
    bLine(selected.getX(), selected.getY(), mouseX, mouseY);
    return;
  }else
    onePrintConn = false;
}

/// This function draws the lines 
void bLine(int x1, int y1, int x2, int y2){
  line(x1, y1, x2, y2);
  return;
 /* 
  int xm, ym;
  int xc1, yc1;
  int xc2, yc2;
  
  xm = midpoint(x1, x2);
  ym = midpoint(y1, y2);
  xc1 = midpoint(x1, xm) / (int)(1 + Math.random() * 1.5);
  yc1 = midpoint(y1, ym) / (int)(1 + Math.random() * 1.5);
  xc2 = midpoint(x2, xm) * (int)(1 + Math.random() * 1.5);
  yc2 = midpoint(y2, ym) * (int)(1 + Math.random() * 1.5);
  
  bezier(x1, y1, xc1, yc1, xc2, yc2, x2, y2);
  */
}

/// Used by Bezier curves
int midpoint(int p1, int p2){
  int pm = 0;
  
  if(p1 > p2){ pm = (p1 - p2) / 2  + p2; }
    else{ pm = (p2 - p1) / 2  + p1; }
    
  return pm;
}

/// 
void mousePressed(){
  if(connecting){
    connecting = false;
    connectFrom = null;
    connectTo = null;
    return;
  }
  
  // check to see if line hit
  
  if(lineHit(mouseX, mouseY)){
    cprint("line hit " + lineFrom.getName() + " " + lineTo.getName());
  }else{
    cprint("No line hit");
    lineFrom = null;
    lineTo = null;
  }
    
  if(selected != null){
      selected.setSelected(false);
      selected = null;
      cprint("Unselected");
      return;
    }
    
    selected = findWhere(mouseX, mouseY);
    
    if(selected != null){
      cprint("Selected " + selected.getName());
      selected.setSelected(true); // this crashes after delete too
    }
}

///
void mouseDragged(){
  // TODO look for conflicts?

  if(selected != null){
    if(selected.getName() != dragWhich){
      dragWhich = selected.getName();
      cprint("Dragging " + dragWhich);
    }
    selected.setXY(mouseX, mouseY);
  }else{ dragWhich = ""; }
}

/// called by draw and others
iComponent findWhere(int x, int y){
  iComponent found = null;
  for(iComponent c:components){
    if(c.isIn(x, y)){
      found = c; 
      break;
    }
  }
  
  return found;
}

///
// TODO reuse this for select?
void mouseMoved(){
  iComponent which;
  if((which = findWhere(mouseX, mouseY)) != null){
    if(which.getName() != hitWhich){
      hitWhich = which.getName();
      cprint("Hit " + hitWhich);
    }
  }else{ 
    hitWhich = ""; 
    //cprint("Unhit");
  }
}

/// 
void keyPressed(){
  
  if(key == '~'){ // delete outgoing connections
    if(selected == null){
      cprint("Cannot delete connections, nothing selected");
      return;
    }
    cprint("Deleting outgoing connections " + 
      Integer.toString(selected.getConnections().size()) + " for " + selected.getName());
    selected.getConnections().clear(); 
    for(iComponent com2:selected.getConnections()){
      com2.getConnectingToMe().remove(selected);
    }
  }
  
  if(key == '@'){
    if(selected == null){
      cprint("Cannot delete connections, nothing selected");
      return;
    }
    cprint("Deleting incoming connections " + 
      Integer.toString(selected.getConnectingToMe().size()) + " for " + selected.getName());
      
    for(iComponent d:selected.getConnectingToMe()){
      for(iComponent e:d.getConnections()){
        if(e.getName() == selected.getName()){
          d.getConnections().remove(e);
          break;
        }
      }
    }
    selected.getConnectingToMe().clear(); 
  }
  
  
  // create rectangle
  // coupling: name has to be unique identifier
  if(key == 'd'){
    
   /* 
   try{
      iComponent x = (iComponent)Class.forName("blob").getConstructor(String.class).newInstance(40, 50);
      x.setName("99");
      cprint("created -- " + x.getName());
    }catch(Exception e){
      cprint("error -- "  + e.toString());
    } */
    
    iComponent c = new rectangle(mouseX, mouseY);
    c.setName(Integer.toString(index++));
    cprint("Adding rect: " + c.getName());
    if(c.isOverlap(components) == false)
      components.add(c);
    else{
      cprint("Overlapping");
      c = null;
    }
    return;
  }
  
  /// TODO is this necessary? simplify
  if(key == 'c'){
    iComponent c = new blob(mouseX, mouseY);
    c.setName(Integer.toString(index++));
    cprint("Adding blob: " + c.getName());
    if(c.isOverlap(components) == false)
      components.add(c);
    else{
      cprint("Overlapping");
      c = null;
    }
    return;
  }
  
  // save
  if(key == 's'){
    cprint("Saving");
    serialize();
    return;
  }
  
  // create connector
  // second press links
  if(key == 'z'){
    // can't attempt to connect if no source component selected
    if(selected == null){
      cprint("Nothing to connect to");
      return;
    }
    
    // if component selected and trying to connect, determine the target 
    if(connecting == true){
      connectTo = findWhere(mouseX, mouseY);
      if(connectTo == null){
        cprint("No target to connect to");
      }else
        if(connectTo.getName() == connectFrom.getName()){
          cprint("Cannot connect to itself");
        }else{
         
          // determine if not already connected
          if(selected.getConnections().contains(connectTo)){
            cprint("Already connected to " + connectTo.getName());
          }else{
            cprint("\tconnecting to " + connectTo.getName());
          
            // build link to connectTo in connectFrom
            connectFrom.connectTo(connectTo);
          
            // build link to connectFrom in connectTo so that I know which to remove at delete
            connectTo.setConnectedToMe(connectFrom);
          }
        }
      connectFrom = null;
      connectTo = null;
      connecting = false;
      return;
    }
    // connecting = false
    // initiating connection, target selected
    connectFrom = selected;
    connecting = true;
    cprint("Connecting " + connectFrom.getName());
    return;
  }
  
  // how to detect DELETE? 
  if(key == '!'){
    if(selected == null){
      cprint("Nothing to delete");
      return;
    }
    cprint("Delete " + selected.getName());
    
    // remove links to this from components that connect to it
    // TODO reuse the other deletes
    iComponent toRemove = selected;
    ArrayList<iComponent> linksTo = toRemove.getConnectingToMe();
    for(iComponent c:linksTo){
      c.getConnections().remove(toRemove);
    }
    
    // remove from existing components
    components.remove(selected);  
    connecting = false;
    selected = null;
    return;
  }
}

/// Determines if a line is selected when clicking the button
boolean lineHit(int testX, int testY){
  boolean val = false;
  for(iComponent com:components){
    lineFrom = com;
    ArrayList<iComponent> conn = com.getConnections(); 
      for(iComponent com2:conn){
        lineTo = com2;
        int point1X = com.getDrawFrom()[0];
        int point1Y = com.getDrawFrom()[1];
        int point2X = com2.getDrawTo()[0];
        int point2Y = com2.getDrawTo()[1];
       
        int dxc = testX - point1X;
        int dyc = testY - point1Y;

        int dxl = point2X - point1X;
        int dyl = point2Y - point1Y;

        int cross = dxc * dyl - dyc * dxl;

        if(cross == 0){
          if (abs(dxl) >= abs(dyl))
            val = dxl > 0 ? 
              point1X <= testX && testX <= point2X :
              point2X <= testX && testX <= point1X;
          else
            val = dyl > 0 ? 
              point1Y <= testY && testY <= point2Y :
              point2Y <= testY && testY <= point1Y;
        }else{
          cprint("No cross");
        }
        
        if(val == true)
          return val;
        /* 
        bLine(com.getDrawFrom()[0], com.getDrawFrom()[1], 
          com2.getDrawTo()[0], com2.getDrawTo()[1]);
          */
    }
  }
  if(val == false){ lineFrom = null; lineTo = null; }
  return val;
}

///
void cprint(String message){
  if(currY + textAscent() + textDescent() > height){
    currY = height - sizeTextWindow;
    fill(255, 255, 255);
    rect(0, height - sizeTextWindow, 600, sizeTextWindow);
  }
  fill(0, 0, 0);
  text(message, 0, currY, width, height); // TODO remove last 2 parms?
  currY += (textAscent() + textDescent());
  noFill();
}

///
void serialize(){
  try{
    cprint("Saved to: " + io.serialize(components));
  }catch(Exception x){
    cprint(x.getMessage());
  }
}