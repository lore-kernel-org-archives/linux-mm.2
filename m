Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AF81E63F25
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 04:17:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 646D16B0126; Sun, 15 Feb 2026 19:07:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 603996B0129; Sun, 15 Feb 2026 19:07:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F1DF6B012B; Sun, 15 Feb 2026 19:07:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B67296B0126
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 19:07:35 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 282951B4F3C
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:43:54 +0000 (UTC)
X-FDA: 84448321188.11.2FFC27A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6910680007
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:43:52 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nLiFV3Ln;
	spf=pass (imf02.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771199032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NOswexeYXK2dpEorNHL+9NAhtzzCs4PH57y+GL8Cfwc=;
	b=sLrsKnyjLEUS5dfrvtRq78oY0cQ3BihF7MC5tDivtA/OzLMqvAGXr8pOc038cBShP3hgkC
	nFOrByjf89Nw/SL8OyhU4NedF8ixN5uat/33dfOxepZ7xLBP6veAbFMAy76fXaM6l9kLYi
	PMuZqXgq4qkko0tRQCdLOOS92x09TU8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nLiFV3Ln;
	spf=pass (imf02.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771199032; a=rsa-sha256;
	cv=none;
	b=y3tNpyD+95BKsckmuA9nENk6u6K3EKcpuSy7FcZ8A9/CLEzMYJHEzJk90gk4z7nVILsohC
	5RtsutOwXfqfRmYGDiHNeIyNEFfRVU1QHw1chNRLpWrShrXyxCh1exPHQCt+5bYKxQP98E
	uPtQi8Ci+pgQm++GHjQ4QzMI4vuV4uM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F39886013E;
	Sun, 15 Feb 2026 23:43:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F166C4CEF7;
	Sun, 15 Feb 2026 23:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771199031;
	bh=kRUjCKtoTGv3hT8Dyq+/AHzdexRsLl9w4VNxmn7tYGw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=nLiFV3Ln/kAwVQ7jgAzUZt+QYD+bmIuFMsT+Yi1JtwFIAC4Lujy/4vUBPaUqsLg44
	 Pz5kKMHGBj4HSoM6TCWWWgcdWSlyV5siE4mMwFGwsawfIDi81j2DYEZsrE4SOW8Rdl
	 ppe7QzEeYHDnYcB99OkjNje7ruTXucVP2m+fbLKPcU+O1vOp7vsr6oUador9TD7ti0
	 bGP/7zKouCcCjV2LzilOwSYablNh8SiboQY5agiYoMXvp6KeR3QEY9vwL3IB3Z+zdb
	 LhX4QTTScID+Yo4Mu7zeL6I5tphcET+DJqzX7jvoaMwa5mj37bI/TCLaThjyrKluyT
	 WIWP+70m+b0Yg==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 16 Feb 2026 00:35:15 +0100
Subject: [PATCH 28/79] block: rnull: add partial I/O support for bad blocks
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-rnull-v6-19-rc5-send-v1-28-de9a7af4b469@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=10153;
 i=a.hindborg@kernel.org; h=from:subject:message-id;
 bh=kRUjCKtoTGv3hT8Dyq+/AHzdexRsLl9w4VNxmn7tYGw=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpklg1reIhnxlHbTm+/U8X/ib+aOTFikBpNjyXx
 0q1mGQ6z6OJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZJYNQAKCRDhuBo+eShj
 dyK7EADGq2Yc0ZJAzDtZeBoR2EMzSt3mLhli34HJVUPQzCDsXSWLN9by/tgnavK/GIhYiLm8NbT
 TKEb3gE133xHSC+rJ9eBZPLMuDl3FAzvZo3Kr+jQNmHa9aBIccULynHVxfQMJyfAdtmK/fOLZV1
 MAcvY4iXxSDezJhmY8n3wYlux5RCjMpMgdrZonAnYinWmQ7OOaUMJQwtC5cI0JX1dOHpq5BIBLB
 6pDyObhtaC2k/70xjE5lg1t3BCNvGRMZYqOXpe7nqXgE5ad6XaMZd8ForSAMIUauJAS1gSwLH9a
 QxI59iQ8+X+Q4lFVcPdtr5orNUyY73x4nI7enf9Gj4pFU61AOahn49yDt79J7RHIWoQJsVdznAc
 waWHA973pU0gBLE7xefFVSKEpoPU7SHPdbtHFsIr/Jsyl3HtL/5D5ki3IxdkRFWg9muENuhF9La
 jkeWWtmv8ea992mOpNlsQJUdMW2J5TPSPNowJs3nbfDcSUnUJL6r5cMPymG9nAMHp0yZAvW5Vu3
 ByHMgLf3Jy1AxQZUloIQkxT10ERnBQiH3mvaDxhPrAynoJcLvRYtMHDdlWNerehpg8UR8gwGs3i
 pSz2BsirisJm7OvQrguGyGuM8GJTpPXGYTQAZh+jR/aaSwYaV1HpZ2M/20xcW+6rJSe+T6BBpnB
 hIlDtcIOxv/pL7Q==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Stat-Signature: txhkdg4tzsxurr1msu191humiuzsyebh
X-Rspamd-Queue-Id: 6910680007
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771199032-121389
X-HE-Meta: U2FsdGVkX1+c2bZXDq1bPNWgBix33rqqqmdDHrI1EGrQ1YPmR7MxTPBZyb3qtxLT++AXmwMMSAMC3euH5yhC0eB04+O1+ZymKHNAybNbfeIeNC/j4iN0RwQ59gUAt06+7yhHQfZLghiTL5s87p27jjEUT07fskXIT1KXIImv3TEbzWEEPoEnRLv4CKwc6bOgfM4JRQsis7mEPLrQO/tAkKYXYkz2HEC28KyMeUi1B+1ceNSZEuGxinXE58wnlZfbfbDGSwHoJurH7NzNoDz6uP1/X/fNlw6jyaH7EbY27C+VDRqa6R197WLHRwSKbdWGv/taLVOf3LtntliNxXLS6oHJp5ldFYIP5sDX5QXjrIkWYTSapKvGriYcNVe59PIZbhewTqKIk1VMQNxg9A0RRBiUEbvNGr7LqA8h8yhKGisjJ90IA08C2e1x/jVMgb77NgXSAJIc2UXSsFCyLFxKAAPXL/DfmWYPuFRlPlGoiHeMMhPWp/9cGMunySpgjlohA3Qm4u0Z8h4GJgYTfPF9v5WinSmodgQah6+M05NmEo9dDuY2pN4P8s/vjnwgZVrHsXhW3wmq38D+j3m0ZbrneAHKnZJKmQczhsXXQJDoMIzcTR8b5fuLOnXLgo5ceEXLFSpBiJojg97pie/tJN+o/tRlSsIdvXrmDWT9n4FrRGpJbfB8sbsPM6cg8NVcgAPVumhLS7tyXmHhyCJsTp7rKgX4A/g5AjTuVxkeXFXnLGdgGDYdWYF1G6J5Zqw0OSJcMZtwMupmSEI2KAuzKrAuJnLdiBCZLOgdm2zbW2jLx7mvP7WiXReHOKHxsGCswf1kZsX/r8b6cUWWZcSDBEpQcQ/TX1DY21mJkd/LyS54JWxzBQI0IZzu2uhyBSEMbShehBXMvRXc2t5ELHHEyiaP5wq1dKbYMyCluo9Ar7v+NUaU6t42L+yqo5m+QcTFnQ/6pNVr4xerFkBC2QYSSe9
 j7IFA6xm
 sbDB3RGWjzIzlm+tfrKUscmGYd+jjfLVjCXNoEIxN/88n/rou8aKoGqGx6YS4A4p+CnxVN5TElrWdUUD5tupHm4q52pGG+8lVWWWJEgG8+WvYr/eB+LmNF6KOK7RcWd1rXehNlzHJFjph61JKLiTmo9vNrFvP/W6lfnNXiZGkPMx6+faMVly4fPp0HtIvggrLggbXZ/U4Rjomq3Re8bdPfW70fgWUEXc9jyhiVgt2SX7naTImIok5oRoVkMoHmN2NcRTP1nS85HUL4sI5x/dXbRxRYclYPpDxAbQCKEW5Ccry8BUOoE21ZrUP2+qa+Uoj/on4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add bad_blocks_partial_io configuration option that allows partial I/O
completion when encountering bad blocks, rather than failing the entire
request.

When enabled, requests are truncated to stop before the first bad block
range, allowing the valid portion to be processed successfully. This
improves compatibility with applications that can handle partial
reads/writes.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 drivers/block/rnull/configfs.rs |  32 ++--------
 drivers/block/rnull/rnull.rs    | 125 ++++++++++++++++++++++++++++------------
 2 files changed, 95 insertions(+), 62 deletions(-)

diff --git a/drivers/block/rnull/configfs.rs b/drivers/block/rnull/configfs.rs
index a39691b39e374..c08a3cbd66f18 100644
--- a/drivers/block/rnull/configfs.rs
+++ b/drivers/block/rnull/configfs.rs
@@ -104,6 +104,7 @@ fn make_group(
                 no_sched:11,
                 badblocks: 12,
                 badblocks_once: 13,
+                badblocks_partial_io: 14,
             ],
         };
 
@@ -128,6 +129,7 @@ fn make_group(
                     no_sched: false,
                     bad_blocks: Arc::pin_init(BadBlocks::new(false), GFP_KERNEL)?,
                     bad_blocks_once: false,
+                    bad_blocks_partial_io: false,
                 }),
             }),
             core::iter::empty(),
