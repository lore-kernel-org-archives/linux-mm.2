Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65B2BE7C71B
	for <linux-mm@archiver.kernel.org>; Sun,  1 Feb 2026 13:06:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA7A56B0089; Sun,  1 Feb 2026 08:06:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2B326B008A; Sun,  1 Feb 2026 08:06:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 929EF6B008C; Sun,  1 Feb 2026 08:06:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7E0296B0089
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 08:06:18 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A6922D5049
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 13:06:17 +0000 (UTC)
X-FDA: 84395911194.26.F307EDC
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf29.hostedemail.com (Postfix) with ESMTP id 80FEE12000B
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 13:06:15 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=Ig+iuG3h;
	spf=pass (imf29.hostedemail.com: domain of gavinguo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=gavinguo@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769951176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BZqm1/Smx1ZhncMV3at0HOf6nRzc5QtCzZ65lye7cbw=;
	b=ZVORNatYYsE354suzlKAG/wveAu/MGTweQxDW0KnBkbEc7HtfAh9wE5ieSFbVjOGrrDef+
	pLdmHOIUKCcsf0RWmbg4Ptj1Xm1QpiygWbhCHCcsq9QbCyaBmPvFJVN6mcQMr+O36iErU9
	h3dHpgWwDY8n5JDsucZLTsfOxIH/IKU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=Ig+iuG3h;
	spf=pass (imf29.hostedemail.com: domain of gavinguo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=gavinguo@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769951176; a=rsa-sha256;
	cv=none;
	b=sDFhtFe3y0DqhdNrpSHpKx6V05BFqzQiGI8w4QaOfMzYh2tLRXd3w9TffDJ0so76hWSxfC
	YzzqGMJu9fWyGFQeKlk0ACDuW1mNHmfBZyzx1ngE3aETl2r4g/D+N/v5lxIpfgLJUGAAR2
	J9piRSLpovPxvt5hU1I7SweVYoBkgVk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=BZqm1/Smx1ZhncMV3at0HOf6nRzc5QtCzZ65lye7cbw=; b=Ig+iuG3hGUOc4saO2uzXOQhLdG
	s8GrYWf1HZBf+l+mb0eUkypYbc348rkmg5cGU9bErhLsYudhXk6THWveyRtzd7OzQmvr8M9yy83eK
	oFji07abBD5Bq8YQ3cUGkfCbCbDIfBDEYeUkz0MY8iyxQxKz8xFaRDXbw37tdJMmEW2/dbtFd1C1v
	suvaV46FSeYgoZJwlGw8GVl/7blBmQqB0PQ6g5l7yJHvV5HDlvga/eEPZ1dHxRP7dKgFPhRIPjhfT
	JHGhcYlmDgoo+P9cEOUXbB9f8v5UhOAIxhkrlQJU8r62cRwHnFY8zoXykEvJASZGIaXJ6oZGdP7P4
	N3dW7EOA==;
Received: from ppp-27-55-83-89.revip3.asianet.co.th ([27.55.83.89] helo=[10.37.212.43])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
	id 1vmX9E-00CPgF-8D; Sun, 01 Feb 2026 14:05:53 +0100
Message-ID: <08f0f26b-8a53-4903-a9dc-16f571b5cfee@igalia.com>
Date: Sun, 1 Feb 2026 21:04:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: fix early failure try_to_migrate() when
 split huge pmd for shared thp
To: Zi Yan <ziy@nvidia.com>, Wei Yang <richard.weiyang@gmail.com>,
 david@kernel.org
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, riel@surriel.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, harry.yoo@oracle.com,
 jannh@google.com, baolin.wang@linux.alibaba.com, linux-mm@kvack.org,
 stable@vger.kernel.org, Gavin Shan <gshan@redhat.com>
References: <20260130230058.11471-1-richard.weiyang@gmail.com>
 <178ADAB8-50AB-452F-B25F-6E145DEAA44C@nvidia.com>
 <20260201020950.p6aygkkiy4hxbi5r@master>
 <C620202F-685A-4B9E-B51B-078EBE5BF0C4@nvidia.com>
Content-Language: en-US
From: Gavin Guo <gavinguo@igalia.com>
In-Reply-To: <C620202F-685A-4B9E-B51B-078EBE5BF0C4@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Stat-Signature: cs15o4w8hastbe6htbzb4afaimco9ed1
X-Rspam-User: 
X-Rspamd-Queue-Id: 80FEE12000B
X-HE-Tag: 1769951175-132809
X-HE-Meta: U2FsdGVkX19vWovHvShmX4KNLawzuNAIBATOrxCThhlELm1ZBO9LhQPA26qsIBq1Ih0eJwlLpxl2JUyDaTgg8jbq+WOnPVpy3BslFwwntnCCKa3lfqDu1N9OzQ5n2r3KWS/3VxaCyKVoYaM/gVZpGbpzKZs5BsMi/HE1uaNsgWYeQ1vkORbpRJl0uMKnBZdu4GcbK0Nh4TN9BwAxTsFZXkWjRazFr+MjtgmHLHU6fTfCwOdj9nW2LrI/sedvEiujensm869jy5XAwREDMmEediJkuP2p+u6YE2Ct0xPqno2BHcfqkqjM7GqwJ+8g1lpyPjJG7sipfJuChLaKoghpOMd6ePpBvD0hxpgqQCkgZaobHtYDjoyPSe6J+FVswVWs6z2N7VUsx/bZfST+gjmRFNclefFjjipc4LcSPg4XjcdymQaq6VDXywtLSoSnK9QQdGO7eln6rPlptgKnm4A++fG6Gc5D2V4ZOa1TV00LyXSPkKEUZPQmYQlEQ3Tsu0jQrynL5qTtymg/YUp5GVr0V3VvNa6jJ9Yj8SeFvxaTNHr90DhxPsf3uqLItiHRTuXpL3bR183vx63bsVcdaPeHC1qvIuPQnQHufTcwaSqYKwOdC/d1n+EJ3O5v9M0s7fIjLiX3Al2Sqzq85eVaugWMvwzsRC1Kab+FvYuRztOlgazTgw8ln09yUgEStkJFqfXp7Yv/RU2VQ/boEX7Yu2r2/2D+GjcVVQlM2nlEKcSPFFh32gxWsgnbo6myi3XmfGeypMJr3ggw0NX7U/MeU1M38W6V58cohz1OmfR/gV5KCWP5YvagkCy7DJCp7TFjf6mcgnn127dZNVe1G0y8JlRyQOvOf4A0bvIU9r5Ih3oTuLvNKpkreSftk6PZFop0SxVhjgxJR1eJGDuMXqVEzLSoS1mrsQ77vG43Ez1ThNEsxj7cxt8hFak+TFB8bQpBS66wey/vuHVpjS4coKsgRpv
 hae+sgr2
 d+CgWqHO9zmHe7Gv02Dh96hmribQY77gC0YAQPxzzYjOXWL42z4xO4DZllWxxetlIagC7vyWAzOC9rYdrrJT5KZdaAnnoPk8nqIVU12W5P8EgNq7X/CtjXgLuYNecvl+g4Gud+Ki42kYj5CJ3BTIOzj5czCmCsdnkq00aWI271d09y54Vu6x2QQl8GrxB3DDCkmR3Oxnwt58HQQALSPenkG6UmBTD7rsDu9xCQA2Cx4jpFbSreIz/l8Y2Z9iJL2OSAW+W13wod9hERAZIqjjwvXYYIab0qz/EeRbXNIjo75asLn+nttDFE5uk4MlHOkb0E/3N7OiioR7mbY7hMWeRPcVca9Gcyx7X/8MwIS5y1ySIikbW4Y9Y+NhsrovrtThGkpsFqDOzsZ2EghKag33u9s/EiwOPmfT4+87ksFFKrIQR6+TK19cHPRrO+IYlaZqOc/DHOuZkgpiPbZwiv2xV8WTId9E+uPb0GEZSIxJnassB4PCBk6oSdjndlDJVR2P/eGdlAKJP9vwue3MuGKRSTAk5rQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/1/26 11:39, Zi Yan wrote:
> On 31 Jan 2026, at 21:09, Wei Yang wrote:
> 
>> On Fri, Jan 30, 2026 at 09:44:10PM -0500, Zi Yan wrote:
>>> On 30 Jan 2026, at 18:00, Wei Yang wrote:
>>>
>>>> Commit 60fbb14396d5 ("mm/huge_memory: adjust try_to_migrate_one() and
>>>> split_huge_pmd_locked()") return false unconditionally after
>>>> split_huge_pmd_locked() which may fail early during try_to_migrate() for
>>>> shared thp. This will lead to unexpected folio split failure.
>>>>
>>>> One way to reproduce:
>>>>
>>>>      Create an anonymous thp range and fork 512 children, so we have a
>>>>      thp shared mapped in 513 processes. Then trigger folio split with
>>>>      /sys/kernel/debug/split_huge_pages debugfs to split the thp folio to
>>>>      order 0.
>>>>
>>>> Without the above commit, we can successfully split to order 0.
>>>> With the above commit, the folio is still a large folio.
>>>>
>>>> The reason is the above commit return false after split pmd
>>>> unconditionally in the first process and break try_to_migrate().
>>>
>>> The reasoning looks good to me.
>>>
>>>>
>>>> The tricky thing in above reproduce method is current debugfs interface
>>>> leverage function split_huge_pages_pid(), which will iterate the whole
>>>> pmd range and do folio split on each base page address. This means it
>>>> will try 512 times, and each time split one pmd from pmd mapped to pte
>>>> mapped thp. If there are less than 512 shared mapped process,
>>>> the folio is still split successfully at last. But in real world, we
>>>> usually try it for once.
>>>>
>>>> This patch fixes this by removing the unconditional false return after
>>>> split_huge_pmd_locked(). Later, we may introduce a true fail early if
>>>> split_huge_pmd_locked() does fail.
>>>>
>>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>>> Fixes: 60fbb14396d5 ("mm/huge_memory: adjust try_to_migrate_one() and split_huge_pmd_locked()")
>>>> Cc: Gavin Guo <gavinguo@igalia.com>
>>>> Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>> Cc: <stable@vger.kernel.org>
>>>> ---
>>>>   mm/rmap.c | 1 -
>>>>   1 file changed, 1 deletion(-)
>>>>
>>>> diff --git a/mm/rmap.c b/mm/rmap.c
>>>> index 618df3385c8b..eed971568d65 100644
>>>> --- a/mm/rmap.c
>>>> +++ b/mm/rmap.c
>>>> @@ -2448,7 +2448,6 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>>>>   			if (flags & TTU_SPLIT_HUGE_PMD) {
>>>>   				split_huge_pmd_locked(vma, pvmw.address,
>>>>   						      pvmw.pmd, true);
>>>> -				ret = false;
>>>>   				page_vma_mapped_walk_done(&pvmw);
>>>>   				break;
>>>>   			}
>>>
>>> How about the patch below? It matches the pattern of set_pmd_migration_entry() below.
>>> Basically, continue if the operation is successful, break otherwise.
>>>
>>> diff --git a/mm/rmap.c b/mm/rmap.c
>>> index 618df3385c8b..83cc9d98533e 100644
>>> --- a/mm/rmap.c
>>> +++ b/mm/rmap.c
>>> @@ -2448,9 +2448,7 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>>> 			if (flags & TTU_SPLIT_HUGE_PMD) {
>>> 				split_huge_pmd_locked(vma, pvmw.address,
>>> 						      pvmw.pmd, true);
>>> -				ret = false;
>>> -				page_vma_mapped_walk_done(&pvmw);
>>> -				break;
>>> +				continue;
>>> 			}
>>
>> Per my understanding if @freeze is trur, split_huge_pmd_locked() may "fail" as
>> the comment says:
>>
>> 		 * Without "freeze", we'll simply split the PMD, propagating the
>> 		 * PageAnonExclusive() flag for each PTE by setting it for
>> 		 * each subpage -- no need to (temporarily) clear.
>> 		 *
>> 		 * With "freeze" we want to replace mapped pages by
>> 		 * migration entries right away. This is only possible if we
>> 		 * managed to clear PageAnonExclusive() -- see
>> 		 * set_pmd_migration_entry().
>> 		 *
>> 		 * In case we cannot clear PageAnonExclusive(), split the PMD
>> 		 * only and let try_to_migrate_one() fail later.
>>
>> While currently we don't return the status of split_huge_pmd_locked() to
>> indicate whether it does replaced PMD with migration entries successfully. So
>> we are not sure this operation succeed.
> 
> This is the right reasoning. This means to properly handle it, split_huge_pmd_locked()
> needs to return whether it inserts migration entries or not when freeze is true.
> 
>>
>> Another difference from set_pmd_migration_entry() is split_huge_pmd_locked()
>> would change the page table from PMD mapped to PTE mapped.
>> page_vma_mapped_walk() can handle it now for (pvmw->pmd && !pvmw->pte), but I
>> am not sure this is what we expected. For example, in try_to_unmap_one(), we
>> use page_vma_mapped_walk_restart() after pmd splitted.
>>
>> So I prefer just remove the "ret = false" for a fix. Not sure this is
>> reasonable to you.
>>
>> I am thinking two things after this fix:
>>
>>    * add one similar test in selftests
>>    * let split_huge_pmd_locked() return value to indicate freeze is degrade to
>>      !freeze, and fail early on try_to_migrate() like the thp migration branch
>>
>> Look forward your opinion on whether it worth to do it.
> 
> This is not the right fix, neither was mine above. Because before commit 60fbb14396d5,
> the code handles PAE properly. If PAE is cleared, PMD is split into PTEs and each
> PTE becomes a migration entry, page_vma_mapped_walk(&pvmw) returns false,
> and try_to_migrate_one() returns true. If PAE is not cleared, PMD is split into PTEs
> and each PTE is not a migration entry, inside while (page_vma_mapped_walk(&pvmw)),
> PAE will be attempted to get cleared again and it will fail again, leading to
> try_to_migrate_one() returns false. After commit 60fbb14396d5, no matter PAE is
> cleared or not, try_to_migrate_one() always returns false. It causes folio split
> failures for shared PMD THPs.
> 
> Now with your fix (and mine above), no matter PAE is cleared or not, try_to_migrate_one()
> always returns true. It just flips the code to a different issue. So the proper fix
> is to let split_huge_pmd_locked() returns whether it inserts migration entries or not
> and do the same pattern as THP migration code path.

How about aligning with the try_to_unmap_one()? The behavior would be 
the same before applying the commit 60fbb14396d5:

diff --git a/mm/rmap.c b/mm/rmap.c
index 7b9879ef442d..0c96f0883013 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2333,9 +2333,9 @@ static bool try_to_migrate_one(struct folio 
*folio, struct vm_area_struct *vma,
                         if (flags & TTU_SPLIT_HUGE_PMD) {
                                 split_huge_pmd_locked(vma, pvmw.address,
                                                       pvmw.pmd, true);
-                               ret = false;
-                               page_vma_mapped_walk_done(&pvmw);
-                               break;
+                               flags &= ~TTU_SPLIT_HUGE_PMD;
+                               page_vma_mapped_walk_restart(&pvmw);
+                               continue;
                         }
  #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
                         pmdval = pmdp_get(pvmw.pmd);


> 
> 
> Hi David,
> 
> In terms of unmap_folio(), which is the only user of split_huge_pmd_locked(..., freeze=true),
> there is no folio_mapped() check afterwards. That might be causing an issue,
> when the folio is pinned between the refcount check and unmap_folio(), unmap_folio()
> fails, but folio split code proceeds. That means the folio is still accessible
> via PTEs and later remove_migration_pte() will try to remove non migration PTEs.
> It needs to be fixed separately, right?
> 
> 
>>
>>> #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
>>> 			pmdval = pmdp_get(pvmw.pmd);
>>>
>>>
>>>
>>> --
>>> Best Regards,
>>> Yan, Zi
>>
>> -- 
>> Wei Yang
>> Help you, Help me
> 
> 
> --
> Best Regards,
> Yan, Zi


