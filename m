Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5409CFF513A
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 03:16:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A85416B008A; Tue,  7 Apr 2026 23:16:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A359A6B008C; Tue,  7 Apr 2026 23:16:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FD936B0092; Tue,  7 Apr 2026 23:16:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7C7116B008A
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 23:16:08 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 36400BC162
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 03:16:08 +0000 (UTC)
X-FDA: 84633924816.10.3A68EE7
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf07.hostedemail.com (Postfix) with ESMTP id 694BD4000B
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 03:16:05 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IUovvs0U;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf07.hostedemail.com: domain of yuan1.liu@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775618166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=yUHLE93QkhZM1LqCKepiDzy4S2kK5yRAZk4gUpcCODg=;
	b=S8QV0ewY0ufI2ihvXyU2S56k/0e6mPsOZTSy83h4nG+YHA/qJq0UeHdRsB/z6uDJci+iOx
	qnwyz5CH80ruwA++g3UHm0JbZoiAlAeSh3hskQ+dXw5LsZCu0h0nyqbATI8nI5YlzRDqb7
	Pk349UzWFHf24M9/9l8ndXdk7lbXh1k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775618166; a=rsa-sha256;
	cv=none;
	b=OmqhdLKiXjsBEk/t8ynVb+eezySyVgyVaUWbtPmRkVsSgzNitqotxOy4XaXDGYqMAvKqpu
	yu0hY4YCvW6zzSt1D//eeYY1FGs/Hdptjv19TugaVk8JERMkHXLgQPk7pOcJhZa/+ijdjt
	6aqWBjGNUT2icNMVvDNvyNwGY+gEnKs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IUovvs0U;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf07.hostedemail.com: domain of yuan1.liu@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775618166; x=1807154166;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=gpa3Jo6F6ic5ermO6RPrV3+R36MC+pmyQh3f8Ogpkfw=;
  b=IUovvs0Ug/RR7awTnfiMMTb8feofXMuoqh2fq3LS9mC3jvxmBYbfsTO2
   ljNSTaQCXcjzd2btS4WaFrpn0tV0j05Dw349XghfeIe/BKGOqWIX4HGNm
   +EE5lCZV5uIKox9NoYwOclnCYrw/UQH4wk1e9CKjIT/lfEjCebv26jviN
   cfLz8aH33tQDqwk+fTKKcw80tN5cVp/B945qotwXPx/R4iGBxR5f1mcUD
   0D/rVilqUAwMFRdR2vPxGBR9tvRiUj+kfyNIETNJJkKMXmLGrDcxGTkR4
   dgZ6g4bD6PT9C94Q/6TbcCtbYGiFcIpN9XmPaH3lgz80b/DdDgGz8ryx8
   w==;
X-CSE-ConnectionGUID: zWwkUABzSJ6aQU/LWAqN9w==
X-CSE-MsgGUID: g3q95uqUQvSIE9LTdfNxVg==
X-IronPort-AV: E=McAfee;i="6800,10657,11752"; a="86883640"
X-IronPort-AV: E=Sophos;i="6.23,166,1770624000"; 
   d="scan'208";a="86883640"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2026 20:16:04 -0700
X-CSE-ConnectionGUID: 9J/28D83RLm5YCDfu1KpiQ==
X-CSE-MsgGUID: SKWVXrvlRmCLuuMysAds3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,166,1770624000"; 
   d="scan'208";a="223587880"
