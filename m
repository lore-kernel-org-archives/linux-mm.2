Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2014E83F05
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 05:20:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFB666B0098; Thu,  5 Feb 2026 00:20:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7E5E6B0099; Thu,  5 Feb 2026 00:20:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97D706B009B; Thu,  5 Feb 2026 00:20:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8631C6B0098
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 00:20:16 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 244B41403C5
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 05:20:16 +0000 (UTC)
X-FDA: 84409252032.05.9A38014
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id F2026140003
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 05:20:13 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770268814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9uY7IFXdI+/p4NvZJLEjyCsaZZAaXakkdr9MfNqK/bo=;
	b=RBda2qY2RHq+8fIC2BgsRJvw1QXY5PpftsuLCgtjWCWfD25/wI70PYWee10MUoOrnz6nSV
	MmdIMYbMfKjkLdhZgciN3Pto8Kzeu89T3JMcede7fHgRu4ccns3S0Yrpl4zlI4QkzOT7WM
	MAnDtdXv0X6ij1Vu1pbkKVgNq5tfyZc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770268814; a=rsa-sha256;
	cv=none;
	b=PSdGR2JyUn9zoSEJTDoZ4xDBiluQ6psMzuPb8AcwV6Wo3m+9XEntw0P6l00/rGLN3OXreK
	UOWlGY1SVgwT82eK90lfovXJlrg9YdZn2dgsEOuGSTsOG1reC3Tcee6a+zpaCux7U0qrI5
	g7PVnoUd9jQUPUFJ+Mmwgq+VQ4miOsI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 68930339;
	Wed,  4 Feb 2026 21:20:06 -0800 (PST)
Received: from [10.164.18.70] (MacBook-Pro.blr.arm.com [10.164.18.70])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 557FC3F778;
	Wed,  4 Feb 2026 21:20:09 -0800 (PST)
Message-ID: <4847c300-c7bb-4259-867c-4bbf4d760576@arm.com>
Date: Thu, 5 Feb 2026 10:50:06 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] memcg: use mod_node_page_state to update stats
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Qi Zheng <qi.zheng@linux.dev>, Vlastimil Babka <vbabka@suse.cz>,
 linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 Meta kernel team <kernel-team@meta.com>
References: <20251110232008.1352063-1-shakeel.butt@linux.dev>
 <20251110232008.1352063-2-shakeel.butt@linux.dev>
 <1052a452-9ba3-4da7-be47-7d27d27b3d1d@arm.com> <aYAmGc6lu973jRwu@linux.dev>
 <2638bd96-d8cc-4733-a4ce-efdf8f223183@arm.com>
 <51819ca5a15d8928caac720426cd1ce82e89b429@linux.dev>
 <05aec69b-8e73-49ac-aa89-47b371fb6269@arm.com> <aYOuCmjQ5lGm8Mup@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <aYOuCmjQ5lGm8Mup@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F2026140003
X-Stat-Signature: efwbqbwq4urgj3nyhyc677syb6frdyqk
X-Rspam-User: 
X-HE-Tag: 1770268813-251674
X-HE-Meta: U2FsdGVkX1/eNLQwa4LtXrerUjoBrQiIknnGRIlkFMudOE5COYe3rO92VZwS/HDlxQlWSNjB7FbLAit31gAFt1M9kv7BCbP6/jxDRGDP0B2FWTxTs9vdy+Z6VzRccybRblrzOx+kbV1EvD+q+qgW9vY5gxWEtqpNVD4v4Ag1tQUZx98c2yuQKs0xtrhcO1l4q+UEYp2BYa5vCFlG3qOQvJWFrXMepv24wl5h6oH+aXEA9WEObpeMD3fpEblUWYE7v64LXb0oN8VfIoHUSRfiu1jA+uO60DPKbOUeTzGLQo0Hx2EMXg6EzRqo5mv+RCLOXUU5dT8XhMWqggawdJfvAotTaUSgKHUevbEkFsX/zwdijok6Fl4cIcw+QYBxCYvOWt3cPBVwI7FcNMS3tJ10YZl7nMdi4OmlXO4EPtYa/vcplwg9m3ev0ZULG5TW8/wG5gzv/HbRaG+o0eMDGpw1bxWIDlOqdtrb6dr+1GUoDqYcmipdHKjX6NBmi3xsWYLJ5M4AIkKbV+Uwb4B15ZNk1UMJWXSaoYKkXxpJm+1D/crruu4dCfHwy6k3PDRb0L6YNYvmqoWkPmbbhsJ9dFV+624LM3tuRhZGwT5R2am43c/rlKraVhehO/txtz7z5ZCsZ5UuNEF15IPMScne7Jv6fngDZssC6Edha/+UQX7NV4aeuQFsMiHSCPpEr3i9guX/LHyT6mOr+13tydHqyrD83BoD0emxctyozGt98H6d7Ouk6t1fP9tnrAaRggWGYSxnSaqcu2gQUxSfJ1Rm47VBMMDEZJoe9x/gjUgOpEwyvrRZNwt3CZFQ14rSP18HFLNo6TezoljcB8Ak1t9d5hpPfOGzRA+hv60qt8ft4b9geDcxHLGolYpDmzzChCiYpX/cnmfM2STw0VilFNfhJiAarNeIwRgbQpwAApkNiVR8PwIreucfKCECb3kHZR3FOxW1cSJu3ytXQ4+dW+Eeyv7
 B4PuE7DW
 y3YHN8v32W0sF5LRaQpUVGwtrx9e1Fp6P382ONEPMN94Ql+nPQLM2iPiNrOnDlOUfBC3jCFtevkIQZFsL+H491yf/f4O4F4JXOin2Bd0kFlI4tZNC5D9hdK6dc/7NX6PYG3nVGUc3q6E4u2iFvqVcsolCHrc2xqYkbOiJSibJlAV/MqP6Ff/7XZPIgT47DVJkEDcSehPnbpyQq2Eyhg0nXn/JQmIexqx/AJ/fOqYTLZDPrDDb6mXEJt4zJx/QRO+ooXNpxnf+QVYoqx/S0A2g1rjWZB95ZZqds8xB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 05/02/26 2:08 am, Shakeel Butt wrote:
> On Mon, Feb 02, 2026 at 02:23:54PM +0530, Dev Jain wrote:
>> On 02/02/26 10:24 am, Shakeel Butt wrote:
>>>>>> Hello Shakeel,
>>>>>>
>>>>>>  We are seeing a regression in micromm/munmap benchmark with this patch, on arm64 -
>>>>>>  the benchmark mmmaps a lot of memory, memsets it, and measures the time taken
>>>>>>  to munmap. Please see below if my understanding of this patch is correct.
>>>>>>
>>>>>  Thanks for the report. Are you seeing regression in just the benchmark
>>>>>  or some real workload as well? Also how much regression are you seeing?
>>>>>  I have a kernel rebot regression report [1] for this patch as well which
>>>>>  says 2.6% regression and thus it was on the back-burner for now. I will
>>>>>  take look at this again soon.
>>>>>
>>>> The munmap regression is ~24%. Haven't observed a regression in any other
>>>> benchmark yet.
>>> Please share the code/benchmark which shows such regression, also if you can
>>> share the perf profile, that would be awesome.
>> https://gitlab.arm.com/tooling/fastpath/-/blob/main/containers/microbench/micromm.c
>> You can run this with
>> ./micromm 0 munmap 10
>>
>> Don't have a perf profile, I measured the time taken by above command, with and
>> without the patch.
>>
> Hi Dev, can you please try the following patch?
>
>
> From 40155feca7e7bc846800ab8449735bdb03164d6d Mon Sep 17 00:00:00 2001
> From: Shakeel Butt <shakeel.butt@linux.dev>
> Date: Wed, 4 Feb 2026 08:46:08 -0800
> Subject: [PATCH] vmstat: use preempt disable instead of try_cmpxchg
>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> ---
>  include/linux/mmzone.h |  2 +-
>  mm/vmstat.c            | 58 ++++++++++++++++++------------------------
>  2 files changed, 26 insertions(+), 34 deletions(-)
>
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 3e51190a55e4..499cd53efdd6 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -776,7 +776,7 @@ struct per_cpu_zonestat {
>  
>  struct per_cpu_nodestat {
>  	s8 stat_threshold;
> -	s8 vm_node_stat_diff[NR_VM_NODE_STAT_ITEMS];
> +	long vm_node_stat_diff[NR_VM_NODE_STAT_ITEMS];
>  };
>  
>  #endif /* !__GENERATING_BOUNDS.H */
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index 86b14b0f77b5..0930695597bb 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -377,7 +377,7 @@ void __mod_node_page_state(struct pglist_data *pgdat, enum node_stat_item item,
>  				long delta)
>  {
>  	struct per_cpu_nodestat __percpu *pcp = pgdat->per_cpu_nodestats;
> -	s8 __percpu *p = pcp->vm_node_stat_diff + item;
> +	long __percpu *p = pcp->vm_node_stat_diff + item;
>  	long x;
>  	long t;
>  
> @@ -456,8 +456,8 @@ void __inc_zone_state(struct zone *zone, enum zone_stat_item item)
>  void __inc_node_state(struct pglist_data *pgdat, enum node_stat_item item)
>  {
>  	struct per_cpu_nodestat __percpu *pcp = pgdat->per_cpu_nodestats;
> -	s8 __percpu *p = pcp->vm_node_stat_diff + item;
> -	s8 v, t;
> +	long __percpu *p = pcp->vm_node_stat_diff + item;
> +	long v, t;
>  
>  	VM_WARN_ON_ONCE(vmstat_item_in_bytes(item));
>  
> @@ -467,7 +467,7 @@ void __inc_node_state(struct pglist_data *pgdat, enum node_stat_item item)
>  	v = __this_cpu_inc_return(*p);
>  	t = __this_cpu_read(pcp->stat_threshold);
>  	if (unlikely(v > t)) {
> -		s8 overstep = t >> 1;
> +		long overstep = t >> 1;
>  
>  		node_page_state_add(v + overstep, pgdat, item);
>  		__this_cpu_write(*p, -overstep);
> @@ -512,8 +512,8 @@ void __dec_zone_state(struct zone *zone, enum zone_stat_item item)
>  void __dec_node_state(struct pglist_data *pgdat, enum node_stat_item item)
>  {
>  	struct per_cpu_nodestat __percpu *pcp = pgdat->per_cpu_nodestats;
> -	s8 __percpu *p = pcp->vm_node_stat_diff + item;
> -	s8 v, t;
> +	long __percpu *p = pcp->vm_node_stat_diff + item;
> +	long v, t;
>  
>  	VM_WARN_ON_ONCE(vmstat_item_in_bytes(item));
>  
> @@ -523,7 +523,7 @@ void __dec_node_state(struct pglist_data *pgdat, enum node_stat_item item)
>  	v = __this_cpu_dec_return(*p);
>  	t = __this_cpu_read(pcp->stat_threshold);
>  	if (unlikely(v < - t)) {
> -		s8 overstep = t >> 1;
> +		long overstep = t >> 1;
>  
>  		node_page_state_add(v - overstep, pgdat, item);
>  		__this_cpu_write(*p, overstep);
> @@ -619,9 +619,8 @@ static inline void mod_node_state(struct pglist_data *pgdat,
>         enum node_stat_item item, int delta, int overstep_mode)
>  {
>  	struct per_cpu_nodestat __percpu *pcp = pgdat->per_cpu_nodestats;
> -	s8 __percpu *p = pcp->vm_node_stat_diff + item;
> -	long n, t, z;
> -	s8 o;
> +	long __percpu *p = pcp->vm_node_stat_diff + item;
> +	long o, n, t, z;
>  
>  	if (vmstat_item_in_bytes(item)) {
>  		/*
> @@ -634,32 +633,25 @@ static inline void mod_node_state(struct pglist_data *pgdat,
>  		delta >>= PAGE_SHIFT;
>  	}
>  
> +	preempt_disable();
> +
>  	o = this_cpu_read(*p);
> -	do {
> -		z = 0;  /* overflow to node counters */
> +	n = o + delta;
>  
> -		/*
> -		 * The fetching of the stat_threshold is racy. We may apply
> -		 * a counter threshold to the wrong the cpu if we get
> -		 * rescheduled while executing here. However, the next
> -		 * counter update will apply the threshold again and
> -		 * therefore bring the counter under the threshold again.
> -		 *
> -		 * Most of the time the thresholds are the same anyways
> -		 * for all cpus in a node.
> -		 */
> -		t = this_cpu_read(pcp->stat_threshold);
> +	t = this_cpu_read(pcp->stat_threshold);
> +	z = 0;
>  
> -		n = delta + (long)o;
> +	if (abs(n) > t) {
> +		int os = overstep_mode * (t >> 1);
>  
> -		if (abs(n) > t) {
> -			int os = overstep_mode * (t >> 1) ;
> +		/* Overflow must be added to node counters */
> +		z = n + os;
> +		n = -os;
> +	}
>  
> -			/* Overflow must be added to node counters */
> -			z = n + os;
> -			n = -os;
> -		}
> -	} while (!this_cpu_try_cmpxchg(*p, &o, n));
> +	this_cpu_add(*p, n - o);
> +
> +	preempt_enable();
>  
>  	if (z)
>  		node_page_state_add(z, pgdat, item);
> @@ -866,7 +858,7 @@ static bool refresh_cpu_vm_stats(bool do_pagesets)
>  		struct per_cpu_nodestat __percpu *p = pgdat->per_cpu_nodestats;
>  
>  		for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++) {
> -			int v;
> +			long v;
>  
>  			v = this_cpu_xchg(p->vm_node_stat_diff[i], 0);
>  			if (v) {
> @@ -929,7 +921,7 @@ void cpu_vm_stats_fold(int cpu)
>  
>  		for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++)
>  			if (p->vm_node_stat_diff[i]) {
> -				int v;
> +				long v;
>  
>  				v = p->vm_node_stat_diff[i];
>  				p->vm_node_stat_diff[i] = 0;

Thanks for looking into this.

But this doesn't solve it :( preempt_disable() contains a compiler barrier,
probably that's why.

Also can you confirm whether my analysis of the regression was correct?
Because if it was, then this diff looks wrong - AFAIU preempt_disable()
won't stop an irq handler from interrupting the execution, so this
will introduce a bug for code paths running in irq context.



