Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFAF3CD8CB2
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:17:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 252EC6B0128; Tue,  9 Jun 2026 15:17:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22A166B012A; Tue,  9 Jun 2026 15:17:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1196E6B012B; Tue,  9 Jun 2026 15:17:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 01BCD6B0128
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:17:41 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BC9538F951
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:17:41 +0000 (UTC)
X-FDA: 84861333522.25.089959E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id EE9E214000C
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:17:39 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Yh4qFHgw;
	spf=pass (imf09.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781032660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F3cUw+ZLEEIEYCWFefqNhKQoFd9lfmv4Djxg5dSyh6Y=;
	b=LWRG2Zyy6VyR0akWkdB2RcX7zmLoUYPxG7gR9OqtemC5TalZKRo0G0WuXf5DH1Vm1JqB7f
	qq4rKOyOOnqIehTVqrNH69WNcIQFx3xG/6/tgmme77g/ikllIqKSKDHcAGnhmA1nHY3j+9
	exJARu5JQ6xUZsQy9qhMI8ZKd3cAVqw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Yh4qFHgw;
	spf=pass (imf09.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781032660;
	b=eNhJ3KrdfZW1BGuuSPv2uaJWdxCZDxfWZfJuNy2xQHvHFWGleHvUel5ZG2YUYX+oEfkOcU
	sa9d8kX6GUPnOXQ1Y2eweTRdlIRSvpAuhgFdGYuSUokBu8Il4FHNH//96Iu26LSAahYPjF
	nhkoD/sfN4UHQEIUBX/jgEB2bbYxuls=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 42C1640B3A;
	Tue,  9 Jun 2026 19:17:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06B2B1F00898;
	Tue,  9 Jun 2026 19:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781032659;
	bh=F3cUw+ZLEEIEYCWFefqNhKQoFd9lfmv4Djxg5dSyh6Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Yh4qFHgwl9dPDE+Dd804+hehfek3T3KktZ4KLW8E0ND8oPBDHwHPhZK4oxN4Jt9cG
	 EE0iARjt5TMMkCAoYKrdklnyXyi+i7wv319+qcsz6IBM0GK99bDE5MzRYlBgv1ZmO1
	 j1YuADV5qkveEai4nkTjSJI6iL0kWqkODtqVr6bj6SaJ5OgO6XjFXWcs6IohWfvxLU
	 ZGgYe2DY+DClniqoBYYOtq/3PZc7lpl6YRqYN7x2SQCCr3MdD8lyK9N5SABAnhEWVT
	 zKebynE+sZt7YwTmDKGLRm8D6GCuWXU+uqH+p6zleDLieCbFam4bWKcqtcX7DryVTn
	 YZ22OhmrgDUcQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 09 Jun 2026 21:08:29 +0200
Subject: [PATCH v2 50/83] block: rust: move gendisk vtable construction to
 separate function
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-rnull-v6-19-rc5-send-v2-50-82c7404542e2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5125; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=nWZZSuCE7eRuBTdr1Tw1jnn7BhOeTAryxo5+j0nH9IQ=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqKGThwYPLrFFscsf6EbG3+a5iaTayyAq94Nxgz
 iFI6puKAgmJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaihk4QAKCRD6UCkIqsW9
 0J3GD/9P/NG4qDSfiZLT6kaSKJVYbPTGQp/wYmerkXDHyXttYDguhsRf0Qbec3e33McsoMnGXdn
 FDVdkp9zxo2TQ9yg/KTko4Kfk/r8uOuKf8LQF1kLfAS7vV5Y5h0WHp/lN3VsGTMD0Oh1TQbr3+t
 mnOhDCph7RJk/hDPa+AQBTo+q6GWMOuATQ9WMJCDb2vmPNVP2y/kyfZTA5Y2RgjJqlGyrA4vkkI
 ibGl+WdC6oa+1nv9sGtlNBDUb76uMcDz8gwvNRtQTDW86JB+Dv5KrdWr/lPgAxgbB+ivkG1iAVl
 wnnitGsYMBoqLT8x53Cgd72es41XV/ZIxXrjHOOvvLrs14Iw3HFDrHQjP/qTdjoAkRfOydVsYT+
 XpiV4YZSkQbdfPIyraHZBqaWmWgb7CvprxvkSNSLJv0WheMyLt0kTBijoO26x7ogyYEEDNrh6Lz
 ZeICGdPddeacasO0sobyJl/FZ4AGx4OdqsBW586ctFoIwwQHQj0SgQKIlvI2IGMxME5pryXnvtT
 np0gGKYMTz63Nqy2l0eOyWgzxyPGL2b/5g6dKZJ2T56cWODWW/Gxnq9bBnVZH2i9JLWm1eB3uM9
 kZusZVyLHqvdEjAJRF5qvdnu67LxpdjEDeb+P8xy2g3S1+b+hYG8TGJ1bogFAC3hn2/3P4kwyMj
 0EgP1DUWmyYA8zg==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: EE9E214000C
X-Stat-Signature: uz1ipaptw3up8qutysdgrmybn95ofjn1
X-Rspam-User: 
X-HE-Tag: 1781032659-105527
X-HE-Meta: U2FsdGVkX19AnxFI2ReFlBxnaxwRokgPkiyccQipnY+4VbzAafelM4wfggvUUvX9FljUeLTED1qCaSHkiln7e5GIBWtXg1gWTwoitSqQR5oOTT1wQFOWsOgnvb7L53Ed2VBOyB+/wR/kalsrXlPBFcg/Rm2d/8h9KgGdHho4LQ4ZIktKi8PkG0+HE0e5JrfnrIQziqgn2hFaUT8B8TD1XdBTxDritKaOIxF11BJ4hC3AagjdaCO9qS54hQ+BpDgDpgShzP2bZz1wFmvSG8XgAv5Yqp2UFJQ4c5AIyozBy18ymNez8aNIjEG17m9eRucgRWk5ft6r5a4vKAPvfucm0LmWzp/Y6+eiLJBH5K5cEFxQTAXL+rE0JAfLuqIgS+0ntGXSYxAiYDxvMz56GMQFKd+8x0x8Al0h7eSYzs8YPpmfI2Li7j7sy53mUot9e398GfmYb/YDD2B+60fCfVRtm5JSXpA2/4RVza1OFOZYaH0mOUBbKUp+XM5MLNslOS14H7Kl7BGxG0ZOxP033GNATZVOO/w5pwnDTI8694QrE31bhvqNMx+hC5MnrZpKmTjZtMDExelPLUwUW+eb3k52gwv0pUv/oYLNNqPr3hQ+UNOz5F3AKG/w/HIE3/PoIg2BSD3lDBJEaFA2zoFcoZwcTMMZxbCaP5FEk5dHzaKS3CMap4+4nHlQLDr7994NBx/vPAtQWOdGpkosQt0688p2MMw/YXjIYS7ZAV9Kwl6oWWXt3O2ke+EoBcyboY9kajL9vNTpJb7m/2CJDfZU8VC4K2G1imcLv8smef71AkPhTNE1Qf2T0tBe2AxfLrLfL1gjpVzhl2xWd8gjBCu4SjqeWbGkp0L4X6VsvEPU//cso9bgx6t6EQWCLPDnyK1pH+9NZhpB+W+/gqt0yUejvEAni4bCbVpvj+SRpjGQGuaUkZrGIuhpK6gEYlSUVvgYDkHoqEODed2l+RNLk0ASspJ
 faoauJ4J
 /3NrSamOqRMbgbf0eTd5oxlOnTP5n9qRWiS7WI4Acs6kTmqOTTd+mP8IAwta1G/bVrsul1Z0ri4KTfs+QXelyFvczzYuvU7tdLzWuuRIJkq4ZDswzuHakTe0XxI8glPnsCClAu2a4ueU9gqZmgigrLMXLHoZZUG2zbJ0cVRAuZoaJ4j5ktiAA8+QhAaCx8+AO2LCw7HeqTtxBeu687EJ6+BJ0puCp0fiEQfPqo+nMyxoj9Pb1YZnO+RCcG6UCO1By3Ie9q05ZBI0aXUTsiKlecbQi0dSwuobDxTjtQKSNJF7oRHu8+/AgtwZdI8RcG9POmg/mg8FftCFpUsoT63/AmkjDag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Refactor the `GenDiskBuilder::build` method to move the `gendisk`
vtable construction into a separate helper function. This prepares for
adding zoned block device support which requires conditional vtable
setup.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 drivers/block/rnull/configfs.rs  |  5 ++-
 rust/kernel/block/mq/gen_disk.rs | 67 +++++++++++++++++++++++-----------------
 2 files changed, 43 insertions(+), 29 deletions(-)

diff --git a/drivers/block/rnull/configfs.rs b/drivers/block/rnull/configfs.rs
index 2dfc87dff66a..8fa16dbc2a75 100644
--- a/drivers/block/rnull/configfs.rs
+++ b/drivers/block/rnull/configfs.rs
@@ -290,7 +290,10 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
     }
 }
 
