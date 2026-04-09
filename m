Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08966F364B1
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 18:44:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CD0E6B0005; Thu,  9 Apr 2026 14:44:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 357306B0089; Thu,  9 Apr 2026 14:44:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21EDE6B008A; Thu,  9 Apr 2026 14:44:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0B40C6B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 14:44:05 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A057516018E
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 18:44:04 +0000 (UTC)
X-FDA: 84639892008.21.5D1A428
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0056314000F
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 18:44:02 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IAL0yO0g;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IAL0yO0g;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775760243; a=rsa-sha256;
	cv=none;
	b=JcYGvXNIW9ST04S5L5ugha5da63F7zBEkzicV7Xa/U4B3rvPcN/ZlW0GCxAntMP70HpTQc
	k3CEHVnZ3rFLappO4B96tiaZBnZoxdSITBoysG7L47wU1DrlY5rWWUCnwvVhE2LoQfJDM/
	P4bcN7dz74pj15Fzc1NQuUjT8IHTsyE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775760243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FyC39NHMa5d3fNLRIgct9A0b/58IO+9pWDhl1Y9uffU=;
	b=yVXtETSP1WrAL6oeUxrkJIACCOgk+NzBKEU+sNc3UP45wkjFs/ZtuYVreJ5NtLjSVqp2+T
	h0dSYBzjHYyvRaU9mM2b++cYEVauKocMkfEu7TvSHOA7kgXumN5ylXAWGEwapST56hQrMg
	Tlwr+4VL1epybYrAyRCQCHbK7CB6prU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0C75C40194;
	Thu,  9 Apr 2026 18:44:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 537ADC19424;
	Thu,  9 Apr 2026 18:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775760241;
	bh=uIg82L4DjC6SQMflVbk9FHtb5Uti2at/qU8a4k6XjA0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IAL0yO0grcurODGd5NI/NYJiE6E0PMYwjOcSMTrGSvPHBUOttOKPTnUesNGyeQToB
	 MM4nYrBdTzGIw6opFv0NrLmjJvxE0/KYe3Yt/ioYsSlXHjvD3RMjNBB3wkS4m8OJMX
	 MX5387cmvjSkWAq3O3rp7qH/hiMUTI4PfLiP1e98RAvU8LOBHjzqvJTHPYFKqZVD89
	 F3Fu9+DEKjXpVFLIAchYvkGJ6QgWE2iIKX5ax/q+7R//u/SVY6HqGzW2khM112y8Za
	 YKS8stNZ8FfMvQPHhKylPOHR8+Al+2WNG1Nk6L4CQ+44Zoj3hMwM1NxcBC1P8kU5ak
	 z0+nLzEmcC4uQ==
Date: Thu, 9 Apr 2026 19:43:55 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Haakon Bugge <haakon.bugge@oracle.com>
Cc: Hugh Dickins <hughd@google.com>, John Hubbard <jhubbard@nvidia.com>, 
	Joseph Salisbury <joseph.salisbury@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Peter Xu <peterx@redhat.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] mm: stress-ng --mremap triggers severe lruvec lock
 contention in populate/unmap paths
Message-ID: <adfxfjtZqnxDKkyz@lucifer>
References: <a3474fcf-9f20-47ee-9d15-233e5c7e3f83@oracle.com>
 <4a4f5b48-8a1d-48f8-8760-0f5d43b5d483@nvidia.com>
 <982e5964-5ea6-eaf7-a11a-0692f14a6943@google.com>
 <adfhGOHcg4AF3IFn@lucifer>
 <AD19A104-818A-4880-9172-0C8FCA6B4633@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AD19A104-818A-4880-9172-0C8FCA6B4633@oracle.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0056314000F
