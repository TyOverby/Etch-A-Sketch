import processing.serial.*;

Serial serial;

int cursorX;
int cursorY;

void setup() {
  serial = new Serial(this, Serial.list()[0], 9600);
  size(1024 / 2, 1024 / 2);
}

void draw() {
  rect(cursorX, cursorY, 4, 4);
  
  int avail = serial.available();
  for (;avail > 0; avail --) {
    int value = serial.read();
    println(value);
    if ((value & 1) == 1) {
      cursorX = (value ^ 1) * 2;
    } else {
      cursorY = value * 2;
    }
  }
}
