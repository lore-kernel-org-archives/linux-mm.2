Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6018EC624D3
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 03:46:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 756646B0095; Thu,  3 Sep 2026 23:46:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 706546B0096; Thu,  3 Sep 2026 23:46:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61D606B0098; Thu,  3 Sep 2026 23:46:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4082A6B0095
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 23:46:28 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CB9031406F5
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 03:46:27 +0000 (UTC)
X-FDA: 85174692414.07.FCFE84D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 98AAFC000B
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 03:46:25 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Do6AqAKu;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788493586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/63bea0xeveJA2KYJiJoZogPYN8tUNJq7l9pT00vG8g=;
	b=fxwSY9ia/rzJwuwmOp6ZCSBQ4bKBpp9vbCQaaG4ujWBU2V9uAGewFRuE1N/6QXFrtrtZql
	sIGociPwM8k35u2lcTvwk5ZTr1OketVniFvMbhexUnETd9DFYu3ThNPdpx/6xDg8QNd2+u
	9tln6RW/abeqxGwP8xHB6Oorqyv4zxw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788493586;
	b=2wdjp23bWT0cO8e0ntXCv0P9g2Mgy/RyNFHoeLNqnqkN9zImI7NZF090P2BeizJe3/XO4E
	JJPgZQkWgz4HnkloWWKc5g8B0Q1qnuJNgWz/RWQqysgf6kGfeOOHSjCEk7qupJjH5MapzF
	oHO7oD2WJ2L3yiZAPdWqENWJN4sTq+4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Do6AqAKu;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C6433153B;
	Thu,  3 Sep 2026 20:46:20 -0700 (PDT)
Received: from [10.164.148.37] (MacBook-Pro-3.blr.arm.com [10.164.148.37])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2EB3F3F882;
	Thu,  3 Sep 2026 20:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788493584; bh=EM+aG+yWfzm6igvMiw3Sluv2MfuOq6zvpVWV7arL9Ao=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Do6AqAKuTFSA+TQLVdkujGV3kkrfvURPaimfzoeAacZ1nJ7LnUQyOXq2sjQ3xdpf6
	 RWe3342+gzzBgjAyJEYnzNb056VUm9egV8DnlBVsLaGmrEQjAPFT0RTEADDOyLKHCq
	 fXfLi3sNVVLQQBMyTrBwToH5/OR1FT5XxhySt1C4=
Message-ID: <f9c41141-308d-4688-99ce-643c34729c47@arm.com>
Date: Fri, 4 Sep 2026 09:16:05 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/8] mm: move anon-exclusive batch helper to mm.h
To: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 hughd@google.com, chrisl@kernel.org, kasong@tencent.com
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, lance.yang@linux.dev,
 baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 baoquan.he@linux.dev, baohua@kernel.org, youngjun.park@lge.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, pfalcato@suse.de, ryan.roberts@arm.com,
 anshuman.khandual@arm.com
References: <20260901054358.4049095-1-dev.jain@arm.com>
 <20260901054358.4049095-4-dev.jain@arm.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260901054358.4049095-4-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 98AAFC000B
X-Stat-Signature: r8csj7c9nsxm7ofsrod8pixd1516i6tr
X-Rspam-User: 
X-HE-Tag: 1788493585-703539
X-HE-Meta: U2FsdGVkX1/mYAUwzASBW/vq5fdDD4yMgWiNYTjHJi9byFoyKzD0LNeWld4h1FqhA1TbYVObd1OAEwhWvk/AWpI5Rt+pBjTIxw7xCw9EbZkNtb1rQDhfxj9mVz5r7r6pG/n24kowjPhKuRnhryYEuFJSBl/21LWl62RmO/CFRQE77pLykh7gH8oXA/Y7/0mJNqnNhNWdqgB/OKxbe9VhqoutUrlJJeWoD21upRGT9CLkZAYCmkfofoHZG8lN8vj/01ssks56ea4A5D6E7D9rMn64mlvyPcDdskpTmfOndfLJhwL76nHw5MIKE/gRdBW5d2GzAwt2pBJHEp8gmUNOFI8D995GYlIGV2zRkvkC2LGS0LkhMMa3fFyHjAZre207QIH3z+6XO4Kd1OsrZaOBg1UwLhZb3Q1JeKPEl2udRrlFNiqfIvQ0RoR6JlrX6o9QhBcIRxegcAwlcz8XWB+NN3HnC1xPUopjkqxv5r1Gz0/eNdM18dDLiZNpVI/AMfqgIfdzt4JVg22q2T+pOTfTdIWVE+QtNjXi4fv51kNvZRDtp6Pmu452g6+Cm/hTthj/gPcgSCwZPSniBojkdUcZmEz3VUl8qlnQLdbqxMAJ9i7ZgqgqkG7oqGN0T8fA6HYrcKObI36RgciWhuej6tzOxvwxv5mS9GKC0dsCZfMWsgZebS4daH55SSDIsKwNT0iaSFxQrZVS4d0uqrwhaaLu3nSB8ezUGMdWmKxAwZ8IeM2ADdqQF1eahxYQkerQaSlYT3CENNzEuK8GYq+xlMQKMi3hoeZXqC0nKZc580QJlpSnf73pCYjQsGZbn5XmJqvLdkhJrSGU9FKkAjLBYe6FZho0WB6eVVKeo6aXSrF8qt4SxMafHdpJTHOU30sLKZ24qlAw4bViYQPyrg5gJTy5x4X8L8/vtBrd511Ea9jRS5heqi9XusMwmT7AYSwwdHarpeT/3diVQQLof3otHxk
 uR0QGlxZ
 LqwSLFGNT6rZeHiWBJwr7XEx+TKMvhhwIlb5ZjioKiAP1xIkbzP6nazMTTlaMGqWIdOG0mil60HQjb6k/+2GZAS9PfbO1UhMPcTmTbJN9+5LJZNwmRUzFuw/0dzuhuBMgO/oncD3aNeii0LLDokOwZBCcuK7g2NGUaoY8Pyi2ni+1YWqldlHJiEMAXRg9T2fLBv9REpIQtiuEofzZ6LxZ2Yhw2A1DeVGLLGVlaFev4rL9W1+ySso0hhGqZL1ojrmWwmKo2frAdADsVcgg+KdAJ6zIlK2Y/u5+fgwaq75K/iv1gY0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 01/09/26 11:13 am, Dev Jain wrote:
> In preparation for optimizing large folio unmapping, we need to reuse
> the page_anon_exclusive_batch helper in rmap.c and rmap.h and obey the
> existing use in mprotect.c .
> 
> Therefore, move it from mprotect.c to mm.h. Gate with CONFIG_MMU since
> both rmap and mprotect users are built only for CONFIG_MMU.
> 
> While at it, change start_idx and max_len to unsigned long type for
> future proofing against THP support at >= PUD level. Also shorten
> expected_anon_exclusive -> anon_exclusive.
> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
>  include/linux/mm.h | 19 +++++++++++++++++++
>  mm/mprotect.c      | 17 -----------------
>  2 files changed, 19 insertions(+), 17 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index dd09c438fa23e..63da8813bc5df 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -244,6 +244,25 @@ static inline unsigned long folio_page_idx(const struct folio *folio,
>  	return page - &folio->page;
>  }
>  
> +#ifdef CONFIG_MMU
> +/*
> + * Get max length of consecutive PTEs pointing to PageAnonExclusive() pages or
> + * !PageAnonExclusive() pages, starting from start_idx. Caller must enforce
> + * that the PTEs point to consecutive pages of the same anon large folio.
> + */
> +static __always_inline int page_anon_exclusive_batch(unsigned long start_idx,

Sashiko says to make the return value unsigned long here, I'll do that. Now we
have an unfortunate mix of int's in existing callers, but keeping nr_pages
unsigned long everywhere eventually seems like the right thing to do.


> +		unsigned long max_len, struct page *first_page, bool anon_exclusive)
> +{
> +	int idx;
> +
> +	for (idx = start_idx + 1; idx < start_idx + max_len; ++idx) {
> +		if (anon_exclusive != PageAnonExclusive(first_page + idx))
> +			break;
> +	}
> +	return idx - start_idx;
> +}
> +#endif
> +
>  static inline struct folio *lru_to_folio(struct list_head *head)
>  {
>  	return list_entry((head)->prev, struct folio, lru);
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index 2888ee638d872..75c2b1a00eb36 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -138,23 +138,6 @@ static __always_inline void prot_commit_flush_ptes(struct vm_area_struct *vma,
>  		tlb_flush_pte_range(tlb, addr, nr_ptes * PAGE_SIZE);
>  }
>  
> -/*
> - * Get max length of consecutive ptes pointing to PageAnonExclusive() pages or
> - * !PageAnonExclusive() pages, starting from start_idx. Caller must enforce
> - * that the ptes point to consecutive pages of the same anon large folio.
> - */
> -static __always_inline int page_anon_exclusive_batch(int start_idx, int max_len,
> -		struct page *first_page, bool expected_anon_exclusive)
> -{
> -	int idx;
> -
> -	for (idx = start_idx + 1; idx < start_idx + max_len; ++idx) {
> -		if (expected_anon_exclusive != PageAnonExclusive(first_page + idx))
> -			break;
> -	}
> -	return idx - start_idx;
> -}
> -
>  /*
>   * This function is a result of trying our very best to retain the
>   * "avoid the write-fault handler" optimization. In can_change_pte_writable(),


