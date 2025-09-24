Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F290CAC5B0
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 09:24:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86D2F8E000A; Wed, 24 Sep 2025 05:24:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81E188E0001; Wed, 24 Sep 2025 05:24:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70C7D8E000A; Wed, 24 Sep 2025 05:24:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5A65B8E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 05:24:07 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 022B81A0748
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 09:24:06 +0000 (UTC)
X-FDA: 83923607334.15.171EEDD
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf14.hostedemail.com (Postfix) with ESMTP id C137E10000D
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 09:24:03 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pTSQvpMO;
	spf=pass (imf14.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758705845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wzo9Dce6E9bbwacKQ1Ls7mKYPDh+vWG+TtUgCH/OXas=;
	b=8cww/cnjv4cN9qUsuCBZzggRjc8LA8uU5g3QennYctEdwbKZOXPbeF5ZpELSgDRaoCKAbg
	Gen/zpADH4ZAcuS1osZ8Of6lHarwpQqxaSkeCGSdEzlfa7POSKypLyDORV1yxE1XIB+rsC
	nzEtVtB+yp7nL9BmLivGdaA0aThKCbI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758705845; a=rsa-sha256;
	cv=none;
	b=0c04Tz+f1UQqf2GXQ7rsSeg5FjanTJiYeDptmsDsCRw4JKgKkN4l3Kle7lfjqua6LBPPg0
	uyrmyV/X1F+45rbq9/GK8lsHK6dsSsRM7YTZ/Yx4lgoHd5IamGSNAmM1TjmU0orTULTIOD
	81OWzjQboG8IHqtg+GXQSXv1tIBsCJ4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pTSQvpMO;
	spf=pass (imf14.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758705841;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Wzo9Dce6E9bbwacKQ1Ls7mKYPDh+vWG+TtUgCH/OXas=;
	b=pTSQvpMOMjgXR64fDZuX0h3oxFz000s6Zr4Ovo6DPMsm1S5N8H8RS0PBUenEQIWyqabi4n
	rWKzQRXKWeCwCui0yJfERDJiGtQSaY7oxafIm5sfifcNNC0J1B2rfaXfIcmvtRzPDIsuLg
	SnJeD0BWSWGTvXOWCde/Zfqt48JVv18=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: hannes@cmpxchg.org,  hughd@google.com,  mhocko@suse.com,
  shakeel.butt@linux.dev,  muchun.song@linux.dev,  david@redhat.com,
  lorenzo.stoakes@oracle.com,  ziy@nvidia.com,  harry.yoo@oracle.com,
  baolin.wang@linux.alibaba.com,  Liam.Howlett@oracle.com,
  npache@redhat.com,  ryan.roberts@arm.com,  dev.jain@arm.com,
  baohua@kernel.org,  lance.yang@linux.dev,  akpm@linux-foundation.org,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org,
  cgroups@vger.kernel.org
Subject: Re: [PATCH v2 4/4] mm: thp: reparent the split queue during memcg
 offline
In-Reply-To: <55370bda7b2df617033ac12116c1712144bb7591.1758618527.git.zhengqi.arch@bytedance.com>
	(Qi Zheng's message of "Tue, 23 Sep 2025 17:16:25 +0800")
References: <cover.1758618527.git.zhengqi.arch@bytedance.com>
	<55370bda7b2df617033ac12116c1712144bb7591.1758618527.git.zhengqi.arch@bytedance.com>
Date: Wed, 24 Sep 2025 09:23:49 +0000
Message-ID: <7ia4bjn06w62.fsf@castle.c.googlers.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 85pwut1cjeje7kkttfa6z6baht4xi4cs
X-Rspam-User: 
X-Rspamd-Queue-Id: C137E10000D
X-Rspamd-Server: rspam10
X-HE-Tag: 1758705843-558525
X-HE-Meta: U2FsdGVkX19Qw1LceVri4GCcKt2pB9F7QccAyQGqXS2TCaYQ1EiXjpXueL7fMVviTScsxiIi7ahAxwJBWDBkmmbgLFDToraSZilcZ6ebflA+5UZjMGJX9Q/dv11wWCGBPhGfmTx3CVQea5wO++CVoEQiJ2aPivJ4O9UgSecvJjXy/Hc2UJXGBHd1p8mK6w0wlCpR1vtAilT1wbfobADu5W0OoK1TfiZ59dfMp6FQTECj5pmzn0p9E1V4jxrEhxLOqtR2GZDdaJNqyYNIjCrAFfuk3kXZuvY97fURTJ0YmbdcffnHF0yrvrMeaq5tl7wCfQFlU3pcPjw+BFPDt93cNIef0t/RndLEInEBmCIB6zbNMRwcAP+gmRaud2n7iOr4pfbMNm1hSrzqiSmCjAqTXauylnG2b59rt8QVLxWua+xn3qmS5rrH4EYEkh0BRi/RbIHad+AFayb93Yj1/6lY8njtqYnOqjD6ETkRxW8AGdZ5/Xoq8UTY5rmcEmVL50n/qNnNuyRdc5XVABgtMmywhyEaX/hFIB9fk3OYioAkfvL/anuYaVujDjk8ZjavW46LjkiQtnpQdBW9dIBnO61X94wK7LBUfnMSegtmSEXr/H1AeyUYwKxhFV43aSQZ3OvoZKNQ9MKTnl8ZF8kHqwwJH/50C3jsPLvetFrLLhvCJa9kegm4H4gFSlToHZksbD+KdSBd0MEi3YG2fNmQaeSNboa+S5qA8DkDxiriSYCikeXokKXwKmRPtc16hy4f7GTw5gcj5AlUZdX8HI9BTqTHyCjWCFFLa8Vs+1spGzYK/B/uzZBQpCTRG4Z27n2mN1S+PFuaH7hHIyBwsBoIio5LbjHLib8M6rbPWx42c5SBW3s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Qi Zheng <zhengqi.arch@bytedance.com> writes:

> In the future, we will reparent LRU folios during memcg offline to
> eliminate dying memory cgroups, which requires reparenting the split queue
> to its parent.

Nit: commit logs should really focus on the actual change, not the future
plans.

>
> Similar to list_lru, the split queue is relatively independent and does
> not need to be reparented along with objcg and LRU folios (holding
> objcg lock and lru lock). So let's apply the same mechanism as list_lru
> to reparent the split queue separately when memcg is offine.
>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---
>  include/linux/huge_mm.h |  2 ++
>  include/linux/mmzone.h  |  1 +
>  mm/huge_memory.c        | 39 +++++++++++++++++++++++++++++++++++++++
>  mm/memcontrol.c         |  1 +
>  mm/mm_init.c            |  1 +
>  5 files changed, 44 insertions(+)
>
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index f327d62fc9852..a0d4b751974d2 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -417,6 +417,7 @@ static inline int split_huge_page(struct page *page)
>  	return split_huge_page_to_list_to_order(page, NULL, ret);
>  }
>  void deferred_split_folio(struct folio *folio, bool partially_mapped);
> +void reparent_deferred_split_queue(struct mem_cgroup *memcg);
>  
>  void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
>  		unsigned long address, bool freeze);
> @@ -611,6 +612,7 @@ static inline int try_folio_split(struct folio *folio, struct page *page,
>  }
>  
>  static inline void deferred_split_folio(struct folio *folio, bool partially_mapped) {}
> +static inline void reparent_deferred_split_queue(struct mem_cgroup *memcg) {}
>  #define split_huge_pmd(__vma, __pmd, __address)	\
>  	do { } while (0)
>  
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 7fb7331c57250..f3eb81fee056a 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -1346,6 +1346,7 @@ struct deferred_split {
>  	spinlock_t split_queue_lock;
>  	struct list_head split_queue;
>  	unsigned long split_queue_len;
> +	bool is_dying;
>  };
>  #endif
>  
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 48b51e6230a67..de7806f759cba 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1094,9 +1094,15 @@ static struct deferred_split *folio_split_queue_lock(struct folio *folio)
>  	struct deferred_split *queue;
>  
>  	memcg = folio_memcg(folio);
> +retry:
>  	queue = memcg ? &memcg->deferred_split_queue :
>  			&NODE_DATA(folio_nid(folio))->deferred_split_queue;
>  	spin_lock(&queue->split_queue_lock);
> +	if (unlikely(queue->is_dying == true)) {
> +		spin_unlock(&queue->split_queue_lock);
> +		memcg = parent_mem_cgroup(memcg);
> +		goto retry;
> +	}
>  
>  	return queue;
>  }
> @@ -1108,9 +1114,15 @@ folio_split_queue_lock_irqsave(struct folio *folio, unsigned long *flags)
>  	struct deferred_split *queue;
>  
>  	memcg = folio_memcg(folio);
> +retry:
>  	queue = memcg ? &memcg->deferred_split_queue :
>  			&NODE_DATA(folio_nid(folio))->deferred_split_queue;
>  	spin_lock_irqsave(&queue->split_queue_lock, *flags);
> +	if (unlikely(queue->is_dying == true)) {
> +		spin_unlock_irqrestore(&queue->split_queue_lock, *flags);
> +		memcg = parent_mem_cgroup(memcg);
> +		goto retry;
> +	}
>  
>  	return queue;
>  }
> @@ -4284,6 +4296,33 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
>  	return split;
>  }
>  
> +void reparent_deferred_split_queue(struct mem_cgroup *memcg)
> +{
> +	struct mem_cgroup *parent = parent_mem_cgroup(memcg);
> +	struct deferred_split *ds_queue = &memcg->deferred_split_queue;
> +	struct deferred_split *parent_ds_queue = &parent->deferred_split_queue;
> +	int nid;
> +
> +	spin_lock_irq(&ds_queue->split_queue_lock);
> +	spin_lock_nested(&parent_ds_queue->split_queue_lock, SINGLE_DEPTH_NESTING);
> +
> +	if (!ds_queue->split_queue_len)
> +		goto unlock;
> +
> +	list_splice_tail_init(&ds_queue->split_queue, &parent_ds_queue->split_queue);
> +	parent_ds_queue->split_queue_len += ds_queue->split_queue_len;
> +	ds_queue->split_queue_len = 0;
> +	/* Mark the ds_queue dead */
> +	ds_queue->is_dying = true;
> +
> +	for_each_node(nid)
> +		set_shrinker_bit(parent, nid, shrinker_id(deferred_split_shrinker));

Does this loop need to be under locks?

> +
> +unlock:
> +	spin_unlock(&parent_ds_queue->split_queue_lock);
> +	spin_unlock_irq(&ds_queue->split_queue_lock);
> +}
> +
>  #ifdef CONFIG_DEBUG_FS
>  static void split_huge_pages_all(void)
>  {
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index e090f29eb03bd..d03da72e7585d 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3887,6 +3887,7 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
>  	zswap_memcg_offline_cleanup(memcg);
>  
>  	memcg_offline_kmem(memcg);
> +	reparent_deferred_split_queue(memcg);
>  	reparent_shrinker_deferred(memcg);

I guess the naming can be a bit more consistent here :)

Thanks!

