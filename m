Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1632CD8CB2
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:14:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4497D6B00ED; Tue,  9 Jun 2026 15:14:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4217A6B00EF; Tue,  9 Jun 2026 15:14:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3374A6B00F0; Tue,  9 Jun 2026 15:14:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 211E76B00ED
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:14:51 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DDA81406DF
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:14:50 +0000 (UTC)
X-FDA: 84861326340.22.F4DF1A5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 06EC9C0008
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:14:48 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bWyNwyB6;
	spf=pass (imf10.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781032489;
	b=x9aifdW0DwxR55Ekzl2493oKFD5+/l665BNJ/wmM5UF2dpxg6pkadW3zhvEYspR9PEQ0od
	MGvWsD0dUCdmdyNLHa20YtF2CtI5PmPoC5WDDtFmSHiEZAnH8bvnuJdmewn88xsvoyg1dr
	t3U2WhxIwQXZw+wdOBJuPpPbr/fS6g0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bWyNwyB6;
	spf=pass (imf10.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781032489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RYYbnA7Q4dh7igQ57Y011k9mdRZ1hokxHpxllxzwi44=;
	b=nFNrw3wmvxyAcMGnDfTegD/7lpmUYcfLxLcYD6ZMuv7R+2qu3vTtbuWYeaQSvgKlBm//0k
	acMUQw2fzQamvwuxZ5RB/BBvjwxgFfMQ5C14wv/Cg+WAO15hbPM/ps7DKFWQ5GzThMHVNv
	M5uS6lyy35bwCh9ObyV9PYvASwD9Gag=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4684843940;
	Tue,  9 Jun 2026 19:14:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 514EE1F00898;
	Tue,  9 Jun 2026 19:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781032488;
	bh=RYYbnA7Q4dh7igQ57Y011k9mdRZ1hokxHpxllxzwi44=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=bWyNwyB6adFUkYFJfv842UmUDVq0mrAXsfUn0bPtMclR/u/umgM7MP+B06igld1bs
	 A8aF5kdlvfIVyuifXdsLkQJ5BlWOp0vvmZp+qAXiSEB4tku4WBWdZrTBKKX1d2V4tB
	 uePjAyngdh3WYxTybFWC9GYOOtOR9BhqiccMF4nQD44JnDrMHbVmJzWsU2TWuoZAPL
	 JJHlWih9Lk6CLwvEtBCb+yU1e6thapVD3IXtcq5sJjNUJOmnodZy72Wuth/G1ChhtY
	 WKL5i0PuRHvPbk3tsU08jIdiM5ftr0A4R59YU+sFsWb5nFqEnte6gSU10Rs7Q8tNDR
	 5aPXC7YSFa3aw==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 09 Jun 2026 21:08:38 +0200
Subject: [PATCH v2 59/83] block: rnull: add REQ_OP_FLUSH support
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-rnull-v6-19-rc5-send-v2-59-82c7404542e2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5324; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=UpX4gG7L/JrWoAycLPQmU4GCqRdexz34zVS4aoqb37s=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqKGTqZ+E1LBttgu8oVGQJ213mTDB9ii02KysEx
 sxYZnUwv0yJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaihk6gAKCRD6UCkIqsW9
 0FqcEACHRLYMIzbzsj377pL0AVUKQNA3v/IIbHjqKDbwp9jFhJpcFsShNwdi6+Hjxi08g+CN5NU
 8zyMZmvY68JQTlN3j1tJyIWbb+YLnV7yEhnF+6Kciv0dToFZShpYI1xT0Hbv5CajqybY3yWWEyV
 Ev4DvIXdeyD3Gkx5ecpI8hem4cqX4aCGEtLMAR4XqPDhNWGAs5t3eFl3WKvFUlOCqApIlo1pRlb
 FQAhufO6qJ3b7UEvOgNfUa46TxXVOqImPa6Q9yMwa8F2OsaH0W5g2Xzm/9ilLUgw1abLPLYVwwN
 CMTPDvwL2zUjg9Ut27Rfri6ImqCQnDJzciTuO9e5JjO6PLTORMJvTwJ0Ni5sH40NaxDV4Pkisqx
 Fb7uBy9CE5KniRLf/r3cNgsLFhe+/bf2P+/tHJp6ocaX7itDUgrNKlbxlI7qO0H0f6a5VRsXcy2
 azZCK/Wit2MRrSFWhft9Gpcw/9o/Yunh9KSHEy2di6neFyT6gIQbJO6XXCHtwuHuQw7qi80Ujo2
 Z87t/RqnNrQOd76aHnJ6tes3nJPkgz+kSbKflkg4Rh+zhRlFdI9LRYCczPHhn9u70PmLBjsHezE
 iVfFX5lp/AjhEXY6fL/EBW0YXEkX3pNYRmv0gua/hty2NwyQOaBXqPfzpOmGDH0HIjLPgd99Eyk
 9hyJetaPpyfZ38A==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Queue-Id: 06EC9C0008
X-Stat-Signature: jqqhh4kk5a8z7wo8rxh75t1gafrr6w1p
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781032488-49832
X-HE-Meta: U2FsdGVkX19cl6QBVJy+lUGzHA5YTIpaQacuYD8JB4Cjac2/ZFG3+uOKudqBBL2WJpxBHRVaB3y9OmzLzT379y6U1q3+5pJuz5bQjKWsFxKFi2pXvgU+j4D/AgSP+4Top9y4BUwVnzaEcip2jYeHH4A0jb7pBtUC0DIoWLxnY31Qd3Y+j6pgHJtGeGx8xYpFeFivvdhW85Ivzi5nO2FSSF8TpQfXg3vze+dqDUy62buhlzgRPOAjro/RHFrUgfR0viKMVLjMZcSCvyxqn3UCZyzI3nKkftU+3IdPJZlUjZQvzHmZSxTrHr5C61myYkZpL+anwLIR3C3h/pjH28KEfpWvOuffkjqtcGRgokdl0/bSlhIPWgsYiOsgyNfT87egvXlqK+3hjhPngS4ucuDVt1pfqaP5oZUA85lFsG6chRlni7rCvnw4saP+OaDQLc9+CuNzympb9g6jE2OJ6SKaInebgheOsGzBdI+8gwVMaeVu1MQBN7goYBBW4tU9mIgllvAhU5ax8X6oFoJL9uDjjKWRNzx7gIE47K7SPKNXx06yEoFVg4p8QOi/IsY4g7Rt5Nwp3a9XHYrRPJvkuVCdikcK0vktKqZLJgrJN9zLRPtM5pf6YyqITXR/+Ls7/bBc6ob9T7rN0VLhOUAZL4rFX4OYmOvzzfTpEbdT53VhujKjLDF89LNWOzL/W5HR60DWp/Jy6y8pZODDVHtYHpfrXHpPLLlsmGMTmVO4MRZaehFD5lpXn8smGrRtNF8uTfTAmeh04BgMlz3PxDkK/nKgrZt0akV/PVDCW+ua3LP+TachMX/DKJ82mkqiiJSLANftrr/ORuPCuJI94lqx6gkQfz69sOyCgHdK6IQsldLmjHNlazN+RdPI96boek4qOz7psDEBujVLZKr50HNwXPUu0C9l9LpFPqx68NIotUOVIS7N//2kcAZKXk8ibECqCm0LoZFOxZ4hqrVG1FdrhNU
 uCrcJLSk
 sK4DtHbxwzRPJKzUnEexWPnDCOQDEef3xfZeVCyUgtaQtIZPYuNHTHyfWQLg5x3HaqNBtSL7YH1iPUnOoUHEm7jvNWJEmZiV/Mag3ytjJr+Uef02v4gF4JqScyDSjh9YGlI1ghZwo7mxJeR9D/+2vkQP/YEOql33mEFn/xzIZ2kck+qcteSHr1C4iP8lCdbiRLtFSV1os6uyODhwc0oNDoJu4RMEP/dr15XWBdeC7wgdm50T5jd3fl/iBm0fxhat+sLeJXNJw7+wrVLiKantvkCbTD1bQ1m9ecqWz1VdyINWWQNiO8e585WXkIibdAP3hKGSuTPc8peEf0Hj0Rkb64OH/8pHxku6yhDG1MZm+Py49njGV+0enRwm/Sg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add support for handling flush requests in rnull. When memory backing
and write cache are enabled, flush requests trigger a cache flush
operation that writes all dirty cache pages to the backing store.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 drivers/block/rnull/disk_storage.rs | 45 +++++++++++++++++++++++++++++++------
 drivers/block/rnull/rnull.rs        | 31 +++++++++++++++++--------
 2 files changed, 60 insertions(+), 16 deletions(-)

diff --git a/drivers/block/rnull/disk_storage.rs b/drivers/block/rnull/disk_storage.rs
index 82de1f656f68..7667830bd616 100644
--- a/drivers/block/rnull/disk_storage.rs
+++ b/drivers/block/rnull/disk_storage.rs
@@ -85,6 +85,13 @@ pub(crate) fn discard(
             remaining_bytes -= processed;
         }
     }
+
+    pub(crate) fn flush(&self, hw_data: &Pin<&SpinLock<HwQueueContext>>) -> Result {
+        let mut tree_guard = self.lock();
+        let mut hw_data_guard = hw_data.lock();
+        let mut access = self.access(&mut tree_guard, &mut hw_data_guard, None);
+        access.flush()
+    }
 }
 
 pub(crate) struct DiskStorageAccess<'a, 'b, 'c> {
