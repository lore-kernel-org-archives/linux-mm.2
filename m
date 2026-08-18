Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82CB5C5DF7E
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 11:44:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 930196B0182; Tue, 18 Aug 2026 07:44:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E1336B0185; Tue, 18 Aug 2026 07:44:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81DAA6B0186; Tue, 18 Aug 2026 07:44:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 616866B0182
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 07:44:35 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 66A66A3676
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 11:44:33 +0000 (UTC)
X-FDA: 85114207626.18.1490BE5
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	by imf18.hostedemail.com (Postfix) with ESMTP id E2E261C0004
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 11:44:28 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="b/+OOCV0";
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf18.hostedemail.com: domain of xiqi2@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=xiqi2@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787053471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=yXfHL44eCUMFCHve4lXyhhgcYfqAVccG0nG6arA10Ng=;
	b=Zs2Yqc/zOrOXLM8jE9pDe9iZEWlCxhDEGfUbOvHprYAus9Y9nybKpU+SDmvZKjUYVFiNRD
	QQAhx4tHJXkAAHIdO8ybfBGwNZKS64MECd2vbp3QGMkjJdwh1lK8+3T5yZbP4QsglBV2Rc
	wbV7zMPS+zRFyQL2FNAq5UhWuwwnfkU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="b/+OOCV0";
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf18.hostedemail.com: domain of xiqi2@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=xiqi2@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787053471;
	b=0cMw1ODV3uRvQbba4CL3i0sEZ8YUdjIK1MLxOm8ZF9qHCBmNfgssUT2PywwEi+bkk/TZ87
	cpEQiZXVUTiKfXgFc4rhphaQgz9Udae/rPjSeYn957oijnghJYivXaO6UeicKV83FnXF1e
	nZ3FbatAqDulP77oba1lxNQwr802K14=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=yXfHL44eCUMFCHve4lXyhhgcYfqAVccG0nG6arA10Ng=;
	b=b/+OOCV0NyCVdVuVlkR3i/mf2U+JUfM7eohksm2/7DExBKsnjYUWUl1umIf+rpr2meV7qlZ4H
	oroOF4MoEC+s69bNQy1gZ0efeIrrHPTp1au3gLPpw2qs8qi2cdtm6no10+Urp0XgitAUr/Pk4uQ
	GARKNWhYd9hRojcwdACHzgE=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hPSJr1SkDznTbN;
	Tue, 18 Aug 2026 19:34:04 +0800 (CST)
Received: from kwepemo200010.china.huawei.com (unknown [7.202.195.178])
	by mail.maildlp.com (Postfix) with ESMTPS id 3278040578;
	Tue, 18 Aug 2026 19:44:23 +0800 (CST)
Received: from huawei.com (10.44.142.85) by kwepemo200010.china.huawei.com
 (7.202.195.178) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 18 Aug
 2026 19:44:22 +0800
From: Qi Xi <xiqi2@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka
	<vbabka@kernel.org>
CC: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner
	<hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <sunnanyong@huawei.com>,
	<wangkefeng.wang@huawei.com>, <xiqi2@huawei.com>
