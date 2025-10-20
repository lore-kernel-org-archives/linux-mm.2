Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4E69CCD199
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 11:04:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DD648E000D; Mon, 20 Oct 2025 07:04:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B53E8E0002; Mon, 20 Oct 2025 07:04:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CAFF8E000D; Mon, 20 Oct 2025 07:04:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0E9F28E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 07:04:23 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A1F22114CEF
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 11:04:22 +0000 (UTC)
X-FDA: 84018208764.25.69524FB
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2C0DE4000F
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 11:04:19 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=biusHwYs;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf17.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760958261; a=rsa-sha256;
	cv=none;
	b=qTLMRnkswMxDDiBqFoh0UxCco3/wIycAVBp3mgOQepShTgb9kpGbYyKmNENQj//QWw95yn
	WDmwGBsCA6Z4oF4dMEGPV20Ne82FwqubEXJpEUdNiOKcVVwlbYEziJfvfZR6rTq2RdEAOV
	2qbMEnTgjL/Fw3H6CJx/9IN9mpos4EM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=biusHwYs;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf17.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760958261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b+3d8uC7KF4xfmtSqoZNFp1K71/AwpCYuc/qfKAkSII=;
	b=emcAJuDBIRJj36+BKlsPxjwBQpHcEQZmFg9qKAj5utStr8aLGLrpLWvPSLYC7N2C1ZOcsg
	F28v7xRxh6Frkci/De/gTbYepn4UacWqVp6J3paIb59Hem8oftnFjQvySB6dyd+Dp5BKrZ
	u2g9YU8UdR8eh1rcFH44ZeVJQ4rNRuE=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1760958257; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=b+3d8uC7KF4xfmtSqoZNFp1K71/AwpCYuc/qfKAkSII=;
	b=biusHwYsHnbGgloznpu7Fog1tN9uFndWCCgwrpbggYMnjff5rujvQO2jxJpR/7i9vhiQa8waWRCm/r176O3KXxveVquvvBKRna+fY8RLUKhDNxVruYBzFkHhfssllwR+HLavsb2tnYqAgM8AD6cIVJ1uANV+Y0OfPOGqlVJfSOY=
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0WqakbIX_1760958255 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 20 Oct 2025 19:04:16 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,  Will Deacon
 <will@kernel.org>,  Ryan Roberts <ryan.roberts@arm.com>,  Gavin Shan
 <gshan@redhat.com>,  Ard Biesheuvel <ardb@kernel.org>,  "Matthew Wilcox
 (Oracle)" <willy@infradead.org>,  Yicong Yang <yangyicong@hisilicon.com>,
  linux-arm-kernel@lists.infradead.org,  linux-kernel@vger.kernel.org,
  linux-mm@kvack.org
