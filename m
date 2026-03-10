Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9171EB106D
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 15:19:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 272BC6B00AF; Tue, 10 Mar 2026 11:19:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 220C86B00B2; Tue, 10 Mar 2026 11:19:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F8666B00B5; Tue, 10 Mar 2026 11:19:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F11046B00AF
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:19:57 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A1116C11A6
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 15:19:57 +0000 (UTC)
X-FDA: 84530513634.16.8263677
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id DCB111C0007
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 15:19:55 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ihk+5INR;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773155995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NMwvNgSnZL7JjoWXGLlJiVyh19l9lm8qN70TzjCdL/0=;
	b=Aj/0/TLz7NhmwnMu5JSUT01uE3o5UZ5d1iOBajH//0YR0JdsHpD6/NzdPN62VS6DDUZnXG
	2/JZxTBj3N0Lq9LBKDfRZz1XnR0sSYa8zMN+YzKY6X43sq8d1+5O/0GJl73bZLma1uesBI
	Zz5saKpiDWWqw3+hkMnHFuLX5ZO7J1U=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ihk+5INR;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773155995; a=rsa-sha256;
	cv=none;
	b=cD+n99TGCaC9iMwKPL3pcmavu6HWG05FhlfIMRPacu3bG64+Lr6/8VTYVC+jphyosiuTMO
	vZJY18GLti/Ar5gISfdyx923oVnNm1pJ/KyTkWkwaiczY5C8oHVcVQNQBsCJbrh7F2Jewm
	VJ5H/omr0PaT1+9oR2mhDWs1sRk5RHA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1A46160131;
	Tue, 10 Mar 2026 15:19:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DC89C2BC86;
	Tue, 10 Mar 2026 15:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773155994;
	bh=5OKV6TxeCTi4sil1+d8DZk4DTK+h6fJGntFraZNhPgY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Ihk+5INRlhnWGKIdjJKu6qnnkZDU3yal33YR/9tUilN7QnhcFJJ2p1jZXqZFNUI7x
	 nzsfOJNTuGx3tIGq2IUFbnyo+sdV82nTYltLOYQ50P9NcTGjg8qsQHbLYz1WTJp790
	 nKK5ZpaEX3ua+8OglDfE3gKw5M9addaiebRAUI0SxKn47xDqo/WlWGjB6TEKEtxjhV
	 BkCV62YXk3s3Nuuf+1QsjPcE6LSiySYZK786xyZikrMmgsJRorGyWrjhpFeN3nkHkd
	 ScJkmZv9AYp2ufZHlTSTla332zomkyyc+0q0OMKT3xIFcbf48S8xfnwL3QaQPy1JkS
	 8ozPeOOB+3q4Q==
Message-ID: <0a652e7e-339e-4f98-b591-7fe5680e2006@kernel.org>
Date: Tue, 10 Mar 2026 16:19:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 1/1] mm/pagewalk: don't split device-backed huge pfnmaps
To: "Boone, Max" <mboone@akamai.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Alex Williamson <alex@shazbot.org>, "linux-mm@kvack.org"
 <linux-mm@kvack.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Tottenham, Max" <mtottenh@akamai.com>, "Hunt, Joshua" <johunt@akamai.com>,
 "Pelland, Matt" <mpelland@akamai.com>
