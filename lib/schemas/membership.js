"use strict"; 

var mongoose            = require('mongoose'),
    Schema              = mongoose.Schema;

var MembershipSchema = module.exports = new Schema({
  _id: {
    type: String,
    default: function() {
      return (new mongoose.Types.ObjectId()).toHexString();
    }
  },

  label: { type: Schema.Types.Mixed },
  role: { type: Schema.Types.Mixed },
  person_id: { type: String, ref: "Person", required: true },
  organization_id: { type: String, ref: "Organization" },
  post_id: { type: String, ref: "Post" },
  on_behalf_of_id: { type: String, ref: "Organization" },
  start_date: String,
  end_date: String,
  area: {
    name: String,
    identifier: String,
    classification: String,
    parent_id: String
  }
}, { strict: false, collection: 'memberships' } );

MembershipSchema.virtual('url').get(function() {
  return '/' + this.constructor.collection.name + '/' + encodeURIComponent(this._id);
});

MembershipSchema
  .virtual('name')
  .get( function () { return this.role; } );

