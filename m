Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38A0FC5AD7B
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 12:55:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24B796B0092; Mon, 10 Aug 2026 08:55:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FD966B0093; Mon, 10 Aug 2026 08:55:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1131C6B0095; Mon, 10 Aug 2026 08:55:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E0B226B0092
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 08:55:30 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C97E8A1002
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 12:55:29 +0000 (UTC)
X-FDA: 85085355978.30.EF8EA0B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2DCC040009
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 12:55:28 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YWXhF5g4;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786366528;
	b=5pf9G4HjYE0pZiOxK2uR+kC0rpZmiGf5P+XDKAzlQF1nSwmpBlrqivPpMSOMmmeKHIFSHk
	Eq7TZspMMQGFUpR4RFGQZn1ZJKLooYab+i9MLKdUfDnXTvF3+BIgfV8fX+AGTpUNkGI877
	+Z5VdMRGnA+iyPfu5v4vzMbejIJOrs8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YWXhF5g4;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786366528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q3fbdyvCGVnrDuoB4RN/w4ZZdW26Al8oLsjQqGypFMs=;
	b=3YV0Q7nGf62yOAokMlzNO4XM4yvxsTymIBqZN1SWsmkLooa86bjOmG/vNsIFVNuuTMr8q/
	gvonCCqo+kvx+Se/ZKAprIZMjusA8/cbf+4qOFnhyiDO9pXrveHksBQGw+ex+RB5Io9SY6
	FD6i6T7qbGUgaVNKUcvBrR9UcP82hjs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1D33B42EA3;
	Mon, 10 Aug 2026 12:55:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 585561F000E9;
	Mon, 10 Aug 2026 12:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786366527;
	bh=q3fbdyvCGVnrDuoB4RN/w4ZZdW26Al8oLsjQqGypFMs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YWXhF5g4j1HNEuU2xUlOoC0+xwHqbDkrFN4BAhSr4rCpMTZw0Y852TJrOp8Cibh/Z
	 NqTcD6/AiIBvgB9Wh4lWhGwogYj7Wqi4bCZjwu3a2GCZF1MuYUGr7X1NZNvniErEnp
	 j0H8t1sbfQP3yhRLBcxkw/kOSK8z9UokIcgm0NESHCk9lSFtjLjSTtP6JX7vQJvCOP
	 ZbKOvSGfoK2j3E47ZDk6KHjXdhqoit6TA2CE3qqc3hNYDUNymCJ8zPVdhxEXDUx4Cm
	 9A4pkl+QuIqBMqfzr4+1/YcBsbgR2pyGOe4XS1ER8/2c5JuZjokcmOdza9a/V7xX0d
	 M+FlldjqDDJ9Q==
Date: Mon, 10 Aug 2026 13:55:06 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@lst.de>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] mm/page_io: use swap entries directly in zeromap
 helpers
Message-ID: <annJiayAzNA7kA6O@lucifer>
References: <20260806-b4-page_io-folios-v1-0-0899bac3b826@columbia.edu>
 <20260806-b4-page_io-folios-v1-3-0899bac3b826@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806-b4-page_io-folios-v1-3-0899bac3b826@columbia.edu>
