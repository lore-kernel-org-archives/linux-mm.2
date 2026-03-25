Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1ACB9109C055
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 18:36:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F6AE6B0089; Wed, 25 Mar 2026 14:36:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CF466B008A; Wed, 25 Mar 2026 14:36:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46F296B008C; Wed, 25 Mar 2026 14:36:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 36E146B0089
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:36:56 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BDD0F5C0A0
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 18:36:55 +0000 (UTC)
X-FDA: 84585441990.01.AA09998
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf26.hostedemail.com (Postfix) with ESMTP id 88FED14000E
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 18:36:52 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774463814; a=rsa-sha256;
	cv=none;
	b=HLXpdpTabQzoPEWaFVV7io1wi2zWf//GWhZGG2+dwTC6/d4eOgBzBewO6aXZMxn+rSekp3
	F5lbQ/zmeTfNxser7b7zIolAsaqozKAmDGRBoSbzsRP5MhLlWGtP5kTV+wWZl9LY1GqVVM
	kPFXSG0RF+HqtliQqGOu4nOz1cdVD2M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774463814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dFmA3BmQAY+HafIIoroCR7sOUBNlQq8ZjodkljHOGpA=;
	b=kVUXo1ywDKiUPWH/gURXGupqrMFKPJRoICQytvGC/jNP911DKBxWnLPR3Lz7MQHWD7O1VK
	qU4G9UZDb7sHn9PNMAhk9PErTJH96DTCZas0ZqP1sqUE1pgFPzIc81aH+KGNC3mcuoFwK/
	r7bSMCiFCuFxOYmTRXoJM1IpVH2D/Ts=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 26 Mar 2026 03:36:49 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Thu, 26 Mar 2026 03:36:49 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Nhat Pham <nphamcs@gmail.com>
Cc: kasong@tencent.com, Liam.Howlett@oracle.com, akpm@linux-foundation.org,
	apopple@nvidia.com, axelrasmussen@google.com, baohua@kernel.org,
	baolin.wang@linux.alibaba.com, bhe@redhat.com, byungchul@sk.com,
	cgroups@vger.kernel.org, chengming.zhou@linux.dev,
	chrisl@kernel.org, corbet@lwn.net, david@kernel.org,
	dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org,
	hughd@google.com, jannh@google.com, joshua.hahnjy@gmail.com,
	lance.yang@linux.dev, lenb@kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-pm@vger.kernel.org, lorenzo.stoakes@oracle.com,
	matthew.brost@intel.com, mhocko@suse.com, muchun.song@linux.dev,
	npache@redhat.com, pavel@kernel.org, peterx@redhat.com,
	peterz@infradead.org, pfalcato@suse.de, rafael@kernel.org,
	rakie.kim@sk.com, roman.gushchin@linux.dev, rppt@kernel.org,
	ryan.roberts@arm.com, shakeel.butt@linux.dev,
	shikemeng@huaweicloud.com, surenb@google.com, tglx@kernel.org,
	vbabka@suse.cz, weixugc@google.com, ying.huang@linux.alibaba.com,
	yosry.ahmed@linux.dev, yuanchu@google.com,
	zhengqi.arch@bytedance.com, ziy@nvidia.com, kernel-team@meta.com,
	riel@surriel.com
