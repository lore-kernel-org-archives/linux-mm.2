Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9693FCD8CAD
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:18:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 057646B012E; Tue,  9 Jun 2026 15:18:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02F4A6B0130; Tue,  9 Jun 2026 15:17:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E87F16B0131; Tue,  9 Jun 2026 15:17:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D89296B012E
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:17:59 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A18C21C2F83
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:17:59 +0000 (UTC)
X-FDA: 84861334278.18.992B31F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id D8C9A100009
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:17:57 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f6x+HKtj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781032677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qkLI2fdYByXyCgDm4iAAw5nvnTz6NbS2AU9RKI9kMBw=;
	b=nev5LDRhTLRBKQDY8Nv5RhnYPAiZYitZOuwk2cSfFaQiBu49yv7fzCZ1degCVN9NmQY1ZS
	Epqlt21fEZHmpW3ufJCFkyiTMxEfxwp43JmVxn+r1udYrK8feC1tA6Q96xh8e//mrJw+3m
	Rh/WOPE97raTkDsQusM6YPDbUwyrBCQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f6x+HKtj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781032677;
	b=LRk6U5UjhyFOEW0qU5I6DCSu7J34fvLo18HQMgeunKTG8ZLQk4H1UT//rJZtF87Wj6lhfa
	rVZNDvomL7JtWT/r+dpR7mHwp/pZXXghdJ3xOtJsVMpt/YMgsET2h+UO+r8x002Tj5lgqt
	Ynr8CZe9thViZED0kwR2ZlrWtwRmRuU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 63BAF602C4;
	Tue,  9 Jun 2026 19:17:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE2B81F00898;
	Tue,  9 Jun 2026 19:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781032677;
	bh=qkLI2fdYByXyCgDm4iAAw5nvnTz6NbS2AU9RKI9kMBw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=f6x+HKtjJQa//HVdP+jdTpzgQjMzAXX/8DUi4w8cMw/3BsbtWRGn6bd2e49kjJLr5
	 MCqb+PhjDxHazy6xuaIa+TQF0xQ5bPBUJQCwGH08tJ8HseG3ZXIZ5P7I4j+ILQPg7c
	 P77wIouKbJuIMS9bOJ9JRPVQ216+621pDd2wUQmBx9/wiZFhl0m1fc0gYsN0clMt8x
	 4tSiZAZp1nt/nGi1UAanZhW267SFA5ipsbZGlbhyEoBMuiT6tdDTBk+TBk42hpAuNA
	 GHqlY+n/YJbdj52UmMDovdi/cmva7RBh/7TR7syAiDLxJxugc9wUY2/WmV7OLRe98Y
	 LKRSWXqiSEXkA==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 09 Jun 2026 21:07:47 +0200
Subject: [PATCH v2 08/83] block: rust: add `Request` private data support
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-rnull-v6-19-rc5-send-v2-8-82c7404542e2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=9400; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=IAlWkCq69WO4onn9FqDheU5v7rVQqR0ixWrEuSku+Rs=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqKGS7NyFEmzZd5N67NuhGtgFIfmFZn7yqauVsq
 hBmYwRv/xuJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaihkuwAKCRD6UCkIqsW9
 0LPiD/9L2omkcWDTbakIiMk5Ihy3WJcxnZhFx+yd0Aw6J6PCE1tGLdx8egOh8hEmDqKO4LSpjCS
 HwuaOKBz1zq7J1wqo83FMDQ3ihDLZShdQ5bVAzZ+SDREyie0Tf7tln/nyMdZk84VykRn05tI3wY
 KtGWxuwh1LDwjPCzvbRUsNEfGfXt/izPMZsRj8CAx2F/R90al+BiQgPKBuPAMvoVpvxK5IHgH+4
 oVf7qrNw0SmhClSKn4UeYDhMjnj7eVm2zVVVhB+0z8zAuXZByKMdD5/wKkNZbotpEr60e7dXjAz
 bdT+b4dUlZ/TJNuXTzuI9kmXNd0iRwl7il8KPNwoX/wfeEyzoOUefYWsGhEnpzRSz6x8eYBWwdz
 RON96H7Z7Pza5TakQkhStQdmVkiMHGKSM7YSuuG2vHtvYHhf2zyKCRRptBcjlbKRNuPPlC8UDIC
 LT1VHlg2nlnTDQkugFTiLJYX9p+mqPdYKoWb5XD1P2kqA7YaZfDaM4W5vwwjw+XJLFN9DF3jrCg
 A+4vK44bZesXVrZUgG0GVrDly1Gg6+n/IKnZiE7UyImj8/RqxOk3SjbKRImkCIdjQGF9EKKb5BN
 BV+B0LxuV1V61KuZ1UC3Y0GgXktYCDk75RjGNw0oMXutl51YvoKIy5fkMYS1OdKoVpVMUvY+erF
 Z+yXmonrvVQnC0A==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D8C9A100009
