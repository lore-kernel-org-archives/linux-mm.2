Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA185CD8CAD
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:17:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 561A46B0126; Tue,  9 Jun 2026 15:17:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E94E6B0128; Tue,  9 Jun 2026 15:17:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FE856B0129; Tue,  9 Jun 2026 15:17:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2FA6D6B0126
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:17:36 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E80901644C6
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:17:35 +0000 (UTC)
X-FDA: 84861333270.24.9C5700D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2031B40013
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:17:34 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="LruU/bVU";
	spf=pass (imf01.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781032654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p4d5I6NPrj9QC3rwhT3LQJHa+sFgEUUsxiN1Rw94+DE=;
	b=7Pa8LbEgi8szZERzU58uJrNSX8bm8QHhPQk+hsm/mqvoR7rB94G2gXPxXfTSTQwF06uX8V
	daVT5twgqtG7T9O35WdFHqvNLqhbL5Xc5Z6tkA5+J6+29VnFouatPEMwpoUes0QogjNReq
	Wi8j+Ny1RojoYiqpoxG04a4UjbIEBRI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781032654;
	b=LXqrd46lHIVqUKTpTIXj0h0QUrHaX1R8tEU0wR1aRtAfnBCCfc8bTX378WBisoc8r7wyZ9
	gosFf84FJgbqZAJvAJP2S+W16YHgPZFdsv5qX715iXY+kZDWVBej14B2y4Gy5M8iwzikZk
	+GCeNXfcZBcdXp1D7voQ/6/vMAmJSp0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="LruU/bVU";
	spf=pass (imf01.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 74B5E406ED;
	Tue,  9 Jun 2026 19:17:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37F381F00893;
	Tue,  9 Jun 2026 19:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781032653;
	bh=p4d5I6NPrj9QC3rwhT3LQJHa+sFgEUUsxiN1Rw94+DE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=LruU/bVU77MdbFwvtz6tVmVrLebbYltpAyDnwaI/L/LiUSYzHPzOHjRpQGG1B0B8k
	 nn5Jmd8IxW3BhKtJQUSXx/YNYEZVj6eYpbutYbHnFIoEImSTZejbs2amCQM0+nlr71
	 L1MxooAh3o3g/sGwX4ONYXHiqpysjm4P2HZ7o/tt3CpyHSTQ3rtzCNmHxMVoQsrAls
	 3zgdYKdnNLIbrSlrsqieFvEbnj81xd3gOtI0GLc0GV92gyVjECNoQBQeWGNCA8kMCI
	 0LsjhRO3fgTgr/xfHgcQ4fASYVAOdRJ8zEtVO/PvfoYfqjXeIJ16HgtURboUMq2lGZ
	 ZfHKDcLs8VkIw==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 09 Jun 2026 21:09:00 +0200
Subject: [PATCH v2 81/83] block: rnull: add `virt_boundary` option
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-rnull-v6-19-rc5-send-v2-81-82c7404542e2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4411; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=mQLcR4pADqmwISKMJS96CwmsvxCUmL6qoCmsZgQdi8k=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqKGT9ToLPR7x5aepZTCfCm4HkjbgUTRQRr8bi+
 tSPr1Q92iOJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaihk/QAKCRD6UCkIqsW9
 0Aj8EAC2EoIkwX9KZomazlQrN/N8C7wXO55qgCiGfevd0Arj+x9lodAq2aTUUrDM01s/qoJZ2q1
 LvRpFf+WmwsdVW7UFlwZgCfaiUBQdMT94rxnN0WMm8GVVE9DMC3ma4u/SVC8GLNgpzSU9UQ2gcw
 aZHwZTzw5/e80I9Qvin84j+ml5alD3PfvBvSkknSX3jgwp5XRcCva7H7XFUs68rvu+yV4p/cc6b
 Hg8LxEPI+7/ZdrOBLtEJ9pn5HhJqp6wZ5T5eMvnurirWHXzwBm4tEtsQNUsN1kUIM236MIR4rcf
 HeJ1LqEecW1kzwAUFEcz3z230Vuud6OmaaU6fkwqbDg3TkrPPfHbsO2gm92OzbvMv1l5u5V8PRt
 gMtAfjC+RS4XtVmilxUn6adKKG88lqpHr9K5pvPpBAPQkUAZnumxDvtiW1+KBeVP/Tx64vBGa/j
 sacJzs2KDVCTn/7sXKDoFunqaH0m34aby1033yoKawIwnK33+FGLHeFSU7UG78KubP2CyDWEu60
 E/gt2qz4kn34tHBwPT6rVfUDomeePgXkKN9mqA62vZn5lmRHagfDZdnZxJHxd/CjXtl4q28PilY
 kfMdnyG5t5tf1lnoCf4rEq/0osNjf1KQBD9CXKMHFEJvIjbMq9Dda/UhHEg+rYAZZHW8R/uPmMu
 6v6OG2Elg7F5Y4g==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Queue-Id: 2031B40013
X-Rspam-User: 
X-Stat-Signature: w3pbfb6xpfazi7carssrxpsigrbbzzb7
X-Rspamd-Server: rspam08
X-HE-Tag: 1781032653-685986
X-HE-Meta: U2FsdGVkX1+Aggdpk8OBz9PjiPzHhwo9fYrcrTJQ3q4HwM4xuLwqjBr938ZZfr1AwOdgfrc/EyG7qmIIEJgK+6wunftUPya5Sg9aaWeQtXyte9ERchNdnlCTC317Lfi0gtR6dCPRTEoMqMb2HatYLPY3zR0/jfPasNt1o+B8IawNS6V264cgZ1RQG+umcEKnkoUaAMh6KEdYhM6U6CUn9vaEWxrWVXtzD3xUZsPoQi+xkuHHypppd8PNz7ecojD+MkBu/0Z9UuBmGK2C0gMUoBIVu5KgSz/tfUs0WGqL02OXesXwY0OQdx/2QJqY1YdOYSl+ClibEc+IyQTgUqZS0zEtvu2PAKcOG1DU/peDVsGAtOwosYXH31wyzP5AG0FU0B90Fq95Qlat+Vw+pBcV8vwQ10wgDwsj3zA5KEM4HkwkkLoT+t1jPYCIqBlArFwsYZcF3kSDIaijMFJu4OEU40r79jORUFO+cZMh1qbdwJBqMjoLz+wcwc9gLnCFC5fiNIoL5DpeyF8XCLTLgDRlbCBjxyMhpHhZ5uzOSAHrBuc0m0NDzKUtNzeTyWADMzE6YFphNYF/+SxtR0twI9uXy902Ub9rlKk//Hx/BmAQ7KP6PhIxBQuK0U9k3U8Mgi6uW6xffIe7vOMN47x35l3zG1DGR3MSHCw5VoO9p+Z0FfUS8KaDgLaUHXxRpPMEQT9kh9FIFwLhOBobjGO1eQNkn6iPTNt2mL0lCULWTvL8Ky+wDZgSkdOec9eFG+Rfhu04cn1ZE/OA4VGwn3evd8TDHIyfif36bF//Rr+EMdQButk5tcS3leJ9C18QPA/BfZuiaXcb1un13JsP1001P/2Vi2O/V3RSfVLDlGHSlAczRXfP+fQCNHDfDC0Srb8uPK+cMhJDWCAZe3I9FmfMXP/2T3f48S4zVMQbx05HyvT5CpzVpIpcnsdkqMYf3T1i3F3lCoATAFDN+26NRUqfAdt
 W+O/BZXa
 /pLIzSIA1WSMcdAjGLZIIpWp+J8arEY8JlrQNmT644EdxD2iwW8wLdDOAJtgH2gDzevYpZiX4wpvMgZSnSNcB2xIqovQ8lEBzzxYmA7wP7zXgDp2ZiwbAYlSImX4xvel0HfDu4pVfPUzHH7ZTiyrmG3YP+7bbcw//1glJiagUmeu71aX7c5hI9QqAHvjWq1SKFuDh8efxy4FV9a9/xSUueEyiyW+tEpXbFvlNVbtMZbrid5O/ufLlTjDLDaO7rMcpKcqV4i8fJKymiMfJJEUgumSbEZRZWcM+u1sFls3EknPLXE13bDBuuX8v6TlO0tVlgdRfWGidc18niY/maQ8NcXs+uo1XG4YvAU78Dtp8+Vb4dB6Z7jMVfCtX9A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a configfs attribute to configure the virtual memory boundary mask
for the rnull block device. This allows testing how drivers and
filesystems handle devices with specific alignment requirements.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 drivers/block/rnull/configfs.rs |  5 +++++
 drivers/block/rnull/rnull.rs    | 17 ++++++++++++++++-
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/block/rnull/configfs.rs b/drivers/block/rnull/configfs.rs
index 5ab217e43e2b..3e054339226c 100644
--- a/drivers/block/rnull/configfs.rs
+++ b/drivers/block/rnull/configfs.rs
@@ -133,6 +133,7 @@ fn make_group(
                 poll_queues: 27,
                 fua: 28,
                 max_sectors: 29,
+                virt_boundary: 30,
             ],
         };
 
@@ -221,6 +222,7 @@ fn make_group(
                     #[cfg(CONFIG_BLK_DEV_RUST_NULL_FAULT_INJECTION)]
                     init_hctx_inject,
                     max_sectors: 0,
+                    virt_boundary: false,
                 }),
             }),
             default_groups,
