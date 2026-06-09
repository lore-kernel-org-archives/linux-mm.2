Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 942CACD8CAD
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:15:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02C9A6B00FB; Tue,  9 Jun 2026 15:15:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 004006B00FD; Tue,  9 Jun 2026 15:15:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5C4B6B00FE; Tue,  9 Jun 2026 15:15:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D4B996B00FB
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:15:29 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8FAC31A0762
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:15:29 +0000 (UTC)
X-FDA: 84861327978.27.7EC7343
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id C620220017
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:15:27 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KFB0bEyM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781032527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A7C6J/4qobSt2YJVzP9B516t3v7OvSeSUX63/tzsSD8=;
	b=TylihP8uvjV81Z0U1StQsd+ANtZrImFs6D+kN70gsRWGozLyKfuG7dZc1ts7ju6bn3GUmH
	/KPyb4tIonb8ZERin+wij0s7CUST+ycthRewe0aPaHqwwiZNA++8Hf6gXUpX0edEkH/6Hz
	wAv46dXykar5aLuJ2+uj5DtKQwKmwdY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KFB0bEyM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781032527;
	b=ViUwda1l0W7SUUjIlmbG8Vd04AxraRfLx31zEChS9IPNmGwEcPYmGLz6cV70tRVqONG/I/
	CPq20uN+0NN79I/3sJmjU5taPa9j5HpIyyDFRCIenwgsNtRdb2508p/Pz+3+7GToTxAOpU
	KLuou0LKC1rnruMTyFcXfp99Vg6bFnQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6713F602CC;
	Tue,  9 Jun 2026 19:15:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 599521F00898;
	Tue,  9 Jun 2026 19:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781032527;
	bh=A7C6J/4qobSt2YJVzP9B516t3v7OvSeSUX63/tzsSD8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=KFB0bEyMs7EiTXFSctBJyJparalcPcsZroXU0a4EB0GdEUSVJQ1jmm52IMGG/3Vi3
	 615Mi+9jnabtiCfiUIdE0HHvBQzXk+eVl2kDCU2Jn829Q13GPFbwUvRWMMoyHJFhNe
	 WBFpvGMDMX/B/MAXYHe0J6rqBAqeEfhflFt0xgQGtQPwTKI3MjMHBRkHA1TuvCgaLe
	 aH+c8py+8ZbIskQkBfi6q6HuI648MgN4TaNNmfpQW2E+kv+WZr/ic68NDKSYK0vCSX
	 3yMAWKPPy6efyPU+hAgNzcs2cy0w2F0NLB5WEeBa8IYgwMg5JgnD7AF17aA6rtp/cf
	 /1lND+VxKezog==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 09 Jun 2026 21:08:47 +0200
Subject: [PATCH v2 68/83] block: rust: add an abstraction for `struct
 rq_list`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-rnull-v6-19-rc5-send-v2-68-82c7404542e2@kernel.org>
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
 rust-for-linux@vger.kernel.org
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=6100; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=3zWHoh8lTGLJ6X5+DtdbMgAgdt2Ms+a+4ebccRKtMVI=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqKGTyrI+QXei6rTMP8iiiEZKr1484LBHMD95oG
 XNTJoWDgPKJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaihk8gAKCRD6UCkIqsW9
 0OPxD/9ibPYIYnDR73NPhBD6/PgXSyhfABFOOMxGgykL5SxPrfRMpIsel+KLRDMxOtTwfZgWPqm
 7x4eXk/w0qBS7J1T4uP1v997OT3s7wNqiANIuX6w4EjLVagJ4RIH5vG+KYhBRcB28QURFuvYNxN
 44u7vqyn29dU8ioYK6DSBn6xB3NQILfY0/W18UedMoGKU2AUmptQKhDOqAO5iy9VJUloWW0wZLe
 7nyeHWAix0ofNz46wCcan2obRujcatIVZx+V0+2E9VbiBlPc0C01r2ELIwXImeWG0MWoyAeFTPO
 LrZsuuMMITkKmD9Mdy4UsKtc/n7aFKgRVuRuUNqfh4tecyVBphzrmE3iETMC8PLo4BddR1MrDF9
 Cc06NF5KA1jiS9FM5FwCOrr99HLkOMNGfJCbiDgPPgvENDjTCdd5Iz7A5s2y9fCM6IUQ8ykUy7F
 bu0AOfVa3f+5Y8mrqunMsHHy5vEJDHjoGTvXeXcxBa0x/pjgmPWfrF6JQPQ+nDpsvUNn9GhczhO
 Weyrad1n73SqnseczMeKxYX08ZNWHG639XShzc+XdTlHq55IzqkojBqOo0gtCYRh/0h4RILIqys
 RgA1/8PhvFvL4e1N9lo2ifsQxargLpvuwK4YsnypCJ9HKZTXRapEGnZEhHX+7WTR5vFVqTz86rI
 kld1/DFJXWO1kXQ==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: fn9xuionsc3x8ebc5n4mbfkuxjsqq1on
