Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DEACC79F9E
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 02:41:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 042856B0093; Mon,  7 Sep 2026 22:41:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F374D6B0096; Mon,  7 Sep 2026 22:41:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4B506B009B; Mon,  7 Sep 2026 22:41:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B44916B0093
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 22:41:33 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5B69A1C1AAA
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:41:33 +0000 (UTC)
X-FDA: 85189044066.21.6974B37
Received: from mail-m602.netease.com (mail-m602.netease.com [210.79.60.2])
	by imf08.hostedemail.com (Postfix) with ESMTP id 49DC8160006
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:41:29 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf08.hostedemail.com: domain of zhen.ni@easystack.cn designates 210.79.60.2 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788835291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Nyoxs0BEx74ILkCWFnwfWvcoD5NnSEmNtXZobMUFMl8=;
	b=cATo6aS0H8M5SJC31XfiE+ETZ3XU6irAeXrSpRGY+QAPKmcfrcG1ugwjfw99XlEtVRylLb
	aRklq1EiJ0uBdPc7uu+MZPNmtV6uArB87CixpQVUa4ol+zRYRXLNn1oHV8ltpjGDB3nnC9
	aTPoaJhwzYzN0HUq+YslLQNPZG/EQL8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf08.hostedemail.com: domain of zhen.ni@easystack.cn designates 210.79.60.2 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788835291;
	b=4oHxUBIU7J/7VkEkK72csC2H28jJVDqUO8DN6w/7TehBh8EIc019w7fJ1mDhNyeJFkojwb
	NEE+H3JyyNvCH1/ajVU+VX66+jvHNM8s3/Az4SxBNS9zQmHea0Z5dY+KdGzylRAybF2Qhn
	sCnIBE0ybENA7KHtsAcpnbbUeWAVO5Y=
Received: from [192.168.0.59] (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1ece1b045;
	Tue, 8 Sep 2026 10:41:23 +0800 (GMT+08:00)
Message-ID: <6744bcdb-3456-4ba2-95a0-a58c354bfbfa@easystack.cn>
Date: Tue, 8 Sep 2026 10:41:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/8] mm/page_owner: Add PID/TGID/COMM and cgroup
 filtering
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 Steven Rostedt <rostedt@goodmis.org>
References: <20260903041819.1776630-1-zhen.ni@easystack.cn>
 <a6ce8684-116b-42f2-a88c-154eb86bad59@kernel.org>
 <a98bde94-d1fb-4246-b7c6-e64303d8388a@easystack.cn>
 <5d4c247c-b8ea-4d3f-b2b9-d442d372fd03@kernel.org>
