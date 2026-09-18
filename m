Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF214C982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 12:14:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C87A16B0092; Fri, 18 Sep 2026 08:14:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C126A6B0093; Fri, 18 Sep 2026 08:14:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFFDF6B009E; Fri, 18 Sep 2026 08:14:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8EC066B0092
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:14:23 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A71CC1A0636
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 12:14:22 +0000 (UTC)
X-FDA: 85226775564.04.124A71A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id A3A11180009
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 12:14:20 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VLouqUR6;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789733660;
	b=J3Bt+49PEjpMXaVvjbI7TO2UiyGmoOT4UYuogocUzlKBV/8w5Xee+DremLi553jZdsomRS
	j8x+f+Zgtca+Ls1ugw6bLTcrBQnCTuMWTfvEPG4s6fQJN5dFdt78f8KUXK/FV6h2pV5ht1
	GsDftROSG04uqMWwIm89IzSLC4GKHEo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VLouqUR6;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789733660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LDkqCMSPvMO2LfbIEM1B2j2kfABaQmmAyskL3eqNU7Q=;
	b=Vzb3nURQFc3661eNY7WlOB1WlkmucieovMRs7H0H9eni2m2B0/okv5SRL3w6X+dWFbS5WC
	GAtJLWnHQjD9brP4RcEEwJNC+Qn6fkC2s3H4RFg51TfH2gZIEiid/RlIivGl5pNSWYxt5s
	c66gqqLj/KywtaRtYlilWCBd4oQQhG8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D4202418B8;
	Fri, 18 Sep 2026 12:14:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6A891F000FF;
	Fri, 18 Sep 2026 12:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789733659;
	bh=LDkqCMSPvMO2LfbIEM1B2j2kfABaQmmAyskL3eqNU7Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=VLouqUR6gfx9icyXJBo4LjZ6iZlDqmiQDr3vxu36bF4NJ/8Iq1dVf2kn2uk0WCnUD
	 bKyOpjQxAsy1MfR8CyolNrGLaOmfyopVj7OAI3CbX5kRQgqr4YPMWajP+aUMYcBSUZ
	 YF6hOUSnmwAS5yaB+0h8g5nYBil0pkQq/DINfM+4e+zS0Qnld5RWhN4egQh1vs4l+8
	 5JMqphBBfNZO/pqKJ00cB9ARIYFw3zw/FNW7A3jPIx9T+Fw5bkCoxTthZCy3jRkWXw
	 GA4DuLqGLdclOIjytELUxeijcCLwNm+WJsW+JjXkFAhoO4oKVvuYrugPmYBmanyEw9
	 +M/VcwTG4GlTA==
Message-ID: <b1ba175c-ceb2-4e00-b233-d51dd8a2f4cb@kernel.org>
Date: Fri, 18 Sep 2026 14:14:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory: reuse the whole exclusive large folio on a
 write fault
