Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1A8AFF885E
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 17:19:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8352F6B0005; Sun, 26 Apr 2026 13:19:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E6336B008A; Sun, 26 Apr 2026 13:19:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FCD06B008C; Sun, 26 Apr 2026 13:19:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5EFD96B0005
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 13:19:54 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8314EA0572
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 17:19:53 +0000 (UTC)
X-FDA: 84701369466.19.1BB1260
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id E83E3C0002
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 17:19:51 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eFoY0CZr;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777223992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r+4CGsVOMiVEFflHNNE59I/LxbooZWo9/tXnXsXpzYg=;
	b=dmG9+XZEuxBgiEX69q4UYsH86dcOOR4nVmgaYG+ZPZII8PFcHWiWsFCkLLb5JvNxcLxSx2
	Df8bnwTzGyx9HP5jIH7N8n+ZHtS7zQEoXnywk4iwE4lSE/cJ8yXLbRS3XU6rU71Z3mnsg5
	ovAATu+2h0s5FLcqYbYuJeB8RNO0Eyg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eFoY0CZr;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777223992; a=rsa-sha256;
	cv=none;
	b=Ado1V0pFTx1B2C5da42MsE8juut9TxBWFDi3XgT7wIq6h6za8FQFLScwZbSiLrl/XbCmNH
	yIxAAmq7LsBK98lVUM8aePUKjJcmkEWqxeVxMQWYJGawFI1dzhNFO+rrilKSo9YQBZs3B1
	afD1KCij5dRH/k4oE5fkxdZsLSKUn8o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1E71860145;
	Sun, 26 Apr 2026 17:19:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52D22C2BCAF;
	Sun, 26 Apr 2026 17:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777223990;
	bh=lG1Berrhw8hjbikGqYFQyztxo7nbWehNH0Od6lNtYYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eFoY0CZr8kKoqAnhi+7eySYA2quK4t4kPOsEwhfU6iP+W8C5Pn6/xu+vVDwI8ldkX
	 9aa/g64vL/kSvXd5zqupofYMCl9Cq+jX4eIiZ2mKTEupYa/U5ir5mdvqX2IcNa6rsv
	 4Ht9AxiGHQKUlFHjrdPXvZOPE8z2W5E3bIXtw77zZ1g5cW1pXpbUeA+NBcd2kjM+R7
	 Q54O2vdV2XVc41XZfIk8GfGT1RPnZNsgdShFPsddRkTlInvCp1MbWU2D6/DP6vI4HY
	 54KGfsA5wrgRYXdSvSILQw33qE1QsbQ20RBVuUpp3gCFrbshhDHc/U8kii6m7DWJEx
	 +x6OILNks7EQg==
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
Subject: Re: [PATCH v8] mm/damon: add node_eligible_mem_bp goal metric
Date: Sun, 26 Apr 2026 10:19:40 -0700
Message-ID: <20260426171941.86007-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260426003245.2687-1-ravis.opensrc@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ry9xdtib7fkg54apt3aip9sdbyc5zbfo
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E83E3C0002
X-Rspam-User: 
X-HE-Tag: 1777223991-189654
X-HE-Meta: U2FsdGVkX18m/dSC6DcnQ4NSPUGIcZAq4SaGfFP3F/OoqSIwEgVtVeJY9dZF/C1QR3ZJC8QxLHduLt7R5TVJr/t1wJNn8u+yls7V48jFZaxhrjHyGUsW9vcRjDZuSBcwAVcmvIG8Seth7t+ZbXvXfVSshZ4djPD3a20m4rKmssB/Fk7tRcr2HhsYbuc/0P+8+UHVgomyt2H012sRePyUDG0FZlA5+NZ9lmYMPGP17tEeNTLFXBXzcB433yoaDBF711giIk4juXA2FG4ZKvCrL8ckhiuiV12YVgEjkvFrj/28lcDs+BAJLmPpLVawKgGl41GgXSWbSC9mRkZsGVfF1Pb+9B0DEdYLDpv/mcILdaCNpbUo1i46M6OWpXzdHpj292o0xz0oh03LOtZF6zB0KhDvd28mO37A4cEBn/aV4z2MG8lkrHGlnDDlaeyNxJrf2cxD8DSMUkxlv/G+R1uuJp53pTcalf2CZ2g1u1paaF106nNLspLfUKOGmdSWiY23HMpugnoela/Iebpj8+DHgeaMd0uIHQLPiGm1kk7tDegVtsqQOJu6Sxh5f+uL/5udrOsp5PgzCNOXDsTsMj+jnMmRrmzvyEUoQchhtrEl7Dnt7BL1ck1XAptlv3/42eSeTqXhW1qQolS4SMcKRUH378/q95S8U2hvYxOKAYoxY0nT103TqmOMiBUYIvsIclXXfwx1AD2gAGL8VK2eXAe5I1fJcS4bC+pDmClnsUi8szKzpFOLo1yCcnBzkLoKHMmJ3JqqMiwZOiFACRROUj4L/9qMSBfrI8Xv3jHs4OiumAB/G3PQIzF2It9abMx9QWJgTzEsyabrS3Ngfcny13kQerXGOooCqtqdQvPs1BTa+/d+B9Hv/eZDGlb5YXmSh36MWnHKKFUUYcgDd3ZbGvzcSd9MUwDuPRHWRYuEF5JjVmyEsKfJkR4ijvYC4vDZz4uQrw3xS3NLq7kBYPjukuR
 Lf9NcaRE
 0E2Y88YnHmqXiFZD/QzcpFRL2okYCwwxMAQ+Kb/NSJeuWvwNvPsZmCJJJZZJCqgs15GRqj7B0xEmIUDxql1gW5vZ7jYPNrTg7hdU3+dn2dt1mCVhGF0Ol8Qi8Fq0hx6qkvJ1Q7+MHWysIwFzXeQQDN5FKRA5YyAs58IdG1oTCJfEDQzpN7wkJ94iQbHMMYTijdAnm8yZcHh73e88uoLB020jg/7gy6+9K4oLtFxPKZQDCbj+wAZGXM9fQxyvQZ+Uh/wxkvMihjrMY51VB73bZHFtvd0Q+rcWdu8sfuBrLM2X0h+/O27wMOEtAUW+fluMVbzkXGZVVB2STIWLfDb9YwaTQ0/Yu8aBiX9rYhAQfXoa/+SJIF6da4U3EmA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 25 Apr 2026 17:32:45 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:

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
> Two-Scheme Setup for Hot Page Distribution
> ==========================================
> 
> For maintaining 60% of hot memory on DRAM (node 0) and 40% on CXL
> (node 1):
> 
>     PULL scheme: migrate_hot to node 0
>       goal: node_eligible_mem_bp, nid=0, target=6000
>       addr filter: node 1 address range (only migrate FROM CXL)
>       "Move hot pages to DRAM if less than 60% of hot data is in DRAM"
> 
>     PUSH scheme: migrate_hot to node 1
>       goal: node_eligible_mem_bp, nid=1, target=4000
>       addr filter: node 0 address range (only migrate FROM DRAM)
>       "Move hot pages to CXL if less than 40% of hot data is in CXL"
> 
> Each scheme independently measures its own eligible memory and adjusts
> its quota to achieve its target ratio. The schemes work in concert
> through DAMON's unified monitoring context, with the quota autotuner
> balancing their relative aggressiveness.
> 
> Implementation Details
> ======================
> 
> The implementation adds a new quota goal metric type
> DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP to the existing DAMOS quota goal
> framework. When this metric is configured for a scheme:
> 
> 1. During each quota adjustment cycle, damos_get_node_eligible_mem_bp()
>    is called to calculate the current memory distribution.
> 
> 2. The function iterates through all regions that match the scheme's
>    access pattern (via __damos_valid_target()) and calculates:
>    - Total eligible bytes across all nodes
>    - Eligible bytes specifically on the target node (goal->nid)
> 
> 3. For each eligible region, damos_calc_eligible_bytes() walks through
>    the physical address range, using damon_get_folio() to look up
>    each folio and determine its NUMA node via folio_nid().
> 
> 4. Large folios are handled by calculating the exact overlap between
>    the region boundaries and folio boundaries, ensuring accurate
>    byte counts even when regions partially span folios.
> 
> 5. The ratio (node_eligible / total_eligible * 10000) is returned
>    as basis points, which the quota autotuner uses to adjust the
>    scheme's effective quota size (esz).
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

