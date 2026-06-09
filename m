Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CD68CD8CB2
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:12:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EEDD6B00B3; Tue,  9 Jun 2026 15:12:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A0656B00B4; Tue,  9 Jun 2026 15:12:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B5A86B00B5; Tue,  9 Jun 2026 15:12:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 58E556B00B3
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:12:01 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1CA531C27F0
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:12:01 +0000 (UTC)
X-FDA: 84861319242.30.FF2D100
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4B7CD40016
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:11:59 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HbkJriII;
	spf=pass (imf04.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781032319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IkD0QE1JNG+5G4E9lQ6Nh6HgjvnmUhj4qhwVEK7b4Kw=;
	b=32ijgScgmARrGwKXfrngeNYHmiDJbtM0hHtLXZbqRGPcQf7qhYq9dSKGiRyrdDR6yBzRt1
	k/Xx56EGlQ1NisFCUzaK0E1mfvrWQjUKyeVob8ZDS/DuejqTCS3AecwJ6VAeYbF4QYK6El
	4y5pV7zJtPCKzV9j9S6LQnnH+9ZzdZs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HbkJriII;
	spf=pass (imf04.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781032319;
	b=JmN0psauBjJNfjkC/SrE5KBzf8CNKfvD0TA4QICx7++BCetyqDRS7BRgSaOTb5X9nFUkJM
	TaSSW7eM4jBAHG9oTn6qAA6hhCPK/YI/zsSthUKvdoX3fNAByi868jRuhLjwNIAe3tvCKb
	H6ok/4Pn4LDFTx0Nw5HVt+2HtBTe71o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 94B2D43BBB;
	Tue,  9 Jun 2026 19:11:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8EE11F00898;
	Tue,  9 Jun 2026 19:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781032318;
	bh=IkD0QE1JNG+5G4E9lQ6Nh6HgjvnmUhj4qhwVEK7b4Kw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=HbkJriII3mozpClgOgi65m6h2a4N5QW7igQRqNhtcRg/1/9VCyekam92oxNs83Vv2
	 8ZvF5ZsjHQnVxNDCtEQdRGKyzgJ3/iPPhkHsDnJO+d61HEqeSOpIM+myPDxNVkTr+A
	 A5e2liydG4NK1SLts+w88+lMJ0AErM2/Q16rZP4xSQYJv0CKTs6i8cLvXKWT6uJYCR
	 eM5CSuk0AtUQk0qW2NMFSjq8VMNMyRNP/XsYZZKEME84eDwrVSf+OgloaEqROe8fah
	 gCpp5t3MPXJ+StljDASOVhFgkcGDd514WrNe5/cHXTO8/VK95jGEbXiwFKKzldxg/b
	 +92RzJ2tyv7ew==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 09 Jun 2026 21:07:55 +0200
Subject: [PATCH v2 16/83] block: rnull: add memory backing
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-rnull-v6-19-rc5-send-v2-16-82c7404542e2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=9051; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=5tWrOfwAoTdtiugODrPJwqvRH5XTpwTVzL/RkoxFmKQ=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqKGTDlpQLAb1Gdie0mQdmixKF/RmwXPiQ/Q1mE
 yviretqzF+JAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaihkwwAKCRD6UCkIqsW9
 0E5BD/kBzAHZRaW7Q6j0G0U3xNqihtUwFAbCJwp+84ZCx2vnJuP6bH2v801ATOF/7Ik6Gips0mP
 +46GLnccPBOI5WabhrpnL2CZ2ZSDBbGUoOm2v2n8HsGRyh61KptIriN+blMlb9soc+VrzGNW1To
 g1B1kBaqYTeVEAPC8iJ5gYzcZTmEwNEIYkHEwT4DlU+OBQpA8/+2cMyJuWrIHXBKe3/z7LgcdnP
 VFkuPPsHkxklFDpZDCuCWYRH4wKwx4kn3XToD8jS7B4AFDlh4eDimVOzFOr33BnmbPceBK+zQon
 bBhjFJH4D6gbSmcZ/uCBYq1aPS4Vj3grlTBCX/KmBfBAY3+VJB5i4cuB/am8pIR+CF1J/8JbS6a
 SO10KADB1axzJrNZLOTOOKQpzRWNvqu7eFtAgdnxkeqaa4Wg4iyrJzvFJSSe1mDYzMYAj2WJOOj
 1uXy8L1k6bYhn16XKayO5bwak8fjQMHOpFUAj6HKxLIXMqRDx3emfaDqNTndTkKYQGaf+drMJh6
 xhn5HyA7xZdrkfBE5n/gQ9j37eojuawnQPcEiGQfIAWuBVX9aFgv/BT5u07a4pD+Z/CBrpOdpDr
 VTPbIr3B7RLh0Z/hJrmf31ZOEUxysfmNaWOSxYcaPC5gBdCXlYfbJjrWvId0h+DW6PVqkl9a0Pb
 cmr4YJ0LMImhP7w==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4B7CD40016
X-Stat-Signature: 4infi4qxe67uo817xj6xex6pywkcc6mf
X-Rspam-User: 
X-HE-Tag: 1781032319-913780
X-HE-Meta: U2FsdGVkX1+k0LdTGwbD9DYfXlr0vAoKm/wOw6cU6sAR7DQw/jvIAVfRuZPZxDMJYuMwqAtKF+EA3IT/cAzS8Ji23iZpV3UV/oDw0raWKCEA4ycknTj5xsWwSp5bWFnHR7Xq8yykW38AwzP8tfORFO3ydZ+67WaS6gFngmCOnvFIRRqcpnMQbxgTnNIWdrHhDydDMA8Yef++xsouG1teFbpG1taAV6yejAUgbfCsVZiyD8dT8vorTlU25uSNR4hsDg8z23FIMPi74YjSt/RLBKvcLbh9zxDnZQI+fZ3rac5Euv4iAS79TtMYxNvzyDvqYTW4L0Od1ieW6RTrAx0ufsteoeDcVDhrwnVm4183h9xa2YzxB4mYHBohEGJL1wDtgYE9R4XLl2Xde+4+U01iSqyPNeBsfJlQTaPRCD+8Eup5drNd9B7NyacOEDvPRx6v0K5D7jgeofYgu9Ug8InEOe/1hFScxG8Jnx8kxsGgrG+GThUE8HnMMFBZ+B79BeLTspYi8+P7thpQHnad2N5ZEkaOS0NmJCzJIcQqVSTyRUPrhJG591EKvqUEKzc0SwbPmH/BJTOFJN/RGcbkeNKchlQ6o/Fw7YJ1+nB27Ig16soJPXrCI7H/FFsw/tFVuQ64p2gFJdc1kGEgLHNCvsaZ8POQ5sUbgw8AGaBYzpjOUFvNTv9L2tVYU330cChCePBG4N9wAr7w9C2jvCC0BFgeAsqMcB7/B2i8BwuGevEPf3EDVjZ9TNeeBRyd1Q8wU40fcZuxSMEZWrdHPIwWQLihfa7hnlxigU/QrUTVqV/32a4NDvctVhwN1Pxf1mXTmBlsejTN9deARYMpT2PGaPzeRP6qMKcmX+fNT277fS128SP6ghCs7Fb253wRILo/Fmz5Y74p+YcqzrOI8OSL3UDkCBwvFdVCD8y1eIqOJJ+eAtunTRzbUG5gGer9chzRPs0pAfb3qfFHSZZ7jl8m04o
 ba+zZLKg
 sutV71HEHRsOqREiEcgGE9X/wbWolWZ7Qg04vGcVtSqhHTzHzV7VZJRXzcDpIjtCbb0Ap+XNEV8+TVxuIpPMermjZUxJwfUr4oco5I6A5+vu98++8sO+F+BqmyM14mKkNUTcCEIVNJmt5UoFox/jhQbL9aUnSuueZBkNIf6Rv7CouhNsSteIGi++SlQF4muQHAEVFAXfIiaw9Z1o01W8Xqq+j9BqU0ofYfByE8QxQHGkajDDbN0Oi0cIsc+x5BBnQriWgaI3vKqcblHwR41DKZLuy2hh99m5njVsCe4pnwH798xGUHPJ54rRbSZxs5Hkua8T3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add memory backing to the rust null block driver. This implementation will
always allocate a page on write, even though a page backing the written
sector is already allocated, in which case the page will be released again.
A later patch will fix this inefficiency.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 drivers/block/rnull/configfs.rs |   8 ++-
 drivers/block/rnull/rnull.rs    | 126 ++++++++++++++++++++++++++++++++++------
 2 files changed, 116 insertions(+), 18 deletions(-)

diff --git a/drivers/block/rnull/configfs.rs b/drivers/block/rnull/configfs.rs
index 83b474f6da60..8daf2ca409ba 100644
--- a/drivers/block/rnull/configfs.rs
+++ b/drivers/block/rnull/configfs.rs
@@ -60,7 +60,7 @@ impl AttributeOperations<0> for Config {
 
     fn show(_this: &Config, page: &mut [u8; PAGE_SIZE]) -> Result<usize> {
         let mut writer = kernel::str::Formatter::new(page);
-        writer.write_str("blocksize,size,rotational,irqmode,completion_nsec\n")?;
+        writer.write_str("blocksize,size,rotational,irqmode,completion_nsec,memory_backed\n")?;
         Ok(writer.bytes_written())
     }
 }
@@ -84,6 +84,7 @@ fn make_group(
                 size: 3,
                 irqmode: 4,
                 completion_nsec: 5,
+                memory_backed: 6,
             ],
         };
 
@@ -101,6 +102,7 @@ fn make_group(
                     irq_mode: IRQMode::None,
                     completion_time: time::Delta::ZERO,
                     name: name.try_into()?,
+                    memory_backed: false,
                 }),
             }),
             core::iter::empty(),
