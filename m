Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CDBBC624D3
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 19:03:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 277FA6B008C; Fri,  4 Sep 2026 15:03:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 201116B0092; Fri,  4 Sep 2026 15:03:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CB0F6B0095; Fri,  4 Sep 2026 15:03:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D5DB16B008C
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 15:03:23 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5C853140139
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 19:03:23 +0000 (UTC)
X-FDA: 85177003086.23.AF7A7B6
Received: from mta1.migadu.com (out-118.mta1.migadu.com [95.215.58.118])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2E1564000A
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 19:03:20 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oGu+JSUE;
	spf=pass (imf07.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.118 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788548601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p26T8Rg7PcP9mD7RHkLoFeS4DhAjzl+zqdAHfCROx0Y=;
	b=cnln0U0D4/gqi6Dn/SQGZEGk3XjgVxLFhu6luJZpl9lfRG5STPp7lL2ueIr9u0dzXanEO0
	/Az6qoGyQv7RglGLVJXf7KGEuInHwPre31sI4ytZmc0Y6IW76GBh66rYhGfcP4LpbBydZc
	XbcuntRH69LK6B/H/59+HL0pWD6VLLY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oGu+JSUE;
	spf=pass (imf07.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.118 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788548601;
	b=rSsfW7wZ9WizecqSAnQaIcjPw2Z9066jm00dxqExofm9q+/yhMMsi3UdTXRh1+czcCaO8C
	zIsaIAFzC7Zlk3NUgSz5YQxgG9L5saiiGkorFxC25a+nukaymuqc0XzpTVjEJICDBRm34p
	5WFsWgG0pmWYdBoJn8vwiqYFd8wa2hI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=oVEK1ub0iUftt+6HmRTnW29esWqJWBJV28QP+4bkBxU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788548599; v=1; x=1789153399;
 b=oGu+JSUEtJP3UKO9jKJTC48Ir3WUU1DR6xuFVlyJb/1S9KROXiZvAAIZW+lVpEczDC5CRyyf
 16SSHqAuIpzZfppMkvaP1tYa1L/7lKkuZins2j2/v/z2NpM+IBlbkJUEqqgyAGPrwezEXTcQ7g6
 /qfbONIlw0ZjJUxGVjRcY16I=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 679dc107f74af9c9;
	Fri, 04 Sep 2026 19:03:19 +0000
X-Mizu-Trace-ID: 679dc107f74af9c9
X-Migadu-Flow: FLOW_OUT
Date: Fri, 4 Sep 2026 12:03:17 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: David Stevens <stevensd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v2] memcg: Don't call schedule_work when no spinning is
 allowed
Message-ID: <apsTohKZNnZuWIxC@linux.dev>
References: <20260904173145.2028377-1-stevensd@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260904173145.2028377-1-stevensd@google.com>
X-Stat-Signature: smhqpr6z6t63sp6pkk9ez7asr4yhatzu
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2E1564000A
X-Rspam-User: 
X-HE-Tag: 1788548600-542051
X-HE-Meta: U2FsdGVkX1/ry0CgM26Ba6u1qMaG3S0VCF56Q23jyNsgExHRWfEQOSgaKsYmKTwvS9VAySWFRHWAq3lTLsr8RJ5wfssTgQdRRjttTX+C1Y6oKTVmHF9VuqayboZAgJ15SR6IGpCH/PmzY8SCP/UNMpqxLDh/ayXdtQgo662jrm+HruVrogVp216jjaw9ICfU1cI54illJaKGnpL2vX1J0W6u2ZF9N03sKkIOq1FpNDoAgMcL5Wkh3Fchm9WV0RsfHWNbU2J7iqyka52TG++TGOePzb2hQg/KESXswOQgR9hP0asdf22fIwsoPRw1Q4CvcLDdARhBvevp3Jx3GHCHxZ7kFeKBc4b+j7nDtT39AkKjW1PweOB9h4yThcWlGo7EhV1G5Jah7CUXtgkGozwVritSYSvVxxOsbEtJMCWJp/01y0MjmRcDg189MrJfpJ4iuYdNYe+Iw2QaVao2cGyJ2zD/3+1yX0s0V1IrWA7oXCm0CrnaqBzXfRTTKaN48NR1gLdvDDHBuicUwIbImPAyBlS8fqIWuM0BuhfjL/GGWy9FhiTnuIAIchr/hYW56DeN29oxfcDwt3kRmWxhPO3CljtClxUzJ/D82ebi23vojJakOa+QDbnb/74EHOcohEH7ICs8vpfPP9SLcAdluQUBCn4FjPy+ForAnBVILY+Kr0HuTrervOLQ7hmTqWue9nLm52FWBpb9BzLXrVjcDqFtkEN2FVYdshtwb1cUwR+eKa0T8DMy3s6UP+O5WLsT3EcXuNKwr+/LbfCHmvYWTBGo5W+dvHyo2e2YlbGZHSw0mKJPw8aEV1Lgk0O+SRiMHUBfooIvPGhchwhMQarzczvqOt5Ep83Ksgrt3wQMl+E3CKZ+inv5Kn6j3+Ev7hMcUNA4ftzW58MNpuueFZOvJp4boIGqZq4UQKCF9nrRyuoKEILx4mJ4oCIKR3rWOXDgWt8K641w1/I00r5n3CMyHoj
 mgSC5efh
 GjNdTcbtCl3t2bijnAj9A+J1dXq40P2DrnsMTCUiN9MDX5oBjJVjciUuhwZWelekf9AhOhZYkBt+at7Vf5oZR+WU4wRHhGZJXMmEKjf8ZD5azGzk344N1CQZYOFob2xVEaNwnliLVq3LBY5ZDq1khqxzHlHtbr/AF5zS3ndsYDQ3hAMarKk3H4wfGVa9C/FasQSBLfimgGFsOVXiCcw/+B9PGVb6hDUfxc1TZoBCZmqgN0f8FMdfH1fyNAVu4CjBuKPYVIc2xi7O/K7tfrh3d5cX/iZpAqAESQuM5ZWtnC1DUOHwrSo2zKVV2foK3m+4+9KGKB5O7EXNawhPHH+19IjZm9phrwE79DlMPEZhqEzMBidQBIk8u+CdM+nKf14mrYOE/VLbieUXffHX4HF9QRmWbyg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 04, 2026 at 10:31:45AM -0700, David Stevens wrote:
> Memcg charging can be done from any context, but calling schedule_work()
> isn't safe from an NMI. If memory.high is breached from a context where
> spinning isn't allowed, use irq_work to schedule the reclaim work.
> 
> Fixes: 3ac4638a734a ("memcg: make memcg_rstat_updated nmi safe")
> Acked-by: Michal Hocko <mhocko@suse.com>
> Signed-off-by: David Stevens <stevensd@google.com>
> ---
> v2:
>   - Added missing includes reported by Lorenzo and kernel test robot
>   - Added Acked-by
> 
>  include/linux/memcontrol.h |  2 ++
>  mm/memcontrol.c            | 13 ++++++++++++-
>  2 files changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 8170bb8066a2..4a5ef0aba475 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -23,6 +23,7 @@
>  #include <linux/writeback.h>
>  #include <linux/page-flags.h>
>  #include <linux/shrinker.h>
> +#include <linux/irq_work_types.h>
>  
>  struct mem_cgroup;
>  struct obj_cgroup;
> @@ -219,6 +220,7 @@ struct mem_cgroup {
>  	spinlock_t	 peaks_lock;
>  
>  	/* Range enforcement for interrupt charges */
> +	struct irq_work high_irq_work;
>  	struct work_struct high_work;
>  
>  #ifdef CONFIG_ZSWAP
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 6dc4888a90f3..0e8b302ca9ad 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -62,6 +62,7 @@
>  #include <linux/seq_buf.h>
>  #include <linux/sched/isolation.h>
>  #include <linux/kmemleak.h>
> +#include <linux/irq_work.h>
>  #include "internal.h"
>  #include "swap_table.h"
>  #include <net/sock.h>
> @@ -2360,6 +2361,11 @@ static void high_work_func(struct work_struct *work)
>  	reclaim_high(memcg, MEMCG_CHARGE_BATCH, GFP_KERNEL);
>  }
>  
> +static void high_irq_work_func(struct irq_work *work)
> +{
> +	schedule_work(&container_of(work, struct mem_cgroup, high_irq_work)->high_work);
> +}
> +
>  /*
>   * Clamp the maximum sleep time per allocation batch to 2 seconds. This is
>   * enough to still cause a significant slowdown in most cases, while still
> @@ -2752,7 +2758,10 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  		/* Don't bother a random interrupted task */
>  		if (!in_task()) {
>  			if (mem_high) {
> -				schedule_work(&memcg->high_work);
> +				if (allow_spinning)
> +					schedule_work(&memcg->high_work);
> +				else
> +					irq_work_queue(&memcg->high_irq_work);
>  				break;
>  			}
>  			continue;
> @@ -4129,6 +4138,7 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
>  		goto fail;
>  
>  	INIT_WORK(&memcg->high_work, high_work_func);
> +	init_irq_work(&memcg->high_irq_work, high_irq_work_func);
>  	vmpressure_init(&memcg->vmpressure);
>  	INIT_LIST_HEAD(&memcg->memory_peaks);
>  	INIT_LIST_HEAD(&memcg->swap_peaks);
> @@ -4337,6 +4347,7 @@ static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
>  		static_branch_dec(&memcg_bpf_enabled_key);
>  
>  	vmpressure_cleanup(&memcg->vmpressure);
> +	irq_work_sync(&memcg->high_irq_work);

On RT kernels, this will put rcu grace period here while we are holding the
cgroup_mutex. Easy fix would be to use IRQ_WORK_INIT_HARD instead of
init_irq_work() in mem_cgroup_alloc.

Something like:
	memcg->high_irq_work = IRQ_WORK_INIT_HARD(high_irq_work_func);


