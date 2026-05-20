Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08EB6CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 09:35:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D9416B0098; Wed, 20 May 2026 05:35:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B0E06B0099; Wed, 20 May 2026 05:35:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C6D86B009B; Wed, 20 May 2026 05:35:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 50F676B0098
	for <linux-mm@kvack.org>; Wed, 20 May 2026 05:35:38 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 16E98140247
	for <linux-mm@kvack.org>; Wed, 20 May 2026 09:35:38 +0000 (UTC)
X-FDA: 84787290756.15.2F1F292
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6A03E40010
	for <linux-mm@kvack.org>; Wed, 20 May 2026 09:35:36 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="GetjQ/uU";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779269736; a=rsa-sha256;
	cv=none;
	b=7WaBarAXPeDyu7QM9DtnYr1eK/r+dA8sMyuERz4vN+rIl3QxBLIpBmXpXfdMvn20tcjml5
	EJWmQK/3U3ScduohOYOCUXtUA2jvtYubtDkkOejYf2TEl9OB35SjSCd2R2m3vt4GHr4vct
	ii6VrWypEx9WC33a4X3Yvy6NP0DTJms=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="GetjQ/uU";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779269736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cKQ8TEy4a/F3xgQZDjI4b33O37xBHC3B7sYri3TaWOE=;
	b=VYkid5Z3S/uP7EP7g0zuSAyfqgVW8YJNwZR2qu7RCuA/LpimsvAjg+R8CAJdXyRydVzCcp
	z2985YuQiR6vN78DINmgHdumO2zBnqb+Wa3s7kcU+8zqoxL86o8OZQB83sSwtAxkTGrWpR
	O3KwwDKc0YQSIFNfxKFi9Ojlv9usXp4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C2CB660129;
	Wed, 20 May 2026 09:35:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A48E41F000E9;
	Wed, 20 May 2026 09:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779269735;
	bh=cKQ8TEy4a/F3xgQZDjI4b33O37xBHC3B7sYri3TaWOE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=GetjQ/uUxGQgtxfzq+bLELhGxJlEL0BVV0+a8LUQgyPJ3AEyqrBND1etreZRkq8ZL
	 20qfHoY1y4dT1DYsR8cp2k7AGGPczNbv0JeUp12TxGJZKXu6MFRZBU0P02+JUifixp
	 bBaeGTe2q4gxahkVNvRP8alEP+x3AeFii0RE9Jj7Mq2UVfKJujaKIxy255sm7J6tps
	 JeLYFmsmnoolpvXsYYrB09OcH266m9xHJKZUDlUH+gx/CsIlpX2OGd2RTfl46CCnNC
	 WNnoGjWlEd0ZOj7v+FWkDSE2yR52+88zQf+z+jPHaBdYK9vplZwOu9BitMhaww8gTP
	 nmEkJG02q872Q==
Message-ID: <4e20f643-6983-4b6e-b12d-c6c4eb20ae0c@kernel.org>
Date: Wed, 20 May 2026 18:35:30 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] memcg: multi objcg charge support
To: Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
 Alexandre Ghiti <alex@ghiti.fr>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel test robot <oliver.sang@intel.com>
References: <20260520053123.2709959-1-shakeel.butt@linux.dev>
 <20260520053123.2709959-5-shakeel.butt@linux.dev>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260520053123.2709959-5-shakeel.butt@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 9dbs3rqape1miyuy43d5hu6n5ipw8c58
