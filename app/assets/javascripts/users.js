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
    submitBtn.val('Processing').prop('disabled', true);
    
    // Collect credit card fields.
    var ccNum = $('#card_number').val(), 
      cvcNum = $('#card_code').val(),
      expMonth = $('card_month').val(),
      expYear = $('card_year').val();
      
    // Use Strine JS library to check for card errors.
    var error = false;
    
    //Validate card number
    if (!Stripe.card.validateCardNumber(ccNum)) {
      error = true;
      alert('The credit card number appears to be invalid');
    }
    
    //Validate CVC number
    if (!Stripe.card.validateCVC(cvcNum)) {
      error = true;
      alert('The CVC number appears to be invalid');
    }
    
    //Validate expiration date
    if (!Stripe.card.validateExpiray(expMonth, expYear)) {
      error = true;
      alert('The expiration date appears to be invalid');
    }

    if (error) {
      //If there are card errors, don't send to stripe
    submitBtn.prop('disabled', false).val("Sign Up")
      
    }
    else {
        // Send CC info to stripe.
      Stripe.createToken({
        number: ccNum,
        cvc: cvcNum,
        exp_month: expMonth,
        exp_year: expYear
        }, stripeResponseHandler);
      return false;
  }); 
    }

    
  // Stripe will return back Card token
    function stripeResponseHandler(status, response){
      //get the token from Stripe's response
      var token = response.id;
      
      //Inject token in a hidden field
      theForm.append($('<input type="hidden" name="user[stripe_card_token]>"').val(token) );
    };
    
  // This prompts the form to submission to our Rails app.
  theForm.get(0).submit();
});
