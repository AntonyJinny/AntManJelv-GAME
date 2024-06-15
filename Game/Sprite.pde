/* Sprite class - to create objects that move around with their own properties
 * Inspired by Daniel Shiffman's p5js Animated Sprite tutorial
 * Note: Picture coordinate origina at top, left corner
 * Author: Joel Bianchi
 * Last Edit: 6/10/24
 * Added getName() method for easier tracking of categories of sprites
 */

public class Sprite {
  
  //------------------ SPRITE FIELDS --------------------//
  PImage normalImage;
  PImage attackingImage;
  boolean isAttacking = false;
  private long lastAttackTime = 0;
  private static final long ATTACK_COOLDOWN = 3000;
  private String spriteImageFile;
  private String name;
  private float centerX;
  private float centerY;
  private float speedX;
  private float speedY;
  private float w;
  private float h;
  private boolean isAnimated;
  float scale;


  //------------------ SPRITE CONSTRUCTORS --------------------//

  public Sprite(String normalImageFile, String attackingImageFile, float scale) {

    this.normalImage = loadImage(normalImageFile);
    this.attackingImage = loadImage(attackingImageFile);
    this.scale = scale;

    if(normalImage != null) {
    normalImage.resize((int)(normalImage.width * scale), (int)(normalImage.height * scale));
    }

    if(attackingImage != null) {
    attackingImage.resize((int)(attackingImage.width * scale), (int)(attackingImage.height * scale));
    }

  } 

  


  // Sprite Constructor #1: Only pass in the image file (Non-animated)
  public Sprite(String spriteImageFile){
    this(spriteImageFile, 1.0, 0.0, 0.0, false);
  }

  // Sprite Constructor #2: Only pass in the image file that can be scaled (Non-animated)
  public Sprite(String spriteImageFile, float scale){
    this(spriteImageFile, scale, 0.0, 0.0, false);
  }

  // Sprite Constructor #3: for Non-Animated Sprite
  public Sprite(String spriteImageFile, float scale, float x, float y) {
    this(spriteImageFile, scale, x, y, false);
  }

  // Sprite Constructor #4: for ANY Sprite
  public Sprite(String spriteImageFile, float scale, float x, float y, boolean isAnimated) {
    this.spriteImageFile = spriteImageFile;
    this.scale = scale;
    setLeft(x);
    setTop(y);
    this.speedX = 0;
    this.speedY = 0;
    this.isAnimated = isAnimated;
    
      if( spriteImageFile != null){
        this.normalImage = loadImage(spriteImageFile);

        if(normalImage != null) {
        w = normalImage.width * scale;
        h = normalImage.height * scale;
      } 

    }
  }



  //------------------ SPRITE MOTION METHODS --------------------//
boolean isAttacking() {
    return isAttacking;
  }


void toggleAttack() {

  long currentTime = System.currentTimeMillis();

  if( currentTime - lastAttackTime >= ATTACK_COOLDOWN) {
    isAttacking = !isAttacking;
    lastAttackTime = currentTime;
  } else {
    System.out.println("Attack mode cooling down. Wait 3 seconds.");
  }

    if(isAttacking == true) {
      System.out.println("ATTACK MODE!");
    } else if (isAttacking == false) {
      System.out.println("Deactivated.");
    }
  }

public boolean canAttack() {

  long currentTime = System.currentTimeMillis();
  return (currentTime - lastAttackTime >= ATTACK_COOLDOWN);
}

public void attack() {

  if(canAttack()) {
    lastAttackTime = System.currentTimeMillis();
  }
}




  void display() {
    if (isAttacking && attackingImage != null) {
      image(attackingImage, getLeft(), getTop());
    } else if (normalImage != null) {
      image(normalImage, getLeft(), getTop());
    }
  }

  // method to display the Sprite image on the screen
  public void show() {
    if (normalImage != null) {
        image(normalImage, getLeft(), getTop(), w, h);
    
    }
  }

  // method to move Sprite image on the screen to a specific coordinate
  public void moveTo(float x, float y){
    setLeft(x);
    setTop(y);
  }

  // method to move Sprite image on the screen relative to current position
  public void move(float changeX, float changeY){
    this.centerX += changeX;
    this.centerY += changeY;
    //System.out.println(getLeft() + "," + getTop());
  }

