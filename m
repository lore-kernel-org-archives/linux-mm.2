Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDE63606A33D
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 09:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Ry7BddNF
Received: by kanga.kvack.org (Postfix)
	id EB69E6B05BE; Mon, 16 Nov 2026 04:13:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8E8D6B05BF; Mon, 16 Nov 2026 04:13:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA5266B05C0; Mon, 16 Nov 2026 04:13:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BA4D46B05BE
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 04:13:48 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 479C28059D
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:13:48 +0000 (UTC)
X-FDA: 85440419736.16.37886AF
Received: from mta0.migadu.com (out-229.mta0.migadu.com [91.218.175.229])
	by imf31.hostedemail.com (Postfix) with ESMTP id 16C5D20006
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:13:45 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ry7BddNF;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.229 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794820426;
	b=Bh1w1rkfwmTvDNMOV/y1BTjN/1mNJRn30H1hszdQL6D5zX/T6Y321zPiqVv7FdBo2S9nCo
	eerXj921ygiWXEWxu307ZB1zGCdnpGkuaxc69cdhH/2uq+eb0VFXSh6q6pA/SWymj6zJuA
	HbaKnh/+lgfWxJD5jPztfxyEPbQRMHo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794820426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uBI20GIoHIeO9nJKpZQ+Icy1CTlU696c8C2pcMHc3vs=;
	b=fPng/cvLWXHzIVb7l/CHkCCZB0AhOjuxdvOac6OWEiiy0IqccYMwYoTzMmk5tqRpWtQpGS
	rzOUhvoZClosBEwlPR7tnG/+0ImdKvd4JUCJHRXqQ+IIxvsRRXFG013A7gaYpLW4Xi7R1v
	3kna+fYSehx49PEkHMcb7gV9bKCGakQ=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ry7BddNF;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.229 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=vkoE6KORQMAFzwcm5haqOvH3H10zW833YOviF5z+zOY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794820424; v=1; x=1795425224;
 b=Ry7BddNFgm8Y2QWK1Gj/bejhBQT1hhYfcDVVFQBZygeYcWMGqLTFBGQYxdLJJu/vXqd+pl/n
 VgdKTw2X6CyMIck031myc1U6Czl7aI4nakTa9AI2uTmVGgk0niBVJpEl78lcKtBFQAyC8qWZ1Mx
 gduMQpQ4FlDWLBFGVTWBcIA0=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 79afc9c9dc722c5a;
	Mon, 16 Nov 2026 09:13:44 +0000
X-Mizu-Trace-ID: 79afc9c9dc722c5a
X-Migadu-Flow: FLOW_OUT
Date: Mon, 16 Nov 2026 17:13:36 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: sashiko-reviews@lists.linux.dev
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, david@kernel.org,
	kasong@tencent.com, baohua@kernel.org,
	baolin.wang@linux.alibaba.com, qi.zheng@linux.dev,
	shakeel.butt@linux.dev, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com,
	Baoquan He <hebaoquan@kylinos.cn>, Kairui Song <ryncsn@gmail.com>
Subject: Re: [PATCH v3 3/4] mm/mglru: skip cold PUD subtrees during aging
Message-ID: <avrJQIyQXf9zmeo3@fedora>
References: <20261113084953.412919-1-baoquan.he@linux.dev>
 <20261113084953.412919-4-baoquan.he@linux.dev>
 <sashiko-outbox-214125@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <sashiko-outbox-214125@kernel.org>
