Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D054C5DF70
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 08:52:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 265856B0095; Mon, 17 Aug 2026 04:52:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 216176B009B; Mon, 17 Aug 2026 04:52:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1055D6B00A1; Mon, 17 Aug 2026 04:52:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DDF6B6B0095
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 04:52:38 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 65727C0684
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 08:52:38 +0000 (UTC)
X-FDA: 85110145596.17.ED97E1E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id C0BDE80005
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 08:52:36 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hRR9dQfs;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786956756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c8rt/m1ocK6A8DLGZQiJTrm2CPGOJpgEOjSjcb53xDg=;
	b=j0K228uJ9mVzXezCHBc4jkDcy5Gvotr9QnLaAQxMaWiqxDoIgOCKUzUsdYosZP9tiHpdeD
	ECcNwar7pUux1TE0hwtMDcWU+82063lOKb9bEzCUGG6uEL6EE/pttqzKQx91IjBRp6Tq1R
	U5VgvgDi0Fk/WC/J3L2nMGXmFneVvKU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786956756;
	b=6Qyf0KTD06Doxj9tdz493vyk9C4JYoky8ypA+Be8rYJI07h9NzLydWpG2QiY8Shv0QWG5f
	10MmdyNiZMrulF4OaN0WLyz6Q9abt4fleYyYb5S7aJc1CaobWYxlYiVO/2uDf1ct/x04Qy
	NPl+WYbkjdCkWeh0ge9Tmg5S/nPrg/g=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hRR9dQfs;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C50CE601FB;
	Mon, 17 Aug 2026 08:52:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43B471F000E9;
	Mon, 17 Aug 2026 08:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786956755;
	bh=c8rt/m1ocK6A8DLGZQiJTrm2CPGOJpgEOjSjcb53xDg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hRR9dQfselNlfEvxmpQRYrJwoHOJXopx/fovox92Sw3N9KznLokMthmvnYq0bXmHb
	 pTiFhVTKGpzosxSeqTpYnH1GtR5LpXKdYrP3cd8wfXZDL0CpN7zHPetbOdSj9DzvKO
	 rOUyBeLyinGIZcbqpwDhao92BL/vM//U/Tm/9OnJx89n+rZCE9ZOOt8A7S9YO/hpvS
	 NO3CW7CKaD4u8pUGOAFTt31mw7++n3u4xlxMdouWv80V4GhIV3ilWGYQuts4K1JnZl
	 m5rf5NYWJdeEtUzvIgYNr5ogNdYijynGa98Fk97+XOH+3w9lz+dXVPg0wm1QwIWduq
	 pFgYOPbGw5hTw==
Date: Mon, 17 Aug 2026 09:52:13 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, david@kernel.org, nico.pache@linux.dev, 
	baolin.wang@linux.alibaba.com, baohua@kernel.org, dev.jain@arm.com, hughd@google.com, 
	lance.yang@linux.dev, liam@infradead.org, mhocko@suse.com, rppt@kernel.org, 
	ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com, usama.arif@linux.dev, 
	vbabka@kernel.org, ziy@nvidia.com, usama.anjum@arm.com, agordeev@linux.ibm.com, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kas@kernel.org, jannh@google.com, willy@infradead.org, pfalcato@suse.de, 
	rostedt@goodmis.org, mhiramat@kernel.org, linux-trace-kernel@vger.kernel.org, 
	bpf@vger.kernel.org
Subject: Re: [RFC PATCH 00/57] mm/collapse: rebuild collapse on migration
 primitives
