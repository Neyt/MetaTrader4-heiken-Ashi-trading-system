//+------------------------------------------------------------------+
//|                                               PositionSizing.mqh |
//|                                      Copyright 2018, Mater_Forex |
//|             https://www.mql5.com/en/users/Master_Forex/portfolio |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, Mater_Forex" // The company name

#property link      "https://www.mql5.com/en/users/Master_Forex/portfolio" //Link to the company website or profile

#property strict               // Compiler directive for strict compilation mode (the #property strict property has been introduced to provide maximum compatibility with the previous approach to developing MQL4 programs)

double Highs=0, Lows=0, rnd=1; // define variable(type double) called as highs\lows\rnd (https://docs.mql4.com/basis/types)

datetime bar;                 // define variable(datatime) called as bar (https://docs.mql4.com/basis/types)
//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH//
//+------------------------------------------------------------------+
//| Calculate Trade Size(Lot)                                        |
//+------------------------------------------------------------------+
double LotSize(int OP, double lot, double percent)
{ 
   double ask=MarketInfo(Symbol(),MODE_ASK);      // Get value of ASK to this Symbol (https://docs.mql4.com/constants/environment_state/marketinfoconstants)
   
   double bid=MarketInfo(Symbol(),MODE_BID);      // Get value of BID to this Symbol (https://docs.mql4.com/constants/environment_state/marketinfoconstants)
   
   double ls=MarketInfo(Symbol(),MODE_LOTSTEP);   // Get value of LOT STEP to this Symbol (https://docs.mql4.com/constants/environment_state/marketinfoconstants)
   
   int dig=(int)MarketInfo(Symbol(),MODE_DIGITS); // Get value of DIGITS to this Symbol (https://docs.mql4.com/constants/environment_state/marketinfoconstants)
   
   int lotdigit=0; double SL=0;
       
   if(ls==1) lotdigit=0;                          // if LOT STEP is 1 then lotdigit = 0
   
   if(ls==0.1) lotdigit=1;                        // if LOT STEP is 0.1 then lotdigit = 1
   
   if(ls==0.01) lotdigit=2;                       // if LOT STEP is 0.01 then lotdigit = 2
   
   if(dig==4 || dig==5) rnd = 0.01;               // if DIGITS is 4 or 5 then rnd = 0 .01
   
//+------------------------------------------------------------------+   
   if(bar != iTime(NULL,0,0))     // Check if variable bar is not equal to time of current candle(bar) //// This function will get any values on opening of every candle (not every tick)
     { 
      Highs=hilo(0);              // Then variable high is equal to value of function hilo(0)
      
      Lows=hilo(1);               // Then variable low is equal to value of function hilo(1)
    
      bar=iTime(NULL,0,0);        // Then variable bar is equal to time of current candle(bar)
     } 
//+------------------------------------------------------------------+   
   double lots = lot, 
     
   LotSize = MarketInfo(Symbol(),MODE_LOTSIZE) * MarketInfo(Symbol(),MODE_TICKVALUE), // Get value of LOTSIZE to this Symbol (https://docs.mql4.com/constants/environment_state/marketinfoconstants)
  
   MaxLot = MarketInfo(Symbol(),MODE_MAXLOT),                                         // Get value of MAXLOT to this Symbol (https://docs.mql4.com/constants/environment_state/marketinfoconstants)
   
   MinLot = MarketInfo(Symbol(),MODE_MINLOT);                                         // Get value of MINLOT to this Symbol (https://docs.mql4.com/constants/environment_state/marketinfoconstants)
   
   if(OP==OP_BUY) SL = ask-Lows;                                                      // Get value of Stop Loss for BUY order
   
   if(OP==OP_SELL) SL = Highs-bid;                                                    // Get value of Stop Loss for SELL order  
   
   if(percent > 0) lots = NormalizeDouble((percent*rnd*AccountBalance())/(SL*LotSize), lotdigit); // Calculating of lots size by value of setted % and stop loss
           
   return( MathRound(MathMin(MathMax(lots,MinLot),MaxLot)/ls)*ls );                   // return final size of lots
}   
//OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO//
//+------------------------------------------------------------------+
//|  Variable to get the values from the custom indicators           |   
//+------------------------------------------------------------------+
double Ha(int buff,int shift){ return(iCustom(NULL,0,"Heiken Ashi",buff,shift));}   //Calculates the specified custom indicator and returns its value (https://docs.mql4.com/indicators/icustom).
//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH//    
//+------------------------------------------------------------------+
//|  Get value of highest or lowest of Heiken Ashi candles           |
//+------------------------------------------------------------------+
double hilo(int ty=-1) 
{
  int i, k=iBars(NULL, 0), ke=0, ks=0, ne=0;

  for(i=1; i<k; i++) // Check values of Heiken Ashi candles among existing candles(bars) in history(k)
     { 
      if(Nd(Ha(3,i+5)) > Nd(Ha(2,i+5)) && Nd(Ha(3,i+4)) > Nd(Ha(2,i+4)) && Nd(Ha(3,i+3)) > Nd(Ha(2,i+3)) && Nd(Ha(3,i+2)) < Nd(Ha(2,i+2)) && Nd(Ha(3,i+1)) < // Get value of HIGH of Heiken Ashi by your rule 
         Nd(Ha(2,i+1)) && Nd(Ha(3,i)) < Nd(Ha(2,i))){ ks++; if(ks>ne && ty==0) 
         
         return(MathMax(MathMax(MathMax(Nd(Ha(1,i+5)),Nd(Ha(1,i+4))),MathMax(Nd(Ha(1,i+3)),Nd(Ha(0,i+2)))),MathMax(Nd(Ha(0,i+1)),Nd(Ha(0,i)))));}            // Return value of HIGH of Heiken Ashi (https://docs.mql4.com/math/mathmax)
    
      if(Nd(Ha(3,i+5)) < Nd(Ha(2,i+5)) && Nd(Ha(3,i+4)) < Nd(Ha(2,i+4)) && Nd(Ha(3,i+3)) < Nd(Ha(2,i+3)) && Nd(Ha(3,i+2)) > Nd(Ha(2,i+2)) && Nd(Ha(3,i+1)) > // Get value of LOW of Heiken Ashi by your rule 
         Nd(Ha(2,i+1)) && Nd(Ha(3,i)) > Nd(Ha(2,i))){ ke++; if(ke>ne && ty==1) 
         
         return(MathMin(MathMin(MathMin(Nd(Ha(1,i+5)),Nd(Ha(1,i+4))),MathMin(Nd(Ha(1,i+3)),Nd(Ha(0,i+2)))),MathMin(Nd(Ha(0,i+1)),Nd(Ha(0,i)))));}            // Return value of LOW of Heiken Ashi (https://docs.mql4.com/math/mathmin)  
     } 
  return(-1);  // End of function
}  
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~+
double Nd(double price)     // function to get setted value as normalized
{
   if(price > 0) return(NormalizeDouble(price,8)); // https://docs.mql4.com/convert/normalizedouble
   
   return(0);  // End of function
}
//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH//