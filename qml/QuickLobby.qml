import QtQuick 2.11
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.3

ApplicationWindow {
    Material.theme:Material.Dark
    Material.background:"black"
    Material.foreground:"white"
    Material.accent:"#8cd3ff"
    Material.primary :Material.Blue
    id: lobby
    width: 1024
    height: 768
    title: "QuickLobby"

    TabBar {
        id: bar
        width: parent.width
        position: TabBar.Header

        TabButton {
            text: qsTr("Battle")
            width: implicitWidth
        }
        TabButton {
            text: qsTr("Chat")
            width: implicitWidth
        }
        TabButton {
            text: qsTr("Replays")
            width: implicitWidth
        }
        TabButton {
            text: qsTr("Downloads")
            width: implicitWidth
        }
    }
    StackLayout {
        y: bar.height
        width: parent.width
        height: parent.height - bar.height
        currentIndex: bar.currentIndex
        Item {
            id: battle
            BattleListPlugin {}
        }
        Item {
            id: chat
            MainChatPlugin {}
        }
        Item {
            id: replays
        }
        Item {
            id: downloads
        }
    }
    LobbyLogin  {}
}
