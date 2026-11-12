Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 782E1606A33F
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 19:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eXTAheRB
Received: by kanga.kvack.org (Postfix)
	id 4F9186B05DA; Thu, 12 Nov 2026 14:56:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 483456B05DB; Thu, 12 Nov 2026 14:56:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 372246B05DF; Thu, 12 Nov 2026 14:56:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0D54C6B05DA
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:56:05 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8A6CF14111E
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 19:56:04 +0000 (UTC)
X-FDA: 85427523048.03.A599E4C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id E4212180002
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 19:56:02 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eXTAheRB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794513363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/DVz9TcMzmRhI4NAq0Bx3DDA+PaOD3fbYpa1xG77J98=;
	b=qvkAXd+dJfyZGXasPUnCe4LbpKMiALZyQTSTW8x1daAMBnS+U7glN0DGR7QP1yRF3/z9YA
	qcLl6D5Dd8+mRtgyLwRSSkzdmEnV88YxyOCsenA2JwRXFb0BYbOsViioNILcfNQWNLbCQn
	7BwOErOvKbGBOsiJBD2w/wKUhv7SD0U=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eXTAheRB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794513363;
	b=2sRyxBurGlduaV97hH61hHJrhq4ozDYDIap7hRlLvZoAZaXS4h8ctagsar6EBmFoSOuJbg
	puvOY8hGQwIfFQJqi3j32279HxjcMPkfsMGXK/1tt5f00GMZT+ETBmw1kJXfX3uVMnR+yR
	lRr4D7aYh0qO14JT4KsBA1bJwFKik8s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 582186110D;
	Thu, 12 Nov 2026 19:56:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04C4D1F000C4;
	Thu, 12 Nov 2026 19:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794513362;
	bh=/DVz9TcMzmRhI4NAq0Bx3DDA+PaOD3fbYpa1xG77J98=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eXTAheRBiXvSIWFMTLXBhb3k8aCTQf5sIn3X3vLWvl1WBSbLRGNP0YplzVv8SOypX
	 DtGLthT7Qi5esc4ctzgtSrhoMOXpbVbotkhM1fjdltQjdvwgDWZ3gWbJsXmClNMsP+
	 cHZHoB2RkkveFBPonlCc0X23P8hmYiUX9BJw+Ybhxpkxj4ZqmxM8+47qtcuKUEmxwz
	 dMIinoOq+ie1zHHAlNURtxmtlx5c6Jd68l4BgLCYGA4T1IKB7TB63JUWJjkXZzgOGj
	 EtAX4DJOCTWU4tTjW5G9+Ps+vqqTQX0xqbnO6PEP0rFdsmWT7aTSwGFUxij5TpRspd
	 HNWbvB8Y5tJRA==
Date: Thu, 12 Nov 2026 19:55:56 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, 
	Gregory Price <gourry@gourry.net>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v2] mm/page_alloc: only skip kswapd nodes below their
 kswapd watermark
