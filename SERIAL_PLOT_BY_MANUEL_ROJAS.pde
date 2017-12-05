
/*
 about;
 I'm currently ( 11 november 2015) a Student of Colegio Arubabo, Aruba. I created this program as part of my Project for physics.
 It took me @ 70 hours to complete, due to the fact that when i started I didnt know much of Processing codes so I had to learn it from the bottom,
 it took me 2 weeks to learn and create this program. Before I started I only knew a bit of C /  arduino programming language.
 I created this program because I needed a program that was able to plot Serial data. And also Capture the serial data for later analysis.
 ( the saved data will be erased after the program has been restarted.)
 The data is saved in the CSV format in a txt file.
 The program uses the (,) to indicate a separate value. This means that the data has to be transmitted with the (,) included.
 the program can handle extremely big numbers as coordinates and as maximum range for a specific variable
 INcome data will be printed under the values/ above the plot graph..
 The program supports only 10 different value. those are the first 10 values separated by a (,), after nothing else is concidered as a value.
 Serial data can also be send by selecting "Data out " and pressing enter to send, the sended string will end with the char 10.(\n) carriage return.
 Each value can act as an X coordinate or as a Y coordinate. 
 Name, max, min of the variables can be changed individualy.
 When more than one Variable is selected on the X-axis and on the Y-axis,the program will plot on a default scale that can also be adjusted.
 The background, the plot thickness and the grid size can be adjusted.
 
 all the values in the settings will be saved to an external txt file.
 if those txt files are deleted, the program will crash, all you have to do is restart the program ( force close ).
 This happens because there will be no settings to read from, when the program crashed it will save the default settings.
 And on restart the program will work normally.
 the axis is calculated by the max and the min values.

this program is openSource and you are allowed to modify it.
but please tell me. tell me about your modification.
please email me at Nodood@hotmail.com

update>> 10/10/2015 ==>> added multiplot with one y/x coord and graph lined// connect dot

have fun, and keep on having fun with coding and processing and arduino /whatever you do :)


screen size can be changed to fullscreen by uncomenting the fullscreen() in the void setup(){}

 */




import processing.serial.*;
Serial Port;
//PrintWriter serialsave;

int displaywidth = 0;//displayWidth;
 int displayheight = 0;
int axisthickness = 1;
int portok = 0;// ok to read from port\


  void settings(){ 
 
    size((displayWidth*8785/10000), (displayHeight*9115/10000)); 
displaywidth = width;//displayWidth;
displayheight = height;
 startplot[3+10] = 0;


}






void setup(){
   
  
  //displaywidth = (displayWidth*8785/10000);displayheight = (displayHeight*9115/10000);//// display Settings windowed
  //size(displayWidth, displayHeight);

 // fullScreen(); displaywidth =height ;displayheight = width ;//// display Settings fullScreen, at startup readings could be incorrect, set the screen size manually or define it in draw
  
  //try{fullscreen = parseInt(loadStrings("fullscreen.txt"));}catch(Exception NullPointer){saveStrings("fullscreen.txt", str(fullscreen));}
  
  
  
  
  
//serialsave = createWriter("coordinates.txt");







}
    
    float Voltage = 0, Current = 0, Thrust = 0, Torque = 0, Power = 0, RPM = 0, Windspeed = 0;
  float[] defscale = {15,-15, 15,-15};//dfault scale when there are more plots
  int[] drawaxis ={0,0,0,0};// draw axis latch, default , x, y
  int reset = 0;
  
  String name[] = {"XX","1","2","3","4","5","6","7","8","9","10","","","","X1","X1","X1","X1","X1","X1","X1","X1","X1","X1","","","",""};/// holds the variable names
  float[] max = {15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,};//max values
  float[] min = {-15,-15,-15,-15,-15,-15,-15,-15,-15,-15,-15,-15,-15,-15,-15,-15,-15,-15,-15,-15,-15,-15,};//  min values
  float[] value = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};// income values string
  int[] c = {0,0};//custom values ...... to plot
  int variabletextprint = 0;// text Variables , to print only on startup
  String[] port = {"","","",""};// port name buffer
String[] incomedata = {"","","","",""};// new data , old data == used to print only on new data income
String[] values = {"","","","","","","","","","","","","","",""};/// values
 float[] plotsetting = {204,1,8,1,0,0,0};///plot settings====> plotsetting[0], plotsetting[1],plotsetting[2]

  int[] portcount = {0,0,0,0,0,0};// maximum ports,are ports available?, loop to print 
  int[] serialsetting = {1000,0,0,0,0,0,0,0,0,0,0,0,0};/// serial setting to load / save
  
  int sendclick;
