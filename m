Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C20F2606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 14:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=NMLyfmu+
Received: by kanga.kvack.org (Postfix)
	id E2A016B05B2; Fri, 30 Oct 2026 10:20:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E01E36B05B3; Fri, 30 Oct 2026 10:20:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D18A26B05B4; Fri, 30 Oct 2026 10:20:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B03806B05B2
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 10:20:51 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3A9B516071A
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 14:20:51 +0000 (UTC)
X-FDA: 85379503902.24.10F1DDB
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2E12C10000E
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 14:20:49 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=NMLyfmu+;
	spf=pass (imf14.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793370049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MSaO26kWHJz53oXNK/ooSoR5p7kapKpTBftLSJ7Kq90=;
	b=SGNE2Fszlr7YadnkHj16DVbcl1qQ289/7x2Fa8lFwWhJOrv0DJTGcBTylE8EiWJXC8kRtO
	umN7E3CJFZAjWhJnMePVU+7p+JwSIz7h4L0psfdIPxM1tXeSsTtNjkEX5Of0Y5E2X3nk9e
	U0xXjiVuZtGlRpMGaHiBIOzaLCyy9uE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793370049;
	b=TxZdivQY/TayT+/MEpTZMTeSjjgowCh8O39yaToKxvDz52EmIxZUZBH+hEN8B4aLkhF7Xv
	DN06vWDVteMCOjDpaF5HdWYwLaTSyCPK9lpXhxS9jLo4gJFUN7oMKfUgZ4HKE0KLRE1zSP
	HgU/YLp/QTNqBUyubVA/skRnECIYZ2Q=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=NMLyfmu+;
	spf=pass (imf14.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CC3BF1CE0;
	Fri, 30 Oct 2026 07:20:44 -0700 (PDT)
Received: from [10.163.155.53] (unknown [10.163.155.53])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 79FE63F673;
	Fri, 30 Oct 2026 07:20:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793370047; bh=LvFZHPc5AjvmFfcnhOAcfYM00twt/E4D7ePpqxI4RHg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=NMLyfmu+3qgBioBF8DPIpA0YdV971kcjPpR8H9920pmFHpKx+W8EpM4oJyHFyKev5
	 yF0OlMWEphWAWXlnh8EIKY6K7Eg4mD58l+bMnr+4DDyVpSpX81cwoSsqg8a0Z8W8oc
	 ipF3rlY/vHHH/M4U3q6PK9OOFRQm9ikxZsahEc1Y=
Message-ID: <e8a2a42d-e424-4366-8a68-e39167f62276@arm.com>
Date: Fri, 30 Oct 2026 19:50:38 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/10] mm/vmalloc: clamp an unaligned range in
 vunmap_pte_range()
To: Hao Ge <hao.ge@linux.dev>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-mm@kvack.org,
 Sashiko <sashiko-bot@kernel.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Shrikanth Hegde <sshegde@linux.ibm.com>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, Andrew Morton
 <akpm@linux-foundation.org>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Uladzislau Rezki <urezki@gmail.com>, Suren Baghdasaryan <surenb@google.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
References: <20261026080329.140244-1-hao.ge@linux.dev>
 <20261026080329.140244-4-hao.ge@linux.dev>
 <99f529e8-06f7-4a20-a60b-0330c5d3d91c@arm.com>
 <5452d555-82f9-45a6-b443-ee732b1874ba@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <5452d555-82f9-45a6-b443-ee732b1874ba@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2E12C10000E
X-Stat-Signature: d4g6udq3sghjhum46e369d981rwdocey
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793370049-405173
X-HE-Meta: U2FsdGVkX1+O8HBpIV4BGEiMbrDf8E9MkvVghdGBOBQaso0LL4jFHQd6P/av4Jiv029DOoKWekN1kddmSFo8QndwpBy3A8eBlBJKlsKF51Q1Z9cDnNO8YD8/b+JrEwnheDXMKxMZEFboVn/ALfxEBL/IU8YMovMAUKh786G9Dbn+O6k4VaDvp7QHTLUJ/5D0z9e84XyV+xPzVt5RkAN0ivvDz/7unok1RHyRbV8/aD34YC6zeXmB5Mk4Fr5TR5w7E1NRewRnGxzEqewrTLG+mv5eYeKM2v0gpTz8HwtEo3geZWrTirsazdfFGHCBmX5qBStbgH7F6LeOHmXOW/dmGmwMDuKo5tr2N/xi4u+8pohsrs1XZUEqQIZd5hauq6T7b4CsdoVj45amOHFharr86mEt0g3QS0hj/NOK8YP9T1KP9D5VUFOCFi8qVULkx39kDzIi9UyGqH7Kwpe71zOuUQYMGgm+NLRG3pi/ucokeMYIzenHtHOhEGYzI4yy3eSa6vt2DHzsc9XVK2XLvUdUiYM8EPH7z9C1vsqwAkdTHkDOcMK711vXUaUEKoVM+YtLkBZL8m/+VQxsRBPGzdb++rvj0gl+C7nn1ZRx/zvQotr+sIMGNyw/gb7chO0Jv04Hb7o/KFANU0i3EDHbHNuctxHbbJZpeU/CzkHV8/SR49jQvtn16pwPTQnzmAKO35wcIumgRu1R8KJpERSRhk3lRyVgbfUfqGgdHKZ4pqARAiPlZkZBY4rT7Q0QRHEtR01IQnHv/SMSdhO5fvxxyRgwi8RICFydod/93HhNmREJ5MnOWrsuPNdFhHwoRerdcudFwGR3bRYrt46vMlrwdB4ImvlLsp2WqY5KFYKOza5SG7bRFqcgVidi/bx77340yMpUqgVtWsiGrAO3BLQw/yOP9uH4lihqjGfU4u41UVwLqRPGhNIrIOvgDtFSSoQsP/sxKt/Zsvzxw2FOuJvgQMA
 Gy3YzyIc
 +KnjaRtGC+mngSATHgUSiWYgwhVK0jDmbLaKEHJjUJPBSLDLwz3Nr7UFvBpOYBMIe46/drlQp7mUB1CADqDzy+bVH0/kQkRQ18xMMBhiyyoApBWdF7rwxt6Rj7nGqPINlA0x9p4c3bx2E4VkQC1SqyaCZ+R+ie9JYh0m9Ry9OOxTmUNLVAbgthJo9sQRD5OXdPBrmQ51Yv8p50wbE6XCXOiBXux1tBWuPxyUbVWqoJSLbZCip5ZM1ZL8f6KSXhF2NWED2iZXk2/TzK2IMGC5fTZNjpjf0z2xgHlmOfGYrrUC34yDA1m9xMZpSYh/Ll05daIt5pP59AXQkHYNf5zzKSkqEWz1l0s7t5yCEpnOVNI+MUcKOB0aUHWj+aLs7alXlUb4r
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 30/10/26 2:00 pm, Hao Ge wrote:
> Hi Dev
> 
> Thanks for your review.
> 
> On 2026/10/30 15:14, Dev Jain wrote:
>>
>>
>> On 26/10/26 1:33 pm, Hao Ge wrote:
>>> commit a739e6b557af ("mm: vmalloc: WARN_ON if mapping size is not
>>> PAGE_SIZE aligned") made vmap_pte_range() warn and bail out when the
>>> size is not a multiple of PAGE_SIZE. That loop steps in page
>>
>> Why are we checking the alignment so late into vmap_pte_range? Why not
>> simply do
>>
>> if (!IS_ALIGNED(addr, PAGE_SIZE) || !IS_ALIGNED(end, PAGE_SIZE))
>> 	return; (or return -EINVAL);
>>
>> at the start of vmap_range_noflush and vunmap_range_noflush?
> 
> I think adding that check at the entry of vunmap_range_noflush()
> goes against its design intent. Its job is to tear down the mappings
> of the given VA range, so even when the caller passes a size that is
> not page-aligned, we still have to unmap whatever is mapped within
> that range.
> 
> So the patch clamps end down to the last full page and keeps
> clearing. A buggy caller still gets its mapping torn down as far as
> it goes, and nothing is left behind. The check here is just for
> protection. 
> 
> This is just my preliminary understanding; I may be mistaken.

Hmm I get you, but this is very ugly. We are trying to tolerate
a blatant bug in the caller with not-so-nice code. But see below.
> 
> Thanks
> Best Regards
> Hao
> 
> 
> But that's just my understanding, happy to be corrected.
> 
> 
>>
>>
>>> multiples and stops only at addr == end; with an unaligned size addr
>>> never lands on end, so the loop cannot terminate and walks off the
>>> end of the page table.
>>>
>>> vunmap_pte_range() has the same loop without any guard, so an
>>> unaligned range would clear PTEs past end without ever stopping,
>>> walking off the end of the page table.
>>>
>>> Add the check there too. The range is clamped down to the last full
>>> page rather than dropped, and the loop is skipped when nothing is
>>> left, so a buggy caller still gets its PTEs cleared as far as they
>>> go.
>>>
>>> Reported-by: Sashiko <sashiko-bot@kernel.org>
>>> Signed-off-by: Hao Ge <hao.ge@linux.dev>
>>> ---
>>>  mm/vmalloc.c | 5 +++++
>>>  1 file changed, 5 insertions(+)
>>>
>>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>>> index 44e0eb32708f..7131f60d1a8e 100644
>>> --- a/mm/vmalloc.c
>>> +++ b/mm/vmalloc.c
>>> @@ -393,6 +393,11 @@ static void vunmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>>>  	pte_t ptent;
>>>  	unsigned long size = PAGE_SIZE;
>>>  
>>> +	if (WARN_ON_ONCE(!PAGE_ALIGNED(end - addr)))
>>> +		end = addr + PAGE_ALIGN_DOWN(end - addr);

For simplicity assume PAGE_SIZE is 4, start is 3, end is 10.
With your code we will get

addr = 3, end = 3 + ALIGN_DOWN(10 - 3) = 3 + 4 = 7.
So the range becomes [3, 7) clearing only two ptes, the one covering
[0, 3], the second covering [4, 7]. I feel we should rather make
the range from [3, 10] to [0, 11], clearing three ptes.

So, at the start of vunmap_range_noflush we could basically
WARN_ON on non-alignment, and then clamp the start down, and clamp
the end up to PAGE_SIZE.

And with this also throw in a patch to bring the -EINVAL bailout
in vmap_pte_range to the top, in vmap_range_noflush and check
both start and end alignment.

>>> +	if (end == addr)
>>> +		return;
>>> +
>>>  	pte = pte_offset_kernel(pmd, addr);
>>>  	lazy_mmu_mode_enable();
>>>  
>>