X-Stat-Signature: kjyts5c8eef8qm36jww78ip957neprjk
X-HE-Tag: 1781032677-718091
X-HE-Meta: U2FsdGVkX180uYlpuJ14GTLLa64CdGqYs30BtIJoQgatmbsmWc91ON5MMQpATb0+GrzA6R6SADb7yF1j2Ui4WVBu4Y7RjojvB6+6B8l31w/ZboquNgJdL3S/wHWqIhwEEeDNcQiX0BX+qFQsSZsdsPfhtVVVnkXVt4C26oHo5ITzovOKH7Xe9Q6nptSi7ufgJq7XoGLxtwq7Mq6XqaD/tLyDSjF6EioovV/HMrZ53FOy5n4A7/DvJEaJUH9DLppXSYLhikdnvW45Clnu30JZkUQgVLOwpssSnj2kdk4csOFYxcOM3Fla+fA1FCL3FlJFW8ZhagUSleCo1lQAmmEpq/pqPaho60wPuwfOQM+IxRhZrk0+D/Jj5hgOvAPE5lbvVwJe3cgTKQ8bl5B9VBfxgcwqmucSDqJhtOvLh7tE7MpMxHDn0zVVkKymTEXEbBrXPsQ8ffVt5qKvEBxOCEo4qBoU4QnN0Ps1KU1U9/KXP6/DSp2tnytY4b/MNhUVzS6z6dr9QaDXi6SpYwiKpYk59Tyqtr1abUYYxaI2hqeoDqcPlracmAXf+Ip4RS2fmDi/qIHBOWPDGY0tlh7IuZoP6t6vpuQqLT5dG2HWGyPubIAU1Sdlt32euoNN2vxhThWCAKBo7yVaJIgsYHhU0OamH00guRhj3yoLw2DtBP3fOaAGMBoqnybtWrScrAn7vP6T1FizP/zN459sbICKF6isjn8rbDKENWyv6gqiUkd2QCcOUkTW+/BkP/YYy22jx4WBS3cypP2GXXlM5wHyRKy2UqP0F6yTszwCzAaHzJSBuiNcn9YK0dt6xtJy8gTIdcb1H/x+IiVDI9ZMDBOmypwXLkXKQAIgiR2NAn0k0TxODFKow2sZ1nqLVjgzMEEcoqqCQ1W36AqBQOORyKiats/b8Zs88hhST9sO32ZiNP7oCamPCXn2lmOsCBfBLWdANOxwY4P88l/0OHnG/JFrqOY
 zXQNXWO/
 IEvg12PEab1W/MJFW3B+os0+oWxJmjaa1DC1hiTUYCIibk6J/D/hWUVH5s2kHzYGUzlI59VD4Fh3rEfr+Uw792exqvONFr3F7hn2/c/1rjskH68nFk5DGMn1cgh7k98xUNUtGN/rGeblbLicTieL+fLoZFly6ZmhBKCExh7WyOdyX9rOMiJRU4Roeq0hZy/eAIWWKSz0Ro3a9MinZctU9EaAugfOipWEbJvhMbCiHDNOwpVKvpUK8rOIcVJmrTr41JyrqMbvH04ly/GKrTIVkN3VSOTm56XaocADsjpdmuBOOfcG4agQ84GOr7o7MV2z0zCVQvjBLbKA3+TWPSFi/DNy4pA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Andreas Hindborg <a.hindborg@samsung.com>

