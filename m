Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE327CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 11:50:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D4046B008C; Wed, 27 May 2026 07:50:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35FAD6B0093; Wed, 27 May 2026 07:50:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FE4E6B0095; Wed, 27 May 2026 07:50:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 09D1D6B008C
	for <linux-mm@kvack.org>; Wed, 27 May 2026 07:50:04 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 926DE12058E
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:50:03 +0000 (UTC)
X-FDA: 84813031086.28.EC722BE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 03B862000C
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:50:01 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="T13d3/cc";
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779882602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1i4tjDsZPp572HglBolUOi1mV5BbE0JYCKltZzPQjRo=;
	b=rCFgfcuhfo1HujkQvxOp86TXCIPd5GMH0HPW0o1IsDGERU9F/ZB4wKD8S224omjvFVv1ym
	7YijTMWZCiHkU9tALN3fjGDKzc81SxV8aPSRlVHxz5D+fKbLZL4EdWvRF35OGsz3C6uTne
	MwWxJrYPXyHigct9TAVeNRIPOCko/bM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779882602; a=rsa-sha256;
	cv=none;
	b=n2ej6nJQDhK7mHWfDbveypRpuUggDClx2JwXwHo+IMo5mi/VGebi6saiP/cPO8RpQfoTmL
	qp9WPRP1y6ORQho0VWpj4EpGl8NcPrDmplA42mCeIOdI4cOdZDzizmf3Bas2PTf30w522a
	mSGVK6wdRmWNUZ+KYp4r0lrDLf0I+fg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="T13d3/cc";
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 482AD600AB;
	Wed, 27 May 2026 11:50:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75D8B1F000E9;
	Wed, 27 May 2026 11:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779882601;
	bh=1i4tjDsZPp572HglBolUOi1mV5BbE0JYCKltZzPQjRo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=T13d3/ccYiLbVhwDYukL2lWUhLlfl3uBRCLqHp/EDFBMLJeN6cwbHwstzU/q6gb68
	 9rqJpRjvvwb6HV4McTPSaEJIgbWRbSDFM7P95xFKL1cgAnSZmNO4gG734MMxceNKNb
	 JvH1ByHBZYsvjzqcshY6bKH+/9pWQQrEeN66t6iwxVgx5MQ1NCDySX680HBrOApbz9
	 Gj2NPsDV/X7pXEHPOqg77JkGpinHGt+VKQrZ3/0cfNqdLjfTg3VzR7MM2in03di49O
	 XLW9Jp77sW8SzERDcH+MBLur3/BI6fmK9nWVHALj1VIAbMGDqfwWdbKZkkh9ox4q88
	 0ghSGin+PEG3g==
Date: Wed, 27 May 2026 12:49:43 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: tao <tao.wangtao@honor.com>
Cc: catalin.marinas@arm.com, will@kernel.org, tglx@kernel.org, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	akpm@linux-foundation.org, david@kernel.org, willy@infradead.org, sj@kernel.org, 
	kees@kernel.org, luizcap@redhat.com, zhangjiao2@cmss.chinamobile.com, 
	kas@kernel.org, hpa@zytor.com, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, jack@suse.cz, 
	riel@surriel.com, harry@kernel.org, jannh@google.com, jgg@ziepe.ca, 
	jhubbard@nvidia.com, peterx@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, xu.xin16@zte.com.cn, chengming.zhou@linux.dev, 
	nao.horiguchi@gmail.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, pfalcato@suse.de, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, damon@lists.linux.dev, shakeel.butt@linux.dev, ryncsn@gmail.com, 
	21cnbao@gmail.com, jparsana@google.com, dvander@google.com, zhangji1@honor.com, 
	wangzicheng@honor.com
Subject: Re: [PATCH 02/15] mm: convert anon_vma rmap APIs to anon_rmap
Message-ID: <ahbZdWDiqTCWU77K@lucifer>
References: <20260527110147.17815-1-tao.wangtao@honor.com>
 <20260527110147.17815-3-tao.wangtao@honor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260527110147.17815-3-tao.wangtao@honor.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 03B862000C