Message-ID: <aoLAly-oL2OAa4n8@lucifer>
References: <20260816224609.308019-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260816224609.308019-1-kirill@shutemov.name>
X-Rspam-User: 
X-Stat-Signature: jkjr87nw9ydmt5nn3to7h9u1bmd51g33
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C0BDE80005
X-HE-Tag: 1786956756-657670
X-HE-Meta: U2FsdGVkX1+thZnjoPUc3fcZxY/HK4dzhWd+cF159Mm372SZg2wsOQinXLre4gUXUy7kH96jekVQLFokHF0DcrPi5J5MZfyEEE6HCSbLroI+fUzxXqf3FM4FKfy84uWiaI7bhG3KOri3wVU0akV0n/aLLuGEZiz9ikW6xG056FRQBJBYEH9qSMn+DTNZUbwjAGX8lp+0oO/dsYrOvcLVXc4K/YFSAR8AdpGeHsgACsMmESoiCkZN8saQH9+HwufpZla+P1xVPGV+JsZoQ/mpAUy10ZWqthdPrU90jz6U+Hllhj/TJ6OAbxwYoRbqsOcJUZs7n6QfV19R3MJleoqs28UXVteBKauIXysdLU8WGvay9KGRHkBTbB5xj3F2Zcfwd0aH1MochKwOpXyrzFfscOcI+VMZw4igW4XGgn1d1ypfPf3Per0BfiaaGcQ6iVPCYYOuTaFIJ59dDbei2h6OTgldbvP76XpAfBWsSWC5ukpl3WONBOlu+gc/XuEEhjAT4e/j36HRTj3JkcmsmY+QXBX7BQS3FqUhnC0Ew0lUFFbuDYL7AXt5q4N6sIJh2+JwsonIfMgKZ0dI4grNRVpEhU8lVMJ8FnOPinar/gcZdqPvAbfIiCeFWBv58wJ7eLc+qKH3CdimfMd4o5+HPVUWU3XQb4wSxKb5cCuS6RFLx8DLHMvirTOIAIRA9G7zRZ0uyD51yNSAJe0k52wea1U5VU/41pEXGXQCgUKPDvg3OjW/yRr3zYSN4ozF0GWXAUMN/upauE6oD+wnWdgsJCVWe220WPkPYsyUuV2Xxk/VxFbLQqtHJ69dv2nTs3lqZHyENs/s7UtmJqy27TZIKthtkzHhO2LeNoL6gzziV9FMk/3TRDe5UApHF5aW9ZfBkscHTUa2kWL209YTLxOH78/IyJwnuN5999f/buP3XWdLf5Pqm5QkZQyAPEtVTwemgpf8Uj9D7teo+Pf5xFVHcuq
 tuaT9nMR
 MCF/9Gmj8bONAFBeCqUfknPB26SKi5ht9NCw/UGIfN1M11jTs/OuWM69hwNunoRrXUduKxEEMG55pSO7RBlEcBGFHQVVpoGFygunhYVxQ+q6Zwz0JlGFYdo/JdLHyeD4py/T1eaGWugWEsV42Qnn4ksN4ktlHzJnXmWg/uBMyMW1XZh45+z3KKDcJib5W684RJAxUCeuUE490Sc+Eio0/IMzqJsyvE0XCyCd2G/SVGrMQPc6QVyhGuJAJC5NmciVJtiTOgiyXIJXgcmDArJAzcXomsWi1sYqWf01iMEjP8fCTsnyYz4NmWlb08k38cqLXHIbPd5toovBZUmZJDc6LYRPGT2VpNCxAC9Aw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+cc Pedro for discussion about perf numbers

On Sun, Aug 16, 2026 at 11:45:12PM +0100, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
>
> Yes, I know, this is a lot of changes. But I'm happy with the overall state
> of the patchset and the only reason I tag it as RFC is that it is tricky
> to get 57 patches upstream.
>
> I wanted to give a view of the end state first. I will suggest a possible
> way to split it below.
>
> I would appreciate any feedback.

Oh Kiryl :)

We have a THP cabal meeting every couple of weeks where it would have been
useful for you to raise this first.

In any case - this series is not something we'd consider at the moment,
even broken into parts.

David and I have put THP into feature freeze - until the codebase is
subtantially improved we're not really interested in seeing significant
development.

The technical debt is substantial and has to be paid down first.

See [0] for a rough list of TODOs in this regard.

(I also intend to do at least 1 series that improves things shortly
myself.)

mTHP khugepaged was allowed in _despite_ my being reticent given this
technical debt, but with a proviso of a feature freeze afterwards.

It's still fine obviously to send a theoretical RFC for early feedback. But
there can be no un-RFC'ing any time soon.

