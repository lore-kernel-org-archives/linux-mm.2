Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26A2DC83F26
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 19:20:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B58C76B0095; Wed, 30 Jul 2025 15:20:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B31006B0096; Wed, 30 Jul 2025 15:20:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A46946B0098; Wed, 30 Jul 2025 15:20:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 920F76B0095
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 15:20:51 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 297B511022F
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 19:20:51 +0000 (UTC)
X-FDA: 83721898302.29.21693F2
Received: from mailrelay-egress16.pub.mailoutpod3-cph3.one.com (mailrelay-egress16.pub.mailoutpod3-cph3.one.com [46.30.212.3])
	by imf17.hostedemail.com (Postfix) with ESMTP id 463BF40008
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 19:20:49 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa1 header.b=WTQstXpN;
	dkim=pass header.d=konsulko.se header.s=ed1 header.b="3P0P/SzZ"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753903249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3ElygyrF5Vh69Zx2+NHe9ydSKBaIv72nS8Ld2xnfgm8=;
	b=S5Y0PTxTS7tYAYixQbNJRxoP1OdsCs0knfo277/ZYCj8GOcEizI3g5EOr9QIYy5yDcP6fI
	3w7nxppjKK9arTQJprmJIJUIuGYrI+2VIUJAsfbfdVf3uV+zH2S1D6FKqMPPmgIae9G04g
	EoL+48FIAL8YPLZryRxjZVFVz/R4r7M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753903249; a=rsa-sha256;
	cv=none;
	b=cV/gpK/NXMG9wQe8RrD1YIt69RtW/i51FW5iJe9FUPdgKvpPNLNnwRx9k6oY09iUwg8ojZ
	+UxClUIuk8VTyuyGBaR57o3ZJEyx1F7DpWF2AR1Lon/jUFKiHd3fJrhLy9mlpbHFdSsY3p
	sBAFnIfCouleOMDfTlQ6Hf7HCUoxZQo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa1 header.b=WTQstXpN;
	dkim=pass header.d=konsulko.se header.s=ed1 header.b="3P0P/SzZ";
	spf=none (imf17.hostedemail.com: domain of vitaly.wool@konsulko.se has no SPF policy when checking 46.30.212.3) smtp.mailfrom=vitaly.wool@konsulko.se;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1753903248; x=1754508048;
	d=konsulko.se; s=rsa1;
	h=content-transfer-encoding:mime-version:references:in-reply-to:message-id:date:
	 subject:cc:to:from:from;
	bh=3ElygyrF5Vh69Zx2+NHe9ydSKBaIv72nS8Ld2xnfgm8=;
	b=WTQstXpNdTw0XLqUl57+GJ7aHHw7rj/b+PhtjqAsNE0PA3XfwORLFEB3pbGUi/mULMbHDSsUCQeGc
	 JBU61goG4G/vC8dOYX4hT8b3d7RGlgpkxOtDxmNn1inm+/GTGDk1ap9h1CG73P/OnN3DePqYMzgXSh
	 nvxWg3Bpb3VEYcVRJNbb2eq+oCr0JLwWuR/boIfx+fBGwiI+k2kDjivx+WmHXo68VWRXyIAVxLkW2H
	 zwXrvjI+zgwp+TIdb29F4Mk7gDt3Am9OKN96aP2VVkTJ5f/7MXaNd3XgpIS1iYqwZRCubaW+u79Yf1
	 yiBgC05+Cm7oxmXxFDVIvAF/WYQ1hBg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1753903248; x=1754508048;
	d=konsulko.se; s=ed1;
	h=content-transfer-encoding:mime-version:references:in-reply-to:message-id:date:
	 subject:cc:to:from:from;
	bh=3ElygyrF5Vh69Zx2+NHe9ydSKBaIv72nS8Ld2xnfgm8=;
	b=3P0P/SzZ+D7S5DumIiX4/pKZ1A2Hyh0YPUJziv0vy6JRZw0xpNCH/PEn8ETiBKPy55RsAd9FhFZEH
	 +yeCs11AA==
