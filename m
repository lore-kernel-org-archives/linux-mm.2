Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E9F3C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 16:34:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7055F6B00B4; Wed,  1 Jul 2026 12:34:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DCE46B00B7; Wed,  1 Jul 2026 12:34:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F4406B00B8; Wed,  1 Jul 2026 12:34:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 323C66B00B4
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 12:34:20 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B62AD8DDE3
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 16:34:19 +0000 (UTC)
X-FDA: 84940755438.18.A2B521C
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf18.hostedemail.com (Postfix) with ESMTP id 456D81C000B
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 16:34:16 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iDTr5a4c;
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782923657;
	b=bNHYTU3qBA6G3gBH70vYxXqkec/27tEyDrdtL5kalAucMBg+A5DwWGGWH7zxhIcZwHj4tz
	03rlnklHGonb7xN5T/+uZ3RczqBSATUPOxiHh7XlqW8H0iEDHUjGWOIBMfIr5blsonQ5gi
	if1frIAq1n188Zat37O1i6d2z6YzQ60=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782923657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S8EN7g6oxS7SXD5LHkfE9wVI24o1Ccmyer7oaOUmqbs=;
	b=y19TIbALi69fcFTlUTMcQlR1NSGZD9qTT+KoqwPqjjZUWfay6RgkLVztjFkhUV2siRpoqX
	ov8cKeRkk4Y5jMYoFK/Ov4eqSwBDuwmc10a3zW42AKo/bHEFietVplaw4Pnfe2odiSgpuB
	qYZDKY1eEA4awbbrjIn7fb6SIe5Sl7A=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iDTr5a4c;
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782923654;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S8EN7g6oxS7SXD5LHkfE9wVI24o1Ccmyer7oaOUmqbs=;
	b=iDTr5a4c5GYQEsX7/WoMX8mugZgns0NLjQHuSMmfFNbqMBJ90bt7Imb/Jq2IOUZYVlwefW
	shL1UB/bB76qXBYtmjfnVFKuf25AHcO7V/mcp3fAWkfsOqbv+UlS8VdUr2ffq/juIgD45a
	6Z4SkIcRx2UjYuHcQ0+MYeDPb/uf1Oc=
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org,
	klarasmodin@gmail.com
Cc: richard.weiyang@gmail.com,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	balbirs@nvidia.com,
	sj@kernel.org,
	ziy@nvidia.com,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [Patch mm-hotfixes v5] mm/page_vma_mapped: fix device-private PMD handling