I'd suggest looking at cleanups that could act as foundations for your
changes.

I'll try to find some time to look through the actual patches to make
concrete suggestions/see if we could break some of this out like that.

Some more comments below.

>
> TL;DR
> =====
>
> This replaces khugepaged's anonymous collapse with an engine that
> can collapse sub-PMD ranges. It is built around migration entries and
> frozen folios instead of heavy locking and isolation, aiming for better
> scalability and less disruption to the workload being collapsed.

OK interesting :)

>
> Why
> ===
>
> mTHP collapse landed in khugepaged in 7.2 and I was glad to see it.  We
> at Meta run arm64 with 64K base pages, where a PMD is 512M: PMD-order THP
> is of limited use at that size, and mTHP is exactly what we want.

Do you have some numbers that indicate to what degree mTHP khugepaged is
beneficial?

I was discussing this with Pedro recently and he pointed out that we have
very poor coverage of the actual observed benefits of mTHP khugepaged
(there are reasons to have merged it anyway but still).

Some detailed analysis on how it benefits Meta would be really beneficial,
with specifics and what settings you find useful.

Is it only useful for larger page size? What orders have you found to be
most effective?

Is it useful in itself or do you view it as a stepping stone to further
work, like this?

>
> It turned out not to help us.

I mean maybe this answers my question :)

>
> khugepaged only ever looks at PMD-aligned windows, and it is not an easy
> limitation to lift.

Yes. This assumption is very much baked in.

I guess this is coming from the perspective of having ranges that are
neither PMD-aligned nor sized (far harder to achieve with 512 MiB PMD size
obviously).

>
> Fixing the alignment is a one-line change, but what it feeds assumes the

Hmm not so sure about that... especially given how baked in these
assumptions are.

Which by the way, all speaks to the need for rework.

The first stage in my view would be to improve the code to the point that
these kinds of assumptions fall out of it, which then lays the foundations
for future changes to eliminate the assumptions.

> PMD everywhere that matters: collapse_huge_page() clears and flushes the
> whole PMD whatever order it is collapsing, installs a PMD leaf because
> that is the only thing it can produce, and keeps everyone out with
> mmap_write_lock, anon_vma_lock_write() and an IPI broadcast while it
> does.

To be clear - the anon path. I think important to clarify :)

And yeah it does IPI for any sensible arch (with
CONFIG_MMU_GATHER_RCU_TABLE_FREE) via tlb_remove_table_sync_one(). The
other arches IPI anyway on TLB invalidation.

[Though I intend to make all page table freeing RCU relatively soon which
should? Eliminate the need for this, possibly?]

It doesn't insert a PMD leaf entry for mTHP collapse though, that's
incorrect.

It does, as you say, clear down the PMD even on mTHP PTE range
installation, and has to hold the rmap lock for a longer period to account
for adjacent ranges that share a PMD entry.

All in all it's a mess yes and clearly can be improved.

>
> Which is why hugepage_vma_revalidate() demands that the VMA span the
> whole PMD even for an mTHP order -- "we'd need to lock all VMAs in the
> PMD range to support this", as the comment there puts it.  A PMD-granular
> operation is only safe when one VMA owns the PMD, and that is exactly the
> restriction in the way.  The alignment is the symptom; the PMD is the
> design.
>
> So both roots have to go.

Yeah this is pretty radical stuff so it's just an absolute no until
technical debt is paid down properly.

That means signficant rework to make this code something far from the
overly-coupled spaghetti mess that it is now.

Efforts have been ongoing with this, Nico and others have submitted
cleanups and obviously more is required here.

But yes I think decoupling the ossified PMD assumption is important.

However we have to remember that a lot of the user-visible API assumes PMD
sizing and so the code has to clearly reflect this and make it clear that