String dataout = "";
int[] graphic = {0,0,0,0};// x begin, graph x size, y begin, graph y size
String[] savestring = new String[1];////string save list, buffer
String savestring2 = "";
int savestringvar = 0;///switching between strings
String[] loaddata = new String[100000];/// load data string buffer
int loaddatavar = 0;/// switching between strings
int loadsettingfromfile = 0;

  void draw(){
    if ( load == 1 ){// save settings
    try{saveStrings("/settings/buttonname.txt", Sbuttonname);///  save names
    saveStrings("/settings/varmax.txt", Sbuttonmax);///  save max var
    saveStrings("/settings/varmin.txt", Sbuttonmin);///  save min var
    saveStrings("/settings/plotsettings.txt", str(plotsetting));//
    saveStrings("/settings/serialsetting.txt", str(serialsetting));///  save serial settings
    }catch(Exception NullPointer){}
    
    
    }
  
  
    if (loadsettingfromfile < 5){/// load settings from file
    try{
    if ( loadStrings("/settings/buttonname.txt") != null){name =loadStrings("/settings/buttonname.txt");}else{saveStrings("/settings/buttonname.txt", Sbuttonname);}///  save names
    if (  parseFloat(loadStrings("/settings/varmax.txt")) != null){ max = parseFloat(loadStrings("/settings/varmax.txt")) ;}else{ saveStrings("/settings/varmax.txt", str(max));}///  save max var
    if ( parseFloat(loadStrings("/settings/varmin.txt")) != null){min = parseFloat(loadStrings("/settings/varmin.txt")) ;}else{ saveStrings("/settings/varmin.txt", str(min));}///  save min var
    if (  parseFloat(loadStrings("/settings/plotsettings.txt")) != null){plotsetting =  parseFloat(loadStrings("/settings/plotsettings.txt")) ;}else{saveStrings("/settings/plotsettings.txt", str(plotsetting));}///// load bgcoolor, gridsize, plot thickness, 
    if ( loadStrings("/settings/plotsettings.txt") != null){ eSetting = loadStrings("/settings/plotsettings.txt") ;}else{saveStrings("/settings/serialsetting.txt", str(serialsetting));}///  save serial settings/// load bgcoolor, gridsize, plot thickness, 
    if ( parseInt(loadStrings("/settings/serialsetting.txt")) != null){ serialsetting = parseInt(loadStrings("/settings/serialsetting.txt"));}///serialsetting ==>>  port, baud 
    
    loadsettingfromfile++;
    defscale[0] = max[0];
    defscale[1] = min[0];
    defscale[2] = max[21];
    defscale[3] = min[21];
    
    selectedportnumber = parseInt(serialsetting[0]);selectedport = Serial.list()[selectedportnumber];
    serialbuttonlast[0] = selectedportnumber; serialbutton[selectedportnumber] = 1;
    baudcustom = str(serialsetting[2]); baudbutton[serialsetting[3]] = 1; baudbuttonlast[0] = serialsetting[3];
    selectedbaud = parseInt(serialsetting[1]);
    
    if (loadsettingfromfile == 3){loadport();}/// initialize comport from settings
    
    }catch(Exception NullPointer){/// if file doesnt exist creat it

    loadfromfile = 100;
    
    }
    
    }
    
    if ( savestringvar > 1 && capturedata == 0){/// save strings to text file
       savestringvar = 0;
       saveStrings("coordinates.txt", trim(savestring));///  data in capture data string
       savestring = new String[1];
       println("done saving");

    }
  
  if ( capturedata == 1 && plot_on == 1){///// save data to string when unpressed ==> sve to txt file.
//serialsave.println(incomedata[0]);

savestring2 = incomedata[0];
try{  savestring = append(savestring, savestring2);savestringvar++;} catch(Exception NullPointer){println("ERROR to save string", savestringvar);startplot[4+10] = 0;}

//println(savestringvar);

}
  

   
    
    
    
    
    
   // if ( fullscreen == 0){displaywidth = 1200;displayheight = 700;}////else{displaywidth = displayWidth;displayheight = displayHeight;size(displayWidth, displayHeight);}((fullscreen))

    graphic[0] =(displaywidth*500/10000);
    graphic[1] =(displaywidth*6589/10000);
    graphic[2] = displayheight-(displayheight*300/10000);
    graphic[3] = 140; 
    
    
      //top bar
  strokeWeight(0);
  fill(0, 14, 255);
  rect(0,0, displaywidth,30);
  //fill(255,0,0);
  //rect(displaywidth-(displaywidth*220/10000), 0, 30,30);
  fill(255,255,255);
  textSize(40);
  //text("X", displaywidth-(displaywidth*190/10000), 30);textSize(30);fill(255,0,0);
  textSize(20);fill(255);
  text("COM PORT:"+selectedport, graphic[0], 20);text("BAUD RATE:"+selectedbaud, 250, 20);
  fill(255,0,0);text("SERIAL-PLOT", 500, 17);textSize(13);text("By MANUEL ROJAS", 505,28);// CREATOR NAME ==> Manuel Rojas NODOOD@HOTMAIL.COM
  //if (mouseX >= displaywidth-(displaywidth*320/10000) && mouseX <= displaywidth && mouseY >= 0 && mouseY <= 30){if (mousePressed && (mouseButton == LEFT)){if (port_on == 1){Port.stop();}exit();}}
textSize(20);
  
  // display values
if ( setting == 0 && plot_on == 1){ // do not do while setting
textSize(20);
noStroke();
fill(204);
textAlign(LEFT);
rect(0,30, displaywidth, 47);
fill(0,0,0);
text(name[1]+": "+value[1], graphic[0],50);
text(name[2]+": "+value[2], graphic[0]+190*1,50);
text(name[3]+": "+value[3], graphic[0]+190*2,50);
text(name[4]+": "+value[4], graphic[0]+190*3,50);
text(name[5]+": "+value[5], graphic[0]+190*4,50);
text(name[6]+": "+value[6], graphic[0],75);
text(name[7]+": "+value[7], graphic[0]+190*1,75);
text(name[8]+": "+value[8], graphic[0]+190*2,75);
text(name[9]+": "+value[9], graphic[0]+190*3,75);
text(name[10]+": "+value[10], graphic[0]+190*4,75);


}
if (setting == 1){/// SERIAL por settings\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
  // stop Serial first.
  Settings(0, graphic[0], 40, graphic[1],80);// Settings block

  try{
   if ( Serial.list()[portcount[0]].length() > 2){
     port[portcount[0]] = Serial.list()[portcount[0]];
     portcount[1] = 1;// indicate thats ports are available
     portcount[0]++;//  
 }  
  }
  catch(Exception Serial){portcount[1] = 0;/// close the printing part until port is available
  portcount[0] = 0;// reset counting
}
  
  if (portcount[1] == 1){// got sign that ports are available,lets print
  
    // do the thing
    serialport(portcount[2], graphic[0], 70, 100, 30, port[portcount[2]]);
    portcount[2]++;
  }else{portcount[2] = 0;}

  
  // baud rate
  baudrate(0, graphic[0], 100, (displaywidth*659/10000), 30, 4800 );
  baudrate(1, graphic[0], 100, (displaywidth*659/10000), 30, 9600 );
  baudrate(2, graphic[0], 100, (displaywidth*659/10000), 30, 19200 );
  baudrate(3, graphic[0], 100, (displaywidth*659/10000), 30, 38400 );
  baudrate(4, graphic[0], 100, (displaywidth*659/10000), 30, 57600 );
  baudrate(5, graphic[0], 100, (displaywidth*659/10000), 30, 115200 );
  baudrate(6, graphic[0], 100, (displaywidth*659/10000), 30, 230400 );
  baudrate(7, graphic[0], 100, (displaywidth*659/10000), 30, 250000 );
  baudrate(8, graphic[0], 100, (displaywidth*659/10000), 30, 4800 );//// used for custom input
}

if ( plot_on == 1 && loadfromfile == 0 ){
//try {if (Serial.list()[selectedportnumber].length() > 2){portok = 1; }else{portok = 0; plot_on = 0;}}catch(Exception Serial){ portok = 0;}/// check if its safe to read port
 if(newdata == 1){newdata = 0;
   
////////// ready to cut the data income;
 // try{if ( Port.available() > 0){incomedata[0] =  Port.readStringUntil(10);



noStroke();fill(204);textSize(20);textAlign(LEFT);rect(0,82, displaywidth, 25);
    fill(0);text("Data in:"+incomedata[0], graphic[0], 100);

    
try{values = split(incomedata[0], ",");
value[1] = parseFloat(values[0]);
value[2] = parseFloat(values[1]);
value[3] = parseFloat(values[2]);
value[4] = parseFloat(values[3]);
value[5] = parseFloat(values[4]);
value[6] = parseFloat(values[5]);
value[7] = parseFloat(values[6]);
value[8] = parseFloat(values[7]);
value[9] = parseFloat(values[8]);
value[10] = parseFloat(values[9]);

}catch(Exception NullPointer){}//separate at the ,

//} }catch(Exception NUllPointer){fill(255,0,0);textSize(50); text("SERIAL ERROR \n CHECK PORT", graphic[1]/3, graphic[2]/2); startplot[0+10] = 0; plot_on = 0;}  
}






if ( plot_on == 1){///// ready to send data
noStroke();fill(204);textAlign(LEFT);rect(0,103, displaywidth, 26);
fill(0);text("Data out:"+dataout, graphic[0], 125);
if ( mouseX >= graphic[0] && mouseY <= graphic[0]+200 && mouseY >= 135-35 && mouseY <= 135 && mousePressed == true && mouseButton == LEFT){ sendclick = 1;}else{if (mousePressed == true && mouseButton == LEFT){sendclick = 0;}}
if (key == ENTER && keyvar[0] == 0 && sendclick == 1){ Port.write(dataout); dataout = ""; keyvar[0] = 1;}/////// default line ending with cariage return ( CR ):.....+13
if (sendclick == 1){
    noStroke();fill(255,0,0);rect(graphic[0],125, 100, 3);
   
     /// get ready to enter data from keyboard
    if (key > 0 && keyvar[0] == 0 && key != BACKSPACE && key != ENTER){
      dataout += key; keyvar[0] = 1; 
    }
    if ( key == BACKSPACE && dataout.length() > 0 && keyvar[0] == 0){
      dataout = dataout.substring(0, dataout.length()-1);keyvar[0] = 1;
    }
    
  } 


}
  }


if ( plot_on == 1 && loadfromfile == 1){/// load from captured file
 if (loaddatavar < 2){loaddata = loadStrings("coordinates.txt");println(" data loaded");}
if (loaddatavar < loaddata.length ){ incomedata[0] = loaddata[loaddatavar]; loaddatavar++;}else{startplot[5+10] = 0; loaddatavar = 0; startplot[0+10] = 0;}/// load till buffer max, reset loaddatavar and loadfromfile button
  //if (incomedata[0].equals("null") == true){loaddatavar = 0; startplot[5+10] = 0; plot_on = 0;}
 // else{/// if null is not found keep reading
try{values = split(incomedata[0], ",");
value[1] = parseFloat(values[0]);
value[2] = parseFloat(values[1]);
value[3] = parseFloat(values[2]);
value[4] = parseFloat(values[3]);
value[5] = parseFloat(values[4]);
value[6] = parseFloat(values[5]);
value[7] = parseFloat(values[6]);
value[8] = parseFloat(values[7]);
value[9] = parseFloat(values[8]);
value[10] = parseFloat(values[9]);} catch(Exception ArrayIndexOutofBounds){}

//}

noStroke();fill(204);textAlign(LEFT);rect(0,82, displaywidth, 25);
    fill(0);text("Data in from file:"+incomedata[0], graphic[0], 100);

}




if (setting == 1){
 
eSettings( 0, graphic[0]+graphic[1]-250, graphic[3], 230, 20, "Bg color:");
eSettings( 1, graphic[0]+graphic[1]-250, graphic[3]+25, 230, 20, "Grid size:");
eSettings( 2, graphic[0]+graphic[1]-250, graphic[3]+25+25, 230, 20, "Plot thickness:");

}
  


fill(255);
/*// debug coord
textSize(20);
rect(400, 55, 150, 30);
fill(0);
text(mouseX+"    "+mouseY, 400,80);
*/

    
    
  /// Variables text
  if (variabletextprint < 1){variabletextprint++;/// make Sure that it doesnt reprint over and over, only print only on startup
  textAlign(LEFT);
  fill(204);noStroke();rect(displaywidth-(displaywidth*2195/10000), graphic[3]+40, 235, 100);
  fill(0);textSize(30);text("Variables", displaywidth-(displaywidth*1757/10000), 210);
   textSize(15); text("X-Coordinate", displaywidth-(displaywidth*2196/10000), 250);text("Y-Coordinate",displaywidth- (displaywidth*1098/10000), 250);
  }
    
  //  float sint = 11000*sin(3.14*(millis()))*sin(3.14*(millis()))*sin(3.14*(millis()));
  ///  float cost = 9000*cos(3.14*(millis()))-3400*cos(3.14*(millis())*2)-1375*cos(3.14*(millis())*3)-cos(3.14*(millis())*4);

  

     
        button2(0, (displaywidth*2196/10000), 140, 100, 30, 20);/// start / stop plot
        button2(1, (displaywidth*1098/10000), 140, 100, 30, 20);/// reset
        button2(2, (displaywidth*1123/10000), 0, 100, 30, 20);// settings button
        ///button2(3, (displaywidth*250/10000), 0, 30, 30, 20);// fullscreen button
        button2(4, (displaywidth*2415/10000), 0, 150, 30, 20);// capture button
        button2(5, (displaywidth*3715/10000), 0, 150, 30, 20);// load from file button
        button2(6, (displaywidth*250/10000), 0, 30, 30, 20);// screenshot button
        button2(7, (displaywidth*4090/10000), 0, 40, 30, 20);// connect dot
        
  
   
   //x axis button 
   button(0,0,(displaywidth*2196/10000),290,100,30, name[1],value[1],max[1],min[1],15, 0,plotsetting[2]);
   button(0,1,(displaywidth*2196/10000),330,100,30, name[2],value[2],max[2],min[2],15, 0,plotsetting[2]);
   button(0,2,(displaywidth*2196/10000),370,100,30, name[3],value[3],max[3],min[3],15, 0,plotsetting[2]);
   button(0,3,(displaywidth*2196/10000),410,100,30, name[4],value[4],max[4],min[4],15, 0,plotsetting[2]);
   button(0,4,(displaywidth*2196/10000),450,100,30, name[5],value[5],max[5],min[5],15, 0,plotsetting[2]);
   button(0,5,(displaywidth*2196/10000),490,100,30, name[6],value[6],max[6],min[6],15, 0,plotsetting[2]);
   button(0,6,(displaywidth*2196/10000),530,100,30, name[7],value[7],max[7],min[7],15, 0,plotsetting[2]);
   button(0,7,(displaywidth*2196/10000),570,100,30, name[8],value[8],max[8],min[8],15, 0,plotsetting[2]);
   button(0,8,(displaywidth*2196/10000),610,100,30, name[9],value[9],max[9],min[9],15, 0,plotsetting[2]);
   button(0,9,(displaywidth*2196/10000),650,100,30, name[10],value[10],max[10],min[10],15, 0,plotsetting[2]);

   
   // y axis button 
   button(1,10,(displaywidth*1098/10000),290,100,30, name[1],value[1],max[1],min[1],15, 0,plotsetting[2]);
   button(1,11,(displaywidth*1098/10000),330,100,30, name[2],value[2],max[2],min[2],15, 0,plotsetting[2]);
   button(1,12,(displaywidth*1098/10000),370,100,30, name[3],value[3],max[3],min[3],15, 0,plotsetting[2]);
   button(1,13,(displaywidth*1098/10000),410,100,30, name[4],value[4],max[4],min[4],15, 0,plotsetting[2]);
   button(1,14,(displaywidth*1098/10000),450,100,30, name[5],value[5],max[5],min[5],15, 0,plotsetting[2]);
   button(1,15,(displaywidth*1098/10000),490,100,30, name[6],value[6],max[6],min[6],15, 0,plotsetting[2]);
   button(1,16,(displaywidth*1098/10000),530,100,30, name[7],value[7],max[7],min[7],15, 0,plotsetting[2]);
   button(1,17,(displaywidth*1098/10000),570,100,30, name[8],value[8],max[8],min[8],15, 0,plotsetting[2]);
   button(1,18,(displaywidth*1098/10000),610,100,30, name[9],value[9],max[9],min[9],15, 0,plotsetting[2]);
   button(1,19,(displaywidth*1098/10000),650,100,30, name[10],value[10],max[10],min[10],15, 0,plotsetting[2]);
  
  
  

   Settings(0, graphic[0], graphic[3], graphic[1],graphic[2]-graphic[3]);// Settings block
   
    
    Settingtext(0, graphic[0]+10, graphic[3]+(displayheight*651/10000), 200, 40, "Multiplot", 20, 0);// defaultplot
    Settingtext(1, graphic[0]+10, graphic[3]+10+(displayheight*651/10000)*2, 200, 40, "X|Y 1", 20, 0);
    Settingtext(2, graphic[0]+10, graphic[3]+10+(displayheight*651/10000)*3, 200, 40, "X|Y 2", 20, 0);
    Settingtext(3, graphic[0]+10, graphic[3]+10+(displayheight*651/10000)*4, 200, 40, "X|Y 3", 20, 0);
    Settingtext(4, graphic[0]+10, graphic[3]+10+(displayheight*651/10000)*5, 200, 40, "X|Y 4", 20, 0);
    Settingtext(5, graphic[0]+10, graphic[3]+10+(displayheight*651/10000)*6, 200, 40, "X|Y 5", 20, 0);
    Settingtext(6, graphic[0]+10, graphic[3]+10+(displayheight*651/10000)*7, 200, 40, "X|Y 6", 20, 0);
    Settingtext(7, graphic[0]+10, graphic[3]+10+(displayheight*651/10000)*8, 200, 40, "X|Y 7", 20, 0);
    Settingtext(8, graphic[0]+10, graphic[3]+10+(displayheight*651/10000)*9, 200, 40, "X|Y 8", 20, 0);
    Settingtext(9, graphic[0]+10, graphic[3]+10+(displayheight*651/10000)*10, 200, 40,"X|Y 9", 20, 0);
    Settingtext(10, graphic[0]+10, graphic[3]+10+(displayheight*651/10000)*11, 200, 40,"X|Y 10", 20, 0);

//////////////////// fix the variables on height change.... and also the baud port on height change    
    
 
    
  }
  
  

  int[] buttonpressnr = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,};//button pressing var
  int[] buttonpressed = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};// variable that switches upon pressing states press if 1
  int[] xplotnumber = {-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};// xplot number
  int[] yplotnumber = {-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};// plot number
  float[] xcoordinate = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};// x coordinate buffer
  float[] ycoordinate = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};// x coordinate buffer
  int[] plotcolor = {#FF0307,#B200FF, #0EFF03, #E1FF03, #03E4FF  ,#FC03EC,#038EFC, #B5FC03, #FC9103,0,0,0,0,0,0};//plot color buffer
  float x_axis = -10000, y_axis = -10000 ;// x, y coord to draw x, y axis// begin of axis/location of axis
  int[] displaycoordinate = {278, 255};// display coordinate , refresh coordinate color
  int[] printini = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};// print initial used to prevend draw on no new data
  float[] lines = {0,0,0,0,0,0,0};// vertical lines, horizontal lines
  int[] connectdot = {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1};///first is to indicate on/off, others are to be used in the oldx/y coord to prevent from writen a new coord to the old coord b4 printing them first.
  float[] oldxcoord = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};// old xcoord before new one
  float[] oldycoord = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};// old xcoord before new one
  void button(int axis,int bnumber, int xpos, int ypos, int xsize, int ysize, String variablename, float variablevalue,float variable_max,float variable_min, int textsize, int textcolor, float pointsize){//axis 0 for x axis 1 for y axis
    //int[] graphic = {50, 900, displayheight-(displaywidth*366/10000), 140};// x begin, y begin, x end, y end
    if (reset == 1 ){ printini[0] = 0;connectdot[1] = 1;ycoordinate[yplotnumber[bnumber+1]] = 0 ;xcoordinate[xplotnumber[bnumber+1]] = 0;xplotnumber[0] = -1;yplotnumber[0] = -1;buttonpressed[bnumber] = 0;buttonpressnr[bnumber] = 0;lines[0] = 0;lines[2] = 0;lines[3] = 0; lines[1] = 0;noStroke();fill(plotsetting[0]); rect(0, graphic[3],displaywidth-(displaywidth*2196/10000),displayheight-graphic[3]);drawaxis[0] = 0; drawaxis[1] = 0; drawaxis[2] = 0;drawaxis[3] = 0;}//reset plot background}// reset
    if ( mouseX > displaywidth-xpos && mouseX < displaywidth-xpos+xsize && mouseY > ypos && mouseY < ypos+ysize)
    {
      if (mousePressed && mouseButton == LEFT)
      {
        if (buttonpressnr[bnumber] == 0 )
        {
          buttonpressnr[bnumber] = 1;if(buttonpressed[bnumber] == 0)
                                        {
                                          buttonpressed[bnumber] = 1; if (axis == 0)
                                                                        {//if (buttonpressed[10] == 1){buttonpressed[10] = 0; yplotnumber[0]--;}
                                                                           xplotnumber[0]++; xplotnumber[bnumber+1] = xplotnumber[0];
                                                                         }
                                                                        else
                                                                         {
                                                                           if (axis == 1)
                                                                          {
                                                                             yplotnumber[0]++; yplotnumber[bnumber+1] = yplotnumber[0];
                                                                             }
                                                                           }
                                         }
                                       else
                                           {
                                               buttonpressed[bnumber] = 0; if (axis == 0)
                                                                            {
                                                                                xplotnumber[0]--;xcoordinate[xplotnumber[bnumber+1]] = -1;// reset x coordinate 
                                                                            }
                                                                                else
                                                                                {
                                                                                  yplotnumber[0]--;ycoordinate[yplotnumber[bnumber+1]] = -1;// reset y coordinate 
                                                                                }
                                                                         
                                           }
         }
       }
      else
          {
              buttonpressnr[bnumber] = 0;
           }
     }
     
   if ( buttonpressed[bnumber] == 1)// if button is pressed take in valus as coordinates===> mved down
       {
         if ( axis == 0)
           {
             fill(plotcolor[xplotnumber[bnumber+1]]);
           }
         else
         {
           fill(plotcolor[yplotnumber[bnumber+1]]);
         }
       }  
   else
      {
        fill(#3C03FF);
      }
if (buttonpressnr[bnumber] == 1 || printini[0] < 50 ){// make sure to only print on click button, load the 30 buttons
    //paint button/'''''''''''''''''''''''''''''''dcdockdc================>>>>>>>>>>>>>>>>>> have to add scale for 1 graph and more than one
    if ( printini[0] < 21 ){ printini[0]++;}else{printini[0]= 0;}// initial print
    noStroke();
    rect(displaywidth-xpos, ypos, xsize, ysize);
    stroke(0);
    textSize(textsize);
    fill(textcolor);
    textAlign(CENTER);
    text(variablename, displaywidth-xpos, ypos+(ysize/6), xsize, ysize );
    
}
if ( axis == 0){// make sure that a variable is used in one axis only   , tis is for th y axis
  if (buttonpressed[bnumber] == 1 && buttonpressed[bnumber+10] == 1){
    buttonpressed[bnumber+10] = 0; yplotnumber[0]--;
  }  
}

if ( axis == 1){// make sure that a variable is used in one axis only   , tis is for th y axis
  if (buttonpressed[bnumber] == 1 && buttonpressed[bnumber-10] == 1){
    buttonpressed[bnumber-10] = 0; xplotnumber[0]--;
  }  
}

//if (buttonpressed[4] == 1 && buttonpressed[15] == 1){
//println(bnumber, xplotnumber[5],xcoordinate[xplotnumber[5]], yplotnumber[16],ycoordinate[yplotnumber[16]] );







  textAlign(LEFT); 
       if (lines[0] == 0){
       ///reset old coordinates buffer for lined graph
       oldycoord[0] = 0; oldxcoord[0] = 0 ;
       oldycoord[1] = 0; oldxcoord[1] = 0 ;
       oldycoord[2] = 0; oldxcoord[2] = 0 ;
       oldycoord[3] = 0; oldxcoord[3] = 0 ;
       oldycoord[4] = 0; oldxcoord[4] = 0 ;
       oldycoord[5] = 0; oldxcoord[5] = 0 ;
       oldycoord[6] = 0; oldxcoord[6] = 0 ;
       oldycoord[7] = 0; oldxcoord[7] = 0 ;
       oldycoord[8] = 0; oldxcoord[8] = 0 ;
       oldycoord[9] = 0; oldxcoord[9] = 0 ;
       oldycoord[10] = 0; oldxcoord[10] = 0 ;
       
       
     }
    
    // draw graph / dot / plot
if (plot_on == 1 && buttonpressed[bnumber] == 1 )
{    
    if(buttonpressed[bnumber] == 1)
      { 
      if (axis == 0){/// x coord
        if ( variablevalue >= 0){float max;
          if (xplotnumber[0] == 0 ){max = variable_max;}else{max = defscale[0];}
          if (variablevalue <= max){
          xcoordinate[xplotnumber[bnumber+1]] = y_axis+((variablevalue*((graphic[0]+graphic[1])-y_axis))/max);
          }
        }
        if (variablevalue < 0){float min;
          if (xplotnumber[0] == 0 ){min = variable_min;}else{min = defscale[1];}
          if (variablevalue >= min){
          xcoordinate[xplotnumber[bnumber+1]] = y_axis-((variablevalue*((y_axis-graphic[0]))/min));
          }
        }
        
      }
        
      }
      if (axis == 1){///y coord
      
      
        
        if ( variablevalue >= 0){float max;
          if (yplotnumber[0] == 0 ){max = variable_max;}else{max = defscale[0];}
          if (variablevalue <= max){
          ycoordinate[yplotnumber[bnumber+1]] =  x_axis-(((x_axis-graphic[3])*variablevalue)/max);
          }
        }
        if (variablevalue < 0){float min;
          if (yplotnumber[0] == 0 ){min = variable_min;}else{min = defscale[1];}
          if (variablevalue >= min){
         ycoordinate[yplotnumber[bnumber+1]] = (((graphic[2]-x_axis)*variablevalue)/min)+x_axis;
          }
        }
      
        
      }
      if ( xplotnumber[0] > 0 && yplotnumber[0] > 0 && axis == 1|| xplotnumber[0] == 0 && yplotnumber[0] == 0  && axis == 1){
        if ( xcoordinate[yplotnumber[bnumber+1]] >= graphic[0] && xcoordinate[yplotnumber[bnumber+1]] <= graphic[0]+graphic[1] && ycoordinate[yplotnumber[bnumber+1]] >= graphic[3] && ycoordinate[yplotnumber[bnumber+1]] <= graphic[2]){
        strokeWeight(pointsize);stroke(plotcolor[yplotnumber[bnumber+1]]);
        if (connectdot[0] == 1){if ( oldxcoord[yplotnumber[bnumber+1]] >= graphic[0] && oldxcoord[yplotnumber[bnumber+1]] <= graphic[0]+graphic[1] && oldycoord[yplotnumber[bnumber+1]] >= graphic[3] && oldycoord[yplotnumber[bnumber+1]] <= graphic[2]){line(oldxcoord[yplotnumber[bnumber+1]], oldycoord[yplotnumber[bnumber+1]], xcoordinate[yplotnumber[bnumber+1]], ycoordinate[yplotnumber[bnumber+1]]);}}
          else{point(xcoordinate[yplotnumber[bnumber+1]], ycoordinate[yplotnumber[bnumber+1]]);}
          oldxcoord[yplotnumber[bnumber+1]] = xcoordinate[yplotnumber[bnumber+1]];  oldycoord[yplotnumber[bnumber+1]] = ycoordinate[yplotnumber[bnumber+1]]; 
        }
      }
      
      if (xplotnumber[0] == 0 && yplotnumber[0] > 0 && axis == 1){//1 xcoord multy ycoord
        xcoordinate[0] = xcoordinate[0];
        xcoordinate[1] = xcoordinate[0];
        xcoordinate[2] = xcoordinate[0];
        xcoordinate[3] = xcoordinate[0];
        xcoordinate[4] = xcoordinate[0];
        xcoordinate[5] = xcoordinate[0];
        xcoordinate[6] = xcoordinate[0];
        xcoordinate[7] = xcoordinate[0];
        xcoordinate[8] = xcoordinate[0];
        xcoordinate[9] = xcoordinate[0];
        if ( xcoordinate[yplotnumber[bnumber+1]] >= graphic[0] && xcoordinate[yplotnumber[bnumber+1]] <= graphic[0]+graphic[1] && ycoordinate[yplotnumber[bnumber+1]] >= graphic[3] && ycoordinate[yplotnumber[bnumber+1]] <= graphic[2]){
        strokeWeight(pointsize);stroke(plotcolor[yplotnumber[bnumber+1]]);
        if (connectdot[0] == 1){if ( oldxcoord[yplotnumber[bnumber+1]] >= graphic[0] && oldxcoord[yplotnumber[bnumber+1]] <= graphic[0]+graphic[1] && oldycoord[yplotnumber[bnumber+1]] >= graphic[3] && oldycoord[yplotnumber[bnumber+1]] <= graphic[2]){line(oldxcoord[yplotnumber[bnumber+1]], oldycoord[yplotnumber[bnumber+1]], xcoordinate[yplotnumber[bnumber+1]], ycoordinate[yplotnumber[bnumber+1]]);}}
        else{point(xcoordinate[yplotnumber[bnumber+1]], ycoordinate[yplotnumber[bnumber+1]]);}
         oldxcoord[yplotnumber[bnumber+1]] = xcoordinate[yplotnumber[bnumber+1]];  oldycoord[yplotnumber[bnumber+1]] = ycoordinate[yplotnumber[bnumber+1]]; 
         
        }
      }
      
      if (yplotnumber[0] == 0 && xplotnumber[0] > 0 && axis == 0){///// one ycoord multi xcoord
        ycoordinate[0] = ycoordinate[0];
        ycoordinate[1] = ycoordinate[0];
        ycoordinate[2] = ycoordinate[0];
        ycoordinate[3] = ycoordinate[0];
        ycoordinate[4] = ycoordinate[0];
        ycoordinate[5] = ycoordinate[0];
        ycoordinate[6] = ycoordinate[0];
        ycoordinate[7] = ycoordinate[0];
        ycoordinate[8] = ycoordinate[0];
        ycoordinate[9] = ycoordinate[0]; 
        if ( xcoordinate[yplotnumber[bnumber+1]] >= graphic[0] && xcoordinate[yplotnumber[bnumber+1]] <= graphic[0]+graphic[1] && ycoordinate[yplotnumber[bnumber+1]] >= graphic[3] && ycoordinate[yplotnumber[bnumber+1]] <= graphic[2]){
        strokeWeight(pointsize);stroke(plotcolor[xplotnumber[bnumber+1]]); 
        if (connectdot[0] == 1){if ( oldxcoord[xplotnumber[bnumber+1]] >= graphic[0] && oldxcoord[xplotnumber[bnumber+1]] <= graphic[0]+graphic[1] && oldycoord[xplotnumber[bnumber+1]] >= graphic[3] && oldycoord[xplotnumber[bnumber+1]] <= graphic[2]){line(oldxcoord[xplotnumber[bnumber+1]], oldycoord[xplotnumber[bnumber+1]], xcoordinate[xplotnumber[bnumber+1]], ycoordinate[xplotnumber[bnumber+1]]);}}
          else{point(xcoordinate[xplotnumber[bnumber+1]], ycoordinate[xplotnumber[bnumber+1]]);}
          oldxcoord[xplotnumber[bnumber+1]] = xcoordinate[xplotnumber[bnumber+1]];  oldycoord[xplotnumber[bnumber+1]] = ycoordinate[xplotnumber[bnumber+1]];
        }
      }
    
    
    
    
    
    
    
    // display coordinates
    if ( xplotnumber[0] == 0 && yplotnumber[0] == 0  && buttonpressed[bnumber] == 1)
    { 
      if (mouseX >= graphic[0] && mouseX <= graphic[1]+graphic[0] && mouseY >= graphic[3] && mouseY <= graphic[2] && mousePressed && mouseButton == LEFT  && buttonpressed[bnumber] == 1)
        {
          //int[] plotsize = { graphic[1], graphic[2]-graphic[3]};// x,y size in px
          
          if (axis == 0)
          {// x coordinate formula
            noStroke();fill(204);rect(displaywidth-xpos, displaycoordinate[1], (displaywidth*1098/10000), 30); textSize(textsize+15);fill(0);
            if ( mouseX >= y_axis)
              {// x coord formula + values
               float xcoord =(variable_max*1.0*(mouseX-y_axis))/((graphic[1]+graphic[0])-y_axis);
               textSize(20);
                text(xcoord, displaywidth-xpos, displaycoordinate[0]);
              }
              else
              {// x coord formula - values
                float xcoord = (variable_min*1.0*(y_axis-mouseX))/(y_axis-graphic[0]);  
                textSize(20);
                text(xcoord, displaywidth-xpos, displaycoordinate[0]);
              }
          }
          else
          {//y coordinate formula
            noStroke();fill(204);rect(displaywidth-(displaywidth*1098/10000), displaycoordinate[1], (displaywidth*1098/10000), 30); textSize(textsize+15);fill(0);
            if ( mouseY <= x_axis)
              {// y coord formula + values
                float ycoord = (variable_max*1.0*(x_axis-mouseY))/(x_axis-graphic[3]);
                textSize(20);
                text(ycoord, displaywidth-(displaywidth*1098/10000), displaycoordinate[0]);
              }
             else
              {// y coord formula - values
                float ycoord = (variable_min*1.0*(mouseY-x_axis))/(graphic[2]-x_axis);
                textSize(20);
                text(ycoord, displaywidth-(displaywidth*1098/10000), displaycoordinate[0]);
              }
          }
        }
    }
    if ( xplotnumber[0] > 0 && yplotnumber[0] > 0 && buttonpressed[bnumber] == 1 || xplotnumber[0] == 0 && yplotnumber[0] > 0 && buttonpressed[bnumber] == 1 || xplotnumber[0] > 0 && yplotnumber[0] == 0 && buttonpressed[bnumber] == 1)
    {// default scale coordinate formula
      if (mouseX >= graphic[0] && mouseX <= graphic[1]+graphic[0] && mouseY >= graphic[3] && mouseY <= graphic[2] && mousePressed && mouseButton == LEFT)
        {//xcoord
          noStroke();fill(204);rect(displaywidth-xpos, displaycoordinate[1], (displaywidth*1098/10000), 30); textSize(textsize+15);fill(0);
            if ( mouseX > y_axis)
              {// x coord + values
               float xcoord =(defscale[0]*1.0*(mouseX-y_axis))/((graphic[1]+graphic[0])-y_axis);
               textSize(20);
                text(xcoord, displaywidth-xpos, displaycoordinate[0]);
              }
              else
              {// x coord - values
                float xcoord = (defscale[1]*1.0*(y_axis-mouseX))/(y_axis-graphic[0]); 
                textSize(20);
                text(xcoord, displaywidth-xpos, displaycoordinate[0]);
              }
          
          //ycoord
          noStroke();fill(204);rect(displaywidth-(displaywidth*1098/10000), displaycoordinate[1], (displaywidth*1098/10000), 30); textSize(textsize+15);fill(0);
            if ( mouseY <= x_axis)
              {// y coord + values
                float ycoord = (defscale[2]*1.0*(x_axis-mouseY))/(x_axis-graphic[3]);
                textSize(20);
                text(ycoord, displaywidth-(displaywidth*1098/10000), displaycoordinate[0]);
              }
             else
              {// y coord - values
                float ycoord = (defscale[3]*1.0*(mouseY-x_axis))/(graphic[2]-x_axis);
                textSize(20);
                text(ycoord, displaywidth-(displaywidth*1098/10000), displaycoordinate[0]);
              }
          }
          
         
        
    }

  // draw axis
  if (xplotnumber[0] == -1){drawaxis[0] = 1;drawaxis[1] = 0;}if (yplotnumber[0] == -1){drawaxis[0] = 1;drawaxis[2] = 0;}// reset axis on no x/yplotnumber
  if (xplotnumber[0] == 0 && yplotnumber[0] > 0 && drawaxis[3] == 0 && drawaxis[0] == 0 || xplotnumber[0] > 0 && yplotnumber[0] == 0 && drawaxis[3] == 0 && drawaxis[0] == 0 || xplotnumber[0] == 0 && yplotnumber[0] > 0 && drawaxis[3] == 0 && drawaxis[0] == 2 || xplotnumber[0] > 0 && yplotnumber[0] == 0 && drawaxis[0] == 2 && drawaxis[1] == 1 ){drawaxis[3] = 1; drawaxis[0] = 0;}
  
  
  if ( drawaxis[0] == 0 && drawaxis[3] == 1 && xplotnumber[0] == 0 && yplotnumber[0] > 0 || drawaxis[0] == 0 && drawaxis[3] == 1 && xplotnumber[0] > 0 && yplotnumber[0] == 0 || drawaxis[0] == 1 && xplotnumber[0] > 0 && yplotnumber[0] > 0)
      {
        lines[0] = 0;lines[2] = 0;lines[3] = 0; lines[1] = 0;noStroke();fill(plotsetting[0]); rect(0, graphic[3],displaywidth-(displaywidth*2196/10000),displayheight-graphic[3]);
        //int[] plotsize = { graphic[1], graphic[2]-graphic[3]};// x , y size in pixels
        x_axis = (((graphic[2]-graphic[3])*defscale[2])*1.0/(defscale[2]-defscale[3]))+graphic[3] ;//(((graphic[2]-graphic[3])*defscale[0]) / (defscale[0]-defscale[1])) + graphic[3];
        y_axis = ((-1*graphic[1]*defscale[1]*1.0) / (defscale[0]-defscale[1]))+graphic[0];
        noStroke();fill(255,0,0);
        rect(graphic[0], x_axis,graphic[1], axisthickness);// draw exis x///// the y values define the x axis
        rect(graphic[0], x_axis-axisthickness,graphic[1], axisthickness);// draw exis x in other directiion///// the y values define the x axis
        rect( y_axis,graphic[3] , axisthickness, graphic[2]-graphic[3]); // draw axis y  ///// the x values define the y axis
        rect( y_axis,graphic[3] , -axisthickness, graphic[2]-graphic[3]); // draw axis y, in other direction  ///// the x values define the y axis
        drawaxis[0]++;        drawaxis[1] = 0;        drawaxis[2] = 0; drawaxis[3]= 0;
       
        
      }
  if (xplotnumber[0] == 0 && yplotnumber[0] == 0 && axis == 1 && drawaxis[1] == 0  && buttonpressed[bnumber] == 1)///// the y values define the x axis
    {
     
      lines[0] = 0;lines[2] = 0;lines[3] = 0; lines[1] = 0;noStroke();fill(plotsetting[0]); rect(0, graphic[3],displaywidth-(displaywidth*2196/10000),displayheight-graphic[3]);
      //int[] plotsize = { graphic[1], graphic[2]-graphic[3]};// x , y size in pixels
      x_axis = (((graphic[2]-graphic[3])*variable_max*1.0)/(variable_max-variable_min))+graphic[3];              
      noStroke();fill(255,0,0);
      rect(graphic[0], x_axis,graphic[1], axisthickness);// draw exis x
      rect(graphic[0], x_axis,graphic[1], -axisthickness);// draw exis x
      drawaxis[1] = 1; drawaxis[0] = 0;
      
    }
   if (yplotnumber[0] == 0 && xplotnumber[0] == 0 && axis == 0 && drawaxis[2] < 10  && buttonpressed[bnumber] == 1 )///// the x values define the y axis
     {
       lines[0] = 0;lines[2] = 0;lines[3] = 0; lines[1] = 0;noStroke();fill(plotsetting[0]); rect(0, graphic[3],displaywidth-(displaywidth*2196/10000),displayheight-graphic[3]);
       //int[] plotsize = { graphic[1], graphic[2]-graphic[3]};// x , y size in pixels
       y_axis = (-1*(graphic[1]*variable_min*1.0)/(variable_max-variable_min))+graphic[0];                       
        noStroke();fill(255,0,0);
       rect( y_axis,graphic[3] , axisthickness, graphic[2]-graphic[3]); // draw axis y
       rect( y_axis,graphic[3] , -axisthickness, graphic[2]-graphic[3]); // draw axis y
       drawaxis[2]++; drawaxis[0] = 0;
      

     }
     
    if ( drawaxis[0] > 0 && drawaxis[1] == 0 && drawaxis[2] == 0 && yplotnumber[0] == 0 && xplotnumber[0] == 0){  lines[0] = 0;lines[2] = 0;lines[3] = 0; noStroke();fill(plotsetting[0]); rect(graphic[0], graphic[3],graphic[1],graphic[2]-graphic[3]);}//reset plot background
     
 

  
  
  
  
  
  
  
  // draw grid
  if (yplotnumber[0] > -1 && xplotnumber[0] > -1  && buttonpressed[bnumber] == 1 ){
    if (axis == 0 && buttonpressed[bnumber] == 1 && x_axis > 0 && y_axis > 0 ){ 
      if( y_axis+lines[0] < graphic[1]+graphic[0] && buttonpressed[bnumber] == 1 && plot_on == 1 ){// + gridlines vertical
      float s;///used to switch between one plot atm and multiplot
     if ( xplotnumber[0] > 0 ){ s = defscale[0];}else{s = variable_max;}
       stroke(0);
       strokeWeight(0);
       line(y_axis+lines[0], graphic[2],y_axis+lines[0],graphic[3]);// vertical lines
       lines[0] +=(((graphic[0]+graphic[1]-y_axis)*plotsetting[1])/s);
        noStroke();fill(204);rect(graphic[0]+graphic[1], graphic[3], 75, graphic[2]-graphic[3]);/// display max x value
       fill(0);textSize(15);text(s,graphic[0]+graphic[1], x_axis);
     }
    
     
     if( y_axis-lines[2] > graphic[0] && buttonpressed[bnumber] == 1 && plot_on == 1){// - gridlines vertical
     float s;///used to switch between one plot atm and multiplot
     if ( xplotnumber[0] > 0 ){ s = defscale[1];}else{s = variable_min;}
       stroke(0);
       strokeWeight(0);
       line(y_axis-lines[2], graphic[2],y_axis-lines[2],graphic[3]);// vertical lines
       lines[2] += -1*(((y_axis-graphic[0])*plotsetting[1])/s);
        noStroke();fill(204);rect(graphic[0]-graphic[0], graphic[3], graphic[0], graphic[2]-graphic[3]);/// display min x value
        fill(0);textSize(15);text(s,0, x_axis);
     }}
     
     if (axis == 1 && buttonpressed[bnumber] == 1 && x_axis > 0 && y_axis > 0){ 
     if(x_axis-lines[1] > graphic[3] && buttonpressed[bnumber] == 1 && plot_on == 1 ){// + gridlines hrizontal
    float s;///used to switch between one plot atm and multiplot
     if ( yplotnumber[0] > 0 ){ s = defscale[2];}else{s = variable_max;}
       stroke(0);
       strokeWeight(0);
       line(graphic[0], x_axis-lines[1], graphic[0]+graphic[1], x_axis-lines[1] );// vertical lines
       lines[1] += ((x_axis-graphic[3])*plotsetting[1]/s);
       noStroke();fill(204);rect(graphic[0]-graphic[0], graphic[3], graphic[0]+graphic[1], -12);/// display max y value
       textAlign(CENTER);
       fill(0);textSize(15);text(s,y_axis, graphic[3], 150);
       textAlign(LEFT);
     }
     
     if(x_axis+lines[3] < graphic[2] && buttonpressed[bnumber] == 1 && plot_on == 1 ){// + gridlines h0rizontal
     float s;///used to switch between one plot atm and multiplot
     if ( yplotnumber[0] > 0 ){ s = defscale[3];}else{s = variable_min;}
       stroke(0);strokeWeight(0);
       line(graphic[0], x_axis+lines[3], graphic[0]+graphic[1], x_axis+lines[3] );// -horizontal lines
       lines[3] += -1*(((graphic[2]-x_axis)*plotsetting[1])/s); 
       noStroke();fill(204);rect(graphic[0]-graphic[0], graphic[2], graphic[0]+graphic[1], 12);/// display min y value
       textAlign(CENTER);
        fill(0);textSize(15);text(s,y_axis, graphic[2]+10, 150);
        textAlign(LEFT);
        
     }}
   
     }
}
     
      

    
    
  }
  
  
  
  
  
  int[] startplot = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};// startplot buffer
  int plot_on = 0;// plot on / off
  int setting = 0;// setings buton
  int[] fullscreen = {0,0};/// fullscreen 
  int capturedata = 0;// capture income data
  int loadfromfile = 0;/// load variables from files
  int apply = 0;// apply  changes
  void button2(int bnumber, int xpos, int ypos, int xsize, int ysize, int textsize){
   
    if ( mouseX >= displaywidth-xpos && mouseX <= displaywidth-xpos+xsize && mouseY >= ypos && mouseY <= ypos+ysize)
    {
     if (mousePressed && mouseButton == LEFT)
     {       
      
      if(startplot[bnumber] == 0)
      {
       startplot[bnumber] = 1;// button pressed
       if ( startplot[bnumber+10] == 0)
       {
         startplot[bnumber+10] = 1;
       }
       else
       {
         startplot[bnumber+10] = 0;
       }
      }
       
     }
     else
     {
       startplot[bnumber] = 0;
     }          
    }

    /// plot start button 
    if ( bnumber == 0)
    { textAlign(CENTER);
      if (startplot[0+10] == 1)
      {
        startplot[2+10] = 0;// setting reset
        plot_on = 1;/// plot off
        
        noStroke();
        fill(255,0,0);
       rect( displaywidth-xpos, ypos, xsize, ysize);
       fill(0);
       text("STOP", displaywidth-xpos, ypos+(ysize/6), xsize, ysize);
      }
      else
      {
        startplot[4+10] = 0;
        plot_on = 0;
        //startplot[5+10] = 0;// load from file reset
        noStroke();
       fill(255);
       rect( displaywidth-xpos, ypos, xsize, ysize);
       fill(0);
       text("START",displaywidth-xpos, ypos+(ysize/6), xsize, ysize);
      }        
      }
     
     // reset button
     if ( bnumber == 1)
      {textAlign(CENTER);
        if (startplot[bnumber+10] == 1)
        {

       startplot[1+10] = 0;// reset button reset
       startplot[0+10] = 0;// start button reset
       startplot[2+10] = 0;// setting reste  
       startplot[5+10] = 0;// load from file reset
       noStroke();
       fill(255,0,0);
       rect( displaywidth-xpos, ypos, xsize, ysize);
       fill(0);
       text("RESET",displaywidth-xpos, ypos+(ysize/6), xsize, ysize);
       reset = 1;
        }
        else
        {
          reset = 0;
        noStroke();
       fill(255);
       rect( displaywidth-xpos, ypos, xsize, ysize);
       fill(0);
       text("RESET",displaywidth-xpos, ypos+(ysize/6), xsize, ysize);
        }
      }

      
  // Settings button
     if ( bnumber == 2 )
      {
      textAlign(CENTER);
    if (startplot[bnumber+10] == 0)    
     {
       setting = 0;
       noStroke();
       fill(255);
       rect( displaywidth-xpos, ypos, xsize, ysize);
       fill(0);
       text("Settings",displaywidth-xpos, ypos+(ysize/6), xsize, ysize);
       
        }
        else
        {
          setting = 1;
          startplot[0+10] = 0;// start button reset
          plot_on = 0;
          noStroke();
       fill(255,0,0);
       rect( displaywidth-xpos, ypos, xsize, ysize);
       fill(0);
       text("Settings",displaywidth-xpos, ypos+(ysize/6), xsize, ysize);   
        }
      }
      //// fullscreen button
     if ( bnumber == 3){ 
       textAlign(CENTER);
      if (startplot[3+10] == 0)    
     {
       
       noStroke();
       fill(255);
       rect( displaywidth-xpos, ypos, xsize, ysize);
       fill(0);
       text("█",displaywidth-xpos, ypos+(ysize/6), xsize, ysize);
       if ( mouseX >= displaywidth-xpos && mouseX <= displaywidth-xpos+xsize && mouseY >= ypos && mouseY <= ypos+ysize && clicked == 1){
       fullscreen[0] = 0; saveStrings("fullscreen.txt", str(fullscreen));
       exit();
       }
       
        }
        else
        {
         
         startplot[0+10] = 0;// start button reset
          plot_on = 0;
          noStroke();
       fill(255,0,0);
       rect( displaywidth-xpos, ypos, xsize, ysize);
       fill(0);
       text("■",displaywidth-xpos, ypos+(ysize/6), xsize, ysize);
       if ( mouseX >= displaywidth-xpos && mouseX <= displaywidth-xpos+xsize && mouseY >= ypos && mouseY <= ypos+ysize && clicked == 1){ 
         fullscreen[0] = 1; saveStrings("fullscreen.txt", str(fullscreen));
       exit();
         }
        }
     }
     
     /// save to text file
     if ( bnumber == 4 ){
       textAlign(CENTER);
      if (startplot[bnumber+10] == 1 && plot_on == 1)    
     {
        startplot[5+10] = 0;
          capturedata = 1;
          noStroke();
       fill(255,0,0);
       rect( displaywidth-xpos, ypos, xsize, ysize);
       fill(0);
       text("Stop Capture",displaywidth-xpos, ypos+(ysize/6), xsize, ysize);   
       
       
        }
        else
        {
         
       capturedata = 0;
       noStroke();
       fill(255);
       rect( displaywidth-xpos, ypos, xsize, ysize);
       fill(0);
       text("Capture Data",displaywidth-xpos, ypos+(ysize/6), xsize, ysize);
        }
        
     }
     //// load from file
     if ( bnumber == 5){
       textAlign(CENTER);
      if (startplot[bnumber+10] == 0)    
     {
       loadfromfile = 0;loaddatavar = 0;
       noStroke();
       fill(255);
       rect( displaywidth-xpos, ypos, xsize, ysize);
       fill(0);
       text("Load Captured",displaywidth-xpos, ypos+(ysize/6), xsize, ysize);
       
        }
        else
        {
          startplot[4+10] = 0;
          loadfromfile = 1;
          
          noStroke();
       fill(255,0,0);
       rect( displaywidth-xpos, ypos, xsize, ysize);
       fill(0);
       text("Stop load",displaywidth-xpos, ypos+(ysize/6), xsize, ysize);   
        }
     }
     
     
     
      //// fullscreen button
     if ( bnumber == 6){
       textAlign(CENTER);
      if (startplot[bnumber+10] == 0)    
     {    
       noStroke();
       fill(255);
       rect( displaywidth-xpos, ypos, xsize, ysize);
       fill(0);
       text("▒",displaywidth-xpos, ypos+(ysize/6), xsize, ysize);
        }
        else
        {
         
          noStroke();
       fill(255,0,0);
       rect( displaywidth-xpos, ypos, xsize, ysize);
       fill(0);
       text("■",displaywidth-xpos, ypos+(ysize/6), xsize, ysize); 
       if (clicked == 1 ){
       saveFrame("SERIAL-PLOT-#######.png");
       startplot[6+10] = 0;
       clicked = 0;
       }
        }
     }
     
      /// save to text file
     if ( bnumber == 7 ){
      if (startplot[bnumber+10] == 1)    
     {
       connectdot[0] = 1;
      // plotsetting[3] = 1;
          noStroke();
       fill(255,0,0);
       rect( displaywidth-xpos, ypos, xsize, ysize);
       fill(0);
       text("/",displaywidth-xpos, ypos+(ysize/6), xsize, ysize);   
        }
        else
        {
          connectdot[0] = 0;
      // plotsetting[3] = 0;
       noStroke();
       fill(255);
       rect( displaywidth-xpos, ypos, xsize, ysize);
       fill(0);
       text("°",displaywidth-xpos, ypos+(ysize/6), xsize, ysize);
        }
     }
     
      
      
  }
  
  
  
  
  int[] settingvar = {0,0,0,0,0,0,0,0,0,0,0};// setting var to latch
