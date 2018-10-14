import QtQuick 2.0

Item {
    property var dot: []

    property var points: []
    property var line: []
    property var polygon: []

    property var rotPolygon: []

    property string primitiveType: "Точка"

    onWidthChanged: {
        canvas.requestPaint();
    }

    onHeightChanged: {
        canvas.requestPaint();
    }

    onDotChanged: {
        switch(primitiveType){
        case "Точка":
            points.push(dot)
            break
        case "Отрезок":
            line.push(dot)
            break
        case "Полигон":
            polygon.push(dot)

            var tmp = [dot[0], dot[1]]
            rotPolygon.push(tmp)
            break
        }

        canvas.requestPaint();
    }

    Canvas {
        id: canvas
        anchors.fill: parent
        antialiasing: true
        property var ctx: null

        onPaint: {

            switch(primitiveType){
            case "Точка":
                drawDot(ctx, canvas)
                break
            case "Отрезок":
                drawLine(ctx, canvas)
                break
            case "Полигон":
                drawPolygon(ctx, canvas)
                break
            }
        }

        function clear(){
            ctx = getContext("2d");
            ctx.clearRect(0, 0, canvas.width, canvas.height)

            requestPaint();
        }
    }

    function drawDot(ctx, canvas) {
        ctx = canvas.getContext("2d");

        if(points.length == 0){
            return
        }

        ctx.fillStyle = "limegreen"
        for(var i = 0; i < points.length; i++) {
            ctx.beginPath();
            ctx.arc(points[i][0], points[i][1], 3, 0, 2*Math.PI)
            ctx.fill();
        }
    }

    function drawLine(ctx, canvas){
        ctx = canvas.getContext("2d");

        if(line.length == 0){
            return
        }

        ctx.lineWidth = 2;
        ctx.strokeStyle = "limegreen"

        for(var i = 0; i < line.length - 1; i += 2) {
            ctx.beginPath()
            ctx.moveTo(line[i][0], line[i][1])
            ctx.lineTo(line[i + 1 ][0], line[i + 1][1])
            ctx.stroke()
        }
    }

    function drawPolygon(ctx, canvas){
        ctx = canvas.getContext("2d");

        if(rotPolygon.length == 0){
            return
        }

        ctx.lineWidth = 2;
        ctx.strokeStyle = "limegreen"

        ctx.beginPath()
        ctx.moveTo(rotPolygon[0][0], rotPolygon[0][1])

        for(var i = 1; i < rotPolygon.length; i++) {
            ctx.lineTo(rotPolygon[i][0], rotPolygon[i][1])
        }

        ctx.stroke()
    }

    function draw() {
        canvas.requestPaint()
    }

    function clear(){
        var tmp = points
        tmp.length = 0
        points = tmp

        tmp = line
        tmp.length = 0
        line = tmp

        tmp = polygon
        tmp.length = 0
        polygon = tmp

        var tmp2 = rotPolygon
        tmp2.length = 0
        rotPolygon = tmp2

        canvas.clear()
    }

    function lockPolygon(){
        switch(primitiveType){
        case "Полигон":
            var tmp = polygon
            tmp[tmp.length - 1] = tmp[0]
            polygon = tmp

            var tmp2 = rotPolygon
            tmp2[tmp2.length - 1] = tmp2[0]
            rotPolygon = tmp2

            canvas.requestPaint();
            break
        }

        console.log("lock")
    }

    function findLines(dragX, dragY, dragWidth, dragHeight) {

        var lines = []
        for(var i = 0; i < line.length - 1; i += 2) {

            var p1 = [Math.min(line[i][0], line[i + 1][0]), Math.min(line[i][1], line[i + 1][1])]
            var p2 = [Math.max(line[i][0], line[i + 1][0]), Math.max(line[i][1], line[i + 1][1])]

            //var p1 = [line[i][0], line[i][1]]
            //var p2 = [line[i + 1][0], line[i + 1][1]]

            if(
                    p1[0] >= dragX && p1[0] <= dragX + dragWidth &&
                    p2[0] >= dragX && p2[0] <= dragX + dragWidth &&
                    p1[1] >= dragY && p1[1] <= dragY + dragHeight &&
                    p2[1] >= dragY && p2[1] <= dragY + dragHeight)
            {
                lines.push([p1, p2])
            }
        }

        if(lines.length === 0){
            return 2
        }

        if(lines.length === 1){
            return 3
        }

        return isCrossed(lines[0], lines[1])
    }

    function isCrossed(line1, line2) {
        var eps = 1e-10

        var r1a = line1[0][1] - line1[1][1] //y1 - y2
        var r1b = line1[1][0] - line1[0][0] //x2 - x1
        var r1c = line1[0][0] * line1[1][1] - line1[1][0] * line1[0][1] //x1 * y2 - x2 * y1

        var r2a = line2[0][1] - line2[1][1] //y1 - y2
        var r2b = line2[1][0] - line2[0][0] //x2 - x1
        var r2c = line2[0][0] * line2[1][1] - line2[1][0] * line2[0][1] //x1 * y2 - x2 * y1

        var res = r1a * r2b - r2a * r1b;

        if(Math.abs(res) >= eps) {

            var x = -(r1c * r2b - r2c * r1b) / res;
            var y = -(r1a * r2c - r2a * r1c) / res;

            var firstRoad =
                    line1[0][0] <= x &&
                    line1[0][1] <= y &&
                    x <= line1[1][0] &&
                    y <= line1[1][1]

            var secondRoad =
                    line2[0][0] <= x &&
                    line2[0][1] <= y &&
                    x <= line2[1][0] &&
                    y <= line2[1][1]

            return firstRoad && secondRoad ? 1 : 0
        }

        return res !== 0 ? 1 : 0
    }

    function doRotation(degrees){

        if(points.length == 0){
            return
        }

        var rad = (degrees / 180) * Math.PI
        var cosPhi = Math.cos(rad)
        var sinPhi = Math.sin(rad)
        var cenX = points[points.length - 1][0]
        var cenY = points[points.length - 1][1]

        for(var i = 0; i < polygon.length - 1; i++){
            var dx = polygon[i][0] - cenX
            var dy = polygon[i][1] - cenY

            rotPolygon[i][0] = Math.floor(cenX + (dx * cosPhi - dy * sinPhi))
            rotPolygon[i][1] = Math.floor(cenY + (dx * sinPhi + dy * cosPhi))
        }

        canvas.clear()
        drawDot(canvas.ctx, canvas)
        canvas.requestPaint();
    }
}















