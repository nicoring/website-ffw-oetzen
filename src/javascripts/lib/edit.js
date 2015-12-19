$(function() {
  var baseurl = "http://nicoring.de:4001";

  $('[data-edit]')
    .each(function(i, el) {

      var type = el.dataset.edit;
      var id = el.dataset.editId;
      var $elem = $(el);

      $elem.css({
        'background-color': '#c2c2c2',
        padding: "10px"
      });

      $elem.editable(baseurl + "/" + type + "/" + id, {
        loadurl   : baseurl + "/" + type + "/" + id,
        type      : 'textarea',
        cancel    : 'Abbrechen',
        submit    : 'Speichern',
        indicator : 'Saving...',
        tooltip   : 'Click to edit...'
      });
    })
});
