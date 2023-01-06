console.log("Msg Start - script is running.");
var origOpen = XMLHttpRequest.prototype.open;
XMLHttpRequest.prototype.open = function() {
    this.addEventListener('load', function() {
        if (this.responseURL.includes('/kcsapi/')) {
            console.log("Msg URL - " + this.responseURL);
            KcapiToFlutter(this);
        }
    });
    origOpen.apply(this, arguments);
};

function KcapiToFlutter(data) {
    console.log("Msg Data - " + data.responseText);
}