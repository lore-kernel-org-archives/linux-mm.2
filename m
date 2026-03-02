Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FD2AE9B37D
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 16:53:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B36FA6B0088; Mon,  2 Mar 2026 11:53:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB8056B0092; Mon,  2 Mar 2026 11:53:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E5016B0088; Mon,  2 Mar 2026 11:53:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 767DA6B0088
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 11:53:43 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3A4491B7047
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 16:53:43 +0000 (UTC)
X-FDA: 84501719526.18.DD870B8
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1A3E7140009
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 16:53:40 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772470421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4vqHa+f3riM2lMN0v5FCCdJh6rpVeYhOPqtu/VUqhec=;
	b=dc/Bn3J0ISNFCEWwe0WMZZrTtEgJkQ2kMbRoiJVYFZZGtBI2p0j56lRBvnirvJhbSYKTRV
	cIA6JHZy4mN7Nb9DUc93wSJxgNZWeUSF/xFzz+LrOdMO0MCxJ9IkakxIM3XsOl9nmrma+o
	ZbgXNDUuN7OQn8BD5Q4UtPNiqT9cmXY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772470421; a=rsa-sha256;
	cv=none;
	b=ZmsujgCc1IWN/Q1fJjlbJS2wyzbmTvlEw/NlvmH/7tY/2kblgKKzHO++dCVK/gCITCBmUJ
	vL55xEXLOR3O7oVpkE7O160ku2B7wPrCJOvuYefUdRADZih0v4ms0fbK8goesZvx3BnOZx
	/inyL/7bEbSkH1r5e0UwYXi+NSM8ZGU=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 3 Mar 2026 01:53:38 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: linux-pm@vger.kernel.org
Cc: linux-mm@kvack.org,
	rafael@kernel.org,
	lenb@kernel.org,
	pavel@kernel.org,
	akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org,
	youngjun.park@lge.com
Subject: [RFC PATCH 1/2] mm/swap: release swap reference on each hibernation slot allocation
Date: Tue,  3 Mar 2026 01:53:33 +0900
Message-Id: <20260302165334.1278479-2-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260302165334.1278479-1-youngjun.park@lge.com>
References: <20260302165334.1278479-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1A3E7140009
X-Stat-Signature: ayog3ix4aycdxgm8jkwu4qcbfyfsmdz5
X-Rspam-User: 
X-HE-Tag: 1772470420-534848
X-HE-Meta: U2FsdGVkX192fIMnM0UJseY9B48VOqW+vmj3/nROgPAlA4s0NqruqOxmMjM9J961hxrEVHzbej3+LlzYrpzd1ARXJQsK3SLSTyiUDPsz+24WUlGzQeNdJ1azOv7G9IoBnKzaTg/nJnNFxopyoW8e9M/px1si+onPLoRbwzkso8og/QG/rM+aUoRt1OT2dU61MCOW/58D+MdNFJzXSelmxIjiaEruVSjNWaDW+IswqvVp6d3YTMbnFkozFwGRcQnOAh5NtD4pV4QCfaBXIUvnOQRDmjjEGVyWYsibGvf5YQEk8DHgfMjxF8+rRbFIGuyQTgzhLla5nH3cAUhYOPQSuneVfMBbRPhrr2zfHj1oPiz6C3uL57YzWlUYIihzvpmye3XJ3UxsXu6zySFs8LqskXDvyI9IfG4Tislkj4rAl7Fvb0bnBvj+MjwVNfHVTOGBOV5R5FLYYGZSq4HhTIYjzYkEZgZuHJKLrOpuVvwuGsMD7mYUxcDGXoamUl2C0udZKRAlLAZA/aqvm+zpapA3UlT9ueBLfiRFQqxutsfsnGTZgWOsRi+Y7MiMEP9XbKED/ZtZjdCBQjQukV1td/G1IibVn7XTJ6jxRo6YBfivFuHBkTW/y1vRBZdgSAXcJT23hMngaykLKBlqyHXNlpwqAzrM/OOM0YfUXsu026dt6s27In/mFPqPTZ1ewRqLuiMlqV1hSSK6SzsY8Z6qe3/1zG2gsSGib0gN6hTO9Ssn+uKUKnqx4tm03gQFXFYuyOjlJFYVjaapSN+rVfis/m9KklUMtkVrGhSfrqRDCsbLDMtJmS19noqWQ9lmkgNDtvpwEr1nMjJEY0Tx3i2wY4fU9cK08kw74qThWrSD7Yh7ZQXCd9xSS3+4q1620KcSvxPKPPjC8t14b3ya+TuFFJBN8LRW8K/OD8IlLZxLhN5DaZXiCavDC05Nj8ZV6y8zF5KDV1KNxOMSWW4B+3o3dOo
 OJhImuPV
 Z2NKmk6gcHejONnpW753MYjN+Fu4w+6ls5xJbnE3h8xm64lIOGh30N3oRQrNLqICBRgR/WZGFDd/S09XJEDYutTMPYI4Z2+TIdMcwFfKnmTacqzcA1FsRJuhZI6WqI0UK8OW76Orlu2lo9ypElUG8KZMmlTYRdRJBtdfH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, only the swap type value is retrieved at lookup time without
holding a reference. If swapoff races after the type is acquired, the
type value becomes invalid and subsequent slot allocations operate on
a stale swap device.

