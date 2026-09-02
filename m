Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F30CC624D0
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 09:16:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54E406B00CE; Wed,  2 Sep 2026 05:16:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FEF66B00CF; Wed,  2 Sep 2026 05:16:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 414FF6B00D0; Wed,  2 Sep 2026 05:16:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1650E6B00CE
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 05:16:34 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6942916011A
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:16:33 +0000 (UTC)
X-FDA: 85168266666.04.B5682AB
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7CFFE80005
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:16:30 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Ae32Vid9;
	spf=pass (imf02.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788340591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/xWKMGzD5oNg8UWITXcf+NlpDdHUkl8dRMjiWqCZA7k=;
	b=dwcRDRd3jDWw7AJ5dKGG8TQ4XrRDJTnEZz9m2Q9VpZBUhDFZBtAfdFbtC8xMuIuWz267nR
	uZiHubyGSQ1H0vj2g5Qe2G8eTocsTvzUQ/vyQEdRLrlBKqyKw0eNdVBEWQ4Uff9P2SRMiI
	n59nGQxazIt85GaECwWxk8lHRM5AGkw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788340591;
	b=IhrtUXL8OAOW2QZlKs5md+Mbsm50stn0rICK5WWS4woCgq422SzrYy85vZx7N2nv+NsSnf
	GW39r5pEgqDvNSkniyJ967UKjFroGchRwNFCHUqz3biyKYX3EH2IBZu3CtkwTdVJkvp4GU
	AENR+B68QCBNUbPo4AMHY3q1C16BM4o=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Ae32Vid9;
	spf=pass (imf02.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788340588; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=/xWKMGzD5oNg8UWITXcf+NlpDdHUkl8dRMjiWqCZA7k=;
	b=Ae32Vid97IVB/ED0UMSwePQjhjeOih06lyXrUBfBDFt7EgTFFXuzpqX7VZpUZv1iS3pTFHHJYKKah7H5cLYDW6ytJ9ReNVU1HfNp8jor/DCrDf0AnLYLakPUy5RRwDH6vo/MyhIoI9BziPasd0LobDstC17ysGN38fh4MmPOb4c=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R591e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0XACEJlP_1788340586;
Received: from 30.74.144.115(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XACEJlP_1788340586 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 02 Sep 2026 17:16:27 +0800
Message-ID: <ef76e85b-dc8e-40b7-9a7f-a071d54ca7fe@linux.alibaba.com>
Date: Wed, 2 Sep 2026 17:16:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/list_lru: disable memcg awareness under
 cgroup_disable=memory
To: Qinyun Tan <qinyuntan@linux.alibaba.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Xunlei Pang <xlpang@linux.alibaba.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260902032840.30250-1-qinyuntan@linux.alibaba.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260902032840.30250-1-qinyuntan@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7CFFE80005
X-Stat-Signature: 6nzjiwn15zpiza8p87kjfsmsiabdrp9m
X-HE-Tag: 1788340590-572903
X-HE-Meta: U2FsdGVkX1831jo4f4YqiisQVsNYd+GDp8jbCEBpgArd1QKokSMq+RZYzbDmtxb4MAl72z33nE9GurBpFVgTpd0cMYBUjgziFFIyoef/tCVw8+OFJbkCfwVU+PisPVn7vXtigdU0Jz7bnGgJ6ROE/meyilDxz4SShoBp9o/Ky3PQ5+Pon+/2Iu87u+N4MckpxAtJyApG4LX2WIjIOrPbQPhf4LrXIp5hK1igjEq0vAXdbjA24d4ht0cGfiXPA7yOef9VVoZK4qhplm3tcVilM9vbifMWvY5WMb5Bm0LN/3RcYCxjLzvLpGCJQn8abs4lWuXPx1eE0hvwtYIzI6ZrImfCq30G488JC3Peu+1wyzi+kCvmhsAPxO9/hpGvznA7l9DFS+yFKqeulOe4k4M7yPiYCxtept4st4k5Jg4+qWti8VAEM5YWVcdtpkYgiX8vHb/1SSr/LxGS5cuJrzJiX/TbzNRgeMtHt1ecn/4qtoJOoFNyW2sZFBDotyX9inWhNGRi3AGTnA5P/cHkraP9Vhh7xjy/gmxM5+uglwY0kSI85Qqh44zGCSzCdBVxOgLJYtav5ey8CljCfC2XAS+ZrgUxo/dcDD3JSKnXSqABbzw4WRqD9Rr9i90kS2JrFfT0UB5qul+QLDCJsbai2v6Sbt0uuiPC0ekqQtkmhbCLmSNmJcaRtsbZW5FEXRasme85ySE83ZzbhR9suCKOZmazEJcf3UMPRH7IchWe1vtgyMdYZp09m0N5u23L7krHzs9lvVi6juWr/54E64l/TitfPXVD5GTN5gOvuMZHec+E71deLXcJt4UG7yZrP/3nEaZP+ekfCLx+DdNhjL7y98ZtpMgu40FJ5s4R+vi/Ro5J80blTsrwnVWufWq0nU3PxK1aCE7uBINcLWAfelAkt3nID4grVafHrE47hblPJqSgfoza4N25pTNgGb3UOkr9LAUHgZQUzWo63IDcNgw+RFk
 ljJLx8hq
 UoD5pEZ0T+WhmOKbIrrlkuzwrKPx/wkosffNyDGvZNS9TZ/P9k1YRIUJQQsOxoQ7777Bz48jl0F7HR8q6e+1NkBQuTDB1wzw5k7ZDEMsvkSAHJ3k+fwBC7Vm/VkCV0L2sL+S7whW5Qy4g/LaspoQmvmOy57WnCP5TTQvTVaCiL2AckgXNOvxTy/B811XoVYN6tsNgDF+rsRs6rtgfehpkpSTN6deJJPoOG5wysLx5J6WYHjJaL/Fl7uw2uHOWChpve8akIF4/ZDwNafBKqTmxuuCxDZoEm8UzEf3EMC2CYUB+Yg/ZNFdqNROJIE8HFRUhfQLpobDcLtTFBoGcyRefq0p+oexFuY0rTgwpQQeG7UGWDkgY3n0knA7C+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/2/26 11:28 AM, Qinyun Tan wrote:
> __list_lru_init() only collapses a memcg-aware list_lru into plain
> per-node lists when kmem accounting is disabled
> (cgroup.memory=nokmem).  When the memory controller is disabled
> entirely (cgroup_disable=memory), mem_cgroup_kmem_disabled() is
> false, so the lru stays memcg aware even though no object will ever
> be charged to a memcg.
> 
> This is more than a semantic inconsistency.
> folio_memcg_list_lru_alloc() trusts list_lru_memcg_aware() and
> dereferences the folio's memcg, which is always NULL with the
> controller disabled.  The only mainline caller,
> folio_memcg_alloc_deferred(), papers over this with an explicit
> mem_cgroup_disabled() check.  The shmem unused-huge shrinker
> conversion ("mm: shmem: make unused huge shrinker memcg aware") adds
> a second caller without such a guard, so booting with
> cgroup_disable=memory and writing to a huge=always tmpfs oopses:
> 
>    BUG: unable to handle page fault for address: 0000000000000488
>    RIP: 0010:folio_memcg_list_lru_alloc+0x41/0xf0
>    Call Trace:
>     <TASK>
>     shmem_get_folio_gfp+0x1cd/0x7c0
>     shmem_write_begin+0x5d/0x100
>     generic_perform_write+0x89/0x2a0
>     shmem_file_write_iter+0x82/0x90
>     vfs_write+0x256/0x410
>     ksys_write+0x61/0xe0
>     do_syscall_64+0x8d/0x460
>     entry_SYSCALL_64_after_hwframe+0x76/0x7e
> 
> The faulting address is the offset of mem_cgroup->kmemcg_id,
> dereferenced on a NULL memcg in memcg_list_lru_allocated():
> 
>    folio_memcg_list_lru_alloc()
>      list_lru_memcg_aware()               <- true, only nokmem checked
>      memcg = folio_memcg(folio)           <- NULL
>      memcg_list_lru_allocated(memcg, lru)
>        memcg->kmemcg_id                   <- NULL pointer dereference
> 
> Check mem_cgroup_disabled() in __list_lru_init() so that all
> list_lrus fall back to plain per-node lists when the controller is
> disabled, matching what the shrinker side already does
> (shrinker_memcg_alloc() bails out on mem_cgroup_disabled()).  This
> makes the mem_cgroup_disabled() check in callers unnecessary rather
> than mandatory.
> 
> Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
> ---
> Applies on top of mm-new.  No Fixes: tag since the commit that makes
> the crash reachable ("mm: shmem: make unused huge shrinker memcg
> aware") is only in mm-new; no stable backport is needed either.
> 
> Reproducer, on mm-new booted with cgroup_disable=memory
> (CONFIG_MEMCG=y, CONFIG_TRANSPARENT_HUGEPAGE=y):
> 
>    # mount -t tmpfs -o huge=always tmpfs /mnt
>    # echo x > /mnt/f
> 
> Without this patch the write oopses immediately as shown above: the
> freshly allocated huge folio extends beyond i_size, so
> shmem_get_folio_gfp() queues the inode via shmem_unused_huge_add()
> -> folio_memcg_list_lru_alloc(), which dereferences the NULL
> folio_memcg().
> 
> With this patch the same steps run cleanly: the lru falls back to
> plain per-node lists and folio_memcg_list_lru_alloc() returns early.
>  From code inspection the rest of the shmem path handles the NULL
> objcg fine (obj_cgroup_memcg() and obj_cgroup_put() are NULL-safe,
> and list_lru_add() with a NULL memcg lands on the per-node list),
> but I have not exercised the shrinker reclaim itself under
> cgroup_disable=memory.
> 
> Discussion: https://lore.kernel.org/linux-mm/20260901115104.2944996-1-qinyuntan@linux.alibaba.com/
> 
>   mm/list_lru.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/list_lru.c b/mm/list_lru.c
> index 36662d02ff963..f8be119351cca 100644
> --- a/mm/list_lru.c
> +++ b/mm/list_lru.c
> @@ -671,7 +671,12 @@ int __list_lru_init(struct list_lru *lru, bool memcg_aware, struct shrinker *shr
>   	else
>   		lru->shrinker_id = -1;
>   
> -	if (mem_cgroup_kmem_disabled())
> +	/*
> +	 * With the memory controller disabled entirely, no object is ever
> +	 * charged to a memcg, so collapse to plain per-node lists just
> +	 * like under nokmem.
> +	 */

These comments seem useless, as the code already explains itself.

> +	if (mem_cgroup_disabled() || mem_cgroup_kmem_disabled())
>   		memcg_aware = false;
>   #endif
>   

Since __list_lru_init() is also exported, I think this looks reasonable 
to me. With comments removed,

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

