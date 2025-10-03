Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6A31CCA471
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 12:38:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 054B68E0007; Fri,  3 Oct 2025 08:38:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 005428E0003; Fri,  3 Oct 2025 08:38:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E36048E0007; Fri,  3 Oct 2025 08:38:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C9F838E0003
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 08:38:25 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 52BB387DEE
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 12:38:25 +0000 (UTC)
X-FDA: 83956756170.22.8A95504
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5B8404000D
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 12:38:23 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759495103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U+sctDrh0iHPUShQHzaJcVCw3eCOC8uh8lfyUlwzj80=;
	b=q35dX70oZp4l41RIoEcbfUlibhh87Tpa8jlStuNUQXKUq7LAb6ua/X5PF9I/PtH3v8F6f6
	ldYLUTJv4jYqEtpG/134lKL5dr6rGAN8kZCJdmWy/mePKQQtwvmrqmfXFH4iDQ+qwfhA3z
	fpavti7ZiPdPpsv2ZczoLyEMFf2UoEs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759495103; a=rsa-sha256;
	cv=none;
	b=if8BGJZSqMw7uTWWelXQmlvCC61Ldny562ygb6//TRb7f+pUxS9IzxVWjuQqEwik+lgvPM
	8lEMqTP55NvfNPTxmL3OIUKw/PRPRppk5Ge9DV86jNzbV/xHAI1fL5XzXEFgyPzEFEmR/s
	N/W+vjFQAhKRaqVLU8Z+S072J5A4pAs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4cdSmY5XHdz6K8wc;
	Fri,  3 Oct 2025 20:35:09 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 1EC7F14038F;
	Fri,  3 Oct 2025 20:38:21 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 3 Oct
 2025 13:38:19 +0100
Date: Fri, 3 Oct 2025 13:38:18 +0100
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Bharata B Rao <bharata@amd.com>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<dave.hansen@intel.com>, <gourry@gourry.net>, <hannes@cmpxchg.org>,
	<mgorman@techsingularity.net>, <mingo@redhat.com>, <peterz@infradead.org>,
	<raghavendra.kt@amd.com>, <riel@surriel.com>, <rientjes@google.com>,
	<sj@kernel.org>, <weixugc@google.com>, <willy@infradead.org>,
	<ying.huang@linux.alibaba.com>, <ziy@nvidia.com>, <dave@stgolabs.net>,
	<nifan.cxl@gmail.com>, <xuezhengchu@huawei.com>, <yiannis@zptcorp.com>,
	<akpm@linux-foundation.org>, <david@redhat.com>, <byungchul@sk.com>,
	<kinseyho@google.com>, <joshua.hahnjy@gmail.com>, <yuanchu@google.com>,
	<balbirs@nvidia.com>, <alok.rathore@samsung.com>
Subject: Re: [RFC PATCH v2 8/8] mm: sched: Move hot page promotion from
 NUMAB=2 to kpromoted
Message-ID: <20251003133818.000017af@huawei.com>
In-Reply-To: <20250910144653.212066-9-bharata@amd.com>
References: <20250910144653.212066-1-bharata@amd.com>
	<20250910144653.212066-9-bharata@amd.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.203.177.15]
X-ClientProxiedBy: lhrpeml500012.china.huawei.com (7.191.174.4) To
 dubpeml100005.china.huawei.com (7.214.146.113)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5B8404000D
