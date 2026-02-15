Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8BFAE63F1F
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 00:50:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B00E6B00A5; Sun, 15 Feb 2026 19:40:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 266486B0130; Sun, 15 Feb 2026 19:40:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 159B46B013B; Sun, 15 Feb 2026 19:40:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 397286B00A5
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 19:39:43 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2DED7160719
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:44:04 +0000 (UTC)
X-FDA: 84448321608.30.49BC39E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7F1AA1C0006
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:44:02 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kVqOk658;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771199042; a=rsa-sha256;
	cv=none;
	b=6Zt9VYhZ0I5+rBemWfWcjZB10WWnSfHCkGRnWJCtPdqDIcd9e895cqFnZgXYKVEpfLoE4M
	MXX6QUKreJVQfkEJkKbt97rfitmHoxDFzJk0W9bd20Bt7wP9FOQYkG+ntG4LoQjBopDwbY
	zzahsIoEbFZItAwb965Rx/7eX69mXqs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kVqOk658;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771199042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4OzTdfQ0FxUb2r3rm+cv17Wk0uybmChuLn/2dbvRKG0=;
	b=OZzOI+vajdPqgsL+SF89Uy9P0wsS4yE8lxZMIa8afOA0GMknRb1UJQlScfvxwxZHCVAuyp
	mxHPpkHi2kTlVwPUgdrWxXgMfdnGayen4xV092JeWd0XgJcCUjmR1kgWKxWaZ1ItNh+n9H
	E7P2JAr9TYwB9IeOz9UCEtnw841PDMQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D7A9C6057A;
	Sun, 15 Feb 2026 23:44:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41E13C4CEF7;
	Sun, 15 Feb 2026 23:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771199041;
	bh=3/is2sfDJmdRy9QPPG2gvTdPrheCZt7kkxfe/Rrhb04=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=kVqOk658tO6pg8KYX7bNxxRB+cTHS2c50HdL/p1++R6v4GnH7HLRcxAuw8IA5riP7
	 3Jt4IDICWjq7yzM4n5QjAQ8/ig/OqXNTTM3n6zQ52XFn73acEKir+D+ouQNgzERc44
	 hVOEEdRJHUNE3P7LFU3s65wdgXswhaUvfHjfWnDpUAn6Le/wmlemPdd/nnmTq35F1E
	 ngL8/34WOhSc91d6R/xOShCJl4l6B/bPuHYyjs/qwtS4s8NbMHmI9wNTIYZPQyL0FA
	 TBQSbXL1sFUr2iAXfXoTHHxuhd044WD/AjNe8u0gs6QfQL1C1KR5W1W0ELiKWSUDaz
	 CyuLRbD8VyITw==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 16 Feb 2026 00:36:06 +0100
Subject: [PATCH 79/79] block: rnull: add zone offline and readonly configfs
 files
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-rnull-v6-19-rc5-send-v1-79-de9a7af4b469@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=15509;
 i=a.hindborg@kernel.org; h=from:subject:message-id;
 bh=3/is2sfDJmdRy9QPPG2gvTdPrheCZt7kkxfe/Rrhb04=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpklhjWcIdNupHJZ+Z1Iqa1OXKENuLiidyv1T3i
 5O5U2MYdHyJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZJYYwAKCRDhuBo+eShj
 d8/3EACTdpRzmaQm8jpMo+udlUhbjmqYZQ1GbysxKSwhPMyLWPONRaDgmeKa2b3Rmbe0NV7Zo5Y
 rIwj38weF3m+Its2XgvUVrahJIiqFSk5NMNQ5HeI+0K+NAQKcKozx5TfEpepA5HdoeaGfJj8b+n
 JkMOaapjc3sNbmsXCjQPo2o2xg0NND5UUAxe0+z0OLn/Ye9inZkivJzED1jXQFs4c9Vkl47lRzo
 UTuKDsSk6spxKiGGbtP2JdlHXjRP8iShxxogibBxN3IWVkYmbyngRfTzgnok73Ozq59wTjYzE5S
 HsuPV36y7jZHTrwnsGiipOeQ0gF6r4E//T+uwJG2yMrszInghK6vLBdJK8TxhAdOwYdEnMdzeVN
 G/LxoYwndTaA4vOOMj8Rt6WWf1AGu3oV57dmJ56qet8F4ssTJnIira4KNF9WHsFYagJHmUzd5Oh
 RSUE1Rp/TBTf8aoBQF0i7uC52UL6SLWO3rPiVQGsidikcmpAHYYEAJSVa60nXzdkT8g8X5v0FWm
 ohKXpgLXGKlIdEgSnROrl/30yR+Gb0F8IO3ZIrmNkncT93pCGE4Cu6Lo6UhcQxzrs0ugJevxH02
 h7Qo6Le7yIoYIZLE0eldLg/PTtbB9il8DVQ5sVVDvI7EsI8f/hjx8XmZpUq/VA10kXbtI8Llr+i
 ZUv36CKP5YOWpDg==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7F1AA1C0006
