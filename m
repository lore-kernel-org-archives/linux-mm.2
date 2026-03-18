Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA2AF1088E4B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 22:49:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A23D56B0377; Wed, 18 Mar 2026 18:49:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D5286B0378; Wed, 18 Mar 2026 18:49:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C3FA6B0379; Wed, 18 Mar 2026 18:49:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 78B166B0377
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 18:49:03 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 246CA1C26F
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 22:49:03 +0000 (UTC)
X-FDA: 84560675766.29.7CBAB85
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	by imf05.hostedemail.com (Postfix) with ESMTP id D583210000F
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 22:49:00 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=EMFkAEP2;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf05.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.42 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773874141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PMr7aJnn5tbpENmXs0hgUd4j/FxLseJeRUZelWseNrw=;
	b=LYw29xDMp/4YApTsj/y/P3KiUgwoDdNzRPDj2ChwWk5GBT/u9tk/YHsT0EEiTPM1TNyMxO
	KABkryRE6qZiip0zFqk3gmXGl9DmBrP2fTC+n7JoH71yUBf5Gr/npDsWSBj7/uFiellXDT
	IIrqo3tI8qICbG1k2PUY5fxmj3ZDnDE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773874141; a=rsa-sha256;
	cv=none;
	b=f+spRJ1c9ArcMhPiHyfOsURQvbYG723MUf+TEtCLVP2hyTPDhomxX4LzK+DFl7hvalYTIx
	GdLAjN69+wr36fiiLKBpS+XjKe2PNvyWC+WypOMogZ8NY+UpxObQ3E/mJfy0t/Z2lUmnth
	aINNn7ixixDYw83LHh0dDiU/muJXiKc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=EMFkAEP2;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf05.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.42 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-89a465bd7edso3987376d6.0
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:49:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1773874140; x=1774478940; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PMr7aJnn5tbpENmXs0hgUd4j/FxLseJeRUZelWseNrw=;
        b=EMFkAEP2UosVwGsrVpBXBeW369xoM/r2EXORAa7JtW0cBuP6p7F0GJRcKP4Ep3Kq1B
         LhsVVZrZLsmnqbXzj2jBQ+JgPoFlv2kKYS6HNh/Or+rMRXnvUB8n6NF8DNj1rqzgh8w/
         ArM+TH0XFPefgybfpsi3pQfriuzXrA/nqi++36dJaZVnZwj5LsbAJotvxpf/UQptKdT6
         ZVKM49PUq7MugkwQkPogPq1+AtWDGRxGYVwJedZqNlKGHvg7a7wALNCQOK6aCTygoD5Q
         bDQPrkYNSPkzdpVUQLwT2EKUlv+CWQT5IovBb5ToleyA4QCREaSUC+PNlZyfCdhMWrK3
         HTNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773874140; x=1774478940;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PMr7aJnn5tbpENmXs0hgUd4j/FxLseJeRUZelWseNrw=;
        b=lZzF9W2jel/pk7oBc/wcYJS4JBA13Rj2hhCUwpROz9LivFy+yQ2U5hEPIyqRyoMbmn
         4ibIOqK9X2e8zDeU91Xm/t+Z9IsIB5jMXWM3E1pYOtlaWRZoouCQ57NUCGowN0fIZXDc
         Jr+eXNNBsnFMuITz3k4B4YAs6l70AM8Dt2nw0J+f1q2febTSIi8A1SMpumABo2HBD4a1
         Ju7plwzQoVAb2OybgBGBg0K9QbBsP2EmoFiXwvf2Gt012YH5ijSIOZgZdMeGqvbUbEz0
         ASTf9SKhJ16tdwUiMovmCO4JY8xxSoxzymqDUCWUza8clfycCb7MeGCGuaaB223gMn3v
         4ROA==
X-Forwarded-Encrypted: i=1; AJvYcCV9p99t933QaHw/hObCSgyy8eIDg/pvuRzyEndTKoL7pi8y88MU2bXS9EDEEFTXiIvyNHsLnpUziA==@kvack.org
X-Gm-Message-State: AOJu0YwkR7AObs4/Exfs6d7WmZxlbAStNxrkigoKvs1PKAoF1EaywGde
	+ncjzB1smo2PlW585ixzJBF6PmTePtQSlXLTurFtQO00lk+eh/bC9MkqM4hL1U+Bqb10vPOkttX
	kVEC4
X-Gm-Gg: ATEYQzwSD9RxfzS4xcYFPfOr9n3Fm0scAfQ0EZ3aIKPRP1iLhMA2wbReqMQIGMNLv1I
	nVNt4xkp6Tq/TzfYdOfbwkGNl+r6BAGtPz7hhxSRP9/zMJIXc2aWIi0j72ZpZ0+pFqRTzEcBeNe
	uN6K3nbhsDRQ3m43idwSgFBq+tc6sKAfrQbhzZJ5TSFFLt876NR9x0rhgPYfqisYSWkhZLTae9o
	/sMvrqtKijpSGHy7y6aTooca0+effL/CURYQnWb+fhP+LcPr+Zxw3dO1cKrvhrjhKJVh1/ON6u+
	8rvVBJ3syvoJzNCFLfZnLcRATR9J/1v+fQ0uOlJpDBPfRHOzZci3UyAPqp5jaxZ0hyug6cbdnrA
	OMgZJ6J43FWAS8BCEw47+oh0f3ianu3HvWuLA906KqPttEvsCDP0/Jv6CbopaMDD4X1n5Lgj5YT
	3fMhJ6wnhbRphkYmGsHr8k8Q==
