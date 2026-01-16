Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEF24D4A619
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 09:50:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 513836B0088; Fri, 16 Jan 2026 04:50:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49CF06B0089; Fri, 16 Jan 2026 04:50:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B5EB6B008A; Fri, 16 Jan 2026 04:50:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2C0FC6B0088
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 04:50:08 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 013CF1BD16
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 09:50:07 +0000 (UTC)
X-FDA: 84337356096.16.B0CBBB8
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 644FD1C0003
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 09:50:06 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gnVbpMtH;
	spf=pass (imf20.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768557006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BkUVBheURQE1gd/PJQo4sO2zwk6CkuZe1KJQsdvxXCI=;
	b=6/Ub74+tsdnMJ4hVk1SQWdaPhI8VcVZp0JUJZk7SoRrdJfZbkfOk70fCFNSCOHLoTdOIIf
	mR7ipJdsgsYM3EgYpf8VjrSsx0eEKj/PRY50vrKp9jzz63odVpobcesD4WvfDPzDpkIWk8
	foKpnJDNJsQRMaIKPFQfotAOgZXD15g=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gnVbpMtH;
	spf=pass (imf20.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768557006; a=rsa-sha256;
	cv=none;
	b=ObB/v7M8EFpxxV0asX7t3eTQDEnfASxUjv50qPGrdq1x9Co581LnS44rifbBYiywKOyLbf
	WHGKoUbttZGZdFO4OQgX8hs4eSTCBctbXkqO96ye0F6Hotz3GZfx/xegCngNZeTFJio06s
	PX4uFKsooudbI8IBT0wOVNiQHPE3l7o=
Message-ID: <4ed93895-7c73-4dba-9b12-ed6f506d1823@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768557004;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BkUVBheURQE1gd/PJQo4sO2zwk6CkuZe1KJQsdvxXCI=;
	b=gnVbpMtHJB57rTxKv/t6Naa75qJ6xWq3zrFLY1LBanMgT5p1HHt3EiHJpcLKziV95PG4YS
	52Gejskh/WMhJuL5FKFYzk7g49ku6jZRt6jMRJtJ8bwvGRVFEvSyrI31C1ph0KMuTHYxHE
	1IXr+n1HOqo1LC0QT4fyexXfAH6m2PY=
Date: Fri, 16 Jan 2026 17:49:43 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 25/30] mm: vmscan: prepare for reparenting traditional
 LRU folios
To: Qi Zheng <qi.zheng@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>,
 hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, david@kernel.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
 yosry.ahmed@linux.dev, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
 <3adb367000706f9ef681b34d0a2b0eb34c494c84.1768389889.git.zhengqi.arch@bytedance.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <3adb367000706f9ef681b34d0a2b0eb34c494c84.1768389889.git.zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 644FD1C0003
X-Stat-Signature: 5c3qb1chncqrbyiojho7w9sw55de4ym7
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768557006-544591
X-HE-Meta: U2FsdGVkX18KM6c2GElPJmLDZ3s6vLX0tz0CVw4GlJjOI7DzepNi3sdk8RWXW/OYUIJytXbkk5VqeI189lZJaTKB6I1M7YgRwKXlicPcAl3QEe3Kp5LDbJN5eayf+mxJf7fOI0QXbjDKTytDjRYiBKgJibt8KkdDePGrzhXaf/mmPORmmtO1sUaZnqjg0aBZnJuCeZoH5+dUV8CPRHPVRzPk1j6ZzVoggxgiAUN1hlo5IuY0bIfGpNi5CJsFZuecQ98CvHBrlfC1vE0Och/zsTSnCo06TgFEWOfB4LXlhZvzht670VWy3z0jNeRam2rehts4Whdkdw0jkZ/ivjvHtjjS5yz+KSMcLXC4Di8wGbdaag1tlz+t+UUIalLm/4ZO+atw/kh0TLHfM8l48Zjg3dEbp9axegTyt2F6iibsZ2IYC+oQjG6bf2fe+38U7w5xwA/OQDJ+hWNDc1AulAoZfJ5J19k0BDutfbu8syZYKksgC3g1svNDwlvlf/EuNWLNXcu81mtJ32UHklPp0RVEAgLe8l8GOluq7fH/btQU8QUZFbPt/sLA4pBgVVTRfm9YTPxyFSq5dzpOKMh6I6gDFXOMjBvKOyVje3pbQbk8LVkgc15PjOOduSLO/KTMpaLG0IxmuMVciKAG3/4H0VABXyfTXfNHAtDPX0zZPyzWdVmyxIVS7Wltg6r4fnVCn5hi7aYNhXAOdNfGu+Z6ySwxE/P3zjQ0gTXbZJ0ySlXn+yo5J7v4W+pzX+9SjMxRjMuOnOERW8OdM9Ur+MY6U8oGfE4Us/8nZMYUnFw7GmZUckbFK7P+ehnCpJGfnyN5WM17A9WZMHo+u4ZqROST4SNGruhJBPUjBj5bhxjU2fp+D9yHAOPqv2z7yw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/1/14 19:32, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
>
> To resolve the dying memcg issue, we need to reparent LRU folios of child
> memcg to its parent memcg. For traditional LRU list, each lruvec of every
> memcg comprises four LRU lists. Due to the symmetry of the LRU lists, it
> is feasible to transfer the LRU lists from a memcg to its parent memcg
> during the reparenting process.
>
> This commit implements the specific function, which will be used during
> the reparenting process.
>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Muchun Song <muchun.song@linux.dev>

With one comment below.
> ---
>   include/linux/mmzone.h |  4 ++++
>   include/linux/swap.h   | 19 +++++++++++++++++++
>   mm/swap.c              | 37 +++++++++++++++++++++++++++++++++++++
>   mm/vmscan.c            | 19 -------------------
>   4 files changed, 60 insertions(+), 19 deletions(-)
>
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 6a7db0fee54a3..1014b5a93c09c 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -366,6 +366,10 @@ enum lruvec_flags {
>   	LRUVEC_NODE_CONGESTED,
>   };
>   
> +#ifdef CONFIG_MEMCG
> +void lru_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent);
> +#endif /* CONFIG_MEMCG */

