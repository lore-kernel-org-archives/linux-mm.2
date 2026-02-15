Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BD2AE63F25
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 04:54:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CAE36B009E; Sun, 15 Feb 2026 23:54:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A2EB6B00A1; Sun, 15 Feb 2026 23:54:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3505A6B00A3; Sun, 15 Feb 2026 23:54:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B343D6B009E
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:54:26 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1B01A160B12
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:44:44 +0000 (UTC)
X-FDA: 84448323288.15.BCF3A88
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 667E0C0006
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:44:42 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qt0jb3wr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771199082; a=rsa-sha256;
	cv=none;
	b=Hb5iwu1eahrp96gMxC87G9D+1QlMH/BiNUGx7pUJgQoTtCjY9TugDu73gZBPtVsI5rQiS9
	I5cA+MJE7ZJmX/yl7dD6/4txFhLPsqyhQiRbVVDbjDkN+/06DPOuiwzDXy/02jws+c/VQH
	sojJRSgsXtvDLy6LoXfSE+SlB9KPkNE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qt0jb3wr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771199082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zum/PEV1YsmxFUGiaVnxyhlTXMT9vNUDvqy90xHdMbE=;
	b=yaVh7TyxjI4aA3opUU7bqaoxo2TRhgwitrbz38oa8XPdJeu15SvDpnpI/gqcK74v0EQqnN
	ICFfYy04QIz4u+mhIuWljZBgC+3WuBUxAmWkpiszYsMfnEQZs35hZ0BFzBETR2S4g4mxMl
	v5Pd+UOiZbofE5xSUZYv09ceeRLMeAU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E654C6013E;
	Sun, 15 Feb 2026 23:44:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BAF7C4CEF7;
	Sun, 15 Feb 2026 23:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771199081;
	bh=aZRrI7grlZwViJknRtkxdybKDycUBf8fCcK8vfkelAQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=qt0jb3wrj4xroz5c6uTfqBoK3nmsYUTL/kzMq1GJfaxJYeSbEjWtNEvp/YH6YvxxM
	 oW6NjXLl7C8Rj5Pxuxu0HBqDBlNkBlq++YKeTPlqVXHEnhf6xOuHXJ9izD5oaOnUGA
	 bvfcoNqNIyjyeJ3tKGGbwYfGMgjcsW6qQWgLB+xyxX0xlUeUvecKVrqc/qDIZMKO02
	 rIBPdpdLnrCD4GIst3Tp36NKgJOyPPDDZmhtJFaRcaxeIRPYvC8hOwMlXMRnkPpFjI
	 x4L3vS6BXD2lBT9tVFGhMNhJBhpjfTDC8axCWVbAjQyVdhqc7ENJAka1OMZsgTOm0j
	 aSriUStk3f5UQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 16 Feb 2026 00:35:59 +0100
Subject: [PATCH 72/79] block: rust: add `request_timeout` hook
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-rnull-v6-19-rc5-send-v1-72-de9a7af4b469@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=6695; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=aZRrI7grlZwViJknRtkxdybKDycUBf8fCcK8vfkelAQ=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpklhcFdAYDse1qYjlb88yVrs/2r4YJvu3bHRZ0
 KLmw+vrTeOJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZJYXAAKCRDhuBo+eShj
 d1XmEACnowsioZfBSvToF9sWGL4GZDs4H83IbFZ/qBJH9HYvC5c5e69trcDeXVyiSY9ncJVk1r9
 +4dbvcPZFaNP57M40/imGhDc4zJ11mL8d8w8K+JR5QqewEtHm0bY64a5rtg0fvDJQ1T7pLWnexO
 yzILWHZaFN8cyTAMTBdZmRNqTSv63VOueQSIDjwDlV2alDpJuLQBrV5PPAe3YGzQ++xTpyMHzgH
 l9puBa+1SzwBEiFg/MX9RFlnl/nyAiTDKPuOlxTsbVKDAf0OkQ5KuhUzXQPD+/1bG83jG08Lls1
 o88X+OX6alrNXkGM/aClhpj4zuYxDTFAWLwdqfidg1HJRNnjVWezpOiEZSCqqZyEmjomMixwC8Q
 Xxjb6bXisCC9AhmXasx7wV49uCS31HIceuMAP/60fPmgbR6vVBP8Ii3Dd6SJlp3o8tA7SkxWjtH
 0wgZMQPo5Iiu8dj3uPFx6w20bBhmzCQ/fCiBc+WGRWrnN02JV+1cTwpXWrmHZGhpcLBtCQO6Jvb
 PXmQi57majPpveWa4LUn0V6Uh/jELxmACJIt5geSbNXeEcbfzKyDh2Q+SpFgbWe71ETkvQGWkin
 aT1zM0eN4xnGIyVms91lsDKdTkkPMyFkzHp3SBIoa3RO8AV99kwqt7vD4U2RRg2wTtRahiWYp5D
 4Z7dUPkBWqPuQjQ==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 667E0C0006
