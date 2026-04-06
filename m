Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16278F46C4E
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 15:24:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 080C36B0108; Mon,  6 Apr 2026 11:24:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 030E96B0109; Mon,  6 Apr 2026 11:24:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E636E6B010A; Mon,  6 Apr 2026 11:24:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D53296B0108
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 11:24:29 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 82A881604BD
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 15:24:29 +0000 (UTC)
X-FDA: 84628502658.02.74EA178
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3B9A42000A
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 15:24:27 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=YUC7wStN;
	spf=pass (imf03.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.171 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775489067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OIJnS2b1tpGZI/Kl+62AYmPsLlQgPfQ3Zwauap2V61E=;
	b=MifWZGZKwF+JhsAFPvszMUHITzlX0mawL2fZ8419sbImxQEBf5Pq+97H6Uete9Nbr2Vi/5
	cLjCLlBSgyeF8eGNRDAILBIzzI8HLFw2tsOErXeI01j0Bp3uF3MfcQVEy168kznAhEvVNR
	P+UVtugDcPUvz8e3rC3tJAmXOfwPlQc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775489067; a=rsa-sha256;
	cv=none;
	b=ZAIkwTYPUov93N2GJa9Zm2L8h4Xene3cdszPmcdoCbMMunCmhvG+6shO1u9IGYKKkepn5B
	qCcyj1dgK7PtrNVQlFxHIZoNpX6LJ8cV0lCect8AD70ufU21zvbt7wCcme25cu8X41kFZ1
	F8X52mkVUKAUZbIz6KGlBSPTC4N1LpU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=YUC7wStN;
	spf=pass (imf03.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.171 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-8d67a483d3eso178855085a.1
        for <linux-mm@kvack.org>; Mon, 06 Apr 2026 08:24:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1775489066; x=1776093866; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OIJnS2b1tpGZI/Kl+62AYmPsLlQgPfQ3Zwauap2V61E=;
        b=YUC7wStNy82VDQEGVKkkTrzIKnIKSfglfaUN2vkgzEkhvym/fynOHA/165S7hOtanQ
         0/o/ZEju5UKmywwD1gzXER1YUR3VujPHOd9/TqJCl3BJkkJ4d6xdGcNS7K1H7B869FuE
         WeFVeNTh0lI2Kbbdgq9SdlJT//8zypCPvicEfWvVtxQzUOw6LRYpZdbTbajUzxE3NBzV
         U9qCh9WvuwF1Pk8DSg8rD4R+BCt1/lAL7w/GT9gcVR3+wlCG7LqbqbRd8oxhHimCjU++
         DXgIg/zG6SNBwbNolJ6wL5C7TbggnQmbUJ6vGy8zbgpLWFyCDKpcYAACS8/vCozz42d2
         e4zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775489066; x=1776093866;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OIJnS2b1tpGZI/Kl+62AYmPsLlQgPfQ3Zwauap2V61E=;
        b=R29xoAztzzbcSjM0C1v3dHSnH8vQAtQcdX2m8z/4fLPTrFkweJx5GN/yLVc5+8aTqw
         D5nvn3ZGcBe1lfcEuPPQga9PI94K1yh7DfA+zdsJaFW0aV7nam1VvbXERfHC3l4qTHQ2
         R1MbIgISj9/RqF1K1ugH+vLWXCsyoRAUfjrfiHTBCfKCJ92mFROfEX6Sd+kpCuA2FRjV
         +UaXSq5gzixv+vNTHDpI7w1UEUzvWGH3H+THJfw23ZVOe6xlJZN9T2VVY147m8/qzigd
         TPppKfzDIj70mXGRhI5A1Prw5ZFn42MZenfRB5Q710ueEdD/2RUAWRHffc0Fv38dpbKX
         6tRw==
X-Gm-Message-State: AOJu0YyNEZNuU+7ZZ8fjfKSXT3TzUWj/dPSa6n5CvFVW7ueM05gtkBWv
	Pn/BLSszopCXJGxE74wPQ1ZhfcfaRdot3VOn1NUh/T75wszymJKGLodzXhYa3RtQu34=
X-Gm-Gg: AeBDiesRK2iFHODWPysAbJjrlYvq3AaD/aU3bFCw1CNbkCytJju0FV+ymuevQgupEpY
	0dO4M4ah6vJ1xceRCu9FLZusMVK9l1TMFIY2p+dE5O0XuVQGnPxgmzzbFg6KS+EFlpp9JQGvitU
	qe6SqGqmL3/rvIE2MPW1eyyJlYUVEkg5kqYcah9l2MTIvmSGFBmwLNSWWPDJLccK1lJr3En/4kJ
	1J/MmqolrPtr3VkCw9p5NVANvOQvLZS0Zd6s+kKMPXlMlES3mAZT7DiFlWXkoVABDgI8gR1BmiT
	gFlkWSm8wyJkKmoSbW10AAE3ptuxzUZMGl+rBA6rGjAGUaB7BqupdzuEgRahOSvqF724FQdfyCa
	pCQIThfdw0IwJrxtzLGHWHLntzHIsxg4ZcU0TLGzdGfWyUGOPQcCxWLP1wVapIp+Gbs9qbbZ+L3
	W37nvKNysq0WvMyV2PchwkoA==
X-Received: by 2002:a05:622a:aa4e:10b0:50d:5f54:6a29 with SMTP id d75a77b69052e-50d6260b300mr152549551cf.11.1775489065919;
        Mon, 06 Apr 2026 08:24:25 -0700 (PDT)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50d4d9ad4b6sm106657441cf.15.2026.04.06.08.24.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2026 08:24:24 -0700 (PDT)
Date: Mon, 6 Apr 2026 11:24:21 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Rik van Riel <riel@surriel.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/2] mm: page_alloc: pcp buddy allocator
Message-ID: <adPQJfmbpYr3-uzX@cmpxchg.org>
References: <20260403194526.477775-1-hannes@cmpxchg.org>
 <1C961B84-522F-43AB-ADCB-014B3A4ACD21@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1C961B84-522F-43AB-ADCB-014B3A4ACD21@nvidia.com>
X-Rspamd-Server: rspam12
X-Stat-Signature: ghfmn6iuxhggdsqpf7rwmky19p7icsd6
X-Rspamd-Queue-Id: 3B9A42000A
X-Rspam-User: 
X-HE-Tag: 1775489067-476505
X-HE-Meta: U2FsdGVkX19v9ApAOUfGfgcpyyI92QLsD0gv0WLItR4acUkDYet+sDTl4YzLoYgFO8IJgR2Mf+xmW0KRtDSSDvgRa/exYC9ALt8FPwlKNIS33+uclB4jFQJ6EwXNqu4x5VFEXidTTQHjPzL3MN7jnKBcpdnew+3ZCoYZH+SqGV0Q+Jr4MXwihA/QHvpI+YF2ZNXYkI42fkvL3dg4UB0aNJ5ND+FkIkChUxBYa8I0kdkyYadTjeJqU3UGiClr5ShKnacPH+BKZtllo+M8gHvPgHfO7lwhx3g1KfziyXeZs+FPg/ZgDhBcQ00NYcqY3S3wtlqre90Xge89CX5FMmMhiKgnurjqbhMdtGxw95BHbURE+ctGUnkF45uABuI1cJTShmIyxBKYDS7+IDkDcfn/ESBin38eVziX80gSIgPkH0/y8OsceHN9cAGO4YtB3nazH/BUIU3GTckJTmWooWyOVPMcrP+PV8qyK+DdPxVLm6YWtebHlcOaaJzrGGA0s1rEOLOtzb/2cloTzhsxV58nA89AD8c+qI74L3xQbk3WvT0Hl7a5E8K7+sgPP0bxv4jkQz9fdOaaExdl0tS8K45GqzvDPK++VKo2qAiOHpvdSQFjHL42tqR+o3z632E0aI8A96ILAykg03u/w6M36ElSvIl3+FqGcBWNOeT/aot6aR6k4U1SmsaN8Tti0/LiLC9y7qbe3w185hulUCjCr1paXtMrMr6/8MaXgRLJ6rf6qNmPY8Mfy8mR+dJQFyTXw88teMc3oimfuwP7MLPXocZtk09LCU2vioKJAFL2ujaKDO6YM6PsZGDrgIZIPxr+8JQ7wgIZa6JDSxP28rMeiF4tay3Xn7CtmPAkXr9hRPlNZRzjxwriKEou+9H/6UPd4kHdTaJxKT76QeFpr98aXavyp94iJ63pQ+5qOH6iALBV3dOBUylQHFTzQ4EyPZRGXfRiN3kJ5z/JX/jMLzCyGQ9
 M+8lFnSg
 jtjxVLo9gSfHSYR+5NyunN1uWRyhvUvYkwTnkOTi57atB1jloSsJ8fCwu17uveLlvGzCuZHHzYxnlEVI21DjuwpQpHrin2OeUWn73Wqh05Nysf34X8REMKiAoQUb6szRsKdRt+mVyH1yHs8o/VMRyimBl4hdSDPpvV0vBKC0dB1uxCt/64ULLHvzCmgJp0yNtMbcIR6Pv47hzFchGJSGKeFAeRnId6uoUAvMLAU1rYdIsyU+Gl8LoGp06TGhNqdB2iIZxZwP6Sdg8hlXi4iCUDXv2ez6zyFSvoSmUzL7uGnI8YuX36TpHWoO2K0D9Ze1+NJvK9P0ExP32qUSIdnEtc56DsqhG4rNjdj72GoJkPUbOpYTP2HZjlc4sJf+i9/teG9AmiBbIgkW1fM2kVVpBrTaymUfdX1rIlvfXlOsglXSsVMt78Vux2fRE8ceWWVcOUghCxXrRQ55SVKseaU3oVY3tggkcAth2xixL7yJjt0F93vecuZNLX+yE7eE4e0fikJP7AcR/7eBWDFASyQhWEn717t2WBWBf20WD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 03, 2026 at 10:27:36PM -0400, Zi Yan wrote:
> On 3 Apr 2026, at 15:40, Johannes Weiner wrote:
> > this is an RFC for making the page allocator scale better with higher
> > thread counts and larger memory quantities.
> >
> > In Meta production, we're seeing increasing zone->lock contention that
> > was traced back to a few different paths. A prominent one is the
> > userspace allocator, jemalloc. Allocations happen from page faults on
> > all CPUs running the workload. Frees are cached for reuse, but the
> > caches are periodically purged back to the kernel from a handful of
> > purger threads. This breaks affinity between allocations and frees:
> > Both sides use their own PCPs - one side depletes them, the other one
> > overfills them. Both sides routinely hit the zone->locked slowpath.
> >
> > My understanding is that tcmalloc has a similar architecture.
> >
> > Another contributor to contention is process exits, where large
> > numbers of pages are freed at once. The current PCP can only reduce
> > lock time when pages are reused. Reuse is unlikely because it's an
> > avalanche of free pages on a CPU busy walking page tables. Every time
> > the PCP overflows, the drain acquires the zone->lock and frees pages
> > one by one, trying to merge buddies together.
> 
> IIUC, zone->lock held time is mostly spent on free page merging.
> Have you tried to let PCP do the free page merging before holding
> zone->lock and returning free pages to buddy? That is a much smaller
> change than what you proposed. This method might not work if
> physically contiguous free pages are allocated by separate CPUs,
> so that PCP merging cannot be done. But this might be rare?

On my 32G system, pcp->high_min for zone Normal is 988. That's one
block and a half. The rmqueue_smallest policy means the next CPU will
prefer the remainder of that partial block. So if there is
concurrency, every other block is shared. Not exactly uncommon. The
effect lessens the larger the machine is, of course.

But let's assume it's not an issue. How do you know you can safely
merge with a buddy pfn? You need to establish that it's on that same
PCP's list. Short of *scanning* the list, it seems something like
PagePCPBuddy() and page->pcp_cpu is inevitably needed. But of course a
per-page cpu field is tough to come by.

So the block ownership is more natural, and then you might as well use
that for affinity routing to increase the odds of merges.

IOW, I'm having a hard time seeing what could be taken away and still
have it work.

> > The idea proposed here is this: instead of single pages, make the PCP
> > grab entire pageblocks, split them outside the zone->lock. That CPU
> > then takes ownership of the block, and all frees route back to that
> > PCP instead of the freeing CPU's local one.
> 
> This is basically distributed buddy allocators, right? Instead of
> relying on a single zone->lock, PCP locks are used. The worst case
> it can face is that physically contiguous free pages are allocated
> across all CPUs, so that all CPUs are competing a single PCP lock.

The worst case is one CPU allocating for everybody else in the system,
so that all freers route to that PCP.

I've played with microbenchmarks to provoke this, but it looks mostly
neutral over baseline, at least at the scale of this machine.

In this scenario, baseline will have the affinity mismatch problem:
the allocating CPU routinely hits zone->lock to refill, and the
freeing CPUs routinely hit zone->lock to drain and merge.

In the new scheme, they would hit the pcp->lock instead of the
zone->lock. So not necessarily an improvement in lock breaking. BUT
because freers refill the allocator's cache, merging is deferred;
that's a net reduction of work performed under the contended lock.

> It seems that you have not hit this. So I wonder if what I proposed
> above might work as a simpler approach. Let me know if I miss anything.
> 
> I wonder how this distributed buddy allocators would work if anyone
> wants to allocate >pageblock free pages, like alloc_contig_range().
> Multiple PCP locks need to be taken one by one. Maybe it is better
> than taking and dropping zone->lock repeatedly. Have you benchmarked
> alloc_contig_range(), like hugetlb allocation?

I didn't change that aspect.

The PCPs are still the same size, and PCP pages are still skipped by
the isolation code.

IOW it's not a purely distributed buddy allocator. It's still just a
per-cpu cache of limited size. The only thing I'm doing is provide a
mechanism for splitting and pre-merging at the cache level, and
setting up affinity/routing rules to increase the chances of
success. But the impact on alloc_contig should be the same.

> > This has several benefits:
> >
> > 1. It's right away coarser/fewer allocations transactions under the
> >    zone->lock.
> >
> > 1a. Even if no full free blocks are available (memory pressure or
> >     small zone), with splitting available at the PCP level means the
> >     PCP can still grab chunks larger than the requested order from the
> >     zone->lock freelists, and dole them out on its own time.
> >
> > 2. The pages free back to where the allocations happen, increasing the
> >    odds of reuse and reducing the chances of zone->lock slowpaths.
> >
> > 3. The page buddies come back into one place, allowing upfront merging
> >    under the local pcp->lock. This makes coarser/fewer freeing
> >    transactions under the zone->lock.
> 
> I wonder if we could go more radical by moving buddy allocator out of
> zone->lock completely to PCP lock. If one PCP runs out of free pages,
> it can steal another PCP's whole pageblock. I probably should do some
> literature investigation on this. Some research must have been done
> on this.

This is an interesting idea. Make the zone buddy a pure block economy
and remove all buddy code from it. Slowpath allocs and frees would
always be in whole blocks.

You'd have to come up with a natural stealing order. If one CPU needs
something it doesn't have, which CPUs, and which order, do you look at
for stealing.

I think you'd still have to route back frees to the nominal owner of
the block, or stealing could scatter pages all over the place and we'd
never be able to merge them back up.

I think you'd also need to pull accounting (NR_FREE_PAGES) to the
per-cpu level, and inform compaction/isolation to deal with these
pages, since the majority default is now distributed.

But the scenario where one CPU needs what another one has is an
interesting one. I didn't invent anything new for this for now, but
rather rely on how we have been handling this through the zone
freelists. But I do think it's a little silly: right now, if a CPU
needs something another CPU might have, we ask EVERY CPU in the system
to drain their cache into the shared pool - simultaneously - running
the full buddy merge algorithm on everything that comes in. The CPU
grabs a small handful of these pages, most likely having to split
again. All other CPUs are now cache cold on the next request.

