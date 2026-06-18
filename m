Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C141DCD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 17:23:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A52CE6B008A; Thu, 18 Jun 2026 13:23:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A04446B0092; Thu, 18 Jun 2026 13:23:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CD746B0093; Thu, 18 Jun 2026 13:23:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5032B6B008A
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 13:23:05 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ADA401C3A73
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 17:23:04 +0000 (UTC)
X-FDA: 84893703888.02.A3B4874
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf05.hostedemail.com (Postfix) with ESMTP id CB82A100013
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 17:23:02 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RgFPJQas;
	spf=pass (imf05.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781803383;
	b=gDv5tZeDlMe13yan97oAkBfCKTK7oa2pvpMoIe98btc/n85Y8i6UVVz7aIWKDh7XEpRlon
	r2g2ynDIgcDU47WWUEwSihS4tHET1+OQtefV49GFPB1IV6lRROtD8C9L5CHLU9upBWXihd
	jCdgSTjWMy/bWuvTCfoQ8rA+6BDMrrw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RgFPJQas;
	spf=pass (imf05.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781803383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0PJPXyL0vEYOxNtEDKLnBlyl99TpZJvo/qte7kjtaCc=;
	b=zKXuLJ9E6D6P8aGocUxRZqZqO6MntYvOgZqfFOfzVcuik41lFJobyF8R016yZfri2omANa
	XjgDcckKpCuy7qIUN+jx1HGzTskGbHjz7QG5mB+3hiv0eyu+svOf1DmK06zlMWjX1LvQj8
	ZV3VYZedSxEt8ZHPHuakNmqYltaGYjs=
Message-ID: <08a8a7c9-b60d-44f0-9028-f480e318d756@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781803381;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0PJPXyL0vEYOxNtEDKLnBlyl99TpZJvo/qte7kjtaCc=;
	b=RgFPJQashPgEaWVAW9M8qHFisy7Pv/RbbHVWsTnXshdG8oGEfn0G4R49eQBlwHzibd3vkC
	cD6dYD3pxQtQ9HxL1brDswkl5m5oztJR+jxGlqPnIVZjf9SkQwTJhyGYprWXZjyNmShf9w
	K0GfTkflVqRBbGMILW7hhQscdlqK4k4=
Date: Thu, 18 Jun 2026 18:22:51 +0100
MIME-Version: 1.0
Subject: Re: [PATCH 3/3] mm: read remote memory without the mmap lock where
 possible
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Rik van Riel <riel@surriel.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Dmitry Ilvokhin <d@ilvokhin.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>
References: <20260618170157.1375279-1-usama.arif@linux.dev>
 <929d36a3-f08d-47e5-94c0-b06739dac74c@kernel.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <929d36a3-f08d-47e5-94c0-b06739dac74c@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CB82A100013
X-Stat-Signature: x3j86fetqhm1rsgn8w1tkb6yy5wutxkm
X-HE-Tag: 1781803382-544794
X-HE-Meta: U2FsdGVkX1+uRqghwqZO1Vhbg1AsU959oZN4L/KGI21FYLt88v+uNPevjFq2OtgBcTprPB8lC3UeBU5UBGNwofo2Wze2eIp1hzfkxBfgw5n/Voa2YI2QhT5uFDaOJuldmfEGUB2fu/xp76LYIXlOmAcbW4iJONK73HvVnZTPTql0ECGidYQvdXspoIpFcYmHpmIOF1lc8QC4JX4zIJCxE/RBwxfeQEkFtFbLcXNRrMpzsfFu0nSY1UJk5yW0YWkkYp3HvDN/Q/5NUKKaXTbOb790nlWnO6W4tof2QYuE0OCHRgxM/ud/ntZMVXXJkm6Qs0JnwzvJYhofU+Oq/JNBWe5bKKjk6Py9q7XH8jG4iG4kwk9NWzvi3RZabE7KKT7/mCKFkO2HGefuD9XmIY/AfRJJHztXFO7W6RXZDb51HZgmmTMhS+En/3/CiNgXPg7/F701jzOkAuboHDcgUa4RFo39f1ngHjY2+xeXL8HMVvnjPsfLxEj8iToF9zDgMhkdyrDODnddR4mRhP/NQr/Om9GidwZTakM8m8gWwwzgQLCuD9OTBceUyAtxXl4kcPdNfjmM7QVoLUzzhpsVnOy/CbWonn/ZhMmhOLB4ScJ++aEMGSFiHI9ZNAfiGWFT8lcispu1RpZ7mNW/0BBS03acIrOXfHjp7mAH5odvBgrZMhgmUeTbGIoZfMQ/Agd9d5Dq5AiIeuWrLgxIqbPmvFNPXdVykj7AN4Gl4PZFIZJtjDu3hNrO9kRdeZBcnxS5vH8gie85PY75G2k5Hi+RD+C5GOfrIgW5u4HMOKBsdor25CfIZMAmYFIAq3I5y2yIxO6TxZ72rP2uqQS+Mf4VZ91VgvNEzvjm32I930xVcx4OiR3ZU6W1dfLycLymimD2l3pkv0wEBFH2PkUHV6BfJSAewcxSUEvYW63g2GdhIUH89ifiWNdHgng9SELoSoGPeaBP42h7Qa9Uz1a7a/2tDjE
 j/G6BTua
 W9t4/6ZVt+TEsClfEXZQnAOddPmp8ZxN+yJCD6xKfDo3HsBHcsEum3u/E2InzBb6/L1xiDayb29vfR7Maoe1nPLZhhxYJxXjR6GJv/r6pP8c2cJiX+LG5hTCSp1JvYglNVlBcJcDVjBDnfVwP76Em/Erl51t4lm8Q2FQn7onCXx0kqS1bRgRk+vt2e4ME0PvgxeNu3Eg34Hu7Fc0r5R1G3r0xyi+noaOTdm8PUovatPUmcRliIE0oBw0Y/02t4TMaSxqNoEDM/XY6Q8I6wkKg/g1Lb0y8K2q1RKSU0zf5uyDjzrSLr06Os40dvA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 18/06/2026 18:07, David Hildenbrand (Arm) wrote:
> On 6/18/26 19:01, Usama Arif wrote:
>> On Tue, 16 Jun 2026 15:03:00 -0400 Rik van Riel <riel@surriel.com> wrote:
>>
>>> __access_remote_vm() takes mmap_read_lock() for the entire transfer and
>>> uses get_user_pages_remote(), which faults pages in.  For the common
>>> case of reading memory that is already resident -- /proc/PID/cmdline,
>>> /proc/PID/environ, ptrace PEEK of resident pages -- the mmap lock is
>>> unnecessary and is badly contended on large machines.
>>>
>>> Add an opportunistic, read-only fast path that transfers what it can
>>> without the mmap lock.  For each address it takes the per-VMA lock with
>>> lock_vma_under_rcu(), re-checks the read-side VMA permissions, and uses
>>> folio_walk_start(..., FW_VMA_LOCKED) to grab a short-lived reference to
>>> a present page before copying it out.  Anything non-trivial -- a not-
>>> present page (needs faulting), a hugetlb or VM_IO/VM_PFNMAP mapping, or
>>> a race with a VMA writer -- falls back to the existing mmap_lock path
>>> for the remainder.
>>>
>>> untagged_addr_remote() asserts the mmap lock, so add an unlocked variant
>>> for the fast path; the untag mask is a stable per-mm value.
>>>
>>> Only reads are handled here; writes keep using the slow path.
>>>
>>> Assisted-by: Claude:claude-opus-4-8
>>> Signed-off-by: Rik van Riel <riel@surriel.com>
>>> ---
>>>  arch/x86/include/asm/uaccess_64.h |  12 +++
>>>  include/linux/uaccess.h           |  11 ++
>>>  mm/memory.c                       | 166 +++++++++++++++++++++++++++++-
>>>  3 files changed, 188 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
>>> index 4a52497ba6a1..c6fac900a747 100644
>>> --- a/arch/x86/include/asm/uaccess_64.h
>>> +++ b/arch/x86/include/asm/uaccess_64.h
>>> @@ -51,6 +51,18 @@ static inline unsigned long __untagged_addr_remote(struct mm_struct *mm,
>>>  	(__force __typeof__(addr))__untagged_addr_remote(mm, __addr);	\
>>>  })
>>>  
>>> +/* Same as __untagged_addr_remote(), but usable without the mmap lock held. */
>>> +static inline unsigned long __untagged_addr_remote_unlocked(struct mm_struct *mm,
>>> +							    unsigned long addr)
>>> +{
>>> +	return addr & READ_ONCE((mm)->context.untag_mask);
>>> +}
>>> +
>>> +#define untagged_addr_remote_unlocked(mm, addr)	({			\
>>> +	unsigned long __addr = (__force unsigned long)(addr);		\
>>> +	(__force __typeof__(addr))__untagged_addr_remote_unlocked(mm, __addr); \
>>> +})
>>> +
>>>  #endif
>>>  
>>>  #define valid_user_address(x) \
>>> diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
>>> index 8a264662b242..c8c83372c9d8 100644
>>> --- a/include/linux/uaccess.h
>>> +++ b/include/linux/uaccess.h
>>> @@ -34,6 +34,17 @@
>>>  })
>>>  #endif
>>>  
>>> +/*
>>> + * Like untagged_addr_remote(), but for callers that stabilize @mm by other
>>> + * means (e.g. a per-VMA lock) and must not assert the mmap lock.
>>> + */
>>> +#ifndef untagged_addr_remote_unlocked
>>> +#define untagged_addr_remote_unlocked(mm, addr)	({	\
>>> +	(void)(mm);					\
>>> +	untagged_addr(addr);				\
>>> +})
>>> +#endif
>>> +
>>>  #ifdef masked_user_access_begin
>>>   #define can_do_masked_user_access() 1
>>>  # ifndef masked_user_write_access_begin
>>> diff --git a/mm/memory.c b/mm/memory.c
>>> index 86a973119bd4..0b23b82eaa18 100644
>>> --- a/mm/memory.c
>>> +++ b/mm/memory.c
>>> @@ -42,6 +42,8 @@
>>>  #include <linux/kernel_stat.h>
>>>  #include <linux/mm.h>
>>>  #include <linux/mm_inline.h>
>>> +#include <linux/secretmem.h>
>>> +#include <linux/pagewalk.h>
>>>  #include <linux/sched/mm.h>
>>>  #include <linux/sched/numa_balancing.h>
>>>  #include <linux/sched/task.h>
>>> @@ -7062,6 +7064,153 @@ int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
>>>  EXPORT_SYMBOL_GPL(generic_access_phys);
>>>  #endif
>>>  
>>> +/*
>>> + * The fast path uses folio_walk_start(FW_VMA_LOCKED), which needs the per-VMA
>>> + * lock and RCU-freed page tables to walk page tables without the mmap lock.
>>> + */
>>> +#if defined(CONFIG_PER_VMA_LOCK) && defined(CONFIG_MMU_GATHER_RCU_TABLE_FREE)
>>> +/*
>>> + * Opportunistic lockless fast path for __access_remote_vm() reads.
>>> + *
>>> + * Memory already resident in @mm can be read without taking the heavily
>>> + * contended mmap_lock: a per-VMA lock stabilizes the VMA, and folio_walk_start()
>>> + * with FW_VMA_LOCKED grabs a short-lived reference to a present page via an
>>> + * RCU/PTL protected page table walk (relying on MMU_GATHER_RCU_TABLE_FREE).
>>> + *
>>> + * Anything that would require faulting a page in, touching a hugetlb or
>>> + * VM_IO/VM_PFNMAP mapping, or that races a VMA writer is left to the mmap_lock
>>> + * path in __access_remote_vm().  Only reads are handled here.
>>> + *
>>> + * Returns the number of bytes transferred via the fast path.
>>> + */
>>> +static int access_remote_vm_fast(struct mm_struct *mm, unsigned long addr,
>>> +				 void *buf, int len, unsigned int gup_flags)
>>> +{
>>> +	void *old_buf = buf;
>>> +
>>> +	addr = untagged_addr_remote_unlocked(mm, addr);
>>> +
>>> +	while (len) {
>>> +		struct vm_area_struct *vma;
>>> +		vm_flags_t vm_flags;
>>> +
>>> +		vma = lock_vma_under_rcu(mm, addr);
>>> +		if (!vma)
>>> +			break;
>>> +
>>> +		/*
>>> +		 * Mirror the read-side permission checks of check_vma_flags(),
>>> +		 * and exclude what FW_VMA_LOCKED cannot handle (hugetlb) or what
>>> +		 * needs the ->access() handler (VM_IO/VM_PFNMAP).  Checked once
>>> +		 * per VMA; anything not positively allowed falls back to the
>>> +		 * slow path, which re-validates everything.
>>> +		 */
>>> +		vm_flags = vma->vm_flags;
>>> +		if ((vm_flags & (VM_IO | VM_PFNMAP)) ||
>>> +		    is_vm_hugetlb_page(vma) || vma_is_secretmem(vma) ||
>>> +		    (!(vm_flags & VM_READ) &&
>>> +		     (!(gup_flags & FOLL_FORCE) || !(vm_flags & VM_MAYREAD)))) {
>>> +			vma_end_read(vma);
>>> +			break;
>>> +		}
>>
>> This should also do the FOLL_ANON check from check_vma_flags().
>>
>> check_vma_flags() rejects non-anonymous VMAs when FOLL_ANON is set:
>>
>> 	if ((gup_flags & FOLL_ANON) && !vma_anon)
>> 		return -EFAULT;
> 
> Duplicating GUP logic in a non-GUP file. Splendid. :)
> 

Haha probably just need a common helper.


