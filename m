Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03865F9D0CE
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 02:32:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 677016B0092; Tue, 14 Apr 2026 22:32:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 628116B0093; Tue, 14 Apr 2026 22:32:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 518C26B0095; Tue, 14 Apr 2026 22:32:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3C75F6B0092
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 22:32:53 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 02CC6B6E24
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 02:32:52 +0000 (UTC)
X-FDA: 84659217426.27.92BA343
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4743B180003
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 02:32:51 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ihO8yONh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776220371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ke7ZU96pP8AphVfQ1r7P8Nw6ADajpZRT0hzukpb8KsU=;
	b=n5gn6DgM4q4FYz0SSWokllvggFxLuiMzurG7TAcbAt4ZPq8uazsoybmcdDpmx4euM3VU24
	o9AICqJ5J0KLUOXXHFJNjRBJJqZ1i4wHqjfD6zW2fi47QsqT08csiABUatEiX1tw9oV7Wk
	X80tHWakrsBSYUME5vRe4PGR5uQO910=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776220371; a=rsa-sha256;
	cv=none;
	b=q2iP3zxP0dVOKBHSmnzfyVPtk+qMAQ0ITL2SDryxODZ7cX0CXmraGwzrdM21qVY4eI+AOQ
	IYAxm+4O7yRHaKsezeBszTkbDMNiMUV4NkBiVZW8CIM4XoW0vFIfr0cOqkypR7M3yf+ACJ
	BorgVCk3xRsfteWSQFcZh7zlAtaZk/A=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ihO8yONh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 17E4B4321F;
	Wed, 15 Apr 2026 02:32:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D4C3C19425;
	Wed, 15 Apr 2026 02:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776220370;
	bh=nJMDOKwUC4j12LbXLzHBYxV0fA5WtS3uw2VZtj0OTNI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ihO8yONhn73jqtT9LKoDI8ZQvx+l2ahTGx+fKK5FDeGDdx43suX9nWb1kgJ8GzZNg
	 u8OdnnwKye8rgsgGTLidab2SYSTZ0JyTtpayVtZLhqJZSuJVb1BscXnwA/XMEU17AZ
	 6gSKbcn16Qd+OXCnjbozDLpCyunvc2q62WycDcZB+dxiRCPVoXaHHxD1/1QB8Zr7hM
	 unRtpY/GXTc0v/nJKc/zI12bfcfdHIr14nQW4IJ1XRIfSM2O7oNU0sjWobavxiNuzZ
	 kRKKwRe7zayEqxVcUKN9cuv2/8h/Mb3ut3/8lyW9TMqBoy1+TDmwTYdFt0vTSmcfhq
	 /J6HZJ+NhBOKw==
Date: Wed, 15 Apr 2026 11:32:47 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@kernel.org>, Yosry Ahmed <yosry@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2] mm/percpu, memcontrol: Per-memcg-lruvec percpu
 accounting
Message-ID: <ad74z5aSkwxn9QQG@hyeyoo>
References: <20260404033844.1892595-1-joshua.hahnjy@gmail.com>
 <20260414202631.2753640-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260414202631.2753640-1-joshua.hahnjy@gmail.com>
X-Rspamd-Queue-Id: 4743B180003
X-Stat-Signature: a3juznjfa188qjoiwsnjgw4dma64y8hy
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1776220371-481930
X-HE-Meta: U2FsdGVkX193+rElaNvn2Zpen6Avlj59Ql6eceT4/iyDIJAYSMBpFsV7mvlcC13ydv1hRMKD9o96cVA+c1F+QsmYjoFdzJ5g1jDCzqJHJeYg5QngxzQGDMVP/Iuq7YmOixDx24iJdn6esLIDoVh04kcw40dE1CYrlnP9pDs7T/CVdcWxWHZm0FE1tWxj39lt6wbHqLqgLHUWQQSn13XdPf0yO0eeXLWV6s/x7kHvNxpoTiFf9YwA9tQUMumsX8PnEE2OwRnTg8vwB8XNDXn8x5shlgjYVsXhc/NXYjjl/yNjiX1HvLRoTQwubpNxWtHvuWcXbTj6J3ZTbgKnFCYh+f2vQFjqWmaGQZDQRl3INptoloY/7DWtm4bNFb7QD0UY7hD/yqiGrQZgXQvXntWB1zA0awDtlC2EDTkm1j0EEeSXK+v+cNFTn94HX0rXWoOwueVhReCwG9ZfJiC0gclZG/2qJAUuM+GJGxD4T8lnxdVmhkus0OYjo/tJNmJpItf0Jhndz8dCNrFNvN9yQf12NuVsb/UeMutrJk6eSbov8KK7xoaYGlzIT6002bdhW2GK36Q6UzKh188t7yj1LEDrG1XoXrKeBdhLS2vY4x00gYMsQtIPoU5+A53Ar2p7jMyWqR+Upl4f8rnaKIpEogFXZ3hixP2UvSg9bhmOC9hH1yppAqPkvA431Rux5tUAUOlsqWZaknLh3ya4pJt4nn3/5NOXdIWMq7NJXtlsQfYFn8m/WDimKpblGSgWj4AK40XoqlHlDdz4z0SfODdtCsnD27pHqyCYT1Y9N7GFfAAgohcNIRIiNqMoy5sFNzivABHLdF6AZk68tODr0XO0nDou4U/RFRdtApwcGJA2b2U+47lm7NdIDVmcAkduHACArVzuh1nlStuh3h+ebQCQ8lBB99qPH73jsPdE18WxNa0LGyvCNWN6PL69lA97Gc7resIPxuhO0IXrksDKX1FnbwF
 fgoFplSr
 i9HNSqS4jcsJZQzEXf8McnyJfPBRA6cgYN8s55n/4CLonurnKtNaO0W5+2fHWjRz2oC5u8S6dy9O6EIyDj1V2Af2E1ec8guS/RUY1Kp4OjaNm95Im52OiDunKg9DJ+RBuuGPmJwHDFKLc5n9xBqbrv/xQ29piXm3KlGyMdRLGK7E6/SuYWZyV+mQ9S5wHPQ6UUygolCd6uvsMjaJP3sVZ4yoFULNIrS2e6iTvUum13zZ9ZywwRZP6RjclRHcsjiUhIrhmf3aHBQdUDd1GGLrDp2rDeroBPq6XmUrinpnDHJX3ra2mD6RboaDsixYRzyGO3qgs3SA+2JIjJJgLNz4y5A7ihmimE3Ax5Ke4xVqc1+rG60xU+wvWI3R0R04XMywbq+r+9ue3VMGu7xj9Wg7FpwZFiw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 14, 2026 at 01:26:31PM -0700, Joshua Hahn wrote:
