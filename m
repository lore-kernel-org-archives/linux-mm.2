Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FF9CFA1FDC
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 18:40:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D9276B0088; Wed, 22 Apr 2026 14:40:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 289EE6B008A; Wed, 22 Apr 2026 14:40:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19F3A6B008C; Wed, 22 Apr 2026 14:40:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 08F456B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 14:40:01 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AC15FC0241
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 18:40:00 +0000 (UTC)
X-FDA: 84687056160.18.6373B5E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id B814120011
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 18:39:58 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RG1AIUof;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776883198; a=rsa-sha256;
	cv=none;
	b=8WhTKdsjP+AdOncYyXHF9/c5Hzt8vn17ysrCbYDlt+AJlzXyTJzURtPyO8Ybh9lhWTUUWP
	DSLLv5x9j5MC4jLQYW4ZW1Asm+TFpQkg6mSaiYqrbvqGwGJMgAtW0yPmUft+GxVC0xMnh/
	qy/Fez1vNybXGG3F0OwT3u8Xxt7rOL4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RG1AIUof;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776883198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RWOnj73d9bkvZ/YOsHgZh0df5uF+iAdM0681u1stGBU=;
	b=5M/vwqJxwduRTY2kyjuRhzmn108BEqUgzJY5wvbJcqxN6lSBck5TMMRSDyxBcb+mF8nfQ3
	TUEa1ohZ3KJum/nOsiIt2n0ijN8OwT+f8GmEz9TLI4NkTKJtwiRgKYKkm3Dh70qmzh/eoR
	J9TEmx9Yniu5UGqfUi/4KDZEXorFQs8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9E468404B2;
	Wed, 22 Apr 2026 18:39:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A4F7C19425;
	Wed, 22 Apr 2026 18:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776883197;
	bh=gPBkLTS8xvviMRNP8SEcmV5ut7acgVc3jDTKipEUsns=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RG1AIUofKfe1bYx9Q4cRXAEWj+ON9FElIcMnnfMFF5BknmDNEGf66PIK9UkMmih4x
	 q4NIPGJeGozprMQtH0pH+1BGB0EycqP3DdE4hsePDKc9wLbrk0rCcr0QGuyZi/inG0
	 Q14x9hD9OKGhJslLLO4vekucewh5KWpQQh/pFsm2mIyNW6/ib4cYFwNT0njGDjRqcz
	 ZiZXIEM9kE+YJMcvfUsW4MF20wGd+/oxvvcfR4drh233AJLyRUYZmR009wFJVXp2am
	 9b6/ARH061RBy+hrJ/gWkrclE4F/ERVWbBtDGpVIzd6ISnUXHEzAHNEQWAm89JrQne
	 5K/NY4RJaPr1Q==
Message-ID: <b77d559b-215e-460a-a268-e63b8273ef42@kernel.org>
Date: Wed, 22 Apr 2026 20:39:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC, PATCH 00/12] userfaultfd: working set tracking for VM guest
 memory
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
 kvm@vger.kernel.org
References: <20260414142354.1465950-1-kas@kernel.org>
 <55019037-4f1c-4d9c-83ee-3a844d8f3d5e@kernel.org>
 <ad50rPOseVa-SP_s@thinkstation> <aeDoqFWPFxkkNB26@thinkstation>
 <1a499781-1115-44bc-adbf-2ac3769354ca@kernel.org>
 <aeFCuLJXT8VOkzH7@thinkstation>
 <4c635703-3d8d-4cfa-bb98-7f6f5fcbe547@kernel.org>
 <aeImfRrrvr3UoKtL@thinkstation> <aeTnlQUOOh-dHG8z@thinkstation>
 <34f75083-29a3-4860-8a6e-94551d37ac6a@kernel.org>
 <aed6fHLrIdahbdY3@thinkstation>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aed6fHLrIdahbdY3@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B814120011
