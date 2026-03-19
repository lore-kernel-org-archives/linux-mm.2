Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE063109023F
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 15:26:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 402716B050A; Thu, 19 Mar 2026 11:26:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B09D6B050C; Thu, 19 Mar 2026 11:26:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 273506B050D; Thu, 19 Mar 2026 11:26:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0E9426B050A
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 11:26:28 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C111A140566
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 15:26:27 +0000 (UTC)
X-FDA: 84563189214.15.F25A4A3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id D039B40010
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 15:26:25 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fLuaFgq8;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773933985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RzulagucixrAq9pvmoZGhIw8ZAuzMVozPfvSNnzKHHo=;
	b=O6+yfTVMjdltmfBe9oMWNBOfE5HoHhdVvgJouqpaYBhIriU4cMfVW8EZ6IlRGMvuxeNtm+
	x1A44L9jrclIR72aIw3NOPqD8m+FAbIFzNpP5bKN7qpRZjzXQt4VR+Q4yCBbFIEzajNMO+
	z72Kz+H6eF5FYwX3Zb8ZxHl1rJkjEzM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fLuaFgq8;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773933985; a=rsa-sha256;
	cv=none;
	b=m18xqfYIQqR8upOCQkvtcpPKhW9EA6QnhU6G/L8NPvuM0FvpWyHPbuHO1j3ePMnkzd1MaK
	kobLDI+k4GghYSpuQZ+YagBGDm4QiNYqt/d4PuwI2PSpxn1oeRZFTZnajxFPLfWDu/hgYu
	VXO2wXNRLVOoh0J+ugxYtsgFP7tMshs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 26E2360054;
	Thu, 19 Mar 2026 15:26:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33593C19425;
	Thu, 19 Mar 2026 15:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773933984;
	bh=Qd6BFYywHFyE8a9Vdt4rUHZRIFcJwJaA71ffKpPrSac=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fLuaFgq8YDjMSa8f34FmvlgdtIqNTRMeX0dHfGgQKoR5Qd5I8LOY8qfSU85237nVI
	 90YLfdGH2w9byMZcwSDhooTqVQB+QOb+1fannxJXWssuZaFnupu6nneORfWSb9JtlL
	 RAVq+ZrdDwpZTk9fUNm05D/pa2EX5O2m3eiTP4iktmwFNO6B9gT0MLrwyCR9D06EvK
	 fMudWXVJSoIv9s3a9kqH8Ix5ZZUY/vBZjq8ZeuTVfAWFRBWpAU7ZMhuou7iRMRrONp
	 lQypOy6dP7+gr0dELj260U5VTVy5nOyuMg4ejzMID+wXoHe3zWn63wzsroiiwSaX14
	 Vzmsbbh+kXPiQ==
Date: Thu, 19 Mar 2026 15:26:22 +0000
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
Subject: Re: [PATCH 6/9] mm/swapfile: Make folio_dup_swap batchable
Message-ID: <8e4cbb87-8146-447b-b140-6fe01672ac81@lucifer.local>
References: <20260310073013.4069309-1-dev.jain@arm.com>
 <20260310073013.4069309-7-dev.jain@arm.com>
 <18928285-20c6-4cd9-842f-c0aef91421a2@lucifer.local>
 <26631dbf-1a3e-4d30-9a07-ff64319cbf2f@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26631dbf-1a3e-4d30-9a07-ff64319cbf2f@arm.com>
