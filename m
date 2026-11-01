Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D4DF606A326
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 17:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FVRcLhEI
Received: by kanga.kvack.org (Postfix)
	id 4B5DE6B05B5; Sun,  1 Nov 2026 12:33:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48D486B05B8; Sun,  1 Nov 2026 12:33:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A3C76B05B9; Sun,  1 Nov 2026 12:33:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0CE436B05B5
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 12:33:52 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 909C51A0AC1
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 17:33:51 +0000 (UTC)
X-FDA: 85387247862.15.BCAF42F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id D07C920002
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 17:33:49 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FVRcLhEI;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793554429;
	b=LNroW9wAB9Vz52esn6MxwGoK+hMM+rl0Zm90Sf2SRBC2GN1Nb0H9X22f1U4Ym5uw5tvYVw
	tC6oDocN8aGeo53U8+pvYPRXrQoK8BOC6WS7M6IHw5xAh2AkZnq0dPzMmW5iZ+vLMku+8X
	ojTBr6kAqbFj8wgP9lv1dVDgkiPrk5g=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FVRcLhEI;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793554429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5Af4wwRThb6wziSNe9r8m/8FYuyWHwsVTFtpr3TfGNM=;
	b=2dtoA1GTM0wrnpCPY1/xSZ3kYfrpR4qkrETerhZ2H666KZ0ejJOxruztL2ObuWsHFbKn+O
	8H29p0/fKeO/fEMuP87oJr1X0/TTtMbwDuiHI6qEvq9muyfWNaN1110WJc0v89fC65acQ7
	8IWiYi4gvsHV2sJ3IhnwHkodxJOHVcE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1220542B3E;
	Sun,  1 Nov 2026 17:33:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD5831F000C1;
	Sun,  1 Nov 2026 17:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793554429;
	bh=5Af4wwRThb6wziSNe9r8m/8FYuyWHwsVTFtpr3TfGNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FVRcLhEI49ERG3OYJlx+mU5241XpKwQk1V51ROBQa912ii7uzUBA4q1lLqBNpL3tf
	 8NRRZhxtnCwGOKAPjjIp/gMTMR9fPTHq5FMKz0fJcRESA6vP/YV9Oj6I86pE4UoV15
	 LULZMoKbQ3F+n6gwBcYbLsDgonbJo+7yXA00bjoy8MiNfKA3GRYAtneqRqa31SPN+f
	 EEdc9jf8+WgmfEMLF2t9cdS4IGOjn7JKNActA+Pm6bVSuICOjQgiy4ibX7bE9dSkuR
	 CLdtuXUQsNHTlCZqDHseRk5TwHrR0m40G/k/GTKFMB856QNynHck1SC67In+UKckDg
	 2WMz98MUdeiBw==
