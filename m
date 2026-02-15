Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07A54E63F1F
	for <linux-mm@archiver.kernel.org>; Sun, 15 Feb 2026 23:55:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5727A6B00A4; Sun, 15 Feb 2026 18:42:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52AD46B00A8; Sun, 15 Feb 2026 18:42:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45C696B00A9; Sun, 15 Feb 2026 18:42:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 458E96B00A4
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 18:42:10 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 29925160513
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:42:06 +0000 (UTC)
X-FDA: 84448316652.17.0F48C4E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 79B671C0004
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:42:04 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ohVjIgyq;
	spf=pass (imf21.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771198924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mnD1o71t6cV2TglStOn4q9uIejM+P/Z2TQlT1mG+cg0=;
	b=nCgnagnRmp7ciDZyYPnlekM6fgY/uztE+GQvsX0tLb6vHYbYmuipHpNVJQp12AehAAD+tT
	fz6SAefZ5YZQ3vZ6ia3IYlKyVmSQInch3JkUNPswnJ6uwQeHgxkBaZbBoSx9Rojo19vymy
	apbJSKBgkllCAH9BIrw71EY6OQ60xD4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771198924; a=rsa-sha256;
	cv=none;
	b=LixFMG5JdhLFUAkpCp6icdUaafIGo5FFzIDSmMTbBh89DSxb/eLr8v9yUlA+alaKa4+xzd
	I5+9ssedJzctiFWSc/JgdEI4/3S3aqH0yh3ZFEhTX4MX5dU/uouRp9PS6qOtMQNR8l3hQU
	J9OfZd7/GgcS5zjoux2dtRK/tWvzR3o=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ohVjIgyq;
	spf=pass (imf21.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 06E0261119;
	Sun, 15 Feb 2026 23:42:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A76FC19422;
	Sun, 15 Feb 2026 23:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771198923;
	bh=EF8S7FmFl3vSFKxHiqAFcxC7opaobmJHHkh7NyfesPA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ohVjIgyq+9ZcKRmy85+VAIPos6ieoFUf7IrfB0vpWBkF4UmMEIJGcb7X3KUIu7szr
	 uQp+/uHB89+wk4oLqScNs3x/4AKs9vyO6WBUXGIMKpZSWmh10K9TIK3nFv83V6mY+f
	 3FLGDsu8oRMyp6Ekxmwb+d3nnaraSnjz1U6/+9R3KKI5A3ZJKqrxQYYe8I0QyyaOsH
	 PjD9BxtoBixN2sAf9tLYSkyhkWl0dsqPZo9gNpNXbDasvkkhxcxoXBZ+egOFkckO3G
	 yQo4+hK0C0YQwHYvQait1QpFBjc1+x7ds+Uh4bCb5YlMzksGZPZ4gZQjLWNb85wOlQ
	 M43NGEbAZPdTQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 16 Feb 2026 00:35:13 +0100
Subject: [PATCH 26/79] block: rnull: add badblocks support
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-rnull-v6-19-rc5-send-v1-26-de9a7af4b469@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=8577; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=EF8S7FmFl3vSFKxHiqAFcxC7opaobmJHHkh7NyfesPA=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpklgzCA5NKN0hlzRJ+B3wI8OXUsh2VHHxSR288
 UF5GphVh4OJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZJYMwAKCRDhuBo+eShj
 d2wvEACO+eazDMVAJLN0GdcSEnzfv4GHoA4o8dfxM15esOo7Welb8VxAhDC2XXVg3Qb7tsdG3Wv
 yQ0qA8AvvWvnsdwXiElwFD14hB509xw5X7VZyEWLTmeUB7ZsKA0I/YSA3XSZr7+/C2e78nOPsf8
 faDFaVBXfb/pXA+Pm9YHNn6j1mlKBfFj2u0j6M8Ei+rvZRxm0KzTQHa8inblXNOXFxGNYkyAwdv
 eEqQ6LLNz1AspU0lNhC4rtn/DBzN9v6MHJCEqUtesRgrxoNd41B2A6h2NZrmX63hSwJEFHzatyj
 UXAZF7luejDKv4T2xgWsN/HPbuxRiRam9mT0fVxZO4zOtjqd+vbr6VteXCRLC1fQNytkvrOxX/0
 V46/1Qr9layTOdMPU6fF6hEDeV4wiJNImaicjCBNlEzmEY0g0sTjZ/xCq6XnQPeN5hVdI1MM3dl
 tKeIrYpzRDIPwrPQtoJ3JMwaIUMDeZhssAut5Dxu01PGoX2ayRd4Og8pJuVAJ61tVHPX8goJDkY
 PGAsDNIqyJybynjO2OFs0QdxeU8ali0gl3ivlIU3ycJ6APNzICDdHDoViaKV1fNPtx/FoOWxoPi
 2ugP9oVP+5W9lWVpGYFFkxD8nz+hAsVx6LCIpFfvXGrVhUWftQUDYs0zQ9sArU2lynbpttaYx0S
 o2ykBH3e1UR4mjg==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Queue-Id: 79B671C0004
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 44gpdontufpy83ohz8t74k39nz8s8k54
X-HE-Tag: 1771198924-868650
X-HE-Meta: U2FsdGVkX1/prIy43dlPWZ029GPRFGvUdHA74cwfOyubuMXBuU2tUUMJLxyeyTtW/q1sePGC+PnDUyEu6b+Ji6la5ihf+0nkVOJ/wJZ+Lg3UCFPTc10JLacmhvb4QrqgBY+kKd30uNte3CfnR70nbw9RN/z5ngenDAxMgLXmJQ5UvXtK3yXAcfOaOKaUPWmWqY+pkPXHf/Bgp+TM2/g+E00BGcU4nUWlybRMXP1EDpN1YgUG+OPps0rG3IC+4SLryvD/9LTKbg3inKH73sEI1SN1sY8iMML96v5KrBx4ehF4T8yLNlbehdOYBlUucOeNHpjTaOWLYL5s7Pjxa5mybA7tk/2M8/JFb97deo9l3VKbTCi06zsvJaG0SMFJJbDAYgIQSSDtaTAQWPgBVSIE58p92KC9k5lNx//+Id3rwHnG23iP2fJibRDjAE1WEiMtudfS627jjrftsafiFwk9o7K6TNJ/WDTYr/8yCGj08YNzwPwW6ks74RcFhtareDDFro3Biu6nholKaxrMTdsgxukhdVxlbPjtIoxjqPL0J4/c2ZpJFHxmPe48RWhFnjzKIq+p9uHycpX036KRoYwbG5EremiPjIszXa3Q/oYbIEIa2vp0ZuZl+MgsqmNOt3HsRlQjjZa2eHbBl8w9ChrR10qiXqa6ynm73cNTdQzoGb+k77hcAYmE3sH1DB14agm0tGc8HQmzSaVcMd5mQIe7X2iuw64Q45Qu05u0qO4MKbfRicMTIr6I7Z1FFZwHDITEfY+iSNBl7pLBOYUgX7mfhL+OtSinzFpM6VyUUNmRnB1+aS1r8mznctRkBtHoDpixllUn7EB2M91kRlgLsCpi11R3EHgkIJc0IkvnVHHtCRpzjqt3Dnib/5kK8gJEFxgOJscnJYCRdhcQTtSEm7eNDjx2tUn4HxYgHRjClOQi7L9BGBs9zkuakLjf59cvMY2w8umU2TNY77ZIgARuI73
 JcQHiXnW
 5Z7cIZDoyvgrIMEguTun5Y9keN+smk65CorX/4k0BMG+wB0EI0fKI2yQgqUyVTZdMSZkbk+H9G8kVyFWgR1ZdFPFDtCrYM1+jj3h6RKkK+RRrPf8itc+5poKXuWE82bGZ0y3SrcJQTlOqmAeipF9+imMIf+fsB00Qg3+tmkRjIPpLrMNKiEXqAlqpYvbYeDkwbQ/Zux2lSnYrxT3DlTwJwfR4Bq7W9B+a4EvaP2kTtkC+Bi6mOsKhmkWD3nS59hT9DutjhXzGxxmkWYyLIrFat0AbbNbKsD9WcASqNXQOx72qIL2onPVrPaBzNSUC0+wJjQ1u
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add badblocks support to the rnull driver with a configfs interface for
managing bad sectors.

- Configfs attribute for adding/removing bad blocks via "+start-end" and
  "-start-end" syntax.
- Request handling that checks for bad blocks and returns IO errors.
- Updated request completion to handle error status properly.

The badblocks functionality is disabled by default and is enabled when
first bad block is added.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 drivers/block/rnull/configfs.rs | 63 ++++++++++++++++++++++++++++++++++++++---
 drivers/block/rnull/rnull.rs    | 46 ++++++++++++++++++++++++++----
 2 files changed, 100 insertions(+), 9 deletions(-)

diff --git a/drivers/block/rnull/configfs.rs b/drivers/block/rnull/configfs.rs
index 18e32a87673aa..61a76addf468b 100644
--- a/drivers/block/rnull/configfs.rs
+++ b/drivers/block/rnull/configfs.rs
@@ -6,9 +6,12 @@
 };
 use kernel::{
     bindings,
-    block::mq::gen_disk::{
-        GenDisk,
-        GenDiskBuilder, //
+    block::{
+        badblocks::BadBlocks,
+        mq::gen_disk::{
+            GenDisk,
+            GenDiskBuilder, //
+        }, //
     },
     c_str,
     configfs::{
@@ -27,7 +30,10 @@
         kstrtobool_bytes,
         CString, //
     },
-    sync::Mutex,
+    sync::{
+        Arc,
+        Mutex, //
+    },
     time, //
 };
 use macros::{
@@ -96,6 +102,7 @@ fn make_group(
                 home_node: 9,
                 discard: 10,
                 no_sched:11,
+                badblocks: 12,
             ],
         };
 
@@ -118,6 +125,7 @@ fn make_group(
                     home_node: bindings::NUMA_NO_NODE,
                     discard: false,
                     no_sched: false,
+                    bad_blocks: Arc::pin_init(BadBlocks::new(false), GFP_KERNEL)?,
                 }),
             }),
             core::iter::empty(),
