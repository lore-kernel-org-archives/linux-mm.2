Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFE8ECA0FF0
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 09:19:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FC676B0089; Fri, 29 Aug 2025 05:19:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D3F26B008A; Fri, 29 Aug 2025 05:19:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EA1C6B008C; Fri, 29 Aug 2025 05:19:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 09F0F6B0089
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 05:19:06 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7AB5B119396
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 09:19:05 +0000 (UTC)
X-FDA: 83829245850.09.FF85CF4
Received: from esa4.hc1455-7.c3s2.iphmx.com (esa4.hc1455-7.c3s2.iphmx.com [68.232.139.117])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3E164140003
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 09:19:03 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=fujitsu.com header.s=fj2 header.b=iASUqVi2;
	spf=pass (imf26.hostedemail.com: domain of ruansy.fnst@fujitsu.com designates 68.232.139.117 as permitted sender) smtp.mailfrom=ruansy.fnst@fujitsu.com;
	dmarc=pass (policy=reject) header.from=fujitsu.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756459143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a1UQwDwZIsizLFMqTAWP74xqht+w7tfODYGAttiUHxo=;
	b=nwDivJOv/6TMFnCFuGnfr55v3qHjHKToZ1yyWLuOrK5vYq44ed+jKTfN8+NHpreGg/PNUn
	XLAy0RMRXtiQ1cUE13csvallkD6xesbQrqqczB+wCxywl2YHpxmfhjHlPOBZaExc/Kn8F3
	nLBASU7kPS7e1BhRwvTKgj39k8SJCYk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=fujitsu.com header.s=fj2 header.b=iASUqVi2;
	spf=pass (imf26.hostedemail.com: domain of ruansy.fnst@fujitsu.com designates 68.232.139.117 as permitted sender) smtp.mailfrom=ruansy.fnst@fujitsu.com;
	dmarc=pass (policy=reject) header.from=fujitsu.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756459143; a=rsa-sha256;
	cv=none;
	b=S23cMhLuFlZXxkmdYHo48xNRUpGqbaZmqX0FkQg7bz5t03S6aDM3YpANQxbSKIXUFCSBcv
	mD7wWgZ1YRpRsDHdKCP8mWlbuJ32YT6x1Fl1J55C5FAIzxMGrNK8BQJ+LgPcKEkU/pbxhP
	tgCWwDPzGADeq87Dd8iQj6x6jCEy/Xo=
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1756459143; x=1787995143;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=9ZPMpcgc1IZqQe2khBwIzzgDVxe2HHh5Zmxc9x8f7/w=;
  b=iASUqVi2gChgrmqBtQivBF8nkNbl8r77ZT35ljrNbMHTT6zJW89qWhBI
   ARBby9vyTwkBmEl2AiG2NoFSqGzccQ/aOgzF/vuaBE3/fdx+0lNNm//fd
   Q6/SsW4+nwzHdKgc2Y0yks2ZbG2TLOP0Jfayog3wEOSxyuq9cISEttT36
   Pmm0vG+69CbtsjqvY3PZaAL+8iNG6r9+UAXeQ8z+90aOwztnt+5N9fOx6
   mniZE/++MYNobOvLI8++zBErGuvveMl9vj1GS84vEC/9nmYcLhyeL+KjU
   j8pCCTrHi5BKPyQGPeP6Hs0hPNSRm8x0NTEPgGxNJxoEnW5sCSgieO03h
   Q==;
X-CSE-ConnectionGUID: Zozxt7ncSRSFhGJ5KYRDIQ==
X-CSE-MsgGUID: CB9ZEVuhSUW06NSmeiy/ZA==
X-IronPort-AV: E=McAfee;i="6800,10657,11536"; a="211565947"
X-IronPort-AV: E=Sophos;i="6.18,221,1751209200"; 
   d="scan'208";a="211565947"
Received: from unknown (HELO az2uksmgr2.o.css.fujitsu.com) ([52.151.125.128])
  by esa4.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 18:19:01 +0900
Received: from az2uksmgm1.o.css.fujitsu.com (unknown [10.151.22.198])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmgr2.o.css.fujitsu.com (Postfix) with ESMTPS id AE17D820704
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 09:19:01 +0000 (UTC)
Received: from az2uksmom3.o.css.fujitsu.com (az2uksmom3.o.css.fujitsu.com [10.151.22.205])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmgm1.o.css.fujitsu.com (Postfix) with ESMTPS id 68E37843BC0
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 09:19:01 +0000 (UTC)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by az2uksmom3.o.css.fujitsu.com (Postfix) with ESMTPS id 5FC3E100928A;
	Fri, 29 Aug 2025 09:18:59 +0000 (UTC)
Received: from [192.168.22.105] (unknown [10.167.135.81])
	by edo.cn.fujitsu.com (Postfix) with ESMTP id D2B021A00E4;
	Fri, 29 Aug 2025 17:18:55 +0800 (CST)
