Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FB6DC83F17
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 02:39:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25FB56B017E; Wed, 23 Jul 2025 22:39:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20FD96B019D; Wed, 23 Jul 2025 22:39:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FEDB6B019E; Wed, 23 Jul 2025 22:39:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E76B66B017E
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 22:39:50 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0BC50C0278
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 02:39:50 +0000 (UTC)
X-FDA: 83697602940.05.1C1CB53
Received: from esa10.hc1455-7.c3s2.iphmx.com (esa10.hc1455-7.c3s2.iphmx.com [139.138.36.225])
	by imf05.hostedemail.com (Postfix) with ESMTP id A5097100009
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 02:39:47 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=fujitsu.com header.s=fj2 header.b=NcLw+OPk;
	spf=pass (imf05.hostedemail.com: domain of ruansy.fnst@fujitsu.com designates 139.138.36.225 as permitted sender) smtp.mailfrom=ruansy.fnst@fujitsu.com;
	dmarc=pass (policy=reject) header.from=fujitsu.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753324788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LVI4ui27shb45WBw7de/2FLoBAEccuHo9aQTcjGPAgE=;
	b=8R+ytn5ILM+KvF05jA3sAWfOR3Pxz7Y34EQ3qRbdjbnIzBxsFtxPGOmrUgeNVrSJ4GRQzu
	NUfHbiuCz+qSnwst80L1GbWCJhDMNHrHxUhpEqlm3yExrPMLrJyqUqgnz5WqEZi4+IyGff
	ftDL94Vb5VMv62m2e2uIyU3BqOUEl14=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753324788; a=rsa-sha256;
	cv=none;
	b=va7S1b2XvvZyIfa4/vkaY3PRIuK5MZ2kUBNCvg27MI+LEiJ63LiUb1/U/oF9F9S6HkL41C
	w89NFaLwC208he1blC1EqczIHN99CBOAoR0F5CjKO9XfIsbXmujGZERZAwZbl8o3mb7fiI
	tFphR7LuI7N3Y/SM1TL15k01zAjFo/A=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=fujitsu.com header.s=fj2 header.b=NcLw+OPk;
	spf=pass (imf05.hostedemail.com: domain of ruansy.fnst@fujitsu.com designates 139.138.36.225 as permitted sender) smtp.mailfrom=ruansy.fnst@fujitsu.com;
	dmarc=pass (policy=reject) header.from=fujitsu.com
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1753324787; x=1784860787;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=uPlh/YWX4gV2j+/e8PX8tFDcfpt6QXFzRYCQvBZYddQ=;
  b=NcLw+OPkkRJRxiKp64GCn0XgSvqjs/weyr82CzGG7yVG/fs9XZ/6EU0Y
   5Crk+FqUsplyqupffEorX40w/x/ThE545P9KWAhJ9geTeVT+ONQ3ATdld
   RM6DDtAZWVByt3iv983NoJWm1mgDXLazndJGRAGwSYA/wGGFXUNUCfQ4R
   0SxGj/FST1sYrujV+mdz4xgdXy3ruZkX9laslDvQl+gwwAyam2pgMvv1b
   epUWSADUKK+pGYMePgzKpnKdZooN30YvbB9aLGbCR9YdkX2JtO+OHtkHF
   7E3k9R6lxl+GIDgaXSxJ6ry0//OabBmWvQiaruCD+ceQfwPvFYm2evdCz
   g==;
X-CSE-ConnectionGUID: ccaXRW36Tu6H7X6EGdxkbA==
X-CSE-MsgGUID: xbGCOWLjTAGb8fDZhpczjg==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="194633409"
X-IronPort-AV: E=Sophos;i="6.16,336,1744038000"; 
   d="scan'208";a="194633409"
Received: from unknown (HELO az2nlsmgr1.o.css.fujitsu.com) ([20.61.8.234])
  by esa10.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 11:39:46 +0900
