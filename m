Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 191C5C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 15:33:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E78066B0088; Thu,  3 Sep 2026 11:33:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E27F76B008A; Thu,  3 Sep 2026 11:33:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D16586B008C; Thu,  3 Sep 2026 11:33:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 965846B0088
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 11:33:49 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1DF22A46AD
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 15:33:49 +0000 (UTC)
X-FDA: 85172846178.20.30FABE0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 574AD2000A
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 15:33:47 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I3SeDa5y;
	spf=pass (imf03.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788449627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mA0IOh1RfpCCNooZGYoPdmrZBmJxGvAB5bfCvVRddbs=;
	b=rmWbzCe9k6Krxibt6diovUk6538Rv+izfPKIThoA9YT9W2rzNrysLK1vbDvIYoGwWUj2uV
	eVZL01GPExVyi9MRBYSVPgW+FZyPWl6ykQi27yqSL540lxiFF38IcxX1ohpkkd5EuBk0qp
	WSr2qiPjPVWZZy4tkO17ijos2wL4aHo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788449627;
	b=wr9kIBYLvD/C17zNsIT/YDt1sz7YbvDF7cFqJf0Y1TnMkR3NxB7kXwkI9DYBNl6HnoL22j
	Llo8wgSsHK9SexbSTv8zEeFbURf/SirJgudgwgtz2Kk4Kqz1dETtZzE5lG9mCnfVR1ITQI
	c/wgCuIxzB5eMicOiMhyDM9dND7pwzw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I3SeDa5y;
	spf=pass (imf03.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E1FFD601EF;
	Thu,  3 Sep 2026 15:33:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4ED41F000E9;
	Thu,  3 Sep 2026 15:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788449626;
	bh=mA0IOh1RfpCCNooZGYoPdmrZBmJxGvAB5bfCvVRddbs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=I3SeDa5y8FjLpHVH3jLFvHwdKcD3Y8ondN5UxOmGWi9uVCNqL/eELQoSgA+VxYHvp
	 wegZn2RAKvkr3iTkwjPZzAWvUMZgXWSUIsyfl66fOw7SmB8BeeNgxOzJIVrlhr6UCK
	 Ke7x76llpRjY3DSgmwY8jSynKJ+YqiummrJmjHyk3vSY0aTRGrCdvHszKU3bk+e/T2
	 oldt6cKBjO4Y0ZLcW9G5g2go+1nuBJEWN78bHPsDPWk75edEbdLR4vMZsnFPlttmEL
	 3LvStkS7YILFS90rKMwwQw3JLQMaMeBtQn9iin1gQ+a+z2lV+xNbTuSQtizadK/bbp
	 MY9oFNPNu1Wgw==
Message-ID: <9f67cacc-b063-48b7-81af-09858aa5dcdb@kernel.org>
Date: Thu, 3 Sep 2026 17:33:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm/page_alloc: refactor build_node_zonelist() out of
 build_zonelists()
Content-Language: en-US
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 brendan.jackman@linux.dev, hannes@cmpxchg.org, ziy@nvidia.com
References: <20260902215853.156267-1-gourry@gourry.net>
 <20260902215853.156267-3-gourry@gourry.net>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260902215853.156267-3-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 574AD2000A
X-Stat-Signature: 1k1dprds4nwseqfgmjicuyz64b89biaa
X-HE-Tag: 1788449627-326579
X-HE-Meta: U2FsdGVkX18t0IpZ4Q6hLMUSEfKeGV7JE1mQOx9PwodJnJE8tUYr1dLA66rRZm3y3//ReNon/nruxm1f2qTglGifb9X63vIMEi1GF/3soX0ZjOKTY5Asmrwx/4w+koqQ5oHFK7g3i00wUUGxaRvrf/ACCOZ5lC0UYeqt36pe7SO378m0sZWUaWW1PT5AA/7mDnILU+nZ/KKt6SJIPqwxuXY4OJvQezrfO4jrt1RXZj9XnZGjJCofc8JZq0TeDmKgWAbsFXZMSIJWzHHEhb6SZqfgEDi5uRxL8Nbnkdt8ox1tQcAIKozgzr5EYq2WQmK25LUQ/S92NB271fYCp0/4fUlHeg/9CZ0IWdOACccG34ah3NAoal2V+DAaP0u+L6ayImiAh1AtvyxeulHH5GvbmQLY0kSKRadu9uoSJcWAA252qdK3YPhnBQiW3l+wB2fG2YzrV4/HYLCJkFb+4UNF8AU13RLaoCJGp1zHdmn2afazibkq4k40hnvQSSltclflidJbLXL4p2baDTFlUPhStMlskC/sQfVNcL81GlvSJUEXK4x/pBNpNnvW60ldoJjFpRb8FAH1+RZSgarXrqMBBzLBEbOXsobNaLv1d40OVI27aEiALRDSIh+j60TNbnEBBfxHno7iU0r6IgoC8LtvtNOyrEHvyyLqvehc7kxDjqzne4PT+Tl4/dlXwPeVDDl2peIifvBh0Pcda7ovdLzbpQQzvH5aJcTllzzMmRo0w+rtUVdLC+WSavRTVoI8wHRbvVY+jVo7D4f/pGKxD2X02X2RP8lCKcG826+63MZacW8RiVTU4OwUXw0wKnGmDf4qG03KrHbiuwqQS2CoMQqn8Igpq3iYYGSPRBKl9hXEChtA8oRn2Q9bPTMO/ZYBES95In4xzYbTlUurA6e1a+9kbGwq8AHCoquDexd9GReLvyngGNhIPak2Yumnh8Oxgct/o+hpICYWMVc4BckWMCj
 QQlhCrY6
 6L1KVreqlLkmeE3H3OtUl4TM70W2APgOtSDiF27aWYeoSunXfHhcURejVEeYZwVGC/cjhkEKgdRk8CpBYyhT4+jUIzWq6U2LW7kd57rQjGBqkoQ9ZdEyperJaK70oaxKHJj5Gz+w7aCW/+MD0/gXglc0RBnnkr+pBjqDWPcKWAKgF5tcKgrKU/yPtxe1/Oqo/x5dFwhtt+vHmtOxN8EblfSqWSipIWH4+jwaaC1mDfb6iVFiPp3X5YxNFnM4E8U7W6M4zRfogREZYL3aM/2q9tladCykJcVoQEI18lYm36/i+YK16Va8W+qX6/g5SCDKc4QQ+BoTApNmn4eUGNw1MVZ9Ib3bR4+4F5/KPX5oRhLQje4E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/2/26 23:58, Gregory Price wrote:
> Extract per-node fallback-list construction into build_node_zonelist().
> 
> This lets us build new zonelists from candidate nodemasks instead of
> just the default N_MEMORY node state list.
> 
> No functional change: build_zonelists() builds the same FALLBACK list over
> N_MEMORY with node_load updates as before.
> 
> Signed-off-by: Gregory Price <gourry@gourry.net>

LGTM, but, while we're at it, could we just do the pr_cont() printing in
build_node_zonelist() itself (maybe behind a flag if you don't want to print
from future new caller) so it doesn't need to pass nr_nodes back to
build_zonelists(). Then also the node_order array could live in
build_node_zonelist() itself?

Actually I wonder if we could get ride of the node_order array completely.
It would mean the loop processing in build_zonelists_in_node_order() would
have to be done piece-meal in build_node_zonelist() itself. But seems
feasible? Depends on how you intend to reuse/extend the new functions later,
I guess...

> ---
>  mm/page_alloc.c | 44 ++++++++++++++++++++++++++++++--------------
>  1 file changed, 30 insertions(+), 14 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 4dde1cbe2fd43..e1d7c8b221d0d 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5849,12 +5849,12 @@ int find_next_best_node_in(int node, nodemask_t *used_node_mask,
>   * DMA zone, if any--but risks exhausting DMA zone.
>   */
>  static void build_zonelists_in_node_order(pg_data_t *pgdat, int *node_order,
> -		unsigned nr_nodes)
> +		unsigned int nr_nodes, int zlidx)
>  {
>  	struct zoneref *zonerefs;
>  	int i;
>  
> -	zonerefs = pgdat->node_zonelists[ZONELIST_FALLBACK]._zonerefs;
> +	zonerefs = pgdat->node_zonelists[zlidx]._zonerefs;
>  
>  	for (i = 0; i < nr_nodes; i++) {
>  		int nr_zones;
> @@ -5883,26 +5883,28 @@ static void build_thisnode_zonelists(pg_data_t *pgdat)
>  	zonerefs->zone_idx = 0;
>  }
>  
> -static void build_zonelists(pg_data_t *pgdat)
> +/*
> + * Build one node-ordered fallback list from a candidate nodemask.
> + * update_load round-robins node_load across equidistant nodes.
> + */
> +static void build_node_zonelist(pg_data_t *pgdat, const nodemask_t *candidates,
> +				int zlidx, bool update_load,
> +				int *node_order, int *nr)
>  {
> -	static int node_order[MAX_NUMNODES];
> -	int node, nr_nodes = 0;
>  	nodemask_t used_mask = NODE_MASK_NONE;
> -	int local_node, prev_node;
> -
> -	/* NUMA-aware ordering of nodes */
> -	local_node = pgdat->node_id;
> -	prev_node = local_node;
> +	int local_node = pgdat->node_id;
> +	int prev_node = local_node;
> +	int node, nr_nodes = 0;
>  
> -	memset(node_order, 0, sizeof(node_order));
>  	while ((node = find_next_best_node_in(local_node, &used_mask,
> -					      &node_states[N_MEMORY])) >= 0) {
> +					      candidates)) >= 0) {
>  		/*
>  		 * We don't want to pressure a particular node.
>  		 * So adding penalty to the first node in same
>  		 * distance group to make it round-robin.
>  		 */
> -		if (node_distance(local_node, node) !=
> +		if (update_load &&
> +		    node_distance(local_node, node) !=
>  		    node_distance(local_node, prev_node))
>  			node_load[node] += 1;
>  
> @@ -5910,8 +5912,22 @@ static void build_zonelists(pg_data_t *pgdat)
>  		prev_node = node;
>  	}
>  
> -	build_zonelists_in_node_order(pgdat, node_order, nr_nodes);
> +	build_zonelists_in_node_order(pgdat, node_order, nr_nodes, zlidx);
> +	*nr = nr_nodes;
> +}
> +
> +static void build_zonelists(pg_data_t *pgdat)
> +{
> +	static int node_order[MAX_NUMNODES];
> +	int local_node = pgdat->node_id;
> +	int node, nr_nodes = 0;
> +
> +	memset(node_order, 0, sizeof(node_order));
> +
> +	build_node_zonelist(pgdat, &node_states[N_MEMORY], ZONELIST_FALLBACK,
> +			    true, node_order, &nr_nodes);
>  	build_thisnode_zonelists(pgdat);
> +
>  	pr_info("Fallback order for Node %d: ", local_node);
>  	for (node = 0; node < nr_nodes; node++)
>  		pr_cont("%d ", node_order[node]);


