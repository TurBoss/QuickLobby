import QtQuick 2.11
import QtQuick.Window 2.11
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.4

Popup {
    id: loggin
    width: 400
    height: 400

    x: parent.width / 2 - width / 2
    y: parent.height /2 - height / 2

    modal: true
    focus: true

    visible: true


    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

    TabBar {
        id: bar
        width: parent.width
        position: TabBar.Header

        TabButton {
            text: qsTr("Login")
            width: implicitWidth
        }
        TabButton {
            text: qsTr("Register")
            width: implicitWidth
        }
    }
    StackLayout {
        y: bar.height
        width: parent.width
        height: parent.height - bar.height
        currentIndex: bar.currentIndex
        Item {
            id: login
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 3
                spacing: 3

                TextField {
                    id: login_username
                    Layout.fillWidth: true
                    placeholderText: "Username"
                    enabled: true
                }

                TextField {
                    id: login_password
                    Layout.fillWidth: true
                    echoMode: TextInput.Password
                    placeholderText: "Pasword"
                    enabled: true
                }

                Button {
                    id: login_button
                    Layout.fillWidth: true
                    text: "Login"

                    onClicked: {

                    }
                }
            }
        }
        Item {
            id: register
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 3
                spacing: 3

                TextField {
                    id: register_username
                    Layout.fillWidth: true
                    placeholderText: "Username"
                    enabled: true
                }
                TextField {
                    id: register_email
                    Layout.fillWidth: true
                    placeholderText: "Email"
                    enabled: true
                }

                TextField {
                    id: register_password
                    Layout.fillWidth: true
                    echoMode: TextInput.Password
                    placeholderText: "Pasword"
                    enabled: true
                }

                TextField {
                    id: register_password2
                    Layout.fillWidth: true
                    echoMode: TextInput.Password
                    placeholderText: "Pasword"
                    enabled: true
                }

                Button {
                    id: register_button
                    Layout.fillWidth: true
                    text: "Register"

                    onClicked: {

                    }
                }
            }
        }
    }


}
