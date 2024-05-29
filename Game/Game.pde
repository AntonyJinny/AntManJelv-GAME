/* Game Class Starter File
 * Authors: Antony, Mansour, Jelver
 * Last Edit: 5/22/2024
 */

//import processing.sound.*;

//------------------ GAME VARIABLES --------------------//

//Title Bar
String titleText = "HorseChess";
String extraText = "Who's Turn?";

//Splash Screen Variables
Screen splashScreen;
PImage splashBg;
String splashBgFile = "images/apcsa.png";
//SoundFile song;

//Level1 World Variables
World level1World;
PImage level1Bg;
String level1BgFile = "images/oldZelda.jpg";


Sprite player1;
String player1File = "images/zombie.png";
int player1Row = 3;
int player1Col = 3;
int health = 3;
Button b1 = new Button("rect", 400, 500, 100, 50, "GoToLevel2");
Sprite enemy;
AnimatedSprite enemySprite;


//Level2 Pixel-based-Screen Variables
World level2World;
PImage level2Bg;
String level2BgFile = "images/sky.jpg";

Sprite player2;   //Use PImage to display the image in a GridLocation
String player2File = "images/zapdos.png";
int player2startX = 50;
int player2startY = 300;


//EndScreen variables
World endScreen;
PImage endBg;
String endBgFile = "images/youwin.png";


//Whole Game Variables
AnimatedSprite exampleSprite;
boolean doAnimation;


//Variables to track the current Screen being displayed
Screen currentScreen;
World currentWorld;
Grid currentGrid;
private int msElapsed = 0;


//------------------ REQUIRED PROCESSING METHODS --------------------//

//Required Processing method that gets run once
void setup() {

  //Match the screen size to the background image size
  size(1200,784);
  
  //Set the title on the title bar
  surface.setTitle(titleText);

  //Load BG images used in all screens
  splashBg = loadImage(splashBgFile);
  splashBg.resize(1200,784);
  level1Bg = loadImage(level1BgFile);
  level1Bg.resize(1200,784);
  level2Bg = loadImage(level2BgFile);
  level2Bg.resize(1200,784);
  endBg = loadImage(endBgFile);
  endBg.resize(1200,784);  


  //------------------ OTHER GRID METHODS --------------------//

  //setup the screens/worlds/grids in the Game
  splashScreen = new Screen("splash", splashBg);
  level1World = new World("Tower", level1Bg);
  level2World = new World("sky", level2BgFile, 8.0, 0, 0); //moveable World constructor --> defines center & scale (x, scale, y)???
  endScreen = new World("end", endBg);
  currentScreen = splashScreen;

  //setup the sprites  
  player1 = new Sprite("images/george.png", 0.5);
  enemy = new Sprite("images/zombie.png", 0.5);

  //level1World.addSprite(player1);
  // player1.resize(level1World.getTileWidthPixels(),level1World.getTileHeightPixels());

  //Adding pixel-based Animated Sprites to the world
  level1World.printSprites();
  System.out.println("Done adding sprites to level 1..");
  
  //LEVEL 2 SPRITE SETUP - WORLD
  player2 = new Sprite(player2File, 0.25);
  //player2.moveTo(player2startX, player2startY);
  // enemy.resize(100,100);

  
  //Other Setup
  exampleAnimationSetup();

  // Load a soundfile from the /data folder of the sketch and play it back
  // song = new SoundFile(this, "sounds/Lenny_Kravitz_Fly_Away.mp3");
  // song.play();
  
  imageMode(CORNER);    //Set Images to read coordinates at corners
  //fullScreen();   //only use if not using a specfic bg image
  println("Game started...");

} //end setup()

//Required Processing method that automatically loops
//(Anything drawn on the screen should be called from here)
void draw() {

  updateTitleBar();
  updateScreen();

  //simple timing handling
  if (msElapsed % 300 == 0) {
    //sprite handling
    populateSprites();
    moveSprites();
  }
  msElapsed +=100;
  currentScreen.pause(100);

  //check for end of game
  if(isGameOver()){
    endGame();
  }

} //end draw()

//------------------ USER INPUT METHODS --------------------//


//Known Processing method that automatically will run whenever a key is pressed
void keyPressed(){

  //check what key was pressed
  System.out.println("Key pressed: " + key); //keyCode gives you an integer for the key

  //What to do when a key is pressed?
  
  //KEYS FOR LEVEL1
  if(currentScreen == level1World){

    if(key == 's') {
      player1.move(0,30);
    }

    //set [W] key to move the player1 up & avoid Out-of-Bounds errors
    if(key == 'd'){
      player1.move(30,0);
    }
    
    if(key =='w'){
      player1.move(0,-30);
    }
    if(key =='a'){
      player1.move(-30,0);
    }

  }

  //CHANGING SCREENS BASED ON KEYS
  //change to level1 if 1 key pressed, level2 if 2 key is pressed
  if(key == '1'){
    currentScreen = level1World;
  } else if(key == '2'){
    currentScreen = level2World;
  }
  // if(keyCode == 83){
   
  //   //Store old GridLocation
  //   GridLocation oldLoc = new GridLocation(player1Row, player1Col);

  //   //Erase image from previous location

    

  //   //change the field for player1Row
  //   player1Row++;
  // }
  // if(keyCode == 65){
   
  //   //Store old GridLocation
  //   GridLocation oldLoc = new GridLocation(player1Row, player1Col);

  //   //Erase image from previous location
    

  //   //change the field for player1Row
  //   player1Col--;
  // }
  // if(keyCode == 68){
   
  //   //Store old GridLocation
  //   GridLocation oldLoc = new GridLocation(player1Row, player1Col);

  //   //Erase image from previous location
    

  //   //change the field for player1Row
  //   player1Col++;
  // }
}

