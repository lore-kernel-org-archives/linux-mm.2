Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC524606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 06:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=hBzLaewE
Received: by kanga.kvack.org (Postfix)
	id 89DA06B00EF; Wed, 11 Nov 2026 01:42:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 826916B05B0; Wed, 11 Nov 2026 01:42:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 714AF6B05B1; Wed, 11 Nov 2026 01:42:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3E1A36B00EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:42:42 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A227E801FD
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:42:41 +0000 (UTC)
X-FDA: 85421894922.29.752557B
Received: from mta0.migadu.com (out-203.mta0.migadu.com [91.218.175.203])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6FE11140004
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:42:39 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hBzLaewE;
	spf=pass (imf09.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.203 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794379360;
	b=7KAPNFItmlLL9uZqCbiw75VFbLXEyzrCv0lxlk3lP8X2e659upvsHKJETCWLkyygmyELIQ
	RSPwzQQuyjgkp8XEWL2kZcpcgQmDAy+gPCN5KllIc0tVnUa8NOY18Z1XVs9uHNy7GXq2kT
	nxPaxzWsN5e9JM2KVVAraM5uULE3w5U=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hBzLaewE;
	spf=pass (imf09.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.203 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794379360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k6U4Lf0sQJqpZ8Y5fkLgnCWsQTx3ySVvc0oyFWLwhiM=;
	b=3gTcAUnbUELif0l1Wa6YLgG+5tt2JnuKiMU0SI6cuSLOJzGlr4sp1ISVVbC+PC9I4GuIqH
	bVckPjWkMvKNTY9vUIjPUmjH7P0Olr0PzGngAStVh3V3crvU+ZM2aAA79XnFczw8Vspe87
	ZE+4u1SUlUAsO6wtC2rDdRSuzg3/B0A=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=vXg77LUbYrNd0DR1CbpFaG4lHflKsKnxztA7kz3pnTk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794379358; v=1; x=1794984158;
 b=hBzLaewEa9G1lqwnzWMoVeQSoEosEA0zFc2sZzegmXkO1Y0/9MFgJlmX0DCvORik6Srf8tM1
 ERjzlwpyaTTmLjBU6lY8W3MJeJSN+3b530z7MED7ne0RMh0Um2iQXQx/arT4tPP1PQ+3nE2m4fW
 NiH5GbPaA7blWqpKykofkJTI=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 72b31bd848cfcfdf;
	Wed, 11 Nov 2026 06:42:37 +0000
X-Mizu-Trace-ID: 72b31bd848cfcfdf
X-Migadu-Flow: FLOW_OUT
Date: Wed, 11 Nov 2026 14:42:25 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Kairui Song <ryncsn@gmail.com>
Cc: Baoquan He <hebaoquan@kylinos.cn>, linux-mm@kvack.org,
	akpm@linux-foundation.org, baohua@kernel.org, kasong@tencent.com,
	shakeel.butt@linux.dev, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, david@kernel.org,
	rostedt@goodmis.org, mhiramat@kernel.org, hannes@cmpxchg.org
Subject: Re: [PATCH v2 2/4] mm/mglru: add PUD-level Bloom filter state and
 generic helpers
Message-ID: <avQOUTtiB90OdWHj@fedora>
References: <20260901063755.1519710-1-hebaoquan@kylinos.cn>
 <20260901063755.1519710-3-hebaoquan@kylinos.cn>
 <atJuDwflq95pU14L@KASONG-MC4>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <atJuDwflq95pU14L@KASONG-MC4>
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6FE11140004
X-Stat-Signature: j38yawy9nknngjcxt7eyf5dt4hbqqayh
X-Rspam-User: 
X-HE-Tag: 1794379359-764390
X-HE-Meta: U2FsdGVkX1+sbVF1eq3ilCS0wgw+L9YXcsh3zOymAAKLjJpVb7tcYrHdkEG7Uh97BJ9jEr5ps6fS1HeUwu5NenrTnfuLCJ9OK6K6eYAT/dEA46ES8paw7jq8MnbkrXl6sln4s4OSVMoVlerR3jjIZkkUmLuJfH9tFokyq5M7U6gOd2oWLEBd+HZe/pzvsNdJXE80w5z7s0VIfg29lNpUITjnrf5gJUcD9A5XCDZ7kHfdk80ygyI31QP7D6QOEZmcN1h9/KiRQzQUOxz/Mox+y30J56fFn5LGKUNKoFKuI4KP65T7pNWFyAuvv7InVXq9uDAPfKaom0PmvzybmB9mq29W+aqPnBhBpE6WU4Jy2wuOQIfGBJaBcvV+6Uf7sMXuajkB5GJs6ySgmpqF48W0fClc3J89cNJoNlhpVps9NDScODnH8/D9JH365wjrk9HQjg8nvz0XjKqitxv/96Sn9SOOggxj65Z9pj+1VZhcsa+ABjOK2QEMr/EUMh3asJtcUr7mrzW1pZSBMan9jBsXJwolf0A/9+nCvNnyWTp2Dt3YePjq0B0aB8Is1QHteLnsSGz/JVbMcVl9d+vci5n2J1LbwtLgTHwqkOvSRX2jdAQjH+zKRA9uZNpj2Ss3xR+Iio3/suigVXCTQ2WB08zJ0foiJTk6sQc6rv0FYzM1KgtRHB7juLk2ku5DYNugaNAd5+82M0hmI/ILRfPPFsYTcFJ3ftGPMholBBhuV66IWzMaxsgBsB3denca3Q7BmgzO8YDikFclcnnzkbby4wSArP/V+Omsbbxq1sYUDgmVuVwCgQiWmyCsXKwQ70cvJAtkBJMYToPOTZw4qf2cRa13oJxRh1Qp/2BACwzhyAIVqT5KI76CeYRNBDY0TthX1PkhuHDVyFremRpqzMwnoNmT8wL5nPjsqURvUgK2YSmfo7s06z9KDt3gjaYbhqNJ+6hjb1Bvvw8vFrTP+XffTcO
 NTFudrW8
 mxrdMGBk7k64D3iw6C2s67dvDuJFqrHvfTjRAxj1jFqOozZnh4HW3i0m1WjMDD4xQNBA3zu8vNJ+70w5Gn2P/8gxH70p7Dc9H8Zdjzyhl4A1sAVD+hTKMtwmMQbO6cjVZM95xYgvXp/TM5Bz0Q4JClCCO/9FDMLVreRaHo6LJe3DDegbiFyKvyIHIN1d9iVhdUbNYO3niQvL1L0P4v3jvUO25zwzm6rxaD4ecvPxN8S2GNuzVe5S/+YYO21qbCVikX8Bdt9MC0l7Uygk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Kairui,

On 10/17/26 at 02:39am, Kairui Song wrote:
> On Tue, Sep 01, 2026 at 02:37:53PM +0800, Baoquan He wrote:
> > Rename the existing PMD-level filter array (filters -> pmd_filters) and
> > add a second, coarser pair of PUD-level Bloom filters (pud_filters).
> > The PUL filsters operate at 1GB (PUD) granularity, whose 512 PMDs would
> > all fail the PMD-level filter - a general suppression of unnecessary page
> > table walks. Cross-node empty walks are the most visible case: a foreign
> > mm's PUDs have no young entries for this lruvec, so the entire PMD
> > iteration is pure waste.
> > 
> > Generalize the Bloom filter helpers (test/update/reset_bloom_filter ->
> > __test/update/reset_bloom_filter) to operate on a generic filters array,
> > and add thin wrappers (test/update/reset_pmd_bloom_filter) that pass the
> > PMD-level array, so the PUD-level pair can reuse the same hash,
> > double-buffering and reset.
> 
> Hi Baoquan,
> 
> This is really nice idea, thanks! And sorry for the late response.

Thanks a lot for careful reviewing, and I am sorry I just missed it.
Please see the reply at the bottom.

> 
> > 
> > No behavior change yet; the PUD filters are populated and used by later
> > patches.
> > 
> > Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
> > ---
> >  include/linux/mmzone.h |  6 ++++--
> >  mm/vmscan.c            | 45 ++++++++++++++++++++++++++++--------------
> >  2 files changed, 34 insertions(+), 17 deletions(-)
> > 
> > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > index f75daa6cd02d..faf28d35065d 100644
> > --- a/include/linux/mmzone.h
> > +++ b/include/linux/mmzone.h
> > @@ -612,8 +612,10 @@ struct lru_gen_mm_state {
> >  	struct list_head *head;
> >  	/* where the last iteration ended before */
> >  	struct list_head *tail;
> > -	/* Bloom filters flip after each iteration */
> > -	unsigned long *filters[NR_BLOOM_FILTERS];
> > +	/* PMD-level Bloom filters flip after each iteration */
> > +	unsigned long *pmd_filters[NR_BLOOM_FILTERS];
> > +	/* PUD-level Bloom filters flip after each iteration */
> > +	unsigned long *pud_filters[NR_BLOOM_FILTERS];
> 
> Or could we have macros like:
> BLOOM_FILTER_LEVELS 2
> BLOOM_FILTER_PUD 0
> BLOOM_FILTER_PMD 1
> 
> (just personal flavor).

Very great flavor, have taken it in my v3.

> 
> >  	/* the mm stats for debugging */
> >  	unsigned long stats[NR_HIST_GENS][NR_MM_STATS];
> >  };
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 55d43ab54459..cd09c5b8af8c 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -2842,14 +2842,13 @@ static void get_item_key(void *item, int *key)
> >  	key[1] = hash >> BLOOM_FILTER_SHIFT;
> >  }
> >  
> > -static bool test_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long seq,
> > -			      void *item)
> > +static bool __test_bloom_filter(unsigned long **filters, unsigned long seq, void *item)
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
> > @@ -2858,14 +2857,13 @@ static bool test_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long s
> >  	return test_bit(key[0], filter) && test_bit(key[1], filter);
> >  }
> >  
> > -static void update_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long seq,
> > -				void *item)
> > +static void __update_bloom_filter(unsigned long **filters, unsigned long seq, void *item)
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
> > @@ -2877,12 +2875,12 @@ static void update_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long
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
> > @@ -2890,7 +2888,24 @@ static void reset_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long
> >  
> >  	filter = bitmap_zalloc(BIT(BLOOM_FILTER_SHIFT),
> >  			       __GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN);
> > -	WRITE_ONCE(mm_state->filters[gen], filter);
> > +	WRITE_ONCE(filters[gen], filter);
> 
> So the helpers will be something like
> test_bloom_filter(mm_state, level, ...), seems a bit cleaner?

Yes, it makes code much cleaner. I wil use it in v3. Thanks again.

Thanks
Baoquan