>
> Design
> ======
>
> The old mechanism holds the address space still because it has nothing
> else stopping the sources from moving under the copy.  The new engine
> makes the sources themselves inert instead, with the two barriers
> migration already uses, raised in that order:
>
>   1. migration entries replace the source PTEs.  Faults and GUP-slow
>      now wait on the source folio's lock, which is taken before the
>      first entry becomes visible.
>   2. the source folio's refcount is frozen to its expected value.
>      GUP-fast, pfn walkers, reclaim, compaction and memory-failure all
>      fail folio_try_get() and back off.
>
> Between the two, nothing can reach a source, so the copy runs with no
> lock held at all -- and the address space is left alone while it does.

Hmm, are migration entries the right mechnanism here? Are you actually
migrating the pages to a large folio here, or using them to get the
behaviour you want on fault/GUP?

Same question in general for the freezing.

I'm not suggesting quite that these are the wrong mechanisms, just querying
how they are being used here.

I do like the idea of using the folio lock though. All rmap operations now
take the folio lock when traversing the rmap.

>
> What that removes from every collapse path:
>
>   mmap_write_lock              -> mmap_read
>   anon_vma_lock_write()        -> nothing: an rmap walk needs the folio
>                                   locked, and the engine holds that lock
>                                   from freeze to putback

I do like the idea of eliminating uses of the rmap lock like this, not only
for contention's sake but also for scalable CoW purposes which introduces
challenges with regards to holding these.

In fact, migration and huge memory collapse are the really problematic
areas.

>   tlb_remove_table_sync_one()  -> nothing: one ranged flush per round

Aren't we reliant upon this synchronisation for correctness?

>   LRU isolation                -> nothing: sources are inert in place
>
> Working in windows rather than whole PMDs takes care of the other root.
> A sub-PMD window is collapsed under the page table lock, so a collapse
> disturbs only the window it collapses, and each candidate is validated
> at its own order -- a window need only fit its own VMA.  A PMD-order
> candidate still has to own the whole PMD, which is the old rule kept
> where it is still needed.
>
> Candidates are carried through the passes a batch at a time rather than
> one window at a time, so a round pays for its flush and its lock
> acquisitions once.
>
> With the barriers holding the sources still, which read lock the engine
> takes stops being part of the design.  A round works inside a single
> VMA, so patches 43-49 switch it from mmap_read to per-VMA locking: an
> mmap_write elsewhere in the mm then stops waiting for a collapse that
> has nothing to do with it.  That block is the only part of the series
> that needs per-VMA locking to be unconditional, and it is a separate
> dependency (see below); everything before it runs under mmap_read and
> does not care.
>
> Patch 7 sketches the engine as a comment naming every pass, what lock it
> takes and what it may sleep on; the details are there rather than here.
>
> What falls out beyond the lock diet:
>
>  - mTHP collapse in VMAs smaller than a PMD, which is the arm64 case
>    above: a 2M VMA on an arm64/64K machine collapses nothing today at
>    any order, and collapses to mTHP here.

I do worry about knock-ons from this. Has to be carefully checked.

>  - Hole and zeropage population at every order, so partially populated
>    windows collapse to mTHP under the same max_ptes_none policy as PMD.
>  - Sources come in spans -- any stretch of consecutive PTEs mapping
>    consecutive pages of one folio -- so partially mapped and scrambled
>    compound sources (the PTE-mapped-THP re-collapse class) work at
>    every order.
>  - A table that cannot become one huge page still yields the largest
>    windows inside it, where before a single disqualified PTE gave up
>    the whole table.

Are you permitting collapse of ranges that straddle PTEs?

Though in general I'm confused by the single disqualified PTE here -

>
> Reading the series
> ==================
>
> 57 patches is a lot to land on a list.  They go in blocks:
>
>   1-6    helpers and shared state: pte_folio(), pte_none_or_zero(),
>          mm/collapse.h, and the policy that replaces asking whether
>          khugepaged started a collapse
>   7-8    the engine's shape: entry points, a call-tree comment naming
>          every pass, and the scan filled in
>   9-23   the collapse half, top down: the round frame, then each pass
>          in turn, then selection and the retry store
>   24     per-candidate tracing, before the switch takes the old
>          tracepoints away
>   25-28  the switch: point the anon path at the engine, widen coverage
>          to sub-PMD VMAs, delete the mechanism it replaces
>   29-35  move what is left of collapse out of khugepaged.c, and
>          MADV_COLLAPSE into madvise.c
>   36-42  tracing: the engine's own events and trace header
>   43-49  per-VMA locking, and the mm reference that makes it safe
>   50-56  selftests for what the engine can now do
>   57     MAINTAINERS

