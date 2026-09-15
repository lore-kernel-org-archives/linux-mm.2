Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDB02C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 03:17:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1DED6B00B6; Mon, 14 Sep 2026 23:17:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CEFE6B00B8; Mon, 14 Sep 2026 23:17:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E2B96B00B9; Mon, 14 Sep 2026 23:17:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5E3AE6B00B6
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 23:17:10 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C8A731A02EF
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:17:09 +0000 (UTC)
X-FDA: 85214535378.09.FA5DD14
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf27.hostedemail.com (Postfix) with ESMTP id 723514000D
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:17:07 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789442228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LG3SPoSFUGEgZI80OSx/VKBcdn6WvsJNqd8eM3KZWoY=;
	b=bVALn9QMEGEM2bRn6I5d4yPCNRzgtDM/sQHCA/FdusU4WC90sbdD/SzhH4K+pR5bB14eKb
	WojBvuuCSDvKDIt0avQGvczl3psTejkOMYcv3MTCJd0JrrvrJU3mzl3bMto3K2m5utShLA
	eoDSBgE/eZg4JwsukDgLXUgq24EHa7o=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789442228;
	b=LRiXwzNORTyhoyM30HQuB8mEjnmmpkndClkgcemtZYXOu0qezchplPH9XPUZp9SpP46/wB
	Igmqtk9hIxIjoHcxOv4EMgC5EbZhl8qGDxRLCls9lv329MSqjvEgoCTEcNloSTsKltn5mw
	0si2PL/wbxlRQstFsZuSc2Xww+rSGVQ=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 15 Sep 2026 12:17:05 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Chris Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Pavel Machek <pavel@kernel.org>,
	Len Brown <lenb@kernel.org>,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	her0gyugyu@gmail.com,
	youngjun.park@lge.com,
	taejoon.song@lge.com
Subject: [RFC PATCH 03/10] mm, swap: move hibernation swap code to mm/swap_hibernate.c
Date: Tue, 15 Sep 2026 12:16:51 +0900
Message-Id: <20260915031658.1505680-4-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260915031658.1505680-1-youngjun.park@lge.com>
References: <20260915031658.1505680-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 3h7e1k3iojjerggs7r9h51sh6skjwcfm
X-Rspamd-Queue-Id: 723514000D
X-Rspamd-Server: rspam07
X-HE-Tag: 1789442227-269057
X-HE-Meta: U2FsdGVkX19BX6F2ZOzitzmZOBVxQ2N3DA34t37jW1QT1zF9/ZlYS+QM+PuFTSFqKoSKKyIWcIddrxPk3i1HsJEtzZOCxQQOCkpkLyHPSF2IQm+tugRY/MD+r2tjqn+568WOEpNW0ucq9Bwdv5p4kMpw/G5pmBiHjgMsOQqF4DScOyTzNvvI7GwyytF0VG5aDLVR5eVxizDdp6yjehsW4spWYmtHCN2TRCdH7zqb2fQdcBKH53ZPPnscfzoQFPPlDiBWYvD0stLZiyG8NfVdYy/p3aq455cqAM9C3B99ZyYrDcO9Rqs0TmCiIs2Wo/3O/AWaXpzbylo246dbla0jSnzjdCtVl6agHv7jQjjOXP+rO+LIOanDTtovTLLfLA6y9w85Ek61FcJ07AAEQUMKJw4o+SV9LtKdeRDJnKDqnx7xcVfq5Wygp7igyi+O2c3WX6L8xHrq7tY3/HljhQibGrBH7+ICU9KMZk27qmKl3VyUxTqtyI0I0BRRbF4NI5PJg0XlcL+QAsUZCzoaY7TWKRgSdNx6CwVw+sgeMxuTw37vLhLFHi1Ex0F8Cbsc/SXcTwhwKI5nNhQd/8Sxu3VhgMbBl+KkuqgOVZVWTj7BgDRO9AZZxhsZ1U9shgY18SsGUBC1QHDZ1aEiT2Qf66bkKJ7jzSj6hnMBFTV2DtlaZn9avinDHlgByqKuS/94u0/9UGrlDqhSKPGs63s9Rj8ezYP9IuBIRnOyxC9QBp/rHjj/XWluL/B145EiMpdGR3wjGGSj7SqSl7u7uUms9Fw1+B9j3pZ84O0OAqtQm+6D96LWd1ngTH50JpcEK6tRQAlC7o1Bspb3I41Sf4Xauo5PBu0SVmp9p1bsfdfrtssPDkamW3PARqup4HwzyEVeXf5mCV+ffmMdgWGzXCTHfiQ+u3aUxkTcawglsYePV5j051Hwf7y5gaMz5osv5S8BBuAdlRGYoFo/H082vSBiYEq
 1EMNg7RA
 QZTNQqgqYflKb2Hu4xDfoZ7snYE8U8sWKW/qOIvX3Unyg9ig3U6f4S/XFFr6sxkmLEIyU8zbeGvcFp7bb6avDn+da/FPWTIkJfnFfPCDE1RwZ5Ej9jrhHTabX/DTPcCG0RnmZZLvH/Wl2KtEJkh1Qt3OE3Iw+xALL06x5QLaAwWEu1jS0807obd5ApMcyx98MigvCJPHPdL6rRXk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The hibernation parts of mm/swapfile.c are mixed in with the allocator.
