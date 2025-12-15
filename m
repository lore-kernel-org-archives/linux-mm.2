Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1646D41D74
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 12:07:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 161DC6B0023; Mon, 15 Dec 2025 07:07:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1398C6B0027; Mon, 15 Dec 2025 07:07:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04FFF6B0028; Mon, 15 Dec 2025 07:07:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E70C06B0023
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 07:07:31 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 96229968C
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 12:07:31 +0000 (UTC)
X-FDA: 84221580702.05.F88312A
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5BABC14001F
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 12:07:29 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IJr2ilOu;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf26.hostedemail.com: domain of tianyou.li@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=tianyou.li@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765800449; a=rsa-sha256;
	cv=none;
	b=CHbBOlxkawSa3HfQLXxTYv0+a46fQXQK71BTlgfPIZ8eVZq3fsftyMr0m8xnvVs+SHDtrr
	+1I4Ux6lqaYpuEoegajuzwPuS8wh5jHUVhk1YAuCNTmXfNStdcRXaVhRapHSDVT/fU+/Su
	IDnS5x8uGZLgDHv6HrlrB/4U9CMnQGE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IJr2ilOu;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf26.hostedemail.com: domain of tianyou.li@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=tianyou.li@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765800449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VHV5DhLsufYyh3Q3Odwwp57EYzqK9AGBvribr3DmtTU=;
	b=upfTVlrEuYZyHd8OdhHUCdLk/FDFA5ytCkct4vwQ7bpNWmBXiiPbXkGEM8rpMXhq5QTyn3
	L11LQJWz9S6k69fYqwwW0L6A1ZUCJYbjk6QbKkjjWbrxRcoZCFfYQd8YpKSnyNshCd+VCY
	63KoPSzrg6CgkCQqd9VDNcnsjZ7eDa4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765800450; x=1797336450;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fwS7+TY4Z+VbLw0aqSOc6vicVlUfjt/T3wdMK/TkQIQ=;
  b=IJr2ilOu69sEdH9d3uPLW9m8J9sKfrEGVZjnTLHcZuIcgNlFuxnl3qnw
   KvxHiL6waCoT259afvZRQvRL1QXr+VtSY9bJG9VJv7xu4PS0K+KqSa7FB
   4xIb1+sXyfAbqeDE0WO2ZxN9gTuU2WaU81NlXZJ0JVZCXDpPSiQMuQ3pB
   nmkd+UCu2v7+ZoQA2QYR9M9ewir664hBwZeArAA1sI72YxuwwtHkT7acM
   CmXBHhlAjJjgLbpTbecsQ742mMEiA7ZsNkzbXrh/fp2NRpOlrxicEJFMq
   n9VF/dL3AiNIsy1YfFaIeO+FVjnuN92J2feCO5lS8bxiDb16feJbg7zzv
   w==;
X-CSE-ConnectionGUID: LSmTCQ3USna0ItshlkzXWA==
X-CSE-MsgGUID: S2wC5kXrR+a3R4NPtd2reQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11642"; a="79154764"
X-IronPort-AV: E=Sophos;i="6.21,150,1763452800"; 
   d="scan'208";a="79154764"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2025 04:07:28 -0800
X-CSE-ConnectionGUID: 9L6dNAMGQC6ZqXwlo151iQ==
X-CSE-MsgGUID: RoG3HVTvQr2MI8esHDf0xQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,150,1763452800"; 
   d="scan'208";a="228357216"
Received: from linux-pnp-server-27.sh.intel.com ([10.239.147.41])
  by orviesa002.jf.intel.com with ESMTP; 15 Dec 2025 04:07:24 -0800
