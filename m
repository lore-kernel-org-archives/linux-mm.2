Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26DFEE668B4
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 18:43:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 550126B0088; Sat, 20 Dec 2025 13:43:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 507FC6B0089; Sat, 20 Dec 2025 13:43:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 433DD6B008A; Sat, 20 Dec 2025 13:43:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3577B6B0088
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 13:43:24 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C7B8060645
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 18:43:23 +0000 (UTC)
X-FDA: 84240722286.09.4F43881
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4DE56A000F
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 18:43:20 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cvY49sZh;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766256202; a=rsa-sha256;
	cv=none;
	b=gngNn/qnRHzFQQcuHaxgGdKyDKR1Lc+LHctlVBtDY4HeyJ2jKot9FNri89dUo9jP40guvn
	oIr//WkR609seoSHTS59EVjorLqNcP+irIeK7WUPrUSLBtG37lwrsRW+IwBmogd5qmT4uh
	Uxbao8zevCdKLhxawlrpxtdTZu+zA1Y=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cvY49sZh;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766256202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oYcEDFt+reXAq8S6HjO2WYSFnT1e9O506FR9izTfXYg=;
	b=aO0f5WaebmT3niU2EV45pVSLu9v1+tChNzi+31Kio0whsZPNsYAVikMJJsdJR+czmMT+zX
	W2Z1xmk/MB3Y6Z48m5+YnZtyJ7nNqegnvPd8/ojxE4AMcCwGVx7hrvuYJiA26DOtrqjws6
	NWqqFBPEH9AC1jXBxDBSgEctUMG9iMY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766256196;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oYcEDFt+reXAq8S6HjO2WYSFnT1e9O506FR9izTfXYg=;
	b=cvY49sZhS6fWeTI911eazXNzrmFdqSxRKUzbVC0iI+/hbUFYPVRLxBYhV+omoSJ4qYGCGd
	T+J+0lOp1MAZbo63six8tvYdFFeqPoxqKxXKCktKgUNxOmiWZSya9Uh9GF3Tdw2JMpv5Ie
	jjF8ZEi7Y1sfl8nGmdDUXOqELd/STkA=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Chris Mason <clm@meta.com>
Cc: bot+bpf-ci@kernel.org,  bpf@vger.kernel.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org,  inwardvessel@gmail.com,  ast@kernel.org,
  daniel@iogearbox.net,  shakeel.butt@linux.dev,  mhocko@kernel.org,
  hannes@cmpxchg.org,  andrii@kernel.org,  martin.lau@kernel.org,
  eddyz87@gmail.com,  yonghong.song@linux.dev,  ihor.solodrai@linux.dev
Subject: Re: [PATCH bpf-next v2 5/7] mm: introduce BPF kfunc to access
 memory events
In-Reply-To: <dfc73fd6-9e5f-4b62-ac3f-7c9a327dd7fc@meta.com> (Chris Mason's
	message of "Sat, 20 Dec 2025 08:19:48 -0500")
References: <20251220041250.372179-6-roman.gushchin@linux.dev>
	<8f23848b8ac657b4b4a2da04da242039c59e9ad9826a8d5fa0f5aee55acfecc9@mail.kernel.org>
	<87a4zdepdh.fsf@linux.dev>
	<dfc73fd6-9e5f-4b62-ac3f-7c9a327dd7fc@meta.com>
