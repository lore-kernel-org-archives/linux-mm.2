Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4C45CA1010
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 14:04:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12B708E0005; Fri,  5 Sep 2025 10:04:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 103AC8E0003; Fri,  5 Sep 2025 10:04:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 018BC8E0005; Fri,  5 Sep 2025 10:04:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DF9D28E0003
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 10:04:14 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8708E139FED
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 14:04:14 +0000 (UTC)
X-FDA: 83855366028.04.B34C472
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf23.hostedemail.com (Postfix) with ESMTP id F20FB140002
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 14:04:12 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="k/nKj3Ew";
	spf=pass (imf23.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757081053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=T3nUGVasVr9vweRN8CMdQ24qkdI2jYVSOynxcLsSz3o=;
	b=VDM2LE6exjJmGTZHL613lObTbQxE6GFHev+wDXmQcringcpuoJ2h1g6uySMPVBsJ/XcbQ0
	gC4UfyoEmJ5k86fU+LklUKRJl1i3YzHVKBMlTogey3OY+IMrrrYnu05JrEIPTByqMwDwIL
	Yp4GC1yIFGr+t/mg0CHr+vld9Rrbuzo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="k/nKj3Ew";
	spf=pass (imf23.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757081053; a=rsa-sha256;
	cv=none;
	b=Cu+lyIyW6adVl/TazbXwnAorRIUox604Pb5S+dKBJHZqK0BMuSNAlPFW5+/DKePeip4uwP
	gKHG1/4U7cydpcXIJ0Qlzah4lW78lLAURQay44A31Ag78xmMtc3E8/Ry7Hm0GoGLLNV3Hn
	yuEVDR8wyQpBWpRK3q3Tu5VqGpwXyF0=
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b04679375f6so365942966b.2
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 07:04:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757081051; x=1757685851; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T3nUGVasVr9vweRN8CMdQ24qkdI2jYVSOynxcLsSz3o=;
        b=k/nKj3EwXYJpB3AUNpxdNvjUj8OvaMjD1B5W8ew2pFdUSS4BORIrXtoVVbS8z0XOUJ
         /lMXOEYNdHGyGhSYn9lh3DJsPAIX9K4XCBXXqO6qwHARS5tvmfavSAZ2ou5XXfu56EaW
         khVJ45iy301bU2DRenGaCmezY1B4QpVndvtMUjrqulApIs0+MsI5oYrvLsqsU0CoSwmw
         0QJThtp7b9uw5DvkN2j5aRXDt1LFwkQ4msY8lSMa9j2ntl1gvXhAJk+U2cHGyVwgzJv0
         1mLKXgo+klTFI64SBCXGxRvvDRJtmCf5TJ3Fuj/Lq3tdP3mH3VtRg+O7KlexAsZrjHw0
         vk9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757081051; x=1757685851;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T3nUGVasVr9vweRN8CMdQ24qkdI2jYVSOynxcLsSz3o=;
        b=crrNYANzYjT9svzcJlCTHbp31r8n+863jwf+SsbrC62+SLYGgGEq08uyELMJN6aJ76
         uA4fJx3wb7i8cXSKskBQr6AS0fujWTH87uq/M6ALWfoxTUcRXfUtV9ORcqMqhner8vXf
         p5wdzAD3X0EdO/kHp99ccNSYmLTLkXRnqY2R5eoh9dmkFTmV0cqTGrmrsFezFbM/xssv
         f5JiNTWObQTR0rDw+l64xRA22q3aYRv3j5po9NUzUnjgTlB9lQGgWAVru6RLSDFlLAp7
         i8mO6Xtpihr+2U9n10/vaQIiz+kMdpkGUAQ/Zbv6enRCgbzqojvi2qcYLcCHVU1bQTQq
         filA==
X-Gm-Message-State: AOJu0Yz8RJvPX74p0ojp1jZL1wkBpYN5hGadOah0i249FmdldEx3uMc4
	LA+GZwvjNkdBHyBbkAU6IhDFulJnghC9JZrnKd9JvViOR6v0gUDREUvWiQPs8Q==
X-Gm-Gg: ASbGnctiTu/ZnrpX1m8QRxBL2GcYJ7xjTCEsikhQe49dWQHx7ZWmrWzRbOaK7ipsh2p
	Dj1FAap1GMzuqZMVcMTcQQGAutPCP+OdDGBjjKKd1dkl71Na1rRWoj9Tcj7VgSN0Agw2EBDuv1E
	QfgCM/ARncCxWtLC5PzuSJQ8Uts9hI4QYUnq2OP80DLHGTNt+bRFJEn1q+6LFxBcAQWDyoZrAEz
	99YKQunNqxspoYu/TQC+eTn1x0rRYTan4W8vfTB3ReIwAr6nJcvtEQG7YtdPYkWYlnqw1o7FN6P
	Ps8XPVYBwCT2386RBlw/3734MgZLF5a7oYoc7KR59Sex8GDDgZ5PUNW6+F6rE8TWtyz95UFmZpS
	6XfjWOY7Sk5vuTR686Ev9CwvQ+LmLXZmL+zeU
X-Google-Smtp-Source: AGHT+IFNG2k/NpGP4kzvCu8T1J9Gj5Tb93hLEzJ4cDQoy/ZanyU9IKxWtJUMxykvv+2uhxiZOOW0VQ==
X-Received: by 2002:a17:907:a0c8:b0:b04:3513:5138 with SMTP id a640c23a62f3a-b0435137355mr1763996366b.41.1757081050986;
        Fri, 05 Sep 2025 07:04:10 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61cfc4bbc07sm17051606a12.30.2025.09.05.07.04.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 05 Sep 2025 07:04:10 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@redhat.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [Patch v2] mm/page_alloc: check the correct buddy if it is a starting block
Date: Fri,  5 Sep 2025 14:03:58 +0000
Message-Id: <20250905140358.28849-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Rspamd-Queue-Id: F20FB140002
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 1uszhwp19qt9wudn59t8ooipr9fnptke
X-HE-Tag: 1757081052-777514
X-HE-Meta: U2FsdGVkX18JPyEKSnbzzaN6+lrmsrZ0FWM1/3dNnnFSiKGS+3aXmZp0dZ5DKtXFhWG74yyPiyHV+f0qs2jPXjn5oJPdBVSGhBEzNFVvgq8oNrN3KbmMFOVzJlWU/+PU0uBwIK3AFIOxVB8Kb96yCLzAJ649F/SLaSvqOl9BwG6pce9U7thwF2p39bbB+WZr7vN+1CYkKitY7tUmrMDS6cvXmDk+mMIEMt6Ucvb8MJCTfJxL1gt1k4+mt026PjTKsCALilDTsJSwc9AifJS+I/bkBJekZG0TZ/nzmo5WvN7m36i03EEHaHVLbeC8pbjLCyLaythxxLWmhrYe+CVze76F+a/LfzKYsurUhDrgVebhm84xqWqGwrs3reVcOJnMCYR7M+XLNbfWgYUDntFtybJ4HaRm/BVZYThdZaEFVAX9pD82iYHBqGegAIl6Nz4e+EhQfCoiblggLZj0jUHAmbRSOS5jxj9NHjEjpUZ7GYYC/ddR6VOWFKAB55tAmnoeu0nS6Nh4izykXqBlyBOvZdfpiF6NItoRPccRBLUwe+D/5DZbcD4hU/cwyP9iOCbJ3pprkBYxkm+0y4TPGOWxfdmazpfZE8CrGPxYhLV0NbbiojkgmnBV2MxE/N5bugPY8Sp5A1kpRqpoJa6qqzXEevMSpPf/kgVrf8tzYB/6oX/P9kMWr980aDHLb6tU0q7m8QRWT7CU11qJ7iude3CNpngkQ5RrT+6ZNERgxtkwFCKft8GEI2SbT9/dg+vppC4FPND+qhIz328D5QU3/RVxkSWuE6fa1ltrrlQABxa0L6lWKKNCrC6cB5+KdgfjhadDmfjMaBXfDUIlFgKMhwyNw0ls5Zf+dPCa4O36albi4C1v5JHI/ian8iJFG+k5Ed+qGopJ48f4Kgk1XsTyZJLt9ujEhx40kREOlFytH0oBD2qBctj2hChcQ4MskmJqO2YQeDSUHtenUUzl1Z01+li
 2mYXlXx8
 CpLYgfXw25I1bsfI0eAwQnlBBrjBRSrLtjIoWGmwYjthUFroeBEp4nHe+sYyLhXd8VA6bVGpvHsC2nc6UR2PSO2Kg8gu9dDJ/hs2I4GF/zKGMy6DaIR+dEvz9gdDfYBdSzRY8zqIZh2iMOHaz5f8IAvFmKuQeUnVoWAch02bXgOaSMnIEBc+uuJPkXPphsazgvSu+e6Xl9je5zz0+kzt+1/U96g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

find_large_buddy() search buddy based on start_pfn, which maybe
different from page's pfn, e.g. when page is not pageblock aligned,
because prep_move_freepages_block() always align start_pfn to pageblock.

This means when we found a starting block at start_pfn, it may check
on the wrong page theoretically. And not split the free page as it is
supposed to, causing a freelist migratetype mismatch.

The good news is the page passed to __move_freepages_block_isolate() has
only two possible cases:

  * page is pageblock aligned
  * page is __first_valid_page() of this block

So it is safe for the first case, and it won't get a buddy larger than
pageblock for the second case.

To fix the issue, check the returned pfn of find_large_buddy() to decide
whether to split the free page:

  1. if it is not a PageBuddy pfn, no split;
  2. if it is a PageBuddy pfn but order <= pageblock_order, no split;
  3. if it is a PageBuddy pfn with order > pageblock_order, start_pfn is
     either in the starting block or tail block, split the PageBuddy at
     pageblock_order level.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Zi Yan <ziy@nvidia.com>

---
v2:
  * adjust changelog per ZiYan's comment
  * rename pfn to buddy_pfn
---
 mm/page_alloc.c | 25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index db3d902c4be0..c8ce46d0909a 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2090,9 +2090,10 @@ static inline void toggle_pageblock_isolate(struct page *page, bool isolate)
 static bool __move_freepages_block_isolate(struct zone *zone,
 		struct page *page, bool isolate)
 {
-	unsigned long start_pfn, pfn;
+	unsigned long start_pfn, buddy_pfn;
 	int from_mt;
 	int to_mt;
+	struct page *buddy;
 
 	if (isolate == get_pageblock_isolate(page)) {
 		VM_WARN_ONCE(1, "%s a pageblock that is already in that state",
@@ -2107,29 +2108,19 @@ static bool __move_freepages_block_isolate(struct zone *zone,
 	if (pageblock_order == MAX_PAGE_ORDER)
 		goto move;
 
-	/* We're a tail block in a larger buddy */
-	pfn = find_large_buddy(start_pfn);
-	if (pfn != start_pfn) {
-		struct page *buddy = pfn_to_page(pfn);
+	buddy_pfn = find_large_buddy(start_pfn);
+	buddy = pfn_to_page(buddy_pfn);
+	/* We're a part of a larger buddy */
+	if (PageBuddy(buddy) && buddy_order(buddy) > pageblock_order) {
 		int order = buddy_order(buddy);
 
 		del_page_from_free_list(buddy, zone, order,
-					get_pfnblock_migratetype(buddy, pfn));
+					get_pfnblock_migratetype(buddy, buddy_pfn));
 		toggle_pageblock_isolate(page, isolate);
-		split_large_buddy(zone, buddy, pfn, order, FPI_NONE);
+		split_large_buddy(zone, buddy, buddy_pfn, order, FPI_NONE);
 		return true;
 	}
 
-	/* We're the starting block of a larger buddy */
-	if (PageBuddy(page) && buddy_order(page) > pageblock_order) {
-		int order = buddy_order(page);
-
-		del_page_from_free_list(page, zone, order,
-					get_pfnblock_migratetype(page, pfn));
-		toggle_pageblock_isolate(page, isolate);
-		split_large_buddy(zone, page, pfn, order, FPI_NONE);
-		return true;
-	}
 move:
 	/* Use MIGRATETYPE_MASK to get non-isolate migratetype */
 	if (isolate) {
-- 
2.34.1


