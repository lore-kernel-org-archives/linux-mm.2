Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74560E63F25
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 04:16:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F33F46B0135; Sun, 15 Feb 2026 19:26:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0A9F6B0136; Sun, 15 Feb 2026 19:26:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0C246B0137; Sun, 15 Feb 2026 19:26:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (unknown [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 092306B0135
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 19:26:46 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5E2EFBC57B
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:42:41 +0000 (UTC)
X-FDA: 84448318122.07.9956C73
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 85945180004
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:42:39 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uLg4izf1;
	spf=pass (imf24.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771198959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gai2fP7Xeos+Qi7dxEtImq1MRIr/gtwPSS82vPUgdUQ=;
	b=YZb/WfbNJn3g2H7SyrYzJcHfg9xLu3/QRmeuncQV60uFTC5wkjFfzyqpA40Cjl8ukxNN69
	GK1G8TWTt96E8G7jMWHJC2hQOpoBFkcwmkGvVnqxRjG4T4bk12e4uQ65nNXrmcaJCbOSuv
	51DKZC+ZLwRNuzo31inLqjW0ohgJP1o=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uLg4izf1;
	spf=pass (imf24.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771198959; a=rsa-sha256;
	cv=none;
	b=k9K4vnW7jax+Gp0zX0820U1EUBPSQHHTuRqQPM7N+BshwIyG7wdFAtKuXGONzvHVbt1O71
	gY/10EFH3Xx1D1rgoyKYrAKOjf0n//zeo9jDqSCYTz+f3r4HMW5sduNZlm039mrKWUXxsN
	jdCYow6eGl3BolIfD8zp3HbxtFMV7UI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B5D8040196;
	Sun, 15 Feb 2026 23:42:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 528A3C4CEF7;
	Sun, 15 Feb 2026 23:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771198958;
	bh=mPaJdnA08bz6YzukufDATJZJlX5Z7yfcsTpWSx7drrU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=uLg4izf1PM8gqhPDfHqZL929CRE2DTJ/KxnrvYokJWM7vmx++wtifuDiKP7IDH+/q
	 15hyyd/bcNJWdAMht6NQ8O5WHgwhmDA1mp2jtL4Vmyj4bL6IvYUnYAtcnPdlIWcByl
	 jkz8KNty6uFOR0qPcf+m7WbDyPeonycK4debT3X+sKdLT3r9yW5jYep4sftXPAkLX2
	 ISpV0T0YhSXNjeTNxm2mBQVGXh3Y5U9CA7pIqz+Qvp72cZZUJH9CIEbzv0csjVaZin
	 bDW6RU2bn/zpJ/0f0Bj2cQya7kaJyOWTWoOO0xB7x1e92pbEjzYGH2yDK9aCiAtPDy
	 nFr65qRtcN8qA==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 16 Feb 2026 00:35:14 +0100
Subject: [PATCH 27/79] block: rnull: add badblocks_once support
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-rnull-v6-19-rc5-send-v1-27-de9a7af4b469@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5676; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=mPaJdnA08bz6YzukufDATJZJlX5Z7yfcsTpWSx7drrU=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpklg0gpsXFXxzc1lHaiAxCsn05VWspInODyhcx
 +COma0+h1WJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZJYNAAKCRDhuBo+eShj
 d6NdD/9VzqziYOZORL+w+EyvJ+DjwGX57mT4SohYFt5k0+dyu6GNOpWEPwoiE96dQtqQncyWvEt
 TXtKlLSGDSZ3yfpf0ID75MqiBwnUtOmOtLS4R360hVOfPSs64mvN4lR3M9EcXoH+lgZFxcADFuv
 LSM3jC+mSrMj28AzbquDyrPLLDD+wABbXX67Lf2bVrNUajlK9T+8J0arhxvmY4sqF61cF0vDScq
 VtvnB61d8V02U0oYkIXlpr18oitcK4jHHzr+6R0Vh8WN74GW2fpuvX5P32RnHWVaIWR+qVXM+m9
 OnwVifaDcOOR2QwKTFF/G5KoPn7H9Fp4hpDK9ieBVEioELGh+bep84Nw/VbqIIzLhtePNuNYH5+
 zais2/7lYmLWqa/gtJZBIdq4IiA8sxlmDpurdga6YlezkCf/zSFIpTmuZE7sBCNg2AlQ6NCXtud
 2CeNoEMzunwPewSKt7+W3bvaJvri93/eoFj16eH6AfhBLJoIiT048CTEjBNzYDjFE7QlRcxxMvM
 EtLAZvsvI3Pd+0i1zzB6WuQkVsAupbWzVf5k+gcbWy1pPAWaBeK/mSzAPKMYq+IS+g/C40POev6
 j/y+QHdq2/G3Pfnqjis+7XJglP1xf4eBE6wUJesr/Jd3tB4VA5fklhxUZVq210VUyUTKSJXPxEN
 1Vz7GfFZyKM7Kew==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Stat-Signature: 89xu7njx9s6dq6x393hbbjcppydojrum
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 85945180004
X-HE-Tag: 1771198959-323599
X-HE-Meta: U2FsdGVkX19YXPwv+4YbLr2eP8HI4o78CKurcNXfapDoaH4rLibmwyT0QILwQz2ilOLkSLSyNYCy9wiaYDZQ8pcok4DvlOoI8YKBH4CjkR1F5psDrpOlhcKNHtwu/4I+9ixSI2LoaxmOSRKIs2bAlWcDFdzjX8gC+s4SDvOKG3T+gu9a5nYERjp4yMip6mPzM3ncqhzKF/1XVwSqPxDHxd2UcmpM71jKONUMjAt+vi0xcuH0ysfoEXHG2qAbvtvNYx8nQgcMhZ7od9eFCLSEFg9GVwwljnaz9VjiR8JkU5f2La5FVF5KJlXVcjM9Iao0lvvHz7+4EMDxF7MEfGPFZvmS8KxKukUIS6D07hUnGwScAGeagvLo7rLXttXI48bDu5s89zoej7+BYfT5MIbyIm/koHIqDgd1SPf+CJ5SaPO6+ZPyGHS7zElXI8H0xMhmc1pTkSsYcNJItab+La6Hc9FuenHGxLQrEztcIRqDvLHRJXAAP3u8AKr5UF80yYu4rYTDoPwgPhVg814uKSgyF5g3e4ctNVHm0KkCpm94Y7iSWw2GJqZV9Iw+7Tu5rVnLQnHCso6hbetTdMrqJI9fD1O8DgwhEHLgYAcIHmSj/jvMOyonAbP8Sovd1NB0zIk/4RxzVMbNSIaAtIs5GCDUfZgzn6DbKH9jhlMMoRuz/jAPt8d0XxCwmiHMSmR6wapOdYRxAMqHJy10j6LLX8drsJiTfVJwkZzyKIDDoNYPEr2W45GU3haZZRbNGg9H5R+bxCKzuw5wExyr7NnZyjt4YO8h2JUo4BbuFJdwMWIGQthSX5zoQGcBrtRBsoesLTuCO/5dzcw0TOwRP/gScr7paHl3JbDHLas3O0OqT/WV5QWkYFDGmi0FJllJxAs40ZsKL0g/mitn9Toq2Eys5cfOzqAgio20CZZ7/jDY3Cqvhv2oVqUoCyEvW/Ml+6wWgk8uJYBl9O/12LiNOgxnFUR
 wm8OSHgr
 OumfywmrUw4JpNhYl2lQxwIwKllFsKZQ3/+Q5nTkSRrQIgfZsjl1/6XP61n3/6xUR7WUYrzT5p/PMQ4bPKb4JmBBS0VJ+V2nJuIchzeZ+C/Ph5KXhA7xAfiotRxomcgUGLJX2NRAk9adl2eyyAYo4f4EQASsOFWrrRLElWG9XOTl9nOG8IXCYpyxoLfmEEFRe3W9/QJj/SCxeSqzE/uD/vjrB4fkjVg9h6SlLs/h/haLDQ8U+ojpsyc+peeJSIt1gS4T7bf5lXIpNXW34kqJE0aeGkS13KKP8uM40BTBxP4uJFZ1TSdj1hUe4DG2NrQriiF6DXT3dEF1ruWv/mpSxYDqNInsluWAfmxQmB8TajZFWmlo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add support for the badblocks_once feature, which automatically clears
bad blocks after they are encountered during I/O operations. This
matches the functionality in the C null_blk driver.

When badblocks_once is enabled:
- Bad blocks are checked during I/O requests as usual
- If a bad block is encountered, the I/O is marked as failed
- The bad block range is immediately cleared from the bad blocks table
- Subsequent I/O to the same sectors will succeed

This feature is useful for testing scenarios where bad blocks are
transient or where devices can recover from bad sectors after a single
access attempt.

The feature is configurable via the configfs badblocks_once attribute
and disabled by default, maintaining compatibility with existing
behavior.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 drivers/block/rnull/configfs.rs | 31 +++++++++++++++++++++++++++++++
 drivers/block/rnull/rnull.rs    | 21 +++++++++++++++------
 2 files changed, 46 insertions(+), 6 deletions(-)

diff --git a/drivers/block/rnull/configfs.rs b/drivers/block/rnull/configfs.rs
index 61a76addf468b..a39691b39e374 100644
--- a/drivers/block/rnull/configfs.rs
+++ b/drivers/block/rnull/configfs.rs
@@ -103,6 +103,7 @@ fn make_group(
                 discard: 10,
                 no_sched:11,
                 badblocks: 12,
+                badblocks_once: 13,
             ],
         };
 
@@ -126,6 +127,7 @@ fn make_group(
                     discard: false,
                     no_sched: false,
                     bad_blocks: Arc::pin_init(BadBlocks::new(false), GFP_KERNEL)?,
+                    bad_blocks_once: false,
                 }),
             }),
             core::iter::empty(),
