Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BECC4606A322
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 14:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H6LTKG6Z
Received: by kanga.kvack.org (Postfix)
	id DCDB96B00EF; Mon,  9 Nov 2026 09:25:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA5A66B05BC; Mon,  9 Nov 2026 09:25:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBBA06B05BD; Mon,  9 Nov 2026 09:25:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A44FF6B00EF
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:25:49 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2F5EF12067B
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 14:25:49 +0000 (UTC)
X-FDA: 85415804418.07.38DD83D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4FA134000A
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 14:25:47 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H6LTKG6Z;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794234347;
	b=i91niYBqkJj3yo/TVqm9Ns0XF3ISRkT5aRCI7VAdj/YpCroiKPM6KfGp1gSI2WUpU1xWWP
	mFgOPh/6X1rKa4ptw/KX6ZyOFIpqKVrKOUNR6Jc/KU9wcEkhy/U55px0kJ53hh/z10x/Vc
	T48XzqQN6PQo6DrVnsHYvuBhRanO9L8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H6LTKG6Z;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794234347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pyAb7uutdcjK3DrEF9ZJ1ufyFQKGxeOU/iSNrYyd/3U=;
	b=LV9UZO4r3WXjEonL8mKRugTXsVOKJUZFmcKp6mo+izTreXopxTEs029O8CHF06H8fCnG4X
	ZhxO6bep3GnVQnOxD+CRXpxxR/94aTR8qost4QKnGe9QaFHhwhd3K/eNul/2UkAg+vXHF8
	RTd2b/XrzLoozzsbaVXZNA9OIejlqZw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 77FD540BF9;
	Mon,  9 Nov 2026 14:25:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 069781F0089F;
	Mon,  9 Nov 2026 14:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794234346;
	bh=pyAb7uutdcjK3DrEF9ZJ1ufyFQKGxeOU/iSNrYyd/3U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=H6LTKG6ZydDAo1DzAKoJVuPxQqp1iKvDEHkMDVo7XCBdavDijZS0f+ueP/EiRea4E
	 Kw0m9lNhSSueaupP17xzBmtY7gAkZwyErXyTzAriXK9zKzawDojgdl2cNX1tKIdkeL
	 JFG4iFBdswMzi8UaiZXIGO87Z8eIWs6H9NH08nxKRZHbHXulE00GyOd06DQO6vXL83
	 U5aif9Ubr8/0uHGIxvyBbXwyxcpI+oKqzGwfmu3vQ50C39dkkI89NJqklDqff5siEC
	 SaAYSXPVdlHhQkyT9H4feaDhmTIift58eP5er4xPbqxjZbXWUf2p29M9DthoebZ//K
	 6R7DdazKEnDTA==
Message-ID: <2e3287d7-19d5-4441-8750-bd351df5574a@kernel.org>
Date: Mon, 9 Nov 2026 15:25:40 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm: free unused page table allocated by
 do_set_pmd()
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 liam@infradead.org, nico.pache@linux.dev, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, usama.arif@linux.dev, kas@kernel.org,
 qi.zheng@linux.dev, hughd@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261106-khugepaged_set_pmd-v2-1-d2457b5e377a@kernel.org>
 <20261108091455.88759-1-lance.yang@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261108091455.88759-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4FA134000A
