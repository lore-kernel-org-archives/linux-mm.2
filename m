Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0210AFD460E
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 03:42:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 202016B0089; Wed, 25 Feb 2026 22:42:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AF946B008A; Wed, 25 Feb 2026 22:42:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0914A6B009F; Wed, 25 Feb 2026 22:42:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EAF986B0089
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 22:42:20 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A08121A0808
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 03:42:20 +0000 (UTC)
X-FDA: 84485210040.07.82AD953
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf10.hostedemail.com (Postfix) with ESMTP id C36ACC0009
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 03:42:17 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=JdEHd4cJ;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf10.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772077339; a=rsa-sha256;
	cv=none;
	b=49GAvvVq4agCv8jrifkElxTk13n6Lsi/6+LN9fWPowMKrq2wIDVGL42LPI5m06cO8dqH12
	C7qG8ROfEu5BQq16+nC8UJKt21sjp+EQnmvzfBaktd7Yt5Dee0hh77WInQjdv7fcTTT4Lq
	ljgwRjwbnkRBQTtyDKhRloTMjbxj5p4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=JdEHd4cJ;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf10.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772077339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s/4WtA3QVEwzHgjUpBzvEPaT6QgOS9tebXTKZPMA8IU=;
	b=eqTa1qf1qDTGgKvZNstPQO8xn27n8/aunHqjTNykhYOPdT5dQQQZ9xhydxeRtsRxiUxaou
	npgEcEq2fUWrjAUFg0jS7S71d+MOVvhwwBSU4uJ6Vry0N8fEVMqD3exZkJ3Pz1SqQb3CK5
	uqG893a3lMjC651ssg2eyiDCi2NgYCU=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1772077334; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=s/4WtA3QVEwzHgjUpBzvEPaT6QgOS9tebXTKZPMA8IU=;
	b=JdEHd4cJCST84ttivofN2a4NAbQM/03HCtk53GTdnfGRwX8A2wJYrEVm/dpYvXSfHiDepIw190ZW/tA9TCFwSculrsx1LDyh6lWiLF/3csswD+Q38LPb4sfP8nz0PRgUOcaL79XXyGdjI933LtVcEiqNbqq2ZnFrgYN9m+jx6gc=
Received: from 30.74.144.118(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WzpnIJH_1772077332 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 26 Feb 2026 11:42:13 +0800
Message-ID: <32c538ce-6af8-48a8-86fc-d26ee253af54@linux.alibaba.com>
Date: Thu, 26 Feb 2026 11:42:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] mm: add a batched helper to clear the young flag for
 large folios
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org
Cc: catalin.marinas@arm.com, will@kernel.org, lorenzo.stoakes@oracle.com,
 ryan.roberts@arm.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, riel@surriel.com,
 harry.yoo@oracle.com, jannh@google.com, willy@infradead.org,
 baohua@kernel.org, dev.jain@arm.com, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, hannes@cmpxchg.org,
 zhengqi.arch@bytedance.com, shakeel.butt@linux.dev, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <cover.1771897150.git.baolin.wang@linux.alibaba.com>
 <bfbe28e381b02452b455498e7ea82662e83a3865.1771897150.git.baolin.wang@linux.alibaba.com>
 <d172d6bf-c60c-4cf5-9da9-f30de38cdfed@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <d172d6bf-c60c-4cf5-9da9-f30de38cdfed@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C36ACC0009
