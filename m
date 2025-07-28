Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 938CDC87FCE
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 05:41:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F2086B008A; Mon, 28 Jul 2025 01:41:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A2646B008C; Mon, 28 Jul 2025 01:41:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 091676B0092; Mon, 28 Jul 2025 01:41:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E79406B008A
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 01:41:22 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 95C9312DAB9
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 05:41:22 +0000 (UTC)
X-FDA: 83712575604.03.E72587E
Received: from techbitestudio.com (techbitestudio.com [75.119.147.106])
	by imf16.hostedemail.com (Postfix) with ESMTP id 69752180002
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 05:41:20 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kenip.in header.s=mail header.b=dNLi3xke;
	spf=pass (imf16.hostedemail.com: domain of siddhartha@kenip.in designates 75.119.147.106 as permitted sender) smtp.mailfrom=siddhartha@kenip.in;
	dmarc=pass (policy=none) header.from=kenip.in
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753681280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=un3+I4PtG8unl1Hd7ukWnF6HXG0/MDVWa42ZNc5QU2Q=;
	b=OJhkdfJZSyke86TjzeJ+yy5EP9rOBEKuAajeGgj3lTKDwWuog0EChGZRLBGDInZCStFcSy
	cFhChSCyhi82fh72f3W+jdTQEs6HIs73NQaQp/fe2zV+nVhVYI03lRN1EdaiKbNtnOdpmC
	Hxb5Zq4+CQD3ROs1NJG5+Wo2B45v1Xk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753681281; a=rsa-sha256;
	cv=none;
	b=WGrayF3MP6d7BUknGEoLCX7ijx1261T47c/sK1ivWMUjM78zT4QYgB6F0kLmkQSfJP/Mx4
	hD0ol3dyjguTp+m9Y4heCQxXuMiFLA9OceSlLVFwUHgh+AHY5tU2V/MY858Q4yAk0P9OJl
	A74DOvRvc1DVATpSnbdb0tkChuTClTM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kenip.in header.s=mail header.b=dNLi3xke;
	spf=pass (imf16.hostedemail.com: domain of siddhartha@kenip.in designates 75.119.147.106 as permitted sender) smtp.mailfrom=siddhartha@kenip.in;
	dmarc=pass (policy=none) header.from=kenip.in
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=kenip.in;
	 s=mail; h=Content-Transfer-Encoding:Content-Type:Message-ID:References:
	In-Reply-To:Subject:Cc:To:From:Date:MIME-Version:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=un3+I4PtG8unl1Hd7ukWnF6HXG0/MDVWa42ZNc5QU2Q=; b=dNLi3xkeInk/bmIW4O+MYUDGxe
	bMqcetiLKlvQlywB3u/1boSNpctJ7EtawYRLurGlF3EzHVzFoitC+6mjlaHZMwhWq6MQXcByp4LfY
	eUThx81GqPOZIxF8UeD3AwFztSE7WATbBC9GopBYnTa4T2lz7AwHR9DwiSMvjJnT3AWo=;
Received: from localhost ([127.0.0.1] helo=kenip.in)
	by techbitestudio.com with esmtpa (Exim 4.93)
	(envelope-from <siddhartha@kenip.in>)
	id 1ugGbr-0001EO-AY; Mon, 28 Jul 2025 11:11:15 +0530
MIME-Version: 1.0
Date: Mon, 28 Jul 2025 11:11:15 +0530
From: siddhartha@kenip.in
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>
Subject: =?UTF-8?Q?Re=3A_=5BPATCH=5D_mm=3A_limit_THP_alignment_=E2=80=93_?=
 =?UTF-8?Q?performance_gain_observed_in_AI_inference_workloads?=
Mail-Followup-To: Dev Jain <dev.jain@arm.com>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>
In-Reply-To: <fd6cc30b-cc8d-4003-ba01-fefd5d696ec6@suse.cz>
References: <d8ffe547-5516-43e5-9f33-56b2698a0b4f@arm.com>
 <ba2c89bd-88de-48f8-abd0-b62d8b1d50b3@lucifer.local>
 <5816677a-705e-4a8f-b598-d74ff6198a02@arm.com>
 <ee92d6a9-529a-4ac5-b3d0-0ff4e9085786@lucifer.local>
 <e7152150-2f3e-4ad7-a6c5-f4b77e5c0e05@arm.com>
 <f746d3aa-17e7-4b42-9e08-97cdb2cad89b@lucifer.local>
 <80b849d4-faf3-47a9-8b8c-e8053299cfb2@arm.com>
 <2e99712b-8dac-4762-9fc5-fe3ef569b65e@lucifer.local>
 <afe95bb0-185b-4c4a-ae41-e02457422cc3@arm.com>
 <787639a1e6a27c0f3b0e3ae658e1b8e7@kenip.in>
 <5c3d307f-d303-48c3-b730-99a83d4815ec@lucifer.local>
 <6eaaa2e4-9067-47bc-8dd4-d8ef56c26b3b@arm.com>
 <5D015E99-474A-4D98-8C43-488A46BEB2F5@nvidia.com>
 <fd6cc30b-cc8d-4003-ba01-fefd5d696ec6@suse.cz>
