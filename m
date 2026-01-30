Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2873E6BF1D
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 15:09:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1939E6B0089; Fri, 30 Jan 2026 10:09:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 141626B008A; Fri, 30 Jan 2026 10:09:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 022DC6B008C; Fri, 30 Jan 2026 10:09:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E4A4C6B0089
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 10:09:14 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 85E53140665
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 15:09:14 +0000 (UTC)
X-FDA: 84388963428.14.B94B191
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf27.hostedemail.com (Postfix) with ESMTP id 623AD40007
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 15:09:12 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=eGxqSab4;
	spf=pass (imf27.hostedemail.com: domain of tianyou.li@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769785752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=tzTC/YRi5F2hd1Pl/RqKe1MRTNrskbzbigksVfGUnyE=;
	b=RLbX19tY5qJEFcmIWM01RSADx1TAXQdT/aeEh78tUuBEdhu0FQtLsEJcH5OJpLPJ7blYLP
	LIzsKSva2X52bgl2zEGXCXNwpisuc3Rnxojq83enonJERw2aa9neLVh3HxYMYE/R+CbY++
	Bd4IvY+yo61vzoWKw+5m+GHFGA81HP4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=eGxqSab4;
	spf=pass (imf27.hostedemail.com: domain of tianyou.li@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769785752; a=rsa-sha256;
	cv=none;
	b=I6uC05fryGaMEVU5UznthzI9yy7nETbrilcwnzoiHvPi5UyQcDZTys3YE1S540iTQsQmC0
	x4omD6EyXWZTQdkRL2Nb7FDyKgEPP8rH38YSG9mb5i4UbLPhwYU7HbnJS4UkOqzAfNsHJi
	8k2hURh4hINheGxLQYX8kjSKmUrygao=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769785752; x=1801321752;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=vFZM82pSaymmTWBe40lRSwnDX7vpqqmpLiq/Cb19+88=;
  b=eGxqSab4kR3kNQLOR9FXEb11j7xIr9OBgt68HmMbBahy6j0qGsD6/Bzv
   Px7LTWNb88fVseKXoEqSIY2ia9Wlk+lXH+K+nG5/Ia+PcsOTRkczV8+pN
   ydYkmmTl0pSH2v+aAOLDbEiaI8iCT++eI/9F1yjfZG9ojw+ezaaeNV+zZ
   fdpiswGz0iqd7LxB+6dSqn3IHUw6GtRauWoNohLvJkipd0aTt4+lI7h3R
   cvUanaFiC0qSkHlAQpM1dacN12x50x+bfJvPItFw8IceN9qGUGnXgEuQt
   LVZKgzTWPKa0ZEQKhukuoltW4KGMq5xgh3UFIWtM0wSwmUOtOS425Vc0A
   A==;
X-CSE-ConnectionGUID: hEhjcD/hQ4WEopfExoQkLA==
X-CSE-MsgGUID: SXGYu5ZiRDeuBGUW24eAVg==
X-IronPort-AV: E=McAfee;i="6800,10657,11686"; a="74659848"
X-IronPort-AV: E=Sophos;i="6.21,263,1763452800"; 
   d="scan'208";a="74659848"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2026 07:09:11 -0800
X-CSE-ConnectionGUID: AdpxE0LwSkGuKfBxrwrP3Q==
X-CSE-MsgGUID: FC6X6yZ7QyuuUFA60B2CoQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,263,1763452800"; 
   d="scan'208";a="212950008"
Received: from linux-pnp-server-27.sh.intel.com ([10.239.147.41])
  by orviesa003.jf.intel.com with ESMTP; 30 Jan 2026 07:09:07 -0800
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
Subject: [PATCH] mm/memory hotplug: Fix zone->contiguous always false when hotplug
Date: Sat, 31 Jan 2026 00:09:38 +0800
Message-ID: <20260130160938.2671462-1-tianyou.li@intel.com>
X-Mailer: git-send-email 2.47.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 623AD40007
X-Stat-Signature: frcg3boncnm1e35hhssju7o88ssqfcm7
X-Rspam-User: 
X-HE-Tag: 1769785752-838976
X-HE-Meta: U2FsdGVkX18Kqpf2/l8Mi7cTHlktKvwUt9wAYU5LpR+b8rMWFKE40Au3+scHFDwAf3ZpGl+fgpCuou4NdcpylJIFc2Ftl6y4S61bbVRUuXqkNLzvIbmRHBQ4XpX6tsWQT3ePyVDrCBUIlP9TBhYTJ8OPeXTwsQvmFPvk26Xo0H3nm2cvUXkKGcSxaU96a8ECBMtIRP2Uhho2lQKw26tCRLCzebYD/S47HrLbFZOW4Tnj8/OnC9i24lldAzvmhHI0qB4mGyyYxnZo2ijLHu85+WGf92KYR5+ydbk4z8mMpiT33ScbE60WXdq1Ok8Acj05kdIyuKcqm6eCrcpBRDvTrUfT8idz+UtwMPLcgYAYaR378CIOEB/12svoqNHbLN+BkVnDRM0vxNrH4HsVILsSn4LSiC8Db8t2adJCsIBI6aLKf3eWEfSF6+fy/3vhCddmkNIeJhUz0C2OiBMnoYkB/7AOEqSAi9RwMvcewNAJy6SVYOcBhEHHsNTgziYOVxynDyHDPXH3Qi2epkq0unPkOYMWO6gI4WXQozMWEM1d8Et213erHKx2FWjtsHzNNHBHxF1pwsyzCWjSvsgr/8VQ8u0OP0l5uDIY/eIUNYX86dY2XbRrkH4D/L8AVhnDzqIOp+mm54tx85fV3itQAO/HkQ5AonrcWNwTJgd4Bhx65+Z2xMMN4/yxAe7zkXhtbzXi7/6Hwl0E6ErVjlpRpwrBNQwFx3QVMPpje64yVYvdsdcMEcZFLsg4hIKeC2rvfC2kEaMZ6A2ThK0nCsUx/ytddO6Uve/EDROF0wTFrvImfJPk2qcT3wpYsKagUngP5tT6kMLPG8RZYefrtnLuIySWduft2uWkhvjjW12EXNul5pZsGwLfh/pxEc9mmGkpIo3qVYcho3MZGv8edK2gs+O7JrKeXfjI20rmoxWYXTW/YnxHF1Yl+YoAEXzLtMOAJkrUJd/Ui/vDeA3nzsNPGc5
 q0zeAhJ9
 K/N8EBzj5/++BP+7A9DBJ5WboC0RHXUiIJVb3lUuLQJzmHAHqxBhlJ3e8dS62mZSa/zg9NmOgpUE9Pv20auCjYrWA6A8jGvzg5WwPqU9tiUEuGYbcU0SHf79dbN/HQMccjN7Y2dQYDURyEaAppf5QjyROXJKGuBO+a2ptP4/IMO1MpbR99JHWPfrg5MNfSd8nmdfCS1LQOD7PShUEsJVLl+zOZFbCVenYQCKyGaGxlrElh/MSe7XpLBMyeYH3csXwEkB+tPeohnKN1zaIF6HBLVxwCJb31nu6Kp+Ygq9KrKXLsiqP/UjDyK53AZnAPlxWX+GNJF7+swtxK3M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Yuan Liu <yuan1.liu@intel.com>

set_zone_contiguous() uses __pageblock_pfn_to_page() to detect
pageblocks that either do not exist (hole) or that do not belong
to the same zone.

__pageblock_pfn_to_page(), however, relies on pfn_to_online_page(),
effectively always returning NULL for memory ranges that were not
onlined yet. So when called on a range-to-be-onlined, it indicates
a memory hole to set_zone_contiguous().

Consequently, the set_zone_contiguous() call in move_pfn_range_to_zone(),
which happens early during memory onlining, will never detect a
zone as being contiguous. Bad: the fast path relies on the zone
contiguous state may skipped.

To fix the issue, move the set_zone_contiguous() call to a later
stage in memory onlining, where pfn_to_online_page() will succeed:
after we mark the memory sections to be online.

Fixes: 2d070eab2e82 ("mm: consider zone which is not fully populated to have holes")
Cc: Michal Hocko <mhocko@suse.com>
Cc: stable@vger.kernel.org
Reviewed-by: Nanhai Zou <nanhai.zou@intel.com>
Signed-off-by: Yuan Liu <yuan1.liu@intel.com>
Signed-off-by: Tianyou Li <tianyou.li@intel.com>
---
Separated from: https://lore.kernel.org/linux-mm/20260120143346.1427837-1-tianyou.li@intel.com/

 mm/memory_hotplug.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index a63ec679d861..c8f492b5daf0 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -782,8 +782,6 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
 	memmap_init_range(nr_pages, nid, zone_idx(zone), start_pfn, 0,
 			 MEMINIT_HOTPLUG, altmap, migratetype,
 			 isolate_pageblock);
-
-	set_zone_contiguous(zone);
 }
 
 struct auto_movable_stats {
@@ -1205,6 +1203,13 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
 	}
 
 	online_pages_range(pfn, nr_pages);
+
+	/*
+	 * Now that the ranges are indicated as online, check whether the whole
+	 * zone is contiguous.
+	 */
+	set_zone_contiguous(zone);
+
 	adjust_present_page_count(pfn_to_page(pfn), group, nr_pages);
 
 	if (node_arg.nid >= 0)
-- 
2.47.1


