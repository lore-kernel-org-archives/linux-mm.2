Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57A8DCD4F57
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 07:44:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8700E6B008C; Tue, 19 May 2026 03:44:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 847566B0092; Tue, 19 May 2026 03:44:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 784606B0093; Tue, 19 May 2026 03:44:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6450E6B008C
	for <linux-mm@kvack.org>; Tue, 19 May 2026 03:44:39 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 03EEB1201DD
	for <linux-mm@kvack.org>; Tue, 19 May 2026 07:44:38 +0000 (UTC)
X-FDA: 84783382278.12.0F8D52D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3150980003
	for <linux-mm@kvack.org>; Tue, 19 May 2026 07:44:37 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dKmcNDHT;
	spf=pass (imf30.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779176677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M/XjWnASwwwtEYcTU0hw3OIJbbs/jhsvGx8lOTrwyrY=;
	b=5ID1aF9Rodl+V8bX6BzqHFqGAiQZ04M1dfSmBXpMRPzptIZYtcv9fBuHS1PGTBxGjGC2AY
	iotJY5k4Et5RUbbtHTtkYGzcbf2unRNfy9SlNjOoIdr63p5pQwXXQAWJ/5dnP6gx76VKop
	En0RJLd6Nxt1+dKWNgSvBccW3MJot6E=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dKmcNDHT;
	spf=pass (imf30.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779176677; a=rsa-sha256;
	cv=none;
	b=j011OUwphA2+jJZZCao3HLeH2zWmc6nmhZpR8kPdp+vnO1FcXX8Q3/TSactGcp94v0Fv3d
	0Oaxf+q/MjUc0mnuY26dDJqHjm7pSRqH+zi7nIZrb83DPBNx+KweoEdym60r3uH/Sb3XTl
	m4OGAuhKrbQVGvEL7e8ZXSRqftHPPzE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6134F44359;
	Tue, 19 May 2026 07:44:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 477E3C2BCC6;
	Tue, 19 May 2026 07:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779176676;
	bh=acrnpGs+RgPn5vmsEe2IHJpGMxxnf1tBLZq09HiFtDs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=dKmcNDHTXW+8ND9r4Uhrbhi1xuyTfW8NMikF4lGXqoqT9UkjEz/v7aOyrxjDp1GJg
	 NYGUmwKHwt9FUoDZnDL029ZP6LpMcYTB0uRKBQLHBeUiVY1/uK6UJrcRvNfgrtx1qW
	 bq1z0wrxU/jJudY5SKxWSMtH94IFjBD2F5cVxGSYP0OdOZ7nATUUvDCpbF+vVI20yv
	 UmVwwYoIFwF7EZn91cb6ouWjsYOkrEO3UL9WvytVoccIduqoYITjFh6DvY9LPq/yMl
	 84V9kCxo3aEL+b97R8AsKXB3Vyudi2SDLg8JqUDcWLSCyqCwfe2erbu8uht/RndmXn
	 iA81wZJ4hZq5w==
Message-ID: <82d2145a-9b41-4ee4-b980-e7bd5d12f035@kernel.org>
Date: Tue, 19 May 2026 16:44:30 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/8] mm/slab: introduce kfree_rcu_nolock()
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Alexei Starovoitov <ast@kernel.org>, "Paul E . McKenney"
 <paulmck@kernel.org>, Frederic Weisbecker <frederic@kernel.org>,
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
 Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett
 <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>,
 Zqiang <qiang.zhang@linux.dev>, Steven Rostedt <rostedt@goodmis.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Lai Jiangshan <jiangshanlai@gmail.com>, rcu@vger.kernel.org,
 linux-mm@kvack.org, bpf@vger.kernel.org
References: <20260416091022.36823-1-harry@kernel.org>
 <20260416091022.36823-5-harry@kernel.org> <aejeVK0J_jHSfVhD@milan>
 <aemevSofweaUSx0n@hyeyoo> <aeoD_Ts6hLsgNc9-@pc636>
 <3s4jafam3la72a6y3dkfvhtzxk3fsngb2cka3bpfqrirl5m633@pz3vzizefoxb>
 <afNG0jNQNYeZ940g@pc636>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <afNG0jNQNYeZ940g@pc636>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3150980003
X-Stat-Signature: z11wau1qeigzmi1ez1qxj95uq6py8ssk
X-HE-Tag: 1779176677-517871
X-HE-Meta: U2FsdGVkX1+GGy/t4Zyv01/XQOXRe96ekyK/+Zbqdti8WVfKDIlm20wxs3dlaoU4osQ8stu+vRWyMRmL80SGPC0J+KNAd+6u1nuwKsKUW1e/QfEo1mYHIlt1EhTRMYLmLLG6IG5mJYauCM0paKoQ7Kt2b5DIZdfYqY0DY4ArA71hjhVBg0eGL2Ie552BH7BMmKyPIItPdl1mRA5jMHywzcMoI3Wk8hqZZBdeBJt1MmyoOzwRKnmwV7OqcQYDiN6nsdbn7Bl20N2dH8oRDJOhsgxsujUABuK7hC84DUxNZ2BitOkRMB0RdGQKuYa1TUwc5qT/8SlMho9YCrstlTl+IL/p/TbuUpVSLCt09eelL58KK5gzOLhrrKaHP9Jh5wncx+MRYA09HYDRlWH5Soa3eWcWb2hSTf+ATbb7FuxYbk0I6FobqBYXfWw5TEN3TbNz8MH8cg90J2ImJn2mtVwDxHhzfQ9smtFZgCIVkBW2po+/TaYkl3P25byJu52lF0FX3F/k/JD8m3MQIWRilcrBOcjQ+XEq7EdljWXzXxvZog7KG7hTTYar1etkWrdRRuKTI+BufEkRxSq+voxdzyDHSIRqifkTtKaDi2E321Ahga8qtLVAh5jqh8kTV+L0i3ci1FOQeWH5nyBxhFxqP8Yf96Fm1L6upMR/xa+eW6w9H7NFGSPGAnVG7u4XGFGSWVxapk3GdKP2LVdpPwI7kkO3z2g7nxR4oDC68NyQWjFyRwx6zbt1Btsi4oxI36KzvmnfAXaRcjGbTHDBGnEHmWEdVBIJXzzeO+60aYY20IDwhgmygeZghabze2FXowXTnkamHl16MrhAZu7/XL/I5lSs5D0tLG5lTqX6rb7BgolgEPg8m1sB1aBhQHt20pOkHLk1vz6lvtUqkAqAomtju6CJYRt9mQhy0rS+/0uwncygGM7Yp73vO7PfF2sceWHArU4cSrs0xkpkW9rpKAs8sZi
 uAeDU2Wz
 EhNJeE1W0yy/iYQeSATm0fVB0UNZqe0Vpqoz3EjRB+l5ER2Tz/scvtGKQZDHRF3FMv59MjxmTcWZVHiaKp1NKclzMwSCQk1UYWGLJAdtpqPPb+qGYeo61l/cqXHLZQ0/T3eUyGGJtNrU2odpG4Pe+W77keY7Ag+ZfYtxPetpMJo9sdbbVXR8mmBZkJk9/c4tFgz5PpZxDpyNVkvr+v4ZS0X/0gxeKCRwkeoHSvsvbjgNQualrLTpwvkh+zjtcyKK4OGfF12nzzXyPIVU/tuLElAYSAXR08PpDFC39eg84o14DkrvGvbaFMnA6I13xYKd7tu1fSubyAv+V39s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[Resending as it's rejected by mailing lists due to my broken email
  setup. Apologies for the noise.]

*shows up late again after LSFMM and processing some backlog*

On 4/30/26 9:10 PM, Uladzislau Rezki wrote:
> Hello, Harry!
> 
>>
>> Hi Ulad. Apologies for the delayed response.
>> I meant to reply sooner but sidetracked by other issues.
>>
> No problem, sometimes i also can lag because of other tasks :)
> 
>> Your questions are fair, but let me try to clarify
>> the current situation.
>>
>> And before diving into details, I would like to reiterate that
>> there are potentially two points to discuss here:
>>
>> Point 1. Can we justify complicating subsystems by passing
>> 	 `allow_spin` parameter all over the place?
>>
> Yes, we can. But as i noted i see some drawbacks :)
> 
> - all new incoming patches have to respect that new third argument;

