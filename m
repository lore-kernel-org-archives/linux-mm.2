Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E26DFF8864
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 06:58:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A49A6B0005; Wed, 29 Apr 2026 02:58:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 855C66B008C; Wed, 29 Apr 2026 02:58:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7448E6B0092; Wed, 29 Apr 2026 02:58:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 62AD56B0005
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 02:58:02 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ED8C0160521
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 06:58:01 +0000 (UTC)
X-FDA: 84710688762.19.E33E694
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf18.hostedemail.com (Postfix) with ESMTP id 222EC1C000C
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 06:57:59 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=H6yiHN2H;
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777445880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Kw+4q1CO+h440dR5FhEdc2icyH3yJEHWAWv9JTT/DU=;
	b=MGPSW+/QRoJZo/TPoHMw8mFHrbZKudQ3ut+aEjSB1MSHV1TTUY1OQf17fjUu/ae6al4Lw1
	ZjFHh1F0eO87HSXLlAAMBgMyJR64DN6JYdf/3J76fcgYAX7J9KpCdSjQKzOXWwOnuXRiDq
	LAcdIrWbmIj1Jop2fEt34sJMlbdbk6A=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=H6yiHN2H;
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777445880; a=rsa-sha256;
	cv=none;
	b=OwS8VWKJnuj5NcqZ2vfg96z32SSsxLLOM1gh5Ys3u4QbWqfyI0BrDKaqwvUVqVrVWzNHTS
	ZB2y6V/88W8lpc8LB6WtAj2gGQX5UHbwidGS2cR0vGGqaNaRKwOpwyVuyolq7LDAqVIvN2
	qyhHiOvENkoVi7pJpQWrlJ3ygoDawNA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777445877;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3Kw+4q1CO+h440dR5FhEdc2icyH3yJEHWAWv9JTT/DU=;
	b=H6yiHN2HgREaOafZFwJ2Uxcile0yOAVcLlhbwmQJhiVr/PnDb3eWARTI6zMqfZJ2M3Yxas
	ZEgKhkdmxMe4Lp4ZZSWa17+K3m4+Yxf2cvJM2rZ5Yco0Yg9mHk8TkN9xA2rVaa1VUes/gZ
	w1VbD8Yl5AxDQY8H3xc6Uv26hdzmoJo=
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org,
	hughd@google.com
Cc: akpm@linux-foundation.org,
	baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	liam.howlett@oracle.com,
	ljs@kernel.org,
	mhocko@suse.com,
	rppt@kernel.org,
	npache@redhat.com,
	zhengqi.arch@bytedance.com,
	ryan.roberts@arm.com,
	surenb@google.com,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH hotfix] mm: fix pmd_special() fallback to observe huge_zero
Date: Wed, 29 Apr 2026 14:57:42 +0800
Message-Id: <20260429065743.67054-1-lance.yang@linux.dev>
In-Reply-To: <e7cbc92b-ce9d-432a-ae5b-c8715dcd922f@kernel.org>
References: <e7cbc92b-ce9d-432a-ae5b-c8715dcd922f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ogj8xxmmpuj8hdwa7gf77ib4pe7wghkw
X-Rspamd-Queue-Id: 222EC1C000C
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777445879-875201
X-HE-Meta: U2FsdGVkX18m3bTx5L0xQjKvTgK+6ozZ34bPh86Fd8rJOauH9u8q6+nHbBMGLnqXQ07ajbBAY5akNGPA99mIU0t2oVV2oLQ8sFMjTgyuWFHLf0BkbxwViFjalHGeYizugB1HHu3fBFsaTpO1T6dlDjLmSz0fpRlKfXPVEebRhvi/p7PSm3rtmLSx92U4CqxdovnIJqReXS8g9Khlst0bEsGu5RcRGScBCk8cdsJNx+eVeNgsz127eDYjpPsB4/gDXeWRUZHi5nq2aAbsoTBFfvik7O6hOSARs6HzIfqBZKZQYHy13oTcao0lqAsj6Xfv17B5gbxRsS10i2kTo+nedC3JLeRkpSNd7w4ab4ddxDUlhEfGEa081l3MUDgFKY8Y4xS5jTVEga4jCchyw/MkJEGYjqhCjw1UTJfTLwxcW8j4gxuYEHFCX8v8DDBht77E0efaOSSwQnXt1PcqAi/ufJGOFShgX3hbyMFawspfqlztejidBDf0WXBHmH8To35zWilXftiY9gcAYO0DPGGcUoebu/Fi6ZPexJ0pTFDyCPnmL3u9soYhespcWJJsHjIYC/UHKoQkEUPkBFQJuCvbgCtr2AsjjhjTd4wNIp0ehOuYouOZbuKRg4cWPbUYRO1L+JE/eu1K+777nyJpcmO4W4ihzKQnMMl99kjOZoewwPtgTKqxAXLAdLnTicDyj0dSWjmNl7CFHESchFESrXED2lvPePVHI2t9DZgRu9pkt1h/4cwsEvETS2pKAQ3TAatGnOclM7pcQsJgJP2AvEYNBWA7kv38iaUo02nEO/sK4XslbuVFJPhZCqdZlXK9Ze+nGTJhdNHkmSuHvc9brLwmU6w53TOuJ8xc3z4aeQ5aecayoq4UW50VpvFPW96xEfyrHuKTvOEM9wEAfszVQ9n9KTYvNT61TiO+23DWeF2HgXwllC8rB9vp6SEUvUV0YGk8AMXaO7QPDqoUvgisQ8U
 FwD+D0Zy
 CN+ON1UOUePUE+pFKHScvKg+xuFl+iq2HXUTw1wds28SeOS3pa0XlS8alvWVSI2FCIEDsTaPtdUkheyFbrkainW+9k9rM5DnoSWpciXzZ4tHeiZEodrZnR7q5trwrRY2TT/nNvbQi+CNf81Wz33ylGV1SfiCE3FsFVf/yq6gi7fAzSTUjX4+hLFnz8P5whML4PR2t7Jj3MIDeNUC2Jc6Dw4uz0o+/t90OQYVmQT8QG3vrLsmpAik77/j8J8cfnXwC/ZK2laOhzS8xqgBQequfDSHyEA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, Apr 29, 2026 at 08:12:55AM +0200, David Hildenbrand (Arm) wrote:
>On 4/29/26 07:54, Lance Yang wrote:
>> 
>> On Tue, Apr 28, 2026 at 10:08:37PM -0700, Hugh Dickins wrote:
>>> On x86 32-bit with THP enabled, zap_huge_pmd() is seen to generate a
>>> "WARNING: mm/memory.c:735 at __vm_normal_page+0x6a/0x7d", from the
>>> VM_WARN_ON_ONCE(is_zero_pfn(pfn) || is_huge_zero_pfn(pfn)); followed
>>> by "BUG: Bad rss-counter state"s, then later "BUG: Bad page state"s
>>> when reclaim gets to call shrink_huge_zero_folio_scan().
>> 
>> Good catch!
>> 
>>> It's as if the _PAGE_SPECIAL bit never got set in the huge_zero pmd:
>>> and indeed, whereas pte_special() and pte_mkspecial() are subject to a
>>> dedicated CONFIG_ARCH_HAS_PTE_SPECIAL, pmd_special() and pmd_mkspecial()
>>> are subject to CONFIG_ARCH_SUPPORTS_PMD_PFNMAP, which is never enabled
>>> on any 32-bit architecture.
>>>
>>> Add CONFIG_ARCH_HAS_PMD_SPECIAL?  Perhaps; but I think it's better just
>>> to observe the huge_zero pmd in the fallback version of pmd_special().
>>>
>>> Fixes: d80a9cb1a64a ("mm/huge_memory: add and use normal_or_softleaf_folio_pmd()")
>
>Likely it should be
>
>	Fixes: d82d09e48219 ("mm/huge_memory: mark PMD mappings of the huge zero folio special")
>
>Because vm_normal_page_pmd() would return the wrong thing.

Right.

>But I am surprised that we didn't run into the
>
>	VM_WARN_ON_ONCE(is_zero_pfn(pfn) || is_huge_zero_pfn(pfn));
>
>earlier. 	

The history seems to be:

	2025-09-13 d82d09e48219 ("mm/huge_memory: mark PMD mappings of the huge zero folio special")
	2025-09-13 af38538801c6 ("mm/memory: factor out common code from vm_normal_page_*()")

After d82d09e48219, vm_normal_page_pmd() still had the explicit huge
zero check before returning the page:

--8<---
struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
				pmd_t pmd)
{
	unsigned long pfn = pmd_pfn(pmd);

	if (unlikely(pmd_special(pmd)))
		return NULL;

	if (unlikely(vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP))) {
		if (vma->vm_flags & VM_MIXEDMAP) {
			if (!pfn_valid(pfn))
				return NULL;
			goto out;
		} else {
			unsigned long off;
			off = (addr - vma->vm_start) >> PAGE_SHIFT;
			if (pfn == vma->vm_pgoff + off)
				return NULL;
			if (!is_cow_mapping(vma->vm_flags))
				return NULL;
		}
	}

	if (is_huge_zero_pfn(pfn))
		return NULL;
	if (unlikely(pfn > highest_memmap_pfn))
		return NULL;

	/*
	 * NOTE! We still have PageReserved() pages in the page tables.
	 * eg. VDSO mappings can cause them to exist.
	 */
out:
	return pfn_to_page(pfn);
}
---

So even if pmd_mkspecial() was a no-op and pmd_special() stayed false,
we would still return NULL there.

Then af38538801c6 moved the PMD path into __vm_normal_page():

