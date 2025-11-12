Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A13ECCF9F8
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 10:00:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EB898E0018; Wed, 12 Nov 2025 05:00:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C2B98E0002; Wed, 12 Nov 2025 05:00:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D8788E0018; Wed, 12 Nov 2025 05:00:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 358BA8E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 05:00:12 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CB36112DB03
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 10:00:11 +0000 (UTC)
X-FDA: 84101509422.17.F1C94BB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2BD731C0004
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 10:00:10 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="akwA/QS5";
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762941610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v2SlrP3MYrgSHwQ2tNBmEBL1wFBTNSOq43U2jq6eP0Y=;
	b=niw74kWJMdTofSUhPMIBVo1rFq4XWpM/GbLbwlk5lx1vAjKcfTrd76KujSBqZfZy0zKjZ+
	xxiO9pW6E6MecZV8VF33umfKfLoVN0JHNE+2c85Gc9i11A2zw55Xe9VoP9d5QY/H++CwxE
	CzhaiRr9erwVMrbkHenZf+THMNzgONc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="akwA/QS5";
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762941610; a=rsa-sha256;
	cv=none;
	b=HjT7XE2PCcpaLamdRA+k6WGomnVvrKRWIEnZFsRa4cDvLSt54bqcZCdfDlDoEUONoa5OnN
	arqQWe+XZXl9eUDT0MwS60i4OlIGRG/a7SNy2diqaiVI8B1s1OdjNpsWVW6V1/DzRPmEOi
	FtgUUoDJZv4MkEGhQ8hI14jAGp1rpVc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 46C0E60143;
	Wed, 12 Nov 2025 10:00:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BB55C4CEF8;
	Wed, 12 Nov 2025 10:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762941608;
	bh=Hc9SpvODoEKqXyT0Yv/Hs9C9gFsaCYRYLwLn+AbBGok=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=akwA/QS5z6CaUXVEzunr+7pQgnrxiS05TwnBHMPu9G9K7v9c/3R8iUIoq0Fcs1D4g
	 uZyFVcYDoifzu15xZtQHiFBAIMDuqArYYZlBjJXdyvuagQ+WofFYu/yGFfMBt2KwOe
	 G+n6vnPF/RN8DkE0+tTxciwrHE1uEt6TYEil166dlKMJggi3wQvLptrv9X9lU6PxgQ
	 XNAr6Fr9I8+mApELE0Zj+iZ1Qiz442z8ZyH6mke/U0LWo9Hx0HSVCUoO8RPKVSBGnf
	 CUy8XhqDiIhiws23n55El8P4yhgadO8ReX6Eikf6sUhqd0LFCEWkHzOmC++LncJ0+w
	 wQDl9Ia2iQ4lw==
Message-ID: <048134fd-6a3d-4a6c-a2eb-9a9911c3b35f@kernel.org>
Date: Wed, 12 Nov 2025 11:00:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory.c: introduce split_unmapped_folio_to_order
To: Balbir Singh <balbirs@nvidia.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
 Zi Yan <ziy@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Ralph Campbell <rcampbell@nvidia.com>,
 =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>
