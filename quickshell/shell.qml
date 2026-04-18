import QtQuick
import Quickshell
import QtQuick.Layouts
import QtQuick.Controls
import Qt.labs.settings

ShellRoot {
    id: root

    property var screens: Quickshell.screens

    function increment_screen_index() {
        cfg.screen_index = (cfg.screen_index + 1) % screens.length
        return screens[cfg.screen_index]
    }

    PanelWindow {
        id: bar
        implicitHeight: 25
        color: "#10f0f8ff"
        screen: root.screens[cfg.screen_index]
        anchors {
            top: true
            left: true
            right: true
        }

        RowLayout {
            anchors.fill: parent

            Rectangle {
                id: bar_left

                color: "transparent"
                Layout.alignment: Qt.AlignLeft
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.leftMargin: 3

                Button {
                    onClicked: bar.screen = root.increment_screen_index()
                    text: root.screens[cfg.screen_index].name || "Screen " + (cfg.screen_index + 1)
                }
            }

            Rectangle {
                id: bar_center

                color: "transparent"
                Layout.alignment: Qt.AlignCenter
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.leftMargin: 3
                Layout.rightMargin: 3
            }

            Rectangle {
                id: bar_right

                color: "transparent"
                Layout.alignment: Qt.AlignRight
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.rightMargin: 3


                Text {
                    id: clock

                    anchors.right: parent.right
                    text: Qt.formatTime(new Date(), "hh:mm:ss")
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }

    Timer {
        id: time
        running: true
        repeat: true
        interval: 1000
        onTriggered: clock.text = Qt.formatTime(new Date(), "hh:mm:ss")
    }

    Settings {
        id: cfg

        category: "ephemeral"
        fileName: ".config/presentation.ini"

        property int screen_index: 0
    }
}
