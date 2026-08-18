Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23BE4C5DF80
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 08:53:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46CBF6B0160; Tue, 18 Aug 2026 04:53:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 443DA6B0161; Tue, 18 Aug 2026 04:53:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30D996B0163; Tue, 18 Aug 2026 04:53:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 01B7C6B0160
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 04:53:32 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9293F1A0BD6
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 08:53:32 +0000 (UTC)
X-FDA: 85113776664.13.8611E56
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2056C20009
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 08:53:29 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="lQ+Hvh+/";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf13.hostedemail.com: domain of yuan1.liu@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787043210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jpUdbPeUHcygFgjnb8fKa6nPorHhWCwTkT6JWZbJ3hY=;
	b=WrIhWOsQ5HoVHUmdrItLW6IkbkrsLXWc2znKnGSYMN+8YhwxFtd0HUyaQv2eIxIrAexXly
	frWC/4QuUg9A6bstQBerqvFb3sVO+v6gI4XhH4w7/5jTAiyYaT0EIwoFUbr9d560UJYIhY
	+3VZg1UbtBtcBt9EucCiK1v7LHz+BVA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="lQ+Hvh+/";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf13.hostedemail.com: domain of yuan1.liu@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787043210;
	b=Hxp3pElXGgyEzpnAlGM3pTcCEm+d+Amh0C2fC9F3I8VNwZo/oWndt19axPG+gFOnn0uPoL
	htbkDOLusyUjP7i9w/r0sFyxxKsx9yPcLREZ8U5Win5pLAgzpJWHb8+DIvAifmAPStpFIs
	2KI1Sy9FA/+zT6N1il43QsgGyX5Q8mo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787043210; x=1818579210;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Z+RYv5HKf5AEjLqXKBXVdkhl7Q55X+j0OFSE/dr+2xY=;
  b=lQ+Hvh+/VZQ5bMdrjcejtCle6jm8oRk/2Ejv4qIDRs+Bp5QWY1123ldO
   ujjRpPivu6mnKLg3up/FfJhRGNKRlTln/pEPWDbzTE1LQlW6CkgzWSVcf
   H7z6Jhlmf6kuWB4dyavh1OLmUzXMT+J3TCjyZzoc49DUFe8NvJmEfE/hv
   4fTJAhG/UdHD3fOnTQGcmnOf8hhG8LBnJvmNqkirURHBWqKWh1dFH+sAM
   51rVsZ8pJGUlRpoSY1GSUo0Bn7E8WRcAbdE62KifcWt0LJXzZCMOWiLMb
   kYFFp/Sulur/34B2RWagDtSxS+Xo4i6RShtmRt42Wm93SucxjbjH3mQ3U
   Q==;
X-CSE-ConnectionGUID: rZ1KPIHGS6y5qCCziUosaQ==
X-CSE-MsgGUID: In3VX7CsQ9WZrHcJZonBTg==
X-IronPort-AV: E=McAfee;i="6800,10657,11878"; a="87292230"
X-IronPort-AV: E=Sophos;i="6.25,230,1779174000"; 
   d="scan'208";a="87292230"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2026 01:53:29 -0700
X-CSE-ConnectionGUID: +WrKAR2iQQerXN6TqB9glw==
X-CSE-MsgGUID: +31DWMrmSnCH1iYj1Vyfdg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,230,1779174000"; 
   d="scan'208";a="262539343"
