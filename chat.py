# -*- coding: utf-8 -*-

import os
import sys
import time
import yaml

from PyQt5.QtCore import pyqtProperty, QCoreApplication, QObject, QUrl
from PyQt5.QtQml import qmlRegisterType, QQmlComponent, QQmlEngine

from PyQt5 import QtNetwork
from PyQt5.QtCore import QFile, QIODevice
from PyQt5.QtWidgets import QWidget, QApplication, QVBoxLayout, QPushButton, QListWidget, QMessageBox, QHBoxLayout, \
    QLineEdit


class Chat(QObject):
    def __init__(self):
        super(Chat, self).__init__(self)
