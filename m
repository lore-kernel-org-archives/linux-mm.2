Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EED06D35144
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 07:01:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE9456B0088; Wed,  1 Apr 2026 03:01:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C99C36B0089; Wed,  1 Apr 2026 03:01:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B88E96B008A; Wed,  1 Apr 2026 03:01:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A46186B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 03:01:56 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3286EC643C
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 07:01:56 +0000 (UTC)
X-FDA: 84609092232.25.9E797EC
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3D85A4001D
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 07:01:53 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IVNwPqXY;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf07.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775026914; a=rsa-sha256;
	cv=none;
	b=3mQSOBFwqx0ySsHdTTs5wwTKBUloN85fEm5YuLdsjq7Bjc6wlpmOmwo2W1qpPpQpVrfo2P
	rt/HSikPzzh1JPOftAAtN+FyHVCxapsflnrt3H3RBV9H6qWncvFPFbAlGiH+MgP9v6EWdz
	TMRPODisEUZjb3klDV141b16eobEZqk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IVNwPqXY;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf07.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775026914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=IQgyrQiw2zeJhUL0DIcbBhQjGRhCM8cbe+9qqlmQGkA=;
	b=pDe/z3HtUYtHxhIx5AxInPtEcpKM9C37wZEWuYpkEtxrV/+vkmpOAiqDWwhVdKUm3/ZHm+
	+e+vSY85U4D2RN3jsvk77Ji8zYmSi1/rS2hme9JhwXAAzOY/n0PEVqEWKZSAE9GLCBWwJv
	4r9tI7aDLN3HvAyze45IMxsEZrKp4HM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775026913; x=1806562913;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=cO2HAq7Tbla5DCgH2yGoOYpWj/xxLKqY/nmwAcNmCmE=;
  b=IVNwPqXY904NIKS9MfqibganwOL2n2ekC4YwFNugmCfEYSyJVWb6Z/YW
   7D9avPmstbmdd6dWzLH7n50CGp/Toant4BGp43W/e8RAQDoJsMYUUoETh
   6rE2QMKKm8waBBerx/QMU39SbBrs4NAHfcRIEEJAdijf3TCjCdy/bkoGQ
   RsAlcMEZsWMaEPE5me1zyOdmoJ1S/hV94MTSbPhVGV0AlzZLM1ZCs7kb6
   J1Jqx0up62ChrqccWpthB+Iq6IaEtq6fhmp0OCxmfHW1HtfhV4RCD9y4C
   6H1tLKXTAZsrvkHr+H16kGHRSlxMwISo7MtlMQ+Cu2xX5aetgC3AKcedn
   A==;
X-CSE-ConnectionGUID: oVOKUTOES9Cto92zDAw1Vw==
X-CSE-MsgGUID: mUL9s2zYTvCv4452V1PEOg==
X-IronPort-AV: E=McAfee;i="6800,10657,11745"; a="86670937"
X-IronPort-AV: E=Sophos;i="6.23,153,1770624000"; 
   d="scan'208";a="86670937"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2026 00:01:39 -0700
X-CSE-ConnectionGUID: xzw0AiRbSv61DOsFc5UM6w==
X-CSE-MsgGUID: vskgqkMkQ3uNPB953sBlkg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,153,1770624000"; 
   d="scan'208";a="257092471"
