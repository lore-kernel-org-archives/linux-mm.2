Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85647CD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 15:02:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D09656B00B8; Wed, 20 May 2026 11:01:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE1336B00BA; Wed, 20 May 2026 11:01:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF66A6B00BB; Wed, 20 May 2026 11:01:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AC6FE6B00B8
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:01:02 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 708478CFE7
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:01:02 +0000 (UTC)
X-FDA: 84788110764.06.867212F
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9D5A580013
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:01:00 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=aCNhk919;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779289260; a=rsa-sha256;
	cv=none;
	b=S5bwZgyIy8K7+ArqRo3FLaHjS1Sxk+zE0EQv8xImlCGLUP+9w86ZXiFR6jKfeeUqz9IOOd
	rzS1uLQbZSQ2e6jsTxqzVZgDjmQZNaqJHoNdzdYb5apMK9w5tmA3IUZGmnWulT6/4iHGHj
	QwhlLya0uD/ExNSyvInsB8nUFCuA97o=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=aCNhk919;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779289260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SZrOQk0GM156TvBoVM+zLzXRO2Iy08Gh16ie8a5/0l4=;
	b=bRoBP1c0dEBfZ3UGW3Y/zkfbvZ3xV1DW6eUl8qTMIuPh+1oHvTCmGMrX+zW6FC9T9zhY1G
	C/+CaGpp77GS952HEmnIlUWIOGjBXX3Jc165CbjJpN3LcofLht/DK4tKQHOxJKJXqF+ksk
	zL1iPE2gyncPuRMVvyW7swsSaoC7Y9g=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=SZrOQk0GM156TvBoVM+zLzXRO2Iy08Gh16ie8a5/0l4=; b=aCNhk9191WRg6r+R2XCSmJGb9N
	XWpYCBqFGqjSuPZAdPk6o4CKReJBXt0pyJ0YNYvbfuErrkbzrlrNhADsUtIYQS9bvj2tS5Uihh81K
	QVvIciHWPeHBse8536TVD6l1Sf/9I3fxdZrKloib+zUmpbYGprwmbA8gDCqriOra8R8qX7Yb8kRzl
	Xzxi42+yhqMJHEx6pJO6/EK/dPBEWr/r63Nget93fY9H/dQmaEgKZJw8Oa4LPzOH2oRXQrPqom484
	Iyi2AOHaVQgtFtbhbHJU1NrCrAgyHdJI1BUu/gFKM38WS1t4FIIi0X7QLB2TFOtlN0jM1aJXqbVp8
	XeYfTlDA==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wPiPN-0000000024Q-0NIZ;
	Wed, 20 May 2026 11:00:29 -0400
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-team@meta.com,
	linux-mm@kvack.org,
	david@kernel.org,
	willy@infradead.org,
	surenb@google.com,
	hannes@cmpxchg.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	usama.arif@linux.dev,
	fvdl@google.com,
	Rik van Riel <riel@surriel.com>
