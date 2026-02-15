Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8346BE63F25
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 04:54:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53EBE6B009D; Sun, 15 Feb 2026 23:54:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C2616B009E; Sun, 15 Feb 2026 23:54:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3429D6B00A1; Sun, 15 Feb 2026 23:54:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C2BA26B009D
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:54:08 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CD6541CD94
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:44:53 +0000 (UTC)
X-FDA: 84448323666.12.4D47104
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2589980007
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:44:51 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q+2PSU7K;
	spf=pass (imf30.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771199092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BwRS3AAtEkRo1HBRa5i+kInlDNd6PzxfKOd8DEmM4Tw=;
	b=SOKXHbrea+pQVSra80YWlQ7FBxXMdE54vhhpuBUGZKxGe7rMxPY3soHcTkXCaKeXkAP5Qo
	+HVNJ0bIIYy9sbY9EeHSkqes7PAbUcqAXHv/wNIXiylrksFeIODRvlWqbaR+EADEIxFVY0
	YniJ0UXM1YVzH5o8WvvFqykaaikret8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q+2PSU7K;
	spf=pass (imf30.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771199092; a=rsa-sha256;
	cv=none;
	b=AbH17IlCEn4hHTsGedDa8b+xSxiJXTQyDk7V5QcuZSrzsfFYW+kEtFvTKkqTT0EuAiuf1L
	Slw0lPRO3xQOBVOb1csJZJl5KPNqRWD9TgK3rFMht5aHLOz7ey9q6+tgQbOZtokQ3jM6qz
	8ISyr34THI+K5YttZuf1eJLAm/dFRVE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A108F6013E;
	Sun, 15 Feb 2026 23:44:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E54BC4CEF7;
	Sun, 15 Feb 2026 23:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771199091;
	bh=KJozLO0lF2FpzqbaUJL2aSa4aBhSF0NKtk7cOClvuLI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Q+2PSU7KVK894R2Aztskm49ouQ07YfRkNT67DhLkNKw5XawmZyq6qySRtQpyy+saB
	 mVJCqCqdjTlB1y6P7X24Fu5LTd3da+95pdHalXDcprdYiTnIvLj5J/wxd8ekT5Ai5J
	 Wkjj9njcLJq4qDAQI+Fqc7ArOvP/CP44APlRwKETRtEI42nRovriFsRO1apokavlUs
	 Brt6wdP4c9BHfJ2wgp4LZXKhFO9fTadztmUrOIFg8FRrzweKW0Kn7rc4K6MmS84EaS
	 oKY3LNB4d5MPiSiqKEoWDT0oqp0SqaVrdyzpxexuhFsW7vuKq/n+4QLSpC+rfJZMVl
	 VFlIDixTWGJvA==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 16 Feb 2026 00:35:37 +0100
Subject: [PATCH 50/79] block: rust: add an abstraction for `struct
 blk_mq_queue_map`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-rnull-v6-19-rc5-send-v1-50-de9a7af4b469@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=7024; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=KJozLO0lF2FpzqbaUJL2aSa4aBhSF0NKtk7cOClvuLI=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpklhIw61luKCnzKfaISJJLxAq6+mHxPJwvpl1v
 iP3zQiPIySJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZJYSAAKCRDhuBo+eShj
 d26FD/4gfr3V2SAN/XvgmWVz1dCEbXu+WeUMPsAAH49GKVtWbtkIiO/6r31TsF16Sb536ocwLdH
 emuUJDlG0IWhGUn9Lz9qme/Hw7xd1SHBKuWDtnGXTbQA+8jva2+qeMC08WKSP0ygKCLVOPMfnjR
 Xbv4nOBDi7ElpZ+F6szkqSAPj3wz+fCy+TfpfB4WWZ2hzuoKkcn5Ei1lrvEysMSqg4AwP0VC8/s
 jTTrcisI392gezwBwij8jQ5Ji3VV+8NDAx4rNLM03hwnqzx7M+6T4rALLxTzW58HWlJjfijKF+G
 2+b+6BJn+Lfv3TAi1jWJvgidUL5xAE510CTbU0cSA6mUOvL/Ev2zVViOzI+qvENkta8PH3mAepe
 39OpQmA6i1/FKTsEITNCMz51/h8S6I/ua48TThZWl7F6GKVT6lVQj0nn5gZGM/sdfLPris2LhC9
 8VxcSXdoG9vr80uOhOLX3m57p78D70sxiEwpL7MrDBDNak7LU0OZxe/DJWvTkkDMmBsEUp2V478
 ZWfDU/N81fzpEWo0uvKPRGjIU12NYvlS7tIRVQwdSJUq2VWr8Lx6PJ2ZeWHSbyXJMcH4ACcoPLo
 8cWW1iXCBlTAEWGHLpiaU+L8M0k0LjLvPvRMKJDQW9xoxXvBIf8mfaAGGn8ZQ/cV77KB6TRL4sk
 PZfkxR9kYsQ6KXQ==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam11
X-Stat-Signature: js8z96hr8pew3xtb1hn1jnkjirkjbwwx
X-Rspam-User: 
X-Rspamd-Queue-Id: 2589980007
X-HE-Tag: 1771199091-210201
X-HE-Meta: U2FsdGVkX18tCNcaOOTF1k/e21mZRefaU3bbsp2t6KZLmRUp+j+O7VmLNLEegvmnXF7IKN8sNH4bEPmSuoW3SHK0+DGCE13DoiHyrQ3lVQdDJ4fMrRggDOHW1drZJJ5qD8vT975YIyCdsU0gYSdwNQfeTs/6GktbhlkkuXgDps16cfRFGAYIvRDes2HF97xGP9L0ZMTD9fBGZ3hyV7ZKKeCXgWgh+HRfWJz2N9iJoYVHBy06dA5l2Cfm/GcW29+Xj6Fy05AJtDmVm2WAtfmsBfqh3TeyVpD7lnSO+0Lznd5TBmzFJaFr3e/bKBzyg8/8MH62yJ02YSzFPi8n+P/VuqFH61B2VhmM0Z2BQqDv1oHJflyNFaMdnAa7OVBbkeDX39sowmj5p8aBH4lHEqCT5JCr5jmBsx03QgRAmnI9GMDnWzNDXrN+ipv8NXTc86HV4Bc7k7Qw8Wo+Pz7CPgAJPodxBymf2arjowHbH/si3mlhZ9BfczBbNkihqac3scQ6BvNu5co8V2aSLbC19H7upSpdPgpO0OKV1Ladn0cjlL+4j6uxT0EMtcFRztga/51tELILGUyBCbn5xqfbN7lgSQgaS+4sdiq/E6i4HlLvFMj1tyMaQ5e6fGyUN6v2b7V1KWRX0Wa9d/uySix3ueUN0oLDdbYYNUAM1rPzUYQkh5REcs7V8Ky0vOUgz+W1qxhuOzxfRdV2CjFHGg3DJRkssuaTTxwAu97mEtljl3MSEHP+grSB0G6IxEnkFWlRBH+5yVpVgsqDxmcZRGyzFFhfVzmW7UyS5Zco4gH5N30U219KoIeTOq/7tNJGfKyXc522NFOi3VUgxOfDG923tZl5V6rU+JSdcmuktONOaNs3xVTswB8mz7K1fZwRIO/T0y/DU9NSk8lTSAKIuLK0K6llpj7ZKmrSU57QMKCJYl5r1W7OR3wFEnwUYs7ZzvrZT0u/wd0jPJYJiQ2fXJ1bPYp
 eeNgqHH2
 J+Vb4R0jclhm1Z8VRLngnWAQp01q/mpK2G7fbbt/owgSn66m1zj0inMdXvHf05U/qaCww3S/zFxdFmYh5CCy8V8XS61UPMM3JDBLFdaVzAbHrRH+vph54sbnnub5wxAKvjmohq2NCAjnR19KR/lCn/sBe3UdVJ9jN5QZZLHCiL7bB8RcrufKHjtQJpNP3Og2lp3xixF2Xo6CFgEnTXaaK45QaQF68AY7SE2AhQBK16YcUapVyfYwk+H/vdH6JpPRSxYkfCpkVpjbMo3+uVzgfV98QgEv7+ag07/4F7IKS6E7joTw6b2V0myZtLGgp6YN/JKf7614USyQaB4T8Ls+faHd9ufl+mB0YzD7/MflFUWz/B8Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
 rust/kernel/block/mq.rs            |  1 +
 rust/kernel/block/mq/operations.rs | 10 ++--
 rust/kernel/block/mq/tag_set.rs    | 96 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 102 insertions(+), 5 deletions(-)

diff --git a/rust/kernel/block/mq.rs b/rust/kernel/block/mq.rs
index 057a5f366be3a..cd0bfbcbf317a 100644
--- a/rust/kernel/block/mq.rs
+++ b/rust/kernel/block/mq.rs
@@ -136,4 +136,5 @@
 pub use request::Request;
 pub use request::RequestTimerHandle;
 pub use request_queue::RequestQueue;
+pub use tag_set::QueueType;
 pub use tag_set::TagSet;
diff --git a/rust/kernel/block/mq/operations.rs b/rust/kernel/block/mq/operations.rs
index 017fad010d174..28dd4b28d203f 100644
--- a/rust/kernel/block/mq/operations.rs
+++ b/rust/kernel/block/mq/operations.rs
@@ -102,8 +102,8 @@ fn report_zones(
         Err(ENOTSUPP)
     }
 
-    /// Called by the kernel to map submission queues to CPU cores.
-    fn map_queues(_tag_set: &TagSet<Self>) {
+    /// Called by the kernel to map hardware queues to CPU cores.
+    fn map_queues(_tag_set: Pin<&mut TagSet<Self>>) {
         build_error!(crate::error::VTABLE_DEFAULT_ERROR)
     }
 }
@@ -408,9 +408,9 @@ impl<T: Operations> OperationsVTable<T> {
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
index 330ff28c91507..e6edc5bc39312 100644
--- a/rust/kernel/block/mq/tag_set.rs
+++ b/rust/kernel/block/mq/tag_set.rs
@@ -97,11 +97,46 @@ pub(crate) fn raw_tag_set(&self) -> *mut bindings::blk_mq_tag_set {
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
@@ -125,3 +160,64 @@ unsafe impl<T: Operations> Sync for TagSet<T> {}
 
 // SAFETY: It is safe to share references to `TagSet` across thread boundaries.
 unsafe impl<T: Operations> Send for TagSet<T> {}
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



