Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77055CD6E4A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 11:28:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC1A36B03D1; Tue,  2 Jun 2026 07:28:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D71E86B03D5; Tue,  2 Jun 2026 07:28:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAEBC6B03D6; Tue,  2 Jun 2026 07:28:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B94B56B03D1
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 07:28:30 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5CE90162BF4
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 11:28:30 +0000 (UTC)
X-FDA: 84834749580.21.A21411D
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf13.hostedemail.com (Postfix) with ESMTP id 640D42000C
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 11:28:28 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wuI3G9V5;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780399708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DqIp9oLiwLP2+3Nhy9P7Nc7jHSP98WdXRQhmtOU/X1k=;
	b=eT9msUNu/53++1r3l3al9JkCBmY3SY+D8ilyOv7Y1Lu8xMorYCXImPEAVVTDMP2s48NY7p
	CXcmIFmsYjVt8Wh7/KR/kcDJ9nDGmeRpUuTw+UpgtvYfJe2bHxXKxYaPFf/KGCuPTJ5SAx
	gqBEftA8dO/z5VygdqsiLVi0o6h8Jno=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wuI3G9V5;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780399708;
	b=iDqeaJ4/iZNlk4qaeY1Cx1h7HA+5cNwEEYNNfgb5Ki4qG0ZaaTZajLamHjz152QAdzXKKR
	43zyMvnPgZpEWK25ASYA2jJnvcXhWQNXPnvVdnAN9pEWI+QA7lrlKLD3/fWybptJq16IER
	/jy3QqOsfFn2kkDTVtTMkXxAI35FkXM=
Date: Tue, 2 Jun 2026 19:28:05 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780399705;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DqIp9oLiwLP2+3Nhy9P7Nc7jHSP98WdXRQhmtOU/X1k=;
	b=wuI3G9V5joRwS25/kCM1W+4B5A8YDJp2Oy3gpzXuENkTevI3r+vC4pB87PewrKOt4rAQvW
	trO6T8+owDWKQ/Lx11TV5eYnc5Z9/B0uYts/A2jMhIM6GUA2nS8aanJKdar+Hz8VYhpJXS
	M7HTv/xyXnx+/HmpXdoFxUUgMQTjT7o=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: Jianyue Wu <wujianyue000@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/3] mm: move folio LRU code out of swap
Message-ID: <ah6-RRTGIBmjrlJi@MiWiFi-R3L-srv>
References: <20260602-ch-swap-series-plus-folio-lru-cleanup-v3-0-5bbb567f8c99@gmail.com>
 <20260602-ch-swap-series-plus-folio-lru-cleanup-v3-2-5bbb567f8c99@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260602-ch-swap-series-plus-folio-lru-cleanup-v3-2-5bbb567f8c99@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: c3y6bgrozthm9d611a4c8kswogbe4j9s
X-Rspamd-Queue-Id: 640D42000C
X-HE-Tag: 1780399708-269329
X-HE-Meta: U2FsdGVkX18n39Ed4l8WUbbwBgyGLJQ8fZeXTyd4Q3vntsFJKp7Ma1MDo4SnNhfiPoqY2Bx2w9ITh00Jg5CYgEflAlHmFAxDpqwohzlc+H2BTrY7z04AFAFunLfzWNSReA849fhJd2hLpsGMWCEEx+mcCuSX2GlDOmJNre43VnZ9VvLw1gqIQsmYD6rsxTVhn7DsTM3JcrBeczLSz2mo5XXq+g503ns5jwQZ08EpecbsxYS1My2YRLTCXviNdeOU9Gxpl8fICaq5F+XMMjm1SeJptk8wfKMlUD+6q9mwf3SDNA5KHsFHLJXpppHU8J6xXyHHDu7rRRA5keSb7TvJaibm4DRZt2Sk01bq6WK8ejfwJDi2sXhOdOT8ArWOZ1xL2lPlLkm4dutoJ3XFcJ8j22WJ4ULIThEkz0/D9T2XtsjQxfTvl//dmlBY1xTCZMYuq4ZpIKquKjFJJynUuubD4wfzNUljpfopZlOUjNvtj9gI6hI/9l+b0fspVmvrAPINUrCLrmSHi2jg24A06foLhVIo02pZQ8M/dUqZjDEuGbDAPwVsVnUbRwRxeXL3kSAvREVMUf9Uz268qgU+NuY/GOPKqv6qU+eexeUhIetXpzFwgMTnWu04QnWtAA6HsvzSvo43jEfjCG3iXkPFTXDkLlCwxSF0Meaa9DN4Y1dHT0Y6KPrGI22zHX2uz76Dnhb2Nwqw762mR19ucY7deQ/rrMjNYg4Fyl2TEn7em3DoBCslQ4BQMMGVcn20Fnc0oFtM9exPlL1jHWwfJtZzh3nyzajxKf4nH7UExBVlJJtzlbXi/UWxaHoUm/R1oZMnopA4XES8hSRLWF1eKG3l8d2x8QG/4Zm4hT0LzNd5Wr4UM6mkwN0xGgpYhncIcACUZRPNS2fQNWIz4S0+vFKokr3kBYYZLDtfBxqWpXYVnp3zboh7EbT2536h/f4nU+oZ65ntIRv78PhFfastjk6jyw+
 xkJJj0yR
 ZKf/EI8YQyfzcEVohdDryGuk/9FO33izoEJBKIvjRcvfSDuQ+sp/qcFBux4jk9OD0fdY/YtVwv3U3yt7B3p9L4w2/jvRlS6tWcUWq/wVnqO6Rbpz6p8IAGVjUs0VORm51WYJyy/QSyFU31n3LWBHcAPgtHz1SMT/H1BidWRafn2oYsKAOO/tZ6ogck79CXo1mqZPDANdKxXUe/ubiHEh7W8BHjSRLRkpcTKHqbNoY96bA8AhBfyeJLYoqIIaS3pYJ9DHwW7wyTMjxGJ9EgAEIfn7mUtj7JuMmGkD88UAq9MuodSFm177pNjkMe5CAf1C8jXat
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06/02/26 at 09:01am, Jianyue Wu wrote:
> Rename mm/swap.c to mm/folio_lru.c so the filename better matches
> the code's main responsibility.

