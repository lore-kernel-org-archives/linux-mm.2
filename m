Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4DF4606A33B
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 01:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=GVCEg272
Received: by kanga.kvack.org (Postfix)
	id AAAC86B05B3; Thu,  5 Nov 2026 20:57:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A81A66B05B4; Thu,  5 Nov 2026 20:57:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BF846B05B5; Thu,  5 Nov 2026 20:57:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 74F186B05B3
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 20:57:56 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F165180C67
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 01:57:55 +0000 (UTC)
X-FDA: 85403033310.10.40C0A9D
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf10.hostedemail.com (Postfix) with ESMTP id A3A75C0002
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 01:57:52 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=GVCEg272;
	spf=pass (imf10.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793930274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jeEw2MVw1wSJgaQ9XTkcs58wxA0f5oseqFiCGyey6Mc=;
	b=18eVGiOGiYIIdlOTE7VUcMcxgyte/Kwe23KcMv1xGihM2LNfOfksoLBCBVT4meDFWq/h0W
	HGrhU5bZ6yasCCSiZIXlk2ERfjRlv2fwxoDjOmI31xDSSvNyaRta4e8l0U7EnG70qYN3jC
	/YmRtKH86fNkzXa1128Y6eECH30w7rE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793930274;
	b=hkXsIDKB3tnSwyHY093Np/6DBGupc5QyExzLW5a780aAVRUPfRywzw5UiazTftyWt223zD
	6pZk+nCw8vgSUDrolK3B3mzlaLB+GRtP1uGmUQ9IPfcCGYKVeGdfC+R1UGFnpQnpD1t4Y5
	BscM1I5O1gf2HTwq7TxenFFrly7s8nc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=GVCEg272;
	spf=pass (imf10.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793930270; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=jeEw2MVw1wSJgaQ9XTkcs58wxA0f5oseqFiCGyey6Mc=;
	b=GVCEg272Gkf2QSwpg9UodwHUov0PCQghMKSza50dJeSOQ9ElyZn8rerXY1YYux8OTwx64GukV3/k+ARFWOdd2CC/5P+MGYylo0o6dMly2MzPUbY1mFcONNt5Yg1C/vKLUc819JfPsw2WOqbAIbuAzH1yCoFV7feAB2nWTjIXg40=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R831e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0XEA-V0._1793930267;
Received: from 30.74.144.130(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XEA-V0._1793930267 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 06 Nov 2026 09:57:48 +0800
Message-ID: <f06d2004-f3c5-46b0-b708-780ffd6727ce@linux.alibaba.com>
Date: Fri, 6 Nov 2026 09:57:47 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: synchronize with PTE table reclaim for all folio
 sizes
To: Lance Yang <lance.yang@linux.dev>, david@kernel.org
Cc: baohua@kernel.org, akpm@linux-foundation.org, ljs@kernel.org,
 riel@surriel.com, liam@infradead.org, vbabka@kernel.org, harry@kernel.org,
 jannh@google.com, qi.zheng@linux.dev, pfalcato@suse.de, ayushr@modal.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <8ebb182b-8a01-4d32-8c76-7e4bd9e54ddb@kernel.org>
 <20261105132258.99528-1-lance.yang@linux.dev>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261105132258.99528-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: moxao4633x1ab7jcw1ni4wkaz57ywxpb
X-Rspamd-Queue-Id: A3A75C0002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793930272-831903
X-HE-Meta: U2FsdGVkX19epJ6KFWRAsj0COJZw5HaHItXeyTrj2YD6cCg/JJM0+An3bEkMuSEzmJBC6fgY0HpWV7wR2TLKnyJD7qhyKppEic/+5fgPs1Z2XrywNaMuzw859IE64DuiVhO4CyucBLnPM83QPZMeXobYjkffGF5Qrkc/i0+GQXmWEE76ny5Fh0pIV+ejm4aYGCY/reIXQMZftQCCXnbKG7qUmacX7CjA9u3W4j//g5mbd2ubA+iGJB+Uo8T+DtF9xgxuAQ+W+kztWx42MGrQFQsmdtHagnl3sGvjlPTk/wOb8YmVGSsfZKejW37JLv4mLNABCLSzICwAqmTSlIi44N0zdxLmBu4nXq78KOsgcLKlkvJfN266R2ITO9LXQ8A3C4DGLOTivNhc2gsPvX8PMeC7AUtmkYxIY4vQjuIXaG8DalpuN3IzjNZJEU34QYVAN4tMadQh7EWV3XwVzcXfmOzmVQkArXJ1Aavvy2EOi0eo/pwh8eVMXdwDLvcc/F1uB5IOGA57LyBhT7zX669XZn+qChPKFMHeu2K5fKhE3bNN5gNArvzrhZsBPhCyORjy3McMDTYsZa+3Zd1FsCQEW30iqFbbw8WKlXhfTmqR/L1bsvbdND2cDB/NenKjyJsvjwS0IuBYKPH/z2LpW39/4iSQt0anHCgFB4Z2Q3k6H2/Wwff182MJwvUL0S2oB5c1uWorynFXR6EKcJ7KDZjU7PGb51t6zcEGQT2XmIDY98VxbtEQfvv5XxH1ooutMT7Va5cEAvkARqStS0We46kNRT0AMJf9aWkKNpCM5YLjZp6npHGMUHh+JCQKgdMpw/PnHTdtUwrKzskPiG17E6f/y2vbV88rsL1eUhwR1IdBCjVY3ov+a5VqE/5FqshMDlVTykj/lEoHvSQPndWFFtHl0erk0ceF+fkgCOj9UAc+GJTeIP/Z52QLak5kkO+xco1kQDAwcaH9gr5nMua1fcA
 VQgAeEX+
 GyBt5Aw2C1ftRc8NUI4wxwXC7xllv1+SwIL9nOkldvLZZDeyf3Vsn5rUcdRUabHEy7MYyoVuAK3d7H09yNiTLaW4+LA/jRRaqpRbq6M7AxgG9Ap1Px9UkVi2qxCFopnUyZU1b7Zb/oZpk//ky9cPBaXf35SD/2sGs4v9FCXG40C+QPgETiNaSXp2jZ/zg5I2CZQ7wDwO/Iaz++vDpNt09OTQSoTyR5Djwsu82hOx8sGA/5gebZUmzcA8IiGM3zOwxE2ZpQYkmDCEcpXHgHhpL81FGKMKkvYyeytXud1/YmRhzE+VQpZeM43IP81H8RxxczZ+615OJd4JNH0P6loB6HEmXffQEZ9hsiLtwlXuc6yGKLSSXSDYnyCooSmcHkOGMj/MmmAk1hoosveE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/5/26 9:22 PM, Lance Yang wrote:
> 
> On Thu, Nov 05, 2026 at 11:06:29AM +0100, David Hildenbrand (Arm) wrote:
>> On 11/5/26 10:00, Baolin Wang wrote:
>>> CC Barry, who added the TTU_SYNC in shrink_folio_list().
>>>
>>> On 11/5/26 1:48 PM, Lance Yang wrote:
>>>>
>>>>
>>>> On 2026/11/5 12:54, Lance Yang wrote:
>>>>>
>>>>>
>>>>> Good catch!
>>>>>
>>>>>
>>>>> Right. Whether the folio can be PMD-mapped doesn't tell us whether its
>>>>> PTE table can be reclaimed, so those extra checks can skip synchronization
>>>>> that the caller explicitly asked for ;)
>>>>
>>>> Ouch ... one thing I missed ... what about order-0 reclaim?
>>>>
>>>> shrink_folio_list() only sets TTU_SYNC for large folio, so can't we still
>>>> hit the same race there?
>>>
>>> Thanks Lance. But this matches the purpose of the TTU_SYNC flag, which is used
>>> to avoid racy checks with PVMW_SYNC. If no TTU_SYNC flag is set, it means the
>>> caller can tolerate some racy checks.
>>>
>>> For this case, I think we should set TTU_SYNC unconditionally in
>>> shrink_folio_list(). Barry, what do you think?
>>
>> That makes sense. I hope this doesn't throw a big wrench into our reclaim
>> performance numbers.
>>
>> Can someone benchmark this?
>>
>> But maybe we should really follow-up with the folio-size based optimization in
>> sync_with_folio_pmd_zap(), where we only need a memory barrier (and sufficient
>> documentation why something that cannot be PMD-mapped can get away cheaper).
> 
> Dug into the history a bit :D
> 
> TTU_SYNC goes back to Hugh's THP splitting fix [1]. A racing zap could
> clear the PTE/PMD before updating mapcount, so the walker could skip the
> lock and return before the accounting caught up.
> 
> Barry later enabled it for large-folio reclaim [2], to avoid skipping
> temporarily cleared PTEs and ending up with a partially unmapped folio.
> He mentioned that small folios had the same race, but with just one PTE,
> they couldn't be partially unmapped. That's where the large-folio check
> in shrink_folio_list() came from.
> 
> Then PTE table reclaim [3] added another way to end up with an empty PMD,
> even for a folio that can't be PMD-mapped. The truncation fix [4] moved
> the rmap flush before the PMD clear and extended synchronization in
> zap_pmd_range() to cover those folios too.
> 
> Looking back at the truncation discussion [5], you also pointed out that
> page_vma_mapped_walk() needed checking, and suggested a possible
> folio-size based optimization in the helper.

Thanks.

> [1] https://lore.kernel.org/all/c1e95853-8bcd-d8fd-55fa-e7f2488e78f@google.com/
> [2] https://lore.kernel.org/all/20240306095219.71086-1-21cnbao@gmail.com/
> [3] https://lore.kernel.org/all/92aba2b319a734913f18ba41e7d86a265f0b84e2.1733305182.git.zhengqi.arch@bytedance.com/
> [4] https://lore.kernel.org/all/14ebbd556cc4941f0ebc43da59fa6a2fdca25dc8.1793148609.git.baolin.wang@linux.alibaba.com/
> [5] https://lore.kernel.org/all/08a0907f-8e3a-4071-a2e4-fd1411c446f3@kernel.org/
> 
> So, how about starting with order-0 folios?
> 
> ---8<---
> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
> index 74cca0e3c726..d01fe8282417 100644
> --- a/include/linux/rmap.h
> +++ b/include/linux/rmap.h
> @@ -872,6 +872,8 @@ struct page_vma_mapped_walk {
>   	spinlock_t *ptl;
>   	unsigned int flags;
>   	bool pgoff_is_anon : 1;
> +	/* Set from the folio, not the number of pages being walked. */
> +	bool folio_is_order0 : 1;
>   };
> 
>   #define DEFINE_FOLIO_VMA_WALK(name, _folio, _vma, _address, _flags)	\
> @@ -883,6 +885,7 @@ struct page_vma_mapped_walk {
>   		.address = _address,					\
>   		.flags = _flags,					\
>   		.pgoff_is_anon = folio_test_anon(_folio),		\
> +		.folio_is_order0 = !folio_test_large(_folio),	\
>   	}
> 
>   static inline void page_vma_mapped_walk_done(struct page_vma_mapped_walk *pvmw)
> diff --git a/mm/internal.h b/mm/internal.h
> index 9b8864a8540a..e70869b38292 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -592,21 +592,29 @@ void pmd_install(struct mm_struct *mm, pmd_t *pmd, pgtable_t *pte);
>    * sync_with_folio_pmd_zap - sync with concurrent zapping of folios
>    * @mm: The mm_struct.
>    * @pmdp: Pointer to the pmd that was found to be pmd_none().
> + * @order0: True if the target is known to be an order-0 folio.
>    *
> - * When we find a pmd_none() while unmapping a folio without holding the PTL,
> - * zap_huge_pmd() may have cleared the PMD but not yet updated the folio
> - * mapcount, and zap_empty_pte_table() clears the PMD only after the rmaps
> - * for the table have been removed, but nothing orders the pmd_none() read
> - * against later mapcount reads. Skipping the PMD without synchronization
> - * could make folio unmapping code assume that unmapping failed.
> + * An empty PMD does not guarantee that a later mapcount read sees the
> + * completed rmap updates. For PMD-mapped folios, zap_huge_pmd() clears
> + * the PMD before updating mapcount, so we must wait for the PMD lock.
>    *
> - * Wait for concurrent zapping to complete by grabbing the PTL.
> + * Order-0 folios cannot be PMD-mapped. Their fully ordered
> + * atomic_add_negative() updates mapcount before PTE table reclaim clears
> + * the PMD. The PTE lock preserves this ordering if another CPU reclaims
> + * the table. A read barrier therefore suffices for order-0 folios.
> + * Keep taking the PMD lock for all other folios.
>    */
> -static inline void sync_with_folio_pmd_zap(struct mm_struct *mm, pmd_t *pmdp)
> +static inline void sync_with_folio_pmd_zap(struct mm_struct *mm, pmd_t *pmdp,
> +					   bool order0)
>   {
> -	spinlock_t *ptl = pmd_lock(mm, pmdp);
> +	if (order0) {
> +		/* Order the PMD read before subsequent mapcount reads. */
> +		smp_rmb();
> +	} else {
> +		spinlock_t *ptl = pmd_lock(mm, pmdp);
> 
> -	spin_unlock(ptl);
> +		spin_unlock(ptl);
> +	}
>   }
> 
>   struct zap_details;
> diff --git a/mm/memory.c b/mm/memory.c
> index 44376321180b..8955d1cd31b0 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2112,7 +2112,8 @@ static inline unsigned long zap_pmd_range(struct mmu_gather *tlb,
>   			/* fall through */
>   		} else if (pmd_none(*pmd)) {
>   			if (details && details->single_folio)
> -				sync_with_folio_pmd_zap(tlb->mm, pmd);
> +				sync_with_folio_pmd_zap(tlb->mm, pmd,
> +							!folio_test_large(details->single_folio));
>   			addr = next;
>   			continue;
>   		}
> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
> index e6b6170c2f4f..36881f8fd45e 100644
> --- a/mm/page_vma_mapped.c
> +++ b/mm/page_vma_mapped.c
> @@ -293,11 +293,9 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>   			spin_unlock(pvmw->ptl);
>   			pvmw->ptl = NULL;
>   		} else if (!pmd_present(pmde)) {
> -			if ((pvmw->flags & PVMW_SYNC) &&
> -			    thp_vma_suitable_order(vma, pvmw->address,
> -						   PMD_ORDER) &&
> -			    (pvmw->nr_pages >= HPAGE_PMD_NR))
> -				sync_with_folio_pmd_zap(mm, pvmw->pmd);
> +			if (pvmw->flags & PVMW_SYNC)
> +				sync_with_folio_pmd_zap(mm, pvmw->pmd,
> +							pvmw->folio_is_order0);
> 
>   			goto next_pmd;
>   		}
> @@ -379,6 +377,7 @@ unsigned long page_mapped_in_vma(const struct page *page,
>   		.nr_pages = 1,
>   		.vma = vma,
>   		.flags = PVMW_SYNC,
> +		.folio_is_order0 = !folio_test_large(folio),
>   	};
> 
>   	if (folio_test_anon(folio))
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 7db6be53f3a9..79cfa9bc475b 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1434,26 +1434,17 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
>   		 * processes. Try to unmap it here.
>   		 */
>   		if (folio_mapped(folio)) {
> -			enum ttu_flags flags = TTU_BATCH_FLUSH;
> +			enum ttu_flags flags = TTU_BATCH_FLUSH | TTU_SYNC;
>   			bool was_swapbacked = folio_test_swapbacked(folio);
> 
>   			if (folio_test_pmd_mappable(folio))
>   				flags |= TTU_SPLIT_HUGE_PMD;
> +
>   			/*
> -			 * Without TTU_SYNC, try_to_unmap will only begin to
> -			 * hold PTL from the first present PTE within a large
> -			 * folio. Some initial PTEs might be skipped due to
> -			 * races with parallel PTE writes in which PTEs can be
> -			 * cleared temporarily before being written new present
> -			 * values. This will lead to a large folio is still
> -			 * mapped while some subpages have been partially
> -			 * unmapped after try_to_unmap; TTU_SYNC helps
> -			 * try_to_unmap acquire PTL from the first PTE,
> -			 * eliminating the influence of temporary PTE values.
> +			 * Synchronize with concurrent rmap updates before checking
> +			 * folio_mapped(). Also avoid skipping temporarily cleared
> +			 * PTEs, which could leave a large folio partially mapped.
>   			 */
> -			if (folio_test_large(folio))
> -				flags |= TTU_SYNC;
> -
>   			try_to_unmap(folio, flags);
>   			if (folio_mapped(folio)) {
>   				stat->nr_unmap_fail += nr_pages;
> --
> 
> atomic_add_negative() provides full ordering for mapcount updates. With
> 243cf1f67b36, rmap removal completes before clearing PMD, including when
> another CPU reclaims an empty table under PTE lock. So smp_rmb() is enough
> here, without an extra writer-side barrier.

I'm afraid the memory barrier here is subtle. __folio_remove_rmap() is 
complex, and in the CONFIG_NO_PAGE_MAPCOUNT branch, 
folio_sub_return_large_mapcount() doesn't provide full ordering, so we 
may still need smp_wmb().

Anyway, as David said, let's fix this race first. Memory barrier 
optimization requires careful analysis and clear documentation.

