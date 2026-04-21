Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1486F8FA71
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 12:55:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 530CA6B008A; Tue, 21 Apr 2026 08:55:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E2386B008C; Tue, 21 Apr 2026 08:55:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3340B6B0092; Tue, 21 Apr 2026 08:55:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 204DB6B008A
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 08:55:17 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E29A58D227
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 12:55:16 +0000 (UTC)
X-FDA: 84682558632.21.FACE44A
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf27.hostedemail.com (Postfix) with ESMTP id A10794000E
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 12:55:14 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=iMyX3eSP;
	spf=pass (imf27.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776776114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V+cErqxYR3zrqRtmYeeTwrK5KY3/fgcKvARbkP0Rl2Y=;
	b=jdfOEk1AKsiDV1+5gTLmeOTGUm3bAmrVHMiUIWuviEG4pBMt4WSEV5Wa2+OhdYKpX6sD4Q
	tJNkejm1V0eS+ERyKwAdB9itzKH815R8bqj0U8FxEBzNJVhBlu4j4Av2OcMzEfsXA2N717
	bB8C2rA9/rv6/UyAjF85xWJr/uuEIc4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776776115; a=rsa-sha256;
	cv=none;
	b=F7q2dQZZVBE7AycyBQmebIIk44e3xq2ibVvosSC/aUN0El+nysnVqxN8MMe3Ka9BQ1t9bD
	TMaycJfIRazv9W9fL0sjC9h2n3CJOTJ6rML1ltQTUKPp9C48PiQIG0mopYmDy3JzqeusTI
	I5ZrSTMhQgLHmcg2ulmy1dhNqqBlOwo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=iMyX3eSP;
	spf=pass (imf27.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776776115; x=1808312115;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nqfqwMo/9Tki1ZXL9m2ZOTrv7RSuchvTgx/XGGtibkQ=;
  b=iMyX3eSPNVceBTjdxcYBYpvxME2OGZx/B8YKL9DWnMqywBPsZ6D6P22i
   cMUOJFXpib+E5YfNTQT96Kqn2u5quQWarIWEEF6mdRAZlgHneu3BodD17
   bn9AOzMrMlQnYLwu88HG21zoCCmDKdWnsjxC43w0KQT7wJawqnaCS8yaI
   tCN/Wyo/2P57ho/nYjV6YNW5HYWlETjU2iDfDjTRChJCtZXnmxJyBjFvj
   fhqvZs7KBhRZLzZ+ovv1suu8PM1DZswMQY2GQ2XFZlCPrBdwM+1cGrZMJ
   DKun75pe4jtG71SrPfh6Hfz9IGY+HoylkfOJF2LLAkzBBf4XM8qcR6hdr
   g==;
X-CSE-ConnectionGUID: Z8Uz7fsRQKSuXM68eQt6Hg==
X-CSE-MsgGUID: evUNe4ofSa22LwMKlp+Lbg==
X-IronPort-AV: E=McAfee;i="6800,10657,11762"; a="80294058"
X-IronPort-AV: E=Sophos;i="6.23,191,1770624000"; 
   d="scan'208";a="80294058"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2026 05:55:14 -0700
X-CSE-ConnectionGUID: baCD8qo5SriHY/9/Wg2UeA==
X-CSE-MsgGUID: MPg+g910TD2NwdN0K3L+XA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,191,1770624000"; 
   d="scan'208";a="231138656"
Received: from spr10.sh.intel.com (HELO localhost) ([10.239.23.75])
  by orviesa010.jf.intel.com with ESMTP; 21 Apr 2026 05:55:10 -0700
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
Subject: [PATCH v4 2/2] mm/memory hotplug/unplug: Optimize zone contiguous check when changing pfn range
Date: Tue, 21 Apr 2026 08:55:08 -0400
Message-ID: <20260421125508.2317429-3-yuan1.liu@intel.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260421125508.2317429-1-yuan1.liu@intel.com>
References: <20260421125508.2317429-1-yuan1.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A10794000E
X-Rspamd-Server: rspam07
X-Stat-Signature: 4oqgpshcgjsu1npobxhsh7xbqmtotnri
X-Rspam-User: 
X-HE-Tag: 1776776114-198275
X-HE-Meta: U2FsdGVkX1+qic6boVwoCKBr6E4IJNrheWAXQ/BiKl5/TmdS97GA7gii0dtCgGuidQ/YV1AENOaleWfTrH77vkyklyay+uZSLVxque2Sa2brgYQHyQhp0D885nldMDrC9DHTZHlQXGWNqEQVsOZIKpVvVWvkpKA8gmPQlMO8TWvoUmwPMogeZgEsfhVDy/srkMNyeJCTWV7/4Zs+J7KJzuQw8glH1N00T1jhVJBkEQaVvW43mAlbEujsWSDHY/0FdVC8Dz7XIXGYKf/RM2cxnKQXOZ0+CP95l8FR7MWFwcwUMN1BJ1lmH+SzBKmjCgEbl7fnEHYIMALKQ82zLoe4uxuVwfmeuw2h29SFQkrkAiZQ1zR3rFJsik26wN6xQ1Tq9lMpcUoLb+4fckx1+iPvxRG7099uGjjDDUCws/ijGnVqEPn1c/himTzjGUQhG+f2m0pfpCgVHtZxFEe+TdnoOPWGHYy68BNCWYwCuty2oSCIO2IcWwQujjTDbKK2ZhdLv1xp05mKXule6qzYjBYupN0mnE8ewLm25UyYohEzw2Op9OB2eP+0OKumHjKw/s4m7xcnjheg20OUxIhQjtkKSQzsWPad7VG3GbmicN1YyCRkat637/mX4cHxypo2yIoQCM3ifxD2a1WlJ1LH7J8hVaNwVTvTICCuMQP5u0yTnx0FWkxJ7jmC5wLLgxd7CY/Wwlm1iDe7IPwEX4whcHgMcHTmc3rEP3JYqlzB7bvqxrTAil7bdsSCcxPsMSrw7fyfpiJhjFaGG+N8kGAkq00oEBN2s5i/m6U8bRYjITGXEX67Lg5olf37GgOe3IkZYN6DDWaBJDSiNdUNFmlaoxp2EtTOM1A4FWl9fm10RcZ2zxXnJO9vrS7iy/X0hnyG/RMetsuyMsZ+xlakV4G5ZNwlTbGwZngbO3Eyv4BqevTM9bfpX/qgYa1KgoWhNdBoa6zPUvqhu2yGI5j8BcwrQ7O
 IZS0RU32
 w58Kd7POqd2i4VxtOkcPQdmNDQNneqCHYwd4bInRqq0qzP5MrvtxndRKBZK+rsLlEvEFdGLGqJtjS9SKoKAVaqJHovqYUQlQ0J6DMRXsdOw47qyp+Luk5E4wHQc/KaLFc3lSyFdiJDtfccWvfuN0ZshlPQUBbWLZxQ4V5N5HAEGDz4dqrV/2/O4xN/9ZZ0WkZtqKgULMKaVybRCMPahzzBGTzuPn+ZizL1JZDjBFpo7BTNll0HqXjthGtILl/h9gr/1yWJo/wGLa+0dJ98Astelv4j+dYG0k7tzFbHKxtUj46X+lcgr7ZYXgDaA==
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
pages within the zone span that have an online memory map (including
present pages and memory holes whose memory map has been initialized).
When spanned_pages == pages_with_online_memmap the zone is contiguous and
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
 Documentation/mm/physical_memory.rst | 13 ++++++++
 drivers/base/memory.c                |  6 ++++
 include/linux/mmzone.h               | 47 ++++++++++++++++++++++++++++
 mm/internal.h                        |  8 +----
 mm/memory_hotplug.c                  | 12 ++-----
 mm/mm_init.c                         | 45 +++++++++++---------------
 6 files changed, 87 insertions(+), 44 deletions(-)

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
index 2b5233060504..165921e22a89 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -820,9 +820,9 @@ void __meminit reserve_bootmem_region(phys_addr_t start,
  *   zone/node above the hole except for the trailing pages in the last
  *   section that will be appended to the zone/node below.
  */
-static void __init init_unavailable_range(unsigned long spfn,
-					  unsigned long epfn,
-					  int zone, int node)
+static unsigned long __init init_unavailable_range(unsigned long spfn,
+						   unsigned long epfn,
+						   int zone, int node)
 {
 	unsigned long pfn;
 	u64 pgcnt = 0;
@@ -836,6 +836,7 @@ static void __init init_unavailable_range(unsigned long spfn,
 	if (pgcnt)
 		pr_info("On node %d, zone %s: %lld pages in unavailable ranges\n",
 			node, zone_names[zone], pgcnt);
+	return pgcnt;
 }
 
 /*
@@ -932,9 +933,21 @@ static void __init memmap_init_zone_range(struct zone *zone,
 	memmap_init_range(end_pfn - start_pfn, nid, zone_id, start_pfn,
 			  zone_end_pfn, MEMINIT_EARLY, NULL, MIGRATE_MOVABLE,
 			  false);
+	zone->pages_with_online_memmap += end_pfn - start_pfn;
 
-	if (*hole_pfn < start_pfn)
-		init_unavailable_range(*hole_pfn, start_pfn, zone_id, nid);
+	if (*hole_pfn < start_pfn) {
+		unsigned long hole_start_pfn = *hole_pfn;
+		unsigned long pgcnt;
+
+		if (hole_start_pfn < zone_start_pfn) {
+			init_unavailable_range(hole_start_pfn, zone_start_pfn,
+					       zone_id, nid);
+			hole_start_pfn = zone_start_pfn;
+		}
+		pgcnt = init_unavailable_range(hole_start_pfn, start_pfn,
+					       zone_id, nid);
+		zone->pages_with_online_memmap += pgcnt;
+	}
 
 	*hole_pfn = end_pfn;
 }
@@ -2250,28 +2263,6 @@ void __init init_cma_pageblock(struct page *page)
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


