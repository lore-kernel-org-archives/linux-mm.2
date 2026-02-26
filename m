Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF661FD4609
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 02:28:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 176306B0088; Wed, 25 Feb 2026 21:28:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FA446B0089; Wed, 25 Feb 2026 21:28:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 005A26B008A; Wed, 25 Feb 2026 21:28:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E0CF76B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 21:28:18 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 937C71404D7
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 02:28:18 +0000 (UTC)
X-FDA: 84485023476.02.925BB5C
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2BA1640006
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 02:28:14 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=inLRTyPS;
	spf=pass (imf11.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772072897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J8G7n0G5IvJbjAWS80AASD+GlHfDZ2XYW2oW2fVo6QM=;
	b=cl3CJ9wHpEO/Uyh3pEnwPto2HFFk9xXg55DqRiCMfssI8Uc1vuUHfxnX/Y/5mdnXMy5Nr/
	XxBTZdPlTnX3//A9IyUhqTI8eyAgMuvaralplMA10iQP4reORxNu2d4nvJN8fwlrT3yyuT
	t5CuYzHZq+giR0qhYhDltw2hfFh1u3s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772072897; a=rsa-sha256;
	cv=none;
	b=YvzO6LrD7uwbwfNiYREShRQFAFWqfASf66FGQnJVLlCicyCF5SYbyYiy+Nr0RZFvmoxFwh
	KYnSkKy+arQs1i6PpQkA7e9TxYKn3kaE7zuR3zRMVmLZa0lGZIOCpPzz3fIPjierYo1PQk
	vJWbQFxs18kk9JQcW23jJXKCoxHXcK0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=inLRTyPS;
	spf=pass (imf11.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Wed, 25 Feb 2026 18:27:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772072890;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=J8G7n0G5IvJbjAWS80AASD+GlHfDZ2XYW2oW2fVo6QM=;
	b=inLRTyPSomd7cx4tU1l+xytkHbPVoB+tKgvlzV/f7mXEW2S2TI31JThNxm3yX9SBJdI5p1
	i0VoBYNMyPj1gMmS3Ptyr4w2cftRfMimJ/kcnc7uxjbuoeeEjCNe2dKfi5gncND2OYLgLN
	KjtZfn55mBY7Dw+8pMmY+l0Ybo4QO+Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, yosry.ahmed@linux.dev, 
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com, 
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, 
	lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v5 update 30/32] mm: memcontrol: convert objcg to be
 per-memcg per-node type
Message-ID: <aZ-uNV1biPYLhJ48@linux.dev>
References: <0f915487ffc653cf6ea19335c21c01aa06004641.1772005110.git.zhengqi.arch@bytedance.com>
 <20260225094456.74145-1-qi.zheng@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225094456.74145-1-qi.zheng@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Stat-Signature: qkswy8wf1qdrsaxk5hso5u6edmu1g4iw
X-Rspamd-Queue-Id: 2BA1640006
X-Rspam-User: 
X-HE-Tag: 1772072894-73135
X-HE-Meta: U2FsdGVkX18zAC0oRkViytmYIF25LqUYR01HvASZqLJdmxSmwCQIE8ev4FWBvqp3jrKtrqYw2HjxnCvRSk2Zh6ORwhZRysi3Cjmho4QjxWUD0wpVe9bBTHXrS9tdJlVxZS98S0r26KIpTv9CPC2/PQAdg4v+CPM9rdKj0+Bf0aq5PdnKxVWVCPZ9IXmxr7/fJbEUpweALB6wVTHCfRWPIEDMfpGlyXCpsmvMXFfDC+SjKvASdw8y4VbW0sfmqJ2zez5e8BMIyQGAqqVQbvJF2DGARYTyKzTIeWzL/GisF/tpCihhw4H2kmmCfZ8JQ2qzVO5DfOyavsqC3kUoBh2PRu8fMOYabb4aa8ebSgIuFkuNJoOeJPhSwcfmx4GKMF6cyMcTnoe0jJbzlv1JJ0SNY5C1gsnAuUqrWeTnZjVQ+HjDCTtWSxoOIuAwDKWh8dN5PJjTqxvtnvSI+E0tLYnK8mjsafGZGV68MT5z4FTaz7nMzuhMX/tIauX4R2HdyteBpcAJtdUdDe60+MMN9uEJpl3lKdpfl57X3BcqUxnBuZHxDIzpdfKFxZSd+lx6mUPBwTYvcsq8oj2NW5Gj4xjT8TV0D3g1UWBd6LJHaZNmmmfcooDm8gOxRLKVnnILbtSf8BB+bItL94ilEbEJZ0TXH3nZ0bTf36VGwUouPLejvuJMd2jfe1SDZzvV9lz2hPSuU8VNgyVj8374fKtClGHSHXDWfVEkS7PSpe58u0xsRXSOtEoowLd/4GOy/tEOlZFUqOTeVQLrnV+yXakKp9X9ZQ4plbmEUFEFYWFEFcie7HNLaEsp5BoyZFQ0yeve8bvuAQ+cgH2xXXI5H3OWZLXfi5oqELMLaSCzVMuNPisHEPZKrluxuYgrwgef33hWlxpmVBc4cUYEvG3CQmL3XjT8TewOTkK95/w6AJukTjtxrVNrlY0boc7RBpJHN4vO7HibLJdKFWOZ6wdIZnMIemm
 7/sxkSf+
 GOeB97X7ubAtcs9dCU9TkDR33bdZLZbnmsySAHmsWNvpEkNKJyUAL3ydoMXSsPFZThtm5xmb0NS8YB6F+hiVucaPOLlyhKmna3/28kLjR94ZVHMOZYWj9fQMc2KeuS4D3VPUAHaCYQv3seRNYHuGl1UPJmksdOa9dtNQW8ZkfZOpkn4c/T0T9HmKeUyh+DcFZFi8RbLBGaAfpUS9fhPJ+PRTJecE/oDs8NhkuHDF7MBDBFONxNa1uKnN+HO9+x/TvffWyT61eVw+35/Kq7B+dRQ7xMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 05:44:56PM +0800, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> Convert objcg to be per-memcg per-node type, so that when reparent LRU
> folios later, we can hold the lru lock at the node level, thus avoiding
> holding too many lru locks at once.
> 
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---
> changlog:
>  - fix a missing root_obj_cgroup conversion and completely delete
>    root_obj_cgroup.
> 
>  include/linux/memcontrol.h | 23 +++++------
>  include/linux/sched.h      |  2 +-
>  mm/memcontrol.c            | 79 +++++++++++++++++++++++---------------
>  3 files changed, 62 insertions(+), 42 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 45d911dd903e7..6e11552a90618 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -116,6 +116,16 @@ struct mem_cgroup_per_node {
>  	unsigned long		lru_zone_size[MAX_NR_ZONES][NR_LRU_LISTS];
>  	struct mem_cgroup_reclaim_iter	iter;
>  
> +	/*
> +	 * objcg is wiped out as a part of the objcg repaprenting process.
> +	 * orig_objcg preserves a pointer (and a reference) to the original
> +	 * objcg until the end of live of memcg.
> +	 */
> +	struct obj_cgroup __rcu	*objcg;
> +	struct obj_cgroup	*orig_objcg;

The layout of struct mem_cgroup_per_node is very performance sensitive. Please
couple of performance benchmarks after rearranging the fields particularly the
above two pointers together at the start of the struct.

Otherwise:

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

