Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6BE2C61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 09:32:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA88B6B0088; Mon, 31 Aug 2026 05:32:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D58CF6B008A; Mon, 31 Aug 2026 05:32:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C499F6B0092; Mon, 31 Aug 2026 05:32:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9A0FA6B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 05:32:17 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1817C140452
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:32:17 +0000 (UTC)
X-FDA: 85161048714.22.7917610
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 86A02100005
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:32:15 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xig1g49z;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788168735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=euqTSNGwMLeVIsy5IBLSW/MZeSbW0il4O6HdzwmdZ9w=;
	b=ISb1fzt8ryvwq+W0VnrECz2Rg8o1eXI2ziXGwNmjYrbYZHIYHSnx/HpM0ekmdyLhYcwoVd
	Wy9f1sFzqgbmYfklb1TAmS3Nex5D2BoY1N4cPV9K+Cr+oSEvpE4TAu7ofSlQWnGEm9il47
	NTQe/BxMocSQkWjOMTk8SrWIXauh6uw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788168735;
	b=SVCwWWIePod7dVgwfTgIowdtDDXQFevgf4ZXcHnlQdfDEFkfLcc/UG8pQXQkg5GRBlOVe2
	ppcvGcEPlvFPlqVoyHP1AKYP2TB5NtAzdZSVjigZaBufLuiphelVIE+RWXOt2vnUVJJdSB
	RzK+MAToCdS65UfqlWSUpPl8nDOVh48=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xig1g49z;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B4D11601DE;
	Mon, 31 Aug 2026 09:32:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97BDE1F000E9;
	Mon, 31 Aug 2026 09:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788168734;
	bh=euqTSNGwMLeVIsy5IBLSW/MZeSbW0il4O6HdzwmdZ9w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Xig1g49zAdFmH+py+LTl0098SpJ4/QBDaNBu2ICqhaHxl/3VEkWjLLiTiB+UfCVr3
	 cEaIKbjHiDSkpsUfdSURZ/vMLwrpKT/K2Bk4sED1fznHNqN/BthRUd7JtScEzN+mqB
	 c6SeoHbidpQrFx6uJMH7G9U9RcH4lXtURcZFuU0Zc/SdJtp1eQPL+Y9q2rBBTausx5
	 BwSjhEG8wuLI5Abxj12tcIeO4g3TjaYp3b8KYs3zsgn2VAAbOtPuXrES85rNVRDpW/
	 Q9dWyBa8bDU+MVTtX3bk9B8riCel/F43ZS5wKVRQbzQRDp1zoKJXpPA568+Z+QrMON
	 KKM4GffEW7hyA==
Date: Mon, 31 Aug 2026 10:32:06 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>, 
	willy@infradead.org, akpm@linux-foundation.org, david@kernel.org, harry@kernel.org, 
	jannh@google.com, lance.yang@linux.dev, liam@infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.com, riel@surriel.com, 
	rppt@kernel.org, surenb@google.com, 
	syzbot+395b7abe9696862fc188@syzkaller.appspotmail.com, vbabka@kernel.org
Subject: Re: [PATCH] mm: fix the race on huge alloc failed
Message-ID: <apVDMw0d0Y8OZYl0@gremlin>
References: <apOkscUtVMpFqFjM@casper.infradead.org>
 <20260830124756.457887-1-trintaeoitogc@gmail.com>
 <apQxGMgLWWlfn3cd@pedro-suse.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apQxGMgLWWlfn3cd@pedro-suse.lan>