References: <20260309174949.2514565-1-mboone@akamai.com>
 <20260309174949.2514565-2-mboone@akamai.com>
 <51eeb09d-d3f4-412f-85da-690fdc0f8e6a@kernel.org>
 <CH2PR17MB3797A91D5107B6E347EEDD97BF79A@CH2PR17MB3797.namprd17.prod.outlook.com>
 <da2ebc9f-ec82-4c55-851c-b27110efdf8c@kernel.org>
 <83842620-AD01-4619-845F-8DE7DF1F8F31@akamai.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <83842620-AD01-4619-845F-8DE7DF1F8F31@akamai.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nc7xhk8iuzosiaetngcfydayd9pjqw16
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: DCB111C0007
X-HE-Tag: 1773155995-162894
X-HE-Meta: U2FsdGVkX1/XANkHGlYH+QoBgymTYObNw6jEEKyVXl+nbZMSmNSswUeE+2cnlj2VmbAhdBfUiPooxSSwJbu2oTHliqWdrKDJrPRw2KBzLsc2PsyP61eSywyzTA8NIhGRC44mcZjkRY5bK5myMSUMMzwWZQzsjMfeUpACbCMwSRZ7peSekbBrf1oE5vL8+ys12rNOwV9a2t8L87ZGI/sPRTMV+N9jtGkuksc/nvBBSkb682T+ntZWo7LB56TC5gn0VlyMYUXAck0qKStnpYE8jwMjyOswg4Sc9UIWacisGqscPzojVNEJOPa0eXRHMjdcXsmpNIO7jLXS1bDm4yrJrcYUqR85fddlvpU6amcVU29pERuLqIQn7hQO+h8qh3P4IoX/oLOMpS6lgX2g2na6aSbYY93gTUEQJcF6a9o2OYFDigHIm4XIXL18fy8xPlxefR9CZd0DMVCJs+ppZf3F+0I8kNIZ37i+SnNNdgU03MR/PTcg+88yv8lxX0lH1WYTP73bS0aIxLxbD4P6LqR59iJonoX9yCUqzbYhu16GgLervrlXi+NSrGU64xXWTez24Nz6284GgirBD0SAFagvbgrjqaIjF9oszAq5lZG74WMYa7cvCXy6/YzvSHJYp8kgfmeLLlx0l7FzzWZhSmsLHHwZ3goMtYSo3DuIrgQzOFgUsuM6EQ1bt4Gn9B8jTFpV1NrnBRGcKYwOixAZhPJaSnkZzB23zrBLCO7Km76zNXPhxbtuUY6JU/VZIVAw3dq0MWpJQD6GernOzkRZX9ouaJUMIPhJZI6PSMVkv2NoqscQhOhKtZKv2L0tOtMuf6aTQ3DZUkbkRiG+C/ygRBgPRECpJ0l8e57d7dt7OrsHelfwq0P2/ImmYyVr55b1Q4m2ETIAnd9tbKESlUUB5d7JCYMSq9vKHwludsVWA0sZxA7izAx4/At8CmQKyM8TkQgewEBgiCfnnZyGWS8IXn2
 bA4eq9P9
 zWmsMWq1Vkj6vhLwUkpgMU1bBITPL0BD/FQwwctGJojU9/dSA2rCdz4xQmy11AD8OIAXOXuaoM5UZYrZ9aJJyojFjRRxp1E4jnUgokpNIxZOeaTBuwR5jaePhtjhauhSM+J6I2mCSvbDHBfdVWzr6fHGS7wOTmefKAIgMYwLzZdlD7iRkrkRXsTEmNkW/kLRXqGPGpZMbtJHCWP6KV6yloaMzUcbdloNfVuM9TH6Jht7L9ukLGaUWH33fWc5eOQGiMMI5a/bt1xZZcLVIgf0aZ+d9XK7AgeFjQ9o+/taq4HOzX7kuuYvh++19lw9v1tIH2CwqJv3rArpia6HQZB/uhb8yYS9p9KV96Nao+5LHPFkgS7jG8QI5/KPmgA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> Because the very same problem can likely be triggered by having the
>> splitting/unmapping be triggered from another thread in some other
>> code path concurrently.
> 
> I was previously testing on 6.12 and didn’t see any changes to vfio-pci or
> pagewalk.c which prompted me to check whether I could reproduce the
> bug in a more recent kernel.  
> 
> However, when I tried to reproduce the bug on 7.0-rc2 (after adding some
> tracing to get a clearer picture of the sequence of events) it doesn’t happen.
> The VFIO DMA set operation is much faster on 7.0, so possibly the race 
> window is too small for it to occur in reasonable time.

Interesting. You could try adding a delay to a test kernel to see if you
can still provoke it.

There is the slight possibility that something else fixed the race for
your reproducer by "accident".

[...]

