Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BFDDE674B2
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 14:00:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84AA96B0088; Mon, 22 Dec 2025 09:00:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8085C6B008A; Mon, 22 Dec 2025 09:00:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 722036B008C; Mon, 22 Dec 2025 09:00:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 63F796B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 09:00:04 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ECCD01A01A1
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 14:00:03 +0000 (UTC)
X-FDA: 84247265886.01.2866BF5
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf30.hostedemail.com (Postfix) with ESMTP id AB4D38000B
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 14:00:01 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ndHihzld;
	spf=pass (imf30.hostedemail.com: domain of tianyou.li@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766412001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U3PyUhhP2s3T/vMs48xiZAMBlI44hu/ttK5bFtM+BnU=;
	b=NhJiI93Rg2Qi3//nkETVG/d5E6KogyeCHrSN0rbCH6gkMZUpDJnHbQti2XJcYSzWL+Xn1H
	d/MP7rN1Cjs27C+F6/BKP21bi9mvdpB4Ds1g477MduHOZDdX+IFZKu1iV4d1fKO6QwWTXS
	MAqgqvBjxI3CNZD1NcZOMF+1eGmnmno=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ndHihzld;
	spf=pass (imf30.hostedemail.com: domain of tianyou.li@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766412001; a=rsa-sha256;
	cv=none;
	b=wEdbwb066G7YbacQ5hSHVopky+bXTxS/2dNNOfYi4NCcQ6mSBGDUzGPOAL2YIx2S1NBLg5
	4I0Eg2/YODuNDTx4Yif+QK2rvw0OpOTtozR5gtMVjkXNRslLZ/55/THij70aJhf7AHMCvJ
	U0KQT641psyrr3xFAZYR3IJG6veDz08=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766412002; x=1797948002;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LHW8YUkwwN6wXd9yGcUC5UpprIWO5Zf0W58o5wEcQnk=;
  b=ndHihzldqMX/ENbCrsvxkxfgfH/beliWEKh1YGIjKOg4gtfnRXL89BmE
   Hdd5r6FyGJjFifEVD3s0OAVAELXnTbuX57h3UiMSfpDx6ZD/JE1Py9pmu
   rPD+3rsPbg4gBdXS1zyCUAT2ZbodR65rwmF7P8suLJxmz2xoCh7Qq4jJO
   Pa8ef0dFO7VDpY31Odlc0eJVEq+DaH8BLaUycV/zQ4Aj+5d90wJcX48TR
   Jf9Zi9Qfb+MtH4pMj4hDTFk/s5oIWfzOqrBg4uuleOUs9gXgfKS6QWlRw
   03i/URCTmABWhrWA9XZ+SyiK1OPXW4cvFxSmj1bfv57YOLnyhWJ8NcLwf
   Q==;
X-CSE-ConnectionGUID: ++nzoXv5QpeaL4NsUjiyBw==
X-CSE-MsgGUID: u6FVw0NlSbKJh1W5EAxrAQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11650"; a="68248546"
X-IronPort-AV: E=Sophos;i="6.21,168,1763452800"; 
   d="scan'208";a="68248546"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2025 06:00:01 -0800
X-CSE-ConnectionGUID: svxj+7fgTtqUONr8QoF5mw==
X-CSE-MsgGUID: mojjmZZmQTeRd7nWxlC3og==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,168,1763452800"; 
   d="scan'208";a="230189577"
Received: from linux-pnp-server-27.sh.intel.com ([10.239.147.41])
  by orviesa002.jf.intel.com with ESMTP; 22 Dec 2025 05:59:56 -0800
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
Subject: [PATCH v7 2/2] mm/memory hotplug/unplug: Optimize zone->contiguous update when changes pfn range
Date: Mon, 22 Dec 2025 22:58:07 +0800
Message-ID: <20251222145807.11351-3-tianyou.li@intel.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20251222145807.11351-1-tianyou.li@intel.com>
References: <20251222145807.11351-1-tianyou.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AB4D38000B
X-Stat-Signature: tjzznpz4ik3qcds655kp6uk4358tka1y
X-Rspam-User: 
X-HE-Tag: 1766412001-117152
X-HE-Meta: U2FsdGVkX18SGog17U+pI8VWNQRlLl+cy76A3FjCo3tO7+2VsyXcx4lqW7whGQFcvJYQU5TvWrn2lRJXPqbJ4leBLjKfDtb3rbhenZnPG/TwNa/aYqpSeY7qVM0T5ErO+myTaJrQAcyMYDMdkqJzghHzUvL0tHZCrOITZWJ4czz6tTKjBSp3L8fq+UEgcRHq9FAHoB2YNvfY1JCAC1zNZ2cBYlIoDDL6rGG0rKGK7DyEHd7QmyL49VNQvaT+tevsDrleikW5IRcXRWq6bovZDJYEor7/Fj9ruC8wJoRAWr/exc77fWFi23AEW9Q0YOPBgE0X8HGktqyYaXR7VRhbegjxdiu2ltMByXrTY36bFwR1KjiRfccM7zwggg+jTLeNmj5eJsjEZbuWmUMhmISSFMa0BDFc/A00h/tVRnwIifxizfFRgQ2CwSuVXb77AbznyCIxkBopPNwRMGZ9VMh39ZR9FLPc+E8Yva1I1GWaptzJtGmmQvRGMuQDKL3YUfjhpVfYVFmHE99bgGljGEdCoqDfSRQr66ZplmXgofM+GiPQNZlOhNBnUaCzzhF88l2/O/vDt967zHLNaKgxUyVFqvNfle+sRD5avfRiY4rrFN66SPhAG0sEMSI3gHu67c58/4j7jCscwc7is+XQo0Dqg0ePCrZOvZlxbPwqb0jBjYeehdaOfwU7dX8cC/kS8H1MHajgXCt1kTfhsx3hRVdU9oAEak6OM13aKdlb4au4elDyZWmAfYxZOHlv0K8WOvb//MJ107KBUdgyHlT26+11iGrodGI1gIdRFa5R8Umt6F9m+Bteli3cghFi7Z9NuUw3bDAbjaOmpvYEB0jiJH/j0dZfjv15dFdlwox/u1lApzQbsrZLCT0BirN0SNbKKfimd6cQCgmlwt0dwVnwaPJKFy6Yg41hYB8YnOD7wF7QxGvdfrqD+n/fZNRi47iuEskXHymZfPdsYM62lPt257c
 Dlw/eat2
 udNnMmg0y3QX9zwCnssyy0rtGlV9yMy2OoLNM0/3WZ9LyuoO4VE7+o8DoNZlxnqtzz+m6omhADr9LM3m+AytUS8HRAgD2VjSDyJuht/D9YRiO5J9xQl+K5NxmdG1uAU1Bedjzup4E8JyM7dtd+ULrX8rgApMmWXvZpLAiNd7NU1Kg4guOr/hcaYHCqsS2wMwOQvBML+yHdcVEVnQaRyTw3+HMFjJ8RAPv2YZSqGVdHg5XYAsMmVhX3WsqXnOdvrz7KZ9pntjI2mZht1M=
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
 mm/memory_hotplug.c | 75 +++++++++++++++++++++++++++++++++++++++++++--
 mm/mm_init.c        | 12 ++++++--
 3 files changed, 89 insertions(+), 6 deletions(-)

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
index ce6caf8674a5..f51293be12eb 100644
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
+								 nr_pages);
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
+	 * If the moved pfn range does not intersect with the original zone spa
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
+	 * If the original zone's hole larger than the moved pages in the range
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
@@ -1090,11 +1148,20 @@ int mhp_init_memmap_on_memory(unsigned long pfn, unsigned long nr_pages,
 {
 	unsigned long end_pfn = pfn + nr_pages;
 	int ret, i;
+	enum zone_contig_state new_contiguous_state = ZONE_CONTIG_NO;
 
 	ret = kasan_add_zero_shadow(__va(PFN_PHYS(pfn)), PFN_PHYS(nr_pages));
 	if (ret)
 		return ret;
 
+	/*
+	 * If the allocated memmap pages are not in a full section, keep the
+	 * contiguous state as ZONE_CONTIG_NO.
+	 */
+	if (IS_ALIGNED(end_pfn, PAGES_PER_SECTION))
+		new_contiguous_state = zone_contig_state_after_growing(zone,
+								pfn, nr_pages);
+
 	move_pfn_range_to_zone(zone, pfn, nr_pages, NULL, MIGRATE_UNMOVABLE,
 			       false);
 
@@ -1113,7 +1180,7 @@ int mhp_init_memmap_on_memory(unsigned long pfn, unsigned long nr_pages,
 	if (nr_pages >= PAGES_PER_SECTION)
 	        online_mem_sections(pfn, ALIGN_DOWN(end_pfn, PAGES_PER_SECTION));
 
-	set_zone_contiguous(zone);
+	set_zone_contiguous(zone, new_contiguous_state);
 	return ret;
 }
 
@@ -1153,6 +1220,7 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
 	const int nid = zone_to_nid(zone);
 	int need_zonelists_rebuild = 0;
 	unsigned long flags;
+	enum zone_contig_state new_contiguous_state = ZONE_CONTIG_NO;
 	int ret;
 
 	/*
@@ -1166,6 +1234,7 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
 			 !IS_ALIGNED(pfn + nr_pages, PAGES_PER_SECTION)))
 		return -EINVAL;
 
+	new_contiguous_state = zone_contig_state_after_growing(zone, pfn, nr_pages);
 
 	/* associate pfn range with the zone */
 	move_pfn_range_to_zone(zone, pfn, nr_pages, NULL, MIGRATE_MOVABLE,
@@ -1204,7 +1273,7 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
 	}
 
 	online_pages_range(pfn, nr_pages);
-	set_zone_contiguous(zone);
+	set_zone_contiguous(zone, new_contiguous_state);
 	adjust_present_page_count(pfn_to_page(pfn), group, nr_pages);
 
 	if (node_arg.nid >= 0)
diff --git a/mm/mm_init.c b/mm/mm_init.c
index fc2a6f1e518f..0c41f1004847 100644
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


