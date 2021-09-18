//+------------------------------------------------------------------+
//|                                                BB 2 Bands MR.mq4 |
//|                                                Myron Apostolakis |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Myron Apostolakis"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#include <CustomFunctions.mqh>
//--- show input parameters
#property show_inputs

extern double maxRiskPrc = 0.02;
extern double maxLossInPips = 20;
extern double minimalDistance =  0.0001;
extern int rsiMinLevel = 40;
extern int rsiMaxLevel = 60;

int magicNB = 55555;
int orderId;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   Alert("");
   Alert("The BB 2 Bands MR EA has started");
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   Alert("");
   Alert("The BB 2 Bands MR EA just closed");
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {

   int bbPeriod = 50;
   double smallDeviation = 1.0;
   double meanDeviation = 2.0;
   double bigDeviation = 6.0;
   int rsiPeriod = 14;

// Alert("The Ask just updated to: " + Ask);

   if(IsTradingAllowed())
     {
      Alert("");
      Alert("Doing some trading");

      // bollinger  bands calculation

      double smallBolligerBandsMain = NormalizeDouble(iBands(NULL,0,bbPeriod, smallDeviation, 0, PRICE_CLOSE, MODE_MAIN, 0), _Digits);
      double smallBolligerBandsUpper =  NormalizeDouble(iBands(NULL,0,bbPeriod, smallDeviation, 0, PRICE_CLOSE, MODE_UPPER, 0), _Digits);
      double smallBolligerBandsLower = NormalizeDouble(iBands(NULL,0,bbPeriod, smallDeviation, 0, PRICE_CLOSE, MODE_LOWER, 0), _Digits);

      double meanBolligerBandsMain = NormalizeDouble(iBands(NULL,0,bbPeriod, meanDeviation, 0, PRICE_CLOSE, MODE_MAIN, 0), _Digits);
      double meanBolligerBandsUpper = NormalizeDouble(iBands(NULL,0,bbPeriod, meanDeviation, 0, PRICE_CLOSE, MODE_UPPER, 0), _Digits);
      double meanBolligerBandsLower = NormalizeDouble(iBands(NULL,0,bbPeriod, meanDeviation, 0, PRICE_CLOSE, MODE_LOWER, 0), _Digits);

      double bigBolligerBandsMain = NormalizeDouble(iBands(NULL,0,bbPeriod, bigDeviation, 0, PRICE_CLOSE, MODE_MAIN, 0), _Digits);
      double bigBolligerBandsUpper = NormalizeDouble(iBands(NULL,0,bbPeriod, bigDeviation, 0, PRICE_CLOSE, MODE_UPPER, 0), _Digits);
      double bigBolligerBandsLower = NormalizeDouble(iBands(NULL,0,bbPeriod, bigDeviation, 0, PRICE_CLOSE, MODE_LOWER, 0), _Digits);

      double rsi = iRSI(NULL, 0, rsiPeriod, PRICE_CLOSE, 0);

      if(CheckIfOpenOrdersByMagicNB(magicNB))
        {

         double currentMidLine;

         Alert("There is already an open  order. Do not send any more orders. Update Order conditionally");
         // update order

         // select order
         if(OrderSelect(orderId, SELECT_BY_TICKET) == true)
           {
            int orderType = OrderType(); // 0 - Long, 1- Short

            double optimalTakeProfit;
            double optimalStopLoss = OrderOpenPrice();

            double optimalNewPrice;

            if(orderType == 0)
              {
               // long position
               optimalTakeProfit = NormalizeDouble(smallBolligerBandsUpper, _Digits);

               optimalNewPrice = Ask;

               // thelw na ginetai auto otan to OrderOpenPrice einai megalitero apo to bigBolligerBandsUpper
               double tempOptimalStopLoss = NormalizeDouble(bigBolligerBandsLower, _Digits);

               if(OrderOpenPrice() > tempOptimalStopLoss)
                 {
                  optimalStopLoss = tempOptimalStopLoss;
                 }
             
              }
            else
              {
               // short position

               optimalTakeProfit = NormalizeDouble(smallBolligerBandsLower, _Digits);

                  // thelw na ginetai auto otan to OrderOpenPrice einai mikrotero apo to bigBolligerBandsUpper

                  double tempOptimalStopLoss = NormalizeDouble(bigBolligerBandsUpper, _Digits);

               if(OrderOpenPrice() < tempOptimalStopLoss)
                 {
                  optimalStopLoss = tempOptimalStopLoss;
                 }
              
               optimalNewPrice = Bid;
              }

            double TP = OrderTakeProfit();
            double TPdistance = MathAbs(TP - optimalTakeProfit);

            if(TP != currentMidLine && TPdistance > minimalDistance)
              {

               bool Ans = OrderModify(orderId, optimalNewPrice, optimalStopLoss, optimalTakeProfit, 0);

               if(Ans == true)
                 {
                  Alert("Modified order: #" + orderId);
                 }
               else
                 {
                  Alert("Unable to modify order");
                 }
              }
           }

        }
      else
        {

         orderId = bollinger2BandsTrading(
                      magicNB,
                      smallBolligerBandsMain,
                      smallBolligerBandsUpper,
                      smallBolligerBandsLower,

                      meanBolligerBandsMain,
                      meanBolligerBandsUpper,
                      meanBolligerBandsLower,

                      bigBolligerBandsMain,
                      bigBolligerBandsUpper,
                      bigBolligerBandsLower,

                      rsi,
                      rsiMinLevel,
                      rsiMaxLevel,

                      maxRiskPrc,
                      maxLossInPips
                   );
        }

     }
  }
//+------------------------------------------------------------------+
