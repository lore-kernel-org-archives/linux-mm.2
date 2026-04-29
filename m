Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14989FF8864
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 07:14:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FDC06B0005; Wed, 29 Apr 2026 03:14:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AECE6B008A; Wed, 29 Apr 2026 03:14:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49D7F6B008C; Wed, 29 Apr 2026 03:14:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 369706B0005
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 03:14:16 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B0F291A078B
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 07:14:15 +0000 (UTC)
X-FDA: 84710729670.03.FD44236
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0153414000D
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 07:14:13 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VtXAsceR;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777446854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GTXnq8+oFSgzjVWXXIm1Cg7w9hyeWjIwPeRUPNNCkjA=;
	b=o/ckCtNW2D6YpijafmgQIGBqjLYvw+14im+3wW9uYoFdWTYbQgYbwZg26p9eU6Jt1wxrmn
	Ex94UUl4k10y8DY4Z/oZ/6JIhRXMk5TdTbf1Ha7FBwJaNI4vskwMUaE3S2S5TS/Ybu+Pls
	OR0BZqOfDdSfZSnNBDVi+EBpNDb+DMU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VtXAsceR;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777446854; a=rsa-sha256;
	cv=none;
	b=O3K0n6BscH1hgRE8eJZUxYzB4N8usY46zEfMwFWLYXGmv7jNzjfRaVVQ+1NtYXIRWIGLha
	a7kzQTXY5kzLu0eAc6Pk7s3lmkHYYRJkAgzK7M25H33ae8fhdr/UtObxsNE6naEdVp9HU3
	LFJx6TcGU4OKhDQuLQttWqB55p/sU/Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5707861119;
	Wed, 29 Apr 2026 07:14:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C1BDC19425;
	Wed, 29 Apr 2026 07:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777446853;
	bh=ipUmxCQGmvMN0iPV6jBK/WQpSWhkisDZdd3tSXVYk1U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VtXAsceR9C8okBBULjc2eiXi1M1ejfc3LFjuCJTFqBng6bWVDYvaUNmdFVcDFku5P
	 RySSmRZ8s5lxL01Td6tJBw0ddos3n6iuj8k3py01syeZalOcRqV0Vuki/QrrnkjWsJ
	 RmK1Kgml0DHBLQgTPccciLKQC7dE/H0yYQHdxwPPD7r36b48cbCfpK23CZvmN789FD
	 FLle1egT0w0Igyrw1HwImr3al0TLhSifeLDG+yxBk0r91ChTzuTjH83BMTtl+/4HTR
	 ulHkauXx2HRDodl4rjSO8zhvEP6uargrnzFdkYG4OlsI4wKQ7tf0tUG6u5nmrj8G76
	 37QjldtIZgolw==
Message-ID: <ea1453a6-14c9-4334-ac7e-2758586393b2@kernel.org>
Date: Wed, 29 Apr 2026 09:14:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH hotfix] mm: fix pmd_special() fallback to observe
 huge_zero
To: Lance Yang <lance.yang@linux.dev>, hughd@google.com
Cc: akpm@linux-foundation.org, baolin.wang@linux.alibaba.com,
 baohua@kernel.org, dev.jain@arm.com, liam.howlett@oracle.com,
 ljs@kernel.org, mhocko@suse.com, rppt@kernel.org, npache@redhat.com,
 zhengqi.arch@bytedance.com, ryan.roberts@arm.com, surenb@google.com,
 ziy@nvidia.com, linux-mm@kvack.org
References: <e7cbc92b-ce9d-432a-ae5b-c8715dcd922f@kernel.org>
 <20260429065743.67054-1-lance.yang@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260429065743.67054-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0153414000D
