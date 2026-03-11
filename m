Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A43D1125854
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 17:00:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F5826B0089; Wed, 11 Mar 2026 13:00:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D73B6B008A; Wed, 11 Mar 2026 13:00:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80CC36B008C; Wed, 11 Mar 2026 13:00:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 617C36B0089
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 13:00:43 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EB9DB8A5D8
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 17:00:42 +0000 (UTC)
X-FDA: 84534396324.11.D2374DA
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf28.hostedemail.com (Postfix) with ESMTP id B0295C0010
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 17:00:40 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="YshX/TOw";
	spf=pass (imf28.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773248441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=umIETC/U+nnyWBOJf7jmCI9bEj8M1NXipZ+2fLbklVY=;
	b=2Z04txUyGFn5RoW0KHIKAEqeA23vsolfBtMl2DzV/nhh6DvgjtfvQ6bdjCy+kFxw8DBhKp
	9N+WE952REZEBvLf20a0gziPU/uvji0kR7snZjO9Igg79QZZvmXOpoYBLnwlCb9WSqS8Dx
	HacSDbiCBjJtQn7l7qvCicQ9Vq2bpjo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="YshX/TOw";
	spf=pass (imf28.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773248441; a=rsa-sha256;
	cv=none;
	b=QTsx8IBR1r2RX3N39HXLvBiGbiG5vXY9D3ptrVi86g2vmuUmf/3bGL+biQq4arfT2cNQf0
	q5Ti/bDNQ2cVrj3VXalDwFjsONzTxHQVQIwigcY8SzeLVHbvqvTLYmj4E1IMN2JEUcMhAE
	9DMYM+LgsogGJmNBoOW9fCFMJqQRad0=
Message-ID: <050ce5bd-4725-468e-acaf-7fca72b84d06@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773248436;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=umIETC/U+nnyWBOJf7jmCI9bEj8M1NXipZ+2fLbklVY=;
	b=YshX/TOw0pBpgg9+ne552JONlu8IFJLdSiAJhkINNKSqruyeR+PisQm6C7PXd5wGJ/8SX3
	urYZ5qOnfJU7lpdVnffb4lXOCr/PCz0ZvrBwCI0a/W0zeXQUQP7nYVJNp8cCrBvQCXV1mh
	WAtjJtOECacpkTe8kXHohGsfQBp4yHE=
Date: Wed, 11 Mar 2026 20:00:29 +0300
MIME-Version: 1.0
Subject: Re: [PATCH] mm: switch deferred split shrinker to list_lru
Content-Language: en-GB
To: Johannes Weiner <hannes@cmpxchg.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Kiryl Shutsemau
 <kas@kernel.org>, Dave Chinner <david@fromorbit.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260311154358.150977-1-hannes@cmpxchg.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20260311154358.150977-1-hannes@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B0295C0010
X-Stat-Signature: eth17awm98hua5hookxfrpq8hzht7cqb
X-Rspam-User: 
X-HE-Tag: 1773248440-321257
X-HE-Meta: U2FsdGVkX1/Oo/xtwgxq6mvp2mxAidQ5PwXUedSc3vXSshgnT6q1/kZFT8c2BwLimF9ofRvUa2Z5IRdU8twv5AbkAklvvM7/ASWHw2TMfUuuKpnuKdC/CojBvVBVNP9q91dX/ev6jBDFlfgi2qG1XtQALbf6AzKwokXDIcOVip9EB9Jt/Rlzpim4hDEcb2PeCdjJSdB4aVttrJWYmsr56F0LSXss5Qp00oF8R3aO1XRvaWfYbi526UDVnbrUXVOiflL6NN5GKql8dkPd+vrSEHljLbGnpQBTN9FcAggfpoeJEobQV50aDYJw2JOA2Nu2E43qcyL+C8iGK6HrYdtRt13eRDvngeS++5LC0kXSxu2UR7PN/UrSVt47ln5CCjUDZo4Xqa3Sw+/b76yBhQU776/3NLbLZGO8kEwUqLMVnQa+LCBqDwy3T4ECxOXSQA4+ToOSB4/MlaEOtVuJOk2dMmBGCYSaOSUd5Yla9BoE0e1+mjUYYbcb4e7Aioy0P5MvPq0zdAhN5PyUCFla6QUG40HUf9jJZ3BzpoNRx6UFpC9IVeZ0oJuZyegxQGA7uyvwF4xoiOCAycb++P7QvfFrQq1agyx6aL0c3Ep1QmMQUVgSwxHXdn5GjNuNgDVgJK05DfDYWeaCeJFOnVDb1fAA+ROd4uLcvjiGn/lBJtv+dIFIZxsJHWfEGsIieYScm9Kvxhm8Hj7EDozjzOBYFQlZhhCLJe4B5+P9ocmSDYhRphEjH6A4u1eJd4WtEaRU1/1bPSuw2kyXHYxeQwD7dejEerLnt04buHkE7qhPPAFUuBcyP7u96KJ1hk8ACYT7lf/VJi4oZ0Z8KGm/EBGzsHNpzlw71nTRQb0XHWWSoxnahPmLZJFCxufw2TXHCtV/MmkeyRxUQu/LH1NS2/q5XUHXFhO4v0sc440hj+Lm2QuGsI1Q5cspWOD3fPq4k5tffzvEHy6HxjRR8IxZi1vYI9W
 j+K8ljyW
 /ArhelZdkm2Ibp2O3PrZv2y8YFU3TieXeS7sF/Yn0zAxTmZGS42JB1j6gyhe1NAJqrYIDuH/KC1pyc1FZEBE3ijOxVFvklYMC3jt6sN8YaVnMwP3o82YPopmnj33AHUIjw07Gm+ayaeA3Zmg/UviC4EwwE+3HS95ba4cPWgyyPV4WQjm0Hqn4ujtsHh8aTf3Au+PYsK98w+GZynHQ+W76bWMUGOlau39SfIS5v0ufWQYg57SJQrjOUH6QkzgsTpGRZeqn0F9hl72ujXN0RIVyEzhL8elrowoBfwOcPnMOjP1+DU0hwsJPIskXAZGIphk+uAl+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/03/2026 18:43, Johannes Weiner wrote:
> The deferred split queue handles cgroups in a suboptimal fashion. The
> queue is per-NUMA node or per-cgroup, not the intersection. That means
> on a cgrouped system, a node-restricted allocation entering reclaim
> can end up splitting large pages on other nodes:
> 
> 	alloc/unmap
> 	  deferred_split_folio()
> 	    list_add_tail(memcg->split_queue)
> 	    set_shrinker_bit(memcg, node, deferred_shrinker_id)
> 
> 	for_each_zone_zonelist_nodemask(restricted_nodes)
> 	  mem_cgroup_iter()
> 	    shrink_slab(node, memcg)
> 	      shrink_slab_memcg(node, memcg)
> 	        if test_shrinker_bit(memcg, node, deferred_shrinker_id)
> 	          deferred_split_scan()
> 	            walks memcg->split_queue
> 
> The shrinker bit adds an imperfect guard rail. As soon as the cgroup
> has a single large page on the node of interest, all large pages owned
> by that memcg, including those on other nodes, will be split.
> 
> list_lru properly sets up per-node, per-cgroup lists. As a bonus, it
> streamlines a lot of the list operations and reclaim walks. It's used
> widely by other major shrinkers already. Convert the deferred split
> queue as well.
> 
> The list_lru per-memcg heads are instantiated on demand when the first
> object of interest is allocated for a cgroup, by calling
> memcg_list_lru_alloc(). Add calls to where splittable pages are
> created: anon faults, swapin faults, khugepaged collapse.
> 
> These calls create all possible node heads for the cgroup at once, so
> the migration code (between nodes) doesn't need any special care.
> 
> The folio_test_partially_mapped() state is currently protected and
> serialized wrt LRU state by the deferred split queue lock. To
> facilitate the transition, add helpers to the list_lru API to allow
> caller-side locking.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  include/linux/huge_mm.h    |   6 +-
>  include/linux/list_lru.h   |  48 ++++++
>  include/linux/memcontrol.h |   4 -
>  include/linux/mmzone.h     |  12 --
>  mm/huge_memory.c           | 326 +++++++++++--------------------------
>  mm/internal.h              |   2 +-
>  mm/khugepaged.c            |   7 +
>  mm/list_lru.c              | 197 ++++++++++++++--------
>  mm/memcontrol.c            |  12 +-
>  mm/memory.c                |  52 +++---
>  mm/mm_init.c               |  14 --
>  11 files changed, 310 insertions(+), 370 deletions(-)
> 

[..]

> @@ -3802,33 +3706,25 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
>  	struct folio *new_folio, *next;
>  	int old_order = folio_order(folio);
>  	int ret = 0;
> -	struct deferred_split *ds_queue;
> +	struct list_lru_one *l;
>  
>  	VM_WARN_ON_ONCE(!mapping && end);
>  	/* Prevent deferred_split_scan() touching ->_refcount */
> -	ds_queue = folio_split_queue_lock(folio);
> +	l = list_lru_lock(&deferred_split_lru, folio_nid(folio), folio_memcg(folio));

Hello Johannes!

I think we need folio_memcg() to be under rcu_read_lock()? 
folio_memcg() calls obj_cgroup_memcg() which has lockdep_assert_once(rcu_read_lock_held()).

folio_split_queue_lock() wraps split_queue_lock() under rcu_read_lock() so wasnt an issue.
 

>  	if (folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1)) {
>  		struct swap_cluster_info *ci = NULL;
>  		struct lruvec *lruvec;
>  
>  		if (old_order > 1) {
> -			if (!list_empty(&folio->_deferred_list)) {
> -				ds_queue->split_queue_len--;
> -				/*
> -				 * Reinitialize page_deferred_list after removing the
> -				 * page from the split_queue, otherwise a subsequent
> -				 * split will see list corruption when checking the
> -				 * page_deferred_list.
> -				 */
> -				list_del_init(&folio->_deferred_list);
> -			}
> +			__list_lru_del(&deferred_split_lru, l,
> +				       &folio->_deferred_list, folio_nid(folio));
>  			if (folio_test_partially_mapped(folio)) {
>  				folio_clear_partially_mapped(folio);
>  				mod_mthp_stat(old_order,
>  					MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
>  			}
>  		}
> -		split_queue_unlock(ds_queue);
> +		list_lru_unlock(l);
>  		if (mapping) {
>  			int nr = folio_nr_pages(folio);
>  
> @@ -3929,7 +3825,7 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
>  		if (ci)
>  			swap_cluster_unlock(ci);
>  	} else {
> -		split_queue_unlock(ds_queue);
> +		list_lru_unlock(l);
>  		return -EAGAIN;
>  	}
>  
[..]

