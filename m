Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31802E63F1C
	for <linux-mm@archiver.kernel.org>; Sun, 15 Feb 2026 23:43:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22B176B009D; Sun, 15 Feb 2026 18:41:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F5916B009E; Sun, 15 Feb 2026 18:41:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 101986B009F; Sun, 15 Feb 2026 18:41:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E0C5F6B009D
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 18:41:16 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9AFDD1A06A4
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:41:16 +0000 (UTC)
X-FDA: 84448314552.07.C3FD887
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0D2CA140007
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:41:14 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N4HkhPLL;
	spf=pass (imf23.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771198875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w9gPSGFycwvZ32A9vRakly0KZXQ62mTM3MIO5B2F+bQ=;
	b=0EcbEpCVuz4+wf2qP1lzJxYUq6kt8CYia2L70SkavtXnft75yOuLXC/C+9hAWHlD7R0x3o
	gDMZOpLg52+CWLbCtFY7JTp1NAAyeAJEwJL+4T08xvvCyPTe4qVaj/KclijUirUB9yVY5e
	zNbBYDCI5uPthPIIEsUTeSlBxTk3DcM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N4HkhPLL;
	spf=pass (imf23.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771198875; a=rsa-sha256;
	cv=none;
	b=dFw7Xyq+puMHPsngXN3Wp43x8tAJ9pEOoWgZ3f62z/jgKwtNDMMYbZB+9CT3RS1aRLoT0V
	PUCmSARzPKU+y3/XjVTNwh7NMMqUV+Ota5UJml5psTKBgjd/hHveZKwL2CSMyR6rFtqXG1
	ekPO2GhJgvZZwOOq3SEnOAXH9nW6ifg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7E4CB6057A;
	Sun, 15 Feb 2026 23:41:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F060BC19422;
	Sun, 15 Feb 2026 23:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771198874;
	bh=oPe8xTPtUm7MU6OaQHlhI5ZvU2RiaWhjCxNoERzRn94=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=N4HkhPLL2+UClx4hGhGXzseXnzQg4SGO27nQbo0G78ClH94QxOAUF1svWavDlEMws
	 v+3GCnbJ7PelKTBeWj8hNce8IoNTYBolND+Ut5M27Ysam9gPKWyrWfc2EDSzQXqLSr
	 Yo0Ex3gxHOOwWTCfC4oAKWJZ9PnN5Yx/F2ZMFpMb5EcB70d3yZgvtJdB7GhZekydp2
	 OaxZjK1/R9a0y0VO4L54lxhONQMfQ2lqR2O1QYqNe2tfmCdkhO+6hVGN0v6n6Ql6Ux
	 9kscZ03Jow8PgfjhYUa8uwY0MW10rD9N1taHvH4xGq47DHr47fh9efvydVBZXIM/lm
	 KTlvuKxEH/Nwg==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 16 Feb 2026 00:35:01 +0100
Subject: [PATCH 14/79] block: rnull: add submit queue count config option
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-rnull-v6-19-rc5-send-v1-14-de9a7af4b469@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=7281; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=oPe8xTPtUm7MU6OaQHlhI5ZvU2RiaWhjCxNoERzRn94=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpklgocr9tcJuX0/u2H2v2dGPhOmiIz0V7rredg
 ljKxj2DbTKJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZJYKAAKCRDhuBo+eShj
 d0KfD/9HduJ9u1Dz2i53t5uptOOHZJWiq5J44S0C7hFuqOn7ciTpEW9jB6p012sRG0NdfGlU9wC
 5wY8zNp0II+nrQ3Z7baNUQBjj8eCmgzIgoiyajufI1VTC5j9OlMlGv76VVGW8abuA21RtpTxvu1
 LQ051KmcQCFrMWY6JNnI9ZsaCEXwBPPpwfZ2fROuKL7NEQutSKWYmXwnr5JF0EB746b3Gl7YFYc
 KxsNfXHcoCH8H2Q7pEeQf6FeQOgbVITNW8TuqZdpVeSUYJYU7tku/KuiKWVWv9QrjV14aRTjmXW
 4nZ0oVFSB0UdmMjsU2ki3/jUuDXRnjbSYO4bIqC6cU7VK7ozdHWz+krobdr8HhkQNFZbiGjpVnZ
 ExhyYez/CA9Idt7BzXrTql/MKkF1IixJQK3ipYI5toRQNg2u/RrOgNDBv+iFHDFm1//zHQwIgIS
 9n9Na57cPIsHWxjD+l7tgB/NV7dWAXKkvHqRNlxOuYKmsRVIRPWnXoguKayXs2rxSTn0REmbbpk
 f4vnf3sMSFHq3+VtUQh+443S2fzdMTttk1L5mDhYEExwB34ujSW7QV5UkMSZLrkLidPAT3j2AOg
 ZpAcNEJydOMa9BQOh8KqyhJrrJh62rbtBDCXdf34YCvx6kcf40950ai1DR0uHlg+smHF+QdvFJC
 vCqrzlQJiQAoKFA==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0D2CA140007
X-Stat-Signature: o1nptpytndneucwz4p6qwgcwkyh4py3n
X-Rspam-User: 
X-HE-Tag: 1771198874-776483
X-HE-Meta: U2FsdGVkX1/r3bOrIEK5jcoE+IBR4mF3+yB16o95GpLNYXp99TSB46G5nrPKAtG8XdIVwuZDj9yq6MiwLyzqukNBZ5s7VKcZPL8Jskse52LO02usx8rEVpDBF900VynX9JnRBrpcZZJdZnaFmLGAOhkMFpp2DeueOJJLPFF1cwVMPrgwZZP4ZzVFTd+OPVcIrf435Eb+8NxS7FvNdbRwCKo2QTbPoFR2abbNBvawYmqWBpdJQH3U6HeoGxf4v0dulJl64nngj6l2gEPl3P380+iMsOxmHXfccDXpjuEpk9tzdOJ+VE40z19EumgwgqPpz4I2NuLN7JnzcuZ/VmrsKi8r14kTOzlx+R7WMKufVfLRKSNoNg6VEAcoI8a07ZRsRkGFwoxLRsxjtiX0XaX3xlwDvbKe4Xoz47FfZ2ljZnmIU9KVMUC6tIKfN60EK4xk2ZVDxCOw9heSypcPJlyfudeMAe7hPqEp/Usq0ZWGd+eQiYxQPS2plhh+w1YvdD8S22GQ1dv3rODWMgnLLfWm9qjB54m/IlwYZAc02Qj9LeuLciqJkMX3GKWdkEgouuQ6mLoKQMeYyW5HoXVc+BHGWQxj0eTkjmN9oSCugNkS+y7TqQDovxmWSaOvaz4OTzs9YiT7v1X5hsi9xD3tUVEKx+50X1qrkEiGM+sDs8xyLS9FQq6j/teqBDb5mHywjrUb5Gin4XRUAvWihDDe05BCg3IaMBYPtIogVTEXnkOBiqgo6NRkaOkDsILKRDt0eWyWzvOre/LYE7BzWLH+AT2Q5vdQ0+IxqtO2CYTTT9S+8c/QmWW63ooM84WiRK9vUiYPbjZeJ9xq23WUztzZRgmf+GPHDiIYqQiQFByCEpi8CaE1nN6HAvGtkAO7Q0Y6E5L40rGAb2BErGwojKMMHS8av+XMQd11u7jCJAa0jAkVuWWWa/tE7sYJ5Th/U63fNuwMoDV8ikdBmaVZJR0jv2m
 zJA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Allow user space to control the number of submission queues when creating
null block devices.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 drivers/block/rnull/configfs.rs | 56 +++++++++++++++++++++++++++++++++--------
 drivers/block/rnull/rnull.rs    | 56 +++++++++++++++++++++++++++--------------
 2 files changed, 83 insertions(+), 29 deletions(-)

diff --git a/drivers/block/rnull/configfs.rs b/drivers/block/rnull/configfs.rs
index b5dc30c5d3e20..fd3cbf7aa012e 100644
--- a/drivers/block/rnull/configfs.rs
+++ b/drivers/block/rnull/configfs.rs
@@ -59,7 +59,10 @@ impl AttributeOperations<0> for Config {
 
     fn show(_this: &Config, page: &mut [u8; PAGE_SIZE]) -> Result<usize> {
         let mut writer = kernel::str::Formatter::new(page);
-        writer.write_str("blocksize,size,rotational,irqmode,completion_nsec,memory_backed\n")?;
+        writer.write_str(
+            "blocksize,size,rotational,irqmode,completion_nsec,memory_backed\
+             submit_queues\n",
+        )?;
         Ok(writer.bytes_written())
     }
 }
@@ -84,6 +87,7 @@ fn make_group(
                 irqmode: 4,
                 completion_nsec: 5,
                 memory_backed: 6,
+                submit_queues: 7,
             ],
         };
 
@@ -102,6 +106,7 @@ fn make_group(
                     completion_time: time::Delta::ZERO,
                     name: name.try_into()?,
                     memory_backed: false,
+                    submit_queues: 1,
                 }),
             }),
             core::iter::empty(),
