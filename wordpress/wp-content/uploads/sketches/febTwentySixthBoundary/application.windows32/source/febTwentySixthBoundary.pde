// Draws a local authority boundary.
// Version 2.0b4, 4th January 2012.
// Author Ben Fry with modifications by Tristan Skinner

/***********************************************************************/
/* --------------------- Sketch-wide variables ----------------------- */
/***********************************************************************/

/***********************************************************************/
/* -------------------------- Global Start --------------------------- */
/***********************************************************************/

// Sketch size.
// 1280 x 720 pixels for standard HD 720p video and most modern monitors, Jo Wood, giCentre 23/04/12
// http://moodle.city.ac.uk/mod/forum/discuss.php?d=393924
//int sketchWidth = 1152;   // 10% smaller
int sketchWidth = 648;   // 10% smaller
int sketchHeight = 648;  // 10% smaller

int globalSketchBackgroundColour = 224;  // colour
int globalPlotBackgroundColour = 255;  // colour
int globalPlotStrokeWeight = 5;
int globalPlotStrokeColour = 50;  // colour

/***********************************************************************/
/* ------------------------- Global Finish --------------------------- */
/***********************************************************************/

/***********************************************************************/
/* --------------------------- Map Start ----------------------------- */
/***********************************************************************/

/***********************************************************************/
// Variables from incident table
Table xyFreqTable; // table with frequency of asb calls from M3, contains no personal data!

float xyFreqEastingMin = MAX_FLOAT;  // used to store min and max data values
float xyFreqEastingMax = MIN_FLOAT;

float xyFreqNorthingMin = MAX_FLOAT;  // used to store min and max data values
float xyFreqNorthingMax = MIN_FLOAT;

float xyFreqValueMin = -10;  // arbitrary values
float xyFreqValueMax = 10;

int xyFreqRowCount;

int xyFreqColumnX = 1;  // declares which column to pull information from
int xyFreqColumnY = 2;  // declares which column to pull information from

int xyFreqColumnValue = 3;  // declares which column to pull information from

String xyFreqCoordinates;  // string for eastings and northings from xyFreqTable
/***********************************************************************/

/***********************************************************************/
// Variables from boundary table.
Table boundaryTable; // table storing Ordance Survey boundary vertices

float boundaryEastingMin = MAX_FLOAT;  // used to store min and max data values
float boundaryEastingMax = MIN_FLOAT;

float boundaryNorthingMin = MAX_FLOAT;  // used to store min and max data values
float boundaryNorthingMax = MIN_FLOAT;

float boundaryDifferenceEasting;
float boundaryDifferenceNorthing;

int boundaryRowCount;

int boundaryColumnX = 0;  // declares which column to pull information from
int boundaryColumnY = 1;  // declares which column to pull information from
/***********************************************************************/

/***********************************************************************/
// Variables from places table.
Table placesTable;   // table storing list of anecdotal place names given to all xy points within borough
// Need to work on comprehensive list of places names!!!
int placesColumnStreetName = 5;  // declares which column to pull information from
/***********************************************************************/

/***********************************************************************/
// Variables for plot
float mapPlotWidth;  // plot width
float mapPlotHeight;  // plot height
float mapPlotX1, mapPlotY1;
float mapPlotX2, mapPlotY2;
float mapSetWithinPlot = 10;  // sets number of pixels within plot boundary is drawn
float mapPlotCornerX;  // determines x coordinate for point for top left hand corner of plot within sketch
float mapPlotCornerY;  // determines y coordinate for point for top left hand corner of plot within sketch
/***********************************************************************/

PImage boundaryImage;

// Global variables set in drawData() and read in draw() for text displayed 
// above ellipse.
float closestDist;
String closestText;
float closestTextX;
float closestTextY;

Integrator[] interpolators;

//PrintWriter writer;  // function for creating new file in the Sketch folder

/***********************************************************************/
/* ---------------------------- Map End ------------------------------ */
/***********************************************************************/

/***********************************************************************/
/* --------------------------- Data Start ---------------------------- */
/***********************************************************************/

/***********************************************************************/
// Variables from data table.
FloatTable data;  // table for storing milk, tea, coffee
float dataMin, dataMax;
int yearMin, yearMax;
int[] years;
int yearInterval = 10;  // value will result in interval every ten years

int dataCurrentColumn = 1;  // declares which column to pull data from
int dataColumnCount;
int dataRowCount;
/***********************************************************************/

