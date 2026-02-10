Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5359EA8115
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 13:29:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14E936B008A; Tue, 10 Feb 2026 08:29:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EBA46B008C; Tue, 10 Feb 2026 08:29:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 026016B0092; Tue, 10 Feb 2026 08:29:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E74076B008A
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 08:29:25 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9A59913AE2C
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 13:29:25 +0000 (UTC)
X-FDA: 84428628690.27.97398E8
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id BC197A0009
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 13:29:23 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770730164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HCJ907E6pfC1y4wBaOaT6SkZD6XlI1iFlZOQCFr2fG0=;
	b=0X7YOH3xzwqrqiQugD4+aoz2jL2rXNNJcOURpwMM6okql3YJhZTwKlHDozBKfdGSisk9Dg
	1zvzI1ZTIe8vZ1tovBTjefdFJ42QSOWa0laJmSP860Oi2NylkcsTQSAiLvr3hNydyx46ZH
	FMw4TMJ89q6mvwdAElnjNGeXBTJNLNU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770730164; a=rsa-sha256;
	cv=none;
	b=dDbcZBRFNQrK35XtGpp7OuhhtVQhQCrueNNHdFUi4C3tlWAGBv+r1p7WtvbJDKLkeNeFcW
	ZyDsnF4pGLONBcFXSxMUQI/aI5ili2dSVU3bBv0etJr2eqtjFWxoabS5pbjTnHz/VSu9cS
	xGKPtKg6iqJLY3nvD2Sy6WITx71LSW0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9370B339;
	Tue, 10 Feb 2026 05:29:16 -0800 (PST)
Received: from [10.164.19.61] (unknown [10.164.19.61])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7AAC93F63F;
	Tue, 10 Feb 2026 05:29:18 -0800 (PST)
Message-ID: <a2cdcf67-ca27-4d8a-96e0-d5a677e7dbc6@arm.com>
Date: Tue, 10 Feb 2026 18:59:15 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: map maximum pages possible in finish_fault
To: Usama Arif <usamaarif642@gmail.com>, akpm@linux-foundation.org,
 david@kernel.org
Cc: lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com, kirill@shutemov.name, willy@infradead.org
References: <20260206135648.38164-1-dev.jain@arm.com>
 <687c7173-31c9-457a-9900-68e7f38688ed@gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <687c7173-31c9-457a-9900-68e7f38688ed@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: qcrcw5rsjhrpnwzwm5s67qtzdjwym8rw
X-Rspamd-Queue-Id: BC197A0009
X-Rspam-User: 
X-HE-Tag: 1770730163-770880
X-HE-Meta: U2FsdGVkX19T/zzONJwmoBmmRurBXYovYBKOXfB2eUzkwndlzj6FDWljJ2n88eQs9Av8AXsSDdFKEgYb5ltIetHlpubbAXJ+Re9ehatj9lVS9ZOZitTZPlKDN1LekkWfaNtmM9mqz0A05VyZPglK7TG4p3On12H1qxxt/0IEzLw7lbUQzgqvBkq/jzfR1qLSblK8vQrsmIM5uAwM2LK8IQaOJwrIvBYbEmQ/DcPXaOGBPiwGpFpMHqXeVxX3VSMjLPx3ojA2pqKgsOr/MNM+8ApHCcdqsjMCirW1FxzrTLFTta2DIUwJ8yhoHDNVinPIvCLdLAQK2xuOcn5EQVb/ZY2rpkqYvZy1gvafpdUzIQgtorTbKvxIz1vx5WFNV4e0IyfI5nzoacXwMZmjopeNA42cLEJgS74z6lyJeP7+VcTnrLC7+UCqYkf4Vt5bgF4fjWOc3ftpmzUc4TuwqV54DcYEI+3QTWTEs8/oQVJ0L/qtbEw3BQFUqfFZGgSJjJ8xspfI8I2HOyuEEgRNQTrvCBMEyWm3rW1nWbKPvMKnRIc0iorlc2S1BvqnPG+8BjceMQZoTrIUhnc1g5xIm05k7nDPFCq6zqmQi3uhy6030O6qE5OIE3hF4U83RScGBC4XNo2/hKuWRaCCXzPUgIZbbG7PPcDLG/ZGL9AuSZjW7qVSyPdTkiO+y4Ki5vYnHNEls1JsN7Fjkt62cLq63HIcUjHLho/YCxv11txfWCn8gbpGDT7LnX8jThm7TnrH5KsZmlX7k3f+xSsPxeovivtxCQWdupezQ6HImXd9/u9P1zukf9AAMx0qEGz4pq/rQg/nunKKLbIrXgiB/HvM3kA7hw+O3Bsa/m3KKQFZcN0p2vQap3/puEOStPqLhHYfdQz3bjfufu7/a/cTvyzy/M4TiPTNBN/BVaDujNFUHM9KlFadvetFxsJhkh3I51seIf321zHIqmjBvEvTKmzCybm
 KfgejNp2
 QY+YfiAqlZ/G4zG6KNg4Q6Pgs56HINkIzKxGFV+jXTu5cUiCMmRBE067LnlR9hbE46U9QVeHy6u/e9gxJJQ2Ru1MM4Nm22kwMuGFZ0ZIgaxKvpa1xgLPTCyRM6QhoZAjl2wFCpBnplCwwfIRIbmfXTvB+XbHBs9viuyitJqtU8sGVGutomaGnr4A7yLyRbgx0eqmZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 07/02/26 11:38 pm, Usama Arif wrote:
>> @@ -5619,49 +5619,53 @@ vm_fault_t finish_fault(struct vm_fault *vmf)
>>  	nr_pages = folio_nr_pages(folio);
>>  
>>  	/* Using per-page fault to maintain the uffd semantics */
>> -	if (unlikely(userfaultfd_armed(vma)) || unlikely(needs_fallback)) {
>> +	if (unlikely(userfaultfd_armed(vma)) || unlikely(single_page_fallback)) {
>>  		nr_pages = 1;
>>  	} else if (nr_pages > 1) {
>> -		pgoff_t idx = folio_page_idx(folio, page);
>> -		/* The page offset of vmf->address within the VMA. */
>> -		pgoff_t vma_off = vmf->pgoff - vmf->vma->vm_pgoff;
>> -		/* The index of the entry in the pagetable for fault page. */
>> -		pgoff_t pte_off = pte_index(vmf->address);
>> +
>> +		/* Ensure mapping stays within VMA and PMD boundaries */
>> +		unsigned long pmd_boundary_start = ALIGN_DOWN(vmf->address, PMD_SIZE);
>> +		unsigned long pmd_boundary_end = pmd_boundary_start + PMD_SIZE;
>> +		unsigned long va_of_folio_start = vmf->address - ((vmf->pgoff - folio->index) * PAGE_SIZE);
>> +		unsigned long va_of_folio_end = va_of_folio_start + nr_pages * PAGE_SIZE;
>> +		unsigned long end_addr;
>
> Hello!
>
> Can va_of_folio_start underflow here? For e.g. if you MAP_FIXED at a very low address and
> vmf->pgoff is big.
>
>
> max3() would then pick this huge value as start_addr/
>
> I think the old code guarded against this explicitly below:
>     if (unlikely(vma_off < idx || ...)) {
>         nr_pages = 1;
>     }

Indeed! Thanks for the spot, I'll fix this.

>
>> +
>> +		start_addr = max3(vma->vm_start, pmd_boundary_start, va_of_folio_start);
>> +		end_addr = min3(vma->vm_end, pmd_boundary_end, va_of_folio_end);
>>  
>>  		/*
>> -		 * Fallback to per-page fault in case the folio size in page
>> -		 * cache beyond the VMA limits and PMD pagetable limits.
>> +		 * Do not allow to map with PTEs across i_size to preserve
>> +		 * SIGBUS semantics.
>> +		 *
>> +		 * Make an exception for shmem/tmpfs that for long time
>> +		 * intentionally mapped with PMDs across i_size.
>>  		 */
>> -		if (unlikely(vma_off < idx ||
>> -			    vma_off + (nr_pages - idx) > vma_pages(vma) ||
>> -			    pte_off < idx ||
>> -			    pte_off + (nr_pages - idx)  > PTRS_PER_PTE)) {
>> -			nr_pages = 1;
>> -		} else {
>> -			/* Now we can set mappings for the whole large folio. */
>> -			addr = vmf->address - idx * PAGE_SIZE;
>> -			page = &folio->page;
>> -		}
>> +		if (mapping && !shmem_mapping(mapping))
>> +			end_addr = min(end_addr, va_of_folio_start + (file_end - folio->index) * PAGE_SIZE);
>> +
>> +		nr_pages = (end_addr - start_addr) >> PAGE_SHIFT;
>> +		page = folio_page(folio, (start_addr - va_of_folio_start) >> PAGE_SHIFT);
>>  	}
>>  
>>  	vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
>> -				       addr, &vmf->ptl);
>> +				       start_addr, &vmf->ptl);
>>  	if (!vmf->pte)
>>  		return VM_FAULT_NOPAGE;
>>  
>>  	/* Re-check under ptl */
>>  	if (nr_pages == 1 && unlikely(vmf_pte_changed(vmf))) {
>> -		update_mmu_tlb(vma, addr, vmf->pte);
>> +		update_mmu_tlb(vma, start_addr, vmf->pte);
>>  		ret = VM_FAULT_NOPAGE;
>>  		goto unlock;
>>  	} else if (nr_pages > 1 && !pte_range_none(vmf->pte, nr_pages)) {
>> -		needs_fallback = true;
>> +		single_page_fallback = true;
>> +		try_pmd_mapping = false;
>>  		pte_unmap_unlock(vmf->pte, vmf->ptl);
>>  		goto fallback;
>>  	}
>>  
>>  	folio_ref_add(folio, nr_pages - 1);
>> -	set_pte_range(vmf, folio, page, nr_pages, addr);
>> +	set_pte_range(vmf, folio, page, nr_pages, start_addr);
>>  	type = is_cow ? MM_ANONPAGES : mm_counter_file(folio);
>>  	add_mm_counter(vma->vm_mm, type, nr_pages);
>>  	ret = 0;

