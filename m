Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5B13C5DF71
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 09:03:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D33496B03D4; Tue,  2 Jun 2026 05:03:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0AFC6B03D5; Tue,  2 Jun 2026 05:03:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF9F36B03D6; Tue,  2 Jun 2026 05:03:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AF9DA6B03D4
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 05:03:42 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 74D5E1625AA
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 09:03:42 +0000 (UTC)
X-FDA: 84834384684.03.90826DB
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4620080018
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 09:03:40 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Xdvy9e0W;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of kaitao.cheng@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780391020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NXyzRZVLtth6eJqeam2mOJJ1lBVnO87YQ9jJaMF5Gt8=;
	b=xfO6BL7vg2cuAmCsKvZAuyQc4UQEwjeS049YlWH6NkdC980PANUl3SrlsdPLT6MOIo1T3N
	2o/bk1yyOGClWo5fMxK+sGR3riZr0pajGLEwjVYDtAEhOQlxLZR/ZsqTfcJebUvEMuf+ME
	PFai6LxbvbZRaXbRoaVbnIEjmCg51r0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Xdvy9e0W;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of kaitao.cheng@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780391020;
	b=JbeHdUSb8WTPljxQdLJqthQhYu5PnUhH/hcmoyvsLhFRV2RWzGPImRLlrfigccnam94BpV
	SX2fpnPewpjvEPRhpYHNNE2gO6EZXRKn+kZQnlj/y+1aLNUKQZcpIQ+XnTh/NP8F7k/+rJ
	tkg3VAoUZxpWW87wFrUq1vBU7BgoI4M=
Message-ID: <32e86da0-b38f-4714-b84f-91cc41e5c20d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780391018;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NXyzRZVLtth6eJqeam2mOJJ1lBVnO87YQ9jJaMF5Gt8=;
	b=Xdvy9e0WbldQmpEggRQT4eZw0u5/KfL1gvwDHQu2zxGk/JLgABk1cLkNZgjy3iGrWkRUw4
	T88Q/zHBA3xFJka1nntTDeEvYZwtkdkYLQdflZivo7zaKE2wylnx4HU32HKy1YP/Y57736
	Np5XI+lXYwS1mhPOjlwUiJFana/HDzs=
Date: Tue, 2 Jun 2026 17:02:41 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] mm/percpu: Preserve NOFS/NOIO scope during chunk
 create and populate
To: Michal Hocko <mhocko@suse.com>, "Vlastimil Babka (SUSE)"
 <vbabka@kernel.org>
Cc: Dennis Zhou <dennis@kernel.org>, Pedro Falcato <pfalcato@suse.de>,
 akpm@linux-foundation.org, tj@kernel.org, cl@gentwo.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, muchun.song@linux.dev,
 Kaitao Cheng <chengkaitao@kylinos.cn>
References: <20260528132917.81123-1-kaitao.cheng@linux.dev>
 <20260528132917.81123-2-kaitao.cheng@linux.dev>
 <ahlameE6FBEZj_gt@pedro-suse.lan> <ahld5va1b9w8j659@pedro-suse.lan>
 <5a4aa532-77a0-436a-8f5e-1bbcf2db6bbb@linux.dev>
 <ahrm4x2ubbjs4An1@palisades.local>
 <e315d2a9-5069-4a8d-a0b5-7c0033ee46ba@linux.dev> <ah2pD468y1LCIe3G@tiehlicka>
 <7e913ba8-fa91-4916-a871-66de7c80cd29@linux.dev>
 <536ea40b-8501-4a81-84c7-de5f12f4eaf3@kernel.org>
 <ah6OsuRRVLRBp3NV@tiehlicka>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kaitao Cheng <kaitao.cheng@linux.dev>
In-Reply-To: <ah6OsuRRVLRBp3NV@tiehlicka>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: h3yjgr8kg11k1y3uxbfwpr33j3rn9pmw
X-Rspamd-Queue-Id: 4620080018
X-HE-Tag: 1780391020-212444
X-HE-Meta: U2FsdGVkX1+I0i1nsnpZN/0IfryDm6xQxaYplOk6Z6pULbOtyk5bXYXZN4krxsaeGxFTGsA/Cbq+fPMWcckYp7tb6VL4dviT5t72D/9Byax0v/deaMerT1nSR33SM1SytRcsVQcGQ0CC3yJQjtw26pB0+U1vPWxV2mUbvjxYv7GeiZg1evXlbTcqTfBtppimCLlQ5oy8bSS2m5Ka5IyTwUfqosbnTJd1JJ8UC0GIqLBy24Rq0qdfBYRILy3eUl0zRqM9+vLvg9hIKk+0URFGOnXZmUEhgcTut2a8h0zSXiWgDrHVex4XS8SGT9Fw6cYEyFb1tNb00wWhDpxESBnyHdoju00ZA/MgOvTe+XWGmtbTu7FnF/YYp/crJrhFHAQzb7qAB83inlbsjRg08I7U0schEXdJqNIu0jtou+ypZWQfnViRdWpdBu+ZtLEKEDcZlHGIUz/ABG7CgwF2c8sAVJmaE+/ZP5JT/TeahakS5+YwhoWoJldkI14bcJU8Rto0+BvJ2hPfI/QgSyuWVDp2IhzshSSFZ2Ao4aPnl2PawkWL/SAz5aXM+DurIBkk1yPqzuWofs4+jaSzKdiuEcOoRnYp+47QMz8MJ9Eauv33ABf5zQGbptFe9rO4HPQxv+ajRuB7IJL90PKNBxH8UF52fkY3dm0pvbPOIfNIxW1EfTuuHPKRwinxVQG8Ibe5LskCTlv3Mft7K36znZrBGwgT4kL62ikv1TJc5KdzHOrZQ3LXOliIKd4Hr6bWu536OMjp0jRYXuOqJ7vmPgkSBSJuBzL+JrJ7QkfsGBbZnUyg327tz89d1U7P0OQuQWwABPjjLmPMtoIvjO7vk79CQ+9i7eXuXfPBY+T1TA1zIRy1Pn0n3m+211+ZRrFKRp/5wy8tVBkpfweXXEDtXeugIREEjO9cEFABohhMyw1EbF7sz9PrQVXA0fyRLygZjZWPaDmsOJOH5MJtN859e6U0Dca
 jdAwxG/O
 TCDRneI2bIZpPuGFL4+KvPbGg0lmTl/JkFwfpvsR6Q2x+SotHZXwPAx5FpfhMbTNyGV9UPZMBQpecasZJ7m5SRpqyMEdctas6q2YDHhcbVcx9udbSoQH2KrH60DPwp2NihOaq0b4ESnLiAIctAfCDhBwV+phF+WNXoGoBqDhZKjyzB5Yih0N40JZVNj5sBaxG1fI8WNfOGDKNWvwv6pD4fQkPi6OUMaoATuDVShJ47ZxSh+xe8TfDYzaTRutdBVvfnhFlbz196/Fh0Uc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