/***********************************************************************/
// Variables for plot
float dataPlotWidth;  // plot width
float dataPlotHeight;  // plot height
float dataPlotX1, dataPlotY1;
float dataPlotX2, dataPlotY2;
float dataSetWithinPlotWidth = 50;  // need to workout appropriate golden ratio between width and height
float dataSetWithinPlotHeight = 60; 
/***********************************************************************/

int dataSetWithinTitleHeight = 10;  // No of pixels title is above the top of the plot
int dataSetWithinLableX = 10;  // No of pixels x axis labels are below plot
int dataSetWithinLableY = 10;  // No of pixels y axis labels are infront of plot


/***********************************************************************/
/* ---------------------------- Data End ----------------------------- */
/***********************************************************************/

/***********************************************************************/
/* ------------------------ Initialisation --------------------------- */
/***********************************************************************/

// Start the sketch and load the data.
void setup()
{
  size(sketchWidth, sketchHeight);

  /***********************************************************************/
  /* --------------------------- Map Start ----------------------------- */
  /***********************************************************************/

  // Load data from table
  boundaryTable = new Table("coordinatesLBI.tsv");
  // The rowCount will be used a lot, so store it globally.
  boundaryRowCount = boundaryTable.getRowCount();

  //writer = createWriter("mouseClickedXY.tsv");

  // Find the minimum and maximum values from boundaryTable
  for (int row=0; row < boundaryRowCount; row++)
  {
    boundaryEastingMin = min(boundaryEastingMin, boundaryTable.getFloat(row, boundaryColumnX));  // column x
    boundaryEastingMax = max(boundaryEastingMax, boundaryTable.getFloat(row, boundaryColumnX));  // column x
    boundaryNorthingMin = min(boundaryNorthingMin, boundaryTable.getFloat(row, boundaryColumnY));  // column x
    boundaryNorthingMax = max(boundaryNorthingMax, boundaryTable.getFloat(row, boundaryColumnY));  // column x
  }

  // Load data from table (table values sorted lowest to highest).
  xyFreqTable = new Table("xyFreq.tsv");
  // The rowCount will be used a lot, so store it globally.
  xyFreqRowCount = xyFreqTable.getRowCount();

  // Find the minimum and maximum values from xyFreqTable
  for (int row=0; row < xyFreqRowCount; row++)
  {
    xyFreqEastingMin = min(xyFreqEastingMin, xyFreqTable.getFloat(row, xyFreqColumnX));  // column x
    xyFreqEastingMax = max(xyFreqEastingMax, xyFreqTable.getFloat(row, xyFreqColumnX));  // column x
    xyFreqNorthingMin = min(xyFreqNorthingMin, xyFreqTable.getFloat(row, xyFreqColumnY));  // column x
    xyFreqNorthingMax = max(xyFreqNorthingMax, xyFreqTable.getFloat(row, xyFreqColumnY));  // column x
    xyFreqValueMin = min(xyFreqValueMin, xyFreqTable.getFloat(row, xyFreqColumnValue));  // column x
    xyFreqValueMax = max(xyFreqValueMax, xyFreqTable.getFloat(row, xyFreqColumnValue));  // column x
  }

  // Load data from table
  placesTable = new Table("places.tsv");

  // Setup: load initial values into the Integrator.
  interpolators = new Integrator[xyFreqRowCount];
  for (int row = 0; row < xyFreqRowCount; row++) {
    float initialValue = xyFreqTable.getFloat(row, xyFreqColumnValue);
    interpolators[row] = new Integrator(initialValue, 0.4, 0.7);  // damping determines wobblyness, attraction determines how quickly value becomes another
  }

  /***********************************************************************/
  // Set size of plot.
  // Width should equal: height * ((boundaryEastingMax - boundaryEastingMin) / (boundaryNorthingMax - boundaryNorthingMin)) ???
  // Height should equal: width * ((boundaryNorthingMax - boundaryNorthingMin) / (boundaryEastingMax - boundaryEastingMin)) ???
  int boundaryDifferenceEasting = round(boundaryEastingMax - boundaryEastingMin);  // used to set width of frame
  int boundaryDifferenceNorthing = round(boundaryNorthingMax - boundaryNorthingMin);   // used to set height of frame
  String boundaryDifferenceStringX = str(boundaryDifferenceEasting).substring(0, 3);   // turn int into substring
  String boundaryDifferenceStringY = str(boundaryDifferenceNorthing).substring(0, 3);   // turn int into substring
  // Used to set width of plot.
  mapPlotWidth = parseInt(boundaryDifferenceStringX);  // turn string into int;
  // Used to set height of frame.
  mapPlotHeight = parseInt(boundaryDifferenceStringY);  // turn string into int);
  //println(mapPlotWidth + " " + mapPlotHeight); // 'true' dimensions = 465, 631

  // Set corners of the map plot
  mapPlotCornerX = 10;  // determines x coordinate for point for top left hand corner of plot within sketch
  mapPlotCornerY = (sketchHeight - parseInt(mapPlotHeight)) / 2;  // determines x coordinate for point for top left hand corner of plot within sketch
  //mapPlotCornerY = 10;  // determines y coordinate for point for top left hand corner of plot within sketch
  mapPlotX1 = mapPlotCornerX;
  mapPlotY1 = mapPlotCornerY;
  mapPlotX2 = mapPlotWidth - mapPlotX1;
  mapPlotY2 = mapPlotHeight + mapPlotY1;
  //println(mapPlotCornerY + " " + mapPlotY1 + " " + mapPlotY2);  
  /***********************************************************************/

  boundaryImage = loadImage("openStreetMapIslingtonBoundary.png");
  boundaryImage.resize(parseInt(mapPlotWidth) - (parseInt(mapSetWithinPlot * 4)), parseInt(mapPlotHeight) - (parseInt(mapSetWithinPlot * 2))); // for some reason resize needs to go in setup rather than draw

  PFont font = loadFont("Arial-BoldMT-14.vlw");
  textFont(font);

  //frameRate(30);

  /***********************************************************************/
  /* ---------------------------- Map End ------------------------------ */
  /***********************************************************************/

  /***********************************************************************/
  /* --------------------------- Data Start ---------------------------- */
  /***********************************************************************/

  /***********************************************************************/
  /* ---------------------------- Data End ----------------------------- */
  /***********************************************************************/
}  // setup final parentheses