@@ -120,18 +127,32 @@ fn to_sector(index: usize) -> u64 {
         (index << block::PAGE_SECTORS_SHIFT) as u64
     }
 
+    fn extract_cache_page(&mut self) -> Result<Option<KBox<NullBlockPage>>> {
+        Self::extract_cache_page_inner(
+            &mut self.cache_guard,
+            &mut self.disk_guard,
+            self.disk_storage,
+            self.hw_data_guard,
+            self.sheaf.as_mut(),
+        )
+    }
+
     fn extract_cache_page_inner<'g>(
         cache_guard: &mut xarray::Guard<'g, TreeNode>,
         disk_guard: &mut xarray::Guard<'g, TreeNode>,
         disk_storage: &DiskStorage,
         hw_data: &mut HwQueueContext,
         sheaf: Option<&mut XArraySheaf<'_>>,
-    ) -> Result<KBox<NullBlockPage>> {
-        let cache_entry = cache_guard
-            .find_next_entry_circular(
-                disk_storage.next_flush_sector.load(ordering::Relaxed) as usize
-            )
-            .expect("Expected to find a page in the cache");
+    ) -> Result<Option<KBox<NullBlockPage>>> {
+        let cache_entry = cache_guard.find_next_entry_circular(
+            disk_storage.next_flush_sector.load(ordering::Relaxed) as usize,
+        );
+
+        let cache_entry = if let Some(entry) = cache_entry {
+            entry
+        } else {
+            return Ok(None);
+        };
 
         let index = cache_entry.index();
 
@@ -172,7 +193,16 @@ fn extract_cache_page_inner<'g>(
             }
         };
 
