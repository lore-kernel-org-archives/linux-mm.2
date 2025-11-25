Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA132CFD364
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 08:58:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1428D6B002A; Tue, 25 Nov 2025 03:58:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F41B6B002B; Tue, 25 Nov 2025 03:58:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 009006B002C; Tue, 25 Nov 2025 03:58:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E2BCB6B002A
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 03:58:12 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 836628A40A
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 08:58:12 +0000 (UTC)
X-FDA: 84148527624.03.FEAFB2D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id CC00B40009
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 08:58:10 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="qd/lV+kX";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764061090; a=rsa-sha256;
	cv=none;
	b=smSnHAqhohPWKdhGbc1q5wAu6LxNRXp+q/96BuGok3ZlDKc5hhOUEyinnizVpRkw90BrdZ
	bLSEmS0KudL2hcLOQX/dfUjT+usuOKPJTFSwkYVBboQxlixT4BsBAVmlf5acaxN7fOFG1I
	e25sJDL0kHDRyNRuwQXXuggBZBcztxY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="qd/lV+kX";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764061090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uB9zfY8rl00VGS2LlLw9JvkjHVPu11SrgOH6XYWxj5c=;
	b=ngUiGHGIVfYyzrN35ouqj0y9eT+aAfoBwhPcLH1MB947a54hpeOMvzNr5viN1bwXP0VRJd
	0JASMejl12xXawt3nkfOVPZAyj7aked8X5zkZVCM22F7v5QMhyPacyD+U7o+7dG1Fk6FE6
	d2f9OYYuhLnd0SecGG2v6IXaqk00CTw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 48CFC60185;
	Tue, 25 Nov 2025 08:58:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A55AC4CEF1;
	Tue, 25 Nov 2025 08:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764061090;
	bh=nAXWuJtSjBIcO6/FobEkrLN/I6WQQ5is6xaKK3EqJg8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qd/lV+kXV823/dqZYQyjNpk9Nq6la3jMN44UkQVCD5maKDw8ebaQjIMyP4KTE+slP
	 C+DBaHpVPOYWTSdoPVwWBaBj7gO3gwrYugftPBfUXdPeZaoq6e422zKRQvordVBZU1
	 7R4lZ6CqEBMC6srVnhIEI0Bgaw7D+wodXrO4lJfMS/9k+/M2VBlXhH5Dx+alEUTLNQ
	 Io3PBIJbQ6WRAi5pA6LU9JYONzCCA52ttQBLuh+WdbqsAyfqc0XjjRlXw8iMvsn2kN
	 aTkVvtvbw/0zrw6XPUbkTJHaOOvNec1BPomP7ZQ2H4Mhe3Tnod5jNsI0gFUpwAk/Zf
	 8MJnOFHWf5PrA==
Message-ID: <e5118fe1-7963-4f09-a80b-e6185ffcb366@kernel.org>
Date: Tue, 25 Nov 2025 09:58:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] mm/huge_memory: change folio_split_supported() to
 folio_check_splittable()
To: Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Wei Yang <richard.weiyang@gmail.com>,
 Balbir Singh <balbirs@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20251122025529.1562592-1-ziy@nvidia.com>
 <20251122025529.1562592-2-ziy@nvidia.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251122025529.1562592-2-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: CC00B40009
X-Stat-Signature: 4wz358j1kxfnww6zjjgtepeq7haae16c
X-Rspam-User: 
X-HE-Tag: 1764061090-704734
X-HE-Meta: U2FsdGVkX1/8sUKC3bKBVuaUBb4dBWPsnXozL2qWNOMePNfWZ9G1uYD9hKPWKqWbSvQnVV/ooUOjAz+HNQ1chnsbS2+1MurZVkZk6TvpKcaqdEZ8zAA1IiIzNHTET1qhF0g8PJd3GK5zw+6KmyBcbND0jYn3Zm3l4fFbJWWuUdlIXLT6LdV5EKWaI+D+omcbKSJ35eRUKH7wdKEBu752RHpPc+Pkd1UtWMA3b+8hOhO0s2HmwwOnm2Q5eD1l/52kPzenfdJrTnvh2VP8nWQ0FOmZ0R8J6n5FJvGAZ0Ee4noT+QW+CIOMO+rVaTt2lovYeJCjl8tMi6GnnSobyA2+d9TI4aoUjA+cSPJWkrQ7xhk5Z1Ug8ZqxNzR7PuKCFesxDgnOsXg9A5eRJTNhNxP7U0j1h1IHeLMYBvvVW/S5ZPOFZQytyXI2q+qEUFUR/XW+dm39e1N4LjtMdfgN6YDzMe6gtedJhqqIppJNKJijFA13yJieHQ/OC0nM4wHe59KXoN7XmuRZO1I1A0HCcwV2CPJUeEFZwaaxesMVxPHJaO00NTdhNYIGWHkPINZylB47MhUDJKTHYRriEUsOMwTuYxO4UgetUdhkUJzlhu1J8j8ZHw/MFrRtK1w+1VJyR57eKhN5XOhYdIttueqZq8hCXtntjPSU4afFNUqUJJ9wB1zASFEwLP4AdPDJo1NKwa7egDNsmRoxJFmo9cSnEajsBhu3qcs04VCWxhGTsX+k9RRiu+2O39kH3+EGDCddH7PiHN1kYdRrOqLIVyRjkOILhas/+mNzy+fyD38o+jHf1RmCpqvTggESO4Aa7BPrIegc8Ui7oC7zCoDS/naCTSxf6aWQs/qsOWmErMq450wyNpgzRnHxTOYYwEyobpQ2+uKW5/UPgzyEbzVxfzSs40BKKOSOhvM8cSvpCgblCamD3YBxyST3Pskv29912IwRK2UDnzwyd65q7nICc8BIp4S
 dwbiN9VX
 7VaHIKtxyD437VvXIkEWP6Ezy4akWXb0zcSsZe7czg6GFS2QWW87Nck69dAMcODype663eQ5kP5l/gCAuC9dziu16/p695TBVEnhClfxgKZGrm/1DLANEDWNc1lvkfU8PylijFxjDR9D2ErWjboex97lIcvWwq3gsAr+p/03k4aOk4wix9Crqwr4+qGes4V+2l3ls0RpNCB6LMskzmmhNjnVBMurAhbWzU6XqrmOq7+3r5rTwy3mtVnF61jqxyQ5HbWO8qKBHJWLrFnIBM4XkRUE3GkmE4KuY6tQZylIc91jDu2bMR0DVL1vMKGCs1y4AbPW5VTjtlXZPh5AFHn8/BmXAHkgnx543bDmMpR5+44XC9cdGdlegjCXt4+6nkC7Vnvcrtb9o1XBEd98amhX8uS/ClA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/22/25 03:55, Zi Yan wrote:
> folio_split_supported() used in try_folio_split_to_order() requires
> folio->mapping to be non NULL, but current try_folio_split_to_order() does
> not check it. There is no issue in the current code, since
> try_folio_split_to_order() is only used in truncate_inode_partial_folio(),
> where folio->mapping is not NULL.
> 
> To prevent future misuse, move folio->mapping NULL check (i.e., folio is
> truncated) into folio_split_supported(). Since folio->mapping NULL check
> returns -EBUSY and folio_split_supported() == false means -EINVAL, change
> folio_split_supported() return type from bool to int and return error
> numbers accordingly. Rename folio_split_supported() to
> folio_check_splittable() to match the return type change.
> 
> While at it, move is_huge_zero_folio() check and folio_test_writeback()
> check into folio_check_splittable() and add kernel-doc.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>   include/linux/huge_mm.h | 10 ++++--
>   mm/huge_memory.c        | 74 +++++++++++++++++++++++++----------------
>   2 files changed, 53 insertions(+), 31 deletions(-)
> 
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index 1d439de1ca2c..97686fb46e30 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -375,8 +375,8 @@ int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list
>   int folio_split_unmapped(struct folio *folio, unsigned int new_order);
>   int min_order_for_split(struct folio *folio);
>   int split_folio_to_list(struct folio *folio, struct list_head *list);
> -bool folio_split_supported(struct folio *folio, unsigned int new_order,
> -		enum split_type split_type, bool warns);
> +int folio_check_splittable(struct folio *folio, unsigned int new_order,
> +			   enum split_type split_type, bool warns);
>   int folio_split(struct folio *folio, unsigned int new_order, struct page *page,
>   		struct list_head *list);
>   
> @@ -407,7 +407,11 @@ static inline int split_huge_page_to_order(struct page *page, unsigned int new_o
>   static inline int try_folio_split_to_order(struct folio *folio,
>   		struct page *page, unsigned int new_order)
>   {
> -	if (!folio_split_supported(folio, new_order, SPLIT_TYPE_NON_UNIFORM, /* warns= */ false))
> +	int ret;
> +
> +	ret = folio_check_splittable(folio, new_order, SPLIT_TYPE_NON_UNIFORM,
> +				     /* warns= */ false);
> +	if (ret)
>   		return split_huge_page_to_order(&folio->page, new_order);
>   	return folio_split(folio, new_order, page, NULL);
>   }
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 041b554c7115..c1f1055165dd 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3688,15 +3688,43 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
>   	return 0;
>   }
>   
> -bool folio_split_supported(struct folio *folio, unsigned int new_order,
> -		enum split_type split_type, bool warns)
> +/**
> + * folio_check_splittable() - check if a folio can be split to a given order
> + * @folio: folio to be split
> + * @new_order: the smallest order of the after split folios (since buddy
> + *             allocator like split generates folios with orders from @folio's
> + *             order - 1 to new_order).
> + * @split_type: uniform or non-uniform split
> + * @warns: whether gives warnings or not for the checks in the function
> + *
> + * folio_check_splittable() checks if @folio can be split to @new_order using
> + * @split_type method. The truncated folio check must come first.
> + *
> + * Context: folio must be locked.
> + *
> + * Return: 0 - @folio can be split to @new_order, otherwise an error number is
> + * returned.
> + */
> +int folio_check_splittable(struct folio *folio, unsigned int new_order,
> +			   enum split_type split_type, bool warns)
>   {
> +	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
> +	/*
> +	 * Folios that just got truncated cannot get split. Signal to the
> +	 * caller that there was a race.
> +	 *
> +	 * TODO: this will also currently refuse shmem folios that are in the
> +	 * swapcache.
> +	 */

Per the other discussion, should this even be:

"this will also currently refuse folios without a mapping in the 
swapcache (shmem or to-be-anon folios)"

IOW, to spell out that anon folios that were read into the swapcache but 
not mapped yet into page tables (where we set folio->mapping).


-- 
Cheers

David

