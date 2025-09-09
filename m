Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B9D9CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 16:32:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5EA48E0013; Tue,  9 Sep 2025 12:32:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E36B88E0001; Tue,  9 Sep 2025 12:32:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D73498E0013; Tue,  9 Sep 2025 12:32:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C50BE8E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 12:32:42 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 98336BABB1
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 16:32:42 +0000 (UTC)
X-FDA: 83870255364.29.C61833E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 67F16A000C
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 16:32:40 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf25.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757435561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d7RuMnOfRLOgqBFzywISUwVsIo2P2e84z86zg3i8x94=;
	b=p6fO3NyjRshstqPOjBPCa7RZjst6G7pF3gqYDhwTgIo7ZG2Ll7D4q+IYJN0yBSXyK9aGvL
	7dkX7aNX2uyHVjCer+N2WSDxTucvV50D8cYoBs3fzMegMVGKq0wu+tSFj34UkJsDtMueR0
	ruwXcqzu4LUm1yRUtmm1ECR5ke6V0tM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757435561; a=rsa-sha256;
	cv=none;
	b=nVkCLIKKh75eKObZXqdan1d9qoZeUkco6IgXH/vWaMIALuSOuyjB9ZRJzympfwE+phwKQz
	y7yb7oyF3k5UARYIj6YFiKDMvxt+loH9EvrswfCnDIDRuVw/S536w6LHzszwhqzFtQGKnC
	jAXywofnEV/1F0h0XMM0Y6ZS1P2P9qQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf25.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E47DF1424;
	Tue,  9 Sep 2025 09:32:30 -0700 (PDT)
Received: from [10.1.33.194] (unknown [10.1.33.194])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 70AD03F66E;
	Tue,  9 Sep 2025 09:32:37 -0700 (PDT)
Message-ID: <1cfda234-1339-4d83-bd87-b219fbd72664@arm.com>
Date: Tue, 9 Sep 2025 17:32:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/6] arm64: support FEAT_BBM level 2 and large block
 mapping when rodata=full
Content-Language: en-GB
To: Yang Shi <yang@os.amperecomputing.com>, Dev Jain <dev.jain@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Ard Biesheuvel <ardb@kernel.org>, scott@os.amperecomputing.com, cl@gentwo.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20250829115250.2395585-1-ryan.roberts@arm.com>
 <e722e49a-d982-4b58-98f7-6fef3d0a4468@arm.com>
 <dd242f5b-8bbe-48e8-8d5f-be6a835a8841@arm.com>
 <aeb76956-f980-417f-b4e7-fe0503bb5a2b@os.amperecomputing.com>
 <612940d2-4c8e-459c-8d7d-4ccec08fce0a@os.amperecomputing.com>
 <1471ea27-386d-4950-8eaa-8af7acf3c34a@arm.com>
 <f8cf1823-1ee9-4935-9293-86f58a9e2224@arm.com>
 <bf1aa0a4-08de-443f-a1a3-aa6c05bab38c@os.amperecomputing.com>
 <39c2f841-9043-448d-b644-ac96612d520a@os.amperecomputing.com>
 <d7cd4004-bacf-47b0-9cd8-f99125e02238@arm.com>
 <fe52a1d8-5211-4962-afc8-c3f9caf64119@os.amperecomputing.com>
 <8c363997-7b8d-4b54-b9b0-1a1b6a0e58ed@arm.com>
 <4aa4eedc-550f-4538-a499-504dc925ffc2@os.amperecomputing.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <4aa4eedc-550f-4538-a499-504dc925ffc2@os.amperecomputing.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6wt8m8coujsbca98m87rcsufscg4ajqi
