Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97C74CD5BAC
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 17:30:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C44136B00A0; Thu, 21 May 2026 13:30:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF4A66B00A3; Thu, 21 May 2026 13:30:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE3346B00A4; Thu, 21 May 2026 13:30:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9F30E6B00A0
	for <linux-mm@kvack.org>; Thu, 21 May 2026 13:30:21 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4B4A61C1B6B
	for <linux-mm@kvack.org>; Thu, 21 May 2026 17:30:21 +0000 (UTC)
X-FDA: 84792115842.25.959A4E0
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9758B1A001B
	for <linux-mm@kvack.org>; Thu, 21 May 2026 17:30:19 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=baTJHRdV;
	spf=none (imf19.hostedemail.com: domain of liam@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779384619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KbROC1RMvZVOCR60m+LvXazRO+hu6hGVDgS2VEWrSyE=;
	b=Is6bRvjtTwWRX641+1S5t5YjL5QJINTh4hYIx0ihHYT7b2nAql60P8fFEI4Pp1PAElauJ1
	KzRwcDwcY2P7ZD0fnHht4I1/nTfD2MUXoSbPwqsDmn8jG2h+w2z5s6K3o4l4XVwyQHguG8
	ySX2wzr+DDvBHAfRJc4BqraciuZ5bkw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=baTJHRdV;
	spf=none (imf19.hostedemail.com: domain of liam@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779384619; a=rsa-sha256;
	cv=none;
	b=fPdNGjZvtHQt5tRK5Bl6C0JNHVIDF/oTZziwRgJBDKu9V0YMgafHtfBPWNhypdxWuq6sDs
	egki1ibAmpKXfHJ0VoLUWJ0SqhPCr2ERosegwEj/Kt41etY01/3s8wV4WIVkg4j0I0IgSL
	+wGjo3gPve5fR1LPwhpCAcsg5CB7ZIo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=KbROC1RMvZVOCR60m+LvXazRO+hu6hGVDgS2VEWrSyE=; b=baTJHRdV8nQoRmLInfmLU9g+oK
	NIKuBFrfk7vDVaT72XYmeTSmRQpl+RI8cKE9krnZhT8ZYLFIggWmS3CR8lvZA9LthssBZVJzHJ3YM
	fdPBSNTRzpzrOO9j0g8RGZ4j0HObQ5V1cAoeb8qfcFaF7t8ArRVCfCMQ9bXV8Ot7CKTilkgdEJKvb
	GwI8ajqWzKVsFXzHi/OMVKvA0Mbcl7t0gKVjd8CLkLAbjjc3qu0gmdEoWX6WeEPi3fUlf3WT/lwlK
	dw1D11JXEM0zKBs3I52113KUD9qPPJNsYAHPWoqjBrPEzMdXiVZk+u6P+3O/Hr+ncS1OJ6ZlHYm4b
	EHfNs9Fg==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wQ7Dq-00000008eAg-2Hof;
	Thu, 21 May 2026 17:30:15 +0000
Date: Thu, 21 May 2026 13:30:11 -0400
From: "Liam R . Howlett" <liam@infradead.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Dave Chinner <david@fromorbit.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Zi Yan <ziy@nvidia.com>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Kairui Song <ryncsn@gmail.com>, Mikhail Zaslonko <zaslonko@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 5/8] mm: list_lru: introduce caller locking for
 additions and deletions
Message-ID: <g3yr5nxoxdj6v23qcsl7dx3k6guzovl52yxezrkregconeci6v@gyarid536gmb>
References: <20260521150330.1955924-1-hannes@cmpxchg.org>
 <20260521150330.1955924-6-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260521150330.1955924-6-hannes@cmpxchg.org>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9758B1A001B
X-Stat-Signature: igto55hi91958otxf3yhcr9dio1do7pn
X-HE-Tag: 1779384619-848697
X-HE-Meta: U2FsdGVkX1/mb0RNPbIemG+XlZ16kBD3/DgTQd8Y9uFhTXH7UvcOFdUrY8ftSF/InQdNFliU3JpOR5Uywzu+J/Xu0ZKMJ3y/oejgl5JHHPDZV1SsOKkwvURqahx5sgftEpjV6VZljf2PauxhLxCfa1rjrTj1AH3NB+9W1N0+HpPXRvCvnqbj5TEVxOC3DeXUu82NYC77Vl56NBLfKmGOK/KChHA2MTr3q/xDm+mo4XMQARfJ1KGNLcxqp33wbhNau0Z0RqeTRjWC4SLSKUCmSWHbhChFXUci68Tj7P8zDQQ9A6ywRD8enB6rnX+0HKv4XT+WCth4urUUfXMVsW9aQmT3PKDOQmGta+2FgUBL5sSAzEqwxKZj2b6PhWVCHK5NhkYSB/hutsLp6y0Ja2Qd0f1xRMSQtvP8AUl7fNwYtC+I808zGPmpo3O7Ut6SHa0gjBR4c90XWk1lZu+xp0J52EeaXBgprT4jYxBpLpltNn0/e4T15doPw50Wh9c2t6zFVCYljBGyCY+H9PBktbCv/n4ioiI3L4XlVR7LXQswUunzzXyGaBOKYv8cbA7fyR027BbSvw73PIvCY4/NAZEaUnwCoa9OTxUaVDcxHL3Q0NkwkdXS0+JKeIiFTmRQ0tYQa+m+XRkZHMMZ2t90ct+E6nJV/jUGUbnkK0y2PsbnzNzBFMgbJLkl5KZa2Srh8oKl2n9AxQmLxsYiKoE8orbpW8p1UhpwLtvtTgV/FFFHi7oNZ/5Hlz5YDZeJznov4q332aCLA0yaJ963JMc1M9WDAr+8BvEOWVwH0Vi+lZ2ZlsM6Sm+AuaUGPvQLS+ow3BDF2uSRwKAZrpm8zbKQtx+0iuu9GS7MG8cD1TmFY//n8u0Kv09CYPnGi3e3zrS3VJUDHfXBsFSDUlxojJuX3sy/YOiL8zAm9sKmM/dSSVYwY1Nl9M1lIUndpTmY+uPndAi4ls6GeAQlwH9c1p2U6Dl
 UCXZC9oX
 E1cCM2RtulW39GEFcHuMXWEu6P/UPi9PQ7RZjnFVFu4EdqtGaLfV9s4cUcVtlfQHAiB69oVWbcpsxFfaAI/PY6UoGH3OyF2B6CouFxyDNu0337jCQ37VlhBKb/ts9zp39ud6zQ4McyaqjQEr7Y/14jFiRn7fLnz+jnNu33t+Wdns82mNMhIgxegn1d8rlrrAWqK9+6IG6swBdXCR8y8qm/Hly+M/Xm3K3LpVgUWlkLcDOZVX3nVUzp7s2RoUsY5DYeYnDdjoW1kgkqeTa7ns43UggW9u6fJ74ZJHStvF0W9PA8/kwfLxEHFFSEUwrnPo2IKaWW53Sx7vVoIVinRnjf+PYYAL065C9xh0hPhh88/EXhNfoodndLyE+Mx12bylmylG3q/G5CdKvJbmnt+CKyTv2A8W2bHd/wst8kuMYGai4OGOeI7EdM2Q/3nu74MO4rG+Lfzd//IkV2EDJ/O8PwPkrbhJO/0tVixrr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/05/21 11:02AM, Johannes Weiner wrote:
> Locking is currently internal to the list_lru API. However, a caller
> might want to keep auxiliary state synchronized with the LRU state.
> 
> For example, the THP shrinker uses the lock of its custom LRU to keep
> PG_partially_mapped and vmstats consistent.
> 
> To allow the THP shrinker to switch to list_lru, provide normal and
> irqsafe locking primitives as well as caller-locked variants of the
> addition and deletion functions.
> 
> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Liam R. Howlett (Oracle) <liam@infradead.org>

> ---
>  include/linux/list_lru.h |  41 ++++++++++++
>  mm/list_lru.c            | 131 ++++++++++++++++++++++++++++++---------
>  2 files changed, 141 insertions(+), 31 deletions(-)
> 
> diff --git a/include/linux/list_lru.h b/include/linux/list_lru.h
> index fe739d35a864..c79ed378311f 100644
> --- a/include/linux/list_lru.h
> +++ b/include/linux/list_lru.h
> @@ -83,6 +83,44 @@ int memcg_list_lru_alloc(struct mem_cgroup *memcg, struct list_lru *lru,
>  			 gfp_t gfp);
>  void memcg_reparent_list_lrus(struct mem_cgroup *memcg, struct mem_cgroup *parent);
>  
> +/**
> + * list_lru_lock: lock the sublist for the given node and memcg
> + * @lru: the lru pointer
> + * @nid: the node id of the sublist to lock.
> + * @memcg: the cgroup of the sublist to lock.
> + *
> + * Returns the locked list_lru_one sublist. The caller must call
> + * list_lru_unlock() when done.
> + *
> + * You must ensure that the memcg is not freed during this call (e.g., with
> + * rcu or by taking a css refcnt).
> + *
> + * Return: the locked list_lru_one, or NULL on failure
> + */
> +struct list_lru_one *list_lru_lock(struct list_lru *lru, int nid,
> +		struct mem_cgroup *memcg);
> +
> +/**
> + * list_lru_unlock: unlock a sublist locked by list_lru_lock()
> + * @l: the list_lru_one to unlock
> + */
> +void list_lru_unlock(struct list_lru_one *l);
> +
> +struct list_lru_one *list_lru_lock_irq(struct list_lru *lru, int nid,
> +		struct mem_cgroup *memcg);
> +void list_lru_unlock_irq(struct list_lru_one *l);
> +
> +struct list_lru_one *list_lru_lock_irqsave(struct list_lru *lru, int nid,
> +		struct mem_cgroup *memcg, unsigned long *irq_flags);
> +void list_lru_unlock_irqrestore(struct list_lru_one *l,
> +		unsigned long *irq_flags);
> +
> +/* Caller-locked variants, see list_lru_add() etc for documentation */
> +bool __list_lru_add(struct list_lru *lru, struct list_lru_one *l,
> +		struct list_head *item, int nid, struct mem_cgroup *memcg);
> +bool __list_lru_del(struct list_lru *lru, struct list_lru_one *l,
> +		struct list_head *item, int nid);
> +
>  /**
>   * list_lru_add: add an element to the lru list's tail
>   * @lru: the lru pointer
> @@ -115,6 +153,9 @@ void memcg_reparent_list_lrus(struct mem_cgroup *memcg, struct mem_cgroup *paren
>  bool list_lru_add(struct list_lru *lru, struct list_head *item, int nid,
>  		    struct mem_cgroup *memcg);
>  
> +bool list_lru_add_irq(struct list_lru *lru, struct list_head *item, int nid,
> +		      struct mem_cgroup *memcg);
> +
>  /**
>   * list_lru_add_obj: add an element to the lru list's tail
>   * @lru: the lru pointer
> diff --git a/mm/list_lru.c b/mm/list_lru.c
> index 65962dbf6dda..df58226eea8c 100644
> --- a/mm/list_lru.c
> +++ b/mm/list_lru.c
> @@ -15,17 +15,23 @@
>  #include "slab.h"
>  #include "internal.h"
>  
> -static inline void lock_list_lru(struct list_lru_one *l, bool irq)
> +static inline void lock_list_lru(struct list_lru_one *l, bool irq,
> +				 unsigned long *irq_flags)
>  {
> -	if (irq)
> +	if (irq_flags)
> +		spin_lock_irqsave(&l->lock, *irq_flags);
> +	else if (irq)
>  		spin_lock_irq(&l->lock);
>  	else
>  		spin_lock(&l->lock);
>  }
>  
> -static inline void unlock_list_lru(struct list_lru_one *l, bool irq_off)
> +static inline void unlock_list_lru(struct list_lru_one *l, bool irq_off,
> +				   unsigned long *irq_flags)
>  {
> -	if (irq_off)
> +	if (irq_flags)
> +		spin_unlock_irqrestore(&l->lock, *irq_flags);
> +	else if (irq_off)
>  		spin_unlock_irq(&l->lock);
>  	else
>  		spin_unlock(&l->lock);
> @@ -78,7 +84,7 @@ list_lru_from_memcg_idx(struct list_lru *lru, int nid, int idx)
>  
>  static inline struct list_lru_one *
>  lock_list_lru_of_memcg(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
> -		       bool irq, bool skip_empty)
> +		       bool irq, unsigned long *irq_flags, bool skip_empty)
>  {
>  	struct list_lru_one *l;
>  
> @@ -86,12 +92,12 @@ lock_list_lru_of_memcg(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
>  again:
>  	l = list_lru_from_memcg_idx(lru, nid, memcg_kmem_id(memcg));
>  	if (likely(l)) {
> -		lock_list_lru(l, irq);
> +		lock_list_lru(l, irq, irq_flags);
>  		if (likely(READ_ONCE(l->nr_items) != LONG_MIN)) {
>  			rcu_read_unlock();
>  			return l;
>  		}
> -		unlock_list_lru(l, irq);
> +		unlock_list_lru(l, irq, irq_flags);
>  	}
>  	/*
>  	 * Caller may simply bail out if raced with reparenting or
> @@ -132,38 +138,106 @@ list_lru_from_memcg_idx(struct list_lru *lru, int nid, int idx)
>  
>  static inline struct list_lru_one *
>  lock_list_lru_of_memcg(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
> -		       bool irq, bool skip_empty)
> +		       bool irq, unsigned long *irq_flags, bool skip_empty)
>  {
>  	struct list_lru_one *l = &lru->node[nid].lru;
>  
> -	lock_list_lru(l, irq);
> +	lock_list_lru(l, irq, irq_flags);
>  
>  	return l;
>  }
>  #endif /* CONFIG_MEMCG */
>  
> -/* The caller must ensure the memcg lifetime. */
> -bool list_lru_add(struct list_lru *lru, struct list_head *item, int nid,
> -		  struct mem_cgroup *memcg)
> +struct list_lru_one *list_lru_lock(struct list_lru *lru, int nid,
> +				   struct mem_cgroup *memcg)
>  {
> -	struct list_lru_node *nlru = &lru->node[nid];
> -	struct list_lru_one *l;
> +	return lock_list_lru_of_memcg(lru, nid, memcg, /*irq=*/false,
> +				      /*irq_flags=*/NULL, /*skip_empty=*/false);
> +}
> +
> +void list_lru_unlock(struct list_lru_one *l)
> +{
> +	unlock_list_lru(l, /*irq_off=*/false, /*irq_flags=*/NULL);
> +}
> +
> +struct list_lru_one *list_lru_lock_irq(struct list_lru *lru, int nid,
> +				       struct mem_cgroup *memcg)
> +{
> +	return lock_list_lru_of_memcg(lru, nid, memcg, /*irq=*/true,
> +				      /*irq_flags=*/NULL, /*skip_empty=*/false);
> +}
> +
> +void list_lru_unlock_irq(struct list_lru_one *l)
> +{
> +	unlock_list_lru(l, /*irq_off=*/true, /*irq_flags=*/NULL);
> +}
>  
> -	l = lock_list_lru_of_memcg(lru, nid, memcg, false, false);
> +struct list_lru_one *list_lru_lock_irqsave(struct list_lru *lru, int nid,
> +					   struct mem_cgroup *memcg,
> +					   unsigned long *flags)
> +{
> +	return lock_list_lru_of_memcg(lru, nid, memcg, /*irq=*/true,
> +				      /*irq_flags=*/flags, /*skip_empty=*/false);
> +}
> +
> +void list_lru_unlock_irqrestore(struct list_lru_one *l, unsigned long *flags)
> +{
> +	unlock_list_lru(l, /*irq_off=*/true, /*irq_flags=*/flags);
> +}
> +
> +bool __list_lru_add(struct list_lru *lru, struct list_lru_one *l,
> +		    struct list_head *item, int nid,
> +		    struct mem_cgroup *memcg)
> +{
>  	if (list_empty(item)) {
>  		list_add_tail(item, &l->list);
>  		/* Set shrinker bit if the first element was added */
>  		if (!l->nr_items++)
>  			set_shrinker_bit(memcg, nid, lru_shrinker_id(lru));
> -		unlock_list_lru(l, false);
> -		atomic_long_inc(&nlru->nr_items);
> +		atomic_long_inc(&lru->node[nid].nr_items);
>  		return true;
>  	}
> -	unlock_list_lru(l, false);
>  	return false;
>  }
>  EXPORT_SYMBOL_GPL(list_lru_add);
>  
> +bool __list_lru_del(struct list_lru *lru, struct list_lru_one *l,
> +		    struct list_head *item, int nid)
> +{
> +	if (!list_empty(item)) {
> +		list_del_init(item);
> +		l->nr_items--;
> +		atomic_long_dec(&lru->node[nid].nr_items);
> +		return true;
> +	}
> +	return false;
> +}
> +
> +/* The caller must ensure the memcg lifetime. */
> +bool list_lru_add(struct list_lru *lru, struct list_head *item, int nid,
> +		  struct mem_cgroup *memcg)
> +{
> +	struct list_lru_one *l;
> +	bool ret;
> +
> +	l = list_lru_lock(lru, nid, memcg);
> +	ret = __list_lru_add(lru, l, item, nid, memcg);
> +	list_lru_unlock(l);
> +	return ret;
> +}
> +
> +bool list_lru_add_irq(struct list_lru *lru, struct list_head *item,
> +		      int nid, struct mem_cgroup *memcg)
> +{
> +	struct list_lru_one *l;
> +	bool ret;
> +
> +	l = list_lru_lock_irq(lru, nid, memcg);
> +	ret = __list_lru_add(lru, l, item, nid, memcg);
> +	list_lru_unlock_irq(l);
> +	return ret;
> +}
> +
>  bool list_lru_add_obj(struct list_lru *lru, struct list_head *item)
>  {
>  	bool ret;
> @@ -185,19 +259,13 @@ EXPORT_SYMBOL_GPL(list_lru_add_obj);
>  bool list_lru_del(struct list_lru *lru, struct list_head *item, int nid,
>  		  struct mem_cgroup *memcg)
>  {
> -	struct list_lru_node *nlru = &lru->node[nid];
>  	struct list_lru_one *l;
> +	bool ret;
>  
> -	l = lock_list_lru_of_memcg(lru, nid, memcg, false, false);
> -	if (!list_empty(item)) {
> -		list_del_init(item);
> -		l->nr_items--;
> -		unlock_list_lru(l, false);
> -		atomic_long_dec(&nlru->nr_items);
> -		return true;
> -	}
> -	unlock_list_lru(l, false);
> -	return false;
> +	l = list_lru_lock(lru, nid, memcg);
> +	ret = __list_lru_del(lru, l, item, nid);
> +	list_lru_unlock(l);
> +	return ret;
>  }
>  
>  bool list_lru_del_obj(struct list_lru *lru, struct list_head *item)
> @@ -270,7 +338,8 @@ __list_lru_walk_one(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
>  	unsigned long isolated = 0;
>  
>  restart:
> -	l = lock_list_lru_of_memcg(lru, nid, memcg, irq_off, true);
> +	l = lock_list_lru_of_memcg(lru, nid, memcg, /*irq=*/irq_off,
> +				   /*irq_flags=*/NULL, /*skip_empty=*/true);
>  	if (!l)
>  		return isolated;
>  	list_for_each_safe(item, n, &l->list) {
> @@ -311,7 +380,7 @@ __list_lru_walk_one(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
>  			BUG();
>  		}
>  	}
> -	unlock_list_lru(l, irq_off);
> +	unlock_list_lru(l, irq_off, NULL);
>  out:
>  	return isolated;
>  }
> -- 
> 2.54.0
> 

