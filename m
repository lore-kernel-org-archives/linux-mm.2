Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 304AECA1016
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 16:34:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75A6F8E0005; Mon,  8 Sep 2025 12:34:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70A7B8E0001; Mon,  8 Sep 2025 12:34:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D26F8E0005; Mon,  8 Sep 2025 12:34:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4712E8E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 12:34:42 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DD5741187D1
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 16:34:41 +0000 (UTC)
X-FDA: 83866631562.06.C0D6EA0
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id A1DBF40006
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 16:34:39 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757349280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KRchr8pA8KC0RWN0Y1UtmU8dNv+O/thXnplqZUD9t1U=;
	b=BSJPBoxSMhG4KkPMEsm+sQ70zsjuJaovMU0bpfn9gIO6PXQmUkQsJ+Efkp4XlCw3raUXZg
	tauZJf/4SZAu8fW+sdZklGMYxptAlBzX+U2g5I0cFKdLte/eDtOerKHYjFANy06PVh3BOK
	PadslWlJ99Net42FdevI4oDEAqtAgqM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757349280; a=rsa-sha256;
	cv=none;
	b=lKtIQik2CE6qavnbd8yOd0Yk3GVM112SbEewaJok8OsU0JeS0AaXhRXdqIfC8j43TEcWoR
	CArXddEBMF1Me1fkwqSn/ItngibVFA4LTGnhOLpKsSYvhUM4lfqZarLR8hNund7pKcA7BF
	9N698hGEm5INb/hQ7BkE/obPc9fVrXs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 581001692;
	Mon,  8 Sep 2025 09:34:30 -0700 (PDT)
Received: from [10.57.91.39] (unknown [10.57.91.39])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5C9E13F694;
	Mon,  8 Sep 2025 09:34:36 -0700 (PDT)
Message-ID: <d7cd4004-bacf-47b0-9cd8-f99125e02238@arm.com>
Date: Mon, 8 Sep 2025 17:34:34 +0100
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
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <39c2f841-9043-448d-b644-ac96612d520a@os.amperecomputing.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: f8gi8pwp7ggwxwnb97z38e6648wmjt5s
X-Rspamd-Queue-Id: A1DBF40006
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757349279-850110
X-HE-Meta: U2FsdGVkX18+G0wNKBZWUpadM6GG+dhHQAKmMbJQSNiY9LyYeziweJkHIgW19sboS+vCf1e3QDEZ5JRpplDVI9hmjOYo76V/owE1Vwg2c3HMaoD1ulnORt7HVCPFUWp3qUmbfiAyacdI8cRDTs4XZHpQipCHXWrO10ZCFlqbuUD/9CXPOYvNcYNoE4C5dYU/sJffgR81ttkcwCyyQ0KiNksO/wps/Nt5qCUhoZcswcMORGggo58ygm2zbhA99qbwRZS/P7BgPzqrgPF5liyLeH3a5IHDn6YIXN79SjhKIt/jPjQv2Ff80GrVHwZorvISsoifGbIJXTjo2P53PQsIb8QCDPqCIjYuLFp/lfTkTuhpaPN5/2OZ5YJf1cRjl0+fp8cU1IAw8HDWSkvkykCIinXW4PBQULrzygDdTfObWhUfNcmKHK+DqbWD5kBE2so1hpxcVvX8g4dXJWPZ2Wlb7bJ4ikabwA3lJEXSkx2FzxS50PuDFLv8rCnNqcG4LTPGYL9fq9hcV/8ZZq7DCDSQsqIC8a9ADB1rmagxSKoJzsS3z0g6jSSlu59eouGno30fJHVEehtXtqek0cle16Zp+IoT3Ync7e3QwUJ/PD7RYsjOT36SlSnHilVdecZg5ShrdxkaSLREFofw97IONYS6BE9Vp0s4Vsd8Ew3rwYKWKz78zC5q+zFX/74WxBoxNl83P53/G2mSah6yqHC2223jryP9IvNLZkElHJvh5v1QwjtdeCRm1ZCZ0r1dO110+xfbZi+Bm6mY2yLkEbruh0CgN/NHg7LPCMxN+8zsU/LtYbhDUIhd+xSkBHc4q7UKG3DN8pF4rynGI260UI9bTXaLlOt3KEb+oqkwpE2iUP4jMnVP+1/Zm2baM3QCyIfRjfIIMvquAfOxEWoS4vQsqDbpvixd5T41oDbIaE6L174y+QmlsBTPHw3Sx1/H5NpdhZy0gIs3CfuYyfBSzF0W6h4
 oXp+FAOr
 ZWaVx5gC1M2jR8uxhDGzUn12x6tgWkyNJtyEGN8NsIoIdXesDg2uie/jtj1UcRMLPQkP/INEzdQfugr19hZ2E/9TroOyVt8/JCxrxLwQ/G2ipKFWBl4FFzmqbEAxPORPpBbvsOsJAVhZ4uRqCST5ps77YZXt0CoCfH0cL6m1+SuJnjJ7v8TIDiODUwGmmZyUlSPg8p3klLx/h/G/IPfTbYPus0w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04/09/2025 22:49, Yang Shi wrote:
