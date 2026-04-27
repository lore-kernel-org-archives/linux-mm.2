Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8333CFF885E
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 09:29:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EED706B0005; Mon, 27 Apr 2026 05:29:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC46A6B0088; Mon, 27 Apr 2026 05:29:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDD3C6B008A; Mon, 27 Apr 2026 05:29:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CEC766B0005
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 05:29:23 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 260E9A07B1
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 09:29:23 +0000 (UTC)
X-FDA: 84703812606.02.9739920
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 44EBB2000E
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 09:29:21 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="JO/jWyeJ";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777282161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CD6a7qZoK4As6AU0wsFr0I9PtgmP3NHbZj7Y7Bpw0vE=;
	b=WyAVpE+mHXZu2BO9u1llexOvdGX+WpVrYMJ86xnvYGfLMBoYwY8LPmBX2mNxPxTUH4rVRx
	kOg1cpa+NkG989zqOny1qOupazdT9P9uNo5sglzhizIyXnoZW/wgPCuzFzNjAIiPQKGhFE
	0URLEat7zIHGTMOyL4sCJJdc5672BL0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777282161; a=rsa-sha256;
	cv=none;
	b=d/wK/js95l/EKSMNg54sRsw/seYnR63kKwrPLS4yHDhwqECzKGFlcmmN6ZoosyX2jbmQyB
	5zCGXOtPwypMlhofH6HSdkvrA9HPwo857qgV/RXB7/SbfJOkSyKG3l/mMgjaGUZU89dR17
	6kP18m7xJ05C42lWHUEYbVY1ebGX/QQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="JO/jWyeJ";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7528443AD3;
	Mon, 27 Apr 2026 09:29:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85F2AC19425;
	Mon, 27 Apr 2026 09:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777282160;
	bh=0Y6di9yzK+/+lJwGz27qCzpdTnkxILyaVzTC3KY49d0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JO/jWyeJufM2+qQ2uYQR3y6n98G0GbZQkqz5wB0k6OWIbVAHSwjhbayHwfCnIrgAy
	 M2+EDF3akJCH0EV5UTAw8vlRacxAfOszop2EZ188qZgRikeFtkEJB7XDUZyGaqWFv1
	 dr9+3zsBxuZItswx51Eb7fmsj3hbEImbajbLeoO0ZQF55g6/QfrduIE8bnwd56yQHR
	 yz9M+0T47jxUJ+8eGqED2QyfHearGh/6DgdNQsPRZgGn9OARfEJwMYHFYDeqvdtQbe
	 +MMW4xroo4a8LlP0+nkxWqyN7JV3FgB/Ra5KOdMVyqG5gcMLKzkcjky+q5h4bMACB+
	 l1nVY74IllSNg==
Message-ID: <f484b864-aa7f-4612-8bf8-5f6bd041ddc2@kernel.org>
Date: Mon, 27 Apr 2026 11:29:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/3] mm: process_mrelease: expedite clean file folio
 reclaim via mmu_gather
To: Minchan Kim <minchan@kernel.org>
Cc: akpm@linux-foundation.org, hca@linux.ibm.com, linux-s390@vger.kernel.org,
 mhocko@suse.com, brauner@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, surenb@google.com, timmurray@google.com
References: <20260421230239.172582-1-minchan@kernel.org>
 <20260421230239.172582-2-minchan@kernel.org>
 <7b4bf980-4ff3-4f53-8c64-1ba2d85cf1b8@kernel.org>
 <aevfhYW0K3y9jTjI@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aevfhYW0K3y9jTjI@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 44EBB2000E
