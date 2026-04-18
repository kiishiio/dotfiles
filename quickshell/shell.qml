import QtQuick
import Quickshell
import Quickshell.Io
import QtQuick.Layouts
import QtQuick.Controls
import QtCore
import Qt.labs.settings

ShellRoot {
    id: root


    property var screens: Quickshell.screens
    property string color: cfg.dark_mode ? "white" : "black" //TODO dark mode updates
    property string current_screen: get_screen_name()

    function increment_screen_index() {
        cfg.screen_index = (cfg.screen_index + 1) % screens.length
        return screens[cfg.screen_index]
    }

    function get_screen_name() {
        return root.screens[cfg.screen_index].name
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

                RowLayout {
                    spacing: cfg.spacing

                    Button {
                        onClicked: {
                            bar.screen = root.increment_screen_index()
                            root.current_screen = root.get_screen_name()
                        }
                        text: root.screens[cfg.screen_index].name || "Screen " + (cfg.screen_index + 1)
                    }

                    Button {
                        property string path: ".config/hypatia/example/pipeline.kdl"
                        property string opt: "--no-pause --volume=50.0"

                        onClicked: {
                            cmd.running = false
                            cmd.command = ["sh", "-c", "hypatia play $HOME/$0 --output $1 $2", path, root.current_screen, opt]
                            cmd.running = true
                        }
                        text: "wallpaper"
                    }
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

                    color: root.color
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

    Process {
        id: cmd
    }

    Settings {
        id: cfg

        fileName: ".config/presentation.ini"

        property int screen_index: 0

        property bool dark_mode: true
        property int spacing: 3
    }
}
