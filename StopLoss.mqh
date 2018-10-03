//+------------------------------------------------------------------+
//|                                                     StopLoss.mqh |
//|                                      Copyright 2018, Mater_Forex |
//|             https://www.mql5.com/en/users/Master_Forex/portfolio |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, Mater_Forex" // The company name

#property link      "https://www.mql5.com/en/users/Master_Forex/portfolio" //Link to the company website or profile

#property strict      // Compiler directive for strict compilation mode (the #property strict property has been introduced to provide maximum compatibility with the previous approach to developing MQL4 programs)

double highs=0, lows=0; // define variable(type double) called as highs and lows (https://docs.mql4.com/basis/types)

datetime Bari;         // define variable(datatime) called as Bari (https://docs.mql4.com/basis/types)

//OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO//
//+------------------------------------------------------------------+
//|  Variable to get the values from the custom indicators           |   
//+------------------------------------------------------------------+
double HA(int buff,int shift){ return(iCustom(NULL,0,"Heiken Ashi",buff,shift));}   //Calculates the specified custom indicator and returns its value (https://docs.mql4.com/indicators/icustom).
//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH// 
//+------------------------------------------------------------------+
//| Get Entry Signals                                                |   
//+------------------------------------------------------------------+
double SL(int OP) 
{      
//+------------------------------------------------------------------+   
   if(Bari != iTime(NULL,0,0))    // Check if variable Bar is not equal to time of current candle(bar) //// This function will get any values on opening of every candle (not every tick)
     { 
      highs=HiLo(0);              // Then variable high is equal to value of function HiLo(0)
      
      lows=HiLo(1);               // Then variable low is equal to value of function HiLo(1)
    
      Bari=iTime(NULL,0,0);       // Then variable Bari is equal to time of current candle(bar)
     } 
//+------------------------------------------------------------------+ 
   if(OP==OP_BUY) return(lows);   // Check and get value of Stop Loss for BUY
   
   if(OP==OP_SELL) return(highs); // Check and get value of Stop Loss for SELL

   return(-1); // End of function
}      
//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH//   
//+------------------------------------------------------------------+
//|  Get value of highest or lowest of Heiken Ashi candles           |
//+------------------------------------------------------------------+
double HiLo(int ty=-1) 
{
  int i, k=iBars(NULL, 0), ke=0, ks=0, ne=0;

  for(i=1; i<k; i++) // Check values of Heiken Ashi candles among existing candles(bars) in history(k)
     { 
      if(nd(HA(3,i+5)) > nd(HA(2,i+5)) && nd(HA(3,i+4)) > nd(HA(2,i+4)) && nd(HA(3,i+3)) > nd(HA(2,i+3)) && nd(HA(3,i+2)) < nd(HA(2,i+2)) && nd(HA(3,i+1)) < // Get value of HIGH of Heiken Ashi by your rule 
         nd(HA(2,i+1)) && nd(HA(3,i)) < nd(HA(2,i))){ ks++; if(ks>ne && ty==0) 
         
         return(MathMax(MathMax(MathMax(nd(HA(1,i+5)),nd(HA(1,i+4))),MathMax(nd(HA(1,i+3)),nd(HA(0,i+2)))),MathMax(nd(HA(0,i+1)),nd(HA(0,i)))));}            // Return value of HIGH of Heiken Ashi (https://docs.mql4.com/math/mathmax)
    
      if(nd(HA(3,i+5)) < nd(HA(2,i+5)) && nd(HA(3,i+4)) < nd(HA(2,i+4)) && nd(HA(3,i+3)) < nd(HA(2,i+3)) && nd(HA(3,i+2)) > nd(HA(2,i+2)) && nd(HA(3,i+1)) > // Get value of LOW of Heiken Ashi by your rule 
         nd(HA(2,i+1)) && nd(HA(3,i)) > nd(HA(2,i))){ ke++; if(ke>ne && ty==1) 
         
         return(MathMin(MathMin(MathMin(nd(HA(1,i+5)),nd(HA(1,i+4))),MathMin(nd(HA(1,i+3)),nd(HA(0,i+2)))),MathMin(nd(HA(0,i+1)),nd(HA(0,i)))));}            // Return value of LOW of Heiken Ashi (https://docs.mql4.com/math/mathmin)  
     } 
  return(-1);  // End of function
}  
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~+
double nd(double price)     // function to get setted value as normalized
{
   if(price > 0) return(NormalizeDouble(price,8)); // https://docs.mql4.com/convert/normalizedouble
   
   return(0);  // End of function
}
//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH//   
