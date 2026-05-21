Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9119CCD5BAC
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 17:28:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7E3E6B009E; Thu, 21 May 2026 13:28:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2F5A6B00A0; Thu, 21 May 2026 13:28:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1ECF6B00A1; Thu, 21 May 2026 13:28:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8CD666B009E
	for <linux-mm@kvack.org>; Thu, 21 May 2026 13:28:40 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2F70614072D
	for <linux-mm@kvack.org>; Thu, 21 May 2026 17:28:40 +0000 (UTC)
X-FDA: 84792111600.16.3665041
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf04.hostedemail.com (Postfix) with ESMTP id 725D540015
	for <linux-mm@kvack.org>; Thu, 21 May 2026 17:28:38 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gtJKinXs;
	spf=pass (imf04.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779384518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VMh0FfyEhpzP/o6+/cG0EuYR7BrwDmTdRcZFskTN7I0=;
	b=tXX37Id109EYkWa1nNj2rqJ10CKubi4exgCt0mGvknV2oQYbVxxxS5rApDppMgmOCwyI3b
	K9aXKcZhQI4oOI2k4q2tklKP+C9tQZqVRrcomFTR/jguPjM1wTRVFn9nKCQGVgDkdM9GNK
	n9fiICuVbT0stv/j4SsxeUEdHu3x/yo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gtJKinXs;
	spf=pass (imf04.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779384518; a=rsa-sha256;
	cv=none;
	b=TQE151z0wsJhEMzy0hPqdb2iAqGCRx3asFoxzjFTF94Dk5cTVgguN30dTND8xys47qA9r8
	Ppn1o9MevpyzDihq1maTXX1WCsEMasmfPgd8Qpcg/fHVzW9VKV3Ov6AhwSTy+aUuuPGcRs
	G4BpMH9YoVQCE5WbN9ofa9bpjhVJjdc=
Date: Thu, 21 May 2026 10:28:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779384516;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VMh0FfyEhpzP/o6+/cG0EuYR7BrwDmTdRcZFskTN7I0=;
	b=gtJKinXsA+PvoLRM/qYCELyTzZ8blaZkWqvMW4qMo4oYOD2Y0aCv/YPNS9HYL2paKJgsak
	UCJngQ0G3V1bmIDRcrnrS9n2pZzZd/MUkrgqnDwcIL9sCdEZXgRDTF0RiTkwZnvG+ZxdjK
	TFDeQo9NvtXo5wql6LmmFsA8m73X9Sk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Minchan Kim <minchan@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Barry Song <baohua@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Wei Xu <weixugc@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH 4/8] mm: memcontrol: track MEMCG_KMEM per NUMA node
Message-ID: <ag9AY2SrcsE1B3Ti@linux.dev>
References: <20260511202136.330358-1-alex@ghiti.fr>
 <20260511202136.330358-5-alex@ghiti.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511202136.330358-5-alex@ghiti.fr>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: b59i53jdwhe9rau8kbp85biazyedp6ti
X-Rspamd-Queue-Id: 725D540015
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779384518-429204
X-HE-Meta: U2FsdGVkX19WsNme9HAWXnv0BONEdMnQWmzicKXWhQkS9FHcPy+kXoNn+PPgn08TnYDlcr6pGELG4lBHZ4ZviiAOIpRQ/8bpr7GnMK0adfMc/Z7a8PT1ZVVIQuBdQ+7TOOZaopI/dmEIv74lR0/eed+3dfX8D/YgqU7Zr7NBmgh4zelOj6ldTiYi537FuS0BDgzNqQP3/LM01wrrooAtNLQ5MHnVpS3VsARn7ZSNM42iEhWIUmauqQdl/1IaHQMDRoKW5EPXVvUqVHpwVSCfH6Z9KARoPGArgWgH9/zfnvun6cqWFCIyzHpGOe++IGMTMArOWAAg7bV2Yb7dgDA7eVKIdLdmWbcgp2VScycQpHmRpMi9h+YTdsI5gw+Lxxim5wPsdgCtBLVYSYWWzZM4sfIkAKvRfgfJjZcuuPZd85x9rJa3qhx2kAZEHP1w9vWQj33fV5kN0H/KPlBXOrwyC5D+CRPvGTulcZSm0YXGGHX+lRsLecKGsFU6KsXp+1+Ik5yqx/Vk9dJhTjHi9oWAjfq28gRP0ayAvrxW9MNHGMI9OBS+fyE41gMpwe5ZLvXkYxMuA/Zdae4SOiHEB0Dq5/1mNLOqEiUpCbRztZRdZYm9IQ05951Nyn3zncSHkRrt16bhntSIjh6/BC+ihhaU2i6VOz76JI+h25DHMRnVRwHpcNANFhZycbf0wZblqXMAW12VcZMKJbKQlkpbGM0KPMIDIMImAT4uhYN8Y9fWb+JD3XVKqdZO2s8n5/6ySoeT2PaXzdacqAmRtA+SDV5lw7fvmBekVuSsZXr5haIZAdyhdV3eOmyLvNMrAXDE7d9lwKpAJV6KAyx6UfJQrpxd9Qi7zXlBVv2UPd0HrOjoDlxyIDqfI1QkW3jBuCo4+5RPzHHymlaI4Ro94dW2wApRlTHx6pgh6WzHbz13EM5RZHtUB3Mitl1FUeycvlRSuP5OBa+uOdA4Xs8sF9YJIW+
 yLGFztSg
 zLdBEpxnNcCgKdKkVoUJXlczwrJtmpW+0vh+sN8Qdp2cXqHB9a8ntDYluDGzFJUQNzYRRqi2DuD2VcIYniiZRn68DVZ3YSzOx7FMGLgZEoxGkDE0WTTl/WiWKSzxMN66UHjJ527RmJmT8/6Ektgbt8EIyrbvVFAJk8r/SitaxzwcrYZjc1fA6PrBVr6rsGuK8WqP38mcvWDthyyStfTfTSP1bp2VrO3ugUnzhdu2xnXhH435XEVOZQJxaLuByQ6zZfkCGYtHHqNOMLO0/cG2D0WsvlaBahL1tnSSyTA5cGrL/rutc7VyQWeqm3Z3jQBO5CqnqMk7at4Ng698i00cE3K1iJPbBB5F4IFnjbLh7mdg30LA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 10:20:39PM +0200, Alexandre Ghiti wrote:
> This patch gets rid of MEMCG_KMEM and wires all the "generic" functions
> by introducing per-node obj_cgroup objects.
> 
> Note that it does not convert the kmem users to proper per-memcg-per-node
> accounting now, this is done in upcoming patches.
> 
> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> ---
>  include/linux/memcontrol.h | 23 ++++++++++----
>  include/linux/mmzone.h     |  1 +
>  mm/memcontrol.c            | 64 ++++++++++++++++++++++++--------------
>  mm/vmstat.c                |  1 +
>  4 files changed, 59 insertions(+), 30 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 568ab08f42af..17cf823160e4 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -35,7 +35,6 @@ enum memcg_stat_item {
>  	MEMCG_SWAP = NR_VM_NODE_STAT_ITEMS,
>  	MEMCG_SOCK,
>  	MEMCG_PERCPU_B,
> -	MEMCG_KMEM,
>  	MEMCG_ZSWAP_B,
>  	MEMCG_ZSWAPPED,
>  	MEMCG_ZSWAP_INCOMP,
> @@ -126,9 +125,10 @@ struct mem_cgroup_per_node {
>  	struct list_head objcg_list;
>  
>  #ifdef CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
> -	/* slab stats for nmi context */
> +	/* slab and kmem stats for nmi context */
>  	atomic_t		slab_reclaimable;
>  	atomic_t		slab_unreclaimable;
> +	atomic_t		kmem;
>  #endif
>  };
>  
> @@ -190,6 +190,7 @@ struct obj_cgroup {
>  		struct rcu_head rcu;
>  	};
>  	bool is_root;
> +	int nid;
>  };
>  
>  /*
> @@ -254,10 +255,6 @@ struct mem_cgroup {
>  	atomic_long_t		memory_events[MEMCG_NR_MEMORY_EVENTS];
>  	atomic_long_t		memory_events_local[MEMCG_NR_MEMORY_EVENTS];
>  
> -#ifdef CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
> -	/* MEMCG_KMEM for nmi context */
> -	atomic_t		kmem_stat;
> -#endif
>  	/*
>  	 * Hint of reclaim pressure for socket memroy management. Note
>  	 * that this indicator should NOT be used in legacy cgroup mode
> @@ -776,6 +773,20 @@ static inline void obj_cgroup_put(struct obj_cgroup *objcg)
>  		percpu_ref_put(&objcg->refcnt);
>  }
>  
> +static inline struct obj_cgroup *obj_cgroup_get_nid(struct obj_cgroup *objcg,
> +						    int nid)
> +{
> +	struct obj_cgroup *nid_objcg;
> +	struct mem_cgroup *memcg;
> +
> +	rcu_read_lock();
> +	memcg = obj_cgroup_memcg(objcg);
> +	nid_objcg = rcu_dereference(memcg->nodeinfo[nid]->objcg);
> +	rcu_read_unlock();
> +
> +	return nid_objcg;

What is guarating the life of nid_objcg?


