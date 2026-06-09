Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DE38CD8CB2
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:10:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72B196B008A; Tue,  9 Jun 2026 15:10:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 701FA6B008C; Tue,  9 Jun 2026 15:10:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 617EF6B0092; Tue,  9 Jun 2026 15:10:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4ED136B008A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:10:37 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F025F1A0764
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:10:36 +0000 (UTC)
X-FDA: 84861315672.01.2777A18
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1E06D40011
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:10:34 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DHfR6GEK;
	spf=pass (imf12.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781032235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n7KJ52vVknn+HZxloD2rw0BcCGYGEtC34QZpg9ZQ/io=;
	b=tPmCqCxdBbMJHpi4B1G/kKrzlooosQ6/nBVyZfoODr66+IP4gbnmHw/Z6hAlVwSIkW4KV4
	Ym4u7mAISRGmOmr2hwiJO2ZFI98O1pPaAj8kENprwV/UXvkNBgtW0MeKBVwhzmocSiIvfg
	qPSa0vqICMO7PDV+dj7gTsKLU50yxLc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DHfR6GEK;
	spf=pass (imf12.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781032235;
	b=JiObCg3cV1JfopDV2S4OJMbsX81vb05JwDZwPG58USWPwjkzRWFBQL8OZSEGWIznh6K56i
	HGR0yZ7nK2ksudawfVw9blySr/Qf6gnpvxngGJ8iXEJvwqAgDi30hA3LM1vipxMfv33xsG
	Tn+2uq1320m9HVpzeNfHDoWf+cX7F0c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 57A7241A75;
	Tue,  9 Jun 2026 19:10:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F3181F00893;
	Tue,  9 Jun 2026 19:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781032234;
	bh=n7KJ52vVknn+HZxloD2rw0BcCGYGEtC34QZpg9ZQ/io=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=DHfR6GEKhSRqH51YDspmHwYVmBeWfn0CFJ/sAWvISIn+W4A9qsA7B1nseHmI9fiHF
	 fZ006O6symB4+yUn2j81GvONJQmwZxHnj/cLWbXxYDvferpNv0TrcPzwvhEVsyeaI7
	 DJ+2svd/J2oDkl4QLUXMSlIBwsrmmUp/uPc+Os7h/VPVSd31f9NoRnMFMSubPoszuA
	 SRfRxPag60Tu/3j905lr8UWXI3WTFD/IK8qMW6Itr4ZBTB4ryLxVIoHVfytCuBFdhf
	 aJknQP6B8UQBj+JRBnRcvEBmZWcBnsTCNNNHkwYHwiGKnaZc+i1TYX/J1jzkOvYm6y
	 8jVegc5ufeA4g==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 09 Jun 2026 21:08:49 +0200
Subject: [PATCH v2 70/83] block: rnull: support queue_rqs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-rnull-v6-19-rc5-send-v2-70-82c7404542e2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=12569;
 i=a.hindborg@kernel.org; h=from:subject:message-id;
 bh=HAe34xfCsUoHt6x/RPtlMZRmBGzEmDCCiUB3Z6xwSqQ=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqKGT0dEhhxLsMeCG5/JhmGIrhDtwxcH+HffVaZ
 VUvAm0Dw4qJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaihk9AAKCRD6UCkIqsW9
 0Nr4D/9RKrd5HFQ7814Jyv+pbynsFomOHkYK6cDSuf2Vza5IIU7h6Ha59MUhEldPZvuKHYS/b0w
 Ak6vgufUIxiEU1Rw3BQtOyBRrwvHuJrMS6+g6MVJ53nlr4tPdnEQzI5fUGg6NmXH7e8UaSZFqNF
 o5fYoOcFgfeP/7HiusbwsMOeFcKG3hqKCFfOLwE0MFKJDYXpStrl3RTttqlvDugrHB2jiFLoyEk
 tHd91XqBTKqvDf5rlHWRO0096yLfkoSROlBMwOWeu5VgAQfaSvMXLbiMJFc6jb2I48SjxsGomk4
 cKT6ggfDBWvWKQQ+u1+tzez4mswknQrIx5ndWVD6xVUSomSnkgMHDI350YFsWWKYFPCygsYlUpV
 /lT6rdCcL3qoD+Z2iJRbH8XeyOOXXI+7lEXEQOI2yAfHrg77SRux0KCIcR9lRNXu1gxsLfsJdoh
 67yj+m+biE+807KtgYaYe3Ohf5/J0gAyAhcSMXDJsAAhBDSgzlVkKNZ0T9oW+6N/onQ0HXSwfHv
 uLDNeF7aU3ulKhQIQ0bOFyqHNGAUtxiZdVdSbHIb5g3g0P6YOUyG/mZRNkfwsIUGdz2IQepDAo1
 xLKtyh5y1oS2pL/sXZxAlok8wWtLhVfFOWZcLVQ0D6Mvdm0f43pYuY/jhS7e7plZqvND7ji1uBB
 hmuxkWh6ftahgbw==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Queue-Id: 1E06D40011
X-Stat-Signature: p6eqr7b89gkwqt5zmrdyi75wqqe7xhdq
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781032234-487328
X-HE-Meta: U2FsdGVkX19beHQNt71MMpNlnKL0WePiajmImDXnZxRHIaHSch/ba3oTp/fJT2RUWU6P7TAbGsmGGfhS4xoOId1dNqbFDn9eLtl27/cAV9W4xt8jSvln+4YKqVK3w1dBDciSRsUguCo5LdSAtt8Rk7vcldYu7r5HlTRoGL1fICdUdmsyrzBBLULsMn13JIzVtYHN9AbjOUbDyUMc1j+nEjTIyN0BOHZvg2gfmUGnY2V93xR7tbs5YkZ1m/WYtShyeCRfDy68SqTGh1YCxQSNCjr86zTCeX/I4vWZExvwB+qtbTrwIbd0UmF1b9aGDolE/2YXcfFUmycPjoO+s5zZmLJUWVF2UfbP8HdW/JDTedHuzchawlY2hSlj0EVvo15JPlS6AUomCo3B32iOf8dNRXv8ezIc09bd9X+8yrpNR6UWPmBuM/QNxn+pzrJHBZ+hxq+e3vLEfLCkgTJiweVfNIjYnyyqlI4lsTMePCc8TS3/2H2jIM354YGOBM7f0eNCLm8EK2/fDBm1Nbm7c/0Vk2QSLELKbh32FVDUMmyK250bXhwCNkNCq2Xl+BSyFXMX3F74oSt2SDmg/mnz4LbR+6w6XRyAVHZgcTvIS51M3h4xd8eXRdp4Pa3ulnf/x1JIyXWI6/HCGWg9eahwrgmf/eTRrRsM4FtSDLOJo24KJfUpolFTpzAIWw7o12kIyuzhN6xv55OeSG+UeNbksX1e+6QTQldiveGD8iwYI7RiGeFn/F4BYnrd9tmWfLslGwGJ0BMYVYtkhooMt8VeCbLeE4JQR7/pKudKvcIiByXWgH49IAihBz7iyxY0A+5TiMBozrxDJjhDOj/44wjbdZdZrW8W6vzDmDlqLr6Yt/b/as2DicGA0RPxnuOpCOhXWtJvbDW2H6m76uNs8ZJJX3ypRs2wwigcTuYVDUoQ+lWjnunzYCCL1O4/L5ZT+zUnV9r1QMohaJW4vMSKgqZF8qR
 uhfGJ61d
 X6av2Pb8q2Lr1I/a2D/j1WIcAnMBwUsLjIskWg8jmOqX/JLIP/4wAvWpxBE4ZjTxhiZxqXZMfJODPFuoLw7t37Usi5BjrIJ23pzFKUZYz/taynuq1056f3wbbRs75wF1ru+B3FUXFNgyRB0awTB7HwEPIaPmp1oQemJQ+P+hK8CWrx3EiSN/s2q9ot5NwpM532LmqDo4mcIZc59QsSChrEc+nyfwHSO7PPtHsDgQkNOFA+Pa+cWaf16WP4Dwk2HPMEzO7FFOa6+0aUkCt/DHhaAXRM0Mi8eG4vhzW89FrgxVwDa8eaPqZizCl2uzV8Jxd8qZue0CllCI/r0HyqLs3cw466OhBuHr0jiJeKr3moOHYFwB6mzbUtbzqKw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement the `queue_rqs` callback for rnull, allowing the block layer
to submit multiple requests in a single call. This improves performance
by reducing per-request overhead and enabling batch processing.

The implementation processes requests from the list one at a time,
removing successfully processed requests from the list.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 drivers/block/rnull/disk_storage.rs |  36 ++++----
 drivers/block/rnull/rnull.rs        | 180 +++++++++++++++++++++++-------------
 2 files changed, 133 insertions(+), 83 deletions(-)

diff --git a/drivers/block/rnull/disk_storage.rs b/drivers/block/rnull/disk_storage.rs
index 4a9bf480221f..6797b7996da3 100644
--- a/drivers/block/rnull/disk_storage.rs
+++ b/drivers/block/rnull/disk_storage.rs
@@ -86,7 +86,7 @@ pub(crate) fn discard(
         }
     }
 
-    pub(crate) fn flush(&self, hw_data: &Pin<&SpinLock<HwQueueContext>>) -> Result {
+    pub(crate) fn flush(&self, hw_data: &Pin<&SpinLock<HwQueueContext>>) {
         let mut tree_guard = self.lock();
         let mut hw_data_guard = hw_data.lock();
         let mut access = self.access(&mut tree_guard, &mut hw_data_guard, None);
@@ -131,7 +131,7 @@ fn to_sector(index: usize) -> u64 {
         (index << block::PAGE_SECTORS_SHIFT) as u64
     }
 
-    fn extract_cache_page(&mut self) -> Result<Option<KBox<NullBlockPage>>> {
+    fn extract_cache_page(&mut self) -> Option<KBox<NullBlockPage>> {
         Self::extract_cache_page_inner(
             &mut self.cache_guard,
             &mut self.disk_guard,
@@ -147,16 +147,10 @@ fn extract_cache_page_inner<'g>(
         disk_storage: &DiskStorage,
         hw_data: &mut HwQueueContext,
         sheaf: Option<&mut XArraySheaf<'_>>,
-    ) -> Result<Option<KBox<NullBlockPage>>> {
+    ) -> Option<KBox<NullBlockPage>> {
         let cache_entry = cache_guard.find_next_entry_circular(
             disk_storage.next_flush_sector.load(ordering::Relaxed) as usize,
-        );
-
-        let cache_entry = if let Some(entry) = cache_entry {
-            entry
-        } else {
-            return Ok(None);
-        };
+        )?;
 
         let index = cache_entry.index();
 
@@ -183,11 +177,14 @@ fn extract_cache_page_inner<'g>(
                     let mut src = cache_entry;
                     let mut offset = 0;
                     for _ in 0..PAGE_SECTORS {
-                        src.page_mut().as_pin_mut().copy_to_page(
-                            disk_entry.page_mut().as_pin_mut(),
-                            offset,
-                            block::SECTOR_SIZE as usize,
-                        )?;
+                        src.page_mut()
+                            .as_pin_mut()
+                            .copy_to_page(
+                                disk_entry.page_mut().as_pin_mut(),
+                                offset,
+                                block::SECTOR_SIZE as usize,
+                            )
+                            .expect("Write to succeed");
                         offset += block::SECTOR_SIZE as usize;
                     }
                     src.remove()
@@ -197,16 +194,15 @@ fn extract_cache_page_inner<'g>(
             }
         };
 
-        Ok(Some(page))
+        Some(page)
     }
 
-    fn flush(&mut self) -> Result {
+    fn flush(&mut self) {
         if self.disk_storage.cache_size > 0 {
-            while let Some(page) = self.extract_cache_page()? {
+            while let Some(page) = self.extract_cache_page() {
                 drop(page);
             }
         }
-        Ok(())
     }
 
     fn get_or_alloc_cache_page(&mut self, sector: u64) -> Result<&mut NullBlockPage> {
@@ -230,7 +226,7 @@ fn get_or_alloc_cache_page(&mut self, sector: u64) -> Result<&mut NullBlockPage>
                         self.disk_storage,
                         self.hw_data_guard,
                         self.sheaf.as_mut(),
-                    )?
+                    )
                     .expect("Expected to find a page in the cache")
                 };
                 let xarray::Entry::Vacant(vacant_entry) = cache_guard.entry(index) else {
diff --git a/drivers/block/rnull/rnull.rs b/drivers/block/rnull/rnull.rs
index 6653db5c069b..32af69bbf8f0 100644
--- a/drivers/block/rnull/rnull.rs
+++ b/drivers/block/rnull/rnull.rs
@@ -28,7 +28,7 @@
             BadBlocks, //
         },
         bio::Segment,
-        error::BlkResult,
+        error::{BlkError, BlkResult},
         mq::{
             self,
             gen_disk::{
@@ -36,8 +36,10 @@
                 GenDisk,
                 GenDiskRef, //
             },
+            IdleRequest,
             IoCompletionBatch,
             Operations,
+            RequestList,
             TagSet, //
         },
         SECTOR_SHIFT,
@@ -773,6 +775,104 @@ fn complete_request(&self, rq: Owned<mq::Request<Self>>) {
             }
         }
     }
