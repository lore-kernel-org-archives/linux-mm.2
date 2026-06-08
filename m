Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6D8CCD8C9F
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 12:32:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4522E6B0005; Mon,  8 Jun 2026 08:32:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42A486B0088; Mon,  8 Jun 2026 08:32:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 366F96B0092; Mon,  8 Jun 2026 08:32:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 250F86B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:32:36 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BF5AD1C2CA1
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 12:32:35 +0000 (UTC)
X-FDA: 84856683870.15.09D8C18
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 113CF4000C
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 12:32:33 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="BokOJ/53";
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780921954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0S/mGlm2XVUNmf88aZNmWlasF/PmDk0YOd5RS53eddI=;
	b=lGI4Z7JartAMjwC5VDv7ZVXdYLL4NEPfrpVBjzH3lgMNIh0ccKRkQtwkOZP5zJ8/IR5ngI
	HNURsKU+fV3HWOSTiNWjdHcq9WxH62nKYEy0aAXoYkzZZAVRaKeStUp8EiBVdu7DaRNR0w
	9xS0AiYeXfe6J/FhcwIKGgwoMYwat+4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="BokOJ/53";
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780921954;
	b=jDeSRKGqaBsA1/id5nFyqeacJhdaIkvSLzaut3UBwX2igfuV7u4kru3W0wVPddGYWs0YVK
	AuL1TmYLawKOtkOKN7W1haLPToXt5Or4IPCocFcp+XErp6v8yal47inBT02uuYgc5+Bozj
	pi87IIJr2l+mdkPPmbquuW35caNFGVY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3ABE1434D2;
	Mon,  8 Jun 2026 12:32:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 689F31F00893;
	Mon,  8 Jun 2026 12:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780921953;
	bh=0S/mGlm2XVUNmf88aZNmWlasF/PmDk0YOd5RS53eddI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BokOJ/53zXQSSC08VD4iug5xPluwrLQ0Ns/1S+/wn18UiuwksvNkniq3qN2FiyewF
	 GMuvCqRpVL0AlJs6aH6tV8YnDN6p+tnV36+1VnBfbTg0jLsYa8433FvIyLHiH3L8yt
	 htaAfUxpnK80iRWeE/PmXHjXPd4o8iNJJ3tVHTfoDnfYO85+edAF3UZK+nO5rForZG
	 /e0J1UFqLl49pfl5O5uW9t+z+yty8dCmRSFwYT4x34bo+/LfAw2X0dBGkMs0gnUA5O
	 LsnRz9VdOFvVPpU9ZGJJYEmusi3LUDyWanA4z1E41tVtyd4j0FxP+4OJa44yqGoh7E
	 qNprUiV5urzPg==
Date: Mon, 8 Jun 2026 13:32:20 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, virtualization@lists.linux.dev, 
	linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v10 27/37] mm: use __GFP_ZERO in vma_alloc_anon_folio_pmd
Message-ID: <aia2G06-ZjsTSD2u@lucifer>
References: <cover.1780906288.git.mst@redhat.com>
 <2ee827fed4765a155d2b56bb0e13d7ee5fc6dce8.1780906288.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ee827fed4765a155d2b56bb0e13d7ee5fc6dce8.1780906288.git.mst@redhat.com>
X-Rspamd-Queue-Id: 113CF4000C
X-Stat-Signature: 3yjc784iopask1kzgg1g4943cenb9qon
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780921953-746287
X-HE-Meta: U2FsdGVkX1/wvoBc+YHWdmEz+bGfj4Slha6ul2WYqNmVi69czkfjS9/3oIguvklXT5LtqXcxRRnJ5J4F6tIBb4OLBXkO2JJuhtMyCEGQWx893ztJFwMBZdEPsTvF85dOLGVE81KRX+FgzgyluSUvS+5jJPheR9dRVCOjehA2E03Q6EOs7T/K8ANElAFU2wubxk6c0smVf+w940jc8jc4DFFR1rXWkU16dOK4Y8dgKnW2plPXi/9jr8irq6CKHxQ+Kbvxb5bIhNVyeTYU0IdRcLvYkI6Jbgs4/gP9Y/zn2mJ0KE2jW5eDTpScskkRiZyV0MBCBp0IJyLJNP2dC6DmttgzGlsuq4tF6J/bGECMV92Eb56iU3G7GAieNkl/dpHMdGVxsfW8WNcpmO9ecqBmS06bCXNLn/2p+ZVF9sqUmHU74KfdamSemf7GbUTM6ZucDw4aEL9FtYzK9jV80fp0qWcLCewBA4XgfjtmWvQbmmhe5GuuysJFZp6fFMt2A8FOUvgsoQSIb6v1ZnD27o0nCmGDXbcGBLBKwejrJQv2h048o9QSYEAAhuChdaH1p4tSUXV4Q1ODOwvOURvq2f8Opt56jV6KMc1yfbw9kxQXAjw9uPUkSPgPSQpUezM8iFv+8aqdsL8SJCeW427VMGfSFHepImkPhitH3iRe1qJOhzmJyIiJuFW80XSUvbCMcNU55qWhkkJ7STRkdZJQhXMk2uAdG+i+N0nM35Gywfibx1SbpXRr8a4nEwvCJ2hFfr3AFkvvO30Fk1ZDFoyi2IWDSh9XGyyAow5roBgsCH2lNlXORcTBlj7LhQm71IOZzu1oQ5C1wo41VFVvVURWe1kcJaCdbQ7ZQUwumzg3yFluGFYtvJQ0z56Js+qgquS/PMuwxf1/AFQbTd6DFKax6w5oq2ilAnWvBvPFny7CTa0MHo32owDxFq9gLsZLhZ5j70XvU7yiZNL3iJVwKvMaMeV
 06UG+75i
 zY/4dObL6eh14TDlI/uCH53WkF0pmTNc+Cby9MJ01gGU4/EZPw7g+/FcJxIrNDz8xNSEfHCqsPyuu57lfvg/luiONY3Lxg4IZc2BED8wkS8zsu8XM0f/Qv8fBGXmfj1SIQoQigcJQ036o/agr2QKmjib9qknsJBV0TPh9OYP9y9G5afUNElsfIXI76NLQuubVC55mL1PonodQ8bQxXpVkQs0eW0VmchwSqzXV1nb1dwylkyoedsLixW3x1PBQo1pvijrsRUdYEccXpe0jbACKf1Yg/dvjUwrNQOXKM1bFNP4Um1SgHPSuh8VXfDnPAnMYr3uzi44dyhzC2B+i6EmirbjRwKyiIzr0XvcLuvAjKnfjDKHuzzCtXGIca9oBQCKiguhwYvKzFw707cipoTjSgk6oZYxEJBZ1/4cwebTF46TiWrhAPBBiiAtj5+niF04bXJMfvlIVxmlh3pc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 04:39:18AM -0400, Michael S. Tsirkin wrote:
> Convert vma_alloc_anon_folio_pmd() to pass __GFP_ZERO instead of
> zeroing at the callsite. post_alloc_hook uses the fault address
> passed through vma_alloc_folio for cache-friendly zeroing.
>
> Note: before this series, replacing folio_zero_user() with
> __GFP_ZERO was unsafe on cache-aliasing architectures because
> __GFP_ZERO uses clear_page() without a dcache flush. With this
> series, it is safe if the caller passes a valid user address
> (not USER_ADDR_NONE) to vma_alloc_folio() etc., which delivers
> it to post_alloc_hook() for the dcache flush via
> folio_zero_user(). It is only unsafe if USER_ADDR_NONE is passed.
>
> Note: with __GFP_ZERO, the folio is zeroed before
> mem_cgroup_charge().  If the charge fails, the zeroing work is
> wasted.  Previously zeroing was done after a successful charge.
> This is inherent to moving zeroing into the allocator.
> Charge failures are rare (only at cgroup limits).
>
> Use folio_put_zeroed() on charge failure so the zeroed hint
> propagates to the buddy allocator, avoiding redundant re-zeroing
> on the next allocation attempt.

Again, is this worth it?...

Every bit of code added increases risks of bugs, maintenance burden,
etc. let's just not do stuff because we can.

>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Reviewed-by: Gregory Price <gourry@gourry.net>
> Assisted-by: Claude:claude-opus-4-6
> ---
>  mm/huge_memory.c | 14 +++-----------
>  1 file changed, 3 insertions(+), 11 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index d689e6491ddb..0dec3c717ff2 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1333,7 +1333,7 @@ EXPORT_SYMBOL_GPL(thp_get_unmapped_area);
>  static struct folio *vma_alloc_anon_folio_pmd(struct vm_area_struct *vma,
>  		unsigned long addr)
>  {
> -	gfp_t gfp = vma_thp_gfp_mask(vma);
> +	gfp_t gfp = vma_thp_gfp_mask(vma) | __GFP_ZERO;
>  	const int order = HPAGE_PMD_ORDER;
>  	struct folio *folio;
>
> @@ -1347,7 +1347,7 @@ static struct folio *vma_alloc_anon_folio_pmd(struct vm_area_struct *vma,
>
>  	VM_BUG_ON_FOLIO(!folio_test_large(folio), folio);
>  	if (mem_cgroup_charge(folio, vma->vm_mm, gfp)) {
> -		folio_put(folio);
> +		folio_put_zeroed(folio);

Same comments as previously.

>  		count_vm_event(THP_FAULT_FALLBACK);
>  		count_vm_event(THP_FAULT_FALLBACK_CHARGE);
>  		count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK);
> @@ -1356,17 +1356,9 @@ static struct folio *vma_alloc_anon_folio_pmd(struct vm_area_struct *vma,
>  	}
>  	folio_throttle_swaprate(folio, gfp);
>
> -       /*
> -	* When a folio is not zeroed during allocation (__GFP_ZERO not used)
> -	* or user folios require special handling, folio_zero_user() is used to
> -	* make sure that the page corresponding to the faulting address will be
> -	* hot in the cache after zeroing.
> -	*/
> -	if (user_alloc_needs_zeroing())
> -		folio_zero_user(folio, addr);
>  	/*
>  	 * The memory barrier inside __folio_mark_uptodate makes sure that
> -	 * folio_zero_user writes become visible before the set_pmd_at()
> +	 * page zeroing becomes visible before the set_pmd_at()

folio zeroing?

>  	 * write.
>  	 */
>  	__folio_mark_uptodate(folio);
> --
> MST
>

Thanks, Lorenzo