X-Stat-Signature: azgijhhtmw6waeq58hiogjucingdjg6c
X-Rspamd-Server: rspam06
X-HE-Tag: 1779882601-839391
X-HE-Meta: U2FsdGVkX18cOWQGHwLdW0Y9fOXaxurc+Yoao34OSOmMMfw7De/A4rMjE15DGwDdmIS1nT3V/hMU2jivZ3OWsZXss7wBVrrzUQ7ef5YwZOYDxssivF3+4gb0KgJsGoHKaf/XJJJAd7A8AHAGayJrlO/0uKuxXsU28VrX8cQUDMbsEAtadfxBXW/pBfO9dGBAYuR46dHPU98c916cR8lvJG7QAG4ZqsAVzGLr82z/EY+NUhujSQwPmzbOd7lpHwt9Dl9Z4Lp64sDeXE/T93XQf61wIR6ybYc4pymnDC/dhgU52mymdbJeopsc+fgQwG2DkNlRDFoaFrEF30qFHY8pBA1I5k5MDDlHsxs4r2UyBNkspZzYchDhlH2SM2xFw+e0g9/+xU8A0UzBlvPmO8i3ntKwz+54OVg5i3FRfJGjdRULqKIkGyLE4X7p1DVC27naE2PYHYuRTPr7gzPYMriKWD5YAQKubn5oYTipU2eH2ICIykqiNmW7IYVR4CBxtR2JjXOGsAcytYZQxf0Hxk0WKpjkmSUweZzEJymcn3/Ecm/kuNLlzu8KZV9+b8CsZAaa2TERWciZZdqO3FVacK7TutQkWoeoAjxXj8GizkVG7xEBq9Ux0fT3wBXziaVihtE7O6O90iTpzSW13py2NlawXH6y73x71JUTGDlYBZ9jVAH70Xap6SKnMw0VkphQ4xCEJLBZ/tL8NAcHH+rxlW7TKQibKwi5iX4JgpmKM2iuHkPI2GgBZsCsqG5iGSTrSwCvZ421JANBETAiQolxeJ8kN7PdPMZY3Zd0lwLIM7ArrHygrUz4VtJUxf8am0jhF9Sg1VE+f4zsG5A9EZLFSfUOo5ziL7QkBnF6lZi/QuqM+QiZCx5RRy3GpkEYA1jkYGTMMkESyMecdcRr+lkVURrZ5sS00d8rMfX/wWtxRBSgoynJRTbbDzE3j6FEwrExkmGPoLRsOddRaalxhUgR2up
 X8VzrZGG
 77hvVNm8cSViNEr/IzvN0vDjh9W0dqZF5O1pxTlwOPWRXPGohfC1o8pRtwZwfdCH240WvPIDa9+Pxb3hI0ONYdCV/trwudeek389vokBnTDR5+3Rr+lVkWaju1kiQ3dYZaYksWvFi6xWnp0nl3oQf3VOyhYKD3UaJH5sxPrrvRAqas7AmGVrRot1f2Tb91JOOLrvBdWb55xrH2pq/g3Q1/l1v7jvYqBqmTyn/L752IMcA+R669nens5Fc8xZwP8CClgFrvIA/7RyguBtairerQfxOiR9K2dmL6wuLZH5libufw6iUKswM67huRpggR6ZnybloIfr5zEV9zMCJkt9l0ox/qfxPzAx6YRCz7Dq+u2+7SvuxYp5s5OlQjzJdQUwJ4+WcvtxrwLWdoqWtHsoXqGJEtUldkxIYNVHMvCPO9ckCDFE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 27, 2026 at 07:01:34PM +0800, tao wrote:
> Convert the rmap anon_vma interfaces to anon_rmap APIs to clarify the
> semantics of anonymous rmap operations and prepare for upcoming
> ANON_VMA_LAZY support and RCU-based lockless rmap traversal.
>
> Replace folio_anon_vma(), folio_get_anon_vma(), folio_lock_anon_vma_read(),
> anon_vma_trylock_read(), anon_vma_lock_read(), anon_vma_unlock_read(),
> anon_vma_trylock_write(), anon_vma_lock_write(), anon_vma_unlock_write(),
> and vma_interval_tree_foreach() with the anon_rmap APIs.

This is another worthless commit message. You're again just writing what you did
not why or what for. This gives no help whatsoever.

>
> No functional change intended.

Err, there is a functional change, since you're literally changing how things
iterate?

>
> Signed-off-by: tao <tao.wangtao@honor.com>

All of this is terrible, you're replacing a broken abstraction with something
that assumes something completely broken with zero explanation.

No to this.