Received: from spr10.sh.intel.com (HELO localhost) ([10.239.23.75])
  by orviesa002.jf.intel.com with ESMTP; 01 Apr 2026 00:01:36 -0700
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
Subject: [PATCH v2] mm/memory hotplug/unplug: Optimize zone contiguous check when changing pfn range
Date: Wed,  1 Apr 2026 03:01:55 -0400
Message-ID: <20260401070155.1420929-1-yuan1.liu@intel.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kcxrqbw6xh3j377a3obygwptmgss1yes
X-Rspamd-Queue-Id: 3D85A4001D
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775026913-102847
X-HE-Meta: U2FsdGVkX196qR3W5qT8muGT1sehpMY4YRRikp5372XeKrS07wnKWKf+rkFADMciqRAKbj9/RYebr0l2CrBxV3DoEDEkxIsGGH6mrCatywlmGZaOqAId8ZlIXVbBooh4bHPzNC58pYmtwx4EYXjtc9R8A5fsKSZq/C1HXIxZCCPxChJBQWXov0VkYGDUiXWUfN25j9GvdLrXHChtwesDR6bNsFRrJ0Ase0sRsekeLUUcnxyKVh4VQj35BTXWmEpN6IPB9fr1Xgb08VbzbJRBY5+dt4JmHQvQLMLC9U+p3clGcczt69zVJIy6+wy67AYjcCALatjmIjqiS/UIXWfVk0sO8tPp1zKbKjsXkq7p+T3plSNGpvHYTad6ciUDndODMyHySQZT5D7vpV9ShELSFqi0xUc3JHMZ1+pM2J/aJMifVkWuk6UwxIzKh67utmFaJ4wby6NsyeNRUf3Xk8LWeSi7eUGiXrLU2VWGupZhonLalm16aC4GvxhJ9sAoRpwlYMNo2qFZHvcL14Z90H8eRI+VT/k7bn7H6fFaO+mZKFBo/xp2NHfwWLXTx470cXxNsx4uIwUV+uehqz9ILaeDB4qJCo0DF7XG8fBfMZbVFet/95fD4ngAWGppl0mSaZwsBcJIeeESXu7LncFRo7hTRLws+qorxkJumZRD0wXuolFyClcKdoxX9HTPqHq6bMNG+dZl80GZfTaGYqXsVVZqy+hyW7Zq3g/4khB4SaHNA141d5ehwCd/5px1Ccq/rs5pgh4P5aVg1TN4ZUZyzKahHYHwiEfzcKbmPKiLZj1y7YLyl2o4l28Go7Ygq45CtXZa57F8b5sk/ZEcob3Koz2LmAXp6EoshqoxJ+u4+jb3AY2yB6UWxBKwBYlXHZcOqHorQYXiTsFVkzlZN6ggWk1tWlR0Uw532ZIJzJ4F8xOLD0Mh8lyuVDp4LwWDKclOYGdDMN2zTs4FC6Zvsg61Yfu
 +UBd31bb
 fr3/XaVIPc9DRwt5zPzegL1sCn7bKJpexZbGfVEq1IcatebCKeHyrQbHZgG2ZBPdxQ2G5ZCxqL9p52fJPhxmfY9419pYISPaGosAxCNNAoVk/5tDxFLmD0HKNoiDs2x0K9VRJ9Dh3pxa/Sz4uhIV+msdJiJyvz4VZmk+sgw8e8tS/vy7d22sybzvjbvFdP4GorGR4heda0AhHHoeLyDEipiIMK9AweY4hKHLCPpw+20DRJLZ0ZwkTi5cB5wnV9kNL5NeStjYFOybnWKAtogsMNfI4Tw==
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
pages within the zone span that have an online memmap (including present
pages and memory holes whose memmap has been initialized). When
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
---
 Documentation/mm/physical_memory.rst | 11 +++++
 drivers/base/memory.c                |  6 +++
 include/linux/mmzone.h               | 44 +++++++++++++++++++
 mm/internal.h                        |  8 +---
 mm/memory_hotplug.c                  | 12 +-----
 mm/mm_init.c                         | 64 +++++++++++++++++-----------
 6 files changed, 102 insertions(+), 43 deletions(-)

diff --git a/Documentation/mm/physical_memory.rst b/Documentation/mm/physical_memory.rst
index b76183545e5b..e47e96ef6a6d 100644
--- a/Documentation/mm/physical_memory.rst
+++ b/Documentation/mm/physical_memory.rst
@@ -483,6 +483,17 @@ General
   ``present_pages`` should use ``get_online_mems()`` to get a stable value. It
   is initialized by ``calculate_node_totalpages()``.
 