@@ -189,6 +191,7 @@ struct DeviceConfigInner {
     no_sched: bool,
     bad_blocks: Arc<BadBlocks>,
     bad_blocks_once: bool,
+    bad_blocks_partial_io: bool,
 }
 
 #[vtable]
@@ -226,6 +229,7 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
                 no_sched: guard.no_sched,
                 bad_blocks: guard.bad_blocks.clone(),
                 bad_blocks_once: guard.bad_blocks_once,
+                bad_blocks_partial_io: guard.bad_blocks_partial_io,
             })?);
             guard.powered = true;
         } else if guard.powered && !power_op {
@@ -427,29 +431,5 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
     }
 }
 
-#[vtable]
-impl configfs::AttributeOperations<13> for DeviceConfig {
-    type Data = DeviceConfig;
-
-    fn show(this: &DeviceConfig, page: &mut [u8; PAGE_SIZE]) -> Result<usize> {
-        let mut writer = kernel::str::Formatter::new(page);
-
-        if this.data.lock().bad_blocks_once {
-            writer.write_str("1\n")?;
-        } else {
-            writer.write_str("0\n")?;
-        }
-
-        Ok(writer.bytes_written())
-    }
-
-    fn store(this: &DeviceConfig, page: &[u8]) -> Result {
-        if this.data.lock().powered {
-            return Err(EBUSY);
-        }
-
-        this.data.lock().bad_blocks_once = kstrtobool_bytes(page)?;
-
-        Ok(())
-    }
-}
+configfs_simple_bool_field!(DeviceConfig, 13, bad_blocks_once);
+configfs_simple_bool_field!(DeviceConfig, 14, bad_blocks_partial_io);
diff --git a/drivers/block/rnull/rnull.rs b/drivers/block/rnull/rnull.rs
index 0f569c5b65f77..6691e5912c5c9 100644
--- a/drivers/block/rnull/rnull.rs
+++ b/drivers/block/rnull/rnull.rs
@@ -162,6 +162,7 @@ fn init(_module: &'static ThisModule) -> impl PinInit<Self, Error> {
                     no_sched: *module_parameters::no_sched.value() != 0,
                     bad_blocks: Arc::pin_init(BadBlocks::new(false), GFP_KERNEL)?,
                     bad_blocks_once: false,
+                    bad_blocks_partial_io: false,
                 })?;
                 disks.push(disk, GFP_KERNEL)?;
             }