-        Ok(page)
+        Ok(Some(page))
+    }
+
+    fn flush(&mut self) -> Result {
+        if self.disk_storage.cache_size > 0 {
+            while let Some(page) = self.extract_cache_page()? {
+                drop(page);
+            }
+        }
+        Ok(())
     }
 
     fn get_cache_page(&mut self, sector: u64) -> Result<&mut NullBlockPage> {
@@ -197,6 +227,7 @@ fn get_cache_page(&mut self, sector: u64) -> Result<&mut NullBlockPage> {
                         self.hw_data_guard,
                         self.sheaf.as_mut(),
                     )?
+                    .expect("Expected to find a page in the cache")
                 };
                 let xarray::Entry::Vacant(vacant_entry) = cache_guard.entry(index) else {
                     unreachable!("slot was vacant and we hold the lock")
diff --git a/drivers/block/rnull/rnull.rs b/drivers/block/rnull/rnull.rs
index edb4ef53d6ad..0695cbd07f1d 100644
--- a/drivers/block/rnull/rnull.rs
+++ b/drivers/block/rnull/rnull.rs
@@ -719,6 +719,18 @@ fn end_request(rq: Owned<mq::Request<Self>>) {
             _ => rq.end(bindings::BLK_STS_IOERR),
         }
     }
+
+    fn complete_request(&self, rq: Owned<mq::Request<Self>>) {
+        match self.irq_mode {
+            IRQMode::None => Self::end_request(rq),
+            IRQMode::Soft => mq::Request::complete(rq.into()),
+            IRQMode::Timer => {
+                OwnableRefCounted::into_shared(rq)
+                    .start(self.completion_time)
+                    .dismiss();
+            }
+        }
+    }
 }
 
 impl_has_hr_timer! {
@@ -835,6 +847,15 @@ fn queue_rq(
 
         let mut rq = rq.start();
 
+        if rq.command() == mq::Command::Flush {
+            if this.memory_backed {
+                this.storage.flush(&hw_data)?;
+            }
+            this.complete_request(rq);
+
+            return Ok(());
+        }
+
         #[cfg(CONFIG_BLK_DEV_ZONED)]
         if this.zoned.enabled {
             this.handle_zoned_command(&hw_data, &mut rq)?;
@@ -860,15 +881,7 @@ fn queue_rq(
 
             hw_data.lock().poll_queue.push_head(rq)?;
         } else {
-            match this.irq_mode {
-                IRQMode::None => Self::end_request(rq),
-                IRQMode::Soft => mq::Request::complete(rq.into()),
-                IRQMode::Timer => {
-                    OwnableRefCounted::into_shared(rq)
-                        .start(this.completion_time)
-                        .dismiss();
-                }
-            }
+            this.complete_request(rq);
         }
         Ok(())
     }

-- 
2.51.2



