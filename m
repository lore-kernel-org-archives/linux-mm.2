Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FE6BCD8CB2
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:13:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 643036B00C8; Tue,  9 Jun 2026 15:13:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F4216B00CA; Tue,  9 Jun 2026 15:13:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 509886B00CB; Tue,  9 Jun 2026 15:13:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3E20C6B00C8
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:13:02 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0DD8D1A0741
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:13:02 +0000 (UTC)
X-FDA: 84861321804.13.15723B9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3879D1C0002
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:13:00 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="H/lEsSss";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781032380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=as5ubVXy9pDah6a38S1Rm853FewwW17NrvS6Iq2Oams=;
	b=pumX/my0g9kre+xw+gxN8PgKvieUMq5MQJ8D4gRmxKnswl7TN3dUp1mFoAiMH3p2gpLmsj
	788cNzU9g5aX94g5ua0NyDmRnAdJcTVWpBNCNdCYmyzexeZULK8OWkRzLASWHjiUDYXZtG
	/bY4VNa2YA3viQis3/w/D/H3/LuCL28=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="H/lEsSss";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781032380;
	b=ri3zjhB4lP4pRaWLjWNo9+92btKY7Fr2hACX+ToPNCjd185/1LR9eHSP0vTC74/UuFiCqt
	rBgxVTOaZKwz5iiSjBiedMFsHqzBC2nc4/k76eHXCc/yJmKlLTAQJabNhzUJHFvov1/ziJ
	ynMDFF4ilchEQ0hUQ4Odp5k38/U4gZg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6EF2B43ECF;
	Tue,  9 Jun 2026 19:12:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84E301F00893;
	Tue,  9 Jun 2026 19:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781032379;
	bh=as5ubVXy9pDah6a38S1Rm853FewwW17NrvS6Iq2Oams=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=H/lEsSssWyII8rY8RleQpGtSmi85awUyW7eU8iflg601qoIsT4qvYikr89gNkQ9En
	 kpHtW+3/uHGG0TQLBmeLNw4LNRWw9HxF1h1SsrzJVmefWnkA0GJBdqgBqcSDdifXK+
	 BJ3OGGtsAmojbqYNtD2QRYQoxG2VwRH3b5UaRJp6C1csUcgiQ42EG3BcXVWWfwxJIe
	 BmF2GyFgl5qXK0j/NGKK8XWulaEixftONEsoWE9ClN+AXkmLxtx7Pfx3/ejBB3vDxX
	 tneJSr04kv1HM5s95zRZlMrMR7bhLMt3o5nGzJpRo1QEht8RBBtk504u3WHLdFQf6g
	 4U6JzxI2Ar/Jg==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 09 Jun 2026 21:09:02 +0200
Subject: [PATCH v2 83/83] block: rnull: add zone offline and readonly
 configfs files
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-rnull-v6-19-rc5-send-v2-83-82c7404542e2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=15517;
 i=a.hindborg@kernel.org; h=from:subject:message-id;
 bh=T3pkCjSoqlz/5eAmoml0zuQJKOlZemt616lr74wbC6g=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqKGT/2B21XD7rkanWLOYqJi6E0g5N/32wBgJiA
 UCG8Z2zaGOJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaihk/wAKCRD6UCkIqsW9
 0A+vD/4/R6jsny4DtPvTLS1Zr0bhgTMsff+cmB0ZHGOBF9MtJTa/RQYLe0TMvKsNc/IkT+Kgmvm
 A5i9CAXdoH9F+qJN5qNlaD2zK7Z1OuHFiEP//e3oPSP6dML1WQDU+tQL/podg/speszIl1GvbcY
 BvDSKpJuEWoNNjKCqTRjJD8LNKMNjTrags41FXp45aiVXyDpR6c3e7nOgjOBHbxMNSnL3D9aEzr
 zXaxnRtik7GXFMqqggZ9npK1ksk33uqIBLNVWz9TTnlwt7lPph4vfOjBreeKPI5slUKaXv0dOb1
 9LBh+pu4tvgbpXJoC1qxZv51uD1g3fP6nXyxBZL5iSLBJGNBRUy8ytmLuAToScyG+NMXMSQymn7
 L/1gju6Hg7GQWX1PDXvkGpFZhYwZcgq8uH59xstBP80I79wcq3bWBqBbobtIKsfMCEsFxt23ylr
 JaOG1XYJ0t89feKumt9mtu32Eavil0dSQG2KICfpsAUhDEQFIR4BoiwlMxmOgnO3AMEyWmLupe8
 3Mp4lwR3QoWLERLfx1owl6xHJKDTNyjY+IaccJTfGP0cK2ONl56Fe4s26NwF/CwXoKD18W8zbtJ
 pGeyYuKoT6AppvcmtiANY3tEOldxVP9uH5e8HeoYdl4NnQnS8v35lObymH6iOA+ZUtPAhdPWaC0
 B5YQyVZzCWRu3zQ==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3879D1C0002
