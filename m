Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9DA8CD8CB2
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:18:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16CA66B0132; Tue,  9 Jun 2026 15:18:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11A556B0134; Tue,  9 Jun 2026 15:18:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0080F6B0135; Tue,  9 Jun 2026 15:18:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E04056B0132
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:18:11 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A066740739
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:18:11 +0000 (UTC)
X-FDA: 84861334782.09.01C110B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id D3D87140015
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:18:09 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XBBv6Gp6;
	spf=pass (imf09.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781032689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YHB1zFLDwKHODEh3lmkWrJX5tEeRvBklzvizAuQ1Beo=;
	b=CYUCRa0be463FFKpzTnyuGj08EXEqRZOaqoEJrgFi3ZQ2F9O8ko6g3ujArJ9b6qepKmnlz
	ja13YbBz6n4UFLuiC+pTQGLlZtFnj3Tovtj3KWciuGdq1dFkWZt+L1QU8dH10GEQmn6fwC
	4w1su4+gwSfTZUqV2ux1BslBkpwuoqs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781032689;
	b=VLDFPF9StkvNBsU0TuoaDnhZtmGnEuNqYNwFkmF6KGL+wYZK8w8eb72msQpP72nCDcVDzs
	LXJQytjRz/WdvXzO/cTQnaapvsziJlW7boyigMIviEoJWwG16S9dPtC3VAmoHOvUynogpo
	Y80tyPJGavHVjqz5MH9UnggkfN+UwAo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XBBv6Gp6;
	spf=pass (imf09.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 456D5602D1;
	Tue,  9 Jun 2026 19:18:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A42BC1F008A0;
	Tue,  9 Jun 2026 19:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781032689;
	bh=YHB1zFLDwKHODEh3lmkWrJX5tEeRvBklzvizAuQ1Beo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=XBBv6Gp6EE0ANqOYfEXJeDfeuyrNi+ULc25y6fgn4C9ijf8pm6e1CYO/Z9MwYJCfG
	 ixC0ZRyL+ecQJyernoxXCIpNg+N1Z49wweTc3HrpHfEkU2fz1+BXBOTm0OBBQ0keim
	 o5CIklivVsfmSo2vi22L71JRmOj9zYNFw9de55uTMT6qmAZJ52ECP5f1ReZU+AljdM
	 anQjfj7x8GcBv82CKcF8ix6SBEiyJ3ixVrGUAnEvgbBDSsp+C4YrTyXQd4pf3xhpfw
	 o8IL3h9ZO1EKlhUymYPMikPEV6SSpm3dnheJWI0QGFYMXCfl93QXwvAGUXgnZFLiB5
	 OU4X1Y+beTYww==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 09 Jun 2026 21:08:14 +0200
Subject: [PATCH v2 35/83] block: rnull: add volatile cache emulation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-rnull-v6-19-rc5-send-v2-35-82c7404542e2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=34846;
 i=a.hindborg@kernel.org; h=from:subject:message-id;
 bh=3yz+SrCPHbaB54NgYDQ68+N5dlDgZu/1MA+s5KWPMjo=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqKGTUSa7JTIavrDEXTxMV9StFT4OhxfwAhN6gu
 wUW7m0J+VmJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaihk1AAKCRD6UCkIqsW9
 0PUGEACQf/36sFXSAcij3iel+EYCrcpIK3gqtkL6wH7YF09YEtA0f4dlkgFAJzXhbn23J3fMF8G
 t2jgeY8qavkatzqc2za4m/Gt+5RytuAvjIsFc1cgUefcci+KP2YaphXwQghg5/Bf1pLatm7rsfr
 55xmSllPFFzl4gu2kH/e1brv/PG0nD2zB/Mn7LEPB9igho6Si5sbZCPDEj55Jrwu1eAlfmK7XZP
 x2KmlobMvpHmJ6IlOr1hFytmkN9V+mjMMBfrPLW+QForcZfyzv6fZ1caa28EUOkAnN6IaJz32QJ
 3wLDVnI0BIolAHaV2oPLvK8BhP0gUZhPjt9jJ4n7F3L35KGgTN+eA5PZyqvjzqK/pU0OA/KqR/W
 B8a6tuuasu3mB6o9Ah5Z55VhvjS5Wh8wOEePt9h+cHJS57s/VyhX/hk4A8TQk/z+lzuF40csLyl
 cOA9QaVkMqdYizoyznw4TcruVhokUs9L8AQsVEu+1WYoRzt7gSCqObxqFmQTjsuVLasSBJu+oCM
 NAANyu73GHAVSrmYxWXMs/QwMJEsa0Wk2FjP0brO+tv419ctdb40q9uTIa7QjYr4A4ju0j1+Gxn
 NH5zEFCJj33q/kEY8Ofsq5gp+1SIEa11gvlRkfyf9Rbxibt0EIPahblv4lfxFg1NarGSCFF6JWS
 fZwpf8Xy1Pu1LIg==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D3D87140015
X-Stat-Signature: pyb6jmnf96rid68qkz37zdbm3tafxtuz
X-HE-Tag: 1781032689-458908
X-HE-Meta: U2FsdGVkX19kpfpXNtK3rgtgcDD9DyrusUnUXaRRWqu/0k6TLkAjvbhuChKIGz5l4mKZ/uhyCHmu3NZXDKwFGXW9o1Xu5fvKZeIer6Obsmd5b7j9T5JM+UqVLLbD2QboOnVj8uVpGEzI5dkxctQ9ttXpCqhER07kpmzN0jMdFDVQqdW0qr/xaEdinanhjlZ+TidXw4pkTU7om4YdeR+zhBxQIaTqv79Ci/SjJRj/OprMf94npPVoXxkg2iVU2vFjFTtTz1t+9hA6miPS7UiWcuQ0PEjIpSh6+EY7ZwUGCIgtJtpg9B8/5c4i0Z5/6GpIqhghbsUzD5rXEkpwlx3JQA8jAFDcoHiGAc7MJtdKP8Tqyes+M9Oncs9lXg0xtFOzod+AP8P96jvXtPybRh1NZS0GPLLwaOUY+Ma6+PAmhSZK2GI9rwQYjpRjYE2/j2UAPotj8E3YEcBLN8sDxjnSOkUZAiMRBHbBiCYUsHeQaE9ABy+gbaJo4onjYW4LjQyEbNISmgvgEJdmmHsK/N87cF21RqOJ1p3fWLkRw3X2rO38mtY3qsHDQsuQiB4ZDO/k6SYefMoEtmTkR1ZRY/U3X1FByLMS2WDP7viDRhSHZcqPJnVfNG3iG7t9/02w57JqX3s8e4mAWM099FSXp8IRMv//p+po/TUxxTZQVApB1kYKWdcCnz0aepQkaGkMRAnfq59svQjD8K0ezmsMuTjEU8qpfinLPI9UgESQC8udoyGJEkD1nlnkE0HyRJU1eABCUlVeGpB2KGsw8uKej04+BmZujyJLwqlg7qJULgJJVeTAlVF3ZmGizdQAg4kA/V9LUC+JW669U2Hutks+XcE60uBHMRyUd9sGy+QFEjBQO6LUnt/UxlVJx8qXflyEA7oaZzw5qSUHiSa1Awm9tbI/en13YpLOhk9jZ9p//aeV8MDm23FZjtSfFe6yWTkdN0ynIW6gjdqhiZ+lxAtz+U4
 6YMpX6DJ
 Y5OMNsdkR26J8SnVr/3T5OvQSYSxM/uSBMQthLdklmUjxRUo01oWdX9RukZmOHcjZ8gHs1r40wJ0UOR9SllV0hSJZYrXAKds7FFd3rwM7/FlO7p4ODxyqz6g3OCWsvGejx5N8ZE6NyQneo+jthwtg4JZOh1Wu5p7CsOgApFMxtQQLgap7nlaSNbNGwLUwFEk9WdYR3s/iEcAjiibPM/9J/8u3ydmMZlu9/2/xr27p/kEn34FV2g3JJAfqHxkEeVVcDUxLTMq9AlulJ20zwd1Rg0Bst520m7vsp2i2SYRtpQjHTCW0Sf9/9JthRGLwuu4s8xmm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add volatile cache emulation to rnull. When enabled via the
`cache_size_mib` configfs attribute, writes are first stored in a volatile
cache before being written back to the simulated non-volatile storage.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 drivers/block/rnull/configfs.rs          |  35 +++-
 drivers/block/rnull/disk_storage.rs      | 260 +++++++++++++++++++++++++
 drivers/block/rnull/disk_storage/page.rs |  77 ++++++++
 drivers/block/rnull/rnull.rs             | 314 ++++++++++++++++++-------------
 4 files changed, 545 insertions(+), 141 deletions(-)

diff --git a/drivers/block/rnull/configfs.rs b/drivers/block/rnull/configfs.rs
index 0e9fe8cdc07f..504bb477c2d0 100644
--- a/drivers/block/rnull/configfs.rs
+++ b/drivers/block/rnull/configfs.rs
@@ -1,9 +1,11 @@
 // SPDX-License-Identifier: GPL-2.0
 
 use super::{
+    DiskStorage,
     NullBlkDevice,
     THIS_MODULE, //
 };
+use core::fmt::Write;
 use kernel::{
     bindings,
     block::{
@@ -18,10 +20,7 @@
         AttributeOperations, //
     },
     configfs_attrs,
-    fmt::{
-        self,
-        Write as _, //
-    },
+    fmt,
     new_mutex,
     page::PAGE_SIZE,
     prelude::*,
@@ -104,17 +103,19 @@ fn make_group(
                 badblocks: 12,
                 badblocks_once: 13,
                 badblocks_partial_io: 14,
+                cache_size_mib: 15,
             ],
         };
 
+        let block_size = 4096;
         Ok(configfs::Group::new(
             name.try_into()?,
             item_type,
             // TODO: cannot coerce new_mutex!() to impl PinInit<_, Error>, so put mutex inside
-            try_pin_init!( DeviceConfig {
+            try_pin_init!(DeviceConfig {
                 data <- new_mutex!(DeviceConfigInner {
                     powered: false,
-                    block_size: 4096,
+                    block_size,
                     rotational: false,
                     disk: None,
                     capacity_mib: 4096,
@@ -129,6 +130,11 @@ fn make_group(
                     bad_blocks: Arc::pin_init(BadBlocks::new(false), GFP_KERNEL)?,
                     bad_blocks_once: false,
                     bad_blocks_partial_io: false,
+                    disk_storage: Arc::pin_init(
+                        DiskStorage::new(0, block_size as usize),
+                        GFP_KERNEL
+                    )?,
+                    cache_size_mib: 0,
                 }),
             }),
             core::iter::empty(),
@@ -201,6 +207,8 @@ struct DeviceConfigInner {
     bad_blocks: Arc<BadBlocks>,
     bad_blocks_once: bool,
     bad_blocks_partial_io: bool,
+    cache_size_mib: u64,
+    disk_storage: Arc<DiskStorage>,
 }
 
 #[vtable]
@@ -239,6 +247,7 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
                 bad_blocks: guard.bad_blocks.clone(),
                 bad_blocks_once: guard.bad_blocks_once,
                 bad_blocks_partial_io: guard.bad_blocks_partial_io,
+                storage: guard.disk_storage.clone(),
             })?);
             guard.powered = true;
         } else if guard.powered && !power_op {
@@ -250,6 +259,7 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
     }
 }
 
+// DiskStorage::new(cache_size_mib << 20, block_size as usize),
 configfs_simple_field!(DeviceConfig, 1, block_size, u32, check GenDiskBuilder::validate_block_size);
 configfs_simple_bool_field!(DeviceConfig, 2, rotational);
 configfs_simple_field!(DeviceConfig, 3, capacity_mib, u64);
@@ -394,3 +404,16 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
 
 configfs_simple_bool_field!(DeviceConfig, 13, bad_blocks_once);
 configfs_simple_bool_field!(DeviceConfig, 14, bad_blocks_partial_io);
+configfs_attribute!(DeviceConfig, 15,
+    show: |this, page| show_field(this.data.lock().cache_size_mib, page),
+    store: |this, page| store_with_power_check(this, page, |data, page| {
+        let text = core::str::from_utf8(page)?.trim();
+        let value = text.parse::<u64>().map_err(|_| EINVAL)?;
+        data.disk_storage = Arc::pin_init(
+            DiskStorage::new(value, data.block_size as usize),
+            GFP_KERNEL
+        )?;
+        data.cache_size_mib = value;
+        Ok(())
+    })
+);
diff --git a/drivers/block/rnull/disk_storage.rs b/drivers/block/rnull/disk_storage.rs
new file mode 100644
index 000000000000..b8fef411fffe
--- /dev/null
+++ b/drivers/block/rnull/disk_storage.rs
@@ -0,0 +1,260 @@
+// SPDX-License-Identifier: GPL-2.0
+
+use super::HwQueueContext;
+use core::pin::Pin;
+use kernel::{
+    block,
+    new_spinlock,
+    new_xarray,
+    page::PAGE_SIZE,
+    prelude::*,
+    sync::{
+        atomic::{ordering, Atomic},
+        SpinLock, SpinLockGuard,
+    },
+    uapi::PAGE_SECTORS,
+    xarray::{
+        self,
+        XArray,
+        XArraySheaf, //
+    }, //
+};
+pub(crate) use page::NullBlockPage;
+
+mod page;
+
+#[pin_data]
+pub(crate) struct DiskStorage {
+    // TODO: Get rid of this pointer indirection.
+    #[pin]
+    trees: SpinLock<Pin<KBox<TreeContainer>>>,
+    cache_size: u64,
+    cache_size_used: Atomic<u64>,
+    next_flush_sector: Atomic<u64>,
+    block_size: usize,
+}
+
+impl DiskStorage {
+    pub(crate) fn new(cache_size: u64, block_size: usize) -> impl PinInit<Self, Error> {
+        try_pin_init!( Self {
+            // TODO: Get rid of the box
+            // https://git.kernel.org/pub/scm/linux/kernel/git/boqun/linux.git/commit/?h=locking&id=a5d84cafb3e253a11d2e078902c5b090be2f4227
+            trees <- new_spinlock!(KBox::pin_init(TreeContainer::new(), GFP_KERNEL)?),
+            cache_size,
+            cache_size_used: Atomic::new(0),
+            next_flush_sector: Atomic::new(0),
+            block_size
+        })
+    }
+
+    pub(crate) fn access<'a, 'b, 'c>(
+        &'a self,
+        tree_guard: &'a mut SpinLockGuard<'b, Pin<KBox<TreeContainer>>>,
+        hw_data_guard: &'a mut SpinLockGuard<'b, HwQueueContext>,
+        sheaf: Option<XArraySheaf<'c>>,
+    ) -> DiskStorageAccess<'a, 'b, 'c> {
+        DiskStorageAccess::new(self, tree_guard, hw_data_guard, sheaf)
+    }
+
+    pub(crate) fn lock(&self) -> SpinLockGuard<'_, Pin<KBox<TreeContainer>>> {
+        self.trees.lock()
+    }
+}
+
+pub(crate) struct DiskStorageAccess<'a, 'b, 'c> {
+    cache_guard: xarray::Guard<'a, TreeNode>,
+    disk_guard: xarray::Guard<'a, TreeNode>,
+    hw_data_guard: &'a mut SpinLockGuard<'b, HwQueueContext>,
+    disk_storage: &'a DiskStorage,
+    pub(crate) sheaf: Option<XArraySheaf<'c>>,
+}
+
+impl<'a, 'b, 'c> DiskStorageAccess<'a, 'b, 'c> {
+    fn new(
+        disk_storage: &'a DiskStorage,
+        tree_guard: &'a mut SpinLockGuard<'b, Pin<KBox<TreeContainer>>>,
+        hw_data_guard: &'a mut SpinLockGuard<'b, HwQueueContext>,
+        sheaf: Option<XArraySheaf<'c>>,
+    ) -> Self {
+        Self {
+            cache_guard: tree_guard.cache_tree.lock(),
+            disk_guard: tree_guard.disk_tree.lock(),
+            hw_data_guard,
+            disk_storage,
+            sheaf,
+        }
+    }
+    fn to_index(sector: u64) -> usize {
+        // CAST: Device size limited during setup to (2^32)-1 on 32 bit systems.
+        (sector >> block::PAGE_SECTORS_SHIFT) as usize
+    }
+
+    fn to_sector(index: usize) -> u64 {
+        // CAST: Casting from `usize` to `u64` never overflows.
+        (index << block::PAGE_SECTORS_SHIFT) as u64
+    }
+
+    fn extract_cache_page_inner<'g>(
+        cache_guard: &mut xarray::Guard<'g, TreeNode>,
+        disk_guard: &mut xarray::Guard<'g, TreeNode>,
+        disk_storage: &DiskStorage,
+        hw_data: &mut HwQueueContext,
+        sheaf: Option<&mut XArraySheaf<'_>>,
+    ) -> Result<KBox<NullBlockPage>> {
+        let cache_entry = cache_guard
+            .find_next_entry_circular(
+                disk_storage.next_flush_sector.load(ordering::Relaxed) as usize
+            )
+            .expect("Expected to find a page in the cache");
+
+        let index = cache_entry.index();
+
+        disk_storage
+            .next_flush_sector
+            .store(Self::to_sector(index).wrapping_add(1), ordering::Relaxed);
+
+        disk_storage.cache_size_used.store(
+            disk_storage.cache_size_used.load(ordering::Relaxed) - PAGE_SIZE as u64,
+            ordering::Relaxed,
+        );
+
+        let page = match disk_guard.entry(index) {
+            xarray::Entry::Vacant(disk_entry) => {
+                disk_entry
+                    .insert(cache_entry.remove(), sheaf)
+                    .expect("Preload is set up to allow insert without failure");
+                hw_data.page.take().expect("Preload has allocated for us")
+            }
+            xarray::Entry::Occupied(mut disk_entry) => {
+                let mut page = if cache_entry.is_full() {
+                    disk_entry.insert(cache_entry.remove())
+                } else {
+                    let mut src = cache_entry;
+                    let mut offset = 0;
+                    for _ in 0..PAGE_SECTORS {
+                        src.page_mut().as_pin_mut().copy_to_page(
+                            disk_entry.page_mut().as_pin_mut(),
+                            offset,
+                            block::SECTOR_SIZE as usize,
+                        )?;
+                        offset += block::SECTOR_SIZE as usize;
+                    }
+                    src.remove()
+                };
+                page.reset();
+                page
+            }
+        };
+
+        Ok(page)
+    }
+
+    fn get_cache_page(&mut self, sector: u64) -> Result<&mut NullBlockPage> {
+        let index = Self::to_index(sector);
+
+        match self.cache_guard.entry(index) {
+            xarray::Entry::Occupied(occupied_entry) => Ok(occupied_entry.into_mut()),
+            xarray::Entry::Vacant(vacant_entry) => {
+                let cache_guard = vacant_entry.into_guard();
+                let page = if self.disk_storage.cache_size_used.load(ordering::Relaxed)
+                    < self.disk_storage.cache_size
+                {
+                    self.hw_data_guard
+                        .page
+                        .take()
+                        .expect("Expected to have a page available")
+                } else {
+                    Self::extract_cache_page_inner(
+                        cache_guard,
+                        &mut self.disk_guard,
+                        self.disk_storage,
+                        self.hw_data_guard,
+                        self.sheaf.as_mut(),
+                    )?
+                };
+                let xarray::Entry::Vacant(vacant_entry) = cache_guard.entry(index) else {
+                    unreachable!("slot was vacant and we hold the lock")
+                };
+                Ok(vacant_entry
+                    .insert(page, self.sheaf.as_mut())
+                    .expect("Should be able to insert"))
+            }
+        }
+    }
+
+    fn get_disk_page(&mut self, sector: u64) -> Result<&mut NullBlockPage> {
+        let index = Self::to_index(sector);
+
+        let page = match self.disk_guard.entry(index) {
+            xarray::Entry::Vacant(e) => e.insert(
+                self.hw_data_guard
+                    .page
+                    .take()
+                    .expect("Expected page to be available"),
+                self.sheaf.as_mut(),
+            )?,
+            xarray::Entry::Occupied(e) => e.into_mut(),
+        };
+
+        Ok(page)
+    }
+
+    pub(crate) fn get_write_page(&mut self, sector: u64) -> Result<&mut NullBlockPage> {
+        let page = if self.disk_storage.cache_size > 0 {
+            self.get_cache_page(sector)?
+        } else {
+            self.get_disk_page(sector)?
+        };
+
+        Ok(page)
+    }
+
+    pub(crate) fn get_read_page(&self, sector: u64) -> Option<&NullBlockPage> {
+        let index = Self::to_index(sector);
+        if self.disk_storage.cache_size > 0 {
+            self.cache_guard
+                .get(index)
+                .or_else(|| self.disk_guard.get(index))
+        } else {
+            self.disk_guard.get(index)
+        }
+    }
+
+    fn free_sector_tree(tree_access: &mut xarray::Guard<'_, TreeNode>, sector: u64) {
+        let index = Self::to_index(sector);
+        if let Some(page) = tree_access.get_mut(index) {
+            page.set_free(sector);
+
+            if page.is_empty() {
+                tree_access.remove(index);
+            }
+        }
+    }
+
+    pub(crate) fn free_sector(&mut self, sector: u64) {
+        if self.disk_storage.cache_size > 0 {
+            Self::free_sector_tree(&mut self.cache_guard, sector);
+        }
+
+        Self::free_sector_tree(&mut self.disk_guard, sector);
+    }
+}
+
+type TreeNode = KBox<NullBlockPage>;
+
+#[pin_data]
+pub(crate) struct TreeContainer {
+    #[pin]
+    disk_tree: XArray<TreeNode>,
+    #[pin]
+    cache_tree: XArray<TreeNode>,
+}
+
+impl TreeContainer {
+    fn new() -> impl PinInit<Self> {
+        pin_init!(TreeContainer {
+            disk_tree <- new_xarray!(xarray::AllocKind::Alloc),
+            cache_tree <- new_xarray!(xarray::AllocKind::Alloc),
+        })
+    }
+}
diff --git a/drivers/block/rnull/disk_storage/page.rs b/drivers/block/rnull/disk_storage/page.rs
new file mode 100644
index 000000000000..bc78973ad5d4
--- /dev/null
+++ b/drivers/block/rnull/disk_storage/page.rs
@@ -0,0 +1,77 @@
+// SPDX-License-Identifier: GPL-2.0
+
+use kernel::{
+    block::{
+        PAGE_SECTOR_MASK,
+        SECTOR_SHIFT, //
+    },
+    memalloc_scope,
+    page::{
+        SafePage,
+        PAGE_SIZE, //
+    },
+    prelude::*,
+    types::Owned,
+    uapi::PAGE_SECTORS, //
+};
+
+static_assert!((PAGE_SIZE >> SECTOR_SHIFT) <= 64);
+
+pub(crate) struct NullBlockPage {
+    page: Owned<SafePage>,
+    status: u64,
+    block_size: usize,
+}
+
+impl NullBlockPage {
+    pub(crate) fn new(block_size: usize) -> Result<KBox<Self>> {
+        memalloc_scope!(let _noio: NoIo);
+        Ok(KBox::new(
+            Self {
+                page: SafePage::alloc_page(__GFP_ZERO)?,
+                status: 0,
+                block_size,
+            },
+            GFP_KERNEL,
+        )?)
+    }
+
+    pub(crate) fn set_occupied(&mut self, sector: u64) {
+        let idx = sector & u64::from(PAGE_SECTOR_MASK);
+        self.status |= 1 << idx;
+    }
+
+    pub(crate) fn set_free(&mut self, sector: u64) {
+        let idx = sector & u64::from(PAGE_SECTOR_MASK);
+        self.status &= !(1 << idx);
+    }
+
+    pub(crate) fn is_empty(&self) -> bool {
+        self.status == 0
+    }
+
+    pub(crate) fn reset(&mut self) {
+        self.status = 0;
+    }
+
+    pub(crate) fn is_full(&self) -> bool {
+        let blocks_per_page = PAGE_SIZE >> self.block_size.trailing_zeros();
+        let shift = PAGE_SECTORS as usize / blocks_per_page;
+
+        for i in 0..blocks_per_page {
+            if self.status & (1 << (i * shift)) == 0 {
+                return false;
+            }
+        }
+
+        true
+    }
+
+    pub(crate) fn page_mut(&mut self) -> &mut Owned<SafePage> {
+        &mut self.page
+    }
+
+    pub(crate) fn page(&self) -> &Owned<SafePage> {
+        &self.page
+    }
+}
diff --git a/drivers/block/rnull/rnull.rs b/drivers/block/rnull/rnull.rs
index 0c1bc2f5ae9c..877683dba0ac 100644
--- a/drivers/block/rnull/rnull.rs
+++ b/drivers/block/rnull/rnull.rs
@@ -3,13 +3,22 @@
 //! This is a Rust implementation of the C null block driver.
 
 mod configfs;
