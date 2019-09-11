//x and y together capture the coordinates (squares really) of the snake as it
//has squares added to the front (when it advances) and removed from the rear 
//when it does not hit the apple).
ArrayList<Integer> x = new ArrayList <Integer>();
ArrayList<Integer> y = new ArrayList <Integer>();
ArrayList<Integer> deathx = new ArrayList <Integer>();
ArrayList<Integer> deathy = new ArrayList <Integer>();
//Note that height and width are variables provided by the Processing environment
//so we don't want to override them in our code, hence w and h for variable names.
int w = 30;              //Width of the board
int h = 30;              //Height of the board
int bs = 20;             //block size
/* dx and dy are direction vectors.  The dir variable indexs into dx and dy
to control the direction the snake takes for the next advance. A value of 0
for dir means that dx is 0 and dy is 1, which sends the snake south.  1 sends
the snake north, 2 sends it east and 3 sends it west.  Remember that the 
coordinates increase as we move away from origin in the upper left corner of the 
screen.*/
int [] dx = {0, 0, 1, -1};
int [] dy = {1, -1, 0, 0};
int dir = 2;             //The next direction to take for the snake
int death_dir = 1;       //The next direction to take for the death snake
//Coordinates of the apple.  The snake gets longer each time it "eats" the apple.
int applex = 12;
int appley = 10;

int randomx = 0;
int randomy = 0;
int randx = 0;
int randy = 0;