@@ -315,6 +317,7 @@ struct DeviceConfigInner {
     #[cfg(CONFIG_BLK_DEV_RUST_NULL_FAULT_INJECTION)]
     init_hctx_inject: Arc<FaultConfig>,
     max_sectors: u32,
+    virt_boundary: bool,
 }
 
 #[vtable]
@@ -388,6 +391,7 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
                 #[cfg(CONFIG_BLK_DEV_RUST_NULL_FAULT_INJECTION)]
                 timeout_inject: guard.timeout_inject.clone(),
                 max_sectors: guard.max_sectors,
+                virt_boundary: guard.virt_boundary,
             })?);
             guard.powered = true;
         } else if guard.powered && !power_op {
@@ -617,3 +621,4 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
 }
 configfs_simple_bool_field!(DeviceConfig, 28, fua);
 configfs_simple_field!(DeviceConfig, 29, max_sectors, u32);
+configfs_simple_bool_field!(DeviceConfig, 30, virt_boundary);
diff --git a/drivers/block/rnull/rnull.rs b/drivers/block/rnull/rnull.rs
index 15b8c365b9fa..147dc8498c3a 100644
--- a/drivers/block/rnull/rnull.rs
+++ b/drivers/block/rnull/rnull.rs
@@ -28,7 +28,10 @@
             BadBlocks, //
         },
         bio::Segment,
