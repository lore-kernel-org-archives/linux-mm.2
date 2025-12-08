Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B91CED3B7F3
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 14:28:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DD4A6B0008; Mon,  8 Dec 2025 09:28:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B4526B000A; Mon,  8 Dec 2025 09:28:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CA3B6B000C; Mon,  8 Dec 2025 09:28:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0E5226B0008
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 09:28:32 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9FE07B63B3
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 14:28:31 +0000 (UTC)
X-FDA: 84196534422.18.7458FA0
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf08.hostedemail.com (Postfix) with ESMTP id 82A8C160015
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 14:28:29 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Gc2QFgSm;
	spf=pass (imf08.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765204109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+RggYbgSv/NY9CU2NZbrIL57PA1NIUo1AA41nhFrrsc=;
	b=fRQyq4YR+XIvRCx4Gs2hl0Fp6jXLOxuCDccLN8x7GMgNA06xcV4/W5vGcKRoCLzL0BxKrJ
	IhiE9d1wmMXksLt5yWtPomDiSL7ozCkNxiF1BUeDBpFhRDlfOcXXd9YcGeX/C4WpQDkBWV
	RDajfAdtxobsBmRpxG+DlfJC4B6CJSY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Gc2QFgSm;
	spf=pass (imf08.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765204109; a=rsa-sha256;
	cv=none;
	b=ZU4ZEZ4Tt/QqpM36tcyjXDKBibM2rC0/ifZgEJD2SOnOe1e9+1HgYEZqUwoc9QWrcIhW2P
	YadYIAMlQz5CVVVB7OUEAtZa+TFAr9EX6cLV8PR5fs0G6lMmBDcYJezk1zIyY7Lc8uNX5Z
	EUZLv8wn5oxh2AfxJF7tzbGQtrytn7w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765204109; x=1796740109;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/fQGvXBGLr7zSEqagmAWMLnNuEXBlmlyD9qytz8sS1w=;
  b=Gc2QFgSmDkE89choPeMpUTzdFwOe5ZRz1ZM94or5QjdtzO18SrD1qLpC
   78H0/rcK7XYQ87Zme3c5CbOc/U8j/k+KI23Qz0QjuDqfpkhV7fuPhM97w
   p4ukJVFInS5AHQVc0MgtzqDFSXPPhGqgLQt/GgqzJTZIef5HS7j0+gLkc
   hzUbdWTmNoTxxFJHrW3zeArV6Q0Uy+HkO1E3XLV+FJ7QVMK7+hNm7Yam8
   nUHCqzBPnafIAj+qMmcBJzkMqW4+f0kSmy/dzUN536BrdH85omd6vbgpm
   5Cs+5EA8GCmq710914N2gNvJEk4ZAJJMLe849Jm91zwmiHh3vTpHlUlqY
   A==;
X-CSE-ConnectionGUID: T1cpvAsPSgakcIgjtTZE8Q==
X-CSE-MsgGUID: ALlPuVyITU2eCG9ydDlqjg==
X-IronPort-AV: E=McAfee;i="6800,10657,11636"; a="67181557"
X-IronPort-AV: E=Sophos;i="6.20,258,1758610800"; 
   d="scan'208";a="67181557"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 06:28:28 -0800
X-CSE-ConnectionGUID: TtX4Sfj+TC+R+w5MLaTyPQ==
X-CSE-MsgGUID: 2KxPqU4mQFSQ0Oq25J6Z3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,258,1758610800"; 
   d="scan'208";a="233317824"
Received: from linux-pnp-server-27.sh.intel.com ([10.239.147.41])
  by orviesa001.jf.intel.com with ESMTP; 08 Dec 2025 06:28:25 -0800
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
Subject: [PATCH v5 2/2] mm/memory hotplug: fix zone->contiguous always false when hotplug
Date: Mon,  8 Dec 2025 23:25:44 +0800
Message-ID: <20251208152544.1150732-3-tianyou.li@intel.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20251208152544.1150732-1-tianyou.li@intel.com>
References: <20251208152544.1150732-1-tianyou.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: s8tsdc7gmgxqakkuqhwpoy9h7pc1dyh5
X-Rspamd-Queue-Id: 82A8C160015
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1765204109-986553
X-HE-Meta: U2FsdGVkX18Sve2M1TlUR3a6EL10a/VoR3wt4lhshPn08LwRvS4+Kldw4UjX3zFukgz1D5HRqN60cD/Ia/U115YrMoiJ2WvXVkah67YuhpLQYbm+ihfDO4+Z6p4xCfhGS+WaYAmtpZuiAjOc+gzVKUukZb4V0+v+B6msyBxaxuOOIj9RU1Jpumb2tXGL47mLlnRJWodJWmHTeQd7lhZOyiSBo2c0+/6qjNkYPWjb025xntx39zRablvO7ZBVc0259TS/lPF30Dy/p6pbgYIeyRn+BYZYS2375n/8vRBiuAm0ZEGxT304MFeyp//ulZ+1gr86u+ui0UK7Ud62Mn/pjw7Wfgv/4uBtEBUMHNuQKzui/P7IoXBN2itaDdlNCUfUfcNQCNwJj/lkEGaXbqg1k/zbRCAPUOuDfuWc+9+2lth4qtjVy2saF54lTC2KfjQRjDTAcm7lkHei3dhj4JHrReYysh2IJ17CHln/bRueGNA3FM+qInHM1hogJo7e4zj1+5T7RyDGQq3nYvlUadlNWRcb6/hEyTIkH8E1PUbqI4P61Ftf9tIk2bjgApZPh4MxRMIECm45zXMt3ZqZRVLFT64aBLrggtpF7kpXckYzOyoKG+qck+k1Dz6dy+1iULSdfAmNYdwvs4LZSi6x1e0/hhg/5EQRxrLa60aF6ReAVEW0eyGCJil33c2j5apvLmRE3msBB6bictmLM5e8Li+xuBI91Pf8bSON+oZDTxB5IY94TtLeJduuro91tIkP3QlqMAHW6q4syYxORwooD87ja62afi6AHl1GPIGM1cStiWsBlvVPFiThnJCE/AmlkNYlI88oNhvXiW20hoYrntcb0ZkGHyqBJo/iSC7Xe/3A17tCPrkLsC5Gm1smf1cktfRU/Z2rRWDfJF0Cj7FuvZa/iTiWx3yLeZ1guR+ErGqEiKFBHIqeOyl1tzpgLqTIxoENkk1CMa5hsY+mhCRkepC
 pz8uyIK5
 Ezifrmrnii3BAW7oJLLscUqu0AhBIqylx7JRRrMfmO4IthTRqHxsMjsk+fWZJHq74U5Hy4/FJdNjzdv//v/xS54QyA+rfdpIhwIsrU3lECtTI/EF6a/HxQhox7ntk8fj2HNNJQJ4piGnjHlmmciAUwofKKgUPnGLAELUi21eovp1V/Icht491BO0Cy8cqIWS4Wqa6o0kfQETG4ucXk/zVbeq3nQrAnpGiSUNEAfUjKjyq3I2rbNUobUehSQ==
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
 mm/memory_hotplug.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index d711f6e2c87f..f548d9180415 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -809,8 +809,7 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
 {
 	struct pglist_data *pgdat = zone->zone_pgdat;
 	int nid = pgdat->node_id;
-	const enum zone_contig_state contiguous_state =
-		zone_contig_state_after_growing(zone, start_pfn, nr_pages);
+
 	clear_zone_contiguous(zone);
 
 	if (zone_is_empty(zone))
@@ -840,8 +839,6 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
 	memmap_init_range(nr_pages, nid, zone_idx(zone), start_pfn, 0,
 			 MEMINIT_HOTPLUG, altmap, migratetype,
 			 isolate_pageblock);
-
-	set_zone_contiguous(zone, contiguous_state);
 }
 
 struct auto_movable_stats {
@@ -1150,6 +1147,7 @@ int mhp_init_memmap_on_memory(unsigned long pfn, unsigned long nr_pages,
 {
 	unsigned long end_pfn = pfn + nr_pages;
 	int ret, i;
+	enum zone_contig_state contiguous_state = ZONE_CONTIG_NO;
 
 	ret = kasan_add_zero_shadow(__va(PFN_PHYS(pfn)), PFN_PHYS(nr_pages));
 	if (ret)
@@ -1164,6 +1162,10 @@ int mhp_init_memmap_on_memory(unsigned long pfn, unsigned long nr_pages,
 	if (mhp_off_inaccessible)
 		page_init_poison(pfn_to_page(pfn), sizeof(struct page) * nr_pages);
 
+	if (IS_ALIGNED(end_pfn, PAGES_PER_SECTION))
+		contiguous_state = zone_contig_state_after_growing(zone, pfn,
+								   nr_pages);
+
 	move_pfn_range_to_zone(zone, pfn, nr_pages, NULL, MIGRATE_UNMOVABLE,
 			       false);
 
@@ -1182,6 +1184,7 @@ int mhp_init_memmap_on_memory(unsigned long pfn, unsigned long nr_pages,
 	if (nr_pages >= PAGES_PER_SECTION)
 	        online_mem_sections(pfn, ALIGN_DOWN(end_pfn, PAGES_PER_SECTION));
 
+	set_zone_contiguous(zone, contiguous_state);
 	return ret;
 }
 
@@ -1220,6 +1223,7 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
 	};
 	const int nid = zone_to_nid(zone);
 	int need_zonelists_rebuild = 0;
+	enum zone_contig_state contiguous_state = ZONE_CONTIG_NO;
 	unsigned long flags;
 	int ret;
 
@@ -1234,6 +1238,7 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
 			 !IS_ALIGNED(pfn + nr_pages, PAGES_PER_SECTION)))
 		return -EINVAL;
 
+	contiguous_state = zone_contig_state_after_growing(zone, pfn, nr_pages);
 
 	/* associate pfn range with the zone */
 	move_pfn_range_to_zone(zone, pfn, nr_pages, NULL, MIGRATE_MOVABLE,
@@ -1272,6 +1277,7 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
 	}
 
 	online_pages_range(pfn, nr_pages);
+	set_zone_contiguous(zone, contiguous_state);
 	adjust_present_page_count(pfn_to_page(pfn), group, nr_pages);
 
 	if (node_arg.nid >= 0)
-- 
2.47.1