+mod disk_storage;
 
 use configfs::IRQMode;
+use disk_storage::{
+    DiskStorage,
+    NullBlockPage,
+    TreeContainer, //
+};
 use kernel::{
     bindings,
     block::{
         self,
-        badblocks::{self, BadBlocks},
+        badblocks::{
+            self,
+            BadBlocks, //
+        },
         bio::Segment,
         mq::{
             self,
@@ -20,7 +29,7 @@
             Operations,
             TagSet, //
         },
-        PAGE_SECTOR_MASK, SECTOR_SHIFT,
+        SECTOR_SHIFT,
     },
     error::{
         code,
@@ -29,11 +38,7 @@
     ffi,
     memalloc_scope,
     new_mutex,
-    new_xarray,
-    page::{
-        SafePage,
-        PAGE_SIZE, //
-    },
+    new_spinlock,
     pr_info,
     prelude::*,
     str::CString,
@@ -42,9 +47,11 @@
         atomic::{
             ordering,
             Atomic, //
-        },
+        }, //
         Arc,
-        Mutex, //
+        Mutex,
+        SpinLock,
+        SpinLockGuard,
     },
     time::{
         hrtimer::{
@@ -59,7 +66,7 @@
         OwnableRefCounted,
         Owned, //
     },
-    xarray::XArray, //
+    xarray::XArraySheaf, //
 };
 
 module! {
@@ -146,9 +153,11 @@ fn init(_module: &'static ThisModule) -> impl PinInit<Self, Error> {
                 } else {
                     module_parameters::submit_queues.value()
                 };
+
+                let block_size = module_parameters::bs.value();
                 let disk = NullBlkDevice::new(NullBlkOptions {
                     name: &name,
-                    block_size: module_parameters::bs.value(),
+                    block_size,
                     rotational: module_parameters::rotational.value(),
                     capacity_mib: module_parameters::gb.value() * 1024,
                     irq_mode: module_parameters::irqmode.value().try_into()?,
@@ -161,6 +170,7 @@ fn init(_module: &'static ThisModule) -> impl PinInit<Self, Error> {
                     bad_blocks: Arc::pin_init(BadBlocks::new(false), GFP_KERNEL)?,
                     bad_blocks_once: false,
                     bad_blocks_partial_io: false,
+                    storage: Arc::pin_init(DiskStorage::new(0, block_size as usize), GFP_KERNEL)?,
                 })?;
                 disks.push(disk, GFP_KERNEL)?;
             }
@@ -190,8 +200,20 @@ struct NullBlkOptions<'a> {
     bad_blocks: Arc<BadBlocks>,
     bad_blocks_once: bool,
     bad_blocks_partial_io: bool,
+    storage: Arc<DiskStorage>,
+}
+
+#[pin_data]
+struct NullBlkDevice {
+    storage: Arc<DiskStorage>,
+    irq_mode: IRQMode,
+    completion_time: Delta,
+    memory_backed: bool,
+    block_size: usize,
+    bad_blocks: Arc<BadBlocks>,
+    bad_blocks_once: bool,
+    bad_blocks_partial_io: bool,
 }
