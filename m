Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CF1ECD8CAD
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:12:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C364F6B00C6; Tue,  9 Jun 2026 15:12:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0E596B00C8; Tue,  9 Jun 2026 15:12:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B23456B00C9; Tue,  9 Jun 2026 15:12:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A11976B00C6
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:12:56 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6DA7E91411
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:12:56 +0000 (UTC)
X-FDA: 84861321552.30.4B1F509
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9F163140007
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:12:54 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XmBpTvYQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781032374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ja5KkFyfig0piS8ccuJVk2LRov2nAywPKm3RKnAniXM=;
	b=xl4cNMdDK9mFpGctVHKZ9hJJtrrkaEiiqX9eIFNvvVyfrAT+eJQNYTlGdKAWYY5rQV6a/h
	AZSPhulTFQX3hkW2ypcwLm43wGvXYNh04avXpEy+lo9bDJgXJ598S2yuBEcgApqKGdZlCh
	yQ28H3+Io7zhIObgHqerFdftSIGU4qo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XmBpTvYQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781032374;
	b=XCvE1e/H79m5+kEe7t6nWjT2rb2HEFPbCk9S6nNPMCprHGYPWhMBdYvz3IA3EG0L7I8dfe
	iYizTGxf5BVAxSw0wUqVoMrqaGkeFnG84rApJwtNKY0btfQBs3Gngkue7IFKKYyJ3Uu0Es
	+0WOlPB/IGXnynh/VmuFQknkkTnZfIo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 33BDD602C5;
	Tue,  9 Jun 2026 19:12:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 203821F00898;
	Tue,  9 Jun 2026 19:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781032373;
	bh=Ja5KkFyfig0piS8ccuJVk2LRov2nAywPKm3RKnAniXM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=XmBpTvYQGNYex0G9cDf7mrTcQkE6zSx5BlSiKxiE8zXF7YoKSvcptVWP0ax9KkZpp
	 WDsBf5/5MNWAIaBKh84619ohb+eA4IgID7EGmF4UaNsE24NYDYjBX9TY1UETt8tFmE
	 FjBXyZ6dGR/zZuKNKjt70yPp4Oxj1fDfRQmf4m1VG/bCnUo1c6CNdW/uP2n3IYoax9
	 TXyHequ1+NZ0UDgWekOATHJFJyk20uG/hE99699Ac+RH2ZNPZ5wl9E3MDtfJdyQpIX
	 S+yIas+hwXklF/uWnIuzkXwNm0Y5yhh3qQBYD5zp++qqDqo7f/c+OrJzKydbHF6Yqy
	 LbGLPfpgyM7WA==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 09 Jun 2026 21:08:02 +0200
Subject: [PATCH v2 23/83] block: rnull: add discard support
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-rnull-v6-19-rc5-send-v2-23-82c7404542e2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=10082;
 i=a.hindborg@kernel.org; h=from:subject:message-id;
 bh=ZSZBUb37pDZIK0wkAHNaDzISlaNSNKMcCAAG2JILBR0=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqKGTJ8uX2fM3Snwr3kQptrqZsMmQScXM8+be4R
 pd3o904NGyJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaihkyQAKCRD6UCkIqsW9
 0CgLD/4uNP8wyJjti62HDNzWfcHXuYIe0fxsRoadLQySp324zQzosIaVo4Da3NKHryJDW2/PsWe
 G4Y+n/rpLSJqi7Xhko5+pXFGvE14CBRxN9pUVppbtUzcaFnObe1627rQxutetQyAUD5yN4Va9gK
 hie9Ah2+DaDh6vzNKVhw75qoLIJn9SbsRVxxfH745isLstt6Nuys/8LgMHpmKtpCR+mUVPxQsKV
 CZIh9ylHjWoKeuDvr0lfFtG5sSrQZ4ZmgJ1iZPiCn4OoMD3ICvHA+EVRXn0CPZlC+nukExNaqIY
 nYtqiNY4C6BNegpLk7ndh2if26Iir/ddeqWem8OO7zXy2fzD3ZPSSmFIIs1NlEwrCjXfpRLXKfl
 tJeUfUOl+rruTUB/zKxgfBRU3cnJvr8jjn7dIgdjtVcLGQzlMs6zciaqhVstqgeQXP7Arp6TZe+
 O0GpmbqqxShxg0bP0LR4MFISa+IzPm+OF58yM1vbccbmmcU3LELjWg2U1V073ke6DjfpaMI18OS
 M6qXn0QLQNPwt8AQbLIL0Ewf5Rtwl9BBK/4OoAOmwAWeRf4+800gx+pt0/Im4ZKFiSFQ7N52Spc
 y6gTGRsf9Q8kgF8xk/jQjdLC2mv9BPvlpWTetaXqo8mMwkZKnmS4zIZAoMAz5R7HMid0BhZuUdd
 FZTC5qe9Qyzk8ig==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 85c48mu9p54ed13z1tnd4auuykdmcns8