+
+    #[inline(always)]
+    fn queue_rq_internal(
+        hw_data: Pin<&SpinLock<HwQueueContext>>,
+        this: ArcBorrow<'_, Self>,
+        rq: Owned<mq::IdleRequest<Self>>,
+        _is_last: bool,
+    ) -> Result<(), QueueRequestError> {
+        if this.bandwidth_limit != 0 {
+            if !this.bandwidth_timer.active() {
+                drop(this.bandwidth_timer_handle.lock().take());
+                let arc: Arc<_> = this.into();
+                *this.bandwidth_timer_handle.lock() =
+                    Some(arc.start(Self::BANDWIDTH_TIMER_INTERVAL));
+            }
+
+            if this
+                .bandwidth_bytes
+                .fetch_add(u64::from(rq.bytes()), ordering::Relaxed)
+                + u64::from(rq.bytes())
+                > this.bandwidth_limit
+            {
+                rq.queue().stop_hw_queues();
+                if this.bandwidth_bytes.load(ordering::Relaxed) <= this.bandwidth_limit {
+                    rq.queue().start_stopped_hw_queues_async();
+                }
+
+                return Err(QueueRequestError { request: rq });
+            }
+        }
+
+        let mut rq = rq.start();
+
+        if rq.command() == mq::Command::Flush {
+            if this.memory_backed {
+                this.storage.flush(&hw_data);
+            }
+            this.complete_request(rq);
+
+            return Ok(());
+        }
+
+        let status = (|| -> Result {
+            #[cfg(CONFIG_BLK_DEV_ZONED)]
+            if this.zoned.enabled {
+                this.handle_zoned_command(&hw_data, &mut rq)?;
+            } else {
+                this.handle_regular_command(&hw_data, &mut rq)?;
+            }
+
+            #[cfg(not(CONFIG_BLK_DEV_ZONED))]
+            this.handle_regular_command(&hw_data, &mut rq)?;
+
+            Ok(())
+        })();
+
+        if let Err(e) = status {
+            // Do not overwrite existing error. We do not care whether this write fails.
+            let _ = rq
+                .data_ref()
+                .error
+                .cmpxchg(0, e.to_errno(), ordering::Relaxed);
+        }
+
+        if rq.is_poll() {
+            // NOTE: We lack the ability to insert `Owned<Request>` into a
+            // `kernel::list::List`, so we use a `RingBuffer` instead. The
+            // drawback of this is that we have to allocate the space for the
+            // ring buffer during drive initialization, and we have to hold the
+            // lock protecting the list until we have processed all the requests
+            // in the list. Change to a linked list when the kernel gets this
+            // ability.
+
+            // NOTE: We are processing requests during submit rather than during
+            // poll. This is different from C driver. C driver does processing
+            // during poll.
+
+            hw_data
+                .lock()
+                .poll_queue
+                .push_head(rq)
+                .expect("Buffer is sized to hold all in flight requests");
+        } else {
+            this.complete_request(rq);
+        }
+
+        Ok(())
+    }
+}
+
+struct QueueRequestError {
+    request: Owned<IdleRequest<NullBlkDevice>>,
+}
+
+impl From<QueueRequestError> for BlkError {
+    fn from(_value: QueueRequestError) -> Self {
+        kernel::block::error::code::BLK_STS_IOERR
+    }
 }
 
 impl_has_hr_timer! {
@@ -814,7 +914,7 @@ struct HwQueueContext {
 struct Pdu {
     #[pin]
     timer: HrTimer<Self>,
-    error: Atomic<u32>,
+    error: Atomic<i32>,
 }
 
 impl HrTimerCallback for Pdu {
@@ -855,76 +955,31 @@ fn new_request_data() -> impl PinInit<Self::RequestData> {
         })
     }
 
-    #[inline(always)]
     fn queue_rq(
         hw_data: Pin<&SpinLock<HwQueueContext>>,
         this: ArcBorrow<'_, Self>,
         rq: Owned<mq::IdleRequest<Self>>,
-        _is_last: bool,
-        is_poll: bool,
+        is_last: bool,
+        _is_poll: bool,
     ) -> BlkResult {
-        if this.bandwidth_limit != 0 {
-            if !this.bandwidth_timer.active() {
-                drop(this.bandwidth_timer_handle.lock().take());
-                let arc: Arc<_> = this.into();
-                *this.bandwidth_timer_handle.lock() =
-                    Some(arc.start(Self::BANDWIDTH_TIMER_INTERVAL));
-            }
+        Ok(Self::queue_rq_internal(hw_data, this, rq, is_last)?)
+    }
 
-            if this
-                .bandwidth_bytes
-                .fetch_add(u64::from(rq.bytes()), ordering::Relaxed)
-                + u64::from(rq.bytes())
-                > this.bandwidth_limit
+    fn queue_rqs(
+        hw_data: Pin<&SpinLock<HwQueueContext>>,
+        this: ArcBorrow<'_, Self>,
+        requests: &mut RequestList<Self>,
+    ) {
+        let mut requeue = RequestList::new();
+        while let Some(request) = requests.pop() {
+            if let Err(QueueRequestError { request }) =
+                Self::queue_rq_internal(hw_data, this, request, false)
             {
-                rq.queue().stop_hw_queues();
-                if this.bandwidth_bytes.load(ordering::Relaxed) <= this.bandwidth_limit {
-                    rq.queue().start_stopped_hw_queues_async();
-                }
-
-                return Err(kernel::block::error::code::BLK_STS_DEV_RESOURCE);
+                requeue.push_tail(request);
             }
         }
 
-        let mut rq = rq.start();
-
-        if rq.command() == mq::Command::Flush {
-            if this.memory_backed {
-                this.storage.flush(&hw_data)?;
-            }
-            this.complete_request(rq);
-
-            return Ok(());
-        }
-
-        #[cfg(CONFIG_BLK_DEV_ZONED)]
-        if this.zoned.enabled {
-            this.handle_zoned_command(&hw_data, &mut rq)?;
-        } else {
-            this.handle_regular_command(&hw_data, &mut rq)?;
-        }
-
-        #[cfg(not(CONFIG_BLK_DEV_ZONED))]
-        this.handle_regular_command(&hw_data, &mut rq)?;
-
-        if is_poll {
-            // NOTE: We lack the ability to insert `Owned<Request>` into a
-            // `kernel::list::List`, so we use a `RingBuffer` instead. The
-            // drawback of this is that we have to allocate the space for the
-            // ring buffer during drive initialization, and we have to hold the
-            // lock protecting the list until we have processed all the requests
-            // in the list. Change to a linked list when the kernel gets this
-            // ability.
-
-            // NOTE: We are processing requests during submit rather than during
-            // poll. This is different from C driver. C driver does processing
-            // during poll.
-
-            hw_data.lock().poll_queue.push_head(rq)?;
-        } else {
-            this.complete_request(rq);
-        }
-        Ok(())
+        drop(core::mem::replace(requests, requeue));
     }
 
     fn commit_rqs(_hw_data: Pin<&SpinLock<HwQueueContext>>, _queue_data: ArcBorrow<'_, Self>) {}
@@ -941,7 +996,6 @@ fn poll(
             let status = rq.data_ref().error.load(ordering::Relaxed);
             rq.data_ref().error.store(0, ordering::Relaxed);
 
-            // TODO: check error handling via status
             if let Err(rq) = batch.add_request(rq, status != 0) {
                 Self::end_request(rq);
             }

-- 
2.51.2



