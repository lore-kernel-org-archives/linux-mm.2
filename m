Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10BD0F531FA
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 07:45:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7572C6B0092; Tue, 14 Apr 2026 03:45:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72EA66B0093; Tue, 14 Apr 2026 03:45:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6440B6B0095; Tue, 14 Apr 2026 03:45:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 524D56B0092
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 03:45:51 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CFED41A04BD
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 07:45:50 +0000 (UTC)
X-FDA: 84656377260.02.5A942B5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id ECF66C000D
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 07:45:48 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Tpc3/16p";
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776152749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hRJBU7hLjdjXRVtmYnD7cC7LMsHtsXsb2gLC+/bs7Bk=;
	b=NXUYLyi6+oGF2TNY2wdORO4lLKg9ADs7WqRxazhWJD10OAioTGX+UBVsZAgE6Kyt90pCee
	B38Jj4IqQ+rQkKwdE36RI0Qv8U8RBTyxHeM+AVg69l+vx6YJF9ns14F/JsYZeCE7i6HCOb
	JprTZJk7zfYy5gLhEhj/2fu3RbEXgFk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Tpc3/16p";
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776152749; a=rsa-sha256;
	cv=none;
	b=RstnhBy6mx1f/AfhyRyRCEuElCqt5M2ro8mkEuq/8DbtVTAmy8Zv4BSjKuIvOYQYN4VE7i
	qLrR9FWA0zsBrCfv18k7tYDXpF091YjSGtBFRiiQbylwEvO5c4qYcJpYkWexa42vQecqfW
	Y2OF00MK3mIeFznbhXQuoL8Cdj+T3rA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 025B7443ED;
	Tue, 14 Apr 2026 07:45:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD2BEC2BCB3;
	Tue, 14 Apr 2026 07:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776152747;
	bh=8YRGWXu3wiw/rOiJ5YXZG0VoQSQDHS9BSPaBRiCQTO8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Tpc3/16pMuuS3Wda05+8uUT7Fz5jgD4nMbcEnMi2izRFD9blIaXjlXp14JbnRWTrB
	 JT2fpcXvPWUAwrYtut7UOjyMykRw17tLDVVew5tFC3hHxrK6kdDIkwBO8nQLdJ1Xt8
	 dc3UUIwKj2KL2jrFJ1u/aVJZLLjwFlUv4z/WvCatEBP1zHPqXV09BFYwm4YGXErkiq
	 RGAMYBytJD9Ku3CHxwKbmWJUix8W3+NYNlVjpyMthEv3UWsUcQYueTwWDdYytgnVZ5
	 mmm7//yHuGVjj3XaDWb7TAqaDMY9MsJWkdYY6ZZQS8eMT293M7cTmFYwGOe7jCoWp+
	 PknCms4rSx+4Q==
Message-ID: <48cd6ee2-d650-4731-a40b-832a17b07237@kernel.org>
Date: Tue, 14 Apr 2026 09:45:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 1/3] mm: process_mrelease: expedite clean file folio reclaim
 via mmu_gather
To: Minchan Kim <minchan@kernel.org>, akpm@linux-foundation.org
Cc: mhocko@suse.com, brauner@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, surenb@google.com, timmurray@google.com
References: <20260413223948.556351-1-minchan@kernel.org>
 <20260413223948.556351-2-minchan@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260413223948.556351-2-minchan@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: ECF66C000D