X-Rspamd-Queue-Id: 9F163140007
X-HE-Tag: 1781032374-8693
X-HE-Meta: U2FsdGVkX19TF2gGgAk5TF3PouJwLi9FNe8eb5BEIxpwARIR1qK73mG8Au0LkpntV+9ZeJ2kza8kKedBC+rDxwDH9G/LH4twXz+5F3wRMHlZSj2lmu703RgLbTP7bLsen3OE7gO9l+2Ds/EN4jj3XnkA8bG2vZsaEIM1HMB/iYzAGlF0We7zS2MrKIWUxN06IrYHR0QpvaVOMtH2aUuP4DY7dSaQdmebdTq0Whw6K+0jejBtYNjve/JwPcqBrvL34e6udRGPpPjwFk9gXZOwmN48Ij6FmAJg09RFsh9fFpjQbUI+yL613xcwylI0Oin7j3rE0Qr+N+xWls5AP7X1MlioMy4TPV8tcESH7oB2QAy0XET9tVo4AhzLBWmQoZRzsbfZfJkQR5njmlw5Qa5UMMY9otEvERCILSMxhVxR15NjHodAV3j+LmGFM3ylQ6OOV33TXa9MCWbXABjYwGVkQ/BbsWcuovLwP4COyXmbhAM9kHOELbtWS8y7wsb7H/kY5Dj9txSMjnSIDAdH/b6xZT157ZBfYqXxataoWPFreltUWg6Wi4JXQjPVIRC8iDgQSjBEQ/GKnnvdDOL37dE6dUMBtv2s9jmvUXxts22SC8YBxj5aQCzPCZzLHCAN5tZw5eNtMQq33L4dbFQUsNZVEzXffHNf4p/QiFsbs+0SRJdqcK/0wYjUAMNezx9k6hdYlmc82vv5CdaRL1oIjFyMKH+Px+Hcv8gIsRnBXvrlBfDzpiU/NB1admz8U5vW3hy9Fj1tVsXRsdKH8oY5d/fUY/6aE6ZPokdSUvkO0vMaC8BFTHEDKoJi7MCEAqmxQhTe39kCDvn+FMSqLt8YJTyu5ujlPpHgM0qpo4O7xjIJRwwnktDhoeEOyEbpS3gGACGREOGLrkIK901BGl4W31MYFWbQLej0C7S0ZLcgzAyyhP6gsByi/BdoO3b49iVmiDnKuL9EtDzCGVoETbMTa/V
 3EvNP67u
 RrNPV1UMperX4nTACA3f/tpZCZGT3jE/zvDTC3KxlJEWYzKhR2FVAxMBPG3qR+cx5SjKILuTj6No8rkduO5OyL1aVN4N17i4vBH5URfQ124wYE3oxUiAbmnPGZMygiN6muAn2OkP2KwujPZIlW3tyTfQxDw5IXOJvF0YVZNCYA6CHIR/1gUB63jFdDQbkGqgZxfE2HZg+41Uuh8cIGuM0jAHw0V3nz2gWiQrTFB86L8a9p7kXhoVSkLiF6a3gPmnzRwVJ80cdPBde9fa277y85aRVUpFdItOePc77elJmNzXvNDMzaZsZnBE9hsdtOdb7F0Aq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add support for discard operations to the rnull block driver:
- Add discard module parameter and configfs attribute.
- Set max_hw_discard_sectors when discard is enabled.
- Add sector occupancy tracking.
- Add discard handling that frees sectors and removes empty pages.
- Discard operations require memory backing to function.

The discard feature uses a bitmap to track which sectors in each page are
occupied, allowing cleanup of pages when they are empty.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 drivers/block/rnull/configfs.rs |  15 +++++
 drivers/block/rnull/rnull.rs    | 120 +++++++++++++++++++++++++++++++++++-----
 2 files changed, 121 insertions(+), 14 deletions(-)

diff --git a/drivers/block/rnull/configfs.rs b/drivers/block/rnull/configfs.rs
index 2f3fa81ea121..e47399cd45a4 100644
--- a/drivers/block/rnull/configfs.rs
+++ b/drivers/block/rnull/configfs.rs
@@ -93,6 +93,7 @@ fn make_group(
                 submit_queues: 7,
                 use_per_node_hctx: 8,
                 home_node: 9,
+                discard: 10,
             ],
         };
 
