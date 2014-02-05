import processing.serial.*;

Serial serial;

int cursorX;
int cursorY;

int pixelWidth;
int pixelHeight;

int gridNum = 0;
boolean[][] gridA = new boolean[256][256];
boolean[][] gridB = new boolean[256][256];
boolean[][] readGrid = gridA;
boolean[][] writeGrid = gridB;

void setup() {
  serial = new Serial(this, Serial.list()[0], 9600);
  size(displayWidth, displayHeight);
  pixelWidth = (displayWidth / 255) * 2;
  pixelHeight = (displayHeight / 255) * 2;
  background(0);
}

boolean sketchFullScreen() {
  return true;
}

int getCell(int row, int col) {
    boolean state = readGrid[row][col];
    int neighbors = 0;

    for (int x = Math.max(0,row-1); x < Math.min(row+2,255); x++) {
        for (int y = Math.max(0,col-1); y < Math.min(col+2,255); y++) {
              if (readGrid[x][y] == true){
                neighbors ++;

              }
          }
      }
    
    return neighbors - (state ? 1 : 0);
}

void step() {

  for (int i = 0; i < 255; i++) {
    for (int k = 0; k < 255; k++) {
      int n = getCell(i, k);
      if(readGrid[i][k]) {
        if (n > 3 || n <=2) {
          writeGrid[i][k] = false;
        } else {
          writeGrid[i][k] = true;
        }
      } else {
        if (n == 3) {
          writeGrid[i][k] = true;
        } else {
          writeGrid[i][k] = false;
        }
      }
    }
  }  
  readGrid = gridNum == 0 ? gridA : gridB; 
  writeGrid = gridNum == 0 ? gridB : gridA;
  gridNum++;
  gridNum %= 2;
}

int frameCounter = 0;
int stepCounter = 0;
void draw() {
  background(0);
  //rect(cursorX, cursorY, 4, 4);
  //rect(cursorX * pixelWidth, cursorY * pixelHeight, pixelWidth + 5, pixelHeight + 3);
  
  for (int i = 0; i < readGrid.length; i++) {
    for (int k = 0; k < readGrid[0].length; k++) {
      if (readGrid[i][k]) {
        rect(i * pixelWidth, k * pixelHeight, pixelWidth, pixelHeight);
      }
    }
  }
  
  boolean steppedThisFrame = false;
  int avail = serial.available();
  for (;avail > 0; avail --) {
    int value = serial.read();
    if (value == 0 ){//&& !steppedThisFrame) {
      steppedThisFrame = true;  
      stepCounter ++;
     // if(stepCounter % 10 == 0) {
        //step();
        serial.clear();
        return;
        //println("stepping)");
      //}
    }
    if ((value & 1) == 1) {
      cursorX = (256 - (value ^ 1)) / 2;
    } else {
      cursorY = value / 2;
    }
    readGrid[cursorX][cursorY] = true;
  }
}

void keyPressed() {
  background(0);
  step();
  //delay(500);  
}
