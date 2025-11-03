Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D87B9CCF9FE
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 11:50:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB0208E0055; Mon,  3 Nov 2025 06:50:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B60788E002A; Mon,  3 Nov 2025 06:50:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4FAA8E0055; Mon,  3 Nov 2025 06:50:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 910E48E002A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 06:50:41 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5F77A8965D
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 11:50:40 +0000 (UTC)
X-FDA: 84069128640.06.64E97A9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6F37B160004
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 11:50:38 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DUuAmCFs;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762170638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LAerPNjH8zWxhJYFXR906QWo/OPHYexByZle7HE1eSw=;
	b=mGqlP2CtRPXjlH6Oy2xyDcv1aZcvGczWrN/hx/JU+hSo5wZJplC8Nc7OzeUUQRopNzxNgp
	MWZb13cZS4YAQCvwfXQ/7JNZghIkVabQiVow2xUV+Axf7lB8P8xYeffKclM6PN/h+WR4hL
	Uu5J5d14sOkCnkH9uN0nIute8LceOxk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DUuAmCFs;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762170638; a=rsa-sha256;
	cv=none;
	b=4AlokuRUszn9BifBKnBw7JN1TYpdBhfqtqf83r/fAj5DGJjwq5wrm++0YEDtEu4faisCJb
	7sxw5rzFttKsCh0dI61pHzHnsazHwIBf1c29Uq4IwWSSYhnRul7a8FgE3b1JNCNQQN3oBr
	ZheENeg+QF8n+nqxa1/XGhzqFqDFtPE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6798E4194B;
	Mon,  3 Nov 2025 11:50:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F0E2C116B1;
	Mon,  3 Nov 2025 11:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762170637;
	bh=+EEkg/g+Q0B03zHNNci7pgeOMD96/c1MN2yt3uYEiLI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DUuAmCFsSCCb02llle0Z/HegHesm6hJ0FGnbgOKFjIgXhfivYgjui54AfBGeZcz6H
	 9aOticR5gLTV/s95JQUI3hy1QahwFyRWgHbq0TcGiq2an3eFRdqOdA9WSJMdVc7gwA
	 kz48Dtt3zYFx43LNWVY6qVsEnvZcu35KbzXZa0sO3UIUz0Iy22tG+j/uwTjJj8+g0K
	 q5eLs5blTQp0GVpN15zXOsj6ZNJnFyemonD+B8JTRprmleTYg/H2o+6ZqYcxd0tf/y
	 QvrGgIz+mzrZW5Jdkak2SMY91nIx27iV1G/Jnj9K4gtLwIUzQrst+3u/wGzhpF/ETT
	 LIZ9I8zT5bqKQ==
Message-ID: <f0fa3ed5-9cc4-4bce-b22f-883db9135a84@kernel.org>
Date: Mon, 3 Nov 2025 12:50:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: merge uniform_split_supported() and
 non_uniform_split_supported()
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev
Cc: linux-mm@kvack.org
References: <20251101021145.3676-1-richard.weiyang@gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251101021145.3676-1-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: onhgfoteomzuy3djzeadrtssfbji4xaw
X-Rspamd-Queue-Id: 6F37B160004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1762170638-725031
X-HE-Meta: U2FsdGVkX1801+e2941iASRxt8wrfj+WQ5empqjN+KFUjmHGt4Z0k19xRFnZs3UoILJDmy10l/xcckTRMt3z+pcHrBvxk08wgy2VKbUJCmlr7HDstot/LW8obkvjCGviXproQCw9l/YlsBWF6Ort5C86FVfMLIGbnUG7kmxP8n95kgbNGFm1sovOzHMfDCpSZtVS74y7k+2/l+YtxhSAq96cbm2Y9LH3Cl4sNczePm+9uSbV7uo6rTgdkCj9AqOsGw+BGiPT0SPHe/j+Uvcky0t+K79ajcPJTctwnZpRFu+od52SPowwgo07CS/DAznT3cIjQDQ2v5qOYcUqV220GCbr3zNmHPHn7SDIrPmfl+qG5nNT4LFtzfeGI4vEUdBfWT7X28gxQmrlwc0fI33cQro2xkaB997uUFrO71Jg3/wG49I+/wuAAQA2XxY1F8o4jB1hixRzeuZ6rrO8ai2rAhheDqktQu3G7nKGY5amGbmAlD1/R5/X2vDVAdRI1qh4vvsACJPjvUR8pYySnQbXNcBlTH2lVrgpmhZh0NPG76hsM/KO1dnuCLvjwlJLace8hcSpin1X+cTohFF1yizpjy9SXUC67TWfi8vZHjmGpZibbaWLfSaRsu/W1URZBzRviv/fIe2VY2qfK6kDzaiM5ctV2awduEVB8MvExllJTVZnCaCgqTtIb1J0MJCn+xIFZNAXWOku/Nxtyw6hV1iw3CQ6TT1qfzuB12rSLgZdq8IIC46a+OMstQ6mODs7aot8df4MlSvxp+2g/FDEdB8oYyLs2WEDmcq6LXMc/IEDS804eXeMVrhWVW2y2myt+Peiyq5F7YWZvSzGfL0Z8Fl4qJJ4bKWBILqMrc287tN9TRUPHSpMq7RwIA7g7DOuAgDxnI8ZemZeJOqcBGfN7Y/U5RVCGKRezUWI7tAgMYJ/QOQ0AYpB5CXxI1QER05e6hVC77cRb8wEDLIFVMr5gFs
 Em8KkfqI
 JKdxm7ImEvNQpObZpkzM6zBD6vf6dCBfqtwSoZDJyhLseAEG5XSv326EQQ7eImODgDwNSg2YSlwauSvFJCvLmqEOuIOXgsDZvTChOdghZvIJi1qRLQk2n9aSbPWv4y5mEAD7nKt/N01gmBIycI6HLFAEV6fUepNy3zbiA6cMAKm2By85k8nsB2a17RGo4tckPsLYn8bCpgh8ksJI+e4cDRFsbAWqacrII1BG1xYT6qojCaYg0EifxPyuqeidNrfKQECuaRlK0bR4oUZQ1usawFqAa81+SHTHVX3COYK41J+tNMclXPT/6T3eHIuJ7c7nMfVysyfNzGneKnUzakrLBD9/37Npb88OW4uW/GhqULrVGdw1/j759K0GYaal7lh52lYMnErpfGURnYe0sbQ0w1hnTk9NmcQRaglosn+jRnqh4rOw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.11.25 03:11, Wei Yang wrote:
> The functions uniform_split_supported() and
> non_uniform_split_supported() share significantly similar logic.
> 
> The only functional difference is that uniform_split_supported()
> includes an additional check on the requested @new_order before
> proceeding with further validation.
> 
> This commit unifies the logic by introducing a new variable,
> @need_check, which is conditionally set based on whether a uniform
> split is requested. This allows us to merge the two functions into
> a single, combined helper, removing redundant code and simplifying
> the split support checking mechanism.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Zi Yan <ziy@nvidia.com>
> ---
>   include/linux/huge_mm.h |  8 +++---
>   mm/huge_memory.c        | 55 +++++++++++------------------------------
>   2 files changed, 18 insertions(+), 45 deletions(-)
> 
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index cbb2243f8e56..79343809a7be 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -369,10 +369,8 @@ int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list
>   		unsigned int new_order, bool unmapped);
>   int min_order_for_split(struct folio *folio);
>   int split_folio_to_list(struct folio *folio, struct list_head *list);
> -bool uniform_split_supported(struct folio *folio, unsigned int new_order,
> -		bool warns);
> -bool non_uniform_split_supported(struct folio *folio, unsigned int new_order,
> -		bool warns);
> +bool folio_split_supported(struct folio *folio, unsigned int new_order,
> +		bool uniform_split, bool warns);
>   int folio_split(struct folio *folio, unsigned int new_order, struct page *page,
>   		struct list_head *list);
>   
> @@ -403,7 +401,7 @@ static inline int split_huge_page_to_order(struct page *page, unsigned int new_o
>   static inline int try_folio_split_to_order(struct folio *folio,
>   		struct page *page, unsigned int new_order)
>   {
> -	if (!non_uniform_split_supported(folio, new_order, /* warns= */ false))
> +	if (!folio_split_supported(folio, new_order, /* uniform_split = */ false, /* warns= */ false))
>   		return split_huge_page_to_order(&folio->page, new_order);
>   	return folio_split(folio, new_order, page, NULL);
>   }
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index d1fa0d2d9b44..f6d2cb2a5ca0 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3673,55 +3673,34 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
>   	return 0;
>   }
>   
> -bool non_uniform_split_supported(struct folio *folio, unsigned int new_order,
> -		bool warns)
> +bool folio_split_supported(struct folio *folio, unsigned int new_order,
> +		bool uniform_split, bool warns)

Likely a simple

enum split_type {
	SPLIT_TYPE_UNIFORM,
	SPLIT_TYPE_NON_UNIFORM, // or SPLIT_TYPE_BUDDY?
};

Could make invocations easier to read.

>   {
> -	if (folio_test_anon(folio)) {
> -		/* order-1 is not supported for anonymous THP. */
> -		VM_WARN_ONCE(warns && new_order == 1,
> -				"Cannot split to order-1 folio");
> -		return new_order != 1;
> -	} else if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
> -	    !mapping_large_folio_support(folio->mapping)) {
> -		/*
> -		 * No split if the file system does not support large folio.
> -		 * Note that we might still have THPs in such mappings due to
> -		 * CONFIG_READ_ONLY_THP_FOR_FS. But in that case, the mapping
> -		 * does not actually support large folios properly.
> -		 */
> -		VM_WARN_ONCE(warns,
> -			"Cannot split file folio to non-0 order");
> -		return false;
> -	}
> -
> -	/* Only swapping a whole PMD-mapped folio is supported */
> -	if (folio_test_swapcache(folio)) {
> -		VM_WARN_ONCE(warns,
> -			"Cannot split swapcache folio to non-0 order");
> -		return false;
> -	}
> +	bool need_check = uniform_split ? new_order : true;

(could be const)

Not really a great name for that variable (what needs a check?).  Maybe 
simply ...



>   
> -	return true;
> -}
> -
> -/* See comments in non_uniform_split_supported() */
> -bool uniform_split_supported(struct folio *folio, unsigned int new_order,
> -		bool warns)
> -{
>   	if (folio_test_anon(folio)) {
> +		/* order-1 is not supported for anonymous THP. */
>   		VM_WARN_ONCE(warns && new_order == 1,
>   				"Cannot split to order-1 folio");
>   		return new_order != 1;
> -	} else  if (new_order) {
> +	} else if (need_check) {

... change this to ("!uniform_split || new_order")

} else if (!uniform_split || new_order) {


