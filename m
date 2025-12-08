Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2BA5D3B7F3
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 14:28:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48A186B0007; Mon,  8 Dec 2025 09:28:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43A4C6B0008; Mon,  8 Dec 2025 09:28:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3293B6B000A; Mon,  8 Dec 2025 09:28:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 235A26B0007
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 09:28:21 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BC5EE1DF826
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 14:28:20 +0000 (UTC)
X-FDA: 84196533960.24.B1065D3
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf28.hostedemail.com (Postfix) with ESMTP id 985E5C0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 14:28:18 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PzI2NYWF;
	spf=pass (imf28.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765204098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pTHU0Tz21TM6mBkxKH7RzP1yWemehITCx7jb5mCXLp8=;
	b=Flah1aYHGvVxVaX9cfgyrNPqnVHm1AEvCH9jlTl5elFmYlNRRAdEds06NztoeVAZKr5HtO
	HwYFuD4YcNSePKZh8PoqvOLBS2ZlNeDK/qFU2JeLC3v1Xt7ekSy7o0FU/Fw0bBtVN1wUh3
	j2/JMhrKd83lm8jwyZ1oIfDVqyvTZms=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765204098; a=rsa-sha256;
	cv=none;
	b=3T33mxNUuwetNREeFrIOKhKT+O0/kpcUAYpLBJL6uXTY6guAJX5cp4saUP2E861sI81hTQ
	ZmfiigbaoKF8BMF58QG0Xh2DkT/6gRWwveDa8UplR4It1ub8BPXdIrFSqdgTgBSoBfaWJC
	HkoXMvS+0Fwm1XuVZwY6YFnwvA+LdG0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PzI2NYWF;
	spf=pass (imf28.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765204098; x=1796740098;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XJmAwSOU2MqY+urUHpB49mvIx2R6KeVN0viI7yYZUoA=;
  b=PzI2NYWFxVF9gwz31F9Wgd/0ej05GIz8qITvBKOmiQhYZO09NMlXQImr
   ajc5h3bInVg3kvErOqpDHDFYvtn4x5iZd/DXF6Xz6a/bgUej0OVA9Mhft
   OPHnDpeziL4L/hMlc4BlXIcSIB6hQvJkIg8y/pEmXgGnvbY9/BYvzA5WX
   Wbz7uXg5M8TH7iFYXGoeNYKHAbur3fx6JTFb1sZYz0hEv7LEbAlftV6Mz
   ufeviTyyh3D2TLkyn7Fbsm/r8urmq61uFGt8sw4W9ptD27j1jroZsvf+7
   GgdJaKHweGpUKHioBO44tvyI1r4LovyouBN8nmErYm4gkh9TBZHcTNxGX
   A==;
X-CSE-ConnectionGUID: 0z1NrLSaQn2TqpJAIvM5fQ==
X-CSE-MsgGUID: NtDxKb0QRb+z4aGZxmbOsA==
X-IronPort-AV: E=McAfee;i="6800,10657,11636"; a="67181531"
X-IronPort-AV: E=Sophos;i="6.20,258,1758610800"; 
   d="scan'208";a="67181531"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 06:28:17 -0800
X-CSE-ConnectionGUID: LUkGjrPCQeGifNSznEoNVg==
X-CSE-MsgGUID: CYTOP1mRQy2tL9ErDT1GyQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,258,1758610800"; 
   d="scan'208";a="233317803"
Received: from linux-pnp-server-27.sh.intel.com ([10.239.147.41])
  by orviesa001.jf.intel.com with ESMTP; 08 Dec 2025 06:28:14 -0800
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
Subject: [PATCH v5 1/2] mm/memory hotplug/unplug: Optimize zone->contiguous update when changes pfn range
Date: Mon,  8 Dec 2025 23:25:43 +0800
Message-ID: <20251208152544.1150732-2-tianyou.li@intel.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20251208152544.1150732-1-tianyou.li@intel.com>
References: <20251208152544.1150732-1-tianyou.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 985E5C0005
X-Stat-Signature: aj1a7kh3ygfp6ihujm3y69oooj3pqzkj
X-Rspam-User: 
X-HE-Tag: 1765204098-457465
X-HE-Meta: U2FsdGVkX18C0VzUfCpdgTMcarO1XKYypYvmS9tQFhcjzOO5dGsf9CAZvLU15jkFa/5XYnL8lGgbWsUGRsUzqU90VF82eRSCByE9SqxWOHTpUK+wzLaQj5KbB9SBAuL+KLEW7N9y2+Ks5QJgiol5bBSgpls6XcnBzCNUlB0VbHh5f0dnqxMowgNv3a0VRxqX7TyMPEhaj/W+dYmKfSgOniavKEEN+38hUY+ZFcv0uNzxs58xi9YpIfyVxiOnK0Boq+dmnplY8SuwEUrhBayvcbKYF6euT9JW7znZy6IT9nO8/KSXw9HDMyIFi67JM2jBV7P3Y1T1HaV5swwGncpGo47MoProN4jWlIgLVWWiWUGyRrD27/FhELSMhUOtFiGlT2vgNYQSlUsuMpB5S/lxfASEXPkuVKl7xoeiGPMpFMd33Bv38wA7sF9tu33cvL38dqjWn8p8jG9eyP/qZO6sV/X/2kZ+8WOkROE+Qvat/4GtZj4iiLFvL/FnnutExexMWQ7kt8Srvb+TnOk8qagQ/q2rWZC0HIDp9a5m+WegSK3rJIdRksxfAUFWW9HEWKyj6CerBtANg06FtFYxOafFdngsWQWNmHM3VVvLzPCOW2zq+hXB1dsz5mpRRcNe0ZY02KrgRXw3wOz2itMph2mOBpp28bjCZ1xv7/LK8g3bpXTMEo/60jmdrAED5TPD+S5HEiaTnEk9VR/bAgblUN//HtZTbAUFOFF9dxaSypNBh2cVyOXcataXceF4hdyldBUuh8BHUkhkhMGD79iIYMRy37fozFFp5Yzu9Ea+69a4aybZLKXRb1M3Ead3j4h96SST+smMNrQaHrAwqqrHb9XbNIMFORKxzXbno9rCz27RR6m9CjZaqStJO23ppwyYXcJnAN1/+hqZmL3sOzEDHxjc35lepesLcrNr6EY53lxntsvwQtAl4H1W4lhAmSQj5ksz6Fo3LhdY+LQjjulDNEL
 3E3Hhzrp
 OzKt0opOvnas1gh6OMECkBkK9u8FkkgMbUy70hn4asAYPcAKjZd30vUL55xIEmq1CkkIngptFo6DECuUxnnCM9rMEdJ6kQbk8GJD/McaW1kW9iAmcvoWUQ01AUEWTu3MJjsjEphrUeXjfIY721eL7tQdXFSFM18lqy9McP3xdDCO8uXsii3X4DrGv/xgUiIVWq08NDji7t0BjOLwm0gIVMcENuG8xJ7RE7JV3MdL/qvpxGpnRfuwfalZmT8Yd502ufZtVVKBl+J8yeTosj187bPVl+A==
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
 mm/memory_hotplug.c | 64 ++++++++++++++++++++++++++++++++++++++++++---
 mm/mm_init.c        | 13 +++++++--
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
index 0be83039c3b5..d711f6e2c87f 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -544,6 +544,28 @@ static void update_pgdat_span(struct pglist_data *pgdat)
 	pgdat->node_spanned_pages = node_end_pfn - node_start_pfn;
 }
 
+static enum zone_contig_state __meminit zone_contig_state_after_shrinking(
+		struct zone *zone, unsigned long start_pfn, unsigned long nr_pages)
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
+	enum zone_contig_state contiguous_state = ZONE_CONTIG_MAYBE;
 
 	/* Poison struct pages because they are now uninitialized again. */
 	for (pfn = start_pfn; pfn < end_pfn; pfn += cur_nr_pages) {
@@ -571,12 +594,13 @@ void remove_pfn_range_from_zone(struct zone *zone,
 	if (zone_is_zone_device(zone))
 		return;
 
+	contiguous_state = zone_contig_state_after_shrinking(zone, start_pfn, nr_pages);
 	clear_zone_contiguous(zone);
 
 	shrink_zone_span(zone, start_pfn, start_pfn + nr_pages);
 	update_pgdat_span(pgdat);
 
-	set_zone_contiguous(zone);
+	set_zone_contiguous(zone, contiguous_state);
 }
 
 /**
@@ -736,6 +760,39 @@ static inline void section_taint_zone_device(unsigned long pfn)
 }
 #endif
 
+static enum zone_contig_state __meminit zone_contig_state_after_growing(
+		struct zone *zone, unsigned long start_pfn, unsigned long nr_pages)
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
@@ -752,7 +809,8 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
 {
 	struct pglist_data *pgdat = zone->zone_pgdat;
 	int nid = pgdat->node_id;
-
+	const enum zone_contig_state contiguous_state =
+		zone_contig_state_after_growing(zone, start_pfn, nr_pages);
 	clear_zone_contiguous(zone);
 
 	if (zone_is_empty(zone))
@@ -783,7 +841,7 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
 			 MEMINIT_HOTPLUG, altmap, migratetype,
 			 isolate_pageblock);
 
-	set_zone_contiguous(zone);
+	set_zone_contiguous(zone, contiguous_state);
 }
 
 struct auto_movable_stats {
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 7712d887b696..e296bd9fac9e 100644
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
@@ -2283,6 +2291,7 @@ void set_zone_contiguous(struct zone *zone)
 
 	/* We confirm that there is no hole */
 	zone->contiguous = true;
+
 }
 
 /*
@@ -2348,7 +2357,7 @@ void __init page_alloc_init_late(void)
 		shuffle_free_memory(NODE_DATA(nid));
 
 	for_each_populated_zone(zone)
-		set_zone_contiguous(zone);
+		set_zone_contiguous(zone, ZONE_CONTIG_MAYBE);
 
 	/* Initialize page ext after all struct pages are initialized. */
 	if (deferred_struct_pages)
-- 
2.47.1


