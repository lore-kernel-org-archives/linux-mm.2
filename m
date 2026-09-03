Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DD4DC79F82
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 07:35:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61EB76B00E7; Thu,  3 Sep 2026 03:35:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A8CD6B00E8; Thu,  3 Sep 2026 03:35:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46F566B00EA; Thu,  3 Sep 2026 03:35:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 24A976B00E7
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 03:35:09 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B0201140436
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:35:08 +0000 (UTC)
X-FDA: 85171639896.27.AA7458F
Received: from lgeamrelo12.lge.com (lgeamrelo12.lge.com [156.147.23.52])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7013C180004
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:35:05 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.52 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788420907;
	b=A3Uo8xNoyPHCo3MQ9Xs9AnQCJUxMMGUUy7bNIA08+qoTZXXa9uH+AXFQmo7wvdroZ48WRR
	PrwRByCAlHRAVsphiQVdO4FkjoQRunSR8TOaY6nHtW1Hf1kd4EJTZVSR0Kot1MymsM9HIZ
	2e9lZzy9ASzHFPYXl+CgxbLAAibxL9c=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.52 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788420907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HLJQEyE+8eqBQ2O3s/aqOQJTmWVPQl/ZErJzqn+JQDc=;
	b=0Hr1hLVFMyqCRK47cfzT0pJYvjn0gS95wtH9tYzbwHu/BB6JO8zw4Q3kbkOzr/wa2rynPA
	bSlKg9R6pD/wm0i+fhe8cw51RW3nrhT6W9iPJ2LlUx25D+nYlWMmJcAaEapTw+6M0oJXXY
	9KMCdlIfH5EJhBROJuxZqZf2MsGaoKc=
Received: from unknown (HELO lgeamrelo02.lge.com) (156.147.1.126)
	by 156.147.23.52 with ESMTP; 3 Sep 2026 16:35:02 +0900
X-Original-SENDERIP: 156.147.1.126
X-Original-MAILFROM: youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.1.126 with ESMTP; 3 Sep 2026 16:35:02 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Thu, 3 Sep 2026 16:35:02 +0900
From: Youngjun Park <youngjun.park@lge.com>
To: Baoquan He <hebaoquan@kylinos.cn>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org,
	kasong@tencent.com, nphamcs@gmail.com, baohua@kernel.org,
	hannes@cmpxchg.org, yosry@kernel.org, shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev, baoquan.he@linux.dev, david@kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/16] xswap: extendable swap device backed by zswap
Message-ID: <apkjJo+g6ewvLy5+@yjaykim-PowerEdge-T330>
References: <20260827094509.1016740-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260827094509.1016740-1-hebaoquan@kylinos.cn>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7013C180004
X-Stat-Signature: uhmjqnf7maje83cf4q4orsxakptzjkea
X-Rspam-User: 
X-HE-Tag: 1788420905-200651
X-HE-Meta: U2FsdGVkX1+JjWzcr9yelZgnnN9FjOBmKib7vwVcfWhadQhwSESo52hfu1VjdOUBSMX9XaPBwXzKE1ea/XfjQp3BzB5xLV2HPWhnpZ4rTOgAz0wbqVWvBu+sHkuvEhEx/kMZsQO9YG+tFoUTpCOKNnuyMO4t0FyK7bIg2Mm3Jpy2TBIrHLCtRZz9AR5tNXCLEm/COsPonPpxuF1/PFJ99D8jBiXl+SuALgRCEKfOZE1DaS7C4vVHn5SzoK6awPlLCfss0zZ2JeumiQ7QZxJ+Jo9T32bjFIhBO5tGhUp0IZ6uB8JXYnR1rViGelvMEBTGE+vPjuuDP7jl7GY6ZF/IJrpyjiJTvmPTmfRh3XUoKeH7QYK+wLgwfhmUZgY77l7C9pVen/Vxcmu5cirNWOJa1P3Xn94B8JlxJ+85vTjwf4+Mh5RAOvdQkYBVRXu4jwrwbUyMlpFT5Ibl8OY5CJr82+tTRvJiAxF1a03s3NpblEWR7LxBsoPGwrxTAPCRCKvmoRhR4hOrZTt6yRX4P0ynEkpBPBUoEscEh7uff/G54a8vpHNL/IZR9g9aE0DdZR+1c6kw4FHzIsaIhtx+cZlf/d9Z7Tb8RzpXzXPaTslrcV56djzW8qkUmApXhay12oMB10hz1SjFsuuXiWrYWP4igja0VatlATZz3LeGcYZn/83ErsJxvGPRwDRk8tiSWhT17o6uye7myX0lWzXgCktIEVMN7sGjzurtX/HGM1XyyVc0GVvYdTuhlTexbfQb0Fa4MnSzLMqnLG+S/Vnqmlb7DA6/GU9LehRMQZMg/S3KC60DNqvKhqTOadoSuZUT4EVjjUUQE+10cHIo3andMSJ48OMq1glpQ6AIzAEqonZfvM+zfe0Ae33Ir3Lzm1DBXdfNmqp2DMogzXB6uBj/+tteSDDYFY1ab83xjW4t+C/ks1AY/mV5gWdGN2Ue5+KU6Ic9nQh6Og6M9gLBBu7lmh4
 fOqQQOAC
 XpG3DiL2ZlAlmH/xbL6BR2QVOPwGG+4oIK5Gi8aoh/ZE28yutNxx76Tm5+olFa3o2JV6LCWnlZTrCi7TggcjFmrm39N8k4tEdtGVcFw5Fh6MwWx1iqpC2XnWvnsBu4PNev/eyfzwts1jcqnTlVYu5Nyws5WwMCrn00K9/49EmZuN1Q3hVrCGDUD/zUQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 05:44:50PM +0800, Baoquan He wrote:
> xswap is an extendable swap device with no backing storage. Swapped-out
> pages live only in zswap, so the device wastes no disk space and its
> size is independent of any physical device.
> 
> xswap decouples PTE swap entries from physical backing storage. The
> cluster_info array is backed by a sparse vmalloc (VM_SPARSE) area that is
> grown and shrunk on demand:
> 
> - Grow: when cluster allocation runs out of free clusters and the device
>   is below its ceiling, more physical pages are mapped into the VM_SPARSE
>   area and their clusters are added to the free list.
> 
> - Shrink: when contiguous free clusters accumulate at the tail of the
>   mapped range (tracked in O(1) via nr_free_tail), they are unmapped and
>   the backing pages freed.  Shrink is deferred to a workqueue to avoid
>   lock recursion.
> 
> A per-device ceiling (nr_clusters) bounds growth and is adjustable at
> runtime via debugfs.
> 
> Interface:
> 
>   /sys/kernel/mm/xswap/create           write "<percent> [<prio>]" to
>                                         create a device; percent is a
>                                         percent of RAM (0 for the default),
>                                         prio is an optional swap priority
>                                         (default DEF_SWAP_PRIO)

As discussed before, until there's a per-memcg tier concept, is there
a meaningful use case for having more than one xswap device? Would it
make sense to limit it to a single device for now, and add support
for multiple devices later once that structure exists?

Also, if xswap accepts an explicit prio, xswap devices would need to
stay grouped within the same tier. But a slow tier with a different
priority range could end up sandwiched in between, or an xswap device
could fall outside the priority range needed to belong to the same
tier.

Could prio just be fixed instead? Is there a reason it needs to be
assignable per device?

Thanks!
Youngjun

