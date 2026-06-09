Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1F4ECD8CB9
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:15:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4728C6B00D4; Tue,  9 Jun 2026 15:15:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44B486B0105; Tue,  9 Jun 2026 15:15:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 361036B0106; Tue,  9 Jun 2026 15:15:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 25F236B00D4
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:15:57 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E0DB1C2757
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:15:56 +0000 (UTC)
X-FDA: 84861329112.30.45BCFEF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id EFC72180017
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:15:54 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PJRuMeub;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781032555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XwkzM7VKd2QXL9hc4jVTBaLQ2ofiUVQa/wzCehzlLfg=;
	b=dJW8PMy+lgatAp1YTSSeS4hpvpCaMgAXYPLDXJvpNIhttHfWKrWYsMfp+MYstahzsbsSx+
	OLAEMt7/aHK3bqGz0kb64gvxKmUeYVhg5sI+/8v18eSedzC9yBxEdjPizrp3x7jzdoZg1v
	vQPsBYAQoGu9ovQ13/xZEzqKbWGi0cA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PJRuMeub;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781032555;
	b=B7xmjVBcnolTj6ckogfaHcYmh9P7hUZOsMpEHRAtcOBDYJQvPB/uYY7ZlFiDXTbwNV3zVv
	G9uBg1LvSo5TrC5cyHvRxkmFzIUIVJuUvCP45D9k/EMWeRQQHtFeOhr0o8t8yxXSZYvtZ4
	g9kOJ27llJqA61WmKSkvErEnrgb8xhw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4092A4416D;
	Tue,  9 Jun 2026 19:15:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67BD01F00893;
	Tue,  9 Jun 2026 19:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781032554;
	bh=XwkzM7VKd2QXL9hc4jVTBaLQ2ofiUVQa/wzCehzlLfg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=PJRuMeubNxh1PQSzxL1DyB41AIrvdek8nDKPtSKhm5o0NviyKSTiVrhDLu3iguEBd
	 0xplh6V9VIdWerS8y8DtTZmmThWVU95nzC9QpGylXKU46KuVuhXlvX1CkzsOu+JoCe
	 MjbNF4bZ8B7n25zVRSn0JlV/mgNqTLFHn0oOt9AFFFqYQwcGNwNUe07KPJxHyFvlxZ
	 Uu7ZwCkEGreSa0hJGaoJKGkcUPY8MxZzIjviUr2EHCVUDXUEgt3mRmbGBZP/66UZ2W
	 OV/8H3/4WZpxm6Pd3jfQqPZJXa4soGpN8YNs6Y1td/O2Drf+0BrX00P4V/lDtDuomn
	 uR2Eh6VVq7z5g==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 09 Jun 2026 21:08:23 +0200
Subject: [PATCH v2 44/83] block: rnull: add bandwidth limiting
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-rnull-v6-19-rc5-send-v2-44-82c7404542e2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=10642;
 i=a.hindborg@kernel.org; h=from:subject:message-id;
 bh=pjTJV6lpFGJdbnqxGVPCelvpzcvZdwrgNcXyn+EPT0s=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqKGTc6+ODZ65AqoAf371RvHz/OnyK5XGNwDbnU
 VCqT77xgpuJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaihk3AAKCRD6UCkIqsW9
 0JWaD/9mQPWw4JE9i9ltAG5BKZTUckOkIUd7RZ4WGZ4lMe6tJZhAq3cT8nktOiW9M0bpzIgKIxn
 zvuvxpqbwe8dQplaQYysdwCAGcn+HP0sBEBtscs8KVgMMokJ9nBgmFvYRs6YJ8Tcb+p19D2kyWd
 LTX2g/vNcZpNfuMKQXgkE28gwts3AruCAUXNY9LdMN1JGBp0gCNdVCxArt9xgwk0bXStMYm8e4/
 PvKOSHSdDspS/YiNaqzcXvFuDqiEos9gX6gOGqIo3jw963sZZH3IHmpaQD7MMbUHnfOJqPVrKYh
 vk/0QP3ErfWjqJA2N1BmOVmoOLN0zmzfxNI/tKk2kBrn9mxR7XBVPZA5cJaoVCR2HC9KasgmsOP
 rXaf/U4Mmm5Qxl3koLOoY/6DIXTR6RL8YYB1Hdp0hlI8KjvMoAyVOJ2EmMMq6QjV1hTdSQns+wj
 oMsdvt+nwsXit4Nldq6dvzXVHZYT+5cVPCI8s/B/W1yDFENImrG+c9LwvAjh7lbkpIIbR7jcDiy
 /+u6dLn7ukZ4PLM7XGvfLq5xcPqQterwMaq/Egacm65c5lpeGPrRhcSDdm6YgtIgr57sc2JUkkH
 ytSxT7XAWiHYky9m5qKgtQhOr5Z5/7ST297dsw9YFwT2lLyok596jljmWq8MHMJa83kwIaqKOUA
 GUJBbFBDOVZunyQ==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EFC72180017
