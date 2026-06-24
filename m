Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D5B5CDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 05:51:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 233856B0088; Wed, 24 Jun 2026 01:51:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E4046B008A; Wed, 24 Jun 2026 01:51:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D3036B008C; Wed, 24 Jun 2026 01:51:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D70806B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 01:51:06 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3C89D40244
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 05:51:06 +0000 (UTC)
X-FDA: 84913732932.01.C2D74DD
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 036261C0004
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 05:51:03 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=WrRo5tSb;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782280264;
	b=NBRaJI+4NNncU7Y5sHnv8x9EhhHWDTmBkIAFwOtSsL/JmrmjuRpWFO1x6gdTtdvIDTwqIy
	8kLgnr5sx9sgxGt1vVFr5ivUfOqPVd5/4V5yEk60e+/BC6Wqre5I1qGQ4B0xqmEcP0NYsZ
	rmdD/uIt/D0EpWwksfQG+Rr8oI+YZ0M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782280264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fBo+gnsR37uWYSdTHZ1XXqdvAdkCH7EjSFNn6GG/uXg=;
	b=p5s31s+OgsDi9c8Cjz/YwjBk8iCdb6XRiPbfk8JBrWlBSj2jhb417Uesz4drnag+qOrIQp
	Q8NCWJQTz6Ak2NFByAt1MWIWRXrh3EM6vDb6TCojjVbpqxXCy41tjGRbHphrVhe3Vz3WVT
	rx9R1DvXUI0hgZgmjpznFkOrFaNu4+8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=WrRo5tSb;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0A6361756;
	Tue, 23 Jun 2026 22:50:58 -0700 (PDT)
Received: from [10.164.148.38] (unknown [10.164.148.38])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CC4073F632;
	Tue, 23 Jun 2026 22:50:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782280262; bh=G1DrRGj/pcW4vuRHrevEY0fnEtN/QDNsQ4085ytGVGQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=WrRo5tSb18qXkWRcfh2IoO9hFlLgZhmoXMwlBCf69YPCvHeAUAFJynTnDmGemQXG4
	 JCIiHk6LHeeFMiueSPF9DDQdTvWfnl/dNfE8ii1MIb0UK2AI69LV2NyTp3fAsHdrSy
	 Wd7Rh66LXFKSsnIuYvvW3+Yk2njHqOUVo9P+3cq8=
Message-ID: <82474473-ff96-4ee5-bbe4-3d92c2f8cefa@arm.com>
Date: Wed, 24 Jun 2026 11:20:44 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 02/12] mm/rmap: Add try_to_unmap_hugetlb_one
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, ljs@kernel.org, chrisl@kernel.org,
 kasong@tencent.com, hughd@google.com, liam@infradead.org, riel@surriel.com,
 vbabka@kernel.org, harry@kernel.org, jannh@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 bhe@redhat.com, youngjun.park@lge.com, baolin.wang@linux.alibaba.com,
 pfalcato@suse.de, ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <ee0d499c-de98-4860-bfd0-0bce0b4c1bdc@kernel.org>
 <20260618074449.24974-1-lance.yang@linux.dev>
 <d6259e43-e507-48a4-a048-93b5df2f1b62@kernel.org>
 <0fe2a584-c633-4f82-8c47-d204e3b39a57@linux.dev>
 <e64fc2f2-c4a0-434a-8d60-dcb28b99b8c6@kernel.org>
 <22613c23-612b-4de0-8731-00ad2da63eae@linux.dev>
 <dcfba95b-8cb0-4fa7-a21f-49b595eb92dd@arm.com>
 <ae987527-7ab1-4905-b7f4-8fcc3bebdd52@arm.com>
 <0368128c-664a-40aa-9b37-27768d403795@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <0368128c-664a-40aa-9b37-27768d403795@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: r8awyw5i116uryckggewwss3y6wb94dd
