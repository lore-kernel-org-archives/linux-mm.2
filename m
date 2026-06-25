Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5145ECDB47C
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 03:02:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F71E6B008A; Wed, 24 Jun 2026 23:02:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CDB16B0092; Wed, 24 Jun 2026 23:02:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E3E76B0093; Wed, 24 Jun 2026 23:02:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F2D3B6B008A
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 23:02:21 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 843DF1C5CF7
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 03:02:21 +0000 (UTC)
X-FDA: 84916936482.17.D11C0ED
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0193A140010
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 03:02:18 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=f3XfhSe6;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782356539;
	b=H/ejIoTApgxrD1EpUEdYepjDO4mVVT+h1/s7514HOpYirsnGOP8usX+pNeyQXzGM11S6K9
	ITWOj6FOc2L34j9IVzG0rS5iKhwARw71N8XlNyIhFrgvdtBHZgYs7bELwhtknLQG7Yuphy
	S0qkv+wxw/Uj1l5WTPlS1cv/2Yq7sYY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782356539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bg7TU7hDzDNv/08FHHH/On04xmb+0Xhy9JCW39bnqOs=;
	b=J/rlFUzZY/pnwPuq/BCyf3ByVl/dw0Z9JgO5R3JfzgIpI8HxD4xIMdcFlbYVymoKdfxBqY
	DRh/k83cl43570SusV5LPSQvg+61XCNMUM80aUabf4v1kKJLlmrcJWjPm8bLQPyU2qhVUY
	LrVst0+X/hBjUOXyHAUQwfH4fAIYpnk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=f3XfhSe6;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
Message-ID: <0ed6b5c3-e955-46e2-9fc6-075a0dfd1c4f@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782356535;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bg7TU7hDzDNv/08FHHH/On04xmb+0Xhy9JCW39bnqOs=;
	b=f3XfhSe6G7brFNVp6GZqjOXNU3vcFca4poUFfkwgVZymI1EYtq9zeoyJzoopay7HWx5JvC
	E0YJXxuEv9p9ioc24zHIhHD7MfpA8W6eQqa3vo59Vdd3bvTmswHZxeWqPUReOxJ21Oxizv
	nnsvKa6R3D4a+gLxizvgKiVabRJ3kcE=
Date: Thu, 25 Jun 2026 11:01:21 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 1/7] list: Add mutable iterator variants
To: David Laight <david.laight.linux@gmail.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Jani Nikula <jani.nikula@linux.intel.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>,
 Alexei Starovoitov <ast@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Tejun Heo <tj@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Paul Moore <paul@paul-moore.com>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, David Howells <dhowells@redhat.com>,
 Simona Vetter <simona.vetter@ffwll.ch>, Randy Dunlap
 <rdunlap@infradead.org>, Luca Ceresoli <luca.ceresoli@bootlin.com>,
 Philipp Stanner <phasta@kernel.org>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 linux-ntfs-dev@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, audit@vger.kernel.org, bpf@vger.kernel.org,
 netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linux-perf-users@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 kexec@lists.infradead.org, live-patching@vger.kernel.org,
 linux-modules@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-pm@vger.kernel.org, rcu@vger.kernel.org, sched-ext@lists.linux.dev,
 linux-mm@kvack.org, virtualization@lists.linux.dev, damon@lists.linux.dev,
 llvm@lists.linux.dev, Kaitao Cheng <chengkaitao@kylinos.cn>,
 Muchun Song <muchun.song@linux.dev>
References: <20260622040533.29824-1-kaitao.cheng@linux.dev>
 <20260622040533.29824-2-kaitao.cheng@linux.dev>
 <20260622094242.64531b9a@pumpkin>
 <351a6b67-b394-4c58-aee2-88b6c8089ad5@linux.dev>
 <cf8467c7-b98f-44a5-9cf9-60b43b5da711@amd.com>
 <20260624152324.3def88ce@pumpkin>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kaitao Cheng <kaitao.cheng@linux.dev>
