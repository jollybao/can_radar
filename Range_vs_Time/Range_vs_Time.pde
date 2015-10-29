/*
Jialun Bao
10/29/2015
*/

import ddf.minim.*;
import ddf.minim.analysis.*;
import javax.swing.*; 


SecondApplet s;
Minim minim;
AudioInput input;
FFT fft;
PFont font;
float c=3*pow(10,8);    //speed of light
float ramp=100*pow(10,6)/(20*pow(10,-3));    //frequency changing rate
float dist;
float prev=0;
int t=0;
int scale=10;    


void setup(){
  size(512, 300);
  stroke(255);
  
  //loading texts
  font=loadFont("ARBERKLEY-48.vlw");
  textFont(font);
  textSize(20);
  
  //naming first window
  frame.setTitle("Spectrum");
  
  //create a new window
  PFrame f = new PFrame(1024,400);
  f.setTitle("Range vs Time");
  f.setResizable(true);
  
  minim = new Minim(this); 
  // use the getLineIn method of the Minim object to get an AudioInput
  input = minim.getLineIn(Minim.STEREO,4096);
  // bufer size of 4096 and sample rate 44.1 kHz
  fft = new FFT(4096,44100);
}

void draw()
{
  background(0);
  int highest=0;
  //perform fft on left channel buffer
  fft.forward(input.left);
  
 
 //only look for the frist 512 bands, find the dominant band
 for(int i = 0; i < 512; i++)
  {
     // draw the waveforms so we can see what we are monitoring 
    line( i, 50 + input.left.get(i)*50, i+1, 50 + input.left.get(i+1)*50 );
    line( i, 150 + input.right.get(i)*50, i+1, 150 + input.right.get(i+1)*50 );
    
    line(i,height,i,height-fft.getBand(i));
    if (fft.getBand(i)>fft.getBand(highest))
      highest=i;
  }
  
  
 // String monitoringState = in.isMonitoring() ? "enabled" : "disabled";
 // text( "Input monitoring is currently " + monitoringState + ".", 5, 15 );
 
 //scale up to find the dominant frequency
  highest=highest*44100/4096;
  dist=highest/ramp*c;
}

public class PFrame extends JFrame {
  public PFrame(int width, int height) {
    setBounds(100, 100, width, height);
    s = new SecondApplet();
    add(s);
    s.init();
    show();
  }
}

public class SecondApplet extends PApplet {
  boolean axis=true; 
  public void setup() { 
      background(0);
      textFont(font);
      textSize(20);
  }
  
  public void draw() {
    //draw axis
    if(axis){
        axis();
        axis=false;
    }
    //plot distance vs time
    line(t,prev,t+1,height-scale*dist);
    prev=height-scale*dist;
    t++;   
  }
  
  
  public void axis(){
    stroke(255);
    for(int i=height; i>0;i-=10*scale){
        line(0,i,20,i);
        text((height-i)/scale,10,i-15);
    }
 
}
  public void keyPressed()
{
    /*
  if ( key == 'm' || key == 'M' )
  {
    if ( in.isMonitoring() )
    {
      in.disableMonitoring();
    }
    else
    {
      in.enableMonitoring();
    }
  }
  */
  if (key == 'r'|| key == 'R'){
       t=0;
       prev=0;
       axis=true;
       background(0);
  }
}
  
}
