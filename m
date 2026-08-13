Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97019C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 17:15:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66D836B055A; Thu, 13 Aug 2026 13:15:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61EB06B055B; Thu, 13 Aug 2026 13:15:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 533FF6B055C; Thu, 13 Aug 2026 13:15:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 30DCC6B055A
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 13:15:11 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BC9D280216
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 17:15:10 +0000 (UTC)
X-FDA: 85096896780.02.4A0B063
Received: from mta0.migadu.com (out-151.mta0.migadu.com [91.218.175.151])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7D220C000A
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 17:15:08 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YA7ZfcUJ;
	spf=pass (imf28.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.151 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786641308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pTLxQstLkB4+RKAm8Qn/u/Sbo0fsNC8qLPC1ltU8D4k=;
	b=aiTJweem1JQ3e1u5TDMoDq6PVJLKG6wo9hoG5KXRTPaJrKdcDeE5z7tmwyBGy794HXynhc
	MEpvpW7AuOOCkVoDnCFjTCpwB8a0GiF7MIZNi+4v+peaZQnvDS0mYooHkcRLY+bcygYdJ4
	S/okqfaEfujzYDyxQ8owlk2Mnr+y0lU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YA7ZfcUJ;
	spf=pass (imf28.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.151 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786641308;
	b=jwcFVxke2/7TSGaV3fAX4xQFdvf/uptyFmD/c9BbTp08i65/xzk3wQBggJLYiXZtkMhCFf
	k6W11V2c1pgG+MuwIAZ+He+NZlUr42N25kMmfy5fmp89qtcuTI6PgBRFTKYwQghs1eJsY3
	Fz4yMnu9nJy3UGIQsJS4tG9SBbsO8k8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Yec5Wj8ZUY9zXGuHPs7l8wD80d+XYwicM6WJm2aA3IY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786641307; v=1; x=1787246107;
 b=YA7ZfcUJa2liuDoGBWGG+/y0Iv+PY4Q13Hgtd/L0Hl6Phnrqy6mjVyTCAnNtxVhfAWXwmqNU
 lKrIBlDTJq9K2icM7myrhlDxbmYs0Vy7wtFHm/nd04iIR08a2KnOja5fT1xl7pq1bPJPhuNM4l0
 f5U922JvjCfjbskRa2bRhaYA=
X-Envelope-To: linux-mm@kvack.org
Received: from [IPV6:2a03:83e0:1126:4:9d:a05e:5bd8:c200] (2620:10d:c092:500::6:def8)
	by smtp.migadu.com with ESMTPS id de41cf8ec9c54807;
	Thu, 13 Aug 2026 17:14:57 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <017721a3-5eae-449e-8b86-75cffb503dd3@linux.dev>
Date: Thu, 13 Aug 2026 18:14:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [linux-next:master] [mm/vmpressure] ea928e9e18:
 stress-ng.mremap.ops_per_sec 36.2% regression
To: Shakeel Butt <shakeel.butt@linux.dev>,
 kernel test robot <yi1.lai@intel.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Michal Hocko <mhocko@suse.com>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, linux-mm@kvack.org,
 cgroups@vger.kernel.org
References: <202608131743.c6a7dda4-lkp@intel.com> <an34C2N-yqfok2Nn@linux.dev>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <an34C2N-yqfok2Nn@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 7frzd8oo4qprc6qow78t369ruyke7zcj
X-Rspamd-Queue-Id: 7D220C000A
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786641308-103054
X-HE-Meta: U2FsdGVkX1/CiIvlz6bMya7CYvHJt7hwvRVyD4Iww+2uclsp3eJg8pPlUkaf2sLAJLNMRMyLONsQLWfESLNyiHGqZLVH18CTP1SRpieIyssdi+t9K0uBKukPC8uzMF0K0gXutDZ3XDXsg5z5yBP3CtO4+fxb3gC0mkpcfeI//DRiGGMKMY9UIYmSt/wngh7MyQ57swpqAIBN11fWZh0qVWka9+UvEWIZDS4qairRIiPZMrV19CTkwDluAnP7EgXUEePYXiqw6DpAB9SeK1qLwJzpFWyXGzO5UaSDgHA3Ytu1vWh6Ke9hrWWp3m9KfHGnW+rhs60p7+O7uBbDUfjhRgLl+KjVyARP1/EVicP9UI4N3US+Fe86nHwzJr81vR+2pnBj0OV1nHRHg02WQAR/3cUxedmKFWBWu3q/XlKx14wH1/4FyKa3mvgF8TBTogJgZDj68WkGr67Z2pR23vrq9V1TQe3bSXlCShTyutZgPAMRW63cbd5N3QApSfpMOFYkQEgJsY7WSyBgPgq3+hV8Nd5nXwPge7TJdr0h9qi0MOn9Y97465YdobI1JIZYVcVupKlEDucsy8Tc1mFZ39E5S+n823a0C4ktvYh4G9FicLaMvedu2LVXOhoKJDyPXv6voCtK3EWgh5k30K4dXv+cetYh1ZH4U2TQvCqSjORVQtcM047D9ONWO4UOro8Zck21f7rVQhRVyQQ6PMwJdVDUMfD/UJ9OpvdT4Yg90M/lhd6CnlZonuicmPufkhmDsDEmjp3kPB9IpauohqQcTAOwm7p8oCNeLl/HrYKbe+5mX/Au6chx25GwFxO6t8Bw64tC2v61nj1V/JWGeuZo+4Bj4LawS07s8beyIJ52VYuGBtEaOhtRiFc1Va+y4dudEc6IOITwgGi4DU3e+HQsI4xnRQu2agbO7dfmJhEZ2WwKtj3iRYIubxCLABJ3iSJDAWF9icBfP9/z9WOvo0Cb5y4
 Qrug1wVn
 ZJeiBG+iWOxycXDLBydBG0FZcHuRonLp3rI5qXVolGAf9LEeBZj/+xe0ztsDCun+BAaZG6YjzdFZuimyoZa/GHhcSD7Pvyz+dC/gsHw4NSzgiYNeSximvjMZ3wSJDun7q+GZtRkHnDjx5a6Kp8RG0j2pbhNXifGIYQzHANDworJErTCSasPGyeQehfWBnffq8sPJIU6EQ6pvbK/ArRPzom+rzN6GTLJ/KQ1Xj1/kveu4laiWfaCo4pc6W3hayqx7IWBbopI9zhp19MDVAeaqWnntJ+FBpPoxwuoLnYazX4IXZqazXy7KWZ4HP3+GFVXRHmc6EpwYJJEw/GmMX3KXxmROB6hq4yDzyfIVRzNH/g0Fd2fByp2ZZjjGPrQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 13/08/2026 18:01, Shakeel Butt wrote:
> On Thu, Aug 13, 2026 at 09:16:22PM +0800, kernel test robot wrote:
>>
>>
>> Hello,
>>
>> kernel test robot noticed a 36.2% regression of stress-ng.mremap.ops_per_sec on:
>>
>> commit: ea928e9e18da682e9a5bc40aa862bff7ce5ae42e ("mm/vmpressure: move v1 userspace eventfd code into memcontrol-v1.c") https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master
>>
>> in testcase: stress-ng
>> version: stress-ng-x86_64-29ce10a2c-1_20260712
>> with following parameters:
>>
>> 	nr_threads: 100%
>> 	testtime: 60s
>> 	test: mremap
>> 	cpufreq_governor: performance
>>
>>
>>
>> config: x86_64-rhel-9.4 (CONFIG_MEMCG=y and CONFIG_MEMCG_V1 is not set)
>> compiler: gcc-14
>> test machine: 256 threads 4 sockets INTEL(R) XEON(R) PLATINUM 8592+ (Emerald Rapids) with 256G memory
>>
>> (please refer to attached dmesg/kmsg for entire log/backtrace)
>>
> 
> Hi there,
> 
> Can you please test the following patch and see if it fixes the regression?
> 
> 
> From 84c0b05b3bc5cf73ee66ead75aafb1ad684462c3 Mon Sep 17 00:00:00 2001
> From: Shakeel Butt <shakeel.butt@linux.dev>
> Date: Thu, 13 Aug 2026 09:38:28 -0700
> Subject: [PATCH] memcg: keep vmstats_percpu off the memory_events[] cacheline
> 
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> ---
>  include/linux/memcontrol.h | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index e78bc98ab229..e25d5b9a1db8 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -246,8 +246,13 @@ struct mem_cgroup {
>  	/* handle for "memory.swap.events" */
>  	struct cgroup_file swap_events_file;
>  
> -	/* memory.stat */
> +	/* Read-mostly. */
>  	struct memcg_vmstats	*vmstats;
> +	struct memcg_vmstats_percpu __percpu *vmstats_percpu;
> +	int			kmemcg_id;
> +
> +	/* Write-hot from here on; do not let it share with the above. */
> +	CACHELINE_PADDING(_pad_);
>  
>  	/* memory.events */
>  	atomic_long_t		memory_events[MEMCG_NR_MEMORY_EVENTS];
> @@ -266,9 +271,6 @@ struct mem_cgroup {
>  #if BITS_PER_LONG < 64
>  	seqlock_t		socket_pressure_seqlock;
>  #endif
> -	int kmemcg_id;
> -
> -	struct memcg_vmstats_percpu __percpu *vmstats_percpu;
>  
>  #ifdef CONFIG_CGROUP_WRITEBACK
>  	struct list_head cgwb_list;


I was currently testing this diff, not sure which one would be better.

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index e78bc98ab229b..215e2e87f42b2 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -268,10 +268,15 @@ struct mem_cgroup {
 #endif
        int kmemcg_id;

-       struct memcg_vmstats_percpu __percpu *vmstats_percpu;
-
 #ifdef CONFIG_CGROUP_WRITEBACK
        struct list_head cgwb_list;
+#endif
+
+       /* Keep the hot per-CPU stats pointer away from memory event counters. */
+       struct memcg_vmstats_percpu __percpu *vmstats_percpu
+               ____cacheline_aligned_in_smp;
+
+#ifdef CONFIG_CGROUP_WRITEBACK
        struct wb_domain cgwb_domain;
        struct memcg_cgwb_frn cgwb_frn[MEMCG_CGWB_FRN_CNT];
 #endif