Additionally, grabbing and releasing the reference on every slot
allocation is inefficient. The proper approach is to hold the reference
from the swap device lookup and release it once when it is no longer
needed.

This is a preparatory change. A subsequent commit will lift the
reference acquisition to the lookup site and replace the per-slot
acquire/release with a single reference held across the entire
hibernation swap operation.

Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 include/linux/swap.h |  1 +
 mm/swapfile.c        | 55 ++++++++++++++++++++++----------------------
 2 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 7a09df6977a5..37bf7cf21594 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -442,6 +442,7 @@ extern bool swap_entry_swapped(struct swap_info_struct *si, swp_entry_t entry);
 extern int swp_swapcount(swp_entry_t entry);
 struct backing_dev_info;
 extern struct swap_info_struct *get_swap_device(swp_entry_t entry);
+extern void put_swap_device_by_type(int type);
 sector_t swap_folio_sector(struct folio *folio);
 
 /*
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 915bc93964db..f505dd1f7571 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1860,6 +1860,10 @@ struct swap_info_struct *get_swap_device(swp_entry_t entry)
 	return NULL;
 }
 
+void put_swap_device_by_type(int type)
+{
+	percpu_ref_put(&swap_info[type]->users);
+}
 /*
  * Free a set of swap slots after their swap count dropped to zero, or will be
  * zero after putting the last ref (saves one __swap_cluster_put_entry call).
@@ -2085,30 +2089,28 @@ swp_entry_t swap_alloc_hibernation_slot(int type)
 		goto fail;
 
 	/* This is called for allocating swap entry, not cache */
-	if (get_swap_device_info(si)) {
-		if (si->flags & SWP_WRITEOK) {
-			/*
-			 * Try the local cluster first if it matches the device. If
-			 * not, try grab a new cluster and override local cluster.
-			 */
-			local_lock(&percpu_swap_cluster.lock);
-			pcp_si = this_cpu_read(percpu_swap_cluster.si[0]);
-			pcp_offset = this_cpu_read(percpu_swap_cluster.offset[0]);
-			if (pcp_si == si && pcp_offset) {
-				ci = swap_cluster_lock(si, pcp_offset);
-				if (cluster_is_usable(ci, 0))
-					offset = alloc_swap_scan_cluster(si, ci, NULL, pcp_offset);
-				else
-					swap_cluster_unlock(ci);
-			}
-			if (!offset)
-				offset = cluster_alloc_swap_entry(si, NULL);
-			local_unlock(&percpu_swap_cluster.lock);
-			if (offset)
-				entry = swp_entry(si->type, offset);
+	if (si->flags & SWP_WRITEOK) {
+		/*
+		 * Try the local cluster first if it matches the device. If
+		 * not, try grab a new cluster and override local cluster.
+		 */
+		local_lock(&percpu_swap_cluster.lock);
+		pcp_si = this_cpu_read(percpu_swap_cluster.si[0]);
+		pcp_offset = this_cpu_read(percpu_swap_cluster.offset[0]);
+		if (pcp_si == si && pcp_offset) {
+			ci = swap_cluster_lock(si, pcp_offset);
+			if (cluster_is_usable(ci, 0))
+				offset = alloc_swap_scan_cluster(si, ci, NULL, pcp_offset);
+			else
+				swap_cluster_unlock(ci);
 		}
-		put_swap_device(si);
+		if (!offset)
+			offset = cluster_alloc_swap_entry(si, NULL);
+		local_unlock(&percpu_swap_cluster.lock);
+		if (offset)
+			entry = swp_entry(si->type, offset);
 	}
+
 fail:
 	return entry;
 }
@@ -2116,14 +2118,10 @@ swp_entry_t swap_alloc_hibernation_slot(int type)
 /* Free a slot allocated by swap_alloc_hibernation_slot */
 void swap_free_hibernation_slot(swp_entry_t entry)
 {
-	struct swap_info_struct *si;
+	struct swap_info_struct *si = __swap_entry_to_info(entry);
 	struct swap_cluster_info *ci;
 	pgoff_t offset = swp_offset(entry);
 
-	si = get_swap_device(entry);
-	if (WARN_ON(!si))
-		return;
-
 	ci = swap_cluster_lock(si, offset);
 	__swap_cluster_put_entry(ci, offset % SWAPFILE_CLUSTER);
 	__swap_cluster_free_entries(si, ci, offset % SWAPFILE_CLUSTER, 1);
@@ -2131,7 +2129,6 @@ void swap_free_hibernation_slot(swp_entry_t entry)
 
 	/* In theory readahead might add it to the swap cache by accident */
 	__try_to_reclaim_swap(si, offset, TTRS_ANYWAY);
-	put_swap_device(si);
 }
 
 /*
@@ -2160,6 +2157,7 @@ int swap_type_of(dev_t device, sector_t offset)
 			struct swap_extent *se = first_se(sis);
 
 			if (se->start_block == offset) {
+				get_swap_device_info(sis);
 				spin_unlock(&swap_lock);
 				return type;
 			}
@@ -2180,6 +2178,7 @@ int find_first_swap(dev_t *device)
 		if (!(sis->flags & SWP_WRITEOK))
 			continue;
 		*device = sis->bdev->bd_dev;
+		get_swap_device_info(sis);
 		spin_unlock(&swap_lock);
 		return type;
 	}
-- 
2.34.1