/***********************************************************************/
/* ------------------------ Processing draw -------------------------- */
/***********************************************************************/

void draw()
{

  background(globalSketchBackgroundColour);  // colour

  /***********************************************************************/
  /* --------------------------- Map Start ----------------------------- */
  /***********************************************************************/

  /***********************************************************************/
  // Draw plot.
  // Show the plot area as a white box.
  fill(globalPlotBackgroundColour);  // colour
  strokeWeight(globalPlotStrokeWeight);
  stroke(globalPlotStrokeColour);  // colour
  smooth();
  rectMode(CORNERS);
  rect(mapPlotX1, mapPlotY1, mapPlotX2, mapPlotY2);
  /***********************************************************************/

  // Draw image.
  image(boundaryImage, mapPlotX1 + mapSetWithinPlot, mapPlotY1 + mapSetWithinPlot);

  //point (mouseX, mouseY);
  //writer.println("Easting = " + mouseX + " Northing = " + mouseY);  // write the coordinates to the file

  // Draw: Update the Integrator with the current values, which are either those from the setup()
  // function or those loaded by the target() function issued in updateTable().
  for (int row = 0; row < xyFreqRowCount; row++) {
    interpolators[row].update();
  }

  closestDist = MAX_FLOAT;

  /***********************************************************************/
  // Loop through coordinates and draw boundary line.
  noFill();
  stroke(100);    // Colour
  strokeWeight(3);
  smooth();

  beginShape();
  for (int row = 0; row < boundaryRowCount; row++) {
    //if (data.isValid(row, col)) {
    float boundaryEasting = boundaryTable.getFloat(row, boundaryColumnX);   // column x
    float boundaryNorthing = boundaryTable.getFloat(row, boundaryColumnY);  // column x
    float boundaryX = map(boundaryEasting, boundaryEastingMin, boundaryEastingMax, 0 + (mapSetWithinPlot * 2), mapPlotWidth - (mapSetWithinPlot * 2));
    float boundaryY = map(boundaryNorthing, boundaryNorthingMin, boundaryNorthingMax, mapPlotHeight, 0 + (mapSetWithinPlot * 2));
    curveVertex(boundaryX, boundaryY);
    // Double the curve points for the start and stop
    if ((row == 0) || (row == boundaryRowCount-1)) {
      curveVertex(boundaryX, boundaryY);    // Should curve method be used rather than just vertex method? - Visually accurate?
    }
  }
  endShape();
  //}
  /***********************************************************************/

  /***********************************************************************/
  // Loop through the rows of the xyFreq file, store the xy coordinates and freq values,
  // turn to int then string and concatenate xy, and declare the drawData function.
  for (int row = 2; row < xyFreqRowCount; row++) {  // start at row 2
    float xyFreqEasting = xyFreqTable.getFloat(row, xyFreqColumnX);  // column x
    float xyFreqNorthing = xyFreqTable.getFloat(row, xyFreqColumnY); // column x
    float xyFreqX = map(xyFreqEasting, xyFreqEastingMin, xyFreqEastingMax, 0 + (mapSetWithinPlot * 2), mapPlotWidth - (mapSetWithinPlot * 2));
    float xyFreqY = map(xyFreqNorthing, xyFreqNorthingMin, xyFreqNorthingMax, mapPlotHeight, 0 + (mapSetWithinPlot * 2));
    //int xyFreqValue = xyFreqTable.getInt(row, xyFreqColumnValue);  // column x
    int intX = (int)xyFreqEasting;   // turn float into integer
    int intY = (int)xyFreqNorthing;  // turn float into integer
    String xyFreqCoordinates = str(intX) + str(intY); // turn integers into strings and then concatenate
    // Function draws ellipses for each incident, measures mouse distance and sets text info above ellipse.
    drawData(xyFreqX, xyFreqY, /*xyFreqValue,*/ xyFreqCoordinates);
  }
  /***********************************************************************/

  /***********************************************************************/
  // Use global variables set in drawData() to draw text related to closest circle.
  if (closestDist != MAX_FLOAT) {
    fill(0);  // colour black
    textAlign(CENTER);
    text(closestText, closestTextX, closestTextY);
  }
  /***********************************************************************/

  /***********************************************************************/
  /* ---------------------------- Map End ------------------------------ */
  /***********************************************************************/

  /***********************************************************************/
  /* --------------------------- Data Start ---------------------------- */
  /***********************************************************************/

  /***********************************************************************/
  /* ---------------------------- Data End ----------------------------- */
  /***********************************************************************/
}  // draw final parentheses

