public class MenuInterface {
  
  public int currentKit = 1;
  
  public void drawAsdf() {
    textAlign(CENTER, CENTER);
    textSize(32);
    fill(150, 150, 150, 100);
    //String, BASEPOS_X - GAP_X, BASEPOS_Y + i*GAP_Y
    text("F", 140 - 40, 240 + 0*60); 
    text("D", 140 - 40, 240 + 1*60);
    text("S", 140 - 40, 240 + 2*60); 
    text("A", 140 - 40, 240 + 3*60); 
  }
  
  public void drawKitNumber() {
    textAlign(CENTER, CENTER);
    textSize(50);
    
    fill(200, 200, 200, 80);
    if (currentKit == 1) fill(255, 255, 255);
    text("1", width/2 - 450, 600);
    
    fill(200, 200, 200, 80);
    if (currentKit == 2) fill(255, 255, 255);
    text("2", width/2 - 150, 600);
    
    fill(200, 200, 200, 80);
    if (currentKit == 3) fill(255, 255, 255);
    text("3", width/2 + 150, 600);
    
    fill(200, 200, 200, 80);
    if (currentKit == 4) fill(255, 255, 255);
    text("4", width/2 + 450, 600); 
    
  }
  
  public void drawElse() {
    fill(200, 200, 200, 80);
    textSize(25);
    text("Press Backspace to return to main.", width/2, 0.9*height);
    
    fill(200, 200, 200, 140);
    textSize(28);
    text("[SAMPLE]", 0.8*width, 0.9*height);
  }

}