Yeah as I replied there the MAINTAINERS change is totally unacceptable :)

This is THP code and belongs to the THP maintainers/reviewers.

No coup d'etat please :)

Also reviewership/maintainership in this area is predicated on significant
review contributions which are badly needed in THP. So effort in this
respect is appreciated too :)

And come to a THP cabal meeting to discuss your changes with us please!
We're friendly :)

>
> The two patches worth reading first if you read nothing else are 7 (the
> design, as a comment naming the whole call tree) and 16 (the freeze,
> which is where the safety argument lives).
>
> A possible split, if that helps:
>
>   1-2    two mm helpers, pte_folio() and pte_none_or_zero().  Both
>          convert callers outside collapse and are useful on their own
>   3-27   the engine and the switch-over.  This is the smallest unit
>          that does anything: stop earlier and the tree carries an
>          engine nothing calls
>   28     remove the mechanism the engine replaces
>   29-42  moving what is left of collapse out of khugepaged.c, and the
>          engine's own tracepoints
>   43-49  per-VMA locking
>   50-57  selftests and MAINTAINERS
>
> Keeping the removal separate leaves both engines in the tree with only
> the new one reachable, so the switch can be reverted on its own if
> something turns up.  The old mechanism is already carried that way for
> three patches inside the series, so this costs nothing but 975 lines of
> unreferenced code until 28 lands.  That safety net only lasts until the
> blocks after it land, though: once collapse has moved out of
> khugepaged.c and the locking has changed, reverting the switch no longer
> gives back a working old engine.

Again as above, no to these changes in any form at the moment.

The techical debt must be paid down first.

>
> Base and dependencies
> =====================
>
> This applies on the selftests series, not on plain mm-new:
>
>   [PATCH v4 00/19] selftests/mm: improve khugepaged coverage
>   https://lore.kernel.org/all/20260815015901.1236937-1-kirill@shutemov.name/
>
> which is on mm-new 33f61b12d297.
>
> Patches 43-49 depend on Suren's unconditional per-VMA locks:
>
>   [PATCH v6 0/5] mm: Unconditional per-VMA locks and cleanups
>   https://lore.kernel.org/all/20260813193433.3318288-1-surenb@google.com/
>
> That series is not in mm-new yet, and with patch 46 applied SMP=n does
> not build without it: lock_next_vma() is behind CONFIG_PER_VMA_LOCK in
> mmap_lock.h.  Everything up to patch 42 builds and runs on mm-new as it
> stands.  There is no fallback path by choice -- adding one would mean
> carrying two locking models through every pass.
>
> Both branches are available at
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kas/linux.git collapse/rfc-v1
>
> and the benchmark used for the numbers below, which is unposted and not a
> dependency, at
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kas/linux.git perf/bench-usemem

As above.

