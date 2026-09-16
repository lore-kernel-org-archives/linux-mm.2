Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83488C982CC
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 15:57:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A32D6B0088; Wed, 16 Sep 2026 11:57:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6792D6B008C; Wed, 16 Sep 2026 11:57:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5681A6B0092; Wed, 16 Sep 2026 11:57:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 19F5A6B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 11:57:31 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6EDB81C2E2F
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 15:57:30 +0000 (UTC)
X-FDA: 85220080260.01.92C979E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id A98AEC0007
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 15:57:28 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CPmWOdUc;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789574248;
	b=7QfzZvld+7icvC6K1sX4iMuMUJ1UfVPcbcOhqX3xbiWSuHpNL0l0HPvx8f/b0vfxsfYeSi
	FitfVvrpSbT0ZtW0RoPrropJxdy5Kw8VHOaUFl4GJdES3NPj8YoWnj9H2z9/fCLBt4Mjhl
	QMAcBvayFSAr6JZ7yvyq4htrHUb9Ilc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CPmWOdUc;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789574248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XN+Zp9/GNf101whKzUoJhTi8UW65xULFMuNHBkfGcuA=;
	b=wUddROz+/MRpDMiKGQyLWMMXKk2XmPCIbwxLv4eLZXj02l0xL8fB2U38magX/I/YdznNXc
	rHp9nI25uqFcK2ordkXf+4gmGG6b/m2yncPpzWey+xtuiID3siHKGyIyXFl4tVJJyXSwFe
	mDyISEcCi6mcVjBSxvqkspTGFUAEO1g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1B3C960234;
	Wed, 16 Sep 2026 15:57:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 303251F000FF;
	Wed, 16 Sep 2026 15:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789574247;
	bh=XN+Zp9/GNf101whKzUoJhTi8UW65xULFMuNHBkfGcuA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=CPmWOdUcWYOk0Bg/VDgSvDyRu5zASVMzHcID6o5azxbk2nZhuxHgyNYA+Ppz52ohF
	 ZxqHXao6kQZKEGDPkED8gFUGKQwrYGtGsRMNmH6LhdXLgbWFu28O/mjS0Mp4z+7zqc
	 Eh2Uh+8BKqAs0R55QoRsfjjqwZZtGh3yZQk/IyPnN3azypSr1NlDux0C+635plufhJ
	 Wi5m8WQohlZVEavxVQ1Rq2xr4yJP8/rI+ANbT/P0pUQ+bm6J+klXikzHldtaY0md8m
	 IIahutEc8ADm6yAURbBhRcBF6CHpDx4r+ygMjo6mlM6NJd1WDT8F77cHs09RHsULcb
	 MW6wpuv6VUK3g==
Message-ID: <d7f162eb-4214-456c-9d1b-a8623da61b45@kernel.org>
Date: Wed, 16 Sep 2026 17:57:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm/mempolicy: stop copying the nodemask in the
 interleave paths
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, ziy@nvidia.com, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
 ying.huang@linux.alibaba.com, apopple@nvidia.com, urezki@gmail.com,
 chenwandun@huawei.com
References: <20260829015943.1258774-1-gourry@gourry.net>
 <20260829015943.1258774-3-gourry@gourry.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260829015943.1258774-3-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A98AEC0007
