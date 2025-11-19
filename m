Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42274CF2564
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 03:09:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 993EE6B0031; Tue, 18 Nov 2025 22:09:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96B4F6B0062; Tue, 18 Nov 2025 22:09:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A8C66B007B; Tue, 18 Nov 2025 22:09:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7A8C16B0031
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 22:09:08 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B8DE758355
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 03:09:05 +0000 (UTC)
X-FDA: 84125875050.25.DCD0C1A
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf16.hostedemail.com (Postfix) with ESMTP id EE92C180008
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 03:09:02 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hRzA3cej;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf16.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=tianyou.li@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763521743; a=rsa-sha256;
	cv=none;
	b=k7osdcwKnK+n303+io0GR2EJD+GN11xO9wS0RaT4A5fy5j0W4Us9J0tgp0yoC3QV0nHjZA
	9YDSwgI3+rN/GmDbzX2EpzgtTPyMqX98dUUJNocYgEbMQvwnaQ/XZSQ6HfcL1DwFGBx3vQ
	mTHpUm3Tv5PGK3lpmdt1FOJieI3sTnY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hRzA3cej;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf16.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=tianyou.li@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763521743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gh6R88LAbnx9tFBHvcQcYUPaASHiMjoo8OXtsvQlTnY=;
	b=AmF/73Hfl4DXutoiJSY836o14eUj64a9rWKE+WPK86jMjBkYcKkS6Dbn6GJCNPuxRl0oai
	IGUZUCbd7ZMqzTkCO/pzPVlnfmYGM0un5vpXinMHcmZfGxzGlC8UyYYmwj8Xh7Kuvnlhdu
	GYIrXBK8nvou0KDCnrMduZHogeJ6SZo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763521743; x=1795057743;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rNPZHlBaO/JApGt1epeD+p3Oa009n2+ha/fBgcOGjrI=;
  b=hRzA3cej0mSa0dm1/i68GSSlO6nVH9r5Pe9QjOlN5dW4mBWi3LuUZD3j
   EXR5C/PYCVd+0B25Ss9oaRpYKukysSfo28kZ7ghWtvZaUeN8g3ku3NJkP
   A8ai2ltGWXendwwh7suQwOsPE7Prru3C5CP14ucVJ6Tdb+/3CXcKQcEbN
   /Szeb82Ycm7KKijcY3zfAe9CU7CYouqozOMAL/HYj6Xp/jgBM3GsTms13
   nyjLGB/Qa3IO4J6gjLOBF63/T7FFyvTIODmI1OsDCU6tUOH6jjuPhN0Mw
   +vaJfBngkp8zlwlCk34aHzdVzynv+ktEsBUZM6qxU1/s6K/SpHX8W9w0U
   g==;
X-CSE-ConnectionGUID: HbAo+PzQTh2EEtluCo5vSg==
X-CSE-MsgGUID: O3IfCvo6SI+OGrqAv+xYww==
X-IronPort-AV: E=McAfee;i="6800,10657,11617"; a="91032308"
X-IronPort-AV: E=Sophos;i="6.19,315,1754982000"; 
   d="scan'208";a="91032308"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 19:09:02 -0800
X-CSE-ConnectionGUID: 84U3sawTTPO3ZldqdNZBdA==
X-CSE-MsgGUID: aB3xw2FzS/uF+2x6c+sx7g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,315,1754982000"; 
   d="scan'208";a="191371608"
Received: from linux-pnp-server-27.sh.intel.com ([10.239.147.41])
  by fmviesa009.fm.intel.com with ESMTP; 18 Nov 2025 19:08:58 -0800