> On Fri,  3 Apr 2026 20:38:43 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:
> 
> > enum memcg_stat_item includes memory that is tracked on a per-memcg
> > level, but not at a per-node (and per-lruvec) level. Diagnosing
> > memory pressure for memcgs in multi-NUMA systems can be difficult,
> > since not all of the memory accounted in memcg can be traced back
> > to a node. In scenarios where numa nodes in an memcg are asymmetrically
> > stressed, this difference can be invisible to the user.
> > 
> > Convert MEMCG_PERCPU_B from a memcg_stat_item to a memcg_node_stat_item
> > to give visibility into per-node breakdowns for percpu allocations.
> > 
> > This will get us closer to being able to know the memcg and physical
> > association of all memory on the system. Specifically for percpu, this
> > granularity will help demonstrate footprint differences on systems with
> > asymmetric NUMA nodes.
> > 
> > Because percpu memory is accounted at a sub-PAGE_SIZE level, we must
> > account node level statistics (accounted in PAGE_SIZE units) and
> > memcg-lruvec statistics separately. Account node statistics when the pcpu
> > pages are allocated, and account memcg-lruvec statistics when pcpu
> > objects are handed out.
> 
> [...snip...]
> 
> > @@ -55,7 +55,8 @@ static void pcpu_free_pages(struct pcpu_chunk *chunk,
> >  			    struct page **pages, int page_start, int page_end)
> >  {
> >  	unsigned int cpu;
> > -	int i;
> > +	int nr_pages = page_end - page_start;
> > +	int i, nid;
> >  
> >  	for_each_possible_cpu(cpu) {
> >  		for (i = page_start; i < page_end; i++) {
> > @@ -65,6 +66,10 @@ static void pcpu_free_pages(struct pcpu_chunk *chunk,
> >  				__free_page(page);
> >  		}
> >  	}
> > +
> > +	for_each_node(nid)
> > +		mod_node_page_state(NODE_DATA(nid), NR_PERCPU_B,
> > +				-1L * nr_pages * nr_cpus_node(nid) * PAGE_SIZE);
> >  }
> >  
> >  /**
> > @@ -84,7 +89,8 @@ static int pcpu_alloc_pages(struct pcpu_chunk *chunk,
> >  			    gfp_t gfp)
> >  {
> >  	unsigned int cpu, tcpu;
> > -	int i;
> > +	int nr_pages = page_end - page_start;
> > +	int i, nid;
> >  
> >  	gfp |= __GFP_HIGHMEM;
> >  
> > @@ -97,6 +103,10 @@ static int pcpu_alloc_pages(struct pcpu_chunk *chunk,
> >  				goto err;
> >  		}
> >  	}
> > +
> > +	for_each_node(nid)
> > +		mod_node_page_state(NODE_DATA(nid), NR_PERCPU_B,
> > +				    nr_pages * nr_cpus_node(nid) * PAGE_SIZE);
> >  	return 0;
> 
> Hello reviewers,
> 
> Since I submitted this, I have been thinking about the feedback that Sashiko
> has given this patch [1]. Harry has already pointed out the points about
> drifting due to CPU hotplug, but one there is one particular concern that
> I have been trying to tackle with no avail.
> 
> The issue is, pcpu allocations for CPUs on node A may actually fall back to
> node B, if node A is out of space and under pressure. This design seems to be
> intentional, to prevent memory pressure from failing these allocations.
> 
> However, this means that we cannot charge percpu memory based on the number
> of CPUs present on a node, because although the memory "belongs" to the node
> (since the CPU it actually belongs to is on the node), the memory can be
> serviced from elsewhere.

Ouch.

> To handle this, I've tried several approaches. All of them were either too
> expensive (iterating through all pages at allocation / free time)

How expensive was it compared to the baseline?

> or introduces
> new drift (I thought of managing per-chunk statistics as well).

How does it introduce a new drift?

> To be honest, I think I'm out of ideas at this point :/ So I wanted to see
> what others thought about how to track physical locations for pcpu allocations
> that were allocated via fallback. Are these rare enough that we are OK with
> the misattributing here? Should we eat the cost of iterating through all pages
> to find out where it is physically?
> 
> Or is this patch not worth pursuing at the moment? ; -)
> 
> I hope this all makes sense. Thank you all in advance!
> Joshua
> 
> [1] https://sashiko.dev/#/patchset/20260404033844.1892595-1-joshua.hahnjy%40gmail.com

-- 
Cheers,
Harry / Hyeonggon

