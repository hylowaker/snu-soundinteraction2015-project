//import processing.net.*;
import netP5.*;
import oscP5.*;

//Server myServer;
NetP5 netP5;
OscP5 oscP5;
NetAddress myRemoteLocation;

NotePanel matrix1, matrix2, matrix3, matrix4;
NotePanel[] matrices = new NotePanel[4];
MatrixPlayer matrixScreen1, matrixScreen2, matrixScreen3, matrixScreen4;
MatrixPlayer currentPlayer;
MenuInterface menuInterface = new MenuInterface();

int loopPos;
boolean viewOnMain = true;


void setup() {
  //size(1600, 900);
  fullScreen();
  
  matrixScreen1 = new MatrixPlayer(matrix1 = new NotePanel(32));
  matrixScreen2 = new MatrixPlayer(matrix2 = new NotePanel(32));
  matrixScreen3 = new MatrixPlayer(matrix3 = new NotePanel(32));
  matrixScreen4 = new MatrixPlayer(matrix4 = new NotePanel(32));
  matrices[0] = matrix1;
  matrices[1] = matrix2;
  matrices[2] = matrix3;
  matrices[3] = matrix4;
  
  matrix1.setRecType(1);
  matrix2.setRecType(2);
  matrix3.setRecType(3);
  matrix4.setRecType(4);
  
  currentPlayer = matrixScreen1;
  currentPlayer.panel.enableInteraction(true);

  oscP5 = new OscP5(this, 8001);
  myRemoteLocation = new NetAddress("127.0.0.1", 8002);
}


void draw() {
  background(40);
  
  if (viewOnMain) {
    textAlign(CENTER, CENTER);
    textSize(40);
    fill(190, 190, 190, 220);
    text("--Introduction--", width/2, height/2 - 100);
    text("Press A, S, D, F key or click on a cell to fill the sequencer", width/2, height/2 - 50);
    text("Press 1, 2, 3, 4 key to change the instrument", width/2, height/2);
    text("Press R key to reset the sequencer", width/2, height/2 + 50);
    text("Left click to continue...", width/2, height/2 + 150);
    return;
  }
  
  
  menuInterface.drawAsdf();
  menuInterface.drawKitNumber();
  menuInterface.drawElse();
  

  matrixScreen1.run();
  matrixScreen2.run();
  matrixScreen3.run();
  matrixScreen4.run();
  //  println(frameRate);
  
  for (NotePanel matrix: matrices) {
    matrix.enableInteraction(false);
  }
  currentPlayer.panel.enableInteraction(true);
  
  
  loopPos = millis(); // TODO
}


void keyPressed() {
  if (viewOnMain) {
    viewOnMain = false;
    sendStartOsc();
    println("debug yo");
    return;
  }
  
  if (key == 'r' || key == 'R') {
    currentPlayer.panel.reset();
  }
  
  if (key == '1') {
      currentPlayer = matrixScreen1;
      menuInterface.currentKit = 1;
    } else if (key == '2') {
      currentPlayer = matrixScreen2;
      menuInterface.currentKit = 2;
    } else if (key == '3') {
      currentPlayer = matrixScreen3;
      menuInterface.currentKit = 3;
    } else if (key == '4') {
      currentPlayer = matrixScreen4;
      menuInterface.currentKit = 4;
    } else if (key == '5') {
  } 
  
  if (key == 'a') {
    currentPlayer.panel.write(3, currentPlayer.panel.recType);
    } else if (key == 's') {
    currentPlayer.panel.write(2, currentPlayer.panel.recType);
    } else if (key == 'd') {
    currentPlayer.panel.write(1, currentPlayer.panel.recType);
    } else if (key == 'f') {
    currentPlayer.panel.write(0, currentPlayer.panel.recType);
  }
    
    
  if (key == ' ') {
    sendStartOsc();
  }
  
  if (keyCode == BACKSPACE) {
    sendStopOsc();
    viewOnMain = true;
    for(NotePanel matrix: matrices) {
      matrix.reset();
    }  
  }
}


