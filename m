Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AB6ED116F5
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 12:24:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BF6D6B0030; Mon,  1 Dec 2025 07:24:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 497566B0031; Mon,  1 Dec 2025 07:24:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D3C26B0032; Mon,  1 Dec 2025 07:24:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2CADD6B0030
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 07:24:29 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E38AF13080B
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 12:24:28 +0000 (UTC)
X-FDA: 84170820216.07.D4025B7
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0BD0C4000D
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 12:24:25 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ngmQiRLN;
	spf=pass (imf07.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764591866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=wrILCi4aZRnlVkga/1f26XLv3W3ZZyvhvDRM5MixYUs=;
	b=uBQzKRicqfo37mkBu4wTuwxW3ov4RocekXTGv3VbimE1tanwzReihbdJ3MQ9WmJILmLUy9
	qW3cROA8Y+hTj0FRjeiGgCtV1PVsp1GkohbLmR2rLcQQIdVhpzktDdd9SMJaXw2WTcGkbg
	nkt/ZQqqLL+/GAOigmKJNdxqq5+uE1k=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ngmQiRLN;
	spf=pass (imf07.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764591866; a=rsa-sha256;
	cv=none;
	b=N1015LLV4XHzpi+jNwZvUUKxXD0dnLLPoix3qK6c+XIQzEsRLzK7cpyB/WLG5RcTH+1KeU
	C81Ga0zB6Zq5Peqr1An8Hoxg8ATHcmIyWOvUDHx1G/DpJ/xu1u9BrUolITAAgxQkEpN20Q
	y3KAwYUj5Tvi/Xz9QSmUMVyWU7oPW3c=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764591866; x=1796127866;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=8hCebE/6vQVoeJdDj2t2yEVh2qzS8Dr/Tb3OeINOkq4=;
  b=ngmQiRLNcyDrgefukbOScnX1iaYlfHR9/uQ0RjHa07k9Kehddc3H/GBt
   Hey5DCdlJdpYXHMO3E7MczlWIrv7T1bsg0NCnzgtIFxGHTm7R9HMUgtCy
   R7JvpRlpixGtXacGvVGzNtgCOFNFsbABTU92HknSk+Sk/N+vddv+VrVsy
   RF2G+iu4jrz2TOU/WC2vjtheuUGIsCjh2j+0rb5U4Xt43WPxQnGpNd9Qx
   MdC/ZaOFFS23tf5oGzURzhl5Rw9IzdUgIi4nFOhovNfmf+3CFm7BjjhAJ
   nniydV9tng1BertSpeqxTz1Cwmm9YwhQaUKFy0jpFT9WBWnypaMIfy2LU
   A==;
X-CSE-ConnectionGUID: MOigPosUTOKJc3n45BZhrg==
X-CSE-MsgGUID: PccZj0C0Sc+YL7fvPzvN5g==
X-IronPort-AV: E=McAfee;i="6800,10657,11629"; a="54082915"
X-IronPort-AV: E=Sophos;i="6.20,240,1758610800"; 
   d="scan'208";a="54082915"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 04:24:24 -0800
X-CSE-ConnectionGUID: KM/s3vX5Qd6l5flq2FXcVw==
X-CSE-MsgGUID: ZvPnrSJdS0CzA9N6etrHkg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,240,1758610800"; 
   d="scan'208";a="198266533"
Received: from linux-pnp-server-27.sh.intel.com ([10.239.147.41])
  by orviesa003.jf.intel.com with ESMTP; 01 Dec 2025 04:24:20 -0800
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
Subject: [PATCH v4] mm/memory hotplug/unplug: Optimize zone->contiguous update when changes pfn range
Date: Mon,  1 Dec 2025 21:22:16 +0800
Message-ID: <20251201132216.1636924-1-tianyou.li@intel.com>
X-Mailer: git-send-email 2.47.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0BD0C4000D
X-Rspamd-Server: rspam02
X-Stat-Signature: 39a8ffmja8agbgax43k8th9re8oyitjo
X-Rspam-User: 
X-HE-Tag: 1764591865-814750
X-HE-Meta: U2FsdGVkX1+aqqQi5N8131OAY4f4uQAt+c0Nf/p6NAlDpycbA2deTZuIEQnQZ/oS5IfWnlnQ+uBWhVahY1yCz2nPpoaLOzj9xAG55mold3DnqNIEpiF5FZQ4dCLn0ytLQbZyZU1tiNH4ryhE8lWuEoWaGatVrN0p6YfMBUF/BFaFBL/RI9KoT5Oy4AFt+aPqFGljiwn6S0eU+ocY+qKh34jDN/C7AzrXNPB7Z9kpyANqTzYxB/+cjTow0OubaTTP7VPmyjXCXmyQaEnJI8mMK4+HlW0/weZrDSArFyADJNN3/eZFOltHnXXpNYsN3qvpfi7yJPTpf41B7Z/qB5t7cBYZgyVBJ7gVwsRS+AbxIUa3mwxSAjf7Oz6/u3jfoDPrmgWL/OYK/c7qyd286Ma6LWkcRayLvTTV2jrb5mN/Nzy8NntyGzhuq7GioNEl3Fh/9bs3iJ13XnFvk4aqOu55zGJK7HZsPbCHh7uGuzyNCR1gfvhIyPKeHekcs4QKxmLiz+D/ojG1seCymjD3MpOhJgj1i3ldpj2h71M0JVfIoMFfB06xsr4nutgmN10eKhUYMKKrBnbN9TNl9GQX45e17DsiJT6R0lA7wlfhEiJHHNr8nKUxb1j91FBXMktu88TSW00EA4iLsOZ4kCtZe+PDM+XHPgd+i7G3nvgzdI/YxF7SLSQNO4xQjgKoTx58LyiuMqjQfXnKwL1DqfwO4j3ZDYdgyjeIyVbMhX7T09Bag9Xmf9Pco7ZBicZdT6zNhvAURzAYWNkP7Coxaqjx7pQs4POyHJoDaCr4AjYJlBsLvt9xGo6Dgh3tv7P/g1CpY9tunnAYZTOeQrOOEK7sw56pBAcdK+SS+eC6cuMuV5wS7wgIgrGSNeH3i3OYNt0y/SuYHItZn/4BskHaLFaOmk9WwcUjDIjiqLPScAo6SakXvh4i5D+GzIQpiML3UWTcE01k6oly52TQps53ZOh89ln
 PJ9diHjF
 mk9clYBCZ5zEvXJje8WzbXI2BoaApHJe0o/mJzWtBfKauLZoogkZaOY09aQFG/AErjDV+HvKeglRPWLDPv0OVgcvHItvU5+cIU0BEVaJsWH9BZlo0i69Xsr7Rckqz5JUnS9I3LfIzp6q8c7VuTc21XBuD7W1LdthO9Wnrn9whV1VpPANEBLLhNvCS/bJ/CwB97Gkid7XDDERE8AlbT50KqVEkbvi4iHL5MonpztWQdP8usHTbSxIoKz+di+jTIzf4OGxQ0BVMHsMk7jgV6M7WN+LTyA==
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
 mm/internal.h       |  8 ++++-
 mm/memory_hotplug.c | 79 ++++++++++++++++++++++++++++++++++++++++++---
 mm/mm_init.c        | 36 +++++++++++++--------
 3 files changed, 103 insertions(+), 20 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 1561fc2ff5b8..a94928520a55 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -730,7 +730,13 @@ static inline struct page *pageblock_pfn_to_page(unsigned long start_pfn,
 	return __pageblock_pfn_to_page(start_pfn, end_pfn, zone);
 }
 
-void set_zone_contiguous(struct zone *zone);
+enum zone_contiguous_state {
+	CONTIGUOUS_DEFINITELY_NOT = 0,
+	CONTIGUOUS_DEFINITELY = 1,
+	CONTIGUOUS_UNDETERMINED = 2,
+};
+
+void set_zone_contiguous(struct zone *zone, enum zone_contiguous_state state);
 bool pfn_range_intersects_zones(int nid, unsigned long start_pfn,
 			   unsigned long nr_pages);
 
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 0be83039c3b5..b74e558ce822 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -544,6 +544,32 @@ static void update_pgdat_span(struct pglist_data *pgdat)
 	pgdat->node_spanned_pages = node_end_pfn - node_start_pfn;
 }
 
+static enum zone_contiguous_state __meminit clear_zone_contiguous_for_shrinking(
+		struct zone *zone, unsigned long start_pfn, unsigned long nr_pages)
+{
+	const unsigned long end_pfn = start_pfn + nr_pages;
+	enum zone_contiguous_state result = CONTIGUOUS_UNDETERMINED;
+
+	/*
+	 * If the removed pfn range inside the original zone span, the contiguous
+	 * property is surely false.
+	 */
+	if (start_pfn > zone->zone_start_pfn && end_pfn < zone_end_pfn(zone))
+		result = CONTIGUOUS_DEFINITELY_NOT;
+
+	/*
+	 * If the removed pfn range is at the beginning or end of the
+	 * original zone span, the contiguous property is preserved when
+	 * the original zone is contiguous.
+	 */
+	else if (start_pfn == zone->zone_start_pfn || end_pfn == zone_end_pfn(zone))
+		result = zone->contiguous ?
+			CONTIGUOUS_DEFINITELY : CONTIGUOUS_UNDETERMINED;
+
+	clear_zone_contiguous(zone);
+	return result;
+}
+
 void remove_pfn_range_from_zone(struct zone *zone,
 				      unsigned long start_pfn,
 				      unsigned long nr_pages)
@@ -551,6 +577,7 @@ void remove_pfn_range_from_zone(struct zone *zone,
 	const unsigned long end_pfn = start_pfn + nr_pages;
 	struct pglist_data *pgdat = zone->zone_pgdat;
 	unsigned long pfn, cur_nr_pages;
+	enum zone_contiguous_state contiguous_state = CONTIGUOUS_UNDETERMINED;
 
 	/* Poison struct pages because they are now uninitialized again. */
 	for (pfn = start_pfn; pfn < end_pfn; pfn += cur_nr_pages) {
@@ -571,12 +598,13 @@ void remove_pfn_range_from_zone(struct zone *zone,
 	if (zone_is_zone_device(zone))
 		return;
 
-	clear_zone_contiguous(zone);
+	contiguous_state = clear_zone_contiguous_for_shrinking(
+				zone, start_pfn, nr_pages);
 
 	shrink_zone_span(zone, start_pfn, start_pfn + nr_pages);
 	update_pgdat_span(pgdat);
 
-	set_zone_contiguous(zone);
+	set_zone_contiguous(zone, contiguous_state);
 }
 
 /**
@@ -736,6 +764,47 @@ static inline void section_taint_zone_device(unsigned long pfn)
 }
 #endif
 
+static enum zone_contiguous_state __meminit clear_zone_contiguous_for_growing(
+		struct zone *zone, unsigned long start_pfn, unsigned long nr_pages)
+{
+	const unsigned long end_pfn = start_pfn + nr_pages;
+	enum zone_contiguous_state result = CONTIGUOUS_UNDETERMINED;
+
+	/*
+	 * Given the moved pfn range's contiguous property is always true,
+	 * under the conditional of empty zone, the contiguous property should
+	 * be true.
+	 */
+	if (zone_is_empty(zone))
+		result = CONTIGUOUS_DEFINITELY;
+
+	/*
+	 * If the moved pfn range does not intersect with the original zone span,
+	 * the contiguous property is surely false.
+	 */
+	else if (end_pfn < zone->zone_start_pfn || start_pfn > zone_end_pfn(zone))
+		result = CONTIGUOUS_DEFINITELY_NOT;
+
+	/*
+	 * If the moved pfn range is adjacent to the original zone span, given
+	 * the moved pfn range's contiguous property is always true, the zone's
+	 * contiguous property inherited from the original value.
+	 */
+	else if (end_pfn == zone->zone_start_pfn || start_pfn == zone_end_pfn(zone))
+		result = zone->contiguous ?
+			CONTIGUOUS_DEFINITELY : CONTIGUOUS_DEFINITELY_NOT;
+
+	/*
+	 * If the original zone's hole larger than the moved pages in the range,
+	 * the contiguous property is surely false.
+	 */
+	else if (nr_pages < (zone->spanned_pages - zone->present_pages))
+		result = CONTIGUOUS_DEFINITELY_NOT;
+
+	clear_zone_contiguous(zone);
+	return result;
+}
+
 /*
  * Associate the pfn range with the given zone, initializing the memmaps
  * and resizing the pgdat/zone data to span the added pages. After this
@@ -752,8 +821,8 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
 {
 	struct pglist_data *pgdat = zone->zone_pgdat;
 	int nid = pgdat->node_id;
-
-	clear_zone_contiguous(zone);
+	const enum zone_contiguous_state contiguous_state =
+		clear_zone_contiguous_for_growing(zone, start_pfn, nr_pages);
 
 	if (zone_is_empty(zone))
 		init_currently_empty_zone(zone, start_pfn, nr_pages);
@@ -783,7 +852,7 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
 			 MEMINIT_HOTPLUG, altmap, migratetype,
 			 isolate_pageblock);
 
-	set_zone_contiguous(zone);
+	set_zone_contiguous(zone, contiguous_state);
 }
 
 struct auto_movable_stats {
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 7712d887b696..06db3fcf7f95 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2263,26 +2263,34 @@ void __init init_cma_pageblock(struct page *page)
 }
 #endif
 
-void set_zone_contiguous(struct zone *zone)
+void set_zone_contiguous(struct zone *zone, enum zone_contiguous_state state)
 {
 	unsigned long block_start_pfn = zone->zone_start_pfn;
 	unsigned long block_end_pfn;
 
-	block_end_pfn = pageblock_end_pfn(block_start_pfn);
-	for (; block_start_pfn < zone_end_pfn(zone);
-			block_start_pfn = block_end_pfn,
-			 block_end_pfn += pageblock_nr_pages) {
+	if (state == CONTIGUOUS_DEFINITELY) {
+		zone->contiguous = true;
+		return;
+	} else if (state == CONTIGUOUS_DEFINITELY_NOT) {
+		// zone contiguous has already cleared as false, just return.
+		return;
+	} else if (state == CONTIGUOUS_UNDETERMINED) {
+		block_end_pfn = pageblock_end_pfn(block_start_pfn);
+		for (; block_start_pfn < zone_end_pfn(zone);
+				block_start_pfn = block_end_pfn,
+				block_end_pfn += pageblock_nr_pages) {
 
-		block_end_pfn = min(block_end_pfn, zone_end_pfn(zone));
+			block_end_pfn = min(block_end_pfn, zone_end_pfn(zone));
 
-		if (!__pageblock_pfn_to_page(block_start_pfn,
-					     block_end_pfn, zone))
-			return;
-		cond_resched();
-	}
+			if (!__pageblock_pfn_to_page(block_start_pfn,
+						block_end_pfn, zone))
+				return;
+			cond_resched();
+		}
 
-	/* We confirm that there is no hole */
-	zone->contiguous = true;
+		/* We confirm that there is no hole */
+		zone->contiguous = true;
+	}
 }
 
 /*
@@ -2348,7 +2356,7 @@ void __init page_alloc_init_late(void)
 		shuffle_free_memory(NODE_DATA(nid));
 
 	for_each_populated_zone(zone)
-		set_zone_contiguous(zone);
+		set_zone_contiguous(zone, CONTIGUOUS_UNDETERMINED);
 
 	/* Initialize page ext after all struct pages are initialized. */
 	if (deferred_struct_pages)
-- 
2.47.1


