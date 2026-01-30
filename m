Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DACFBE6BF1B
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 15:06:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BCAA6B0089; Fri, 30 Jan 2026 10:06:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35FF66B008A; Fri, 30 Jan 2026 10:06:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 283206B008C; Fri, 30 Jan 2026 10:06:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1A1646B0089
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 10:06:03 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BD2A614054C
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 15:06:02 +0000 (UTC)
X-FDA: 84388955364.15.0355A77
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf02.hostedemail.com (Postfix) with ESMTP id EACC380004
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 15:05:59 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YZZza7zn;
	spf=pass (imf02.hostedemail.com: domain of tianyou.li@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769785560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=PlZKUYH3q0zF+5pbmKMuyT//gcd58UDPHVNa2LFC7Qk=;
	b=nYACz1CeES6GyXKCdLKASJpYJ03EENFqfx9JZ9vAe2TRG4txTnV7+mL8wGx8PF41mI8b6K
	zqD1KHxPRH7yqMHr2JtT7m5TqSkvRjyOmYJMXL+OrQrwDsFP5bJdWk2MtMWIy926GINjGl
	zqR1ZtNwpCNo8c4MNNtzLyPiYLvNi4k=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YZZza7zn;
	spf=pass (imf02.hostedemail.com: domain of tianyou.li@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769785560; a=rsa-sha256;
	cv=none;
	b=rJoqrwCOl0d3X0vejaz0kIIUydhjbkTM4LqOCM+FSxw24JF5sgL3q7R03LhDhUux5RJtLS
	dPMdf7gTi5fYkCWhG4NtJJW9+YtsGICaylZRtvzNBBMNzRbdfXxFnFM3Bcp9WKeIRgwgaw
	IDlhMpJ9FhfUYDjB/QaeZU7LwPm1DlE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769785560; x=1801321560;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=z4itQQ8EdTou0Lagf7D+EwlyGfKDCiq3jLuL7LgiGg0=;
  b=YZZza7zn69QUVfN3C+ZQ3BkT4UHqxUlmrvxY5+k29r8YkvSmuSyYXyaK
   TuYxRAZWX9huCWkAdh2NU0mhxipAd86IMyWjV9DinbpyKCMZ2epNf5+Lj
   1GHdeX3AfElAkYZr11vTrJYAUCt7dU9/LrYvzMwj/1gTBnU6ROBCqtaVy
   b+3zHB0cMsKGNQA9Rd+SIo2c42uLYx3cbIoJrVMyuIaLv3xyHsoPGs7nw
   mWMI4U1rJcHP0yWmggVmyt70/nymcCm5uK+Jv6ldIv4ViAU9MX53flR0j
   AF3e5ghfpSYxqEs9gLM4nGce1+K+a1PwYnkSsr6hSi4E5FAyFCKh+iIVf
   w==;
X-CSE-ConnectionGUID: w4Stl5uYRxysntjyfdQpPw==
X-CSE-MsgGUID: ftZlyFCeTGKulV2ZQhQVBA==
X-IronPort-AV: E=McAfee;i="6800,10657,11686"; a="71013655"
X-IronPort-AV: E=Sophos;i="6.21,263,1763452800"; 
   d="scan'208";a="71013655"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2026 07:05:59 -0800
X-CSE-ConnectionGUID: OS+Ay1+8STmH7nrELmRnXw==
X-CSE-MsgGUID: VSHojw0JQHm9OFBmlmf1kg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,263,1763452800"; 
   d="scan'208";a="231798299"
Received: from linux-pnp-server-27.sh.intel.com ([10.239.147.41])
  by fmviesa002.fm.intel.com with ESMTP; 30 Jan 2026 07:05:55 -0800
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
Subject: [PATCH v9] mm/memory hotplug: Fix zone->contiguous always false when hotplug
Date: Sat, 31 Jan 2026 00:06:35 +0800
Message-ID: <20260130160635.2671167-1-tianyou.li@intel.com>
X-Mailer: git-send-email 2.47.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EACC380004
X-Stat-Signature: jzho688on3jn464bdtaf7r9ywhtao9fe
X-Rspam-User: 
X-HE-Tag: 1769785559-580183
X-HE-Meta: U2FsdGVkX180AbeF54ayus02LnJc5qjMyUtrVrcIXD+IKlcrIQHJEKR+qCElnIPY/1odFFPnxR+ansAvPqx7+0sI6GfN8XgprgJqG9D+W023uYFfwPrHQ+RPsLtXEPRZqTPny0nChaBswNxzNSPt4LuaM1sPHsevWINOv6NJ4Cc/3dSlFXsL8M+Ukxz/pf37s1fypxPkPPPlN2i/80JvVVQtDxALUMfUPaHuHFv8Sx1nFsI9QPrX+dLi8t3irH8gsPH4vwefHkxIimfrpY8qwt5NriWMk62sm+MIDmEIGIWZiqNSQSs0MgrBJAwRTFIqti9WbL0bB3GZrqDtwXeuLBP2FHGG+L6ihssQJv0bk8MYxriLBNL0R7+/zT2jOHfRfij2ou2Tz3JY2V8OsIj0Pols3El3WFDaItGqWliwZiWGPP1SfTP+bTl5x73rj6waxFqD7OSMRtvUMi+2fS6mUqlLi5K6Raa46ULm4DCi1krpGP/tm5B0fdmZpE4NpbOWPs8f8v2/OYELnI7bi7ZeWflG97iTjWrs7/clDYrQ/WIFeYXOSiPF7zUeCieSBylWbPPv44GQb+PKJ6Tz6DytxTZw21WfX/MuCzk342w7eAgvBIsjkwzkndYC04hkW4/1iMEodeceMAkWB1P5dCxIO69TLRPAou1x6b2dOBG1Ikwrk1kNIua3ba7VbVHJh52ixIETZZ3alxnQSnfp/Psv7ZETLMA1+/RPWpGXjyvxYpiCFQQXLtzQb4VVX4o3b8c8lirVghtwp0r9hBa/xqZpjEyJRlFIOKrWoF650cbF1H8P2ZSXJoSgy1TuieXL6pM7A65m+As0WsOKSephzpiwHjEorGOYxy0o7i1thpavVKolv6kGOFy9EyIetsQb/PWFnz3h18lg+3735SORrM/V2uuy73OotDKdU3TygB2pPjdDHwoqVgXiSTooLF9w4XML58sCIWR91HXBoUYhZiN
 GNl6wN53
 DhI2N6c/TsBsgPMf/Dw9po1CgnBMfN3EgbEtE7735Nye4NrfEjXEbLDqnhBwApuSl+bZw+bIW6BhJ1Hj0lMCuqvkGAkLDxHEQ/FvKoFbvYTS9biQpwnXt6ICRJfYsvMKvrZ3btlVprvgRk6Y9X8rKFNxGSvfEl8MCXPz9eU96ER1da+FoWc5Mvvwj9ZAEaLnBZlpl7Rb7y77HFpYJgiLsbqcZqTtLW3eaeWZSyw7WSSHicjz8Xm4kxVPG9dtaKetCFgp+Kat0+pgIu5pb79V79cPW//JFXbN4PklX263HcTZ3Ir6oMk5IVoJCRhYn4CuVTBCWEwtK7uW+zzo=
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