From: Tianyou Li <tianyou.li@intel.com>
To: David Hildenbrand <david@redhat.com>,
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
Subject: [PATCH v6 1/2] mm/memory hotplug/unplug: Optimize zone->contiguous update when changes pfn range
Date: Mon, 15 Dec 2025 21:04:36 +0800
Message-ID: <20251215130437.3914342-2-tianyou.li@intel.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20251215130437.3914342-1-tianyou.li@intel.com>
References: <20251215130437.3914342-1-tianyou.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5BABC14001F
X-Stat-Signature: bruy81ysxmukj6fpueo7f6wdaz1ng8w9
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1765800449-87461
X-HE-Meta: U2FsdGVkX18zga5eICctNAwZgnhYp9xlk7jWI3epywq6bhmRl0IlP9oK/u6zARVS97KF8yDMcGPlh+ZW0uYnGgi60bwIR1yeXUqait324eW0328e589UhvPoDBgRZC/5EIBaBY5AbWKw93vuBtVX/tnvHJpBn5VrqbuhpY7uAFfLqIMqk84eVdEsEyhBqyTUk+nmReFhHcsgetyy+M3cMimHJ01QbXuJCylzrF9ckyTqbovS6gazWj1oPJEPjxRyjwfLVhBnwRqlF26n22qxJFy09NT3rd/0NERsMljaotT2xlZXp/MBYKYVXwLO25XqcVHC4QbXNgEh0Gje/2GMK8/bFwjndN4/VIslDNT53NM8hQO7+bm4GPh62POn3FXnRekylfYqzTEDlY6kTD6e9g+WuK4Akn9SiHjkjTE/FdhWM1wbJa0n81Y0wzHRnLfg+ON3g5wDWMWRjzRt9kbS9UrGtnM27IsbOcavzkiMCGmSa6hJd1fQ2sgr7XxgTUCc7JrzFEYtqzM5Orbr6PDfiUWLLPgwCnwCUO/XaUiPlFrrgE+RVA3Q8MqqeaxHrFhvFsh8v8ZHINaPVIdcgwGdHomHaiYHYRF75LSA9NpbO+TN25/rQLJ6F78VVRurY0vdF94RvvkpaXOWlYEiyI+o/KeWVxQQ2pkehQA1PmM/ACDfuLra566R4/N5BiBUWYQOOthraqOQ0kUNqpJu5q99up61WNN2b2uas0hkb3k0xVkln/QgtTuQwUTR8HoT5UtXmnDxTL4GruVxU+TH/0ytSi8vNgROBbJdNJaDWZsJBurAUCgePrz0Es/E50XTkXPp5+OExpc02rQXY8BKgeCtbtXWJSpMeNeXdK1nMsYp01MOQvqv/uMdunK7ASDUyM9+VNSF13MKbiMItCRDbJSKlgn+2Sd8rqSOPhi4OZGdulph8kptabuoEq7aiA2GnX0xJJu6TgdhoNTNj9kHbPM
 nEEIAwYA
 3SVerBCKsmuOqc4bzVDFaTM2VjbBUtDLaD2oKZy+BAUEAgtoAA8HElsdo8WZpSkCtwap8GmmFWrcaWd9uXvPSw2Hh/uKG1KJSpSvbO53LCDv8Bgeia2E6/igShWuvyQIMVMIjWVWcGAklLhKIykTRZPoux++spOIsK4Q5Gvl6LalOOR3oWeZiC5Qnvkb8hX8TY4YgOuacpVVpFpS4nlq8aVm4LY8zTeeu19S2sNSePU+p+PuEUdtpsGB30Zcn/CANGue/RtWFaVfAtfY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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

Add fast paths to quickly detect cases where zone is definitely not
contiguous without scanning the new zone. The cases are: when the new range
did not overlap with previous range, the contiguous should be false; if the
new range adjacent with the previous range, just need to check the new
range; if the new added pages could not fill the hole of previous zone, the
contiguous should be false.

The following test cases of memory hotplug for a VM [1], tested in the
environment [2], show that this optimization can significantly reduce the
memory hotplug time [3].

+----------------+------+---------------+--------------+----------------+
|                | Size | Time (before) | Time (after) | Time Reduction |
|                +------+---------------+--------------+----------------+
| Plug Memory    | 256G |      10s      |      2s      |       80%      |
|                +------+---------------+--------------+----------------+
|                | 512G |      33s      |      6s      |       81%      |
+----------------+------+---------------+--------------+----------------+