void Settings(int number,int xbegin,int ybegin,int xsize,int ysize){
  
    if (setting == 1)
    {
      settingvar[1] = 0;// ready to drawgrid on onpress
      if ( settingvar[0] <= 2)
      {
        settingvar[0]++;// no more setting reprint
       fill(255);
       noStroke();
       rect(xbegin,ybegin,xsize,ysize);
       
      }          
    }
    else
    {
      if (settingvar[1] < 3){lines[0] = 0;lines[2] = 0;lines[3] = 0; lines[1] = 0;settingvar[1]++;noStroke();fill(204); rect(0,30,xsize+(displaywidth*1220/10000),displayheight);} // draw grid on onpressing button // refresh
     settingvar[0] = 0; 
    }
 
  }
  
  

  int[] keyvar = {0,0,0,0,0};// key variable to notice when key is a new key is typed

  
  
  
  void keyReleased(){
    keyvar[0] = 0;
  }
  int clicked = 0;
  void mouseClicked() {clicked = 1;}///mouse clicked
    
  
 
  int[] Sbuttonnamevar = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};// write min
  String Sbuttonname[] = {"XX","1","2","3","4","5","6","7","8","9","10","","","","X1","X1","X1","X1","X1","X1","X1","X1","X1","X1","","","",""};//name buffer from settings to apply on apply press
  int[] Sbuttonmaxvar = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
  String[] Sbuttonmax = {"","","","","","","","","","","","","","","","","","","","","","","","",};// used for conversion from int to string
  int[] Sbuttonminvar = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
  String[] Sbuttonmin = {"","","","","","","","","","","","","","","","","","","","","","","","",};// used for conversion from int to string
  
 
  
  
  int[] Slast = {0,0,0,0,0,0};// last text to enter , last clicked(name, max, min)// used to reset selection
  int[] d = {200, 40, 3, 30};// distance betwwen text, underline lenght, underline thickness, distance between lines 
  int load = 0; // load the changes
  long loadtime;// time that reset clicked, timer to give time to load new data = time is = 500 millisec
  void Settingtext( int number, int xbegin, int ybegin, int xsize,int ysize, String text,int textsize, int Color){

  
    
    if (setting == 1)
    
    {
      // apply button
      {//int[] plotsize = { graphic[1], graphic[2]-graphic[3]};// x , y size in pixels
        noStroke();fill(255);rect(graphic[0]+graphic[1]/2, graphic[3], 75,30); 
        if (mouseX >= (graphic[0]+graphic[1]/2) && mouseX <= (graphic[0]+graphic[1]/2+75) && mouseY >= graphic[3] && mouseY <= graphic[3]+30 && mousePressed && mouseButton == LEFT){
            fill(255,0,0);
            load = 1;
            loadtime = millis();
        }
        else{
          fill(#1400FF);
        }
        textSize(textsize);
        text("APPLY", graphic[0]+graphic[1]/2, graphic[3]+20);
        noFill();      
      }
      
      {// load
       if (load == 1){
         if(millis()-loadtime >= 500){startplot[1+10] = 1;/* bring reset button  high == reset */load = 0;// 500 millisec after apply close setting     
         }
  
         name[number] = Sbuttonname[number];
         if (Sbuttonmax[number].equals("") == false ){max[number] = parseFloat(Sbuttonmax[number]);}else{max[number] = 0; }if (max[number] < 0){max[number]*=-1;}// max variables
         if (Sbuttonmin[number].equals("") == false ){min[number] = parseFloat(Sbuttonmin[number]);}else{min[number] = 0; }if (min[number] > 0){min[number]*=-1;}// min variables
         
         
         if ( Sbuttonmax[0].equals("") == false ){ defscale[0] = parseFloat(Sbuttonmax[0]);}else{ defscale[0] = 0;} if (defscale[0] < 0){defscale[0]*=-1;}// defscale x max
         if ( Sbuttonmin[0].equals("") == false ){defscale[1] = parseFloat(Sbuttonmin[0]);}else{ defscale[1] = 0;}if (defscale[1] > 0){defscale[1]*=-1;}//defscale x min
         if ( Sbuttonmax[21].equals("") == false ){defscale[2] = parseFloat(Sbuttonmax[21]);}else{ defscale[2] = 0;}if (defscale[2] < 0){defscale[2]*=-1;}// defscale y max
         if ( Sbuttonmin[21].equals("") == false ){defscale[3] = parseFloat(Sbuttonmin[21]);}else{ defscale[3] = 0;}if (defscale[3] > 0){defscale[3]*=-1;}// defscale y min
         
         
         
         
       }
      }
      
      
      {// load new key
      // for the name
      
       if (Sbuttonnamevar[number] == 1 && keyvar[0] == 0){// load var name
       keyvar[0] = 1;
       
       if ( key != BACKSPACE && Sbuttonname[number].length() <= 10){
         Sbuttonname[number] += key;
       }
       else{
         if ( Sbuttonname[number].length()> 0){
          Sbuttonname[number] = Sbuttonname[number].substring(0, Sbuttonname[number].length()-1);
         }
       }      
       }
       
       // load max
       if (Sbuttonmaxvar[number] == 1 && keyvar[0] == 0 ){// load var name,
       keyvar[0] = 1;
       
       if ( keyCode >= 48 && keyCode <= 57  && Sbuttonmax[number].length() <= 10 || keyCode == 45 && Sbuttonmax[number].length() <= 10 || keyCode == 46 && Sbuttonmin[21].length() <= 10){//make sure that they are numbers
         Sbuttonmax[number] += key;
       }
       else{
         if ( key == BACKSPACE && Sbuttonmax[number].length()> 0){
          Sbuttonmax[number] = Sbuttonmax[number].substring(0, Sbuttonmax[number].length()-1);
         }
       }      
       }
       
       // load min
       if (Sbuttonminvar[number] == 1 && keyvar[0] == 0){// load var name, 
       keyvar[0] = 1;
       
       if (  keyCode >= 48 && keyCode <= 57  && Sbuttonmin[number].length() <= 10 || keyCode == 45  && Sbuttonmin[number].length() <= 10 || keyCode == 46 && Sbuttonmin[21].length() <= 10){//make sure that they are numbers
         Sbuttonmin[number] += key;
       }
       else{
         if (key == BACKSPACE &&  Sbuttonmin[number].length()> 0){
          Sbuttonmin[number] = Sbuttonmin[number].substring(0, Sbuttonmin[number].length()-1);
         }
       }      
       }
      ///// extra for multyplot Y max, min var == max,min => buffer 21
       // load max
       if (Sbuttonmaxvar[21] == 1 && keyvar[0] == 0 ){// load var name,
       keyvar[0] = 1;
       
       if ( keyCode >= 48 && keyCode <= 57  && Sbuttonmax[21].length() <= 10|| keyCode == 45 && Sbuttonmax[21].length() <= 10 || keyCode == 46 && Sbuttonmin[21].length() <= 10){//make sure that they are numbers
         Sbuttonmax[21] += key;
       }
       else{
         if ( key == BACKSPACE && Sbuttonmax[21].length()> 0){
          Sbuttonmax[21] = Sbuttonmax[21].substring(0, Sbuttonmax[21].length()-1);
         }
       }      
       }
       
       // load min
       if (Sbuttonminvar[21] == 1 && keyvar[0] == 0){// load var name, 
       keyvar[0] = 1;
       
       if ( keyCode >= 48 && keyCode <= 57 && Sbuttonmin[21].length() <= 10|| keyCode == 45 && Sbuttonmin[21].length() <= 10 || keyCode == 46 && Sbuttonmin[21].length() <= 10){//make sure that they are numbers
         Sbuttonmin[21] += key;
       }
       else{
         if ( key == BACKSPACE && Sbuttonmin[21].length()> 0){
          Sbuttonmin[21] = Sbuttonmin[21].substring(0, Sbuttonmin[21].length()-1);
         }
       }      
       }
       
       
       
       
       
      }
      
      
      
      
    

     
       if (  mouseButton == LEFT ||  settingvar[3] < 23  || keyvar[0] == 0 || Sbuttonnamevar[number] == 1 || Sbuttonmaxvar[number] == 1 || Sbuttonminvar[number] == 1 || Sbuttonmaxvar[21] == 1 || Sbuttonminvar[21] == 1){// print only on these  
      
       if(settingvar[3] < 25 ){settingvar[3]++;}
    fill(Color);
    textSize(textsize);
   if (number == 0)
   { 
        noStroke();fill(255);rect(xbegin,ybegin-20, 450, 60 );//// referesh text
        fill(Color);
        text(text, xbegin,ybegin-d[3]);
        if ( Sbuttonmaxvar[0] == 1 ){noStroke();fill(255,0,0);rect(xbegin+40, ybegin,d[1],d[2]);}/// underline to show selection
        if ( Sbuttonminvar[0] == 1){ noStroke();fill(255,0,0);rect(xbegin+d[0]+40, ybegin,d[1],d[2]);}/// underline to show selection
        if ( Sbuttonmaxvar[21] == 1){ noStroke();fill(255,0,0);rect(xbegin+40, ybegin+30,d[1],d[2]);}/// underline to show selection // for y max on multiplot
        if ( Sbuttonminvar[21] == 1){ noStroke();fill(255,0,0);rect(xbegin+d[0]+40, ybegin+30,d[1],d[2]);}/// underline to show selection  /// for y min on multiplot

      fill(Color);
      
     text("X→ Max: "+Sbuttonmax[number],xbegin, ybegin); text("Min: "+Sbuttonmin[number], xbegin+d[0]+40, ybegin);// only for multiplot
     text("Y→ Max: "+Sbuttonmax[21],xbegin, ybegin+30); text("Min: "+Sbuttonmin[21], xbegin+d[0]+40, ybegin+30);// only for multiplot       /////// multiplot max, min are on 21, 21
    if (mouseX >= xbegin+40 && mouseX <= xbegin+d[0]+40 && mouseY >= ybegin-d[3] && mouseY <= ybegin)
    {
      if(mousePressed && mouseButton == LEFT)
      {
        eSettinglast[0] = -10; Sbuttonmaxvar[Slast[1]] = 0;Sbuttonminvar[Slast[1]] = 0;Sbuttonnamevar[Slast[1]] = 0; Slast[1] = number;Sbuttonmaxvar[21] = 0;Sbuttonminvar[21] = 0;// last max selected// reset, settingvar == to reset background
        Sbuttonmaxvar[number] = 1;       
      }
    }
    if (mouseX >= xbegin+d[0]+40 && mouseX <= xbegin+d[0]*2+40 && mouseY >= ybegin-d[3] && mouseY <= ybegin)
    {
      if(mousePressed && mouseButton == LEFT)
      {
      eSettinglast[0] = -10; Sbuttonmaxvar[Slast[1]] = 0;Sbuttonminvar[Slast[1]] = 0;Sbuttonnamevar[Slast[1]] = 0; Slast[1] = number;Sbuttonmaxvar[21] = 0;Sbuttonminvar[21] = 0;;// last max selected// reset 
        Sbuttonminvar[number] = 1;       
      }
    }
    /// for the 2 extra === y axis min, max
    if (mouseX >= xbegin+40 && mouseX <= xbegin+d[0]+40 && mouseY >= ybegin-d[3]+30 && mouseY <= ybegin+30)
    {
      if(mousePressed && mouseButton == LEFT)
      {
        eSettinglast[0] = -10;  Sbuttonmaxvar[Slast[1]] = 0;Sbuttonminvar[Slast[1]] = 0;Sbuttonnamevar[Slast[1]] = 0; Slast[1] = number;Sbuttonminvar[21] = 0;// last max selected// reset, settingvar == to reset background
        Sbuttonmaxvar[21] = 1;       
      }
    }
    if (mouseX >= xbegin+d[0]+40 && mouseX <= xbegin+d[0]*2+40 && mouseY >= ybegin-d[3]+30 && mouseY <= ybegin+30)
    {
      if(mousePressed && mouseButton == LEFT)
      {
      eSettinglast[0] = -10; Sbuttonmaxvar[Slast[1]] = 0;Sbuttonminvar[Slast[1]] = 0;Sbuttonnamevar[Slast[1]] = 0; Slast[1] = number;Sbuttonmaxvar[21] = 0;// last max selected// reset 
        Sbuttonminvar[21] = 1;       
      }
    }
    
    
      }
      else
      {
        
      
     
       noStroke();fill(255);rect(xbegin,ybegin-20, 730, 25 );//// referesh text 
        
      if ( Sbuttonnamevar[number] == 1){ noStroke();fill(255,0,0);rect(xbegin+75, ybegin,d[1]+20,d[2]);}/// underline to show selection
      if ( Sbuttonmaxvar[number] == 1){ noStroke();fill(255,0,0);rect(xbegin+d[0]+140, ybegin,d[1],d[2]);}/// underline to show selection
      if ( Sbuttonminvar[number] == 1){ noStroke();fill(255,0,0);rect(xbegin+d[0]*2+140, ybegin,d[1],d[2]);}/// underline to show selection
      fill(Color);
       text(text+"→ Name: "+Sbuttonname[number],xbegin, ybegin); text("Max: "+Sbuttonmax[number], xbegin+d[0]+140, ybegin);text("Min: "+Sbuttonmin[number], xbegin+d[0]*2+140, ybegin);// for x en y       
    if (mouseX >= xbegin+75 && mouseX <= xbegin+d[0]+140 && mouseY >= ybegin-d[3] && mouseY <= ybegin)
    {
      if(mousePressed && mouseButton == LEFT)
      {
        eSettinglast[0] = -10; Sbuttonmaxvar[Slast[1]] = 0;Sbuttonminvar[Slast[1]] = 0;Sbuttonnamevar[Slast[1]] = 0; Slast[1] = number;Sbuttonmaxvar[21] = 0;Sbuttonminvar[21] = 0;// last max selected// reset 
        Sbuttonnamevar[number] = 1; Slast[1] = number;      
      }
    }
    if (mouseX >= xbegin+d[0]+140 && mouseX <= xbegin+d[0]*2+140 && mouseY >= ybegin-d[3] && mouseY <= ybegin)
    {
      if(mousePressed && mouseButton == LEFT)
      {
        eSettinglast[0] = -10;  Sbuttonmaxvar[Slast[1]] = 0;Sbuttonminvar[Slast[1]] = 0;Sbuttonnamevar[Slast[1]] = 0; Slast[1] = number;Sbuttonmaxvar[21] = 0;Sbuttonminvar[21] = 0;// last max selected// reset 
        Sbuttonmaxvar[number] = 1; Slast[1] = number;   
      }
    }
     if (mouseX >= xbegin+d[0]*2+140 && mouseX <= xbegin+d[0]*3+140 && mouseY >= ybegin-d[3] && mouseY <= ybegin)
    {
      if(mousePressed && mouseButton == LEFT)
      {
       eSettinglast[0] = -10;  Sbuttonmaxvar[Slast[1]] = 0;Sbuttonminvar[Slast[1]] = 0;Sbuttonnamevar[Slast[1]] = 0; Slast[1] = number;Sbuttonmaxvar[21] = 0;Sbuttonminvar[21] = 0;// last max selected// reset 
        Sbuttonminvar[number] = 1; Slast[1] = number;  
      }
    }  
        
      }
      }
     
    }
      else
      {eSettinglast[0] = -10; Sbuttonmaxvar[Slast[1]] = 0;Sbuttonminvar[Slast[1]] = 0;Sbuttonnamevar[Slast[1]] = 0; Slast[1] = number;Sbuttonmaxvar[21] = 0;Sbuttonminvar[21] = 0;// reset selection to asure that no new is key get in/turn off key input
    
    loadtime = millis();
    if(number != 0){
    Sbuttonname[number] = name[number];// assign the name to buffer//
    Sbuttonmax[number] = Float.toString(max[number]);// load max
    Sbuttonmin[number] = Float.toString(min[number]);// load min
    }
    if (number == 0)
    { 
      Sbuttonmax[number] = Float.toString(defscale[0]);// load max
      Sbuttonmin[number] = Float.toString(defscale[1]);// load min
      Sbuttonmax[21] = Float.toString(defscale[2]);// load from defscale => Y , max
      Sbuttonmin[21] = Float.toString(defscale[3]);// load from defscale => Y , min
    }
      }
      
  }
    
     

//Serial Settings
int selectedportnumber = 0;// selected port , default = 0
int[] serialbutton = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};// serial menu button click buffer
int[] serialbuttonlast = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};// last serial button pressed memory
String selectedport = "1";/// lseleted port name
void serialport(int number, int xbegin, int ybegin, int xsize, int ysize, String text){
  int[] d = {100, 45, 3} ;// distance between text print, underline size, underline thickness
  noStroke();fill(255);rect(xbegin+d[0]*number, ybegin-ysize, xsize, ysize+d[2]);
  
  
  fill(0);textSize(20);
  text(text, xbegin+d[0]*number, ybegin);// initial text
  
  if ( mouseX >= xbegin+d[0]*number && mouseX <= xbegin+xsize+d[0]*number && mouseY >= ybegin-ysize && mouseY <= ybegin && mousePressed && mouseButton == LEFT && serialbutton[number] == 0){
    serialbutton[serialbuttonlast[0]] = 0;// reset the ass pressed
    serialbutton[number] = 1; // button pressed
    serialbuttonlast[0] = number;// assign the last button
    selectedportnumber = number;
  }
  
  if (serialbutton[number] == 1){/// underline selected, only on click
    noStroke();fill(255,0,0);// 
    rect(xbegin+d[0]*number, ybegin, d[1],d[2] );//
  serialsetting[0] = number;//assign port number to setting
  }
  if (load == 1 && serialbuttonlast[0] == number){selectedport = text; selectedportnumber = number;
  
loadport(); /// start serial 
}

  
}
  
  //BAUD RATE Settings
