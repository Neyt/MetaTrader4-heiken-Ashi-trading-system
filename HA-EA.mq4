//+------------------------------------------------------------------+
//|                                                           HA.mq4 |
//|                                      Copyright 2018, Mater_Forex |
//|             https://www.mql5.com/en/users/Master_Forex/portfolio |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, Mater_Forex"

#property link      "https://www.mql5.com/en/users/Master_Forex/portfolio" //Link to the company website or profile

#property version   "1.00" // Program version, maximum 31 characters

#property strict  // Compiler directive for strict compilation mode (the #property strict property has been introduced to provide maximum compatibility with the previous approach to developing MQL4 programs)

#property description "Created - 04.06.2018 01:13"
#property description " "
#property description "Customer: ney123456789 ( https://www.mql5.com/en/users/ney123456789 )"

#include <stdlib.mqh>         // file mqh(include) will used to getting of descriptions of any errors which could comes in MT4 

#include <Entry.mqh>          // call (import) external file mqh
#include <StopLoss.mqh>       // call (import) external file mqh
#include <PositionSizing.mqh> // call (import) external file mqh
#include <Comment.mqh>        // call (import) external file mqh
 
input string EAComment      = "HA EA";// EA Comment 
input double Lot            = 0.01;   // Fixed Lot Size
input double RiskPercent    = 0;      // Risk %   
input double TakeProfit     = 100;    // Take Profit  
input int    MN             = 1;      // Magic Number  
 
