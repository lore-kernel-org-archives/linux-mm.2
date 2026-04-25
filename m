Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8389FF885A
	for <linux-mm@archiver.kernel.org>; Sat, 25 Apr 2026 00:39:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 970C16B0005; Fri, 24 Apr 2026 20:39:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 921F66B008A; Fri, 24 Apr 2026 20:39:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8107C6B008C; Fri, 24 Apr 2026 20:39:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6CCD16B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 20:39:56 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 68C0CA02B4
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 00:39:55 +0000 (UTC)
X-FDA: 84695220750.27.17DF789
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8AFECA000D
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 00:39:53 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YIcMW4ni;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777077593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fSnvUoh7EyzThmsJfEgge9r8JXHQWhBZRx5zgbOpbzc=;
	b=ZNXzKpm/hcNziMJKJDVIHD4cPJmVeWmEtoddXK1GaB9hRxfu/S2X7eriLkvxJgFtDxcYAi
	Gs5AZl5uuE1s5XcRo1tL8usxuqEHFZTkbWuhpuL6FoPfwzZadH5Epfx0kUohGYw5rC8CAi
	a74brtjRxUTyWgwWHaKwGKreD5G49h0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777077593; a=rsa-sha256;
	cv=none;
	b=K57/7s0wx4OXE4KiTuTiyFoSxp6m4+d8rsCiCDIlW6TRigqKwWwkrI1C8f07Ekl7IworTb
	Xdl2nnXlHkH6lcoqFXTpjA2s2fe4L1cnZBSQEvj9WZsUjO33ykDtI6mGCAsnOhUnfzj62e
	TxzHIVvdANZQ/7W/BrEhyXcb3KbJjjU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YIcMW4ni;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 25015409DD;
	Sat, 25 Apr 2026 00:39:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 761FCC19425;
	Sat, 25 Apr 2026 00:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777077592;
	bh=uWZdeICdnNyt0raLlSy490jp95pBv/ubkvh6ZDBpJvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YIcMW4niRToZF2HXZfEBLizMX0kUQXuPp4jDBBBi2tmGrpRWx2cgEDOg9eFBG23H2
	 KXnTKs3I5k5imDDccP9oj9sYZt6wS/Hb83tPe+5k+NPTizdF88wUYhAJreAzVs5yUP
	 g3kPc74hxAv9sU+X/kjGGGm5MLoR6q9d6VyOdw/uQUQfE6XJdFDtgWrGgJoue6SOTK
	 jHMrjK2z0DHnpCdYLqo/HKlbRKJNjeHcDBYNDlfskrWz7uudyGTbIg1+j3qP6RTatk
	 OAloQf9lZA5eL1g8DHt/9bM3RdGHHTaoEGbcUG7HxAt9enQBp0kT5y/t0yyQzAjALU
	 WKdBPvp4hz7bg==
