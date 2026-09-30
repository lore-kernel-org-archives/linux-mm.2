Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C35ECA5FC5
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 14:06:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 773706B0088; Wed, 30 Sep 2026 10:06:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 724C36B008C; Wed, 30 Sep 2026 10:06:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 613886B0092; Wed, 30 Sep 2026 10:06:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 37A516B0088
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 10:06:48 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D36BA1C38F4
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 14:06:47 +0000 (UTC)
X-FDA: 85270604454.06.9A6686D
Received: from mail-qk2-f43.google.com (mail-qk2-f43.google.com [74.125.230.235])
	by imf09.hostedemail.com (Postfix) with ESMTP id AD60E140004
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 14:06:45 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=a3prfw8V;
	spf=pass (imf09.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.230.235 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790777206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w7/ZyRNe756x2qIILuqRWig+Ez86Z+PdUS4umWMDN+k=;
	b=RII0MugBFZudg2/aDqTVoTZrtUWQ8QYU0NtcQR/dPOZ+Zb5/cbEKi4soWAhHrOwjcfAZae
	kteGjLahZOK7IJ3fRMiQodakjNmcf9LpHHYyeKOmda9SdbGgKbZq5BRfcwkcoQr9qHw55S
	+96jXuZQQD3gXCb7CcyoNiSpFQASTFA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790777206;
	b=GbLLnDr3roR3Zpx+JLs4wTruPIXOjeSNf7ZWR+6yrjtlk7VimPeZZPWVQaIhqaQm4MFNbv
	MDNXg8YvsipGyH9Jj1ZKJPLwX1ygfaaInrmvJK8zgeB2YM163Xa3br/HzoU5STbCeynTns
	FuxqbwnId8/f+9nmVW38xTTaGhkUPYA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=a3prfw8V;
	spf=pass (imf09.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.230.235 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qk2-f43.google.com with SMTP id af79cd13be357-93ca50c8ba6so89435685a.2
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 07:06:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1790777205; x=1791382005; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=w7/ZyRNe756x2qIILuqRWig+Ez86Z+PdUS4umWMDN+k=;
        b=a3prfw8VK43AKDZkkZa2Xn1wJpdC2h6g/Dx/moi+2lQMK3szAF1eVm9gOu/p3y0bq7
         ruBsXR8hSElagYR51tr9ltp/d9F+SqWoyEUoRhuXCW+VDcq8a6f7MXTCCIgbX1olQDnj
         06j1XgU9TqrSMun4KgwK7dBx8pB+kzL5xWelErSs+TRo7xQnnqiBuqYQyLjTuRymqL0R
         S+M4fJRGqdp6VZ7rrz+uuLn84VaVXbQQg0jKwdrDZ49+B4r02GEvn5ambKEa8se++AP1
         2AG01qk7PZ3cllcMUuJILZCCqWdWl5hVusSBvxGWPoJwDss6Fug3frO1EVYFBDte2VSc
         /VWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790777205; x=1791382005;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=w7/ZyRNe756x2qIILuqRWig+Ez86Z+PdUS4umWMDN+k=;
        b=fP6N8zc04htF4MziQYlHzZ1RyKQQmQUpMCx9Q53SLqLG6GBXHf96UcO90gGInz+rJM
         JnCM2ERC1EYrMreogO91+NkmpmZFnBoboUN/f4IIerzwHNi9yorJ8d8IV9geY1jO7TdV
         uLFy+nJkUDrmnOXef0OCh78U/kncOowqfSQxbox9DIXfugcVBnWxLzCDItF8c4lYZXi8
         BS0JHWp1brFM491d1J1vBsaMjn3GvgvXuSXUQ1n+Hd1KUUhNssQyoOZjVBT9u3k408az
         WPwcspNQzYy3NxHdWKagTySLHIq4XA5BbXxSQUHPFJKWDeUGUedxDbMqyNVUYr2ncVou
         0yvQ==
X-Forwarded-Encrypted: i=1; AKwUvBwlXIErVfiVQ5qLIlLGw1QFtZSM8zQ6EsvSGNG/qiG04mEkaxZtmW5Yv4jt6mt9zf86WYXNfFqgdA==@kvack.org
X-Gm-Message-State: AFuF++mW2nrWFdWyyUWBR/iLhhJZ1Ij1OXBgrVxD8ge4tvFwpqL8DkCr
	uqQ2Gc6Yo31LIye6CJlNseuKoky5GCFvLekpIqFfyr3CSJs3Ls4Mmm06UQkPkXUxoxY=
X-Gm-Gg: AYBFou0hQEb6pifOgPeuH4CzqwrGlCiwmakp9Rkx0NYR6fS3n85nfdZ1LDJxzWKXN8t
	lPHcOXOr/o7qVeX+HX8/sJdSltQOc6S5XcKNrjD4BddnMb45tnhpyKTAfnTIJLovs0YAggNcLtH
	yKkOQaqsgVuf15jEgaoxng1Yfo5neEwf/p1v6GrCWozEfKu2HuVG9JdLxm7B95wE1VcaWF2U8D4
	yfOxUGLNTtjhre4Dk1HAaweAcFtWfZwQHE9b8xtixPAqk+DIVORszJLRr2j7FOZKaUHYqSDU8tY
	H/uYCcsqavw8Uu7PcYVfc+0b4HQP0Uh9rR+JIjO+nUGgTu5bMOrUVSmRYs9+VYC/JA8hwFqKgR5
	f9A/N8J2xk5vqfjWDwqMzAogMziJDMh7Zy10hqkFyhcQg+2srI0SX9Z3eCJ32+XosmpZSehqu3/
	PqU1PoaeaSEpwMouBT6jDsnPZmEhAzL7/MbkQgy3UtgBaTWSqsbu5CXJWIyQ3H9XeLz4PGjH0rv
	DTwa7k=
X-Received: by 2002:a05:620a:1a20:b0:939:f89:3688 with SMTP id af79cd13be357-93ca973661dmr258616985a.42.1790777203446;
        Wed, 30 Sep 2026 07:06:43 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93ca83283besm122303285a.40.2026.09.30.07.06.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 07:06:42 -0700 (PDT)
Date: Wed, 30 Sep 2026 10:06:38 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Harry Yoo <harry@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>, Shakeel Butt <shakeel.butt@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH] mm: page_alloc: make defrag_mode retries follow the
 promoted order
Message-ID: <ar0Xbs9mEu-vUHvc@cmpxchg.org>
References: <20260929174553.175333-1-kirill@shutemov.name>
 <arv8J7ysrdazJmfY@thinkstation>
 <ar0NRMxps8UErXaQ@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ar0NRMxps8UErXaQ@thinkstation>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AD60E140004
X-Stat-Signature: s5f1rq1ndokwqcnmc4emm5kpngbf7j8x
X-Rspam-User: 
X-HE-Tag: 1790777205-954087
X-HE-Meta: U2FsdGVkX1/Hk6VlvG4ZZrZfPtQeBJ0eoBsQIP6002c1kJVg6+NOc4gC3sd3krZXwnCuaHyskttq8zU8BHZ2tuAeZ7IGD8DahBmhvqRDdAVydWu6I3LwhzeFtqndxYo936BEvCiAsv3hx1Ve+vQ2rWBUtDNwy/6KRpcKpuSS4RW98KriBkk7jEb/JDZXwbeN2m+NYgTdipULQTm2s38+7qJ7iNgRR82rDufQYrApeebj8VWuA5fnoZhPMGPVmOfGInHxpnY69wMcvCkr7Ffdlwjpu8IEDQEaavQyKXDWro5mAfyyDSNucSJiPRUuGDCnT9olZYoE5cJlZKC2cl5gC0sKIaASI3akJHSahjNOKlgkHp7mEyvct+2M0jUXHj5xhgScUQUr8+s98zn6clFIm9dDWB4vzNkMhQQxhd2XC1oD4mgne9qcg8+71i4hzUw6u2Lgjsd0ZmLaLrFW+OrvnmLBrNbanjxkrnzb8t1nTxVTh0MK0Z47jIXNTpSa1nLvUH7R19Nl3WHNqFOxJLVZ/w9jGzotGLKmKeyL2P6Ndx3lUm2Xx2p8PAfMwxASKa763tytOJREtFiqR4uB7JoksKDTxufNnnoTCZxBRIIfxl9bdvl9EvB1vMRsfv3BXma4X9xXp0FQEnjcqutn63MaenfoqD76d1WuosL67/l32t7Kl4Uz5JQ1ps+e2vJmLPR4qP3wWZhyG9u3xX+Vs5KSPyq9MVeZHQFZSqxWWvSx6IX48N4fi1jsAgkmDx3EUIQEkKVEMVdkz/+h+mt+ZjXMycq3un0c2KX/38Dbee/vStX8Qju9yn1V++yfvBLaDPLdxXqWtlG3Z9gRhPEKy1P/il9vXRafOFSgNvcBt3E5wIOW7bRkMhxS8QAkYgPIxzG8qvJ6gjCbujwPm3gIx1bqg07IbY03ELs5t6ZHnuNgUo+5d6vC1ABqyuXYtie41jTHdTIyG+R9aaSnsx9uwpj
 qJTfULKM
 Lxo0/LRnAnIcmxIXVF7zbLd0b8dDDSIIxcQaORDkX2d6Y09WH+gZIiLMrIpPcKDhg9JYuUhveMNeUGhnJJvaknIEiomWurEc72Lh0jb7gOOybp5s3BvsgNEmU06ZPNjg+5VqxIk4dMxvl6D/LflWV+61W+LiZmgfNVlq7G2Epvkl/uSDb0uOg2gM67l6wV7gwzS4dNKQo4r71aqMEE6rqNwrUHbK5U8Ybq6DZZcRK47aB0yk1c8pdVN5fzygt2OkK7zsd9A4yjjc92L5bQY2Am6R2/YLr2oNsEH30kBS7a5c7hAZPteef3OqrTYY138Zc2uJF5YNYV8dSg08QhRie4ekyu3vQgZx9qFgKWC9bxOpeTkG/ehE8uqBAm8Ue0dftW2/I+Psy6w9E5mZnRxh1RUVGhtW10FPu/E+5mhxl1HeA5egEUVabpHeDcUE6bYfA4vlWCifBbmTORGO8MaBUIysyz3YjXSA6aXi6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 30, 2026 at 02:32:12PM +0100, Kiryl Shutsemau wrote:
> On Tue, Sep 29, 2026 at 07:39:41PM +0100, Harry Yoo wrote:
> > On Tue, Sep 29, 2026 at 06:45:51PM +0100, Kiryl Shutsemau wrote:
> > > From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> > > 
> > > Since commit 7e8756d7ad22 ("mm: page_alloc: fix non-movable reclaim
> > > storm in defrag_mode"), direct reclaim and compaction for non-movable
> > > requests under defrag_mode run at pageblock_order, to produce the whole
> > > blocks that ALLOC_NOFRAGMENT needs.
> > 
> > > The retry decisions that follow still use the request order.
> > 
> > Indeed, good catch!
> > 
> > > An order-0 request can therefore retry
> > > indefinitely without ever reaching the ALLOC_NOFRAGMENT fallback:
> > > 
> > > - Reclaim at pageblock_order gives up after one pass as soon as a zone
> > >   looks compaction_ready(), and do_try_to_free_pages() then returns 1
> > >   even though nothing was reclaimed. It returns before the retry that
> > >   would reclaim memory.low-protected cgroups, so when most memory is
> > >   protected, the pass that did run finds next to nothing.
> > >
> > > - Compaction at pageblock_order fails or is deferred.
> > > 
> > > - should_reclaim_retry() takes the reported progress as progress for
> > >   the order-0 request and resets no_progress_loops. The request
> > >   retries.
> > 
> > Makes sense to me.
> > 
> > > Order 1-3 requests loop the same way, and should_compact_retry() also
> > > checks their pageblock_order compaction result against the request
> > > order.
> > > 
> > > On a production host (64G, defrag_mode, memory.low covering most of the
> > > workload), 95% of direct reclaim runs were order-9 runs that returned 1
> > > with nothing reclaimed, at up to 60k runs per second. Across ~200M
> > > should_reclaim_retry() calls in a day, no_progress_loops never left 0.
> > > The spinning allocations were SLUB slab refills for inode and dentry
> > > caches. The time spent registers as memory pressure, and pressure-based
> > > OOM killing takes down both workloads and system services.
> > > 
> > > Treat promoted requests like costly orders:
> > > 
> > > - Reclaim progress does not reset no_progress_loops for them.
> > > 
> > > - should_compact_retry() checks the compaction result at the promoted
> > >   order. It does not retry COMPACT_SKIPPED, since the request can fall
> > >   back, and it does not escalate compaction to COMPACT_PRIO_SYNC_FULL.
> > > 
> > > When the fallback is taken, reset the retry counters, so that the
> > > fallback attempt gets a full retry budget before the OOM killer is
> > > considered.
> > > 
> > > In a VM reproducer (32G, defrag_mode, inode churn under memory.low):
> > > 
> > >                                         before    after
> > >     should_reclaim_retry() calls           63M     293k
> > >     peak memory pressure (PSI some avg10)  99%      12%
> > > 
> > > File creation runs 5.7x faster.
> > > 
> > > Fixes: 7e8756d7ad22 ("mm: page_alloc: fix non-movable reclaim storm in defrag_mode")

Thanks for fixing this. Ironically, the same workload blowing up again
that I tested the old fix again for 3 weeks :(

Back then, the problem was: allocating thread is spinning on a goal it
doesn't help accomplish.

Now the problem is: allocating thread spinning and helping, but goal
is not achievable.

> > > Cc: <stable@vger.kernel.org>
> > > Assisted-by: LLM
> > > Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> > > ---
> > >  mm/page_alloc.c | 85 ++++++++++++++++++++++++++++++++-----------------
> > >  1 file changed, 56 insertions(+), 29 deletions(-)
> > > 
> > > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > > index 12fac9084c48..608487672d93 100644
> > > --- a/mm/page_alloc.c
> > > +++ b/mm/page_alloc.c
> > > @@ -4127,6 +4127,31 @@ __alloc_pages_may_oom(gfp_t gfp_mask, unsigned int order,
> > >  	return page;
> > >  }
> > >  
> > > +/*
> > > + * If fallbacks are not permitted (defrag_mode), we either need to
> > > + * reclaim space in a block of matching type, or clear out an entire
> > > + * block to allow __rmqueue_claim() to convert.
> > > + *
> > > + * Reclaim by itself is primarily freeing space in movable blocks,
> > > + * since that's where the LRU pages live. So this works for movable
> > > + * requests, but not for others.
> > > + *
> > > + * For those, promote the order of reclaim and compaction to help make
> > > + * blocks, instead of spinning in reclaim alone unproductively. Retry
> > > + * decisions based on the outcome of that work - reclaim progress and
> > > + * compaction results - must account for the promotion as well, see
> > > + * should_reclaim_retry() and should_compact_retry().
> > > + */
> > > +static inline unsigned int nofrag_promote_order(unsigned int order,
> > > +						unsigned int alloc_flags,
> > > +						const struct alloc_context *ac)
> > > +{
> > > +	if ((alloc_flags & ALLOC_NOFRAGMENT) && ac->migratetype != MIGRATE_MOVABLE)
> > > +		return max(order, pageblock_order);
> > > +
> > > +	return order;
> > > +}
> > 
> > I think we should start distinguishing order and compact/reclaim_order
> > in __alloc_pages_slowpath(). Silently overriding it makes it harder to
> > follow and easy to make a mistake.
> 
> Agreed, four callers recomputing the same thing is asking for a
> mismatch.
> 
> I would rather not grow this patch, it has to go to stable.
> 
> I will look into a cleanup on top: __alloc_pages_slowpath() computes the
> promoted order once per iteration and passes it to direct
> reclaim/compaction and the two retry helpers next to the request order,
> so the helpers stop knowing about defrag_mode.

+1

All they really need to know is the split into requested order vs
production order (reclaim_order, compaction_order).

> > > @@ -4299,7 +4316,7 @@ should_compact_retry(gfp_t gfp_mask, struct alloc_context *ac, int order,
> > >  	/*
> > >  	 * Compaction failed. Retry with increasing priority.
> > >  	 */
> > > -	min_priority = (order > PAGE_ALLOC_COSTLY_ORDER) ?
> > > +	min_priority = (compact_order > PAGE_ALLOC_COSTLY_ORDER) ?
> > >  			MIN_COMPACT_COSTLY_PRIORITY : MIN_COMPACT_PRIORITY;
> > 
> > This would change how hard we try to compact with defrag_mode in direct
> > compaction as it won't try compaction with MIN_COMPACT_PRIORITY anymore.
> > 
> > It doesn't make much sense to change that as part of this fix?
> 
> It is a choice between compacting harder and falling back, which
> fragments a block.
> 
> It is a judgement call on what defrag_mode means.
> 
> It would also mean that order-0 allocation request promoted to pageblock
> can trigger SYNC_FULL compaction. I cannot say I understand the
> implications. Will give it a try with the reproducer.
> 
> Johannes, Vlastimil, any comments here?

I would leave this one with requested order unless the reproducer
disagrees.

There is a risk of defrag_mode self defeating over time by raising the
bar for fallbacks but not high enough. Every fallback we let through
will make it harder down the line to compact towards that higher bar.

There is also a non-zero risk of connecting order-0 request contexts
to SYNC compaction which they haven't done before 7e8756d7ad22. But
you traced the problem to retrying, not sync compaction itself.

