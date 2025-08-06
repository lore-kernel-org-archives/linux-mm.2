Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4696FC87FD3
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 12:55:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFA136B00AA; Wed,  6 Aug 2025 08:55:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD1F16B00AB; Wed,  6 Aug 2025 08:55:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0E706B00AC; Wed,  6 Aug 2025 08:55:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BF2866B00AA
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 08:55:30 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 856441A05A2
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 12:55:30 +0000 (UTC)
X-FDA: 83746328820.06.D4B15BD
Received: from mailrelay-egress16.pub.mailoutpod3-cph3.one.com (mailrelay-egress16.pub.mailoutpod3-cph3.one.com [46.30.212.3])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5B4B180012
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 12:55:28 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa1 header.b=bM2Mix7j;
	dkim=pass header.d=konsulko.se header.s=ed1 header.b=QrLaB633
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754484928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2EpY0iZjaJvwwklHeHLkr7Po0NT5Jxje1Dm2vCoM5Mw=;
	b=6WPCYj1gLXD0TIinRVB+SryS8KlpId3Wfcz/xmZvcmrOOVV7V4e217cHmDlV29E0iNf+Fc
	CEOZ7P74aDZ3rjBt/NXr/pm0AX0uS+a+oOWmhmwDvvuMfT4dyOAMSjlSfAdHByVNUdhR6/
	fCWkyDmiPpERab64OjynNBQIZP+GoNw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754484928; a=rsa-sha256;
	cv=none;
	b=kRJATfTJKEo1lrmHr8ygY4yeCSNAwFWHQvgy47VeVi6HE6fNVf9hsPNWkw+MmX+E2yO1oG
	bmyUVqkAnvAs+hPOOEf9R4lLwcaXwic1cS45BGZGO2Vg7oNp4YIu0O+vKc7WUvaqgD2VuP
	xobRHSY3x3DqfJXZ45Nc6JnU+0QfEYA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa1 header.b=bM2Mix7j;
	dkim=pass header.d=konsulko.se header.s=ed1 header.b=QrLaB633;
	spf=none (imf02.hostedemail.com: domain of vitaly.wool@konsulko.se has no SPF policy when checking 46.30.212.3) smtp.mailfrom=vitaly.wool@konsulko.se;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1754484926; x=1755089726;
	d=konsulko.se; s=rsa1;
	h=content-transfer-encoding:mime-version:references:in-reply-to:message-id:date:
	 subject:cc:to:from:from;
	bh=2EpY0iZjaJvwwklHeHLkr7Po0NT5Jxje1Dm2vCoM5Mw=;
	b=bM2Mix7j8hTPXUDnW4X6OqzeQ8JMIjZwwisIJTsx72xmMgSfz7BeOlYxyqNrm6uKVJogNxl3itiSn
	 1dz+ETRJOluRfpQdPOo3Kyr5auUpajjm4ZNoKWO4+tqkRpAK+Q+mW5AJbrSa7cELxmVGA8gXBoBDn2
	 7C+nAsSZg1jhcVHlKU2PnYTI27Cg1VMNPJID5vGdfnqwIx+n43lGQwSKSsvvct1bkoQ0VxFgpjo1Fp
	 UtjqA6EPdk+qIREk8+b4RR8Zz/iEG4BZQdl/zy1adozDB8W4BhYqUD95kjEmp4+YiLYQD4W58wqlWx
	 N0lbDW3T3s+OmH0okqd02dsFlGYQryQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1754484926; x=1755089726;
	d=konsulko.se; s=ed1;
	h=content-transfer-encoding:mime-version:references:in-reply-to:message-id:date:
	 subject:cc:to:from:from;
	bh=2EpY0iZjaJvwwklHeHLkr7Po0NT5Jxje1Dm2vCoM5Mw=;
	b=QrLaB633JmLmW+gulWPCBUbLUwHVFFLdvXKmQYr4zMgpb5ewhvPZjDn/vdsbTRFNA/Vul3OcaTvML
	 dzqf32sBg==
