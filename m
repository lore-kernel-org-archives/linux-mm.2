Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FEC5CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 07:32:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D2676B0005; Wed, 27 May 2026 03:32:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 782BE6B008A; Wed, 27 May 2026 03:32:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BFCC6B008C; Wed, 27 May 2026 03:32:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5CFD26B0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 03:32:54 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F19EB12051D
	for <linux-mm@kvack.org>; Wed, 27 May 2026 07:32:53 +0000 (UTC)
X-FDA: 84812383026.22.A2A63CA
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf25.hostedemail.com (Postfix) with ESMTP id 58032A000D
	for <linux-mm@kvack.org>; Wed, 27 May 2026 07:32:50 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PCCWz1j4;
	spf=pass (imf25.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779867172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YFls7SMJ02XKWGF99vSkvxNkfAWR2qq2XwYkVeiy+vw=;
	b=pO2v5S9dNYdV+TefMxz2yteRhbKQVoo2s3tFTHNj1Xw1PV8xnUi5UoVHlIv61UUP8rx+i5
	NoX671/8UWvrMBuyncXXUQqszuZcAqvzo8vBGoIgwXZhmoK0CzxLQIk2a085ynsmif9Wa4
	KrEwi0+ZWkTaOy7oz9Ja+aXqNiMq6aE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779867172; a=rsa-sha256;
	cv=none;
	b=Z60MJhb5K88zzCfLo9jMt3NJMWwUssxhKa6fzwSG+oKaw337WlxDelUAMT/zo/j7HdQCsU
	kGLULEGUsEOCIe+37dlKYWzZ4zxjqmKpt/wCvbe9hDu7lSkX4Lu++uf9AsDkHQzzwI1+pe
	N68IQHlhfPhMwmKHyk5DI95OVt4uymU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PCCWz1j4;
	spf=pass (imf25.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Wed, 27 May 2026 15:32:39 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779867166;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YFls7SMJ02XKWGF99vSkvxNkfAWR2qq2XwYkVeiy+vw=;
	b=PCCWz1j4mW3PNJnnTeEbWMBbkf0qRUvPxxxLRYR7FXDXUD8H1wd5TFr7te9ET+1LBlOxxz
	2oWaltWYrqQlnGaulkhjMgm46jeBcdHAaiSsxkUyHV7jx4L19CmHkNrpCU0ERdrB+Y6evb
	smGKlfO2ukHe0xg+jswt3ARvH7drz+U=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: Youngjun Park <youngjun.park@lge.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	baohua@kernel.org, gunho.lee@lge.com, taejoon.song@lge.com,
	hyungjun.cho@lge.com, mkoutny@suse.com, baver.bae@lge.com,
	matia.kim@lge.com
Subject: Re: [PATCH v7 4/4] mm: swap: filter swap allocation by memcg tier
 mask
Message-ID: <ahaeFxC6BzXnLqhc@MiWiFi-R3L-srv>
References: <20260527062247.3440692-1-youngjun.park@lge.com>
 <20260527062247.3440692-5-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260527062247.3440692-5-youngjun.park@lge.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 58032A000D
X-Stat-Signature: cwrpudp3wkhd3ismqixuwp8ykcfz4dwz
X-Rspamd-Server: rspam06
X-HE-Tag: 1779867170-520077
X-HE-Meta: U2FsdGVkX1/SfIKSJg9dTBR4V7+/zQOc+pyKv2hLooUbJrQSOrUGV/hhGLHa8vDPzgtWg8Qwo4AmtaTW7k9D918jdUaCTPssd3ap8lydDY23XOdujtQIyj3uIPzqHywoF43TuVswtoWEtXopC2A2p/mUI1PpYLONbSBsTD6/gomylzBq/fEb8Ag+D34I6t5ZKeB9oTKSvWrqyj4LYjU/mwt4/GS07LSgLzVLMhAIeYZW5khtDPqahIBze1xlJo32RImj7HZABO1abo0bF6wcwd4s749J2FXb1iUu6UpKER716ArwVkhCnums0IUsYEz4iF3RXuNHcDAIobQ5+a5n2FFW/Ezmgc0qcaPDgIsdUsPM/HF/aRRnT5vaMmxsgw45tuCy7zauPy/jqPI/e/mTz+Hs6YzEBK0qZIfugeFUGvGnwJ2Bm8y0ngCmR8FdiFlQLtR9GHFqJe8QrQATlGrRC/3ZYa9vPYSPtpM6r2I1SlDrNp+AzGoxDeIk3xrlBzzaQ4ShkZKOy7KDEeJsaYyZuCV652Ssxp9T5jlrlvv6twX3N2UoKD32THpRIY17hlX/iRunnGwUAnFkQfjtHDOaEY0m/G00JU1z2lFBBj1OgXKLZuNHQoPVNETAECbRKuKEu/L6IzQkXOmUMICc2qrlDKCIdv+qGa4FEYQuro0phRzTEcAXib9HU2lIZTM53E6KZeaQEwTu497P8G33Vz3q0MwOEeQxjVMYSJNrI+eK/6/fVUVOnN0zZ3GEXkuLTqPL9cIljvdijut/NBmUTi1p2BKdGSeT7N+pxRI/YeOr6QsFRtogzbzubbHkA3h8vREUjy5Ik2aUXxev/wSq+87o/KBjTOjftFkZ7CiCZpUQD4PNbJS0t1G77SwyoTgYkmHS9TYrWF86ueJUkTm9mDZvX95TIE36Ce3/3MvGFIW/pB8c0cOz1xzlsVsjNmtg/4zsCL5kLxsNpTQlVKh2TAa
 VCOxSZGk
 Ox3TVXi6m54f14wmG3kbV53WVCB727u0CAGmSfswe8lyvBvMlVk9rp1CpMvYclrR28xhqu4xWmOfHilwJSJwh1Jh4rk+7darvByGuOeEKRSr5GoQNtdWWVN9Pk8dIslccwep7oPi+vzWmqBTFBwC9f83C6lWmrJSBl7+UaxUCbbcprvDTFkTMBphVwV+DZjVhlKg5fEQfmnzEVAJEDVU3OD14EVVZWwl7xjhpKd+wsidpX2cy+JtglW47YmUz5W4fpoVH85uY+cpgw8Oo90q+yDZzjA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05/27/26 at 03:22pm, Youngjun Park wrote:
> Apply memcg tier effective mask during swap slot allocation to
> enforce per-cgroup swap tier restrictions.
> 
> In the fast path, check the percpu cached swap_info's tier_mask
> against the folio's effective mask. If it does not match, fall
> through to the slow path. In the slow path, skip swap devices
> whose tier_mask is not covered by the folio's effective mask.
> 
> This works correctly when there is only one non-rotational
> device in the system and no devices share the same priority.
> However, there are known limitations:
> 
>  - When non-rotational devices are distributed across multiple
>    tiers, and different memcgs are configured to use those
>    distinct tiers, they may constantly overwrite the shared
>    percpu swap cache. This cache thrashing leads to frequent
>    fast path misses.
> 
>  - Combined with the above issue, if same-priority devices exist
>    among them, a percpu cache miss (overwritten by another memcg)
>    forces the allocator to round-robin to the next device
>    prematurely, even if the current cluster is not fully
>    exhausted.
> 
> These edge cases do not affect the primary use case of
> directing swap traffic per cgroup. Further optimization is
> planned for future work.
> 
> Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> ---
>  mm/swapfile.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)

LGTM,

Reviewed-by: Baoquan He <baoquan.he@linux.dev>

> 
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 9a86ebe992f4..1a2d29735b71 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1365,14 +1365,18 @@ static bool swap_alloc_fast(struct folio *folio)
>  	struct swap_cluster_info *ci;
>  	struct swap_info_struct *si;
>  	unsigned int offset;
> +	int mask = folio_tier_effective_mask(folio);
>  
>  	/*
>  	 * Once allocated, swap_info_struct will never be completely freed,
>  	 * so checking it's liveness by get_swap_device_info is enough.
>  	 */
>  	si = this_cpu_read(percpu_swap_cluster.si[order]);
> +	if (!si || !swap_tiers_mask_test(si->tier_mask, mask))
> +		return false;
> +
>  	offset = this_cpu_read(percpu_swap_cluster.offset[order]);
> -	if (!si || !offset || !get_swap_device_info(si))
> +	if (!offset || !get_swap_device_info(si))
>  		return false;
>  
>  	ci = swap_cluster_lock(si, offset);
> @@ -1392,10 +1396,14 @@ static bool swap_alloc_fast(struct folio *folio)
>  static void swap_alloc_slow(struct folio *folio)
>  {
>  	struct swap_info_struct *si, *next;
> +	int mask = folio_tier_effective_mask(folio);
>  
>  	spin_lock(&swap_avail_lock);
>  start_over:
>  	plist_for_each_entry_safe(si, next, &swap_avail_head, avail_list) {
> +		if (!swap_tiers_mask_test(si->tier_mask, mask))
> +			continue;
> +
>  		/* Rotate the device and switch to a new cluster */
>  		plist_requeue(&si->avail_list, &swap_avail_head);
>  		spin_unlock(&swap_avail_lock);
> -- 
> 2.34.1
> 
> 

