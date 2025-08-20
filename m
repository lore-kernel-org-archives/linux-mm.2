Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C45DCA0EED
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 23:00:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C42DF8E003D; Wed, 20 Aug 2025 19:00:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF1D08E0031; Wed, 20 Aug 2025 19:00:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE70E8E003D; Wed, 20 Aug 2025 19:00:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9D0518E0031
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 19:00:03 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 52AC31A01AE
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 23:00:03 +0000 (UTC)
X-FDA: 83798655486.21.57547B1
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf29.hostedemail.com (Postfix) with ESMTP id BA6F2120010
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 23:00:01 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=U7l0i6CL;
	spf=pass (imf29.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755730802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LwMfKt/z+b32Yog71y0IpHQR50ir1+SPpvMPlDiQyXM=;
	b=UKSRxjCQ+SGz9gVm2UOt9Kl2+1HBN5YSxv0qqCTw8O+Kq5t4rOX0H7R0jrOZJXcdkom+7L
	uZRW8MB8DAoiZBIIPHHt4fUXS5gUJrFAFRj2pYZv8quKD3KpmECZlX9uX4W8yjOJhIp5va
	WPohQJQL/uNvyuoFyzJZ7OKicHtutqo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=U7l0i6CL;
	spf=pass (imf29.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755730802; a=rsa-sha256;
	cv=none;
	b=ZaJlCD5lsiX6hyZBEgh1+fRe/TTiko3ZH/9xjzS6nCW8uX7WZyOYLa3CYX1TPdRmroOLKn
	zzavWLBIF6oiSaJuCnwZYs587nK0WemGOAyaNrGjFxfjigOAfXECAiCLdI4op5M1YlTy17
	aiJSPuBXLcsWjiHaml2V7MwEjyh4ZLk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755730800;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LwMfKt/z+b32Yog71y0IpHQR50ir1+SPpvMPlDiQyXM=;
	b=U7l0i6CLs6K5elGR2S9r3KYV+KT3KbqTIrQKQ4wXxtsjxNCdZjVBOTgvSdznS3eWHzCcNj
	yoXFsMF3+BeByV5AOH6oeYMWD8+Xc9fai/nBhrUKeCusI2O3ZuyRhw20Hzssg7XDCT743J
	cS0Oxf9asNw/vgky++prC0R8zDSg+4M=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: linux-mm@kvack.org,  bpf@vger.kernel.org,  Suren Baghdasaryan
 <surenb@google.com>,  Johannes Weiner <hannes@cmpxchg.org>,  Michal Hocko
 <mhocko@suse.com>,  David Rientjes <rientjes@google.com>,  Matt Bobrowski
 <mattbobrowski@google.com>,  Song Liu <song@kernel.org>,  Alexei
 Starovoitov <ast@kernel.org>,  Andrew Morton <akpm@linux-foundation.org>,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 06/14] mm: introduce bpf_out_of_memory() bpf kfunc
In-Reply-To: <CAP01T777JF7wvHDaQ-Bz-Vp_dFM=NXvpAK0RY7kLjs2amEd85Q@mail.gmail.com>
	(Kumar Kartikeya Dwivedi's message of "Wed, 20 Aug 2025 11:34:39
	+0200")
References: <20250818170136.209169-1-roman.gushchin@linux.dev>
	<20250818170136.209169-7-roman.gushchin@linux.dev>
	<CAP01T777JF7wvHDaQ-Bz-Vp_dFM=NXvpAK0RY7kLjs2amEd85Q@mail.gmail.com>
Date: Wed, 20 Aug 2025 15:59:53 -0700
Message-ID: <87349loaza.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BA6F2120010
X-Stat-Signature: dzufhhwstr1ejo788ipp6tjspfpgjz4t
X-Rspam-User: 
X-HE-Tag: 1755730801-77748
X-HE-Meta: U2FsdGVkX1+GMZ4RSKam1e8/qFpJjZpuTauTinsI3RsaKsnaxXP2x2d+tSHgOa2atSDtfnWXM+qjTsXqFLr+tAiXJPBuTsHYrIW6poZVf7jg9i7Cr/KRGw+O3E2fSREHJGhoCdid05Rbuq/H+cEh7pmTMHwIUQPTVdZIn26QcpNqubP8szLpArlzGXFiQuTWD4I36CemOkNc0U3+mFit7PEk+7/R6nBvi2nZ6/9kD9RlWwCc5fReRJammPu4Wvjv//j9jgLtmfLFPa8RgkCP5anVUIu0Lc5XLTUwNMVIDmPguquuWu1Ir18cceIvdLuCxYTz6E9LL1kBPGOeihC40uJNKExOwTzM3jC5dGE1HSi6y8ptF2p0DG+Y/A53IhIXwoVfL7I4hcL56FftNWf8VloeOhtaKqr5//Icwb1FM3H5era12+zvTbXCv/4M6Yz/ljYoBTuZhyrQWios5jnxfGe05cXjxLHzvoPos7KgajzP8cVHjRUgjueS+bHGe5UKNFqruV9DgraH2eCAzWgzZSdNEKHb/eVAgYbJNJoKVFRsK4IXk0xgvzNkBBklPLi4YssiCvcR/P9NMIguG6dlsHcOzSD4mTFfyQQQq9bmYag2WoVv0RSI3tRvA13A/ZxFnra6ng0okaPgS6JYeznxBwSUBvfT85AS8/UHLu7Ueds7m6j99h8YlgGmu9xnQXpv+EwERUrKCRqED1V2sN3ZbxXOdXyB4X/TSHpn5dMNSJeTWE1vugjivhis6uDL8b9VGLmLRRu4AM+N6DiCoKNx8lWD9JKhJfMdYcbINfo77013pBF/wCtVxBbMSc7BaBOs2i6JV96m0uSr4MHosmbN4goGg7CtAfK9t32xQQjgOKsj0FwUAOYSkMneW05ukmAgGHyNX4E82uSnYpVzIVi9nHUwfKcyx1SF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kumar Kartikeya Dwivedi <memxor@gmail.com> writes:

> On Mon, 18 Aug 2025 at 19:02, Roman Gushchin <roman.gushchin@linux.dev> wrote:
>>
>> Introduce bpf_out_of_memory() bpf kfunc, which allows to declare
>> an out of memory events and trigger the corresponding kernel OOM
>> handling mechanism.
>>
>> It takes a trusted memcg pointer (or NULL for system-wide OOMs)
>> as an argument, as well as the page order.
>>
>> If the wait_on_oom_lock argument is not set, only one OOM can be
>> declared and handled in the system at once, so if the function is
>> called in parallel to another OOM handling, it bails out with -EBUSY.
>> This mode is suited for global OOM's: any concurrent OOMs will likely
>> do the job and release some memory. In a blocking mode (which is
>> suited for memcg OOMs) the execution will wait on the oom_lock mutex.
>>
>> The function is declared as sleepable. It guarantees that it won't
>> be called from an atomic context. It's required by the OOM handling
>> code, which is not guaranteed to work in a non-blocking context.
>>
>> Handling of a memcg OOM almost always requires taking of the
>> css_set_lock spinlock. The fact that bpf_out_of_memory() is sleepable
>> also guarantees that it can't be called with acquired css_set_lock,
>> so the kernel can't deadlock on it.
>>
>> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
>> ---
>>  mm/oom_kill.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 45 insertions(+)
>>
>> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
>> index 25fc5e744e27..df409f0fac45 100644
>> --- a/mm/oom_kill.c
>> +++ b/mm/oom_kill.c
>> @@ -1324,10 +1324,55 @@ __bpf_kfunc int bpf_oom_kill_process(struct oom_control *oc,
>>         return 0;
>>  }
>>
>> +/**
>> + * bpf_out_of_memory - declare Out Of Memory state and invoke OOM killer
>> + * @memcg__nullable: memcg or NULL for system-wide OOMs
>> + * @order: order of page which wasn't allocated
>> + * @wait_on_oom_lock: if true, block on oom_lock
>> + * @constraint_text__nullable: custom constraint description for the OOM report
>> + *
>> + * Declares the Out Of Memory state and invokes the OOM killer.
>> + *
>> + * OOM handlers are synchronized using the oom_lock mutex. If wait_on_oom_lock
>> + * is true, the function will wait on it. Otherwise it bails out with -EBUSY
>> + * if oom_lock is contended.
>> + *
>> + * Generally it's advised to pass wait_on_oom_lock=true for global OOMs
>> + * and wait_on_oom_lock=false for memcg-scoped OOMs.
>> + *
>> + * Returns 1 if the forward progress was achieved and some memory was freed.
>> + * Returns a negative value if an error has been occurred.
>> + */
>> +__bpf_kfunc int bpf_out_of_memory(struct mem_cgroup *memcg__nullable,
>> +                                 int order, bool wait_on_oom_lock)
>
> I think this bool should be a u64 flags instead, just to make it
> easier to extend behavior in the future.

I like it, will change in the next version.

Thanks for the idea and also for reviewing the series!

