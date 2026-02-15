Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D9B8E63F25
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 04:16:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83B236B011A; Sun, 15 Feb 2026 18:56:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E5916B011C; Sun, 15 Feb 2026 18:56:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B9B86B011D; Sun, 15 Feb 2026 18:56:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 48F3E6B011A
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 18:56:15 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A9D3EBBEA3
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:46:38 +0000 (UTC)
X-FDA: 84448328076.28.02CEA8A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id CFCE21C000F
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:46:36 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=apYQLKSE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771199197; a=rsa-sha256;
	cv=none;
	b=phPAjCFixbku0orr+yzHX6gOe3KmI+yDzezt2o2qWjDj4RwBGVyGI1WWXWydeACfXZTXIp
	EWKGkI05TMi9+B5ig8nTd2wTx2IBbKH+0ApZOfPWrBDlbwiFPCVr2CSBeXDkWrWytDKfLw
	FFVxDweYu1t0H4z5Ni+/HaHEFbwjQrU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=apYQLKSE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771199197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wXBmfS8UstdyI5MUkdOdM5VjatSGPDOXpj93BAVn5LE=;
	b=HPNp5eRY2PyUI7SoKJD/rn3i7GvOs896RGIaRUZr83pjiCJdO7dap/a61PLe53fy5ZLFV1
	JREY3LMzgbA5zIoC9YZDsdAcPrDo0Hej6np6oXxP/HyzOjdxZx4FwalS5QIZN7a+khXKYf
	6qPrwwxoWM9OnIuxJXAsXKt7IhYyiuM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EB4AA41898;
	Sun, 15 Feb 2026 23:46:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D11CC4CEF7;
	Sun, 15 Feb 2026 23:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771199195;
	bh=1D3Qowx2aO/t4IbOvgsohdBDGHVkeFHvWTMo4nJU384=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=apYQLKSEGKioDBmRLdyp49YhhecKtiE4t5lJ1+rq6Eqnw5uAOhOdqKGstI6n3JrPQ
	 4jY6cBFbWPOcya15GtWyOaNkjSP1/YVcHiO7iCHqC9+aJBHnbHnPIWpyc8IBFplC+m
	 2iLz979YOrDEYF3hKy36fH0FY2ZQo+ob8YGuuGOe1iFx31rTm2au3/RJV9in0Mz7Wn
	 VgWrNweaTCoYWM6akq3agJRPDFiLe2IQ1Nwy6cz6Y3VbrOfM6DwCf3/3RXZ2QYhRW+
	 /8Dzy0ucH1lDoPgbznEKC0tCFtZKBSShiGcL5Wx6Y+rkmJc5jscse5T7uS+tB80Auw
	 qVhe9/gVxleMg==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 16 Feb 2026 00:35:27 +0100
Subject: [PATCH 40/79] block: rnull: add bandwidth limiting
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-rnull-v6-19-rc5-send-v1-40-de9a7af4b469@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=10640;
 i=a.hindborg@kernel.org; h=from:subject:message-id;
 bh=1D3Qowx2aO/t4IbOvgsohdBDGHVkeFHvWTMo4nJU384=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpklg/lJ8RWBn2XqZv3u9MAaleDBN4J6c9pL1EJ
 bQYXASf7kGJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZJYPwAKCRDhuBo+eShj
 d6adEAC1AoqKlyjEncpLkoQZDBtLyNnZisBjZMEGbED4jlqtXi+tqor3i/XT+zMdn2i0SSNUM2o
 ymEeqxJzhJsRd/xOhFQ5tvangLI53sBloxbomvjTtAAk0L6BOLFf9GWHGdHj+Ma9f9PXC6mblIO
 WEYHUe3pF6ffQdmS1RPsKX4TbNxJ1CYIEShynTnp5yq842QSs620NFz0YKZhHPQL9DZPiyelcX8
 PykJ92EkZbLZeRB3ND2+gYpgm7k/55TKcwlDz9JzQhvi4KEhAZIeDEPujmY0+xlgElZNvIwR17P
 PMrwhJHoN3aeEPx6IK8m2jArV64/JV1qWRF9Taop6aiGribyIY5Ot1tbBIeeaI0Bk0OB6HsK8aH
 EkJYzXTcxjmZ8mP449ZiB384I+HUc5i0tt/klS6ld0FIgkrtpOl8MV+TT4n4ADEl7HeFHw9cX80
 2Z5Ujr6UQa4xck2quT/mYwyOlgx7lohn1s0H4JE7CwSm6rcaoUP+ZhxGWUtpxTuRpocZAc++cAb
 XswxLn6fVPoF2MHD3ZHeBCDhWlQJi7XZjGe2ARzj5u++0y9wQ8fiQs4BGwjVdBwHYpFJy0Wcqa7
 rXAnGj7bUGfIelI24lgLX21Osa+v1fX49660d9PP3dB5jM4OEv+/E/pF/CvmOdYJZi7pp4YO6Sh
 szGVbzqkiaQle+g==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: CFCE21C000F