X-Rspam-User: 
X-Stat-Signature: jykphgkwodd63xtprx7ty96o5gep98n1
X-HE-Tag: 1789574248-903401
X-HE-Meta: U2FsdGVkX19aGK49XVImIp0FYBiRdEp6AXqwTzfyJd8jBuFYyAZuSUJppkINN3t9JzReZx6yGBfTCftvRt4rYqST5jvbN6oTJePXubTmzi2MLL20WG1qHMY0Xj3ycfLYlKzFhWnFp5XZ+x1ZV7XuFsK2irVPshXYqIr2QgBayA2lzYERLh9oRZF1Jt+oAJm3QwTNBFFOyb5H7CTVrQYtMEwrlQKAhozovq8XJEcWQhhY/lmGtcSsP9mMdsQMoYTCpDtCDqPJnR5EhlwGwd3Dj3Ec7/qz180FBp5VF/wacOgFUnc1ifC4yQkEamqbE6O6+rmeUQWYUcDljN0Q7DV3o3vh4M3EYPrL3s5f55cL68BbJHFq6Mot8wVHJlMHuDDU1Ua7wd1gP/NIT4KChQDYktD/s8JCW+NEfbndbiXmdOEIQXZ8bWCGJiNE7Lgrj1IWgT+ND1Vxmnvgaa9ra00BYE1SDU/mpjmDYk/qQwFbeUVEiKyyOElge0RPbc2+Aaqar6wovFHnKhFtTdNwHZp403vPPKpR7aCAz+I1xYRaXOLmIB4Nxh+ylsXZzb5sjsVpM0pCan0iQiAlJTt70g0lsq7lK2xlHdI7qNCRmIm6gaV6g/BtMneBUjd2lwwACQY2QbaZsf0YJvHpi+jH7TPSiXBvdQJMJIpHTMc4BrujqhskQhif8AKdTIBzGgGLJL9OIzAfPosIuUlQHtxZVCWJB+b6QVeFPx5sSZp2fVUKgHg80Ax02+ybkpgG1ysFR5+VHTP8L/U80z6OyVDhJz9C13Wyu/QO9P9xZc1P0XaZm/jHctnggyLwSvhtGOtLOg7E1knUM41hvsz3u7ZjuSPOxcmSG6yYAL1n3mnI0FO/xR8d1WifbjVyiN44GfCy6bF2o8DccJA57aMVRSO9fN2Jfmw8wo9TXhunbglnWwNGGAET5ZEOtm9tq3hbZ48/6ItJ0cerHYSHCG9j3aaQwWg
 T6Iy8eq4
 InkjUrqmOUviGoIfGygFU/FCm0y7lrugEWKmOVmm5FXGdMgmyY75lJ0Urckss88GRQrxwSsupNQinLO615QkorwwV3hLZ2Y76dXCouCSOwBZRD0iGpWorVKDHegAUby6PKnCkWuS6oQtoe/K0tr95wdT/I5oUn+RovUaKt3/gz+TPSFja3m3PH8DgXljGWitBon3fuZBeE8ah+u4oWi7Y0uteV7fSyXBRN/kGXINHCAril5ZFvXpMRal+SkaNAnpGR0les1EQhanrBqnY7XkscBda6eqx8Z6ccNvtVjmk+atwQqLpEgYwrzMTtCKKYiv+SsDjY5EyN0qEtong9mwkqZLQTZWRhYwBj5yHwnT41eNDcAg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/29/26 03:59, Gregory Price wrote:
> The interleave node selectors copy pol->nodes onto the stack so the mask
> cannot change while they walk it.  nodemask_t is 128 bytes at
> MAX_NUMNODES=1024, and two of the three run per folio fault.
> 
> The copy only buys consistency between the node count and the walk.
> Drop the consistency and just bounds check the walk instead.

I think you should document here that accessing the node bitnmap is safe (is RCU
responsible for that? I think yes), but it can get updated concurrently.

> 
> If an empty nodelist or weight is perceived, fall back to numa_node_id(),
> which is what the functions already did when the copy came back empty.

Makes sense.