@@ -190,6 +191,7 @@ struct NullBlkOptions<'a> {
     no_sched: bool,
     bad_blocks: Arc<BadBlocks>,
     bad_blocks_once: bool,
+    bad_blocks_partial_io: bool,
 }
 struct NullBlkDevice;
 
@@ -209,6 +211,7 @@ fn new(options: NullBlkOptions<'_>) -> Result<GenDisk<Self>> {
             no_sched,
             bad_blocks,
             bad_blocks_once,
+            bad_blocks_partial_io,
         } = options;
 
         let mut flags = mq::tag_set::Flags::default();
@@ -239,6 +242,7 @@ fn new(options: NullBlkOptions<'_>) -> Result<GenDisk<Self>> {
                 block_size: block_size.into(),
                 bad_blocks,
                 bad_blocks_once,
+                bad_blocks_partial_io,
             }),
             GFP_KERNEL,
         )?;
@@ -327,16 +331,62 @@ fn discard(tree: &Tree, mut sector: u64, sectors: u64, block_size: u64) -> Resul
     }
 
     #[inline(never)]
-    fn transfer(
-        command: bindings::req_op,
-        tree: &Tree,
-        sector: u64,
-        segment: Segment<'_>,
+    fn transfer(rq: &mut Owned<mq::Request<Self>>, tree: &Tree, sectors: u32) -> Result {
+        let mut sector = rq.sector();
+        let end_sector = sector + <u32 as Into<u64>>::into(sectors);
+        let command = rq.command();
+
+        for bio in rq.bio_iter_mut() {
+            let segment_iter = bio.segment_iter();
+            for segment in segment_iter {
+                // Length might be limited by bad blocks.
+                let length = segment
+                    .len()
+                    .min((sector - end_sector) as u32 >> SECTOR_SHIFT);
+                match command {
+                    bindings::req_op_REQ_OP_WRITE => Self::write(tree, sector, segment)?,
+                    bindings::req_op_REQ_OP_READ => Self::read(tree, sector, segment)?,
+                    _ => (),
+                }
+                sector += u64::from(length) >> SECTOR_SHIFT;
+
+                if sector >= end_sector {
+                    return Ok(());
+                }
+            }
+        }
+        Ok(())
+    }
+
+    fn handle_bad_blocks(
+        rq: &mut Owned<mq::Request<Self>>,
+        queue_data: &QueueData,
+        sectors: &mut u32,
     ) -> Result {
-        match command {
-            bindings::req_op_REQ_OP_WRITE => Self::write(tree, sector, segment)?,
-            bindings::req_op_REQ_OP_READ => Self::read(tree, sector, segment)?,
-            _ => (),
+        if queue_data.bad_blocks.enabled() {
+            let start = rq.sector();
+            let end = start + u64::from(*sectors);
+            match queue_data.bad_blocks.check(start..end) {
+                badblocks::BlockStatus::None => {}
+                badblocks::BlockStatus::Acknowledged(mut range)
+                | badblocks::BlockStatus::Unacknowledged(mut range) => {
+                    rq.data_ref().error.store(1, ordering::Relaxed);
+
+                    if queue_data.bad_blocks_once {
+                        queue_data.bad_blocks.set_good(range.clone())?;
+                    }
+
+                    if queue_data.bad_blocks_partial_io {
+                        let block_size_sectors = queue_data.block_size >> SECTOR_SHIFT;
+                        range.start = align_down(range.start, block_size_sectors);
+                        if start < range.start {
+                            *sectors = (range.start - start) as u32;
+                        }
+                    } else {
+                        *sectors = 0;
+                    }
+                }
+            };
         }
         Ok(())
     }
@@ -398,6 +448,7 @@ struct QueueData {
     block_size: u64,
     bad_blocks: Arc<BadBlocks>,
     bad_blocks_once: bool,
+    bad_blocks_partial_io: bool,
 }
 
 #[pin_data]
@@ -426,6 +477,30 @@ impl HasHrTimer<Self> for Pdu {
     }
 }
 
+fn is_power_of_two<T>(value: T) -> bool
+where
+    T: core::ops::Sub<T, Output = T>,
+    T: core::ops::BitAnd<Output = T>,
+    T: core::cmp::PartialOrd<T>,
+    T: Copy,
+    T: From<u8>,
+{
+    (value > 0u8.into()) && (value & (value - 1u8.into())) == 0u8.into()
+}
+
+fn align_down<T>(value: T, to: T) -> T
+where
+    T: core::ops::Sub<T, Output = T>,
+    T: core::ops::Not<Output = T>,
+    T: core::ops::BitAnd<Output = T>,
+    T: core::cmp::PartialOrd<T>,
+    T: Copy,
+    T: From<u8>,
+{
+    debug_assert!(is_power_of_two(to));
+    value & !(to - 1u8.into())
+}
+
 #[vtable]
 impl Operations for NullBlkDevice {
     type QueueData = Pin<KBox<QueueData>>;
@@ -444,39 +519,17 @@ fn queue_rq(
         mut rq: Owned<mq::Request<Self>>,
         _is_last: bool,
     ) -> Result {
-        if queue_data.bad_blocks.enabled() {
-            let start = rq.sector();
-            let end = start + u64::from(rq.sectors());
-            match queue_data.bad_blocks.check(start..end) {
-                badblocks::BlockStatus::None => {}
-                badblocks::BlockStatus::Acknowledged(range)
-                | badblocks::BlockStatus::Unacknowledged(range) => {
-                    rq.data_ref().error.store(1, ordering::Relaxed);
-                    if queue_data.bad_blocks_once {
-                        queue_data.bad_blocks.set_good(range)?;
-                    }
-                }
-            };
-        }
+        let mut sectors = rq.sectors();
 
-        // TODO: Skip IO if bad block.
+        Self::handle_bad_blocks(&mut rq, queue_data.get_ref(), &mut sectors)?;
 
         if queue_data.memory_backed {
             let tree = &queue_data.tree;
-            let command = rq.command();
-            let mut sector = rq.sector();
 
-            if command == bindings::req_op_REQ_OP_DISCARD {
-                Self::discard(tree, sector, rq.sectors().into(), queue_data.block_size)?;
+            if rq.command() == bindings::req_op_REQ_OP_DISCARD {
+                Self::discard(tree, rq.sector(), sectors.into(), queue_data.block_size)?;
             } else {
-                for bio in rq.bio_iter_mut() {
-                    let segment_iter = bio.segment_iter();
-                    for segment in segment_iter {
-                        let length = segment.len();
-                        Self::transfer(command, tree, sector, segment)?;
-                        sector += u64::from(length) >> block::SECTOR_SHIFT;
-                    }
-                }
+                Self::transfer(&mut rq, tree, sectors)?;
             }
         }
 

-- 
2.51.2