Move them to their own file so they are easier to read and maintain.

The file is #included from swapfile.c, so the allocator's data
structures stay private.

No functional change.

Assisted-by: Claude:claude-opus-5
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 MAINTAINERS         |   1 +
 mm/swap_hibernate.c | 316 ++++++++++++++++++++++++++++++++++++++++++++
 mm/swapfile.c       | 311 +------------------------------------------
 3 files changed, 318 insertions(+), 310 deletions(-)
 create mode 100644 mm/swap_hibernate.c

diff --git a/MAINTAINERS b/MAINTAINERS
index e4412c3d8d45..8273f220ae90 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17408,6 +17408,7 @@ F:	include/linux/swapfile.h
 F:	include/linux/swapops.h
 F:	mm/page_io.c
 F:	mm/swap.h
+F:	mm/swap_hibernate.c
 F:	mm/swap_table.h
 F:	mm/swap_state.c
 F:	mm/swapfile.c
diff --git a/mm/swap_hibernate.c b/mm/swap_hibernate.c
new file mode 100644
index 000000000000..45359b664f46
--- /dev/null
+++ b/mm/swap_hibernate.c
@@ -0,0 +1,316 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Hibernation support for swap.  Included by mm/swapfile.c so that it can
+ * use the allocator's static helpers.
+ */
+
+/**
+ * swap_alloc_hibernation_slot() - Allocate a swap slot for hibernation.
+ * @type: swap device type index to allocate from.
+ *
+ * The caller must ensure the swap device is stable, either by pinning
+ * it (SWP_HIBERNATION) or by freezing user-space.
+ *
+ * Return: a valid swp_entry_t on success, or an empty entry (val == 0)
+ * on failure.
+ */
+swp_entry_t swap_alloc_hibernation_slot(int type)
+{
+	struct swap_info_struct *pcp_si, *si = swap_type_to_info(type);
+	unsigned long pcp_offset, offset = SWAP_ENTRY_INVALID;
+	struct swap_cluster_info *ci;
+	swp_entry_t entry = {0};
+
+	if (!si)
+		goto fail;
+
+	/*
+	 * Try the local cluster first if it matches the device. If
+	 * not, try grab a new cluster and override local cluster.
+	 */
+	local_lock(&percpu_swap_cluster.lock);
+	pcp_si = this_cpu_read(percpu_swap_cluster.si[0]);
+	pcp_offset = this_cpu_read(percpu_swap_cluster.offset[0]);
+	if (pcp_si == si && pcp_offset) {
+		ci = swap_cluster_lock(si, pcp_offset);
+		if (cluster_is_usable(ci, 0))
+			offset = alloc_swap_scan_cluster(si, ci, NULL, pcp_offset);
+		else
+			swap_cluster_unlock(ci);
+	}
+	if (!offset)
+		offset = cluster_alloc_swap_entry(si, NULL);
+	local_unlock(&percpu_swap_cluster.lock);
+	if (offset)
+		entry = swp_entry(si->type, offset);
+
+fail:
+	return entry;
+}
+
+/**
+ * swap_free_hibernation_slot() - Free a swap slot allocated for hibernation.
+ * @entry: swap entry to free.
+ *
+ * The caller must ensure the swap device is stable.
+ */
+void swap_free_hibernation_slot(swp_entry_t entry)
+{
+	struct swap_info_struct *si = __swap_entry_to_info(entry);
+	struct swap_cluster_info *ci;
+	pgoff_t offset = swp_offset(entry);
+
+	ci = swap_cluster_lock(si, offset);
+	__swap_cluster_free_entries(si, ci, offset % SWAPFILE_CLUSTER, 1);
+	swap_cluster_unlock(ci);
+}
+
+static int __find_hibernation_swap_type(dev_t device, sector_t offset)
+{
+	int type;
+
+	lockdep_assert_held(&swap_lock);
+
+	if (!device)
+		return -EINVAL;
+
+	for (type = 0; type < nr_swapfiles; type++) {
+		struct swap_info_struct *sis = swap_info[type];
+
+		if (!(sis->flags & SWP_WRITEOK) || !sis->bdev)
+			continue;
+
+		if (device == sis->bdev->bd_dev) {
+			struct swap_extent *se = first_se(sis);
+
+			if (se->start_block == offset)
+				return type;
+		}
+	}
+	return -ENODEV;
+}
+
+/**
+ * pin_hibernation_swap_type - Pin the swap device for hibernation
+ * @device: Block device containing the resume image
+ * @offset: Offset identifying the swap area
+ *
+ * Locate the swap device for @device/@offset and mark it as pinned
+ * for hibernation. While pinned, swapoff() is prevented.
+ *
+ * Only one uswsusp context may pin a swap device at a time.
+ * If already pinned, this function returns -EBUSY.
+ *
+ * Return:
+ * >= 0 on success (swap type).
+ * -EINVAL if @device is invalid.
+ * -ENODEV if the swap device is not found.
+ * -EBUSY if the device is already pinned for hibernation.
+ */
+int pin_hibernation_swap_type(dev_t device, sector_t offset)
+{
+	int type;
+	struct swap_info_struct *si;
+
+	spin_lock(&swap_lock);
+
+	type = __find_hibernation_swap_type(device, offset);
+	if (type < 0) {
+		spin_unlock(&swap_lock);
+		return type;
+	}
+
+	si = swap_type_to_info(type);
+	if (WARN_ON_ONCE(!si)) {
+		spin_unlock(&swap_lock);
+		return -ENODEV;
+	}
+
+	/*
+	 * hibernate_acquire() prevents concurrent hibernation sessions.
+	 * This check additionally guards against double-pinning within
+	 * the same session.
+	 */
+	if (WARN_ON_ONCE(si->flags & SWP_HIBERNATION)) {
+		spin_unlock(&swap_lock);
+		return -EBUSY;
+	}
+
+	si->flags |= SWP_HIBERNATION;
+
+	spin_unlock(&swap_lock);
+	return type;
+}
+
+/**
+ * repin_hibernation_swap_type - Atomically replace the hibernation pin
+ * @old_type: Swap type currently pinned (or < 0 if none).
+ * @device:   Block device of the new resume image.
+ * @offset:   Offset identifying the new swap area.
+ *
+ * Look up the swap device for @device/@offset and atomically transfer
+ * the SWP_HIBERNATION pin from @old_type (if valid) to the new device,
+ * all under a single swap_lock critical section. This closes the
+ * swapoff() window that exists when callers unpin and re-pin in two
+ * separate operations.
+ *
+ * If the new device cannot be located, the existing pin on @old_type
+ * is preserved and an error is returned. If @old_type already refers
+ * to the same swap_info_struct as the new lookup, no flag changes are
+ * made and @old_type is returned.
+ *
+ * Return:
+ * >= 0 on success (new swap type).
+ * -EINVAL if @device is invalid.
+ * -ENODEV if the swap device is not found.
+ * -EBUSY  if the new device is already pinned by another context.
+ */
+int repin_hibernation_swap_type(int old_type, dev_t device, sector_t offset)
+{
+	struct swap_info_struct *old_si, *new_si;
+	int new_type;
+
+	spin_lock(&swap_lock);
+
+	new_type = __find_hibernation_swap_type(device, offset);
+	if (new_type < 0) {
+		spin_unlock(&swap_lock);
+		return new_type;
+	}
+
+	new_si = swap_type_to_info(new_type);
+	if (WARN_ON_ONCE(!new_si)) {
+		spin_unlock(&swap_lock);
+		return -ENODEV;
+	}
+
+	old_si = swap_type_to_info(old_type);
+	if (new_si == old_si) {
+		spin_unlock(&swap_lock);
+		return new_type;
+	}
+
+	if (WARN_ON_ONCE(new_si->flags & SWP_HIBERNATION)) {
+		spin_unlock(&swap_lock);
+		return -EBUSY;
+	}
+
+	if (old_si)
+		old_si->flags &= ~SWP_HIBERNATION;
+	new_si->flags |= SWP_HIBERNATION;
+
+	spin_unlock(&swap_lock);
+	return new_type;
+}
+
+/**
+ * unpin_hibernation_swap_type - Unpin the swap device for hibernation
+ * @type: Swap type previously returned by pin_hibernation_swap_type()
+ *
+ * Clear the hibernation pin on the given swap device, allowing
+ * swapoff() to proceed normally.
+ *
+ * If @type does not refer to a valid swap device, this function
+ * does nothing.
+ */
+void unpin_hibernation_swap_type(int type)
+{
+	struct swap_info_struct *si;
+
+	spin_lock(&swap_lock);
+	si = swap_type_to_info(type);
+	if (!si) {
+		spin_unlock(&swap_lock);
+		return;
+	}
+	si->flags &= ~SWP_HIBERNATION;
+	spin_unlock(&swap_lock);
+}
+
+/**
+ * find_hibernation_swap_type - Find swap type for hibernation
+ * @device: Block device containing the resume image
+ * @offset: Offset within the device identifying the swap area
+ *
+ * Locate the swap device corresponding to @device and @offset.
+ *
+ * Unlike pin_hibernation_swap_type(), this function only performs a
+ * lookup and does not mark the swap device as pinned for hibernation.
+ *
+ * This is safe in the sysfs-based hibernation path where user space
+ * is already frozen and swapoff() cannot run concurrently.
+ *
+ * Return:
+ * A non-negative swap type on success.
+ * -EINVAL if @device is invalid.
+ * -ENODEV if no matching swap device is found.
+ */
+int find_hibernation_swap_type(dev_t device, sector_t offset)
+{
+	int type;
+
+	spin_lock(&swap_lock);
+	type = __find_hibernation_swap_type(device, offset);
+	spin_unlock(&swap_lock);
+
+	return type;
+}
+
+int find_first_swap(dev_t *device)
+{
+	int type;
+
+	spin_lock(&swap_lock);
+	for (type = 0; type < nr_swapfiles; type++) {
+		struct swap_info_struct *sis = swap_info[type];
+
+		if (!(sis->flags & SWP_WRITEOK) || !sis->bdev)
+			continue;
+		*device = sis->bdev->bd_dev;
+		spin_unlock(&swap_lock);
+		return type;
+	}
+	spin_unlock(&swap_lock);
+	return -ENODEV;
+}
+
+/*
+ * Get the (PAGE_SIZE) block corresponding to given offset on the swapdev
+ * corresponding to given index in swap_info (swap type).
+ */
+sector_t swapdev_block(int type, pgoff_t offset)
+{
+	struct swap_info_struct *si = swap_type_to_info(type);
+	struct swap_extent *se;
+
+	if (!si || !(si->flags & SWP_WRITEOK))
+		return 0;
+	se = offset_to_swap_extent(si, offset);
+	return se->start_block + (offset - se->start_page);
+}
+
+/*
+ * Return either the total number of swap pages of given type, or the number
+ * of free pages of that type (depending on @free)
+ *
+ * This is needed for software suspend
+ */
+unsigned int count_swap_pages(int type, int free)
+{
+	unsigned int n = 0;
+
+	spin_lock(&swap_lock);
+	if ((unsigned int)type < nr_swapfiles) {
+		struct swap_info_struct *sis = swap_info[type];
+
+		spin_lock(&sis->lock);
+		if (sis->flags & SWP_WRITEOK) {
+			n = sis->pages;
+			if (free)
+				n -= swap_usage_in_pages(sis);
+		}
+		spin_unlock(&sis->lock);
+	}
+	spin_unlock(&swap_lock);
+	return n;
+}
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 655f2647472c..07aefb782fbe 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2165,316 +2165,7 @@ void swap_put_entries_direct(swp_entry_t entry, int nr)
 }
 
 #ifdef CONFIG_HIBERNATION
