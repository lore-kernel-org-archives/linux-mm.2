Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A721606A335
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 03:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=iDKrsO+B
Received: by kanga.kvack.org (Postfix)
	id 22AC26B05B1; Thu,  5 Nov 2026 22:03:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 201A76B05B2; Thu,  5 Nov 2026 22:03:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13EF56B05B3; Thu,  5 Nov 2026 22:03:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E0BC66B05B1
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 22:03:55 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0E1E140CEA
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 03:03:55 +0000 (UTC)
X-FDA: 85403199630.20.2E8BF91
Received: from mta0.migadu.com (out-138.mta0.migadu.com [91.218.175.138])
	by imf31.hostedemail.com (Postfix) with ESMTP id D248F2000A
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 03:03:52 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iDKrsO+B;
	spf=pass (imf31.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.138 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793934233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eeUY/7cJGXFEn20K8oROVcv/0XXhUdc/6BlusTj1DNU=;
	b=Ixo5ejYuhKrwiD2MMQdihZrTtPpPNZNh2ci6QmOphsE5+ziU4k9KMtkYQjhviV9Pf3XQCI
	VmcACNKtO8is+wODaXpNJpFPSRy7GcEH5RihE55JqV7pt6sM7PMC5VpiH0du9yvjhB3Zc1
	2+3ZiP5CHx2qzl9nD7PoBNOKTLQkdi4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793934233;
	b=pmFk0RN+nYd1UNLvXBDUXgh+T7X89JjRDVJyj5gDI9hrMfsKeUB6Vc3vP5th+gR1Ea4+tY
	GhVR30TeGy30oFBS+LshhuEs3EOsDzkqYsNy3ScdvHdj722wjskz9R//WTh37j2u8HxK73
	S6RTJxiWm3apjoYi4Ch7LDFZuJrVTAk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iDKrsO+B;
	spf=pass (imf31.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.138 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=jLiXUbWh0Cq3K7wdDXTxGIGTG12TPsew4PFOTwWSpWU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793934231; v=1; x=1794539031;
 b=iDKrsO+BXI5lRueVDL1VlGWh5PUtQvd5QPfMcXlcflU/tL2xOd8/J2XNEsJBpoNvINTzAXoK
 VNjQJmv+UDu8PSkTVvoYMfjtYO9fp1B8+yP5d8BnpKP6L+DPF/nsEH/sP5ajPM7dYrrEkS+Ry6Y
 a7b/G7AFrSME9IqNeTV/Og0g=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id b619772cf9920b08;
	Fri, 06 Nov 2026 03:03:51 +0000
X-Mizu-Trace-ID: b619772cf9920b08
X-Migadu-Flow: FLOW_OUT
Message-ID: <88a6bf17-2189-44a8-8255-50b7ee1d80f2@linux.dev>
Date: Fri, 6 Nov 2026 11:03:46 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Betterbird (macOS/Intel)
Subject: Re: [PATCH v4] mm/memory: use pmdp_get_lockless() for the pmd read in
 do_fault_around()
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
 Sam Creasey <sammy@sammy.net>
Cc: Hui Zhu <zhuhui@kylinos.cn>, stable+noautosel@kernel.org,
 linux-m68k@lists.linux-m68k.org
References: <20261104091050.117076-1-hui.zhu@linux.dev>
 <dec26f4a-138a-4cd7-b000-4bda7c61af82@kernel.org>
Content-Language: en-US
From: Hui Zhu <hui.zhu@linux.dev>
In-Reply-To: <dec26f4a-138a-4cd7-b000-4bda7c61af82@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 81n4ipnigchnp1z9qfzqywc9eqesjxbu
X-Rspamd-Queue-Id: D248F2000A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793934232-511569
X-HE-Meta: U2FsdGVkX19do9Yw6Nd4smqE5/lBctZmvhEf8ahSaoXFidLK1kR/7ov/qcmsrHM0GTNaTGW8jyBQvNZYGpz3RrhG3tupnbnvlZSZ5j0PPrD+mmxhr2QrOUu4wCDUZhU02Hjjj0ytbyjHNvB4zn+7hP0IIVVyKvL4hI0Rr0XrWK8Tt3eUwdI3e40vgxJL/mbTGWFVBrU+s6Vw0QZqVscjpM4aIfyNtDdQDLci/D2+6SGDB8kz8dRpBBrDNhXjHDs4xROSjGlyt0rGkjvKZjIWqgnDvN3BMYspqsUmZcymosSx6MkSC7urK6avusNN76UmcsYZmWCqaRjtIpU3wwuTC8Fdy3dbKIiUEe4BWRghZtFYnWI9Up0z+cid0dlWq7kmyMII+v5K8WK6IwHOQH+DG30HeB7Ymk5N8yzJu/YgZuCbLAfHacK6lUR1k6047O/qE2Lu1p/miqAQssxICLAdoBord2RG5Vnhfxfm4h5ijOP4adyGvVwdJnNe0Dq30sbUp53Q1Y4ODhjLd6Ce3OqJmPCeyyZBb+Hrx1zAqU+1C/bnsiDKC363iB5Pe/we3pdHbIXprgrpcTeUVhkeYan9E/e/fPPjLvS7d0lENYbQRrtDR8A2jjiivOukTG7C8hVbk7v/d+WeFDl6N38e5Aq7APgYOfuXVsVi/WDU8fs7fgpJFhhX2EH2olBGzYgEdTWJaFJfuEHLpG7D6egrAcfCBmIzfyUdzT98nuP92DyPptDacVll6uItEwIGVYM/sSGO3sSzve+WR5/5T45u5HRaAjAo48hyEteusr8f2fFk0+BDn9FomSSxJf5XFKvbKwelEEGIPn9WI1pVujlGYd0j0WQ814bN1bSPFO60ia4LixlBEmbCYiWRIfpjigFuM+RoDURa8y/bUJ0iontRbqHyp8HNqRUSAqvWWD1m28XPRwdWpHymdx09gXP+WnmeH7KDW/HpEwxkGbipBCdz53J
 myc/cKeU
 KC/4x8Mhozc4Q+8ygBMBWlVbQJiaKdHdLqUDg0h+6X94D2uzPF1BfAwbe0IiW3zn7JJQPF7h2sjvfBAHNSFPsK9QpQsu/axLhXL5AveY7Zd9TidIRUP1lZwd2IHvKP0+fTR0bYT6JXN+0U4xM4oBD9l87mRMnbqsp23+LAMcyPW+ULM+56sBwD9Ico0RHSBODmbMfaW7xw3PWgNqMlfdqkFPW6eOHw757a/IjP6exB022CV2J1ZoCTBtjmHfk2+AwgIAk7CgWOGfQY9FrR78Wxv2L4x/17MRMJz24RYzZ30j0jJfmiGqAmpAxwy7RMOb/CR6D0H2G/dTlNfKmFsKOGIDzQL9CVuF8t79jMJLGc7tGVPx+J3/L/q63IfmA3oJaUvaLgn+TFEybHQQws7kBdvu3LvD/L71uWpJg26lWzJ17RsifofhKDIe0Wr5Ua7eZsisoSUd8+GbtCflk9uSurftTB2Tf8el99L0PoElaUU4pk+JxQG3cIs8u8w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


2026/11/5 20:00, David Hildenbrand (Arm) :
> On 11/4/26 10:10, Hui Zhu wrote:
>> From: Hui Zhu <zhuhui@kylinos.cn>
>>
>> KCSAN reports a data-race in do_read_fault / pmd_install; the same code
>> is in mainline:
>>
>>    write (marked) to 0xffff8d52a75fb810 of 8 bytes by task 27487 on cpu 5:
>>     native_set_pmd arch/x86/include/asm/pgtable_64.h:83 [inline]
>>     pmd_populate arch/x86/include/asm/pgalloc.h:84 [inline]
>>     pmd_install+0xe0/0x120 mm/memory.c:444
>>     finish_fault+0x5bc/0xb00 mm/memory.c:5204
>>     do_cow_fault mm/memory.c:5432 [inline]
>>     do_fault+0x5d0/0x6e0 mm/memory.c:5526
>>     handle_mm_fault+0x211/0x4c0 mm/memory.c:6218
>>     __mm_populate+0x144/0x270 mm/gup.c:2207
>>     __do_sys_mlockall+0x2cd/0x380 mm/mlock.c:764
>>
>>    read to 0xffff8d52a75fb810 of 8 bytes by task 27527 on cpu 9:
>>     do_fault_around mm/memory.c:5341 [inline]
>>     do_read_fault+0x162/0x670 mm/memory.c:5381
>>     do_fault+0x31a/0x6e0 mm/memory.c:5524
>>     handle_mm_fault+0x211/0x4c0 mm/memory.c:6218
>>     faultin_page_range+0x227/0x530 mm/gup.c:2156
>>     __x64_sys_madvise+0x67/0x80 mm/madvise.c:1479
>>
>>    value changed: 0x0000000000000000 -> 0x000000001386c067
>>
>> Both paths only hold mmap_lock for read, so do_fault_around() tests
>> vmf->pmd while pmd_install() populates it under the pmd lock.  The race is
>> benign: a stale pmd_none() only wastes the prealloc_pte, which do_fault()
>> frees again, and a pmd seen as populated only makes ->map_pages() find no
>> PTE and do_read_fault() fall back to __do_fault().
>>
>> The load still has to be lockless-safe.  The store side already is: on
>> i386-PAE, pmd_install() publishes both halves of the pmd with a single
>> cmpxchg8b.  The load side is not.  pmdp_get() is a plain READ_ONCE() over
>> a pmd_t that is wider than a word there, so it becomes two 32-bit loads
>> and can return the low half of one pmd together with the high half of
>> another.  Use pmdp_get_lockless(), the accessor for pmd reads that do not
>> hold the pmd lock: it re-reads until both halves come from the same pmd.
>> It is also what __pte_offset_map() already uses on this very pmd a few
>> instructions later.
>>
>> Only X86_32+X86_PAE and SH+X2TLB compile the retry loop, these being the
>> GUP_GET_PXX_LOW_HIGH selectors that have more than two page table levels.
>> mips32 with 64-bit physical addresses selects GUP_GET_PXX_LOW_HIGH too,
>> but is 2-level and so falls back to pmdp_get().  On every other
>> configuration, x86-64 included, pmdp_get_lockless() is pmdp_get(): the
>> pmd is loaded in one go, the READ_ONCE() silences the report the same
>> way, and there is no functional change.
>>
>> Fixes: 7267ec008b5c ("mm: postpone page table allocation until we have page to map")
>> Cc: stable+noautosel@kernel.org # KCSAN annotation only, no functional change
>> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
>> Acked-by: Lorenzo Stoakes <ljs@kernel.org>
>> ---
>> Changelog:
>> v4:
>> Commit message only, the diff is identical to v3.  Spell out the affected
>> arches and add the lore links for v1-v3 (Lorenzo Stoakes).  Reword the
>> cmpxchg8b sentence: the store is already atomic, it is the load that tears.
>> Add the Fixes: tag (David Hildenbrand).
>> v3:
>> https://lore.kernel.org/all/20261103014749.96764-1-hui.zhu@linux.dev/
>> Shorten the comment to one line (David Hildenbrand).
>> v2:
>> https://lore.kernel.org/all/20261102093120.92654-1-hui.zhu@linux.dev/
>> Use pmdp_get_lockless() instead of pmdp_get() (David Hildenbrand).
>> v1:
>> https://lore.kernel.org/all/20261102031308.66177-1-hui.zhu@linux.dev/
>>
>>   mm/memory.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/memory.c b/mm/memory.c
>> index 0fb676dd2bd63..f25c2ce0ef153 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -6017,7 +6017,8 @@ static vm_fault_t do_fault_around(struct vm_fault *vmf)
>>   	to_pte = min3(from_pte + nr_pages, (pgoff_t)PTRS_PER_PTE,
>>   		      pte_off + vma_pages(vmf->vma) - vma_off) - 1;
>>   
>> -	if (pmd_none(*vmf->pmd)) {
>> +	/* pmd_install() rechecks pmd_none() under the pmd lock. */
>> +	if (pmd_none(pmdp_get_lockless(vmf->pmd))) {
>>   		vmf->prealloc_pte = pte_alloc_one(vmf->vma->vm_mm);
>>   		if (!vmf->prealloc_pte)
>>   			return VM_FAULT_OOM;
> Fun, this breaks some odd m68k configs because they do some legacy weird stuff with pmd_none().
>
> I'll throw in the following cleanup. CCing m68k maintainers: I would drag
> this along with this fix here unless you disagree.
>
>  From e3c739933a04743e3923f6f39a603e93f2700304 Mon Sep 17 00:00:00 2001
> From: "David Hildenbrand (Arm)" <david@kernel.org>
> Date: Thu, 5 Nov 2026 12:49:38 +0100
> Subject: [PATCH] m68k/mm: simplify
>   pmd_none()/pmd_val()/pmd_present()/pmd_bad()
>
> pmd_t on m68k used to contain 16 words. Commit ef22d8abd876 ("m68k:
> mm: Restructure Motorola MMU page-table layout") reduced Motorola PMDs
> to one word; Sun3 and ColdFire use word-sized folded PMDs.
>
> Use direct member access in pmd_val() and replace the Sun3 and ColdFire
> pointer-taking predicate wrappers with inline functions taking values.
>
> This allows us to write something like:
>
>    if (pmd_none(pmdp_get(pmdp)))
>
> While at it remove unused pmd_present2() and commented-out pmd_bad()
> on sun3.
>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>   arch/m68k/include/asm/mcf_pgtable.h  | 20 +++++++++++++++-----
>   arch/m68k/include/asm/page.h         |  2 +-
>   arch/m68k/include/asm/sun3_pgtable.h | 23 +++++++++++++++--------
>   3 files changed, 31 insertions(+), 14 deletions(-)
>
> diff --git a/arch/m68k/include/asm/mcf_pgtable.h b/arch/m68k/include/asm/mcf_pgtable.h
> index f45a882238dbb..4efa8e3e1e98a 100644
> --- a/arch/m68k/include/asm/mcf_pgtable.h
> +++ b/arch/m68k/include/asm/mcf_pgtable.h
> @@ -130,11 +130,21 @@ static inline void pte_clear(struct mm_struct *mm, unsigned long addr,
>   
>   #define pte_page(pte)	virt_to_page(__pte_page(pte))
>   
> -static inline int pmd_none2(pmd_t *pmd) { return !pmd_val(*pmd); }
> -#define pmd_none(pmd) pmd_none2(&(pmd))
> -static inline int pmd_bad2(pmd_t *pmd) { return 0; }
> -#define pmd_bad(pmd) pmd_bad2(&(pmd))
> -#define pmd_present(pmd) (!pmd_none2(&(pmd)))
> +static inline int pmd_none(pmd_t pmd)
> +{
> +	return !pmd_val(pmd);
> +}
> +
> +static inline int pmd_bad(pmd_t pmd)
> +{
> +	return 0;
> +}
> +
> +static inline int pmd_present(pmd_t pmd)
> +{
> +	return !pmd_none(pmd);
> +}
> +
>   static inline void pmd_clear(pmd_t *pmdp) { pmd_val(*pmdp) = 0; }
>   
>   
> diff --git a/arch/m68k/include/asm/page.h b/arch/m68k/include/asm/page.h
> index d30f8b2f15927..09a2c020ec992 100644
> --- a/arch/m68k/include/asm/page.h
> +++ b/arch/m68k/include/asm/page.h
> @@ -17,7 +17,7 @@
>    */
>   #if !defined(CONFIG_MMU) || CONFIG_PGTABLE_LEVELS == 3
>   typedef struct { unsigned long pmd; } pmd_t;
> -#define pmd_val(x)	((&x)->pmd)
> +#define pmd_val(x)	((x).pmd)
>   #define __pmd(x)	((pmd_t) { (x) } )
>   #endif
>   
> diff --git a/arch/m68k/include/asm/sun3_pgtable.h b/arch/m68k/include/asm/sun3_pgtable.h
> index 704442a391fd7..5867d24032655 100644
> --- a/arch/m68k/include/asm/sun3_pgtable.h
> +++ b/arch/m68k/include/asm/sun3_pgtable.h
> @@ -109,14 +109,21 @@ static inline void pte_clear (struct mm_struct *mm, unsigned long addr, pte_t *p
>   #define pmd_page(pmd)		virt_to_page((void *)pmd_page_vaddr(pmd))
>   
>   
> -static inline int pmd_none2 (pmd_t *pmd) { return !pmd_val (*pmd); }
> -#define pmd_none(pmd) pmd_none2(&(pmd))
> -//static inline int pmd_bad (pmd_t pmd) { return (pmd_val (pmd) & SUN3_PMD_MASK) != SUN3_PMD_MAGIC; }
> -static inline int pmd_bad2 (pmd_t *pmd) { return 0; }
> -#define pmd_bad(pmd) pmd_bad2(&(pmd))
> -static inline int pmd_present2 (pmd_t *pmd) { return pmd_val (*pmd) & SUN3_PMD_VALID; }
> -/* #define pmd_present(pmd) pmd_present2(&(pmd)) */
> -#define pmd_present(pmd) (!pmd_none2(&(pmd)))
> +static inline int pmd_none(pmd_t pmd)
> +{
> +	return !pmd_val(pmd);
> +}
> +
> +static inline int pmd_bad(pmd_t pmd)
> +{
> +	return 0;
> +}
> +
> +static inline int pmd_present(pmd_t pmd)
> +{
> +	return !pmd_none(pmd);
> +}
> +
>   static inline void pmd_clear (pmd_t *pmdp) { pmd_val (*pmdp) = 0; }
>   
>   /*

Hi David,

Thanks for picking this up, and for the m68k cleanup!

Tested-by: Hui Zhu <zhuhui@kylinos.cn>

Tested with gcc-m68k-linux-gnu 13.3.0 (Ubuntu 13.3.0-6ubuntu2~24.04), on
three configs that between them cover all three m68k families:

   amiga_defconfig                    Motorola MMU, PGTABLE_LEVELS=3
   sun3_defconfig                     SUN3,  PGTABLE_LEVELS=2
   m5208evb_defconfig + CONFIG_MMU=y  ColdFire,  PGTABLE_LEVELS=2

Without your patch none of the three can build mm/memory.o, and each fails
at a different site:

   arch/m68k/include/asm/page.h:20:27: error: lvalue required as unary 
'&' operand
   arch/m68k/include/asm/sun3_pgtable.h:113:33: error: lvalue required 
as unary '&' operand
   arch/m68k/include/asm/mcf_pgtable.h:134:33: error: lvalue required as 
unary '&' operand

With it, all three build a full vmlinux with zero warnings.

Two things that might save you some time:

- m68k looks like the only arch with this pattern. Grepping arch/ and
   include/ for '(&x)->pmd' and '(&(pmd))' finds nothing outside arch/m68k/,
   and pmd_none2()/pmd_bad2()/pmd_present2() only exist in mcf_pgtable.h and
   sun3_pgtable.h. So your three hunks look complete to me.

- No m52xx/m54xx defconfig enables CONFIG_MMU, so the ColdFire path through
   mcf_pgtable.h has no defconfig coverage at all; you have to flip it on by
   hand (scripts/config -e MMU && make olddefconfig) to reach it. That is
   probably how this went unnoticed for so long - my patch has been breaking
   m68k since v1, because pmdp_get() returns by value just like
   pmdp_get_lockless() does.

I also checked whether your patch changes code generation, by building the
same tree with and without it and comparing every object with objdump -d
(plain cmp is useless here, timestamps and link layout shift everything).
Counting only objects whose disassembly actually differs:

   amiga      3733 objects, 0 changed
   sun3       3553 objects, 3 changed: mm/memory.o, mm/pgtable-generic.o,
                                       mm/vmalloc.o
   m5208evb    716 objects, 1 changed: mm/pgtable-generic.o

amiga is the interesting one. It is the only config where pmd_val() itself
changed, and it comes out bit-for-bit identical, which also says the build
is reproducible enough for this comparison to mean anything. sun3 and
ColdFire differ because pmd_none() stops taking the address of its
argument, and the direction is an improvement. In mm/vmalloc.o on sun3 one
function loses a forced spill:

   -  subql #4,%sp
   -  movel %d0,%sp@(12)     /* spill the pmd value */
   -  lea %sp@(12),%a1       /* &(pmd) */
   -  moveal %a1@,%a0        /* read it back */

and turns into a 13 instruction function with no stack slot at all.
Instruction counts are otherwise flat (sun3 mm/memory.o 7373 -> 7373,
mm/vmalloc.o 5514 -> 5515), so it is not a size regression.

Dragging the cleanup along with the fix sounds right to me. It is a hard
prerequisite, and sent on its own it would just look like a cleanup with no
urgency. I assume it goes in ahead of 6ab55cfd in core-7.5.misc, so that
linux-next never sees a broken m68k in between.

One red herring in case anyone else pokes at this: m5208evb with its stock
defconfig (CONFIG_MMU not set) fails to build mm/memory.o for reasons that
have nothing to do with any of this - implicit declarations of
pte_is_uffd_wp_marker() and pmd_pgtable(), plus a parse error in
include/linux/mm.h. Pre-existing, and it goes away once MMU is on.

Best,
Hui