在 2026/6/2 16:05, Michal Hocko 写道:
> On Tue 02-06-26 09:16:24, Vlastimil Babka (SUSE) wrote:
>> On 6/2/26 05:03, Kaitao Cheng wrote:
>>>
>>>
>>> 在 2026/6/1 23:45, Michal Hocko 写道:
>>>> On Mon 01-06-26 10:27:53, Kaitao Cheng wrote:
>>>>> However, if we revert 9a5b183941b, it seems that all of these issues would
>>>>> be resolved. The only downside is that the failure rate of pcpu_alloc_noprof()
>>>>> allocations may increase, which might be acceptable.
>>>>
>>>> That has practical impact on some versions of iscsid which do not have
>>>> PR_SET_IO_FLUSHER. And maybe some more so I would rather not revert
>>>> based on a theoretical concerns which I believe is the case here. 
>>>>
>>>
>>> Based on the previous discussion, I think we have a way to address most
>>> of the concurrency issues around percpu allocation.
>>>
>>> However, there still seems to be one remaining case that I do not yet
>>> have a good way to solve. For example:
>>>
>>> Thread A calls pcpu_alloc_noprof() with GFP_KERNEL and takes
>>> pcpu_alloc_mutex. Since the internal allocation is not constrained by
>>> NOFS, it may enter FS reclaim while still holding pcpu_alloc_mutex,
>>> creating a dependency like:
>>>
>>> pcpu_alloc_mutex -> fs_reclaim -> FS lock
>>> At the same time, Thread B may already hold an FS lock and then call
>>> pcpu_alloc_noprof() with GFP_NOFS. It will try to acquire
>>> pcpu_alloc_mutex and block, creating the reverse dependency:
>>>
>>> FS lock -> pcpu_alloc_mutex
>>> This can still form a potential deadlock cycle.
>>>
>>> Does anyone have a good suggestion for how to handle this remaining case?
>>> Or should we simply treat all GFP_KERNEL/GFP_NOFS allocation behavior in
>>> pcpu_alloc_noprof() as GFP_NOIO?
>>>
>>> If there is no clear solution for now, would it be acceptable to first
>>> fix some of the issues introduced by commit 9a5b183941b, and leave this
>>> remaining case as a pre-existing historical issue to be handled separately
>>> later?
>>
>> We don't need to solve any issues that are only theoretical and based on
>> scenarios that nobody sane should be doing, i.e. Pedro already pointed out
>> "As in no reclaim path should be insane^W daring enough to do pcpu allocations?"
> 
> Yes, but you do not need to do a pcp allocation from the reclaim path to
> hit the deadlock. All you need is a NOFS pcp allocation - e.g. one done
> from NOFS scope. Then you have fs lock <-> pcpu_alloc_mutex dependency
> and a potential deadlock. It is hard to know whether we have any of
> those in the kernel but I know for a fact (9a5b183941b) that there are
> scoped NOIO allocations so I wouldn't be suprised if the same was the
> case for NOFS. Not only that having NOIO is a weaker reclaim context.

Besides the case mentioned by Michal Hocko, in my previous email I listed
a scenario where blkg_conf_prep races with blkcg_deactivate_policy. This
is also something that can actually happen in the existing code, and we
have discussed some possible solutions.

The concurrent situation Pedro pointed out, "As in no reclaim path should
be insane^W daring enough to do pcpu allocations?", does exist at the
theoretical level. However, some other issues do genuinely exist. The
reason they have not been observed so far may be that the reproduction
probability is very low, or that they have already happened but no one
has reported them to the community.

>> Elsewhere Pedro said "The proper way of fixing this would probably be to
>> release pcpu_alloc_mutex (or not have it in the first place!) while you're
>> allocating memory."
> 
> I do agree with this. Back then when I was dealing with the NOIO issue
> I've tried to look at the lock and drop it but it was not really
> straightforward. Maybe my lack of close understanding of the pcp
> allocator was an obstacle there. So if there is a path forward like that
> then it would certainly be the best.

That is indeed the optimal solution, but after thinking about it briefly,
this optimization may not be easy to implement, or it may require a large
amount of changes. I would really appreciate hearing any concrete suggestions
people may have on how to optimize pcpu_alloc_mutex. Otherwise, this issue
will remain blocked here.

-- 
Thanks
Kaitao Cheng