Can we move it to swap.h since it is declared in swap.c?

> +
>   #endif /* !__GENERATING_BOUNDS_H */
>   
>   /*
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index e60f45b48e74d..4449d1f371a56 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -636,5 +636,24 @@ static inline bool mem_cgroup_swap_full(struct folio *folio)
>   }
>   #endif
>   
> +/* for_each_managed_zone_pgdat - helper macro to iterate over all managed zones in a pgdat up to
> + * and including the specified highidx
> + * @zone: The current zone in the iterator
> + * @pgdat: The pgdat which node_zones are being iterated
> + * @idx: The index variable
> + * @highidx: The index of the highest zone to return
> + *
> + * This macro iterates through all managed zones up to and including the specified highidx.
> + * The zone iterator enters an invalid state after macro call and must be reinitialized
> + * before it can be used again.
> + */
> +#define for_each_managed_zone_pgdat(zone, pgdat, idx, highidx)	\
> +	for ((idx) = 0, (zone) = (pgdat)->node_zones;		\
> +	    (idx) <= (highidx);					\
> +	    (idx)++, (zone)++)					\
> +		if (!managed_zone(zone))			\
> +			continue;				\
> +		else
> +
>   #endif /* __KERNEL__*/
>   #endif /* _LINUX_SWAP_H */
> diff --git a/mm/swap.c b/mm/swap.c
> index 7e53479ca1732..cb40e80da53cd 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -1090,6 +1090,43 @@ void folio_batch_remove_exceptionals(struct folio_batch *fbatch)
>   	fbatch->nr = j;
>   }
>   
> +#ifdef CONFIG_MEMCG
> +static void lruvec_reparent_lru(struct lruvec *child_lruvec,
> +				struct lruvec *parent_lruvec,
> +				enum lru_list lru, int nid)
> +{
> +	int zid;
> +	struct zone *zone;
> +
> +	if (lru != LRU_UNEVICTABLE)
> +		list_splice_tail_init(&child_lruvec->lists[lru], &parent_lruvec->lists[lru]);
> +
> +	for_each_managed_zone_pgdat(zone, NODE_DATA(nid), zid, MAX_NR_ZONES - 1) {
> +		unsigned long size = mem_cgroup_get_zone_lru_size(child_lruvec, lru, zid);
> +
> +		mem_cgroup_update_lru_size(parent_lruvec, lru, zid, size);
> +	}
> +}
> +
> +void lru_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent)
> +{
> +	int nid;
> +
> +	for_each_node(nid) {
> +		enum lru_list lru;
> +		struct lruvec *child_lruvec, *parent_lruvec;
> +
> +		child_lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
> +		parent_lruvec = mem_cgroup_lruvec(parent, NODE_DATA(nid));
> +		parent_lruvec->anon_cost += child_lruvec->anon_cost;
> +		parent_lruvec->file_cost += child_lruvec->file_cost;
> +
> +		for_each_lru(lru)
> +			lruvec_reparent_lru(child_lruvec, parent_lruvec, lru, nid);
> +	}
> +}
> +#endif
> +
>   static const struct ctl_table swap_sysctl_table[] = {
>   	{
>   		.procname	= "page-cluster",
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index c48ff6e05e004..e738082874878 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -270,25 +270,6 @@ static int sc_swappiness(struct scan_control *sc, struct mem_cgroup *memcg)
>   }
>   #endif
>   
> -/* for_each_managed_zone_pgdat - helper macro to iterate over all managed zones in a pgdat up to
> - * and including the specified highidx
> - * @zone: The current zone in the iterator
> - * @pgdat: The pgdat which node_zones are being iterated
> - * @idx: The index variable
> - * @highidx: The index of the highest zone to return
> - *
> - * This macro iterates through all managed zones up to and including the specified highidx.
> - * The zone iterator enters an invalid state after macro call and must be reinitialized
> - * before it can be used again.
> - */
> -#define for_each_managed_zone_pgdat(zone, pgdat, idx, highidx)	\
> -	for ((idx) = 0, (zone) = (pgdat)->node_zones;		\
> -	    (idx) <= (highidx);					\
> -	    (idx)++, (zone)++)					\
> -		if (!managed_zone(zone))			\
> -			continue;				\
> -		else
> -
>   static void set_task_reclaim_state(struct task_struct *task,
>   				   struct reclaim_state *rs)
>   {


