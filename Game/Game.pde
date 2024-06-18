/* Game Class Starter File
 * Authors: Antony, Mansour, Jelver
 * Last Edit: 6/10/2024
 */

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
Sprite player1;
String player1File = "images/zombie.png";
int player1Row = 3;
int player1Col = 3;
int health = 100;
Sprite zombie;
int zombieCount = 0;
int maxZombies = 7;
int zombiesSpawned = 0;

// GAME SCORE & HEALTH DISPLAY
int score = 0;
PFont fonty;
PImage fullHealth;
String fullHealthFile = "images/fullHealth.png";
PImage halfHealth;
String halfHealthFile = "images/halfHealth.png";
PImage redHealth;
String redHealthFile = "images/redHealth.png";
PImage noHealth;
String noHealthFile = "images/noHealth.png";


boolean doAnimation = false;

// BUTTON TO PROCEED LEVELS
Button b1 = new Button("rect", 650, 525, 400, 50, "GoToLevel2");
Button b2 = new Button("circle", 650, 525, 400, 50, "Victory! \n You got your dog back from \n the evil monsters! \n CLICK ME" );


//VARIABLES: Level2World Pixel-based Screen
World level2World;
PImage level2Bg;
String level2BgFile = "images/zeldaTower.jpg";
Sprite player2;
String player2File = "images/zapdos.png";
Sprite spider;
int player2startX = 50;
int player2startY = 300;
int maxSpiders = 6;
int spidersSpawned = 0;
int spiderCount = 0;

//VARIABLES: EndScreen
World endScreen;
PImage endBg;
String endBgFile = "images/doggy.jpeg";

World deathScreen;
PImage deathBg;
String deathBgFile = "images/deathScreen.png";

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
  deathBg = loadImage(deathBgFile);
  deathBg.resize(width, height);
  fonty = createFont("Helvetica", 16, true);

  
  fullHealth = loadImage(fullHealthFile);
  fullHealth.resize(200, 200);
  halfHealth = loadImage(halfHealthFile);
  halfHealth.resize(200, 200);
  redHealth = loadImage(redHealthFile);
  redHealth.resize(200, 200);
  noHealth = loadImage(noHealthFile);
  noHealth.resize(200, 200);
  
  //SETUP: Screens, Worlds, Grids
  splashScreen = new Screen("splash", splashBg);
  level1World = new World("Tower", level1Bg);
  level2World = new World("Tower", level2BgFile, 8.0, 0, 0); //moveable World constructor --> defines center & scale (x, scale, y)???
  endScreen = new World("end", endBg);
  deathScreen = new World("death", deathBg);
  currentScreen = splashScreen;

  //SETUP: Level 1
  player1 = new Sprite("images/george.png", "images/georgeAttacking.png", 0.7);
  zombie = new Sprite("images/zombie.png", 0.7);
  spider = new Sprite("images/spider.png", 0.7);
  player1.move(565,125);

  //Adding pixel-based Animated Sprites to the world
  level1World.printSprites();
  System.out.println("Done adding sprites to level 1..");
  
  //SETUP: Level 2
  player2 = new Sprite(player2File, 0.25);
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

  if (currentScreen != splashScreen)
{
  player1.display();
  textFont(fonty, 50);
  fill(255);
  text("Score:" + score, 950,75);
  if (health > 50)
  {
  image(fullHealth, 0, -50);
  }
  else if (health <= 50 && health > 25)
  {
    image(halfHealth, 0, -50);
  }
  else if (health <= 25 && health > 0)
  {
    image(redHealth, 0, -50);
  }
  else
  {
    image(noHealth, 0, -50);
  }
}
  

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

  if(zombieCount ==0 && currentScreen == level1World ){
    b1.show();
    if(b1.isClicked()){
      currentScreen = level2World;
      player1.move(player2startX, player2startY);
    }
  }

  if(spiderCount == 0 && currentScreen == level2World) {
    b2.show();
    if(b2.isClicked()) {
      currentScreen = endScreen;
 
    }
  }

  if (player1.isAttacking() && !player1.canAttack()) {
        fill(255, 0, 0); 
        textAlign(CENTER);
        textSize(60);
        text("Attack Mode Cooldown", width / 2, height - 20);
    }

  if(health < 51) {
    fill(255, 0, 0); 
        textAlign(CENTER);
        textSize(60);
        text("LOW HEALTH. Press H to heal.", width / 2, height - 20);
  }

 
  textFont(fonty, 20);
  fill(0);
  text("K = Attack Mode! (Move slower, take less damage & kill mobs. \nNormal mode = Faster! Evade mobs but take more damage!", 515,370);
  

 

} //end draw()

//------------------ USER INPUT METHODS --------------------//


