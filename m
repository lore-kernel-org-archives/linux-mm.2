Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBC66CD8CA8
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 16:39:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 327138E000D; Thu, 13 Nov 2025 11:39:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FF0B8E0002; Thu, 13 Nov 2025 11:39:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23BFD8E000D; Thu, 13 Nov 2025 11:39:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 11D9C8E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 11:39:51 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D1781C0AB3
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 16:39:50 +0000 (UTC)
X-FDA: 84106145340.07.F5EBC8C
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf04.hostedemail.com (Postfix) with ESMTP id 29EB640012
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 16:39:47 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=FDOUAK+Z;
	spf=none (imf04.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763051989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KWiuhOrKURFpDF1jEF6HDs7VsJ1uOu4RR59xEAk1d1I=;
	b=hc3c7HvLiO4QCQfn5WyYTjfFc9nQQo3M0Fo67rtk3dd5tA0f7WuZjAgcaA/AAkLnLX1jg3
	XzB2lgMprMt8aEuRU81dtYI+bmWT9IAdey+ZG0upg/2nqwyf7VZSN6KKVoM7URF6FUx1g8
	Ht8IUncYtH8rUtlKra82+E/TU4Uafsg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=FDOUAK+Z;
	spf=none (imf04.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763051989; a=rsa-sha256;
	cv=none;
	b=Nf37JItTh3mM7uMHftTLvGD+RnCOsMY2VsDX4cfZBdQPBRWeAPm8Tay1L/XjKtGtEQt4pE
	Yr5l4PJBzxogAJWC3ZbH34uagwl5MxyjSHuyYCmup4+d57I9OHv4UEFXwz98eQsKcqxXei
	ulI47u97x7zrcjuAszHFAF8tj3/suTY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=KWiuhOrKURFpDF1jEF6HDs7VsJ1uOu4RR59xEAk1d1I=; b=FDOUAK+Z6YcXPnG3ObMXyYfXyu
	pqX9OEVNzDjCVhE7Q6ZtgKXR8HhZY5Wn5qUpkAAeElMhXJZtktRJaQy7bjPuIQ8yot2uMVu3VheQ9
	7KC6hUJ4UtLhDw/jUPAGtDN0657kI0ZMcCLJArV30LN0fyZAUNqDeR9Q3KVetqPqOy1BrdAVvPTJw
	DsMw8gAT5540Qhv7dm7yVJ6SJkti2PK/6Mofbg4FvwTm/n8JX03y/lxiFTa1UsHTlL2aI/XmJxkTX
	fL9a6wmIUwvChVwqoY4b25w8Oa4LPBo4705Eeq3/vLv+orFaQ0yFS08Qz6X0db5M1/F88omJBehbY
	IviTwLNg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJaMH-00000007oHL-0pG0;
	Thu, 13 Nov 2025 16:39:41 +0000
Date: Thu, 13 Nov 2025 16:39:41 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org
Subject: Re: [PATCH v4 14/16] memcg: Convert mem_cgroup_from_obj_folio() to
 mem_cgroup_from_obj_slab()
Message-ID: <aRYJzbZpd-UP3jh9@casper.infradead.org>
References: <20251113000932.1589073-1-willy@infradead.org>
 <20251113000932.1589073-15-willy@infradead.org>
 <20251113161424.GB3465062@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251113161424.GB3465062@cmpxchg.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 29EB640012
X-Stat-Signature: 8u7pdgjeudrqh7n7j1cs6snk76ij7ih5
X-Rspam-User: 
X-HE-Tag: 1763051987-876581
X-HE-Meta: U2FsdGVkX1+VAffyViKR/e6ffS+6vuDGdlybCjjleywCinEaigDcR7G78/4/Kg5xyiB33UqH/A3r/5Xg15SVF6LAG3Eos+7cfEfrgBCkE96XOuv7t4Rz/HCZ1IPL35vUzQcnFn2xDP5OOvAsLz9qSExfOBNwWt0dAxtIV8pa0DHt2+XP3JuNX0Dqlz+3nB62JHl+y/TsFdXyQf4SUSxue7O/3p5j/lah0HRvT1QJyWS4409rlCHWccLCueR0/WKHVFtjnnShKsyj2dAO2lsoEJ8QnY8I95VozftvXu6uL3CDw5/PIYXFUz64T83Tdh90sWs+5MxWLMF4isdPTjig9gHzoZTYMAMp42d5uUdf71WaIoHkN6RAoDBH25L04NVx06N5IofJgskRfkpQEU7u2JcX9HU+QUuZcwPK+DWY2tDnIwut8R9WO03m+Px4teRTQ49kyoqlj2CWEJwZ0ykOQDTNPoS8rH+WJ9RLBDGDVppBTVJ/tVeHZuUvd3BJnr2r3YBBB3tvtHIaXddGbNgy4PxNXSgL4ilJuy82qmF3GjP1X9G25VtLDeG9d04p7XyQcr9LWvlvgcWKXpOz7a6L1IRtLYqKcfUk+MOa6bJSXH482f+S/IZUyYBNHebT54OUfR8hA+qRWC9coTEYCeexwqIHM+Myt61Q3RDh9hQElG9U3ImSowrrj0NRULiO5acO6gm2nNSkjM4rsgNi8ULNFoQBBG2KJKOU2NQ1JfXg0Q+7ONKH7sGUrg4rx1Hk/hb0N8JZagrxuI9lexk4RQ3lRwkYIT+fXJ6W4P85lwM4BVDnZVEFKFJnrBKacBHA8mSu0NYbboos5WNrXBtPMwGIK1+qfUd/c5XdE6eW1i5PQ7kO3FsNweu5Rtj1ch0RmMZdumYG26FZLV/ddlPAjLdrlz1rosBLuGyaoUuVJ6DYDahdGKbFflxoSYREhZ3cOkXNABDFTZKhpQubCXOk0jS
 qo8Kl/Ns
 ldbqrLM11Nyx0nh79DoJnCfyXOjUP3kiCjPuT9UfFWGFi7d4U4HHBJ5tr85dpaoKcYN0DklDxVww9GW2nyDUgpe0yF1DAwYJcgS/3A9AviFhRUeqrPCGi4JiJ6VYNZbhSlDvBLZ5C8TRC9UZZnY9+0TGOnRRYJBRjrhaeUCDmG8w8csySm81wNMVVJr1EUriyM22YMb6N4GQcr0/yKPHXZ8vDOkajCxCoypWrNqAhpkx5YTXNX2ziH3T0t/yaY4dDnkJ9DjtnA1yL+tEVmXgMWN0KsnvxQiMbv0MFCByRo1ikPLrgqgc6VQmHnhBnLly5Akrq+fpriAJN8Z9kN8MIGvIzqFpl2zBz3leK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 13, 2025 at 11:14:24AM -0500, Johannes Weiner wrote:
> On Thu, Nov 13, 2025 at 12:09:28AM +0000, Matthew Wilcox (Oracle) wrote:
> > -	/*
> > -	 * folio_memcg_check() is used here, because in theory we can encounter
> > -	 * a folio where the slab flag has been cleared already, but
> > -	 * slab->obj_exts has not been freed yet
> > -	 * folio_memcg_check() will guarantee that a proper memory
> > -	 * cgroup pointer or NULL will be returned.
> > -	 */
> > -	return folio_memcg_check(folio);
> > +	off = obj_to_index(slab->slab_cache, slab, p);
> > +	if (obj_exts[off].objcg)
> > +		return obj_cgroup_memcg(obj_exts[off].objcg);
> > +
> > +	return NULL;
> >  }
> >  
> >  /*
> > @@ -2637,7 +2627,7 @@ struct mem_cgroup *mem_cgroup_from_slab_obj(void *p)
> >  	if (mem_cgroup_disabled())
> >  		return NULL;
> >  
> > -	return mem_cgroup_from_obj_folio(virt_to_folio(p), p);
> > +	return mem_cgroup_from_obj_slab(virt_to_slab(p), p);
> 
> The name undoubtedly sucks, but there is a comment above this function
> that this can be used on non-slab kernel pages as well.

Oh, I see.  Usercopy calls this kind of thing 'heap object', so
perhaps eventually rename this function to mem_cgroup_from_heap_obj()?

> E.g. !vmap kernel stack pages -> mod_lruvec_kmem_state -> mem_cgroup_from_obj_slab

That actually seems to be the only user ... and I wasn't testing on a
!VMAP_STACK build, so I wouldn't've caught it.

> How about:
> 
> 	if ((slab = virt_to_slap(p)))
> 		return mem_cgroup_from_obj_slab(slab, p);
> 	return folio_memcg_check(virt_to_folio(p), p);

Mild updates, here's my counteroffer:

commit 6ca8243530e4
Author: Matthew Wilcox (Oracle) <willy@infradead.org>
Date:   Thu Nov 13 11:30:59 2025 -0500

    fix-memcg-slab

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 597673e272a9..a2e6f409c5e8 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2599,9 +2599,6 @@ struct mem_cgroup *mem_cgroup_from_obj_slab(struct slab *slab, void *p)
 	struct slabobj_ext *obj_exts;
 	unsigned int off;
 
-	if (!slab)
-		return NULL;
-
 	obj_exts = slab_obj_exts(slab);
 	if (!obj_exts)
 		return NULL;
@@ -2624,10 +2621,15 @@ struct mem_cgroup *mem_cgroup_from_obj_slab(struct slab *slab, void *p)
  */
 struct mem_cgroup *mem_cgroup_from_slab_obj(void *p)
 {
+	struct slab *slab;
+
 	if (mem_cgroup_disabled())
 		return NULL;
 
-	return mem_cgroup_from_obj_slab(virt_to_slab(p), p);
+	slab = virt_to_slab(p);
+	if (slab)
+		return mem_cgroup_from_obj_slab(slab, p);
+	return folio_memcg_check(virt_to_folio(p));
 }
 
 static struct obj_cgroup *__get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)

