Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E007C53209
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 12:59:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B95F6B00DB; Mon, 27 Jul 2026 08:59:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 190F66B00F0; Mon, 27 Jul 2026 08:59:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CE6A6B00F1; Mon, 27 Jul 2026 08:59:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C8F5A6B00DB
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 08:59:42 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2AD561C0ED1
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:59:42 +0000 (UTC)
X-FDA: 85034563404.04.1801448
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf24.hostedemail.com (Postfix) with ESMTP id 38ED1180008
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:59:40 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pKx7nQjq;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of guopeng.zhang@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=guopeng.zhang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785157180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UGm8K3HWHfu5g3506x1reX7/ao6GY/lBHJT4qsVrxm8=;
	b=aEuUr9wNV6MgdJM5+sFqSy1Hk89vzFkOsyRr6wwX4WfCeuNHT7BiJ5me0waq50BiQqB4KD
	IBOBunSBQgjX59mXXwMLQP9u3w5ZdS10mMYc1soULMIJKArntJwTCsz96OVVH00mKoTVOA
	XjoUIVEAuFPH9i1B3tNXpTeuRsxT2UM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pKx7nQjq;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of guopeng.zhang@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=guopeng.zhang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785157180;
	b=K5IY7zIcCNgNjFimVKdCvSnxnxSAGY47D3wsf+tkY2laJt/QjEuLwqX8X4Lv4eBdSmS7Es
	KWjuAfnh+WoMqfBwnJzCSdnBHJWCmjZGQQvaNlLeWR8nsNMHlKWQtecQXcPrKR+5upzVS4
	tlXPUQveYiZqtBKy0cpXHOJ99B/BtWs=
Message-ID: <615d091c-bd3b-4686-817e-5b29756542ff@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785157178;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UGm8K3HWHfu5g3506x1reX7/ao6GY/lBHJT4qsVrxm8=;
	b=pKx7nQjqZ9OLuPkkD3nkGAiBOx+aCIzESNbsDurHU3vGAEJcnbnQZvAf9VBPxVJP/p3DHL
	a9/4gu498oML3/ZQ34E2am3TOnX42/QkbSwEZRC2HPRtir028Bj+t2393tXc9pgRC2LJC5
	T3mX4XRlIWqC5IszTJZm33uiQ2ysYV8=
Date: Mon, 27 Jul 2026 20:59:23 +0800
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
 <amcT75pLmA0hRUm1@tiehlicka>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <amcT75pLmA0hRUm1@tiehlicka>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 38ED1180008
