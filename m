Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DCA4E63F2E
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 04:14:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3C9A6B00EC; Sun, 15 Feb 2026 18:55:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEC4B6B0113; Sun, 15 Feb 2026 18:55:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC5286B0115; Sun, 15 Feb 2026 18:55:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 79E906B0113
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 18:55:38 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 77A54140B6D
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:45:08 +0000 (UTC)
X-FDA: 84448324296.04.D05CC8F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id BC1CE140006
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:45:06 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fu0XHhmJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771199106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MkFRx0Zrmp5dLwNj5lU/Wb7OamRWHTSL45130yn4TlU=;
	b=Yh9VC/p8mi7uFD2TmpJbmqSfwOvUMd0Wm5tuZajdwobFdWVCUwHUrs9FL/5zbWuOUgVLP2
	lhKoczGSwzpEUSYANgMHu2Hso1cOPBQxOKCC1PjF8QfCXg6Q42KffV36Sq1uUnIPmJnai4
	vINgbe8EX8G25ReLOkT1nMESwlElKQM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771199106; a=rsa-sha256;
	cv=none;
	b=2XKuwvNduTehc7SH0xk4w8lA6zZmk4iGkXfwlYxHWFqj2uBuFjn1HeaV6pMADp3tk/wvA7
	VGpUBJ90fDGJNhGHNsn9SfpROAXVVV0RFy55Yi/ltea4tdHseUgBjLBVVIv1c5wp72Jhwc
	GdK2x5JxjYLbzJ9OpUIB/eBxpgcz6qk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fu0XHhmJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 455B86013E;
	Sun, 15 Feb 2026 23:45:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF990C4CEF7;
	Sun, 15 Feb 2026 23:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771199106;
	bh=nKDJESXMMdAbXJmbQH/TDKLxr1LGgof53q+XTMeqr04=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=fu0XHhmJy1gX/cIRnvFxxJ+Y6oO6mmRvqlrUbBDEAj7/MDVFRt8wHqVsDplzrIE5T
	 5EOS9gGCApRYbQcciwZ07npml4Uvrks09ds2DcHMJ1tcvhe4fNjl6tcbYAWqWtUl76
	 KnoZ76AcPMBYHrXAnJPaTJf9TmwRH0MdLxin18ihIcwxPV6Pcv5IYBq78fTPOTX3QR
	 aloupiIdvfV5i1HQMGoQkNwR4OLzgwkaab1uWkDyTn6wtKtil5GQg+U3YmXLcAlmZc
	 Jb/apVlrYiUjpbWdaOHC4gwTXpZtwM3V0S+fD1WZO/cQ2nNhTcNDvFbYb6OCfQ03LS
	 x2WLZhUmvGAhQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 16 Feb 2026 00:34:53 +0100
Subject: [PATCH 06/79] block: rust: add `Request` private data support
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-rnull-v6-19-rc5-send-v1-6-de9a7af4b469@kernel.org>
References: <20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org>
In-Reply-To: <20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org>
To: Boqun Feng <boqun.feng@gmail.com>, Jens Axboe <axboe@kernel.dk>, 
 Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
 FUJITA Tomonori <fujita.tomonori@gmail.com>, 
 Frederic Weisbecker <frederic@kernel.org>, Lyude Paul <lyude@redhat.com>, 
 Thomas Gleixner <tglx@kernel.org>, 
 Anna-Maria Behnsen <anna-maria@linutronix.de>, 
 John Stultz <jstultz@google.com>, Stephen Boyd <sboyd@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: linux-block@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=8672; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=nKDJESXMMdAbXJmbQH/TDKLxr1LGgof53q+XTMeqr04=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpklghxER7z4eSTdEgWu7X/lQaa701iP5OWF88X
 2vR1dp8TKmJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZJYIQAKCRDhuBo+eShj
 d5E4D/0WP5q39O/TWBj0zA73T1cdUnagb39/g6S+WLyQMwhG/g/V+RteReTcHJduUiBc1vZIWc+
 liak4eD/kewjxEn34O7jS0CPyMcS532TA4dhaGsMjw6ClQDzI/iqw6HMi/JZOEq3Dbkx7xk8htA
 sKWAUpXf3+xxGuF9t/Nc/OxHivpjIsArUeX5fz5anIMuwKMNQtWx3hCFMbXUDxr/VuJ8f5iqKBb
 ZdSonYSCcXir9fXGDpPV54nM18ZZja6RsoZTuNVKzbJO7YVzWIfFyMM38/Gr1XExlzehFsp33lU
 Lj97Q01XDL2fxwgY7ru1gJ3R+f+hmrBNdLQOQKECNVx/4UbBGt69bfO1BKXk82zHionAFBJXZnN
 0wCOIVvqO2ecr3ZjQxKACU2XahihjhlnMyOa2u3NM7T72+D2fpV6PwB8awhuKMIC7oXyjsPMLBm
 xYfaURbuvtahZg9e2jLbtkf/bvg7hiYdYB4InVbQ2SrUyJYUu1rI2jc/Zzfohdoi/+QHFc+01Kp
 w1KhO+jQDsqeaf7qKbSybYPtkmK7BmGdnjK2xB5LtkyJHL+IXkZ7hTY8DCgvUp6Dnr6DsTZPBmp
 ETjeKMMkQ0b+BhUbxUZ7JBnWGuVOJl1pyKmN5HBFFl7FrmMbOP17swDr2zZ4tkL2aaalrIDXXMt
 J36cFJ6YWjJ1Ahw==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Queue-Id: BC1CE140006
