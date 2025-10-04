Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B04EECAC5B0
	for <linux-mm@archiver.kernel.org>; Sat,  4 Oct 2025 14:27:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FF778E0006; Sat,  4 Oct 2025 10:27:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AFDD8E0002; Sat,  4 Oct 2025 10:27:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C5158E0006; Sat,  4 Oct 2025 10:27:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 799738E0002
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 10:27:00 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C4A3F140147
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 14:26:59 +0000 (UTC)
X-FDA: 83960658558.12.3212739
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9882140004
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 14:26:57 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759588018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g4GhKkMm6uL2Fs/6g0f43IlWTFC0TV00zL9VDhG8wyg=;
	b=VAtDIH1vkOU1gixNEwCJQ0SVOst8Q5eO6fymzG+7HrBgmn9jOcnWW4cb4yXpaedig7l6/P
	q38aYQqVo3khJbtuZFbsWOpjFTv9y7cxy5E1WEr9IexDGoki19/a2U88lVMu1XPEbDWUja
	8jJfFH9P/IHzxA9/Hvcm3u4y5cuXP4M=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759588018; a=rsa-sha256;
	cv=none;
	b=hOBGv8B5MRQLVS+W5GoMdxSoQTRO3IFOOhDOLrHx7A6RTn4l4xfxDqHo44ev3uSaiYAJGF
	yYT3pwjwOsDHLE3w9qcCIDLihC1JjdQCaJpjFGbhJF5urdtGUxiO28nCvSa09Ndr60Cb5i
	31tsY+NJuw2917WE8fPFZm783tsgyGs=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9A8A6153B;
	Sat,  4 Oct 2025 07:26:48 -0700 (PDT)
Received: from [10.163.66.97] (unknown [10.163.66.97])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 24D613F5A1;
	Sat,  4 Oct 2025 07:26:51 -0700 (PDT)
Message-ID: <96dac3c7-c969-4d4a-afca-85341f8a6a6e@arm.com>
Date: Sat, 4 Oct 2025 19:56:48 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/khugepaged: use map_anon_folio_pmd() in
 collapse_huge_page()
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, baohua@kernel.org, lance.yang@linux.dev
Cc: linux-mm@kvack.org
References: <20251004092523.28989-1-richard.weiyang@gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20251004092523.28989-1-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9882140004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: sdo88z3su9aqmmc968fjrgni9qfe8nog
X-HE-Tag: 1759588017-158610
X-HE-Meta: U2FsdGVkX18XAEVjQg8ozfgmtM1pkLCmp3hBMh5RU5q8A/2r5yxWnNrmV4fOiaNYm4HOOVCaiAJ7Hp13ELR0lQvvLGpeuROPo1F3BqehR8jo/uLxMrr87kNcdHgaoRpL62aAiJlrKSHjSgQ/msyWJcH0jDMXsdGpkeEepV0iPSVPtOwvmaa10y1rKdcrM19epLqcEAHNFi9egoLwBXDXO4f/Bt/W8biJyH+aIJwGfttox4yBLJzcHlbk8SoiD8nVDvYAPdXO3flrWlatgotZjvp8yNmTtKkTjos8EtPbzSli8eECIlHbySTY6l5b/zsEX9Zp53Q6CSLmzvmiGlv+SzLCjXS/1i1X/iN0Vamfc5uKot5asygUCNrQQjciKfIRPj/aU2SXsZAGiuqeCC+Ry/v4VaSTohaY+REXGgJhvKR31tAHkxQrLmVZKihiInPwDAgDhCD7srwma4pxBwRem8tPu6FUb/OfWPaWd6SYsIa/ZkzvE91EZ4AwTS8BiTIiNGlBcpeizIqwUW+rDhI/0+aTzPPG8u1+HTpdzkQS2lMbqpkTTSR2bhwTQr96n182B6xhDT5mpalk8m5IYGbG9O8INreYGH89gMSlZYk9HOvm2CmP0a0zSFgbrBxxIx+zL22GllPhJPvj7bjG+J4tutGVerSVHTYvJ7Jlb63BZ8g6zoak+R+nIan1YSLdM0W0XX329mI2BDFl4rQt6DknoLCUJfmVDf52+CmJnJzO9MXHOF8R4yj3iMVRrue91F6fYRicgd1HpulgrwBmWs9L3NGXZPN9ffoNpYjE4NkO/W/OkxRQw0SP7ODsoZvMKvWrW+xDpYoX0Th00CgDWhvkkPRLTxsVhCbPj6TZgEBhNgAGl3hvdLifk5XQU8Kf4p6qQHuAq1dIMdt3fjgj+UxF0WrvGEwH1iGV8fxZNFORL5P9jVt39MK6kk4B3lGcKajPrn7KojlW6Duuki81xbV
 gFhTDGyy
 lxnx/dzBenTAziMcZtmgrpcYjvdF5vtQy8P81j+lX2lZiQc7NH4vyBarVe6qWXJW2O3yJdWdYjuBXyCjewu85wHDeE8A1n4HYZyywrvJk5C9koqFuxQrhn4ONKI89T8VieHoWEqY/2q2CplFsXX/TmwR+CSbbbkfbtvNLb1OEtQJ1EKQwR8yK8GHIPBfHXHqip+sRRdPcl3PfWIldtRYTrfKmz7K6UpbNXEwBGyJOHZiYROBHmdSART/ZZ7mcXzlUrHh91KPYF0Q5n6jIQ4DofGgzFju6dpFwisWq75eij9/u8P3unEU5Zyjgw9sDB+SPcJZp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 04/10/25 2:55 pm, Wei Yang wrote:
> Unify the process to install pmd folio.
>
> No functional change is intended.
>
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>

Base commit on which this patch applies?

> ---
>   include/linux/huge_mm.h |  6 ++++++
>   mm/huge_memory.c        | 18 ++++++++++--------
>   mm/khugepaged.c         |  9 +--------
>   3 files changed, 17 insertions(+), 16 deletions(-)
>
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index e3ed008a076a..becfba48d17e 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -539,6 +539,8 @@ void split_huge_pmd_locked(struct vm_area_struct *vma, unsigned long address,
>   			   pmd_t *pmd, bool freeze);
>   bool unmap_huge_pmd_locked(struct vm_area_struct *vma, unsigned long addr,
>   			   pmd_t *pmdp, struct folio *folio);
> +void map_anon_folio_pmd(struct folio *folio, pmd_t *pmd,
> +		struct vm_area_struct *vma, unsigned long haddr, bool in_pf);
>   
>   #else /* CONFIG_TRANSPARENT_HUGEPAGE */
>   
> @@ -629,6 +631,10 @@ static inline bool unmap_huge_pmd_locked(struct vm_area_struct *vma,
>   	return false;
>   }
>   
> +void map_anon_folio_pmd(struct folio *folio, pmd_t *pmd,
> +		struct vm_area_struct *vma, unsigned long haddr, bool in_pf)
> +{}
> +
>   #define split_huge_pud(__vma, __pmd, __address)	\
>   	do { } while (0)
>   
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index f13de93637bf..bfe38ca60a10 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1217,8 +1217,8 @@ static struct folio *vma_alloc_anon_folio_pmd(struct vm_area_struct *vma,
>   	return folio;
>   }
>   
> -static void map_anon_folio_pmd(struct folio *folio, pmd_t *pmd,
> -		struct vm_area_struct *vma, unsigned long haddr)
> +void map_anon_folio_pmd(struct folio *folio, pmd_t *pmd,
> +		struct vm_area_struct *vma, unsigned long haddr, bool in_pf)
>   {
>   	pmd_t entry;
>   
> @@ -1228,11 +1228,13 @@ static void map_anon_folio_pmd(struct folio *folio, pmd_t *pmd,
>   	folio_add_lru_vma(folio, vma);
>   	set_pmd_at(vma->vm_mm, haddr, pmd, entry);
>   	update_mmu_cache_pmd(vma, haddr, pmd);
> -	add_mm_counter(vma->vm_mm, MM_ANONPAGES, HPAGE_PMD_NR);
> -	count_vm_event(THP_FAULT_ALLOC);
> -	count_mthp_stat(HPAGE_PMD_ORDER, MTHP_STAT_ANON_FAULT_ALLOC);
> -	count_memcg_event_mm(vma->vm_mm, THP_FAULT_ALLOC);
>   	deferred_split_folio(folio, false);
> +	if (in_pf) {
> +		add_mm_counter(vma->vm_mm, MM_ANONPAGES, HPAGE_PMD_NR);
> +		count_vm_event(THP_FAULT_ALLOC);
> +		count_mthp_stat(HPAGE_PMD_ORDER, MTHP_STAT_ANON_FAULT_ALLOC);
> +		count_memcg_event_mm(vma->vm_mm, THP_FAULT_ALLOC);
> +	}
>   }
>   
>   static vm_fault_t __do_huge_pmd_anonymous_page(struct vm_fault *vmf)
> @@ -1271,7 +1273,7 @@ static vm_fault_t __do_huge_pmd_anonymous_page(struct vm_fault *vmf)
>   			return ret;
>   		}
>   		pgtable_trans_huge_deposit(vma->vm_mm, vmf->pmd, pgtable);
> -		map_anon_folio_pmd(folio, vmf->pmd, vma, haddr);
> +		map_anon_folio_pmd(folio, vmf->pmd, vma, haddr, true);
>   		mm_inc_nr_ptes(vma->vm_mm);
>   		spin_unlock(vmf->ptl);
>   	}
> @@ -1877,7 +1879,7 @@ static vm_fault_t do_huge_zero_wp_pmd(struct vm_fault *vmf)
>   	if (ret)
>   		goto release;
>   	(void)pmdp_huge_clear_flush(vma, haddr, vmf->pmd);
> -	map_anon_folio_pmd(folio, vmf->pmd, vma, haddr);
> +	map_anon_folio_pmd(folio, vmf->pmd, vma, haddr, true);
>   	goto unlock;
>   release:
>   	folio_put(folio);
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index f4f57ba69d72..cd187d10dee6 100644
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
> +	map_anon_folio_pmd(folio, pmd, vma, address, false);
>   	spin_unlock(pmd_ptl);
>   
>   	folio = NULL;