X-Stat-Signature: q9ip91zmjdx78kky74ksgdqoyu5mediw
X-Rspam-User: 
X-HE-Tag: 1759495103-563765
X-HE-Meta: U2FsdGVkX1+HNtA6L01aWQ84X/FERkcNEPHCeXXP19kDE/bV0XOlIoNg8JPfgT79wUHC8FZevToXMXmag3dsE8bQsRf+hzWelSdH29uDHUbeKDzYvVPowDxoVtgFRgbxQvOmjKMeyPE/S9aehJnGOa2EKtWXPedgKRmEHFWQlgJzD3HTpvf+Ld4eSANEScuNZTMCBv+OAtSVhScgC8d3Olt/Kf7M35zYWIX4aIroCfIrxwZKg3Pj7KrRCVBGdKJxXos+mdjYol1HM2WPOgEbLOtqLQ/sHaC9c6HBG/XZH9BF+FbuWqpNoDgYB3dvs6IsyWoT3CnoTTgOHcCHYS907FZJF8NdtL/FvhMS0lGze/WWU9XhrM9FCIOBOmycGr8vJ3HiyAkoJXXRNTrBUgpqvA51Wqb0xlClY5U5LNfWeHaKlJQzq+6BxvCrQ0VS/Dv/9dfrgC4TlBBNoTGXl5rBRK7R+TSfnOmntTsCcW5gWAGO9Pj5J5mxDDJePTBNhu3nRDnL6XQLvE7pAYUxPXiNkYUiuUZFKYymOCGMlYHd1v/imJb2e6Y//ANd3MdblKVdcIXIJSG7Om6aqIuuLI+1e7eDnX/hf+AZmR+abH1x+7O6h1XqSEsklta+qfnXSZjsi+62hQfR0QTY4io8xx5YpDL4/zhnFSHsgRL82u8+FRet7GrlnliseBbshMRxoWvPJRS4+8oKnpIQHAML9JWkL91WVx1rd8ZwxyfJGFGRZdOkc86akil8lUnTSKLsh7SIkDJLFSu9SxFv8V85VMjdMX6TPFISfqEZoRuw0rvNL/bGcIm3qCYqMITcF8N6Fe8iJRDb5cnRGG/vvxMDaH8JuGSsMj3nnIXYx3tlwLZrKhux5pwwZQk2Rr2n40467cSUPGdSXBS9FPWp47PtjfZiWlk07xpI/RE3+55IRWlJ1CVsXD4vw9jzqZNINw0o79k9/cSltHjWnqQw3t/T8M/
 GGTwMvGs
 BM4CmqmWrVn1X7Nil+uvPDkBhkSerJoh89kTHS+/goP7ms/cscwcF/CEoLmbN/2bjSo9ANoNxYncguZ3ID8BiVEeLfcR4XoixPiu05gd6bodA25DK/67ODey+8z+M9em0NqHG2f/TcTbYP3Pjr2mLcaocfpfku/HMYxa4wfxUldHHs2zjJBPT74wI/vYYpyCbIkiCDK28WuzFUDiLShJN3yNnoxYORhCwb/HRq1x+hq9tfFvjYCzO15YRgKum+97Z9ZJGQ7xaV2dH45ZwgnJqqp/y8kNDrYuhDX00T9Cvhq66NQH6QlWeYln1MrrsRI+hyaI3cd7fi+o/4r9hecTzHTncD5kavA7eNn+g
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 10 Sep 2025 20:16:53 +0530
Bharata B Rao <bharata@amd.com> wrote:

> Currently hot page promotion (NUMA_BALANCING_MEMORY_TIERING
> mode of NUMA Balancing) does hot page detection (via hint faults),
> hot page classification and eventual promotion, all by itself and
> sits within the scheduler.
> 
> With the new hot page tracking and promotion mechanism being
> available, NUMA Balancing can limit itself to detection of
> hot pages (via hint faults) and off-load rest of the
> functionality to the common hot page tracking system.
> 
> pghot_record_access(PGHOT_HINT_FAULT) API is used to feed the
> hot page info. In addition, the migration rate limiting and
> dynamic threshold logic are moved to kpromoted so that the same
> can be used for hot pages reported by other sources too.
> 
> Signed-off-by: Bharata B Rao <bharata@amd.com>

Making a direct replacement without any fallback to previous method
is going to need a lot of data to show there are no important regressions.

So bold move if that's the intent! 

J
> ---
>  include/linux/pghot.h |   2 +
>  kernel/sched/fair.c   | 149 ++----------------------------------------
>  mm/memory.c           |  32 ++-------
>  mm/pghot.c            | 132 +++++++++++++++++++++++++++++++++++--
>  4 files changed, 142 insertions(+), 173 deletions(-)
> 

> diff --git a/mm/pghot.c b/mm/pghot.c
> index 9f7581818b8f..9f5746892bce 100644
> --- a/mm/pghot.c
> +++ b/mm/pghot.c
> @@ -9,6 +9,9 @@
>   *
>   * kpromoted is a kernel thread that runs on each toptier node and
>   * promotes pages from max_heap.
> + *
> + * Migration rate-limiting and dynamic threshold logic implementations
> + * were moved from NUMA Balancing mode 2.
>   */
>  #include <linux/pghot.h>
>  #include <linux/kthread.h>
> @@ -34,6 +37,9 @@ static bool kpromoted_started __ro_after_init;
>  
>  static unsigned int sysctl_pghot_freq_window = KPROMOTED_FREQ_WINDOW;
>  
> +/* Restrict the NUMA promotion throughput (MB/s) for each target node. */
> +static unsigned int sysctl_pghot_promote_rate_limit = 65536;