void mousePressed() {
  if (viewOnMain) {
    viewOnMain = false;
    sendStartOsc();
    return;
  }

  currentPlayer.whenMousePressedDo();
  
  // change currentPlayer by mouse
  if (width/2 - 450 - 70 < mouseX && mouseX < width/2 - 450 + 70 &&
  600 - 70 < mouseY && mouseY < 600 + 70) {
        currentPlayer = matrixScreen1;
        menuInterface.currentKit = 1;
  }
  if (width/2 - 150 - 70 < mouseX && mouseX < width/2 - 150 + 70 &&
  600 - 70 < mouseY && mouseY < 600 + 70) {
        currentPlayer = matrixScreen2;
        menuInterface.currentKit = 2;
  }
  if (width/2 + 150 - 70 < mouseX && mouseX < width/2 + 150 + 70 &&
  600 - 70 < mouseY && mouseY < 600 + 70) {
        currentPlayer = matrixScreen3;
        menuInterface.currentKit = 3;
  }
  if (width/2 + 450 - 70 < mouseX && mouseX < width/2 + 450 + 70 &&
  600 - 70 < mouseY && mouseY < 600 + 70) {
        currentPlayer = matrixScreen4;
        menuInterface.currentKit = 4;
  }
  
  // view SAMPLE
  if (0.8*width - 80 < mouseX && mouseX < 0.8*width + 80 &&
  0.9*height - 80 < mouseY && mouseY < 0.9*height + 80) {
        setSample();
  }
  
}


void sendNoteOsc(int instrumentType, int index) {
  /* create an osc bundle */
  OscBundle myBundle = new OscBundle();

  /* createa new osc message object */
  OscMessage myMessage = new OscMessage("/note");
  myMessage.add(instrumentType);
  myMessage.add(index);
  myBundle.add(myMessage);
  
  //myBundle.setTimetag(myBundle.now() + 10000);
  /* send the osc bundle, containing 2 osc messages, to a remote location. */
  oscP5.send(myBundle, myRemoteLocation);
}


void sendStartOsc() {
  OscBundle myBundle = new OscBundle();
  OscMessage myMessage = new OscMessage("/start");
  myMessage.add(1);
  myBundle.add(myMessage);
  oscP5.send(myBundle, myRemoteLocation);
}


void sendStopOsc() {
  OscBundle myBundle = new OscBundle();
  OscMessage myMessage = new OscMessage("/stop");
  myMessage.add(1);
  myBundle.add(myMessage);
  oscP5.send(myBundle, myRemoteLocation);
}


void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  //print("### received an osc message.");
  //print(" addrpattern: "+theOscMessage.addrPattern());
  //println(" typetag: "+theOscMessage.typetag());
  //println(theOscMessage.get(0).intValue());
  //loopPos = theOscMessage.get(0).intValue();
}


void setSample() {
  for(NotePanel matrix: matrices) {
    matrix.reset();
  }
  int[] set13 = {0,8,16,24};
  for (int i: set13) {
    matrix1.getNoteAt(i, 3).setType(1);
  }
  int[] set12 = {4,12,20,28};
  for (int i: set12) {
    matrix1.getNoteAt(i, 2).setType(1);
  }
  int[] set11 = {0,2,4,6,7,9,11,13,14,16,17,19,22,24,26,27,29,30};
  for (int i: set11) {
    matrix1.getNoteAt(i, 1).setType(1);
  }
  int[] set10 = {3,6,10,18,22,25,28};
  for (int i: set10) {
    matrix1.getNoteAt(i, 0).setType(1);
  }
  
  int[] set23 = {0,3,6};
  for (int i: set23) {
    matrix2.getNoteAt(i, 3).setType(2);
  }
  int[] set22 = {8,11,14};
  for (int i: set22) {
    matrix2.getNoteAt(i, 2).setType(2);
  }
  int[] set21 = {24,27,30};
  for (int i: set21) {
    matrix2.getNoteAt(i, 1).setType(2);
  }
  int[] set20 = {16,19,22};
  for (int i: set20) {
    matrix2.getNoteAt(i, 0).setType(2);
  }
  
  int[] set33 = {0,12,20,28};
  for (int i: set33) {
   matrix3.getNoteAt(i, 3).setType(3);
  }
  int[] set32 = {2,10,14,22,26};
  for (int i: set32) {
   matrix3.getNoteAt(i, 2).setType(3);
  }
  int[] set31 = {4,8,18,24};
  for (int i: set31) {
   matrix3.getNoteAt(i, 1).setType(3);
  }
  int[] set30 = {6,16,30};
  for (int i: set30) {
   matrix3.getNoteAt(i, 0).setType(3);
  }
  
  int[] set42 = {0,3,6};
  int[] set41 = {8,11,14};
  int[] set40 = {16,19,22};
  int[] set43 = {24,27,30};
  for (int i: set40) {
   matrix4.getNoteAt(i, 0).setType(4);
  }
  for (int i: set41) {
   matrix4.getNoteAt(i, 1).setType(4);
  }
  for (int i: set42) {
   matrix4.getNoteAt(i, 2).setType(4);
  }
  for (int i: set43) {
   matrix4.getNoteAt(i, 3).setType(4);
  }
}