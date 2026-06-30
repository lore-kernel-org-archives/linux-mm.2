Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81CDDC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 16:31:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EC846B00BE; Tue, 30 Jun 2026 12:31:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09E326B00C4; Tue, 30 Jun 2026 12:31:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF6426B00C5; Tue, 30 Jun 2026 12:31:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4610A6B00BE
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:31:29 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9FE241C36E9
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:31:17 +0000 (UTC)
X-FDA: 84937118994.16.6C40995
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf06.hostedemail.com (Postfix) with ESMTP id D11A8180003
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:31:14 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qtt7N7T+;
	spf=pass (imf06.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782837075;
	b=J3FlIJPy0oSHc7yup6hHuguZv6VwC3UN5CiCl8L4kYrL5emPyLsppxmLBfj8CQSfLbvzxp
	r6Fh3qSPhj3tIZ66U0sPkkEDdtiLjCatNMTORLTvivw4SwqX+Qplj4rC0RnyQke5OlU8v3
	CBU2cIvy50Xz8xkvz8GsCcgcHe85SzA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782837075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5Xu6GzUkNCE14ufar9+KLOm5/yfYEVOMR8CoxaWNrKU=;
	b=aLLgiqMElcpg87DhKFXhUIaf7MtnzSirGHkkk+U2cqVenXQrR+fDyZFlwodnAL0DnamijB
	1/1jAMVwFdMNTrDIpelswCmWYLAlDURjBtsO1uc1h++kSn/XjO3P196/pdFzgwboVoV/cl
	j2uGw/avbMB6FwgmQLIAoErdddsayVk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qtt7N7T+;
	spf=pass (imf06.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <e8e1a409-48d8-4fa7-ae98-49485a1607f6@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782837072;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5Xu6GzUkNCE14ufar9+KLOm5/yfYEVOMR8CoxaWNrKU=;
	b=qtt7N7T+U2sk/W/u8fGrzG+0CoCpe4CScmp3L/9RHZMf5U8PEFP6fLKvEoaqOe+fhohd25
	0IIYU2Lrm1tLUBArCArKtmdFuqsNX0jE7PLJnvF/+SA1c7YdGqrOyF9hS8+w5D8jsU3SJt
	6Ka614oNxoNUFFgYvJsjrLXazUgxkQw=
Date: Tue, 30 Jun 2026 17:30:58 +0100
MIME-Version: 1.0
Subject: Re: [PATCH v3 1/2] mm/vmpressure: skip tree=true accounting on cgroup
 v2
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
 linux-mm@kvack.org, tj@kernel.org, mkoutny@suse.com, shakeel.butt@linux.dev,
 roman.gushchin@linux.dev, liam@infradead.org, linux-kernel@vger.kernel.org,
 ljs@kernel.org, mhocko@suse.com, rppt@kernel.org, surenb@google.com,
 vbabka@kernel.org, kernel-team@meta.com
References: <20260630112617.1198623-1-usama.arif@linux.dev>
 <20260630112617.1198623-2-usama.arif@linux.dev>
 <akPptQjnQEmvCXhD@cmpxchg.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <akPptQjnQEmvCXhD@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: yzts5y575gcuhujaofbk48xdb85qdyuk
X-Rspam-User: 
X-Rspamd-Queue-Id: D11A8180003
X-Rspamd-Server: rspam02
X-HE-Tag: 1782837074-443006
X-HE-Meta: U2FsdGVkX1+FAXaHGc1LjoEdUsNoSzlww7pwQzjPtjldUz00AiQwtdyicsr6LRfGDWKYq3iW2+l5/wu9/XI5cHvMlyg5NDreC0UDXtb4BgxNaAdWCxk12qeJkXt44L68gjdaxa2tM6BmbE5Yezz5mbqk3bPoZLzeG0KAJCq7gCECSwzhSpZlKBc1cj45I5AO223+6Qj3uAq5Qx5lbmokcjvYr3Hphh79fAlrnClsgcs/KlpuCjOuO1ySX8gj+7FEoM/mP1S6gt8S3Nrinqwk2ylTlKOvSHvvVF86pjowShU2dzr+Qa+YUVocjx2YegLCMWO6YHVFeY63CBbuk5LqgGGAZQIsvcOmdxiDBIywVMn8Su7QmxahgX1KCgKFuzbulHo4QoNnM+q6Ql2wuldN8i1b2/6Fi+LXpt3WxYxn5f6NzUKy726Zwt/hQciVtvflfEgvAYhFR1YsJwJ/XzfFUhvBv0c7G4Hh1d9Lp9mMUU7t/luKhqnHaqFVS0H3zHE/XiZ7RZpKzzVh8xUAX6yvlr7iAe70D7sCRBIq4jFtJSHJanbVLEBPsjxPqhXpylUwTEBvocRo389yaPRUVpnu46LPeDA3Ahfkm9dARxoE2FT+P89yJG6tdhgZBrImZsV0JkkaVXqOvq4TKPhd0+pTq0cTsIS+3iSFl7dROam3W5NUbcx2rS0A2UsaO9/u8t8aNyccREp12ACRWFxBfGw2LTWs0XZmOC3+89BKf+KZxbb7g5FOigrnCn2grx7IUWdtsnLyyBRLyvqRWS/3AsNl5PgPzCinulbbavWt+OOX4yjErbv+yyXvhn24x3CRWHdEe8q35FRZR8AltOknQHCUIJb5ecszyk/AI2w7sTDPQTyPizPzVp15+ecxYuQTz0aRv96g+Rf9ZiaGbjOJptzV4E1P6RTuR6cXV5xniTzf0aHA8etrhOb4DXY7f1CrtXmFysP1BAgsTp6tduhs9cJ
 J1Ucv1xZ
 +py/34fAsVL+E8SxxY6JZb7jxU/+65D2T0QP3q8hZGDZLHgFWeMEDiMLZkinEWV0tm85rwYd42pg7YGbby7MMbpnas0uz5maBlAYVy/V61ZNAdiwe3AEEN76pPfUjtON3uNsAy1kM8kGeJ8f5x76+M8xp1ZpqV6rVzm4upEaAUWQfQjvC9XzNWzwh6wlD/o74ReKprMpO46i85AmtGvVlMIwY2POK5ynrRAAqKJH/N5HSG7spwbEeY50dwuipbFqX4SkF+FqbO1K22sVLjuqCL22NPv8FJTuDVCjxptRJyfcn4pzCS+6OYUlNCQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 30/06/2026 17:07, Johannes Weiner wrote:
> On Tue, Jun 30, 2026 at 04:23:32AM -0700, Usama Arif wrote:
>> vmpressure() has two outputs gated by the @tree argument:
>>
>>   @tree=false drives in-kernel socket pressure (mem_cgroup_set_
>>               socket_pressure), consumed by TCP/SCTP. This only
>>               applies on cgroup v2; on v1 socket memory is charged
>>               separately via tcpmem and the consumer reads
>>               memcg->tcpmem_pressure instead.
>>
>>   @tree=true  drives userspace eventfd notifications via the v1
>>               memory.pressure_level / cgroup.event_control interface.
>>               v2 has no equivalent: userspace gets reclaim signals
>>               through memory.pressure (PSI), which does not touch
>>               vmpressure.
>>
>> The existing early return covered v1 + @tree=false. The symmetric
>> v2 + @tree=true case was falling through and doing the full lock /
>> accumulate / schedule_work / parent-walk dance for an events list
>> that can never be populated. bpftrace on a 176-core production host
>> (cgroup v2, CONFIG_MEMCG_V1=n, 285 memcgs, sustained reclaim) showed
>> ~16,200 @tree=true vmpressure() calls per minute. Add an early return
>> that skips cgroup v2 + tree = true which avoids us doing all this work.
>> On a v2-only host this also eliminates a lock contention path that can
>> serialise reclaimers on a single global sr_lock.
>>
>> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>> ---
>>  mm/vmpressure.c | 10 ++++++----
>>  1 file changed, 6 insertions(+), 4 deletions(-)
>>
>> diff --git a/mm/vmpressure.c b/mm/vmpressure.c
>> index f053554e5826..c82cee1ab43b 100644
>> --- a/mm/vmpressure.c
>> +++ b/mm/vmpressure.c
>> @@ -246,11 +246,13 @@ void vmpressure(gfp_t gfp, int order, struct mem_cgroup *memcg, bool tree,
>>  		return;
>>  
>>  	/*
>> -	 * The in-kernel users only care about the reclaim efficiency
>> -	 * for this @memcg rather than the whole subtree, and there
>> -	 * isn't and won't be any in-kernel user in a legacy cgroup.
>> +	 * Only two combinations have a consumer:
>> +	 *   cgroup v2 + tree=false -> in-kernel socket pressure
>> +	 *   cgroup v1 + tree=true  -> userspace eventfds (memory.pressure_level)
>> +	 * Skip the other two: nothing consumes the result.
>>  	 */
>> -	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && !tree)
>> +	if ((!cgroup_subsys_on_dfl(memory_cgrp_subsys) && !tree) ||
>> +	    (cgroup_subsys_on_dfl(memory_cgrp_subsys) && tree))
>>  		return;
> 
> I had already acked this one, with a half serious suggestion to make
> this
> 
> 	if (cgroup_subsys_on_dfl(memory_cgrp_subsys) == tree)
> 		return;
> 
> Anyway, no strong feelings. If nobody agrees,
> 
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Yeah sorry about this! I just amended my last patch to move code
from vmpressure-v1.c to memcontrol-v1.c and just sent it, without
other changes. Forgot Shakeels ack on v2 as well :(

Andrew would you mind applying the below fixlet? I can also respin
if its easier. Thanks!!

From 969c19da782bbcd77ae4b9e94d3a9e1d78c198d7 Mon Sep 17 00:00:00 2001
From: Usama Arif <usama.arif@linux.dev>
Date: Tue, 30 Jun 2026 09:25:05 -0700
Subject: [fixlet] mm/vmpressure: skip tree=true accounting on cgroup v2

Simplify the guard. Both cgroup_subsys_on_dfl() and tree are bool, so
the two combinations that have no consumer (v1 + tree=false, v2 +
tree=true) are exactly the cases where dfl == tree.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/vmpressure.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/vmpressure.c b/mm/vmpressure.c
index 14470141bbe6..9629240d77ad 100644
--- a/mm/vmpressure.c
+++ b/mm/vmpressure.c
@@ -120,8 +120,7 @@ void vmpressure(gfp_t gfp, int order, struct mem_cgroup *memcg, bool tree,
 	 *   cgroup v1 + tree=true  -> userspace eventfds (memory.pressure_level)
 	 * Skip the other two: nothing consumes the result.
 	 */
-	if ((!cgroup_subsys_on_dfl(memory_cgrp_subsys) && !tree) ||
-	    (cgroup_subsys_on_dfl(memory_cgrp_subsys) && tree))
+	if (cgroup_subsys_on_dfl(memory_cgrp_subsys) == tree)
 		return;
 
 	vmpr = memcg_to_vmpressure(memcg);
-- 
2.53.0-Meta






