Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 213BDCCF9FE
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 09:05:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 706228E0049; Mon,  3 Nov 2025 04:05:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B57A8E002A; Mon,  3 Nov 2025 04:05:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A4838E0049; Mon,  3 Nov 2025 04:05:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 47F498E002A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 04:05:02 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DAF1B5C251
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 09:05:01 +0000 (UTC)
X-FDA: 84068711202.03.7C141F2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 17F5E10000B
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 09:04:59 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf14.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762160700; a=rsa-sha256;
	cv=none;
	b=qSRVwhVyOqw3lmm3GL1zNkFKEQVVC27USKHhwZ1CweyqL4wYTRY5PyUHCrqw4nQELcgcXw
	hPAKf4AyXqyCWovaHLfGYoQ27MlsrguIaSS8ymDsx1QGV2Oww0v2s4BW1MdC515spW+dIb
	jziHCorr9FNpKqvLOhNJDKylF2kJfgg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf14.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762160700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sZMmvO2vULw51KFZ5FR0r3MvBKRcMFfMVgoIgmfHa/w=;
	b=hGPfNP+IruOsGNnlkv6b1ObBtLnyp9qceR0cwUYq2nYAT7ZdgvedVm35JlfBpeJxL2vWqX
	St32g1HIY/snN3+oz29e083fdZBec4vWPGtDPP9D6wAUIA3TNEhHZ6bRXmTU1CnNJX0e1l
	DdOjEMjhOF8HYCCBgLqFYJQ0W+NJQgo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4690A1D13;
	Mon,  3 Nov 2025 01:04:51 -0800 (PST)
Received: from [10.164.136.41] (unknown [10.164.136.41])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A1EF93F63F;
	Mon,  3 Nov 2025 01:04:55 -0800 (PST)
Message-ID: <0d79bb63-38c8-4dc8-9ee5-13e13820fb75@arm.com>
Date: Mon, 3 Nov 2025 14:34:52 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: merge uniform_split_supported() and
 non_uniform_split_supported()
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, baohua@kernel.org, lance.yang@linux.dev
Cc: linux-mm@kvack.org
References: <20251101021145.3676-1-richard.weiyang@gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20251101021145.3676-1-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 17F5E10000B
X-Stat-Signature: zq7kys7d83kcszdyme13jpirxhk89o5g
X-HE-Tag: 1762160699-861278
X-HE-Meta: U2FsdGVkX1+prao7P27hpRBCMA1RZkrFBdy9uW/F6SYQHtwufZibHucTb9PIRx7w6uBYD1btSFkMEdsLbuEPVZ5NRrwXkXfMIT290Oy4oz5b6eq5zWui9SikidOZxT3EEhYRARAuUYW7eJ4Y2JHkfQdldFm7BO/8uDE1qMyt5mz/g0guuLE1IJzeImmz7rPVc7BHgoNtvZZhyVdV2nPyfSDEDiznkahkzVuXrCjIoEPDdt0wVyjnNZGcwiZ4Lx87XezJdxdNEmEvKXX+2Vq2gfim2BwuLzi5kY61px+XCioFKemIl1Qt10bQxKzrkLhG+sLErliAXNs9v+5EFqq8Lcqa9Pl7xzhI1AlRXrcy4ZtnXcI9kbsF6sYjalYqUjfyh0I5kDsiQK0wc7F3iz2ZISUmxTGSUWVwLL6yzJGLvfsImUvZTqvBef580LJ654BxefjLA42FiUJcPmHgt/9pibmOR37PJrzIv0TQHAFK7Z+Maq++bKfqTcgvfqkf1rChQM3nsBlFGKBdtI4ac3vs28nH2UlK3qaZmOJvpdkS5dxrSKho1ZHaXboyP25YKXvv9zdxcGLotmFWMfKSX9TDeUTG0SLlrb40Ml5jFl4zhI/hEeEB4U/q+7CMpkZsAsrP2vO+W6ojqg/Ydqfg3EwRtTb/5EOuJ99niBdkGgWwceafAfSorkOBmfAU0ZPzIFbhYwYMTuNuPq+gsmSVJIbfgtxs+hq+6XX75iiC7iaW1l4feLLl2gKwtrtmrNPYcBAMveO2whCzmRgn89CdEdgWPHd47xjj17bxZqdLBYKNEI4LPu1yW4Lb5w/BFfTP6FehTLmm/JVMm8nkZ3o/pWnCqaMHKRa9bVDKGfSDFXizVmnt/VQ+h1lG1H3yOaiHPyma6F5aorPTX/f0r+eWGIrqpN0CNCLwneKV3wheXYhvwZRvYGyru3s+6RBwLQovJ4uwuwDU+A+3SpRRI0ZQOfc
 zx5y/Fcv
 KHCIXNWFGUkJ6WnhKQ73SQ3O4yHiCB17VzC+pkFaHxC6XCygO36UO0n32NAd3v6rfHYZ725X+iIyx4FnNvPi9rxsRlkbmYgdE1QchqGOHY1lt+qu1GYFLfRxFvE6LmxagsOgh9B/gM0NTzwJtlWmataEbock5v1XYVE2FANtOyHkZYpQb71HIIzOgy1Iy7dJfm9pLRZ86zNwv09p6N6GUo9bLXAlNCmMLkA5Nn8F2vJ5en395gdaZgK3i6FWJgg68uWPNTYDZv8gFMXoD9JfbRvC8YXbBedDtffE18bdpKjCrMw4c2k+kLULoog==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 01/11/25 7:41 am, Wei Yang wrote:
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
>   		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>   		    !mapping_large_folio_support(folio->mapping)) {
> +			/*
> +			 * No split if the file system does not support large
> +			 * folio.  Note that we might still have THPs in such
> +			 * mappings due to CONFIG_READ_ONLY_THP_FOR_FS. But in
> +			 * that case, the mapping does not actually support
> +			 * large folios properly.
> +			 */
>   			VM_WARN_ONCE(warns,
>   				"Cannot split file folio to non-0 order");
>   			return false;
>   		}
>   	}
>   
> -	if (new_order && folio_test_swapcache(folio)) {
> +	/* Only swapping a whole PMD-mapped folio is supported */
> +	if (need_check && folio_test_swapcache(folio)) {
>   		VM_WARN_ONCE(warns,
>   			"Cannot split swapcache folio to non-0 order");
>   		return false;
> @@ -3779,11 +3758,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>   	if (new_order >= old_order)
>   		return -EINVAL;
>   
> -	if (uniform_split && !uniform_split_supported(folio, new_order, true))
> -		return -EINVAL;
> -
> -	if (!uniform_split &&
> -	    !non_uniform_split_supported(folio, new_order, true))
> +	if (!folio_split_supported(folio, new_order, uniform_split, /* warn = */ true))
>   		return -EINVAL;
>   
>   	is_hzp = is_huge_zero_folio(folio);

@Zi, I am confused on the code. Is there something stopping us from passing a zero new_order to
non_uniform_split_supported()?