X-HalOne-ID: 9e338ad1-72c4-11f0-aa1a-632fe8569f3f
Received: from localhost.localdomain (host-95-203-16-218.mobileonline.telia.com [95.203.16.218])
	by mailrelay2.pub.mailoutpod3-cph3.one.com (Halon) with ESMTPSA
	id 9e338ad1-72c4-11f0-aa1a-632fe8569f3f;
	Wed, 06 Aug 2025 12:55:25 +0000 (UTC)
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
Subject: [PATCH v15 3/4] rust: add support for NUMA ids in allocations
Date: Wed,  6 Aug 2025 14:55:22 +0200
Message-Id: <20250806125522.1726992-1-vitaly.wool@konsulko.se>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250806124034.1724515-1-vitaly.wool@konsulko.se>
References: <20250806124034.1724515-1-vitaly.wool@konsulko.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5B4B180012
X-Stat-Signature: 9qpn59zeq73wrphtb9rzs77jbgatsj7e
X-Rspam-User: 
X-HE-Tag: 1754484928-816774
X-HE-Meta: U2FsdGVkX19WOqynm/0JdSzGSlniByqaoK5gwSc4/XpU/KcOUtzyYX28xNTt6SfdTaMuacu+eP08CYZlQSJwe7+nyduPjkB0R72JHc/NYygGJ6vJNvl/7HN2lRnm6ZreycpFLGvj4FB2crrzbAx6A1wYR/NeBN+fZVxe8gbZWE5OeKqqISg9Pqa9mFg0UUvxkaIzRnGmufj/O6TS2CUZSzkpJeZ0OC0owv0xyUUCLe3emRB8J3KqOo7An1BMPE8wNggUb5a9XApV68EkbYxfXZ/5dk1sXEcebq4AdDfXBRqQ5YjyudrIMcvFaIrgiOpE9kdJhpOZt/zQsJgHLiuCEI0w5WRCiSvXz9s8jfVsJ2s3DTXbglnaOUG3Ycb4r6PVOObpjpxMK8xwOJN5/IdxT1JRy6r+51EGjI7fWKojM5/haLEIBw0oUAyrOCC/Z47ysmxXhC1XF3dPVZYGaNovd6zRkSGgaHA8syzWcTZaymQIIP9A1X9YIrg5drVw0cG/IJHDV3HW+GtHJECtDK7Whsqd0HKclnDm+ovD87BLBRdHmy7+OfbgniJoxD3oU5JNCr1P8iHO/hHJ40C3roHl3CkYu2aTrPxTXWWFzYaWqQeaisqU2T7kXAZnWZW+snZJq8qDKw1vMlDfPyNnVGkg4a+0iMtteID0Lkcx87Jt4hUN75YijdmrkZVqVU0R9iSUEZtpZK31nrGQcXKwRKRMItqO6PkNMTKD4GlJU0iL/WV28bLF3+dvRQ0/oUdE/FPfenkxPD7f7ks1h95JB0rw0iW07FFZrLiUIx34PQutG2RfGSwXiXva4SfqDipS4UKULVOOGzWROoG1ggwMz3df0/O1AYN5L3iJdXHD13uDbqXzchU0R6yLLw+/fX38TBTEqY1SjS0Yb1qDgO/w7fDzfHjRPNyc4moTELTEspDLrnNCMXZcvbqKZx0EB2viMCwZygA/0jCRSHLxPB12qnh
 keMKkgvn
 QKHMhaYW05BaBw+1U4aGfLENvMa3k2lckaj1KCvmXZdU5f/sCpu4i1uqvsF2jdJ6otzL3ddbn6RkpShXIpS3XQi/wBuJgbBezwxWwLmMXb+DEGBuxA7QZuPat/KyoGgW+JFDLPxX7XfiBYC2/ozCwh2mTvf2Ncew6d6h8kZ0M1RK1Nyfy9y6b18mSUsZOfDNvSVjTCocdvO3yU8kOTsPsLeXBAA==
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
 rust/helpers/slab.c                 |  8 ++---
 rust/helpers/vmalloc.c              |  4 +--
 rust/kernel/alloc.rs                | 54 ++++++++++++++++++++++++++---
 rust/kernel/alloc/allocator.rs      | 35 ++++++++++++-------
 rust/kernel/alloc/allocator_test.rs |  1 +
 rust/kernel/alloc/kbox.rs           |  4 +--
 rust/kernel/alloc/kvec.rs           | 11 ++++--
 7 files changed, 89 insertions(+), 28 deletions(-)

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
diff --git a/rust/kernel/alloc/allocator_test.rs b/rust/kernel/alloc/allocator_test.rs
index d19c06ef0498..955f8b8286fe 100644
--- a/rust/kernel/alloc/allocator_test.rs
+++ b/rust/kernel/alloc/allocator_test.rs
@@ -40,6 +40,7 @@ unsafe fn realloc(
         layout: Layout,
         old_layout: Layout,
         flags: Flags,
+        _nid: NumaNode,
     ) -> Result<NonNull<[u8]>, AllocError> {
         let src = match ptr {
             Some(src) => {
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