X-Rspamd-Server: rspam04
X-Stat-Signature: ontp1w7nezj5n7ooeih39beipthpak47
X-HE-Tag: 1777282161-203169
X-HE-Meta: U2FsdGVkX19FIR4fOTOFuo4tvw7/6L5vllvxoMuV5d09lJsk3IfsAt2lSgrIUJXtyfANYMRXdySyxkJMOiQbMeGyt8DygP874sraUkZu0DylLD+Y8Uo+lKsuSDSCc1Ai5xCKy2bNkkezht/1xMA9lAGcbwUkK+JbK3noHQ5tRrfSylAW5tVQ2eCLVlGI79B0JhxItrKvZDLX8LJiH2zFNMY+iHLN2is5ftByJrRDzU+X4G4+U2lQuZAOKsrQXU5FSrickqJNrDF7mFazGb9g6OUB9yB09xakWtfSoyoOb48XAdxs+51cRxQrg3Q+j1AmD/hKk5HrzQNV2CbiLK1lDzeRr6XjzOw4VzBnSArkc+8M4bNZl3wwEUNX7UBsxf2jRbQ+WQR06+eL6K3T+GXGMmEXhsu/RZVzByI+SMaxrxs54A4sNCTJhA2MLSq2G13CMmjmTkXYuXCJW01xBX+plpzMA6B1/HeOwY9YIk6iM2o1c3e/+nOZ27Z7/ZeLVEW6veOYgU8EfRHWgxFWSNw1pj9EkDgn9jcpe+iSZMI65L8kTL5yBNyIJVEcmhQ7hfMQvnpirOJIl9ZUxjkQcAHGE6kL8olYbuzfvvperdrW2Gayy3ddxC510qMJSlRxKLpR4nnQreKilJseoPzN6rlsQxX/HSZuYsxV3tadRY5g8+TOB8mtrKWm9BMkk8CgPz5hGUtSI7JOMdgEkfGSVDPoa+s3V6CFwKROR9VS4mB1MJYgB+c37pMKr0/TUXmx71ksGa7jQ+qH7LC15e/nbQmXxJ/SnN4TGuWRY/rvMBKoo1b7dMTGXszX6nk9NJNPHOtzZZo5ol8yXbx9vR/n39Q4OFli7Vf9xFYiTmfIuZ38kBX4WOn4i9nWw5TeLxPXhRx9HPACKRbddSgxlP7TvF9vuElnacYaufvDJG1dJjnof7uDoxO1KqrEMBKdngyCtu/kasdc3ABKHrk+onDJwrQ
 L4oq89mK
 qcorAp2DR/t/go2wck3cgVWtjFS3Pau8nyLRTC1zMEKejTkMVqvHwncJKclsAkqjYWDWfAnMlicuKN1GJ7bPIr0+zsesr4xfVnoKFw/1sLoMJSQCAbgVq2rkTkDkL65vMr79Px5s1U1xrBPu/OaEzN3LXJki2e8iNwmEmMPBWUkXkMPNft8HOJxPQsQVwte7f80hMX4vy93CW2T/P8Kfavtnoq9U3fzwLYwRrRrkY+tS8NRY2tF4vEZnsjrqXZsrYpS4p+MGT/RIkQGCb4iGsZdXRbFH3kTP+7CzeZgMZf4ojP8jWI66NFmfCRJYgmIiwGX9kjYI4R6JJIZfsGxfWTC2Ch34v71Fhaoc15Lm9WPz/3n4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/24/26 23:24, Minchan Kim wrote:
> On Fri, Apr 24, 2026 at 09:56:01AM +0200, David Hildenbrand (Arm) wrote:
>> On 4/22/26 01:02, Minchan Kim wrote:
>>
>> Can we make the subject easier to understand?
>>
>> "mm: process_mrelease: evict clean file folios when reaping a process"
>>
>>> Currently, process_mrelease() unmaps pages but file-backed pages are
>>> not evicted and stay in the pagecache, relying on standard memory reclaim
>>> (kswapd or direct reclaim) to eventually free them. This delays the
>>> immediate recovery of system memory under Android's LMKD scenarios,
>>> leading to redundant background apps kills.
>>>
>>> This patch implements an expedited eviction mechanism for clean pagecache
>>> folios in the mmu_gather code, similar to how swapcache folios are handled.
>>> It drops them from the pagecache (i.e., evicting them) if they are completely
>>> unmapped during reaping.
>>>
>>> Within this single unified loop, anonymous pages are released via
>>> free_swap_cache(), and file-backed folios are symmetrically released via
>>> free_file_cache().
>>>
>>> Signed-off-by: Minchan Kim <minchan@kernel.org>
>>> ---
>>>  arch/s390/include/asm/tlb.h |  2 +-
>>>  include/linux/swap.h        |  5 ++---
>>>  mm/mmu_gather.c             |  7 ++++---
>>>  mm/swap.c                   | 42 +++++++++++++++++++++++++++++++++++++
>>>  mm/swap_state.c             | 26 -----------------------
>>>  5 files changed, 49 insertions(+), 33 deletions(-)
>>>
>>> diff --git a/arch/s390/include/asm/tlb.h b/arch/s390/include/asm/tlb.h
>>> index 619fd41e710e..2736dbb571a8 100644
>>> --- a/arch/s390/include/asm/tlb.h
>>> +++ b/arch/s390/include/asm/tlb.h
>>> @@ -62,7 +62,7 @@ static inline bool __tlb_remove_folio_pages(struct mmu_gather *tlb,
>>>  	VM_WARN_ON_ONCE(delay_rmap);
>>>  	VM_WARN_ON_ONCE(page_folio(page) != page_folio(page + nr_pages - 1));
>>>  
>>> -	free_pages_and_swap_cache(encoded_pages, ARRAY_SIZE(encoded_pages));
>>> +	free_pages_and_caches(tlb->mm, encoded_pages, ARRAY_SIZE(encoded_pages));
>>>  	return false;
>>>  }
>>>  
>>> diff --git a/include/linux/swap.h b/include/linux/swap.h
>>> index 62fc7499b408..bdb784966343 100644
>>> --- a/include/linux/swap.h
>>> +++ b/include/linux/swap.h
>>> @@ -414,7 +414,9 @@ extern int sysctl_min_unmapped_ratio;
>>>  extern int sysctl_min_slab_ratio;
>>>  #endif
>>>  
>>> +struct mm_struct;
>>>  void check_move_unevictable_folios(struct folio_batch *fbatch);
>>> +void free_pages_and_caches(struct mm_struct *mm, struct encoded_page **pages, int nr);
>>>  
>>>  extern void __meminit kswapd_run(int nid);
>>>  extern void __meminit kswapd_stop(int nid);
>>> @@ -433,7 +435,6 @@ static inline unsigned long total_swapcache_pages(void)
>>>  
>>>  void free_swap_cache(struct folio *folio);
>>>  void free_folio_and_swap_cache(struct folio *folio);
>>> -void free_pages_and_swap_cache(struct encoded_page **, int);
>>>  /* linux/mm/swapfile.c */
>>>  extern atomic_long_t nr_swap_pages;
>>>  extern long total_swap_pages;
>>> @@ -510,8 +511,6 @@ static inline void put_swap_device(struct swap_info_struct *si)
>>>  	do { (val)->freeswap = (val)->totalswap = 0; } while (0)
>>>  #define free_folio_and_swap_cache(folio) \
>>>  	folio_put(folio)
>>> -#define free_pages_and_swap_cache(pages, nr) \
>>> -	release_pages((pages), (nr));
>>>  
>>>  static inline void free_swap_cache(struct folio *folio)
>>>  {
>>> diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
>>> index fe5b6a031717..3c6c315d3c48 100644
>>> --- a/mm/mmu_gather.c
>>> +++ b/mm/mmu_gather.c
>>> @@ -100,7 +100,8 @@ void tlb_flush_rmaps(struct mmu_gather *tlb, struct vm_area_struct *vma)
>>>   */
>>>  #define MAX_NR_FOLIOS_PER_FREE		512
>>>  
>>> -static void __tlb_batch_free_encoded_pages(struct mmu_gather_batch *batch)
>>> +static void __tlb_batch_free_encoded_pages(struct mm_struct *mm,
>>> +		struct mmu_gather_batch *batch)
>>>  {
>>>  	struct encoded_page **pages = batch->encoded_pages;
>>>  	unsigned int nr, nr_pages;
>>> @@ -135,7 +136,7 @@ static void __tlb_batch_free_encoded_pages(struct mmu_gather_batch *batch)
>>>  			}
>>>  		}
>>>  
>>> -		free_pages_and_swap_cache(pages, nr);
>>> +		free_pages_and_caches(mm, pages, nr);
>>>  		pages += nr;
>>>  		batch->nr -= nr;
>>>  
>>> @@ -148,7 +149,7 @@ static void tlb_batch_pages_flush(struct mmu_gather *tlb)
>>>  	struct mmu_gather_batch *batch;
>>>  
>>>  	for (batch = &tlb->local; batch && batch->nr; batch = batch->next)
>>> -		__tlb_batch_free_encoded_pages(batch);
>>> +		__tlb_batch_free_encoded_pages(tlb->mm, batch);
>>>  	tlb->active = &tlb->local;
>>>  }
>>>  
>>> diff --git a/mm/swap.c b/mm/swap.c
>>> index bb19ccbece46..e44bc8cefceb 100644
>>> --- a/mm/swap.c
>>> +++ b/mm/swap.c
>>> @@ -1043,6 +1043,48 @@ void release_pages(release_pages_arg arg, int nr)
>>>  }
>>>  EXPORT_SYMBOL(release_pages);
>>>  
>>> +static inline void free_file_cache(struct folio *folio)
>>> +{
>>> +	if (folio_trylock(folio)) {
>>> +		mapping_evict_folio(folio_mapping(folio), folio);
>>> +		folio_unlock(folio);
>>> +	}
>>> +}
>>> +
>>> +/*
>>> + * Passed an array of pages, drop them all from swapcache and then release
>>> + * them.  They are removed from the LRU and freed if this is their last use.
>>> + *
>>> + * If @try_evict_file_folios is true, this function will proactively evict clean
>>> + * file-backed folios if they are no longer mapped.
>>
>> There is no such parameter.
>>
>> But I do wonder if such a parameter would be better than passing in the MM here.
> 
> Makes sense.
> 
>>
>> Also, is there a way to avoid moving the function?
> 
> I guess you are talking about "free_pages_and_swap_cache".
> 
> The problem is mm/swap_state.c is conditionally compiled only when CONFIG_SWAP
> is enabled.
> 
> Since the expedited clean file cache eviction should be available
> even on !CONFIG_SWAP, we need this function to be compiled unconditionally.
> That is why I moved it to swap.c, which is always compiled.

Ah, right. Please spell that out in the patch description!

-- 
Cheers,

David

