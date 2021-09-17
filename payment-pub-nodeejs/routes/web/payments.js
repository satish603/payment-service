
var express = require('express');
var router = express.Router();
const Razorpay = require('razorpay')
const PaymentDetail =  require('../../models/payment-detail')
const { nanoid } = require("nanoid");


let razorPayInstance = new Razorpay({
	key_id: "//YOur Razorpay key",
	key_secret: "//Your razorpay secretkey"
})


router.get('/', function(req, res, next) {

	res.render('pages/payment/order', { 
		title: 'Pay now'
	});
});


router.post('/order', function(req, res, next) {
	params = {
		amount: req.body.amount * 100,
		currency: "INR",
		receipt: nanoid(),
		payment_capture: "1"
	}
	razorPayInstance.orders.create(params)
	.then(async (response) => {
		// Save orderId and other payment details
		const paymentDetail = new PaymentDetail({
			orderId: response.id,
			receiptId: response.receipt,
			amount: response.amount,
			currency: response.currency,
			createdAt: response.created_at,
			status: response.status
		})
		try {
			await paymentDetail.save()
			res.render('pages/payment/checkout', {
				title: "Confirm Order",
				paymentDetail : paymentDetail
			})
		} catch (err) {
			// Throw err if failed to save
			if (err) throw err;
		}
	}).catch((err) => {
		// Throw err if failed to create order
		if (err) throw err;
	})
});


router.post('/verify', async function(req, res, next) {
	body=req.body.razorpay_order_id + "|" + req.body.razorpay_payment_id;
	let crypto = require("crypto");
	let expectedSignature = crypto.createHmac('sha256', "//Your razorpay secret-key")
							.update(body.toString())
							.digest('hex');

	// Compare the signatures
	if(expectedSignature === req.body.razorpay_signature) {
		// if same, then find the previosuly stored record using orderId,
		// and update paymentId and signature, and set status to paid.
		await PaymentDetail.findOneAndUpdate(
			{ orderId: req.body.razorpay_order_id },
			{
				paymentId: req.body.razorpay_payment_id,
				signature: req.body.razorpay_signature,
				status: "paid"
			},
			{ new: true },
			function(err, doc) {
				// Throw er if failed to save
				if(err){
					throw err
				}
				// Render payment success page, if saved succeffully
				res.render('pages/payment/success', {
					title: "Payment verification successful",
					paymentDetail: doc
				})
			}
		);
	} else {
		res.render('pages/payment/fail', {
			title: "Payment verification failed",
		})
	}
});

module.exports = router;