X-Stat-Signature: 9jwp7f1f1dgq7p4ajate8apqzee97uwh
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1771199106-953954
X-HE-Meta: U2FsdGVkX1+x2PIwgaJ6/fx2zwfp4fjHgmMfcUjl9qvQWLMEvRcl4UZOLe5JJq6ljDG3Pe4NOBkVv9ZWqfaVoDQkXHU6aLchlxuh0HutJs9sHmGXD3YMuS78Smyj21kTFTtKrgb7/hQXo/9iykY3q05FLMUIH+cmGg/vgHPGhIOMFLjxaGqW1BQKMSuA9FL6Gm/jVX+9lfO+UGS+0ketTyULdt1x8TQawZNpHgGzupLfpOBs4I2Qh6y6FqsS+gmhiVQaS4atxaQ6zHpX56Kalv1rqx2X07G9DFI9CwoaokAFqCF7IAajrOF+VBF3qwxJUBAgOtYlFUM7pC4NdM1+gtdN/lFRnzSZB3UffvkbxWWmDsEZ1TdXwod9CFz7lNxeN6OcXJWWx1Kjx0G37OB+jRV81sQyW5Rsw2YlXBHWNpxRuN8HQLQSIkBaEzsqypaAYDcBXTsdcn1b1l2U+jt2RhSqHeekHm19JOauN9CYshZUTdRtjVqhy9PJMZhWxuFrRZ+It/TCk3Zda79FQR2eyXgGEACiLJR4cGFvmcrEdjVdPWh52vILkHPPCrgwijywZUY0InbrTNgqb8z1MCVMXADW0Pvje7Wj95/sxPKCGFJZI3ppsmEH4g0Q0VfV5+qyvM8GFsc1wQzwTp5Z9fH+VP7FlVfoh0Z8T99N3q3i9UW4H/yGB8J9F1U18o628I9p+Onqe/+1R6C8WEeEOFwmAqsbDnCwloIuJvAIFkjBEQnoC6Oiq96KdOc4hZ/oAVACQrKbb3b6LsZ25U+1kkLA+EuSyeOAeTrYHcNiR3JuyJoju92JBi/O60bW8PDFXZ7epghAcFcTwekdUJPb5gyILgBXHlTldKL1IiKpSjYtpGRbsNyQRs+p9jB4RZAZ2OnaCgBacuUNt7fb5DKm9nAg/sLW/6XOKcb24QFZ7vN0NehDzYBVnRkQND2Bt+gInds1jGseUNUmd3ckvCXf1GJ
 rqW9mUAm
 3ULeoICh54yYtYAFq+W82FeFbllj+HhadcmQWKOS7b02vW3EJ5aTIOVzDxl4S6SS6uE4FZUGgoyNJn3yiq/tEVG97woyVJXNHoELBltatkKH2WONQ00GAvCfmaMxaae7wGbllpgzE4Qvl3Yb9FEe3Oi8vW/9+p0x0BoDOdwJGx0DnE6gHd6UMvSKY9H27KaT8loolW6xYCH+vXu+LmKyN2cPnjHpnyjgZh8k5YrfYrEt3ad5pEO7KH8risHFSjYJmLLStFNsDHSPaCv/sBy6QH3Qt6T6wcK8tSlYqDtMGCsQ51GPm4BOR2txofs83WtiEk5c0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

C block device drivers can attach private data to a `struct request`. This
data is stored next to the request structure and is part of the request
allocation set up during driver initialization.

Expose this private request data area to Rust block device drivers.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 drivers/block/rnull/rnull.rs       |  5 +++++
 rust/kernel/block/mq.rs            |  6 ++++++
 rust/kernel/block/mq/operations.rs | 24 +++++++++++++++++++++++-
 rust/kernel/block/mq/request.rs    | 24 +++++++++++++++++++-----
 rust/kernel/block/mq/tag_set.rs    |  2 +-
 5 files changed, 54 insertions(+), 7 deletions(-)

