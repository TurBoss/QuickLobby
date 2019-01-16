import QtQuick 2.11
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.4

Rectangle {
    id: root
    anchors.fill: parent
    height: 600
    RowLayout{
        anchors.fill: parent

        ColumnLayout {
            ListView {
                id: roomView
                width: 180
                Layout.fillWidth: true
                Layout.fillHeight: true
                topMargin: 10
                leftMargin: 10
                bottomMargin: 10
                rightMargin: 10
                spacing: 20
                model: ["Server", "Moderator", "Main", "Sy", "moddev", "S44", "SpringLobby", "es", "main", "newbies"]
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
                        source: "../img/1.svg"
                    }
                    onClicked: {
                        console.log(modelData)
                    }

                }
            ScrollBar.vertical: ScrollBar {}
            }
        }

        ColumnLayout {

            ListView {
                id: chatView
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.margins: pane.leftPadding + messageField.leftPadding
                displayMarginBeginning: 10
                displayMarginEnd: 10
                verticalLayoutDirection: ListView.BottomToTop
                spacing: 12
                model: ["te", "tas"]
                delegate: Column {
                    anchors.right: sentByMe ? parent.right : undefined
                    spacing: 6

                    readonly property bool sentByMe: model.recipient !== "Me"

                    Row {
                        id: messageRow
                        spacing: 6
                        anchors.right: sentByMe ? parent.right : undefined

                        Image {
                            id: avatar
                            source: !sentByMe ? "qrc:/" + model.author.replace(" ", "_") + ".png" : ""
                        }

                        Rectangle {
                            width: Math.min(messageText.implicitWidth + 24, chatView.width - avatar.width - messageRow.spacing)
                            height: messageText.implicitHeight + 24
                            color: sentByMe ? "lightgrey" : "steelblue"

                            Label {
                                id: messageText
                                text: model.message
                                color: sentByMe ? "black" : "white"
                                anchors.fill: parent
                                anchors.margins: 12
                                wrapMode: Label.Wrap
                            }
                        }
                    }

                    Label {
                        id: timestampText
                        text: Qt.formatDateTime(model.timestamp, "d MMM hh:mm")
                        color: "lightgrey"
                        anchors.right: sentByMe ? parent.right : undefined
                    }
                }

                ScrollBar.vertical: ScrollBar {}
            }

            Pane {
                id: pane
                Layout.fillWidth: true

                RowLayout {
                    width: parent.width

                    TextArea {
                        id: messageField
                        Layout.fillWidth: true
                        placeholderText: qsTr("Compose message")
                        wrapMode: TextArea.Wrap
                    }

                    Button {
                        id: sendButton
                        text: qsTr("Send")
                        enabled: messageField.length > 0
                        onClicked: {
                            chatView.model.sendMessage(inConversationWith, messageField.text);
                            messageField.text = "";
                        }
                    }
                }
            }
        }

        ColumnLayout {
            ListView {
                id: usersView
                width: 180
                Layout.fillWidth: true
                Layout.fillHeight: true
                topMargin: 10
                leftMargin: 10
                bottomMargin: 10
                rightMargin: 10
                spacing: 20
                model: ["Albert Einstein", "Ernest Hemingway", "Hans Gude"]

                delegate: ItemDelegate {
                    text: modelData
                    width: usersView.width - usersView.leftMargin - usersView.rightMargin
                    height: 45
                    leftPadding: 45 + 32

                    Image {
                        id: userAvatar
                        sourceSize.height: 45
                        sourceSize.width: 45
                        fillMode: Image.Tile
                        source: "../img/2.svg"
                    }
                    onClicked: {
                        console.log(modelData)
                    }
                }

            ScrollBar.vertical: ScrollBar {}
            }
        }
    }
}