References: <20251112044634.963360-1-balbirs@nvidia.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251112044634.963360-1-balbirs@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2BD731C0004
X-Stat-Signature: 5pno7x8thz8s9zm1d7rnqwnikakh9813
X-Rspam-User: 
X-HE-Tag: 1762941610-191349
X-HE-Meta: U2FsdGVkX1+XYDh3Ey5NaLBimXBCcPFJ4iZAw3jHA/U3sgTcSCV534VBVcyGkIEC5I3UmTfbNwhsNZsGaWsiBE39PYIIN/C95tWAGJ+2szw42PYVOz8O93wW6G05cbNR0SsraT6RZAWcXs+KRhlwbhtSD4Cm4TcUgaUy3ILcO30YtafHRfyIbGxXs0pXBCDB0Wl9mV+x/WSKk157HjcyHQiItGKPnLWOC39pR5C392hkgMr/9Idxat545OjD9G9O3mRKH61YwgTsaBO31Je4igLDClgQAWYSSRqy9K/JZpKBD+/6seGWCGgABabSY+ok9geRcQHUQUvkxlF5K2YBDa3J4Zhrw86ndf4mfQGCiyMo791DV1X6jyzLSo5J4rSAyyvOa4oEe3R1iFg+JmLumZUyW9sqrd3jg8aEqkKKjURTKadFigx8gB8Vsies9zLAFOY8+p8MzixiqReWP831c/kRxrv9+8+R5SQWZtDdrP0AVJcmHin2f/jLmE9orwzCgL6ZBt/EGZSWg+SAvr/+YBGU+y/byRBSGIC7ZmyULVJ4o/Yy0INSS1wSsiZiWx5w7l/dWVyjbSNehgHkoOMeBBNcoXvRWeLwcPEX+jnlW/BP0Yht/VuAYu1TNntGVcvmw3PtD5fel/+evDkWEWWw3+2TtXAlZhFAuZDDMRtTcL2AxmbcC+REexSlgsAaBLSWdDfOoSyUhH+5Z4hD5YR+O5Q5SYo0gP63mNCVV3RmnSgmUpj9EihZ7rI30UE9JnG8YuLEDqVcErjq0vbIws2nH3sPGC6sBffpW1OcYRDkM5pIKO5ozIToEZlFzfgJtk3u/DvNorUOjFvtAyCpXpbZxzrPzPT2mDt8NayYm+J4Xny0topBnj2PzFiRDMNHsbvyqkRl9wv36nsAFi2rCGLTkSFpek3o6DcKpShufZ0+l7c6Z9ZN8srYd3khanWZ6ZrGWBthKwKWKRDvvrM6Gpy
 144/pnql
 8WvJhQi44xo3c5YCQD4CowoNVul1zi7xxOT6Li7Y2lwa96uGtDs3gW9e1BDICowZlT/Jt/oJQTwMfANLhirG3KLtQD72kaVaglNpct/1lWu1PxADEWykFJbepuobFWAZvENnc4CNWT2LNIFscfyLCWEJrsG+AxDjMQHHJNC17Rv2/nGTZ7lW1PJSHIDVKtEdFssIzeR5CapulSwMAd869B61oKuLZtmPJvfYNeDuISwB3YQUbeWD5h50J6f2wjpdiBIltRTahdiA2kvE+J+mXxyzyGG8Ml0zGmoffxZyFcPd1suwkEE1AhVQ3nchkklwqmgvv/iIAsixTV0OPCJacM3eGWuaCBaJ0TFkn0Y9PyZuT4dFX9LNX6HRQQJVXH1KCneGMQznJRKqgY02tm1yvl8QDq2XkLxC+/hiuQcnV5velqQ70JYb45RM6Wf9x2GuRcOZ3qriW7CG3+g0pjHgw+9BfJwK7SWv3AvW7eKL/YKSG7J/I3qHtpGP355Mf0m1SU/UhqnDCd2WfkaXnkCbWnIcFIVwb0RGZzFl7BmuDSjLt5uEEl5SOcG2q5UupVWXJTyT5JJn4QDIUbBrm/wFlWzBnoree/ktmRqj6hjf33il4Qf1VzDq+Sj1cLDsr8OLmc/Tk+xI0kyMO5aIn1DLDbXz2PLYnYXs+Mm95cvd/LGbFfnG2xLUWcVg/+NsOQrU7KEbE4NSDospYd79/kbXRG6UWiB2faaaB1zdLo9PldHDAdVjFBmf09/T5By+cRCksAJrOT14BwSu637dFepcrD/23puc/bk8vVOsvomRFCzKq3IQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12.11.25 05:46, Balbir Singh wrote:
> Unmapped was added as a parameter to __folio_split() and related
> call sites to support splitting of folios already in the midst
> of a migration. This special case arose for device private folio
> migration since during migration there could be a disconnect between
> source and destination on the folio size.
> 
> Introduce split_unmapped_folio_to_order() to handle this special case.
> This in turn removes the special casing introduced by the unmapped
> parameter in __folio_split().

As raised recently, I would hope that we can find a way to make all 
these splitting functions look more similar in the long term, ideally 
starting with "folio_split" / "folio_try_split".

What about

	folio_split_unmapped()

Do we really have to spell out the "to order" part in the function name?

And if it's more a mostly-internal helper, maybe

	__folio_split_unmapped()