-configfs_simple_field!(DeviceConfig, 1, block_size, u32, check GenDiskBuilder::validate_block_size);
+configfs_simple_field!(DeviceConfig, 1,
+                       block_size, u32,
+                       check GenDiskBuilder::<NullBlkDevice>::validate_block_size
+);
 configfs_simple_bool_field!(DeviceConfig, 2, rotational);
 configfs_simple_field!(DeviceConfig, 3, capacity_mib, u64);
 configfs_simple_field!(DeviceConfig, 4, irq_mode, IRQMode);
diff --git a/rust/kernel/block/mq/gen_disk.rs b/rust/kernel/block/mq/gen_disk.rs
index 49ce5ac4774d..79a67b545eca 100644
--- a/rust/kernel/block/mq/gen_disk.rs
+++ b/rust/kernel/block/mq/gen_disk.rs
@@ -34,20 +34,24 @@
         ScopeGuard, //
     },
 };
-use core::ptr::NonNull;
+use core::{
+    marker::PhantomData,
+    ptr::NonNull, //
+};
 
 /// A builder for [`GenDisk`].
 ///
 /// Use this struct to configure and add new [`GenDisk`] to the VFS.
-pub struct GenDiskBuilder {
+pub struct GenDiskBuilder<T> {
     rotational: bool,
     logical_block_size: u32,
     physical_block_size: u32,
     capacity_sectors: u64,
     max_hw_discard_sectors: u32,
+    _p: PhantomData<T>,
 }
 
-impl Default for GenDiskBuilder {
+impl<T> Default for GenDiskBuilder<T> {
     fn default() -> Self {
         Self {
             rotational: false,
@@ -55,11 +59,12 @@ fn default() -> Self {
             physical_block_size: bindings::PAGE_SIZE as u32,
             capacity_sectors: 0,
             max_hw_discard_sectors: 0,
+            _p: PhantomData,
         }
     }
 }
 
-impl GenDiskBuilder {
+impl<T: Operations> GenDiskBuilder<T> {
     /// Create a new instance.
     pub fn new() -> Self {
         Self::default()
@@ -126,7 +131,7 @@ pub fn max_hw_discard_sectors(mut self, max_hw_discard_sectors: u32) -> Self {
     }
 
     /// Build a new `GenDisk` and add it to the VFS.
-    pub fn build<T: Operations>(
+    pub fn build(
         self,
         name: fmt::Arguments<'_>,
         tagset: Arc<TagSet<T>>,
@@ -157,30 +162,8 @@ pub fn build<T: Operations>(
             )
         })?;
 
-        const TABLE: bindings::block_device_operations = bindings::block_device_operations {
-            submit_bio: None,
-            open: None,
-            release: None,
-            ioctl: None,
-            compat_ioctl: None,
-            check_events: None,
-            unlock_native_capacity: None,
-            getgeo: None,
-            set_read_only: None,
-            swap_slot_free_notify: None,
-            report_zones: None,
-            devnode: None,
-            alternative_gpt_sector: None,
-            get_unique_id: None,
-            // TODO: Set to `THIS_MODULE`.
-            owner: core::ptr::null_mut(),
-            pr_ops: core::ptr::null_mut(),
-            free_disk: None,
-            poll_bio: None,
-        };
-
         // SAFETY: `gendisk` is a valid pointer as we initialized it above
-        unsafe { (*gendisk).fops = &TABLE };
+        unsafe { (*gendisk).fops = Self::build_vtable() };
 
         let mut writer = NullTerminatedFormatter::new(
             // SAFETY: `gendisk` points to a valid and initialized instance. We
@@ -233,6 +216,34 @@ pub fn build<T: Operations>(
 
         Ok(disk.into())
     }
+
+    const VTABLE: bindings::block_device_operations = bindings::block_device_operations {
+        submit_bio: None,
+        open: None,
+        release: None,
+        ioctl: None,
+        compat_ioctl: None,
+        check_events: None,
+        unlock_native_capacity: None,
+        getgeo: None,
+        set_read_only: None,
+        swap_slot_free_notify: None,
+        report_zones: None,
+        devnode: None,
+        alternative_gpt_sector: None,
+        get_unique_id: None,
+        // TODO: Set to THIS_MODULE. Waiting for const_refs_to_static feature to
+        // be merged (unstable in rustc 1.78 which is staged for linux 6.10)
+        // <https://github.com/rust-lang/rust/issues/119618>
+        owner: core::ptr::null_mut(),
+        pr_ops: core::ptr::null_mut(),
+        free_disk: None,
+        poll_bio: None,
+    };
+
+    pub(crate) const fn build_vtable() -> &'static bindings::block_device_operations {
+        &Self::VTABLE
+    }
 }
 
 /// A generic block device.

-- 
2.51.2