---8<---
struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
				pmd_t pmd)
{
	return __vm_normal_page(vma, addr, pmd_pfn(pmd), pmd_special(pmd),
				pmd_val(pmd), PGTABLE_LEVEL_PMD);
}
---

For CONFIG_ARCH_HAS_PTE_SPECIAL=y, __vm_normal_page() only returns NULL
for the huge zero PFN if special == true. On x86 32-bit, pmd_special()
stays false, so this can now fall through to VM_WARN_ON_ONCE():

---8<---
	if (IS_ENABLED(CONFIG_ARCH_HAS_PTE_SPECIAL)) {
		if (unlikely(special)) {
			if (is_zero_pfn(pfn) || is_huge_zero_pfn(pfn))
				return NULL;
...
		}
...
	} else {
...
		if (is_zero_pfn(pfn) || is_huge_zero_pfn(pfn))
			return NULL;
	}

...
	VM_WARN_ON_ONCE(is_zero_pfn(pfn) || is_huge_zero_pfn(pfn));
...
---

So my guess is that the warning above became possible after
af38538801c6, IIUC.

>
>>> Signed-off-by: Hugh Dickins <hughd@google.com>
>>> ---
>>> include/linux/mm.h | 2 +-
>>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>>> index 0b776907152e..3b02ac43bcb7 100644
>>> --- a/include/linux/mm.h
>>> +++ b/include/linux/mm.h
>>> @@ -3422,7 +3422,7 @@ static inline pte_t pte_mkspecial(pte_t pte)
>>> #ifndef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
>>> static inline bool pmd_special(pmd_t pmd)
>>> {
>>> -	return false;
>>> +	return is_huge_zero_pmd(pmd);
>>> }
>> 
>> Emm ... feels a bit odd to me ...
>
>Agreed. But it could be a temporary fix until we fixed up relevant architectures.

Ah, got it :D

>> 
>> On these configs pmd_mkspecial() is still a no-op, so pmd_special()
>> would no longer really mean that the PMD was made special :)
>> 
>> Could we handle the huge zero PMD in vm_normal_page_pmd() instead?
>
>That adds unnecessary checks for architectures that properly implement pmd_special.
>
>pmd_special() should be fixed longterm on architectures that support THP
>and CONFIG_ARCH_HAS_PTE_SPECIAL. It should not be glued to CONFIG_ARCH_SUPPORTS_PMD_PFNMAP.
>
>
>arch/arc/Kconfig:       select HAVE_ARCH_TRANSPARENT_HUGEPAGE if ARC_MMU_V4
>arch/arm/Kconfig:       select HAVE_ARCH_TRANSPARENT_HUGEPAGE if ARM_LPAE
>arch/arm64/Kconfig:     select HAVE_ARCH_TRANSPARENT_HUGEPAGE
>arch/loongarch/Kconfig: select HAVE_ARCH_TRANSPARENT_HUGEPAGE
>arch/mips/Kconfig:      select HAVE_ARCH_TRANSPARENT_HUGEPAGE if CPU_SUPPORTS_HUGEPAGES
>arch/powerpc/platforms/Kconfig.cputype:       select HAVE_ARCH_TRANSPARENT_HUGEPAGE
>arch/riscv/Kconfig:     select HAVE_ARCH_TRANSPARENT_HUGEPAGE if 64BIT && MMU
>arch/s390/Kconfig:      select HAVE_ARCH_TRANSPARENT_HUGEPAGE
>arch/sparc/Kconfig:     select HAVE_ARCH_TRANSPARENT_HUGEPAGE
>arch/x86/Kconfig:       select HAVE_ARCH_TRANSPARENT_HUGEPAGE
>
>arch/arc/Kconfig:       select ARCH_HAS_PTE_SPECIAL
>arch/arm/Kconfig:       select ARCH_HAS_PTE_SPECIAL if ARM_LPAE
>arch/arm64/Kconfig:     select ARCH_HAS_PTE_SPECIAL
>arch/loongarch/Kconfig: select ARCH_HAS_PTE_SPECIAL
>arch/mips/Kconfig:      select ARCH_HAS_PTE_SPECIAL if !(32BIT && CPU_HAS_RIXI)
>arch/parisc/Kconfig:    select ARCH_HAS_PTE_SPECIAL
>arch/powerpc/Kconfig:   select ARCH_HAS_PTE_SPECIAL
>arch/riscv/Kconfig:     select ARCH_HAS_PTE_SPECIAL
>arch/s390/Kconfig:      select ARCH_HAS_PTE_SPECIAL
>arch/sh/Kconfig:        select ARCH_HAS_PTE_SPECIAL
>arch/sparc/Kconfig:     select ARCH_HAS_PTE_SPECIAL
>arch/x86/Kconfig:       select ARCH_HAS_PTE_SPECIAL
>
>That's a bit of work given that only arm64, powerpc (64), riscv and x86 (64)
>properly implement pmd_special().
>
>
>So I think Hugh's patch here makes sense for now.

Lesson learned :D thanks!
Lance