@@ -157,6 +162,7 @@ struct DeviceConfigInner {
     completion_time: time::Delta,
     disk: Option<GenDisk<NullBlkDevice>>,
     memory_backed: bool,
+    submit_queues: u32,
 }
 
 #[vtable]
@@ -180,15 +186,16 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
         let mut guard = this.data.lock();
 
         if !guard.powered && power_op {
-            guard.disk = Some(NullBlkDevice::new(
-                &guard.name,
-                guard.block_size,
-                guard.rotational,
-                guard.capacity_mib,
-                guard.irq_mode,
-                guard.completion_time,
-                guard.memory_backed,
-            )?);
+            guard.disk = Some(NullBlkDevice::new(crate::NullBlkOptions {
+                name: &guard.name,
+                block_size: guard.block_size,
+                rotational: guard.rotational,
+                capacity_mib: guard.capacity_mib,
+                irq_mode: guard.irq_mode,
+                completion_time: guard.completion_time,
+                memory_backed: guard.memory_backed,
+                submit_queues: guard.submit_queues,
+            })?);
             guard.powered = true;
         } else if guard.powered && !power_op {
             drop(guard.disk.take());
@@ -244,3 +251,32 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
         Ok(())
     }
 }
+
+#[vtable]
+impl configfs::AttributeOperations<7> for DeviceConfig {
+    type Data = DeviceConfig;
+
+    fn show(this: &DeviceConfig, page: &mut [u8; PAGE_SIZE]) -> Result<usize> {
+        let mut writer = kernel::str::Formatter::new(page);
+        writer.write_fmt(fmt!("{}\n", this.data.lock().submit_queues))?;
+        Ok(writer.bytes_written())
+    }
+
+    fn store(this: &DeviceConfig, page: &[u8]) -> Result {
+        if this.data.lock().powered {
+            return Err(EBUSY);
+        }
+
+        let text = core::str::from_utf8(page)?.trim();
+        let value = text
+            .parse::<u32>()
+            .map_err(|_| kernel::error::code::EINVAL)?;
+
+        if value == 0 || value > kernel::num_possible_cpus() {
+            return Err(kernel::error::code::EINVAL);
+        }
+
+        this.data.lock().submit_queues = value;
+        Ok(())
+    }
+}
diff --git a/drivers/block/rnull/rnull.rs b/drivers/block/rnull/rnull.rs
index a1156a368c467..55ee5165b90b3 100644
--- a/drivers/block/rnull/rnull.rs
+++ b/drivers/block/rnull/rnull.rs
@@ -80,6 +80,10 @@
             default: 0,
             description: "Create a memory-backed block device. 0-false, 1-true. Default: 0",
         },
