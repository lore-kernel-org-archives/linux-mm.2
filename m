Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 343E5C9830D
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 07:29:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27B5B6B0095; Fri, 25 Sep 2026 03:29:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 252DC6B0096; Fri, 25 Sep 2026 03:29:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1685A6B0098; Fri, 25 Sep 2026 03:29:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E1A306B0095
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 03:29:25 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7031714059E
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 07:29:25 +0000 (UTC)
X-FDA: 85251459090.06.2BC150F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 9415E20004
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 07:29:23 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="TPsZEIc/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790321363;
	b=LjjspLtIs8MxtGyWq4kqcDAx+3J3c3eAL201UI1fcuvOfzw5l5cSCbKifbdy7EXsCD/ynu
	96DZ1d4ayIvOpsDXvcZG3V0jZ+iI6dS/Sn+7lK6SrVTiR2mGVAnCQAsMRZBy/mebtx/fhx
	+4bO5x1SgKVZi3Nnd+VtyZ0lQ4scHXU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="TPsZEIc/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790321363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mfnb3GXAJ6qEATTIM7j+kMnju+C9c/oq/1MBEZFo2sk=;
	b=xo33UH/7gz+pL5FAIvUTNLrwB+Pay6mZlb6by2FPUwOgudw4CYU2mrTkW/NXSqYN04hRIU
	z2aKd4mWEnR26uiM7bFP2xhfnFBni8L4MvYXSpCZSiUh9LLyru9pl2T0qJwKqAbQANhDkt
	c7zWyS2Fnibmt6puT4wLvT3Ezyu0RWM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 784956022F;
	Fri, 25 Sep 2026 07:29:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30DE71F000FF;
	Fri, 25 Sep 2026 07:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790321362;
	bh=Mfnb3GXAJ6qEATTIM7j+kMnju+C9c/oq/1MBEZFo2sk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=TPsZEIc/WsipxGDE8RhpcTcM1O2qXwgqnk+1A1yxgE0s67tJ2P0+FzqsPD5j/ra8N
	 3IC54JRZw5rnypO/kwU2ObM8PWWqJ7ENRm1hUrNo5hKBX5/nf++KIQPKKmhfUB9vcy
	 VWZy5xWZ8BMPsmBycV8uzg2vT+k4tTAzRjnUmas9eIsRaxdC9ajviKZ3X7nnghOGE1
	 zYJ9D3pUxZPwORZDZOoxo9kJzt6hmhcpxd8fKJCRRsdtjKmeX70z2pdMoXJHcqDEWN
	 QLp7HIA1+Z0ZIQ90pHRtsdxQN37aVNzYYd43+8HqfkVpxsMRrCxKhXysQoJV99TxVI
	 8sjVtYyX7LgXg==
Message-ID: <c2f8eb01-7a10-4ccb-92f1-eece29c06cd4@kernel.org>
Date: Fri, 25 Sep 2026 09:29:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm: restrict can_spin_trylock() to preemptible
 context on PREEMPT_RT
Content-Language: en-US
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
 Karl Mehltretter <kmehltretter@gmail.com>
Cc: Harry Yoo <harry@kernel.org>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Amery Hung <ameryhung@gmail.com>,
 Swaraj Gaikwad <swarajgaikwad1925@gmail.com>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 linux-mm@kvack.org, bpf@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20260919171443.90512-1-kmehltretter@gmail.com>
 <DLJHZEZMLW0F.27OPPS218CX9Q@gmail.com> <arIY0wMQjCCsqidI@gmail.com>
 <DLO3RV3IQUOV.21BNLF4QS9T4W@gmail.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <DLO3RV3IQUOV.21BNLF4QS9T4W@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: ab7wjc5m4unzdnr9h61bjw5ueis5tyqz
