Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BAF5D5B177
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 14:48:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2B626B0006; Mon, 15 Dec 2025 09:48:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDCA36B0007; Mon, 15 Dec 2025 09:48:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCAD36B0008; Mon, 15 Dec 2025 09:48:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AAC546B0006
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 09:48:07 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5140714028A
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 14:48:07 +0000 (UTC)
X-FDA: 84221985414.01.E8F986F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 942DF1C0011
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 14:48:05 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="niGNJ/9n";
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765810085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i7cw+Cky2EXd7nNEV08cJV+90MTvKcu3DzOBFdzndQE=;
	b=whm3jcYPh3iHcMgecj+xrXrHoumNn+q7HgHjPpCZLQUdr/yQYO8I3iDV1dhmXRNgNup+SK
	rFOroJ/WzsTJ/X3ibZ2ptGUYs/CzibBbjdZ6La8hY+q5iISnimT9lJk/04iMwkgTB24oOk
	7c4yBDemEgqPszRpIO4e2hLHoP8ULEQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765810085; a=rsa-sha256;
	cv=none;
	b=F4uQPJycML5vs4VdfJjeGq/t+VcKuwE99QSk4xS6SLMATNBG4G8Adkrv3dmPKY3wqPtCCi
	uxAZ8dDlNhRGgX9oC+2XebqNSshjxVvdVcWiaNrs/rsxdaeHovJByw/vIunyZXqSyagOme
	KaoW8XQOr1fxoUqTaGjQgP2T47UkHRs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="niGNJ/9n";
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EC2D960133;
	Mon, 15 Dec 2025 14:48:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7732C4CEF5;
	Mon, 15 Dec 2025 14:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765810084;
	bh=mV3B6xzBDJJhXBY0+MuZ/E/eWrtZv1dU8DuL0QrCJos=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=niGNJ/9nLNAcG7+GscG5rl1VsKZF8bJb/qYslvcYV+zGeLxb07aeoEgPu7HJ/Sthn
	 mFTV0AClsXOnG6AmRKVOtCOwiVhUW36xovmM47DlfU7ZCIr6Z78vylhzbYZeYBBp0T
	 KwZ9YbjhYZ2JsYtvfh/0rnU5uqCmztM9pKxAGGrGEP6Re38zxFnZcTuZ7jBF+M4+Nc
	 Gw46iMjDQex4/+CrSySB+0oOSvSsgZjB1M6y6aarXaxSVBZ28Oz2q5IqAWk1XNGGNt
	 liezIwU5PL2imabkYE7mALE09KoTRj0q+rKwxm0xnNvUyvIGkQmPtwj4PbFejZ6P4t
	 3SE3nGyR6NsIg==
Message-ID: <937a4525-910d-4596-a9c4-29e47ca53667@kernel.org>
Date: Mon, 15 Dec 2025 15:47:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 4/4] mm/hugetlb: fix excessive IPI broadcasts when
 unsharing PMD tables using mmu_gather
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-mm@kvack.org, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry.yoo@oracle.com>, Laurence Oberman <loberman@redhat.com>,
 Prakash Sangappa <prakash.sangappa@oracle.com>,
 Nadav Amit <nadav.amit@gmail.com>, stable@vger.kernel.org
