Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5B24C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 08:01:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9CCE6B0088; Tue,  1 Sep 2026 04:01:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D72FE6B00A1; Tue,  1 Sep 2026 04:01:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB08A6B00A2; Tue,  1 Sep 2026 04:01:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A124C6B0088
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:01:33 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0BF1EC0370
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:01:33 +0000 (UTC)
X-FDA: 85164448866.29.00AC742
Received: from mail-m93246.xmail.ntesmail.com (mail-m93246.xmail.ntesmail.com [103.126.93.246])
	by imf20.hostedemail.com (Postfix) with ESMTP id C8C541C0017
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:01:28 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf20.hostedemail.com: domain of zhen.ni@easystack.cn designates 103.126.93.246 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788249690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/DXH//t9RYtuCqD/0h2Mck4Tb/6lpuemgdPw8lkHID8=;
	b=5UVtIJrFP0lx1Gk3FKG4/GMY8s4ZJqOBFUHv1ry+O+LNnAvsUO+JFq+dpsSB1FYGfl/QZq
	KUKJu7vy9/s4qNqUZKUs0/HUumtPikRjx5UgEin9ZoeSWRnnUI7AxEG9dW/ZTJ0vWp+4Zl
	ddOxvKsI1nEXf4lTsLn8YWz/b8RZZsM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf20.hostedemail.com: domain of zhen.ni@easystack.cn designates 103.126.93.246 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788249690;
	b=zs8wqgN5CmK3xZlDrnqMZjXjPmMA7BVvP9iIyNDiuzpsOQS0HOpCOyK/Hg2KcSaXJLrMtU
	pCe4L74Z6JrC1Z4tOHt7IsgnndpZKkAHvxHMk2mO+mCEWlx2JLPkzBjXu5Yfyu6BKSi6lZ
	qI/5jl9LftieApPNW3OpDxcUiwvBp2c=
Received: from [192.168.0.59] (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1e8dcbb65;
	Tue, 1 Sep 2026 16:01:21 +0800 (GMT+08:00)
Message-ID: <ff7d838c-8ea7-4a91-86bc-f6899970cdcf@easystack.cn>
Date: Tue, 1 Sep 2026 16:01:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/8] mm/page_owner: Add PID/TGID/COMM and cgroup filtering
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap
 <rdunlap@infradead.org>, Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260828031339.1270699-1-zhen.ni@easystack.cn>
 <apEx0wT_hWs1Q5Wp@gremlin>
 <20260828113654.d01abd8baed3f73e87506eb3@linux-foundation.org>
 <9fce3210-3548-4df3-ae00-730b666f5d57@easystack.cn>
 <apZ99NHTmNI_nIwz@gremlin>