> 
> 
> On 9/4/25 10:47 AM, Yang Shi wrote:
>>
>>
>> On 9/4/25 6:16 AM, Ryan Roberts wrote:
>>> On 04/09/2025 14:14, Ryan Roberts wrote:
>>>> On 03/09/2025 01:50, Yang Shi wrote:
>>>>>>>>
>>>>>>>> I am wondering whether we can just have a warn_on_once or something for the
>>>>>>>> case
>>>>>>>> when we fail to allocate a pagetable page. Or, Ryan had
>>>>>>>> suggested in an off-the-list conversation that we can maintain a cache
>>>>>>>> of PTE
>>>>>>>> tables for every PMD block mapping, which will give us
>>>>>>>> the same memory consumption as we do today, but not sure if this is
>>>>>>>> worth it.
>>>>>>>> x86 can already handle splitting but due to the callchains
>>>>>>>> I have described above, it has the same problem, and the code has been
>>>>>>>> working
>>>>>>>> for years :)
>>>>>>> I think it's preferable to avoid having to keep a cache of pgtable memory
>>>>>>> if we
>>>>>>> can...
>>>>>> Yes, I agree. We simply don't know how many pages we need to cache, and it
>>>>>> still can't guarantee 100% allocation success.
>>>>> This is wrong... We can know how many pages will be needed for splitting
>>>>> linear
>>>>> mapping to PTEs for the worst case once linear mapping is finalized. But it
>>>>> may
>>>>> require a few hundred megabytes memory to guarantee allocation success. I
>>>>> don't
>>>>> think it is worth for such rare corner case.
>>>> Indeed, we know exactly how much memory we need for pgtables to map the linear
>>>> map by pte - that's exactly what we are doing today. So we _could_ keep a
>>>> cache.
>>>> We would still get the benefit of improved performance but we would lose the
>>>> benefit of reduced memory.
>>>>
>>>> I think we need to solve the vm_reset_perms() problem somehow, before we can
>>>> enable this.
>>> Sorry I realise this was not very clear... I am saying I think we need to fix it
>>> somehow. A cache would likely work. But I'd prefer to avoid it if we can find a
>>> better solution.
>>
>> Took a deeper look at vm_reset_perms(). It was introduced by commit
>> 868b104d7379 ("mm/vmalloc: Add flag for freeing of special permsissions"). The
>> VM_FLUSH_RESET_PERMS flag is supposed to be set if the vmalloc memory is RO
>> and/or ROX. So set_memory_ro() or set_memory_rox() is supposed to follow up
>> vmalloc(). So the page table should be already split before reaching vfree().
>> I think this why vm_reset_perms() doesn't not check return value.

If vm_reset_perms() is assuming it can't/won't fail, I think it should at least
output a warning if it does?

>>
>> I scrutinized all the callsites with VM_FLUSH_RESET_PERMS flag set. 

Just checking; I think you made a comment before about there only being a few
sites that set VM_FLUSH_RESET_PERMS. But one of them is the helper,
set_vm_flush_reset_perms(). So just making sure you also followed to the places
that use that helper?

>> The most
>> of them has set_memory_ro() or set_memory_rox() followed. 

And are all callsites calling set_memory_*() for the entire cell that was
allocated by vmalloc? If there are cases where it only calls that for a portion
of it, then it's not gurranteed that the memory is correctly split.

