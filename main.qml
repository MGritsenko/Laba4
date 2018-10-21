import QtQuick 2.10
import QtQuick.Window 2.10
import QtQuick.Dialogs 1.1

Window {
    id: root
    visible: true
    width: 1280
    height: 960
    minimumHeight: height
    maximumHeight: height
    minimumWidth: width
    maximumWidth: width
    title: qsTr("Hello lab 4")

    property int crossed: -1
    property string crossText: ""

    MyTopBar{
        id: topBar
        width: parent.width
        height: 60

        onClear: {
            canvas.clear()
            selectionRectangle.destroySelection()
        }

        onSelect: {
            selectionRectangle.create()
        }

        onIsCrossed: {
            crossed = canvas.findLines(selectionRectangle.dragX,
                                       selectionRectangle.dragY,
                                       selectionRectangle.dragWidth,
                                       selectionRectangle.dragHeight)


            switch(crossed){
            case 0: crossText = "Не пересекаются"
                break
            case 1: crossText = "Пересекаются"
                break
            case 2: crossText = "Отрезки не выделены"
                break
            case 3: crossText = "Выделите еще один отрезок"
            }
        }

        onPrimitiveTypeChanged: {
            canvas.primitiveType = primitiveType
        }

        onRotAngleChanged: {
            if(canvas.primitiveType == "Вращение"){
                canvas.doRotation(rotAngle)
            } else if (canvas.primitiveType == "Масштаб") {
                canvas.doScale(rotAngle)
            }
        }
    }

    MyCanvas {
        id:canvas

        width: parent.width
        height: parent.height - topBar.height
        y: topBar.height

        MouseArea {
            id:mouseArea
            anchors.fill: canvas
            acceptedButtons: Qt.LeftButton | Qt.RightButton

            onPressed: {
                if((mouseArea.pressedButtons & Qt.RightButton) == 0) {
                    var tmp = canvas.dot
                    tmp = 0
                    tmp = [mouseX, mouseY]
                    canvas.dot = tmp
                } else {
                    tmp = canvas.dot
                    tmp = 0
                    tmp = [mouseX, mouseY]
                    canvas.dot = tmp

                    canvas.lockPolygon()
                }
            }
        }

        SelectionRectangle{
            id: selectionRectangle
            width: 150
            height: 150

            onDragXChanged: {
                if(canvas.primitiveType == "Перемещение"){
                    canvas.doTranslateX(dragX)
                }
            }

            onDragYChanged: {
                if(canvas.primitiveType == "Перемещение"){
                    canvas.doTranslateY(dragY)
                }
            }
        }
    }

    MessageDialog {
        id: messageDialog
        title: "Пересечение двух отрезков"
        text: crossText

        onAccepted: {
            close()
            crossed = -1
        }

        visible: crossed !== -1
    }
}



