Message-ID: <57c50dbbccf38a97e6e9cbb3f2f75f01@kenip.in>
X-Sender: siddhartha@kenip.in
X-Priority: 1 (Highest)
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 69752180002
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 7uk3dpc4m99xj96px5t48hooauje3q8y
X-HE-Tag: 1753681280-161125
X-HE-Meta: U2FsdGVkX19v2uUkrYeeo4F/3hYb7rFjJIFYecIZf/z3/UPBKFFq03vabRl8/rBQEXe3ykUXjiDd9dIpxfIzhtZrbl84Hp0jWbJNJ3Md54BQ4/Jr2bkEPZU5DY75bpQDNbFCU5v9vKWrz4MKIKEiFM+jJko2S6AdCNKi1x0LnaWTMG9+wLLjAKRRSpKQu10CnzOZhUJZPw1Obo5M9SpdanxqGdmsqG9hTxjT4KUofCMiKY1y3N9JdEm09dwAVG/F664H1bBaistcvHOCqFCxn7qWM90H8lsXpy/DQFHYvxd0etqPEFRawUuW338CZ9Q5z1TqTlFl6xYbG9nhSn0cNtQq+t9SpAoQAXyyhLFTbZqOPIMh5LU3q6G8APRI73ldFQeuFeC8ULvaucXl61LUUtBEgVBaL72wktzaaM0HQw8arWcYQwKX+gg7brHP9TzQiDFEgC+Y/7nNmDWaDMOA8gCVZleMGSMIGxXM8oXYEem46w76xrHOSw9VFav/mDpRd7lKu0aQ15ynEnW0bB61if8kMdowbZQUEqEPFdIXqZVTqzdfb6QVJNzd+9hUiWymZtxak5TRTJOCfWWm6m/qtUB1KTRvGCYsS25HRHsAH0HQHdesUpv+/EswVpMH2/z/JAUDJ/eIHBozGW87WJY67B65v8DfVmQKy2E9vIrvKVZAf3loEc5RGoPoeunWIOdjxqRYXBMy4Iq2v+2EnJvSjMg93ihbY6BYFgh7uQ+l8hX9477Bho0GSfPSHOaEYFoHCr8G0tZrrE07b9rY/Q+oB97e7hPF4DhYQQIDaYDojphZ+qMLCsQI2SZNja9IcnZfSpuaQd++Wj63V/fFGrL72QoIQiJIjCAbtuyLVRGvJXmJQwhwOm3fw9/5fLAVhizOyRUiwHbcljk7CQTwbfW09kDLxpg+WQWc3NBbTYT6hxuhGQ30aD8YSePTxf/63uyVvy2OxAmKjepa0T/firK
 JitCwwHd
 a/X5ZW2b2PGaRiEgwVfveKnup9RfAqSs64RT+BJEv8omx+Q5iGZR0cygP9oKsWAF52M/ktZDSnY/dqcWMwVAy3t9IpqMwJTxBsl2uJSBnI6RA0O8a72qf9G8Zmw3L9hwSgmB/+2vrLZ2PuROS93X1an43vWXTGcga6OBN+/CPHCyDGHBpWxcWApEdPW/ruxB6DF1W783d3QiyD5uL5giPFPFYMr/yyAS7o8fkJRQHa5PhLMNBLFZbOrKujssqpqM1eU8+pLbzHv54xLHuGz8bhZdl3aH2Au7PFkF81F0RxCoWT4w2bMyCX3HMEkOErhqqg2U81hil3YXdCttHbReQBnAq55KRRhxr7DhTkayjK4OGdi3kVAiNcbh/Ki6NWQ3mbULskVA8VqZPaJd2HpPIs6EAabIeID74TVJuw0LuvM4jSMjRqra25jTTpbcdLU5yZMtBMUsmvZ1gfDjwXI62WqOcgogrTZheXUcKkj8PsPYXkQpHKC+KLCXtYT7aBDa5IQSK3d3JL2/Ul/G8NdXTPWZjs/4BxmlLAukC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-07-07 14:26, Vlastimil Babka wrote:
> On 7/1/25 20:49, Zi Yan wrote:
>>>> This is very useful information and it's appreciated! Let's not 
>>>> drown this
>>>> out with restatements of stuff already covered.
>>>> 
>>>>> ⚙️ 5. mTHP note
>>>>> Although this patch doesn’t target mTHP directly, I believe a 
>>>>> similar logic
>>>>> tweak could apply there too — especially with shmem-backed 
>>>>> workloads (common
>>>>> in model servers using shared tensor memory). I’d be happy to help 
>>>>> test any
>>>>> changes proposed there to derive the consequent results.
>>>> Dev - could we hold off on any effort to do something like this 
>>>> until I've
>>>> had a chance to refactor THP somewhat? This is already a mess and 
>>>> I'd like
>>>> to avoid us piling on more complexity.
>>>> 
>>>> We can revisit this at a later stage.
>>> 
>>> Yes of course. I had run a small benchmark on a quick dumb patch I 
>>> wrote and I
>>> don't see any measurable perf improvement, probably because the 
>>> highest THP order
>>> getting chosen is always PMD size.
>> 
>> I think mTHP is much more complicated, since mTHP has many sizes.
>> Trying to adjust VMA alignments to get mTHP might not work well, since
>> you never know what sizes new VMAs are going to have.
> 
> Yes I agree it's more complicated. In case there would be a stream of
> allocations of varying small-ish sizes, aligning each of them to its
> smallest applicable mTHP could create gaps that wouldn't exist if we 
> ignored
> the alignment and just find any free area and in the end merge it to an
> existing one. Basically we'd risk recreating the issue with gaps.
> 
> Sticking to one size (2MB) mitigates this to some extent. Unfortunately 
> even
> after my fix the heuristics might be prone to gaps:
> 
> - all allocations not multiple of 2MB - will merge freely
> 
> - all allocations multiple of 2MB - the alignment heuristic will kick 
> in,
> but as a result allocations should still merge as all boundaries are 
> 2MB
> alignned
> 
> - allocations alternate between multiple of 2MB and non-multiple of 2MB 
> -
> this will still create gaps
> 
> Note we already had a report about ebizzy regressing due to my commit 
> [1]
> and I suspect it might be due to this kind of scenario. A proper
> investigation would be useful but I didn't get to it.
> 
> Maybe the solution is to first check if unaligned search gives us a 
> range
> that will merge with adjacent area, and only try the alignment 
> heuristics if
> it doesn't. This will still fail if mmap() is followed by e.g. 
> mprotect() or
> madvise() that will change an initially un-mergeable area to a 
> mergeable
> one. I have no ideas around that though. Just some thoughts to consider 
> for
> anyone wanting to change things here further :)
> 
> [1] 
> https://lore.kernel.org/all/019401db769f%24961e7e20%24c25b7a60%24@telus.net/
> 
>> IMHO, it might be better to align VMA to PMD or the largest mTHP size
>> (for example, on ARM64 with 64KB base page, PMD THP is 512MB, a 2MB
>> mTHP sounds more reasonable there) if possible and enable
>> VMA merging as much as possible for future huge page collapse.
>> mTHP can be used to fill the non faulted holes in VMAs if necessary.
>> 
>>> 
>>> Out of curiosity, where do you plan to do the refactoring?
>> 
>> 
>> Best Regards,
>> Yan, Zi
>> 
Hi Lorenzo, Dev, Mel,

I'm following up on this patch submission from earlier this month:
"[PATCH] mm: limit THP alignment – performance gain observed in AI 
inference workloads."

The change limits THP alignment to PMD-sized mappings, avoiding 
unnecessary hugepage over-allocations in scenarios where 2MB alignment 
is not beneficial. We’ve observed consistent performance improvements in 
inference pipelines (specifically with OpenVINO) where the workload 
profile includes a mix of small and large allocations.

Please let me know if:
- There has been any progress or feedback from your end,
- The patch needs to align with ongoing THP refactoring efforts,
- Additional benchmarks, test traces, or system-level profiles would 
help.

Happy to revise or refine the patch based on further discussion. Thanks 
again for your time and input!

For your information, I have also posted the same at Openvino and 
Huggingface forums and currently waiting for review for the commit on 
the Openvino github repository.

Best regards,
Siddhartha Sharma

