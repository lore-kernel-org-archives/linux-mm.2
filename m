Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80EDCD2ECF7
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 13:33:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D817D6B03FC; Tue, 20 Jan 2026 08:33:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2BB06B03FE; Tue, 20 Jan 2026 08:33:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C58216B03FF; Tue, 20 Jan 2026 08:33:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B2E326B03FC
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 08:33:51 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6E3F213B488
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 13:33:51 +0000 (UTC)
X-FDA: 84352435062.28.6CF1092
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4E7CB18000B
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 13:33:49 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JzZJpzOa;
	spf=pass (imf16.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768916029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j8fboblFD4Q//NU5QrCf0XTEFOlysrkKtH8Jrfdz/Mk=;
	b=yIZda9ftTejkLYJaeIOZqCt0K97kzX7itw5PmUvbXb9pJlETZorNSMUpMA8bfq87PDkNbn
	M6Kz/PPxRX1hSrghVuQOsyP9QA3PiRrNqk/3Gu87HNVWA9nNfIwqja6xJ2xZny30X8tfp+
	I5egaF1Rmk0d5R1klVVSyroOl+ofV7w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768916029; a=rsa-sha256;
	cv=none;
	b=zCsUPxQbn0fkoD2elw0KhCXdI8w0Wm/TcLnVxSsUNqIp3r6ZhVl3kvwvNW/1dQtMDldayt
	N2slRbIWK4sck3nVfwWPr/INgLGBfG2B4gtCe+NfWzRV9REsnoyJhOML6I7Iip3INF7mQg
	RvkrbUC9EVmiwRLxAMW+9IH8M9iFeDY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JzZJpzOa;
	spf=pass (imf16.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768916029; x=1800452029;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uRXJUMxk0Hb4jFSZhLv2yNQYjNQfhMU9CNfEjHKF7go=;
  b=JzZJpzOa7/wk4XfS285fvll/T0aw+AO9R1ey71KuuqVzThUJszR7ygXw
   9Yg4jQDhfLnpit/ETr7GERiwz57cE+13Q2ZUpqdEqNY8yfXxSfxErcjPq
   EkOtw148z9wnnNxLTXi84kHQ6zmjU2R6WCGR547fqgJ7BpDzcxWuIaZ4n
   odYw+qeVVGce72nT3ndHPbPsqKhzzpEynMuY/TTfcgbHcJkUgY88v5+zk
   J6VbyHKJN43TksB+NoiGTE0tbAlu3ddlg2U8d+5sSXQ4jauj3x2VnzKZu
   L9jItpWF6FGrw1tUYyNNWvzu00uDUJ1geuNwV5AwrNXST0B608bZoE/G3
   A==;
X-CSE-ConnectionGUID: kawbhcz2QU+ZOIcnwOwkBg==
X-CSE-MsgGUID: lA4BmUSaSFWmDBzkorMDTQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11676"; a="81494876"
X-IronPort-AV: E=Sophos;i="6.21,240,1763452800"; 
   d="scan'208";a="81494876"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 05:33:47 -0800
X-CSE-ConnectionGUID: HbLPm/C3QO+Cm3NSPQ6zHA==
X-CSE-MsgGUID: LcT4k1BQQbu08CJxGXonRg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,240,1763452800"; 
   d="scan'208";a="210272063"
Received: from linux-pnp-server-27.sh.intel.com ([10.239.147.41])
  by orviesa003.jf.intel.com with ESMTP; 20 Jan 2026 05:33:44 -0800
From: Tianyou Li <tianyou.li@intel.com>
To: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	Michal Hocko <mhocko@suse.com>
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
Subject: [PATCH v8 3/3] mm/memory hotplug/unplug: Optimize zone->contiguous update when changes pfn range
Date: Tue, 20 Jan 2026 22:33:46 +0800
Message-ID: <20260120143346.1427837-4-tianyou.li@intel.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20260120143346.1427837-1-tianyou.li@intel.com>
References: <20260120143346.1427837-1-tianyou.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4E7CB18000B
X-Rspam-User: 
X-Stat-Signature: xjw4b49wjkmhct5ckpzxo5gjwkz4bffs
X-HE-Tag: 1768916029-4370
X-HE-Meta: U2FsdGVkX18RqYdPuqSXSlS4OpSEnzztElInHYCpFoDd2Dr8TYjSVxz7LXzzo1mOOwN5SihWc5kXhI00seCAcvQ/RUc+aZHnLd/Rg4B85C70VqF24/mg+qO92KSaRPXS+w9GUbHDAHyW7uPqmOlNNLhCOryr5cGwF8eWN9PQdHn98REelu4RBUQ0RveBpGpR6cODXswByCtzVOd78NVM/mvWaYPchajlFnnt+akEAwur0BRyReh8pnveejWM6n4waAmORNKFGGijyW9CMwDk0Jw6Rn0+qeAeR0Yhqq7EojEgly5PpKWfVhvOFLOwImtj45Jl+B8E7LZch2KzBwEBZexm1M/NP29dS7d4SOXfYt/9L9QcbwcnYYoYcznEl3o+CMcnEO3i0azU+QtKsDA1x0iifhHbt75MffJhdci0hrXlwR2hVf136fkv1br4rlTz5Wrx0m4xuqYdbr3MXVVCahbo+W4oR9PR/1+mFHGL/PkbHqBRw0ViTctIKPchZMt7nkdl1Ogt6PpQrq/PDPkfAeIJjaGRKx3JlKZoimRS6nnQ0ieGk4ZabZ4XM6yoB9ucPPHZxdZlXsJ7J3+i1Exe80gBnCTlr3+12rAa1nfaAlGYLzz2sAAOMrasu0JcSwsZ5ERfSAZ2Y1n910Y6xdmvKdfyW62ZgMZ++BdUupq8SyhK2awWV1i0JxTlt0TNiKlK9fMLvH5NrusRpaxdEcAVRcIZXed0BPLOhyILKMkrTy9bd+9iTAw0dFXHjgnkfYw4V3A2AgBSm0vumW/xe4HTThzmShU/7Mibs0pNenVWhRLwJUkoVujVQsAKkdssrNXK6acK0/2zKPcEOUsdL8bWjKg3kD48zrQjtIsmZphlrHUaj0J4Z49qxTOPv5NL2/oEpwsJGevDkFWA/8axd59BOGYapnTzPnD/7vBOIy+jEEJQV83HrTICqet88otYSKYxN8SydAEZ66Y=
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
 mm/memory_hotplug.c | 86 +++++++++++++++++++++++++++++++++++++--------
 mm/mm_init.c        | 15 ++++++--
 3 files changed, 92 insertions(+), 17 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index e430da900430..828aed5c2fef 100644
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
index 8793a83702c5..7b8feaca0d63 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -544,6 +544,25 @@ static void update_pgdat_span(struct pglist_data *pgdat)
 	pgdat->node_spanned_pages = node_end_pfn - node_start_pfn;
 }
 
+static enum zone_contig_state zone_contig_state_after_shrinking(struct zone *zone,
+				unsigned long start_pfn, unsigned long nr_pages)
+{
+	const unsigned long end_pfn = start_pfn + nr_pages;
+
+	/*
+	 * If we cut a hole into the zone span, then the zone is
+	 * certainly not contiguous.
+	 */
+	if (start_pfn > zone->zone_start_pfn && end_pfn < zone_end_pfn(zone))
+		return ZONE_CONTIG_NO;
+
+	/* Removing from the start/end of the zone will not change anything. */
+	if (start_pfn == zone->zone_start_pfn || end_pfn == zone_end_pfn(zone))
+		return zone->contiguous ? ZONE_CONTIG_YES : ZONE_CONTIG_MAYBE;
+
+	return ZONE_CONTIG_MAYBE;
+}
+
 void remove_pfn_range_from_zone(struct zone *zone,
 				      unsigned long start_pfn,
 				      unsigned long nr_pages)
@@ -551,6 +570,7 @@ void remove_pfn_range_from_zone(struct zone *zone,
 	const unsigned long end_pfn = start_pfn + nr_pages;
 	struct pglist_data *pgdat = zone->zone_pgdat;
 	unsigned long pfn, cur_nr_pages;
+	enum zone_contig_state new_contiguous_state;
 
 	/* Poison struct pages because they are now uninitialized again. */
 	for (pfn = start_pfn; pfn < end_pfn; pfn += cur_nr_pages) {
@@ -571,12 +591,14 @@ void remove_pfn_range_from_zone(struct zone *zone,
 	if (zone_is_zone_device(zone))
 		return;
 
+	new_contiguous_state = zone_contig_state_after_shrinking(zone, start_pfn,
+								 nr_pages);
 	clear_zone_contiguous(zone);
 
 	shrink_zone_span(zone, start_pfn, start_pfn + nr_pages);
 	update_pgdat_span(pgdat);
 
-	set_zone_contiguous(zone);
+	set_zone_contiguous(zone, new_contiguous_state);
 }
 
 /**
@@ -736,6 +758,32 @@ static inline void section_taint_zone_device(unsigned long pfn)
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
+	 * If the moved pfn range does not intersect with the original zone span
+	 * the zone is surely not contiguous.
+	 */
+	if (end_pfn < zone->zone_start_pfn || start_pfn > zone_end_pfn(zone))
+		return ZONE_CONTIG_NO;
+
+	/* Adding to the start/end of the zone will not change anything. */
+	if (end_pfn == zone->zone_start_pfn || start_pfn == zone_end_pfn(zone))
+		return zone->contiguous ? ZONE_CONTIG_YES : ZONE_CONTIG_NO;
+
+	/* If we cannot fill the hole, the zone stays not contiguous. */
+	if (nr_pages < (zone->spanned_pages - zone->present_pages))
+		return ZONE_CONTIG_NO;
+
+	return ZONE_CONTIG_MAYBE;
+}
+
 /*
  * Associate the pfn range with the given zone, initializing the memmaps
  * and resizing the pgdat/zone data to span the added pages. After this
@@ -1165,7 +1213,6 @@ static int online_pages(unsigned long pfn, unsigned long nr_pages,
 			 !IS_ALIGNED(pfn + nr_pages, PAGES_PER_SECTION)))
 		return -EINVAL;
 
-
 	/* associate pfn range with the zone */
 	move_pfn_range_to_zone(zone, pfn, nr_pages, NULL, MIGRATE_MOVABLE,
 			       true);
@@ -1203,13 +1250,6 @@ static int online_pages(unsigned long pfn, unsigned long nr_pages,
 	}
 
 	online_pages_range(pfn, nr_pages);
-
-	/*
-	 * Now that the ranges are indicated as online, check whether the whole
-	 * zone is contiguous.
-	 */
-	set_zone_contiguous(zone);
-
 	adjust_present_page_count(pfn_to_page(pfn), group, nr_pages);
 
 	if (node_arg.nid >= 0)
@@ -1254,16 +1294,25 @@ static int online_pages(unsigned long pfn, unsigned long nr_pages,
 	return ret;
 }
 
-int online_memory_block_pages(unsigned long start_pfn,
-		unsigned long nr_pages, unsigned long nr_vmemmap_pages,
-		struct zone *zone, struct memory_group *group)
+int online_memory_block_pages(unsigned long start_pfn, unsigned long nr_pages,
+			unsigned long nr_vmemmap_pages, struct zone *zone,
+			struct memory_group *group)
 {
+	const bool contiguous = zone->contiguous;
+	enum zone_contig_state new_contiguous_state;
 	int ret;
 
+	/*
+	 * Calculate the new zone contig state before move_pfn_range_to_zone()
+	 * sets the zone temporarily to non-contiguous.
+	 */
+	new_contiguous_state = zone_contig_state_after_growing(zone, start_pfn,
+							       nr_pages);
+
 	if (nr_vmemmap_pages) {
 		ret = mhp_init_memmap_on_memory(start_pfn, nr_vmemmap_pages, zone);
 		if (ret)
-			return ret;
+			goto restore_zone_contig;
 	}
 
 	ret = online_pages(start_pfn + nr_vmemmap_pages,
@@ -1271,7 +1320,7 @@ int online_memory_block_pages(unsigned long start_pfn,
 	if (ret) {
 		if (nr_vmemmap_pages)
 			mhp_deinit_memmap_on_memory(start_pfn, nr_vmemmap_pages);
-		return ret;
+		goto restore_zone_contig;
 	}
 
 	/*
@@ -1282,6 +1331,15 @@ int online_memory_block_pages(unsigned long start_pfn,
 		adjust_present_page_count(pfn_to_page(start_pfn), group,
 					  nr_vmemmap_pages);
 
+	/*
+	 * Now that the ranges are indicated as online, check whether the whole
+	 * zone is contiguous.
+	 */
+	set_zone_contiguous(zone, new_contiguous_state);
+	return 0;
+
+restore_zone_contig:
+	zone->contiguous = contiguous;
 	return ret;
 }
 
diff --git a/mm/mm_init.c b/mm/mm_init.c
index fc2a6f1e518f..5ed3fbd5c643 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2263,11 +2263,22 @@ void __init init_cma_pageblock(struct page *page)
 }
 #endif
 
-void set_zone_contiguous(struct zone *zone)
+void set_zone_contiguous(struct zone *zone, enum zone_contig_state state)
 {
 	unsigned long block_start_pfn = zone->zone_start_pfn;
 	unsigned long block_end_pfn;
 
+	/* We expect an earlier call to clear_zone_contiguous(). */
+	VM_WARN_ON_ONCE(zone->contiguous);
+
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
@@ -2348,7 +2359,7 @@ void __init page_alloc_init_late(void)
 		shuffle_free_memory(NODE_DATA(nid));
 
 	for_each_populated_zone(zone)
-		set_zone_contiguous(zone);
+		set_zone_contiguous(zone, ZONE_CONTIG_MAYBE);
 
 	/* Initialize page ext after all struct pages are initialized. */
 	if (deferred_struct_pages)
-- 
2.47.1


