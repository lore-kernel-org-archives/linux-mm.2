Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2871CD59D99
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 12:07:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B4F06B0027; Mon, 15 Dec 2025 07:07:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88CEB6B002A; Mon, 15 Dec 2025 07:07:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A2F46B002B; Mon, 15 Dec 2025 07:07:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 66F206B0027
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 07:07:37 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 39200138F32
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 12:07:36 +0000 (UTC)
X-FDA: 84221580912.26.C0E89CA
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf26.hostedemail.com (Postfix) with ESMTP id 29937140008
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 12:07:33 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jWcTlPWL;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf26.hostedemail.com: domain of tianyou.li@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=tianyou.li@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765800454; a=rsa-sha256;
	cv=none;
	b=Jd0W54/H6ewNeX1p3Dgo/OincubMk8noRi+sjGLRXH0naGVbCX5gJj+Go3s0E9GiP4mkgI
	krmucHtTnLCVpG9eEG8SuPlUMR5DYyDvqlxizTNiAwDjbRu/r2qdWmbP1OuaRx11jYDw/S
	4o5tEHG3ZL7dfM5kNGoIZ2CBJocydMQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jWcTlPWL;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf26.hostedemail.com: domain of tianyou.li@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=tianyou.li@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765800454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GiES2xoF/ntKgiz7DSqRL4qPX1KqBD8hccmp1DXj2uM=;
	b=ys6wp01lCoMNrfWtBTTx9UMz+rwPYXL52lZuS/pRz3Bz8+DUlojGscJpf39FvdP4qiRTla
	DjBwQGQWOqb98eGMLF56mV0d4y3Hj/XFC92cI+osoMpijV0BdqZlv4CllDaptFEOrDCY0l
	crt+JkTTt069eRGUVAxX2I6BQOhdyME=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765800455; x=1797336455;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=X0xeLrf1TXcns3kKgLXAP+OUewmmoGYtUK735svAtxc=;
  b=jWcTlPWLAWs1ZAdeiBEM7aMn9jXYDmJ9FBLFC4YF81iK/wHmcPZoT+wG
   RV3MYkWaZf4aW+R7sfJmNas/oWCb21iibQTb3NSlKVitblYbJfnHVaGgx
   UslHO3gyl1xbnMDiaxn5j9ilRTvmVqHHFGlJK1Lw4W4faxS0g/v6Rp5gk
   ApSvEMvI6iJRBFl48rv1f7mIE/6pBVaJcR4ctVHZ6AMi/Ovo70hvwJr5B
   IKy+C92AKkNdNaPWSG2p65186xhghEb4b0o6IQzMlgbOKRV18T0EaEjWM
   zq9F97mMbpooIzxUSa9Gk4bnCgIwmc1N+vspTOe5bhglyisg3yaUy3m8B
   A==;
X-CSE-ConnectionGUID: qx0wDOcETlur2QjfIUNMuQ==
X-CSE-MsgGUID: 0doh0YhQRD2WzwKf3kDKHQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11642"; a="79154775"
X-IronPort-AV: E=Sophos;i="6.21,150,1763452800"; 
   d="scan'208";a="79154775"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2025 04:07:34 -0800
X-CSE-ConnectionGUID: J2n7uCkoRX2NsrRxNQD4YQ==
X-CSE-MsgGUID: DphniEEzSKWRj3L5PshQqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,150,1763452800"; 
   d="scan'208";a="228357219"
Received: from linux-pnp-server-27.sh.intel.com ([10.239.147.41])
  by orviesa002.jf.intel.com with ESMTP; 15 Dec 2025 04:07:30 -0800
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
Subject: [PATCH v6 2/2] mm/memory hotplug: fix zone->contiguous always false when hotplug
Date: Mon, 15 Dec 2025 21:04:37 +0800
Message-ID: <20251215130437.3914342-3-tianyou.li@intel.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20251215130437.3914342-1-tianyou.li@intel.com>
References: <20251215130437.3914342-1-tianyou.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 29937140008
X-Stat-Signature: ck1yhmbo49xdc89ngdwuefuawbaft4wn
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1765800453-776572
X-HE-Meta: U2FsdGVkX18WyT+6BuSzUbVHVAfU+d9WPmk4+BSiTNdKlgvJAE1MRJgExe4/76biiDzUEV+iZ6cdcmXWkTe/u4quN6YNLQl7wn0hNp2qX9wrqfvzVx57JR1YCmmjcnhRInT288W1ZDOaNFZymanIJwVbw9StRik5MAvNwmkbr2qq73Teq63OtMz2qrd52/foNvb/NwOO37Ty0heKT5q04IQkhvhSLiyORaT3+ySQcL5LCOfo7JcQpl3lYcDof45qn5ig5jeRWUvu9CN7s5L4dUJ5WJkHJQy5ZqlmH+Ucyp+/VKMFtEHp1Lfjliei/szcLr8r/FheLoirBFcSwLZNfVfGGwi7xBEPB2jVkmqUBgI+Gr7SBoJXpD/GaqCq6+mLuhL5ud+xxBMw1uaIKKixBXSL4Q256ulIbdGfE5lTNmVTD0aCq4neo94MLY1iDIq6L3jBfpF4nIAbsyT7jActvaFPa/PqB0+awvORlBbAbBdP2omLQKc+zYmWdqlHixp0Z/u+mVRxRq1CgFPY6p8cVuJD7kz0Y2OnPhjHNqnQCaT/MprGCH5FL5jG19ff5DQ9Kg4oUslE723QQG0k7tzQ3MBEW21x7BumGQw6OuLRsOcO/pj86a7/A275tGS9PcxBoBzA7+iFd3CluY3SJutYEel4yTYEEqFjFmHSTkp5xvxsRNymPiVyT0iwhtfA9KD5YCwme/BctLOjqHrnkw4v9H/PRqT9hPxkUquGtUFZ5AQB+4CeSeVTPkGN7rVU9+MDPHkBSjDPNQ8e+KlEGupEQAbl6eHFtyznj+azAFAeXIkukA0L0d7Itc+E1TQ4e9KP932pW21r6bgshz/fJ6YFbKTbVnhFr4PB4p4Nio3QxdP+MVX0m+ElLK1Ia+EEGEIhGR6BuPQ4sVfyPsmO6k54WVi25fK8A9oC7ke88if1BQqaM8Sw709Ru01gW3QtxsNzp2mGQSmXbQSIwY3Bfp0
 cpXf/KXj
 Dx2e29n7RNHZfHY/ByzF0IZj1/ztIH0jFgDZwz6/BY5hM3o6cDUlsQBLyL4HLkaKLoTHYglpfqsJztsg7W8RucTWQTWH7vb0gqNhLwyz82nRv335nkq5iCPFeOs+XWw0QPrmDgyphhA4DyDp8jN27/ZbQLB+zD2TtkZTWJ4xWWpEDHj4qe5SMYnlwoJ1XSUFnUNvi6Lx7dNPzj3W2cNXJzAWNxroCCl2+Tq0gjx7pW5ue/S01Zt0UCRuoPw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Yuan Liu <yuan1.liu@intel.com>

