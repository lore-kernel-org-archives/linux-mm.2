Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFCDA606A339
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 05:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=UpNt+xLP
Received: by kanga.kvack.org (Postfix)
	id C87406B05B3; Mon,  9 Nov 2026 00:50:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C385A6B05B8; Mon,  9 Nov 2026 00:50:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2CD66B05B3; Mon,  9 Nov 2026 00:50:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 865536B05B3
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 00:50:52 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 05804C05B5
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:50:51 +0000 (UTC)
X-FDA: 85414506744.02.CAF0281
Received: from mta1.migadu.com (out-241.mta1.migadu.com [95.215.58.241])
	by imf14.hostedemail.com (Postfix) with ESMTP id BA69E100003
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:50:49 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UpNt+xLP;
	spf=pass (imf14.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.241 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794203450;
	b=mqk+uCE+zt5IINzX9r750Yjwc7wWmm2oCC5FITix5y3LPEK/sPDO+KeH9D3XCBPKZdB8Cq
	Pf2ebh1Mj3WN6YV2Ii5NEy+aCCCESpI1pinSnco9PMXAusirIS5OusTB9pQ2l9XE4YQBhl
	MkyeGdFSYvJJslN7h7A39cyzgWnUO5s=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UpNt+xLP;
	spf=pass (imf14.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.241 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794203450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MNwtJGlaqUCyQUQFpRisrhaSPNbClPkTOsfsk4c6288=;
	b=StDBhcmVEYIIJzEUxiUIApc20IMopYKC9ZZgvdIUsHVOJiFNEfjHLy+a+4mOntXwfMTgqW
	Bm5OnUYhZgceTKBGWDGYOdJyh57qp1c8krMNZwj/o6+c3Ha/rgcH/pxMwUkmaSMpfkiPvZ
	7iyojjJCSAHauNNUfVw7wEwqPcwTgps=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=05YxRWNZJI30oJfOmyqMZX5TbgRYCDrZaXVZFkrDSX0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794203448; v=1; x=1794808248;
 b=UpNt+xLP4wHFET68R+zvjaQZyHcS+yE5UEzVYOILWclodaHHroQfBK3ir6+BfF8HYFKMc0na
 8RTLf8bktd2k1+DmSgBoftOKZkUPuH8FkWCROqQw/HUKYo0gAXSHJl/9TdaRwRjNF6d+gVeD7WT
 hCwPZi+9YgjCKbjZQlVBahnA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id a9500b413c04da7b;
	Mon, 09 Nov 2026 05:50:45 +0000
X-Mizu-Trace-ID: a9500b413c04da7b
X-Migadu-Flow: FLOW_OUT
Message-ID: <f03d8a2f-7803-4503-9485-54a9ddcaf332@linux.dev>
Date: Mon, 9 Nov 2026 13:50:32 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Betterbird (macOS/Intel)
Subject: Re: [PATCH v4] mm/memory: use pmdp_get_lockless() for the pmd read in
 do_fault_around()
To: Greg Ungerer <gerg@polyxeno.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>,
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
 <88a6bf17-2189-44a8-8255-50b7ee1d80f2@linux.dev>
 <e6ed4165-03fd-4204-b25a-bafc37c3930c@polyxeno.com>
Content-Language: en-US
From: Hui Zhu <hui.zhu@linux.dev>
In-Reply-To: <e6ed4165-03fd-4204-b25a-bafc37c3930c@polyxeno.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: re46opqazab7e5mchzb6jw4ejhgg7ojq
X-Rspamd-Queue-Id: BA69E100003
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794203449-244449
X-HE-Meta: U2FsdGVkX19Fl5auW/nQKAQzI7HWUXJsc0JFHHf+Zt6V1snUbDCS5sPjaFySshfEKJi/ox8TO6hhuSPawmWxsCBLAXivFpEiZ+Qjm741dostf6AeIxjyoY9lBoJTdpqYP39QtdTZlaI0+sCfjOD7yNMmpKgI9UuIpcCouM1RKNuK8//8ZWyyVLpBQ6FGfVljHbV0f5MDHIwoomv9Bmu9Ny4fvTmJSqt2vHUtKJoVDgmSK2vc2qJuwlXN6ZYmQG+ym2gmsvK85O+k/z9jow8BJHJt9RPwtmuEQ6RriKX1Or8GN51mkihxsggBAOs+XppDOjrQSFZ3YkXEcydiX0/4wTNtv87bBUCQc3d0/CVo2EgZ064nfqg3r/V6ki1fasX8wetcbzXuWDbzDNH6xglhxC+A4EBpQGE20rkDMpdyCE7aPCpGeNEWKx96fVIA53u3BcM3GnDH8bM5Z30X4obp5LPic7HWPS68ZKNI/0AZD8+BNlT8nUxjaESYjbNNU7Sbr5i3W4bZ41upSyk88M5huqCkqLqUb3EgD2T9kGi/6rrG9vGL+Vxe5puxKCwE+9D0g1AIZar+/C4vlqxf8pkZoS+XLkae/bdLrfeqdHuR7cohD7ecxZHz4xAPtklHjYeyhT3KKuLy2K9vjAz0z1yzxo2ItMqmcGksX711q3awbr8A8dbGbQtnQFsB2c45q5kBg6QEYfhz4TktYjpbKtkMnVQIcir0JUrTqkVmuz6oWVnu2nL2PTid+hx6WS0ky0dd21hkEjcBDfePvvgwBeieuHn8wyrxAzizwlo/N1cdbeNMpBDD3j+nFhHB5M5hoFsL1SvSSmyUUzMIQj25bUR2OLJERbqOhF0eZPI6m41vbGgBn13tDTYo0P4a8LOgYZFYvMfF3K0c3SrwMnyLsAvImjwou1Y+1xYRa8W33gOzCLDGatr/A9bGyuYiqKv2t4ymit3Od2gfHrc9rqaPGI8
 ckLDz3HV
 4DeAuCdwLOmk8EQvp8zquH18wEtgFs9xyy0zw0zSKDN3ccGOCKp1CpKj4tMM8CRUuAT5tngYokQi8Vd8KijPZI51IKsgiZRaAdxbEDavsIAp4X1xB0YHCeh6GVoVxoMOb7HyEM42f9G0EyKm0jH7fGRed8WM4iF/0+L7ifYZG5I9RajDxsqM68nbdcixMtX6hsYcCc+X6DHjHR7f0uVb62o7aLry1Qlwf6Jt7g6QZzzvnb/nKUbdRWUqkhlDpptct21ilnqkkJ+ski7OwTEgmzA1rj6qA7wuqDxuHHyn8oPBJ/YZ7Qlb1BzSXKrAs1LNC3HiRMc2AK1g41GyDNtd8v++0BsYwqABcjmzCSc+ob4O2JX+CQkY/wtrGzW77WIq1tO61S/xqtyuPjo4IR1b+dnWrjvrnOAbFy9tvGxUvAiSsyke2zr02/u2g8IAFGn2vC0Z1KA3TGXiuuCjquHVCUqN9F1svTelSPx/hMZREXHntq1A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

2026/11/6 20:08, Greg Ungerer:

Hi Greg,

> Hi Hui,
>
> On 6/11/26 13:03, Hui Zhu wrote:
>> 2026/11/5 20:00, David Hildenbrand (Arm) :
>>> On 11/4/26 10:10, Hui Zhu wrote:
>>>> From: Hui Zhu <zhuhui@kylinos.cn>
>>>>
>>>> KCSAN reports a data-race in do_read_fault / pmd_install; the same code
>>>> is in mainline:
>>>>
>>>>     write (marked) to 0xffff8d52a75fb810 of 8 bytes by task 27487 on cpu 5:
>>>>      native_set_pmd arch/x86/include/asm/pgtable_64.h:83 [inline]
>>>>      pmd_populate arch/x86/include/asm/pgalloc.h:84 [inline]
>>>>      pmd_install+0xe0/0x120 mm/memory.c:444
>>>>      finish_fault+0x5bc/0xb00 mm/memory.c:5204
>>>>      do_cow_fault mm/memory.c:5432 [inline]
>>>>      do_fault+0x5d0/0x6e0 mm/memory.c:5526
>>>>      handle_mm_fault+0x211/0x4c0 mm/memory.c:6218
>>>>      __mm_populate+0x144/0x270 mm/gup.c:2207
>>>>      __do_sys_mlockall+0x2cd/0x380 mm/mlock.c:764
>>>>
>>>>     read to 0xffff8d52a75fb810 of 8 bytes by task 27527 on cpu 9:
>>>>      do_fault_around mm/memory.c:5341 [inline]
>>>>      do_read_fault+0x162/0x670 mm/memory.c:5381
>>>>      do_fault+0x31a/0x6e0 mm/memory.c:5524
>>>>      handle_mm_fault+0x211/0x4c0 mm/memory.c:6218
>>>>      faultin_page_range+0x227/0x530 mm/gup.c:2156
>>>>      __x64_sys_madvise+0x67/0x80 mm/madvise.c:1479
>>>>
>>>>     value changed: 0x0000000000000000 -> 0x000000001386c067
>>>>
>>>> Both paths only hold mmap_lock for read, so do_fault_around() tests
>>>> vmf->pmd while pmd_install() populates it under the pmd lock.  The race is
>>>> benign: a stale pmd_none() only wastes the prealloc_pte, which do_fault()
>>>> frees again, and a pmd seen as populated only makes ->map_pages() find no
>>>> PTE and do_read_fault() fall back to __do_fault().
>>>>
>>>> The load still has to be lockless-safe.  The store side already is: on
>>>> i386-PAE, pmd_install() publishes both halves of the pmd with a single
>>>> cmpxchg8b.  The load side is not.  pmdp_get() is a plain READ_ONCE() over
>>>> a pmd_t that is wider than a word there, so it becomes two 32-bit loads
>>>> and can return the low half of one pmd together with the high half of
>>>> another.  Use pmdp_get_lockless(), the accessor for pmd reads that do not
>>>> hold the pmd lock: it re-reads until both halves come from the same pmd.
>>>> It is also what __pte_offset_map() already uses on this very pmd a few
>>>> instructions later.
>>>>
>>>> Only X86_32+X86_PAE and SH+X2TLB compile the retry loop, these being the
>>>> GUP_GET_PXX_LOW_HIGH selectors that have more than two page table levels.
>>>> mips32 with 64-bit physical addresses selects GUP_GET_PXX_LOW_HIGH too,
>>>> but is 2-level and so falls back to pmdp_get().  On every other
>>>> configuration, x86-64 included, pmdp_get_lockless() is pmdp_get(): the
>>>> pmd is loaded in one go, the READ_ONCE() silences the report the same
>>>> way, and there is no functional change.
>>>>
>>>> Fixes: 7267ec008b5c ("mm: postpone page table allocation until we have page to map")
>>>> Cc: stable+noautosel@kernel.org # KCSAN annotation only, no functional change
>>>> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
>>>> Acked-by: Lorenzo Stoakes <ljs@kernel.org>
>>>> ---
>>>> Changelog:
>>>> v4:
>>>> Commit message only, the diff is identical to v3.  Spell out the affected
>>>> arches and add the lore links for v1-v3 (Lorenzo Stoakes).  Reword the
>>>> cmpxchg8b sentence: the store is already atomic, it is the load that tears.
>>>> Add the Fixes: tag (David Hildenbrand).
>>>> v3:
>>>> https://lore.kernel.org/all/20261103014749.96764-1-hui.zhu@linux.dev/
>>>> Shorten the comment to one line (David Hildenbrand).
>>>> v2:
>>>> https://lore.kernel.org/all/20261102093120.92654-1-hui.zhu@linux.dev/
>>>> Use pmdp_get_lockless() instead of pmdp_get() (David Hildenbrand).
>>>> v1:
>>>> https://lore.kernel.org/all/20261102031308.66177-1-hui.zhu@linux.dev/
>>>>
>>>>    mm/memory.c | 3 ++-
>>>>    1 file changed, 2 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/mm/memory.c b/mm/memory.c
>>>> index 0fb676dd2bd63..f25c2ce0ef153 100644
>>>> --- a/mm/memory.c
>>>> +++ b/mm/memory.c
>>>> @@ -6017,7 +6017,8 @@ static vm_fault_t do_fault_around(struct vm_fault *vmf)
>>>>        to_pte = min3(from_pte + nr_pages, (pgoff_t)PTRS_PER_PTE,
>>>>                  pte_off + vma_pages(vmf->vma) - vma_off) - 1;
>>>>    -    if (pmd_none(*vmf->pmd)) {
>>>> +    /* pmd_install() rechecks pmd_none() under the pmd lock. */
>>>> +    if (pmd_none(pmdp_get_lockless(vmf->pmd))) {
>>>>            vmf->prealloc_pte = pte_alloc_one(vmf->vma->vm_mm);
>>>>            if (!vmf->prealloc_pte)
>>>>                return VM_FAULT_OOM;
>>> Fun, this breaks some odd m68k configs because they do some legacy weird stuff with pmd_none().
>>>
>>> I'll throw in the following cleanup. CCing m68k maintainers: I would drag
>>> this along with this fix here unless you disagree.
>>>
>>>   From e3c739933a04743e3923f6f39a603e93f2700304 Mon Sep 17 00:00:00 2001
>>> From: "David Hildenbrand (Arm)" <david@kernel.org>
>>> Date: Thu, 5 Nov 2026 12:49:38 +0100
>>> Subject: [PATCH] m68k/mm: simplify
>>>    pmd_none()/pmd_val()/pmd_present()/pmd_bad()
>>>
>>> pmd_t on m68k used to contain 16 words. Commit ef22d8abd876 ("m68k:
>>> mm: Restructure Motorola MMU page-table layout") reduced Motorola PMDs
>>> to one word; Sun3 and ColdFire use word-sized folded PMDs.
>>>
>>> Use direct member access in pmd_val() and replace the Sun3 and ColdFire
>>> pointer-taking predicate wrappers with inline functions taking values.
>>>
>>> This allows us to write something like:
>>>
>>>     if (pmd_none(pmdp_get(pmdp)))
>>>
>>> While at it remove unused pmd_present2() and commented-out pmd_bad()
>>> on sun3.
>>>
>>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>>> ---
>>>    arch/m68k/include/asm/mcf_pgtable.h  | 20 +++++++++++++++-----
>>>    arch/m68k/include/asm/page.h         |  2 +-
>>>    arch/m68k/include/asm/sun3_pgtable.h | 23 +++++++++++++++--------
>>>    3 files changed, 31 insertions(+), 14 deletions(-)
>>>
>>> diff --git a/arch/m68k/include/asm/mcf_pgtable.h b/arch/m68k/include/asm/mcf_pgtable.h
>>> index f45a882238dbb..4efa8e3e1e98a 100644
>>> --- a/arch/m68k/include/asm/mcf_pgtable.h
>>> +++ b/arch/m68k/include/asm/mcf_pgtable.h
>>> @@ -130,11 +130,21 @@ static inline void pte_clear(struct mm_struct *mm, unsigned long addr,
>>>      #define pte_page(pte)    virt_to_page(__pte_page(pte))
>>>    -static inline int pmd_none2(pmd_t *pmd) { return !pmd_val(*pmd); }
>>> -#define pmd_none(pmd) pmd_none2(&(pmd))
>>> -static inline int pmd_bad2(pmd_t *pmd) { return 0; }
>>> -#define pmd_bad(pmd) pmd_bad2(&(pmd))
>>> -#define pmd_present(pmd) (!pmd_none2(&(pmd)))
>>> +static inline int pmd_none(pmd_t pmd)
>>> +{
>>> +    return !pmd_val(pmd);
>>> +}
>>> +
>>> +static inline int pmd_bad(pmd_t pmd)
>>> +{
>>> +    return 0;
>>> +}
>>> +
>>> +static inline int pmd_present(pmd_t pmd)
>>> +{
>>> +    return !pmd_none(pmd);
>>> +}
>>> +
>>>    static inline void pmd_clear(pmd_t *pmdp) { pmd_val(*pmdp) = 0; }
>>>      diff --git a/arch/m68k/include/asm/page.h b/arch/m68k/include/asm/page.h
>>> index d30f8b2f15927..09a2c020ec992 100644
>>> --- a/arch/m68k/include/asm/page.h
>>> +++ b/arch/m68k/include/asm/page.h
>>> @@ -17,7 +17,7 @@
>>>     */
>>>    #if !defined(CONFIG_MMU) || CONFIG_PGTABLE_LEVELS == 3
>>>    typedef struct { unsigned long pmd; } pmd_t;
>>> -#define pmd_val(x)    ((&x)->pmd)
>>> +#define pmd_val(x)    ((x).pmd)
>>>    #define __pmd(x)    ((pmd_t) { (x) } )
>>>    #endif
>>>    diff --git a/arch/m68k/include/asm/sun3_pgtable.h b/arch/m68k/include/asm/sun3_pgtable.h
>>> index 704442a391fd7..5867d24032655 100644
>>> --- a/arch/m68k/include/asm/sun3_pgtable.h
>>> +++ b/arch/m68k/include/asm/sun3_pgtable.h
>>> @@ -109,14 +109,21 @@ static inline void pte_clear (struct mm_struct *mm, unsigned long addr, pte_t *p
>>>    #define pmd_page(pmd)        virt_to_page((void *)pmd_page_vaddr(pmd))
>>>      -static inline int pmd_none2 (pmd_t *pmd) { return !pmd_val (*pmd); }
>>> -#define pmd_none(pmd) pmd_none2(&(pmd))
>>> -//static inline int pmd_bad (pmd_t pmd) { return (pmd_val (pmd) & SUN3_PMD_MASK) != SUN3_PMD_MAGIC; }
>>> -static inline int pmd_bad2 (pmd_t *pmd) { return 0; }
>>> -#define pmd_bad(pmd) pmd_bad2(&(pmd))
>>> -static inline int pmd_present2 (pmd_t *pmd) { return pmd_val (*pmd) & SUN3_PMD_VALID; }
>>> -/* #define pmd_present(pmd) pmd_present2(&(pmd)) */
>>> -#define pmd_present(pmd) (!pmd_none2(&(pmd)))
>>> +static inline int pmd_none(pmd_t pmd)
>>> +{
>>> +    return !pmd_val(pmd);
>>> +}
>>> +
>>> +static inline int pmd_bad(pmd_t pmd)
>>> +{
>>> +    return 0;
>>> +}
>>> +
>>> +static inline int pmd_present(pmd_t pmd)
>>> +{
>>> +    return !pmd_none(pmd);
>>> +}
>>> +
>>>    static inline void pmd_clear (pmd_t *pmdp) { pmd_val (*pmdp) = 0; }
>>>      /*
>> Hi David,
>>
>> Thanks for picking this up, and for the m68k cleanup!
>>
>> Tested-by: Hui Zhu <zhuhui@kylinos.cn>
>>
>> Tested with gcc-m68k-linux-gnu 13.3.0 (Ubuntu 13.3.0-6ubuntu2~24.04), on
>> three configs that between them cover all three m68k families:
>>
>>    amiga_defconfig                    Motorola MMU, PGTABLE_LEVELS=3
>>    sun3_defconfig                     SUN3,  PGTABLE_LEVELS=2
>>    m5208evb_defconfig + CONFIG_MMU=y  ColdFire,  PGTABLE_LEVELS=2
>>
>> Without your patch none of the three can build mm/memory.o, and each fails
>> at a different site:
>>
>>    arch/m68k/include/asm/page.h:20:27: error: lvalue required as unary '&' operand
>>    arch/m68k/include/asm/sun3_pgtable.h:113:33: error: lvalue required as unary '&' operand
>>    arch/m68k/include/asm/mcf_pgtable.h:134:33: error: lvalue required as unary '&' operand
>>
>> With it, all three build a full vmlinux with zero warnings.
>>
>> Two things that might save you some time:
>>
>> - m68k looks like the only arch with this pattern. Grepping arch/ and
>>    include/ for '(&x)->pmd' and '(&(pmd))' finds nothing outside arch/m68k/,
>>    and pmd_none2()/pmd_bad2()/pmd_present2() only exist in mcf_pgtable.h and
>>    sun3_pgtable.h. So your three hunks look complete to me.
>>
>> - No m52xx/m54xx defconfig enables CONFIG_MMU, so the ColdFire path through
>>    mcf_pgtable.h has no defconfig coverage at all; you have to flip it on by
>>    hand (scripts/config -e MMU && make olddefconfig) to reach it. That is
>>    probably how this went unnoticed for so long - my patch has been breaking
>>    m68k since v1, because pmdp_get() returns by value just like
>>    pmdp_get_lockless() does.
> The m5475evb_defconfig is supposed to have MMU enabled:
>
>       $ ARCH=m68k CROSS_COMPILE=m68k-linux-uclibc- make m5475evb_defconfig
>         HOSTCC  scripts/basic/fixdep
>         [snip]
>         HOSTLD  scripts/kconfig/conf
>       #
>       # configuration written to .config
>       #
>       $
>       $ grep CONFIG_MMU .config
>       CONFIG_MMU=y
>       CONFIG_MMU_COLDFIRE=y
>       CONFIG_MMU_GATHER_NO_RANGE=y
>       CONFIG_MMU_GATHER_MERGE_VMAS=y
>       CONFIG_MMU_LAZY_TLB_REFCOUNT=y
>
> But something ends up disabling it when you compile.
> I'll fix this.
>
>
>> I also checked whether your patch changes code generation, by building the
>> same tree with and without it and comparing every object with objdump -d
>> (plain cmp is useless here, timestamps and link layout shift everything).
>> Counting only objects whose disassembly actually differs:
>>
>>    amiga      3733 objects, 0 changed
>>    sun3       3553 objects, 3 changed: mm/memory.o, mm/pgtable-generic.o,
>>                                        mm/vmalloc.o
>>    m5208evb    716 objects, 1 changed: mm/pgtable-generic.o
>>
>> amiga is the interesting one. It is the only config where pmd_val() itself
>> changed, and it comes out bit-for-bit identical, which also says the build
>> is reproducible enough for this comparison to mean anything. sun3 and
>> ColdFire differ because pmd_none() stops taking the address of its
>> argument, and the direction is an improvement. In mm/vmalloc.o on sun3 one
>> function loses a forced spill:
>>
>>    -  subql #4,%sp
>>    -  movel %d0,%sp@(12)     /* spill the pmd value */
>>    -  lea %sp@(12),%a1       /* &(pmd) */
>>    -  moveal %a1@,%a0        /* read it back */
>>
>> and turns into a 13 instruction function with no stack slot at all.
>> Instruction counts are otherwise flat (sun3 mm/memory.o 7373 -> 7373,
>> mm/vmalloc.o 5514 -> 5515), so it is not a size regression.
>>
>> Dragging the cleanup along with the fix sounds right to me. It is a hard
>> prerequisite, and sent on its own it would just look like a cleanup with no
>> urgency. I assume it goes in ahead of 6ab55cfd in core-7.5.misc, so that
>> linux-next never sees a broken m68k in between.
>>
>> One red herring in case anyone else pokes at this: m5208evb with its stock
>> defconfig (CONFIG_MMU not set) fails to build mm/memory.o for reasons that
>> have nothing to do with any of this - implicit declarations of
>> pte_is_uffd_wp_marker() and pmd_pgtable(), plus a parse error in
>> include/linux/mm.h. Pre-existing, and it goes away once MMU is on.
> You should not be able to set MMU=y if configured for the M5208.
> It doesn't have an MMU. You want the 5475, 5485 or 54418 to test
> valid MMU=y configurations.
>
> Regards
> Greg
>
>
>

You are right on both counts, and that mail of mine had three things
wrong.

1. "No m52xx/m54xx defconfig enables CONFIG_MMU" - wrong.  I grepped the
defconfig fragments for CONFIG_MMU=y, but MMU is 'default y', so an
enabled MMU never appears in the fragment.  m5475evb and m54418evb
both give CONFIG_MMU=y, as you show.

2. My "m5208evb + CONFIG_MMU=y" test config was not a valid config.
M520x is 'depends on !MMU', so forcing MMU on leaves the SoC choice
unsatisfiable and olddefconfig silently drops it:

before:  # CONFIG_MMU is not set / CONFIG_M520x=y
after:   CONFIG_MMU=y / CONFIG_MMU_COLDFIRE=y / CONFIG_M520x gone

Please disregard the m5208evb row in my codegen numbers.

3. The "red herring" I flagged was my own doing, not a pre-existing
problem.  mm/Makefile has 'mmu-$(CONFIG_MMU) := ... memory.o', so a
NOMMU config never builds mm/memory.o at all; I asked for a target
that config does not have.  Sorry for the noise on that one.

Retested with the configs you named (7.4-rc1 plus the do_fault_around
change plus David's cleanup, gcc-m68k-linux-gnu 13.3.0):

m5475evb_defconfig   without David's patch: mm/memory.o fails at
mcf_pgtable.h:134 with it: full -j24 build ok, vmlinux 4215344
bytes, 0 warnings

m54418evb_defconfig  without David's patch: same mcf_pgtable.h:134
failure

So the Tested-by I sent covers amiga, sun3 and m5475evb.  It is
build-tested only - I have no m68k hardware here to boot.

On MMU being disabled when you compile: I cannot reproduce that. Here
m5475evb_defconfig gives CONFIG_MMU=y, olddefconfig reports no change,
two consecutive defconfig runs produce an identical .config, and a full
build finishes with CONFIG_MMU=y and CONFIG_M547x=y still set and
.config untouched.  Two differences from your setup that might matter:
I am on a glibc toolchain rather than uclibc, and building out of tree
with O= rather than in tree.

One observation, which may well be unrelated.  m5475evb_defconfig never
sets CONFIG_M547x - it only ends up with it because the "ColdFire SoC
type" choice defaults to M520x, which is unavailable under MMU=y, so
kconfig falls back to the first usable member. m54418evb_defconfig sets
CONFIG_M5441x=y explicitly.  If that fallback is what breaks on your
side, making m5475evb explicit would sidestep it.

Best,
Hui


>