X-Stat-Signature: h3wrt94ubkqc3zigaph83115ziwpqkeh
X-Rspam-User: 
X-HE-Tag: 1781032380-812200
X-HE-Meta: U2FsdGVkX19RQDmk9XgX663ONmbU9fahnPoamd0RxmgYkr/Zw9UJQxlLNuk2uSV4svswivkQ4mDCjGVddoROI16nPqTixrrl2C+6OLS38PD1Op9CqD2sSylovP2rl9XRUHz0HZ+ZlOJULxlN+6fNTigrmVMkeZorEMZULmYlPrQybm31Mg0GZyG1Wc667MwNwNAi2ktX//Q7OiYGLTP09fc7Kh/IA5jKAeVuK8rYLicZ9HF0YLkBYk3XWYP5oF3ZH4ZOZetfhAUPfL8npgoLxku+NCiIU15zlalIlOjE4kHTgsSXIVL5QxyB5ypHMZomDo41fjsw4F4zWmc2GQ7zMXpxBO2XuOjijMDg3V9Spt2mz8Nd07UjPFtIAfQPcVDeUBxl6fGDQLmHRCr+nWT5qyWHFnkaR7hjKGk8e3/oAdgFlQknPhiXFJNlK9K65L7+nOEQYyx2yV1qY7ZebHWeca5OmcxjNPAKaHGvBGRT6f7bUNBSjII3li/Yc5G1IWdvrKuU5cj46G3TK6A6jY32FQb5QeG1B1KM30Hm668I0bQ5Q25SbRkHC8lQWMVivfTF6LUUumTu2ZsFZJPLwqc2NkzFlTWYI4FjzDD6STFMbwQBjsS7dzWsxnANkYbx6XIQY1CwJk5EsJl6OptVOQvjQdzUN5o1D9ovmWOCpmXLQpsH9nGynXamYMMT+aa7LI6o0mPGjUq5WORfkZNO3EBMaTczNdSAb6azAaGlwpGuK+ZgJGVcH+CsbfpCGMWzEF9m2Fb/7yVj+jW6BUdJ1GzE4zdHqcj4nvzAEUloaMenKh0apVkFAerJjb2aGDDrAitmWLVN2P14/9ZolpA6mbtmJxS+5TJ4+Bf9uyaR9VxKfVYskETQ8732ViGsioT9oIadn4fU29ln3M03OpYU8SdgAcHHOSJw8XRIY6f0IQjU5lFP8wEWwAEqAMQcc5k0IqUTBSEOwJ56duRtFXPzMnF
 1ggabXTx
 j/zhvtGDwHbv/MZKKienZTJvY0Kv5zCzwgEndhyol/U3dbWQ+rG5oyacuY3jsuDOwRFqHe9jPvLQI7sLd0hhADS/dT8vINtmGMkT0iPqu5y1ct8occCQpBsI35Hn+7UyGMWEaNqGvq1MaGohIfZyj+vGjYw64KFXRukSFnRaasOHM21io9tgVaQGiQOdUIhGpr0gZS8qm4o/DDECOXwtgDrWPt9W4uohJb2LIwjnTmLUt8kDtlKflv8vyelAySDe6pPSGOm1xGkNMv8VtnIb1gddMBh/f6LmFQq7Z/i444Elc1DSeBJJmpwvwT+iPjntmk6vf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add configfs attributes for managing zone states in the rnull zoned