@@ -165,6 +167,7 @@ struct DeviceConfigInner {
     irq_mode: IRQMode,
     completion_time: time::Delta,
     disk: Option<GenDisk<NullBlkDevice>>,
+    memory_backed: bool,
 }
 
 #[vtable]
@@ -195,6 +198,7 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
                 guard.capacity_mib,
                 guard.irq_mode,
                 guard.completion_time,
+                guard.memory_backed,
             )?);
             guard.powered = true;
         } else if guard.powered && !power_op {
@@ -226,3 +230,5 @@ fn from_str(s: &str) -> Result<Self> {
         value.try_into()
     }
 }
+
+configfs_simple_bool_field!(DeviceConfig, 6, memory_backed);
diff --git a/drivers/block/rnull/rnull.rs b/drivers/block/rnull/rnull.rs
index 746ddadd11f0..8e4d2b270bcf 100644
--- a/drivers/block/rnull/rnull.rs
+++ b/drivers/block/rnull/rnull.rs
@@ -6,8 +6,10 @@
 
 use configfs::IRQMode;
 use kernel::{
+    bindings,
     block::{
         self,
+        bio::Segment,
         mq::{
             self,
             gen_disk::{
@@ -19,15 +21,12 @@
         },
     },
     error::Result,
-    new_mutex,
+    memalloc_scope, new_mutex, new_xarray,
+    page::SafePage,
     pr_info,
     prelude::*,
     str::CString,
-    sync::{
-        aref::ARef,
-        Arc,
-        Mutex, //
-    },
+    sync::{aref::ARef, Arc, Mutex},
     time::{
         hrtimer::{
             HrTimerCallback,
@@ -40,7 +39,8 @@
     types::{
         OwnableRefCounted,
         Owned, //
-    }, //
+    },
+    xarray::XArray,
 };
 
 module! {
@@ -74,6 +74,10 @@
             default: 10_000,
             description:  "Time in ns to complete a request in hardware. Default: 10,000ns",
         },
+        memory_backed: bool {
+            default: false,
+            description: "Create a memory-backed block device.",
+        },
     },
 }
 