From: "zhen.ni" <zhen.ni@easystack.cn>
In-Reply-To: <5d4c247c-b8ea-4d3f-b2b9-d442d372fd03@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa07ee443440229kunma965adf619bcf2
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkZTx1LVh1MTE5PGE1CQ01MGlYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVCQk
	lOS1VKS0tVSkJLQlkG
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: n6iyfi3q3trdd9rdebdj7ga19edkow8d
X-Rspamd-Queue-Id: 49DC8160006
X-HE-Tag: 1788835289-754773
X-HE-Meta: U2FsdGVkX1+uE+CYliSplACgaYiXgcIH4N+vuekHWvggIBMDU3shLCIQoidUvIxLt721Sxv5VwJJZt+b7MXj/Hu5WxtCHvZyGkTB3uV+MkIZZdGzGVgO5FnDYseKQmBGDkMe2iJy9rI/JScU75CQ7JABQA7E7Kl6jwEXGbLnMItNmEATdP/Im7FsIkYjsLo6JHdbZ/I170ikwNniW728xajjW4DS4QZUfH6dcNd9r/rqqpA7TFlIPUcRrfaOUbCXvoukfPzlciOq5TNvso7DLIrcCUkXJLBtwkJYODi/b9eEVl0jCcq8iMuiIvJq1oryRlNzHefiDmHYjycoGOc86MpVgXo5CheZ2beemqYVF7pH0uFzp1YEnEc8lTUNmlKVllwFNl9n+fSJwUd9LrT2S+C9eBvN+kbLG3pNYo6ko9xozR84H12dywJ4KBoFZmpIOIXTsU/TpWX8mcJ3F8Kmsq2oPuRZw/A0VKZK2+G/l9Krmq2uunzYhKL/li0jt8CaG8zeI705rClS55KFp3ga5KtsmSc1r38vrE2WGoWe+QHXniL1Iztz0lmWg269z8jgmPGlj5qMV7WKRkHeOIZrN0uACNPWyek/btc4UtZ67m+JCltuifrRH7BMPh2zMJSVKB/reCcrj8SiJFX1LZ0KbtL39+Bfbs8If1XwusRkEPNJV5jI9uhdM1Wqv1zXDCNBHKYKn6Li57pU7EB1/V6M4husfrz2wMTpGXcY0xCxCW+VDdk3gl3ntMg11qRRbrMPHnu4z49KBWdRRCqcojijRTCPRH8HQzCDza0NOaP+m0f+qCjOKEL0QLpL8hXoM5BA8Cvg1jcQEXiAJqG4qsvaSDntHPoGIqUadZkA+Qa8+bwtx+6UskT5FqICOcHw/d7dd3Eo87LCz3qRXwbtodQjsiQrk8uQMRa3unGHvddbZHa36sifWfN3f4SeMArC42NrAiBkK1kaUJhLgeTucp1
 uH5BuoYg
 ZMrA9iKyBQETmZIEKCTqnhJKyvyON1kN11S6p38yBeEr3Wy6hi6RY3+jM4yXtBnygWxCleqyqy02ZkFIcPz3uP0nJiQbHEnt68sO26jni5OnC8sdsDZOjyqxd9YbCq5X3UuFZidsOmqZ+ZuhHjddRDHDFbcC6Cb7nnnVewbNXUa16/HY/23NLxwRYVqpFMk7WO0/KzmPA5tpglMFzTMn/o6ninySSQR1UydhnmQ/tuKvuXqYAiyCazFtHfhgfhO3SLdsfBzUv+hWfS9vd/x8aPHTZ5tI4L9Sc+xAfRqkwxi9Osmzu7IvfGqMS0WTIWgPOnsX9DFkKiFN6oe8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/9/7 23:21, Vlastimil Babka (SUSE) 写道:
> On 9/7/26 06:08, zhen.ni wrote:
>>
>>
>> 在 2026/9/4 16:25, Vlastimil Babka (SUSE) 写道:
>>> On 9/3/26 06:18, Zhen Ni wrote:
>>>> This patch series adds process and memory cgroup filtering support to
>>>> page_owner. Following the previous series that introduced print_mode and
>>>> NUMA node filters:
>>>>     https://lore.kernel.org/linux-mm/20260707115411.1714314-1-zhen.ni@easystack.cn/
>>>>
>>>> This series adds filtering capabilities to page_owner, allowing users to
>>>> filter output by specific processes and memory cgroups. Users can now
>>>> filter page_owner output by PID, TGID, COMM (with wildcard support), and
>>>> memory cgroup path. This makes page_owner debugging more focused and
>>>> efficient for tracking memory allocations in specific contexts.
>>>
>>> I wonder about the usefulness of all the new filters. In my experience
>>> page_owner is useful to find a kernel memory leak code, and for that the
>>> stacktraces are most useful. Dealing with things like pid/tgid/comm/cgroups
>>> sounds more like your aim is to profile and optimize particular userspace to
>>> use less kernel memory? In that case, isn't it rather the area of memory
>>> allocation profiling (or maybe tracing with bpf), not page_owner?
>>>
>>> Moreover, tracing or bpf can already do such kind of filtering and AFAIK
>>> ftrace filters for tracepoints are nice and generic, while this is adding a
>>> bunch of custom parsing and filtering. So that makes me somewhat sceptical.
>>>
>>
>> Thanks for the review, and the scepticism is fair - let me first
>> clarify where I agree with you, then explain the niche I think these
>> filters fill.
> 
> Sorry but your whole reply reads like a LLM slop. It took a lot of mental
> effor to actually try and engage with it.
> 

