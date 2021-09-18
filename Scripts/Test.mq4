//+------------------------------------------------------------------+
//|                                                         Test.mq4 |
//|                                                Myron Apostolakis |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Myron Apostolakis"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
int magicNB = 77777;
// #property show_inputs
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+

#include <CustomFunctions.mqh>

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnStart()
  {

// bollingerBandsTrading()
// pipsTrading();
   Alert("");
// Alert("Stop level: "+MarketInfo(NULL, MODE_STOPLEVEL));

    Alert("Test 123");
   if(IsTradingAllowed())
     {
      Alert("Doing some trading");
      //
      // double optimalLotSize = OptimalLotSize(maxRiskPrc, maxLossInPips);

      // Alert("optimalLotSize: " + optimalLotSize);

      // double optimalLotSize_ = OptimalLotSize(maxRiskPrc, 1.17749, 1.17949);

      // Alert("optimalLotSize_: " + optimalLotSize_);

      if(CheckIfOpenOrdersByMagicNB(magicNB))
        {
         Alert("There is already an order. Do not send any more orders");
        }
      else
        {
         bollingerBandsTradingTest(magicNB);
        }

      // Print("Hello");
     }
  }

//+------------------------------------------------------------------+