subject: "mm/huge_memory: introduce ..."

> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
> Cc: Rakie Kim <rakie.kim@sk.com>
> Cc: Byungchul Park <byungchul@sk.com>
> Cc: Gregory Price <gourry@gourry.net>
> Cc: Ying Huang <ying.huang@linux.alibaba.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Nico Pache <npache@redhat.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Lyude Paul <lyude@redhat.com>
> Cc: Danilo Krummrich <dakr@kernel.org>
> Cc: David Airlie <airlied@gmail.com>
> Cc: Simona Vetter <simona@ffwll.ch>
> Cc: Ralph Campbell <rcampbell@nvidia.com>
> Cc: Mika Penttilä <mpenttil@redhat.com>
> Cc: Matthew Brost <matthew.brost@intel.com>
> Cc: Francois Dugast <francois.dugast@intel.com>
> 
> Suggested-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
> ---
>   include/linux/huge_mm.h |   5 +-
>   mm/huge_memory.c        | 135 ++++++++++++++++++++++++++++++++++------
>   mm/migrate_device.c     |   3 +-
>   3 files changed, 120 insertions(+), 23 deletions(-)
> 
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index e2e91aa1a042..9155e683c08a 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -371,7 +371,8 @@ enum split_type {
>   
>   bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins);
>   int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
> -		unsigned int new_order, bool unmapped);
> +		unsigned int new_order);
> +int split_unmapped_folio_to_order(struct folio *folio, unsigned int new_order);
>   int min_order_for_split(struct folio *folio);
>   int split_folio_to_list(struct folio *folio, struct list_head *list);
>   bool folio_split_supported(struct folio *folio, unsigned int new_order,
> @@ -382,7 +383,7 @@ int folio_split(struct folio *folio, unsigned int new_order, struct page *page,
>   static inline int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
>   		unsigned int new_order)
>   {
> -	return __split_huge_page_to_list_to_order(page, list, new_order, false);
> +	return __split_huge_page_to_list_to_order(page, list, new_order);
>   }
>   static inline int split_huge_page_to_order(struct page *page, unsigned int new_order)
>   {
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 0184cd915f44..942bd8410c54 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3747,7 +3747,6 @@ bool folio_split_supported(struct folio *folio, unsigned int new_order,
>    * @lock_at: a page within @folio to be left locked to caller
>    * @list: after-split folios will be put on it if non NULL
>    * @split_type: perform uniform split or not (non-uniform split)
> - * @unmapped: The pages are already unmapped, they are migration entries.
>    *
>    * It calls __split_unmapped_folio() to perform uniform and non-uniform split.
>    * It is in charge of checking whether the split is supported or not and
> @@ -3763,7 +3762,7 @@ bool folio_split_supported(struct folio *folio, unsigned int new_order,
>    */
>   static int __folio_split(struct folio *folio, unsigned int new_order,
>   		struct page *split_at, struct page *lock_at,
> -		struct list_head *list, enum split_type split_type, bool unmapped)
> +		struct list_head *list, enum split_type split_type)

Yeah, nice to see that go.

>   {
>   	struct deferred_split *ds_queue;
>   	XA_STATE(xas, &folio->mapping->i_pages, folio->index);
> @@ -3809,14 +3808,12 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>   		 * is taken to serialise against parallel split or collapse
>   		 * operations.
>   		 */
> -		if (!unmapped) {
> -			anon_vma = folio_get_anon_vma(folio);
> -			if (!anon_vma) {
> -				ret = -EBUSY;
> -				goto out;
> -			}
> -			anon_vma_lock_write(anon_vma);
> +		anon_vma = folio_get_anon_vma(folio);
> +		if (!anon_vma) {
> +			ret = -EBUSY;
> +			goto out;
>   		}
> +		anon_vma_lock_write(anon_vma);
>   		mapping = NULL;
>   	} else {
>   		unsigned int min_order;
> @@ -3882,8 +3879,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>   		goto out_unlock;
>   	}
>   
> -	if (!unmapped)
> -		unmap_folio(folio);
> +	unmap_folio(folio);
>   

Hm, I would have hoped that we could factor out the core logic and reuse 
it for the new helper, instead of duplicating code.

Did you look into that?


-- 
Cheers

David

