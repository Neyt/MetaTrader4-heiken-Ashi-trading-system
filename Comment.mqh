//+------------------------------------------------------------------+
//|                                                      Comment.mqh |
//|                                      Copyright 2018, Mater_Forex |
//|             https://www.mql5.com/en/users/Master_Forex/portfolio |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, Mater_Forex" // The company name

#property link      "https://www.mql5.com/en/users/Master_Forex/portfolio" //Link to the company website or profile

#property strict    // Compiler directive for strict compilation mode (the #property strict property has been introduced to provide maximum compatibility with the previous approach to developing MQL4 programs)

//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH// 
//+------------------------------------------------------------------+
//| Get info to comment                                              |
//+------------------------------------------------------------------+
void CM(int mn)
{    
    double tv=MarketInfo(Symbol(),MODE_TICKVALUE);         // Get value of TICKVALUE to this Symbol (https://docs.mql4.com/constants/environment_state/marketinfoconstants)  
    
    double bid=MarketInfo(Symbol(),MODE_BID);              // Get value of BID to this Symbol (https://docs.mql4.com/constants/environment_state/marketinfoconstants)
    
    int dig=(int)MarketInfo(Symbol(),MODE_DIGITS), pip=10; // Get value of DIGITS to this Symbol (https://docs.mql4.com/constants/environment_state/marketinfoconstants)
    
    if(dig==4 || (bid<1000 && dig==2)) pip=1;              // Check Symbol digits is 4 or 5 (2 or 3 for JPY pair)
    
        
    double tpp=0;  if(Get(2,mn) > 0) tpp=MathAbs(Get(3,mn)-Get(2,mn))/pts(); // Get value of Take Profit in pips
    
    double slp=0;  if(Get(1,mn) > 0) slp=MathAbs(Get(3,mn)-Get(1,mn))/pts(); // Get value of Stop Loss in pips
    
    double tpu=0;  if(Get(2,mn) > 0) tpu=tpp*Get(0,mn)*tv*pip;               // Get value of Take Profit in USD
    
    double slu=0;  if(Get(1,mn) > 0) slu=slp*Get(0,mn)*tv*pip;               // Get value of Stop Loss in USD
    
    double rr=0;   if(slp > 0 && tpp > 0) rr= slp/tpp;                       // Get value of Risk reward ratio 
    
             
    Comment("\n","\n",                                                       // Set values to Comment function
    "-------------------------------------------","\n","\n",  
    "Units (microlots) = " + DoubleToStr(MarketInfo(Symbol(),MODE_MINLOT),2),"\n","\n",   
    "1 pip = " + DoubleToStr(tv,2)+" USD","\n","\n",   
    "-------------------------------------------","\n","\n",   
    "Trade Value = " + DoubleToStr(Get(0,mn),2),"\n","\n",
    "Margin Used = " + DoubleToStr(AccountMargin(),1),"\n","\n",
    "Take Profit in USD = " + DoubleToStr(tpu,1),"\n","\n",
    "Take Profit in PIPS = " + DoubleToStr(tpp,1),"\n","\n",
    "Stop loss in USD = " + DoubleToStr(slu,1),"\n","\n",    
    "Stop loss in PIPS = " + DoubleToStr(slp,1),"\n","\n",
    "Risk reward ratio = " + DoubleToStr(rr,1),"\n","\n",  
    "-------------------------------------------");
}     
//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH//
//+------------------------------------------------------------------+
//| Get the values of latest open order                              |
//+------------------------------------------------------------------+
double Get(int ty=0, int mn=0)
{
   int PrevTicket=0, CurrTicket=0;
   
   for(int i = 0; i < OrdersTotal(); i++)                          // Check existing all(total) open orders into this account (https://docs.mql4.com/trading/orderstotal)
      {
       bool OrSel = OrderSelect(i, SELECT_BY_POS, MODE_TRADES);    // Check existing OPEN orders only (https://docs.mql4.com/trading/orderselect)
       
       if(OrderSymbol() == Symbol() &&                             // Check Symbol of open order which should be same with Symbol of chart which the EA is attached (https://docs.mql4.com/trading/ordersymbol)
         (mn == 0 || OrderMagicNumber() == mn))                    // Check Magic Number of open order which should be same with Magic Number of the EA (https://docs.mql4.com/trading/ordermagicnumber) 
         {
          CurrTicket = OrderTicket();
          
          if(CurrTicket > PrevTicket)                              // if "Current Ticket" > "Previous Ticket" 
            {
             PrevTicket = CurrTicket;                              // then "Previous Ticket" = "Current Ticket" 
             
             if(ty==0) return(OrderLots());                        // then if ty = 0 return Lots of latest order
             
             if(ty==1) return(OrderStopLoss());                    // then if ty = 1 return Stop Loss of latest order
             
             if(ty==2) return(OrderTakeProfit());                  // then if ty = 2 return Take Profit of latest order
             
             if(ty==3) return(OrderOpenPrice());                   // then if ty = 3 return Open Price of latest order
            }
         }   
      }   
   return(0);  // End of function
}    
//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH//
//+------------------------------------------------------------------+
//| Check Symbol Points                                              |  // Auto checking value of points to this Symbol
//+------------------------------------------------------------------+     
double pts(string symbol=NULL)  
{  
   string sym=symbol; if(symbol==NULL) sym=Symbol();             
   
   double bid=MarketInfo(sym,MODE_BID);                   // Get value of BID to this Symbol  
   
   int digits=(int)MarketInfo(sym,MODE_DIGITS);           // Get value of digits to this Symbol  
   
   if(digits<=1) return(1);                               // Symbol is CFD or Indexes  
   
   if(digits==4 || digits==5) return(0.0001);             // Symbol is 4 or 5 digits
   
   if((digits==2 || digits==3) && bid>1000) return(1);    // Symbol is 2 or 3 digits (CFD or Indexes)
   
   if((digits==2 || digits==3) && bid<1000) return(0.01); // Symbol is 2 or 3 digits (JPY)
   
   if(StringFind(sym,"XAU")>-1 || StringFind(sym,"xau")>-1 || StringFind(sym,"GOLD")>-1) return(0.1); // Symbol is Gold (XAUUSD)
   
   return(0);  // End of function
}   
//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH//
