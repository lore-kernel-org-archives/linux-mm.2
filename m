Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95E3AE63F1C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 01:37:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91F736B00C7; Sun, 15 Feb 2026 18:44:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D7E16B00CD; Sun, 15 Feb 2026 18:44:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F5F86B00CE; Sun, 15 Feb 2026 18:44:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5D2966B00C7
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 18:44:46 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0DC8DBCAC5
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:44:24 +0000 (UTC)
X-FDA: 84448322448.03.E85C453
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 55AB940003
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:44:22 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FljKbIJu;
	spf=pass (imf17.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771199062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L8tRBGD30rOu/sG5ePVxIfJ8uQ2qSQaC7iY0qYLIl0M=;
	b=DAnw/YS7bNvZW3e5UUm2+0RiBMABlX1cqMLY1IBkbo5MgOvCCsGvKk/8o5HCx3qkQyaHR6
	HT4AdtskbyBadd+RyLiRM3VVKcWXgaUnyD29CHXeQWGgVWDSzKqFfNrSnV6eYIoX2qoZa0
	vi2+IdSbaFYgUVPvzrWWKYoSVUkjhns=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FljKbIJu;
	spf=pass (imf17.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771199062; a=rsa-sha256;
	cv=none;
	b=MoJs9/NlbUCsLcw9NW44CdVc+Sj7e29l8VfjPZd2J5Q5jIARVw0202ajj5MJtGoo3lEjt9
	RrIeVPIWZcRFhs0EW3lJcIRXedxL6KJRhonm3rvuIPJhf26hN+LrfahGXTbOiQ99InnAFV
	ZEpum0O5Z2aQ2bkzMZuulu1bXEph1ps=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D4AE16013E;
	Sun, 15 Feb 2026 23:44:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40614C4CEF7;
	Sun, 15 Feb 2026 23:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771199061;
	bh=kxfk0NxivP7xMNYmKs13HrD3bNE4wuOWBn6+zseKLgk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=FljKbIJuZZV66echQHbgF+iOvpuxT26U4pYgG5yJje98VOFVcvJuhy02vW5XcPTVA
	 bxYXKtNYmHU32oYNfnDOb2EbvpaNaYB5599R+2Jnhfiu16c0NlSkEYER/ncbTcT2B8
	 fSCYG4AQY4BSXZ0pI9TQzqd7P8SwHOBzkyRw4oXcWDJf3g+g8AX+seX8T9GxtPyZ8I
	 GQTNEXG/zPo90Q9PhF/jSEQyzD4ZQv47uPvGWog8R22euuESIr3z6iOuSWK/Kn5enU
	 u0i12EoV6H1O1hWYHXBioxGfVfKA1YZh2JxUMIkkkdiWn2qSTdN2TaogEfxqJKe1oO
	 KOppbs4tPn9+Q==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 16 Feb 2026 00:35:52 +0100
Subject: [PATCH 65/79] block: rust: add `queue_rqs` vtable hook
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-rnull-v6-19-rc5-send-v1-65-de9a7af4b469@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5925; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=kxfk0NxivP7xMNYmKs13HrD3bNE4wuOWBn6+zseKLgk=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpklhWkfykeGrJtn+Xnt679z12Wv0nstxNgY43F
 EyZrVwsMdaJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZJYVgAKCRDhuBo+eShj
 dxR9D/0b80WZwQzfSaWye9AkT8IHEguI8Qx2vaI9c49aW3ONnRUoCG99C7oEbKQC1dE0BU87+o2
 05pBhsiaG0aSEKewssne26p6QXeZkluBdkjIOZqUb0Ul+gaWrY74tiSv+jdv3hO3nWzcvZhISdV
 i3CaMJDevyGKBbjJNJxJOyHQasm5ftuNatcq1B04oFLV6RSbyeMRkUaqQIlcqOCArM0CPRhCpnK
 BDgRy8EekJyo+YmhBMT+9S0wIojLfRXKn7O3+2VHXK46if+TUT1w+oQhXMf9XvC9GiHujgEecBZ
 85tLpgJ+aJS5e1cbOS6XTpmjXRIoJ5XnKWIpN7SlhaeghSqt9CM3cU1EL2RG3x4ZIQ6XXbtAML+
 Gvj5fj/c57My8iy4WkMlhV07XgrnpYKLHK1QJ+iMW0QgzV8yyUf+rIQb7//5G0yjLDh9AznYqn2
 Vux4Ysb8OK0gYe/7TIDRZt8KxoL0cts/hsCN7nJh+MVwIPnniT6+Uvhdb7i4h+ut2te9w/K+pYA
 SGqW7821xeTiYqtrc+zsI8zOtiHfG9N93Z3i3TtbdFCOcSJFReUy3nAUl0VzlieSejw3RKDCJb/
 PH0ZLgEh4U0jm8RJhhkmycDkZ13VuCv9zvKlz1g/4fvfzTZF1IxeP7IFcOGmsD62fMV7l9hJKfs
 iFCzlr4gnyB3iKg==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Stat-Signature: ikxhsocad9j1g3us415r3h5tyua1myhs
X-Rspamd-Queue-Id: 55AB940003
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771199062-423043
X-HE-Meta: U2FsdGVkX19Dh3tU/SWVhxoz41/u+8WWrBVsb62aCJMZj2iHz4IIktciw97TzK2dWjh/7zmDcb2gkuLMO3PxGO11r1KUPo9C2hTopAC4gEY9kZ6M8ndjjXIEjr9u92lynDhlHh9MJr4HCZg/Ck0WBQPp/CB6Ivo0jRjSf+zU6AX8n86s6GM7F/ILAdlo/mMd3M7f7QaQrtIpD8uWbEEYOXF5VVdn4YVDTaCS71Vq5EszjF1I5pS04ax7XWwwviPjZqMW/u3uwuR6/r+CKF07BEOHb5PZI/SQuNL1jFFtWWWUf3ifMmHjZVoXbPV6kk/xNnuKDUEcbLeWES5XVBYQ8HR8C0GFU4EFvjEDoKvA3IBSsZnLiwuSgPCsSGdr+eOUx4HQYSgbLVz6GMIhUVBY23faDulTNe5tod3fF3rIJwTxAfHH2xA3yRW83Zr61FDZRn6466iTiK8WDRowket/sM6mmt+2svu3Y9bJT3+OeLAEQuWNNdBxPfGNjzfhlYzQBQFKwjFUqqnMkB3PJR99dpAZoS0nCKlaVgqunfY2rWc462FY+bzZCvTfd+YpWd3WO0p+W9xxsrE1DFPFBdheCcvYjwGE0UnTyoVmmI1aW+lS2YJadkJRCaG7Zt3AQBXp1cOSHQV4DNMtW2iQ/E82cdusJqOee7FbGgsl25eoMQjWbaLZ8fdf9muFCuZqdWuDVVmE6yRxa5mknRldLTyDCe8SSkUn98YcQcdzDbCGITsHBHTjV8F+BeOFPLgNl67Xhjq6XNr03KvgeUy4sDeBv6TCvW4UtxspYHwbR+eAhYMqOKAvBB6J14mWdJQOpXPTvWfaIkw3LQSgGYFGLQcrlc9xbGlfrMllNRKEfkOHRqUaJTqzQ1Ra45rqrkWH6rOxX8LvedDDnXaUiFbUQCBVstkOCDVftNFuWQAyQVRgdO6aXsW8XlIbsV7b99WLWecHYU6OR+SqDFQxA7lnOi2
 O866+3Jo
 WCORL3PeUZdKTLeQW7Y9Wvj8Q768j1RWTGcaYiDzFG9lHWln13uH3qgDJZ5qU/jLB018mzytGOSiU2Z+7/o3EhMCUdI5zXortV9ky/PXOwzGku9leudPTGUEdfCGz7ap0V5nLbvaz92U1VIp4P4tJWMKOU0/Uq5vJpKbERlHBqGsYw4YFSHBuM5EZ33s1ebiP0HG+Y8uue5ffPKkJcG3NU/UhxNcUkpvKcUar8jBF7TWTnaV6PFpc3ppaQN8mX3QDkMocrniEXYQ7d08fGKlJmhl1ImoCkgH8t4kE/a0YN0zZXOJYbu54uIaHNOT8lrK7aUsQzsKo4Ml8d3IJnP6hkQDYigC1fdgSdWHmm9MaK77SUAMBNomW6lRgBgHBCPB9tGRF6l7ifqiOEfA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add support for the `queue_rqs` callback to the Rust block layer
bindings. This callback allows drivers to receive multiple requests in
a single call, enabling batch processing optimizations.

The callback receives a `RequestList` containing the requests to be
processed. Drivers should remove successfully processed requests from
the list; any remaining requests will be requeued individually.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/block/mq/operations.rs | 61 +++++++++++++++++++++++++++++++++++++-
 rust/kernel/block/mq/request.rs    | 26 ++++++++++++++++
 2 files changed, 86 insertions(+), 1 deletion(-)

diff --git a/rust/kernel/block/mq/operations.rs b/rust/kernel/block/mq/operations.rs
index bccc1903a0d10..e4de6db807e18 100644
--- a/rust/kernel/block/mq/operations.rs
+++ b/rust/kernel/block/mq/operations.rs
@@ -18,6 +18,8 @@
 use core::{marker::PhantomData, ptr::NonNull};
 use pin_init::PinInit;
 
+use super::request_list::RequestList;
+
 type ForeignBorrowed<'a, T> = <T as ForeignOwnable>::Borrowed<'a>;
 
 /// Implement this trait to interface blk-mq as block devices.
@@ -68,6 +70,15 @@ fn queue_rq(
         is_poll: bool,
     ) -> BlkResult;
 
+    /// Called by the kernel to queue a list of requests with the driver.
+    fn queue_rqs(
+        _hw_data: ForeignBorrowed<'_, Self::HwData>,
+        _queue_data: ForeignBorrowed<'_, Self::QueueData>,
+        _requests: &mut RequestList<Self>,
+    ) {
+        build_error!(crate::error::VTABLE_DEFAULT_ERROR)
+    }
+
     /// Called by the kernel to indicate that queued requests should be submitted.
     fn commit_rqs(
         hw_data: ForeignBorrowed<'_, Self::HwData>,
@@ -208,6 +219,50 @@ impl<T: Operations> OperationsVTable<T> {
         }
     }
 
+    /// This function is called by the C kernel to queue a list of new requests.
+    ///
+    /// Driver is guaranteed that each request belongs to the same queue. If the
+    /// driver doesn't empty the `rqlist` completely, then the rest will be
+    /// queued individually by the block layer upon return.
+    ///
+    /// # SAFETY
+    ///
+    /// - `requests` must satisfy the safety requirements of `RequestList<T>`
+    /// - All requests in `requests` must belong to the same hardware context.
+    unsafe extern "C" fn queue_rqs_callback(requests: *mut bindings::rq_list) {
+        // SAFETY:
+        // - By the safety requirements of this function, `requests` is valid for use as a
+        // `RequestList`.
+        // - We have exclusive access to `requests` for the duration of this function.
+        let requests = unsafe { RequestList::from_raw(requests) };
+
+        let rq_ptr = requests.peek_raw();
+
+        if rq_ptr.is_null() {
+            return;
+        }
+
+        // SAFETY: By function safety requirements, rq_ptr is pointing to a
+        // valid request.
+        let hctx = unsafe { (*rq_ptr).mq_hctx };
+
+        // SAFETY: The safety requirement for this function ensure that `hctx`
+        // is valid and that `driver_data` was produced by a call to
+        // `into_foreign` in `Self::init_hctx_callback`.
+        let hw_data = unsafe { T::HwData::borrow((*hctx).driver_data) };
+
+        // SAFETY: `hctx` is valid as required by this function.
+        let queue_data = unsafe { (*(*hctx).queue).queuedata };
+
+        // SAFETY: `queue.queuedata` was created by `GenDiskBuilder::build` with
+        // a call to `ForeignOwnable::into_foreign` to create `queuedata`.
+        // `ForeignOwnable::from_foreign` is only called when the tagset is
+        // dropped, which happens after we are dropped.
+        let queue_data = unsafe { T::QueueData::borrow(queue_data) };
+
+        T::queue_rqs(hw_data, queue_data, requests);
+    }
+
     /// This function is called by the C kernel. A pointer to this function is
     /// installed in the `blk_mq_ops` vtable for the driver.
     ///
@@ -450,7 +505,11 @@ impl<T: Operations> OperationsVTable<T> {
 
     const VTABLE: bindings::blk_mq_ops = bindings::blk_mq_ops {
         queue_rq: Some(Self::queue_rq_callback),
-        queue_rqs: None,
+        queue_rqs: if T::HAS_QUEUE_RQS {
+            Some(Self::queue_rqs_callback)
+        } else {
+            None
+        },
         commit_rqs: Some(Self::commit_rqs_callback),
         get_budget: None,
         put_budget: None,
diff --git a/rust/kernel/block/mq/request.rs b/rust/kernel/block/mq/request.rs
index bc655d202ca01..e22af7ea77bbc 100644
--- a/rust/kernel/block/mq/request.rs
+++ b/rust/kernel/block/mq/request.rs
@@ -148,6 +148,32 @@ pub fn queue(&self) -> &RequestQueue<T> {
     pub fn as_raw(&self) -> *mut bindings::request {
         self.0.get()
     }
+
+    // Return a valid hctx pointer.
+    fn hctx_raw(&self) -> *mut bindings::blk_mq_hw_ctx {
+        // SAFETY: The requests is guaranteed to be associated with a hardware
+        // context while we have access to it.
+        unsafe { (*self.0.get()).mq_hctx }
+    }
+
+    /// Get a reference to the [`T::HwData`] for the hardware context that this
+    /// request is associated with.
+    pub fn hw_data(&self) -> <T::HwData as ForeignOwnable>::Borrowed<'_> {
+        let hctx = self.hctx_raw();
+
+        // SAFETY: `hctx` is valid and `driver_data` was produced by a call to
+        // `into_foreign` in `Operations::init_hctx_callback`.
+        unsafe { T::HwData::borrow((*hctx).driver_data) }
+    }
+
+    pub fn is_poll(&self) -> bool {
+        let hctx = self.hctx_raw();
+
+        u32::from(
+            // SAFETY: `hctx_raw` returns a valid pointer.
+            unsafe { (*hctx).type_ },
+        ) == bindings::hctx_type_HCTX_TYPE_POLL
+    }
 }
 
 /// A wrapper around a blk-mq [`struct request`]. This represents an IO request.

-- 
2.51.2



