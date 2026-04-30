Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CEDACD1297
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 05:53:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 592F26B0088; Thu, 30 Apr 2026 01:53:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 543A26B008A; Thu, 30 Apr 2026 01:53:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 431FB6B008C; Thu, 30 Apr 2026 01:53:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3368B6B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 01:53:17 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8397C1B96D7
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 05:53:16 +0000 (UTC)
X-FDA: 84714154392.03.53256E4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id BFC921C0006
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 05:53:14 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=piHvu1VH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777528394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cEO3O+OLsQzrqvzI/DwdiPlbyqpiLEz1N3J2b+p8B4Q=;
	b=5PyumzbyXsCuJkS0c7NbUoeaA8fgzeAlZqqU8qONk+BQusULa6PuaMxKOSOLcXxUdOJo9k
	yNnVAc8FWJ62HOGfuPp0CzwgvP4My64wiOLPaSFcjX/fqT8VGl5iiCND9Kqy35oG3A324c
	9jHwOu6zqVZz+gZlPtRLkno1SoZFs04=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777528394; a=rsa-sha256;
	cv=none;
	b=GjFMVl1VY9GtdsRryR3CSPN5IsSyRHSVAPsaT2mYtoio6vNd/QXBqd4XcbmrDyTQ6tN0dG
	DQOiuXnH8w9A1BSExUkrOaot8/85rXxfKN2/sasuajSCdcrviPsZOQ+I0rmwmDVQx5WNEi
	huBCpCGJ+fah0uUMJM1YX3KXlP+SCc4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=piHvu1VH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E814061143;
	Thu, 30 Apr 2026 05:53:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05892C2BCB8;
	Thu, 30 Apr 2026 05:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777528393;
	bh=MjWOpBdaGzrb9lnmgplclBG1fnyUbOtnWd/eVcxMw9c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=piHvu1VHshGkqtmKhqphJsf1GgDUzknbuMpIJHH+xMPGtMlSpsgDhzv6pF1HcHLv0
	 fGz7ASWFMTf24BN6CdZZ8esjt3tvvK58Au0+XqnuxruNRQ58W/8npMPAVsNRRKZhr5
	 /PauiaQvPVcPcRsY0KygVQQY1hA/hOyrsj0Z5+CS0AeyqV7EU9HTZTPKmNOQ5YgW/k
	 PBHWhcMBnmpwROguF+qu3xesZFHrqiwnCyBZoVtqNLY8LJ/FoaaK+L3BaY17v6YTcm
	 t68POF3Cv5fK4iKMguiAgXWmZHR01ts96jnJgzwq290oU+KkndWp5bHFUaPs989lme
	 J04iujk4t8uwg==
Message-ID: <4d950326-6944-409b-b108-a4e67256857f@kernel.org>
Date: Thu, 30 Apr 2026 07:53:05 +0200
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
 <ea1453a6-14c9-4334-ac7e-2758586393b2@kernel.org>
 <aa3937bb-7f06-4136-ba36-ce4a06acf80a@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aa3937bb-7f06-4136-ba36-ce4a06acf80a@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BFC921C0006
