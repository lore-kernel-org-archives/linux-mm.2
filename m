Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D78B5C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 05:49:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96CBF6B009E; Mon,  6 Jul 2026 01:49:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91D8F6B009F; Mon,  6 Jul 2026 01:49:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80C106B00A0; Mon,  6 Jul 2026 01:49:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DACD86B009E
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 01:49:11 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 52A301C2357
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 05:49:11 +0000 (UTC)
X-FDA: 84957273702.22.5C74D43
Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	by imf22.hostedemail.com (Postfix) with ESMTP id 98294C0002
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 05:49:07 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	spf=pass (imf22.hostedemail.com: domain of wangruikang@iscas.ac.cn designates 159.226.251.25 as permitted sender) smtp.mailfrom=wangruikang@iscas.ac.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783316949;
	b=c10KrmE7T1JRzDwns/QBa4W8UjDYhYrkIbVfiGxVBgkuOyRz7HKWONm5ugaxASCiqqjcR0
	uP/PtFLTPonIyjWnSTPPbWObMVCMLbub2brEvy475Q7LWHGwHtLkqGHa2zR3vxMIWGVKZ4
	cAAdAPmnUySQ8KsZ64FFNP5hHYxqqsA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of wangruikang@iscas.ac.cn designates 159.226.251.25 as permitted sender) smtp.mailfrom=wangruikang@iscas.ac.cn;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783316949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WwMF2aj9UZ6vai2ne8z58CIqSF1TWO6A8EE0BvxSuiQ=;
	b=SAboBV8uUDJueOGacGEaW4QR+2eyBAqY/EDIgpYIVw/6S9KzR/tVVVzjsqQnUuC6d90xcZ
	AyThUQt/F1Bf0KN8f9bUQoFIriHN3pzpbLf4IJ/J5MCV/s4Y/hUBMqLSGDNE4Hch2cmxe7
	8PEnqIx2+dotteaTJaW3mADZQ89vWCA=
Received: from [192.168.0.113] (unknown [123.118.218.239])
	by APP-05 (Coremail) with SMTP id zQCowADHNenDQUtqcJ4pFw--.19733S2;
	Mon, 06 Jul 2026 13:48:51 +0800 (CST)
Message-ID: <b1690a31-f11b-417a-bfdd-c4a357b12e7a@iscas.ac.cn>
Date: Mon, 6 Jul 2026 13:48:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] riscv: mm: Avoid spurious fault after hotplugging
 vmemmap
To: Muchun Song <muchun.song@linux.dev>
Cc: linuxppc-dev@lists.ozlabs.org, Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Alexandre Ghiti <alex@ghiti.fr>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
References: <20260630-mark-after-vmemmap-populate-v4-1-febbc15da028@iscas.ac.cn>
 <7B0CB4ED-C190-4F49-97EE-E1F14F08DED2@linux.dev>
 <5fac578c-ff97-4721-96f3-8ba495f0556a@iscas.ac.cn>
 <214FC970-465A-4E45-98C0-17978D63DE89@linux.dev>
Content-Language: en-US
From: Vivian Wang <wangruikang@iscas.ac.cn>
In-Reply-To: <214FC970-465A-4E45-98C0-17978D63DE89@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:zQCowADHNenDQUtqcJ4pFw--.19733S2
X-Coremail-Antispam: 1UD129KBjvJXoWxKw47XrWrKr1xJF45KryxAFb_yoW3Xr1kpF
	Wj9an8Kr4DJr1fCw4Iqw17Wrn7trnYga4xWw1kKry8Zwn0qFnrGryFqa1Y9ry8Xrn7WayI
	v3WYy343u345AaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvlb7Iv0xC_Kw4lb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I2
	0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
	A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xII
	jxv20xvEc7CjxVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4
	vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
	F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r
	4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACI402YVCY1x02628vn2kIc2xK
	xwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJV
	W8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF
	1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6x
	IIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvE
	x4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvj
	DU0xZFpf9x07bIBTOUUUUU=
