Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83E02C88E53
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 15:59:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BDD66B008C; Fri, 11 Sep 2026 11:59:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86F7B6B0096; Fri, 11 Sep 2026 11:59:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75E6C6B0098; Fri, 11 Sep 2026 11:59:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 37A156B008C
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:59:24 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9B3CBA45D1
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:59:22 +0000 (UTC)
X-FDA: 85201940964.06.19A59ED
Received: from mail-qk2-f8.google.com (mail-qk2-f8.google.com [74.125.230.200])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8AEC780008
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:59:20 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=JN6eImSq;
	spf=pass (imf02.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.230.200 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789142360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ql6yDYiCUfB1KtPKnMN8J1mkX0CDVMGXFwFiHiyB4X8=;
	b=osPK+rMAxSLM9tN2RIJncmomXBI2BYrhdHf4zUzRUHLsuxweYPYnM1TdP3nIpNUVvovAFd
	quC/Mgmyku/fSQH+nKgIDA5JO8xK7ZJb9yGSSuz/Ag48r+TVzXzbQ6GOSyZJQvXN7+9oWS
	AV95x1JiHtFmJVMzTkchUPDiqmKp7rE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789142360;
	b=kAyxnMVi2OVyi0AeLYzZE7JZkO1kZv37vinOlmoFcYxn+wMgkD9I21i6BptrSNLwE19ca3
	RJzOqIJ4vTNScMDl1jsLJXRUi5TRDgZxcaJzRSMGTFk+7zrtmc42dML4gdtlUpdO6fKCUc
	j22SZc2QFJBzHDroQXceepJB07zPQC4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=JN6eImSq;
	spf=pass (imf02.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.230.200 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qk2-f8.google.com with SMTP id d75a77b69052e-530e0062c97so1620201cf.1
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:59:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1789142360; x=1789747160; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ql6yDYiCUfB1KtPKnMN8J1mkX0CDVMGXFwFiHiyB4X8=;
        b=JN6eImSqtDbxe+yzfYVdjjWFJugq7AFjn8WNOAJkKNPugrQOukbtVQUje1gTRM1MDa
         m5mab/jVEXTwPmC803j3CbpMzOSOVbpWz72TtFxUbR4wb/Aw67TJ5a1YGooYtUosCbtA
         ArQpZqXCDNK3PkAF2kt230XAw7DMuHiPsiovzw5lX/OoLq0xmqrfDNECFr718A+hXJ1q
         RoQoB6HECw/8Ba0xm5F3ZJH1ERnV4973MfTb/2hdo5FkwLjKrKmbF3emik6TpJSMcoXC
         HVHJJKCZE7PB9odTh76ALKVD359uuvL2J3M5iln9cQkAMgXZMSanr7hQBrNWEPm2qmb3
         x3EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789142360; x=1789747160;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ql6yDYiCUfB1KtPKnMN8J1mkX0CDVMGXFwFiHiyB4X8=;
        b=JMTWF6zv9yyAGt3yTgWZ9zTXe2jlXACY+c0E9N98YwdQVb0voWekVVQWHHSqYVYZHP
         JdzN4vvDFh9cK6SOyHAIPU2r6b8D1PsIAbz0ARgk2Rme6woGe0ZaNHGUzSR9qNCWGakt
         yc/YEZN6/exvnNhHx69m1+NxRyto95OpY0m7c/Nr47J6EvDTNOC6l7ZUw5TmTBTN07Cm
         tYIHvRsqrfZla5OOCw4WMOQb2tgenvQE1bkOsTYmJwmcYCZNlGV7OSpyBOldcpnTiQjY
         nyEFtdnGqHN//2bH0aT4SE6fgh7VgkKKxDD4l/AnxF5ote5SQ7iSEITILRarHvv0lFHl
         0SXA==
X-Forwarded-Encrypted: i=1; AKwUvBy4EPQPyxp2DwiSOOl2+JM3RYtr106AYD5h6mxXrgpxovfk0L23RtKV/8vJ8oCatoTecnAdUag0Eg==@kvack.org
X-Gm-Message-State: AFuF++kMCzn6pAqWIXVPIj6wXhvGTtglLPgnFALh7qOTh0ZudTq7Uwt3
	/2Krkr1JXdQCP7Tx/RojzomkM3m2aMuLYRFk8jvdfu61PnYB4QS60hIwc8jUIvA54Ys=
X-Gm-Gg: AYBFou0Z10v2vGY4y4UysluTzm5DOiK8VQl2yv5WNY8d7NMdLCONaseUgLU2huzOg6W
	lczgMhCavRIWRJDPRsNMtLTzuIF/1btX/uZz3VRddkQi3viglVOvvJjWjzxnMda21vfJA8CWGUo
	trL7bNDmTrCZJfOmbrOzOHVOhqbNQdvYb9t5yz0T+xlcKrjf+NfeGVYdP5u5IcENHGbe+J2lRJ/
	rIrciNqL9UPgglrvVicj28r7uf1Qom8Wdw2rMgZyZ1PFU/G4voUrqpa9arZqSJG8aiAWImGly5M
	Muc/7LMm1w/OU/vWHHFlJK1xdR9ieJTby9WK4z0X/S8IxwOIO/5CbBhJI6vItaSAiv4TgCqNXFi
	OndF5GdFOOvCOb50i28dSscM89x4VZwK9x1Lj8xBeB5AchCQ5LWRNlv3rLigY6/tLofBTVJjHQv
	vx8B6nOyqVoUy48e8vXHit7MRGDKoZkUchj8KPdWXsSm2NNNCUrp5xf07dilinFCv+JlEDaQ==
X-Received: by 2002:a05:622a:2b0b:b0:52f:aa6c:bc7d with SMTP id d75a77b69052e-530c86d54b3mr75558611cf.28.1789142359223;
        Fri, 11 Sep 2026 08:59:19 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-530ca47efa2sm22945531cf.11.2026.09.11.08.59.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 08:59:18 -0700 (PDT)
Date: Fri, 11 Sep 2026 11:59:14 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Salvatore Dipietro <dipiets@amazon.it>
Cc: akpm@linux-foundation.org, abuehaze@amazon.com, alisaidi@amazon.com,
	blakgeof@amazon.com, brauner@kernel.org, brendan.jackman@linux.dev,
	david@redhat.com, dgc@kernel.org, dipietro.salvatore@gmail.com,
	djwong@kernel.org, hch@infradead.org, hch@lst.de,
	jackmanb@google.com, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, mhocko@suse.com, ritesh.list@gmail.com,
	rvvandan@amazon.com, stable@vger.kernel.org, surenb@google.com,
	vbabka@kernel.org, vbabka@suse.cz, willy@infradead.org,
	ziy@nvidia.com
Subject: Re: [PATCH v4] mm/page_alloc: avoid direct compaction for costly
 __GFP_NORETRY allocations
Message-ID: <aqQlUr-1h07G8JWM@cmpxchg.org>
References: <20260905174239.99e31515fabe220aa7d8e6fa@linux-foundation.org>
 <20260910114602.926944-1-dipiets@amazon.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260910114602.926944-1-dipiets@amazon.it>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: niuu6cfwtgpezu4of7x1ofz13ezi3wqr
X-Rspamd-Queue-Id: 8AEC780008
X-HE-Tag: 1789142360-462104
X-HE-Meta: U2FsdGVkX19Ct127Liv0c7l9lBfEVaZRKOfPl3AkiTDRvauUYfqVky+aFQys+JMS5OfuM1wwCPRBdFmsvtMg9eFwcjrq2EHJsocfe2bhlLrRZjP0c/3994J0EKFK+l9p5MlfLxK+pp3lgfPP6k2p500TBCE28KG1d14qsbiJeM7Fy4HC7XSJFMh+mJ1rpiqCh4uJf7AQZJOMe6YQLNpRwh8t7NaQW1y4LQ1omA3lu+YtSGe3gSBTFvqe7o8+6jDS2UNyqTNHulSVUC9KsIu6I2bm2BZOsP05Vmlw+wwBkEVMUz9/ryLmCDYeyi+koibu8FEgwCup8D3RMoayIETAik5Rw9KfZLnK7S/RPlkJg0q5ohozA9OcZsTaVtA2f1m+WDWp3e3KsA4XjCZm7x9otGnkRZkdIcs1fZwoXf0XwcbhV6jq+tlskIQqY8+1vJlGinHxVYHBDqN7n3FIR+BLc729iyYx1N1AvU3PiJV1vF8Hdur/Jyme0Na1X3SVHGldkvE5fA2+w/rcpEF0zhbjLrJbADEPmWxQ9he8USd/jhixArybetWju5ZaudwLegnFIGZo17rZtbktU+eYIhtonS7/FTHQJNG5p25uAjwZC9/PZfmBRn7Z5se3aSx67budh9Hqo6J6G6T8qPnccmPVNuEG6bEtchueVYjbkBCP2wefcQ86TBNcreL+6X/RSlBz1uaVLH04gRa9bgbHRkvDgiPwjY/Sz7kadyUW8QjnPcCg8VCO47pscLskgBlnNojP068yXULjTCopcHPO+4PghWeWxItC9L0SWbqxfM111kGZxP4qpSp5EhT4P3Jx+YxwJuoY4N+OAtQEBuOJ6/iciZey+XeAJwQ+ElPejjoKBWli+fYlGZI5UMRR1KD+gUr8ft8+6/V3snuDtHE/rmaKZ0rAIDI0oOyzEihkDzqO7ZekyREiG5sW47Lkp+R7Ssv41AFOlXjQsi/2n/wkZxj
 PmvCdoPF
 /T/i23YFyFICwUQbTL4TvR4FoawDnk+Wurb56sqkxtbfgnunzcdsw3hfHifaTkbdAkyDFHTEHjez6M99bfYQneeN+kgipwZceA2kH4rrfZ4N5dTZ2A8Hp1Gx2DXiHzVvL5VBFmyZhPLad8TSRnRr8j3jplzlaWHu1r5bEp4aFJs8X15DM9I2vork+DklRHwI6EZsRAkxaBJoIN+VLIEDfqdLlo8b5QeeHMDlJgIl48+r6wCrWmkrCo6wOzf/bRm30JbO9NQO+OLrv97rl2QKu4l52gTj0RO3DIvRPZDxscSQrhYeoM/yRjMYonRlvB4QtQHfiVvSuoa2dFCekDvULcUXP6ZgkAT3AnOIgPIaD7AcI0XwOWQ6KQ6lfNAk5IY2z8hafpHjKLp64xIgri8BeusiIGDuZRNZdOiSWMZfFCVmXYVrqsCi0z5iIPjMBljEh/tTGqRmOEoTlq9BfwUeBTTFqRQM6qBMNaPmQ/bnGygSiwzxeL4iHfU8BtYjb7EXcD24GfqofcJ2x8qFMqBWFyRj41Pj423xW+pt0mziaqXCRMfjVM9aMs0rZ+qvjPgXwA9legXxLzOy1rtsM7PD6+yIavOEIR6Lb60u1r8uOppZUr8asBL/HOm9aff9DO2l75OVwSjCuzDiqhfs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 11:46:02AM +0000, Salvatore Dipietro wrote:
> 
> On Sat, 05 Sep 2026 17:42:39 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > Is there anything particularly unusual about this test case?
> 
> It is a stock pgbench simple-update PostgreSQL workload on a large
> instance (96 vCPUs), using standard PostgreSQL settings and with no huge
> pages assigned to the database. We deliberately overprovision the
> pgbench clients: 1024 clients over 96 threads. That keeps enough writers
> in the buffered write path concurrently to hit the costly-order
> allocation failure path continuously. The memory fragmentation comes from 
> page tables: PostgreSQL spawns a new process per client, and those page
> tables consume ~40% of memory, which significantly limits the page cache
> and the free memory available.
> 
> 
> > > Results (average of 3 runs, TPS):
> > >
> > >   Config                   Avg TPS      % vs Baseline
> > >   baseline (no patch)       59,408       -
> > >   With this patch          155,409      +161.6%
> >
> > Is this back to pre-5d8edfb900d5 performance?
> 
> Yes - fully recovered. Here is the summary, same host and workload
> throughout, average of 3 runs:
> 
>   Config                                        Avg TPS   % vs baseline
>   AL2023 stock 6.1 kernel                       136,942            n/a
>   v7.3-rc1 baseline (no patch)                   59,408             -
>   v7.3-rc1, 5d8edfb900d5 behaviour reverted     151,184        +154.5%
>   v7.3-rc1 + v4                                 155,409        +161.6%
> 
> The 6.1 row predates 5d8edfb900d5 entirely. A different kernel version,
> so not directly comparable, but it shows the performance this workload
> used to get on this host.
> 
> A literal "git revert 5d8edfb900d5" does not apply to v7.3-rc1 -
> iomap_write_iter() has been rewritten since - so the reverted row is a
> one-line behavioural revert, forcing the write loop back to copying at
> most PAGE_SIZE per iteration:
> 
>   -	size_t chunk = mapping_max_folio_size(mapping);
>   +	size_t chunk = PAGE_SIZE;
> 
> which is what the pre-5d8edfb900d5 loop computed. That makes
> iomap_get_folio() pass no order hint, so the path issues only order-0
> allocations.
> 
> 
> > AI review asked a few serious-looking questions:
> > 	https://sashiko.dev/#/patchset/20260904115629.3993331-1-dipiets@amazon.it
> 
> Thanks for pointing that out. To address them, we can have something
> like the patch below. Performance results are still similar to v4. Happy
> to submit a formal v5 patch with it if you would like.

The feedback looks misleading to me.

ALLOC_NON_BLOCKING itself is fine, it usually only means something in
conjunction with other flags, like __GFP_HIGH. The access to
MIGRATE_HIGHATOMIC that it points out is in itself too generous. This
seems like a real but separate bug. It will allow GFP_TRANSHUGE_LIGHT
into the highatomic reserves as well, for example.

The rt issue seems made up too. We're talking about costly_order &&
__GFP_NORETRY allocations. Why would they need access to reserves?

>   Config                                        Avg TPS   % vs baseline
>   v7.3-rc1 baseline (no patch)                   59,408             -
>   v7.3-rc1 + v4                                 155,409        +161.6%
>   v7.3-rc1 + proposed patch                     161,994        +172.7%
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 12fac9084c48..be8b0d72a2db 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4784,10 +4784,22 @@ static inline struct page *
>  __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  						struct alloc_context *ac)
>  {
> -	bool can_direct_reclaim = gfp_mask & __GFP_DIRECT_RECLAIM;
> +	const bool costly_order = order > PAGE_ALLOC_COSTLY_ORDER;
> +	/*
> +	 * Costly __GFP_NORETRY callers have a cheap fallback to a lower order,
> +	 * so don't stall them in direct reclaim or direct compaction.  Exempt
> +	 * __GFP_THISNODE (the THP attempt from alloc_pages_mpol() needs direct
> +	 * compaction) and __GFP_NOFAIL (must not be made to fail).  Don't
> +	 * clear __GFP_DIRECT_RECLAIM from gfp_mask instead: that would also
> +	 * change the alloc_flags derived by alloc_flags_slowpath().
> +	 */
> +	const bool costly_noretry = costly_order &&
> +		(gfp_mask & __GFP_NORETRY) &&
> +		!(gfp_mask & (__GFP_THISNODE | __GFP_NOFAIL));
> +	bool can_direct_reclaim = !costly_noretry &&
> +		(gfp_mask & __GFP_DIRECT_RECLAIM);

IMO this is worse because now there is a disconnect between these
flags and the gfp mask again. This sets us up for subtle bugs.

I much preferred v4.