ArrayList<Integer> minex = new ArrayList <Integer>();
ArrayList<Integer> miney = new ArrayList <Integer>();
boolean gameover = false;      //flag to show whether game is done or not.
int [] colors = {#266C1B, #E89E25, #2D3FDE, #C10A35, #EBF018};
final int initialFrameRate = 30;
void setup () {
  //600 = width * bs and height * bs.  If you change any of those three variables,
  //be sure to change the arguments to the size function accordingly.
  size (600, 600);            //size will only take literals, not variables
  x.add(5);              //Just a random starting position for the snake
  y.add(5);
  deathx.add(15);              //Just a random starting position for the death snake
  deathy.add(28);
  frameRate (initialFrameRate);              //start slow to make the game easier.
}
void draw () {
  background(255);            //make the background white
  //Create a grid pattern on the screen with vertical and horizontal lines
  for (int i = 0; i < width; i++) {
    line (i*bs, 0, i*bs, height);
  }
  for (int i = 0; i < height; i++) {
    line (0, i * bs, width, i * bs);
  }
  for (int i = 0; i < x.size(); i++) {      //draw the snake
//    fill(0, 255, 0);
    fill(colors[i % colors.length]);
    rect(x.get(i)*bs, y.get(i)*bs, bs, bs);
  }
  for (int i = 0; i < deathx.size(); i++) {      //draw the death snake
//    fill(0, 255, 0);
    fill(#000000);
    rect(deathx.get(i)*bs, deathy.get(i)*bs, bs, bs);
  }
  if (!gameover) {
    //draw the apple
    fill(255, 0, 0);
    rect(applex * bs, appley * bs, bs, bs);
  }    
  if (!gameover) {
    //draw the mines
    fill(0, 0, 0);
    for (int i = 0; i < minex.size(); i++) {
        rect(minex.get(i)*bs, miney.get(i)*bs, bs, bs);}
  }    
  if (!gameover) {
    if (frameCount % 5 == 0) {
      x.add(0, x.get(0) + dx[dir]);
      y.add(0, y.get(0) + dy[dir]);
      deathx.add(0, deathx.get(0) + dx[death_dir]);
      deathy.add(0, deathy.get(0) + dy[death_dir]);
      //Make sure that we do not run off the edge of the board
      if (x.get(0) < 0 || y.get(0) < 0 || x.get(0) >= w || y.get(0) >= h)
      {
        gameover = true;
      }
      
      //deathSnakeBorderDetection();
      //deathSnakeCollisionDetection();
      
      //See if we've ran into ourself
      for(int i = 0; i < x.size(); i++) {
        if(x.get(0) == x.get(i) && y.get(0) == y.get(i)) {
          gameover = true;
        }
      }
      
      //See if we've hit the apple
      if(x.get(0) == applex && y.get(0) == appley) {
        randx = (int) random(0, w);      //Reposition the apple
        randy = (int) random(0, h);      //Don't make the snake shorter
        frameRate(frameRate + frameRate / 10);
        
        //generates a mine in a random location once the apple is eaten
        randomx = (int) random(0, w);
        randomy = (int) random(0, h);
        while (randomx == randx && randomy == randy) {
                randomx = (int) random(0, w);
                randomy = (int) random(0, h);
                randx = (int) random(0, w);
                randy = (int) random(0, h);
                println("Random mine was the same as apple");
            }
        for (int i = 0; i < minex.size(); i++) {
            while (randomx == minex.get(i) && randomy == miney.get(i)) {
                randomx = (int) random(0, w);
                randomy = (int) random(0, h);
                println("Random mine was the same as an old mine");
            }
        }
        applex = randx;
        appley = randy;
        minex.add(randomx);
        miney.add(randomy);    
      } else {                      //Trim off the last element in the snake
        x.remove(x.size() - 1);
        y.remove(y.size() - 1);
        deathx.remove(deathx.size() - 1);
        deathy.remove(deathy.size() - 1);
      }
      //insert condition if snake hits a mine
      for (int i = 0; i < minex.size(); i++) {
            if (x.get(0) == minex.get(i) && y.get(0) == miney.get(i)) {
                gameover = true;
            }
        }
    }
  } else if (gameover) {
    fill (0);
    textSize(30);
    textAlign(CENTER);
    text("GAME OVER. Press space bar to resume.", width/2, height/2);
    if(keyPressed && key == ' ') {      //user wants to resume
      frameRate(initialFrameRate);      //start over with the speed of the game
      x.clear();
      y.clear();
      minex.clear();
      miney.clear();
      x.add(5);
      y.add(5);
      deathx.clear();
      deathy.clear();
      deathx.add(15);
      deathy.add(28);
      gameover = false;
    }
  }
}
void keyPressed () 
{
  /*
  The "a" key starts the snake going left, "d" sends it right, "w" sends it up 
  and "s" sends it down.  The way to remember which is which is by their position
  on the qwerty keyboard.
  
  The dir variable is the index into the dx and dy vectors that we use when we add
  a new set of x,y coordinates to the front of the arraylist of points that represents
  our snake.
  */
  println("Key pressed is: " + key);
  int newdir = key == ('s') | (keyCode == DOWN) ? 0 : (key == ('w') | (keyCode == UP) ? 1 : (key == ('d') | (keyCode == RIGHT) ? 2 : (key == ('a') | (keyCode == LEFT) ? 3 : -1)));
  if (newdir != -1)
  {
    dir = newdir;
    deathSnakeDirection();
  }
}

void deathSnakeDirection()
{
  int new_death_dir = int(random(4)); //Generate a random int to determine new direction
  if (new_death_dir == death_dir)     //If the new direction is the same as the old, change it
  {
    new_death_dir = new_death_dir + 1;
    if (new_death_dir >= 4)
    {
      new_death_dir = 0;
    }
  }
  death_dir = new_death_dir; //Update the direction of the death snake
}

void deathSnakeBorderDetection()
{
  if (deathx.get(0) - 1 < 0) // If run into left border, go down
      {
        death_dir = 2;
      }
  else if(deathy.get(0) - 1 < 0)
      {
        death_dir = 0;
      }
  else if (deathx.get(0) + 1 >= w)
      {
        death_dir = 3;
      } 
  else if (deathy.get(0) + 1 >= h)
      {
        death_dir = 1;
      }
}

void deathSnakeCollisionDetection()
{
  for (int t = 0; t < x.size(); ++t)
  {
    if ((deathx.get(0) == x.get(t)) | (deathx.get(t) == x.get(0)) && ((deathy.get(0) == y.get(t)) | (deathy.get(t) == y.get(0))))
    {
      gameover = true;
    }
  }
}

void snakeCollisionDetection()
{
  for (int r = 0; r < x.size(); ++r)
  {
    if (x.get(0) == deathx.get(r) && y.get(0) == deathy.get(r))
    {
      gameover = true;
    }
  }
}
