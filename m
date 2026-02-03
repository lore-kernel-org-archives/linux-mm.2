Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FC41E87824
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 13:20:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A003E6B0005; Tue,  3 Feb 2026 08:20:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AE026B00AB; Tue,  3 Feb 2026 08:20:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88FFE6B00AC; Tue,  3 Feb 2026 08:20:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7B1F16B0005
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 08:20:25 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 46F258B65C
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 13:20:25 +0000 (UTC)
X-FDA: 84403204410.24.B273927
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf14.hostedemail.com (Postfix) with ESMTP id 22120100008
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 13:20:22 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gflWpeyT;
	spf=pass (imf14.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770124823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fCN/KXyaNLhPpDlNl5DFscQc8m92nKiFKj5UwfM91fw=;
	b=bOmwCccut7oTlbTz7UmMj6ctk9iOlTha4R+rizK3P4cHiMOnGQWe+5P+qTLAiXP5GZm8Tc
	ZpoBVurn7FaI7Mu0bYXh22s41q31yrWu92wKfbDnSQaB5tvfAaPGCmAUrDezC3wiXi3Pu9
	ncGzsl0Li4TToiHRHaje5E3t+s11NWM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gflWpeyT;
	spf=pass (imf14.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770124823; a=rsa-sha256;
	cv=none;
	b=jjn4FWWrBbBO1j/OW4cSMs26Kkh5xN/NqFcP/PwzK60CR/fykl3MeBk/hvX1Y2/b5DUeP9
	ChM8ZVt2qzW8Y+hOyuSwfM2v2N9gZvgSecFKJcihu960nU1ypZnSjF+GV+UWhVLGNliInZ
	yr6l89/a0PUL+DokD/VpztCNHikgDEM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770124820;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fCN/KXyaNLhPpDlNl5DFscQc8m92nKiFKj5UwfM91fw=;
	b=gflWpeyT9Lg77R9MOVQpSaX2p7Yr7DDMp8uR0kDuSKgWLkV5MBAkSMKiSBE5kxGEvgAWNJ
	wP5vrTOVmc9aillHtjQEfC7arApsydjdQSRvrUm6z3N11eBctkialSeMbUsyV5+2QA6gfo
	2EbOJTvieIp+5IqsUg88j2MSspz99Jc=
From: Lance Yang <lance.yang@linux.dev>
To: ziy@nvidia.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	baolin.wang@linux.alibaba.com,
	david@kernel.org,
	gavinguo@igalia.com,
	gshan@redhat.com,
	harry.yoo@oracle.com,
	jannh@google.com,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	richard.weiyang@gmail.com,
	riel@surriel.com,
	stable@vger.kernel.org,
	vbabka@suse.cz,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH] mm/huge_memory: fix early failure try_to_migrate() when split huge pmd for shared thp
Date: Tue,  3 Feb 2026 21:20:06 +0800
Message-ID: <20260203132006.66958-1-lance.yang@linux.dev>
In-Reply-To: <4D8CC775-A86C-4D80-ADB3-6F5CD0FF9330@nvidia.com>
References: <4D8CC775-A86C-4D80-ADB3-6F5CD0FF9330@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 22120100008
X-Stat-Signature: zz93qf6yqeksteqfi99x9bybgxh55ank
X-Rspam-User: 
X-HE-Tag: 1770124822-725024
X-HE-Meta: U2FsdGVkX1+b+EzIzvZfq/XsL30TWW0Do+EQjCNuy/R/OcA1XZJeEElNYy1B61iXj6Ea6zN1SM9h7K9hGOks0MPulQ/1gmGXkqlAYUOJdJBZddsJ8NxLbLvRJeBeSXqdRhSjEJ8Y4SFVEhOn0TnWPEzsbEMtGPXmha/oI/4lLH4fw7HuUw2hhq1HOqCZ7uO7BVcy89ytJ1/1I8Ook8V2nGcxgatk6VvBwwRLCIAjbLxNvqq6b1soGps8AoH4aMdwfvnlifodf351KOJ9EbbVpFccLc63Fz8lqv3/c7UbK4/WgPinBMRjr78uLzdb6aJgSYHojHASY3t4AnwVVkf6hIW3IYX6DKEpg16HAVGuG2dtPoMnOeUMcp0yKjwDT71sJ2Th5n7D2oDJYfZzmdL7tYX+nxjqRx5By2FzGE+wGDh9Fmf2W40GtMzfpvIntCcEg0R1Xfu4SB/gXVOVNEQd19tscofKzBvzNs/ZOAEKiQ1iPcpFtKauLopH5Rk60iocBbGunzz8uxFR/KGKRg1dsJJEkpVexKUZ7bG0TtQrXSY3Di8RGnFDD5XiO54QyIEdiC7V5THIObJVxnFXI/QY9vz3tTFojPaEw5aC7N/tXgbnew0dfR1NBeO5HAnRD+yLdkuG6oGv7mzmxSpZhOYvyQLe65vaWctDrNN1fBg7fQmfncpjDI/o7aiS3/Fk15qK34GAeDRriKLJYciyaBdh0uzioCYmuhBO06+KvounVmY3PZAzrC2UXn9ZveIz9nBVZ7V8CkCiPuKojMVxbofDkLtIlaqMyaLnHfc7JZDihsiNrsqoUzPIk/MW7q5Jsp1+QkQi0k0wC43zJq5ZPhBlKc1mL75S2DFhKSiExApeW407xJKIzfGz27xCuST3O5CjfKNRl+PkYDnad/PlbMaWyIkyn5HX35DQfS8FhIaZ7JHasqWEdIuSZqRx3TQQ7QOE6uwzMEcnOA4F87MyDhP
 un2I2XtE
 uYZNr0+ixvUcRYY28L9XWsZAtvdgSn/hmbuaL7Y5mLMFBJWTn5WfDX2RhF3Au/mnGdxJctA8goyTU8N5RTwCfLKM504nh6ks9iwCJvei4mmt7YNpm0uYWV7RPmD6voY3srMMkqsqHGAcLrhdxarQQlJIxa1nfAERwxGH40clpPUVul1fjBu6fnfUVQSl7I6XKAVWIIT3xUHP7AYHOyIkYUjJb0NnfGY6+XzTkVWa0Kp5e33rYZH7qSKj5ZEi8XNeWVKbGwy71YM6HgM7wH3w8diV/3NF/tdzJ4GhDR1XvxOOyC675dCUy/uJWUHpGABjhy8Hans1jfsNgDXgr8rNxQmtKU9R+lVqOoHLt/i6LWu6gEzPPt3EBLQ9V/WhRpBminVrq03vERmL8m+b2cq/EgDSnLqRpsUlMT7B/cMkPPS20jumtGcLPkign9ITrAQnjP4E3DDbXmpmzfBJGorWxquSiQwC+tvl/MTTd/GbpOIex2lsUMHmOvhKe0S43XXaZvztv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Sun, Feb 01, 2026 at 09:20:35AM -0500, Zi Yan wrote:
>On 1 Feb 2026, at 8:04, Gavin Guo wrote:
>
>> On 2/1/26 11:39, Zi Yan wrote:
>>> On 31 Jan 2026, at 21:09, Wei Yang wrote:
>>>
>>>> On Fri, Jan 30, 2026 at 09:44:10PM -0500, Zi Yan wrote:
>>>>> On 30 Jan 2026, at 18:00, Wei Yang wrote:
>>>>>
>>>>>> Commit 60fbb14396d5 ("mm/huge_memory: adjust try_to_migrate_one() and
>>>>>> split_huge_pmd_locked()") return false unconditionally after
>>>>>> split_huge_pmd_locked() which may fail early during try_to_migrate() for
>>>>>> shared thp. This will lead to unexpected folio split failure.
>>>>>>
>>>>>> One way to reproduce:
>>>>>>
>>>>>>      Create an anonymous thp range and fork 512 children, so we have a
>>>>>>      thp shared mapped in 513 processes. Then trigger folio split with
>>>>>>      /sys/kernel/debug/split_huge_pages debugfs to split the thp folio to
>>>>>>      order 0.
>>>>>>
>>>>>> Without the above commit, we can successfully split to order 0.
>>>>>> With the above commit, the folio is still a large folio.
>>>>>>
>>>>>> The reason is the above commit return false after split pmd
>>>>>> unconditionally in the first process and break try_to_migrate().
>>>>>
>>>>> The reasoning looks good to me.
>>>>>
>>>>>>
>>>>>> The tricky thing in above reproduce method is current debugfs interface
>>>>>> leverage function split_huge_pages_pid(), which will iterate the whole
>>>>>> pmd range and do folio split on each base page address. This means it
>>>>>> will try 512 times, and each time split one pmd from pmd mapped to pte
>>>>>> mapped thp. If there are less than 512 shared mapped process,
>>>>>> the folio is still split successfully at last. But in real world, we
>>>>>> usually try it for once.
>>>>>>
>>>>>> This patch fixes this by removing the unconditional false return after
>>>>>> split_huge_pmd_locked(). Later, we may introduce a true fail early if
>>>>>> split_huge_pmd_locked() does fail.
>>>>>>
>>>>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>>>>> Fixes: 60fbb14396d5 ("mm/huge_memory: adjust try_to_migrate_one() and split_huge_pmd_locked()")
>>>>>> Cc: Gavin Guo <gavinguo@igalia.com>
>>>>>> Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
>>>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>>>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>>>> Cc: <stable@vger.kernel.org>
>>>>>> ---
>>>>>>   mm/rmap.c | 1 -
>>>>>>   1 file changed, 1 deletion(-)
>>>>>>
>>>>>> diff --git a/mm/rmap.c b/mm/rmap.c
>>>>>> index 618df3385c8b..eed971568d65 100644
>>>>>> --- a/mm/rmap.c
>>>>>> +++ b/mm/rmap.c
>>>>>> @@ -2448,7 +2448,6 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>>>>>>   			if (flags & TTU_SPLIT_HUGE_PMD) {
>>>>>>   				split_huge_pmd_locked(vma, pvmw.address,
>>>>>>   						      pvmw.pmd, true);
>>>>>> -				ret = false;
>>>>>>   				page_vma_mapped_walk_done(&pvmw);
>>>>>>   				break;
>>>>>>   			}
>>>>>
>>>>> How about the patch below? It matches the pattern of set_pmd_migration_entry() below.
>>>>> Basically, continue if the operation is successful, break otherwise.
>>>>>
>>>>> diff --git a/mm/rmap.c b/mm/rmap.c
>>>>> index 618df3385c8b..83cc9d98533e 100644
>>>>> --- a/mm/rmap.c
>>>>> +++ b/mm/rmap.c
>>>>> @@ -2448,9 +2448,7 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>>>>> 			if (flags & TTU_SPLIT_HUGE_PMD) {
>>>>> 				split_huge_pmd_locked(vma, pvmw.address,
>>>>> 						      pvmw.pmd, true);
>>>>> -				ret = false;
>>>>> -				page_vma_mapped_walk_done(&pvmw);
>>>>> -				break;
>>>>> +				continue;
>>>>> 			}
>>>>
>>>> Per my understanding if @freeze is trur, split_huge_pmd_locked() may "fail" as
>>>> the comment says:
>>>>
>>>> 		 * Without "freeze", we'll simply split the PMD, propagating the
>>>> 		 * PageAnonExclusive() flag for each PTE by setting it for
>>>> 		 * each subpage -- no need to (temporarily) clear.
>>>> 		 *
>>>> 		 * With "freeze" we want to replace mapped pages by
>>>> 		 * migration entries right away. This is only possible if we
>>>> 		 * managed to clear PageAnonExclusive() -- see
>>>> 		 * set_pmd_migration_entry().
>>>> 		 *
>>>> 		 * In case we cannot clear PageAnonExclusive(), split the PMD
>>>> 		 * only and let try_to_migrate_one() fail later.
>>>>
>>>> While currently we don't return the status of split_huge_pmd_locked() to
>>>> indicate whether it does replaced PMD with migration entries successfully. So
>>>> we are not sure this operation succeed.
>>>
>>> This is the right reasoning. This means to properly handle it, split_huge_pmd_locked()
>>> needs to return whether it inserts migration entries or not when freeze is true.
>>>
>>>>
>>>> Another difference from set_pmd_migration_entry() is split_huge_pmd_locked()
>>>> would change the page table from PMD mapped to PTE mapped.
>>>> page_vma_mapped_walk() can handle it now for (pvmw->pmd && !pvmw->pte), but I
>>>> am not sure this is what we expected. For example, in try_to_unmap_one(), we
>>>> use page_vma_mapped_walk_restart() after pmd splitted.
>>>>
>>>> So I prefer just remove the "ret = false" for a fix. Not sure this is
>>>> reasonable to you.
>>>>
>>>> I am thinking two things after this fix:
>>>>
>>>>    * add one similar test in selftests
>>>>    * let split_huge_pmd_locked() return value to indicate freeze is degrade to
>>>>      !freeze, and fail early on try_to_migrate() like the thp migration branch
>>>>
>>>> Look forward your opinion on whether it worth to do it.
>>>
>>> This is not the right fix, neither was mine above. Because before commit 60fbb14396d5,
>>> the code handles PAE properly. If PAE is cleared, PMD is split into PTEs and each
>>> PTE becomes a migration entry, page_vma_mapped_walk(&pvmw) returns false,
>>> and try_to_migrate_one() returns true. If PAE is not cleared, PMD is split into PTEs
>>> and each PTE is not a migration entry, inside while (page_vma_mapped_walk(&pvmw)),
>>> PAE will be attempted to get cleared again and it will fail again, leading to
>>> try_to_migrate_one() returns false. After commit 60fbb14396d5, no matter PAE is
>>> cleared or not, try_to_migrate_one() always returns false. It causes folio split
>>> failures for shared PMD THPs.
>>>
>>> Now with your fix (and mine above), no matter PAE is cleared or not, try_to_migrate_one()
>>> always returns true. It just flips the code to a different issue. So the proper fix
>>> is to let split_huge_pmd_locked() returns whether it inserts migration entries or not
>>> and do the same pattern as THP migration code path.
>>
>> How about aligning with the try_to_unmap_one()? The behavior would be the same before applying the commit 60fbb14396d5:
>>
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index 7b9879ef442d..0c96f0883013 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -2333,9 +2333,9 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>>                         if (flags & TTU_SPLIT_HUGE_PMD) {
>>                                 split_huge_pmd_locked(vma, pvmw.address,
>>                                                       pvmw.pmd, true);
>> -                               ret = false;
>> -                               page_vma_mapped_walk_done(&pvmw);
>> -                               break;
>> +                               flags &= ~TTU_SPLIT_HUGE_PMD;
>> +                               page_vma_mapped_walk_restart(&pvmw);
>> +                               continue;
>>                         }
>>  #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
>>                         pmdval = pmdp_get(pvmw.pmd);
>
>Yes, it works and definitely needs a comment like "After split_huge_pmd_locked(), restart
>the walk to detect PageAnonExclusive handling failure in __split_huge_pmd_locked()".
>The change is good for backporting, but an additional patch to fix it properly by adding
>a return value to split_huge_pmd_locked() is also necessary.

Right. IIUC, after split_huge_pmd_locked() we always have 512 PTEs: either
migration entries, or present PTEs with PageAnonExclusive still set.

And try_to_migrate_one() doesn't use PVMW_MIGRATION. So when we restart the
walk we're either seeing migration — then map_pte/check_pte() won't match,
we hit not_found() and leave the loop with ret still true.

Or we see present (with PageAnonExclusive still set) — then we drop into
the normal PTE path, call folio_try_share_anon_rmap_pte() again, and set
ret=false when it fails.

Cheers,
Lance

