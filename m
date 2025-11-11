Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8324ECCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 03:04:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8C4F8E000C; Mon, 10 Nov 2025 22:04:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3D5E8E0002; Mon, 10 Nov 2025 22:04:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2BE08E000C; Mon, 10 Nov 2025 22:04:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A85F78E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 22:04:24 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4330EC036B
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 03:04:24 +0000 (UTC)
X-FDA: 84096832848.12.E8583EA
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf06.hostedemail.com (Postfix) with ESMTP id 940A0180002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 03:04:21 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jNsiaLRb;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf06.hostedemail.com: domain of tianyou.li@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=tianyou.li@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762830262; a=rsa-sha256;
	cv=none;
	b=C1f4/kZlA3zHH5Q0TGCBtaGdSCrPYhfMSdEFB26Ao3PSTTmgdA/gzPO5Hk5VA4yHGYWDxw
	AU38rxW2u7A78EBlLxZ1YNnARMj80Nt2zmgEQUHnf+BeVHMcyfBOIilTV+3PeDlAyK9cNS
	VJU6rz5gJandMJqtq8Y9UJx2yId7N9Q=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jNsiaLRb;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf06.hostedemail.com: domain of tianyou.li@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=tianyou.li@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762830262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=xTgzSccouxxOd1Pd0gwWnVYm2edQE0v4nnHTl2yGMM4=;
	b=ejAO0ElSRk0o0xOCzY69ktAnJ/LLbUpedukGpqOYo4UxeoRZeS6NzeZdeW5efE8VYXpTBA
	xYNaWZ+X/fzQ++KETjDx4nP9BtLpGCoHLhu3NfXVCM82e8j3mTKDqTftbZmJTuK4QkAEHt
	Gi9gs72z+ZkTq66fOdyVq8xawHJVecg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762830262; x=1794366262;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=U14qEmo2Bd9oj+urSYeVZMeAZrk53gq/DoeDSco2grA=;
  b=jNsiaLRbJUuEmCgcwJUcaz0N7J4N6w4YmVxR0sV/0RyZTD1wDl537waV
   DuUqLVU46EOZ5JZa6q1mAeG/DrmZ6IvR2A6xohtuzVenkfdQI+vj+SUI+
   gE/pc0DF6hNGeaFz6Z2SDA8XEjEtGwJMHNSairB4bcCpc/q2Mj37an/ii
   PViquz5IFyoqPEE9cwcG6P3V6ioJpwhVkMJiaHa++Zt6F9GyKcdBCnfHX
   WkDI2zOx618mjiNVOYFWqfHhIEYIxFkGrESbOm2SmSb9ikPiT4S+IdduR
   sOgdeTqpp3JJ9XHkHpzz1H88guy//3xhTNWLufgIjU21aDBzQh6Rpz3d5
   Q==;
X-CSE-ConnectionGUID: mby+jA7MQmmbh0cPe/j84w==
X-CSE-MsgGUID: GFizm4CRQKyeBbgp8axuEg==
X-IronPort-AV: E=McAfee;i="6800,10657,11609"; a="65044832"
X-IronPort-AV: E=Sophos;i="6.19,295,1754982000"; 
   d="scan'208";a="65044832"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2025 19:04:20 -0800
X-CSE-ConnectionGUID: dYGErXrHQMy2oUs2IjcdZA==
X-CSE-MsgGUID: 2N3tqJKnS6+ccOwshoA7Hw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,295,1754982000"; 
   d="scan'208";a="193844403"
Received: from linux-pnp-server-27.sh.intel.com ([10.239.147.41])
  by fmviesa004.fm.intel.com with ESMTP; 10 Nov 2025 19:04:18 -0800
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
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/memory hotplug/unplug: Optimize zone->contiguous update when move pfn range
Date: Tue, 11 Nov 2025 11:58:45 +0800
Message-ID: <20251111035845.2556593-1-tianyou.li@intel.com>
X-Mailer: git-send-email 2.47.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 940A0180002
X-Stat-Signature: we3yzoc56fx8tk7w19eft1iub77fsgtg
X-HE-Tag: 1762830261-664661
X-HE-Meta: U2FsdGVkX18m0qTuqD25ZV+QGlPPhatBvEMMEVv6BiJn33eca7OkhIIMV435vK1bNzfO5rSimG8Y2V95wnuDWexEZZ8k9/cW5jfdcEC4hXjp5kMbLkWDbEeY/rNuQcUFmCAnLFVPyjePuuqXyhY3nggKvCzaXDl/IEHDEo0HroWINxd6gsICZmlatP+bG0qpzQW/MEXwWJe5Ff6339sunCBGTiCZQxuQ6HmTHr/e0W6M8n1et5dkfQIulkRQHMwORU77l+XLt1WEpDAjNkgdSpnp8I3WC2Q6B9pZL4aRzgTe7c7Y0Oetl24C8T/WWNNgPqXbUngBmskbuT+ntgh54qv3A8PZsUvhzz0RCz39s0+Oplg9LQjICijGTrG9IsijCR5tkoX7PKtjtXlFTqZEmgIqNpLa3K7wV1F5Rq6M8cVGi8Kzx6L1BS8kqofDs9UwNCeGLSCdbrKrtDQuLQPHNgcoCWpKnu3V9BqWeWydXNMmPRCcCXCvZBG0gnuToBj08+XmKuMxNUEV8XfagsXL2eLzZkaCU6VgUyCJY6UtAtGed+cQa4KtySU5oYw+6TUcWt3/X6Nu72iynvghbmOM0WelK/+Wnvn1tAlM0nevh3FlNEjPIQ2qa36nMv6r3z2NkKFv+OLQOTqBrVFLkV0T/M6fWLRaGtESuDBHdFecnr+abLmaBRruHWAcz0xMNpKdwlX/hIYUusX5Zgqj0S6SKbygBW6MssHjDUMf+yeP57HNUzP1ofyIOsrGHhrn0we2paTGYb8iFjRe3DlnG/ZBIA/oVgBbqvzEtvBTlqMSMyd+O3bLkkTznIp7kpch51JRLZnQgNm3WvQaqAuKhV2lL6dJOePkZX14r4PvpE85umqCTgprO7MA2yHDbAI3bdPu+ZE1QFz1IlV0TEabZVQwOz5mlqsjGwBG+2Gt00L3uIHfNQJb1AIoseYBkWdsS7dY/AQViTUswL+WbtnY11v
 Mp8yaUe2
 QqSi1KPnLfQV/mN3t1itRY3u2x6IouZgNgJOLXrtsJ/Mkiu5LbGps+QB+Ji0+ycagM1lTb7xIt5DKCdr3HWUGWzNHWPAfmODt6QHgw9V7fC3g8P2/IRw7DymJR2nof4UE6DxDtr9ik/fUZn6kmvcaMrzE+/JX7XSxp3FksRd+pkP5w5ybR94jIPXZnQ==
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
index 3db2dea7db4c..7e5049f060eb 100644
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


