int led = 13;
int knob1 = 2;
int knob2 = 4;

int pv1 = 0;
int pv2 = 0;

void setup() {
  pinMode(led, OUTPUT);
  Serial.begin(9600);
}

void loop() {
  int v1 = analogRead(knob1);
  if (v1 != pv1) {
    Serial.write((v1 / 4) | 1);
    pv1 = v1;
  }
  
  int v2 = analogRead(knob2);
  if (v2 != pv2) {
    Serial.write((v2 / 4) & (~1));
    pv2 = v2;
  }
}