X-Rspam-User: 
X-Rspamd-Queue-Id: 67F16A000C
X-Rspamd-Server: rspam10
X-HE-Tag: 1757435560-149836
X-HE-Meta: U2FsdGVkX19GBJujb6Sk+SPBUa2MRkZWQGTpW4AvyJbUbyO2hH+24dEc2H8wQ76IA7TCagG9MfFQIjccfpcPdvbQHpiXkdOcQzdwIHj3Dmviac+aPdfHmhJwFZ7eAPNwYqoPLbrxUuzxZjNQMkn3AGzjEn4tyR/po92uegc0/sndzRa6TKa4Cc78Nxsddp54OItUUAtt6IIIGWmVH/MQ1qW0cQr/T+w/ABtGbjWuVvqt6u9Li6cGkQADy2Buyd3vaktdZwAhdImajc9iGc1fzQ9UQ6JDPwWan6BOKN3VQdZOy+qJDntn/kaPliKaBYqd6kV+eQA8QkDnInq5UM+ey6i1glJ1gRNS+Pf+jtxEUCX9vbq9T6ThzXfv4alrpsaAFgRFwQftj1yX8fJlcTlE9SDkw1DfRtkn8TTotNBfSRINWWRx8E1w4+v3E3IV1AiE3VuzASZhKmspnNYUTbZJhTY8x8Y3+hxZY0rz3FEdrrNP+d0PGElBUzfRUNUF/4/Ex3pJ8D+S/LuLN37gWM6MW+LrwpZo+VmRO0+UzYkWJn1XST4oOvpxjMqcVUqitnB8x1n/BK49N1SPNUtkbcZouxptJJbuqx1qkYbm9Fadw+SWug8aIgw2T+f0SD+nezAKtWrTG09d2VGWhX6kKjDzNyhCXq4OiVxuh+FQUcQ16T7uqDwt7KeymuwSREXTNqbsP0HA8PtBibGhcFgn/BEoSLO4UP8i614pe56ppsxKM5lk8nhPCbywVt4Npt5e202/+47WvmChSnsPyNlDWyT+XKv8ckS4oD5Od/xahlpSfX+SWhRZ5igqYQ+a/bW1uipGD/OK83kl/zjJeOjtP9t4nPte+Nnhp0gUgUy144xvT3mzXH8XFxrwgNVpNXGi8gosWur27bxR2DejPbPvqMjGTaZGh80cLVAYQ8ZMXM7adglHD0hqKrdBLMdwM0huFD4d8ig22r59Kzt7JFbVGXF
 OvYaEI3T
 EA+9PxzlheUZKZ/lmZrzHbPA25pBAI9ttSUrKjY7vv/OUQ+yLfoW/Xkg5WFtVtnbEjmCnB/Xwz6kvLqi919U0U29d0nO16yi5EDzC7VE6OkD6J43ft5ITtNxrtxOJocmNm69h9zpa1OdWweB/sgMQT9FxAPuhGX+0pncXRX4ZTT8lgl5SX0+eeCWm5WrQ0rff2z02gii//o3XBokvdP2805ZHrA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/09/2025 16:32, Yang Shi wrote:
