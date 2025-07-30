Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1561C87FCB
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 19:21:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DAB06B0098; Wed, 30 Jul 2025 15:21:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B2E46B0099; Wed, 30 Jul 2025 15:21:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C8B96B009A; Wed, 30 Jul 2025 15:21:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3C6FD6B0098
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 15:21:09 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EF1C31A053F
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 19:21:08 +0000 (UTC)
X-FDA: 83721899016.16.F08F6DD
Received: from mailrelay-egress16.pub.mailoutpod3-cph3.one.com (mailrelay-egress16.pub.mailoutpod3-cph3.one.com [46.30.212.3])
	by imf29.hostedemail.com (Postfix) with ESMTP id 26B3812000C
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 19:21:06 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa1 header.b=kqVcEhhF;
	dkim=pass header.d=konsulko.se header.s=ed1 header.b=E+hJluxp
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753903267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9/m4MO6Q9UDpoalx8uuY2cF/KzW9kmn77IOh1iOY9IU=;
	b=0+8xaT8vpuesjkGTeTIR3OswCRq9OPhZ9qxO+cFE6sNNb2I/N2HFJeFkOXi39Tcq40AXzE
	u5iq/6gUxCNGxKavqWkddOn5Y2sEGpTw8zqQQpfMQWexICJnQPjYkDG/Ecl+IyGn6StPor
	aKYEEpPM/fi3+uM972t4sNNvzO+CUag=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753903267; a=rsa-sha256;
	cv=none;
	b=w8K+VYUGo39xLizVJrNRB7Ea9E/0P0wUW45M6qTurH/3SgKyeTQIesBxMPbxPclXhGjOpS
	Rq5Q7tgz5kxYgH4N98CEE38Bkh3BUJRzT5eKTCBj3iWHgBlj9EwaOKsVV2kZIrJbRqHMbB
	+3svmQbYJIfHlkIRP46hhbCAwUrRfBg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa1 header.b=kqVcEhhF;
	dkim=pass header.d=konsulko.se header.s=ed1 header.b=E+hJluxp;
	spf=none (imf29.hostedemail.com: domain of vitaly.wool@konsulko.se has no SPF policy when checking 46.30.212.3) smtp.mailfrom=vitaly.wool@konsulko.se;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1753903266; x=1754508066;
	d=konsulko.se; s=rsa1;
	h=content-transfer-encoding:mime-version:references:in-reply-to:message-id:date:
	 subject:cc:to:from:from;
	bh=9/m4MO6Q9UDpoalx8uuY2cF/KzW9kmn77IOh1iOY9IU=;
	b=kqVcEhhFl9ILbR6XiefEURkPV15FlDqWFQHAxZgJgJskJ/UEr053u4VgUE0OBQWsMMKJh2NgrMg0n
	 Qneh9HDPF1Y+O6EZ8wTxCSOaCb5Q8iznVT9AlDV87Kuk7xMK4GRLr6rYDgFSt2giX/Er/l6jB89uZY
	 Ti30jk5Qaq9Y2SraIP20geOxuDvyZrgIPcbilurbpB48EAt5O60rkwjqOG9MrkRyp97bLHyA8J11yX
	 AKeqqMr4UYmbCWDDNAruZa6ioZyhnQQdpeGk+jyIV6isrdM8QpjU+Wo7py8LOgAd8bu8yviqqE7Kcy
	 cF5KSm21QYq2+UYVVlfKc9z08pNdiOA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1753903266; x=1754508066;
	d=konsulko.se; s=ed1;
	h=content-transfer-encoding:mime-version:references:in-reply-to:message-id:date:
	 subject:cc:to:from:from;
	bh=9/m4MO6Q9UDpoalx8uuY2cF/KzW9kmn77IOh1iOY9IU=;
	b=E+hJluxptc5Hgx5gUKqIPEjPaZzcg1BzkmL2XB9nxmR4zKsa24kT/kiDauNf+Yw8ZsXH1dD1GUojI
	 j03oxD9CQ==