block device emulation. The `zone_offline` and `zone_readonly`
attributes allow setting specific zones to offline or read-only states,
which is useful for testing how applications handle degraded zones.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 drivers/block/rnull/configfs.rs     | 76 +++++++++++++++++++++++++++++++++
 drivers/block/rnull/disk_storage.rs | 59 +++++++++++++-------------
 drivers/block/rnull/rnull.rs        |  2 +-
 drivers/block/rnull/zoned.rs        | 83 ++++++++++++++++++++++++++-----------
 4 files changed, 164 insertions(+), 56 deletions(-)

diff --git a/drivers/block/rnull/configfs.rs b/drivers/block/rnull/configfs.rs
index 1bab38c55698..43d01b419579 100644
--- a/drivers/block/rnull/configfs.rs
+++ b/drivers/block/rnull/configfs.rs
@@ -135,6 +135,8 @@ fn make_group(
                 max_sectors: 29,
                 virt_boundary: 30,
                 shared_tag_bitmap: 31,
+                zone_offline: 32,
+                zone_readonly: 33,
             ],
         };
 
@@ -627,3 +629,77 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
 configfs_simple_field!(DeviceConfig, 29, max_sectors, u32);
 configfs_simple_bool_field!(DeviceConfig, 30, virt_boundary);
 configfs_simple_bool_field!(DeviceConfig, 31, shared_tag_bitmap);
+
+#[cfg(CONFIG_BLK_DEV_ZONED)]
+fn set_zone_condition(
+    this: &DeviceConfig,
+    sector: u64,
+    cb: impl FnOnce(
+        &crate::zoned::ZoneOptions,
+        &DiskStorage,
+        &mut crate::zoned::ZoneDescriptor,
+    ) -> Result,
+) -> Result {
+    use crate::zoned::ZoneType;
+    let data_guard = this.data.lock();
+    let null_disk = data_guard.disk.as_ref().ok_or(EBUSY)?.queue_data();
+    let storage = &null_disk.storage;
+    let zone_options = &null_disk.zoned;
+    zone_options.enabled.then_some(()).ok_or(EINVAL)?;
+    let mut zone = zone_options.zone(sector)?.lock();
+
+    if zone.kind == ZoneType::Conventional {
+        return Err(EINVAL);
+    }
+
+    cb(zone_options, storage, &mut zone)
+}
+
+#[cfg(CONFIG_BLK_DEV_ZONED)]
+configfs_attribute!(
+    DeviceConfig,
+    32,
+    show: |_this, _page| Ok(0),
+    store: |this,page| {
+        let text = core::str::from_utf8(page)?.trim();
+        let sector = text.parse().map_err(|_| EINVAL)?;
+
+        set_zone_condition(this, sector, |zone_options, storage, zone| {
+            zone_options.offline_zone(storage, zone)
+        })?;
+        Ok(())
+    },
+);
+
+#[cfg(CONFIG_BLK_DEV_ZONED)]
+configfs_attribute!(
+    DeviceConfig,
+    33,
+    show: |_this, _page| Ok(0),
+    store: |this,page| {
+        let text = core::str::from_utf8(page)?.trim();
+        let sector = text.parse().map_err(|_| EINVAL)?;
+
+        set_zone_condition(this, sector, |zone_options, storage, zone| {
+            zone_options.read_only_zone(storage, zone)
+        })?;
+
+        Ok(())
+    },
+);
+
+#[cfg(not(CONFIG_BLK_DEV_ZONED))]
+configfs_attribute!(
+    DeviceConfig,
+    32,
+    show: |_this, _page| Ok(0),
+    store: |_this, _page| Err(ENOTSUPP),
+);
+
+#[cfg(not(CONFIG_BLK_DEV_ZONED))]
+configfs_attribute!(
+    DeviceConfig,
+    33,
+    show: |_this, _page| Ok(0),
+    store: |_this, _page| Err(ENOTSUPP),
+);
diff --git a/drivers/block/rnull/disk_storage.rs b/drivers/block/rnull/disk_storage.rs
index 6797b7996da3..879dd5d96e65 100644
--- a/drivers/block/rnull/disk_storage.rs
+++ b/drivers/block/rnull/disk_storage.rs
@@ -65,27 +65,45 @@ pub(crate) fn lock(&self) -> SpinLockGuard<'_, Pin<KBox<TreeContainer>>> {
         self.trees.lock()
     }
 
