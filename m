Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3D91CD8CB2
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:14:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 582E76B00E9; Tue,  9 Jun 2026 15:14:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 559896B00EB; Tue,  9 Jun 2026 15:14:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 470A46B00EC; Tue,  9 Jun 2026 15:14:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 307C16B00E9
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:14:40 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EA165A0737
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:14:39 +0000 (UTC)
X-FDA: 84861325878.05.B9A07C7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1C123C0002
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:14:37 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CnPtpzyI;
	spf=pass (imf28.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781032478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RUaG/t4BDKUDpP/85NUbptm2D8pKhwGgeSEJZQeUeww=;
	b=MNIiMjE/eFmeiCfkMOs5cxVG5DSl+35G166Cxs8e4yZ6h6RASss1J2CZLWzaxwSpqYYsfb
	O2mHtsrh8NrqV6IZHIDONYrIZEOM24MEA8AvQisayapH5PVGmOC9wckQ2NeFYhWXJPFDQ5
	1LKFkmmm4leMUblkQY1hqG2ktR4jiRM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CnPtpzyI;
	spf=pass (imf28.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781032478;
	b=gJcT9Atbk30LVFAEW1sqyRc5/WdvCTXR4RBzGgir85LpFWvJofmpMV87EzxTEKAb6ZGeG+
	kWuTmbX+hhVjQpVx2+zHTuaNP8sO/4yG9z3aumphW+XC/cidNALo2ey7bH7C4ryOjxzNF1
	JVh6c2Sfo2YyBAVqGRReummmKy65HKo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6691A40801;
	Tue,  9 Jun 2026 19:14:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B0831F00898;
	Tue,  9 Jun 2026 19:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781032477;
	bh=RUaG/t4BDKUDpP/85NUbptm2D8pKhwGgeSEJZQeUeww=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=CnPtpzyI6JJwiF89/OVcBwVdCgzSMStGy76LCrLcV2v+1pJCJ3u/cfYj3UmJ/txA0
	 d/F7MGakQeCukt7wcUPT+S7HGaXMpdGiGc+0Qz4Ur78myT/Uh4uTHzGocNTkRjsjnJ
	 dIv9KjhTJTv04bu6G96Dej7Reso0hHguGGB9YhLPUh/gzwMUbks5XPB+vCBLO+UyKL
	 QxeMZtK3isd8uolnozzIUuR5PbDgpdvyuxuTYWZRr8GzujIwExJwL+vJOMbYVAA6Q4
	 BKfsExARjUkMoG+roR+q74XSanjl4R10QPhHfLB5GDB9xLCqF0toNq+EDm/2A2RE67
	 bU6qNL2PmhlLg==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 09 Jun 2026 21:08:13 +0200
Subject: [PATCH v2 34/83] block: rust: add `hctx` private data support
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-rnull-v6-19-rc5-send-v2-34-82c7404542e2@kernel.org>
References: <20260609-rnull-v6-19-rc5-send-v2-0-82c7404542e2@kernel.org>
In-Reply-To: <20260609-rnull-v6-19-rc5-send-v2-0-82c7404542e2@kernel.org>
To: "Liam R. Howlett" <liam@infradead.org>, 
 Alice Ryhl <aliceryhl@google.com>, 
 Anna-Maria Behnsen <anna-maria@linutronix.de>, 
 Benno Lossin <lossin@kernel.org>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Boqun Feng <boqun@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 FUJITA Tomonori <fujita.tomonori@gmail.com>, 
 Frederic Weisbecker <frederic@kernel.org>, Gary Guo <gary@garyguo.net>, 
 Jens Axboe <axboe@kernel.dk>, John Stultz <jstultz@google.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Lyude Paul <lyude@redhat.com>, 
 Miguel Ojeda <ojeda@kernel.org>, Stephen Boyd <sboyd@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
 "Liam R. Howlett" <liam@infradead.org>, Boqun Feng <boqun@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>
Cc: Andreas Hindborg <a.hindborg@kernel.org>, linux-block@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 rust-for-linux@vger.kernel.org, Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=11924;
 i=a.hindborg@kernel.org; h=from:subject:message-id;
 bh=RnxsNBO4KO4zAfn6JI4Hivn6bXj0kWEGZsxUPnRjRL8=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqKGTT31y62ICIlg+/98VZqV/cU4EFmXJR9XD0z
 hQSjPqeT+2JAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaihk0wAKCRD6UCkIqsW9
 0JRUD/4wIz/6c4NdjCaY6LJ9sWTiesBhrg6ORxtGqQfBUZbTDLhJc+Bb9URi0WPsT+s1Dl5170Q
 LeP06P5iO9om3yjr095jzb1jWks1Y3xHEVQbQ840PUfmSWKgzjfix8V9cX3z8j806favdqneebp
 Sj4zDr2MCHBAJqpqgF42aRRWntwL/BNIqnyn4RaCEJuQh1wji1HAmKxS9rtat/QOeNkextJX+jZ
 NudJugI8vkPYDiqspVI6DIPuZaHhurfhqnZsAMx9Ann7ZLS/8dwzzyEkzltl3KjfZ/GlN8kcxuS
 +dUBkY9ZQTvocxDPk+C7w89SdC9Q1UJ4Ggw6bvjNRxLH8dboDNgXnL1Squ/5BdIlSuJEsV9O4v+
 ixqJ5I3ZBQmmNST4LI+F/FPFeeMOyDwLCmCIRwjB2YD/BrSbeQglVz0Ke0hSi9YEOG4E6fLBl9o
 XRY+xRfltKW2HhfC4g/wzInFbRvnIE5O01PdM0pjmcU3tW/S1X8g689CNtGKUCqkLNzPLWGKe5a
 GldkkBaIv/pUdPHMbf039XyDfoxEBjs/ItgSaphYMdWIlJUFS3EUWBHSBKIjjpGBEaIkC4TdnCe
 TyfUhbCEbEmmuf6qVx2XV24clbPM/7x4MGtHAiVQSWrFAAfx8n6xFii+bOeUpHVFMS0w2am5R8g
 Z4fes14xD76AyIA==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1C123C0002
X-Stat-Signature: yntgdybpddfgk3kppyw1tso74u5ss49i
X-Rspam-User: 
X-HE-Tag: 1781032477-917402
X-HE-Meta: U2FsdGVkX18kqmgvqzmbqKiJUCh8G3gDAuw5UHc2v98uckCSK5twfeJ0aHd+vWbOlRmk4mBHlEmPLZrzSAFPbcHocnzirw9vre/ul9rG1XFz2ArpWGVEgiN3cXm/7E33QtDgoamkmmgZiGPYzjvWvilVLEARWnK6DGnGTTVSsUedngrCAHEvPJ3Vs6SwVXCR66Ibdj50YEgG8P8KBcfjhx+FWk5+xedf+Yfb3K95W0mDRo+heH8iqu7qUd5qY+zdJ0DHeJMzQ2OjO98jVMQdF6Mei8AYOC5w2h6G2n8GqhHRrHh337eVkvMsHonk3uesY1LKEqaEodtmZUecU7eYTYrH8oOwN/9g7r7rcNFfQknthjvVXwmAmaZ9VJJiZadavjp7LjSSg0g1TDjsw3PHvroBXr45J+0/ziDoEnznTIWwnemNWljTXMAhckgNHg7W9/vXbJmAODLV2rm1DqFWURTwng9IZ4TjlmI1aHcwMNr0UIYozdocXuXawtreTG7pw4KA60SNBkw8RU49Jyzw1vGxpdIpZ7JOUELoPdKOZRWoHm86uTPA904KQ3iFp2aR3IxwPkFcBp2uuoMQY3+sr3bESxSYV0Io1EZueKx84CCL5w8kNMXBgukp7ftb9JtSKCkEFwuHFiBnkOInobDotITPQI7BoPJGs5S1I51ne1wt5eil2TgGPMzIJskNdTDaPKtcGYKbZByHMYILuFL1cdLaIqnh5JF3ovVV0mdDXNzZDHKu1AnZIpp+OhK1/O/2i3VjzCZ2yuKTu/Y54UnZOKBZfLlTi9LdkyDqYdHneT43PJI1vxZqt0pKy1syc6j8mub48FYzYKEnBnA+b8kivvvrrDHWoKInY4aQ59zy7rmCy8RTCTophqGpk/Ih75Mttw9hxDhjIBKYF/aaJqeQ14nX/E7fozXOtEyQymjVgevqIhrkKCkEEnHG2lZHXNBlXLlLT9n8Vs8fs4iA2we
 OdHeeKoi
 nZxMBrpUKq82Jwt46PBW0isFvCkVfaj7KxK6LUauhMvgwQDXILk6U2leFqc/ip48cZnmbm4HavrHAK/260i8hT5RMdq/2JWIl+SqcFpIAX78rnu8hezlVEhPLAimb2QJQ7VZrAog7wgaBcHmDAYXk/6tZxEGXFO7TZ0sogxWpfGbqmExGP1QmqoK+uejxXvvs7FIoefiN/r6M4w5QCkvGxkFPYoHe+xrKcrwSFcoHvIeYSZZkSFs4VxZiBzVl+AAc44+S+74kAIVlfP73eypCDzgzSWe5EdBZVTtxysl8LF3fzSL6Q2/La/fovpE78V+V4473RPYSb64WS9QdVd8/cDOnVrik88DPN2Xo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Andreas Hindborg <a.hindborg@samsung.com>

C block device drivers can attach private data to a hardware context
(`struct blk_mq_hw_ctx`). Add support for this feature for Rust block
device drivers via the `Operations::HwData` associated type.

The private data is created in the `init_hctx` callback and stored in
the `driver_data` field of `blk_mq_hw_ctx`. It is passed to `queue_rq`,
`commit_rqs`, and `poll` callbacks, and is released in `exit_hctx`.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 drivers/block/rnull/rnull.rs       |  8 +++-
 rust/kernel/block/mq.rs            | 23 +++++++++-
 rust/kernel/block/mq/operations.rs | 88 +++++++++++++++++++++++++++++++-------
 3 files changed, 100 insertions(+), 19 deletions(-)

diff --git a/drivers/block/rnull/rnull.rs b/drivers/block/rnull/rnull.rs
index ad26a4a8dbbe..0c1bc2f5ae9c 100644
--- a/drivers/block/rnull/rnull.rs
+++ b/drivers/block/rnull/rnull.rs
@@ -534,6 +534,7 @@ impl Operations for NullBlkDevice {
     type QueueData = Pin<KBox<QueueData>>;
     type RequestData = Pdu;
     type TagSetData = ();
+    type HwData = ();
 
     fn new_request_data() -> impl PinInit<Self::RequestData> {
         pin_init!(Pdu {
@@ -544,6 +545,7 @@ fn new_request_data() -> impl PinInit<Self::RequestData> {
 
     #[inline(always)]
     fn queue_rq(
+        _hw_data: (),
         queue_data: Pin<&QueueData>,
         mut rq: Owned<mq::Request<Self>>,
         _is_last: bool,
@@ -575,7 +577,11 @@ fn queue_rq(
         Ok(())
     }
 
-    fn commit_rqs(_queue_data: Pin<&QueueData>) {}
+    fn commit_rqs(_hw_data: (), _queue_data: Pin<&QueueData>) {}
+
+    fn init_hctx(_tagset_data: (), _hctx_idx: u32) -> Result {
+        Ok(())
+    }
 
     fn complete(rq: ARef<mq::Request<Self>>) {
         Self::end_request(
diff --git a/rust/kernel/block/mq.rs b/rust/kernel/block/mq.rs
index 28cee0d60846..b095cc7f51ce 100644
--- a/rust/kernel/block/mq.rs
+++ b/rust/kernel/block/mq.rs
@@ -17,6 +17,12 @@
 //! - The [`GenDisk`] type that abstracts the C type `struct gendisk`.
 //! - The [`Request`] type that abstracts the C type `struct request`.
 //!
+//! Many of the C types that this module abstracts allow a driver to carry
+//! private data, either embedded in the struct directly, or as a C `void*`. In
+//! these abstractions, this data is typed. The types of the data is defined by
+//! associated types in `Operations`, see [`Operations::RequestData`] for an
+//! example.
+//!
 //! The kernel will interface with the block device driver by calling the method
 //! implementations of the `Operations` trait.
 //!
@@ -71,6 +77,7 @@
 //! impl Operations for MyBlkDevice {
 //!     type RequestData = ();
 //!     type QueueData = ();
+//!     type HwData = ();
 //!     type TagSetData = ();
 //!
 //!     fn new_request_data(
@@ -78,12 +85,17 @@
 //!         Ok(())
 //!     }
 //!
-//!     fn queue_rq(_queue_data: (), rq: Owned<Request<Self>>, _is_last: bool) -> Result {
+//!     fn queue_rq(
+//!         _hw_data: (),
+//!         _queue_data: (),
+//!         rq: Owned<Request<Self>>,
+//!         _is_last: bool
+//!     ) -> Result {
 //!         rq.end_ok();
 //!         Ok(())
 //!     }
 //!
-//!     fn commit_rqs(_queue_data: ()) {}
+//!     fn commit_rqs(_hw_data: (), _queue_data: ()) {}
 //!
 //!     fn complete(rq: ARef<Request<Self>>) {
 //!         OwnableRefCounted::try_from_shared(rq)
@@ -91,6 +103,13 @@
 //!             .expect("Fatal error - expected to be able to end request")
 //!             .end_ok();
 //!     }
+//!
+//!     fn init_hctx(
+//!         _tagset_data: (),
+//!         _hctx_idx: u32,
+//!     ) -> Result<Self::HwData> {
+//!         Ok(())
+//!     }
 //! }
 //!
 //! let tagset: Arc<TagSet<MyBlkDevice>> =
diff --git a/rust/kernel/block/mq/operations.rs b/rust/kernel/block/mq/operations.rs
index 093bb21fa1b2..1b20df25d6df 100644
--- a/rust/kernel/block/mq/operations.rs
+++ b/rust/kernel/block/mq/operations.rs
@@ -63,6 +63,13 @@ pub trait Operations: Sized {
     /// the `GenDisk` associated with this `Operations` implementation.
     type QueueData: ForeignOwnable + Sync;
 
+    /// Data associated with a dispatch queue. This is stored as a pointer in the C `struct
+    /// blk_mq_hw_ctx` that represents a hardware queue.
+    ///
+    /// Hardware contexts may be cleaned up by a thread different from the allocating thread, so
+    /// `HwData` must be `Send`.
+    type HwData: ForeignOwnable + Sync + Send;
+
     /// Data associated with a `TagSet`. This is stored as a pointer in `struct
     /// blk_mq_tag_set`.
     type TagSetData: ForeignOwnable + Sync;
@@ -73,20 +80,30 @@ pub trait Operations: Sized {
     /// Called by the kernel to queue a request with the driver. If `is_last` is
     /// `false`, the driver is allowed to defer committing the request.
     fn queue_rq(
+        hw_data: ForeignBorrowed<'_, Self::HwData>,
         queue_data: ForeignBorrowed<'_, Self::QueueData>,
         rq: Owned<Request<Self>>,
         is_last: bool,
     ) -> Result;
 
     /// Called by the kernel to indicate that queued requests should be submitted.
-    fn commit_rqs(queue_data: ForeignBorrowed<'_, Self::QueueData>);
+    fn commit_rqs(
+        hw_data: ForeignBorrowed<'_, Self::HwData>,
+        queue_data: ForeignBorrowed<'_, Self::QueueData>,
+    );
+
+    /// Called by the kernel to allocate and initialize a driver specific hardware context data.
+    fn init_hctx(
+        tagset_data: ForeignBorrowed<'_, Self::TagSetData>,
+        hctx_idx: u32,
+    ) -> Result<Self::HwData>;
 
     /// Called by the kernel when the request is completed.
     fn complete(rq: ARef<Request<Self>>);
 
     /// Called by the kernel to poll the device for completed requests. Only
     /// used for poll queues.
-    fn poll() -> bool {
+    fn poll(_hw_data: ForeignBorrowed<'_, Self::HwData>) -> bool {
         build_error!(crate::error::VTABLE_DEFAULT_ERROR)
     }
 }
@@ -146,6 +163,11 @@ impl<T: Operations> OperationsVTable<T> {
         let mut rq =
             unsafe { Owned::from_raw(NonNull::<Request<T>>::new_unchecked((*bd).rq.cast())) };
 
+        // SAFETY: The safety requirement for this function ensure that `hctx`
+        // is valid and that `driver_data` was produced by a call to
+        // `into_foreign` in `Self::init_hctx_callback`.
+        let hw_data = unsafe { T::HwData::borrow((*hctx).driver_data) };
+
         // SAFETY: `hctx` is valid as required by this function.
         let queue_data = unsafe { (*(*hctx).queue).queuedata };
 
@@ -159,6 +181,7 @@ impl<T: Operations> OperationsVTable<T> {
         unsafe { rq.start_unchecked() };
 
         let ret = T::queue_rq(
+            hw_data,
             queue_data,
             rq,
             // SAFETY: `bd` is valid as required by the safety requirement for
@@ -181,6 +204,10 @@ impl<T: Operations> OperationsVTable<T> {
     /// This function may only be called by blk-mq C infrastructure. The caller
     /// must ensure that `hctx` is valid.
     unsafe extern "C" fn commit_rqs_callback(hctx: *mut bindings::blk_mq_hw_ctx) {
+        // SAFETY: `driver_data` was installed by us in `init_hctx_callback` as
+        // the result of a call to `into_foreign`.
+        let hw_data = unsafe { T::HwData::borrow((*hctx).driver_data) };
+
         // SAFETY: `hctx` is valid as required by this function.
         let queue_data = unsafe { (*(*hctx).queue).queuedata };
 
@@ -189,7 +216,7 @@ impl<T: Operations> OperationsVTable<T> {
         // `ForeignOwnable::from_foreign()` is only called when the tagset is
         // dropped, which happens after we are dropped.
         let queue_data = unsafe { T::QueueData::borrow(queue_data) };
-        T::commit_rqs(queue_data)
+        T::commit_rqs(hw_data, queue_data)
     }
 
     /// This function is called by the C kernel. A pointer to this function is
@@ -213,12 +240,18 @@ impl<T: Operations> OperationsVTable<T> {
     ///
     /// # Safety
     ///
-    /// This function may only be called by blk-mq C infrastructure.
+    /// This function may only be called by blk-mq C infrastructure. `hctx` must
+    /// be a pointer to a valid and aligned `struct blk_mq_hw_ctx` that was
+    /// previously initialized by a call to `init_hctx_callback`.
     unsafe extern "C" fn poll_callback(
-        _hctx: *mut bindings::blk_mq_hw_ctx,
+        hctx: *mut bindings::blk_mq_hw_ctx,
         _iob: *mut bindings::io_comp_batch,
     ) -> crate::ffi::c_int {
-        T::poll().into()
+        // SAFETY: By function safety requirement, `hctx` was initialized by
+        // `init_hctx_callback` and thus `driver_data` came from a call to
+        // `into_foreign`.
+        let hw_data = unsafe { T::HwData::borrow((*hctx).driver_data) };
+        T::poll(hw_data).into()
     }
 
     /// This function is called by the C kernel. A pointer to this function is
@@ -226,15 +259,29 @@ impl<T: Operations> OperationsVTable<T> {
     ///
     /// # Safety
     ///
-    /// This function may only be called by blk-mq C infrastructure. This
-    /// function may only be called once before `exit_hctx_callback` is called
-    /// for the same context.
+    /// This function may only be called by blk-mq C infrastructure.
+    /// `tagset_data` must be initialized by the initializer returned by
+    /// `TagSet::try_new` as part of tag set initialization. `hctx` must be a
+    /// pointer to a valid `blk_mq_hw_ctx` where the `driver_data` field was not
+    /// yet initialized. This function may only be called once before
+    /// `exit_hctx_callback` is called for the same context.
     unsafe extern "C" fn init_hctx_callback(
-        _hctx: *mut bindings::blk_mq_hw_ctx,
-        _tagset_data: *mut crate::ffi::c_void,
-        _hctx_idx: crate::ffi::c_uint,
-    ) -> crate::ffi::c_int {
-        from_result(|| Ok(0))
+        hctx: *mut bindings::blk_mq_hw_ctx,
+        tagset_data: *mut c_void,
+        hctx_idx: c_uint,
+    ) -> c_int {
+        from_result(|| {
+            // SAFETY: By the safety requirements of this function,
+            // `tagset_data` came from a call to `into_foreign` when the
+            // `TagSet` was initialized.
+            let tagset_data = unsafe { T::TagSetData::borrow(tagset_data) };
+            let data = T::init_hctx(tagset_data, hctx_idx)?;
+
+            // SAFETY: by the safety requirements of this function, `hctx` is
+            // valid for write
+            unsafe { (*hctx).driver_data = data.into_foreign().cast() };
+            Ok(0)
+        })
     }
 
     /// This function is called by the C kernel. A pointer to this function is
@@ -242,11 +289,20 @@ impl<T: Operations> OperationsVTable<T> {
     ///
     /// # Safety
     ///
-    /// This function may only be called by blk-mq C infrastructure.
+    /// This function may only be called by blk-mq C infrastructure. `hctx` must
+    /// be a valid pointer that was previously initialized by a call to
+    /// `init_hctx_callback`. This function may be called only once after
+    /// `init_hctx_callback` was called.
     unsafe extern "C" fn exit_hctx_callback(
-        _hctx: *mut bindings::blk_mq_hw_ctx,
+        hctx: *mut bindings::blk_mq_hw_ctx,
         _hctx_idx: crate::ffi::c_uint,
     ) {
+        // SAFETY: By the safety requirements of this function, `hctx` is valid for read.
+        let ptr = unsafe { (*hctx).driver_data };
+
+        // SAFETY: By the safety requirements of this function, `ptr` came from
+        // a call to `into_foreign` in `init_hctx_callback`
+        unsafe { T::HwData::from_foreign(ptr) };
     }
 
     /// This function is called by the C kernel. A pointer to this function is

-- 
2.51.2



