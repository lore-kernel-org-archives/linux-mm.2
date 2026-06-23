Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B02CCDB46F
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 00:46:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B520F6B0088; Mon, 22 Jun 2026 20:46:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B02EF6B008A; Mon, 22 Jun 2026 20:46:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F4176B008C; Mon, 22 Jun 2026 20:46:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 737356B0088
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 20:46:30 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 04A6140331
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 00:46:29 +0000 (UTC)
X-FDA: 84909336540.29.C938837
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3CC67A0003
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 00:46:28 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fpHGXV+b;
	spf=pass (imf15.hostedemail.com: domain of jp.kobryn@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782175588;
	b=YLeGAR5jk69T5tF6FAfoE/pY9Rm+NuM8s7gvtyq/IzdSB+qOCMnzKLP2j0SbL6twPu5jtf
	/Ve7hFdkOMB+Ln2vL7/1ZQ4gNpwg74tczcEatNur0w9RAYcY5IU4Lc4ewQGOvx67sSFAMF
	rotkNOP8/VnIsNEp3oxY+2EBXb7oFKM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782175588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=XlkqxyqOJoqvIllh9mUeQc2L3VjewKUXQAdYDGn19nU=;
	b=O/jPkmzOL+0yxggGtP1MHxvqN6wPkEeOzXE5ujD/FD4i3daNUDyg0izECPXL01rkYwTsCY
	D9LDGeE0kCp6aGD1zTzOT2haZNSoSUuJcSx0D2YvkKui5IaqqDe6m3HV3yxu9POswkFYz5
	z49jv3QOZTBCLQPLq9nv6fAosD497O0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fpHGXV+b;
	spf=pass (imf15.hostedemail.com: domain of jp.kobryn@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782175586;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=XlkqxyqOJoqvIllh9mUeQc2L3VjewKUXQAdYDGn19nU=;
	b=fpHGXV+bOWANXRUf4vFTJWaXsRwbL6mq5UVW/e2SdaLe860HN79yRDQ0c4NRJ851uGB9KZ
	oqCNbaDImHw9u08HRL4lY237DBueGOycSHhY6+++pidQlRl0zHnF8T/9alStrooX/nhIOq
	BN3Qa2m/1b/fzSyjeF7OxJ18ZV1+gs8=
From: JP Kobryn <jp.kobryn@linux.dev>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	fvdl@google.com,
	linux-mm@kvack.org
Cc: shakeel.butt@linux.dev,
	usama.arif@linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3] mm/page_alloc: use existing highatomic reserves on the buddy fastpath
Date: Mon, 22 Jun 2026 17:46:00 -0700
Message-ID: <20260623004600.113347-1-jp.kobryn@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: zhb1ipocfkxru8seidd1usrhmjbuhuwi
X-Rspamd-Queue-Id: 3CC67A0003
X-Rspamd-Server: rspam06
X-HE-Tag: 1782175588-792078
X-HE-Meta: U2FsdGVkX1/7aUW/eINLVuJXHlZSWkAEVI2xu5+opaH2zSfMXn1ttVR2pX3fC/Sa4m1oxiDkAmRQGlbXOtBsNkzF9LPCRFFUMDIEUDSQzlNqFa1LnjdSfU07uvhEDCOC+PVaM61AdjwnHN0SOX+GDoXXBKvMF3TXjBVlIfJOBhz7DGC9dmpUxXqPbvOp4mVvJzwAVDo1sj69QGgx2wtNGGDmR15IAQ5Ymx85d9xOwvaJgcE+DDo5ebsHu5kfmNa//NTX5oPXI91NEvQqcwJJ7zF1vp09bhSq7gIxokEAiq16XAzGj/x6NQLoWqId73Q1iePq2U5NrD2GR1piXiYebgwHi3bvLnscHwpSl2YzuZgCoG6L5Que0BRJPjae5UyRmftZ4MiUCRzNMnzUdcHKiKL+Pi7DzNOtiItaUiDcruvd3mjcyHeNVyQSrwLmfCELmVA5i+x5RrJU+2I0n+MzSzpEQB1h663y4w2Oz6Y9og0l7F91Rt17P7S6nV5Rl3N3Bka9IlTqgfCrbGuT5HeLjVlFWGICCcGtpY18UTyx+CB93JhWXx//NyD3Hsj2RCR5QN5jmPnoV3S5MuEYaz9XO6tGvqYFYh8VUyB0PV68EfsCMCStYVOO48bW1+cqFJzbK+vrZZp/jRBi9WsGuku4YMDhBeOgFN6edq3DXQnM+J1+dViPtdSPqJr4QTq9XtgF+Z1dnkJ5x9dlGzIKHSaC8uv1RElYulM8VlQodIgcc8qZ0I6OO8ZxpYSVbzfq2wKZAxXrbAly0XTm6trfkCNrb12AYxidxpuYoNhYYxAS7JGgLYM8A2cYbhXGYNaFqEfCkcztfmNG7urpgmdgjN5DuHSGZgOr7DoyO1AHxwWKsQEOHNXSi1QZ0I4P+ZVbL9x8gslNrlAJ9ZqgzlCIf5JIDaep+TLoBduisna+CryqUjgX4HLVHnG1KNBs4xEIj/Mpsjqi/SBxvSSKBNIcKc1
 lGaKvsL5
 n3njCB2B22ImFEiyiwWxZBsXieje2l+l9pIPDwhm+6Gqcubl5DOO5GmjVn7GNwN3KDpoyswQzdBFll7QHtnXNTbpcEwcszzRm/TZlNfDfC3WnZA13mS1gcKYlBfF0Rwv0mB7CB9OB1o59z6cguHbDS0hrzyUKtOheY1qaY3qf2n+80qtw32J6Gp3qOpXqwQalRbhUfQhjGc+DYO3G4pNIewgr9h8S3X88oyJ4YfvG7rsHQ1yJNmQ2qzJ3mYeD4APZdUiEdAzF3iBhyFkngXQ4AE0vqg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ALLOC_HIGHATOMIC currently provides both access to MIGRATE_HIGHATOMIC free
pages and permission to create new highatomic pageblock reserves. This
makes it unsuitable for the fastpath.

However, the fastpath can reach rmqueue_buddy() while MIGRATE_HIGHATOMIC
reserves have free pages available. In this situation, the allocation can
fall back to other migratetypes without trying those reserves first.

Allow high-priority non-blocking allocations to use existing
MIGRATE_HIGHATOMIC reserves on the buddy fastpath without growing them.
First tighten the criteria for reserving pageblocks so that growth may only
occur in the slowpath. Then allow fastpath usage by enabling
ALLOC_HIGHATOMIC when the GFP mask describes a non-blocking high-priority
allocation. This logic has been factored out from gfp_to_alloc_flags() to a
new function gfp_to_alloc_flags_nonblocking().

A UDP receive workload was run with free MIGRATE_HIGHATOMIC pageblocks
available in the target zone. Before this patch, the workload did not
consume these blocks. With this patch, eligible order-1 allocations
reaching the buddy path consumed existing MIGRATE_HIGHATOMIC pageblocks,
with no highatomic misses observed. The workload did not grow highatomic
reserves and NAPI page-frag allocations remained healthy with no failures
or order-0 fallbacks.

Signed-off-by: JP Kobryn <jp.kobryn@linux.dev>
---
v3:
  - remove ALLOC_HIGHATOMIC_RESERVE and let ALLOC_HIGHATOMIC keep original behavior
  - use ALLOC_WMARK_MIN to identify slowpath before growing reserve
  - factor out non-blocking logic from gfp_to_alloc_flags() into *_nonblocking() helper
  - dropped reviewed-by tag

v2: https://lore.kernel.org/linux-mm/20260617234958.150339-1-jp.kobryn@linux.dev/
  - decouple use semantics from ALLOC_HIGHATOMIC_RESERVE
  - update changelog to reflect above change and reword test paragraph
  - adjust comment in PCP path

v1: https://lore.kernel.org/linux-mm/20260616191420.52556-1-jp.kobryn@linux.dev/

 mm/page_alloc.c | 44 ++++++++++++++++++++++++++++++--------------
 1 file changed, 30 insertions(+), 14 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index f7db8f049bd2..7330f22e3f8f 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3247,10 +3247,11 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
 	} while (check_new_pages(page, order));
 
 	/*
-	 * If this is a high-order atomic allocation then check
-	 * if the pageblock should be reserved for the future
+	 * Slowpath (precarious) high-atomic allocations may reserve
+	 * a pageblock for future use.
 	 */
