public class MenuInterface {
  
  public int currentKit = 1;
  
  public void drawAsdf() {
    textAlign(CENTER, CENTER);
    textSize(32);
    fill(150, 150, 150, 100);
    text("F", 60 - 40, 160 + 0*80); 
    text("D", 60 - 40, 160 + 1*80);
    text("S", 60 - 40, 160 + 2*80); 
    text("A", 60 - 40, 160 + 3*80); 
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

}