Isn't the main action of this patch renaming mm/swap.c to
mm/folio_lru.c? Why the subject still saying moving folio LRU code out
of swap? I am a little confused?

> 
> This keeps the implementation split from swap-specific code without
> changing the published LRU helper interfaces.
> 
> Update MAINTAINERS and the remaining mm/swap.c documentation references
> after the rename.
> 
> Suggested-by: Baoquan He <bhe@redhat.com>
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
> ---
>  Documentation/admin-guide/sysctl/vm.rst | 2 +-
>  Documentation/core-api/mm-api.rst       | 2 +-
>  MAINTAINERS                             | 3 +--
>  mm/Makefile                             | 2 +-
>  mm/{swap.c => folio_lru.c}              | 2 +-
>  5 files changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
> index 97e12359775c..31d135e107cb 100644
> --- a/Documentation/admin-guide/sysctl/vm.rst
> +++ b/Documentation/admin-guide/sysctl/vm.rst
> @@ -20,7 +20,7 @@ of the virtual memory (VM) subsystem of the Linux kernel and
>  the writeout of dirty data to disk.
>  
>  Default values and initialization routines for most of these
> -files can be found in mm/swap.c.
> +files can be found in mm/swap_state.c.

Sorry, I don't get what are 'these files' for most of which default
values and initialization routines can be found in mm/swap.c or
mm/swap_state.c. I tried to search some of them, they are not in
mm/swap*. Could you double check if this sentence is still meaningful.

>  
>  Currently, these files are in /proc/sys/vm:
>  
> diff --git a/Documentation/core-api/mm-api.rst b/Documentation/core-api/mm-api.rst
> index aabdd3cba58e..d6d189b9a996 100644
> --- a/Documentation/core-api/mm-api.rst
> +++ b/Documentation/core-api/mm-api.rst
> @@ -117,7 +117,7 @@ More Memory Management Functions
>  .. #kernel-doc:: mm/hmm.c (build warnings)
>  .. kernel-doc:: mm/memremap.c
>  .. kernel-doc:: mm/hugetlb.c
> -.. kernel-doc:: mm/swap.c
> +.. kernel-doc:: mm/folio_lru.c
>  .. kernel-doc:: mm/memcontrol.c
>  .. #kernel-doc:: mm/memory-tiers.c (build warnings)
>  .. kernel-doc:: mm/shmem.c
> diff --git a/MAINTAINERS b/MAINTAINERS
> index e3ee97f5474e..6bd39e0afceb 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16900,7 +16900,7 @@ F:	Documentation/admin-guide/mm/multigen_lru.rst
>  F:	Documentation/mm/multigen_lru.rst
>  F:	include/linux/mm_inline.h
>  F:	include/linux/mmzone.h
> -F:	mm/swap.c
> +F:	mm/folio_lru.c
>  F:	mm/vmscan.c
>  F:	mm/workingset.c
>  
> @@ -17045,7 +17045,6 @@ F:	include/linux/swap.h
>  F:	include/linux/swapfile.h
>  F:	include/linux/swapops.h
>  F:	mm/page_io.c
> -F:	mm/swap.c
>  F:	mm/swap.h
>  F:	mm/swap_table.h
>  F:	mm/swap_state.c
> diff --git a/mm/Makefile b/mm/Makefile
> index eff9f9e7e061..5f712f9bbe73 100644
> --- a/mm/Makefile
> +++ b/mm/Makefile
> @@ -50,7 +50,7 @@ endif
>  
>  obj-y			:= filemap.o mempool.o oom_kill.o fadvise.o \
>  			   maccess.o page-writeback.o folio-compat.o \
> -			   readahead.o swap.o truncate.o vmscan.o shrinker.o \
> +			   readahead.o folio_lru.o truncate.o vmscan.o shrinker.o \
>  			   shmem.o util.o mmzone.o vmstat.o backing-dev.o \
>  			   mm_init.o percpu.o slab_common.o \
>  			   compaction.o show_mem.o \
> diff --git a/mm/swap.c b/mm/folio_lru.c
> similarity index 99%
> rename from mm/swap.c
> rename to mm/folio_lru.c
> index e4b3dadaa6dc..7dab6a544d94 100644
> --- a/mm/swap.c
> +++ b/mm/folio_lru.c
> @@ -1,6 +1,6 @@
>  // SPDX-License-Identifier: GPL-2.0-only
>  /*
> - *  linux/mm/swap.c
> + *  linux/mm/folio_lru.c
>   *
>   *  Copyright (C) 1991, 1992, 1993, 1994  Linus Torvalds
>   */
> 
> -- 
> 2.43.0
> 

