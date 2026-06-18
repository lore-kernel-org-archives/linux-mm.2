Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDD7BCD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 17:07:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8ABD46B008C; Thu, 18 Jun 2026 13:07:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85D3A6B0092; Thu, 18 Jun 2026 13:07:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74D676B0096; Thu, 18 Jun 2026 13:07:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3EF816B0092
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 13:07:49 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B7F2C401CA
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 17:07:48 +0000 (UTC)
X-FDA: 84893665416.11.FB0E5CE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id EC43A120010
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 17:07:46 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kx8zyzO7;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781802467;
	b=ALjaRafj/wVTtA6pBLA/c8CxmDiZwqBx7UTUR4cV4fJANu9i9sPnNfQiXcPRFImZzjFM2A
	9wRD3Gj7VBmMy2/WqEuADD5dh/uffmSdSjj0uhsoV2q1JWFxQekQNFpld6E88WcMwamXzB
	1Ru17okJIDfsZ8cJv6HHZC0Jd+FL/Ck=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kx8zyzO7;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781802467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CaAA2B6CTQIeAfF9nNT4236V48ifhECzdxsqKpDS0ls=;
	b=xUKF/FBKnW4LNEMnQr1nXrVTGvlkcw35WA7EZL27B964b7TIG8h4Mt/Npo8kaEiLWkrD1D
	s41zqp+dzOMtszbZ/KID5XljYXCoRVXLbJMcKdD5nykIW/DEJlX86vDVWbA9/tryeKbq1P
	NfOlgxj/5JpBNycKHwCq6AD05NbhCj8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 78A3360008;
	Thu, 18 Jun 2026 17:07:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E918C1F000E9;
	Thu, 18 Jun 2026 17:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781802466;
	bh=CaAA2B6CTQIeAfF9nNT4236V48ifhECzdxsqKpDS0ls=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kx8zyzO7PD8eRTepsHFSKPOmTVEjflYhbBq8sJgG/XnkcbumUjsrnPnpb8BAk96NG
	 uDKM2RRHU8sthRNpOO7lceCoOvyiaPjBVH5tJcRgET75MmRsovul7z3M4BX3nppi76
	 klICesKuwG3QdWmmy5F1qI9UaneeNSKncQQLYVltcOdBO2JPXaX6X1qhYkCP+K3e1O
	 x1T+0i1oTYqiEuCiX23YlS23fEhMDDyP2ytPDvMkl9c+DiUUJbDaq0tnMkRJiTiCza
	 sMLpe3fp3/E4dNMPbVx49HvrGsvlLUHjw3bNtzS9YUFZBBc1oDW/OZqvXsnA4CEc9D
	 K9dR/6xjecUDQ==
Message-ID: <929d36a3-f08d-47e5-94c0-b06739dac74c@kernel.org>
Date: Thu, 18 Jun 2026 19:07:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] mm: read remote memory without the mmap lock where
 possible