If the comment correlates with the value, this is 64 GiB/s?  That seems
unlikely if I guess possible.

> +
>  #ifdef CONFIG_SYSCTL
>  static const struct ctl_table pghot_sysctls[] = {
>  	{
> @@ -44,8 +50,17 @@ static const struct ctl_table pghot_sysctls[] = {
>  		.proc_handler	= proc_dointvec_minmax,
>  		.extra1		= SYSCTL_ZERO,
>  	},
> +	{
> +		.procname	= "pghot_promote_rate_limit_MBps",
> +		.data		= &sysctl_pghot_promote_rate_limit,
> +		.maxlen		= sizeof(unsigned int),
> +		.mode		= 0644,
> +		.proc_handler	= proc_dointvec_minmax,
> +		.extra1		= SYSCTL_ZERO,
> +	},
>  };
>  #endif
> +
Put that in earlier patch to reduce noise here.

>  static bool phi_heap_less(const void *lhs, const void *rhs, void *args)
>  {
>  	return (*(struct pghot_info **)lhs)->frequency >
> @@ -94,11 +109,99 @@ static bool phi_heap_insert(struct max_heap *phi_heap, struct pghot_info *phi)
>  	return true;
>  }
>  
> +/*
> + * For memory tiering mode, if there are enough free pages (more than
> + * enough watermark defined here) in fast memory node, to take full

I'd use enough_wmark   Just because "more than enough" is a common
English phrase and I at least tripped over that sentence as a result!

> + * advantage of fast memory capacity, all recently accessed slow
> + * memory pages will be migrated to fast memory node without
> + * considering hot threshold.
> + */
> +static bool pgdat_free_space_enough(struct pglist_data *pgdat)
> +{
> +	int z;
> +	unsigned long enough_wmark;
> +
> +	enough_wmark = max(1UL * 1024 * 1024 * 1024 >> PAGE_SHIFT,
> +			   pgdat->node_present_pages >> 4);
> +	for (z = pgdat->nr_zones - 1; z >= 0; z--) {
> +		struct zone *zone = pgdat->node_zones + z;
> +
> +		if (!populated_zone(zone))
> +			continue;
> +
> +		if (zone_watermark_ok(zone, 0,
> +				      promo_wmark_pages(zone) + enough_wmark,
> +				      ZONE_MOVABLE, 0))
> +			return true;
> +	}
> +	return false;
> +}

> +
> +static void kpromoted_promotion_adjust_threshold(struct pglist_data *pgdat,

Needs documentation of the algorithm and the reasons for various choices.

I see it is a code move though so maybe that's a job for another day.

> +						 unsigned long rate_limit,
> +						 unsigned int ref_th,
> +						 unsigned long now)
> +{
> +	unsigned int start, th_period, unit_th, th;
> +	unsigned long nr_cand, ref_cand, diff_cand;
> +
> +	now = jiffies_to_msecs(now);
> +	th_period = KPROMOTED_PROMOTION_THRESHOLD_WINDOW;
> +	start = pgdat->nbp_th_start;
> +	if (now - start > th_period &&
> +	    cmpxchg(&pgdat->nbp_th_start, start, now) == start) {
> +		ref_cand = rate_limit *
> +			KPROMOTED_PROMOTION_THRESHOLD_WINDOW / MSEC_PER_SEC;
> +		nr_cand = node_page_state(pgdat, PGPROMOTE_CANDIDATE);
> +		diff_cand = nr_cand - pgdat->nbp_th_nr_cand;
> +		unit_th = ref_th * 2 / KPROMOTED_MIGRATION_ADJUST_STEPS;
> +		th = pgdat->nbp_threshold ? : ref_th;
> +		if (diff_cand > ref_cand * 11 / 10)
> +			th = max(th - unit_th, unit_th);
> +		else if (diff_cand < ref_cand * 9 / 10)
> +			th = min(th + unit_th, ref_th * 2);
> +		pgdat->nbp_th_nr_cand = nr_cand;
> +		pgdat->nbp_threshold = th;
> +	}
> +}
 +
>  static bool phi_is_pfn_hot(struct pghot_info *phi)
>  {
>  	struct page *page = pfn_to_online_page(phi->pfn);
> -	unsigned long now = jiffies;
>  	struct folio *folio;
> +	struct pglist_data *pgdat;
> +	unsigned long rate_limit;
> +	unsigned int latency, th, def_th;
> +	unsigned long now = jiffies;
>  
Avoid the reorder.  Just put it here in first place if you prefer this.




