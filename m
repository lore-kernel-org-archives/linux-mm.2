Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEA9DFF8873
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 12:33:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3570A6B0088; Thu, 30 Apr 2026 08:33:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 307E46B008A; Thu, 30 Apr 2026 08:33:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21DFE6B008C; Thu, 30 Apr 2026 08:33:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 121D26B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 08:33:06 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A873E1C01A0
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 12:33:05 +0000 (UTC)
X-FDA: 84715161930.29.0A90888
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 629E71C0004
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 12:33:03 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=l7HQCUDy;
	spf=pass (imf18.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777552384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yvT7alaoKdIhI5kLbvRhB8hj+B8HpDJWHuvkd80iS4M=;
	b=D98mksRu6+rDKuiefQ60BcH466S1uWfWQY+W039uxisayEMrSFHwhtqed+xCB7BfKvCXM1
	aYXy6mkHJZGdeFwehAzwO0IhsPlicnrBq5xmmeUMCVBE/5skeVMq77DiTe9F7rjzqFLROj
	fl5+kijhiDwJjLuLk74l8C4GA7WLv6o=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=l7HQCUDy;
	spf=pass (imf18.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777552384; a=rsa-sha256;
	cv=none;
	b=ONKGaEGWBMI2qw1UKydkwSp3Ne/q4OXVsN+TXLhFShJOxdrHyYJxtFRncbbUzEHVFRlJ6U
	5PoCaU+bOJVPjjvi32Tx77frcapWOzzw6qlTEq529kDroGZ03/MH4H4PKCA/q3P4OP+aEv
	pAXvRPxDtzwZPihUOduEwiVp9dpNq6k=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9DE3219F6;
	Thu, 30 Apr 2026 05:32:56 -0700 (PDT)
Received: from [10.57.90.96] (unknown [10.57.90.96])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 120723F7B4;
	Thu, 30 Apr 2026 05:32:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777552382; bh=Kmi7hh+sO6z2S3y8opc1Fyz09zGGdr9v7xC+7nSlt1o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=l7HQCUDyMDl141q50c9CPFNzaRun/uJJSrTG+cDq+t5dHzHX/7fZFsawMzauuUqbo
	 2hqU40o6oMaJ2JL32aGkaUS3q3l5HHCoP3KLaTYiE5SZ2+XtTqVpUywpHxLT2IqzXL
	 BFRC6vsF5AFL4+5quCkrbFdsyVLq2RX89OG+XyAM=
Message-ID: <74bddfeb-0530-4cca-af17-a7920f17bb5b@arm.com>
Date: Thu, 30 Apr 2026 13:32:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/3] mm: Free contiguous order-0 pages efficiently
Content-Language: en-GB
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Muhammad Usama Anjum <usama.anjum@arm.com>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>,
 Uladzislau Rezki <urezki@gmail.com>, Nick Terrell <terrelln@fb.com>,
 David Sterba <dsterba@suse.com>, Vishal Moola <vishal.moola@gmail.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
 david.hildenbrand@arm.com
References: <20260401101634.2868165-1-usama.anjum@arm.com>
 <20260429103326.GA1743@cmpxchg.org>
 <20260429050430.d86f01dbe731edc9fa932add@linux-foundation.org>
 <9834200a-492c-4705-a2b2-e76cc0ba5392@arm.com>
 <20260429135228.GA1987@cmpxchg.org>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <20260429135228.GA1987@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 629E71C0004
X-Stat-Signature: ad4ycomobsxufajuknago4y93cjxk7gr
X-HE-Tag: 1777552383-325961
X-HE-Meta: U2FsdGVkX18YzuOkJY/GBoStBLBbFG34pi+TuYKGKXFh6CzO7wcfPukO44hx7OwhNjT9tftjHPNmJ0xxVmWAhKoshTjtm46ZogvaarK++Zyin8C36XaVjpmWakzFsk5kQ72erJ1Yn7VYciuv3SmxwLxvmBTZ0g6moDIIOTOYTNyppxTRGQv6zKWEOvUggV7jsRBYYpjqiZ0SDpkMaXE6tpDTUtJfBxxgpHpgO4tWUoqWJ8iQ6lTqLqex7hhuyHY3DQWh3Nn1MseH7e9xlC+XgF/WidPYhJzW1RBxuHGLvCxxL/PZqsjcwTVDbsP03CnK4rLbNRc6Y3s9EWE5sYSf58fWKGHXX8CLy5isdDlzspINDcaTmjdlTUiQTAGPrmVa45VJfqMEFC5Pzh5Y+xVrsNNeThVQNdwNs9JwtcFqji+PNrxrVavX7fp5MfEOw1MPZYcYpLJyUesNgTJdfqMzTws6X1bduqXktMy8kk3R4Q1wWvPaQwRsq9n/pWKwCP0iRZt8LxQcsqP/L+UvQUU61net7TXfzTvrSMDLe3uHSPkXFviyru763vV5L9S2bTgWWt9Boiw3jRfzoZhykv8o/zNXexCEtHcx92YSAemxMCKQNQKxQvZnB/VK3N5n7ST2lnrUow3mupnXp45IKKHfuLG9o3jwW8JeQGhQCvdIA0DwmCbspEgzO0HPLfBQ3yZiSGhzbByrRmFbRQ5++s3C38qrxPQxSvX3ulr30Q7Q3C2+RauDWyrMmaf/e+J1oIyKyrRbE/b/ZWyP8la8biHIztnq89KXKClrXfev6VEbixH7RqmHr17k4fjVQOZuBJWcuhNnBnt+8OQA01oiDJ07IiA/6d2QHYcWLlpFOMnJ7rmsKMxCes1qvoYear4TQdHCWQN7Ec1oMRlF4z/RkOK0u/GGrFUV4Hca7vz4OhmmFON6VbpPkEBi+TDLth9JBufwCkQpmzwrjtDnnXTe+Q7
 qwjqJX1b
 iEgouQiD/c/30ykcJzo9/ksOd2yL814wIbYl0yzOPUK1LzXQOi3gOU7nKGkvO/aDIGTNGMyUDoxo42LnsRcvE6/55QpuKvQjn6Gb7e4vsavpOzswKMpSwPwHOh/nvWAR2GfolKx9dXhoa0tyU0b2OGOI5CVcCKguePLeBq6+bxpevvERPz50QYsIGPzeVegJw3mpEwdK9dIE+x6wG5TeCsVEpn/V9yWVOQoVlKvdPWyvzFDgs6dbzqXx/HPVGb/q1PaiKsBpih8QhJxBjXChtQJ+8f7NI8BprdkKXzBCR820J8Hat0ha5re0olL3Dm+czmXYEkT5KZsuBcDiwLE+dJt1tZ/Ei0Ck5LckIZN38u+LlKnE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29/04/2026 14:52, Johannes Weiner wrote:
> On Wed, Apr 29, 2026 at 01:31:10PM +0100, Ryan Roberts wrote:
>> On 29/04/2026 13:04, Andrew Morton wrote:
>>> On Wed, 29 Apr 2026 06:33:26 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:
>>>
>>>> On Wed, Apr 01, 2026 at 11:16:18AM +0100, Muhammad Usama Anjum wrote:
>>>>> Hi All,
>>>>>
>>>>> A recent change to vmalloc caused some performance benchmark regressions (see
>>>>> [1]). I'm attempting to fix that (and at the same time significantly improve
>>>>> beyond the baseline) by freeing a contiguous set of order-0 pages as a batch.
>>>>
>>>> I think we should revert the original patch.
>>>>
>>>> The premise is that we can save some allocator calls by requesting
>>>> higher orders and splitting them up into singles. This is a frivolous
>>>> and short-sighted use of a very coveted and expensive resource.
>>
>> I'm not sure it's that simple. First off, vmalloc has preferred to allocate high
>> order pages for quite a while, it's just that the patch you're referring to
>> makes it try even harder. So reverting the patch doesn't completely revert the
>> behaviour, it just reduces it.
>>
>> Performance benefits because those high order pages are mapped appropriately in
>> the page table - i.e. 1G PUD, 2M PMD, (or 64K CONTPTE on arm64). So it's not
>> solely about the number of cycles spent in the allocator; the HW is used more
>> efficiently. vmalloc only splits to order-0 for the benefit of the caller,
>> because there are some places that assume they can access each returned struct page.
> 
> Sure, TLB benefits can offset the cost.
> 
> PTE mapped higher orders on systems without contpte (still many) are the problem.