References: <20251205213558.2980480-1-david@kernel.org>
 <20251205213558.2980480-5-david@kernel.org>
 <c641335e-39aa-490a-b587-4a2586917bc9@lucifer.local>
 <9ac7c53e-04ae-49f3-976d-44d1e29587d1@kernel.org>
 <07e8b94e-b4a1-4541-84ed-a5d57058d5a1@lucifer.local>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <07e8b94e-b4a1-4541-84ed-a5d57058d5a1@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: osp5d9c5h5xjjjojtf13d7k6bx66i641
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 942DF1C0011
X-Rspam-User: 
X-HE-Tag: 1765810085-858774
X-HE-Meta: U2FsdGVkX1+PYc1AKhDJK5Kw5Oy4kjf8f7IcLZRQr+Dm0uAfBEuKLA+NFNsu/9EmVwpTSbNPd3qhXvmE9Mo+jtZCk6LQePEY5j8ZEG6d6YDs/yZ5UJzWYW8leqsUs1XrXL2qiaML1cFDxxQubmYVQSXBUOiKxorSnskmBg1LuNQjWJweYU+wC6rc6L1hqi46vMTCTnBe7futx+MH5TqDjo1l79VUEtapIUD7pl0ULUgdLV6TWdsj7A6UimmcwmANdINrR0R5Mv31VKRjYzqEAtY4RnYItug2N6VGGefE1AI8g59hWW4ZseHXAJRgd+LHxpwNxJOJ/GCIon8swHDJ4w+vhF4g5yoVMZCWAh3nuA08bHeu3ms64bIu3uVQRFLNMxFC8weoLN0N+SFCrjLnOq+RbjjR3XjG0U4k1iXN7DZFzI+I1hXANdgEPNx2G10IsWSPXgIASdNJcd+TglsvjlIX8A10OU4fHO7kTkL62D2crQCrG9nGOfKH8/rjx4rg6NBxeqMY1V9EW0MBqszAvD7CD3Jt0hYuLEEbraxJ4r9UzMyB7rDXw00NLS/5xBFdJkJDNq6gcFKtq6R4L1j1Vb72U9Ejv/eumddeXZ7G17R7F+0nk+XeoZx9BGhE4JWf6HQZkpeDiqToQ29e0kqoXJXNqu1gP3T81QdFqEFZfTB6PDWs6an9TirJvWJHeGyDlx3wsC1DzoKViZhf2Cwc763s9wIkaiF53jbewT3HKwBy14rBYgyHlAeBG9PVmwF4yhEjC3KmOGkHsbgGNAqpskc/8uuKN8Vvpk8TWv5KpcbEfiyW7wiiVw0hC3d6vN85fxm8O0VvfSjTHwfJXSBRY/eEs/8qaq94bggn3w1qq2GRtAJ+FYS3YgSV7KaHVuzld03g5pch3muu3VOmN0VngN2owrRLG/3b1W1ZPkHi4FGZLzyWWmSSIDiSFjW/HJmJZ1BZKQMtq9nC9warLLe
 HzUPOHXq
 soOQ8Nu9Mof4VHnX1KIeTwoPXa9+AuA8c6awY/mxBOsj6Z5aK/S1sCWUDv8wrohLpBI6vk5BYCtF+aeHLCIm+9Z1IyGxNx78sD46UzznIHyeM+ZcUvb/v5HyOMcdPlmsEu0cZdZzWE6tdvvJzxi+hH+9kjAoTmRcDsBBNNPVaulDOUiVMUQaubi9XmGvafM/GzBL4djLznXOdivU9U6LNesB2pulwMiLgGDIe96Igdg6hvdQ2xKNymLZL/KHScCePY1tahc4oGB7oxRBTvMn4mUTIcd4xLipLaSPYtA8k1EI/g+wfUdMCJAwd3LM+tpaA1JFAzs5VxzOReZKFAGkcC/rQb+Sc784U7JZpJN/D4td48BRcqUzYXPzZqQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>>>
>>> As Nadav points out, should also initialise fully_unshared_tables.
>>
>> Right, but on an earlier init path, not on the range reset path here.
> 
> Shouldn't we reset it also?
> 
> I mean __tlb_reset_range() is also called by __tlb_gather_mmu() (invoked by
> tlb_gather_mmu[_fullmm]()).
> 

__tlb_reset_range() is all about flushing the TLB.

In v2 I have:

diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
index 247e3f9db6c7a..030a162a263ba 100644
--- a/mm/mmu_gather.c
+++ b/mm/mmu_gather.c
@@ -426,6 +426,7 @@ static void __tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm,
  #endif
         tlb->vma_pfn = 0;
  
+       tlb->fully_unshared_tables = 0;
         __tlb_reset_range(tlb);
         inc_tlb_flush_pending(tlb->mm);
  }


