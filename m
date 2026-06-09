Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03D8BCD8CB2
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:11:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 667E46B00A8; Tue,  9 Jun 2026 15:11:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 619356B00AA; Tue,  9 Jun 2026 15:11:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52E876B00AB; Tue,  9 Jun 2026 15:11:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3EFE16B00A8
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:11:34 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 03B53C20B2
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:11:34 +0000 (UTC)
X-FDA: 84861318108.26.3A27CB6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 370B72000C
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:11:32 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EZHUEfJY;
	spf=pass (imf31.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781032292;
	b=gSFIFwiXUoTJm+46T1WtCoMh0sSDchYPAPnYvoefq2iO7Lzw6m1xLZQKEgDMh6eMwatDFO
	lTY+SRcJPpcw0SpnfsFGCOSnrmhUwIPflQqOUnzjMO3LAne0CjZnIQm5yoPTrcwRk0viG4
	135zimNTpUaMHNHSxqEhAuMntIpJtPk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EZHUEfJY;
	spf=pass (imf31.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781032292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GI7bMkhPaaNJq9fuPFFaiFn3pKn1655aVcxzZP2OKa8=;
	b=V2GSbDbQSdD/m/5zHsMUWSNc58KeTC7fGuL6jr5LWUQaWqSuEfttiO1J2mnwPDKVmKZhHw
	4l9WUjf1rsJ3HGxjJF+k4JqoUc/bPbkOlXwvOUD9JaGbmW7PtukenTO8Mr85FXF3/lqhoU
	brGkhvdIZaAl1iSIxzGvoxAJjpuIw2k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 494BC40599;
	Tue,  9 Jun 2026 19:11:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B8D21F00893;
	Tue,  9 Jun 2026 19:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781032291;
	bh=GI7bMkhPaaNJq9fuPFFaiFn3pKn1655aVcxzZP2OKa8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=EZHUEfJYGN1jW1sAkKwr559XDdZdWoWVCrAILg5iUtNDYxlfsJNdrRbWicD1yB5U6
	 TqvbVW1DOFFNkiF95/STtQ2qQ3lxZaSw/prEon1gGhr6ejYbhr6Z4uX1xLVAsqj6SA
	 E5X+4oDlhNpgd5O7Z+Wl4uwsP/WWaa6Vlnf6hEybMLT560soImnS9AvaU/2C4pXUa6
	 gmDjya5H7oMAy9ZIJmjxQubrEgO0jRt/Zv4H6OBZCY9HGIvVxL1/dSRjIXT16lrXGu
	 mlSGYbAu6Uq7rzxdps74pGMWhKiMsxSxvvcpeByzHKlYNVj/9iP9fDuoW9U4jmpuhk
	 BAv/+lIVO3QPw==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 09 Jun 2026 21:07:56 +0200
Subject: [PATCH v2 17/83] block: rnull: add submit queue count config
 option
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-rnull-v6-19-rc5-send-v2-17-82c7404542e2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=7246; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=lzez8j8zqRLV6gbk6iWV9jQDc4roUyUsLUzz7LgTQpc=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqKGTEugFhxWOtTsK/8FP5iDzSz6aLCztmYQWKh
 q35rokSuQKJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaihkxAAKCRD6UCkIqsW9
 0AeqD/wNZq1pWUrULFGmIEbOx73Cl6XyiQcErKBUzZVdec3C6xECJjipuL9gjVjAUQI/Q6B0QLj
 0UFnRtYmRP8OMrfo2AYryyW6ZcWJFuzRqkm3d36ZkBgIwY3GZ6pIwb2SBH5S2GmvxokxEJdO7z8
 n6k0M8Z4pUta9Cw8dDy34OwP1axygPMoVzy5hX7Hh5spwxuuxhb/8YhgtD+J15wxS+BPzdxtdRc
 oEcTbUilzEqMGUxPfL+AwSTo+vZDOSjWpekfkO1n6bH/N6nuhrpp/2Ftyy/XTSAEL7C7ZlXINmE
 lZoyLq+Cdnw99vQFKX7orrRhflx7aRrtTPthwzudOpVJcX2ecadD3fd69Cjz1E5V1hCJi0wyNvY
 qUlV0dv7zQrvbIrQbSmHd6C5LGHEa5RPzfn8L0QH8CSo3rSXFHeeX47TjRN1xFt8Fr2m5q+C+6D
 67O/5bHx2QnGRoOcBaLKxn1Prtnzod9OyXk/Kv5r97GWwXCNuCp9sarwHMqRTg4DkK4OV7rypKB
 AZ6S1TaR+FtmyZfDUt/TyGeRrA0PIBanT4xsYsAgH4B5AL7wQTwpD3tgUzrlBK8PC90wzncRnmM
 vZIbR+CxAXXWtMbaMYOVGiCPo9SlisFxFRwYQtfUSj+s/rx9AR/pr818kvGmPgvvUxfBeLC9SD6
 C61RVrxw2QMRGnA==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Queue-Id: 370B72000C
X-Stat-Signature: a1pbm1upkjfoxhbwtqy8i4u4y19dxdo9
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781032291-293958
X-HE-Meta: U2FsdGVkX1/B5QZ1QpHIAURMT44mXCegQ9CD0GePjOXvgK8dpsegCwGV2Rd3mH2ZdfIAPSOA7h8O7GVDYotwvy96uhiZO1eN2pXcKVAYeBCVufkshBTyWY69J8InV15lCvynMzrPPwYcA+dJQlZB2vJISYHa4LguO21K4MgKJWuVYiCPOwKiUYnHOxi/DCPVemQdBN39/AgrPON2AcwF41IwuBwVDaHu21h9h7qYKp8aTuXtYYSh3ETXHM/45KVQBkrKpj7tC8bqqstF04RmVBX9wZccorb5s5mFao9+Bp6xE7hXo3wgyCueUL/vLdx1t/I6aREvq/EkdrhpvxYHAiiXUylKH373O4ncKycQQFP1+nJVUsnjqzTTMzK7WmIEbZqiaZVQSQttGKEMVvgn5fs9exHxkm6GRIEtUJxDAxCO4AaPirpydYZIL3sdsUSNMaBWXfECBrTMMLAFoKbgaUy63UQGh3it5oLaHzL2NmRlFx3KTASXIr+yd9NzGLFB2LukNoRw8ZbWzCpFcLaAMzgTR+haGuIMsINtow6aHRlvjV2KxFoEI0lDqaC5DXQA7VxW93f8olnKJkwgWKRUf9YmR9nd6dwZnxfTlJ3uBZ4+7bd9EqlVwHQeJMCId5zAyTtx4qq0pLgOC3Dq3+JV9X0YcxXZ4lzkpwm/zpl8HL8oYJd+AmGFL36OHiBjixqCmPJ9AD8ho8+zIOeKi1Vf2G8gxwedxvAbbcVcoeMgmoqAAC9H/Ysk6qAOcgFM5sRtGSBF/qal2F+NXnUWobkEzLlTVFA6gx0CXnzfPhWlGfBuVKh/ZRCRRe4IKtQJhSkRmYgUev2/4NyIkRufiBcvJQrrYusJCej2oC2XsuF4rLZneZ1Wo74pjuLFngc0BQJ0qUzb1mbr1ChrOhTsJaB7StY94QpOzjo+2+tnTcalCQH+78oJ1ZpoFvRTCY/w4YsS7vm2RJWKabgnSPVlTx5
 h385fsAO
 qkzEMNKuwVmRIB+3qQKhOLz52LPuaQ2jwkAynw9bnLKzHkt/k+fPpHABurBbVdGyxH/NYQ9qcGO3u7dEZPKvq9D0hw/jHa+Z3j0qcsTk3LWW2TWLVQ2oW35Z2j98Gh4n0t9Y73vts3LS2CbFKV1P9oMPmKON08uNMLmlRGKtp0FmfxfVrCrIzh9Cc0s+8mBdAOwHABeDxnTBNqlZFvKswkpm5Pxsp2BPwh4gLAAf11E4eryX0Qk0AVtCLFQdPN2XBS1wgLADYcntvQTrkhJJns0opRbOejKwhtWstegKQq26VStilrsKE46h0mi67svZdydmB
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
index 8daf2ca409ba..0dea92a9079b 100644
--- a/drivers/block/rnull/configfs.rs
+++ b/drivers/block/rnull/configfs.rs
@@ -60,7 +60,10 @@ impl AttributeOperations<0> for Config {
 
     fn show(_this: &Config, page: &mut [u8; PAGE_SIZE]) -> Result<usize> {
         let mut writer = kernel::str::Formatter::new(page);
-        writer.write_str("blocksize,size,rotational,irqmode,completion_nsec,memory_backed\n")?;
+        writer.write_str(
+            "blocksize,size,rotational,irqmode,completion_nsec,memory_backed,\
+             submit_queues\n",
+        )?;
         Ok(writer.bytes_written())
     }
 }
@@ -85,6 +88,7 @@ fn make_group(
                 irqmode: 4,
                 completion_nsec: 5,
                 memory_backed: 6,
+                submit_queues: 7,
             ],
         };
 
@@ -103,6 +107,7 @@ fn make_group(
                     completion_time: time::Delta::ZERO,
                     name: name.try_into()?,
                     memory_backed: false,
+                    submit_queues: 1,
                 }),
             }),
             core::iter::empty(),