X-Rspam-User: 
X-Stat-Signature: cnbbejfbb8xw8w5t5ufuk3p86utbbpqq
X-HE-Tag: 1785157180-587715
X-HE-Meta: U2FsdGVkX18e1iEddF0ZiGHfPLGsZu6MqXV/eOZw3CFs+3s7SZ1I+IOx1Ohx2XgiqH1CTBUHxJqHmujo1Tf0GEjDAE6dEEjs67xMJGj0IbNyihowJ8NKfScfr9D9b0MO0EuZg4w9vyLBL4I+jwwbs1rfiyJPfxA6l0F2r737DMbLJQ13gFxyDd2CKQ+8NWbiwRyjHdOH0BoX2IglAbE38pq3YpoZ9MG76YEaYhR1gOu6P82uXchIyjrkyj5rDbDpDe/JQTXZ/gcw/jPDxiVlXOxI1O53e4pM8cXFNwhsKjfzZCT5mXO+lUj9wSuowXrPWQuHg1UvM/zC4W6XAMMTIFq2HAqPHNUaQNMTuU/28zJOmilZ/SeHLTt2So4Szr8TiHnxNBX+IBw1yu2Qyjio5hmtoz2JTpF+h82TppgJtsyuQ4LI69XXU6vuZGx40kzU33JE5Np9d2/gT7DN0sR7BSSjBWMSDvMYIwuXekVAXzmhqoKve2RMpK8kznrkEAL6eSdoy0gbzi5ndsqh0TB4PKqeKQy9RLEMLhIrEyVQZ/6N3H5h8qdIfQ6M2fvchds6uT0X9xp1i2WyQ3a9FE9ntvXEFh9rDvAoX8hxuTKs1EsfOjG4ZNe+9u88q4I6u15ha4tRU/y0cBKUw4YSnXeI/BhdXQxPy0g9IddAa714P8zNwBfwlOvupFurNBBXR9r9gN5dwSlHPkG/bt+cBBB9avdK5YiXwFmmbUvDfXXzu1gJJE35A8XiBXbgnz21XrRMqORwl8m51spfSdUpt184jbtymbKNIrzZ7aodMWsbPAHhNFFqPwQjnZWIGWlSlLxLOZukiR/hvdAzpmWbxXDVyUJoPXLyJYi7yXRK8riiolih3Ytfazsl6f7HByi1qWb4YfueS2Z9J/FXuhWYPsx0CJEL0Zbws/KU1F5CfhiHIBj53NKLA+1YVO894yLASjTu2auPo+DZ2SFyEzbWPQ9
 ZUdQiYuZ
 qWAJJhVIXvUoShDBRb/FLjXjwBQcFnhyeDUqqUL+Y2+pW/1CfhOnzRFdL+g2YbYNZso+q7kqbI6RkmY8kQhAdBBt8cVR3W8nke7xy6SHKYky9S5iJzvQZuTUIuhbrobdVGvmYCPsIEFdRelLn4jvdM6CTKpcGb0F007TeuBuaI/DUEtld6Be0GeJOZroyAWFJ39/zlUr4luo770F10S6hgaDod4GBpUrLJiO74T4SGnfae2k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/7/27 16:16, Michal Hocko 写道:
> On Fri 24-07-26 10:18:05, Guopeng Zhang wrote:
>> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
>>
>> kernfs serializes file operations only per open file, so separate open
>> files can update the same memory.high or memory.max file concurrently.
>> Both handlers store the new limit before synchronous reclaim, but
>> continue to use the writer's local target in the reclaim loop. If another
>> writer raises or removes the limit, the first writer can continue
>> reclaiming toward a stale target.
>>
>> For memory.max, this can leave the writer looping indefinitely once
>> reclaim retries are exhausted. The OOM path sees sufficient margin under
>> the current limit and returns true without killing, while the writer
>> still compares usage against its stale target and records another OOM
>> event.
> 
> The current behavior is deliberate as described in b6e6edcfa4056.
> What is an actual problem you are trying to fix?

Thanks for raising this. I agree that the behavior introduced by
b6e6edcfa405 is deliberate while the limit installed by the writer
remains current. The problem occurs when that limit is overwritten by a
later write through another open file.

Writer A stores a low memory.max and enters synchronous reclaim. Writer
B then restores memory.max to "max". A still compares usage against its
local old target, while mem_cgroup_out_of_memory() checks the current
memory.max. Since 1378b37d03e8, the current-margin check in
mem_cgroup_out_of_memory() sees sufficient margin and returns true
without selecting a victim. Once the reclaim retries are exhausted, A
therefore loops indefinitely and increments the oom counter in
memory.events on every iteration.

I reproduced this with a cgroup holding 128 MiB of anonymous memory and
with swapping disabled for the cgroup. Writer A lowered memory.max to
32 MiB. After that value became visible, writer B restored memory.max
to "max" through another open file.

On the unpatched kernel, A remained blocked after B's write, and the oom
counter in memory.events increased from 37333 to 13512861 during the
reproducer's one-second sampling interval. With the patch, the same
reproducer observed A return after B superseded A's limit.

The new check does not change the behavior introduced by b6e6edcfa405
while the writer's target remains the active limit. For the indefinite
loop described above, 1378b37d03e8 appears to be the more precise
Fixes: target for the memory.max hunk. Does that match your reading of
the history?

Thanks,
Guopeng