-        error::{BlkError, BlkResult},
+        error::{
+            BlkError,
+            BlkResult, //
+        },
         mq::{
             self,
             gen_disk::{
@@ -54,6 +57,7 @@
     memalloc_scope,
     new_mutex,
     new_spinlock,
+    page::PAGE_SIZE,
     pr_info,
     prelude::*,
     revocable::Revocable,
@@ -208,6 +212,10 @@
             default: 0,
             description: "Maximum size of a command (in 512B sectors)",
         },
+        virt_boundary: bool {
+            default: false,
+            description: "Set alignment requirement for IO buffers to be page size.",
+        },
     },
 }
 
@@ -312,6 +320,7 @@ fn init(_module: &'static ThisModule) -> impl PinInit<Self, Error> {
                     #[cfg(CONFIG_BLK_DEV_RUST_NULL_FAULT_INJECTION)]
                     timeout_inject: Arc::pin_init(FaultConfig::new(c"timeout_inject"), GFP_KERNEL)?,
                     max_sectors: module_parameters::max_sectors.value(),
+                    virt_boundary: module_parameters::virt_boundary.value(),
                 })?;
                 disks.push(disk, GFP_KERNEL)?;
             }
@@ -358,6 +367,7 @@ struct NullBlkOptions<'a> {
     #[cfg(CONFIG_BLK_DEV_RUST_NULL_FAULT_INJECTION)]
     timeout_inject: Arc<FaultConfig>,
     max_sectors: u32,
+    virt_boundary: bool,
 }
 
 #[pin_data]
@@ -494,6 +504,7 @@ fn new(options: NullBlkOptions<'_>) -> Result<Arc<GenDisk<Self>>> {
             #[cfg(CONFIG_BLK_DEV_RUST_NULL_FAULT_INJECTION)]
             timeout_inject,
             max_sectors,
+            virt_boundary,
         } = options;
 
         let memory_backed = tag_set.memory_backed;
@@ -558,6 +569,10 @@ fn new(options: NullBlkOptions<'_>) -> Result<Arc<GenDisk<Self>>> {
             .forced_unit_access(forced_unit_access && storage.cache_enabled())
             .max_sectors(max_sectors);
 
+        if virt_boundary {
+            builder = builder.virt_boundary_mask(PAGE_SIZE - 1);
+        }
+
         #[cfg(CONFIG_BLK_DEV_ZONED)]
         {
             builder = builder

-- 
2.51.2



