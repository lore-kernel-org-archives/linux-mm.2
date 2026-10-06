Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E8CECA5FF0
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 08:11:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 065F36B0088; Tue,  6 Oct 2026 04:11:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 017786B008C; Tue,  6 Oct 2026 04:11:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E47E76B0092; Tue,  6 Oct 2026 04:11:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 75C6D6B0088
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 04:11:00 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 084FC1A05B1
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 08:11:00 +0000 (UTC)
X-FDA: 85291480680.04.F1FCB04
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf02.hostedemail.com (Postfix) with ESMTP id E131D8000A
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 08:10:57 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=SbP3u44I;
	spf=pass (imf02.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.221.50 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791274258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tVXYOf8mvidID9ngA6Wiy5Zd6aixe2bdtBClg3CvrsU=;
	b=l/dCzlxl/QaMPmk0JypL6k2Zoxn5m286nSv2kKvIRhWLmuhQV2tXhBdCUIWdTbkm+Jhw+w
	kWsgsJEd9x090Qpdp3/ScP4FQwxv+WH2HXLyNYkPloKz1+vGVNry/EX9n5L82PCEZRk0vu
	kU/Ypz5Qc1eMjO1hfL+jDMbY6BvWJBo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791274258;
	b=eRTA2wOaN8V+rcrF7nb+/W4zslV9QkKYQPbb6eKsTIK+KLiYCq8c8kHMA+UyyJ9KfslW5+
	A8pX1twljXD8FrhaCEILOODctc15zbJJhmLetXey6eKJ8KaHTd4jedFbTf469WrnLVXdON
	v1YX4rBPCVtnxfMPFGTM1r8AdErpG94=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=SbP3u44I;
	spf=pass (imf02.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.221.50 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-48b0946c2c2so223348f8f.3
        for <linux-mm@kvack.org>; Tue, 06 Oct 2026 01:10:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1791274256; x=1791879056; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=tVXYOf8mvidID9ngA6Wiy5Zd6aixe2bdtBClg3CvrsU=;
        b=SbP3u44IV85ysAj0b8EN6ki+c+UhG0mD63GujfXPjwkY4/dAkIzc5yH+ruYQDT7fWH
         GaGtbAW/hv6RjFDSAZwG5SXPjNC89CBX1HvajqOldI6Y/bRmVO/buQEP8SMvj7+qiQqO
         /xzFMlCdx4r71lPaNGY282oQcDtuvBHOyd8Fz2wCHZw6v2kek5KgFbcnohlmBqqS5pO7
         iZTiikB2XaObm3LglgrNBt+UOj+aRdyjBmT8pN/oAo4VNhMtN7Yz6uppwpt8Xe2iqwJs
         mWtl1lSHYeUWi5A+DRff689C0D3VoVeKBU50/vQ2bID5T9POg7Ro1+gF2yhIGaQZDkFE
         EjLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791274256; x=1791879056;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=tVXYOf8mvidID9ngA6Wiy5Zd6aixe2bdtBClg3CvrsU=;
        b=kIQvx72QIyRxZetlwXplfsn3caF2juLME/wdaHYKr+xYfi4+WFEz9vQvCbNLz3jgYo
         6LeKBRuNjFR74DF5QAL0hvd3YPY4Y4AE0eDmTN8e2tFO8DEAKJPaxjZGcnTuZ0X/gRR3
         gXNyQjnOhLNpxW+fiaSMlbNfGNKY3uPE00LyX8DtOAKXhMmPwh3d7HSVJOL5cXIDpFOF
         +F6n1miNm/unos5PjMgQx7lPelJtDtJ1aYZrMImxMjLuHxhoGiPc/0ZLfXnW6nKgLcHF
         JqID1n8VZa/UAJKRU5LQoGeCQ7bEnzXFIMIuWSGj4FKvYTJomaxos15DXd3DQNObBnZ6
         rlTw==
X-Forwarded-Encrypted: i=1; AKwUvBwhK9KS7HNgELKQScq9CEqoC6+ROOU8JfSkkaz7Cw13Q3JB4F4kmxK5cEl7/1EhdekrdPB5H9/iJA==@kvack.org
X-Gm-Message-State: AFq9FYJVuXvfWJLhaq1Oiy4iYI6eiOZ9PJ0k3NxxrVBV6JL89OkesmNO
	8VAwuvK6OclZfgAWqV+hGgBFSVHZOmpXIuGl+TQ1HBguJTM8yZvQ2NVIKQi+BdMw+bo=
X-Gm-Gg: AYBFou07N0KOQID1yhMxz+BaD73Wk5H1zYFwN05Pb1aIqJ16dV6BDnOQeZZaZDda0rP
	ASXO42BPfgD+tSEQy9wbnhg66y/OMozLLdxBTRUxHrkhEyUN9wMpa2ZxaptbIRn91gmQDaYZjUI
	cfloxrxCvBCUf/5RgLNUQPqr7mxRrc7niMYT4MjKWBh7OxBClEEYnwPrUnvpF7/i0zZeIevRQDq
	ZscQ//pgXmo4pG2e4VxPuOsqSIW5GZiCb43tX6eFS18npQZj5+q34Hev4TCtIaNGSaWyDntoFFZ
	3EPOZKH/iux7w0KweRCgK0ATw1ZvL7T0IoQf9GzO1e2N6l8cIOe7m8hW0g4MNaln2ABTc3jaUSO
	p7kIXnQdRpKGqBW9atqW6h1H8MWbcTeVylbcn1a8s/DLa30OPr4787DUvq1dgN31c5FWdI496Fp
	d21o8wb16iNtZKu3006S2TiXfTvFe0muB5sK48XuK/wVo+qWM8GEr83we9xGfiNjFPaB485CiLw
	Qui8ywDDKES
X-Received: by 2002:a05:6000:220f:b0:48b:60a:760c with SMTP id ffacd0b85a97d-48c6d18629cmr1226749f8f.31.1791274255753;
        Tue, 06 Oct 2026 01:10:55 -0700 (PDT)
Received: from localhost (90-182-211-1.rcp.o2.cz. [90.182.211.1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48c6308481dsm9975049f8f.3.2026.10.06.01.10.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 01:10:54 -0700 (PDT)
Date: Tue, 6 Oct 2026 10:10:50 +0200
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
Message-ID: <20261006081050.GA234057@cmpxchg.org>
References: <20260929174553.175333-1-kirill@shutemov.name>
 <arv8J7ysrdazJmfY@thinkstation>
 <ar0NRMxps8UErXaQ@thinkstation>
 <ar0Xbs9mEu-vUHvc@cmpxchg.org>
 <ar5rOHWwc_iPJF6C@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ar5rOHWwc_iPJF6C@thinkstation>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E131D8000A
X-Rspam-User: 
X-Stat-Signature: fhyasznx81sp1ago4d7k1d9m9sd6eiwj
X-HE-Tag: 1791274257-98470
X-HE-Meta: U2FsdGVkX1+vrLLtbi4vK6Id39OYRt4OnQtuBT0CTdbBjJEAxybqlxSd5NiHqMb7Vk+NwDaGMHtQx+V4JV3oLo/g073RGBLPUUIJZu/waxS7WPUZQy2ff/FBh0bNDOp8e5FjrCJ6Y+1QeE9bOJyr1WeUzpRWhb6hB0iXH7VDTJ6whAFvCM2j3IsjMcZbN77s+0N2SNM9BYXNDNmB3PaBHgzGBuUoUcE9J5T6cKez4UoGXF2lq9qudvn8nKWZEwmQEqS/1clO28mxRjTxAHLDGjST8Ju/c+EeCf5EiHqHuoNxvXcWuzDwiwGY/BLvtrB9kMukrZogB2xp/aZH98YLHhdoxNDb3GOj183FQW8e1d285QvZ6Xh3Gv/ORdzWCL5ZfwV8UF6bxQ73/mkh6v9u4hAgz6Set9VKwp+qj2Wna4YAcb3BHP8lmS03ldH2nwixLsE2g/o+TkM7tVQaQIUxD1WaeXKQ9+KgPUTxs6CZEPEhbBAziC2RJOvtp9qlRDIi69Vb9NaggKH6CLFZa9vBcF9WBHP0FUoCtccPYox380vEr0jo2IMsM0DFqisThmIByyEw2/76T7L34M4+W60vjGH0y9zIVi/bydhG53XOJJV7IQE8lKgNr9VcRTWoS5li73BxUMJijh4GKZy9ZPQ8CZO6rX8/x4M9nc8IeHKUMC9+Li4r9aI8F9k7Bw5q8nsd25n8H2H1/bNn1nSm7C0fwIcY4nar3rRd9XaiAmXyRZCXZHX+aWJQCFWfQAh9BImsZaRDjp+wcLKoDm3OaeBuKGgRgTJV8jAIORe+QtfkO0iu5ttT3oplGkKLkGrGHhkd4JXbc8aNRFLtmPRUZm5WU/7aWX/xq8q5KHBbakjs6i+jG4TsQgE79/VqVTJuHbayVh1ancjS+qujVgWuT/ZL9cQ/YF1WLwp6xSPIpfydA74fcA90sEDlk2t5EVMoRWM35/PuDOD1he6Qy4bKCX8
 8LIOZOI3
 HVDko7tLJG0LOlxB0WoPe3ixKq/SFq0Yp8NiFBqem3igiHcVP/hOM09ylYWlo4AIB8t/s0KrjVU8W3OcpzdGC5vt1W+elHLVf/EXqjn97aw7o1zQUj9nlMzOcFwSmPqVgPVzHOE6eiGflq9W32F1Vdhqq5vAPQW5+/Pf4zYdw+jmWNNZZmwvGOQlSAB8WEIjWzFpSLy0o4TPOGSWDNx18FwpA+UdtgdBZLaaRfOPmyI2+eR+AteJJyK60F3yp95LJvu1c3mTAYm0sQPwdwxoFIWsK/LZxAZhCEKxsq+ruyfl5stb6fWHJdGMzNASNkjcDjKZBXbMl8Jmr82fGRP4Ueik8bhA6YJnHfe0lnfTsRKUv3ZHEcw1lXrQnObr/eqPi0KRGidnzf81sdlbhdwoZ/w73L3YsLqXbx0mKdRLM6KUEptxl5+u79k0s0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 02, 2026 at 10:59:32AM +0100, Kiryl Shutsemau wrote:
> On Wed, Sep 30, 2026 at 10:06:38AM -0400, Johannes Weiner wrote:
> > > > > @@ -4127,6 +4127,31 @@ __alloc_pages_may_oom(gfp_t gfp_mask, unsigned int order,
> > > > >  	return page;
> > > > >  }
> > > > >  
> > > > > +/*
> > > > > + * If fallbacks are not permitted (defrag_mode), we either need to
> > > > > + * reclaim space in a block of matching type, or clear out an entire
> > > > > + * block to allow __rmqueue_claim() to convert.
> > > > > + *
> > > > > + * Reclaim by itself is primarily freeing space in movable blocks,
> > > > > + * since that's where the LRU pages live. So this works for movable
> > > > > + * requests, but not for others.
> > > > > + *
> > > > > + * For those, promote the order of reclaim and compaction to help make
> > > > > + * blocks, instead of spinning in reclaim alone unproductively. Retry
> > > > > + * decisions based on the outcome of that work - reclaim progress and
> > > > > + * compaction results - must account for the promotion as well, see
> > > > > + * should_reclaim_retry() and should_compact_retry().
> > > > > + */
> > > > > +static inline unsigned int nofrag_promote_order(unsigned int order,
> > > > > +						unsigned int alloc_flags,
> > > > > +						const struct alloc_context *ac)
> > > > > +{
> > > > > +	if ((alloc_flags & ALLOC_NOFRAGMENT) && ac->migratetype != MIGRATE_MOVABLE)
> > > > > +		return max(order, pageblock_order);
> > > > > +
> > > > > +	return order;
> > > > > +}
> > > > 
> > > > I think we should start distinguishing order and compact/reclaim_order
> > > > in __alloc_pages_slowpath(). Silently overriding it makes it harder to
> > > > follow and easy to make a mistake.
> > > 
> > > Agreed, four callers recomputing the same thing is asking for a
> > > mismatch.
> > > 
> > > I would rather not grow this patch, it has to go to stable.
> > > 
> > > I will look into a cleanup on top: __alloc_pages_slowpath() computes the
> > > promoted order once per iteration and passes it to direct
> > > reclaim/compaction and the two retry helpers next to the request order,
> > > so the helpers stop knowing about defrag_mode.
> > 
> > +1
> > 
> > All they really need to know is the split into requested order vs
> > production order (reclaim_order, compaction_order).
> 
> Will fold it into the fix itself. The cleanup changes the same places as
> the fix. It makes zero sense to keep it separate.
> 
> > > > > @@ -4299,7 +4316,7 @@ should_compact_retry(gfp_t gfp_mask, struct alloc_context *ac, int order,
> > > > >  	/*
> > > > >  	 * Compaction failed. Retry with increasing priority.
> > > > >  	 */
> > > > > -	min_priority = (order > PAGE_ALLOC_COSTLY_ORDER) ?
> > > > > +	min_priority = (compact_order > PAGE_ALLOC_COSTLY_ORDER) ?
> > > > >  			MIN_COMPACT_COSTLY_PRIORITY : MIN_COMPACT_PRIORITY;
> > > > 
> > > > This would change how hard we try to compact with defrag_mode in direct
> > > > compaction as it won't try compaction with MIN_COMPACT_PRIORITY anymore.
> > > > 
> > > > It doesn't make much sense to change that as part of this fix?
> > > 
> > > It is a choice between compacting harder and falling back, which
> > > fragments a block.
> > > 
> > > It is a judgement call on what defrag_mode means.
> > > 
> > > It would also mean that order-0 allocation request promoted to pageblock
> > > can trigger SYNC_FULL compaction. I cannot say I understand the
> > > implications. Will give it a try with the reproducer.
> > > 
> > > Johannes, Vlastimil, any comments here?
> > 
> > I would leave this one with requested order unless the reproducer
> > disagrees.
> 
> I built a reproducer around what we saw in production, which was oomd
> killing the workload on sustained PSI, so PSI and the number of times
> ALLOC_NOFRAGMENT gets dropped are the headline numbers. 32G VM, 8 CPUs:
> 
>  - fill memory with 4K anon pages in a cgroup, memory.low = fill + 1G,
>    so page cache beyond that stays reclaimable;
> 
>  - pin one page in every pageblock with io_uring registered buffers[1],
>    except one block in 50 (2%), so whole blocks can be made but only
>    from a few places. Without the pins rc5 does not storm in 180s:
>    compaction makes 130-210 blocks per run and every retry loop ends in
>    one. The storm needs blocks to be hard to produce, and the pin
>    fraction is the knob for that;
> 
>  - free one page in eight so ~4G sit scattered in movable blocks;
> 
>  - turn on defrag_mode and run 8 build-like workers on btrfs for 180s:
>    write 1-64K files, read earlier ones back, unlink 20%, fdatasync
>    every 50 creates.
> 
> Kernels: v7.3-rc5; the fix as posted; the fix with the priority floor
> and the COMPACT_SUCCESS retry limit on the requested order. Three runs
> each, mean ± stddev, 2% producible:
> 
>                             rc5            posted        requested
>     ops/s                   4751 ± 684     5181 ± 18     5206 ± 84
>     PSI some, mean %        28.7 ± 11.5    22.0 ± 0      22.0 ± 0
>     PSI some, peak avg10    42.8 ± 30.7    24.9 ± 0.3    25.0 ± 0.8
>     s with some avg10 > 50  3.3 ± 5.8      0             0
>     give-ups (NOFRAG off)   0              222 ± 58      277 ± 199
>     movable blocks lost     641 ± 13       654 ± 10      652 ± 14
>     whole blocks claimed    90 ± 8         81 ± 10       76 ± 8
> 
> rc5 stormed in one of its three runs: 3.85M order-9 reclaim runs in
> 180s, PSI at 42% with ten seconds above 50, workers that would not die
> on SIGKILL. The other two were quiet, which matches a workload that
> OOMs regularly rather than always. The fixed kernels never stormed.

Ack. Nice. Thanks for testing it out.

> Between the two floors there is no difference I can measure here: same
> PSI, same throughput, same give-ups, same movable blocks lost, same
> whole blocks produced.
> 
> The promoted path is a small part of what the allocator does in this
> workload, 16-22k order-9 reclaim runs against a million order-0 ones for
> page cache, and a few hundred give-ups in 180s.
> 
> > There is a risk of defrag_mode self defeating over time by raising the
> > bar for fallbacks but not high enough. Every fallback we let through
> > will make it harder down the line to compact towards that higher bar.
> 
> Same movable blocks lost and same whole blocks produced in all three
> kernels, so in this workload the extra SYNC_FULL passes neither produce
> blocks nor save any.

Ok that's good to know.

Without counter indication, I would prefer to keep the tighter
guarantees. ISTR this mattered on some of my ext4 tests in the past
with the buffer locking.

> > There is also a non-zero risk of connecting order-0 request contexts
> > to SYNC compaction which they haven't done before 7e8756d7ad22. But
> > you traced the problem to retrying, not sync compaction itself.
> 
> That shows up only when I take the I/O out: tmpfs, every block pinned,
> 1M empty files. Then every exhausted order-0 refill does a whole-zone
> SYNC_FULL pass before it falls back, PSI some runs at 39% against 20%,
> and the churn takes 1.3-2.8x as long, five runs each.

That seems acceptable for the no-hope worst-case behavior.

> What do you prefer here? I don't have strong preference either way.
> 
> [1] One thing the pins made me notice. A FOLL_LONGTERM pin migrates
>     the page first only for ZONE_MOVABLE, CMA and isolated blocks, see
>     folio_is_longterm_pinnable(); a page in a MIGRATE_MOVABLE block in
>     ZONE_NORMAL is pinned where it sits, and the block can never be
>     made whole for as long as the pin lives. The migration target in
>     gup already uses GFP_USER without __GFP_MOVABLE, so a moved page
>     lands in a non-movable block.

+1

>     Should defrag_mode treat MIGRATE_MOVABLE like ZONE_MOVABLE there and
>     move the page out at pin time? Ideally we might want to move it back
>     on unpin, but it can be done by compaction too.

Should it even be specific to defrag_mode? I suppose without it, the
poisoning from fallbacks would dominate by a landslide under
pressure. But these pins can mess with compactability long before
becoming capacity-bound.

