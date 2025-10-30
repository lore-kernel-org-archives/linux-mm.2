Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E623CCF9EB
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 02:31:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03E058E01B7; Wed, 29 Oct 2025 22:31:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 015CB8E01B2; Wed, 29 Oct 2025 22:31:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6E188E01B7; Wed, 29 Oct 2025 22:31:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D57168E01B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 22:31:28 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 819D01608C5
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 02:31:28 +0000 (UTC)
X-FDA: 84053204256.12.BB1733F
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9A0F32000D
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 02:31:26 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="oj/IxwZx";
	spf=pass (imf13.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761791486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gg4L5oAgYBz25YzLH6kOdzXmTMAfYlJEqOAX4aq55Yw=;
	b=Ksj3YG+BnOB6uqTJV0UHUf+sL6wGWr8l2pMmZxBZ4kg8XgM4lk1JYeuin9V/XwnxOysOQl
	f2/nLH4QQIQIACebPuLXwVyIpigjIRu69r+yDFbEvsuZJa/aeUUVNi5wdUINRD0tDI3x9J
	W9o6Mz/502z5fzw7ClL9CNN3VaZl8X0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="oj/IxwZx";
	spf=pass (imf13.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761791486; a=rsa-sha256;
	cv=none;
	b=RH75RQuZurYZfliGxzgq9ewpiqNY79DSdcxOMRRemD/AJzFMQNVn14rBz2k5ft5KtRSOy4
	6g6zJ4H7oR6lRiMOUjNNl6FxVIx+24DaDni2hbGD0ET1eP2N//8AL95X7Qy4WS5hiCn4zx
	z5zMNU4bbf95zW55p86xLTJBDLT2bow=
Message-ID: <17dea8a6-b473-44da-82d2-d84223b7cdf1@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761791484;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Gg4L5oAgYBz25YzLH6kOdzXmTMAfYlJEqOAX4aq55Yw=;
	b=oj/IxwZxyaupSvCLMQpNxLfuw7iq585mKCxt6iInm0NvZqxAaK8/HNxYFqEw9lvOX+MYbV
	NsbYr5c5G7phrIlLb6EihUTZUI01NJBIzVYe+4bW4MhClIsxGEw9uX1IkzVx7LCNH566dB
	+B0rDKkAh6TBO9Oprm8pAr6FeFFLIIY=
Date: Thu, 30 Oct 2025 10:31:12 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v4 3/3] mm/huge_memory: fix kernel-doc comments for
 folio_split() and related.
Content-Language: en-US
To: Zi Yan <ziy@nvidia.com>
Cc: kernel@pankajraghav.com, jane.chu@oracle.com, akpm@linux-foundation.org,
 mcgrof@kernel.org, nao.horiguchi@gmail.com, david@redhat.com,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 linmiaohe@huawei.com, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Wei Yang <richard.weiyang@gmail.com>, Yang Shi <shy828301@gmail.com>,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20251030014020.475659-1-ziy@nvidia.com>
 <20251030014020.475659-4-ziy@nvidia.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20251030014020.475659-4-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 9A0F32000D
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: tsb3gxpdcpsymbk4bjpkbi3oyjd7i446
X-HE-Tag: 1761791486-458486
X-HE-Meta: U2FsdGVkX18NovWufRvMaR3lDY/QDb3TJpNN+rWzgDhz4wLQZeZ+LEQ2caTS+wW+gh8ZZPMhXPtr3z4sg7rdHEUvNHfQiAF+HjPsYyOzuALE6pVIqZfeFpOasQvmy0+XXkYya0uOD3L8WmM2KnE2S/3X6F1y/Gg9FKKHlwPOxyNehoNCcX0wYl2KbP7bvwUYHR8hjkhBewx+aCXIza/Ak0A85DITSCAICzL4/W6wbHfQgOrJ8YxCHfT9OHKisBzC+PzuCq1MJXrA/VZE3/3Tdg3QaRexInLHBC4sjNt2Wz3ekrd1u+NbWbgBBjXewj6kV9hzDDedsqTJ1XGWlie7R+3E1yhg2zgrGxcTCQhJ0u+mWT2WJ7y+KPDOfDnMY+lX+fNW2rg54W2+kNm0Udyb3DyBAHpcxuruXtVjI7nm+iVHK0s+oM0h1I3E8DCa3CWLC6+iAFjUP/T5SqCfGpxYX5JuGFKg/LfneqgdKAzNhWYKDO/gHH3j+/GHsi36Bd2GS6fH3R07iEe7/DB32zP165MIdoJ5RNwY3V2zjQnKR3dGPDjqNlJldmTXakUpgYYtQD1yGnE2grFJsxclULg8cyYf/pAitQJSdilPIzRR9rUSjOzBav/28Vvfv2q5a5yMVXwe/TAZmxjTQI7dU+Dl/M8lHw9Dkzi2Y5OA/thKpvLlNDt6eqAjVR/69Uolp10qpTr12JOvK6zldGZXBuGfhuir9XAaOCvYTZEQEvFct2dmmXuOwWx9hXH3yTdccl7eCK4VxIDKR7d3w/MU+SLDR6pa0pJhEsT8Hccr001Irk6WHr6RK8Z6navxSSGcWZ7Q6oBuVQyTuTy3NZBDHiMQj0QjBgb183LRzPZFz5KTFNpMhJ7bp1fPM3B/mPMou+My1tH4vbyl3tc2pt0H0XYvXBw3LZgSV0nsmbiy6yaQkMWPrwnEfOvpfFDytkJXZJMdzrVH1VyLNAjiF2QnjXu
 mm+fTgpy
 X4Fh+AfPdEh+2RsRIwNcCJjvyaxste+4m96kMF/8v7285ILIYqW5nkT6y6xYg3YGVyo7k3RfJl4UP7ZkQak/bGo3z9Yg5t1ISObHxr/TUJ+uSEonU7O3VCw4oqeiE/ZI1mJonka4Ga9Wa0YYylQhppTd1aI8K0EFC1TxFuZrE5BsXsp3zncTg3x+HIktlaM5ykwQQEbBn7705UegR0UrlhKavFLmizFtzbsiQYmBIVAv8uiZuOG0PZluIBIRHAD+5lzzTdC5YrK7l/u8+Ljf6CM8JPPcgLQ2Q0Ws8c4ij3um2oCh26ivxIRiYNkiE6DoEcQzB7xMsA3+V/puJcOLZrwJSNuJW8jtqODLqnf1sourf17Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/30 09:40, Zi Yan wrote:
> try_folio_split_to_order(), folio_split, __folio_split(), and
> __split_unmapped_folio() do not have correct kernel-doc comment format.
> Fix them.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> ---

LGTM.

Reviewed-by: Lance Yang <lance.yang@linux.dev>

>   include/linux/huge_mm.h | 10 ++++++----
>   mm/huge_memory.c        | 27 +++++++++++++++------------
>   2 files changed, 21 insertions(+), 16 deletions(-)
> 
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index 34f8d8453bf3..cbb2243f8e56 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -386,9 +386,9 @@ static inline int split_huge_page_to_order(struct page *page, unsigned int new_o
>   	return split_huge_page_to_list_to_order(page, NULL, new_order);
>   }
>   
> -/*
> - * try_folio_split_to_order - try to split a @folio at @page to @new_order using
> - * non uniform split.
> +/**
> + * try_folio_split_to_order() - try to split a @folio at @page to @new_order
> + * using non uniform split.
>    * @folio: folio to be split
>    * @page: split to @new_order at the given page
>    * @new_order: the target split order
> @@ -398,7 +398,7 @@ static inline int split_huge_page_to_order(struct page *page, unsigned int new_o
>    * folios are put back to LRU list. Use min_order_for_split() to get the lower
>    * bound of @new_order.
>    *
> - * Return: 0: split is successful, otherwise split failed.
> + * Return: 0 - split is successful, otherwise split failed.
>    */
>   static inline int try_folio_split_to_order(struct folio *folio,
>   		struct page *page, unsigned int new_order)
> @@ -486,6 +486,8 @@ static inline spinlock_t *pud_trans_huge_lock(pud_t *pud,
>   /**
>    * folio_test_pmd_mappable - Can we map this folio with a PMD?
>    * @folio: The folio to test
> + *
> + * Return: true - @folio can be mapped, false - @folio cannot be mapped.
>    */
>   static inline bool folio_test_pmd_mappable(struct folio *folio)
>   {
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 0e24bb7e90d0..381a49c5ac3f 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3567,8 +3567,9 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
>   		ClearPageCompound(&folio->page);
>   }
>   
> -/*
> - * It splits an unmapped @folio to lower order smaller folios in two ways.
> +/**
> + * __split_unmapped_folio() - splits an unmapped @folio to lower order folios in
> + * two ways: uniform split or non-uniform split.
>    * @folio: the to-be-split folio
>    * @new_order: the smallest order of the after split folios (since buddy
>    *             allocator like split generates folios with orders from @folio's
> @@ -3603,8 +3604,8 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
>    * folio containing @page. The caller needs to unlock and/or free after-split
>    * folios if necessary.
>    *
> - * For !uniform_split, when -ENOMEM is returned, the original folio might be
> - * split. The caller needs to check the input folio.
> + * Return: 0 - successful, <0 - failed (if -ENOMEM is returned, @folio might be
> + * split but not to @new_order, the caller needs to check)
>    */
>   static int __split_unmapped_folio(struct folio *folio, int new_order,
>   		struct page *split_at, struct xa_state *xas,
> @@ -3722,8 +3723,8 @@ bool uniform_split_supported(struct folio *folio, unsigned int new_order,
>   	return true;
>   }
>   
> -/*
> - * __folio_split: split a folio at @split_at to a @new_order folio
> +/**
> + * __folio_split() - split a folio at @split_at to a @new_order folio
>    * @folio: folio to split
>    * @new_order: the order of the new folio
>    * @split_at: a page within the new folio
> @@ -3741,7 +3742,7 @@ bool uniform_split_supported(struct folio *folio, unsigned int new_order,
>    * 1. for uniform split, @lock_at points to one of @folio's subpages;
>    * 2. for buddy allocator like (non-uniform) split, @lock_at points to @folio.
>    *
> - * return: 0: successful, <0 failed (if -ENOMEM is returned, @folio might be
> + * Return: 0 - successful, <0 - failed (if -ENOMEM is returned, @folio might be
>    * split but not to @new_order, the caller needs to check)
>    */
>   static int __folio_split(struct folio *folio, unsigned int new_order,
> @@ -4130,14 +4131,13 @@ int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list
>   				unmapped);
>   }
>   
> -/*
> - * folio_split: split a folio at @split_at to a @new_order folio
> +/**
> + * folio_split() - split a folio at @split_at to a @new_order folio
>    * @folio: folio to split
>    * @new_order: the order of the new folio
>    * @split_at: a page within the new folio
> - *
> - * return: 0: successful, <0 failed (if -ENOMEM is returned, @folio might be
> - * split but not to @new_order, the caller needs to check)
> + * @list: after-split folios are added to @list if not null, otherwise to LRU
> + *        list
>    *
>    * It has the same prerequisites and returns as
>    * split_huge_page_to_list_to_order().
> @@ -4151,6 +4151,9 @@ int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list
>    * [order-4, {order-3}, order-3, order-5, order-6, order-7, order-8].
>    *
>    * After split, folio is left locked for caller.
> + *
> + * Return: 0 - successful, <0 - failed (if -ENOMEM is returned, @folio might be
> + * split but not to @new_order, the caller needs to check)
>    */
>   int folio_split(struct folio *folio, unsigned int new_order,
>   		struct page *split_at, struct list_head *list)


