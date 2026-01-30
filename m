Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51CB7E6BF1F
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 15:38:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACCE76B0089; Fri, 30 Jan 2026 10:38:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A776D6B008A; Fri, 30 Jan 2026 10:38:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 979E16B008C; Fri, 30 Jan 2026 10:38:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 85F6D6B0089
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 10:38:16 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2A4E11B1957
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 15:38:16 +0000 (UTC)
X-FDA: 84389036592.25.974E757
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf24.hostedemail.com (Postfix) with ESMTP id F29BD18000D
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 15:38:13 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=L3dxvdLn;
	spf=pass (imf24.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769787494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fwjPz5VCYcyvLIB0hJ07TQoeqEE9mXDb+lcKi9b8bb4=;
	b=x6oBGakPeHQXW4mHGGFsNFIgfGNNgF6Qipt4MYFxniRWwGTCqAq0nwxhTV+QzJmHyyZQa7
	Rv77ZmfYgjaVD1g8xMND9nazmQzYZCH8+/HOJAreKxj4+hFsXDzVOUNMkCwKACbRCI/Odq
	Gs76GoEhqA9ajCs2lWzIZ2JavYi9PDA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=L3dxvdLn;
	spf=pass (imf24.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769787494; a=rsa-sha256;
	cv=none;
	b=yt9WEEfhz/dbmCGCNWj0Annx4Vc1em7JM/uZKsaqwwkwX0QhMsZowjEvoIjUudS4dG74Cw
	+NA3bElehYuvuEbR/bThcfnVebVg136KP74QPwtC/fjtET39Yc7/fcun+fpCi0lT1tePHn
	+Pe8dU3lGWIqVJCn4f+koj1iq1qvSwk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769787494; x=1801323494;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KC4ClZUEUyHZvFs/yAflZy81KaZYjP/nXRU7sx4MPl8=;
  b=L3dxvdLnn+XkZ+pGW1ZTt0Fo08CViITjyftw8QHgx9Sm/yodW1/IvLKo
   HEgTpO+vlcAaFE0aHJiqN9QpTVtLvvVJnYZ72IJOgffKWH7j2Ugm2HowC
   aW+mQx/rJomEJ3R1opowEfFuIlK1Sbdu5+Uf2zRgGbCh7GdjMouljWXhF
   JHmUj/Yvvx+GpPc8/T6xNBFgJN91NY+S0G0EzPNvh70I9OHEv/3LNYQ4W
   H1noskA1Tlk2dn6KFsPDDnXn6LJ/MY1f9nGagcu1pyi26KQR+qI+p5r/1
   R+cwuIT13gj8Sw7is3JmdfKfwBW0BY/BxTCJ4CGn+BFntT92ObAyGZ+fr
   g==;
X-CSE-ConnectionGUID: rm1+ON/uTgCGFaUvQMRKyQ==
X-CSE-MsgGUID: znRoGrRXRs+eqmKm/KrC9Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11686"; a="71124799"
X-IronPort-AV: E=Sophos;i="6.21,263,1763452800"; 
   d="scan'208";a="71124799"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2026 07:38:12 -0800
X-CSE-ConnectionGUID: lZkSF11VTSCRrsB2deS0Tg==
X-CSE-MsgGUID: r+uawfEzT7KZA9rvNVBHvQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,263,1763452800"; 
   d="scan'208";a="208989163"
Received: from linux-pnp-server-27.sh.intel.com ([10.239.147.41])
  by orviesa007.jf.intel.com with ESMTP; 30 Jan 2026 07:38:09 -0800
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
Subject: [PATCH v9 2/2] mm/memory hotplug/unplug: Optimize zone->contiguous update when changes pfn range
Date: Sat, 31 Jan 2026 00:37:56 +0800
Message-ID: <20260130163756.2674225-3-tianyou.li@intel.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20260130163756.2674225-1-tianyou.li@intel.com>
References: <20260130163756.2674225-1-tianyou.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F29BD18000D
X-Stat-Signature: pizw65ug1zchkwbtu6bqg8zndbenyk3o
X-Rspam-User: 
X-HE-Tag: 1769787493-695802
X-HE-Meta: U2FsdGVkX19A4GLfYEDvlj9h6JG/NDHaNZgMHyL695aexl/slGtMK1DD3I76zacjQhdUFcnCle051PhlysSSeb/GY7PcvAuc5jRWi2frv1wPU9rUjan5JUbHjnQbwH9G8SU0QCsQoAEJ0QEIo/pM9k1y/UG0ni8Y155cMbUtZ19m3tJPQyDmxyzd1Xsdl5NwG0C3nZAIchvnNYKYglwBw22Cxj9BTwPKZcxNmka2245Eytaxeapqm35LQmwYbSpK3jOBtVph6AomFpQp2+7B06LAYG57oA10H87ZFeUdg9wc7AeTkcgYL+Uf0pYxBNKfihoeNxFzWzmPW1d0RxFgpCvdtUjryfDspiKNvCNf17vc9i5jED/G5yUnRlygYxtxiXtyv/etSqZJ8VGwjWQn85Urk+2cLSljLzjEYJWBWsTqMHRaktMulN7ONfp3n1ccfQ6CZVRH3j0u/AuQr3pwdwLb8At2dPoCvA2TtRjU6ul0xxpHBaUF/yw40NQBIilvapBGl4rjTwLqd8In6jf8TM/UO6ph/Qt/oigzefbOj5OVagt/8oFqwcmcLzBvoMbkkWCntlHyFkrSGX/o5D35r4D6cbYdG4vDFdmW1/6KICv/2sYeHyL7ebTTSvu8xZNsP2evBbmWmjoghKknwu8800mnqJTw9bgKHfrXeNacmnONrBiQGAqKpGP/rjf4OLSfbbdSN/xw03yAxc/4ru4BiQOcpJV6mM4Kwfx/jshpQxfJPB3RS8lhAbnj73FEnqQ7tMFKy5OCI0lyNVx6lCDbeI3Ot4ac+PAJnwoTMlpaKM5cYpYVEWkWdXZt6X6/iY2t7MFQXH/rTwU9qcEbrJ74EBRWqaGeIPKhpS1pbu9PLVT141wNq4OkiZ7exFxIZljVEYoguHZ/m11yThJYBe07onPj0NYO5OXm3ZJN2yHwuaQF2Evu8Lh30MFJBgo3fO4LLe0vsJC+2OFCl3+Q8Kz
 NlwrHs05
 dvVKlncPlJhhiUtVKyIzYv2nVoxdVcZIy2uVrloUNmvFvrIorRvyREAK3aCwGcI2skWkJ6oLq5bwv9fAGsTQNFXS73rOwcxfeKoKebL+KzWPt/NjZ8zoZ/306F93SyhTAGrXhckitRNfiwGDUOWGaObHKLscsacPGTLGq50LnoGTb+xCugc4ccO1QF2WIQRb0yGhDJn6JR0quEX/GpEoAcEBZWIK4Swi8030rKRjF064a9Lx80CFGwVikNfXLl+5olC7fZmE3LAxeR9tETVeL29Pkdw==
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
 mm/memory_hotplug.c | 80 ++++++++++++++++++++++++++++++++++++++-------
 mm/mm_init.c        | 15 +++++++--
 3 files changed, 89 insertions(+), 14 deletions(-)

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
index 62d6bc8ea2dd..e7a97c9c35be 100644
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
@@ -1258,12 +1298,21 @@ static int online_memory_block_pages(unsigned long start_pfn, unsigned long nr_p
 			unsigned long nr_vmemmap_pages, struct zone *zone,
 			struct memory_group *group)
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
@@ -1271,7 +1320,7 @@ static int online_memory_block_pages(unsigned long start_pfn, unsigned long nr_p
 	if (ret) {
 		if (nr_vmemmap_pages)
 			mhp_deinit_memmap_on_memory(start_pfn, nr_vmemmap_pages);
-		return ret;
+		goto restore_zone_contig;
 	}
 
 	/*
@@ -1282,6 +1331,15 @@ static int online_memory_block_pages(unsigned long start_pfn, unsigned long nr_p
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