X-Rspamd-Queue-Id: 2DCC040009
X-Stat-Signature: 4f311g38jba1mudw9jod4qfxpokzbebr
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786366528-522449
X-HE-Meta: U2FsdGVkX18vRnwk6+DcpUpAGqhBgFEHSh4po8lYmJASQCkJ6PKkmkRHDkIo+CMRiFd3kDl24EnMeCen/i7kaTLjNc1Ve44MHE9GUyX1+7aS/0DYxgod6uCEA4nQ3XLTiv/UnNPsIq2fUiYywXFHFHL+umWzetZPMimIkSieGaPVXLJ7SpKR1jvejKC/CGIRwSxB5GADkg24AQ9ZASBg7J+ygDRdxW5BXt0c8e1pwb7n1txt5YDNjO/+sUyLifYH9Oc7ibtBvHwrIi+AR9XrutlAR/NJ7Z4h/1uhp42x62lpE5cbT9iOAWOps8rLE+ibpAdQmL2nikSHQGS+zIcENUQtdfpVEmbrMyCEWTMVC+o9A4xCTMs6KbBFeqMzTvsJMxHAnSQGKrFr7R5DkpGHqifOUYR0IsV6eVklpRcs16+R4kgELUnoSj9a+267zOPnXmS9i38zV+PewwMmflknoyquXFtXrZDxIRvn0B5lNViNE9Mm3mOtHKNqKCZT7345SpEd9Z6eG8yM07ZXc04eET83dBRsPtBX0udm9rM2ky1vIPbmy1eDA5bLaLQ/CoEbb73SdfMas/9lHarNtE2S1wzsDS15yqAdMBzrSRqnE3slHsIACJaMht0gldmokjAqI0YqIqFGqdJtb9igdM+Lvq/X4VQjNcr5INXtxH2S4iLKxLaREtRtJfU3Wl8sj3Lp/K9LL7+USIS+aaevqiQi69nbwAayZOIU8IeQC5jor1Uc5DKVLdyML5ehrCmewsRjkopwLl9vxKiXycv3vXTqzYH9bNuF7jynPcLYPJFWBhJlucfvXHuJ0clDtaZxERoYCJcVuyP8lODLK+OID38grRI9vbxy2qhdumxDifI7tjBCbPSezSNpVlJRm6e4a0cPa4NE4jlIhqPjQqVY61RTU4fbIVYeiR9isI8FOxRR/oA3t8SK0iAUC9GgvPZl1pCRiOjqy5MWUYq0aUKFMOO
 U+CQNGDf
 J2UIxkyPohW09Bfi8haqC8zh15KVP7HeT2LlfNyA59SrhHHpTMoOnQFr6t8ABXfBMmZCQYzhd/sCXetWkc2Rsn2ThdboRUeylIbc9oJSjquxfE+/W58MBzF1XZ/AQ6zQ8W2NGN9UqMhXeFDgA5TVfmGi/8sQSYCrJkKIt3R10KX64UqJBLtvzcrtDhYKYYPHWSLABBAJwMO8HwfgBqHGDVhX8kx59Ak/bwqGtqnvAX/qaeZ9WXt1eBLr0mxjR/RaTxRVQyEACObr+OZ0hxJEHmLhvOJl2vOgFa06JowOMuSsCEWticqCAScZhTMW+aAyMbqUie13nb0ypuv+eucXbi7KR4JOyvUDrtdf8Fhf+/FLlfuk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 06:55:35PM -0400, Tal Zussman wrote:
> Increment swp_entry_t::val directly instead of recomputing each entry
> with page_swap_entry(). This removes the last struct page usage in
> page_io.c and saves one call to compound_head() per page.
>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Lord I just looked at page_swap_entry() and... yeah. This is an improvement
thanks :)

I haven't looked at the rest of the series so maybe you already did it but I
wonder if we could remove it altogether?

Should we rename page_io.c to folio_io.c now? :P

Anyway LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/page_io.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/mm/page_io.c b/mm/page_io.c
> index 43b4383a4729..c6d0949b3f1e 100644
> --- a/mm/page_io.c
> +++ b/mm/page_io.c
> @@ -159,7 +159,7 @@ static void swap_zeromap_folio_set(struct folio *folio)
>  	struct obj_cgroup *objcg = get_obj_cgroup_from_folio(folio);
>  	int nr_pages = folio_nr_pages(folio);
>  	struct swap_cluster_info *ci;
> -	swp_entry_t entry;
> +	swp_entry_t entry = folio->swap;
>  	unsigned int i;
>
>  	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
> @@ -167,8 +167,8 @@ static void swap_zeromap_folio_set(struct folio *folio)
>
>  	ci = swap_cluster_get_and_lock(folio);
>  	for (i = 0; i < folio_nr_pages(folio); i++) {
> -		entry = page_swap_entry(folio_page(folio, i));
>  		__swap_table_set_zero(ci, swp_cluster_offset(entry));
> +		entry.val++;
>  	}
>  	swap_cluster_unlock(ci);
>
> @@ -182,7 +182,7 @@ static void swap_zeromap_folio_set(struct folio *folio)
>  static void swap_zeromap_folio_clear(struct folio *folio)
>  {
>  	struct swap_cluster_info *ci;
> -	swp_entry_t entry;
> +	swp_entry_t entry = folio->swap;
>  	unsigned int i;
>
>  	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
> @@ -190,8 +190,8 @@ static void swap_zeromap_folio_clear(struct folio *folio)
>
>  	ci = swap_cluster_get_and_lock(folio);
>  	for (i = 0; i < folio_nr_pages(folio); i++) {
> -		entry = page_swap_entry(folio_page(folio, i));
>  		__swap_table_clear_zero(ci, swp_cluster_offset(entry));
> +		entry.val++;
>  	}
>  	swap_cluster_unlock(ci);
>  }
>
> --
> 2.39.5
>

--
Cheers, Lorenzo