Subject: [RFC PATCH 36/40] mm: page_alloc: set ALLOC_NOFRAGMENT on alloc_frozen_pages_nolock_noprof
Date: Wed, 20 May 2026 10:59:42 -0400
Message-ID: <20260520150018.2491267-37-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520150018.2491267-1-riel@surriel.com>
References: <20260520150018.2491267-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: f74rd41s85yjtmcbj5geuzsdr7yzktmx
X-Rspam-User: 
X-Rspamd-Queue-Id: 9D5A580013
X-Rspamd-Server: rspam07
X-HE-Tag: 1779289260-697238
X-HE-Meta: U2FsdGVkX1+g9JMGB+Z5YI40IcQjBgzFeqsiKkkiPy6nDyQ5sClVVX2LChbZX75JNdnaTXvQgPV4ljm8B+4z9LuvWBlJXiK7f7gyLJtYMHdaUGE8BFBr4bSAjMjgV4e86imssi1DR5p/SHfeJqltjrN0WTL5/Hl7oUblq78ygnjRpSH5Rx8o/uX9aImKLtdpQo0Gbt5Ri4ByEFaZwxcmBVA03dFoeORLNYgFiDeYG2Hp2AVWkyYvlxGaJR22WbGk3TtRMrssBSHxLL+qOtfvm/CmYpC8yT3hhfQ/I5C9BG1iX4javTLcdhdmPQ2D35liIO8mlbo0ZzCHfy5jMag/TeXuNRZGN4VyExojzowpdrWC/TK5/jeS2POBsYSkaRQdDu8BBdvjItXKMLMM2eJq3rzsAzcM8lhy9JXLwQmi1/Y1fNmNlxITb53TftGuYXvlkiN59K2+Zq6bhQ30LBNtfebxa2n6+Bul1PSLjdQ5LTXlavV6d/CEB4+s+GoWDkgzbtDUTI1E61S7+tK8wIowqZdQUv6/vBBKm4Fazy4vDGufNOjolzYNEe1bxa0ylt7zwrNIZUCxbv2aNxR1i9XwMyViPQICOGEDyE4A+FMfjlgTHroScXawALnwZgrVafysM4R5N4LTnEm+S9FV/yi5DWwlN2iSfiKjTbZdH+K6BMq4JJ3mUSqboGmVc4ojxVioSdkN7YQjjhgdMBsjQHp3o5QQLiEfoM2cVfVHBFwIMcf4nNp+PDgT3a6EBTjzCgciJ3otWTAuYpsJmNHJkEXnlP/ZDF9USfZoeXz4HNppXrLhAn/2pU0i/Y4n/NdjeuJRa8HLJ6Z4NDuR1k8vDvLlxWbMLQwixJ9VEZfqC+1TpIPA+glsKdFnx/H6ikP0jcHbM3FAG83QoBje+teH9dlHhlI8CxUdpcvLnWemtD5VernTtUjbl9eN9ghah48YfQkfqUsyM8EqdsIGMjXRHSI
 57QiknC2
 lG1NNKsioEPgZO4Scuw5AZm2VH2NC2VlnivRjUY0bSinMXeY6g8TOWcBgNpIjnVsyHFnu7wjpnAkQU1+HR+nzLyjHUBheJM0D9A6YgNlVVZrfGXfcHAW8pKMR3KF1Jm+sfsEJPRaYQEKXvMq3KP97T8FdB588SdUlOymfr5Ai0KfBPes9WPz/HiAQoXN6MijDS6GabJHCKTF+che3MMddwEYwC4vJYnZqoxWvo4mfz3RA0LxIaMz8IK5Q4jiHsK+WNqC/DcgayXlnIfzCbqAfJMxUNYu+jEcKoM3i7wQIRSLHSAZZsDqL/h3vnN/DjRe8Auck
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The no-lock atomic page allocator (alloc_frozen_pages_nolock) bypasses
__alloc_pages_slowpath() entirely and calls get_page_from_freelist()
directly. The slowpath is where ALLOC_NOFRAGMENT is normally set for
non-movable allocations, so the nolock path runs without the "skip
clean SPBs" guard.

Add ALLOC_NOFRAGMENT to the alloc_flags. The function is best-effort
and callers already handle NULL. The flag steers the alloc toward
tainted-SPB sub-pageblock space first; for order > 0 the existing
auto-refuse in the get_page_from_freelist relax sequence returns NULL
when the tainted pool can serve a smaller order, and for order = 0
the alloc falls back to claiming a clean SPB only if the tainted
pool is exhausted of suitable fragments.

ALLOC_NOFRAGMENT is purely a pageblock-category steering hint; it
does not depend on __GFP_DIRECT_RECLAIM and does not introduce any
sleeping locks, so it composes cleanly with ALLOC_TRYLOCK in NMI,
hardirq, and PREEMPT_RT contexts.

Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 mm/page_alloc.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2791a52b61da..4e45fac14622 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -11525,7 +11525,23 @@ struct page *alloc_frozen_pages_nolock_noprof(gfp_t gfp_flags, int nid, unsigned
 	 */
 	gfp_t alloc_gfp = __GFP_NOWARN | __GFP_ZERO | __GFP_NOMEMALLOC | __GFP_COMP
 			| gfp_flags;
-	unsigned int alloc_flags = ALLOC_TRYLOCK;
+	/*
+	 * ALLOC_NOFRAGMENT steers this best-effort no-lock allocation
+	 * toward tainted-SPB sub-pageblock space before fragmenting any
+	 * clean superpageblock. Without it, atomic kmalloc_nolock callers
+	 * (e.g. BPF storage from sched_process_exec tracepoints) hit the
+	 * fallback path on every PCP miss and convert a movable pageblock
+	 * in a clean SPB to UNMOVABLE -- tainting a 1 GiB hugepage
+	 * candidate for an order-0 atomic alloc. With NOFRAGMENT set:
+	 *   - order > 0: the get_page_from_freelist relax sequence
+	 *     auto-refuses to drop NOFRAGMENT when the tainted pool can
+	 *     serve a smaller order, returning NULL to the caller.
+	 *   - order = 0: prefers tainted-SPB fragments first; only falls
+	 *     back to claiming a clean-SPB pageblock if the tainted pool
+	 *     is exhausted of suitable fragments.
+	 * Callers of alloc_pages_nolock() already handle NULL.
+	 */
+	unsigned int alloc_flags = ALLOC_TRYLOCK | ALLOC_NOFRAGMENT;
 	struct alloc_context ac = { };
 	struct page *page;
 
-- 
2.54.0


