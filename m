Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 590F6CD37B5
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 08:07:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79DB76B0088; Mon, 11 May 2026 04:07:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74E1C6B008A; Mon, 11 May 2026 04:07:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63E576B008C; Mon, 11 May 2026 04:07:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4F2296B0088
	for <linux-mm@kvack.org>; Mon, 11 May 2026 04:07:23 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D979E1C14FE
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:07:22 +0000 (UTC)
X-FDA: 84754409124.02.8B3EC29
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1E6361A000C
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:07:21 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="WD/VFGv8";
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778486841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vh/uWTTYjZm0asWf0jT2Px58NeBMEka/KfwyB1RKj1s=;
	b=QkVhbymvlKwwGMy7mslalygeAxqVMU6ezejBNPyCAoDZXfEvNeO51T7SFrVrJmEM9nxXBI
	62zuaxXcVNBQ0frH7dbYqcOn5KAmdyLEPOvhz66roH1KaLO9yt6hA+8AkQkxFk0BILwfWQ
	hozglP3jE6tOIiG6qEGCqin9gEDTjAI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="WD/VFGv8";
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778486841; a=rsa-sha256;
	cv=none;
	b=xcYnOYC0l2oSkX32b3F8v/tOzAnJi9byUaeIVmlSmM5MiyybJfiFnG64pD53Cch+4qX4H9
	7aibz0jGEi5iz5mFuA2sivAWFLM6z/vNfj9nQOWYon1HkMGGxb8vDhDMHQLSjMCMuNAC2w
	tY4v0BWpQ4u7c5Oy2l8kSU7X/HNnSPk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8E95960125;
	Mon, 11 May 2026 08:07:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04641C2BCB0;
	Mon, 11 May 2026 08:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778486840;
	bh=Hv2TUTOaDojfumEKJhQdOH+FpyV8uE5bZuGwDm9nbkk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=WD/VFGv8kN2/OyQghM2iYjaLD4ln290lKMK9comJhQ12fNWKOG9sRzzbUoZ2eBfG9
	 A1IXMNifd3PUEGDyWE5aXD/mvB88fD8ggMUuQY6xsrLaatGWCzHJhQGDnD7YGlw6Ke
	 vgPI1wyEKCTCH4Ju3+UJHcus+ZP0C/UavhmhrdBzhRRlJnGLuFR4Fq7/DDg08nyDy3
	 Bc6BUsptQOLCD16SvO5CdItW6Rdkux3e4kWk3H0J5LEFHCpEFqoqVJxxRLAgDf7chs
	 IY7Z1vfZD09fV+m2ragb80trDFPY3nyOP4t9yxSFwF2WBmIB3emZqRGe0w5wOItgo9
	 CXS2hCpLxSeCQ==
