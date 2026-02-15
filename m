Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 101E6E63F1C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 00:06:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8834A6B00AA; Sun, 15 Feb 2026 18:43:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 824326B00B2; Sun, 15 Feb 2026 18:43:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71A1B6B00B3; Sun, 15 Feb 2026 18:43:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 875A66B00AA
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 18:43:19 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 81ABB8CCBC
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:43:19 +0000 (UTC)
X-FDA: 84448319718.05.63C1DD3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id D4FFC140004
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:43:17 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BI8OtOGP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771198997; a=rsa-sha256;
	cv=none;
	b=SgyASGg/flaxcSrY6avLmhcEx4ogWqaSZ7iGc6vKfjY9M5Bf8/5FG1nTN8XRXZZbHvTm37
	WVTuBQcTbD66f+BG3ANGaMiPPjowdvfsVtFAO0u1WlKB4HsVuNNYVANJNo68ZnGqBk+wGg
	+TUl2SrEb6BcSGa9jEJrM60tJYVfFYo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BI8OtOGP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771198997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2aob8arwEQKaKEk/Gq+YNReSwNwNiFA3nQZIhyi5tVA=;
	b=1oqoKoNvftyxtB3us/sbNwtTBG9zSC95b5UqFX3v1M1rZoooVQ/q3lyQHEYKDytni7UytH
	I1fOIjzmz4Uzl3IGNr4vIbuZVCQodeRGzwgCPz/gNYnxgCZhJnmb1cm33J+jI/qTflEavP
	P8QuYWWAXaC5EsPldqm5oZVRmyW2+zA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5A6496013F;
	Sun, 15 Feb 2026 23:43:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA917C4CEF7;
	Sun, 15 Feb 2026 23:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771198997;
	bh=xGoluFA0is+PW3oIdECTL4BJYJwKP74nRrbzYRfRoWk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=BI8OtOGPWqfX79yRtNzdumXoN1AkPyhoQFxEqPqShE+LORe81VTcXuWju2k2C/TGc
	 94v3a6l3t7lLWBNdQxuWaRBl6RVAUHBUH1bX++VxWfyuwie9I3bXbP5qgGY8dh2MYc
	 49s9qkf0lAhzL3BvfGtWH5RE47w84fK1slJ2qS4fbwGLGzdjEc+jGRxRCeP3/jAMUL
	 c1ulLTpr1ab0M7P2DDgpIWlwFDTTBtgWknf92yyle2WFmCzKGMN7ZIlmbS45Jof4d5
	 mDpWfzkUryuMtnHvJNJ3onRUJW5yqrkitIJ5AJJgPmN2rNqtmUwhMyL7VMntrRCUSo
	 P9CcmdB0E/n+w==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 16 Feb 2026 00:35:50 +0100
Subject: [PATCH 63/79] block: rnull: add an option to change the number of
 hardware queues
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-rnull-v6-19-rc5-send-v1-63-de9a7af4b469@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=13710;
 i=a.hindborg@kernel.org; h=from:subject:message-id;
 bh=xGoluFA0is+PW3oIdECTL4BJYJwKP74nRrbzYRfRoWk=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpklhUWEuv7HdW35YDvuGKYE8l1tBjini+J5IAD
 ksxuawWzxSJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZJYVAAKCRDhuBo+eShj
 dwJOEACuhdjHz9OU2pi8f1XJnCz/BujfUae1C49VE34im+iJY74WEEzIyRJePG39SUY/yHjTWDp
 PRr0Q83+P+XTjDa9VbQpkOucxGVO2Y2ARa6RzF3mAjBvllIYhERY2DwDdaJSmQt0L7Iy45oBYOO
 Ap96VkzwyGT20pY02BY0DyVLSGlhOjzmSNOfey8zgmkveFxUt0hpi8FvqUyJ9Shs+uNjJxl+29Z
 itvamOKnpI6rmXyKSFhkjnui6uBRLUw+skWyWENJC6AzRVah2ECXnOqI9uzMs7Wt3BXBpic1Imo
 4RTe2ijuixMMxo1wMkN/8SVSzkPGyPwy4zawZ8uCAaG/ZFWBsxoRY9KhWaCWpDmIJr3CS1C1gZX
 dGwHFMjqh5SX8gEg8xURdJ0+ilSkB66ufkfTMXqZ3vUeR7XhpwQFvx0aXLAgb3KohixMZbsAj7O
 XjDnfLxwSTJ5KZzVMErIzPNOnGrj+ITRhPtmryIJBni/y9KQ7v9ky8GK17Ga37uEr0jXZhL1ipY
 kMWKlAdHEZI09rMuIQUGG8XZajrNMJF+TcKIBxglM4XnoPVZxZlEfiMLfy2YsoHr1+2TOgpF+bn
 gTs1f68yrSF6R52qK5NQ9uirdGAVJfV4YI6StnyeWblfCT4eCX+UiZAtnDfumWpNwklDuILj82b
 Kz5JtyFk0YPe2ew==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D4FFC140004