X-Stat-Signature: 14j359h51wnq7pn7sxi18az9kerhzwyr
X-HE-Tag: 1772077337-226091
X-HE-Meta: U2FsdGVkX1/5tNjuVu1Os3cN5/uxMiDAbhhXLhC4+nzXxaT0TLUbh78Q4evYOkuoMujhx0qGW8K0CCqw6lbGgliUuLi2y3wbc5hpQ1FyqPtaA7Y7mc3wWlu0gRpa58EK235Yn+dNqYHFz3q6f56VKuLLb1uiXRNMP4PdIuZbASMD0AM9AZDnlgkSlQTx5vvci3Bld0JhewVkYQRMmi8FZeZomm2lZu5LtX7V1OJ7cKXuTsuIWJjuubRNTF8inYAFZehFuXk5pp6Owm0dot+cxQIKX2hez67LQ3yLR0ZRfuzmvQ50u50CGVGvkVohbIV4mrTUBY1lh6NbhOqND9sNBFUlkPTBkJoHniGfeuqBGbBQ+PfUEdX2uBPOyWKqW3DZZNU/LAefWkysAS25Lb1JatU8DhwpEoEwh/2QLa7mrUPRuiAIaIP9ZP8qA1H8VBMtDLxvWUxKJgyToyaEHSuMF4Ad5sUck9Qr4nRX0kDgrfAd+vSChwttLelETGh+lIuTVd9FCwgcZkmOcXbgQ4YEQYZZfqfTtadQhoSEOZm0cI95TDxa/+VlVUgcgQGut5SXgflXeB+5ZYxBr/tLE6zRwGmd9uN+q0ne9edY7rXfY41ZuvT4ABvQRKpS4MPez1WRi5vZdkOAwTvdsPM8g5bTWvTjvXSb9aORS5Dmfbq9n+4Dqbdpc6RE6flsnUZ8y+oRCfiqhXyplbUGgX8An3pK5yRd7GT8K4aZkPSfLlao/+Fzu4TUZpwb5nBLRrFYnbZ9UHe1WmgynVtsgZhQUZu6UCIldEZ+wo4gSPZxtTfrdFdeR7T2UiCZZ8OksQzfqOdw2pyt6eCIZExT0CITP972dP1XFxN9JGmwbErcccJ7ert513vgrOkQLNBWZGfB+tBQ1T3oDXzLmTsiI7BrY6BdMgAJmqsxCehN0CLLx5+aLH445sMOMtO2+mwzrwCVS4LzbE721huXPfHKTTHkvcB
 NZHVASeG
 aoMrM9vyDnPE48miFGImmM7kE2fujKKztdNS1Ja22j/ai6W5odEiUFA8TGm1IDrsUVARmEIb0oLfDKnZcfPDwXgzTCTsKhWaCPzKswrWOWdbX5XjAERAbdtzF7vrRIf1YLt3cN+S8dBW+6VWxGRVKINCsCkBYMgXWPCHcwaFgb62lK4YIauXhYvEFnStrdGqU/yWkPcOm7NVEXf9Ab0nscvRRynqvNkIOpVaV1c0KVqQLS61UaLpVuxxiVde8pszfcauP0WukF9tOxsxft0KF+41WPz6jeOukl5BJ0PO/XrdyOXQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2/25/26 10:04 PM, David Hildenbrand (Arm) wrote:
> On 2/24/26 02:56, Baolin Wang wrote:
>> Currently, MGLRU will call ptep_clear_young_notify() to check and clear the
>> young flag for each PTE sequentially, which is inefficient for large folios
>> reclamation.
>>
>> Moreover, on Arm64 architecture, which supports contiguous PTEs, the Arm64-
>> specific ptep_test_and_clear_young() already implements an optimization to
>> clear the young flags for PTEs within a contiguous range. However, this is not
>> sufficient. Similar to the Arm64 specific clear_flush_young_ptes(), we can
>> extend this to perform batched operations for the entire large folio (which
>> might exceed the contiguous range: CONT_PTE_SIZE).
>>
>> Thus, we can introduce a new batched helper: test_and_clear_young_ptes() and
>> its wrapper clear_young_ptes_notify(), to perform batched checking of the young
>> flags for large folios, which can help improve performance during large folio
>> reclamation when MGLRU is enabled. And it will be overridden by the architecture
>> that implements a more efficient batch operation in the following patches.
>>
> 
> Maybe mention that the implementation follows the other existing functions.

Ack.

