Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90A8BC61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 05:26:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A51C86B00BC; Tue,  1 Sep 2026 01:26:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2A696B00BD; Tue,  1 Sep 2026 01:26:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 918F86B00BE; Tue,  1 Sep 2026 01:26:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6776C6B00BC
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 01:26:28 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D885880359
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 05:26:27 +0000 (UTC)
X-FDA: 85164058014.20.7E7D18B
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf30.hostedemail.com (Postfix) with ESMTP id 48FCE80003
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 05:26:25 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LJrtnEu6;
	spf=pass (imf30.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788240385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hrll4R7+M6/shkFjtljCI51Kz0EBGQACySGcXtSW0hg=;
	b=ccEcnlfoX+VszyOA6VOS1Kfiy/3Kd2jnfWBL7VbkwpAhKeKgpG08nnvrB3PW2t/vSIrwQG
	qBnIEKk0lw5yhLW3H7lFQ6QIwTbQNxPXJEwaixeBwvh+EcB0XbfIBv/WNmlwctGo+t88/M
	JINOW4ZucCrDYkouCeacL+kSjJmk+d8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788240385;
	b=VuFNQpunbbV/PS8oVTa4NdAmivzQEIBYsFjE7G/4P54hYPnQZXm331sDlMdmKApZHiJBLR
	rXy88fFZj4Wi4Jq5W4HeUfmZKIgIMGic7Avd/ShxSuoxZn1vT5LeKS2NTI/9kK4JwgsNpu
	isJamcYqrQ6MMPYwuRS5A2pRyhZsP+E=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LJrtnEu6;
	spf=pass (imf30.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788240385; x=1819776385;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RoaZidmG7b7/mz0yVDo9ZctXO8An3zNHM3in1PWNKYo=;
  b=LJrtnEu6S3ZYgfuNsORmN8yVFAcfSJ51nfZcHgbUm4NjDiUn9bXrmgBI
   LjfJeSz8v5CjurRR6CxRPPXtIYEfiL57BJrKy9zKLsX3Q409LcsjEC2l2
   kAaf5xq0F8R6648lMktu02aRa9WUn0/cA/2wN8LtouANsi3SJX0CIMz+C
   papPQhYyCVskV+2+qtfncw2WtfLUZiVWcUCeRb75O6zlY+AmoeqYCPDEi
   t4huoNjoom++cWOvJ8EJE+Mmp5BIh0BGXL7SOyKVIzOM0Vo9XltQT+D62
   JWntOuDlPk0rndXA0gIQoMV8IgiOYSqJApeqVlpIEFg2r8P9QpWg0/mxe
   g==;
X-CSE-ConnectionGUID: hMt3Am4FQKaP/riBMiTOKQ==
X-CSE-MsgGUID: JZh3y+mDTNyF1QpuXJ8P3A==
X-IronPort-AV: E=McAfee;i="6800,10657,11892"; a="106178904"
X-IronPort-AV: E=Sophos;i="6.25,255,1779174000"; 
   d="scan'208";a="106178904"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 22:26:24 -0700
X-CSE-ConnectionGUID: FjQQqBa3RAC7vKUvQaze4g==
X-CSE-MsgGUID: 8P5bcomPRs6UhkCAGUXvtA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,255,1779174000"; 
   d="scan'208";a="292482115"
Received: from spr10.sh.intel.com (HELO localhost) ([10.239.23.75])
  by fmviesa002.fm.intel.com with ESMTP; 31 Aug 2026 22:26:21 -0700
From: Yuan Liu <yuan1.liu@intel.com>
To: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>
Cc: linux-mm@kvack.org,
	Nanhai Zou <nanhai.zou@intel.com>,
	Chen Zhang <zhangchen.kidd@jd.com>,
	Yuan Liu <yuan1.liu@intel.com>,
	Jason Zeng <jason.zeng@intel.com>,
	Chen Yu <yu.c.chen@intel.com>,
	Pan Deng <pan.deng@intel.com>,
	Tianyou Li <tianyou.li@intel.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v8 2/2] mm/memory_hotplug: optimize zone contiguous check when changing pfn range
Date: Tue,  1 Sep 2026 01:29:50 -0400
Message-ID: <20260901052950.3284540-3-yuan1.liu@intel.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260901052950.3284540-1-yuan1.liu@intel.com>
References: <20260901052950.3284540-1-yuan1.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 48FCE80003
X-Stat-Signature: cp3hff4xo5ax48o7izmisph9edu987ro
X-HE-Tag: 1788240385-986003
X-HE-Meta: U2FsdGVkX1+oV2izSQ6Gb7KjtJC2jso+jTcOmSXq9U6eR4JvIJVdQiwSxbejNpdLcfjgzIqiGcCOzedpIPIJ3CIMYHCkg8D/MW62xI7dpEe1fYa+l+cBzfJC5Iav+8Q9oljI+jE0SQkQULlpXJCxfKusJxhMFW6Jx+kC1bsStn3C51pu5PZ266el6N1MuGtqDU+aiAZH2cMhKO5RyvLFkl00fBw4cF3vF2t+SjbdujSHKHfbB3yLsMdGnYOJxMRJjU43XMRfqjfy0eOMK8HPLX2kTcHlZJFgzluPesp3nkxVDkVsMGOIMvBmEF4/M2wBqNTF3uQ9uK2QUxC2xfD8v+sJhQIYMztf0PPLQbkPr+LxMYDPfRCLYAgY2q7S2A3uHL9FvvKavXh6IrzRTYDjU8StBAIxQwAejo1x7mQ5kH/WLYg7MUbehF8BclPC2rIn3HfBHu6xzCWTmv3mCAC57XSowCCLe0PEYl+8FE/3c87XGvPiXN4/xZdaMxCokED7fMjz/3VBWdYRWx1jYIqj8IS1TRe8ujVeyP4UO5LQld8GlSmQPAuYktvkVCEtItDQiE1PlCac1WYqJvS2D/LR4dU6TlYe1W1b0oJNsGJaMLu9dlUAo4jQboH6uykZ6IkxX1dAXEhbkuxKyiCTCl39fnlHFgbONRzdXHAk8NL1CwpUJTWEsIyt2PVnnanECD8khb9YW9TdV8fH9iFILhw1dq4o7TkqjFDds0AoihRqOmBVaUMUIiC6A+DnWFC+EHxwzvYQAX74K1aLuumIsH7INQt1y+TsN1jF60fhtGMnBh62CejLORFDTJ4TcoV9dita9V5bIkM8b9u4RLfeIVpsL+YzMiBYUmWs1FlBu3hDzKrQRPOc7jkNYHSxycvGO8pgJsQrks0DrDjtlZVyqcWyDMyqGiLBihhVoFAU+Lzy1V2RCLK2Fb2ysk1+12XkrrExdRuSc5huo1k5IcAyaxp
 JJ7yM1K1
 u89M+xSbdPlUKYlR2HK5oQ9pmBeKO13z3n5DG0altf9spDaN3kiPO9BNaqmv8NKbOKet7phUinQLchu6v81peWM3atuj/OACKusAuKZxY665pmLYoSjjVsuagyhsVgk4PrsRCHM76s9GJ+ZmAHFlJJAysQKM7TtSvUGfCOZkcVGGb0i2oYPaUh4QLfA4TOkWSxFhY6wFI+oMrrp/Gy2ScPhCmYubQLJ0M6D5RvBJAT5mc/WCikJw1XWGOLBrrfP2ROdyjrvntTD+P23XnEjyqg7lO/Yt5t0ehslc3AcHkC3NwUiM3wqocpX/29X0rTLaIf9x5mP/WOUAhogU=
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

Add a new zone member, pages_with_online_memmap, that tracks the
number of pages within the zone span that have an online memory map,
including present pages and memory holes whose memory map has been
initialized and for which pfn_to_online_page() succeeds.

For early boot memory, pages_with_online_memmap is calculated in
memmap_init_zone_range(). PFNs initialized by memmap_init_range() are
included in pages_with_online_memmap, and hole PFNs for which
pfn_to_online_page() succeeds are also counted in
init_unavailable_range(). For hotplugged memory,
pages_with_online_memmap is updated through adjust_present_page_count(),
which is called during memory online and offline operations. When
spanned_pages == pages_with_online_memmap, every PFN in the zone span
has a valid memmap entry, so pfn_to_page() can be called for any PFN
within the zone span without an additional pfn_valid() check.

The counter may temporarily undercount when pages with an online
memory map exist outside the current zone span. This can only happen
during boot, when initializing the memory map of pages that do not
fall into any zone span. Growing the zone to cover such pages and
later shrinking it back may result in a value that is too small.
This is safe, as it merely prevents detecting a contiguous zone.

The contiguity check using pages_with_online_memmap is stricter than
the old pageblock-by-pageblock scan. The old set_zone_contiguous()
iterated at pageblock granularity via pageblock_pfn_to_page(), so a
zone could be marked contiguous even if a subsection-sized hole
existed within a pageblock. The new check requires
spanned_pages == pages_with_online_memmap, meaning every PFN in the
zone span must satisfy pfn_to_online_page().

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
    Guest Kernel : v7.3-rc1
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
Reviewed-by: Jason Zeng <jason.zeng@intel.com>
Reviewed-by: Chen Yu <yu.c.chen@intel.com>
Reviewed-by: Pan Deng <pan.deng@intel.com>
Co-developed-by: Tianyou Li <tianyou.li@intel.com>
Signed-off-by: Tianyou Li <tianyou.li@intel.com>
Signed-off-by: Yuan Liu <yuan1.liu@intel.com>
---
 Documentation/mm/physical_memory.rst |  6 +++
 drivers/base/memory.c                |  7 +++-
 include/linux/mmzone.h               | 48 +++++++++++++++++++++
 mm/memory_hotplug.c                  | 12 +-----
 mm/mm_init.c                         | 63 +++++++++++++++-------------
 mm/mm_init.h                         |  6 ---
 mm/page_alloc.h                      |  2 +-
 7 files changed, 98 insertions(+), 46 deletions(-)

diff --git a/Documentation/mm/physical_memory.rst b/Documentation/mm/physical_memory.rst
index a09407d72973..2e67e8b23a99 100644
--- a/Documentation/mm/physical_memory.rst
+++ b/Documentation/mm/physical_memory.rst
@@ -480,6 +480,12 @@ General
   ``present_pages`` should use ``get_online_mems()`` to get a stable value. It
   is initialized by ``calculate_node_totalpages()``.
 
+``pages_with_online_memmap``
+  Pages within the zone that have an online memory map: present pages and
+  memory holes whose memory map has been initialized and
+  ``pfn_to_online_page()`` succeeds. See the comment for
+  ``pages_with_online_memmap`` in ``include/linux/mmzone.h`` for more details.
+
 ``present_early_pages``
   The present pages existing within the zone located on memory available since
   early boot, excluding hotplugged memory. Defined only when
diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 5eead3346f1e..28f9503f6a71 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -255,6 +255,7 @@ static int memory_block_online(struct memory_block *mem)
 		nr_vmemmap_pages = mem->altmap->free;
 
 	mem_hotplug_begin();
+	clear_zone_contiguous(zone);
 	if (nr_vmemmap_pages) {
 		ret = mhp_init_memmap_on_memory(start_pfn, nr_vmemmap_pages, zone);
 		if (ret)
@@ -279,6 +280,7 @@ static int memory_block_online(struct memory_block *mem)
 
 	mem->zone = zone;
 out:
+	set_zone_contiguous(zone);
 	mem_hotplug_done();
 	return ret;
 }
@@ -304,6 +306,7 @@ static int memory_block_offline(struct memory_block *mem)
 		nr_vmemmap_pages = mem->altmap->free;
 
 	mem_hotplug_begin();
+	clear_zone_contiguous(mem->zone);
 	if (nr_vmemmap_pages)
 		adjust_present_page_count(pfn_to_page(start_pfn), mem->group,
 					  -nr_vmemmap_pages);
@@ -321,8 +324,10 @@ static int memory_block_offline(struct memory_block *mem)
 	if (nr_vmemmap_pages)
 		mhp_deinit_memmap_on_memory(start_pfn, nr_vmemmap_pages);
 
-	mem->zone = NULL;
 out:
+	set_zone_contiguous(mem->zone);
+	if (!ret)
+		mem->zone = NULL;
 	mem_hotplug_done();
 	return ret;
 }
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 94f9c3ff5416..7bfb871d6344 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1043,6 +1043,21 @@ struct zone {
 	 * cma pages is present pages that are assigned for CMA use
 	 * (MIGRATE_CMA).
 	 *
+	 * pages_with_online_memmap tracks pages within the zone that have
+	 * an online memory map: present pages and memory holes whose
+	 * memory map has been initialized and pfn_to_online_page()
+	 * succeeds. When spanned_pages == pages_with_online_memmap,
+	 * pfn_to_page() can be performed without further checks on any
+	 * PFN within the zone span.
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
@@ -1067,6 +1082,7 @@ struct zone {
 	atomic_long_t		managed_pages;
 	unsigned long		spanned_pages;
 	unsigned long		present_pages;
+	unsigned long		pages_with_online_memmap;
 #if defined(CONFIG_MEMORY_HOTPLUG)
 	unsigned long		present_early_pages;
 #endif
@@ -1694,6 +1710,38 @@ static inline bool zone_is_zone_device(const struct zone *zone)
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
+	return READ_ONCE(zone->contiguous);
+}
+
+static inline void set_zone_contiguous(struct zone *zone)
+{
+	if (zone_is_zone_device(zone))
+		return;
+	if (zone->spanned_pages == zone->pages_with_online_memmap)
+		WRITE_ONCE(zone->contiguous, true);
+}
+
+static inline void clear_zone_contiguous(struct zone *zone)
+{
+	WRITE_ONCE(zone->contiguous, false);
+}
+
 /*
  * Returns true if a zone has pages managed by the buddy allocator.
  * All the reclaim decisions have to use this function rather than
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 9f19876ec3ec..100941d1b828 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -549,18 +549,13 @@ void remove_pfn_range_from_zone(struct zone *zone,
 
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
@@ -738,8 +733,6 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
 	struct pglist_data *pgdat = zone->zone_pgdat;
 	int nid = pgdat->node_id;
 
-	clear_zone_contiguous(zone);
-
 	if (zone_is_empty(zone))
 		init_currently_empty_zone(zone, start_pfn, nr_pages);
 	resize_zone_range(zone, start_pfn, nr_pages);
@@ -767,8 +760,6 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
 	memmap_init_range(nr_pages, nid, zone_idx(zone), start_pfn, 0,
 			 MEMINIT_HOTPLUG, altmap, migratetype,
 			 isolate_pageblock);
-
-	set_zone_contiguous(zone);
 }
 
 struct auto_movable_stats {
@@ -1064,6 +1055,7 @@ void adjust_present_page_count(struct page *page, struct memory_group *group,
 	if (early_section(__pfn_to_section(page_to_pfn(page))))
 		zone->present_early_pages += nr_pages;
 	zone->present_pages += nr_pages;
+	zone->pages_with_online_memmap += nr_pages;
 	zone->zone_pgdat->node_present_pages += nr_pages;
 
 	if (group && movable)
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 1533aebafb68..d40a8ff23370 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -817,22 +817,39 @@ void __meminit init_deferred_page(unsigned long pfn, int nid)
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
+	unsigned long next_chunk_pfn __maybe_unused = spfn;
 	unsigned long pfn;
-	u64 pgcnt = 0;
+	u64 online_pgcnt = 0, pgcnt = 0;
+	bool is_online = true;
 
 	for_each_valid_pfn(pfn, spfn, epfn) {
 		__init_single_page(pfn_to_page(pfn), pfn, zone, node);
 		__SetPageReserved(pfn_to_page(pfn));
 		pgcnt++;
+
+		/*
+		 * With vmemmap, at this stage all pages in an early section
+		 * have a valid memmap and are marked as online. However, only
+		 * subsections in the subsection map are actually online.
+		 */
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
+		if (pfn >= next_chunk_pfn) {
+			is_online = pfn_section_valid(__pfn_to_section(pfn), pfn);
+			next_chunk_pfn = min(SUBSECTION_ALIGN_UP(pfn + 1), epfn);
+		}
+#endif
+		if (is_online)
+			online_pgcnt++;
 	}
 
 	if (pgcnt)
 		pr_info("On node %d, zone %s: %lld pages in unavailable ranges\n",
 			node, zone_names[zone], pgcnt);