String baudcustom = "9600";
int[] baudbutton = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};// baud menu button click buffer
int[] baudbuttonlast = {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};// last baud button pressed memory
int selectedbaud = 9600;/// selected baud name , 9600 as default


  void baudrate(int number, int xbegin, int ybegin, int xsize, int ysize, int text){
  int[] d = {xsize, 60, 3} ;// distance between text print, underline size, underline thickness
  
  
  noStroke();fill(255);rect(xbegin+d[0]*number, ybegin-ysize+d[2], xsize, ysize);// refresh text
  fill(0);textSize(20);
  if(number != 8){text(text, xbegin+d[0]*number, ybegin);}// initial text, not for custo input
  else{noStroke();fill(255);rect(xbegin+d[0]*number, ybegin-ysize+d[2], xsize*2, ysize);}// refresh text, for custom
  
  if (number != 8){if ( mouseX >= xbegin+d[0]*number && mouseX <= xbegin+xsize+d[0]*number && mouseY >= ybegin-ysize && mouseY <= ybegin && mousePressed && mouseButton == LEFT && baudbutton[number] == 0){
    baudbutton[baudbuttonlast[0]] = 0;// reset the ast pressed
    baudbutton[number] = 1; // button pressed
    baudbuttonlast[0] = number;// assign the last button
    serialsetting[3] = number;
     
  }}
  if (baudbutton[number] == 1){/// underline selected, only on click
    noStroke();fill(255,0,0);// 
    rect(xbegin+d[0]*number, ybegin, d[1],d[2] );//
     
  }
  
  if (number == 8){// only for custom input
  fill(0);text("Custom:"+baudcustom, xbegin+d[0]*number, ybegin);
  
    if ( mouseX >= xbegin+d[0]*number && mouseX <= xbegin+xsize+d[0]*number+100 && mouseY >= ybegin-ysize && mouseY <= ybegin && mousePressed && mouseButton == LEFT && baudbutton[number] == 0){
    baudbutton[baudbuttonlast[0]] = 0;// reset the ast pressed
    baudbutton[number] = 1; // button pressed
    baudbuttonlast[0] = number;// assign the last button  
    selectedbaud = text;
  }
  
  
  if (baudbutton[8] == 1 && keyvar[0] == 0){/// get ready to enter baud from keyboard
    if (keyCode >= 48 && keyCode <= 57 && baudcustom.length() < 7){
      baudcustom += key; keyvar[0] = 1; 
    }
    if ( key == BACKSPACE && baudcustom.length() > 0 && keyvar[0] == 0){
      baudcustom = baudcustom.substring(0, baudcustom.length()-1);keyvar[0] = 1;
    }
  }
  }
  
 //// load the baud on click
 if (number != 8 && baudbuttonlast[0] == number){selectedbaud = text;serialsetting[1] = text;}// assign to setting}// assign selected baud
 if ( baudbutton[8] == 1){selectedbaud = parseInt(baudcustom);serialsetting[1] = selectedbaud;serialsetting[2] = parseInt(baudcustom);  serialsetting[3] = number;}// assign to setting}// assign selected baud on apply press 


}