To: Usama Arif <usama.arif@linux.dev>, Rik van Riel <riel@surriel.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Dmitry Ilvokhin <d@ilvokhin.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>
References: <20260618170157.1375279-1-usama.arif@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260618170157.1375279-1-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: om9dkaedkemij7bqih87ifb1hofd6nro
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EC43A120010
X-HE-Tag: 1781802466-22633
X-HE-Meta: U2FsdGVkX1+cYZomxmmekj/DGNyXb46eVu8bPiYSYsUgOWGIKUzJ+SPwKE1LOENFLzy0Xf9jMSIsGxl/4WdSqF3QOwCiePpqh0FhmEzND3gphIqRTm3+XYBy1XCFVHg9CHjPgybWVBG+7NvHoMl4bZpt5cfcHSL/B8h1zD8D8IVaQ6nVymqhTVUt8gtsF/amGUM7q+1sks9fQwkV6yxl8DHWKvLI3ZYp5L4fKc2/7RZiAL6kk+I70Nr+yZGEcQKevJinGKhhjGsxySsdP23SCcnU3f70nr7KNJjeIWlf5VPmXqZQOgg2wpG0NRAxtzwLplHIJdN5cn3u7cGdhbJ0zg8eS/nREt3jUlYu8gC7FaJdHqqN3r3xBej9t/Ccv+2Eloilzxxe8xsFcGDDHikNbQrXGR+sJ3XaMhlAkNzydV7PK410IuCKpUwWWjSnNY2ALa/HK7z7sCrcUQCoh8QwYlg6zinuApUV3SIGwJE3pMwZnJO3WgJza2qiJsPJfThLHtiJSI3m2J4sAYA7Qvlri9XqCaxnlL+wpODCaR2gEh2bpPLUNEPe9LCQyWIXttYaXDofgeUzk5uzXPrQtuLSdr+wGR8kL34d7liyB9KAzcG2+EMk0XV/LdtX+Yx0ZQW2YQPbej4rOGIVg2QPUAGRwko6JhqeTcsgFmdpS8tgS1eXuFw22GjP++WA5aPe3egmyOJmKAL21B1NrPvOXsjWd/UBiZtZeOKFpjiD8kxPvoO/ykSA3ierAs2ELoNy3QsIeX4GtevUHzTi0ltgVEfRtqYxGrL42WNRC7U2TZflNx7bimYkg70+Ic+C01Q6VDDyLJMECcd11A29mSmzuePGUteZEx7A/zlDxGjseiGBKkfJv/lcH7I4aoBX/i+5kZnbDHh4iWI1jTTFePucXJKd9OkGU1VoX67PRxahR69MT9bMj0v6hZBD84j61SuIkUJBrlZeQRliMaqVirJZYzK
 zYsubI3c
 JV6Q3ji+3lNzqnz62FdPAiJTVMA/0VI4J+f8rpOQ3LV0Czd0Kx31kREehqci606NY2uQBEwGx/TW0xHwnBrEaVlqLW9pnDqGEBCsICZI0ejGM/kUmm/XW+E5SLbuIzaWkvb2hqBgC3NKMgGGjFd/6Disz8XgUafLEtq4iXOX5JQnYXLEX5oS4p0JMARqPv+5AzQm7/L6NKVvcsWzg89uojLjA+wWjanX+qRiuHsUhmL10Q6MV7I6nAZeDgHcZPVjnycAWyInag5mQhh59v7MWDegSDzAdJAViCaerO6vrS22obQZpLbBkFnzt8lj0gl4UQksV1E3o+w/MbqmnEe2hkHTTxNHp1bSFI6dz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/18/26 19:01, Usama Arif wrote:
> On Tue, 16 Jun 2026 15:03:00 -0400 Rik van Riel <riel@surriel.com> wrote:
> 
>> __access_remote_vm() takes mmap_read_lock() for the entire transfer and
>> uses get_user_pages_remote(), which faults pages in.  For the common
>> case of reading memory that is already resident -- /proc/PID/cmdline,
>> /proc/PID/environ, ptrace PEEK of resident pages -- the mmap lock is
>> unnecessary and is badly contended on large machines.
>>
>> Add an opportunistic, read-only fast path that transfers what it can
>> without the mmap lock.  For each address it takes the per-VMA lock with
>> lock_vma_under_rcu(), re-checks the read-side VMA permissions, and uses
>> folio_walk_start(..., FW_VMA_LOCKED) to grab a short-lived reference to
>> a present page before copying it out.  Anything non-trivial -- a not-
>> present page (needs faulting), a hugetlb or VM_IO/VM_PFNMAP mapping, or
>> a race with a VMA writer -- falls back to the existing mmap_lock path
>> for the remainder.
>>
>> untagged_addr_remote() asserts the mmap lock, so add an unlocked variant
>> for the fast path; the untag mask is a stable per-mm value.
>>
>> Only reads are handled here; writes keep using the slow path.
>>
>> Assisted-by: Claude:claude-opus-4-8
>> Signed-off-by: Rik van Riel <riel@surriel.com>
>> ---
>>  arch/x86/include/asm/uaccess_64.h |  12 +++
>>  include/linux/uaccess.h           |  11 ++
>>  mm/memory.c                       | 166 +++++++++++++++++++++++++++++-
>>  3 files changed, 188 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
>> index 4a52497ba6a1..c6fac900a747 100644
>> --- a/arch/x86/include/asm/uaccess_64.h
>> +++ b/arch/x86/include/asm/uaccess_64.h
>> @@ -51,6 +51,18 @@ static inline unsigned long __untagged_addr_remote(struct mm_struct *mm,
>>  	(__force __typeof__(addr))__untagged_addr_remote(mm, __addr);	\
>>  })
>>  
>> +/* Same as __untagged_addr_remote(), but usable without the mmap lock held. */
>> +static inline unsigned long __untagged_addr_remote_unlocked(struct mm_struct *mm,
>> +							    unsigned long addr)
>> +{
>> +	return addr & READ_ONCE((mm)->context.untag_mask);
>> +}
>> +
>> +#define untagged_addr_remote_unlocked(mm, addr)	({			\
>> +	unsigned long __addr = (__force unsigned long)(addr);		\
>> +	(__force __typeof__(addr))__untagged_addr_remote_unlocked(mm, __addr); \
>> +})
>> +
>>  #endif
>>  
>>  #define valid_user_address(x) \
>> diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
>> index 8a264662b242..c8c83372c9d8 100644
>> --- a/include/linux/uaccess.h
>> +++ b/include/linux/uaccess.h
>> @@ -34,6 +34,17 @@
>>  })
>>  #endif
>>  
>> +/*
>> + * Like untagged_addr_remote(), but for callers that stabilize @mm by other
>> + * means (e.g. a per-VMA lock) and must not assert the mmap lock.
>> + */
>> +#ifndef untagged_addr_remote_unlocked
>> +#define untagged_addr_remote_unlocked(mm, addr)	({	\
>> +	(void)(mm);					\
>> +	untagged_addr(addr);				\
>> +})
>> +#endif
>> +
>>  #ifdef masked_user_access_begin
>>   #define can_do_masked_user_access() 1
>>  # ifndef masked_user_write_access_begin
>> diff --git a/mm/memory.c b/mm/memory.c
>> index 86a973119bd4..0b23b82eaa18 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -42,6 +42,8 @@
>>  #include <linux/kernel_stat.h>
>>  #include <linux/mm.h>
>>  #include <linux/mm_inline.h>
>> +#include <linux/secretmem.h>
>> +#include <linux/pagewalk.h>
>>  #include <linux/sched/mm.h>
>>  #include <linux/sched/numa_balancing.h>
>>  #include <linux/sched/task.h>
>> @@ -7062,6 +7064,153 @@ int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
>>  EXPORT_SYMBOL_GPL(generic_access_phys);
>>  #endif
>>  
>> +/*
>> + * The fast path uses folio_walk_start(FW_VMA_LOCKED), which needs the per-VMA
>> + * lock and RCU-freed page tables to walk page tables without the mmap lock.
>> + */
>> +#if defined(CONFIG_PER_VMA_LOCK) && defined(CONFIG_MMU_GATHER_RCU_TABLE_FREE)
>> +/*
>> + * Opportunistic lockless fast path for __access_remote_vm() reads.
>> + *
>> + * Memory already resident in @mm can be read without taking the heavily
>> + * contended mmap_lock: a per-VMA lock stabilizes the VMA, and folio_walk_start()
>> + * with FW_VMA_LOCKED grabs a short-lived reference to a present page via an
>> + * RCU/PTL protected page table walk (relying on MMU_GATHER_RCU_TABLE_FREE).
>> + *
>> + * Anything that would require faulting a page in, touching a hugetlb or
>> + * VM_IO/VM_PFNMAP mapping, or that races a VMA writer is left to the mmap_lock
>> + * path in __access_remote_vm().  Only reads are handled here.
>> + *
>> + * Returns the number of bytes transferred via the fast path.
>> + */
>> +static int access_remote_vm_fast(struct mm_struct *mm, unsigned long addr,
>> +				 void *buf, int len, unsigned int gup_flags)
>> +{
>> +	void *old_buf = buf;
>> +
>> +	addr = untagged_addr_remote_unlocked(mm, addr);
>> +
>> +	while (len) {
>> +		struct vm_area_struct *vma;
>> +		vm_flags_t vm_flags;
>> +
>> +		vma = lock_vma_under_rcu(mm, addr);
>> +		if (!vma)
>> +			break;
>> +
>> +		/*
>> +		 * Mirror the read-side permission checks of check_vma_flags(),
>> +		 * and exclude what FW_VMA_LOCKED cannot handle (hugetlb) or what
>> +		 * needs the ->access() handler (VM_IO/VM_PFNMAP).  Checked once
>> +		 * per VMA; anything not positively allowed falls back to the
>> +		 * slow path, which re-validates everything.
>> +		 */
>> +		vm_flags = vma->vm_flags;
>> +		if ((vm_flags & (VM_IO | VM_PFNMAP)) ||
>> +		    is_vm_hugetlb_page(vma) || vma_is_secretmem(vma) ||
>> +		    (!(vm_flags & VM_READ) &&
>> +		     (!(gup_flags & FOLL_FORCE) || !(vm_flags & VM_MAYREAD)))) {
>> +			vma_end_read(vma);
>> +			break;
>> +		}
> 
> This should also do the FOLL_ANON check from check_vma_flags().
> 
> check_vma_flags() rejects non-anonymous VMAs when FOLL_ANON is set:
> 
> 	if ((gup_flags & FOLL_ANON) && !vma_anon)
> 		return -EFAULT;

Duplicating GUP logic in a non-GUP file. Splendid. :)

-- 
Cheers,

David