-    pub(crate) fn discard(
-        &self,
-        hw_data: &Pin<&SpinLock<HwQueueContext>>,
-        mut sector: u64,
-        sectors: u32,
-    ) {
-        let mut tree_guard = self.lock();
-        let mut hw_data_guard = hw_data.lock();
-
-        let mut access = self.access(&mut tree_guard, &mut hw_data_guard, None);
+    pub(crate) fn discard(&self, mut sector: u64, sectors: u32) {
+        let tree_guard = self.lock();
+        let mut cache_guard = tree_guard.cache_tree.lock();
+        let mut disk_guard = tree_guard.cache_tree.lock();
 
         let mut remaining_bytes = sectors_to_bytes(sectors);
 
         while remaining_bytes > 0 {
-            access.free_sector(sector);
+            self.free_sector(&mut cache_guard, &mut disk_guard, sector);
             let processed = remaining_bytes.min(self.block_size);
             sector += Into::<u64>::into(bytes_to_sectors(processed));
             remaining_bytes -= processed;
         }
     }
 
+    fn free_sector_tree(tree_access: &mut xarray::Guard<'_, TreeNode>, sector: u64) {
+        let index = DiskStorageAccess::to_index(sector);
+        if let Some(page) = tree_access.get_mut(index) {
+            page.set_free(sector);
+
+            if page.is_empty() {
+                tree_access.remove(index);
+            }
+        }
+    }
+
+    pub(crate) fn free_sector<'a>(
+        &self,
+        cache_guard: &mut xarray::Guard<'a, TreeNode>,
+        disk_guard: &mut xarray::Guard<'a, TreeNode>,
+        sector: u64,
+    ) {
+        if self.cache_size > 0 {
+            Self::free_sector_tree(cache_guard, sector);
+        }
+
+        Self::free_sector_tree(disk_guard, sector);
+    }
+
     pub(crate) fn flush(&self, hw_data: &Pin<&SpinLock<HwQueueContext>>) {
         let mut tree_guard = self.lock();
         let mut hw_data_guard = hw_data.lock();
@@ -286,25 +304,6 @@ pub(crate) fn get_read_page(&self, sector: u64) -> Option<&NullBlockPage> {
             self.disk_guard.get(index)
         }
     }
-
-    fn free_sector_tree(tree_access: &mut xarray::Guard<'_, TreeNode>, sector: u64) {
-        let index = Self::to_index(sector);
-        if let Some(page) = tree_access.get_mut(index) {
-            page.set_free(sector);
-
-            if page.is_empty() {
-                tree_access.remove(index);
-            }
-        }
-    }
-
-    pub(crate) fn free_sector(&mut self, sector: u64) {
-        if self.disk_storage.cache_size > 0 {
-            Self::free_sector_tree(&mut self.cache_guard, sector);
-        }
-
-        Self::free_sector_tree(&mut self.disk_guard, sector);
-    }
 }
 
 type TreeNode = KBox<NullBlockPage>;
