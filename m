Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8E2DE63F25
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 04:14:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C43B46B00F5; Sun, 15 Feb 2026 18:51:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF55B6B00F8; Sun, 15 Feb 2026 18:51:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B20526B00F9; Sun, 15 Feb 2026 18:51:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B9F806B00F5
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 18:51:08 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2307A13BB1F
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:42:56 +0000 (UTC)
X-FDA: 84448318752.01.F6D3D25
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4B06C4000B
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:42:54 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Rteou1Of;
	spf=pass (imf27.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771198974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6gTko/deqJmjoTkmD/YRUFg5PUajI6afM5Rdt0nYU80=;
	b=k7NswC6zwvZRzgG3gpN8361FQENYtb955/TmyJx36G0IMkCnTxIMS9r3lzHnx9yYl3Yupn
	q6JT6o8f3Nl5xQ3pn0XgHk907WL0+yZR+q2SViGKW7UMmdBuChG0j5FtH996wakSQhYH2i
	SBxxqyqfoRQhf8bNt7Sw1/9WMHLeUow=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Rteou1Of;
	spf=pass (imf27.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771198974; a=rsa-sha256;
	cv=none;
	b=OG6+jXMxAx80rKLEoy1Tk65kIO6+5W97g6Og1oTQ4D52MSRlqGrVKujTrSlSyWmC6/+u0D
	CSsPDLuSriHNP5EnPR2hzQDUCl6MbZESDx/nGxFFdo0YqR8dLF4vqRFwnVPHIeZ4ShQo8o
	R0FSlvRiMLJkS2sfHwkqDluu+8cZJQw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7D9664050E;
	Sun, 15 Feb 2026 23:42:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23672C4CEF7;
	Sun, 15 Feb 2026 23:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771198973;
	bh=ybh9nCCqsUVynbqxeVyqYZphZTsFNB8zOBEw2xwvxWs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Rteou1OfjI7DKLZqSkBe8PPB/IualqGflbnnBUsS9qsXSD1luGbY3im1XZdknHpCh
	 ObspwCI6zYj8eQvVnxJaOrnI8naEoqRQGGQdi3WfhjZIJIGQMQlVjdk7B2stZz1gJK
	 ch0xXIGkwAtBB/E4wPNKPKMCvVonP+3A2qHyZfyXZAkJz4obksknG9EioW6Ibv4AYi
	 bJe079aEZpDebE/eorwXj6dZO4h6zvF7yOnLRz9u+uWDLVkFkzL8sQR38QBGCwdECZ
	 1ZsbAjWZn1CuPwdZ0I9OpgeOVqpLAbH09MZV/pP0NBdDW5uYre/tnRtCx3ugieDPjO
	 Zr25lEJigzPDQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 16 Feb 2026 00:35:38 +0100
Subject: [PATCH 51/79] block: rust: add polled completion support
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-rnull-v6-19-rc5-send-v1-51-de9a7af4b469@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=9024; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=ybh9nCCqsUVynbqxeVyqYZphZTsFNB8zOBEw2xwvxWs=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpklhJUt9ZG6dMGHexv9X0pUqQqoVvjeHvSSbTC
 N7CBGOKzqqJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZJYSQAKCRDhuBo+eShj
 d0YkD/wM2YmefoyIOH2Avc5M4h+sj8E49GBIT9pw/3UvtWozdRDkLczeYLr9jQGFz0SP2jpZ9zh
 TJhoqSB97nBs8R5KwAZfCsB6Ox2tM5z1dqFGBfzFwhIlU3YrKjAYKELexy1poD/IXocYw1FFfJu
 VLH4+RaAg16WK5srruKHjDylJCuj7ATBAIr8Vxtuvwk/8TvtO2NAFN3nQd01MMMj4mt2H+NGdvG
 EM4SVRCwqUzqhbk22R9jrF7CRPiT7Et3cRX36c2YULLiktSl9hcjVbuLNdQtMbGlf4uyuKDLR5r
 1fSBAM1Kjx6SwvgegBSYTCmDDsyCP9Jg17eemC9xeZTUYdIJdeHBl+bKtgvePqqUxRuNM+nxYvv
 Ke2FOITFh2i6hjr5s2RXeJjxR8sTk1mzvGCQ6qL2P56mKQDzcKuXJSwjxyRGLUN00v5WgKWWuHz
 l3mee429Irt+8c2fJD/NPYQTI8jLiLHPwqGsNOG+jpo0NTsDj5G13IAugg4terPzoirj1KZygt+
 YMR9a+9YRItbUV/BEJjS3NCmGfU2daUz24JpewoCuWjSginBmwyx8Y20jpGTTyiIxBl+4Pkx9Ar
 A/PXt41xofUhYuAr/OrFFSSrb3lpkh9X21FdITS7I36WQd5oChWpOZM1zLA8ECX2LFAorKHcX42
 XOS3K4rjwbL/o0A==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4B06C4000B
X-Stat-Signature: rnbuxyymasqmn193jzqpekhu55gtapq1
X-Rspam-User: 
X-HE-Tag: 1771198974-934169
X-HE-Meta: U2FsdGVkX19byZTgzIG+1ZabagQiOc/ZzWaLl86vFCKCxgA0WIzQBVAi/6Dmn1/wKY7PdfUT8B4vvpXeMt+YqEtAcPscHWfBXCDZjLXOoFud3iGCEL1qobWAejOuQ1gwzhfjnmdZUOgAPNYCyNrwzUgBbMISDQmZy1FPR5VPJqt8/GuYyZeddXJ6Im4lQMBo1qmXjO9D1XeSsZS0xpnXwDixF0Gq+ysAx0xXt4tAC+l0C1SO3e3lhBds5XEHPE4FVaEXLGqm273uNrxZcVYZO0NHfLNhJeXEAdiVuVFjNkU1KWYh5/sEGDOFDGkisUrAMTixvtnINelvJF5ETso2KK0CiwO0DG24tU/RBozBV7WXOkKRgfcL9/3YXcrSe4G7OpvqpXahbb0y288dZ5t7ZQK0HRj2z8qkN4dqAbJT8RKQEuPkzDr9Rjc+jooUQIL990LBVRzAMur+GAcg3PVaHUrsNWbSMaIp37nE0MFjDRn3iQDCcVyNeScL3A56Nk+S56pNCBkoQfVABo2a8a/HLid0rk32mpHMRcFOkty0ixldZ40jHZR0d6tL7G5RFkh72v8XZL9GF/DWBlOAH22LtZ6EBJjyeZiCV5PfvYFzeMzIK6MONXuYfF1GdIF/3KCFFafyrq9MChE/i7wmWR9C4RsAUTLgcuNJmcc+MTvXwa29SrQAZGEsk57Z5pJbeFxn3vN/NTqJFP9MkMSuJ8PL8ZjaMWWx0I4dOxa853u1QjEjYhN5k4MYvVZblSbau8zIwwLTE6PiRmQYjeDuu1E0tAHC9UiETmEmI5CM3Q1XbGiN7UEEfmBkGGn8GDJhf1ycD00t27rsK3oe2Kldd1TGY1nr0jV7YW9bmyi1uxGLal39wdBzApql68oaLXVc43JYaNbhbrFcBYoC9v+Qm1nQDvRKO6oVIbDyKQJ2ZjcrdMxnbzTHiy9j0v5FqrFZsjfnkqH8Ce4sTx1DvZX1KS+
 BEdAuMJf
 hcAa2JvCZVo3WLo/gEN8Ebv4HE4Ip3u+Bk7zBJwAC9HwtMICD4eB8UuCGto1QrLK92thVLNmkaZ9EsCDnQY3oJNFCOdb59OHE2HvGUkOhejJoy8geCLJNVc4R7t7fpMv/yg652s/FYwUVobATGm0EDjzZyS4OAJPc9GogwXil//wniV8tlYBUOxdQ1pT9woy9xBya6FzFkqZ8NfNTJytz1wKuM9tBPu6ALiRF0/DjQrudm//OyTDtaI9zXKokcQ39pfcgJ69poB3aixbftjawR6YDtz3Gndseb7W/zVoibBup3g2Q0DIv+AHRq8d1LTNKIH5R
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add support for polled I/O completion to the Rust block layer bindings.
This includes the `poll` callback in `Operations` and the
`IoCompletionBatch` type for batched completions.

The `poll` callback is invoked by the block layer when polling for
completed requests on poll queues. Drivers can use `IoCompletionBatch`
to batch multiple completions efficiently.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 drivers/block/rnull/rnull.rs       |   1 +
 rust/helpers/blk.c                 |   7 +++
 rust/kernel/block/mq.rs            |   4 +-
 rust/kernel/block/mq/operations.rs | 104 +++++++++++++++++++++++++++++++++++--
 rust/kernel/block/mq/request.rs    |   5 ++
 5 files changed, 117 insertions(+), 4 deletions(-)

diff --git a/drivers/block/rnull/rnull.rs b/drivers/block/rnull/rnull.rs
index 48b2bd598304c..765bbc8101d10 100644
--- a/drivers/block/rnull/rnull.rs
+++ b/drivers/block/rnull/rnull.rs
@@ -733,6 +733,7 @@ fn queue_rq(
         this: ArcBorrow<'_, Self>,
         rq: Owned<mq::IdleRequest<Self>>,
         _is_last: bool,
+        _is_poll: bool,
     ) -> BlkResult {
         if this.bandwidth_limit != 0 {
             if !this.bandwidth_timer.active() {
diff --git a/rust/helpers/blk.c b/rust/helpers/blk.c
index 53beba8c7782d..91b72131a04cd 100644
--- a/rust/helpers/blk.c
+++ b/rust/helpers/blk.c
@@ -20,3 +20,10 @@ void rust_helper_bio_advance_iter_single(const struct bio *bio,
 {
 	bio_advance_iter_single(bio, iter, bytes);
 }
+
+bool rust_helper_blk_mq_add_to_batch(struct request *req,
+				     struct io_comp_batch *iob, bool is_error,
+				     void (*complete)(struct io_comp_batch *))
+{
+	return blk_mq_add_to_batch(req, iob, is_error, complete);
+}
diff --git a/rust/kernel/block/mq.rs b/rust/kernel/block/mq.rs
index cd0bfbcbf317a..1d58eea971bd7 100644
--- a/rust/kernel/block/mq.rs
+++ b/rust/kernel/block/mq.rs
@@ -89,7 +89,8 @@
 //!         _hw_data: (),
 //!         _queue_data: (),
 //!         rq: Owned<IdleRequest<Self>>,
-//!         _is_last: bool
+//!         _is_last: bool,
+//!         is_poll: bool
 //!     ) -> BlkResult {
 //!         rq.start().end_ok();
 //!         Ok(())
@@ -130,6 +131,7 @@
 mod request_queue;
 pub mod tag_set;
 
+pub use operations::IoCompletionBatch;
 pub use operations::Operations;
 pub use request::Command;
 pub use request::IdleRequest;
diff --git a/rust/kernel/block/mq/operations.rs b/rust/kernel/block/mq/operations.rs
index 28dd4b28d203f..bccc1903a0d10 100644
--- a/rust/kernel/block/mq/operations.rs
+++ b/rust/kernel/block/mq/operations.rs
@@ -65,6 +65,7 @@ fn queue_rq(
         queue_data: ForeignBorrowed<'_, Self::QueueData>,
         rq: Owned<IdleRequest<Self>>,
         is_last: bool,
+        is_poll: bool,
     ) -> BlkResult;
 
     /// Called by the kernel to indicate that queued requests should be submitted.
@@ -84,7 +85,15 @@ fn init_hctx(
 
     /// Called by the kernel to poll the device for completed requests. Only
     /// used for poll queues.
-    fn poll(_hw_data: ForeignBorrowed<'_, Self::HwData>) -> bool {
+    ///
+    /// Should return `Ok(true)` if any requests were completed during the call,
+    /// `Ok(false)` if no requests were completed, and `Err(e)` to signal an
+    /// error condition.
+    fn poll(
+        _hw_data: ForeignBorrowed<'_, Self::HwData>,
+        _queue_data: ForeignBorrowed<'_, Self::QueueData>,
+        _batch: &mut IoCompletionBatch<Self>,
+    ) -> Result<bool> {
         build_error!(crate::error::VTABLE_DEFAULT_ERROR)
     }
 
@@ -168,6 +177,11 @@ impl<T: Operations> OperationsVTable<T> {
         // `into_foreign` in `Self::init_hctx_callback`.
         let hw_data = unsafe { T::HwData::borrow((*hctx).driver_data) };
 
+        let is_poll = u32::from(
+            // SAFETY: `hctx` is valid as required by this function.
+            unsafe { (*hctx).type_ },
+        ) == bindings::hctx_type_HCTX_TYPE_POLL;
+
         // SAFETY: `hctx` is valid as required by this function.
         let queue_data = unsafe { (*(*hctx).queue).queuedata };
 
@@ -184,6 +198,7 @@ impl<T: Operations> OperationsVTable<T> {
             // SAFETY: `bd` is valid as required by the safety requirement for
             // this function.
             unsafe { (*bd).last },
+            is_poll,
         );
 
         if let Err(e) = ret {
@@ -242,13 +257,32 @@ impl<T: Operations> OperationsVTable<T> {
     /// previously initialized by a call to `init_hctx_callback`.
     unsafe extern "C" fn poll_callback(
         hctx: *mut bindings::blk_mq_hw_ctx,
-        _iob: *mut bindings::io_comp_batch,
+        iob: *mut bindings::io_comp_batch,
     ) -> crate::ffi::c_int {
         // SAFETY: By function safety requirement, `hctx` was initialized by
         // `init_hctx_callback` and thus `driver_data` came from a call to
         // `into_foreign`.
         let hw_data = unsafe { T::HwData::borrow((*hctx).driver_data) };
-        T::poll(hw_data).into()
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
+        let mut batch = IoCompletionBatch {
+            inner: iob,
+            _p: PhantomData,
+        };
+
+        let ret = T::poll(hw_data, queue_data, &mut batch);
+        match ret {
+            Ok(val) => val.into(),
+            Err(e) => e.to_errno(),
+        }
     }
 
     /// This function is called by the C kernel. A pointer to this function is
@@ -448,3 +482,67 @@ pub(crate) const fn build() -> &'static bindings::blk_mq_ops {
         &Self::VTABLE
     }
 }
+
+/// A batch of I/O completions for polled I/O.
+///
+/// This struct wraps the C `struct io_comp_batch` and is used to batch
+/// multiple request completions together for improved efficiency during polled
+/// I/O operations.
+///
+/// When the kernel polls for completed requests via [`Operations::poll`], it
+/// passes an `IoCompletionBatch` to collect completed requests. The driver can
+/// add completed requests to the batch using [`add_request`], allowing the
+/// kernel to process multiple completions together rather than one at a time.
+///
+/// # Invariants
+///
+/// - `inner` must point to a valid `io_comp_batch`.
+///
+/// [`add_request`]: IoCompletionBatch::add_request
+#[repr(transparent)]
+pub struct IoCompletionBatch<T> {
+    inner: *mut bindings::io_comp_batch,
+    _p: PhantomData<T>,
+}
+
+impl<T: Operations> IoCompletionBatch<T> {
+    /// Attempt to add a completed request to this batch.
+    ///
+    /// This method tries to add `rq` to the batch for deferred completion. If
+    /// the request is successfully added, ownership is transferred to the batch
+    /// and the request will be completed later when the batch is processed.
+    ///
+    /// # Arguments
+    ///
+    /// - `rq`: The completed request to add to the batch.
+    /// - `error`: Set to `true` if the request completed with an error.
+    ///
+    /// # Return
+    ///
+    /// When this method returns `Err`, the caller is responsible for completing
+    /// the request through other means, such as calling
+    /// [`Request::complete`](super::Request::complete).
+    pub fn add_request(
+        &mut self,
+        rq: Owned<Request<T>>,
+        error: bool,
+    ) -> Result<(), Owned<Request<T>>> {
+        // SAFETY: By type invariant, `self.inner` is a valid `io_comp_batch`.
+        let ret = unsafe {
+            bindings::blk_mq_add_to_batch(
+                rq.as_raw(),
+                self.inner,
+                error,
+                Some(bindings::blk_mq_end_request_batch),
+            )
+        };
+
+        match ret {
+            true => {
+                core::mem::forget(rq);
+                Ok(())
+            }
+            false => Err(rq),
+        }
+    }
+}
diff --git a/rust/kernel/block/mq/request.rs b/rust/kernel/block/mq/request.rs
index 4e7adb10929f0..b4f5a98a97b16 100644
--- a/rust/kernel/block/mq/request.rs
+++ b/rust/kernel/block/mq/request.rs
@@ -135,6 +135,11 @@ pub fn queue(&self) -> &RequestQueue<T> {
         // SAFETY: By type invariant, self.0 is guaranteed to be valid.
         unsafe { RequestQueue::from_raw((*self.0.get()).q) }
     }
+
+    /// Return a raw pointer to the underlying C structure.
+    pub fn as_raw(&self) -> *mut bindings::request {
+        self.0.get()
+    }
 }
 
 /// A wrapper around a blk-mq [`struct request`]. This represents an IO request.

-- 
2.51.2