Received: from spr10.sh.intel.com (HELO localhost) ([10.239.23.75])
  by fmviesa006.fm.intel.com with ESMTP; 07 Apr 2026 20:16:00 -0700
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
Subject: [PATCH v3] mm/memory hotplug/unplug: Optimize zone contiguous check when changing pfn range
Date: Tue,  7 Apr 2026 23:16:15 -0400
Message-ID: <20260408031615.1831922-1-yuan1.liu@intel.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 694BD4000B
X-Stat-Signature: 6am4iyxje6myjonn1ngrae5nmjzjg654
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775618165-11698
X-HE-Meta: U2FsdGVkX19m1EW4Y3dVuQB7ATBgXI0dJZnn/qWwsueaSi4KZvhxUp+MNOc+4P3RJO5bG6sA2fdEkPgNhTwbFHheiZWnZjhj+KgG5QGbyWeOKbF0u66pBub0I/zLuArglLKq+8sHVDlHKW8P0GVljKuRbzOLr2Sd2Oc5av8rqrX29b5p3KBowR5gkF6iXWitGWoiQa8Cnybq1QDyDKpi+Bqx3iJ2GQJ+H6IjYYmX7vTPohfB4Ld7SKn1u/hztRwdc6ltIPOp5/io8CmQyvuGJRj00pGSOe3rmbFRGUEdLzb8H6ZW8v32s6zU9o9CSZ5aitffJ/sSYuZukfy3vo7PkTiYgNBJkEQQs52ZAf6IH0CQtGM6f7rfMgpu4Pd6NSyE90O+SsFqlrarN1kd9tYq61rJkTkeIIcLJD98ezG7TgW4b7sA4bmm4guubguIXJvkq4w6Mn5Y6yn9u4PaoVq2Fw1N4udE+90jYtjZgEQHzPHLRpa7P/HOX+2EqWhmzg9uteXfg3US41701LXmEZ/yMXU/x+oVp1Rnyz4/01sNZRoUJb7RNnwln0TjEz9Q6MLcJgubasbEfVaIwkZgWLtRKZBbgVT5CecKUCxI/k7UPHq6W+HsqbQ2uHkEwCvrk3eyiXmqtQTu1NgDf+CFqE6GZCcge4e7cZH7nzZ5mWdIf13kOaXyQ/blhE2YMpZlwuFax8YwzqQzhw22tEUMyYpSdIG5I4BAVbFRtQ2E4ssdLn7UZP/bjdnfjsYD1ibMbFap+hMeqkmJUxh4NylRkKfa07rEbFg/bRcoO6O6m9gmlCKip8BO8tcRPUJ7RGOupIfsL/qADbYCSP7g+wpm+5KCgKqjt2qsz4gISkb6+HcNg6NwjNVn324PNPdiDABiTVUoZxetQtmiOPhPL4uFYMrdPiYRPdoUxuF6fn4sPQqO7TAbl9/UTTfJ64RZVt6b02CasHHpnFNp9olN11yci4Q
 3PGNM2f0
 tzwiVJIIMFJHWDT9GVh4mhKs6eBA9Pfnf0teYPF1cFw+l5NVh4uCTa2KW0kqb6OEMs5/3oGiP0VZZBwihYLeFXgWYhVjsTiTjK7tyQ7t8QUT3jBztCwoQrYEqDE1NK+oHO4GSUrnHK/NAPYQ4wBIZTfu7+cGtWREbR+RkkaCNc0eel1gAZ+dUza0mafYFoMwUyOWpaoEe7qwSr0J3phNWm6cIMoGa9FOoqmzdawfHjdQuSE+szJXpwqjXix2DQGT7dNLmFUZJaScCfcjVm/ADLNNnD6fm3BE+sq4P+JzzYUi1hkLrF1Hjqe3c3o7lNPuSuU+H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When move_pfn_range_to_zone() or remove_pfn_range_from_zone() updates a
zone, set_zone_contiguous() rescans the entire zone pageblock-by-pageblock
to rebuild zone->contiguous. For large zones this is a significant cost
during memory hotplug and hot-unplug.

Add a new zone member pages_with_online_memmap that tracks the number of
pages within the zone span that have an online memory map (including present
pages and memory holes whose memory map has been initialized). When
spanned_pages == pages_with_online_memmap the zone is contiguous and
pfn_to_page() can be called on any PFN in the zone span without further
pfn_valid() checks.

Only pages that fall within the current zone span are accounted towards
pages_with_online_memmap. A "too small" value is safe, it merely prevents
detecting a contiguous zone.

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
Co-developed-by: Tianyou Li <tianyou.li@intel.com>
Signed-off-by: Tianyou Li <tianyou.li@intel.com>
Signed-off-by: Yuan Liu <yuan1.liu@intel.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
 Documentation/mm/physical_memory.rst | 13 ++++++++
 drivers/base/memory.c                |  6 ++++
 include/linux/mmzone.h               | 47 ++++++++++++++++++++++++++++
 mm/internal.h                        |  8 +----
 mm/memory_hotplug.c                  | 12 ++-----
 mm/mm_init.c                         | 42 ++++++++++---------------
 6 files changed, 86 insertions(+), 42 deletions(-)

diff --git a/Documentation/mm/physical_memory.rst b/Documentation/mm/physical_memory.rst
index b76183545e5b..0aa65e6b5499 100644
--- a/Documentation/mm/physical_memory.rst
+++ b/Documentation/mm/physical_memory.rst
@@ -483,6 +483,19 @@ General
   ``present_pages`` should use ``get_online_mems()`` to get a stable value. It
   is initialized by ``calculate_node_totalpages()``.
 