X-Rspamd-Queue-Id: C620220017
X-HE-Tag: 1781032527-908995
X-HE-Meta: U2FsdGVkX186bTZ54+8z6XCS/MAWUgT2NoNhobrYwc7mYJ2xAI/+1iXctMPFSBrD5JJohpQ1AGdeFvanKKHFR9WwojLOhZ3HTvFV8wy3d3QziogU0Fzwkc+x6N82qviBxH7uE4iX6geq0rzjafQ8+MotIJMH0e72XLCRT4sc5mKDGvHVfyixREMp5JVLU5G877/TTPFf3cuk38h4lHLRdExDVsNdmM0onDv1/KPNyVYlI8ZBmffzHzTzVKoBBuaf6+ROqjQkpDcPJUPbbqmoSspOwkkoNtl1XbA1cK9cN93etPiSp9XAMoY0Mc20vaDA2ar9Dyo+5ruM+1HWoVWqBNYRZziH7nb9smSUzLxNN15Y9f/LrRjkQuHkSQ8W7D+XmfurcL/QosLAH6bai7KAE5jSs3k39e9S/koTVFmJ1roHQvvGPKNUZTRf+TaTk/nKDP54Jcnd2tqo9LTT23AW7zpp7FKNjiOOmsi/7aLEvr5exBEuFiCA9Tlhr9LJQw8vqrolW/mPB8muz7nVITDItKXDwzyZoMMASarn/HvgZ3qBgU6giF7mOhybSLlSuBPZ2SH7y/o7c4GCU788915bRdVXmtS0LLCCUOgQT48yYYH8b/xOT06zrLrt0UU+FxPKrwSdBNtXSuJ2ZPVOWw6Mna+mlwr8cRNp8lJKCIlMXyQ3LCpJcn4UVZ22ZVePgzRLXK09lxyn+OXv9+fzRdbqAjW67S2hQ949Nhe2pIfIwnNGE53oj+CeWS0bPK7w4wmzgt6/0Wh0JEoDCAIruPMJDXRWaxOlAT37LyRuRKivDW0i2h0IfaHTRr/ZDHMAObybSETtt07C8NsxgpCFdDW6iKCLYm7tAPvccZHSN3rPumTVeXSgBHZ50Jt7kSx0fKTUSRO4evUiyM8iSXMXvnMq+lMaBEwMGM/44i5wdYgUvcB4PYEOheEs5wtL5G2341pi4mZrRQgNN23/k+Ww12S
 eHV/OFGJ
 i0e1CEdz4cuyI3E5X/W3rjuTIJWhXheIdc10X9+KpgfNqcKT+LUtMotKqhC1v0VWpkrFSXahaqCqFq7uO94XdtnhyBDMuMTQ5N3ONojTim8ebUfh4SAYesz6mkPvPYQPZnV/Bh6PdI5BKDntt0kQkw1PxEr/guv1IdxXavdUNsz+l+iuh2FUt/Wxh9406o8j8IbMA1NPVAvWehVdWUQXrucmf98B/jV7IqVmIXe2w+VBZU0rOl+8Ai/ooSis2Cu6dvJ5SaEDYVxvOELvYDAzb8+hZfFYfXKWDPs3c2+pkGH+F1VvHEBhgkplrgo53seij4OKyXeso/90DvL/dNFQiwmubSjVzNTUJ1uRwlj9SJ8+gGOEWYbpoSox9Jg==
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
 rust/kernel/block/mq/request_list.rs | 119 +++++++++++++++++++++++++++++++++++
 3 files changed, 147 insertions(+)

diff --git a/rust/helpers/blk.c b/rust/helpers/blk.c
index 500e3c6fd951..422289d617ae 100644
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
index 7c346be843e1..e8f0d03f2ff7 100644
--- a/rust/kernel/block/mq.rs
+++ b/rust/kernel/block/mq.rs
@@ -129,6 +129,7 @@
 pub mod gen_disk;
 mod operations;
 mod request;
+mod request_list;
 mod request_queue;
 pub mod tag_set;
 
@@ -148,6 +149,7 @@
     Request,
     RequestTimerHandle, //
 };
+pub use request_list::RequestList;
 pub use request_queue::RequestQueue;
 pub use tag_set::{
     QueueType,
diff --git a/rust/kernel/block/mq/request_list.rs b/rust/kernel/block/mq/request_list.rs
new file mode 100644
index 000000000000..82e6005126f7
--- /dev/null
+++ b/rust/kernel/block/mq/request_list.rs
@@ -0,0 +1,119 @@
+// SPDX-License-Identifier: GPL-2.0
+
+use core::marker::PhantomData;
+
+use crate::{
+    owned::Owned,
+    types::Opaque, //
+};
+
+use super::{
+    IdleRequest,
+    Operations, //
+};
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