+----------------+------+---------------+--------------+----------------+
|                | Size | Time (before) | Time (after) | Time Reduction |
|                +------+---------------+--------------+----------------+
| Unplug Memory  | 256G |      10s      |      2s      |       80%      |
|                +------+---------------+--------------+----------------+
|                | 512G |      34s      |      6s      |       82%      |
+----------------+------+---------------+--------------+----------------+

[1] Qemu commands to hotplug 256G/512G memory for a VM:
    object_add memory-backend-ram,id=hotmem0,size=256G/512G,share=on
    device_add virtio-mem-pci,id=vmem1,memdev=hotmem0,bus=port1
    qom-set vmem1 requested-size 256G/512G (Plug Memory)
    qom-set vmem1 requested-size 0G (Unplug Memory)

[2] Hardware     : Intel Icelake server
    Guest Kernel : v6.18-rc2
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
Signed-off-by: Tianyou Li <tianyou.li@intel.com>
---
 mm/internal.h       |  8 +++++-
 mm/memory_hotplug.c | 65 ++++++++++++++++++++++++++++++++++++++++++---
 mm/mm_init.c        | 12 +++++++--
 3 files changed, 79 insertions(+), 6 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 1561fc2ff5b8..1b5bba6526d4 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -730,7 +730,13 @@ static inline struct page *pageblock_pfn_to_page(unsigned long start_pfn,
 	return __pageblock_pfn_to_page(start_pfn, end_pfn, zone);
 }
 
-void set_zone_contiguous(struct zone *zone);
+enum zone_contig_state {
+	ZONE_CONTIG_YES,
+	ZONE_CONTIG_NO,
+	ZONE_CONTIG_MAYBE,
+};
+
+void set_zone_contiguous(struct zone *zone, enum zone_contig_state state);
 bool pfn_range_intersects_zones(int nid, unsigned long start_pfn,
 			   unsigned long nr_pages);
 
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 0be83039c3b5..12839032ad42 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -544,6 +544,28 @@ static void update_pgdat_span(struct pglist_data *pgdat)
 	pgdat->node_spanned_pages = node_end_pfn - node_start_pfn;
 }
 
+static enum zone_contig_state zone_contig_state_after_shrinking(struct zone *zone,
+				unsigned long start_pfn, unsigned long nr_pages)
+{
+	const unsigned long end_pfn = start_pfn + nr_pages;
+
+	/*
+	 * If the removed pfn range inside the original zone span, the contiguous
+	 * property is surely false.
+	 */
+	if (start_pfn > zone->zone_start_pfn && end_pfn < zone_end_pfn(zone))
+		return ZONE_CONTIG_NO;
+
+	/* If the removed pfn range is at the beginning or end of the
+	 * original zone span, the contiguous property is preserved when
+	 * the original zone is contiguous.
+	 */
+	if (start_pfn == zone->zone_start_pfn || end_pfn == zone_end_pfn(zone))
+		return zone->contiguous ? ZONE_CONTIG_YES : ZONE_CONTIG_MAYBE;
+
+	return ZONE_CONTIG_MAYBE;
+}
+
 void remove_pfn_range_from_zone(struct zone *zone,
 				      unsigned long start_pfn,
 				      unsigned long nr_pages)
