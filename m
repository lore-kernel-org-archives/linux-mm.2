Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4D3BF8FA6D
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 12:55:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C356C6B0089; Tue, 21 Apr 2026 08:55:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEC3D6B008A; Tue, 21 Apr 2026 08:55:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99C576B008C; Tue, 21 Apr 2026 08:55:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 83FED6B0089
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 08:55:13 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3B6FFC3C48
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 12:55:13 +0000 (UTC)
X-FDA: 84682558506.12.E4CF5FB
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf27.hostedemail.com (Postfix) with ESMTP id EA1644000D
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 12:55:10 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=db5QEeGX;
	spf=pass (imf27.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776776111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wi7XnS8EyGDIPzllgXzAw1YBnjuuXF4XkUtArZKKp+k=;
	b=oBgR0K2kpxiQvR/Q/xip8FT6x4iSxPtlT1GYLZOVoBRs4aWG4dYFX5ixyeTaCh09M9ndKW
	GHfLJ36bMF7fbsuyavPu6+mFKNqtkVxWjFHAWtrqslAgOLMpEawgWBvnIqAMQAfUJOHO2t
	ncyVoQdzDvtQjcKWmAGTsdvogDNo8r8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776776111; a=rsa-sha256;
	cv=none;
	b=siLnLvDtNmMrJAIBOgdtF87PCm7Nkv7aaLiUM/bLMdxPdttI/UEDKsJJzaKvr4hEJdJKnN
	A8r0yYLOCc9z9k3KompItG3Kr8aiAmqr2Xt+5b9lgtQbCUXMc/omsdC5w6VpQteGmu0TP3
	VYamNuc7d/CaZOX6h/Vn50csFDRJUAM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=db5QEeGX;
	spf=pass (imf27.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776776111; x=1808312111;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=la0kE+U18VpZTh/JecOWzTRDqzNAkItoXGtY/DvNqnw=;
  b=db5QEeGX75jcW7kczf44nxDTKgQQI0ZPj1Jg82TXIfyVIUOCWeNVdVEa
   tQaAs0GdssXSZBP4wpki/o7urLYKvwaYuIqNJhJ4u3VPiMBafuFD2Tou/
   Q4eXF5tOAQELr1v7cVUjb/9aPSTovKSMCjrtSC8lzNbqzbo2UmaMW+dma
   wU7lDKkOmceugs2ARgzdq/LHSGGnlAFxzW0DLqV6hawwsTfzL0nlrHZpN
   ovjlL0JSozA2VUyjcxg++ETO2LqUIaKCpy04riBH3p57LNiE8hvps1QiM
   u3c7xMXSd+n4elanEoT/7MfapvHgaR7navs+QopRDTSlKcvo+gBN46mT1
   Q==;
X-CSE-ConnectionGUID: RUKqiDnZSki6BPbQkZi6Vw==
X-CSE-MsgGUID: bg+u50SyT8GPdGM1RbiXrw==
X-IronPort-AV: E=McAfee;i="6800,10657,11762"; a="80294045"
X-IronPort-AV: E=Sophos;i="6.23,191,1770624000"; 
   d="scan'208";a="80294045"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2026 05:55:10 -0700
X-CSE-ConnectionGUID: xMEVpwGxQwqo+KXyKqoENw==
X-CSE-MsgGUID: 0HjUGPv1T6qrWSKq25A/SA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,191,1770624000"; 
   d="scan'208";a="231138638"
Received: from spr10.sh.intel.com (HELO localhost) ([10.239.23.75])
  by orviesa010.jf.intel.com with ESMTP; 21 Apr 2026 05:55:06 -0700
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
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/2] mm: move overlap memory map init check to memmap_init()
Date: Tue, 21 Apr 2026 08:55:07 -0400
Message-ID: <20260421125508.2317429-2-yuan1.liu@intel.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260421125508.2317429-1-yuan1.liu@intel.com>
References: <20260421125508.2317429-1-yuan1.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EA1644000D
X-Rspamd-Server: rspam07
X-Stat-Signature: zhecf3y7w3f6jtbi3nagr39bifx8rdky
X-Rspam-User: 
X-HE-Tag: 1776776110-914126
X-HE-Meta: U2FsdGVkX1+kZUfAPh2pEKP0xrObhadjnt4mtHSUvhLkqGpCiVb7Px0gFVzKA90orxdvmKIZdhIAJ8bv1GC5az5815Ev0UKOVzTCvFSjosACxXKQGiCqv0t/TOo+YZDGcU5+Stb0Vkk76cpMWLKDfuJv5YOZY1/4KUeFGwPfIWL0j4D8t32hiYcfi+NE1+zCSl6vW5ZFjJM2Tm6sMWFajhavNbAGeJjnVc7T5nuwo1GQ9iVacCsTSwXTyiHBxmhFWFiGILpP7PnN3kqbOYHs+03UWzgKE47aRYMpowDz04LcNn5x1hb9gu9IBNCpPecNrQBTdFgWpm8QR75aZDU5/pcFqwxHSe0EFJCajeXAcrTcGCGYOixrx6j8bLL5Lx5kZCvfQhHFtpo61Zh2fVCOcWtNc1FzUfDa/pOiPtStxA43q93FIl4z6wlMgS/4GjpfKZ3fn2vTA/WBhzEiQwYq6OI98aEKA+DAjV3A+4F+i/qH5BOXdDm7hqRhCxJ6vTP9y/asKGoLyUtTu3FnmT0UsKaIOzmq7pyjbxomsS/6z/HLQytwoCA3x1TER94RKkAKFoh5dtl73MCylEQFmOzOrIAtrPKM9ANcnieaGKHQc+JEuJscjuFPWXH+XOJSskduBrd3nlv9/vpsA0YuebfQwmVkQ24UEFhmKEv5BIQmWG/UBb1meRgjjQC4t4gzjblaeBD6pfnzt+7npcyFrmEYfHJxQrc7pFZjv1/eJLI+hAEKaTuCyyxAwE5D8aJJ2QhVOoh66NBdCUJ5YwIBgn5nmDM10Ta3yFQNu+bSG9ElL7OSGUMq7T36Ys+QFeOVppEbLhVxfShYVGAFMh6p71IBBpwXMbNyxnERuo12LYpYDRm+KtSOn0PpIXU7JdOpyIzmWurNBakCN0lSlKHE7ENuhbhwC2cX3PTY17H+0ImrqHgNgcmUpKG2dQ6Uw1Bh4vviWPiWcGpnEnjwTD7qqWN
 +b8aX8vf
 yo6SRHb5DaPBnHZt/5UTdSZUzyx5+LKr2BDkYp63btU+00T/TNwzR2rmyukgLwt4nOtS5iPYAZ3JoCDz6nFEeS+Ow5WtSiNG55vrhWm9vBn9M0vPuX07aq6Uzl+YtZP2YW1cUcrxMoKjMayfTgz1MyWzbm93H/fNesyBHpSyBgp9Yp7IRFsLf35KIGC3dNPCqhh+QWntwlJnOAg4Ld+shvzOlmpOmJpVtqIsCNK1JGBFj6y/dIzGoXINs4P+3AFNKdMQVze7mcuSAIQ4YGDjiTgVzHc+ru6BKOJWsZ3x3RfpwJL9UaPy6T/D3ULuOYgg4AsvK7hiwLs1dyUY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move the overlap memmap init check from memmap_init_range() into
memmap_init().

When mirrored kernelcore is enabled, avoid memory map initialization
for overlap regions. There are two cases that may overlap: a mirror
memory region assigned to movable zone, or a non-mirror memory region
assigned to a non-movable zone but falling within the movable zone
range.

Signed-off-by: Yuan Liu <yuan1.liu@intel.com>
---
 mm/mm_init.c | 37 +++++++++++++------------------------
 1 file changed, 13 insertions(+), 24 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index df34797691bd..2b5233060504 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -797,28 +797,6 @@ void __meminit reserve_bootmem_region(phys_addr_t start,
 	}
 }
 