X-HalOne-ID: 4a8d52d3-6d7a-11f0-9a05-c9fa7b04d629
Received: from slottsdator.home (host-90-238-19-233.mobileonline.telia.com [90.238.19.233])
	by mailrelay1.pub.mailoutpod3-cph3.one.com (Halon) with ESMTPSA
	id 4a8d52d3-6d7a-11f0-9a05-c9fa7b04d629;
	Wed, 30 Jul 2025 19:20:47 +0000 (UTC)
From: Vitaly Wool <vitaly.wool@konsulko.se>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	Uladzislau Rezki <urezki@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	rust-for-linux@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	linux-bcachefs@vger.kernel.org,
	bpf@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Vitaly Wool <vitaly.wool@konsulko.se>
Subject: [PATCH v14 3/4] rust: add support for NUMA ids in allocations
Date: Wed, 30 Jul 2025 21:20:43 +0200
Message-Id: <20250730192043.357783-1-vitaly.wool@konsulko.se>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250730191921.352591-1-vitaly.wool@konsulko.se>
References: <20250730191921.352591-1-vitaly.wool@konsulko.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 463BF40008
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 1b744rbg75wrdkb5b99pkg8uhp51uztg
X-HE-Tag: 1753903249-823034
X-HE-Meta: U2FsdGVkX1+ssfZOTdcuipwUeLXgJ4/3bYqYzN5WdaYJr6VtRd4aOl7vb3xi+2b5DZsfu+peGD72DK96LAiDRFNcDZHzPP0k7jclhGjG73MR1djyns+O2zWv1hgi+dffc3tmt/y2YEv9nWFxHmW6epSE1xEd8VxtRb31TCjzDw+fL9zoyjNA8z7tLK8UNXrJpmsrSdnIxSxqUqw1pczQxM0aPW4fgFJnkkwJg5RIQkpasiW+oCgdBsb1LKXkTv3HqZb0cociKQFR+yYvtg6IcoWhnOKk1O72/ZMPcpWb3wpVz4MvRuwGbSFOejSCOAZjxgIbdSrBLsGpm+U91FN9r/NiBUWY1yHEIaeOs6SLGGY/QE8GFs5LCjtQHY2Ums7myc6B2aZn15dX/t43yZxHhI+pNXJfivSDrLWZ/HAXbtCH7RekDYFjGMBceOPy/Rg9CG4n9K6E77UIhWDf00N8PuPdvl9CIqTaWvv026y6LSAdd79nXb5JRBgGRAzOJlR4g5+uND2640o9wqxPxXp9K+UZgESmtpMYhIz6pe74Y+KAQWrVyMWbq/WQwfZ6N1ATJxj//BxjkartmWYx326cgpZuo8ntaxgP0qnC64l8w49tzsW4kXSdpY/9Vz0mFPIWpDajMjPNrx5bVMUZeSywpYW4KmpdZxE1XB36p78Q3U+P2o31XbkDyjRFQYHOTUvocaIqB8ONOSnmLBslmtrupgwPV79jK2j5OchqyRg5la7JQH5CkZJcdzf1E3emnrBoNVguNKRfAPmWzaKmB2HtUHqs3KbR4m3zN5Jv35sUxwJ4dB8zn5yA/31Gdvp1kGR0G8OBxx3viEb0N+rNzGFwbQg+KF2QHvsG5LbZCdUOSJhqD/hQq9NJXY4PMJZb/k9AlsOIkT0OHhgIRQnaoOUoQS9s3T7MhHCLHx8x3ksDPxBboCJ3CBUVtR/pFVdHVX/o3lL77QksZlCpUXXIoYD
 ZKGlbZ4K
 zDy+M75uKwCw7e7tvFIL32pmE9/K+zbF43PS4K0QpB61uSuK5tVp+qV7zzQJoYyijHQaxekWwPg83x4HuvtMVoeGmAXzezIDcsMNfeIm9ceB1Knd28Vt+OkkghOCXDTSq7qbEId6FUY6i8gnF77Qs6yhI7Ir16+PT25YXEuRCkcYFunBjgWd5flXIsvOS2ZUxOpHlrpNWBifChx9bn4b3q2EHiw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a new type to support specifying NUMA identifiers in Rust
