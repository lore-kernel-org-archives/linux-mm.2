Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68802CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 08:24:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD40D8E000D; Tue, 11 Nov 2025 03:24:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B84438E0002; Tue, 11 Nov 2025 03:24:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC1998E000D; Tue, 11 Nov 2025 03:24:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 988798E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 03:24:09 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 49BD9160473
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 08:24:09 +0000 (UTC)
X-FDA: 84097638618.06.F14B47E
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf17.hostedemail.com (Postfix) with ESMTP id 43A714000A
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 08:24:07 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="e/b7C496";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762849447; a=rsa-sha256;
	cv=none;
	b=6HR5Rx2yx8vfq5ysW7jVMqFN1FPuObXolF0cT4FKCJq02Fj4udxe4GQhLMAC5xSm9BGOqU
	J7nTCMGbqOwUaEEO2N/4GpCapOtmgXyRLeSGj1Wzq8xREzIFPl0eMiaJgh8oDpfKhgwVza
	ANv8L6mTyhmySkRfAgPVNcPOYOrFJqs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="e/b7C496";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762849447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T1lCF8ZxwiRf7MmmtFFe+0D9tQtuDiUNOYjnvpfAnHA=;
	b=Fxa6wjPSeibb/DUmE80GdFzFhp5EsNsOondfAHaKOYtKBejqV0rOwWTUXB/zJaFGQKwnYI
	kRnwM4NcAsojKbVTUKpABEg6ud4HY1gGCuIxQB3zW2TnXaEoI/R950HBshQQWDKJRAsdqY
	0WPBSmaqzohX2bzdv3P00evqXKhHb4M=
Message-ID: <19219ae3-209d-4371-b275-ab2043151f60@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762849444;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T1lCF8ZxwiRf7MmmtFFe+0D9tQtuDiUNOYjnvpfAnHA=;
	b=e/b7C496YBxC6KfnwzYKF3iSY9yupIoQg9pFTwlzfN6vHwdjD/PU+M7GyhLeE8pZjvEXJS
	eLbTUlW6R9Si/egd5wODSTyNN3E7HSmi54FePJXdTXu+iDCWKdsWgDJ/Ard2bSG8vlm+On
	OsJUgeyAMmPk0rUsQF0Lv8L1EcHdrSk=
Date: Tue, 11 Nov 2025 16:23:37 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 2/4] memcg: remove __mod_lruvec_kmem_state
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 Meta kernel team <kernel-team@meta.com>,
 Andrew Morton <akpm@linux-foundation.org>
References: <20251110232008.1352063-1-shakeel.butt@linux.dev>
 <20251110232008.1352063-3-shakeel.butt@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20251110232008.1352063-3-shakeel.butt@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 43A714000A
X-Stat-Signature: b435c61us8hndge1ushku7m4znt7ncqo
X-HE-Tag: 1762849447-672728
X-HE-Meta: U2FsdGVkX1/h/MzceQjPb9TKYaUCvM/tiJUMSES1bEO4NDTosX3c1NT7QiiD9YEZ7KwkS8YlvekkbP0n/ulYUoEvYp7IdDu067rXqQaNA65vkZHrrl73cmM82OGpU9ATXRixQnr90x/91pmmNXrs1B7gFsRoO9Ts9PZ2wQwojelwucolO226a9/TZfZx5HG+OLLLLh9NHb9cQLYBsLLgqU7hnGz1sYivnfcIBVb2vQZYj4sfee43qXi2L81Mol3iS2SgB/sh5ugadWDz1iEYYFodPuwPCkeOTeUe9fWGgSiaoKuEVDqo3j0KqVs9eJRN6zjwcjOVbIXYGKr5BiM68sHG8oukH8ZF0FTHEkvERUOrZaOhOvqi3lxTfL/0Px8J9tLHNK1zG44CEcPGYBrZyKQQecf7O/DCpA/P8tjZjrkx5auKZpSwPejR4z75ydToKD7tYOWRbwpjzpbttT8X5oCfYH+12TfEZQ8jHfHTfcbH68Z5jnuqKDOdlxcBq0kzlormBdOh2MtLVDiNVHaKyGpMiDXDkqwwFLlLMMHLMvzDuOTiEZG7w/pSKUHddsvG40f3m7mbjg2hfX2cvGoAGVP6uTLIP0OAxF0yBZ1M1H+wiBJcbIwqDxaNSHXDAO6NS+Doc9wKyAiV5gHu+uCAEYhCWhP850OF1AkDWaUorC/rckaA6U2+/NNyGH67+RE1+2VTLFGZqKk49fkoSsUeNfJW2MMDy5TEQOraerHbf6wWuqYTputcbLXjnObzn2+IduZ4jPRYxHvnTL+oeylpWSw0LOYAoplaN5KYcdk+f2vJTC2DZEbZPPDvKCCE5RsEVeAFUSPlugdvh1kXCHhC2m3utqlbemdD2X/l+RzZyZXUYDTDWAWTjgr7rOD3UHCkOumdUDq8X/88IsMqB6mqYu73oJbt+uEjlfZOvlS+czyaIVIxhQlImundHQIL/I3jh+mp3FE7ovYjodGHB/G
 +XCnsA8z
 6FCL5X5GWp0+jEmqGzv7zpgp72Mjxv/w1FHp5LDNnidGg65ch2H5D7vNqqRgEoNXVel5xgqzj0AB4yEuwTf7S79xs0GM7PqNHf6eQv0z7/os2XaPQ/mwAxMFjzG/u37I/nSfWAgj3YVOwrYZIpHNynZKiRFmm5mQ1CDXeS9gt06uDVtc5SEj1T6OthRGsjwlKDJuHRv7ZQZoi2amd/OujZ696ij3C5acnRki/dpaaSQSg2+cW9TgKGwV2eqAq4oUflITf6L4NS8bPZtacp2JOt5JCW0u7OR1Hb0h3Y9Xey+C/9Ic1Yx1IAr8Uaw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Shakeel,

