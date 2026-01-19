Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39BBAD4A5EB
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 03:51:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 863156B0100; Sun, 18 Jan 2026 22:51:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83A376B0101; Sun, 18 Jan 2026 22:51:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 739076B0102; Sun, 18 Jan 2026 22:51:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5FE4D6B0100
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 22:51:01 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 07FF88C1EA
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 03:51:01 +0000 (UTC)
X-FDA: 84347337522.20.FCC54DA
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2AB10100003
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 03:50:58 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hbybdNAt;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768794659; a=rsa-sha256;
	cv=none;
	b=Q4PpjjRZ7cN7f3BosFtKA9hto7pfAC4/hqKnrFXolHAkeMtPH8rrxzfovzhnQUgvrETyfl
	xuSwbf9DGXmUXffelaQ4OFsVb3v4SHJPR6I/Naf1Vg8QWsrhNGoDsdAJPMeIyBhut5w5F9
	jo+QTZrcENTsVTGzGotvedNJjbBYa34=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hbybdNAt;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768794659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OndFxxnVxJHEWV1Ai4YOkM1DVjpvrsGTOMshAUDXrrs=;
	b=oqH/4bjZ2pkrS/xBUHQbLjFed5dcpY9VDhGMUJmtoF4KvMuhOZdxpcNhG5+MvO4em9db1R
	VOfNw/OslMFwvF3RRO4XOOnx6iXIKiv7k9qMbdeN4J9KXyQs8AbZKuSfE3eExnFIDK5DDE
	SnYEit6sGODQcHZ9NHuxzSnSlPRVgAw=
Message-ID: <24837e0e-db86-4c64-8387-243d94293b48@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768794657;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OndFxxnVxJHEWV1Ai4YOkM1DVjpvrsGTOMshAUDXrrs=;
	b=hbybdNAt06yK3Ue9qz5tUkDDtYUIVbamganh0hpEQCf75muj99rryT85wDoTAZTEInAmI5
	CHKqFtiG0pmhZ4aoDnrB9Eu3Rco9srP+y1Jcl1/m2NZZcWV/LkYhvfkXb6L7LloimZT5zp
	byPLsUVK3GIoTWY1pccENgzenQny59E=
Date: Mon, 19 Jan 2026 11:50:41 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 7/7] mm: make PT_RECLAIM depends on
 MMU_GATHER_RCU_TABLE_FREE
To: "David Hildenbrand (Red Hat)" <david@kernel.org>, will@kernel.org,
 aneesh.kumar@kernel.org, npiggin@gmail.com, peterz@infradead.org,
 dev.jain@arm.com, akpm@linux-foundation.org, ioworker0@gmail.com,
 linmag7@gmail.com
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-alpha@vger.kernel.org, loongarch@lists.linux.dev,
 linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
 linux-um@lists.infradead.org, Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1765963770.git.zhengqi.arch@bytedance.com>
 <ac2bdb2a66da1edb24f60d1da1099e2a0b734880.1765963770.git.zhengqi.arch@bytedance.com>
 <bef9fc2c-c982-4b46-b16a-8ecbc9584d62@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <bef9fc2c-c982-4b46-b16a-8ecbc9584d62@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2AB10100003
