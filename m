Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90F4BE674B2
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 13:59:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05EA56B0089; Mon, 22 Dec 2025 08:59:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01C3C6B008A; Mon, 22 Dec 2025 08:59:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E97D76B008C; Mon, 22 Dec 2025 08:59:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D82F06B0089
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 08:59:53 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7EA46140188
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 13:59:53 +0000 (UTC)
X-FDA: 84247265466.28.8B6103F
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf21.hostedemail.com (Postfix) with ESMTP id 67BA31C000F
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 13:59:51 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=eqt6iC6X;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf21.hostedemail.com: domain of tianyou.li@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=tianyou.li@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766411991; a=rsa-sha256;
	cv=none;
	b=hK6Ij33N9zzRaKsTUhH/dcOet8EC3cdS3yOck3gNKYs6esMNfUrXKj+OHdNhcbz2CiNCLT
	e4vtFwl7YwxpHS5pObNKYwNpGAVU5LUg/PtEUtwjyign2UvnjIoNxNzjo0vm528uIzuxRt
	WOGFyXeYgNQlxB7YDZIXWCZaXYaFiy4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=eqt6iC6X;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf21.hostedemail.com: domain of tianyou.li@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=tianyou.li@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766411991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RNnavlKCtPItrEpuBnWrZFfsybfLa22IYlMNZ+OjLyE=;
	b=7eNgwhm5oidSmQDqYJ2cQIXn4G+ypK001RTl7i/S2nboumq87Xi42NShA2icSEykc7yxM8
	dxL5WdSvaUXvfqn08O6cjMHl+e8S8mE0VMTPqx5l7Pxi6a3G2XhOAx5JQNfclYaJ7j+bav
	vOiEX5F+i9ZHFfw2djDHBNSh+CGUf4k=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766411992; x=1797947992;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8ZfPW8FLfn5108gLlzBjYP1a7U55zV4LZPgYpJMp4sM=;
  b=eqt6iC6XQgjcpzGT67oFl5k+0Qxa/W3NZzN8vEHKi7SVS9aVCevCTw5T
   aYwiyv62neCFDgo8r2hudeFI4Kc2I+M3h/OPqjsOsGHOU45T7fe88ClCM
   /5Zhqb5vz5xzP0EudKjqW67DspdqG9vQivr7Q4D+5mvCVyuNKD5XhK6iu
   4enaOs8wwaXbJCe3dy6YZlmpGWVX5izmajxb+ukd96HIrDsJKfUnx5Wcg
   D3NeAXB3w6MU6z/1NWaAqDQgqAopUDoe2n9TNw6xLIDWSwJyxaGA83pzN
   ZBtsl7Pr2C6Lqr6sBE7NvSLJIiaKDy4ysy5cGY96k2REIkqxoxlt9Q83j
   A==;
X-CSE-ConnectionGUID: ta/NstPETr+lbw0HLsTiPw==
X-CSE-MsgGUID: vXJ3yGDZQNCepu9svV69Lg==
X-IronPort-AV: E=McAfee;i="6800,10657,11650"; a="68248530"
X-IronPort-AV: E=Sophos;i="6.21,168,1763452800"; 
   d="scan'208";a="68248530"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2025 05:59:51 -0800
X-CSE-ConnectionGUID: +3QTUcGgRp6cLKlkaopwTg==
X-CSE-MsgGUID: 6+XTCocSTvKH5wkIhm219A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,168,1763452800"; 
   d="scan'208";a="230189558"
