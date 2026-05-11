Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B693CD37B5
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 07:45:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8406F6B0088; Mon, 11 May 2026 03:45:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F0C26B008A; Mon, 11 May 2026 03:45:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DF586B008C; Mon, 11 May 2026 03:45:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5FFA16B0088
	for <linux-mm@kvack.org>; Mon, 11 May 2026 03:45:11 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0A89FC22D7
	for <linux-mm@kvack.org>; Mon, 11 May 2026 07:45:11 +0000 (UTC)
X-FDA: 84754353222.13.833608A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 54675100013
	for <linux-mm@kvack.org>; Mon, 11 May 2026 07:45:09 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HSnzbyjo;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778485509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D0j2xMwk0vUPlfOGZ5PJP3aRy8JQJKvr+3DOexbKMBk=;
	b=67WZyseQ1jr5uirbkhJVT9WAE+gn/pGtmuCdgM6Y4rxMvqb7PNiml5zCHiLWKbucno2m1J
	HtKjyXydmrJ7Q0+7DXGRSikz2nn1nmWOct6YbRtDkUstlndY1i9LVOxsQQIHS0ewbEmHLJ
	x1M8NNWql99OgFiuG9xzQ3gMIEUgsU8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HSnzbyjo;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778485509; a=rsa-sha256;
	cv=none;
	b=O/Uega+Nf1o14gt6HEQj78XXOFCKoS3fNyNz5WHeSwP8zAg6DAkncy4pUsRb3q9w2+JerX
	NZiEIwlokr6JaAI+ntgaKqDloLGJSoxeGnC0C8i0McGYRb84TrMppUAoRmxRmYCSe91yLo
	mZ0FdbLrBeQds51Rl24sFTFxuJOBq7U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AEDEB6001A;
	Mon, 11 May 2026 07:45:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AE89C2BCF5;
	Mon, 11 May 2026 07:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778485508;
	bh=Tmv8ILQJ5wFGpDEILVDxUrZCNZ3sVrCAo9Z+GYKi18Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HSnzbyjoPHLcDNg8wlL50dd+VZz1jbN7fZitBE+z496M1da5A4NhJiASFFpGgEi5S
	 e112+KN4u9dnQJhSDL8MDwPglBj2fXLFJQPAd0w2ruAZqKGPPAiaYhOMI8b/AL6HxT
	 a9tpl1VPuef3eSBomRPpJ1DKx2ToORKCOfRZb9rmJ9COZziiXgPEyf0wrsJNz7+zs2
	 hEX+z2lsMJQa44mwa0egbTWBAdpcvVCm5Q4rKN40KQMuXbHeSilLlUtiZCEbyuq0EO
	 HSfz4wiPXf4Ndzg6h22nVIvu7Om1Oeid4KoGKDvpADDnZtAHSshRUfxjaBtieTocPD
	 MlAWbywJb5jPg==
Message-ID: <871d9a91-2d14-4dbb-934d-b52c12dae7cd@kernel.org>
Date: Mon, 11 May 2026 09:45:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/9] mm/swapfile: Add batched version of folio_dup_swap
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, ljs@kernel.org,
 hughd@google.com, chrisl@kernel.org, kasong@tencent.com
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 bhe@redhat.com, youngjun.park@lge.com, pfalcato@suse.de,
 ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <20260506094504.2588857-1-dev.jain@arm.com>
 <20260506094504.2588857-7-dev.jain@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260506094504.2588857-7-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 54675100013
