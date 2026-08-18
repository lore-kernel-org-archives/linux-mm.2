Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D74CC5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 13:56:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C9BA6B018D; Tue, 18 Aug 2026 09:56:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67A2D6B018E; Tue, 18 Aug 2026 09:56:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 542706B0197; Tue, 18 Aug 2026 09:56:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 299C46B018D
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:56:10 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A3AC41C0A88
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:56:09 +0000 (UTC)
X-FDA: 85114539258.24.F4FF804
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id CE1C340008
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:56:07 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="GUgmc/3D";
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787061367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0ybpsH1qF2kQ2X6hSDpZ9q8bsv7zDFXVoiomo/Pu55E=;
	b=oBu3TUw2K/4LQWcaEsTNjM0AF3asH7qsYES78POWc4XeTK/IvvgSx73KMYZeBRlqRcnZp8
	1JuqXRQM8EbmO3/s4gVNrLISWnw49qPhVVoZQ3mamTNVvftlHlrUED0joHVPaobtKb5a51
	fKNa1uMgH/MiYcWI14XaaiRHjez8KH4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="GUgmc/3D";
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787061367;
	b=CD+XGzn7pXO7hvEZ1o5H0k2I/NteozP1+CRsy0+TFwuMTh9GE2kt1fM+VuZGMZAT7fMc85
	HKSPMGicgThUaU1bHDpLdB5f0Q2ykJSIxfu2k5ejb31ZRINc7TrxARMDaLWwi1AIMlUVBj
	DKZv/FfWD9JVCvYfIDvJLeV/dud9b7M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ECC91601DE;
	Tue, 18 Aug 2026 13:56:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEBE21F000E9;
	Tue, 18 Aug 2026 13:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787061366;
	bh=0ybpsH1qF2kQ2X6hSDpZ9q8bsv7zDFXVoiomo/Pu55E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=GUgmc/3D567E4tL2tG1nSOtkACzTHrpqUfHPfBlNAV9t3PmzP0NP295lMalU/nCau
	 rxnJ6+EiTC/EDYUMcMxNrBhER1u6ShT+OxJDkOzAGBkjCcz63dObu9toyz/wCg+TKA
	 vlMqebfHedAKp4/lmWURIRjylBxowC/VhEUGhWBnd6Jrnw/a4cij3WExAL3GwbEoGc
	 aaSO0Z1DS7ZhmjjHjK3PWjqOlx2KgjninBCIgV8b0qGKq2lpsSm8pQEDGSSZY8azFE
	 J7q/edGf0D+c3RIe9Quxt7PTUsnmsb/GVtbA0HKIya75yKFMJa05bqxCMtSw68UlgL
	 XrOEp6Yz5E+ng==
Message-ID: <9f51ac27-24b2-495b-b397-84865f977d24@kernel.org>
Date: Tue, 18 Aug 2026 15:55:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 00/57] mm/collapse: rebuild collapse on migration
 primitives
To: Kiryl Shutsemau <kirill@shutemov.name>, akpm@linux-foundation.org,
 ljs@kernel.org, nico.pache@linux.dev
Cc: baolin.wang@linux.alibaba.com, baohua@kernel.org, dev.jain@arm.com,
 hughd@google.com, lance.yang@linux.dev, liam@infradead.org, mhocko@suse.com,
 rppt@kernel.org, ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com,
 usama.arif@linux.dev, vbabka@kernel.org, ziy@nvidia.com,
 usama.anjum@arm.com, agordeev@linux.ibm.com, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 kas@kernel.org, jannh@google.com, willy@infradead.org, pfalcato@suse.de,
 rostedt@goodmis.org, mhiramat@kernel.org,
 linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org
