//+------------------------------------------------------------------+
//|                                              CustomFunctions.mqh |
//|                                                Myron Apostolakis |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Myron Apostolakis"
#property link      "https://www.mql5.com"
#property strict

//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+
double GetStopLossPrice(bool isLongPosition, double entryPrice, int maxLossInPips)
  {
   double stopLossPrice;

   if(isLongPosition)
     {
      stopLossPrice = entryPrice - (maxLossInPips * 0.0001);
     }
   else
     {
      stopLossPrice = entryPrice + (maxLossInPips * 0.0001);
     }

   return stopLossPrice;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetPipValue()
  {
   double pipValue = 0.0001;

   if(_Digits < 4)
     {
      pipValue = 0.01;
     }
   return pipValue;
  }


//--- Arguments should be
//--- Arg 1: signalPrice
//--- Arg 2: takeProfitPips


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CalculateTakeProfit(bool isLong, double entryPrice, int pips)
  {
   double takeProfit;
// Alert("Ask:"+ Ask);
// Alert("Bid:"+ Bid);
   if(isLong)
     {
      //--- buy
      takeProfit = entryPrice + pips * GetPipValue();
     }
   else
     {
      //--- short
      takeProfit = entryPrice - pips * GetPipValue();
     }

   return takeProfit;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CalculateStopLoss(bool isLong, double entryPrice, int pips)
  {

   double stopLossPrice;
//-- Alert("Ask:"+ Ask);
//-- Alert("Bid:"+ Bid);

   if(isLong)
     {
      //--- buy
      stopLossPrice = entryPrice - pips * GetPipValue();
     }
   else
     {
      //--- short
      stopLossPrice = entryPrice + pips * GetPipValue();
     }

   return stopLossPrice;
  }


//--- Arguments should be
//--- Arg 1: signalPrice
//--- Arg 2: takeProfitPips


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CalculateTakeProfit___(double signalPrice, int takeProfitPips)
  {
   double takeProfit;
//-- Alert("Ask"+ Ask);
//-- Alert("Bid"+ Bid);
   if(Ask < signalPrice)
     {
      Alert("buy");
      //--- buy
      takeProfit = Ask + takeProfitPips * GetPipValue();
     }
   else
      if(Bid > signalPrice)
        {
         Alert("short");
         //--- short
         takeProfit = Bid - takeProfitPips * GetPipValue();
        }

   return takeProfit;
  }

//--- Arguments should be
//--- Arg 1: signalPrice
//--- Arg 2: stopLossPips


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CalculateStopLoss___(double signalPrice, int stopLossPips)
  {

   double stopLossPrice;
//-- Alert("Ask"+ Ask);
//-- Alert("Bid"+ Bid);

   if(Ask < signalPrice)
     {
      Alert("buy");
      //--- buy
      stopLossPrice = Ask - stopLossPips * GetPipValue();
     }
   else
      if(Bid > signalPrice)
        {
         Alert("short");
         //--- short
         stopLossPrice = Bid + stopLossPips * GetPipValue();
        }

   return stopLossPrice;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int bollingerBandsTradingTest(
   int magicNB,
   double smallBolligerBandsMain,
   double smallBolligerBandsUpper,
   double smallBolligerBandsLower,
   double bigBolligerBandsMain,
   double bigBolligerBandsUpper,
   double bigBolligerBandsLower)
  {


   double maxRiskPrc = 0.02;
   double maxLossInPips = 20;
   double takeProfit;
   double stopLoss;
   int orderId;

   Alert("");
   Alert("smallBolligerBandsMain: " + smallBolligerBandsMain);
   Alert("smallBolligerBandsUpper: " + smallBolligerBandsUpper);
   Alert("smallBolligerBandsLower: " + smallBolligerBandsLower);

   Alert("bigBolligerBandsMain: " + bigBolligerBandsMain);
   Alert("bigBolligerBandsUpper: " + bigBolligerBandsUpper);
   Alert("bigBolligerBandsLower: " + bigBolligerBandsLower);

   Alert("Ask:"+Ask);
   Alert("Bid:"+Bid);

   if(Ask < smallBolligerBandsLower)
     {
      // long position
      Alert("Entering long position");
      Alert("Entry price: " + Ask);
      takeProfit = smallBolligerBandsMain;
      stopLoss = bigBolligerBandsLower;

      double optLotsSize = OptimalLotSize(maxRiskPrc, Ask, stopLoss);
      Alert("optLotsSize: " + optLotsSize);
      // send buy order
      orderId = OrderSend(NULL, OP_BUYLIMIT,optLotsSize, Ask, 10, stopLoss, takeProfit, NULL, magicNB);
      Alert("orderId: "+orderId);
     }
   else
      if(Bid > smallBolligerBandsUpper)
        {
         // short position
         Alert("Entering short position");
         Alert("Entry price: " + Bid);
         takeProfit = bigBolligerBandsMain;
         stopLoss = bigBolligerBandsUpper;

         double optLotsSize = OptimalLotSize(maxRiskPrc, Bid, stopLoss);
         Alert("optLotsSize: " + optLotsSize);
         // send short order
         orderId = OrderSend(NULL, OP_SELLLIMIT, 0.01, Bid, 10, stopLoss, takeProfit, NULL, magicNB);
         Alert("orderId: "+orderId);
        }
      else
         if(takeProfit > 0 || stopLoss > 0)
           {
            Alert("takeProfit:" + takeProfit);
            Alert("stopLoss:" + stopLoss);
           }
         else
           {
            Alert("Waiting to place order");
           }



   /*
   if(orderId < 0 ) {
      Alert("OrderSend failed with error #" + GetLastError());
   } else {
      Alert("OrderSend placed successfully");
   }
   */

   return orderId;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void pipsTrading()
  {
   Alert(" ");

   int takeProfitPips = 30;
   int stopLossPips = 40;

// Alert(GetStopLossPrice(true, 1.6265, 20));
// Alert("Account balance = ",AccountBalance());
// Alert("Account #",AccountNumber(), " leverage is ", AccountLeverage());

   double signalPrice = 1.5515;


   if(Ask < signalPrice)
     {

      Alert("buy");
      // Alert("takeProfitPips: "+ takeProfitPips);
      // Alert("stopLossPips: "+ stopLossPips);
      //--- buy
      double takeProfit = CalculateTakeProfit(true, Ask, takeProfitPips);
      Alert("takeProfit:" + takeProfit);
      double stopLossPrice = CalculateStopLoss(true, Ask, stopLossPips);
      Alert("stopLossPrice:" + stopLossPrice);
      Alert("entryPrice:" + Ask);

     }
   else
      if(Bid > signalPrice)
        {

         Alert("sell"+ takeProfitPips);
         double takeProfit = CalculateTakeProfit(false, Bid, takeProfitPips);
         Alert("takeProfit:" + takeProfit);
         double stopLossPrice = CalculateStopLoss(false, Bid, stopLossPips);
         Alert("stopLossPrice:" + stopLossPrice);
         Alert("entryPrice:" + Bid);

        }

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool IsTradingAllowed()
  {

   if(false && IsMarketClosed())
     {

      Alert("Market is closed");
      return false;
     }
   if(!IsTradeAllowed())
     {
      Alert("Expert Advisor is NOT allowed to trade. Check AutoTrading");
      return false;
     }

   if(!IsTradeAllowed(Symbol(), TimeCurrent()))
     {
      Alert("Trading is NOT allowed for specific Symbol and Time");
      return false;
     }
   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool IsMarketClosed()
  {
   return MarketInfo(Symbol(), MODE_TRADEALLOWED) == true;
  }

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Test()
  {
   Alert("");
   Alert("Test");
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double OptimalLotSize(double maxRiskPrc, int maxLossInPips)
  {
   Print("Account lot: " + SymbolInfoDouble(NULL, SYMBOL_TRADE_CONTRACT_SIZE));
   Print("Minimum Lot: " + MarketInfo(NULL, MODE_MINLOT));

   double accEquity = AccountEquity() / 1; // use 1/100

   Print("accEquity: " + accEquity);

   double lotSize = MarketInfo(NULL,MODE_LOTSIZE);

   Print("lotSize: " + lotSize);

   double tickValue = NormalizeDouble(MarketInfo(NULL,MODE_TICKVALUE),2);

   if(Digits <= 3)
     {
      Alert("Digits < 3 before: " + tickValue);
      tickValue = tickValue / 100;
     }

   Print("tickValue: " + tickValue);

   double maxLossEuros = accEquity * maxRiskPrc;

   Print("maxLossEuros: " + maxLossEuros);

   double maxLossInQuoteCurrency = maxLossEuros / tickValue;

   Print("maxLossInQuoteCurrency: " + maxLossInQuoteCurrency);


   double ar1 = maxLossInQuoteCurrency;
   double ar2 = maxLossInPips * GetPipValue();
   Alert("------------ ar2: " + ar2);
   double optimalLotSize = NormalizeDouble((ar1 / ar2) / lotSize, 2);

   return optimalLotSize;

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double OptimalLotSize(double maxRiskPrc, double entryPrice, double stopLoss)
  {

   int maxLossInPips = MathAbs(entryPrice - stopLoss)/GetPipValue();

   Alert("maxLossInPips: " + maxLossInPips);

   return OptimalLotSize(maxRiskPrc, maxLossInPips);

  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CheckIfOpenOrdersByMagicNB(int magicNB)
  {


   int openOrders = OrdersTotal();

   for(int i=0; i< openOrders; i++)
     {
      if(OrderSelect(i, SELECT_BY_POS) == true)
        {
         Alert("This expert advisor already sent order");
         return true;
        }
     }

   return false;
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int bollinger2BandsTrading(
   int magicNB,
   double smallBolligerBandsMain,
   double smallBolligerBandsUpper,
   double smallBolligerBandsLower,

   double meanBolligerBandsMain,
   double meanBolligerBandsUpper,
   double meanBolligerBandsLower,

   double bigBolligerBandsMain,
   double bigBolligerBandsUpper,
   double bigBolligerBandsLower,

   double rsi)
  {

   double takeProfit;
   double stopLoss;
   int orderId;
   double maxRiskPrc = 0.02;
   double maxLossInPips = 20;

// prints

   Alert("smallBolligerBandsMain: " + smallBolligerBandsMain);
   Alert("smallBolligerBandsUpper: " + smallBolligerBandsUpper);
   Alert("smallBolligerBandsLower: " + smallBolligerBandsLower);
   Alert("");
   Alert("meanBolligerBandsMain: " + meanBolligerBandsMain);
   Alert("meanBolligerBandsUpper: " + meanBolligerBandsUpper);
   Alert("meanBolligerBandsLower: " + meanBolligerBandsLower);
   Alert("");
   Alert("bigBolligerBandsMain: " + bigBolligerBandsMain);
   Alert("bigBolligerBandsUpper: " + bigBolligerBandsUpper);
   Alert("bigBolligerBandsLower: " + bigBolligerBandsLower);
   Alert("");
   Alert("rsi: " + rsi);
   Alert("");


   if(Ask < meanBolligerBandsLower && Open[0] > meanBolligerBandsLower && rsi < 40)
     {
      // long position
      // long position
      Alert("Entering long position");
      Alert("Entry price: " + Ask);
      takeProfit = smallBolligerBandsUpper;
      stopLoss = bigBolligerBandsLower;

      double optLotsSize = OptimalLotSize(maxRiskPrc, Ask, stopLoss);
      Alert("optLotsSize: " + optLotsSize);
      // send buy order
      orderId = OrderSend(NULL, OP_BUYLIMIT,optLotsSize, Ask, 10, stopLoss, takeProfit, NULL, magicNB);
     }
   else
      if(Bid > meanBolligerBandsUpper && Open[0] < meanBolligerBandsUpper && rsi > 60)
        {
         // short position

         Alert("Entering short position");
         Alert("Entry price: " + Bid);
         takeProfit = smallBolligerBandsLower;
         stopLoss = bigBolligerBandsUpper;

         Alert("stopLoss: " + stopLoss);

         double optLotsSize = OptimalLotSize(maxRiskPrc, Bid, stopLoss);
         Alert("optLotsSize: " + optLotsSize);

         // send short order

         orderId = OrderSend(NULL, OP_SELLLIMIT, 0.01, Bid, 10, stopLoss, takeProfit, NULL, magicNB);

        }
      else
         if(takeProfit > 0 || stopLoss > 0)
           {
            Alert("takeProfit:" + takeProfit);
            Alert("stopLoss:" + stopLoss);
           }
         else
           {
            Alert("Waiting to place order");
           }

   return orderId;
  }
//+------------------------------------------------------------------+
