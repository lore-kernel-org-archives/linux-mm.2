Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBB5DCCF9E3
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 10:35:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A8618E012A; Tue,  4 Nov 2025 05:35:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2587E8E0124; Tue,  4 Nov 2025 05:35:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16E818E012A; Tue,  4 Nov 2025 05:35:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EF3B98E0124
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 05:35:55 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8FA155909F
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 10:35:55 +0000 (UTC)
X-FDA: 84072569070.23.5FB5E78
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6B6C91C000F
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 10:35:53 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762252553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W9fWhd6QJsyeKlRbv3z0NdTNxe0g7ZY8sLGfpRKnytQ=;
	b=s3llvbAj9CdHL2LL/XF97Hj6ogDBVWkCzEnG/MfdOoZcCfAp7TcOLt4H4cyo4zoVw0lUNW
	CzK0SVAVzU4kHyTaUMC9Mh+a3Iu7ztqD/R+qeslx97czrN/kK8SrdiFAH2JUQ+tf4vI1Ch
	d+GkCYqlybxV+JSfaGa7rbR10MemuEc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762252553; a=rsa-sha256;
	cv=none;
	b=DLvtqk6bPi0AYZKWWoEmMHcDbZc7Siu18Vx7CCuiR7oAnRmxpXwQlDiOyKfXHu9KZFzfaV
	lC8Pb0a0qwlP7djqxbcR027mOTRARRZz/BCwR7wSSX/BTBROHkRGWToWXZgHd/8VGQFnNk
	40+KrBecJYBhIVN6G1N9kzBHvI5hlzs=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 663671764;
	Tue,  4 Nov 2025 02:35:44 -0800 (PST)
Received: from [10.164.18.64] (unknown [10.164.18.64])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 56E1C3F694;
	Tue,  4 Nov 2025 02:35:49 -0800 (PST)
Message-ID: <9dcd181a-7058-4fee-83a5-695df77c9edb@arm.com>
Date: Tue, 4 Nov 2025 16:05:46 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] slab: prevent infinite loop in kmalloc_nolock() with
 debugging
To: Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>,
 Alexei Starovoitov <ast@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20251103-fix-nolock-loop-v1-1-6e2b3e82b9da@suse.cz>
 <5bb311a5-b59f-4897-b4d0-4e06d7d2b3f2@arm.com>
 <f59e2a0e-1da3-4670-84ee-679c2001f58f@suse.cz>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <f59e2a0e-1da3-4670-84ee-679c2001f58f@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6B6C91C000F
X-Stat-Signature: 7iu5j7d18tsds1uqb9bm4rc3dmxwswzr
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762252553-408343
X-HE-Meta: U2FsdGVkX1/QdU7t7BvO2ufOHiaq24esvclAbZtIi5dSs3sCi6mVK7bRSXatxlZCvIZBIl+dbqgXHuabzDBJoKiGfqp6vu7AnXI/pPhD5vjJoFo9WBZYAR4weSls+zKsyUJuf3cGcQZ2WwNYCgkPkHizbpkH9TH/C8lxRchh0h5PKRfD2lyMtM72bzFWs7gNB7hVeN/vqvbpzfKcJjoHLT6xkaJFEZf66JhawGgYWDdD6hbM9P7abyhcXW+2J88JL8/Vh6mNcKkHlqpsyNYIHpMaEpvp0pebpK+XAu3GeFKbrD/RC8fe6Rq3SB5mSp6ofodxUBKeM6B1IiI+DsHB8mvKoIqj+guSY0wxQ8MqpZ1sSCCMuzmQ1tv0jBEQnpNaWDz0I89HzB3PO3ytigGgxC5oHyx64lf/dxErFzet76xA9IwEVlOAxmtgD+zKz5H5CAdlgfa5R7znwswEXK0NgaZGMGmLXvFKb4XEJqbZASt+cfXAX6kOXUX0yftWxSg+p9fXBmGutxJY6bIVpsp6M6MNxQDnQy5wHeuQVyn51XrYAl29PoS6X3Y1TtgCjn2u3Nvrf+MirOv9YLihO5GlXjIxs24psBFd/+L2nYwx6df7am2/wQaW2GGCJ0aCVNYYkoZa/r3FnuvMhm8QiQJOO93UzHNVZgzTQSlaTPJk1G/2ESAW92x09cfRNNhDqjpEMXdVJ+F1Q/41aw9MkyecRjXm0OnVTwMDUK+WHqV5IQKnT5kuRxSY6yNNmMI9VMd07bFM1cg8DtfE5fsm4UF8DdS24tVD21u2PvB8oNwS7REd97u784/PBa4M4QFpvXFr9U7SAlAScM7H9YeAMOeycwhDPS23SXqAYu4brUrEld4PBqbgmeJjBQMzbVSGKdrXDfa04QdZcmHnGCltxcvLVAwe4ChmUNdwMFuKoHZ+E7KDy3qQ6EelVj5Dpa4IELdbmby9CSeOYVpPE50g4tS
 Apm/t29V
 y6kNqfnCtuM64MlBMONyakjFTUaOjMbVfP6wumGnPec1HueK49K7NfuEwjVlTrMlRsE0HxAhLhWyJcIkT2ClVzdGdzmtoR1miy6Wj1p4zErWj3pYTanNLpC8SBrHVOT/8Fk7vQCXgN8IWduM+MqoD+fvg5bCucPTmhefoi0jsoeTgFuhfq1aeCGb3eaSukFe8VmR2NiMhiziSn6hq6ImClvBif7rnM9uokIPUxiL+MfQ4xQdNKfZFk1PI/47mVafi3nCl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 04/11/25 3:54 pm, Vlastimil Babka wrote:
