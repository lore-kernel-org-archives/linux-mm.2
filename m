Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCF9ACCFA13
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 08:54:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 122D06B0088; Thu, 30 Apr 2026 04:54:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D3956B008A; Thu, 30 Apr 2026 04:54:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDD5C6B008C; Thu, 30 Apr 2026 04:54:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D7E756B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 04:54:16 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 98A75140495
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 08:54:15 +0000 (UTC)
X-FDA: 84714610470.10.350BD82
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id CFDC3140013
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 08:54:13 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ca6lUa67;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777539253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UfTVnsvX+8nbcKm1Sco/LUHH4f6rQH+LK+qnsavO0Ms=;
	b=L+PEEaVieN0/jamsT64uz4mlEsU2hr94VDRkSvGY8DkgY8oz3BNfp6Xm16le7XYgGZFdMm
	oQ/sQQqCHyD7NcfbU0ZvIOQBGWiZAKQyDa48zDvKDiXnBvSQ3wqlf9BywZ5qpflLpeKptj
	5bavqU4bXMMsOLpvLnh7YsO667ZaCbY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ca6lUa67;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777539253; a=rsa-sha256;
	cv=none;
	b=WXnP0PT8qNyvVMvyUIFgIFN33ahnDyUfVS154IWCh5VGvH/pYUL2i4uYJ6JagPC49gnmdq
	NsZWWOYIy3xzn5vr2bp+vTAnLCt9JxwMy8w2ag/I2bW86Hg29imV7pXu5lAX0IrRfhNMAl
	ZZI/y4xw7V1aJ6vdx8mtj6TmAmihIzQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1891E6015B;
	Thu, 30 Apr 2026 08:54:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA8BFC2BCB3;
	Thu, 30 Apr 2026 08:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777539252;
	bh=/wSBpmhqZapSeg9o/Z+i3bMhLelGt9xiGZSqJKvYzEs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Ca6lUa67G0BQk/1SldprKmnEN9e5LtFi5bJu2tDyflou/lt86Ktr4AFu0EgBWeW7A
	 C2mfdpw5lkG/qDNgmRhobXrVtY/4fG8LkiqFfL/rh1+OvEb6+JLR/91a2ttpaUwEwJ
	 19Zbx2V5R0dyGzey6/na7jYqY9AqIQua5j84t+D/uGiLIF+YSIHuWlSBEW9mMctdcu
	 GS6tqghZ/WGw9TRgm8u30CIEeU2UTiEFks45dz2xej0s/9ntDGDwmvznT/MHkIUmZS
	 lVuszu/QMa8pMb8Yxw9H+G3YS1IVBG9sutspYoztA3hxsibVnYnPO1gR4ZyXc3kQ28
	 IRq8rvnMFK7QQ==
Message-ID: <9845ff31-acaf-4a04-86a2-b4104446e966@kernel.org>
Date: Thu, 30 Apr 2026 10:54:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH hotfix] mm: fix pmd_special() fallback to observe
 huge_zero
To: Hugh Dickins <hughd@google.com>
Cc: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org,
 baolin.wang@linux.alibaba.com, baohua@kernel.org, dev.jain@arm.com,
 liam.howlett@oracle.com, ljs@kernel.org, mhocko@suse.com, rppt@kernel.org,
 npache@redhat.com, zhengqi.arch@bytedance.com, ryan.roberts@arm.com,
 surenb@google.com, ziy@nvidia.com, linux-mm@kvack.org
References: <e7cbc92b-ce9d-432a-ae5b-c8715dcd922f@kernel.org>
 <20260429065743.67054-1-lance.yang@linux.dev>
 <ea1453a6-14c9-4334-ac7e-2758586393b2@kernel.org>
 <aa3937bb-7f06-4136-ba36-ce4a06acf80a@linux.dev>
 <4d950326-6944-409b-b108-a4e67256857f@kernel.org>
 <e92e45df-0821-1d67-e026-88c57960814f@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <e92e45df-0821-1d67-e026-88c57960814f@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CFDC3140013
X-Stat-Signature: ticc517c5sxgjb3d6uzr5jgae9eciwf4
X-HE-Tag: 1777539253-494128
X-HE-Meta: U2FsdGVkX19hbA4PKl13lPHt5p1tZ6hgMKnRXxv+aeE+6ODQ+GAPfFZ8y3+XV+6/lB/85P8CxVyZTpjVsyEIJB5diQ3b+jt0SN+5y6h5fsJNVCffFdziVU/D48pp9HCCXICdpzhmBGYZBGZXJ9xvjsSQslkpk/AKpVg/9/nYpQaaSAPcZ6ESuJPLX5mtTGf6WCrehxcIpV/bpP1GDQir9VMtZIGJlAJ2zAHobdUxwT2USksygAFlcN6IqInyS4DKMIdyxBeGA3P6UAHyCt0nvhGcp2N0B7GFADEdyoGaTt1tXsk/xI2Cw6BQkXTeaxgFLLJPjhrKaIubweCIbB4CZKHMX5LEK2nBd1zETqSpXz8yjcNUURfDCsD8kg5No0Oa7NLs3M0TwfZCJRox22ikIWPtB626m0G1FzWclZGx9eI0J7HVHmtdbOOImV2vhvSu0Jqw/6e6enFGsXuQlGbfh3MIbQDXEVD3h0R9dwDFyruv+D1GxgN9k94OUrrLtPFzAxEQ8cdcmuTk7bvwlVIDCXVCvt26Go/KggdzAy8NvbwB3yosV1cYuBXYPOteK0oF6+V3gH7+qJiyfG8YfK75TYxO4a9PfwrN9y7oI/pfqj0NZFUUxJger7/GGkXRnt2TQSXOscyRsx8/NYvkPybH6GI2z9G/iCtycugHqMwOuZbaMBTKH1rbyAKeakXzdWW7YeG2Lm+YMfFhYPc2vIJR2R02XzyW8lrLTi5GGhQp4OggVKbPkq0FVxtqL/s6AfS2alhAj91TxuYCB2P1aJucc39d1O1GKyCachKo90YMmw8lYGTv7XtXPVRFXj8M5vI63zCKYBxDsR1Ld1xaZbq1/1YDAtXLnOon3gwBrCIxUBi7WhKs/NFO/7pxVe+OoIOEG1+APx58d4FUODG64VYRxHKsjMF9ehdq6oX6LFXcOwV8yFFejpUDTC5nQYxoZPA0l3UizWreNJSwkxfshnK
 vWSZq/x1
 hdldEtF0qAOPWNTK/yFPhQ5KAvHr08Nxq15kj2HsbwQ7ekKXPjQeJvHWoM46h5A4plwue/alAQHk/xtPmgsplqm4MupS9AIWNsKsw3+Odgm+85d0fFobBTdu+0E6egt5hiikITHg6G4J6SGRZOhb3wPZvoSgT0wZRikR2bTbzcC+VFsv/O2NaaG/N8FhQ/o1lsH/gOYODuTAYFOlEDQLWgDFVx/kyzahf9XRkzYuqePLxe6BiOfaEGLUl0eKR9zTItRnsWX7xecO4Id0klXNnip4kzeXuPf90YDqpzTggfAvn1D5nn+dk0v/sIMR0IwJT+hXDn6ZGfsSpRGX+cbnEjKHL5XhODS6Mwbrt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> ... and triggering the VM_WARN_ON_ONE(), although never reported so far.