-	if (unlikely(alloc_flags & ALLOC_HIGHATOMIC))
+	if (unlikely((alloc_flags & ALLOC_HIGHATOMIC) &&
+			((alloc_flags & ALLOC_WMARK_MASK) == ALLOC_WMARK_MIN)))
 		reserve_highatomic_pageblock(page, order, zone);
 
 	__count_zid_vm_events(PGALLOC, page_zonenum(page), 1 << order);
@@ -4473,6 +4474,29 @@ static void wake_all_kswapds(unsigned int order, gfp_t gfp_mask,
 	}
 }
 
+static inline unsigned int
+gfp_to_alloc_flags_nonblocking(gfp_t gfp_mask, unsigned int order)
+{
+	unsigned int alloc_flags = 0;
+
+	if (gfp_mask & __GFP_DIRECT_RECLAIM)
+		return 0;
+
+	/*
+	 * Not worth trying to allocate harder for __GFP_NOMEMALLOC even
+	 * if it can't schedule.
+	 */
+	if (gfp_mask & __GFP_NOMEMALLOC)
+		return 0;
+
+	alloc_flags |= ALLOC_NON_BLOCK;
+
+	if (order > 0 && (gfp_mask & __GFP_HIGH))
+		alloc_flags |= ALLOC_HIGHATOMIC;
+
+	return alloc_flags;
+}
+
 static inline unsigned int
 gfp_to_alloc_flags(gfp_t gfp_mask, unsigned int order)
 {
@@ -4495,18 +4519,9 @@ gfp_to_alloc_flags(gfp_t gfp_mask, unsigned int order)
 	alloc_flags |= (__force int)
 		(gfp_mask & (__GFP_HIGH | __GFP_KSWAPD_RECLAIM));
 
-	if (!(gfp_mask & __GFP_DIRECT_RECLAIM)) {
-		/*
-		 * Not worth trying to allocate harder for __GFP_NOMEMALLOC even
-		 * if it can't schedule.
-		 */
-		if (!(gfp_mask & __GFP_NOMEMALLOC)) {
-			alloc_flags |= ALLOC_NON_BLOCK;
-
-			if (order > 0 && (alloc_flags & ALLOC_MIN_RESERVE))
-				alloc_flags |= ALLOC_HIGHATOMIC;
-		}
+	alloc_flags |= gfp_to_alloc_flags_nonblocking(gfp_mask, order);
 
+	if (!(gfp_mask & __GFP_DIRECT_RECLAIM)) {
 		/*
 		 * Ignore cpuset mems for non-blocking __GFP_HIGH (probably
 		 * GFP_ATOMIC) rather than fail, see the comment for
@@ -5299,6 +5314,7 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
 	 * memory until all local zones are considered.
 	 */
 	alloc_flags |= alloc_flags_nofragment(zonelist_zone(ac.preferred_zoneref), gfp);
+	alloc_flags |= gfp_to_alloc_flags_nonblocking(gfp, order) & ALLOC_HIGHATOMIC;
 
 	/* First allocation attempt */
 	page = get_page_from_freelist(alloc_gfp, order, alloc_flags, &ac);
-- 
2.54.0


