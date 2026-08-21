Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD02BC5DF87
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 03:30:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC5B46B009D; Thu, 20 Aug 2026 23:30:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9D006B009F; Thu, 20 Aug 2026 23:30:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B39E6B00A0; Thu, 20 Aug 2026 23:30:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 72A8D6B009D
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 23:30:39 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E31AC8019D
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 03:30:38 +0000 (UTC)
X-FDA: 85123849356.01.CAFD047
Received: from mta1.migadu.com (out-126.mta1.migadu.com [95.215.58.126])
	by imf17.hostedemail.com (Postfix) with ESMTP id C57A240007
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 03:30:36 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CD8j1c4H;
	spf=pass (imf17.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.126 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787283037;
	b=pV/9r5AnWpuIOd4ErFm3IVLchnRKrXDIIW6yvqwtor5uYEx3oe+gXECO7RcXE2fkQDT1p7
	hZUR+Qb0Pia31WoB2BfjqIv1YXrFr9+PpnA+ms4hrJn80uiBpGGQEKp8kR2q4IOfRNldeQ
	LD57XuXbsWg3v2+6+0AZQOE4qHzGVps=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CD8j1c4H;
	spf=pass (imf17.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.126 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787283037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1tdY9ODRf+bLpSdQyXA5Del0LMztBAq+yrYTqzgoukU=;
	b=NNIUMFDEKiPPqGkrqv3kHhhfnp0Pe1QCjBPFp0J+l0llN3O9zqMNDXG2c2sMQyiy91q4/j
	4sYt9TqbCNXPsf0IbZx17xi0SvDYAjZQ21jIPzWv31SNKN/mXdjxFTUrQLTQ0UFxOQ4h5M
	rnsAA9ouVDO5fPm07OeBnveg0UC/eGs=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=8Rol1VQ2uWB+1YlygJuGTeySnySTZ0MsTfHdn9dxHxQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787283035; v=1; x=1787887835;
 b=CD8j1c4HLyZ/32ulPwHbYs83YBahR4bTU6Ah9rxWHxSy1P/DWQyJpWeB23IZuAXu1oFxALPW
 W60bcCOZWDz4RyaD1CiuG8t7ZGoN/BxE5qohB9V1GwOtnyGFZiiZODGlH4V7n3X+liAueATkhzY
 bkxSUAnJUDwbs5MjWdbNWKyc=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (223.70.160.239)
	by mta11.migadu.com with ESMTPS id 098c33cb966c1553;
	Fri, 21 Aug 2026 03:30:25 +0000
X-Mizu-Trace-ID: 098c33cb966c1553
X-Migadu-Flow: FLOW_OUT
Date: Fri, 21 Aug 2026 11:30:18 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Barry Song <baohua@kernel.org>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, kasong@tencent.com,
	qi.zheng@linux.dev, shakeel.butt@linux.dev,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com
Subject: Re: [RFC PATCH 3/6] mm/mglru: skip empty PUD subtrees during aging
Message-ID: <aofGSm9PoZtpkDWO@fedora>
References: <20260806103003.3924438-1-baoquan.he@linux.dev>
 <20260806103003.3924438-4-baoquan.he@linux.dev>
 <CAGsJ_4yF=NN896RqhGWGtkhQPFr2ZSsFC2izhA456J_fnRv78A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4yF=NN896RqhGWGtkhQPFr2ZSsFC2izhA456J_fnRv78A@mail.gmail.com>
X-Rspamd-Queue-Id: C57A240007
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: dko1153zx7ekj1k7n7phfi9z9tu3616u
X-HE-Tag: 1787283036-688836
X-HE-Meta: U2FsdGVkX1+RzTPg3wlAb3Lwc1SnJMiXh441NF6+tkgzvLk4Pyrw2XM0gN8UwLx/AgLFrjllDRyvcsgNHYWz++01AGZR0Gj+ldivEiQNOSL8qq7Io6kjrLczPJfJL1vzH4YD/9OWOgFQ2cb09l8H8zfSYhVnJ3NyOotvU7iZ9YTnx3gX3tusve22gcPae8FR8P/FyWGEtxOyuE99z3oiSCUHB7GWBh7R/DpIvYJeiSORAaMr8eKZSNjlfzQMM+Xfl8VmdYLfMgMXNNS718twDUi+QPSar+1NbxmydOx6LVedmYioOEiHEtLhLXROZFWUKQQ7irhgCJ2pXm+0aBNSeKQJLl/jOcoGruiaBq7a09fSsmvVEd6/tshx7x85AhQiezB5T+nuuIqhbNe/OMCxULIjsRPxjeY2RJX/G1netNTthOi2ir9gNGcNB/hAlaULDKolOcvNqxf0M7wgc2cggon+7hu0PjBnaclpdX0DGKQoJcVND4r2btkYCgDjh4PvjBoiOQaIPZn3G+xFKKVn8P1K7wuA0lux0KsyaokDRN5Q37dE9cpetkDoUrq95CmffJyrtDxLHDUuGBkg/gPcZ/lX5HZxiLfY9iX9gXaNK9Fw7xnF0KrzPkujSi9EY8wDrqzNLdUNcx1MAbsvyK4RwMRe+9v7iBI7pexKvf7OLBupD/7HYYoRRlN5NeVtyz2Ml99Zp80w7QMYPl7Xv3uBnI1f6aqe/iLYH2PqnwZouH5Rz+HlLaBpYmrEdgkt0YlGmzLxvA1zg6e03HmECcjNLyzNI0UwMjiFUIHDjBN5hJ14PvTV9d2klkzEozsSqw9q7dz7zfcgR2w0x3fqGRrr1z6GMvfxB2PwQQRiPZizVFJnV1MsA9oU82AmWd8eLRcdgxASpgGJtUSqir7rK4y2aC4oFoNTOHTHbNnUp7vYaKKT84mwiSM1CaaAs268qAw7lrTJoZvgruzuBofXjWK
 T4G2t0XE
 xVHJLu6TofN4JgR62LYxTSgSN31tkkGaYP5hVPM4Lde4+J/fRE6wAkFXOIyMJeM30HPH9izaQ2VIHZ2FSfjr1TrXYNiATjQ0uR2p2IbI8EllGhPxpmtnHeGWZYbDbcLwfmOFtIJ9IJ0KrFWyAkqRGqa0WquR6s6h+CKF0PEME67uWYoZK8pLzqpWmyABX/2MrHsuSjmFHZMY+TAFNmtqRvtypsqi1Mfla+pd1rL9V14iZAu7J6um5RyXj9gXBqrBPKwtBQOEaaqGewwoNuIQYstMtRJcF3Qk4h0PtKouQfuVVJKSwn3mXDFmRCmN28Zp9nl3I0xt3tNNixUN0wGuVu7Ju9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/15/26 at 07:28am, Barry Song wrote:
> On Thu, Aug 6, 2026 at 6:30 PM Baoquan He <baoquan.he@linux.dev> wrote:
> >
> > The aging walk descends every present PUD and iterates all 512 of its
> > PMDs, testing the PMD-level Bloom filter on each. For a process whose
> > memory lives only on other NUMA nodes, every PUD of this lruvec fails
> > the PMD test, so the whole PMD iteration is pure waste - and on
> > multi-socket systems these cross-node walks are common because
> > lru_gen_use_mm() marks an mm for all nodes at every context switch.
> >
> > Add a PUD-level Bloom filter (pud_filters) one level up. walk_pmd_range()
> > now reports whether it found any young leaf entries; walk_pud_range()
> > records that in the PUD filter and, on subsequent generations, skips the
> > whole 1GB subtree when the filter says it had none last generation.
> > The double-buffered filter flips with each new iteration, and the
> > existing eviction feedback (lru_gen_look_around()) keeps hot regions
> > marked, so newly hot or migrated-in pages are re-examined promptly
> > rather than suppressed indefinitely.
> >
> > force_scan walks bypass the PUD test, so manual aging and newly added
> > mm's always rescan and re-populate the filter.
> >
> > Signed-off-by: Baoquan He <baoquan.he@linux.dev>
> > ---
> >  mm/vmscan.c | 50 +++++++++++++++++++++++++++++++++++++++++++++++---
> >  1 file changed, 47 insertions(+), 3 deletions(-)
> >
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index a397c62b2e5d..74edfe2a747d 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -2816,6 +2816,13 @@ static bool __maybe_unused seq_is_valid(struct lruvec *lruvec)
> >   * walk_pmd_range(); the eviction also report them when walking the rmap
> >   * in lru_gen_look_around().
> >   *
> > + * A second, coarser pair of filters (pud_filters) sits one level up. It
> > + * remembers which 1GB PUD subtrees had young leaf entries, so walk_pud_range()
> > + * can skip whole subtrees whose 512 PMDs would all fail the PMD-level test —
> > + * e.g. the page tables of a process whose memory lives only on other NUMA
> > + * nodes (cross-node empty walks). It mirrors the PMD-level filters: populated
> > + * by walk_pmd_range()/lru_gen_look_around(), flipped by reset_pud_bloom_filter().
> > + *
> >   * For future optimizations:
> >   * 1. It's not necessary to keep both filters all the time. The spare one can be
> >   *    freed after the RCU grace period and reallocated if needed again.
> > @@ -2907,6 +2914,23 @@ static void reset_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long
> >         __reset_bloom_filter(mm_state->filters, seq);
> >  }
> >
> > +static bool test_pud_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long seq,
> > +                                 void *item)
> > +{
> > +       return __test_bloom_filter(mm_state->pud_filters, seq, item);
> > +}
> > +
> > +static void update_pud_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long seq,
> > +                                   void *item)
> > +{
> > +       __update_bloom_filter(mm_state->pud_filters, seq, item);
> > +}
> > +
> > +static void reset_pud_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long seq)
> > +{
> > +       __reset_bloom_filter(mm_state->pud_filters, seq);
> > +}
> 
> I'd rather have symmetric names such as update_pmd_bloom_filter()
> and update_pud_bloom_filter(), rather than
> update_bloom_filter() and update_pud_bloom_filter().
> it could also be:
> 
> update_bloom_filter(mm_state, seq, pmd + i, PMD);
> update_bloom_filter(mm_state, seq, pud + i, PUD);
> 
> I think either approach would make the intent clearer than the current
> naming.