@@ -551,6 +573,7 @@ void remove_pfn_range_from_zone(struct zone *zone,
 	const unsigned long end_pfn = start_pfn + nr_pages;
 	struct pglist_data *pgdat = zone->zone_pgdat;
 	unsigned long pfn, cur_nr_pages;
+	enum zone_contig_state new_contiguous_state = ZONE_CONTIG_MAYBE;
 
 	/* Poison struct pages because they are now uninitialized again. */
 	for (pfn = start_pfn; pfn < end_pfn; pfn += cur_nr_pages) {
@@ -571,12 +594,14 @@ void remove_pfn_range_from_zone(struct zone *zone,
 	if (zone_is_zone_device(zone))
 		return;
 
+	new_contiguous_state = zone_contig_state_after_shrinking(zone, start_pfn,
+								nr_pages);
 	clear_zone_contiguous(zone);
 
 	shrink_zone_span(zone, start_pfn, start_pfn + nr_pages);
 	update_pgdat_span(pgdat);
 
-	set_zone_contiguous(zone);
+	set_zone_contiguous(zone, new_contiguous_state);
 }
 
 /**
@@ -736,6 +761,39 @@ static inline void section_taint_zone_device(unsigned long pfn)
 }
 #endif
 
+static enum zone_contig_state zone_contig_state_after_growing(struct zone *zone,
+				unsigned long start_pfn, unsigned long nr_pages)
+{
+	const unsigned long end_pfn = start_pfn + nr_pages;
+
+	if (zone_is_empty(zone))
+		return ZONE_CONTIG_YES;
+
+	/*
+	 * If the moved pfn range does not intersect with the original zone span,
+	 * the contiguous property is surely false.
+	 */
+	if (end_pfn < zone->zone_start_pfn || start_pfn > zone_end_pfn(zone))
+		return ZONE_CONTIG_NO;
+
+	/*
+	 * If the moved pfn range is adjacent to the original zone span, given
+	 * the moved pfn range's contiguous property is always true, the zone's
+	 * contiguous property inherited from the original value.
+	 */
+	if (end_pfn == zone->zone_start_pfn || start_pfn == zone_end_pfn(zone))
+		return zone->contiguous ? ZONE_CONTIG_YES : ZONE_CONTIG_NO;
+
+	/*
+	 * If the original zone's hole larger than the moved pages in the range,
+	 * the contiguous property is surely false.
+	 */
+	if (nr_pages < (zone->spanned_pages - zone->present_pages))
+		return ZONE_CONTIG_NO;
+
+	return ZONE_CONTIG_MAYBE;
+}
+
 /*
  * Associate the pfn range with the given zone, initializing the memmaps
  * and resizing the pgdat/zone data to span the added pages. After this
@@ -752,7 +810,8 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
 {
 	struct pglist_data *pgdat = zone->zone_pgdat;
 	int nid = pgdat->node_id;
-
+	const enum zone_contig_state new_contiguous_state =
+		zone_contig_state_after_growing(zone, start_pfn, nr_pages);
 	clear_zone_contiguous(zone);
 
 	if (zone_is_empty(zone))
@@ -783,7 +842,7 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
 			 MEMINIT_HOTPLUG, altmap, migratetype,
 			 isolate_pageblock);
 
-	set_zone_contiguous(zone);
+	set_zone_contiguous(zone, new_contiguous_state);
 }
 
 struct auto_movable_stats {
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 7712d887b696..8a56b838913e 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2263,11 +2263,19 @@ void __init init_cma_pageblock(struct page *page)
 }
 #endif
 
-void set_zone_contiguous(struct zone *zone)
+void set_zone_contiguous(struct zone *zone, enum zone_contig_state state)
 {
 	unsigned long block_start_pfn = zone->zone_start_pfn;
 	unsigned long block_end_pfn;
 
+	if (state == ZONE_CONTIG_YES) {
+		zone->contiguous = true;
+		return;
+	}
+
+	if (state == ZONE_CONTIG_NO)
+		return;
+
 	block_end_pfn = pageblock_end_pfn(block_start_pfn);
 	for (; block_start_pfn < zone_end_pfn(zone);
 			block_start_pfn = block_end_pfn,
@@ -2348,7 +2356,7 @@ void __init page_alloc_init_late(void)
 		shuffle_free_memory(NODE_DATA(nid));
 
 	for_each_populated_zone(zone)
-		set_zone_contiguous(zone);
+		set_zone_contiguous(zone, ZONE_CONTIG_MAYBE);
 
 	/* Initialize page ext after all struct pages are initialized. */
 	if (deferred_struct_pages)
-- 
2.47.1


