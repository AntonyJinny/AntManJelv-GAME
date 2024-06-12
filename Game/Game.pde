/* Game Class Starter File
 * Authors: Antony, Mansour, Jelver
 * Last Edit: 6/10/2024
 */

//import processing.sound.*;

//import processing.core.PApplet;


//------------------ GAME VARIABLES --------------------//

//Title Bar
String titleText = "The Tower";
String extraText = "Save Your Dog!";

//VARIABLES: Splash Screen
Screen splashScreen;
PImage splashBg;
String splashBgFile = "images/apcsa.png";
//SoundFile song;


//VARIABLES: Level1World
World level1World;
PImage level1Bg;
String level1BgFile = "images/zeldaTower.jpg";
PImage fullHealth;
String fullHealthFile = "images/fullHealth.png";

Sprite player1;
String player1File = "images/zombie.png";
boolean isAttacking = false;


int player1Row = 3;
int player1Col = 3;
int health = 3;
// AnimatedSprite walkingChick;
// AnimatedSprite runningHorse;
boolean doAnimation = false;
// Button b1 = new Button("rect", 650, 525, 100, 50, "GoToLevel2");
Sprite zombie;
Sprite spider;
int zombieCount = 0;



//VARIABLES: Level2World Pixel-based Screen
World level2World;
PImage level2Bg;
String level2BgFile = "images/sky.jpg";
Sprite player2; //Use Sprite for a pixel-based Location
String player2File = "images/zapdos.png";
int player2startX = 50;
int player2startY = 300;

//VARIABLES: EndScreen
World endScreen;
PImage endBg;
String endBgFile = "images/youwin.png";


//VARIABLES: Tracking the current Screen being displayed
Screen currentScreen;
World currentWorld;
Grid currentGrid;
private int msElapsed = 0;


//------------------ REQUIRED PROCESSING METHODS --------------------//

//Required Processing method that gets run once
void setup() {

  //SETUP: Match the screen size to the background image size
  size(1200,784);  //these will automatically be saved as width & height
  imageMode(CORNER);    //Set Images to read coordinates at corners
  //fullScreen();   //only use if not using a specfic bg image
  
  //SETUP: Set the title on the title bar
  surface.setTitle(titleText);

  //SETUP: Load BG images used in all screens
  splashBg = loadImage(splashBgFile);
  splashBg.resize(width, height);
  level1Bg = loadImage(level1BgFile);
  level1Bg.resize(width, height);
  level2Bg = loadImage(level2BgFile);
  level2Bg.resize(width, height);
  endBg = loadImage(endBgFile);
  endBg.resize(width, height);
  fullHealth =loadImage(fullHealthFile);
  

  
  
  //SETUP: Screens, Worlds, Grids
  splashScreen = new Screen("splash", splashBg);
  level1World = new World("Tower", level1Bg);
  level2World = new World("sky", level2BgFile, 8.0, 0, 0); //moveable World constructor --> defines center & scale (x, scale, y)???
  endScreen = new World("end", endBg);
  currentScreen = splashScreen;

  //SETUP: Level 1
  player1 = new Sprite("images/george.png", "images/georgeAttacking.png", 0.7);
  zombie = new Sprite("images/zombie.png", 0.7);
  spider = new Sprite("images/spider.png", 0.7);
  
  // walkingChick = new AnimatedSprite("sprites/chick_walk.png", "sprites/chick_walk.json", 0.0, 0.0, 5.0);
  // runningHorse = new AnimatedSprite("sprites/horse_run.png", "sprites/horse_run.json", 50.0, 75.0);
  player1.move(565,125);

  //Adding pixel-based Animated Sprites to the world
  // level1World.addSpriteCopyTo(walkingChick, 200,200);
  level1World.printSprites();
  System.out.println("Done adding sprites to level 1..");
  
  //SETUP: Level 2
  player2 = new Sprite(player2File, 0.25);
  //player2.moveTo(player2startX, player2startY);
  // level2World.addSpriteCopyTo(runningHorse, 100, 200);  //example Sprite added to a World at a location, with a speed
  level2World.printWorldSprites();
  System.out.println("Done loading Level 2 ...");
  
  
  //SETUP: Sound
  // Load a soundfile from the /data folder of the sketch and play it back
  // song = new SoundFile(this, "sounds/Lenny_Kravitz_Fly_Away.mp3");
  // song.play();
  
  println("Game started...");

  

} //end setup()