In-Reply-To: <20260624152324.3def88ce@pumpkin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0193A140010
X-Stat-Signature: bdmkpwrepkqmx17yijfmdki3e8ibxd86
X-HE-Tag: 1782356538-139259
X-HE-Meta: U2FsdGVkX1/MSIMq3PGJk9C4wX8OyIEx/nyNyMnldueweVzcRoGgxydOwhzryGgnneSBgIr7NvB2KimUQWyHzp7076dvEi0yWb/lguZSUb0gCx0XHoVdFD/iXHJPEZcSBf5L40fNIjkmGtcQ9fTx2SYUjbnDyirFPfSxjYbHupbBTbAEFxtgyBO+5h8/8XAJZNL/hgak2+Bx8LjcZwJz3JcEQKbGDFMtIfDSBDclrNKHouhpfEe6Q4uibCEGOmXj0mHb98sRRWia5n5LsZXxiuVhSvLGS/xIdLfnjpqvwFb7jRh2cYVmmDYg8+3SRzDYWPLRk37heED+/MU5AxZIWAv6zCAWbnvh4os9a5vYkVp4F2anS/do8D7E0kKSf0agTzBxfk5SXKZni9z/x45dJtI2mxyQCMS/yil/O0ahaWKk9q1Am67y68Glgv1MpKvX1DX17cNmmwYg5o8TBmJZb7CQEFW0Tt4yVA5D2DP66ZisnT0yva4mNATzulabQ79ju+6ltd0JcHnE431MAFNn8cF1f6aNVZVmSBAi2JqX99aYfpCt+LsDzUqga4wYBbal7sycqjzDhNEVV3JVJqyGLxPXBYJALta+4yAX/bihlbLngsEmDjTfPGSUAeZzssoNmneJv6vyiTLwcPXISrzPoZMKDNNcTw71l/r/O9fBbiOffStx2vfaYrAO99C2d0/2OS0xZAtaorEf6VeGzb+OAtpLVVAIHzAmN5wPqKmjJqG39akFz/gRU/9Rvq2grCuOZiuNkoUsxKqE6VCi9GC7RHdtyI25B76Qi0r5TvGKSyjmXvA2KYysPl4IaO6GpmjYacxWdRDkMsax7rG9BIMhEEmkipWCpq/CRffSj9uR9YKEpBFrlSOx16oaJfp1P7lqxy0HIpFKJZYo/hxiHPPlzizkzojtK+I+JBvlnX9GjKUig3Z6nZ48E3Qrig9PEFnhZPT5c9453IuFoFupJc4
 Lm4/s3oi
 strXckkHtNQfjFr+8dRaC+27tkp+Ovhe9ye2y9aeLWdg8QOzRnL+HSug0rslhqqqEqWQc1oXtMlEfNaMN8h/S6lxt0o0MyxF8BYa/wFbN0Zj690SUmLkJNb9KQc211r6+4+dkmhtkzxzvDB+ZldyMZOd9+306Byh70JgY/3b0BQQPqRMgfS2VXyAeFveEppETVXF5tRyOFZIJvvZSIzwhiRihlPXI7xs9466eQ4jeLtvfOp0pOINVBKPa+Yjmgm9TpejsSTIvz3AsuODcO6LS82MfeyYrEFb72SomT9YB5YPl3ql+IeOSynoVI3Kxv7wwqXnub6O5WD0SkPtFm2gcAqj4ag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