X-Stat-Signature: j1z4cdxmtybebdgkkwy6jbg4eg6t7ird
X-Rspamd-Server: rspam06
X-HE-Tag: 1776152748-191724
X-HE-Meta: U2FsdGVkX185YJoBj1nIGQaJ4LmgCnqrcS/V2oI2BUbQHOCiq1JhFuTpwKmGklrVXCcXWRlu7tjkD2lKE6D6GkNTWrtzQlGbU3BLoo4TpreZHVM7FgmzRrUwVXyfXJbYe7sKfau3GDKS/zRcD1cVG//yolOndlUxf9Bi0eS7Qik9jyrns5jzhlI68d/n8yFoMYXnZmKjTLJVxtN+cqZ9Zfhvl8aTSuA3cR8TKEf3/c952t5Bk7pG8mUw481eFyog/UVUZLEJ8Lw2PzTlyEP/DPj0fA2CP9zsYyaihKdTCyMHIoTRMNVD9r9djnq3sJCLTIcYLESUg4vx8JldIIaExFq78951emFFhhANwzlUllLZ+x1FHNh4gDXi2dVlqBxMFq4h8gVs5yeUukiHa6svqgP+boQfVbXaNqXsF8l9aeBNCvt6ydytO6MhU5L0S1aQBqcs1of5UoGD7tB+sBSjz8g9aCRn4pRCLec9vrMO424tSb4XiHXspX2iGgnlXt4JCklnlaqqe9MNSDQjLNymZoIzBWRxVtpotNpoa1WnMq08z2ZnMQ+cyzAGxTWGFruqnQg+8eanjmOCelMu6ogGabZNjzJQBM8OUalXXs9YU8RMmH066gBqx/OVXf6k6x26Dw6+4YBhbTzpbIfwO12C+YQkAI/Ux5ig07hXoK9PgxuH3eLNZa0hubgtBonZxu3QVZCN9vxuzUyh6EcIMERY4d44SxGjIOxo/VD37ac2tR6r7prwpOfJg4cC4m8xdhmtwjpMpeEXIQMjxAkL0Dn46UzSGp4mTHNVmwg1+5aTNrSlrNiMLlYnWB1rFhr0PBn/4gwgrhiB4ZCD4DMQjs4NLXFZroTmi+s/v5siIWgbCuBsA7NicoUbuVcf6mOXCOcQi1vuByoKgvo0LmtyDJ1p26My1FhG5pXtMvrfCYXSm9vayeK0Rytovc7Do/AKJ/44jzTG2RaC5he3cYDzmW4
 uNTuDkm4
 5jnjWaavkxC6YbqBnySj7IlddoXVCW9xOs9GThukigQ1l3o+2cERvuTXYkttrBcEAvFWaqYR0kfJwVPU6FX9NRKHhCNlGHU/pnmGihcY5/A0+I2U0ioxBkIKxMPUV76u5rR9pLdtgA6KGbCm6GPqSJkVnOr/n3UOaLfW/PLyLW474xOCff+jt1BV8dxmbn2wnT/5fF849YKnFzFs3HQS4wtIEkFlNMAW7y2AVYnvl9kMwAPgAYOcGCk8goQ1dP6am1t7ObablmENJIYvqRmUGTDlSE3yYudp/gFhytco2Kmz876Iecx+OOMYkK68U+4aFZ0NwTskFFCkRck90FwxGiDd+Yf1JVA2cVhNbkkER3plUzm0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/14/26 00:39, Minchan Kim wrote:
> Currently, process_mrelease() unmaps the pages but leaves clean file
> folios on the LRU list, relying on standard memory reclaim to eventually
> free them. This delays the immediate recovery of system memory under OOM
> or container shutdown scenarios.

process_mrelease() calls __oom_reap_task_mm().

There, we skip any MAP_SHARED file mappings.

So I assume what you describe only applies to MAP_PRIVATE file mappings?
What about MAP_SHARED?

Also "leaves ... on the LRU list" is rather confusing. They are not
evicted and stay in the pagecache?

> 
> This patch implements an expedited eviction mechanism for clean file
> folios by integrating directly into the low-level TLB batching
> infrastructure (mmu_gather).

Is this a complicated way of saying "Handle clean pagecache folios
similar to swapcache folios in mmu_gather code, dropping them from the
swapcache (i.e., evicting them) if they are completely unmapped during
reaping"?

> 
> Instead of repeatedly locking and evicting folios one by one inside the
> unmap loop (zap_present_folio_ptes), we pass the MMF_UNSTABLE flag
> status down to free_pages_and_swap_cache(). Within this single unified
> loop, anonymous pages are released via free_swap_cache(), and
> file-backed folios are symmetrically truncated via mapping_evict_folio().

... where you still evict them one-by-one. Rather confusing.

> 
> This avoids introducing unnecessary data structures, preserves TLB flush
> safety, and removes duplicate tree traversals, resulting in an extremely
> lean and highly responsive process_mrelease() implementation.

I don't think this paragraph adds a lot of value, really.

Which "duplicate tree traversal"? Which unnecessary data structures?

Is that AI generated text? A lot of the stuff here reads AI generated. I
yet have to meet a developer (not a sales person) that would just say
"extremely lean and highly responsive process_mrelease() implementation"

If it is AI generated, throw it away and write it yourself from scratch.
Use AI only to polish your English.

