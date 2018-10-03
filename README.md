# MetaTrader4-heiken-Ashi-trading-system
A heiken Ashi indicator trading system

Metatrader 4 System

varibles to create
time frame
what is a high
what is a low

Time frame variable = 1 Hour (this is a variable, since we could chose other time frames)


Entry rule (entry.mp4):
Use A heiken Ashi indicator, to define trends:

A high is defined as: 3 (this 3 should be a variable that we can manipulate) BLUE heiken Ashi candles followed by 3 RED candles.

A low is defined as: 3 (this 3 should be a variable that we can manipulate) RED heiken Ashi candles followed by 3 BLUE candles.


Set a limit in the last high and last low:

If no transactions are open:

When last high is broken (surpassed) then buy.

When last low is broken then sell

If we have a bullish open position (bough contracts):

when last high is broken, do nothing.

When last low is broken then close position, and sell another one. Now we are bearish.

If we have a bearish open position (sold contracts):

when last high is broken,close position, and BUY. Now we are bullish, going up.

When last low is broken then do nothing.




image example https://c.mql5.com/21/38/heiken-ashi-candle-color-change-alerts-serie-mt5-screen-5240.png


Stop loss rule (StopLoss.mp4):
Set stop in the last high or low. (as in entry.mp4)

If we sell, the set stop in the last high

If we buy, set stop in the last low


Position sizing Rules (how much to buy) (PositionSizing.mp4):
Create a variable called "__%" of the account risked. 
Example: 1%. And divide that 1% of the account for the # of pips to the last high or low.

That will equal the number of contract we can buy.




Print on screen (Comment)
Units (microlots) = ___

1 pip = __ $USD

Trade Value =   ___USD

Margin Used =  ___USD

Take Profit in USD= ___

Take Profit in PIPS =___

Stop loss in USD =___

Stop loss in PIPS = ___

Risk reward ratio =___