X-Stat-Signature: 6xgiboc7icyb77txpzqyzd8uuzqoyxe3
X-HE-Tag: 1771199082-206015
X-HE-Meta: U2FsdGVkX18TvUk4wa/WXwRwhETLlfLm53rcLXYXQ/J47XNib84bA3VMaTVmBuXZRQTxs9uM+cUsghZUEKueybzbLLYNzqR6tCI/rWJFtAcPH+gi+Wwu+hyW2kpEWdJGwBccC51dW45C30r5W82cAoSQpsJew/Wqe1ymA2pvSNc16ku7TANTIcYDMdcz5EEjL6b6WRAO7EhHv5RzIw6hDOWrAto42eFwPzEYRjtcV65gkWKy5easid/G5lwpN+BA8u0iNL1noj5Ew/6OLGJdoIjLv6v1TKulvq3QdXOqNfEAJfyCnKGewZVAD7KefB/VOYdPJ0GZ3MErd8bnG+cMoXzJP1d5SgpAYjDg8II2nVX4NEKa+s48QX6ORp/KJ2LV94nYaD474709nMUMe/e3UIolajRs2B5dqDQR5SrYiCyIX2w3RGubBsltkWfnS75AB0Z3W32PNiHgNDGbxW25j7m+fGi33CppGzPWEkKSEt45fE88NmMlEyKMpw7W4Y8QYiMAFtqiy8CeQCenE2Wn1VIqphqxa3FkbrYnboD9RtCwviuFIerHKezw5FajGkMb8J9dyf9idFclPwBLkYgnK2LRRg3UcuDFJjhosOCXFR0L8tKOvUeXf8IokEzXytLN0+GYOa7tS209tYtljJu2t0nfmJy3C9rdaIt4UNyRwtniSfYbXJQp5LML06Bz86SHfyR06qYM48ixtAxnqtmoljSq2WL8vwskwMwRLzjzXWooQiNZOPK9PzqXYa1aAJH1xBWktD9NXKZpppW9my7ISo4EpPTC2XAmsgBcgMk+hOtf40iYbKyoyqj9o2Q0jI/qmNGV9jNWughcyZ1YONo0sWDSwBcdmWKBnBgtIf3EiS1e5Op5uviU1D5YGpOfBnkXkc/JMO2R8YO/ujsGFAkflaZwvTbUk3wl8i7hLERTiH+77BIhwJXv+us9mjpTtXo4Vuc/3d+cBx4RjgL8hX5
 bu0p4DlR
 pBtImFiDTEpGNazsXVeQZ83JtGGuvQ2+vOPnbXlToynMEcvBFTHCkhnBOJ1jCjHWsExBGk/v927w4gLytAPQUaKSS7V/cMYZeBr+src0AJfEDW552WNDIbgaYzLt6pC0udDCl+BRSV6gWPyg16V/SRJDKe6xhdEf/rsGCo2DfaVy5Lw9lpwhlfCCheYDkupWsaL2wozPTldW03upH5qJHZE5ZG9qcrDeeEwdZu26ZY22/T0Cj3NNefgXxz3LE91dAx+O20pNomZKANv5SFSopvdGj2hP19qMV9AR4a34lFKMRYdDs3MHq5biHvD/WdZgXvRLKFgmTolvcioz/O2OCQWRa/5HMjpKBuu3o3687l3+VlFY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a hook for the request timeout feature. This allows the kernel to call