+``pages_with_online_memmap``
+  Tracks pages within the zone that have an online memmap (present pages and
+  memory holes whose memmap has been initialized). When ``spanned_pages`` ==
+  ``pages_with_online_memmap``, ``pfn_to_page()`` can be performed without
+  further checks on any PFN within the zone span.
+
+  Note: this counter may temporarily undercount when pages with an online
+  memmap exist outside the current zone span. Growing the zone to cover such
+  pages and later shrinking it back may result in a "too small" value. This is
+  safe: it merely prevents detecting a contiguous zone.
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
index 3e51190a55e4..011df76a03b6 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -943,6 +943,17 @@ struct zone {
 	 * cma pages is present pages that are assigned for CMA use
 	 * (MIGRATE_CMA).
 	 *
+	 * pages_with_online_memmap tracks pages in the zone that have an
+	 * online memmap (present pages and holes whose memmap was initialized).
+	 * When spanned_pages == pages_with_online_memmap, pfn_to_page() can
+	 * be performed without further checks on any PFN in the zone span.
+	 *
+	 * Note: pages_with_online_memmap may temporarily undercount when pages
+	 * with an online memmap exist outside the current zone span (e.g., from
+	 * init_unavailable_range() during boot). Growing the zone to cover such
+	 * pages and later shrinking it back may result in a "too small" value.
+	 * This is safe: it merely prevents detecting a contiguous zone.
+	 *
 	 * So present_pages may be used by memory hotplug or memory power
 	 * management logic to figure out unmanaged pages by checking
 	 * (present_pages - managed_pages). And managed_pages should be used
@@ -967,6 +978,7 @@ struct zone {
 	atomic_long_t		managed_pages;
 	unsigned long		spanned_pages;
 	unsigned long		present_pages;
+	unsigned long		pages_with_online_memmap;
 #if defined(CONFIG_MEMORY_HOTPLUG)
 	unsigned long		present_early_pages;
 #endif
@@ -1601,6 +1613,38 @@ static inline bool zone_is_zone_device(const struct zone *zone)
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
index bc805029da51..cd9c89de6ed2 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
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
@@ -1079,6 +1070,7 @@ void adjust_present_page_count(struct page *page, struct memory_group *group,
 	if (early_section(__pfn_to_section(page_to_pfn(page))))
 		zone->present_early_pages += nr_pages;
 	zone->present_pages += nr_pages;
+	zone->pages_with_online_memmap += nr_pages;
 	zone->zone_pgdat->node_present_pages += nr_pages;
 
 	if (group && movable)
diff --git a/mm/mm_init.c b/mm/mm_init.c
index df34797691bd..b8187a22e90e 100644
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
@@ -858,6 +858,36 @@ static void __init init_unavailable_range(unsigned long spfn,
 	if (pgcnt)
 		pr_info("On node %d, zone %s: %lld pages in unavailable ranges\n",
 			node, zone_names[zone], pgcnt);
+	return pgcnt;
+}
+
+/*
+ * Initialize unavailable range [spfn, epfn) while accounting only the pages
+ * that fall within the zone span towards pages_with_online_memmap. Pages
+ * outside the zone span are still initialized but not accounted.
+ */
+static void __init init_unavailable_range_for_zone(struct zone *zone,
+						   unsigned long spfn,
+						   unsigned long epfn)
+{
+	int nid = zone_to_nid(zone);
+	int zid = zone_idx(zone);
+	unsigned long in_zone_start;
+	unsigned long in_zone_end;
+
+	in_zone_start = clamp(spfn, zone->zone_start_pfn, zone_end_pfn(zone));
+	in_zone_end = clamp(epfn, zone->zone_start_pfn, zone_end_pfn(zone));
+
+	if (spfn < in_zone_start)
+		init_unavailable_range(spfn, in_zone_start, zid, nid);
+
+	if (in_zone_start < in_zone_end)
+		zone->pages_with_online_memmap +=
+			init_unavailable_range(in_zone_start, in_zone_end,
+					       zid, nid);
+
+	if (in_zone_end < epfn)
+		init_unavailable_range(in_zone_end, epfn, zid, nid);
 }
 
 /*
@@ -956,9 +986,10 @@ static void __init memmap_init_zone_range(struct zone *zone,
 	memmap_init_range(end_pfn - start_pfn, nid, zone_id, start_pfn,
 			  zone_end_pfn, MEMINIT_EARLY, NULL, MIGRATE_MOVABLE,
 			  false);
+	zone->pages_with_online_memmap += end_pfn - start_pfn;
 
 	if (*hole_pfn < start_pfn)
-		init_unavailable_range(*hole_pfn, start_pfn, zone_id, nid);
+		init_unavailable_range_for_zone(zone, *hole_pfn, start_pfn);
 
 	*hole_pfn = end_pfn;
 }
@@ -996,8 +1027,11 @@ static void __init memmap_init(void)
 #else
 	end_pfn = round_up(end_pfn, MAX_ORDER_NR_PAGES);
 #endif
-	if (hole_pfn < end_pfn)
-		init_unavailable_range(hole_pfn, end_pfn, zone_id, nid);
+	if (hole_pfn < end_pfn) {
+		struct zone *zone = &NODE_DATA(nid)->node_zones[zone_id];
+
+		init_unavailable_range_for_zone(zone, hole_pfn, end_pfn);
+	}
 }
 
 #ifdef CONFIG_ZONE_DEVICE
@@ -2261,28 +2295,6 @@ void __init init_cma_pageblock(struct page *page)
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


