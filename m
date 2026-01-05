Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4905CC2A072
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 06:38:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDDF16B00E2; Mon,  5 Jan 2026 01:38:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8A7D6B00E3; Mon,  5 Jan 2026 01:38:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8D006B00E4; Mon,  5 Jan 2026 01:38:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B4B846B00E2
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 01:38:51 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3BE7C13D7D8
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 06:38:51 +0000 (UTC)
X-FDA: 84296957262.23.F6B3EA3
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4247C40002
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 06:38:49 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=og007XNo;
	spf=pass (imf01.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767595129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6GSWauQ+JqQj2YxH5/FYfC8pu4G5J3rlHrbtcyoAwBI=;
	b=eXIldBNJjr/7A6ww8XH9LT4niZmsohm0BcrUdnwLdQvAXUmVv8a4362n0ZuHZ+BiB4uzrU
	KKBXrMC2dsyiV+6UkRHP+GPme4154OYhwDnDEQWHxYRpMK1q3S0prQuiOxOkEt2hdj2ukI
	Xmr3eUxzghdp5TN7YPRQvBjF/FIx8bs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=og007XNo;
	spf=pass (imf01.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767595129; a=rsa-sha256;
	cv=none;
	b=3xuNfoX+85+6Nsg5LeQaDXmI/SRfZ4NVsZ1MBdNAmDj2GEZrkFPxw3cAentPGUohi4uiHX
	laZrezMu4tmmesqmPeZldbB4mJ7s69/7ZZ9dgwSfY9pZJbPDr/+utMyo0Iz56qVHBB4bTn
	zDzOWFNo7vpl21gJygSMy/F/5M/8N/8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767595125;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6GSWauQ+JqQj2YxH5/FYfC8pu4G5J3rlHrbtcyoAwBI=;
	b=og007XNo1/mr8GtR9T1LkxWzw62ZWQ0jKZd6IaqP7454/WX0ocFgdaBJ4eREIDDcMYvaeA
	MKWAASCu+WCm1JLcYP8/aJ+aeZU7BGOWaLzSOqgSqZIt321u/JvN58bFNROLNOS4CDSvqG
	IcHU0ay+9teJol9aJJgkx7eocYV6NTw=
From: Lance Yang <lance.yang@linux.dev>
To: realwujing@qq.com
Cc: david@kernel.org,
	akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	jackmanb@google.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	mhocko@suse.com,
	surenb@google.com,
	vbabka@suse.cz,
	yuanql9@chinatelecom.cn,
	ziy@nvidia.com,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH 1/1] mm/page_alloc: auto-tune min_free_kbytes on atomic allocation failure
Date: Mon,  5 Jan 2026 14:38:30 +0800
Message-ID: <20260105063830.15140-1-lance.yang@linux.dev>
In-Reply-To: <tencent_9DB6637676D639B4B7AEA09CC6A6F9E49D0A@qq.com>
References: <tencent_9DB6637676D639B4B7AEA09CC6A6F9E49D0A@qq.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4247C40002
X-Stat-Signature: pigdbutp5ci18te43ewjykw7duna85px
X-Rspam-User: 
X-HE-Tag: 1767595129-400058
X-HE-Meta: U2FsdGVkX18VLqu0IigSPSqNey81G4MnLGq6rdGRoCbRs9LeM/ftyJ0lrbAAeVuuW4B1EHw4vNDrNvhjjPTJZrQiYNuAQM999aD8eATGfpwGVFLnDSJAp9eEyu2TnhgsiYghmpjG0V7P+j9hMwHF8+9ybT/FecILu/12SXqaDq0E3+foXL7rmIMugtf82MKpGoUB2y8m/DVatSJDJGmSXrUeV0qhdhAKeokLEbZ5ro1VhsrGZfk/vdAzUzqbdg1NmxstNjCc3NQVgb92/9PiDlBvEEeo3a8LfShMDDIySvT746+2oXXrl0WTiyV7WQuo3QK2SzfYlZwi/azvT0YCOlhXDS7i12pgDL9H+OG6DO87XQJ7TbCPkOYtyZrvLLenMyjGhdklQvs3vqZk4H73yEqUWUu0P4aAOIz28rNatdPHLFe1DtrV9zxUhHLmx550XUGraH7uPRWijE+anFHaperbe0K2yiyzDLC/eI05EzmtznZb/vhzoqJRBY9RK52xFHIdFD/o0OSx1PRwWZ2aR1lZG/1e9SUSKzjEG27c/bwKVpSYQhuSQ4vZxJ5SQMUZQKkbvjKvtGLoJEEPQmQ/giZvpmkAc0SrxgU4AjQ9uCynF3GsGRtVA0cTDz5C6BwsvqY4CzlkhX5QSCnBb7Wb0IWG0QVHds6hUawgwxoX4Wk9qdVpJeFAa7fYpl2RGHT9zGM1kS9TnkP6z4jms2T4Wrz2EK+b4mV0PPMPqF7hN89M43WMFB3nLb0vk/YBJM1HkTslarid7DqqUimZ6ZnzS0Ad+Y7wukxta613iu7O31hc3GTEE9dIu2iO0EnfT8jDG9bxLfnXk8TA1gJgjitfCO+b6L/uTbK0LB5uUjghO5xXesLXzpt6xS4j3Zyyis9Gz6aG7VuEa3a+7AdjCLyGQgmwRI8lJ/n8nVEtQHIsKPWTTIWyywVE9oItJAwRsKJANZhYgDPPpNlflI23Hhx
 errxeNeS
 5+EPeIFyvIVTatmZu/fjf/KohzstKWaQtR3yZ7C/1L8wqCIweAzWbIBbabei+e5h2OLlbeLNOlWvFYhAW0fyKcgg9ExNI7CYMu000gytSSKxPb31RIzoM6K7WxAwG3viR+CRb3XSDA7C0Pkdx6AB1nUSPjNuDW99YdKZiulVdo391S+/AqPp3A1xpEdFYAjOQPfa/fq/9DPS1bFOy0mrQr0mW+aa75MKRm7PKpAF+8GzHjEwv2I+AzqmD0XuLjjjUBr2Yz0bvnMApWlQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Sun,  4 Jan 2026 20:26:52 +0800, wujing wrote:
> Introduce a mechanism to dynamically increase vm.min_free_kbytes when
> critical atomic allocations (GFP_ATOMIC, order-0) fail. This prevents
> recurring network packet drops or other atomic failures by proactively
> reserving more memory.

Just wondering, could we adjust watermark_scale_factor instead of
min_free_kbytes?

Increasing min_free_kbytes directly reduces available memory, while
watermark_scale_factor just makes kswapd wake up earlier for reclaim ...

Seems like less side effect than min_free_kbytes :)

