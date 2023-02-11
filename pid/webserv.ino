#include <Arduino.h>
#ifdef ESP32
  #include <WiFi.h>
  #include <AsyncTCP.h>
#else                                              //BOUTH PLATFORM 8226 OR ESP32 WROM(SIMILAR)
  #include <ESP8266WiFi.h>
  #include <ESPAsyncTCP.h>
#endif
#include <ESPAsyncWebServer.h>

  AsyncWebServer server(80);    //Default port 80 change if neaded 
  unsigned int8_t speedM=100;
  const char* input_parameter1 = "input_string";
//HTML PAGE
 char index_html[] PROGMEM = R"rawliteral(
<!DOCTYPE HTML><html><head>
  <title>HTML Form to Input Data</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <style>
    html {font-family: Times New Roman; display: inline-block; text-align: center;}
    h2 {font-size: 3.0rem; color: #FF0000;}
  </style>
  </head><body>
  <h2>Motor Speed Control</h2> 
  
  <form action="/get">
    Enter an integer: <input type="number" name="input_integer">
    <input type="submit" value="Submit">
  </form>
  <br>
  
</body></html>)rawliteral";

void notFound(AsyncWebServerRequest *request) {
  request->send(404, "text/plain", "Not found");                         //IF SERVER IS NOT FOUND
}
 
void setupConection(void)
{
  String password="",String ssid="";  //Input your wifi credential
  int counter=0;
    WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, password);
  if (WiFi.waitForConnectResult() != WL_CONNECTED) {
    Serial.println("Connecting...");
    return;
  }
  Serial.println();
  Serial.print("IP Address: ");
  Serial.println(WiFi.localIP());

  server.on("/", HTTP_GET, [](AsyncWebServerRequest *request){           //IF 200 ok 
    request->send_P(200, "text/html", index_html);
  });

  server.on("/get", HTTP_GET, [] (AsyncWebServerRequest *request) {
    String input_message;                                                                //get asynchro
    String input_parameter;

    if (request->hasParam(input_parameter1)) {
      input_message = request->getParam(input_parameter1)->value();                      //extraction of a value()
      input_parameter = input_parameter1;
    }

    else {
      input_message = "No message sent";
      input_parameter = "none";                                                          //ako ne postoji
    }
    //Serial.println(input_message);              //on second page shoing of a speed                                                                                                                                  //ASCI +48           
    request->send(200, "text/html", "HTTP GET request sent to your ESP on input field ("+ input_parameter + ") with value: " + input_message + "<br><a href=\"/\">Return to Home Page</a>"+"<p>This is a speed:"+(speedM+48)+ "RPM</p>");
  });
  server.onNotFound(notFound);                            //nema servera
  server.begin();                                         //Pocni
}
void setup() 
{
  // put your setup code here, to run once:
  Serial.begin(9600);   //Voditi racuna sta se salje usb connected to a uart basicli alredy send BAUND MUST be the same
  setupConection();
}
void loop() 
{
  // put your main code here, to run repeatedly:
  Serial.stop();    //Stop uart
  Serial.begin(9600);  //Matching with a uart on pic

   if (Serial.available() > 0) 
   {
    // read the incoming byte:
    speedM = Serial.read();
   }
   else 
   {
    Serial.write(input_parameter1); 
   }

}





 