X-Rspam-User: 
X-Stat-Signature: tx94ryi71kfrcdhuyfszmuyr38m459gw
X-HE-Tag: 1777446853-159137
X-HE-Meta: U2FsdGVkX1+yhMPJ5TAIa8Q92hdzXh3brYlatwFjNmvqsv60OmXnMp1O6b6HfuDnfMUQChgSbBrK5lIjCdEorFNtCzVMgWNqH/A/igJifcmd/XDyFO84bZ5brPZfRdbfx+hZH/4S0RAJtDkzkBmuc+UVHCcdGbJGcBawspn40jN1LxxjzaeQa7RXvbA8MGEVjPdrBFQ5wE7b1wr71yM7hOqZVxRQeE1ORIoST0MEBH3LELgG5qlKrumDmeQqgLSikEvcxridxCQLHO5KqFe0RZdF5A4N0EYdPGjIy7nLVBw/hNZEzFHfSnfB3L+rkn76xIr8+QqqSOyLlGVkXxb+0jItMdexNivsYpsmX75IJGr/vta41I46uRAG+WcO/9oUU+XCXxZ7rTv12O5jXcb4OLip7vV35rd+T6aDbnqc2Dn6RB4MyA8FmQ5+eqsiZfKYn1+bXL1jLIz9/0Y71OmezN96zlZ+9tfbmny+KsjpKJHTfA2Soa1jwUltKCCTTg2PByyr05AkOhLBAGuZClW5QdH5axT2DC7kEL9ESpcfBO7wVOb4WtoPMazGI148ytWV60mO1m8xCxj81Mxv32uS4ce0TNUGg+duEtMTaHNQ/6xfBaAc68TolmIfGjlSYsYnLVa17tfzaLSkwrj1NwYqE9raIC9HX9Vux+HQWD+WjItsqwuZkDZBADALhwvOHt/LH3Duq44dC+WYl0pPuN0mD6HSyk2YnETMKR/3DaUhUJXCALWLI4Gid3DKUNMOUc29DKJo7kBtaMem/baFP/Tiu4AhZEFz0/GpTnJRK45mDa8gDN+uIGQR6EL/105cCOjiAzIcYx7kPN0kFEAJqsrDRq+FFml83cIjHBishz8uTQ7WisoksUgMgIkvLh2TioEAqY53XAqcr53IZjm1hx2cHeYGEqRXJYc42CDkKDt3ke+dxuX0vSdX3A02GuyNYVPG56Xun1YNcM0hQRb1AgP
 Plzdv2Rb
 +5b45qvCwy9PaZ6q3NzGugkcpY7R8kOJduQVXHT/mMCE6iLP+MW/x8PcJJVt1/57V6BVgDDi/MKPmevoZCgndBjmqIaR/Zg69CMXuavcghBTmEZuno4yPBhIB+iTF+DOOeeJBIxmErzuzxnU63Khk0OnPzsz6c6TCp6xcbaSZ3pj0Ia1wt8bgGK+/7d+c/flMt7Ifpopz0B+V5Vtx7keLw2p5kTlyxcumbosLL/ZdPvBHhVeCfdYd3wddO1I/15H3I3rvj5acpkXCsbLLmFEmQ6Bycc0fdBmJ619e762omn0IkzDoxLMSPkSh/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/29/26 08:57, Lance Yang wrote:
> 
> On Wed, Apr 29, 2026 at 08:12:55AM +0200, David Hildenbrand (Arm) wrote:
>> On 4/29/26 07:54, Lance Yang wrote:
>>>
>>>
>>> Good catch!
>>>
>>
>> Likely it should be
>>
>> 	Fixes: d82d09e48219 ("mm/huge_memory: mark PMD mappings of the huge zero folio special")
>>
>> Because vm_normal_page_pmd() would return the wrong thing.
> 
> Right.
> 
>> But I am surprised that we didn't run into the
>>
>> 	VM_WARN_ON_ONCE(is_zero_pfn(pfn) || is_huge_zero_pfn(pfn));
>>
>> earlier. 	
> 
> The history seems to be:
> 
> 	2025-09-13 d82d09e48219 ("mm/huge_memory: mark PMD mappings of the huge zero folio special")
> 	2025-09-13 af38538801c6 ("mm/memory: factor out common code from vm_normal_page_*()")
> 
> After d82d09e48219, vm_normal_page_pmd() still had the explicit huge
> zero check before returning the page:
> 
> --8<---
> struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
> 				pmd_t pmd)
> {
> 	unsigned long pfn = pmd_pfn(pmd);
> 
> 	if (unlikely(pmd_special(pmd)))
> 		return NULL;
> 
> 	if (unlikely(vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP))) {
> 		if (vma->vm_flags & VM_MIXEDMAP) {
> 			if (!pfn_valid(pfn))
> 				return NULL;
> 			goto out;
> 		} else {
> 			unsigned long off;
> 			off = (addr - vma->vm_start) >> PAGE_SHIFT;
> 			if (pfn == vma->vm_pgoff + off)
> 				return NULL;
> 			if (!is_cow_mapping(vma->vm_flags))
> 				return NULL;
> 		}
> 	}
> 
> 	if (is_huge_zero_pfn(pfn))
> 		return NULL;
> 	if (unlikely(pfn > highest_memmap_pfn))
> 		return NULL;
> 
> 	/*
> 	 * NOTE! We still have PageReserved() pages in the page tables.
> 	 * eg. VDSO mappings can cause them to exist.
> 	 */
> out:
> 	return pfn_to_page(pfn);
> }
> ---
> 
> So even if pmd_mkspecial() was a no-op and pmd_special() stayed false,
> we would still return NULL there.
> 
> Then af38538801c6 moved the PMD path into __vm_normal_page():
> 
> ---8<---
> struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
> 				pmd_t pmd)
> {
> 	return __vm_normal_page(vma, addr, pmd_pfn(pmd), pmd_special(pmd),
> 				pmd_val(pmd), PGTABLE_LEVEL_PMD);
> }
> ---
> 
> For CONFIG_ARCH_HAS_PTE_SPECIAL=y, __vm_normal_page() only returns NULL
> for the huge zero PFN if special == true. On x86 32-bit, pmd_special()
> stays false, so this can now fall through to VM_WARN_ON_ONCE():
> 
> ---8<---
> 	if (IS_ENABLED(CONFIG_ARCH_HAS_PTE_SPECIAL)) {
> 		if (unlikely(special)) {
> 			if (is_zero_pfn(pfn) || is_huge_zero_pfn(pfn))
> 				return NULL;
> ...
> 		}
> ...
> 	} else {
> ...
> 		if (is_zero_pfn(pfn) || is_huge_zero_pfn(pfn))
> 			return NULL;
> 	}
> 
> ...
> 	VM_WARN_ON_ONCE(is_zero_pfn(pfn) || is_huge_zero_pfn(pfn));
> ...
> ---
> 
> So my guess is that the warning above became possible after
> af38538801c6, IIUC.

Yes, I think you are right about af38538801c6.

What about the following then as a temporary solution:

diff --git a/mm/memory.c b/mm/memory.c
index 199214f8de08..bf447c8b2f57 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -684,7 +684,9 @@ static inline struct page *__vm_normal_page(struct vm_area_struct *vma,
                unsigned long addr, unsigned long pfn, bool special,
                unsigned long long entry, enum pgtable_level level)
 {
-       if (IS_ENABLED(CONFIG_ARCH_HAS_PTE_SPECIAL)) {
+       if ((IS_ENABLED(CONFIG_ARCH_HAS_PTE_SPECIAL) && level == PGTABLE_LEVEL_PTE) ||
+           (IS_ENABLED(CONFIG_ARCH_SUPPORTS_PMD_PFNMAP) && level == PGTABLE_LEVEL_PMD) ||
+           (IS_ENABLED(CONFIG_ARCH_SUPPORTS_PUD_PFNMAP) && level == PGTABLE_LEVEL_PUD)) {
                if (unlikely(special)) {
 #ifdef CONFIG_FIND_NORMAL_PAGE
                        if (vma->vm_ops && vma->vm_ops->find_normal_page)


We could wrap the check in a fancy helper.

-- 
Cheers,

David