References: <20260816224609.308019-1-kirill@shutemov.name>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260816224609.308019-1-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CE1C340008
X-Stat-Signature: 57qsightqbmmwkmfzw3pgk84fwdxpqnh
X-Rspam-User: 
X-HE-Tag: 1787061367-374149
X-HE-Meta: U2FsdGVkX19r7NxCMzt7Ace4ux1b62hI1Nc+wxucgmeUL/sHFN3bv+Mlkv3fCtQlc52N6TyNm9VJmtXOVDXRvAtnKx0+rVIOKrYTeq+s7PARhfGMzzK5wuxARozKx9/pKclr7Jm5n99VX9bXVDKPOVAPE/D+qo5xsYv5Bxev4sCVMBrWxQWwd3UHG4ZlY1D7LmwzMINQDRajq+b6NZR0H2gbEfK1cSHj66hllNCI+vBUvJ/zsyjWpo5H8Y5fGV+AxWeOnFU3y9REPaE319xXXPrV8m1af+r/TiYOvCq91PhIQ7TO/XbpzOa3N3juqmnDSklTU2tqPKi0mzeRl2lvL8UF+yjcN61n1pm8sg7T9DOdYUmKghF3mO3OHMI5q37mEL8Skoz2Sp/nNt+YCc/TgtBnqcSKWV9lk7YP10srnU6+DyKv2zxVE5aAFaSYz1el72wNFRK2pznTKh6tH1GENvO6VeY+HvknHPU+pvmbWDnYfa2h2xA8f1vK3NldQdJSBb2FgDCBMbeLPsHZeEjpKhDgg4fvHVp7sT1p/iQoWji/aW3Ns82GMIFpRrHp6/IMqsws+1dMyy7R30gSlHx5DisakFAtUPzGbut5OtLJEaXKzq8GaScSjhd6XpXDqFZFaZJPl9rmmLRJZ9OA+BZ4zVcKLEznFjnoE9POHkan+sS+/rFijZ2Rwl8o1zdUe5GQQYpt+DC9KVcRn7x2ie72tyEOCSBKEnJer/2/ws3uXDJ0p1OYZ/rdfZDBg21fxqghYFkuK9IaplW9ZE+td6cXwyDYX4LG21Iqs0i+YEZp/moWbpn8uqPOEdiPieyGbZKwWmiJDH2AS8qcFEhRhwVtsS7v1pfAMDBxvxoP2dzfT7tPNEIG4JIt/A2Fto9X9M4N/Wdp82xuVsyOR5UbrUR/tD4z8e5KxFA52DuJ9wKeGklcKayRiWW8MonRnSp1GHatMUX+tfXp4wa1UOI/CCM
 v3v9z09T
 9llWqQy+kDFJp5QYiA538WGrNgdPIs6LDLxcgRT76F8WnwmOs4BhIBQs6SchjBuiw5CfuRrTrkWB6fpWD39he6eQhOj34KQ0Km/mmFZprM2egoJMuuYD3PuFvY0lApoR0Co1Cx9udZLx9D+dIbjbyvliwzbHCePXvXT7HAlLiQQTaG8LDCcMSBXVptrqrXyLip3x7EMOwfyMU7PwyWiwZOuqrkbHX0EZz7EfhiAd2nhqKC5XpMMy+mivFub4USOdRwwKvFjDZH76zDANZkoTHFgqXlKwb9I3FKTQr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/17/26 00:45, Kiryl Shutsemau wrote:
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

Replying here on the overall design first before reading into the other
discussions (and process related topics).

> 
> TL;DR
> =====
> 
> This replaces khugepaged's anonymous collapse with an engine that
> can collapse sub-PMD ranges. It is built around migration entries and
> frozen folios instead of heavy locking and isolation, aiming for better
> scalability and less disruption to the workload being collapsed.

I recall us discussing something around using some PTE/PMD markers (e.g.,
migration entries) in the past.

One thing that needed care is handling concurrent MADV_DONTNEED + faultin after
dropping relevant locks.

> 
> Why
> ===
> 
> mTHP collapse landed in khugepaged in 7.2 and I was glad to see it.  We
> at Meta run arm64 with 64K base pages, where a PMD is 512M: PMD-order THP
> is of limited use at that size, and mTHP is exactly what we want.

Right, as the first step, we decided to go for the simpler and minimally
intrusive approach of using the existing mechanism that always operates on PMD
ranges, keeping using the existing pmdp_collapse_flush()-based mechanism and
locking in place.

That's why anything more elaborate will require significantly more LOC :)

