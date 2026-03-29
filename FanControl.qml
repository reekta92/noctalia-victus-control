import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

RowLayout {
    id: fanControl
    spacing: 4

    property string currentMode: "AUTO"

    // This background process updates the state file for the root daemon
    Process {
        id: stateWriter
        command: ["bash", "-c", "echo " + fanControl.currentMode + " > /var/tmp/victus_fan_mode"]
    }

    function setMode(mode) {
        currentMode = mode;
        stateWriter.running = true;
    }

    // AUTO Button
    Rectangle {
        width: 45
        height: 24
        color: currentMode === "AUTO" ? "#7fc8ff" : "#333333"
        radius: 4
        
        Text {
            anchors.centerIn: parent
            text: "AUTO"
            color: currentMode === "AUTO" ? "#000000" : "#ffffff"
            font.pixelSize: 11
            font.bold: true
        }
        
        MouseArea {
            anchors.fill: parent
            onClicked: setMode("AUTO")
        }
    }

    // MEDIUM Button
    Rectangle {
        width: 45
        height: 24
        color: currentMode === "MEDIUM" ? "#7fc8ff" : "#333333"
        radius: 4
        
        Text {
            anchors.centerIn: parent
            text: "MED"
            color: currentMode === "MEDIUM" ? "#000000" : "#ffffff"
            font.pixelSize: 11
            font.bold: true
        }
        
        MouseArea {
            anchors.fill: parent
            onClicked: setMode("MEDIUM")
        }
    }

    // MAX Button
    Rectangle {
        width: 45
        height: 24
        color: currentMode === "MAX" ? "#7fc8ff" : "#333333"
        radius: 4
        
        Text {
            anchors.centerIn: parent
            text: "MAX"
            color: currentMode === "MAX" ? "#000000" : "#ffffff"
            font.pixelSize: 11
            font.bold: true
        }
        
        MouseArea {
            anchors.fill: parent
            onClicked: setMode("MAX")
        }
    }
}
