Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92ECFC87FD3
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 12:58:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 352C38E0003; Wed,  6 Aug 2025 08:58:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DBFF8E0002; Wed,  6 Aug 2025 08:58:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CBC88E0003; Wed,  6 Aug 2025 08:58:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0C82B8E0002
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 08:58:40 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B460D1DCAA8
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 12:58:39 +0000 (UTC)
X-FDA: 83746336758.12.B72E7F4
Received: from mailrelay-egress16.pub.mailoutpod3-cph3.one.com (mailrelay-egress16.pub.mailoutpod3-cph3.one.com [46.30.212.3])
	by imf17.hostedemail.com (Postfix) with ESMTP id C292F40016
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 12:58:37 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa1 header.b=fDzJflG0;
	dkim=pass header.d=konsulko.se header.s=ed1 header.b=nxrSyIPu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754485118; a=rsa-sha256;
	cv=none;
	b=WU3+qSeB7OYKKOr5R4R2a6GytZSlX+AHRMTfsEIIqD2A+rmb0z4EPd+zcSc5rEEALll6K/
	fCmlJm2uk9RHugptt0Hu0OkfxGuFQi8dz/NbZv8RcHGPvRTVZ3o9hSWz97uITiAC6bLW98
	eBumktnSj0uLs76YZRwAF8eZHUMVfKA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa1 header.b=fDzJflG0;
	dkim=pass header.d=konsulko.se header.s=ed1 header.b=nxrSyIPu;
	spf=none (imf17.hostedemail.com: domain of vitaly.wool@konsulko.se has no SPF policy when checking 46.30.212.3) smtp.mailfrom=vitaly.wool@konsulko.se;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754485117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sFGu5BXaHdw7qt33g/urIepCBkzhd5+wVoobk3GWVFk=;
	b=l/Oul0cQpla3W/1hyEGEOC1RAIr2Lzv3iwRCh2iSL5vSoVUyH8jFFsDlUSD0e3gaTqzmrU
	wvHiqkzw4IJkhEbhDHbtJPESv6PwQqmNK8kxK1IPUdcT2awOYcpRUJDax8n6/X3aQhDLI8
	YqzKv3L7mXqZBW5Xvsd1Hemp58jekHI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1754485116; x=1755089916;
	d=konsulko.se; s=rsa1;
	h=content-transfer-encoding:mime-version:references:in-reply-to:message-id:date:
	 subject:cc:to:from:from;
	bh=sFGu5BXaHdw7qt33g/urIepCBkzhd5+wVoobk3GWVFk=;
	b=fDzJflG0Xf+anBPajbpNMaIwDk1XtW0QZ2vsxOEf2MwhI5BbS7yxAkYZwA6ql7GqThbRpV9vQZ/1c
	 ZEefaRToFFd7kEqUB+dH5cnmlO5XF+kt/Jjj+xCzgtLRzDh8YG+WRfZZ3p+/BzvxD8c8ywmTdmM2aq
	 oPlXN0m8d34gvu8mk4E6rhnQ9WQqz+ZealKuz5Zm5PscCMUR9mPEBOZ2lvcWlSfOcEXUgU909eXwjZ
	 Kh9EX1dvyt0Pcw8Bn0DKsUqr+2iQhJM7yH6Wq6rUsGmVYWsTqsVwMp7nccZ7X6/mfFh2yRejseFyCq
	 FpsuIMEyv58485dfeDzxVfcxL3N/u9Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1754485116; x=1755089916;
	d=konsulko.se; s=ed1;
	h=content-transfer-encoding:mime-version:references:in-reply-to:message-id:date:
	 subject:cc:to:from:from;
	bh=sFGu5BXaHdw7qt33g/urIepCBkzhd5+wVoobk3GWVFk=;
	b=nxrSyIPuFxJvBvGYzbokaEzckF2VsQhhDZ8WbQq3DvuqC84KGmIryiQNXeCVHEq8DDSuNhkm3L5Ny
	 J1gw/pkDg==