Subject: Re: [PATCH v5 00/21] Virtual Swap Space
Message-ID: <acQrQYHJgqof0yx4@yjaykim-PowerEdge-T330>
References: <20260320192735.748051-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320192735.748051-1-nphamcs@gmail.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 88FED14000E
X-Stat-Signature: r85hyt6npxjwypoduyudies7kkyiduok
X-Rspam-User: 
X-HE-Tag: 1774463812-293414
X-HE-Meta: U2FsdGVkX18Dx7iK+3qHUJ22mRimpjEH/Oke0BVADlSSLyE50DNEUVFY1PZPHMEdiJSEN1F33r5VeICDQg9qXID87g+0MN9Pj0dIo2IwXwoGi5shUkNnZEmeFe77Sh55yFU1PoJEW5ogIEs2l0+GiZZjyKiCTZbm6tO8n1mYnCwj4tV83OZJU0cuofLdqjdMW5cpQCE9y/6HqBO1o4tA/YFvTmDBZzWm6uO9pq4nty5CO75QWSsN7gHk64OHou7XAQMVt2d4LGfHktMkcy6nNywKQ98j1CREzOFJIEAPi6cv5Vdhy/0xYrv9fkJ5pkuXJJ4IFZgmJ1S8VHoiA3tgIEXAJn5eEyEgS9YYlNwnKxsxtGkEGXJWaNg7542qAHbajcHYDS+Q3qEYrCC9AuOCGOJCPHRU7LKh/xwk95ltVbH4rNsbz8VJFBnW2Xb6oQ/EnrkfETCqOSwIQhWjoe6tetDErELutQaxetJ5h2tBCM9U5LsZXKEsRCsTEPfkbjbZ3MaYzslfdR9C8qMYagf4j/emBBV5kfjj5C1cN23dZBqhlo4M/L2BpI1tRo/0Ckx4o7rpuQtnf6MiG18xN6qjQZPhisFvfVjYDjTL4DgXlPMPWhjlgZqV7BqLK1ihsdpMyEX+6d9b2WlsYVno3mxAnNFs4jw8/vBHOlIwxnVv556828PEv9pmU58jfawh3cY37TfxlxB63iR+/L026IjLLejUXCmTLykNpvID4UbCwQXrWa8RcplhHrr7nGc0CZqWubd3hNTSbfOdmipmHVVVI/xuiWG1l6SyxtaiM2rsSEKOyYKGwHqtDRWudVtg4H+wzL38WdBg8ChsATZQ5HauNC+EhfHhfcItuJ2jDP1m5CtAoPqkkPhafAOvQA12aR/hkJxkf7++SJ/DUWow78AvRJ7bySSijoziv98XwnjHpJXlgnnM49q7+Hbeid0OCYeN0w2rLyKxaKcZt2aIJ9F
 ihoHLHjh
 T2ZqQJOVBuLQfmbGQZY16QTh4B2ccp06kZwdvwbXTvMVZ8MAEniHH3Sm0LhmavH6uM5GMuO7gsZTj2gG/R2el9iAkER5apyQ4bJtYNfEXqPaItXh7F8vNAftykxX0Kmwp009bvFliMw9Qj08ML78Vo7y7+l/bQBphQQVvow0PLYlMQ/dltohFoO8JRXtyW3bELzRd/oec2YrkFASvupnxvy/knNCSwEc7Hsz1R6djNhh/swaRW1gKZasclMuZlmcCKjuJDTmW/4EbK8vncHtmcac88vaiW5r0hiedyf6RVx3A2ozUzwNG1Yce+BLVd+3OSMfPw8xrU4L0Dysf0+ojU7waJg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 12:27:14PM -0700, Nhat Pham wrote:
> 
> This patch series is based on 6.19. There are a couple more
> swap-related changes in mainline that I would need to coordinate
> with, but I still want to send this out as an update for the
> regressions reported by Kairui Song in [15]. It's probably easier
> to just build this thing rather than dig through that series of
> emails to get the fix patch :)

Hi Nhat,

I wanted to fully understand the patches before asking questions,
but reviewing everything takes time, and I didn't want to miss the
timing. So let me share some thoughts and ask about your direction. 

These are the perspectives I'm coming from:

Pros:
- The architecture is very clean.
- Zero entries currently consume swap space, which can prevent
  actual swap usage in some cases.
- It resolves zswap's dependency on swap device size.
- And so on.

Cons:
- An additional virtual allocation step is introduced per every swap.
- not easy to merge (change swap infrastructure totally?)

To address the cons, I think if we can demonstrate that the
benefits always outweigh the costs, it could fully replace the
existing mechanism. However, if this can be applied selectively,
we get only the pros without the cons.

1. Modularization

You removed CONFIG_* and went with a unified approach. I recall
you were also considering a module-based structure at some point.
What are your thoughts on that direction?

If we take that approach, we could extend the recent swap ops
patchset (https://lore.kernel.org/linux-mm/20260302104016.163542-1-bhe@redhat.com/)
as follows:
- Make vswap a swap module
- Have cluster allocation functions reside in swapops
- Enable vswap through swapon

I think this could result in a similar structure. An additional
benefit would be that it enables various configurations:

- vswap + regular swap together
- vswap only
- And other combinations

And merge is not that hard. it is not the total change of swap infra structure.

But, swapoff fastness might disappear? it is not that critical as I think.

2. Flash-friendly swap integration (for my use case)

I've been thinking about the flash-friendly swap concept that
I mentioned before and recently proposed:
(https://lore.kernel.org/linux-mm/aZW0voL4MmnMQlaR@yjaykim-PowerEdge-T330/)

One of its core functions requires buffering RAM-swapped pages
and writing them sequentially at an appropriate time -- not
immediately, but in proper block-sized units, sequentially.

This means allocated offsets must essentially be virtual, and
physical offsets need to be managed separately at the actual
write time.

If we integrate this into the current vswap, we would either
need vswap itself to handle the sequential writes (bypassing
the physical device and receiving pages directly), or swapon
a swap device and have vswap obtain physical offsets from it.
But since those offsets cannot be used directly (due to
buffering and sequential write requirements), they become
virtual too, resulting in:

  virtual -> virtual -> physical

This triple indirection is not ideal.

However, if the modularization from point 1 is achieved and
vswap acts as a swap device itself, then we can cleanly
establish a:

  virtual -> physical

relationship within it.

I noticed you seem to be exploring collaboration with Kairui
as well. I'm curious whether you have a compromise direction
in mind, or if you plan to stick with the current approach.

P.S. I definitely want to review the vswap code in detail
when I get the time. great work and code.

Thanks,
Youngjun Park

