Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB585FD3774
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 16:35:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C8966B00D4; Wed, 25 Feb 2026 11:35:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 754386B00D5; Wed, 25 Feb 2026 11:35:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66E256B00D6; Wed, 25 Feb 2026 11:35:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 544426B00D4
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:35:00 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 06B7E13B6FD
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:35:00 +0000 (UTC)
X-FDA: 84483528360.21.F6FF121
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf01.hostedemail.com (Postfix) with ESMTP id 31F784000C
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:34:57 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=jNONLRQw;
	spf=pass (imf01.hostedemail.com: domain of 3sCSfaQgKCMkyprz1p2qv33v0t.r310x29C-11zAprz.36v@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3sCSfaQgKCMkyprz1p2qv33v0t.r310x29C-11zAprz.36v@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772037298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G/9fFi5oF0vRGQJfwEM4ETi3Y5U6mRHQzuEt7SowwhY=;
	b=IuQb8Nam6904mwB2IhFQiPwo7fNNLN6Eb1KQdTJPeEl6Cm2nJjdFwlKq+gAyqRD611ayic
	BA7vLKi3JZspsNLR1kcFyHqDTLutarjujreCgab/wJsEQh5pWzTr7SKNuvLzv9dhc/+EwE
	X96gZKFebbf2PzgtxoP02BGYovrmcZg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772037298; a=rsa-sha256;
	cv=none;
	b=gtyy5kcopnegMWX0rI4BrqBK3HYRPZUchWFven5l6SfBPnPw1XDZkaPRTdX5o/qT3MRjjc
	yHuNBdEhsOAPcGD0rf4TbNr2Brt4bipicuc+kULDxr/27bJhoQn+nhbl9QSeqHNQvtA/4X
	SnCwyP2m8wEwBiYkMd4b4u0vovViaac=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=jNONLRQw;
	spf=pass (imf01.hostedemail.com: domain of 3sCSfaQgKCMkyprz1p2qv33v0t.r310x29C-11zAprz.36v@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3sCSfaQgKCMkyprz1p2qv33v0t.r310x29C-11zAprz.36v@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4837907ec88so78421635e9.0
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:34:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772037297; x=1772642097; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=G/9fFi5oF0vRGQJfwEM4ETi3Y5U6mRHQzuEt7SowwhY=;
        b=jNONLRQwk9LfyCK7yPTyuv/yoKjhjf6bIRyX9Y/Lq4kZyDepz1vccv1ITVdh5J3M9t
         +Mh29iBHqq1AtSoYtilXr4b93GSppP2WOmKiITwVgnYlf/PqdyWyfjxtdVBU9+Tq1zo6
         mhHolRLiMx27YbYnq2XJWVbeIBVHFgaj50sB7/ZWv0VxUrL4YGMWl97k1PYZsQAhO3Sq
         bIfgKaFOG0PJdJf8/mXQibahkG2LCEbU7CEDyFRcaiXdp698gVrZbnmispjTmA5dv9pd
         21cJn2kmj6R6FM737Cbsyc/JmeP8DuH93fplYb/DrUMGbfa2/dHngLxaYG+o9bu1ZAua
         gbNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772037297; x=1772642097;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G/9fFi5oF0vRGQJfwEM4ETi3Y5U6mRHQzuEt7SowwhY=;
        b=sbvDMIJA2PuDQdRzuIwVQzfqoWY6MnvCIsa0Q/2wiGYX85cmOQY3oMjUuHb94nemL3
         UI3bb9Y3pAc473DzRwqpbzdGAhCrlcRavwtiiTQFcGkVx0rtHZGq728kueM38+kcKZMS
         32BRaEGD3dC9jt2Op27/sqJwEl4tW9lI70RxId+6VrCw4zpDolQ+yu7ZKLos2xX3+0/P
         V82HAPzbnxnTKKi527nfgMK1LmM671xYtm3ouYt0a6pRHG7+m3hyzuj09xBZNeywhS9Z
         zTs9Prq4e19A+t68qqiw1o0wyeu0Pp1n42qBNzp0GBJp0NY9lOVQDkUHpi/aJbpHuT/O
         N5Qw==
X-Gm-Message-State: AOJu0Yx53aXAl3AHsh2qJtkE//dpbel1eSw91YYik7s0eUsNz74vIITA
	MldNLIFCjSI8/2TCRjXjE8ShNTKZC1cmyDR4hNOnNP0JGEituzYLYlFeR4gz1n4kizOld7VKGDE
	VbZMpKHOWmnI6EQ==
X-Received: from wmbjr3.prod.google.com ([2002:a05:600c:5603:b0:480:6c79:b533])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:674f:b0:483:6ff1:18b with SMTP id 5b1f17b1804b1-483a9555bafmr280867955e9.0.1772037296543;
 Wed, 25 Feb 2026 08:34:56 -0800 (PST)
Date: Wed, 25 Feb 2026 16:34:40 +0000
In-Reply-To: <20260225-page_alloc-unmapped-v1-0-e8808a03cd66@google.com>
Mime-Version: 1.0
References: <20260225-page_alloc-unmapped-v1-0-e8808a03cd66@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20260225-page_alloc-unmapped-v1-15-e8808a03cd66@google.com>
Subject: [PATCH RFC 15/19] mm/page_alloc: rename ALLOC_NON_BLOCK back to _HARDER
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
X-Rspamd-Queue-Id: 31F784000C
X-Stat-Signature: yueuffu8hxhjgwe3x4semfdn1wyw9xrn
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1772037297-381633
X-HE-Meta: U2FsdGVkX1+INruaysTgvqJVZ0HxaE6J6UtC9UFrd8ZDZHnUTz0FA2XnJQHZVD0aGKTarxWEr1Y88/nBgKj2aPHircP+RyYLZ1gj9ZiLxrYpb9AWk8MDXPuCnnaOCpTyDYMpGoRg7FgMf8qvTTIjgutlodj89fdgBz0Wj9qXW18bQJ8pm2qRiUKC+pAgeR7kRPdQ8exR8FEtAWlNHUhFnfWRa2Fb6kyzpRJUBKh830V5ow0oFO5jEExNi63VSw6/YMtcEdI2tEmJQpJe+TL9u5IhdDYfWooTQIj+bLHwJBzoSHH/qJAx1u+tG91yd12xgmd/HKWeP3WDdxxlrILQGdtg5o+TVhcDuKmfy+wFA8Vb1HO/GV/lUU6MEUCQeJI6iXiWWD5RawMeMatBLZEIH0lgvwwIEJbGUJzsZj7Ulf6Z5DU1C4RAQNtYdhEnoiv2eYkEo7kFvGXmTtmYeJ2hZjM0k7bcYnj4uqL5sdYwc3Oezs0ntzE6OWp5AbELmQHdgwi8xWVXdj1H4RPvj2FgCRwq43YPNApmtRyTtqZnT1K+/6qVQyhV9G1/Tu7GBB/G4rxwL7vntSjSMrkBUaJ/sYVyMCXyq/UfKB6EMDaE2aNuAbPoV2/DIsj0dllUEy9Huv7nG5XYOmtQ8LNm+aZR5GeJZPQUZHskloGxGx7kXjYN2xuN0huHED0vo80LioUs4fzCv2yXdO9zTFZdpWf73ky7SWJNMQU5yTElAdx5MxS28gWb1Z4SX8rNFDUVjbxs1RKZjq4o1PXvfn9d8bughZ9lFLc5Zl7zBQc5nxIFETvS2uzMoyMdcQ38rctla8W++9PVqCfRJUoyPTow8s9SJBEhQGlQlzd195uwMnItGhGt8gCvgxkWGf3ryhXkDPtxeQZHs7zjb5/QZEXPjF7YQJevaK/lkpnh7/6p9BCOuNxEYjn0qZucBRIptbEvTwXv2oiPcvpYi8LbZzy3HDy
 G4rRcYf0
 dLSO5hGpYDr80fUB2p8UBcCFTEUwHw9ufR7/Uac0Gzcc39tOloDR+dKiWQSOM9gYCPGDxc1a3x4ss//65FFLMUbXGe//k50SeTMbfNXK67BQ24PzwrRsVCGA/1frq0FSg+dKVUmYkkT5YDSJv2PYVh5a/a1YKSh4pGJaNtOi2AZs0heOLS5VVO2+XmSHnk+oPs4d/k9MLCRX68Dqeff5zQ3KeONKjpjh0Ay2yswqcVyQtmHXMlMUztA5UckX4sAqE+CkKj0kDJ+jhI0j/XhLU4PhjnN8++gTM7aJPuOVSRST3qjxVKm54pgMsN2P/6pPgWlXSlWiCCBo/4uv4LVUiQjRRVXLFCukckrlB7Pj2qDnMziNBfAIZ1S9oYJzx6XEAZa6U/TNSZMpAQJhnrKTXPFDdM1STlSe1qLQBTIm31W0RLyRPi/ddvGo6VxGucgqmnvrGz1jGNvjjnw3AUfMMPxnECiLJyEPSF0XWEJi9bisXBwSjIfDe0E1/MkjYRzpvoyCFzfL6lyQoQi2rNZg0uc46kKNc9kvxuXjbdQ46KTfG8Rggs1oiYQ+8zaD7cQ6jF5SiJCvI+/8kfWgggsKYAbDBCxF9ZXiLBWfbnKimuQdyFJR29jXAiJwpjeE2UdkP16EnSgXM96LajhHaTWqfT3Anr6OmBoZg2jQPJwyM+jNqIP2FwKxPLopqQE7v9Ftc8O7z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 1ebbb21811b7 ("mm/page_alloc: explicitly define how __GFP_HIGH
non-blocking allocations accesses reserves") renamed ALLOC_HARDER to
ALLOC_NON_BLOCK because the former is "a vague description".

However, vagueness is accurate here, this is a vague flag. It is not set
for __GFP_NOMEMALLOC. It doesn't really mean "allocate without blocking"
but rather "allow dipping into atomic reserves, _because_ of the need
not to block".

A later commit will need an alloc flag that really means "don't block
here", so go back to the flag's old name and update the commentary
to try and give it a slightly clearer meaning.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 mm/internal.h   | 9 +++++----
 mm/page_alloc.c | 8 ++++----
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index cac292dcd394f..5be53d25c89b7 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1372,9 +1372,10 @@ unsigned int reclaim_clean_pages_from_list(struct zone *zone,
 #define ALLOC_OOM		ALLOC_NO_WATERMARKS
 #endif
 
-#define ALLOC_NON_BLOCK		 0x10 /* Caller cannot block. Allow access
-				       * to 25% of the min watermark or
-				       * 62.5% if __GFP_HIGH is set.
+#define ALLOC_HARDER		 0x10 /* Because the caller cannot block,
+				       * allow access * to 25% of the min
+				       * watermark or 62.5% if __GFP_HIGH is
+				       * set.
 				       */
 #define ALLOC_MIN_RESERVE	 0x20 /* __GFP_HIGH set. Allow access to 50%
 				       * of the min watermark.
@@ -1391,7 +1392,7 @@ unsigned int reclaim_clean_pages_from_list(struct zone *zone,
 #define ALLOC_KSWAPD		0x800 /* allow waking of kswapd, __GFP_KSWAPD_RECLAIM set */
 
 /* Flags that allow allocations below the min watermark. */
-#define ALLOC_RESERVES (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
+#define ALLOC_RESERVES (ALLOC_HARDER|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
 
 enum ttu_flags;
 struct tlbflush_unmap_batch;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 14098474afd07..42b807faca5fe 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3392,7 +3392,7 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
 			 * reserves as failing now is worse than failing a
 			 * high-order atomic allocation in the future.
 			 */
-			if (!page && (alloc_flags & (ALLOC_OOM|ALLOC_NON_BLOCK)))
+			if (!page && (alloc_flags & (ALLOC_OOM|ALLOC_HARDER)))
 				page = __rmqueue_smallest(zone, order, ft_high);
 
 			if (!page) {
@@ -3755,7 +3755,7 @@ bool __zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
 			 * or (GFP_KERNEL & ~__GFP_DIRECT_RECLAIM) do not get
 			 * access to the min reserve.
 			 */
-			if (alloc_flags & ALLOC_NON_BLOCK)
+			if (alloc_flags & ALLOC_HARDER)
 				min -= min / 4;
 		}
 
@@ -4640,7 +4640,7 @@ gfp_to_alloc_flags(gfp_t gfp_mask, unsigned int order)
 	 * The caller may dip into page reserves a bit more if the caller
 	 * cannot run direct reclaim, or if the caller has realtime scheduling
 	 * policy or is asking for __GFP_HIGH memory.  GFP_ATOMIC requests will
-	 * set both ALLOC_NON_BLOCK and ALLOC_MIN_RESERVE(__GFP_HIGH).
+	 * set both ALLOC_HARDER and ALLOC_MIN_RESERVE(__GFP_HIGH).
 	 */
 	alloc_flags |= (__force int)
 		(gfp_mask & (__GFP_HIGH | __GFP_KSWAPD_RECLAIM));
@@ -4651,7 +4651,7 @@ gfp_to_alloc_flags(gfp_t gfp_mask, unsigned int order)
 		 * if it can't schedule.
 		 */
 		if (!(gfp_mask & __GFP_NOMEMALLOC)) {
-			alloc_flags |= ALLOC_NON_BLOCK;
+			alloc_flags |= ALLOC_HARDER;
 
 			if (order > 0 && (alloc_flags & ALLOC_MIN_RESERVE))
 				alloc_flags |= ALLOC_HIGHATOMIC;

-- 
2.51.2