在 2026/6/24 22:23, David Laight 写道:
> On Wed, 24 Jun 2026 15:23:47 +0200
> Christian König <christian.koenig@amd.com> wrote:
>> On 6/24/26 15:14, Kaitao Cheng wrote:
>>> 在 2026/6/22 16:42, David Laight 写道:  
>>>> On Mon, 22 Jun 2026 12:05:31 +0800
>>>> Kaitao Cheng <kaitao.cheng@linux.dev> wrote:
>>>>  
>>>>> From: Kaitao Cheng <chengkaitao@kylinos.cn>
>>>>>
>>>>> The list_for_each*_safe() helpers are used when the loop body may
>>>>> remove the current entry.  Their API exposes the temporary cursor at
>>>>> every call site, even though most users only need it for the iterator
>>>>> implementation and never reference it in the loop body.
>>>>>
>>>>> Add *_mutable() variants for list and hlist iteration.  The new helpers
>>>>> support both forms: callers may keep passing an explicit temporary cursor
>>>>> when they need to inspect or reset it, or omit it and let the helper use
>>>>> a unique internal cursor.  
>>>>
>>>> I'm not really sure 'mutable' means anything either.
>>>> It is possible to make it valid for the loop body (or even other threads)
>>>> to delete arbitrary list items - but that needs significant extra overheads.
>>>>
>>>> It might be worth doing something that doesn't need the extra variable,
>>>> but there is little point doing all the churn just to rename things.
>>>>  
>>>>>
>>>>> This makes call sites that only mutate the list through the current entry
>>>>> less noisy, while keeping the existing *_safe() helpers available for
>>>>> compatibility.
>>>>>
>>>>> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
>>>>> ---
>>>>>  include/linux/list.h | 269 +++++++++++++++++++++++++++++++++++++------
>>>>>  1 file changed, 231 insertions(+), 38 deletions(-)
>>>>>
>>>>> diff --git a/include/linux/list.h b/include/linux/list.h
>>>>> index 09d979976b3b..1081def7cea9 100644
>>>>> --- a/include/linux/list.h
>>>>> +++ b/include/linux/list.h
>>>>> @@ -7,6 +7,7 @@
>>>>>  #include <linux/stddef.h>
>>>>>  #include <linux/poison.h>
>>>>>  #include <linux/const.h>
>>>>> +#include <linux/args.h>
>>>>>  
>>>>>  #include <asm/barrier.h>
>>>>>  
>>>>> @@ -763,28 +764,72 @@ static inline void list_splice_tail_init(struct list_head *list,
>>>>>  #define list_for_each_prev(pos, head) \
>>>>>  	for (pos = (head)->prev; !list_is_head(pos, (head)); pos = pos->prev)
>>>>>  
>>>>> -/**
>>>>> - * list_for_each_safe - iterate over a list safe against removal of list entry
>>>>> - * @pos:	the &struct list_head to use as a loop cursor.
>>>>> - * @n:		another &struct list_head to use as temporary storage
>>>>> - * @head:	the head for your list.
>>>>> +/*
>>>>> + * list_for_each_safe is an old interface, use list_for_each_mutable instead.
>>>>>   */
>>>>>  #define list_for_each_safe(pos, n, head) \
>>>>>  	for (pos = (head)->next, n = pos->next; \
>>>>>  	     !list_is_head(pos, (head)); \
>>>>>  	     pos = n, n = pos->next)
>>>>>  
>>>>> +#define __list_for_each_mutable_internal(pos, tmp, head)		\
>>>>> +	for (typeof(pos) tmp = (pos = (head)->next)->next;		\  
>>>>
>>>> Use auto
>>>>  
>>>>> +	     !list_is_head(pos, (head));				\
>>>>> +	     pos = tmp, tmp = pos->next)
>>>>> +
>>>>> +#define __list_for_each_mutable1(pos, head)				\
>>>>> +	__list_for_each_mutable_internal(pos, __UNIQUE_ID(next), head)
>>>>> +
>>>>> +#define __list_for_each_mutable2(pos, next, head)			\
>>>>> +	list_for_each_safe(pos, next, head)
>>>>> +
>>>>>  /**
>>>>> - * list_for_each_prev_safe - iterate over a list backwards safe against removal of list entry
>>>>> + * list_for_each_mutable - iterate over a list safe against entry removal
>>>>>   * @pos:	the &struct list_head to use as a loop cursor.
>>>>> - * @n:		another &struct list_head to use as temporary storage
>>>>> - * @head:	the head for your list.
>>>>> + * @...:	either (head) or (next, head)
>>>>> + *
>>>>> + * next:	another &struct list_head to use as optional temporary storage.
>>>>> + *		The temporary cursor is internal unless explicitly supplied by
>>>>> + *		the caller.
>>>>> + * head:	the head for your list.
>>>>> + */
>>>>> +#define list_for_each_mutable(pos, ...)					\
>>>>> +	CONCATENATE(__list_for_each_mutable, COUNT_ARGS(__VA_ARGS__))	\
>>>>> +		(pos, __VA_ARGS__)  
>>>>
>>>> The variable argument count logic really just slows down compilation.
>>>> Maybe there aren't enough copies of this code to make that significant.
>>>> But just because you can do it doesn't mean it is a gooD idea.
>>>> I'm also not sure it really adds anything to the readability.
>>>>
>>>> And, it you are going to make the middle argument optional there is
>>>> no need to change the macro name.  
>>>
>>> Christian König and Jani Nikula also disagree with the variadic-argument
>>> implementation approach. If we abandon that method, it means we will
>>> inevitably need to add some new macros. If mutable is not a good name,
>>> suggestions for better alternatives would be welcome; coming up with a
>>> suitable name is indeed rather tricky.  
>>
>> I don't think you need to add a new macro for the specific use case that people want to modify the next element of the iteration.
>>
>> If I remember your numbers correctly that is a really corner case and keeping using the existing *_safe() macros for that sounds perfectly fine to me.
> 
> IIRC currently you have a choice of either:
> 	define               Item that can't be deleted
> 	list_for_each()	     The current item.
> 	list_for_each_safe() The next item.
> There is also likely to be code that updates the variables to allow
> for other scenarios.
> 
> Note that if increase a reference count and release a lock then list_for_each()
> is likely safer than list_for_each_safe() :-)
> 
> list.h has 9 variants of the 'safe' loop.
> The bloat of another 9 is getting excessive.
> 
> It has to be said that this is one of my least favourite type of list...

