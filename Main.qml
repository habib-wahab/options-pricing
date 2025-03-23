import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import QtCharts
import QtQuick.Window
import OptionPricingTool 1.0

ApplicationWindow {
    id: window
    visible: true
            width: 1000
    height: 700
    minimumWidth: 800
    minimumHeight: 600
    title: "Option Pricing Visualisation"

    OptionsModel {
        id: optionsModel
    }

    property bool isDarkMode: false

    property color lightAccentColor: "#007ac3"
    property color lightBackgroundColor: "#f0f8ff"
    property color lightTextColor: "#333333"
    property color lightPanelColor: "white"
    property color lightBorderColor: "#cccccc"
    property color lightChartColor1: "#003366"
    property color lightChartColor2: "#0066cc"
    property color lightChartColor3: "#3399ff"

    property color darkAccentColor: "#1e88e5"
    property color darkBackgroundColor: "#121212"
    property color darkTextColor: "#ffffff"
    property color darkPanelColor: "#242424"
    property color darkBorderColor: "#555555"
    property color darkChartColor1: "#4fc3f7"
    property color darkChartColor2: "#29b6f6"
    property color darkChartColor3: "#03a9f4"

    property color accentColor: isDarkMode ? darkAccentColor : lightAccentColor
    property color backgroundColor: isDarkMode ? darkBackgroundColor : lightBackgroundColor
    property color textColor: isDarkMode ? darkTextColor : lightTextColor
    property color panelColor: isDarkMode ? darkPanelColor : lightPanelColor
    property color borderColor: isDarkMode ? darkBorderColor : lightBorderColor
    property color chartColor1: isDarkMode ? darkChartColor1 : lightChartColor1
    property color chartColor2: isDarkMode ? darkChartColor2 : lightChartColor2
    property color chartColor3: isDarkMode ? darkChartColor3 : lightChartColor3

    color: backgroundColor

    onIsDarkModeChanged: {
        priceChartView.theme = isDarkMode ? ChartView.ChartThemeDark : ChartView.ChartThemeLight
        deltaChartView.theme = isDarkMode ? ChartView.ChartThemeDark : ChartView.ChartThemeLight
        gammaChartView.theme = isDarkMode ? ChartView.ChartThemeDark : ChartView.ChartThemeLight

        priceSeries.color = chartColor1
        deltaSeries.color = chartColor2
        gammaSeries.color = chartColor3
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10
        clip: true

        Rectangle {
            Layout.fillWidth: true
            height: 60
            color: accentColor
            radius: 5

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 20
                anchors.rightMargin: 20

                Text {
                    Layout.fillWidth: true
                    text: "Option Pricing Visualisation Tool"
                    font.pixelSize: 24
                    font.bold: true
                    color: "white"
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                }

                Switch {
                    id: themeSwitch
                    text: "Dark Mode"
                    checked: isDarkMode
                    onToggled: {
                        window.isDarkMode = checked
                    }
                    contentItem: Text {
                        text: themeSwitch.text
                        font.pixelSize: 14
                        color: "white"
                        verticalAlignment: Text.AlignVCenter
                        leftPadding: themeSwitch.indicator.width + 8
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 10

            Rectangle {
                Layout.preferredWidth: 300
                Layout.minimumWidth: 250
                Layout.fillHeight: true
                color: panelColor
                radius: 5
                border.color: borderColor
                border.width: 1

                ScrollView {
                    id: optionsScrollView
                    anchors.fill: parent
                    clip: true
                    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                    ScrollBar.vertical.policy: ScrollBar.AsNeeded

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 15
                        spacing: 15
                        width: optionsScrollView.width - 30

                    Text {
                        text: "Option Parameters"
                        font.pixelSize: 18
                        font.bold: true
                        color: accentColor
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Text {
                            text: "Option Type:"
                            Layout.preferredWidth: 100
                            color: textColor
                        }
                        RadioButton {
                            text: "Call"
                            checked: optionsModel.isCallOption
                            onClicked: optionsModel.isCallOption = true
                            contentItem: Text {
                                text: parent.text
                                color: textColor
                                leftPadding: parent.indicator.width + 4
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                        RadioButton {
                            text: "Put"
                            checked: !optionsModel.isCallOption
                            onClicked: optionsModel.isCallOption = false
                            contentItem: Text {
                                text: parent.text
                                color: textColor
                                leftPadding: parent.indicator.width + 4
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                    }

                    GridLayout {
                        Layout.fillWidth: true
                        columns: 2
                        rowSpacing: 10
                        columnSpacing: 10

                        Text { text: "Spot Price:"; color: textColor }
                        Text {
                            text: optionsModel.spotPrice.toFixed(2)
                            font.bold: true
                            color: textColor
                        }

                        Slider {
                            id: spotPriceSlider
                            Layout.columnSpan: 2
                            Layout.fillWidth: true
                            from: 50
                            to: 150
                            value: optionsModel.spotPrice
                            onMoved: optionsModel.spotPrice = value
                        }

                        Text { text: "Strike Price:"; color: textColor }
                        Text {
                            text: optionsModel.strikePrice.toFixed(2)
                            font.bold: true
                            color: textColor
                        }

                        Slider {
                            Layout.columnSpan: 2
                            Layout.fillWidth: true
                            from: 50
                            to: 150
                            value: optionsModel.strikePrice
                            onMoved: optionsModel.strikePrice = value
                        }

                        Text { text: "Volatility:"; color: textColor }
                        Text {
                            text: (optionsModel.volatility * 100).toFixed(1) + "%"
                            font.bold: true
                            color: textColor
                        }

                        Slider {
                            Layout.columnSpan: 2
                            Layout.fillWidth: true
                            from: 0.05
                            to: 0.5
                            value: optionsModel.volatility
                            onMoved: optionsModel.volatility = value
                        }

                        Text { text: "Risk-free Rate:"; color: textColor }
                        Text {
                            text: (optionsModel.riskFreeRate * 100).toFixed(2) + "%"
                            font.bold: true
                            color: textColor
                        }

                        Slider {
                            Layout.columnSpan: 2
                            Layout.fillWidth: true
                            from: 0.01
                            to: 0.1
                            value: optionsModel.riskFreeRate
                            onMoved: optionsModel.riskFreeRate = value
                        }

                        Text { text: "Time to Expiry:"; color: textColor }
                        Text {
                            text: optionsModel.timeToExpiry.toFixed(2) + " years"
                            font.bold: true
                            color: textColor
                        }

                        Slider {
                            Layout.columnSpan: 2
                            Layout.fillWidth: true
                            from: 0.1
                            to: 2
                            value: optionsModel.timeToExpiry
                            onMoved: optionsModel.timeToExpiry = value
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: borderColor
                    }

                    Text {
                        text: "Results"
                        font.pixelSize: 18
                        font.bold: true
                        color: accentColor
                    }

                    GridLayout {
                        Layout.fillWidth: true
                        columns: 2
                        rowSpacing: 5
                        columnSpacing: 10

                        Text { text: "Option Price:"; color: textColor }
                        Text {
                            text: optionsModel.optionPrice.toFixed(4)
                            font.bold: true
                            font.pixelSize: 16
                            color: accentColor
                        }

                        Text { text: "Delta:"; color: textColor }
                        Text { text: optionsModel.delta.toFixed(4); color: textColor }

                        Text { text: "Gamma:"; color: textColor }
                        Text { text: optionsModel.gamma.toFixed(4); color: textColor }

                        Text { text: "Theta:"; color: textColor }
                        Text { text: optionsModel.theta.toFixed(4); color: textColor }

                        Text { text: "Vega:"; color: textColor }
                        Text { text: optionsModel.vega.toFixed(4); color: textColor }

                        Text { text: "Rho:"; color: textColor }
                        Text { text: optionsModel.rho.toFixed(4); color: textColor }
                    }

                    Item { Layout.fillHeight: true }

                    Button {
                        text: "Reset to Defaults"
                        Layout.fillWidth: true
                        onClicked: optionsModel.resetToDefaults()
                    }
                }
            }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.minimumWidth: 300
                Layout.fillHeight: true
                color: panelColor
                radius: 5
                border.color: borderColor
                border.width: 1

                TabBar {
                    id: chartsTabBar
                    width: parent.width
                    background: Rectangle {
                        color: isDarkMode ? "#333333" : "#f6f6f6"
                    }

                    TabButton {
                        text: "Option Price"
                        contentItem: Text {
                            text: parent.text
                            color: parent.checked ? accentColor : textColor
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        background: Rectangle {
                            color: parent.checked ? (isDarkMode ? "#333333" : "white") : "transparent"
                            border.color: parent.checked ? accentColor : "transparent"
                            border.width: parent.checked ? 2 : 0
                        }
                    }
                    TabButton {
                        text: "Delta"
                        contentItem: Text {
                            text: parent.text
                            color: parent.checked ? accentColor : textColor
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        background: Rectangle {
                            color: parent.checked ? (isDarkMode ? "#333333" : "white") : "transparent"
                            border.color: parent.checked ? accentColor : "transparent"
                            border.width: parent.checked ? 2 : 0
                        }
                    }
                    TabButton {
                        text: "Gamma"
                        contentItem: Text {
                            text: parent.text
                            color: parent.checked ? accentColor : textColor
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        background: Rectangle {
                            color: parent.checked ? (isDarkMode ? "#333333" : "white") : "transparent"
                            border.color: parent.checked ? accentColor : "transparent"
                            border.width: parent.checked ? 2 : 0
                        }
                    }
                }

                StackLayout {
                    anchors.top: chartsTabBar.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.margins: 10
                    currentIndex: chartsTabBar.currentIndex

                    ChartView {
                        id: priceChartView
                        title: "Option Price vs Spot Price"
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        legend.visible: false
                        antialiasing: true
                        theme: isDarkMode ? ChartView.ChartThemeDark : ChartView.ChartThemeLight
                        backgroundColor: panelColor

                        ValuesAxis {
                            id: priceAxisX
                            titleText: "Spot Price"
                            min: Math.max(1, optionsModel.strikePrice * 0.5)
                            max: optionsModel.strikePrice * 1.5
                            labelFormat: "%.1f"
                            color: textColor
                            gridLineColor: isDarkMode ? "#555555" : "#dddddd"
                        }

                        ValuesAxis {
                            id: priceAxisY
                            titleText: "Option Price"
                            min: 0
                            max: 50
                            labelFormat: "%.1f"
                            color: textColor
                            gridLineColor: isDarkMode ? "#555555" : "#dddddd"
                        }

                        LineSeries {
                            id: priceSeries
                            axisX: priceAxisX
                            axisY: priceAxisY
                            color: chartColor1
                            width: 2
                        }

                        ScatterSeries {
                            id: priceMarker
                            axisX: priceAxisX
                            axisY: priceAxisY
                            color: "red"
                            markerSize: 10
                        }
                    }

                    ChartView {
                        id: deltaChartView
                        title: "Delta vs Spot Price"
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        legend.visible: false
                        antialiasing: true
                        theme: isDarkMode ? ChartView.ChartThemeDark : ChartView.ChartThemeLight
                        backgroundColor: panelColor

                        ValuesAxis {
                            id: deltaAxisX
                            titleText: "Spot Price"
                            min: Math.max(1, optionsModel.strikePrice * 0.5)
                            max: optionsModel.strikePrice * 1.5
                            labelFormat: "%.1f"
                            color: textColor
                            gridLineColor: isDarkMode ? "#555555" : "#dddddd"
                        }

                        ValuesAxis {
                            id: deltaAxisY
                            titleText: "Delta"
                            min: optionsModel.isCallOption ? -0.1 : -1.1
                            max: optionsModel.isCallOption ? 1.1 : 0.1
                            labelFormat: "%.1f"
                            color: textColor
                            gridLineColor: isDarkMode ? "#555555" : "#dddddd"
                        }

                        LineSeries {
                            id: deltaSeries
                            axisX: deltaAxisX
                            axisY: deltaAxisY
                            color: chartColor2
                            width: 2
                        }

                        ScatterSeries {
                            id: deltaMarker
                            axisX: deltaAxisX
                            axisY: deltaAxisY
                            color: "red"
                            markerSize: 10
                        }
                    }

                    ChartView {
                        id: gammaChartView
                        title: "Gamma vs Spot Price"
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        legend.visible: false
                        antialiasing: true
                        theme: isDarkMode ? ChartView.ChartThemeDark : ChartView.ChartThemeLight
                        backgroundColor: panelColor

                        ValuesAxis {
                            id: gammaAxisX
                            titleText: "Spot Price"
                            min: Math.max(1, optionsModel.strikePrice * 0.5)
                            max: optionsModel.strikePrice * 1.5
                            labelFormat: "%.1f"
                            color: textColor
                            gridLineColor: isDarkMode ? "#555555" : "#dddddd"
                        }

                        ValuesAxis {
                            id: gammaAxisY
                            titleText: "Gamma"
                            min: 0
                            max: 0.1
                            labelFormat: "%.3f"
                            color: textColor
                            gridLineColor: isDarkMode ? "#555555" : "#dddddd"
                        }

                        LineSeries {
                            id: gammaSeries
                            axisX: gammaAxisX
                            axisY: gammaAxisY
                            color: chartColor3
                            width: 2
                        }

                        ScatterSeries {
                            id: gammaMarker
                            axisX: gammaAxisX
                            axisY: gammaAxisY
                            color: "red"
                            markerSize: 10
                        }
                    }
                }
            }
        }

        Text {
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignRight
            text: "Option Pricing Visualisation Tool"
            font.italic: true
            color: isDarkMode ? "#aaaaaa" : "#666666"
        }
    }

    function updatePriceChart() {
        priceSeries.clear();
        priceMarker.clear();

        let maxY = 0;
        let currentSpotFound = false;
        let lineValueAtSpot = 0;

        for (let i = 0; i < optionsModel.priceSeriesData.length; i++) {
            const x = optionsModel.priceSeriesData[i].x;
            const y = optionsModel.priceSeriesData[i].y;
            priceSeries.append(x, y);
            maxY = Math.max(maxY, y);

            if (Math.abs(x - optionsModel.spotPrice) < 0.001) {
                currentSpotFound = true;
                lineValueAtSpot = y;
            }
        }

        if (currentSpotFound) {
            priceMarker.append(optionsModel.spotPrice, lineValueAtSpot);
        } else {
            priceMarker.append(optionsModel.spotPrice, optionsModel.optionPrice);
        }

        priceAxisX.min = Math.min(Math.max(1, optionsModel.strikePrice * 0.5), optionsModel.spotPrice * 0.8);
        priceAxisX.max = Math.max(optionsModel.strikePrice * 1.5, optionsModel.spotPrice * 1.2);
        priceAxisY.max = maxY * 1.1 || 50;
    }

    function updateDeltaChart() {
        deltaSeries.clear();
        deltaMarker.clear();

        let currentSpotFound = false;
        let lineValueAtSpot = 0;

        for (let i = 0; i < optionsModel.deltaSeriesData.length; i++) {
            const x = optionsModel.deltaSeriesData[i].x;
            const y = optionsModel.deltaSeriesData[i].y;
            deltaSeries.append(x, y);

            if (Math.abs(x - optionsModel.spotPrice) < 0.001) {
                currentSpotFound = true;
                lineValueAtSpot = y;
            }
        }

        if (currentSpotFound) {
            deltaMarker.append(optionsModel.spotPrice, lineValueAtSpot);
        } else {
            deltaMarker.append(optionsModel.spotPrice, optionsModel.delta);
        }

        deltaAxisX.min = Math.min(Math.max(1, optionsModel.strikePrice * 0.5), optionsModel.spotPrice * 0.8);
        deltaAxisX.max = Math.max(optionsModel.strikePrice * 1.5, optionsModel.spotPrice * 1.2);
        deltaAxisY.min = optionsModel.isCallOption ? -0.1 : -1.1;
        deltaAxisY.max = optionsModel.isCallOption ? 1.1 : 0.1;
    }

    function updateGammaChart() {
        gammaSeries.clear();
        gammaMarker.clear();

        let maxY = 0;
        let currentSpotFound = false;
        let lineValueAtSpot = 0;

        for (let i = 0; i < optionsModel.gammaSeriesData.length; i++) {
            const x = optionsModel.gammaSeriesData[i].x;
            const y = optionsModel.gammaSeriesData[i].y;
            gammaSeries.append(x, y);
            maxY = Math.max(maxY, y);

            if (Math.abs(x - optionsModel.spotPrice) < 0.001) {
                currentSpotFound = true;
                lineValueAtSpot = y;
            }
        }

        if (currentSpotFound) {
            gammaMarker.append(optionsModel.spotPrice, lineValueAtSpot);
        } else {
            gammaMarker.append(optionsModel.spotPrice, optionsModel.gamma);
        }

        gammaAxisX.min = Math.min(Math.max(1, optionsModel.strikePrice * 0.5), optionsModel.spotPrice * 0.8);
        gammaAxisX.max = Math.max(optionsModel.strikePrice * 1.5, optionsModel.spotPrice * 1.2);
        gammaAxisY.max = maxY * 1.1 || 0.1;
    }

    Component.onCompleted: {
        updatePriceChart();
        updateDeltaChart();
        updateGammaChart();
    }

    Connections {
        target: optionsModel

        function onPriceSeriesDataChanged() { updatePriceChart() }
        function onDeltaSeriesDataChanged() { updateDeltaChart() }
        function onGammaSeriesDataChanged() { updateGammaChart() }

        function onDataChanged() {
            updatePriceChart();
            updateDeltaChart();
            updateGammaChart();
        }

        function onSpotPriceChanged() {

            priceAxisX.min = Math.min(priceAxisX.min, optionsModel.spotPrice * 0.9);
            priceAxisX.max = Math.max(priceAxisX.max, optionsModel.spotPrice * 1.1);

            deltaAxisX.min = Math.min(deltaAxisX.min, optionsModel.spotPrice * 0.9);
            deltaAxisX.max = Math.max(deltaAxisX.max, optionsModel.spotPrice * 1.1);

            gammaAxisX.min = Math.min(gammaAxisX.min, optionsModel.spotPrice * 0.9);
            gammaAxisX.max = Math.max(gammaAxisX.max, optionsModel.spotPrice * 1.1);
        }

        function onIsCallOptionChanged() {
            deltaAxisY.min = optionsModel.isCallOption ? -0.1 : -1.1;
            deltaAxisY.max = optionsModel.isCallOption ? 1.1 : 0.1;
        }

        function onStrikePriceChanged() {
            priceAxisX.min = Math.max(1, optionsModel.strikePrice * 0.5);
            priceAxisX.max = optionsModel.strikePrice * 1.5;

            deltaAxisX.min = Math.max(1, optionsModel.strikePrice * 0.5);
            deltaAxisX.max = optionsModel.strikePrice * 1.5;

            gammaAxisX.min = Math.max(1, optionsModel.strikePrice * 0.5);
            gammaAxisX.max = optionsModel.strikePrice * 1.5;
        }

        function onOptionPriceChanged() {
            priceMarker.clear();
            priceMarker.append(optionsModel.spotPrice, optionsModel.optionPrice);
        }

        function onGreeksChanged() {
            deltaMarker.clear();
            deltaMarker.append(optionsModel.spotPrice, optionsModel.delta);

            gammaMarker.clear();
            gammaMarker.append(optionsModel.spotPrice, optionsModel.gamma);
        }
    }
}