/***********************************************************************/
/***********************************************************************/
/***********************************************************************/

/***********************************************************************/
/* --------------------------- Map Start ----------------------------- */
/***********************************************************************/

// Map the size of the ellipse to the data value and draw the ellipses
// then measure disatnce from mouse to determine when to dispaly text information.
void drawData(float xyFreqX, float xyFreqY, /*int xyFreqValue,*/ String xyFreqCoordinates) {
  smooth();
  //fill(192, 0, 0);    // change RGB to LBI colours
  noStroke();
  stroke(50);         // colour
  strokeWeight(0.5);

  // Figure out what row this is.
  //println(xy);
  int row = xyFreqTable.getRowIndex(xyFreqCoordinates);
  // Get the current value.
  float value = interpolators[row].value;
  //println(value);

  // Normalise value and map value.
  float radius = 0;
  radius = map(value, xyFreqValueMin, xyFreqValueMax, 1.5, 15); // arbitrary values
  fill(#FF4422);  // colour

  ellipseMode(RADIUS); // width and height parameters to ellipse() specify radius of the ellipse, rather than the diameter
  ellipse(xyFreqX, xyFreqY, radius, radius);

  float d = dist(xyFreqX, xyFreqY, mouseX, mouseY);
  // Because the following check is done each time a new circle is drawn, we end up with the
  // values of the circle closest to the mouse.
  if ((d < radius + 2) && (d < closestDist)) {
    closestDist = d;
    String name = placesTable.getString(xyFreqCoordinates, placesColumnStreetName); // (row x, column x)
    closestText = name + ", " + nf(value, 0, -1);  // second and third values determine no of digits to the left and right of decimal point
    closestTextX = xyFreqX;
    closestTextY = xyFreqY - radius - 4;
  }
}

/***********************************************************************/
/***********************************************************************/
/***********************************************************************/

// Updating values over time.
void keyPressed() {
  if (key == ' ') {  // pressing the space bar
    updateTable();
  }
}

// Change value table to another made-up asb table.
void updateTable() {
  for (int row = 0; row < xyFreqRowCount; row++) {
    float newValue = random(0, 77);
    interpolators[row].target(newValue);
    // println(newValue);
  }
} 

/***********************************************************************/
/***********************************************************************/
/***********************************************************************/

// Writes all mouseX and mouseY movements to a file until mouse is clicked.
/**void mousePressed(){
 writer.flush();  // writes the remaining data to the file
 writer.close();  // finishes the file
 exit();  // stops the programme
 }*/

/***********************************************************************/
/***********************************************************************/
/***********************************************************************/

/***********************************************************************/
/* ---------------------------- Map End ------------------------------ */
/***********************************************************************/

/***********************************************************************/
/* --------------------------- Data Start ---------------------------- */
/***********************************************************************/

/***********************************************************************/
/* ---------------------------- Data End ----------------------------- */
/***********************************************************************/
