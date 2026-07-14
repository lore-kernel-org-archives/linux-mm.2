Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B525C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 20:05:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BDCA6B00CA; Tue, 14 Jul 2026 16:05:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3746D6B00F3; Tue, 14 Jul 2026 16:05:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 287256B00F4; Tue, 14 Jul 2026 16:05:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F30856B00CA
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 16:05:31 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 79FDF14045D
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 20:05:31 +0000 (UTC)
X-FDA: 84988462062.03.59BCF54
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf23.hostedemail.com (Postfix) with ESMTP id C02D314000B
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 20:05:29 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="nASgY/cP";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784059529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BLqLKH5IvfKdelylXtTpwefx4KsBR33CINxbQ5x0Fqk=;
	b=z10VOSw0/0rpzrx84ePVxGZ+GumbixLyCYxNNDq39XnibYpKQiX4DqpZzdIov0xAjs0VUU
	GbuCHuwK5fBBTxOuL97wqIR9VVd3OS2qpn4Muu4IdgRT0C7RQZok11GccAOED1xrYniBlv
	w4I/QLeneWHDKu4Fvaxe5E/ybK/0fwc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="nASgY/cP";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784059529;
	b=25NfXjWyTNIo5pV1Gmz3UULbQG5hT4Ls50buBxWe36dAsbjGuFfNtF0dbU5QD6060kCW9a
	MrbdB0kJE2Ymjn0ZBE79zZ16FJ/rkKTeYG+f7a5x0ibQMj804l1cPXHfRuxdEdIeM9eytE
	I0BBdxUsENwlTIsRqDlOR7PE+nCTEFQ=
Date: Tue, 14 Jul 2026 13:05:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784059528;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BLqLKH5IvfKdelylXtTpwefx4KsBR33CINxbQ5x0Fqk=;
	b=nASgY/cPDPiWt21ZZyKIcwGLYVyGB4ufGOPaFxRr5hd6gHTbtV8ySF1XScNfYac7cwG9pg
	QeQlV4JxgsYquQV9RNtt34ZrStlkQWSaagjaMGCvZawUrfC+veAPNpWRV3spiCK62S1xJ+
	HdM9i+zJep7TuSY+/PyleCqGIiIoqv0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, kasong@tencent.com, 
	baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	hannes@cmpxchg.org, harry@kernel.org, muchun.song@linux.dev, 
	peiyang_he@smail.nju.edu.cn, mhocko@kernel.org, roman.gushchin@linux.dev, ljs@kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Qi Zheng <zhengqi.arch@bytedance.com>, stable@vger.kernel.org
Subject: Re: [PATCH v5] mm: mglru: fix stale batch updates after memcg
 reparenting