@@ -168,6 +173,7 @@ struct DeviceConfigInner {
     completion_time: time::Delta,
     disk: Option<GenDisk<NullBlkDevice>>,
     memory_backed: bool,
+    submit_queues: u32,
 }
 
 #[vtable]
@@ -191,15 +197,16 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
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
@@ -232,3 +239,32 @@ fn from_str(s: &str) -> Result<Self> {
 }
 
 configfs_simple_bool_field!(DeviceConfig, 6, memory_backed);
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
+        if value == 0 || value > kernel::cpu::num_possible_cpus() {
+            return Err(kernel::error::code::EINVAL);
+        }
+
+        this.data.lock().submit_queues = value;
+        Ok(())
+    }
+}
diff --git a/drivers/block/rnull/rnull.rs b/drivers/block/rnull/rnull.rs
index 8e4d2b270bcf..a7c35f33631a 100644
--- a/drivers/block/rnull/rnull.rs
+++ b/drivers/block/rnull/rnull.rs
@@ -78,6 +78,10 @@
             default: false,
             description: "Create a memory-backed block device.",
         },
+        submit_queues: u32 {
+            default: 1,
+            description: "Number of submission queues",
+        },
     },
 }
 
@@ -100,15 +104,16 @@ fn init(_module: &'static ThisModule) -> impl PinInit<Self, Error> {
             for i in 0..module_parameters::nr_devices.value() {
                 let name = CString::try_from_fmt(fmt!("rnullb{}", i))?;
 
-                let disk = NullBlkDevice::new(
-                    &name,
-                    module_parameters::bs.value(),
-                    module_parameters::rotational.value(),
-                    module_parameters::gb.value() * 1024,
-                    module_parameters::irqmode.value().try_into()?,
-                    Delta::from_nanos(completion_time),
-                    module_parameters::memory_backed.value(),
-                )?;
+                let disk = NullBlkDevice::new(NullBlkOptions {
+                    name: &name,
+                    block_size: module_parameters::bs.value(),
+                    rotational: module_parameters::rotational.value(),
+                    capacity_mib: module_parameters::gb.value() * 1024,
+                    irq_mode: module_parameters::irqmode.value().try_into()?,
+                    completion_time: Delta::from_nanos(completion_time),
+                    memory_backed: module_parameters::memory_backed.value(),
+                    submit_queues: module_parameters::submit_queues.value(),
+                })?;
                 disks.push(disk, GFP_KERNEL)?;
             }
 
@@ -122,25 +127,38 @@ fn init(_module: &'static ThisModule) -> impl PinInit<Self, Error> {
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



