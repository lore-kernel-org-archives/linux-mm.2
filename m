Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95F14CD8CB2
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:13:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0768D6B00CA; Tue,  9 Jun 2026 15:13:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 027EF6B00CC; Tue,  9 Jun 2026 15:13:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E806C6B00CD; Tue,  9 Jun 2026 15:13:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D45AF6B00CA
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:13:07 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6AB511406EE
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:13:07 +0000 (UTC)
X-FDA: 84861322014.09.57CE4C3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9389F1C0008
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:13:05 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TFpYDTDB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781032385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JnD8AYBlSFJHV8ifo4XwIzlj5eOON9Q0z1EH0iWmsCE=;
	b=yf0teSsZqu4xE8m2GLrddfg4rTdSe2Ak3RXin4MURr0Z+QxNYb+nDa+9Z+1h67zbo1zGR3
	Vz43cwq8cdAeeaebtKy9Kpq92Tb8KD5T7MdKs96sVouAbadtZeDDDJWD2ySndBQ2AF3AZI
	SMZe95WcnFjK2JeaFLfPHKooQZlsWqw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TFpYDTDB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781032385;
	b=Zzy2Qvw+OcaYkkMJUodhnlxkRDUdsIr62SHcYqTqnz9/xjsV0/CinUunO0XHz0fLD6NbI4
	uMvFQlLCLyxAMGG07CEoY+WfeXojfQrgpef81VRfbDKtfqOybDQLFZ+cjfRsq3U73nDZo7
	hed1Uk5r8Jqp/u8oeAhI4r5471Dvcpk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D351B441BE;
	Tue,  9 Jun 2026 19:13:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA1051F00898;
	Tue,  9 Jun 2026 19:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781032384;
	bh=JnD8AYBlSFJHV8ifo4XwIzlj5eOON9Q0z1EH0iWmsCE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=TFpYDTDBuIAzpa+0TjHG5dMSItuqqqLZhFGeQ34qoDBgGbY2MoHw2glhTaoX81oCm
	 9z0VXjifWppnmUn0b/0WnuVlIJ/msxO6TdXR2BXu0PffY8j17xDH0BLMyNEONtfaa5
	 0b0MveTNIZzwhgPjhPSz024RZcIvQd7gj+d/h3U7rX+T2oT+TRUe6R9PPvaDucAlo3
	 dhgUYoDWmMPr6lEelcLBQi9AtCdCLExLm7X/WjKemb0TbVpLy6lOWzE9nDibDxjxrJ
	 rKsjZGaDcoo4HrDKmvyXeaniKekTP9LHlqPsMQ7A5+RAgenOJURmR0Y/El9KRA68M3
	 nSA6T58L5V6UA==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 09 Jun 2026 21:08:25 +0200
Subject: [PATCH v2 46/83] block: rnull: add shared tags
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-rnull-v6-19-rc5-send-v2-46-82c7404542e2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=13841;
 i=a.hindborg@kernel.org; h=from:subject:message-id;
 bh=OyYo3h9FH7tddSUSU2yGqcG1rcOMZa8+hV0gLvVXT30=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqKGTeznS9taKg4dSs5gVp6USJA2+jTJFwZidH4
 aBNBag7rUaJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaihk3gAKCRD6UCkIqsW9
 0HtxEACstjqG92HymGqbWHGNy9sEvKNUzNlbVl7NQKWv5rxeAIN2/U3xOvzo9HHjRbXBbQrz3Hq
 /ygvkPv1e/v6mOOFMSHLLL3rwlfgGXZ1JSZykGsCYNc+ggl6+cGbuOetVXEt4E0LHzqNLBi1/IY
 4E3qoazdTGvD7Ms4eycgZ/Q9WpPM1SzmnGZz6iucfO0/zumZhVEWty6ofpwVDXWA2pMjJNFymCx
 lVC7/sgmJfQzvMMLAskuJwCBQ57FncfWBQKlyUT8TWJdmtQCVjyNFRH0D/pafBn7M0nYTwi217H
 z45FxqGkhzSe0AOZJgfmWf4yE3DgJ95LqlxaG3pXKulcf7m2L9LehCoEfOKVVF0Wvb55/pAiPu1
 ofTBQ2sJKjf8pNdm8/R3UVcO44WJDbll32vo6/h4tIpH/P4STXAW/SnZPN23Q2T4M945He/g21E
 d1hK4m6b4ljc6hjIh92kokd0Xn2nVnajcqZpNhCxSG98at29luZcwruLAag6M2KtV+1uimnIKP2
 mAiMahiFIBKe+4ZW9KIKuScsxOkaQ6nwg6XckyaCxi16iIC6CJ7HQ7Ix5xu/ndi9o/2pcp5kc4+
 JS4G2uI7K7ZdKlm2BQq93oxC4S2WvjB28W1v9h8A0C+6Mlafa8QUaVhUF4EOvUXAWSg2+xy7v/7
 GS9TiRF96HEb1pg==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9389F1C0008
