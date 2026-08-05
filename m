Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AC06C55184
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 02:16:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 194C16B008A; Tue,  4 Aug 2026 22:16:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 145FE6B0092; Tue,  4 Aug 2026 22:16:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05D896B0093; Tue,  4 Aug 2026 22:16:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CDE036B008A
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 22:16:18 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 49C92A037C
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 02:16:18 +0000 (UTC)
X-FDA: 85065601236.14.27904C3
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6FD1B100007
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 02:16:16 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NJi1XOp4;
	spf=pass (imf05.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785896176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=8poeoDZkGdDv1roqY9qI4+IwjPDa5UcGb8SnGgss8Eo=;
	b=e8p0pUjC9rcWIfGdyZc1HkVRUptPKMOayJJw+74MMYVtQId3VKMdnap0BV/ZEap5UqR6kH
	oPzV8zcziZMUXAurgQoKoJOBrJfGjzJ2jxhHy4KoQTyBHTXWS6KulZqt4zRGmvpyoUiavJ
	sdGVWvb7awowbI51TyS2VghDMwavkrQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785896176;
	b=viXH9w/+GI3MpMwoAsL4Sa9xAkZW8XBWK6pZBmHZk6qJuUbJlB4L4T1bAiT5G3b1Wzb2gu
	z77XEmtrCOGDZHvY1uGb/VIy/Lrxx9Pu9i7ojrdofBXpPiCqE07vy2zo7oNPTPUTx5mSeY
	a7qokC2wA03u9aZ4XO6ip08EPSktEl8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NJi1XOp4;
	spf=pass (imf05.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785896174;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=8poeoDZkGdDv1roqY9qI4+IwjPDa5UcGb8SnGgss8Eo=;
	b=NJi1XOp4s/Zqe1TxxE/+26J0CV4BkBzHPNeQAp9vL8qRNRi0R5VhnARjfSbD8bdROgDzhw
	a1yhhH9xUzMC87xxPcAWpXImqZHoxGaAxYJs5RYURpoBLUKKw5vOmOR2sLaTkuJ8QLPQtX
	SfG+ilSsD3EwiDw87ltvi5hsV7E44CU=
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: Ye Liu <liuye@kylinos.cn>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/show_mem: fix format string inconsistencies and type mismatches
Date: Wed,  5 Aug 2026 10:15:55 +0800
Message-Id: <20260805021556.1908807-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 6FD1B100007
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: ib41d3kaatz4eu8o6xaby65jbgp7r1rb
X-HE-Tag: 1785896176-616518
X-HE-Meta: U2FsdGVkX18fENnxNPe5PS8svYEGBH74axRTv/FvFkJ6W9pnKKCo9HncwUVluz+BOwgR37OEYaVexzWlF7xXEHxEzY8F66f2YzyEbcTfuNBTmz9vIECB+2mAPwx6WywGGtvZe3QBlfrGtE1Er9ruFTRUWedhooO4XNdYUy5kum0bS+gI826m1Inc1y7sQ5bZmXjH8suE8XZZX4JXG+c0lnXyT/hD0N6/TZ0c1jnT+d21s+nN7pudd7FE8iqxWn59XwFs67X+H7lhAX6F4TEL6uuYMKgMECtt9IXeQYRHlE1IjhfI7pPQsGXpb4AY8tEWP2vJPiBLWAwMpi27Zix3cSr9rCr5gkzDINb/xNh2W9gOJJU//DjIVf6/TepFQVpH0lAXpoMmdjUGRG8G22Lg8b7gXXPOmkKamulXnJrNtGpfb6ww6XRPVj0RzhVMWvzMRDRGQIJ0/XW6A8pAkzUn8/CVD0qCifUkL4fl42Gm1GLz1dNk8CtWPMCegYrAgxnLup/U3xSilUfD6JyVvxxDGbTasRRrETW/+0DGu/KoGMdZA1TeWIXgnCFWx6geGqk88wIE73CBSrBacg/MaIDLhrNkXh9O0WNFy9OAmLwR+FK65YxBZEeJqXBpvZV7B2T4ZPY9mA99L14b46BMM8pq3GOnF66A7BV1t0a9y+dNVDoqMXGIkCWDzl4dzRA6J3kgWG9AH6B2yr5+hKqqinCL1HbsAkqZInH6qRUrMkcVBi4rF9sUFuUBCaExHC9hawqVCQXBd+Hf0D62mWZNg6MsesFRKXMWIiSF77nyOsDllgFEiqYU/Ke01I7tzlLkEngltRRyxS+qq0cFF58CJYhtwrGTbdhjy/ZF5pIRGXnbZXxUz1tdFb461rdKnnvRPrwB0sicsA5ypy7a5lCzGomV9UihKSlFRm0NF48Ex0tWMvyAH0DgQ97xNhWrbKVlCnRE1ct9F9naMK07By+Uuq+
 LKzlMGOp
 WhAztKVbpVGCly4NsEBUMx1p7Y+zv+WZCW51PDwr34c7/U8GqAaXGnmZIBk4vZrxUAEUMgD974mLIyAqUNy2tDRdi4Z+h/9ev9ii/ESsm+q3vs1R4pefyFGI2mHY1Hvy53ZcOKHnAsJHfyhEamrBLXu/COZttljHsHcVmoNbyvVPojWXO2vZtYqf9Cm7dAxy1BqmaNR4jsFcQid6u/CXlx8evjGVX7At6e3t9Uj5OdM/uwquVPLhJ4Fdsaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

Fix five format string issues in show_free_areas() and __show_mem():

1-2. reserved_highatomic and free_highatomic: %luKB -> %lukB
   The uppercase "KB" is inconsistent with all other fields in the
   same output block and with /proc/meminfo convention.

3. local_pcp: %ukB -> %lukB with explicit (unsigned long) cast
   per_cpu_pages.count is int, so K(count) yields int. Using %u
   was a signed/unsigned mismatch. Cast to unsigned long and use
   %lu for consistency with all other K() usages in the file.

4. total pagecache pages: %ld -> %lu
   global_node_page_state() returns unsigned long. Using %ld is a
   signedness mismatch caught by gcc -Wformat-signedness.

5. hwpoisoned pages: %lu -> %ld
   atomic_long_read() returns long (signed). Using %lu is a
   signedness mismatch caught by gcc -Wformat-signedness.

Verified with: make KCFLAGS="-Wformat -Wformat-signedness" mm/show_mem.o

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
 mm/show_mem.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/show_mem.c b/mm/show_mem.c
index d1288b4c2b64..b938cbcd774a 100644
--- a/mm/show_mem.c
+++ b/mm/show_mem.c
@@ -309,8 +309,8 @@ static void show_free_areas(unsigned int filter, const nodemask_t *nodemask,
 			" min:%lukB"
 			" low:%lukB"
 			" high:%lukB"
-			" reserved_highatomic:%luKB"
-			" free_highatomic:%luKB"
+			" reserved_highatomic:%lukB"
+			" free_highatomic:%lukB"
 			" active_anon:%lukB"
 			" inactive_anon:%lukB"
 			" active_file:%lukB"
@@ -323,7 +323,7 @@ static void show_free_areas(unsigned int filter, const nodemask_t *nodemask,
 			" mlocked:%lukB"
 			" bounce:%lukB"
 			" free_pcp:%lukB"
-			" local_pcp:%ukB"
+			" local_pcp:%lukB"
 			" free_cma:%lukB"
 			"\n",
 			zone->name,
@@ -350,7 +350,7 @@ static void show_free_areas(unsigned int filter, const nodemask_t *nodemask,
 			K(zone_page_state(zone, NR_MLOCK)),
 			0UL,
 			K(free_pcp),
-			K(this_cpu_read(zone->per_cpu_pageset->count)),
+			K((unsigned long)this_cpu_read(zone->per_cpu_pageset->count)),
 			K(zone_page_state(zone, NR_FREE_CMA_PAGES)));
 		printk("lowmem_reserve[]:");
 		for (i = 0; i < MAX_NR_ZONES; i++)
@@ -400,7 +400,7 @@ static void show_free_areas(unsigned int filter, const nodemask_t *nodemask,
 		hugetlb_show_meminfo_node(nid);
 	}
 
-	printk("%ld total pagecache pages\n", global_node_page_state(NR_FILE_PAGES));
+	printk("%lu total pagecache pages\n", global_node_page_state(NR_FILE_PAGES));
 
 	show_swap_cache_info();
 }
@@ -430,7 +430,7 @@ void __show_mem(unsigned int filter, const nodemask_t *nodemask,
 	printk("%lu pages cma reserved\n", totalcma_pages);
 #endif
 #ifdef CONFIG_MEMORY_FAILURE
-	printk("%lu pages hwpoisoned\n", atomic_long_read(&num_poisoned_pages));
+	printk("%ld pages hwpoisoned\n", atomic_long_read(&num_poisoned_pages));
 #endif
 #ifdef CONFIG_MEM_ALLOC_PROFILING
 	static DEFINE_SPINLOCK(mem_alloc_profiling_spinlock);
-- 
2.25.1