Date: Thu,  2 Jul 2026 00:33:56 +0800
Message-Id: <20260701163356.22936-1-lance.yang@linux.dev>
In-Reply-To: <d4e4180e-dcdf-40e6-b5a2-2ac55f4aecc4@kernel.org>
References: <d4e4180e-dcdf-40e6-b5a2-2ac55f4aecc4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: hy7bqi9pqu673fni7c1bef855zsmgo14
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 456D81C000B
X-HE-Tag: 1782923656-459082
X-HE-Meta: U2FsdGVkX1/eE5g5OZxyxheYhE+S7cRMXGDUDQI5wxCjGZd/N23jhn43gu+WGxHPDVY0neGcubyzVyBE3v0IsNTCf+dt82OL8PmNGCufPDMgRBUFl5+2MsX00ibkKtEBNA8q3IP+V0cfZZBJX3wNlSN6cOWwX/wNHIWZLP1i2KcyR3Tt2FKRMVOop9Qk1D7HVGzArL+N2tp/ih9wl7Xw4oUf5mykQHPDUwfNSmpE1iMa6RBQgCEmbe8yAXZ9XCg2wy9hZCqdIjUc4n5GwGiKlBtVJ9WQ1rREqZf3lzqKG2Y5ATwCzNK4bk9rN9QYcgCsYECwGFHX9NVpD+7noUTi/rUmbmv7Jgf2EXNDu1ENaX9oboAcauDr1U40FDwWvOV+EFpty6Vt/F7mkDTeRCWb9ZwboLDbGqo32mO4Wb/KRGAeY4YT9Ae0PPZ/jLtF/dZzKOYRYG+ggZmoJdTMThCVSZBbwZW80K23uvZYa6IBnvEj6Zma1LmH5abAG7dxWMo/z9bHu7/Ht8Z7HwWGZ2mDUihCPr1NLGCicILl1GwtMboDsdRwnkcmwWxHorYjPMWbU6mZ76S7nvV7JmFVV68uE8h2PxZkKpT2tSwGVFLynNwPWRjIIltoYMOWeidR0PrMHD6npyJhwleBjAx+s48knUWTolPmLig9etPj9HdbT/cVlf9pe0axpOedMfQX1rz3Ewkbweky6SMQsLh+HJliLM8A/pS2pVj6Igt2QPqf34Q1R8TRO2JubWEStqlz6iq9FjhoQPLzLF9l8kTjAc0vkuQS4+ZRTEKSuCQkscBBcjLoZrTdqoBOXGoCST0G/WW9Bbyg59N/dC2osePLpNvKRCImVPaR9p2YrpGQfT3IXok9eKY6E1kXoc6rtghof2I5CsrKehi1577y6PksiUQuOT8QzmHDHWogdAAnU892dWeqqgkN6Di8unasUgFHW7O0+zmQAv6NtGHvEhHk7EC
 LxM6mlcK
 PF5hKWCCYGigPr93vNSqMYfYxd6utO5ZO5O6ijEn/HLQlLLAfeqk9CAlM655v8ueeVhgEtmxpHSjmTbeELNVfgUZtvn9qs+Ow1CZeHePvQ3dFxwf9w141PTbdkt/HoalVKbECElE0nSlOzbC+Gmg3kWe1FHJyf2Fp93StaGBXFAw9oIwyBx0yP0h1PDSoDme/izdp8KS1gDBtglGiCbE9/6f9yp38Z3cZfKBU05HDQe4X688Qe5cz10s+6V64oklO4mjK2+/I8XUpqeodYm0TT9FIjTSNsAdgVrVK/LKQ26IgUPJUEowe47GF4pYNoEvB4EVcq/h/8PLFCc4rhP1QJirVOdH2c5KI4tBFuv0NRHEz2r7a4KeckvTXrb69gvUKee5gwKLDLCofN5aW7dUmH49agHEPQ7aFDflzrrdm+P9p69Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, Jul 01, 2026 at 05:36:33PM +0200, David Hildenbrand (Arm) wrote:
>On 7/1/26 16:33, Klara Modin wrote:
>> Hi,

Hi,

[...]
>> 
>> This results in a build bug for my Raspberry Pi 1:

Thanks for reporting this!

