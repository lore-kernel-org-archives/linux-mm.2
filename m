Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86715EEA876
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 01:53:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B42E26B0005; Thu, 12 Feb 2026 20:52:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF09C6B0089; Thu, 12 Feb 2026 20:52:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FD166B008A; Thu, 12 Feb 2026 20:52:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8B2846B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 20:52:59 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DE3A88B463
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 01:52:57 +0000 (UTC)
X-FDA: 84437759994.13.56CA13D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 17131100002
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 01:52:55 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ZABErF/b";
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770947576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PGcRpk6gzXzhxCCxJgndalCrqyipRlOIZ+Z196oHPho=;
	b=Kd7fouQVwFZUQMS9D4Nva6fy9Of8pNDhQCaE8z+ykC9LxqonVQEdbgU/YcVtYNCglKBClD
	qKl4pNsaXm06HBU3PJECv8aOj5W4LeKcqxniHfZC5vr7ocIL1GJA9B2ksIAYMEEnQUii0A
	vD12ow8VoHeuqTzm7Pn5INicWPq+ah4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ZABErF/b";
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770947576; a=rsa-sha256;
	cv=none;
	b=IJg3wIvJ5pJGAoRMkttMPYF/c/5l7f8fyXT0zs/vOVjcqrhbbQg1HVEIZfGAlI7AsUN4ck
	wisAp+YVTPDQKQDr0L1pCWIHAcE47yGU2feVvOQJgz130e+mZqXhiZfWHjoR8FqqiJs6X5
	LbcGQk7uAMJIm6VSg9d9Etd8RwUYNuM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 473AE43D46;
	Fri, 13 Feb 2026 01:52:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA6D1C4CEF7;
	Fri, 13 Feb 2026 01:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770947573;
	bh=a745jQN8yH5L9qhr1/jEP6+9uNOORuWZn3xuUZxnxfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZABErF/bCtB2tRsUScqf69kDe4/1BITm9QcToUR9EhazbcD6BPa0LFBMG5c0tiV9E
	 9/x/O8li3pP53+nefdCrA/GTC6N1Wk9rEUGzlPF8WSACnPGdx+u1qxhYdOYDraboo4
	 /nhKfyOIx/ivGquCAGeturtR10G/zmfRsRAuBL1IrTjOzM/FbU5mUZKtGo3L6d5zaG
	 YFQlAvsvVhcvNIZFlrWv8Vu04gPIOW1JG9Gop0J3TTbP1C+lCUsIM3AVPg4ZJipX/k
	 gf4fXoIBVizHLbXgdlu0LezlDExEsm/Xtbya9c4yI9w+O+Y+nMD76sm51fZcGOtEiw
	 RHlx6gGy4qxkg==
From: SeongJae Park <sj@kernel.org>
To: Qiliang Yuan <realwujing@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Lance Yang <lance.yang@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel test robot <oliver.sang@intel.com>,
	Qiliang Yuan <yuanql9@chinatelecom.cn>