> 
> Signed-off-by: Minchan Kim <minchan@kernel.org>
> ---
>  arch/s390/include/asm/tlb.h |  2 +-
>  include/linux/swap.h        |  9 ++++++---
>  mm/mmu_gather.c             |  8 +++++---
>  mm/swap_state.c             | 19 +++++++++++++++++--
>  4 files changed, 29 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/s390/include/asm/tlb.h b/arch/s390/include/asm/tlb.h
> index 619fd41e710e..554842345ccd 100644
> --- a/arch/s390/include/asm/tlb.h
> +++ b/arch/s390/include/asm/tlb.h
> @@ -62,7 +62,7 @@ static inline bool __tlb_remove_folio_pages(struct mmu_gather *tlb,
>  	VM_WARN_ON_ONCE(delay_rmap);
>  	VM_WARN_ON_ONCE(page_folio(page) != page_folio(page + nr_pages - 1));
>  
> -	free_pages_and_swap_cache(encoded_pages, ARRAY_SIZE(encoded_pages));
> +	free_pages_and_caches(encoded_pages, ARRAY_SIZE(encoded_pages), false);

As we dislike boolean parameters, we either try to avoid them (e.g., use
flags) or document the parameters using something like

"/* parameter_name= */false"

>  	return false;
>  }
>  
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 62fc7499b408..e7b929b062f8 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -433,7 +433,7 @@ static inline unsigned long total_swapcache_pages(void)
>  
>  void free_swap_cache(struct folio *folio);
>  void free_folio_and_swap_cache(struct folio *folio);
> -void free_pages_and_swap_cache(struct encoded_page **, int);
> +void free_pages_and_caches(struct encoded_page **pages, int nr, bool free_unmapped_file);
>  /* linux/mm/swapfile.c */
>  extern atomic_long_t nr_swap_pages;
>  extern long total_swap_pages;
> @@ -510,8 +510,11 @@ static inline void put_swap_device(struct swap_info_struct *si)
>  	do { (val)->freeswap = (val)->totalswap = 0; } while (0)
>  #define free_folio_and_swap_cache(folio) \
>  	folio_put(folio)
> -#define free_pages_and_swap_cache(pages, nr) \
> -	release_pages((pages), (nr));
> +static inline void free_pages_and_caches(struct encoded_page **pages,
> +		int nr, bool free_unmapped_file)
> +{
> +	release_pages(pages, nr);
> +}

Why should !CONFIG_SWAP not take care of free_unmapped_file?


>  
>  static inline void free_swap_cache(struct folio *folio)
>  {
> diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
> index fe5b6a031717..5ce5824db07f 100644
> --- a/mm/mmu_gather.c
> +++ b/mm/mmu_gather.c
> @@ -100,7 +100,8 @@ void tlb_flush_rmaps(struct mmu_gather *tlb, struct vm_area_struct *vma)
>   */
>  #define MAX_NR_FOLIOS_PER_FREE		512
>  
> -static void __tlb_batch_free_encoded_pages(struct mmu_gather_batch *batch)
> +static void __tlb_batch_free_encoded_pages(struct mm_struct *mm,
> +		struct mmu_gather_batch *batch)
>  {
>  	struct encoded_page **pages = batch->encoded_pages;
>  	unsigned int nr, nr_pages;
> @@ -135,7 +136,8 @@ static void __tlb_batch_free_encoded_pages(struct mmu_gather_batch *batch)
>  			}
>  		}
>  
> -		free_pages_and_swap_cache(pages, nr);
> +		free_pages_and_caches(pages, nr,
> +				      mm_flags_test(MMF_UNSTABLE, mm));
>  		pages += nr;
>  		batch->nr -= nr;
>  
> @@ -148,7 +150,7 @@ static void tlb_batch_pages_flush(struct mmu_gather *tlb)
>  	struct mmu_gather_batch *batch;
>  
>  	for (batch = &tlb->local; batch && batch->nr; batch = batch->next)
> -		__tlb_batch_free_encoded_pages(batch);
> +		__tlb_batch_free_encoded_pages(tlb->mm, batch);
>  	tlb->active = &tlb->local;
>  }
>  
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index 6d0eef7470be..e70a52ead6d3 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -400,11 +400,22 @@ void free_folio_and_swap_cache(struct folio *folio)
>  		folio_put(folio);
>  }
>  
> +static inline void free_file_cache(struct folio *folio)
> +{
> +	if (folio_trylock(folio)) {
> +		mapping_evict_folio(folio_mapping(folio), folio);
> +		folio_unlock(folio);
> +	}
> +}
> +
>  /*
>   * Passed an array of pages, drop them all from swapcache and then release
>   * them.  They are removed from the LRU and freed if this is their last use.
> + *
> + * If @free_unmapped_file is true, this function will proactively evict clean
> + * file-backed folios if they are no longer mapped.

The parameter name is not really expressive.

You are not freeing unmapped files.

"try_evict_file_folios" maybe?

mapping_evict_folio() has exactly these semantics (unmapped, clean)

>   */
> -void free_pages_and_swap_cache(struct encoded_page **pages, int nr)
> +void free_pages_and_caches(struct encoded_page **pages, int nr, bool free_unmapped_file)
>  {
>  	struct folio_batch folios;
>  	unsigned int refs[PAGEVEC_SIZE];
> @@ -413,7 +424,11 @@ void free_pages_and_swap_cache(struct encoded_page **pages, int nr)
>  	for (int i = 0; i < nr; i++) {
>  		struct folio *folio = page_folio(encoded_page_ptr(pages[i]));
>  
> -		free_swap_cache(folio);
> +		if (folio_test_anon(folio))
> +			free_swap_cache(folio);
> +		else if (unlikely(free_unmapped_file))
> +			free_file_cache(folio);
> +
>  		refs[folios.nr] = 1;
>  		if (unlikely(encoded_page_flags(pages[i]) &
>  			     ENCODED_PAGE_BIT_NR_PAGES_NEXT))


-- 
Cheers,

David

