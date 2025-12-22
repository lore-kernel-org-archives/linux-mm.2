Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 691A6E6ADF9
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 22:24:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF62D6B009D; Mon, 22 Dec 2025 17:24:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA4266B009F; Mon, 22 Dec 2025 17:24:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD0896B00A0; Mon, 22 Dec 2025 17:24:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AF3446B009D
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 17:24:14 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6458CB8B51
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 22:24:14 +0000 (UTC)
X-FDA: 84248536428.29.E826AAF
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf16.hostedemail.com (Postfix) with ESMTP id 81F49180008
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 22:24:12 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SP2Il+Mb;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766442252; a=rsa-sha256;
	cv=none;
	b=KPu/hI1xxL15F+hNbvmsguZI6tvLVITCDnt9Hbzjbr7kaIAsskJRH/sO1CJSqS6pU53a+6
	WimjEwEUcpQyMvR1TyG+Vtd4029rg72mwocbXQwhWSrnPT5FyYO3cTQPG5gSaphrHc9K1i
	Lmr7H018RBORxP/IXpDyqE0DrbKzius=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SP2Il+Mb;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766442252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sJ5Rz7oks9BsiGW+7NF3TEgOyoDBKE6fPRGPHx1O1TY=;
	b=CTYkaDKGK8N4gU7AQt0TFnafdCACMIY1FwmQMIk/KT1VxlWZ1qe/IwwGcB4DZaIDO/u5nk
	mGkQdLB2/ucelB5fBGVPFivNGtP84R9ts9gyGHrp4DOS2FcuQJ/MmjKgcGCkp1sqjyAy/I
	JKV6rlj/MCQ0c0MObfVQzmuVSVuYmoE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766442250;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sJ5Rz7oks9BsiGW+7NF3TEgOyoDBKE6fPRGPHx1O1TY=;
	b=SP2Il+Mbb70Adf+Z5FyVVrTiglt2NEwPGCTriW/yeE63WhdsAFfs3dsnS6tzKSB+rR1w7C
	6QGbctyDfdEHLjbcp2ZFm4KaG309gb0sK884rQvEXGeHbRwI91iGdiZ7TsgXhAo8b0ek8q
	HSZMBZm2gA+JPqcu4x+j5E/T5qI8N+I=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Chris Mason <clm@meta.com>
Cc: bot+bpf-ci@kernel.org,  bpf@vger.kernel.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org,  inwardvessel@gmail.com,  ast@kernel.org,
  daniel@iogearbox.net,  shakeel.butt@linux.dev,  mhocko@kernel.org,
  hannes@cmpxchg.org,  andrii@kernel.org,  martin.lau@kernel.org,
  eddyz87@gmail.com,  yonghong.song@linux.dev,  ihor.solodrai@linux.dev
Subject: Re: [PATCH bpf-next v2 5/7] mm: introduce BPF kfunc to access
 memory events
In-Reply-To: <93dbca4e-bd58-4b9a-a3c6-595810727121@meta.com> (Chris Mason's
	message of "Sat, 20 Dec 2025 14:59:56 -0500")
References: <20251220041250.372179-6-roman.gushchin@linux.dev>
	<8f23848b8ac657b4b4a2da04da242039c59e9ad9826a8d5fa0f5aee55acfecc9@mail.kernel.org>
	<87a4zdepdh.fsf@linux.dev>
	<dfc73fd6-9e5f-4b62-ac3f-7c9a327dd7fc@meta.com>
	<87zf7d6ll1.fsf@linux.dev>
	<93dbca4e-bd58-4b9a-a3c6-595810727121@meta.com>