Message-ID: <10659223-9bbe-468e-b458-ccd421590b7a@fujitsu.com>
Date: Fri, 29 Aug 2025 17:18:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] mm: memory-tiering: Fix PGPROMOTE_CANDIDATE counting
To: Vlastimil Babka <vbabka@suse.cz>, akpm@linux-foundation.org,
 linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, lkp@intel.com,
 ying.huang@linux.alibaba.com, y-goto@fujitsu.com, mingo@redhat.com,
 peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org,
 dietmar.eggemann@arm.com, rostedt@goodmis.org, mgorman@suse.de,
 vschneid@redhat.com, Ben Segall <bsegall@google.com>,
 Li Zhijian <lizhijian@fujitsu.com>
References: <20250729035101.1601407-1-ruansy.fnst@fujitsu.com>
 <23765f70-e869-4ef6-8ddd-24c0b1548fb2@suse.cz>
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
In-Reply-To: <23765f70-e869-4ef6-8ddd-24c0b1548fb2@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3E164140003
X-Stat-Signature: ajs8gpccyb4bf4dd3cj7apzrdagbowr6
X-Rspam-User: 
X-HE-Tag: 1756459143-723412
X-HE-Meta: U2FsdGVkX18qRT6R/NxaTlBxj0fKZC8wMyNmgqJiaF5Exnx+yLkprYwmklQAsJPcjdDJ9O//mutGw+/UfWDHmzWHzuYoXn939xi4DzpxFOrIZFFENyK5QRXvf5mvizEN1/IaK8Ab4gOLa8wgcY4Pg6CEFsG1/FI8FoWdjvnXreasG0kQKtZBfE7K5iEuyG23YYPjEpWYVBVIPiyOB+QObBgqtiHeceWobleTCUkrmSrvFzI1otaUivCYMcc4LuNu+sOAeh5N6XFsktyGuUYKL42uo1u+sAWIqc/mgJQy583aD1kaKXCvi5ELlpm23TqNEIcOv4hG4o8kVMeHV9sZ9NkIy6Hp/cSYV80k9BfGXzdaeb8OkeR/RF2jjU7kYno52JLL0CQ6OjXXrJvAjrWV0ww8XKNttKRa8L75nNyVSFHrZN7Ges6bV5QuhToBAMj+J0roG9X+mI+TKsdH96S2wndWuwg9zGyBONRoLoCYGDbgTmHN3b8uAjjuQMeSsCpUqoGtRYYF1/nmHlpmCYbJEukjfbYxYJ+/ctZRiHf7161nVYn2ns6+OXiOfUw695KeXsEpt/RgMiJn4KCTessMTR9awQN5EG4er7WbarFMTfBsu2q0NeIgpe1rRuZ8aJtwwG1fP45Fo4sy/w0mZGhjjcf7VKzpfTGORWHJdUk8XHNZrxAxqKZej4p/FoNYMmqe652w5bOcEtZ7+pfrFoEgNcMqy+NmUVbQbYmTTmwrjZ/EsryWVoiCuE9kSUARiXPyNEHMO8qTyZLmiCsp+SVyEGYQB0OJxKhCalj/SqlXkF5P9s1iRAy1F9ZbDumlciy6ScvFRmIzjyj4JW1X2pMbax6I5nGTQ9AsWgpsUfP/QRhu7FeN7jhOXArU2vT2Vuf5RA26BNkJm8k6b3548unFK4EuAMi2PfLibPW5GDf9r2A010JJnyNZLsoX4QR7gQAjrXzDh3X9Nasj6QhOFsT
 UyJ+9Nct
 aXwkfhOtwdbAsonWD5OyYB6K3yovhGoZK9DoC45VblQbSOTX6NoINFXNvfEgRUQVHmjIZdmIw71452Xsks9QCbG8njUQeCjkwEfwTqhRVGu6sA9PDad0AL29Tq1KH0K6BNjRLMntNt5nHkU11btobuZbWMEhtgZwCRv6+ImxN05vmvn0V81yQYA0822zkPEFLWJGBTG/2O4hapAJ+X1y4wl/+x4Emeod4tQom5ts7MzhYVGMnqFLY04Gxh5n5lftqkHK8AU0ObHqOon65a+mPjiMhDfpuCHA3IRos/9KTNWmvT9XUfNIdItOal6wNRhuCsc/6Jzsat4vuZoBLVvA6z3Wl1qrkZwWH3KOU3mQOBk0lY7Dx1/QnOhPQoTN9WeY6AO0pKTWjvv2gld6L+XTrENoOtfv/yfAHy/TGdp12QuFoZCTLatBFKmiB+K7TRciZG1MXbIgAEc5JS8qM/j17Z4p/DSWGyv3uooM6v7e4vLfCtpYLDVrIC2+Jvyo50NNNPeUfA+0pzsHfM394dvAVj8AWpw+lK2A41Z0C2qEqFhtlEbgdinQmRPXCvlN/lK3X/KIyRu5y/ADVT3npK5hrGYozGCzWns8Xl0teM+ExYiV8qpyeb3jQkXXwXTawAGJzHAihrR4U4Q6gDWDFiw4TOY397OgDVzc7ZP4GxoEapVJ3tdKqLhcWcDcdz9ep6OArjkt8kHjUFoi3qYkYlejcel9KtJi/FdVlkr18
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2025/8/29 17:08, Vlastimil Babka 写道:
> On 7/29/25 05:51, Ruan Shiyang wrote:
> 
> A process nit: your RFC v3 had:
> 
> From: Li Zhijian <lizhijian@fujitsu.com>
> 
> and this one doesn't.
> 
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
>> To solve this confusing statistics, introduce this PGPROMOTE_CANDIDATE_NRL
>> to count the missed promotion pages.  And also, not counting these pages
>> into PGPROMOTE_CANDIDATE is to avoid changing the existing algorithm or
>> performance of the promotion rate limit.
>>
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
>> Suggested-by: Huang Ying <ying.huang@linux.alibaba.com>
>> Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
> 
> So the S-o-b from Li doesn't match anything now.
> You can either reinstate that "From: Li ..." or add a "Co-developed-by: Li
> ..." right above the "S-o-b: Li ..." - that's for you two to decide who is
> the main author.

