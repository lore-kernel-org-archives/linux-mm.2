Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 380651090247
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 15:54:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D09E6B0514; Thu, 19 Mar 2026 11:54:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55BC56B0516; Thu, 19 Mar 2026 11:54:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 449716B0517; Thu, 19 Mar 2026 11:54:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2E10B6B0514
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 11:54:03 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D46181A05E8
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 15:54:02 +0000 (UTC)
X-FDA: 84563258724.21.D540823
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1C0B71C0002
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 15:54:00 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uLk4CcZW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773935641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U7Fh53GaKP6p77En+9frhcsQVL1i+1ahck7maJ3cSfE=;
	b=3MRvCaXepX7FgFHCrlbtCfRfPXYZlIUCq7Cfe+yp4VS8ZIgBPtaZCpDV7CNMw5600oxVlD
	4joP1dqnk+oXnAGoRHasNGehSY7YY7DWo14qG6VjCJj+O4MpeUT/Bg3xmlgjcMOmFgzUKs
	P5VYVDxAb7h5NKq58aBds5cIV/mbkFo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773935641; a=rsa-sha256;
	cv=none;
	b=oqxR9Vn3zqAeBjBCF0ARsRINoqM5Q4C3tCKKLWluQIS9l/ulUyW+KpGQCqOR9j0t5sGm39
	F2dEE1oWGXw35WwCZEPDX9NA+Ah9DUqhfs6zgiX1H50HfE7FZhP2bF5qHyygU7i9LRembz
	WsJs9+bTB6Hu8yyrFEC6miybQc41pjQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uLk4CcZW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D4AC14012F;
	Thu, 19 Mar 2026 15:53:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24CABC19424;
	Thu, 19 Mar 2026 15:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773935639;
	bh=zMVXnXLHI36ewwgqOA9dwM/IT0esoQh0vSlEPV7lZ4Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uLk4CcZWAnXyLV5R64pNJ5c9zJ+0sykjMTh2LW/CJzet3wRfZ+kgnnlvVy1oJzHN+
	 R0ioki6myuSgsdRYDWol6mlGkduEc6GVPMzxsRntuXXcrxLPPuIiWfEv9CC1EWVCvh
	 c+NdlO7G5n2HmDZvLgKAlxauTw85JwiKIgnFLjFaaVMAXj6bZZ4q6w8WELLXkZtSTa
	 MIk/OI9SRIo28THNP0F4M1/41+SVs8q0sjVlu3rnxpl5+vYrVDzu3gEhNq7B355RIp
	 2NnM4+AlzMwHtdOjzZhiIRR8vv2ztP0vK+bV+ILwgVHZ/exfY7AN8R4y+otiQq+FTS
	 KuRXROL4Jpq9g==
Date: Thu, 19 Mar 2026 15:53:57 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, 
	yuanchu@google.com, david@kernel.org, hughd@google.com, chrisl@kernel.org, 
	kasong@tencent.com, weixugc@google.com, Liam.Howlett@oracle.com, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, riel@surriel.com, 
	harry.yoo@oracle.com, jannh@google.com, pfalcato@suse.de, 
	baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com, 
	baohua@kernel.org, youngjun.park@lge.com, ziy@nvidia.com, kas@kernel.org, 
	willy@infradead.org, yuzhao@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, ryan.roberts@arm.com, anshuman.khandual@arm.com
Subject: Re: [PATCH 3/9] mm/rmap: refactor lazyfree unmap commit path to
 commit_ttu_lazyfree_folio()
Message-ID: <a8b06f36-98e1-435c-881f-67242bc4304a@lucifer.local>
References: <20260310073013.4069309-1-dev.jain@arm.com>
 <20260310073013.4069309-4-dev.jain@arm.com>
 <3915e3bc-c390-44bc-a463-bdd687598284@lucifer.local>
 <71e7df79-cfe1-4f3d-b00c-8ac53f886c04@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <71e7df79-cfe1-4f3d-b00c-8ac53f886c04@arm.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1C0B71C0002