X-Stat-Signature: zk1wo7qf3x4opscqdw4whoh9fdifgic9
X-HE-Tag: 1771199196-846297
X-HE-Meta: U2FsdGVkX1+f0MAdajqCFHGtzzmrnn/jTr7g+dqd1vI2DKCqQRf4LEWCXd6uvDnlwhz67Bl1rMEGQbq47ERxWxbC1xS9g+h+OM7Cjoy51m9dyg3c+LWms66eZm6f81bsQ/sSJDAJwmFEU6ZvY0F9LlpAbepVkgk836JfmeGcYgAm6ZPVPMsiJSZRVt9JTLuwg2bLkZ9qBJ7oLE1A0yPvIDgQ8TUtzSiBEm6LpSuxoPZlt8aWem7c4xDtstZxPrb7x/iL/cFmrR9B/87hxqJCx6XzKrcq77uwi3C35gJzTIZHfEbn435u/j5d14rWlhvKYKoS8meEiADPHUrihirCRDdEMyEB2btiNQUryqXDEHjycfMz75nenIg1CviQPUduMy/1+jMyARIOwXKmPsH0Zo+ReVbzRtmAHgpje4XfQylN6coNuoBt233HuEOroY0SLfMYNcLdAtIwjqP6dhbs05yo7ylzTmngp+9iBMSK3U1t6z0Sa0SvA+9GReVnGCCZa0hJKlone6LqJeXqOlPPq64cLTzTmiZdOTr6mexdDoiCBAYZoUACfaDAk3yqkQMkkjbHoh1jar5rAvrdTIhWstJ4GrobJjxfgEqoMoyYcBEwYhAUbJk5gULgsCBcYBgKnAiBvVjP9dU3HyRQTQHEHZttecDVho11Eb8dgeOS/0Z+fif61RaIcROWQLwrD06hOWYPND5H5NXFVhwB1T5mCJyebWEN+09TvTHB+Ai7koWSvkDs78103y0Fxf+cgJJlT845D9m0/KsA1LJ6b7+hPrHf99szKGcPJ3/tgNsB/gyo8gw3wLY2YuTttdmAn9VuhwjL3I17+k+MazeTK7RJWVV2J1jf9oN2sQeAhqtqWqbe9UrbyLh1nijZ/nstHq1mUjIW7+yPA17Ag6cY9fWKeTHO/1+7QGxITnQ9zhzdFheCoXp7Nrn5plA2tpqxmoJS8Bv8fFRSaVGH8fm80rp
 iaHzc60+
 21g5S35/gZRmjzJyFie8OPYqWWp+kNuVsKZMXnQO0jZzQo4uExiyuO5/AEEim5Sa4qmG1KmcirPwBw0DdafRbCwPMuZYGSxeuiKESWCPGMfxrY6gTR5duKbOSSkOwT6oBq2gBCeRDhPPpwn1nTDiwg2BfPSdcoPaBa522Vu50Pz8sHGV6UVTo1ZDm609gtSB8Zu6tSzL8uFN9tLg5lHrBdsQKhYmgwwMbV52WqiUd4qAmfAHboSIF0ghst3LeQ3QK4faxJ6zteNh7oHYwgM4PUMWbGyQ0M2xful3bp5yuo3OfCJwjd5t/fLwbwlFPtcjDMQlU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add bandwidth limiting support to rnull via the `mbps` configfs
