Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA0D1606A330
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 01:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m8pfWXH+
Received: by kanga.kvack.org (Postfix)
	id B25546B00EF; Fri, 13 Nov 2026 20:45:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD5926B05B0; Fri, 13 Nov 2026 20:45:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EADC6B05B1; Fri, 13 Nov 2026 20:45:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3B1AC6B00EF
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 20:45:54 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EE1B81202AC
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 01:45:45 +0000 (UTC)
X-FDA: 85432033050.03.9A7E33C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5FB99140007
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 01:45:44 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m8pfWXH+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794620744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nzPTEwjVAGuMkVeVrNJQmCZCNrgNkk2JW836iQoERSA=;
	b=vdzYlMIzCjQExRg6yCouEW2MjwvFMlZNmxCuHHqAYjB6wLK8jyisc8miHVJjg+y4uI1JfV
	O2+xAphd5kKM1/zmK3p7Vf8CC1H0pQuydcvojyTfbv8LO0iJYM3u1TQ9woKtmo1gouw4k8
	8iCB1k/XO86Pea61l+0bhhmVh/ooXoo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794620744;
	b=TPf3fMe6zfbkt5hcFwnnwzPCsQ1cmY8xVXmAexTxWFFTCT4sqLptBd8BwyV/hjMRu+cJAe
	3yef3LiuZAzNgx7pL5BVwcFufymU9rDfc0SOp45ggTLzK97SzDIpai0Kc/DjXKoIHNAVK7
	xTv9P442zOixKhrGWsNFTq7Ts2zOzJw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m8pfWXH+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8DEA544D3C;
	Sat, 14 Nov 2026 01:45:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA5771F000CB;
	Sat, 14 Nov 2026 01:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794620743;
	bh=nzPTEwjVAGuMkVeVrNJQmCZCNrgNkk2JW836iQoERSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m8pfWXH+rSDRwQSOjLLF/Q6INjVXDQL5TEoFbCOqKpbQGW5ysfXQEW/nFkDp8febQ
	 IHdRoij07Wk1WIqLcxgXUzLjma2NNY71GGr/fBxhOh0kwZJJmj2J1nCpfi6PVxu/bd
	 eZAvtUAGJVVkLg6yKDCfHzQUkgG78h587qs6lxux0a0Hq358ztgqXuIQDPKPyyRara
	 6xWVrRnaVeizg3nr5CeKVJB7oikQlKk45IoVmmrmie/gcrcUZqqELC1dVCuBEHIp9h
	 fvxDCE0OTeOBBJQ5WyEMd150kaDCwOecpzwK/vysmFbrewyNiBbN00oaak5frHdFwY
	 wC9dMf9xIgzIA==
