Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DF6FC55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 09:02:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E5716B00AA; Wed,  5 Aug 2026 05:02:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5958C6B00AC; Wed,  5 Aug 2026 05:02:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D3BB6B00AD; Wed,  5 Aug 2026 05:02:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 225826B00AA
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 05:02:57 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8AE8F803DE
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 09:02:56 +0000 (UTC)
X-FDA: 85066625952.26.6FBE57E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id DDE3780010
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 09:02:54 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fbk0d4Ai;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785920575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DgUrRaLpxOH3ntUG5C+r2jZs0iCEzrHMP112JlOYgdQ=;
	b=JHln2mFWCAzDPsL2g2zwD332OQwU0GRvyVCgfu7Zx9ncm4jzsKLrN2qJYrjMKJ8t+mttFo
	tMoMbpFMVTGfdIuwvzGd3B3SyhiVLwlz542PPq+TEz3utTT9E5LubvmnIWiUksHAAcxjmv
	HM1ogyn5Psg7kkZxd8N0eIw/5OHbS/o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785920575;
	b=b6yvHbXBLzJIH/PJKLTcMkkyzYOhRElxTxZcZYfTl5bKEjSIWj1uKraeh5hw67PxeRZaf0
	7f3a2B0EXPo8LZP00Xg3+DHQN3aujUjQ6dGwSO04aFsL4ZfBVz0fROpu72Nj99KOMM6EsY
	2kehb9rAYp90QvJxVavDB5WHb7x7OKY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fbk0d4Ai;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1BF8841491;
	Wed,  5 Aug 2026 09:02:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6223F1F000E9;
	Wed,  5 Aug 2026 09:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785920574;
	bh=DgUrRaLpxOH3ntUG5C+r2jZs0iCEzrHMP112JlOYgdQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fbk0d4Ai1zF/PGXaiBJQGtW2oxIUYnp9HEblf0k8GtwWk5+okgt6pTJdRNX7dYjOJ
	 fkNqkG540pwyGbtf5TaLzFfmBB7hsNgsZP5SCQtl/qq22iIycL8aw6UWCxPdSJUMk+
	 B6u34hQxfcxzPi2aCanJ7nKbfDLFkBxOkQFwT+L0c8yN7KPsBXdxJhzVGkCW5G6Ief
	 iSSI8N0DPeoFCMmwk7hurdH0//lJJRpi23UeVr+DaDP4aNgIYfJZSkU5svn0XZN97v
	 L+TtkcLIHa3zYYr34b2cxCZtY4XHUzeKawfDYk97rQVIxlZ6ithQvVpEXvvwvh1e4Z
	 MPUIB/mEo+ijg==
Date: Wed, 5 Aug 2026 10:02:32 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Usama Arif <usama.arif@linux.dev>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 08/15] mm: introduce and use linear_folio_page_index()
Message-ID: <anL8EawRefur2cc2@lucifer>
References: <20260729-b4-scalable-cow-virt-pgoff-v3-0-e8ecfefea812@kernel.org>
 <20260729-b4-scalable-cow-virt-pgoff-v3-8-e8ecfefea812@kernel.org>
 <0d9f3040-825d-49af-9d07-1e7945dd3e9d@kernel.org>
 <anCdkHNmG5K43E6l@lucifer>
 <784eab3a-2b37-476c-a6fc-7fb6e27b6c66@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <784eab3a-2b37-476c-a6fc-7fb6e27b6c66@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DDE3780010