+	return online_pgcnt;
 }
 
 /*
@@ -930,9 +947,21 @@ static void __init memmap_init_zone_range(struct zone *zone,
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
@@ -2188,28 +2217,6 @@ void __init init_cma_pageblock(struct page *page)
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
diff --git a/mm/mm_init.h b/mm/mm_init.h
index 39f75df9be1c..520d53ecc68d 100644
--- a/mm/mm_init.h
+++ b/mm/mm_init.h
@@ -20,15 +20,9 @@ struct vmem_altmap;
 /* perform sanity checks on struct pages being allocated or freed */
 DECLARE_STATIC_KEY_MAYBE(CONFIG_DEBUG_VM, check_pages_enabled);
 
-void set_zone_contiguous(struct zone *zone);
 bool pfn_range_intersects_zones(int nid, unsigned long start_pfn,
 			   unsigned long nr_pages);
 
-static inline void clear_zone_contiguous(struct zone *zone)
-{
-	zone->contiguous = false;
-}
-
 void memblock_free_pages(unsigned long pfn, unsigned int order);
 
 void *memmap_alloc(phys_addr_t size, phys_addr_t align, phys_addr_t min_addr,
diff --git a/mm/page_alloc.h b/mm/page_alloc.h
index b9259deddb59..d4182f7cb7dd 100644
--- a/mm/page_alloc.h
+++ b/mm/page_alloc.h
@@ -214,7 +214,7 @@ extern struct page *__pageblock_pfn_to_page(unsigned long start_pfn,
 static inline struct page *pageblock_pfn_to_page(unsigned long start_pfn,
 				unsigned long end_pfn, struct zone *zone)
 {
-	if (zone->contiguous)
+	if (zone_is_contiguous(zone))
 		return pfn_to_page(start_pfn);
 
 	return __pageblock_pfn_to_page(start_pfn, end_pfn, zone);
-- 
2.47.3


