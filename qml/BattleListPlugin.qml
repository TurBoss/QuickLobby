import QtQuick 2.11
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.4

Rectangle {
    id: root
    anchors.fill: parent
    height: parent.height
    ColumnLayout{
        ColumnLayout {
            ListView {
                id: roomView
                width: parent.width
                height: root.height - pane.height
                Layout.fillWidth: true
                Layout.fillHeight: true
                topMargin: 10
                leftMargin: 10
                bottomMargin: 10
                rightMargin: 10
                spacing: 20
                model: ["BA DSD", "tc:elite", "Planet", "Absolut"]
                delegate: ItemDelegate {
                    text: modelData
                    width: roomView.width - roomView.leftMargin - roomView.rightMargin
                    height: 45
                    leftPadding: 45 + 32

                    Image {
                        id: roomAvatar
                        sourceSize.height: 45
                        sourceSize.width: 45
                        fillMode: Image.Tile
                        source: "../img/battle.svg"
                    }

                    onClicked: {
                        console.log(modelData)
                    }

                }
            ScrollBar.vertical: ScrollBar {}
            }
        }
        ColumnLayout {
            Pane {
                y: roomView.height
                id: pane
                Layout.fillWidth: true

                RowLayout {
                    width: parent.width

                    TextArea {
                        id: filter
                        placeholderText: qsTr("Filter")
                    }
                    CheckBox {
                        id: passwored
                        text: qsTr("Password")
                    }
                    CheckBox {
                        id: empty
                        text: qsTr("Hide empty")
                    }
                }
            }
        }
    }
}