X-Stat-Signature: qod67r1hkxx5u6s1ejogowqq9muojs55
X-HE-Tag: 1771199042-326142
X-HE-Meta: U2FsdGVkX1+N0UVN83FLSZVxuC+9KUqTXPGGtKILJ91V/SFU+f9BqVGeXA7taKx7AXyfGskXYgBrAeOvljpHu2Tv5/jQs248osVQRy1gMex0puVKbcdO5gOyCXdB6+fgzuDiVa4rfuLJr2H4jDyo8tsqnUGTwqrAGodoNdvdRa2lbz1Mx4Cs0T5ORwgypvmCDPEv10Y4edVOCtxNPgx2a+GtL914ksrTuFvnQp6acFKnfQWVehFTre7yBa5Z4Q0uJsGfTI4NoollsFJvXi9GNgyjucdr7jiChVPF6eF63lYmvlMoT58FGlQOsZ4J1sgviIFiIXvNYuiLJNq2lPQwv/0LkuYJV0Lwkmb5pYu9S/ZJlf42b9mZXLUcgpYHoTRqkGGSS9E/khlOfWVeeqncZxitXKVmnmzESMJ2NrRsvKkEf7pvjDvYi5wg6gBjv72Ez4aoldddDyz4u60JYw4GvD8Aj8tSTP9nmA2Gq10n7QlidRFyiX1NV1PvJJTtTFMknipfEzDOPh2ci+i/FybZqYQOwswxHBnqeMBLzfAR/E6xrVJb98JHoGJ8Y7mqEMPHivuXB4qfO8wjA25u0e+9GTV8cZzyeZkZvLVP2FLq+AIcQ30bjHlp5JhGllRscCTJR9tYIHVu4wCUA7NQZQ+ZyBizPGe0kl7pQckOoOc5INgeG4iM1wFC8E0ezjxDZGS8UDdas7dA8kS2kSmSJQrdJsL9EwA4iN0kPXiMrPDbZcqWxq6C+w2457t46h5opiDJ3ajXZ+EfpydAQ2tNcq2XFkBNkMvPE///cE+jVoed44Ic3KcDKqYNnctnKYZSP6uszxa4CkdLzCai+oiaEOG9qeEtLw8iUl6Qrlyg9h3dggM0RIcH9QtPM26w1IRIOd+/LGpkOcFMm9DOXeG3OQxIn4zfqGic3TwNFHwXt4O3T4NW8vriL08Afbif1Nnp1BDi1B67y3GgNOlhhz+dwhS
 v5BFq+Kx
 7yFKYf1gN4vLXRjNQDUXZkNpsO/YuzK2sYYN7m5N/hYUz4uXOXeF4iouHQMH8lzFCm7WyvnJI/cfbrOHHxZ1qL1/6feBk3Ivkg1H1EU8cp2audvTs0tMDbvSL+pIvdyUiw5d0GRuBIbrgeULlodeD2bRNiMHusCbS/iArC97B7UtEz8Ti6RxkvToxjoauG5f5UJjksM8jvmtBxyVdEkSpSfvXUTaOdbFd0wn8ZgfVnTa+LcEgIbS9Kq5Ss8DfdUN26FJ13Oc17k3AHQsaAQFcmUGKIRTmgYtCl8nvMxCNiPCYAl5ja92fjl7bNm2TI/ZS27k8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
 drivers/block/rnull/configfs.rs     | 80 +++++++++++++++++++++++++++++++++++
 drivers/block/rnull/disk_storage.rs | 59 +++++++++++++-------------
 drivers/block/rnull/rnull.rs        |  2 +-
 drivers/block/rnull/zoned.rs        | 83 ++++++++++++++++++++++++++-----------
 4 files changed, 168 insertions(+), 56 deletions(-)

diff --git a/drivers/block/rnull/configfs.rs b/drivers/block/rnull/configfs.rs
index 395da68d96dc6..1c0d95ded7e9f 100644
--- a/drivers/block/rnull/configfs.rs
+++ b/drivers/block/rnull/configfs.rs
@@ -125,6 +125,8 @@ fn make_group(
                 max_sectors: 29,
                 virt_boundary: 30,
                 shared_tag_bitmap: 31,
+                zone_offline: 32,
+                zone_readonly: 33,
             ],
         };
 
