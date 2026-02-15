Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB4A5E63F1C
	for <linux-mm@archiver.kernel.org>; Sun, 15 Feb 2026 23:41:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA05E6B0092; Sun, 15 Feb 2026 18:40:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4EB76B0093; Sun, 15 Feb 2026 18:40:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B23D46B0096; Sun, 15 Feb 2026 18:40:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2B15E6B0092
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 18:40:42 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D819013BD7B
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:40:37 +0000 (UTC)
X-FDA: 84448312914.21.67DCD0F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id F3C5940005
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:40:35 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EIVtL4lw;
	spf=pass (imf04.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771198836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hNtXznM1qYNqPpDqlBoLyw+ldHq+TFhLrhelIiTqSVA=;
	b=JtZjdwdweqSn0+OZZE6jwm3ev/qKyOBa34Bw4GxYhPZ3ZoGUCUlkIkXPTyt6UlWJZ1g+kZ
	c2TqwR6yufuphUvxKZq6Suiq+skkmWy9DoA1dryLZ1UIgecdp4GGe897B95vcJnUATOfdx
	uX5OOjsHCYKG9eU5hx1NIRNFc1DMt5Y=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EIVtL4lw;
	spf=pass (imf04.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771198836; a=rsa-sha256;
	cv=none;
	b=wqZqIR2nyZkkmlOnF2DTGQYsWgCQ7jkIj2UDSCtUqQSZg713GHlvxNpPBmBuBNQsqFT8iH
	5Gdh0SXrXE1/6pK5BAtzuw11/X19iRj0TDpSt8zusNoWb1lgs32v0EXAjGHfiU8OvGQf73
	0uZZ6XuD04Uva1loX5pe1EVbluwAeoQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A9E6141B66;
	Sun, 15 Feb 2026 23:40:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4950AC4CEF7;
	Sun, 15 Feb 2026 23:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771198834;
	bh=lhLM7VW+elgLHbwAaApu2uDju5ClodzV2lsUXSCKd6w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=EIVtL4lw8JFCfYyLbkOkVEa7JXlNSdcyGo4qOyIIWOqr+nEHnuDiRWmxUe6wzDpdt
	 isgZdMXuUFBbJIUNka6yubc0IlqQeppw0r5J7yihoL0PlRPF3nv1l0ZcM/RjqhXCnQ
	 ZXSayfGGBCotK5nvCVqe7QpRipdTvgbA9iZlPNJlpTWsBUO8LhhVDFR8B1xyV9HWsO
	 degsko85wF5DrlPMznLHzQHKJp7T67C/Lv0943THWRSn45NAVDXxlfNuP9LzNFreQ8
	 +Vy6bec8YMLhqwhZBRcwIELNj+GoqC52kS9fMO8Nyk5zg9MMVo1UX8+DahqmUIXAz5
	 Z1ehugPEPKz6A==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 16 Feb 2026 00:35:41 +0100
Subject: [PATCH 54/79] block: rnull: add REQ_OP_FLUSH support
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-rnull-v6-19-rc5-send-v1-54-de9a7af4b469@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4765; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=lhLM7VW+elgLHbwAaApu2uDju5ClodzV2lsUXSCKd6w=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpklhM3Jq8YHxrfkqK/oCU6MjwIsMXoUhI4IkTK
 +/jl05X3saJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZJYTAAKCRDhuBo+eShj
 d8KjD/0QbfTC3g4Lbp6rrVquof9Xlz219bbRgWBbI0ddnxfwoBL0oYG9l+U7pgzMJwxChHNGUsW
 yaXD7XeOVnRfKxNopjmfMpgY8dz4KBRFRPfAI1FOKkjg5Q7pAH68iGn3ytQrqpQ0vOy/qjO8hWX
 SOdpbBoM5SkJQWgmbRC5eW99He2gVmaNawIruI/N7nMh+H/v7+nDHxodwp+6l16XQ8T4h8L8eoH
 IsD89YfFpQavHXTBxUv+bhU5YKdy0HNGW8by7aRCmOhpvqP7ctHLNOLeEe8qCfkdEXg0DV/XDYj
 WqUXjGKZ7ImjxPcNgg6RAYVNerGHKqNus6SnHMgZzSrFspg7SeWJ9M9/BXW5P29HFP+k/lPzTHg
 J1PMbstlAaUcLEtJMqUkGpUCYYFkMgXeThO1GAnKHp5k+RAFZL6l99kAbEYLl0Cyp66FNYfJiN0
 U3CzV14Qz1w1zRUoQKl6uMkCY+A0DIUDKOD7Whm/lR0Zw5xKKxFt+SazbuUIjCjMr4boyqklSy8
 WN1vAeenCReskUvStsX6RSMCQEbP+SyNOphfLq15xvx25z1HfP72OFWohynS+RkoOwdhT/4nnse
 Jb++s4gzj5w8zDYD4uZ486v3p7PLBAoL0/UgxZK2hDpXeRoSMrJzlbvs48ilKYWUSluC5HSjQdz
 VoZHh/6GYoIaaWA==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Stat-Signature: 8kjn8qq6sfacs1bsn5ahfx38dtkrmr1k
X-Rspamd-Queue-Id: F3C5940005
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771198835-577749
X-HE-Meta: U2FsdGVkX1/8fjTlnCkJ6krXsmV6Xv7zb5LKMrDRiGV3g07nt+gGeaZ7bCnnL6YrqK2gQZQKIAvokPfvJutfjt8X6LXmD0uPfg+dfEaumdMHnSQoVp49oyA+kFGmhqddnM3wEGxBRlYyNfdm46RsOqmwhZnU7Rhj4aGG+/wPPWN8b0lz9xSiLU5FntaaeKtXIoqq07/k+uRDdLYJ1d8cdk9CnsJ+JU7pVFrO4R3OxPPYXoqLeD1TNxhiY7ETiV+k0ir/28OoNn6B5+lSxsO5pETUPG3YxVtGmazKQX2riTNPYInAfa89zaRoLW3exg/eqg8aPTdcWOT+DFstLg80AuiEYqOczOyijMHAniN5nMAeIQp9CiUCZvi7OPu8C4HvpJbDTMb2PqxXLr9bir8K/kwl2UDckjtu3hbZpKoEYMtFFc+LvrvsipX9u0lH7mBf+sqz+F9rpCVrhh39XEFpRzSWI0b7qhX8R3gfAsnkcwZVeCpil5ojQu3uw5AiZRGheRtg6FZ/Pb32Fb4SteAEuaOtIyVQ/SwvCeveB7RzfC7WHr4PM+5uuUcYu9W+gf1uqxqMTTjCl6o5jScAu37+3tgJ+2FgpcrC0TbRx3B8t0DU18rJ9guFlYR9VCzxzrpIJo68yA7Ij0TydjCQV4Iq4a7fWm+N+QfXrat7U6KV/rubjpNGkk//M32w1ge/cfvcMDKTfF27zZsdFg1YPTG0DX4ITrE3ToNOReeMc0LJoq1nqSdyxoZWl7NY9T4s5yoNMRx/npQIyhEmFgvqe13XX4KvmTjnFJ4RthBS+ilWTsOhmctcq+bWzOZkXcEU/zA+OxupyyP9k+SVJCpnCuLdyt8LMRkcfOBUvm/N/UDoYCTo4iEEsIcFCt7eYHbeT99p6a50nJSpxy8JrBN3jyMA83THGxuXvqpFCT/S0aQRFLzl6lOOia4SZfFWohnVjlVAwP64rviu6mXZAr1dYqP
 pQ8S9aQS
 VZnbD2LVEj9Oq/J/e/PXEUzdQzV6Ef1fRssJ5c1KhGx4ZtMMCG96S1i12DAf9v8T+c2WYkOofgrnl8B5qjGDpaLjN78mNzwIQ7LsOvO+MxF2KUgalvlFhBdDHqrbrhaEsMiJn+lBMVGmgWyX660p64rUu5hjoBborFRhYmr38QaZtSRQTWwSXkHCW9nnPNh8xZf5K6k402sRh2qnA+HPIe5YihHtVq3o/awuhJ5hdC+G7A23mnboruiJHPv5KamjkZ01KvKyw7/mAQFP1+XIC7vwbN7L5RPj3tA8gjBlc+3mT46MS/b5kZVOMsTVv7YIhAykJay3yZXbP8LAaLWR+M15d0JM/VPcNJtDmckheyqMPlwc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
 drivers/block/rnull/disk_storage.rs | 36 ++++++++++++++++++++++++++++--------
 drivers/block/rnull/rnull.rs        | 31 ++++++++++++++++++++++---------
 2 files changed, 50 insertions(+), 17 deletions(-)

diff --git a/drivers/block/rnull/disk_storage.rs b/drivers/block/rnull/disk_storage.rs
index ce3e83671709a..a613ed5223ba7 100644
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
@@ -118,13 +125,16 @@ fn to_sector(index: usize) -> u64 {
         (index << block::PAGE_SECTORS_SHIFT) as u64
     }
 
-    fn extract_cache_page(&mut self) -> Result<KBox<NullBlockPage>> {
-        let cache_entry = self
-            .cache_guard
-            .find_next_entry_circular(
-                self.disk_storage.next_flush_sector.load(ordering::Relaxed) as usize
-            )
-            .expect("Expected to find a page in the cache");
+    fn extract_cache_page(&mut self) -> Result<Option<KBox<NullBlockPage>>> {
+        let cache_entry = self.cache_guard.find_next_entry_circular(
+            self.disk_storage.next_flush_sector.load(ordering::Relaxed) as usize,
+        );
+
+        let cache_entry = if let Some(entry) = cache_entry {
+            entry
+        } else {
+            return Ok(None);
+        };
 
         let index = cache_entry.index();
 
@@ -168,7 +178,16 @@ fn extract_cache_page(&mut self) -> Result<KBox<NullBlockPage>> {
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
@@ -186,6 +205,7 @@ fn get_cache_page(&mut self, sector: u64) -> Result<&mut NullBlockPage> {
                     .expect("Expected to have a page available")
             } else {
                 self.extract_cache_page()?
+                    .expect("Expected to find a page in the cache")
             };
             Ok(self
                 .cache_guard
diff --git a/drivers/block/rnull/rnull.rs b/drivers/block/rnull/rnull.rs
index 92e75f15e02c6..4870aa3b7a53e 100644
--- a/drivers/block/rnull/rnull.rs
+++ b/drivers/block/rnull/rnull.rs
@@ -673,6 +673,18 @@ fn end_request(rq: Owned<mq::Request<Self>>) {
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
@@ -789,6 +801,15 @@ fn queue_rq(
 
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
@@ -814,15 +835,7 @@ fn queue_rq(
 
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