>
> Performance
> ===========
>
> Measuring khugepaged is awkward.  It is a background daemon, so what
> matters is what a workload feels while it runs, not what the daemon
> reports about itself -- and the usual coverage instrument is no help
> below the PMD: smaps AnonHugePages only counts PMD-order folios, so it
> reads zero however much mTHP has been collapsed.
>
> So I wrote "perf bench mem usemem" for this.  It touches a region while
> khugepaged works on it and reports the workload's own latency
> percentiles and throughput, against per-size counters that can see
> sub-PMD folios.  The branch is above; it is unposted and not a
> dependency.
>
> x86-64, production configs (no KASAN, no lockdep, no DEBUG_VM, no
> PAGE_TABLE_CHECK), interleaved rounds on an idle host, equal work on
> every arm.
>
> I measured three kernels, so the two halves of the series can be told
> apart in the numbers below:
>
>   A   the base
>   B   the new engine, still under mmap_read
>   C   B plus per-VMA locking -- what this series ends up with
>
> The engine: a sub-PMD collapse stops blanking the surrounding 2M
> -----------------------------------------------------------------
>
> base routes sub-PMD collapse through collapse_huge_page(), whose
> pmdp_collapse_flush() and tlb_remove_table_sync_one() are not gated on
> order: to collapse an order-4 window of 16 pages it clears and flushes
> the whole 512-page PMD and IPIs, then repopulates.  The engine does the
> window under the PTL.
>
> A thread reading and writing a 32G region while it is collapsed at
> order-4, 16384 collapses on every arm:
>
>                          A        B        C
>   read p99 (ns)       3071     1023     1023   -66.7%
>   write p99 (ns)      3071      927      927   -69.8%
>
> and the workload's read rate rises by 68% on both engine kernels.
>
> B == C, so this is the engine, not the locking.
>
> At PMD order the same workload is flat, and that is expected rather
> than disappointing: it is the one configuration where both mechanisms
> disturb exactly the same 2M.  Read it as no regression at PMD order.
>
> Per-VMA locking: address-space operations stop waiting on the scan
> -------------------------------------------------------------------
>
> MADV_HUGEPAGE/MADV_NOHUGEPAGE toggling against a scanning mm, which is
> what jemalloc does with its arenas.  4096 collapses on every arm:
>
>                          A        B        C
>   ops/sec           340656   340820   603305   +77%
>   p99 (ns)           77823    86015     3327   -96%
>   p99.9 (ns)         86015    94207     9215   -89%
>
> B is about 11% worse than base at p99 here, consistently across runs:
> the engine alone slightly worsens hint-toggle latency, and per-VMA
> locking is what turns it into a win.  Both halves are in this series, so
> C is what a reviewer gets, but the middle column is the honest one.
>
> The trade is real in the other direction too.  On settled memory with
> nothing to collapse and scan_sleep_millisecs=0, per-VMA locking costs
> about 47% of scan throughput against one mmap_read for the whole walk.
> That is a synthetic worst case -- the daemon wraps 8000 times a second
> there, where production defaults to 10s between passes -- and it buys
> mmap/munmap p99 of 56us against 1.4us.
>
> Collapse itself is not slower
> -----------------------------
>
> One complete pass over a 32G region, 16384 collapses, khugepaged CPU
> from /proc/<pid>/stat, 7 repeats:
>
>   A base    median 5760 ms   spread 12.7%
>   B engine  median 4990 ms   spread  3.8%
>   C pervma  median 5020 ms   spread 12.4%
>
> The base arm is bimodal, so its median moves with sampling and the
> percentage is soft.  The distribution-free statement is better: every
> engine run used less CPU than every base run.
>
> The engine also allocates one destination per folio installed, where
> base allocates 5.25 and frees the rest again: nothing is allocated until
> the sources are frozen and the collapse can no longer be refused.
>
> A measurement note, since an earlier version of this series quoted worse
> figures.  khugepaged CPU has to be measured per collapse or per
> completed pass, never over a fixed window with scan_sleep_millisecs=0:
> the daemon never sleeps, so whichever kernel finishes the work sooner
> spends the rest of the window scanning settled memory and is charged for
> it.  Measured that way the engine appeared to cost 10% more CPU;
> measured per unit of work it costs less.
>
> Costs
> =====
>
> At PMD order the engine issues two TLB flushes per collapse where the
> old mechanism issues one: the freeze's ranged flush plus the terminal
> layer's pmdp_collapse_flush().  A PMD candidate is alone in its round,
> so nothing amortizes the first.  Dropping the old per-collapse
> tlb_remove_table_sync_one() IPI presumably pays for it, but that was not
> measured and is not claimed here.
>
> There may be a way out -- a PMD migration entry over the table during
> the window, so the CPU never caches a walk to shoot down -- but that
> means teaching every pmd-level walker a new kind of entry, and I have
> not tried it.

Hmm this seems like complexity on top of complexity...