Subject: Re: [PATCH RESEND v8] mm/page_alloc: boost watermarks on atomic allocation failure
Date: Thu, 12 Feb 2026 17:52:48 -0800
Message-ID: <20260213015249.69626-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260212-wujing-mm-page_alloc-v8-v8-1-daba38990cd3@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 17131100002
X-Rspamd-Server: rspam07
X-Stat-Signature: 3ns8xatnt9po49ea78y5tmweqktr4xoh
X-HE-Tag: 1770947575-143877
X-HE-Meta: U2FsdGVkX1+sNtjmEUk/btNW5G0CD135kTH057Be7tmHWPfl6U8eT4ueR01ixgi4D10Yz/yiOWEr8b840RSGGFP/+lRaSO/DSuZG2hFO1cNBPL4wkAdIC4rKtQ1ZaMig5gzGmVs3YjjkxvjwI1uzZQlEgeM6PqQYJ1Q1RGHEa1kZjGKi/cg4KclJoFFXxc4O08xiPEItpe+/qgu7oVB2mQkG9JgshC9pUvz0IlH2ETBtGuz9sH9brEkecUoMVj7473jX48AbmOZdVQMvS1Sjl25C3DC3gOyyDGlbe8Dv9qwDmeFVUITOw0agcOXdcz81qj3XjtCQkyvk+fowNE/O4tznFbw+n0Ca2mHjWmzOqZ+ehyZ9jTc2Fe2ixuBrrXR92woXCLr8m+xLGpf1rhE1/NsKBHQTgESo4HU12THmx/cGenWqG/WFPxDrlkZg5BskqGvZJT1DyrJQxXvJoVKWGAkuc/81h/bzYIScboZh6s3i3cELA9GWNq1TJam0yKF6Mv6XE0zRCF/6uP2klmoTCgW3u+OOH/pKFq0/4+tQJpzCUx9xHZwOrBgzj+QTzAc5BKLbCSFlcK0xDtNwu17CzUTlAp3QHyX7gVOyt1Dbfs2o+RDi9WXG2h2bFXgnR1RiCfIw2DgXhiSNLBYvoUNtlsndjHUp/vgZMdRSEFjQuI0MPXweSfouwaOWPaK5Rlz/f4rLdZhvWGqkbH3qL4vc2ge9+BVFXtpctX4rAHuqFMcjL+CFGMP+f68AMh9dI8h4XnwbOoIPSrKM0gj/62FCCd3kDk7MnIjIR+zFt7KlKl1++Dv97+S8umgODYCgCstlcH83IX1y1lnEerqOsMHksz+yDYyxMFw74OZzIOe4/f5oXkR5QFhdamvxj+gJe76h3HqYAHjb8a3Mm58a01saeA5p2bLXyHeGSKKBdCaYf32jT6/Dxk8/7FvrQ8E/j+S9z0k5YXvM+0AcgyrjvV4
 24oQ+sc0
 g/ku4f4tZs9nizrcmSnWsk5lLulcKx6kBPeI8QM04myjV5CEP9jmgYEEO7bLoZyqDtcpl5I9xinR7rupjf7dv3Z4TrjIjjncgBjvtBPvNU+y1FHQMG4Vs0DkF4exTtjiuSiGuzfHYGyRq4nMpRoCgxWDj3EPtYm3/WNdairE0b9uOLEDpN9SuKUn42hJt6HHdzXw+TbP6ecksIXmyobjfn/EAELxu4MrkOatmWrHPPKXPG80N9gByl0uw5uD7jmJhiu8gyI9DGjbgVEQAAf++26tUXqwSmVTZjg8jtKY0b1SQwQeMt47EYOkiLdaIUeyUD/PypI4E4Iyo010=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 12 Feb 2026 15:27:41 +0800 Qiliang Yuan <realwujing@gmail.com> wrote:

> Atomic allocations (GFP_ATOMIC) are prone to failure under heavy memory
> pressure as they cannot enter direct reclaim. This patch introduces a
> watermark boost mechanism to mitigate this issue.
> 
> When a GFP_ATOMIC request enters the slowpath, the preferred zone's
> watermark_boost is increased under zone->lock protection. This triggers
> kswapd to proactively reclaim memory, creating a safety buffer for
> future atomic allocations. A 1-second debounce timer prevents excessive
> boosts during traffic bursts.
> 
> This approach reuses existing watermark_boost infrastructure with
> minimal overhead and proper locking to ensure thread safety.
> 
> Allocation failure logs:
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
> Reported-by: kernel test robot <oliver.sang@intel.com>

I was surprised the robot can find this kind of issue, too.

> Closes: https://lore.kernel.org/oe-lkp/202601271341.5d24a59f-lkp@intel.com

But seems the report was inconsistent_lock_state warning on the previous
revision of this patch.

The report was saying

    If you fix the issue in a separate patch/commit (i.e. not just a new version of
    the same patch/commit), kindly add following tags
    | Reported-by: kernel test robot <oliver.sang@intel.com>
    | Closes: https://lore.kernel.org/oe-lkp/202601271341.5d24a59f-lkp@intel.com

And this is a new version of the reported patch, so I don't think the above two
tags are needed here.

> Signed-off-by: Qiliang Yuan <yuanql9@chinatelecom.cn>
> Signed-off-by: Qiliang Yuan <realwujing@gmail.com>

Having two signed-off-by tags for single person looks weird to me.