Date: Mon, 22 Dec 2025 14:23:59 -0800
Message-ID: <87pl862m0w.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 81F49180008
X-Stat-Signature: tzbqfetumwgbc1xebyjm8ggihnbc5d73
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766442252-623436
X-HE-Meta: U2FsdGVkX1+jhxVErfHeEZWjcm3wTDbZe5RmI/OiY7cWhVl/bLwI6NbSFgmMfkwhd/ltX9RJtfoR4KfXu6nPZ9sfCFiEVYhRl8udaYQndezD8uXF0BG3lsAx/IaB+snDOzYPQFr1cRwibuW6yGA+x/gGBU+LqMq6hM3Bi3EZmfpFj4+k55sRlquORh27MoRD2dI1gcz40sTogWEKxX5FR+E/kDTG9QAbzNXNjpPPCpLqOZd0uBGb0SUicARxorlcOY0JzaRtpAydeFp1P9vPs3Z66z2Hamtc7hb4QSWWGimQRzypZcbvR6vkXBa4t/Onumd5MTRUD127GDGYzw7gGbqzFtlaGOZxELSLJzsB10hVIVIug6fDRHUCsC0Mrric4ps41ETPC8wqkYpBWcLMkhK07YTZhyjOeTQct5FzERTeGC91XGtywUzaVbF5zQAZYlcpl9DVB81+z8OaBOlLsLbfLeZDhfDPWvfdYkFBJuM2kykEpiwSB0WjQD1wwekrL6lliO9c2JB2Vd1Z583qLXBsZ1uIO50fZqgWL3bvFt7JwfG3O4LsE2lWSootXAkenK6EfPEqxI2xTkma7ueIiTg4uYno/51ryNCyp/YHDqClRew4bXozFAeKuN4Ig1QnfCpa7oDPpDjcIZaoKR6d/k5t8zkqkkzLQlff0GMtPCcbZ3PL0QhI3f1PTOIlVEY0to58/x+zNCKd3lbu6w+BIOf9jSclTjs9R62WNs3UFbo4KHd8HoCztc5RbUuSGlEN5ylA8lFGvmX2dgGR6bzyhus2HUFivJ9mV5hjO8su3wlb2uhcK8PBdm24jBbblCtkTU/P4t9TrYKh2Y2mNBhFIL7dzgoeFEAtsJfjeH3MR1GLX8V1tneJ07c9YjnAzQliBTGyco45CIXe+M4WUaqoX3GgcJ3ym/GkWuk8Kut7u9J0cB8AmePQ6HjfSfyUhLbQkJycDQhXfit/lWh94G9
 CusGVd5t
 B6UQ5t1nRVCNR9iI4M/EinM0MhGoFnQQ8h3XlkBEm33eg5CbqP2z2EPEjdAqho5rUwPaUh1b5i63fSgQ6cij3ZHi4cuw06jXs50MPjF78XjPgnnZ9SDFxiaaOXugp3iPwPfzUkqfoZvLd/ZMAh284ZjyDXhdNBIIRo9JMnGYAESG2iMLUvL99gZ329rAOn8eNIan+OTfDDV55DINbMEsX15xsYPfVQ+dZmwHhOUdZ3M4FNrxFI/lbJ9NQSGRxn00ir9SH8fNjP2zAff5aJtZXR/7DewwOkqOmVbJn9btreVBjbHigXiosW7R1ppcKuFji3M4uOXd2fxat5fD1DP259k5EA22bN0fA56QD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Chris Mason <clm@meta.com> writes:

> On 12/20/25 1:43 PM, Roman Gushchin wrote:
>> Chris Mason <clm@meta.com> writes:
>> 
>>> On 12/19/25 11:41 PM, Roman Gushchin wrote:
>>>> bot+bpf-ci@kernel.org writes:
>>>>
>>>>>> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
>>>>>> index d84fe6f3ed43..858eb43766ce 100644
>>>>>> --- a/mm/bpf_memcontrol.c
>>>>>> +++ b/mm/bpf_memcontrol.c
>>>>>> @@ -103,6 +103,22 @@ __bpf_kfunc unsigned long bpf_mem_cgroup_usage(struct mem_cgroup *memcg)
>>>>>>  	return mem_cgroup_usage(memcg, false) * PAGE_SIZE;
>>>>>>  }
>>>>>>
>>>>>> +/**
>>>>>> + * bpf_mem_cgroup_memory_events - Read memory cgroup's memory event value
>>>>>> + * @memcg: memory cgroup
>>>>>> + * @event: memory event id
>>>>>> + *
>>>>>> + * Returns current memory event count.
>>>>>> + */
>>>>>> +__bpf_kfunc unsigned long bpf_mem_cgroup_memory_events(struct mem_cgroup *memcg,
>>>>>> +						enum memcg_memory_event event)
>>>>>> +{
>>>>>> +	if (event >= MEMCG_NR_MEMORY_EVENTS)
>>>>>> +		return (unsigned long)-1;
>>>>>
>>>>> Should this also check for negative values?  The enum type is typically
>>>>> signed, so a BPF program passing a negative event value would pass this
>>>>> check but cause an out-of-bounds read from memcg->memory_events[].
>>>>>
>>>>> The similar bpf_mem_cgroup_page_state() in this same file uses:
>>>>>
>>>>>     if (idx < 0 || idx >= MEMCG_NR_STAT)
>>>>>
>>>>> which checks both bounds.  Could the check here be changed to:
>>>>>
>>>>>     if (event < 0 || event >= MEMCG_NR_MEMORY_EVENTS)
>>>>>
>>>>> to match that pattern?
>>>>
>>>> No, the bpf verifier enforces event > 0.
>>>> It's a false positive.
>>>
>>> I'll add some words here to the bpf prompts, thanks Roman.
>> 
>> I'll try to play with it too, hopefully we can fix it.
>> 
>
> https://github.com/masoncl/review-prompts/commit/fcc3bf704798f6be64cbb2e28b05a5c91eee9c7b

Hi Chris!

I'm sorry, apparently I was dead wrong and overestimated the bpf
verifier  (and ai was correct, lol). Somebody told me that enums
are fully covered as a feedback to an earlier version and I didn't
check.

In reality the verifier doesn't guarantee the correctness of the value
passed as an enum, only that it's a u32. So we need to check the value.
I've added necessarily checks in v3 of my patchset. It passes the local
ai review without your latest change. Please, revert it.

Thanks and sorry for the hassle