@@ -113,6 +114,7 @@ fn make_group(
                     memory_backed: false,
                     submit_queues: 1,
                     home_node: bindings::NUMA_NO_NODE,
+                    discard: false,
                 }),
             }),
             core::iter::empty(),
@@ -180,6 +182,7 @@ struct DeviceConfigInner {
     memory_backed: bool,
     submit_queues: u32,
     home_node: i32,
+    discard: bool,
 }
 
 #[vtable]
@@ -213,6 +216,7 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
                 memory_backed: guard.memory_backed,
                 submit_queues: guard.submit_queues,
                 home_node: guard.home_node,
+                discard: guard.discard,
             })?);
             guard.powered = true;
         } else if guard.powered && !power_op {
@@ -307,3 +311,14 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
         }
     })
 );
+
+configfs_attribute!(DeviceConfig, 10,
+    show: |this, page| show_field(this.data.lock().discard, page),
+    store: |this, page| store_with_power_check(this, page, |data, page| {
+        if !data.memory_backed {
+            return Err(EINVAL);
+        }
+        data.discard = kstrtobool_bytes(page)?;
+        Ok(())
+    })
+);
diff --git a/drivers/block/rnull/rnull.rs b/drivers/block/rnull/rnull.rs
index 1d0faf524f5c..bdc05b3f6072 100644
--- a/drivers/block/rnull/rnull.rs
+++ b/drivers/block/rnull/rnull.rs
@@ -19,15 +19,20 @@
             Operations,
             TagSet, //
         },
+        PAGE_SECTOR_MASK, SECTOR_SHIFT,
     },
     error::{
         code,
         Result, //
     },
+    ffi,
     memalloc_scope,
     new_mutex,
     new_xarray,
-    page::SafePage,
+    page::{
+        SafePage, //
+        PAGE_SIZE,
+    },
     pr_info,
     prelude::*,
     str::CString,
@@ -100,6 +105,11 @@
             default: -1,
             description: "Home node for the device. Default: -1 (no node)",
         },
+        discard: bool {
+            default: false,
+            description:
+                "Support discard operations (requires memory-backed null_blk device).",
+        },
     },
 }
 
@@ -137,6 +147,7 @@ fn init(_module: &'static ThisModule) -> impl PinInit<Self, Error> {
                     memory_backed: module_parameters::memory_backed.value(),
                     submit_queues,
                     home_node: module_parameters::home_node.value(),
+                    discard: module_parameters::discard.value(),
                 })?;
                 disks.push(disk, GFP_KERNEL)?;
             }
@@ -161,6 +172,7 @@ struct NullBlkOptions<'a> {
     memory_backed: bool,
     submit_queues: u32,
     home_node: i32,
+    discard: bool,
 }
 struct NullBlkDevice;
 
@@ -176,6 +188,7 @@ fn new(options: NullBlkOptions<'_>) -> Result<GenDisk<Self>> {
             memory_backed,
             submit_queues,
             home_node,
+            discard,
         } = options;
 
         let flags = if memory_backed {
@@ -205,22 +218,30 @@ fn new(options: NullBlkOptions<'_>) -> Result<GenDisk<Self>> {
                 irq_mode,
                 completion_time,
                 memory_backed,
+                block_size: block_size as usize,
             }),
             GFP_KERNEL,
         )?;
 
-        gen_disk::GenDiskBuilder::new()
+        let mut builder = gen_disk::GenDiskBuilder::new()
             .capacity_sectors(capacity_mib << (20 - block::SECTOR_SHIFT))
             .logical_block_size(block_size)?
             .physical_block_size(block_size)?
-            .rotational(rotational)
-            .build(fmt!("{}", name.to_str()?), tagset, queue_data)
+            .rotational(rotational);
+
+        if memory_backed && discard {
+            builder = builder
+                // Max IO size is u32::MAX bytes
+                .max_hw_discard_sectors(ffi::c_uint::MAX >> block::SECTOR_SHIFT);
+        }
+
+        builder.build(fmt!("{}", name.to_str()?), tagset, queue_data)
     }
 
     #[inline(always)]
     fn write(tree: &XArray<TreeNode>, mut sector: usize, mut segment: Segment<'_>) -> Result {
         while !segment.is_empty() {
-            let page = SafePage::alloc_page(GFP_KERNEL)?;
+            let page = NullBlockPage::new()?;
             let mut tree = tree.lock();
 
             let page_idx = sector >> block::PAGE_SECTORS_SHIFT;
@@ -232,8 +253,10 @@ fn write(tree: &XArray<TreeNode>, mut sector: usize, mut segment: Segment<'_>) -
                 tree.get_mut(page_idx).unwrap()
             };
 
+            page.set_occupied(sector);
             let page_offset = (sector & block::PAGE_SECTOR_MASK as usize) << block::SECTOR_SHIFT;
-            sector += segment.copy_to_page(page, page_offset) >> block::SECTOR_SHIFT;
+            sector +=
+                segment.copy_to_page(page.page.as_pin_mut(), page_offset) >> block::SECTOR_SHIFT;
         }
         Ok(())
     }