Received: from spr10.sh.intel.com (HELO localhost) ([10.239.23.75])
  by fmviesa008.fm.intel.com with ESMTP; 18 Aug 2026 01:53:26 -0700
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
Subject: [PATCH v7 2/2] mm/memory_hotplug: optimize zone contiguous check when changing pfn range
Date: Tue, 18 Aug 2026 04:57:02 -0400
Message-ID: <20260818085702.3395529-3-yuan1.liu@intel.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260818085702.3395529-1-yuan1.liu@intel.com>
References: <20260818085702.3395529-1-yuan1.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nnqmzd6r6ficbez9rjtocmj6w43jdukf
X-Rspamd-Queue-Id: 2056C20009
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787043209-160212
X-HE-Meta: U2FsdGVkX19d4KvhMDZypm6aJBnfQlonOewjY9yX8hh3RSz8ixtdV8OYKuvK7NBpnZR0IHRPhyIIKZ/Q4DuE+K9rK1bTogrBGTknYeZx/ohuhaP2uWfPvxMwNV0XGxhWXuelE44WHPmxkSA3s0KoH39Lq9DOKaj31su0c4gGUT/e55hR6bvLa8Q94rxdqawPaJD6C9CQnvN+IjJqSvRWINLAXQLGiaHbg8KMZguKL27H+8DzCXoiSzzp1C5XGhzUYkqwquAtA076VL6hYScDXmE3MdyY7eBpu0G2KxZzGvcRIe5Dm+UYQoZ46lu8uToAjOlq4yu62/kTaY/k6hI+DWwew7xb1XAJ5Xtn6colSe8JdWnZpUSQqquSivUlnQCwvt7Sxbl4a5/A635dWZpfGgJ5LX1JZ99OGcE7wxSNdFlLgygpSjz9kU4a9xnD7mEfGal76qye8Sb429vnlUrg94lhgefyNxVunP9S5LhnzAqmqcfWTkOeFaPIU2Z6StfIBS+zQuYLYdKw+9AB/I1iBApEGBFpOx55TRDmZ+L8CeP6oPXGGG4SUZI81Qm+pVv7PUsjHJeAEdykizVwGpvT8IGuUzSOp1rhwOXaDN2uYYxSbNbqRB4hcqiVW47I89B+EuvGAVkT9F65lSsXccPWhRMWditw/n4Mw6FGe5jO6MScG1MnRMEtTM4fB8nJwR5uJFQoVIIwSZR8vAK0E0sq3pdZAso93Dd1WXP0sh9jeZqhWKZGVJJziZiOg1SRsh8mq36wjh123FI80u8VLT8H96Q77pNkT+6Zb+Ii/rczsUa0Qz0YQ7bcM/0dKUXewA4FdesaAUI/UI4M/CNq5q+wqT7q4bT1lWroGUbFfv8bW0Tpi6TO62WwI3PLb7PXQh6ZSbcMXrKbEExRnJRkhmvtss9LrZGSpLw5QMv5/M0qUHpM5pZ4uPdIaBsHT0YoNVOa6MXHRtmZJNe+GhsyrI4
 A5V9zPB8
 cfleS4lruhLkr3KmcQTmUb6vaRsn1WZnkF8u6fJhwvJFTX1BJJwY+7/CXB/SA+TbfrD9R7ImWZECTA3XniVEhJ1kC+Qc83mkNRJBhSSQYAJAa5mN7iuz7WuYz0tKEK7vk22vMTcgK0bRODc++sykyXUb/3EvRLmu0lMVr/eIwqwXrK0HYkwknREWPYdfYZv5LXpkbE5xrE1GFaLVQWVW1aRnQZ4XngZyRBdmMEJw2exzkux7sYXv3nzbQT1hJBwT5OFnL6VWidxw+pohpwlvE1NAJ8PF7qN5ixxQvzfis4B3K+VctV9fNaYqCQsqqsCMVf5st
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
    Guest Kernel : v7.2-rc1
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
 drivers/base/memory.c                |  7 ++-
 include/linux/mmzone.h               | 48 ++++++++++++++++++
 mm/internal.h                        |  8 +--
 mm/memory_hotplug.c                  | 12 +----
 mm/mm_init.c                         | 73 +++++++++++++++++-----------
 6 files changed, 108 insertions(+), 46 deletions(-)

diff --git a/Documentation/mm/physical_memory.rst b/Documentation/mm/physical_memory.rst
index b76183545e5b..ceea6c8b27cc 100644
--- a/Documentation/mm/physical_memory.rst
+++ b/Documentation/mm/physical_memory.rst
@@ -483,6 +483,12 @@ General
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
index bcfe2d9f4adb..97699be9a357 100644
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
@@ -295,6 +297,7 @@ static int memory_block_offline(struct memory_block *mem)
 		nr_vmemmap_pages = mem->altmap->free;
 
 	mem_hotplug_begin();
+	clear_zone_contiguous(mem->zone);
 	if (nr_vmemmap_pages)
 		adjust_present_page_count(pfn_to_page(start_pfn), mem->group,
 					  -nr_vmemmap_pages);
