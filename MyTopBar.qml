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
    property int rotAngle: rotationSlider.sliderValue

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

    CustomSlider{
        id: rotationSlider

        anchors{
            left: crossBt.right
            verticalCenter: parent.verticalCenter
            right: column.left
        }
    }

    ButtonGroup {
        buttons: column.children

        onClicked: {
            primitiveType = button.text

            if(primitiveType == "Масштаб"){
                rotationSlider.reset(180)
            }
            else {
                rotationSlider.reset(0)
            }
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
            id: bTrans
            checked: true
            text: qsTr("Перемещение")

            contentItem: Text {
                text: bTrans.text
                font: bTrans.font
                opacity: enabled ? 1.0 : 0.3
                color: "white"
                verticalAlignment: Text.AlignVCenter
                leftPadding: bTrans.indicator.width + bTrans.spacing
            }
        }

        RadioButton {
            id: bRot
            checked: true
            text: qsTr("Вращение")

            contentItem: Text {
                text: bRot.text
                font: bRot.font
                opacity: enabled ? 1.0 : 0.3
                color: "white"
                verticalAlignment: Text.AlignVCenter
                leftPadding: bRot.indicator.width + bRot.spacing
            }
        }

        RadioButton {
            id: bScale
            checked: true
            text: qsTr("Масштаб")

            contentItem: Text {
                text: bScale.text
                font: bScale.font
                opacity: enabled ? 1.0 : 0.3
                color: "white"
                verticalAlignment: Text.AlignVCenter
                leftPadding: bScale.indicator.width + bScale.spacing
            }
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

