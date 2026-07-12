Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10E38C43458
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 11:16:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA3B86B008A; Sun, 12 Jul 2026 07:16:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7B516B008C; Sun, 12 Jul 2026 07:16:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6CC36B0092; Sun, 12 Jul 2026 07:16:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 95D4E6B008A
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 07:16:49 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 11CAAA08A5
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 11:16:49 +0000 (UTC)
X-FDA: 84979872138.20.0121463
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id AAD9110000A
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 11:16:46 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=aizDZIet;
	spf=pass (imf05.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783855007;
	b=bDD2fWnREkYGF6QbWyCZ+wyEDRAuTwu5UTYFBVjAFa5ggAvkltx/Zq/0bb5ml53z+rnK8p
	wJ+lVPtF0ZAiuiZ0n81gFtQU58rQ7Fttx67N/KZFHktfKHJ/we1N67eDgILVGYEd5kWMio
	oMX047n2MErE/yTU8XLNqFH4CaxUDWY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=aizDZIet;
	spf=pass (imf05.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783855007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cDCSe4Ss39LQVe4+ibbsjVG0EUJbnO2iiUzXj+P+BRs=;
	b=JLwYEaZng49IqHS2egW1exhs1hsCLIjcyc7swYwujp+rxpiOtup6JhYRgDPxUPgSF8rfxi
	m8PtGifg3L/JRlgzxNDmShhsYQtGI8Pe/kVxDddGQypDt6h5bzn/RmUGJzUzJKw/SQbKtS
	ztwPQzQzyNbQ8FxlA2nmCjKHhj0OqJU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 132A81682;
	Sun, 12 Jul 2026 04:16:41 -0700 (PDT)
Received: from [10.163.128.224] (unknown [10.163.128.224])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9374E3F85F;
	Sun, 12 Jul 2026 04:16:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783855005; bh=4w2FnFBScyw7YiWU7s5gk5e3O6Mlmlj6IlRNpHN4Kvs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=aizDZIetRuhqDZIAblfUpSHmN60c1g6V9Mt4KSqHWNxS7o8f22B5iWg89O/gWEy3U
	 xlLQsPTatoZxElpkRlPCFNKVpRZ66ca6G7+pNhtMcqsfcCRZ9dRqxOG9MiqH109zRo
	 TZbIaVaOnhkMQGxIsvq0cW4Q0p459JDKSW3WI/lI=
Message-ID: <28b7e7d2-62d8-4141-a6e9-7ab1cbb2baa4@arm.com>
Date: Sun, 12 Jul 2026 16:46:36 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/vmalloc: acquire init_mm read lock on huge vmap
 promotion
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Uladzislau Rezki <urezki@gmail.com>, Toshi Kani <toshi.kani@hpe.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 David Carlier <devnexen@gmail.com>, Ryan Roberts <ryan.roberts@arm.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
 syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com
References: <20260710-series-vmap-race-fix-v1-0-5b3794c113fe@kernel.org>
 <20260710-series-vmap-race-fix-v1-1-5b3794c113fe@kernel.org>
 <d47ac961-4767-4ce4-9c75-f281beb24e42@arm.com> <alNM8tIxep2-PHAM@lucifer>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <alNM8tIxep2-PHAM@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AAD9110000A
X-Stat-Signature: 9das9g9wkyqx4ehqpmuqxncc1j9uoxu5
X-HE-Tag: 1783855006-575297
X-HE-Meta: U2FsdGVkX18+jbOA2uzY0hsZxvr0bNoujFh3/TRrMLjSCRwe5WQCJtvFJRnXPzMtYyVvYXaW6RpTfIH9edywl2eDL8bZ+nIXH2315egNrg5ArlcESdgKqPPxYlxKGH3raKDlxwNWLQXC+uIapOvxX6zPhQABb1U81RETZ7srUdiO/Tg6FCpXMt+cuaICibVTyvuzUWKwdNe7uLrgl4IbklAla9scRNpkfghvJwGiSWb1ODgtoZAEc5hwxYUp0bTIpMCPBFLK21AASFaZj1DM9dSXlKRKbwgXdLnxjqD6KCK/5qvEmQlhtCm3R68RLi+WtANVFXMQf0WtvamKctDj+8qertQaga3f1ISdfjYSRCfSmhC1X/fWxzdP4Romj/+iBnACHIiCmD6Mqn5Ksb01qz13kYfkHBtcLSsZWLSRzpefzflGNssAI/DY0sy1s++243Aao7QXmUx1yPPYZQetjxGqTT0BtS/k/QVYUYD2T9Mniss7+iFSqrrHeZeThT63v1SXxuRGCe0x05X1ktUfHP8Q5wSBp/LvROsPLafWTh0WB3mlXVg3jnAwSkmzE9mKHKWR1TOHjcVgqAmjycSlYwkQ3iE06FlMnv3t50dFg20fDrEOF8qHoznven6Ugi0kI4TGArbn5LGbd5VzkPzSDUUbWk5Ffzke1n+v7AMF1z+5UcGF2iCSmqL+VgvagitZZEHtnIR98z7TGg/8Q0tm3MuxW4KdiKEA3YXso64q2iAFOz/8Xlm7nbMRrLT4Gu3Qvg3UpyPCBhIGpjj6F/+fB+R9CCt8UW2Xy16up6FV0qkuMkdd9OoelH7pFsRdv2Tlff3w8jk2IE9kF37tw9yWAeu5qtnNQcIqMHTKbiyJUL9SL/eBc7dfQjOW0q52CLqUC9TcumthlMaAfTzThtPjNCEKYFTu5GQMDkdeMlQglAvcnAA3zvI90/1t/JED2D6yEKGArfAPn6jH86e89ef
 ci6pe2G0
 EXGti8ipfmLztv2gSIHOTJ2ZwRNwExkzSfaSOPPFYv1M48sEB471NCsqIsLhJqoDLu7TQx1FYNt49F2KusxTS+LEptD7BCR+2FSZs/k03UTVuVGLO5p3WuTZcVj/j1QHancvCgtmQyzg2Tr0X1Vhxy3Ptll/zHKtxhtM5fhFou2Obx+jo1LxXXBtvymUYe3K7DTBWJ3dEZCoh56Afuru7D/+87Wb6f9eGrOVP5UcWCaGVt9KEl1LohBL3d2QnHVCsMto4tvUpmCcxuyQpms8Sh8Ln8MOMbXV6px7ubZmlY7GjwuCIgISseRReqna9fqxBh5d6ANBZI5UyDEvj7Y6+kppKI0g5F0B/v//TXwyHn8+hbZIWBlpK2uih4bA07hREyh0v3bdtpC9QebGlW5ZNcL+cCA8GweLVdT9S/5I4NW+M5J6+XDtgJClrxrw6TgtrKV65QFdnauUu9w7zGDJrQUSvbfv+2e/rqh7pY42H4CI2xIpME/hiJBtr+T1sOuokjad4bfXMDI6hcJ9/wqclJ2Ta5JKy1sLD02mJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/07/26 1:52 pm, Lorenzo Stoakes wrote:
> On Sun, Jul 12, 2026 at 01:13:12PM +0530, Dev Jain wrote:
>>
>>
>> [-----]
>>
>>> We also define a guard class for mmap_read_trylock() so we can use
>>> cleanup.h to make the scope handling cleaner in the implementation.
>>>
>>
>> Will this cause backport problems, I think this scoped guard thingy is
>> not that old?
> 
> I intentionally used it because it's the best way to solve this problem.
> 
> If there's any issue I'll fix them up in the stable backports myself.
> 
> I will likely resend this as a 4 patch series and just do the stable
> backports manually anyway.
> 
>>
>>
>>> One wrinkle here is commit fa93b45fd397 ("arm64: Enable vmalloc-huge with
>>> ptdump"), which addresses the issue for arm64 only by explicitly acquiring
>>> the mmap read lock on kernel page table freeing should a concurrent ptdump
>>> be in progress.
>>>
>>> This is problematic as vmap may acquire the mmap read lock prior to ptdump
>>> attempting to acquire an mmap write lock, leading to a deadlock when the
>>> mmap read lock is slept upon on page table freeing due to rwsem
>>> anti-starvation.
>>>
>>> We work around this by predicating the mmap lock being taken on
>>> !CONFIG_ARM64 for the time being.
>>>
>>> With this patch applied, a follow up will partially revert commit
>>> fa93b45fd397 ("arm64: Enable vmalloc-huge with ptdump") and at that stage
>>> remove the arm64 ifdeffery.
>>>
>>> We also update walk_page_range_debug() to assert the mmap write lock
>>> unconditionally and update the comment here to reflect this change.
>>>
>>> The issue has existed as long as ptdump was available and vmap freed page
>>> tables when promoting to a huge leaf entry, that is, since commit
>>> b6bdb7517c3d ("mm/vmalloc: add interfaces to free unmapped page table") for
>>> huge ioremap, and commit 121e6f3258fe ("mm/vmalloc: hugepage vmalloc
>>> mappings") for huge vmalloc.
>>>
>>> Since the former is the earlier of the two we choose that for our Fixes
>>> tag.
>>>
>>> This patch is based on work by David Carlier (linked), with gratitude!
>>>
>>> Fixes: b6bdb7517c3d ("mm/vmalloc: add interfaces to free unmapped page table")
>>> Cc: <stable@vger.kernel.org>
>>> Reported-by: syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com
>>> Closes: https://lore.kernel.org/all/6a287988.39669fcc.33b062.00a0.GAE@google.com/T/
>>> Link: https://lore.kernel.org/linux-mm/20260706203128.162335-1-devnexen@gmail.com/
>>> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
>>> ---
>>>  include/linux/mmap_lock.h |  1 +
>>>  mm/pagewalk.c             | 22 +++++++++++----------
>>>  mm/vmalloc.c              | 50 ++++++++++++++++++++++++++++++++++++++---------
>>>  3 files changed, 54 insertions(+), 19 deletions(-)
>>>
>>> diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
>>> index 04b8f61ece5d..6b5c2390cc30 100644
>>> --- a/include/linux/mmap_lock.h
>>> +++ b/include/linux/mmap_lock.h
>>> @@ -621,6 +621,7 @@ static inline void mmap_read_unlock(struct mm_struct *mm)
>>>
>>>  DEFINE_GUARD(mmap_read_lock, struct mm_struct *,
>>>  	     mmap_read_lock(_T), mmap_read_unlock(_T))
>>> +DEFINE_GUARD_COND(mmap_read_lock, _try, mmap_read_trylock(_T))
>>>
>>>  static inline void mmap_read_unlock_non_owner(struct mm_struct *mm)
>>>  {
>>> diff --git a/mm/pagewalk.c b/mm/pagewalk.c
>>> index 3ae2586ff45b..bbcfd68d0907 100644
>>> --- a/mm/pagewalk.c
>>> +++ b/mm/pagewalk.c
>>> @@ -678,6 +678,8 @@ int walk_kernel_page_table_range_lockless(unsigned long start, unsigned long end
>>>   * will also not lock the PTEs for the pte_entry() callback.
>>>   *
>>>   * This is for debugging purposes ONLY.
>>> + *
>>> + * The mmap write lock must be held.
>>>   */
>>>  int walk_page_range_debug(struct mm_struct *mm, unsigned long start,
>>>  			  unsigned long end, const struct mm_walk_ops *ops,
>>> @@ -691,6 +693,16 @@ int walk_page_range_debug(struct mm_struct *mm, unsigned long start,
>>>  		.no_vma		= true
>>>  	};
>>>
>>> +	/*
>>> +	 * When walking userland page tables, an mmap write lock must be held to
>>> +	 * account for munmap() downgrading to an mmap read lock when tearing
>>> +	 * down page tables.
>>> +	 *
>>> +	 * When walking kernel page tables, an mmap write lock must also be held
>>> +	 * to account for page table freeing on vmap huge page mapping.
>>> +	 */
>>> +	mmap_assert_write_locked(mm);
>>> +
>>>  	/* For convenience, we allow traversal of kernel mappings. */
>>>  	if (mm == &init_mm)
>>>  		return walk_kernel_page_table_range(start, end, ops,
>>> @@ -700,16 +712,6 @@ int walk_page_range_debug(struct mm_struct *mm, unsigned long start,
>>>  	if (!check_ops_safe(ops))
>>>  		return -EINVAL;
>>>
>>> -	/*
>>> -	 * The mmap lock protects the page walker from changes to the page
>>> -	 * tables during the walk.  However a read lock is insufficient to
>>> -	 * protect those areas which don't have a VMA as munmap() detaches
>>> -	 * the VMAs before downgrading to a read lock and actually tearing
>>> -	 * down PTEs/page tables. In which case, the mmap write lock should
>>> -	 * be held.
>>> -	 */
>>> -	mmap_assert_write_locked(mm);
>>> -
>>>  	return walk_pgd_range(start, end, &walk);
>>>  }
>>>
>>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>>> index 1afca3568b9b..9d0f1fdd6af3 100644
>>> --- a/mm/vmalloc.c
>>> +++ b/mm/vmalloc.c
>>> @@ -43,6 +43,7 @@
>>>  #include <asm/tlbflush.h>
>>>  #include <asm/shmparam.h>
>>>  #include <linux/page_owner.h>
>>> +#include <linux/cleanup.h>
>>>
>>>  #define CREATE_TRACE_POINTS
>>>  #include <trace/events/vmalloc.h>
>>> @@ -158,10 +159,25 @@ static int vmap_try_huge_pmd(pmd_t *pmd, unsigned long addr, unsigned long end,
>>>  	if (!IS_ALIGNED(phys_addr, PMD_SIZE))
>>>  		return 0;
>>>
>>> -	if (pmd_present(*pmd) && !pmd_free_pte_page(pmd, addr))
>>> -		return 0;
>>> +	if (!pmd_present(*pmd))
>>> +		return pmd_set_huge(pmd, phys_addr, prot);
>>>
>>> -	return pmd_set_huge(pmd, phys_addr, prot);
>>> +	/*
>>> +	 * Kernel page table walkers either walk ranges they own exclusively
>>> +	 * using the mmap lock for mutual exclusion, or hold the mmap write lock
>>> +	 * on init_mm (ptdump being the motivating case).
>>> +	 *
>>> +	 * Therefore, acquire the mmap read lock to prevent use-after-free when
>>> +	 * freeing page tables.
>>> +	 */
>>> +#ifndef CONFIG_ARM64
>>> +	scoped_cond_guard(mmap_read_lock_try, return 0, &init_mm)
>>> +#endif
>>> +	{
>>> +		if (!pmd_free_pte_page(pmd, addr))
>>> +			return 0;
>>> +		return pmd_set_huge(pmd, phys_addr, prot);
>>> +	}
>>>  }
>>>
>> Note that we do not need to take the lock around pmd_set_huge - we don't
>> care if ptdump observes a temporarily cleared pmd entry. So how about keeping
>> this outside the guard block. Otherwise right now we have an inconsistency:
>> for !pmd_present() we do pmd_set_huge() without locking, but for pmd_present()
>> we do pmd_set_huge() with locking.
> 
> As I said in the commit message I'm intentionally taking the lock around all of
> it so a concurrent ptdump sees either the leaf entry or the non-leaf entry.
> 
> By doing that we can easiliy avoid the situation where a ptdump gives you
> inconsistent output and it makes more sense logically.
> 
> So this is the opposite of inconsistent - if !pmd_present() the ptdump may
> observe the _genuine_ state of there not being an entry before. With
> pmd_present() it either observes what was or what became, not something
> inbetween :)

Yeah okay fair enough.


> 
>>
>>
> 
> Thanks, Lorenzo