Perhaps vmalloc should only request the high orders when it knows it can map
them beneficially then? (which I guess was the case prior to the patch in
question?).

> 
>> And all the order-0 pages of the original high order page are freed at the same
>> time, so it's not like we are destroying the contiguous resource; it remains
>> intact for the next user (well, ignoring that some will be freed to the pcpu
>> list - this series solves that wrinkle). I've heard it argued that this approach
>> is actually _better_ for conserving contiguous blocks because it's keeping the
>> lifetime of all the constituent pages bound together and reducing fragmentation.
> 
> You're still consuming contiguity and increasing competition over
> it. That needs to pay off in a closed system, not just in one small
> part of it.
> 
> I'm a bit skeptical of that beneficial effect. Sure, if there aren't
> any small fragments and most everybody is doing larger allocations,
> then yes, this could make sense. Although in that case, even calling
> the buddy allocator repeatedly from vmalloc would give you physically
> adjacent pages due to the way splitting works (although I'm not sure
> right now if you'd get the right exact PFN order for contpte).
> 
> But as long as there is a mix of allocation sizes with mixed
> lifetimes, consuming contiguity that you don't need has a high cost
> over vacuuming up holes and fragments. Because now you're competing
> with somebody who has no choice but to *painstakingly move live pages
> around to coalesce the holes*.
> 
> That's the whole reason for the __rmqueue_smallest()-first policy in
> the page allocator. It's fine for somebody to challenge this. But it
> feels pretty strange to make a unilateral decision in vmalloc that
> works around and inverts established allocator policy, with very
> little data to boot.
> 
>> I've never seen any data though...
> 
> Yes. Considering the possible externalities of this patch, IMO we
> should have much more data on big picture behavior, under varying
> pressure situations and workloads etc.
> 
> The reason for my email was that we see this hurting in experiments
> with new code. The vmalloc higher-orders cause a sharp increase in
> compaction activity, subsequent lock contention in zsmalloc migration
> callbacks etc. I wasn't just making this up.

Fair enough.

For the avoidence of doubt, are you also suggesting that this series should not
go in or just that a06157804399 ("mm/vmalloc: request large order pages from
buddy allocator") should be reverted? If the latter, then perhaps it's best to
move the discussion to that thread to catch Vishal and Willy's attention?

Thanks,
Ryan