To: Yuan-Hao Hsu <aa9736195201@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, liam@infradead.org,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Barry Song <baohua@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260918064238.868-1-aa9736195201@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260918064238.868-1-aa9736195201@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A3A11180009
X-Rspam-User: 
X-Stat-Signature: bo4dnn7snnru3eadcuki8bu4fgecat6e
X-HE-Tag: 1789733660-812348
X-HE-Meta: U2FsdGVkX19AaM4J67g9BJuF0xq4lwgdnFWFikV/3wB4QTDNnHMEU4Ybj06rJvkJ0eKKqRS+dR+eKmw01q1tbCu8CF8TDWTUv6R/j657RveOQB0XcWeJ3DMfOGdUNibngDjqGg6LYzf4qORmqTSwqYXg2Cy316DSxHMe8STigVrTDxPwI+mVZJkh9SZVbTuxAPOnGocdnL7SEnaQepMIEK6vJDR0VSsvqtZEKXIBOX1fjriprhI9Q/KpepKhvpkJYkWzwq3So09Jjn6AsO+BwTn+lIrXDYLZSvh7ocDjdUPDbtGioKqnOwiYixHTbb05f+DQLN/ZP3i8zGys1IfbCtSobZkHe4ARzgkVJTATfcxv7vxcr5Xm5NOrpEnzbfzlZ/yn3A+LQnIEifexmKnzTGoL4MajXU3SOKm74bubfZgtszmJbpkuPiWkTWG2yK6W7Oi1KwSCWOugnRRJn17g/KVeey7r2cBQ6PtfKfEemtdQEQkI9P5gMdj4KPdtRvvJFoRBfNkqC2CB4x509Ew7WN2GGOrWgTCsRurnT3mhUEILYhxk0xhshwiGvvpyo5N0qJU7tWXNIjtCgtQV/cvQViOofDSv1VvN4Y/X5Mxm+y37+rUHtgWbPcbTKZzRL0p03g5n85lAUI/icolUqoWRl9gngKDcPlhSn2KZ9tbcLv8IqMGLPgGkkRWQC1mIvJvCLt5ytr08Yy5pMHA8WffxO+4eHtGrSgF98r+MV3Qkl4HUVQ6AcgukIXli5r8uxs9zHzc3k0Ur/gm8aCwBbM9Py+9mwtVbTeBXpngbmHZEBMyyLT0DHVOahZ1uaAwYHsWCPtwtq7/wSmqq1PPuRx7IyO8stbGau899Zh4b7/8Fw4dzc7p3i+ZWLdrFUFj36wRPJHns+4Ygsv6hSGaLS/EROdUf/s6Pc7TSyE0U0owTGhOIIZIkb6b8IcRusJsvCiEwpinfhYROHTzO2tydpbV
 aQoZR0x5
 4L4Gz2Rks1OiGzeMxuzJrYu5A9u0T/8k2Areqo/wa0hRe5Zp0Lvo30gZngAPBe2bKcIKDdqQFZwcKqsUxvfksC19bat1SR538xQYfIVFsJcyIrKZpEfDfDEAD8ChXAukbSGzCBbBG9ejy6poq5AYL/9klvyQXO2fk1TLR9ApxQVxkyjDz5gMV+j0O0kNPJ+4bCGrh5fbyB/4RYTUG3LOT5w8drQcDeD4kzEo8D/pIiRehmvYGM/JvXaUSWSJ2YtHdRhWbdQe2vJpNbuQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/18/26 08:42, Yuan-Hao Hsu wrote:
> fork() maps the anonymous pages of the parent read-only and clears
> PageAnonExclusive on them.  Once the child has exec'ed or exited, a
> write fault of the parent ends up in the reuse path of do_wp_page():
> wp_can_reuse_anon_folio() finds that all references to the folio come
> from mappings in this MM, the page is marked exclusive again and its PTE
> is made writable.
> 
> For a large folio that check is about the folio, and what it finds holds
> for every page of it.  Still only the page that faulted is marked
> exclusive and only its PTE becomes writable, so each of the other pages
> takes a write fault of its own, and each of those takes the large
> mapcount lock to find out the same thing again: 16 faults for a 64K
> folio, 512 for a 2M THP that is mapped by PTEs.  The same THP mapped by
> a PMD is reused by one fault in do_huge_pmd_wp_page(), do_swap_page()
> maps all PTEs of an exclusive large folio writable at once, and
> numa_rebuild_large_mapping() upgrades all PTEs of the folio from one
> hinting fault.
> 
> Commit 1da190f4d0a6 ("mm: Copy-on-Write (COW) reuse support for
> PTE-mapped THP") left this for later because faulting around might
> increase the COW latency.  Numbers for that are below.
> 
> When a large folio has been found exclusive, walk the part of it that
> this page table maps inside the VMA.  PTEs that still map it read-only
> are batched with folio_pte_batch_flags(), their pages are marked
> exclusive, and where can_change_pte_writable() agrees the batch is made
> writable with modify_prot_start_ptes()/modify_prot_commit_ptes(), the
> way mprotect() does it.  That leaves NUMA hinting and uffd-wp PTEs
> alone, keeps soft-dirty tracking exact, and on arm64 writes a contpte
> block back as a whole where ptep_set_access_flags() on a single PTE has
> to unfold it.  Pages that cannot be made writable are marked exclusive
> all the same, so their own fault skips the folio check.  The PTE that
> faulted is in one of the batches and is then completed by
> wp_page_reuse() as before.  Small folios, PMD-mapped THPs, unsharing
> faults and the copy path are not changed.
> 
> x86-64, i7-12700KF, 256 MiB of anonymous memory, fork(), the child
> exits, then the parent stores to the memory.  Medians of 15 runs, two
> boots of each kernel, taken alternately:
> 
>                           v7.3-rc3+           patched
>   one byte per page, a clock_gettime() between the stores
>     write faults
>       4K pages            65,601              65,601
>       64K mTHP            65,601               4,161
>       1M mTHP             65,601                 321
>       2M THP, PTE-mapped  65,601                 193
>       2M THP, PMD-mapped     193                 193
>     time (ms)
>       4K pages            29.7 / 30.1         30.0 / 31.1
>       64K mTHP            29.4 / 29.7          5.5 /  5.6
>       1M mTHP             29.3 / 29.8          3.9 /  3.9
>       2M THP, PTE-mapped  29.9 / 29.2          3.8 /  3.9
>       2M THP, PMD-mapped   2.5 /  2.5          2.5 /  2.6
>   memset() of all of it (ms)
>       4K pages            57.2 / 56.5         56.9 / 57.1
>       64K mTHP            56.5 / 56.3         39.0 / 38.7
>       2M THP, PTE-mapped  58.6 / 56.5         36.8 / 37.7
>       2M THP, PMD-mapped  37.5 / 35.9         35.9 / 36.5
>   8 threads, one byte per page, random order (ms)
>       64K mTHP             6.1 /  6.2          0.9 /  1.0
>       2M THP, PTE-mapped   6.0 /  6.7          0.7 /  0.7
> 
> The latency of the one fault that now does the work for the folio,
> measured as the time of the store that takes it, against 420 ns for a
> reuse fault today (medians, ns):
> 
>                           reuse fault   fault that     COW fault that
>                           (patched)     allocated it   copies 4K
>       64K mTHP                   730          4,600          1,500
>       1M mTHP                  5,500         63,000          1,500
>       2M THP, PTE-mapped      10,100        126,000          1,500
> 
> That is 14 to 20 ns per PTE.  Builds that differ only by NOPs in front
> of the new function take either 10,100 or 7,500 ns for the 2M folio,
> with a period of 32 bytes: it is the loop of modify_prot_commit_ptes()
> that changes speed with its address.
> 
> Capping the walk to the 16 PTEs around the fault instead was measured as
> well: it takes 5.4 ms where the above takes 3.9 ms on 1M and 2M folios,
> it is slower than today when only one page per 64K is written (3.1 ms
> against 1.9 ms, the whole folio takes 1.5 ms), and it is only ahead when
> no more than one page per 2M is ever written (0.1 ms against 1.3 ms for
> the 256 MiB).
> 
> Redis 7.0.15 with 1.3 M keys of 512 bytes on 64K mTHP, BGSAVE and then
> 1,000,000 SETs: the faults of redis-server during the SETs go from
> 262,100 to 18,500, its CPU time from 1.48-1.53 s to 1.25-1.33 s, and
> redis-benchmark reports 742,000 to 794,000 requests per second instead
> of 652,000 to 658,000.  With THP off all three stay where they were.
> 
> arm64 was only run under QEMU, for the counters and with DEBUG_VM and
> PAGE_TABLE_CHECK: the faults are the same as above, and with 64K folios
> the first pass after fork() unfolds every contpte block today (512
> contpte_convert() calls for 512 blocks, and nothing folds them again)
> while none is unfolded with this patch.
> 
> What does not get faster on x86 are stores to pages that this CPU still
> has a read-only TLB entry for.  The fault makes the PTEs writable but,
> like mprotect(), does not flush, so such a page still takes a fault, a
> spurious one that costs about the same as the reuse fault it replaces.
> That happens to pages that were read since fork(): reading the 16 pages
> of every 64K folio before storing to them takes 65,500 faults and 28 ms
> before and after.  And it happens in a loop that does nothing but store
> one byte to every page in ascending order, which is what the reuse-byte
> mode of David's pte-mapped-folio-benchmarks does (120 ms before and
> after for 1 GiB of 64K folios; 2M folios: 119 ms to 18 ms; the reuse
> mode, a memset(), goes from 232 ms to 157 ms with 64K folios): while the
> first store of a folio is faulting, the CPU has already run the next
> stores speculatively and has filled the TLB with the read-only
> translations of their pages.  Counting with kprobes, such a run enters
> handle_mm_fault() 135,687 times and do_wp_page() 8,457 times; with an
> LFENCE after every store the faults are 4,100 instead of 65,400 and the
> loop takes 4 ms instead of 29 ms.  The PMD-mapped case, which this patch
> does not touch, shows the same: 8,800 faults for 128 THPs, 133 with the
> LFENCE.
> 
> With a flush_tlb_local() in the new function, as an experiment, the
> ascending loop takes 4.1 ms instead of 28 ms on 64K folios, the
> read-then-store loop 5.3 ms instead of 28 ms and the memset() 21 ms
> instead of 38 ms, for a fault of 870 instead of 730 ns and 11% more time
> for the pass with the clock_gettime().  Generic code has no way to ask
> x86 for a flush that stays on this CPU, so that is left for later.
> 
> Assisted-by: LLM sparse


My review backlog is large enough for me to just go through this wall of text.

There were previous discussions on this, in particular around how much we should
actually try operating around the target PTE.

How did you use the LLM for coming up with this patch + description?

-- 
Cheers,

David

