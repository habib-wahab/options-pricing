#include <QApplication>
#include <QQmlApplicationEngine>

#include "OptionsModel.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    app.setApplicationName("Option Pricing Tool");
    app.setApplicationVersion("1.0.0");

    qmlRegisterType<OptionsModel>("OptionPricingTool", 1, 0, "OptionsModel");

    QQmlApplicationEngine engine;

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection
        );

    engine.loadFromModule("options-pricing", "Main");

    return app.exec();
}