X-Received: by 2002:a05:6214:21a2:b0:899:f570:3167 with SMTP id 6a1803df08f44-89c6b5af178mr69240396d6.46.1773874139756;
        Wed, 18 Mar 2026 15:48:59 -0700 (PDT)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89c6b9ce6cfsm37644246d6.24.2026.03.18.15.48.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 15:48:58 -0700 (PDT)
Date: Wed, 18 Mar 2026 18:48:54 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry.ahmed@linux.dev>, Zi Yan <ziy@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 7/7] mm: switch deferred split shrinker to list_lru
Message-ID: <absr1vgNP_tM1OEP@cmpxchg.org>
References: <20260312205321.638053-1-hannes@cmpxchg.org>
 <20260312205321.638053-8-hannes@cmpxchg.org>
 <61d86249-cd89-4e99-99d8-ab7c72e95f34@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61d86249-cd89-4e99-99d8-ab7c72e95f34@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D583210000F
X-Stat-Signature: xk1fcu41fo3uf1brjibhnua369cz1qje
X-Rspam-User: 
X-HE-Tag: 1773874140-197473
X-HE-Meta: U2FsdGVkX1/VqDoHEspvCa7LffjCVDwXErmHWLOPSlIA19+5HarqQU2mHum2wZlMdwYh6gHQA2E8o9e/YMPxX+CtSLja1R1FTiROHb2s+Yh7hWMiEBgi15ao4TTKP9DGEk1+ERetHMro0ugyT6+fWBu+QuITofRhGTWjJzFz7aTDjOEFBfGyLy+xb2C6aQO0cn7NJqQS8Hw03QpTkUUIeHq2fHLlMcZ0gpggR7a2+8wg9yKHbtVAxKh/paXdmusu0eXTcjRucTdz0WBr3/QTBNn/1M/NccmG+xBV9mJ3j4I6492C+DLGGPdj8sS94+/sj0Kvfv8EmH8Qm5cl+e+qAOY9VDbGshDOmRDuonrHvq5VtZlDJU7sDPkWBNndZeK+pVvgwDyxgrzEO9d4gjK9pQeWBXE1ap1iwvJo4Si1igtRB49/PIxZWYbh/M0FC2yjPg4YDdJfKBXXpUvkwAsi94b6IfdXLUtDDdX2JiCv8QiWbrpo/S3SqcMwWsOERW938Vi/RCZmhMatGmdZ/gBQl3tIV86Wghmbq5KAp3ya7Ei6bl2zebdU771uZfq1o669jTpRegKZpY5BjZE/4ZU2ea6sAp4g+TLwBEgQWT++FTtcDzJSfdcvhYuVJSKW0bpmOPRc7QpR0GnZytg0Ypn1xYCqxo9GcLhSNZKrGvECrGDSjXUVRmMXyyfq9iEWt+y9myCSXC2nNOsOQ4mXt6GigjlMNUq6vKWAL6VfI2ov+MFbj6R2Hy4vKC4jwbTmzDXLfdVOjsV2iQwFFgpYwGz2LwfwHASYKTzCefuxnx7U5YZ+xOTl6N30fNwg26e1mrp7IX2DQ7BKI3oQ/Z2MKQdX3+vObynK22yrNYIJhC8LPykwruSm7YZBwOUZQjoHQDUFyaPB1DGl4ddklhCqO8GB3AKzU9kojZ2hAvgbCEJHE9dG+i60nLI5/fCPGmsiPV7S1yaSHn/WRpwAzkTB+O+
 vnvz+m9t
 +9GoQWaXWU1eraqMRmpYhR5rAb0dh3LPg8GTHHpH+UO3rJSehWxj2+EtzUthe9hJXoFQuzNPTDCULabDEtSZvlZHjYG2iJj+WXKwX8KDOQ0CjR0hBSTMQ6zos78ySrucSXR0oP+WlBdKNzlDuxI2lVi1W4Szb2Ag5erVeGLqAGbjv4HnTL4Vj+1JnHY6fSpZDFBlyM6h5W7yeu7VX9WFqUelhVJqyqgoCuP8/42PBCfduNp84X7kI4jbrtHQwJG8DpZ/kdw9Z5/T2FSSrlKZFjCbJ188MKKv4GMRatB0/8zhAmjANtJ5nJ7c2SfX50MstwzIRmzjWYGY1YyEZcHvPabrVDaOeOZa4WzZNmF/7Lk1i6TGdnpsXslnUXqWlGukN0cdOt3YuCfOwC6e0obY6KVAkajJvDGXzzG51POA9FSMazfmJ7VLCFVGVE63qOoCPENJQGfFp32UctAw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 09:25:17PM +0100, David Hildenbrand (Arm) wrote:
> On 3/12/26 21:51, Johannes Weiner wrote:
> > The deferred split queue handles cgroups in a suboptimal fashion. The
> > queue is per-NUMA node or per-cgroup, not the intersection. That means
> > on a cgrouped system, a node-restricted allocation entering reclaim
> > can end up splitting large pages on other nodes:
> > 
> > 	alloc/unmap
> > 	  deferred_split_folio()
> > 	    list_add_tail(memcg->split_queue)
> > 	    set_shrinker_bit(memcg, node, deferred_shrinker_id)
> > 
> > 	for_each_zone_zonelist_nodemask(restricted_nodes)
> > 	  mem_cgroup_iter()
> > 	    shrink_slab(node, memcg)
> > 	      shrink_slab_memcg(node, memcg)
> > 	        if test_shrinker_bit(memcg, node, deferred_shrinker_id)
> > 	          deferred_split_scan()
> > 	            walks memcg->split_queue
> > 
> > The shrinker bit adds an imperfect guard rail. As soon as the cgroup
> > has a single large page on the node of interest, all large pages owned
> > by that memcg, including those on other nodes, will be split.
> > 
> > list_lru properly sets up per-node, per-cgroup lists. As a bonus, it
> > streamlines a lot of the list operations and reclaim walks. It's used
> > widely by other major shrinkers already. Convert the deferred split
> > queue as well.
> > 
> > The list_lru per-memcg heads are instantiated on demand when the first
> > object of interest is allocated for a cgroup, by calling
> > memcg_list_lru_alloc_folio(). Add calls to where splittable pages are
> > created: anon faults, swapin faults, khugepaged collapse.
> > 
> > These calls create all possible node heads for the cgroup at once, so
> > the migration code (between nodes) doesn't need any special care.
> 
> 
> [...]
> 
> > -
> >  static inline bool is_transparent_hugepage(const struct folio *folio)
> >  {
> >  	if (!folio_test_large(folio))
> > @@ -1293,6 +1189,14 @@ static struct folio *vma_alloc_anon_folio_pmd(struct vm_area_struct *vma,
> >  		count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE);
> >  		return NULL;
> >  	}
> > +
> > +	if (memcg_list_lru_alloc_folio(folio, &deferred_split_lru, gfp)) {
> > +		folio_put(folio);
> > +		count_vm_event(THP_FAULT_FALLBACK);
> > +		count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK);
> > +		return NULL;
> > +	}
> 
> So, in all anon alloc paths, we essentialy have
> 
> 1) vma_alloc_folio / __folio_alloc (khugepaged being odd)
> 2) mem_cgroup_charge / mem_cgroup_swapin_charge_folio
> 3) memcg_list_lru_alloc_folio
> 
> I wonder if we could do better in most cases and have something like a
> 
> 	vma_alloc_anon_folio()
> 
> That wraps the vma_alloc_folio() + memcg_list_lru_alloc_folio(), but
> still leaves the charging to the caller?

Hm, but it's the charging that figures out the memcg and sets
folio_memcg() :(

> The would at least combine 1) and 3) in a single API. (except for the
> odd cases without a VMA).
> 
> I guess we would want to skip the memcg_list_lru_alloc_folio() for
> order-0 folios, correct?

Yeah, we don't use the queue for < order-1. In deferred_split_folio():

	/*
	 * Order 1 folios have no space for a deferred list, but we also
	 * won't waste much memory by not adding them to the deferred list.
	 */
	if (folio_order(folio) <= 1)
		return;

> > @@ -3802,33 +3706,28 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
> >  	struct folio *new_folio, *next;
> >  	int old_order = folio_order(folio);
> >  	int ret = 0;
> > -	struct deferred_split *ds_queue;
> > +	struct list_lru_one *l;
> >  
> >  	VM_WARN_ON_ONCE(!mapping && end);
> >  	/* Prevent deferred_split_scan() touching ->_refcount */
> > -	ds_queue = folio_split_queue_lock(folio);
> > +	rcu_read_lock();
> 
> The RCU lock is for the folio_memcg(), right?
> 
> I recall I raised in the past that some get/put-like logic (that wraps
> the rcu_read_lock() + folio_memcg()) might make this a lot easier to get.
> 
> 
> memcg = folio_memcg_lookup(folio)
> 
> ... do stuff
> 
> folio_memcg_putback(folio, memcg);
> 
> Or sth like that.
> 
> 
> Alternativey, you could have some helpers that do the
> list_lru_lock+unlock etc.
> 
> folio_memcg_list_lru_lock()
> ...
> folio_memcg_list_ru_unlock(l);
> 
> Just some thoughts as inspiration :)

I remember you raising this in the objcg + reparenting patches. There
are a few more instances of

	rcu_read_lock()
	foo = folio_memcg()
	...
	rcu_read_unlock()

in other parts of the code not touched by these patches here, so the
first pattern is a more universal encapsulation.

Let me look into this. Would you be okay with a follow-up that covers
the others as well?

