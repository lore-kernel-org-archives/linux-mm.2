Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42CD8FEA837
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 08:56:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FC1C6B0005; Wed, 25 Mar 2026 04:56:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AD736B0089; Wed, 25 Mar 2026 04:56:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79C0A6B008A; Wed, 25 Mar 2026 04:56:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 684366B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 04:56:08 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 12410C29EE
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 08:56:08 +0000 (UTC)
X-FDA: 84583978416.30.0410033
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3950110000C
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 08:56:05 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nZV4GWtn;
	spf=pass (imf05.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nZV4GWtn;
	spf=pass (imf05.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774428966; a=rsa-sha256;
	cv=none;
	b=TfuW8G7g9UG/uL/NH0TwWaQ+0J46S+AaFwygo+ytimSVdbGzz+0fbKlqQ2+0U65TJdxO5V
	vY7FWeP7wHinrYjJraEJtavvfDIf+jPdk11lKZ/btaqPIi6WQsuZX32egqPxHORn9SpsY9
	xr4B7SL16xYhkrk/JMh7qU8nvaVckK0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774428966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PP9ZaWjF4kkscfMWl4N5NvAvTpHMI/CLS4RpQGDbPQE=;
	b=wRT6XhleNk5RHPH+klhmKy3sXIY5TKkHTKKLPHLqMXCuxzFEDV6diBY8KLlb+jXJXvFR0H
	TsS8n+yhDounGRxqrs6hp8mXLZ7uGaU3MF626ONePjELOMVva9AtOltoHfAJ4QwbqYfr8X
	SPBTfXuG60ApPU8toMwuYKk3NCv4i14=
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-59e4989dacdso6484353e87.1
        for <linux-mm@kvack.org>; Wed, 25 Mar 2026 01:56:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774428964; x=1775033764; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PP9ZaWjF4kkscfMWl4N5NvAvTpHMI/CLS4RpQGDbPQE=;
        b=nZV4GWtn8OlNSTelATYXQ+kXBEnXyzD75Yb+owYdj2may6DeaAqu/d3q5iWOVzC3zU
         7zQo3kBa/xFhZzBII35hTAEqYa/DtWkoxIHTtPe48T5r+JU9H063Urqn9gkEoRbrhzSJ
         2J9gG8C22JbzUAnWg3EWhF66LEtlrkhbUGB7Keuhny8c5JC7uHZz7estytIr25YZbMlM
         Uvkl2Hw/M0NZJfxTXY0joLStQCfjDatpJEtlVubc78JErPV2udlfqn4sxswNAd0Y4fa6
         kqSfUGr3nqqguDI5d/cuTzS7+M6YGRM31XRBcgyE+AR0/AqcUxknXYn9tdiJiqITYIb1
         RoGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774428964; x=1775033764;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PP9ZaWjF4kkscfMWl4N5NvAvTpHMI/CLS4RpQGDbPQE=;
        b=X5FWJfa6oOWZbTS85ElqEtniCkIq7BZHR+5TvMK8FaUfnJ22zw1XGWqCIWpqM3GNDV
         ZKznSU67j8xHMa0TYA9Ua+ddbFlLvvLQvHbkmnyumHQAWCwayfeR+1vMcgKu7OEvb2TI
         9N7qM+BqH3T3d4H+RSB81qZ3MBFuKY/pS+MjHvjyQ7oW/C2+24lq1y47T35vsEhISAZ2
         8ELuskWDLehMKGNaJv4o+j4iey5Qo0MxCtSOgBTUSv88rumUIMdQqOHENToNthtjrBxn
         sxgpaDzh1SCSQ4tx7yCN55havgyUCW6k+yv9ICyyFt119P7I9kuUIV7UW/x61c4vLtSr
         5cJw==
X-Forwarded-Encrypted: i=1; AJvYcCW9asOiJiUIuqOfT7X1+Quqgo1ipOF5wCZNvvwGtBYSVMCxk5XSUY8SuFCHLyY21lWM/8gMVcMIcQ==@kvack.org
X-Gm-Message-State: AOJu0YxhZMwUPlOHrr0x0RMuBCMrRHspfiU4wpTONM9lXP220neTfqnZ
	UXQTcYu0BoMAJs+SgNyBLAtFGK/rh0xOYk9DmMGsDT8yTEhcEyqk9Tub
X-Gm-Gg: ATEYQzxOaBiIdBRCz6dgDduaHL3+jgYK2f9VQeWU2/0/N+ywRDtLQD+NwietmzYg4Fo
	Miu+qC6S7nGze34wsPM73wMRoRd1KvHT6lPWEA8b74CNTuJAMoxjwzMLm3F9eC9PE9SDgVyRkGi
	fflIs7dJ+USRRmutm37MJQNDrOzocRkqyCz44+7SWDmUyVE3U2l9A7XazgZnnz5FgfQO3lOzvKm
	aMPDN3O6ZEZgyri/xg5ZROcbC7ZkK4zYlyQtCn2YPxzeYpZfWwkEjxThBxrTsd4o4IyCzz2la9/
	yg41+v5ww3U62RVO31QVJeC2nHoZKKgpL6SawPlGGn1VEJMadWWKOSlGg5tW2GN1rLAsX8T0iE4
	+FEUKNvdCKHCEbR0+rIf4egrK5sMr5kluTG2eLl2WmHW4EHAXkAWXg7/B7nKgyYXY
X-Received: by 2002:a05:6512:6181:b0:5a2:7b43:62da with SMTP id 2adb3069b0e04-5a29b992dabmr963125e87.30.1774428963937;
        Wed, 25 Mar 2026 01:56:03 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a285192b44sm3673978e87.5.2026.03.25.01.56.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 01:56:03 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Wed, 25 Mar 2026 09:56:01 +0100
To: Zi Yan <ziy@nvidia.com>
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Uladzislau Rezki <urezki@gmail.com>, Nick Terrell <terrelln@fb.com>,
	David Sterba <dsterba@suse.com>,
	Vishal Moola <vishal.moola@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
	Ryan.Roberts@arm.com, david.hildenbrand@arm.com
Subject: Re: [PATCH v3 2/3] vmalloc: Optimize vfree
Message-ID: <acOjIcqyIVY9KNn0@milan>
References: <20260324133538.497616-1-usama.anjum@arm.com>
 <20260324133538.497616-3-usama.anjum@arm.com>
 <1D88CFF0-8A74-413F-9A6A-39E27B760AE1@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1D88CFF0-8A74-413F-9A6A-39E27B760AE1@nvidia.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3950110000C
X-Stat-Signature: rjingkkdyjdd4kcmk9jhzhhf77o4b6uh
X-Rspam-User: 
X-HE-Tag: 1774428965-779507
X-HE-Meta: U2FsdGVkX19QitdHKOUew+RZyMijGUPTd+JrCw3xmuz48sOgWpl2XBO+GbJ268JGL6ws4t4nazrnHkiTsp7A8pEtm+QXRSaLYOGYXlfleR2KeLN7WTgQ0B9BkMooqcZu6ItkgJRQ2dWT9ZnPvMmx7Co1v5bEWmw1LG/V4O3jikyBZUl2KkQRPApTgqt4kM4feAlvp1IvNy1gkLczfpORNzVcLkQc79BDffVl1ptaL8UZhepslZcrS98Bo+QEolC9iPkXZYU9aCCsbVUSKfpywn2V49F/TKlpWM+sM4cNa6NMHsi3j1mHiQ9VdPdpPEvJ7PSBKjgFC+Q3gGIB3TACSy2pLulDS0v1fNZXXIQrYHLd7UdfIWNG4Mrsg/OVKhVtvUhhfynYPOaZpQCZXqcj11+gNiwUwy6J1/PKc+s7fPn5l3A7uFuZE3YcC8YINayWgxchfglg0tx0fLJwagUFV9kd2qq1xLsLkyTcLhza3JYQ6snR9epqLiKpdV/nyihsItZwOHAn0gRM8UjOWe7rrvR6vyY9+Uk0OjtGlNOXlVV9FnorKjR6AVeA0gE0642pKG1H6KzC1k7LsPH9gk17PBkWmxhrD3jyNecrhtCzHXNIz6Qe/nOkAMx7Uk6VjFAY850kRaSbWnPbq1xygkJ2x23AuZrxkgLFZeZPxy/zOfuxwluDVeXdAX0DqIQEUEUd9v9Cwjl9wRYvKspm/8ySxtjq30YhctJbw+HjdLm/PgRRhKAqxcGenf8YaE0iMoAens15klmifrlN0yVrMmr+Ul9o2kpSORTIOuXM0Z3A5zGUjIL9cTTEfjO8/TOfej6L38soGJGNwiTHYrvhpUuzotKkuec3XUQ1CtzVt7+Bp2f63pNykdqKt2vGgdMVtwyAtkfTbPzDsm2yOixpy//Z+TNegHQJ/7JX6Cx+IAVv99XID5AYGIn3pPD5ehoSdxdhdiNjQkX8Zi2AuXwrD6w
 NN52r1lB
 5/qCwNAAShTyV1tkFzLHeSu8rTo9mWRbElNso5NxUnJCvsg8QuUnDlPYXe1Xqwa+M7KFTHB1aCfATzy982Z0PBe07Hg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 24, 2026 at 10:55:55AM -0400, Zi Yan wrote:
> On 24 Mar 2026, at 9:35, Muhammad Usama Anjum wrote:
> 
> > From: Ryan Roberts <ryan.roberts@arm.com>
> >
> > Whenever vmalloc allocates high order pages (e.g. for a huge mapping) it
> > must immediately split_page() to order-0 so that it remains compatible
> > with users that want to access the underlying struct page.
> > Commit a06157804399 ("mm/vmalloc: request large order pages from buddy
> > allocator") recently made it much more likely for vmalloc to allocate
> > high order pages which are subsequently split to order-0.
> >
> > Unfortunately this had the side effect of causing performance
> > regressions for tight vmalloc/vfree loops (e.g. test_vmalloc.ko
> > benchmarks). See Closes: tag. This happens because the high order pages
> > must be gotten from the buddy but then because they are split to
> > order-0, when they are freed they are freed to the order-0 pcp.
> > Previously allocation was for order-0 pages so they were recycled from
> > the pcp.
> >
> > It would be preferable if when vmalloc allocates an (e.g.) order-3 page
> > that it also frees that order-3 page to the order-3 pcp, then the
> > regression could be removed.
> >
> > So let's do exactly that; use the new __free_contig_range() API to
> > batch-free contiguous ranges of pfns. This not only removes the
> > regression, but significantly improves performance of vfree beyond the
> > baseline.
> >
> > A selection of test_vmalloc benchmarks running on arm64 server class
> > system. mm-new is the baseline. Commit a06157804399 ("mm/vmalloc: request
> > large order pages from buddy allocator") was added in v6.19-rc1 where we
> > see regressions. Then with this change performance is much better. (>0
> > is faster, <0 is slower, (R)/(I) = statistically significant
> > Regression/Improvement):
> >
> > +-----------------+----------------------------------------------------------+-------------------+--------------------+
> > | Benchmark       | Result Class                                             |   mm-new          |  this series       |
> > +=================+==========================================================+===================+====================+
> > | micromm/vmalloc | fix_align_alloc_test: p:1, h:0, l:500000 (usec)          |        1331843.33 |         (I) 67.17% |
> > |                 | fix_size_alloc_test: p:1, h:0, l:500000 (usec)           |         415907.33 |             -5.14% |
> > |                 | fix_size_alloc_test: p:4, h:0, l:500000 (usec)           |         755448.00 |         (I) 53.55% |
> > |                 | fix_size_alloc_test: p:16, h:0, l:500000 (usec)          |        1591331.33 |         (I) 57.26% |
> > |                 | fix_size_alloc_test: p:16, h:1, l:500000 (usec)          |        1594345.67 |         (I) 68.46% |
> > |                 | fix_size_alloc_test: p:64, h:0, l:100000 (usec)          |        1071826.00 |         (I) 79.27% |
> > |                 | fix_size_alloc_test: p:64, h:1, l:100000 (usec)          |        1018385.00 |         (I) 84.17% |
> > |                 | fix_size_alloc_test: p:256, h:0, l:100000 (usec)         |        3970899.67 |         (I) 77.01% |
> > |                 | fix_size_alloc_test: p:256, h:1, l:100000 (usec)         |        3821788.67 |         (I) 89.44% |
> > |                 | fix_size_alloc_test: p:512, h:0, l:100000 (usec)         |        7795968.00 |         (I) 82.67% |
> > |                 | fix_size_alloc_test: p:512, h:1, l:100000 (usec)         |        6530169.67 |        (I) 118.09% |
> > |                 | full_fit_alloc_test: p:1, h:0, l:500000 (usec)           |         626808.33 |             -0.98% |
> > |                 | kvfree_rcu_1_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |         532145.67 |             -1.68% |
> > |                 | kvfree_rcu_2_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |         537032.67 |             -0.96% |
> > |                 | long_busy_list_alloc_test: p:1, h:0, l:500000 (usec)     |        8805069.00 |         (I) 74.58% |
> > |                 | pcpu_alloc_test: p:1, h:0, l:500000 (usec)               |         500824.67 |              4.35% |
> > |                 | random_size_align_alloc_test: p:1, h:0, l:500000 (usec)  |        1637554.67 |         (I) 76.99% |
> > |                 | random_size_alloc_test: p:1, h:0, l:500000 (usec)        |        4556288.67 |         (I) 72.23% |
> > |                 | vm_map_ram_test: p:1, h:0, l:500000 (usec)               |         107371.00 |             -0.70% |
> > +-----------------+----------------------------------------------------------+-------------------+--------------------+
> >
> > Fixes: a06157804399 ("mm/vmalloc: request large order pages from buddy allocator")
> > Closes: https://lore.kernel.org/all/66919a28-bc81-49c9-b68f-dd7c73395a0d@arm.com/
> > Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
> > Co-developed-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> > Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> > ---
> > Changes since v2:
> > - Remove BUG_ON in favour of simple implementation as this has never
> >   been seen to output any bug in the past as well
> > - Move the free loop to separate function, free_pages_bulk()
> > - Update stats, lruvec_stat in separate loop
> >
> > Changes since v1:
> > - Rebase on mm-new
> > - Rerun benchmarks
> >
> > Made-with: Cursor
> > ---
> >  include/linux/gfp.h |  2 ++
> >  mm/page_alloc.c     | 23 +++++++++++++++++++++++
> >  mm/vmalloc.c        | 16 +++++-----------
> >  3 files changed, 30 insertions(+), 11 deletions(-)
> >
> > diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> > index 7c1f9da7c8e56..71f9097ab99a0 100644
> > --- a/include/linux/gfp.h
> > +++ b/include/linux/gfp.h
> > @@ -239,6 +239,8 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
> >  				struct page **page_array);
> >  #define __alloc_pages_bulk(...)			alloc_hooks(alloc_pages_bulk_noprof(__VA_ARGS__))
> >
> > +void free_pages_bulk(struct page **page_array, unsigned long nr_pages);
> > +
> >  unsigned long alloc_pages_bulk_mempolicy_noprof(gfp_t gfp,
> >  				unsigned long nr_pages,
> >  				struct page **page_array);
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index eedce9a30eb7e..250cc07e547b8 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -5175,6 +5175,29 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
> >  }
> >  EXPORT_SYMBOL_GPL(alloc_pages_bulk_noprof);
> >
> > +void free_pages_bulk(struct page **page_array, unsigned long nr_pages)
> > +{
> > +	unsigned long start_pfn = 0, pfn;
> > +	unsigned long i, nr_contig = 0;
> > +
> > +	for (i = 0; i < nr_pages; i++) {
> > +		pfn = page_to_pfn(page_array[i]);
> > +		if (!nr_contig) {
> > +			start_pfn = pfn;
> > +			nr_contig = 1;
> > +		} else if (start_pfn + nr_contig != pfn) {
> > +			__free_contig_range(start_pfn, nr_contig);
> > +			start_pfn = pfn;
> > +			nr_contig = 1;
> > +			cond_resched();
>
It will cause schedule while atomic. Have you checked that
__free_contig_range() also can sleep? Of so then we are aligned, if not
probably we should remove it.

--
Uladzislau Rezki