//Known Processing method that automatically will run when a mouse click triggers it
void mouseClicked(){
  
  //check if click was successful
  System.out.println("Mouse was clicked at (" + mouseX + "," + mouseY + ")");
  if(currentGrid != null){
    //System.out.println("World location: " + currentWorld.getGridLocation());
   }

  //what to do if clicked? (Make player1 jump back?)
  


  //Toggle the animation on & off
  doAnimation = !doAnimation;
  System.out.println("doAnimation: " + doAnimation);
  if(currentGrid != null){
    // currentGrid.setMark("X",currentWorld.getGridLocation());
  }

}



//------------------ CUSTOM  GAME METHODS --------------------//

//method to update the Title Bar of the Game
public void updateTitleBar(){

  if(!isGameOver()) {
    //set the title each loop
    surface.setTitle(titleText + "    " + extraText + " " + health);

    //adjust the extra text as desired
  
  }
}

//method to update what is drawn on the screen each frame
public void updateScreen(){

  //Update the Background of the current Screen
  if(currentScreen.getBg() != null){
    background(currentScreen.getBg());
  }

  //splashScreen update
  if(splashScreen.getScreenTime() > 3000 && splashScreen.getScreenTime() < 5000){
    currentScreen = level1World;
  }

  //level1Grid Screen Updates
  if(currentScreen == level1World){

    //Display the Player1 image
    //level1World.setTileImage(player1Loc, player1);
    player1.show();
      
    //update other screen elements
    level1World.showSprites();
    //level1World.showImages();
    //level1World.showGridSprites();

    //move to next level based on a button click
    b1.show();
    if(b1.isClicked()){
      currentScreen = level2World;
    }
    
  }

  //level2World Updates
  else if(currentScreen == level2World){
    currentWorld = level2World;
    
    level2World.moveBgXY(-3.0, 0);
    level2World.show();

    player2.show();


  }

  //Updtes for any Screen
  checkExampleAnimation();


}

//Method to populate enemies or other sprites on the screen
public void populateSprites(){

  //What is the index for the last column?
  int lastCol = level1World.ge - 1;
    
  

  //Loop through all the rows in the last column
  for(int r = 0; r < level1World.getNumRows(); r++) {

    GridLocation loc = new GridLocation(r, lastCol);

    //Generate a random number
    double rando = Math.random();

    //10% of the time, decide to add an enemy image to a Tile
    if(rando < 0.1) {
      level1World.setTileSprite(loc, enemy);
      System.out.println("Adding bomb to "+ loc);
    }
  }
  }


//Method to move around the enemies/sprites on the screen
public void moveSprites(){

//Loop through all of the rows & cols in the grid

      //Store the current GridLocation

      //Store the next GridLocation

      //Check if the current tile has an image that is not player1      


        //Get image/sprite from current location
          

        //CASE 1: Collision with player1


        //CASE 2: Move enemy over to new location


        //Erase image/sprite from old location

        //System.out.println(loc + " " + grid.hasTileImage(loc));

          
      //CASE 3: Enemy leaves screen at first column

}

//Method to check if there is a collision between Sprites on the Screen
public boolean checkCollision(GridLocation loc, GridLocation nextLoc){

  //Check what image/sprite is stored in the CURRENT location
  // PImage image = grid.getTileImage(loc);
  // AnimatedSprite sprite = grid.getTileSprite(loc);

  //if empty --> no collision

  //Check what image/sprite is stored in the NEXT location

  //if empty --> no collision

  //check if enemy runs into player

    //clear out the enemy if it hits the player (using cleartTileImage() or clearTileSprite() from Grid class)

    //Update status variable

  //check if a player collides into enemy

  return false; //<--default return
}

//method to indicate when the main game is over
public boolean isGameOver(){
  
  return false; //by default, the game is never over
}

//method to describe what happens after the game is over
public void endGame(){
    System.out.println("Game Over!");

    //Update the title bar

    //Show any end imagery
    currentScreen = endScreen;

}

//example method that creates 1 horse run along the screen
public void exampleAnimationSetup(){  
  int i = 2;
  exampleSprite = new AnimatedSprite("sprites/horse_run.png", "sprites/horse_run.json", 50.0, i*75.0);
  //exampleSprite.resize(200,200);
}

//example method that animates the horse Sprites
public void checkExampleAnimation(){
  if(doAnimation){
    exampleSprite.animateHorizontal(5.0, 10.0, true);
    //System.out.println("animating!");
  }
}