Received: from az2nlsmgm2.o.css.fujitsu.com (unknown [10.150.26.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmgr1.o.css.fujitsu.com (Postfix) with ESMTPS id 2F3731C000A1
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 02:39:46 +0000 (UTC)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmgm2.o.css.fujitsu.com (Postfix) with ESMTPS id 9497F1C00167
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 02:39:45 +0000 (UTC)
Received: from [192.168.22.105] (unknown [10.167.135.81])
	by edo.cn.fujitsu.com (Postfix) with ESMTP id C9EC11A000B;
	Thu, 24 Jul 2025 10:39:40 +0800 (CST)
Message-ID: <85d83be2-02f8-4ef6-91c7-ff920e47d834@fujitsu.com>
Date: Thu, 24 Jul 2025 10:39:40 +0800
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
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
In-Reply-To: <87cy9r38ny.fsf@DESKTOP-5N7EMDA>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A5097100009
X-Stat-Signature: qadyw14yeire5eafyubzabyndq7dzeyu
X-Rspam-User: 
X-HE-Tag: 1753324787-846220
X-HE-Meta: U2FsdGVkX1/NgUlUrLcaZre//6RDIQemPEKTYZVJ2jcBnspNuBNkOp7qcJvWDYaKN5gaUyYAzIJ/29wF/iA2Ryf8dhFVa7gu2+SOP+cmHWL7wGK1yzt91dgii38UYaKJtNIIjkpD3w90bQw0fQ2eowPrGRMqPnTyaMkogVKznZ2gosSvZ28SIF/OcGMvCkdtnpu11ZteFRec/zn6tGhtaVL8uXdpKE27ZQWoa80mSw2MsFxgU83VM5ZHV8OIdrKU10hnVx04whqd4NOxGAO7FGmySFLAcv6uXayEAEUHRj0q7lFUthBA7Mrsu0Y4nLsU2Q6eE2xwxUtCyb0X7BRmQsUHELrxMQSqR/mdwDPcN4G94wgnmHGI1ZM33oNeHEWB/gs3CangE7KMjKoWWJUaDKanA5T712sS2U9ad2krQhCeHXuPGTZZA7YSV5eappy3d5QaS1DXRMP2Nfl96QuP0MTLM2VkNRR69nIR8tyjp4XJ84ECBHupi6JFpAUqtwE8IRzUc+LYhKEvDbRlnwEkCxNM3Dt1cbGkA6UH47ID8+D2fdD/KJD67RmmHcezg9T2eUBA/WJnVRfpH8Fj4E/y193TBycLcyDRUb+abSeptnhkhpBNlmElDDMtrhcPWdb3Xo3nxwpvVowgnm2o/A7MWW1iHxNBtnUHTnbkncYPz9tzaZNQh449PzDScuM86d04JmDG89pZunW8mED+rHPDeJsySzK7CnFJPISGg+klCwFd9DgODWmLv2ACBZ0HgeQ+Q+XuUqyQE/RlxtGfkpcgpWHMSfOjoQSC+Lwwce+Hy0EXjYUZVNCPhA+E2HA93SSsxBV8Oa9CCMiT1pRiNHInltkFjw7J7raqY1kxUCfIlZjuVk8WWTwuUBGhp3An8zRzCEZomrQxDRG+Ylck+zcZLCcHgAXhROyJ3hZaBS7TLkWCbdPoyajhMU9FSmTRkimav4XX2+0ITkCSCdIesiH
 2PyXU+4u
 N3iMMEFx2NInNsRurwkd+tSKOFfqkw4wJjSbcEgKx9/Xizn/NPa58Xriw3AXGsQdcWKtyrk4ygBM8oJrwGNXW4bo3oN0QtLqV+hOTmV3hEkR6w7BoBW7MMVGJRcg29HtiDSwxi/fQ2698fc0ZhudK9A24lVt2iOAvr3as+0Eew9szniHnELeYaIQXAspzT7RW3Y7y36Ra5fRf7iILehb2EbJa8pEYaqLI9m4wEBCs9pMJ6+dOHfR6De/WoW4yVjuTlGb0/ty/66lT+5WfuJKK4CehDWJBuX53QHlljCwdqEyzNQwozb3duEhboHTYtzy47zwVxtP/ZN4ThAfdO5sEbIU2MT5x8wraQgekCp8PO+mGz9LCUdOCIIJ+k2hrDDKzUPfOR2d1FDYBPr8Esu/N6W1FyN/C1lk5c/wXEZpgDyUTMHISqGzfycejDAu1MWzgMsXvDrndUy1p5QBRg095dyAb7vcrKXQLSKRy12+ddZNB1xXM3TAs2+g7dYh9beriaGeMYpQJOF9UqQZQ9GIcCWNWOSylysgzu6H/GG8dg3QN85Tjg9UmnmppYtw9pEpnYWgFcLEwkN+mMnY379qRs7zX44/rP5CD9eZR0dlwxvvLk+XqsKJZBGI98KKPbJQbUmS3oCBocDCsFya3C53oGK0g430rauSjXXVMts57fFzTVBDl54VRhWgy7B/PmX1SqUwxrNOXhKyWPBSqOqR2UpTqv8FZTCiet4DGVwRgOyM6x+vVbOXTKQ8EGfVw5IdcQZGFohdYxZD8QdpS1uKO9n0tRA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2025/7/23 11:09, Huang, Ying 写道:
> Ruan Shiyang <ruansy.fnst@fujitsu.com> writes:
> 
>> From: Li Zhijian <lizhijian@fujitsu.com>
>>
>> ===
>> Changes since v2:
>>    1. According to Huang's suggestion, add a new stat to not count these
>>    pages into PGPROMOTE_CANDIDATE, to avoid changing the rate limit
>>    mechanism.
>> ===
> 
> This isn't the popular place for changelog, please refer to other patch
> email.

OK. I'll move this part down below.>
>> Goto-san reported confusing pgpromote statistics where the
>> pgpromote_success count significantly exceeded pgpromote_candidate.
>>
>> On a system with three nodes (nodes 0-1: DRAM 4GB, node 2: NVDIMM 4GB):
>>   # Enable demotion only
>>   echo 1 > /sys/kernel/mm/numa/demotion_enabled
>>   numactl -m 0-1 memhog -r200 3500M >/dev/null &
>>   pid=$!
>>   sleep 2
>>   numactl memhog -r100 2500M >/dev/null &
>>   sleep 10
>>   kill -9 $pid # terminate the 1st memhog
>>   # Enable promotion
>>   echo 2 > /proc/sys/kernel/numa_balancing
>>
>> After a few seconds, we observeed `pgpromote_candidate < pgpromote_success`
>> $ grep -e pgpromote /proc/vmstat
>> pgpromote_success 2579
>> pgpromote_candidate 0
>>
>> In this scenario, after terminating the first memhog, the conditions for
>> pgdat_free_space_enough() are quickly met, and triggers promotion.
>> However, these migrated pages are only counted for in PGPROMOTE_SUCCESS,
>> not in PGPROMOTE_CANDIDATE.
>>
>> To solve this confusing statistics, introduce this
>> PGPROMOTE_CANDIDATE_NOLIMIT to count the missed promotion pages.  And
>> also, not counting these pages into PGPROMOTE_CANDIDATE is to avoid
>> changing the existing algorithm or performance of the promotion rate
>> limit.
>>
>> Perhaps PGPROMOTE_CANDIDATE_NOLIMIT is not well named, please comment if
>> you have a better idea.
> 
> Yes.  Naming is hard.  I guess that the name comes from the promotion
> that isn't rate limited.  I have asked Deepseek that what is the good
> abbreviation for "not rate limited".  Its answer is "NRL".  I don't know
> whether it's good.  However, "NOT_RATE_LIMITED" appears too long.

"NRL" Sounds good to me.

I'm thinking another one: since it's not rate limited, it could be 
migrated quickly/fast.  How about PGPROMOTE_CANDIDATE_FAST?


> 
>>
>>
> 
> The empty line is unnecessary.

OK.>
>> Cc: Huang Ying <ying.huang@linux.alibaba.com>
> 
> Suggested-by: Huang Ying <ying.huang@linux.alibaba.com>

OK.


--
Thanks,
Ruan.

> 
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Cc: Juri Lelli <juri.lelli@redhat.com>
>> Cc: Vincent Guittot <vincent.guittot@linaro.org>
>> Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> Cc: Ben Segall <bsegall@google.com>
>> Cc: Mel Gorman <mgorman@suse.de>
>> Cc: Valentin Schneider <vschneid@redhat.com>
>> Reported-by: Yasunori Gotou (Fujitsu) <y-goto@fujitsu.com>
>> Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
>> Signed-off-by: Ruan Shiyang <ruansy.fnst@fujitsu.com>
>> ---
>>   include/linux/mmzone.h | 2 ++
>>   kernel/sched/fair.c    | 6 ++++--
>>   mm/vmstat.c            | 1 +
>>   3 files changed, 7 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
>> index 283913d42d7b..6216e2eecf3b 100644
>> --- a/include/linux/mmzone.h
>> +++ b/include/linux/mmzone.h
>> @@ -231,6 +231,8 @@ enum node_stat_item {
>>   #ifdef CONFIG_NUMA_BALANCING
>>   	PGPROMOTE_SUCCESS,	/* promote successfully */
>>   	PGPROMOTE_CANDIDATE,	/* candidate pages to promote */
>> +	PGPROMOTE_CANDIDATE_NOLIMIT,	/* candidate pages without considering
>> +					 * hot threshold */
>>   #endif
>>   	/* PGDEMOTE_*: pages demoted */
>>   	PGDEMOTE_KSWAPD,
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index 7a14da5396fb..12dac3519c49 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -1940,11 +1940,14 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
>>   		struct pglist_data *pgdat;
>>   		unsigned long rate_limit;
>>   		unsigned int latency, th, def_th;
>> +		long nr = folio_nr_pages(folio);
>>   
>>   		pgdat = NODE_DATA(dst_nid);
>>   		if (pgdat_free_space_enough(pgdat)) {
>>   			/* workload changed, reset hot threshold */
>>   			pgdat->nbp_threshold = 0;
>> +			mod_node_page_state(pgdat, PGPROMOTE_CANDIDATE_NOLIMIT,
>> +					    nr);
>>   			return true;
>>   		}
>>   
>> @@ -1958,8 +1961,7 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
>>   		if (latency >= th)
>>   			return false;
>>   
>> -		return !numa_promotion_rate_limit(pgdat, rate_limit,
>> -						  folio_nr_pages(folio));
>> +		return !numa_promotion_rate_limit(pgdat, rate_limit, nr);
>>   	}
>>   
>>   	this_cpupid = cpu_pid_to_cpupid(dst_cpu, current->pid);
>> diff --git a/mm/vmstat.c b/mm/vmstat.c
>> index a78d70ddeacd..ca44a2dd5497 100644
>> --- a/mm/vmstat.c
>> +++ b/mm/vmstat.c
>> @@ -1272,6 +1272,7 @@ const char * const vmstat_text[] = {
>>   #ifdef CONFIG_NUMA_BALANCING
>>   	"pgpromote_success",
>>   	"pgpromote_candidate",
>> +	"pgpromote_candidate_nolimit",
>>   #endif
>>   	"pgdemote_kswapd",
>>   	"pgdemote_direct",
> 
> ---
> Best Regards,
> Huang, Ying


