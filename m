Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAEC7CCD19A
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 02:32:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21B408E0039; Sun, 16 Nov 2025 21:32:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F3108E0002; Sun, 16 Nov 2025 21:32:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 130B98E0039; Sun, 16 Nov 2025 21:32:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F08098E0002
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 21:32:55 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8EB08C0B2D
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 02:32:55 +0000 (UTC)
X-FDA: 84118526310.25.4078927
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf02.hostedemail.com (Postfix) with ESMTP id 74C8D8001B
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 02:32:53 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Yn6rJ7z9;
	spf=pass (imf02.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763346773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=RiJjJz4HWZ7ftecVTy/VtCLUkhIaRZOfJW4JEH0WblU=;
	b=X1easMrolU+MGxlJKbSiPGbPiWneFOjlOF3x1KxjiJQm8LFyS5fYsv5dj42bVSTZguWGBW
	oJzVlXH4gB2aiY+vRD57WbYoJynwmcISIbklCabL+lu9q6Z4kMUKlJQqrX0TUYPZ5pc4Jf
	cCXDYOsONfW69fQJkOaLlrvfFgapG8A=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Yn6rJ7z9;
	spf=pass (imf02.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763346773; a=rsa-sha256;
	cv=none;
	b=ZsojQt6GUKbcf+QDbi8VeGkw1dyscWLrRaDPVrKivw1irHwRiX1QIEoi0qHr8kjjSUP+xu
	MkCdN/7C2N7Z4hGDxTd3P7Yac8j6mT3RPJ7eiGkd7cLfIQczfcnPl7tHS83doVkXr8LkE1
	2O3IE+mGwdUCrU29CJ0Gdw8OgnUFnbw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763346773; x=1794882773;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Z4YEi9qbtWiwRlqs9qbYFwWfrbJZ6vVZMpfrCH6e9DI=;
  b=Yn6rJ7z9a0eR/k/LCFcn5li6X6I613lRCfaL4RFpz2IzfBspRCL+sjSj
   g/SpHoh5pSV3mE+Rub9j/xtOq8miEFy8BfrkNGTrdfIhydKdP33GHVW88
   xgWCzWPWvx+tJVrpWUvprDTUPUPCAKvEdfflzpU39868SWcNRg5nt6Wik
   ZohQqxS5l1bC9kIYUyIkhC3771eKubyf81XHBFnFWYwq9p4SSoHOL0uWF
   lO2WLk3AJWxZPHJnhQtod2S+0lq8MrXrwjQcWYn+mnzANMqgURmhBgr1P
   yyAbObITAbuT/y5H2IYeFIr0L/BCNbIvx93B7VmTpughm3lB1HaG1cF4w
   w==;
X-CSE-ConnectionGUID: iuKBw3CTSM2ns1dz9CDMfg==
X-CSE-MsgGUID: 6uGjC3A1Q+GChoH2lL0JVg==
X-IronPort-AV: E=McAfee;i="6800,10657,11615"; a="65244439"
X-IronPort-AV: E=Sophos;i="6.19,310,1754982000"; 
   d="scan'208";a="65244439"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2025 18:32:52 -0800
X-CSE-ConnectionGUID: /IYMZ3NgS/G3f4sulk4UCw==
X-CSE-MsgGUID: 3SMwPYNWS6yAGSCWkBCWfg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,310,1754982000"; 
   d="scan'208";a="220965541"
Received: from linux-pnp-server-27.sh.intel.com ([10.239.147.41])
  by orviesa002.jf.intel.com with ESMTP; 16 Nov 2025 18:32:49 -0800
From: Tianyou Li <tianyou.li@intel.com>
To: David Hildenbrand <david@redhat.com>,
	Oscar Salvador <osalvador@suse.de>
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
Subject: [PATCH] mm/memory hotplug/unplug: Optimize zone->contiguous update when move pfn range
Date: Mon, 17 Nov 2025 11:30:52 +0800
Message-ID: <20251117033052.371890-1-tianyou.li@intel.com>
X-Mailer: git-send-email 2.47.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 74C8D8001B
X-Stat-Signature: f319bgaseg3z48s7ws19rmyorjrp8ocx
X-Rspam-User: 
X-HE-Tag: 1763346773-642213
X-HE-Meta: U2FsdGVkX1+jD/OqNiaodPoX5uJlzThlGGKVr1kiKFOy3ULuYRqPZUbaekMGm+zwY5oasb2BqpiLm05ZkLr+4P1//2/dzapflb7g95hDapuzT2z3iXgwwUP5pLfjrFBwbSl/0UwAdMPCi3059eb8yaPDxv2u6lRmRgak0zxZzWJrZK7VL3vESLtRnt0C2EKgKsdNXALzH86UO1wBYBEwVbLJ3Qg/uOi8Qj6EJbjp86p7K2y+wr/+ZcCBvL4J1ZDH+1vRPP84B7WxJlcR4CynqY2IkmmaYmtrtKOOZeRXjoKmjN6BbJMYv15eUXbZIpMXQBIqO70HOp9SSK29Z0Yj+8TNesZ3ZX1p1DMMwpuuZAoyb0OFbA5TbTzilS2Vq0PTfcWWwMVGatpOzYSlajDt6WqO6EbNwbuXYpL5K1U/xqfyp9/8j9nzyfM97orgTEwL7Le2u7gJ89o5nvj9KSNVYQ+C9cE8fXHVee07UukCUPTyTHrUQ/DzaYuZtSNZCbNrvephf4rScxxMpbXBwikrnxphGT/e3tvnqoJlMYMBrF3cW+s+yiVvaSBrXpMR8DhUQHc1Rc2/nNC41toFYu4nmSVGGwD7UMwq1pMzK9pxQzMMx5YV5nE1/SKbsG58RyIjXmiaxjRMl0cRysUiHmo1C7Sx5txTP2wpfTQ42DzY//fRSJAIDwCAgPpX6nXiR3pueKcjMuVtmg6c+xXrRwcFXHdm6kJqlQq7E1gQ77LsgwWZlIadkxdYkhBsk196ULYogo4suiJ5zOWGa7IMP6qfUzfOe0n4lo0lSK2Vvi1Y3+6b/8zdON+HlVsfbS6ZOC3Qdq1prnUELNPwu8ish6Y8YPxoe7zoA064h0KAHgRSk80Vi3Tl9OvMu7aJAzmsyuD2M5st6/n/gQzwgvEl2hJQ4N/o33OGTqqHvwMca9lHrw0uOKFBUpLyWGTazTzSunmGSuiCGvbAjsydmSTWIrS
 lj0kwRcd
 hezFlvbohMhOnOG0HH5NYlklCPG2p3TrCkdBZYCc63n6sTu91ZP9rurCqHXGr96AlQ2hvpxRf21t1z4STKiCh+McgSdoUvprYQNXasPJI3pi/o9taDKKquSI2RUnaZc7Kw4TZtrY7UZSJhhOxCXJ0Qz7pQkgKhKmtQo+kNc2mh9s3fSvabF2hFqV46/HH1kSHQwg1pPuoNi7bsp0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When invoke move_pfn_range_to_zone, it will update the zone->contiguous by
checking the new zone's pfn range from the beginning to the end, regardless
the previous state of the old zone. When the zone's pfn range is large, the
cost of traversing the pfn range to update the zone->contiguous could be
significant.

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
| Memory Hotplug | 256G |      10s      |      3s      |       70%      |
|                +------+---------------+--------------+----------------+
|                | 512G |      33s      |      8s      |       76%      |
+----------------+------+---------------+--------------+----------------+

[1] Qemu commands to hotplug 512G memory for a VM:
    object_add memory-backend-ram,id=hotmem0,size=512G,share=on
    device_add virtio-mem-pci,id=vmem1,memdev=hotmem0,bus=port1
    qom-set vmem1 requested-size 512G

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
Signed-off-by: Tianyou Li <tianyou.li@intel.com>
---
 mm/internal.h       |  3 +++
 mm/memory_hotplug.c | 48 ++++++++++++++++++++++++++++++++++++++++++++-
 mm/mm_init.c        | 31 ++++++++++++++++++++++-------
 3 files changed, 74 insertions(+), 8 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 1561fc2ff5b8..734caae6873c 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -734,6 +734,9 @@ void set_zone_contiguous(struct zone *zone);
 bool pfn_range_intersects_zones(int nid, unsigned long start_pfn,
 			   unsigned long nr_pages);
 
+bool check_zone_contiguous(struct zone *zone, unsigned long start_pfn,
+			   unsigned long nr_pages);
+
 static inline void clear_zone_contiguous(struct zone *zone)
 {
 	zone->contiguous = false;
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 0be83039c3b5..96c003271b8e 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -723,6 +723,47 @@ static void __meminit resize_pgdat_range(struct pglist_data *pgdat, unsigned lon
 
 }
 
+static void __meminit update_zone_contiguous(struct zone *zone,
+			bool old_contiguous, unsigned long old_start_pfn,
+			unsigned long old_nr_pages, unsigned long old_absent_pages,
+			unsigned long new_start_pfn, unsigned long new_nr_pages)
+{
+	unsigned long old_end_pfn = old_start_pfn + old_nr_pages;
+	unsigned long new_end_pfn = new_start_pfn + new_nr_pages;
+	unsigned long new_filled_pages = 0;
+
+	/*
+	 * If the moved pfn range does not intersect with the old zone span,
+	 * the contiguous property is surely false.
+	 */
+	if (new_end_pfn < old_start_pfn || new_start_pfn > old_end_pfn)
+		return;
+
+	/*
+	 * If the moved pfn range is adjacent to the old zone span,
+	 * check the range to the left or to the right
+	 */
+	if (new_end_pfn == old_start_pfn || new_start_pfn == old_end_pfn) {
+		zone->contiguous = old_contiguous &&
+			check_zone_contiguous(zone, new_start_pfn, new_nr_pages);
+		return;
+	}
+
+	/*
+	 * If old zone's hole larger than the new filled pages, the contiguous
+	 * property is surely false.
+	 */
+	new_filled_pages = new_end_pfn - old_start_pfn;
+	if (new_start_pfn > old_start_pfn)
+		new_filled_pages -= new_start_pfn - old_start_pfn;
+	if (new_end_pfn > old_end_pfn)
+		new_filled_pages -= new_end_pfn - old_end_pfn;
+	if (new_filled_pages < old_absent_pages)
+		return;
+
+	set_zone_contiguous(zone);
+}
+
 #ifdef CONFIG_ZONE_DEVICE
 static void section_taint_zone_device(unsigned long pfn)
 {
@@ -752,6 +793,10 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
 {
 	struct pglist_data *pgdat = zone->zone_pgdat;
 	int nid = pgdat->node_id;
+	bool old_contiguous = zone->contiguous;
+	unsigned long old_start_pfn = zone->zone_start_pfn;
+	unsigned long old_nr_pages = zone->spanned_pages;
+	unsigned long old_absent_pages = zone->spanned_pages - zone->present_pages;
 
 	clear_zone_contiguous(zone);
 
@@ -783,7 +828,8 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
 			 MEMINIT_HOTPLUG, altmap, migratetype,
 			 isolate_pageblock);
 
-	set_zone_contiguous(zone);
+	update_zone_contiguous(zone, old_contiguous, old_start_pfn, old_nr_pages,
+				old_absent_pages, start_pfn, nr_pages);
 }
 
 struct auto_movable_stats {
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 7712d887b696..04fdd949fe49 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2263,26 +2263,43 @@ void __init init_cma_pageblock(struct page *page)
 }
 #endif
 
-void set_zone_contiguous(struct zone *zone)
+/*
+ * Check if all pageblocks in the given PFN range belong to the given zone.
+ * The given range is expected to be within the zone's pfn range, otherwise
+ * false is returned.
+ */
+bool check_zone_contiguous(struct zone *zone, unsigned long start_pfn,
+			    unsigned long nr_pages)
 {
-	unsigned long block_start_pfn = zone->zone_start_pfn;
+	unsigned long end_pfn = start_pfn + nr_pages;
+	unsigned long block_start_pfn = start_pfn;
 	unsigned long block_end_pfn;
 
+	if (start_pfn < zone->zone_start_pfn || end_pfn > zone_end_pfn(zone))
+		return false;
+
 	block_end_pfn = pageblock_end_pfn(block_start_pfn);
-	for (; block_start_pfn < zone_end_pfn(zone);
+	for (; block_start_pfn < end_pfn;
 			block_start_pfn = block_end_pfn,
 			 block_end_pfn += pageblock_nr_pages) {
 
-		block_end_pfn = min(block_end_pfn, zone_end_pfn(zone));
+		block_end_pfn = min(block_end_pfn, end_pfn);
 
 		if (!__pageblock_pfn_to_page(block_start_pfn,
 					     block_end_pfn, zone))
-			return;
+			return false;
 		cond_resched();
 	}
 
-	/* We confirm that there is no hole */
-	zone->contiguous = true;
+	return true;
+}
+
+void set_zone_contiguous(struct zone *zone)
+{
+	unsigned long start_pfn = zone->zone_start_pfn;
+	unsigned long nr_pages = zone->spanned_pages;
+
+	zone->contiguous = check_zone_contiguous(zone, start_pfn, nr_pages);
 }
 
 /*
-- 
2.47.1