>>
>>>
>>>>    	/*
>>>>    	 * Do not reset mmu_gather::vma_* fields here, we do not
>>>>    	 * call into tlb_start_vma() again to set them if there is an
>>>> @@ -484,7 +496,7 @@ static inline void tlb_flush_mmu_tlbonly(struct mmu_gather *tlb)
>>>>    	 * these bits.
>>>>    	 */
>>>>    	if (!(tlb->freed_tables || tlb->cleared_ptes || tlb->cleared_pmds ||
>>>> -	      tlb->cleared_puds || tlb->cleared_p4ds))
>>>> +	      tlb->cleared_puds || tlb->cleared_p4ds || tlb->unshared_tables))
>>>
>>> What about fully_unshared_tables? I guess though unshared_tables implies
>>> fully_unshared_tables.
>>
>> fully_unshared_tables is only for triggering IPIs and consequently not about
>> flushing TLBs.
>>
>> The TLB part is taken care of by unshared_tables, and we will always set
>> unshared_tables when unsharing any page tables (incl. fully unshared ones).
> 
> OK, so is there ever a situation where fully_unshared_tables would be set
> without unshared_tables? Presumably not.

tlb_unshare_pmd_ptdesc() will always set "unshared_tables" but only conditionally
sets "fully_unshared_tables".

"unshared_tables" might get handled by a prior TLB flush,
leaving only fully_unshared_tables set to perform the IPI in tlb_flush_unshared_tables().

So the important part is that whenever we unshare, we set "unshared_tables".

[...]

>>>> +{
>>>> +	/*
>>>> +	 * As soon as the caller drops locks to allow for reuse of
>>>> +	 * previously-shared tables, these tables could get modified and
>>>> +	 * even reused outside of hugetlb context. So flush the TLB now.
>>>
>>> Hmm but you're doing this in both the case of unshare and fully unsharing, so is
>>> this the right place to make this comment?
>>
>> That's why I start the comment below with "Similarly", to make it clear that
>> the comments build up on each other.
>>
>> But I'm afraid I might not be getting your point fully here :/
> 
> what I mean is, if we are not at the point of the table being fully unshared,
> nobody else can come in and reuse it right? Because we're still using it, just
> dropped a ref + flushed tlb?

After we drop the lock, someone else could fully unshare it. And that other (MM) would
not be able to flush the TLB for us -- in contrast to the IPI that would affect all
CPUs.

> 
> Isn't really the correct comment here that ranges that previously mapped the
> shared pages might no longer, so we must clear the TLB? I may be missing
> something :)

There are cases where we defer flushing the TLB until we dropped all (exclusive) locks.
In particular, MADV_DONTNEED does that in some cases, essentially deferring the flush
to the tlb_finish_mmu().

free_pgtables() will also defer the flush, performing the TLB flush during tlb_finish_mmu(),
before

The point is (as I tried to make clear in the comment), for unsharing we have no control
whenn the page table gets freed after we drop the lock.

So we must flush the TLB now and cannot defer it like we do in the other cases.

> 
> Or maybe the right thing is 'we must always flush the TLB because <blahdyblah>,
> and if we are fully unsharing tables we must avoid reuse of previously-shared
> tables when the caller drops the locks' or something?

I hope the description above made it clearer why I spell out that the TLB must be flushed
now.

> 
>>
>>>
>>> Surely here this is about flushing TLBs for the unsharer only as it no longer
>>> uses it?
>>>
>>>> +	 *
>>>> +	 * Note that we cannot defer the flush to a later point even if we are
>>>> +	 * not the last sharer of the page table.
>>>> +	 */
>>>
>>> Not hugely clear, some double negative here. Maybe worth saying something like:
>>>
>>> 'Even if we are not fully unsharing a PMD table, we must flush the TLB for the
>>> unsharer who no longer has access to this memory'
>>>
>>> Or something? Assuming this is accurate :)
>>
>> I'll adjust it to "Not that even if we are not fully unsharing a PMD table,
>> we must flush the TLB for the unsharer now.".
> 
> I guess you mean Note or that's even more confusing :P

:) Yeah, I did that in v2.

-- 
Cheers

David

