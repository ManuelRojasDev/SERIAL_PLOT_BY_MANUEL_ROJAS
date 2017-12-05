# SERIAL_PLOT_BY_MANUEL_ROJAS



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