@@ -103,6 +107,7 @@ fn init(_module: &'static ThisModule) -> impl PinInit<Self, Error> {
                     module_parameters::gb.value() * 1024,
                     module_parameters::irqmode.value().try_into()?,
                     Delta::from_nanos(completion_time),
+                    module_parameters::memory_backed.value(),
                 )?;
                 disks.push(disk, GFP_KERNEL)?;
             }
@@ -127,17 +132,23 @@ fn new(
         capacity_mib: u64,
         irq_mode: IRQMode,
         completion_time: Delta,
+        memory_backed: bool,
     ) -> Result<GenDisk<Self>> {
-        let tagset = Arc::pin_init(
-            TagSet::new(1, 256, 1, mq::tag_set::Flags::default()),
-            GFP_KERNEL,
-        )?;
+        let flags = if memory_backed {
+            mq::tag_set::Flag::Blocking.into()
+        } else {
+            mq::tag_set::Flags::default()
+        };
+
+        let tagset = Arc::pin_init(TagSet::new(1, 256, 1, flags), GFP_KERNEL)?;
 
-        let queue_data = Box::new(
-            QueueData {
+        let queue_data = Box::pin_init(
+            pin_init!(QueueData {
+                tree <- new_xarray!(kernel::xarray::AllocKind::Alloc),
                 irq_mode,
                 completion_time,
-            },
+                memory_backed,
+            }),
             GFP_KERNEL,
         )?;
 
@@ -148,11 +159,72 @@ fn new(
             .rotational(rotational)
             .build(fmt!("{}", name.to_str()?), tagset, queue_data)
     }
+
+    #[inline(always)]
+    fn write(tree: &XArray<TreeNode>, mut sector: usize, mut segment: Segment<'_>) -> Result {
+        while !segment.is_empty() {
+            let page = SafePage::alloc_page(GFP_KERNEL)?;
+            let mut tree = tree.lock();
+
+            let page_idx = sector >> block::PAGE_SECTORS_SHIFT;
+
+            let page = if let Some(page) = tree.get_mut(page_idx) {
+                page
+            } else {
+                tree.store(page_idx, page, GFP_KERNEL)?;
+                tree.get_mut(page_idx).unwrap()
+            };
+
+            let page_offset = (sector & block::PAGE_SECTOR_MASK as usize) << block::SECTOR_SHIFT;
+            sector += segment.copy_to_page(page, page_offset) >> block::SECTOR_SHIFT;
+        }
+        Ok(())
+    }
+
+    #[inline(always)]
+    fn read(tree: &XArray<TreeNode>, mut sector: usize, mut segment: Segment<'_>) -> Result {
+        let tree = tree.lock();
+
+        while !segment.is_empty() {
+            let idx = sector >> block::PAGE_SECTORS_SHIFT;
+
+            if let Some(page) = tree.get(idx) {
+                let page_offset =
+                    (sector & block::PAGE_SECTOR_MASK as usize) << block::SECTOR_SHIFT;
+                sector += segment.copy_from_page(page, page_offset) >> block::SECTOR_SHIFT;
+            } else {
+                sector += segment.zero_page() >> block::SECTOR_SHIFT;
+            }
+        }
+
+        Ok(())
+    }
+
+    #[inline(never)]
+    fn transfer(
+        command: bindings::req_op,
+        tree: &XArray<TreeNode>,
+        sector: usize,
+        segment: Segment<'_>,
+    ) -> Result {
+        match command {
+            bindings::req_op_REQ_OP_WRITE => Self::write(tree, sector, segment)?,
+            bindings::req_op_REQ_OP_READ => Self::read(tree, sector, segment)?,
+            _ => (),
+        }
+        Ok(())
+    }
 }
 
+type TreeNode = Owned<SafePage>;
+
+#[pin_data]
 struct QueueData {
+    #[pin]
+    tree: XArray<TreeNode>,
     irq_mode: IRQMode,
     completion_time: Delta,
+    memory_backed: bool,
 }
 
 #[pin_data]
@@ -182,7 +254,7 @@ impl HasHrTimer<Self> for Pdu {
 
 #[vtable]
 impl Operations for NullBlkDevice {
-    type QueueData = KBox<QueueData>;
+    type QueueData = Pin<KBox<QueueData>>;
     type RequestData = Pdu;
 
     fn new_request_data() -> impl PinInit<Self::RequestData> {
@@ -192,7 +264,27 @@ fn new_request_data() -> impl PinInit<Self::RequestData> {
     }
 
     #[inline(always)]
-    fn queue_rq(queue_data: &QueueData, rq: Owned<mq::Request<Self>>, _is_last: bool) -> Result {
+    fn queue_rq(
+        queue_data: Pin<&QueueData>,
+        mut rq: Owned<mq::Request<Self>>,
+        _is_last: bool,
+    ) -> Result {
+        if queue_data.memory_backed {
+            memalloc_scope!(let _noio: NoIo);
+            let tree = &queue_data.tree;
+            let command = rq.command();
+            let mut sector = rq.sector();
+
+            for bio in rq.bio_iter_mut() {
+                let segment_iter = bio.segment_iter();
+                for segment in segment_iter {
+                    let length = segment.len();
+                    Self::transfer(command, tree, sector, segment)?;
+                    sector += length as usize >> block::SECTOR_SHIFT;
+                }
+            }
+        }
+
         match queue_data.irq_mode {
             IRQMode::None => rq.end_ok(),
             IRQMode::Soft => mq::Request::complete(rq.into()),
@@ -205,7 +297,7 @@ fn queue_rq(queue_data: &QueueData, rq: Owned<mq::Request<Self>>, _is_last: bool
         Ok(())
     }
 
-    fn commit_rqs(_queue_data: &QueueData) {}
+    fn commit_rqs(_queue_data: Pin<&QueueData>) {}
 
     fn complete(rq: ARef<mq::Request<Self>>) {
         OwnableRefCounted::try_from_shared(rq)

-- 
2.51.2