Subject: [PATCH] mm/page_isolation: fix UBSAN shift-out-of-bounds warning
Date: Tue, 18 Aug 2026 19:28:55 +0800
Message-ID: <20260818112855.3831692-1-xiqi2@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.44.142.85]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemo200010.china.huawei.com (7.202.195.178)
X-Rspamd-Queue-Id: E2E261C0004
X-Stat-Signature: c6aboxq5bzegst3x8zqr3tar5tn5mgpg
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787053468-383056
X-HE-Meta: U2FsdGVkX18+r/g4PthoerZ7K6ZlhlRu2iCCIEGP+RuUPTRcmNEznYYy01VPrcfeMfOkbySVUlPWLFHxJay137IM3J4ddEnNxxDOIhR0tO1QY7evvgPNIv6TqSb38lCCk02kjTdIW5Gk4ZuExizc570VWKUyczLd0VW+nvEcPzFcMNWLFZCGEa2heERpwrzx2VpTMhDcgE2x9t8FGVv9NHwV+IMxBzj4EEh2c5qvHQyxybgnVpzGZFeQ4YqDLGabMq73bKJaqPj7HA0+ekWGpnS91dcHSXyPDMI9CHPIk95tV5ojXrlixod0grfyW52S7eTVjYWoN6tkNSuV/cM0UXMVeg2LlBX3syxNYOU+hrPgrPzB/tsJ0v4LjRHD/qdfFrePoxm6e4cfhMQ0XdOT2JUihMO7N/rbbRjv4iO7fJQUMAjvUrQFUJpHO0MoyZ4zAJi0z+psnn/XwMX0zWB0wRRr3cySZJ6CAuVHwzTaioEKWDWqSmIe4ELEryPkibUvs3kGlf1V9PXNDEfd3FVEd64eR+ckQ9OIR03VW+4M79j6ODb//srqMlRcfH26ASqdz44TSfLuZKY+1uzLvfOW0ZhlA88MZUtS+n4tPTrHxXbVehYMh4/cUp4ZDCsNmZYfzroMk8w3dIU6oU71Ke0EdoH8fDcJIrekWbR4ujgOPVnwRoRBfwMXfx1n8N6DDWmE6Lp+zGTWvS+dFjE/yipdEXE9Vezseb0YPK1HQcRSQ1/7T00O0zKV6wIhDbxUGcSKn98G/+eJCtuigG34Opvj9WCn9PhgBX+ZJEJBz2zro0cmtWypMY0MH0rVDC7jGCbIzZaeZLkIeBRj/X+jXoXSEvpV6slAWVGPkKPcsN6UgY/i8qHVxvvfTiEDWUSH05Jscefk8vG3pQlSTMhQ/8NiCFJM+12p4ASVcv8zNhCnqN3kXMGryef2CDcocZVyqxZtCPMVKIZjY8BTormsWc/
 VCtiuR+l
 VZGzyjY/2wwQ3IfAf6QMfn00bwAn26L1AKpDIWjDuEVb3c2jMzQq7SG+H6k1psq45HvMTOozbopx6KGecg2v0NbEpKlT2hbVGtV2lRezHgwDBTjcFY4D33c63DyykGq/F14I+0RTlSGmLiTYsfdinrXXFkJX6IO5QC2HXv+QXn7MzEu+nCDye58trZLQfPYBWgmtm7lUhBl4dXZ/SprCG7pEodP/zTk8ZkCosHmcGmvejZ7qeYfHUjwFJd2h1bfCeHXOTICczmEviVyYLrNKNeEyxQTJzdx/W1H4Cb9TA05ltF5bq4tnlffmKIDLDY3Hmxl7W0tv6JUNo0xcIjLi2pnLXxI51A870msWSD6y0mL/R4ZI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A contig-range allocation racing with buddy allocation on the adjacent
pageblock can trigger:

 UBSAN: shift-out-of-bounds in mm/page_isolation.c:393:15
 shift exponent -749042176 is negative
 Call trace:
  isolate_single_pageblock
  start_isolate_page_range
  alloc_contig_frozen_range_noprof
  alloc_contig_range_noprof

isolate_single_pageblock() first calls set_migratetype_isolate() with
zone->lock held, which marks the pageblock MIGRATE_ISOLATE and moves any
free page straddling the boundary out of the way.  Once the lock is
dropped, it scans the MAX_ORDER_NR_PAGES-aligned window [start_pfn,
boundary_pfn) locklessly, only to skip the free pages already handled
above and to detect in-use pages straddling the boundary.  Since this
scan only reads page state to decide how far to skip and returns -EBUSY
on a straddling in-use page, it does not take the lock.

The window also covers the adjacent pageblock, whose free pages stay on
the normal movable/CMA freelist and can be allocated concurrently.  So
after the scan observes PageBuddy(page), another CPU can allocate the
page, leaving a stale value in page->private that makes "1 << order" shift
out of range.

Use buddy_order_unsafe() to read the order exactly once (READ_ONCE), and
guard the shift with an order <= MAX_PAGE_ORDER check so it is never
performed with a bogus value.

Fixes: b2c9e2fbba32 ("mm: make alloc_contig_range work at pageblock granularity")
Signed-off-by: Qi Xi <xiqi2@huawei.com>
---
 mm/page_isolation.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/mm/page_isolation.c b/mm/page_isolation.c
index 32ce8a7d9df3..8aa096f1754d 100644
--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -387,13 +387,16 @@ static int isolate_single_pageblock(unsigned long boundary_pfn,
 		}
 
 		if (PageBuddy(page)) {
-			int order = buddy_order(page);
+			unsigned int order;
 
-			/* pageblock_isolate_and_move_free_pages() handled this */
-			VM_WARN_ON_ONCE(pfn + (1 << order) > boundary_pfn);
+			order = buddy_order_unsafe(page);
+			if (likely(order <= MAX_PAGE_ORDER)) {
+				/* pageblock_isolate_and_move_free_pages() handled this */
+				VM_WARN_ON_ONCE(pfn + (1 << order) > boundary_pfn);
 
-			pfn += 1UL << order;
-			continue;
+				pfn += 1UL << order;
+				continue;
+			}
 		}
 
 		/*
-- 
2.33.0