X-Rspamd-Queue-Id: D039B40010
X-Stat-Signature: myganwt8eozuoeizdi6ya81ta14pm97g
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773933985-707924
X-HE-Meta: U2FsdGVkX1++IqCaWYQFmFf7zUoIh492Kn4NluCBxc51e29urpg18R7knNbrMHWTA5fC4LWAo2OSCeGG7jD3IziI2dXivnVRfaa2UVRmznKY7DrJRO+Du941kxyThwRiayCZqM6qob9lC7+a+MtotV6puQ1W9oVudsXoirPJo/ey0xSrMGnSxk3sGCc4O5IeqQa4k+k3RZ2UfNnUgmyOKROf75m+/RWjfudarxBTORYfS3/uZb0ye5NeIPcyWctC+rU7025DU5yS/G0jNsBNmUQ7ZWUDCH8Z22Vr2LKKeRq1KN3CCZfD2Ocn6J8DAC1VmGOuJscmDauc9Lde8Bs+lLlD5GUjkbnxDrh3geLtfBffzwZh65Ys0P/xckU9Cj/KvaD91de7j+S/UKmLCZuSukc1xVXD5VooQ06cEW5EhgxEeUtsoar56F9KTv/+55LqG31j34AhFadnjTBChVbsvntPnX4mSm5tswgv4nkW4rUd2FJufUci9t3ktBrPJC7RxgyWTr8HSWtpDbiEYJ9AvQvGHeeoYBKjfr7xJWXTC1BRuhn1Iy+csIvpWMa+jsgZ6sVtNz8RTOjNv87hMeAPNfkI7uM8UATUnoomEqWL8erO2A56TSPwZUwG8/F5ff/rff9s4/siPae7qDR503FU1nCpGq7YiFzGBI60J8WOFCyfEtUU3D0EXqjSwNmYkpV6P6ns0ODVQNP/wT2N3YA/31wq4hGIbiu76/beS9BpgZccCit29ekk4fpKEasUef9VV03gXaa6Y/oKkvqYncTDH4lWXEm3tI8rALnRO+ZFu1RU8zDlwcw/r1J12AKhWRNo2Sfsiqn8EAVJ7c/nCfIVJGU2gdN7kiMXDALx1itqVyjBYBC5msTYDvtbPQ/TiPsQ9XLJlrN5TFlf1FGHjj2b6GQZWIw45ixXfJO5ZgRIPj5V98bs1MjLK8Psk+hQfNRm+sDPAGT2Ge2s+5IzZo7
 TYz0U7+8
 cZ6+Ffm2GIjED++s2SafAZ8v3H4q07ngqPMlDfzJGlCaeC0mq9b6zLBzUDMa54fZ1OW1cfuX5GBbbJPMNjLMajtk0+6WLXi+aTtCayg9ZksuYlWug72P7Vnwej8xCcMvsF+lMrkA48ZrzgrAdHm2P/CMY+a7BhVBV3KIjvn21qV8R68AVXmlRRon1tMk76IyETfl1V1ZNs/a4hVufpE2fE+lRp/+oIGNKDoVy2WBxQOiQwP7R2S1w72CFw/wJbfYDYpyBp8vNfsNr18DE6d+lQhGBYYdg4U+7uzQvuVtURNkqiWzVAM5uwJyVysg0+JDevkDd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 11:12:22AM +0530, Dev Jain wrote:
>
>
> On 10/03/26 2:19 pm, Lorenzo Stoakes (Oracle) wrote:
> > On Tue, Mar 10, 2026 at 01:00:10PM +0530, Dev Jain wrote:
> >> Teach folio_dup_swap to handle a batch of consecutive pages. Note that
> >> folio_dup_swap already can handle a subset of this: nr_pages == 1 and
> >> nr_pages == folio_nr_pages(folio). Generalize this to any nr_pages.
> >>
> >> Currently we have a not-so-nice logic of passing in subpage == NULL if
> >> we mean to exercise the logic on the entire folio, and subpage != NULL if
> >> we want to exercise the logic on only that subpage. Remove this
> >> indirection, and explicitly pass subpage != NULL, and the number of
> >> pages required.
> >
> > You've made the interface more confusing? Now we can update multiple subpages
> > but specify only one? :)
> >
> > Let's try to actually refactor this into something sane... see below.
> >
> >>
> >> Signed-off-by: Dev Jain <dev.jain@arm.com>
> >> ---
> >>  mm/rmap.c     |  2 +-
> >>  mm/shmem.c    |  2 +-
> >>  mm/swap.h     |  5 +++--
> >>  mm/swapfile.c | 12 +++++-------
> >>  4 files changed, 10 insertions(+), 11 deletions(-)
> >>
> >> diff --git a/mm/rmap.c b/mm/rmap.c
> >> index dd638429c963e..f6d5b187cf09b 100644
> >> --- a/mm/rmap.c
> >> +++ b/mm/rmap.c
> >> @@ -2282,7 +2282,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
> >>  				goto discard;
> >>  			}
> >>
> >> -			if (folio_dup_swap(folio, subpage) < 0) {
> >> +			if (folio_dup_swap(folio, subpage, 1) < 0) {
> >>  				set_pte_at(mm, address, pvmw.pte, pteval);
> >>  				goto walk_abort;
> >>  			}
> >> diff --git a/mm/shmem.c b/mm/shmem.c
> >> index 5e7dcf5bc5d3c..86ee34c9b40b3 100644
> >> --- a/mm/shmem.c
> >> +++ b/mm/shmem.c
> >> @@ -1695,7 +1695,7 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
> >>  			spin_unlock(&shmem_swaplist_lock);
> >>  		}
> >>
> >> -		folio_dup_swap(folio, NULL);
> >> +		folio_dup_swap(folio, folio_page(folio, 0), folio_nr_pages(folio));
> >>  		shmem_delete_from_page_cache(folio, swp_to_radix_entry(folio->swap));
> >>
> >>  		BUG_ON(folio_mapped(folio));
> >> diff --git a/mm/swap.h b/mm/swap.h
> >> index a77016f2423b9..d9cb58ebbddd1 100644
> >> --- a/mm/swap.h
> >> +++ b/mm/swap.h
> >> @@ -206,7 +206,7 @@ extern int swap_retry_table_alloc(swp_entry_t entry, gfp_t gfp);
> >>   * folio_put_swap(): does the opposite thing of folio_dup_swap().
> >>   */
> >>  int folio_alloc_swap(struct folio *folio);
> >> -int folio_dup_swap(struct folio *folio, struct page *subpage);
> >> +int folio_dup_swap(struct folio *folio, struct page *subpage, unsigned int nr_pages);
> >>  void folio_put_swap(struct folio *folio, struct page *subpage);
> >>
> >>  /* For internal use */
> >> @@ -390,7 +390,8 @@ static inline int folio_alloc_swap(struct folio *folio)
> >>  	return -EINVAL;
> >>  }
> >>
> >> -static inline int folio_dup_swap(struct folio *folio, struct page *page)
> >> +static inline int folio_dup_swap(struct folio *folio, struct page *page,
> >> +				 unsigned int nr_pages)
> >>  {
> >>  	return -EINVAL;
> >>  }
> >> diff --git a/mm/swapfile.c b/mm/swapfile.c
> >> index 915bc93964dbd..eaf61ae6c3817 100644
> >> --- a/mm/swapfile.c
> >> +++ b/mm/swapfile.c
> >> @@ -1738,7 +1738,8 @@ int folio_alloc_swap(struct folio *folio)
> >>  /**
> >>   * folio_dup_swap() - Increase swap count of swap entries of a folio.
> >>   * @folio: folio with swap entries bounded.
> >> - * @subpage: if not NULL, only increase the swap count of this subpage.
> >> + * @subpage: Increase the swap count of this subpage till nr number of
> >> + * pages forward.
> >
> > (Obviously also Kairui's point about missing entry in kdoc)
> >
> > This is REALLY confusing sorry. And this interface is just a horror show.
> >
> > Before we had subpage == only increase the swap count of the subpage.
> >
> > Now subpage = the first subpage at which we do that? Please, no.
> >
> > You just need to rework this interface in general, this is a hack.
> >
> > Something like:
> >
> > int __folio_dup_swap(struct folio *folio, unsigned int subpage_start_index,
> > 		     unsigned int nr_subpages)
> > {
> > 	...
> > }
> >
> > ...
> >
> > int folio_dup_swap_subpage(struct folio *folio, struct page *subpage)
> > {
> > 	return __folio_dup_swap(folio, folio_page_idx(folio, subpage), 1);
> > }
> >
> > int folio_dup_swap(struct folio *folio)
> > {
> > 	return __folio_dup_swap(folio, 0, folio_nr_pages(folio));
> > }
> >
> > Or something like that.
>
>
> I get the essence of the point you are making.
>
> Since most callers of folio_put_swap mean it for entire folio, perhaps
> we can have folio_put_swap for these callers, and the ones which are
> not sure can call folio_put_swap_subpages? Same for folio_dup_swap.
> And since we are calling it folio_put_swap_subpages, we can retain
> the subpage parameter?

Right but I'm talking about dup variants here but the principle is the same.

>
> >
> > We're definitely _not_ keeping the subpage parameter like that and hacking on
> > batching, PLEASE.
> >
> >>   *
> >>   * Typically called when the folio is unmapped and have its swap entry to
> >>   * take its place: Swap entries allocated to a folio has count == 0 and pinned
> >> @@ -1752,18 +1753,15 @@ int folio_alloc_swap(struct folio *folio)
> >>   * swap_put_entries_direct on its swap entry before this helper returns, or
> >>   * the swap count may underflow.
> >>   */
> >> -int folio_dup_swap(struct folio *folio, struct page *subpage)
> >> +int folio_dup_swap(struct folio *folio, struct page *subpage,
> >> +		   unsigned int nr_pages)
> >>  {
> >>  	swp_entry_t entry = folio->swap;
> >> -	unsigned long nr_pages = folio_nr_pages(folio);
> >>
> >>  	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
> >>  	VM_WARN_ON_FOLIO(!folio_test_swapcache(folio), folio);
> >>
> >> -	if (subpage) {
> >> -		entry.val += folio_page_idx(folio, subpage);
> >> -		nr_pages = 1;
> >> -	}
> >> +	entry.val += folio_page_idx(folio, subpage);
> >>
> >>  	return swap_dup_entries_cluster(swap_entry_to_info(entry),
> >>  					swp_offset(entry), nr_pages);
> >> --
> >> 2.34.1
> >>
> >
> > Thanks, Lorenzo
>

Cheers, Lorenzo

