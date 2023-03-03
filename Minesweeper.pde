import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
public final static int NUM_ROWS = 5;
public final static int NUM_COLS = 5;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined


void setup ()
{
  size(400, 400);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make( this );

  //your code to initialize buttons goes here
  buttons = new MSButton[NUM_ROWS][NUM_COLS]; //first call to new makes apts
  for (int r = 0; r< NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++) {
      buttons[r][c] = new MSButton(r, c); //second call to new makes the objects
    }
  }


  setMines();
}
public void setMines()
{
  while (mines.size() < 5) {
    int r = (int)(Math.random()*3);
    int c = (int)(Math.random()*3);
    if (!mines.contains(buttons[r][c]) ) {
      mines.add(buttons[r][c]);
      System.out.println(r + " " + c);
    }
  }
}

public void draw ()
{
  background( 0 );
  if (isWon() == true)
    displayWinningMessage();
}
public boolean isWon()
{
      for (int r = 0; r < NUM_ROWS; r++){
        for (int c = 0; c < NUM_COLS; c++){
        if (!buttons[r][c].clicked && !mines.contains(buttons[r][c]))
          return false;
      }
    }
    return true;
}
public void displayLosingMessage()
{
    buttons[1][1].myLabel= "Y";
    buttons[1][2].myLabel= "O";
    buttons[1][3].myLabel= "U";
    buttons[2][0].myLabel= "L";
    buttons[2][1].myLabel= "O";
    buttons[2][2].myLabel= "S";
    buttons[2][3].myLabel= "E";
    for(int r = 0; r < NUM_ROWS; r++)
      for(int c = 0; c < NUM_COLS; c++)
        if(mines.contains(buttons[r][c]) && buttons[r][c].clicked == false)
          buttons[r][c].mousePressed();
    noLoop();


}
public void displayWinningMessage()
{
   buttons[1][1].myLabel= "Y";
    buttons[1][2].myLabel= "O";
    buttons[1][3].myLabel= "U";
    buttons[2][1].myLabel= "W";
    buttons[2][2].myLabel= "I";
    buttons[2][3].myLabel= "N";

}
public boolean isValid(int r, int c)
{
  if (r>= 0 && r<buttons.length && c>=0 && c< buttons[r].length)
    return true;
  return false;
}
public int countMines(int row, int col)
{

  int numMines = 0;
  for (int i = -1; i <= 1; i++) {
    for (int j = -1; j <= 1; j++) {
      if (i == 0 && j == 0)
        j+=1;
      if (isValid(row+i, col+j) && mines.contains(buttons[row + i][col + j]))
        numMines+=1;
    }
  }
  return numMines;
}
public class MSButton
{
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;

  public MSButton ( int row, int col )
  {
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed () 


  {
    clicked = true;
    if (mouseButton == RIGHT) {
      flagged = !flagged;
      if (flagged == false) {
        clicked = false;
      }
    } else if (mines.contains(this)) {
      displayLosingMessage();
    } else if (countMines(myRow, myCol) > 0) {
      setLabel(countMines(myRow, myCol));
    } else {
      for (int r = myRow-1; r < myRow+2; r++) {
        for (int c = myCol-1; c < myCol+2; c++) {
          if (isValid(r, c) && buttons[r][c].clicked == false) {
            buttons[r][c].mousePressed();
          }
        }
      }
    }
  }



  public void draw () 
  {    
    if (flagged)
      fill(0);
    else if ( clicked && mines.contains(this) ) 
      fill(255, 0, 0);
    else if (clicked)
      fill( 200 );
    else 
    fill( 100 );

    rect(x, y, width, height);
    fill(0);
    text(myLabel, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel)
  {
    myLabel = newLabel;
  }
  public void setLabel(int newLabel)
  {
    myLabel = ""+ newLabel;
  }
  public boolean isFlagged()
  {
    return flagged;
  }
}
