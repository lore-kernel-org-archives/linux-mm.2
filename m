Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09166606A321
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 09:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lp8IreAf
Received: by kanga.kvack.org (Postfix)
	id DEDEC6B05DB; Fri, 13 Nov 2026 04:18:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9E066B0644; Fri, 13 Nov 2026 04:18:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C65E96B0646; Fri, 13 Nov 2026 04:18:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 91EA96B05DB
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 04:18:02 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 19ED5C029D
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 09:18:02 +0000 (UTC)
X-FDA: 85429544004.20.9CAC287
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 589A240003
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 09:18:00 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lp8IreAf;
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794561480;
	b=V1a9CLvj+1BOuDqptxn52ST+Ep+90k+VpsGLLjXTfF5yuj7k16ZRrSpuBY3kvwh7NQenv8
	lgNdBE0WVN8tqMoPcva8vAzk1y9IGuixCrLJhtJ7QPOugxawS7T+znaADqDNEamElbP0mN
	PZmihIrao8MmizyxPrRcK+RaGrjPMD4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lp8IreAf;
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794561480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eStupLSXeWq6p5mACFQucqZl8B+vHFCM7s/qEMYl1DA=;
	b=pnwSNoqCR5feBTeqkWIpgafltkZV33tFVx6nK3HG0kOQiv2sbK80fnqzI5CXUyPFRq1w3l
	LXzzsKonfTaVVZ91zc9NPnPVPAHH8JjZNadGIdhGxqTB4+0IdcSIyYshaaxlexIIAMqHgk
	Tru1ljkGLp7nV6Ufx4aL7QkN7YQ5yA8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AB78D612F0;
	Fri, 13 Nov 2026 09:17:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7FA51F000C4;
	Fri, 13 Nov 2026 09:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794561479;
	bh=eStupLSXeWq6p5mACFQucqZl8B+vHFCM7s/qEMYl1DA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=lp8IreAfVoWjkixVIy9DCUXHkhoExRX0F1bbq7RlUuuTLL2eI+T7WMiDI5rw6sIv+
	 Tm2Suo/+oDXFjmRwIiOnV02E4vaOWMUZ8wTK/EJAeUrdGwkD26bi30Vw8xnP/kIV98
	 u7ddgT8/w0FqgbOAedwo4GGOSF4BjyPO/jdwIfbdfuaYHbCW2mLAR0Bv8XNN52x2dt
	 RxgOs0ydh/zyJPL/0Pug88P7wSdbgFS3HkokHC8vobelXDq1P+NMXkg+e3grB/8qcc
	 jEcjzrWoR30bVGhisVhMc6gHD9Yr99w1Sdg6Ylsj6TL0yP959LlIrHJl2PfcF12YSh
	 RgyN/1I/zeC4g==
Message-ID: <ba5dd85a-20a3-4f76-a929-4fc2df8fecf0@kernel.org>
Date: Fri, 13 Nov 2026 10:17:54 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/page_alloc: only skip kswapd nodes below their
 kswapd watermark
Content-Language: en-US
To: Joshua Hahn <joshua.hahnjy@gmail.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Gregory Price <gourry@gourry.net>,
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>,
 "Jose A . Perez de Azpillaga" <azpijr@gmail.com>,
 Daniel Hodges <hodgesd@meta.com>, Andrew Morton <akpm@linux-foundation.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20261112214738.3002458-1-joshua.hahnjy@gmail.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261112214738.3002458-1-joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 589A240003
