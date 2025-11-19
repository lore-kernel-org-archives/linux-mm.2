Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C2A0CF34AB
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 13:08:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0543F6B0011; Wed, 19 Nov 2025 08:08:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 004FE6B00A5; Wed, 19 Nov 2025 08:08:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E366A6B00B0; Wed, 19 Nov 2025 08:08:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CD9246B0011
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 08:08:56 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 143DF88B09
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:08:54 +0000 (UTC)
X-FDA: 84127386588.02.731D3D1
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf12.hostedemail.com (Postfix) with ESMTP id 72F8D40014
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:08:51 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=VIs2l5yV;
	spf=pass (imf12.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763557732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Y9SL57qZefJrmurh0PVwebiqHhmWmVbupaoTp2hpNs=;
	b=SbQ9PkZlr4di2MLA16le8Gm/DNwGhlawU7JD0TpZnwXsBe9lTt/vBO7XNlzUY9c/N6GJfo
	rW2UNOLDW8oc12hZ1hUEk2aMyJQXqBGKzyV0O10KgRxs6gvHUajHvwv/aFfIEdwNgpO94A
	bidkPAQLcpZ6N9e2RRfbWy8E3kGDAQo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=VIs2l5yV;
	spf=pass (imf12.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763557732; a=rsa-sha256;
	cv=none;
	b=knCBmJ4FxYXDViAO0w/RINRqukXoMgPEEdEz+u7oPTIt8mLiVAskGB4hkQnuVtRDBMx9+Z
	niiXV5NxfsXMiORXjIvM7rMo975hDVUkdezohJKv9Yw8uMS30IaJaVPrV8KGNqxcOdxoqi
	JdIvrkgRlyXLfytbxvhbOARUthivwQk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763557731; x=1795093731;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EobbzjPSd7ce0PeoMfEi9EKfhaLXGdK6W7FpdY7oKOk=;
  b=VIs2l5yVqN8KqeQx3NTqrEFXzUJ2kMhXV8X+DWV9usf2FIP0MHiCJvRp
   zv93e1JOSLc7fo8Kzyd2viP4lQms3QH+AO7/JxF+xGmj4JXx1+3AtK4P1
   FAwSGNuXTZPCRq5Utrhe7NZ0q4qEfTPAkKUWD1ovtai4gtdKM1eE9ObGQ
   HHbTVxgb48zfvehLlZClmjpktA2oBepxvdzvZQbh8GpuXOoMrJ/DNq+7y
   SfEw4dCgPvbMfayib2E9lfUAuGJp3HiO5rwa2hbdh4NXM3x7dopYtfE7P
   DZyWQHH5Xn6TL6CDN5aX/lUODf3uzGmpmSn2tXaNZEYBXXWFWKYwL3MKS
   w==;
X-CSE-ConnectionGUID: tjVoIqzZROmBbUlVERV6/A==
X-CSE-MsgGUID: X89YtE2vTNistM3hr3R3Ow==
X-IronPort-AV: E=McAfee;i="6800,10657,11617"; a="69464398"
X-IronPort-AV: E=Sophos;i="6.19,315,1754982000"; 
   d="scan'208";a="69464398"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 05:08:49 -0800
X-CSE-ConnectionGUID: XXVaHIofRpuc2rR4fZZopQ==
X-CSE-MsgGUID: N3Y1W7EZT9mZSBRsigU3Iw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,315,1754982000"; 
   d="scan'208";a="196003425"
Received: from linux-pnp-server-27.sh.intel.com ([10.239.147.41])
  by fmviesa004.fm.intel.com with ESMTP; 19 Nov 2025 05:08:45 -0800
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
Subject: [PATCH v3] mm/memory hotplug/unplug: Optimize zone->contiguous update when move pfn range
Date: Wed, 19 Nov 2025 22:06:57 +0800
Message-ID: <20251119140657.3845818-1-tianyou.li@intel.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20251119114252.oykrczprf3ecd7ak@master>
References: <20251119114252.oykrczprf3ecd7ak@master>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 72F8D40014
X-Stat-Signature: eb4s79o715meg7a59kms6grhbx9utt5y
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763557731-241769
X-HE-Meta: U2FsdGVkX19IPefmoiGZi60R8ryiZft0+Cu3vaFSumrLZePCr+ethupXiIC9xObkc4BOEFtoGjPdQIdMpino7AxmCHWeU35HzHP/AQJCoqYBE/rtive3hqly4oKENwOUeXeMsUOUD1uj/lWWpVS1ZnptzOHiXZ9pU45tfv8MrbWGEdMwX2WIVacV0Rai0gbPfcVcU4l1Cos9Y6yQc4J7hNJriGBSbsJFGdODSjxlKxk16RfgrvlOOJKT4ArnH08ZggLg/g3odCSRPgKD10dc2oAjtldt+5f54eF/NUaZdk/BW0tL6OldHLc4539a7o/lnhtOVAdPStdsf3RQ35S5KoQCRG9nj7CCtRI2JAGlHA/RKPHHDxWjG1AftujMi+fx1xRrJ/yk7oYCJeVxhwzAZ773xIXUl+O5DHmBxqRrHcrdH3N7YiEaBIN9TURPLB/bQU4WxXn06xju7+rE3OL3MOU3Es1L2kgqnesn41zLB7adjGxJXvS6OKvQMzKhwNn1R2lA21ycPS62sqdOYQUtyOrsyro0yWtoaxRSpj+kFivvRzMGALAuvXzJ/23M6EX3jvKNd8NnXQEZ2meCrgytLOMjynlkeb+OxbUc4sxys2H24rX6yhlwQorruyTxDut9p2sTw91f3mAbmlgB+ehDESz6Ta+ElHdH/ZHNCT231E3oqM9UXbLTpkQx3q3V7somuv0BjKRT4+ERsN1rO8r8DgIj9wiqzXWyc4r9M1Tmy94kRZx9Nb5pAgsnLWT1m75hmC17loVGygXTbL+UIsjCw5s5EOpOrMe2V10X1ZToEtZDSqd05nJ7npxGiUhsntoLn/QOw+3Zomgyj6B7X3XCxOceV6ABgOaHLKDFxne649UZXZHr54wMThlGXYSAaPRqUnoEjew3vjTbs1UKU4DvSv13QCk+7qNtCjyi11GfZtu3qT4OxHhGBPAfQi8zQ6qXg3lvj5zlgeg=
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
 mm/memory_hotplug.c | 51 ++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 48 insertions(+), 3 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 0be83039c3b5..aed1827a2778 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -723,6 +723,51 @@ static void __meminit resize_pgdat_range(struct pglist_data *pgdat, unsigned lon
 
 }
 
+static bool __meminit check_zone_contiguous_fast(struct zone *zone,
+			unsigned long start_pfn, unsigned long nr_pages)
+{
+	const unsigned long end_pfn = start_pfn + nr_pages;
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
+	 * If the original zone's hole larger than the moved pages in the range,
+	 * the contiguous property is surely false.
+	 */
+	if (nr_pages < (zone->spanned_pages - zone->present_pages)) {
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
@@ -752,8 +797,7 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
 {
 	struct pglist_data *pgdat = zone->zone_pgdat;
 	int nid = pgdat->node_id;
-
-	clear_zone_contiguous(zone);
+	const bool fast_path = check_zone_contiguous_fast(zone, start_pfn, nr_pages);
 
 	if (zone_is_empty(zone))
 		init_currently_empty_zone(zone, start_pfn, nr_pages);
@@ -783,7 +827,8 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
 			 MEMINIT_HOTPLUG, altmap, migratetype,
 			 isolate_pageblock);
 
-	set_zone_contiguous(zone);
+	if (!fast_path)
+		set_zone_contiguous(zone);
 }
 
 struct auto_movable_stats {
-- 
2.47.1


