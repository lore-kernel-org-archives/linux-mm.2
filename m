Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C09ACD8CB2
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:16:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 843FA6B00CB; Tue,  9 Jun 2026 15:16:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81AFE6B0108; Tue,  9 Jun 2026 15:16:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 731656B0109; Tue,  9 Jun 2026 15:16:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 63BCB6B00CB
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:16:13 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2C7001406EF
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:16:13 +0000 (UTC)
X-FDA: 84861329826.05.D3C7C8D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3864F18000C
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:16:11 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RUzkqU+Z;
	spf=pass (imf06.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781032571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Orhut8IhA4k/fI1g8VtdPP5GiujeWv5wMA2yYIWY1p8=;
	b=Vp0yOxs/ZQUszD9pcvPKa3WeA8tfUPOqk5lrK3lbaxBhhsDpIRGPOpmT0zAf+A5RxiM9Hu
	cC0syRp7k52ee+KtuekSLNkYlM9Vy0lH66YdkwAHAcKdNgi8yK4AFLgBeB903KIuRhJELL
	k9CIggiyPCbch20pRwce1E2JIwGACtQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RUzkqU+Z;
	spf=pass (imf06.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781032571;
	b=5ZiA4Iqj34J+2Yi7espFSwlOJQZzDffa1DJuwaOHxKOsxzpchcK0bR12jdxlqPRicgMl68
	UqxLqFOCaheyKHwws3Fn3EhgutSr3ut0J42Kcgne9iGCGo6RNhb0gvlpvbOBIhrI0kmizz
	I8NpeS5OY5uDOgq2XCMq3YISfALPyfQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 862B143FAF;
	Tue,  9 Jun 2026 19:16:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A48B81F00898;
	Tue,  9 Jun 2026 19:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781032570;
	bh=Orhut8IhA4k/fI1g8VtdPP5GiujeWv5wMA2yYIWY1p8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=RUzkqU+ZXawZrmlyk04BLnOhiuJzHkfl61joHhZcBaJzAK6ZcL1k6CE2FsibWxiU7
	 RYBL/UjhqKpDI+/39m/Z9JiKYUdcO9PK8ohduC4fYu3E0T7i5TCnvfraScXLOaEGh3
	 S+gZoTn3QrqlDt0k4RgvmC3st+7ihZ7uo8hy0+zJrYWIuqmhltbPlwr+FbaM63QyRz
	 11bRCpQFv0VBLxZiB3u+NuaeVqyC7/FHEQu/r+IjOwfRffZHpGz6sep1y/Xcc7GZ4X
	 3+pEleRTX5HmupMZswDkaL2Y8vLRrOkd4yCOBevKooC1A4X0p6ue4AtmVgoE3jCKKY
	 vxwxONaV/5lkA==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 09 Jun 2026 21:07:50 +0200
Subject: [PATCH v2 11/83] block: rnull: add timer completion mode
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-rnull-v6-19-rc5-send-v2-11-82c7404542e2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=8400; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=2WihwLY3BKsR/bUh+8xVFcjC68ymvUSpcl2aNu7m3ro=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqKGS+rU1gDuulIyezDBGUgrXsFtIS6RTlCiVRL
 3EBNU/is9GJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaihkvgAKCRD6UCkIqsW9
 0KnwD/0bwBHMPBBCjhyRdIxobUfjyBnsEtn2wXnswCENj7OIZnPKIiR4pzsIijIprkOLi+Xh/rR
 Aj2+xTHMdRGVHPz/gZX2rsrde9a3ar0Eqv3xd/8WtXbW6lFynQTgEqBsDxD4xFHDvegdth1FFFT
 zX6Qs7QhtK9QoQvbrizt2qP/+Rc6QCoLB7CKXr4UhWV1BIC4TQjVZMlhGvF+VTW5UU6lOTQ72IR
 aLsHVbe03W2nuO8HOhl6d/ZqzPAeifmI5KvH6ep0ARDTCIGK+7g/TLrNKlSScLmMUI5MQ5H0XYb
 X8n+mA5zynpdOnPAuFv8N0LTtN7TaOokE8mGIiTXgswZXdxqzx/mGIRxNY6iQ3yOhyyCw0wAwCS
 Cbr/JD8gjj8qUQcI2yThBBSvXn9mJOxuqVJSYT4QAeemEQE6w7nKrCITN5OZ/6haENVWg3jHt+W
 I+nckkSVS3F8v8ZU42L/H9IHaekvx3yaQuGlA5lZtiHrGSPojoJevRkJNlMc7gbaLoOfyPYU0oa
 YF8Q4ELRoA2VIIp1QMDK4jKssuV2eDGgH3QC2E76jp0oKV7BGb2ul+h1T6nqQjPxfua+9H0TXal
 /QJfn3BY4k+XN9vv4Dlvo2mk+mIUBCPqRTcdN1t+d8CDzAJBpIT00omYkYnAesldTy4wyE3fiEs
 /ZAVOJ55sXdCcww==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3864F18000C
X-Stat-Signature: 7ji9hm7dsjwwh5b1yxaj4o4r44ec9zde
X-Rspam-User: 
X-HE-Tag: 1781032571-513627
X-HE-Meta: U2FsdGVkX1+/V6l/1Nl8Z6lfF0uoa4xX2+kF8ddqJyi2KfMKrgxwyVtW4LJfz3l68ohx50fFuejOxfr7x7SX672VEpTGpraBT9WYK6C19uo1FQuvIT0BUV1v6VIYV8B4qB5W5sReWkzhsbDZsarQjcFVCR5vS8p6mM3+PNGV1e425220siooTtixLID4HoMQmzLN1q1f6yrOJ48Pq/AVAB4Viq4rxDD/I46JrlUf3RBxv+fkkEoBCtAYPWJACkqE/UMN+8Wgrx5XGPRC2XdfidWguV6VxA2L1X9PWbNTEIOTc3Dxtm9QMmYEIPuMgJV+AVXpaT8QOXKfndlLii29V9+EX/9DCMteCp6SfmMLZ4bmAcq2LmnCqTOiP0Cibi36dT7nRQ4vWl0jHhLDFk7DvpS7CYGj66H1yF/K21ODTXJNzHUi7KN2F8nMBvjXVJ474O/7Wgxv7UI70mUZ3WTjwWIcYk3jyiGJb/m98bKGJOvu6Ii8SEq4Nsvx2B19xd4iwZQ2xTnyaET1sIsJ9aXJMbDmILtI1EG+BGsARccQvzPOaW/ZOmtQGqfvAMOdBVgRIlYixVHr0OsRdx+JNxrdBW3yB3lV5Y+vdR2u5xA0GTp5jurM1iqU//7NA+rss6AmZE65NMCiiI5y4nZWSLSCKATeHS6mi3ifp6+WEZ4PAnbSOhI3qT59g8k3K4qChKjW0W5FN3w8VGPB/JeNdTglb3vLkO7spMi5poIWe96mQIsgzJTvhu4cySi5kRF5FP755/zXdN1CkSVDrcYUQF39gCleM6XTZV2V4U2lHUTTIEgVUqHD1oeFALLeLG7pPPpP6PJZitM5jve6ry1wbzjndjjrNs+4N//mkfrEy1BbP3QZUh5zaDEUiVneLlbSH3nHhsRL5hjss1OevAJEiFDRqmF+J0Gvk7JVdG8ao21JOHUrf5pFWd1dhNhvhvENVV0zlxni5fJhVrnHudvhBHX
 mzmfPNKY
 k7OCJ+qra96vOKfpLGtW/+tsYF/5mNe5orYnNJdXiatrRO8P2r3fDV1ZbScDqErhb2OKC5vDXMLyZCv5CrKxxbmxXfT8A2lratPU2RL6Pxte3E/tMxwH2B4cx0wet+eIP7pE1EFUqZeoM4fWZ0+4NYdQH40fr+I7o1bZBN+U4F+ry4P+l6Bfnr/88sVk3CtftrFy3dZ4XKE2hkYUf2FpxxY6cwpigXmRZBpbK86jEqqf80RFSICplQ9ksPNcthMMZwhFG423Z8anCgr6FZRc5ExnnyZCrpit0SEdmYpCJW+kBxJtn7LrDz7cqEU2APCn4iQIY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a timer completion mode to `rnull`. This will complete requests after a
specified time has elapsed. To use this mode of operation, set `irqmode` to
`2` and write a timeout in nanoseconds to `completion_nsec`.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 drivers/block/rnull/configfs.rs | 34 ++++++++++++++++++++--
 drivers/block/rnull/rnull.rs    | 63 ++++++++++++++++++++++++++++++++++++++---
 2 files changed, 90 insertions(+), 7 deletions(-)

diff --git a/drivers/block/rnull/configfs.rs b/drivers/block/rnull/configfs.rs
index fd309fc17e66..83b474f6da60 100644
--- a/drivers/block/rnull/configfs.rs
+++ b/drivers/block/rnull/configfs.rs
@@ -25,11 +25,15 @@
         kstrtobool_bytes,
         CString, //
     },
-    sync::Mutex, //
+    sync::Mutex,
+    time, //
 };
 use macros::{
+    configfs_attribute,
     configfs_simple_bool_field,
-    configfs_simple_field, //
+    configfs_simple_field,
+    show_field,
+    store_number_with_power_check, //
 };
 
 mod macros;