X-Stat-Signature: 3t9411xxnwajqc4cr4rmaxyus348u953
X-Rspam-User: 
X-HE-Tag: 1775760242-262771
X-HE-Meta: U2FsdGVkX19EoTY0td1CdH8pMCRuipHTI9iAcuHvGPh/BcDA6p4Oo1+kkbMfR9HouJI6kwyn6ZSKU9hfh4I5znoik08ht9Myf42qSEqYPZrcOkAB91+760cf/fIvkf7bD1x5wNJzxuTSZSA6Z/IjMkzRgKnO/q38zldkKHjeTn4aooaJUYEnU8YWbf6bSdFQoJsxHxsOIHX9GLsQCU94srmEV5rshceRkGwRb+b5pRSr3htOjVVUcAhcgYnr10PXMeYaVcQUZVojqj67gulJ+OarWD/ATtQJoFouBARl+g2Oa6i/1R/kT3/VY4RlNsrGsMMMhK0chdNWyHB6aWoAiBiUL6j14FbahpDg0S8WfUA/gzFyRQ0SF1xR5MdAo9Ppw1J+Cq+fnDXShYw6J7a/NveLzVmzljXO5PlxrG6rX/pzco1z3RsY51va7a6ugEDw0A5Sz6a6PXT7HYZEEUsxxXkN2wmnddCSyUqlsjIusfcYAoAjAl5lfUcHgF3PDRyYFochKRBWd81gA2PrpbgubuxyteVHYnVwRD9dLiZUWeihQuJ5340XFARCN9mC6hpY05s4V/SL2MSILos2/I6wFPe50bw2ojgvHEwl2/+pPm2XyJHaqCqx+dA45E1pL5VGJOCr120CovYKuRk8/9CPAhbgJabiQ1ymdt1TAUwRbfYiLDs+lh4x0YvdSWi9Y1snnvjewDZ8mvGCiFWJKW3ViTBUyvyq731DRAOAv7SOJWNRz1La75Ls2YJDWKzuNhBDk9nhPdg/RmwjsCNPIqZ8KLpjUzb6fFHv5J0Plu7lp0QWkLXQsiZ5PyOgSZr1TvDkHXBc9E8b0gZlaFatykO+ZHpxjv000YRICILLOcF7cSfUC9vFFwsIKetId3bUQQo+ZHOWx/ldaS9EQdmYr7eVUmVnRlsHCNAbTLU/nazxyGBOWb0HCLsrWDqBU3PNKXW8zCLAFsJO6lNGyjnsP5R
 LQA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 09, 2026 at 06:15:50PM +0000, Haakon Bugge wrote:
>
>
> > On 9 Apr 2026, at 20:03, Lorenzo Stoakes <ljs@kernel.org> wrote:
> >
> > On Tue, Apr 07, 2026 at 05:35:18PM -0700, Hugh Dickins wrote:
> >> On Tue, 7 Apr 2026, John Hubbard wrote:
> >>> On 4/7/26 1:09 PM, Joseph Salisbury wrote:
> >>>> Hello,
> >>>>
> >>>> I would like to ask for feedback on an MM performance issue triggered by
> >>>> stress-ng's mremap stressor:
> >>>>
> >>>> stress-ng --mremap 8192 --mremap-bytes 4K --timeout 30 --metrics-brief
> >>>>
> >>>> This was first investigated as a possible regression from 0ca0c24e3211
> >>>> ("mm: store zero pages to be swapped out in a bitmap"), but the current
> >>>> evidence suggests that commit is mostly exposing an older problem for
> >>>> this workload rather than directly causing it.
> >>>>
> >>>
> >>> Can you try this out? (Adding Hugh to Cc.)
> >>>
> >>> From: John Hubbard <jhubbard@nvidia.com>
> >>> Date: Tue, 7 Apr 2026 15:33:47 -0700
> >>> Subject: [PATCH] mm/gup: skip lru_add_drain() for non-locked populate
> >>> X-NVConfidentiality: public
> >>> Cc: John Hubbard <jhubbard@nvidia.com>
> >>>
> >>> populate_vma_page_range() calls lru_add_drain() unconditionally after
> >>> __get_user_pages(). With high-frequency single-page MAP_POPULATE/munmap
> >>> cycles at high thread counts, this forces a lruvec->lru_lock acquire
> >>> per page, defeating per-CPU folio_batch batching.
> >>>
> >>> The drain was added by commit ece369c7e104 ("mm/munlock: add
> >>> lru_add_drain() to fix memcg_stat_test") for VM_LOCKED populate, where
> >>> unevictable page stats must be accurate after faulting. Non-locked VMAs
> >>> have no such requirement. Skip the drain for them.
> >>>
> >>> Cc: Hugh Dickins <hughd@google.com>
> >>> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
> >>
> >> Thanks for the Cc.  I'm not convinced that we should be making such a
> >> change, just to avoid the stress that an avowed stresstest is showing;
> >> but can let others debate that - and, need it be said, I have no
> >> problem with Joseph trying your patch.
> >
> > Yeah, the test case (as said by others also) is rather synthetic, and it's a
> > test designed to saturate, if not I/O throttled by swap then we hammer the
> > populate path. It feels like a micro-optimisation for something that is not (at
> > least not yet demonstrated to be) an actual problem.
> >
> > stress-ng is not a benchmarking tool per se, it's designed to eek out bugs.
> >
> > So really we need to see a real-world case I think.
> >
> >>
> >> I tend to stand by my comment in that commit, that it's not just for
> >> VM_LOCKED: I believe it's in everyone's interest that a bulk faulting
> >> interface like populate_vma_page_range() or faultin_vma_page_range()
> >> should drain its local pagevecs at the end, to save others sometimes
> >> needing the much more expensive lru_add_drain_all().
> >
> > I mean yeah, but I guess anywhere that _really_ needs to be sure of the drain
> > has to do an lru_add_drain_all(), because it'd be fragile to rely on
> > lru_add_drain()'s being done at the right time?
> >
> >>
> >> But lru_add_drain() and lru_add_drain_all(): there's so much to be
> >> said and agonized over there  They've distressed me for years, and
> >> are a hot topic for us at present.  But I won't be able to contribute
> >> more on that subject, not this week.
> >
> > Yeah they do feel rather delicate... :) sometimes you _really do_ need to know
> > everything's drained. But other times it feels a bit whack-a-mole.
> >
> > I also do agree it makes sense to drain locally after a batch operation.
> >
> > It all comes down to whether this manifests in a real-world case, at which point
> > maybe this is a more useful change?
> >
> >>
> >> Hugh
> >>
> >>> ---
> >>> mm/gup.c | 13 ++++++++++++-
> >>> 1 file changed, 12 insertions(+), 1 deletion(-)
> >>>
> >>> diff --git a/mm/gup.c b/mm/gup.c
> >>> index 8e7dc2c6ee73..2dd5de1cb5b9 100644
> >>> --- a/mm/gup.c
> >>> +++ b/mm/gup.c
> >>> @@ -1816,6 +1816,7 @@ long populate_vma_page_range(struct vm_area_struct *vma,
> >>> struct mm_struct *mm = vma->vm_mm;
> >>> unsigned long nr_pages = (end - start) / PAGE_SIZE;
> >>> int local_locked = 1;
> >>> + bool need_drain;
> >>> int gup_flags;
> >>> long ret;
> >>>
> >>> @@ -1857,9 +1858,19 @@ long populate_vma_page_range(struct vm_area_struct *vma,
> >>> * We made sure addr is within a VMA, so the following will
> >>> * not result in a stack expansion that recurses back here.
> >>> */
> >>> + /*
> >>> + * Read VM_LOCKED before __get_user_pages(), which may drop
> >>> + * mmap_lock when FOLL_UNLOCKABLE is set, after which the vma
> >>> + * must not be accessed. The read is stable: mmap_lock is held
> >>> + * for read here, so mlock() (which needs the write lock)
> >>> + * cannot change VM_LOCKED concurrently.
> >>> + */
> >
> > BTW, not to nitpick (OK, maybe to nitpick :) this comments feels a bit
> > redundant. Maybe useful to note that the lock might be dropped (but you don't
> > indicate why it's OK to still assume state about the VMA), and it's a known
> > thing that you need a VMA write lock to alter flags, if we had to comment this
> > each time mm would be mostly comments :)
> >
> > So if you want a comment here I'd say something like 'the lock might be dropped
> > due to FOLL_UNLOCKABLE, but that's ok, we would simply end up doing a redundant
> > drain in this case'.
> >
> > But I'm not sure it's needed?
> >
> >>> + need_drain = vma->vm_flags & VM_LOCKED;
> >
> > Please use the new VMA flag interface :)
> >
> > need_drain = vma_test(VMA_LOCKED_BIT);
> >
>
> I think we all agree that the stress-ng test case is synthetic. I evaluated John's patch as I understood that was requested, and the outcome was, merely, as expected.

(Please wrap lines :)

Ack re: synthetic.

Thanks for evaluating it! I don't think John's patch is incorrect per se, but as
I said on reply further up thread, I fear this all might be rather a distraction
from a real world perspective, because you'd expect similar results due to
reasons other than the lruvec being a bit *ahem* sub-optimal shall we say.

>
> The fio case is more interesting, as, if my runs make sense, it improves IOPS by ~20% and avoid threads being stuck at termination. But, I am not intimate with fio, so take that part as a grain of salt.

That is interesting, but again I wonder what it's actually measuring, because if
things are getting stuck because of saturation from stress-ng doing insane
things (hammering the hell out of madvise(..., MAP_PAGEOUT), mremap(), munmap()
in the hot path, all while not caring about NUMA node locality), then that's
sort of what you'd expect I guess?

I guess the only way to avoid possibly measuring the wrong thing is to examine a
real-world case, and if there is something lurking there with lruvec scalability
(very possible) then we can definitely look at that!

Thanks for digging into this!

>
>
> Thxs, Håkon
>
>

Cheers, Lorenzo