Agree, I would like to choose the 1st one, will change as suggested.

> 
> 
> > +
> >  /******************************************************************************
> >   *                          mm_struct list
> >   ******************************************************************************/
> > @@ -3146,8 +3170,10 @@ static bool iterate_mm_list(struct lru_gen_mm_walk *walk, struct mm_struct **ite
> >
> >         spin_unlock(&mm_list->lock);
> >
> > -       if (mm && first)
> > +       if (mm && first) {
> >                 reset_bloom_filter(mm_state, walk->seq + 1);
> > +               reset_pud_bloom_filter(mm_state, walk->seq + 1);
> > +       }
> >
> >         if (*iter)
> >                 mmdrop(*iter);
> > @@ -3728,10 +3754,11 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
> >         *first = -1;
> >  }
> >
> > -static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
> > +static bool walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
> >                            struct mm_walk *args)
> >  {
> >         int i;
> > +       bool young = false;
> >         pmd_t *pmd;
> >         unsigned long next;
> >         unsigned long addr;
> > @@ -3790,6 +3817,7 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
> >                         continue;
> >
> >                 walk->mm_stats[MM_NONLEAF_ADDED]++;
> > +               young = true;
> >
> >                 /* carry over to the next generation */
> >                 update_bloom_filter(mm_state, walk->seq + 1, pmd + i);
> > @@ -3799,6 +3827,8 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
> >
> >         if (i < PTRS_PER_PMD && get_next_vma(PUD_MASK, PMD_SIZE, args, &start, &end))
> >                 goto restart;
> > +
> > +       return young;
> >  }
> >
> >  static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long end,
> > @@ -3809,6 +3839,7 @@ static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long end,
> >         unsigned long addr;
> >         unsigned long next;
> >         struct lru_gen_mm_walk *walk = args->private;
> > +       struct lru_gen_mm_state *mm_state = get_mm_state(walk->lruvec);
> >
> >         VM_WARN_ON_ONCE(p4d_leaf(*p4d));
> >
> > @@ -3822,7 +3853,20 @@ static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long end,
> >                 if (!pud_present(val) || WARN_ON_ONCE(pud_leaf(val)))
> >                         continue;
> >
> > -               walk_pmd_range(&val, addr, next, args);
> > +               /*
> > +                * Cross-node empty walk suppression. A 1GB PUD subtree whose
> > +                * 512 PMDs all failed the PMD-level Bloom filter last generation
> > +                * found no young leaf entries for this lruvec, so skip the whole
> > +                * PMD iteration instead of re-checking every entry. This mirrors
> > +                * the PMD-level filter one level up and mainly cuts the cost of
> > +                * walking page tables of processes whose memory lives only on
> > +                * other NUMA nodes.
> > +                */
> 
> Is this a common case? It seems a bit odd to me that NUMA balancing
> doesn't keep the process and its memory on the same NUMA node.
> Or is it because users don't pin processes and memory properly?

Hmm, a good question. The empty walks are not caused by NUMA balancing,
but from how MGLRU manages mm->lru_gen.bitmap: lru_gen_use_mm() sets
all bits at every context switch, and each node's walker clears only
its own bit after walking. So an actively scheduled process is walked
by every node every aging pass, no matter  where its memory is. Let me
give an example:

You have a system with 8 NUMA nodes, and you launch a process A on
node 0, then A has mm->lru_gen.bitmap all set, then when iterating a
lru_gen_mm_list, it will check mm->lru_gen.bitmap in get_next_mm() even
though A only runs on NUMA node 0, while lruvec on other NUMA node will
also check process A's page table. I think the original purpose of this
is it doesn't want to skip those pages of A which unfortunately are
migrated to other node. While this causes a lot of empty walk on other
node.

Not sure if I got your question correctly.