>>  In file included from <command-line>:
>>  In function ‘check_pmd’,
>>      inlined from ‘page_vma_mapped_walk’ at /home/klara/git/linux/trees/bisect/mm/page_vma_mapped.c:256:10:
>>  /home/klara/git/linux/trees/bisect/include/linux/compiler_types.h:702:45: error: call to ‘__compiletime_assert_433’ declared with attribute error: BUILD_BUG failed
>>    702 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
>>        |                                             ^
>>  /home/klara/git/linux/trees/bisect/include/linux/compiler_types.h:683:25: note: in definition of macro ‘__compiletime_assert’
>>    683 |                         prefix ## suffix();                             \
>>        |                         ^~~~~~
>>  /home/klara/git/linux/trees/bisect/include/linux/compiler_types.h:702:9: note: in expansion of macro ‘_compiletime_assert’
>>    702 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
>>        |         ^~~~~~~~~~~~~~~~~~~
>>  /home/klara/git/linux/trees/bisect/include/linux/build_bug.h:40:37: note: in expansion of macro ‘compiletime_assert’
>>     40 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
>>        |                                     ^~~~~~~~~~~~~~~~~~
>>  /home/klara/git/linux/trees/bisect/include/linux/build_bug.h:60:21: note: in expansion of macro ‘BUILD_BUG_ON_MSG’
>>     60 | #define BUILD_BUG() BUILD_BUG_ON_MSG(1, "BUILD_BUG failed")
>>        |                     ^~~~~~~~~~~~~~~~
>>  /home/klara/git/linux/trees/bisect/include/linux/huge_mm.h:113:28: note: in expansion of macro ‘BUILD_BUG’
>>    113 | #define HPAGE_PMD_SHIFT ({ BUILD_BUG(); 0; })
>>        |                            ^~~~~~~~~
>>  /home/klara/git/linux/trees/bisect/include/linux/huge_mm.h:117:26: note: in expansion of macro ‘HPAGE_PMD_SHIFT’
>>    117 | #define HPAGE_PMD_ORDER (HPAGE_PMD_SHIFT-PAGE_SHIFT)
>>        |                          ^~~~~~~~~~~~~~~
>>  /home/klara/git/linux/trees/bisect/include/linux/huge_mm.h:118:26: note: in expansion of macro ‘HPAGE_PMD_ORDER’
>>    118 | #define HPAGE_PMD_NR (1<<HPAGE_PMD_ORDER)
>>        |                          ^~~~~~~~~~~~~~~
>>  /home/klara/git/linux/trees/bisect/mm/page_vma_mapped.c:142:20: note: in expansion of macro ‘HPAGE_PMD_NR’
>>    142 |         if ((pfn + HPAGE_PMD_NR - 1) < pvmw->pfn)
>>        |                    ^~~~~~~~~~~~
>> 
>> bisect log:
>> 
>>  # bad: [be5c93fa674f0fc3c8f359c2143abce6bbb422e6] Add linux-next specific files for 20260630
>>  git bisect start 'HEAD'
>>  # status: waiting for 'good' commit(s), 'bad' commit known
>>  # good: [dc59e4fea9d83f03bad6bddf3fa2e52491777482] Linux 7.2-rc1
>>  git bisect good dc59e4fea9d83f03bad6bddf3fa2e52491777482
>>  # bad: [6148219e90732fd06f5d7a498bda974e6a43ab4b] Merge branch 'nand/next' of https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git
>>  git bisect bad 6148219e90732fd06f5d7a498bda974e6a43ab4b
>>  # bad: [e0326ebe10191447ab8fa2e904080df7b743765e] Merge branch 'for-next' of https://git.kernel.org/pub/scm/linux/kernel/git/soc/soc.git
>>  git bisect bad e0326ebe10191447ab8fa2e904080df7b743765e
>>  # bad: [fbc9c5ac47cef5a2b04aef30c8e990b32dcf2548] Merge branch 'hwmon' of https://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git
>>  git bisect bad fbc9c5ac47cef5a2b04aef30c8e990b32dcf2548
>>  # bad: [e488171f6f6df6fc899a355079665fdb3c50b0e3] Merge branch 'for-linus' of https://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git
>>  git bisect bad e488171f6f6df6fc899a355079665fdb3c50b0e3
>>  # bad: [60db0fcb8fc9d80ac0b63041c632b41a311a45f1] Merge branch 'fs-current' of linux-next
>>  git bisect bad 60db0fcb8fc9d80ac0b63041c632b41a311a45f1
>>  # good: [51021d260d682aa17b3533848a99160ab83e0c93] Merge branch 'vfs.fixes' of https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
>>  git bisect good 51021d260d682aa17b3533848a99160ab83e0c93
>>  # good: [ded56474db6552260786a65898322464b72c7540] mm: a second pagecache maintainer
>>  git bisect good ded56474db6552260786a65898322464b72c7540
>>  # good: [6c893b948351d42cfc3761cc746ab5b3d03ee7f3] Merge branch 'misc-7.2' into next-fixes
>>  git bisect good 6c893b948351d42cfc3761cc746ab5b3d03ee7f3
>>  # good: [bfcc55a14179495b0c41408908fd7b9d7785c694] lib: test_hmm: use device devt for coherent device range selection
>>  git bisect good bfcc55a14179495b0c41408908fd7b9d7785c694
>>  # good: [a27318567c92ba5482906d047e71a7aa4fd01889] Merge branch 'fixes' of https://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git
>>  git bisect good a27318567c92ba5482906d047e71a7aa4fd01889
>>  # bad: [6887a39652cdfd4cfd3b0962662c9cbc26ce5252] mm/page_vma_mapped: fix device-private PMD handling
>>  git bisect bad 6887a39652cdfd4cfd3b0962662c9cbc26ce5252
>>  # good: [2cc6bd0efc264b9ac760c2bc74dff4f521a680a1] MAINTAINERS: s/SeongJae/SJ/
>>  git bisect good 2cc6bd0efc264b9ac760c2bc74dff4f521a680a1
>>  # first 'bad' commit: [6887a39652cdfd4cfd3b0962662c9cbc26ce5252] mm/page_vma_mapped: fix device-private PMD handling
>> 
>>>
>>> Fixes: 65edfda6f3f2 ("mm/rmap: extend rmap and migration support device-private entries")
>>> Cc: <stable@vger.kernel.org>
>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>> Suggested-by: David Hildenbrand <david@kernel.org>
>>> Cc: David Hildenbrand <david@kernel.org>
>>> Cc: Balbir Singh <balbirs@nvidia.com>
>>> Cc: SeongJae Park <sj@kernel.org>
>>> Cc: Zi Yan <ziy@nvidia.com>
>>> Cc: Lorenzo Stoakes <ljs@kernel.org>
>>> Cc: Lance Yang <lance.yang@linux.dev>
>>>
>>> ---
>>> v5:
>>>   * put device-private pmd handling along with the other two cases
>>>   * remove thp_migration_supported()
>>> v4: https://lore.kernel.org/all/20260624065353.1622-1-richard.weiyang@gmail.com/T/#u
>>>   * refine subject and commit log based on Lorenzo's suggestion
>>>   * put pmd device-private entry handling in its own if branch,
>>>     suggested by Lorenzo
>>>
>>> v3:
>>>   * remove cleanup part, only fix the issue for device-private entry
>>>   * refine user effect description based on Lorenzo's suggestion
>>>
>>> v2: https://lore.kernel.org/all/20260616063436.20455-1-richard.weiyang@gmail.com/T/#u
>>>   * specify the possible error case of current code and user visible effect
>>>   * besides fix, cleanup the pmd entry handling based on David's suggestion
>>>
>>> v1: https://lore.kernel.org/linux-mm/20260508013728.21285-1-richard.weiyang@gmail.com/
>>> ---
>>>  mm/page_vma_mapped.c | 30 ++++++++++++++++--------------
>>>  1 file changed, 16 insertions(+), 14 deletions(-)
>>>
>>> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>>> index 2ccbabfb2cc1..2d6c58488e3a 100644
>>> --- a/mm/page_vma_mapped.c
>>> +++ b/mm/page_vma_mapped.c
>>> @@ -243,21 +243,30 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>>>  		 */
>>>  		pmde = pmdp_get_lockless(pvmw->pmd);
>>>  
>>> -		if (pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde)) {
>>> +		if (pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde) ||
>>> +		    pmd_is_device_private_entry(pmde)) {
>>>  			pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>>>  			pmde = *pvmw->pmd;
>>> -			if (!pmd_present(pmde)) {
>>> +			if (pmd_is_migration_entry(pmde)) {
>>>  				softleaf_t entry;
>>>  
>>> -				if (!thp_migration_supported() ||
>>> -				    !(pvmw->flags & PVMW_MIGRATION))
>>> +				if (!(pvmw->flags & PVMW_MIGRATION))
>>>  					return not_found(pvmw);
>>>  				entry = softleaf_from_pmd(pmde);
>>> +				if (!check_pmd(softleaf_to_pfn(entry), pvmw))
>>> +					return not_found(pvmw);
>>> +				return true;
>>> +			} else if (pmd_is_device_private_entry(pmde)) {
>>> +				softleaf_t entry;
>>>  
>> 
>>> -				if (!softleaf_is_migration(entry) ||
>>> -				    !check_pmd(softleaf_to_pfn(entry), pvmw))
>> 
>> My only guess here would be that the compiler evaluates
>> !softleaf_is_migration(entry) to always be true and optimises away the
>> !check_pmd(softleaf_to_pfn(entry), pvmw) which is why this worked
>> before?
>
>Weird, we enter this path only with
>
>pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde) ||
>pmd_is_device_private_entry(pmde)
>
>If any one of these would compile for !CONFIG_TRANSPARENT_HUGEPAGE that would be
>odd.
>
>pmd_is_device_private_entry() is hard-coded to false unless
>CONFIG_ARCH_ENABLE_THP_MIGRATION. Which is only selected with
>ARCH_ENABLE_THP_MIGRATION.
>
>pmd_trans_huge() as well.
>
>Maybe it's struggling with pmd_is_migration_entry() on some (older) compilers?
>(not innlining stuff and not properly optimizing it out).
>
>The whole conditional must be optimized out.

Right. Kinda weird if compiler didn't fold

pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde) ||
pmd_is_device_private_entry(pmde)

away here ...

>We could check for IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) right at the start
>to make it easier for the compiler:

+1, explicit THP guard should do the trick :)

>if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) &&
>    (pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde) ||
>     pmd_is_device_private_entry(pmde))) {
>
>

Klara, could you try with this change and see if it fixes the build?

Thanks, Lance