X-Stat-Signature: ds8zmcjdq1r9zpormho3fsy81he5o5j4
X-Rspam-User: 
X-HE-Tag: 1773935640-675572
X-HE-Meta: U2FsdGVkX1+VYRU+KKlXEV2hRCkdrT9wN0ZL41L75Kz160nxAtqKJmkREf7APnU5WER+/EDSJGrXLNyrPSUOQkkgUFHSIqprmXKsBjkwUYMbm2KqliMKZLShXS2wrj6LXVqlA9u44DuziiQoy79KDS537gXLFZIANea1K1SNpJKE0UQaxHNSt8T/FtbxyHB0xkslw/TEPQhCbplMsq76rkTndUY9OQL8REI5FwXSxb4IkuNtN4+aIFIi8L0IXC8AfcaGhqB+ZLEofGzbkTCyZlL51AeEN0j5O32r0e52GCAZWbQgg92m2p5xe3BdZoOZrV6Ty24AsC53FYbqdNIqOankO7phHLIuUjANhpImcs9M5sy5ItKY/jmeJCcuP7AtInuS0Sv/PxLAhyPyKwR0FyfRfNoE8kFdoBUcwiCZaIIVmMPoQV8slDqK588iwaw+7G1EWlPxt29ByiX1yw+unVa52sIZYdDGyUrGPy5ceG4IXmb/jaKVGrAS/Zgl32b6LsWQ4+0D+BlJHfWO4v501NeKbp5CLdp/4qzga35aiY6QjFknua60qt1f2DTwe9EIjhElj0IFf1yUFbv4v8Z8jT1TkhjllNNKw6nd/oowTxwwazlPhh1d6ua0ub4vOPoLcq1TrxUrJauqX4LKD4cysYF3GOjVF9jT3Ft9TgWozzGfDCaZtkMRlBvA/Ra2KOwq5yWAbZ7dWcuou94YdaUquYg3e4u7b9EwHdUpM67jR2uBbtixlp9PjhzwqMxhWC7WM/kXSm+y9R655xaMAqPnjwMv/sYWCPSFb7SReVn27iZTuP3lO7opTLpnR9bMMswwuXKKkdKMh3PxdQJ6rLyEj+mmWFbDIMXAYEOfFJdt9s8zTbXKIpM4RLHoDro+0OH/XMrZgDPfgraiH93UpiI9O9bDSl3qr5FEBkOSbVRVj+/Ti/+soQGR5PDrJmiSo8xiG67KlaTgXB42MGTpaBD
 NKCpcDKI
 yAkUgJoZ3Xj9o7PmTn7LPSH0kNViZT+KiBcQegN8AP/+g1TfLs+6uomp/aP3MVCSlNNeVCo13Q3QUGBt5fA2Vv0PXi+x/EA0JeUyOjXaAUNwmrfGr2Tjsnr/HtwZ8YcKis3l3nmIDqbG7zmAdKU+sJ4uXADFVN/24RE6Af9EqB2xyFjIq1XaXNxsAHaRwiKYKXqc1J1d3M4M7yrTHXsMTo4AkjTd8AHCXB8iFok2DP7W7bPSYwfdiSTflrwqx0Qmjiy6T6nx7k5yHkcqe1657KEK0uQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 10, 2026 at 02:12:45PM +0530, Dev Jain wrote:
>
>
> On 10/03/26 1:49 pm, Lorenzo Stoakes (Oracle) wrote:
> > On Tue, Mar 10, 2026 at 01:00:07PM +0530, Dev Jain wrote:
> >> Clean up the code by refactoring the post-pte-clearing path of lazyfree
> >> folio unmapping, into commit_ttu_lazyfree_folio().
> >>
> >> No functional change is intended.
> >>
> >> Signed-off-by: Dev Jain <dev.jain@arm.com>
> >
> > This is a good idea, and we need more refactoring like this in the rmap code,
> > but comments/nits below.
> >
> >> ---
> >>  mm/rmap.c | 93 ++++++++++++++++++++++++++++++++-----------------------
> >>  1 file changed, 54 insertions(+), 39 deletions(-)
> >>
> >> diff --git a/mm/rmap.c b/mm/rmap.c
> >> index 1fa020edd954a..a61978141ee3f 100644
> >> --- a/mm/rmap.c
> >> +++ b/mm/rmap.c
> >> @@ -1966,6 +1966,57 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
> >>  				     FPB_RESPECT_WRITE | FPB_RESPECT_SOFT_DIRTY);
> >>  }
> >>
> >> +static inline int commit_ttu_lazyfree_folio(struct vm_area_struct *vma,
> >
> > Strange name, maybe lazyfree_range()? Not sure what ttu has to do with
>
> ttu means try_to_unmap, just like it is used in TTU_SYNC,
> TTU_SPLIT_HUGE_PMD, etc. So personally I really like the name, it reads
> "commit the try-to-unmap of a lazyfree folio". The "commit" comes because
> the pte clearing has already happened, so now we are deciding if at all
> to back-off and restore the ptes.

I absolutely hate the name, and nobody sane is going to read it like that
sorry :) I think this is a case of being too close to the work.

I also hate the overloading of 'lazyfree' which is actually MADV_FREE,
users don't know what lazyfree is and it's a bit of an overloaded term
(we've had discussions of a new 'lazy free' implementation at conferences
before).

Commit is overloaded everywhere I'm not sure it's even particularly
pertinent here.

Also it's not necessarily a folio is it? It could be a contpte range within
a folio so that's just misleading...

lazyfree_pte_range() or something like that seems better to me.

>
> > anything...
> >
> >> +		struct folio *folio, unsigned long address, pte_t *ptep,
> >> +		pte_t pteval, long nr_pages)
> >
> > That long nr_pages is really grating now...
>
> Reading the discussion on patch 1, I'll convert this to unsigned long.

