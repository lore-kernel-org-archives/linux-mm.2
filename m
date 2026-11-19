Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 886F9606A320
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 09:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=neDjzNmX
Received: by kanga.kvack.org (Postfix)
	id 9E36D6B05B6; Thu, 19 Nov 2026 04:24:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9975F6B05CE; Thu, 19 Nov 2026 04:24:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8ACF56B05EE; Thu, 19 Nov 2026 04:24:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 674A76B05B6
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 04:24:55 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C36F68099C
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 09:24:54 +0000 (UTC)
X-FDA: 85451334108.01.8E32651
Received: from mta1.migadu.com (out-91.mta1.migadu.com [95.215.58.91])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7E58E40006
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 09:24:52 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=neDjzNmX;
	spf=pass (imf27.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.91 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795080293;
	b=6CRISYy6VkylCvz5wufonBVfYkUysExIxvvmCeZW7/hsfiwLQpgax+XEp1fUVkmfA2j6vZ
	86fi8hIau0+qiLlEBLiJLjrhOwMRn1AwTB1kqxHpUjMcQZAqMx2z+53px2m3LyACva0+bh
	QCbeU/PosCUuXOh3bW+ryQums+aLcTk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795080293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cCe8wn7rXIQDY9mJX+i674ZbYVhG3egsT2+B2uCc1sQ=;
	b=1AI1RAAa6oYHoo0zG408Bd6Q314DXwBUDMTjSlKUJxboh7XDY6gasAq/ppnEdQA8pEggZb
	zEaBjwr1bbge43MzVWMfGbvUtej9Em2jeHhVTCCichxrhmyMvgCuagVLYlJeAdK3EcFx9l
	B8JPYcR7QM3fVnvl9Qu84doiJWu+eM0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=neDjzNmX;
	spf=pass (imf27.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.91 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=W345cDTFz+dZOqJx8GXphTmXARBFaFLNDZgCFqVrQDM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795080290; v=1; x=1795685090;
 b=neDjzNmX2peKmf/8HN4GiVI/3CxB8kAj/le4Idy95zMywuRzUZyHIN/Sd9w7qNxNP0Qj+0Mk
 dqvQWJFf5KKSGBSAMLxab5um+mWcWyTNHUPjEKdyLncg3LHPou+woAkExgVKOkNioxrO8ix7Btg
 oneC8aLpIbuIGa8mWympZNf4=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 54021951ad124a27;
	Thu, 19 Nov 2026 09:24:50 +0000
X-Mizu-Trace-ID: 54021951ad124a27
X-Migadu-Flow: FLOW_OUT
Date: Thu, 19 Nov 2026 17:24:43 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, david@kernel.org,
	kasong@tencent.com, baohua@kernel.org,
	baolin.wang@linux.alibaba.com, qi.zheng@linux.dev,
	shakeel.butt@linux.dev, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: Re: [PATCH v3 2/4] mm/mglru: add PUD-level Bloom filter state and
 generic helpers
Message-ID: <av7AW0kaJTUnucuC@fedora>
References: <20261113084953.412919-1-baoquan.he@linux.dev>
 <20261113084953.412919-3-baoquan.he@linux.dev>
 <avq-hc6E4Urpf6x4@KASONG-MC4>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avq-hc6E4Urpf6x4@KASONG-MC4>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7E58E40006
X-Rspam-User:
X-Stat-Signature: fyqzajnjq7m9j8h79feeoymr8mwud3jo
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795080292-986040
X-HE-Meta: U2FsdGVkX18a3X0KMbIn9TKtKmHJZsv3NGqsaxKQDoPv9pjBXtHvWbv8ujHX1nWj3R21gvD5xptxJraFNrgk1pZthWl9WDbHPk6VmQHgvDqizdMMCDdx6GQU8gRG6KMaioB/WrLzgGsOglviFPznIZKY3UmULl2G9DFYf5GBOIp/axjwWIXU3tJOOrVPw1L2WaxZGDdnZMaDFpj/yh/zcJKN0ClqhpO+0qmXXUWjCfeMdg6MG1eyhGJdsarRQLn9/hA+PFjn3/aYQyK1oiWfhgg41zp3rhDqM3E+0SNiGAZJqv3CAGQaPu7AYw3CRQJIiOF4c1sHcAkxQi5FqlH/JCpYQPtme37/IyQMt2bDUYYhEHunO6BDx/9tDZvevHDAC9S2UgdAGGdZIaHYBVJK/a494f5VDf+ec50QffZMNXVDhyukZYoXiXzLn5S3pNL8/BUkXXfhMMwtwI3yPxzSco8DfMzl1TKq7gIRa7hPbRhjAtFe2W2bSWl+9Zu82gud1H43wAgJMiUeYwKKO3USQnpsL7EzADgQiGNEcrkADJLkNXfHgZiKSX6esE96QtBOBeMRS0dS1NnV9YIvfGYAo2sHrxt8TeeaIxA9U0jBGn2V8M/AZI6uL4arSfDUYM08IM+hU7vNsY3tg5PKPoD5xNY4EyVqVfcO7pDdJCdDWnD0aD09JXPwZ8ViXHU7i7E6mFYUODZKFpm3+Uybf7VrZB4DNtt5Zent7glIbJKc7jRNsXw7/keLgqM5aIMWBIbT9s97IGNtOJRdMHqzuigaIEXZn35pGLvW7Abb5My0euRe9NUYTQpeeUssduZM9U9Pdju4s64weyXkHgJwfGA3UA6V/9q9BQRM8bqlPtdlR6WpL0g2IbHvJI/CAyxK/kxZOgVQQZD45Icy8ocGsjPtiTU5nAL+DqJcvcEehYY+rdtClmKIAMYfuPmBgvNMgXzas9Ewj1pCggcRDttqjwn
 bkpv2jt7
 KHdPkZhwC4tLPNU/SeGCc7pc5k4wXs/cRRJwH+h3iJZgfqqdjf8HUVxTtwrXB2uSW7uCiOCpSloiuwstPNmftkCm7/9nSWtoR9K02lSFnFq1A/2yjY/ZsMtKpPs4hIvpL7hSMpccIjxOptC49mmcu2uxXD5gKsYHRzXToYWCLbQ+n3yZELs3s3PSNUDXl/zpQze95jonLaIZRU304mPTieJWeVfFjL+pgdlrQawkTxVly+R0NIy6QlyQQJx7vIPXC7c/42E1yCiymvJBqUusmwvMcdfN9bJrKAauvdGfgVUBnwIl84Q1GWTeKpLXg9QJA9KJx8YYkUqU47v06PWiH3wECB9EjNjrLwJxxzn7xOFf2UJCxos4MPMh+AMA2miunD2+3n/BYT6AEHB8+lNPH4Qk8v0W79GiPKIn1+v4kQgf/DzswEetnzcivC7ppbsCWcLExNzZpo+NlPDnTgYzJ01nzjqm3ZsqcgfOlTvmmwyseBOZ8UPrPTXwbOQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/17/26 at 12:24am, Kairui Song wrote:
> On Fri, Nov 13, 2026 at 04:49:51PM +0800, Baoquan He wrote:
> > From: Baoquan He <hebaoquan@kylinos.cn>
> > 
> > Generalize the Bloom filter state and helpers so that another filter
> > level can reuse the same hash, double-buffering and reset logic.
> > 
> > Replace the PMD-level filter array with a two-dimensional filters array
> > indexed by level, and add BLOOM_FILTER_PUD and BLOOM_FILTER_PMD. The
> > PUD-level filters operate at PUD granularity and generalize the
> > suppression one level up: when all PMDs under a PUD fail the PMD-level
> > filter, the whole PMD iteration can be skipped. Cross-node empty walks
> > are the most visible case: a foreign mm's PUDs have no young entries for
> > this lruvec, so the entire PMD iteration is pure waste.
> > 
> > The existing PMD-level code now goes through the generic
> > test/update/reset_bloom_filter() helpers.
> > 
> > No behavior change yet; the PUD-level filters are populated and used by
> > the next patch.
> > 
> > Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
> > Signed-off-by: Baoquan He <baoquan.he@linux.dev>
> 
> ...
> 
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 98037a562ab6..9dbb3f477d7d 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -2798,6 +2798,10 @@ static bool __maybe_unused seq_is_valid(struct lruvec *lruvec)
> >   * walk_pmd_range(); the eviction also report them when walking the rmap
> >   * in lru_gen_look_around().
> >   *
> 
> Not a problem for this patch, but the comment above may want an update
> in the next commit. This describes things only at the PMD level, while
> the PUD level, the ~1/5 and ~1/2 FP figures still hold for (same m, k
> and n). But the PMD false positive only causes a wasted PTE walk if
> the PUD gate also passes, so the effective FP rate is weighted by
> the PUD part too.  The PUD filter has its own FP, which is rarer but
> costs a whole 1 GiB subtree, so maybe the 4 KiB bitmap for PUD
> is not that obviously oversized (despite the PUD number are much
> lower than PMD we are using same sized bitmaps).

OK, makes sense, will update.

> 
> > + * A second, coarser pair of filters sits one level up. The filters are
> > + * indexed by level: BLOOM_FILTER_PMD for the PMD-level filters above, and
> > + * BLOOM_FILTER_PUD for the PUD-level pair.
> > + *
> >   * For future optimizations:
> >   * 1. It's not necessary to keep both filters all the time. The spare one can be
> >   *    freed after the RCU grace period and reallocated if needed again.
> 
> Still not a problem but this optimization is more important now. We have a
> extra 8KB peak overhead per lruvec if I did the math right, not too bad
> as there won't be too many of them, even on large machines (memcg number
> is currently hard limited to 64k and they are lazily allocated). But
> worth mentioning and optimized later.

Agree but don't worry, I have considered this and queued patch in my
local branch. Will post them after this pud filter series.

> 
> > @@ -2823,14 +2827,13 @@ static void get_item_key(void *item, int *key)
> >  	key[1] = hash >> BLOOM_FILTER_SHIFT;
> >  }
> >  
> > -static bool test_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long seq,
> > -			      void *item)
> > +static bool __test_bloom_filter(unsigned long **filters, unsigned long seq, void *item)
> 
> There is only one caller of this (test_bloom_filter), do we really
> need the __ version?