@@ -186,6 +188,7 @@ struct DeviceConfigInner {
     discard: bool,
     no_sched: bool,
     bad_blocks: Arc<BadBlocks>,
+    bad_blocks_once: bool,
 }
 
 #[vtable]
@@ -222,6 +225,7 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
                 discard: guard.discard,
                 no_sched: guard.no_sched,
                 bad_blocks: guard.bad_blocks.clone(),
+                bad_blocks_once: guard.bad_blocks_once,
             })?);
             guard.powered = true;
         } else if guard.powered && !power_op {
@@ -422,3 +426,30 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
         Ok(())
     }
 }
+
+#[vtable]
+impl configfs::AttributeOperations<13> for DeviceConfig {
+    type Data = DeviceConfig;
+
+    fn show(this: &DeviceConfig, page: &mut [u8; PAGE_SIZE]) -> Result<usize> {
+        let mut writer = kernel::str::Formatter::new(page);
+
+        if this.data.lock().bad_blocks_once {
+            writer.write_str("1\n")?;
+        } else {
+            writer.write_str("0\n")?;
+        }
+
+        Ok(writer.bytes_written())
+    }
+
+    fn store(this: &DeviceConfig, page: &[u8]) -> Result {
+        if this.data.lock().powered {
+            return Err(EBUSY);
+        }
+
+        this.data.lock().bad_blocks_once = kstrtobool_bytes(page)?;
+
+        Ok(())
+    }
+}
diff --git a/drivers/block/rnull/rnull.rs b/drivers/block/rnull/rnull.rs
index 861392c5b5841..0f569c5b65f77 100644
--- a/drivers/block/rnull/rnull.rs
+++ b/drivers/block/rnull/rnull.rs
@@ -161,6 +161,7 @@ fn init(_module: &'static ThisModule) -> impl PinInit<Self, Error> {
                     discard: *module_parameters::discard.value() != 0,
                     no_sched: *module_parameters::no_sched.value() != 0,
                     bad_blocks: Arc::pin_init(BadBlocks::new(false), GFP_KERNEL)?,
+                    bad_blocks_once: false,
                 })?;
                 disks.push(disk, GFP_KERNEL)?;
             }
