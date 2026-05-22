Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 096B1CD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 16:37:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36DED6B0093; Fri, 22 May 2026 12:37:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32DDD6B0095; Fri, 22 May 2026 12:37:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26A9C6B0096; Fri, 22 May 2026 12:37:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 171CD6B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 12:37:55 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AD070140729
	for <linux-mm@kvack.org>; Fri, 22 May 2026 16:37:54 +0000 (UTC)
X-FDA: 84795612468.04.40DAC43
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf18.hostedemail.com (Postfix) with ESMTP id C42C21C0006
	for <linux-mm@kvack.org>; Fri, 22 May 2026 16:37:52 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=giS18ONg;
	spf=pass (imf18.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779467872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oGer9ojiBJJKSgW4zmxqBqKbeEU9rBkVQbJdBxhzT0c=;
	b=o0VK8Pwo5EOjb45WIsm5Nx9zhUGbm/SZhzi4g77xcFRqCuph1Bk5xuiOuzfxZL9UWfdMn9
	CpDKokP3xBFaC8YaenWkEv1NqMJSFUwTHKwyBN8zeWzPR40d/tAfdnF9RRNbdZ/J57fKo/
	VSfV5cIgF7MkGsV62Tq119AUthAjpdA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=giS18ONg;
	spf=pass (imf18.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779467872; a=rsa-sha256;
	cv=none;
	b=K0rNa1zlHaLjAwDYvejakGsd5mqKwNJwCOe/Z+S5q8nG499nKf9CZGRry31A7KlgRCoxUc
	/8HR9rvdld25P8X+debIhzyDplLnfm1EHVzPKeqcnNgjigJRAQN6JqrbCm1LKpOje/ITPJ
	qJHSNEReNZtEFyTAAPwCwIUQ2RkL1Bg=
Date: Fri, 22 May 2026 09:37:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779467871;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oGer9ojiBJJKSgW4zmxqBqKbeEU9rBkVQbJdBxhzT0c=;
	b=giS18ONglvazOIz5+CrJmLvo+1ZX/TD6DtT1KkoaLTzb5sdswuQCbKxe6EBNa8gP4WzY3T
	HeuaJ+sBuZnuEds/er5wc87wu0eCq6itAzxxcRAMWc+YtmGQGQyyx4izS9xDU2SUIm1NVo
	J2Ha8K+cWUlsZqyBlo6lKnjYMcimAs0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Muchun Song <muchun.song@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, Alexandre Ghiti <alex@ghiti.fr>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Harry Yoo <harry@kernel.org>, 
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kernel test robot <oliver.sang@intel.com>
Subject: Re: [PATCH v2 4/4] memcg: multi objcg charge support
Message-ID: <ahCGEAQ6USZDYrUo@linux.dev>
References: <20260522011908.1669332-1-shakeel.butt@linux.dev>
 <20260522011908.1669332-5-shakeel.butt@linux.dev>
 <9D6F8C2F-F3E7-4326-A4F6-D5B1433A6C55@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9D6F8C2F-F3E7-4326-A4F6-D5B1433A6C55@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: C42C21C0006
X-Stat-Signature: 1aca7b8peo9affoaanxknd5tyu3x5f36
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779467872-510497
X-HE-Meta: U2FsdGVkX1+IhytPn2G+XMkP/f6Y3RdfGPrDSDi2CTZpybLYOka3LNOvG/cUb4ho14rVRQ8XJcMVgUru031iNDRmQNtPRrWrvOqq4xjxBTV1crSZWVsZUd65kfnLgKOLz0ojyZM8LoCgXlXzzXh237vc/T7EzvVMtnoWtND2j4Uf4VBEhtyDefMQ0R6725smnrwK6vN/QFrtFgobXxtwMcvJNBcMVu7Pt2/VdVpXNvCtwdp5/ynOfxi/lruLxuULM5Bfn49goMIkCqe8XjPNntvWYuW1AQsTielyxim/nQ1JX++W92jqbLYMrNhpIhzDQW5aEq9XrMrBWK5OxQDh8+8zdzsFZ9n9cSbPgw4OIiCS5fpYrjQ1mEVJ7qU8jy7rVTKD0e88rW7YNDYDzegoFP3EwRQVaAtLMEvXzaw9/tPJjWYVLbSedPcwXyRACrnI5G7AZkTokGptQCZjrDj3JksEC3/oaDIEpNCyqanYepPZuDbb+0085SqE3fa6ADCK0MI2YheYfaE6VAZK3FvCA4oyKjIWaW2OKhq6RObN82nXqj7fkg0GgCFswq3qc/kqWcp0VJqLe5gFRHBti5zlCkx/WLX0+5lG0dIcPsKwPWUl3Hz9Q9jO/gjJ2G9n2PDPWelYZeGOL2/W2NW9ak3oGs/N7uz8tXkKoJpORuuz1gIxFySpS/y/rYTG54aeMjLtr4zkGgffoKyNTx/KRsLqhobx/d6cj6FpeIGyLhF1h1bYd355vOTbbsUDNZcwQwrqfAsKcEYcT3MxinpTj4+MgfaNMrS5dnD1A8FJbHL2ZYzGOUVgdJjtdYS7IXHHv+grFUE8GH1HKw05LMucU5KDN8hYzZXeobQXeiEkbem5cONuMmwBwazRDeg3QYRBvmvlv0+h1Mb9mI7tgGgBBC8eb6WI+iCB21xfgUr2ao9uNmCsK6JrAZB0SqGlcbchVwohxGUAJwFUQ3AhE5RblCx
 LKqMeE3p
 qYoINZnXZhVzSE4RgvmSkZPXj2K5y74FOV86reLFxl4rP+zZNJ4H5OC1DlrYYxuaym73YsNquJM7DYjJOfhnqM7JLeCLz51uMdiAwDwQrq1WGojX/nYwivgtYQVAdcHaA+kYOIiQcuY3br8rA5XlgecqZ6VSdL2kRssSx4TN9raJ0Ow0UMgPaSN6kkLYw4HJ1drZw0mC3OGWtVTaCO9v6l8ANhMqq80cSOA5jLuSBhQgQGOutz0su0OOZYG5Ryoj9WIH6IjPKMWwm/fIiJm0QACyjJoZQBqtndVDvsv1AuRZyXwFPcnFTgGPDf0Vk76WHZNHbEE7zok68N+0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 02:33:36PM +0800, Muchun Song wrote:
> 
> 
> > On May 22, 2026, at 09:19, Shakeel Butt <shakeel.butt@linux.dev> wrote:
> > 
> > Commit 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg
> > per-node type") split a memcg's single obj_cgroup into one per NUMA
> > node so that reparenting LRU folios can take per-node lru locks. As a
> > side effect, the per-CPU obj_stock_pcp -- which caches exactly one
> > cached_objcg -- thrashes on workloads where threads of the same memcg
> > run on different NUMA nodes. The kernel test robot reported a 67.7%
> > regression on stress-ng.switch.ops_per_sec from this pattern.
> > 
> > Mirror the multi-slot pattern already used by memcg_stock_pcp: turn
> > nr_bytes and cached_objcg into NR_OBJ_STOCK-element arrays, scan all
> > slots on consume/refill/account, prefer empty slots when inserting,
> > and evict a random slot only when full. With multiple slots a CPU can
> > hold the per-node objcg variants of one memcg plus a few siblings
> > without ever forcing a drain.
> > 
> > A single int8_t index records which slot the cached slab stats belong
> > to; the stats are flushed on slot or pgdat change. With NR_OBJ_STOCK
> > = 5 the layout (verified with pahole) is:
> > 
> >  offset 0  : lock(1) + index(1) + node_id(2) + slab stats(4) = 8B
> >  offset 8  : nr_bytes[5]                                     = 10B
> >  offset 18 : padding                                         = 6B
> >  offset 24 : cached[5]                                       = 40B
> >  offset 64 : (line 2) work_struct + flags (cold)
> > 
> > so consume_obj_stock, refill_obj_stock and the slab account path each
> > touch exactly one 64-byte cache line on non-debug 64-bit builds.
> > 
> > Reported-by: kernel test robot <oliver.sang@intel.com>
> > Closes: https://lore.kernel.org/oe-lkp/202605121641.b6a60cb0-lkp@intel.com
> > Fixes: 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg per-node type")
> > Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> > Tested-by: kernel test robot <oliver.sang@intel.com>
> > ---
> > 
> > Changes since v1:
> > - Use round robin for drain
> > 
> > mm/memcontrol.c | 188 ++++++++++++++++++++++++++++++++++--------------
> > 1 file changed, 136 insertions(+), 52 deletions(-)
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 78c02451312b..ba17633b0bd0 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -150,14 +150,14 @@ static void obj_cgroup_release(struct percpu_ref *ref)
> > 	* However, it can be PAGE_SIZE or (x * PAGE_SIZE).
> > 	*
> > 	* The following sequence can lead to it:
> > - 	* 1) CPU0: objcg == stock->cached_objcg
> > + 	* 1) CPU0: objcg cached in one of stock->cached[i]
> > 	* 2) CPU1: we do a small allocation (e.g. 92 bytes),
> > 	*          PAGE_SIZE bytes are charged
> > 	* 3) CPU1: a process from another memcg is allocating something,
> > 	*          the stock if flushed,
> > 	*          objcg->nr_charged_bytes = PAGE_SIZE - 92
> > 	* 5) CPU0: we do release this object,
>            ^
>            4
> 
> Since you're already modifying the comments in this section,
> would you mind fixing the numbering as well? I noticed that the
> sequence was wrong a while back :)

Haha I didn't even notice. If I send a new version, I will fix this otherwise I
will ask Andrew to fix inplace.


