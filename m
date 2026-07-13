Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65EFBC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:37:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D7F26B0146; Mon, 13 Jul 2026 12:37:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73A9F6B0147; Mon, 13 Jul 2026 12:37:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DB506B0148; Mon, 13 Jul 2026 12:37:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1790D6B0146
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:37:48 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8EEA8A0011
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:37:47 +0000 (UTC)
X-FDA: 84984309774.20.F63FECA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id AC7A11C0003
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:37:45 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EMKYsEWE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783960665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u/P4qKRpyyO/IqxmO4MioJCCSc/ZdvDZK4M5KJUmWHU=;
	b=jayTcO7Jkc6/55t7MqajqhXLs4tsQpRn1Syt2b2pbN0gzA8yzy0Xz3+JBEBKPsqkzcUfgm
	AjPU9ZfW9oLuUtlTCR1vaqb2fZ11A6xcsCB3Mf73bW+BHk2KnYFqXHq62wBDudfgAL3L6g
	xleWCohmHaRN0nlaqxSv1gHRiu3FAXU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EMKYsEWE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783960665;
	b=hLQD605kF95CM6/DkxW+MhhiilN3EygL7zHP5FSKT8l4DjQzNl9xcmAxoHXPz3lLdn+RnQ
	SGh72qbtO5ry7aO4c42y7YXaHAt14xMajojgEoJFVWIQXgpdAPUSUtZfctD4Yr8tCtny74
	8ZOM+oaDV/kQ3CIWJSHl4Q3X0lng1BA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AC8D842E9B;
	Mon, 13 Jul 2026 16:37:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C8111F000E9;
	Mon, 13 Jul 2026 16:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783960664;
	bh=u/P4qKRpyyO/IqxmO4MioJCCSc/ZdvDZK4M5KJUmWHU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=EMKYsEWECwFyZOLAzrrUyIkqBqCAe/QiyW4dkMgZe21P2CsUOXzfyU8/5Kg4sMutT
	 CtgooL5RszapnkM2tGGpI2kRftv9v7OORyRGUrCp+C98Zl7iohEzKFoiCTYcj7sz4G
	 TTY17PEtXBfqDPGovkUYPjGGf+NIt2Zk2akuw5x/uv09CvzuCkpq2kvizw8CJSK3ud
	 mjKj7Am+v4uOApq6IlDDpQmLVUCajMTcOkkty0mOAAtSGW3PMyWUljcq1bjAw0MnF3
	 LlpsRbt3Thds+4gl/xEfTujN5gWBqFX3PnWbAfGwtGSRCnyLYUHlx2KJW5ggdtuBuK
	 bRtJUPBnzmXqA==
Message-ID: <0e7c2aff-a278-4118-a9a9-123c2735ed67@kernel.org>
Date: Mon, 13 Jul 2026 18:37:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 13/18] mm: Remove __alloc_pages_node()
Content-Language: en-US
To: Zi Yan <ziy@nvidia.com>, Brendan Jackman <brendan.jackman@linux.dev>
Cc: Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 "Harry Yoo (Oracle)" <harry@kernel.org>, Gregory Price <gourry@gourry.net>,
 Alexei Starovoitov <ast@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Hao Ge <hao.ge@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, derkling@google.com, reijiw@google.com,
 Yosry Ahmed <yosry@kernel.org>
References: <20260703-alloc-trylock-v5-0-c87b714e19d3@google.com>
 <20260703-alloc-trylock-v5-13-c87b714e19d3@google.com>
 <DJP0VKJLE8TE.6EDLC2BFI1SG@nvidia.com> <DJXJRNZFBPQ2.2S6CM4YAKHVQ5@linux.dev>
 <399958F1-544F-4826-90E5-B471E2231375@nvidia.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <399958F1-544F-4826-90E5-B471E2231375@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bsmoz5forqw7n3tyi7mc5mmmdbkxgyhw