From: Tianyou Li <tianyou.li@intel.com>
To: David Hildenbrand <david@redhat.com>,
	Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>
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
Subject: [PATCH v2] mm/memory hotplug/unplug: Optimize zone->contiguous update when move pfn range
Date: Wed, 19 Nov 2025 12:07:18 +0800
Message-ID: <20251119040718.2735199-1-tianyou.li@intel.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <aRwAjSQBby614Itx@kernel.org>
References: <aRwAjSQBby614Itx@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: EE92C180008
X-Stat-Signature: pmi6yjhh3ucp7qtmy8uchz8ukbhpecaa
X-Rspam-User: 
X-HE-Tag: 1763521742-695951
X-HE-Meta: U2FsdGVkX1/U4gWsJum7dBJCVNrZ1IfAkzLsyl6yyMKkvPunY/N0NKEvFcAtzQvU4DmlCm8XxzVkWn2kb1YcUjMoTBPEOvOCZkZIpYO/VWnd7lzXYCT/6xuJ/SVk8tsJFTH6kCvW7Jswzh6usFwBLh/0+5a3GC9lGYBC5/QLxGc6Rj1fm3RMw4i3xHS5V4UBU88d9ZdYUL6V8ibCasnashly2rvtnWaVrUOcNvFQsqz9VWA6Tyy+LP4KXIbt8nYqfOTI/g2ak98SUITtplNjknEOjvxSEJTeaPAZcyQni8coPTmco9fw617R9B2eT2qtUHzn2LgJdVBLk6ROoC8JxNpI34iDFnZQxWHusN/FU1VjIItn+uowMxzfN1suYgQ9X9gNLAm3ARX9TTtZBKRr9kS3jm+HmiY6DXwVcfYWpXqt7L9Fw5tt5z06zWWIuM0/nCgB9aq1BtRFfC2psaG5ItWNi+iiGbZYA8kV9H2SmgEnTGGhhn14WKJ9RQ7Fu34eE5nLdjIEMHs7ma2iXe91hX0m6Ggq/eeCCVQdnSE26mmxNYuyM59WZ6kCy4KrxQy21Ut0KsvyM3NVhuvjnkMgv9HypqY29M5360+5FgGxgY+iJWXHwdCkS6O6DV7CQGGSRn4niUOJgwG7aimwFCC4IpTlmGgqNTL/FH3+YNxgbKorpG+Wysp280DVw6EDLAxq2G1tpc6cRlv2LC/NWXwnjkt45lWMQBWRSAXzPfQbVDkM0YuYaJqM3AeeACAhiXs6+4invg6TMwMln80OBQAmoDu2gevwXF4Q3OMMb2D2/c6iJSpCU+GqpYZ0/p8Af4rlH4blugjaoMx1BOBqRmTFUhdz+A8YiDdOymgrKGrnyoTa4pbmHdqIohuh/iU7i0qY5mA+YKcyCA7/h5tBT5xBYJW3EU8UMgweX/lO6xNXBBK2wcuAl+bvytB6mhVBvUqqlLY+ta4EfMA4dyMvPKl
 YQKKgQsT
 Mt29r7UImdfcAeuOE1iOlAgOxrWjuRLMUQ08YgaGDxHBiyqWrpiFk0kEhMd9FKRA9AthHtVIqLf07YSFNhAm2naxZ7sYNpPpBUlojftJm8Oq6kf8da+Vn88WCpLXMWVFRniiqVBj80vFF2nSiYfniP4PSWBbeXoJyuXHzcuYZvM9AJE/9shGOwjxfSTmbhyu6LC4ZELuDByHIP9o=
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
| Memory Hotplug | 256G |      10s      |      2s      |       80%      |
|                +------+---------------+--------------+----------------+
|                | 512G |      33s      |      6s      |       81%      |
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
Reviewed-by: Yuan Liu <yuan1.liu@intel.com>
Signed-off-by: Tianyou Li <tianyou.li@intel.com>
---
 mm/memory_hotplug.c | 57 ++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 54 insertions(+), 3 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 0be83039c3b5..8f126f20ca47 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -723,6 +723,57 @@ static void __meminit resize_pgdat_range(struct pglist_data *pgdat, unsigned lon
 
 }
 
+static bool __meminit check_zone_contiguous_fast(struct zone *zone,
+			unsigned long start_pfn, unsigned long nr_pages)
+{
+	const unsigned long end_pfn = start_pfn + nr_pages;
+	unsigned long nr_filled_pages;
+
+	/*
+	 * Given the moved pfn range's contiguous property is always true,
+	 * under the conditional of empty zone, the contiguous property should
+	 * be true.
+	 */
+	if (zone_is_empty(zone)) {
+		zone->contiguous = true;
+		return true;
+	}
+
+	/*
+	 * If the moved pfn range does not intersect with the original zone span,
+	 * the contiguous property is surely false.
+	 */
+	if (end_pfn < zone->zone_start_pfn || start_pfn > zone_end_pfn(zone)) {
+		zone->contiguous = false;
+		return true;
+	}
+
+	/*
+	 * If the moved pfn range is adjacent to the original zone span, given
+	 * the moved pfn range's contiguous property is always true, the zone's
+	 * contiguous property inherited from the original value.
+	 */
+	if (end_pfn == zone->zone_start_pfn || start_pfn == zone_end_pfn(zone))
+		return true;
+
+	/*
+	 * If the original zone's hole larger than the new filled pages, the
+	 * contiguous property is surely false.
+	 */
+	nr_filled_pages = end_pfn - zone->zone_start_pfn;
+	if (start_pfn > zone->zone_start_pfn)
+		nr_filled_pages -= start_pfn - zone->zone_start_pfn;
+	if (end_pfn > zone_end_pfn(zone))
+		nr_filled_pages -= end_pfn - zone_end_pfn(zone);
+	if (nr_filled_pages < (zone->spanned_pages - zone->present_pages)) {
+		zone->contiguous = false;
+		return true;
+	}
+
+	clear_zone_contiguous(zone);
+	return false;
+}
+
 #ifdef CONFIG_ZONE_DEVICE
 static void section_taint_zone_device(unsigned long pfn)
 {
@@ -752,8 +803,7 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
 {
 	struct pglist_data *pgdat = zone->zone_pgdat;
 	int nid = pgdat->node_id;
-
-	clear_zone_contiguous(zone);
+	const bool fast_path = check_zone_contiguous_fast(zone, start_pfn, nr_pages);
 
 	if (zone_is_empty(zone))
 		init_currently_empty_zone(zone, start_pfn, nr_pages);
@@ -783,7 +833,8 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
 			 MEMINIT_HOTPLUG, altmap, migratetype,
 			 isolate_pageblock);
 
-	set_zone_contiguous(zone);
+	if (!fast_path)
+		set_zone_contiguous(zone);
 }
 
 struct auto_movable_stats {
-- 
2.47.1


