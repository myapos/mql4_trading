//+------------------------------------------------------------------+
//|                                                BB Test Strat.mq4 |
//|                                                Myron Apostolakis |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Myron Apostolakis"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#include <CustomFunctions.mqh>

int magicNB = 88888;
int orderId;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   Alert("");
   Alert("The EA has started");
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   Alert("The EA just closed");
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {

   int period = 20;
   double smallDeviation = 1.0;
   double bigDeviation = 4.0;

   // Alert("The Ask just updated to: " + Ask);

   if(IsTradingAllowed())
     {
      Alert("Doing some trading");

      // bollinger  bands calculation

      double smallBolligerBandsMain = NormalizeDouble(iBands(NULL,0,period, smallDeviation, 0, PRICE_CLOSE, MODE_MAIN, 0), _Digits);
      double smallBolligerBandsUpper =  NormalizeDouble(iBands(NULL,0,period, smallDeviation, 0, PRICE_CLOSE, MODE_UPPER, 0), _Digits);
      double smallBolligerBandsLower = NormalizeDouble(iBands(NULL,0,period, smallDeviation, 0, PRICE_CLOSE, MODE_LOWER, 0), _Digits);

      double bigBolligerBandsMain = NormalizeDouble(iBands(NULL,0,period, bigDeviation, 0, PRICE_CLOSE, MODE_MAIN, 0), _Digits);
      double bigBolligerBandsUpper = NormalizeDouble(iBands(NULL,0,period, bigDeviation, 0, PRICE_CLOSE, MODE_UPPER, 0), _Digits);
      double bigBolligerBandsLower = NormalizeDouble(iBands(NULL,0,period, bigDeviation, 0, PRICE_CLOSE, MODE_LOWER, 0), _Digits);

      if(CheckIfOpenOrdersByMagicNB(magicNB))
        {
         Alert("There is already an open  order. Do not send any more orders");
         // update order

         // select order
         if(OrderSelect(orderId, SELECT_BY_TICKET) == true)
           {
            int orderType = OrderType(); // 0 - Long, 1- Short

            double currentMidLine = NormalizeDouble(smallBolligerBandsMain, _Digits);
            double TP = OrderTakeProfit();

            if(TP != currentMidLine )
              {

               bool Ans = OrderModify(orderId, OrderOpenPrice(), OrderStopLoss(), currentMidLine, 0);

               if(Ans == true)
                 {
                  Alert("Modified order: #" + orderId);
                 }
              }
           }

        }
      else
        {
         orderId = bollingerBandsTradingTest(magicNB, smallBolligerBandsMain, smallBolligerBandsUpper, smallBolligerBandsLower, bigBolligerBandsMain, bigBolligerBandsUpper, bigBolligerBandsLower);
        }

     }
  }
//+------------------------------------------------------------------+