Subject: Re: [PATCH] arm64, mm: avoid always making PTE dirty in pte_mkwrite()
In-Reply-To: <0e6d1f1f-a917-4e36-80de-03ba94c6d850@arm.com> (Anshuman
	Khandual's message of "Mon, 20 Oct 2025 07:39:51 +0530")
References: <20251015023712.46598-1-ying.huang@linux.alibaba.com>
	<aPKFmHg-FrkGJxWd@arm.com>
	<0e6d1f1f-a917-4e36-80de-03ba94c6d850@arm.com>
Date: Mon, 20 Oct 2025 19:04:14 +0800
Message-ID: <87o6q1dec1.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2C0DE4000F
X-Stat-Signature: kyuxwz3k7jzirk8t4zug8smjicte1wur
X-HE-Tag: 1760958259-345801
X-HE-Meta: U2FsdGVkX19o+Rick98gpMkL+FevrkU3n35+tYTWu7jTq26h/pwOj9q+i6vZTd3XeUXK/fMU2AyXoodxI6neaFbcpD9h+bCZdCAPaSjJigwZPU8RjIHKATxCos8KgNo38eQyyAkG8JNcAWWd8Nde87LJnLqjx3isck2iS1FXsaXEJRcvXiZYT9ddrh4YbKTg87IUvdBxkp0Kv7glTjqy0iN1+ObB5zBspEKhCppTDKfVtzkbUmD7OsMnRpnRYgzP2dlMfMT0VgB5wGRSEAuEx9gAtiw8e6VwxJUHwCEduRykrdhqhBd++5f96lZquwtI8GmLEKAnCntPU9YTArm3w2vfdovAJTbPiEta54OKPbrObWBuGqZkGDkn9PV566BM7AzO7+Klx4GSn/Bgb2GLbReo1WJl6+A8JPCM9E6MY4T/6wK7ntSxiEAlVkntsv7OimSRQ+9DFb0DQ1jNTXx1WNMUitFjfI/47NTdAD+6v+nggcpjAxUziU8/edSJPlolrw2M0HdmcCoTBLkGOxME43TdPIkINsKMUVoV4g3vXcX5VhhG/yZ3l/39vrHjjA3TAfRW7tn9eSrDwnog5elH3WV45z9zSsstbYEBSzAmMFNpM1kG4gAqYXpnD3ZQ1dSR4ytr3so+Mfnf3AwFthgbaaN0d3ysHLe1uqGSMy7IVd05Hb1LXbzoI8WyB48x5oe7+DCcQjqduRKVSddy2dfXoHYvf2fjDzMwts3Og7o1cU4IlLB239fThr0IYLpvLTCigMC7WGHFTq5v460bz9701HfNBYIYvdFvhlZVBamYJaMZxBuKpAeWYKgcUaVKmL27QCkj716Kq9RyjeaRz+5FQdFVIZWnzS1c4Hrgi+cL4EmwMMsgAkylX7cUAf3QUFg3iYzoL/tD03Z37rU2JgozhHpeV4WAEgirNdq8BnnCy4Uk0g6H0rxnFqggEuV1OIlvn26bZ3lxKW5r+PXF65d
 AvqS152e
 YNMBz9yve6YDXYnNZT6VwtZssk5IBSeJFeEGtxRIAN2o3LQ6tir6HXgSMnvHKIx7q6krOG3U2qvSL1N0AKe5gHFq7Gae/w7eBjP/fUPdijLmJ5JVueHkakT6ngRAZR8Y3wo3B7JRIVnbZrbws5a0rL+0+FAuc8OHNLD59zzY8a9Co4fac74der5TMjknYgC00MEy9NUtCKwT3fQUxFDr91vdt5A2aovhjGNOpLOK8+xAdIGiGjln+uNOtCWiNsb/IqvtwBnlC6uZQu6Pu0kC5Cje3jBV2Es/arjr6Wa/CE4nel1VJtmE5Wq1XhFlMuUX3lk/HLJ4TaBP9yHRCZVTK/9XynCEePS/yFuhZHgbVw597cSjtTNfWJ7r8XKe0DyiVj3aZIuYHPaghFCHcMC+3tKml1OxaPfDs5kPQr3b/zSMQbUGtPViDkUvmqE8vKVZh/xCdn9Bz3myxwwls5xhzWeTrklPJ9o+DPY0T8pSerWm9uJojIDwSLVVDj/TaVtBLFu+wTRWHyzz0Ii16nvnGBS1oeQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Anshuman,

Anshuman Khandual <anshuman.khandual@arm.com> writes:

> On 17/10/25 11:36 PM, Catalin Marinas wrote:
>> On Wed, Oct 15, 2025 at 10:37:12AM +0800, Huang Ying wrote:
>>> Current pte_mkwrite_novma() makes PTE dirty unconditionally.  This may
>>> mark some pages that are never written dirty wrongly.  For example,
>>> do_swap_page() may map the exclusive pages with writable and clean PTEs
>>> if the VMA is writable and the page fault is for read access.
>>> However, current pte_mkwrite_novma() implementation always dirties the
>>> PTE.  This may cause unnecessary disk writing if the pages are
>>> never written before being reclaimed.
>>>
>>> So, change pte_mkwrite_novma() to clear the PTE_RDONLY bit only if the
>>> PTE_DIRTY bit is set to make it possible to make the PTE writable and
>>> clean.
>>>
>>> The current behavior was introduced in commit 73e86cb03cf2 ("arm64:
>>> Move PTE_RDONLY bit handling out of set_pte_at()").  Before that,
>>> pte_mkwrite() only sets the PTE_WRITE bit, while set_pte_at() only
>>> clears the PTE_RDONLY bit if both the PTE_WRITE and the PTE_DIRTY bits
>>> are set.
>>>
>>> To test the performance impact of the patch, on an arm64 server
>>> machine, run 16 redis-server processes on socket 1 and 16
>>> memtier_benchmark processes on socket 0 with mostly get
>>> transactions (that is, redis-server will mostly read memory only).
>>> The memory footprint of redis-server is larger than the available
>>> memory, so swap out/in will be triggered.  Test results show that the
>>> patch can avoid most swapping out because the pages are mostly clean.
>>> And the benchmark throughput improves ~23.9% in the test.
>>>
>>> Fixes: 73e86cb03cf2 ("arm64: Move PTE_RDONLY bit handling out of set_pte_at()")
>>> Signed-off-by: Huang Ying <ying.huang@linux.alibaba.com>
>>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>>> Cc: Will Deacon <will@kernel.org>
>>> Cc: Anshuman Khandual <anshuman.khandual@arm.com>
>>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>>> Cc: Gavin Shan <gshan@redhat.com>
>>> Cc: Ard Biesheuvel <ardb@kernel.org>
>>> Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
>>> Cc: Yicong Yang <yangyicong@hisilicon.com>
>>> Cc: linux-arm-kernel@lists.infradead.org
>>> Cc: linux-kernel@vger.kernel.org
>>> ---
>>>  arch/arm64/include/asm/pgtable.h | 3 ++-
>>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
>>> index aa89c2e67ebc..0944e296dd4a 100644
>>> --- a/arch/arm64/include/asm/pgtable.h
>>> +++ b/arch/arm64/include/asm/pgtable.h
>>> @@ -293,7 +293,8 @@ static inline pmd_t set_pmd_bit(pmd_t pmd, pgprot_t prot)
>>>  static inline pte_t pte_mkwrite_novma(pte_t pte)
>>>  {
>>>  	pte = set_pte_bit(pte, __pgprot(PTE_WRITE));
>>> -	pte = clear_pte_bit(pte, __pgprot(PTE_RDONLY));
>>> +	if (pte_sw_dirty(pte))
>>> +		pte = clear_pte_bit(pte, __pgprot(PTE_RDONLY));
>>>  	return pte;
>>>  }
>> 
>> This seems to be the right thing. I recall years ago I grep'ed
>> (obviously not hard enough) and most pte_mkwrite() places had a
>> pte_mkdirty(). But I missed do_swap_page() and possibly others.
>> 
>> For this patch:
>> 
>> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
>> 
>> I wonder whether we should also add (as a separate patch):
>> 
>> diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
>> index 830107b6dd08..df1c552ef11c 100644
>> --- a/mm/debug_vm_pgtable.c
>> +++ b/mm/debug_vm_pgtable.c
>> @@ -101,6 +101,7 @@ static void __init pte_basic_tests(struct pgtable_debug_args *args, int idx)
>>  	WARN_ON(pte_dirty(pte_mkclean(pte_mkdirty(pte))));
>>  	WARN_ON(pte_write(pte_wrprotect(pte_mkwrite(pte, args->vma))));
>>  	WARN_ON(pte_dirty(pte_wrprotect(pte_mkclean(pte))));
>> +	WARN_ON(pte_dirty(pte_mkwrite_novma(pte_mkclean(pte))));
>>  	WARN_ON(!pte_dirty(pte_wrprotect(pte_mkdirty(pte))));
>>  }
>> 
>> For completeness, also (and maybe other combinations):
>> 
>> 	WARN_ON(!pte_write(pte_mkdirty(pte_mkwrite_novma(pte))));
>
> Adding similar tests to pte_wrprotect().
>
> diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
> index 830107b6dd08..573632ebf304 100644
> --- a/mm/debug_vm_pgtable.c
> +++ b/mm/debug_vm_pgtable.c
> @@ -102,6 +102,11 @@ static void __init pte_basic_tests(struct pgtable_debug_args *args, int idx)
>         WARN_ON(pte_write(pte_wrprotect(pte_mkwrite(pte, args->vma))));
>         WARN_ON(pte_dirty(pte_wrprotect(pte_mkclean(pte))));
>         WARN_ON(!pte_dirty(pte_wrprotect(pte_mkdirty(pte))));
> +
> +       WARN_ON(pte_dirty(pte_mkwrite_novma(pte_mkclean(pte))));
> +       WARN_ON(!pte_write(pte_mkdirty(pte_mkwrite_novma(pte))));
> +       WARN_ON(!pte_write(pte_mkwrite_novma(pte_wrprotect(pte))));
> +       WARN_ON(pte_write(pte_wrprotect(pte_mkwrite_novma(pte))));
>  }
>
>  static void __init pte_advanced_tests(struct pgtable_debug_args *args)
> @@ -195,6 +200,9 @@ static void __init pmd_basic_tests(struct pgtable_debug_args *args, int idx)
>         WARN_ON(pmd_write(pmd_wrprotect(pmd_mkwrite(pmd, args->vma))));
>         WARN_ON(pmd_dirty(pmd_wrprotect(pmd_mkclean(pmd))));
>         WARN_ON(!pmd_dirty(pmd_wrprotect(pmd_mkdirty(pmd))));
> +
> +       WARN_ON(!pmd_write(pmd_mkwrite_novma(pmd_wrprotect(pmd))));
> +       WARN_ON(pmd_write(pmd_wrprotect(pmd_mkwrite_novma(pmd))));
>         /*
>          * A huge page does not point to next level page table
>          * entry. Hence this must qualify as pmd_bad().

Thanks!

I can add a patch for these tests.  Or, do you want to work on it?

>> 
>> I cc'ed linux-mm in case we missed anything. If nothing raised, I'll
>> queue it next week.

---
Best Regards,
Huang, Ying

