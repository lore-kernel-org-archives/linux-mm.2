Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59225C43458
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 08:43:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D9536B0005; Sun, 12 Jul 2026 04:43:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B1236B0088; Sun, 12 Jul 2026 04:43:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C9C46B008A; Sun, 12 Jul 2026 04:43:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1CF6C6B0005
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 04:43:35 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A5AD01A06C0
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 08:43:34 +0000 (UTC)
X-FDA: 84979485948.30.5AF9693
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1930320003
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 08:43:33 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="kY6U/KCA";
	spf=pass (imf13.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783845813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oip8/L74rePX2kCOX9iUEXROqX3ZFpWrMwHT4YHp2mI=;
	b=ft1KUL/QWOZ+0LhaUTLgIgQcBc8HwgX7lyNsnhtPZe20i9qKtrSjT9sK8aV0B5bZe+GwMB
	EOk/LixMCOZRuTQwyTYVvhF5IXRceUEz/W44o/v3qsM+xQYrURUMpaLoq2C64pUncZgUgE
	73e9HLUtlRUuVfcltKPyjGK6M6Ulodc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="kY6U/KCA";
	spf=pass (imf13.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783845813;
	b=peJlYhY+mkBMlk/2U/Mfj6C1vykrk1G77OBkhAYXWE8E7ElEhBJYuuWxglNU8s5L30l6fO
	wSUwHces/bI7MVzrAG+djYsny621e1NHRuK1cA9bwjiJu3FjPlpNyeggCxxUHgQxWTOAGB
	KWrmthGWEVF4vutprt8qrusZAd+h37c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A7A69600AA;
	Sun, 12 Jul 2026 08:43:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A3FD1F000E9;
	Sun, 12 Jul 2026 08:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783845812;
	bh=oip8/L74rePX2kCOX9iUEXROqX3ZFpWrMwHT4YHp2mI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=kY6U/KCAOMBDsMm89Apzuf6levNSIlhw3O32oTCKrYEr63zQ52LCoaTop2h+6CKKc
	 4SjauLHkova8qYu85Ru55QA6IpQbZ8ripGCMcmbtfG4KlPDm1k2hERb+LZ2Se2mXwf
	 woLVRZm6b4iY3XkOZBcyt34vZRcZmI7aPCSwGfsjFK3OT6eO6UME/+zxfDU34YP+kz
	 DQlXlK4KLmzTL8MwbOPhyuzEb9vNrspf3o31zlCmf/YTa4ENgO2DzQlhYxQK++/Mr2
	 mZGe9VR+gH6IfRKXUddKno3nnnSMgKy9B391cyyNaKK9J30NqFFpheyK2f3QQTvd/f
	 OwII0S5DYsM1A==
X-Mailer: emacs 30.2 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH] mm/memory-tiers: cache top tier nodes
In-Reply-To: <20260706204507.98522-1-joshua.hahnjy@gmail.com>
References: <20260706204507.98522-1-joshua.hahnjy@gmail.com>
Date: Sun, 12 Jul 2026 14:13:24 +0530
Message-ID: <yq5apl0sk383.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1930320003
X-Stat-Signature: 5yd34y69sw34ue16fyfk1d7ypcwwzir9
X-HE-Tag: 1783845813-949927
X-HE-Meta: U2FsdGVkX18terZMCPFG3Ha16wBLc3PtBeu3gAg6p9hdims79c7fcm5T5oHed/Zn4RoHNY9kw7L+Rq8T/aWR0IsKRb1dNh7Wosqv4RYxeMh1AHT0rnjB2MIha/EyT1+4Lo0b8vhJmgFWjzRo7RzHY09eOwMG53v7is8dUR2X60IP/G18mdqf5rEXU4oodRsfBLCVYIGQXDeSPFxblRrIybE7ZHis2YpaWYPP/jTkmLNVxTD/n5ovOO6gth58cW01fAu1SafLbFcWdjt2xQrew/u/ZPc96UIXtv3Z8SuXh+U6MZhS2Rhhgm/lDrwpBciMqr60iOPw5ckD2NMBi6z3vU+aSkJGRB7Bs6RrA7AhUbJTBRTjR7rhQvSib+6Amahzn2lYwmjSmGjEvTtSA99vLy2eRZoMDg/MQRpbd/0/JwVEqRkTxQ67vhRKZ+kw37pVxT7bmo9A01eB/03CIeLSGLm0CK/+fgqjZtSq9Ou3PhrIWUR/oI3AOLPVvFHIDIyKNSWF6yfP8hRD1DpE+Q9ahxVb9Y7pcuWIOwFs9tzRbOV+EbllnRM+zf7CPHC475k4CLzYWrHaIOnuNorl3+oqUrz7yYHtvZ1KWg4mOo6bIOMjueb8wvO5s2tBi0zJuET7wYZfPAY9O5xqCFpkie68ApuwRSSeypLW1drxVoFkRamlp/BWMmIOp8EV0+RYiY3843q2ZlMTfwjftv2t+tu0kMT2wRNOPS+pR+WWPQYekkg9XWBGzMv3Ha68Ou8Ra17k0qQ53eKSKCNYvtiTURjEJzNOXcXBbemTugElzwZGISX7gqbwfZKpmYuESr6vbHe2tfYdhlVFXk9ly+exWgjf4cjn6fhibkzmiQPBISuZv0YA0/q/Q2sUFRrW1TBXKJgl/Sde9jbNhnXeM5NJvHJ9x1G2njzmkkrlNUNqM59V+K5QBvwpbGEebZz4kHexGcJHfleSS1ejmbf9qYTDCJ8
 X4hJXCgW
 ZN1+TA2lITpi/3iZeoy6IyL6djHcoiEWroMtbPsDwz8sAIE8hAO6QgmWi+ehtBKDA3DwjuFMO8+2HN9/CyVd0oZoh6xQzvDjpwifp0KfRgXiE5BYsketjd81vz8zEOUgJB6te0g/uPKLJhJgAi9hH0tKWYHlNa2mhfa8xHhMDdWQ5AdRiWu7JVNM9qndmpUzH7rFba+mdY+3p+Y6WS1xuOWHOnUscTiZYgbAN9F7paa1CxQoaGDJACfG3dkuLM8s46hEzNTZaOdjiCcJfU7nzLDdfZ6gHsZx7NwtxIGSgmOyjoqx3Yv1B848XNw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Joshua Hahn <joshua.hahnjy@gmail.com> writes:

> node_is_toptier() is called in a few hot paths: task_numa_fault(),
> should_numa_migrate_memory(), folio_migrate_flags(), etc. Each call
> takes an RCU read section and performs the tier distance check again.
>
> Tieredness for all nodes only changes on memory node hotplugs. Instead
> of recomputing toptier nodes inside each of the hot paths above, compute
> it only on memory node hotplug events and cache the results.
>
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> ---
>  mm/memory-tiers.c | 36 ++++++++++--------------------------
>  1 file changed, 10 insertions(+), 26 deletions(-)
>
> diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
> index 54851d8a195b0..2e6e02ec1fce4 100644
> --- a/mm/memory-tiers.c
> +++ b/mm/memory-tiers.c
> @@ -71,6 +71,7 @@ bool folio_use_access_time(struct folio *folio)
>  
>  #ifdef CONFIG_NUMA_MIGRATION
>  static int top_tier_adistance;
> +static nodemask_t toptier_nodes __read_mostly = NODE_MASK_ALL;
>  /*
>   * node_demotion[] examples:
>   *
> @@ -276,27 +277,7 @@ static struct memory_tier *__node_get_memory_tier(int node)
>  #ifdef CONFIG_NUMA_MIGRATION
>  bool node_is_toptier(int node)
>  {
> -	bool toptier;
> -	pg_data_t *pgdat;
> -	struct memory_tier *memtier;
> -
> -	pgdat = NODE_DATA(node);
> -	if (!pgdat)
> -		return false;
> -
> -	rcu_read_lock();
> -	memtier = rcu_dereference(pgdat->memtier);
> -	if (!memtier) {
> -		toptier = true;
> -		goto out;
> -	}
> -	if (memtier->adistance_start <= top_tier_adistance)
> -		toptier = true;
> -	else
> -		toptier = false;
> -out:
> -	rcu_read_unlock();
> -	return toptier;
> +	return node_isset(node, toptier_nodes);
>  }
>  
>  void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets)
> @@ -497,19 +478,22 @@ static void establish_demotion_targets(void)
>  		}
>  	}
>  	/*
> -	 * Now build the lower_tier mask for each node collecting node mask from
> -	 * all memory tier below it. This allows us to fallback demotion page
> -	 * allocation to a set of nodes that is closer the above selected
> -	 * preferred node.
> +	 * A node stays toptier unless it belongs to a tier below
> +	 * top_tier_adistance, while each tier's lower_tier_mask collects the
> +	 * nodes of every tier below it so demotion page allocation can fall
> +	 * back to nodes closer to the selected preferred node.
>  	 */
> +	toptier_nodes = node_states[N_MEMORY];
>

Won't this result in a larger window where every node_is_toptier() call
can return an incorrect result? This change would make every memory node
a top-tier node until the loop below clears them from the toptier_nodes
nodemask.

I assume an incorrect result from node_is_toptier() is not too bad, but
is the performance impact large enough to make this change?



>  	lower_tier = node_states[N_MEMORY];
>  	list_for_each_entry(memtier, &memory_tiers, list) {
> +		tier_nodes = get_memtier_nodemask(memtier);
> +		if (memtier->adistance_start > top_tier_adistance)
> +			nodes_andnot(toptier_nodes, toptier_nodes, tier_nodes);
>  		/*
>  		 * Keep removing current tier from lower_tier nodes,
>  		 * This will remove all nodes in current and above
>  		 * memory tier from the lower_tier mask.
>  		 */
> -		tier_nodes = get_memtier_nodemask(memtier);
>  		nodes_andnot(lower_tier, lower_tier, tier_nodes);
>  		memtier->lower_tier_mask = lower_tier;
>  	}
> -- 
> 2.53.0-Meta

-aneesh