into a block device driver when it decides a request has timed out. Rust
block device drivers can now implement `Operations::request_timeout` to
respond to request timeouts.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/block.rs               |  1 +
 rust/kernel/block/mq.rs            |  1 +
 rust/kernel/block/mq/operations.rs | 78 +++++++++++++++++++++++++++++++++++++-
 rust/kernel/block/mq/tag_set.rs    |  1 -
 4 files changed, 79 insertions(+), 2 deletions(-)

diff --git a/rust/kernel/block.rs b/rust/kernel/block.rs
index 6cd83dc75a5eb..d4f09d6fa9f97 100644
--- a/rust/kernel/block.rs
+++ b/rust/kernel/block.rs
@@ -42,6 +42,7 @@ macro_rules! declare_err {
         declare_err!(BLK_STS_NOTSUPP, "Operation not supported.");
         declare_err!(BLK_STS_IOERR, "Generic IO error.");
         declare_err!(BLK_STS_DEV_RESOURCE, "Device resource busy. Retry later.");
+        declare_err!(BLK_STS_TIMEOUT, "Operation timed out.");
     }
 
     /// A wrapper around a 1 byte block layer error code.
diff --git a/rust/kernel/block/mq.rs b/rust/kernel/block/mq.rs
index 02d75acfddb3b..41008f9bb32cd 100644
--- a/rust/kernel/block/mq.rs
+++ b/rust/kernel/block/mq.rs
@@ -135,6 +135,7 @@
 pub use feature::{Feature, Features};
 pub use operations::IoCompletionBatch;
 pub use operations::Operations;
+pub use operations::RequestTimeoutStatus;
 pub use request::Command;
 pub use request::Flag as RequestFlag;
 pub use request::Flags as RequestFlags;
diff --git a/rust/kernel/block/mq/operations.rs b/rust/kernel/block/mq/operations.rs
index efead98767196..4767be3ad2a5a 100644
--- a/rust/kernel/block/mq/operations.rs
+++ b/rust/kernel/block/mq/operations.rs
@@ -125,6 +125,51 @@ fn report_zones(
     fn map_queues(_tag_set: Pin<&mut TagSet<Self>>) {
         build_error!(crate::error::VTABLE_DEFAULT_ERROR)
     }
+
+    /// Called by the kernel when a request has been queued with the driver for too long.
+    ///
+    /// We identify the request by `queue_id` and `tag` as we cannot pass
+    /// `Owned<Request>` or `ARef<Request>`. The driver may hold either of these
+    /// already.
+    ///
+    /// A driver can use [`TagSet::tag_to_rq`] to try to obtain a request reference.
+    ///
+    /// A driver must return [`RequestTimeoutStatus::Completed`] if the request
+    /// was completed during the call. Otherwise
+    /// [`RequestTimeoutStatus::RetryLater`] must be returned, and the kernel
+    /// will retry the call later.
+    fn request_timeout(_tag_set: &TagSet<Self>, _queue_id: u32, _tag: u32) -> RequestTimeoutStatus {
+        build_error!(crate::error::VTABLE_DEFAULT_ERROR)
+    }
+}
+
+/// Return value for [`Operations::request_timeout`].
+#[repr(u32)]
+pub enum RequestTimeoutStatus {
+    /// The request was completed.
+    Completed = bindings::blk_eh_timer_return_BLK_EH_DONE,
+
+    /// The request is still processing, retry later.
+    RetryLater = bindings::blk_eh_timer_return_BLK_EH_RESET_TIMER,
+}
+
+impl RequestTimeoutStatus {
+    /// Create a [`RequestTimeoutStatus`] from an integer.
+    ///
+    /// # SAFETY
+    ///
+    /// - `value` must be one of the enum values declared for [`bindings::blk_eh_timer_return`].
+    pub unsafe fn from_raw(value: u32) -> Self {
+        // SAFETY: By function safety requirements, value is usable as `Self`.
+        unsafe { core::mem::transmute(value) }
+    }
+}
+
+impl From<RequestTimeoutStatus> for u32 {
+    fn from(value: RequestTimeoutStatus) -> Self {
+        // SAFETY: All `RequestTimeoutStatus` representations are valid as `u32`.
+        unsafe { core::mem::transmute(value) }
+    }
 }
 
 /// A vtable for blk-mq to interact with a block device driver.