attribute. When set to a non-zero value, the driver limits I/O
throughput to the specified rate in megabytes per second.

The implementation uses a token bucket algorithm to enforce the rate
limit, delaying request completion when the limit is exceeded.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 drivers/block/rnull/configfs.rs |   7 ++-
 drivers/block/rnull/rnull.rs    | 111 +++++++++++++++++++++++++++++++++++-----
 2 files changed, 105 insertions(+), 13 deletions(-)

diff --git a/drivers/block/rnull/configfs.rs b/drivers/block/rnull/configfs.rs
index e365eb06be6de..d369d8b683c61 100644
--- a/drivers/block/rnull/configfs.rs
+++ b/drivers/block/rnull/configfs.rs
@@ -105,6 +105,7 @@ fn make_group(
                 badblocks_once: 13,
                 badblocks_partial_io: 14,
                 cache_size_mib: 15,
+                mbps: 16,
             ],
         };
 
@@ -136,6 +137,7 @@ fn make_group(
                         GFP_KERNEL
                     )?,
                     cache_size_mib: 0,
+                    mbps: 0,
                 }),
             }),
             core::iter::empty(),
@@ -200,6 +202,7 @@ struct DeviceConfigInner {
     bad_blocks_partial_io: bool,
     cache_size_mib: u64,
     disk_storage: Arc<DiskStorage>,
+    mbps: u32,
 }
 
 #[vtable]
@@ -239,6 +242,7 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
                 bad_blocks_once: guard.bad_blocks_once,
                 bad_blocks_partial_io: guard.bad_blocks_partial_io,
                 storage: guard.disk_storage.clone(),
+                bandwidth_limit: u64::from(guard.mbps) * 2u64.pow(20),
             })?);
             guard.powered = true;
         } else if guard.powered && !power_op {
@@ -250,7 +254,6 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
     }
 }
 
-// DiskStorage::new(cache_size_mib << 20, block_size as usize),
 configfs_simple_field!(DeviceConfig, 1, block_size, u32, check GenDiskBuilder::validate_block_size);
 configfs_simple_bool_field!(DeviceConfig, 2, rotational);
 configfs_simple_field!(DeviceConfig, 3, capacity_mib, u64);
@@ -457,3 +460,5 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
         Ok(())
     })
 );
+
+configfs_simple_field!(DeviceConfig, 16, mbps, u32);
diff --git a/drivers/block/rnull/rnull.rs b/drivers/block/rnull/rnull.rs
index 55cbdfed25414..16a4f915e59f4 100644
--- a/drivers/block/rnull/rnull.rs
+++ b/drivers/block/rnull/rnull.rs
@@ -25,7 +25,8 @@
             self,
             gen_disk::{
                 self,
-                GenDisk, //
+                GenDisk,
+                GenDiskRef, //
             },
             Operations,
             TagSet, //
@@ -37,24 +38,31 @@
         Result, //
     },
     ffi,
+    impl_has_hr_timer,
     new_mutex,
     new_spinlock,
     pr_info,
     prelude::*,
+    revocable::Revocable,
     str::CString,
     sync::{
         aref::ARef,
         atomic::{
             ordering,
             Atomic, //
-        }, //
+        },
         Arc,
+        ArcBorrow,
         Mutex,
+        SetOnce,
         SpinLock,