X-Originating-IP: [123.118.218.239]
X-CM-SenderInfo: pzdqw2pxlnt03j6l2u1dvotugofq/
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 98294C0002
X-Stat-Signature: e1gbk4dxqm3b5eg4ce6aat1psap71c79
X-HE-Tag: 1783316947-581061
X-HE-Meta: U2FsdGVkX1/ci3925s6F4VGARUmF/CMy6GWsprY/tPd9OjLZMkU9DrorQvTH9V6wcnxUF9bW4OxugUw/Bf4tLV81be/QnnWgBZa1XnO8TmmfIFcBL+mZ3COQqpGrxg7I1nCXMngD9l5oO+nN+wRf4SblYHIDLMQmZFHQmhKZ8M2fglhda2l/x+Jhzsr2YD5sH/AJ21mVs2Jqv+QJAoBA5C9d07sQOmXFWRoOjZLqQN0sb1Z8YjfI+x60NlCl5bGAQw3B5rXtIsToHMl9Pxkcz1hRlNUDMagNJAoEJs3MZmMKFTaCedrS3I4k4LmNhN9nMs7VQ81rJ0KHxgpLawS7WEEjSfNKONJe1PiF5F44w4k75h/5tYTDH0pz672kNRYaMiERuZ6irbODyeKpqe72Fwxat8HFcN9KMbcp0Jv8T0oK2K13a3yPPL9IhkTNFDZFAtGDidwZTKbhEX+iUOR0rYUDKJaXmo4C5FjqXDp9yR6H5YaDV8pj0fFGWO09NkoK1eo1272+45hVFdt3kTqZ4afrg2SLDD/Hohwl31bVJJOLYFmXAYNhjTzVu1JnHQFQZOd5IAuBtMZGtZcMc88rf54ppYVXy5CtKgK703sO7CaMwhNcqgnVAfb3ZqfSyZMS3iXZVY1wo8UMcYrUo/N71kJNAYNxdN6HYCFQM0ZXDYQGgMeNl8i/eukB53b0r2OK15Rveid77Mdngitl6PEpIxP2xNDemOWqVwrUqrO8ZMGQ7gd/5AZjpA4d3tMe1yAhyKpKw7JC4dBa86+/TfY0116BItnmd7tRdAoC7LgtHzK+iKGn7SIHCRb6pOjFLQLz/hW+WLc3YF3AbKX9kPyrtmkEUOrpwQ1ztqRws2y8/HUqG0OA0oB7uFjhneSJxeCNiYvNoUhil5nO469kf39qV6P0+BjSmTrFDbo2I/PKGDY9gjOGpqdLXXQR3zYkFXqMp4ErRMdkxXpcJ9oCf/5
 lpOTq6BM
 lGJXFLDL6TnENxGn+ClYjWFIxqNnyELHC0Zgecy3GEkP3aY/Tupqpktl760atiTUENEtNjACnvH7hSW/S3CMEIPymNMWMKOMFek1vR307666NjeGdnMS+tKWq9xjTO4mW6sVjQLF3uYbtWSV1xeG7jiW7xyXyvxjmQDLCAjD4eMvSNd2esk/GaDU9g+ZSPyAWPQiTfs1YgQSxx/w466VoS/i7NzDrCCeXuyx7KItd519vJY+yXsuBzvHtRJIZ7GyjaihGSW1nlWZZDlS4GcprdfqneVGbWPmJQshWiBq25jdzW11ICviSXCvYR5e+14PYl+j7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/6/26 13:38, Muchun Song wrote:

>
>> On Jul 6, 2026, at 13:04, Vivian Wang <wangruikang@iscas.ac.cn> wrote:
>>
>> [ powerpc maintainers: Thoughts on replacing the ptesync in
>> vmemmap_set_pmd() with a flush_cache_vmap() post-vmemmap-hotplug in the
>> generic code? ]
>>
>> On 7/6/26 11:00, Muchun Song wrote:
>>>> On Jun 30, 2026, at 15:51, Vivian Wang <wangruikang@iscas.ac.cn> wrote:
>>>>
>>>> section_activate() does not flush TLB after populating new vmemmap
>>>> pages. On most architectures, this is okay. However it is a problem on
>>>> RISC-V since there the TLB caching non-present entries is permitted,
>>>> which causes spurious faults on some hardwares.
>>>>
>>>> This seems to be most easily reproduced with DEBUG_VM=y and
>>>> PAGE_POISONING=y, which causes these newly mapped struct pages to be
>>>> poisoned i.e. written to immediately after mapping.
>>>>
>>>> Add a hook vmemmap_populate_finalize() in __populate_section_memmap()
>>>> after population, to allow architectures to handle such situations as
>>>> needed. Then implement it on RISC-V to arrange for the existing
>>>> exception handler code to deal with these faults if they happen.
>>>>
>>>> Signed-off-by: Vivian Wang <wangruikang@iscas.ac.cn>
>>>> ---
>>>> Changes in v4:
>>>> - Rebase on v7.2-rc1, drop dependencies
>>>> - (No code changes otherwise)
>>>> - (A concurrency fix for mark_new_valid_map was sent independently)
>>>> https://lore.kernel.org/linux-riscv/20260629-riscv-mm-new-valid-map-ordering-v1-1-60d8c10c6292@iscas.ac.cn/
>>>> - Link to v3: https://patch.msgid.link/20260605-mark-after-vmemmap-populate-v3-1-a06001ac9264@iscas.ac.cn
>>>>
>>>> Changes in v3:
>>>> - Merged back into one patch (Mike)
>>>> - (No code changes otherwise.)
>>>> - Link to v2: https://patch.msgid.link/20260604-mark-after-vmemmap-populate-v2-0-ab6a7d03b434@iscas.ac.cn
>>>>
>>>> Changes in v2:
>>>> - Split patch in two, hook point and riscv hook 
>>>> - Explain hook necessity in patch 1 message (Mike)
>>>> - Make hook #define based (Mike)
>>>> - Call finalize hook only on populate success
>>>> - Link to v1: https://patch.msgid.link/20260525-mark-after-vmemmap-populate-v1-1-e698d859ba16@iscas.ac.cn
>>>> ---
>>>> arch/riscv/include/asm/pgtable.h | 4 ++++
>>>> arch/riscv/mm/init.c             | 6 ++++++
>>>> mm/sparse-vmemmap.c              | 8 ++++++++
>>>> 3 files changed, 18 insertions(+)
>>>>
>>>> diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
>>>> index 5d5756bda82e..6b000c990ba7 100644
>>>> --- a/arch/riscv/include/asm/pgtable.h
>>>> +++ b/arch/riscv/include/asm/pgtable.h
>>>> @@ -1253,6 +1253,10 @@ static inline pte_t pte_swp_clear_exclusive(pte_t pte)
>>>> #define TASK_SIZE FIXADDR_START
>>>> #endif
>>>>
>>>> +/* Needed on SPARSEMEM_VMEMMAP */
>>>> +#define vmemmap_populate_finalize vmemmap_populate_finalize
>>>> +void __meminit vmemmap_populate_finalize(void);
>>>> +
>>>> #else /* CONFIG_MMU */
>>>>
>>>> #define PAGE_SHARED __pgprot(0)
>>>> diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
>>>> index 5b1b3c88b4d1..800cb5c007d1 100644
>>>> --- a/arch/riscv/mm/init.c
>>>> +++ b/arch/riscv/mm/init.c
>>>> @@ -1372,6 +1372,12 @@ int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
>>>> */
>>>> return vmemmap_populate_hugepages(start, end, node, altmap);
>>>> }
>>>> +
>>>> +void __meminit vmemmap_populate_finalize(void)
>>>> +{
>>>> +  /* Avoid faults on cached non-present TLB entries. */
>>>> +  mark_new_valid_map();
>>>> +}
>>>> #endif
>>>>
>>>> #if defined(CONFIG_MMU) && defined(CONFIG_64BIT)
>>>> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
>>>> index 99e2be39671b..290cafcfd723 100644
>>>> --- a/mm/sparse-vmemmap.c
>>>> +++ b/mm/sparse-vmemmap.c
>>>> @@ -544,6 +544,12 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
>>>>
>>>> #endif
>>>>
>>>> +#ifndef vmemmap_populate_finalize
>>>> +static void __meminit vmemmap_populate_finalize(void)
>>>> +{
>>>> +}
>>>> +#endif
>>>> +
>>>> struct page * __meminit __populate_section_memmap(unsigned long pfn,
>>>> unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
>>>> struct dev_pagemap *pgmap)
>>>> @@ -564,6 +570,8 @@ struct page * __meminit __populate_section_memmap(unsigned long pfn,
>>>> if (r < 0)
>>>> return NULL;
>>>>
>>>> +  vmemmap_populate_finalize();
>>> Does the hook of flush_cache_vmap() work for you?  From the document of
>>> cachetlb.rst, it said: 
>>>
>>> 6) ``void flush_cache_vmap(unsigned long start, unsigned long end)``
>>>    ``void flush_cache_vunmap(unsigned long start, unsigned long end)``
>>>
>>> Here in these two interfaces we are flushing a specific range
>>> of (kernel) virtual addresses from the cache. After running,
>>> there will be no entries in the cache for the kernel address
>>> space for virtual addresses in the range 'start' to 'end-1'.
>>>
>>> It seems that flush_cache_vmap() is supposed to be called after a new kernel
>>> mapping has been installed, but before this address range is accessed.
>> Good point. I had initially avoided flush_cache_vmap() because, to be
>> honest, it looked scary. But the combination of "have vmemmap" and "have
>> flush_cache_vmap()" is much less scary.
>>
>> I'd need to drop the address range check in RISC-V's flush_cache_vmap(),
>> but might as well.
> No. Please a new check for vmemmap address range.