>
> PMD collapse deposits a freshly allocated page table instead of
> redepositing the detached one.  Whoever withdraws a deposited table
> frees it immediately, with nothing to hold a lockless walker off first,
> and under a read lock the detached table may still be traversed by
> GUP-fast or an RCU pte walk.  It goes to pte_free_defer() instead,
> exactly as retract_page_tables() does.  One transient table page per PMD
> collapse buys the IPI's absence.
>
> That cost goes away if zap_deposited_table() -- the only site that frees
> a deposited table outright, the others redeposit it or repopulate the
> PMD with it -- used pte_free_defer().  The deposit would no longer have
> to be quiescent and the detached table could go straight back.  It would
> defer every THP zap's table free, and I have not tried it.
>
> A shared source now costs an extra copy.  The freeze needs every page
> exclusive to this mm, so the fault-in pass breaks CoW first -- an
> allocation and a copy -- and the collapse then copies that page into the
> destination; the old mechanism copied a shared page straight into the
> new folio and broke the sharing that way.  It is bounded by
> max_ptes_shared, which khugepaged holds at zero below the PMD order, so
> in practice this is PMD-order collapse and MADV_COLLAPSE.

Hmm I guess better to be explicit.

>
> Size
> ====
>
> mm/ grows by 1915 lines net: 4475 added against 2560 deleted.
>
> That is not a claim that this is less code, but it is less than it
> looks.  khugepaged.c goes from 3283 lines to 908.  The new engine is
> 4052 lines across mm/collapse.c and mm/collapse.h, of which 1344 --
> about a third -- are comments, which is where the pipeline's invariants
> are written down.  What replaces three install paths with their own
> isolate/copy/rollback is one engine and one contract.

As above. The existing codebase is a mess and must be cleaned up first,
this isn't optional.

>
> Testing
> =======
>
> Both matrices run the mm selftests plus a race harness, on the
> validation config: KASAN, lockdep, PROVE_LOCKING, DEBUG_VM and
> PAGE_TABLE_CHECK, 16G of guest memory, swap active so the swap-in
> prepass is exercised rather than skipped.
>
>   x86-64        433 pass, 0 fail, 12 skip
>   arm64/64K     581 pass, 0 fail, 18 skip
>
> dmesg clean on both.  The arm64 skips are a pre-existing shmem
> MADV_COLLAPSE -EINVAL on 64K pages, confirmed against the base by A/B.
>
> Every one of the 57 patches builds with no new warnings; !NUMA and !MMU
> (arm nommu) build clean.  SMP=n does not build, for the reason in the
> dependencies section above.
>
> The race harness also gets longer soaks -- 1800s per driver mode, with
> memory pressure and swap -- and the engine is fuzzed with syzkaller on a
> KCOV+KASAN build.  That found two bugs the selftests could not reach: a
> teardown that dropped rmap while the source was still frozen, where
> removing an mlocked mapping munlocks and munlock_folio() takes a
> reference a frozen folio forbids; and a whole-table MADV_DONTNEED racing
> the copy window under CONFIG_PT_RECLAIM, which freed the table and left
> the sources frozen and locked.  Both are fixed, and both gained coverage
> -- the mlocked case is patch 53.

Thanks for the detailed explanation.