diff --git a/drivers/block/rnull/rnull.rs b/drivers/block/rnull/rnull.rs
index 6a7f660d31998..065639fc4f941 100644
--- a/drivers/block/rnull/rnull.rs
+++ b/drivers/block/rnull/rnull.rs
@@ -134,6 +134,11 @@ struct QueueData {
 #[vtable]
 impl Operations for NullBlkDevice {
     type QueueData = KBox<QueueData>;
+    type RequestData = ();
+
+    fn new_request_data() -> impl PinInit<Self::RequestData> {
+        pin_init::zeroed::<Self::RequestData>()
+    }
 
     #[inline(always)]
     fn queue_rq(queue_data: &QueueData, rq: Owned<mq::Request<Self>>, _is_last: bool) -> Result {
diff --git a/rust/kernel/block/mq.rs b/rust/kernel/block/mq.rs
index b8ecd69abe980..a285b753ada88 100644
--- a/rust/kernel/block/mq.rs
+++ b/rust/kernel/block/mq.rs
@@ -69,8 +69,14 @@
 //!
 //! #[vtable]
 //! impl Operations for MyBlkDevice {
+//!     type RequestData = ();
 //!     type QueueData = ();
 //!
+//!     fn new_request_data(
+//!     ) -> impl PinInit<()> {
+//!         pin_init::zeroed::<()>()
+//!     }
+//!
 //!     fn queue_rq(_queue_data: (), rq: Owned<Request<Self>>, _is_last: bool) -> Result {
 //!         rq.end_ok();
 //!         Ok(())
diff --git a/rust/kernel/block/mq/operations.rs b/rust/kernel/block/mq/operations.rs
index 3dea79d647ff7..cd37b939bbf30 100644
--- a/rust/kernel/block/mq/operations.rs
+++ b/rust/kernel/block/mq/operations.rs
@@ -13,6 +13,7 @@
     types::{ForeignOwnable, Owned},
 };
 use core::{marker::PhantomData, ptr::NonNull};
+use pin_init::PinInit;
 
 type ForeignBorrowed<'a, T> = <T as ForeignOwnable>::Borrowed<'a>;
 
@@ -28,10 +29,24 @@
 /// [module level documentation]: kernel::block::mq
 #[macros::vtable]
 pub trait Operations: Sized {
+    /// Data associated with a request. This data is located next to the request
+    /// structure.
+    ///
+    /// To be able to handle accessing this data from interrupt context, this
+    /// data must be `Sync`.
+    ///
+    /// The `RequestData` object is initialized when the requests are allocated
+    /// during queue initialization, and it is are dropped when the requests are
+    /// dropped during queue teardown.
+    type RequestData: Sized + Sync;
+
     /// Data associated with the `struct request_queue` that is allocated for
     /// the `GenDisk` associated with this `Operations` implementation.
     type QueueData: ForeignOwnable;
 
+    /// Called by the kernel to get an initializer for a `Pin<&mut RequestData>`.
+    fn new_request_data() -> impl PinInit<Self::RequestData>;
+
     /// Called by the kernel to queue a request with the driver. If `is_last` is
     /// `false`, the driver is allowed to defer committing the request.
     fn queue_rq(
@@ -236,6 +251,13 @@ impl<T: Operations> OperationsVTable<T> {
             // it is valid for writes.
             unsafe { RequestDataWrapper::refcount_ptr(pdu.as_ptr()).write(Refcount::new(0)) };
 
+            let initializer = T::new_request_data();
+
+            // SAFETY: `pdu` is a valid pointer as established above. We do not
+            // touch `pdu` if `__pinned_init` returns an error. We promise ot to
+            // move the pointee of `pdu`.
+            unsafe { initializer.__pinned_init(RequestDataWrapper::data_ptr(pdu.as_ptr()))? };
+
             Ok(0)
         })
     }
@@ -255,7 +277,7 @@ impl<T: Operations> OperationsVTable<T> {
     ) {
         // SAFETY: The tagset invariants guarantee that all requests are allocated with extra memory
         // for the request data.
-        let pdu = unsafe { bindings::blk_mq_rq_to_pdu(rq) }.cast::<RequestDataWrapper>();
+        let pdu = unsafe { bindings::blk_mq_rq_to_pdu(rq) }.cast::<RequestDataWrapper<T>>();
 
         // SAFETY: `pdu` is valid for read and write and is properly initialised.
         unsafe { core::ptr::drop_in_place(pdu) };
diff --git a/rust/kernel/block/mq/request.rs b/rust/kernel/block/mq/request.rs
index 148348b4ef245..8a6c29ac627ee 100644
--- a/rust/kernel/block/mq/request.rs
+++ b/rust/kernel/block/mq/request.rs
@@ -96,12 +96,12 @@ pub fn complete(this: ARef<Self>) {
     ///
     /// - `this` must point to a valid allocation of size at least size of
     ///   [`Self`] plus size of [`RequestDataWrapper`].
-    pub(crate) unsafe fn wrapper_ptr(this: *mut Self) -> NonNull<RequestDataWrapper> {
+    pub(crate) unsafe fn wrapper_ptr(this: *mut Self) -> NonNull<RequestDataWrapper<T>> {
         let request_ptr = this.cast::<bindings::request>();
         // SAFETY: By safety requirements for this function, `this` is a
         // valid allocation.
         let wrapper_ptr =
-            unsafe { bindings::blk_mq_rq_to_pdu(request_ptr).cast::<RequestDataWrapper>() };
+            unsafe { bindings::blk_mq_rq_to_pdu(request_ptr).cast::<RequestDataWrapper<T>>() };
         // SAFETY: By C API contract, `wrapper_ptr` points to a valid allocation
         // and is not null.
         unsafe { NonNull::new_unchecked(wrapper_ptr) }
@@ -109,7 +109,7 @@ pub(crate) unsafe fn wrapper_ptr(this: *mut Self) -> NonNull<RequestDataWrapper>
 
     /// Return a reference to the [`RequestDataWrapper`] stored in the private
     /// area of the request structure.
-    pub(crate) fn wrapper_ref(&self) -> &RequestDataWrapper {
+    pub(crate) fn wrapper_ref(&self) -> &RequestDataWrapper<T> {
         // SAFETY: By type invariant, `self.0` is a valid allocation. Further,
         // the private data associated with this request is initialized and
         // valid. The existence of `&self` guarantees that the private data is
@@ -121,16 +121,19 @@ pub(crate) fn wrapper_ref(&self) -> &RequestDataWrapper {
 /// A wrapper around data stored in the private area of the C [`struct request`].
 ///
 /// [`struct request`]: srctree/include/linux/blk-mq.h
-pub(crate) struct RequestDataWrapper {
+pub(crate) struct RequestDataWrapper<T: Operations> {
     /// The Rust request refcount has the following states:
     ///
     /// - 0: The request is owned by C block layer.
     /// - 1: The request is owned by Rust abstractions but there are no [`ARef`] references to it.
     /// - 2+: There are [`ARef`] references to the request.
     refcount: Refcount,
+
+    /// Driver managed request data
+    data: T::RequestData,
 }
 
-impl RequestDataWrapper {
+impl<T: Operations> RequestDataWrapper<T> {
     /// Return a reference to the refcount of the request that is embedding
     /// `self`.
     pub(crate) fn refcount(&self) -> &Refcount {
@@ -148,6 +151,17 @@ pub(crate) unsafe fn refcount_ptr(this: *mut Self) -> *mut Refcount {
         // field projection is safe.
         unsafe { &raw mut (*this).refcount }
     }
+
+    /// Return a pointer to the `data` field of the `Self` pointed to by `this`.
+    ///
+    /// # Safety
+    ///
+    /// - `this` must point to a live allocation of at least the size of `Self`.
+    pub(crate) unsafe fn data_ptr(this: *mut Self) -> *mut T::RequestData {
+        // SAFETY: Because of the safety requirements of this function, the
+        // field projection is safe.
+        unsafe { &raw mut (*this).data }
+    }
 }
 
 // SAFETY: Exclusive access is thread-safe for `Request`. `Request` has no `&mut
diff --git a/rust/kernel/block/mq/tag_set.rs b/rust/kernel/block/mq/tag_set.rs
index c3cf56d52beec..46481754b1335 100644
--- a/rust/kernel/block/mq/tag_set.rs
+++ b/rust/kernel/block/mq/tag_set.rs
@@ -41,7 +41,7 @@ pub fn new(
         // SAFETY: `blk_mq_tag_set` only contains integers and pointers, which
         // all are allowed to be 0.
         let tag_set: bindings::blk_mq_tag_set = unsafe { core::mem::zeroed() };
-        let tag_set: Result<_> = core::mem::size_of::<RequestDataWrapper>()
+        let tag_set: Result<_> = core::mem::size_of::<RequestDataWrapper<T>>()
             .try_into()
             .map(|cmd_size| {
                 bindings::blk_mq_tag_set {

-- 
2.51.2