OK, will remove them.

> 
> >  {
> >  	int key[2];
> >  	unsigned long *filter;
> >  	int gen = filter_gen_from_seq(seq);
> >  
> > -	filter = READ_ONCE(mm_state->filters[gen]);
> > +	filter = READ_ONCE(filters[gen]);
> >  	if (!filter)
> >  		return true;
> >  
> > @@ -2839,14 +2842,13 @@ static bool test_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long s
> >  	return test_bit(key[0], filter) && test_bit(key[1], filter);
> >  }
> >  
> > -static void update_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long seq,
> > -				void *item)
> > +static void __update_bloom_filter(unsigned long **filters, unsigned long seq, void *item)
> 
> Also this one, only one caller, the __ intermediate layer seems unnecessary.

Ditto.

> 
> >  {
> >  	int key[2];
> >  	unsigned long *filter;
> >  	int gen = filter_gen_from_seq(seq);
> >  
> > -	filter = READ_ONCE(mm_state->filters[gen]);
> > +	filter = READ_ONCE(filters[gen]);
> >  	if (!filter)
> >  		return;
> >  
> > @@ -2858,12 +2860,12 @@ static void update_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long
> >  		set_bit(key[1], filter);
> >  }
> >  
> > -static void reset_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long seq)
> > +static void __reset_bloom_filter(unsigned long **filters, unsigned long seq)
> >  {
> >  	unsigned long *filter;
> >  	int gen = filter_gen_from_seq(seq);
> >  
> > -	filter = mm_state->filters[gen];
> > +	filter = filters[gen];
> >  	if (filter) {
> >  		bitmap_clear(filter, 0, BIT(BLOOM_FILTER_SHIFT));
> >  		return;
> > @@ -2871,7 +2873,25 @@ static void reset_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long
> >  
> >  	filter = bitmap_zalloc(BIT(BLOOM_FILTER_SHIFT),
> >  			       __GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN);
> > -	WRITE_ONCE(mm_state->filters[gen], filter);
> > +	WRITE_ONCE(filters[gen], filter);
> > +}
> > +
> > +static bool test_bloom_filter(struct lru_gen_mm_state *mm_state, int level,
> > +			      unsigned long seq, void *item)
> > +{
> > +	return __test_bloom_filter(mm_state->filters[level], seq, item);
> > +}
> > +
> > +static void update_bloom_filter(struct lru_gen_mm_state *mm_state, int level,
> > +				unsigned long seq, void *item)
> > +{
> > +	__update_bloom_filter(mm_state->filters[level], seq, item);
> > +}
> > +
> > +static void reset_bloom_filter(struct lru_gen_mm_state *mm_state, int level,
> > +			       unsigned long seq)
> > +{
> > +	__reset_bloom_filter(mm_state->filters[level], seq);
> >  }
> >  
> >  /******************************************************************************
> > @@ -3114,7 +3134,7 @@ static bool iterate_mm_list(struct lru_gen_mm_walk *walk, struct mm_struct **ite
> >  	spin_unlock(&mm_list->lock);
> >  
> >  	if (mm && first)
> > -		reset_bloom_filter(mm_state, walk->seq + 1);
> > +		reset_bloom_filter(mm_state, BLOOM_FILTER_PMD, walk->seq + 1);
> >  
> >  	if (*iter)
> >  		mmdrop(*iter);
> > @@ -3771,7 +3791,8 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
> >  			walk_pmd_range_locked(pud, addr, vma, args, bitmap, &first);
> >  		}
> >  
> > -		if (!walk->force_scan && !test_bloom_filter(mm_state, walk->seq, pmd + i))
> > +		if (!walk->force_scan &&
> > +		    !test_bloom_filter(mm_state, BLOOM_FILTER_PMD, walk->seq, pmd + i))
> 
> This looks nice.
> 
> >  			continue;
> >  
> >  		walk->mm_stats[MM_NONLEAF_FOUND]++;
> > @@ -3782,7 +3803,7 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
> >  		walk->mm_stats[MM_NONLEAF_ADDED]++;
> >  
> >  		/* carry over to the next generation */
> > -		update_bloom_filter(mm_state, walk->seq + 1, pmd + i);
> > +		update_bloom_filter(mm_state, BLOOM_FILTER_PMD, walk->seq + 1, pmd + i);
> >  	}
> >  
> >  	walk_pmd_range_locked(pud, -1, vma, args, bitmap, &first);
> > @@ -4417,8 +4438,8 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
> >  
> >  	/* feedback from rmap walkers to page table walkers */
> >  	if (mm_state && suitable_to_scan(i, young))
> > -		update_bloom_filter(mm_state, READ_ONCE(lruvec->lrugen.max_seq),
> > -				    pvmw->pmd);
> > +		update_bloom_filter(mm_state, BLOOM_FILTER_PMD,
> > +				    READ_ONCE(lruvec->lrugen.max_seq), pvmw->pmd);
> >  
> >  	mem_cgroup_put(memcg);
> >  
> > @@ -5981,6 +6002,7 @@ void lru_gen_init_memcg(struct mem_cgroup *memcg)
> >  void lru_gen_exit_memcg(struct mem_cgroup *memcg)
> >  {
> >  	int i;
> > +	int level;
> >  	int nid;
> >  	struct lru_gen_mm_list *mm_list = get_mm_list(memcg);
> >  
> > @@ -5998,9 +6020,11 @@ void lru_gen_exit_memcg(struct mem_cgroup *memcg)
> >  		if (!mm_state)
> >  			continue;
> >  
> > -		for (i = 0; i < NR_BLOOM_FILTERS; i++) {
> > -			bitmap_free(mm_state->filters[i]);
> > -			mm_state->filters[i] = NULL;
> > +		for (level = 0; level < BLOOM_FILTER_LEVELS; level++) {
> > +			for (i = 0; i < NR_BLOOM_FILTERS; i++) {
> > +				bitmap_free(mm_state->filters[level][i]);
> > +				mm_state->filters[level][i] = NULL;
> > +			}
> 
> So just a few nit style and comment issue from me, rest looks good, thanks!
> 
> Reviewed-by: Kairui Song <kasong@tencent.com>

Thanks for careful reviewing and great suggestion.