X-Stat-Signature: dzmtf85ydy5h9hto54ak8zgqci1n53hz
X-HE-Tag: 1771198997-459592
X-HE-Meta: U2FsdGVkX1+2QNFU42tYk8wymrLAXsxSppe0tsOaH/aEfio5H7YmIMEy5rcChDwvVRnTLGeGKX8lLRO20g6tFFl7ddRG5P/6K0MaRi+jMDEKT4N7JAmTvOLJKvwH8NGgpQ/3y/+H3J9tkzYs8kO4DKlRRYPcbtRv/QMTAjp5phrGCKG7z3DVp4f5w/VmLNojlbx+7lZ276+wKHBpHXxU4VvV5etdlMkSRZ/FnRKeUPxqzTe29vHypOQz/YswAvXIMy/yTbWX6Q6224z+SB/J/rc0diUyt286UFZOXJJ41IV0DIcZsPfBZO//nHOTbg3TAWa4MMiuOVTDM9NG3mBzfepCExZvBJbpub9jOFP9cVJjuR3whczJ6Uq/oSvf4z788E40G5E/clL2thL4vbkGwRCtTtLf741Ec1e/aQfwFYTDKTA20iRORQUjc6nParL36ymM8GpV+tYQySwZeCYpFYInShhelgZzyxCf0d6txG71Skqg5yoqVBqP9ZDVAzLwidZU+WEAZBA/dLVGlHbEwf/AKVkFqjmxg5sT1O19C+MhnSj7ImpY9Jr+QSlEk1DOE1uIJoGFI/VAYMmr8Nkw5Dqdj0n4VRPIye2Ussa2y3jPBjG1CHD32csC9elb6aD9ArAK7GxAUuGJo5pO9+gJPefG6YGcGAZOU9s2vxTdHicyCPrTrUdDH+ozE2Ksj77WPDQbtFMQJZYfdXLYqcyL5/jwame2Xlz5epfsyJxj6ODQyuKQ/jJMezs6Lf99cB9h7arDVD+MR4nWHn5IqMbTl1c4Uu0kgerJMDlRsofYTuYGxLehxGJIMfx5kFkzeKlbIp6FOKOAMPVLbU8z/2p46iaZLo//vT7kgY9RpNNb0JGp5mI5CQhX1HKy0AEb6TnTLx35XHlp7BUvi0YcmHIEI89NOA/GnCRUxVx7xMoikdprTwiJOoErDxOqzZzVtHlZOtbovOiTcPmDhyTULYu
 cROYxSMP
 7qgG5Klme7ATQpjgStOWAzXqJ3wSo9xMA1UxldSmEh43gHzc48+El+lFEe/DrrPk5ENDSt0td4ITcMb7BEveXkjRtSii128yzvRxVid2YJx2mwkJxCa8tSrQGdTsQkJMFSGCuvDSMaERaUlXyR67sWZdCjIwNA/Xj56APgvhQf5tLBje/Zp7Oyii0UqT/wW47t5mT6XhqJty3jiVSk7rIr2sdynG73afTKlG0KsncMbDw/4Ktiaifpl53f/sJrpQxQdjgvI96dFPlDY2+Y4ED5hTBrLC0yq/ESWwzR/ciF7BUqeCmlifuEZ/ZPnqOub7UYR1kU7ttTEvSB3pX2yiuIrjGaA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a feature to rnull that allows changing the number of simulated
hardware queues during device operation.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 drivers/block/rnull/configfs.rs | 143 +++++++++++++++++++++++++---------------
 drivers/block/rnull/rnull.rs    |  39 +++++++----
 2 files changed, 116 insertions(+), 66 deletions(-)

