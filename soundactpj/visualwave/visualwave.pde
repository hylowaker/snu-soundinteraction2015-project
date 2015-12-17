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

public int loopPos;


void setup() {
  size(1400, 720);
  
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
  //currentMatrix = matrix1;
  currentPlayer.panel.enableInteraction(true);


  //myServer = new Server(this, 12000);
  oscP5 = new OscP5(this, 8001);
  myRemoteLocation = new NetAddress("127.0.0.1", 8002);
}


void draw() {
  background(40);
  
  menuInterface.drawAsdf();
  menuInterface.drawKitNumber();

  matrixScreen1.run();
  matrixScreen2.run();
  matrixScreen3.run();
  matrixScreen4.run();
  //  println(frameRate);
  
  for (NotePanel matrix: matrices) {
    matrix.enableInteraction(false);
  }
  currentPlayer.panel.enableInteraction(true);
  
  
  //loopPos = millis(); // TODO
}


void keyPressed() {
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
}


void mousePressed() {
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
  /* create an osc bundle */
  OscBundle myBundle = new OscBundle();

  /* createa new osc message object */
  OscMessage myMessage = new OscMessage("/start");
  myMessage.add(1);
  myBundle.add(myMessage);
  
  //myBundle.setTimetag(myBundle.now() + 10000);
  /* send the osc bundle, containing 2 osc messages, to a remote location. */
  oscP5.send(myBundle, myRemoteLocation);
}


void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  //print("### received an osc message.");
  //print(" addrpattern: "+theOscMessage.addrPattern());
  //println(" typetag: "+theOscMessage.typetag());
  //println(theOscMessage.get(0).intValue());
  loopPos = theOscMessage.get(0).intValue();
}