#include "OptionsModel.h"

#include <cmath>
#include <QtMath>
#include <QVariantMap>

OptionsModel::OptionsModel(QObject *parent)
    : QObject(parent),
    m_spotPrice(100.0),
    m_strikePrice(100.0),
    m_riskFreeRate(0.05),
    m_volatility(0.2),
    m_timeToExpiry(1.0),
    m_isCallOption(true),
    m_optionPrice(0.0),
    m_delta(0.0),
    m_gamma(0.0),
    m_theta(0.0),
    m_vega(0.0),
    m_rho(0.0)
{
    calculateOptionPrice();
    generateSeriesData();
}

void OptionsModel::setSpotPrice(double spotPrice)
{
    if (spotPrice <= 0.0) {
        spotPrice = 0.01;
    }

    if (qFuzzyCompare(m_spotPrice, spotPrice))
        return;

    m_spotPrice = spotPrice;
    emit spotPriceChanged();
    calculateOptionPrice();
    generateSeriesData();
}

void OptionsModel::setStrikePrice(double strikePrice)
{
    if (strikePrice <= 0.0) {
        strikePrice = 0.01;
    }

    if (qFuzzyCompare(m_strikePrice, strikePrice))
        return;

    m_strikePrice = strikePrice;
    emit strikePriceChanged();
    calculateOptionPrice();
    generateSeriesData();
}

void OptionsModel::setRiskFreeRate(double riskFreeRate)
{
    if (qFuzzyCompare(m_riskFreeRate, riskFreeRate))
        return;

    m_riskFreeRate = riskFreeRate;
    emit riskFreeRateChanged();
    calculateOptionPrice();
    generateSeriesData();
}

void OptionsModel::setVolatility(double volatility)
{
    if (volatility <= 0.0) {
        volatility = 0.01;
    }

    if (qFuzzyCompare(m_volatility, volatility))
        return;

    m_volatility = volatility;
    emit volatilityChanged();
    calculateOptionPrice();
    generateSeriesData();
}

void OptionsModel::setTimeToExpiry(double timeToExpiry)
{
    if (timeToExpiry <= 0.0) {
        timeToExpiry = 0.01;
    }

    if (qFuzzyCompare(m_timeToExpiry, timeToExpiry))
        return;

    m_timeToExpiry = timeToExpiry;
    emit timeToExpiryChanged();
    calculateOptionPrice();
    generateSeriesData();
}

void OptionsModel::setIsCallOption(bool isCallOption)
{
    if (m_isCallOption == isCallOption)
        return;

    m_isCallOption = isCallOption;
    emit isCallOptionChanged();
    calculateOptionPrice();
    generateSeriesData();
}

void OptionsModel::calculateOptionPrice()
{
    m_optionPrice = blackScholesPrice(m_spotPrice, m_strikePrice, m_riskFreeRate, m_volatility, m_timeToExpiry, m_isCallOption);

    m_delta = calculateDelta(m_spotPrice, m_strikePrice, m_riskFreeRate, m_volatility, m_timeToExpiry, m_isCallOption);
    m_gamma = calculateGamma(m_spotPrice, m_strikePrice, m_riskFreeRate, m_volatility, m_timeToExpiry);
    m_theta = calculateTheta(m_spotPrice, m_strikePrice, m_riskFreeRate, m_volatility, m_timeToExpiry, m_isCallOption);
    m_vega = calculateVega(m_spotPrice, m_strikePrice, m_riskFreeRate, m_volatility, m_timeToExpiry);
    m_rho = calculateRho(m_spotPrice, m_strikePrice, m_riskFreeRate, m_volatility, m_timeToExpiry, m_isCallOption);

    emit optionPriceChanged();
    emit greeksChanged();
}

void OptionsModel::generateSeriesData()
{
    m_priceSeriesData.clear();
    m_deltaSeriesData.clear();
    m_gammaSeriesData.clear();

    const int numPoints = 100; // Increased for smoother curves
    // Ensure current spot price is included in the range
    const double minSpot = qMin(m_strikePrice * 0.6, m_spotPrice * 0.8);
    const double maxSpot = qMax(m_strikePrice * 1.4, m_spotPrice * 1.2);
    const double step = (maxSpot - minSpot) / numPoints;

    for (int i = 0; i <= numPoints; ++i) {
        double spotPrice = minSpot + i * step;

        double price = blackScholesPrice(spotPrice, m_strikePrice, m_riskFreeRate, m_volatility, m_timeToExpiry, m_isCallOption);
        double delta = calculateDelta(spotPrice, m_strikePrice, m_riskFreeRate, m_volatility, m_timeToExpiry, m_isCallOption);
        double gamma = calculateGamma(spotPrice, m_strikePrice, m_riskFreeRate, m_volatility, m_timeToExpiry);

        QVariantMap pricePoint;
        pricePoint["x"] = spotPrice;
        pricePoint["y"] = safeCalculation(price);
        m_priceSeriesData.append(pricePoint);

        QVariantMap deltaPoint;
        deltaPoint["x"] = spotPrice;
        deltaPoint["y"] = safeCalculation(delta);
        m_deltaSeriesData.append(deltaPoint);

        QVariantMap gammaPoint;
        gammaPoint["x"] = spotPrice;
        gammaPoint["y"] = safeCalculation(gamma);
        m_gammaSeriesData.append(gammaPoint);
    }

    emit dataChanged();
    emit priceSeriesDataChanged();
    emit deltaSeriesDataChanged();
    emit gammaSeriesDataChanged();
}

