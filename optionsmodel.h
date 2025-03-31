#ifndef OPTIONSMODEL_H
#define OPTIONSMODEL_H

#include <QObject>
#include <QtQml/qqml.h>
#include <QVector>

class OptionsModel : public QObject
{
    Q_OBJECT

    Q_PROPERTY(double spotPrice READ spotPrice WRITE setSpotPrice NOTIFY spotPriceChanged)
    Q_PROPERTY(double strikePrice READ strikePrice WRITE setStrikePrice NOTIFY strikePriceChanged)
    Q_PROPERTY(double riskFreeRate READ riskFreeRate WRITE setRiskFreeRate NOTIFY riskFreeRateChanged)
    Q_PROPERTY(double volatility READ volatility WRITE setVolatility NOTIFY volatilityChanged)
    Q_PROPERTY(double timeToExpiry READ timeToExpiry WRITE setTimeToExpiry NOTIFY timeToExpiryChanged)
    Q_PROPERTY(bool isCallOption READ isCallOption WRITE setIsCallOption NOTIFY isCallOptionChanged)

    Q_PROPERTY(double optionPrice READ optionPrice NOTIFY optionPriceChanged)
    Q_PROPERTY(double delta READ delta NOTIFY greeksChanged)
    Q_PROPERTY(double gamma READ gamma NOTIFY greeksChanged)
    Q_PROPERTY(double theta READ theta NOTIFY greeksChanged)
    Q_PROPERTY(double vega READ vega NOTIFY greeksChanged)
    Q_PROPERTY(double rho READ rho NOTIFY greeksChanged)

    Q_PROPERTY(QVariantList priceSeriesData READ priceSeriesData NOTIFY priceSeriesDataChanged)
    Q_PROPERTY(QVariantList deltaSeriesData READ deltaSeriesData NOTIFY deltaSeriesDataChanged)
    Q_PROPERTY(QVariantList gammaSeriesData READ gammaSeriesData NOTIFY gammaSeriesDataChanged)

    Q_PROPERTY(double probabilityITM READ probabilityITM NOTIFY riskMetricsChanged)
    Q_PROPERTY(double probabilityOTM READ probabilityOTM NOTIFY riskMetricsChanged) 
    Q_PROPERTY(double breakEvenPrice READ breakEvenPrice NOTIFY riskMetricsChanged)

public:
    explicit OptionsModel(QObject *parent = nullptr);

    double spotPrice() const { return m_spotPrice; }
    double strikePrice() const { return m_strikePrice; }
    double riskFreeRate() const { return m_riskFreeRate; }
    double volatility() const { return m_volatility; }
    double timeToExpiry() const { return m_timeToExpiry; }
    bool isCallOption() const { return m_isCallOption; }

    double optionPrice() const { return m_optionPrice; }
    double delta() const { return m_delta; }
    double gamma() const { return m_gamma; }
    double theta() const { return m_theta; }
    double vega() const { return m_vega; }
    double rho() const { return m_rho; }

    QVariantList priceSeriesData() const { return m_priceSeriesData; }
    QVariantList deltaSeriesData() const { return m_deltaSeriesData; }
    QVariantList gammaSeriesData() const { return m_gammaSeriesData; }

    double probabilityITM() const { return m_probabilityITM; }
    double probabilityOTM() const { return m_probabilityOTM; }
    double breakEvenPrice() const { return m_breakEvenPrice; }
    double maxProfit() const { return m_maxProfit; }
    double maxLoss() const { return m_maxLoss; }
    double valueAtRisk() const { return m_valueAtRisk; }
    double expectedPayoff() const { return m_expectedPayoff; }
    double expectedStockPrice() const { return m_expectedStockPrice; }
    double riskRewardRatio() const { return m_riskRewardRatio; }
    double valueAtRisk1Day() const { return m_valueAtRisk1Day; }
    double valueAtRisk10Day() const { return m_valueAtRisk10Day; }
    double expectedPL() const { return m_expectedPL; }
    double sharpeRatio() const { return m_sharpeRatio; }
    double probabilityOfProfit() const { return m_probabilityOfProfit; }

    void setSpotPrice(double spotPrice);
    void setStrikePrice(double strikePrice);
    void setRiskFreeRate(double riskFreeRate);
    void setVolatility(double volatility);
    void setTimeToExpiry(double timeToExpiry);
    void setIsCallOption(bool isCallOption);

public slots:
    void calculateOptionPrice();
    void generateSeriesData();
    void resetToDefaults();
    void calculateRiskMetrics();

private:
    void updateAllCalculations();

signals:
    void spotPriceChanged();
    void strikePriceChanged();
    void riskFreeRateChanged();
    void volatilityChanged();
    void timeToExpiryChanged();
    void isCallOptionChanged();

    void optionPriceChanged();
    void greeksChanged();
    void dataChanged();

    void priceSeriesDataChanged();
    void deltaSeriesDataChanged();
    void gammaSeriesDataChanged();
    void riskMetricsChanged();

private:
    double blackScholesPrice(double S, double K, double r, double v, double T, bool isCall);
    double calculateDelta(double S, double K, double r, double v, double T, bool isCall);
    double calculateGamma(double S, double K, double r, double v, double T);
    double calculateTheta(double S, double K, double r, double v, double T, bool isCall);
    double calculateVega(double S, double K, double r, double v, double T);
    double calculateRho(double S, double K, double r, double v, double T, bool isCall);

    double normalCDF(double x);
    double normalPDF(double x);

    double safeCalculation(double value) const;

    double m_spotPrice;
    double m_strikePrice;
    double m_riskFreeRate;
    double m_volatility;
    double m_timeToExpiry;
    bool m_isCallOption;

    double m_optionPrice;
    double m_delta;
    double m_gamma;
    double m_theta;
    double m_vega;
    double m_rho;

    QVariantList m_priceSeriesData;
    QVariantList m_deltaSeriesData;
    QVariantList m_gammaSeriesData;

    double m_probabilityITM;
    double m_probabilityOTM;
    double m_breakEvenPrice;
    double m_maxProfit;
    double m_maxLoss;
    double m_valueAtRisk;
    double m_expectedPayoff;
    double m_expectedStockPrice;
    double m_riskRewardRatio;
    double m_valueAtRisk1Day;
    double m_valueAtRisk10Day;
    double m_expectedPL;
    double m_sharpeRatio;
    double m_probabilityOfProfit;
};

#endif // OPTIONSMODEL_H