Date: Sat, 20 Dec 2025 10:43:06 -0800
Message-ID: <87zf7d6ll1.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 4DE56A000F
X-Rspamd-Server: rspam03
X-Stat-Signature: 56gxo9r4j41ckpbatk8u5y4ibcfttqir
X-Rspam-User: 
X-HE-Tag: 1766256200-70531
X-HE-Meta: U2FsdGVkX1+cc5YAQmXmBHtE72eIL5w9ysT+dOgKdL7G3CcgHVBPum/d3noVoChCp8CHQUg2tzEmjAvFlt9CGTRWZIHe3yVF8oPE+RJZEAf4O6bSsyqZHNT5Hy3beBAV8O/7Y5QImK+2oFYfXKywXdjejgwdVquuvZM7OFRdcIkukMfTdkA1Q36QUt6qi5nT0Cj3OnwYvFzqL2M/CVXvNMNSlPEd3RwY1TjMDFUlhZOsHgoltwUVtkYEaKGmI0HAjGWp6TnQdXIftVxusaeXLKgeXXEKhiDQZuSLF4DbAL2ogyluZexb17ktfqMVHFHK3xJOPH4yUc/8dL6P6DRp8gjwYIrQH42OBfM2Ccwys3vxZpPIvCQFYXeHS4y42DrAxoCG1CGD5NBLN7VETovMSzj894nRXkTpNSf5GtbxSc+ygqr3jArZkGa5eZJ9IwBrhWP6pr+wS/Jq41ssMJGkj9jXX1/GNjvx0pX6OsMGhlEPmfwzJ9kcYoBpSPcpPvh8s+XRHJavSqkFKveQWnOI9ZXMMgvLj+KfNVriQnP1QzefTx94c5TEtsBrxucFiZb5aRebiKgFRqcGPHFdF9zXGoQ4IDKBHjwYo4RcNKHgJibCBjeHZua04HeuVN6gvCqBLfLxgaYq7rPR2OqXWeOEUxe0PcT2Lc/EzNzXaLiXIMA5p1s3WcL0IHMHj0hmm7TrUjC7G1qHD1GhZ3a+RrAEZFX1z7kC5hkLmbu6AL5Gn5WrJmNwzqRoQydh6AbkhX4ReXP2tdp+SE9EG0pbQ0EKYO/bvWbdDzou6f/BeHjuQ98W04WYMk2ltkjiQhyx06EHQTcDTGnaQE3F/sU2m6v7Q/EvjcZhoTbzuUO90MDbA6ebFBglNgS1n8eL/RWN++n+urcbnnn9FQn5Cgda4KBcY55VDPnKgfw6dmejB/ILu7FX+WpaFwgjLibRDqYQf6yGKUuSRTeK9tC8apHz0f3
 UDD/L3tN
 Yr8PktOtMkl8rc7KeQvZCQtdItMS8z5lBSUvM81P/H30hX+Yfi7jnttBFRBoIHDeu4xZHBni8g2Mtcw7vGBIsrAT+RafD0jcPMxCfxgVuY7nY1pxTO/03qzW9RucXShz1mUfIQYdbWbNewBmfDFUxmybdk/jVRThIhN79cXGazJ26z6A9IGaQDFVgvYhEp14CBGNp9r3lP8Sv45WY1f4yCy4KZ/mEmmLvOYqHeVvD9wbqplGqIJukUL28LYjf/asZQv8BIDvCU0ZpZWIkNHnr1+zBX5sGDlKWIpVNCdJpEG5nLs9G9wcNzqbnyKbBAgz6QiO0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Chris Mason <clm@meta.com> writes:

> On 12/19/25 11:41 PM, Roman Gushchin wrote:
>> bot+bpf-ci@kernel.org writes:
>> 
>>>> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
>>>> index d84fe6f3ed43..858eb43766ce 100644
>>>> --- a/mm/bpf_memcontrol.c
>>>> +++ b/mm/bpf_memcontrol.c
>>>> @@ -103,6 +103,22 @@ __bpf_kfunc unsigned long bpf_mem_cgroup_usage(struct mem_cgroup *memcg)
>>>>  	return mem_cgroup_usage(memcg, false) * PAGE_SIZE;
>>>>  }
>>>>
>>>> +/**
>>>> + * bpf_mem_cgroup_memory_events - Read memory cgroup's memory event value
>>>> + * @memcg: memory cgroup
>>>> + * @event: memory event id
>>>> + *
>>>> + * Returns current memory event count.
>>>> + */
>>>> +__bpf_kfunc unsigned long bpf_mem_cgroup_memory_events(struct mem_cgroup *memcg,
>>>> +						enum memcg_memory_event event)
>>>> +{
>>>> +	if (event >= MEMCG_NR_MEMORY_EVENTS)
>>>> +		return (unsigned long)-1;
>>>
>>> Should this also check for negative values?  The enum type is typically
>>> signed, so a BPF program passing a negative event value would pass this
>>> check but cause an out-of-bounds read from memcg->memory_events[].
>>>
>>> The similar bpf_mem_cgroup_page_state() in this same file uses:
>>>
>>>     if (idx < 0 || idx >= MEMCG_NR_STAT)
>>>
>>> which checks both bounds.  Could the check here be changed to:
>>>
>>>     if (event < 0 || event >= MEMCG_NR_MEMORY_EVENTS)
>>>
>>> to match that pattern?
>> 
>> No, the bpf verifier enforces event > 0.
>> It's a false positive.
>
> I'll add some words here to the bpf prompts, thanks Roman.

I'll try to play with it too, hopefully we can fix it.

Thanks!