X-Rspam-User: 
X-Stat-Signature: nbtnpsh49hmgse471n4qjueemgumpwka
X-HE-Tag: 1778485509-756107
X-HE-Meta: U2FsdGVkX18vJ6hHLXUdlfNNCh0mep0T9n7XLPvl9vaAwul0UvRXIlkrxjFkPUYE2aW907BbyjNerHWD7so1y7uc3vFKZnFYivtv5xLWtEkV/Eqb0R4FskE3b8NvLX39M3QGPuNSHWDUG7XCKuLvyLzUcjETS1I4ASX1PUl5adB2hiFdfhTJO8+HbOwOd7iXC4R2HqwCnpcyvZJIcNGVHfxM3A9KyJoNuScpoHtWgu1yvlON9tFCEBomyd97zMWqiD8amNgemmBownDHhFOD5ppMNxrZybLIl/FdCfArP9sCEU0d3FM8GK8Msae2Twc3sH+wPpEAYLNihYzje/0Tf7hoEjD1wMtJ8k4XBUEu1aqbO9SqxpDoN5olrEaSfreX+94xZ4zSYlwp34WcrgGqFwzi56X3SZvcl4d9LdnqcfEfQavK0RlvjAOuSlKkZBw99u+VNmjY/v0gVsIhnpVc9fso1ApS7X7SoVCwdu3mhnDl9Cs0gjVpaUc39TsCD/Uq1M5nbawteM5tz5AM3UGWob38aZVELCfhFDqdL0KnSeZZ/JDRGYjyHXxdnObuh94e7VYyTg23J+OUEUWwFLbYl7THHUMGQNh4e/Zx0wOFMcIYNUhR7L4eELe/m2XHH45ugQYwk+mjxZl6cXp4P/LMr7A55dbLxF6R/y0yBHUCKP2+PN9NEeSb28/xTKmjr7qRNubWcIdguhvx8CXdOA335w97EW7DdRjvEqmUogjWHDmhkQKupAhWmAfOYHgVE2EljbxfN+IhoUJn7G3ZSdhbuhfPlS4KZ4vE2/aa/mNv+4EE8eqAbMeoQJJdVNCoST91fKPdJG+101l6iq1v4T0b19a4dTVcFQucAjKibVVRvXiAyxhaKy9GEltU8mCmg1LwpXmNpNC95Ie9R+SuIEcf5tU41OLDpB8uV2YSghxDYONnUT9eFO9G96If4mQxf7IuqiAemTToB9S7tORthZo
 V68PP6wi
 bgrI5ZKuyYQovn+X54O/gKTCWUSmOh9FoL2ojZRjCOvOHaEyvAs6aCXNm/QKeLNtq8rdOXGcBLHj7OwKooB+1UGnBtilEbDQcm24AmRaisJY8P0HkRdbq3jooUUZkecGnev/6qA+DSkCdwQ7zqXp92EjjJ3mve4xFyHLa54ADsVHb5exCjkyLGFcgJG1WrmqCU0TgDzGhn0YmJMhKsa/fMpwW9TncNeNqvyzRtRjI2mRGwr0vyflm2glLgR6mmWIws2EMVCru1xdN+N99EMtMEF1hXZVQzgogOvgEibdwYaOWzwB+I14bMdZ999+k7yvOjTr2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/6/26 11:45, Dev Jain wrote:
> Add folio_dup_swap_pages to handle a batch of consecutive pages. Note
> that folio_dup_swap already can handle a subset of this: nr_pages == 1 and
> nr_pages == folio_nr_pages(folio). Generalize this to any nr_pages.
> 
> Currently we have a not-so-nice logic of passing in subpage == NULL if
> we mean to exercise the logic on the entire folio, and subpage != NULL if
> we want to exercise the logic on only that subpage. Remove this
> indirection: the caller invokes folio_dup_swap_pages() if it wants to
> operate on a range of pages in the folio (i.e nr_pages may be anything
> between 1 till folio_nr_pages()), and invokes folio_dup_swap() if it
> wants to operate on the entire folio.
> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
>  mm/rmap.c     |  2 +-
>  mm/shmem.c    |  2 +-
>  mm/swap.h     | 12 ++++++++++--
>  mm/swapfile.c | 20 ++++++++++++--------
>  4 files changed, 24 insertions(+), 12 deletions(-)
> 
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 25813e3605991..352ba77d90f67 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -2314,7 +2314,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>  				goto finish_unmap;
>  			}
>  
> -			if (folio_dup_swap(folio, subpage) < 0) {
> +			if (folio_dup_swap_pages(folio, subpage, 1) < 0) {

Can you throw in a patch to rename subpage -> page first?

>  				set_pte_at(mm, address, pvmw.pte, pteval);
>  				goto walk_abort;
>  			}
> diff --git a/mm/shmem.c b/mm/shmem.c
> index bab3529af23c5..5e4f521399847 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1698,7 +1698,7 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
>  			spin_unlock(&shmem_swaplist_lock);
>  		}
>  
> -		folio_dup_swap(folio, NULL);
> +		folio_dup_swap(folio);
>  		shmem_delete_from_page_cache(folio, swp_to_radix_entry(folio->swap));
>  
>  		BUG_ON(folio_mapped(folio));
> diff --git a/mm/swap.h b/mm/swap.h
> index a77016f2423b9..3c25f914e908b 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -206,7 +206,9 @@ extern int swap_retry_table_alloc(swp_entry_t entry, gfp_t gfp);
>   * folio_put_swap(): does the opposite thing of folio_dup_swap().
>   */
>  int folio_alloc_swap(struct folio *folio);
> -int folio_dup_swap(struct folio *folio, struct page *subpage);
> +int folio_dup_swap(struct folio *folio);
> +int folio_dup_swap_pages(struct folio *folio, struct page *page,
> +			 unsigned long nr_pages);
>  void folio_put_swap(struct folio *folio, struct page *subpage);
>  
>  /* For internal use */
> @@ -390,7 +392,13 @@ static inline int folio_alloc_swap(struct folio *folio)
>  	return -EINVAL;
>  }
>  
> -static inline int folio_dup_swap(struct folio *folio, struct page *page)
> +static inline int folio_dup_swap(struct folio *folio)
> +{
> +	return -EINVAL;
> +}
> +

Much cleaner.

Can we have a common folio_dup_swap() function instead that does what the
variant below does? (call folio_dup_swap_pages())

> +static inline int folio_dup_swap_pages(struct folio *folio, struct page *page,
> +		unsigned long nr_pages)
>  {
>  	return -EINVAL;
>  }
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index c7e173b93e11d..28daf92839e77 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1740,9 +1740,10 @@ int folio_alloc_swap(struct folio *folio)
>  }
>  
>  /**
> - * folio_dup_swap() - Increase swap count of swap entries of a folio.
> + * folio_dup_swap_pages() - Increase swap count of swap entries of a folio.
>   * @folio: folio with swap entries bounded.
> - * @subpage: if not NULL, only increase the swap count of this subpage.
> + * @page: the first page in the folio to increase the swap count for.
> + * @nr_pages: the number of pages in the folio to increase the swap count for.
>   *
>   * Typically called when the folio is unmapped and have its swap entry to
>   * take its place: Swap entries allocated to a folio has count == 0 and pinned
> @@ -1756,23 +1757,26 @@ int folio_alloc_swap(struct folio *folio)
>   * swap_put_entries_direct on its swap entry before this helper returns, or
>   * the swap count may underflow.
>   */
> -int folio_dup_swap(struct folio *folio, struct page *subpage)
> +int folio_dup_swap_pages(struct folio *folio, struct page *page,
> +		unsigned long nr_pages)
>  {
>  	swp_entry_t entry = folio->swap;
> -	unsigned long nr_pages = folio_nr_pages(folio);
>  
>  	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
>  	VM_WARN_ON_FOLIO(!folio_test_swapcache(folio), folio);
>  
> -	if (subpage) {
> -		entry.val += folio_page_idx(folio, subpage);
> -		nr_pages = 1;
> -	}
> +	entry.val += folio_page_idx(folio, page);
>  
>  	return swap_dup_entries_cluster(swap_entry_to_info(entry),
>  					swp_offset(entry), nr_pages);
>  }
>  
> +int folio_dup_swap(struct folio *folio)
> +{
> +	return folio_dup_swap_pages(folio, folio_page(folio, 0),
> +				    folio_nr_pages(folio));
> +}

Can you add simplistic kerneldoc for folio_dup_swap() as well, and mostly just
link to folio_dup_swap_pages() ?

-- 
Cheers,

David

