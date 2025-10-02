Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D932CCAC5BB
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 03:31:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 261058E000C; Wed,  1 Oct 2025 23:31:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19C218E0002; Wed,  1 Oct 2025 23:31:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03D898E000C; Wed,  1 Oct 2025 23:31:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DA8A68E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 23:31:51 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AB74013A7A9
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 03:31:51 +0000 (UTC)
X-FDA: 83951750022.02.89CA017
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf16.hostedemail.com (Postfix) with ESMTP id D3500180005
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 03:31:49 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Q2V8G4lG;
	spf=pass (imf16.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759375909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=Sksh+fvQDkvmMLTjml6GxWuky1HRz6r6C/qw5t3XRyo=;
	b=tUZFSaKcNlGv7Z0Acuhhpxf4u5CDlV/+um6W/Ta9WqkOKoLAj8HjIENSnkOMX3kr/Z72zb
	uywQFvcZC87BxLe4i/PdlYXRT6IJoBPykfjc1qaQwETj3zjLMVAqTq9eu1theUjKWpwFxt
	ZuDumHQYhU5SPlBxRAjwRomypuqmbQ8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759375910; a=rsa-sha256;
	cv=none;
	b=xaLt3h7pa3Ex1MpfHF7WubV+E0cHb9be1QPqiR4qRq6gvnryfmROSUkK/9sOTJ/vkhNXLa
	6rK1+rSFO5dEwBPCGnGI6M2QXVxm7vHL86UtFKaZ2jxqSeZvx213s/VQX2AhqtTa2Gk5gf
	u362M0BxAJ2UXfQJdp3/Lf/sS9eWs94=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Q2V8G4lG;
	spf=pass (imf16.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-637e2b86240so418073a12.0
        for <linux-mm@kvack.org>; Wed, 01 Oct 2025 20:31:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759375908; x=1759980708; darn=kvack.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Sksh+fvQDkvmMLTjml6GxWuky1HRz6r6C/qw5t3XRyo=;
        b=Q2V8G4lGsnNrBDJ51kBXPHEnnpQ5B08EToSHUlKf3ujSX9bJSL43TxU42i/Q8zyGmL
         4bFUAs/BL49hx3HGecRfb85pF2OOQihEh2Ll9tIIHhCOZjeRsfrhK/qofJkl47cvNjYP
         MnpYb9VnTkBtiixAqdxM8hfja/ILWs1VwL/BTmKAQZpV0qbcepwFqU0vu04rFjN6zzNA
         9TXrLpaQ5c4vI8C7G+QYtipyRjHWxJC/QAv46pLQCObZYeLhDaDlgBY1ooDF5rQnc2oP
         I+aprNVWwoknlynEFRQaEyE1FNkrmeFUmTukh3Xt5NhnB70DXVJdyDr2SrmHJMabTn4m
         DSZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759375908; x=1759980708;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Sksh+fvQDkvmMLTjml6GxWuky1HRz6r6C/qw5t3XRyo=;
        b=h6VAlRBrWsWxxXboLqSyU9ULRwYmRGgqFJFnqht85zstfOLH1Ns5p1b9RCngbhWIjP
         wn3Jh6pqo4s3D1gCJ3thQ9xStCQozmQX1LqB1vju2iQ3yH1ZmPFltwmfT6cllYa/caJR
         ebCkQ7bguhXaHS4hlFU1YLVfAzrWV6N3acv4/WzcX3q79YOxvvpBY08G7c+cYFVCojSz
         7vCCNrQkQKpn4EsbsyoBOjN87OZb+jL+2xxtk4mUmDvXVp3dSi0LfiYSJacQesDXcAlw
         Rab6Z2FOCybazG94SnwZWpj1TQkY/7cAWnWSx29cB7cMI8fu6+SgwSFLkQQ2m+ypUA71
         iNnA==
X-Gm-Message-State: AOJu0YzHqdIjhuLUqexrh60rkjFpjmVA2TwB+9kaBhqFve2PTtnFOuZ1
	Vr33pBkD4dNxFIZmD/a4tl/To54+zDeExGv8aB61GcvjcBreLPzuJY1r
X-Gm-Gg: ASbGnctBYnHakOMB0BRkm4PDEcNXvmcvNt7nf6jZx6wQB08kK58kRJG8BaNsPmPLOBD
	JG4WCQDrq8ltGceAvciX0lK6qwTp2ItPfpeExAWPgEOuiMPAFdIw7Xs+DiBcRzYjFZvv30agiFO
	VzGM6RBqbhHOZjBVTwzPFYVNJqfsaf4F5HaKCz/AUZdkUFBorL90aTrBByYHFg2JtVxAf3ALnAO
	V6Kyb2ypcSR6y9xqKUW3Gei5y8NsAtvBBd0UvwXMKVuB1IWhJRpDTKaBB4gZ6r2MDdW7RN6bM9d
	UnswWePk/23b+ce78qDDpmM4fIUyxuAJva0wVyhO3t7tr20da1MSVXvuIrpAKGsPxZkvfmd34B6
	vkDTr5LfS5pVL4V9UB7mZuBU8NIyS3CltZsBdjDSZo4cLtU2aGg==
X-Google-Smtp-Source: AGHT+IHFAe7XekP+HnOPO8ZcEcV8lPeuwBzswzDtWe8g7WRheEFeVg1cb2WHCtUEPLzBCEcAJScSdg==
X-Received: by 2002:a05:6402:4404:b0:633:4726:a077 with SMTP id 4fb4d7f45d1cf-63678bb906bmr6475643a12.15.1759375908016;
        Wed, 01 Oct 2025 20:31:48 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6376b3b8625sm1011005a12.18.2025.10.01.20.31.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 01 Oct 2025 20:31:46 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	vbabka@suse.cz,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	rppt@kernel.org,
	iamjoonsoo.kim@lge.com
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [PATCH 2/2] mm/compaction: fix the range to pageblock_pfn_to_page()
Date: Thu,  2 Oct 2025 03:31:40 +0000
Message-Id: <20251002033140.24462-3-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20251002033140.24462-1-richard.weiyang@gmail.com>
References: <20251002033140.24462-1-richard.weiyang@gmail.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D3500180005
X-Stat-Signature: io5us11yp8nb8cdyf7qr5xzs3gzwudg6
X-Rspam-User: 
X-HE-Tag: 1759375909-906801
X-HE-Meta: U2FsdGVkX1+0lWfVTSWYjuG1M3ZJRzeG2lergYFWLvo9hgsW2K+lho0Kp6SQKSwRiTHmt4fw0ZM47vwIeIm1IKsYbaIzJxSWOCnLFzuQhecN9wKC16nphMkpcNZajeR2KkiA2Gg+ZeFU+N6tNPuWYduX3sq8BJNWZjp1XV6K/4G6LEMiOGf0IZwwlZQtwSm5GtDsXYY3DNB3HnpMDB2eQb669n0FpL/todcQVHlilhhsNR/ksCgAFmQvfCD7P8wPTpcOMJtB1Ce8Dlf07V0e7suEmgIrZ1F9bsgMd4O3FZ83NsK4QULXqNnJExs/XOHsTuTPMULTA0mxWqCYpSO75YMEsTNW6Dn6Lgf3GG82143BabHwgUPBGjKz9WGBRz1X97TuBIS5cbylglsin/0DEqJdsXy8mbuXdX8R7dy2U74F5gNY0HUmppcEGEICkuKEcByV6GxlZNbo8Iqn8ts86jLSkeWXVR/vhQLo4/Nggb8M2MPuwxWQlc6g4CvybKZkZ5XiEx9uWAtrf1JtJYNTzwy7A6iWdyBcO/cNrYyAt1H0+fQBkw/zQK3ugyaTE47ihD+lWT6/67mEHsZdkoIEh6pNgJC3PdtrGyjuXPfkhVIlovAhCu+cyCPjbioKnywgXCnZLAFzqzjf0WHpuyaG/OVeYPTLf8qwjXHrPzkMPQLmbd+kBaz8DD2AswdqTeZUF1P9xbvVKLFVLYFhWGSAyGDTPTWSNSdZSFHWor6GnBInnrGidqtb3cN1utOSQ+UcV39g7BQk5l1snETa3NiCxbMckxZE/86dozKR4pvz6NyLGTzNrz6T0xVQU/nHtSpgqFRVck2vofSZut3Vdpo0xzrWXzncqOk/KQlzvp0yLkifBq11K4q8Y6LIzvimVLqIYUzc6SXI6+aEXWnB5qf+VxHObGFU74ifcz67ZGdvWoTbXnvVNRpMNHgRuQX8VJlPBmlQWfJEiCDjeh8HYVb
 R+8sfx/3
 ahXebOluSP4/B0u2ehXITBE5zRCDzKE4Ps92604bO+Igvt7NxJ5dfoBkXwza8c7bpJcbl015OlMo7YEpzrt+tpkY1p+6jniFMAib2Y/EnD1CtvndFodFkkBk1Fx/zSPWqq+culrp9BgbBVqNIZZ5Kwls9RVvcV4Zj+7ts0ySnLTmGijpyFi5mQsMHE5OUpl5gMnxqpUzAezpcWq79g0PeCK8dq3LYFMm4JX1+JXRnkpmmT4++a8pDSR6efzZm0lrdKLrLTRhMHgx710Z3JNV01nUp1HD4G1LwIeQYIhwy27J9K7PMmYB1BVpDPlh9ChfYs+chMmpGFUhJGYW2Geaoz7Oju12yf9WojA+PZF4USq8yKx1oqNWsmqlBCKTx/mhCBKVPF2TLHNVTaRa3rhkNC96WLONwqYHHQzzNA8ifjoBGDG6jGBUt50r0JVjwV7syy/UNlxdR0u2FdVZdcheOfb33xCYfvzs9Kktz/sOPH0QKjO9bFvRLTr7gviAXJzlTHHTC9eYrOO8tRbqnfnX8MBmdlm6f/hTcPYA+QGpDJWDHtHuTabiELeR7dIJHCo7l+t6dzrnYRe89IKSz9wcKweN5RA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Current code may skip some part of the range to
pageblock_pfn_to_page() to check whether the range is in the same zone.

Function pageblock_pfn_to_page() is first introduced by commit 7d49d8868336
("mm, compaction: reduce zone checking frequency in the migration scanner"),
in which it checks and isolates on the same range [pfn, block_end_pfn].

While after commit e1409c325fdc ("mm/compaction: pass only pageblock
aligned range to pageblock_pfn_to_page"), we operate on two different
ranges for check and isolation.

  * [block_start_pfn, block_end_pfn] to check it is in the same zone
  * [pfn, block_end_pfn] to do isolation

It miss some range to check when start_pfn and zone->zone_start_pfn is
in the same pageblock but (start_pfn < zone->zone_start_pfn). The range
before zone_start_pfn is missed.

         start_pfn     zone_start_pfn
    +----+-------------+-------------------+
    block_start_pfn                        block_end_pfn

This leads to the range check is passed, but it will isolate a range in
two different zones.

Let's use the same [block_start_pfn, block_end_pfn] for each iteration
to represent the range to check and isolate.

Fixes: e1409c325fdc ("mm/compaction: pass only pageblock aligned range to pageblock_pfn_to_page")
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 mm/compaction.c | 37 ++++++++++++++-----------------------
 1 file changed, 14 insertions(+), 23 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 1e8f8eca318c..8760d10bd0b3 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1320,27 +1320,22 @@ int
 isolate_migratepages_range(struct compact_control *cc, unsigned long start_pfn,
 							unsigned long end_pfn)
 {
-	unsigned long pfn, block_start_pfn, block_end_pfn;
+	unsigned long block_start_pfn, block_end_pfn;
 	int ret = 0;
 
 	/* Scan block by block. First and last block may be incomplete */
-	pfn = start_pfn;
-	block_start_pfn = pageblock_start_pfn(pfn);
-	if (block_start_pfn < cc->zone->zone_start_pfn)
-		block_start_pfn = cc->zone->zone_start_pfn;
-	block_end_pfn = pageblock_end_pfn(pfn);
+	block_start_pfn = start_pfn;
+	block_end_pfn = pageblock_end_pfn(start_pfn);
 
-	for (; pfn < end_pfn; pfn = block_end_pfn,
-				block_start_pfn = block_end_pfn,
+	for (; block_start_pfn < end_pfn; block_start_pfn = block_end_pfn,
 				block_end_pfn += pageblock_nr_pages) {
 
 		block_end_pfn = min(block_end_pfn, end_pfn);
 
-		if (!pageblock_pfn_to_page(block_start_pfn,
-					block_end_pfn, cc->zone))
+		if (!pageblock_pfn_to_page(block_start_pfn, block_end_pfn, cc->zone))
 			continue;
 
-		ret = isolate_migratepages_block(cc, pfn, block_end_pfn,
+		ret = isolate_migratepages_block(cc, block_start_pfn, block_end_pfn,
 						 ISOLATE_UNEVICTABLE);
 
 		if (ret)
@@ -2046,7 +2041,6 @@ static isolate_migrate_t isolate_migratepages(struct compact_control *cc)
 {
 	unsigned long block_start_pfn;
 	unsigned long block_end_pfn;
-	unsigned long low_pfn;
 	struct page *page;
 	const isolate_mode_t isolate_mode =
 		(sysctl_compact_unevictable_allowed ? ISOLATE_UNEVICTABLE : 0) |
@@ -2058,20 +2052,17 @@ static isolate_migrate_t isolate_migratepages(struct compact_control *cc)
 	 * initialized by compact_zone(). The first failure will use
 	 * the lowest PFN as the starting point for linear scanning.
 	 */
-	low_pfn = fast_find_migrateblock(cc);
-	block_start_pfn = pageblock_start_pfn(low_pfn);
-	if (block_start_pfn < cc->zone->zone_start_pfn)
-		block_start_pfn = cc->zone->zone_start_pfn;
+	block_start_pfn = fast_find_migrateblock(cc);
 
 	/*
 	 * fast_find_migrateblock() has already ensured the pageblock is not
 	 * set with a skipped flag, so to avoid the isolation_suitable check
 	 * below again, check whether the fast search was successful.
 	 */
-	fast_find_block = low_pfn != cc->migrate_pfn && !cc->fast_search_fail;
+	fast_find_block = block_start_pfn != cc->migrate_pfn && !cc->fast_search_fail;
 
 	/* Only scan within a pageblock boundary */
-	block_end_pfn = pageblock_end_pfn(low_pfn);
+	block_end_pfn = pageblock_end_pfn(block_start_pfn);
 
 	/*
 	 * Iterate over whole pageblocks until we find the first suitable.
@@ -2079,7 +2070,7 @@ static isolate_migrate_t isolate_migratepages(struct compact_control *cc)
 	 */
 	for (; block_end_pfn <= cc->free_pfn;
 			fast_find_block = false,
-			cc->migrate_pfn = low_pfn = block_end_pfn,
+			cc->migrate_pfn = block_end_pfn,
 			block_start_pfn = block_end_pfn,
 			block_end_pfn += pageblock_nr_pages) {
 
@@ -2088,7 +2079,7 @@ static isolate_migrate_t isolate_migratepages(struct compact_control *cc)
 		 * many pageblocks unsuitable, so periodically check if we
 		 * need to schedule.
 		 */
-		if (!(low_pfn % (COMPACT_CLUSTER_MAX * pageblock_nr_pages)))
+		if (!(block_start_pfn % (COMPACT_CLUSTER_MAX * pageblock_nr_pages)))
 			cond_resched();
 
 		page = pageblock_pfn_to_page(block_start_pfn,
@@ -2109,8 +2100,8 @@ static isolate_migrate_t isolate_migratepages(struct compact_control *cc)
 		 * before making it "skip" so other compaction instances do
 		 * not scan the same block.
 		 */
-		if ((pageblock_aligned(low_pfn) ||
-		     low_pfn == cc->zone->zone_start_pfn) &&
+		if ((pageblock_aligned(block_start_pfn) ||
+		     block_start_pfn == cc->zone->zone_start_pfn) &&
 		    !fast_find_block && !isolation_suitable(cc, page))
 			continue;
 
@@ -2128,7 +2119,7 @@ static isolate_migrate_t isolate_migratepages(struct compact_control *cc)
 		}
 
 		/* Perform the isolation */
-		if (isolate_migratepages_block(cc, low_pfn, block_end_pfn,
+		if (isolate_migratepages_block(cc, block_start_pfn, block_end_pfn,
 						isolate_mode))
 			return ISOLATE_ABORT;
 
-- 
2.34.1


