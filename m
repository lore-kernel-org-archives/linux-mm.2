Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26028107528B
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 09:56:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EA666B0455; Thu, 19 Mar 2026 05:56:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 194DC6B0456; Thu, 19 Mar 2026 05:56:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 083216B0457; Thu, 19 Mar 2026 05:56:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E621F6B0455
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 05:56:04 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9459F1A0436
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 09:56:04 +0000 (UTC)
X-FDA: 84562356648.26.AAEE7FD
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf26.hostedemail.com (Postfix) with ESMTP id 85E9B140007
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 09:56:01 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FHjHsh3D;
	spf=pass (imf26.hostedemail.com: domain of yuan1.liu@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773914162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=dSF7XRJkn63l0FysodrySsOm0YEYHh+VHQsQRQ2PNiU=;
	b=TwDcpyDtS2H15lrMzNcnNG5NpHZZxXrwSD7KSf5yJWTpFRVLic/lF6d1XByWRxb+DFWAx1
	ExKcqX2QMAiaGBXEyAJUy8KH0SAyzzFQBozxkKI1PtxJa8sn7zSW7lBhdbkWA8E1tz60Rf
	+mjttg/Icu8kIXBZds72oJY51o6zhuk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FHjHsh3D;
	spf=pass (imf26.hostedemail.com: domain of yuan1.liu@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773914162; a=rsa-sha256;
	cv=none;
	b=VJKzgx30STdNbkXU1nCVshhKhdWvSeeQ8YHwB6AYZOPnDh/pADpkMkOKPFiTt8Zj3JpOB7
	eS7oStdo+Mnx4LUPk6NS18HjbFwuWsHRHcl3GBMfZixnsLhoiywyNBM9gKIMsSTwFKUljo
	msOULbpBXAhQZicFu7CVte12adYukJY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773914162; x=1805450162;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=iXBuPzApwsDZn14dVbQbPHpb9MhfNh/ERqUvWTcGU+o=;
  b=FHjHsh3DSJ1ul4z15M6B8d/UvJ5ELs6MwTSJS/caY1XIrDLY+S6/A2bv
   C/Xl/Jm+bkecgfoeiFctskzdBOCyw9ow2xNCC1zBp0Q+MJfnCetI5m6W8
   9T/019eBUQyQCPOsZl4fpcGJI/ADykENx05Sql084KCU7cz4hwWLMAEZ6
   UtRgt/wn24/6liLGSRGOM2DUHuPMxLtIsxZi2tsylm88En/MsSYcWG8ol
   6ne2gpvIRbe9WAAQVNY3mVdSYXZs/n2yoaklg9AO92kcVfkr+Yl/kQdXJ
   VoNPsBfG6za1jqUzfHuUbTYW+QptZ3gE9AyjjsS7ySJbCATQ8ig9d8RjT
   A==;
X-CSE-ConnectionGUID: 0vcSbAPCR6OolcA/zQ6dwg==
X-CSE-MsgGUID: lD4Vux4UQdGB+3r3RySjMg==
X-IronPort-AV: E=McAfee;i="6800,10657,11733"; a="74955833"
X-IronPort-AV: E=Sophos;i="6.23,129,1770624000"; 
   d="scan'208";a="74955833"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2026 02:56:00 -0700
X-CSE-ConnectionGUID: m6wpcnzpSsaBZFJICGO/3Q==
X-CSE-MsgGUID: 0ys+HpxwSnCgCHmhzCMQZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,129,1770624000"; 
   d="scan'208";a="227035362"
Received: from spr10.sh.intel.com (HELO localhost) ([10.239.23.75])
  by orviesa003.jf.intel.com with ESMTP; 19 Mar 2026 02:55:55 -0700
From: Yuan Liu <yuan1.liu@intel.com>
To: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>
Cc: linux-mm@kvack.org,
	Yong Hu <yong.hu@intel.com>,
	Nanhai Zou <nanhai.zou@intel.com>,
	Yuan Liu <yuan1.liu@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Yu C Chen <yu.c.chen@intel.com>,
	Pan Deng <pan.deng@intel.com>,
	Tianyou Li <tianyou.li@intel.com>,
	Chen Zhang <zhangchen.kidd@jd.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/memory hotplug/unplug: Optimize zone contiguous check when changing pfn range
Date: Thu, 19 Mar 2026 05:56:22 -0400
Message-ID: <20260319095622.1130380-1-yuan1.liu@intel.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: oab9m4sjfhsdazaqchhahdbqmzzukhxm
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 85E9B140007
X-HE-Tag: 1773914161-607602
X-HE-Meta: U2FsdGVkX1+O6WJaTqK/wolDIQs8GNQHSV8BAChsXXf25+Lo+L5aYBs3miQQXbVjGaPC6OBA4Zcd+/6OcYxEypkUJTSdx6cFg8cQRikMvXWgecsEKk7x2CGWYNSC8hyTFpsYz7lwZO268kwfwLGOCQLxRL0x/v1zqLBN//L0e1uQHQhngg6xiyRUyuxO+0tekauLBYAlHg+7jegay+op5nswdYSdOK+O6SmPiXbN9qzflnsuL+vi7RdgxNHHbwPc5t9o5wr6NuxkGBdY9YZo6xLRthfY4dG/D9FZz0LBqPm3UbEWhZvFg3u4L4bsx9jNMciUk5XFhBWo50zbkERFauRgotvwBvjMqdaQ5NgLUunbbeL+m4+3apDdWfomSg+cUMuVnUomKpWZA8LzM1svtjt2FFDc2uM3rto/gFXNhN8SRlJRM7l6aM+NACDe2m7e7t5Ghkoa78JAfDMQCvIrDy92oo9hVUtlIRzeypdPbxAFd0nHU59Tj0iwBNuV/r09RDSOzd4widtt07NRYDt78uiqpraTbSKPMSjo3azoHWAZVLmjoCPRTfCLth4uj48Y0Ky0mAVT1azAGtEJEJ9pAs3YTDFlP/bvqJuH8M37iEsHroDwpZobPfApSKlV0yY3ZHtUG0L7CnTavXzyRka1PyKY9wSoE8H9wNAY65cL2odRzIQX/QvZfcXYmguk4vkhNEhuUGk3d9gpV5X5f2JrNfqeJrt34e2bPI3cKvm3RDl2A0NdV6y6Aj4E87OzLbTVuBZHfvscRjS2xUL+cvRDgFLVeM5P8JfcDdO5utlCFCCEvJE302UD8l/B6rIUjDi5vHb426Nfvv4D2BkxRf31HMM1hxsXbDZpsixHWtH5p4T/PWPed5Pf6ufkWi9k43TVrl8ZC6/N1Cpq3ZQ7LU6B+uWx1WUdq2cJaZr0nM/JcvX3mJ3LqHfFWjxUKDb6lQIdxXwFGNHnuwk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When invoke move_pfn_range_to_zone or remove_pfn_range_from_zone, it will
update the zone->contiguous by checking the new zone's pfn range from the
beginning to the end, regardless the previous state of the old zone. When
the zone's pfn range is large, the cost of traversing the pfn range to
update the zone->contiguous could be significant.

Add a new zone's pages_with_memmap member, it is pages within the zone that
have an online memmap. It includes present pages and memory holes that have
a memmap. When spanned_pages == pages_with_online_memmap, pfn_to_page() can
be performed without further checks on any pfn within the zone span.

The following test cases of memory hotplug for a VM [1], tested in the
environment [2], show that this optimization can significantly reduce the
memory hotplug time [3].

+----------------+------+---------------+--------------+----------------+
|                | Size | Time (before) | Time (after) | Time Reduction |
|                +------+---------------+--------------+----------------+
| Plug Memory    | 256G |      10s      |      3s      |       70%      |
|                +------+---------------+--------------+----------------+
|                | 512G |      36s      |      7s      |       81%      |
+----------------+------+---------------+--------------+----------------+

+----------------+------+---------------+--------------+----------------+
|                | Size | Time (before) | Time (after) | Time Reduction |
|                +------+---------------+--------------+----------------+
| Unplug Memory  | 256G |      11s      |      4s      |       64%      |
|                +------+---------------+--------------+----------------+
|                | 512G |      36s      |      9s      |       75%      |
+----------------+------+---------------+--------------+----------------+

[1] Qemu commands to hotplug 256G/512G memory for a VM:
    object_add memory-backend-ram,id=hotmem0,size=256G/512G,share=on
    device_add virtio-mem-pci,id=vmem1,memdev=hotmem0,bus=port1
    qom-set vmem1 requested-size 256G/512G (Plug Memory)
    qom-set vmem1 requested-size 0G (Unplug Memory)

[2] Hardware     : Intel Icelake server
    Guest Kernel : v7.0-rc4
    Qemu         : v9.0.0

    Launch VM    :
    qemu-system-x86_64 -accel kvm -cpu host \
    -drive file=./Centos10_cloud.qcow2,format=qcow2,if=virtio \
    -drive file=./seed.img,format=raw,if=virtio \
    -smp 3,cores=3,threads=1,sockets=1,maxcpus=3 \
    -m 2G,slots=10,maxmem=2052472M \
    -device pcie-root-port,id=port1,bus=pcie.0,slot=1,multifunction=on \
    -device pcie-root-port,id=port2,bus=pcie.0,slot=2 \
    -nographic -machine q35 \
    -nic user,hostfwd=tcp::3000-:22

    Guest kernel auto-onlines newly added memory blocks:
    echo online > /sys/devices/system/memory/auto_online_blocks

[3] The time from typing the QEMU commands in [1] to when the output of
    'grep MemTotal /proc/meminfo' on Guest reflects that all hotplugged
    memory is recognized.

Reported-by: Nanhai Zou <nanhai.zou@intel.com>
Reported-by: Chen Zhang <zhangchen.kidd@jd.com>
Tested-by: Yuan Liu <yuan1.liu@intel.com>
Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
Reviewed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Reviewed-by: Yu C Chen <yu.c.chen@intel.com>
Reviewed-by: Pan Deng <pan.deng@intel.com>
Reviewed-by: Nanhai Zou <nanhai.zou@intel.com>
Reviewed-by: Yuan Liu <yuan1.liu@intel.com>
Co-developed-by: Tianyou Li <tianyou.li@intel.com>
Signed-off-by: Tianyou Li <tianyou.li@intel.com>
Signed-off-by: Yuan Liu <yuan1.liu@intel.com>
---
 Documentation/mm/physical_memory.rst |  6 +++++
 include/linux/mmzone.h               | 22 ++++++++++++++-
 mm/internal.h                        | 10 +++----
 mm/memory_hotplug.c                  | 21 +++++----------
 mm/mm_init.c                         | 40 +++++++++-------------------
 5 files changed, 50 insertions(+), 49 deletions(-)

diff --git a/Documentation/mm/physical_memory.rst b/Documentation/mm/physical_memory.rst
index b76183545e5b..d324da29ac11 100644
--- a/Documentation/mm/physical_memory.rst
+++ b/Documentation/mm/physical_memory.rst
@@ -483,6 +483,12 @@ General
   ``present_pages`` should use ``get_online_mems()`` to get a stable value. It
   is initialized by ``calculate_node_totalpages()``.
 
+``pages_with_online_memmap``
+  The pages_with_online_memmap is pages within the zone that have an online
+  memmap. It includes present pages and memory holes that have a memmap. When
+  spanned_pages == pages_with_online_memmap, pfn_to_page() can be performed
+  without further checks on any pfn within the zone span.
+
 ``present_early_pages``
   The present pages existing within the zone located on memory available since
   early boot, excluding hotplugged memory. Defined only when
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 3e51190a55e4..c7a136ce55c7 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -943,6 +943,11 @@ struct zone {
 	 * cma pages is present pages that are assigned for CMA use
 	 * (MIGRATE_CMA).
 	 *
+	 * pages_with_online_memmap is pages within the zone that have an online
+	 * memmap. It includes present pages and memory holes that have a memmap.
+	 * When spanned_pages == pages_with_online_memmap, pfn_to_page() can be
+	 * performed without further checks on any pfn within the zone span.
+	 *
 	 * So present_pages may be used by memory hotplug or memory power
 	 * management logic to figure out unmanaged pages by checking
 	 * (present_pages - managed_pages). And managed_pages should be used
@@ -967,6 +972,7 @@ struct zone {
 	atomic_long_t		managed_pages;
 	unsigned long		spanned_pages;
 	unsigned long		present_pages;
+	unsigned long		pages_with_online_memmap;
 #if defined(CONFIG_MEMORY_HOTPLUG)
 	unsigned long		present_early_pages;
 #endif
@@ -1051,7 +1057,6 @@ struct zone {
 	bool			compact_blockskip_flush;
 #endif
 
-	bool			contiguous;
 
 	CACHELINE_PADDING(_pad3_);
 	/* Zone statistics */
@@ -1124,6 +1129,21 @@ static inline bool zone_spans_pfn(const struct zone *zone, unsigned long pfn)
 	return zone->zone_start_pfn <= pfn && pfn < zone_end_pfn(zone);
 }
 
+/**
+ * zone_is_contiguous - test whether a zone is contiguous
+ * @zone: the zone to test.
+ *
+ * In a contiguous zone, it is valid to call pfn_to_page() on any pfn in the
+ * spanned zone without requiring pfn_valid() or pfn_to_online_page() checks.
+ *
+ * Returns: true if contiguous, otherwise false.
+ */
+static inline bool zone_is_contiguous(const struct zone *zone)
+{
+	return READ_ONCE(zone->spanned_pages) ==
+		READ_ONCE(zone->pages_with_online_memmap);
+}
+
 static inline bool zone_is_initialized(const struct zone *zone)
 {
 	return zone->initialized;
diff --git a/mm/internal.h b/mm/internal.h
index cb0af847d7d9..7c4c8ab68bde 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -793,21 +793,17 @@ extern struct page *__pageblock_pfn_to_page(unsigned long start_pfn,
 static inline struct page *pageblock_pfn_to_page(unsigned long start_pfn,
 				unsigned long end_pfn, struct zone *zone)
 {
-	if (zone->contiguous)
+	if (zone_is_contiguous(zone) && zone_spans_pfn(zone, start_pfn)) {
+		VM_BUG_ON(end_pfn > zone_end_pfn(zone));
 		return pfn_to_page(start_pfn);
+	}
 
 	return __pageblock_pfn_to_page(start_pfn, end_pfn, zone);
 }
 
-void set_zone_contiguous(struct zone *zone);
 bool pfn_range_intersects_zones(int nid, unsigned long start_pfn,
 			   unsigned long nr_pages);
 
-static inline void clear_zone_contiguous(struct zone *zone)
-{
-	zone->contiguous = false;
-}
-
 extern int __isolate_free_page(struct page *page, unsigned int order);
 extern void __putback_isolated_page(struct page *page, unsigned int order,
 				    int mt);
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index bc805029da51..2ba7a394a64b 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -492,11 +492,11 @@ static void shrink_zone_span(struct zone *zone, unsigned long start_pfn,
 		pfn = find_smallest_section_pfn(nid, zone, end_pfn,
 						zone_end_pfn(zone));
 		if (pfn) {
-			zone->spanned_pages = zone_end_pfn(zone) - pfn;
+			WRITE_ONCE(zone->spanned_pages, zone_end_pfn(zone) - pfn);
 			zone->zone_start_pfn = pfn;
 		} else {
 			zone->zone_start_pfn = 0;
-			zone->spanned_pages = 0;
+			WRITE_ONCE(zone->spanned_pages, 0);
 		}
 	} else if (zone_end_pfn(zone) == end_pfn) {
 		/*
@@ -508,10 +508,10 @@ static void shrink_zone_span(struct zone *zone, unsigned long start_pfn,
 		pfn = find_biggest_section_pfn(nid, zone, zone->zone_start_pfn,
 					       start_pfn);
 		if (pfn)
-			zone->spanned_pages = pfn - zone->zone_start_pfn + 1;
+			WRITE_ONCE(zone->spanned_pages, pfn - zone->zone_start_pfn + 1);
 		else {
 			zone->zone_start_pfn = 0;
-			zone->spanned_pages = 0;
+			WRITE_ONCE(zone->spanned_pages, 0);
 		}
 	}
 }
@@ -565,18 +565,13 @@ void remove_pfn_range_from_zone(struct zone *zone,
 
 	/*
 	 * Zone shrinking code cannot properly deal with ZONE_DEVICE. So
-	 * we will not try to shrink the zones - which is okay as
-	 * set_zone_contiguous() cannot deal with ZONE_DEVICE either way.
+	 * we will not try to shrink the zones.
 	 */
 	if (zone_is_zone_device(zone))
 		return;
 
-	clear_zone_contiguous(zone);
-
 	shrink_zone_span(zone, start_pfn, start_pfn + nr_pages);
 	update_pgdat_span(pgdat);
-
-	set_zone_contiguous(zone);
 }
 
 /**
@@ -753,8 +748,6 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
 	struct pglist_data *pgdat = zone->zone_pgdat;
 	int nid = pgdat->node_id;
 
-	clear_zone_contiguous(zone);
-
 	if (zone_is_empty(zone))
 		init_currently_empty_zone(zone, start_pfn, nr_pages);
 	resize_zone_range(zone, start_pfn, nr_pages);
@@ -782,8 +775,6 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
 	memmap_init_range(nr_pages, nid, zone_idx(zone), start_pfn, 0,
 			 MEMINIT_HOTPLUG, altmap, migratetype,
 			 isolate_pageblock);
-
-	set_zone_contiguous(zone);
 }
 
 struct auto_movable_stats {
@@ -1079,6 +1070,8 @@ void adjust_present_page_count(struct page *page, struct memory_group *group,
 	if (early_section(__pfn_to_section(page_to_pfn(page))))
 		zone->present_early_pages += nr_pages;
 	zone->present_pages += nr_pages;
+	WRITE_ONCE(zone->pages_with_online_memmap,
+		READ_ONCE(zone->pages_with_online_memmap) + nr_pages);
 	zone->zone_pgdat->node_present_pages += nr_pages;
 
 	if (group && movable)
diff --git a/mm/mm_init.c b/mm/mm_init.c
index df34797691bd..96690e550024 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -946,6 +946,7 @@ static void __init memmap_init_zone_range(struct zone *zone,
 	unsigned long zone_start_pfn = zone->zone_start_pfn;
 	unsigned long zone_end_pfn = zone_start_pfn + zone->spanned_pages;
 	int nid = zone_to_nid(zone), zone_id = zone_idx(zone);
+	unsigned long zone_hole_start, zone_hole_end;
 
 	start_pfn = clamp(start_pfn, zone_start_pfn, zone_end_pfn);
 	end_pfn = clamp(end_pfn, zone_start_pfn, zone_end_pfn);
@@ -957,8 +958,19 @@ static void __init memmap_init_zone_range(struct zone *zone,
 			  zone_end_pfn, MEMINIT_EARLY, NULL, MIGRATE_MOVABLE,
 			  false);
 
-	if (*hole_pfn < start_pfn)
+	WRITE_ONCE(zone->pages_with_online_memmap,
+		   READ_ONCE(zone->pages_with_online_memmap) +
+		   (end_pfn - start_pfn));
+
+	if (*hole_pfn < start_pfn) {
 		init_unavailable_range(*hole_pfn, start_pfn, zone_id, nid);
+		zone_hole_start = clamp(*hole_pfn, zone_start_pfn, zone_end_pfn);
+		zone_hole_end = clamp(start_pfn, zone_start_pfn, zone_end_pfn);
+		if (zone_hole_start < zone_hole_end)
+			WRITE_ONCE(zone->pages_with_online_memmap,
+				   READ_ONCE(zone->pages_with_online_memmap) +
+				   (zone_hole_end - zone_hole_start));
+	}
 
 	*hole_pfn = end_pfn;
 }
@@ -2261,28 +2273,6 @@ void __init init_cma_pageblock(struct page *page)
 }
 #endif
 
-void set_zone_contiguous(struct zone *zone)
-{
-	unsigned long block_start_pfn = zone->zone_start_pfn;
-	unsigned long block_end_pfn;
-
-	block_end_pfn = pageblock_end_pfn(block_start_pfn);
-	for (; block_start_pfn < zone_end_pfn(zone);
-			block_start_pfn = block_end_pfn,
-			 block_end_pfn += pageblock_nr_pages) {
-
-		block_end_pfn = min(block_end_pfn, zone_end_pfn(zone));
-
-		if (!__pageblock_pfn_to_page(block_start_pfn,
-					     block_end_pfn, zone))
-			return;
-		cond_resched();
-	}
-
-	/* We confirm that there is no hole */
-	zone->contiguous = true;
-}
-
 /*
  * Check if a PFN range intersects multiple zones on one or more
  * NUMA nodes. Specify the @nid argument if it is known that this
@@ -2311,7 +2301,6 @@ bool pfn_range_intersects_zones(int nid, unsigned long start_pfn,
 static void __init mem_init_print_info(void);
 void __init page_alloc_init_late(void)
 {
-	struct zone *zone;
 	int nid;
 
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
@@ -2345,9 +2334,6 @@ void __init page_alloc_init_late(void)
 	for_each_node_state(nid, N_MEMORY)
 		shuffle_free_memory(NODE_DATA(nid));
 
-	for_each_populated_zone(zone)
-		set_zone_contiguous(zone);
-
 	/* Initialize page ext after all struct pages are initialized. */
 	if (deferred_struct_pages)
 		page_ext_init();
-- 
2.47.3