-/**
- * swap_alloc_hibernation_slot() - Allocate a swap slot for hibernation.
- * @type: swap device type index to allocate from.
- *
- * The caller must ensure the swap device is stable, either by pinning
- * it (SWP_HIBERNATION) or by freezing user-space.
- *
- * Return: a valid swp_entry_t on success, or an empty entry (val == 0)
- * on failure.
- */
-swp_entry_t swap_alloc_hibernation_slot(int type)
-{
-	struct swap_info_struct *pcp_si, *si = swap_type_to_info(type);
-	unsigned long pcp_offset, offset = SWAP_ENTRY_INVALID;
-	struct swap_cluster_info *ci;
-	swp_entry_t entry = {0};
-
-	if (!si)
-		goto fail;
-
-	/*
-	 * Try the local cluster first if it matches the device. If
-	 * not, try grab a new cluster and override local cluster.
-	 */
-	local_lock(&percpu_swap_cluster.lock);
-	pcp_si = this_cpu_read(percpu_swap_cluster.si[0]);
-	pcp_offset = this_cpu_read(percpu_swap_cluster.offset[0]);
-	if (pcp_si == si && pcp_offset) {
-		ci = swap_cluster_lock(si, pcp_offset);
-		if (cluster_is_usable(ci, 0))
-			offset = alloc_swap_scan_cluster(si, ci, NULL, pcp_offset);
-		else
-			swap_cluster_unlock(ci);
-	}
-	if (!offset)
-		offset = cluster_alloc_swap_entry(si, NULL);
-	local_unlock(&percpu_swap_cluster.lock);
-	if (offset)
-		entry = swp_entry(si->type, offset);
-
-fail:
-	return entry;
-}
-
-/**
- * swap_free_hibernation_slot() - Free a swap slot allocated for hibernation.
- * @entry: swap entry to free.
- *
- * The caller must ensure the swap device is stable.
- */
-void swap_free_hibernation_slot(swp_entry_t entry)
-{
-	struct swap_info_struct *si = __swap_entry_to_info(entry);
-	struct swap_cluster_info *ci;
-	pgoff_t offset = swp_offset(entry);
-
-	ci = swap_cluster_lock(si, offset);
-	__swap_cluster_free_entries(si, ci, offset % SWAPFILE_CLUSTER, 1);
-	swap_cluster_unlock(ci);
-}
-
-static int __find_hibernation_swap_type(dev_t device, sector_t offset)
-{
-	int type;
-
-	lockdep_assert_held(&swap_lock);
-
-	if (!device)
-		return -EINVAL;
-
-	for (type = 0; type < nr_swapfiles; type++) {
-		struct swap_info_struct *sis = swap_info[type];
-
-		if (!(sis->flags & SWP_WRITEOK) || !sis->bdev)
-			continue;
-
-		if (device == sis->bdev->bd_dev) {
-			struct swap_extent *se = first_se(sis);
-
-			if (se->start_block == offset)
-				return type;
-		}
-	}
-	return -ENODEV;
-}
-
-/**
- * pin_hibernation_swap_type - Pin the swap device for hibernation
- * @device: Block device containing the resume image
- * @offset: Offset identifying the swap area
- *
- * Locate the swap device for @device/@offset and mark it as pinned
- * for hibernation. While pinned, swapoff() is prevented.
- *
- * Only one uswsusp context may pin a swap device at a time.
- * If already pinned, this function returns -EBUSY.
- *
- * Return:
- * >= 0 on success (swap type).
- * -EINVAL if @device is invalid.
- * -ENODEV if the swap device is not found.
- * -EBUSY if the device is already pinned for hibernation.
- */
-int pin_hibernation_swap_type(dev_t device, sector_t offset)
-{
-	int type;
-	struct swap_info_struct *si;
-
-	spin_lock(&swap_lock);
-
-	type = __find_hibernation_swap_type(device, offset);
-	if (type < 0) {
-		spin_unlock(&swap_lock);
-		return type;
-	}
-
-	si = swap_type_to_info(type);
-	if (WARN_ON_ONCE(!si)) {
-		spin_unlock(&swap_lock);
-		return -ENODEV;
-	}
-
-	/*
-	 * hibernate_acquire() prevents concurrent hibernation sessions.
-	 * This check additionally guards against double-pinning within
-	 * the same session.
-	 */
-	if (WARN_ON_ONCE(si->flags & SWP_HIBERNATION)) {
-		spin_unlock(&swap_lock);
-		return -EBUSY;
-	}
-
-	si->flags |= SWP_HIBERNATION;
-
-	spin_unlock(&swap_lock);
-	return type;
-}
-
-/**
- * repin_hibernation_swap_type - Atomically replace the hibernation pin
- * @old_type: Swap type currently pinned (or < 0 if none).
- * @device:   Block device of the new resume image.
- * @offset:   Offset identifying the new swap area.
- *
- * Look up the swap device for @device/@offset and atomically transfer
- * the SWP_HIBERNATION pin from @old_type (if valid) to the new device,
- * all under a single swap_lock critical section. This closes the
- * swapoff() window that exists when callers unpin and re-pin in two
- * separate operations.
- *
- * If the new device cannot be located, the existing pin on @old_type
- * is preserved and an error is returned. If @old_type already refers
- * to the same swap_info_struct as the new lookup, no flag changes are
- * made and @old_type is returned.
- *
- * Return:
- * >= 0 on success (new swap type).
- * -EINVAL if @device is invalid.
- * -ENODEV if the swap device is not found.
- * -EBUSY  if the new device is already pinned by another context.
- */
-int repin_hibernation_swap_type(int old_type, dev_t device, sector_t offset)
-{
-	struct swap_info_struct *old_si, *new_si;
-	int new_type;
-
-	spin_lock(&swap_lock);
-
-	new_type = __find_hibernation_swap_type(device, offset);
-	if (new_type < 0) {
-		spin_unlock(&swap_lock);
-		return new_type;
-	}
-
-	new_si = swap_type_to_info(new_type);
-	if (WARN_ON_ONCE(!new_si)) {
-		spin_unlock(&swap_lock);
-		return -ENODEV;
-	}
-
-	old_si = swap_type_to_info(old_type);
-	if (new_si == old_si) {
-		spin_unlock(&swap_lock);
-		return new_type;
-	}
-
-	if (WARN_ON_ONCE(new_si->flags & SWP_HIBERNATION)) {
-		spin_unlock(&swap_lock);
-		return -EBUSY;
-	}
-
-	if (old_si)
-		old_si->flags &= ~SWP_HIBERNATION;
-	new_si->flags |= SWP_HIBERNATION;
-
-	spin_unlock(&swap_lock);
-	return new_type;
-}
-
-/**
- * unpin_hibernation_swap_type - Unpin the swap device for hibernation
- * @type: Swap type previously returned by pin_hibernation_swap_type()
- *
- * Clear the hibernation pin on the given swap device, allowing
- * swapoff() to proceed normally.
- *
- * If @type does not refer to a valid swap device, this function
- * does nothing.
- */
-void unpin_hibernation_swap_type(int type)
-{
-	struct swap_info_struct *si;
-
-	spin_lock(&swap_lock);
-	si = swap_type_to_info(type);
-	if (!si) {
-		spin_unlock(&swap_lock);
-		return;
-	}
-	si->flags &= ~SWP_HIBERNATION;
-	spin_unlock(&swap_lock);
-}
-
-/**
- * find_hibernation_swap_type - Find swap type for hibernation
- * @device: Block device containing the resume image
- * @offset: Offset within the device identifying the swap area
- *
- * Locate the swap device corresponding to @device and @offset.
- *
- * Unlike pin_hibernation_swap_type(), this function only performs a
- * lookup and does not mark the swap device as pinned for hibernation.
- *
- * This is safe in the sysfs-based hibernation path where user space
- * is already frozen and swapoff() cannot run concurrently.
- *
- * Return:
- * A non-negative swap type on success.
- * -EINVAL if @device is invalid.
- * -ENODEV if no matching swap device is found.
- */
-int find_hibernation_swap_type(dev_t device, sector_t offset)
-{
-	int type;
-
-	spin_lock(&swap_lock);
-	type = __find_hibernation_swap_type(device, offset);
-	spin_unlock(&swap_lock);
-
-	return type;
-}
-
-int find_first_swap(dev_t *device)
-{
-	int type;
-
-	spin_lock(&swap_lock);
-	for (type = 0; type < nr_swapfiles; type++) {
-		struct swap_info_struct *sis = swap_info[type];
-
-		if (!(sis->flags & SWP_WRITEOK) || !sis->bdev)
-			continue;
-		*device = sis->bdev->bd_dev;
-		spin_unlock(&swap_lock);
-		return type;
-	}
-	spin_unlock(&swap_lock);
-	return -ENODEV;
-}
-
-/*
- * Get the (PAGE_SIZE) block corresponding to given offset on the swapdev
- * corresponding to given index in swap_info (swap type).
- */
-sector_t swapdev_block(int type, pgoff_t offset)
-{
-	struct swap_info_struct *si = swap_type_to_info(type);
-	struct swap_extent *se;
-
-	if (!si || !(si->flags & SWP_WRITEOK))
-		return 0;
-	se = offset_to_swap_extent(si, offset);
-	return se->start_block + (offset - se->start_page);
-}
-
-/*
- * Return either the total number of swap pages of given type, or the number
- * of free pages of that type (depending on @free)
- *
- * This is needed for software suspend
- */
-unsigned int count_swap_pages(int type, int free)
-{
-	unsigned int n = 0;
-
-	spin_lock(&swap_lock);
-	if ((unsigned int)type < nr_swapfiles) {
-		struct swap_info_struct *sis = swap_info[type];
-
-		spin_lock(&sis->lock);
-		if (sis->flags & SWP_WRITEOK) {
-			n = sis->pages;
-			if (free)
-				n -= swap_usage_in_pages(sis);
-		}
-		spin_unlock(&sis->lock);
-	}
-	spin_unlock(&swap_lock);
-	return n;
-}
+#include "swap_hibernate.c"
 #endif /* CONFIG_HIBERNATION */
 
 static inline int pte_same_as_swp(pte_t pte, pte_t swp_pte)
-- 
2.48.1