That is true :)

> - the fallback mechanism which uses irq-work is not optimal in my
>    opinion:

In most cases it would not fall back because most likely trylock would
succeed. If most of the calls do not fall back, a bit of suboptimality
on the fallback path is acceptable.

>      a) We introduce an extra window between queuing a pointer, mark
>         irq-work to be executed and then reenter the kfree_rcu() with
>         no-sync flag and now we need to wait a GP for them. But the GP
>         might be already passed for such pointers. So we potentially
>         need more time to offload. This is rather minus.
> 
>      b) Since it is for BPF, allow_spin is always false, thus only
>         fallback path is used. Decoupling comes to mind.

No, allow_spin == true means spinning on a lock is safe. If allow_spin
is false, it would do a trylock instead of spinning, and it is expected
to succeed most of the time. As long as trylock succeeds, it uses the
same data structures as the existing kvfree_rcu batching without fallback.

> 
>      c)
> 
> Why should we mix those? What it is worth to do, is to prevent mixing
> "unknown path which is for BPF/others" with generic kfree_rcu().

Because we want to reuse the existing kvfree_rcu batching infrastructure
without reinventing a new feature to do the same thing.

The intent is to avoid the fallback in most cases when allow_spin is
false, with fallback being there for correctness.

>> Point 2. Can we avoid adding this complexity to kvfree_rcu() and
>> 	 let slab handle it instead? (as mentioned in [4])
>>
> it depends if BPF people want to free a pointer using RCU machinery?
> Do you know if that an intention?