X-HalOne-ID: 55256178-6d7a-11f0-9726-fb5fec76084d
Received: from slottsdator.home (host-90-238-19-233.mobileonline.telia.com [90.238.19.233])
	by mailrelay3.pub.mailoutpod3-cph3.one.com (Halon) with ESMTPSA
	id 55256178-6d7a-11f0-9726-fb5fec76084d;
	Wed, 30 Jul 2025 19:21:05 +0000 (UTC)
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
Subject: [PATCH v14 4/4] rust: support large alignments in allocations
Date: Wed, 30 Jul 2025 21:21:01 +0200
Message-Id: <20250730192101.358943-1-vitaly.wool@konsulko.se>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250730191921.352591-1-vitaly.wool@konsulko.se>
References: <20250730191921.352591-1-vitaly.wool@konsulko.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 26B3812000C
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: deajg591tejy88homn33yk4qbarmrtxh
X-HE-Tag: 1753903266-238829
X-HE-Meta: U2FsdGVkX19GOfP0EeOgHSn1LHmIzdvg/mW06IuKQjo2eFM716Q+sSDsOc97G/ikG0r/HwICJBbgk4TM/s5xET4aPgKhYuQ0y7hKg/n5Tvq26UjzmO0LAmCENLzLRTFtzecXR551JhNvKRj2JPLZuXjEwuML7BicP2+cP+uEjkSWKAgEPhMckcdqBEALQ+H9HvTCUZgHK+2VB3wFaezObvlhYiZZ3sgsLhpolEn40Tezpa8/4d7HM6uwIUFjYY34ZIATsT2Z02tXUJrIWsF6CS39krdJmv1YtK/Mm/Q6KNDLYlwU88JgFMFpPKfeOtqNr/xX7E8oR8H+3OQGa3F4oPDLuC84QI0ia1Um9si1u1tgCl/8ltSdF5D8DSuGKrCX6cRmukYWwnfy9E6u0w33flUDMJwahhRYQw3tA0LDU3fvj0b1lMw9wNLbwDFpko483jXyxSps1GwbpTpgxpVn88Gyxont1fPyaxE61oi0tx1FATbFNDJcfHaAwEPHM0oA0wEpbrUuKlgHBvVyuNBql5uJsFYGmw5Swf06KLmVuE0hhHG8afy72iJ65eyQ/r6iG27m+eycRvQsak8EVvJDWAo4SrofnkTxCdee3mZzAcf910TZwqTWAyn1IJl+2HJCUuTZuxV7zL059ZbqjhGrI9PX0mYPxz/qcLNUHWufQMlEI/AdzMYVPnn4zQr5EbYa3OC15npR5mOtrSp7mYVwSSn3kC1c4AzrT1x0m78ONVhtKgJhEL7eD+hwJQIt8YnzODJuuok0i3aVASu/LzSiqndKYZg0fBH3FuR599G8IF3NqUIoYhat1j9DN4ENkEG3c16/yd9pqfoRDEoLiN6BkUkAfPhf+3JVgS8u7iXAO3feNZEj9ldUwDKtiMOp3fYbGZ2oRhOZ8Rgy2AF8EOpqCVi13OHYyBLur/KXNsrA9zUB0GuuRj28VLT6Xcob16H0gwRzYV1KcO1j6FSdAax
 aqW+C4wH
 EE+ddetb5LxvZg7rlcBYYpkWRbOylp8BhAlxCLkcCeCuTcuO6XvSLKwj36eOX3GZQ3uCauFVjMxKNAaJ0GfPmaZHCmiw0K7Dj9Pms08mJXoJ/DgkN28YzYOoo7zT9DfzGiE9jMl5VlB66xrXMTMHb3sE2l9bEI0+qwEhB80yw6FbQll5TNyD+NtyKkA==
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
 rust/helpers/slab.c                 | 10 ++++++----
 rust/helpers/vmalloc.c              |  5 +++--
 rust/kernel/alloc/allocator.rs      | 30 +++++++++--------------------
 rust/kernel/alloc/allocator_test.rs |  1 +
 4 files changed, 19 insertions(+), 27 deletions(-)

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
diff --git a/rust/kernel/alloc/allocator_test.rs b/rust/kernel/alloc/allocator_test.rs
index d19c06ef0498..17b27c6e9e37 100644
--- a/rust/kernel/alloc/allocator_test.rs
+++ b/rust/kernel/alloc/allocator_test.rs
@@ -40,6 +40,7 @@ unsafe fn realloc(
         layout: Layout,
         old_layout: Layout,
         flags: Flags,
+        nid: NumaNode,
     ) -> Result<NonNull<[u8]>, AllocError> {
         let src = match ptr {
             Some(src) => {
-- 
2.39.2