Okay, I'll do that in v5.

>
>>> Therefore, invoking flush_cache_vmap() here aligns perfectly with its interface
>>> definition. But how would this change impact other architectures? Currently,
>>> among architectures where CONFIG_SPARSEMEM=y, only RISC-V and PowerPC provide
>>> a concrete implementation for flush_cache_vmap().
>>>
>>> For PowerPC, the implementation is as follows:
>>>
>>> static inline void flush_cache_vmap(unsigned long start, unsigned long end)
>>> {
>>> asm volatile("ptesync" ::: "memory");
>>> }
>>>
>>> Here, flush_cache_vmap() is also intended to supply the ptesync instruction
>>> that the kernel address mapping lacks. However, flush_cache_vmap() is not
>>> called in the __populate_section_memmap() path. So, how does PowerPC ensure
>>> ptesync is executed there? The answer lies in the architecture-specific
>>> vmemmap_set_pmd(), which injects the necessary ptesync.
>>>
>>> If we choose to reuse flush_cache_vmap() in the generic path, it yields the
>>> following benefits:
>>>
>>> - Avoids architectural churn: We do not need to introduce a new hook
>>>  like vmemmap_populate_finalize().
>>> - Cleans up arch code: PowerPC can deprecate its custom vmemmap_set_pmd()
>>>  and migrate to the generic implementation.
>>>
>>> Let me know if this rationale makes sense, or if there are any hidden edge
>>> cases I might have overlooked regarding other architectures.
>>>
>>> Thanks,
>>> Muchun
>> At least on the face of it, it makes sense. The main thing is I don't
>> know much about powerpc. So I'm also hoping powerpc maintainers could
>> chime in. 
> You do not need to know about powerpc since the change of powerpc is not
> a part of this patch. It should be a separate code clean up for powerpc.

Ah, good point. I'll just use flush_cache_vmap() in v5, and, as you
said, the powerpc stuff can come later.

Thanks,
Vivian "dramforever" Wang