  //method to change the speed of the Sprite
  public void setSpeed( float speedX, float speedY){
    this.speedX = speedX;
    this.speedY = speedY;
  }


  // method to rotate Sprite image on the screen
  public void rotate(float degrees){
    float rads = radians(degrees);
    translate(centerX,centerY);
    rotate(rads);
  }



  //------------------ SPRITE COORDINATES ACCESSOR & MUTATOR METHODS --------------------//

  public float getW(){
    return w;
  }
  public float getH(){
    return h;
  }
  public float getCenterX(){
    return centerX;
  }
  public float getCenterY(){
    return centerY;
  }
  public float getX(){
    return getCenterX();
  }
  public float getY(){
    return getCenterY();
  }

  public void setW(float w){
    this.w = w;
  }
  public void setH(float h){
    this.h=h;
  }
  public void setCenterX(float centerX){
    this.centerX = centerX;
  }
  public void setCenterY(float centerY){
    this.centerY=centerY;
  }
  
  
  /*------------------ SPRITE BOUNDARY METHODS  --------------------
   * -- Used from Long Bao Nguyen
   *  -- https://longbaonguyen.github.io/courses/platformer/platformer.html
   */
  void setLeft(float left){
    centerX = left + w/2;
  }
  float getLeft(){
    return centerX - w/2;
  }
  void setRight(float right){
    centerX = right - w/2;
  }
  float getRight(){
    return centerX + w/2;
  }
  void setTop(float top){
    centerY = top + h/2;
  }
  float getTop(){
    return centerY - h/2;
  }
  void setBottom(float bottom){
    centerY = bottom - h/2;
  }
  float getBottom(){
    return centerY + h/2;
  }

  //------------------ SPRITE IMAGE & ANIMATION METHODS --------------------//

  //Accessor method to the Sprite object
  public PImage getImage(){
    return this.normalImage;
  }
  //Mutator method to the Sprite object
  public void setImage(PImage img){
    this.normalImage = img;
  }

  //Accessor method to check if Sprite object is animated
  public boolean getIsAnimated(){
    return isAnimated;
  }
  //Mutator method to change if Sprite object is animated
  public void setIsAnimated(boolean a){
    isAnimated = a;
  }

  //Accessor method to the image path of the Sprite
  public String getImagePath(){
    return this.spriteImageFile;
  }

  //Method to be used to compare 2 sprites by a name, will check the image file name if no name specified
  public String getName(){
    if(name == null){
      return getImagePath();
    } else {
      return name;
    }
  }

  //Sets the Sprites name to be used for comparisons
  public void setName(String name){
    this.name = name;
  }


  //Method to copy a Sprite to a specific location
  public Sprite copyTo(float x, float y){

    PImage si = this.normalImage;
    String sif = this.spriteImageFile;
    float cx = this.centerX;
    float cy = this.centerY;
    float sx = this.speedX;
    float sy = this.speedY;
    float w = this.w;
    float h = this.h;
    boolean ia = this.isAnimated;
    
    Sprite sp = new Sprite(sif, 1.0, x, y, ia);
    sp.setSpeed(sx,sy);
    sp.setW(w);
    sp.setH(h);

    return sp;

  }

  public void resize(int width, int height){
    normalImage.resize(width, height);
  }


  // method that automatically moves the Sprite based on its velocity
  public void update(){
    move(speedX, speedY);
  }

  public void update(float deltaTime){
    speedX += deltaTime/1000;
    speedY += deltaTime/1000;
    move(speedX, speedY);
  }

  //Method to copy a Sprite to same location
  public Sprite copy(){
    return copyTo(this.centerX, this.centerY);
  }

  //Method to check if 2 Sprites are the same (based on name or image)
  public boolean equals(Sprite otherSprite){
    if(this.spriteImageFile != null && otherSprite != null && this.getName().equals(otherSprite.getName())){
      return true;
    }
    return false;
  }

  public String toString(){
    return spriteImageFile + "\t" + getLeft() + "\t" + getTop() + "\t" + speedX + "\t" + speedY + "\t" + w + "\t" + h + "\t" + isAnimated;
  }


}
