Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCEE9C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 14:55:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1F1B6B0095; Mon, 24 Aug 2026 10:55:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF6816B00A2; Mon, 24 Aug 2026 10:55:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0C476B00A3; Mon, 24 Aug 2026 10:55:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 95BE16B0095
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 10:55:48 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 22E0A40141
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:55:48 +0000 (UTC)
X-FDA: 85136462376.20.83C38C8
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	by imf12.hostedemail.com (Postfix) with ESMTP id 41AF64000A
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:55:46 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kXZSxNa8;
	spf=pass (imf12.hostedemail.com: domain of hughd@google.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787583346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z3p4N+WdGfy0YyEKXl3GFU0ih7nRgZs+zJqtEvKEyhU=;
	b=HdwmXTOAW99Z9/U43cgRuua2nTXJwtZQCld6VZGsoheye3X+tZLB1lRUWRsdMt6kQhNPHV
	nwZn756BQxJaeeafSRo51DmIHUeqkyVXvwN+raolvnoanN6QfYxjmNDYBe8rxIDVbb+e8z
	jejEYr0vrH0EecI0p5qZlziEhRfghhk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787583346;
	b=JPpoGfIN2lGeeMXmY45Tv+AA5VrHgaBRAWPrELEssOMFpDpN4L4Ua/Sh0bfLWrZOOZhlNY
	80WSqbFVWAiZWf2lEpJPn4LinIiSKTJApxUygpFUTqzrrGaJuY+K2lb7lUt3ydhhsOnDGl
	PP3oVl2jMKnaoo5MNvPB0cGGkXxye6w=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kXZSxNa8;
	spf=pass (imf12.hostedemail.com: domain of hughd@google.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-836cde02992so43288097b3.2
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:55:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787583345; x=1788188145; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=z3p4N+WdGfy0YyEKXl3GFU0ih7nRgZs+zJqtEvKEyhU=;
        b=kXZSxNa8rcCPJFgHqQVyo8WoMX7PqeeQyW2PEShtlOD6gbHN+50Juth33GGfWZIrJR
         SY73p2FtLPZWe54OY5jwKWksk/EsykoM6T2yKxXf8PsxBDL905GXGTN7DBiGwj31Uuvb
         Rqqz2JoBrRH9IGGg9nqOaXkqKe/lQfcnelCd6Luo386fnD/vwXik4nHId2d+M8F+weXu
         2oU91E6ficpYv8JPo0N6wjOR66iqmqyDXMz9O8aZmKopE42iwefH4eWhHw7FkUruIpdT
         gDRylXOwvQc9Azayw9Trw2/IQnI5BvtR0abhHRD/kxg3odQy2lTFUbQMl+Yu2rnKrOYi
         PUCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787583345; x=1788188145;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=z3p4N+WdGfy0YyEKXl3GFU0ih7nRgZs+zJqtEvKEyhU=;
        b=bEHbeLKHuoD4JdBg90ssPv2OhVh9wgk2E/GbVPw79u/6S6XqaU+o76ADq8wGWIAf8J
         EoMd8YO3Ey2505j1Cz+PyWjnzR8HCc43sQzmf4sgMO7V6ot7KEjGKojBKjnRCL0GNGzY
         sf8kXxh+HnJ2gql12VymULA2Yfzk03xkWlyX+ZzXhVMxD0UKrhrvw8D+erej9fq7QkOe
         zYVaAiwHAuxZZxc12pO48mPPauzwBG8iIxnxJnZcxnOU/tSlsUuy1srrH/F8m6dTeTs9
         LqvUJR9bwWSubiQTbtDoPAP7ffkH+eADMrNm6UTcHHILM/NGn0gFTD7It8k6qVwwO9bo
         gg5Q==
X-Forwarded-Encrypted: i=1; AHgh+Rqa7uSAenHpYFTltIpm2H7CQDJ5yd0hk9ilFVc6DhedE2QuPDXbuTYBEazG+vlSqTFWLLJ7Km/VSg==@kvack.org
X-Gm-Message-State: AFuF++m2CQpzoL/vqLOmVUqN+E8nhxpCoQKfnoxmGFfBtCtBXG5sT8Rg
	w8bNnJiPDFK/E5cV9rH0OKK6TUYRxWswkrMz0sjEtpppkMERl8izvblPtFtwswd3tQ==
X-Gm-Gg: AR+sD10UzNzKedKcxgteVnvS9RdKY04wGwMFhXTVT+CLUk74Px1tWGH1KidoAFw9tkR
	Jao3LNHIXXCDQkkjdAVLCMZlSVpp3RvJJo6759wvCn6Q1JvCG31FlXavCQhlX0pO9ZbLJfY0C7g
	7sXg8Azq3lsnJ8aBv8fUsyyZdqXP0r2bnE+m/d2GlnUAY16CM//IXNETNhEa3vdCNOtT1EVR02n
	yZMHeT6w0S7WJ2nJA1h8YUPY1XNqNsQHEmLrMKriwqPa0s6mru8u5z5YAmGTIyjR5pBUkUJBK6+
	dXWGtHi+kG5UtL6f7Ur3qTLAj1gJOpwr9NPWh5dC/WwGwmdhoHopvQ+ChR3kLhTRTQPohg658dr
	Bu2QyRsP5E7vnt5aJi9imgOsqvHGS8ZZS1Sv2VQ5a54NUEeQ/kFoly4P6RMaE2u1Mpy7wnqc2M+
	dn4GsFxb5l6oBvqvNRafqP2qoteFlRtaM6TWBVKtpsaYVsJwgRPzentAufUUKpGRWHKifiSYgcj
	YwNJO0xAkyfgRzUv7cNbWHt7nYMeifqBRK5InLus1eURdRp
X-Received: by 2002:a05:690c:b96:b0:845:ddf4:a399 with SMTP id 00721157ae682-849f3007b00mr110178637b3.11.1787583344519;
        Mon, 24 Aug 2026 07:55:44 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-84ca5c2c52csm35086077b3.11.2026.08.24.07.55.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 07:55:43 -0700 (PDT)
Date: Mon, 24 Aug 2026 07:55:39 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ackerley Tng <ackerleytng@google.com>, 
    Alexander Viro <viro@zeniv.linux.org.uk>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, 
    Barry Song <baohua@kernel.org>, Binbin Wu <binbin.wu@linux.intel.com>, 
    Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>, 
    Christoph Lameter <cl@gentwo.org>, 
    Claudio Imbrenda <imbrenda@linux.ibm.com>, 
    David Hildenbrand <david@kernel.org>, JP Kobryn <jp.kobryn@linux.dev>, 
    Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, 
    Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <ryncsn@gmail.com>, 
    Kiryl Shutsemau <kas@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
    Leonardo Bras <leobras.c@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>, 
    Marcelo Tosatti <mtosatti@redhat.com>, 
    Matthew Wilcox <willy@infradead.org>, 
    Mel Gorman <mgorman@techsingularity.net>, 
    Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@suse.com>, 
    Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
    Oscar Salvador <osalvador@suse.de>, Peter Zijlstra <peterz@infradead.org>, 
    Qi Zheng <qi.zheng@linux.dev>, Rik van Riel <riel@surriel.com>, 
    Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
    Shakeel Butt <shakeel.butt@linux.dev>, 
    Suren Baghdasaryan <surenb@google.com>, 
    Vlastimil Babka <vbabka@kernel.org>, 
    Yang Shi <yang@os.amperecomputing.com>, Yu Zhao <yuzhao@google.com>, 
    Zach O'Keefe <zokeefe@google.com>, Zi Yan <ziy@nvidia.com>, 
    linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH alt 13/25] mm/fbatch: no lru_add_drain() to
 collect_longterm_unpinnable_folios()
In-Reply-To: <fbf3fa74-c646-8855-17e4-e8b35dfd9c14@google.com>
Message-ID: <333bb765-a36d-e07e-d3c4-5ea2f1cadfcb@google.com>
References: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com> <fbf3fa74-c646-8855-17e4-e8b35dfd9c14@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Stat-Signature: 6n8g3k17s6espoh68nn1zc64capr4yda
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 41AF64000A
X-HE-Tag: 1787583346-505484
X-HE-Meta: U2FsdGVkX19lraSMHvq+KmcAE4i97/tFjYeKtF/29rEXN85UfxWl05I+5EaypiFHbf35PI+7knqHi/0jlYjHkVcAJFkK65c6lO6Mur1VFVLwJ7JRVEnjNH+oT4tcFuvRJ3rMPdL0k5QaMd/YI8Roz9jflQxCuC9DQy5htxfqGkQN4ePCQNsgIuNA3XbwS3dWv5MW3vGgQGxkDgfV6VFuV5CAfEMEXhHbSqCmJNv7SfGyDo1uCiYFphhcontXepBZX7g53EzWis0ASH2Mb1piYeN60Z8Azd9M7kMTmvEZNDphLSsk5ocKVp45FC7RIMdlz7IDIau5drRLYFzVZALPUMaBi+JUayE0tV+vIHXXh47Xsd+7BxwzAZVVLNGYRHdhICMndTaQ9xJW4aOsaik9ihRkFqtNb3IG+sIZoOnw8zLPoTl7zhthnPNXVAddsexwf8UX5NwZi6Z3yeZydbPjv7QedzDVCH4jf49akUG+xsT+RwQcFGj2/i1SFX87jgb7FfFJXSNdbT3DlegecdJyXa10gZ0AL5H4c6SyVHulmCrHfLdU9w2k+T1DOPwFwIhmoC0jhxzi+UzLQHBDnPT389YJYzFJf56nid6zFwTySoO1wANQn4PyGuLuMlNpUtlnkHr2pNFk5cwb+//wWd/MbZevBq5DI90qO+3CfDyK+Q2tI+Zh5ojnOrfcPtUfXHXWkU+vGL+X6IuMkfzRzxsqceUNiXSKS2JC424bcge1vL5UWXcC34ab60NtmHluAUXi6XwVN1TalR20zCRoW9TqgI0S3iX4wmMDx2LtM1ETZL4n0u/xYO5uU5W7+dBv+NUcsFpHkAYp+BFOTjM2jEUG9agwENOf8p8BITcUaNfziJ1it7e6ATbf1hx1b51xyuPdQaFs3OfBZ5NxJ3BPgAqD159okF8T63jSjBgi4szfXu0RWFZKNxuHWKOlejWWsN2qIYD0zWzsgGp3/yZQM/a
 7Egb5cyD
 NX5kjMKH3kkL5xPfEBVGHqproMjHyVNfFyHvHkde/fhTNXrYV2Uhc7vfztBoTfBM2qioqJ8lUOdOMF0pQHtAI2a9B1qmPmjoQmDuF2GUJyqrYxg1qyc9etDRGVkmZDiwXlvOwQ5GvDIpyohWncudb4LKpQGh1wabuegRkMEMLZWDAWQnJTjz+vvi/ejzljIsgGL+aHIV+5QmukEhfiF8/R4F8SXGBrci2Lj9hZnZiH68JCP4mtRagoMB+FqW5/HvE3ED/IgMrIE9/Fr9VetcInP+OZqbZlq29S4w1NeU1V7vM5LpzZlFS1dRZWrErhcJo+6jwVmWl46ksrkiO0k5IM7dG1lX8KkfLYnXKnIhzLP0oOTqytJ5uD9iT14k1hK3oSGAZtXvKdLgRnpwOStDaB+1rNDq/uD46Lhzu3g0Xdxc31zy0k/zkvOZNB9Tj46DcBVzpVm+iGgGJ4z2ETrASF+auxNT94MF4S5csmPoCYhzAAwUnlzoXnIXwf7Brox1MjIdcR8uBYl+PCPQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

collect_longterm_unpinnable_folios() has no use for lru_add_drain() nor
lru_add_drain_all(), now that the per-cpu fbatch references are gone.
So remove the recently added lru_cache_drain_for_folio().

Signed-off-by: Hugh Dickins <hughd@google.com>
---
Alternate version for use once David Hildenbrand's two commits
here have been pulled from mm.git into linux.git for 7.3-rc1.

 include/linux/swap.h |  8 --------
 mm/folio.c           | 46 --------------------------------------------
 mm/gup.c             |  9 ---------
 3 files changed, 63 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 17c60956c553..ecb877fe61ed 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -302,14 +302,6 @@ static inline void folio_add_lru(struct folio *folio)
 void folio_mark_accessed(struct folio *folio);
 void lru_add_drain_all(void);
 
-enum lru_cache_drained {
-	LRU_CACHE_NOT_DRAINED,
-	LRU_CACHE_DRAINED,
-	LRU_CACHE_DRAINED_ALL,
-};
-void lru_cache_drain_for_folio(const struct folio *folio,
-		unsigned int extra_refs, enum lru_cache_drained *drained);
-
 /* linux/mm/folio-compat.c */
 void mark_page_accessed(struct page *page);
 
diff --git a/mm/folio.c b/mm/folio.c
index 1c03b44362c1..7b309059b302 100644
--- a/mm/folio.c
+++ b/mm/folio.c
@@ -842,52 +842,6 @@ void lru_add_drain_all(void)
 }
 #endif /* CONFIG_SMP */
 
