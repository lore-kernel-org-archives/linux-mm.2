Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DEDCCD6E56
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 02:28:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9C866B01F5; Sun, 31 May 2026 22:28:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4DA16B01F6; Sun, 31 May 2026 22:28:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A62EF6B01F7; Sun, 31 May 2026 22:28:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 926946B01F5
	for <linux-mm@kvack.org>; Sun, 31 May 2026 22:28:57 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 586DD1405A6
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 02:28:57 +0000 (UTC)
X-FDA: 84829761114.17.B6E393B
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf05.hostedemail.com (Postfix) with ESMTP id A8A71100003
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 02:28:55 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LIbUAE5U;
	spf=pass (imf05.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780280935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PRrEBBqGyVoXbfBxkuU7wd0QpAuvP6ciBxn6sNWOSaM=;
	b=2gC0cX28zoWNcAPVXzhxWL5lIm3VREVdCna/m6XW5beGhce9yr0OEqSR5bGjpAS5FYxl4+
	eXPY490pXdcVNOewrHQwE4+TfGhcVtBS/1TzQaloG6umk4bmBtfr7Qq6tS/F6/xSb9gWuX
	axygVlWrC/MU/CleUKVta2BOytOov9s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780280935; a=rsa-sha256;
	cv=none;
	b=RLm/UJx5os9wzFWGeXfkBWOxMQdCTgzXLFk1LlW7GnsDi9NPH4gXldBE5O4Ek/OzCK3YRD
	aroRXPZoFE9vLnGbGt4MBMcFrLELmeYeizgN9GngKMH07xU1ShBKtz7OdTMT/oxR0scBKy
	/o1iUkzEOrABdKNjw0DupfVDCJDH7EE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LIbUAE5U;
	spf=pass (imf05.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <e315d2a9-5069-4a8d-a0b5-7c0033ee46ba@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780280933;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PRrEBBqGyVoXbfBxkuU7wd0QpAuvP6ciBxn6sNWOSaM=;
	b=LIbUAE5Uxy37D7JHfVWLYfochvu7uWcsa291RMbDyc/1KinUpU7L4zMHEJuMY1h9P/gGZ1
	haQz9Lk96a8KXx1vYhTVV8Add1WH2mNwk0HyjdJ7DfNZIcaASFLcp2KkGd6yQJ111DmsLa
	7eC3D9YNPkBJDOgkqkq/o/m/ukMNMyU=
Date: Mon, 1 Jun 2026 10:27:53 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] mm/percpu: Preserve NOFS/NOIO scope during chunk
 create and populate
To: Dennis Zhou <dennis@kernel.org>, Pedro Falcato <pfalcato@suse.de>,
 akpm@linux-foundation.org
Cc: tj@kernel.org, cl@gentwo.org, mhocko@suse.com, vbabka@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, muchun.song@linux.dev,
 Kaitao Cheng <chengkaitao@kylinos.cn>
References: <20260528132917.81123-1-kaitao.cheng@linux.dev>
 <20260528132917.81123-2-kaitao.cheng@linux.dev>
 <ahlameE6FBEZj_gt@pedro-suse.lan> <ahld5va1b9w8j659@pedro-suse.lan>
 <5a4aa532-77a0-436a-8f5e-1bbcf2db6bbb@linux.dev>
 <ahrm4x2ubbjs4An1@palisades.local>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kaitao Cheng <kaitao.cheng@linux.dev>
In-Reply-To: <ahrm4x2ubbjs4An1@palisades.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Stat-Signature: fckz3e4wqrxjzq39wy4u9yy6xe395bhs
X-Rspamd-Queue-Id: A8A71100003
X-Rspam-User: 
X-HE-Tag: 1780280935-95953
X-HE-Meta: U2FsdGVkX1+N8Cur0onzZmQALZ+2XnRQ2gO4mtaH+dolH602YNy8nmUVpEZ+vcCHcFE8vvtBUJUNsmdCVR6lR+ZGaQOW6ShGFkUW4fXYnViryqdPtnMR9uwJuf2UUND6TLUcayz+RHyU4er5isc0UwqZXY+NoY9k9fimpM5a/f5qTPm9oXD/mW04PCjJaoWXAhNp8TEAo9Rd74S2EMKA9WpS9YGgjujbU2voxZjJVaTAS/Ygeg5iVNaJ4O9dY5cCo2dYWBQUJNebyF43dOgYZiYyDolG5kJxJHlXOTa6J+fpqPbt9E47VycFnnYgT2HG4GatdJQgUj0MFxc3jmCwhQCOyaS2ATn9fUYfhGmfaqnK3E5ol0hdIGXYtA6Rge+hYIdIJr5Z2CV9E7Ln2jBDNEZTKGLy96YueVHhsTuEAtOyFat4audGYe2Ke+ehwjRiwoIj0MiJdtFiodtl6htAkjMWHb4m+mQ4KGLQ0ykvbC1Nds7+4Lf4KbpmZGs4Q2jMG8Uknv5UsRE0ikmQzTtCpC328mMF58GGMkXZZ0wIMhytN7NIWer4K2CypaLvimFKLprk/8qMhlwerOwbBvw3fcQfcoh1YALKaGMUZfrLZ1+zGk3TCIyUzEINd7r2Y+ayBj3JrwCX3bYC4AxLkB6jTJkIrur3w43y6ubdLBt+/k6BnqS9UI/aJAIVl8TT06LLQPqqm+q5bLYzxh0MCHd4RrHBh6jIudpAIakDCIJmD1tokyivolsiaN2Hu3ARmyK/HY+B6CLpP0UHk4VszxQ4J8ry97IoinjtpelodajPMZEVyHqSqZ6wVgkYYZOBjZqwRYmxBqjtPMbBPzWmL8yQl7dB73YM0XVggP4cu86hHs8m3zFulTnuVf2FhPhj+XPnBApBn7KLZgMqpI0jgfcHsAMEhI7sxMYJPjrRd030qGTDbEPt82t5Dfsw8vVymN5WBCkZ19zg/GzaYwLyG5i
 y1GCus9b
 jL3jzcVyBz2E3jxGXMzR55ahByIZr3pKEUML4KxaQpgfZupSqtsCnY9KomRglgTtxKrHn2sLxzR0OvxEDWLN4AQhaJzNyvSiw30VLitMXFvtz7dw/bnt2ionalJz/CQdk3a4dIsNsm7pwO7fyI84I5N/P6c3rFYeF1iuAwKw/t3UXwRZEXkXtIdDCh2frm9eEB2r+TTF6xEiYc38dL+oaSoDg/gDVE8Hq5vIbuiINbINUeM+HKhHYCJsmjA991+52JVJOxSWu1C7TtH5aR6bLrHVG5ZqM58T3xctobgy8cjKBIZy6/OJhNqE+TwopNZhPXYikyQ08fCzYl9whsn3M6/JEeNKeCB/1GcO3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/5/30 21:32, Dennis Zhou 写道:
> Hello,
> 
> On Sat, May 30, 2026 at 08:47:34PM +0800, Kaitao Cheng wrote:
>> 在 2026/5/29 17:38, Pedro Falcato 写道:
>>> On Fri, May 29, 2026 at 10:25:28AM +0100, Pedro Falcato wrote:
>>>> On Thu, May 28, 2026 at 09:29:16PM +0800, Kaitao Cheng wrote:
>>>>> From: Kaitao Cheng <chengkaitao@kylinos.cn>
>>>>>
>>>>> pcpu_alloc_noprof() derives pcpu_gfp from the caller supplied GFP mask and
>>>>> passes it to the backing percpu allocators. This preserves GFP_NOFS and
>>>>> GFP_NOIO for pcpu_alloc_pages() and for the initial pcpu_chunk allocation.
>>>>>
>>>>> However, the chunk creation and population slow paths also call helpers
>>>>> which do not take a GFP mask and perform internal allocations with
>>>>> GFP_KERNEL. For example, pcpu_create_chunk() calls pcpu_get_vm_areas(),
>>>>> and population can allocate temporary metadata or page tables while mapping
>>>>> backing pages. As a result, a caller which explicitly uses GFP_NOFS or
>>>>> GFP_NOIO can still enter FS or IO reclaim while creating or populating a
>>>>> percpu chunk.
>>>>>
>>>>> This is problematic for callers which use GFP_NOFS or GFP_NOIO because
>>>>> they are already holding filesystem or IO-path locks. If free chunks are
>>>>> exhausted, the percpu allocation can take pcpu_alloc_mutex and then enter
>>>>> unconstrained reclaim from these internal allocations, defeating the
>>>>> caller's allocation context and potentially recreating reclaim lock
>>>>> dependencies.
>>>>>
>>>>> Wrap chunk creation and population in a scoped NOIO or NOFS context when
>>>>> pcpu_gfp has the corresponding constraints. Leave ordinary GFP_KERNEL
>>>>> allocations unchanged so they retain full reclaim capability.
>>>>>
>>>>> Fixes: 9a5b183941b5 ("mm, percpu: do not consider sleepable allocations atomic")
>>>>
>>>> I assume you _did not_ observe this in production? As in no reclaim path should be
>>>> insane^W daring enough to do pcpu allocations?
>>>
>>> Oops, I mixed my issues up. This is purely a GFP flags issue. A quick
>>> "git grep alloc_percpu_gfp" shows that the vast majority (all?) callers are
>>> using some combination of GFP_KERNEL or GFP_ATOMIC + other GFP flags, but no
>>> NOFS or NOIO as far as I can see. So you probably did not observe this?
>>
>> Right, this issue has not been observed in production. It came from a
>> question raised by AI code review, and after carefully reading the code,
>> I found that there are indeed some synchronization concerns.
>>
>> Here is one example of the scenario [PATCH 1/2] is trying to address:
>>
>> blk-cgroup after 5d726c4dbeed ("blk-cgroup: fix possible deadlock while
>> configuring policy"). blkg_conf_prep() now serializes against
>> blkcg_deactivate_policy() with q->blkcg_mutex, and blkg_alloc() was
>> changed to GFP_NOIO for that reason:
>>
>>   CPU0: blkg_conf_prep()
>>     mutex_lock(q->blkcg_mutex)
>>     blkg_alloc(..., GFP_NOIO)
>>       alloc_percpu_gfp(..., GFP_NOIO)
>>         -> if percpu chunks are exhausted, chunk create/populate may do
>>            internal GFP_KERNEL allocations
>>         -> direct reclaim / writeback can issue IO to this queue
>>         -> IO waits because the queue is frozen
>>
>>   CPU1: blkcg_deactivate_policy()
>>     blk_mq_freeze_queue(q)
>>     mutex_lock(q->blkcg_mutex)
>>       -> waits for CPU0
>>     ... unfreeze only happens after q->blkcg_mutex is acquired/released
>>
>> So the concern is that the caller deliberately uses GFP_NOIO because it
>> may hold a lock which can be acquired after queue freeze, but the percpu
>> slow path can temporarily lose that allocation context. The failure
>> requires the slow path (new chunk creation or population), so it is not
>> expected to be common.
> 
> This is likely just a miss for [1] where we switching to
> gfpflags_allow_blocking(),
> 
> This seems like it's just a miss from [1] where we switched to a less
> conservative approach than atomic == !GFP_KERNEL. If anything we just
> need to allow the additional flags through. Maybe just add GFP_NOIO and
> GFP_NOFS in pcpu_gfp via the whitelist.
> 
> [1] 9a5b183941b ("mm, percpu: do not consider sleepable allocations atomic")
>>
>>>>> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
>>>>> ---
>>>>>  mm/percpu.c | 26 ++++++++++++++++++++++++++
>>>>>  1 file changed, 26 insertions(+)
>>>>>
>>>>> diff --git a/mm/percpu.c b/mm/percpu.c
>>>>> index 71a85d7245c7..1bb38467390b 100644
>>>>> --- a/mm/percpu.c
>>>>> +++ b/mm/percpu.c
>>>>> @@ -1778,6 +1778,23 @@ static void pcpu_alloc_tag_free_hook(struct pcpu_chunk *chunk, int off, size_t s
>>>>>  }
>>>>>  #endif
>>>>>  
>>>>> +static unsigned int pcpu_memalloc_scope_save(gfp_t gfp)
>>>>> +{
>>>>> +	if (!(gfp & __GFP_IO))
>>>>> +		return memalloc_noio_save();
>>>>> +	if (!(gfp & __GFP_FS))
>>>>> +		return memalloc_nofs_save();
>>>>> +	return 0;
>>>>> +}
>>>>> +
>>>>> +static void pcpu_memalloc_scope_restore(gfp_t gfp, unsigned int flags)
>>>>> +{
>>>>> +	if (!(gfp & __GFP_IO))
>>>>> +		memalloc_noio_restore(flags);
>>>>> +	else if (!(gfp & __GFP_FS))
>>>>> +		memalloc_nofs_restore(flags);
>>>>> +}
>>>>
>>>> I disagree with this. We already have gfp flags, they're already passed to pcpu_create_chunk()
>>>> and pcpu_populate_chunk(). It's their job to respect the gfp flags and
>>>> Do The Right Thing(tm). Can you fix the problematic places? It seems like it's
>>>> mostly the vmalloc backend that's problematic.
>>
>> I’ll try to do it.
>>
>> Following your suggestion, including in [PATCH 2/2], I will also try a
>> different approach and fix the issue by reducing the scope of the
>> pcpu_alloc_mutex critical section.
>>
> 
> No please don't. The point of the percpu mutex is to ensure that only
> one person is ever possibly creating a new chunk. If you drop the mutex,
> then you have to deal with concurrent callers when available percpu
> memory is low. Percpu memory is expensive and unmovable so the cost is
> in the control plane to avoid excess fragmentation.
> 

You are right. pcpu_alloc_mutex seems necessary, and there does not appear
to be a good way to replace it for now.

The introduction of 9a5b183941b can lead to several synchronization issues.
There are already three known cases: the two described in [PATCH 0/2], plus
the one raised by AI review.

https://lore.kernel.org/all/20260528132917.81123-1-kaitao.cheng@linux.dev/
https://sashiko.dev/#/patchset/20260528132917.81123-1-kaitao.cheng@linux.dev

Since optimizing around pcpu_alloc_mutex is constrained, there does not seem
to be a perfect solution that addresses all of them at the same time.

However, if we revert 9a5b183941b, it seems that all of these issues would
be resolved. The only downside is that the failure rate of pcpu_alloc_noprof()
allocations may increase, which might be acceptable.

I would like to hear what others think.

-- 
Thanks
Kaitao Cheng