+        submit_queues: u32 {
+            default: 1,
+            description: "Number of submission queues",
+        },
     },
 }
 
@@ -102,15 +106,16 @@ fn init(_module: &'static ThisModule) -> impl PinInit<Self, Error> {
             for i in 0..(*module_parameters::nr_devices.value()) {
                 let name = CString::try_from_fmt(fmt!("rnullb{}", i))?;
 
-                let disk = NullBlkDevice::new(
-                    &name,
-                    *module_parameters::bs.value(),
-                    *module_parameters::rotational.value() != 0,
-                    *module_parameters::gb.value() * 1024,
-                    (*module_parameters::irqmode.value()).try_into()?,
-                    Delta::from_nanos(completion_time),
-                    *module_parameters::memory_backed.value() != 0,
-                )?;
+                let disk = NullBlkDevice::new(NullBlkOptions {
+                    name: &name,
+                    block_size: *module_parameters::bs.value(),
+                    rotational: *module_parameters::rotational.value() != 0,
+                    capacity_mib: *module_parameters::gb.value() * 1024,
+                    irq_mode: (*module_parameters::irqmode.value()).try_into()?,
+                    completion_time: Delta::from_nanos(completion_time),
+                    memory_backed: *module_parameters::memory_backed.value() != 0,
+                    submit_queues: *module_parameters::submit_queues.value(),
+                })?;
                 disks.push(disk, GFP_KERNEL)?;
             }
 
@@ -124,25 +129,38 @@ fn init(_module: &'static ThisModule) -> impl PinInit<Self, Error> {
     }
 }
 
+struct NullBlkOptions<'a> {
+    name: &'a CStr,
+    block_size: u32,
+    rotational: bool,
+    capacity_mib: u64,
+    irq_mode: IRQMode,
+    completion_time: Delta,
+    memory_backed: bool,
+    submit_queues: u32,
+}
 struct NullBlkDevice;
 
 impl NullBlkDevice {
-    fn new(
-        name: &CStr,
-        block_size: u32,
-        rotational: bool,
-        capacity_mib: u64,
-        irq_mode: IRQMode,
-        completion_time: Delta,
-        memory_backed: bool,
-    ) -> Result<GenDisk<Self>> {
+    fn new(options: NullBlkOptions<'_>) -> Result<GenDisk<Self>> {
+        let NullBlkOptions {
+            name,
+            block_size,
+            rotational,
+            capacity_mib,
+            irq_mode,
+            completion_time,
+            memory_backed,
+            submit_queues,
+        } = options;
+
         let flags = if memory_backed {
             mq::tag_set::Flag::Blocking.into()
         } else {
             mq::tag_set::Flags::default()
         };
 
-        let tagset = Arc::pin_init(TagSet::new(1, 256, 1, flags), GFP_KERNEL)?;
+        let tagset = Arc::pin_init(TagSet::new(submit_queues, 256, 1, flags), GFP_KERNEL)?;
 
         let queue_data = Box::pin_init(
             pin_init!(QueueData {

-- 
2.51.2