diff --git a/drivers/block/rnull/configfs.rs b/drivers/block/rnull/configfs.rs
index 816c057f130fc..424722f01ab8d 100644
--- a/drivers/block/rnull/configfs.rs
+++ b/drivers/block/rnull/configfs.rs
@@ -138,7 +138,13 @@ fn make_group(
                     completion_time: time::Delta::ZERO,
                     name: name.try_into()?,
                     memory_backed: false,
-                    submit_queues: 1,
+                    queue_config: Arc::pin_init(
+                        new_mutex!(QueueConfig {
+                            submit_queues: 1,
+                            poll_queues: 0
+                        }),
+                        GFP_KERNEL
+                    )?,
                     home_node: bindings::NUMA_NO_NODE,
                     discard: false,
                     no_sched: false,
@@ -158,7 +164,6 @@ fn make_group(
                     zone_max_open: 0,
                     zone_max_active: 0,
                     zone_append_max_sectors: u32::MAX,
-                    poll_queues: 0,
                     fua: true,
                 }),
             }),
@@ -215,7 +220,7 @@ struct DeviceConfigInner {
     completion_time: time::Delta,
     disk: Option<Arc<GenDisk<NullBlkDevice>>>,
     memory_backed: bool,
-    submit_queues: u32,
+    queue_config: Arc<Mutex<QueueConfig>>,
     home_node: i32,
     discard: bool,
     no_sched: bool,
@@ -235,7 +240,6 @@ struct DeviceConfigInner {
     zone_max_open: u32,
     zone_max_active: u32,
     zone_append_max_sectors: u32,
-    poll_queues: u32,
     fua: bool,
 }
 
@@ -268,7 +272,7 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
                 irq_mode: guard.irq_mode,
                 completion_time: guard.completion_time,
                 memory_backed: guard.memory_backed,
-                submit_queues: guard.submit_queues,
+                queue_config: guard.queue_config.clone(),
                 home_node: guard.home_node,
                 discard: guard.discard,
                 no_sched: guard.no_sched,
@@ -287,7 +291,6 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
                 zone_max_open: guard.zone_max_open,
                 zone_max_active: guard.zone_max_active,
                 zone_append_max_sectors: guard.zone_append_max_sectors,
-                poll_queues: guard.poll_queues,
                 forced_unit_access: guard.fua,
             })?);
             guard.powered = true;
@@ -300,9 +303,17 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
     }
 }
 
-configfs_simple_field!(DeviceConfig, 1,
-                       block_size, u32,
-                       check GenDiskBuilder::<NullBlkDevice>::validate_block_size
+pub(crate) struct QueueConfig {
+    pub(crate) submit_queues: u32,
+    pub(crate) poll_queues: u32,
+}
+
+configfs_simple_field!(
+    DeviceConfig,
+    1,
+    block_size,
+    u32,
+    check GenDiskBuilder::<NullBlkDevice>::validate_block_size
 );
 configfs_simple_bool_field!(DeviceConfig, 2, rotational);
 configfs_simple_field!(DeviceConfig, 3, capacity_mib, u64);
@@ -349,51 +360,57 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
     }
 }
 