-        SpinLockGuard,
+        SpinLockGuard, //
     },
     time::{
         hrtimer::{
+            self,
+            ArcHrTimerHandle,
+            HrTimer,
             HrTimerCallback,
             HrTimerCallbackContext,
             HrTimerPointer,
@@ -129,6 +137,10 @@
             default: 0,
             description: "No IO scheduler",
         },
+        mbps: u32 {
+            default: 0,
+            description: "Max bandwidth in MiB/s. 0 means no limit.",
+        },
     },
 }
 
@@ -174,6 +186,7 @@ fn init(_module: &'static ThisModule) -> impl PinInit<Self, Error> {
                     bad_blocks_once: false,
                     bad_blocks_partial_io: false,
                     storage: Arc::pin_init(DiskStorage::new(0, block_size as usize), GFP_KERNEL)?,
+                    bandwidth_limit: u64::from(*module_parameters::mbps.value()) * 2u64.pow(20),
                 })?;
                 disks.push(disk, GFP_KERNEL)?;
             }
@@ -204,6 +217,7 @@ struct NullBlkOptions<'a> {
     bad_blocks_once: bool,
     bad_blocks_partial_io: bool,
     storage: Arc<DiskStorage>,
+    bandwidth_limit: u64,
 }
 
 #[pin_data]