X-HalOne-ID: 0ff7d6ea-72c5-11f0-a1f4-f78b1f841584
Received: from localhost.localdomain (host-95-203-16-218.mobileonline.telia.com [95.203.16.218])
	by mailrelay1.pub.mailoutpod2-cph3.one.com (Halon) with ESMTPSA
	id 0ff7d6ea-72c5-11f0-a1f4-f78b1f841584;
	Wed, 06 Aug 2025 12:58:36 +0000 (UTC)
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
Subject: [PATCH v15 4/4] rust: support large alignments in allocations
Date: Wed,  6 Aug 2025 14:55:52 +0200
Message-Id: <20250806125552.1727073-1-vitaly.wool@konsulko.se>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250806124034.1724515-1-vitaly.wool@konsulko.se>
References: <20250806124034.1724515-1-vitaly.wool@konsulko.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C292F40016
X-Stat-Signature: x51hxprk9hynud3zrwgsxa97uczqqsaz
X-HE-Tag: 1754485117-611511
X-HE-Meta: U2FsdGVkX1+14h1lu6ZyLjes5ItgVdVqNl3N6b8ZEH4PUaYMocsWcvpooGt4w5Xa+skWNmA5rHKycScRmXNnr8ayIdtd5XXhywSpZopjgmGaRgvfdrdNV3ntNE861RCXVK5BItUJ5+Ass54H+2SlXDIJ+4Mrv5tRtc+2fYbtdbdgoFqke5hGSLhlg3YPi2PVboMVRml24TWcjW17dX6aq+WSPaRn7h+OyN6/4oj7lGV54hRJMCwLXbfljNasDwDZDTYsEowwbysjr198moakJy/NCuAC54K3625XnOHBjKN6I9OLWGHfpM+e2O9D+ireyTn/vHYmofJpZczh9sRUxEvJOvglXzEv3pp7VbuqOXVc9nnJuiBhuGjxwxfeGFs/t+e7Yd1tMuIxQ03qwwxFpyLfQ+Gxba1EwjsmC53KWzN//dF2eR2o8Lvz54sltmd2HtHOYeiH2BSkNN07PmPNyOMVNbRnfYz1iTbH6hdVJWO/pdTm3OXz/tkTXJCAGCSymHpj1Q8gX1EYWhTxY2Ov0mwFINzwSGArgzEs2D4npuEsWGp5QZEcf5Ipk5eXYUEl+A8DYvOvXCpKCWRTrTgEsdzPY+NjzH8ZlgiBZ22g6gQxZAekKSBpBjl/PEY15KL5nilBtqxuZCqOcr7OnyqJHW9ef/cNDR63MlAdVDaCSxlDLDNlpKa1ED2dDim4iw7czltJ46muG1V2UBVAXr/MUmFKFhOAoqsF4W2fHgozK8t+WWQHWgnqXJcKbLAH3YV/c+vB3Gr8FEMvA4wc9g7XT+RMRdoLtLbKuCALozjHRwESIBQkI0aQCgyZSdUnnSV+NVIQI1CFyr3rLgWNISvkvPsTp+NKzp76neyZjduXFiq5O0U7+iK77RFxEsjwt7xf6xgVrE1j8TBGcsyIZPa8gEJzINcwnrc/IPCpz2g2TCPJduC8Brq6FlC7kYiD+/ry7aIepukHSDPiJnYslZl
 ax/6DlO9
 84pa0pribd/ZwAdFxauhALXbqbkO6hRuKv2yXfcFVsXm4VBLsHVq4IxGP9d8XDizHZPk4eTTFtevpuT3nlRfPnCuABSH4V3KjppLlfxjym/HKeZubrKaXPbA/uRX3vWGDA229mF/elvPPN1hg+6vidl6li7Cmi+3Yar1+aS717VYWmFUYtmU4hHDMPw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add support for large (> PAGE_SIZE) alignments in Rust allocators.
All the preparations on the C side are already done, we just need
to add bindings for <alloc>_node_align() functions and start
using those.

Signed-off-by: Vitaly Wool <vitaly.wool@konsulko.se>
Acked-by: Danilo Krummrich <dakr@kernel.org>
Acked-by: Alice Ryhl <aliceryhl@google.com>
---
 rust/helpers/slab.c            | 10 ++++++----
 rust/helpers/vmalloc.c         |  5 +++--
 rust/kernel/alloc/allocator.rs | 30 +++++++++---------------------
 3 files changed, 18 insertions(+), 27 deletions(-)

diff --git a/rust/helpers/slab.c b/rust/helpers/slab.c
index 8472370a4338..7fac958907b0 100644
--- a/rust/helpers/slab.c
+++ b/rust/helpers/slab.c
@@ -3,13 +3,15 @@
 #include <linux/slab.h>
 
 void * __must_check __realloc_size(2)
-rust_helper_krealloc_node(const void *objp, size_t new_size, gfp_t flags, int node)
+rust_helper_krealloc_node_align(const void *objp, size_t new_size, unsigned long align,
+				gfp_t flags, int node)
 {
-	return krealloc_node(objp, new_size, flags, node);
+	return krealloc_node_align(objp, new_size, align, flags, node);
 }
 
 void * __must_check __realloc_size(2)
-rust_helper_kvrealloc_node(const void *p, size_t size, gfp_t flags, int node)
+rust_helper_kvrealloc_node_align(const void *p, size_t size, unsigned long align,
+				 gfp_t flags, int node)
 {
-	return kvrealloc_node(p, size, flags, node);
+	return kvrealloc_node_align(p, size, align, flags, node);
 }