X-Rspam-User: 
X-Rspamd-Queue-Id: 6A03E40010
X-Rspamd-Server: rspam07
X-HE-Tag: 1779269736-156470
X-HE-Meta: U2FsdGVkX1+XOmy4CyffIePBgkVCE+F/LTGp5X10qjfsXkq9oO646VHFNKpXSlM3jLAjrcrL2v6eV3GneonPQjh4vtc02jmvuNuMb7qm32aLb4O2vbvrYy89/q0CAiBBUSyv9xCoTUyH6wH9WUHV0MNBmM+J58M8+3JxH0m4gezbcTOsAtB1sxvmI1WTc9I9/W5IAVH8i2WBpQ64KkJ4VH7bgoCR0Av95AzaAOR/tXSLgs9LN5Cn3Imb0bWImzJiB/+lOV6D/rZzktRKLsJSq5ux5+YsqMsR8hEQCt64YZi3/Jwc0mxRsiRF57lw4sSBT1AvMRRE1maeOLjnhJYAPBAP5LMP1pu3KgBZ5Pq+o1Upea9tOE1+nI3wzW4bb+dZJRv+gkz4d3DOa/BpN61b+N0lA4HPNfOM1n80MNjQ1ZCvzZDS9bs2GgNuKUEklzfjrCgZHZSkD0sZ7esQBLflshXgIO0ZHzuSaHyReaacQZK7bKoyix5Agq2QCh1laLYNbcuVgLIBqpMZcMmReMokmFeNoqN2WYfeUghvDwIri11aYW+3+rHhw5rUVg85tsLJqagGKkuwgjac/kI1EGjEyPtV/0S4FEnY3AlxDw0YXHGvwEnChlx9hi3zEH6i9UkJjkOrgfXsGzt2N/qavvXZ9tAcg6MPFQSm6BpEGigSeQ6OgP2KkV1W4X9qGNLpuTPkReWmZULPKS8LDkim5b0WMvY7GuojEjinU8iNOMVrDI7ZuFuUfDhxPP8320QBDQwtanE4tlaEHCkkgs/Bgg8WmOS5QBuVYF9FvxVkhqzu61r753IA+FUKCaYqfk/RBJJed90eMydT09i+1roqPbaA+1X3UBfHWbwL9Wy3AZtBA0aaaCxVgkaowzcx7fnfrjd9+3A6m/eZAeYYpu7rICSMw3YjYIkZi86ZWAJLshLC8MWdJOI67LB5qHdFzCmKJClP8FyNpZ59VEAdgiTur7F
 zznxd+f2
 lDOO+n2YzuTZJPfn2Y/KNcnGggw24nP47UQzTDbfodxHyiSLbL/Aa4LnB0Gv6jnk7OpIxpSK0Z+Qs4u30QBQjLrNwMa6b6xITGSOlcfg/4FlJjzh/MsKT+u3+OvgQbO1XsA3/g6KqbPDeeOyy7ZCnDxKrtvYC1Uld3mVItU7qlfCye7RZ9uS2K1A2/7T2eLz2NQetXD28nXoxPU90P5JUW/2mylux8hFoFKjijtj475njXnptE6X79ALsiFfrwgiUQn/rzyAlCB6ueT3z0kP1nqO7IUDb1+xag5aJgmEKJbnXJNwvUWLYFvO8fDxi4A/aAtdnFEl4qI0+9aiLlQUjy/FfyFdXULCKhOohACUdBNzWXIwggu6wI5jTgA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/20/26 2:31 PM, Shakeel Butt wrote:
> Commit 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg
> per-node type") split a memcg's single obj_cgroup into one per NUMA
> node so that reparenting LRU folios can take per-node lru locks. As a
> side effect, the per-CPU obj_stock_pcp -- which caches exactly one
> cached_objcg -- thrashes on workloads where threads of the same memcg
> run on different NUMA nodes. The kernel test robot reported a 67.7%
> regression on stress-ng.switch.ops_per_sec from this pattern.
> 
> Mirror the multi-slot pattern already used by memcg_stock_pcp: turn
> nr_bytes and cached_objcg into NR_OBJ_STOCK-element arrays, scan all
> slots on consume/refill/account, prefer empty slots when inserting,
> and evict a random slot only when full. With multiple slots a CPU can
> hold the per-node objcg variants of one memcg plus a few siblings
> without ever forcing a drain.
> 
> A single int8_t index records which slot the cached slab stats belong
> to; the stats are flushed on slot or pgdat change. With NR_OBJ_STOCK
> = 5 the layout (verified with pahole) is:
> 
>    offset 0  : lock(1) + index(1) + node_id(2) + slab stats(4) = 8B
>    offset 8  : nr_bytes[5]                                     = 10B
>    offset 18 : padding                                         = 6B
>    offset 24 : cached[5]                                       = 40B
>    offset 64 : (line 2) work_struct + flags (cold)
> 
> so consume_obj_stock, refill_obj_stock and the slab account path each
> touch exactly one 64-byte cache line on non-debug 64-bit builds.
> 
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Closes: https://lore.kernel.org/oe-lkp/202605121641.b6a60cb0-lkp@intel.com
> Fixes: 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg per-node type")
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> Tested-by: kernel test robot <oliver.sang@intel.com>
> ---
> @@ -3350,19 +3405,45 @@ static void __refill_obj_stock(struct obj_cgroup *objcg,
>   		goto out;
>   	}
>   
> -	stock_nr_bytes = stock->nr_bytes;
> -	if (READ_ONCE(stock->cached_objcg) != objcg) { /* reset if necessary */
> -		drain_obj_stock(stock);
> +	for (i = 0; i < NR_OBJ_STOCK; ++i) {
> +		struct obj_cgroup *cached = READ_ONCE(stock->cached[i]);
> +
> +		if (!cached) {
> +			if (empty_slot == -1)
> +				empty_slot = i;
> +			continue;
> +		}
> +		if (cached == objcg) {
> +			slot = i;
> +			break;
> +		}
> +	}
> +
> +	if (slot == -1) {
> +		slot = empty_slot;
> +		if (slot == -1) {
> +			slot = get_random_u32_below(NR_OBJ_STOCK);

It would break kmalloc_nolock() because _get_random_bytes() uses a 
spinlock. perhaps prandom_u32_state() should be sufficient in this case.

Is there a reason why it uses random eviction, unlike multi-memcg percpu 
charge cache?

Otherwise LGTM!

-- 
Cheers,
Harry / Hyeonggon


