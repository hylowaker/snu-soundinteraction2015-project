protected class NotePanel {
  public static final int N = 4;    // number of pitches
  private final int LOOP_INTERVAL = 4000;    // length(ms) of each loop
  //private final int LOOP_INTERVAL = 3750;    // length(ms) of each loop
  
  public int cellCount;    // number of beats
  public Note[] matrix;    // music score data
  public int currBeat;
  public int noteLength;
  public int recType;    // kind of instrument
  public int loopCount;
  public boolean startPoint;
  private int tmpBeat = 0;
  private boolean interactionEnabled = false;
  
  public NotePanel(int cellCount) {
    this.cellCount = cellCount;
    this.matrix = new Note[N*cellCount];
    for (int p = 0; p < N; p++) {
      for (int t = 0; t < cellCount; t++) {
        matrix[t + p*cellCount] = new Note(t, p, 0);
      }
    }
    this.currBeat = 0;
    this.noteLength = LOOP_INTERVAL/cellCount;
    this.recType = 1;
    this.loopCount = 0;
    this.startPoint = false;
  }
  
  public void setRecType(int recType) {
    this.recType = recType;
  }
  
  public void run() {
    noteLength = LOOP_INTERVAL/cellCount;

    // reset all notes to default state
    for (Note note : matrix) {
      note.defocus();
      note.unSmoothen();
    }
    
    // focus on notes corresponding to current beat index
    int t = currBeat;
    for (int j = 0; j < N; j++) {
      Note note = matrix[t + j*cellCount];
      note.focus();
    }
    
    // write a note
    //record(recType);
    
    // update current beat index
    currBeat = loopPos/noteLength % cellCount;
    
    if (currBeat == 0 && tmpBeat == 15) {
      loopCount++;
    }
    tmpBeat = currBeat;
    //println(loopCount);
  }
  
  //public void record(int type) {
  //  int t = currBeat;
  //  int p = 0; //
  //  if (Dummy.foo()) {
  //    Note note = matrix[t + p*cellCount];
  //    note.setType(type);
  //  }
  //}
  public void enableInteraction(boolean flag) {
    interactionEnabled = flag;
  }
  
  public void write(int pitch, int type) {
    if (!interactionEnabled)
      return;
      
    Note note = matrix[currBeat + pitch*cellCount];
    note.setType(type);
    //println("HELLO");
    
  }
  
  public Note getNoteAt(int timing, int pitch) {
    return matrix[timing + pitch*cellCount];
  }
  
  public void changeRecType(int type) {
    recType = type;
  }
  
  public void reset() {
    for (Note note : matrix) {
      note.setType(0);
    }
  }
}



public class MatrixPlayer {
  private final int W = ScreenSize.W;
  private final int H = ScreenSize.H;
  private final int CORNER_X = 0;
  private final int CORNER_Y = 0;
  
  private NotePanel panel;
  private NoteEffector[] effectors;
  private int metronAlpha;
  private int tmpBeatIndex;

  public MatrixPlayer(NotePanel panel) {
    this.panel = panel;
    this.effectors = new NoteEffector[panel.matrix.length];
    for (int i = 0; i < panel.matrix.length; i++) {
      Note note = panel.matrix[i];
      effectors[i] = new NoteEffector(note);
    }
    this.metronAlpha = 0;
    this.tmpBeatIndex = panel.currBeat;
  }
  
  public void run() {
    panel.run();
    
    // when hit, show hit effect to the corresponding cell
    if (Dummy.foo()) {
      int t = panel.currBeat;
      int p = 0;
      NoteEffector effector = effectors[t + p*panel.cellCount];
      effector.takeHitSignal();
    }
    
    display();
  }
  
  public void display() {
    
    for (NoteEffector effector : effectors) {
      effector.flagHandleLoop();
    }
    
    if (!panel.interactionEnabled)
      return;
      
    for (NoteEffector effector : effectors) {
      effector.displayLoop();
      effector.beatEffectDisplayLoop();
    }
    
    
      
    
    
    //debug
    //noStroke();
    //fill(255, 0, 120);
    //text(panel.currBeat, width - 30, H + 5);

    // beat stroke rectangle
    if (panel.currBeat != tmpBeatIndex) {
     if (panel.currBeat % 4 == 0) {
       metronAlpha = 160;
       tmpBeatIndex = panel.currBeat;
     }
    }
    //stroke(90, metronAlpha);

    //strokeWeight(10);
    noStroke();
    fill(56, metronAlpha);
    rectMode(CORNER);
    rect(0, height - 30, width, 30);
    metronAlpha -= 14;
  }
  
  public void whenMousePressedDo() {
    for (NoteEffector noteEffector: effectors) {
      if (noteEffector.xPos - noteEffector.GAP_X/2 < mouseX && mouseX < noteEffector.xPos + noteEffector.GAP_X/2 &&
      noteEffector.yPos - noteEffector.GAP_Y/2 < mouseY && mouseY < noteEffector.yPos + noteEffector.GAP_Y/2) {
        Note targetNote = noteEffector.note;
          if (targetNote.type == 0) {
            targetNote.setType(panel.recType);
          } else {
            targetNote.setType(0);
          }
      }
    }
  }
  
}