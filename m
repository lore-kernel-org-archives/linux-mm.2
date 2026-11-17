Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99428606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 22:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fY1OmYfI
Received: by kanga.kvack.org (Postfix)
	id A35ED6B05B2; Tue, 17 Nov 2026 17:21:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E7316B05B3; Tue, 17 Nov 2026 17:21:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AE516B05B5; Tue, 17 Nov 2026 17:21:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 551E76B05B2
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 17:21:23 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4DAA61605DF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 22:21:21 +0000 (UTC)
X-FDA: 85446033162.19.A040494
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 85273120006
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 22:21:19 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fY1OmYfI;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794954079;
	b=SRJ6Ly3JALRybCxw4Ff6BGfQerAucHNEfk4SC5AXfdG9GgU42eNkp3aB7S3VGBjWo57pr4
	5fkDTAeUvFsufbfLpfjbx37dyAZH9nbHRb19Oopt3lOpEuIb/Df6mJ0mCNBEvulo2412E5
	bfHBr8hH0CefH5aJzEqIUDXRt30OcJQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fY1OmYfI;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794954079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YnPmoI6JPFrx0ipKzZPLJ8qO6jh67M7b6J0hvlzZ69Y=;
	b=KRdlZ0NO/7NYawFHOgmeuP8JydJPh0GY78e2MHIBlxj0mjvo7eXs++omnslX9fWMXWWrlr
	jVK7lkfto1Qf19QbEkiMvHs7wBlQG2F9BhViXrNlFQ2M0sLzGwtwzQzemws/DfdWgWmTiJ
	A4vkyAI/xjn94WyXKUUrIfXRLOCNiOs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 47EC961C69;
	Tue, 17 Nov 2026 22:21:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE6FD1F000C4;
	Tue, 17 Nov 2026 22:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794954078;
	bh=YnPmoI6JPFrx0ipKzZPLJ8qO6jh67M7b6J0hvlzZ69Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fY1OmYfI8nFvOwKlbmwhJnYNa4PV3Cm02aSc0zrIQuYxxuHiAigmFIySbTVjj5Plq
	 IiMijaCQGIbFVQugF8PirF8LFwwZuOQoZEheouKRSiPYjTc2QwxcmaiSAJAfSKYVEc
	 uAmSiDIHqlReu0m0cOr9N2HDXcv1qaw+efBvoWfcddysNTX7hhRXZRfHh5HQWAAapO
	 E4DcLt1fm1I2EVvNLIhtmnvEUjotWw05fzNBETV7+gl8trEjQpLV9ofFDEfy2EI9v3
	 hF0LgEeisby1ii6eS7cFi/jnU6x82Ua+ltWektpoa+V/yMkL12+v9Mimwrv0QLaTko
	 xWbuWwkS2Toqg==
Message-ID: <0d75991d-9381-440c-8d7c-07bca53cc8ff@kernel.org>
Date: Tue, 17 Nov 2026 23:21:08 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/4] mm: add anonymous mTHP folios to the deferred
 split list
To: Joanne Koong <joannelkoong@gmail.com>, akpm@linux-foundation.org,
 ljs@kernel.org
Cc: baohua@kernel.org, usama.arif@linux.dev, hannes@cmpxchg.org,
 kas@kernel.org, alex@ghiti.fr, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, liam@infradead.org, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, lance.yang@linux.dev,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 willy@infradead.org, linux-mm@kvack.org
References: <20261103212004.1356327-1-joannelkoong@gmail.com>
 <20261103212004.1356327-5-joannelkoong@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261103212004.1356327-5-joannelkoong@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: p7px57nbcicspgryh5pbh4tp33ffz5ak
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 85273120006
X-HE-Tag: 1794954079-886701
X-HE-Meta: U2FsdGVkX1+t+Smu0/55mEbtGQlCVol4lHLesG8rU7tuc+vI1b4RzgqcJXjuEQRxQDisJEEBHOX2TAJK5EnCafLqSxd0RxMP6HLzXYhwLkJOVdtaaxuRCZJ3KrSqL0qfZdjnGrLdVViLhiwyVhfliQiBNKFkMTT3g6ERnIAMrygzVSYWt9Rk8q8S3wsw5tk1w3Ty9ERpgFxfuDUEpl3uWVBGIARX4zPf9Kp826p/2gGDeKjjleesChvvRDwrqP84CF3WRFgRn5b+onHNtz9FZOd/4rVLnUSM9YOCDJk/RVBCAXG6gXKXWstpibi3HFLx+w9Bblv80rzMUA83NCH5vkT/S58N1SKzL3sItLcIN0VB9TbAGDoSLV1q/GjXIWK8WLwGkCiY2UM6ozeXZfIVm04AJVsnOpR3OITOaSKWay9khZCKtKivXE52UoRvDdLOuDN4DR3I6PrnSP+bBdLBoW5jzILigsk0YJp8TdrbMJ7L6b4w6sr16gIZkXnZN6Dgry/0G+550hBo+zLif4vgjuA60J7G0tP+kDKNKupKqFKB4Zp1dzgyVXYhY5DgPw9kb4qJPkhjjOPC8IzWm/BUFkA72OQbim/K6RyAoY0LGA/vN7Uz46LRcSNE8w0ItElcEulyy9QVIz5pcWJkFEmf4oPi/WJQeJnwWh9zNQoTnTLZHRQVYg9KbQCJZgY1z2tiolCHmRINjdRvBK2S7YiIRH0QwZjcHwwPNvakCs7bqfCQDescSY4cYCs65n/rSwFwXTsgjiO5z3Utyn0+dgp8eZMOHVSj4ccRN755dtqmq5tiz8FNpLtTrPShObAeT6ElQGrmeROrShvDF2CquUZjuWkEjjUXOgH+evCE3fUa6fc/eb+7n1VrqMt3/Tx3SHUY1clQaW5PdOFE/KOs7DwA26ebEzRTnfM0BDThcOXzYBwO0Nhk2YUq6HY6FO3TJ8um+CHCXLCH+yD0QN5txE/
 QDnybMgh
 YiGsYtGWM8k2tFZZdBN7WeBWk/ukzKJtrXIRzvagLK8BAGyOxMNKjx21yhk6I/cso3BqMOPY4IrPTzEcgpk6p7XXTv3gZG7z/YHLlXIFKJ4UF7uvLInT54H8ISENXlIvS8rQXVhfHB7F0N/u1eXtBNtM5w0rBtqc2xDCz9O6ZQ7jZRQMBAAeUfU3l2oFaOAm8kXOQO8/c1oTNXZZVm/OUQHYkoibr0nT+1qpfuBCB5Co4CiAkriQKXH1UkeXeQcOfSTKvrfJ8JrsL0az1rfVuVd6qaFUtX8LzBdwx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/3/26 22:20, Joanne Koong wrote:
> Unlike for PMD-sized folios, an anonymous mTHP folio doesn't get added
> to the deferred split list at fault or collapse time. As a result, a
> fully mapped mTHP folio that is mostly zero-filled doesn't get split by
> the deferred split shrinker when the system is under memory pressure.
> 
> At Meta we would like to deploy 2M THP=always on arm64 with 64k base
> pages, as 2M gives the contpte benefits while the PMD size (512M) is too
> big to use. Without underused splitting this causes memory regressions,
> as the unused parts of those folios can never be broken down and
> reclaimed.
> 
> Add anonymous mTHP folios to the deferred split list from
> map_anon_folio_pte_nopf(), mirroring what map_anon_folio_pmd_nopf()
> already does for PMD-sized folios. This covers both the fault path and
> the khugepaged mTHP collapse path. If there is memory pressure, a
> zero-filled mTHP can then be split with its zero pages remapped to the
> shared zero page and reclaimed.
> 
> Only queue mTHP folios of at least 2M for underused splitting. With
> thp_underused() scaling khugepaged/max_ptes_none to the folio size, any
> folio of order 2 or above could in principle be underused, but for small
> folios it is unlikely to be worth it. An order-2 folio on 4k base pages
> can free at most four pages and on systems that only enable small mTHP
> sizes (eg Android's order-2-only configuration) zero-filled subpages
> tend to be few and short-lived.
> 
> The minimum is hard-coded rather than a knob, since admins have no good
> way of choosing it, and is a size rather than an order since what a
> split recovers depends on the folio's size in bytes, and the same order
> means very different sizes across different base page sizes. It can be
> lowered later if data shows smaller sizes are worth it. PMD-sized folios
> are exempt from the minimum in order to maintain backwards compatibility
> since on some architectures (s390, with a 1M PMD) the PMD size can be
> below 2M.
> 
> To minimize overhead on the common order-0 fault path, the
> deferred_split_folio() call is guarded by an inline folio_test_large()
> check.
> 
> Suggested-by: Usama Arif <usama.arif@linux.dev>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
>  mm/huge_memory.c | 14 ++++++++++++++
>  mm/memory.c      |  2 ++
>  2 files changed, 16 insertions(+)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 8f90fb609e57..cda3c886ec53 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4575,6 +4575,13 @@ static bool thp_underused_never(unsigned long max_ptes_none)
>  	return max_ptes_none == HPAGE_PMD_NR - 1;
>  }
>  
> +/*
> + * Smallest mTHP folio that is queued for underused splitting. Kept
> + * conservative, as small folios are unlikely to free enough memory to be
> + * worth queueing and scanning.
> + */
> +#define THP_UNDERUSED_MIN_SIZE	SZ_2M

Working on orders would be nice.

I think you can use something like

	order_base_2(SZ_2M >> PAGE_SHIFT)

for that.

And then you can just do something like

	max(order_base_2(SZ_2M >> PAGE_SHIFT), HPAGE_PMD_ORDER)

And place the comment next to this definition.

> +
>  /* partially_mapped=false won't clear PG_partially_mapped folio flag */
>  void deferred_split_folio(struct folio *folio, bool partially_mapped)
>  {
> @@ -4600,6 +4607,13 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
>  		 */
>  		if (thp_underused_never(khugepaged_max_ptes_none))
>  			return;
> +		/*
> +		 * Keep queueing PMD-sized folios as before, even where the PMD
> +		 * size is below the minimum (eg 1M on s390).
> +		 */
> +		if (folio_size(folio) < THP_UNDERUSED_MIN_SIZE &&
> +		    !is_pmd_order(folio_order(folio)))
> +			return;
>  	}

Shame that we already did a function call just to figure that out. Shouldn't we
just replace the folio_test_large() thingy below by helper that embeds this
directly, with a focus on underused shrinking?

>  
>  	/*
> diff --git a/mm/memory.c b/mm/memory.c
> index 0c9ed04528d8..44376321180b 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -5477,6 +5477,8 @@ void map_anon_folio_pte_nopf(struct folio *folio, pte_t *pte,
>  	folio_add_lru_vma(folio, vma);
>  	set_ptes(vma->vm_mm, addr, pte, entry, nr_pages);
>  	update_mmu_cache_range(NULL, vma, addr, pte, nr_pages);
> +	if (folio_test_large(folio))
> +		deferred_split_folio(folio, false);

Do we also ahve to take care of mTHP placed by khugepaged?

-- 
Cheers,

David