X-Stat-Signature: czyxqfp69ipqd5h9giizkf6z8m8djwf9
X-HE-Tag: 1785920574-143401
X-HE-Meta: U2FsdGVkX189mT07m3bGSmaheOiFxBl1N3W8UbL1xabkq+L+Blg5aH2lXmkbAipxT0SIM2cDTuiDY+p49pQDdgfnEelNufVSNFRkk/tz+WeMdO5yaGKS4k0/ngcPWgoLiiAgjKVIA0HNWBKt4KRugAE7x5zyvZYQt+eR2u+lKWRZYcpY7CKKjgjHlxcPi2gooUtP9SQRaBptI7NBZ+WXRi3di9FpmKVX+o90VU+gSFOa7nkQnsRxSO4LZzcWrdZDVHU0e5YtBh37zkUN9Kb2wkDnBj9Gz5TfIB5GHzUBEBaTDJds8Qpene37gK1s/yt+4+FdOSg3rYOomoWLnnLi9rdUPMwhNDw6/sE/EPLYvQ4c3bWkO6I6cUwA/ViT5SdGWCK1le4g6ENM0UR6P375OsqZC8klxKRjyS0B5DIeAGnhpvmzLMEQTJtitPxtVCRoKqususmeuGQtb+51CEgrDYJ0v271vPlwT4l6qtmWYTCNgw30eltSrjoe9lcLmbEmIEcGFI0Dn6I53br5uYoXMWCmU5ZWFPmx0sQPb0GS8GpynwDZkJaEViJPKRtehKlNX3kUF7v9zIHdsX5+YRecUOcgq8r5tILAyG4uxV/4fYRmR33cukSrIDzhdx9muVQldUncL8nH0HFzeFShazFdTYYICgai1+F1nzUH0oOkRHnfB2hf0JOecV0cDoQKmDmDxnLNGxbKBbsQDg0PwkZDJ8xWRzuqnNt4CNKWCHbFrxc2bg/XpulXxzWs/XQsV33+u6/JkhcoRiAdDEJEX3Kp1gxaat3ktQnY+haayZSkRPL+ZZzxMMcjCBcSqHvFvkoHAO7OGLjm8nWJgdw1nLRvolBoPKsvohLaQYwQAna+2xEroBg/QPxZ2mAbO+/834e4Gc/l5gX7Q/04QbhDHmTUq9wjaVWlYywpkKKT+OScgbjQS/YJX9eBb0aKAFe5aQ0tGbVr+OEQ2kfREhoRQjX
 kNaCz8tr
 1FCyFcD+0MpVA4OO2WCck4RKcQiJqMLrp4hrr1vNBouXNEKhfDcvMW5pEyA2xIOMbj/Md4V1iZRHJKrnsWKqZDjO9q2eB1LSJk3hD57CV9dmDAPlgDXHjbiVuBEvKDt14WFabB0Tmmk7wZmUhIqp+yWoTOEPm3K3uRbYu/YBr1vGND3Rt39Fj597Z2R+2rh28PcxHYVmoeKs2w0tAL8w8/uRuCSHZkyIpkTHf4VCuMm5yxi2xHSyVvERZFCMNz2JtyzvlWoZQmtWimBd207naY7/urtBY8b9GszTgaVbxM1scOxJ6qg/Zkwu8zZQEfyVje9u16MSj+O/lfuM3fMHG99b5DJOxSp+uXeGfLwG9xFH+m7IGIk/DxKHDq4sSmAbw8wsMEZx0x5lRy33Head3o1HNKg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 05, 2026 at 09:26:59AM +0200, David Hildenbrand (Arm) wrote:
> On 8/3/26 16:30, Lorenzo Stoakes (ARM) wrote:
> > On Mon, Aug 03, 2026 at 01:27:09PM +0200, David Hildenbrand (Arm) wrote:
> >> On 7/29/26 18:48, Lorenzo Stoakes (ARM) wrote:
> >>> This function is, for now, a placeholder; it will be used in future to
> >>> determine whether to use the anonymous page index or not, based on whether
> >>> the folio is anonymous or not.
> >>>
> >>> Currently it simply wraps linear_page_index(), so this does not change
> >>> behaviour.
> >>>
> >>> We update callers that will, once the change is introduced to track
> >>> anonymous folios by anonymous page offset if MAP_PRIVATE file-backed, need
> >>> to determine which index to use based on folio type.
> >>>
> >>> No functional change intended.
> >>>
> >>> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> >>> ---
> >>>  include/linux/pagemap.h | 18 ++++++++++++++++++
> >>>  mm/huge_memory.c        |  3 ++-
> >>>  mm/migrate.c            |  6 ++++--
> >>>  mm/userfaultfd.c        |  6 ++++--
> >>>  4 files changed, 28 insertions(+), 5 deletions(-)
> >>>
> >>> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> >>> index 259177544b03..6eb8d811ba4c 100644
> >>> --- a/include/linux/pagemap.h
> >>> +++ b/include/linux/pagemap.h
> >>> @@ -1143,6 +1143,24 @@ static inline pgoff_t linear_anon_page_index(const struct vm_area_struct *vma,
> >>>  	return pgoff;
> >>>  }
> >>>
> >>> +/**
> >>> + * linear_folio_page_index() - Determine the absolute page offset of
> >>> + * @address within @vma from @folio.
> >>> + * @folio: The folio whose linear page index is sought.
> >>> + * @vma: The VMA in which @address resides.
> >>> + * @address: The address whose absolute page offset is required.
> >>> + *
> >>> + * For compatibility, currently identical to linear_page_index().
> >>> + *
> >>> + * Returns: The absolute page offset of @address within @vma.
> >>> + */
> >>> +static inline pgoff_t linear_folio_page_index(const struct folio *folio,
> >>> +					      const struct vm_area_struct *vma,
> >>> +					      const unsigned long address)
> >>> +{
> >>> +	return linear_page_index(vma, address);
> >>> +}
> >>
> >>
> >> I found this to be rather confusing, given that we now have a "folio" helper that
> >> receives a folio and a "page" helper that doesn't receive a page ...
> >
> > This is just to avoid having to duplicate the if (folio_test_anon()) { ... }
> > else { ... } stuff.
> >
> > Agreed it's a bit confusing!
> >
> > Really you are figuring things out from (vma, address) - 'what is the correct
> > page offset based on the VMA'.
> >
> > And yeah it seems migrate can do it via PFN as you suggest, it really is
> > just trying to find the page offset in the folio.
> >
> > But...
> >
> >>
> >> I guess the problem is the "page" in "linear_page_index", as it
> >> reminds of legacy page->index.
> >>
> >>
> >> I wonder if it would be better to have a linear_folio_index() and
> >> force that address points at the start of the folio.
> >>
> >> Looking below, this is exactly what we want for all except one case:
> >
> > ...I don't think this is true.
> >
> > The uffd code uses this too in move_present_ptes():
> >
> > 		src_folio->index = linear_folio_page_index(src_folio, dst_vma,
> > 							   dst_addr);
> >
> > And it's now _updating_ the source folio index to the offset in the destination
> > VMA, so it doesn't even relate to the source folio's offset at all?
> >
> > (move_swap_pte() calls linear_folio_page_index() but obviously has to be
> > anon, so that can just use linear_anon_page_index() there instead, will
> > update.)
> >
> > With your change we can just eliminate the linear_folio_page_index()
> > function and open-code the uffd case.
>
> The would be even better!
>
> >
> > It's a bit of a special case anyway and is neatly the one place where you
> > actually don't know if it's anon or file-backed (well anon or shmem
> > specifically I think).
> >
> >>
> >>
> >>>  		/* pgoff is invalid for ksm pages, but they are never large */
> >>> -		if (folio_test_large(folio) && !folio_test_hugetlb(folio))
> >>> -			idx = linear_page_index(vma, pvmw.address) - pvmw.pgoff;
> >>> +		if (folio_test_large(folio) && !folio_test_hugetlb(folio)) {
> >>> +			idx += linear_folio_page_index(folio, vma, pvmw.address);
> >>> +			idx -= pvmw.pgoff;
> >>> +		}
> >>>  		new = folio_page(folio, idx);
> >>
> >> I think we could avoid this index work entirely by using the pfn, which is much
> >> clearer to me, and similar to how we handle it during other rmap operations.
> >>
> >> diff --git a/mm/migrate.c b/mm/migrate.c
> >> index 222c8c15f782f..686351d353203 100644
> >> --- a/mm/migrate.c
> >> +++ b/mm/migrate.c
> >> @@ -362,17 +362,12 @@ static bool remove_migration_pte(struct folio *folio,
> >>                 struct page *new;
> >>                 unsigned long idx = 0;
> >>
> >> -               /* pgoff is invalid for ksm pages, but they are never large */
> >> -               if (folio_test_large(folio) && !folio_test_hugetlb(folio))
> >> -                       idx = linear_page_index(vma, pvmw.address) - pvmw.pgoff;
> >> -               new = folio_page(folio, idx);
> >> -
> >>  #ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
> >>                 /* PMD-mapped THP migration entry */
> >>                 if (!pvmw.pte) {
> >>                         VM_BUG_ON_FOLIO(folio_test_hugetlb(folio) ||
> >>                                         !folio_test_pmd_mappable(folio), folio);
> >> -                       remove_migration_pmd(&pvmw, new);
> >> +                       remove_migration_pmd(&pvmw, folio_page(folio, idx));
> >
> > I think we'd need the idx code below to go above where the idx code is now
> > as otherwise this will be incorrect right?
> >
> > But then again, if it's a PMD softleaf it'd have to be aligned right, so
> > couldn't we just update that function to be passed a folio instead and
> > avoid the idx here at all?
>
> Right, that's what I mentioned below
>
> "remove_migration_pmd() will work for now. Later it should just receive the folio
> and do the same thing through softleaf_from_pmd() -> softleaf_to_pfn().
>
> >
> >>                         continue;
> >>                 }
> >>  #endif
> >> @@ -385,10 +380,14 @@ static bool remove_migration_pte(struct folio *folio,
> >>                     try_to_map_unused_to_zeropage(&pvmw, folio, old_pte, idx))
> >>                         continue;
> >>
> >> +               entry = softleaf_from_pte(old_pte);
> >> +               if (folio_test_large(folio) && !folio_test_hugetlb(folio))
> >> +                       idx = softleaf_to_pfn(entry) - folio_pfn(rmap_walk_arg->folio);
> >
> > Could actually be softleaf_to_pfn(entry) - pvmw.pfn even?
>
> Given that DEFINE_FOLIO_VMA_WALK() sets
>
> 	.pfn = folio_pfn(_folio);
>
> I think so.
>
> >
> >> +               new = folio_page(folio, idx);
> >> +
> >>                 folio_get(folio);
> >>                 pte = mk_pte(new, READ_ONCE(vma->vm_page_prot));
> >>
> >> -               entry = softleaf_from_pte(old_pte);
> >>                 if (!softleaf_is_migration_young(entry))
> >>                         pte = pte_mkold(pte);
> >>                 if (folio_test_dirty(folio) && softleaf_is_migration_dirty(entr
> >>
> >>
> >> remove_migration_pmd() will work for now. Later it should just receive the folio
> >> and do the same thing through softleaf_from_pmd() -> softleaf_to_pfn().
> >
> > Ah you already addressed it. But since this would move the idx code above,
> > I think I should just change it to accept a folio instead?
> >
> > Or for less churn &folio->page...
> Right, whatever you prefer.

Awesome will do all that on respin :)

Thanks for the review, this is actually really improving the series :>)

>
>
>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