X-Stat-Signature: 5fd7mrbg9ggpt1osigy4e6yi9dwgnuuh
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776883198-244636
X-HE-Meta: U2FsdGVkX19QBe4wdRileGaTw0gYY/3bjjI0F5SXjJib9XBnUF0jy9J9xexQcEGWZS60W+9NYDowsuiJXen6Nr3dDwWeZNTaGUKeN469qgo7f8IAk1QLfJaKzLPsSatfmByVWN9BI4xQg8LGoL3Hv8lXXNbXVsBC0/BlhwV/5flWD1r//kHg+Hx323SKfDdeERqjWUotIZzy3MA8PLicV6+KMtFg5oulTQbCpdCpp0kAM0BkWznYl1jVV3Z34M8BKnd0MGihNySc1bq6Dp4pyNkcsxdqR4k2r354dPudXCMbNF/lo48Jhbb1tfEi7t23J6xnWi/iO2oC3/coj0dlQ6JDUUUfcsOAYhF6KBxPEq4Kxl0okEGuBiwUrJfQ1qJEI3GbfYqf2leZSpxgxJdyZebid1tlxU7hIY1cXGIZRSZTjwanbC/CmcRHLttgHQ91RrOQ8tn06f2SjkCCYpomWbnNoYGWot2jY58WTAFBQnumwbkJWTbHSdoY1JZnQ/JuK7A393ontrEHRIMp8ecrmitkJiyyuaJwRJsXqBkTs2oonTaaLv95opZZAM7G7ZQ54bZGIC14No2hVImN4dk11G0H0T8JfpbumHxNn9ZUjj7dDiD5p4zAA/DTT1gI8t6wtcPgpMsmi2FynwGAn6qfQwYiPZ3tSpRMzT2UYjKmx2IL3wnOjxyfk0xJSC8lYgHafrxrEo+6Pe2tD308l+W+yyx7PYdZ8QV0OH0+8aNB6KHQzDXaw6NVDwvHM3vj1zqsetiHrE/2eLQg4t1pjGlMX7JYKv9NNFbj9KxTWYeiz+4uVnL5++gAm5TYSEiwxhoquJT2ZvuSOb/Eub4uHKNeI5tiq0Yvcub1APOPl4fKhHLvC7SZorgFN+iaeDJYTJifo7Y9dl9219K68vEwpQnGSzCCT6NxsleKAVXGCdOjeGMh5eaRoJ9uR6OZoOGcYJdowui7xqUIWbpZs/GbcPh
 Er9797vX
 s6LH9uSwbW6rFU1M0/C5CiQ3gc/Dw7CfhylwvCt8sF4J6Z8ikeF+BzLsft/4cOulhhYjLqJdu9VK4MvCbxNtyqKZKNC1Th2PGY6QP2kYb096SDLo2dygYDaiXUemAJ3RjgFi5rMnuKKTsINnq6nV5H88PLt5wKtsAJ3nJ3LFxxMDF5odSNiy0FWLhePnKnsx3GJ1m6GmXM7FKgEBuVmaL5wOPqFOUayrMZAr9hzHApSvsx1AiUGJS2dzkI+RvgrME1ou4ancwr/U+l/tHAhsIDjPSaLEWaaRNs6Ex
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/21/26 16:33, Kiryl Shutsemau wrote:
> On Tue, Apr 21, 2026 at 03:03:56PM +0200, David Hildenbrand (Arm) wrote:
>> On 4/19/26 16:33, Kiryl Shutsemau wrote:
>>>
>>> See https://git.kernel.org/pub/scm/linux/kernel/git/kas/linux.git uffd/rfc-v3
>>>
>>
>> Quick feedback from skimming over it:
>>
>>
>> 1) ARCH_SUPPORTS_PROT_NONE needs some thought, because I am pretty sure all 
>> architectures support something like mprotect(PROT_NONE), and the config
>> option might be misleading.
>>
>> So you very likely want to express different semantics here. You want to
>> know whether pte_protnone()/pmd_protnone() works.
> 
> We do support mprotect(PROT_NONE) everywhere, but we don't always have a
> way to distinguish such entries from others without VMA in hands. Like,
> there are other PTEs that don't have present bit set. In my and NUMA
> balancing context we cannot rely on VMA, because we want to install
> PAGE_NONE entires into accessible VMA.

Exactly. So it's not ARCH_SUPPORTS_PROT_NONE.

> 
> So we need two things; pte/pmd_protnone() checks and PAGE_NONE itself.
> The first to test PTE for PAGE_NONE, the second for pte/pmd_modify() to
> make the entry protnone.
> 
> Currently, generic code only use this functionality for NUMA balancing
> and gated by NUMA balancing config option. So I moved it under separate
> config option.
> 
> Do you want it to be named differently?

