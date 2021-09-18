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
void bollingerBandsTrading()
  {

   Alert("");
   int period = 20;
   double smallDeviation = 1.0;
   double bigDeviation = 4.0;
   double takeProfit;
   double stopLoss;
   int orderId;

// bollinger  bands assignment

   double smallBolligerBandsMain = NormalizeDouble(iBands(NULL,0,period, smallDeviation, 0, PRICE_CLOSE, MODE_MAIN, 0), _Digits);
   double smallBolligerBandsUpper =  NormalizeDouble(iBands(NULL,0,period, smallDeviation, 0, PRICE_CLOSE, MODE_UPPER, 0), _Digits);
   double smallBolligerBandsLower = NormalizeDouble(iBands(NULL,0,period, smallDeviation, 0, PRICE_CLOSE, MODE_LOWER, 0), _Digits);

   Alert("smallBolligerBandsMain: " + smallBolligerBandsMain);
   Alert("smallBolligerBandsUpper: " + smallBolligerBandsUpper);
   Alert("smallBolligerBandsLower: " + smallBolligerBandsLower);

   Alert("");

   double bigBolligerBandsMain = NormalizeDouble(iBands(NULL,0,period, bigDeviation, 0, PRICE_CLOSE, MODE_MAIN, 0), _Digits);
   double bigBolligerBandsUpper = NormalizeDouble(iBands(NULL,0,period, bigDeviation, 0, PRICE_CLOSE, MODE_UPPER, 0), _Digits);
   double bigBolligerBandsLower = NormalizeDouble(iBands(NULL,0,period, bigDeviation, 0, PRICE_CLOSE, MODE_LOWER, 0), _Digits);

   Alert("bigBolligerBandsMain: " + bigBolligerBandsMain);
   Alert("bigBolligerBandsUpper: " + bigBolligerBandsUpper);
   Alert("bigBolligerBandsLower: " + bigBolligerBandsLower);

   Alert("");
   Alert("Ask:"+Ask);
   Alert("Bid:"+Bid);

   if(Ask < smallBolligerBandsLower)
     {
      // long position
      Alert("Entering long position");
      Alert("Entry price: " + Ask);
      takeProfit = smallBolligerBandsMain;
      stopLoss = bigBolligerBandsLower;

      double optLotsSize = OptimalLotSize(0.02, Ask, stopLoss);
      // send buy order
      // orderId = OrderSend(NULL, OP_BUYLIMIT,optLotsSize, Ask, 10, stopLoss, takeProfit);
      // Alert("orderId: "+orderId);
     }
   else
      if(Bid > smallBolligerBandsUpper)
        {
         // short position
         Alert("Entering short position");
         Alert("Entry price: " + Bid);
         takeProfit = bigBolligerBandsMain;
         stopLoss = bigBolligerBandsUpper;

         double optLotsSize = OptimalLotSize(0.02, Bid, stopLoss);
         // send short order
         // orderId = OrderSend(NULL, OP_SELLLIMIT, 0.01, Bid , 10, stopLoss, takeProfit);
         // Alert("orderId: "+orderId);
        }

   Alert("");
   Alert("takeProfit:" + takeProfit);
   Alert("stopLoss:" + stopLoss);

   /*
   if(orderId < 0 ) {
      Alert("OrderSend failed with error #" + GetLastError());
   } else {
      Alert("OrderSend placed successfully");
   }
   */
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
   return MarketInfo(Symbol(), MODE_TRADEALLOWED);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double OptimalLotSize(double maxRiskPrc, int maxLossInPips){


   Alert("Account lot: " + SymbolInfoDouble(NULL, SYMBOL_TRADE_CONTRACT_SIZE));
   Alert("Minimum Lot: " + MarketInfo(NULL, MODE_MINLOT));
/*
   double accEquity = AccountEquity() / 100; // use 1/100

   Alert("accEquity: " + accEquity);

   double lotSize = MarketInfo(NULL,MODE_LOTSIZE);

   Alert("lotSize: " + lotSize);

   double tickValue = NormalizeDouble(MarketInfo(NULL,MODE_TICKVALUE),2);

   if(Digits <= 3)
     {
      Alert("Digits < 3 before: " + tickValue);
      tickValue = tickValue / 100;
     }

   Alert("tickValue: " + tickValue);

   double maxLossEuros = accEquity * maxRiskPrc;

   Alert("maxLossEuros: " + maxLossEuros);

   double maxLossInQuoteCurrency = maxLossEuros / tickValue;

   Alert("maxLossInQuoteCurrency: " + maxLossInQuoteCurrency);


   double ar1 = maxLossInQuoteCurrency;
   double ar2 = maxLossInPips * GetPipValue();

   double optimalLotSize = NormalizeDouble((ar1 / ar2) / lotSize, 2);

   Alert("optimalLotSize: " + optimalLotSize);
   
   return optimalLotSize;
   */
   
   return 0.01;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double OptimalLotSize(double maxRiskPrc, double entryPrice, double stopLoss)
  {

   int maxLossInPips = MathAbs(entryPrice - stopLoss)/GetPipValue();

   return OptimalLotSize(maxRiskPrc,maxLossInPips);

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