X-Stat-Signature: 31d51ehmka1dd5roukuraoswjh1ze88y
X-Rspam-User: 
X-HE-Tag: 1777528394-450333
X-HE-Meta: U2FsdGVkX18OBe0vPMVklOBT4dE5aYF09DHtAy/tvzu6ZYFWZisBPzI+lAY6tceTgMlggacQFJrj/o8BAySiYyN6WS2aZ7D1iAPB2KaCGXu/fxKixfFpU92x2AW+SkENUKkOtFrnMoZDiGLUcf70GblhHuXO7ajOi/E7baf982obRHOoLHJTLRMmvd5WEw6VcVDsVJvcpQMyqy41XBMNXFwxjx9ko1T08QyK0MZHK/vynAQ3mg1kUxezyT+neoS9EugdEheh6vRjAO0o+VZl/sAqB1C7K4g2gRtJF9ZFPJySLxlevJwWGbuM5ItUXTnHvUpOfJoCBnK6HsnjUpwkfWu4wgaJljowoC8EUGqZQKJEGFc4M0nZwpgpjy8rq7bOjmoMWyNk0o2K4wxBJp/0+/fdDL6yg2779fQi52Qw7UWmxnqKNDuO4TWNdjyEUCvzRQKWxT+sxjTIEKP/6sgoWzHopzKmnziVOavJkqIqSWVLd1BxPKK0HNsy0HQVW31hXcWv1/IRxzxSst7X2zmdxVCgWv483UeBc8eXnp4XuZw++JKGS8rFNuh5wflZ5ss0j1u5rRZPU8f27NQZxSig9texi5vv2VGaCYbES7KVgrilIExwDoOewxcsQlGd9Av99+DGdFlfDuPVLTET1TSeaXo+5xl4006c1l7tmJ2PNp6l7bNW8o9HwY8sViPFhmYlavmr3VazVCEJ8ZezbHjvrplS09p262ki6fp/UwHnlTBj/xOQl3mjxG7+p9BinGPUTB7zbll0IxUOPd1IpsaC9T5M+uY330buOybCUZ/3FwAKjz484/SzV5x8XjIgBwKQEG1BGnXMLV3Uh7EHlxcB/t/2o0w7cJcatSohcGIvpjf7erry0o4Qg4lhX/6HCZRlDdq/VQYYAjkZAVYx9ur922K6ZSt36kqHbYX90eooZK6GfbO+RfNr2hziMNtwndlqNCMhsKIR/t1cJ9Lh96c
 P6Ru01Et
 HSh4Kf28MnYkaiQ3DNeOqC1jBsdBQ/6gseVZGVnFSUdCZf3ANeNF7fsQ6cc1eiW7Mw4pranauhRaFLBuZlGHgcwfGuqoRiVdFNXijJkwJr+bEz/uQouVgZKxPctnJIPZITWa4JNuUT+Gl0l6VWKGty5mpcGV+eQ4LVxphS6I8PcGUV6yJ+uTXJFagRSEWxi/2GPPM0v2nKKm2ThkSNKIhM+WbpzZYHN7yeGlv30RH5NEgR/QtASw1BzUtyTZfxTu/4W+4Oa6M5l6fftWsFnOdfHoXLaN64bNKAypDF5kXTbm4sy4qYXtRfAouN28TummVtvmC4OC8daSwUL4fv3JJsUTypomDnmTA3wBQsdbI2OV5Sq/OSN23NMn8fVyeGCBrbfr6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/29/26 09:33, Lance Yang wrote:
> 
> 
> On 2026/4/29 15:14, David Hildenbrand (Arm) wrote:
>> On 4/29/26 08:57, Lance Yang wrote:
>>>
>>>
>>> Right.
>>>
>>>
>>> The history seems to be:
>>>
>>>     2025-09-13 d82d09e48219 ("mm/huge_memory: mark PMD mappings of the huge
>>> zero folio special")
>>>     2025-09-13 af38538801c6 ("mm/memory: factor out common code from
>>> vm_normal_page_*()")
>>>
>>> After d82d09e48219, vm_normal_page_pmd() still had the explicit huge
>>> zero check before returning the page:
>>>
>>> --8<---
>>> struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
>>>                 pmd_t pmd)
>>> {
>>>     unsigned long pfn = pmd_pfn(pmd);
>>>
>>>     if (unlikely(pmd_special(pmd)))
>>>         return NULL;
>>>
>>>     if (unlikely(vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP))) {
>>>         if (vma->vm_flags & VM_MIXEDMAP) {
>>>             if (!pfn_valid(pfn))
>>>                 return NULL;
>>>             goto out;
>>>         } else {
>>>             unsigned long off;
>>>             off = (addr - vma->vm_start) >> PAGE_SHIFT;
>>>             if (pfn == vma->vm_pgoff + off)
>>>                 return NULL;
>>>             if (!is_cow_mapping(vma->vm_flags))
>>>                 return NULL;
>>>         }
>>>     }
>>>
>>>     if (is_huge_zero_pfn(pfn))
>>>         return NULL;
>>>     if (unlikely(pfn > highest_memmap_pfn))
>>>         return NULL;
>>>
>>>     /*
>>>      * NOTE! We still have PageReserved() pages in the page tables.
>>>      * eg. VDSO mappings can cause them to exist.
>>>      */
>>> out:
>>>     return pfn_to_page(pfn);
>>> }
>>> ---
>>>
>>> So even if pmd_mkspecial() was a no-op and pmd_special() stayed false,
>>> we would still return NULL there.
>>>
>>> Then af38538801c6 moved the PMD path into __vm_normal_page():
>>>
>>> ---8<---
>>> struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
>>>                 pmd_t pmd)
>>> {
>>>     return __vm_normal_page(vma, addr, pmd_pfn(pmd), pmd_special(pmd),
>>>                 pmd_val(pmd), PGTABLE_LEVEL_PMD);
>>> }
>>> ---
>>>
>>> For CONFIG_ARCH_HAS_PTE_SPECIAL=y, __vm_normal_page() only returns NULL
>>> for the huge zero PFN if special == true. On x86 32-bit, pmd_special()
>>> stays false, so this can now fall through to VM_WARN_ON_ONCE():
>>>
>>> ---8<---
>>>     if (IS_ENABLED(CONFIG_ARCH_HAS_PTE_SPECIAL)) {
>>>         if (unlikely(special)) {
>>>             if (is_zero_pfn(pfn) || is_huge_zero_pfn(pfn))
>>>                 return NULL;
>>> ...
>>>         }
>>> ...
>>>     } else {
>>> ...
>>>         if (is_zero_pfn(pfn) || is_huge_zero_pfn(pfn))
>>>             return NULL;
>>>     }
>>>
>>> ...
>>>     VM_WARN_ON_ONCE(is_zero_pfn(pfn) || is_huge_zero_pfn(pfn));
>>> ...
>>> ---
>>>
>>> So my guess is that the warning above became possible after
>>> af38538801c6, IIUC.
>>
>> Yes, I think you are right about af38538801c6.
>>
>> What about the following then as a temporary solution:
> 
> Nice, that works for me :)

