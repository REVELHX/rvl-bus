$("#container").hide();
$(function () {
  window.addEventListener("message", function (event) {
    var item = event.data;

    if (item.type === "main") {
      if (item.status) {
        $("#container").show();
      } else {
        $("#container").hide();
      }
    }
  });


  document.onkeyup = function (data) {
    if (data.which == 27) {
      $.post(
        "https://RevelFixlight/callbacks",
        JSON.stringify({
          action: "close",
        })
      );
    }
  };



  $("#start-job").click(function () {
    $.post(
      "https://RevelFixlight/callbacks",
      JSON.stringify({
        action: "start"
      })
    );
  });


});