X-Stat-Signature: c9eyotgjz87qo3fs314qdei8gnsqfnky
X-Rspam-User: 
X-HE-Tag: 1794561480-534918
X-HE-Meta: U2FsdGVkX19FpOFVdxTeVlTIyPuM7vyU+i4kigM/FQWaOx3PXcqhvaI+SUtdvw+ccVyt0UGYzlEq0aFqkuY0s+1wt+eQ6jV+DB+dLLdBMe2QIO8iQp9aAgHgsoVT8geiPmSVNEBx6M0U6ZvbxpwKOL3IoypqJlltZypnmU4QzgAPtvQAyW7tn/XpDL+8nyZKreYN1gMV6iPzAEs9Wu3gBhqaZVV189r+0kT48yKTvcVS+wB+TSdRh4/g5ufuleHRtwWpUvMKZJmutSZIwWDyLkXkrYLUYVapvhpdoorRJX+aUleUpukGblaDee7Wgc689Lqo0x5hOwH08FtemZp8v+LShOCFcC4BZ3yVDH06OxqcVmubdLuMHR2ud5yxPTM1iKI9AwU1vGR3xALzkoNn3B/yj5jeYPddNSPfU2OCDIIoCTxoa4A3uIeBSeWZ7iXqhVROBxMhha8o5mCGCYNX6Ifo/VYg3ubJR3htPF42a7BiaWYJ5hz4vQFa07ZgkoNNeKRAfYu730yNkHPv1fcPONZ+fAaOgpcyY8MFmN8hvAasK+7wzon+KHpJZNz6D7/FppTPTLUWpvKC1X10+AighB95t1o2tlTTdIr18UgIVXTCFKIAnyE8/nN7oT5DZFPXqdOLKVry4mFrOlGrhKJA2BBOOYpphkkr5DDKbxSAfqODJXuiQsrTiZKIUlBdIApgmZ8ns8SQiH30OXpq7DvLmWo4ClqEuEiluZx7yCX83sR4xnDdHsL2qwajKfy89i02rTF+F7FJLQobuWBEgiQRRCwtOnF1TRsXEO0UqLchcttgVIvOLz+2iNpw+Ki0TVNuvsvvmYvku+d8gRxSatDuWhmekrnGDTQDsMRZn3SXnb2LmQz7M+WyRE7baRjkosvSoKbl/lARobyhr5oPJFXk/X0z2g5rLLPx1IOtwQ03KoA8UF5u9VR1t2vvw6n/e4p2ZtUuqoQLF5sAaL6DOps
 N10sQtDU
 xdN//TF+51gzh+IXsXFcVENYjW0OxnRdGNyBDuJVHEN0JknV4BQDE6ZVWgXaY5tVlU1S9aKKxRjoD49E0n3fFB+3izactivbDl2ynseNFJji4uj9qXUNMQDOgpRdHbIAwvDzzLhufgmrDzcCIs2PB63+JFwfmIrXxEdAebAUyyH4nS8A6NZmH+Bec+hq0BCqwmQWMW5sbvD+xOTc7Qc8DTWQPESg6iMAmq73LwY4CiEALRVvjRmGS7vs4+P9VNIPnsuz1Z2GTemp2OskEdtuNIWW7CDjWGsNcf9MeC0Ve6P4J+3TJLWCD/LasGkAUmYSYQmzt2l9g/1/ZoLDnp+oH9SV7j7RAVcIEjUXngk/H69hSAaoq7A0QVvkmdkJNe0PXHoI6Q7MYBQ7wEkWRNb9M1Q3sCjroiTExnc4ZylTEHbf5S90ThBLVqF8/K3wQcbUfao7baY22sNzLhE8hJjiWOCMptq1Wh+dMiUnoZp6uL1euRPCaUV4MVuZVwEmkB6qvzwwf0t+SBuXCigUnQKCCsDCPaJZfu1rqUmoXGAMjsfOXCKr9WzBWnNZJMKQUHwU2M0H5H7BJDdxLwUuJS2LI7HAS/twfx1MHgt1wYfWxWIdNMFyLp6yeX3cEMUO7Bpi2QXCS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/12/26 22:47, Joshua Hahn wrote:
> Commit 19c5fb83f2a4 ("mm: page_alloc: avoid kswapd thrashing due to
> NUMA restrictions") makes get_page_from_freelist() skip any node with
> kswapd running to avoid piling on already-pressured nodes.
> 
> This assumes that kswapd was woken to create free space, although kswapd
> can be woken up for other reasons, like higher order allocation
> failures. Thus, fragmented nodes with failed high order allocations will
> always wake up kswapd and direct order-0 allocations to the fallback
> path, even when there is free space.
> 
> This behavior was observed on 2-NUMA Meta production workloads where
> faults would pile on already pressured remote nodes while stranding
> memory on the relatively empty local node, causing unnecessary pressure.
> 
> Only skip nodes with kswapd running if the node is under the relevant
> low-memory watermark.
> 
> On a 2-NUMA VM with a 60G node0 and a 20G node1, with THP enabled=always
> and defrag=defer, I ran a process that prefers allocating on node0.
> With a fragmented node0:
> - Before the patch, 66% of faults were served from node0
> - After the patch, 100% of faults were served from node0
> 
> Fixes: 19c5fb83f2a4 ("mm: page_alloc: avoid kswapd thrashing due to NUMA restrictions")
> Suggested-by: Daniel Hodges <hodgesd@meta.com>
> Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
> Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Acked-by: Gregory Price (Meta) <gourry@gourry.net>
> Acked-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> ---
> v2 --> v3:
> - Shortening cover letter, suggested by Gregory and Johannes
> - Collect signatures
> 
> v1 --> v2:
> - Added a Fixes tag and separated this from the other cleanup patches
> - Check zone_watermark_fast with no flag to match the call in
>   pgdat_balanced().
> - Calculates mark outside the zone_watermark_fast check to match the
>   style for the other zone checks.
> - Wordsmithing commit message to explain the unaddressed gap.
> - Yes, this is ugly. I have another series to clean this code up but
>   I wanted this to be a feature-minimal patch so that it could be
>   easily backported. Things will be much prettier once those are landed.

Easily backported, but there's no Cc stable. So I'm adding it as it seems
useful enough for LTS kernels. But at the same time not urgent for rcX hotfix.

Applied to page_alloc/for-next, thanks.

> 
>  mm/page_alloc.c | 23 ++++++++++++++++-------
>  1 file changed, 16 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 8532af052d74b..56121c3f9c4a7 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -45,6 +45,7 @@
>  #include <linux/mmu_notifier.h>
>  #include <linux/migrate.h>
>  #include <linux/sched/mm.h>
> +#include <linux/sched/sysctl.h>
>  #include <linux/page_owner.h>
>  #include <linux/page_table_check.h>
>  #include <linux/memcontrol.h>
> @@ -3799,6 +3800,9 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
>  	struct zoneref *z;
>  	struct zone *zone;
>  	struct pglist_data *last_pgdat = NULL;
> +	enum zone_watermarks kswapd_watermark =
> +		sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING ?
> +		WMARK_PROMO : WMARK_HIGH;
>  	bool last_pgdat_dirty_ok = false;
>  	bool no_fallback;
>  	bool skip_kswapd_nodes = nr_online_nodes > 1;
> @@ -3866,16 +3870,21 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
>  		}
>  
>  		/*
> -		 * If kswapd is already active on a node, keep looking
> -		 * for other nodes that might be idle. This can happen
> -		 * if another process has NUMA bindings and is causing
> -		 * kswapd wakeups on only some nodes. Avoid accidental
> -		 * "node_reclaim_mode"-like behavior in this case.
> +		 * If kswapd is already active on a node and the zone is below
> +		 * its kswapd watermark for this request, keep looking for
> +		 * other nodes that might be idle. This can happen if another
> +		 * process has NUMA bindings and is causing kswapd wakeups on
> +		 * only some nodes. Avoid accidental "node_reclaim_mode"-like
> +		 * behavior in this case.
>  		 */
>  		if (skip_kswapd_nodes &&
>  		    !waitqueue_active(&zone->zone_pgdat->kswapd_wait)) {
> -			skipped_kswapd_nodes = true;
> -			continue;
> +			mark = wmark_pages(zone, kswapd_watermark);
> +			if (!zone_watermark_fast(zone, order, mark,
> +					ac->highest_zoneidx, 0, gfp_mask)) {
> +				skipped_kswapd_nodes = true;
> +				continue;
> +			}
>  		}
>  
>  		cond_accept_memory(zone, order, alloc_flags);


