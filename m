Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A9A7CAC5B8
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 01:17:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FB7F8E0012; Mon,  6 Oct 2025 21:17:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AC428E0002; Mon,  6 Oct 2025 21:17:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39B078E0012; Mon,  6 Oct 2025 21:17:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 245B78E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 21:17:10 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AE25E5B3CE
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 01:17:09 +0000 (UTC)
X-FDA: 83969554578.27.8864A1C
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf27.hostedemail.com (Postfix) with ESMTP id 08B1D40002
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 01:17:05 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=U8gRxbXf;
	spf=pass (imf27.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759799828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R/cxVyas6/pRM6wQKxDAz0vX7ozt1yiLmngqL8EtG00=;
	b=q3RHsQwn1M0i0kq0raW0o36B0KysJ6EPfPLcAFnpx5C25HrzqPRTcpE9QEiZWsJITPyOUF
	Es7AoHhH+TO8TxOspC8kQw4IEaC2vd6SqqFOdn60qjONuOCLsMVypNn01mEpH1hx+zoxTY
	Yjf+7oLcx097ce1JFBjF1bsPqSv0CUM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=U8gRxbXf;
	spf=pass (imf27.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759799828; a=rsa-sha256;
	cv=none;
	b=aJ29WCfkvJCTYgQyre5gc3AEyBNl6dQIWNoqgBkJx8hm3siln5fdMy+F1VAT+51HGOXNoE
	fVursrfm5CMTpgwcETkpsdr+mNjEf0shHE9qdyUtH6Pg/JOo0iPxQYaDqKf1zqaLxorDOU
	5P+Fclk6bSyoJIMBgn5lch0nibZfZNw=
Message-ID: <32f2278f-2491-49d1-8c9b-5b359a2dacbb@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759799823;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R/cxVyas6/pRM6wQKxDAz0vX7ozt1yiLmngqL8EtG00=;
	b=U8gRxbXfSvk871FhlW8WrYN8ynEbxuiViMEafoLYnW0JZJPXX3jxB7utm4/mREKhYyvl3j
	ip+YR8zM68cQoQs4y7/M7y8xur+Xb1Jnh9HZ0XHuIEdEdFYxWFMqL4I1gM30FHsACUdzSY
	2pMTtg9sKBZazGUq5sDTpjTxGylgb7A=
Date: Tue, 7 Oct 2025 09:16:51 +0800
MIME-Version: 1.0
Subject: Re: [Patch v2] mm/khugepaged: unify pmd folio installation with
 map_anon_folio_pmd()
Content-Language: en-US
To: Wei Yang <richard.weiyang@gmail.com>
Cc: linux-mm@kvack.org, dev.jain@arm.com, Usama Arif
 <usamaarif642@gmail.com>, baohua@kernel.org,
 Matthew Wilcox <willy@infradead.org>, david@redhat.com, ziy@nvidia.com,
 akpm@linux-foundation.org, ryan.roberts@arm.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com
References: <20251007005022.24413-1-richard.weiyang@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20251007005022.24413-1-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: awu8n79r4pncmii81rgy9u5nnbzai4zf
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 08B1D40002
X-HE-Tag: 1759799825-47303
X-HE-Meta: U2FsdGVkX18CFC2SbncJBVciYgYqnBsis8+k723rnFOMAolfkL4GTD6ZGY4c3uaC/HWn9AKTJpVymfVr8fQ/fV0wgsbrmcEt6+CIF/mBPVDAX60TCtpBeaI8na1R3Zc7mAi6igmElRXkyUgERTt6BOJQUKyw9p0igsQYluqKWrf+irLJP30g9p4OvIJhS0locNWLC10nPlQjqQVTy73W/drWara93H0UpsYywks2OLnz9ymRN2qmCUGdOK45OLqH1fUt41VvD24aBoS4b3zLeB6X7rEqfdJg0ASBzT6+S59hUdbI7wipEz38LKcPphTwx/RceIUTdeRAYTBKi19XZn94GVjU6gQxDhPX6qSOtZM2LpC/eFdA6ES0Atb6xmyJmKam4xxTy3QfhtuKRHcMwYnY4JbbjrovTpXKy1WHLtXSaEJvFrkedFbmrD0W+/qXqYd7VdkssRKQ2etwEJGVQ+A7mbN7gnxvXl8XsWXfzfFMOFnRbMh6rLw8V51wQQgsJ6SmaPTYP1r4j25RhIU5WHpVorCDs/osbc7ge3uH4wjweZbRHxn+97D0rlG6XYHsIlfmdEJyaS62iV934KU4MxizdFdqlq6YVfy0QtAslTNzoKHUdIhfM903YOkD/sFJOmg34AncW6iFDkAeQFItSBa1rFxRnPaUhcn/8wsfEXm5ILjFnrkqDWEtYAU0Fd7CpUYj49MmpLl/vlnfzfPEJQihuloukWoyo9S8BgrwAqcAyWEN6H+r0/4UB8hv+YfgV4OvKg5DvE9nWGMkqZZJFO+q2KWL/n0+raarrwtRPcSoQNL4KlmyXZ0XOkz2HqfsILVKmr4JJLiIPLcUGKCmUfLNPdQdhVRdbzaMBu+30ATK6ZG1e2cXYYoeEg1TC0DEvbCEKBOgGhDR5SWft+p1RRgWwsNECeKwt2M+LUaOVHexBG4fOzMMvVjFB/skCsGvy1sOc4D/greGBLphyGJ
 HOZmV/Dt
 ZrCxmrQ+z1hdB76zAWO8dHcigpM75aIrjjbamYh2fj/eBrHB6N0ebbRpORG0I5jhHTAmkDGi/swBkIOJyCnXYKlZS0XXOady+8aQnQIOW6Oh37zdSUbQu13nsHe8rDrZcNSoldeoNX/sp3tGr8Jj7gWLap9/EG6/UkZUVAeA1ey4wRztUSjpCoGSY32rfSVlKl2bu7pFsSaNOCaaZbpeEgVUY3UoFhMlA+Qefzc44VqlXyXVJj0MdwJ+XOD90EyQVLqycrbaixYKlSIVRoP5jm6ryPWkCosKKsyv6WJsdVG/xZR31amAycVZKo0k2171C7hStsDNrLybo9VryZ4BslICqcK7dyPrke9vmI5JoC1W1rDQWW6w5pl+0cReGQgFlwpWLybcLg6Rs4DU3mEJfHW9vWUMR6z+W0WtO49JyMHbxL5w6NEzco/ifBvpTeQG9/Ki8t0+Uv4zU8Qs6fgscOk04NCHQ2S9joRNEtOKfRWqyAtadtbprb6tnoCcRloHpVHIpJ5+ASHttIyapVZp4Ir2+bTzWvwjLHGdnDbP6qecx8SM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/7 08:50, Wei Yang wrote:
> Currently we install pmd folio with map_anon_folio_pmd() in
> __do_huge_pmd_anonymous_page() and do_huge_zero_wp_pmd(). While in
> collapse_huge_page(), it is done with identical code except statistics
> adjustment.
> 
> Unify the process with map_anon_folio_pmd() to install pmd folio. Split
> it to map_anon_folio_pmd_pf() and map_anon_folio_pmd_nopf() to be used
> in page fault or not respectively.
> 
> No functional change is intended.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Usama Arif <usamaarif642@gmail.com>
> Cc: Matthew Wilcox <willy@infradead.org>

Nice cleanup!

Acked-by: Lance Yang <lance.yang@linux.dev>

But one nit below.

> 
> ---
> v2:
>    * split to map_anon_folio_pmd_[no]pf() suggested by Matthew
> ---
>   include/linux/huge_mm.h |  6 ++++++
>   mm/huge_memory.c        | 14 ++++++++++----
>   mm/khugepaged.c         |  9 +--------
>   3 files changed, 17 insertions(+), 12 deletions(-)
> 
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index e3ed008a076a..277ade3b7640 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -539,6 +539,8 @@ void split_huge_pmd_locked(struct vm_area_struct *vma, unsigned long address,
>   			   pmd_t *pmd, bool freeze);
>   bool unmap_huge_pmd_locked(struct vm_area_struct *vma, unsigned long addr,
>   			   pmd_t *pmdp, struct folio *folio);
> +void map_anon_folio_pmd_nopf(struct folio *folio, pmd_t *pmd,
> +		struct vm_area_struct *vma, unsigned long haddr);
>   
>   #else /* CONFIG_TRANSPARENT_HUGEPAGE */
>   
> @@ -629,6 +631,10 @@ static inline bool unmap_huge_pmd_locked(struct vm_area_struct *vma,
>   	return false;
>   }
>   
> +void map_anon_folio_pmd_nopf(struct folio *folio, pmd_t *pmd,
> +		struct vm_area_struct *vma, unsigned long haddr)
> +{}

Nit: can you put the braces on separate lines?

+void map_anon_folio_pmd_nopf(struct folio *folio, pmd_t *pmd,
+		struct vm_area_struct *vma, unsigned long haddr)
+{
+}

AFAIK, this is the preferred style in kernel for empty function bodies.

> +
>   #define split_huge_pud(__vma, __pmd, __address)	\
>   	do { } while (0)
>   
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index f13de93637bf..88960530b1d5 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1217,7 +1217,7 @@ static struct folio *vma_alloc_anon_folio_pmd(struct vm_area_struct *vma,
>   	return folio;
>   }
>   
> -static void map_anon_folio_pmd(struct folio *folio, pmd_t *pmd,
> +void map_anon_folio_pmd_nopf(struct folio *folio, pmd_t *pmd,
>   		struct vm_area_struct *vma, unsigned long haddr)
>   {
>   	pmd_t entry;
> @@ -1228,11 +1228,17 @@ static void map_anon_folio_pmd(struct folio *folio, pmd_t *pmd,
>   	folio_add_lru_vma(folio, vma);
>   	set_pmd_at(vma->vm_mm, haddr, pmd, entry);
>   	update_mmu_cache_pmd(vma, haddr, pmd);
> +	deferred_split_folio(folio, false);
> +}
> +
> +static void map_anon_folio_pmd_pf(struct folio *folio, pmd_t *pmd,
> +		struct vm_area_struct *vma, unsigned long haddr)
> +{
> +	map_anon_folio_pmd_nopf(folio, pmd, vma, haddr);
>   	add_mm_counter(vma->vm_mm, MM_ANONPAGES, HPAGE_PMD_NR);
>   	count_vm_event(THP_FAULT_ALLOC);
>   	count_mthp_stat(HPAGE_PMD_ORDER, MTHP_STAT_ANON_FAULT_ALLOC);
>   	count_memcg_event_mm(vma->vm_mm, THP_FAULT_ALLOC);
> -	deferred_split_folio(folio, false);
>   }
>   
>   static vm_fault_t __do_huge_pmd_anonymous_page(struct vm_fault *vmf)
> @@ -1271,7 +1277,7 @@ static vm_fault_t __do_huge_pmd_anonymous_page(struct vm_fault *vmf)
>   			return ret;
>   		}
>   		pgtable_trans_huge_deposit(vma->vm_mm, vmf->pmd, pgtable);
> -		map_anon_folio_pmd(folio, vmf->pmd, vma, haddr);
> +		map_anon_folio_pmd_pf(folio, vmf->pmd, vma, haddr);
>   		mm_inc_nr_ptes(vma->vm_mm);
>   		spin_unlock(vmf->ptl);
>   	}
> @@ -1877,7 +1883,7 @@ static vm_fault_t do_huge_zero_wp_pmd(struct vm_fault *vmf)
>   	if (ret)
>   		goto release;
>   	(void)pmdp_huge_clear_flush(vma, haddr, vmf->pmd);
> -	map_anon_folio_pmd(folio, vmf->pmd, vma, haddr);
> +	map_anon_folio_pmd_pf(folio, vmf->pmd, vma, haddr);
>   	goto unlock;
>   release:
>   	folio_put(folio);
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index f4f57ba69d72..ce7181b6ae4e 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1224,17 +1224,10 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
>   	__folio_mark_uptodate(folio);
>   	pgtable = pmd_pgtable(_pmd);
>   
> -	_pmd = folio_mk_pmd(folio, vma->vm_page_prot);
> -	_pmd = maybe_pmd_mkwrite(pmd_mkdirty(_pmd), vma);
> -
>   	spin_lock(pmd_ptl);
>   	BUG_ON(!pmd_none(*pmd));
> -	folio_add_new_anon_rmap(folio, vma, address, RMAP_EXCLUSIVE);
> -	folio_add_lru_vma(folio, vma);
>   	pgtable_trans_huge_deposit(mm, pmd, pgtable);
> -	set_pmd_at(mm, address, pmd, _pmd);
> -	update_mmu_cache_pmd(vma, address, pmd);
> -	deferred_split_folio(folio, false);
> +	map_anon_folio_pmd_nopf(folio, pmd, vma, address);
>   	spin_unlock(pmd_ptl);
>   
>   	folio = NULL;