> 
> It turned out not to help us.
> 
> khugepaged only ever looks at PMD-aligned windows, and it is not an easy
> limitation to lift.


I recall we discussed some simpler way to make this work with VMAs that don't
fully span PMDs: I think write-locking VMAs (+ rmap) that cover the PMD was
discussed as a low-hanging fruit, such that other page table walkers would not
suddenly stumble over the temporarily removed page table.

So the mmap_write_lock() + vma write-locks prevents concurrent mmap+page faults
and the rmap locks prevent concurrent rmap walks.

There were discussions on the impact when a PMD spans many VMAs, and I think one
conclusion was that such scenarios are likely not worth considering (e.g., 512
VMAs in a single PMD, all with different rmap locks; your workload sucks already).

> 
> Fixing the alignment is a one-line change, but what it feeds assumes the
> PMD everywhere that matters: collapse_huge_page() clears and flushes the
> whole PMD whatever order it is collapsing, installs a PMD leaf because
> that is the only thing it can produce, and keeps everyone out with
> mmap_write_lock, anon_vma_lock_write() and an IPI broadcast while it
> does.
> 
> Which is why hugepage_vma_revalidate() demands that the VMA span the
> whole PMD even for an mTHP order -- "we'd need to lock all VMAs in the
> PMD range to support this", as the comment there puts it.  A PMD-granular
> operation is only safe when one VMA owns the PMD, and that is exactly the
> restriction in the way.  The alignment is the symptom; the PMD is the
> design.

I disagree with "A PMD-granular operation is only safe when one VMA owns the
PMD". It's safe when all page table walkers can be stopped (see above).

> 
> So both roots have to go.
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

Right. Concurrent MADV_DONTNEED can zap migration PTEs and other faults even
re-fault fresh anon folios. So that must be detected before replacing migration
entries again I guess.

> 
> What that removes from every collapse path:
> 
>   mmap_write_lock              -> mmap_read
>   anon_vma_lock_write()        -> nothing: an rmap walk needs the folio
>                                   locked, and the engine holds that lock
>                                   from freeze to putback
>   tlb_remove_table_sync_one()  -> nothing: one ranged flush per round
>   LRU isolation                -> nothing: sources are inert in place
> 

Not sure how you handle PMD collapse. I recall problems with migration entries
on the PMD level for non-folio things (we discussed something along these lines
also in the past).

> Working in windows rather than whole PMDs takes care of the other root.
> A sub-PMD window is collapsed under the page table lock, so a collapse
> disturbs only the window it collapses, and each candidate is validated

I recall us discussing that holding the PT lock for a longer collapse operation
(especially on 64k) is problematic. But I don't get all the details from your
description here.

> at its own order -- a window need only fit its own VMA.  A PMD-order
> candidate still has to own the whole PMD, which is the old rule kept
> where it is still needed.
> 
> Candidates are carried through the passes a batch at a time rather than
> one window at a time, so a round pays for its flush and its lock
> acquisitions once.

Now I am starting to feel that there are too many changes packed in a single
series :)

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
>  - Hole and zeropage population at every order, so partially populated
>    windows collapse to mTHP under the same max_ptes_none policy as PMD.
>  - Sources come in spans -- any stretch of consecutive PTEs mapping
>    consecutive pages of one folio -- so partially mapped and scrambled
>    compound sources (the PTE-mapped-THP re-collapse class) work at
>    every order.
>  - A table that cannot become one huge page still yields the largest
>    windows inside it, where before a single disqualified PTE gave up
>    the whole table.
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

I fail to parse this sentence.

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

[...]

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

Something more realistic might be running some workload in a VM whereby the VM
is getting collapsed by khugepaged.

[...]

> There may be a way out -- a PMD migration entry over the table during
> the window, so the CPU never caches a walk to shoot down -- but that
> means teaching every pmd-level walker a new kind of entry, and I have
> not tried it.

I think we discussed that in the past and it's absolutely nasty.

[...]

> Size
> ====
> 
> mm/ grows by 1915 lines net: 4475 added against 2560 deleted.
> 
That's quite a lot for something that reads like a cleanup at first.


Okay, let me read the other discussions.

-- 
Cheers,

David

