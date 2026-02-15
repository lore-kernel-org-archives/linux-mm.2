Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADD83E63F21
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 00:54:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 288486B00D6; Sun, 15 Feb 2026 18:46:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 264CF6B00DD; Sun, 15 Feb 2026 18:46:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11B586B00DE; Sun, 15 Feb 2026 18:46:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 034F96B00D6
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 18:46:13 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B37371CDB4
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:46:03 +0000 (UTC)
X-FDA: 84448326606.03.C25CBAF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id C0C0C140005
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:46:01 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XiiM5Ah7;
	spf=pass (imf26.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771199161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e0DebrfNfYRRspOOW4jgn8L+egW9zxvZN4hijU0qtdQ=;
	b=JVK0bc9hQkCdsVPnhuwQ/ZHooFL7a5cb8QAld5Y+4PZNC0k3bKYaZR0CcC7mQFzJxRlv4T
	N8KUNna31qEZcz/I41WHsEInaNkwcwySYIbbWFQ+brSGTBYIcsvcu4i1N9pJ8m2E+xsSNZ
	le8WgKLAtk/rWAwDJrAi9E2S4Njouck=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XiiM5Ah7;
	spf=pass (imf26.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771199161; a=rsa-sha256;
	cv=none;
	b=quFJAvbSrS4EKr/MejISHuglh2Ug9RhCGKud2F15Pdxg4ZvY2VAdWRBWKn18h8ks3qma6Z
	q9WpuYIM0l91IDO21E7Be1mSjEo6Gp3aRxoyvr59mZpCbG/lEtVwJ9dJYluGc8QVn3W/h2
	14Kckk7Sqq4auxXYI2XoaApB/KsB9Uc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E08FF42A02;
	Sun, 15 Feb 2026 23:46:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74CB6C4CEF7;
	Sun, 15 Feb 2026 23:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771199160;
	bh=jZ608odEKTUNSFrE/SOnMnlQT6DB0sc7l5Lx9qmISMk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=XiiM5Ah7X1e+o6XtV6o5U46+0qoO5UBHAvPqA6M9opCsoMYbca+mSnjPGI5UUMZcB
	 fcGlayUQjIl1YBDKK+G2+jJN2cSR3z0h0KlEqXphZui08jmMn/6CNHtl5J/5UUEonC
	 AP0vm7CFamxgQ/m63F8pnzQ6GBB/f4vhMLuHgGqjb4mwNEYEpAw5SD77h7Ihsr2rsF
	 5jXy2Yu8W5PKJjqUNbiGuX9MvREIPFt3LLfP8TZqqOyY756I5j4TgsEs0PkFEjdP9g
	 hwVDqNYVmmP7dpmAHf0hhFvirmBzf67K5gzMOPpd3ZYQumw3jncTu/l2qtgiJtPdYj
	 BHow284+aMSHQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 16 Feb 2026 00:34:55 +0100
Subject: [PATCH 08/79] block: rnull: add timer completion mode
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-rnull-v6-19-rc5-send-v1-8-de9a7af4b469@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=7586; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=jZ608odEKTUNSFrE/SOnMnlQT6DB0sc7l5Lx9qmISMk=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpklgj0Yu8uMU7TEqY3x4l6rKBJxrFk0MqHBWwe
 o7L8Uuy2cWJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZJYIwAKCRDhuBo+eShj
 d7JtD/49ta7KxNhGfU2B490AUk8e8AXtKTzvkoZnq2sUdzew7/4YETUXrT4HgmA6SCqMCSaQ4H+
 55/4mU4jRsiwTzwPsga1dVDIMa7C+MCkEZTDlOLXP2m66kfpaRkdXSkp0dYLyh4EDfK6d7kINCl
 XPAPBtrruq6bFMqEI52dRmhZISzCDZw0ZSBM0SCneWoxYg155cjApTLUSJHVGFv/bVrLn/jC3Ar
 OOvgErOMpzy9k6f76F/7QiisnQABLat+plLHeIlQ3v8KfS8hErej5W2XtCLXowv9Z+r9IMWghvJ
 enfQQ5mfwS1UrCCz7WNbp7D6QFPqKdzZdhNnEoUuOipgC+QtYVtgEdsRQp4v6n3D5P1U1zkc3Lo
 f4IA0vDg+GddKYKIWY6y20i0/VvrmeIVRbd874mcvI3PfbiLdO1NblXOVNoTwChs1AOfMOFDEGH
 7vZD0r3ErtgHVJ0hszcfD1wlIdbQb1ms8J292ZGsqsHdfF+hTtcrIInHuqw3R1TaWDB+NOqaygB
 llsnTOLj45WFwHhuGZNKZfvLsHYkdP3ikxcxojLPNjebDl3d38v+Acwe47Mj1tpJqwuYcgXV/cp
 On7C6vtYpqzO/BoztgKgse5Q9VQe1l7R7DYT/R7s5y3sZQIjOoJPZFZBKonL0F+37+MnaZrKnkA
 RO3m9tVKOHxQ50g==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C0C0C140005
X-Stat-Signature: 36qxw9u1zhkfr9sws8td331xpuhzfiq5
X-Rspam-User: 
X-HE-Tag: 1771199161-23278
X-HE-Meta: U2FsdGVkX1+WLeh1h499pK4rQYMnXlDvQXKnmaihxiLcANAHCvYcltB1HlgrjHGKUGUBaz6LqOkUEWYETL3GT6IYnOIm8jBSxHN3fiK9aLfbl3LN01e67YkDLgwzn5HWokL4qKPuuRE7be5sxgDVgvCDTmgRrBCOWbCLZLP8P5dliUcJQkXEDn25q3aLz/He8vB1R6klxI4sjxCTzyD63Swx3HgZJZ3JkjKSoLv9SlKGX6RS9jDp7MMVgmXaQ8PjuK+/SK7aRye9cX1CA71SVWJ+2OrzPLwLSvuyCIR7M5Q9bhafTwpyC5UY9giojEIcm1DMMsafQDgCy2jgj/lUNHRQB7yWfv4202hSGZyfu9Ouok7wAY/0z7KYwy6OUjAOld5ZDnqeyryXPaq+UU1NNSgDEVpAR+dnlWJVJgoOmEClqH+1DszB3WYe3RpYsg6f2a6ZeTF3cHJJkMWhGg3bp6Z94sjqr3xyPlCaOa0V4blJ924GW26l2v+gnecbmL3rlktyY63ByO/0WBaELKA9sEv2CVxONh3zyeSTz0xNTtYy6C+Peqk2zv0JP+QYENpGznkRDZCkXPH+jS6xsiTZ7Hpj9WQMpNIdR3gJOQrLEine1oE5ZCKYvnLlQxUq+eTHlErC5STdTGUxN4FR3Dqd7mYfWkzx4tW0SmgYoDhPRC39bBgxrwXDzGlgwszQzBYNHYTqaDjIyts4mbqxFKK0i40R89U+0ZEEYgv6QyHv76+NSvdP1REOPWzkvCCJTZb8b3NI6lIBR186JQkGal4Wzz1G2B30/IVxvHNxubfKMmzH+5W5AeKoGia33CUkXnqqJz+S71W6VutNzNNBYew79niBacuHPaoZMvgUi3OtWs1FPGD72iYSLxl6aOFoV3SPk8eB55OTv0iWqzb7ZjWQ4NbanHQ1IRF1/178gAKUehX7xs3Gdursv2bROsBizcQh8S9ogemHlcOrX1FMyfu
 q9a5vKg4
 /rZuy1HbyYlBGDn/Gr+vjO9gXnVb3SCtxmd9Ox4D7bC0/5F1V1nu9R8q6dKVSoxBMIRZtDp63V7wLaj2rF6aTCiPSxNo6HiWJOCAaRzN3ba8hhXx/lG6ont3Es7vjzVmjTepje8WWdGtYRXJftTI2ovA+wlmMLPZOiOhoyKGlvaU2IUEkIhnDN1qlN8eKb2SD7BUHC0FZd993PcjFtrjkN9ZqE8TnBCpvHc8/oCail9v2bK12l5EQlSzOi5ankXR19B8RMRHULUKKuIF4fZomVOX+RtFE/j2zihh9EaRkKNcCYzUAQ3q1s6IQpHgxwJ3/UQ33
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
 drivers/block/rnull/configfs.rs | 13 +++++++--
 drivers/block/rnull/rnull.rs    | 63 ++++++++++++++++++++++++++++++++++++++---
 2 files changed, 70 insertions(+), 6 deletions(-)

diff --git a/drivers/block/rnull/configfs.rs b/drivers/block/rnull/configfs.rs
index eafa71dfc40d3..7952f41f42bfd 100644
--- a/drivers/block/rnull/configfs.rs
+++ b/drivers/block/rnull/configfs.rs
@@ -26,7 +26,8 @@
         kstrtobool_bytes,
         CString, //
     },
-    sync::Mutex, //
+    sync::Mutex,
+    time, //
 };
 use macros::{
     configfs_simple_bool_field,
@@ -58,7 +59,7 @@ impl AttributeOperations<0> for Config {
 
     fn show(_this: &Config, page: &mut [u8; PAGE_SIZE]) -> Result<usize> {
         let mut writer = kernel::str::Formatter::new(page);
-        writer.write_str("blocksize,size,rotational,irqmode\n")?;
+        writer.write_str("blocksize,size,rotational,irqmode,completion_nsec\n")?;
         Ok(writer.bytes_written())
     }
 }
@@ -81,6 +82,7 @@ fn make_group(
                 rotational: 2,
                 size: 3,
                 irqmode: 4,
+                completion_nsec: 5,
             ],
         };
 
