import QtQuick 2.10
import QtQuick.Controls 2.2

Item{
    property int sliderValue: slider.value

    Slider{
        id: slider
        anchors{
            left: parent.left
            leftMargin: 20
            verticalCenter: parent.verticalCenter
            right: sliderText.left
            rightMargin: 20
        }
        from: 0
        to: 360
        value: 0
        stepSize: 1
    }

    Text {
        id: sliderText
        anchors{
            verticalCenter: parent.verticalCenter
            right: parent.right
            rightMargin: 40
        }
        //text: String(slider.value)
        font.pointSize: 14
        color: "white"
    }

    function reset(myVal){
        slider.value = myVal
    }
}