>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> ---
>>   include/linux/pgtable.h | 36 ++++++++++++++++++++++++++++++++++++
>>   mm/internal.h           | 23 ++++++++++++++++++-----
>>   2 files changed, 54 insertions(+), 5 deletions(-)
>>
>> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
>> index 776993d4567b..0bcd3be524d3 100644
>> --- a/include/linux/pgtable.h
>> +++ b/include/linux/pgtable.h
>> @@ -1103,6 +1103,42 @@ static inline int clear_flush_young_ptes(struct vm_area_struct *vma,
>>   }
>>   #endif
>>   
>> +#ifndef test_and_clear_young_ptes
>> +/**
>> + * test_and_clear_young_ptes - Mark PTEs that map consecutive pages of the same
>> + *			       folio as old
>> + * @vma: The virtual memory area the pages are mapped into.
>> + * @addr: Address the first page is mapped at.
>> + * @ptep: Page table pointer for the first entry.
>> + * @nr: Number of entries to clear access bit.
>> + *
>> + * May be overridden by the architecture; otherwise, implemented as a simple
>> + * loop over ptep_test_and_clear_young().
>> + *
>> + * Note that PTE bits in the PTE range besides the PFN can differ. For example,
>> + * some PTEs might be write-protected.
> 
> Document the return value?
> 
> Returns: whether any PTE was young.

Ack.

> 
> Or sth like that.
> 
>> + *
>> + * Context: The caller holds the page table lock.  The PTEs map consecutive
>> + * pages that belong to the same folio.  The PTEs are all in the same PMD.
>> + */
>> +static inline int test_and_clear_young_ptes(struct vm_area_struct *vma,
>> +					    unsigned long addr, pte_t *ptep,
>> +					    unsigned int nr)
> 
> Two tabs ...

Ack.

> 
>> +{
>> +	int young = 0;
>> +
>> +	for (;;) {
>> +		young |= ptep_test_and_clear_young(vma, addr, ptep);
>> +		if (--nr == 0)
>> +			break;
>> +		ptep++;
>> +		addr += PAGE_SIZE;
>> +	}
>> +
>> +	return young;
> 
> BTW: can this function simply return (and use) a bool instead?
> 
> Likely we should do the same for the other functions, but that can be
> done separately.

Yes, add this to my TODO list to convert all related functions.

>>   /*
>>    * On some architectures hardware does not set page access bit when accessing
>>    * memory page, it is responsibility of software setting this bit. It brings
>> diff --git a/mm/internal.h b/mm/internal.h
>> index 1ba175b8d4f1..1b59be99dc3f 100644
>> --- a/mm/internal.h
>> +++ b/mm/internal.h
>> @@ -1813,16 +1813,23 @@ static inline int pmdp_clear_flush_young_notify(struct vm_area_struct *vma,
>>   	return young;
>>   }
>>   
>> -static inline int ptep_clear_young_notify(struct vm_area_struct *vma,
>> -					  unsigned long addr, pte_t *ptep)
>> +static inline int clear_young_ptes_notify(struct vm_area_struct *vma,
>> +					  unsigned long addr, pte_t *ptep,
>> +					  unsigned int nr)
>>   {
>>   	int young;
>>   
>> -	young = ptep_test_and_clear_young(vma, addr, ptep);
>> -	young |= mmu_notifier_clear_young(vma->vm_mm, addr, addr + PAGE_SIZE);
>> +	young = test_and_clear_young_ptes(vma, addr, ptep, nr);
>> +	young |= mmu_notifier_clear_young(vma->vm_mm, addr, addr + nr * PAGE_SIZE);
>>   	return young;
>>   }
>>   
>> +static inline int ptep_clear_young_notify(struct vm_area_struct *vma,
>> +					  unsigned long addr, pte_t *ptep)
>> +{
>> +	return clear_young_ptes_notify(vma, addr, ptep, 1);
>> +}
>> +
>>   static inline int pmdp_clear_young_notify(struct vm_area_struct *vma,
>>   					  unsigned long addr, pmd_t *pmdp)
>>   {
>> @@ -1837,9 +1844,15 @@ static inline int pmdp_clear_young_notify(struct vm_area_struct *vma,
>>   
>>   #define clear_flush_young_ptes_notify	clear_flush_young_ptes
>>   #define pmdp_clear_flush_young_notify	pmdp_clear_flush_young
>> -#define ptep_clear_young_notify	ptep_test_and_clear_young
>> +#define clear_young_ptes_notify	test_and_clear_young_ptes
>>   #define pmdp_clear_young_notify	pmdp_test_and_clear_young
>>   
>> +static inline int ptep_clear_young_notify(struct vm_area_struct *vma,
>> +					  unsigned long addr, pte_t *ptep)
>> +{
>> +	return test_and_clear_young_ptes(vma, addr, ptep, 1);
>> +}
> 
> Why not outside of the ifdef a single generic
> 
> static inline int ptep_clear_young_notify(struct vm_area_struct *vma,
> 		 unsigned long addr, pte_t *ptep)
> {
> 	return clear_young_ptes_notify(vma, addr, ptep, 1);
> }

Yes, will do. And this function will be removed in the following patch.

