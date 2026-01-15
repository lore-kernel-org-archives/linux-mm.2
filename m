Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3BF3D41178
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 12:28:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5033E6B0092; Thu, 15 Jan 2026 07:28:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AD206B0093; Thu, 15 Jan 2026 07:28:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DA536B0095; Thu, 15 Jan 2026 07:28:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2EA596B0092
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 07:28:31 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DE6F01ADF4B
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:28:30 +0000 (UTC)
X-FDA: 84334126380.24.7F85553
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0B32C80006
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:28:28 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JWMIDcJe;
	spf=pass (imf30.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768480109; a=rsa-sha256;
	cv=none;
	b=5SzHdX5oLBXrf6A2iTkqECEEaxQUnCV/128XpJfmadVePRPfoWpwVcNxLerk0UFKP7kcKz
	DHA6krDWErHlnlF2jG1Gum4CSD+xQ9sCos2MJ0pPLFpvcej4DbqTFTM+WpxEuXI1+Hf1sR
	Udpu2Lv/KOCcwNaiLgMcYWwWVZPuNkk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JWMIDcJe;
	spf=pass (imf30.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768480109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LO/MKTvdUHcs8CszjDJdblzD/1oYrlivkdR1yyi35cU=;
	b=ytSbRg5L+ZPBVmuzf9D3dVIRFjjd/S8VMu8Y0xndbYPHJH/QhYpNwzziQEnYpfNO+1bNFe
	4sOMFq1sotQb0vav9Lrn6zg8HkxIiyeNXmP6ehLmxX6Ht1dw6SyRCSeLepKibDtB5tBi/D
	lcVPY7ipFDWaCYm1DEnselqYEkWlJJE=
Message-ID: <8754b56d-b9a8-4b94-b5bc-982384234527@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768480106;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LO/MKTvdUHcs8CszjDJdblzD/1oYrlivkdR1yyi35cU=;
	b=JWMIDcJecMA3p9Vmm72Ebn8zDuxzyx/GKRb/mD/2zdzp3SqjedZCT51yRxeimkv9dmFtB9
	4YurRCRgzy+JZciV4ltY1TfcAg+398L+2iUmGQpQl80peR2wsdTB/QdPCIdFcKj3GLzNtf
	uU0YDlSauJHJRa2zDifeCus80bCQvk8=
Date: Thu, 15 Jan 2026 20:28:13 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v1 1/1] mm/khugepaged: move tlb_remove_table_sync_one out
 from under PTL
Content-Language: en-US
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: ioworker0@gmail.com, lorenzo.stoakes@oracle.com, david@kernel.org,
 akpm@linux-foundation.org, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260115071651.42626-1-lance.yang@linux.dev>
 <0bc3807e-2c1b-43af-9aab-665ce30d49d4@linux.alibaba.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <0bc3807e-2c1b-43af-9aab-665ce30d49d4@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 1iirexbbcy7dis5tpdsu9shyraryrbbx
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0B32C80006
X-Rspam-User: 
X-HE-Tag: 1768480108-496717
X-HE-Meta: U2FsdGVkX1+HBd1Mf9r8eK5LammLPZIRDl8lUOCN3PWah0dgmhc5mkdiW8BjRFktmWTWDXmkWewmKJnRfatJ68GOi7KbzKa8x3GviocAmbPVfuSL2z+OXGrzvJZUyx9YsxzOVU+IvA2+4Wb0AjnmzVZSRrUFwPdd+pMjSHxekGXHy5FckyuoBGofrljDcm6ZQq+dzZGMNXb8fjVyvFFg3KIU3NcQSnMxKTirY3IQHGJmRZHK7B1kZjVFVDqC/ikE9XRBjx/NVnlQaN9eQfKWYBf7crwLbjHULc7cS+39EBd+OUPU/rce+VjkW7aSiPYhd4Jh3+trDXNGWtWEnuhohlamxuX8T2a7zjxhtYWlJs6j2crq6wQ5PGieRxrcrFpGsAU3kiXfblCyCQ9VVY5kNn2VYZ7uFbT0C3hgVp+rNavfkVOTAbkwKL+6fcT4nOa0CQRF88QGqurSYCXC1fq4OnWQxdERVk2qmzaeAXN35KJ3i6s+0cvBDxIN/VvYgZWbcV5ZHYP12rbsiJQqezeov12vqcTM+54Rnf2dd2RXwD4sAFUCBLURV5j7utN4Sd7ruy8a3q0uiidc9ccPaSazkIM1kEy4TpIbD4kbz7I5/sL0L6FUypmmjwTcn+QDLZLsr8wiallV/JKOl51L6kFGUcDkYNRR9zrit0UjPaq4NCDHjbzVDgICv57MvbQ3xVf5e+QADMDq9YXoDYbSMsChfpkLrUXBS2/YJpbNyc6vRVjQhZAD0eIMsNR0ybod23m6Od7YdFwUS0DlJ+gIKwIMWTTKVKEmOFRzGkM7urS8Hf42QaDD3FKe0PF7A6EukSFu9iJ3kAKULBaC3HuDtubBnHyHcHo0tqZB6pg1yTSuekg3AAnD61L4npjiM91V5J1KsmRV39z6uZ1p3SXV3M3nTk6psokErM2QjBfiE2QEDPxwvZMvy/VKPlLzcAU79NIqkburqWiCScA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/1/15 18:00, Baolin Wang wrote:
> Hi Lance,
> 
> On 1/15/26 3:16 PM, Lance Yang wrote:
>> From: Lance Yang <lance.yang@linux.dev>
>>
>> tlb_remove_table_sync_one() sends IPIs to all CPUs and waits for them,
>> which we really don't want to do while holding PTL.
> 
> Could you add more comments to explain why this is safe for the PAE case?

Yep, IIUC, it is safe because we've already done pmdp_collapse_flush()
which ensures the PMD change is visible.

pmdp_get_lockless_sync() (which calls tlb_remove_table_sync_one() on PAE)
is just to ensure any ongoing lockless pmd readers (e.g., GUP-fast) complete
before we proceed. It sends IPIs to all CPUs and waits for responses - a CPU
can only respond when it's not between local_irq_save() and 
local_irq_restore().

Moving it out from under PTL doesn't change the synchronization semantics,
since lockless readers don't depend on PTL anyway.

> 
> For the non-PAE case, you added a new tlb_remove_table_sync_one(), why 
> we need this (to solve what problem)? Please also add more comments to 
> explain.

Oops, you're right, the original macro was a no-op for non-PAE.

I should just move the macro call out from under PTL, rather than
replacing it with direct tlb_remove_table_sync_one() calls.


Thanks,
Lance

> 
>> Just move the call to after we release PTL, and drop the macro wrapper
>> while we're at it.
>>
>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>> ---
>>   include/linux/pgtable.h | 4 ----
>>   mm/khugepaged.c         | 5 +++--
>>   2 files changed, 3 insertions(+), 6 deletions(-)
>>
>> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
>> index eb8aacba3698..fb04ed22052c 100644
>> --- a/include/linux/pgtable.h
>> +++ b/include/linux/pgtable.h
>> @@ -755,7 +755,6 @@ static inline pmd_t pmdp_get_lockless(pmd_t *pmdp)
>>       return pmd;
>>   }
>>   #define pmdp_get_lockless pmdp_get_lockless
>> -#define pmdp_get_lockless_sync() tlb_remove_table_sync_one()
>>   #endif /* CONFIG_PGTABLE_LEVELS > 2 */
>>   #endif /* CONFIG_GUP_GET_PXX_LOW_HIGH */
>> @@ -774,9 +773,6 @@ static inline pmd_t pmdp_get_lockless(pmd_t *pmdp)
>>   {
>>       return pmdp_get(pmdp);
>>   }
>> -static inline void pmdp_get_lockless_sync(void)
>> -{
>> -}
>>   #endif
>>   #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 9f790ec34400..0a6cebf880e0 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -1664,10 +1664,10 @@ static enum scan_result 
>> try_collapse_pte_mapped_thp(struct mm_struct *mm, unsign
>>           }
>>       }
>>       pgt_pmd = pmdp_collapse_flush(vma, haddr, pmd);
>> -    pmdp_get_lockless_sync();
>>       pte_unmap_unlock(start_pte, ptl);
>>       if (ptl != pml)
>>           spin_unlock(pml);
>> +    tlb_remove_table_sync_one();
>>       mmu_notifier_invalidate_range_end(&range);
>> @@ -1818,7 +1818,6 @@ static void retract_page_tables(struct 
>> address_space *mapping, pgoff_t pgoff)
>>            */
>>           if (likely(file_backed_vma_is_retractable(vma))) {
>>               pgt_pmd = pmdp_collapse_flush(vma, addr, pmd);
>> -            pmdp_get_lockless_sync();
>>               success = true;
>>           }
>> @@ -1826,6 +1825,8 @@ static void retract_page_tables(struct 
>> address_space *mapping, pgoff_t pgoff)
>>               spin_unlock(ptl);
>>   drop_pml:
>>           spin_unlock(pml);
>> +        if (success)
>> +            tlb_remove_table_sync_one();
>>           mmu_notifier_invalidate_range_end(&range);
> 