//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH//
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
void OnInit() // The OnInit() function is the Init event handler. The Init event is generated immediately after an Expert Advisor or an indicator is downloaded;
{   
   return;   // End of "Expert initialization function" 
}  
//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH//  
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) // The OnDeinit() function is called during deinitialization and is the Deinit event handler.
{ 
   return;  // End of "Expert deinitialization function" 
}  
//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH//
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{ 
//+------------------------------------------------------------------+
   // Check History...
   if(Bars < 10)                                           // Checking the history to get amount of candles(bars) work of EA
     { 
      Print("Not enough bars for working the EA");         // Print as info about reason of stopping of EA
      return;                                              // if it less than 10, then Expert will stop to work!
     } 
   
   CM(MN);                                                 // Show comment
//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH//      
  
   for(int i = 0; i < OrdersTotal(); i++)                          // Check existing all(total) open orders into this account (https://docs.mql4.com/trading/orderstotal)
      {
       bool OrSel = OrderSelect(i, SELECT_BY_POS, MODE_TRADES);    // Check existing OPEN orders only (https://docs.mql4.com/trading/orderselect)
       
       if(OrderSymbol() == Symbol() &&                             // Check Symbol of open order which should be same with Symbol of chart which the EA is attached (https://docs.mql4.com/trading/ordersymbol)
         (MN == 0 || OrderMagicNumber() == MN))                    // Check Magic Number of open order which should be same with Magic Number of the EA (https://docs.mql4.com/trading/ordermagicnumber) 
         {
          if(OrderType() == OP_BUY &&                              // Check type of open order which should be BUY (Market - instant order. https://docs.mql4.com/constants/tradingconstants/orderproperties) 
             CLOSE() == CLOSE_BUY)                                 // Check function of CLOSE() from file Entry.mgh. If it's give signal as "CLOSE_BUY", then close open BUY order 
            {
             bool close = OrderClose(OrderTicket(), OrderLots(), OrderClosePrice(), 0, clrBlue);                            // Close open BUY order (https://docs.mql4.com/trading/orderclose)
             
             int err = GetLastError();if(err!=ERR_NO_ERROR){ Print("Error on Order closing = ", ErrorDescription(err));}    // Check to find and inform about probable errors (https://docs.mql4.com/predefined/_lasterror) 
            }
          if(OrderType() == OP_SELL &&                             // Check type of open order which should be SELL (Market - instant order. https://docs.mql4.com/constants/tradingconstants/orderproperties) 
             CLOSE()==CLOSE_SELL)                                  // Check function of CLOSE() from file Entry.mgh. If it's give signal as "CLOSE_SELL", then close open SELL order 
            {
             bool close = OrderClose(OrderTicket(), OrderLots(), OrderClosePrice(), 0, clrRed);                             // Close open SELL order (https://docs.mql4.com/trading/orderclose) 
            
             int err = GetLastError();if(err!=ERR_NO_ERROR){ Print("Error on Order closing = ", ErrorDescription(err));}    // Check to find and inform about probable errors (https://docs.mql4.com/predefined/_lasterror) 
            } 
         }   
      }     
//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH//       

   if(IsTesting() ||              // Checks if the Expert Advisor runs in the testing mode (https://docs.mql4.com/check/istesting)
     (IsExpertEnabled() &&        // Checks if Expert Advisors are enabled for running (https://docs.mql4.com/check/isexpertenabled) 
      IsTradeAllowed()))          // Checks if the Expert Advisor is allowed to trade and trading context is not busy (https://docs.mql4.com/check/istradeallowed)
     {  
      if(OPEN()==OP_BUY &&        // Check function of OPEN() from file Entry.mgh. If it's give signal as "OP_BUY", then open BUY order 
         1 > Orders(-1))          // Check function of Orders() to get amount of open orders. If it's less than 1 (as 0), then will able to open order
        {  
         double Sloss=SL(OP_BUY), // Check function of SL() from file StopLoss.mgh. If it's set as "OP_BUY", then receive Stop loss for BUY order 
      
         Tprof=0; if(TakeProfit > 0){ Tprof = Ask + TakeProfit * point();} // Check varible TakeProfit is more than 0, then set Take Profit from price of ASK
                    
         int Ticket = OrderSend(Symbol(), OP_BUY, LotSize(OP_BUY,Lot,RiskPercent), Ask, 3, Sloss, Tprof, EAComment, MN, 0, clrBlue); // Open BUY order (https://docs.mql4.com/trading/ordersend)
         
         int err=GetLastError(); if(err!=ERR_NO_ERROR){ Print("Error on opening of order = ", ErrorDescription(err));}  // Check to find and inform about probable errors (https://docs.mql4.com/predefined/_lasterror)
        }       
      if(OPEN()==OP_SELL &&       // Check function of OPEN() from file Entry.mgh. If it's give signal as "OP_SELL", then open SELL order 
         1 > Orders(-1))          // Check function of Orders() to get amount of open orders. If it's less than 1 (as 0), then will able to open order
        { 
         double Sloss=SL(OP_SELL),// Check function of SL() from file StopLoss.mgh. If it's set as "OP_SELL", then receive Stop loss for SELL order  
       
         Tprof=0; if(TakeProfit > 0){ Tprof = Bid - TakeProfit * point();} // Check varible TakeProfit is more than 0, then set Take Profit from price of BID
                          
         int Ticket = OrderSend(Symbol(), OP_SELL, LotSize(OP_SELL,Lot,RiskPercent), Bid, 3, Sloss, Tprof, EAComment, MN, 0, clrRed); // Open SELL order (https://docs.mql4.com/trading/ordersend)
         
         int err=GetLastError(); if(err!=ERR_NO_ERROR){ Print("Error on opening of order = ", ErrorDescription(err));}  // Check to find and inform about probable errors (https://docs.mql4.com/predefined/_lasterror) 
        }        
     }                           
   return; // End of "Expert tick function" 
}      
//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH//
//+------------------------------------------------------------------+
//| Get amount of open orders                                        |
//+------------------------------------------------------------------+
int Orders(int type) //if type: -1= All type orders,0=Buy,1=Sell,2=BuyLimit,3=SellLimit,4=BuyStop,5=SellStop,6=AllBuy,7=AllSell,8=AllMarket,9=AllPending; 
{
   int count=0;
     
   for(int x=OrdersTotal()-1;x>=0;x--)                            // Check existing all(total) open orders into this account (https://docs.mql4.com/trading/orderstotal)
      {
      if(OrderSelect(x,SELECT_BY_POS,MODE_TRADES)){               // Check existing OPEN orders only (https://docs.mql4.com/trading/orderselect)
    
      if(OrderSymbol() == Symbol() &&                             // Check Symbol of open order which should be same with Symbol of chart which the EA is attached (https://docs.mql4.com/trading/ordersymbol)
        (MN == 0 || OrderMagicNumber() == MN))                    // Check Magic Number of open order which should be same with Magic Number of the EA (https://docs.mql4.com/trading/ordermagicnumber) 
        {
         if(type < 0){ count++;}                                  // if type < 0(-1), then get amount of all type(market and pending) orders
        
         if(OrderType() == type && type >= 0){ count++;}          // if type = 0(or >), then get amount of orders by value of type
        
         if(OrderType() <= 1 && type == 8){ count++;}             // if type = 8, then get amount of all type of market orders
        
         if(OrderType() > 1 && type == 9){ count++;}              // if type = 9, then get amount of all type of pending orders 
        
         if((OrderType() == 0 || OrderType() == 2 || OrderType() == 4) && type == 6){ count++;} // if type = 6, then get amount of all type(market and pending) BUY orders
        
         if((OrderType() == 1 || OrderType() == 3 || OrderType() == 5) && type == 7){ count++;} // if type = 7, then get amount of all type(market and pending) SELL orders      
        }}}   
   return(count); // return count 
}      
//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH//
//+------------------------------------------------------------------+
//| Check Symbol Points                                              |  // Auto checking value of points to this Symbol
//+------------------------------------------------------------------+     
double point(string symbol=NULL)  
{  
   string sym=symbol; if(symbol==NULL) sym=Symbol();             
   
   double bid=MarketInfo(sym,MODE_BID);          // Get value of BID to this Symbol  
   
   int digits=(int)MarketInfo(sym,MODE_DIGITS);  // Get value of digits to this Symbol  
   
   if(digits<=1) return(1); // Symbol is CFD or Indexes  
   
   if(digits==4 || digits==5) return(0.0001); // Symbol is 4 or 5 digits
   
   if((digits==2 || digits==3) && bid>1000) return(1); // Symbol is 2 or 3 digits (CFD or Indexes)
   
   if((digits==2 || digits==3) && bid<1000) return(0.01); // Symbol is 2 or 3 digits (JPY)
   
   if(StringFind(sym,"XAU")>-1 || StringFind(sym,"xau")>-1 || StringFind(sym,"GOLD")>-1) return(0.1);//Symbol is Gold (XAUUSD)
   
   return(0);
}    
//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH\\
//                                                                           _________                                                                                    ||
//                                                                          /         \                                                                                   ||
//                                                                         |  THE END  |                                                                                  ||
//                                                                          \_________/                                                                                   ||
//                                                                                                                                                                        ||
//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH//
 