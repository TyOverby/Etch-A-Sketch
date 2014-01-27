int led = 13;
int knob1 = 2;
int knob2 = 3;

void setup() {
  pinMode(led, OUTPUT);
  Serial.begin(9600);
}

void loop() {
  int v1 = analogRead(knob1);
  Serial.write((v1 / 4) | 1);
}