Message-ID: <avYQcqVZvRevtCxM@gremlin>
References: <20261110224432.2347606-1-joshua.hahnjy@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110224432.2347606-1-joshua.hahnjy@gmail.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E4212180002
X-Stat-Signature: w8wyeipnn34mkfwn9p45gp7h9q5uuzb4
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794513362-288607
X-HE-Meta: U2FsdGVkX18USK3Qg21n2v5GOrxMPNHWj9gqb+yGUMatONGBiuzDrva/KF+KLsC1Q9a7UimUJq30xjk7kNw2HjMEYD0NBpH8TM+1MRDKTgl+h1xFJhZipLvXLJu/2mgnJtbCeNHfOOyBGKS14KN/hb5IuIb6pZe7twAukQl/F/+ERLZoMOfe8MMvhj9ezOYfOwEk2lpjsKwqMG47CyEAbMDd7MzqctwO5i99dH1xM426kZ6oeQ1Fh1MrDM95f+WdGRRMG/cChTSvgDF/o/xeuXovKiwivRMvB1OkRFLnRbm79temXS7gUzjC+NeU2BUvK1dQfNqQ2HP9IhamNwTLquUm/ZleHtQrUU9es25XBIX63sfrORtNWv4c3xAEITFPHYCpTCYii7xMPikcA+NaaXWXWiTU/TzGXWzGSsxNlcZ20qCSxRQurb+fmNUPmHkQq9i4rDBLAs0kEznBha+A7H+8vgeKyQUALoxWE06E6+JWtaBBbw2zsGXA47dJa7YrQK6x0PCqH4pXc/uX9U6OBo/k+KlKsla3L0KSO0tMdGJeM/xdj1tuFgRCmn0l0HryVpRhvDFpk6B4i91MVMhlfls/Ej+l0c9hckRHrCjB088UvoYqAqLVxHy2PfHEJduGf7PYglAucWhLzuktl6cCn0Ocxzxi0hH4LVVOwZ31Siydj4/Dw+AA1dI7Dsu3p3DuDTvNIn9ZBiFylLYIEyFNoNhUCD5YgmRe3jutGPRJS3+7WnPMGLS3GrJ/sT93AvKdOuhFHW7XTdfQxqXTrQGtc0RGalKzTofM7WKu02k90igEyu/QHVdcbzNbHuVuGfbh+V0K420pYmJ7YaX0xtix5PNSMxgCSr6RjsoOgWcqHFdWdlvn93fj6+2cdK2IrDy+0auqo/+5B1skmKUjnZsekpblw/MFD+IVcaG1kqsTfqt72iLUlT4LXpTEXg2ezaIi1BeeAAP2k2TznPi877A
 0/ya3e61
 MLkA+nR6hDQNZP5zsFaFf30CJHlmImfJBjQam7Robo3pXmFU833OGPRqW0nDNNGeUn6zWHyF46h0+bPihc495XYSgK4bg8XrySkplJAHVUpupmp7HX+LQfBnSH75dYJd2lvxkw5/IBDhA/nxvf09q+NQGO1E14TQ9TOZ0yqaulCpRboPB58uYrShNGBY3gq5Ok/uTZ6TdXUtNYrxsxYzh4t6/ucDdYr66TwVWggV+Up1h7B0My2Ls0Dry+1/szSoAhZZFDIq1602LtTTKZe8j4mSJNTszv7zIXo/E8j3VRuoBNc7ymzqzLOb9PITzaNbYd4oplQyCkO8oZ2rO30QHHMCurTjqvoGXQ8cPJSRwKzqq0+mXhZmtcNyvMITF77pl7LGhdeVwJ5oOVH5d7H89fvyfVv/+aFucZh6bIYZqYhPLrjFtWMTyG9iCYpJkd84q6aD6fFGQjs7j3X04tfQx+LY8bnnEjShES4t3d4u2Lg/vbYwkXFzcr17UfBm8fcCu9LMM1UJxpwJQeXb3VXDimkmdUiZBI0NVpmrh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 02:44:31PM -0800, Joshua Hahn wrote:
> Commit 19c5fb83f2a4 ("mm: page_alloc: avoid kswapd thrashing due to
> NUMA restrictions") makes get_page_from_freelist() skip any node with an
> active kswapd on the first pass through the zonelist, so unrestricted
> allocations don't immediately consume the memory kswapd is freeing.
>
> But kswapd is also woken for high-order requests. With THP defrag set to
> defer, each THP fault that fails on a fragmented node wakes kswapd at
> PMD order. kswapd reclaims a batch, wakes kcompactd, and sleeps until
> the next failed fault, so it stays awake much of the time even on a node
> with plenty of free order-0 memory. This means those order-0 allocations
> get directed elsewhere.
>
> This was observed on some Meta production workloads running on 2-NUMA
> systems, where processes with a preference for node0 allocations
> continuously allocated order-0 pages on node1, despite node0 having
> hundreds of GB of free memory.
>
> Only skip a zone with an active kswapd if it is also below kswapd's
> target watermark.
>
> On a 2-NUMA VM with a 60G node0 and a 20G node1, with THP enabled=always
> and defrag=defer, I ran a process that prefers allocating on node0.
> With a fragmented node0:
> - Before the patch, 68% of pages were served from node0
> - After the patch, 100% of pages were served from node0
>
> One remaining gap is that since this uses kswapd's own threshold,
> unrestricted allocations can take what kswapd frees above the target
> watermark. The current code already lets such allocations drain from the
> high to the low watermark while kswapd sleeps.
>
> One potential solution, as hinted by Johannes in the discussion from the
> original fix [1] is to add some kind of fudge factor (for instance,
> wmark_pages + high_wmark_pages - low_wmark_pages).
>
> But in tests that I ran in a VM where the allocation demand outpaces
> kswapd, about 4% more pages landed on the busy node and kswapd reclaimed
> about 15% more, but kswapd still finished and slept. So let's hold off
> on the fudge factor until it becomes an observable issue in workloads.
>
> [1] https://lore.kernel.org/linux-mm/20251001164131.GB1597553@cmpxchg.org/
>
> Fixes: 19c5fb83f2a4 ("mm: page_alloc: avoid kswapd thrashing due to NUMA restrictions")
> Suggested-by: Daniel Hodges <hodgesd@meta.com>
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>

LGTM and:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
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

Much better thanks!

>  		}
>
>  		cond_accept_memory(zone, order, alloc_flags);
> --
> 2.53.0-Meta
>

--
Cheers, Lorenzo

