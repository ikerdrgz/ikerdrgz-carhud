$(function() {
    window.addEventListener('message', function (event) {  
        let speed = (event.data.speed -1)
        let show = event.data.show
        let seatbelt = event.data.seatbelt
        let fuel = event.data.fuel

        if (speed == -1 ) {
            speed = '0'
        }

        if (show) {
            $('.main-div').show()
        } else {
            $('.main-div').hide()
        }

        if (speed !== 0) {
            $('#text').html(speed)
        }

        if (fuel < 25) {
            $('#fuel').show()
            $('#fuel').css('opacity', '1.0');
            $('#fuel').attr('src', 'assets/fuel.png');
            $('#fuel').css('animation', 'blink 1000ms infinite');
        } else {
            $('#fuel').hide()
            $('#fuel').css('opacity', '0');
            $('#fuel').attr('src', '');
            $('#fuel').css('animation', '');
        }

        if (!seatbelt) {
            $('#seatbelt').show()
            $('#seatbelt').css('opacity', '1.0');
            $('#seatbelt').attr('src', 'assets/seatbelt.png');
            $('#seatbelt').css('animation', 'blink 1000ms infinite');
        } else {
            $('#seatbelt').hide()
            $('#seatbelt').css('opacity', '0');
            $('#seatbelt').attr('src', '');
            $('#seatbelt').css('animation', '');
        }
    })
})