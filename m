Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4434CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 09:35:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E0666B0088; Wed, 20 May 2026 05:35:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B8DB6B008A; Wed, 20 May 2026 05:35:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A7756B008C; Wed, 20 May 2026 05:35:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0E3566B0088
	for <linux-mm@kvack.org>; Wed, 20 May 2026 05:35:19 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D5AD81A0230
	for <linux-mm@kvack.org>; Wed, 20 May 2026 09:35:18 +0000 (UTC)
X-FDA: 84787289916.04.6FC1B4D
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf19.hostedemail.com (Postfix) with ESMTP id A21BC1A0004
	for <linux-mm@kvack.org>; Wed, 20 May 2026 09:35:16 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=aWOv2IdC;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf19.hostedemail.com: domain of yuan1.liu@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779269716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T2mM8rhPjsX/H/3fAS07GRobAM4MXGryzcETHZ7EJfY=;
	b=PZ4TtJ9jH6YbocLe87bRC4oHvxaOZl8TijfMbJYj6jVHr6j/EtxRQ63QjzOvSzYD7WR7wg
	h330vRQ4tsaswfsiuVWe/TJ4tEXGtYq7R7R1Z5eA0deUIsxUmKmbbXEFe3g8TLYyQRYUPM
	kADmf2z0uqRiq9GajsxekS9dPtSjYrk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779269716; a=rsa-sha256;
	cv=none;
	b=iaENW6PL5EYp1Sd60KcwY6LZWZgmH6jOZo1b+oMWnrmHiIZ22KE+1ArRAfl1fejWHiiEi0
	GzpRDWM/wWEYlsglHCC83c10WEY9Fdi47xPh7fV7CLJ+V18m38ul6llBPjud4Eztt/x+cT
	yXZbrz02ENoBGWO9LxeCdvi+jIJUL/Y=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=aWOv2IdC;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf19.hostedemail.com: domain of yuan1.liu@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779269717; x=1810805717;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=H6pG8TzQarYorWbLMhJac6ahvD81snEqzPj7eqL2S7s=;
  b=aWOv2IdCUFIZjquqD9etGAbIJ+X+IKnfXqRwegN3mzQp1CeTcYz4rOFu
   uCjFdcF0mWax1fdFznGbYCsF5uLaKWRXDsy+4Ogg6xWLCfc6lYOsh+Dpe
   Dc1qByET8ha9EQhh2slefhaTZI2/B6qjAP7vH8mcYWXAZzJzmgAKayGKY
   QEqDHCx6f0osKFZ7zXDx4bjK544p9+yyr7+YLggvP6DeEQOPKIg1+5yL8
   lLm3RoV65f2TV8VRe2o/H8OokZl0wNQWbXCl4Gp3kW9sofptv8SSf8Adc
   IIGYE8Nfe9S9aSBmLbkznBMFPles4Ir8J+CIHtPxOVneWzYk6qTGFAPoF
   Q==;
X-CSE-ConnectionGUID: c8Lquwq9Qi6FohgGT5Izgw==
X-CSE-MsgGUID: nY1d1MQqTqeWm88toYSssQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11791"; a="90461008"
X-IronPort-AV: E=Sophos;i="6.23,244,1770624000"; 
   d="scan'208";a="90461008"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2026 02:35:16 -0700
X-CSE-ConnectionGUID: XgoZLKfWQZmCeiLlpJwhWg==
X-CSE-MsgGUID: e9a92kdZRBiXWkJqqNKp7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,244,1770624000"; 
   d="scan'208";a="241925189"
Received: from spr10.sh.intel.com (HELO localhost) ([10.239.23.75])
  by fmviesa004.fm.intel.com with ESMTP; 20 May 2026 02:35:13 -0700
From: Yuan Liu <yuan1.liu@intel.com>
To: David Hildenbrand <david@kernel.org>,
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
	Jason Zeng <jason.zeng@intel.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 1/5] mm: move mirrored memory overlap checking to the outer loop
