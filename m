Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 896A9606A883
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 16:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=A/HvHNNb
Received: by kanga.kvack.org (Postfix)
	id AC5506B00EF; Wed, 11 Nov 2026 11:05:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A76D26B05B0; Wed, 11 Nov 2026 11:05:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B3856B05B1; Wed, 11 Nov 2026 11:05:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 842506B00EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:05:20 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1BD1F1C32C7
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 16:05:20 +0000 (UTC)
X-FDA: 85423312800.10.9E524E6
Received: from mta1.migadu.com (out-198.mta1.migadu.com [95.215.58.198])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6E0DDC0003
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 16:05:17 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="A/HvHNNb";
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.198 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794413118;
	b=HTxCUcoYs7udl9L5jh4ZAyZcsVlEI19gSYHgrOHm1RmKr+z+nbDaAVtW5ZXcDoN8fc8pWJ
	5QlpslEp+95BwnQs+kTa3UM6LViRJdnTQy1w0BUzaWqKJQERKMq80Txk8grwxjYwKhuOAA
	LfWpEVBWgeMmLO5VruRp+CQMvfAi/kE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="A/HvHNNb";
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.198 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794413118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vgUyxZr3jp6uPGx0b4XwC4Qf9E1Vwd28NNkJ7vQnXkM=;
	b=1UUnytiD/kIXcOatqyXMFrpVsw1XhgcXeL6ctcqukBYIfzEygkr4YjlE+v5SYQE9V5i3ah
	lcGsMYIsvHIqcsyR1YUhRhp9TZ79fIcKnH13kPGpuxwGeIDZKK0vk9lit+4JjfM8zjt6aV
	UUgD7QrDIkw1OodyjVGaewT98tHeDYI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=xD34cqqqS4yDJ5ebssDBJAARql9kbmOvm4FiIbCzonk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794413115; v=1; x=1795017915;
 b=A/HvHNNbdOjTaGekBFwl0auDEmfjyI/oERlYqpLCxq6kwyrOJNeiEY1QVv2Q/MWMs+btH6am
 hn3R1nqNaB+CMH9cerFZ91zIrfpqkIdgG4tKd5k/5uEQ3d1EOm9ovzuAYPEyub4s+lrP5fyKMCI
 UypiNP6g7CTKUIlmZm4uLSlw=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id cdc56c3804abbbc3;
	Wed, 11 Nov 2026 16:05:14 +0000
X-Mizu-Trace-ID: cdc56c3804abbbc3
X-Migadu-Flow: FLOW_OUT
Date: Wed, 11 Nov 2026 08:05:08 -0800
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Runli <mingyu.he@shopee.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Yosry Ahmed <yosry@kernel.org>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, littleswimmingwhale@gmail.com
Subject: Re: [PATCH v2] mm/bpf: Always flush memcg stats when explicitly
 requested
Message-ID: <avSR4bHP2HX5-OQo@linux.dev>
References: <20261111071434.34547-1-mingyu.he@shopee.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261111071434.34547-1-mingyu.he@shopee.com>
X-Stat-Signature: d6nesrgicd9sxse8brh4zd5sy83u5y14
X-Rspamd-Queue-Id: 6E0DDC0003
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794413117-954784
X-HE-Meta: U2FsdGVkX18paFbhQjNhDvHxGkuk0IWTkNAn1HWcwcojqQuAqoPhJi4oqzQ69ETkMayauX1byb3pgk3Gb05C9HyVTjiHQnyH/4sEeKMRhnX4S8RaeLAWR0Dk+Le7y4GDW63c5nIaG8wT3T3BFHVzoqTT4jsLTe0/HWWa57abja/PorTR/Zye7U9a+EjDrJGCjILRWnryFVtgtj6Xl5FAXwXIVSIP4s78PRpib0e+R+c5uAmtE3j7jg+y3ueGYVgV4atkCLwvhn2Mfu9rmkUSMGPjN7oO5bYA20z9u5ggMCVtFjBYDnqXyynJETUVHTHGqoY8f3WllTYxhI9x+lGhdOYRgx2jj93pEXTZZBCubr/glu6P6yw4TNd8hpe1oElJPbiqtBodYcnvXye9P6vCNw8prh59F+V6xxPwIdiybGJYK/4+oEX9BDIriEI1z1V0CKNV7RdX+NRROQOPyXht+ZMgPosXOgF9t1YMBrll2uPftbyUtvtwtfNlhAUv5qUCAoBGR9jMEe6gZ0do1pyItgfFmZGn8j94SLrj0V7Yz47LA55OPa/Ej3p+XYepFYg1Ywi6rTBRvSJW8Z8FqP8thvsUVP9ExWf4BQFIdeEOG1dlUbwSUOhIxwMtGSP4i0srtnMFP7AXx8ROS1Tfb6sTPPoCzqvhHiGWUoB5OwzTKhvrTiPnKxDoWZ7vQtQMDU8opGPrmJkWTQWtulas32hBeFzJy0japOO2+t5AwCOxuz2bg9lAc1xRzBxvgcWYdqyx+bP+OB9StwiVVXyKktS9Xyv6AlfTWnP5TiNJRHYWZZvcqKR9mXKrMyVR661Kx1xMg8xVAzjyX6CPzYUB1lj7Olte8phDZik2CPdnQLHjHJUKQLBTJyzj676s9uZDYWNwC4K8T63LmOmvWfZrI7xAEpPh8yS3muePqc/RYIytsZy9aSpIukmfk2bf+qso6CwcOEQ1lmLDPeKTzlxoHhg
 My0XoMd8
 uS2cBjSpwx9Af78jHSsSbfBNRtNRPdnmqq/pVUty/xykYScik2eEllgkiEkYI+bmwGVPCwYHmPchsQFjNvsGoycRuprK99+jaiYG+q5n214hK5E6lVEKDffapa8DgCy54aRBoU3T55eBM5f82Res+jBnGxP4UWGpznWKJpsvTYUIfRzrZwNrq9gbfHmsVuM7wMuOounn+UvmjtulwcqpzWHa57N4NjM1BMnuqttcFx3LSi86yFRGU7R02qX9qrCukHsBHbl5Eh+0v3CXZwLyzE6IZVY26/3iRRhhZrS4jo6GvnurgayiJur+rgPVCD+sRSEwYJEd9VM/ATBbn0n+JonN4kfr4eLw4yETY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 03:14:34PM +0800, Runli wrote:
