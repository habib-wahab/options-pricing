# Option Pricing Visualisation Tool

A Qt Quick application for visualising option pricing and the Greeks using the Black-Scholes model.

## Features

- Interactive visualisation of option prices and Greeks (Delta, Gamma)
- Real-time calculation of option values
- Support for both call and put options
- Adjustable parameters:
  - Spot price
  - Strike price
  - Volatility
  - Risk-free rate
  - Time to expiry
- Dark/Light mode toggle for comfortable viewing in different environments
- Responsive design with proper resising behavior

## Screenshots
![image](https://github.com/user-attachments/assets/561973d2-936f-470c-a422-f197ba16a53e)
![image](https://github.com/user-attachments/assets/ad2ba41c-015f-4d00-8c15-118afaf7de39)

## Requirements

- Qt 6.8 or higher
- QtQuick, QtCharts components

## Project Structure

The application consists of:
- QML UI for the visualiation interface
- C++ backend (OptionsModel) for Black-Scholes calculations
- Interactive charts for option price, delta, and gamma

## Building and Running

### Prerequisites
- Qt development environment (Qt Creator recommended)
- C++ compiler compatible with your Qt version

### Steps
1. Clone the repository:
```
git clone https://github.com/habib-wahab/options-pricing.git
```

2. Open the project in Qt Creator or build from command line:
```
cd options-pricing
qmake
make
```

3. Run the application:
```
./options-pricing
```

## Usage

1. Adjust option parameters using the sliders on the left panel
2. Switch between call and put options using the radio buttons
3. View different Greeks by selecting the appropriate tab
4. Toggle between dark and light modes using the switch in the header