X-Stat-Signature: s86q1jr5cgttzsxqgjcn4ymja4ikq54c
X-Rspam-User: 
X-HE-Tag: 1768794658-174269
X-HE-Meta: U2FsdGVkX1/8PWEshrwqYqZuyGievsTg9zrEXnSFHnPln80SJLZlZbx7qCuwdCKK/PxyFB7fkvr6HtGJgrrcYIBz5Rkf6hs2jAv1H1u6JtKAMJIUC5yjS1qg8qWJGf4bQUXpvFtYjPJ+Cz4Z5twBButTzjco6ilfPcLuyHuS1GMGEQQlZleNUAl3xxe9t957GMmzmQzIoWMjWDjXfi+qxwSv1N6nMalCjfXY+vsq2eY5cf+wIv1PmnrjCTU8g9J3f0R5f3gzx4l7IFkPso76OfkF0llVh7i1UBp3nAifIMFhMEIAKNGFcxA3ykhLBIpbiHtWzRHl7gRRnfW5IUyByQukaJDV14yn/ZZ3HZ5c3uy7ZOSTzeEm/GkrnJJrIZONDVbJgxhAKmCTnMvNrwGu8x6XrYNqMMeByy54aFBmHhw+Q4O6ZHiWFIrur9y+U7z9Er8bPHf08eeMDa8yozDx5gSUtX06CNK5juEowVHsSOF6Ib1Wr3yOFRzcAjHZCv14rKwhb6iNAEVPoPYkEgyctFLzfyv21ucO/bw+Xrqv3ktkuuTBD7oh/1gi74ndwoOPPcAU59L7jVow9It5kABRSncHCOxdISr6ka8saL2SWpTTFJOmCvtA9ZhvGgkwrcoSkr+qgcZ+lLaVl73kcIOC6+B4RQnIyx1RbJeBe7p06R6MFhbamTKuHU+Gy1FDckQv7sKIvsKx1SnuoOtkQ266ErzT2Znfpyu95h1L4f42d6E3MeToWfIHWEHa/PhorhxUzSw+ByI6UttQ6Ou6PFQdmFYT9pLgckYpRg7S7tP2KeTeo/UAMA6YsEH+QmUY10ex4rhkJF/AFwjwSGu3x3Hk6C6A+xUktY+gkaA/b4AFn/WrsgGeHaFSPbX2pL1u+YB3YA3+0D4wzKJdPfBiarMNyYM1BndpHIJd10YNPK+fBE2DaMjZKRTyix3ESO9puAoU0VXqBGzihhJSGDT+B8/
 5NelP7Qa
 JVijr/cqxYnbfvT2iaiMyN7A+WDfqgerFxKiLFnVTMB1dndzYyTDukTIkfB6OknyqsIkdDqaV5lRRTtSqTNUuGJh+J0IdgqQapdiCVQg/jQ92UQNpkvU9Ht0RS+qTdRRkiLqNU5l99AO9nIraV1wnxLN3HoVxCZeBO9CuwDL4itimFtXUKUERojk4h2nrORt5OByR3gOH47OjpCI+wVw/dj2x8wGFj3fyTloPMgRmThgRvWiSQSSajqn1TEuXiSUvWFsNzU/3sEqQ7oRnOKJnTEWC7Cpa9LVRgD3IMv6z4B0ZWsC+uAzNGaVvQzkf4gHDcfPl4PRnZxtU62Rf8Q7EaIJAfDtxTmuZV72IOJ1PurfeBt6Ol+om1pIJm1GCLIqqtRGQVfq+TTA2D1cEUVbBt7O9W9AFZ8F91D3f
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/18/26 7:23 PM, David Hildenbrand (Red Hat) wrote:
> On 12/17/25 10:45, Qi Zheng wrote:
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>
>> The PT_RECLAIM can work on all architectures that support
>> MMU_GATHER_RCU_TABLE_FREE, so make PT_RECLAIM depends on
>> MMU_GATHER_RCU_TABLE_FREE.
>>
>> BTW, change PT_RECLAIM to be enabled by default, since nobody should want
>> to turn it off.
>>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> ---
>>   arch/x86/Kconfig | 1 -
>>   mm/Kconfig       | 9 ++-------
>>   2 files changed, 2 insertions(+), 8 deletions(-)
>>
>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>> index 80527299f859a..0d22da56a71b0 100644
>> --- a/arch/x86/Kconfig
>> +++ b/arch/x86/Kconfig
>> @@ -331,7 +331,6 @@ config X86
>>       select FUNCTION_ALIGNMENT_4B
>>       imply IMA_SECURE_AND_OR_TRUSTED_BOOT    if EFI
>>       select HAVE_DYNAMIC_FTRACE_NO_PATCHABLE
>> -    select ARCH_SUPPORTS_PT_RECLAIM        if X86_64
>>       select ARCH_SUPPORTS_SCHED_SMT        if SMP
>>       select SCHED_SMT            if SMP
>>       select ARCH_SUPPORTS_SCHED_CLUSTER    if SMP
>> diff --git a/mm/Kconfig b/mm/Kconfig
>> index bd0ea5454af82..fc00b429b7129 100644
>> --- a/mm/Kconfig
>> +++ b/mm/Kconfig
>> @@ -1447,14 +1447,9 @@ config ARCH_HAS_USER_SHADOW_STACK
>>         The architecture has hardware support for userspace shadow call
>>             stacks (eg, x86 CET, arm64 GCS or RISC-V Zicfiss).
>> -config ARCH_SUPPORTS_PT_RECLAIM
>> -    def_bool n
>> -
>>   config PT_RECLAIM
>> -    bool "reclaim empty user page table pages"
>> -    default y
>> -    depends on ARCH_SUPPORTS_PT_RECLAIM && MMU && SMP
>> -    select MMU_GATHER_RCU_TABLE_FREE
>> +    def_bool y
>> +    depends on MMU_GATHER_RCU_TABLE_FREE
>>       help
>>         Try to reclaim empty user page table pages in paths other than 
>> munmap
>>         and exit_mmap path.
> 
> This patch seems to make s390x compilations sometimes unhappy:
> 
> Unverified Warning (likely false positive, kindly check if interested):