> memcg_rstat_updated() stops walking the ancestors when a memcg exceeds
> the flush threshold. A concurrent flush can leave an ancestor below the
> threshold, so the early exit prevents it from receiving further updates.
> 
> Consider root and leaf on a 4-CPU system, with a threshold of 256.
> CPU 0 is flushing another CPU's stats after CPU 1's stats have already
> been flushed. The counts below are shared stats_updates counters:
> 
>   CPU 0 (root flush)                CPU 1 (leaf updates)
>   ------------------               --------------------
>   clear leaf->stats_updates
>                                    add 64 to leaf and root
>   clear root->stats_updates
>   finish flush
>                                    leaf = 64, root = 0
>                                    4 more batches of 64:
>                                      leaf = 320, root = 256
>                                    next update:
>                                      leaf > threshold
>                                      break; root is not updated
> 
> Root remains at the threshold, which is insufficient to trigger a flush,
> while further leaf updates keep taking the early exit. The periodic
> forced flush restores progress, but until then the root's aggregated
> statistics can fall far behind. For example, page cache grows at rate of
> 1 GiB/s, a two-second wait can leave the reported usage about 2 GiB below
> the actual usage.
> 
> Make bpf_mem_cgroup_flush_stats() bypass the update threshold so BPF
> callers can explicitly flush stale statistics without waiting for the
> periodic flush.
> 
> Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
> Link: https://lore.kernel.org/all/avKy9oMwDRjKjfzm@linux.dev/
> Signed-off-by: Runli <mingyu.he@shopee.com>
> ---
> Changes since v1:
> - Make the BPF kfunc flush unconditionally, as suggested by Shakeel.
> - Leave memcg_rstat_updated() unchanged.
> 
> v1: https://lore.kernel.org/all/20260911032905.63683-1-mingyu.he@shopee.com/
> 
>  mm/bpf_memcontrol.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
> index d8f579c28560..f8552651b6d6 100644
> --- a/mm/bpf_memcontrol.c
> +++ b/mm/bpf_memcontrol.c
> @@ -7,6 +7,7 @@
>  
>  #include <linux/memcontrol.h>
>  #include <linux/bpf.h>
> +#include <linux/cgroup.h>
>  
>  #include "internal.h"
>  
> @@ -154,11 +155,12 @@ __bpf_kfunc unsigned long bpf_mem_cgroup_page_state(struct mem_cgroup *memcg, in
>   * bpf_mem_cgroup_flush_stats - Flush memory cgroup's statistics
>   * @memcg: memory cgroup
>   *
> - * Propagate memory cgroup's statistics up the cgroup tree.
> + * Flush the memory cgroup subtree and propagate its statistics up the cgroup
> + * tree, regardless of the number of pending updates.
>   */
>  __bpf_kfunc void bpf_mem_cgroup_flush_stats(struct mem_cgroup *memcg)
>  {
> -	mem_cgroup_flush_stats(memcg);
> +	css_rstat_flush(&memcg->css);

Please expose mem_cgroup_flush_stats_force(memcg) which call
__mem_cgroup_flush_stats(memcg, true) or something like that. We have some
bookkeeping in __mem_cgroup_flush_stats() which we should not skip.

>  }
>  
>  /**
> -- 
> 2.39.2 (Apple Git-143)
> 