-#[vtable]
-impl configfs::AttributeOperations<7> for DeviceConfig {
-    type Data = DeviceConfig;
-
-    fn show(this: &DeviceConfig, page: &mut [u8; PAGE_SIZE]) -> Result<usize> {
-        let mut writer = kernel::str::Formatter::new(page);
-        writer.write_fmt(fmt!("{}\n", this.data.lock().submit_queues))?;
-        Ok(writer.bytes_written())
-    }
+configfs_attribute! {
+    DeviceConfig,
+    7,
+    show: |this, page| show_field(this.data.lock().queue_config.lock().submit_queues, page),
+    store: |this,page| {
+        let config_guard = this.data.lock();
+        let mut queue_config = config_guard.queue_config.lock();
 
-    fn store(this: &DeviceConfig, page: &[u8]) -> Result {
-        if this.data.lock().powered {
-            return Err(EBUSY);
+        let text = core::str::from_utf8(page)?.trim();
+        let value = text.parse().map_err(|_| EINVAL)?;
+        if value > kernel::num_possible_cpus() {
+            return Err(kernel::error::code::EINVAL)
         }
 
-        let text = core::str::from_utf8(page)?.trim();
-        let value = text
-            .parse::<u32>()
-            .map_err(|_| kernel::error::code::EINVAL)?;
+        let old_submit_queues = queue_config.submit_queues;
+        queue_config.submit_queues = value;
+        let total_queue_count = queue_config.submit_queues + queue_config.poll_queues;
+
+        let disk = config_guard.disk.clone();
+
+        drop(queue_config);
+        drop(config_guard);
 
-        if value == 0 || value > kernel::num_possible_cpus() {
-            return Err(kernel::error::code::EINVAL);
+        if let Some(disk) = &disk {
+            if let Err(e) = disk.tag_set().update_hw_queue_count(total_queue_count) {
+                this.data.lock().queue_config.lock().submit_queues = old_submit_queues;
+                return Err(e);
+            }
         }
 
-        this.data.lock().submit_queues = value;
         Ok(())
-    }
+    },
 }
 
 configfs_attribute!(DeviceConfig, 8,
-    show: |this, page| show_field(
-        this.data.lock().submit_queues == kernel::num_online_nodes(), page
-    ),
-    store: |this, page| store_with_power_check(this, page, |this, page| {
-        let value = core::str::from_utf8(page)?
-            .trim()
-            .parse::<u8>()
-            .map_err(|_| kernel::error::code::EINVAL)?
-            != 0;
-
-        if value {
-            this.data.lock().submit_queues *= kernel::num_online_nodes();
-        }
-        Ok(())
-    })
+            show: |this, page| show_field(
+                this.data.lock().queue_config.lock().submit_queues == kernel::num_online_nodes(),
+                page
+            ),
+            store: |this, page| store_with_power_check(this, page, |this, page| {
+                let value = core::str::from_utf8(page)?
+                    .trim()
+                    .parse::<u8>()
+                    .map_err(|_| kernel::error::code::EINVAL)?
+                    != 0;
+
+                if value {
+        this.data.lock().queue_config.lock().submit_queues *= kernel::num_online_nodes();
+                }
+                Ok(())
+            })
 );
 
 configfs_simple_field!(
@@ -518,17 +535,37 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
 configfs_simple_field!(DeviceConfig, 24, zone_max_open, u32);
 configfs_simple_field!(DeviceConfig, 25, zone_max_active, u32);
 configfs_simple_field!(DeviceConfig, 26, zone_append_max_sectors, u32);
-configfs_simple_field!(
+configfs_attribute! {
     DeviceConfig,
     27,
-    poll_queues,
-    u32,
-    check | value | {
+    show: |this, page| show_field(this.data.lock().queue_config.lock().poll_queues, page),
+    store: |this,page| {
+        let config_guard = this.data.lock();
+        let mut queue_config = config_guard.queue_config.lock();
+
+        let text = core::str::from_utf8(page)?.trim();
+        let value = text.parse().map_err(|_| EINVAL)?;
         if value > kernel::num_possible_cpus() {
-            Err(kernel::error::code::EINVAL)
-        } else {
-            Ok(())
+            return Err(kernel::error::code::EINVAL)
         }
-    }
-);
+
+        let old_poll_queues = queue_config.poll_queues;
+        queue_config.poll_queues = value;
+        let total_queue_count = queue_config.submit_queues + queue_config.poll_queues;
+
+        let disk = config_guard.disk.clone();
+
+        drop(queue_config);
+        drop(config_guard);
+
+        if let Some(disk) = &disk {
+            if let Err(e) = disk.tag_set().update_hw_queue_count(total_queue_count) {
+                this.data.lock().queue_config.lock().poll_queues = old_poll_queues;
+                return Err(e);
+            }
+        }
+
+        Ok(())
+    },
+}
 configfs_simple_bool_field!(DeviceConfig, 28, fua);
diff --git a/drivers/block/rnull/rnull.rs b/drivers/block/rnull/rnull.rs
index 3b7edfe7efe44..429819bf042ba 100644
--- a/drivers/block/rnull/rnull.rs
+++ b/drivers/block/rnull/rnull.rs
@@ -10,7 +10,10 @@
 #[cfg(CONFIG_BLK_DEV_ZONED)]
 mod zoned;
 
-use configfs::IRQMode;
+use configfs::{
+    IRQMode,
+    QueueConfig, //
+};
 use disk_storage::{
     DiskStorage,
     NullBlockPage,
@@ -225,6 +228,8 @@ fn init(_module: &'static ThisModule) -> impl PinInit<Self, Error> {
                     *module_parameters::submit_queues.value()
                 };
 
+                let poll_queues = *module_parameters::poll_queues.value();
+
                 let block_size = *module_parameters::bs.value();
                 let disk = NullBlkDevice::new(NullBlkOptions {
                     name: &name,
@@ -234,7 +239,13 @@ fn init(_module: &'static ThisModule) -> impl PinInit<Self, Error> {
                     irq_mode: (*module_parameters::irqmode.value()).try_into()?,
                     completion_time: Delta::from_nanos(completion_time),
                     memory_backed: *module_parameters::memory_backed.value() != 0,
-                    submit_queues,
+                    queue_config: Arc::pin_init(
+                        new_mutex!(QueueConfig {
+                            submit_queues,
+                            poll_queues
+                        }),
+                        GFP_KERNEL,
+                    )?,
                     home_node: *module_parameters::home_node.value(),
                     discard: *module_parameters::discard.value() != 0,
                     no_sched: *module_parameters::no_sched.value() != 0,
@@ -253,7 +264,6 @@ fn init(_module: &'static ThisModule) -> impl PinInit<Self, Error> {
                     zone_max_open: *module_parameters::zone_max_open.value(),
                     zone_max_active: *module_parameters::zone_max_active.value(),
                     zone_append_max_sectors: *module_parameters::zone_append_max_sectors.value(),
-                    poll_queues: *module_parameters::poll_queues.value(),
                     forced_unit_access: *module_parameters::fua.value() != 0,
                 })?;
                 disks.push(disk, GFP_KERNEL)?;
@@ -277,7 +287,7 @@ struct NullBlkOptions<'a> {
     irq_mode: IRQMode,
     completion_time: Delta,
     memory_backed: bool,
-    submit_queues: u32,
+    queue_config: Arc<Mutex<QueueConfig>>,
     home_node: i32,
     discard: bool,
     no_sched: bool,
@@ -302,7 +312,6 @@ struct NullBlkOptions<'a> {
     zone_max_active: u32,
     #[cfg_attr(not(CONFIG_BLK_DEV_ZONED), expect(unused_variables))]
     zone_append_max_sectors: u32,
-    poll_queues: u32,
     forced_unit_access: bool,
 }
 
@@ -342,7 +351,7 @@ fn new(options: NullBlkOptions<'_>) -> Result<Arc<GenDisk<Self>>> {
             irq_mode,
             completion_time,
             memory_backed,
-            submit_queues,
+            queue_config,
             home_node,
             discard,
             no_sched,
@@ -361,7 +370,6 @@ fn new(options: NullBlkOptions<'_>) -> Result<Arc<GenDisk<Self>>> {
             zone_max_open,
             zone_max_active,
             zone_append_max_sectors,
-            poll_queues,
             forced_unit_access,
         } = options;
 
@@ -379,6 +387,11 @@ fn new(options: NullBlkOptions<'_>) -> Result<Arc<GenDisk<Self>>> {
             return Err(code::EINVAL);
         }
 
+        let queue_config_guard = queue_config.lock();
+        let submit_queues = queue_config_guard.submit_queues;
+        let poll_queues = queue_config_guard.poll_queues;
+        drop(queue_config_guard);
+
         let tagset_ctor = || -> Result<Arc<_>> {
             Arc::pin_init(
                 TagSet::new(
@@ -386,8 +399,7 @@ fn new(options: NullBlkOptions<'_>) -> Result<Arc<GenDisk<Self>>> {
                     KBox::new(
                         NullBlkTagsetData {
                             queue_depth: hw_queue_depth,
-                            submit_queue_count: submit_queues,
-                            poll_queue_count: poll_queues,
+                            queue_config,
                         },
                         GFP_KERNEL,
                     )?,
@@ -773,8 +785,7 @@ impl HasHrTimer<Self> for Pdu {
 
 struct NullBlkTagsetData {
     queue_depth: u32,
-    submit_queue_count: u32,
-    poll_queue_count: u32,
+    queue_config: Arc<Mutex<QueueConfig>>,
 }
 
 #[vtable]
@@ -919,8 +930,10 @@ fn report_zones(
     }
 
     fn map_queues(tag_set: Pin<&mut TagSet<Self>>) {
-        let mut submit_queue_count = tag_set.data().submit_queue_count;
-        let mut poll_queue_count = tag_set.data().poll_queue_count;
+        let queue_config = tag_set.data().queue_config.lock();
+        let mut submit_queue_count = queue_config.submit_queues;
+        let mut poll_queue_count = queue_config.poll_queues;
+        drop(queue_config);
 
         if tag_set.hw_queue_count() != submit_queue_count + poll_queue_count {
             pr_warn!(

-- 
2.51.2



