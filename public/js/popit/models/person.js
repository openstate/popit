define( [ 'Backbone' ], function ( Backbone  ) {

  var PersonModel = Backbone.Model.extend({
    urlRoot: '/api/v1/person',
    schema: {
      name:    { dataType: 'Text', validators: ['required'] },
      slug:    { dataType: 'Text', validators: ['required'] },
      summary: { dataType: 'TextArea' }
    }
  });

  return PersonModel;

});