Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FE82FC5903
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 07:16:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A92986B0088; Thu, 26 Feb 2026 02:16:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A405A6B008C; Thu, 26 Feb 2026 02:16:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94CBB6B0092; Thu, 26 Feb 2026 02:16:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 824226B0088
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 02:16:34 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 30CA3C3182
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 07:16:34 +0000 (UTC)
X-FDA: 84485749908.05.9B486A0
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5D5851C0008
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 07:16:32 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="wJIa/rzI";
	spf=pass (imf20.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772090192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mivwzEjvoVllGSbUKSkxFH5flC9gyyg1MxM9PNByEN8=;
	b=0LpnvUNKvGKip3SClovrITdZd/U+C5vCoD7M+h3xDib3CGRU/Ytf+txlBMxVx71uHQMtSK
	5ne2bYs+r263IA5Juxut0zNyteD0ZPcYkS3FkmlH4EOaPCzOrdhVNRndTIQJDI6/ovoQX8
	FVK3ntnNRT/OKJuNvnBMyuRibdwCCrc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772090192; a=rsa-sha256;
	cv=none;
	b=nRgYffMwVJ7NMcUZi583DfbArK0dAOkH+y3s+6XL/OPkUay/i4b3B7vASE/dBN7k6RIKh2
	e+kPGyKRfTGHN62SsB208wKNwLZuXs2tSzerp7rwakIfblRUbXugTCnE3SeOjaVuM37yNC
	NNJsOGuM7qwX7Fbndtx5HBM59uwxBgQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="wJIa/rzI";
	spf=pass (imf20.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <835ed9a0-da93-4e34-b967-f91954a329b8@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772090190;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mivwzEjvoVllGSbUKSkxFH5flC9gyyg1MxM9PNByEN8=;
	b=wJIa/rzIJlol6i7Jpp/4hOVMUvSMkMcB8/t2fq8UmOaMSPh6yCohpnIEH6GP7nalM1AOSR
	zcdYehCNqtbJljqyPEr0akwlCKcuUG53ZM8Ahz0lXQ4vtIxryujMK9GUrFBIuHPfq5MzlH
	g+vvRC70OajQC8DxtY9m1oOns4Qq72M=
Date: Thu, 26 Feb 2026 15:16:13 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm: Do not allocate shrinker info with
 cgroup.memory=nokmem
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Andrew Morton <akpm@linux-foundation.org>, Dave Chinner
 <david@fromorbit.com>, Qi Zheng <zhengqi.arch@bytedance.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>
Cc: Jan Kara <jack@suse.cz>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260225-cgroup-ml-nokmem-shrinker-v1-1-d703899bdda4@suse.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260225-cgroup-ml-nokmem-shrinker-v1-1-d703899bdda4@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: r88jos37jk81bzfd87hb14k16aiyb4k3
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5D5851C0008
X-HE-Tag: 1772090192-69387
X-HE-Meta: U2FsdGVkX1+O3wIY2Ju2NMl9ULs14CD5Rbvi7mqOXQ9n9CHppUmBuq/jarQJmIjfeb1cMJNMIdzNWBKSFl2mAOLx2Mckpsg+rArfGePjojuhvno0eNbaX1ROAS/NiDIvrKcwMw0ZWZOVULQTfFPDLSDs53hv4SNaxaiRQYdo1UeM/U3Md8V6Cbo4OIyuqqi3V+DXg7BGJa3Va3xLgWay9t8tm+zFt5C48Ldz1hloM7qo5pFQszbaUpPbiP6bigMxdwd+uhbWfwoHZc0VFfYnh0PqUZ3rfhO2dQZ9uS5H01sz0ii+vQeylETb7KQikj8VDfUx5jtSOERsYH1wLPJlhHvOuwoqi3eE/EkZrYIFoD/Yg6mImiIysDB1WlFDXYMEWVPj+cToOJxZnlmkHVtbKtR76DVpJ2c051NhSM82STHVW5xFluolUTaXgS0iGMv6yhv+CyH1t6dLJoUtYHXMV6LRpslffi7Wq893NxGauk8zrdZtsmOuDGgFOxl46KtpMLs6ONnztOB7fkz5haYA2mBdOh1j5WhbDaQUpxiROVs9K3wNpF+D5aEXVryago4kKOnMc1Nx9hhsou9MhoeNaFpy4uQpxWOhonI6VcgVp9m5/CsEmYqIaFMG8wZwPgvwL1JvChiu1XXSPlz5zBWGXH1QSHyN+Nn6OWSwZJrA/JOdjBDakyfLjBfghIeNeZIXxuFdUUZh3cr/r//mm+3GJP9w+bTCq2RuxmKZUHqzicye9kIzx31hEV7NeauIAUfM58ESP6o7ytn6NYsDx9/ciEvPuUsWB+xo4VUDQmdutaHez61MfjuPRkzAIcId08f8DFmh3GXsClQ234VI4Anj7DuMyhYNFjnzj+1Cn58iaBv+E6UGA07ZdI7+oEv19iNSClGgrkgQL8tmmTiSY+mdC2WbnRINhSgFr/NrZmZYGx5lMHeUX1SoBclOHToQ8IsOG7cCgOOwMXRJsBKgiD+
 71Flbdaz
 pbgQd4sBSoG+4f4lQzPAFuHwwxy11GXw82sNCJZnoIePvxmXkZWdqYWR5znaL0aSqxH/NKWKkqZWyZDNoaRl1cNIuvmzEdt810Nr05uFSQrUqTBlqMOTqgmUtX23mXaXbTva7fKPM3xuJaW7/qbAe0JmgpSqZMxWXAOqfyPD/5H7CKKY3HQkmDv4iv0uZp6tnWPNaUvUa0T6hMoPsvczTwLJPsgb6sGQKRCg/1nfwlhck0h3IozJZEnPYS8pvpvOxcEmcvpHcnZDXl0e1/nYXEx11GPViAJgQVEjtUS2DOVTYj4GXTl9kN8UWsgP0+ggc6y8L
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2/26/26 2:38 AM, Michal Koutný wrote:
> There'd be no work for memcg-aware shrinkers when kernel memory is not
> accounted per cgroup, so we can skip allocating per memcg shrinker data.
> This saves some memory, avoids holding shrinker_mutex with O(nr_memcgs)
> and saves work in shrink_slab_memcg().
> 
> Then there are SHRINKER_NONSLAB shrinkers which handle non-kernel memory
> so nokmem should not disable their per-memcg behavior. Such shrinkers
> (e.g.  deferred_split_shrinker) still need access to per-memcg data (see
> also commit 0a432dcbeb32e ("mm: shrinker: make shrinker not depend on
> memcg kmem")).
> 
> The savings with this patch come on container hosts that create many
> superblocks (each with own shrinker) but tracking and processing
> per-memcg data is pointless with nokmem (shrink_slab_memcg() is
> partially guarded with !memcg_kmem_online already).
> 
> The patch uses "boottime" predicate mem_cgroup_kmem_disabled() (not
> memcg_kmem_online()) to avoid mistakenly un-MEMCG_AWARE-ing shrinkers
> registered before first non-root memcg is mkdir'd.
> 
> Signed-off-by: Michal Koutný <mkoutny@suse.com>
> ---
>   mm/shrinker.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/mm/shrinker.c b/mm/shrinker.c
> index 4a93fd433689a..7d7302619b7f7 100644
> --- a/mm/shrinker.c
> +++ b/mm/shrinker.c
> @@ -219,6 +219,8 @@ static int shrinker_memcg_alloc(struct shrinker *shrinker)
>   
>   	if (mem_cgroup_disabled())
>   		return -ENOSYS;
> +	if (mem_cgroup_kmem_disabled() && !(shrinker->flags & SHRINKER_NONSLAB))
> +		return -ENOSYS;

Make sense, and can you help update the following comment in
shrinker_alloc() as well:

         /*
	 * The nr_deferred is available on per memcg level for memcg aware
	 * shrinkers, so only allocate nr_deferred in the following cases:
	 *  - non-memcg-aware shrinkers
	 *  - !CONFIG_MEMCG
	 *  - memcg is disabled by kernel command line
	 */

Otherwise:

Acked-by: Qi Zheng <zhengqi.arch@bytedance.com>

Thanks,
Qi

>   
>   	mutex_lock(&shrinker_mutex);
>   	id = idr_alloc(&shrinker_idr, shrinker, 0, 0, GFP_KERNEL);
> 
> ---
> base-commit: cd2e103d57e5615f9bb027d772f93b9efd567224
> change-id: 20260225-cgroup-ml-nokmem-shrinker-7da42fbcf8f2
> 
> Best regards,


