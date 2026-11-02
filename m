Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAF60606A324
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 01:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=EIUPFzWs
Received: by kanga.kvack.org (Postfix)
	id BBBB36B00EF; Sun,  1 Nov 2026 20:37:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6C3B6B05B1; Sun,  1 Nov 2026 20:37:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A34D06B05B2; Sun,  1 Nov 2026 20:37:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 774306B00EF
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 20:37:14 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C35E11A0BFF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 01:37:13 +0000 (UTC)
X-FDA: 85388465946.20.29D5289
Received: from mta0.migadu.com (out-154.mta0.migadu.com [91.218.175.154])
	by imf31.hostedemail.com (Postfix) with ESMTP id B41CF20002
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 01:37:12 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EIUPFzWs;
	spf=pass (imf31.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.154 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793583432;
	b=zzYPbQsfVHNaEskJKXUZ9aCaoznxWcGwSD/hjxqi3zh34EvPKF/nBIKked8T4QQ6aH25kU
	g8/7imqKsa7+vLP8bJQgfY+a+oRSbXC16sJQSLF8Sxmv8b0nNppFkMEuS3rr4JgJgHLPpH
	0IxUshL1X5PqTFpvWy5EjGDW6rCU4cI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EIUPFzWs;
	spf=pass (imf31.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.154 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793583432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=60rYsd/AjRckt1lyvYj4vtHp2+NMHTUyTXpQRwJ1gH8=;
	b=oWcwgiICYzyhcyAyYmyUPo1vNa0NQOPCHjiaQyTdfqCsE5SLHvEOAAAqeaPjlbW17GwayA
	nbV0jM1/uB4nEXEcMT0zRdqpGDAL/bDiTu9ZQfDc4uV02mrHWeUzsG8JWoswKmwrHyriqx
	AuG/PsfBw2ueWVD0TRrDp2glDFvOmjk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=mF5HCW1rYzYU+/byn7lpiTMdUmKESV7ryiW//mc/fP0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793583429; v=1; x=1794188229;
 b=EIUPFzWsp6gKLfS2+RhRYiXCqrdqUabhe/sOw3lewqSPsFfLEKGo9dyTZGA7Fc4FdWkDngVW
 uOkrdFdJBaFlmqIFKOqBFznjvBuCiH2Cw7P/jUJ9wqaqdfkQFktp6gO2FhQKyvT23ovTOEAd0zB
 cctPkGPMsGXw39Hy7JgaCc8I=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 7b95e43db45818e8;
	Mon, 02 Nov 2026 01:37:09 +0000
X-Mizu-Trace-ID: 7b95e43db45818e8
X-Migadu-Flow: FLOW_OUT
Date: Mon, 2 Nov 2026 09:37:05 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Dave Chinner <david@fromorbit.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
	Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org,
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>,
	"open list:BPF [MISC]:Keyword:(?:b|_)bpf(?:b|_)" <bpf@vger.kernel.org>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH v5 2/6] mm/vmscan: move vmscan tracepoints to a local
 header
Message-ID: <aufpQS0XL-CD9YW_@bogon>
References: <20261031090041.58574-1-ridong.chen@linux.dev>
 <20261031090041.58574-3-ridong.chen@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261031090041.58574-3-ridong.chen@linux.dev>
X-Stat-Signature: o8n674yf7xo3qc39s534hsc3uxm8xs58
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B41CF20002
X-Rspam-User: 
X-HE-Tag: 1793583432-650252
X-HE-Meta: U2FsdGVkX19ohSk4sTssLYHZWTg6Z7kYL5WVOgiUNNSCurMH4TctrvfxcasUmohcJ7lAVOJuQdOjTcd02+CrpwZ+b2II7myY81/YgQHu3A6gwuhk1CUTEl2OsLgn3eJ3nyvwIM2kFuxztLYriDPyrMDN/NsurL36/9qQAeeSqGpe5u5zgr+PVDCAQmW4nfbCavBeIvLKCaVLW1OhsxNTO3SbWLry8KAeq+okE/9uzj1N01h+VrqphxH3j46qWN9sdspvojSLNIkFzqNaXyT/8+bo5UfGBi0geMjHv7yEYCQYljrZrJCvSuRLzq7BhumbZ0Uu8FsDjJgrEmIXaBGzPAyo9wII0PZaoRUzMnZSroHGcfRU7ZX0I5Bay0jhaFRPdYMQZlAAlxF0WzxjpPux31axQO3CqWBD7CZN5kZJQn2DfcftPirqBlGKm3WV1RFC/51/bkhFIocQVdJahoDuOLy8dbCdzlNH5JpirL1T2LekU6HaI06dUsqrXAVXLe4uFgCMPZqteUR3BdYUHR2rglv+9Xo+pZ7zffT2P7+IGKZ0oaTjcvgReP6Ccthj41yh+wT+j02GqjOwWUhX4FpNbPkXi/DFBNPjGCxK1gt7jVKFJfVHOv+XjTmbwbneMqHA2A+9CYG6QUEEG8bX56Zce9owsgyj7znIE7Xp/4I4t8fTTNn1zuwi6t0UBqflUx3N/bSjfDgk+9Gi3Y1lUSS3vxyYUoBym0V3W8xZSz628ejkV2AeyRXbFkDk5044BAqKAHeQUy5yW4isdt9f17A9Th3nXkJNdmCm+LIeLCab3jaUWv0yhTZVS6+o7Lq1UogAAveU61iUN8qYnsSfC+oBl/SR6DMfyJkVqIePlHbtovTwQ+nh4EyC0SkBn/moL68ucfFAb6wbu0TxGN6SwNRmwgzS1m5ipUdT3eK1ouS6T6Drd5ozVKaAw7U0GgOQqVYVh+S0q1Z/awlxUnEYDgs
 j7WQkZ/y
 APW/RVDQZ81STsnZRl6D4Uz4dUH873vu9YtM+P4NXTeToHIHHFQEMdnjsp5c3Z8d0uI2JL24TG4JFoFH1ENRsjgVxuycWFno3GiZJO35U5D+/D1dIvUZVO5LsHMVPrlMhSj2aIUkS08D0Bw5BxTLi3c23r2wS3nSZBdhi7hUe8qEkK3Oxw+ky+X92Mf9+FxIGGDxfW3IsXeUpk1vOnEDBqKAAz2BNK/PIwlrJSPvlEP9jgIKuWMnty0vo3kPFsq7x5OmsH1RKACvXgpKGhcqOfhgOnzizHZAlo2a0IGrdY4IhB6nimWTt08v9TkDhEf02NhqQPX6QGQi0SzVF9WUSy63ZubI03JeTwf2jTysrmFSRCFmdUoiNgcd1bQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/31/26 at 05:00pm, Ridong Chen wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> Move include/trace/events/vmscan.h to mm/trace_vmscan.h so that the
> tracepoints can be extended to reference vmscan-internal structures such
> as struct scan_control, which is not visible outside mm/.  This mirrors
> what several other subsystems already do with their trace headers (e.g.
> fs/fuse/fuse_trace.h, fs/gfs2/trace_gfs2.h, fs/lockd/trace.h).  As they
> do, set TRACE_INCLUDE_PATH to "." and add mm/ to the include path of
> vmscan.o, the only user that defines CREATE_TRACE_POINTS.
> 
> No functional change.
> 
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> Reviewed-by: Barry Song <baohua@kernel.org>
> ---
>  MAINTAINERS                                        | 2 ++
>  mm/Makefile                                        | 1 +
>  mm/shrinker.c                                      | 2 +-
>  include/trace/events/vmscan.h => mm/trace_vmscan.h | 4 ++++
>  mm/vmscan.c                                        | 2 +-
>  5 files changed, 9 insertions(+), 2 deletions(-)
>  rename include/trace/events/vmscan.h => mm/trace_vmscan.h (99%)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index aaf2825ac945..2ad01107fa05 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17653,6 +17653,7 @@ F:	Documentation/admin-guide/mm/multigen_lru.rst
>  F:	Documentation/mm/multigen_lru.rst
>  F:	include/linux/mm_inline.h
>  F:	include/linux/mmzone.h
> +F:	mm/trace_vmscan.h
>  F:	mm/vmscan.c
>  F:	mm/workingset.c
>  
> @@ -17802,6 +17803,7 @@ R:	Shakeel Butt <shakeel.butt@linux.dev>
>  R:	Lorenzo Stoakes <ljs@kernel.org>
>  L:	linux-mm@kvack.org
>  S:	Maintained
> +F:	mm/trace_vmscan.h
>  F:	mm/vmscan.c
>  F:	mm/workingset.c
>  
> diff --git a/mm/Makefile b/mm/Makefile
> index 2a3ec53d62ee..277b97f7f8d7 100644
> --- a/mm/Makefile
> +++ b/mm/Makefile
> @@ -32,6 +32,7 @@ KCOV_INSTRUMENT_vmstat.o := n
>  KCOV_INSTRUMENT_failslab.o := n
>  
>  CFLAGS_init-mm.o += -Wno-override-init
> +CFLAGS_vmscan.o += -I$(src)

One nit:

Does it really need the above line? It affects mm/shrinker.c too, did your
shrinker.o building fail?

Seems it's redundant because kbuild adds -I$(src) -I$(obj) for every object
in the directory since commit cdd750bfb1f7 ("kbuild: remove 'addtree' and
'flags' magic for header search paths"). Please correct me if I am
wrong.

Other than the nit, this patch looks good to me,

Reviewed-by: Baoquan He <baoquan.he@linux.dev>

Thanks.
>  
>  mmu-y			:= nommu.o
>  mmu-$(CONFIG_MMU)	:= highmem.o memory.o mincore.o \
> diff --git a/mm/shrinker.c b/mm/shrinker.c
> index 4fb424e721bc..4fbdade6d2f6 100644
> --- a/mm/shrinker.c
> +++ b/mm/shrinker.c
> @@ -3,7 +3,7 @@
>  #include <linux/rwsem.h>
>  #include <linux/shrinker.h>
>  #include <linux/rculist.h>
> -#include <trace/events/vmscan.h>
> +#include "trace_vmscan.h"
>  
>  #include "internal.h"
>  
> diff --git a/include/trace/events/vmscan.h b/mm/trace_vmscan.h
> similarity index 99%
> rename from include/trace/events/vmscan.h
> rename to mm/trace_vmscan.h
> index 8a872990b4be..ad90f0e9bf2e 100644
> --- a/include/trace/events/vmscan.h
> +++ b/mm/trace_vmscan.h
> @@ -648,4 +648,8 @@ TRACE_EVENT(mm_vmscan_kswapd_clear_hopeless,
>  #endif /* _TRACE_VMSCAN_H */
>  
>  /* This part must be outside protection */
> +#undef TRACE_INCLUDE_FILE
> +#undef TRACE_INCLUDE_PATH
> +#define TRACE_INCLUDE_PATH .
> +#define TRACE_INCLUDE_FILE trace_vmscan
>  #include <trace/define_trace.h>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 9959ca158ce8..79d2d614afd0 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -71,7 +71,7 @@
>  #include "swap.h"
>  
>  #define CREATE_TRACE_POINTS
> -#include <trace/events/vmscan.h>
> +#include "trace_vmscan.h"
>  
>  struct scan_control {
>  	/* How many pages shrink_list() should reclaim */
> -- 
> 2.43.0
> 