-struct NullBlkDevice;
 
 impl NullBlkDevice {
     fn new(options: NullBlkOptions<'_>) -> Result<GenDisk<Self>> {
@@ -210,6 +232,7 @@ fn new(options: NullBlkOptions<'_>) -> Result<GenDisk<Self>> {
             bad_blocks,
             bad_blocks_once,
             bad_blocks_partial_io,
+            storage,
         } = options;
 
         let mut flags = mq::tag_set::Flags::default();
@@ -244,13 +267,13 @@ fn new(options: NullBlkOptions<'_>) -> Result<GenDisk<Self>> {
             GFP_KERNEL,
         )?;
 
-        let queue_data = Box::pin_init(
-            pin_init!(QueueData {
-                tree <- new_xarray!(kernel::xarray::AllocKind::Alloc),
+        let queue_data = Box::try_pin_init(
+            try_pin_init!(Self {
+                storage,
                 irq_mode,
                 completion_time,
                 memory_backed,
-                block_size: block_size.into(),
+                block_size: block_size as usize,
                 bad_blocks,
                 bad_blocks_once,
                 bad_blocks_partial_io,
@@ -273,22 +296,68 @@ fn new(options: NullBlkOptions<'_>) -> Result<GenDisk<Self>> {
         builder.build(fmt!("{}", name.to_str()?), tagset, queue_data)
     }
 
+    fn sheaf_size() -> usize {
+        2 * ((usize::BITS as usize / bindings::XA_CHUNK_SHIFT)
+            + if (usize::BITS as usize % bindings::XA_CHUNK_SHIFT) == 0 {
+                0
+            } else {
+                1
+            })
+    }
+
+    fn preload<'b, 'c>(
+        tree_guard: &'b mut SpinLockGuard<'c, Pin<KBox<TreeContainer>>>,
+        hw_data_guard: &'b mut SpinLockGuard<'c, HwQueueContext>,
+        block_size: usize,
+        sheaf: &'b mut Option<XArraySheaf<'c>>,
+    ) -> Result {
+        match sheaf {
+            Some(sheaf) => {
+                tree_guard.do_unlocked(|| {
+                    hw_data_guard.do_unlocked(|| sheaf.refill(GFP_KERNEL, Self::sheaf_size()))
+                })?;
+            }
+            None => {
+                let _ = sheaf.insert(
+                    kernel::xarray::xarray_kmem_cache()
+                        .sheaf(Self::sheaf_size(), GFP_NOWAIT)
+                        .or(tree_guard.do_unlocked(|| {
+                            hw_data_guard.do_unlocked(|| -> Result<_> {
+                                kernel::xarray::xarray_kmem_cache()
+                                    .sheaf(Self::sheaf_size(), GFP_KERNEL)
+                            })
+                        }))?,
+                );
+            }
+        }
+
+        // Another thread may get the lock after we allocate. If this happens, retry.
+        while hw_data_guard.page.is_none() {
+            hw_data_guard.page =
+                Some(tree_guard.do_unlocked(|| {
+                    hw_data_guard.do_unlocked(|| NullBlockPage::new(block_size))
+                })?);
+        }
+
+        Ok(())
+    }
+
     #[inline(always)]
-    fn write(tree: &XArray<TreeNode>, mut sector: u64, mut segment: Segment<'_>) -> Result {
-        while !segment.is_empty() {
-            let page = NullBlockPage::new()?;
-            let mut tree = tree.lock();
+    fn write<'a, 'b, 'c>(
+        &'a self,
+        tree_guard: &'b mut SpinLockGuard<'c, Pin<KBox<TreeContainer>>>,
+        hw_data_guard: &'b mut SpinLockGuard<'c, HwQueueContext>,
+        mut sector: u64,
+        mut segment: Segment<'_>,
+    ) -> Result {
+        let mut sheaf: Option<XArraySheaf<'_>> = None;
 
-            // CAST: Device size limited during setup to (2^32)-1 on 32 bit systems.
-            let page_idx = (sector >> block::PAGE_SECTORS_SHIFT) as usize;
+        while !segment.is_empty() {
+            Self::preload(tree_guard, hw_data_guard, self.block_size, &mut sheaf)?;
 
-            let page = if let Some(page) = tree.get_mut(page_idx) {
-                page
-            } else {
-                tree.store(page_idx, page, GFP_KERNEL)?;
-                tree.get_mut(page_idx).unwrap()
-            };
+            let mut access = self.storage.access(tree_guard, hw_data_guard, sheaf);
 
+            let page = access.get_write_page(sector)?;
             page.set_occupied(sector);
 
             // CAST: Page offset always fits in 32 bits.
@@ -296,58 +365,73 @@ fn write(tree: &XArray<TreeNode>, mut sector: u64, mut segment: Segment<'_>) ->
                 ((sector & u64::from(block::PAGE_SECTOR_MASK)) << block::SECTOR_SHIFT) as usize;
 
             // CAST: Casting from `usize` to `u64` never overflows.
-            sector += segment.copy_to_page(page.page.as_pin_mut(), page_offset) as u64
+            sector += segment.copy_to_page(page.page_mut().as_pin_mut(), page_offset) as u64
                 >> block::SECTOR_SHIFT;
+
+            sheaf = access.sheaf;
         }
+
+        if let Some(sheaf) = sheaf {
+            tree_guard.do_unlocked(|| {
+                hw_data_guard.do_unlocked(|| {
+                    sheaf.return_refill(GFP_KERNEL);
+                })
+            });
+        }
+
         Ok(())
     }
 
     #[inline(always)]
-    fn read(tree: &XArray<TreeNode>, mut sector: u64, mut segment: Segment<'_>) -> Result {
-        let tree = tree.lock();
+    fn read<'a, 'b, 'c>(
+        &'a self,
+        tree_guard: &'b mut SpinLockGuard<'c, Pin<KBox<TreeContainer>>>,
+        hw_data_guard: &'b mut SpinLockGuard<'c, HwQueueContext>,
+        mut sector: u64,
+        mut segment: Segment<'_>,
+    ) -> Result {
+        let access = self.storage.access(tree_guard, hw_data_guard, None);
 
         while !segment.is_empty() {
-            // CAST: Device size limited during setup to (2^32)-1 on 32 bit systems.
-            let page_idx = (sector >> block::PAGE_SECTORS_SHIFT) as usize;
+            let page = access.get_read_page(sector);
 
-            if let Some(page) = tree.get(page_idx) {
-                // CAST: Page offset always fits in 32 bits.
-                let page_offset =
-                    ((sector & u64::from(block::PAGE_SECTOR_MASK)) << block::SECTOR_SHIFT) as usize;
+            match page {
+                Some(page) => {
+                    // CAST: Page offset always fits in 32 bits.
+                    let page_offset = ((sector & u64::from(block::PAGE_SECTOR_MASK))
+                        << block::SECTOR_SHIFT) as usize;
 
+                    // CAST: Casting from `usize` to `u64` never overflows.
+                    sector += segment.copy_from_page(page.page(), page_offset) as u64
+                        >> block::SECTOR_SHIFT;
+                }
                 // CAST: Casting from `usize` to `u64` never overflows.
-                sector +=
-                    segment.copy_from_page(&page.page, page_offset) as u64 >> block::SECTOR_SHIFT;
-            } else {
-                // CAST: Casting from `usize` to `u64` never overflows.
-                sector += segment.zero_page() as u64 >> block::SECTOR_SHIFT;
+                None => sector += segment.zero_page() as u64 >> block::SECTOR_SHIFT,
             }
         }
 
         Ok(())
     }
 
-    fn discard(tree: &XArray<TreeNode>, mut sector: u64, sectors: u64, block_size: u64) -> Result {
-        let mut remaining_bytes = sectors << SECTOR_SHIFT;
-        let mut tree = tree.lock();
+    fn discard(
+        &self,
+        hw_data: &Pin<&SpinLock<HwQueueContext>>,
+        mut sector: u64,
+        sectors: u32,
+    ) -> Result {
+        let mut tree_guard = self.storage.lock();
+        let mut hw_data_guard = hw_data.lock();
 
-        while remaining_bytes > 0 {
-            // CAST: Device size limited during setup to (2^32)-1 on 32 bit systems.
-            let page_idx = (sector >> block::PAGE_SECTORS_SHIFT) as usize;
-            let mut remove = false;
-            if let Some(page) = tree.get_mut(page_idx) {
-                page.set_free(sector);
-                if page.is_empty() {
-                    remove = true;
-                }
-            }
+        let mut access = self
+            .storage
+            .access(&mut tree_guard, &mut hw_data_guard, None);
 
-            if remove {
-                drop(tree.remove(page_idx))
-            }
+        let mut remaining_bytes = (sectors as usize) << SECTOR_SHIFT;
 
-            let processed = remaining_bytes.min(block_size);
-            sector += processed >> SECTOR_SHIFT;
+        while remaining_bytes > 0 {
+            access.free_sector(sector);
+            let processed = remaining_bytes.min(self.block_size);
+            sector += (processed >> SECTOR_SHIFT) as u64;
             remaining_bytes -= processed;
         }
 
@@ -356,14 +440,19 @@ fn discard(tree: &XArray<TreeNode>, mut sector: u64, sectors: u64, block_size: u
 
     #[inline(never)]
     fn transfer(
+        &self,
+        hw_data: &Pin<&SpinLock<HwQueueContext>>,
         rq: &mut Owned<mq::Request<Self>>,
-        tree: &XArray<TreeNode>,
         max_sectors: u32,
     ) -> Result {
         let mut sector = rq.sector();
         let max_end_sector = sector + <u32 as Into<u64>>::into(max_sectors);
         let command = rq.command();
 
+        // TODO: Use `PerCpu` to get rid of this lock
+        let mut hw_data_guard = hw_data.lock();
+        let mut tree_guard = self.storage.lock();
+
         for bio in rq.bio_iter_mut() {
             let segment_iter = bio.segment_iter();
             for mut segment in segment_iter {
@@ -373,8 +462,12 @@ fn transfer(
                 let length_sectors_allowed = segment_length_sectors.min(max_remaining_sectors);
                 segment.truncate(length_sectors_allowed << SECTOR_SHIFT);
                 match command {
-                    bindings::req_op_REQ_OP_WRITE => Self::write(tree, sector, segment)?,
-                    bindings::req_op_REQ_OP_READ => Self::read(tree, sector, segment)?,
+                    bindings::req_op_REQ_OP_WRITE => {
+                        self.write(&mut tree_guard, &mut hw_data_guard, sector, segment)?
+                    }
+                    bindings::req_op_REQ_OP_READ => {
+                        self.read(&mut tree_guard, &mut hw_data_guard, sector, segment)?
+                    }
                     _ => (),
                 }
                 sector += u64::from(length_sectors_allowed);
@@ -384,29 +477,26 @@ fn transfer(
                 }
             }
         }
+
         Ok(())
     }
 
-    fn handle_bad_blocks(
-        rq: &mut Owned<mq::Request<Self>>,
-        queue_data: &QueueData,
-        sectors: &mut u32,
-    ) -> Result {
-        if queue_data.bad_blocks.enabled() {
+    fn handle_bad_blocks(&self, rq: &mut Owned<mq::Request<Self>>, sectors: &mut u32) -> Result {
+        if self.bad_blocks.enabled() {
             let start = rq.sector();
             let end = start + u64::from(*sectors);
-            match queue_data.bad_blocks.check(start..end) {
+            match self.bad_blocks.check(start..end) {
                 badblocks::BlockStatus::None => {}
                 badblocks::BlockStatus::Acknowledged(mut range)
                 | badblocks::BlockStatus::Unacknowledged(mut range) => {
                     rq.data_ref().error.store(1, ordering::Relaxed);
 
-                    if queue_data.bad_blocks_once {
-                        queue_data.bad_blocks.set_good(range.clone())?;
+                    if self.bad_blocks_once {
+                        self.bad_blocks.set_good(range.clone())?;
                     }
 
-                    if queue_data.bad_blocks_partial_io {
-                        let block_size_sectors = queue_data.block_size >> SECTOR_SHIFT;
+                    if self.bad_blocks_partial_io {
+                        let block_size_sectors = (self.block_size >> SECTOR_SHIFT) as u64;
                         range.start = align_down(range.start, block_size_sectors);
                         if start < range.start {
                             *sectors = (range.start - start) as u32;
@@ -431,52 +521,8 @@ fn end_request(rq: Owned<mq::Request<Self>>) {
     }
 }
 
-static_assert!((PAGE_SIZE >> SECTOR_SHIFT) <= 64);
-
-struct NullBlockPage {
-    page: Owned<SafePage>,
-    status: u64,
-}
-
-impl NullBlockPage {
-    fn new() -> Result<KBox<Self>> {
-        Ok(KBox::new(
-            Self {
-                page: SafePage::alloc_page(GFP_KERNEL | __GFP_ZERO)?,
-                status: 0,
-            },
-            GFP_KERNEL,
-        )?)
-    }
-
-    fn set_occupied(&mut self, sector: u64) {
-        let idx = sector & u64::from(PAGE_SECTOR_MASK);
-        self.status |= 1 << idx;
-    }
-
-    fn set_free(&mut self, sector: u64) {
-        let idx = sector & u64::from(PAGE_SECTOR_MASK);
-        self.status &= !(1 << idx);
-    }
-
-    fn is_empty(&self) -> bool {
-        self.status == 0
-    }
-}
-
-type TreeNode = KBox<NullBlockPage>;
-
-#[pin_data]
-struct QueueData {
-    #[pin]
-    tree: XArray<TreeNode>,
-    irq_mode: IRQMode,
-    completion_time: Delta,
-    memory_backed: bool,
-    block_size: u64,
-    bad_blocks: Arc<BadBlocks>,
-    bad_blocks_once: bool,
-    bad_blocks_partial_io: bool,
+struct HwQueueContext {
+    page: Option<KBox<disk_storage::NullBlockPage>>,
 }
 
 #[pin_data]
@@ -531,10 +577,10 @@ fn align_down<T>(value: T, to: T) -> T
 
 #[vtable]
 impl Operations for NullBlkDevice {
-    type QueueData = Pin<KBox<QueueData>>;
+    type QueueData = Pin<KBox<Self>>;
     type RequestData = Pdu;
     type TagSetData = ();
-    type HwData = ();
+    type HwData = Pin<KBox<SpinLock<HwQueueContext>>>;
 
     fn new_request_data() -> impl PinInit<Self::RequestData> {
         pin_init!(Pdu {
@@ -545,42 +591,40 @@ fn new_request_data() -> impl PinInit<Self::RequestData> {
 
     #[inline(always)]
     fn queue_rq(
-        _hw_data: (),
-        queue_data: Pin<&QueueData>,
+        hw_data: Pin<&SpinLock<HwQueueContext>>,
+        this: Pin<&Self>,
         mut rq: Owned<mq::Request<Self>>,
         _is_last: bool,
     ) -> Result {
         let mut sectors = rq.sectors();
 
-        Self::handle_bad_blocks(&mut rq, queue_data.get_ref(), &mut sectors)?;
+        Self::handle_bad_blocks(this.get_ref(), &mut rq, &mut sectors)?;
 
-        if queue_data.memory_backed {
+        if this.memory_backed {
             memalloc_scope!(let _noio: NoIo);
-            let tree = &queue_data.tree;
-
             if rq.command() == bindings::req_op_REQ_OP_DISCARD {
-                Self::discard(tree, rq.sector(), sectors.into(), queue_data.block_size)?;
+                this.discard(&hw_data, rq.sector(), sectors)?;
             } else {
-                Self::transfer(&mut rq, tree, sectors)?;
+                this.transfer(&hw_data, &mut rq, sectors)?;
             }
         }
 
-        match queue_data.irq_mode {
+        match this.irq_mode {
             IRQMode::None => Self::end_request(rq),
             IRQMode::Soft => mq::Request::complete(rq.into()),
             IRQMode::Timer => {
                 OwnableRefCounted::into_shared(rq)
-                    .start(queue_data.completion_time)
+                    .start(this.completion_time)
                     .dismiss();
             }
         }
         Ok(())
     }
 
-    fn commit_rqs(_hw_data: (), _queue_data: Pin<&QueueData>) {}
+    fn commit_rqs(_hw_data: Pin<&SpinLock<HwQueueContext>>, _queue_data: Pin<&Self>) {}
 
-    fn init_hctx(_tagset_data: (), _hctx_idx: u32) -> Result {
-        Ok(())
+    fn init_hctx(_tagset_data: (), _hctx_idx: u32) -> Result<Self::HwData> {
+        KBox::pin_init(new_spinlock!(HwQueueContext { page: None }), GFP_KERNEL)
     }
 
     fn complete(rq: ARef<mq::Request<Self>>) {

-- 
2.51.2