X-Rspam-User: 
X-Rspamd-Queue-Id: 9415E20004
X-HE-Tag: 1790321363-414114
X-HE-Meta: U2FsdGVkX1/Tb2I6sDiblaVDxwwQnj0Kk8tri7wwU4IZlYZi/oHAzRNwI6/I0uA+K2D9FOlI4u63d1oiDq9L+u5rzAMgiRtS+2h7rmqmqyiMtyrAkWga8YJVKEN7/DfiiwmW9L7rqBxDZTVsa10LUop7EbkTZctG5eCuePeuY308gzpVtUrwu++3Il+CkG9BdMHJUcO/OE7fTVZLNIAOxg/cxk2sSn9UR1C+ntGEycqnJIVfkKLSDHwpCNhXF58oESGw+5+8dtkY+3jXRIxv3vGevBkhkkooAK/EK3bacLZKlBrrtlwy+NDGGFUWDtD64g+Ar23ZXZNjeVOWqv27vzreDPLr8Zcn6NxhMQFh5dgcTZWxTEssXTvcs+CJMFm2R9kHYUvyZ8gPS778cVRYfELQIqakdj4/MctQqElCXFI2tyNIQYdk1pdp6+sggXJaj1MWTLXw6GOBW+HX45xWYweLSco3EUvZQn52ikrI8CiLQwM6KQ0cZMLPcV85aDP/FWdAkl3aXXR/7kM1PCAbe56jOThydPYIWXohF1g0625VoSCyFHJJ8IHDgSEofqJLNQP3TfNmrMfjaGgjjQDr8dGpZ53fcd3UwWZBtTKlZhOcUZAwfbKzC6cqAHc1TcOA9BR7dqAUbq2iLXr8sfmYG33dzF7L9bvGPAUaWduTPDc9nxnXPb5syXCIkFDfdRb+OOdWnLpFo2RfF48hPAiADPGFnymruSMESvRtaaV5drzdPxMVyJU2UNlZJFFjmiKIO+ektu26vDzOvVsL+88CyGhz21crVspC7HKIiV6URoNJ3/FdhNCrkuPS4Gmsayt1jQ2rKMH2R4W4/Gsz7bEAj9B786X2gN1Irh4kMEw/x7VQnEOwZQDfOxrSA4AN07KtkHqxeLbwLWD6MyDYDcr8Yy6CuQKLJkN0amiw/dNASE+dH76/cfbUNI0l3CYTfSHvhZF9Z7SLVTe7kTFkz8C
 +seIiQfN
 zi4i9E7DY1h+GVej2EU4J8v54VSytkBWDXV0JSDm4TVNR0/0fGPewWoIRhFKofiFdkyS+1U9x6jmjcpTYdUu3ZwjjETEU8t6liuo5oKa8Bovk9lBVJuvgk3pM+2n/5iplUZWO5cdk+lQ5s7gca7fX0XK3nFjdefbZZtwJvzZ2Yuw6RYsIGXRyTk4aeL/rbh/NrnAs41liIYBFiisXIqPlDE8Ohl0lMm+fOgU/D9egZAy3e7PkQ7/4/WRZlk4BQuIq08vUgm9PEldpaYPHhRtzNLVKcvMxHTNdTF1BpD44ACV1EOuLM5fN/kajUEJI6aW2/wQHRpxFjqCMA7Gqp75J0uye6syCi4x+PHVxrho5kUDUlcju5uCn2xibsDnuaafB3xnh/DxhbjqH+SMYCVut3yauUw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/25/26 06:12, Alexei Starovoitov wrote:
> On Tue, Sep 22, 2026 at 08:04 AM Karl Mehltretter <kmehltretter@gmail.com> wrote:
>> a) Change MM so _nolock() allocation remains safe and can still succeed
>>    while pi_lock or an rq lock is held. Existing BPF behavior would
>>    remain unchanged. Is this feasible, or would it require substantial
>>    allocator changes?
> 
> I don't think it's feasible. On RT the sheaves lock, n->list_lock and
> zone->lock are all rtmutex based. When trylock succeeded and a waiter
> showed up rt_spin_unlock() has to wake it.
> 
>> b) Restore BPF local storage's dedicated allocator, and document, with
>>    debug checks if possible, that _nolock() must not be used in those
>>    scheduler-lock contexts.
> 
> No. Local storage is not the only one. bpf_arena_alloc_pages(),
> bpf_stream_vprintk(), bpf_task_work_schedule_*() call kmalloc_nolock()
> as well and the same sched_waking prog can call them.
> bpf_mem_alloc was removed from local storage, because it wastes memory
> on preallocation. Same answer for d).
> 
>> c) Have MM detect those contexts and return NULL. This prevents the
>>    deadlock while preserving ordinary raw-lock callers such as arena,
>>    but task-storage creation from scheduler tracepoints then fails
>>    deterministically.
> 
> This one.

Yeah, but how exactly to do that detection :)

> bpf_task_storage_get() with F_CREATE can return NULL and the progs
> have to check for it anyway.

e) Introduce raw_local_trylock_t...

>> Are these the right alternatives? In particular, what behavior is
>> intended from the _nolock() API in these scheduler-lock contexts?
> 
> It can be called from any context and it can return NULL.
> That's what it does from NMI and hardirq on RT already.


