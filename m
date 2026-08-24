Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51E87C61CE3
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 11:20:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3480C6B00A7; Mon, 24 Aug 2026 07:20:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 320996B00A9; Mon, 24 Aug 2026 07:20:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19A9D6B00AA; Mon, 24 Aug 2026 07:20:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E88A26B00A7
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:20:17 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 79067A0508
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 11:20:17 +0000 (UTC)
X-FDA: 85135919274.19.580E144
Received: from mta1.migadu.com (out-157.mta1.migadu.com [95.215.58.157])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4133FC0009
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 11:20:15 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cBxRjeXT;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.157 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787570415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8YHH8OzbpTBavnezZBWkTDGGKss28zyQvPl+GI29ZfE=;
	b=WVGBFRaS+95LxE+sANZQOv46y+fPoRm8maWGSNVUaG2UoDNu92zZySDphW94tm7cb2p7TE
	pNrw5UPyuom350I4fMgD14vdwBimLqbRxPLJy/tuOLjDTW1BFU6+qNO1+I2lpbl7KwqMa+
	08kEzEJ/L46j8kXjm6nXjGCdgK1QpY0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cBxRjeXT;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.157 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787570415;
	b=ddKJInQN18M+W0SDcrbg3Pd9mheCP/OryRtOw1FOKbLTgnMo9rWO2rjeNXfh+x5GYwr5yd
	ZV0dtDmd8cOdRsaYkome9LPQH5KEct3qX2NvTra5QI50K60t+GdYfEn5jAzVQmlNMQn4zv
	3ZU3Jf+/yzV5cyJCqdGhDKTEQXSZKMU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=YqtmwJj1TSTjAKuc+RN5KV+zNyJi4YEBO9daURTvoKI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787570414; v=1; x=1788175214;
 b=cBxRjeXTr4YoFroncha9ILGDO2EQVAsiq/XLTi7JFU0fh2h2l+dISPpK41qq2aJ9ayS+SWbb
 bBR7d6CG5pmQ3bY+IE2bxmx/rtb/1Cw9FRHCDILGTd23CG6X+mPHKGlJZsZTrngfostncwh1tz8
 7qbQ7fd/GKe1jfnQ9on6DEM8=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2602:fce1:44f:115e::)
	by smtp.migadu.com with ESMTPS id dbcc094937eb36f3;
	Mon, 24 Aug 2026 11:20:13 +0000
X-Mizu-Trace-ID: dbcc094937eb36f3
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: kirill@shutemov.name
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	nico.pache@linux.dev,
	baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	hughd@google.com,
	liam@infradead.org,
	mhocko@suse.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	surenb@google.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	ziy@nvidia.com,
	usama.anjum@arm.com,
	agordeev@linux.ibm.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kas@kernel.org,
	jannh@google.com,
	willy@infradead.org,
	pfalcato@suse.de,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	linux-trace-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [RFC PATCH 12/57] mm/collapse: allocate a destination per candidate
Date: Mon, 24 Aug 2026 19:20:05 +0800
Message-Id: <20260824112005.63097-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260816224609.308019-13-kirill@shutemov.name>
References: <20260816224609.308019-13-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4133FC0009
X-Stat-Signature: um3wmye8633ddqnpw3cojewy81kyadnw
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787570414-99970
X-HE-Meta: U2FsdGVkX19yxZfQgiwDV4zagBEEgEgi+lyXDTcYideSuEJpGpdzqvSuO4d55/XjSh49H3uU84fMBeKTrWpCuzBTOf/oBi85KWSAWEL+2LYhyAKtkLRK8APHz8dZ+WZO+RQ0rDWLPoNVLPGA9R/t41aeWqNGFkwYM4nThilSfDepOmeW/6L5DYDpO8ay7o21gDjWjTWahVjN/iPaii8uXwmgT1MjPdjzzq6sOlSd1rAsc9hl+T/z2T+TxyZRb6BnRHLBbHvryrgp4I/znTjSHKR4QOOfDGYtpT0YxwHN00hnRXS6kXgSESOjfJvjcRF4DcdGxyXdp6R+JUI/NoBocKN+JI8TnYUI4IfndhTyUDX3DFXusgHYxqhfZlfYvkMXatMIoXWdW1ZElhxSZvm65gsUCsDsbCSg5jDLGfR9LsleFU2JVId8HlYFd4a3g2UBohyWcII9sJmLDWYJSQ5K2mFJ9n6spW8yMmiBxtIxL1LzFBIpisa/96Tbzul4Pvbxs1UbpJR+B5F4iyPSqlLWevlF8WIP49ZeubQVldLW1AO0Iu0wWqJt6rW+uSzFn9K9jZLCZzquCiJeG90JckZmaWjz+T7b/OP89qJMRjmDPenmkSgebfEvtWpR/JodCWWTowcLYytHB1AMCe45ZCoNA1VD2Oe2TzLhWvPl5zls97LVdDMkOoOfQK8ntSK1VPsXVq12557TBAYtXRVxPAnFgw6P9DncSxyIxsHG19Nlf1RXKwYrUzUpXA9Gmtf4forOb8BnAnMFzzRLav7Zqxi5k1WA6ejo1lXxEJ/1BIcVazV8buntUamUCTxbgfugNdkC/KFz/RqnC68LJTOPf7SGYp1mEmAMjZLKJuHyPicwciJg5wRh/YXY/OaUXCVQnOFIkCIFf2I47VfoLrgMsQEHzFH3aNw+BVLo9PljiRGw/0L2O2ExDg/e8PIxcJfiUfDc1oegtCQpy3Z+yz/BDwD
 0jnU6sz7
 0yeFLe6pgoezblMzjZZ7KFNdlYj0+lEjPwudOA2w2CYY7TT3cpdM/O8BWO83VoeIvaHNBTZK1aCtzVrCxFcv2HvH9MsMjwm+fnfRn/K8aqgeqAL++Qa6BnAso7/abqeEYykVCaR/KbJw4GCV/IWPtLwqfdvABMYpePQtYDubdCyFtbKcK4QsMC3yqDwRAQRvsTa9HTPesm04SfqCAnH3lRZndlCJMlkZTXBJL9H67/T8j7YGXHOWO8RpKaSAUTmLxYa8mRVzAIL8+mvscAOFzO5TqaFnsQtBwERJHJvKh49+Ww8ClcDMI3SBEag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Sun, Aug 16, 2026 at 11:45:24PM +0100, Kiryl Shutsemau wrote:
>From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
>
>Fill in the allocation, which happens on both sides of the freeze.
>
>A destination is a folio of the candidate's order, charged to the memcg,
>with the memcg's deferred-split list entry taken up front while sleeping
>is still allowed: the PMD-order install would otherwise need one under
>the pmd lock.
>
>collapse_alloc() does all of that for one candidate with the gfp it is
>handed, and counts nothing when it fails: what a miss means is up to the
>caller.
>
>collapse_provision() is the caller inside the window.  The sources are
>frozen by then and a faulter on any of them is waiting, so it asks
>without __GFP_DIRECT_RECLAIM: reclaim entered there would be paid for by
>that faulter.
[...]
>+/*
>+ * Allocate one candidate's destination with @gfp: a folio of its order, charged,
>+ * with the memcg's deferred-split list heads in place so the install cannot need
>+ * to allocate under the pmd lock.  Those heads cost only the first collapse in a
>+ * memcg.
>+ *
>+ * A failure counts nothing and changes nothing: what a miss means is the caller's
>+ * policy.
>+ */
>+static enum scan_result collapse_alloc(struct mm_struct *mm,
>+				       struct collapse_control *cc,
>+				       struct collapse_candidate *cand,
>+				       gfp_t gfp)
>+{
>+	struct folio *folio;
>+
>+	folio = __folio_alloc(gfp, cand->order, collapse_find_target_node(cc),
>+			      &cc->alloc_nmask);
>+	if (!folio)
>+		return SCAN_ALLOC_HUGE_PAGE_FAIL;
>+
>+	if (unlikely(mem_cgroup_charge(folio, mm, gfp)) ||
>+	    folio_memcg_alloc_deferred(folio)) {

One small nit: folio_memcg_alloc_deferred() passes GFP_KERNEL to the
deferred_split_lru allocation.

At the full series tip, collapse_round() invokes it after
collapse_freeze() and before collapse_putback(), while faults on the
source migration entries wait:

static void collapse_round(struct mm_struct *mm, unsigned long pmd_addr,
			   struct collapse_control *cc)
{
...
	collapse_freeze(vma, cc, pmd);
	collapse_provision(mm, cc);
...
	collapse_putback(vma, cc);
...
}

collapse_provision() strips direct reclaim before calling
collapse_alloc():

static void collapse_provision(struct mm_struct *mm,
			       struct collapse_control *cc)
{
	const gfp_t gfp = cc->policy.gfp & ~__GFP_DIRECT_RECLAIM;
...
		result = collapse_alloc(mm, cc, cand, gfp);
...
}

collapse_alloc() uses that gfp for the charge, then calls
folio_memcg_alloc_deferred():

static enum scan_result collapse_alloc(struct mm_struct *mm,
				       struct collapse_control *cc,
				       struct collapse_candidate *cand,
				       gfp_t gfp)
{
...
	if (unlikely(mem_cgroup_charge(folio, mm, gfp)) ||
	    folio_memcg_alloc_deferred(folio)) {
...
	}
...
}

The helper substitutes GFP_KERNEL:

int folio_memcg_alloc_deferred(struct folio *folio)
{
...
	return folio_memcg_list_lru_alloc(folio, &deferred_split_lru, GFP_KERNEL);
}

When this metadata has not been allocated for a memcg yet,
folio_memcg_list_lru_alloc() can take its blocking slow branch:

int folio_memcg_list_lru_alloc(struct folio *folio, struct list_lru *lru,
			       gfp_t gfp)
{
...
	/* Fast path when list_lru heads already exist */
	rcu_read_lock();
	memcg = folio_memcg(folio);
	res = memcg_list_lru_allocated(memcg, lru);
	rcu_read_unlock();
	if (likely(res))
		return 0;

	/* Allocation may block, pin the memcg */
	memcg = get_mem_cgroup_from_folio(folio);
	res = __memcg_list_lru_alloc(memcg, lru, gfp);
...
}

GFP_KERNEL includes __GFP_DIRECT_RECLAIM:

...
#define __GFP_DIRECT_RECLAIM	((__force gfp_t)___GFP_DIRECT_RECLAIM) /* Caller can reclaim */
#define __GFP_KSWAPD_RECLAIM	((__force gfp_t)___GFP_KSWAPD_RECLAIM) /* kswapd can wake */
#define __GFP_RECLAIM ((__force gfp_t)(___GFP_DIRECT_RECLAIM|___GFP_KSWAPD_RECLAIM))

...
#define GFP_KERNEL	(__GFP_RECLAIM | __GFP_IO | __GFP_FS)

This only affects calls that find the metadata missing; after it has been
installed, later calls take the fast branch. Still, it bypasses the gfp
with direct reclaim stripped for the freeze window. Could
folio_memcg_alloc_deferred() take that gfp here?

[...]

Cheers, Lance