Message-ID: <alaWT_sKn7V9zoOr@linux.dev>
References: <20260710154318.75388-1-qi.zheng@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710154318.75388-1-qi.zheng@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C02D314000B
X-Stat-Signature: h4hwc4iycm7rjzz33hpopu3dza7s9yh5
X-HE-Tag: 1784059529-270797
X-HE-Meta: U2FsdGVkX18NzNdF4o9vh4nNvbMJ/eY1v5BVkDxzT2S1LUgcPa/YMA7mgwVOX494XADnrX8Roi61MA6qCffoGM2aBmZRdTA876w+gkEr6OIu4D0MhG7niYzisUGcK8UUIeOwg5Q/i2uF//Z8GNXXQohImz6Yo+NrM9+3u/1D30j91pnP5lL0R5tTMeqeiaF9pwQwTqTfA4HTlUNKUAB09Oe08NtxHNz3pLc8fTY+FVTCjFHiuyiMJ6lG/++uYSk+C811yBBRCxSE29JC6ypMUgZpUCabqMgMXp3Vyktp+4Wyk0fQ80HD8511uC7HZgvJKpCj4H5hDVe3YFKl0vDGscmWhy+eaS2Y1EEtkm4Dg62Wgt6sWXqDgCqllElORIhk5Twk5IlYDOVi9nRQ8R1nKa0e48jiiKMB26kmt54aXmPcUO7xwJ3jXwDfsxtakhFv8/l8ydLiyxkDv7k2Y/d2xXkqzyyyytPRBEn77Mvl9h/QqDfuMzOy/9MxxT2ME2JSmZGG6RtVJgmvGs/aSj+T8R41Qickjrslkwk0aAZQ+mpHxcYdmMUzZ8JpBqP7o0CcG+rklUD7bCv5ulAXXh+LLWNLpmS4e6C6Ud7RLbkUVrZUwIw4kWJ/yQ83AMt7ARP186hE9kDozF917qqY2cT47H+fcSpaQS+qC/GqrOciXIky6McjR7tYcSnNSOxS9cNN8IHG0eujjnT3jN8Dsy/eTE38ZK3oLNpFbPSaxb0DHgkDpBxDk4TD/vWMtBThR3kbw3AoCEFJiUtzdF8sSCmyhk3fNDwdIBWt03RVQQkWXnj92ijhg6Jet5ylRseuBINGw3URbnZVW+cQHZ2Y9YmJPbqZ3yteVUjuTsTC3/DftRCkkLH6q09WJLqAhI1s0HU3wLnS/T+BH5xg9noJKkBG2Dq2gcNunnh+EQdFX2eghUFP46Da3tc4PXTgEXC5fd8PbN27tIjmf6XMktLC6Ou
 9WA03ZZg
 TRfewcJAJPqk0eKxhY9vTKEu7UdHBaSRkNu6Rl6OAHTnPwTNK27By8T4eewzYo+SO1gMX2y7QTjImALw5stdPyg9VluQvyVdRyYT1sulKaiurT9MHiFIpbprxNczIf7UldysLuVjsY7LQGrnWaJtq8PWzh7CtKwKTPTiNE6XhYEClGZs9QPH6NsYGwIwgG9Z7E+KlrcW3KY6BeV8G1aGEyj4oZ2/aC71T8L0Rnlw9KPqjYsrNfhBYq90ASHM75TyBnaT+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 11:43:18PM +0800, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> The mglru page table walker batches per-generation size deltas in
> walk->nr_pages while walking page tables without holding the lruvec lock.
> The reset_batch_size() later folds those deltas into walk->lruvec under
> the lruvec lock.
> 
> The page table walker can run concurrently with the memcg reparenting path
> as follows:
> 
> CPU0                           CPU1
> ====                           ====
> 
> walk_mm
> --> walk_page_range
>     --> update_batch_size
>         --> walk->nr_pages += delta
> 
>                               mem_cgroup_css_offline
>                               --> memcg_reparent_objcgs
>                                   --> lock lruvec
>                                       lru_gen_reparent_memcg
>                                       --> reparent child folios to parent
>                                       unlock lruvec
> 
>     lock lruvec
>     reset_batch_size
>     --> child lrugen->nr_pages += delta
> 
> This will trigger the following warning in lru_gen_exit_memcg():
> 
> 	VM_WARN_ON_ONCE(memchr_inv(lruvec->lrugen.nr_pages, 0,
> 				   sizeof(lruvec->lrugen.nr_pages)));
> 
> And the user-visible impact of underestimated nr_pages in MGLRU was
> premature OOMs because MGLRU does not try to reclaim memory when nr_pages
> reaches zero, but there are still more pages.
> 
> To fix it, make reset_batch_size() check CSS_DYING under RCU before
> flushing the pending batch. A non-dying memcg keeps the original lruvec
> stable against RCU-delayed offlining; a dying memcg redirects the deltas
> to the first non-dying ancestor.
> 
> Reported-by: Peiyang He <peiyang_he@smail.nju.edu.cn>
> Closes: https://lore.kernel.org/all/5A9E929D82717101+12fcf643-efb8-4b9a-a53a-1e28cc894f0b@smail.nju.edu.cn
> Fixes: f304652609ea ("mm: vmscan: prepare for reparenting MGLRU folios")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

