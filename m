Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35EA0C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 14:13:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32D236B00AA; Mon, 24 Aug 2026 10:13:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3047D6B00AB; Mon, 24 Aug 2026 10:13:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21AB96B00AC; Mon, 24 Aug 2026 10:13:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F0B4D6B00AA
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 10:13:17 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8C9D38015E
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:13:17 +0000 (UTC)
X-FDA: 85136355234.30.CC76591
Received: from flow-a3-smtp.messagingengine.com (flow-a3-smtp.messagingengine.com [103.168.172.138])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9102C4000D
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:13:15 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="i P63UKX";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=LJp4A8dO;
	spf=pass (imf12.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.138 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787580795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sGr2voTn/4URYLRPHsH5IQjOMwzItseS07qYBk1Gieg=;
	b=ksm9h+V7whVHEz+gYbw96zOCsL/m75j1m3egQ4VvrbXnvL5v+wPudvrR2yc/FtbuDD2KA/
	ri42jdN6dbmdyMnnUUvyUA1m3+mBZys7H8eS/7rve7kcAzPAHNOpty2Bs2FixU06HFm2UL
	xbPsbnPbE3tdy++/RpATiYLplh7zWW0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787580795;
	b=dKZL4CoFlh///RVB90AmNxZd1eBKcBnqew06umaRwDtl0KeT8yafZC+ilo1Nqrcifi7BvA
	oDhpqSQ+L9YN4joJR6B8/ZhSzeEGNOi1P+f+HBc3C2ObjdItiqFmJotlMeDINxgBMxq8YI
	4Vydm9lE6XJubVcArnqrAYGTblTLMTI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="i P63UKX";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=LJp4A8dO;
	spf=pass (imf12.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.138 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailflow.phl.internal (Postfix) with ESMTP id C01AB13801E4;
	Mon, 24 Aug 2026 10:13:14 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Mon, 24 Aug 2026 10:13:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1787580794; x=
	1787587994; bh=sGr2voTn/4URYLRPHsH5IQjOMwzItseS07qYBk1Gieg=; b=i
	P63UKXBP8FWswjF/FJlq4Xe5RuBitvDLEwD8PRAfeP1vVx7qDO4r6OYRZXmj+W0t
	tDOyEyhf5c8Scg1TKL9sAw/u29dW62XdNZwmqMNPKFfW7dId/14J2bIuizLUuVN0
	DlB/pVYr6sFZvjCwzSg33ZbNs4RapL1uzskaySoqxUVgRM4DjrRS1X2szQ00frjk
	ZKaVAtonwJ9JaSAIMnbOSWqtF++OCB+EgxhE023V7z2jSFX1BqEJCijQF8ydXBFl
	auHff9b5YmubO7F4qR6FiCuDuBSHnjTi0oiBy8OQhh2o5k6IumQiI8gy8hqWoRGV
	L5iZnJE6j91qvSZ1E+ZxA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1787580794; x=1787587994; bh=sGr2voTn/4URYLRPHsH5IQjOMwzItseS07q
	YBk1Gieg=; b=LJp4A8dODexTNZs9bjp5DL66g1d5YmYaV7coiiH+CHDFA+Fbkre
	tUJERgfHrm7Qlvp0+susDmaoOGy3YSydw9lqs/fYMFq2E3NNJHtEPwmeCuTq9ViF
	BaUdGBAp7Klbw2bNRUFydjJW1za/PLpnGBKAp54D9173a9vIHyClLrcJ3jJKJsdR
	LSBnLPB1zfvmeyGYzRIDuWkXt0tq7uV0m2h09F/rOKf+mvvIqIHtkjXJLu40Y9No
	p4p1/CwDACcBrxUTgFo5Oib/DB1cRFDTs3Eo7ArLPOLRqI8Bf0yp/5eFdfDTZKw0
	Cmv58vWr1LsoL21X9rPBWSRunWAb+mWcZfA==
X-ME-Sender: <xms:eVGMauycaxCMdTcnp1y1QWw_D6lleTd19bjLITd2C652QPNRK9toiQ>
    <xme:eVGMasRtYe6KFwnjhXkHQWeawG_31huk7tibYvH9EG-qd8jEoamhsWYQA8sef7f1A
    GX8mX423r4d6L-DbmtaaAer0ga5PAyXZXFYS3GgTNnRRXJJa3RJDxiv>
X-ME-Received: <xmr:eVGMakm_LNNfHOpu71jD34d4L0L4jGRodYEtSYcS14sDAt8XlXFf_Se3XBw>
X-ME-Proxy-Cause: dmFkZTE7iU/l2zFXlLm6D9uRhnO1/wflet3q+zsqBlow1mhxui5biosheq/DUvb+sEp8I4
    u5xTPAy8JgVzFf9/CoE7YYrHLc5rYr517ogPvopNib6F2BhJHz6NGOEF3SHm6tpstAzEnN
    ToMISdvRE9aRDWeuLzS//ajnynzaNGH23UJb4fOI6RwZbF/lkNEl9T4D+sexmLzQxxW064
    l4aJAPm8Orlkj9Wd3FcL2K1mfJsjeUGGCUYyNiXpvp9HFN1k4RxcZFRqiV7ZR5wb+YQqjL
    es/DEbU54mnSDFtJ4ONeUw4zGwcjFfHoT4/e5gdG5u1t0NETVKXv13PvY6vqFUDjQzBsDH
    2YbgCTXaJ1OYnkDCZff9lqECEFKHJraRpdl9SE0g+OacFeYVy+ThxVtzgpDCQ2ZYt/bCnA
    JUg7E09T/4aT1XW1yj5PnuFFh61+1xlUVDgGfhxrXUOx1nGkAYnR4aGnEevmQaXC+gEFml
    ZNjgwAW/ybMSwrUbcsWlD+C3MWWud/lbvHG7bnkRCmmaz76B+sJ8s6+TKECEPe4xguM0mc
    frXmQxJT+tnA6n4KQFlu4L30J9XxgUGNlT7pyAY1jUOJ1l5ZM+QMhvXWAJlDt2kY6wsb9Q
    q8PyiaMKdBFA8+feyH45AyL5eieJBM+ptL6naQQ6sq13QpRm6lgqA2Oo/WwA
X-ME-Proxy: <xmx:eVGMavfNtlTP7Lsq4aVMTy2uLrsuD1h3opeU380pLrYt1vKnvqPblg>
    <xmx:eVGMakwzPQA3U728von2Cw5b_63ZT9RaUCTekzomux7nN_igpKguVA>
    <xmx:eVGMau9vtffz42aGk-oz0B5zzKsxvCCUEcX_7wiB8s87rDPCoQhTKA>
    <xmx:eVGMaggx8W7vuaj-0Ryg5h3Mlj7Er2lganIMx9wnnBKohip9lo5gBQ>
    <xmx:elGMauE2LyNzGIuYbG1iCBrneZds_h9zBu0UwUfJNl2Z4B1Ty-CpRWRo>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 24 Aug 2026 10:13:12 -0400 (EDT)
Date: Mon, 24 Aug 2026 15:13:10 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Lance Yang <lance.yang@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	nico.pache@linux.dev, baolin.wang@linux.alibaba.com, baohua@kernel.org, 
	dev.jain@arm.com, hughd@google.com, liam@infradead.org, mhocko@suse.com, 
	rppt@kernel.org, ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com, 
	usama.arif@linux.dev, vbabka@kernel.org, ziy@nvidia.com, usama.anjum@arm.com, 
	agordeev@linux.ibm.com, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, jannh@google.com, willy@infradead.org, pfalcato@suse.de, 
	rostedt@goodmis.org, mhiramat@kernel.org, linux-trace-kernel@vger.kernel.org, 
	bpf@vger.kernel.org
Subject: Re: [RFC PATCH 16/57] mm/collapse: freeze the sources behind
 migration entries
Message-ID: <aoxQnuEacGpzp2I7@thinkstation>
References: <20260816224609.308019-17-kirill@shutemov.name>
 <20260824131224.73344-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260824131224.73344-1-lance.yang@linux.dev>
X-Rspam-User: 
X-Stat-Signature: fbmatumdwfjhrx6qufezyd9uonzqypsr
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9102C4000D
X-HE-Tag: 1787580795-283351
X-HE-Meta: U2FsdGVkX18imdsXCVN7amASeYlkw8bcg0H+dIwaJcmC2wuiNx+UbMUGLUPe9K0i/GJkIE8h8RT6eSFAhs816qG9o85xoZn2G4m0ZSEUU7PO+xUC0ad+G8jXIFhYQn0v1KOyZBzgHSuhPptzmfUzxk+7j9N0INvsNUVghX5P1hevTWgQ0LSzqQej600CEvnFw7ei+Y+50pHQTnu3mMMDonVThYMR/FqnYdrwbgYlnS6rYoSeaIW+EYOEsdA3t9g1sUdo+XShVI4JVf1cnOezwdkBcs6wtv7MKaLD3nesfwyLAm3K705gRkdAQinJ1qKjkfPmDFowHFQuiO43naqmXoXJVEDNIZDO/nEw2weTttwZVRwV//xjL0ciZnMbeP4xTzgOUkU2d+JEDuspNrEA8rYyvynldsrvKB3T3R9zTx6Fg5EOcflsOhNkk72dxDTdI889kyF1nlMpqILdqDjZsAtR0X/7HuZb8cdZj/ZKFWB6SYe3oPHgryvE5r1lQp+QPkOa9vwn3AdO75v28zjNg+aUPIDCo53z2Kml9cdb6g9AvmjToLvrVWgIukgrko5bwobkT4nUz/2fnVtDF4J/SFOuiufYBhepianq4/sKX4R1Ge335KjDb0z/vyB+4WNItTCyMFIKKQ+t27y5qvgb7ot8A7Ix6sHsV1I2+3E0x3JXQD35ogmdbM1QxyqgfiFuMtCmz/5RezZ/qeOvsv6TcnRB2bYtxYbQfLXF1izeuuOpSFnDeDJFE92C7A+fMYf5+joYdAScRHIoQyYKv4fR8sYuN6GQVDgQRN0WvuBR9GQy/dTUatf/oI92+xuonLbbfXBcMG8pY5jZrxkZzvgTs8h3Vx8mjJS69S6Ony2QmM0ztowQoNU/pP3Hu2w1gAXW7ZC9rDZ8PwhtNKDVlRbZB0foVsEsrAxy1aRZ0yXF+Q0rZC2Kdgf3DsA8KHS33Pt78YzXbiKin1mziS1sDud
 rwZ/k6+3
 1BnJlckEJHwDKNfITaJCUitVXrLVc7Sj+mfmoeLbQnvX+vXXijVoULYq54PwFzynjy1qBnOY6P5M8e3bGB8zjvzs0tkZxUD34kakl8OC77YCYoPPASLC2UpkOFSNAXk/+yIOIqsmJnl7VzlL0Py5zcBuZx1ajA7wOfpNdbHoEuem1IJlYJ4M3wRkVX3pMOH4zMd76tGZll7rb9EJTJEGz0zZf+He8lZBRh/fUWzkEFvKFjAPrTMK1Kv6Ze9RMUwigoQs+5VNQlmjSCuXgOjBAXA9m1AMDVVDc7rQloXmVoEraG2dBIFtPWSFFydgRL2recVKIs8rITNbLe1LIzZLSpBDFT0CR4hJADhsEJkxMmNuQcJBqQeGyN+4uMnN5GMbILVjYsO5nsYfJFOkYPstvirnpXZIIQzjWAsa8gj1bLQOCA3xBWjbm1TmRpd/wTPzqTGnF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 09:12:24PM +0800, Lance Yang wrote:
> 
> On Sun, Aug 16, 2026 at 11:45:28PM +0100, Kiryl Shutsemau wrote:
> >+		if (!folio_ref_freeze(folio,
> >+				      folio_expected_ref_count(folio) + 1)) {
> >+			result = SCAN_PAGE_COUNT;
> >+			goto unfreeze;
> >+		}
> >+		nr_frozen = nr_saved;
> 
> Just one thing I was wondering about ... can deferred_split_isolate()
> remove a source folio from deferred_split_lru while its refcount is
> frozen by collapse_freeze_candidate()?
> 
> Assume an earlier span belongs to an anonymous large folio on the
> deferred split queue, then a later span fails folio_trylock().
> collapse_freeze_candidate() continues after freezing each source folio
> and calls collapse_unfreeze_candidate() on a later failure:
> 
> static noinline enum scan_result collapse_freeze_candidate(struct mm_struct *mm,
> 		struct collapse_candidate *cand, pte_t *pte)
> {
> ...
> 	for (i = 0, addr = cand->addr; i < nr_pages;) {
> ...
> 		if (!folio_trylock(folio)) {
> 			folio_put(folio);
> 			result = SCAN_PAGE_LOCK;
> 			goto unfreeze;
> 		}
> ...
> 		nr_saved = i + nr;
> 
> 		if (!folio_ref_freeze(folio,
> 				      folio_expected_ref_count(folio) + 1)) {
> 			result = SCAN_PAGE_COUNT;
> 			goto unfreeze;
> 		}
> 		nr_frozen = nr_saved;
> 
> 		i += nr;
> 		addr += nr * PAGE_SIZE;
> 	}
> 
> ...
> unfreeze:
> 	collapse_unfreeze_candidate(mm, cand, pte, nr_saved, nr_frozen);
> 	return result;
> }
> 
> folio_ref_freeze() takes the source folio's refcount to zero:
> 
> static inline int folio_ref_freeze(struct folio *folio, int count)
> {
> 	return page_ref_freeze(&folio->page, count);
> }
> 
> static inline int page_ref_freeze(struct page *page, int count)
> {
> 	int ret = likely(atomic_cmpxchg(&page->_refcount, count, 0) == count);
> 
> ...
> 	return ret;
> }
> 
> While collapse_freeze_candidate() still holds the source folio lock,
> deferred_split_scan() can call deferred_split_isolate():
> 
> static unsigned long deferred_split_scan(struct shrinker *shrink,
> 		struct shrink_control *sc)
> {
> 	LIST_HEAD(dispose);
> 	struct folio *folio, *next;
> 	int split = 0;
> 	unsigned long isolated;
> 
> 	isolated = list_lru_shrink_walk_irq(&deferred_split_lru, sc,
> 					    deferred_split_isolate, &dispose);
> }
> 
> static enum lru_status deferred_split_isolate(struct list_head *item,
> 					      struct list_lru_one *lru,
> 					      void *cb_arg)
> {
> 	struct folio *folio = container_of(item, struct folio, _deferred_list);
> 	struct list_head *freeable = cb_arg;
> 
> 	if (folio_try_get(folio)) {
> 		list_lru_isolate_move(lru, item, freeable);
> 		return LRU_REMOVED;
> 	}
> 
> 	/*
> 	 * We lost race with folio_put(). Read folio state before the
> 	 * isolate: folio_unqueue_deferred_split() checks list_empty()
> 	 * locklessly, so once removed the folio can be freed any time.
> 	 */
> 	if (folio_test_partially_mapped(folio)) {
> 		folio_clear_partially_mapped(folio);
> 		mod_mthp_stat(folio_order(folio),
> 			      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
> 	}
> 	list_lru_isolate(lru, item);
> 	return LRU_REMOVED;
> }
> 
> And folio_try_get() fails because the source folio has a frozen refcount.
> deferred_split_isolate() treats the failure as a race with folio_put(),
> clears PG_partially_mapped and its MTHP_STAT_NR_ANON_PARTIALLY_MAPPED
> accounting when set, then removes the folio from deferred_split_lru ...

Hm. So, the premise in deferred_split_isolate() is false:
!folio_try_get() doesn't mean lost race with folio_put().

I think deferred_split_isolate() should do something like:

      if (!folio_try_get(folio))
              return LRU_SKIP;

      list_lru_isolate_move(lru, item, freeable);
      return LRU_REMOVED;

Johannes, do I miss something?

> 
> >+
> >+		i += nr;
> >+		addr += nr * PAGE_SIZE;
> >+	}
> >+
> >+	cand->state = CAND_FROZEN;
> >+	return SCAN_SUCCEED;
> >+
> >+unfreeze:
> >+	collapse_unfreeze_candidate(mm, cand, pte, nr_saved, nr_frozen);
> >+	return result;
> 
> And collapse_unfreeze_candidate() restores the source PTEs and refcount,
> then unlocks and puts the source folio :)
> 
> The source folio is not added back to the deferred split queue, so an
> underused or partially mapped folio can remain off the queue.
> 
> Should collapse unqueue the source folio after folio_ref_freeze()
> succeeds, remember whether it was on the deferred split queue and whether
> PG_partially_mapped was set, then requeue it if
> collapse_unfreeze_candidate() restores the source folio?
> 
> [...]
> 
> Cheers, Lance

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