void OptionsModel::resetToDefaults()
{
    m_spotPrice = 100.0;
    m_strikePrice = 100.0;
    m_riskFreeRate = 0.05;
    m_volatility = 0.2;
    m_timeToExpiry = 1.0;
    m_isCallOption = true;

    emit spotPriceChanged();
    emit strikePriceChanged();
    emit riskFreeRateChanged();
    emit volatilityChanged();
    emit timeToExpiryChanged();
    emit isCallOptionChanged();

    calculateOptionPrice();
    generateSeriesData();
}

double OptionsModel::safeCalculation(double value) const
{
    // Handle potential numerical errors
    if (std::isnan(value) || std::isinf(value)) {
        return 0.0;
    }
    return value;
}

double OptionsModel::blackScholesPrice(double S, double K, double r, double v, double T, bool isCall)
{
    // Enhanced safety checks
    if (v <= 0.0 || T <= 0.0 || S <= 0.0 || K <= 0.0) {
        return 0.0;
    }

    try {
        double d1 = (qLn(S / K) + (r + 0.5 * v * v) * T) / (v * qSqrt(T));
        double d2 = d1 - v * qSqrt(T);

        if (isCall) {
            return safeCalculation(S * normalCDF(d1) - K * qExp(-r * T) * normalCDF(d2));
        } else {
            return safeCalculation(K * qExp(-r * T) * normalCDF(-d2) - S * normalCDF(-d1));
        }
    } catch (...) {
        return 0.0;
    }
}

double OptionsModel::calculateDelta(double S, double K, double r, double v, double T, bool isCall)
{
    if (v <= 0.0 || T <= 0.0 || S <= 0.0 || K <= 0.0) {
        return 0.0;
    }

    try {
        double d1 = (qLn(S / K) + (r + 0.5 * v * v) * T) / (v * qSqrt(T));

        if (isCall) {
            return safeCalculation(normalCDF(d1));
        } else {
            return safeCalculation(normalCDF(d1) - 1.0);
        }
    } catch (...) {
        return 0.0;
    }
}

double OptionsModel::calculateGamma(double S, double K, double r, double v, double T)
{
    if (v <= 0.0 || T <= 0.0 || S <= 0.0 || K <= 0.0) {
        return 0.0;
    }

    try {
        double d1 = (qLn(S / K) + (r + 0.5 * v * v) * T) / (v * qSqrt(T));
        return safeCalculation(normalPDF(d1) / (S * v * qSqrt(T)));
    } catch (...) {
        return 0.0;
    }
}

double OptionsModel::calculateTheta(double S, double K, double r, double v, double T, bool isCall)
{
    if (v <= 0.0 || T <= 0.0 || S <= 0.0 || K <= 0.0) {
        return 0.0;
    }

    try {
        double d1 = (qLn(S / K) + (r + 0.5 * v * v) * T) / (v * qSqrt(T));
        double d2 = d1 - v * qSqrt(T);

        double theta = -(S * v * normalPDF(d1)) / (2 * qSqrt(T));

        if (isCall) {
            return safeCalculation(theta - r * K * qExp(-r * T) * normalCDF(d2));
        } else {
            return safeCalculation(theta + r * K * qExp(-r * T) * normalCDF(-d2));
        }
    } catch (...) {
        return 0.0;
    }
}

double OptionsModel::calculateVega(double S, double K, double r, double v, double T)
{
    if (v <= 0.0 || T <= 0.0 || S <= 0.0 || K <= 0.0) {
        return 0.0;
    }

    try {
        double d1 = (qLn(S / K) + (r + 0.5 * v * v) * T) / (v * qSqrt(T));
        return safeCalculation(S * qSqrt(T) * normalPDF(d1));
    } catch (...) {
        return 0.0;
    }
}

double OptionsModel::calculateRho(double S, double K, double r, double v, double T, bool isCall)
{
    if (v <= 0.0 || T <= 0.0 || S <= 0.0 || K <= 0.0) {
        return 0.0;
    }

    try {
        double d1 = (qLn(S / K) + (r + 0.5 * v * v) * T) / (v * qSqrt(T));
        double d2 = d1 - v * qSqrt(T);

        if (isCall) {
            return safeCalculation(K * T * qExp(-r * T) * normalCDF(d2));
        } else {
            return safeCalculation(-K * T * qExp(-r * T) * normalCDF(-d2));
        }
    } catch (...) {
        return 0.0;
    }
}

double OptionsModel::normalCDF(double x)
{
    return 0.5 * (1.0 + std::erf(x / qSqrt(2.0)));
}

double OptionsModel::normalPDF(double x)
{
    return (1.0 / qSqrt(2.0 * M_PI)) * qExp(-0.5 * x * x);
}