-/* If zone is ZONE_MOVABLE but memory is mirrored, it is an overlapped init */
-static bool __meminit
-overlap_memmap_init(unsigned long zone, unsigned long *pfn)
-{
-	static struct memblock_region *r;
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
@@ -905,8 +883,6 @@ void __meminit memmap_init_range(unsigned long size, int nid, unsigned long zone
 		 * function.  They do not exist on hotplugged memory.
 		 */
 		if (context == MEMINIT_EARLY) {
-			if (overlap_memmap_init(zone, &pfn))
-				continue;
 			if (defer_init(nid, pfn, zone_end_pfn)) {
 				deferred_struct_pages = true;
 				break;
@@ -971,6 +947,7 @@ static void __init memmap_init(void)
 
 	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid) {
 		struct pglist_data *node = NODE_DATA(nid);
+		struct memblock_region *r = &memblock.memory.regions[i];
 
 		for (j = 0; j < MAX_NR_ZONES; j++) {
 			struct zone *zone = node->node_zones + j;
@@ -978,6 +955,18 @@ static void __init memmap_init(void)
 			if (!populated_zone(zone))
 				continue;
 
+			if (mirrored_kernelcore) {
+				const bool is_mirror = memblock_is_mirror(r);
+				const bool is_movable_zone = (j == ZONE_MOVABLE);
+
+				if (is_mirror && is_movable_zone)
+					continue;
+
+				if (!is_mirror && !is_movable_zone &&
+				    start_pfn >= zone_movable_pfn[nid])
+					continue;
+			}
+
 			memmap_init_zone_range(zone, start_pfn, end_pfn,
 					       &hole_pfn);
 			zone_id = j;
-- 
2.47.3


