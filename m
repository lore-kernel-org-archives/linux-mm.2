Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21CC7C43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 14:32:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1382F6B00A0; Fri, 26 Jun 2026 10:32:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1101B6B00A1; Fri, 26 Jun 2026 10:32:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04D256B00A2; Fri, 26 Jun 2026 10:32:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D7D416B00A1
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:32:57 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 62F211A049E
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 14:32:57 +0000 (UTC)
X-FDA: 84922305594.29.8C57EA4
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4FFF712000E
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 14:32:55 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=a31JYTtk;
	spf=pass (imf29.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782484375;
	b=tvFnlNwQJMdIManbJyqGl2dtkjlBhApGsEW2oQ9R3vD1GJztkObLKI89FqNiiuqvl4eURE
	y8mxx+FdBuZJCFErb7siCT2TbIameGmzY1t8rwB1hZYqKgNpcX1JMgahVcbUx+/BJiT5dF
	nGD2qOna+8hZBSZt2HVGTM87JDj+zEs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782484375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K1f7G+W7XdToQCcEEv+xhI/b4k9eRW05nVoQLm3eeNw=;
	b=jn/IVOmJhoj/EuYkHckctrkAuC/wxMqE1HwwEloKWUmo03XxyHsBgAiDAeMvywKKHPwmGU
	zR9JRP7koAkMLJGtbzBqBzxGajeig63mslwBXkEQoQ3p9mBOEyUWEaV15mRNO7tIqkN7/R
	PN2WaayUUWS9SPn6/9cTK7dDcsCxwaE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=a31JYTtk;
	spf=pass (imf29.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782484372;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K1f7G+W7XdToQCcEEv+xhI/b4k9eRW05nVoQLm3eeNw=;
	b=a31JYTtkHqBYP9yQgIATJLIF5O8Bt+AGU5eBWio4HiGkQ+cWhMjdR+Z7sw8NkHZw6f+WCi
	a20/l8a4z1Yth6b1AP+Q2UbPym1OAFn9NaJQRG16c34M/0bXcekcPKPKqMyOlmlXhJKfks
	7Sx+8QTrExLatoHZHsVkKYjjyn9ZtIQ=
From: Usama Arif <usama.arif@linux.dev>
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: Usama Arif <usama.arif@linux.dev>,
	alexandre@ghiti.fr,
	Andrew Morton <akpm@linux-foundation.org>,
	Barry Song <baohua@kernel.org>,
	Ben Segall <bsegall@google.com>,
	cgroups@vger.kernel.org,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Hildenbrand <david@kernel.org>,
	Dennis Zhou <dennis@kernel.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Kairui Song <kasong@tencent.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Minchan Kim <minchan@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Tejun Heo <tj@kernel.org>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Wei Xu <weixugc@google.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Yuanchu Xie <yuanchu@google.com>
Subject: Re: [PATCH v2 9/9] mm: zswap: per-node kmem accounting for zswap/zsmalloc
Date: Fri, 26 Jun 2026 07:32:43 -0700
Message-ID: <20260626143244.3382853-1-usama.arif@linux.dev>
In-Reply-To: <20260626102358.1603618-10-alex@ghiti.fr>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: set95r9cqx5stsehoe7pbb5b8w1noj7k
X-Rspamd-Queue-Id: 4FFF712000E
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782484375-357025
X-HE-Meta: U2FsdGVkX1+zAfy8v8C0sk23gWLq2UgjKfisn89DC9u2TURmTNh3bGOalntHA84ITnGZ9xpmQ9qVvas4zJ/ljsnE1/dthuSC+pdDCGxWDdDc/qSD+xdSN9INaoyhxSo/DCisYNJGEZQuIvA6l8udU0oDIOjeNcwm5M5XnxmKn7EQR3mhGmYQb5/Beb6/M/665ZZUwyn9VcUpH+idVs6MY256m6hzj2ysX2H2mqqQ4gk6F1sBdqRPZsSNeOSKChI4fwX61MoBwWkrAVGgnGt9Nev4z1WeK4cM+4Jhpu80+fHI8kYPm82rV76NUOqdZCKq2EYOAMzs2MnztRPR7p0PeyOqlI0GyAcKDkakG+KpA41E1OoN0zKZuhCri5gQKHm0N3jy+PY0x7n7avpYEMPyu+NrzkDBgoDIBl9+1u8Pjq0d1cnHd7JkRb2Ev2VyVgg9Y52F5DYFESt5BJt/vBQKjOmGsHw9U+cIjNxqNFyek5bURAu5gm0+Cj3II+kMudc2U4FTdEIaGpSHoXZqxmZAzQopqQMQFmGpF72SajPxmX7jwBV/0uoOzcfeksYLNMbL7/NhcNoBkBbbw/bS3375iVrB9fMb4wPXc8WjzPtwkRR+29wzLyKRgzw89S5p2/amWfak6O85juNT+ixLgn5ufgE1HrKy5pFlQLDpwIXT7mx7sxwCpU8Qxx4Hso0y567Ag0G0upwVdLN1ljYE42dNFPXGQIgxEXQjSakzJmFfL4YukYVFJwjdV9GwMjYam2K3LIADIvEoWSzaqQim+ue8Lcji9es1raQ2Me/Z69xMdEzs2B4WJ2JQzPsZ5m3TeH4rG9nqna99MXrjmalSTKtWCqMuchACH9tyrqsoSJQQFBFEx0KVyeuRuR/EdR6LbLOaTbBaSD6cslFpv6/t9aSi172I6gtdh5nIoLafPN230l+XBx4VOhINiHBRewEWoV3vbsedJ9OUDpq94Z3FFKh
 g6P7cCzL
 0CN7kD63MyA8LZekSMsrWsdoZc74p7T6kvlxecQuz+chQHuU5dPEzrfEAMshcAEEU05voqFhRmZpJBNMbR9//finzmBlKcQNWkjkn7938sApGc86hTEk7uZloymPd4FkaBRy1qMHzwky8pCenyhgSn0qabPUfY+lbiLLGx4N3DYbHqtWMja0TC3cyK6ZvOQS42eUPwap9IkH1nrbb8qXniuYI90xKqrYeGu9iBRTC2WNF099klnFABLNE+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 26 Jun 2026 12:20:58 +0200 Alexandre Ghiti <alex@ghiti.fr> wrote:

> Update zswap and zsmalloc to use per-node obj_cgroup for kmem
> accounting, attributing compressed page charges to the correct
> NUMA node.
> 
> But actually, this is incomplete because it does not correctly account
> for entries that straddle pages, those pages being possibly on 2 different
> nodes.
> 
> This will be correctly handled by Joshua in a different series [1].
> 
> Link: https://lore.kernel.org/linux-mm/20260311195153.4013476-1-joshua.hahnjy@gmail.com/ [1]
> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> ---
>  include/linux/zsmalloc.h |  2 ++
>  mm/zsmalloc.c            | 11 +++++++++++
>  mm/zswap.c               | 19 ++++++++++++++++++-
>  3 files changed, 31 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/zsmalloc.h b/include/linux/zsmalloc.h
> index 478410c880b1..30427f3fe232 100644
> --- a/include/linux/zsmalloc.h
> +++ b/include/linux/zsmalloc.h
> @@ -50,6 +50,8 @@ void zs_obj_read_sg_end(struct zs_pool *pool, unsigned long handle);
>  void zs_obj_write(struct zs_pool *pool, unsigned long handle,
>  		  void *handle_mem, size_t mem_len);
>  
> +int zs_handle_to_nid(struct zs_pool *pool, unsigned long handle);
> +
>  extern const struct movable_operations zsmalloc_mops;
>  
>  #endif
> diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> index 83f5820c45f9..17f7403ebe77 100644
> --- a/mm/zsmalloc.c
> +++ b/mm/zsmalloc.c
> @@ -1380,6 +1380,17 @@ static void obj_free(int class_size, unsigned long obj)
>  	mod_zspage_inuse(zspage, -1);
>  }
>  
> +int zs_handle_to_nid(struct zs_pool *pool, unsigned long handle)
> +{
> +	unsigned long obj;
> +	struct zpdesc *zpdesc;
> +
> +	obj = handle_to_obj(handle);
> +	obj_to_zpdesc(obj, &zpdesc);
> +	return page_to_nid(zpdesc_page(zpdesc));
> +}
> +EXPORT_SYMBOL(zs_handle_to_nid);

Does this need the same locking as the other handle-to-zspage paths?
zs_free() takes pool->lock before handle_to_obj() because zspage migration can
update or move the object behind the handle. This helper does the same decode
without the lock, so zswap's uncharge path can race migration and charge or
uncharge the wrong node, or observe transient zspage state.


> +
>  void zs_free(struct zs_pool *pool, unsigned long handle)
>  {
>  	struct zspage *zspage;
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 761cd699e0a3..466c6a3f4ef3 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -1438,7 +1438,24 @@ static bool zswap_store_page(struct page *page,
>  	 */
>  	zswap_pool_get(pool);
>  	if (objcg) {
> -		obj_cgroup_get(objcg);
> +		struct obj_cgroup *nid_objcg;
> +		int nid = zs_handle_to_nid(pool->zs_pool, entry->handle);
> +
> +		/*
> +		 * obj_cgroup_nid() returns a borrowed RCU pointer (no
> +		 * reference), so the returned per-node objcg may be freed
> +		 * (kfree_rcu) before we use it. Pin it with a tryget inside a
> +		 * single rcu section; if it is already dying, fall back to the
> +		 * folio objcg (held by the caller) so the charge still lands on
> +		 * the right memcg, just without per-node attribution.
> +		 */
> +		rcu_read_lock();
> +		nid_objcg = obj_cgroup_nid(objcg, nid);
> +		if (nid_objcg && obj_cgroup_tryget(nid_objcg))
> +			objcg = nid_objcg;
> +		else
> +			obj_cgroup_get(objcg);
> +		rcu_read_unlock();
>  		obj_cgroup_charge_zswap(objcg, entry->length);
>  	}
>  	atomic_long_inc(&zswap_stored_pages);
> -- 
> 2.54.0
> 
> 