Hi Christian König, David Laight, Jani Nikula, David Hildenbrand,
Andy Shevchenko, Alexei Starovoitov

For ease of discussion, I need to summarize the currently possible
approaches and briefly describe their respective pros and cons,
using the list_for_each_entry* interfaces as examples.

1. Add list_for_each_entry_mutable, while keeping list_for_each_entry
and list_for_each_entry_safe unchanged. list_for_each_entry_mutable
would be used specifically for safe deletion scenarios that do not
need to expose the temporary cursor externally. The code can refer to
the v1 version.

Pros: Does not depend on immediate per-subsystem adaptation and can be
      merged directly.
Cons: Requires adding a whole set of mutable interfaces, which makes the
      code somewhat redundant.

2. Directly optimize away the temporary cursor in list_for_each_entry_safe
and define it inside the loop instead, changing the interface from four
arguments to three.

Pros: Does not add redundant interfaces.
Cons: (1) Users need to manually update special cases that use the
      traversal variable of list_for_each_entry_safe, the new
      list_for_each_entry_safe would no longer apply there and would
      need to be open-coded.
      (2) Because the macro arguments changes, all list_for_each_entry_safe
      callers would need to be modified and merged together, making it
      difficult to merge such a large amount of code at once.

3. Use a variadic macro approach to optimize list_for_each_entry_safe,
so that it supports both three and four arguments.

Pros: (1) Does not add redundant interfaces.
      (2) Does not depend on immediate per-subsystem adaptation and can
      be merged directly.
Cons: (1) Increases compile time.
      (2) Makes the interface harder for users to use.

4. Optimize list_for_each_entry by defining the temporary cursor internally,
making it compatible with the functionality of list_for_each_entry_safe.
The code can refer to the v2 version.

Pros: (1) Does not add redundant interfaces.
      (2) The number of externally visible arguments of list_for_each_entry
      remains unchanged, still three.
Cons: (1) list_for_each_entry and list_for_each_entry_safe would be merged
      into one, and list_for_each_entry_safe would gradually be deprecated.
      (2) Users need to manually update special cases that use the traversal
      variable of list_for_each_entry, the new list_for_each_entry would no
      longer apply there and would need to be open-coded. There are 15 such
      cases in total.

5. Use a variadic macro approach to optimize list_for_each_entry, so that
it supports both three and four arguments.

Pros: (1) Does not add redundant interfaces.
      (2) Does not depend on immediate per-subsystem adaptation and can be
      merged directly.
Cons: (1) Increases compile time.
      (2) list_for_each_entry and list_for_each_entry_safe would be merged
      into one, and list_for_each_entry_safe would gradually be deprecated.

6. Make no changes, keep the current logic unchanged, and close the current
email discussion.


Which of the six solutions above do people prefer?

-- 
Thanks
Kaitao Cheng


