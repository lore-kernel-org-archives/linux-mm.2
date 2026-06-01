Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78493CD6E56
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 10:23:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEDCB6B0311; Mon,  1 Jun 2026 06:23:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC52B6B0313; Mon,  1 Jun 2026 06:23:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDB056B0314; Mon,  1 Jun 2026 06:23:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BC01D6B0311
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 06:23:53 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 89509140647
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 10:23:53 +0000 (UTC)
X-FDA: 84830957946.14.781802D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 98C904000E
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 10:23:51 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c833BeYw;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780309431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i98ewwvptaynRm7UjfKX4kD/Leq2g7oiiApUuPFAV2U=;
	b=xZyqIa9x4jSiyX524PuBeODbAsOzolZy9HRafNuZATWanGOXOOsMnehGoRkhBwXOIgTQnJ
	cQHLgN6wmsjy6qkI/q3Qx+JOU9ZC8vT2bxTasRmCegifIN6knIsNpj5ER5SVwqKu67x8wO
	NaEbzT6QZAayaJeiWXQs5/hQcJaPvx8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c833BeYw;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780309431; a=rsa-sha256;
	cv=none;
	b=WUBm+RZVZ2TztIanzTT0124Sp0Hck2UXYzHHc08IuUB9jl4Wurk+Pbxy1o0/t0pLzbAJPI
	kCrTYN9xZt1lhahLteI0abGVsKj9S6grDaTyg1YuSW7JOkYqdTZlR4bDRbpTxiqIFqDQPP
	bD0uMQYZkWI5r9qwd5yyLePZMEpFQB4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CC7C2439A6;
	Mon,  1 Jun 2026 10:23:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45F371F00893;
	Mon,  1 Jun 2026 10:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780309430;
	bh=i98ewwvptaynRm7UjfKX4kD/Leq2g7oiiApUuPFAV2U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=c833BeYwgWz0ppp2x5phqCnJSunVgereyjGFUP4VqomH4E1+QpFfXKobIPxqHWZjf
	 mHsIUimognUz54K96CBjCRux7u5M+O3Fns9wbdjp0/SfXsM5HOfeyQIKeIBQ2+IxQK
	 VdGUz2DB8VatOJWgXIaufLTsE/5ra+O+5teh72LQe+jWlTOSUmxZtZsSojv2M9Jifd
	 kicJVxsrzwL2zbz0aLVT4FgrsgN2rKBfx/N+CsNTRqdmNCn6X9BBnbueQgumucs+I+
	 eHf+Qiz0MgWpWxRaJbOr7V12LUXNhYpe4ePGGEX9K2h7Mg7rr/KZ+q6an5DZThkQhv
	 gqc+JIOA7PrpA==
Message-ID: <6b11bf0a-769c-4ef2-ac6f-2af38200a6bc@kernel.org>
Date: Mon, 1 Jun 2026 12:23:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v18 06/14] mm/khugepaged: generalize
 collapse_huge_page for mTHP collapse
To: Lance Yang <lance.yang@linux.dev>
Cc: npache@redhat.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, aarcange@redhat.com,
 akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net,
 hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, jackmanb@google.com,
 jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com,
 kas@kernel.org, liam@infradead.org, ljs@kernel.org,
 mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
 mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de,
 rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org,
 richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org,
 rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
 sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com,
 tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz,
 vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org,
 willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com,
 usama.arif@linux.dev
References: <2024af56-5e99-4799-a586-e9ba756cecb9@kernel.org>
 <20260601032804.96122-1-lance.yang@linux.dev>
 <f5d38f64-ab92-496d-afd3-29ccc17fec2b@kernel.org>
 <616de1a8-1cfd-40b8-b04f-7b324be40bfd@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <616de1a8-1cfd-40b8-b04f-7b324be40bfd@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 98C904000E