@@ -177,6 +185,7 @@ struct DeviceConfigInner {
     home_node: i32,
     discard: bool,
     no_sched: bool,
+    bad_blocks: Arc<BadBlocks>,
 }
 
 #[vtable]
@@ -212,6 +221,7 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
                 home_node: guard.home_node,
                 discard: guard.discard,
                 no_sched: guard.no_sched,
+                bad_blocks: guard.bad_blocks.clone(),
             })?);
             guard.powered = true;
         } else if guard.powered && !power_op {
@@ -367,3 +377,48 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
         Ok(())
     }
 }
+
+#[vtable]
+impl configfs::AttributeOperations<12> for DeviceConfig {
+    type Data = DeviceConfig;
+
+    fn show(this: &DeviceConfig, page: &mut [u8; PAGE_SIZE]) -> Result<usize> {
+        let ret = this.data.lock().bad_blocks.show(page, false);
+        if ret < 0 {
+            Err(Error::from_errno(ret as c_int))
+        } else {
+            Ok(ret as usize)
+        }
+    }
+
+    fn store(this: &DeviceConfig, page: &[u8]) -> Result {
+        // This attribute can be set while device is powered.
+
+        for line in core::str::from_utf8(page)?.lines() {
+            let mut chars = line.chars();
+            match chars.next() {
+                Some(sign @ '+' | sign @ '-') => {
+                    if let Some((start, end)) = chars.as_str().split_once('-') {
+                        let start: u64 = start.parse().map_err(|_| EINVAL)?;
+                        let end: u64 = end.parse().map_err(|_| EINVAL)?;
+
+                        if start > end {
+                            return Err(EINVAL);
+                        }
+
+                        this.data.lock().bad_blocks.enable();
+
+                        if sign == '+' {
+                            this.data.lock().bad_blocks.set_bad(start..=end, true)?;
+                        } else {
+                            this.data.lock().bad_blocks.set_good(start..=end)?;
+                        }
+                    }
+                }
+                _ => return Err(EINVAL),
+            }
+        }
+
+        Ok(())
+    }
+}
diff --git a/drivers/block/rnull/rnull.rs b/drivers/block/rnull/rnull.rs
index b0008e2f9c398..861392c5b5841 100644
--- a/drivers/block/rnull/rnull.rs
+++ b/drivers/block/rnull/rnull.rs
@@ -9,6 +9,7 @@
     bindings,
     block::{
         self,
+        badblocks::{self, BadBlocks},
         bio::Segment,
         mq::{
             self,
@@ -37,6 +38,10 @@
     str::CString,
     sync::{
         aref::ARef,
+        atomic::{
+            ordering,
+            Atomic, //
+        },
         Arc,
         Mutex, //
     },
@@ -155,6 +160,7 @@ fn init(_module: &'static ThisModule) -> impl PinInit<Self, Error> {
                     home_node: *module_parameters::home_node.value(),
                     discard: *module_parameters::discard.value() != 0,
                     no_sched: *module_parameters::no_sched.value() != 0,
+                    bad_blocks: Arc::pin_init(BadBlocks::new(false), GFP_KERNEL)?,
                 })?;
                 disks.push(disk, GFP_KERNEL)?;
             }