allocators and extend the allocators to have NUMA id as a
parameter. Thus, modify ReallocFunc to use the new extended realloc
primitives from the C side of the kernel (i. e.
k[v]realloc_node_align/vrealloc_node_align) and add the new function
alloc_node to the Allocator trait while keeping the existing one
(alloc) for backward compatibility.

This will allow to specify node to use for allocation of e. g.
{KV}Box, as well as for future NUMA aware users of the API.

Signed-off-by: Vitaly Wool <vitaly.wool@konsulko.se>
Acked-by: Danilo Krummrich <dakr@kernel.org>
Acked-by: Alice Ryhl <aliceryhl@google.com>
---
 rust/helpers/slab.c            |  8 ++---
 rust/helpers/vmalloc.c         |  4 +--
 rust/kernel/alloc.rs           | 54 ++++++++++++++++++++++++++++++----
 rust/kernel/alloc/allocator.rs | 35 ++++++++++++++--------
 rust/kernel/alloc/kbox.rs      |  4 +--
 rust/kernel/alloc/kvec.rs      | 11 +++++--
 6 files changed, 88 insertions(+), 28 deletions(-)

diff --git a/rust/helpers/slab.c b/rust/helpers/slab.c
index a842bfbddcba..8472370a4338 100644
--- a/rust/helpers/slab.c
+++ b/rust/helpers/slab.c
@@ -3,13 +3,13 @@
 #include <linux/slab.h>
 
 void * __must_check __realloc_size(2)
-rust_helper_krealloc(const void *objp, size_t new_size, gfp_t flags)
+rust_helper_krealloc_node(const void *objp, size_t new_size, gfp_t flags, int node)
 {
-	return krealloc(objp, new_size, flags);
+	return krealloc_node(objp, new_size, flags, node);
 }
 
 void * __must_check __realloc_size(2)
-rust_helper_kvrealloc(const void *p, size_t size, gfp_t flags)
+rust_helper_kvrealloc_node(const void *p, size_t size, gfp_t flags, int node)
 {
-	return kvrealloc(p, size, flags);
+	return kvrealloc_node(p, size, flags, node);
 }
diff --git a/rust/helpers/vmalloc.c b/rust/helpers/vmalloc.c
index 80d34501bbc0..62d30db9a1a6 100644
--- a/rust/helpers/vmalloc.c
+++ b/rust/helpers/vmalloc.c
@@ -3,7 +3,7 @@
 #include <linux/vmalloc.h>
 
 void * __must_check __realloc_size(2)
-rust_helper_vrealloc(const void *p, size_t size, gfp_t flags)
+rust_helper_vrealloc_node(const void *p, size_t size, gfp_t flags, int node)
 {
-	return vrealloc(p, size, flags);
+	return vrealloc_node(p, size, flags, node);
 }
diff --git a/rust/kernel/alloc.rs b/rust/kernel/alloc.rs
index a2c49e5494d3..b39c279236f5 100644
--- a/rust/kernel/alloc.rs
+++ b/rust/kernel/alloc.rs
@@ -28,6 +28,8 @@
 /// Indicates an allocation error.
 #[derive(Copy, Clone, PartialEq, Eq, Debug)]
 pub struct AllocError;
+
+use crate::error::{code::EINVAL, Result};
 use core::{alloc::Layout, ptr::NonNull};
 
 /// Flags to be used when allocating memory.
@@ -115,6 +117,31 @@ pub mod flags {
     pub const __GFP_NOWARN: Flags = Flags(bindings::__GFP_NOWARN);
 }
 