Okay, I'd say we do the following:

From fd9ead548f102f7c257980ccc7b96cce7e42a570 Mon Sep 17 00:00:00 2001
From: Hugh Dickins <hughd@google.com>
Date: Thu, 30 Apr 2026 07:35:31 +0200
Subject: [PATCH] mm: fix pmd_special() fallback to observe huge_zero

On x86 32-bit with THP enabled, zap_huge_pmd() is seen to generate a
"WARNING: mm/memory.c:735 at __vm_normal_page+0x6a/0x7d", from the
VM_WARN_ON_ONCE(is_zero_pfn(pfn) || is_huge_zero_pfn(pfn)); followed
by "BUG: Bad rss-counter state"s, then later "BUG: Bad page state"s
when reclaim gets to call shrink_huge_zero_folio_scan().

It's as if the _PAGE_SPECIAL bit never got set in the huge_zero pmd:
and indeed, whereas pte_special() and pte_mkspecial() are subject to a
dedicated CONFIG_ARCH_HAS_PTE_SPECIAL, pmd_special() and pmd_mkspecial()
are subject to CONFIG_ARCH_SUPPORTS_PMD_PFNMAP, which is never enabled
on any 32-bit architecture.

While the problem was exposed through d80a9cb1a64a ("mm/huge_memory: add
and use normal_or_softleaf_folio_pmd()"), it was an oversight in
af38538801c6 ("mm/memory: factor out common code from vm_normal_page_*()")
and would result in other problems:
* huge zero folio accounted in smaps, pagemap (PAGE_IS_FILE) and
  numamaps as file-backed THP
* folio_walk_start() returning the folio even without FW_ZEROPAGE set.
  Callers seem to tolerate that, though.

... and triggering the VM_WARN_ON_ONE(), although never reported so far.

To fix it, teach vm_normal_page_pmd()/vm_normal_page_pud() whether
pmd_special/pud_special is actually implemented.

Fixes: af38538801c6 ("mm/memory: factor out common code from vm_normal_page_*()")
Signed-off-by: Hugh Dickins <hughd@google.com>>
Co-developed-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/memory.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index 7322a40e73b9..a60bc07b48b2 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -612,6 +612,21 @@ static void print_bad_page_map(struct vm_area_struct *vma,
 	dump_stack();
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
 }
+
+static inline bool pgtable_level_has_pxx_special(enum pgtable_level level)
+{
+	switch (level) {
+	case PGTABLE_LEVEL_PTE:
+		return IS_ENABLED(CONFIG_ARCH_HAS_PTE_SPECIAL);
+	case PGTABLE_LEVEL_PMD:
+		return IS_ENABLED(CONFIG_ARCH_SUPPORTS_PMD_PFNMAP);
+	case PGTABLE_LEVEL_PUD:
+		return IS_ENABLED(CONFIG_ARCH_SUPPORTS_PUD_PFNMAP);
+	default:
+		return false;
+	}
+}
+
 #define print_bad_pte(vma, addr, pte, page) \
 	print_bad_page_map(vma, addr, pte_val(pte), page, PGTABLE_LEVEL_PTE)
 
@@ -684,7 +699,7 @@ static inline struct page *__vm_normal_page(struct vm_area_struct *vma,
 		unsigned long addr, unsigned long pfn, bool special,
 		unsigned long long entry, enum pgtable_level level)
 {
-	if (IS_ENABLED(CONFIG_ARCH_HAS_PTE_SPECIAL)) {
+	if (pgtable_level_has_pxx_special(level)) {
 		if (unlikely(special)) {
 #ifdef CONFIG_FIND_NORMAL_PAGE
 			if (vma->vm_ops && vma->vm_ops->find_normal_page)
-- 
2.43.0



-- 
Cheers,

David