Would ARCH_SUPPORTS_PXX_PROTNONE or sth. like that better describe that
pte_protnone()/pmd_protnone() do what we want?

> 
>> 2) The other stuff is really just an extension of existing WP handling.
>> I suspect we want to have some reasonable cleanups to not end up in
>> common code with
>>
>> @@ -1841,7 +1841,7 @@ static void copy_huge_non_present_pmd(
>>  	add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
>>  	mm_inc_nr_ptes(dst_mm);
>>  	pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
>> -	if (!userfaultfd_wp(dst_vma))
>> +	if (!userfaultfd_wp(dst_vma) && !userfaultfd_rwp(dst_vma))
>>  		pmd = pmd_swp_clear_uffd_wp(pmd);
>>  	set_pmd_at(dst_mm, addr, dst_pmd, pmd);
>>
>> All the uffd handling should be better isolated (i.e., a single vma check?),
>> and likely the uffd bit should be abstracted away from being called "wp" to
>> something more generic.
>>
>> Maybe it's simply a "uffd" flag which's semantics depend
>> on the vma flags.
>>
>> Maybe something like:
>>
>> @@ -1841,7 +1841,7 @@ static void copy_huge_non_present_pmd(
>>  	add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
>>  	mm_inc_nr_ptes(dst_mm);
>>  	pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
>> 	if (!userfaultfd_uses_pte_bit(dst_vma))
>>  		pmd = pmd_swp_clear_uffd(pmd);
>>  	set_pmd_at(dst_mm, addr, dst_pmd, pmd);
>>
>> Not sure, needs another thought. But I think there are some decent
>> cleanups to be had.
> 
> That's fair. Maybe userfaultfd_protected() name is better for the VMA
> check?

Yes, something like that could also work.

> 
> And about UFFD_WP bit name. Maybe we can just drop _WP: _PAGE_UFFD_WP ->
> _PAGE_UFFD, pte_uffd_wp() -> pte_uffd()?

Yes, I hinted at the above with pmd_swp_clear_uffd().

> 
> But it is a lot of changes. Can I do the bit rename as a follow up
> patchset?

Let's get this clean. There is no need to rush that in ;)

I suspect it's a fairly mechanical change.

> 
>> 3) Some other stuff needs a second thought, like
>>
>> diff --git a/mm/gup.c b/mm/gup.c
>> index 8e7dc2c6ee738..08fc18f1290d4 100644
>> --- a/mm/gup.c
>> +++ b/mm/gup.c
>> @@ -695,7 +695,8 @@ static inline bool can_follow_write_pmd(pmd_t pmd, struct page *page,
>>  	/* ... and a write-fault isn't required for other reasons. */
>>  	if (pmd_needs_soft_dirty_wp(vma, pmd))
>>  		return false;
>> -	return !userfaultfd_huge_pmd_wp(vma, pmd);
>> +	return !userfaultfd_huge_pmd_wp(vma, pmd) &&
>> +	       !userfaultfd_huge_pmd_rwp(vma, pmd);
>>  }
>>
>> How can a pte be writable and prot_none at the same time? Maybe just confused AI
>> output that you should carefully double check before sending that out officially.
> 
> Note that this path is for !pmd_write() case to begin with. It serves
> FOLL_FORCE case. I believe this check is correct: we don't want to allow
> to write to such pages even with FOLL_FORCE.
> 
> But looking around, I missed gup_can_follow_protnone() modification. It
> has to return false for RWP.

Right, read-permission checks come before the write-permission checks.

> 
>> 4) How do we want to handle PM_UFFD_WP?
>>
>> We are pretty much out of flags soon. Overloading PM_UFFD_WP means that we will not
>> be able to easily support using a separate bit.
>>
>> But our internal design will not easily allow that either, and I am not really
>> sure we want to go down that path any time soon.
>>
>> Maybe we could document this for now as "In WP VMAs, indicated WP PTEs.
>> Otherwise, in RWP VMAs, indicates RWP.". Whenever we would allow both at the
>> same time, we could change the semantics. User space would fail to create one
>> with both protection types for now either way.
> 
> Yeah. I think about doing documentation-only update for PM_UFFD_WP for
> now.

Ok, good!

-- 
Cheers,

David

