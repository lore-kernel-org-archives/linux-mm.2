Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76D91C3DA7A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 16:59:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 720C66B0088; Wed, 14 Oct 2026 12:59:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D1BC6B008A; Wed, 14 Oct 2026 12:59:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C0286B008C; Wed, 14 Oct 2026 12:59:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 26AA06B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 12:59:37 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6EE80A7928
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 16:59:35 +0000 (UTC)
X-FDA: 85321843110.01.13B61FE
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4E195140005
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 16:59:33 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=KAbUwgAx;
	spf=pass (imf23.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791997173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=prPunQqbna8thQ76F5VpQmbPqh027UVozqQG4+ve53M=;
	b=khlM0A1HN6h+Rpjoi+oUFspfQIcphYYvTlSZjkrNULGtUvKZTf4gmIOioAtwRKN/7VukXE
	tYlkT/QOuNTU08xz9urhPweRdafnYj8lcy1Qb/V5nDHFwBs+amEr8ppWT6KZU1vVw+vSqV
	wE3yLn0f2uOGxTFTW0nFNUD6Ue7+nUU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=KAbUwgAx;
	spf=pass (imf23.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791997173;
	b=vgQ4LtcPwlfcuT+g9w7NuVa30TiAKIIabFlNftEn3K/R0Wgy84HQPRSpyJjeI3BsaaXkKs
	8hwwaHNK0OpypT9kNqVssJpWEGzEdBreqPlzIX2rjcggv+v7Mnuuh0Wt5Er28SaKlJZWto
	W3LmmQoDSCCIWdpGUE/fmuReDniLDgA=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-49d05d51553so8133295e9.2
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:59:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1791997172; x=1792601972; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=prPunQqbna8thQ76F5VpQmbPqh027UVozqQG4+ve53M=;
        b=KAbUwgAx89VexzNrltkROnSNtrJFor3u8jKIC4tYCqSSDIiUmUTP8vyP6p0oO4kpgX
         malH5mYPSeBJOPNPCEvC80qEp5IBNG6TAL4zt0nSs0K+7dZUHDmISkFgzbxuPSYmN9Us
         UhXM9cw4YH9ZKk03bIcjMrEvI6Ix54s7lp16fQv6eZGrR/9VKqIc8AerlfAndIbZQpcx
         dBDFbZfxKAYhZwhUks+AV0QByEEx4lBbUJbYpO0zlunVa3pa434pnmoscxHS+RNIGGqf
         /8rZiml0WPFFHFl2SMmvk1Z8Y5Ol9UcuEIP6nsIaATJ/piwoXsUuj27zo8y3G7rCehko
         UViQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791997172; x=1792601972;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=prPunQqbna8thQ76F5VpQmbPqh027UVozqQG4+ve53M=;
        b=HE5wqYep549gYUeyEodZL40luxDIspI5SZxY88/nkI5/TFp0vqezDPc1JolksugNjp
         5xBc+d650rUfzNLw5Bce6cwUIOrccYpsfAsz2Fwqwi3OEX/5Oz6GpOYYhGqRVr+y2mLT
         O3PxsKckl6c53D1y5sM0IDmT00kCaUWKf2hqv6e6nlrxWPK71HpigN/qqUoFSEW1BdkB
         txcVHPWuyTBQRtn1FIH6GRD71vDSScWAlo2T6to7hSR3hpnwDy1vZ1RW+wMKxNsF6TZq
         ACvfkzxagbfd3CdMbW6YoWu2X0ixBc1VMM6es/rCo5X1zWm5ru5A7+eKFs/BjyQeKSYS
         CCMg==
X-Forwarded-Encrypted: i=1; AKwUvBz4ox8b2v1JUKyuztC9EuzB6EQyjJu6JtZV6fNv0+hNjhr9QrYR72sRRSwRm2IOjfuqfOQkObBj1g==@kvack.org
X-Gm-Message-State: AFq9FYLNow3T+IptWJrkR7frkbQrJ7fz9D91qqVcdKUVvNE6oyJSW4lh
	ixRvH5HE6AK9EO6Zi0nO6KdD0pNTGMPwUiEKTL0NwfGDjCyKK/R2nZ3alibs62j0cIg=
X-Gm-Gg: AYBFou2biDoLHyuq56r7Sjo860fvwyMA9QI+O6seEdOdlQ0yQKxXizcGY1CadROHtZm
	1ED9QxRITZacLOdq50uUHbXATpGzHB5BchwTsYRML3pXQjB3Xp77p8wr0U90Vet/+5716E07yyk
	dY451O++Aebp1X2ls6X6RYzjOUmmpR7vQvLY62CpQgo9rXbV2jjQducmtRB6pMCrOUHiZjkbBnI
	KKoKJYcdtAS3FiCguTZwsTRnGT08Zwj6aq/y5TzFgVlTzkt0yZ8VqFtXtQ9dwz8TrGwCgKCkOHg
	6rH6uzYpxwHkVI1nZAp+nD79req59glS84Fu9eR4Bqjl0UUIY8zmML1IWPXVdQMz6nWBuhbylgh
	gZl5bfjxV9dE/+pweUU1noMY35WyLgOrNiB1m4qtvLca18onrjoqRY5+wvMUbwPaOrLRZMLgBi9
	WwjiYcLITF0++YKNNlOBLUf2kGv4cyFdcwmc9CG9KBfH1/7ah/vy/CM1GlpcIUw3fMMRlhJzyc2
	E5qCFUO9b28
X-Received: by 2002:a05:600c:821a:b0:4a1:74a1:7ecc with SMTP id 5b1f17b1804b1-4a18e446ef5mr292644385e9.1.1791997171723;
        Wed, 14 Oct 2026 09:59:31 -0700 (PDT)
Received: from localhost (109-81-25-183.rct.o2.cz. [109.81.25.183])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48de0aaa9f9sm13247466f8f.19.2026.10.14.09.59.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 09:59:31 -0700 (PDT)
Date: Wed, 14 Oct 2026 18:59:30 +0200
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>,
	Meta kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH for-7.5 4/5] memcg: avoid queuing high_work from reclaim
Message-ID: <as-08j9_1C2F_N8s@tiehlicka>
References: <20261010210957.1350874-1-shakeel.butt@linux.dev>
 <20261010210957.1350874-5-shakeel.butt@linux.dev>
 <as9p2uFqCQprwdnI@tiehlicka>
 <as97Nzob4XuzO9Ss@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <as97Nzob4XuzO9Ss@linux.dev>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4E195140005
X-Rspam-User: 
X-Stat-Signature: mphgh6mqidp1n5qqou1u1de6p1ytbsqt
X-HE-Tag: 1791997173-3674
X-HE-Meta: U2FsdGVkX19A3cQrE0RKHIZ8u5iZO0PXXLE2hQpMw5Xdce5Qy4fgwKFpoS4vbyYNsxuZ/Psx1MoTqu7PbRevsMsM3v8H7o4OiUf9PH0StBkiHpUOVRcOjzkXlatrz9eutmnxYuDjm9IgLgpD+188X8HhpB6ZPahk8uH3WJ4p5A7JIKjoP4o+R9lL8tO5jAN1n8xcwHMki/Pal1r8fbdXfVFV5HPRetLqT0OfS5yb8ChVlmW6MN4wkEDi61yXsK/guW5/uhpQtDYrGOmMhzuETNFvC93wJJEwnj2f3H8lgs2vYFYiFwNM5FulhCmGPZEtdODArKrr7my/LTvl8DMYJLy8m3tpzLTYEwlPRnONUv1W+UoOg8m7qJIRfruS2wW42kgv4Y50prhO83UM7gRh34EI82JO3unYHYE3SWIN4YIY3NPCC6EZWy3w2wZlXdp3q+W4ZryUySxUxRU1nAoBSsvEFfN6ZIh4lI11tKMDga1qFg3voprYmvexICPAXTUXqEd55eE+3OBI0qz9fMXm8LlvqSz1HC7NwUlzoqjHVO0noiZk8he7xGO/Rno5q1L0UCxzCHEJEv4vSC0w1sVAaN+asReMB0vrGFl8VJQqmS1eIp+V1gJbftc1BaRAu6gwhXD/+J3w4dTzKe5EBAMXj1rpEy9aGL73fpTk4xNeGEBqEZJYsdxL4YT4IVkgMspVSpXeWELJv2I299CxCqRgmSxlr329JRcPYAIAXD5Mmo4/uGBTei4qYxYVGqwYKY2FgkTywjY2zg3hb/s9L6vR8ue28yaqIqkqv2ZWiyOHykweg/8SWLdwZizMH4jq73aTSdcl+yaTbpN29QQ7B1JeqzXTldA48itqOzgXcJ6QzfHfVCqnZ5WH7XEQZHisszUf0Efm+vfutEgZNbiZzdACEaj5BZ4AD5zxq5gW0O1Gn5l4jsorsN9W05Va8W1McS6Icm0qA/EsGU/Lvwyf0dC
 zbqrO2wI
 78L3R1oWjPQcUPS7uasIfgGwASHjnJhCQ9SdKy7oVtXfATtLDC/KEU6ux2Js87ldyk1lyEIzQ7d5oQv//njZ+i9UdPVQZqmOMvKya6Bl23R+YRSFwPfmuZeLyskXxPlJw+a3R4W9kzxXGf38hMz0cy6IN+li6iZYliNbxgi27ltP8OjoewWVavGD5asMjNug1O30tSjXtwB/K9V0noxlMIqKhjrykurzW1RjlMuE1CSyllRlQ1H7iGA39I0VNkDee7pCrcr+vhsZUMme03LJm2Bmmyw1CVXF1y2SefAfHtIYvF2RvzmlAQAqX2DMRPt9nD//w7nZH4MUvyoZMuMnap6Y3f5Qko6BqdyKtsZHgq1bmIwUTu0p40v+1rooz/BEbkhwALiVHal5Tlh4TcD/22W2L8Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 14-10-26 09:06:00, Shakeel Butt wrote:
> On Wed, Oct 14, 2026 at 01:39:06PM +0200, Michal Hocko wrote:
> > On Sat 10-10-26 14:09:56, Shakeel Butt wrote:
> > > Kernel threads and remote chargers use high_work when memory.high is
> > > exceeded. Their allocations during reclaim can also charge memory,
> > > for example when zswap stores a page.
> > > 
> > > Without a check, the high_work worker can queue itself from its own
> > > reclaim. The pending bit is cleared before high_work runs, so each run
> > > can queue another run.
> > 
> > What does that mean really? Does this delays the actual run?
> 
> It will not delay the actual charge request. This mainly means that we keep
> enqueing the high reclaim work even from high reclaim context and can
> potentially keep wasting CPU if high reclaim is not very successful.

Hmm, so is there any practical problem if we do that? What exactly do you
mean by "keep wasting CPU"?
 
> > > Skip memory.high enforcement for charges from task context with
> > > PF_MEMALLOC set when they would use high_work. This covers kernel
> > > threads and remote charges. The memory is still charged. Interrupt
> > > charges keep their current path.
> > > 
> > > In a VM with incompressible zswap data, the worker queued itself 163 times
> > > without this check.
> > > 
> > > Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> > 
> > The patch itself looks OK. I am wondering whether we can unify the check
> > with the existing one which forces the allocation through in main
> > charging path.
> 
> The force charge (and ENOMEM) paths bypass the memory.high enforcement
> altogether.

Exactly. Isn't that exactl what we want to achieve here as well?

> Only successful charges (done_restock label) goes through
> memory.high enforcement. So, even if we move this check in try_charge_memcg, it
> will still be a separate check before calling high enforcement function. I think
> this check is very high_work specific and better to be in the high enforcement
> function.

I meant something like the following

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 856a7d07586c..832b40ee5b6f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2653,7 +2653,6 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	bool passed_oom = false;
 	unsigned int reclaim_options;
 	bool drained = false;
-	bool raised_max_event = false;
 	unsigned long pflags;
 	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
 
@@ -2661,6 +2660,15 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (consume_stock(memcg, nr_pages))
 		return 0;
 
+	/*
+	 * Prevent unbounded recursion when reclaim operations need to
+	 * allocate memory. This might exceed the limits temporarily,
+	 * but we prefer facilitating memory reclaim and getting back
+	 * under the limit over triggering OOM kills in these cases.
+	 */
+	if (unlikely(current->flags & PF_MEMALLOC))
+		goto force;
+
 	if (!allow_spinning)
 		/* Avoid the refill and flush of the older stock */
 		batch = nr_pages;
@@ -2683,15 +2691,6 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 		goto retry;
 	}
 