> 
> 
> On 9/9/25 7:36 AM, Ryan Roberts wrote:
>> On 08/09/2025 19:31, Yang Shi wrote:
>>>
>>> On 9/8/25 9:34 AM, Ryan Roberts wrote:
>>>> On 04/09/2025 22:49, Yang Shi wrote:
>>>>> On 9/4/25 10:47 AM, Yang Shi wrote:
>>>>>> On 9/4/25 6:16 AM, Ryan Roberts wrote:
>>>>>>> On 04/09/2025 14:14, Ryan Roberts wrote:
>>>>>>>> On 03/09/2025 01:50, Yang Shi wrote:
>>>>>>>>>>>> I am wondering whether we can just have a warn_on_once or something
>>>>>>>>>>>> for the
>>>>>>>>>>>> case
>>>>>>>>>>>> when we fail to allocate a pagetable page. Or, Ryan had
>>>>>>>>>>>> suggested in an off-the-list conversation that we can maintain a cache
>>>>>>>>>>>> of PTE
>>>>>>>>>>>> tables for every PMD block mapping, which will give us
>>>>>>>>>>>> the same memory consumption as we do today, but not sure if this is
>>>>>>>>>>>> worth it.
>>>>>>>>>>>> x86 can already handle splitting but due to the callchains
>>>>>>>>>>>> I have described above, it has the same problem, and the code has been
>>>>>>>>>>>> working
>>>>>>>>>>>> for years :)
>>>>>>>>>>> I think it's preferable to avoid having to keep a cache of pgtable
>>>>>>>>>>> memory
>>>>>>>>>>> if we
>>>>>>>>>>> can...
>>>>>>>>>> Yes, I agree. We simply don't know how many pages we need to cache,
>>>>>>>>>> and it
>>>>>>>>>> still can't guarantee 100% allocation success.
>>>>>>>>> This is wrong... We can know how many pages will be needed for splitting
>>>>>>>>> linear
>>>>>>>>> mapping to PTEs for the worst case once linear mapping is finalized.
>>>>>>>>> But it
>>>>>>>>> may
>>>>>>>>> require a few hundred megabytes memory to guarantee allocation success. I
>>>>>>>>> don't
>>>>>>>>> think it is worth for such rare corner case.
>>>>>>>> Indeed, we know exactly how much memory we need for pgtables to map the
>>>>>>>> linear
>>>>>>>> map by pte - that's exactly what we are doing today. So we _could_ keep a
>>>>>>>> cache.
>>>>>>>> We would still get the benefit of improved performance but we would lose
>>>>>>>> the
>>>>>>>> benefit of reduced memory.
>>>>>>>>
>>>>>>>> I think we need to solve the vm_reset_perms() problem somehow, before we
>>>>>>>> can
>>>>>>>> enable this.
>>>>>>> Sorry I realise this was not very clear... I am saying I think we need to
>>>>>>> fix it
>>>>>>> somehow. A cache would likely work. But I'd prefer to avoid it if we can
>>>>>>> find a
>>>>>>> better solution.
>>>>>> Took a deeper look at vm_reset_perms(). It was introduced by commit
>>>>>> 868b104d7379 ("mm/vmalloc: Add flag for freeing of special permsissions").
>>>>>> The
>>>>>> VM_FLUSH_RESET_PERMS flag is supposed to be set if the vmalloc memory is RO
>>>>>> and/or ROX. So set_memory_ro() or set_memory_rox() is supposed to follow up
>>>>>> vmalloc(). So the page table should be already split before reaching vfree().
>>>>>> I think this why vm_reset_perms() doesn't not check return value.
>>>> If vm_reset_perms() is assuming it can't/won't fail, I think it should at least
>>>> output a warning if it does?
>>> It should. Anyway warning will be raised if split fails. We have somehow
>>> mitigation.
>>>
>>>>>> I scrutinized all the callsites with VM_FLUSH_RESET_PERMS flag set.
>>>> Just checking; I think you made a comment before about there only being a few
>>>> sites that set VM_FLUSH_RESET_PERMS. But one of them is the helper,
>>>> set_vm_flush_reset_perms(). So just making sure you also followed to the places
>>>> that use that helper?
>>> Yes, I did.
>>>
>>>>>> The most
>>>>>> of them has set_memory_ro() or set_memory_rox() followed.
>>>> And are all callsites calling set_memory_*() for the entire cell that was
>>>> allocated by vmalloc? If there are cases where it only calls that for a portion
>>>> of it, then it's not gurranteed that the memory is correctly split.
>>> Yes, all callsites call set_memory_*() for the entire range.
>>>
>>>>>> But there are 3
>>>>>> places I don't see set_memory_ro()/set_memory_rox() is called.
>>>>>>
>>>>>> 1. BPF trampoline allocation. The BPF trampoline calls
>>>>>> arch_protect_bpf_trampoline(). The generic implementation does call
>>>>>> set_memory_rox(). But the x86 and arm64 implementation just simply return 0.
>>>>>> For x86, it is because execmem cache is used and it does call
>>>>>> set_memory_rox(). ARM64 doesn't need to split page table before this series,
>>>>>> so it should never fail. I think we just need to use the generic
>>>>>> implementation (remove arm64 implementation) if this series is merged.
>>>> I know zero about BPF. But it looks like the allocation happens in
>>>> arch_alloc_bpf_trampoline(), which for arm64, calls bpf_prog_pack_alloc(). And
>>>> for small sizes, it grabs some memory from a "pack". So doesn't this mean that
>>>> you are calling set_memory_rox() for a sub-region of the cell, so that doesn't
>>>> actually help at vm_reset_perms()-time?
>>> Took a deeper look at bpf pack allocator. The "pack" is allocated by
>>> alloc_new_pack(), which does:
>>> bpf_jit_alloc_exec()
>>> set_vm_flush_reset_perms()
>>> set_memory_rox()
>>>
>>> If the size is greater than the pack size, it calls:
>>> bpf_jit_alloc_exec()
>>> set_vm_flush_reset_perms()
>>> set_memory_rox()
>>>
>>> So it looks like bpf trampoline is good, and we don't need do anything. It
>>> should be removed from the list. I didn't look deep enough for bpf pack
>>> allocator in the first place.
>>>
>>>>>> 2. BPF dispatcher. It calls execmem_alloc which has VM_FLUSH_RESET_PERMS set.
>>>>>> But it is used for rw allocation, so VM_FLUSH_RESET_PERMS should be
>>>>>> unnecessary IIUC. So it doesn't matter even though vm_reset_perms() fails.
>>>>>>
>>>>>> 3. kprobe. S390's alloc_insn_page() does call set_memory_rox(), x86 also
>>>>>> called set_memory_rox() before switching to execmem cache. The execmem cache
>>>>>> calls set_memory_rox(). I don't know why ARM64 doesn't call it.
>>>>>>
>>>>>> So I think we just need to fix #1 and #3 per the above analysis. If this
>>>>>> analysis look correct to you guys, I will prepare two patches to fix them.
>>>> This all seems quite fragile. I find it interesting that vm_reset_perms() is
>>>> doing break-before-make; it sets the PTEs as invalid, then flushes the TLB,
>>>> then
>>>> sets them to default. But for arm64, at least, I think break-before-make is not
>>>> required. We are only changing the permissions so that can be done on live
>>>> mappings; essentially change the sequence to; set default, flush TLB.
>>> Yeah, I agree it is a little bit fragile. I think this is the "contract" for
>>> vmalloc users. You allocate ROX memory via vmalloc, you are required to call
>>> set_memory_*(). But there is nothing to guarantee the "contract" is followed.
>>> But I don't think this is the only case in kernel.
>>>
>>>> If we do that, then if the memory was already default, then there is no need to
>>>> do anything (so no chance of allocation failure). If the memory was not
>>>> default,
>>>> then it must have already been split to make it non-default, in which case we
>>>> can also gurrantee that no allocations are required.
>>>>
>>>> What am I missing?
>>> The comment says:
>>> Set direct map to something invalid so that it won't be cached if there are any
>>> accesses after the TLB flush, then flush the TLB and reset the direct map
>>> permissions to the default.
>>>
>>> IIUC, it guarantees the direct map can't be cached in TLB after TLB flush from
>>> _vm_unmap_aliases() by setting them invalid because TLB never cache invalid
>>> entries. Skipping set direct map to invalid seems break this. Or "changing
>>> permission on live mappings" on ARM64 can achieve the same goal?
>> Here's my understanding of the intent of the code:
>>
>> Let's say we start with some memory that has been mapped RO. Our goal is to
>> reset the memory back to RW and ensure that no TLB entry remains in the TLB for
>> the old RO mapping. There are 2 ways to do that:
> 
> 
> 
>>
>> Approach 1 (used in current code):
>> 1. set PTE to invalid
>> 2. invalidate any TLB entry for the VA
>> 3. set the PTE to RW
>>
>> Approach 2:
>> 1. set the PTE to RW
>> 2. invalidate any TLB entry for the VA
> 
> IIUC, the intent of the code is "reset direct map permission *without* leaving a
> RW+X window". The TLB flush call actually flushes both VA and direct map together.
> So if this is the intent, approach #2 may have VA with X permission but direct
> map may be RW at the mean time. It seems break the intent.