X-Stat-Signature: xyxtgc835jeuaxp8epfrcc3du5f5hqmm
X-HE-Tag: 1781032385-873237
X-HE-Meta: U2FsdGVkX1+q6dn9a/K+IuQDydJSL5+WLt2/Etxz5RxvzPFFBIu1cOPlFUYBqWNpyWfL4yPY7iEhsFm2/aPSfEWs/yTsTShK5jj8xswNgjIIpKnR8N0FfShJYk9HbqMs64uMAez42mA4zZ26/fCKahKpYHr7QkQ9HuPWDxQDK3lUh0ssSeuV3XtQwDOX/MgdkzfIPGlpDUhzkZRVSpnqTc9brWbUncXXlJIG3QLyUod59oAPO76nC1vCaUSKD7OoeVfUeJ1e19iXQVS7bWqDtsGuNPzaKG85PYvOvH9EVHWwpvu3DmlPvQ8PMt53TFbZWN8a+VFwnBUqP41vSWkOFJLDzfYkIcWZ6XP+vEetC4CK6VTD2tOrAAqg+MAtfWDrR/X893p774Kv/dcDowAVfa9CN4x5tcZBodBqu3O/Bxh5WIhkKki3JCD4bLMmmH+NuwLftG/0PlSDTfdyU4CEtu06ySiUMXGBFQgC1xzkn4t5d3L88S3SbGInYczA9hSDezbVk+22hKIpuyScX6QhfDC371/X73IzHyOGjQE40FDuWhOsZL5UdwNGQvu2I6l/mZ6ICBvLYT/Asanfe9Jbn8Zk/ZfrKrBkG+JLW8ZQd8ZwlQ07G180LD+bpwPA5IPAFnushSRC1zl/0CvGj/SssE2QyNSSA1Ot+VZZ+gDPgofmeoxP2P+Yt7N2X4vJKBoBkvjg9Fua3vvG3/6e6vMBrvQGqrMHZ6wDN9uG0XxjinHBfLKIMxiqrTSvoSKt6mXQ8RmoyEtFcsHmSW5HsUbZKqgbVAQhVsd8mfhpdpeIwNBuAQlx8CVK/nQjMN6uycbbvlRfSouJRPyLsTgDaL3THzvyQEL9kCs/m5ILJi3WKe5alheTM5rGc56EQJN6pIJDg/j0bpZhA+tbZdS7DfjkwiMiJr42KKF+uP42Bw8ujw931ZXlLjXEAS1I8lj5PMsuvP/VvZujEuYSM4zTv00
 JFW0exip
 8qhdhdM+SkVi3RX6OC+cSvkp1EGuEMHPNCb1E0IehmR9j/ogbNcVc5SjpHcHn5AdgMjsAlGxC6Ll/eVpvWdFvLyuahQTfaSoGllOA+gTNLUHdqMQad5dcjTXa3odyR0qBoomroieIiePmgWbmgru4vFJlw2BMcG+YHYZxAXaaTH8F85K9y2hRFgcSrrDKAkaqPSMFglyMW+weYTjAfdNR4EhOEla3syXwEX8LwjRZ54urJ+eVzAztRUqSaPIHLo+Z5M5hwKt0tWHFuh+75q2q3R4+vLURqnvkblF7z9ja2N0tmuBU76UwmG5Z93MKMTM0zDjT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add support for sharing tags between multiple rnull devices. When
enabled via the `shared_tags` configfs attribute, all devices in the
group share a single tag set, reducing memory usage.

This feature requires creating a shared `TagSet` that can be referenced
by multiple devices.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 drivers/block/rnull/configfs.rs |  44 +++++++++----
 drivers/block/rnull/rnull.rs    | 136 +++++++++++++++++++++++++---------------
 rust/kernel/block/mq/tag_set.rs |  18 ++++++
 3 files changed, 136 insertions(+), 62 deletions(-)