-/**
- * lru_cache_drain_for_folio() - drain LRU caches if the caches might hold
- *				 folio references
- * @folio: The folio.
- * @extra_refs: Extra folio references held by the caller.
- * @drained: Drain status for batch folio processing.
- *
- * Drain LRU caches if the caches might hold folio references. Start
- * with a local LRU cache drain, to then drain LRU caches on all CPUs if
- * local draining was insufficient.
- *
- * This function detects LRU cache references by comparing the folio refcount
- * with the sum of the expected folio refcount + extra references held by the
- * caller. Note that we cannot rely on PG_lru to reliably detect all LRU
- * cache references, and there are rare scenarios (concurrent folio (un)mapping)
- * where this function might miss detecting LRU cache references.
- *
- * If @drained is not NULL, the function will avoid re-draining LRU caches
- * when processing multiple folios in a row. In that case, the variable
- * @drained points at must be initialized to LRU_CACHE_NOT_DRAINED before
- * the first invocation by the caller.
- */
-void lru_cache_drain_for_folio(const struct folio *folio,
-		unsigned int extra_refs, enum lru_cache_drained *drained)
-{
-	if (!folio_may_be_lru_cached(folio))
-		return;
-
-	if (!drained || *drained == LRU_CACHE_NOT_DRAINED) {
-		if (folio_ref_count(folio) ==
-		    folio_expected_ref_count(folio) + extra_refs)
-			return;
-		lru_add_drain();
-		if (drained)
-			*drained = LRU_CACHE_DRAINED;
-	}
-	if (!drained || *drained == LRU_CACHE_DRAINED) {
-		if (folio_ref_count(folio) ==
-		    folio_expected_ref_count(folio) + extra_refs)
-			return;
-		lru_add_drain_all();
-		if (drained)
-			*drained = LRU_CACHE_DRAINED_ALL;
-	}
-}
-
 atomic_t lru_disable_count = ATOMIC_INIT(0);
 
 /*
diff --git a/mm/gup.c b/mm/gup.c
index 98fdf7b7baca..e87a77dacdb6 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2273,14 +2273,12 @@ static unsigned long collect_longterm_unpinnable_folios(
 		struct list_head *movable_folio_list,
 		struct pages_or_folios *pofs)
 {
-	enum lru_cache_drained drained = LRU_CACHE_NOT_DRAINED;
 	unsigned long collected = 0;
 	struct folio *folio;
 	long i = 0;
 
 	for (folio = pofs_get_folio(pofs, i); folio;
 	     folio = pofs_next_folio(folio, pofs, &i)) {
-		const int pin_refs = folio_has_pincount(folio) ? 1 : GUP_PIN_COUNTING_BIAS;
 
 		if (folio_is_longterm_pinnable(folio))
 			continue;
@@ -2295,13 +2293,6 @@ static unsigned long collect_longterm_unpinnable_folios(
 			continue;
 		}
 
-		/*
-		 * We drain not only to make the folio_isolate_lru() succeed,
-		 * but also to remove any other folio references from LRU
-		 * caches.
-		 */
-		lru_cache_drain_for_folio(folio, pin_refs, &drained);
-
 		if (!folio_isolate_lru(folio))
 			continue;
 

