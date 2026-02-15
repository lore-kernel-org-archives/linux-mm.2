Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8E13E63F21
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 00:49:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 492966B00AB; Sun, 15 Feb 2026 19:35:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42FD46B0138; Sun, 15 Feb 2026 19:35:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 365886B013A; Sun, 15 Feb 2026 19:35:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 76AFE6B00AB
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 19:35:45 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4330C1407A5
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:42:16 +0000 (UTC)
X-FDA: 84448317072.06.212274E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 762A04000D
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:42:14 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oTB2Bv0h;
	spf=pass (imf07.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771198934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dWIQ2b599zN4W7H4Uq6lj5blfckqKfOS1JZdFu1QTG8=;
	b=cDp7p5vXBQuQAxCutFVyULn6o376U2RgKa+9x38rKYprTBpKo1y29SgH5q8CnKqZhSKr+E
	9Vkroj3FeWRCKujUkHOsONBb/s6soRUrtlYg+Q7Cp2WLTaHKOcijAxl1BkmDEpqIP97ziP
	Ke2yRMdYL8rzmKcX/QK8ca0lvwIqhIw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oTB2Bv0h;
	spf=pass (imf07.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771198934; a=rsa-sha256;
	cv=none;
	b=TrhmJIFfH4uOOXL2v+SGN1weLFf00/1BXMiKnsBC7eMwh77grCaG8baNgnT3icTSmapXN9
	FfavI57lPV+qkysrgT35fnyUsOqc8eBcAlv14NG6Eg9iX/RJPGI7EmT6g0//N3gy6a6SYe
	Si8opp4Fxm52PhZqEnUhU+3Nv2FQer8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B22C2405A3;
	Sun, 15 Feb 2026 23:42:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58C44C4CEF7;
	Sun, 15 Feb 2026 23:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771198933;
	bh=h7+bon01UENFNoUz8aPGZ7HCRgNi5L5RQlf/Y/C7XMA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=oTB2Bv0htB2pXAXWaZJsudOqYB2WyHJ74Zz2aeHIU3yDKemx2JWmtEf8wyTL84VPL
	 dRyIkzzyIQsjYHgWBkoHd+YUny96mtkaUBkrhDyVio9zCC3+WSHffWQWsoh+MRjLR4
	 bg3kzp8VNT1qSq6rw75xhyP7k88bU+LbVBNEW7s4bwqJHBotNK2ZiaYPz8yGfEmds9
	 ZK8r9TrjOvywsNIBH6jnlG7LlQ0At0/TFSeIJpR0Nat1vbvJemEV4/tbyOKw7hfnQN
	 aasdUQPnAkxUS3HqfhHpzAi3DeHoci8f1DnQyHxbxxSnFRtTkO2Kq/BWB8VuVHL3dK
	 OrIlFBmjm6eSA==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 16 Feb 2026 00:35:43 +0100
Subject: [PATCH 56/79] block: rust: add abstraction for block queue feature
 flags
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-rnull-v6-19-rc5-send-v1-56-de9a7af4b469@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=6502; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=h7+bon01UENFNoUz8aPGZ7HCRgNi5L5RQlf/Y/C7XMA=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpklhOREpIyxuvj/IBFaVKOjzP6Ic55E0Q/l0dW
 MIwADOZnFeJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZJYTgAKCRDhuBo+eShj
 d9hoEACpVmpgtnsKcpDvuhvuAPuxqSo5potehm+47IVnGk8liQen6kvUYVGj8MBJ92nUu9SvxuY
 dtoaM8jPnSp4ocwYgA4nowinOfRuNy7oBVWt8HmD0WQtFC6AKb6bJZotCcb7PmpeJF0YPu6kyOI
 WUC5JGi3URjTb1Qq7MbfGjXXvvHIqlZT+MuxDboD/0EBn5EJl+EjKjNVYVS9TeA2aq6Q/f03h7z
 3xP1Mjrbmj9sXhwYAy6T+wfbC2GrTbcjw/Hob5FFXb297vFUX7d++uNTazraLYmpfi99JcjltAi
 0wbe28Jp6hJE9zeqOlufQLn/x3MPMl8Kn+00raZObBz06TiRKXSgOj1Gt5Yri6PznQjjR+ITxXE
 3GQeznd6Xd/BLpDQSfNfR/RBxAAkoWf3jfpj4tblQFH3K84gvr7jxwWH2+/qEuXVqmLVgwR/+hB
 DtwffWbgsHjVSLjItvZuQ3wkWAF1SqLhG+JOkgAU/tP+/uhNCVRLcccxnSsy6xhIlxVpisfG8HZ
 0n95Sh6IL2L43khIYnpYfNVuFkCnzD+7AYxe0SgMd9/eAytq1ETsaNMG+6WWQFAo6vqmvjrQ8JE
 zCpkPZGushAyWA5FLbU0pLekebqK9U98u4uomQZtHfd73cUHlCwIf8lM+PtZTtmEZ9nRrXliYZs
 yYj1lSCT2uPCd7w==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Stat-Signature: ztw6xjtdaz9ksuhcd63tdmiah4hc4c4i
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 762A04000D
X-HE-Tag: 1771198934-448859
X-HE-Meta: U2FsdGVkX199718xJ1TiBrhY/FdJN0WzV4sdXurY6A5fatOH3Pu93JsRflk5t+ggFrCV1WPradLJAjf4bo20f2UAlOISGkQ5VT6TosFAAIttm/nX0iutBi+qA6d85ijboQ1v3hAPX1Megb2evXoC5Nzf7SBZP2GPqK4o/2HAnGnQ7DssX3za7k+pWKZ9OtP7OfslT2MqlSBoOwm8rMi+eaW9n9h3O6lH8hadD+DH0CyXbF2uqOZdSTgPAWHnm8DL0UFqCsRdSWbrePS4gFLz+uXYDkp5r1BfCRI7fzV9VjU2pEtUL/oBj/5y+Soj9k5cOFPGjaaQ3ItfQPPJol/Q6K7bo6PxhInVlkV4SCuoxR2B0FbvtD+vPpUQ0qBZmwgwhUBwQYzqXVP/MDtWPsmIo5ZxNsRQDwq7SAO8TZt4jC4IVYi46EslidWTDcZG9zp1/Len8cAjxzItY2C5wgxJM7fopKTVss4hbQehGzY09DndqChmXEHBEhABDmIMWUp1Nyklz0QpVPCs3MyseGptJvzwO/9tbCpwO3KYg3TblvTdStOGiojMqVB+tPIk6nvgswcDqA3Wtz1x3p+qdcSSvUjP+bCT1QXvvOS1bqh8jyvJ8HY7ucC45gSf3ZTk3R6Zg6Dt3RDFlH1a2NOqqvjBMKE7mP3v3wfn2uFBUXkVVNRzYm6l8TxJPwrU1A6Gnndr4Z3P0AywREkMi2nFF8LA67dvIUE4mqazS7eZobazouqAe2uRVrmFkYDqiw9/aSVdBgjFeqIIbMpPc0DKEUc4I+WN9EiuCmGByoKJ2nAzicpcWya/UK5HEqyfD0Vv8iFjvT/rGrhWf0+D2kLZby9fve1ywc3i8gnNWlMvUd0l1s+AIPuTAukPYizIMDz7770JuuYDPV2D0ejQ7WzmEyaCXJAbSZxMeZwnE4PviusVLtuioH85Yiz2ZocK1q1neWnLcWTyp3CWa9Wa8kFla1J
 S+ym+v01
 mUUIhvI/z2yHziN9jHrS39pYTOWqQ92H4pg3/4yxab+7G1W7DxrgE9XuT5XPOBtU57Wn/XVSrJZQGtSC8GIxPNGfgmnCrxPNomadHhJV0G+/cMcunwKj9SCx+ZmIMibsxV+af8DGbNWeqmzVGL5BKoyEsFECFc/ym+eS7Tv5kpHt+1UjrzjdxGsRyxriQLwLGwktqOQMtoO/HPBmMRXY3mLVDwOx+V/VGt3hkctnEd2MBpMjpwqJsZMhXedqSY+eOvJIKuQdo8xWeO7rXMn9mdr8byOYbyhJMdbT2qw5KAT6DMuHTL30PVjoNyzONO9+UUjRD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the `Feature` enum and `Features` type as Rust abstractions for the
C `blk_features_t` bitfield. These types wrap the `BLK_FEAT_*` flags
and allow drivers to describe block device capabilities such as write
cache support, FUA, rotational media, and DAX.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/bindings/bindings_helper.h | 15 ++++++++-
 rust/kernel/block/mq.rs         |  2 ++
 rust/kernel/block/mq/feature.rs | 73 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 89 insertions(+), 1 deletion(-)

diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
index b8c2f3eadc730..209c53443e9cb 100644
--- a/rust/bindings/bindings_helper.h
+++ b/rust/bindings/bindings_helper.h
@@ -113,7 +113,6 @@ const gfp_t RUST_CONST_HELPER_GFP_NOWAIT = GFP_NOWAIT;
 const gfp_t RUST_CONST_HELPER___GFP_ZERO = __GFP_ZERO;
 const gfp_t RUST_CONST_HELPER___GFP_HIGHMEM = ___GFP_HIGHMEM;
 const gfp_t RUST_CONST_HELPER___GFP_NOWARN = ___GFP_NOWARN;
-const blk_features_t RUST_CONST_HELPER_BLK_FEAT_ROTATIONAL = BLK_FEAT_ROTATIONAL;
 const blk_status_t RUST_CONST_HELPER_BLK_STS_OK = BLK_STS_OK;
 const blk_status_t RUST_CONST_HELPER_BLK_STS_NOTSUPP = BLK_STS_NOTSUPP;
 const blk_status_t RUST_CONST_HELPER_BLK_STS_TIMEOUT = BLK_STS_TIMEOUT;
@@ -133,7 +132,21 @@ const blk_status_t RUST_CONST_HELPER_BLK_STS_ZONE_ACTIVE_RESOURCE = BLK_STS_ZONE
 const blk_status_t RUST_CONST_HELPER_BLK_STS_OFFLINE = BLK_STS_OFFLINE;
 const blk_status_t RUST_CONST_HELPER_BLK_STS_DURATION_LIMIT = BLK_STS_DURATION_LIMIT;
 const blk_status_t RUST_CONST_HELPER_BLK_STS_INVAL = BLK_STS_INVAL;
+const blk_features_t RUST_CONST_HELPER_BLK_FEAT_WRITE_CACHE = BLK_FEAT_WRITE_CACHE;
+const blk_features_t RUST_CONST_HELPER_BLK_FEAT_FUA = BLK_FEAT_FUA;
+const blk_features_t RUST_CONST_HELPER_BLK_FEAT_ROTATIONAL = BLK_FEAT_ROTATIONAL;
+const blk_features_t RUST_CONST_HELPER_BLK_FEAT_ADD_RANDOM = BLK_FEAT_ADD_RANDOM;
+const blk_features_t RUST_CONST_HELPER_BLK_FEAT_IO_STAT = BLK_FEAT_IO_STAT;
+const blk_features_t RUST_CONST_HELPER_BLK_FEAT_STABLE_WRITES = BLK_FEAT_STABLE_WRITES;
+const blk_features_t RUST_CONST_HELPER_BLK_FEAT_SYNCHRONOUS = BLK_FEAT_SYNCHRONOUS;
+const blk_features_t RUST_CONST_HELPER_BLK_FEAT_NOWAIT = BLK_FEAT_NOWAIT;
+const blk_features_t RUST_CONST_HELPER_BLK_FEAT_DAX = BLK_FEAT_DAX;
+const blk_features_t RUST_CONST_HELPER_BLK_FEAT_POLL = BLK_FEAT_POLL;
 const blk_features_t RUST_CONST_HELPER_BLK_FEAT_ZONED = BLK_FEAT_ZONED;
+const blk_features_t RUST_CONST_HELPER_BLK_FEAT_PCI_P2PDMA = BLK_FEAT_PCI_P2PDMA;
+const blk_features_t RUST_CONST_HELPER_BLK_FEAT_SKIP_TAGSET_QUIESCE = BLK_FEAT_SKIP_TAGSET_QUIESCE;
+const blk_features_t RUST_CONST_HELPER_BLK_FEAT_RAID_PARTIAL_STRIPES_EXPENSIVE = BLK_FEAT_RAID_PARTIAL_STRIPES_EXPENSIVE;
+const blk_features_t RUST_CONST_HELPER_BLK_FEAT_ATOMIC_WRITES = BLK_FEAT_ATOMIC_WRITES;
 const blk_opf_t RUST_CONST_HELPER_REQ_FAILFAST_DEV = REQ_FAILFAST_DEV;
 const blk_opf_t RUST_CONST_HELPER_REQ_FAILFAST_TRANSPORT = REQ_FAILFAST_TRANSPORT;
 const blk_opf_t RUST_CONST_HELPER_REQ_FAILFAST_DRIVER = REQ_FAILFAST_DRIVER;
diff --git a/rust/kernel/block/mq.rs b/rust/kernel/block/mq.rs
index 5a1c8e914bb9e..b36112f7b22b9 100644
--- a/rust/kernel/block/mq.rs
+++ b/rust/kernel/block/mq.rs
@@ -125,12 +125,14 @@
 //! # Ok::<(), kernel::error::Error>(())
 //! ```
 
+mod feature;
 pub mod gen_disk;
 mod operations;
 mod request;
 mod request_queue;
 pub mod tag_set;
 
+pub use feature::{Feature, Features};
 pub use operations::IoCompletionBatch;
 pub use operations::Operations;
 pub use request::Command;
diff --git a/rust/kernel/block/mq/feature.rs b/rust/kernel/block/mq/feature.rs
new file mode 100644
index 0000000000000..6c9f098e10c55
--- /dev/null
+++ b/rust/kernel/block/mq/feature.rs
@@ -0,0 +1,73 @@
+// SPDX-License-Identifier: GPL-2.0
+
+//! Block device feature flags.
+//!
+//! This module provides Rust abstractions for the C `blk_features_t` type and
+//! the associated `BLK_FEAT_*` flags defined in `include/linux/blkdev.h`.
+
+use kernel::prelude::*;
+
+impl_flags! {
+    /// A set of block device feature flags.
+    ///
+    /// This type wraps the C `blk_features_t` bitfield and represents a
+    /// combination of zero or more [`Feature`] flags. It is used to describe
+    /// the capabilities of a block device in [`struct queue_limits`].
+    ///
+    /// [`struct queue_limits`]: srctree/include/linux/blkdev.h
+    #[derive(Debug, Clone, Default, Copy, PartialEq, Eq)]
+    pub struct Features(u32);
+
+    /// A block device feature flag.
+    ///
+    /// Each variant corresponds to a `BLK_FEAT_*` constant defined in
+    /// `include/linux/blkdev.h`. These flags describe individual capabilities
+    /// or properties of a block device.
+    #[derive(Debug, Clone, Copy, PartialEq, Eq)]
+    pub enum Feature {
+        /// Supports a volatile write cache.
+        WriteCache = bindings::BLK_FEAT_WRITE_CACHE,
+
+        /// Supports passing on the FUA bit.
+        ForcedUnitAccess = bindings::BLK_FEAT_FUA,
+
+        /// Rotational device (hard drive or floppy).
+        Rotational = bindings::BLK_FEAT_ROTATIONAL,
+
+        /// Contributes to the random number pool.
+        AddRandom = bindings::BLK_FEAT_ADD_RANDOM,
+
+        /// Enables disk/partitions I/O accounting.
+        IoStat = bindings::BLK_FEAT_IO_STAT,
+
+        /// Don't modify data until writeback is done.
+        StableWrites = bindings::BLK_FEAT_STABLE_WRITES,
+
+        /// Always completes in submit context.
+        Synchronous = bindings::BLK_FEAT_SYNCHRONOUS,
+
+        /// Supports REQ_NOWAIT.
+        Nowait = bindings::BLK_FEAT_NOWAIT,
+
+        /// Supports DAX.
+        Dax = bindings::BLK_FEAT_DAX,
+
+        /// Supports I/O polling.
+        Poll = bindings::BLK_FEAT_POLL,
+
+        /// Is a zoned device.
+        Zoned = bindings::BLK_FEAT_ZONED,
+
+        /// Supports PCI(e) p2p requests.
+        PciP2Pdma = bindings::BLK_FEAT_PCI_P2PDMA,
+
+        /// Skips this queue in `blk_mq_(un)quiesce_tagset`.
+        SkipTagsetQuiesce = bindings::BLK_FEAT_SKIP_TAGSET_QUIESCE,
+
+        /// Undocumented magic for bcache.
+        RaidPartialStripesExpensive = bindings::BLK_FEAT_RAID_PARTIAL_STRIPES_EXPENSIVE,
+
+        /// Atomic writes enabled.
+        AtomicWrites = bindings::BLK_FEAT_ATOMIC_WRITES,
+    }
+}

-- 
2.51.2