From: "zhen.ni" <zhen.ni@easystack.cn>
In-Reply-To: <apZ99NHTmNI_nIwz@gremlin>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa05bfcacc80229kunma31d9b2c27c472
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCTExDVk5OGEJNS0gfTBhJGlYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVCQk
	lOS1VKS0tVSkJLQlkG
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: j8j77izrxjxd6fcz7rdxdufddu3fq9xd
X-Rspamd-Queue-Id: C8C541C0017
X-HE-Tag: 1788249688-809494
X-HE-Meta: U2FsdGVkX1+XbD3coxMpKzXZ0iovs0TOvcqIzjpVypi8m7WVahmI56l+dVKW2CKgpbEmz/WRcJ+sFGm08nbiQaE/dBS/ONt5GG2bd8+o3m6z1m8ip7sriSR9xzD6imdepbg0Zumso3YNzbBDTrLZuM7WtiQcUjMiq5Gd45pTl91UFAczGESruU8R/c1AHZ94UvS9+o2tpWWgm97is6dJfHlSetsdSTd/43phQuIgHm9DCGDdN3WUv+aEUBwe4S/lg7AmXerGsrgReEXBEeO4R6qJH7ChxA9xOgeuq0/7IREthiVB+7R/hjZaWHsDH9tlN4BYUD/1D7aX+J9LH4p9GoK22l4avalTrl2/XHlXXWwK5nMv5NLLtdm6FGNFeoKLL9raVty9VMRtEJV3AueXOMYsKslLikXYRm6Mm+0ItYqb57OBrHQFkTTagghEhu8PInnnPfOSHkJLoAxGeGnQdZ/qKlqPDFKlw97R0Es4ecuEH+PjNBunzlgU9vxKLTSaLOFMYtWcfw54v88QsFKkQ8Mv9eQDxHDzT86REQ7oNJkrRL+PZgwQsA/ylxiWkIxoUu8fQ6n6b1ZKmv97qwRnIIAuUTs+r5uRl42vYY5a+707haPP8InhNcfUu5LirMAL40oTPQ31TvSlQREmTOoBuFOqmWm2NrJNowa93cejw+rNex3WpawNZopQincQHrRYGBlM0cWDqtxumvVe9OqeHOQUuXLhosNUzPvKJovVfEWVZdQ/z6o6ouKL8mAgTKYqnrZkiJ79DRN6TIPHerD4cGmCQdraB21xieylQ9O5CPmw4DdC6C+POL4Ff7GSa3v2KqQxYrDwRjZzTiGEivkrKHV8NPX8LxCZmagoseEeYNlgMOPp29smp2zwu49hLdl+R2OBCBZ5qp8xXxBVO4M+IEYBTjseVaYhWgqxGKl0/rtB2hvJWjdR5oxsnCGlUAlHKg5zkWM8vYW/RC3wwAw
 HAxeX4l7
 FQRQFK6CqcI+0D06pjtRiRBu0HMVJQ2JBsN4NOMOhuo1RsG002H3mf/DY8biXDRDEPuMqcVt6HpzRov5hFeZBQnMcHz0dm7RgcVRoNrUzyNHpFR2ii2P7d4D6F54jXwreAJIuZV65U56VOJWhthys6X20OG2kyAByGQeinIx3u/KOTMfAg8uVkdrVbmyt40VgmXgu4kilFSG5Kh7v/lMMIO3iuE9F6kO6Z3hwgAhrMLjh8Yr5FDzEUAc7txHYCtjIi6k61iKlIaOvbeBjrLVwzsBwFzD9bFU8tl6JIRYVj62DFBqLi+0YW+A2IyCF1lb8ekjLryY9iJ7A442tHZqirtlUtT/pBQSHxvm7ZYmQ4GCHXoiPMtOnHGMED5v5cW2DTB2pYCuiajIfjTzjDqF9pPYDjbVjzcuRCDKoytOXPDIlQyvOTUm9Ntif9LDQmdcerAK6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/9/1 15:27, Lorenzo Stoakes (ARM) 写道:
> On Tue, Sep 01, 2026 at 02:34:34PM +0800, zhen.ni wrote:
>>
>>
>> 在 2026/8/29 02:36, Andrew Morton 写道:
>>> On Fri, 28 Aug 2026 08:03:38 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:
>>>
>>>> On Fri, Aug 28, 2026 at 11:13:31AM +0800, Zhen Ni wrote:
>>>>> This patch series adds process and memory cgroup filtering support to
>>>>> page_owner. Following the previous series that introduced print_mode and
>>>>> NUMA node filters:
>>>>>     https://lore.kernel.org/linux-mm/20260707115411.1714314-1-zhen.ni@easystack.cn/
>>>>>
>>>>> This series adds filtering capabilities to page_owner, allowing users to
>>>>> filter output by specific processes and memory cgroups. Users can now
>>>>> filter page_owner output by PID, TGID, COMM (with wildcard support), and
>>>>> memory cgroup path. This makes page_owner debugging more focused and
>>>>> efficient for tracking memory allocations in specific contexts.
>>>>
>>>> The majority of this cover letter feels like it should have been
>>>> documentation put somewhere :)
>>>
>>> yes please.
>>>
>>> The only thing longer than the cover letter is the Sashiko report ;)
>>>
>>> 	https://sashiko.dev/#/patchset/20260828031339.1270699-1-zhen.ni@easystack.cn
>>>
>>>
>>
>> Hi Andrew, Lorenzo,
>>
>> Thanks for the review.
>>
>> I have analyzed all the Sashiko report findings. Some will be fixed in
>> the next version, and for the rest I propose not to fix them, with
>> reasons below. If there are no objections I will send v2 accordingly.
>>
>> Will be fixed in the next version:
>>
>> - mm/page_owner.c: drop the kstrdup() copy in parse_pid_t_list(); the
>>    token will be parsed in place. This also fixes a leak on the success
>>    path and a kfree() of an advanced (interior) pointer on the error
>>    path. cmp_int() will replace plain subtraction in cmp_pid_t(), and
>>    pid values exceeding PID_MAX_LIMIT will be rejected.
>> - mm/page_owner.c: PAGE_OWNER will select GLOB so glob_match() is
>>    always linked in; parse_comm_list() will drop its kstrdup() copy the
>>    same way.
>> - mm/page_owner.c: the cgroup path buffer will be allocated once per
>>    read() outside the page_ext RCU read-side critical section instead of
>>    per page inside get_page_memcg_info() (GFP_KERNEL allocations must
>>    not sleep there). The memcg= parsing branch will be guarded by
>>    CONFIG_MEMCG so kernels built without memcg reject the command
>>    instead of silently enabling a filter that never matches.
>> - tools/mm/page_owner_filter.c: user-visible input errors (empty
>>    -p/-t/-c/-g arguments) will print error messages instead of exiting
>>    silently.
>> - Documentation: the wildcard pattern in the -c example will be quoted
>>    to prevent shell glob expansion.
>>
>> Proposed not to fix, by design:
>>
>> 1. Shared-fd concurrent read/write races (READ_ONCE around the pid
>>     passed to bsearch, torn reads of pid/tgid lists, glob_match() racing
>>     comm rewrites, concurrent write() leading to state->memcg_path
>>     double-allocation): multi-threaded sharing of one page_owner fd is
>>     not a designed use of this interface. The filters are per-fd state
>>     meant to be configured once and then read, which is what the
>>     page_owner_filter tool does. Adding locking to the read path would
>>     put overhead into the per-page scan loop for no designed benefit.
>>     This matches the semantics of the original filter introduction.
>>
>> 2. No "clear filter" support (empty pid=/tgid= lists partially clearing
>>     proc filters, empty memcg=/nid= being rejected): write commands are
>>     incremental -- "keep the unmentioned filters" -- and there is no
>>     clear operation by design. To start over, close the fd and open a
>>     fresh one; the page_owner_filter tool already works this way. This
>>     also matches the semantics of the original filter introduction.
>>
>> 3. kcalloc() vs kmalloc_array() for new_comm_list: no consumer of the
>>     list reads past strscpy()'s NUL terminator, so uninitialized bytes
>>     are unreachable.
>>
>> 4. char cgroup_path[512] in validate_cgroup_path(): acknowledged that
>>     the kernel side accepts paths up to PATH_MAX (4096). The userspace
>>     check truncates an over-long path with snprintf() and then fails
>>     access(), so it is rejected, never silently accepted. Bumping the
>>     buffer to PATH_MAX would only serve pathological paths; realistic
>>     cgroup paths are well under 100 bytes, so 512 wastes nothing in
>>     practice.
>>
>> If this plan looks reasonable I will send v2.
> 
> Sorry but this kind of 'summary', 'do you agree with the plan' email is not
> acceptable.
> 
> You have your feedback, reply to people like a human being directly to them,
> thank you very much.
> 
> At this point, based on past experience, I have to ask if you're using an LLM?
> If so please disclose this as per kernel guidelines:
> 
> https://docs.kernel.org/process/coding-assistants.html
> https://docs.kernel.org/process/generated-content.html
> 
>>
>> Thanks,
>> Zhen Ni
> 
> --
> Cheers, Lorenzo
> 
> 
Hi, Lorenzo

I honestly don't understand what is wrong here. I spent two full days
going through every single finding in the Sashiko report one by one,
checking each against the code. In fact I am already working on v2 and
testing the corresponding changes. What I don't understand is what
"this kind of 'summary' email is not acceptable" is supposed to mean.

If you disagree with any specific item, name it and we can discuss it
-- but rejecting the whole thing outright, with just two documentation
links and no specifics, is not something I can act on.

Thanks,
Zhen

