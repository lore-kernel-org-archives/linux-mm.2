Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BF78FD376A
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 16:34:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB9176B00C7; Wed, 25 Feb 2026 11:34:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC37B6B00C8; Wed, 25 Feb 2026 11:34:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B060F6B00C9; Wed, 25 Feb 2026 11:34:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 85C1D6B00C7
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:34:48 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4666713B53F
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:34:48 +0000 (UTC)
X-FDA: 84483527856.01.8150014
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf04.hostedemail.com (Postfix) with ESMTP id 58E3340013
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:34:46 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="KLJU9R/8";
	spf=pass (imf04.hostedemail.com: domain of 3pCSfaQgKCL0mdfnpdqejrrjoh.frpolqx0-ppnydfn.ruj@flex--jackmanb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3pCSfaQgKCL0mdfnpdqejrrjoh.frpolqx0-ppnydfn.ruj@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772037286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zn/sQ5//FH47xWrBpYa+2czdly0Dx/d99/N8Hn2JIac=;
	b=vGWndyKhAGyA6RUDAoVQzm+wjQ0bZiYSyFvxccicQwK01amxijF7Nzlo19a2TxCSaPQ+cI
	72yasVU9sShxJJOk0LY254+Gii2oCjIlVnmISKsdAxibMux6KL51qLMDvZaIT80ZwYw63p
	G1RRKMJ/WXE5rD9exv8E4WOI+zHc60Y=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="KLJU9R/8";
	spf=pass (imf04.hostedemail.com: domain of 3pCSfaQgKCL0mdfnpdqejrrjoh.frpolqx0-ppnydfn.ruj@flex--jackmanb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3pCSfaQgKCL0mdfnpdqejrrjoh.frpolqx0-ppnydfn.ruj@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772037286; a=rsa-sha256;
	cv=none;
	b=bZDd3LJgkGXLr7r2PdwuG/okaUtsvzLgzg+OSh0NSyI+iR861im0CjAI8JeGuS9NJCCnAg
	Xp/3UfgvhrXDPJb7YUHSrVVDMAyL92KGrA5ofrVcRC8NEqyJgKRQdSqv1DEmsVufIZIelL
	8FGDM9NO7JDf0Srh/0FCb2G1d+u4cr4=
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-4376e25bb4dso4752821f8f.0
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:34:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772037285; x=1772642085; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Zn/sQ5//FH47xWrBpYa+2czdly0Dx/d99/N8Hn2JIac=;
        b=KLJU9R/8w9n0VF3a2ILMMpFxL4hDnN00Jf0SpkIrk34KiwiUK5ajY+ZuPiRDF7r5Ws
         gna333K1RBTdcNCMujJzHS4yTAq9sLWUGhxuM/xKNuk6q3UuPZ1pHxCDtmJtT/EcHR9q
         vpzutxcBYNI1T04fA8wZGBPAOxUiJlsF12yWWFb0+TEsqVS9bKRpdDXJoj9l/8soqjMq
         7W3if/WPQoQ3wVGCTYb5yQcGI3BEn8ABuDXdJPqHNW31w5nnJBSDs5IfuSuzxvJWSGeN
         CEEvaeBtmLbnJrP4Ni2U5R2JRkKXm3+sGoYBhDjEVMcRiH+jZsmf2G/SnrS1sxAH2mBj
         alIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772037285; x=1772642085;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Zn/sQ5//FH47xWrBpYa+2czdly0Dx/d99/N8Hn2JIac=;
        b=r18KTxQ3CqJE2ynLz+joCt1NWmPl0zRUgMKcq8VByCREBIfFjDDddjYnXYgxHjs7Ys
         S3YyXXKmCPnA7R1vW1mG1TRBw3tafqs7MSVSa74vogjgCd8W8vBNi4j0vxZT1GNIcFf3
         B0RHEDN131Kb896VicJQyIGkS1MUYYWFRPWLj0gC63dh6GxZ90XfB1Cky0Eg4UUXj1bP
         K3AzaeRUpU8i6dAcY4RflKGUSHlA1k5b+r/N5gSYsiCfGzxJ7wok41LqJnrWkLm4yBNf
         q0Fpk+AQLnZ6fOftEUId2pfcuJgfwJyF1gMJiOX7cie6Qc0EQlTrsk+o8hzko/4twwyO
         +GcQ==
X-Gm-Message-State: AOJu0Ywyi4kKRdgGmKIz+7qw2nFeri7M4vQYxr1Q5HRYQkyHG2hY0EIl
	TMz1HwwPQ03wtklnSRCAp9bnnqjQn5ITOxlaV0XOrJUqDgOQ7oGOu6+x0C2AyqHK3wdJwkx/G83
	UKe/7okuoQFRe2Q==
X-Received: from wrbbn22.prod.google.com ([2002:a05:6000:616:b0:436:30bc:37dd])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:2c08:b0:439:94a7:715a with SMTP id ffacd0b85a97d-43994a771a8mr1769317f8f.17.1772037284432;
 Wed, 25 Feb 2026 08:34:44 -0800 (PST)
Date: Wed, 25 Feb 2026 16:34:32 +0000
In-Reply-To: <20260225-page_alloc-unmapped-v1-0-e8808a03cd66@google.com>
Mime-Version: 1.0
References: <20260225-page_alloc-unmapped-v1-0-e8808a03cd66@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20260225-page_alloc-unmapped-v1-7-e8808a03cd66@google.com>
Subject: [PATCH RFC 07/19] mm/page_alloc: don't overload migratetype in find_suitable_fallback()
From: Brendan Jackman <jackmanb@google.com>
To: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>, derkling@google.com, 
	reijiw@google.com, Will Deacon <will@kernel.org>, rientjes@google.com, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, 
	Brendan Jackman <jackmanb@google.com>, Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 58E3340013
X-Stat-Signature: agjaiegjbxje18q56wmghxk5nprrjxpo
X-Rspam-User: 
X-HE-Tag: 1772037286-409371
X-HE-Meta: U2FsdGVkX19jYvAyJtiCdoNvOXJ8gPxNnXdDXKamoqFeRhE5tptqxivIAJxz34iAIevyLAtffju0b5PE/uu59+pET70FgNgdpp82RKSG2D9WeOjehJUb1kl9S8oC3Gu8lcatJfY7fHvefX5XyxG4Hu/y/Og2w5DQebo2vGdGCW78noKpLRIwUYVMO8DZTtVm+Pz70nYX9h+NTrxEANmwVULcbX+nj0Fgh4f8KsUyIABAPCkbIcwO4vKF1L9OwU1RUMqRAX/aktvUPIA9VRjJ6HUeu3RSu+kmPArOaIQRI5b+BL372XR1rV/LXkLOKDZ3mpUa6GBsPw4N81xweS6ZrcA92U8tF9Ct/o7ifeLUhQLRAmJRD9hIn2UpfYa1dozki/4b/M39c7R/VI3MqY/7qD2QSkY7ic4bSHZ+jdfZD/6ReFOQ0bm3ZyxoeiKXAj3vLe5A5lHj/XzF5n1pwpmRh/5guyi/bV6gbaBqBAZEC7t4VIjYncLfB2feWel3G89oQkLvqzSlDQbPIoGPnHxHf8oWEDRXE6cRP3bOreAhO+C4lfxdeMjNAgLP5lfk6Gp/ftXOdESf3MW8v0Jrwp6+hCTWfRfGFkPi1q0gLdWge0P4Gst4DtaqYOlbXU8uqm1gU0De71Lj+aXNJFI2j22mSKSjclEqpeTFOVsITyn6sh2winYQqo0ZOWvJGECg/tSeOOTJOSgl9GlwrhZXzHPuC2cLC+gQ7I1P2+LDZ1ZUhJxcZWNvQDt9AIXUSNk4Sj4ufF6PLo/oHJgy1BSR1GhyqjfBEt9dieNjZI9HQato6o6PHE9a1koyRJiW24GQ+xkjb8o8Q2HdZLn+2l2v7wMPfZESoV81m8UOpYeGwtnxnbg3TIHfV4Z4GPbKa+vxuWbNNiKxTiI4PxtosnO4BOitjM3aEtSAOQPM/ZVIPJ/+jdAX1IQWsqfOAkJg4kih0m+VxBhZEBv566gTS+CXfGF
 KFJCoKGJ
 iLritt4M8YA25BGnBRwpDE+dI885JriooijC7PWEwCts1LQ35aZPSrYtxLfdiTCVUUcHUntuXv+sicaGuO9g7sbGuNsSxMtOG9gFgf00vmgm26bPsj1zPRc8e8ZxKFGnm08vqxeCaltxpEgJHJNf7RJ3OeDRufiOJJIY86EW/781HlH6DrKoZ3sZX9CGnTVuX72GQoRht1so78tWvELqGJgfX4XMMo2aFXziv+/NhWTBbHzX7RD78st99sN+K9wu/8lTC0u1pLWPIbm6e0Rft3/vhxGyqWaOFA448K5ib9WZGNSnmA/b/A41ZzEOqKAfasXPVU8hhZxo8/WQdgVAlncILhPAin0koQyyZSz4xNe+R2/oAKOcpSApLTiRFVogexu15meQ5yrM/4Q2HrxVLL4VgdOi8n2xJZl8biBhLj1m2ScsWfjEzwfTeUXaeUBNtM0PQ93SjHdKH02P5cqi9NoUI7COdb/UlVBNadB7MJMStet/9B5C5fGohNfoEH+GyTXCCMQNKXVuPbekcTA5tz1H+iXqOPn2yZpD5LtHG5Ns51hNmVYWRSEUnlOPlsvhzcqxl9VXn4N0O+/5emaAxqB+9kCphzXJ+FmNip9wKXyQloduZtViHDuNEP2zZot3Q9sjsYVeIH/E4sDC1ho+nRo92126/2Y78Sq7l5YtyvkleO0FMzJjMNVhG0Jkbnp0OLp8s
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This function currently returns a signed integer that encodes status
in-band, as negative numbers, along with a migratetype.

This function is about to be updated to a mode where this in-band
signaling no longer makes sense. Therefore, switch to a more
explicit/verbose style that encodes the status and migratetype
separately.

In the spirit of making things more explicit, also create an enum to
avoid using magic integer literals with special meanings. This enables
documenting the values at their definition instead of in one of the
callers.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 mm/compaction.c |  3 ++-
 mm/internal.h   | 14 +++++++++++---
 mm/page_alloc.c | 40 +++++++++++++++++++++++-----------------
 3 files changed, 36 insertions(+), 21 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 1e8f8eca318c6..cf65a3425500c 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -2323,7 +2323,8 @@ static enum compact_result __compact_finished(struct compact_control *cc)
 		 * Job done if allocation would steal freepages from
 		 * other migratetype buddy lists.
 		 */
-		if (find_suitable_fallback(area, order, migratetype, true) >= 0)
+		if (find_suitable_fallback(area, order, migratetype, true, NULL)
+		    == FALLBACK_FOUND)
 			/*
 			 * Movable pages are OK in any pageblock. If we are
 			 * stealing for a non-movable allocation, make sure
diff --git a/mm/internal.h b/mm/internal.h
index cb0af847d7d99..1d88e56a9dee0 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1028,9 +1028,17 @@ static inline void init_cma_pageblock(struct page *page)
 }
 #endif
 
-
-int find_suitable_fallback(struct free_area *area, unsigned int order,
-			   int migratetype, bool claimable);
+enum fallback_result {
+	/* Found suitable migratetype, *mt_out is valid. */
+	FALLBACK_FOUND,
+	/* No fallback found in requested order. */
+	FALLBACK_EMPTY,
+	/* Passed @claimable, but claiming whole block is a bad idea. */
+	FALLBACK_NOCLAIM,
+};
+enum fallback_result
+find_suitable_fallback(struct free_area *area, unsigned int order,
+		       int migratetype, bool claimable, unsigned int *mt_out);
 
 static inline bool free_area_empty(struct free_area *area, int migratetype)
 {
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index fcc32737f451e..1cd74a5901ded 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2280,25 +2280,29 @@ static bool should_try_claim_block(unsigned int order, int start_mt)
  * we would do this whole-block claiming. This would help to reduce
  * fragmentation due to mixed migratetype pages in one pageblock.
  */
-int find_suitable_fallback(struct free_area *area, unsigned int order,
-			   int migratetype, bool claimable)
+enum fallback_result
+find_suitable_fallback(struct free_area *area, unsigned int order,
+		       int migratetype, bool claimable, unsigned int *mt_out)
 {
 	int i;
 
 	if (claimable && !should_try_claim_block(order, migratetype))
-		return -2;
+		return FALLBACK_NOCLAIM;
 
 	if (area->nr_free == 0)
-		return -1;
+		return FALLBACK_EMPTY;
 
 	for (i = 0; i < MIGRATE_PCPTYPES - 1 ; i++) {
 		int fallback_mt = fallbacks[migratetype][i];
 
-		if (!free_area_empty(area, fallback_mt))
-			return fallback_mt;
+		if (!free_area_empty(area, fallback_mt)) {
+			if (mt_out)
+				*mt_out = fallback_mt;
+			return FALLBACK_FOUND;
+		}
 	}
 
-	return -1;
+	return FALLBACK_EMPTY;
 }
 
 /*
@@ -2408,16 +2412,16 @@ __rmqueue_claim(struct zone *zone, int order, int start_migratetype,
 	 */
 	for (current_order = MAX_PAGE_ORDER; current_order >= min_order;
 				--current_order) {
-		area = &(zone->free_area[current_order]);
-		fallback_mt = find_suitable_fallback(area, current_order,
-						     start_migratetype, true);
+		enum fallback_result result;
 
-		/* No block in that order */
-		if (fallback_mt == -1)
+		area = &(zone->free_area[current_order]);
+		result = find_suitable_fallback(area, current_order,
+						start_migratetype, true, &fallback_mt);
+
+		if (result == FALLBACK_EMPTY)
 			continue;
 
-		/* Advanced into orders too low to claim, abort */
-		if (fallback_mt == -2)
+		if (result == FALLBACK_NOCLAIM)
 			break;
 
 		page = get_page_from_free_area(area, fallback_mt);
@@ -2447,10 +2451,12 @@ __rmqueue_steal(struct zone *zone, int order, int start_migratetype)
 	int fallback_mt;
 
 	for (current_order = order; current_order < NR_PAGE_ORDERS; current_order++) {
+		enum fallback_result result;
+
 		area = &(zone->free_area[current_order]);
-		fallback_mt = find_suitable_fallback(area, current_order,
-						     start_migratetype, false);
-		if (fallback_mt == -1)
+		result = find_suitable_fallback(area, current_order, start_migratetype,
+						false, &fallback_mt);
+		if (result == FALLBACK_EMPTY)
 			continue;
 
 		page = get_page_from_free_area(area, fallback_mt);

-- 
2.51.2


