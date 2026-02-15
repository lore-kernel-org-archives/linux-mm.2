Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89628E63F25
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 04:15:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E2766B00A7; Sun, 15 Feb 2026 18:56:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38CEC6B011F; Sun, 15 Feb 2026 18:56:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 281626B0120; Sun, 15 Feb 2026 18:56:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with SMTP id 3BDCE6B011F
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 18:56:24 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 771AB1A0B89
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:45:43 +0000 (UTC)
X-FDA: 84448325766.13.60D5E5B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 94D9B20002
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:45:41 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OWNqkVSp;
	spf=pass (imf03.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771199141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cU9n8VtrKWF/Ned4VA7bLx59vaXoDeVVB97sLGd4KcE=;
	b=cIJZxo7DClVmYA0shu6s15wFCOyA3Yiq8D/eocWB9Ctj4SYTLNQc8L12tP8CLTrPE5QX+b
	f0tJoAC5lMWuBw2g/Glr8I2/sNljv6c/BiloKab8QvN+OO66CdgZtlXihLSIBMEIbsWLbu
	mSkIf40jTY3GTyuZkYXAUTtFPRPZTFU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OWNqkVSp;
	spf=pass (imf03.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771199141; a=rsa-sha256;
	cv=none;
	b=d/Mrn+Ypl1rFcjEvxRGRMFBKNmH0Xo8n5vllrm6hcDRZvPc3hqOyk6XwcBevjLkAPfEPEw
	Lp5UIkRocVNSu0CBBww+N3kO/F+mB6Kdek5eBc/VHR3etk3hY/MY0uoeBfK6mjXEQl8ZzL
	hSCSb3V9TvplFk5OxPPi7wDemQwjRiw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BEEDC419FF;
	Sun, 15 Feb 2026 23:45:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6497AC4CEF7;
	Sun, 15 Feb 2026 23:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771199140;
	bh=iHJebs10G3KEuSKPd64YYQzEozbVohCdh4WUvdT+gdA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=OWNqkVSpuHPfeqJ1obG9KjUAge7I1l0KH3Bd4vcO7D26r2YjI5dQDpC664biAVsof
	 LFGcoc+uoSB3f4UWDWN86wMaA+4RLjrMK04KxYVHi3HbR/g1M2+q6dJsxzwsAmUXf0
	 MkdCMQfCPZCXbesYKg53FrD3gFepV53oCsnpLSVUlJj1CppafFHN3uj7GrdOBt7HWz
	 gnz5pKgtMyrqfBnP12nE/1Iul/ci552vsJvYYQAyjIFfwPXI2JLXzPhnxLqcng+qQB
	 mvptHf9cmJkdD+nYS69XoZtNMyqtb+EQ73fqh0HFSZdctdRHsTaTiX549NW1gItkDz
	 A8JUVDBoPx4Rg==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 16 Feb 2026 00:35:51 +0100
Subject: [PATCH 64/79] block: rust: add an abstraction for `struct rq_list`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-rnull-v6-19-rc5-send-v1-64-de9a7af4b469@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=6135; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=iHJebs10G3KEuSKPd64YYQzEozbVohCdh4WUvdT+gdA=;
 b=kA0DAAoB4bgaPnkoY3cByyZiAGmSWFWjeowTsFEiINSqulAD21O5tLcZBRTLEu7+cvl0taWOq
 YkCMwQAAQoAHRYhBBLB+UdWv3wqFdbAEuG4Gj55KGN3BQJpklhVAAoJEOG4Gj55KGN3uDQQAK5S
 TJnyt6251s9+e3u70mSgIM2EB4xbkhZPSh2nxTo3lEp8w82guHRW0t/howvgJ3nj9a6w4XCwEb+
 AV1gxbGx40380Hc0c3wU9N+z4qG5PXCNGGOHSd+OEnl5gVXZnZZtbbVSveZ79khqvzcTJ3gz7d0
 7UIWol335/lElOkzzPm/gSQKxUSKOcIt2H+VozTRfqpok96aJx89/jI9g7tI4goDwEh00tbcchK
 PpHQ0APkpbh09Kb81cZ0I/SXBMWttrK3oF3P8eio0mjOLmq7Eh2Dhvs1kB1OZd3LbsUHXb0xDCa
 WJEanZ2sRkFI8QAVA5/6loJIUgo1joWAaMu2oUIbvIp5FAlKy2p/crJIYU+hdKE7pm8O+VNmqps
 rW7N1XxuiUFlFp2SQwlKbxmnshbAz7OvnLl1LvvYfdfv7BQMCIzjBRfdExGQl28u6kCiN2o8YDS
 dDkxJ+d/dydjryyzj7Mr444ULi3Cl73k+OAm09roYSf9gxMKYBkO2gExZsIg4B0WqdUA5GUkYXi
 cJn5wgLNpae6d8gxQ7y8KXFpa87YWXO2bxdWn3efgB/cERasAm6EG5izcBgz/WEFLSksxZJsS79
 0TL1iD3sJOhx1/dvbZBCVV3oHa/xp6OnRG/JFWt31mFFA0+/9upKGkRAW0okHMgaq2tWDEcgTy1
 Cv3+C
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam12
X-Stat-Signature: asa13aq8h9i3xkogh16sub4qd8ho6rrx
X-Rspamd-Queue-Id: 94D9B20002
X-Rspam-User: 
X-HE-Tag: 1771199141-371182
X-HE-Meta: U2FsdGVkX1+kYGaXDEOCnKiaxysAaRI6TgnGJQ8ZZLHphVA5x5SuDUpRvmC7TvcIK/scnlrHWehSWLjH+6roPEGpi0ASyNQooy1IZsIVcJ82KSdr1E28nYt43ww3duu+BwufwqwmGMzfUFBFfoziebm92g7STfm3mt2FuxF8OdLVidAJcNtAPfEUxk5o3OEOnN5pRId4yODQ3XiK8EIvMhyYNr52B49/dgave1oYQWxvtP9nmKVY4EU4KWPGBXPdc+JtQwRHgBdR/ytHtOx0bkzNsyBSE/L+Ay9G+OiDwYjcagS4Xcp6NRr35k5WazgoplLycXwQK2JKsqLc788BI7bvijZM041uotj/LwIOVKt05ZX1dbDmvGAkI2QOjsK1sdyVxDry6UYBSJh1nas1BOHbxedc4eGdAIhbpfKwbLawdiXyo3uoJkQvYnYlK+hC6sTjV7RI7oA1p16EKyr88jp/YTkCFNv4PxxdQRDWcg/zIb7YdrwoLenU7OOuxyJOs0ZS9XVG0xayQUmJpIbhE2QN9k8BuS84azaXN6NT6sjq04Ej2RH6RINCvLI1p+6eOuADELi7HoTkmaJiewZb+hAa/myERxSAp5E6RwX6LozZO4/CsohYh5iFulszHObwc97q59xMAgXQMf5QOVxk/EWR4F8xYMBtS6CYUk4JtalTOFI6mOm6p84LQIkgZAT9wBAJR7s0OwHvJpJprlGWhBLknCZkDq4dFAOvKs5qsFDxM+EafdM/Q/aYf+VZusfDyTRu9J4MCT4WDrbsW7vuYxmyGVT9WpzvUt53SN3oFGKJATkrTrIpvHYN2tu5iJnt7eVaNDnnHpyRcfA25i/Ax3jNP6ea6Mo7r6wrjy52fJOUmmQTnNc3yRQKMMcVufNiitv6gxm+4ZIF78TxbEk6gWD4HdPUg5q3uBrJ7Ua67CDvrMxOzXF3KCnfWWkhWJ3TY8Q+PmPaQCE8xhv86YV
 aF1Axhh8
 9f7OKF8Jx/MQzQS3AdatRY2kixMzOmlqjhq193LUD3pE+nobnWhRd3btAc2yI7ghbTfuigDwwuBbuc29pGtn3qR8t/CIuvsNsjE28pNFT88fIIiZd48NtDO8+rP81GmreoMg3Yf9CKw0o24vL1y4T0Yx0EM5oLZsPPwMsAc68rR51JPSosLObmfJRmHPjoJv91/29Xi6/S7wr5k+OUQ1qVKTJo528mvhxQIaHq2bqvYNDxN3I+KN2gAtzcRvTggfrjs8GFRuSdLtRrT+qkQpGnPpcQ8P/22UwW7xxssT6z59A4D8E6mzSfvOxWnsMuN6uXybLuZ9Uq34cadzuQVkPRCTcMIJHa+S9qwnyk26dGptPyN4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the `RequestList` type as a safe wrapper around the C `struct
rq_list`. This type provides methods to iterate over and manipulate
lists of block requests, which is needed for implementing the
`queue_rqs` callback.

The abstraction includes methods for popping requests from the list,
checking if the list is empty, and peeking at the head request.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/helpers/blk.c                   |  26 ++++++++
 rust/kernel/block/mq.rs              |   2 +
 rust/kernel/block/mq/request_list.rs | 113 +++++++++++++++++++++++++++++++++++
 3 files changed, 141 insertions(+)

diff --git a/rust/helpers/blk.c b/rust/helpers/blk.c
index 91b72131a04cd..0db567dfc5d53 100644
--- a/rust/helpers/blk.c
+++ b/rust/helpers/blk.c
@@ -27,3 +27,29 @@ bool rust_helper_blk_mq_add_to_batch(struct request *req,
 {
 	return blk_mq_add_to_batch(req, iob, is_error, complete);
 }
+
+__rust_helper struct request *rust_helper_rq_list_pop(struct rq_list *rl)
+{
+	return rq_list_pop(rl);
+}
+
+__rust_helper int rust_helper_rq_list_empty(const struct rq_list *rl)
+{
+	return rq_list_empty(rl);
+}
+
+__rust_helper void rust_helper_rq_list_add_tail(struct rq_list *rl,
+						struct request *rq)
+{
+	rq_list_add_tail(rl, rq);
+}
+
+__rust_helper void rust_helper_rq_list_init(struct rq_list *rl)
+{
+	rq_list_init(rl);
+}
+
+__rust_helper struct request *rust_helper_rq_list_peek(struct rq_list *rl)
+{
+	return rq_list_peek(rl);
+}
diff --git a/rust/kernel/block/mq.rs b/rust/kernel/block/mq.rs
index b36112f7b22b9..786c32f2cb56c 100644
--- a/rust/kernel/block/mq.rs
+++ b/rust/kernel/block/mq.rs
@@ -129,6 +129,7 @@
 pub mod gen_disk;
 mod operations;
 mod request;
+mod request_list;
 mod request_queue;
 pub mod tag_set;
 
@@ -141,6 +142,7 @@
 pub use request::IdleRequest;
 pub use request::Request;
 pub use request::RequestTimerHandle;
+pub use request_list::RequestList;
 pub use request_queue::RequestQueue;
 pub use tag_set::QueueType;
 pub use tag_set::TagSet;
diff --git a/rust/kernel/block/mq/request_list.rs b/rust/kernel/block/mq/request_list.rs
new file mode 100644
index 0000000000000..60284d9ef6c9c
--- /dev/null
+++ b/rust/kernel/block/mq/request_list.rs
@@ -0,0 +1,113 @@
+// SPDX-License-Identifier: GPL-2.0
+
+use core::marker::PhantomData;
+
+use crate::{owned::Owned, types::Opaque};
+
+use super::{IdleRequest, Operations};
+
+/// A list of [`Request`].
+///
+/// # INVARIANTS
+///
+/// - `self.inner` is always a valid list, meaning the `next` and `prev`
+///   pointers point to valid requests, or are both null.
+/// - All requests in the list are valid for use as `IdleRequest<T>`.
+#[repr(transparent)]
+pub struct RequestList<T: Operations> {
+    inner: Opaque<bindings::rq_list>,
+    _p: PhantomData<T>,
+}
+
+impl<T: Operations> RequestList<T> {
+    /// Create a new [`RequestList`].
+    pub fn new() -> Self {
+        let this = Self {
+            inner: Opaque::zeroed(),
+            _p: PhantomData,
+        };
+
+        // NOTE: We are actually good to go, but we call the C initializer for forward
+        // compatibility.
+        // SAFETY: `this.inner` is a valid allocation for use as `bindings::rq_list!.
+        unsafe { bindings::rq_list_init(this.inner.get()) }
+
+        //INVARIANT: `self.inner` was initialized above and is empty.
+        this
+    }
+
+    /// Create a mutable reference to a [`RequestList`] from a raw pointer.
+    ///
+    /// # SAFETY
+    /// - The list pointed to by `ptr` must satisfy the invariants of `Self`.
+    /// - The list pointed to by `ptr` must remain valid for use as a mutable reference for the
+    ///   duration of `'a`.
+    pub unsafe fn from_raw<'a>(ptr: *mut bindings::rq_list) -> &'a mut Self {
+        // SAFETY:
+        // - RequestList is transparent.
+        // - By function safety requirements, `ptr` is valid for us as a mutable reference.
+        unsafe { &mut (*ptr.cast()) }
+    }
+
+    /// Check if the list is empty.
+    pub fn empty(&self) -> bool {
+        // SAFETY: By type invariant, self.inner is valid.
+        let ret = unsafe { bindings::rq_list_empty(self.inner.get()) };
+        ret != 0
+    }
+
+    /// Pop a request from the list.
+    ///
+    /// Returns [`None`] if the list is empty.
+    pub fn pop(&mut self) -> Option<Owned<IdleRequest<T>>> {
+        // SAFETY: By type invariant `self.inner` is a valid list.
+        let ptr = unsafe { bindings::rq_list_pop(self.inner.get()) };
+
+        if !ptr.is_null() {
+            // SAFETY: If `rq_list_pop` returns a non-null pointer, it points to a valid request. By
+            // type invariant all requests in this list are valid for use as `IdleRequest`.
+            Some(unsafe { IdleRequest::from_raw(ptr) })
+        } else {
+            None
+        }
+    }
+
+    /// Push a request on the tail of the list.
+    pub fn push_tail(&mut self, rq: Owned<IdleRequest<T>>) {
+        let ptr = rq.as_raw();
+        core::mem::forget(rq);
+        // INVARIANT: rq is an `IdleRequest<T>`.
+        // SAFETY: By type invariant, `self.inner` is a valid list.
+        unsafe { bindings::rq_list_add_tail(self.inner.get(), ptr) };
+    }
+
+    /// Peek at the head of the list.
+    ///
+    /// Returns a null pointer if the list is empty.
+    pub fn peek_raw(&self) -> *mut bindings::request {
+        // SAFETY: By type invariant, `self.inner` is a valid list.
+        unsafe { bindings::rq_list_peek(self.inner.get()) }
+    }
+}
+
+impl<T: Operations> Default for RequestList<T> {
+    fn default() -> Self {
+        Self::new()
+    }
+}
+
+impl<T: Operations> Drop for RequestList<T> {
+    fn drop(&mut self) {
+        while let Some(rq) = self.pop() {
+            drop(rq)
+        }
+    }
+}
+
+impl<T: Operations> Iterator for &mut RequestList<T> {
+    type Item = Owned<IdleRequest<T>>;
+
+    fn next(&mut self) -> Option<Self::Item> {
+        self.pop()
+    }
+}

-- 
2.51.2



