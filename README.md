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
- Risk Analysis Dashboard including:
  - Probability metrics (ITM/OTM)
  - Break-even analysis
  - Option sensitivity measures
  - Payoff diagram
  - Price distribution at expiry
  - Intrinsic and time value calculations
- Dark/Light mode toggle for comfortable viewing in different environments
- Responsive design with proper resising behavior

## Screenshots

![image](https://github.com/user-attachments/assets/eeef9b63-8475-4381-99b5-b730293736f0)
![image](https://github.com/user-attachments/assets/32428a4d-5ed9-49f0-9566-229234c52fad)
![image](https://github.com/user-attachments/assets/4c4a7dcb-8b21-4b18-b607-a9bb03e502ba)

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

Installation
Steps

Clone the repository:

git clone https://github.com/habib-wahab/options-pricing.git

Open the project in Qt Creator:

Launch Qt Creator
Select "Open Project"
Navigate to the cloned repository and select the CMakeLists.txt file
Configure the project when prompted

Build and run directly from Qt Creator using the Run button

2. Open the project in Qt Creator:
   - Launch Qt Creator
   - Select "Open Project"
   - Navigate to the cloned repository and select the CMakeLists.txt file
   - Configure the project when prompted

3. Build and run directly from Qt Creator using the Run button

## Usage

1. Adjust option parameters using the sliders on the left panel
2. Switch between call and put options using the radio buttons
3. View different Greeks by selecting the appropriate tab
4. Toggle between dark and light modes using the switch in the header