X-Rspamd-Queue-Id: 16C5D20006
X-Rspamd-Server: rspam12
X-Stat-Signature: bii9wugw5j68bctqucszsmmq9ctu5ora
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794820425-844313
X-HE-Meta: U2FsdGVkX1+isBiXpCcZb6OI/eUXq1rgZGPc4dLYHH8ELX3F6NvGvduEVcv/fiQDjvjMyIl2lkAIb2/A/OhHK1gG7cpWIBZkr4iLco0gMHJB/won0bnMN27HkDZj2qNQgCrMtXMazcJwEZ5FLIlFF/X72edGNnThFr0eAPcmMbYqxw05rI0nKpO/0qIFvZVcqyGuB0uQNFOc/6lJATEywijnrqcEGbui19+Sa7/NeiakvrMaQZMcxhMbZtNPmuLntoR9ivCcWLCtUOuMedq0poCqXttc4TtKpTsAgTeXDBMi4rtlUsQlh8eTeN+Lc0VrbueLr/snPlhy8mEXekrOeLB4ZmOoML8RQsMW5kU8S7GixXLE78DwD08W7s4sls7MGlMW426pDlJJ+snc2Uf17iFO+3KeE8NpuVCKv8D6S64JEsTQE18ikHhsJi7m972z4x0TtAXgUxh7Qo/0yHuwpVsLQYY4uU5toaFclPa1yEM8hqDAoZ0MvZSN+NMkx4SL/dq3PGD0P3fq+BBBJkhEOGnNfzHRLmsHX7RC6iW6CgebeC0J6SocMglG9qBWGxIMWcqUTMk9dDxNoZMyCFm+d+8j01MAeC4w60ITyT0BzGJ4NxzMEm8tRE24tH2PJPCwQNipDN3YYZm/ofJ8vo142Z5RZUY5pGOX32n3f4T1b3Cfxu6h5Qm0M3IehdayEyhS0e9YzQMrFtpmY5/EKRnuNj2wLgrBAI5fW4YA6KR43csnsD50ake4VNi2v0OAjfcI1mKwjP+NnZXrVPCUf/SBz9dbmSPBqVEQyE6wbyOfFWM/EThxpoHP8CfZnGcPzDtNXMbTPuCRamF1JFwda1sCcaS/h4V7wXARbrb8M/jS3M6RDLhOnuGoBk4geMQ5w+0jLifLVfjK58EibQkGEXw7GM2YdxA5kKtpQKugYWUYz7voKWvN4z5rghk3tFX2rz24kuQGyEp1mazRLfo7amC
 BmeMbhgU
 2+NoF5Xv9SefDlzu/Gwp7NpHu7z9agf1o8sygj2CmeP3RdcAxQP1ZQW/Hn89leqxv6MI8dMpBW6WBD0rBAoZeLN1HQYVK8OskNjS39DyRKA3FFAuWxgs66SkDuiAZhikAfy4ypgIiY7g0agFvVKu/3bzyZwTb0DFGRKrotKS9iBaKYx+P/bA2yMf3p5hXfFk3/u2uTH+Lk0xDGGJgKxpeEv4oQ2ovczOd7A5/PF4a+Pq9DShq6AVzuN4288edmiRR1LKoFakZ0FTxKOxy3AHd21P6vgh2dUBxzuXIgcB8VhPXMC5gspup4FdRVtlcRz2ljfOmlk/F+Z43GqqRFXBOe7MLbkz8uh8ojbcjz+/bicbq14sS2YEiVqGeHzyJkQ8NnI/FlUL/FBS6W/+dBxfEeM5/siouqoin1iukrJaAWJLQVHj35+ctxrCa6vopA8yGhzUNO4EfdFIfnlW6WupIuhY9c3ua7qSs9BVWk7C0Ew9rqibBWkqum2VBu/QpRU7RPXi/IU7VDyZTjsmXXD4jI0inq7nFoK24/3nCKkcxv5p8S2qOlzlJyER13Dfqjakio9DBLlMhvcRncHHMRFHa/Dtnhw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/14/26 at 03:42am, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential
> issues to consider:
> - [Medium] mm/mglru: walk_pmd_range() marks PUD young on non-leaf PMD
>   accessed bit
> - [Medium] mm/mglru: walk_pmd_range() marks PUD young for THP before
>   memcg and notifier checks
> - [Medium] mm/mglru: PUDs with PMD-mapped THPs are suppressed
>   indefinitely once skipped

Thanks for the review. All three points are real. The third one is the most
important. Will Changes in v4. Please see the inline reply for each item.