Thanks!

>
> >
> >> +{
> >
> > Come on Dev, it's 2026, why on earth are you returning an integer and not a
> > bool?
> >
> > Also it would make sense for this to return false if something breaks, otherwise
> > true.
>
> Yes I was confused on which one of the options to choose :). Since the
> function does a lot more than just test some functionality (which is what
> boolean functions usually do) I was feeling weird when returning bool.
> But yeah alright, I'll convert this to bool.

Thanks!

Cheers, Lorenzo

>
> >
> >> +	struct mm_struct *mm = vma->vm_mm;
> >> +	int ref_count, map_count;
> >> +
> >> +	/*
> >> +	 * Synchronize with gup_pte_range():
> >> +	 * - clear PTE; barrier; read refcount
> >> +	 * - inc refcount; barrier; read PTE
> >> +	 */
> >> +	smp_mb();
> >> +
> >> +	ref_count = folio_ref_count(folio);
> >> +	map_count = folio_mapcount(folio);
> >> +
> >> +	/*
> >> +	 * Order reads for page refcount and dirty flag
> >> +	 * (see comments in __remove_mapping()).
> >> +	 */
> >> +	smp_rmb();
> >> +
> >> +	if (folio_test_dirty(folio) && !(vma->vm_flags & VM_DROPPABLE)) {
> >> +		/*
> >> +		 * redirtied either using the page table or a previously
> >> +		 * obtained GUP reference.
> >> +		 */
> >> +		set_ptes(mm, address, ptep, pteval, nr_pages);
> >> +		folio_set_swapbacked(folio);
> >> +		return 1;
> >> +	}
> >> +
> >> +	if (ref_count != 1 + map_count) {
> >> +		/*
> >> +		 * Additional reference. Could be a GUP reference or any
> >> +		 * speculative reference. GUP users must mark the folio
> >> +		 * dirty if there was a modification. This folio cannot be
> >> +		 * reclaimed right now either way, so act just like nothing
> >> +		 * happened.
> >> +		 * We'll come back here later and detect if the folio was
> >> +		 * dirtied when the additional reference is gone.
> >> +		 */
> >> +		set_ptes(mm, address, ptep, pteval, nr_pages);
> >> +		return 1;
> >> +	}
> >> +
> >> +	add_mm_counter(mm, MM_ANONPAGES, -nr_pages);
> >> +	return 0;
> >> +}
> >> +
> >>  /*
> >>   * @arg: enum ttu_flags will be passed to this argument
> >>   */
> >> @@ -2227,46 +2278,10 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
> >>
> >>  			/* MADV_FREE page check */
> >>  			if (!folio_test_swapbacked(folio)) {
> >> -				int ref_count, map_count;
> >> -
> >> -				/*
> >> -				 * Synchronize with gup_pte_range():
> >> -				 * - clear PTE; barrier; read refcount
> >> -				 * - inc refcount; barrier; read PTE
> >> -				 */
> >> -				smp_mb();
> >> -
> >> -				ref_count = folio_ref_count(folio);
> >> -				map_count = folio_mapcount(folio);
> >> -
> >> -				/*
> >> -				 * Order reads for page refcount and dirty flag
> >> -				 * (see comments in __remove_mapping()).
> >> -				 */
> >> -				smp_rmb();
> >> -
> >> -				if (folio_test_dirty(folio) && !(vma->vm_flags & VM_DROPPABLE)) {
> >> -					/*
> >> -					 * redirtied either using the page table or a previously
> >> -					 * obtained GUP reference.
> >> -					 */
> >> -					set_ptes(mm, address, pvmw.pte, pteval, nr_pages);
> >> -					folio_set_swapbacked(folio);
> >> +				if (commit_ttu_lazyfree_folio(vma, folio, address,
> >> +							      pvmw.pte, pteval,
> >> +							      nr_pages))
> >
> > With above corrections this would be:
> >
> > 	if (!lazyfree_range(vma, folio, address, pvme.pte, pteval, nr_pages))
> > 	   ...
> >
> >>  					goto walk_abort;
> >> -				} else if (ref_count != 1 + map_count) {
> >> -					/*
> >> -					 * Additional reference. Could be a GUP reference or any
> >> -					 * speculative reference. GUP users must mark the folio
> >> -					 * dirty if there was a modification. This folio cannot be
> >> -					 * reclaimed right now either way, so act just like nothing
> >> -					 * happened.
> >> -					 * We'll come back here later and detect if the folio was
> >> -					 * dirtied when the additional reference is gone.
> >> -					 */
> >> -					set_ptes(mm, address, pvmw.pte, pteval, nr_pages);
> >> -					goto walk_abort;
> >> -				}
> >> -				add_mm_counter(mm, MM_ANONPAGES, -nr_pages);
> >>  				goto discard;
> >>  			}
> >>
> >> --
> >> 2.34.1
> >>
> >
> > Thanks, Lorenzo
> >
>

