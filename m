Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2E3CC53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 06:16:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B46826B008C; Wed, 29 Jul 2026 02:15:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF75C6B0092; Wed, 29 Jul 2026 02:15:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0D256B0093; Wed, 29 Jul 2026 02:15:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8081C6B008C
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 02:15:59 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 12AB6805F3
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 06:15:59 +0000 (UTC)
X-FDA: 85040803638.21.A9B8E60
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4A9D11A0007
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 06:15:57 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mJ1LnvGX;
	spf=pass (imf19.hostedemail.com: domain of guopeng.zhang@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=guopeng.zhang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785305757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nrwl4T0wokUMsgTEiucrmEaPLvIskj+e7z9qSMf7oIY=;
	b=sUWBEyhVaA243fwhr+ayYhI3CbJJI3o2af5FEXL5XrH+/g44dwLMdozCYG3XvwVABb/bsZ
	4K7ckxjeEWVUbk+pWVNHhbealKt/q7LN8YJxw3xUa3Wp1+VD2tmoS6+yyh0HqKjHYAn7by
	KDPyHFToAcjvvEY02bC4Bo4v495ZmOg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785305757;
	b=Y0H/ClLmj7f2LiFldr11xR38I+kwEE9sz1VYwANxg/eKUgtFlnBprwpdQVs/SDh0LXxeoT
	g62tuRZLcq5xaZS/TOxINTgir+782NJZCqoabAWjvbtMoELaqtNnsmCFnfNViGYUqhKJLM
	/t+FvABN+wp87fTQnlbRJHpJ5F79eJw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mJ1LnvGX;
	spf=pass (imf19.hostedemail.com: domain of guopeng.zhang@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=guopeng.zhang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <f706d139-53a7-436d-adc5-c691577ce53b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785305755;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nrwl4T0wokUMsgTEiucrmEaPLvIskj+e7z9qSMf7oIY=;
	b=mJ1LnvGXB6ZpGZZZvBrU6iFbLMGDuixbk+xBex4tNo4s6ZHuKUkSDXv4u++HsT7M/gtbWm
	hJ4tgOBsfy0UglTlyTDKeMPYLhuyloR7Ep7rIFa9rGYt28RoVGge9+Pdqrck4yjdL7HVSP
	e9yvye7cSbKwMh7mTAXtPRVodlgQV0c=
Date: Wed, 29 Jul 2026 14:15:25 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm: memcg: stop reclaim when a limit update is superseded
To: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20260724021805.1234583-1-guopeng.zhang@linux.dev>
 <amcT75pLmA0hRUm1@tiehlicka> <615d091c-bd3b-4686-817e-5b29756542ff@linux.dev>
 <amdkHvSMj95DUri5@tiehlicka>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <amdkHvSMj95DUri5@tiehlicka>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 9nubti7pu3sgwhxhi8mksahbaumkacnz
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4A9D11A0007
X-HE-Tag: 1785305757-694902
X-HE-Meta: U2FsdGVkX1+SQNAbFMxX7vKCZSDZcpJTLkjicAm0qmPl6Re6jfkatx/i7DEAVZdbBe93UvR9pJmYOaOxS34KO3mgxl/tCNpFgDI+GsJ9ITng9O3zir3i5ugRVuUqSntPDSiSc8Hdw7YAtbx5h64C56QsWSDYELhIIOiIsdrsd+hqiu2gVrlp6NJdT+dqrY7gJQu0SQxLqtbpN6Jtg8dCKfam6KpMYXTYXsKaJKTbjkZ1NZoqKY2j9HVyi4u7jMQYrEQIRoktWTj1Zrsz/DYjHHtPxn8YtDTp4rJfli7ZNRZVpXlJjmqjfBD00WYfbQZQdCVYI8fLt9RO3GGjrKZhQ8abrehwlep6nlhcs86cYzFqPE8thQk9KHtiYEQgt8knnL7GnAqkK70lM0hphg7FFYd/5xBjVVOO8KI4WofH8fPxblLUsu78BZ4j4BVP255yTlRAXoRm5YBs9H1za41peG1oCLUQ0Xn38ISGQ9qoK1IByimeYkgHO7HQbFDUFJP3b9iv2YmAWfj9zw5G7ufxQ6imENyl5Qugi1dC0qScI9ArukBVO0ZYVye/23NZXhZhbRzji9GdFxuNE25T2u4bLPJEL3jMjc7fA4eGTwTC4yvs+8TCIEoBFv5czyVoCJARPNVXBf8DCQ19DqlzMWKh3xX/BxNMdjHmXIW4oPw8AN77KKtr8r0uFqxrE8ckP6oykpV2bLPkv1ILXUpkGXUdCI81Swc6szC/SNQbRdVmky0WTevIw6vTAKEWFc3Z77lCsAnHo1HcMBeeBpGSDXMskpp/AX9aWacxJmhkHujnja6HAiDSBptZTbjq1fsGtSiviOOeEJ1Va+4Dd3jp9qrY4ltpQsvWJYc8XiN3f/Occ2D81ejIZkBeB//2Xw7pYpKNNeJTdZO7RQVG0/Rsc4CKzRzI9KIUCeFLYhc7pf3wgsgIKNHcL5SsDPOoi5GodIlHb6euFkZMBMrqRXdvjgI
 IApdXdol
 VLou9je7ESjuEM36RoFG8uME6IU7MAyLZ89b+39bAa/WHxxr/E3h3ozFIK8Jt2yJ7WQucJk7vbdc5xry8ZW4Ke3gaDlPleIlExtLAlXkQ5y2+IaEnYNILV5ekV2qgjrEw25uKcPu536V0lhv/7sy4VAtcmsQm7hORsOY/kce5YQNP47XxuLvaNym/6q5KqjI9ayrZzyF3aAd9sJLT/JI4IBRwSHLtF8DDw44irPllcrsGEVg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/7/27 21:58, Michal Hocko 写道:
> On Mon 27-07-26 20:59:23, Guopeng Zhang wrote:
>>
>>
>> 在 2026/7/27 16:16, Michal Hocko 写道:
>>> On Fri 24-07-26 10:18:05, Guopeng Zhang wrote:
>>>> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
>>>>
>>>> kernfs serializes file operations only per open file, so separate open
>>>> files can update the same memory.high or memory.max file concurrently.
>>>> Both handlers store the new limit before synchronous reclaim, but
>>>> continue to use the writer's local target in the reclaim loop. If another
>>>> writer raises or removes the limit, the first writer can continue
>>>> reclaiming toward a stale target.
>>>>
>>>> For memory.max, this can leave the writer looping indefinitely once
>>>> reclaim retries are exhausted. The OOM path sees sufficient margin under
>>>> the current limit and returns true without killing, while the writer
>>>> still compares usage against its stale target and records another OOM
>>>> event.
>>>
>>> The current behavior is deliberate as described in b6e6edcfa4056.
>>> What is an actual problem you are trying to fix?
>>
>> Thanks for raising this. I agree that the behavior introduced by
>> b6e6edcfa405 is deliberate while the limit installed by the writer
>> remains current. The problem occurs when that limit is overwritten by a
>> later write through another open file.
>>
>> Writer A stores a low memory.max and enters synchronous reclaim. Writer
>> B then restores memory.max to "max". A still compares usage against its
>> local old target, while mem_cgroup_out_of_memory() checks the current
>> memory.max. Since 1378b37d03e8, the current-margin check in
>> mem_cgroup_out_of_memory() sees sufficient margin and returns true
>> without selecting a victim. Once the reclaim retries are exhausted, A
>> therefore loops indefinitely and increments the oom counter in
>> memory.events on every iteration.
>>
>> I reproduced this with a cgroup holding 128 MiB of anonymous memory and
>> with swapping disabled for the cgroup. Writer A lowered memory.max to
>> 32 MiB. After that value became visible, writer B restored memory.max
>> to "max" through another open file.
> 
> Is this trying to replicate any real workload? One would expect that
> writers to limit do some sort of coordination otherwise the exact
> behavior is not really well defined.
> 

No, this was not motivated by a reported production workload. We found
it through automated randomized testing for our cgroup observability
work and reduced it to the reproducer above.

>> On the unpatched kernel, A remained blocked after B's write, and the oom
>> counter in memory.events increased from 37333 to 13512861 during the
>> reproducer's one-second sampling interval. With the patch, the same
>> reproducer observed A return after B superseded A's limit.
>>
>> The new check does not change the behavior introduced by b6e6edcfa405
>> while the writer's target remains the active limit.  For the indefinite
>> loop described above, 1378b37d03e8 appears to be the more precise
>> Fixes: target for the memory.max hunk. Does that match your reading of
>> the history?
> 
> Well, to be really honest I am not really convinced this needs fixing.
> And if yes, your patch changes a well established behavior existing
> userspace might already depend on. While your described case doesn't
> look great it doesn't seem really harmful and the looping task is
> killable.

That makes sense. Without a concrete workload showing practical impact,
there is not enough justification to change the established behavior.
We can revisit this if such a workload turns up.

Andrew, please drop this patch from your queue.

Thanks,
Guopeng