X-Stat-Signature: ei6dk7qp33sy1r5qfpt8wmtkemp5ie1r
X-Rspam-User: 
X-HE-Tag: 1781032554-425671
X-HE-Meta: U2FsdGVkX196JtZqPNrGL8J6puhkyi1UXSfxY7pw0kQMPG/zXXkie15WDCg1degWlyNdwumD0iehUIZrJM8HTVCcadsmZOxduzWwdlOgemUPMgUY8EIcvTAOSWSTW4KQwru6j2oXeMoLYyof+aLD81jowuw6YsM8Lsuv44BODscnz4hO+mY/U07mu+W8r9ult1Tnz9xeo3YVMFvf9lM8P/aSuxcxEaGiSzavYy54hR1e/1r4l/bBqZakVDoGTg8KgiXjY761viYEi33kli/a7ZdZIhfZW85T8vb6p1MPwNNEwtJnIDSQqsa+tEWlzLo+vR5HwyFNKEj4ebRM4NFb3HiAVxDDg4uf1wove5z/Et39FWwD84//i0jKRS0dW3Z5ZCTt/3GJixIFyaQG2vMclxvS+0gkAlZPo0MC0dEOUC6vf3k+nrhJF9oHNyXPvTBpmDkve1rABG/I7VD2VSSzVNiqmpxj7hRmhwT3KmLVPHIp+7mJUFTQnPSEwGkr/3LE6qBFhONUL7n7w5jPKp8NZZfV5gHo7Y8MdtVnuhTgeEqVEiGbIlVgcL+4X1DRJkrzIdXLNjOxPD3pZUG/AIcT6PcJRaPE4G4bji7SBc4sAzeqTdajwFSEK3AfJEmWhqmvxJZBZOZ93F/oymATUg/tFjx4p8duE29a3qRnmU2U8JY1WsdyTBiXiUGouaKCIHg3auEQHADwGnIvkiK8xCqMUHRSX1RAnyJfUjGoqvxo53z1xDln/6qp0/X1slGTwH6m76XU9pYU7QnCu7Kl6tDrmu3+oVIN7Yw7aZXiDVDUf653qF3S8e0R5eQTdkeEzGGq9heZAIOOpz2bLubkl1JnF0ebRY5vW81G09RLu/OesZUjkTamhHcfW1+8aiDPyq0hlibNd/4vusTDJqxKIA/K4d0agKLPkWU5Ey150FcKW8NWIgkH15kpln0tD3p2iteKBEWajXIc2sGTrWN2bRP
 n/CTZZVh
 sgHeml/rWWYtaYo/oBlN8F58QxcTCYl3kt2awOY4oyCEHSEI5AOJ7FRcOTHXajMtc2UllLu/QIG/SWNFL08avzO6+NDiSs1LFmn8O7EcOWQmMr2bMrzrW0XyJgznQBOyWQVVB+JlKGAydwaSFUJ+CQYnC0no2djyDbg70HUkjI3iC68YnNwv1UWOTYOxHAY8GhL/hfcoWMo87v/ILI28wsUqlDmeNyeSMdkpioA6X52o8dgWshEZgRN7vfur7dk5olrHNSlmvr+ig8fQl2SCXbb77sQEHgc0NrPO3sEDPNYCR5SdfOOOO4wgs17TQgPtxdx34
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
index 4df0b748596a..59217d75f46b 100644
--- a/drivers/block/rnull/configfs.rs
+++ b/drivers/block/rnull/configfs.rs
@@ -104,6 +104,7 @@ fn make_group(
                 badblocks_once: 13,
                 badblocks_partial_io: 14,
                 cache_size_mib: 15,
+                mbps: 16,
             ],
         };
 
@@ -135,6 +136,7 @@ fn make_group(
                         GFP_KERNEL
                     )?,
                     cache_size_mib: 0,
+                    mbps: 0,
                 }),
             }),
             core::iter::empty(),
@@ -209,6 +211,7 @@ struct DeviceConfigInner {
     bad_blocks_partial_io: bool,
     cache_size_mib: u64,
     disk_storage: Arc<DiskStorage>,
+    mbps: u32,
 }
 
 #[vtable]
@@ -248,6 +251,7 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
                 bad_blocks_once: guard.bad_blocks_once,
                 bad_blocks_partial_io: guard.bad_blocks_partial_io,
                 storage: guard.disk_storage.clone(),
+                bandwidth_limit: u64::from(guard.mbps) * 2u64.pow(20),
             })?);
             guard.powered = true;
         } else if guard.powered && !power_op {
@@ -259,7 +263,6 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
     }
 }
 
