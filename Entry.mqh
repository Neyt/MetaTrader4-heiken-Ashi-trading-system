//+------------------------------------------------------------------+
//|                                                   Entry_rule.mqh |
//|                                      Copyright 2018, Mater_Forex |
//|             https://www.mql5.com/en/users/Master_Forex/portfolio |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, Mater_Forex" // The company name

#property link      "https://www.mql5.com/en/users/Master_Forex/portfolio" //Link to the company website or profile

#property strict      // Compiler directive for strict compilation mode (the #property strict property has been introduced to provide maximum compatibility with the previous approach to developing MQL4 programs)

#define CLOSE_BUY 2   // define variable CLOSE_BUY

#define CLOSE_SELL 3  // define variable CLOSE_SELL

double high=0, low=0; // define variable(type double) called as high and low (https://docs.mql4.com/basis/types)

datetime Bar;         // define variable(datatime) called as Bar (https://docs.mql4.com/basis/types)

//OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO//
//+------------------------------------------------------------------+
//|  Variable to get the values from the custom indicators           |   
//+------------------------------------------------------------------+
double ha(int buff,int shift){ return(iCustom(NULL,0,"Heiken Ashi",buff,shift));}   //Calculates the specified custom indicator and returns its value (https://docs.mql4.com/indicators/icustom).
//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH//  
//+------------------------------------------------------------------+
//| Function to get "Entry Signals"                                  |   
//+------------------------------------------------------------------+
int OPEN() 
{      
//+------------------------------------------------------------------+   
   if(Bar != iTime(NULL,0,0))   // Check if variable Bar is not equal to time of current candle(bar) //// This function will get any values on opening of every candle (not every tick)
     { 
      high=GetHiLo(0);          // Then variable high is equal to value of function GetHiLo(0)
      
      low=GetHiLo(1);           // Then variable low is equal to value of function GetHiLo(1)
    
      Bar=iTime(NULL,0,0);      // Then variable Bar is equal to time of current candle(bar)
     } 
//+------------------------------------------------------------------+ 
   if(high <= Bid && high > ND(ha(2,0)) && high+2*points() > Bid) return(OP_BUY); // Check and get entry signals for BUY
   
   if(low >= Bid && low < ND(ha(2,0)) && low-2*points() < Bid) return(OP_SELL);   // Check and get entry signals for SELL    

   return(-1); // End of function
}    
//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH//  
//+------------------------------------------------------------------+
//| Function to get "Exit Signals"                                   |   
//+------------------------------------------------------------------+
int CLOSE() 
{      
//+------------------------------------------------------------------+   
   if(Bar != iTime(NULL,0,0))   // Check if variable Bar is not equal to time of current candle(bar) //// This function will get any values on opening of every candle (not every tick)
     { 
      high=GetHiLo(0);          // Then variable high is equal to value of function GetHiLo(0)
      
      low=GetHiLo(1);           // Then variable low is equal to value of function GetHiLo(1)
    
      Bar=iTime(NULL,0,0);      // Then variable Bar is equal to time of current candle(bar)
     } 
//+------------------------------------------------------------------+
   
   if(low >= Bid && low < ND(ha(2,0))) return(CLOSE_BUY);     // Check and get exit(close) signals for BUY
   
   if(high <= Bid && high > ND(ha(2,0))) return(CLOSE_SELL);  // Check and get exit(close) signals for SELL    
   
   return(-1);  // End of function
}    
//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH//   
//+------------------------------------------------------------------+
//|  Get value of highest or lowest of Heiken Ashi candles           |
//+------------------------------------------------------------------+
double GetHiLo(int ty=-1) 
{
  int i, k=iBars(NULL, 0), ke=0, ks=0, ne=0;

  for(i=1; i<k; i++) // Check values of Heiken Ashi candles among existing candles(bars) in history(k)
     { 
      if(ND(ha(3,i+5)) > ND(ha(2,i+5)) && ND(ha(3,i+4)) > ND(ha(2,i+4)) && ND(ha(3,i+3)) > ND(ha(2,i+3)) && ND(ha(3,i+2)) < ND(ha(2,i+2)) && ND(ha(3,i+1)) < // Get value of HIGH of Heiken Ashi by your rule 
         ND(ha(2,i+1)) && ND(ha(3,i)) < ND(ha(2,i))){ ks++; if(ks>ne && ty==0) 
         
         return(MathMax(MathMax(MathMax(ND(ha(1,i+5)),ND(ha(1,i+4))),MathMax(ND(ha(1,i+3)),ND(ha(0,i+2)))),MathMax(ND(ha(0,i+1)),ND(ha(0,i)))));}            // Return value of HIGH of Heiken Ashi (https://docs.mql4.com/math/mathmax)
    
      if(ND(ha(3,i+5)) < ND(ha(2,i+5)) && ND(ha(3,i+4)) < ND(ha(2,i+4)) && ND(ha(3,i+3)) < ND(ha(2,i+3)) && ND(ha(3,i+2)) > ND(ha(2,i+2)) && ND(ha(3,i+1)) > // Get value of LOW of Heiken Ashi by your rule 
         ND(ha(2,i+1)) && ND(ha(3,i)) > ND(ha(2,i))){ ke++; if(ke>ne && ty==1) 
         
         return(MathMin(MathMin(MathMin(ND(ha(1,i+5)),ND(ha(1,i+4))),MathMin(ND(ha(1,i+3)),ND(ha(0,i+2)))),MathMin(ND(ha(0,i+1)),ND(ha(0,i)))));}            // Return value of LOW of Heiken Ashi (https://docs.mql4.com/math/mathmin)  
     } 
  return(-1);  // End of function
}  
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~+
double ND(double price) // function to get setted value as normalized
{
   if(price > 0) return(NormalizeDouble(price,8)); // https://docs.mql4.com/convert/normalizedouble
   
   return(0);  // End of function
}
//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH//
//+------------------------------------------------------------------+
//| Check Symbol Points                                              |  // Auto checking value of points to this Symbol
//+------------------------------------------------------------------+     
double points(string symbol=NULL)  
{  
   string sym=symbol; if(symbol==NULL) sym=Symbol();             
   
   double bid=MarketInfo(sym,MODE_BID);          // Get value of BID to this Symbol  
   
   int digits=(int)MarketInfo(sym,MODE_DIGITS);  // Get value of digits to this Symbol  
   
   if(digits<=1) return(1); // Symbol is CFD or Indexes  
   
   if(digits==4 || digits==5) return(0.0001); // Symbol is 4 or 5 digits
   
   if((digits==2 || digits==3) && bid>1000) return(1); // Symbol is 2 or 3 digits (CFD or Indexes)
   
   if((digits==2 || digits==3) && bid<1000) return(0.01); // Symbol is 2 or 3 digits (JPY)
   
   if(StringFind(sym,"XAU")>-1 || StringFind(sym,"xau")>-1 || StringFind(sym,"GOLD")>-1) return(0.1);//Symbol is Gold (XAUUSD)
   
   return(0);  // End of function
}    
//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH//
 