import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtCharts

Rectangle {
    id: root
    color: panelColor
    radius: 5
    border.color: borderColor
    border.width: 1

    required property var optionsModel
    property color textColor
    property color accentColor

    ScrollView {
        anchors.margins: 10
        anchors.fill: parent
        clip: true
        
        ColumnLayout {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 15
            spacing: 15

        Text {
            text: "Risk Analysis Dashboard"
            font.pixelSize: 18
            font.bold: true
            color: accentColor
        }

        GridLayout {
            Layout.fillWidth: true
            columns: 2
            rowSpacing: 8
            columnSpacing: 10

            Text { 
                text: "Probability Metrics"
                font.bold: true
                Layout.columnSpan: 2
                color: accentColor
            }
            Text { text: "ITM Probability:"; color: textColor }
            RowLayout {
                Text { 
                    text: (optionsModel.probabilityITM * 100).toFixed(1) + "%"
                    color: optionsModel.probabilityITM > 0.5 ? "#4CAF50" : "#FF5252"
                    font.bold: true
                }
                Rectangle {
                    Layout.fillWidth: true
                    height: 6
                    radius: 3
                    color: "#e0e0e0"
                    Rectangle {
                        width: parent.width * optionsModel.probabilityITM
                        height: parent.height
                        radius: 3
                        color: parent.parent.children[0].color
                    }
                }
            }
            
            Text { text: "OTM Probability:"; color: textColor }
            RowLayout {
                Text { 
                    text: (optionsModel.probabilityOTM * 100).toFixed(1) + "%"
                    color: optionsModel.probabilityOTM > 0.5 ? "#4CAF50" : "#FF5252"
                    font.bold: true
                }
                Rectangle {
                    Layout.fillWidth: true
                    height: 6
                    radius: 3
                    color: "#e0e0e0"
                    Rectangle {
                        width: parent.width * optionsModel.probabilityOTM
                        height: parent.height
                        radius: 3
                        color: parent.parent.children[0].color
                    }
                }
            }

            Text { 
                text: "Break-even Analysis"
                font.bold: true
                Layout.columnSpan: 2
                Layout.topMargin: 10
                color: accentColor
            }
            Text { text: "Break-even Price:"; color: textColor }
            RowLayout {
                Text { 
                    text: optionsModel.breakEvenPrice.toFixed(2)
                    color: textColor
                    font.bold: true
                }
                Rectangle {
                    width: 8
                    height: 8
                    radius: 4
                    color: optionsModel.breakEvenPrice > optionsModel.spotPrice ? "#FF9800" : "#4CAF50"
                }
            }
            
            Text { text: "Distance to Break-even:"; color: textColor }
            Text { 
                text: ((optionsModel.breakEvenPrice - optionsModel.spotPrice) / optionsModel.spotPrice * 100).toFixed(2) + "%"
                color: Math.abs((optionsModel.breakEvenPrice - optionsModel.spotPrice) / optionsModel.spotPrice) > 0.1 ? "#FF5252" : "#4CAF50"
                font.bold: true
            }

            Text { 
                text: "Option Sensitivity"
                font.bold: true
                Layout.columnSpan: 2
                Layout.topMargin: 10
                color: accentColor
            }
            Text { text: "Price per Point:"; color: textColor }
            Text { text: optionsModel.delta.toFixed(4); color: textColor }
            Text { text: "Daily Theta:"; color: textColor }
            Text { text: optionsModel.theta.toFixed(4); color: textColor }
            Text { text: "Volatility Impact:"; color: textColor }
            Text { text: optionsModel.vega.toFixed(4); color: textColor }

            Text {
                text: "Payoff Diagram"
                font.bold: true
                Layout.columnSpan: 2
                Layout.topMargin: 10
                color: accentColor
            }
            
            ChartView {
                Layout.columnSpan: 2
                Layout.fillWidth: true
                Layout.preferredHeight: 300
                antialiasing: true
                theme: isDarkMode ? ChartView.ChartThemeDark : ChartView.ChartThemeLight
                backgroundColor: panelColor
                legend.visible: false

                ValuesAxis {
                    id: payoffAxisX
                    titleText: "Stock Price"
                    min: optionsModel.strikePrice * 0.5
                    max: optionsModel.strikePrice * 1.5
                    color: textColor
                    gridLineColor: isDarkMode ? "#555555" : "#dddddd"
                }

                ValuesAxis {
                    id: payoffAxisY
                    titleText: "Profit/Loss"
                    min: -optionsModel.optionPrice * 2
                    max: optionsModel.isCallOption ? 
                         (optionsModel.strikePrice * 0.5) : 
                         optionsModel.optionPrice * 2
                    color: textColor
                    gridLineColor: isDarkMode ? "#555555" : "#dddddd"
                }

                LineSeries {
                    axisX: payoffAxisX
                    axisY: payoffAxisY
                    color: optionsModel.isCallOption ? "#4CAF50" : "#FF5252"
                    width: 2
                    XYPoint { x: 0; y: -optionsModel.optionPrice }
                    XYPoint { 
                        x: optionsModel.strikePrice; 
                        y: -optionsModel.optionPrice 
                    }
                    XYPoint { 
                        x: optionsModel.strikePrice * 1.5;
                        y: optionsModel.isCallOption ? 
                           (optionsModel.strikePrice * 0.5 - optionsModel.optionPrice) :
                           -optionsModel.optionPrice
                    }
                }
            }

            Text {
                text: "Price Distribution at Expiry"
                font.bold: true
                Layout.columnSpan: 2
                Layout.topMargin: 10
                color: accentColor
            }

            ChartView {
                Layout.columnSpan: 2
                Layout.fillWidth: true
                Layout.preferredHeight: 300
                Layout.preferredWidth: 500
                antialiasing: true
                theme: isDarkMode ? ChartView.ChartThemeDark : ChartView.ChartThemeLight
                backgroundColor: panelColor
                legend.visible: false

                ValuesAxis {
                    id: distAxisX
                    titleText: "Stock Price"
                    min: optionsModel.spotPrice * 0.5
                    max: optionsModel.spotPrice * 1.5
                    color: textColor
                    gridLineColor: isDarkMode ? "#555555" : "#dddddd"
                }

                ValuesAxis {
                    id: distAxisY
                    titleText: "Probability"
                    min: 0
                    max: 0.02
                    color: textColor
                    gridLineColor: isDarkMode ? "#555555" : "#dddddd"
                }

                AreaSeries {
                    axisX: distAxisX
                    axisY: distAxisY
                    color: "#80CBC4"
                    borderColor: "#00897B"
                    borderWidth: 2
                    opacity: 0.5

                    upperSeries: LineSeries {
                        XYPoint { 
                            x: optionsModel.spotPrice * 0.5; 
                            y: Math.exp(-Math.pow(Math.log(optionsModel.spotPrice * 0.5 / optionsModel.spotPrice) - 
                               (optionsModel.riskFreeRate - 0.5 * Math.pow(optionsModel.volatility, 2)) * 
                               optionsModel.timeToExpiry, 2) / 
                               (2 * Math.pow(optionsModel.volatility, 2) * optionsModel.timeToExpiry)) / 
                               (optionsModel.spotPrice * 0.5 * optionsModel.volatility * 
                               Math.sqrt(2 * Math.PI * optionsModel.timeToExpiry))
                        }
                        XYPoint { 
                            x: optionsModel.spotPrice; 
                            y: Math.exp(-Math.pow(Math.log(optionsModel.spotPrice / optionsModel.spotPrice) - 
                               (optionsModel.riskFreeRate - 0.5 * Math.pow(optionsModel.volatility, 2)) * 
                               optionsModel.timeToExpiry, 2) / 
                               (2 * Math.pow(optionsModel.volatility, 2) * optionsModel.timeToExpiry)) / 
                               (optionsModel.spotPrice * optionsModel.volatility * 
                               Math.sqrt(2 * Math.PI * optionsModel.timeToExpiry))
                        }
                        XYPoint { 
                            x: optionsModel.spotPrice * 1.5; 
                            y: Math.exp(-Math.pow(Math.log(optionsModel.spotPrice * 1.5 / optionsModel.spotPrice) - 
                               (optionsModel.riskFreeRate - 0.5 * Math.pow(optionsModel.volatility, 2)) * 
                               optionsModel.timeToExpiry, 2) / 
                               (2 * Math.pow(optionsModel.volatility, 2) * optionsModel.timeToExpiry)) / 
                               (optionsModel.spotPrice * 1.5 * optionsModel.volatility * 
                               Math.sqrt(2 * Math.PI * optionsModel.timeToExpiry))
                        }
                    }
                }

                LineSeries {
                    axisX: distAxisX
                    axisY: distAxisY
                    color: "#FF5252"
                    width: 2
                    style: Qt.DashLine
                    XYPoint { x: optionsModel.breakEvenPrice; y: 0 }
                    XYPoint { x: optionsModel.breakEvenPrice; y: 0.02 }
                }
            }
            Text { text: "Intrinsic Value:"; color: textColor }
            Text { 
                text: optionsModel.isCallOption ? 
                    Math.max(0, (optionsModel.spotPrice - optionsModel.strikePrice)).toFixed(2) :
                    Math.max(0, (optionsModel.strikePrice - optionsModel.spotPrice)).toFixed(2)
                color: textColor 
            }
            Text { text: "Time Value:"; color: textColor }
            Text { 
                text: (optionsModel.optionPrice - (optionsModel.isCallOption ? 
                    Math.max(0, (optionsModel.spotPrice - optionsModel.strikePrice)) :
                    Math.max(0, (optionsModel.strikePrice - optionsModel.spotPrice)))).toFixed(2)
                color: textColor
            }
        }

        }
    }
}