-// DiskStorage::new(cache_size_mib << 20, block_size as usize),
 configfs_simple_field!(DeviceConfig, 1, block_size, u32, check GenDiskBuilder::validate_block_size);
 configfs_simple_bool_field!(DeviceConfig, 2, rotational);
 configfs_simple_field!(DeviceConfig, 3, capacity_mib, u64);
@@ -417,3 +420,5 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
         Ok(())
     })
 );
+
+configfs_simple_field!(DeviceConfig, 16, mbps, u32);
diff --git a/drivers/block/rnull/rnull.rs b/drivers/block/rnull/rnull.rs
index 6ceba23a4d3e..1dda8d717b95 100644
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
@@ -37,25 +38,32 @@
         Result, //
     },
     ffi,
+    impl_has_hr_timer,
     memalloc_scope,
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
@@ -127,6 +135,10 @@
             default: false,
             description: "No IO scheduler",
         },
+        mbps: u32 {
+            default: 0,
+            description: "Max bandwidth in MiB/s. 0 means no limit.",
+        },
     },
 }
 
@@ -172,6 +184,7 @@ fn init(_module: &'static ThisModule) -> impl PinInit<Self, Error> {
                     bad_blocks_once: false,
                     bad_blocks_partial_io: false,
                     storage: Arc::pin_init(DiskStorage::new(0, block_size as usize), GFP_KERNEL)?,
+                    bandwidth_limit: u64::from(module_parameters::mbps.value()) * 2u64.pow(20),
                 })?;
                 disks.push(disk, GFP_KERNEL)?;
             }
@@ -202,6 +215,7 @@ struct NullBlkOptions<'a> {
     bad_blocks_once: bool,
     bad_blocks_partial_io: bool,
     storage: Arc<DiskStorage>,
+    bandwidth_limit: u64,
 }
 
 #[pin_data]
@@ -214,9 +228,18 @@ struct NullBlkDevice {
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
@@ -234,6 +257,7 @@ fn new(options: NullBlkOptions<'_>) -> Result<Arc<GenDisk<Self>>> {
             bad_blocks_once,
             bad_blocks_partial_io,
             storage,
+            bandwidth_limit,
         } = options;
 
         let mut flags = mq::tag_set::Flags::default();
@@ -268,7 +292,7 @@ fn new(options: NullBlkOptions<'_>) -> Result<Arc<GenDisk<Self>>> {
             GFP_KERNEL,
         )?;
 
-        let queue_data = Box::try_pin_init(
+        let queue_data = Arc::try_pin_init(
             try_pin_init!(Self {
                 storage,
                 irq_mode,
@@ -278,6 +302,11 @@ fn new(options: NullBlkOptions<'_>) -> Result<Arc<GenDisk<Self>>> {
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
@@ -294,7 +323,10 @@ fn new(options: NullBlkOptions<'_>) -> Result<Arc<GenDisk<Self>>> {
                 .max_hw_discard_sectors(ffi::c_uint::MAX >> block::SECTOR_SHIFT);
         }
 
-        builder.build(fmt!("{}", name.to_str()?), tagset, queue_data)
+        let disk = builder.build(fmt!("{}", name.to_str()?), tagset, queue_data)?;
+        let queue_data: ArcBorrow<'_, Self> = disk.queue_data();
+        queue_data.disk.populate(disk.get_ref());
+        Ok(disk)
     }
 
     fn sheaf_size() -> usize {
@@ -522,6 +554,36 @@ fn end_request(rq: Owned<mq::Request<Self>>) {
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
@@ -529,7 +591,7 @@ struct HwQueueContext {
 #[pin_data]
 struct Pdu {
     #[pin]
-    timer: kernel::time::hrtimer::HrTimer<Self>,
+    timer: HrTimer<Self>,
     error: Atomic<u32>,
 }
 
@@ -578,14 +640,14 @@ fn align_down<T>(value: T, to: T) -> T
 
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
@@ -593,14 +655,39 @@ fn new_request_data() -> impl PinInit<Self::RequestData> {
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
             memalloc_scope!(let _noio: NoIo);
@@ -623,7 +710,7 @@ fn queue_rq(
         Ok(())
     }
 
-    fn commit_rqs(_hw_data: Pin<&SpinLock<HwQueueContext>>, _queue_data: Pin<&Self>) {}
+    fn commit_rqs(_hw_data: Pin<&SpinLock<HwQueueContext>>, _queue_data: ArcBorrow<'_, Self>) {}
 
     fn init_hctx(_tagset_data: (), _hctx_idx: u32) -> Result<Self::HwData> {
         KBox::pin_init(new_spinlock!(HwQueueContext { page: None }), GFP_KERNEL)

-- 
2.51.2