//Known Processing method that automatically will run whenever a key is pressed
void keyPressed(){

  //check what key was pressed
  System.out.println("\nKey pressed: " + keyCode); //key gives you a character for the key pressed

  //What to do when a key is pressed?
  
  //KEYS FOR LEVEL1
  if(currentScreen == level1World || currentScreen == level2World){

    int moveSpeed;

    if(player1.isAttacking()) {
      moveSpeed = 5;
    } else {
      moveSpeed = 15;
    }

    if(key == 's' || key == 'S' && player1.getBottom() < height-30) {
      player1.move(0,moveSpeed);
      checkCollision();
      System.out.println("p1x: "+ player1.getBottom() + " dw: "+ width);
    }

    //set [W] key to move the player1 up & avoid Out-of-Bounds errors
    if(key == 'd' || key == 'D' && player1.getRight() < width){
      player1.move(moveSpeed,0);
     // checkCollision();
      System.out.println("p1x: "+ player1.getRight() + " dw: "+ width);
    }
    
    if(key =='w' || key == 'W'  && player1.getTop() > 0){
      player1.move(0,-moveSpeed);
      //checkCollision();
      System.out.println("p1x: "+ player1.getTop() + " dw: "+ width);
      
    }

    if(key =='a' || key == 'A'  && player1.getLeft() > 0){
      player1.move(-moveSpeed,0);
      //checkCollision(player1.getGridLocation, ); //Work on a way to add another gridlocation while changing the x in it to go back 15
      System.out.println("p1x: "+ player1.getLeft() + " dw: "+ width);
    }

    if(key == 'k'  || key == 'K' ) {
      player1.toggleAttack();
    }

    if((key == 'h' || key == 'H') && health < 51 && health > 0) {
      health += 5;
      println("+5 health");
      println(health);
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
}

//Method to populate enemies or other sprites on the screen
public void populateSprites(){

  //spawnpoint
  int spawnX = 100;
  int spawnY = 100;
  int spawnAreaWidth = 1000;
  int spawnAreaHeight = 520;

  if(currentScreen == level1World && zombiesSpawned < maxZombies) {

    int randomX = spawnX + (int)(Math.random() * spawnAreaWidth);
    int randomY = spawnY + (int)(Math.random() * spawnAreaHeight);

    spawnZombieSpiderAt(randomX, randomY, level1World);
    zombiesSpawned++;
  }

  if(currentScreen == level2World && spidersSpawned < maxSpiders) {
    int randomX = spawnX + (int)(Math.random() * spawnAreaWidth);
    int randomY = spawnY + (int)(Math.random() * spawnAreaHeight);

    spawnZombieSpiderAt(randomX, randomY, level2World);
    spidersSpawned++;
  }

}

  
  void spawnZombieSpiderAt(int x, int y, World world) {
    if (world == level1World && zombieCount < maxZombies) {
        level1World.addSpriteCopyTo(zombie, x, y);
        zombieCount++;
    }

    if (world == level2World && spiderCount < maxSpiders) {
        level2World.addSpriteCopyTo(spider, x, y);
        spiderCount++;
    }
    
}
  


//Method to move around the enemies/sprites on the screen
public void moveSprites(){

  if(currentScreen == level1World) {
    
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

  if(currentScreen == level2World) {

    for (Sprite spider : level2World.getSprites()) {
        // Calculate the direction for zomb
        PVector playerPos = new PVector(player1.getX(), player1.getY());
        PVector spiderPos = new PVector(spider.getX(), spider.getY());
        PVector direction = PVector.sub(playerPos, spiderPos).normalize();

        float speed = 10.0; 
        float newX = spider.getX() + direction.x * speed;
        float newY = spider.getY() + direction.y * speed;

        spider.move(newX - spider.getX(), newY - spider.getY());
    }
  }

  }

//Method to check if there is a collision between Sprites on the Screen
void checkCollision(){

  if(currentScreen == level1World) {
    
  //for (Sprite zombie : level1World.getSprites()) {
  for(int i = level1World.getNumSprites() -1; i >=0; i--){

    Sprite zombie = level1World.getSprite(i);
    float distance = dist(zombie.getX(), zombie.getY(), player1.getX(), player1.getY());
    float collisionValNeeded = 35;

    if (distance < collisionValNeeded) {
      System.out.println("Collision detected. Distance: " + distance + " | Player attacking: " + player1.isAttacking());

      //make zombie disappear if in attack mode
      if (player1.isAttacking) {
        level1World.removeSprite(zombie);
        System.out.println("Zombie defeated");
        score+= 20;
        health-= 5;
        zombieCount--;
        println("Zombie count in level 1: " + zombieCount);

      //if not, then lose health
      } else {
        health -= 10;
        score-= 10;
        System.out.println("hit by zombie");
      }

      System.out.println("Player health: " + health);
    }
  }
  }

  if(currentScreen == level2World) {
    
  //for (Sprite spider : level1World.getSprites()) {
  for(int i = level2World.getNumSprites() -1; i >=0; i--){

    Sprite spider = level2World.getSprite(i);
    float distance = dist(spider.getX(), spider.getY(), player1.getX(), player1.getY());
    float collisionValNeeded = 35;

    if (distance < collisionValNeeded) {
      System.out.println("Collision detected. Distance: " + distance + " | Player attacking: " + player1.isAttacking());

      //make spider disappear if in attack mode
      if (player1.isAttacking) {
        level2World.removeSprite(spider);
        System.out.println("Spider defeated");
        score+= 30;
        health -= 5;
        spiderCount--;
        println("Spider count in level 2: " + spiderCount);

      //if not, then lose health
      } else {
        health -= 10;
        score-= 20;
        System.out.println("Hit by spider");
      }

      System.out.println("Player health: " + health);
    }
  }
  }

}

//method to indicate when the main game is over
public boolean isGameOver(){
  if (health <= 0)
  {
    return true;
  }
  return false;
}

//method to describe what happens after the game is over
public void endGame(){
    System.out.println("Game Over!");

    //Update the title bar

    //Show any end imagery
    if (health <= 0)
    {
      currentScreen = deathScreen;
    }
    else
    {
    currentScreen = endScreen;
    }
}
