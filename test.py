import asyncio
import signal

from PyQt5.QtCore import QAbstractTableModel, QModelIndex, Qt
from PyQt5.QtWidgets import QApplication, QMainWindow
from PyQt5 import QtWidgets

INVALID_INDEX = QModelIndex()

QUAMASH = False


class TableModel(QAbstractTableModel):

    def __init__(self, parent):
        super().__init__(parent)
        self.parent = parent
        self.records = []
        self.count = 0
        self.columns = ['column']

    def columnCount(self, index):
        if not index.isValid():
            return len(self.columns)
        else:
            return 0

    def rowCount(self, index):
        if index.isValid():
            return 0
        else:
            return len(self.records)

    def data(self, index, role=Qt.DisplayRole):
        result = None
        if index.isValid():
            record = self.records[index.row()]
            if role == Qt.DisplayRole:
                return record
        return result

    def headerData(self, section, orientation, role):
        result = None
        if orientation == Qt.Horizontal and role == Qt.DisplayRole:
            result = self.columns[section]
        return result

    def add_row(self, record):
        pos = len(self.records)
        self.beginInsertRows(INVALID_INDEX, pos, pos)
        self.records.append(record)
        self.endInsertRows()
        self.count += 1

    def clear(self):
        self.records.clear()


class MainWindow(QMainWindow):

    def __init__(self, loop):
        self.loop = loop
        super().__init__()

        self.stop_signal = self.loop.create_future()
        self.table_shown = True

        self.setupUi()
        self.loop.create_task(monitor(self.table_model, self))
        self.loop.create_task(self.loop_add_row())

    def setupUi(self):
        self.resize(800, 600)
        self.centralwidget = QtWidgets.QWidget(self)
        self.verticalLayout = QtWidgets.QVBoxLayout(self.centralwidget)
        self.logTable = QtWidgets.QTableView(self.centralwidget)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Expanding)
        sizePolicy.setVerticalStretch(69)
        self.logTable.setSizePolicy(sizePolicy)
        self.verticalLayout.addWidget(self.logTable)
        spacerItem = QtWidgets.QSpacerItem(20, 10, QtWidgets.QSizePolicy.Minimum, QtWidgets.QSizePolicy.Expanding)
        self.verticalLayout.addItem(spacerItem)
        self.hideButton = QtWidgets.QPushButton(self.centralwidget)
        self.hideButton.setText("Hide or unhide table")
        self.verticalLayout.addWidget(self.hideButton)
        self.setCentralWidget(self.centralwidget)
        self.statusbar = QtWidgets.QStatusBar(self)
        self.setStatusBar(self.statusbar)

        self.table_model = TableModel(self)

        self.logTable.setModel(self.table_model)
        self.logTable.verticalScrollBar().rangeChanged.connect(self.logTable.scrollToBottom)

        self.hideButton.clicked.connect(self.toggle_table_shown)

        self.setWindowTitle('QT TESTING WINDOW')

        self.show()

    def toggle_table_shown(self):
        if self.table_shown:
            self.logTable.hide()
        else:
            self.logTable.show()
        self.table_shown = not self.table_shown

    async def loop_add_row(self):
        c = 0
        while True:
            self.table_model.add_row(f"row {c}")
            c += 1
            done, pending = await asyncio.wait([asyncio.sleep(1e-6), self.stop_signal],
                                               return_when=asyncio.FIRST_COMPLETED)
            if self.stop_signal in done:
                return

    def closeEvent(self, event):
        self.shutdown()
        event.accept()

    def shutdown(self, signal=None):
        try:
            print("stopping")
            self.stop_signal.set_result('shutdown')
            self.close()
        except asyncio.InvalidStateError:
            raise SystemExit


async def monitor(model, window):
    while True:
        await asyncio.sleep(1)
        status = f"{model.count} rows/s"
        print(status)
        window.statusBar().showMessage(status)
        model.count = 0


async def process_events(qapp):
    while True:
        await asyncio.sleep(0)
        qapp.processEvents()


if __name__ == "__main__":

    app = QApplication([])

    if QUAMASH:
        from quamash import QEventLoop

        loop = QEventLoop(app)
        asyncio.set_event_loop(loop)
    else:
        loop = asyncio.get_event_loop()

    main = MainWindow(loop)
    loop.add_signal_handler(signal.SIGINT, main.shutdown, None)

    if QUAMASH:
        with loop:
            loop.run_forever()
    else:
        loop.run_until_complete(process_events(app))

    app.closeAllWindows()
