Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87089606A31F
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 16:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VQ6E2J5f
Received: by kanga.kvack.org (Postfix)
	id 5CF116B05B4; Fri, 30 Oct 2026 12:08:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A71E6B05B5; Fri, 30 Oct 2026 12:08:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E45D6B05B6; Fri, 30 Oct 2026 12:08:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0E6226B05B4
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 12:08:49 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 81675A07B2
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 16:08:49 +0000 (UTC)
X-FDA: 85379775978.06.02E5421
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id AAB6E18000D
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 16:08:47 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VQ6E2J5f;
	spf=pass (imf06.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793376527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TEoBzydLhAWoxE6JUj9FRAegtYtzr4vhwwBHbq7ZyAE=;
	b=ikiQLSgEYCr2xjYuTveFHpWiQ8zyrZfQ1jyz4+CQ6Bmlt3Me1KxEW1FGaE/4v77PcAvXX5
	aZrrgtTZHjXwPn5MEzdXRsbqMv4+Tsom3mwxYxj4td71Jcnw9NKk+h7ucbFt4dXRStv76T
	0TA8/0prm27gQ8M8viEbIvPEcbFP/oM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793376527;
	b=nCYXmMLfoFZVbJbNBi9TDL4LMuZ6ISIiCachJFn0/cjfk/kbJeKh/ddqfuqvWw3sHt6EQk
	BewGtqow7KHa8eDjOE4b1fkzUzdBX2B8V2MgyHfW7DhbvxTCeJJaCPY3uaJY0ahF8LNyjt
	tgbDIkpzjpwC9JhWPVq8mf/KLP/8ZHg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VQ6E2J5f;
	spf=pass (imf06.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E6CCD43BF5;
	Fri, 30 Oct 2026 16:08:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBB351F000C1;
	Fri, 30 Oct 2026 16:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793376526;
	bh=TEoBzydLhAWoxE6JUj9FRAegtYtzr4vhwwBHbq7ZyAE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=VQ6E2J5fBcqUMJHxr8bO2dxN+Z6ipPSNZ1LTkwq93t2gL6/Ss1zV/pML5gZ1p/xGH
	 /F71hx+C9CatqSuSX6XljhY149R/J3O3+fxmjH0ofwLm0VShVa//08Vrhm2TIMfyW9
	 r6Q/g6XeRy5V+Q4sPQfDtoYvZhE494nMf68RYJE2KjDS5SAOG2WD6ozflKRpf4aUBY
	 GrWAL2xSHifCdxRGRlhiSRKxlBZByNFTMxbtzvgnwqmc79T4gct648fUoxl4D/UGnM
	 r3YNg1whPEbGuF741QJE20+uYX1tAkd/HcLZYeU5wNZ55DV0gsaQhfmpuvhbAEDqmi
	 B3QHX2KMmr9cw==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Fri, 30 Oct 2026 17:08:04 +0100
Subject: [PATCH v4 2/2] rust: alloc: move `NumaNode` to the `numa` module
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261030-cpu-helpers-v4-2-a8d840d34837@kernel.org>
References: <20261030-cpu-helpers-v4-0-a8d840d34837@kernel.org>
In-Reply-To: <20261030-cpu-helpers-v4-0-a8d840d34837@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
 Danilo Krummrich <dakr@kernel.org>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Tamir Duberstein <tamird@kernel.org>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Thomas Gleixner <tglx@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Uladzislau Rezki <urezki@gmail.com>, 
 Yury Norov <yury.norov@gmail.com>, Yury Norov <ynorov@nvidia.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-mm@kvack.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5583; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=KD3jiA8PB7u+cdp08Fd6vVtn/2TqMtouWbVeRQ7Vg3Q=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBq5MDpZs0vTnnYLx/gSJ6gNp2Z5/kihDzco/3AH
 H7LzPck3/yJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCauTA6QAKCRD6UCkIqsW9
 0EAUD/4sMjw4PzHpnAuc4FATQY6yu73zk/YNKMGSTcHPxj7Ig1CgvbIIr/BtJl17FArToJmj0gx
 RGZ6nQJlLLYAEXnhDsAflpz1uXJVfITVHS9L47v8ZG05FWp7DmmhXhZiCtC2Lq45qLyfV1GvpYs
 u47MbYRCg+immljxU+oetszPZETxHz+yqB+swIL+uWMqKXW/QRK0/CF1JjENuTs/SC7UvKKdK4l
 +/7KC40Ay4pL98ZFLVve5Vm8vLMijK/cvGVGAAkdeLZb1l78GlI+JxDV+TIPxy5SghCgch6XWqY
 636YxVXAtLs7JopP+TRcVNpAC0bt7nLrLL883RyA/6bhxeoTxbnO5ZGbIqnz1gnjunFYviQXikP
 CoyZ39qmA9de/hhE3oDHgGmuSv55ehaNQO7XFz7R8Kj8o92aJ7SS8FtHuqgW73mFDWolynKMhm6
 hXfuHWlv58iyENUujO11gKKp2iGe4CAA2D+77Ny8T7N/85IHHRFfLbqkQ8OXDyVdOwWIMepJtu4
 DVIBtIuDKahUxCZMhACJ7M38bj5Zj9m2i8gNem9UQJLWxMy+Px3ULOTxrIFOEVnZSeM5R++vvNH
 1r86L2nn91tKhIne5ZWFB96ZMRI5DDXIPHX+ACGLp7IoF5R4JeV/OdhcCJEwsoGe1DhqV7a1GFN
 SFDg///KM0lXZ1A==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AAB6E18000D
X-Stat-Signature: eq5jmg4wdfopgkpgy1bxzeimrd4iyd5e
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793376527-446935
X-HE-Meta: U2FsdGVkX18+gun0Y5mIMvT5RgNdkFbSOra481Z3JLa5VHcSKSkzVQF5s/4thgMG6v9xCkfeHE6SbqNyU1UikC9whp0a8Da8z5/NTUal4FZoeA6aR9Q8+/SnaIjGjbkqIaIzcbxHIOqqLp9+vSB5WpTxM0SalmWJaBfWkp9OFt3oo1C6S9nlgEHLvVwD5YIFl7lDmCXnn/V0/Sa2eDGfn64yeupgs5y7xdD8Vb/90GmpImT9a0+u7k6DK6uBTl3+BzNSl8xaaoPv9h0PgvaUPRqX40C0P+XwNhIqhxdN3s+LnSAyHi5raRG6/HzBYCmdiry/dO36dJvKF2L9jVsH5IyIj5xLNIWqkOU8ezHR8KWrv+Hn+qtB/uJn+PfZEbqdGn+SmEcivh+yFSymPTjZYBhDfcWVDBRB2eZDVvGfJ6LIcY7YM+AUCEu37d0xviQej4w+BkoAqLCJNGqZ4wvVEPjKWalRGj5XMduHrNYSh5+4NyedvNjuh+I2zC+DY/GeqCwnrkMViKzIZzjWkftln27Fs6tKu2yvh0n9QVQUbVcbdhdFuu2kg0B11bPCmoyGDDQxohlICvrVTqnIoUVgecHg4fobG197jEfq9buf0g7HrpxepGw85tvK74/TIuyThJIKRpRjaAVbm+Y7rLdvUhrkxXVQBm3E/d+Udf5V/CEWcQDdZ7BGXnx4+puz4sJO3IHO++2ZMbRTrtatw/7atOurO8QEot89AeQdQ4ByUc95p5jCxAw7xyTqNfj+qQofKI+3pMm+ILZ2YK+Pa6WGvef38b3Inzhbxc/kuVwPTYHnLbfQSQ61wYDMhIc4qdjuRL+6VpEfb49H2lieBTj/jL9X3u/nDwXLocjo4l1e6UbTKRKL83qvhyEIkXK8sTt6UMfZ5sTeg+JZfmHEFit8giq8IwwlElIurEYjvxhk7O/8zCD6f0j2KIAwhGewQmkxq0/lPo4pTI4uAguEMcn
 REXgC00T
 bzeT0Jqd4iDELJ/NWC31f/YLFpAbhgvhwu5FhVnITkc5FPNeL2pRUWd+oFOZ4ujWRJYpk8EAME7UDSBiP0I9kUQv4bpqS2m2gKArFH1ObNq3bmloVA0ihhEUDrz7KXKExNZW3riH93qimPmcJDo1WpsqJYVrkWYccoXebcPQRZtkkW3nahIvvu2qS14QyTxkHIPQT4FdBTFk4GIXrilEZ3k0yIe1tqyaEmGtMrsP5VxgRNmSp+InmVVjpBlyWG7lVnp10WDCqPrf+fm4FCnnvIsPCKeTEONcLWTQvpE0PGYBYfX93U51AmZTvRttOyVqdICJeFoPMNCxD9NQWoIhuprKGwVBd/L8mJ/bS23MRuIKSH4GUms0pAoS6QA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

`NumaNode` identifies a NUMA node and is not specific to the allocator API.
Move it from the `alloc` module to the `numa` module so that NUMA related
items live together.

No functional change.

Suggested-by: Alice Ryhl <aliceryhl@google.com>
Link: https://lore.kernel.org/all/aiZvKPFCkqJUsP0a@google.com/
Reviewed-by: Yury Norov <ynorov@nvidia.com>
Assisted-by: LLM
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/alloc.rs           | 30 ++++--------------------------
 rust/kernel/alloc/allocator.rs |  6 +++---
 rust/kernel/alloc/kbox.rs      |  4 ++--
 rust/kernel/alloc/kvec.rs      |  4 ++--
 rust/kernel/numa.rs            | 35 ++++++++++++++++++++++++++++++++++-
 5 files changed, 45 insertions(+), 34 deletions(-)

diff --git a/rust/kernel/alloc.rs b/rust/kernel/alloc.rs
index 21067bde6860..9daddf540e7d 100644
--- a/rust/kernel/alloc.rs
+++ b/rust/kernel/alloc.rs
@@ -22,7 +22,10 @@
 #[derive(Copy, Clone, PartialEq, Eq, Debug)]
 pub struct AllocError;
 
-use crate::prelude::*;
+use crate::{
+    numa::NumaNode,
+    prelude::*, //
+};
 
 use core::{
     alloc::Layout,
@@ -114,31 +117,6 @@ pub mod flags {
     pub const __GFP_NOWARN: Flags = Flags(bindings::__GFP_NOWARN);
 }
 
-/// Non Uniform Memory Access (NUMA) node identifier.
-#[derive(Clone, Copy, PartialEq)]
-pub struct NumaNode(i32);
-
-impl NumaNode {
-    /// Create a new NUMA node identifier (non-negative integer).
-    ///
-    /// Returns [`EINVAL`] if a negative id or an id exceeding [`bindings::MAX_NUMNODES`] is
-    /// specified.
-    pub fn new(node: i32) -> Result<Self> {
-        // MAX_NUMNODES never exceeds 2**10 because NODES_SHIFT is 0..10.
-        if node < 0 || node >= bindings::MAX_NUMNODES as i32 {
-            return Err(EINVAL);
-        }
-        Ok(Self(node))
-    }
-}
-
-/// Specify necessary constant to pass the information to Allocator that the caller doesn't care
-/// about the NUMA node to allocate memory from.
-impl NumaNode {
-    /// No node preference.
-    pub const NO_NODE: NumaNode = NumaNode(bindings::NUMA_NO_NODE);
-}
-
 /// The kernel's [`Allocator`] trait.
 ///
 /// An implementation of [`Allocator`] can allocate, re-allocate and free memory buffers described
diff --git a/rust/kernel/alloc/allocator.rs b/rust/kernel/alloc/allocator.rs
index cd4203f27aed..4af50e20933b 100644
--- a/rust/kernel/alloc/allocator.rs
+++ b/rust/kernel/alloc/allocator.rs
@@ -11,12 +11,12 @@
 use super::{
     AllocError,
     Allocator,
-    Flags,
-    NumaNode, //
+    Flags, //
 };
 
 use crate::{
     bindings,
+    numa::NumaNode,
     page, //
 };
 
@@ -122,7 +122,7 @@ unsafe fn call(
         // - Those functions provide the guarantees of this function.
         let raw_ptr = unsafe {
             // If `size == 0` and `ptr != NULL` the memory behind the pointer is freed.
-            self.0(ptr.cast(), size, layout.align(), flags.0, nid.0).cast()
+            self.0(ptr.cast(), size, layout.align(), flags.0, nid.as_raw()).cast()
         };
 
         let ptr = if size == 0 {
diff --git a/rust/kernel/alloc/kbox.rs b/rust/kernel/alloc/kbox.rs
index c63d6acdbb6f..0fa736c81287 100644
--- a/rust/kernel/alloc/kbox.rs
+++ b/rust/kernel/alloc/kbox.rs
@@ -13,12 +13,12 @@
 use super::{
     AllocError,
     Allocator,
-    Flags,
-    NumaNode, //
+    Flags, //
 };
 
 use crate::{
     fmt,
+    numa::NumaNode,
     page::AsPageIter,
     prelude::*,
     types::ForeignOwnable, //
diff --git a/rust/kernel/alloc/kvec.rs b/rust/kernel/alloc/kvec.rs
index c7546b9da4fa..b669ca10b3f7 100644
--- a/rust/kernel/alloc/kvec.rs
+++ b/rust/kernel/alloc/kvec.rs
@@ -14,12 +14,12 @@
     AllocError,
     Allocator,
     Box,
-    Flags,
-    NumaNode, //
+    Flags, //
 };
 
 use crate::{
     fmt,
+    numa::NumaNode,
     page::{
         AsPageIter,
         PAGE_SIZE, //
diff --git a/rust/kernel/numa.rs b/rust/kernel/numa.rs
index 164e622d325f..4a3a880308f3 100644
--- a/rust/kernel/numa.rs
+++ b/rust/kernel/numa.rs
@@ -4,12 +4,15 @@
 //!
 //! C header: [`include/linux/nodemask.h`](srctree/include/linux/nodemask.h)
 
-use crate::bindings;
 #[cfg(CONFIG_NUMA)]
 use crate::sync::atomic::{
     Atomic,
     Relaxed, //
 };
+use crate::{
+    bindings,
+    prelude::*, //
+};
 
 /// Returns the number of online NUMA nodes.
 #[inline]
@@ -27,3 +30,33 @@ pub fn num_online_nodes() -> u32 {
         bindings::nr_online_nodes
     }
 }
+
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
+
+    /// Get the raw representation of this node identifier.
+    pub(crate) fn as_raw(self) -> i32 {
+        self.0
+    }
+}
+
+/// Specify necessary constant to pass the information to Allocator that the caller doesn't care
+/// about the NUMA node to allocate memory from.
+impl NumaNode {
+    /// No node preference.
+    pub const NO_NODE: NumaNode = NumaNode(bindings::NUMA_NO_NODE);
+}

-- 
2.54.0