X-Rspamd-Queue-Id: AC7A11C0003
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783960665-788814
X-HE-Meta: U2FsdGVkX18ycMsiZjkm7cEhKcQDrhsGysS0Rbseh5W7ldZij6unWBiqtNG1muEVWkUbZABPLKJ/vxdeKM1Bhxi1Cwe2FaFBtz2lUZE95N0TuXZA7V38ZA0g+0L9IhPiWuX5vqyocRAhB15JnIfLAdJxkJx2VagujlWGNvglpEV2GtcW6IK+DmhcX0eEUpDfIOITSsbjgDk66Ll9q1D57Xp2wzloWsqCXOP6y1t57j/xEzTC2ZGTKPUVIpD9gBD0HADTS31x6Q9eWAC04325+/05HuL0TjgbbI53XRgkEEuiFC0yICxec60GBf1U2z+j3WLuTq7eLA6ZHGhRjIITtXP4TkS1Jl2jYUPs+vgDPnbYaRVHwVDmKSbYLff47Ea1Ej/znelHKJqD4bUYjflfJ8q5/9s+xynKcrElY7iHJy2Kfh0caw3GloT6ES8p9jYKz1pQ2g/UfKtJ9f+dxYWcoDx7KEJwGlRIxJgHOLgzYLW/KyTLscd2aQ8mMpD70tCRMraQLbcn9Uq5TOu6qKB0KHoGwvJI5Mpz34wCOaGOVZmm7uq5BWIvSNwmR63WKNU3HinxMAmyw9MNYzwowyAq7ecJjIF4SOv8lnw6ft+tJlDnwbqQBJbyNCUmacagqMgT4YNXbaVevtb5xj3I6plBNNeF9BDSRHBvn+fnSHG1ZtTh+t4pXNGqXN7B52tqxux6lCoiglB12ayRygN/Lqt6EuC52X1aHOl00d8k03hMclrHsVqBlB6LTeCGnxQzyWvp5LPFTb29mnp9DpO5I+jXNdWbJ3Oo+acmlhbJBtJ/uP59/av5NrdvgfanKpZS4iKAJUQ1E7Tgq9KOOj63AI3JS4SUey2hHOnQPsPNqD/Dj+lJItLShSdRdu/lu0SHMZ1MDXkucNQ1Qu9iKfs+bxi/9TjVxv2N9qaJ5PnyGy6UVZ3luxxFeicP5+EYLe6SmJzvGeP4W0CBQa1HWZ/PR5R
 88t+Z38E
 dcRXcYxkVNRmj/sWNZtKN8ZMaQHk9lOJYW90PEqHADVTemoC5CJwo+3AX/KIP4wFMuX/qCMRqiw4LijFap1P5V1hZI4L7HtuIrEFSaroXOKXf/v2jZ3Ux/Ps+cgPsmoncYhizhXKgV5jg3TKGrLGjoNZMGHEbxLd5KEJq/WhmCGEXSOwBTlizrKi0YTd7S1TLOuLgbVFewS1uX26JFxQLqu5iF4cp4AAIwb0QEaNOyt8MHykwCe97e6qQjPZHhCg3G1t1UdCf4LUlxd2Tlg7lbHLC7cCabGt4G+R1JROSN5ds9FkcLfRiZnxjR4BpvgIfSWWiP6eZgwZN/R9l4ajMeuTl26Fr6kCmYE1GcGfYxP5EpXNcxtyt18III14GiVT/IZo9dAHy6AP7rCeV8tCfHcLsJ37RVPUQCLrpFybSs5X011v5my0s+r0PmgV5yHzchhMPtbqX9iJsrvg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/13/26 17:54, Zi Yan wrote:
> On 13 Jul 2026, at 11:26, Brendan Jackman wrote:
> 
>> On Fri Jul 3, 2026 at 2:57 PM UTC, Zi Yan wrote:
>>> On Fri Jul 3, 2026 at 8:31 AM EDT, Brendan Jackman wrote:
>>>> There were only a few users, which have been removed. The only advantage
>>>> of this API over alloc_pages_node() is avoiding a single conditional
>>>> branch. The disadvantages are:
>>>>
>>>> 1. More API surface, more sources of confusion, more maintenance.
>>>>
>>>> 2. Worse impact of CPU hotplug bugs: most users of __alloc_pages_node()
>>>>    were using the result of cpu_to_node(); if the CPU gets hotplugged
>>>>    out this will return NUMA_NO_NODE. If one of these paths fails to
>>>>    protect against a concurrent hotplug then page_alloc.c will use
>>>>    NUMA_NO_NODE as an index into NODE_DATA() and cause some horrible
>>>>    memory corruption or other. With alloc_pages_node(), the code might
>>>>    just work fine.
>>>>
>>>> Ulterior motive: this frees up the __* variants of the allocator APIs to
>>>> serve specifically for use as mm-internal API.
>>>>
>>>> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
>>>> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>>>> Signed-off-by: Brendan Jackman <jackmanb@google.com>
>>>> ---
>>>>  include/linux/gfp.h | 20 ++++----------------
>>>>  1 file changed, 4 insertions(+), 16 deletions(-)
>>>>
>>>> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
>>>> index 01d6d2591f49e..3bf55a5f9143e 100644
>>>> --- a/include/linux/gfp.h
>>>> +++ b/include/linux/gfp.h
>>>> @@ -256,21 +256,6 @@ static inline void warn_if_node_offline(int this_node, gfp_t gfp_mask)
>>>>  	dump_stack();
>>>>  }
>>>>
>>>> -/*
>>>> - * Allocate pages, preferring the node given as nid. The node must be valid and
>>>> - * online. For more general interface, see alloc_pages_node().
>>>> - */
>>>> -static inline struct page *
>>>> -__alloc_pages_node_noprof(int nid, gfp_t gfp_mask, unsigned int order)
>>>> -{
>>>> -	VM_BUG_ON(nid < 0 || nid >= MAX_NUMNODES);
>>>> -	warn_if_node_offline(nid, gfp_mask);
>>>> -
>>>> -	return __alloc_pages_noprof(gfp_mask, order, nid, NULL);
>>>> -}
>>>> -
>>>> -#define  __alloc_pages_node(...)		alloc_hooks(__alloc_pages_node_noprof(__VA_ARGS__))
>>>> -
>>>>  static inline
>>>>  struct folio *__folio_alloc_node_noprof(gfp_t gfp, unsigned int order, int nid)
>>>>  {
>>>> @@ -293,7 +278,10 @@ static inline struct page *alloc_pages_node_noprof(int nid, gfp_t gfp_mask,
>>>>  	if (nid == NUMA_NO_NODE)
>>>>  		nid = numa_mem_id();
>>>>
>>>> -	return __alloc_pages_node_noprof(nid, gfp_mask, order);
>>>> +	VM_BUG_ON(nid < 0 || nid >= MAX_NUMNODES);
>>>
>>> Could this become a VM_WARN_ON?
>>
>> Er, it will almost certainly crash later if this is violated. Personally
> 
> You mean in warn_if_node_offline() when accessing the nodemask?
> 
>> if I'm enabling DEBUG_VM I'd rather it crashes with a helpful stacktrace
>> instead of chasing random poihnters, likely corrupting memory, and then
>> crashing later in a completely undebuggable way instead.
> 
> In this case, VM_WARN_ON + return NULL could work, right?

See below.

>>
>> TBH I don't really understand the "don't BUG" culture we have in Linux.
>> I usually just go along with it coz it doesn't seem important enough to
>> argue about. But now I'm wondering: if we really don't like VM_BUG_ON()
>> why not get rid of it completely? I wonder if there's some case-by-case
>> difference that I'm not picking up on.
> 
> My understanding is that issues like the above one should be caught
> at development phase, so VM_WARN_ON() is sufficient.
> 
> The source of “don’t BUG”: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=1cfd9d7e43d5a1cf739d1420b10b1e65feb02f88
> You can read the commit message to know when BUG_ON() can be used.

Quoted from there:

    I'd prefer to keep all these warnings 'simple' - i.e. no attempted
    recovery & control flow, unless we ever expect these to trigger.
    [5]

So I wouldn't attempt recovery here.

> 
> Best Regards,
> Yan, Zi