C block device drivers can attach private data to a `struct request`. This
data is stored next to the request structure and is part of the request
allocation set up during driver initialization.

Expose this private request data area to Rust block device drivers.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 drivers/block/rnull/rnull.rs       |  5 +++++
 rust/kernel/block/mq.rs            |  6 ++++++
 rust/kernel/block/mq/operations.rs | 26 +++++++++++++++++++++++++-
 rust/kernel/block/mq/request.rs    | 24 +++++++++++++++++++-----
 rust/kernel/block/mq/tag_set.rs    | 24 +++++++++++++++++++-----
 5 files changed, 74 insertions(+), 11 deletions(-)

diff --git a/drivers/block/rnull/rnull.rs b/drivers/block/rnull/rnull.rs
index 69cf62475446..dd7a30519870 100644
--- a/drivers/block/rnull/rnull.rs
+++ b/drivers/block/rnull/rnull.rs
@@ -132,6 +132,11 @@ struct QueueData {
 #[vtable]
 impl Operations for NullBlkDevice {
     type QueueData = KBox<QueueData>;
+    type RequestData = ();
+
+    fn new_request_data() -> impl PinInit<Self::RequestData> {
+        Ok(())
+    }
 
     #[inline(always)]
     fn queue_rq(queue_data: &QueueData, rq: Owned<mq::Request<Self>>, _is_last: bool) -> Result {
diff --git a/rust/kernel/block/mq.rs b/rust/kernel/block/mq.rs
index b8ecd69abe98..7718b106eb49 100644
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
+//!         Ok(())
+//!     }
+//!
 //!     fn queue_rq(_queue_data: (), rq: Owned<Request<Self>>, _is_last: bool) -> Result {
 //!         rq.end_ok();
 //!         Ok(())
diff --git a/rust/kernel/block/mq/operations.rs b/rust/kernel/block/mq/operations.rs
index bb23a32f3983..c49ca2e8bbb2 100644
--- a/rust/kernel/block/mq/operations.rs
+++ b/rust/kernel/block/mq/operations.rs
@@ -29,6 +29,7 @@
     marker::PhantomData,
     ptr::NonNull, //
 };
+use pin_init::PinInit;
 
 type ForeignBorrowed<'a, T> = <T as ForeignOwnable>::Borrowed<'a>;
 
@@ -44,10 +45,27 @@
 /// [module level documentation]: kernel::block::mq
 #[macros::vtable]
 pub trait Operations: Sized {
+    /// Data associated with a request. This data is located next to the request
+    /// structure.
+    ///
+    /// To be able to handle accessing this data from interrupt context, this
+    /// data must be `Sync`.
+    ///
+    /// Requests may be cleaned up by a thread different from the allocating thread, so
+    /// `RequestData` must be `Send`.
+    ///
+    /// The `RequestData` object is initialized when the requests are allocated
+    /// during queue initialization, and it is are dropped when the requests are
+    /// dropped during queue teardown.
+    type RequestData: Sized + Sync + Send;
+
     /// Data associated with the `struct request_queue` that is allocated for
     /// the `GenDisk` associated with this `Operations` implementation.
     type QueueData: ForeignOwnable + Sync;
 
+    /// Called by the kernel to get an initializer for a `Pin<&mut RequestData>`.
+    fn new_request_data() -> impl PinInit<Self::RequestData>;
+
     /// Called by the kernel to queue a request with the driver. If `is_last` is
     /// `false`, the driver is allowed to defer committing the request.
     fn queue_rq(
@@ -252,6 +270,12 @@ impl<T: Operations> OperationsVTable<T> {
             // it is valid for writes.
             unsafe { RequestDataWrapper::refcount_ptr(pdu.as_ptr()).write(Refcount::new(0)) };
 
+            let initializer = T::new_request_data();
+
+            // SAFETY: `pdu` is a valid pointer as established above. We do not touch `pdu` if
+            // `__pinned_init` returns an error. We promise not to move the pointee of `pdu`.
+            unsafe { initializer.__pinned_init(RequestDataWrapper::data_ptr(pdu.as_ptr()))? };
+
             Ok(0)
         })
     }
@@ -271,7 +295,7 @@ impl<T: Operations> OperationsVTable<T> {
     ) {
         // SAFETY: The tagset invariants guarantee that all requests are allocated with extra memory
         // for the request data.
-        let pdu = unsafe { bindings::blk_mq_rq_to_pdu(rq) }.cast::<RequestDataWrapper>();
+        let pdu = unsafe { bindings::blk_mq_rq_to_pdu(rq) }.cast::<RequestDataWrapper<T>>();
 
         // SAFETY: `pdu` is valid for read and write and is properly initialised.
         unsafe { core::ptr::drop_in_place(pdu) };
diff --git a/rust/kernel/block/mq/request.rs b/rust/kernel/block/mq/request.rs
index 7444de3c8522..1882d697dcf3 100644
--- a/rust/kernel/block/mq/request.rs
+++ b/rust/kernel/block/mq/request.rs
@@ -107,12 +107,12 @@ pub fn complete(this: ARef<Self>) {
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
@@ -120,7 +120,7 @@ pub(crate) unsafe fn wrapper_ptr(this: *mut Self) -> NonNull<RequestDataWrapper>
 
     /// Return a reference to the [`RequestDataWrapper`] stored in the private
     /// area of the request structure.
-    pub(crate) fn wrapper_ref(&self) -> &RequestDataWrapper {
+    pub(crate) fn wrapper_ref(&self) -> &RequestDataWrapper<T> {
         // SAFETY: By type invariant, `self.0` is a valid allocation. Further,
         // the private data associated with this request is initialized and
         // valid. The existence of `&self` guarantees that the private data is
@@ -132,16 +132,19 @@ pub(crate) fn wrapper_ref(&self) -> &RequestDataWrapper {
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
@@ -159,6 +162,17 @@ pub(crate) unsafe fn refcount_ptr(this: *mut Self) -> *mut Refcount {
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
index dae9df408a86..ec5cac48b83f 100644
--- a/rust/kernel/block/mq/tag_set.rs
+++ b/rust/kernel/block/mq/tag_set.rs
@@ -8,13 +8,27 @@
 
 use crate::{
     bindings,
-    block::mq::{operations::OperationsVTable, request::RequestDataWrapper, Operations},
-    error::{self, Result},
+    block::mq::{
+        operations::OperationsVTable,
+        request::RequestDataWrapper,
+        Operations, //
+    },
+    error::{
+        self,
+        Result, //
+    },
     prelude::try_pin_init,
     types::Opaque,
 };
-use core::{convert::TryInto, marker::PhantomData};
-use pin_init::{pin_data, pinned_drop, PinInit};
+use core::{
+    convert::TryInto,
+    marker::PhantomData, //
+};
+use pin_init::{
+    pin_data,
+    pinned_drop,
+    PinInit, //
+};
 
 /// A wrapper for the C `struct blk_mq_tag_set`.
 ///
@@ -39,7 +53,7 @@ pub fn new(
         num_maps: u32,
     ) -> impl PinInit<Self, error::Error> {
         let tag_set: bindings::blk_mq_tag_set = pin_init::zeroed();
-        let tag_set: Result<_> = core::mem::size_of::<RequestDataWrapper>()
+        let tag_set: Result<_> = size_of::<RequestDataWrapper<T>>()
             .try_into()
             .map(|cmd_size| {
                 bindings::blk_mq_tag_set {

-- 
2.51.2