@@ -188,6 +189,7 @@ struct NullBlkOptions<'a> {
     discard: bool,
     no_sched: bool,
     bad_blocks: Arc<BadBlocks>,
+    bad_blocks_once: bool,
 }
 struct NullBlkDevice;
 
@@ -206,6 +208,7 @@ fn new(options: NullBlkOptions<'_>) -> Result<GenDisk<Self>> {
             discard,
             no_sched,
             bad_blocks,
+            bad_blocks_once,
         } = options;
 
         let mut flags = mq::tag_set::Flags::default();
@@ -235,6 +238,7 @@ fn new(options: NullBlkOptions<'_>) -> Result<GenDisk<Self>> {
                 memory_backed,
                 block_size: block_size.into(),
                 bad_blocks,
+                bad_blocks_once,
             }),
             GFP_KERNEL,
         )?;
@@ -393,6 +397,7 @@ struct QueueData {
     memory_backed: bool,
     block_size: u64,
     bad_blocks: Arc<BadBlocks>,
+    bad_blocks_once: bool,
 }
 
 #[pin_data]
@@ -442,12 +447,16 @@ fn queue_rq(
         if queue_data.bad_blocks.enabled() {
             let start = rq.sector();
             let end = start + u64::from(rq.sectors());
-            if !matches!(
-                queue_data.bad_blocks.check(start..end),
-                badblocks::BlockStatus::None
-            ) {
-                rq.data_ref().error.store(1, ordering::Relaxed);
-            }
+            match queue_data.bad_blocks.check(start..end) {
+                badblocks::BlockStatus::None => {}
+                badblocks::BlockStatus::Acknowledged(range)
+                | badblocks::BlockStatus::Unacknowledged(range) => {
+                    rq.data_ref().error.store(1, ordering::Relaxed);
+                    if queue_data.bad_blocks_once {
+                        queue_data.bad_blocks.set_good(range)?;
+                    }
+                }
+            };
         }
 
         // TODO: Skip IO if bad block.

-- 
2.51.2