>>>
>>>
>>> Hehe, first timer, still figuring out the process.
>>
>> :)
>>
>>>
>>>
>>> I think so, the bug can be easily triggered by repeatedly booting up a VM that passes through a PCI device with large BARs while continuously reading the numa_maps of the main VM process. The reproducer script is mainly to narrow down to the specific part where the race occurs, the VFIO DMA set ioctl.
>>>
>>> Should I raise a bug email to refer to, and resubmit a new RFC v2 (without the cover letter), or keep discussion in this thread for now?
>>
>> No, it's okay. Let's first discuss the proper fix.
>>
>>>
>>>
>>> Have only seen it with PUDs, will try forcing the mapping to happen with PMDs tomorrow.
>>
>> Can you try the following:
>>
>>
>> From b3f0a85b9f071e338097147f997f20d1ac796155 Mon Sep 17 00:00:00 2001
>> From: "David Hildenbrand (Arm)" <david@kernel.org>
>> Date: Tue, 10 Mar 2026 10:09:39 +0100
>> Subject: [PATCH] tmp
>>
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>> ---
>> mm/pagewalk.c | 22 ++++++++++++++++++----
>> 1 file changed, 18 insertions(+), 4 deletions(-)
>>
>> diff --git a/mm/pagewalk.c b/mm/pagewalk.c
>> index cb358558807c..779f6fa00ab7 100644
>> --- a/mm/pagewalk.c
>> +++ b/mm/pagewalk.c
>> @@ -96,6 +96,7 @@ static int walk_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>> static int walk_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
>>   struct mm_walk *walk)
>> {
>> + pud_t pudval = pudp_get(pud);
>> pmd_t *pmd;
>> unsigned long next;
>> const struct mm_walk_ops *ops = walk->ops;
>> @@ -104,6 +105,18 @@ static int walk_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
>> int err = 0;
>> int depth = real_depth(3);
>>
>> + /*
>> +  * For PTE handling, pte_offset_map_lock() takes care of checking
>> +  * whether there actually is a page table. But it also has to be
>> +  * very careful about concurrent page table reclaim. If we spot a PMD
>> +  * table, it cannot go away, so we can just walk it. However, if we find
>> +  * something else, we have to retry.
>> +  */
>> + if (!pud_present(pudval) || pud_leaf(pudval)) {
>> + walk->action = ACTION_AGAIN;
>> + return 0;
>> + }
>> +
>> pmd = pmd_offset(pud, addr);
>> do {
>> again:
>> @@ -176,7 +189,7 @@ static int walk_pud_range(p4d_t *p4d, unsigned long addr, unsigned long end,
>>
>> pud = pud_offset(p4d, addr);
>> do {
>> - again:
>> +again:
>> next = pud_addr_end(addr, end);
>> if (pud_none(*pud)) {
>> if (has_install)
>> @@ -217,12 +230,13 @@ static int walk_pud_range(p4d_t *p4d, unsigned long addr, unsigned long end,
>> else if (pud_leaf(*pud) || !pud_present(*pud))
>> continue; /* Nothing to do. */
>>
>> - if (pud_none(*pud))
>> - goto again;
>> -
>> err = walk_pmd_range(pud, addr, next, walk);
>> if (err)
>> break;
>> +
>> + if (walk->action == ACTION_AGAIN)
>> + goto again;
>> +
>> } while (pud++, addr = next, addr != end);
>>
>> return err;
>> -- 
>> 2.43.0
> 
> That works, awesome!
> 
> interestingly enough the VFIO ioctl now also returns “[Errno 22] Invalid argument” where
> I would previously see the process reading numa_maps crash.
> 
> [dma_map]
> dma_map iova=0x000000000000 size=0x000004000000 vaddr=0x00007f7800000000
> dma_map FAILED iova=0x020000000000: [Errno 22] Invalid argument
> dma_map iova=0x040000000000 size=0x000002000000 vaddr=0x00007f5780000000 

Just to double-check: is that expected?

I wonder why "-EINVAL" would be returned here. Do you know?

> 
> For my own understanding, why is this patch preferred over:
> - if (pud_none(*pud))
> + if (pud_none(*pud) || pud_leaf(*pud))
> in the walk_pud_range function?

It might currently work for PUDs, but as soon as we have non-present PUD
entries (like migration entries) the code could become shaky: pud_leaf()
is only guaranteed to yield the right result if pud_present() is true.

So I decided to instead make walk_pud_range() look more similar to
walk_pmd_range(), which is quite helpful for spotting actual differences
in the logic.

> 
> I do think moving the check to walk_pmd_range is a more clear on the code’s intent and
> personally prefer the code there, but I don’t see why this check is removing the possibility
> of a race after the (!pud_present(pudval) || pud_leaf(pudval)) check, as to me it looks
> like the PMD entry was possible to disappear between the splitting and this check?

I distilled that in the comment: PMD page tables cannot/are not
reclaimed. So once you see a PMD page table, it's not going anywhere
while you hold relevant locks (mmap_lock or VMA lock).

Only PMD leaf entries can get zapped any time and PMD none entries can
get populated any time. But not PMD page tables.

> 
> Anyways, regardless, this patch resolves the bug and looks good to me - what’s the 
> course of action as we probably want to backport this to earlier kernels as well. Shall
> I send in a new PATCH without cover letter and take it from there?

Right, I think you should:

(1) rework the patch description to incorporate the essential stuff from
    the cover letter
(2) Identify and add Fixes: tag and Cc: stable
(3) Document that we are reworking the code to mimic what we do in
    walk_pmd_range(), to have less inconsistency on the core logic
(4) Document why you think the reproducer fails on newer kernels. (or
    best try to get it reproduced by adding some delays in the code)
(5) Clarify that only PUD handling are prone to the race and that PMDs
    are fine (and point out why)
(6) Use a patch subject like "mm/pagewalk: fix race between unmapping
    and refaulting in walk_pud_range()"

Once you resend, best to add

	Co-developed-by: David Hildenbrand (Arm) <david@kernel.org>
	Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Above your SOB.

To get something like:

	Co-developed-by: David Hildenbrand (Arm) <david@kernel.org>
	Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
	Signed-off-by: Max Boone <mboone@akamai.com>

Note that the existing

	Signed-off-by: Max Tottenham <mtottenh@akamai.com>

Is weird, as Max Tottenham did not send out this patch. If he was
involved in the development, you should either make him

	Suggested-by:

Or
	Debugged-by:

Or
	Co-developed-by: + Signed-off-by:

See Documentation/process/submitting-patches.rst


Let me know if you have any questions :)

-- 
Cheers,

David