> 
> weighted_interleave_nid() counts the nodes as we sum the weights. We use
> that node count to limit the maximum skew a single node can host.
> 
> interleave_nid() walks with next_node_in() rather than next_node(), so a
> mask that shrank mid-walk wraps to a node still in the policy.
> 
> alloc_pages_bulk_weighted_interleave() derives per-node counts from a
> weight total summed over the mask, so a changing mask can make them exceed
> the request.  Clamp each chunk to the space left in page_array.
> 
> A cpuset cookie will not work here: two of these take VMA policies, which
> mpol_rebind_mm() rebinds under mmap_write_lock(), not mems_allowed_seq.
> 
> Cost is distribution accuracy during a rebind - but the copy never
> corrected this anyway, it was just a safety mechanism to prevent div/0
> and overrunning the alloc request buffer.
> 
> Remove read_once_policy_nodemask(), now unused.
> 
> -fstack-usage at MAX_NUMNODES=1024:
> 
>   weighted_interleave_nid            184 -> 56
>   interleave_nid                     168 -> 32
>   alloc_pages_bulk_mempolicy_noprof  360 -> 136

Nice!

>  static unsigned int weighted_interleave_nid(struct mempolicy *pol, pgoff_t ilx)
>  {
>  	struct weighted_interleave_state *state;
> -	nodemask_t nodemask;
> -	unsigned int target, nr_nodes;
> +	unsigned int target, nnodes = 0;
>  	u8 *table = NULL;
>  	unsigned int weight_total = 0;
>  	u8 weight;
>  	int nid = 0;
>  
> -	nr_nodes = read_once_policy_nodemask(pol, &nodemask);
> -	if (!nr_nodes)
> -		return numa_node_id();
> -
>  	rcu_read_lock();
>  
>  	state = rcu_dereference(wi_state);
> @@ -2232,22 +2213,40 @@ static unsigned int weighted_interleave_nid(struct mempolicy *pol, pgoff_t ilx)
>  	if (state)
>  		table = state->iw_table;
>  
> -	/* calculate the total weight */
> -	for_each_node_mask(nid, nodemask)
> +	/* calculate the total weight and the node count */
> +	for_each_node_mask(nid, pol->nodes) {
>  		weight_total += table ? table[nid] : 1;
> +		nnodes++;
> +	}
> +
> +	/* the mask is empty */
> +	if (!weight_total) {
> +		rcu_read_unlock();
> +		return numa_node_id();
> +	}
>  
>  	/* Calculate the node offset based on totals */
>  	target = ilx % weight_total;
> -	nid = first_node(nodemask);
> -	while (target) {
> +	nid = first_node(pol->nodes);
> +
> +	/*
> +	 * The target was calculated in a separate loop, and a concurrent
> +	 * rebind can change the total number of nodes.  Clamp this loop to
> +	 * a single pass (nnodes) to keep the walk bounded by node count.

Might want to explicitly comment here that we are looking at a moving target and
might race with node bitmap modifications.

> +	 */
> +	while (target && nnodes-- && nid < MAX_NUMNODES) {
>  		/* detect system default usage */
>  		weight = table ? table[nid] : 1;
>  		if (target < weight)
>  			break;
>  		target -= weight;
> -		nid = next_node_in(nid, nodemask);
> +		nid = next_node_in(nid, pol->nodes);
>  	}
>  	rcu_read_unlock();
> +
> +	/* the mask emptied under the walk */
> +	if (nid >= MAX_NUMNODES)
> +		return numa_node_id();

Makes sense.

>  	return nid;
>  }
>  
> @@ -2258,18 +2257,21 @@ static unsigned int weighted_interleave_nid(struct mempolicy *pol, pgoff_t ilx)
>   */
>  static unsigned int interleave_nid(struct mempolicy *pol, pgoff_t ilx)
>  {
> -	nodemask_t nodemask;
>  	unsigned int target, nnodes;
>  	int i;
>  	int nid;
>  
> -	nnodes = read_once_policy_nodemask(pol, &nodemask);
> +	nnodes = nodes_weight(pol->nodes);
>  	if (!nnodes)
>  		return numa_node_id();
>  	target = ilx % nnodes;
> -	nid = first_node(nodemask);
> -	for (i = 0; i < target; i++)
> -		nid = next_node(nid, nodemask);
> +	nid = first_node(pol->nodes);

Similarly, I wonder whether we should spell out the raciness.

[...]


Nothing jumped at me

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

