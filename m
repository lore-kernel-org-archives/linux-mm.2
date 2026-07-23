Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CC16C531CB
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 08:45:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C0D56B0153; Thu, 23 Jul 2026 04:45:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 398586B0155; Thu, 23 Jul 2026 04:45:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2872B6B0156; Thu, 23 Jul 2026 04:45:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DF4706B0153
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 04:45:54 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5711614014C
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 08:45:54 +0000 (UTC)
X-FDA: 85019408628.22.0636759
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf11.hostedemail.com (Postfix) with ESMTP id CF4CB4000A
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 08:45:51 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=S5KH+pGS;
	spf=pass (imf11.hostedemail.com: domain of yuan1.liu@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784796352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JkcGnoopQNJ9m9vIxArsXlpTyExlKj0gbPE5zWnkRYc=;
	b=jNOi7Yam7smkE4VjnEQfIvePIYxPblelNxsOtQs9B13rOGixGIfR3wTYtfiC40vqwtkqTK
	YKMwGjUmlMuq18YVuRvYmS5pJO4dNzhOy28bGHfl6qMVafY0UpP/nriq2VyE0sw6BxN86P
	HsSsOVdn82nQrmW3YS/DRm+2MER0R8M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784796352;
	b=EWmJma+rc39ebMz4czprnW8sMxUMGajxXEf+YjXjwH7uLm4UUfGfYePK1PHO5ez+WrLoG8
	rAW+FtJ4cejxSOPCcKxs0VdDTh81gZchRwIdkjvC5FQACUC50iVhlS1yYJWoq3seu+Jl2Z
	qzb/m/ZN0OK3LYsbJhAzQA7EwGLRxF4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=S5KH+pGS;
	spf=pass (imf11.hostedemail.com: domain of yuan1.liu@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784796352; x=1816332352;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8WfoTOawSaGZIDDYaRMLxR1K1pmVgTzFDcoX39JzD1s=;
  b=S5KH+pGS21e8VuAz7HiaHuAdfFWfz0NcUDEtQodgbANOdUzN5Bj+rXSR
   Rgy5+zNWbaL+dvF25N76jYRwkEh2/kWFu2yHYd5Zt7EipyHzB5Tvh4xnu
   gHlV/HSn6TgLPpvQkzasIMRjM0XbqzZuNSTyKBnONw3bSfBuROq1MGK5R
   WKYWSrgeeG4dIYrIPOOYZWf5SVSU5W3Goaa3/BDzrAA1cRzZxBGvuTNBa
   +UkihNxzJtu0cc++y95VYgE9/8mk/AScstgtGvA7pyLwrs3YQCvdMYMyM
   oqJzHoCW54U0wJYHNL+ohabQVPAyLYn1eK/qO7BG2v0utMKtDxjL/Cloz
   g==;
X-CSE-ConnectionGUID: aD7WN+I4QG2/QZh/wDKDcQ==
X-CSE-MsgGUID: l97Ka2dLT/i0VfkV7wUHsw==
X-IronPort-AV: E=McAfee;i="6800,10657,11854"; a="108234132"
X-IronPort-AV: E=Sophos;i="6.25,180,1779174000"; 
   d="scan'208";a="108234132"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2026 01:45:51 -0700
X-CSE-ConnectionGUID: bArUnfzoT9q+iKkUkoUI1A==
X-CSE-MsgGUID: 4qg/ypOPSl2hUO78xsq42w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,180,1779174000"; 
   d="scan'208";a="262126115"
Received: from spr10.sh.intel.com (HELO localhost) ([10.239.23.75])
  by orviesa004.jf.intel.com with ESMTP; 23 Jul 2026 01:45:48 -0700
From: Yuan Liu <yuan1.liu@intel.com>
To: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>
Cc: linux-mm@kvack.org,
	Nanhai Zou <nanhai.zou@intel.com>,
	Yuan Liu <yuan1.liu@intel.com>,
	Pan Deng <pan.deng@intel.com>,
	Tianyou Li <tianyou.li@intel.com>,
	Chen Zhang <zhangchen.kidd@jd.com>,
	Jason Zeng <jason.zeng@intel.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v6 1/2] mm/memory_hotplug: optimize zone contiguous check when changing pfn range
Date: Thu, 23 Jul 2026 04:49:45 -0400
Message-ID: <20260723084946.189392-2-yuan1.liu@intel.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260723084946.189392-1-yuan1.liu@intel.com>
References: <20260723084946.189392-1-yuan1.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CF4CB4000A
X-Stat-Signature: kr8akc6f3exyiwj1o1aicrtn1ctbac7t
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784796351-581876
X-HE-Meta: U2FsdGVkX18XsHdGcRHDeeeUh/bmGgM4mpxKgj1K29xmNw2vBdUh/5rdoqt9drV6otAypQJodiicKKCAMpGgcAE9tSUCmyUJeIIJvXlqe78VqUobv/LkBRReTvEpn7eLV1WgyPb+bJh6uokmx4Z0fHbuoZA/+q2vEm73SdWvKlHBukM5vXEbZdZZ0eLfJtbvxfkxYDuRiqsH0JF96fOyLPY3RbQaCiroFst4hDD4iz+cFsC76DN/HsLFuB5yrmppXWM4xsB9t+mr3k9Vkm7EwT4HnVQesWzcFtx7LeNWact8p9PtUI3V63rD56ZLH1u319GeJtBv2e90rp7gnf8DjyIeY+yrNmjzQ0m0q+LsWKuGEKfC3ul122TCVzDX8rd4EZW0TvnbQayAYVGaZtEzTfv8TWP7od4xfB0AwzJ1isn7a4xpstbXlsxTzlr8fwtUylT7aF3jw1Wr5d7UOx8BzdJUgII55+BmlJ7ZdgSjC4WZVX8NR0mIbydiN8PcTST8SMPw4ejdVTHa2wI/8Un5u6FTuUSjBW2z1sOteYLqsA5irc3H2tHOfCfmUlvP+4hdPQD4kbGVjQ00ed3Pgm/SfM9kPOnfQLPWKdIatVhMZkIxPEErBPlWEA/UtHh3vaEvAM3ilI6mAfw2fsNOdCCqD5cx2FxYVVf7F37zDm9tYWREOEudjNPzMp/Gn4VbQucWTlxRUIn29lwEey7xmSNT7Ywks71pGLRJ8y72ULKBmqyK/tpR0Pwo6o7BVxw6aJet+jwKQP+B+wfkX48vwmxIKMtIbicrhEluEViKEqVhunI2ob8qM31al7KS8+pLM0EmGrjEPhM+a4IxWVTpCiMz5oQsJbs7Ay8dmo3ly/lf5DJrgiE9G9FIDeW5Q5Qw8sRJGRrgVDjDmOPpVvhxuymsnZBrV/1PqgY9/9iPq7nLWCzdT+dKOYESXfkH4gee7hYD7HOmGvCc1VfYHOOyAEu
 PM3CZwcN
 vu//O7zyUa2mqpocA2YqKJeyI9IPTlsp/6y9EdGo7eApHqXMjIHrjXIwlO1HWqYXKbKNa1vaNTOEe3wRvCPARSw7KYoJxHLNE0lLMNjdL0wOKiEU8F6t9fnnJTATGj0kz94Emh+avfX8GjWe52+N6GFqZuO0ICTsz27ggolcEeY6xxhbP7S44HKvV+j2qy06voB34Scpd3QEpGEiL5jYQHP0SWRyghhi1BSuOaaS1opPQ0TGqiR8PgSnstLo+nTYjgRcLYMzHwc9edX7tEgGqc4otzJcgGTYgY/xS69XjTY2relaJSekI1z7x0yhKkxhOSXDN/vvdip+kJKcKUHyM1aU9jGzQ1wXTrI8t
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When move_pfn_range_to_zone() or remove_pfn_range_from_zone() updates a
zone, set_zone_contiguous() rescans the entire zone
pageblock-by-pageblock to rebuild zone->contiguous. For large zones this
is a significant cost during memory hotplug and hot-unplug.

Add a new zone member pages_with_online_memmap that tracks the number of
pages within the zone span that have an online memory map (including
present pages and memory holes smaller than a subsection whose memory
map has been initialized). When spanned_pages == pages_with_online_memmap
the zone is contiguous and pfn_to_page() can be called on any PFN in the
zone span without further pfn_valid() checks.

For early boot memory, pages_with_online_memmap is calculated in
memmap_init_zone_range(). Since every PFN within a memblock region
satisfies pfn_to_online_page(), the calculation aligns both boundaries
of each memblock range to PAGES_PER_SUBSECTION and counts the aligned
pages that fall within the zone span. If two adjacent memblock regions
share a subsection (i.e. the hole between them is smaller than a
subsection), the overlapping subsection pages are counted only once.
For hotplugged memory, pages_with_online_memmap is updated through
adjust_present_page_count(), which is called during memory online and
offline.

Only pages that fall within the current zone span are accounted towards
pages_with_online_memmap. A "too small" value is safe, it merely
prevents detecting a contiguous zone.

The contiguity check using pages_with_online_memmap is stricter than the
old pageblock-by-pageblock scan. The old set_zone_contiguous() iterated
at pageblock granularity via pageblock_pfn_to_page(), so a zone could be
marked contiguous even if a subsection-sized hole existed within a
pageblock. The new check requires
spanned_pages == pages_with_online_memmap, meaning every PFN in the zone
span must satisfy pfn_to_online_page().

The following test cases of memory hotplug for a VM [1], tested in the
environment [2], show that this optimization can significantly reduce
the memory hotplug time [3].

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
Reviewed-by: Pan Deng <pan.deng@intel.com>
Reviewed-by: Jason Zeng <jason.zeng@intel.com>
Co-developed-by: Tianyou Li <tianyou.li@intel.com>
Signed-off-by: Tianyou Li <tianyou.li@intel.com>
Signed-off-by: Yuan Liu <yuan1.liu@intel.com>
---
 Documentation/mm/physical_memory.rst | 13 +++++++
 drivers/base/memory.c                |  6 +++
 include/linux/mmzone.h               | 47 ++++++++++++++++++++++
 mm/internal.h                        |  8 +---
 mm/memory_hotplug.c                  | 12 +-----
 mm/mm_init.c                         | 58 +++++++++++++++++-----------
 6 files changed, 105 insertions(+), 39 deletions(-)

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
index bcfe2d9f4adb..237ace435372 100644
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
index ca2712187147..ac1467ac3336 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1032,6 +1032,20 @@ struct zone {
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
@@ -1056,6 +1070,7 @@ struct zone {
 	atomic_long_t		managed_pages;
 	unsigned long		spanned_pages;
 	unsigned long		present_pages;
+	unsigned long		pages_with_online_memmap;
 #if defined(CONFIG_MEMORY_HOTPLUG)
 	unsigned long		present_early_pages;
 #endif
@@ -1681,6 +1696,38 @@ static inline bool zone_is_zone_device(const struct zone *zone)
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
index 181e79f1d6a2..f932b7577c92 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -805,21 +805,15 @@ extern struct page *__pageblock_pfn_to_page(unsigned long start_pfn,
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
index 7ac19fab2263..4c699fd9c479 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -557,18 +557,13 @@ void remove_pfn_range_from_zone(struct zone *zone,
 
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
@@ -746,8 +741,6 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
 	struct pglist_data *pgdat = zone->zone_pgdat;
 	int nid = pgdat->node_id;
 
-	clear_zone_contiguous(zone);
-
 	if (zone_is_empty(zone))
 		init_currently_empty_zone(zone, start_pfn, nr_pages);
 	resize_zone_range(zone, start_pfn, nr_pages);
@@ -775,8 +768,6 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
 	memmap_init_range(nr_pages, nid, zone_idx(zone), start_pfn, 0,
 			 MEMINIT_HOTPLUG, altmap, migratetype,
 			 isolate_pageblock);
-
-	set_zone_contiguous(zone);
 }
 
 struct auto_movable_stats {
@@ -1072,6 +1063,7 @@ void adjust_present_page_count(struct page *page, struct memory_group *group,
 	if (early_section(__pfn_to_section(page_to_pfn(page))))
 		zone->present_early_pages += nr_pages;
 	zone->present_pages += nr_pages;
+	zone->pages_with_online_memmap += nr_pages;
 	zone->zone_pgdat->node_present_pages += nr_pages;
 
 	if (group && movable)
diff --git a/mm/mm_init.c b/mm/mm_init.c
index f1afe023e4e7..73d1fde17040 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -916,6 +916,40 @@ void __meminit memmap_init_range(unsigned long size, int nid, unsigned long zone
 	}
 }
 
+static void __init update_zone_online_memmap_pages(struct zone *zone,
+						   unsigned long start_pfn,
+						   unsigned long end_pfn,
+						   unsigned long *hole_pfn)
+{
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
+	unsigned long zone_start_pfn = zone->zone_start_pfn;
+	unsigned long zone_end_pfn = zone_start_pfn + zone->spanned_pages;
+	unsigned long sub_start, sub_end;
+
+	sub_start = max(ALIGN_DOWN(start_pfn, PAGES_PER_SUBSECTION),
+			zone_start_pfn);
+	sub_end = min(ALIGN(end_pfn, PAGES_PER_SUBSECTION), zone_end_pfn);
+
+	/*
+	 * For an in-zone hole smaller than a subsection, the adjacent
+	 * memblock ranges share a subsection. Avoid counting the same
+	 * subsection's pages twice.
+	 */
+	if (*hole_pfn > zone_start_pfn) {
+		unsigned long prev_sub_end;
+
+		prev_sub_end = min(ALIGN(*hole_pfn, PAGES_PER_SUBSECTION),
+				   zone_end_pfn);
+		sub_start = max(sub_start, prev_sub_end);
+	}
+
+	if (sub_start < sub_end)
+		zone->pages_with_online_memmap += sub_end - sub_start;
+#else
+	zone->pages_with_online_memmap += end_pfn - start_pfn;
+#endif
+}
+
 static void __init memmap_init_zone_range(struct zone *zone,
 					  unsigned long start_pfn,
 					  unsigned long end_pfn,
@@ -932,6 +966,8 @@ static void __init memmap_init_zone_range(struct zone *zone,
 	if (start_pfn >= end_pfn)
 		return;
 
+	update_zone_online_memmap_pages(zone, start_pfn, end_pfn, hole_pfn);
+
 	memmap_init_range(end_pfn - start_pfn, nid, zone_id, start_pfn,
 			  zone_end_pfn, MEMINIT_EARLY, NULL, mt, false);
 
@@ -2195,28 +2231,6 @@ void __init init_cma_pageblock(struct page *page)
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