-	/*
-	 * Prevent unbounded recursion when reclaim operations need to
-	 * allocate memory. This might exceed the limits temporarily,
-	 * but we prefer facilitating memory reclaim and getting back
-	 * under the limit over triggering OOM kills in these cases.
-	 */
-	if (unlikely(current->flags & PF_MEMALLOC))
-		goto force;
-
 	if (unlikely(task_in_memcg_oom(current)))
 		goto nomem;
 
@@ -2712,7 +2711,6 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 		goto nomem;
 
 	__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
-	raised_max_event = true;
 
 	psi_memstall_enter(&pflags);
 	nr_reclaimed = try_to_free_mem_cgroup_pages(mem_over_limit, nr_pages,
@@ -2773,13 +2771,6 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (!(gfp_mask & (__GFP_NOFAIL | __GFP_HIGH)))
 		return -ENOMEM;
 force:
-	/*
-	 * If the allocation has to be enforced, don't forget to raise
-	 * a MEMCG_MAX event.
-	 */
-	if (!raised_max_event)
-		__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
-
 	/*
 	 * The allocation either can't fail or will lead to more memory
 	 * being freed very soon.  Allow memory usage go over the limit
@@ -2789,6 +2780,8 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (do_memsw_account())
 		page_counter_charge(&memcg->memsw, nr_pages);
 
+	if (mem_cgroup_margin(memcg))
+		__memcg_memory_event(memcg, MEMCG_MAX, allow_spinning);
 	return 0;
 
 done_restock:

-- 
Michal Hocko
SUSE Labs