They want to free slab objects after RCU grace period. Freeing slab
objects without involving RCU is already supported by kfree_nolock().
(There are other use cases as well, as recently posted in [1])

I meant RCU sheaves can handle freeing slab objects after RCU grace
period, and kfree_rcu_nolock() users don't need to handle vmalloc pages.
So technically we don't have to add this complexity to kvfree_rcu
batching and handle it in slab.

But to do that, we shouldn't disable kfree_rcu_sheaf() completely on RT.
Apparently Vlastimil has a suggestion to address this, and I'm going to
digest his suggestion and explore that aspect.

[1] 
https://lore.kernel.org/linux-mm/esepccfhqg7m6jo76ns2znj2cnuaepx2xvw5zaygtwohq4psma@563ypprp6rr3

[2] 
https://lore.kernel.org/linux-mm/6811cc17-8ee4-48c8-8cbf-6bf4d9f98162@kernel.org

>> On Point 1: IMHO it could be justified, but at the same time I hope we
>> end up avoiding more complexity in the long term by working on Point 2.
>>
>> This reply focuses only on Point 1 and explains why it could be
>> justified.
>>
>> On Thu, Apr 23, 2026 at 01:35:25PM +0200, Uladzislau Rezki wrote:
>>> On Thu, Apr 23, 2026 at 01:23:25PM +0900, Harry Yoo (Oracle) wrote:
>>>> On Wed, Apr 22, 2026 at 04:42:28PM +0200, Uladzislau Rezki wrote:
>>>> How much performance do we sacrifice compared to
>>>> letting them go through the kvfree_rcu() fastpath?
>>>
>>> Freeing an object over RCU from
>>> NMI context is a corner case. It is __not_ generic.
>>
>> First, I want to clarify that kfree_rcu_nolock() is not just for NMI
>> context. It is intended to be used when the context is unknown (because
>> it can be called in an arbitrary code locations).
>>
> When we say "unknown" to me it sounds like a worst case, which is NMI :)

If we say "allow_spin = false assumes the most restrictive context, such
as NMI context", that is misleading. It sounds like we always fall back,
but we don't. Even when the context is unknown, fallback isn't required
most of the time.

So I would like to say "the context is unknown", meaning that
technically kvfree_rcu could be re-entered in the middle of kvfree_rcu
and we need to be able to handle that for correctness (although in most
cases there's no re-entry and no fallback).

>> There are two kinds of problematic situations where BPF programs
>> are attached to:
>>
>>    - 1) a tracepoint or a function that can be invoked in a critical
>>         section (w/ a lock held), or
>>
>>    - 2) a function that can be called in an NMI context, which might
>>         preempt an arbitrary context holding a lock.
>>
>> While 1) and 2) are not (I think) dominant use cases, and although
>> most of users can legally call kvfree_rcu(), BPF can't use kvfree_rcu()
>> and must consider the most restrictive contexts.
>>
>>> We even do not have(now
>>> in mainline) users because we never support it from NMI,
>>> just like call_rcu().
>>
>> Unfortunately, we've had this use case (of allocating memory for BPF
>> programs) for a long time in the mainline. There are two current
>> approaches to mitigate the limitation:
>>
>>    - 1) Pre-allocate all memory. e.g.) allocate all hash table elements
>>         when creating a BPF map, rather than allocating them on demand.
>>         This ensures correctness but sacrifices memory.
>>
>>    - 2) Use the BPF-specific memory allocator [1] [2] to allocate memory
>>         on demand and avoid preallocation. While this wastes less memory
>>         than 1) and also maintains performance, it is re-inventing yet
>>         another memory allocator.
>>
>>         Also, the allocator reinvented kfree_rcu batching as well.
>>
>> Now, we're trying to avoid 1) and 2) as much as possible and use
>> kmalloc_nolock() instead [3].
>>
>>> If BPF needs
>>> it, then the first question which comes to mind is not about performance.
>>> It is how to support this case in kfree_rcu() without adding noticeable
>>> complexity or overhead or hacks to the generic path without making it harder
>>> to maintain.
>>
>> Since there will be only few subsystems that needs it, and because
>> they already use it on production systems, I don't see much value in
>> maintaining a simple implementation if that compromises performance
>> (and thus make the transition harder).
>>
>>> Performance wise you noted, you mean:
>>>
>>> a) call latency(this is probably the most important for NMI)?
>>> b) memory footprint?
>>> c) pointer-chasing overhead?
>>
>> I think it's either
>>
>> - The performance of kfree_rcu_nolock() itself (a), or
>> - Not distrubing workloads running on the machine (b and c)
>>
>> depending on what people use BPF for.
>>
> Are you aware of any specific workloads which we can run? To test
> and see what we have when it comes to performance metrics? I mean
> exact uses cases with exact steps who to trigger them?
> 
> That would be useful to see on behaviour.

I'll share once I find what BPF folks are using for performance
benchmarks. (Which means I'm not aware at the moment :D)

[+Cc bpf@vger.kernel.org]

Thanks!

-- 
Cheers,
Harry / Hyeonggon