diff --git a/drivers/block/rnull/configfs.rs b/drivers/block/rnull/configfs.rs
index 5e6bcf9d31d8..a84854e7c358 100644
--- a/drivers/block/rnull/configfs.rs
+++ b/drivers/block/rnull/configfs.rs
@@ -10,9 +10,12 @@
     bindings,
     block::{
         badblocks::BadBlocks,
-        mq::gen_disk::{
-            GenDisk,
-            GenDiskBuilder, //
+        mq::{
+            gen_disk::{
+                GenDisk,
+                GenDiskBuilder, //
+            },
+            TagSet, //
         }, //
     },
     configfs::{
@@ -45,7 +48,9 @@
 
 mod macros;
 
-pub(crate) fn subsystem() -> impl PinInit<kernel::configfs::Subsystem<Config>, Error> {
+pub(crate) fn subsystem(
+    shared_tag_set: Arc<TagSet<NullBlkDevice>>,
+) -> impl PinInit<kernel::configfs::Subsystem<Config>, Error> {
     let item_type = configfs_attrs! {
         container: configfs::Subsystem<Config>,
         data: Config,
@@ -55,11 +60,17 @@ pub(crate) fn subsystem() -> impl PinInit<kernel::configfs::Subsystem<Config>, E
         ],
     };
 
-    kernel::configfs::Subsystem::new(c"rnull", item_type, try_pin_init!(Config {}))
+    kernel::configfs::Subsystem::new(
+        c"rnull",
+        item_type,
+        try_pin_init!(Config { shared_tag_set }),
+    )
 }
 
 #[pin_data]
-pub(crate) struct Config {}
+pub(crate) struct Config {
+    shared_tag_set: Arc<TagSet<NullBlkDevice>>,
+}
 
 #[vtable]
 impl AttributeOperations<0> for Config {
@@ -69,7 +80,7 @@ impl AttributeOperations<0> for Config {
         let mut writer = kernel::str::Formatter::new(page);
         writer.write_str(
             "blocksize,size,rotational,irqmode,completion_nsec,memory_backed,\
-             submit_queues,use_per_node_hctx,discard,blocking\n",
+             submit_queues,use_per_node_hctx,discard,blocking,shared_tags\n",
         )?;
         Ok(writer.bytes_written())
     }
@@ -106,6 +117,7 @@ fn make_group(
                 cache_size_mib: 15,
                 mbps: 16,
                 blocking: 17,
+                shared_tags: 18,
             ],
         };
 
@@ -139,6 +151,8 @@ fn make_group(
                     cache_size_mib: 0,
                     mbps: 0,
                     blocking: false,
+                    shared_tags: false,
+                    shared_tag_set: self.shared_tag_set.clone(),
                 }),
             }),
             core::iter::empty(),
@@ -215,6 +229,8 @@ struct DeviceConfigInner {
     disk_storage: Arc<DiskStorage>,
     mbps: u32,
     blocking: bool,
+    shared_tags: bool,
+    shared_tag_set: Arc<TagSet<NullBlkDevice>>,
 }
 
 #[vtable]
@@ -245,17 +261,20 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
                 capacity_mib: guard.capacity_mib,
                 irq_mode: guard.irq_mode,
                 completion_time: guard.completion_time,
-                memory_backed: guard.memory_backed,
-                submit_queues: guard.submit_queues,
-                home_node: guard.home_node,
                 discard: guard.discard,
-                no_sched: guard.no_sched,
                 bad_blocks: guard.bad_blocks.clone(),
                 bad_blocks_once: guard.bad_blocks_once,
                 bad_blocks_partial_io: guard.bad_blocks_partial_io,
                 storage: guard.disk_storage.clone(),
                 bandwidth_limit: u64::from(guard.mbps) * 2u64.pow(20),
-                blocking: guard.blocking,
+                shared_tag_set: guard.shared_tags.then(|| guard.shared_tag_set.clone()),
+                tag_set: crate::TagSetOptions {
+                    submit_queues: guard.submit_queues,
+                    home_node: guard.home_node,
+                    blocking: guard.blocking,
+                    memory_backed: guard.memory_backed,
+                    no_sched: guard.no_sched,
+                },
             })?);
             guard.powered = true;
         } else if guard.powered && !power_op {
@@ -427,3 +446,4 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
 
 configfs_simple_field!(DeviceConfig, 16, mbps, u32);
 configfs_simple_bool_field!(DeviceConfig, 17, blocking);
+configfs_simple_bool_field!(DeviceConfig, 18, shared_tags);
diff --git a/drivers/block/rnull/rnull.rs b/drivers/block/rnull/rnull.rs
index 181fce551a91..bcf6a85f1cbc 100644
--- a/drivers/block/rnull/rnull.rs
+++ b/drivers/block/rnull/rnull.rs
@@ -143,6 +143,10 @@
             default: false,
             description: "Register as a blocking blk-mq driver device",
         },
