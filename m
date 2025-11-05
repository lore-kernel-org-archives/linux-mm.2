Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CAADCCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 08:05:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AF468E000A; Wed,  5 Nov 2025 03:05:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 986A28E0002; Wed,  5 Nov 2025 03:05:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C3C18E000A; Wed,  5 Nov 2025 03:05:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7BA4D8E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 03:05:39 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1DB26C022A
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 08:05:39 +0000 (UTC)
X-FDA: 84075819198.26.6F6F206
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4EF0940002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 08:05:37 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qwvVWSop;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762329937; a=rsa-sha256;
	cv=none;
	b=4X3iif2R4eISbsD5eYWYfrtw3kUbmclLXVWKsP0Rw193XJkHJzRgbP67xWrWrhQprQ6Sn7
	Jq3k7a3aBMCkzv21Lb4QnU9wTyzVg4pOIxRJDqjmpXyhe+hZtMOTWG8Wt+NK6lfp5redep
	rrb5ExaEsPRMS/6XEnzVzWNQ9N5DVi0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qwvVWSop;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762329937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CmmvfBB7KB+mpdqOZEB/2pWZzOVkgz56JxxJ/+4H0uA=;
	b=RQWTNwb1Zz7nUBR4qqkvfz8f7vo6ZUG6P33pnw7iGDSII9cBoEJMs7Mz/wUWDkVk06MEs8
	a1e8Bt8h5ZA7FHt41kQ5ixeAN0CdBLkSoGSE6khRnYQQ9bGiOXpK8SyXNyyfZoZXh8J6o1
	RDiUxn/RhRJTV75lI1sbkwFdmrx3Eeg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1CA9244140;
	Wed,  5 Nov 2025 08:05:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BCABC4CEF8;
	Wed,  5 Nov 2025 08:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762329936;
	bh=nG8FGA4KyJK5cpMdCvJlOe63E9nwFMWwmlWXh5Sedf8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qwvVWSop/bgFGIeD2dIXyPv8/fmHiXa2B9skzb27qLkDWFkFkuVPuVDQz4kiXktrl
	 R76vsrP8x/6JbSAGUKwrOpjeTgRwGHvS0xSnKnaAkzY0fR2ejY2H+t5EKl6TmyQkmI
	 isxaK1KkhsJxQuTmqvB15OAAnj1GeLsItsY3U4Y1dn8XOi0e1R8aA39usD0Y24mijH
	 PiJM5I5jLErKMywxSBlfE3EFYQHNogmkcx64BTSbzuQQ789gO38nDHpNE7qhadEHef
	 mSoHHfyqzszkZOenm1dhNG+Y95FQCyemnqgXYpJzUSvVT2mUscVRxrSWCqXyeTJz6d
	 OAwp9o1ASdZiw==
Message-ID: <dc0ecc2c-4089-484f-917f-920fdca4c898@kernel.org>
Date: Wed, 5 Nov 2025 09:05:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v2] mm/huge_memory: merge uniform_split_supported() and
 non_uniform_split_supported()
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev
Cc: linux-mm@kvack.org
References: <20251105072521.1505-1-richard.weiyang@gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251105072521.1505-1-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4EF0940002
X-Stat-Signature: 411joe5aycieibkwdyr7zn6n3ih3gsf7
X-HE-Tag: 1762329937-343529
X-HE-Meta: U2FsdGVkX19HH6sw5H5Ez6o1G6cdqbBTim+rP56CtFcYBcXaZb/OBIAMD2WytVCHLhTEtZ85WLDXJHZszng+NZ+qmtD9ZXjzKurI0oFx5c3QtOxAHHyic8AwBhO/pN7zTkimC+9mBbiG+5XlLNTTCyKCfV5LMQweoBpDHD8EYpw4B3TtZLNBVdH5QHsnz0l+/Gg9Fs5SjL/Jza0fhFvOJHvpoDoQJCy56yW8KshMAJOpmwGt0HL0i4Qx9e6af/CfHs2QM4WWQZFig6Vp2ZgFB2kuW8eUmYjIMQVzl6mWlljR8Vz1+o43wyCvW9rfHma4vrG8God3dX+YDpTbSpIyPOLbTHnxnRUZ8pokVywZ+7zrmzw7ZvcbzfyZgjPfkacZfnvwSiDleOV2q4MXfutl7L6padStwZbEC4V4kIlQUFh7a8gURRoNnUO2PMmM/VCjTmSoKoga7T2JbnH15yOA9kKBZKF/SLvBtJKbT0p0Yxkve/cBfH690LqJrb3yA+NpQCyk94D4gCnGTpwaQFyR2tIyohSt/T7LTiW6GnKSNx0IKn1aqjbOXz33xvKKfVwziQr502hjo8oLU6YkbnxHos4toH/SvnAMdeLVytQ2HMvQOgJPKSNGn4k8+ra42hMFOw2xCTYcxc8YBHq/FNjW0HyX3e+Uz38y5k3sx15868/RqF8tCuEhO6tpHzHVQrwVh/3HCcbaM9RJVup/7O7Y9gcqRTvp6aaAZRM8i8D2HxDoJT6R0a0LUG0Uk6If/vY6anunf4xfDeZUHw86bkqxWzRxuD+Ue37gc2VIGG9hVx7FQx9LrEY3oy1hT10+eSpAaEHL/KBooYDgbHoKONfcxIlgIG6NPyNCGNDKfwA0iiZVxqhGyeuTZHaGhLfXn9RiZhB//NffaXbDSXuZDwg+Px9oQoxE/dyOGZIYKRqm4AWc3INpUIXw+c9OcV69Lh7dJM7628BoFqEjHM5HiSp
 5i7xztwL
 X87zg0Yhtzu26gjZWgeUcYw5XC3XNBOx/h5nTul10XOdAW3fXuUPfAtp7mwLoOvyad33WOIx4gpn9RD8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05.11.25 08:25, Wei Yang wrote:
