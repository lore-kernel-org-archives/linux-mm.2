Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44776CA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 04:53:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D51FD8E00C3; Tue, 12 Aug 2025 00:53:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D02E88E00BE; Tue, 12 Aug 2025 00:53:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF1938E00C3; Tue, 12 Aug 2025 00:53:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AAA5C8E00BE
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 00:53:32 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2D1341DA1FB
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 04:53:32 +0000 (UTC)
X-FDA: 83766887064.24.F519D44
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9A1B040006
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 04:53:28 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="p9Nqks/m";
	spf=pass (imf27.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754974410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vxkRGPtW/Hy53i4ls2hik5N/SCj/n27xlLut7svn+U8=;
	b=etxZNXt9wNTVDsuris27y0hVXzjQm3RIRfAQbuBhAmyObZv9M4/C7pLU4KPDFhnW0Ov9Cm
	CToBuRqK5Hp0C3UVx066cVE933HDh89SIg5B0rX4DCz+iUACHUO01G4sGhKsWvTOe9Sslb
	wGdQRf9hMfEM3fHzjQgJ7xKrD79lRyE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="p9Nqks/m";
	spf=pass (imf27.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754974410; a=rsa-sha256;
	cv=none;
	b=uDTMpO/T/BSkl+XyPRWaySqRd8whntF1Kd/WmXvyNV5XVmYj+wpJRCZpYMl92NxRFCEE0b
	hzNdKNFeQl5yxOxCIYeRuW6YAMvFh6wgAqR3arTi+9jkKCDyCVKUhrHK4qrqq7MXovTfqc
	YC2n8B0iBSo2z25mVAmtHI3QHITPmNQ=
Message-ID: <4865af61-7343-4c60-b4e2-f142f92b7c79@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1754974406;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vxkRGPtW/Hy53i4ls2hik5N/SCj/n27xlLut7svn+U8=;
	b=p9Nqks/mlOZN/tGrqRDmjtIpBiBe1xj7j/3hPcPcHoAgdhOSWGsOvQGG4WWQYwUf16ocpN
	/eSOnoYSrPeVJDmil+MF/Q4G88O3SeFZwq9agCDOjLtfcZ875hNUGHK2AXTesoYOVApLl4
	Vj8yiy6OgDEwRzTUKixNKG2ngK13V1Y=
Date: Tue, 12 Aug 2025 12:52:59 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 01/11] mm/huge_memory: move more common code into
 insert_pmd()
Content-Language: en-US
To: David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org, xen-devel@lists.xenproject.org,
 linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, Andrew Morton <akpm@linux-foundation.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Juergen Gross <jgross@suse.com>, Stefano Stabellini
 <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
 Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox
 <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Hugh Dickins <hughd@google.com>, Oscar Salvador <osalvador@suse.de>,
 Alistair Popple <apopple@nvidia.com>, Wei Yang <richard.weiyang@gmail.com>,
 linux-kernel@vger.kernel.org
References: <20250811112631.759341-1-david@redhat.com>
 <20250811112631.759341-2-david@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20250811112631.759341-2-david@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 9A1B040006
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: tcop3h7yefpkiowsd1kxudo4z6kees7m
X-HE-Tag: 1754974408-697385
X-HE-Meta: U2FsdGVkX1+ZcQp02ZqXeIjvpQzfJu/ONNFgyISS44iHzID/vELI5CdT/tVK4OymgbLKPu3DbWW9+CWmBNWWv6IrZ35YmcDjyOBwLTb8HTfiTKOvUdxXfyjLzZmuC2ZD1qt1KCHhckOi+dh7d3Z8svtsDCXw08qYp5hsn6A51a8NhXs6YVLKU/Rpy/sIVFJUDOV4FkJmInfq6VKomEO9Qd+KkjC3qvdhcKTM5mys/GjeV4yP3fQrJ7HGTvsQ8z1q2hsgAY/MMRSXuSqLafRgtRRPiDuDwJ4p5t7jIeB99Ho/rxY56IwRUE+V+w5Ma9z5QCRTdSRCbguwfMJmp3zdiQ0AW3AkNyFjS58NiBoGi126OUROLyuE86vD3o5Bm5xXBT5CEox13hLhyBAGQtZkbBukLasRTpPNUZ0ZQQpulz8XP/rJGdIY9oD2vXoPTkTbRsViyN3uYjQNa/tpFrTxtdlxbdxRynfWCRNcvGxOGek7SWM9IBhrnzwCYi3pv98eVXnDSHwkQI3YQRCeEBOQ+c3ySY+yOyL0teDIP/N/XEZhruEM/Nr4ByIvAEX/InnK+CpJ3g018yP4HqBBMsSUGJg6F4QV60/6wv+I4vfwkwWcHD7dpeBFULOiIVLAzY17x4upn9P20Xi1q/EnHIeCmWbHZVUn10U19NiEIwy6M0vON3xcWjqgSovDZ8/EEFKBVR5VIxpkiIyYB9WXg4KKUpAFhLpOIxzsuDsB+B/oi20pOIQ9SBawjlKdx38ZkO2l0sOqiQv9bSglnYp3elBINEKuXOKxOzpcGlc20I+mvGayzVNuB9wumvZgLp5BUlfd1qD8JgiJuu1mtZuYiAfU9reuUb2WKFDCO0Mu5wrKrs0HvnDRtsY9cFFdEl+KRZSvV3AMrGLRNhb34G/fp4Ae+ipPvtVlht2i7gkwYntAd7xmoHiuqUzqKnhsUlCqWZ5zKjYZOhRIkXrhZUHQnnK
 xHWg4EN4
 HGmyR0BFiMhwxbJwnf1uLruivppZku/xTnHRTA2NV0OljCFDcOEaW857IjCxm43/M38cPzjiWzHOjDgQSNme+3rtKeLxHtr/OcAZU6zdfbL36Hp+oKXTsTB8wDfKtkzlThDnLAmqPH+3KtmHxKRKb2DgAMYQMMOT1M/Pa3Iutk8R/t3hxvVDtZJXULFbHXYyzC820FW4iQZbDzZSORt55QkyUwSJN+6ZFLYrf0do7/cDxlKC7DfKCd405t30tjyRSJer8YJI1iN1xIueQUGexGZNDYFnddm58/HQq9C3GkjqA4jScSeAWjVQED+7qSIl5MC3y7nuur+6pHHmApEQZAhE9JYNYHSwvLOnhKQ3YTQxpEigIgvc3h47p9kh/GemSl/zqeEK+97LC974kmLAxQqoZyo8WIjlcoaWtDaXOAW3Wdb4YbA7sxr7ty0he6IHgmfsuqVwVJJN6etA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/8/11 19:26, David Hildenbrand wrote:
> Let's clean it all further up.
> 
> No functional change intended.
> 
> Reviewed-by: Oscar Salvador <osalvador@suse.de>
> Reviewed-by: Alistair Popple <apopple@nvidia.com>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>

Nice. Feel free to add:

Reviewed-by: Lance Yang <lance.yang@linux.dev>

Thanks,
Lance

> ---
>   mm/huge_memory.c | 72 ++++++++++++++++--------------------------------
>   1 file changed, 24 insertions(+), 48 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 2b4ea5a2ce7d2..5314a89d676f1 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1379,15 +1379,25 @@ struct folio_or_pfn {
>   	bool is_folio;
>   };
>   
> -static int insert_pmd(struct vm_area_struct *vma, unsigned long addr,
> +static vm_fault_t insert_pmd(struct vm_area_struct *vma, unsigned long addr,
>   		pmd_t *pmd, struct folio_or_pfn fop, pgprot_t prot,
> -		bool write, pgtable_t pgtable)
> +		bool write)
>   {
>   	struct mm_struct *mm = vma->vm_mm;
> +	pgtable_t pgtable = NULL;
> +	spinlock_t *ptl;
>   	pmd_t entry;
>   
> -	lockdep_assert_held(pmd_lockptr(mm, pmd));
> +	if (addr < vma->vm_start || addr >= vma->vm_end)
> +		return VM_FAULT_SIGBUS;
>   
> +	if (arch_needs_pgtable_deposit()) {
> +		pgtable = pte_alloc_one(vma->vm_mm);
> +		if (!pgtable)
> +			return VM_FAULT_OOM;
> +	}
> +
> +	ptl = pmd_lock(mm, pmd);
>   	if (!pmd_none(*pmd)) {
>   		const unsigned long pfn = fop.is_folio ? folio_pfn(fop.folio) :
>   					  fop.pfn;
> @@ -1395,15 +1405,14 @@ static int insert_pmd(struct vm_area_struct *vma, unsigned long addr,
>   		if (write) {
>   			if (pmd_pfn(*pmd) != pfn) {
>   				WARN_ON_ONCE(!is_huge_zero_pmd(*pmd));
> -				return -EEXIST;
> +				goto out_unlock;
>   			}
>   			entry = pmd_mkyoung(*pmd);
>   			entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
>   			if (pmdp_set_access_flags(vma, addr, pmd, entry, 1))
>   				update_mmu_cache_pmd(vma, addr, pmd);
>   		}
> -
> -		return -EEXIST;
> +		goto out_unlock;
>   	}
>   
>   	if (fop.is_folio) {
> @@ -1424,11 +1433,17 @@ static int insert_pmd(struct vm_area_struct *vma, unsigned long addr,
>   	if (pgtable) {
>   		pgtable_trans_huge_deposit(mm, pmd, pgtable);
>   		mm_inc_nr_ptes(mm);
> +		pgtable = NULL;
>   	}
>   
>   	set_pmd_at(mm, addr, pmd, entry);
>   	update_mmu_cache_pmd(vma, addr, pmd);
> -	return 0;
> +
> +out_unlock:
> +	spin_unlock(ptl);
> +	if (pgtable)
> +		pte_free(mm, pgtable);
> +	return VM_FAULT_NOPAGE;
>   }
>   
>   /**
> @@ -1450,9 +1465,6 @@ vm_fault_t vmf_insert_pfn_pmd(struct vm_fault *vmf, unsigned long pfn,
>   	struct folio_or_pfn fop = {
>   		.pfn = pfn,
>   	};
> -	pgtable_t pgtable = NULL;
> -	spinlock_t *ptl;
> -	int error;
>   
>   	/*
>   	 * If we had pmd_special, we could avoid all these restrictions,
> @@ -1464,25 +1476,9 @@ vm_fault_t vmf_insert_pfn_pmd(struct vm_fault *vmf, unsigned long pfn,
>   						(VM_PFNMAP|VM_MIXEDMAP));
>   	BUG_ON((vma->vm_flags & VM_PFNMAP) && is_cow_mapping(vma->vm_flags));
>   
> -	if (addr < vma->vm_start || addr >= vma->vm_end)
> -		return VM_FAULT_SIGBUS;
> -
> -	if (arch_needs_pgtable_deposit()) {
> -		pgtable = pte_alloc_one(vma->vm_mm);
> -		if (!pgtable)
> -			return VM_FAULT_OOM;
> -	}
> -
>   	pfnmap_setup_cachemode_pfn(pfn, &pgprot);
>   
> -	ptl = pmd_lock(vma->vm_mm, vmf->pmd);
> -	error = insert_pmd(vma, addr, vmf->pmd, fop, pgprot, write,
> -			   pgtable);
> -	spin_unlock(ptl);
> -	if (error && pgtable)
> -		pte_free(vma->vm_mm, pgtable);
> -
> -	return VM_FAULT_NOPAGE;
> +	return insert_pmd(vma, addr, vmf->pmd, fop, pgprot, write);
>   }
>   EXPORT_SYMBOL_GPL(vmf_insert_pfn_pmd);
>   
> @@ -1491,35 +1487,15 @@ vm_fault_t vmf_insert_folio_pmd(struct vm_fault *vmf, struct folio *folio,
>   {
>   	struct vm_area_struct *vma = vmf->vma;
>   	unsigned long addr = vmf->address & PMD_MASK;
> -	struct mm_struct *mm = vma->vm_mm;
>   	struct folio_or_pfn fop = {
>   		.folio = folio,
>   		.is_folio = true,
>   	};
> -	spinlock_t *ptl;
> -	pgtable_t pgtable = NULL;
> -	int error;
> -
> -	if (addr < vma->vm_start || addr >= vma->vm_end)
> -		return VM_FAULT_SIGBUS;
>   
>   	if (WARN_ON_ONCE(folio_order(folio) != PMD_ORDER))
>   		return VM_FAULT_SIGBUS;
>   
> -	if (arch_needs_pgtable_deposit()) {
> -		pgtable = pte_alloc_one(vma->vm_mm);
> -		if (!pgtable)
> -			return VM_FAULT_OOM;
> -	}
> -
> -	ptl = pmd_lock(mm, vmf->pmd);
> -	error = insert_pmd(vma, addr, vmf->pmd, fop, vma->vm_page_prot,
> -			   write, pgtable);
> -	spin_unlock(ptl);
> -	if (error && pgtable)
> -		pte_free(mm, pgtable);
> -
> -	return VM_FAULT_NOPAGE;
> +	return insert_pmd(vma, addr, vmf->pmd, fop, vma->vm_page_prot, write);
>   }
>   EXPORT_SYMBOL_GPL(vmf_insert_folio_pmd);
>   