X-Rspamd-Queue-Id: 036261C0004
X-Rspamd-Server: rspam06
X-HE-Tag: 1782280263-133951
X-HE-Meta: U2FsdGVkX19yRB5Ocl6oxd1zLY0dAnS0xa3awGVAKFOsd6IcX23uAw+JA94AB6dfB9S5UXTyK5wdtEulnQtsXO1dNyuhKtZcR2xYDfQzGFOd1JSAb+3XAnXL8Mh2FVcIjVTPJenE+QCpWVEqA7jMbCAJIKgCu3DfQaywH9Ky/dJwvRhu+fvJQ4wk5fg/NGU7/ap/OGZ9QhTPRAwQdBp0uqpeARPJgH56cZ3/USzpadXOHH4R5BP+ckK9fDYWPg1eL6jB0+PLiEwFzZ3qcxeKQMIIKn2LSIuDr+AYOn3h6ATmNJYqDvw+K+CHWRVbSSqa4TiC/PmKkCbTCB9BkSiEuArABLxuA/2AC2sEsMtGMFvGJZ798YLMEU+vcVNsD2R8+0E7JMGe0S9afTiXL/+P0poK57YHYreDjhJy2bCztI3IsP5Td9U+E8HyqYWm9feOX9DZUz8ekihH4dQ42bMDkUJQHPkyH0tw18GnDuJTPYxwzzHlvv4R5YVtlBZEBbaIc6eE5Vp/USarUhG82qYmINO5MzAghrHtgEj+OOLdBIbfzqnYQX2K2dSUiUk3fvTT6LlWIv5vuvXZn0XNIJhvqboy2tTp+/jm+Tq7r9kz+kUwA4Zhs6lgJCJHoK4zIr2ReHKJc9S0MsaRQDGZ0PRZniCqSRCg7uzujci5cpbGXf+hKkt7DLzpI5LfmPhUzYMCi27NOdNr+MwDO8DQ9yhJIM96XEo7XsMePf0tyaATBBblgWdQyibkMy8z46U0cMEALNyR6a68QVPExvRg1RtonE86x6WoSXKfblHCW8Y+JD/OdnxFce8zpWEqNLVvNi5zMOA7NhbLnCMGfvOYIZUggDdTrj/YuaDLMC1gWY/w7voOeT/x75DWqEdR9ZmabpocJu4OiL0rLbbEYVqECI3Q+ywKcvimGu1DkfNCZo8GXkDE6y3mHHdFkFXMAgnTUCopSlzwe/n3rNyBcA0ZPtM
 PyWkMMAP
 kkMPUVWmQ0JDpnjmVSakskSeGhcD0OhFeq1l/HPBmpUlWUgXKjCchcLQWhlZRNutjrtkdt9Z0oi23uPTHu/XyCdwfezNXIX6RAb1M0sAqfB7mmSUNrmJo4KeFG7bzWAHedIkRk2u/CendnvPJU7Ps7Jk5X0wpjv1pghTlqo/lhk2995an9mcaJL0LBFAdhw6JxqQuW7rdJzHgD4fCucQFu3maI4cNkSJ/7cmR2pZ8N1sshO9a9KdjJIpoP0WxO5BwnzMA1CgNHJygW9thJI/uyuWh2UUF6HgKfq3g
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 22/06/26 1:47 pm, David Hildenbrand (Arm) wrote:
> On 6/22/26 10:14, Dev Jain wrote:
>>
>>
>> On 22/06/26 1:43 pm, Dev Jain wrote:
>>>
>>>
>>> On 18/06/26 3:31 pm, Lance Yang wrote:
>>>>
>>>>
>>>>
>>>> Yeah, looks like this was already there before the split. Should this
>>>> be fixed separately?
>>>
>>> Same bug is there in try_to_migrate_one(), check_pte(), remove_migration_pte()
>>> and prot_none_hugetlb_entry() :)
>>>
>>
>> Lemme send a series for them. Main thing is identifying the fixes tag really.
> 
> Thanks!

I am confused w.r.t backport. So currently we just have to do this:

-               /*
-                * Handle PFN swap PTEs, such as device-exclusive ones, that
-                * actually map pages.
-                */
-               pteval = ptep_get(pvmw.pte);
+               address = pvmw.address;
+               if (folio_test_hugetlb(folio)) {
+                       pteval = huge_ptep_get(mm, address, pvmw.pte);
+               } else {
+                       /*
+                        * Handle PFN swap PTEs, such as device-exclusive ones,
+                        * that actually map pages.
+                        */
+                       pteval = ptep_get(pvmw.pte);
+               }


At commit c7ab0d2fdc84, try_to_unmap_one() was converted to use the pvmw API. The
code was:

	while (page_vma_mapped_walk(&pvmw)) {
		subpage = page - page_to_pfn(page) + pte_pfn(*pvmw.pte);

Doing a plain dereference. Before this commit, the code was:


pte_t *__page_check_address(struct page *page, struct mm_struct *mm,
			  unsigned long address, spinlock_t **ptlp, int sync)
{
	pmd_t *pmd;
	pte_t *pte;
	spinlock_t *ptl;

	if (unlikely(PageHuge(page))) {
		/* when pud is not present, pte will be NULL */
		pte = huge_pte_offset(mm, address);
		if (!pte)
			return NULL;

		ptl = huge_pte_lockptr(page_hstate(page), mm, pte);
		goto check;
	}

	pmd = mm_find_pmd(mm, address);
	if (!pmd)
		return NULL;

	pte = pte_offset_map(pmd, address);
	/* Make a quick check before getting the lock */
	if (!sync && !pte_present(*pte)) {
		pte_unmap(pte);
		return NULL;
	}

	ptl = pte_lockptr(mm, pmd);
check:
	spin_lock(ptl);
	if (pte_present(*pte) && page_to_pfn(page) == pte_pfn(*pte)) {
		*ptlp = ptl;
		return pte;
	}
	pte_unmap_unlock(pte, ptl);
	return NULL;
}


This does pte_pfn(*pte), a plain dereference. I am not sure how back I need
to go for the backport and do I need to post multiple patches for different
stable versions.

And, it is crazy that the bug has stayed for this long and testing didn't find this.
Perhaps no one bothered running hugetlb-read-hwpoison on PPC or s390. And for some
reason those tests are in a category of "destructive" in run_vmtests.sh, requiring
a command line option - and even that option was fixed just now in 3432cbb291aa!

> 