@@ -248,7 +271,7 @@ fn read(tree: &XArray<TreeNode>, mut sector: usize, mut segment: Segment<'_>) ->
             if let Some(page) = tree.get(idx) {
                 let page_offset =
                     (sector & block::PAGE_SECTOR_MASK as usize) << block::SECTOR_SHIFT;
-                sector += segment.copy_from_page(page, page_offset) >> block::SECTOR_SHIFT;
+                sector += segment.copy_from_page(&page.page, page_offset) >> block::SECTOR_SHIFT;
             } else {
                 sector += segment.zero_page() >> block::SECTOR_SHIFT;
             }
@@ -257,6 +280,37 @@ fn read(tree: &XArray<TreeNode>, mut sector: usize, mut segment: Segment<'_>) ->
         Ok(())
     }
 
+    fn discard(
+        tree: &XArray<TreeNode>,
+        mut sector: usize,
+        sectors: usize,
+        block_size: usize,
+    ) -> Result {
+        let mut remaining_bytes = sectors << SECTOR_SHIFT;
+        let mut tree = tree.lock();
+
+        while remaining_bytes > 0 {
+            let page_idx = sector >> block::PAGE_SECTORS_SHIFT;
+            let mut remove = false;
+            if let Some(page) = tree.get_mut(page_idx) {
+                page.set_free(sector);
+                if page.is_empty() {
+                    remove = true;
+                }
+            }
+
+            if remove {
+                drop(tree.remove(page_idx))
+            }
+
+            let processed = remaining_bytes.min(block_size);
+            sector += processed >> SECTOR_SHIFT;
+            remaining_bytes -= processed;
+        }
+
+        Ok(())
+    }
+
     #[inline(never)]
     fn transfer(
         command: bindings::req_op,
@@ -273,7 +327,40 @@ fn transfer(
     }
 }
 
-type TreeNode = Owned<SafePage>;
+static_assert!((PAGE_SIZE >> SECTOR_SHIFT) <= 64);
+
+struct NullBlockPage {
+    page: Owned<SafePage>,
+    status: u64,
+}
+
+impl NullBlockPage {
+    fn new() -> Result<KBox<Self>> {
+        Ok(KBox::new(
+            Self {
+                page: SafePage::alloc_page(GFP_KERNEL | __GFP_ZERO)?,
+                status: 0,
+            },
+            GFP_KERNEL,
+        )?)
+    }
+
+    fn set_occupied(&mut self, sector: usize) {
+        let idx = sector & PAGE_SECTOR_MASK as usize;
+        self.status |= 1 << idx;
+    }
+
+    fn set_free(&mut self, sector: usize) {
+        let idx = sector & PAGE_SECTOR_MASK as usize;
+        self.status &= !(1 << idx);
+    }
+
+    fn is_empty(&self) -> bool {
+        self.status == 0
+    }
+}
+
+type TreeNode = KBox<NullBlockPage>;
 
 #[pin_data]
 struct QueueData {
@@ -282,6 +369,7 @@ struct QueueData {
     irq_mode: IRQMode,
     completion_time: Delta,
     memory_backed: bool,
+    block_size: usize,
 }
 
 #[pin_data]
@@ -332,12 +420,16 @@ fn queue_rq(
             let command = rq.command();
             let mut sector = rq.sector();
 
-            for bio in rq.bio_iter_mut() {
-                let segment_iter = bio.segment_iter();
-                for segment in segment_iter {
-                    let length = segment.len();
-                    Self::transfer(command, tree, sector, segment)?;
-                    sector += length as usize >> block::SECTOR_SHIFT;
+            if command == bindings::req_op_REQ_OP_DISCARD {
+                Self::discard(tree, sector, rq.sectors(), queue_data.block_size)?;
+            } else {
+                for bio in rq.bio_iter_mut() {
+                    let segment_iter = bio.segment_iter();
+                    for segment in segment_iter {
+                        let length = segment.len();
+                        Self::transfer(command, tree, sector, segment)?;
+                        sector += length as usize >> block::SECTOR_SHIFT;
+                    }
                 }
             }
         }

-- 
2.51.2



