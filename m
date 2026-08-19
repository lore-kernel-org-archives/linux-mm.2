Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D64DC5DF81
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 17:09:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 240856B0092; Wed, 19 Aug 2026 13:09:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F1706B0093; Wed, 19 Aug 2026 13:09:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 107206B0095; Wed, 19 Aug 2026 13:09:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D74566B0092
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 13:09:18 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5DA96A05B3
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 17:09:18 +0000 (UTC)
X-FDA: 85118654796.18.A195D7C
Received: from flow-a2-smtp.messagingengine.com (flow-a2-smtp.messagingengine.com [103.168.172.137])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5FAD114000C
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 17:09:16 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="X kXQWv4";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=B56neHLq;
	spf=pass (imf09.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.137 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787159356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rngWsIbqp4UM0fSmr3ndBU+ttc5Nai8HRxYczVDElJk=;
	b=rXJD8RGShhR+fwn537VtHumZAVNURtSlo+4y9iGposzbtEJM8YQMeCCoC/cBvD+7Kro5K/
	ka8QJW1jzLnVb/R/WE8vT2b27QCcA4Qf6UhIiq9bZ0dIvpv1a6fSwFXPPfsrM30cZ+mVWF
	7p2UnwPh+wXwKOJIQ/c9h7A5ZwVPt5U=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="X kXQWv4";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=B56neHLq;
	spf=pass (imf09.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.137 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787159356;
	b=iW+U3spBY1fnT4bTJFIv40gnl6fat9TRG1JZH5eL8KSBYxFQGxAzNGtUAQZHVlCJAOp2MZ
	Oti8VjaY1JWvuPlIqc6V0W0qW0qvckCf7NoSAWAIKYnnJwJcwNwgu3imgFd6JqjEKbf0GL
	355+nQooNv/iVDdALKxD+4idzfNCl0s=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailflow.phl.internal (Postfix) with ESMTP id B412913801E1;
	Wed, 19 Aug 2026 13:09:15 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Wed, 19 Aug 2026 13:09:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1787159355; x=
	1787166555; bh=rngWsIbqp4UM0fSmr3ndBU+ttc5Nai8HRxYczVDElJk=; b=X
	kXQWv4mldgxmebPhO5HInIrxwEyXD7vdckRHaKRDChcdEPNbk3qUOf9dnVbAxlMk
	az0p914xNSD65d/CambQfN2m53NBgSIkHBnSKTXEIclH4UOt4ibk3DKjRnU5yycs
	W7gDD2J/wOyvepAeEmZgp9k0q7alDQtUKYNLYKWaqLBHf+QG8jqy7cMnTfj+GAuu
	7MQ1r1ZnLMcfU8hBJlRrigPUfjmRCFrQRm1vdhOQQL6UeeoG4NjPyKihvsxb0bkG
	Phm8LO8GScuNqukHYN3lMaQr3SwfMpvPpHZKUKrOTPc05t8FaOh2Z2Kj0H+zOP5p
	KsvUp92DdQ24UqVFIDM1Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1787159355; x=1787166555; bh=rngWsIbqp4UM0fSmr3ndBU+ttc5Nai8HRxY
	czVDElJk=; b=B56neHLq7er86+lmQ2V++BpiXFLH6WkSpfWF4TZ53vg1yUV4AW3
	9SQBlGGfqGGcpFkq6dQTt6aFnKNJyxn/7BSYUTvQ/RvRsnElNoxGCBrhrEgXXGNx
	qaLVSl81xjPChjmV16jkux7Sty6758SxBluBXpK3eOQc2e/ch2GoUONBIbKngSxX
	VTFwZOhvh75/cYypXnDj/c3zTm6u3IU6xugzHtJSGDWIihvQp8e9exTT0PNm3hPS
	AFDhWChONL8lNT/KUfGjOf6u9qK7vuwlLP89Lciv856uSXuvtWMdER5nTWhkOdt6
	9bBIctLhJPJTTOE0ghgRBVHd3JpYVHw4FNw==
X-ME-Sender: <xms:OuOFahdNPCaQTr9ES9HTrKEi-_OhwFcGJL2Y1JwhYpfj-YN4SSFw6g>
    <xme:OuOFahgThiTOZcJOBYBmDOPIsCJPcyiNaEmsn_nBDnF1DRh1ms9OGeDMtwbdJHfre
    WAo6GPgUePt_ZD9Nqo--RmJ2IR64gmxMOv77SrY4-0mt22qpyh0nvgT>
X-ME-Received: <xmr:OuOFapTYCJl9yzGlAvik790RSVDJbcQrwMvOhgXHFHBDFlO5GI5Aj2H_MyY>
X-ME-Proxy-Cause: dmFkZTF2hJnMxPlMk/jfavBtLUpTUzRd98wV0yj6Xt/Tg57fveFXbfrnoCBHAhwoJSnwvc
    MtBG50RSMfmClpPI3x6CkcWZCyQvMgs1EZ/KW76Yapbv4d0vUdc6gFqdtYBxQZoYDkSqYD
    2YcaHdEdQfhRcwKftYsqzXEfDtHBoWdxBFtT8n56HAZST46t7Dn270fSXfsHXaq5JKYPDD
    JoKvC7wqN5tCFOmjr9104dGNuRhfDkdXo/k1uVDYnCrgfsZx1Du/6tDXbC34XfACrLwl8p
    prfw7PeES/yEPXECxT/4GTheYyqLa/iux7yvt2JLPJJHC1s6Kbpk2oi4ksERMJCH47snQd
    o5MgcUNJ9MgaGAfFhljde5JsdiLa7vnywvzsFsEsyh6/jENVfGHBB4NYMoCHdzyeFT8lW6
    yYx1d6atj2GRUwmmZRZCOxWT0OhZjWhxDuT3G55syUAHSF2ICY/molwLA0RFftwTEOY5DZ
    vg1rRhzPDm2Yibh8HWbghC4+BGr6CwebgdS5VlYpB58QAw8wmG5zI94Pi9k6Zwc8qPqzi4
    pLEXAvi5grHrQtpdHqLnZkW8cxNCm4EgsEziTB0bvXmJoMSqnaJDLH4LM2KDB4EHumeg05
    Oe+IYAPb9sqnI6CCz8ZB7kaLsW4wP+oI0J46P6EySsDJt/Gtpr2OyCnJpRuQ
X-ME-Proxy: <xmx:OuOFalKbWCWCI4ZXnZ6o2x7NBHXHelXnP4ynvixvbIEXdrgu7mryRA>
    <xmx:OuOFagQJaZaqTXceo5AM0IZ8hNjlHfdFY2va7llJmUBU9sg0iUsbxA>
    <xmx:OuOFaiuBACucNMmEX4x_pO3FXL942oTmUfqnR8DAtclVKO7yjC8cgw>
    <xmx:OuOFal-067q4FSkBuyRRGIfsvMUFjGtdxbPfuJaiDhQe6psxBq8www>
    <xmx:O-OFas-OgkCIQ2NKZkmWqu2BlJxVNaFGk9Y2qaKYd5zBQIs3fM20His3>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 19 Aug 2026 13:09:13 -0400 (EDT)
Date: Wed, 19 Aug 2026 18:09:12 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, ljs@kernel.org, nico.pache@linux.dev, 
	baolin.wang@linux.alibaba.com, baohua@kernel.org, dev.jain@arm.com, hughd@google.com, 
	lance.yang@linux.dev, liam@infradead.org, mhocko@suse.com, rppt@kernel.org, 
	ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com, usama.arif@linux.dev, 
	vbabka@kernel.org, ziy@nvidia.com, usama.anjum@arm.com, agordeev@linux.ibm.com, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	jannh@google.com, willy@infradead.org, pfalcato@suse.de, rostedt@goodmis.org, 
	mhiramat@kernel.org, linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [RFC PATCH 00/57] mm/collapse: rebuild collapse on migration
 primitives
Message-ID: <aoXRi3ngBhO54Akk@thinkstation>
References: <20260816224609.308019-1-kirill@shutemov.name>
 <9f51ac27-24b2-495b-b397-84865f977d24@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9f51ac27-24b2-495b-b397-84865f977d24@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5FAD114000C
X-Stat-Signature: mtmjiqopwwbq9xbpgph56dxkdhumxunr
X-Rspam-User: 
X-HE-Tag: 1787159356-879170
X-HE-Meta: U2FsdGVkX19Fe0F5Rli3n9cWCTO8pumz3zBZff1bja3q1Ck6VO4Ny/J2318dXW7dWwUhbcCOiFS7L/8qH/rx5+J/H49oVWLpa6Ws1XUnFMGsknxUVu0+0IuDhahp/imAPmK3j+w7GZU1t8N5VEWEdUCSO8kuRwMEThf7m/n8S/QXSxvsEMdP5AHiDr72joY5YCTrRUY0FXLnaFN3pTv1d3AAHU8VUbsnRUeUcxzi3EQOVL0z5oVawooFwrr197ALE8pvWfpVtYihlv8K74a1oyeHlQB2fqGLEoRDCbMI0TXaWKcztXGDIn2Cop1dY0R32MNeB7AvkAdOdN+h52iojIofeevUjrQo96Kl30ekuoLoGfWfs1sH1giGOSZoGWstW9xPC0idiSoN2Yya5JNbvCvctx1fJ6vXvfKOR+h0JB321e7K+Lz6ku+s2nQGq3uXHPZE+EoyP8P0gPr/orQNSkO5o/eT9eTSx5n9er8h5eHTFmXIOvyJbxH12HkKxkfAZ/tds1SAiVqbOLAwi4rgn5vmWsAuYqEbYUfAs/YhjfFKy+2q3jFQZ8pwcsjjkZxYkVPgkyINOR0mr+HTO7WzAcjuD4+i8d0RuFkhGuljVX3SzLAdqZHGNs/6YVQhXgq9pFsu+AT2fwCzcsypflg8sH2AthY49C7k32IOgmBAJuQo8sb57J2uYSAQZO0T9MEusANPq1YN/DfBTDocLWerLzWdJSAI3HaB75Yrt0qQDApdNdA8eAErsoYqaQYfNldfG43CZXj0zn/6dJwELEPpPFu+7jAFkALDLcfERLuinKgWiGk4jL6ObLIzP44myPZrm3UQVjxg7T9XggRvwdoJpzBjh8FPToYZnaiEOVEQhkGToaOnKGD+Qa/qX1/h+yA4aYQWFWIqgloJTjO5lAbOO+ZjPBEazldRrZzCNt6+w5IHV8xO88qtBWiGFmWpl4tXS6cWuz03JgsmgsoD0JQ
 E2Yzyaaf
 rUBCHBOHGgf5mWzwhHQuKWyrgHeeWAY7MNHcRs8sXsKHJXR7MCt4vayGaemoK7IehSMlmEiu6rqPYXNBXxG8seh2BwJt4bZge4BRzHnyTm5CZ40NLVAO8gFfO9aUEhDf8KLd6MQneWfKjSdRzc9nuKjtLdzHEsKdhXsjmu3k8VAFlsblcFVn/41h6H+CcNSyXhtMbJPGPymLQmnbaGn+EbGrB2nLGYwsXxNV/XZTbKBpUkdas8SFLzPv0RT1E1x1ZIPGxLqM61g5HTwivZ3GjUGahA3kV+ov8JpEQOgiWaGeWMUQRZSqsVOAx1Rn76cd0+zELo9N5Nv1jdowSORC3I+xCwCj2+81GW6GjmSGm6KUalQMI45d91hWIjXbWEA1A45Jo2qwRnmKL88mLBs6y4ZcxpQyUv1576hi/V2qaR4U7UWHBHvW+qttRRWwJvR12PBIC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 03:55:55PM +0200, David Hildenbrand (Arm) wrote:
> > This replaces khugepaged's anonymous collapse with an engine that
> > can collapse sub-PMD ranges. It is built around migration entries and
> > frozen folios instead of heavy locking and isolation, aiming for better
> > scalability and less disruption to the workload being collapsed.
> 
> I recall us discussing something around using some PTE/PMD markers (e.g.,
> migration entries) in the past.
> 
> One thing that needed care is handling concurrent MADV_DONTNEED + faultin after
> dropping relevant locks.

Handled at install time.

I drop the PTL after the freeze to allow allocation and copy, but sample
the PTE values (see saved_ptes) at freeze time. If something changed
under us by the time we install the new page table entries, we give up
on that candidate and roll it back; the rest of the round still
installs. We allow harmless transitions: zero page to none.

> > Which is why hugepage_vma_revalidate() demands that the VMA span the
> > whole PMD even for an mTHP order -- "we'd need to lock all VMAs in the
> > PMD range to support this", as the comment there puts it.  A PMD-granular
> > operation is only safe when one VMA owns the PMD, and that is exactly the
> > restriction in the way.  The alignment is the symptom; the PMD is the
> > design.
> 
> I disagree with "A PMD-granular operation is only safe when one VMA owns the
> PMD". It's safe when all page table walkers can be stopped (see above).

Fair, the sentence is too strong.  mmap_write_lock plus a VMA write lock on
every VMA the PMD covers, plus their rmap locks, would make it safe.

But the mechanism still clears the whole PMD, flushes, IPIs and
repopulates it to collapse each 16-page window. That's very noisy to the
workload.

And I am not sure how to deal with rmap locking here.  Nothing in mm
holds two unrelated anon_vma rwsems: vma_prepare() takes one for both VMAs
it touches, because a merge requires them to share the anon_vma, and
anon_vma_clone() takes one because "all anon_vma's share the same root".
The lock ordering in mm/rmap.c has a single anon_vma->rwsem level, so a PMD
spanning unrelated mappings would need an ordering rule that does not exist
today.

> > Between the two, nothing can reach a source, so the copy runs with no
> > lock held at all -- and the address space is left alone while it does.
> 
> Right. Concurrent MADV_DONTNEED can zap migration PTEs and other faults even
> re-fault fresh anon folios. So that must be detected before replacing migration
> entries again I guess.

Yes, that is the install-time check above.

The copy itself is safe: a zap of a migration entry only clears the slot
and adjusts rss -- see zap_nonpresent_ptes(), which neither puts the
folio nor drops its rmap -- so a frozen, locked source cannot go away
under the copy.

The rollback does the rest: it leaves a foreign slot as found and drops
the rmap the freeze kept, which is the half of the teardown the zapper
could not do.

> 
> > 
> > What that removes from every collapse path:
> > 
> >   mmap_write_lock              -> mmap_read
> >   anon_vma_lock_write()        -> nothing: an rmap walk needs the folio
> >                                   locked, and the engine holds that lock
> >                                   from freeze to putback
> >   tlb_remove_table_sync_one()  -> nothing: one ranged flush per round
> >   LRU isolation                -> nothing: sources are inert in place
> > 
> 
> Not sure how you handle PMD collapse. I recall problems with migration entries
> on the PMD level for non-folio things (we discussed something along these lines
> also in the past).

There are no PMD-level migration entries here.

The freeze is always at PTE level, so the pmd keeps pointing at the
table until the last step, and the PMD leaf goes in as the terminal
layer: verify, pmdp_collapse_flush(), deposit a fresh table, set the
leaf, all in one section under the pmd lock with the pte ptl nested
inside.

A pmd-level walker sees the old table or the leaf and never pmd_none,
and faults stay held at pte level by the migration entries throughout,
which is what lets PMD collapse run under a VMA read lock like
everything else.

> 
> > Working in windows rather than whole PMDs takes care of the other root.
> > A sub-PMD window is collapsed under the page table lock, so a collapse
> > disturbs only the window it collapses, and each candidate is validated
> 
> I recall us discussing that holding the PT lock for a longer collapse operation
> (especially on 64k) is problematic. But I don't get all the details from your
> description here.

As I mentioned above, we drop the ptl after the freeze. And take it a
second time for the install.  Allocation and the copy run in between with
no lock held -- on 64K the copy at PMD order is 512M of it, which is why
it cannot sit under either lock.

> 
> > at its own order -- a window need only fit its own VMA.  A PMD-order
> > candidate still has to own the whole PMD, which is the old rule kept
> > where it is still needed.
> > 
> > Candidates are carried through the passes a batch at a time rather than
> > one window at a time, so a round pays for its flush and its lock
> > acquisitions once.
> 
> Now I am starting to feel that there are too many changes packed in a single
> series :)

Batching is not an extra here, it is the only way collapse works at mTHP
sizes.  What a round pays once -- lru_add_drain(), the mmu_notifier
invalidate window, the two ptl acquisitions and the TLB flush -- would
otherwise be paid per collapse.  A 2M PMD is 32 collapses at order-4, and
a gigabyte collapsed into 64K mTHP is 16384 of them: the serialization
would dominate, and the workload would feel every one.

> > Reading the series
> > ==================
> > 
> > 57 patches is a lot to land on a list.  They go in blocks:
> > 
> >   1-6    helpers and shared state: pte_folio(), pte_none_or_zero(),
> >          mm/collapse.h, and the policy that replaces asking whether
> >          khugepaged started a collapse
> >   7-8    the engine's shape: entry points, a call-tree comment naming
> >          every pass, and the scan filled in
> >   9-23   the collapse half, top down: the round frame, then each pass
> >          in turn, then selection and the retry store
> 
> I fail to parse this sentence.

Bad wording.  The engine is introduced in a top-down manner:

  - patch 7 adds the external interface and a comment naming every pass
  - 8 the scan
  - 9-11 how candidates become a round and which passes the round has
  - 12-21 fill in one pass per patch in the order they run
  - 22-23 add the cursor that picks the windows and the second chance
    for the refused ones.

I'll spell that out in the next iteration.

> > So I wrote "perf bench mem usemem" for this.  It touches a region while
> > khugepaged works on it and reports the workload's own latency
> > percentiles and throughput, against per-size counters that can see
> > sub-PMD folios.  The branch is above; it is unposted and not a
> > dependency.
> 
> Something more realistic might be running some workload in a VM whereby the VM
> is getting collapsed by khugepaged.

Fair, I'll run that: a guest touching its memory while the host collapses
the backing mapping, measured from inside the guest.

> 
> [...]
> 
> > There may be a way out -- a PMD migration entry over the table during
> > the window, so the CPU never caches a walk to shoot down -- but that
> > means teaching every pmd-level walker a new kind of entry, and I have
> > not tried it.
> 
> I think we discussed that in the past and it's absolutely nasty.

Let's leave this for now. I will give it a try when it gets its turn.

> 
> [...]
> 
> > Size
> > ====
> > 
> > mm/ grows by 1915 lines net: 4475 added against 2560 deleted.
> > 
> That's quite a lot for something that reads like a cleanup at first.

About half of that is comments. :)

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