From: SJ Park <sj@kernel.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH 2/3] mm/page_alloc: move the kswapd node skip check into a helper
Date: Fri, 13 Nov 2026 17:45:29 -0800
Message-ID: <20261114014530.86361-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261113235238.3595412-3-joshua.hahnjy@gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qkq8r9r4y1nno8sjfbhpcik3y6zwjz6p
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5FB99140007
X-HE-Tag: 1794620744-701836
X-HE-Meta: U2FsdGVkX19ugGQEI/EJSdzflmYPpnYTZrUT5L1zINWBxbogImbh2H0JWixpJ5Xgzt/po8S5yDKqPdVpPG7kId0wy8v89fMW4G8L+xgEkVVwOiegJJASCL5RaCmGOVVuKH0/cHn13ddJc2opqW7yNA4XEk03+8kVhP5I/K1y7CMoI0Wkk6qCLSH+jGsYaBl+54mZncOZmQJVpFE63WUYyqv8+zR/jWQ7T1p/E4c7lgU6Pz2bcTmWGAj5D99dCBCflneZpyBe9iEzCQQk17uMcJdeJhpW+GF6jTqvnXTseK/42aBCkoexi23LnwPJQhT2FAJ+WTxE2ODeuIPDsz6Bdztaj4hH5w18wIXG21s7ee5CjpKNKG93xeYAySaL3qCNTd8d+NqajyRRLjyXo1M410s5EhXV7lk/cGXdzNU1p0S8k+t6e1Md2INVHm/B/IjlPsxlojGrjjrCmJOFq5Q1FxEv1hrGnY+PVvZxnJF0Havi9vZmbZaqnGUbJLCn/lK/4PqOCBRxhMNRGGJflNB1gjPj2+EZbqarQfMjsyeDUyOQDc18bdxpOtETeHwVzk16tGi3lTT3nBC8sFb2FMcfLgKKfr7AGXbzHH2CFtUlHw4lhw7OFpvIfXlvfyHZqOnPoltBkWRJaIIm4jiELMPhAkhJ6CURCrXy62H58012fK4u94N3RLDjCJjkenxQ7gc1wN82SFPTsanJwwuOXRSKPfCVchJSlHLgeeWXv+JyWymvOs9SBuIpphl3oMy/D7bEsFYEx6pQsgEpx6NFzBKYYLve49iJTKHgvY1Sbqx010hN7Juw1hvfow2u64B0lgHTwpSy4ANe0FMhDZUi31Vnidy6PUdvLIGJFN9gjOV/6MHoa+Gx7ViVI8/legFRPHCUbyiOQyobN4r0plHzRAyqxrJ5/C2zdAio42GwVpPNJdGIj5V0eZf8T05LkBcwhJPMzCYOgkLXfws9qtMT3bx
 6mpjFi1P
 M6Szgw/+y3n61di+h55Ur/mLXRjASQf1mD4clKJMcxwAXzi+uak5LlW8DhKIbgdtBrMnpNZNAXmZWZGa3r7DjoOBKBoJQoQmRRSk0FhvtAxGWiutd/U52GoMnVg5dZkJxHcOHNiVvbTKtlFJ1oHmRSqoMNA6BDTlYORQwsbQ0xxi7/6uGrxkUo7UQ2Tf3z/khDDeh2iRSuMNOo8hIFdmeO9otRhMw8Q3LCYI0OCP/SwJYNBnF5TV40EPI+2XWOn1CM6CuOxDdE9P2H9clRNqejQpP1r/rbQqmR6MjQRcvCZV1twZwJ4ZOYOccgtpibUpuiwJe+qsWSqe2/LAIRWxLS6FMZhoVNea3WciaaMOhxyv9DE0U6TowplJtBuFivMzAAaHX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 13 Nov 2026 15:52:35 -0800 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:

> get_page_from_freelist() checks many conditions for each zone, often
> with a big comment block explaining the conditions.
> 
> Move the kswapd check and its comment into should_skip_kswapd_zone() to
> make the zone iteration cleaner to read.
> 
> While moving this, also resolve a checkpatch warning which complains of
> a waitqueue_active() call with no corresponding comment explaining why
> the lockless use is OK in this case.
> 
> No functional change intended.

Looks correct to me.

> 
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>

Reviewed-by: SJ Park <sj@kernel.org>

[...]
> @@ -3865,22 +3885,10 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
>  			}
>  		}
>  
> -		/*
> -		 * If kswapd is already active on a node and the zone is below
> -		 * its kswapd watermark for this request, keep looking for
> -		 * other nodes that might be idle. This can happen if another
> -		 * process has NUMA bindings and is causing kswapd wakeups on
> -		 * only some nodes. Avoid accidental "node_reclaim_mode"-like
> -		 * behavior in this case.
> -		 */
>  		if (skip_kswapd_nodes &&
> -		    !waitqueue_active(&zone->zone_pgdat->kswapd_wait)) {
> -			mark = wmark_pages(zone, kswapd_watermark);
> -			if (!zone_watermark_fast(zone, order, mark,
> -					ac->highest_zoneidx, 0)) {
> -				skipped_kswapd_nodes = true;
> -				continue;
> -			}
> +		    should_skip_kswapd_zone(zone, order, ac)) {
> +			skipped_kswapd_nodes = true;
> +			continue;

Just thinking loud.  While reviewing I realized this patch is not based on
mm-new but apparently mm/page_alloc.git for-next.  I should also update some of
my setups.


Thanks,
SJ

[...]