@@ -496,6 +541,33 @@ impl<T: Operations> OperationsVTable<T> {
         T::map_queues(tag_set);
     }
 
+    /// This function is called by the block layer when a request has been
+    /// queued with the driver for too long.
+    ///
+    /// # Safety
+    ///
+    /// - This function may only be called by blk-mq C infrastructure.
+    /// - `rq` must point to an initialized and valid `Request`.
+    unsafe extern "C" fn request_timeout_callback(
+        rq: *mut bindings::request,
+    ) -> bindings::blk_eh_timer_return {
+        // SAFETY: `rq` is valid and initialized.
+        let hctx = unsafe { (*rq).mq_hctx };
+        // SAFETY: `rq` is valid and initialized, so `hctx` is also valid and initialized.
+        let qid = unsafe { (*hctx).queue_num };
+        // SAFETY: `rq` is valid and initialized.
+        let tag = unsafe { (*rq).tag } as u32;
+        // SAFETY: `rq` is valid and initialized, so `hctx` is also valid and initialized.
+        let queue = unsafe { (*hctx).queue };
+        // SAFETY: `rq` is valid and initialized, so is `queue`.
+        let tag_set = unsafe { (*queue).tag_set };
+        // SAFETY: As `rq` is valid, so is `tag_set`. We never create mutable referennces to a
+        // `TagSet` without proper locking.
+        let tag_set: &TagSet<T> = unsafe { TagSet::from_ptr(tag_set) };
+
+        T::request_timeout(tag_set, qid, tag).into()
+    }
+
     const VTABLE: bindings::blk_mq_ops = bindings::blk_mq_ops {
         queue_rq: Some(Self::queue_rq_callback),
         queue_rqs: if T::HAS_QUEUE_RQS {
@@ -508,7 +580,11 @@ impl<T: Operations> OperationsVTable<T> {
         put_budget: None,
         set_rq_budget_token: None,
         get_rq_budget_token: None,
-        timeout: None,
+        timeout: if T::HAS_REQUEST_TIMEOUT {
+            Some(Self::request_timeout_callback)
+        } else {
+            None
+        },
         poll: if T::HAS_POLL {
             Some(Self::poll_callback)
         } else {
diff --git a/rust/kernel/block/mq/tag_set.rs b/rust/kernel/block/mq/tag_set.rs
index e7d7217da8922..88a425a70b283 100644
--- a/rust/kernel/block/mq/tag_set.rs
+++ b/rust/kernel/block/mq/tag_set.rs
@@ -98,7 +98,6 @@ pub(crate) fn raw_tag_set(&self) -> *mut bindings::blk_mq_tag_set {
     /// `ptr` must be a pointer to a valid and initialized `TagSet<T>`. There
     /// may be no other mutable references to the tag set. The pointee must be
     /// live and valid at least for the duration of the returned lifetime `'a`.
-    #[expect(dead_code)]
     pub(crate) unsafe fn from_ptr<'a>(ptr: *mut bindings::blk_mq_tag_set) -> &'a Self {
         // SAFETY: By the safety requirements of this function, `ptr` is valid
         // for use as a reference for the duration of `'a`.

-- 
2.51.2



