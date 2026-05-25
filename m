Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D7EBCD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 18:53:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C3856B0005; Mon, 25 May 2026 14:53:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74CE96B0088; Mon, 25 May 2026 14:53:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63BA86B008A; Mon, 25 May 2026 14:53:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4FC716B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 14:53:24 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D56A71201B1
	for <linux-mm@kvack.org>; Mon, 25 May 2026 18:53:23 +0000 (UTC)
X-FDA: 84806840286.29.BE4AA0F
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf06.hostedemail.com (Postfix) with ESMTP id F33AD18000B
	for <linux-mm@kvack.org>; Mon, 25 May 2026 18:53:21 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=O1yTKEXi;
	spf=pass (imf06.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779735202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k2QFQ7BTMixxlbnZQLMk0q07QCSPnGwVgu1LfJW46xE=;
	b=0ig+JS8oiuBOhuBYIoLd9LozhxTVjArzisTEI70wE0rtYLFMqaZFXI2OjKYN8WCz6A5B+H
	z8k3XFlrBU6we4x3gaFFaGuawD47WY9/m/Eth447Ee4tRDK8pr9FBu//l07TUZ6pu0My5p
	1f1GV4mt34xRGhEtwrbTtZvxIv1k6j0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=O1yTKEXi;
	spf=pass (imf06.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779735202; a=rsa-sha256;
	cv=none;
	b=tCHERKGGp4r4OiUAhVgwb4+Mw6FFoJ26FOn/yuRR2VE2073advQFzresRMbTB9y7K6Q9MC
	Rh7a0gRJa4YviNb4GPjmqRVYfZYDawL1ekblzK71ym3yvPN+iJ5Kutl/ASIAJq6qW7WhNs
	g2l70ie3uV09zraTScTiEpzceQ18/5E=
Date: Mon, 25 May 2026 11:53:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779735199;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=k2QFQ7BTMixxlbnZQLMk0q07QCSPnGwVgu1LfJW46xE=;
	b=O1yTKEXiYPTNyv6AaTj2UJ3dxovLWFeTSxcS5+2a/sMNAEgp9JKVVdJkgXS52r6X/eiZW/
	4CRrMhT2imibry/fsmn289JH4y4N4lhomVSK7Jbjik/NQYIVNEi3GLri1bGLGhIhkB9T/O
	1US80fxDrb1H/26uabBheDAQazKm1pk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Alexandre Ghiti <alex@ghiti.fr>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Harry Yoo <harry@kernel.org>, 
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kernel test robot <oliver.sang@intel.com>
Subject: Re: [PATCH v2 0/4] memcg: shrink obj_stock_pcp and cache multiple
 objcgs
Message-ID: <ahSaKlJ04BYsayQZ@linux.dev>
References: <20260522011908.1669332-1-shakeel.butt@linux.dev>
 <20260522193440.40e20563422afcc69b8445dd@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260522193440.40e20563422afcc69b8445dd@linux-foundation.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: F33AD18000B
X-Stat-Signature: fmbbjog5gcwonyiic7rkr913sk87fndm
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779735201-280898
X-HE-Meta: U2FsdGVkX18aJ0S6CzdWY/LFg0sWWOFEb7aASTydWvuARUFq+vaTEu1FDbyl2usPx43zTBtgyay5Pg6JQNaAjAM8yhZwra4ZzkxQ/1bpxYxO8TwSPA3CdBa7D/59RO/QT1vb7t5NHcS/z42APMnrCGO4JNanwk6z2mXRIr4fxy4Ht9nxM6+9rVSyPD3MYE5ma/RBhbbjdvQgmk5ecEp6gmdXm6TdHafFjuAVaPGoTBBCyKW32RPe6Rnj0g25ane2kLv6xMRHhOrRWhzN6z8a50RonMYhPZUR18xDmWewO5xx0yp3tG8RYzY7+4aeJ+cYCnUYUbjwBH1GUxMkMV+CGoBo0rc9wZjziR5w2ezou8HNPTmmlIaZxtxLCBF6LPhFcUa2ScUyRQVlYBGVoxuzsOHP/Jt1TvgDKMyr6eqCUVvTuCCUsU6VaBxSxIKw6YKfJc9OXy9/dS0l7RRaMQ2+s4sO5II+QM3blCfs2+KvEpS9WoPltTSR8sewpg5S52wOt4Cz72oWnEb6sz0ScLNztTgSzGIw+Aunr/9ohdmFYYMsMfozNVOqnKc7JMx4r6eZhYTzw7J0M7PbQs94oTX9WH/M7TCMThq9IphONnM3OoQsFFjh3Yfvm7zy3ezwWndzEctT5/3skQBx0vsiW2I8RbR7L6KuigWz+G9e5QMnbVwMUggjgnmMvlMZu+cWuQBZZblsshl84wKRNfkTyJ4mg2ypfHOrIYCkXlQnivxvi8Zj8jK7bLly53cQHh883sEYVmymOQt5HXH0kuTEOAhzFILz3EN9sIzxYqmZIvATZJ6tGKQkx2YSpApseaWoibGiCgB9gqBz/8TwK6QOliyyjfJl3IY4ExDYfWj9BjM8x76rRK/m9e2nep1A8MFxK03OfomA+z0dqTD/EbrGbfT2moDpHtIsEpjX5J+OSIqzIoY7xIKBDH5TJ4OExYlbmSyRNv51JSGaQ2HkEVt0CDs
 w0ofgDdM
 dB4tyVoBqBhAKJ+JD44ilGwKP28zGOQikZBCnprDuM65gpWWLitiSZyWa0EcwlSzqw8EfNPPibFeddpSAuD76SPdDrX77AjsR+7hZ5fNF8AiLlJvfCeh5zAYBe1+0RlBrjO6KfmTVsiUYVsSu5cT2EN8RPf1XB0MdxYuJf3gYg6X0QNtijLnm4OqaTdCHRmJSY88SShyh25O83UU4SVF6x0asL4y3teLDG/Ue/rKyKg3X6Qs/uLjPvYOIbGWCe2Cb3Mp9dPZsqQ5MbflulyAGm9LJFypUvauom0YLZLEeozeRQI81K34RJ73ttqsNljjTCqXPF0NB2bPH8lOCRt7wudSxV4lvX/Gx8/abTW7rDq34YDQtix1Ewjd1zA3zk4sWLf5ky5BpabCao9c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 07:34:40PM -0700, Andrew Morton wrote:
> On Thu, 21 May 2026 18:19:04 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:
> 
> > Commit 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg
> > per-node type") split a memcg's single obj_cgroup into one per NUMA
> > node so that reparenting LRU folios can take per-node lru locks. As a
> > side effect, the per-CPU obj_stock_pcp -- which caches a single
> > cached_objcg pointer -- thrashes on workloads where threads of the
> > same memcg run on different NUMA nodes. The kernel test robot reported
> > a 67.7% regression on stress-ng.switch.ops_per_sec from this pattern.
> > 
> > Commit d0211878ce06 ("memcg: cache obj_stock by memcg, not by objcg
> > pointer") landed as a temporary fix by treating sibling per-node
> > objcgs as equivalent for the cache lookup, intended to be reverted
> > once per-node kmem accounting is introduced. This series takes a more
> > general approach: cache multiple objcgs per CPU using the multi-slot
> > pattern memcg_stock_pcp already uses, so the per-node objcg variants
> > of one memcg can all coexist in the stock without ever forcing a
> > drain. The temporary fix can then be reverted.
> > 
> > To avoid increasing the per-CPU cache footprint, the first three
> > patches shrink the existing single-slot obj_stock_pcp fields.
> > The final patch converts cached_objcg and nr_bytes into
> > NR_OBJ_STOCK=5 slot arrays and reorders the struct so the entire
> > consume/refill/account hot path fits within a single 64-byte cache
> > line on non-debug 64-bit builds (verified with pahole).
> 
> Thanks, I added this to mm.git's mm-new branch, along with a couple of
> possible todo notes from the review.
> 
> Sashiko asked a thing:
> 	https://sashiko.dev/#/patchset/20260522011908.1669332-1-shakeel.butt@linux.dev
> 
> Did you already see this?  The footers there indicate that an email was
> sent out but I don't know if it works?

Yes, I saw that comment. It is kind of very specific to archs with 256KiB base
page sizes. Anyways, I have a simple fix for that and there were minor
suggestions from others for simple changes, I will send v3 with the requested
changes.