> ---
> v8:
> - Use spin_lock_irqsave() to prevent inconsistent lock state (softirq-on
>   vs in-softirq) as reported by LKP.
> v7:
>   - Use local variable for boost_amount to improve code readability
>   - Add zone->lock protection in boost_zones_for_atomic()
>   - Add lockdep assertion in boost_watermark() to prevent locking mistakes
>   - Remove redundant boost call at fail label due to 1-second debounce
>   - Link: https://lore.kernel.org/all/20260123064231.250767-1-realwujing@gmail.com/
> v6:
>   - Replace magic number ">> 10" with ATOMIC_BOOST_SCALE_SHIFT define
>   - Add documentation explaining 0.1% zone size boost rationale
> v5:
>   - Simplify to use native boost_watermark() instead of custom logic
> v4:
>   - Add watermark_scale_boost and gradual decay via balance_pgdat
> v3:
>   - Move debounce timer to per-zone; optimize zone selection
> v2:
>   - Add debounce logic and zone-proportional boosting
> v1:
>   - Initial: boost min_free_kbytes on GFP_ATOMIC failure
> ---
>  include/linux/mmzone.h |  1 +
>  mm/page_alloc.c        | 48 ++++++++++++++++++++++++++++++++++++++++++++++--
>  2 files changed, 47 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 75ef7c9f9307..8e37e4e6765b 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -882,6 +882,7 @@ struct zone {
>  	/* zone watermarks, access with *_wmark_pages(zone) macros */
>  	unsigned long _watermark[NR_WMARK];
>  	unsigned long watermark_boost;
> +	unsigned long last_boost_jiffies;
>  
>  	unsigned long nr_reserved_highatomic;
>  	unsigned long nr_free_highatomic;
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index c380f063e8b7..7dc1e056a082 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -218,6 +218,13 @@ unsigned int pageblock_order __read_mostly;
>  static void __free_pages_ok(struct page *page, unsigned int order,
>  			    fpi_t fpi_flags);
>  
> +/*
> + * Boost watermarks by ~0.1% of zone size on atomic allocation pressure.
> + * This provides zone-proportional safety buffers: ~1MB per 1GB of zone size.
> + * Larger zones under GFP_ATOMIC pressure need proportionally larger reserves.
> + */
> +#define ATOMIC_BOOST_SCALE_SHIFT 10

Why don't you use '_FACOTR' as the suffix of the namethis a factor, and use
mult_frac() for calculation, consistent to others like watermark_boost_factor?

> +
>  /*
>   * results with 256, 32 in the lowmem_reserve sysctl:
>   *	1G machine -> (16M dma, 800M-16M normal, 1G-800M high)
> @@ -2161,6 +2168,9 @@ bool pageblock_unisolate_and_move_free_pages(struct zone *zone, struct page *pag
>  static inline bool boost_watermark(struct zone *zone)
>  {
>  	unsigned long max_boost;
> +	unsigned long boost_amount;
> +
> +	lockdep_assert_held(&zone->lock);
>  
>  	if (!watermark_boost_factor)
>  		return false;
> @@ -2189,12 +2199,42 @@ static inline bool boost_watermark(struct zone *zone)
>  
>  	max_boost = max(pageblock_nr_pages, max_boost);
>  
> -	zone->watermark_boost = min(zone->watermark_boost + pageblock_nr_pages,
> -		max_boost);
> +	boost_amount = max(pageblock_nr_pages,
> +			   zone_managed_pages(zone) >> ATOMIC_BOOST_SCALE_SHIFT);
> +	zone->watermark_boost = min(zone->watermark_boost + boost_amount,
> +				    max_boost);
>  
>  	return true;
>  }
>  
> +static void boost_zones_for_atomic(struct alloc_context *ac, gfp_t gfp_mask)
> +{
> +	struct zoneref *z;
> +	struct zone *zone;
> +	unsigned long now = jiffies;
> +	bool should_wake;
> +
> +	for_each_zone_zonelist(zone, z, ac->zonelist, ac->highest_zoneidx) {
> +		/* Rate-limit boosts to once per second per zone */
> +		if (time_after(now, zone->last_boost_jiffies + HZ)) {
> +			unsigned long flags;

Why don't you define 'should_wake' here together?

> +
> +			zone->last_boost_jiffies = now;
> +
> +			/* Modify watermark under lock, wake kswapd outside */
> +			spin_lock_irqsave(&zone->lock, flags);
> +			should_wake = boost_watermark(zone);
> +			spin_unlock_irqrestore(&zone->lock, flags);
> +
> +			if (should_wake)
> +				wakeup_kswapd(zone, gfp_mask, 0, ac->highest_zoneidx);

Why don't you wrap the line for the 80 columns limit?

> +
> +			/* Boost only the preferred zone */
> +			break;

So, this function boosts only one zone per call?  How about renaming the
function to use a singular noun?  That is, s/zones/zone/ ?

> +		}
> +	}
> +}
> +
>  /*
>   * When we are falling back to another migratetype during allocation, should we
>   * try to claim an entire block to satisfy further allocations, instead of
> @@ -4742,6 +4782,10 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  	if (page)
>  		goto got_pg;
>  
> +	/* Boost watermarks for atomic requests entering slowpath */
> +	if ((gfp_mask & GFP_ATOMIC) && order == 0)
> +		boost_zones_for_atomic(ac, gfp_mask);
> +
>  	/*
>  	 * For costly allocations, try direct compaction first, as it's likely
>  	 * that we have enough base pages and don't need to reclaim. For non-
> 
> ---
> base-commit: b54345928fa1dbde534e32ecaa138678fd5d2135
> change-id: 20260206-wujing-mm-page_alloc-v8-fb1979bac6fe
> 
> Best regards,
> -- 
> Qiliang Yuan <realwujing@gmail.com>


Thanks,
SJ

