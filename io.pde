/// IO handler
static class io{
  private static javax.swing.JFileChooser fc = new javax.swing.JFileChooser(); 
  
  ///
  public static String serialize(ArrayList<iComponent> components) throws Exception{
    fc.setDialogTitle("Choose file to save");
    int returnVal = fc.showSaveDialog(null);
    if(returnVal != javax.swing.JFileChooser.APPROVE_OPTION)
      throw new Exception("No file selected");
      
    DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
    DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
    Document doc = dBuilder.newDocument();        
    
    Comment comment = doc.createComment(version);
    doc.appendChild(comment);
    Date dNow = new Date( );
    SimpleDateFormat ft = new SimpleDateFormat ("E yyyy.MM.dd 'at' hh:mm:ss a zzz");
    comment = doc.createComment("Saved on " + ft.format(dNow));
    doc.appendChild(comment);
    
    Element rootElement = doc.createElement("designerRoot");
    doc.appendChild(rootElement);
    
    Element nodes = doc.createElement("components");
    rootElement.appendChild(nodes); 
    
    for(iComponent com:components){ 
      Element node = doc.createElement("component");
      node.setAttribute("name", com.getName());
      node.setAttribute("type", com.getType());
      node.setAttribute("x", Integer.toString(com.getX()));
      node.setAttribute("y", Integer.toString(com.getY()));
     
      ArrayList<iComponent> conn = com.getConnections(); 
      
      for(iComponent com2:conn){
        Element node2 = doc.createElement("connectTo");
        node2.setAttribute("component", com2.getName());
        node.appendChild(node2);
      }
      nodes.appendChild(node);
    }
    
    TransformerFactory transformerFactory = TransformerFactory.newInstance();
    Transformer transformer = transformerFactory.newTransformer();
    transformer.setOutputProperty(javax.xml.transform.OutputKeys.INDENT, "yes");
    DOMSource source = new DOMSource(doc);
    StreamResult result = new StreamResult(fc.getSelectedFile());
    transformer.transform(source, result);
    return fc.getSelectedFile().getAbsolutePath();
  }
  
  ///
  public static ArrayList<iComponent> load(){
    return null;
  }
}