+        shared_tags: bool {
+            default: false,
+            description: "Share tag set between devices for blk-mq",
+        },
     },
 }
 
@@ -158,19 +162,30 @@ impl kernel::InPlaceModule for NullBlkModule {
     fn init(_module: &'static ThisModule) -> impl PinInit<Self, Error> {
         pr_info!("Rust null_blk loaded\n");
 
-        let mut disks = KVec::new();
+        pin_init::pin_init_scope(move || -> Result<_, Error> {
+            let submit_queues = if module_parameters::use_per_node_hctx.value() {
+                kernel::numa::num_online_nodes()
+            } else {
+                module_parameters::submit_queues.value()
+            };
+            let home_node = module_parameters::home_node.value();
+            let blocking = module_parameters::blocking.value();
+            let memory_backed = module_parameters::memory_backed.value();
+            let no_sched = module_parameters::no_sched.value();
+
+            let shared_tag_set = NullBlkDevice::build_tag_set(TagSetOptions {
+                submit_queues,
+                home_node,
+                blocking,
+                memory_backed,
+                no_sched,
+            })?;
 
-        let defer_init = move || -> Result<_, Error> {
+            let mut disks = KVec::new();
             let completion_time: i64 = module_parameters::completion_nsec.value().try_into()?;
             for i in 0..module_parameters::nr_devices.value() {
                 let name = CString::try_from_fmt(fmt!("rnullb{}", i))?;
 
-                let submit_queues = if module_parameters::use_per_node_hctx.value() {
-                    kernel::numa::num_online_nodes()
-                } else {
-                    module_parameters::submit_queues.value()
-                };
-
                 let block_size = module_parameters::bs.value();
                 let disk = NullBlkDevice::new(NullBlkOptions {
                     name: &name,
@@ -179,27 +194,30 @@ fn init(_module: &'static ThisModule) -> impl PinInit<Self, Error> {
                     capacity_mib: module_parameters::gb.value() * 1024,
                     irq_mode: module_parameters::irqmode.value().try_into()?,
                     completion_time: Delta::from_nanos(completion_time),
-                    memory_backed: module_parameters::memory_backed.value(),
-                    submit_queues,
-                    home_node: module_parameters::home_node.value(),
                     discard: module_parameters::discard.value(),
-                    no_sched: module_parameters::no_sched.value(),
                     bad_blocks: Arc::pin_init(BadBlocks::new(false), GFP_KERNEL)?,
                     bad_blocks_once: false,
                     bad_blocks_partial_io: false,
                     storage: Arc::pin_init(DiskStorage::new(0, block_size as usize), GFP_KERNEL)?,
                     bandwidth_limit: u64::from(module_parameters::mbps.value()) * 2u64.pow(20),
-                    blocking: module_parameters::blocking.value(),
+                    shared_tag_set: module_parameters::shared_tags
+                        .value()
+                        .then(|| shared_tag_set.clone()),
+                    tag_set: TagSetOptions {
+                        submit_queues,
+                        home_node,
+                        blocking,
+                        memory_backed,
+                        no_sched,
+                    },
                 })?;
                 disks.push(disk, GFP_KERNEL)?;
             }
 
-            Ok(disks)
-        };
-
-        try_pin_init!(Self {
-            configfs_subsystem <- configfs::subsystem(),
-            param_disks <- new_mutex!(defer_init()?),
+            Ok(try_pin_init!(Self {
+                configfs_subsystem <- configfs::subsystem(shared_tag_set),
+                param_disks <- new_mutex!(disks),
+            }))
         })
     }
 }
@@ -211,17 +229,14 @@ struct NullBlkOptions<'a> {
     capacity_mib: u64,
     irq_mode: IRQMode,
     completion_time: Delta,
-    memory_backed: bool,
-    submit_queues: u32,
-    home_node: i32,
     discard: bool,
-    no_sched: bool,
     bad_blocks: Arc<BadBlocks>,
     bad_blocks_once: bool,
     bad_blocks_partial_io: bool,
     storage: Arc<DiskStorage>,
     bandwidth_limit: u64,
-    blocking: bool,
+    shared_tag_set: Option<Arc<TagSet<NullBlkDevice>>>,
+    tag_set: TagSetOptions,
 }
 
 #[pin_data]
@@ -243,9 +258,50 @@ struct NullBlkDevice {
     disk: SetOnce<Arc<Revocable<GenDiskRef<Self>>>>,
 }
 
+struct TagSetOptions {
+    submit_queues: u32,
+    home_node: i32,
+    blocking: bool,
+    memory_backed: bool,
+    no_sched: bool,
+}
+
 impl NullBlkDevice {
     const BANDWIDTH_TIMER_INTERVAL: Delta = Delta::from_millis(20);
 
+    fn build_tag_set(options: TagSetOptions) -> Result<Arc<TagSet<Self>>> {
+        let TagSetOptions {
+            submit_queues,
+            home_node,
+            blocking,
+            memory_backed,
+            no_sched,
+        } = options;
+
+        if home_node > kernel::numa::num_online_nodes().try_into()? {
+            return Err(code::EINVAL);
+        }
+
+        let numa_node = if home_node == -1 {
+            kernel::alloc::NumaNode::NO_NODE
+        } else {
+            kernel::alloc::NumaNode::new(home_node)?
+        };
+
+        let mut flags = mq::tag_set::Flags::default();
+        if blocking || memory_backed {
+            flags |= mq::tag_set::Flag::Blocking;
+        }
+        if no_sched {
+            flags |= mq::tag_set::Flag::NoDefaultScheduler;
+        }
+
+        Arc::pin_init(
+            TagSet::new(submit_queues, (), 256, 1, numa_node, flags),
+            GFP_KERNEL,
+        )
+    }
+
     fn new(options: NullBlkOptions<'_>) -> Result<Arc<GenDisk<Self>>> {
         let NullBlkOptions {
             name,
@@ -254,37 +310,22 @@ fn new(options: NullBlkOptions<'_>) -> Result<Arc<GenDisk<Self>>> {
             capacity_mib,
             irq_mode,
             completion_time,
-            memory_backed,
-            submit_queues,
-            home_node,
             discard,
-            no_sched,
             bad_blocks,
             bad_blocks_once,
             bad_blocks_partial_io,
             storage,
             bandwidth_limit,
-            blocking,
+            shared_tag_set,
+            tag_set,
         } = options;
 
-        let mut flags = mq::tag_set::Flags::default();
+        let memory_backed = tag_set.memory_backed;
 
-        if blocking || memory_backed {
-            flags |= mq::tag_set::Flag::Blocking;
-        }
-
-        if no_sched {
-            flags |= mq::tag_set::Flag::NoDefaultScheduler;
-        }
-
-        if home_node > kernel::numa::num_online_nodes().try_into()? {
-            return Err(code::EINVAL);
-        }
-
-        let numa_node = if home_node == -1 {
-            kernel::alloc::NumaNode::NO_NODE
+        let tagset = if let Some(shared) = shared_tag_set {
+            shared
         } else {
-            kernel::alloc::NumaNode::new(home_node)?
+            Self::build_tag_set(tag_set)?
         };
 
         let capacity_sectors = capacity_mib << (20 - block::SECTOR_SHIFT);
@@ -294,11 +335,6 @@ fn new(options: NullBlkOptions<'_>) -> Result<Arc<GenDisk<Self>>> {
             return Err(code::EINVAL);
         }
 
-        let tagset = Arc::pin_init(
-            TagSet::new(submit_queues, (), 256, 1, numa_node, flags),
-            GFP_KERNEL,
-        )?;
-
         let queue_data = Arc::try_pin_init(
             try_pin_init!(Self {
                 storage,
diff --git a/rust/kernel/block/mq/tag_set.rs b/rust/kernel/block/mq/tag_set.rs
index bfb8f8af4ee1..5359e60fb5a5 100644
--- a/rust/kernel/block/mq/tag_set.rs
+++ b/rust/kernel/block/mq/tag_set.rs
@@ -124,3 +124,21 @@ fn drop(self: Pin<&mut Self>) {
         unsafe { T::TagSetData::from_foreign(tagset_data) };
     }
 }
+
+// SAFETY: It is safe to share references to `TagSet` across thread boundaries as long as
+// `TagSetData` is `Sync`.
+unsafe impl<T> Sync for TagSet<T>
+where
+    T: Operations,
+    T::TagSetData: Sync,
+{
+}
+
+// SAFETY: It is safe to transfer ownership of `TagSet` across thread boundaries if the associated
+// private data is `Send` (it will be dropped with the `TagSet`).
+unsafe impl<T> Send for TagSet<T>
+where
+    T: Operations,
+    T::TagSetData: Send,
+{
+}

-- 
2.51.2