@@ -56,7 +60,7 @@ impl AttributeOperations<0> for Config {
 
     fn show(_this: &Config, page: &mut [u8; PAGE_SIZE]) -> Result<usize> {
         let mut writer = kernel::str::Formatter::new(page);
-        writer.write_str("blocksize,size,rotational,irqmode\n")?;
+        writer.write_str("blocksize,size,rotational,irqmode,completion_nsec\n")?;
         Ok(writer.bytes_written())
     }
 }
@@ -79,6 +83,7 @@ fn make_group(
                 rotational: 2,
                 size: 3,
                 irqmode: 4,
+                completion_nsec: 5,
             ],
         };
 
@@ -94,6 +99,7 @@ fn make_group(
                     disk: None,
                     capacity_mib: 4096,
                     irq_mode: IRQMode::None,
+                    completion_time: time::Delta::ZERO,
                     name: name.try_into()?,
                 }),
             }),
@@ -106,6 +112,7 @@ fn make_group(
 pub(crate) enum IRQMode {
     None,
     Soft,
+    Timer,
 }
 
 impl TryFrom<u8> for IRQMode {
@@ -115,6 +122,7 @@ fn try_from(value: u8) -> Result<Self> {
         match value {
             0 => Ok(Self::None),
             1 => Ok(Self::Soft),
+            2 => Ok(Self::Timer),
             _ => Err(EINVAL),
         }
     }
@@ -125,11 +133,22 @@ fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
         match self {
             Self::None => f.write_str("0")?,
             Self::Soft => f.write_str("1")?,
+            Self::Timer => f.write_str("2")?,
         }
         Ok(())
     }
 }
 