@@ -96,6 +98,7 @@ fn make_group(
                     disk: None,
                     capacity_mib: 4096,
                     irq_mode: IRQMode::None,
+                    completion_time: time::Delta::ZERO,
                     name: name.try_into()?,
                 }),
             }),
@@ -108,6 +111,7 @@ fn make_group(
 pub(crate) enum IRQMode {
     None,
     Soft,
+    Timer,
 }
 
 impl TryFrom<u8> for IRQMode {
@@ -117,6 +121,7 @@ fn try_from(value: u8) -> Result<Self> {
         match value {
             0 => Ok(Self::None),
             1 => Ok(Self::Soft),
+            2 => Ok(Self::Timer),
             _ => Err(EINVAL),
         }
     }
@@ -127,6 +132,7 @@ fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
         match self {
             Self::None => f.write_str("0")?,
             Self::Soft => f.write_str("1")?,
+            Self::Timer => f.write_str("2")?,
         }
         Ok(())
     }
@@ -146,6 +152,7 @@ struct DeviceConfigInner {
     rotational: bool,
     capacity_mib: u64,
     irq_mode: IRQMode,
+    completion_time: time::Delta,
     disk: Option<GenDisk<NullBlkDevice>>,
 }
 
@@ -176,6 +183,7 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
                 guard.rotational,
                 guard.capacity_mib,
                 guard.irq_mode,
+                guard.completion_time,
             )?);
             guard.powered = true;
         } else if guard.powered && !power_op {
@@ -191,6 +199,7 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
 configfs_simple_bool_field!(DeviceConfig, 2, rotational);
 configfs_simple_field!(DeviceConfig, 3, capacity_mib, u64);
 configfs_simple_field!(DeviceConfig, 4, irq_mode, IRQMode);
+configfs_simple_field!(DeviceConfig, 5, completion_time, i64, into time::Delta::from_nanos);
 
 impl core::str::FromStr for IRQMode {
     type Err = Error;
diff --git a/drivers/block/rnull/rnull.rs b/drivers/block/rnull/rnull.rs
index 065639fc4f941..55e56c39f1c2c 100644
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
@@ -61,7 +70,11 @@
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
@@ -81,6 +94,7 @@ fn init(_module: &'static ThisModule) -> impl PinInit<Self, Error> {
         let mut disks = KVec::new();
 
         let defer_init = move || -> Result<_, Error> {
+            let completion_time: i64 = (*module_parameters::completion_nsec.value()).try_into()?;
             for i in 0..(*module_parameters::nr_devices.value()) {
                 let name = CString::try_from_fmt(fmt!("rnullb{}", i))?;
 
@@ -90,6 +104,7 @@ fn init(_module: &'static ThisModule) -> impl PinInit<Self, Error> {
                     *module_parameters::rotational.value() != 0,
                     *module_parameters::gb.value() * 1024,
                     (*module_parameters::irqmode.value()).try_into()?,
+                    Delta::from_nanos(completion_time),
                 )?;
                 disks.push(disk, GFP_KERNEL)?;
             }
@@ -113,10 +128,17 @@ fn new(
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
@@ -129,15 +151,43 @@ fn new(
 
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
-        pin_init::zeroed::<Self::RequestData>()
+        pin_init!(Pdu {
+            timer <- kernel::time::hrtimer::HrTimer::new(),
+        })
     }
 
     #[inline(always)]
@@ -145,6 +195,11 @@ fn queue_rq(queue_data: &QueueData, rq: Owned<mq::Request<Self>>, _is_last: bool
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



