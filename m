Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CCF6EA3F16
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 07:39:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33D4D6B0089; Tue, 10 Feb 2026 02:38:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DB1A6B0088; Tue, 10 Feb 2026 02:38:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F4DF6B0089; Tue, 10 Feb 2026 02:38:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0D16C6B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 02:38:59 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A72C816040E
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 07:38:58 +0000 (UTC)
X-FDA: 84427745556.22.2A4CB31
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id C72D31C0006
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 07:38:56 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770709137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NVqfXZFieKJgW7wqXCfcV0Gq8P5xSqrtgXrA3fcBA/o=;
	b=LWpOIXjAYo1RI1pMgt7S2JhJm51zcbidxdTVLFv4LelqZDdEtsyAwMeyOcOiIVxGsb4OED
	8Acwi95DSABQuyJ34tzzk/haPaIZAGey3RVSjFWpUSfTN2mVy9gj3bca/pFZ1GdKpWuVjC
	WsEEw3Kh1gGC9Z+GIiFNvDAVrKaLTOY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770709137; a=rsa-sha256;
	cv=none;
	b=f7ezC4RP0X5vjd9C/WWxcNLadRy/qQcFE5/BSwXd0eQNquAWVrV8lUJheRtsfBbjwF3BIK
	AhjyUCz2eU2TUSY3/k+2QoUS4ciDEJbZ3YYwTeGq3cLgP6HOjqAOZ1lUshF8/ieAUvLXyd
	GxFkIc00WwQb57DxNuD70Ux5G2Y5cPw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3F2F9339;
	Mon,  9 Feb 2026 23:38:49 -0800 (PST)
Received: from [10.164.19.61] (unknown [10.164.19.61])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 46E0D3F740;
	Mon,  9 Feb 2026 23:38:52 -0800 (PST)
Message-ID: <b77dc11e-fe09-4f0c-a912-d05faa01ff1c@arm.com>
Date: Tue, 10 Feb 2026 13:08:49 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] memcg: use mod_node_page_state to update stats
To: Shakeel Butt <shakeel.butt@linux.dev>, Harry Yoo <harry.yoo@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
 Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 Meta kernel team <kernel-team@meta.com>
References: <20251110232008.1352063-1-shakeel.butt@linux.dev>
 <20251110232008.1352063-2-shakeel.butt@linux.dev>
 <1052a452-9ba3-4da7-be47-7d27d27b3d1d@arm.com> <aYAmGc6lu973jRwu@linux.dev>
 <2638bd96-d8cc-4733-a4ce-efdf8f223183@arm.com>
 <51819ca5a15d8928caac720426cd1ce82e89b429@linux.dev>
 <05aec69b-8e73-49ac-aa89-47b371fb6269@arm.com> <aYOuCmjQ5lGm8Mup@linux.dev>
 <4847c300-c7bb-4259-867c-4bbf4d760576@arm.com> <aYQuj6Ot-JS4tXvY@hyeyoo>
 <7df681ae0f8254f09de0b8e258b909eaacafadf4@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <7df681ae0f8254f09de0b8e258b909eaacafadf4@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: r3r4tttsn698mer5xdztju98fs4wo4qe
X-Rspamd-Queue-Id: C72D31C0006
X-Rspam-User: 
X-HE-Tag: 1770709136-278503
X-HE-Meta: U2FsdGVkX1+hyRrJsqkPV5TSc8dCgA2KZ0ZZWbvA01agQHYoT1yK0wtfXKrs1QgsrtaCzbE1b7sIPNbc86FJofTbI1iSkd6hcH38WEBTZyyPpGTBzbOZJz7Bb5MV/Ymb35H3UhzZ2BsF/P8B/zXLhUbl8immsHTcjW8bSGiRECFKAiNDjBlr8bXIXAANOR9fkoKTDOdS4b5oT/bljxAaHyi00cE6XCBDzWtHgRf/Qi02gKelzonvYhY0Hcj+iHbErHPRIoDYzhuWrj5nxMdyr70S7evmgSjXFYZIomDpR3ECt+Q9BqzPGIr/Ya3cxt/PU8StmyzhM5np4q2Woj20BIt7zROleTqOt+awnJr88RddjH836uNblC5zQi54bByUJzgutekDsGFCpgPUuzi601lrKVzbmfdwtr1MbYDVFUumfky4nPw1jKVonc82CfPLnUwBzdsS2LKbpUrydbITKplPTRHT0C1y6+YEnvOnBKeB13G47rCW8FGSzK8MwlrWvaMzzGlC/eWKjfZXDBerWO/+ZqnXn6oBIh5IuErP/+M2X92kX26oMcwffJutiqm6I7EJf0LJVMfhpEnKNtW9S0mp7NYy5B0SnCmRZZkK7S3WcV3SC/3lbDFi9Esphvbut5tdYFW1ZpUR5ypwuGARo9hTLxwkpzjgNDi4V3BX+M/7W8oFksTtmfWB763Qe8T5edhpSNpC07BiSEXctVGhgFcDDFEq3ajzFfRzDyyHaGtpjzdYyp4sLq7JIdUo6wBvjDDeN4ZNmdf412CQJTJ5vHeXJq8wY1M+OTYkru6VotbHyeBQs7qr7CtD3WBN4oBIh33lq/IDoFGIdKe0J31qfc8nSZ5eVNkxEeB3e+l4R9X/cwnUnUnRDq6ICo9S5ntsqdeeVEbDDx+hqLP/Xcpt43m+yhcXX1aG61UD/pHRqbaMwYiVu8/eqz53x5ysg/2Yi4KHT96tN0/+0dngfUP
 2tmBN+KW
 cHOSU6XZqSyw+utHEkNI+s1VKga0DyYY1u+o1y1IkROLyAels9UfDrtb9wZnM16x+KCXq29WwC2Mbw2ZUFxiUjm9fIfCpr3lQyFl8gXNYBubqrD7QkSYsMzRyWQcArXPTqv1h8x/a7rgNU4XRrgzdCTOzdKhXOeUyRCdt2XDBitVGdbjQOG3wdA2cH/iVPZ1SNZ5dcdnnEq0jGAoUZqsahQEkN40dlWXNOVICmhumQe3ECqO9ZrDvUWzbgA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 05/02/26 11:28 am, Shakeel Butt wrote:
>> On Thu, Feb 05, 2026 at 10:50:06AM +0530, Dev Jain wrote:
>>
>>> On 05/02/26 2:08 am, Shakeel Butt wrote:
>>>  On Mon, Feb 02, 2026 at 02:23:54PM +0530, Dev Jain wrote:
>>>  On 02/02/26 10:24 am, Shakeel Butt wrote:
>>>  Hello Shakeel,
>>>
>>>  We are seeing a regression in micromm/munmap benchmark with this patch, on arm64 -
>>>  the benchmark mmmaps a lot of memory, memsets it, and measures the time taken
>>>  to munmap. Please see below if my understanding of this patch is correct.
>>>
>>>  Thanks for the report. Are you seeing regression in just the benchmark
>>>  or some real workload as well? Also how much regression are you seeing?
>>>  I have a kernel rebot regression report [1] for this patch as well which
>>>  says 2.6% regression and thus it was on the back-burner for now. I will
>>>  take look at this again soon.
>>>
>>>  The munmap regression is ~24%. Haven't observed a regression in any other
>>>  benchmark yet.
>>>  Please share the code/benchmark which shows such regression, also if you can
>>>  share the perf profile, that would be awesome.
>>>  https://gitlab.arm.com/tooling/fastpath/-/blob/main/containers/microbench/micromm.c
>>>  You can run this with
>>>  ./micromm 0 munmap 10
>>>
>>>  Don't have a perf profile, I measured the time taken by above command, with and
>>>  without the patch.
>>>
>>>  Hi Dev, can you please try the following patch?
>>>
>>>  From 40155feca7e7bc846800ab8449735bdb03164d6d Mon Sep 17 00:00:00 2001
>>>  From: Shakeel Butt <shakeel.butt@linux.dev>
>>>  Date: Wed, 4 Feb 2026 08:46:08 -0800
>>>  Subject: [PATCH] vmstat: use preempt disable instead of try_cmpxchg
>>>
>>>  Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
>>>  ---
>>>
>> [...snip...]
>>
>>> Thanks for looking into this.
>>>  
>>>  But this doesn't solve it :( preempt_disable() contains a compiler barrier,
>>>  probably that's why.
>>>
>> I think the reason why it doesn't solve the regression is because of how
>> arm64 implements this_cpu_add_8() and this_cpu_try_cmpxchg_8().
>>
>> On arm64, IIUC both this_cpu_try_cmpxchg_8() and this_cpu_add_8() are
>> implemented using LL/SC instructions or LSE atomics (if supported).
>>
>> See:
>> - this_cpu_add_8()
>>  -> __percpu_add_case_64
>>  (which is generated from PERCPU_OP)
>>
>> - this_cpu_try_cmpxchg_8()
>>  -> __cpu_fallback_try_cmpxchg(..., this_cpu_cmpxchg_8)
>>  -> this_cpu_cmpxchg_8()
>>  -> cmpxchg_relaxed()
>>  -> raw_cmpxchg_relaxed()
>>  -> arch_cmpxchg_relaxed()
>>  -> __cmpxchg_wrapper()
>>  -> __cmpxchg_case_64()
>>  -> __lse_ll_sc_body(_cmpxchg_case_64, ...)
>>
> Oh so it is arm64 specific issue. I tested on x86-64 machine and it solves
> the little regression it had before. So, on arm64 all this_cpu_ops i.e. without
> double underscore, uses LL/SC instructions. 
>
> Need more thought on this. 
>
>>> Also can you confirm whether my analysis of the regression was correct?
>>>  Because if it was, then this diff looks wrong - AFAIU preempt_disable()
>>>  won't stop an irq handler from interrupting the execution, so this
>>>  will introduce a bug for code paths running in irq context.
>>>
>> I was worried about the correctness too, but this_cpu_add() is safe
>> against IRQs and so the stat will be _eventually_ consistent?
>>
>> Ofc it's so confusing! Maybe I'm the one confused.
> Yeah there is no issue with proposed patch as it is making the function
> re-entrant safe.

Ah yes, this_cpu_add() does the addition in one shot without read-modify-write.

I am still puzzled whether the original patch was a bug fix or an optimization.
The patch description says that node stat updation uses irq unsafe interface.
Therefore, we had foo() calling __foo() nested with local_irq_save/restore. But
there were code paths which directly called __foo() - so, your patch fixes a bug right
(in which case we should have a Fixes tag)? The patch ensures that mod_node_page_state
is used, and depending on HAVE_CMPXCHG_LOCAL, either uses irq disabling or
preempt_disable + cmpxchg - making the interface irq safe.