+``pages_with_online_memmap``
+  Tracks pages within the zone that have an online memory map (present pages
+  and memory holes whose memory map has been initialized). When
+  ``spanned_pages`` == ``pages_with_online_memmap``, ``pfn_to_page()`` can be
+  performed without further checks on any PFN within the zone span.
+
+  Note: this counter may temporarily undercount when pages with an online
+  memory map exist outside the current zone span. This can only happen during
+  boot, when initializing the memory map of pages that do not fall into any
+  zone span. Growing the zone to cover such pages and later shrinking it back
+  may result in a "too small" value. This is safe: it merely prevents
+  detecting a contiguous zone.
+
 ``present_early_pages``
   The present pages existing within the zone located on memory available since
   early boot, excluding hotplugged memory. Defined only when
diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index a3091924918b..2b6b4e5508af 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -246,6 +246,7 @@ static int memory_block_online(struct memory_block *mem)
 		nr_vmemmap_pages = mem->altmap->free;
 
 	mem_hotplug_begin();
+	clear_zone_contiguous(zone);
 	if (nr_vmemmap_pages) {
 		ret = mhp_init_memmap_on_memory(start_pfn, nr_vmemmap_pages, zone);
 		if (ret)
@@ -270,6 +271,7 @@ static int memory_block_online(struct memory_block *mem)
 
 	mem->zone = zone;
 out:
+	set_zone_contiguous(zone);
 	mem_hotplug_done();
 	return ret;
 }
@@ -282,6 +284,7 @@ static int memory_block_offline(struct memory_block *mem)
 	unsigned long start_pfn = section_nr_to_pfn(mem->start_section_nr);
 	unsigned long nr_pages = PAGES_PER_SECTION * sections_per_block;
 	unsigned long nr_vmemmap_pages = 0;
+	struct zone *zone;
 	int ret;
 
 	if (!mem->zone)
@@ -294,7 +297,9 @@ static int memory_block_offline(struct memory_block *mem)
 	if (mem->altmap)
 		nr_vmemmap_pages = mem->altmap->free;
 
+	zone = mem->zone;
 	mem_hotplug_begin();
+	clear_zone_contiguous(zone);
 	if (nr_vmemmap_pages)
 		adjust_present_page_count(pfn_to_page(start_pfn), mem->group,
 					  -nr_vmemmap_pages);
@@ -314,6 +319,7 @@ static int memory_block_offline(struct memory_block *mem)
 
 	mem->zone = NULL;
 out:
+	set_zone_contiguous(zone);
 	mem_hotplug_done();
 	return ret;
 }
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 3e51190a55e4..d4dd37a7222a 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -943,6 +943,20 @@ struct zone {
 	 * cma pages is present pages that are assigned for CMA use
 	 * (MIGRATE_CMA).
 	 *
+	 * pages_with_online_memmap tracks pages within the zone that have
+	 * an online memory map (present pages and memory holes whose memory
+	 * map has been initialized). When spanned_pages ==
+	 * pages_with_online_memmap, pfn_to_page() can be performed without
+	 * further checks on any PFN within the zone span.
+	 *
+	 * Note: this counter may temporarily undercount when pages with an
+	 * online memory map exist outside the current zone span. This can
+	 * only happen during boot, when initializing the memory map of
+	 * pages that do not fall into any zone span. Growing the zone to
+	 * cover such pages and later shrinking it back may result in a
+	 * "too small" value. This is safe: it merely prevents detecting a
+	 * contiguous zone.
+	 *
 	 * So present_pages may be used by memory hotplug or memory power
 	 * management logic to figure out unmanaged pages by checking
 	 * (present_pages - managed_pages). And managed_pages should be used
@@ -967,6 +981,7 @@ struct zone {
 	atomic_long_t		managed_pages;
 	unsigned long		spanned_pages;
 	unsigned long		present_pages;
+	unsigned long		pages_with_online_memmap;
 #if defined(CONFIG_MEMORY_HOTPLUG)
 	unsigned long		present_early_pages;
 #endif
@@ -1601,6 +1616,38 @@ static inline bool zone_is_zone_device(const struct zone *zone)
 }
 #endif
 
+/**
+ * zone_is_contiguous - test whether a zone is contiguous
+ * @zone: the zone to test.
+ *
+ * In a contiguous zone, it is valid to call pfn_to_page() on any PFN in the
+ * spanned zone without requiring pfn_valid() or pfn_to_online_page() checks.
+ *
+ * Note that missing synchronization with memory offlining makes any PFN
+ * traversal prone to races.
+ *
+ * ZONE_DEVICE zones are always marked non-contiguous.
+ *
+ * Return: true if contiguous, otherwise false.
+ */
+static inline bool zone_is_contiguous(const struct zone *zone)
+{
+	return zone->contiguous;
+}
+
+static inline void set_zone_contiguous(struct zone *zone)
+{
+	if (zone_is_zone_device(zone))
+		return;
+	if (zone->spanned_pages == zone->pages_with_online_memmap)
+		zone->contiguous = true;
+}
+
+static inline void clear_zone_contiguous(struct zone *zone)
+{
+	zone->contiguous = false;
+}
+
 /*
  * Returns true if a zone has pages managed by the buddy allocator.
  * All the reclaim decisions have to use this function rather than
diff --git a/mm/internal.h b/mm/internal.h
index cb0af847d7d9..92fee035c3f2 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -793,21 +793,15 @@ extern struct page *__pageblock_pfn_to_page(unsigned long start_pfn,
 static inline struct page *pageblock_pfn_to_page(unsigned long start_pfn,
 				unsigned long end_pfn, struct zone *zone)
 {
-	if (zone->contiguous)
+	if (zone_is_contiguous(zone))
 		return pfn_to_page(start_pfn);
 
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
index bc805029da51..3f73fcb042cf 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -565,18 +565,13 @@ void remove_pfn_range_from_zone(struct zone *zone,
 
 	/*
 	 * Zone shrinking code cannot properly deal with ZONE_DEVICE. So
-	 * we will not try to shrink the zones - which is okay as
-	 * set_zone_contiguous() cannot deal with ZONE_DEVICE either way.
+	 * we will not try to shrink it.
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
@@ -1079,6 +1070,7 @@ void adjust_present_page_count(struct page *page, struct memory_group *group,
 	if (early_section(__pfn_to_section(page_to_pfn(page))))
 		zone->present_early_pages += nr_pages;
 	zone->present_pages += nr_pages;
+	zone->pages_with_online_memmap += nr_pages;
 	zone->zone_pgdat->node_present_pages += nr_pages;
 
 	if (group && movable)
diff --git a/mm/mm_init.c b/mm/mm_init.c
index df34797691bd..d88ba739ab3d 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -842,7 +842,7 @@ overlap_memmap_init(unsigned long zone, unsigned long *pfn)
  *   zone/node above the hole except for the trailing pages in the last
  *   section that will be appended to the zone/node below.
  */
-static void __init init_unavailable_range(unsigned long spfn,
+static unsigned long __init init_unavailable_range(unsigned long spfn,
 					  unsigned long epfn,
 					  int zone, int node)
 {
@@ -858,6 +858,7 @@ static void __init init_unavailable_range(unsigned long spfn,
 	if (pgcnt)
 		pr_info("On node %d, zone %s: %lld pages in unavailable ranges\n",
 			node, zone_names[zone], pgcnt);
+	return pgcnt;
 }
 
 /*
@@ -956,9 +957,22 @@ static void __init memmap_init_zone_range(struct zone *zone,
 	memmap_init_range(end_pfn - start_pfn, nid, zone_id, start_pfn,
 			  zone_end_pfn, MEMINIT_EARLY, NULL, MIGRATE_MOVABLE,
 			  false);
+	zone->pages_with_online_memmap += end_pfn - start_pfn;
 
-	if (*hole_pfn < start_pfn)
-		init_unavailable_range(*hole_pfn, start_pfn, zone_id, nid);
+	if (*hole_pfn < start_pfn) {
+		unsigned long pgcnt;
+
+		if (*hole_pfn < zone_start_pfn) {
+			init_unavailable_range(*hole_pfn, zone_start_pfn,
+					       zone_id, nid);
+			pgcnt = init_unavailable_range(zone_start_pfn,
+					start_pfn, zone_id, nid);
+		} else {
+			pgcnt = init_unavailable_range(*hole_pfn, start_pfn,
+					zone_id, nid);
+		}
+		zone->pages_with_online_memmap += pgcnt;
+	}
 
 	*hole_pfn = end_pfn;
 }
@@ -2261,28 +2275,6 @@ void __init init_cma_pageblock(struct page *page)
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
-- 
2.47.3


