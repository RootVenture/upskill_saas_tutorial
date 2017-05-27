/* global $, Stripe */

// Document Ready function to pause and JS until the page loads
$(document).on('turbolinks:load', function() {
  var theForm = $('#pro_form');
  var submitBtn = $('#form-submit-btn');
  // Set stripe public key before we send CC info to stripe
  // this is how stripe identifies us
  Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content') );
  
  // When user clicks form submit btn 
  submitBtn.click(function(event){
    // prevent default submission behavior
    event.preventDefault();
    
    // Collect credit card fields.
    var ccNum = $('#card_number').val(), 
      cvcNum = $('#card_code').val(),
      expMonth = $('card_month').val(),
      expYear = $('card_year').val();
    // Send CC info to stripe.
    Stripe.createToken({
      number: ccNum,
      cvc: cvcNum,
      exp_month: expMonth,
      exp_year: expYear
    }, stripeResponseHandler);
  });
    

  // Stripe will return back Card token
  // Card token will be injected into this form as a hidden form
  // This prompts the form to submission to our Rails app.


});