@@ -639,3 +641,81 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
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
+    show: |this, page| {Ok(0)},
+    store: |this,page| {
+        Err(ENOTSUPP)
+    },
+);
+
+#[cfg(not(CONFIG_BLK_DEV_ZONED))]
+configfs_attribute!(
+    DeviceConfig,
+    33,
+    show: |this, page| {Ok(0)},
+    store: |this,page| {
+        Err(ENOTSUPP)
+    },
+);
diff --git a/drivers/block/rnull/disk_storage.rs b/drivers/block/rnull/disk_storage.rs
index d9f2703957fc0..802e9534ca2a5 100644
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
@@ -262,25 +280,6 @@ pub(crate) fn get_read_page(&self, sector: u64) -> Option<&NullBlockPage> {
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
 
 type Tree = XArray<TreeNode>;
diff --git a/drivers/block/rnull/rnull.rs b/drivers/block/rnull/rnull.rs
index 5bf965908ef63..91f8636d74cca 100644
--- a/drivers/block/rnull/rnull.rs
+++ b/drivers/block/rnull/rnull.rs
@@ -739,7 +739,7 @@ fn handle_regular_command(
 
         if self.memory_backed {
             if rq.command() == mq::Command::Discard {
-                self.storage.discard(hw_data, rq.sector(), sectors);
+                self.storage.discard(rq.sector(), sectors);
             } else {
                 self.transfer(hw_data, rq, rq.command(), sectors)?;
             }
diff --git a/drivers/block/rnull/zoned.rs b/drivers/block/rnull/zoned.rs
index 0f15f4cc4e5c3..3b8ebf5449a8d 100644
--- a/drivers/block/rnull/zoned.rs
+++ b/drivers/block/rnull/zoned.rs
@@ -178,7 +178,7 @@ pub(crate) fn handle_zoned_command(
         match rq.command() {
             ZoneAppend | Write => self.zoned_write(hw_data, rq)?,
             ZoneReset | ZoneResetAll | ZoneOpen | ZoneClose | ZoneFinish => {
-                self.zone_management(hw_data, rq)?
+                self.zone_management(rq)?
             }
             _ => self.zoned_read(hw_data, rq)?,
         }
@@ -186,18 +186,14 @@ pub(crate) fn handle_zoned_command(
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
 
@@ -213,10 +209,10 @@ fn zone_management(
 
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
@@ -282,7 +278,7 @@ fn zoned_write(
             if self.zoned.use_accounting() {
                 let mut accounting = self.zoned.accounting.lock();
                 self.zoned
-                    .check_zone_resources(&mut accounting, &mut zone, rq.sector())?;
+                    .check_zone_resources(&mut accounting, &mut zone)?;
 
                 if zone.condition == ZoneCondition::Closed {
                     accounting.closed -= 1;
@@ -365,7 +361,7 @@ fn zone_no(&self, sector: u64) -> usize {
         (sector >> self.size_sectors.ilog2()) as usize
     }
 
-    fn zone(&self, sector: u64) -> Result<&Mutex<ZoneDescriptor>> {
+    pub(crate) fn zone(&self, sector: u64) -> Result<&Mutex<ZoneDescriptor>> {
         self.zones.get(self.zone_no(sector)).ok_or(EINVAL)
     }
 
@@ -418,7 +414,7 @@ fn try_close_implicit_open_zone(&self, accounting: &mut ZoneAccounting, sector:
         Err(EINVAL)
     }
 
-    fn open_zone(&self, zone: &mut ZoneDescriptor, sector: u64) -> Result {
+    fn open_zone(&self, zone: &mut ZoneDescriptor) -> Result {
         if zone.kind == ZoneType::Conventional {
             return Err(EINVAL);
         }
@@ -434,13 +430,13 @@ fn open_zone(&self, zone: &mut ZoneDescriptor, sector: u64) -> Result {
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
@@ -457,14 +453,13 @@ fn check_zone_resources(
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
@@ -533,7 +528,7 @@ fn close_zone(&self, zone: &mut ZoneDescriptor) -> Result {
         Ok(())
     }
 
-    fn finish_zone(&self, zone: &mut ZoneDescriptor, sector: u64) -> Result {
+    fn finish_zone(&self, zone: &mut ZoneDescriptor) -> Result {
         if zone.kind == ZoneType::Conventional {
             return Err(EINVAL);
         }
@@ -545,12 +540,12 @@ fn finish_zone(&self, zone: &mut ZoneDescriptor, sector: u64) -> Result {
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
@@ -566,7 +561,6 @@ fn finish_zone(&self, zone: &mut ZoneDescriptor, sector: u64) -> Result {
     fn reset_zone(
         &self,
         storage: &crate::disk_storage::DiskStorage,
-        hw_data: &Pin<&SpinLock<HwQueueContext>>,
         zone: &mut ZoneDescriptor,
     ) -> Result {
         if zone.kind == ZoneType::Conventional {
@@ -589,16 +583,55 @@ fn reset_zone(
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
@@ -626,7 +659,7 @@ fn check_bounds_read(&self, sector: u64, sectors: u32) -> Result {
 
 #[derive(Copy, Clone, PartialEq, Eq, Debug)]
 #[repr(u32)]
-enum ZoneType {
+pub(crate) enum ZoneType {
     Conventional = bindings::blk_zone_type_BLK_ZONE_TYPE_CONVENTIONAL,
     SequentialWriteRequired = bindings::blk_zone_type_BLK_ZONE_TYPE_SEQWRITE_REQ,
     #[expect(dead_code)]

-- 
2.51.2



