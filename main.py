# -*- coding: utf-8 -*-

import os
import signal
import sys
import time
import asyncio
import yaml
import ssl

from hashlib import md5
from base64 import b64encode as ENCODE_FUNC

import logging

from asyncspring.spring import connect

from PyQt5.QtCore import QUrl, pyqtSlot, pyqtSignal, QObject
from PyQt5.QtQml import QQmlApplicationEngine

from quamash import QEventLoop, QApplication


logging.basicConfig(level=logging.DEBUG)
logging.getLogger("quamash").setLevel(level=logging.INFO)


def encode_password(password):
    return ENCODE_FUNC(md5(password.encode()).digest()).decode()


class QuickLobby(QQmlApplicationEngine):

    loginSuccesSignal = pyqtSignal(int, arguments=['result'])
    registerSignal = pyqtSignal(int, arguments=['register'])

    def __init__(self, loop):
        self.loop = loop
        super(QuickLobby, self).__init__()

        self.stop_signal = self.loop.create_future()

        self.load(QUrl('qml/QuickLobby.qml'))
        self.rootContext().setContextProperty("quicklobby", self)

        with open("config.yaml", 'r') as yml_file:
            cfg = yaml.load(yml_file)

        self.lobby_host = cfg["server"]["host"]
        self.lobby_port = cfg["server"]["port"]

        self.client = None

    @pyqtSlot('QString', 'QString')
    def login(self, username, password):
        if self.client is None:
            password = encode_password(password)

            self.client = asyncio.coroutine(self._lobby_connect(username, password))

            self.loginSuccesSignal.emit(True)
            print("loged in")

        else:
            print("already login")

    @pyqtSlot('QString', 'QString', 'QString', 'QString')
    def register(self, username, email, password1, password2):

        self.registerSignal.emit()

    def closeEvent(self, event):
        self.shutdown()
        event.accept()

    def shutdown(self, signal=None):
        try:
            print("stopping")
            self.stop_signal.set_result('shutdown')
        except asyncio.InvalidStateError:
            raise SystemExit

    async def _lobby_connect(self, username, password):

        if self.client is None:
            self.client = await connect(self.lobby_host, port=self.lobby_port, use_ssl=False)
            self.client.login(username, password)

            @self.client.on("said")
            def incoming_message(parsed, user, target, text):
                print(parsed)
                # parsed is an RFC1459Message object
                # user is a User object with nick, user, and host attributes
                # target is a string representing nick/channel the message was sent to
                # text is the text of the message
                # self.client.say(target, "{}: you said {}".format(user.nick, text))


def main():
    app = QApplication(sys.argv)
    loop = QEventLoop(app)
    # loop.set_debug(True)
    asyncio.set_event_loop(loop)  # NEW must set the event loop

    lobby = QuickLobby(loop)
    loop.add_signal_handler(signal.SIGINT, lobby.shutdown, None)

    for window in lobby.rootObjects():
        window.show()

    with loop:
        loop.run_forever()


if __name__ == "__main__":
    main()