I believe it is a false positive.

> 
>      mm/memory.c:1911 zap_pte_range() error: uninitialized symbol 'pmdval'.
> 
> Warning ids grouped by kconfigs:
> 
> recent_errors
> `-- s390-randconfig-r072-20260117
>      `-- mm-memory.c-zap_pte_range()-error:uninitialized-symbol-pmdval-.
> 
> I assume the compiler is not able to figure out that only when
> try_get_and_clear_pmd() returns false that pmdval could be uninitialized.
> 
> Maybe it has to do with LTO?
> 
> 
> After all, that function resides in a different compilation unit.
> 
> Which makes me wonder whether we want to just move try_get_and_clear_pmd()
> and reclaim_pt_is_enabled() to internal.h or even just memory.c?
> 
> But then, maybe we could remove pt_reclaim.c completely and just have
> try_to_free_pte() in memory.c as well?
> 
> 
> I would just do the following cleanup:
> 
>  From cfe97092f71fcc88f729f07ee0bc6816e3e398f0 Mon Sep 17 00:00:00 2001
> From: "David Hildenbrand (Red Hat)" <david@kernel.org>
> Date: Sun, 18 Jan 2026 12:20:55 +0100
> Subject: [PATCH] mm: move pte table reclaim code to memory.c
> 
> Let's move the code and clean it up a bit along the way.
> 
> Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
> ---
>   MAINTAINERS     |  1 -
>   mm/internal.h   | 18 -------------
>   mm/memory.c     | 70 ++++++++++++++++++++++++++++++++++++++++++-----
>   mm/pt_reclaim.c | 72 -------------------------------------------------
>   4 files changed, 64 insertions(+), 97 deletions(-)
>   delete mode 100644 mm/pt_reclaim.c

Make sense, and LGTM. The reason it was placed in mm/pt_reclaim.c before
was because there would be other paths calling these functions in the
future. However, it can be separated out or put into a header file when
there are actually such callers.

would you be willing to send out an official patch?

Thanks,
Qi

> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 11720728d92f2..28e8e28bca3e5 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16692,7 +16692,6 @@ R:    Shakeel Butt <shakeel.butt@linux.dev>
>   R:    Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>   L:    linux-mm@kvack.org
>   S:    Maintained
> -F:    mm/pt_reclaim.c
>   F:    mm/vmscan.c
>   F:    mm/workingset.c
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index 9508dbaf47cd4..ef71a1d9991f2 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1745,24 +1745,6 @@ int walk_page_range_debug(struct mm_struct *mm, 
> unsigned long start,
>                 unsigned long end, const struct mm_walk_ops *ops,
>                 pgd_t *pgd, void *private);
> 
> -/* pt_reclaim.c */
> -bool try_get_and_clear_pmd(struct mm_struct *mm, pmd_t *pmd, pmd_t 
> *pmdval);
> -void free_pte(struct mm_struct *mm, unsigned long addr, struct 
> mmu_gather *tlb,
> -          pmd_t pmdval);
> -void try_to_free_pte(struct mm_struct *mm, pmd_t *pmd, unsigned long addr,
> -             struct mmu_gather *tlb);
> -
> -#ifdef CONFIG_PT_RECLAIM
> -bool reclaim_pt_is_enabled(unsigned long start, unsigned long end,
> -               struct zap_details *details);
> -#else
> -static inline bool reclaim_pt_is_enabled(unsigned long start, unsigned 
> long end,
> -                     struct zap_details *details)
> -{
> -    return false;
> -}
> -#endif /* CONFIG_PT_RECLAIM */
> -
>   void dup_mm_exe_file(struct mm_struct *mm, struct mm_struct *oldmm);
>   int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm);
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index f2e9e05388743..a09226761a07f 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -1824,11 +1824,68 @@ static inline int do_zap_pte_range(struct 
> mmu_gather *tlb,
>       return nr;
>   }
> 
> +static bool pte_table_reclaim_enabled(unsigned long start, unsigned 
> long end,
> +        struct zap_details *details)
> +{
> +    if (!IS_ENABLED(CONFIG_PT_RECLAIM))
> +        return false;
> +    return details && details->reclaim_pt && (end - start >= PMD_SIZE);
> +}
> +
> +static bool zap_empty_pte_table(struct mm_struct *mm, pmd_t *pmd, pmd_t 
> *pmdval)
> +{
> +    spinlock_t *pml = pmd_lockptr(mm, pmd);
> +
> +    if (!spin_trylock(pml))
> +        return false;
> +
> +    *pmdval = pmdp_get_lockless(pmd);
> +    pmd_clear(pmd);
> +    spin_unlock(pml);
> +
> +    return true;
> +}
> +
> +static bool zap_pte_table_if_empty(struct mm_struct *mm, pmd_t *pmd,
> +        unsigned long addr, pmd_t *pmdval)
> +{
> +    spinlock_t *pml, *ptl = NULL;
> +    pte_t *start_pte, *pte;
> +    int i;
> +
> +    pml = pmd_lock(mm, pmd);
> +    start_pte = pte_offset_map_rw_nolock(mm, pmd, addr, pmdval, &ptl);
> +    if (!start_pte)
> +        goto out_ptl;
> +    if (ptl != pml)
> +        spin_lock_nested(ptl, SINGLE_DEPTH_NESTING);
> +
> +    for (i = 0, pte = start_pte; i < PTRS_PER_PTE; i++, pte++) {
> +        if (!pte_none(ptep_get(pte)))
> +            goto out_ptl;
> +    }
> +    pte_unmap(start_pte);
> +
> +    pmd_clear(pmd);
> +
> +    if (ptl != pml)
> +        spin_unlock(ptl);
> +    spin_unlock(pml);
> +    return true;
> +out_ptl:
> +    if (start_pte)
> +        pte_unmap_unlock(start_pte, ptl);
> +    if (ptl != pml)
> +        spin_unlock(pml);
> +    return false;
> +}
> +
>   static unsigned long zap_pte_range(struct mmu_gather *tlb,
>                   struct vm_area_struct *vma, pmd_t *pmd,
>                   unsigned long addr, unsigned long end,
>                   struct zap_details *details)
>   {
> +    bool can_reclaim_pt = pte_table_reclaim_enabled(addr, end, details);
>       bool force_flush = false, force_break = false;
>       struct mm_struct *mm = tlb->mm;
>       int rss[NR_MM_COUNTERS];
> @@ -1837,7 +1894,6 @@ static unsigned long zap_pte_range(struct 
> mmu_gather *tlb,
>       pte_t *pte;
>       pmd_t pmdval;
>       unsigned long start = addr;
> -    bool can_reclaim_pt = reclaim_pt_is_enabled(start, end, details);
>       bool direct_reclaim = true;
>       int nr;
> 
> @@ -1878,7 +1934,7 @@ static unsigned long zap_pte_range(struct 
> mmu_gather *tlb,
>        * from being repopulated by another thread.
>        */
>       if (can_reclaim_pt && direct_reclaim && addr == end)
> -        direct_reclaim = try_get_and_clear_pmd(mm, pmd, &pmdval);
> +        direct_reclaim = zap_empty_pte_table(mm, pmd, &pmdval);
> 
>       add_mm_rss_vec(mm, rss);
>       lazy_mmu_mode_disable();
> @@ -1907,10 +1963,12 @@ static unsigned long zap_pte_range(struct 
> mmu_gather *tlb,
>       }
> 
>       if (can_reclaim_pt) {
> -        if (direct_reclaim)
> -            free_pte(mm, start, tlb, pmdval);
> -        else
> -            try_to_free_pte(mm, pmd, start, tlb);
> +        if (!direct_reclaim)
> +            direct_reclaim = zap_pte_table_if_empty(mm, pmd, start, 
> &pmdval);
> +        if (direct_reclaim) {
> +            pte_free_tlb(tlb, pmd_pgtable(pmdval), addr);
> +            mm_dec_nr_ptes(mm);
> +        }
>       }
> 
>       return addr;
> diff --git a/mm/pt_reclaim.c b/mm/pt_reclaim.c
> deleted file mode 100644
> index 46771cfff8239..0000000000000
> --- a/mm/pt_reclaim.c
> +++ /dev/null
> @@ -1,72 +0,0 @@
> -// SPDX-License-Identifier: GPL-2.0
> -#include <linux/hugetlb.h>
> -#include <linux/pgalloc.h>
> -
> -#include <asm/tlb.h>
> -
> -#include "internal.h"
> -
> -bool reclaim_pt_is_enabled(unsigned long start, unsigned long end,
> -               struct zap_details *details)
> -{
> -    return details && details->reclaim_pt && (end - start >= PMD_SIZE);
> -}
> -
> -bool try_get_and_clear_pmd(struct mm_struct *mm, pmd_t *pmd, pmd_t 
> *pmdval)
> -{
> -    spinlock_t *pml = pmd_lockptr(mm, pmd);
> -
> -    if (!spin_trylock(pml))
> -        return false;
> -
> -    *pmdval = pmdp_get_lockless(pmd);
> -    pmd_clear(pmd);
> -    spin_unlock(pml);
> -
> -    return true;
> -}
> -
> -void free_pte(struct mm_struct *mm, unsigned long addr, struct 
> mmu_gather *tlb,
> -          pmd_t pmdval)
> -{
> -    pte_free_tlb(tlb, pmd_pgtable(pmdval), addr);
> -    mm_dec_nr_ptes(mm);
> -}
> -
> -void try_to_free_pte(struct mm_struct *mm, pmd_t *pmd, unsigned long addr,
> -             struct mmu_gather *tlb)
> -{
> -    pmd_t pmdval;
> -    spinlock_t *pml, *ptl = NULL;
> -    pte_t *start_pte, *pte;
> -    int i;
> -
> -    pml = pmd_lock(mm, pmd);
> -    start_pte = pte_offset_map_rw_nolock(mm, pmd, addr, &pmdval, &ptl);
> -    if (!start_pte)
> -        goto out_ptl;
> -    if (ptl != pml)
> -        spin_lock_nested(ptl, SINGLE_DEPTH_NESTING);
> -
> -    /* Check if it is empty PTE page */
> -    for (i = 0, pte = start_pte; i < PTRS_PER_PTE; i++, pte++) {
> -        if (!pte_none(ptep_get(pte)))
> -            goto out_ptl;
> -    }
> -    pte_unmap(start_pte);
> -
> -    pmd_clear(pmd);
> -
> -    if (ptl != pml)
> -        spin_unlock(ptl);
> -    spin_unlock(pml);
> -
> -    free_pte(mm, addr, tlb, pmdval);
> -
> -    return;
> -out_ptl:
> -    if (start_pte)
> -        pte_unmap_unlock(start_pte, ptl);
> -    if (ptl != pml)
> -        spin_unlock(pml);
> -}


