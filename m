Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8BCFCD6E4A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 12:34:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD9FF6B0005; Thu,  4 Jun 2026 08:34:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8AE36B0088; Thu,  4 Jun 2026 08:34:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7AD76B008A; Thu,  4 Jun 2026 08:34:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A2F976B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 08:34:13 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 51A801C14B3
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 12:34:13 +0000 (UTC)
X-FDA: 84842172786.18.A58516B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9B02214000C
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 12:34:11 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FmbeSmfP;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780576451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nF1iBW3FnQDK77z6Z/erssj/aJgmx1yuGL+yjDuzS7s=;
	b=NmG+si8hZmhGsSsLctSWS4G+ejvVah6SwoNviGmuOOBsFoLzfVe9H7nfJRIV2r/hW0PMYG
	e9XDE9g1rimXwL2e28I4ZzW/teeA0eUSrfQEUXB1ozQJwT3V4kaSU6Mf16vkZYFDtu6PpB
	yYqixOLMy8rQBOq3KeiNo0Q7gyM3kJ4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780576451;
	b=XksWpaZUrrarS5QGKgPDoHkFedPXqKAStXCKSUem+qPy2YpMhOREPfDmFcp0O+IgfZ9fv1
	Qbi5yNDjljP1JIJzhyS8RQkcatpyBh+lvDmxcnu5fYAchGitGjgRCNdOs/mPaQQq3pG3O9
	XoR9V+lgH/jWT/IsVzTU1sLuqjHerSM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FmbeSmfP;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A1A78408E2;
	Thu,  4 Jun 2026 12:34:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FF3B1F00893;
	Thu,  4 Jun 2026 12:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780576450;
	bh=nF1iBW3FnQDK77z6Z/erssj/aJgmx1yuGL+yjDuzS7s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FmbeSmfP3EK9rBz/hN1P235JwHBuwKRZqChSyPgRQ0akT4zcsHmAOwY8SpA8L/0D0
	 HApsu4hM0YRqD/0/ychCxMQqWguRZdqvZ/uUPIYcdS7cXhn/mN8Ky9ChjKbGkO7J3x
	 1THCiOccp+vQWU94FMtFxgj8o47NEOki/Okk4TzYLtdp0L4lkNQpoMgQrqwmh2a7el
	 sJQPHqQHuyX1tZ8Jy89q3GawXcKUhAJICfbN7f+dTaRca2xtZKd96SQeoeWxu4aJO/
	 oRVa6qNGwkhpV4gK5Fzqkt3zPzqKzqFNFGTejf6zO2tMnDmGTchjiWSFZuMC/KLKFp
	 6menozUfpMnoQ==
Date: Thu, 4 Jun 2026 13:33:55 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>, npache@redhat.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, aarcange@redhat.com, akpm@linux-foundation.org, 
	anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org, 
	corbet@lwn.net, dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net, 
	hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, jackmanb@google.com, 
	jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com, kas@kernel.org, 
	liam@infradead.org, mathieu.desnoyers@efficios.com, matthew.brost@intel.com, 
	mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de, 
	rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org, 
	richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org, rppt@kernel.org, 
	ryan.roberts@arm.com, shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com, 
	thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, 
	vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com, 
	usama.arif@linux.dev
Subject: Re: [PATCH mm-unstable v18 06/14] mm/khugepaged: generalize
 collapse_huge_page for mTHP collapse
Message-ID: <aiFlNd9vr_NJi3Ah@lucifer>
References: <2024af56-5e99-4799-a586-e9ba756cecb9@kernel.org>
 <20260601032804.96122-1-lance.yang@linux.dev>
 <f5d38f64-ab92-496d-afd3-29ccc17fec2b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5d38f64-ab92-496d-afd3-29ccc17fec2b@kernel.org>
