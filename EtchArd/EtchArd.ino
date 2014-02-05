int led = 13;
int knob1 = 2;
int knob2 = 4;
int btn = 2;

int pv1 = 0;
int pv2 = 0;
int pb = 0;

void setup() {
  pinMode(btn, INPUT);
  Serial.begin(9600);
}

void loop() {
  int v1 = analogRead(knob1);
  if (v1 != pv1 && v1 != 0) {
    Serial.write((v1 / 4) | 1);
    pv1 = v1;
  }
  
  int v2 = analogRead(knob2);
  if (v2 != pv2 && v2 != 0) {
    byte value = (v2 / 4) & (~1);
    if (value != 0) {
      Serial.write(value);
    }
    pv2 = v2;
  }
  
  int curbtn = digitalRead(btn);
  //if (curbtn != pb && curbtn == HIGH) {
  if(curbtn == HIGH){
    pb = curbtn;
    Serial.write(0);
  }
}