> --
> 
> commit 31572808d36982038b4b945e98794001c99a5d21
> Author: Baoquan He <hebaoquan@kylinos.cn>
> 
> mm/mglru: skip cold PUD subtrees during aging
> 
> This commit introduces a PUD-level Bloom filter keyed by (mm, PUD-aligned
> address) to skip PUD subtrees that had no young pages in the previous
> generation during MGLRU aging walks, and updates it from the rmap feedback
> path in lru_gen_look_around().
> 
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index a0332586b3d83..79d533ebfd108 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> 
> [ ... ]
> 
> > @@ -3730,10 +3732,11 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
> >  	*first = -1;
> >  }
> >  
> > -static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
> > +static bool walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
> >  			   struct mm_walk *args)
> >  {
> >  	int i;
> > +	bool young = false;
> >  	pmd_t *pmd;
> >  	unsigned long next;
> >  	unsigned long addr;
> > @@ -3770,8 +3773,10 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
> >  
> >  			walk->mm_stats[MM_LEAF_TOTAL]++;
> >  
> > -			if (pfn != -1)
> > +			if (pfn != -1) {
> >  				walk_pmd_range_locked(pud, addr, vma, args, bitmap, &first);
> > +				young = true;
> > +			}
> >  			continue;
> >  		}
> 
> [Severity: Medium]
> Does setting young = true as soon as get_pmd_pfn() != -1 mark the PUD young
> before checking memcg ownership or MMU notifiers?
> 
> get_pmd_pfn() only checks that the PFN is on pgdat and that pmd_young() or
> mm_has_notifiers() is true, while the memcg check in get_pfn_folio() and
> the notifier young check in pmdp_test_and_clear_young_notify() are deferred
> to walk_pmd_range_locked().  A PUD with PMD-mapped THPs belonging to
> another memcg on the same node, or cold THPs in an mm with MMU notifiers,
> will therefore be recorded in BLOOM_FILTER_PUD on every generation and
> never skipped.

Yes, that is too early. get_pmd_pfn() only checks that the PFN is on this
node and that the accessed bit is set. The memcg check and the notifier
young check happen later, inside walk_pmd_range_locked().
  
Will fix in v4 by making walk_pmd_range_locked() return true only when it
found a young entry for this lruvec, and using that value here:

> 
> > @@ -3781,6 +3786,7 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
> >  				continue;
> >  
> >  			walk_pmd_range_locked(pud, addr, vma, args, bitmap, &first);
> > +			young = true;
> >  		}
> >  
> >  		if (!walk->force_scan &&
> > @@ -3793,6 +3799,7 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
> >  			continue;
> >  
> >  		walk->mm_stats[MM_NONLEAF_ADDED]++;
> > +		young = true;
> >  
> >  		/* carry over to the next generation */
> >  		update_bloom_filter(mm_state, BLOOM_FILTER_PMD, walk->seq + 1, pmd + i);
> 
> [Severity: Medium]
> Should young = true be omitted from the non-leaf pmd_young(val) block?
> 
> When should_clear_pmd_young() is true, setting young = true there happens
> before checking BLOOM_FILTER_PMD or calling walk_pte_range().  Because CPU
> page table walks set the accessed bit on non-leaf PMDs regardless of which
> node or memcg owns the underlying PTEs, any accessed non-leaf PMD will
> cause walk_pmd_range() to return true and carry the PUD into
> BLOOM_FILTER_PUD even when every PMD in the subtree fails the PMD Bloom
> filter or has no folios in walk->lruvec.  The young = true after
> walk_pte_range() already handles non-leaf PMDs that pass suitable_to_scan().

Agreed, will remove. The accessed bit of a non-leaf PMD says nothing about which
lruvec owns the pages, and the first walker of a generation clears it. A
second walker (another node, or kswapd) then sees it cleared and skips the
whole PUD, so the skip depends on walk order instead of on the lruvec.
 
In v4 a PUD is marked young only when walk_pte_range() reports young leaves for
this lruvec, or when a young huge page of this lruvec is found. The batched
flush below contributes too, because batched huge pages are processed there:
 
   young |= walk_pmd_range_locked(pud, -1, vma, args, bitmap, &first);

> 
> > @@ -3802,6 +3809,8 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
> >  
> >  	if (i < PTRS_PER_PMD && get_next_vma(PUD_MASK, PMD_SIZE, args, &start, &end))
> >  		goto restart;
> > +
> > +	return young;
> >  }
> >  
> >  static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long end,
> > @@ -3812,6 +3821,7 @@ static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long end,
> >  	unsigned long addr;
> >  	unsigned long next;
> >  	struct lru_gen_mm_walk *walk = args->private;
> > +	struct lru_gen_mm_state *mm_state = get_mm_state(walk->lruvec);
> >  
> >  	VM_WARN_ON_ONCE(p4d_leaf(*p4d));
> >  
> > @@ -3819,13 +3829,29 @@ static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long end,
> >  restart:
> >  	for (i = pud_index(start), addr = start; addr != end; i++, addr = next) {
> >  		pud_t val = pudp_get(pud + i);
> > +		void *pud_key;
> >  
> >  		next = pud_addr_end(addr, end);
> >  
> >  		if (!pud_present(val) || WARN_ON_ONCE(pud_leaf(val)))
> >  			continue;
> >  
> > -		walk_pmd_range(pud + i, addr, next, args);
> > +		/*
> > +		 * Use (mm, PUD-aligned address) as the filter key instead of
> > +		 * the page table pointer. It is stable across the aging walk
> > +		 * and the rmap feedback path, and avoids walking the page
> > +		 * tables in lru_gen_look_around().
> > +		 */
> > +		pud_key = (void *)((unsigned long)args->mm ^ (addr & PUD_MASK));
> > +
> > +		/* Skip a subtree that had nothing young for this lruvec last gen */
> > +		if (!walk->force_scan &&
> > +		    !test_bloom_filter(mm_state, BLOOM_FILTER_PUD, walk->seq, pud_key))
> > +			continue;
> > +
> > +		if (walk_pmd_range(pud + i, addr, next, args))
> > +			update_bloom_filter(mm_state, BLOOM_FILTER_PUD, walk->seq + 1,
> > +					    pud_key);
> 
> [Severity: Medium]
> Once a PUD is absent from BLOOM_FILTER_PUD, can PMD-mapped THPs inside it
> ever be scanned by page-table aging again without force_scan?

Agreed, and this is the important one. For a PMD-mapped folio
folio_referenced_one() takes the pmdp_clear_flush_young_notify() branch and
never calls lru_gen_look_around(), so once a PUD is skipped nothing puts its
key back, until a forced scan or a new mm.
 
v4 will add the missing feedback. 

> 
> Previously, BLOOM_FILTER_PMD was checked after pmd_trans_huge() in
> walk_pmd_range(), so PMD-mapped THPs were never gated by a Bloom filter.
> Gating walk_pmd_range() on BLOOM_FILTER_PUD skips the entire PUD when
> pud_key is not present, and iterate_mm_list() clears the next generation's
> filter via reset_bloom_filter(mm_state, BLOOM_FILTER_PUD, walk->seq + 1).
> The only rmap feedback that populates BLOOM_FILTER_PUD is
> lru_gen_look_around(), which folio_referenced_one() only calls when
> pvmw.pte is non-NULL:
> 
> mm/rmap.c:folio_referenced_one() {
>     ...
> 		if (lru_gen_enabled() && !lru_gen_switching() && pvmw.pte &&
> 		    pte_present(pteval)) {
> 			if (lru_gen_look_around(&pvmw, nr))
> 				referenced++;
> 		} else if (pvmw.pte) {
>     ...
> 		} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
> 			if (pmdp_clear_flush_young_notify(vma, address,
> 						pvmw.pmd))
> 				referenced++;
>     ...
> }
> 
> For PMD-mapped THPs (pvmw.pte == NULL), rmap eviction checks never update
> BLOOM_FILTER_PUD, so any PUD that goes cold for one generation or receives
> newly faulted or collapsed THPs after the initial force_scan will be
> skipped by aging indefinitely.
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261113084953.412919-1-baoquan.he@linux.dev?part=3