Assuming below two minor things are addressed,

Reviewed-by: SeongJae Park <sj@kernel.org>

[...]
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
> +
> +	node_eligible = damos_calc_eligible_bytes(c, s, nid, &total_eligible);
> +
> +	if (!total_eligible)
> +		return 0;
> +
> +	return mult_frac((unsigned long)node_eligible, 10000,
> +			(unsigned long)total_eligible);

Sashiko found [1] total_eligible after the casting could be zero on 32bit
system, resulting in divide-by-zero.  As I also replied to Sashiko review,
could you please fix this?  It seems we can simply remove the castings.

[...]
> @@ -2389,9 +2528,9 @@ static void damos_goal_tune_esz_bp_temporal(struct damos_quota *quota)
>  /*
>   * Called only if quota->ms, or quota->sz are set, or quota->goals is not empty
>   */
> -static void damos_set_effective_quota(struct damos_quota *quota,
> -		struct damon_ctx *ctx)
> +static void damos_set_effective_quota(struct damon_ctx *c, struct damos *s)

Sorry for finding this late.  Could we keep the dmon_ctx parameter name?
Otherwise, we introduce unnecessary change below.

If the mult_frac() divide-by-zero is not a real issue, I wouldn't insist this
change.  But, if we will make a new version, let's do this together.

>  {
> +	struct damos_quota *quota = &s->quota;
>  	unsigned long throughput;
>  	unsigned long esz = ULONG_MAX;
>  
> @@ -2402,9 +2541,9 @@ static void damos_set_effective_quota(struct damos_quota *quota,
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
> @@ -2415,7 +2554,7 @@ static void damos_set_effective_quota(struct damos_quota *quota,
>  		else
>  			throughput = PAGE_SIZE * 1024;
>  		esz = min(throughput * quota->ms, esz);
> -		esz = max(ctx->min_region_sz, esz);
> +		esz = max(c->min_region_sz, esz);

Above change is unnecessarily introduced.  Could we keep the old damon_ctx
parameter name?

[1] https://lore.kernel.org/20260426005341.B393EC2BCB0@smtp.kernel.org


Thanks,
SJ

[...]