Message-ID: <37a2531b-7b27-4574-838e-558ba310261b@kernel.org>
Date: Mon, 11 May 2026 10:07:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 7/9] mm/swapfile: Add batched version of folio_put_swap
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
 <20260506094504.2588857-8-dev.jain@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260506094504.2588857-8-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: mwh5p5j9myxc8ybny3trk6f3e8m3nsoj
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1E6361A000C
X-Rspam-User: 
X-HE-Tag: 1778486841-555601
X-HE-Meta: U2FsdGVkX18UtSTG+2CwVrvZHSjdwd5HN86m6tHU/XvubG1sGCpFCfnNBt28wUZgZsjKxRcUkjfNQyGbXkgDb5PzTxKi9Xv5LdCX48QTjr15bCmYJ4zypPeuOUPHrYnG4GVlfq5K2rHlKW5OFDxIIiaQqdl/kqp3wv4NDBwmubwDIt9ZTr//++AuksS9QcM6js0yuKZlbMR3h7vIJ1NUE7reS93DvQtv+SBScFDqRBaNzs+VZ/cvWgZl4ckSjOkx+vmr+hAxaVUCSXqrILZKpfZ5xjddZIyk6VnVxxTcXpXLDp5YKpnYlZWjXwr1HjKRMcI7y62x7r5xK4tHgMRzoeVO2i20nbnDhLctYva6rMZpWknRPSY02epbtehzSff7LdfzOeZwr8XVH+ARcb//oHxQXuXtokfhSwot2FysRpAZjzs3n47jQK6EhIafjRxA7VdsFn4FuWz+FcM1fNOOPUEyBuUDzqek3b/RxL0jTVfG9EL4ohetUfst0exzb+uUjNYeyo5149ykIC0B7vy7kTi8cQWGd4MVZn5IoNviYFImVgapMLp0Bzal8RBYJJRbw+dx8r5s2omxTRF0uKdcFwuOo1BUTVkaSH6Yb3TuBtTg7yIWMllX/y7jDRBpoHy8Z7+mFqCYALFOVKpMCgfAG471aQzNHHucjnZifLkwSGOwpI6sVGOEeuiWw2QaejiBbdenvCmhR63HCIRTU9iVflqU1nSseF+3NjcZiGjePcmd69M0LwCCUA6z4a6UFYtqI8hDwka2D4dGiecJC3royKh6RUhGos4+TXPPl/vvTGU2w011sbMy0/p8VfkVkMhCY/55Hg2I9fIt7SqvuHy8pEcCZw9Dx+mNq7LX53z/NCXWeYLNMGDsAT5klNMqLcDbd41OefAqHTm653AiOIK1aekok51uikO0Bs3EhTZqYagMs7GlZ9R+4pK+sLU6uOnJidxhs+2TsNJUqdUY68a
 0ANLUufp
 41J58WOt+JnFPtjQAHcv4/O1SnshiVuHoM5q21f8mBt1pCyCbedYXJvn3yDjG5gvJ8iGAxhE4K9/Pf6mKzSC3VlItLTeS5urBMh9vvmTUKv4Bmj9VR3N9gtYpaveiq+Bh9YAaNtGXJBrMS74TW+7JMMZ/ocD46BgA9QfHLoTH6wdOI6InbHV8muCkIjbvg16y54Kp+F4+mMXvm5uj7mYQNti9e68UJM6fERuTEMMUE46+nNlCm7UOF0VipUgj6/hFq+veS9xSSocHzUBGXSi3QwABb2P17h/VaK24RpOJMpDBY4a/0kuO5yonSruV0irEN4ib6l8Ca9x2SL8i190oQZk3Q29XsfeXMKOQcAyZe7ky7SM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/6/26 11:45, Dev Jain wrote:
> Add folio_put_swap_pages to handle a batch of consecutive pages. Note
> that folio_put_swap already can handle a subset of this: nr_pages == 1 and
> nr_pages == folio_nr_pages(folio). Generalize this to any nr_pages.
> 
> Currently we have a not-so-nice logic of passing in subpage == NULL if
> we mean to exercise the logic on the entire folio, and subpage != NULL if
> we want to exercise the logic on only that subpage. Remove this
> indirection: the caller invokes folio_put_swap_pages() if it wants to
> operate on a range of pages in the folio (i.e nr_pages may be anything
> between 1 till folio_nr_pages()), and invokes folio_put_swap() if it
> wants to operate on the entire folio.
> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---


[...]

>  
> -static inline void folio_put_swap(struct folio *folio, struct page *page)
> +static inline void folio_put_swap(struct folio *folio)
> +{
> +}

Same comment regarding common function.

> +
> +static inline void folio_put_swap_pages(struct folio *folio, struct page *page,
> +				  unsigned long nr_pages)
>  {
>  }
>  
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 28daf92839e77..ac576cc63b194 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1778,31 +1778,34 @@ int folio_dup_swap(struct folio *folio)
>  }
>  
>  /**
> - * folio_put_swap() - Decrease swap count of swap entries of a folio.
> + * folio_put_swap_pages() - Decrease swap count of swap entries of a folio.
>   * @folio: folio with swap entries bounded, must be in swap cache and locked.
> - * @subpage: if not NULL, only decrease the swap count of this subpage.
> + * @page: the first page in the folio to decrease the swap count for.
> + * @nr_pages: the number of pages in the folio to decrease the swap count for.
>   *
>   * This won't free the swap slots even if swap count drops to zero, they are
>   * still pinned by the swap cache. User may call folio_free_swap to free them.
>   * Context: Caller must ensure the folio is locked and in the swap cache.
>   */
> -void folio_put_swap(struct folio *folio, struct page *subpage)
> +void folio_put_swap_pages(struct folio *folio, struct page *page,
> +			  unsigned long nr_pages)
>  {
>  	swp_entry_t entry = folio->swap;
> -	unsigned long nr_pages = folio_nr_pages(folio);
>  	struct swap_info_struct *si = __swap_entry_to_info(entry);
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
>  	swap_put_entries_cluster(si, swp_offset(entry), nr_pages, false);
>  }
>  
> +void folio_put_swap(struct folio *folio)
> +{
> +	folio_put_swap_pages(folio, folio_page(folio, 0), folio_nr_pages(folio));
> +}

Same comment regarding kerneldoc :)


... and same comment that this definitely looks nicer.

-- 
Cheers,

David