+/// Wraps [`time::Delta`] to render the value as a bare nanosecond count for
+/// configfs attributes that historically used this format.
+struct DeltaDisplay(time::Delta);
+
+impl kernel::fmt::Display for DeltaDisplay {
+    fn fmt(&self, f: &mut kernel::fmt::Formatter<'_>) -> kernel::fmt::Result {
+        f.write_fmt(kernel::prelude::fmt!("{}", self.0.as_nanos()))
+    }
+}
+
 #[pin_data]
 pub(crate) struct DeviceConfig {
     #[pin]
@@ -144,6 +163,7 @@ struct DeviceConfigInner {
     rotational: bool,
     capacity_mib: u64,
     irq_mode: IRQMode,
+    completion_time: time::Delta,
     disk: Option<GenDisk<NullBlkDevice>>,
 }
 
@@ -174,6 +194,7 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
                 guard.rotational,
                 guard.capacity_mib,
                 guard.irq_mode,
+                guard.completion_time,
             )?);
             guard.powered = true;
         } else if guard.powered && !power_op {
@@ -189,6 +210,13 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
 configfs_simple_bool_field!(DeviceConfig, 2, rotational);
 configfs_simple_field!(DeviceConfig, 3, capacity_mib, u64);
 configfs_simple_field!(DeviceConfig, 4, irq_mode, IRQMode);
+configfs_attribute!(DeviceConfig, 5,
+    show: |this, page| show_field(DeltaDisplay(this.data.lock().completion_time), page),
+    store: |this, page| store_number_with_power_check(this, page, |data, value: i64| {
+        data.completion_time = time::Delta::from_nanos(value);
+        Ok(())
+    })
+);
 
 impl core::str::FromStr for IRQMode {
     type Err = Error;
diff --git a/drivers/block/rnull/rnull.rs b/drivers/block/rnull/rnull.rs
index dd7a30519870..3e7a47e6d0e5 100644
--- a/drivers/block/rnull/rnull.rs
+++ b/drivers/block/rnull/rnull.rs
@@ -28,6 +28,15 @@
         Arc,
         Mutex, //
     },
+    time::{
+        hrtimer::{
+            HrTimerCallback,
+            HrTimerCallbackContext,
+            HrTimerPointer,
+            HrTimerRestart, //
+        },
+        Delta,
+    },
     types::{
         OwnableRefCounted,
         Owned, //
@@ -59,7 +68,11 @@
         },
         irqmode: u8 {
             default: 0,
-            description:  "IRQ completion handler. 0-none, 1-softirq",
+            description:  "IRQ completion handler. 0-none, 1-softirq, 2-timer",
+        },
+        completion_nsec: u64 {
+            default: 10_000,
+            description:  "Time in ns to complete a request in hardware. Default: 10,000ns",
         },
     },
 }