Received: from linux-pnp-server-27.sh.intel.com ([10.239.147.41])
  by orviesa002.jf.intel.com with ESMTP; 22 Dec 2025 05:59:46 -0800
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
Subject: [PATCH v7 1/2] mm/memory hotplug: fix zone->contiguous always false when hotplug
Date: Mon, 22 Dec 2025 22:58:06 +0800
Message-ID: <20251222145807.11351-2-tianyou.li@intel.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20251222145807.11351-1-tianyou.li@intel.com>
References: <20251222145807.11351-1-tianyou.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 67BA31C000F
X-Stat-Signature: 1rdz1xx5osajyksobcgynh7qkby7bc5c
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766411991-636385
X-HE-Meta: U2FsdGVkX1++CqxGC1w10gQWalQNQzkUpJm31Y3wd1CDnDWn1fFceadE0H0nPdraK7bj3v9HklpD7EFanUo0at8mn0gU+3lune22B3Z/whnLS2tE0USlXhgSLnBB8Vb+j3ecjNRHW3scQY7tk9hTA9f7SahOh66DZyLHzfFv0lyicmoR3s7P4n0qPRnJIKbYKcGRbcOzxvSUofx3y01yWoxzWTPJsW3kw/b7iRIq/PRz4LPFWLmGfnxjPtRbP7zGHURkj+iqBT4lz/+wrqd4dgDLLP+o8h8n+2l1pZC4sh7fWzyJtYOHDXFraEYm1Z5y5ak8pmgnzOzcFmd2bHlqFyCzeSyLURkQy47w2ozj9LBXzVQ9Db2CmQ0b0U3q63P3ucFvkbP8PT+wJJXdKlDbWGLk4cPy/ccSC3ox+PtpjUONCzI2W5j8Wh6h6vE8gNpcwdDE5A21qAWiDzlC5/88huwJ9nDSNqGrHuqXJ2RRL13xJLVyTkSaB2FuLqr4Is/qR2x3VVRYGtQAsJqv5kCstX0v0iBCY8EAj6NQnWmNG5OJQhvjwh8e4VbnZXrRFTUxq/KsU/a1vdcPirN+ZvGSovwk6le0zssvxL10GTTj3C72UhPskV0VC1/J75fQD6wdfWw39GUl0G3aia+Qwcn1zIYO8HVZHr41102bs4LqP+I92Wy3kbDHLN4nC+Q6O6B/Mow/2Pe1mHEb6Vs5MfoGbgxetDRu0rgMhztOD0yUyQKGQE0pD2UoQOGEiXT7zGCFCbNlMpsplbylIuOTYCv2lIVc165qZEo2ibp7KQQlDgroUN5xg18zyuqjSE88tZnpg8TpR1P1zpUdTsQvjG7FJ8WT1CfpGsyIe1trC+FtvkUJ079zbQ/SP8/06f8ZOe57m7xwJePDreW7jet1tHnDESYaxKiXrK5kabsdLdjyXISQ5h6m3gDNdrDwiqhcp31jlS0eGklJM4MYh3kdNUQ
 4fxlS/T3
 IcUov988nkurX7l8DhJrydu85eWi9wXDqnXe2UDX9LyvazVdNHVBE3GKQ6NbBELKuqvGX2oTobtUMikPwz2NIMdtO8edn57J9rm8OEEEBxH21bdYWzqNhNoiryLC8gyAQUgGs7sDwAMKW1MHrJQbA4znu4+miNp2/xIBCoHfJDQZpMl7Eqxu0HpeN4RYocU9U7gAcDMjS/DLEk1YylBsUJfqlOGeXM9DWzpqgVD4JlTN4xZLHkHV3Vd0FjA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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

Reviewed-by: Nanhai Zou <nanhai.zou@intel.com>
Signed-off-by: Yuan Liu <yuan1.liu@intel.com>
Signed-off-by: Tianyou Li <tianyou.li@intel.com>
---
 mm/memory_hotplug.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index a63ec679d861..ce6caf8674a5 100644
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
@@ -1115,6 +1113,7 @@ int mhp_init_memmap_on_memory(unsigned long pfn, unsigned long nr_pages,
 	if (nr_pages >= PAGES_PER_SECTION)
 	        online_mem_sections(pfn, ALIGN_DOWN(end_pfn, PAGES_PER_SECTION));
 
+	set_zone_contiguous(zone);
 	return ret;
 }
 
@@ -1205,6 +1204,7 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
 	}
 
 	online_pages_range(pfn, nr_pages);
+	set_zone_contiguous(zone);
 	adjust_present_page_count(pfn_to_page(pfn), group, nr_pages);
 
 	if (node_arg.nid >= 0)
-- 
2.47.1