X-Stat-Signature: z7n9y3c4uhbdrbqwf8tfayhwf4iobqzq
X-HE-Tag: 1780309431-630231
X-HE-Meta: U2FsdGVkX18HmdCFzr5afuwSvk+dLajpC/h0yRUO8n4nuJXAI9RjcsayUrueVTZ6BCwgMMnrHSWeqi7MVexbzRFoYVMC7Yr2XARFPEQIaPHDQoJ+HWyWfHdCJu75dF8vAq795XhEUW1xQ82PEiBIV913FYTQDhQhq/UrJ6jUukXzn5nG08JmQot/3dnQXSH6IMUnSND+weP175cgD7J71nNmhdeJ/jvB25PcyThx8TdFXIXDKL0hDWh7QCCdtSCVmBuRO1wNkzjr8KpslypauzkyycnQqV7IVoXlmZcKWJIEoVfadIb06dCoJqq6rK8GUQwQG/dRkpe45GTDFU31rop0yTh5wQVUAAA7iJ2ybJC1n2aD9354nxIfcSJvJL0AI8RlnwB7U0ayatGOjRD3dDo7fFxlAXlGIPXaq6Ro/Dh1IPF90KEpkQLexcdPrky3QfvmuRJ05FSFuj1haskW1zU19ne7ympqYe+dSO37AwZqUNV/bQdIZwdDCeeXbqmgENvXnTnNAJlIA9rnLU544CJpH6OUjuxboGMtm/RHKtuZuvhIbgS4VExogCtVMm3qzKYFQFWAPRm36cYRPi341DO/luXlXFUShS6hMhS3OZZEvleElfV8JM125hmSblmcy6EocLB7dmvNqxIsM7FV8vaL3b4KGuG9FFknpTfshj2JWtiu9ghFPO5NOqdsUckj2+hinDkz4r3I7crLxbZG9a19ljV2GegZqeP1HW39PcA0xOdDq8KFAxotauj83dAd1+K9dR9ETBpBxaOIY2Tv9Zz/miXXCgUs9tBQB29w+446CuKVLenOsAnhTgoCQKIc/J3my3H6jQJqOLP+r7SihaPXcsrEEcMFSgpKYMWB/3qHzDkbxOIGQI+jk5h3jrBNkNPSv1uFWgz1EHL6nzx0j+f2An604gEQA2VHBmTPTVv9LJf0mwgA9PyX6y93almha5j1gsq9toX/Je3VTYA
 Ondk5uT3
 Vl6BTlhRD2SiBS2Sv64/35ntCsmBOjVvj8UcLME+Ddi0pVx1WD0bWxNG2GlJLLSpwvfngVdYkeA3GBPNLZ5Y35KjcBh8oHSx00NegAftTvnAd07GxWuiwhUB3tNCmJRx2ut7l9SmeZ06zS0ybQJcX+Q1HRGLA6PHE0yfp4NBelpd4NhRE/VT49Jxoxh4hswCI20DRg78+W/2Wvqu3S8iPaKG7VzOyRMQvJntpCSGFmqbNlJ2WUQgUwX5em/yw6/Ba4myqd6YNLRRAKpK8IMN7FqLuMOJHO+pvADRqs6X/JklHyTg3jiOKrK7x2xWcEy1Jum5UXlF1IsUBuIRaUvcTU9oz5SVQpARlB+TA5S9ZWFwsGdbL7qpcSCQ0C/wf6o0GZ8XFcxEHSwOudNaeswoZ96k9zw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/1/26 11:08, Lance Yang wrote:
> 
> 
> On 2026/6/1 14:54, David Hildenbrand (Arm) wrote:
>> On 6/1/26 05:28, Lance Yang wrote:
>>>
>>>
>>> Ah, fair point.
>>>
>>> I was mostly worried about arch hooks that walk vma->vm_mm again, rather
>>> than only using the pte pointer passed in. For example, mips does:
>>
>> Right, a re-walk would be the real problem.
>>
>>>
>>>    update_mmu_cache_range()
>>>      -> __update_tlb()
>>>        -> pgd_offset(vma->vm_mm, address)
>>>        -> pte_offset_map(...)
>>>
>>> and __update_tlb() has this assumption:
>>>
>>>         /*
>>>          * update_mmu_cache() is called between pte_offset_map_lock()
>>>          * and pte_unmap_unlock(), so we can assume that ptep is not
>>>          * NULL here: and what should be done below if it were NULL?
>>>          */
>>>
>>> So if khugepaged happens to run with current->active_mm == vma->vm_mm
>>> here, could __update_tlb() hit the none PMD, get NULL from
>>> pte_offset_map(), and then dereference it?
>>
>> Likely yes -- that MIPS code is horrible. And the comment in MIPS code
>> even spells that out. :(
>>
>> Do you know about other code like that, or is MIPS the only one doing a
>> re-walk and crossing fingers?
>>
>>>
>>> Just wanted to raise it since some arch code may still have assumptions
>>> like this, and the always-enable-mTHP work is getting closer ...
>>
>> Right. I assume set_pte_at() couldn't trigger something similar (re-walk) in
>> arch code,
>> because we simply provide the ptep. update_mmu_cache_range() only consumes the
>> pte.
>>
>>>
>>> Probably very very very hard to hit, though :)
>>
>> Delaying update_mmu_cache_range() is nasty, as we'd have to make sure that
>> nobody can interfere in the meantime ... and the PMD lock will not be sufficient.
>>
>> Maybe we could reinstall the page table with the cleared (none) entries while
>> still holding the PTL?
>>
>> Thinking out loud:
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 5ba298d420b7..e39b750b1e6f 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -1413,13 +1413,17 @@ static enum scan_result collapse_huge_page(struct
>> mm_struct *mm, unsigned long s
>>                  map_anon_folio_pmd_nopf(folio, pmd, vma, pmd_addr);
>>          } else {
>>                  /*
>> -                * set_ptes is called in map_anon_folio_pte_nopf with the
>> -                * pmd_ptl lock still held; this is safe as the PMD is expected
>> -                * to be none. The pmd entry is then repopulated below.
>> +                * Re-insert the page table with the cleared entries, but
>> +                * hold the PTL, such that no one can mess with the re-installed
>> +                * page table until we updated the temporarily-cleared entries
>> +                * through map_anon_folio_pte_nopf().
>>                   */
>> -               map_anon_folio_pte_nopf(folio, pte, vma, start_addr, /
>> *uffd_wp=*/ false);
>> -               smp_wmb(); /* make PTEs visible before PMD. See pmd_install() */
> 
> One small thing, I think we should probably keep the smp_wmb(), and just
> move it before the earlier pmd_populate().
> 
> IIUC, the ordering we want is still:
> 
>   clear old PTEs
>   smp_wmb()
>   pmd_populate()
> 
> so another CPU cannot walk through the re-installed PMD and still observe
> the old PTEs, right?

There is a smp_wmb() in __folio_mark_uptodate(), that should be sufficient?

-- 
Cheers,

David