X-Stat-Signature: 93xu9cdt3xhrxn6bw739n4ke5uo3ba4y
X-Rspam-User: 
X-HE-Tag: 1794234347-731854
X-HE-Meta: U2FsdGVkX19vtOUqC0ZaovRpQSoPv5Bfln86N0QHNwrDnfeoKtXtNDhv5n138shAgYZR96tnhWjO7wbirO21HUqWxL6VfF+F8P7/TeldgtMSFQ8VnkbIByiSrX/FxJS4gkFXeZakFM3p43xKdyWaxsdVeKiGwl976pBhO4HRiC7nJIYSB+sCekxhPkerHnIVV7TuaeQ+sRU34v47AlWShW72AbKFIZ0rY1erpexRyXvourwQCbhVW+fgrxRp48mTANMl4tCGXBWrqa723osBxc23fBT2H+PxTb4SAxsHQ9KW6aHRG+hsICjF7ZYuC24skGiEt44ij7IQtiELljlxwgf09fD3EKPy5GBDMGZRIsgHoUmReOOcoIXlHRdjkhDxKNXdJQ/GMua7k/FEiH31wn1Q79YXnnXyNbkhhMs2jlByHu+pOTsYycxDMVGoTopATbx35KXSuztaScq8NiuQdkoQneicUDHo0M61QboxYK/uVczl7KtWYi7DnQPuwqECEGe2Wkb25fJIF3TsAKxXp/HN+Bm3qnlJ36PINxDsgEDoOCu12NjIvpCUUrV3BZG7dBOZgkfqOhkVu0ZkDXQUsvTHH9y5fJl+eU5oEJYA/YRI9cF5FP3NrTbu6uXPzp4eN7apznFU9WeVb6Zi5J2oJ+LU9P3+UBpUSQAK9Ynr6E9kL2XU/YIAfesqnfRb4/usJE+DSekFTX6GdxI4vcTQdRQncB/ARtf7g7NPlCEIhyy4DuSV8jXDyntRRDUxpXyZZTBCvWpPTmdLKIi7uVliShB86yLyxmK14+0+AFIJMaPRnkRdS5QBWejRSPf16SFzq76gTkCYpuUboKbGHs1Rjnqjq8pLbhLg+d0JKo82sSPF44QJBKxnKxB9y57IE750qzEQmSjjll4FK3jF06/7IDCR0EBoTFh7u6GuzE5Wq+oOXC0b7EkjKZel7VG9hhlPSFjiMZKB97zG9X/WQpO
 yd5XgR/r
 4mM70D6n4/MNG/UNwA1GXf9J837jxkn3PSyZhzj0ATB+S/s9k2U/hKHlQzwSBGYtnJJVuQFMN8Kd3makP/s1X8/C2MWUf+2Z+9TLRyg4ljMWmTlVC5p0XUyoTtLUNS0nH0s6tjNtSEBDNYtUhlGZSgUXEHVGgzA5WxE1njdolpMza+NASFTYou2o3T+8ksAo7ZoOhhBU6uYcHT+ZH/BH3/27WrdHtvHSuGmHImk4YjoldYxKtyoVHFLmC/2aKDdQ3demYt97EVup3Jlf4phBNFgI/oQcxYSJWeqRUR6YCd4to+kxMtzP4Y3VLhuUmfxPGfAKQLg6OZzJ18T4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/8/26 10:14, Lance Yang wrote:
> 
> On Fri, Nov 06, 2026 at 01:36:12PM +0100, David Hildenbrand (Arm) wrote:
>> do_set_pmd() can allocate vmf->prealloc_pte on architectures that need a
>> deposited page table, such as PowerPC with the hash MMU. If the PMD is
>> no longer empty when it takes the PMD lock, it returns VM_FAULT_FALLBACK
>> without consuming that table.
>>
>> Since collapse_pte_mapped_thp() uses mmap_read_lock(), a concurrent
>> userfaultfd operation can install a PTE table before taking the folio
>> lock. If that races with set_huge_pmd(), the unused preallocated table
>> is lost when its local vm_fault goes out of scope.
>>
>> Track whether do_set_pmd() allocated the table and free it after dropping
>> the PMD lock if it was not consumed. Preserve any preallocated table
>> supplied by the caller for PTE fallback. Successful PMD installation
>> consumes the table and clears the pointer.
>>
>> Returning without a preallocated table matches the existing behavior on
>> architectures that do not need a deposited table. All callers
>> already handle that case.
>>
>> Fixes: 1043173eb5eb ("mm/khugepaged: collapse_pte_mapped_thp() with mmap_read_lock()")
>> Cc: stable@vger.kernel.org
>> Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>> ---
>> mm/memory.c | 6 ++++++
>> 1 file changed, 6 insertions(+)
>>
>> diff --git a/mm/memory.c b/mm/memory.c
>> index becf53a2a0944..421064aef3cf0 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -5687,6 +5687,7 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *pa
>> 	struct vm_area_struct *vma = vmf->vma;
>> 	bool write = vmf->flags & FAULT_FLAG_WRITE;
>> 	unsigned long haddr = vmf->address & HPAGE_PMD_MASK;
>> +	bool pgtable_allocated = false;
>> 	pmd_t entry;
>> 	vm_fault_t ret = VM_FAULT_FALLBACK;
>>
>> @@ -5725,6 +5726,7 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *pa
>> 		vmf->prealloc_pte = pte_alloc_one(vma->vm_mm);
>> 		if (!vmf->prealloc_pte)
>> 			return VM_FAULT_OOM;
>> +		pgtable_allocated = true;
>> 	}
>>
>> 	vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
>> @@ -5755,6 +5757,10 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *pa
>> 	count_vm_event(THP_FILE_MAPPED);
>> out:
>> 	spin_unlock(vmf->ptl);
>> +	if (pgtable_allocated && vmf->prealloc_pte) {
> 
> Took me a sec ... to see why we can't just check vmf->prealloc_pte here
> ...
> 
> Emm ... as it turns out, the caller might have supplied it for fallback :D
> 

Yeah, it's all ... complicated :)

-- 
Cheers,

David