Date: Wed, 20 May 2026 05:34:53 -0400
Message-ID: <20260520093457.3719960-2-yuan1.liu@intel.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260520093457.3719960-1-yuan1.liu@intel.com>
References: <20260520093457.3719960-1-yuan1.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A21BC1A0004
X-Stat-Signature: sdfg486chz495skrix6dbzkf1txbja4n
X-Rspam-User: 
X-HE-Tag: 1779269716-972913
X-HE-Meta: U2FsdGVkX18ICa2Yb8f+4Y8hYn2NsDzghxAcbbJAnPzMi4z7hIKhUxDPbpH7IbppZfNTVLbaX3vz4GhwFMsNP+DYJnAbWmS3fOsrGwomLgkYrSw2J8+n252djjYyp2v/8cS0Xde90RTltrWCwwfSv3/okCuezk4fIU9rnatb5ekvVwryVdgXxmuYf1ECYT0UD6lAKJEEiqQNWBKYvxotA1oP0DZawiwaepvfegHzTFxGtEjx32VxYNIz4ttJwONHIiV64lw+tnNF37zi5CQOVSEvfKs/em+wFJbUBmFa85NYmpxiNyxxupkkgLgVYafWcoR8oOhyhxFRuZM/Dz8LuiILrpGLSn+RWNVcYqedaFfYJYSy073+8BXYyaFK2RFb5HODSXU6TD2nPBnIkq3yoZ0KOfzuQQNTksma/b70T0UEGNgFd29cX059j031+2SNBeuWXzE+xqH9utsco/YI/O7E41aO7uFIwmec504qDY2ymz+dPX31KlQ3lU3UwFlPK3Xr8KVBR2ZUm+rXFqq7CiIWmd8CZKIZw0Fjr8T6l4eOpgLRFujnSQD2ps64uXvL5wersfJoQtDWqQo4FgnXS4mwJevpsLmv/q0jpWphMKSGUgEFV7QYokSZdURxakWPtucw/Snlx6XGkFBwxRiHcihOCtZsu0VXsEb9jN7YpFNP+YsR/Ef70eDT+PAT1YzePH4GjxJqx6mLkZ6iz6hT1G+6+4w6gFKoJgNLkKMxraMMjsmeC1EYLrTKbiAZus3Ccf6/k3QqOSldDQWmvU++lC69pAQZV6H/X5LxSAk+6n/ndO565tK5OxuPYVp/3upraTuDZHo481QulRtiQyK2S/+rItHwyU4filSVGRIezVCW6tXsG4NKPSN1haso7WGix75P4JJTdkmGivQElpCIezR5o6wDCdkwu6IKVvVaWVelTrTHTdcpM7ehXL2/ggdjZAC/IfSr1IiwIoiH76X
 QKYNmggm
 NE13n/ug0auyn7qensU1gjQY4JaPeIQD13pAELaYEPn78zsZFDCMJFUhNKZD2aLEhomx0ESUZVAFrpW9DE6PzpTVPp9OLaY5Mi6394akc7Tl8yZYASW9TN1XX7BqD2gXvJvrK9BKv0GJNRh30wjD3gxNEUwhHi6ub7z+9NR0NBvXhTatmk/mtBnsH+OdS0urpSqUMeCkIfD9zrHUnXCC1thpgnzIYewgDs50kzEv9BWkT0V2sz2vG9GUInyghZQqas86IfxMoNYFuHjIfIJXJQGu5Ww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move the overlap memmap initialization check from memmap_init_range()
to memmap_init(), and replace the per-PFN check with a memblock-based
check.

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Jason Zeng <jason.zeng@intel.com>
Signed-off-by: Yuan Liu <yuan1.liu@intel.com>
---
 mm/mm_init.c | 29 +++++------------------------
 1 file changed, 5 insertions(+), 24 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index f9f8e1af921c..24e103a402b0 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -783,28 +783,6 @@ void __meminit init_deferred_page(unsigned long pfn, int nid)
 	__init_deferred_page(pfn, nid);
 }
 
-/* If zone is ZONE_MOVABLE but memory is mirrored, it is an overlapped init */
-static bool __meminit
-overlap_memmap_init(unsigned long zone, unsigned long *pfn)
-{
-	static struct memblock_region *r __meminitdata;
-
-	if (mirrored_kernelcore && zone == ZONE_MOVABLE) {
-		if (!r || *pfn >= memblock_region_memory_end_pfn(r)) {
-			for_each_mem_region(r) {
-				if (*pfn < memblock_region_memory_end_pfn(r))
-					break;
-			}
-		}
-		if (*pfn >= memblock_region_memory_base_pfn(r) &&
-		    memblock_is_mirror(r)) {
-			*pfn = memblock_region_memory_end_pfn(r);
-			return true;
-		}
-	}
-	return false;
-}
-
 /*
  * Only struct pages that correspond to ranges defined by memblock.memory
  * are zeroed and initialized by going through __init_single_page() during
@@ -891,8 +869,6 @@ void __meminit memmap_init_range(unsigned long size, int nid, unsigned long zone
 		 * function.  They do not exist on hotplugged memory.
 		 */
 		if (context == MEMINIT_EARLY) {
-			if (overlap_memmap_init(zone, &pfn))
-				continue;
 			if (defer_init(nid, pfn, zone_end_pfn)) {
 				deferred_struct_pages = true;
 				break;
@@ -956,6 +932,7 @@ static void __init memmap_init(void)
 	int i, j, zone_id = 0, nid;
 
 	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid) {
+		struct memblock_region *r = &memblock.memory.regions[i];
 		struct pglist_data *node = NODE_DATA(nid);
 
 		for (j = 0; j < MAX_NR_ZONES; j++) {
@@ -964,6 +941,10 @@ static void __init memmap_init(void)
 			if (!populated_zone(zone))
 				continue;
 
+			if (mirrored_kernelcore && j == ZONE_MOVABLE &&
+			    memblock_is_mirror(r))
+				continue;
+
 			memmap_init_zone_range(zone, start_pfn, end_pfn,
 					       &hole_pfn);
 			zone_id = j;
-- 
2.47.3


