Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3298107761C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 20:51:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7AD36B032F; Wed, 18 Mar 2026 16:51:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2C246B0330; Wed, 18 Mar 2026 16:51:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D68D36B0331; Wed, 18 Mar 2026 16:51:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C5C6C6B032F
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 16:51:14 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5F2A31A015A
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 20:51:14 +0000 (UTC)
X-FDA: 84560378868.01.DC3A794
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf23.hostedemail.com (Postfix) with ESMTP id 58FEF140012
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 20:51:12 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mFHpCUO9;
	spf=pass (imf23.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773867072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jDhgcdQYWRAHbCXaMJOJeJyqhIY2pecR4Pfu9w08Mv4=;
	b=x8Q9FQuiod6p6Pi3QPV+ugCDrhL0vWyEg3zN8nEw6xWgBdTWJSTtPa9iNFMBek5GhrYuDC
	bzAgv1L0FfMgnFhaDVPlgR7Y++k285npfJTM6kGCzVbQL7QX+6wAk1rVOgModHhHIXynBr
	Xl4ySxTPh527tsFyILF803YT6eIP5dk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773867072; a=rsa-sha256;
	cv=none;
	b=AS6OEAhZXyVics7h6+M0BaYXEtJMiYu1HG0w96hCAELykqseBAVfv6w21NbMeQjw5fK1Ta
	L87iwwR7VDCPzA5JYS2zQdnFig6if9u5U49lsAMtvxJZWHc9ROYfra1EaRlCRt8Z6w+8jH
	GzlUMYzn6JPbOlfJq/F8oY/lw8VbtWs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mFHpCUO9;
	spf=pass (imf23.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Wed, 18 Mar 2026 13:51:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773867069;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jDhgcdQYWRAHbCXaMJOJeJyqhIY2pecR4Pfu9w08Mv4=;
	b=mFHpCUO9u/MBt+HlQ4/bAC6fqp/6hRvvArE/ZHsnEH0ftY4GgtNSEzSkYaECsW/OIH82f4
	ZnxjNGU+1oGBPG5ywjZqo0SehMqDV2OqR3L40gZvOynVuLoWuyabk5dS5+GtCusmKIb1pp
	f7ao7LbzaGJCsv3FCfN7NDix8HhROHA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, Zi Yan <ziy@nvidia.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Dave Chinner <david@fromorbit.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 5/7] mm: list_lru: introduce caller locking for
 additions and deletions
Message-ID: <absO1Bg_exH4llmH@linux.dev>
References: <20260318200352.1039011-1-hannes@cmpxchg.org>
 <20260318200352.1039011-6-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260318200352.1039011-6-hannes@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: kdm7xwohk9xe1o3pqzomji7ehy6y8guh
X-Rspam-User: 
X-Rspamd-Queue-Id: 58FEF140012
X-Rspamd-Server: rspam12
X-HE-Tag: 1773867072-311504
X-HE-Meta: U2FsdGVkX1//FbfPWcZDghmL3Pc1sxUaF4oKpd9Tk0v7hUMPZg+Tj0OB5lNy1rAvv6g4doMCLhqWa7QRnAlrsTb2mKZDjGnbhsEMlRZPUNeMiNckcJ2ZMc0Fd0MP05joIiwbfVSQhFXOTJFJOiff6JWLtw8k6M8YEhBC/fpSDBLgvBHPyyR2r0Bj2Dv5rrVP1w+V0aQfGTGZwwevmx0t+5LXZ6G0wAyFgseDIeUsP+eWyfMHnPh2PPMHdt4yd26YXwhUEyZHpTsD+oT1/1EmvgV7WiC+a/0CzBveKN/aQxE6oRu43y84zGO36hq5RCGcFCfAXKt5hgCw0Os5VR9H5FFLx9ttTy6k5tSefnsjYCgWjQg7QwEHxILkdGffQLGZ37bg6r9uSJXkZdAQ8K7dTy9B5upd70eyJfJIYYxnDiUAqLnZz7ibP531yu57Cqugdn6F2vHTygUyzDPPYCunceXhTfTdQE7ME3dg0B0Sl64NRRiMkXJ6CIGdOV8TAx4j4OHXG5WbBnc/hNUhR6i0UzIouux1/sOrVOfa5COLjv0Px0AIFVf3niPRF2h07mFk0y2e76wpgRuEat9wGIXB/AH6jeiTUCBfEt0MhqWgH+lo9vT439tIygKxBebQYUb2SxwmBnPP3YhIXCUjZ5Qq9HzpSa4IUq5ZR0mbsH85HNxKuK2zjzpjKzg2TVtzTjEgASrcwh5Id/yU5F2Zbo0uQWSqNIsCZdhtehY5P5Mi/+kVJjR1ScpsDOoaUCSck5bhmpmVpekqT6PfcaoxiniN2j736XxSs4EKMwSO9p8XeBHMqtHhaGTJAtRV3QyJVFyiM/Princgv8UvhF3J1ys1Y7TtRyMivTQ0kAxsUz+TD6GQpweW59dSpvfjyYU9VsOm1wt3cQJGJ/UdFRuoGxJRRoMfWpg/KTcUlqPeJbXJy0t1rmnz8qn0awZAirzxQJ9GRQaIQeS3Od90F5zLFCG
 RkA8XWXO
 wa/ROkStADMnj5EHki9S0QN1ngs2ww9SaFo5rYst+aKk1iGIEQJ2ovlkN3deZ2N4VCJkokWpc5Y4BfLQ/ee8jQ0QB8lGW/tFqPzVMg4gNMVa5BfNoJL7rgtK6FNOG0oJ5oXx89E3sYWHnIPdaF58Q6ExqDnS57LS/mmk2jBHnAuu83vycfhLZBWwCRmWqrtqc1OmS33olLXLaGtv4NY/+07JmkrRG25N1rppROZoICZXvFnRJgzYVOlvGpCqyKniQx+X6cr5lMZSM1xGfeBiicGN4AzdFhZN+/AZczK6Io3UMlNM//zheo0g0ZaQ/jIs5z4cqa8xCUMgx6CHW8ah6TqewYg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 03:53:23PM -0400, Johannes Weiner wrote:
> Locking is currently internal to the list_lru API. However, a caller
> might want to keep auxiliary state synchronized with the LRU state.
> 
> For example, the THP shrinker uses the lock of its custom LRU to keep
> PG_partially_mapped and vmstats consistent.
> 
> To allow the THP shrinker to switch to list_lru, provide normal and
> irqsafe locking primitives as well as caller-locked variants of the
> addition and deletion functions.
> 
> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

One nit below, other than that:

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

>  
> -static inline void lock_list_lru(struct list_lru_one *l, bool irq)
> +static inline void lock_list_lru(struct list_lru_one *l, bool irq,
> +				 unsigned long *irq_flags)
>  {
> -	if (irq)
> +	if (irq_flags)
> +		spin_lock_irqsave(&l->lock, *irq_flags);
> +	else if (irq)

If we move __list_lru_walk_one to use irq_flags then we can remove the irq
param. It is reclaim code path and I don't think additional cost of irqsave
would matter here.


