Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D36FDE81BCF
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 14:39:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 437BB6B00A4; Mon,  9 Feb 2026 09:39:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EEE86B00A5; Mon,  9 Feb 2026 09:39:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E4A36B00A6; Mon,  9 Feb 2026 09:39:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 197AD6B00A4
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 09:39:32 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DA6B6C075F
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:39:31 +0000 (UTC)
X-FDA: 84425176542.07.C02A12C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id F0DA614000D
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:39:29 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lCpPM2ND;
	spf=pass (imf23.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770647970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7D7Sxisqp2Djs5piGCNcYYVVx35/upvy9akEW+RtHCk=;
	b=Pdsuys4iQUutm0Aic0mK/dcRURNv13MSnB0MAJNNIWmMf9DE4hLcdCv+2zfDJDVYrZcXXD
	nH2VIgXa17EDrjgg4vYRnO1ESIprUX+et3iE7NFcYM89xE5/f/VL/BJd85iBJWhF4RLYKN
	Jsjrob1K3+pl5ywhS3gjuyGldCEOweg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lCpPM2ND;
	spf=pass (imf23.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770647970; a=rsa-sha256;
	cv=none;
	b=RLW5HkDlhO/b2CMJhjj6cZfejQLPFFqUuDSt8WdR2mXv3i6eDWdlqqLoss3VhJg8TW+a9q
	TsRWuw9j9sXKPO5QO+WjMgaBNL3998pAYMuGge67302Oc8ChOPNUtooc/wjY5nMkKHPJ19
	sZStDZ3ERTWRRkwx1pMgboerCO7zcV4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2C93741950;
	Mon,  9 Feb 2026 14:39:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38C4BC116C6;
	Mon,  9 Feb 2026 14:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770647969;
	bh=rKGd883t0mW5F1sVxQvZylDp/AAHhdrL4UTVDJdkRgM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=lCpPM2ND9onyRZvKor9ARgLCOMktp2aQHrqH1n8BQrGgfgOsTu/VQ4GBiOMRD5L66
	 FASf74NjN3AvypbOawbaq+LllM5T0b0vLC1lPJ1pU/9ff4JmKKW7S2i7ku9qBes//Y
	 seduQY1Vveo2bhfhmgvdt8ci3k9K2qKUp7zJhkXm1wNrcv4cstX/Wb0OsLm7+I/F9c
	 57HOH/6cKUwqGt9rAJQ+AiwMgcuS83umxfaM9YyxcGWg++q7Nw9+YojpPJM2tnjfnK
	 Q1DiUBphb1qWhFxzveQ8n4z+Ih+7GlEnVvKr/q0sjuhtWIaIhs7bT9WBrWzX5atEJh
	 hsudSZQ/b8jQA==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 09 Feb 2026 15:38:17 +0100
Subject: [PATCH v3 12/12] rust: xarray: add preload API
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260209-xarray-entry-send-v3-12-f777c65b8ae2@kernel.org>
References: <20260209-xarray-entry-send-v3-0-f777c65b8ae2@kernel.org>
In-Reply-To: <20260209-xarray-entry-send-v3-0-f777c65b8ae2@kernel.org>
To: Tamir Duberstein <tamird@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, 
 Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>
Cc: Daniel Gomez <da.gomez@kernel.org>, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Andreas Hindborg <a.hindborg@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=16827;
 i=a.hindborg@kernel.org; h=from:subject:message-id;
 bh=rKGd883t0mW5F1sVxQvZylDp/AAHhdrL4UTVDJdkRgM=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpifFf6NffzuXerL7xmFyC9b4KK7WEKpBgEWDYV
 NTIqGYovkSJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaYnxXwAKCRDhuBo+eShj
 dy44EACNDxm6p+yj/FsUGdp4Qtxt98PxnZF1Fv09Kj81o8fMoLkBXYm72Ty5SLNtxRCu+bAb8jy
 71lkuOHueV1wmQ/Yxy2vmQW3rqhLOSQEYsI7IiieomAjg4fj1hUHkr50Ltw0zG1OdrtfZV5vR3E
 Un0nV0ocP15tv4Qk2g9ajNXevmDzutOqc6qJWyJlYofzCTiQ7+5V/yQzyre2EfXTuKgQdLSk6+C
 /gQst7h1JIQ/nEPuVAWVfYidFAvkg8v/xSIHMfYkiF4+yfwMW+L3XwKY6rFUgB5jfRljI6YiiGe
 OYNmnsQACXRUoDLnpQ0ly6UR0KaZpLgbXLf+zjIKRQhr6/P9EpW0f5q4LTsduZWa2b2y8ITuMg8
 ENP6Gkk/GlbYc+TMxjLMZeOpqgNQg36NQzRDjWabQr8lPrQpiWoijt0S/MRYA/tjz96DJS7mQW2
 D5z1C3q2PDvSP/U/uE8LFDhtwn4hB67lzPPLwsjEtM1vNOxc3zJMcvmLOayJh+K7t0VvtX0gWcW
 ZkB6BUY9vMSmG6M8fXbdYPVFXEP5iEGqb1BxexJqLHiRUunLVZ5c/VCCx+Cxfp7bgsBjDO9+GzZ
 BZJGUkl+6aQrhj2QJbaJ+2R3RTLadNSUW8tpdZj4QvT9mp2m5uVVdlc6FxEbj636TMEw59r0Qn1
 BXzwDdR4akoRAXg==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User: 
X-Rspamd-Queue-Id: F0DA614000D
X-Rspamd-Server: rspam07
X-Stat-Signature: 4pyxympns9map6zjrkzfs7bnsy7msg6u
X-HE-Tag: 1770647969-41780
X-HE-Meta: U2FsdGVkX1/BtZICgvSYQr7Xn/3H9CAqDuqKuTVEHGuhSuB74MJGVGkI6MsquSg5Qx6+5Tjj2JenD7znwjlDH0NRFGOLQXNkl+mv3JzM4fLPtzq8hByLXfTNm0LdMD3D2zlLPjVduU9Ogtd9L9YjeiwWkVaEfrX5+hisaIizWRh67XIiei6klI8jAC5GEeDqzYSXC4OrI48k0l8Hd8gM8leBDGNx7KeWGXUVLJHMbLpAfVSsVxI9uoFcgcaHcmz2CB771LHMA+cc5BwMZzojrhEaYP26chghLwS6eWCWYohXxcV8QaRgidknUszRxP82G7BOvaRYPxRR44+fK70dF2XV341k27kTFko8ijbvSZC+4aeLUzTXxFRfgXEhvZ0RNkHWn+tQPwG1LbdziOXEIaPy0keNbjbVW8HN8ICncfFUUpNLdaoeVSUK+z9CrG5yElZbBT1LLmfXJJx3f9DhIn40Fjy+v95jAc/UuHw+b2jW7ACKfEvd87zk6CRNfnoCTbdqBU90WyjycDqh//AjIiOGaA2A5L5J/yvqNxQSuecLXXEuMCcW4y+3/70eDusXh3XMhtNjkJsspnXtDD2XgqtC4klb07T2wprvrMhwvJLE13+A9rLBqwEhLgwgWe8wbfxM8GdrGj/vrhkCDdLDx7v2lj0hu3LmX0tz4//hLRtUWMQLzP3zL8E9gWLgb69wHsDs+WisI2omJOJ1vCYNPcn4elk04cPTizxFOrJoLF0fM+Mi8lDV3fp33xY5XRY/caLy+VhwjbwqUUkpy8MhBecC2s4LQPq/E8aYvmFodPUpex196fQwA5jC70SY45FJTgnH6BpDJXKbbQX8x+tl99NNTo23F+qf5f83ozaARGAvRDVy7A8bipQzaD0H4TNSt/o3YUU2iPCeqeX3Ur25UaD/gqJ/pXFc/b14mfq6y6a4sMXFLVKsHgmfaUouEV4PlWukoX/MG2mQg86FD5p
 4arGjuXb
 sjsvLCJJIL2zTQzc+GljSM8Hg8h0+2giente2FSA3ZxbVfOFCG1NnTp4m6dMZamEJ0A4l0D2hdnBGt/6ydPVa3NNE56BuVBLdbIAJTXnrZzobcnjUPbOF/5sxvhwvzRIp8+R9IM4W8FuWSZT34G3A86Co1iYHHUFVrPNa/IN7qNotmqo+ie8HLLhpGN8VUzSMxcK4Jh2HoWqjBEv46t9mJlJBjIFhvpGuvXQYZh+31c5gBLKRcSfbLXtgtw/xTcAtFTQrG3QvDt8UYQmur/19EsFdNoI2Ed4SUF5HSL9cYn0eL9GrB0hYJfwB0zFZFQFs86n0F+oTavbJzKEVBsfngag+Ixj6E7nm86xnPydLpEhug6+DEA7qdWSIRBiawbC4iaOqTnGT7scSOGjt2DBY7z51EQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a preload API that allows preallocating memory for XArray
insertions. This enables insertions to proceed without allocation
failures in contexts where memory allocation is not desirable, such as
in atomic contexts.

The implementation introduces `XArrayNode` representing a single XArray
node and `XArraySheaf` as a type alias for a sheaf of preallocated
nodes.

Add the function `xarray_kmem_cache` to provide access to the global XArray
node cache for creating sheaves.

Update `VacantEntry::insert` and `VacantEntry::insert_entry` to accept
an optional sheaf argument for preloaded memory. Add a new
`Guard::insert_entry` method for inserting with preload support. When an
insertion would fail due to ENOMEM, the XArray state API automatically
consumes a preallocated node from the sheaf if available.

Export `radix_tree_node_ctor` and `radix_tree_node_cachep` from C to
enable Rust code to work with the radix tree node cache.

Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 include/linux/radix-tree.h      |   3 +
 lib/radix-tree.c                |   5 +-
 rust/bindings/bindings_helper.h |   3 +
 rust/kernel/xarray.rs           | 172 +++++++++++++++++++++++++++++++++++-----
 rust/kernel/xarray/entry.rs     |  29 ++++---
 5 files changed, 182 insertions(+), 30 deletions(-)

diff --git a/include/linux/radix-tree.h b/include/linux/radix-tree.h
index eae67015ce51a..c3699f12b070c 100644
--- a/include/linux/radix-tree.h
+++ b/include/linux/radix-tree.h
@@ -469,4 +469,7 @@ static __always_inline void __rcu **radix_tree_next_slot(void __rcu **slot,
 	     slot = radix_tree_next_slot(slot, iter,			\
 				RADIX_TREE_ITER_TAGGED | tag))
 
+
+void radix_tree_node_ctor(void *arg);
+
 #endif /* _LINUX_RADIX_TREE_H */
diff --git a/lib/radix-tree.c b/lib/radix-tree.c
index 1cf0012b15ade..ddd67ce672f5c 100644
--- a/lib/radix-tree.c
+++ b/lib/radix-tree.c
@@ -33,6 +33,7 @@
  * Radix tree node cache.
  */
 struct kmem_cache *radix_tree_node_cachep;
+EXPORT_SYMBOL(radix_tree_node_cachep);
 
 /*
  * The radix tree is variable-height, so an insert operation not only has
@@ -1566,14 +1567,14 @@ void idr_destroy(struct idr *idr)
 }
 EXPORT_SYMBOL(idr_destroy);
 
-static void
-radix_tree_node_ctor(void *arg)
+void radix_tree_node_ctor(void *arg)
 {
 	struct radix_tree_node *node = arg;
 
 	memset(node, 0, sizeof(*node));
 	INIT_LIST_HEAD(&node->private_list);
 }
+EXPORT_SYMBOL(radix_tree_node_ctor);
 
 static int radix_tree_cpu_dead(unsigned int cpu)
 {
diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
index 58605c32e8102..652f08ad888cd 100644
--- a/rust/bindings/bindings_helper.h
+++ b/rust/bindings/bindings_helper.h
@@ -118,6 +118,9 @@ const xa_mark_t RUST_CONST_HELPER_XA_PRESENT = XA_PRESENT;
 const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC = XA_FLAGS_ALLOC;
 const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC1 = XA_FLAGS_ALLOC1;
 const size_t RUST_CONST_HELPER_XAS_RESTART = (size_t)XAS_RESTART;
+const size_t RUST_CONST_HELPER_XA_CHUNK_SHIFT = XA_CHUNK_SHIFT;
+const size_t RUST_CONST_HELPER_XA_CHUNK_SIZE = XA_CHUNK_SIZE;
+extern struct kmem_cache *radix_tree_node_cachep;
 
 const vm_flags_t RUST_CONST_HELPER_VM_MERGEABLE = VM_MERGEABLE;
 const vm_flags_t RUST_CONST_HELPER_VM_READ = VM_READ;
diff --git a/rust/kernel/xarray.rs b/rust/kernel/xarray.rs
index 8c10e8fd76f15..89bf531308c88 100644
--- a/rust/kernel/xarray.rs
+++ b/rust/kernel/xarray.rs
@@ -5,6 +5,7 @@
 //! C header: [`include/linux/xarray.h`](srctree/include/linux/xarray.h)
 
 use core::{
+    convert::Infallible,
     iter,
     marker::PhantomData,
     pin::Pin,
@@ -23,11 +24,17 @@
     bindings,
     build_assert, //
     error::{
+        code::*,
         to_result,
         Error,
         Result, //
     },
     ffi::c_void,
+    mm::sheaf::{
+        KMemCache,
+        SBox,
+        StaticSheaf, //
+    },
     types::{
         ForeignOwnable,
         NotThreadSafe,
@@ -35,12 +42,54 @@
     },
 };
 use pin_init::{
+    init,
     pin_data,
     pin_init,
     pinned_drop,
+    Init,
     PinInit, //
 };
 
+/// Sheaf of preallocated [`XArray`] nodes.
+pub type XArraySheaf<'a> = StaticSheaf<'a, XArrayNode>;
+
+/// Returns a reference to the global XArray node cache.
+///
+/// This provides access to the kernel's `radix_tree_node_cachep`, which is the
+/// slab cache used for allocating internal XArray nodes. This cache can be used
+/// to create sheaves for preallocating XArray nodes.
+pub fn xarray_kmem_cache() -> &'static KMemCache<XArrayNode> {
+    // SAFETY: `radix_tree_node_cachep` is a valid, statically initialized
+    // kmem_cache that remains valid for the lifetime of the kernel. The cache
+    // is configured for `xa_node` objects which match our `XArrayNode` type.
+    unsafe { KMemCache::from_raw(bindings::radix_tree_node_cachep) }
+}
+
+/// An preallocated XArray node.
+///
+/// This represents a single preallocated internal node for an XArray.
+pub struct XArrayNode {
+    node: Opaque<bindings::xa_node>,
+}
+
+impl kernel::mm::sheaf::KMemCacheInit<XArrayNode> for XArrayNode {
+    fn init() -> impl Init<Self, Infallible> {
+        init!(Self {
+            // SAFETY:
+            // - This initialization cannot fail and will never return `Err`.
+            // - The xa_node does not move during initalization.
+            node <- unsafe {
+                pin_init::init_from_closure(
+                    |place: *mut Opaque<bindings::xa_node>| -> Result<(), Infallible> {
+                        bindings::radix_tree_node_ctor(place.cast::<c_void>());
+                        Ok(())
+                    },
+                )
+            }
+        })
+    }
+}
+
 /// An array which efficiently maps sparse integer indices to owned objects.
 ///
 /// This is similar to a [`crate::alloc::kvec::Vec<Option<T>>`], but more efficient when there are
@@ -137,15 +186,22 @@ fn iter(&self) -> impl Iterator<Item = NonNull<c_void>> + '_ {
         let mut index = 0;
 
         // SAFETY: `self.xa` is always valid by the type invariant.
-        iter::once(unsafe {
-            bindings::xa_find(self.xa.get(), &mut index, usize::MAX, bindings::XA_PRESENT)
-        })
-        .chain(iter::from_fn(move || {
-            // SAFETY: `self.xa` is always valid by the type invariant.
-            Some(unsafe {
-                bindings::xa_find_after(self.xa.get(), &mut index, usize::MAX, bindings::XA_PRESENT)
-            })
-        }))
+        Iterator::chain(
+            iter::once(unsafe {
+                bindings::xa_find(self.xa.get(), &mut index, usize::MAX, bindings::XA_PRESENT)
+            }),
+            iter::from_fn(move || {
+                // SAFETY: `self.xa` is always valid by the type invariant.
+                Some(unsafe {
+                    bindings::xa_find_after(
+                        self.xa.get(),
+                        &mut index,
+                        usize::MAX,
+                        bindings::XA_PRESENT,
+                    )
+                })
+            }),
+        )
         .map_while(|ptr| NonNull::new(ptr.cast()))
     }
 
@@ -166,7 +222,6 @@ pub fn try_lock(&self) -> Option<Guard<'_, T>> {
     pub fn lock(&self) -> Guard<'_, T> {
         // SAFETY: `self.xa` is always valid by the type invariant.
         unsafe { bindings::xa_lock(self.xa.get()) };
-
         Guard {
             xa: self,
             _not_send: NotThreadSafe,
@@ -270,7 +325,7 @@ pub fn get_mut(&mut self, index: usize) -> Option<T::BorrowedMut<'_>> {
     ///
     /// match guard.entry(42) {
     ///     Entry::Vacant(entry) => {
-    ///         entry.insert(KBox::new(0x1337u32, GFP_KERNEL)?)?;
+    ///         entry.insert(KBox::new(0x1337u32, GFP_KERNEL)?, None)?;
     ///     }
     ///     Entry::Occupied(_) => unreachable!("We did not insert an entry yet"),
     /// }
@@ -475,6 +530,45 @@ pub fn store(
             Ok(unsafe { T::try_from_foreign(old) })
         }
     }
+
+    /// Inserts a value and returns an occupied entry for further operations.
+    ///
+    /// If a value is already present, the operation fails.
+    ///
+    /// This method will not drop the XArray lock. If memory allocation is
+    /// required for the operation to succeed, the user should supply memory
+    /// through the `preload` argument.
+    ///
+    /// # Examples
+    ///
+    /// ```
+    /// # use kernel::{prelude::*, xarray::{AllocKind, XArray}};
+    /// let mut xa = KBox::pin_init(XArray::<KBox<u32>>::new(AllocKind::Alloc), GFP_KERNEL)?;
+    /// let mut guard = xa.lock();
+    ///
+    /// assert_eq!(guard.get(42), None);
+    ///
+    /// let value = KBox::new(0x1337u32, GFP_KERNEL)?;
+    /// let entry = guard.insert_entry(42, value, None)?;
+    /// let borrowed = entry.into_mut();
+    /// assert_eq!(borrowed, &0x1337);
+    ///
+    /// # Ok::<(), kernel::error::Error>(())
+    /// ```
+    pub fn insert_entry<'b>(
+        &'b mut self,
+        index: usize,
+        value: T,
+        preload: Option<&mut XArraySheaf<'_>>,
+    ) -> Result<OccupiedEntry<'a, 'b, T>, StoreError<T>> {
+        match self.entry(index) {
+            Entry::Vacant(entry) => entry.insert_entry(value, preload),
+            Entry::Occupied(_) => Err(StoreError {
+                error: EBUSY,
+                value,
+            }),
+        }
+    }
 }
 
 /// Internal state for XArray iteration and entry operations.
@@ -489,6 +583,25 @@ pub(crate) struct XArrayState<'a, 'b, T: ForeignOwnable> {
     state: bindings::xa_state,
 }
 
+impl<'a, 'b, T: ForeignOwnable> Drop for XArrayState<'a, 'b, T> {
+    fn drop(&mut self) {
+        if !self.state.xa_alloc.is_null() {
+            // SAFETY:
+            // - `xa_alloc` is only set via `SBox::into_ptr()` in `insert()` where
+            //   the node comes from an `XArraySheaf` backed by `radix_tree_node_cachep`.
+            // - `xa_alloc` points to a valid, initialized `XArrayNode`.
+            // - `XArrayState` has exclusive ownership of `xa_alloc`, and no other
+            //   `SBox` or reference exists for this value.
+            drop(unsafe {
+                SBox::<XArrayNode>::static_from_ptr(
+                    bindings::radix_tree_node_cachep,
+                    self.state.xa_alloc.cast(),
+                )
+            })
+        }
+    }
+}
+
 impl<'a, 'b, T: ForeignOwnable> XArrayState<'a, 'b, T> {
     fn new(access: &'b Guard<'a, T>, index: usize) -> Self {
         let ptr = access.xa.xa.get();
@@ -529,16 +642,37 @@ fn status(&self) -> Result {
         to_result(unsafe { bindings::xas_error(&self.state) })
     }
 
-    fn insert(&mut self, value: T) -> Result<*mut c_void, StoreError<T>> {
+    fn insert(
+        &mut self,
+        value: T,
+        mut preload: Option<&mut XArraySheaf<'_>>,
+    ) -> Result<*mut c_void, StoreError<T>> {
         let new = T::into_foreign(value).cast();
 
-        // SAFETY: `self.state.state` is properly initialized and `new` came from `T::into_foreign`.
-        // We hold the xarray lock.
-        unsafe { bindings::xas_store(&mut self.state, new) };
-
-        self.status().map(|()| new).map_err(|error| {
-            // SAFETY: `new` came from `T::into_foreign` and `xas_store` does not take ownership of
-            // the value on error.
+        loop {
+            // SAFETY: `self.state` is properly initialized and `new` came from
+            // `T::into_foreign`. We hold the xarray lock.
+            unsafe { bindings::xas_store(&mut self.state, new) };
+
+            match self.status() {
+                Ok(()) => break Ok(new),
+                Err(ENOMEM) => {
+                    debug_assert!(self.state.xa_alloc.is_null());
+                    let node = match preload.as_mut().map(|sheaf| sheaf.alloc().ok_or(ENOMEM)) {
+                        None => break Err(ENOMEM),
+                        Some(Err(e)) => break Err(e),
+                        Some(Ok(node)) => node,
+                    };
+
+                    self.state.xa_alloc = node.into_ptr().cast();
+                    continue;
+                }
+                Err(e) => break Err(e),
+            }
+        }
+        .map_err(|error| {
+            // SAFETY: `new` came from `T::into_foreign` and `xas_store` does not take
+            // ownership of the value on error.
             let value = unsafe { T::from_foreign(new) };
             StoreError { value, error }
         })
diff --git a/rust/kernel/xarray/entry.rs b/rust/kernel/xarray/entry.rs
index 1b1c21bed7022..ff500be3832b7 100644
--- a/rust/kernel/xarray/entry.rs
+++ b/rust/kernel/xarray/entry.rs
@@ -3,6 +3,7 @@
 use super::{
     Guard,
     StoreError,
+    XArraySheaf,
     XArrayState, //
 };
 use core::ptr::NonNull;
@@ -29,9 +30,9 @@ impl<T: ForeignOwnable> Entry<'_, '_, T> {
     /// let mut xa = KBox::pin_init(XArray::<KBox<u32>>::new(AllocKind::Alloc), GFP_KERNEL)?;
     /// let mut guard = xa.lock();
     ///
-    ///
     /// let entry = guard.entry(42);
     /// assert_eq!(entry.is_occupied(), false);
+    /// drop(entry);
     ///
     /// guard.store(42, KBox::new(0x1337u32, GFP_KERNEL)?, GFP_KERNEL)?;
     /// let entry = guard.entry(42);
@@ -64,7 +65,8 @@ pub(crate) fn new(guard: &'b mut Guard<'a, T>, index: usize) -> Self {
     /// Returns a reference to the newly inserted value.
     ///
     /// - This method will fail if the nodes on the path to the index
-    ///   represented by this entry are not present in the XArray.
+    ///   represented by this entry are not present in the XArray and no memory
+    ///   is available via the `preload` argument.
     /// - This method will not drop the XArray lock.
     ///
     ///
@@ -79,7 +81,7 @@ pub(crate) fn new(guard: &'b mut Guard<'a, T>, index: usize) -> Self {
     ///
     /// if let Entry::Vacant(entry) = guard.entry(42) {
     ///     let value = KBox::new(0x1337u32, GFP_KERNEL)?;
-    ///     let borrowed = entry.insert(value)?;
+    ///     let borrowed = entry.insert(value, None)?;
     ///     assert_eq!(*borrowed, 0x1337);
     /// }
     ///
@@ -87,8 +89,12 @@ pub(crate) fn new(guard: &'b mut Guard<'a, T>, index: usize) -> Self {
     ///
     /// # Ok::<(), kernel::error::Error>(())
     /// ```
-    pub fn insert(mut self, value: T) -> Result<T::BorrowedMut<'b>, StoreError<T>> {
-        let new = self.state.insert(value)?;
+    pub fn insert(
+        mut self,
+        value: T,
+        preload: Option<&mut XArraySheaf<'_>>,
+    ) -> Result<T::BorrowedMut<'b>, StoreError<T>> {
+        let new = self.state.insert(value, preload)?;
 
         // SAFETY: `new` came from `T::into_foreign`. The entry has exclusive
         // ownership of `new` as it holds a mutable reference to `Guard`.
@@ -98,7 +104,8 @@ pub fn insert(mut self, value: T) -> Result<T::BorrowedMut<'b>, StoreError<T>> {
     /// Inserts a value and returns an occupied entry representing the newly inserted value.
     ///
     /// - This method will fail if the nodes on the path to the index
-    ///   represented by this entry are not present in the XArray.
+    ///   represented by this entry are not present in the XArray and no memory
+    ///   is available via the `preload` argument.
     /// - This method will not drop the XArray lock.
     ///
     /// # Examples
@@ -112,7 +119,7 @@ pub fn insert(mut self, value: T) -> Result<T::BorrowedMut<'b>, StoreError<T>> {
     ///
     /// if let Entry::Vacant(entry) = guard.entry(42) {
     ///     let value = KBox::new(0x1337u32, GFP_KERNEL)?;
-    ///     let occupied = entry.insert_entry(value)?;
+    ///     let occupied = entry.insert_entry(value, None)?;
     ///     assert_eq!(occupied.index(), 42);
     /// }
     ///
@@ -120,8 +127,12 @@ pub fn insert(mut self, value: T) -> Result<T::BorrowedMut<'b>, StoreError<T>> {
     ///
     /// # Ok::<(), kernel::error::Error>(())
     /// ```
-    pub fn insert_entry(mut self, value: T) -> Result<OccupiedEntry<'a, 'b, T>, StoreError<T>> {
-        let new = self.state.insert(value)?;
+    pub fn insert_entry(
+        mut self,
+        value: T,
+        preload: Option<&mut XArraySheaf<'_>>,
+    ) -> Result<OccupiedEntry<'a, 'b, T>, StoreError<T>> {
+        let new = self.state.insert(value, preload)?;
 
         Ok(OccupiedEntry::<'a, 'b, T> {
             state: self.state,

-- 
2.51.2