Ahh! Thanks, it's starting to make more sense now.

Though on first sight it seems a bit mad to me to form a tlb flush range that
covers all the direct map pages and all the lazy vunmap regions. Is that
intended to be a perf optimization or something else? It's not clear from the
history.


Could this be split into 2 operations?

1. unmap the aliases (+ tlbi the aliases).
2. set the direct memory back to default (+ tlbi the direct map region).

The only 2 potential problems I can think of are;

 - Performance: 2 tlbis instead of 1, but conversely we probably avoid flushing
a load of TLB entries that we didn't really need to.

 - Given there is now no lock around the tlbis (currently it's under
vmap_purge_lock) is there a race where a new alias can appear between steps 1
and 2? I don't think so, because the memory is allocated to the current mapping
so how is it going to get re-mapped?


Could this solve it?



> 
> Thanks,
> Yang
> 
>>
>> The benefit of approach 1 is that it is guarranteed that it is impossible for
>> different CPUs to have different translations for the same VA in their
>> respective TLB. But for approach 2, it's possible that between steps 1 and 2, 1
>> CPU has a RO entry and another CPU has a RW entry. But that will get fixed once
>> the TLB is flushed - it's not really an issue.
>>
>> (There is probably also an obscure way to end up with 2 TLB entries (one with RO
>> and one with RW) for the same CPU, but the arm64 architecture permits that as
>> long as it's only a permission mismatch).
>>
>> Anyway, approach 2 is used when changing memory permissions on user mappings, so
>> I don't see why we can't take the same approach here. That would solve this
>> whole class of issue for us.
>>
>> Thanks,
>> Ryan
>>
>>
>>> Thanks,
>>> Yang
>>>
>>>> Thanks,
>>>> Ryan
>>>>
>>>>
>>>>> Tested the below patch with bpftrace kfunc (allocate bpf trampoline) and
>>>>> kprobes. It seems work well.
>>>>>
>>>>> diff --git a/arch/arm64/kernel/probes/kprobes.c b/arch/arm64/kernel/probes/
>>>>> kprobes.c
>>>>> index 0c5d408afd95..c4f8c4750f1e 100644
>>>>> --- a/arch/arm64/kernel/probes/kprobes.c
>>>>> +++ b/arch/arm64/kernel/probes/kprobes.c
>>>>> @@ -10,6 +10,7 @@
>>>>>
>>>>>    #define pr_fmt(fmt) "kprobes: " fmt
>>>>>
>>>>> +#include <linux/execmem.h>
>>>>>    #include <linux/extable.h>
>>>>>    #include <linux/kasan.h>
>>>>>    #include <linux/kernel.h>
>>>>> @@ -41,6 +42,17 @@ DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
>>>>>    static void __kprobes
>>>>>    post_kprobe_handler(struct kprobe *, struct kprobe_ctlblk *, struct pt_regs
>>>>> *);
>>>>>
>>>>> +void *alloc_insn_page(void)
>>>>> +{
>>>>> +       void *page;
>>>>> +
>>>>> +       page = execmem_alloc(EXECMEM_KPROBES, PAGE_SIZE);
>>>>> +       if (!page)
>>>>> +               return NULL;
>>>>> +       set_memory_rox((unsigned long)page, 1);
>>>>> +       return page;
>>>>> +}
>>>>> +
>>>>>    static void __kprobes arch_prepare_ss_slot(struct kprobe *p)
>>>>>    {
>>>>>           kprobe_opcode_t *addr = p->ainsn.xol_insn;
>>>>> diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
>>>>> index 52ffe115a8c4..3e301bc2cd66 100644
>>>>> --- a/arch/arm64/net/bpf_jit_comp.c
>>>>> +++ b/arch/arm64/net/bpf_jit_comp.c
>>>>> @@ -2717,11 +2717,6 @@ void arch_free_bpf_trampoline(void *image, unsigned int
>>>>> size)
>>>>>           bpf_prog_pack_free(image, size);
>>>>>    }
>>>>>
>>>>> -int arch_protect_bpf_trampoline(void *image, unsigned int size)
>>>>> -{
>>>>> -       return 0;
>>>>> -}
>>>>> -
>>>>>    int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *ro_image,
>>>>>                                   void *ro_image_end, const struct
>>>>> btf_func_model *m,
>>>>>                                   u32 flags, struct bpf_tramp_links *tlinks,
>>>>>
>>>>>
>>>>>> Thanks,
>>>>>> Yang
>>>>>>
>>>>>>>> Thanks,
>>>>>>>> Ryan
>>>>>>>>
>>>>>>>>> Thanks,
>>>>>>>>> Yang
>>>>>>>>>
>>>>>>>>>> Thanks,
>>>>>>>>>> Yang
>>>>>>>>>>
>>>>>>>>>>> Thanks,
>>>>>>>>>>> Ryan
>>>>>>>>>>>
>>>>>>>>>>>
> 


