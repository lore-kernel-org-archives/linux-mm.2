Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B24BCC83F26
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 02:20:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 527726B007B; Thu, 24 Jul 2025 22:20:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FF256B0088; Thu, 24 Jul 2025 22:20:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43BFB6B0089; Thu, 24 Jul 2025 22:20:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 35C046B007B
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 22:20:54 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AA468B99F1
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 02:20:53 +0000 (UTC)
X-FDA: 83701183986.28.1056E46
Received: from esa4.hc1455-7.c3s2.iphmx.com (esa4.hc1455-7.c3s2.iphmx.com [68.232.139.117])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7F274A0006
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 02:20:51 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=fujitsu.com header.s=fj2 header.b="oPQar/6n";
	spf=pass (imf25.hostedemail.com: domain of ruansy.fnst@fujitsu.com designates 68.232.139.117 as permitted sender) smtp.mailfrom=ruansy.fnst@fujitsu.com;
	dmarc=pass (policy=reject) header.from=fujitsu.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753410051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F6MoRUVGr8WG1btkk1PVJMTVfQVbfxzpo+FbC8bWR+c=;
	b=JIHqv0gz/SzxYjMiZCw2y4gFERM+JHYPJI1LXJY74yBFOrjr2FCHgCcKsRpV2+MH+Dd9kC
	5KLfaAFLIBwm0xyxEugyvsBJTzk+9kg/kkffXsksoXI+1bh9rh20UMyqE0LhfGg5C6Xupd
	9r1CSkrpOYmbw6RNJRAPjguXMPy62wg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753410051; a=rsa-sha256;
	cv=none;
	b=6GGI7jG1K9pgnp5F6f1NuTyNe6gBjA1zvHRDQ+7vA8bi39DybICNbfIC3K8+gV8b9mEsXT
	ZS+MBUPXHwS4ge9lUxK/HiMbJ4qao7dIDiMM8yslFe5/C/IhSgsJzddUjAi4Kd3jnw5syn
	vQUY4oDzFv4/JK5g2+Vqevzn/J/VYMU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=fujitsu.com header.s=fj2 header.b="oPQar/6n";
	spf=pass (imf25.hostedemail.com: domain of ruansy.fnst@fujitsu.com designates 68.232.139.117 as permitted sender) smtp.mailfrom=ruansy.fnst@fujitsu.com;
	dmarc=pass (policy=reject) header.from=fujitsu.com
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1753410051; x=1784946051;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=N8TtpA7lzF4PbRiXLF8Toc0Ps0/E7V/1pJKfeLjZlEE=;
  b=oPQar/6nWC03IWXOA2ulwdkIhwu9kLLdewxIv2r6TeOSloXFbrl3BO+A
   q79YWj2WmA7MHFXTtxshWOV6TJZsQ4jknHc0AGRaubxIGwKPniWCxf1nU
   pooU0NEtHFItl6QS8WTn8+4xxVz0dNsXtVQpRnXHYt1HsjdPc4gbABt5l
   iYfHAsPtn4sBHyAXmEQ4va1y3IzX9zbiDmgkG7WNDDAUAlpDEuG3wlvBv
   VZDoN0Gj93sgTtXMot0als94mCWqccY+9QAbtrymrp5v5n8X3L/74an4o
   MUlo5kTd1RrlWCBlT7+9rXPkTb8iWyyUGFWvFk1q5m7U/np//2X0uLamg
   w==;
X-CSE-ConnectionGUID: 8/OFGOhvR1CXUpvf257zxA==
X-CSE-MsgGUID: G2l71faBQSuTElC8vbJA9A==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="207878009"
X-IronPort-AV: E=Sophos;i="6.16,338,1744038000"; 
   d="scan'208";a="207878009"
Received: from unknown (HELO az2uksmgr2.o.css.fujitsu.com) ([52.151.125.19])
  by esa4.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2025 11:20:50 +0900