X-Rspamd-Queue-Id: 9B02214000C
X-Rspam-User: 
X-Stat-Signature: imnq6itf3hu76bkcr36ikafiqn5dse4b
X-Rspamd-Server: rspam08
X-HE-Tag: 1780576451-872878
X-HE-Meta: U2FsdGVkX18xrtVsUfbPG2hpTBFziX97EkIkm7o+ZxnqHBnOLC4Hy/fqxU6S8wzT3MeJWKj8jY8RqcPRVn5e3kkCCSaha6M5HKjbnRmTfQDlpv/wvXzx3uGfYMFGN4pjYodjY1gAFEv0mYJ8hxWCSL2a0NJost7UKzhcjThQBpWL3PpUvZ2mzdKwCKQZ9xBqAdFhYt+Ssm4HL5HU4XPLi6GIeZ1P2BavJ47KiRRTpc/1Yk3q758g252j2T4gk9uWBMwYC3LJKAQFb8xKYK2hrdt2+pE9mvPYHS+RwWd7ph0EwXMUlexEtPVAqUfsVrD8EXMowPcNcZmGf1nR0K1th4Y5+RIpCkZYkft9cCqhaHPLd796Md9/Su7zvWdaDtGWd49jmkKJzlNWm88EqQ30WVZtk7w6+PywX/rDUu7L9Vy2fh9wTG7TRM6X1ilYKJIlG6msxYtJcM3xEJcf79fg513ZyXK3fUc2RUUVhQqiUvnTuqniXzKYAs0NuIenJJ867OZvbYnj50gh6eKP7m7bTaYu43wXjI9DB8IJmiDpLE4McZI53U4cJSxKyIjO1H8bGU2Tk8aTZoT3zpyiB9O7pQp1vNhmJvrsLVW6R0ghWEWL5lQ4wid1/RxWTmBdSUexY/VwtGtui08itD0vMWf8s+av6CRDwouR9dBJ15hO/VOWIu2PiGOayG4V8ZeyG/W+o6qZhgksDpsqEHrnQZTzuV+Bq6I9G0eg/PTbkw6KIueGB/8+c8nVOqfeIrajVgC982MlLQrlIjs0m7yfrfoP3v1hmst47J5wMnXfli95UeINVLPt13X+OjekpfY5RnfjAz8rn7Y8lvqzmfi7JTING26dVRnkKQKxRgFK+2/BLhrCVn1wJBRimh+Rp/L25OH4vd/5svBx+JlPR9lsgKpm2SzhcyvHMjZ8NP8EJsHGzS/KScO3rpZSuVWqjX4zw/9aZKI5COjtgfH8CCdwWfM
 wEu69sxz
 NVcixpqUqeNX/E/xUhN047wPJk/HhPKDLpnvKcwPijkNRqs1YeuOJ5qARmOrdLlH6N2f4nnvFWwwHxqcntORztXOhuxTAxjleTzabYeoZAEG2EakvF6f8vhxmK6qrLhLpCrSY26KZrhObM1yNQGWmAXP0HSihK4RzpkDgmwhTQvQmEf3GuYLiuTEQW64Lbio8lKPY08aeMJIPjXHHlQoXAIXMRlEOJbRgdphvDpDUvhP7vP6D4u6Bng6/S+Ukdsvzrtn72MnZyiIItxPVOHZh+8bGw8mKkhEBTwDtAE1Fxbvv07ytTy4g/ypnmsynCNHGzNOQn2fF7OEsD2mBfRbxZqEpflxLYb+pmsOkV3hEyE5PmKUhH26bLOI1ww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 01, 2026 at 08:54:24AM +0200, David Hildenbrand (Arm) wrote:
> On 6/1/26 05:28, Lance Yang wrote:
> >
> > On Sun, May 31, 2026 at 10:00:17PM +0200, David Hildenbrand (Arm) wrote:
> >> On 5/31/26 11:39, Lance Yang wrote:
> >>>
> >>>
> >>> Emm ... is it safe to use map_anon_folio_pte_nopf() here?
> >>>
> >>> At this point pmdp_collapse_flush() has cleared the PMD from the page
> >>> tables. The PTE table we are updating is only reachable through the saved
> >>> old PMD value, _pmd, until pmd_populate() below.
> >>>
> >>> map_anon_folio_pte_nopf() does set_ptes() and then calls
> >>> update_mmu_cache_range(). Documentation/core-api/cachetlb.rst describes
> >>> that hook as:
> >>>
> >>> "
> >>> 	At the end of every page fault, this routine is invoked to tell
> >>> 	the architecture specific code that translations now exists
> >>> 	in the software page tables for address space "vma->vm_mm"
> >>> 	at virtual address "address" for "nr" consecutive pages.
> >>> "
> >>>
> >>> But that does not seem true here yet, since the PTE table is not
> >>> reachable from vma->vm_mm when update_mmu_cache_range() is called.
> >>>
> >>> Should we avoid calling update_mmu_cache_range() until after the PTE
> >>> table is reinstalled with pmd_populate()?
> >>
> >> I recall that update_mmu_cache* users mostly care about updating folios flags,
> >> for the folio derived from the PTE ... or flushing caches for the user address.
> >>
> >> So intuitively I would say "the architecture code doesn't care that the PMD
> >> table will only be visible to HW shortly after". The important thing should be
> >> that it will definetly happen, and that nothing else is curently there or can be
> >> there?
> >
> > Ah, fair point.
> >
> > I was mostly worried about arch hooks that walk vma->vm_mm again, rather
> > than only using the pte pointer passed in. For example, mips does:
>
> Right, a re-walk would be the real problem.
>
> >
> >   update_mmu_cache_range()
> >     -> __update_tlb()
> >       -> pgd_offset(vma->vm_mm, address)
> >       -> pte_offset_map(...)
> >
> > and __update_tlb() has this assumption:
> >
> > 		/*
> > 		 * update_mmu_cache() is called between pte_offset_map_lock()
> > 		 * and pte_unmap_unlock(), so we can assume that ptep is not
> > 		 * NULL here: and what should be done below if it were NULL?
> > 		 */
> >
> > So if khugepaged happens to run with current->active_mm == vma->vm_mm
> > here, could __update_tlb() hit the none PMD, get NULL from

