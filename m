Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6DBEC5DF6D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 11:24:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C43316B0092; Wed, 19 Aug 2026 07:24:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF3AA6B0093; Wed, 19 Aug 2026 07:24:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABC996B0095; Wed, 19 Aug 2026 07:24:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7E9486B0092
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 07:24:30 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 170F280512
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 11:24:30 +0000 (UTC)
X-FDA: 85117785900.05.5846BD5
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4BDE71A0005
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 11:24:28 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EYM+FNCr;
	spf=pass (imf19.hostedemail.com: domain of kmanaouil.dev@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=kmanaouil.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787138668;
	b=x9XMpaPjNEsH+BGoFd23AaJIulxQx/H4gmKCH0P4LDh+iFSnYcMyHqEmZhzwj4GRpP9g6y
	pEQDqMqSYdFHqG/leJmJRv85LpA0hGI+jlctJd3fbsfQO+4OIFeCio2RrdtxSc5QHlvMP7
	YnyqNVON+ymi38KsEr5gsWHy0RVkFhQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EYM+FNCr;
	spf=pass (imf19.hostedemail.com: domain of kmanaouil.dev@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=kmanaouil.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787138668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F3NgZBE9hRs9qXlD6E6LALHZpzbe9DU4fqAWKNGx43k=;
	b=7Gj/QWAjhUwRjHAw3gctxeYAXl84rA3y7mMVdmw4H0CDNjyJ5qfQgjNFywsgwTS4g/Brs/
	qipSrlbNse/PVYr5oDJtPyv256d57XnS4Crz+gBHujBKIqoCel0EYyI3TnWgvb5RNaONnK
	3+xUWmW3lmJfFp1mzBOZSmCzxXf8RA0=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4953de5be0aso7371475e9.0
        for <linux-mm@kvack.org>; Wed, 19 Aug 2026 04:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787138667; x=1787743467; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=F3NgZBE9hRs9qXlD6E6LALHZpzbe9DU4fqAWKNGx43k=;
        b=EYM+FNCrTRv+le9GkWbAXQTsXYb3LLGlvd2YcBuG0YoyY+lvwkGSJd9pJbCpQmsfO6
         3i90zI6omejWWbgvh1IqEusB38huGOZ1BbdTXx0C55usMk7yucAPZ7Ml+0FgQEMjp03q
         8oMEHb5V/vSPjsuFnaJdhQEtp1oDm34sM5GaYLUqyfzeIylNszKHHrdCwmAg7XS03/gz
         VZ4tGxsHAF3hxYKpIw8nJbwl9IkrB8z2WWITDp5cokm8DKqSldAthcjD1JL5Q3vsIxey
         nrtfQExhuv6XFIxFXM9407sZul7uPPoIr13zYOpF0u7A+0i+6gVz2b7cDV3PxBNFdyac
         mWuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787138667; x=1787743467;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=F3NgZBE9hRs9qXlD6E6LALHZpzbe9DU4fqAWKNGx43k=;
        b=jWf3qmCOYxnexK9QFW2pGlX7OEKQ09C42YnxWwXrB5UeYdTUXyTtqlush0P/HwQlKk
         jfWiv2cPsy7QKV0WPmk0+xxKyj0s4B3VXbPnfqHZwhoapQTLp+h/dJqPMvxd0UlDBkK7
         8Ntq1cPeR9r3hTVyohIdVtwY5fncC9UVMz2qkXUIGv/jlHCxe6Qq+FshaJ42wzrAtE0D
         EMai/YNbboGnWSztzPuZ8R6hE5UncPZE1Pf/i+EGuylANABd1GZ058LEEag8l07sfy8L
         uVeMQXUf75KlJdWSJ/bg7ui4V/4yQCDQ7vKw0+7Hj6EfdGv51DvnjzcJEYtos+iVPVJV
         6NjQ==
X-Forwarded-Encrypted: i=1; AHgh+RrAoUeHqiIJC5w0AmVGIx7sRCuj2K/+1xastHQtmrD2FL6xTrZVgxEEvcFkKRVhfdPdW9/YoWi+bQ==@kvack.org
X-Gm-Message-State: AOJu0YxVFeLvIjQNtCv9Un8c8adyywshXaYQOl8ihAS8M+VV/bb/jrvi
	HY1kbivcy04vxAQXV7SWPtwVXKQjLGMBkbWln1KtL0/d+8YUuCgm1cUV
X-Gm-Gg: AR+sD132oflP25kAUS5pSW10+Ry9K+hP2rKQyBN4lxogukjUIDubUZOgZXzz9V9zHwU
	/0XcjED1YlhaNCzKC4rJjZPrNXwXEmq1Axu4BVshZytA4xXsw285bXyrwhaO7edTmyaUou6+ux8
	ELSO6sniY0dmrj7g4aODNwhPNk0+p/TFL6iMlNtTUJy/+/35hkisNXfZR5hHOxzs8BAFNCZhb5o
	CmPD0PsgVzg5i8UUiZSmVJkIEJ+9mriHGgGH4gJcCNs5BQmebopYr2klnMVaI2BO4d8JEd8dkjw
	0OQ4rm8RliR9vKQMmqNUc3qaVTlKYeRkesc6EYDtiXnrqSQdz+iYSfs0xJwzzT+MRpa8kP5SqPh
	jBW1GdPcFRHvy9SA3MVu49xigFfT5uCOrwV1VrDNx2+HbiNR1F8VHCoMD7Mc/Qa8iZmcD+fCHPD
	BmFO0xlDlgKLXb7ePc3YQs4bDRFa6h6mgOgMrpKggXdkuZnk6V/ZfcH2JbXiVMSQWeH/69KZj7n
	EMc+Jce7rTBno7uv8UzF2UjaLW557XjAcvPmXh8FkcwbU+edsgPRviymJAMKus8zn5y5u6b
X-Received: by 2002:a05:600c:a05:b0:495:3da3:beb with SMTP id 5b1f17b1804b1-499aa1b6a02mr61478655e9.10.1787138666712;
        Wed, 19 Aug 2026 04:24:26 -0700 (PDT)
Received: from localhost (pat-125-254.wlan.net.ed.ac.uk. [192.41.125.254])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482b1441753sm5668998f8f.5.2026.08.19.04.24.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2026 04:24:25 -0700 (PDT)
Date: Wed, 19 Aug 2026 12:24:19 +0100
From: Karim Manaouil <kmanaouil.dev@gmail.com>
To: Shivank Garg <shivankg@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Rik van Riel <riel@surriel.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Frank van der Linden <fvdl@google.com>,
	Kinsey Ho <kinseyho@google.com>, Wei Xu <weixugc@google.com>,
	Bharata B Rao <bharata@amd.com>,
	David Rientjes <rientjes@google.com>, Dev Jain <dev.jain@arm.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/7] mm/migrate: split remove_migration_pte_hugetlb()
 out of remove_migration_pte()
Message-ID: <20260819112419.n4fkhvbxxfhsyhun@wrangler>
References: <20260813-migrate-rmap-batch-v2-0-3c5424c555c7@amd.com>
 <20260813-migrate-rmap-batch-v2-3-3c5424c555c7@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260813-migrate-rmap-batch-v2-3-3c5424c555c7@amd.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4BDE71A0005
X-Stat-Signature: 6xtghog1a6tgsn3oh5gwpa5wqjbqn3bj
X-HE-Tag: 1787138668-297271
X-HE-Meta: U2FsdGVkX19+zlBKcntdIJhHfWsa8PotOX/7Df9GYPuFDcHjm2eCnwBT5VT8O5z6aoZOwicb7t97WThrslvW52iSTdozXjhuUX9E+t+GIbv5fsbf8EtjEAt44Kd/cYkSknHtoy4C4+BMGx96GCSvY8PRgDudt/vtMGPWF6v7cFG3EAIl/yC+6XpyKVFbu34z0vtRRbrtg952FzEdsrnQOBiB5n58x41loGtM5CETVXaKWO3TLH2AG6TgAM5jXAfTFKtjmrTTqPruZU4iJ8kPR+bhlh/068OJpiD7RuZ84QcqVXD4qb/Pv7vxkt1PUjnsB33rmaJ1HqhrL0I5YJYO1Lp9ln3hL60x4QqZ/Lt/0S56RSax5URkTpADvA04LEPzndnF8DtXh6Zi3it/lbpPmDRZ/kn4et4Wmn83SAmoG7iFohkHkBCcYdPNQG8mRYqA93i9Xgd+q1//JeMIw65Dlycx1yycz9cVla44W6mY/NfgfWqaeF4SnNeTaLCNiV9Lue95jyKfWWs9oyuXHoKxnQ1FVCtSRki6bcSgJCBMnUdOMeyqINWwXuzld9O1UuqOBcin0eoOR7QsPB9K8gq+ADfMpw5HTQ2zcgXHBKYdyT5PgqH+WUqThfNIa+3/CC1iw91lMHHE6r6lix8fZ4Mo74JOw/WUkeTVYBf/48JSlrK0p6R/xGhYwboNpKqZ6l04HbGJ8LBbyM+3rz8N2ZJtwLnY6Tnu8iXz9mumujod3MVPo4rkvsT0Ty7wBObPuMEc4SEnzlUkWsniq2RUmLOGzWU+dU7pds5DRxgq2HWI2ky9YUAXjkVzUBB0dUmci3eYnKRUo5t0gCOq5D0uxwZWlFusRRcX9g2/rBpNjqG5dhbrK1GZhSIhtwaMlpfZOzn2ksUmw6is2eFuL/vp5Kg9lmVZxRl8TVAT+PxTBwRtptC8/Ri3HNzxut+zt+ziHz7gxrCDKTqqDy65NW4TL9w
 sxA28brS
 VtJ80LJ4bE4PYw8PQ/u9ZbQqZVtYEu1aiHmSDIBDeefLC6El2DUb056PSCfV/68LrPlSnYVhkiV1qIy9fQ0bXtC7dMYxlxgeOnlInDa8H+We+tQXoV6wrFYFDjxZ4euRpuIY9aByqTlJHDmf25LGBz267kyg8n9+vGZiMB4sbCNkpQr7I3C5pmi89fjiS/TnRKUQv7kxX4X/A7KxUrUxT89IVp2a3xa2cq/CEM1oONP96ER//wcUDgZq5GNiApClMuxSGQHWBYFc67muXTTHdn0vq+X94zZPGeUyIC5BOSpC31FsSWD+3FBQOqFs6XUJ3XvbTO6ajwgVkt7E37QProC4GvLmMbhMfR5UPNDPZYJbyi0igwiaTkf/nejvlDNOmRkWZhKMmqZJQh0Ec76MFAqWJwKYhmlMplIQzkUh5iiQEXY7zLtjjN9rxM0f6BYpnBkOD8noO1dNFKw/xy9Qdz+OVAM0ZcqZANMJ9Vfk9/N28/Nj6Vbcrw8F84PE21SmXapJZaa70/siY2w4PeaPXZkX8VUPWvHIVr6QlhLg+gosj6TIvqXJG2A49pdG3Dkc2hRZkjoNPHvDbyAbYCpom1n25wWgpruvuPGGGf6RIXxiufQ2VVjSttEYhKw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Shivank,

On Thu, Aug 13, 2026 at 04:23:14AM +0000, Shivank Garg wrote:
> remove_migration_pte() interleaves hugetlb handling with the regular
> folio path. Move it into a dedicated callback selected by
> remove_migration_ptes(), leaving the generic callback focused on regular
> folios ahead of PTE batching.
> 
> With hugetlb folios routed separately, simplify the PMD mapping check to
> a one-time warning.
> 
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---
>  mm/migrate.c | 97 +++++++++++++++++++++++++++++++++++++++---------------------
>  1 file changed, 63 insertions(+), 34 deletions(-)
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index a3362cc9ef66..ee1b8a55a2a4 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -375,6 +375,57 @@ static pte_t migration_entry_to_pte(struct folio *folio, struct page *new,
>  	return pte;
>  }
>  
> +/*
> + * Restore a potential migration pte to a working pte entry for hugetlb folios.
> + */
> +#ifdef CONFIG_HUGETLB_PAGE
> +static bool remove_migration_pte_hugetlb(struct folio *folio,
> +		struct vm_area_struct *vma, unsigned long addr, void *arg)
> +{
> +	struct rmap_walk_arg *rmap_walk_arg = arg;
> +	DEFINE_FOLIO_VMA_WALK(pvmw, rmap_walk_arg->folio, vma, addr, PVMW_SYNC | PVMW_MIGRATION);
> +	struct hstate *h = hstate_vma(vma);
> +	unsigned int shift = huge_page_shift(h);
> +	unsigned long psize = huge_page_size(h);
> +	struct page *new = folio_page(folio, 0);
> +	rmap_t rmap_flags = RMAP_NONE;
> +	pte_t old_pte, pte;
> +	softleaf_t entry;
> +
> +	/* There is only a single mapping in a VMA. */

I don't think this comment is necessary. page_vma_mapped_walk() clearly
explains what happens with HugeTLB entries.

> +	if (!page_vma_mapped_walk(&pvmw))
> +		return true;
> +
> +	old_pte = huge_ptep_get(vma->vm_mm, pvmw.address, pvmw.pte);
> +	entry = softleaf_from_pte(old_pte);
> +	folio_get(folio);
> +	pte = migration_entry_to_pte(folio, new, entry, old_pte, vma, &rmap_flags);
> +	pte = arch_make_huge_pte(pte, shift, vma->vm_flags);
> +	if (folio_test_anon(folio))
> +		hugetlb_add_anon_rmap(folio, vma, pvmw.address, rmap_flags);
> +	else
> +		hugetlb_add_file_rmap(folio);
> +	set_huge_pte_at(vma->vm_mm, pvmw.address, pvmw.pte, pte, psize);

I know nothing in HugeTLB, but can't they be mapped as 4KiB entries? In
which case we have to use

	while (page_vma_mapped_walk(&pvmw)) {
		...
	}

It seems like it's not the case from my little investigation, but
I'll keep it here just to be sure.

> +	if (READ_ONCE(vma->vm_flags) & VM_LOCKED)
> +		mlock_drain_local();
> +
> +	trace_remove_migration_pte(pvmw.address, pte_val(pte), compound_order(new));
> +
> +	/* No need to invalidate - it was non-present before */
> +	update_mmu_cache(vma, pvmw.address, pvmw.pte);
> +	page_vma_mapped_walk_done(&pvmw);
> +
> +	return true;
> +}
> +#else
> +static bool remove_migration_pte_hugetlb(struct folio *folio,
> +		struct vm_area_struct *vma, unsigned long addr, void *arg)
> +{
> +	return false;
> +}
> +#endif /* CONFIG_HUGETLB_PAGE */
> +
>  /*
>   * Restore a potential migration pte to a working pte entry
>   */
> @@ -395,20 +446,14 @@ static bool remove_migration_pte(struct folio *folio,
>  #ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
>  		/* PMD-mapped THP migration entry */
>  		if (!pvmw.pte) {
> -			VM_BUG_ON_FOLIO(folio_test_hugetlb(folio) ||
> -					!folio_test_pmd_mappable(folio), folio);
> +			VM_WARN_ON_ONCE_FOLIO(!folio_test_pmd_mappable(folio), folio);
>  			remove_migration_pmd(&pvmw, folio);
>  			continue;
>  		}
>  #endif
> -		if (folio_test_hugetlb(folio))
> -			old_pte = huge_ptep_get(vma->vm_mm, pvmw.address,
> -						pvmw.pte);
> -		else
> -			old_pte = ptep_get(pvmw.pte);
> -
> +		old_pte = ptep_get(pvmw.pte);
>  		entry = softleaf_from_pte(old_pte);
> -		if (folio_test_large(folio) && !folio_test_hugetlb(folio))
> +		if (folio_test_large(folio))
>  			idx = softleaf_to_pfn(entry) - pvmw.pfn;
>  
>  		if (rmap_walk_arg->map_unused_to_zeropage &&
> @@ -434,30 +479,12 @@ static bool remove_migration_pte(struct folio *folio,
>  				pte = pte_swp_mkuffd(pte);
>  		}
>  
> -#ifdef CONFIG_HUGETLB_PAGE
> -		if (folio_test_hugetlb(folio)) {
> -			struct hstate *h = hstate_vma(vma);
> -			unsigned int shift = huge_page_shift(h);
> -			unsigned long psize = huge_page_size(h);
> -
> -			pte = arch_make_huge_pte(pte, shift, vma->vm_flags);
> -			if (folio_test_anon(folio))
> -				hugetlb_add_anon_rmap(folio, vma, pvmw.address,
> -						      rmap_flags);
> -			else
> -				hugetlb_add_file_rmap(folio);
> -			set_huge_pte_at(vma->vm_mm, pvmw.address, pvmw.pte, pte,
> -					psize);
> -		} else
> -#endif
> -		{
> -			if (folio_test_anon(folio))
> -				folio_add_anon_rmap_pte(folio, new, vma,
> -							pvmw.address, rmap_flags);
> -			else
> -				folio_add_file_rmap_pte(folio, new, vma);
> -			set_pte_at(vma->vm_mm, pvmw.address, pvmw.pte, pte);
> -		}
> +		if (folio_test_anon(folio))
> +			folio_add_anon_rmap_pte(folio, new, vma,
> +						pvmw.address, rmap_flags);
> +		else
> +			folio_add_file_rmap_pte(folio, new, vma);
> +		set_pte_at(vma->vm_mm, pvmw.address, pvmw.pte, pte);
>  		if (READ_ONCE(vma->vm_flags) & VM_LOCKED)
>  			mlock_drain_local();
>  
> @@ -484,7 +511,9 @@ void remove_migration_ptes(struct folio *src, struct folio *dst,
>  	};
>  
>  	struct rmap_walk_control rwc = {
> -		.rmap_one = remove_migration_pte,
> +		.rmap_one = folio_test_hugetlb(src) ?
> +				remove_migration_pte_hugetlb :
> +				remove_migration_pte,
>  		.arg = &rmap_walk_arg,
>  	};
>  
> 
> -- 
> 2.43.0
> 

-- 
~karim

