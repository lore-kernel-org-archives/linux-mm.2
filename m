Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB162CAC5AE
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 17:50:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C4CE8E0003; Fri, 26 Sep 2025 13:50:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09CCA8E0001; Fri, 26 Sep 2025 13:50:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1B568E0003; Fri, 26 Sep 2025 13:50:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D9D688E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 13:50:09 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8A8E41A0721
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 17:50:09 +0000 (UTC)
X-FDA: 83932140138.25.856A213
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id BEAF7180011
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 17:50:07 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="iP/0kHkA";
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758909008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kg1pw56CZO1jFQNT/WXskMh/z0sxgn09NbpPNb5SaOo=;
	b=FqAKK4l4W3MGGq5wSToHy0/afMfu6h0Dl9zljVIK59EBvbSZC6fO725zwjPJEQsCEFZkKz
	zw8X4HjvrXT58TtHldq1dXTUlfF5T2Ud2sFcHQM0CXG3QTxAq5dKIMnJRx4g3VKHWTWVEN
	JZEqUPPTA2F2nHrwV9ZZT7aaK/iKsW8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758909008; a=rsa-sha256;
	cv=none;
	b=trp344i/CLCiec3EpwRmBpvxyO9FGyMvVNWuTtA8wn8R6H/f7Y82BN8wEUuVOqXmXpqb/C
	hK0z43vnFGGEVYK0Sd0N7zSaoY5DDUx7ejlTktp+mztkq/rAy7a4fDCEp16KMbvWE8hDdU
	ohZN4/1Xr9WH+fG8JQiSD7UcwZsUME0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="iP/0kHkA";
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9B0334323B;
	Fri, 26 Sep 2025 17:50:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FC5FC4CEF4;
	Fri, 26 Sep 2025 17:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758909006;
	bh=SNVyu5gv5hl8E6Qx2wc/yrakuqwwjH4Ub9je2xkzgaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iP/0kHkAX2Ih1cjA6REv4/yQ/PVDQLisR/NNCt3epWOJp4WR6kWUJN/yZ9paUrlTq
	 QOT8HRoKT6acsywhGEG6G83EZqi0f5E3Ql0m4tfodVM2sVSnCNIlGfXLXuQj/7rY5s
	 14dD8pJ5yXexC0GAyCwJIvxlo1wBR6TnPpvGKg6GdkXTkgg0GCwKdy/1yZpLiLpukD
	 lI1Yrandmm1t1SbyfKYzOdUX1WdTo65t/lOpXO7W0h35vgCj4oeU/gbJKwQlWJ40qK
	 wZARlWd05vyx1cx8OEaxwmqy8kQ8VUvLVZrtIcXEToAdBMT8TO0FpEmrsKte6s4C/e
	 d4JCzshH5uDmw==
From: SeongJae Park <sj@kernel.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Chris Mason <clm@fb.com>,
	Kiryl Shutsemau <kirill@shutemov.name>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Brendan Jackman <jackmanb@google.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2 1/4] mm/page_alloc/vmstat: Simplify refresh_cpu_vm_stats change detection
Date: Fri, 26 Sep 2025 10:50:04 -0700
Message-Id: <20250926175004.54610-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250924204409.1706524-2-joshua.hahnjy@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: doizm9t6nr9io18d43fnisjk6oq8ps8j
X-Rspam-User: 
X-Rspamd-Queue-Id: BEAF7180011
X-Rspamd-Server: rspam10
X-HE-Tag: 1758909007-55895
X-HE-Meta: U2FsdGVkX190YU6NSt7zBLaIL5JwEnHpI9AzP4/JBzc1n2jcZ4RS62fC+7VjDj77D/WyJHMFzWtnv0UUcLOWRD65n9+NPTbW/K+n2CPG/5oL0oAetg9iDKmMCULJkci8z8A+SPOIA5sTAwHR74lU0hQjRT4spbDpjS7UZnlYWYirMD8hMo1qu6m33lCLJP+z4X4pLmWej8B/0CC+3pnNTHeb/xbTlcIta+TlDzBJ9gfKMdCeboToLs3cVk1xohsIFNvO5iO10KfrLdK3IwzMyCBfH8tVlw+keT2jZuTf6EZms+fnwIZzqhy5TeKhVnEJ/iyD9DhFsgTNFbnMGQ66abM6P9UBZuSPQS3w7wjNliZInkzRgukgODsXZEjfP6nPBc3gE9QGuBqP6JfCK7y3tMu8MVZeqQG2stXg5vxqR7lRejAJB6kGqX3jmPfI+EWnryAB/sPhP0Aual2ymXSjewYlpGAzNhSp+D8T6x4aI0vYHf4OeFZgEfUlorrda4EZTB4TYGONz1BVS1nr+2+KOwjXtljDMwB2cimM8LbBSwccGy6Icie5gqYygmUsZBW46i7CNPWRiEqo4fdAKLTjeumGJS9B++vZDE1HsXybgAxKFWVHsLUM8laHCkGkjOI4/9b7iSuWdmdLCvghDZCMwNq158he15+/eOxKqXgHf9C+nWmaq6Kkdhzo3cfb96jL9KrnYRQzgGDxrX4C+mLLzzO3AY4Oh7+rx8LnsESnJLkbYP6PcF7pJF7uQVMA7VWy/sm2cvd6pUyA0qSrZF7gUZW3QA5bfn2/D1/Ae0233NspfqS07Ci6kmr6chjQcgy5abCvxjU4RcJJSkdPCg3o6tnT/RY1pFZiaOYjjlYXivGIaFtfKemw4KKPdtYjRgQP+bwAClwPV9YrMSwCyPmHhXedv9NTJqwv6jq4t7F56kyORc0L72mKb+laUbr+wCxWRVFmFf+3Z1JGhGBvO1Y
 8GDXnqoV
 5/aFlm3GuZf08OyZqpL9dBoaIHXMzqp+v0mo0n/oqB7V3St84pwUX0MA2WaSWOQWhf4o6NoTqF+88zFelhLt8XuPJRRbO2bsbuQxSBoiFAdpLnj2zG/Gk6GQotZkG038M6AW+K93WNOXODzd6FLILrAtCuPLDADnmadwJwfi21KLqLdpMVLETychQ+aPq1PaTUgTO88b+am2cGicP84TOBEjXgg/DlRWiBrKK+AjHI224fnxHNKxC0PH9wwbImPzKAnm+2muNbdPzVSGflG3WtiAea3H/+bQZyPlPzaRJdgvc9dD/tm3lWcaR5ACUQUfzQPWRX6ZOBI6tab6w8SKoXYKQW2Imf6F4GHTFt36a5UqQccf6+PILFQIuGRL4dxm8vncm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 24 Sep 2025 13:44:05 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:

> Currently, refresh_cpu_vm_stats returns an int, indicating how many
> changes were made during its updates. Using this information, callers
> like vmstat_update can heuristically determine if more work will be done
> in the future.
> 
> However, all of refresh_cpu_vm_stats's callers either (a) ignore the
> result, only caring about performing the updates, or (b) only care about
> whether changes were made, but not *how many* changes were made.
> 
> Simplify the code by returning a bool instead to indicate if updates
> were made.
> 
> In addition, simplify fold_diff and decay_pcp_high to return a bool
> for the same reason.
> 
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> ---
>  include/linux/gfp.h |  2 +-
>  mm/page_alloc.c     |  8 ++++----
>  mm/vmstat.c         | 26 +++++++++++++-------------
>  3 files changed, 18 insertions(+), 18 deletions(-)
> 
> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index 5ebf26fcdcfa..63c72cb1d117 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -386,7 +386,7 @@ extern void free_pages(unsigned long addr, unsigned int order);
>  #define free_page(addr) free_pages((addr), 0)
>  
>  void page_alloc_init_cpuhp(void);
> -int decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp);
> +bool decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp);
>  void drain_zone_pages(struct zone *zone, struct per_cpu_pages *pcp);
>  void drain_all_pages(struct zone *zone);
>  void drain_local_pages(struct zone *zone);
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index d1d037f97c5f..77e7d9a5f149 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -2561,10 +2561,10 @@ static int rmqueue_bulk(struct zone *zone, unsigned int order,
>   * Called from the vmstat counter updater to decay the PCP high.
>   * Return whether there are addition works to do.
>   */
> -int decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp)
> +bool decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp)
>  {
>  	int high_min, to_drain, batch;
> -	int todo = 0;
> +	bool todo;

I know you and others already found 'todo' should be initialized. :)

[...]
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index 71cd1ceba191..1f74a3517ab2 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
[...]
> @@ -839,7 +839,7 @@ static int refresh_cpu_vm_stats(bool do_pagesets)
>  		if (do_pagesets) {
>  			cond_resched();
>  
> -			changes += decay_pcp_high(zone, this_cpu_ptr(pcp));
> +			changed |= decay_pcp_high(zone, this_cpu_ptr(pcp));

I'm not a fan of bit operations unless it provides clear benefits.
What about below?

    if (decay_pcp_high(zone, this_cpu_ptr(pcp)) && !changed)
    	changed = truee;

Just a personal and trivial taste.  No strong opinion.  If you don't strongly
feel my suggestion is better, please keep the original code.

>  #ifdef CONFIG_NUMA
>  			/*
>  			 * Deal with draining the remote pageset of this
> @@ -861,13 +861,13 @@ static int refresh_cpu_vm_stats(bool do_pagesets)
>  			}
>  
>  			if (__this_cpu_dec_return(pcp->expire)) {
> -				changes++;
> +				changed = true;
>  				continue;
>  			}
>  
>  			if (__this_cpu_read(pcp->count)) {
>  				drain_zone_pages(zone, this_cpu_ptr(pcp));
> -				changes++;
> +				changed = true;
>  			}
>  #endif
>  		}
> @@ -887,8 +887,8 @@ static int refresh_cpu_vm_stats(bool do_pagesets)
>  		}
>  	}
>  
> -	changes += fold_diff(global_zone_diff, global_node_diff);
> -	return changes;
> +	changed |= fold_diff(global_zone_diff, global_node_diff);
> +	return changed;

Ditto.

>  }
>  
>  /*
> -- 
> 2.47.3

Other than the above trivial things, all looks good to me :)


Thanks,
SJ