@@ -216,9 +230,18 @@ struct NullBlkDevice {
     bad_blocks: Arc<BadBlocks>,
     bad_blocks_once: bool,
     bad_blocks_partial_io: bool,
+    bandwidth_limit: u64,
+    #[pin]
+    bandwidth_timer: HrTimer<Self>,
+    bandwidth_bytes: Atomic<u64>,
+    #[pin]
+    bandwidth_timer_handle: SpinLock<Option<ArcHrTimerHandle<Self>>>,
+    disk: SetOnce<Arc<Revocable<GenDiskRef<Self>>>>,
 }
 
 impl NullBlkDevice {
+    const BANDWIDTH_TIMER_INTERVAL: Delta = Delta::from_millis(20);
+
     fn new(options: NullBlkOptions<'_>) -> Result<Arc<GenDisk<Self>>> {
         let NullBlkOptions {
             name,
@@ -236,6 +259,7 @@ fn new(options: NullBlkOptions<'_>) -> Result<Arc<GenDisk<Self>>> {
             bad_blocks_once,
             bad_blocks_partial_io,
             storage,
+            bandwidth_limit,
         } = options;
 
         let mut flags = mq::tag_set::Flags::default();
@@ -260,7 +284,7 @@ fn new(options: NullBlkOptions<'_>) -> Result<Arc<GenDisk<Self>>> {
             GFP_KERNEL,
         )?;
 
-        let queue_data = Box::try_pin_init(
+        let queue_data = Arc::try_pin_init(
             try_pin_init!(Self {
                 storage,
                 irq_mode,
@@ -270,6 +294,11 @@ fn new(options: NullBlkOptions<'_>) -> Result<Arc<GenDisk<Self>>> {
                 bad_blocks,
                 bad_blocks_once,
                 bad_blocks_partial_io,
+                bandwidth_limit: bandwidth_limit / 50,
+                bandwidth_timer <- HrTimer::new(),
+                bandwidth_bytes: Atomic::new(0),
+                bandwidth_timer_handle <- new_spinlock!(None),
+                disk: SetOnce::new(),
             }),
             GFP_KERNEL,
         )?;
@@ -286,7 +315,10 @@ fn new(options: NullBlkOptions<'_>) -> Result<Arc<GenDisk<Self>>> {
                 .max_hw_discard_sectors(ffi::c_uint::MAX >> block::SECTOR_SHIFT);
         }
 
-        builder.build(fmt!("{}", name.to_str()?), tagset, queue_data)
+        let disk = builder.build(fmt!("{}", name.to_str()?), tagset, queue_data)?;
+        let queue_data: ArcBorrow<'_, Self> = disk.queue_data();
+        queue_data.disk.populate(disk.get_ref());
+        Ok(disk)
     }
 
     fn sheaf_size() -> usize {
@@ -504,6 +536,36 @@ fn end_request(rq: Owned<mq::Request<Self>>) {
     }
 }
 
+impl_has_hr_timer! {
+    impl HasHrTimer<Self> for NullBlkDevice {
+        mode: hrtimer::RelativeHardMode<kernel::time::Monotonic>,
+        field: self.bandwidth_timer,
+    }
+}
+
+impl HrTimerCallback for NullBlkDevice {
+    type Pointer<'a> = Arc<Self>;
+
+    fn run(
+        this: ArcBorrow<'_, Self>,
+        mut context: HrTimerCallbackContext<'_, Self>,
+    ) -> HrTimerRestart {
+        if this.bandwidth_bytes.load(ordering::Relaxed) == 0 {
+            return HrTimerRestart::NoRestart;
+        }
+
+        this.disk.as_ref().map(|disk| {
+            disk.try_access()
+                .map(|disk| disk.queue().start_stopped_hw_queues_async())
+        });
+
+        this.bandwidth_bytes.store(0, ordering::Relaxed);
+
+        context.forward_now(Self::BANDWIDTH_TIMER_INTERVAL);
+        HrTimerRestart::Restart
+    }
+}
+
 struct HwQueueContext {
     page: Option<KBox<disk_storage::NullBlockPage>>,
 }
@@ -511,7 +573,7 @@ struct HwQueueContext {
 #[pin_data]
 struct Pdu {
     #[pin]
-    timer: kernel::time::hrtimer::HrTimer<Self>,
+    timer: HrTimer<Self>,
     error: Atomic<u32>,
 }
 
@@ -560,14 +622,14 @@ fn align_down<T>(value: T, to: T) -> T
 
 #[vtable]
 impl Operations for NullBlkDevice {
-    type QueueData = Pin<KBox<Self>>;
+    type QueueData = Arc<Self>;
     type RequestData = Pdu;
     type TagSetData = ();
     type HwData = Pin<KBox<SpinLock<HwQueueContext>>>;
 
     fn new_request_data() -> impl PinInit<Self::RequestData> {
         pin_init!(Pdu {
-            timer <- kernel::time::hrtimer::HrTimer::new(),
+            timer <- HrTimer::new(),
             error: Atomic::new(0),
         })
     }
@@ -575,14 +637,39 @@ fn new_request_data() -> impl PinInit<Self::RequestData> {
     #[inline(always)]
     fn queue_rq(
         hw_data: Pin<&SpinLock<HwQueueContext>>,
-        this: Pin<&Self>,
+        this: ArcBorrow<'_, Self>,
         rq: Owned<mq::IdleRequest<Self>>,
         _is_last: bool,
     ) -> BlkResult {
-        let mut rq = rq.start();
         let mut sectors = rq.sectors();
 
-        Self::handle_bad_blocks(this.get_ref(), &mut rq, &mut sectors)?;
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
+                return Err(kernel::block::error::code::BLK_STS_DEV_RESOURCE);
+            }
+        }
+
+        let mut rq = rq.start();
+
+        use core::ops::Deref;
+        Self::handle_bad_blocks(this.deref(), &mut rq, &mut sectors)?;
 
         if this.memory_backed {
             if rq.command() == bindings::req_op_REQ_OP_DISCARD {
@@ -604,7 +691,7 @@ fn queue_rq(
         Ok(())
     }
 
-    fn commit_rqs(_hw_data: Pin<&SpinLock<HwQueueContext>>, _queue_data: Pin<&Self>) {}
+    fn commit_rqs(_hw_data: Pin<&SpinLock<HwQueueContext>>, _queue_data: ArcBorrow<'_, Self>) {}
 
     fn init_hctx(_tagset_data: (), _hctx_idx: u32) -> Result<Self::HwData> {
         KBox::pin_init(new_spinlock!(HwQueueContext { page: None }), GFP_KERNEL)

-- 
2.51.2