+/// Non Uniform Memory Access (NUMA) node identifier.
+#[derive(Clone, Copy, PartialEq)]
+pub struct NumaNode(i32);
+
+impl NumaNode {
+    /// Create a new NUMA node identifier (non-negative integer).
+    ///
+    /// Returns [`EINVAL`] if a negative id or an id exceeding [`bindings::MAX_NUMNODES`] is
+    /// specified.
+    pub fn new(node: i32) -> Result<Self> {
+        // MAX_NUMNODES never exceeds 2**10 because NODES_SHIFT is 0..10.
+        if node < 0 || node >= bindings::MAX_NUMNODES as i32 {
+            return Err(EINVAL);
+        }
+        Ok(Self(node))
+    }
+}
+
+/// Specify necessary constant to pass the information to Allocator that the caller doesn't care
+/// about the NUMA node to allocate memory from.
+impl NumaNode {
+    /// No node preference.
+    pub const NO_NODE: NumaNode = NumaNode(bindings::NUMA_NO_NODE);
+}
+
 /// The kernel's [`Allocator`] trait.
 ///
 /// An implementation of [`Allocator`] can allocate, re-allocate and free memory buffers described
@@ -137,7 +164,7 @@ pub mod flags {
 /// - Implementers must ensure that all trait functions abide by the guarantees documented in the
 ///   `# Guarantees` sections.
 pub unsafe trait Allocator {
-    /// Allocate memory based on `layout` and `flags`.
+    /// Allocate memory based on `layout`, `flags` and `nid`.
     ///
     /// On success, returns a buffer represented as `NonNull<[u8]>` that satisfies the layout
     /// constraints (i.e. minimum size and alignment as specified by `layout`).
@@ -153,13 +180,21 @@ pub unsafe trait Allocator {
     ///
     /// Additionally, `Flags` are honored as documented in
     /// <https://docs.kernel.org/core-api/mm-api.html#mm-api-gfp-flags>.
-    fn alloc(layout: Layout, flags: Flags) -> Result<NonNull<[u8]>, AllocError> {
+    fn alloc(layout: Layout, flags: Flags, nid: NumaNode) -> Result<NonNull<[u8]>, AllocError> {
         // SAFETY: Passing `None` to `realloc` is valid by its safety requirements and asks for a
         // new memory allocation.
-        unsafe { Self::realloc(None, layout, Layout::new::<()>(), flags) }
+        unsafe { Self::realloc(None, layout, Layout::new::<()>(), flags, nid) }
     }
 
-    /// Re-allocate an existing memory allocation to satisfy the requested `layout`.
+    /// Re-allocate an existing memory allocation to satisfy the requested `layout` and
+    /// a specific NUMA node request to allocate the memory for.
+    ///
+    /// Systems employing a Non Uniform Memory Access (NUMA) architecture contain collections of
+    /// hardware resources including processors, memory, and I/O buses, that comprise what is
+    /// commonly known as a NUMA node.
+    ///
+    /// `nid` stands for NUMA id, i. e. NUMA node identifier, which is a non-negative integer
+    /// if a node needs to be specified, or [`NumaNode::NO_NODE`] if the caller doesn't care.
     ///
     /// If the requested size is zero, `realloc` behaves equivalent to `free`.
     ///
@@ -196,6 +231,7 @@ unsafe fn realloc(
         layout: Layout,
         old_layout: Layout,
         flags: Flags,
+        nid: NumaNode,
     ) -> Result<NonNull<[u8]>, AllocError>;
 
     /// Free an existing memory allocation.
@@ -211,7 +247,15 @@ unsafe fn free(ptr: NonNull<u8>, layout: Layout) {
         // SAFETY: The caller guarantees that `ptr` points at a valid allocation created by this
         // allocator. We are passing a `Layout` with the smallest possible alignment, so it is
         // smaller than or equal to the alignment previously used with this allocation.
-        let _ = unsafe { Self::realloc(Some(ptr), Layout::new::<()>(), layout, Flags(0)) };
+        let _ = unsafe {
+            Self::realloc(
+                Some(ptr),
+                Layout::new::<()>(),
+                layout,
+                Flags(0),
+                NumaNode::NO_NODE,
+            )
+        };
     }
 }
 
diff --git a/rust/kernel/alloc/allocator.rs b/rust/kernel/alloc/allocator.rs
index aa2dfa9dca4c..8af7e04e3cc6 100644
--- a/rust/kernel/alloc/allocator.rs
+++ b/rust/kernel/alloc/allocator.rs
@@ -13,7 +13,7 @@
 use core::ptr;
 use core::ptr::NonNull;
 
-use crate::alloc::{AllocError, Allocator};
+use crate::alloc::{AllocError, Allocator, NumaNode};
 use crate::bindings;
 use crate::pr_warn;
 
@@ -56,20 +56,25 @@ fn aligned_size(new_layout: Layout) -> usize {
 
 /// # Invariants
 ///
-/// One of the following: `krealloc`, `vrealloc`, `kvrealloc`.
+/// One of the following: `krealloc_node`, `vrealloc_node`, `kvrealloc_node`.
 struct ReallocFunc(
-    unsafe extern "C" fn(*const crate::ffi::c_void, usize, u32) -> *mut crate::ffi::c_void,
+    unsafe extern "C" fn(
+        *const crate::ffi::c_void,
+        usize,
+        u32,
+        crate::ffi::c_int,
+    ) -> *mut crate::ffi::c_void,
 );
 
 impl ReallocFunc {
-    // INVARIANT: `krealloc` satisfies the type invariants.
-    const KREALLOC: Self = Self(bindings::krealloc);
+    // INVARIANT: `krealloc_node` satisfies the type invariants.
+    const KREALLOC: Self = Self(bindings::krealloc_node);
 
-    // INVARIANT: `vrealloc` satisfies the type invariants.
-    const VREALLOC: Self = Self(bindings::vrealloc);
+    // INVARIANT: `vrealloc_node` satisfies the type invariants.
+    const VREALLOC: Self = Self(bindings::vrealloc_node);
 
-    // INVARIANT: `kvrealloc` satisfies the type invariants.
-    const KVREALLOC: Self = Self(bindings::kvrealloc);
+    // INVARIANT: `kvrealloc_node` satisfies the type invariants.
+    const KVREALLOC: Self = Self(bindings::kvrealloc_node);
 
     /// # Safety
     ///
@@ -87,6 +92,7 @@ unsafe fn call(
         layout: Layout,
         old_layout: Layout,
         flags: Flags,
+        nid: NumaNode,
     ) -> Result<NonNull<[u8]>, AllocError> {
         let size = aligned_size(layout);
         let ptr = match ptr {
@@ -110,7 +116,7 @@ unsafe fn call(
         // - Those functions provide the guarantees of this function.
         let raw_ptr = unsafe {
             // If `size == 0` and `ptr != NULL` the memory behind the pointer is freed.
-            self.0(ptr.cast(), size, flags.0).cast()
+            self.0(ptr.cast(), size, flags.0, nid.0).cast()
         };
 
         let ptr = if size == 0 {
@@ -134,9 +140,10 @@ unsafe fn realloc(
         layout: Layout,
         old_layout: Layout,
         flags: Flags,
+        nid: NumaNode,
     ) -> Result<NonNull<[u8]>, AllocError> {
         // SAFETY: `ReallocFunc::call` has the same safety requirements as `Allocator::realloc`.
-        unsafe { ReallocFunc::KREALLOC.call(ptr, layout, old_layout, flags) }
+        unsafe { ReallocFunc::KREALLOC.call(ptr, layout, old_layout, flags, nid) }
     }
 }
 
@@ -151,6 +158,7 @@ unsafe fn realloc(
         layout: Layout,
         old_layout: Layout,
         flags: Flags,
+        nid: NumaNode,
     ) -> Result<NonNull<[u8]>, AllocError> {
         // TODO: Support alignments larger than PAGE_SIZE.
         if layout.align() > bindings::PAGE_SIZE {
@@ -160,7 +168,7 @@ unsafe fn realloc(
 
         // SAFETY: If not `None`, `ptr` is guaranteed to point to valid memory, which was previously
         // allocated with this `Allocator`.
-        unsafe { ReallocFunc::VREALLOC.call(ptr, layout, old_layout, flags) }
+        unsafe { ReallocFunc::VREALLOC.call(ptr, layout, old_layout, flags, nid) }
     }
 }
 
@@ -175,6 +183,7 @@ unsafe fn realloc(
         layout: Layout,
         old_layout: Layout,
         flags: Flags,
+        nid: NumaNode,
     ) -> Result<NonNull<[u8]>, AllocError> {
         // TODO: Support alignments larger than PAGE_SIZE.
         if layout.align() > bindings::PAGE_SIZE {
@@ -184,6 +193,6 @@ unsafe fn realloc(
 
         // SAFETY: If not `None`, `ptr` is guaranteed to point to valid memory, which was previously
         // allocated with this `Allocator`.
-        unsafe { ReallocFunc::KVREALLOC.call(ptr, layout, old_layout, flags) }
+        unsafe { ReallocFunc::KVREALLOC.call(ptr, layout, old_layout, flags, nid) }
     }
 }
diff --git a/rust/kernel/alloc/kbox.rs b/rust/kernel/alloc/kbox.rs
index c386ff771d50..5c0b020fb2a4 100644
--- a/rust/kernel/alloc/kbox.rs
+++ b/rust/kernel/alloc/kbox.rs
@@ -4,7 +4,7 @@
 
 #[allow(unused_imports)] // Used in doc comments.
 use super::allocator::{KVmalloc, Kmalloc, Vmalloc};
-use super::{AllocError, Allocator, Flags};
+use super::{AllocError, Allocator, Flags, NumaNode};
 use core::alloc::Layout;
 use core::fmt;
 use core::marker::PhantomData;
@@ -271,7 +271,7 @@ pub fn new(x: T, flags: Flags) -> Result<Self, AllocError> {
     /// ```
     pub fn new_uninit(flags: Flags) -> Result<Box<MaybeUninit<T>, A>, AllocError> {
         let layout = Layout::new::<MaybeUninit<T>>();
-        let ptr = A::alloc(layout, flags)?;
+        let ptr = A::alloc(layout, flags, NumaNode::NO_NODE)?;
 
         // INVARIANT: `ptr` is either a dangling pointer or points to memory allocated with `A`,
         // which is sufficient in size and alignment for storing a `T`.
diff --git a/rust/kernel/alloc/kvec.rs b/rust/kernel/alloc/kvec.rs
index 1a0dd852a468..aa5d27176d9c 100644
--- a/rust/kernel/alloc/kvec.rs
+++ b/rust/kernel/alloc/kvec.rs
@@ -5,7 +5,7 @@
 use super::{
     allocator::{KVmalloc, Kmalloc, Vmalloc},
     layout::ArrayLayout,
-    AllocError, Allocator, Box, Flags,
+    AllocError, Allocator, Box, Flags, NumaNode,
 };
 use core::{
     fmt,
@@ -633,6 +633,7 @@ pub fn reserve(&mut self, additional: usize, flags: Flags) -> Result<(), AllocEr
                 layout.into(),
                 self.layout.into(),
                 flags,
+                NumaNode::NO_NODE,
             )?
         };
 
@@ -1058,7 +1059,13 @@ pub fn collect(self, flags: Flags) -> Vec<T, A> {
             // the type invariant to be smaller than `cap`. Depending on `realloc` this operation
             // may shrink the buffer or leave it as it is.
             ptr = match unsafe {
-                A::realloc(Some(buf.cast()), layout.into(), old_layout.into(), flags)
+                A::realloc(
+                    Some(buf.cast()),
+                    layout.into(),
+                    old_layout.into(),
+                    flags,
+                    NumaNode::NO_NODE,
+                )
             } {
                 // If we fail to shrink, which likely can't even happen, continue with the existing
                 // buffer.
-- 
2.39.2


