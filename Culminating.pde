/* //<>//
 Description: This program is a game where players must catch the most amount of fruits that matches the basket that are falling from the top of the screen
 Author:  Emily Wang
 Date of last edit: June 15, 2017
 */

float [] xValues, yValues, ySpeeds, fruit;
boolean [] fruitScore;
float basketX, basketY, fruitOnBasket;
PImage homeScreenPic, gamePic, basketPic, bananaPic, pearPic, applePic, instructionScreenPic, gameOverScreenPic;
boolean play, instruction, gameOver;
int startTime, score;
int amountOfCircles = 100;
int fruitTimer = 0;

void settings() {
  fullScreen();
}

void setup() {
  startTime=60; //game lasts 60 seconds

  //loads all the images needed for the game
  homeScreenPic=loadImage("home screen.png");
  homeScreenPic.resize(width, height);
  gamePic=loadImage("game.png");
  gamePic.resize(width, height);
  basketPic=loadImage("basket.png");
  basketPic.resize(width/5, height/5);
  applePic=loadImage("apple.png");
  applePic.resize(width/15, height/15);
  pearPic=loadImage("pear.png");
  pearPic.resize(width/15, height/15);
  bananaPic=loadImage("banana.png");
  bananaPic.resize(width/15, height/15);
  instructionScreenPic=loadImage("Instructions.png");
  instructionScreenPic.resize(width, height);
  gameOverScreenPic=loadImage("Game Over.png");
  gameOverScreenPic.resize(width, height);

  //size of arrays
  xValues = new float[amountOfCircles];
  yValues = new float[amountOfCircles];
  ySpeeds = new float[amountOfCircles];
  fruit= new float[amountOfCircles];
  fruitScore= new boolean[amountOfCircles];

  for (int i = 0; i < amountOfCircles; i++) {
    yValues[i] = -width/20; //y value for fruit
    xValues[i] = random(0, width-width/15); //x value for fruit 
    ySpeeds[i] = random(1, 2.5); // speed of fruit
    fruit[i]=floor(random(3)); //picks between three fruit
    fruitScore[i]=true;
  }
}

void draw() {
  //switching between different screens
  if (!play && !instruction && !gameOver) { 
    homeScreen();
    frameCount=0;
  }
  if (play && !instruction && !gameOver) {
    gameScreen();
  } 
  if (!play && instruction && !gameOver) {
    instructionScreen();
  }
  if (gameOver && !play && !instruction ) {  
    gameOverScreen();
  }
}

void mousePressed() {
  //buttons on the home page
  if (!play && !instruction && !gameOver) {
    if (mouseX>width*.43 && mouseX<width*.58 && mouseY>height*.75 && mouseY<height*0.86) {//play button
      play = true; 
      instruction=false;
      gameOver= false;
    }
    if (mouseX>width*.4 && mouseX<.63*width && mouseY>height*.91 && mouseY<height*.98) {//instructions button
      instruction=true;
      gameOver= false;
      play= false;
    }
  }

  //button on instruction page 
  if (!play && instruction && !gameOver) {
    if (mouseX>width*.87 && mouseX<width*0.98 &&  mouseY>height*.9  && mouseY<height*.96) {//play button
      instruction=false;
      play=true;
    }
    if ( mouseX>width*.03 && mouseX<width*0.15 &&  mouseY>height*.9  && mouseY<height*.97) {//return button
      instruction=false;
    }
  }
  //buttons on game over page
  if (gameOver && !instruction && !play) {
    if (mouseX>width*.41 && mouseX<width*0.645 &&  mouseY>height*0.76  && mouseY<height*.845) {//back to home screen
      gameOver=false;
      reset();
    }
    if (mouseX>width*.41 && mouseX<width*0.645 &&  mouseY>height*0.611  && mouseY<height*.69) {//play button
      gameOver=false;
      reset();
      play=true;
    }
  }
}

void keyPressed() {
  //moves the basket
  if ((play && !instruction && !gameOver)) {
    if (keyCode==LEFT && basketX+width/2-width/14>=0) //moves basket left
    {
      basketX=basketX-12;
    } 
    if (keyCode==RIGHT && basketX+width/2+width/14<=width ) //moves basket right
    {
      basketX=basketX+12;
    }
  }
}

void homeScreen() {
  image(homeScreenPic, 0, 0); //sets background to image
}

void gameScreen() {
  image(gamePic, 0, 0);

  int timer = (startTime*60-frameCount)/60; //timer that counts down from 60 
  textSize(50);
  fill(0);
  text(timer, 0, 40);

  if (timer==0 && !instruction && !gameOver && play) {   //After 60 seconds have pass, the game ends and the gameover screen will pop out
    gameOver = true;
    play=false;
  }
  if (fruitTimer <60*60) {
    fruitTimer++;
  } 
  //fruit moves and falls from top of screen every second
  for (int i = 0; i < fruitTimer/60; i++) {
    yValues[i] += ySpeeds[i];
  }
  //depending on value in array, different fruit falls
  for (int i = 0; i < fruit.length; i++) {
    if (fruit[i] == 0) {
      image(bananaPic, xValues[i], yValues[i]);
    }
    if (fruit[i] == 1) {
      image(applePic, xValues[i], yValues[i]);
    }
    if (fruit[i] == 2) {
      image(pearPic, xValues[i], yValues[i]);
    }
  }
  //basket image starts in middle of screen
  image(basketPic, basketX+width/2-width/10, height-height/6);

  //depending on value in array, different fruit is displayed on basket
  if (fruitOnBasket == 0) {
    image(bananaPic, basketX+width/2-width/25, height-height/12);
  }
  if (fruitOnBasket == 1) {
    image(applePic, basketX+width/2-width/25, height-height/12);
  }
  if (fruitOnBasket == 2) {
    image(pearPic, basketX+width/2-width/25, height-height/12);
  }
  if (fruitTimer % 600==0) {
    fruitOnBasket=(floor(random(3))); //every 10 sec the fruit on the basket changes
  }

  //scoring
  //if correct fruit is within certain distance to basket, 2 points added to score
  for (int i=0; i<amountOfCircles; i++) {
    if (dist(basketX+width/2-width/20, height-height/45, xValues[i], yValues[i]) <= width/11 && fruit[i]==fruitOnBasket && fruitScore[i]==true) {
      fruitScore[i] =false;
      score=score+2;
      yValues[i]=height+50; //makes the fruit go offscreen to look like it has been caught by basket
    }
    //if wrong fruit is within certain distance to basket, 1 point deducted from score
    if (dist(basketX+width/2-width/20, height-height/45, xValues[i], yValues[i]) <= width/11 && fruit[i]!=fruitOnBasket && fruitScore[i]==true) {
      score=score-1;
      fruitScore[i]= false;
      yValues[i]=height+50;
    }
  }

  //display score on screen
  fill(0);
  text(score, width*.93, height*.08);
}

void gameOverScreen() {
  image(gameOverScreenPic, 0, 0);
  textSize(width/20+height/20);   //displays final score
  text(score, .45*width, 2*height/5);
}

void instructionScreen() {
  image(instructionScreenPic, 0, 0);
}

void reset() {
  //resets values for when game is replayed
  setup();
  fruitTimer=0;
  frameCount=0;
  score=0;
}