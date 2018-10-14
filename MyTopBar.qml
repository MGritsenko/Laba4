import QtQuick 2.10
import QtQuick.Window 2.10
import QtQuick.Controls 2.2

Rectangle {
    id: topBar
    width: parent.width
    height: 40

    color: "#2362cf"

    signal clear()
    signal select()
    signal isCrossed()

    property string primitiveType: "Tочка"
    property int rotAngle: rotationSlider.value

    Button{
        id: clearBt
        width: parent.width / 10
        height: 30

        text: "Очистить"

        anchors{
            verticalCenter: parent.verticalCenter
            leftMargin: 10
            left: parent.left
        }

        onClicked: {
            clear()
        }
    }

    Button{
        id: selectBt
        width: parent.width / 10
        height: 30

        text: "Выделить"

        anchors{
            verticalCenter: parent.verticalCenter
            leftMargin: 10
            left: clearBt.right
        }

        onClicked: {
            select()
        }
    }

    Button{
        id: crossBt
        width: parent.width / 10
        height: 30

        text: "Пересекаются?"

        anchors{
            verticalCenter: parent.verticalCenter
            leftMargin: 10
            left: selectBt.right
        }

        onClicked: {
            isCrossed()
        }
    }

    Slider{
        id: rotationSlider
        anchors{
            left: crossBt.right
            leftMargin: 20
            verticalCenter: parent.verticalCenter
            right: sliderVal.left
            rightMargin: 20
        }
        from: 0
        to: 360
        value: 180
        stepSize: 1
    }

    Text {
        id: sliderVal
        anchors{
            //left: rotationSlider.right
           // leftMargin: 20
            verticalCenter: parent.verticalCenter
            right: column.left
            rightMargin: 40
        }
        text: String(rotationSlider.value)
        font.pointSize: 14
        color: "white"
    }

    ButtonGroup {
        buttons: column.children

        onClicked: {
            primitiveType = button.text
        }
    }

    Row {
        id: column

        anchors {
            right: topBar.right
            rightMargin: 10
            verticalCenter: parent.verticalCenter
        }

        RadioButton {
            id: bSin
            checked: true
            text: qsTr("Точка")

            contentItem: Text {
                text: bSin.text
                font: bSin.font
                opacity: enabled ? 1.0 : 0.3
                color: "white"
                verticalAlignment: Text.AlignVCenter
                leftPadding: bSin.indicator.width + bSin.spacing
            }
        }

        RadioButton {
            id: cosB
            text: qsTr("Отрезок")

            contentItem: Text {
                text: cosB.text
                font: cosB.font
                opacity: enabled ? 1.0 : 0.3
                color: "white"
                verticalAlignment: Text.AlignVCenter
                leftPadding: cosB.indicator.width + cosB.spacing
            }
        }

        RadioButton {
            id: xB
            text: qsTr("Полигон")

            contentItem: Text {
                text: xB.text
                font: xB.font
                opacity: enabled ? 1.0 : 0.3
                color: "white"
                verticalAlignment: Text.AlignVCenter
                leftPadding: xB.indicator.width + xB.spacing
            }
        }
    }
}

