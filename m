Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 477C2CDE03C
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 08:49:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA2338E000A; Fri, 14 Nov 2025 03:49:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A79DD8E0002; Fri, 14 Nov 2025 03:49:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B7408E000A; Fri, 14 Nov 2025 03:49:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8A3EE8E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 03:49:43 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 354791402EF
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 08:49:43 +0000 (UTC)
X-FDA: 84108589446.22.A7637AD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 76AE9100012
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 08:49:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PV9NQ2cE;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763110181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RWx38PnipLzEnx5V8Xgc/qLnRXWn0lzhs9c9FCoUf+c=;
	b=irCEFHsSrgZteITUS5dlI9moz9Zc0VrVunbdqa2cq/17O3mjIounYPkFWOOmyNCkGYbFaA
	Mxc0My0TO7Qn4pm5coz2qgUzDN2i5xpajzCVjd2JW4CMLYy5DK2msuoEwjnQp/KShOnT8b
	2q7aisxnKFYHMfT8Z2184zgOZe4IiYo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PV9NQ2cE;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763110181; a=rsa-sha256;
	cv=none;
	b=Agpr4u/Mg6WDBF0C4tyoJMLxMLXnKIZbeZPn1JNtH2pbzcDNxfSRWKcmYNsK0SkEmLoAsx
	gNCi5XAM18EA71yFXs8WtLkkqZa2U4bt0Ew+J1JlNaxj33x6UdSBmdaG4E11oPnVak/k7I
	NhvYsObBQZOQDEw7UCWwYaVCUQEM6Zw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DA8346016C;
	Fri, 14 Nov 2025 08:49:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F606C4CEF5;
	Fri, 14 Nov 2025 08:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763110180;
	bh=2VjlPjr4YgqvCmkWdEAljVv3hnLPGuBJoJEbxeGw5+U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=PV9NQ2cEFX90//6qK37YDIkkXBgQAEEJbQMTojQ0TzNFMTVGbtV7SzaKE4Q2tJc8j
	 AlAIsfNfeku+vvPh2SqSDyZ+qP0EBByvPRHDrlyCJxAAEdA/RP2JCTO1xrYrUNIZ1t
	 0KlSWSrOAkUGXOR9rlWOz0PgYi9Rpb+mHYvKbMB+r9RWyaI22UZvoeqQWWAfJSaYs7
	 yniXIb8YVCoE914w4nWE6MagSt+ySOBnoFCkKhH4Pq1P68p+sWV9WcJI5zD2Snq7DW
	 i+kvJbfBXbQd0FO+MHJt+OLFBwZKOvb8jhYEHoSk2y+VfXCa86omdWjOB621C+CDdI
	 FgxcqMUOUG+fg==
Message-ID: <827fd8d8-c327-4867-9693-ec06cded55a9@kernel.org>
Date: Fri, 14 Nov 2025 09:49:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: consolidate order-related checks into
 folio_split_supported()
To: Wei Yang <richard.weiyang@gmail.com>, willy@infradead.org,
 akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <20251114075703.10434-1-richard.weiyang@gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251114075703.10434-1-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 76AE9100012
X-Stat-Signature: 77gkij4i4bp66ifp88zmkds4rct88bm1
X-Rspam-User: 
X-HE-Tag: 1763110181-479839
X-HE-Meta: U2FsdGVkX19TKmhX1XWqnM0zI9pd7iMiGhjn1/5lJcB9shM2RztZ2dwSkCrpAneKiApM5Q5jDa6/mozKc0Zo/29fa490VLgPHOlphOAmpHbYFWRaCvYW18fyPwao7/BJqwD3ui8iRB8sSJfu5vU0sHZIZRbrdn8sA38C/0ca/+2v6S/GgQbQArO7AJrOpkvN/fnI+sbf0CfTtgzsCyYlHv4qHUjw9hdTVWub8tqq9w5V7g5P6un8cFcpUjZ0uRKxY0+cKl5fjIXkto2n4wep22AIxQlldDIlO4hf4L7Sri1pldlDI2oihLSS2ARtSdCiJTdSEysq6pe3JlW4KY58WofaKO2+/yD/32yPzq3v4eiZ6jqU55EtRtiMHSieRk8RByHylicr4gNAdpAjVhZOw9TngfWVCclS9PlNFCdUzvZChS+dyPp8lYEd9uqaDEUzbx/1lcRJdp+RSWv4vMqCzvdfu6Ia9r5wDc4xd7BiH2GA8AlHglXVgb06h7B6r7UoiYS5sDpnP3GrT17aaO38Voc32F1qRzWRSJEtgKJ7fR572cltN5yT4VbTGMt160Yh8lg0NmF77rMP5tklWxkJxMxId1Detjf5LMkEY3C/eMB0lqJOjzFP0VULvvGfUsU7Mw4TgF0V9a8w61p/mN7j+KTQX6Plsz3aHtBBLp+E2+8XuBmCw9N3htjCs6Q+wSx9teb3pI/doEttVJuAcAc6RPccTAGsL4anT/KNvcDWoFXzOfy7Zp86FhktdWxUCsFWrCIstSe9rntF3nUHU4/poAkZNKETpdR1JOzkS6+idcTgTOkG5HwjU9lpMNgtT1FjDbP8t8/FoLm3ddamoqlI1aa8OxxZ90JUiALEbS/6JlFeMGH3XUNYEHvpaYbogvpETrS5BhrWQ3NUW0yfmXWR/yHBha/l7teKFYgdBFVUd8BLxrnESdCnwqNQnyHKdhIS0lkWCh0t20om8P0pSdi
 5UwDgcOm
 cgl1IgrbLIrPCAEbP5ZspOFn0OCy6Hm4MVGbI2AdeCI2FWJ84DmrrfFg9Z2QsY/IYGsO12VyaOzGfryjMUQKN4dcxsleUVQwgdSSHiDnqNhL/8VD99LtStX6S6ReNO6oJhP7WI1R8hPgkzhxtNE2TSiImbCinVt+OYkZsk10ezBZgPM/a3cfw4EdYgbN1oKC5TB/xzC7qv1toOvusNuitMzrccPiULNa8gzCgZpfFl1IIG0Da2ROekmoHddIe3c7mgDbBfFU7tdIZ3FjgjEurx8rsS2CTirOQ/4f4rXA/LGIOYFH8yX/KkxThoScN9BZevVBBDCV32CiamNL+jwGrmIP7Ob7NcUdER75aLQcDeCqlWwaD5bZQ+lsHTx3Mhr9sd+GD40raVdFktzU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14.11.25 08:57, Wei Yang wrote:
> The primary goal of the folio_split_supported() function is to validate
> whether a folio is suitable for splitting and to bail out early if it is
> not.
> 
> Currently, some order-related checks are scattered throughout the
> calling code rather than being centralized in folio_split_supported().
> 
> This commit moves all remaining order-related validation logic into
> folio_split_supported(). This consolidation ensures that the function
> serves its intended purpose as a single point of failure and improves
> the clarity and maintainability of the surrounding code.

Combining the EINVAL handling sounds reasonable.

> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> ---
>   include/linux/pagemap.h |  6 +++
>   mm/huge_memory.c        | 88 +++++++++++++++++++++--------------------
>   2 files changed, 51 insertions(+), 43 deletions(-)
> 
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index 09b581c1d878..d8c8df629b90 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -516,6 +516,12 @@ static inline bool mapping_large_folio_support(const struct address_space *mappi
>   	return mapping_max_folio_order(mapping) > 0;
>   }
>   
> +static inline bool
> +mapping_folio_order_supported(const struct address_space *mapping, unsigned int order)
> +{
> +	return (order >= mapping_min_folio_order(mapping) && order <= mapping_max_folio_order(mapping));
> +}

(unnecessary () and unnecessary long line)

Style in the file seems to want:

static inline bool mapping_folio_order_supported(const struct address_space *mapping,
						 unsigned int order)
{
	return order >= mapping_min_folio_order(mapping) &&
	       order <= mapping_max_folio_order(mapping);
}


The mapping_max_folio_order() check is new now. What is the default value of that? Is it always initialized properly?

> +
>   /* Return the maximum folio size for this pagecache mapping, in bytes. */
>   static inline size_t mapping_max_folio_size(const struct address_space *mapping)
>   {
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 0184cd915f44..68faac843527 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3690,34 +3690,58 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
>   bool folio_split_supported(struct folio *folio, unsigned int new_order,
>   		enum split_type split_type, bool warns)
>   {
> +	const int old_order = folio_order(folio);

While at it, make it "unsigned int" like new_order.

> +
> +	if (new_order >= old_order)
> +		return -EINVAL;
> +
>   	if (folio_test_anon(folio)) {
>   		/* order-1 is not supported for anonymous THP. */
>   		VM_WARN_ONCE(warns && new_order == 1,
>   				"Cannot split to order-1 folio");
>   		if (new_order == 1)
>   			return false;
> -	} else if (split_type == SPLIT_TYPE_NON_UNIFORM || new_order) {
> -		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
> -		    !mapping_large_folio_support(folio->mapping)) {
> -			/*
> -			 * We can always split a folio down to a single page
> -			 * (new_order == 0) uniformly.
> -			 *
> -			 * For any other scenario
> -			 *   a) uniform split targeting a large folio
> -			 *      (new_order > 0)
> -			 *   b) any non-uniform split
> -			 * we must confirm that the file system supports large
> -			 * folios.
> -			 *
> -			 * Note that we might still have THPs in such
> -			 * mappings, which is created from khugepaged when
> -			 * CONFIG_READ_ONLY_THP_FOR_FS is enabled. But in that
> -			 * case, the mapping does not actually support large
> -			 * folios properly.
> -			 */
> +	} else {
> +		const struct address_space *mapping = NULL;
> +
> +		mapping = folio->mapping;

const struct address_space *mapping = folio->mapping;

> +
> +		/* Truncated ? */
> +		/*
> +		 * TODO: add support for large shmem folio in swap cache.
> +		 * When shmem is in swap cache, mapping is NULL and
> +		 * folio_test_swapcache() is true.
> +		 */
> +		if (!mapping)
> +			return false;
> +
> +		/*
> +		 * We have two types of split:
> +		 *
> +		 *   a) uniform split: split folio directly to new_order.
> +		 *   b) non-uniform split: create after-split folios with
> +		 *      orders from (old_order - 1) to new_order.
> +		 *
> +		 * For file system, we encodes it supported folio order in
> +		 * mapping->flags, which could be checked by
> +		 * mapping_folio_order_supported().
> +		 *
> +		 * With these knowledge, we can know whether folio support
> +		 * split to new_order by:
> +		 *
> +		 *   1. check new_order is supported first
> +		 *   2. check (old_order - 1) is supported if
> +		 *      SPLIT_TYPE_NON_UNIFORM
> +		 */
> +		if (!mapping_folio_order_supported(mapping, new_order)) {
> +			VM_WARN_ONCE(warns,
> +				"Cannot split file folio to unsupported order: %d", new_order);

Is that really worth a VM_WARN_ONCE? We didn't have that previously IIUC, we would only return
-EINVAL.




-- 
Cheers

David