@@ -312,8 +315,10 @@ static int memory_block_offline(struct memory_block *mem)
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
index ca2712187147..58f342de3bac 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1032,6 +1032,21 @@ struct zone {
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
@@ -1056,6 +1071,7 @@ struct zone {
 	atomic_long_t		managed_pages;
 	unsigned long		spanned_pages;
 	unsigned long		present_pages;
+	unsigned long		pages_with_online_memmap;
 #if defined(CONFIG_MEMORY_HOTPLUG)
 	unsigned long		present_early_pages;
 #endif
@@ -1681,6 +1697,38 @@ static inline bool zone_is_zone_device(const struct zone *zone)
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
index cd82e79f0782..8dbd50d88155 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -546,18 +546,13 @@ void remove_pfn_range_from_zone(struct zone *zone,
 
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
@@ -735,8 +730,6 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
 	struct pglist_data *pgdat = zone->zone_pgdat;
 	int nid = pgdat->node_id;
 
-	clear_zone_contiguous(zone);
-
 	if (zone_is_empty(zone))
 		init_currently_empty_zone(zone, start_pfn, nr_pages);
 	resize_zone_range(zone, start_pfn, nr_pages);
@@ -764,8 +757,6 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
 	memmap_init_range(nr_pages, nid, zone_idx(zone), start_pfn, 0,
 			 MEMINIT_HOTPLUG, altmap, migratetype,
 			 isolate_pageblock);
-
-	set_zone_contiguous(zone);
 }
 
 struct auto_movable_stats {
@@ -1061,6 +1052,7 @@ void adjust_present_page_count(struct page *page, struct memory_group *group,
 	if (early_section(__pfn_to_section(page_to_pfn(page))))
 		zone->present_early_pages += nr_pages;
 	zone->present_pages += nr_pages;
+	zone->pages_with_online_memmap += nr_pages;
 	zone->zone_pgdat->node_present_pages += nr_pages;
 
 	if (group && movable)
diff --git a/mm/mm_init.c b/mm/mm_init.c
index f1afe023e4e7..d63ee554d7eb 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -799,6 +799,28 @@ void __meminit init_deferred_page(unsigned long pfn, int nid)
 	__init_deferred_page(pfn, nid);
 }
 
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
+static bool __init unavailable_pfn_is_online(unsigned long pfn,
+					     unsigned long *last_subsection,
+					     bool *is_online)
+{
+	unsigned long subsection = pfn & PAGE_SUBSECTION_MASK;
+
+	if (subsection != *last_subsection) {
+		*is_online = !!pfn_to_online_page(pfn);
+		*last_subsection = subsection;
+	}
+	return *is_online;
+}
+#else
+static inline bool unavailable_pfn_is_online(unsigned long pfn,
+					     unsigned long *last_subsection,
+					     bool *is_online)
+{
+	return true;
+}
+#endif
+
 /*
  * Only struct pages that correspond to ranges defined by memblock.memory
  * are zeroed and initialized by going through __init_single_page() during
@@ -822,22 +844,27 @@ void __meminit init_deferred_page(unsigned long pfn, int nid)
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
-	u64 pgcnt = 0;
+	u64 pgcnt = 0, online_pgcnt = 0;
+	unsigned long last_subsection = -1;
+	bool is_online = false;
 
 	for_each_valid_pfn(pfn, spfn, epfn) {
 		__init_single_page(pfn_to_page(pfn), pfn, zone, node);
 		__SetPageReserved(pfn_to_page(pfn));
+		if (unavailable_pfn_is_online(pfn, &last_subsection, &is_online))
+			online_pgcnt++;
 		pgcnt++;
 	}
 
 	if (pgcnt)
 		pr_info("On node %d, zone %s: %lld pages in unavailable ranges\n",
 			node, zone_names[zone], pgcnt);
+	return online_pgcnt;
 }
 
 /*
@@ -934,9 +961,21 @@ static void __init memmap_init_zone_range(struct zone *zone,
 
 	memmap_init_range(end_pfn - start_pfn, nid, zone_id, start_pfn,
 			  zone_end_pfn, MEMINIT_EARLY, NULL, mt, false);
+	zone->pages_with_online_memmap += end_pfn - start_pfn;
+
+	if (*hole_pfn < start_pfn) {
+		unsigned long hole_start_pfn = *hole_pfn;
+		unsigned long pgcnt;
 
-	if (*hole_pfn < start_pfn)
-		init_unavailable_range(*hole_pfn, start_pfn, zone_id, nid);
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
@@ -2195,28 +2234,6 @@ void __init init_cma_pageblock(struct page *page)
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


