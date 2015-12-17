protected class Note {
  public int timing;
  public int pitch;
  public int type;
  private boolean focused_;
  private boolean lively;
  
  public Note(int timing, int pitch) {
    this(timing, pitch, 0);
  }
  
  public Note(int timing, int pitch, int type) {
    this.timing = timing;
    this.pitch = pitch;
    this.type = type;
    this.focused_ = false;
    this.lively = true;
  }
  
  public void setType(int type) {
    this.type = type;
  }
  
  public boolean isFocused() {
    return focused_;
  }
  
  public void focus() {
    focused_ = true;
  }
  
  public void defocus() {
    focused_ = false;
  }
  
  public boolean isSmoothened() {
    return !lively;
  }
  
  public void smoothen() {
    lively = false;
  }
  
  public void unSmoothen() {
    lively = true;
  }
}



public class NoteEffector {
  private final int BASEPOS_X = 60;
  private final int BASEPOS_Y = 160;
  private final int GAP_X = 40;
  private final int GAP_Y = 80;
  private final int GAP_XCHUNK = 6;
  
  private Note note;
  private int blurryAlpha;
  private int pitchFxAlpha;
  private int xPos;
  private int yPos;
  private int fxFramesPassed;
  private boolean newNote;
  private boolean focusFlag;
  private boolean beatVisible;
 
  public NoteEffector(Note note) {
    this.note = note;
    this.blurryAlpha = 0;
    this.pitchFxAlpha = 0;
    this.xPos = BASEPOS_X + GAP_X*note.timing + note.timing/4*GAP_XCHUNK;
    this.yPos = BASEPOS_Y + GAP_Y*note.pitch;
    this.fxFramesPassed = 999;
    this.newNote = false;
    this.focusFlag = false;
    this.beatVisible = false;
  }
  
  public void displayLoop() {
    if (note.type == 0) {
      noStroke();
      fill(200, 200, 200, 80);
    } else if (note.type == 1) {
      noStroke();
      fill(198, 198, 104);
    } else if (note.type == 2) {
      noStroke();
      fill(104, 197, 186);
    } else if (note.type == 4) {
      noStroke();
      fill(130, 100, 250);
    } else {
      noStroke();
      fill(215, 200, 195);
    }
    
    rectMode(CENTER);
    rect(xPos, yPos, GAP_X - 2, GAP_Y - 2, 4);
    
    inFocus();
    inPitchFocus();
  }
  
  // always activated even if matrix not enabled
  public void flagHandleLoop() {
    if (note.type != 0 && note.isFocused()) {
      beatVisible = true;
      if (!focusFlag) {
        fxFramesPassed = 0;
        focusFlag = true;
        playSound();
      }
    }
    
    if (fxFramesPassed > 30) {
      focusFlag = false;
      beatVisible = false;
      newNote = false;
    }
    fxFramesPassed++;
  }
  
  public void takeHitSignal() {
    fxFramesPassed = 0;
    newNote = true;
  }
  
  private void beatEffectDisplayLoop() {
    if (beatVisible) {
      color c;
      if (newNote) {
        c = color(255, 255, 0);
      } else {
        c = color(255, 255, 255);
      }
      int a = 255 - 14*fxFramesPassed;
      stroke(c, a);
      strokeWeight(4);
      noFill();
      int d = 5*fxFramesPassed;
      ellipse(xPos, yPos, d, d);
    }
  }
  
  private void inFocus() {
    if (note.isFocused()) {
      blurryAlpha = 120;
    } else {
      blurryAlpha = 0;
    }
    //blurryAlpha = constrain(blurryAlpha, 0, 205);
    
    if (blurryAlpha > 0) {
      //color c = color(251, 120, 120);
      //stroke(c, blurryAlpha);
      //strokeWeight(5);
      //ellipseMode(CENTER);
      //ellipse(xPos, yPos, 16, 16);
      color c = color(216, 61, 204);
      noStroke();
      fill(c, blurryAlpha);
      rectMode(CENTER);
      rect(xPos, yPos, GAP_X - 2, GAP_Y - 2, 4);
    }
  }
  
  private void inPitchFocus() {
    if (Dummy.foo()) {
      pitchFxAlpha = 255;
    } else {
      pitchFxAlpha -= 25;
    }
    pitchFxAlpha = constrain(pitchFxAlpha, 0, 255);
    
    if (pitchFxAlpha > 0) {
      color c = color(255, 255, 0);
      stroke(c, pitchFxAlpha);
      strokeWeight(2);
      ellipseMode(CENTER);
      ellipse(xPos, yPos, 20, 20);
    }
  }
  
  private void playSound() {
    int index = NotePanel.N - note.pitch - 1;
    sendNoteOsc(note.type, index);
    Dummy.foo();
  }
  
}