Function set_zone_contiguous used __pageblock_pfn_to_page to
check the whole pageblock is in the same zone. One assumption is
the memory section must online, otherwise the __pageblock_pfn_to_page
will return NULL, then the set_zone_contiguous will be false.
When move_pfn_range_to_zone invoked set_zone_contiguous, since the
memory section did not online, the return value will always be false.

To fix this issue, we removed the set_zone_contiguous from the
move_pfn_range_to_zone, and place it after memory section onlined.

Function remove_pfn_range_from_zone did not have this issue because
memory section remains online at the time set_zone_contiguous invoked.

Reviewed-by: Tianyou Li <tianyou.li@intel.com>
Reviewed-by: Nanhai Zou <nanhai.zou@intel.com>
Signed-off-by: Yuan Liu <yuan1.liu@intel.com>
---
 mm/memory_hotplug.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 12839032ad42..0220021f6a68 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -810,8 +810,7 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
 {
 	struct pglist_data *pgdat = zone->zone_pgdat;
 	int nid = pgdat->node_id;
-	const enum zone_contig_state new_contiguous_state =
-		zone_contig_state_after_growing(zone, start_pfn, nr_pages);
+
 	clear_zone_contiguous(zone);
 
 	if (zone_is_empty(zone))
@@ -841,8 +840,6 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
 	memmap_init_range(nr_pages, nid, zone_idx(zone), start_pfn, 0,
 			 MEMINIT_HOTPLUG, altmap, migratetype,
 			 isolate_pageblock);
-
-	set_zone_contiguous(zone, new_contiguous_state);
 }
 
 struct auto_movable_stats {
@@ -1151,6 +1148,7 @@ int mhp_init_memmap_on_memory(unsigned long pfn, unsigned long nr_pages,
 {
 	unsigned long end_pfn = pfn + nr_pages;
 	int ret, i;
+	enum zone_contig_state new_contiguous_state = ZONE_CONTIG_NO;
 
 	ret = kasan_add_zero_shadow(__va(PFN_PHYS(pfn)), PFN_PHYS(nr_pages));
 	if (ret)
@@ -1165,6 +1163,14 @@ int mhp_init_memmap_on_memory(unsigned long pfn, unsigned long nr_pages,
 	if (mhp_off_inaccessible)
 		page_init_poison(pfn_to_page(pfn), sizeof(struct page) * nr_pages);
 
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
 
@@ -1183,6 +1189,7 @@ int mhp_init_memmap_on_memory(unsigned long pfn, unsigned long nr_pages,
 	if (nr_pages >= PAGES_PER_SECTION)
 	        online_mem_sections(pfn, ALIGN_DOWN(end_pfn, PAGES_PER_SECTION));
 
+	set_zone_contiguous(zone, new_contiguous_state);
 	return ret;
 }
 
@@ -1221,6 +1228,7 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
 	};
 	const int nid = zone_to_nid(zone);
 	int need_zonelists_rebuild = 0;
+	enum zone_contig_state new_contiguous_state = ZONE_CONTIG_NO;
 	unsigned long flags;
 	int ret;
 
@@ -1235,6 +1243,7 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
 			 !IS_ALIGNED(pfn + nr_pages, PAGES_PER_SECTION)))
 		return -EINVAL;
 
+	new_contiguous_state = zone_contig_state_after_growing(zone, pfn, nr_pages);
 
 	/* associate pfn range with the zone */
 	move_pfn_range_to_zone(zone, pfn, nr_pages, NULL, MIGRATE_MOVABLE,
@@ -1273,6 +1282,7 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
 	}
 
 	online_pages_range(pfn, nr_pages);
+	set_zone_contiguous(zone, new_contiguous_state);
 	adjust_present_page_count(pfn_to_page(pfn), group, nr_pages);
 
 	if (node_arg.nid >= 0)
-- 
2.47.1