From: SJ Park <sj@kernel.org>
To: sashiko-bot@kernel.org
Cc: SJ Park <sj@kernel.org>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v2 2/6] mm/damon/vaddr: use damos->last_applied for migrate action
Date: Sun,  1 Nov 2026 09:33:39 -0800
Message-ID: <20261101173341.82357-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <sashiko-outbox-192531@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4hbg6urmdu9nyw365wdy3m56dyh6saky
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D07C920002
X-Rspam-User: 
X-HE-Tag: 1793554429-488357
X-HE-Meta: U2FsdGVkX19R0N12mQx48UXa57GxSI0HWn9ZD7JjF3rRvKU/ChLP+pYQLUkrzYY47TbbdbQTpGZAOsM+4Ey1b1OM+ts54CsL+qwVpi/8Wa74SOpb2nnxUf3BoO51n0ML63jenqN+D2nfUHOEOQNZbNl9pkzr0QktM6uuimkL1nY2wJxcTMVMDVf31l3/As6zUFgS01nQSYlxu09mQY1b3CQkckT9cO2tTXBuBa5x7eGflsPB+7hzobvF4Zb5da8E3Fq8A7ly31rAZ2VUzoMKPcHUnp3BPdm1nR31Hkq79tGPN0cmH0bF1JsZGzMmYA5aXSku/7+25UYzC4bgmv3BJWFqIb8Yexewp58HumkSiz4LQHkvrk7cmOdJFjQ4MUYdHnBc2mkbS4KcVWQTsJ7pbIY7c7YCPwwaHQjb5OS1ZoTWanABU2eFb7lfB4oniImbWVZKS/K0Z+mW3dB96zKHOAXFYxb6r8p8vFNwQxqo+Kbm5jSe864mBwCmEs0JQ+s5HoVeO8hdpEbuITOSXNv6RR/K94mF7pQ7cZNvzCgg0hzzBWhKULeHxGxnkdp7HfmoC5pV8vzoS6mkkXQKCObw730EQSqlFrdPTtwE8O6zUd6/quMU+Ee6khd9Gg2DgRzXWieAXOZBNb5DjJp6h7F3cZMtedy9l+iamLE+k65sQh5Qn8LwSV5KFmDEFasDh20AWfF4CznuDGSG7cnYvktVjUcdTR/4sZMvkHr0gntLu42rTr+/8FJKRHTPB0i4kozBL3IaYtabmEG6lUdLTQ6NlmhK/+TWi+tlumSiQgWthYHozT5vzmX0RFjl7dMYO82s6jnFRE+erXgarm1YNPE3yEZTDw+BtcvbWzQ9VdYikuuepnjikD+26GjBEOtS0Scpad6rQzfrQAX+hUPHqvEk0pU1OUYt530wIWQmHJU1m3uSqqqh9rA0CX2dXSF+pr5WDrDr4WI44IZPpQgnBqp
 47JuJ4im
 IfBs+kpD/ZOpZgIt9Hpm5+3qf5niPy75Qu85KxvGQh/YFPzG+SEdIurwlEygaSWJOiY015BjEUqaCo0GDy7gMB28yoS2rl969RIISwIQm2+Keo2JrOD4P0QEeOEoxm7iVLdscjt4zkB91CfP2Pq7+fU52hkXnVNv6+Nhi/PfpcRBdVo5nqZmi7Q2NocGUnHs9zF7mxdeCBTUze955hlvXdFHnQ3VE1ewgvKM31Ly1ENYFaSMwd8bshS3wECkP6mNY9yuDGELISXaJniD5AfxlUiogryfjh8re383NHdikwn/R85YMLT2bQSpsrCjRj2X2sYeNa2+UGUWjWwnuey7AIyK1I018nT+kWHsow+kvhoNUnXvi/QhwlOlftg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, 01 Nov 2026 17:27:03 +0000 sashiko-bot@kernel.org wrote:

> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> - [Medium] mm/damon/vaddr: last_applied not updated when damos_va_filter_out() rejects
> - [Medium] mm/damon/vaddr: stale folio in last_applied after damos_va_migrate()
> - [Low] mm/damon/vaddr: single-page PTE step in damos_va_migrate_pmd_entry()
> --
> 
> commit af5ba00f84f8ca12cd15e44abbd02f8e8e38b95b
> Author: SJ Park <sj@kernel.org>
> 
> mm/damon/vaddr: use damos->last_applied for migrate action
> 
> This patch updates damos_va_migrate_pmd_entry() to check and record
> s->last_applied via damos_va_invalid_folio() so that DAMOS_MIGRATE_HOT and
> DAMOS_MIGRATE_COLD actions are not applied multiple times to folios spanning
> adjacent virtual address regions.
> 
> > diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
> > index c271b6d63c027..b1d7bcf7305bb 100644
> > --- a/mm/damon/vaddr.c
> > +++ b/mm/damon/vaddr.c
> > @@ -834,6 +834,12 @@ static void damos_va_migrate_dests_add(struct folio *folio,
> >  	list_add(&folio->lru, &migration_lists[i]);
> >  }
> >  
> > +static inline bool damos_va_invalid_folio(struct folio *folio,
> > +		struct damos *s)
> > +{
> > +	return !folio || folio == s->last_applied;
> > +}
> > +
> >  static int damos_va_migrate_pmd_entry(pmd_t *pmd, unsigned long addr,
> >  		unsigned long next, struct mm_walk *walk)
> >  {
> > @@ -854,10 +860,11 @@ static int damos_va_migrate_pmd_entry(pmd_t *pmd, unsigned long addr,
> >  		if (!pmd_present(pmde))
> >  			goto huge_out;
> >  		folio = vm_normal_folio_pmd(walk->vma, addr, pmde);
> > -		if (!folio)
> > +		if (damos_va_invalid_folio(folio, s))
> >  			goto huge_out;
> >  		if (damos_va_filter_out(s, folio, walk->vma, addr, NULL, pmd))
> >  			goto huge_out;
> > +		s->last_applied = folio;
> >  		damos_va_migrate_dests_add(folio, walk->vma, addr, dests,
> >  				migration_lists);
> >  huge_out:
> > @@ -879,12 +886,13 @@ static int damos_va_migrate_pmd_entry(pmd_t *pmd, unsigned long addr,
> >  		if (pte_none(ptent) || !pte_present(ptent))
> >  			continue;
> >  		folio = vm_normal_folio(walk->vma, addr, ptent);
> > -		if (!folio)
> > +		if (damos_va_invalid_folio(folio, s))
> >  			continue;
> 
> [Severity: Low]
> In damos_va_migrate_pmd_entry(), when damos_va_invalid_folio(folio, s) returns
> true because folio == s->last_applied for a PTE-mapped large folio at the
> start of the next region, the loop continues before computing page_idx and nr:
> 
> 	nr = 1;
> 	ptent = ptep_get(pte);
> 
> 	if (pte_none(ptent) || !pte_present(ptent))
> 		continue;
> 	folio = vm_normal_folio(walk->vma, addr, ptent);
> 	if (damos_va_invalid_folio(folio, s))
> 		continue;
> 	page_idx = folio_page_idx(folio, pte_page(ptent));
> 	nr = folio_nr_pages(folio) - page_idx;
> 
> Doesn't this leave nr at 1 and step through all remaining tail PTEs of that
> large folio one page at a time instead of advancing by folio_nr_pages(folio) -
> page_idx?

Good catch.  I will setup nr and page_idx before calling
damos_va_invalid_folio().

> 
> >  		page_idx = folio_page_idx(folio, pte_page(ptent));
> >  		nr = folio_nr_pages(folio) - page_idx;
> >  		if (damos_va_filter_out(s, folio, walk->vma, addr, pte, NULL))
> >  			continue;
> > +		s->last_applied = folio;
> >  		damos_va_migrate_dests_add(folio, walk->vma, addr, dests,
> >  				migration_lists);
> >  	}
> 
> [Severity: Medium]
> Should s->last_applied be updated even when damos_va_filter_out() rejects the
> folio in both the PMD and PTE paths of damos_va_migrate_pmd_entry(), matching
> damos_va_stat_pmd_entry() and damon_pa_migrate()?
> 
> When a PMD-mapped THP or PTE-mapped large folio spans two adjacent regions and
> is rejected by damos_va_filter_out() in the first region, jumping to huge_out
> or continuing before setting s->last_applied = folio leaves s->last_applied
> unchanged. When the second region is walked, damos_va_filter_out() is called
> a second time on the same folio.
> 
> If an ops filter such as DAMOS_FILTER_TYPE_YOUNG is used to exclude young
> folios (for example with DAMOS_MIGRATE_COLD), evaluating
> damos_va_filter_young_match() in the first region clears the page table young
> bit and marks the folio idle as a side effect:
> 
> mm/damon/vaddr.c:damos_va_filter_young_match() {
> 	...
> 	if (young && ptep)
> 		damon_ptep_mkold(ptep, vma, addr);
> 	else if (young && pmdp)
> 		damon_pmdp_mkold(pmdp, vma, addr);
> 	...
> }
> 
> Wouldn't re-running damos_va_filter_out() on the same folio in the adjacent
> region then observe the folio as old, pass the filter, and migrate the young
> folio that was just rejected in the first region?

Makes sense.  I will do so in the next version.

> 
> [Severity: Medium]
> Also, how does s->last_applied deduplicate a folio across adjacent regions
> once damos_va_migrate() has migrated it in the first region?
> 
> In damos_va_migrate(), damon_migrate_pages() runs at the end of each region
> before the next region is walked:
> 
> mm/damon/vaddr.c:damos_va_migrate() {
> 	...
> 	damon_va_walk_page_range(mm, r->ar.start, r->ar.end, &walk_ops, &priv);
> 	mmput(mm);
> 
> 	for (int i = 0; i < nr_dests; i++) {
> 		nid = use_target_nid ? s->target_nid : dests->node_id_arr[i];
> 		applied += damon_migrate_pages(&priv.migration_lists[i], nid);
> 		cond_resched();
> 	}
> 	...
> }
> 
> When a large folio spanning two adjacent regions is migrated during the first
> region, migrate_pages() allocates a new destination folio, remaps all PTEs or
> PMDs across the VMA (including those in the second region) to the new folio,
> and frees the source folio.
> 
> When damos_va_migrate_pmd_entry() then walks the second region,
> vm_normal_folio() or vm_normal_folio_pmd() returns the newly allocated
> destination folio while s->last_applied still holds the old source folio
> pointer. Since the pointers do not match, won't damos_va_invalid_folio()
> return false in the second region, causing damos_va_filter_out() and
> damos_va_migrate_dests_add() to be evaluated again on the already-migrated
> folio?

That's a good room to improve.  Not a blocker of this patch in my opinion,
though.

> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261101171630.81477-1-sj@kernel.org?part=2
> 


Thanks,
SJ