@@ -79,6 +92,7 @@ fn init(_module: &'static ThisModule) -> impl PinInit<Self, Error> {
         let mut disks = KVec::new();
 
         let defer_init = move || -> Result<_, Error> {
+            let completion_time: i64 = module_parameters::completion_nsec.value().try_into()?;
             for i in 0..module_parameters::nr_devices.value() {
                 let name = CString::try_from_fmt(fmt!("rnullb{}", i))?;
 
@@ -88,6 +102,7 @@ fn init(_module: &'static ThisModule) -> impl PinInit<Self, Error> {
                     module_parameters::rotational.value(),
                     module_parameters::gb.value() * 1024,
                     module_parameters::irqmode.value().try_into()?,
+                    Delta::from_nanos(completion_time),
                 )?;
                 disks.push(disk, GFP_KERNEL)?;
             }
@@ -111,10 +126,17 @@ fn new(
         rotational: bool,
         capacity_mib: u64,
         irq_mode: IRQMode,
+        completion_time: Delta,
     ) -> Result<GenDisk<Self>> {
         let tagset = Arc::pin_init(TagSet::new(1, 256, 1), GFP_KERNEL)?;
 
-        let queue_data = Box::new(QueueData { irq_mode }, GFP_KERNEL)?;
+        let queue_data = Box::new(
+            QueueData {
+                irq_mode,
+                completion_time,
+            },
+            GFP_KERNEL,
+        )?;
 
         gen_disk::GenDiskBuilder::new()
             .capacity_sectors(capacity_mib << (20 - block::SECTOR_SHIFT))
@@ -127,15 +149,43 @@ fn new(
 
 struct QueueData {
     irq_mode: IRQMode,
+    completion_time: Delta,
+}
+
+#[pin_data]
+struct Pdu {
+    #[pin]
+    timer: kernel::time::hrtimer::HrTimer<Self>,
+}
+
+impl HrTimerCallback for Pdu {
+    type Pointer<'a> = ARef<mq::Request<NullBlkDevice>>;
+
+    fn run(this: Self::Pointer<'_>, _context: HrTimerCallbackContext<'_, Self>) -> HrTimerRestart {
+        OwnableRefCounted::try_from_shared(this)
+            .map_err(|_e| kernel::error::code::EIO)
+            .expect("Failed to complete request")
+            .end_ok();
+        HrTimerRestart::NoRestart
+    }
+}
+
+kernel::impl_has_hr_timer! {
+    impl HasHrTimer<Self> for Pdu {
+        mode: kernel::time::hrtimer::RelativeMode<kernel::time::Monotonic>,
+        field: self.timer,
+    }
 }
 
 #[vtable]
 impl Operations for NullBlkDevice {
     type QueueData = KBox<QueueData>;
-    type RequestData = ();
+    type RequestData = Pdu;
 
     fn new_request_data() -> impl PinInit<Self::RequestData> {
-        Ok(())
+        pin_init!(Pdu {
+            timer <- kernel::time::hrtimer::HrTimer::new(),
+        })
     }
 
     #[inline(always)]
@@ -143,6 +193,11 @@ fn queue_rq(queue_data: &QueueData, rq: Owned<mq::Request<Self>>, _is_last: bool
         match queue_data.irq_mode {
             IRQMode::None => rq.end_ok(),
             IRQMode::Soft => mq::Request::complete(rq.into()),
+            IRQMode::Timer => {
+                OwnableRefCounted::into_shared(rq)
+                    .start(queue_data.completion_time)
+                    .dismiss();
+            }
         }
         Ok(())
     }

-- 
2.51.2