diff --git a/drivers/block/rnull/rnull.rs b/drivers/block/rnull/rnull.rs
index 81f9e2d03f31..b6371fe4ebeb 100644
--- a/drivers/block/rnull/rnull.rs
+++ b/drivers/block/rnull/rnull.rs
@@ -798,7 +798,7 @@ fn handle_regular_command(
         if self.memory_backed {
             memalloc_scope!(let _noio: NoIo);
             if rq.command() == mq::Command::Discard {
-                self.storage.discard(hw_data, rq.sector(), sectors);
+                self.storage.discard(rq.sector(), sectors);
             } else {
                 self.transfer(hw_data, rq, rq.command(), sectors)?;
             }
diff --git a/drivers/block/rnull/zoned.rs b/drivers/block/rnull/zoned.rs
index 808449cc49e1..cf0eb5d31840 100644
--- a/drivers/block/rnull/zoned.rs
+++ b/drivers/block/rnull/zoned.rs
@@ -179,7 +179,7 @@ pub(crate) fn handle_zoned_command(
         match rq.command() {
             ZoneAppend | Write => self.zoned_write(hw_data, rq)?,
             ZoneReset | ZoneResetAll | ZoneOpen | ZoneClose | ZoneFinish => {
-                self.zone_management(hw_data, rq)?
+                self.zone_management(rq)?
             }
             _ => self.zoned_read(hw_data, rq)?,
         }
@@ -187,18 +187,14 @@ pub(crate) fn handle_zoned_command(
         Ok(())
     }
 
-    fn zone_management(
-        &self,
-        hw_data: &Pin<&SpinLock<HwQueueContext>>,
-        rq: &mut Owned<mq::Request<Self>>,
-    ) -> Result {
+    fn zone_management(&self, rq: &mut Owned<mq::Request<Self>>) -> Result {
         if rq.command() == mq::Command::ZoneResetAll {
             for zone in self.zoned.zones_iter() {
                 let mut zone = zone.lock();
                 use ZoneCondition::*;
                 match zone.condition {
                     Empty | ReadOnly | Offline => continue,
-                    _ => self.zoned.reset_zone(&self.storage, hw_data, &mut zone)?,
+                    _ => self.zoned.reset_zone(&self.storage, &mut zone)?,
                 }
             }
 
@@ -214,10 +210,10 @@ fn zone_management(
 
         use mq::Command::*;
         match rq.command() {
-            ZoneOpen => self.zoned.open_zone(&mut zone, rq.sector()),
+            ZoneOpen => self.zoned.open_zone(&mut zone),
             ZoneClose => self.zoned.close_zone(&mut zone),
-            ZoneReset => self.zoned.reset_zone(&self.storage, hw_data, &mut zone),
-            ZoneFinish => self.zoned.finish_zone(&mut zone, rq.sector()),
+            ZoneReset => self.zoned.reset_zone(&self.storage, &mut zone),
+            ZoneFinish => self.zoned.finish_zone(&mut zone),
             _ => Err(EIO),
         }
     }
@@ -283,7 +279,7 @@ fn zoned_write(
             if self.zoned.use_accounting() {
                 let mut accounting = self.zoned.accounting.lock();
                 self.zoned
-                    .check_zone_resources(&mut accounting, &mut zone, rq.sector())?;
+                    .check_zone_resources(&mut accounting, &mut zone)?;
 
                 if zone.condition == ZoneCondition::Closed {
                     accounting.closed -= 1;
@@ -367,7 +363,7 @@ fn zone_no(&self, sector: u64) -> usize {
         (sector >> self.size_sectors.ilog2()) as usize
     }
 
-    fn zone(&self, sector: u64) -> Result<&Mutex<ZoneDescriptor>> {
+    pub(crate) fn zone(&self, sector: u64) -> Result<&Mutex<ZoneDescriptor>> {
         self.zones.get(self.zone_no(sector)).ok_or(EINVAL)
     }
 
@@ -420,7 +416,7 @@ fn try_close_implicit_open_zone(&self, accounting: &mut ZoneAccounting, sector:
         Err(EINVAL)
     }
 
-    fn open_zone(&self, zone: &mut ZoneDescriptor, sector: u64) -> Result {
+    fn open_zone(&self, zone: &mut ZoneDescriptor) -> Result {
         if zone.kind == ZoneType::Conventional {
             return Err(EINVAL);
         }
@@ -436,13 +432,13 @@ fn open_zone(&self, zone: &mut ZoneDescriptor, sector: u64) -> Result {
             let mut accounting = self.accounting.lock();
             match zone.condition {
                 Empty => {
-                    self.check_zone_resources(&mut accounting, zone, sector)?;
+                    self.check_zone_resources(&mut accounting, zone)?;
                 }
                 ImplicitOpen => {
                     accounting.implicit_open -= 1;
                 }
                 Closed => {
-                    self.check_zone_resources(&mut accounting, zone, sector)?;
+                    self.check_zone_resources(&mut accounting, zone)?;
                     accounting.closed -= 1;
                 }
                 _ => (),
@@ -459,14 +455,13 @@ fn check_zone_resources(
         &self,
         accounting: &mut ZoneAccounting,
         zone: &mut ZoneDescriptor,
-        sector: u64,
     ) -> Result {
         match zone.condition {
             ZoneCondition::Empty => {
                 self.check_active_zones(accounting)?;
-                self.check_open_zones(accounting, sector)
+                self.check_open_zones(accounting, zone.start_sector)
             }
-            ZoneCondition::Closed => self.check_open_zones(accounting, sector),
+            ZoneCondition::Closed => self.check_open_zones(accounting, zone.start_sector),
             _ => Err(EIO),
         }
     }
@@ -535,7 +530,7 @@ fn close_zone(&self, zone: &mut ZoneDescriptor) -> Result {
         Ok(())
     }
 
-    fn finish_zone(&self, zone: &mut ZoneDescriptor, sector: u64) -> Result {
+    fn finish_zone(&self, zone: &mut ZoneDescriptor) -> Result {
         if zone.kind == ZoneType::Conventional {
             return Err(EINVAL);
         }
@@ -547,12 +542,12 @@ fn finish_zone(&self, zone: &mut ZoneDescriptor, sector: u64) -> Result {
             match zone.condition {
                 Full => return Ok(()),
                 Empty => {
-                    self.check_zone_resources(&mut accounting, zone, sector)?;
+                    self.check_zone_resources(&mut accounting, zone)?;
                 }
                 ImplicitOpen => accounting.implicit_open -= 1,
                 ExplicitOpen => accounting.explicit_open -= 1,
                 Closed => {
-                    self.check_zone_resources(&mut accounting, zone, sector)?;
+                    self.check_zone_resources(&mut accounting, zone)?;
                     accounting.closed -= 1;
                 }
                 _ => return Err(EIO),
@@ -568,7 +563,6 @@ fn finish_zone(&self, zone: &mut ZoneDescriptor, sector: u64) -> Result {
     fn reset_zone(
         &self,
         storage: &crate::disk_storage::DiskStorage,
-        hw_data: &Pin<&SpinLock<HwQueueContext>>,
         zone: &mut ZoneDescriptor,
     ) -> Result {
         if zone.kind == ZoneType::Conventional {
@@ -591,16 +585,55 @@ fn reset_zone(
         zone.condition = ZoneCondition::Empty;
         zone.write_pointer = zone.start_sector;
 
-        storage.discard(hw_data, zone.start_sector, zone.size_sectors);
+        storage.discard(zone.start_sector, zone.size_sectors);
+
+        Ok(())
+    }
+
+    fn set_zone_condition(
+        &self,
+        storage: &crate::disk_storage::DiskStorage,
+        zone: &mut ZoneDescriptor,
+        condition: ZoneCondition,
+    ) -> Result {
+        if zone.condition == condition {
+            zone.condition = ZoneCondition::Empty;
+            zone.write_pointer = zone.start_sector;
+            storage.discard(zone.start_sector, zone.size_sectors);
+        } else {
+            if matches!(
+                zone.condition,
+                ZoneCondition::ReadOnly | ZoneCondition::Offline
+            ) {
+                self.finish_zone(zone)?;
+            }
 
+            zone.condition = ZoneCondition::Offline;
+            zone.write_pointer = u64::MAX;
+        }
         Ok(())
     }
+    pub(crate) fn offline_zone(
+        &self,
+        storage: &crate::disk_storage::DiskStorage,
+        zone: &mut ZoneDescriptor,
+    ) -> Result {
+        self.set_zone_condition(storage, zone, ZoneCondition::Offline)
+    }
+
+    pub(crate) fn read_only_zone(
+        &self,
+        storage: &crate::disk_storage::DiskStorage,
+        zone: &mut ZoneDescriptor,
+    ) -> Result {
+        self.set_zone_condition(storage, zone, ZoneCondition::ReadOnly)
+    }
 }
 
 pub(crate) struct ZoneDescriptor {
     start_sector: u64,
     size_sectors: u32,
-    kind: ZoneType,
+    pub(crate) kind: ZoneType,
     capacity_sectors: u32,
     write_pointer: u64,
     condition: ZoneCondition,
@@ -628,7 +661,7 @@ fn check_bounds_read(&self, sector: u64, sectors: u32) -> Result {
 
 #[derive(Copy, Clone, PartialEq, Eq, Debug)]
 #[repr(u32)]
-enum ZoneType {
+pub(crate) enum ZoneType {
     Conventional = bindings::blk_zone_type_BLK_ZONE_TYPE_CONVENTIONAL,
     SequentialWriteRequired = bindings::blk_zone_type_BLK_ZONE_TYPE_SEQWRITE_REQ,
     #[expect(dead_code)]

-- 
2.51.2



