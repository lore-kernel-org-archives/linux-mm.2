Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EB7BCD8CB2
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:11:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 927356B00AA; Tue,  9 Jun 2026 15:11:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D7CE6B00AC; Tue,  9 Jun 2026 15:11:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7ED626B00AD; Tue,  9 Jun 2026 15:11:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6B5836B00AA
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:11:39 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2A12090B7C
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:11:39 +0000 (UTC)
X-FDA: 84861318318.14.A6F4268
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 505F4100015
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:11:37 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c1cG7zd1;
	spf=pass (imf14.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781032297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BNgt6NEUNStjnj6HIxW0BxY2rf9f+JxrNGSNIXiRUfI=;
	b=4qgrOCAn5aG/CnQCMK5YEsA3n+vNRVC0OyBdb6Zm/6BCXXt9LR/gtbWEBeJ/jM4KwVX1O1
	+uQX0gxaFWLfjaBCU+ZwRBllxqfk6wNUWywY3JBWOGqJm8lxZjr3cO6p8L22L+XLZzqlDZ
	hp0EeqQOcPrk86vKVevaefplbCmLyZ8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c1cG7zd1;
	spf=pass (imf14.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781032297;
	b=E5YOd6v0N4DqxmwHQKQ/H5kS9EZKoDGZOKiPsXzR9Q0zuych7XCPXjyYrBdBKDwfICO/6c
	eyR8QTD7msU98cB8ioSDqcmrl7b2+fxfGwUaFiIyVYmAnFJ9ocQkrhjqJmRYu0uUfFZCd9
	8p83KNUlmMJQalepOo5uSNpS6aKS+rQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DAD83602D0;
	Tue,  9 Jun 2026 19:11:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4FF81F00898;
	Tue,  9 Jun 2026 19:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781032296;
	bh=BNgt6NEUNStjnj6HIxW0BxY2rf9f+JxrNGSNIXiRUfI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=c1cG7zd10jQTjOFbyKBTS2Xr3GepDjhaSf9h61vP7FI4V27AfuIdSci/J2vDfc43d
	 LlMbXoI+wLxIyLsvITXIf+mrwQ/jNL7Bis+MyUnkchyKZN9s0ROJ2UvDDUz9aM6VI2
	 jtCkgsT0uoPPQLQKux0+VR6hSWH0feyU4mhX1FAuuqTQK4KHANY+LNkj2bn1EHfw2K
	 jjtpjuncCJG3tGpCzvURJp5b3bhujvNbnPe5nVsUv8yQKuFebRPVRfa4e3nbDt45bn
	 8ZH/C8lu1W1wXyKs95rG4JXc5Qu3hE6IX81Mx0YVB4lZ59sP+dMhKzHblGbDTV+T29
	 TpprcYZGMcQIg==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 09 Jun 2026 21:08:34 +0200
Subject: [PATCH v2 55/83] block: rust: add an abstraction for `struct
 blk_mq_queue_map`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-rnull-v6-19-rc5-send-v2-55-82c7404542e2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=6865; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=ektQL/aHChpH2COAEoc+T67ae92mSUZiOEMhrybycnM=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqKGTmL3Mfx97RHoZzsqxrmDoBER68EUD3nOm+m
 V2jwyRIXWuJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaihk5gAKCRD6UCkIqsW9
 0EZUD/9krINdRjcBpOaNIsActzD16iPZ7v0RNTmF0EsM7APNv3HU7Y34DmFAgNgTNTi7pfqHtH5
 jZrv7s9P49bzKoloCxFs3RAa8r5ThTj1q7gwGhUpn9gGLhTaC87KeIG6WOsu2UfBlBahhNW+GeP
 6FPTO6sN1gqjVHRruzT9TSUmdc47nJX2B73Wr0CVMoaBngH/9YdAd7dWKvRP7eOaPIq2DeTxPkC
 DXfg7LUSpCfIFYR3rBrOHFuegLl1ge6gqqFmMcqrwzclI1Th9LOnYMmaXVI16UPawAfcs7114de
 2XHhzORXqAq1eN0ADdsx3RRM6IYZUONy9I6bTPgyIStvg5Ole1myIqQ0wPmHDnxH2Ps5RJ9IMze
 ejuJ8QplYt7AI433kAmjy3AW4VcNjK4aPsk8QuLK37XXyn+QfhvGSjlfuZrrR5FrkAkh8MgNdLr
 lfjm79kMoynNJmT/y+5W1rtiawpty4qYkWTgPg7lRJIma3Eejn0K7khxTtOp49Gj7/4fhDUqeZ7
 btwxisYW+0u87V9ULrCbRoLLNPu/2D1TvvtN4EXv3CrNOltcV/RnY2zxepVyNNfpMe6KA9QYZ+2
 koiWqsTAp9qZtFA6GNn+1lexur+ODHeGeF3dmIA43bq/hRNdQDK9BfL1IaPrPWPs2cPJrB3QUYJ
 WDh/LwnMojBKxCg==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 505F4100015
X-Stat-Signature: rhfd35xbi3rgeach3hy73biuzeyikqjw
X-Rspam-User: 
X-HE-Tag: 1781032297-830318
X-HE-Meta: U2FsdGVkX19q2E5KNr/9IxU2Rel+kLvp4kQzXnOg7LI9CfmG72crLnLbtm968IghEsg8KpgZgaCNA45w+rEzZPY+B2d+hzwuRp1VZy52U8qjkOOrQrTefzPDe3yhcmLcy3YiWvUdZ6hRGPXO257eCdXc5evfK22UlCXi+CrROJK3WUBqLj96G58G5DyXbq/3QvG8b87dG8/5k6pgw6zL2k63OeURk/BdDPYNnaucm3htjVO3NQz4A4VI5bNo90RQNujizk/I3YC7/bm8akuj0+dr+v83Ahv14QfJIueZIcKOXJJ+nQ1zTaOaQnqNAh6OPpIX4V7XqBKeKzS7wzfIblAsb4S2K/zWEdyI3EqpLYp00++uyG3FHWvRCg33VXCPA0cS7qHwSJi1n+M3rz8/5JV0ZhK5DdT+caKjUaWW7F1Mro3/2j9YJDvHedk9dyOLMx3qK05lsufnNN5GDooMKW/8DT93dSSf3uUq3XjxzdQZul7Q3ralpk6bhY0j3GDI74AL/7YpayAHnoxJBT509sR7F+gy6oaqzezZipsj4qvQCzqhZA5H8muhTAAJFGJKpNgZuFCFkwnaErwH1YryxDR6tfJ7mjx9MG8ljbYOm+Ybgm2T9YWu7Ihb6rS6vlIt8yzuZpkP1bzpDa3E5HRlO8Pz2zq4BQh1W/KLeitn0uScLsBUbeLOeK6BKoeKlCUMXYJNKDUuMxIrrRPY9PmssK6ZKUYwKhibJDWST7V6qEGwJSJU7KK5C52OPGd4ZaA/SLs8R464JGnjrvhS0ef1Rr8VM7Qb/nYdB09VplgbDNe+8BFVlYHpfuGOJurNfhWLfYneeMkgUwJnBQ9XuOiFVk0/ygeDlwKBxzQYuqtsdMJcFsOLfJ3RYcqzf8zleZvf9sh4CDzsZoVz/xdArb3+j05fX6tZK2DgUt73qtTdqN2Ad6HR09NtMPlMkYS50YEYTfZLKg6uVbO4wTQt/gT
 Rq7hv6lI
 HDKWUw3ztK36+42cY69+y71tlpjxUU7DyUmMpNQ44KeyTAj2Rr7qwIjN4LS0HhUapE7pYq7VWVW/2vOwozi2F0bcjueabtsubO/TIkkYYt3wmQPA39TrggMbMbUZR6V1lxQ8UHXyQOj7XSWESJ9N++o7Y3jOenmX4gH/VZ3Pvd5orSZQyneUZjhPbW5OUt8yRWEM7WxijzjhiTzUympydRzhR7U6O53+Jvybe07VgbUj7r7seqhbUfARUAymtJBXcezc6OGV1du5B2NmphNubcnU4oXc7aP1q1W2hyucP9ozpnoW2bsz5Isrsk4OIaQGke5djSv1Npk5dAYC8ZuTbw7PafJfg8XKgIdfISbfP8g/4jLs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the `QueueMap` and `QueueType` types as Rust abstractions for CPU
to hardware queue mappings. The `QueueMap` type wraps `struct
blk_mq_queue_map` and provides methods to set up the mapping between
CPUs and hardware queues.

`QueueType` represents the different queue types: default, read, and
poll queues.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/block/mq.rs            |  5 +-
 rust/kernel/block/mq/operations.rs | 10 ++--
 rust/kernel/block/mq/tag_set.rs    | 96 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 105 insertions(+), 6 deletions(-)

diff --git a/rust/kernel/block/mq.rs b/rust/kernel/block/mq.rs
index 5bf2cf2736a5..e9bea19d684b 100644
--- a/rust/kernel/block/mq.rs
+++ b/rust/kernel/block/mq.rs
@@ -138,4 +138,7 @@
     RequestTimerHandle, //
 };
 pub use request_queue::RequestQueue;
-pub use tag_set::TagSet;
+pub use tag_set::{
+    QueueType,
+    TagSet, //
+};
diff --git a/rust/kernel/block/mq/operations.rs b/rust/kernel/block/mq/operations.rs
index 8a418bf0f3ba..06faf5647aaa 100644
--- a/rust/kernel/block/mq/operations.rs
+++ b/rust/kernel/block/mq/operations.rs
@@ -128,8 +128,8 @@ fn report_zones(
         Err(ENOTSUPP)
     }
 
-    /// Called by the kernel to map submission queues to CPU cores.
-    fn map_queues(_tag_set: &TagSet<Self>) {
+    /// Called by the kernel to map hardware queues to CPU cores.
+    fn map_queues(_tag_set: Pin<&mut TagSet<Self>>) {
         build_error!(crate::error::VTABLE_DEFAULT_ERROR)
     }
 }
@@ -433,9 +433,9 @@ impl<T: Operations> OperationsVTable<T> {
     /// must be a pointer to a valid and initialized `TagSet<T>`. The pointee
     /// must be valid for use as a reference at least the duration of this call.
     unsafe extern "C" fn map_queues_callback(tag_set: *mut bindings::blk_mq_tag_set) {
-        // SAFETY: The safety requirements of this function satiesfies the
-        // requirements of `TagSet::from_ptr`.
-        let tag_set = unsafe { TagSet::from_ptr(tag_set) };
+        // SAFETY: By C API contract `tag_set` is the tag set registered with the `GenDisk` created
+        // by `GenDiskBuilder`.
+        let tag_set = unsafe { TagSet::from_ptr_mut(tag_set) };
         T::map_queues(tag_set);
     }
 
diff --git a/rust/kernel/block/mq/tag_set.rs b/rust/kernel/block/mq/tag_set.rs
index d3e93ad98b6e..e62dfd267fd9 100644
--- a/rust/kernel/block/mq/tag_set.rs
+++ b/rust/kernel/block/mq/tag_set.rs
@@ -124,11 +124,46 @@ pub fn flags(&self) -> Flags {
     /// `ptr` must be a pointer to a valid and initialized `TagSet<T>`. There
     /// may be no other mutable references to the tag set. The pointee must be
     /// live and valid at least for the duration of the returned lifetime `'a`.
+    #[expect(dead_code)]
     pub(crate) unsafe fn from_ptr<'a>(ptr: *mut bindings::blk_mq_tag_set) -> &'a Self {
         // SAFETY: By the safety requirements of this function, `ptr` is valid
         // for use as a reference for the duration of `'a`.
         unsafe { &*(ptr.cast::<Self>()) }
     }
+
+    /// Create a `TagSet<T>` from a raw pointer.
+    ///
+    /// # Safety
+    ///
+    /// `ptr` must be a pointer to a valid and initialized `TagSet<T>`. There
+    /// may be no other mutable references to the tag set. The pointee must be
+    /// live and valid at least for the duration of the returned lifetime `'a`.
+    pub(crate) unsafe fn from_ptr_mut<'a>(ptr: *mut bindings::blk_mq_tag_set) -> Pin<&'a mut Self> {
+        // SAFETY: By function safety requirements, `ptr` is valid for use as a mutable reference.
+        let mref = unsafe { &mut *(ptr.cast::<Self>()) };
+
+        // SAFETY: We never move out of `mref`.
+        unsafe { Pin::new_unchecked(mref) }
+    }
+
+    /// Helper function to invoke a closure each hardware queue type supported.
+    ///
+    /// This function invokes `cb` for each variant of [`QueueType`] that this [`TagSet`] supports.
+    /// This is helpful for setting up CPU to hardware queue maps in the [`Operations::map_queues`]
+    /// callback.
+    pub fn update_maps(self: Pin<&mut Self>, mut cb: impl FnMut(QueueMap)) -> Result {
+        // SAFETY: By type invariant, `self.inner` is valid.
+        let nr_maps = unsafe { (*self.inner.get()).nr_maps };
+        for i in 0..nr_maps {
+            cb(QueueMap {
+                // SAFETY: By type invariant, `self.inner` is valid.
+                map: unsafe { &raw mut (*self.inner.get()).map[i as usize] },
+                kind: i.try_into()?,
+            });
+        }
+
+        Ok(())
+    }
 }
 
 #[pinned_drop]
@@ -164,3 +199,64 @@ unsafe impl<T> Send for TagSet<T>
     T::TagSetData: Send,
 {
 }
+
+/// A [`TagSet`] CPU to hardware queue mapping.
+///
+/// # Invariants
+///
+/// - `self.map` points to a valid `blk_mq_queue_map`
+pub struct QueueMap {
+    map: *mut bindings::blk_mq_queue_map,
+    kind: QueueType,
+}
+
+impl QueueMap {
+    /// Set the number of queues for this mapping kind.
+    pub fn set_queue_count(&mut self, nr_queues: u32) {
+        // SAFETY: By type invariant, `self.map` is valid.
+        unsafe { (*self.map).nr_queues = nr_queues }
+    }
+
+    /// First hardware queue to map this queue kind onto. Used by the PCIe NVMe driver to map each
+    /// hardware queue type ([`QueueType`]) onto a distinct set of hardware queues.
+    pub fn set_offset(&mut self, offset: u32) {
+        // SAFETY: By type invariant, `self.map` is valid.
+        unsafe { (*self.map).queue_offset = offset }
+    }
+
+    /// Effectuate the mapping described by [`Self`].
+    pub fn map_queues(&self) {
+        // SAFETY: By type invariant, `self.map` is valid.
+        unsafe { bindings::blk_mq_map_queues(self.map) }
+    }
+
+    /// Return the kind of this queue mapping.
+    pub fn kind(&self) -> QueueType {
+        self.kind
+    }
+}
+
+/// Type of hardware queue.
+#[derive(Copy, Clone, Debug, PartialEq, Eq)]
+#[repr(u32)]
+pub enum QueueType {
+    /// All I/O not otherwise accounted for.
+    Default = bindings::hctx_type_HCTX_TYPE_DEFAULT,
+    /// Just for READ I/O.
+    Read = bindings::hctx_type_HCTX_TYPE_READ,
+    ///  Polled I/O of any kind.
+    Poll = bindings::hctx_type_HCTX_TYPE_POLL,
+}
+
+impl TryFrom<u32> for QueueType {
+    type Error = kernel::error::Error;
+
+    fn try_from(value: u32) -> core::result::Result<Self, Self::Error> {
+        match value {
+            bindings::hctx_type_HCTX_TYPE_DEFAULT => Ok(QueueType::Default),
+            bindings::hctx_type_HCTX_TYPE_READ => Ok(QueueType::Read),
+            bindings::hctx_type_HCTX_TYPE_POLL => Ok(QueueType::Poll),
+            _ => Err(kernel::error::code::EINVAL),
+        }
+    }
+}

-- 
2.51.2