Thanks for pointing out.  I wasn't aware of this.

I'd like to add a Co-developed-by tag:

Co-developed-by: Li Zhijian

Then, should I resend a new version with is tag added?  Or you will do that for me?


--
Best regards,
Ruan.

> 
> More details in Documentation/process/submitting-patches.rst
> 
>> Signed-off-by: Ruan Shiyang <ruansy.fnst@fujitsu.com>
>> ---
>> Changes since RFC v3:
>>    1. change the naming of new added stat to PGPROMOTE_CANDIDATE_NRL.
>>    2. improve the description of the two stats.
>> ---
>>   include/linux/mmzone.h | 16 +++++++++++++++-
>>   kernel/sched/fair.c    |  5 +++--
>>   mm/vmstat.c            |  1 +
>>   3 files changed, 19 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
>> index 283913d42d7b..4345996a7d5a 100644
>> --- a/include/linux/mmzone.h
>> +++ b/include/linux/mmzone.h
>> @@ -230,7 +230,21 @@ enum node_stat_item {
>>   #endif
>>   #ifdef CONFIG_NUMA_BALANCING
>>   	PGPROMOTE_SUCCESS,	/* promote successfully */
>> -	PGPROMOTE_CANDIDATE,	/* candidate pages to promote */
>> +	/**
>> +	 * Candidate pages for promotion based on hint fault latency.  This
>> +	 * counter is used to control the promotion rate and adjust the hot
>> +	 * threshold.
>> +	 */
>> +	PGPROMOTE_CANDIDATE,
>> +	/**
>> +	 * Not rate-limited (NRL) candidate pages for those can be promoted
>> +	 * without considering hot threshold because of enough free pages in
>> +	 * fast-tier node.  These promotions bypass the regular hotness checks
>> +	 * and do NOT influence the promotion rate-limiter or
>> +	 * threshold-adjustment logic.
>> +	 * This is for statistics/monitoring purposes.
>> +	 */
>> +	PGPROMOTE_CANDIDATE_NRL,
>>   #endif
>>   	/* PGDEMOTE_*: pages demoted */
>>   	PGDEMOTE_KSWAPD,
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index 7a14da5396fb..4022c9c1f346 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -1940,11 +1940,13 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
>>   		struct pglist_data *pgdat;
>>   		unsigned long rate_limit;
>>   		unsigned int latency, th, def_th;
>> +		long nr = folio_nr_pages(folio);
>>   
>>   		pgdat = NODE_DATA(dst_nid);
>>   		if (pgdat_free_space_enough(pgdat)) {
>>   			/* workload changed, reset hot threshold */
>>   			pgdat->nbp_threshold = 0;
>> +			mod_node_page_state(pgdat, PGPROMOTE_CANDIDATE_NRL, nr);
>>   			return true;
>>   		}
>>   
>> @@ -1958,8 +1960,7 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
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
>> index a78d70ddeacd..bb0d2b330dd5 100644
>> --- a/mm/vmstat.c
>> +++ b/mm/vmstat.c
>> @@ -1272,6 +1272,7 @@ const char * const vmstat_text[] = {
>>   #ifdef CONFIG_NUMA_BALANCING
>>   	"pgpromote_success",
>>   	"pgpromote_candidate",
>> +	"pgpromote_candidate_nrl",
>>   #endif
>>   	"pgdemote_kswapd",
>>   	"pgdemote_direct",
> 