This reply was written by me, and its viewpoints are not simply copied 
directly from an LLM. The LLM only assists with the wording.

>> In memory usage source analysis and memory leak analysis, I believe
>> page_owner has its own unique niche:
>>
>> 1. Nearly all historical allocation records are queryable. Dynamic
>>      tracing tools (bpf, ftrace) cannot do this.
> 
> This seems totally the opposite. page_owner gives you the current allocation
> snapshot. Tracing can provide the full historical record of allocation and
> freeing, which can be also postprocessed for snapshots.
> 
Here you completely misunderstood my meaning, perhaps I did not express 
it clearly.

The biggest difference between page_owner and dynamic tracing tools is 
that page_owner traverses all currently allocated pages using PFN; 
whereas dynamic tracing tools can only view pages after the observation 
point is established. The pages collected by page_owner include those 
from relatively early in the kernel — as long as they are still 
occupying memory, they can be detected. This is what I mean by 
"historical allocation records."

>> 2. The full allocation stack is recorded via stackdepot. Memory
>>      allocation profiling as a code-tagging technique cannot do this.
> 
> I think there's some extension (or plan for it), Suren would know better.
> 

I have previously researched the code and documentation of Memory 
allocation profiling, so this viewpoint is not directly copied from an 
LLM. The reason I think it cannot record stacks is: its design goal is 
to be lightweight and usable in production environments, therefore it 
chose the code-tagging approach. If it recorded stacks, it would already 
deviate from its original design goal.

>> 3. Zero extra usage cost (works as long as page_owner is enabled) and
>>      a low barrier to entry (one echo line versus writing a bpf
>>      program).
>>
>> On the pain points that motivated the series. On production machines
>> with large memory configurations (e.g., 250GB+):
>>
>> 1. Collecting page_owner information takes minutes to tens of minutes.
>> 2. The output is several gigabytes to over 10GB.
>>
>> That makes the raw output nearly unreadable and forces post-processing
>> with tools/mm/page_owner_sort.c, adding further workload. The root
>> causes are:
> 
> the "workload" is just cpu time though

This workload is not just CPU — printing the stack takes up the vast 
majority of it.

> 
>> 1. The PFN scan itself - unavoidable, it is the price of page_owner's
>>      core function of covering every page.
>> 2. Printing every stack for every page - this dominates the cost and
>>      is avoidable. stackdepot already deduplicates stacks and keeps a
>>      refcount per unique stack; page_owner then re-prints the same stack
>>      once per page, and page_owner_sort deduplicates it all over again
>>      in userspace.
> 
> Since it's avoidable, why mention it at all? Oh I know, LLM slop.
> 

I feel like you haven't really understood what I'm trying to express.

>> The filters target exactly this waste: they keep page_owner focused on
>> the user's area of interest instead of paying the full print cost.
>>
>> On the overlap with dynamic tracing and allocation profiling: the
>> features do look similar, but the usage scenarios differ. page_owner
>> is not enabled by default on production systems, so most developers
>> rightly reach for the lighter-weight tools first - dynamic tracing or
>> allocation profiling.
> 
> Good! That's an argument against.
> 
>> But when page_owner is already enabled, or the
>> lighter-weight tools cannot solve (or cannot conveniently solve) the
> 
> Adding custom filtering code to kernel vs user convenience is a trade-off.
> 
>> problem and enabling page_owner is an option, the advantages above
>> kick in: the historical snapshot is filterable in place, and the
>> filtered output is small enough to read directly.
>>
>> So I see the filters as completing page_owner for the scenarios where
>> it is the right tool, rather than competing with the profiling and
>> tracing tooling.
> 
> I'm not convinced it's worth it.

You may keep your opinion. I think you haven't carefully read my reply, 
or you simply assumed this is just an automated reply from an LLM.

Perhaps you haven't actually used page_owner on a server with very large 
memory to investigate memory usage or leak issues (for example, the NIC 
ring buffer usage problem cannot be solved with dynamic tracing tools). 
Once you've used it, you'll know how much you need a filter.


Thanks,
Zhen