>> But there are 3
>> places I don't see set_memory_ro()/set_memory_rox() is called.
>>
>> 1. BPF trampoline allocation. The BPF trampoline calls
>> arch_protect_bpf_trampoline(). The generic implementation does call
>> set_memory_rox(). But the x86 and arm64 implementation just simply return 0.
>> For x86, it is because execmem cache is used and it does call
>> set_memory_rox(). ARM64 doesn't need to split page table before this series,
>> so it should never fail. I think we just need to use the generic
>> implementation (remove arm64 implementation) if this series is merged.

I know zero about BPF. But it looks like the allocation happens in
arch_alloc_bpf_trampoline(), which for arm64, calls bpf_prog_pack_alloc(). And
for small sizes, it grabs some memory from a "pack". So doesn't this mean that
you are calling set_memory_rox() for a sub-region of the cell, so that doesn't
actually help at vm_reset_perms()-time?

>>
>> 2. BPF dispatcher. It calls execmem_alloc which has VM_FLUSH_RESET_PERMS set.
>> But it is used for rw allocation, so VM_FLUSH_RESET_PERMS should be
>> unnecessary IIUC. So it doesn't matter even though vm_reset_perms() fails.
>>
>> 3. kprobe. S390's alloc_insn_page() does call set_memory_rox(), x86 also
>> called set_memory_rox() before switching to execmem cache. The execmem cache
>> calls set_memory_rox(). I don't know why ARM64 doesn't call it.
>>
>> So I think we just need to fix #1 and #3 per the above analysis. If this
>> analysis look correct to you guys, I will prepare two patches to fix them.

This all seems quite fragile. I find it interesting that vm_reset_perms() is
doing break-before-make; it sets the PTEs as invalid, then flushes the TLB, then
sets them to default. But for arm64, at least, I think break-before-make is not
required. We are only changing the permissions so that can be done on live
mappings; essentially change the sequence to; set default, flush TLB.

If we do that, then if the memory was already default, then there is no need to
do anything (so no chance of allocation failure). If the memory was not default,
then it must have already been split to make it non-default, in which case we
can also gurrantee that no allocations are required.

What am I missing?

Thanks,
Ryan


> 
> Tested the below patch with bpftrace kfunc (allocate bpf trampoline) and
> kprobes. It seems work well.
> 
> diff --git a/arch/arm64/kernel/probes/kprobes.c b/arch/arm64/kernel/probes/
> kprobes.c
> index 0c5d408afd95..c4f8c4750f1e 100644
> --- a/arch/arm64/kernel/probes/kprobes.c
> +++ b/arch/arm64/kernel/probes/kprobes.c
> @@ -10,6 +10,7 @@
> 
>  #define pr_fmt(fmt) "kprobes: " fmt
> 
> +#include <linux/execmem.h>
>  #include <linux/extable.h>
>  #include <linux/kasan.h>
>  #include <linux/kernel.h>
> @@ -41,6 +42,17 @@ DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
>  static void __kprobes
>  post_kprobe_handler(struct kprobe *, struct kprobe_ctlblk *, struct pt_regs *);
> 
> +void *alloc_insn_page(void)
> +{
> +       void *page;
> +
> +       page = execmem_alloc(EXECMEM_KPROBES, PAGE_SIZE);
> +       if (!page)
> +               return NULL;
> +       set_memory_rox((unsigned long)page, 1);
> +       return page;
> +}
> +
>  static void __kprobes arch_prepare_ss_slot(struct kprobe *p)
>  {
>         kprobe_opcode_t *addr = p->ainsn.xol_insn;
> diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
> index 52ffe115a8c4..3e301bc2cd66 100644
> --- a/arch/arm64/net/bpf_jit_comp.c
> +++ b/arch/arm64/net/bpf_jit_comp.c
> @@ -2717,11 +2717,6 @@ void arch_free_bpf_trampoline(void *image, unsigned int
> size)
>         bpf_prog_pack_free(image, size);
>  }
> 
> -int arch_protect_bpf_trampoline(void *image, unsigned int size)
> -{
> -       return 0;
> -}
> -
>  int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *ro_image,
>                                 void *ro_image_end, const struct btf_func_model *m,
>                                 u32 flags, struct bpf_tramp_links *tlinks,
> 
> 
>>
>> Thanks,
>> Yang
>>
>>>
>>>
>>>> Thanks,
>>>> Ryan
>>>>
>>>>> Thanks,
>>>>> Yang
>>>>>
>>>>>> Thanks,
>>>>>> Yang
>>>>>>
>>>>>>> Thanks,
>>>>>>> Ryan
>>>>>>>
>>>>>>>
>>
> 