> The functions uniform_split_supported() and
> non_uniform_split_supported() share significantly similar logic.
> 
> The only functional difference is that uniform_split_supported()
> includes an additional check on the requested @new_order.
> 
> The reason for this check comes from the following two aspects:
> 
>    * some file system or swap cache just supports order-0 folio
>    * the behavioral difference between uniform/non-uniform split
> 
> The behavioral difference between uniform split and non-uniform:
> 
>    * uniform split splits folio directly to @new_order
>    * non-uniform split creates after-split folios with orders from
>      folio_order(folio) - 1 to new_order.
> 
> This means for non-uniform split or !new_order split we should check the
> file system and swap cache respectively.
> 
> This commit unifies the logic and merge the two functions into a single
> combined helper, removing redundant code and simplifying the split
> support checking mechanism.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
> 
> ---
> v2:
>    * remove need_check
>    * update comment
>    * add more explanation in change log
>    * selftests/split_huge_page_test pass
> ---
>   include/linux/huge_mm.h |  8 ++---
>   mm/huge_memory.c        | 70 ++++++++++++++++++-----------------------
>   2 files changed, 33 insertions(+), 45 deletions(-)
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
> index 381a49c5ac3f..db442e0e3a46 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3666,55 +3666,49 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
>   	return 0;
>   }
>   
> -bool non_uniform_split_supported(struct folio *folio, unsigned int new_order,
> -		bool warns)
> +bool folio_split_supported(struct folio *folio, unsigned int new_order,
> +		bool uniform_split, bool warns)
>   {
>   	if (folio_test_anon(folio)) {
>   		/* order-1 is not supported for anonymous THP. */
>   		VM_WARN_ONCE(warns && new_order == 1,
>   				"Cannot split to order-1 folio");
>   		return new_order != 1;
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
> -
> -	return true;
> -}
> -
> -/* See comments in non_uniform_split_supported() */
> -bool uniform_split_supported(struct folio *folio, unsigned int new_order,
> -		bool warns)
> -{
> -	if (folio_test_anon(folio)) {
> -		VM_WARN_ONCE(warns && new_order == 1,
> -				"Cannot split to order-1 folio");
> -		return new_order != 1;
> -	} else  if (new_order) {
> +	} else if (!uniform_split || new_order) {
>   		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>   		    !mapping_large_folio_support(folio->mapping)) {
> +			/*
> +			 * We can always split a folio down to a single page
> +			 * (new_order == 0) uniformly.
> +			 *
> +			 * For any other scenario
> +			 *   a) uniform split targeting a large folio
> +			 *      (new_order > 0)
> +			 *   b) any non-uniform split
> +			 * we must confirm that the file system supports large
> +			 * folios.
> +			 *
> +			 * Note that we might still have THPs in such
> +			 * mappings, which is created from khugepaged when
> +			 * CONFIG_READ_ONLY_THP_FOR_FS is enabled. But in that
> +			 * case, the mapping does not actually support large
> +			 * folios properly.
> +			 */
>   			VM_WARN_ONCE(warns,
>   				"Cannot split file folio to non-0 order");
>   			return false;
>   		}
>   	}
>   
> -	if (new_order && folio_test_swapcache(folio)) {
> +	/*
> +	 * swapcache folio could only be split to order 0
> +	 *
> +	 * non-uniform split creates after-split folios with orders from
> +	 * folio_order(folio) - 1 to new_order, making it not suitable for any
> +	 * swapcache folio split. Only uniform split to order-0 can be used
> +	 * here.
> +	 */
> +	if ((!uniform_split || new_order) && folio_test_swapcache(folio)) {

Staring at the existing code, how would we reach the 
folio_test_swapcache() test for anon folios?

At the beginning of the function we have

if (folio_test_anon()) {
	...
	return new_order != 1;
}

Aren't we missing a check for anon folios that are in the swapcache?

-- 
Cheers

David