Received: from az2uksmgm2.o.css.fujitsu.com (unknown [10.151.22.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmgr2.o.css.fujitsu.com (Postfix) with ESMTPS id 2BCEC8203FF
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 02:20:50 +0000 (UTC)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmgm2.o.css.fujitsu.com (Postfix) with ESMTPS id 9822418002DE
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 02:20:49 +0000 (UTC)
Received: from [192.168.22.105] (unknown [10.167.135.81])
	by edo.cn.fujitsu.com (Postfix) with ESMTP id B010D1A006C;
	Fri, 25 Jul 2025 10:20:44 +0800 (CST)
Message-ID: <982da1b2-0024-4c01-b586-02c0b8a41e95@fujitsu.com>
Date: Fri, 25 Jul 2025 10:20:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v3] mm: memory-tiering: Fix PGPROMOTE_CANDIDATE
 counting
To: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, lkp@intel.com,
 akpm@linux-foundation.org, y-goto@fujitsu.com, mingo@redhat.com,
 peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org,
 dietmar.eggemann@arm.com, rostedt@goodmis.org, mgorman@suse.de,
 vschneid@redhat.com, Li Zhijian <lizhijian@fujitsu.com>,
 Ben Segall <bsegall@google.com>
References: <20250722141650.1821721-1-ruansy.fnst@fujitsu.com>
 <87cy9r38ny.fsf@DESKTOP-5N7EMDA>
 <85d83be2-02f8-4ef6-91c7-ff920e47d834@fujitsu.com>
 <87wm7y3ur3.fsf@DESKTOP-5N7EMDA>
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
In-Reply-To: <87wm7y3ur3.fsf@DESKTOP-5N7EMDA>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7F274A0006
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 4mae5ct6hnq46dkz6qo55g5zxbq5ui3j
X-HE-Tag: 1753410051-410229
X-HE-Meta: U2FsdGVkX1+9JlpHcOytzMblMNULT82CcUm2zQhqRUpDYfdSfTMbU6m/aqmNULI8JgoZD5tg5eUj+mzMkMlh7GJ6AMK/lkLRQ3az7uhvkfqIUUrQ8JI2AaPhEuHyoH/bxRFbrPeWR+oll2FqfHEsGKYfsUuH42n72HoRIjzVyx58SPHAhtBwXyb/PQls7TWDh2t7dfjXQSVWdCY42lx4kjawKEAAAmcOMsMu17/xR0gavTPGCxUg2YYbqNXanT/L3nZHjg/aou1BDpP/EURQYl4iabEnJULWzFBgK5YgZni72yDOiLaDQ2rHoqzYyLwW6KEQ3ilDYMKk/XG2zgSfscdzJpVSs24oWgqTp8pxhzquGupDvIbOjsLUWXEvXbWRnZCc8hYmh6ScpJhLQ0fnPLM56ERtiQMlQIiv1zKDzfj2g34za2e6UREykXjjQ5WGQ9hfq6B0vZZC8YNeiV1p6y7AO78B6OmqBL02on+CrK41c25AzX+v2c1EVP43GiUrFgHJu2seTSDmLSGgISMYsHrLmkgIjZW9+DsmurmRtp45saLssNuNi+TqxcDPF1mVWNxZrKZzG3cJ+lrZI7eBEmHqoWdPL1wL24T0EQsXS2YsVnxO/gWzUrAxBbuxSCTJ6VIxbcxCIDsY/PIPtHqPDAMUuHdVdxkRNMbslTsltAnRy45hRGxD1jLsImvgkQhTWYlL7b/grcybjfAvIcIiKZvNHTij+RmeNcxGJBsguvSYbivYES/2ENYxHQrPqEqO/66StSi1kZ6CesvmlLwCkYIQCRgy+nGU2Aw2srnlj5SkBI+rY2KPQVA7mO7+XgNfc3EySl9I91aE8O7x2Jl+JAP35JPJoB0vnh7OE+nOw2crW8PRA5qM+S1cyb9JYIR7xy6N5o8YjdBX3bjrPnGhQx0iDnNbrdbyWqLZiQaMs3lUDHNFKhDyMiKaxk/rie4Qyn4UMEO1kjRfReUlROE
 rdIP8AuI
 BE1/DA6iDLsq8AA48lwmW9+6eXa+Rp5nEYpGepPdNhpRa9Ujy8sUL5aODp4Tao3vhwYaXhrvTR2j0MIjHwOz9M8uuZnbhZPJkt0KK2FY8PEuUlp07qqwK3Hbtt05VV0KLPpwEq2ezW/KDNWa2CzXGlWopn3pF3DNJ/Xp5K6Qxu+kH1FklG9k3DyMgi6+t9KQOlmxOjca8tniJW4QmAsgzbaked/lDudhK+18UNzChwmiocitzVfw3ig9z3QwrXxmgARwW8db3ZZGrEwTba1qfQTfnDqqKIxIZTs5+3qkJi2kOGxkMDTsPqlR5n01YAkcSVZN4NfJxlN4EW2VvuX/QY6i7OUfTOc7s2l0e1+fWIOqr+0dF3WwQZNRyjF7La7Zh2CHBBx4jprnyW90trUvEzio9m+Jnq6rXu82A2Igsqh+OZFf75N5/tkv2sHB5GXTHKjVg4kMSeRJK56wIBsmFtQphJfBMva0TzQpdzVip+0+lwiASEhaDF0MCg9BTNsDDi/xv6z0J8YiyoEKtwMTnm+lDC21yNqKOLmbT5pNZVqeBGFRexkxvEHSwwmKzVtFSriq6C0b/lJUCvP2Xnp/9I0gFQFTXX6kkvn92wbqGEpMd1+3R5H3fnbDFN+SXR03kqBf2RebRFHMT5+w5PJA76wjNNODblc/oOw3duBDMfzM+/zdN8n0yj7wNPDZM5q9MGMo6sOynnD2O+Xu3StUkXpe3E8THJWrrXvk6HHcsLh4zcwCB0z49kfTR98Hgbm84G3cBdKOpOKc1f320hSTNHynegQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2025/7/24 15:36, Huang, Ying 写道:
> Shiyang Ruan <ruansy.fnst@fujitsu.com> writes:
> 
>> 在 2025/7/23 11:09, Huang, Ying 写道:
>>> Ruan Shiyang <ruansy.fnst@fujitsu.com> writes:
>>>
>>>> From: Li Zhijian <lizhijian@fujitsu.com>
>>>>
>>>> ===
>>>> Changes since v2:
>>>>     1. According to Huang's suggestion, add a new stat to not count these
>>>>     pages into PGPROMOTE_CANDIDATE, to avoid changing the rate limit
>>>>     mechanism.
>>>> ===
>>> This isn't the popular place for changelog, please refer to other
>>> patch
>>> email.
>>
>> OK. I'll move this part down below.>
>>>> Goto-san reported confusing pgpromote statistics where the
>>>> pgpromote_success count significantly exceeded pgpromote_candidate.
>>>>
>>>> On a system with three nodes (nodes 0-1: DRAM 4GB, node 2: NVDIMM 4GB):
>>>>    # Enable demotion only
>>>>    echo 1 > /sys/kernel/mm/numa/demotion_enabled
>>>>    numactl -m 0-1 memhog -r200 3500M >/dev/null &
>>>>    pid=$!
>>>>    sleep 2
>>>>    numactl memhog -r100 2500M >/dev/null &
>>>>    sleep 10
>>>>    kill -9 $pid # terminate the 1st memhog
>>>>    # Enable promotion
>>>>    echo 2 > /proc/sys/kernel/numa_balancing
>>>>
>>>> After a few seconds, we observeed `pgpromote_candidate < pgpromote_success`
>>>> $ grep -e pgpromote /proc/vmstat
>>>> pgpromote_success 2579
>>>> pgpromote_candidate 0
>>>>
>>>> In this scenario, after terminating the first memhog, the conditions for
>>>> pgdat_free_space_enough() are quickly met, and triggers promotion.
>>>> However, these migrated pages are only counted for in PGPROMOTE_SUCCESS,
>>>> not in PGPROMOTE_CANDIDATE.
>>>>
>>>> To solve this confusing statistics, introduce this
>>>> PGPROMOTE_CANDIDATE_NOLIMIT to count the missed promotion pages.  And
>>>> also, not counting these pages into PGPROMOTE_CANDIDATE is to avoid
>>>> changing the existing algorithm or performance of the promotion rate
>>>> limit.
>>>>
>>>> Perhaps PGPROMOTE_CANDIDATE_NOLIMIT is not well named, please comment if
>>>> you have a better idea.
>>> Yes.  Naming is hard.  I guess that the name comes from the
>>> promotion
>>> that isn't rate limited.  I have asked Deepseek that what is the good
>>> abbreviation for "not rate limited".  Its answer is "NRL".  I don't know
>>> whether it's good.  However, "NOT_RATE_LIMITED" appears too long.
>>
>> "NRL" Sounds good to me.
>>
>> I'm thinking another one: since it's not rate limited, it could be
>> migrated quickly/fast.  How about PGPROMOTE_CANDIDATE_FAST?
> 
> This sounds good to me, Thanks!

Gemini 2.5 gave me a more radical name for it:

/*
  * Candidate pages for promotion based on hint fault latency. This counter
  * is used by the feedback mechanism to control the promotion rate and
  * adjust the hot threshold.
  */
PGPROMOTE_CANDIDATE,
/*
  * Pages promoted aggressively to a fast-tier node when it has sufficient
  * free space. These promotions bypass the regular hotness checks and do
  * NOT influence the promotion rate-limiter or threshold-adjustment logic.
  * This is for statistics/monitoring purposes.
  */
PGPROMOTED_AGGRESSIVE,

I think this one is concise and easy to understand with the comments. What do 
you think?  If this one is not appropriate, then I will go with "_NRL" as you 
suggested.


--
Thanks,
Ruan.

> 
> ---
> Best Regards,
> Huang, Ying
> 
>>
>>>
>>>>
>>>>
>>> The empty line is unnecessary.
>>
>> OK.>
>>>> Cc: Huang Ying <ying.huang@linux.alibaba.com>
>>> Suggested-by: Huang Ying <ying.huang@linux.alibaba.com>
>>
>> OK.
>>
>>
>> --
>> Thanks,
>> Ruan.
>>
>>>
>>>> Cc: Ingo Molnar <mingo@redhat.com>
>>>> Cc: Peter Zijlstra <peterz@infradead.org>
>>>> Cc: Juri Lelli <juri.lelli@redhat.com>
>>>> Cc: Vincent Guittot <vincent.guittot@linaro.org>
>>>> Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
>>>> Cc: Steven Rostedt <rostedt@goodmis.org>
>>>> Cc: Ben Segall <bsegall@google.com>
>>>> Cc: Mel Gorman <mgorman@suse.de>
>>>> Cc: Valentin Schneider <vschneid@redhat.com>
>>>> Reported-by: Yasunori Gotou (Fujitsu) <y-goto@fujitsu.com>
>>>> Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
>>>> Signed-off-by: Ruan Shiyang <ruansy.fnst@fujitsu.com>
>>>> ---
>>>>    include/linux/mmzone.h | 2 ++
>>>>    kernel/sched/fair.c    | 6 ++++--
>>>>    mm/vmstat.c            | 1 +
>>>>    3 files changed, 7 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
>>>> index 283913d42d7b..6216e2eecf3b 100644
>>>> --- a/include/linux/mmzone.h
>>>> +++ b/include/linux/mmzone.h
>>>> @@ -231,6 +231,8 @@ enum node_stat_item {
>>>>    #ifdef CONFIG_NUMA_BALANCING
>>>>    	PGPROMOTE_SUCCESS,	/* promote successfully */
>>>>    	PGPROMOTE_CANDIDATE,	/* candidate pages to promote */
>>>> +	PGPROMOTE_CANDIDATE_NOLIMIT,	/* candidate pages without considering
>>>> +					 * hot threshold */
>>>>    #endif
>>>>    	/* PGDEMOTE_*: pages demoted */
>>>>    	PGDEMOTE_KSWAPD,
>>>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>>>> index 7a14da5396fb..12dac3519c49 100644
>>>> --- a/kernel/sched/fair.c
>>>> +++ b/kernel/sched/fair.c
>>>> @@ -1940,11 +1940,14 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
>>>>    		struct pglist_data *pgdat;
>>>>    		unsigned long rate_limit;
>>>>    		unsigned int latency, th, def_th;
>>>> +		long nr = folio_nr_pages(folio);
>>>>      		pgdat = NODE_DATA(dst_nid);
>>>>    		if (pgdat_free_space_enough(pgdat)) {
>>>>    			/* workload changed, reset hot threshold */
>>>>    			pgdat->nbp_threshold = 0;
>>>> +			mod_node_page_state(pgdat, PGPROMOTE_CANDIDATE_NOLIMIT,
>>>> +					    nr);
>>>>    			return true;
>>>>    		}
>>>>    @@ -1958,8 +1961,7 @@ bool should_numa_migrate_memory(struct
>>>> task_struct *p, struct folio *folio,
>>>>    		if (latency >= th)
>>>>    			return false;
>>>>    -		return !numa_promotion_rate_limit(pgdat, rate_limit,
>>>> -						  folio_nr_pages(folio));
>>>> +		return !numa_promotion_rate_limit(pgdat, rate_limit, nr);
>>>>    	}
>>>>      	this_cpupid = cpu_pid_to_cpupid(dst_cpu, current->pid);
>>>> diff --git a/mm/vmstat.c b/mm/vmstat.c
>>>> index a78d70ddeacd..ca44a2dd5497 100644
>>>> --- a/mm/vmstat.c
>>>> +++ b/mm/vmstat.c
>>>> @@ -1272,6 +1272,7 @@ const char * const vmstat_text[] = {
>>>>    #ifdef CONFIG_NUMA_BALANCING
>>>>    	"pgpromote_success",
>>>>    	"pgpromote_candidate",
>>>> +	"pgpromote_candidate_nolimit",
>>>>    #endif
>>>>    	"pgdemote_kswapd",
>>>>    	"pgdemote_direct",
>>> ---
>>> Best Regards,
>>> Huang, Ying