On 11/11/25 7:20 AM, Shakeel Butt wrote:
> The __mod_lruvec_kmem_state is already safe against irqs, so there is no
> need to have a separate interface (i.e. mod_lruvec_kmem_state) which
> wraps calls to it with irq disabling and reenabling. Let's rename
> __mod_lruvec_kmem_state to mod_lruvec_kmem_state.
> 
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Reviewed-by: Qi Zheng <zhengqi.arch@bytedance.com>

One nit below:

> ---
>   include/linux/memcontrol.h | 28 +++++-----------------------
>   mm/memcontrol.c            |  2 +-
>   mm/workingset.c            |  2 +-
>   3 files changed, 7 insertions(+), 25 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index f82fac2fd988..1384a9d305e1 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -957,17 +957,7 @@ unsigned long lruvec_page_state_local(struct lruvec *lruvec,
>   void mem_cgroup_flush_stats(struct mem_cgroup *memcg);
>   void mem_cgroup_flush_stats_ratelimited(struct mem_cgroup *memcg);
>   
> -void __mod_lruvec_kmem_state(void *p, enum node_stat_item idx, int val);
> -
> -static inline void mod_lruvec_kmem_state(void *p, enum node_stat_item idx,
> -					 int val)
> -{
> -	unsigned long flags;
> -
> -	local_irq_save(flags);
> -	__mod_lruvec_kmem_state(p, idx, val);
> -	local_irq_restore(flags);
> -}
> +void mod_lruvec_kmem_state(void *p, enum node_stat_item idx, int val);
>   
>   void count_memcg_events(struct mem_cgroup *memcg, enum vm_event_item idx,
>   			unsigned long count);
> @@ -1403,14 +1393,6 @@ static inline void mem_cgroup_flush_stats_ratelimited(struct mem_cgroup *memcg)
>   {
>   }
>   
> -static inline void __mod_lruvec_kmem_state(void *p, enum node_stat_item idx,
> -					   int val)
> -{
> -	struct page *page = virt_to_head_page(p);
> -
> -	mod_node_page_state(page_pgdat(page), idx, val);
> -}
> -
>   static inline void mod_lruvec_kmem_state(void *p, enum node_stat_item idx,
>   					 int val)
>   {
> @@ -1470,14 +1452,14 @@ struct slabobj_ext {
>   #endif
>   } __aligned(8);
>   
> -static inline void __inc_lruvec_kmem_state(void *p, enum node_stat_item idx)
> +static inline void inc_lruvec_kmem_state(void *p, enum node_stat_item idx)
>   {
> -	__mod_lruvec_kmem_state(p, idx, 1);
> +	mod_lruvec_kmem_state(p, idx, 1);
>   }

The inc_lruvec_kmem_state() has only one user.

>   
> -static inline void __dec_lruvec_kmem_state(void *p, enum node_stat_item idx)
> +static inline void dec_lruvec_kmem_state(void *p, enum node_stat_item idx)
>   {
> -	__mod_lruvec_kmem_state(p, idx, -1);
> +	mod_lruvec_kmem_state(p, idx, -1);
>   }

The dec_lruvec_kmem_state() has no user.

Not sure whether inc_lruvec_kmem_state() and dec_lruvec_kmem_state()
also need to be removed.

Thanks,
Qi

>   
>   static inline struct lruvec *parent_lruvec(struct lruvec *lruvec)
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index f4b8a6414ed3..3a59d3ee92a7 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -799,7 +799,7 @@ void __lruvec_stat_mod_folio(struct folio *folio, enum node_stat_item idx,
>   }
>   EXPORT_SYMBOL(__lruvec_stat_mod_folio);
>   
> -void __mod_lruvec_kmem_state(void *p, enum node_stat_item idx, int val)
> +void mod_lruvec_kmem_state(void *p, enum node_stat_item idx, int val)
>   {
>   	pg_data_t *pgdat = page_pgdat(virt_to_page(p));
>   	struct mem_cgroup *memcg;
> diff --git a/mm/workingset.c b/mm/workingset.c
> index d32dc2e02a61..892f6fe94ea9 100644
> --- a/mm/workingset.c
> +++ b/mm/workingset.c
> @@ -749,7 +749,7 @@ static enum lru_status shadow_lru_isolate(struct list_head *item,
>   	if (WARN_ON_ONCE(node->count != node->nr_values))
>   		goto out_invalid;
>   	xa_delete_node(node, workingset_update_node);
> -	__inc_lruvec_kmem_state(node, WORKINGSET_NODERECLAIM);
> +	inc_lruvec_kmem_state(node, WORKINGSET_NODERECLAIM);
>   
>   out_invalid:
>   	xa_unlock_irq(&mapping->i_pages);


