$(function() {
  $('[data-scroll=true]')
    .filter('*[href*=#]:not([href=#]), *[data-target]')
    .click(function(evt) {
      var hasPathname = this.pathname !== undefined;

      if (!hasPathname || (location.pathname.replace(/^\//,'') == this.pathname.replace(/^\//,'') && location.hostname == this.hostname)) {
        var target = $(this.hash);
        if (target.length === 0) {
          target =  $($(evt.currentTarget).attr("data-target"));
        }

        var time = 2000;
        var offset = 10;
        var customTime = $(evt.currentTarget).attr("data-scroll-time");
        var customOffset = $(evt.currentTarget).attr("data-scroll-offset");

        if (customTime) {
          time = parseInt(customTime);
        }

        if (customOffset) {
          offset = parseInt(customOffset);
        }

        if (target.length) {
          $('html,body').animate({
            scrollTop: target.offset().top - offset
          }, time);

          // show hash in url without page jump
          history.pushState(null, null, this.hash);
          return false;
        }
      }
  });
});