From: SeongJae Park <sj@kernel.org>
To: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com
Subject: Re: [PATCH v7] mm/damon: add node_eligible_mem_bp goal metric
Date: Fri, 24 Apr 2026 17:39:41 -0700
Message-ID: <20260425003942.85395-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260424203448.5040-1-ravis.opensrc@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8AFECA000D
X-Stat-Signature: mdmbd98s9teo6ukahnx7bai5wqe58u94
X-Rspam-User: 
X-HE-Tag: 1777077593-957480
X-HE-Meta: U2FsdGVkX1/CM61yDIcbYenE5GyvGMWQFTMZT83HhaVhuMNEQF8DSu9LnDrDt8W81xx0d5htE+1+yeH6ZSIFkDustdyN8YunI9wz1BRcePUax7RFk/ytor49juDyMSEKDIhnANmPHiiOvcXLxAQo4mHC2mBI6uNEjSAkZ21NDvZomkl84p7MkxTZfNeNpZNjl0LoWHblQQKWBgufbczaANPgpli1bbne85CFXYIips7BmlcRE038Pudx6cYf1V2UxGQyWHRHJ57t4VfhtI9V0aKhxIsoMVwhjmxSItXsUmCN6YJK+T6zbL7t5ZGkjPnl/c4pw5BEUoQowDkbnKDcnHtEVw7MMRgGsvktiR3vGkkHwkdpRpWNrCO8eSapiQVJvOoDHcLXbDiFbRtL43X2clr2wjaYMYwzPi9lkVsIH3QgwNyUrEm7r2gCkwOvRiesk/oxxCHaPAdwNnrcRlt1zDn6guS3PjQkwZiOCqt3D+lojFbkx39CG23xFZ+zyhATDKIkiYRNDNNbQxIszox6XvwGDB3GgIzWr+QirHZ//MknXFD2lGilKraHxalwgs2krCaqHovpx/7ERndg9ODqp8BgtdATdMpOz+Pk6ZoNKkW5NZ566uurAhb961wOuLJQCVDOVa9KUUV0P2AtKf7ntKF4exp48XcX3AJScMenscFc/P96SGPCliM2kEKcaZYaJNdteyXpC0VJOduYdA+H9cP9rleiLa3MSS/euFNVhuzTeWyd/1EpO94V6a4DFHN+HmR7bHnL99JrRajx8J6vbARcnqcaRzCZl/vTvJUWmUw7skjln0oMnFKndcoLJSrrIuu7GAQdPwjp2d0UOOF/rDqIA0OwBEbnOFXaQgyjRvWkdHATlOSSq/sdTuQzjb3STtll1HX5/DC6tR6oCPmKPkic62G2yebbBbwjEwZvyadxcpPgTbvDBC7H9sqiguPuBRspMbYt7qC+wJ4KKCK
 vrUWieMZ
 esH+nrgop7+luU5Ht4T7N3/4mAgZKgrIazl/rbFchBSLp/qKLK0hbJCOMQdMLiOSdIlCaAgmwrKkLP3nNfaP7v3ABZNA8MLxzOfIsjrIlRBRxA0xqIrADoNJzFsKQML99Zv4wKKXyRAQ73RG/1yGp/dOpZbiWkGLeEvfE2OAuQ9Hp6r/xZzLQrZcHd7YQAzAlYSTN2YH/3msPZ+43weM8E/1ISWE6xkXpojmspsl/smp4628dNAQzK2eu1P/K8CuRwboWs8/Bk/QiY3OhNm1fRnejYuk4xrLfLx2iYe2oBtwvUkX2MiozpJWbz1au+C7zwhSKR6zJeij2Hqha7yf5tkJnTIT9I66NvakI7ZFqOHkVSsb03GFTLFrduZj+kgw9/ffR34A1hMuWuYuCbJWoRBKEBQ1cPXPuejNTtUR5jEYxY9k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Ravi,


This version looks good, except very trivial nits.

On Fri, 24 Apr 2026 13:34:48 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:

> Background and Motivation
> =========================
> 
> In heterogeneous memory systems, controlling memory distribution across
> NUMA nodes is essential for performance optimization. This patch enables
> system-wide page distribution with target-state goals such as "maintain
> 60% of scheme-eligible memory on DRAM" using PA-mode DAMON schemes.
> 
> Rather than using absolute thresholds, this metric tracks the ratio of
> memory that matches each scheme's access pattern filters on a target
> node, enabling the quota system to automatically adjust migration
> aggressiveness to maintain the desired distribution.
> 
> What This Metric Measures
> =========================
> 
> node_eligible_mem_bp:
>     scheme_eligible_bytes_on_node / total_scheme_eligible_bytes * 10000
> 
> The metric iterates through each scheme's eligible regions and uses
> damon_get_folio() to determine NUMA node placement of each folio.
> 
> Two-Scheme Setup for Hot Page Distribution
> ==========================================
> 
> For maintaining hot memory on DRAM (node 0) and CXL (node 1) in a 6:4
> ratio (per SeongJae Park's suggestion):
> 
>     PULL scheme: migrate_hot to node 0
>       goal: node_eligible_mem_bp, nid=0, target=6000
>       "Move hot pages to DRAM if less than 60% of hot data is in DRAM"

You also set a damos filter of node type with node id 1 for this scheme, right?

> 
>     PUSH scheme: migrate_hot to node 1
>       goal: node_eligible_mem_bp, nid=1, target=4000
>       "Move hot pages to CXL if less than 40% of hot data is in CXL"

And you set damos filter of node type with node id 0 here, right?

I think it would good to mention that here, too.

> 
> Each scheme independently measures its own eligible memory and adjusts
> its quota to achieve its target ratio. The schemes work in concert
> through DAMON's unified monitoring context, with the quota autotuner
> balancing their relative aggressiveness.
> 
> Implementation Details
> ======================
> 
> Key implementation considerations:
> - Uses phys_addr_t for byte calculations to prevent overflow on 32-bit
>   architectures with large memory configurations
> - Includes cond_resched() per region to prevent CPU soft lockups when
>   processing large numbers of regions
> - Validates that ops type is DAMON_OPS_PADDR in both damon_commit_ctx()
>   (for clear error feedback) and the metric function (defensive check)
> - Properly handles folio alignment when region addresses fall within
>   large folios by calculating exact overlap

This is changelog from the previous version [1], right?  Let's put all
changelog from all previous version on the commentary area [2].

> 
> The implementation requires CONFIG_DAMON_PADDR since damon_get_folio()
> is only available for physical address space monitoring.
> 
> Testing Results
> ===============
> 
> Functionally tested on a two-node heterogeneous memory system with DRAM
> (node 0) and CXL memory (node 1). A PUSH+PULL scheme configuration using
> migrate_hot actions was used to reach a target hot memory ratio between
> the two tiers.
> 
> With the TEMPORAL tuner, the system converges quickly to the target
> distribution. The tuner drives esz to maximum when under goal and to
> zero once the goal is met, forming a simple on/off feedback loop that
> stabilizes at the desired ratio.
> 
> With the CONSIST tuner, the scheme still converges but more slowly, as
> it migrates and then throttles itself based on quota feedback. The time
> to reach the goal varies depending on workload intensity.
> 
> Note: This metric works with both TEMPORAL and CONSIST goal tuners.
> 
> Suggested-by: SeongJae Park <sj@kernel.org>
> Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
> ---
>  include/linux/damon.h    |   3 +
>  mm/damon/core.c          | 171 +++++++++++++++++++++++++++++++++++----
>  mm/damon/sysfs-schemes.c |   7 ++
>  3 files changed, 165 insertions(+), 16 deletions(-)
> 
> diff --git a/include/linux/damon.h b/include/linux/damon.h
> index f2cdb7c3f5e6..986b8c902585 100644
> --- a/include/linux/damon.h
> +++ b/include/linux/damon.h
> @@ -159,6 +159,8 @@ enum damos_action {
>   * @DAMOS_QUOTA_NODE_MEMCG_FREE_BP:	MemFree ratio of a node for a cgroup.
>   * @DAMOS_QUOTA_ACTIVE_MEM_BP:		Active to total LRU memory ratio.
>   * @DAMOS_QUOTA_INACTIVE_MEM_BP:	Inactive to total LRU memory ratio.
> + * @DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP:	Scheme-eligible memory ratio of a
> + *					node in basis points (0-10000).
>   * @NR_DAMOS_QUOTA_GOAL_METRICS:	Number of DAMOS quota goal metrics.
>   *
>   * Metrics equal to larger than @NR_DAMOS_QUOTA_GOAL_METRICS are unsupported.
> @@ -172,6 +174,7 @@ enum damos_quota_goal_metric {
>  	DAMOS_QUOTA_NODE_MEMCG_FREE_BP,
>  	DAMOS_QUOTA_ACTIVE_MEM_BP,
>  	DAMOS_QUOTA_INACTIVE_MEM_BP,
> +	DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP,
>  	NR_DAMOS_QUOTA_GOAL_METRICS,
>  };
>  
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 3dbbbfdeff71..4ac805205261 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -13,10 +13,14 @@
>  #include <linux/memcontrol.h>
>  #include <linux/mm.h>
>  #include <linux/psi.h>
> +#include <linux/sched.h>
>  #include <linux/slab.h>
>  #include <linux/string.h>
>  #include <linux/string_choices.h>
>  
> +/* for damon_get_folio() used by node eligible memory metrics */
> +#include "ops-common.h"
> +
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/damon.h>
>  
> @@ -1326,11 +1330,25 @@ static int damon_commit_targets(
>  int damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
>  {
>  	int err;
> +	struct damos *scheme;
> +	struct damos_quota_goal *goal;
>  
>  	dst->maybe_corrupted = true;
>  	if (!is_power_of_2(src->min_region_sz))
>  		return -EINVAL;
>  
> +	/* node_eligible_mem_bp metric requires PADDR ops */
> +	if (src->ops.id != DAMON_OPS_PADDR) {
> +		damon_for_each_scheme(scheme, src) {
> +			struct damos_quota *quota = &scheme->quota;
> +
> +			damos_for_each_quota_goal(goal, quota) {
> +				if (goal->metric == DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP)

Let's wrap this line to keep the 80 columns limit.

> +					return -EINVAL;
> +			}
> +		}
> +	}
> +
>  	err = damon_commit_schemes(dst, src);
>  	if (err)
>  		return err;
> @@ -2287,7 +2305,112 @@ static unsigned long damos_get_node_memcg_used_bp(
>  		numerator = i.totalram - used_pages;
>  	return mult_frac(numerator, 10000, i.totalram);
>  }
> -#else
> +
> +#ifdef CONFIG_DAMON_PADDR
> +/*
> + * damos_calc_eligible_bytes() - Calculate raw eligible bytes per node.
> + * @c:		The DAMON context.
> + * @s:		The scheme.
> + * @nid:	The target NUMA node id.
> + * @total:	Output for total eligible bytes across all nodes.
> + *
> + * Iterates through each folio in eligible regions to accurately determine
> + * which node the memory resides on. Returns eligible bytes on the specified
> + * node and sets *total to the sum across all nodes.
> + *
> + * Note: This function requires damon_get_folio() from ops-common.c, which is
> + * only available when CONFIG_DAMON_PADDR is enabled. It also requires the
> + * context to be using PADDR operations for meaningful results.
> + */
> +static phys_addr_t damos_calc_eligible_bytes(struct damon_ctx *c,
> +		struct damos *s, int nid, phys_addr_t *total)
> +{
> +	struct damon_target *t;
> +	struct damon_region *r;
> +	phys_addr_t total_eligible = 0;
> +	phys_addr_t node_eligible = 0;
> +
> +	damon_for_each_target(t, c) {
> +		damon_for_each_region(r, t) {
> +			phys_addr_t addr, end_addr;
> +
> +			if (!__damos_valid_target(r, s))
> +				continue;
> +
> +			/* Convert from core address units to physical bytes */
> +			addr = (phys_addr_t)r->ar.start * c->addr_unit;
> +			end_addr = (phys_addr_t)r->ar.end * c->addr_unit;
> +			while (addr < end_addr) {
> +				struct folio *folio;
> +				phys_addr_t folio_start, folio_end;
> +				phys_addr_t overlap_start, overlap_end;
> +				phys_addr_t counted;
> +
> +				folio = damon_get_folio(PHYS_PFN(addr));
> +				if (!folio) {
> +					addr += PAGE_SIZE;

Sashiko found [3] this may better to be aligned.  It is trivial but I agree.
How about using PAGE_ALIGN_DOWN(addr + PAGE_SIZE)?

> +					continue;
> +				}
> +
> +				/*
> +				 * Calculate exact overlap between the region
> +				 * [addr, end_addr) and the folio range.
> +				 * The folio may start before addr if addr is
> +				 * in the middle of a large folio.
> +				 */
> +				folio_start = PFN_PHYS(folio_pfn(folio));
> +				folio_end = folio_start + folio_size(folio);
> +
> +				overlap_start = max(addr, folio_start);
> +				overlap_end = min(end_addr, folio_end);
> +
> +				if (overlap_end > overlap_start) {
> +					counted = overlap_end - overlap_start;
> +					total_eligible += counted;
> +					if (folio_nid(folio) == nid)
> +						node_eligible += counted;
> +				}
> +
> +				/* Advance past the entire folio */
> +				addr = folio_end;
> +				folio_put(folio);
> +			}
> +			cond_resched();
> +		}
> +	}
> +
> +	*total = total_eligible;
> +	return node_eligible;
> +}
> +
> +static unsigned long damos_get_node_eligible_mem_bp(struct damon_ctx *c,
> +		struct damos *s, int nid)
> +{
> +	phys_addr_t total_eligible = 0;
> +	phys_addr_t node_eligible;
> +
> +	if (c->ops.id != DAMON_OPS_PADDR)
> +		return 0;
> +
> +	if (nid < 0 || nid >= MAX_NUMNODES || !node_online(nid))
> +		return 0;

Trivial nit.  I'd prefer using '!node_state(nid, N_MEMORY)' to be consistent
with the similar one in damon_migrate_pages().  But this one seems fine to me.

> +
> +	node_eligible = damos_calc_eligible_bytes(c, s, nid, &total_eligible);
> +
> +	if (!total_eligible)
> +		return 0;
> +
> +	return mult_frac((unsigned long)node_eligible, 10000,
> +			(unsigned long)total_eligible);
> +}
> +#else /* CONFIG_DAMON_PADDR */
> +static unsigned long damos_get_node_eligible_mem_bp(struct damon_ctx *c,
> +		struct damos *s, int nid)
> +{
> +	return 0;
> +}
> +#endif /* CONFIG_DAMON_PADDR */
> +#else /* CONFIG_NUMA */
>  static __kernel_ulong_t damos_get_node_mem_bp(
>  		struct damos_quota_goal *goal)
>  {
> @@ -2299,7 +2422,13 @@ static unsigned long damos_get_node_memcg_used_bp(
>  {
>  	return 0;
>  }
> -#endif
> +
> +static unsigned long damos_get_node_eligible_mem_bp(struct damon_ctx *c,
> +		struct damos *s, int nid)
> +{
> +	return 0;
> +}
> +#endif /* CONFIG_NUMA */
>  
>  /*
>   * Returns LRU-active or inactive memory to total LRU memory size ratio.
> @@ -2319,7 +2448,8 @@ static unsigned int damos_get_in_active_mem_bp(bool active_ratio)
>  	return mult_frac(inactive, 10000, total);
>  }
>  
> -static void damos_set_quota_goal_current_value(struct damos_quota_goal *goal)
> +static void damos_set_quota_goal_current_value(struct damon_ctx *c,
> +		struct damos *s, struct damos_quota_goal *goal)
>  {
>  	u64 now_psi_total;
>  
> @@ -2345,19 +2475,24 @@ static void damos_set_quota_goal_current_value(struct damos_quota_goal *goal)
>  		goal->current_value = damos_get_in_active_mem_bp(
>  				goal->metric == DAMOS_QUOTA_ACTIVE_MEM_BP);
>  		break;
> +	case DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP:
> +		goal->current_value = damos_get_node_eligible_mem_bp(c, s,
> +				goal->nid);
> +		break;
>  	default:
>  		break;
>  	}
>  }
>  
>  /* Return the highest score since it makes schemes least aggressive */
> -static unsigned long damos_quota_score(struct damos_quota *quota)
> +static unsigned long damos_quota_score(struct damon_ctx *c, struct damos *s)
>  {
>  	struct damos_quota_goal *goal;
> +	struct damos_quota *quota = &s->quota;
>  	unsigned long highest_score = 0;
>  
>  	damos_for_each_quota_goal(goal, quota) {
> -		damos_set_quota_goal_current_value(goal);
> +		damos_set_quota_goal_current_value(c, s, goal);
>  		highest_score = max(highest_score,
>  				mult_frac(goal->current_value, 10000,
>  					goal->target_value));
> @@ -2366,17 +2501,19 @@ static unsigned long damos_quota_score(struct damos_quota *quota)
>  	return highest_score;
>  }
>  
> -static void damos_goal_tune_esz_bp_consist(struct damos_quota *quota)
> +static void damos_goal_tune_esz_bp_consist(struct damon_ctx *c, struct damos *s)

80 columns limit?

>  {
> -	unsigned long score = damos_quota_score(quota);
> +	struct damos_quota *quota = &s->quota;
> +	unsigned long score = damos_quota_score(c, s);
>  
>  	quota->esz_bp = damon_feed_loop_next_input(
>  			max(quota->esz_bp, 10000UL), score);
>  }
>  
> -static void damos_goal_tune_esz_bp_temporal(struct damos_quota *quota)
> +static void damos_goal_tune_esz_bp_temporal(struct damon_ctx *c, struct damos *s)
>  {
> -	unsigned long score = damos_quota_score(quota);
> +	struct damos_quota *quota = &s->quota;
> +	unsigned long score = damos_quota_score(c, s);
>  
>  	if (score >= 10000)
>  		quota->esz_bp = 0;
> @@ -2389,9 +2526,9 @@ static void damos_goal_tune_esz_bp_temporal(struct damos_quota *quota)
>  /*
>   * Called only if quota->ms, or quota->sz are set, or quota->goals is not empty
>   */
> -static void damos_set_effective_quota(struct damos_quota *quota,
> -		struct damon_ctx *ctx)
> +static void damos_set_effective_quota(struct damon_ctx *c, struct damos *s)
>  {
> +	struct damos_quota *quota = &s->quota;
>  	unsigned long throughput;
>  	unsigned long esz = ULONG_MAX;
>  
> @@ -2402,9 +2539,9 @@ static void damos_set_effective_quota(struct damos_quota *quota,
>  
>  	if (!list_empty(&quota->goals)) {
>  		if (quota->goal_tuner == DAMOS_QUOTA_GOAL_TUNER_CONSIST)
> -			damos_goal_tune_esz_bp_consist(quota);
> +			damos_goal_tune_esz_bp_consist(c, s);
>  		else if (quota->goal_tuner == DAMOS_QUOTA_GOAL_TUNER_TEMPORAL)
> -			damos_goal_tune_esz_bp_temporal(quota);
> +			damos_goal_tune_esz_bp_temporal(c, s);
>  		esz = quota->esz_bp / 10000;
>  	}
>  
> @@ -2415,7 +2552,7 @@ static void damos_set_effective_quota(struct damos_quota *quota,
>  		else
>  			throughput = PAGE_SIZE * 1024;
>  		esz = min(throughput * quota->ms, esz);
> -		esz = max(ctx->min_region_sz, esz);
> +		esz = max(c->min_region_sz, esz);
>  	}
>  
>  	if (quota->sz && quota->sz < esz)
> @@ -2452,7 +2589,9 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
>  	/* First charge window */
>  	if (!quota->total_charged_sz && !quota->charged_from) {
>  		quota->charged_from = jiffies;
> -		damos_set_effective_quota(quota, c);
> +		damos_set_effective_quota(c, s);
> +		if (trace_damos_esz_enabled())
> +			damos_trace_esz(c, s, quota);

damos_trace_esz() seems an unintended change?

>  	}
>  
>  	/* New charge window starts */
> @@ -2467,7 +2606,7 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
>  		quota->charged_sz = 0;
>  		if (trace_damos_esz_enabled())
>  			cached_esz = quota->esz;
> -		damos_set_effective_quota(quota, c);
> +		damos_set_effective_quota(c, s);
>  		if (trace_damos_esz_enabled() && quota->esz != cached_esz)
>  			damos_trace_esz(c, s, quota);
>  	}
> diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
> index 245d63808411..f21191d31f58 100644
> --- a/mm/damon/sysfs-schemes.c
> +++ b/mm/damon/sysfs-schemes.c
> @@ -1094,6 +1094,10 @@ struct damos_sysfs_qgoal_metric_name damos_sysfs_qgoal_metric_names[] = {
>  		.metric = DAMOS_QUOTA_INACTIVE_MEM_BP,
>  		.name = "inactive_mem_bp",
>  	},
> +	{
> +		.metric = DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP,
> +		.name = "node_eligible_mem_bp",
> +	},
>  };
>  
>  static ssize_t target_metric_show(struct kobject *kobj,
> @@ -2685,6 +2689,9 @@ static int damos_sysfs_add_quota_score(
>  			}
>  			goal->nid = sysfs_goal->nid;
>  			break;
> +		case DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP:
> +			goal->nid = sysfs_goal->nid;
> +			break;
>  		default:
>  			break;
>  		}
> 
> base-commit: 277a7fae172bb4a598e0d4144ffb2ff6207fedb3
> -- 
> 2.43.0

I also reviewed Sashiko review [3] and I find no real problem except the addr
alignment.

So this looks good to me, except the trivial things I commented above.  Could
you please revision for the last time?

[1] https://lore.kernel.org/20260405184247.2690-1-ravis.opensrc@gmail.com
[2] https://docs.kernel.org/process/submitting-patches.html#commentary
[3] https://lore.kernel.org/20260424205908.CF949C2BCB8@smtp.kernel.org


Thanks,
SJ