//Required Processing method that automatically loops
//(Anything drawn on the screen should be called from here)
void draw() {

  updateTitleBar();
  updateScreen();
  player1.display(player1.getX(), player1.getY());
  image(fullHealth,0,0);
  
  

  //simple timing handling
  if (msElapsed % 300 == 0) {
    //sprite handling
    populateSprites();
    moveSprites();
    checkCollision();
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
  System.out.println("\nKey pressed: " + keyCode); //key gives you a character for the key pressed

  //What to do when a key is pressed?
  
  //KEYS FOR LEVEL1
  if(currentScreen == level1World){

    if(key == 's' && player1.getBottom() < height-30) {
      player1.move(0,15);
      checkCollision();
      System.out.println("p1x: "+ player1.getBottom() + " dw: "+ width);
    }

    //set [W] key to move the player1 up & avoid Out-of-Bounds errors
    if(key == 'd' && player1.getRight() < width){
      player1.move(15,0);
     // checkCollision();
      System.out.println("p1x: "+ player1.getRight() + " dw: "+ width);
    }
    
    if(key =='w' && player1.getTop() > 0){
      player1.move(0,-15);
      //checkCollision();
      System.out.println("p1x: "+ player1.getTop() + " dw: "+ width);
      
    }

    if(key =='a' && player1.getLeft() > 0){
      player1.move(-15,0);
      //checkCollision(player1.getGridLocation, ); //Work on a way to add another gridlocation while changing the x in it to go back 15
      System.out.println("p1x: "+ player1.getLeft() + " dw: "+ width);
    }

    if(key == 'k') {
      player1.toggleAttack();
    }
  }
  



  //CHANGING SCREENS BASED ON KEYS
  //change to level1 if 1 key pressed, level2 if 2 key is pressed
  if(key == '1'){
    currentScreen = level1World;
  } else if(key == '2'){
    currentScreen = level2World;
  }
  
}



//Known Processing method that automatically will run when a mouse click triggers it
void mouseClicked(){
  
  //check if click was successful
  System.out.println("\nMouse was clicked at (" + mouseX + "," + mouseY + ")");
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

  //UPDATE: Background of the current Screen
  if(currentScreen.getBg() != null){
    background(currentScreen.getBg());
  }

  //UPDATE: splashScreen
  if(currentScreen == splashScreen && splashScreen.getScreenTime() > 3000 && splashScreen.getScreenTime() < 5000){
    System.out.print("s");
    currentScreen = level1World;
  }

  //UPDATE: level1Grid Screen
  if(currentScreen == level1World){
    System.out.print("1");

    //Display the Player1 image
    player1.show();
    
    
      
    //update other screen elements
    level1World.showWorldSprites();

    //move to next level based on a button click
    // b1.show();
    // if(b1.isClicked()){
    //   System.out.println("\nButton Clicked");
    //   currentScreen = level2World;
    // }
  
  }
  
  //UPDATE: level2World Scren
  if(currentScreen == level2World){
    System.out.print("2");
    currentWorld = level2World;
    currentGrid = null;
    
    level2World.moveBgXY(-3.0, 0);
    level2World.show();

    player2.show();

    level2World.showWorldSprites();

  }

  //UPDATE: End Screen
  // if(currentScreen == endScreen){

  // }

  //UPDATE: Any Screen
  // if(doAnimation){
  //   runningHorse.animateHorizontal(5.0, 10.0, true);
  // }


}

//Method to populate enemies or other sprites on the screen
int maxZombies = 7;
int zombiesSpawned = 0;

public void populateSprites(){

  //spawnpoint
  int spawnX = 100;
  int spawnY = 100;
  int spawnAreaWidth = 1000;
  int spawnAreaHeight = 520;
  

  //add sprites to World

  // if(zombieCount < 6) {
  //   level1World.addSpriteCopyTo(zombie, spawnX, spawnY);
  //   zombieCount++;

    

  if(zombiesSpawned < maxZombies) {

    int randomX = spawnX + (int)(Math.random() * spawnAreaWidth);
    int randomY = spawnY + (int)(Math.random() * spawnAreaHeight);

    spawnZombieAt(randomX, randomY);
    zombiesSpawned++;
  }
}

  
  void spawnZombieAt(int x, int y) {
    if (zombieCount < maxZombies) {
        level1World.addSpriteCopyTo(zombie, x, y);
        zombieCount++;
    }
}
  


//Method to move around the enemies/sprites on the screen
public void moveSprites(){

    for (Sprite zombie : level1World.getSprites()) {
        // Calculate the direction for zomb
        PVector playerPos = new PVector(player1.getX(), player1.getY());
        PVector zombiePos = new PVector(zombie.getX(), zombie.getY());
        PVector direction = PVector.sub(playerPos, zombiePos).normalize();

        float speed = 5.0; 
        float newX = zombie.getX() + direction.x * speed;
        float newY = zombie.getY() + direction.y * speed;

        zombie.move(newX - zombie.getX(), newY - zombie.getY());
    }


}

//Method to check if there is a collision between Sprites on the Screen
void checkCollision(){

for (Sprite zombie : level1World.getSprites()) {

  float distance = dist(zombie.getX(), zombie.getY(), player1.getX(), player1.getY());
  float collisionValNeeded = 30;

  if (distance < collisionValNeeded) {
    health -= 10;
    System.out.println("Player health: " + health);
  }

// not working
  if (isAttacking) {
        for (int i = level1World.getSprites().size() - 1; i >= 0; i--) {
            if (distance < collisionValNeeded) {
                level1World.getSprites().remove(i);
                System.out.println("Zombie defeated");
            }
  
        }
  }
}
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