I really wish people would say Pxx _entry_ :) so confusing.

> > pte_offset_map(), and then dereference it?
>
> Likely yes -- that MIPS code is horrible. And the comment in MIPS code
> even spells that out. :(
>
> Do you know about other code like that, or is MIPS the only one doing a
> re-walk and crossing fingers?
>
> >
> > Just wanted to raise it since some arch code may still have assumptions
> > like this, and the always-enable-mTHP work is getting closer ...
>
> Right. I assume set_pte_at() couldn't trigger something similar (re-walk) in arch code,
> because we simply provide the ptep. update_mmu_cache_range() only consumes the pte.
>
> >
> > Probably very very very hard to hit, though :)
>
> Delaying update_mmu_cache_range() is nasty, as we'd have to make sure that
> nobody can interfere in the meantime ... and the PMD lock will not be sufficient.
>
> Maybe we could reinstall the page table with the cleared (none) entries while
> still holding the PTL?

You mean the cleared PTE entries that are to be updated with the collapsed
larger folio?

>
> Thinking out loud:

After staring at this long enough, this does seems like a viable solution yes.

I hate how subtle this is.

>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 5ba298d420b7..e39b750b1e6f 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1413,13 +1413,17 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
>                 map_anon_folio_pmd_nopf(folio, pmd, vma, pmd_addr);
>         } else {
>                 /*
> -                * set_ptes is called in map_anon_folio_pte_nopf with the
> -                * pmd_ptl lock still held; this is safe as the PMD is expected
> -                * to be none. The pmd entry is then repopulated below.
> +                * Re-insert the page table with the cleared entries, but
> +                * hold the PTL, such that no one can mess with the re-installed
> +                * page table until we updated the temporarily-cleared entries
> +                * through map_anon_folio_pte_nopf().
>                  */

You may say nit, but, I think we should be clearly stating the problem here. Yes
we want to hold the PTL to stop anybody else messing with it yet, but we're
really doing this because of:

map_anon_folio_pte_nopf
-> update_mmu_cache_range
-> rewalk
-> try to look up an entry that's not yet actually installed
-> bang

Right?

So maybe something like:

	Re-insert the PMD entry pointing to the PTE page table with cleared
	entries first, because map_anon_folio_pte_nopf() invokes
	update_mmu_cache_range() which may cause a rewalk of the page tables and
	blow up if the supplied PTE entry belongs to a PTE table that is not yet
	present there.

	We hold the PTE PTL to avoid anything else messing with this until we're
	ready.


> -               map_anon_folio_pte_nopf(folio, pte, vma, start_addr, /*uffd_wp=*/ false);
> -               smp_wmb(); /* make PTEs visible before PMD. See pmd_install() */

(I guess better to comment on the smp_wmb() stuff in the other message about
this.)

> +               if (pte_ptl != pmd_ptl)
> +                       spin_lock(pte_ptl);

(Obviously should be spin_lock_nested() as David says later)

It seems a bit weird to me that we acquire the PTE lock:

	pte = pte_offset_map_lock(mm, &_pmd, start_addr, &pte_ptl);

Clear out the mTHP entries we're going to remove:

	if (pte) {
		result = __collapse_huge_page_isolate(vma, start_addr, pte, cc,
						      order, &compound_pagelist);

THen unlock the PTE:

		spin_unlock(pte_ptl);

Before again reacquiring here, especially given this is an unreachable PTE
table.

But then again not doing that would require us to add some error handling logic
to unlock again so it's probably not vital.

>                 pmd_populate(mm, pmd, pmd_pgtable(_pmd));

So we're protecting against concurrent rmap and fault handlers with the PTL such
that installing this is safe right?

Are we good against GUP fast? I guess a race will be fine with that, or will it?
I suppose before it would have skipped the range entirely because of the missing
PMD entry anyway.

(in any case we also hold anon_vma write lock too.)

> +               map_anon_folio_pte_nopf(folio, pte, vma, start_addr, /*uffd_wp=*/ false);
> +               if (pte_ptl != pmd_ptl)
> +                       spin_unlock(pte_ptl);
>         }
>         spin_unlock(pmd_ptl);
>
>
>
> --
> Cheers,
>
> David

Thanks, Lorenzo