>
> Kiryl Shutsemau (Meta) (57):
>   mm: add pte_folio()
>   mm: add pte_none_or_zero()
>   mm/collapse: add collapse.h for the shared collapse state
>   mm/collapse: rename mthp_present_ptes to eligible_ptes
>   mm/collapse: state what a collapse may do in the policy
>   mm/collapse: move the smallest collapse order to collapse.h
>   mm/collapse: sketch the new anonymous collapse engine
>   mm/collapse: scan a table for what a collapse could use
>   mm/collapse: collect candidate windows into a round
>   mm/collapse: run a round and feed the outcomes back
>   mm/collapse: sketch the passes of a round
>   mm/collapse: allocate a destination per candidate
>   mm/collapse: revalidate a round against the VMA
>   mm/collapse: fault the sources in before the freeze
>   mm/collapse: check what a candidate would freeze
>   mm/collapse: freeze the sources behind migration entries
>   mm/collapse: copy the sources into the destinations
>   mm/collapse: install the destinations at PTE level
>   mm/collapse: install a PMD leaf as the terminal layer
>   mm/collapse: put the sources back
>   mm/collapse: settle whatever the round reached
>   mm/collapse: walk a table with a selection cursor
>   mm/collapse: give a refused region a second chance
>   mm/collapse: report each candidate's outcome to tracing
>   mm/collapse: collapse anonymous memory with the new engine
>   mm/collapse: give collapse_single_pmd() the range to work on
>   mm/collapse: scan the windows a VMA can hold
>   mm/collapse: remove the mechanism the engine replaces
>   mm/collapse: move what a collapse is judged on into collapse.c
>   mm/collapse: name the max_ptes ceiling after collapse
>   mm/khugepaged: count collapses where khugepaged makes them
>   mm/collapse: move the file collapse into collapse.c
>   mm/collapse: split collapse into a scan and a run
>   mm/collapse: implement MADV_COLLAPSE in madvise.c
>   mm/madvise: drop MADV_COLLAPSE's redundant mm reference
>   mm/collapse: report what the scan found
>   mm/collapse: report what the fault-in pass paid
>   mm/collapse: report the round, and what it made faulters wait
>   mm/collapse: name the file collapse's tracepoints after collapse
>   mm/collapse: remove the tracepoints of the mechanism that is gone
>   mm/collapse: give collapse its own trace header
>   mm/collapse: allow error injection into the freeze
>   mm/khugepaged: check the scan budget before the work, not after
>   mm/khugepaged: hold the address space open across a scan
>   mm/collapse: take a per-VMA read lock for the round
>   mm/khugepaged: scan under a per-VMA read lock
>   mm/madvise: collapse under a per-VMA read lock
>   mm/collapse: assert the mm reference the engine relies on
>   mm/khugepaged: drop the mmap_lock barrier from __khugepaged_exit()
>   selftests/mm: attribute collapses by candidate event alone
>   selftests/mm: cover collapse inside a sub-PMD VMA
>   selftests/mm: cover a hole-y window in a sub-PMD VMA
>   selftests/mm: cover collapse of mlocked ranges
>   selftests/mm: cover collapse beside a MADV_FREE'd page
>   selftests/mm: cover collapse beside a pinned page
>   selftests/mm: cover the scaled max_ptes_shared limit
>   MAINTAINERS: add an entry for collapse
>
>  MAINTAINERS                                   |   19 +-
>  fs/proc/task_mmu.c                            |    4 +-
>  include/linux/huge_mm.h                       |    9 -
>  include/linux/mm.h                            |   14 +
>  include/linux/pgtable.h                       |   17 +
>  .../events/{huge_memory.h => collapse.h}      |  176 +-
>  kernel/bpf/btf.c                              |    8 +-
>  mm/Makefile                                   |    2 +-
>  mm/collapse.c                                 | 3808 +++++++++++++++++
>  mm/collapse.h                                 |  244 ++
>  mm/hugetlb.c                                  |    8 +-
>  mm/khugepaged.c                               | 2711 +-----------
>  mm/madvise.c                                  |  251 +-
>  mm/migrate_device.c                           |    9 +-
>  mm/mremap.c                                   |    2 +-
>  tools/testing/selftests/mm/khugepaged.c       |  346 ++
>  tools/testing/selftests/mm/khugepaged_race.c  |   29 +-
>  .../selftests/mm/khugepaged_sync_check.c      |   65 +-
>  tools/testing/selftests/mm/vm_util.c          |    2 +-
>  19 files changed, 5022 insertions(+), 2702 deletions(-)
>  rename include/trace/events/{huge_memory.h => collapse.h} (60%)
>  create mode 100644 mm/collapse.c
>  create mode 100644 mm/collapse.h
>
>
> base-commit: 8b76faf42c5d342b3bf0b1fd97bdaf603ee57354
> --
> 2.54.0
>

--
Cheers, Lorenzo

[0]:https://docs.google.com/document/d/1dsAXvVtioR2Hj98E_Um6220jamdznWxYsyx8jO0aUGU/edit?usp=sharing

