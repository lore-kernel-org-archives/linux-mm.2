Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C42C8CD8CAD
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:13:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D3466B00D0; Tue,  9 Jun 2026 15:13:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AB0C6B00D1; Tue,  9 Jun 2026 15:13:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C1316B00D2; Tue,  9 Jun 2026 15:13:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1D2946B00D0
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:13:36 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DC04B140704
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:13:35 +0000 (UTC)
X-FDA: 84861323190.15.F9588B5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 24F12A0015
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:13:33 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XG+ezTAn;
	spf=pass (imf25.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781032414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MQiHlNRAHcG0zCplCfubwH1heBFHeJMR1Ghfy65SyHo=;
	b=3yZG00aD3WOmuallQf72jg3Bed9aeGMCNkCJWC+yChGfZObIKzxIQ44O0xvF3jIWUpOK9C
	Rh8y+36Pm0TcWZ1rMM8tJP1fuM1q0ckwKspQB6Ip3935rFL/vw/KFpJPiU1puH4tWAegwh
	lcGetjjj9tWbOM5z7QWzRSBENC5Z01s=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XG+ezTAn;
	spf=pass (imf25.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781032414;
	b=KI6YPr5N71dckN03AP96J8sXOngcZphWqO1W9bmQ5qLxDee0r9m/0WjqPF0tVpWTetdNOg
	a0gNXRFKdG/alf+Bk4arAPSra70jQgpxVC7fMfQ2VZmFmeU7YSLTSgxuqAtPBWXZEKOqD3
	WeMPsNGpyQQXlPl6NPPJPfWhSqJwncU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B2F6C602CE;
	Tue,  9 Jun 2026 19:13:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3767A1F00893;
	Tue,  9 Jun 2026 19:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781032413;
	bh=MQiHlNRAHcG0zCplCfubwH1heBFHeJMR1Ghfy65SyHo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=XG+ezTAn3i1xqHdZPtdFpCrSiMPocPWl4XuHVxwbumaNYCNa7ClDAIbBNh5b2lukE
	 misM/dXVckb5it86sWzB5ZkLc1PL+RWzMTweV01gvsSZS+q4jteYytyzA+i+pqRXsx
	 Tf0gjOwSp52RvKmCY+jaFJtXIToGzapEcixnTv1RbYIRIoEq2vAx+L20z85Qr/n15a
	 iIgy1waClKBNfPxwKazUMxsvlrexnBAL4byc9fhhLND8oE/V+i0DEqfQaVkTgYqdA4
	 BrQMNEi4z8izlVAE2/HEDB3oRSZrTpSn36RPtcad5hLtXw8UDinfZErDAsW8OJjrwf
	 mfa7UOUgqakpw==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 09 Jun 2026 21:08:12 +0200
Subject: [PATCH v2 33/83] block: rust: add `TagSet` private data support
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-rnull-v6-19-rc5-send-v2-33-82c7404542e2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5734; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=3g5+YHpLQZtUQxpZtQ2/w4vImmZD3/qhcfuMUlvuqQc=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqKGTSdtbD1l7vP9EyaG6jBiQ3jFqAW4K54QXX3
 hnEnGAciQqJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaihk0gAKCRD6UCkIqsW9
 0HJED/9N+0BqKQHS/fK1I2gbsYIMS8fTYQC9/oy1w2ldDx6XoxRqHv68II+u+A84sakszQZjrry
 nUk3j7FAqdeCks7LeDrW2U/w/cjCJVqJPU4uXR60K4xowPGgdiWvSBpjUw7+Zr8G5A+gjNbhoFR
 BNpthODIrjQsn4+AYmz8T1Az7y4r6jEQs7mKAjpHB2kaRIbEEy8Prxg4Yz91bDAzWD3K3A6XsW4
 +v3i+KskX2LGXBrdsTu51JDJ1vGhAXDS7XGUocRvpYmFzjUAGyUynZebFu9Bn5sMQQshgWtY0Bi
 CUE/+WvRAcMljkDv/ha8LtcMNgbECjUhzwEMYB/WcWAJ7em+2PW5bUSQVflvoLJD86cOH9xe/Kf
 4d491j0ovtSQ3eq7qp7/9i2qakGwACVppYf//cg68DAi+438MqhvsehwTzCo6B+oqRkS1QW63YW
 GK88ffUCkNnuEfZwlKVZbPY1wfRT5mSXvXqe1D2+b9ohflfK/QxjfenRsSgSlWYv+9Xrr86K0Oh
 vP73viiPWDBIfq56mCsGfJx/rKR0h8KVcJJbwyjb7M4jBBr1eEF4GFYB5NpIx1hjsjG0iUvPWLC
 c326mxqiqd6Rvk5LIUzUH5odg8ocrT79Vwe68mcQ2VYrJgBMs0YVPlkRKVnP7QKNIjvugXz0gLR
 0LRZdzS1Ak40/oQ==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Queue-Id: 24F12A0015
X-Stat-Signature: w3ndne84y1c5bqdxpbs3g3zhjzzugoty
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781032413-436951
X-HE-Meta: U2FsdGVkX18i5ikLfGzSewsGRv7u8cBHWLSl2wGzYavStj0pCVUiS0Y5BAnvJsvSsaxGc+JGLVLCSOJTHWl1TBaW53pmiX4Re0rNvvCBYWJ9D7Xxgu3koeEhHDAGZhvM73MGzrWiSC4kpfTgf4OPBvxhflUuWlPYZOflBrwNs6jOoX42OV9zrFURTiAxCmn1z9Nt1GngQ2DBvMbd5snSVJjkAjzFVoalCIQPjnzIujy2eshZwgL/0GNSzu9we5jjCHgvIO0WkXRSZs+geT/VKM7JFgfTxE8LK4TnqCqFtm/bN+eEwoutlnCAntUu8sI6LssbJuBYnshglB4ax6dyid2HDpX4eTBV+aDLIM63lqEWZukSs9F6+fN03YMqO3mf7tXhn97KX2rFmmN4fkVzsAm12IeB/TOGqrakJsgRhYZVu9qk6pP05JD6NNjWwl1s1RfDmmWj2umfVPaMfPxTJIfYrHDio+liAXpycKUBPcy8crmqU4x0okCp8VB6i6RJW2XhfOWGz/BQj3+8J+N4+bJu/FcAG8iyIg5jV9P1oUjLFrM0+rkQ3kpq40eK5Sz/Nwr6JDmKz5g//Lzh09JZLwOKiguAx++G5GLDQugx/c7k3cArP1/VsBXifrqp0jHGFwSQACVRxO7ShgRCYK5Vbnz9gc5b3atFpeIZyJaw3dKwWmgqwoJPb0UQ+VBMyr1LmQuFVKrsADIgSdOndEo5LpyjvW+UKRIqpC2biGP3wbKX11UFootb/ysgyMFCO0P5wdxsC4yqa7K/xExkq0n6Fqia8mX9rchfsgFEVVDC49Qrs9dAhBUUkZNFePE0rfMHYZYrCt5XsYtGffRZ+64bsaotn4SIH+HXH71DGhDZOzKwWaCNzJyLzFwf7xz+GMr7AYkC0P5ldsN9R6od8dhg5akRS1453PLPBAByLXrUHUPUPEcagMewKpXX6qqJwzeVuy1o2Xx3uULfJxNZ47h
 9Es7a/EN
 8mjmttfj8baewd8BFxtY1NNEOPAXnQf2LfJN+xwtcuaSBCDbkbW1JOvSSF7524EfZYG7KUFnTOH2UnAqd7zV5Q8YSa8fFzm9nSjXan8eQKMBmco6EL1m7bqEVqb2q8GfpRcZ0k5jQ8d/TTA3Pv3MEXPoohZeKENhVk4ZYXiop0WT7jN+fipEMBX5OinzZnmUQ1fuGFLfbIMOqzYYpWa6OBLs8dajotWYIJed1lEootdg5TfXnydf8735MwYQfF2ruCiodC8ugG96Zhr/mRmmxjD00hesvh8UGw26y/i6ZAL1KvtRcPkq+F7cvr9AWnZ81EQOEXpqA5K+fUN3n4gGYM1ZzJg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Andreas Hindborg <a.hindborg@samsung.com>

C block device drivers can attach private data to a `struct
blk_mq_tag_set`. Add support for this feature for Rust block device
drivers via the `Operations::TagSetData` associated type.

The private data is passed to `TagSet::new` and is stored in the
`driver_data` field of the underlying `struct blk_mq_tag_set`. It is
released when the `TagSet` is dropped.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 drivers/block/rnull/rnull.rs       |  3 ++-
 rust/kernel/block/mq.rs            |  6 ++++--
 rust/kernel/block/mq/operations.rs |  4 ++++
 rust/kernel/block/mq/tag_set.rs    | 26 ++++++++++++++++++++++----
 4 files changed, 32 insertions(+), 7 deletions(-)

diff --git a/drivers/block/rnull/rnull.rs b/drivers/block/rnull/rnull.rs
index be0b4bd25e53..ad26a4a8dbbe 100644
--- a/drivers/block/rnull/rnull.rs
+++ b/drivers/block/rnull/rnull.rs
@@ -240,7 +240,7 @@ fn new(options: NullBlkOptions<'_>) -> Result<GenDisk<Self>> {
         }
 
         let tagset = Arc::pin_init(
-            TagSet::new(submit_queues, 256, 1, numa_node, flags),
+            TagSet::new(submit_queues, (), 256, 1, numa_node, flags),
             GFP_KERNEL,
         )?;
 
@@ -533,6 +533,7 @@ fn align_down<T>(value: T, to: T) -> T
 impl Operations for NullBlkDevice {
     type QueueData = Pin<KBox<QueueData>>;
     type RequestData = Pdu;
+    type TagSetData = ();
 
     fn new_request_data() -> impl PinInit<Self::RequestData> {
         pin_init!(Pdu {
diff --git a/rust/kernel/block/mq.rs b/rust/kernel/block/mq.rs
index bac15b509d90..28cee0d60846 100644
--- a/rust/kernel/block/mq.rs
+++ b/rust/kernel/block/mq.rs
@@ -71,6 +71,7 @@
 //! impl Operations for MyBlkDevice {
 //!     type RequestData = ();
 //!     type QueueData = ();
+//!     type TagSetData = ();
 //!
 //!     fn new_request_data(
 //!     ) -> impl PinInit<()> {
@@ -94,8 +95,9 @@
 //!
 //! let tagset: Arc<TagSet<MyBlkDevice>> =
 //!     Arc::pin_init(
-//!         TagSet::new(1, 256, 1, NumaNode::NO_NODE, mq::tag_set::Flags::default()),
-//!         GFP_KERNEL)?;
+//!         TagSet::new(1, (), 256, 1, NumaNode::NO_NODE, mq::tag_set::Flags::default()),
+//!         GFP_KERNEL
+//!     )?;
 //! let mut disk = gen_disk::GenDiskBuilder::new()
 //!     .capacity_sectors(4096)
 //!     .build(fmt!("myblk"), tagset, ())?;
diff --git a/rust/kernel/block/mq/operations.rs b/rust/kernel/block/mq/operations.rs
index c49ca2e8bbb2..093bb21fa1b2 100644
--- a/rust/kernel/block/mq/operations.rs
+++ b/rust/kernel/block/mq/operations.rs
@@ -63,6 +63,10 @@ pub trait Operations: Sized {
     /// the `GenDisk` associated with this `Operations` implementation.
     type QueueData: ForeignOwnable + Sync;
 
+    /// Data associated with a `TagSet`. This is stored as a pointer in `struct
+    /// blk_mq_tag_set`.
+    type TagSetData: ForeignOwnable + Sync;
+
     /// Called by the kernel to get an initializer for a `Pin<&mut RequestData>`.
     fn new_request_data() -> impl PinInit<Self::RequestData>;
 
diff --git a/rust/kernel/block/mq/tag_set.rs b/rust/kernel/block/mq/tag_set.rs
index d6d104adf4aa..bfb8f8af4ee1 100644
--- a/rust/kernel/block/mq/tag_set.rs
+++ b/rust/kernel/block/mq/tag_set.rs
@@ -19,7 +19,10 @@
         Result, //
     },
     prelude::*,
-    types::Opaque,
+    types::{
+        ForeignOwnable,
+        Opaque, //
+    },
 };
 use core::{
     convert::TryInto,
@@ -56,6 +59,7 @@ impl<T: Operations> TagSet<T> {
     /// Try to create a new tag set
     pub fn new(
         nr_hw_queues: u32,
+        tagset_data: T::TagSetData,
         num_tags: u32,
         num_maps: u32,
         numa_node: NumaNode,
@@ -73,7 +77,7 @@ pub fn new(
                     queue_depth: num_tags,
                     cmd_size,
                     flags: flags.into(),
-                    driver_data: core::ptr::null_mut::<c_void>(),
+                    driver_data: tagset_data.into_foreign(),
                     nr_maps: num_maps,
                     ..tag_set
                 }
@@ -86,7 +90,14 @@ pub fn new(
                 // SAFETY: we do not move out of `tag_set`.
                 let tag_set: &mut Opaque<_> = unsafe { Pin::get_unchecked_mut(tag_set) };
                 // SAFETY: `tag_set` is a reference to an initialized `blk_mq_tag_set`.
-                error::to_result( unsafe { bindings::blk_mq_alloc_tag_set(tag_set.get())})
+                let status = error::to_result(
+                    unsafe { bindings::blk_mq_alloc_tag_set(tag_set.get())}
+                );
+                if status.is_err() {
+                    // SAFETY: We created `driver_data` above with `into_foreign`
+                    unsafe { T::TagSetData::from_foreign((*tag_set.get()).driver_data) };
+                }
+                status
             }),
             _p: PhantomData,
         })
@@ -102,7 +113,14 @@ pub(crate) fn raw_tag_set(&self) -> *mut bindings::blk_mq_tag_set {
 impl<T: Operations> PinnedDrop for TagSet<T> {
     fn drop(self: Pin<&mut Self>) {
         // SAFETY: By type invariant `inner` is valid and has been properly
-        // initialized during construction.
+        // initialised during construction.
+        let tagset_data = unsafe { (*self.inner.get()).driver_data };
+
+        // SAFETY: `inner` is valid and has been properly initialised during construction.
         unsafe { bindings::blk_mq_free_tag_set(self.inner.get()) };
+
+        // SAFETY: `tagset_data` was created by a call to
+        // `ForeignOwnable::into_foreign` in `TagSet::try_new()`
+        unsafe { T::TagSetData::from_foreign(tagset_data) };
     }
 }

-- 
2.51.2



