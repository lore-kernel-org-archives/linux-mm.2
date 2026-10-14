Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B240ACC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 06:14:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99F9A6B0095; Wed, 14 Oct 2026 02:14:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94FD16B0096; Wed, 14 Oct 2026 02:14:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 865C26B0098; Wed, 14 Oct 2026 02:14:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5BC4A6B0095
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 02:14:27 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 779BD1A0453
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 06:14:26 +0000 (UTC)
X-FDA: 85320217332.09.14A3507
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8D62E1A0007
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 06:14:24 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=iVZjLtZt;
	spf=pass (imf19.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791958464;
	b=lLiB1t78LtM6isUgXP+nA3DmuIH0KgYrFXpHZegj+6ji1ibfW9U68BqSo61lwIRcNWuFOV
	SjzJROYZzWLSm9lcF7eHni6QF9tdaGixfD/C4nCCfa35iu7alCW1g8aD2opp4xVOUseXah
	M7MC4MKibhQjaVcwdmu541yt7zKog4c=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=iVZjLtZt;
	spf=pass (imf19.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791958464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xL7lz3u7A7nCbF8cVqVov/D4tUJYTYOjlx+J/uhQPIc=;
	b=AywpSXhZX9dOo/tzXmVCOPnxEIEWPInDUIbTjTtqqm1eOxIjFGjWSmD4A0cIbFa/9lVn08
	LZOA2AqqHBNqY9IbHxd3PmGJ888ZJthksFCeLsKvXz1yTWP/hG5ccVdka5Crz8lKqck1q3
	jG6LJ4GmwzmDfIuvwuy1xNMukENf9SI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 59978152B;
	Tue, 13 Oct 2026 23:14:20 -0700 (PDT)
Received: from [10.164.19.62] (unknown [10.164.19.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0671C3F7B4;
	Tue, 13 Oct 2026 23:14:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791958463; bh=a7qhbNgmdcPYQ6buXTv8OGPWO0Grnhy1fDX5AmFWNhU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=iVZjLtZtTnUpq+MWM8i1fufHT2ECWkrV3HWNj3WcG/hN9gP+H6H1v93xpCesC3iXX
	 CQi/6xszKB9Zt761+SEqTqssh9cXgTWtdj2H2ozmWZiK6LvgOQCLvIdI0bH8dhgof8
	 tc467R1T/ulRHWldWSPWBQMRzgRPRXiY+auEPDBE=
Message-ID: <c1849f90-58a4-404a-aa01-97b53bd92650@arm.com>
Date: Wed, 14 Oct 2026 11:44:15 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 03/10] mm/vmalloc: use pte_set_huge()/pte_clear_huge()
 for PTE-level block mappings
To: Uladzislau Rezki <urezki@gmail.com>, Wen Jiang <jiangwenxiaomi@gmail.com>
Cc: akpm@linux-foundation.org, catalin.marinas@arm.com, linux-mm@kvack.org,
 will@kernel.org, Xueyuan.chen21@gmail.com, ajd@linux.ibm.com,
 anshuman.khandual@arm.com, baohua@kernel.org, chleroy@kernel.org,
 david@kernel.org, jiangwen6@xiaomi.com, leo.yan@arm.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, maddy@linux.ibm.com, mpe@ellerman.id.au,
 npiggin@gmail.com, rppt@kernel.org, ryan.roberts@arm.com
References: <20261002090947.869220-1-jiangwen6@xiaomi.com>
 <20261002090947.869220-4-jiangwen6@xiaomi.com> <asudY_EhrT5fZGmZ@milan>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <asudY_EhrT5fZGmZ@milan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8D62E1A0007
X-Stat-Signature: a97qz7ubk37pk7ri5wfw9sf8npo3q4rh
X-HE-Tag: 1791958464-231976
X-HE-Meta: U2FsdGVkX1902vK/Z/N+T4ctqdPsKtkYH+OFK07Wzr4uNBLBiZwyF0W0b9I0GAYRl1mHGffK5oq1sBIk+uee0Q+E7jHLfqOx+JajweVuaqkGA6n49A4D9F1hY47hs/fSCH+01Te2adTbVAG4PVY3jTxFTq2eCszlPnPO9Ubcxefx55jgUxUBeMj5Zz/SkOz2n/Vz072dZtu9S9YagoC+9pHPRNPQt5bnDmdtYxyW1x23AqCIM4ZqVmha3pcJxbuJd39VlBEluk1otJSNs67iw076YGlqLVq6YgKJPGJ00fGmMs6Th/ZjnZaoJVkmSELiPoHJbAkcjUBeyyAkxDokc8+fAB9tWjYxCkx0c0CgRlsv+dSLEfEfyZBEw/u8R82G00E55d9t4L3Zi4zxwo10+JhWBOiduG4mBZ+2XxX3uCPbg9GsZ7/5B8yXba7gLF2tJfj3wmfxrfv5KDnr2cDqQk8sik3rsRsijipEwPpns1iUhPNwaOSFz8aw1/mkRQQggODn+fDo1RDm8VlB5w5qHkduqMg9ZBi1YI22m8xerV6czrOQ6/h9/E/SAvSCA9uSLYE1b+TBYLKP/RlHbO1aCtn0IWcqNK3lpjRRvO31ln3f+85NrVmlN0DiHbaB455RF2JOp7qGtdkbuHgLpQh8e2Yd3PVH7f4uMCFSAt6yYZKlwV+lhri9KdmqmqHCNLPoDb9Zeek019zwzP+L04uFpPlOze2SIVkqvfdaaK/WIPDTKf7RcL4K40nmJRmp1TwreFgfdyg/OMRjSUEsDFo/DheeID3J7ixgbsmH/Q7omOuB4oMLdOiyeBFE+8KgdAoQ0LiIK2GJqYInrmhhO/x2yEGPlnTAPq7R7oltlX72186HWEsQu2wWVb+nOlllHLjk57e1F/DvUHRnJoBh6UpZD8frfH2eJe96Ft7Z/74pM6Y/RT2jZAjekPcjPgWNzWE1D1iqcdC7Fh5n3ZrBs9g
 ibiOYh3x
 Ls8a+nV4glvZkZk3jOtG7GZwP/Qmm89Em+dxZ6LSEGEgwXf7jNom/bxzFAQSzCRFkQeTjBxMqdk6GvPZ4CxAogSutLNb33oL4KjleO++H4imlMmu8VebuieLGvBJuacpWOs8XRpX7Ap0PFTIxqJpuCy/QPEForE0Cyjet90cN4Q2OHQJ5O8QUjksikldBow4P/WrIkb3dOB/Bz8LXY+I2/2lyjMQbY2P4cljfRr2Jujejl6IH6TJSm+H34DMmKtKMh7g/NVwDg6C//zh2FIiXCeEac2am1JkouW/i6i9yall6mS0bZUSdGVLnBKm8OwqQomyK11N/vGgeU+c+bYgRJJ+OoemqSu2wcuDmDnAdkuZSRul1+ucTelX4bym75fqAAX1ndpd9V6hrlru/KkqrqFfrgfQm0Kl6zVLxRySSI5/ZZRXWXHsXaTfIHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/10/26 7:59 pm, Uladzislau Rezki wrote:
> On Fri, Oct 02, 2026 at 05:09:40PM +0800, Wen Jiang wrote:
>> vmap installs PTE-level block mappings by reusing set_huge_pte_at() and
>> huge_ptep_get_and_clear() under #ifdef CONFIG_HUGETLB_PAGE. This makes
>> the feature silently unavailable on CONFIG_HUGETLB_PAGE=n kernels and
>> couples mm/vmalloc.c to HugeTLB internals it does not otherwise need.
>>
>> Now that arm64 and powerpc/8xx provide pte_set_huge() and
>> pte_clear_huge(), add the generic fallbacks next to the existing
>> pmd/pud_set_huge() family and convert vmap_pte_range() and
>> vunmap_pte_range() to the new helpers. The CONFIG_HUGETLB_PAGE guards
>> around the block-mapping paths are dropped, so PTE-level block mappings
>> now also work on CONFIG_HUGETLB_PAGE=n kernels, and mm/vmalloc.c no
>> longer includes <linux/hugetlb.h>.
>>
>> The fallbacks exist only to keep the build working on architectures
>> without PTE-level block mapping support. They are unreachable there:
>> the callers only run when arch_vmap_pte_range_map_size() or
>> arch_vmap_pte_range_unmap_size() return a size other than PAGE_SIZE,
>> which requires an arch implementation. BUILD_BUG() makes that
>> explicit rather than silently doing nothing.
>>
>> Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
>> Reviewed-by: Barry Song <baohua@kernel.org>
>> ---
>>  include/linux/pgtable.h | 29 +++++++++++++++++++++++++++++
>>  mm/vmalloc.c            | 19 ++++++-------------
>>  2 files changed, 35 insertions(+), 13 deletions(-)
>>
>> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
>> index 8c093c119e5a8..a7fd51fec8a17 100644
>> --- a/include/linux/pgtable.h
>> +++ b/include/linux/pgtable.h
>> @@ -2204,6 +2204,35 @@ static inline int pmd_free_pte_page(pmd_t *pmd, unsigned long addr)
>>  }
>>  #endif	/* CONFIG_HAVE_ARCH_HUGE_VMAP */
>>  
>> +/*
>> + * PTE-level block mappings for vmap.
>> + *
>> + * pte_set_huge() only has to be implemented by architectures whose
>> + * arch_vmap_pte_range_map_size() can return a size other than PAGE_SIZE.
>> + */
>> +#ifndef __HAVE_ARCH_PTE_SET_HUGE
>> +static inline void pte_set_huge(pte_t *ptep, unsigned long addr,
>> +				phys_addr_t phys, pgprot_t prot,
>> +				unsigned long size)
>> +{
>> +	BUILD_BUG();
>> +}
>> +#endif
>> +
>> +/*
>> + * Likewise, pte_clear_huge() only has to be implemented by architectures
>> + * whose arch_vmap_pte_range_unmap_size() can return a size other than
>> + * PAGE_SIZE.
>> + */
>> +#ifndef __HAVE_ARCH_PTE_CLEAR_HUGE
>> +static inline pte_t pte_clear_huge(pte_t *ptep, unsigned long addr,
>> +				   unsigned long size)
>> +{
>> +	BUILD_BUG();
>> +	return __pte(0);
>> +}
>> +#endif
>> +
>>  #ifndef __HAVE_ARCH_FLUSH_PMD_TLB_RANGE
>>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>>  /*
>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>> index bea9f76ed7e74..fb757d95bde25 100644
>> --- a/mm/vmalloc.c
>> +++ b/mm/vmalloc.c
>> @@ -38,7 +38,6 @@
>>  #include <linux/rbtree_augmented.h>
>>  #include <linux/overflow.h>
>>  #include <linux/pgtable.h>
>> -#include <linux/hugetlb.h>
>>  #include <linux/sched/mm.h>
>>  #include <asm/tlbflush.h>
>>  #include <asm/shmparam.h>
>> @@ -100,7 +99,7 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>>  	pte_t *pte;
>>  	u64 pfn;
>>  	struct page *page;
>> -	unsigned long size = PAGE_SIZE;
>> +	unsigned long size;
>>  
>>  	if (WARN_ON_ONCE(!PAGE_ALIGNED(end - addr)))
>>  		return -EINVAL;
>> @@ -121,17 +120,12 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>>  			BUG();
>>  		}
>>  
>> -#ifdef CONFIG_HUGETLB_PAGE
>>  		size = arch_vmap_pte_range_map_size(addr, end, pfn, max_page_shift);
>>  		if (size != PAGE_SIZE) {
>> -			pte_t entry = pfn_pte(pfn, prot);
>> -
>> -			entry = arch_make_huge_pte(entry, ilog2(size), 0);
>> -			set_huge_pte_at(&init_mm, addr, pte, entry, size);
>> +			pte_set_huge(pte, addr, PFN_PHYS(pfn), prot, size);
>>
> As far as i understand, X86_64 arches do not use this path. This
> specifically is only for ARM64 or powerpc. pte_set_huge() makes me
> thinking about huge-page mappings(PMD/PUD/hugetlb). This helper is

I disagree. All the helpers in hugetlb.c are all "huge" helpers but
the arch overrides.

It has been a long time since huge mappings have been supported at the PTE
level, setting it by setting multiple ptes is just an implementation detail.

Similarly, there are CONT-PMD mappings on arm64, we still call them huge mappings,
it is a matter of implementation that the huge mapping is expressed by setting
multiple PMDs.

 > about mutli page mapping on the PTE level.
> 
> Better naming? pte_set_large()?
> 
> Any thoughts?
> 
> Other then that:
> 
> Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> 
> --
> Uladzislau Rezki