int port_on = 0;

void loadport(){
  port_on = 1;
  try{Port.stop();}catch(Exception NullPointer){}
  try{Port = new Serial(this, Serial.list()[selectedportnumber], selectedbaud);Port.bufferUntil(10);}catch(Exception Serial){

textAlign(CENTER);textSize(50);text("PORT BUSY", displaywidth*2/6, displayheight/2);load = 0;setting = 1;}/// port busy
 
}
int newdata = 0;
void serialEvent( Serial Port){
  incomedata[0] = Port.readString();
  newdata = 1;
  
  
}




  
  
  
  String[] eSetting = {str(plotsetting[0]), str(plotsetting[1]), str(plotsetting[2]),str(plotsetting[3]),str(plotsetting[3]),"","",""};//bg color, plotsetting[1], plot thickness, connect dot
  int[] eSettinglast = {-10,0,0,0,0,0,0,0,0,0,0,0};/// last setting selected
  void eSettings(int number, int xbegin, int ybegin, int xsize, int ysize, String text){/// extra setting for pot thickness, bg color, plotsetting[1]
   fill(255);noStroke();rect(xbegin, ybegin, xsize, ysize+5);/// refresh
   textSize(20);fill(0);
   text(text+eSetting[number], xbegin, ybegin+ysize);//plot background color setting
   if (mouseX >= xbegin && mouseX <= xbegin+xsize && mouseY >= ybegin && mouseY <= ybegin+ysize && mousePressed && mouseButton == LEFT){//// select on mouse hover and click left
     eSettinglast[0] = number;/// assign last selected 
      Sbuttonmaxvar[Slast[1]] = 0;Sbuttonminvar[Slast[1]] = 0;Sbuttonnamevar[Slast[1]] = 0; Slast[1] = number;Sbuttonmaxvar[21] = 0;Sbuttonminvar[21] = 0;// last max selected// from variable settings
     /////input from the variable settings to reset and also the other
   }
   
   if ( eSettinglast[0] == number ){/// if eSetting is selected
   fill(255,0,0);noStroke();rect(xbegin, ybegin+ysize, xsize, 3);/// refresh
   if ( keyPressed && key >= 48 && key <= 58 && keyvar[0] == 0 || key == BACKSPACE && keyvar[0] == 0 ){///// enter character
    keyvar[0] = 1;// reset keyvar[0]
   if ( key != BACKSPACE  && eSetting[number].length() < 11 ){
     eSetting[number] += key;
   }else{ if( eSetting[number].length() > 0 ){eSetting[number] = eSetting[number].substring(0, eSetting[number].length()-1); keyvar[0] = 1; }}  
   }
   }

   
   if ( load == 1 ){
      plotsetting[0] = parseInt(eSetting[0]);/// 
      plotsetting[1] =  parseInt(eSetting[1]);/// 
      plotsetting[2] =  parseInt(eSetting[2]);///
      
   }

  }

  
  
  
  /// if dots are skiped its because of the Serial.bufferUntil(10), get all of that off and do it with (if Port.available>0){copy strings......}
  