> On 11/4/25 6:26 AM, Dev Jain wrote:
>> On 03/11/25 5:54 pm, Vlastimil Babka wrote:
>>> In review of a followup work, Harry noticed a potential infinite loop.
>>> Upon closed inspection, it already exists for kmalloc_nolock() on a
>>> cache with debugging enabled, since commit af92793e52c3 ("slab:
>>> Introduce kmalloc_nolock() and kfree_nolock().")
>>>
>>> When alloc_single_from_new_slab() fails to trylock node list_lock, we
>>> keep retrying to get partial slab or allocate a new slab. If we indeed
>>> interrupted somebody holding the list_lock, the trylock fill fail
>> Hi Vlastimil,
>>
>> I see that we always take n->list_lock spinlock by disabling irqs. So
>> how can we interrupt someone holding the list_lock?
>  From a NMI or e.g. a kprobe->bpf hook, which are the use cases for
> kmalloc_nolock(). The word "interrupt" thus doesn't mean IRQ, but I'm
> not sure which word would be better. "Preempt" would be perhaps even
> more potentially misleading.
>
>> If we are already in a path holding list_lock, and trigger a slab
>> allocation
>> and recursively end up in the same path again, we can get the situation
>> you mention, is that possible?
> There shouldn't be such recursion in the code itself, in the absence of
> NMI/kprobe/etc.

Thanks for explaining.

>>> deterministically and we end up allocating and defer-freeing slabs
>>> indefinitely with no progress.
>>>
>>> To fix it, fail the allocation if spinning is not allowed. This is
>>> acceptable in the restricted context of kmalloc_nolock(), especially
>>> with debugging enabled.
>>>
>>> Reported-by: Harry Yoo <harry.yoo@oracle.com>
>>> Closes: https://lore.kernel.org/all/aQLqZjjq1SPD3Fml@hyeyoo/
>>> Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and
>>> kfree_nolock().")
>>> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
>>> ---
>>> as we discussed in the linked thread, 6.18 hotfix to be included in
>>> slab/for-next-fixes
>>> ---
>>>    mm/slub.c | 6 +++++-
>>>    1 file changed, 5 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/mm/slub.c b/mm/slub.c
>>> index d4367f25b20d..f1a5373eee7b 100644
>>> --- a/mm/slub.c
>>> +++ b/mm/slub.c
>>> @@ -4666,8 +4666,12 @@ static void *___slab_alloc(struct kmem_cache
>>> *s, gfp_t gfpflags, int node,
>>>        if (kmem_cache_debug(s)) {
>>>            freelist = alloc_single_from_new_slab(s, slab, orig_size,
>>> gfpflags);
>>>    -        if (unlikely(!freelist))
>>> +        if (unlikely(!freelist)) {
>>> +            /* This could cause an endless loop. Fail instead. */
>>> +            if (!allow_spin)
>>> +                return NULL;
>>>                goto new_objects;
>>> +        }
>>>              if (s->flags & SLAB_STORE_USER)
>>>                set_track(s, freelist, TRACK_ALLOC, addr,
>>>
>>> ---
>>> base-commit: 6146a0f1dfae5d37442a9ddcba012add260bceb0
>>> change-id: 20251103-fix-nolock-loop-854e0101672f
>>>
>>> Best regards,