diff --git a/rust/helpers/vmalloc.c b/rust/helpers/vmalloc.c
index 62d30db9a1a6..7d7f7336b3d2 100644
--- a/rust/helpers/vmalloc.c
+++ b/rust/helpers/vmalloc.c
@@ -3,7 +3,8 @@
 #include <linux/vmalloc.h>
 
 void * __must_check __realloc_size(2)
-rust_helper_vrealloc_node(const void *p, size_t size, gfp_t flags, int node)
+rust_helper_vrealloc_node_align(const void *p, size_t size, unsigned long align,
+				gfp_t flags, int node)
 {
-	return vrealloc_node(p, size, flags, node);
+	return vrealloc_node_align(p, size, align, flags, node);
 }
diff --git a/rust/kernel/alloc/allocator.rs b/rust/kernel/alloc/allocator.rs
index 8af7e04e3cc6..63f271624428 100644
--- a/rust/kernel/alloc/allocator.rs
+++ b/rust/kernel/alloc/allocator.rs
@@ -15,7 +15,6 @@
 
 use crate::alloc::{AllocError, Allocator, NumaNode};
 use crate::bindings;
-use crate::pr_warn;
 
 /// The contiguous kernel allocator.
 ///
@@ -56,25 +55,26 @@ fn aligned_size(new_layout: Layout) -> usize {
 
 /// # Invariants
 ///
-/// One of the following: `krealloc_node`, `vrealloc_node`, `kvrealloc_node`.
+/// One of the following: `krealloc_node_align`, `vrealloc_node_align`, `kvrealloc_node_align`.
 struct ReallocFunc(
     unsafe extern "C" fn(
         *const crate::ffi::c_void,
         usize,
+        crate::ffi::c_ulong,
         u32,
         crate::ffi::c_int,
     ) -> *mut crate::ffi::c_void,
 );
 
 impl ReallocFunc {
-    // INVARIANT: `krealloc_node` satisfies the type invariants.
-    const KREALLOC: Self = Self(bindings::krealloc_node);
+    // INVARIANT: `krealloc_node_align` satisfies the type invariants.
+    const KREALLOC: Self = Self(bindings::krealloc_node_align);
 
-    // INVARIANT: `vrealloc_node` satisfies the type invariants.
-    const VREALLOC: Self = Self(bindings::vrealloc_node);
+    // INVARIANT: `vrealloc_node_align` satisfies the type invariants.
+    const VREALLOC: Self = Self(bindings::vrealloc_node_align);
 
-    // INVARIANT: `kvrealloc_node` satisfies the type invariants.
-    const KVREALLOC: Self = Self(bindings::kvrealloc_node);
+    // INVARIANT: `kvrealloc_node_align` satisfies the type invariants.
+    const KVREALLOC: Self = Self(bindings::kvrealloc_node_align);
 
     /// # Safety
     ///
@@ -116,7 +116,7 @@ unsafe fn call(
         // - Those functions provide the guarantees of this function.
         let raw_ptr = unsafe {
             // If `size == 0` and `ptr != NULL` the memory behind the pointer is freed.
-            self.0(ptr.cast(), size, flags.0, nid.0).cast()
+            self.0(ptr.cast(), size, layout.align(), flags.0, nid.0).cast()
         };
 
         let ptr = if size == 0 {
@@ -160,12 +160,6 @@ unsafe fn realloc(
         flags: Flags,
         nid: NumaNode,
     ) -> Result<NonNull<[u8]>, AllocError> {
-        // TODO: Support alignments larger than PAGE_SIZE.
-        if layout.align() > bindings::PAGE_SIZE {
-            pr_warn!("Vmalloc does not support alignments larger than PAGE_SIZE yet.\n");
-            return Err(AllocError);
-        }
-
         // SAFETY: If not `None`, `ptr` is guaranteed to point to valid memory, which was previously
         // allocated with this `Allocator`.
         unsafe { ReallocFunc::VREALLOC.call(ptr, layout, old_layout, flags, nid) }
@@ -185,12 +179,6 @@ unsafe fn realloc(
         flags: Flags,
         nid: NumaNode,
     ) -> Result<NonNull<[u8]>, AllocError> {
-        // TODO: Support alignments larger than PAGE_SIZE.
-        if layout.align() > bindings::PAGE_SIZE {
-            pr_warn!("KVmalloc does not support alignments larger than PAGE_SIZE yet.\n");
-            return Err(AllocError);
-        }
-
         // SAFETY: If not `None`, `ptr` is guaranteed to point to valid memory, which was previously
         // allocated with this `Allocator`.
         unsafe { ReallocFunc::KVREALLOC.call(ptr, layout, old_layout, flags, nid) }
-- 
2.39.2


