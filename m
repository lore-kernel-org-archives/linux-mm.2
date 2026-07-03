Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63D71C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 12:33:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F1F36B00CE; Fri,  3 Jul 2026 08:32:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CA566B00CF; Fri,  3 Jul 2026 08:32:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06AB86B00D0; Fri,  3 Jul 2026 08:32:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D6E096B00CE
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 08:32:44 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 684E91404CB
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 12:32:44 +0000 (UTC)
X-FDA: 84947404248.23.E627896
Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	by imf04.hostedemail.com (Postfix) with ESMTP id AC12840006
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 12:32:42 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nnUZmPDl;
	spf=pass (imf04.hostedemail.com: domain of 36atHaggKCLghYaikYlZemmejc.amkjglsv-kkitYai.mpe@flex--jackmanb.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=36atHaggKCLghYaikYlZemmejc.amkjglsv-kkitYai.mpe@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783081962;
	b=3BC1qD0FvXNd/LxWVIL9aQVR8Imh+e26mDba757woIcbJvJh+UyNTIgsrjdN9fdMCYo+eV
	ysBpg/xMN6CG+ovvygkjHH308Mbz7VWX6liDSbp2pzwsblbyUEbxh2SwDFYDq9o4iHf7Rg
	H7/rjPVHaPppx4yVAti6e5JZWmhnJeE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783081962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bD9d5R/Qa5BcsyyPmIa4YCQAd3/CPOGQg2JVFAI3c00=;
	b=PEbO0agRrvIqHxUclkjyZNd7LdsD1HO4RPKnQaJ4bnKALkxJMKZgLvc9QQt+x8o6cK/Fe0
	IKX8pO5dQuU39Iwi70XgpspAVZPVcVtGdh11WuLi3VYQwoyGF06MsicOiI9Q7sUGAUCTxV
	Tv4YIksDs24TG3+liannpNYRAHSG4RY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nnUZmPDl;
	spf=pass (imf04.hostedemail.com: domain of 36atHaggKCLghYaikYlZemmejc.amkjglsv-kkitYai.mpe@flex--jackmanb.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=36atHaggKCLghYaikYlZemmejc.amkjglsv-kkitYai.mpe@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-c092c622e15so44887466b.0
        for <linux-mm@kvack.org>; Fri, 03 Jul 2026 05:32:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783081961; x=1783686761; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bD9d5R/Qa5BcsyyPmIa4YCQAd3/CPOGQg2JVFAI3c00=;
        b=nnUZmPDlfU8sFePhQjQmAwcewkqsfr7hyZsSCwhCqfVbmv0hsloTsYUX6thHGoEjyP
         wOtbt8CdSjujMgMJYfY6xCgEC1vY/FV3MtIyasGqavxmnR1DX9Kn/J8IhB6HtT5EOjjJ
         0BE10gCx2CplaDfNoeX+EEKuSOfpgQqW8omDb3iueM/HFiaMIRM54KXfKgbnyvupjya/
         49mvNZq9ij0Xf0wD5IUaWu8Kfr10eXH7UHGoLomDFrAHi+0WfFLrb2AYM9OyY2zWqP5D
         YYkUGThF8x2Z97YMIYAM0hL7+cqFfm0XPPGJamFT4vxn2UWvjl6dS7XUJnExPf0vq8Tk
         WfZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783081961; x=1783686761;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bD9d5R/Qa5BcsyyPmIa4YCQAd3/CPOGQg2JVFAI3c00=;
        b=b+RDw1gNWqHCZcSJn/0ar9qYnpZBj4/Dj7o8lnXzkkfmxQQtsO+IeCQ8eWeOqaTr1m
         oRYp3U2AshMCWUMVuyoF0Tgk+KaeK82wqprMwpV0qATsSleL+tRQn788ryBhZxFWWFHU
         3uawXhRGIMHkkpjpoPIGww2NpF/c3/UaNFJLpaTS5U0zXFM6i8HCfQW6IHEiRY91ebGa
         BZ9eqXio/SAW02cv07GdyyDqyV7WnfRJeqqJyXP/URq7Hb/k99j7dPp/QnveBMD8+t2q
         W5Eo4BVl0FDte3zrDLCqqdKtwFOuGX+R8N9nZmKXm+1084KD7yxxG1VMthI4BLhGQbZ/
         YIYw==
X-Forwarded-Encrypted: i=1; AHgh+RrCul5PfwtFO1EWEHArVFSDvY+pgaPMu0q8QTsXXdptvDiJTjkQ/bvynwUOy40JsCTTCODIuCYVdQ==@kvack.org
X-Gm-Message-State: AOJu0Yw2eN6Mx5vGd+rILZ7KVzp09vlg2hkg7XZD6JSiuFnUYvh856i8
	bc2r5RWXv/tcPta1cd4JUMPhcm01mWx7BVGpqIA6MV1+UTb7DdaU1PCD2ui4sST0jr4YKdBT6I5
	fy/wqCIYI3VtAVQ==
X-Received: from ejblz6.prod.google.com ([2002:a17:906:fb06:b0:c12:58f8:f86])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:fd0b:b0:c12:9692:791b with SMTP id a640c23a62f3a-c12ae79a0eemr441027266b.37.1783081961027;
 Fri, 03 Jul 2026 05:32:41 -0700 (PDT)
Date: Fri, 03 Jul 2026 12:31:57 +0000
In-Reply-To: <20260703-alloc-trylock-v5-0-c87b714e19d3@google.com>
Mime-Version: 1.0
References: <20260703-alloc-trylock-v5-0-c87b714e19d3@google.com>
X-Mailer: b4 0.15.2
Message-ID: <20260703-alloc-trylock-v5-17-c87b714e19d3@google.com>
Subject: [PATCH v5 17/18] mm/page_alloc: drop alloc_flags arg from alloc_flags_cma()
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, Gregory Price <gourry@gourry.net>, 
	Johannes Weiner <hannes@cmpxchg.org>, Alexei Starovoitov <ast@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Hao Ge <hao.ge@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
	derkling@google.com, reijiw@google.com, Brendan Jackman <jackmanb@google.com>, 
	Yosry Ahmed <yosry@kernel.org>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam08
X-Rspam-User: 
X-Stat-Signature: 8kwxnsomi3q8qo5mofs9jhoefy4rykqj
X-Rspamd-Queue-Id: AC12840006
X-HE-Tag: 1783081962-585355
X-HE-Meta: U2FsdGVkX1+ISEcP1BfFLT5KsgFsoLRGfh03iO7M6wV8C2rhX+Vqhh879xKdNHpPFBRRICHIHPckQyOnEMyCOABz8hbBsBsf7OZahUIoMcwnUM0biVb4cKvkbmpQhMs7cd7fRIMjEe5+qbhJjcdRYpXDeTX6sYGYZGH6Uc197fQLceUUS6e2YUlHM4Zkh5b2hvGHYNPDnIY9v6wcnyLnUejWDdfyvbvqiH905EgKUmHYNMVxA0YqUOXacXKKFcyzSRXG6IDqwQWjyOgMq9Ncocl9cw6qZ+7FBTlscMVkvLNeTH8B5GkgLRZg4aonhxJUavCySd0J2lXy4Ku8timEXiRXAgvAnkLEz+7Z4fQgw/xTuGUF40rrTTptJ0R/c+Dermm9esWEFb7q3Y9+sWyA3AMY359z9uzxOSE0lD0V3B7Bw6mmmqEq1pXxkht0qeQvgbXKEnEmlgjCoKAQGakS0n8iEj3KztAsRh2hRHATg+3DyrSq83j2hlFRuIQPeC9sBHcmp8sotrwf/b+vVoyJ924Z9DhD+JVI/z+SZXXv/iLsYb79pcJ0OWMBMJESJqiV8MBdQ42EuvYh7hUEQSGUtSiWIpqfwTSGiehx0DDwN3OjEP0bVlBLPEFGU0+V5vG6YaVMG654R1jXsQlgu1v621zebApbsNBoOIBry9G57O07jsFtbnKOkrudK/mOgcsK7DgRjW0MPWjiovphJLHrsSKPD8fLWuGmQxJHEzwRr7seenPu5qPPaIohumHtEg8oi1tY4YosDVNSr9QRjVCK6rfL5rptzsqU0PDUv7kxC1bAqo8Mv9sILW3dbWeUzUb5xlSZVgDSF/Xp3/9QOwbjOeN2/eizpNEwIroVcMh1e+qni09ZuJ0wOdc+Exol1dSVeI2wzDRaiClKRhLDnRCdHv/xAba2RVKhiXnL51fDO8nJp6sPp2avdd0bnLt9i0ZKbjbuhqXHBwUnWrdrmz8
 uV01rpWF
 MtNWGWlUrLC/K4QKWoKcvy1lIvIoWYU78rJ0iDyoUi/s/KhCwJNluBoBW155kwhdE65zh24hTwb5BXBKvy8NeI7oHKervzv+3oBG+f3aXWzKEgWqlvO+47KVMGqVrqEnmmMr3f7shmCeBHdFzniFL4w9tJSTsL1YwveLsPy5Bb9gTM5ceL59ENWGYxvqGA641HProjwMeXP2y1FO7pzQ8zfnn6f6Mea1BSMfxpVKFXQvrR+gLDe1urqRnb+qpuxXgMJqjfH0HnZPabgqVcsoYB6zxH/VOwcBRUIx6OAK1FCKYG3zXOZfEDtulrDQHG10lFHacWfpFgV7zjkpVn85c+ko6uLR+pWA5ddCL7D92j3rqv1WA/JGfJtphK5PotRgodwx3FpbIArNadXrHvNtKSgfPwRqTdnUlZrndsdRewRlzgdES5Hm1YTUOLhvk/X26jnhIGExIt2Rnk9NvegqPbZ8G1+hXfR0CE67JK9HftGBIad5maTJ4BFVivm0tpQ0ZLhfV1H2riWfdXjueZ33QdxbCUxMlVu5to50JcNhtEpOnuXi1jY7KPDeOZOi7m99wAwr1W1Mt5pTWUyFwibC8uJ6Xiz/X/KjXNl/vTXenlxg9dB/IwKKka2cAXpyWy7FobEZq/fCpQ2t4IE+9AhxnuFxE+EzDwp75rFU30NBJ+3xPtSbm3MiMAh4XQqQSEi8kYwjnMiHlW3sF5TQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To align the style with other alloc_flags_*() functions, drop this
additive argument and just have the callers do that themselves.

Note you can't always freely or alloc_flags like these callers do
(because of the WMARK bits that encode an enum) but this is fine for
ALLOC_CMA, just like it's fine for e.g. ALLOC_NON_BLOCK returned by
alloc_flags_nonblocking() and or'd by its caller.

Suggested-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Link: https://lore.kernel.org/all/5dcdd1ef-21ad-4ed0-9e8a-0e5cf96b4392@kernel.org/
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 mm/page_alloc.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index cfaf16244f56d..c3b246e67ed14 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3775,14 +3775,13 @@ alloc_flags_nofragment(struct zone *zone, gfp_t gfp_mask)
 }
 
 /* Must be called after current_gfp_context() which can change gfp_mask */
-static inline unsigned int alloc_flags_cma(gfp_t gfp_mask,
-					   unsigned int alloc_flags)
+static inline unsigned int alloc_flags_cma(gfp_t gfp_mask)
 {
 #ifdef CONFIG_CMA
 	if (gfp_migratetype(gfp_mask) == MIGRATE_MOVABLE)
-		alloc_flags |= ALLOC_CMA;
+		return ALLOC_CMA;
 #endif
-	return alloc_flags;
+	return ALLOC_DEFAULT;
 }
 
 /*
@@ -4526,7 +4525,7 @@ alloc_flags_slowpath(gfp_t gfp_mask, unsigned int order)
 	} else if (unlikely(rt_or_dl_task(current)) && in_task())
 		alloc_flags |= ALLOC_MIN_RESERVE;
 
-	alloc_flags = alloc_flags_cma(gfp_mask, alloc_flags);
+	alloc_flags |= alloc_flags_cma(gfp_mask);
 
 	if (defrag_mode)
 		alloc_flags |= ALLOC_NOFRAGMENT;
@@ -4837,7 +4836,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 
 	reserve_flags = __gfp_pfmemalloc_flags(gfp_mask);
 	if (reserve_flags)
-		alloc_flags = alloc_flags_cma(gfp_mask, reserve_flags) |
+		alloc_flags = alloc_flags_cma(gfp_mask) | reserve_flags |
 				ac->alloc_flags | (alloc_flags & ALLOC_KSWAPD);
 
 	/*
@@ -5070,7 +5069,7 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
 	    should_fail_alloc_page(gfp_mask, order))
 		return false;
 
-	*alloc_flags = alloc_flags_cma(gfp_mask, *alloc_flags);
+	*alloc_flags |= alloc_flags_cma(gfp_mask);
 
 	/* Dirty zone balancing only done in the fast path */
 	ac->spread_dirty_pages = (gfp_mask & __GFP_WRITE);

-- 
2.54.0