> ---
>  include/linux/rmap.h  |  6 ++--
>  mm/damon/ops-common.c |  4 +--
>  mm/huge_memory.c      | 16 +++++------
>  mm/ksm.c              | 43 ++++++++++++++---------------
>  mm/memory-failure.c   | 11 ++++----
>  mm/migrate.c          | 64 +++++++++++++++++++++----------------------
>  mm/page_idle.c        |  2 +-
>  mm/rmap.c             | 51 ++++++++++++++++++----------------
>  8 files changed, 98 insertions(+), 99 deletions(-)
>
> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
> index c42314ea4362..9802bce92695 100644
> --- a/include/linux/rmap.h
> +++ b/include/linux/rmap.h
> @@ -997,15 +997,13 @@ struct rmap_walk_control {
>  	bool (*rmap_one)(struct folio *folio, struct vm_area_struct *vma,
>  					unsigned long addr, void *arg);
>  	int (*done)(struct folio *folio);
> -	struct anon_vma *(*anon_lock)(const struct folio *folio,
> -				      struct rmap_walk_control *rwc);
> +	anon_rmap_t (*anon_lock)(const struct folio *folio,
> +				 struct rmap_walk_control *rwc);
>  	bool (*invalid_vma)(struct vm_area_struct *vma, void *arg);
>  };
>
>  void rmap_walk(struct folio *folio, struct rmap_walk_control *rwc);
>  void rmap_walk_locked(struct folio *folio, struct rmap_walk_control *rwc);
> -struct anon_vma *folio_lock_anon_vma_read(const struct folio *folio,
> -					  struct rmap_walk_control *rwc);
>
>  bool folio_maybe_same_anon_vma(const struct folio *folio,
>  	const struct vm_area_struct *vma);
> diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
> index 8c6d613425c1..5788410965b8 100644
> --- a/mm/damon/ops-common.c
> +++ b/mm/damon/ops-common.c
> @@ -172,7 +172,7 @@ void damon_folio_mkold(struct folio *folio)
>  {
>  	struct rmap_walk_control rwc = {
>  		.rmap_one = damon_folio_mkold_one,
> -		.anon_lock = folio_lock_anon_vma_read,
> +		.anon_lock = folio_lock_anon_rmap_read,
>  	};
>
>  	if (!folio_mapped(folio) || !folio_raw_mapping(folio)) {
> @@ -236,7 +236,7 @@ bool damon_folio_young(struct folio *folio)
>  	struct rmap_walk_control rwc = {
>  		.arg = &accessed,
>  		.rmap_one = damon_folio_young_one,
> -		.anon_lock = folio_lock_anon_vma_read,
> +		.anon_lock = folio_lock_anon_rmap_read,
>  	};
>
>  	if (!folio_mapped(folio) || !folio_raw_mapping(folio)) {
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 970e077019b7..ab3c2397449a 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4051,7 +4051,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>  	struct folio *end_folio = folio_next(folio);
>  	bool is_anon = folio_test_anon(folio);
>  	struct address_space *mapping = NULL;
> -	struct anon_vma *anon_vma = NULL;
> +	anon_rmap_t anon_rmap = ANON_RMAP_NULL;
>  	int old_order = folio_order(folio);
>  	struct folio *new_folio, *next;
>  	int nr_shmem_dropped = 0;
> @@ -4087,12 +4087,12 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>  		 * is taken to serialise against parallel split or collapse
>  		 * operations.
>  		 */
> -		anon_vma = folio_get_anon_vma(folio);
> -		if (!anon_vma) {
> +		anon_rmap = folio_get_anon_rmap(folio);
> +		if (!anon_rmap_value(anon_rmap)) {
>  			ret = -EBUSY;
>  			goto out;
>  		}
> -		anon_vma_lock_write(anon_vma);
> +		anon_rmap_lock_write(anon_rmap);
>  		mapping = NULL;
>  	} else {
>  		unsigned int min_order;
> @@ -4122,7 +4122,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>  			}
>  		}
>
> -		anon_vma = NULL;
> +		anon_rmap = ANON_RMAP_NULL;
>  		i_mmap_lock_read(mapping);
>
>  		/*
> @@ -4200,9 +4200,9 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>  	}
>
>  out_unlock:
> -	if (anon_vma) {
> -		anon_vma_unlock_write(anon_vma);
> -		put_anon_vma(anon_vma);
> +	if (anon_rmap_value(anon_rmap)) {
> +		anon_rmap_unlock_write(anon_rmap);
> +		put_anon_rmap(anon_rmap);
>  	}
>  	if (mapping)
>  		i_mmap_unlock_read(mapping);
> diff --git a/mm/ksm.c b/mm/ksm.c
> index 7d5b76478f0b..f4c204a8a379 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -187,7 +187,7 @@ struct ksm_stable_node {
>  /**
>   * struct ksm_rmap_item - reverse mapping item for virtual addresses
>   * @rmap_list: next rmap_item in mm_slot's singly-linked rmap_list
> - * @anon_vma: pointer to anon_vma for this mm,address, when in stable tree
> + * @anon_rmap: anonymous folio rmap for this mm,address, when in stable tree
>   * @nid: NUMA node id of unstable tree in which linked (may not match page)
>   * @mm: the memory structure this rmap_item is pointing into
>   * @address: the virtual address this rmap_item tracks (+ flags in low bits)
> @@ -201,7 +201,7 @@ struct ksm_stable_node {
>  struct ksm_rmap_item {
>  	struct ksm_rmap_item *rmap_list;
>  	union {
> -		struct anon_vma *anon_vma;	/* when stable */
> +		anon_rmap_t anon_rmap;	/* when stable */
>  #ifdef CONFIG_NUMA
>  		int nid;		/* when node of unstable tree */
>  #endif
> @@ -786,7 +786,7 @@ static void break_cow(struct ksm_rmap_item *rmap_item)
>  	 * It is not an accident that whenever we want to break COW
>  	 * to undo, we also need to drop a reference to the anon_vma.
>  	 */
> -	put_anon_vma(rmap_item->anon_vma);
> +	put_anon_rmap(rmap_item->anon_rmap);
>
>  	mmap_read_lock(mm);
>  	vma = find_mergeable_vma(mm, addr);
> @@ -898,7 +898,7 @@ static void remove_node_from_stable_tree(struct ksm_stable_node *stable_node)
>
>  		VM_BUG_ON(stable_node->rmap_hlist_len <= 0);
>  		stable_node->rmap_hlist_len--;
> -		put_anon_vma(rmap_item->anon_vma);
> +		put_anon_rmap(rmap_item->anon_rmap);
>  		rmap_item->address &= PAGE_MASK;
>  		cond_resched();
>  	}
> @@ -1051,7 +1051,7 @@ static void remove_rmap_item_from_tree(struct ksm_rmap_item *rmap_item)
>  		VM_BUG_ON(stable_node->rmap_hlist_len <= 0);
>  		stable_node->rmap_hlist_len--;
>
> -		put_anon_vma(rmap_item->anon_vma);
> +		put_anon_rmap(rmap_item->anon_rmap);
>  		rmap_item->head = NULL;
>  		rmap_item->address &= PAGE_MASK;
>
> @@ -1598,9 +1598,8 @@ static int try_to_merge_with_ksm_page(struct ksm_rmap_item *rmap_item,
>  	/* Unstable nid is in union with stable anon_vma: remove first */
>  	remove_rmap_item_from_tree(rmap_item);
>
> -	/* Must get reference to anon_vma while still holding mmap_lock */
> -	rmap_item->anon_vma = vma->anon_vma;
> -	get_anon_vma(vma->anon_vma);
> +	/* Must get reference to anon_rmap while still holding mmap_lock */
> +	rmap_item->anon_rmap = vma_get_anon_rmap(vma);
>  out:
>  	mmap_read_unlock(mm);
>  	trace_ksm_merge_with_ksm_page(kpage, page_to_pfn(kpage ? kpage : page),
> @@ -3108,7 +3107,6 @@ struct folio *ksm_might_need_to_copy(struct folio *folio,
>  			struct vm_area_struct *vma, unsigned long addr)
>  {
>  	struct page *page = folio_page(folio, 0);
> -	struct anon_vma *anon_vma = folio_anon_vma(folio);
>  	struct folio *new_folio;
>
>  	if (folio_test_large(folio))
> @@ -3118,10 +3116,10 @@ struct folio *ksm_might_need_to_copy(struct folio *folio,
>  		if (folio_stable_node(folio) &&
>  		    !(ksm_run & KSM_RUN_UNMERGE))
>  			return folio;	/* no need to copy it */
> -	} else if (!anon_vma) {
> +	} else if (!folio_test_anon(folio)) {
>  		return folio;		/* no need to copy it */
>  	} else if (folio->index == linear_page_index(vma, addr) &&
> -			anon_vma->root == vma->anon_vma->root) {
> +			folio_maybe_same_anon_vma(folio, vma)) {
>  		return folio;		/* still no need to copy it */
>  	}
>  	if (PageHWPoison(page))
> @@ -3173,20 +3171,20 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
>  	hlist_for_each_entry(rmap_item, &stable_node->hlist, hlist) {
>  		/* Ignore the stable/unstable/sqnr flags */
>  		const unsigned long addr = rmap_item->address & PAGE_MASK;
> -		struct anon_vma *anon_vma = rmap_item->anon_vma;
> +		anon_rmap_t anon_rmap = rmap_item->anon_rmap;
>  		struct anon_vma_chain *vmac;
>  		struct vm_area_struct *vma;
>
>  		cond_resched();
> -		if (!anon_vma_trylock_read(anon_vma)) {
> +		if (!anon_rmap_trylock_read(anon_rmap)) {
>  			if (rwc->try_lock) {
>  				rwc->contended = true;
>  				return;
>  			}
> -			anon_vma_lock_read(anon_vma);
> +			anon_rmap_lock_read(anon_rmap);
>  		}
>
> -		anon_vma_interval_tree_foreach(vmac, &anon_vma->rb_root,
> +		anon_rmap_foreach_vma(vma, vmac, anon_rmap,
>  					       0, ULONG_MAX) {
>
>  			cond_resched();
> @@ -3207,15 +3205,15 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
>  				continue;
>
>  			if (!rwc->rmap_one(folio, vma, addr, rwc->arg)) {
> -				anon_vma_unlock_read(anon_vma);
> +				anon_rmap_unlock_read(anon_rmap);
>  				return;
>  			}
>  			if (rwc->done && rwc->done(folio)) {
> -				anon_vma_unlock_read(anon_vma);
> +				anon_rmap_unlock_read(anon_rmap);
>  				return;
>  			}
>  		}
> -		anon_vma_unlock_read(anon_vma);
> +		anon_rmap_unlock_read(anon_rmap);
>  	}
>  	if (!search_new_forks++)
>  		goto again;
> @@ -3237,9 +3235,9 @@ void collect_procs_ksm(const struct folio *folio, const struct page *page,
>  	if (!stable_node)
>  		return;
>  	hlist_for_each_entry(rmap_item, &stable_node->hlist, hlist) {
> -		struct anon_vma *av = rmap_item->anon_vma;
> +		anon_rmap_t anon_rmap = rmap_item->anon_rmap;
>
> -		anon_vma_lock_read(av);
> +		anon_rmap_lock_read(anon_rmap);
>  		rcu_read_lock();
>  		for_each_process(tsk) {
>  			struct anon_vma_chain *vmac;
> @@ -3248,10 +3246,9 @@ void collect_procs_ksm(const struct folio *folio, const struct page *page,
>  				task_early_kill(tsk, force_early);
>  			if (!t)
>  				continue;
> -			anon_vma_interval_tree_foreach(vmac, &av->rb_root, 0,
> +			anon_rmap_foreach_vma(vma, vmac, anon_rmap, 0,
>  						       ULONG_MAX)
>  			{
> -				vma = vmac->vma;
>  				if (vma->vm_mm == t->mm) {
>  					addr = rmap_item->address & PAGE_MASK;
>  					add_to_kill_ksm(t, page, vma, to_kill,
> @@ -3260,7 +3257,7 @@ void collect_procs_ksm(const struct folio *folio, const struct page *page,
>  			}
>  		}
>  		rcu_read_unlock();
> -		anon_vma_unlock_read(av);
> +		anon_rmap_unlock_read(anon_rmap);
>  	}
>  }
>  #endif
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index ee42d4361309..bc9abba75b5d 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -547,11 +547,11 @@ static void collect_procs_anon(const struct folio *folio,
>  		int force_early)
>  {
>  	struct task_struct *tsk;
> -	struct anon_vma *av;
> +	anon_rmap_t anon_rmap;
>  	pgoff_t pgoff;
>
> -	av = folio_lock_anon_vma_read(folio, NULL);
> -	if (av == NULL)	/* Not actually mapped anymore */
> +	anon_rmap = folio_lock_anon_rmap_read(folio, NULL);
> +	if (!anon_rmap_value(anon_rmap))	/* Not actually mapped anymore */
>  		return;
>
>  	pgoff = page_pgoff(folio, page);
> @@ -564,9 +564,8 @@ static void collect_procs_anon(const struct folio *folio,
>
>  		if (!t)
>  			continue;
> -		anon_vma_interval_tree_foreach(vmac, &av->rb_root,
> +		anon_rmap_foreach_vma(vma, vmac, anon_rmap,
>  					       pgoff, pgoff) {
> -			vma = vmac->vma;
>  			if (vma->vm_mm != t->mm)
>  				continue;
>  			addr = page_mapped_in_vma(page, vma);
> @@ -574,7 +573,7 @@ static void collect_procs_anon(const struct folio *folio,
>  		}
>  	}
>  	rcu_read_unlock();
> -	anon_vma_unlock_read(av);
> +	anon_rmap_unlock_read(anon_rmap);
>  }
>
>  /*
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 8a64291ab5b4..769983cf14e0 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -1142,18 +1142,18 @@ enum {
>
>  static void __migrate_folio_record(struct folio *dst,
>  				   int old_page_state,
> -				   struct anon_vma *anon_vma)
> +				   anon_rmap_t anon_rmap)
>  {
> -	dst->private = (void *)anon_vma + old_page_state;
> +	dst->private = (void *)anon_rmap_to_anon_vma(anon_rmap) + old_page_state;
>  }
>
>  static void __migrate_folio_extract(struct folio *dst,
>  				   int *old_page_state,
> -				   struct anon_vma **anon_vmap)
> +				   anon_rmap_t *anon_rmapp)
>  {
>  	unsigned long private = (unsigned long)dst->private;
>
> -	*anon_vmap = (struct anon_vma *)(private & ~PAGE_OLD_STATES);
> +	*anon_rmapp = anon_vma_to_anon_rmap((void *)(private & ~PAGE_OLD_STATES));
>  	*old_page_state = private & PAGE_OLD_STATES;
>  	dst->private = NULL;
>  }
> @@ -1161,15 +1161,15 @@ static void __migrate_folio_extract(struct folio *dst,
>  /* Restore the source folio to the original state upon failure */
>  static void migrate_folio_undo_src(struct folio *src,
>  				   int page_was_mapped,
> -				   struct anon_vma *anon_vma,
> +				   anon_rmap_t anon_rmap,
>  				   bool locked,
>  				   struct list_head *ret)
>  {
>  	if (page_was_mapped)
>  		remove_migration_ptes(src, src, 0);
> -	/* Drop an anon_vma reference if we took one */
> -	if (anon_vma)
> -		put_anon_vma(anon_vma);
> +	/* Drop an anon_rmap reference if we took one */
> +	if (anon_rmap_value(anon_rmap))
> +		put_anon_rmap(anon_rmap);
>  	if (locked)
>  		folio_unlock(src);
>  	if (ret)
> @@ -1210,7 +1210,7 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
>  	struct folio *dst;
>  	int rc = -EAGAIN;
>  	int old_page_state = 0;
> -	struct anon_vma *anon_vma = NULL;
> +	anon_rmap_t anon_rmap = ANON_RMAP_NULL;
>  	bool locked = false;
>  	bool dst_locked = false;
>
> @@ -1275,19 +1275,19 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
>  	/*
>  	 * By try_to_migrate(), src->mapcount goes down to 0 here. In this case,
>  	 * we cannot notice that anon_vma is freed while we migrate a page.
> -	 * This get_anon_vma() delays freeing anon_vma pointer until the end
> +	 * This get_anon_rmap() delays freeing anon_rmap pointer until the end
>  	 * of migration. File cache pages are no problem because of page_lock()
>  	 * File Caches may use write_page() or lock_page() in migration, then,
>  	 * just care Anon page here.
>  	 *
> -	 * Only folio_get_anon_vma() understands the subtleties of
> -	 * getting a hold on an anon_vma from outside one of its mms.
> -	 * But if we cannot get anon_vma, then we won't need it anyway,
> +	 * Only folio_get_anon_rmap() understands the subtleties of
> +	 * getting a hold on an anon_rmap from outside one of its mms.
> +	 * But if we cannot get anon_rmap, then we won't need it anyway,
>  	 * because that implies that the anon page is no longer mapped
>  	 * (and cannot be remapped so long as we hold the page lock).
>  	 */
>  	if (folio_test_anon(src) && !folio_test_ksm(src))
> -		anon_vma = folio_get_anon_vma(src);
> +		anon_rmap = folio_get_anon_rmap(src);
>
>  	/*
>  	 * Block others from accessing the new page when we get around to
> @@ -1302,7 +1302,7 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
>  	dst_locked = true;
>
>  	if (unlikely(page_has_movable_ops(&src->page))) {
> -		__migrate_folio_record(dst, old_page_state, anon_vma);
> +		__migrate_folio_record(dst, old_page_state, anon_rmap);
>  		return 0;
>  	}
>
> @@ -1326,13 +1326,13 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
>  	} else if (folio_mapped(src)) {
>  		/* Establish migration ptes */
>  		VM_BUG_ON_FOLIO(folio_test_anon(src) &&
> -			       !folio_test_ksm(src) && !anon_vma, src);
> +			       !folio_test_ksm(src) && !anon_rmap_value(anon_rmap), src);
>  		try_to_migrate(src, mode == MIGRATE_ASYNC ? TTU_BATCH_FLUSH : 0);
>  		old_page_state |= PAGE_WAS_MAPPED;
>  	}
>
>  	if (!folio_mapped(src)) {
> -		__migrate_folio_record(dst, old_page_state, anon_vma);
> +		__migrate_folio_record(dst, old_page_state, anon_rmap);
>  		return 0;
>  	}
>
> @@ -1345,7 +1345,7 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
>  		ret = NULL;
>
>  	migrate_folio_undo_src(src, old_page_state & PAGE_WAS_MAPPED,
> -			       anon_vma, locked, ret);
> +			       anon_rmap, locked, ret);
>  	migrate_folio_undo_dst(dst, dst_locked, put_new_folio, private);
>
>  	return rc;
> @@ -1359,12 +1359,12 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
>  {
>  	int rc;
>  	int old_page_state = 0;
> -	struct anon_vma *anon_vma = NULL;
> +	anon_rmap_t anon_rmap = ANON_RMAP_NULL;
>  	bool src_deferred_split = false;
>  	bool src_partially_mapped = false;
>  	struct list_head *prev;
>
> -	__migrate_folio_extract(dst, &old_page_state, &anon_vma);
> +	__migrate_folio_extract(dst, &old_page_state, &anon_rmap);
>  	prev = dst->lru.prev;
>  	list_del(&dst->lru);
>
> @@ -1425,9 +1425,9 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
>  	 * and will be freed.
>  	 */
>  	list_del(&src->lru);
> -	/* Drop an anon_vma reference if we took one */
> -	if (anon_vma)
> -		put_anon_vma(anon_vma);
> +	/* Drop an anon_rmap reference if we took one */
> +	if (anon_rmap_value(anon_rmap))
> +		put_anon_rmap(anon_rmap);
>  	folio_unlock(src);
>  	migrate_folio_done(src, reason);
>
> @@ -1439,12 +1439,12 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
>  	 */
>  	if (rc == -EAGAIN) {
>  		list_add(&dst->lru, prev);
> -		__migrate_folio_record(dst, old_page_state, anon_vma);
> +		__migrate_folio_record(dst, old_page_state, anon_rmap);
>  		return rc;
>  	}
>
>  	migrate_folio_undo_src(src, old_page_state & PAGE_WAS_MAPPED,
> -			       anon_vma, true, ret);
> +			       anon_rmap, true, ret);
>  	migrate_folio_undo_dst(dst, true, put_new_folio, private);
>
>  	return rc;
> @@ -1476,7 +1476,7 @@ static int unmap_and_move_huge_page(new_folio_t get_new_folio,
>  	struct folio *dst;
>  	int rc = -EAGAIN;
>  	int page_was_mapped = 0;
> -	struct anon_vma *anon_vma = NULL;
> +	anon_rmap_t anon_rmap = ANON_RMAP_NULL;
>  	struct address_space *mapping = NULL;
>  	enum ttu_flags ttu = 0;
>
> @@ -1513,7 +1513,7 @@ static int unmap_and_move_huge_page(new_folio_t get_new_folio,
>  	}
>
>  	if (folio_test_anon(src))
> -		anon_vma = folio_get_anon_vma(src);
> +		anon_rmap = folio_get_anon_rmap(src);
>
>  	if (unlikely(!folio_trylock(dst)))
>  		goto put_anon;
> @@ -1550,8 +1550,8 @@ static int unmap_and_move_huge_page(new_folio_t get_new_folio,
>  	folio_unlock(dst);
>
>  put_anon:
> -	if (anon_vma)
> -		put_anon_vma(anon_vma);
> +	if (anon_rmap_value(anon_rmap))
> +		put_anon_rmap(anon_rmap);
>
>  	if (!rc) {
>  		move_hugetlb_state(src, dst, reason);
> @@ -1778,11 +1778,11 @@ static void migrate_folios_undo(struct list_head *src_folios,
>  	dst2 = list_next_entry(dst, lru);
>  	list_for_each_entry_safe(folio, folio2, src_folios, lru) {
>  		int old_page_state = 0;
> -		struct anon_vma *anon_vma = NULL;
> +		anon_rmap_t anon_rmap = ANON_RMAP_NULL;
>
> -		__migrate_folio_extract(dst, &old_page_state, &anon_vma);
> +		__migrate_folio_extract(dst, &old_page_state, &anon_rmap);
>  		migrate_folio_undo_src(folio, old_page_state & PAGE_WAS_MAPPED,
> -				anon_vma, true, ret_folios);
> +				anon_rmap, true, ret_folios);
>  		list_del(&dst->lru);
>  		migrate_folio_undo_dst(dst, true, put_new_folio, private);
>  		dst = dst2;
> diff --git a/mm/page_idle.c b/mm/page_idle.c
> index 9c67cbac2965..d4103f20f526 100644
> --- a/mm/page_idle.c
> +++ b/mm/page_idle.c
> @@ -102,7 +102,7 @@ static void page_idle_clear_pte_refs(struct folio *folio)
>  	 */
>  	static struct rmap_walk_control rwc = {
>  		.rmap_one = page_idle_clear_pte_refs_one,
> -		.anon_lock = folio_lock_anon_vma_read,
> +		.anon_lock = folio_lock_anon_rmap_read,
>  	};
>
>  	if (!folio_mapped(folio) || !folio_raw_mapping(folio))
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 1b2dada71778..41607168e00e 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -630,8 +630,8 @@ struct anon_vma *folio_get_anon_vma(const struct folio *folio)
>   * reference like with folio_get_anon_vma() and then block on the mutex
>   * on !rwc->try_lock case.
>   */
> -struct anon_vma *folio_lock_anon_vma_read(const struct folio *folio,
> -					  struct rmap_walk_control *rwc)
> +static struct anon_vma *folio_lock_anon_vma_read(const struct folio *folio,
> +						 struct rmap_walk_control *rwc)
>  {
>  	struct anon_vma *anon_vma = NULL;
>  	struct anon_vma *root_anon_vma;
> @@ -744,6 +744,14 @@ void anon_rmap_unlock_read(anon_rmap_t anon_rmap)
>  	anon_vma_unlock_read(anon_rmap_to_anon_vma(anon_rmap));
>  }
>
> +static anon_rmap_t folio_anon_rmap(const struct folio *folio)
> +{
> +	struct anon_vma *anon_vma;
> +
> +	anon_vma = folio_anon_vma(folio);
> +	return anon_vma ? anon_vma_to_anon_rmap(anon_vma) : ANON_RMAP_NULL;
> +}
> +
>  bool folio_maybe_same_anon_vma(const struct folio *folio,
>  	const struct vm_area_struct *vma)
>  {
> @@ -930,13 +938,11 @@ unsigned long page_address_in_vma(const struct folio *folio,
>  		const struct page *page, const struct vm_area_struct *vma)
>  {
>  	if (folio_test_anon(folio)) {
> -		struct anon_vma *anon_vma = folio_anon_vma(folio);
>  		/*
>  		 * Note: swapoff's unuse_vma() is more efficient with this
>  		 * check, and needs it to match anon_vma when KSM is active.
>  		 */
> -		if (!vma->anon_vma || !anon_vma ||
> -		    vma->anon_vma->root != anon_vma->root)
> +		if (!vma->anon_vma || !folio_maybe_same_anon_vma(folio, vma))
>  			return -EFAULT;
>  	} else if (!vma->vm_file) {
>  		return -EFAULT;
> @@ -944,7 +950,7 @@ unsigned long page_address_in_vma(const struct folio *folio,
>  		return -EFAULT;
>  	}
>
> -	/* KSM folios don't reach here because of the !anon_vma check */
> +	/* The !folio_maybe_same_anon_vma() above handles KSM folios */
>  	return vma_address(vma, page_pgoff(folio, page), 1);
>  }
>
> @@ -1145,7 +1151,7 @@ int folio_referenced(struct folio *folio, int is_locked,
>  	struct rmap_walk_control rwc = {
>  		.rmap_one = folio_referenced_one,
>  		.arg = (void *)&pra,
> -		.anon_lock = folio_lock_anon_vma_read,
> +		.anon_lock = folio_lock_anon_rmap_read,
>  		.try_lock = true,
>  		.invalid_vma = invalid_folio_referenced_vma,
>  	};
> @@ -1580,8 +1586,7 @@ static void __page_check_anon_rmap(const struct folio *folio,
>  	 * are initially only visible via the pagetables, and the pte is locked
>  	 * over the call to folio_add_new_anon_rmap.
>  	 */
> -	VM_BUG_ON_FOLIO(folio_anon_vma(folio)->root != vma->anon_vma->root,
> -			folio);
> +	VM_BUG_ON_FOLIO(!folio_maybe_same_anon_vma(folio, vma), folio);
>  	VM_BUG_ON_PAGE(page_pgoff(folio, page) != linear_page_index(vma, address),
>  		       page);
>  }
> @@ -2468,7 +2473,7 @@ void try_to_unmap(struct folio *folio, enum ttu_flags flags)
>  		.rmap_one = try_to_unmap_one,
>  		.arg = (void *)flags,
>  		.done = folio_not_mapped,
> -		.anon_lock = folio_lock_anon_vma_read,
> +		.anon_lock = folio_lock_anon_rmap_read,
>  	};
>
>  	if (flags & TTU_RMAP_LOCKED)
> @@ -2813,7 +2818,7 @@ void try_to_migrate(struct folio *folio, enum ttu_flags flags)
>  		.rmap_one = try_to_migrate_one,
>  		.arg = (void *)flags,
>  		.done = folio_not_mapped,
> -		.anon_lock = folio_lock_anon_vma_read,
> +		.anon_lock = folio_lock_anon_rmap_read,
>  	};
>
>  	/*
> @@ -2990,8 +2995,8 @@ void __put_anon_vma(struct anon_vma *anon_vma)
>  		anon_vma_free(root);
>  }
>
> -static struct anon_vma *rmap_walk_anon_lock(const struct folio *folio,
> -					    struct rmap_walk_control *rwc)
> +static anon_rmap_t rmap_walk_anon_lock(const struct folio *folio,
> +				       struct rmap_walk_control *rwc)
>  {
>  	struct anon_vma *anon_vma;
>
> @@ -3006,7 +3011,7 @@ static struct anon_vma *rmap_walk_anon_lock(const struct folio *folio,
>  	 */
>  	anon_vma = folio_anon_vma(folio);
>  	if (!anon_vma)
> -		return NULL;
> +		return ANON_RMAP_NULL;
>
>  	if (anon_vma_trylock_read(anon_vma))
>  		goto out;
> @@ -3019,7 +3024,7 @@ static struct anon_vma *rmap_walk_anon_lock(const struct folio *folio,
>
>  	anon_vma_lock_read(anon_vma);
>  out:
> -	return anon_vma;
> +	return anon_vma ? anon_vma_to_anon_rmap(anon_vma) : ANON_RMAP_NULL;
>  }
>
>  /*
> @@ -3035,9 +3040,10 @@ static struct anon_vma *rmap_walk_anon_lock(const struct folio *folio,
>  static void rmap_walk_anon(struct folio *folio,
>  		struct rmap_walk_control *rwc, bool locked)
>  {
> -	struct anon_vma *anon_vma;
> +	anon_rmap_t anon_rmap;
>  	pgoff_t pgoff_start, pgoff_end;
>  	struct anon_vma_chain *avc;
> +	struct vm_area_struct *vma;

I have no idea why you put the VMA at this scope...

>
>  	/*
>  	 * The folio lock ensures that folio->mapping can't be changed under us
> @@ -3046,20 +3052,19 @@ static void rmap_walk_anon(struct folio *folio,
>  	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
>
>  	if (locked) {
> -		anon_vma = folio_anon_vma(folio);
> +		anon_rmap = folio_anon_rmap(folio);
>  		/* anon_vma disappear under us? */
> -		VM_BUG_ON_FOLIO(!anon_vma, folio);
> +		VM_BUG_ON_FOLIO(!anon_rmap_value(anon_rmap), folio);
>  	} else {
> -		anon_vma = rmap_walk_anon_lock(folio, rwc);
> +		anon_rmap = rmap_walk_anon_lock(folio, rwc);
>  	}
> -	if (!anon_vma)
> +	if (!anon_rmap_value(anon_rmap))
>  		return;
>
>  	pgoff_start = folio_pgoff(folio);
>  	pgoff_end = pgoff_start + folio_nr_pages(folio) - 1;
> -	anon_vma_interval_tree_foreach(avc, &anon_vma->rb_root,
> +	anon_rmap_foreach_vma(vma, avc, anon_rmap,
>  			pgoff_start, pgoff_end) {
> -		struct vm_area_struct *vma = avc->vma;

Don't throw random changes like this in with a general replacement patch.

>  		unsigned long address = vma_address(vma, pgoff_start,
>  				folio_nr_pages(folio));
>
> @@ -3076,7 +3081,7 @@ static void rmap_walk_anon(struct folio *folio,
>  	}
>
>  	if (!locked)
> -		anon_vma_unlock_read(anon_vma);
> +		anon_rmap_unlock_read(anon_rmap);
>  }
>
>  /**
> --
> 2.17.1
>

