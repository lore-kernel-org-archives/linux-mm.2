Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC0C4E63F25
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 04:13:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9D4F6B011C; Sun, 15 Feb 2026 20:24:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A745B6B013F; Sun, 15 Feb 2026 20:24:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 976806B0140; Sun, 15 Feb 2026 20:24:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 15C0D6B011C
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 20:24:41 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 76858160658
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:44:39 +0000 (UTC)
X-FDA: 84448323078.11.C0C2087
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9B07BC0007
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:44:37 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HEwbeqMw;
	spf=pass (imf28.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771199077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Y/UR/BH7S7XJkfONe7EL2mIo+zNO/Qm+ZLoyRQpJl8=;
	b=t81TD/iYlJL+re7ODE9Zqzk7+TvWWXVg3tZ77BRMkOoWMGlbc6Kz1R4N8Qbl+AJ5jqFv59
	+6Hva/VzUQRW/LWdXyaJZgXZWLJDTwRYykz4ugru51xTh1RSWkvnmz5Sz1jJLif3fOhYvh
	fZd5uMbjOkZcy1poXS8wb7Yu8PtyA4U=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HEwbeqMw;
	spf=pass (imf28.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771199077; a=rsa-sha256;
	cv=none;
	b=48/V4/JfHVEB4/6LdiXqqE6LQ0TOKQCd7MesMbinNNqOfB3sapBnMM8VSDssK5C+BL9Mns
	hr0oizTpCK2W1GUq6wv2jt824IXIv8zidkPPf5seQUO9MYy+IyIlUuX5GgdFIc2uFVfIvc
	MAbBiGU+BHuMxzABvHhskF8gFtgsu9Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AB84843228;
	Sun, 15 Feb 2026 23:44:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F643C4CEF7;
	Sun, 15 Feb 2026 23:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771199076;
	bh=HKPTgIJvjqkHxf4DOaN33MBiBgSvGkO/5CG2qjyHOmI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=HEwbeqMwqhChrUCr0eLVICcsS0kFu3re0MSkS9a7rAap1IsrAEKcKkEc0BoVyz8CP
	 tOt96798R0PqBauyBPJ1bFpvWFtWXVFa8qzPcLPZ8Ld+JV1vCQ28v5arFsYib21ZtN
	 13fg4gOjKrWZD0zKjm8kS9atSllQkX549FQ2Fw4lS4rqSCef/rmiJn8Kts9a5j1Ps6
	 M4Bq5zEUiFadeV1YBprYi+RP6zf368p0qbUaE2ke/jQf5uq8U5LtS97eiDQQfhvNkw
	 z2/q4ntwj/WmHNbNz4TpuVQjOoZdtnbtCsebkeeRcCC0poScOEJZlXf5BzgBJAX5vT
	 ag6JVCquNNJHQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 16 Feb 2026 00:35:53 +0100
Subject: [PATCH 66/79] block: rnull: support queue_rqs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-rnull-v6-19-rc5-send-v1-66-de9a7af4b469@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=12232;
 i=a.hindborg@kernel.org; h=from:subject:message-id;
 bh=HKPTgIJvjqkHxf4DOaN33MBiBgSvGkO/5CG2qjyHOmI=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpklhXTS1cfVP+RDBqvgSmswBnxZJTKLx89agmK
 q2pgugwP/eJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZJYVwAKCRDhuBo+eShj
 d/3tD/40WsdJWyyYdlKPzEWrD0jdbY+3W83zTWtXtFvD++vJ73emsdfzJGywBkqivcTP2Mw4srN
 hMaketviLPQhFfp2PZbweUdYsV0U3uoOic9UhqwrAuINKhlv/y7ee9tkIw+wPtN6ZPlfXXdXYF6
 hwyz6bI3yH7xSxPNC02QrQyfE7ObOt92sKVJbQjcxKKl57ZKkStWM/QHJusHuaaT5+dljtbHFMF
 XqSqkNSxbNfh42AS2LRmc7prBMokZCGMUTPgVMejWe8GyXv26jQuFet3FPvwVqr2C31M5cIf4oq
 d8yph8PhGIDKoUFiAKK0D+a3Cah5jxOwITAlUoTehUeN2uVIAiw+Nf6iiyZIfo2dmuSA9TZSQao
 AmcsNsOFYuD6LTzmO7KAPrPdZF81HMrIpUupHYIhx/+gfsWWR041QgdwCix5HjNmOCIGGA63Tty
 bA4l84a1ugbEHBL+dekLmMrWjgrdSp7ZJTnInQ0rAG29XrUijIveoNZcRaOWiJCmtm78+wEWLFk
 +uhDrBtGlBpviMdoKoqBh/eaRkHXSUlOpZ+jcNKFOJMxJfKugcS5lo42sahjPO28E5jsMFZIVd4
 3OCOlMRfahAfl0GN6VPi4Hdc1WtB/j5+dOZnjSE881iJEkvGykDvIzukH8WOd0m4vVbthdP1rSJ
 qu9CVscK+CEFYAA==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9B07BC0007
X-Stat-Signature: mnjii44uqhdxpmhqjbitij4r7okqpg18
X-Rspam-User: 
X-HE-Tag: 1771199077-513108
X-HE-Meta: U2FsdGVkX19qQP4wr/fTiDo1igUlST4d4K9LfmgtPkmkOGs+cK7lGLt0F6e0VuISonH5tsQcO97INyZBgM4mYMDgf2uKxMAJRwBn+dvriM3bJtCp3rATcC53gu8rQkWyzbYPew50yBs0UHr1/kRMmyUynwHkwbfLeoJbsyG6qZd7PcLe3raAzyeqrod4qvNV7cGW8JaMQFYOWGQ16VWbNiYX5nCfCXG+xdPfhZHl60G0MOqSP0WZ9dgMJ+TQiBzx7qxzUefzcd2mmyJ/idbxJq+/HZ0Y5eTm6t5NI7Ono3IwyhkzbilqsAaNwygEVA0XNy42+pXgQcuk7nW/H4vURMCFhJyeWr5DYdPz0i1UdUblwsaC5XWhW4VXhLhsYXrt8SA+THd25QJTLtvp2P+x/uvLO6d3AfduahQOfjqK5+e/3ynUB/F0a7Fy4oXDVMF15J9YAQFwVD+5Y2pzgbP83mhxoc6npmkq6HqTx/4YWOU9ydp/uTiMd2IY4G0tvfhs98Guu+2OQHln0YTy1AWlQa0j7IFJkcLtR3IwfBK94EwyLhgfGy59aR1F0yINylA0nLardmz3blVF78Nn0Gk07MHspGAsy7ujS06qPzSjJwJyJjcTlJ87Y3A/8z2jriF+yktahCojRrSqQQ4o5r4NK7L+cJyu1TH9OwRRC+Cx6Z9TK39cydlNF80gHTAzB6Olywah80+9FVF34HLturK1ocgj5nHxHfa5vtAt+XscoExvltae72tuZbj9hL2k8tZu8IA2r1rcH46PPdDYcXqkUIhTvpKubpuu5S/h2FurpyPcDmgI/Usy3ejjUmTHFSkojWXixmSaWAUQRCvIhIep2XYAluQ/xdmfmtdYU06eo9cMMOB2Ko8XgftMJrIVUKAV6k+Z+GEZym5/On7jzkdgQGKGCYCmyG74Dbt60eHraosE1wWrILDECJvWFmvz3HOmDM0gmpXE+XlH3N42VE9
 LRxpg12D
 ABLQOTOx/cvfwBcrpdCOkLeZdiGOKoJJv1C1ocKi/Uoh0iR9ixIqLvDBYRABvV0vI9YUpvPuIIPLknHnSd9ybLYxwE6JzVlJtvOyUibn+VrxASFXr/2VK5GGNwaI1AWvzVz61eUB4M8em31ScKQnPI5GeuC6QU1sG3Q9uItBEyvAXVsklAOS/ZTPIP4pBhbVHglF3NprWaQ1FrWwFllNSaecXiTtMMJ7CZV1QNKgQB1wtf+gRa6NaMSdP0nv9Jnz9x+zMLEFZmSJMcO7LscTG/EXwerFb9Kr2CbC0bSE/EiBpHIkvxAqrjcc09aSUC3fq6QbVUbEyUjCnlSNQNbVt/Z8OsNcOmLadpLIpWqrlhwX+H5I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
 drivers/block/rnull/disk_storage.rs |  34 +++----
 drivers/block/rnull/rnull.rs        | 180 +++++++++++++++++++++++-------------
 2 files changed, 132 insertions(+), 82 deletions(-)

diff --git a/drivers/block/rnull/disk_storage.rs b/drivers/block/rnull/disk_storage.rs
index b2b5eaa783cdc..d9f2703957fc0 100644
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
@@ -129,16 +129,10 @@ fn to_sector(index: usize) -> u64 {
         (index << block::PAGE_SECTORS_SHIFT) as u64
     }
 
-    fn extract_cache_page(&mut self) -> Result<Option<KBox<NullBlockPage>>> {
+    fn extract_cache_page(&mut self) -> Option<KBox<NullBlockPage>> {
         let cache_entry = self.cache_guard.find_next_entry_circular(
             self.disk_storage.next_flush_sector.load(ordering::Relaxed) as usize,
-        );
-
-        let cache_entry = if let Some(entry) = cache_entry {
-            entry
-        } else {
-            return Ok(None);
-        };
+        )?;
 
         let index = cache_entry.index();
 
@@ -168,11 +162,14 @@ fn extract_cache_page(&mut self) -> Result<Option<KBox<NullBlockPage>>> {
                     let mut src = cache_entry;
                     let mut offset = 0;
                     for _ in 0..PAGE_SECTORS {
-                        src.page_mut().get_pin_mut().copy_to_page(
-                            disk_entry.page_mut().get_pin_mut(),
-                            offset,
-                            block::SECTOR_SIZE as usize,
-                        )?;
+                        src.page_mut()
+                            .get_pin_mut()
+                            .copy_to_page(
+                                disk_entry.page_mut().get_pin_mut(),
+                                offset,
+                                block::SECTOR_SIZE as usize,
+                            )
+                            .expect("Write to succeed");
                         offset += block::SECTOR_SIZE as usize;
                     }
                     src.remove()
@@ -182,16 +179,15 @@ fn extract_cache_page(&mut self) -> Result<Option<KBox<NullBlockPage>>> {
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
@@ -208,7 +204,7 @@ fn get_or_alloc_cache_page(&mut self, sector: u64) -> Result<&mut NullBlockPage>
                     .take()
                     .expect("Expected to have a page available")
             } else {
-                self.extract_cache_page()?
+                self.extract_cache_page()
                     .expect("Expected to find a page in the cache")
             };
             Ok(self
diff --git a/drivers/block/rnull/rnull.rs b/drivers/block/rnull/rnull.rs
index 429819bf042ba..592fbf5790fd2 100644
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
@@ -720,6 +722,104 @@ fn complete_request(&self, rq: Owned<mq::Request<Self>>) {
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
@@ -761,7 +861,7 @@ struct HwQueueContext {
 struct Pdu {
     #[pin]
     timer: HrTimer<Self>,
-    error: Atomic<u32>,
+    error: Atomic<i32>,
 }
 
 impl HrTimerCallback for Pdu {
@@ -802,76 +902,31 @@ fn new_request_data() -> impl PinInit<Self::RequestData> {
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
@@ -888,7 +943,6 @@ fn poll(
             let status = rq.data_ref().error.load(ordering::Relaxed);
             rq.data_ref().error.store(0, ordering::Relaxed);
 
-            // TODO: check error handling via status
             if let Err(rq) = batch.add_request(rq, status != 0) {
                 Self::end_request(rq);
             }

-- 
2.51.2