X-Stat-Signature: dncmp8ehk5ojqwtmp9tuq9gjbjozbje8
X-Rspamd-Queue-Id: 86A02100005
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788168735-672810
X-HE-Meta: U2FsdGVkX18gpFsMf2LlK6m6Vx2qdCpI3sqzx/1/lvszeCswzPdiLnkb6xOAO5ERcAbBcFBmRq2Cicm+1RyFVHLCYo0FfRZuweqDLwxUA9bWi9+WrYYGsYRjWjWoaP5P1xTPSWlhdQqF/zqx6iGEEzt4VCqNfvnhs9/ji2/AvulH/W5BMCxytJnYDAusqSoUwt4TN5MCf0aRCVnai38CLcIssYOcjCxdv0nba9zh8npYFZYO8FkJ1IZ+bPNk0V51hlF13dRbh6AR1J1cESNwknhnWJ69Z0HsLz1m9bho3HscRQnY8pCHuTRVyD6aaCGE7wWca4RmF6LL0z3U6ppqdbfb1Wm8PzUPXbWiFXBEzbXy4Z/xX46KMIdljqOu1/BTy/FszY/pTZpQsuFYY08uBScpt38xFie2m9Gut9wt768Q/ZPY9YFMXGJ097BrIzEXuX6Qq93UmCMn9TLvtLOf7xkueIuQ8l43xbSm0qdO+sFZP//4HS+AMOL0ptNicqgfIU5aP0TG18ZTgXKc9nwuWVeHp/KID7J5LMNenMVuqFNQFt2XsH5/t+n5qPKUppoXkdF3A8CrNUXPapNV/RPIJFL3C1ib0aib7+OWERb3bF2h+3vSVdyR/RfE5EHClM2H50idRR2is+2HfqWHmY3LfdOJi+GCUfDzRaCtf/i2l3OPMsLpenQP2c6RIj+N55Bz4d+FObIIlnLi7KeleLPPw6ylJI8vmmYJaRXji/gystbOL4gTEwd/gDIUYULZky0FtzVwv2CYnpLXhtg0TaU4QTBxCHvY74850H6KrZVvrSd6H6zGTV5GX41y6SRNLB5V26cG45MBeurdLW57FI4BJem6+OvA05uUz1z0snydgKp/S4RWseZ+Ci0lpTLpKOw11vlXbgI7Gtnk0lkzt8MrmQ02IlKbEtiC8lQ+fVs/qb9io66fTh3gMmUg0xX1hHWXpELqq6uytTgB2XyKpWC
 9DLcpy6w
 /kw/qO3RC+ylaihjlO1ni+CWem+F3oULecNU7/bkqyzzVQDND9c2HLIxGDCcDF91xWGydWqLqGpC8hiVzBaXJ9C0IGbmHqKPxphjZH6FAvbUiVKtFe/xCRODflfmEGt1s+D/eFCRya5Wiv/yTZgLnMg9HjKIPinNhkwJROTD82U/C6uqhCQsOhbdGIrYjEIIJJOB3LU/uJlVNLSD0QALkS4oSPymuvo00x7MZEnEwm1eQRm0M7Vdt2EsPPGlwb8B7P8snjsHJ/dq9vFL2+i9++wXaWy90urUXqnPRuEjjHvSmpigBJABDJ2Q7v58pD+IhFl/kp3W0XfBfWerq4dU0WVHgCsTc2Fy3/m22XzB59eQnX/OvW1r8EeJCtn4a4YXBWvM6urAamgxhX84cdhlCA4fRcshribZ0ZNDebdODKGjtFnLMIcgLaGuM/Z0o9B9JKzgTZiYgY1r0fAbdCCf4LovaQV9jvj/35WQLS7VRJlv9SH3/q+0lVYfCFg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 30, 2026 at 03:07:25PM +0100, Pedro Falcato wrote:
> On Sun, Aug 30, 2026 at 09:47:56AM -0300, Guilherme Giacomo Simoes wrote:
> > Matthew Wilcox <willy@infradead.org> wrotes:
> > > The important thing to know is that the mmap_lock is a read-write lock.
> > > That means that two readers can be present at the same time.  So this race
> > > can happen when both threads hold the mmap_lock.  I don't know whether
> > > they do in the syzbot reproducer; probably not, but it doesn't matter.
> > >
> > > The other important thing is that _we don't care_ what the value of
> > > vma->anon_vma is.  We only care whether it's NULL or not (this is a
> > > sufficiently common case that I wonder whether KCSAN shouldn't special-case
> > > it and decline to monitor it ...)  VMAs are created with a NULL anon_vma,
> > > and then if needed, anon_vma is set.  Once set, it is never changed (uhh
>
> I believe it can be changed (IIRC on a mremap dontunmap edge case??), but
> that needs the write lock anyway.

Yep in dontunmap_complete() if a source VMA is left in place due to
MREMAP_DONTUNMAP being set (which has caused some fun lately), but that does
require a VMA write lock.
>
> > > ... at least I don't think it is.  Lorenzo, could you check me on this?

As above :>)

> > > I think all the places where we set vma->anon_vma to NULL are in
> > > situations where the VMA is not yet exposed to the page fault handler,
> > > like in the child side of fork()).
> > But if I have a write in the same time, this can be a problem, even though if
> > you only want to know if vma->anon_vma is NULL or not.

The forking logic holds the write lock anyway.

> >
> > >
> > > So it's inappropriate to use READ_ONCE() / WRITE_ONCE() to "solve"
> > > this problem, because we don't need those semantics.  It's sufficient
> > > to wrap the read side in data_race() to indicate to KCSAN that we know
> > > what we're doing.
> > you sure?
> >
> > the __anon_vma_prepare(..) is write on vma->anon_vma and the
> > __vmf_anon_prepare(..) is reade from the same vma->anon_vma at the same time,
> > you sure that is not a problem? (I'm asking as a curious layperson.)

Yup, page_table_lock is taken explicitly to serialise this. See
https://docs.kernel.org/mm/process_addrs.html

>
> 99.9% sure. Here's the basic logic laid out:
>
> 1) Fault needs to fault in anonymous pages
> 2) Fault needs to possibly create an anon_vma
>  2a) Thus it does the lockless check, where indeed we only
>      care if it's non-null or not.
>  2b) if the lockless check fails, we get into __anon_vma_prepare()
>      logic, which crucially takes the page_table_lock to write the
>      anon_vma to the vma. If it takes the lock and something is already
>      there, it backs out.

Yes.

> 3) Now, into the weeds of anon page faulting, we end up in __folio_set_anon(),
>    which reads the anon_vma from vma. This function always (AFAIK?) runs with
>    the PTE lock held. Thus we can be sure the anon_vma value is correct. In

Confirmed (manually, probably should have got an LLM to do it ;):

All hold PTL:

Huge TLB (yuck) cases with 'huge' PTL:

copy_hugetlb_page_range()
  -> hugetlb_install_folio()
   -> hugetlb_add_new_anon_rmap()
     -> __folio_set_anon()
hugetlb_wp()
  -> hugetlb_add_new_anon_rmap()
    -> __folio_set_anon()
hugetlb_no_page()
  -> hugetlb_add_new_anon_rmap()
    -> __folio_set_anon()
hugetlb_mfill_atomic_pte()
  -> hugetlb_add_new_anon_rmap()
    -> __folio_set_anon()

THP using the PMD PTL:

__do_huge_pmd_anonymous_page()
  -> map_anon_folio_pmd_pf()
    -> map_anon_folio_pmd_nopf()
      -> folio_add_new_anon_rmap()
        -> __folio_set_anon()
do_huge_zero_wp_pmd()
  -> map_anon_folio_pmd_pf()
    -> map_anon_folio_pmd_nopf()
      -> folio_add_new_anon_rmap()
        -> __folio_set_anon()
collapse_huge_page()
  -> map_anon_folio_pmd_nopf()
    -> folio_add_new_anon_rmap()
      -> __folio_set_anon()

The rest all hold the PTE PTL:

copy_pte_range()
  -> copy_present_ptes()
    -> copy_present_page()
      -> folio_add_new_anon_rmap()
        -> __folio_set_anon()

wp_page_copy()
  -> folio_add_new_anon_rmap()
    -> __folio_set_anon()

do_swap_page()
  -> folio_add_new_anon_rmap()
    -> __folio_set_anon()

do_anonymous_page()
  -> map_anon_folio_pte_pf()
    -> map_anon_folio_pte_nopf()
      -> folio_add_new_anon_rmap()
        -> __folio_set_anon()

collapse_huge_page() [fallback path]
  -> map_anon_folio_pte_nopf()
    -> folio_add_new_anon_rmap()
      -> __folio_set_anon()

filemap_map_pages()
  -> filemap_map_folio_range()
    -> set_pte_range()
      -> folio_add_new_anon_rmap()
        -> __folio_set_anon()

filemap_map_pages()
  -> filemap_map_order0_folio()
    -> set_pte_range()
      -> folio_add_new_anon_rmap()
        -> __folio_set_anon()

finish_fault()
  -> set_pte_range()
    -> folio_add_new_anon_rmap()
      -> __folio_set_anon()

unuse_pte()
  -> folio_add_new_anon_rmap()
    -> __folio_set_anon()

mfill_atomic_install_pte()
  -> folio_add_new_anon_rmap()
    -> __folio_set_anon()

>    any case, we only need to have held the page table lock once in the fault
>    for it to be valid; any change to its value from non-null to null needs
>    the vma/mmap write lock. Because we take a bunch of locks and do a bunch of
>    stuff between that initial check in __vmf_anon_prepare and this, the compiler
>    cannot validly cache the load (which can, in theory, tear).

Yup.

>
> Now, for memory ordering and its wonderful transitive properties:
> 1) writing anon_vma takes the page_table_lock. therefore if you acquire
>    page_table_lock, you obsreve the anon_vma store and all preceding stores
>    (due to spin_unlock providing RELEASE semantics, and spin_lock providing
>    ACQUIRE semantics)
> 2) say you install e.g a PUD entry, you take the page_table_lock. So you fully
>    observe the anon_vma that was installed (by doing an ACQUIRE on the lock).
>    you also issue a smp_wmb() which makes sure the ptdesc setup is visible.
> 3) others using that PUD entry will (should?) transitively observe everything
>    you have observed, data-dependent loads will help you there. If we _ever_
>    observe a page table without seeing an associated anon_vma, it's broken.
>
> [Yes, I spent quite a bit of time thinking through this; it isn't trivial to prove
> that 2->3 transition is correct, but it looks vaguely _handwavely_ correct]

I don't think you'd ever need to know for PUD installation?

In any case you are always serialised through one lock or another with
acquire/release semantics AFAICT so I don't think there's an issue here,
and if there were one we'd have encountered it by now :)

>
> >
> > >
> > > Also, as Lance said, I don't see how this is related to huge_page_alloc
> > > failing.  All I see is two threads calling  __vmf_anon_prepare() at the
> > > same time, which I presume is an attempt to COW a hugetlb page.

Yeah nor odo I.

> > >
> > > I don't think it's enough to just add a data_race() to this one read of
> > > vma->anon_vma.  I think it's quite prevalent.  There's probably other
> > > syzbot reports that mention it.
>
> It sounds to me like the most cromulent solution is simply adding a
>
> /* maybe vma_has_anon? */
> static inline bool vma_has_anon_vma(const struct vm_area_struct *vma)
> {
> 	return data_race(vma->anon_vma);
> }
>
> and churn everything to use it.

I'd prefer vma_is_faulted(). That'll align better with my scalable CoW work
also.

Anyway I agree with Pedro that a data_race() resolution is appropriate here
rather than an unnecessary READ_ONCE()/WRITE_ONCE() pair.

>
> --
> Pedro

--
Cheers, Lorenzo