@@ -181,6 +187,7 @@ struct NullBlkOptions<'a> {
     home_node: i32,
     discard: bool,
     no_sched: bool,
+    bad_blocks: Arc<BadBlocks>,
 }
 struct NullBlkDevice;
 
@@ -198,6 +205,7 @@ fn new(options: NullBlkOptions<'_>) -> Result<GenDisk<Self>> {
             home_node,
             discard,
             no_sched,
+            bad_blocks,
         } = options;
 
         let mut flags = mq::tag_set::Flags::default();
@@ -226,6 +234,7 @@ fn new(options: NullBlkOptions<'_>) -> Result<GenDisk<Self>> {
                 completion_time,
                 memory_backed,
                 block_size: block_size.into(),
+                bad_blocks,
             }),
             GFP_KERNEL,
         )?;
@@ -327,6 +336,16 @@ fn transfer(
         }
         Ok(())
     }
+
+    fn end_request(rq: Owned<mq::Request<Self>>) {
+        let status = rq.data_ref().error.load(ordering::Relaxed);
+        rq.data_ref().error.store(0, ordering::Relaxed);
+
+        match status {
+            0 => rq.end_ok(),
+            _ => rq.end(bindings::BLK_STS_IOERR),
+        }
+    }
 }
 
 const _CHEKC_STATUS_WIDTH: () = build_assert!((PAGE_SIZE >> SECTOR_SHIFT) <= 64);