Cheers,
Lance

> 
> The adjustment doubles min_free_kbytes upon upon failure (exponential backoff),
> capped at 1% of total RAM.
> 
> Observed failure logs:
> [38535641.026406] node 0: slabs: 941, objs: 54656, free: 0
> [38535641.037711] node 1: slabs: 349, objs: 22096, free: 272
> [38535641.049025] node 1: slabs: 349, objs: 22096, free: 272
> [38535642.795972] SLUB: Unable to allocate memory on node -1, gfp=0x480020(GFP_ATOMIC)
> [38535642.805017] cache: skbuff_head_cache, object size: 232, buffer size: 256, default order: 2, min order: 0
> [38535642.816311] node 0: slabs: 854, objs: 42320, free: 0
> [38535642.823066] node 1: slabs: 400, objs: 25360, free: 294
> [38535643.070199] SLUB: Unable to allocate memory on node -1, gfp=0x480020(GFP_ATOMIC)
> [38535643.078861] cache: skbuff_head_cache, object size: 232, buffer size: 256, default order: 2, min order: 0
> [38535643.089719] node 0: slabs: 841, objs: 41824, free: 0
> [38535643.096513] node 1: slabs: 393, objs: 24480, free: 272
> [38535643.484149] SLUB: Unable to allocate memory on node -1, gfp=0x480020(GFP_ATOMIC)
> [38535643.492831] cache: skbuff_head_cache, object size: 232, buffer size: 256, default order: 2, min order: 0
> [38535643.503666] node 0: slabs: 898, objs: 43120, free: 159
> [38535643.510140] node 1: slabs: 404, objs: 25424, free: 319
> [38535644.699224] SLUB: Unable to allocate memory on node -1, gfp=0x480020(GFP_ATOMIC)
> [38535644.707911] cache: skbuff_head_cache, object size: 232, buffer size: 256, default order: 2, min order: 0
> [38535644.718700] node 0: slabs: 1031, objs: 43328, free: 0
> [38535644.725059] node 1: slabs: 339, objs: 17616, free: 317
> [38535645.428345] SLUB: Unable to allocate memory on node -1, gfp=0x480020(GFP_ATOMIC)
> [38535645.436888] cache: skbuff_head_cache, object size: 232, buffer size: 256, default order: 2, min order: 0
> [38535645.447664] node 0: slabs: 940, objs: 40864, free: 144
> [38535645.454026] node 1: slabs: 322, objs: 19168, free: 383
> [38535645.556122] SLUB: Unable to allocate memory on node -1, gfp=0x480020(GFP_ATOMIC)
> [38535645.564576] cache: skbuff_head_cache, object size: 232, buffer size: 256, default order: 2, min order: 0
> [38535649.655523] warn_alloc: 59 callbacks suppressed
> [38535649.655527] swapper/100: page allocation failure: order:0, mode:0x480020(GFP_ATOMIC), nodemask=(null)
> [38535649.671692] swapper/100 cpuset=/ mems_allowed=0-1
> 
> Signed-off-by: wujing <realwujing@qq.com>
> Signed-off-by: Qiliang Yuan <yuanql9@chinatelecom.cn>
> ---
>  mm/page_alloc.c | 33 +++++++++++++++++++++++++++++++++
>  1 file changed, 33 insertions(+)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index c380f063e8b7..9a24e2b6cfbf 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -30,6 +30,7 @@
>  #include <linux/oom.h>
>  #include <linux/topology.h>
>  #include <linux/sysctl.h>
> +#include <linux/workqueue.h>
>  #include <linux/cpu.h>
>  #include <linux/cpuset.h>
>  #include <linux/pagevec.h>
> @@ -3975,6 +3976,9 @@ static void warn_alloc_show_mem(gfp_t gfp_mask, nodemask_t *nodemask)
>  	mem_cgroup_show_protected_memory(NULL);
>  }
>  
> +static void boost_min_free_kbytes_workfn(struct work_struct *work);
> +static DECLARE_WORK(boost_min_free_kbytes_work, boost_min_free_kbytes_workfn);
> +
>  void warn_alloc(gfp_t gfp_mask, nodemask_t *nodemask, const char *fmt, ...)
>  {
>  	struct va_format vaf;
> @@ -4947,6 +4951,10 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  		goto retry;
>  	}
>  fail:
> +	/* Auto-tuning: trigger boost if atomic allocation fails */
> +	if ((gfp_mask & GFP_ATOMIC) && order == 0)
> +		schedule_work(&boost_min_free_kbytes_work);
> +
>  	warn_alloc(gfp_mask, ac->nodemask,
>  			"page allocation failure: order:%u", order);
>  got_pg:
> @@ -7682,3 +7690,28 @@ struct page *alloc_pages_nolock_noprof(gfp_t gfp_flags, int nid, unsigned int or
>  	return page;
>  }
>  EXPORT_SYMBOL_GPL(alloc_pages_nolock_noprof);
> +
> +static void boost_min_free_kbytes_workfn(struct work_struct *work)
> +{
> +	int new_min;
> +
> +	/* Cap at 1% of total RAM for safety */
> +	unsigned long total_kbytes = totalram_pages() << (PAGE_SHIFT - 10);
> +	int max_limit = total_kbytes / 100;
> +
> +	/* Exponential increase: double the current value */
> +	new_min = min_free_kbytes * 2;
> +
> +	if (new_min > max_limit)
> +		new_min = max_limit;
> +
> +	if (new_min > min_free_kbytes) {
> +		min_free_kbytes = new_min;
> +		/* Update user_min_free_kbytes so it persists through recalculations */
> +		if (new_min > user_min_free_kbytes)
> +			user_min_free_kbytes = new_min;
> +		
> +		setup_per_zone_wmarks();
> +		pr_info("Auto-tuning: unexpected atomic failure detected, increasing min_free_kbytes to %d\n", min_free_kbytes);
> +	}
> +}