>>
>> To fix it, teach vm_normal_page_pmd()/vm_normal_page_pud() whether
>> pmd_special/pud_special is actually implemented.
>>
>> Fixes: af38538801c6 ("mm/memory: factor out common code from vm_normal_page_*()")
> 
> Agreed.  My Fixes tag (where my bisection arrived) was correct for the
> common zap_huge_pmd() symptom I was seeing (Lorenzo's commit removed
> an independent is_huge_zero_pmd() check from it, so it now relies on
> vm_normal_folio_pmd() to give the right answer).  But you've chased
> up other usages, and realized it goes back further.  You could just as
> well blame the other commit mentioned in this thread, the d82d09e48219
> ("mm/huge_memory: mark PMD mappings of the huge zero folio special"),
> because in come configs it is not doing what it expects to be doing.
> But af38538801c6 is where effects start appearing, so fine to blame
> it (and both come from the same 6.18 series, do it doesn't matter).
> 
>> Signed-off-by: Hugh Dickins <hughd@google.com>>
>> Co-developed-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> That's generous, but the patch is not mine at all, and I'll
> happily let you grab my two paragraphs above.  Please, just

Okay, I didn't want to undermine your involvement.

> Reported-by: Hugh Dickins <hughd@google.com>

Then, I'd also add a

Debugged-by: Hugh Dickins <hughd@google.com>

> 
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>> ---
>>  mm/memory.c | 17 ++++++++++++++++-
>>  1 file changed, 16 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/memory.c b/mm/memory.c
>> index 7322a40e73b9..a60bc07b48b2 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -612,6 +612,21 @@ static void print_bad_page_map(struct vm_area_struct *vma,
>>  	dump_stack();
>>  	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
>>  }
>> +
>> +static inline bool pgtable_level_has_pxx_special(enum pgtable_level level)
>> +{
>> +	switch (level) {
>> +	case PGTABLE_LEVEL_PTE:
>> +		return IS_ENABLED(CONFIG_ARCH_HAS_PTE_SPECIAL);
>> +	case PGTABLE_LEVEL_PMD:
>> +		return IS_ENABLED(CONFIG_ARCH_SUPPORTS_PMD_PFNMAP);
>> +	case PGTABLE_LEVEL_PUD:
>> +		return IS_ENABLED(CONFIG_ARCH_SUPPORTS_PUD_PFNMAP);
>> +	default:
>> +		return false;
>> +	}
>> +}
>> +
>>  #define print_bad_pte(vma, addr, pte, page) \
>>  	print_bad_page_map(vma, addr, pte_val(pte), page, PGTABLE_LEVEL_PTE)
>>  
>> @@ -684,7 +699,7 @@ static inline struct page *__vm_normal_page(struct vm_area_struct *vma,
>>  		unsigned long addr, unsigned long pfn, bool special,
>>  		unsigned long long entry, enum pgtable_level level)
>>  {
>> -	if (IS_ENABLED(CONFIG_ARCH_HAS_PTE_SPECIAL)) {
>> +	if (pgtable_level_has_pxx_special(level)) {
>>  		if (unlikely(special)) {
>>  #ifdef CONFIG_FIND_NORMAL_PAGE
>>  			if (vma->vm_ops && vma->vm_ops->find_normal_page)
> 
> That block ends with a comment on CONFIG_ARCH_HAS_PTE_SPECIAL:
> perhaps better reworded now - but I don't know what to suggest!

Good point, let me take a loook.

> 
> This patch seems okay, but TBH I have no enthusiasm for it -
> it forces me to think too hard, and I prefer my own one-liner
> (iwhich Lance found odd: odd if you're thinking pmd_special(pmd)
> means pmd has the _PAGE_SPECIAL bit set, yes, but not odd if you
> think it means that pmd is of a special folio).

If pmd_mkspecial() is a nop I'd prefer that pmd_special() is similarly a nop.

> 
> But whatever, you and Lance prefer this one: thanks for the fix!

Thank you Hugh. I'll send out my version officially, and if there are strong
opinions against it we can just use your variant.

-- 
Cheers,

David