@@ -373,12 +392,14 @@ struct QueueData {
     completion_time: Delta,
     memory_backed: bool,
     block_size: u64,
+    bad_blocks: Arc<BadBlocks>,
 }
 
 #[pin_data]
 struct Pdu {
     #[pin]
     timer: kernel::time::hrtimer::HrTimer<Self>,
+    error: Atomic<u32>,
 }
 
 impl HrTimerCallback for Pdu {
@@ -408,6 +429,7 @@ impl Operations for NullBlkDevice {
     fn new_request_data() -> impl PinInit<Self::RequestData> {
         pin_init!(Pdu {
             timer <- kernel::time::hrtimer::HrTimer::new(),
+            error: Atomic::new(0),
         })
     }
 
@@ -417,6 +439,19 @@ fn queue_rq(
         mut rq: Owned<mq::Request<Self>>,
         _is_last: bool,
     ) -> Result {
+        if queue_data.bad_blocks.enabled() {
+            let start = rq.sector();
+            let end = start + u64::from(rq.sectors());
+            if !matches!(
+                queue_data.bad_blocks.check(start..end),
+                badblocks::BlockStatus::None
+            ) {
+                rq.data_ref().error.store(1, ordering::Relaxed);
+            }
+        }
+
+        // TODO: Skip IO if bad block.
+
         if queue_data.memory_backed {
             let tree = &queue_data.tree;
             let command = rq.command();
@@ -437,7 +472,7 @@ fn queue_rq(
         }
 
         match queue_data.irq_mode {
-            IRQMode::None => rq.end_ok(),
+            IRQMode::None => Self::end_request(rq),
             IRQMode::Soft => mq::Request::complete(rq.into()),
             IRQMode::Timer => {
                 OwnableRefCounted::into_shared(rq)
@@ -451,9 +486,10 @@ fn queue_rq(
     fn commit_rqs(_queue_data: Pin<&QueueData>) {}
 
     fn complete(rq: ARef<mq::Request<Self>>) {
-        OwnableRefCounted::try_from_shared(rq)
-            .map_err(|_e| kernel::error::code::EIO)
-            .expect("Failed to complete request")
-            .end_ok();
+        Self::end_request(
+            OwnableRefCounted::try_from_shared(rq)
+                .map_err(|_e| kernel::error::code::EIO)
+                .expect("Failed to complete request"),
+        )
     }
 }

-- 
2.51.2



