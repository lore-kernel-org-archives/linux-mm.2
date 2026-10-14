Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE2FCCC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 16:49:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E28C6B0088; Wed, 14 Oct 2026 12:49:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8934B6B008A; Wed, 14 Oct 2026 12:49:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A91D6B008C; Wed, 14 Oct 2026 12:49:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 549A66B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 12:49:23 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E5AFE40697
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 16:49:22 +0000 (UTC)
X-FDA: 85321817364.12.D2B4E43
Received: from relay.hostedemail.com (unirelay09 [10.200.18.72])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2FD5A180004
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 16:49:21 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791996561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a+jcCItmaVXvg0z3J5thFi2DsdWgCqN1j0EvdcEpj+w=;
	b=nTsRpsbGOdpkUFhOTaS6l4Hg8YuRp6FLPS3lQIr/jyRM8UvXZ+aMSOp+DWroKgZZkeL4pJ
	4UKAe9bLBwks6PQK/NVBOA4Lnww/zIQd7njZrGeqDIXj+FuOb8dYJRYki9dV/pZh1scJk0
	3AqGCHFelcbPK3mINIbRhRTYJc5o78g=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791996561;
	b=kVqnXjPbvxZTDFA9yxG5nZoh5Ly/8XkKb3IQBTMu4FdVXWxCjROAx3Xb2fXaA8fT73JOk5
	dO6Pbn+fapxgLj4Pnr3YHPwELUKwxzHCftu+J1NMkcz2NLarcR3HbvU4YKpw6kN/TdjEPJ
	IIZ3wQosBxeKPZ70fW+XfzsGktkBXwA=
Received: from omf03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 02FCF8066A;
	Wed, 14 Oct 2026 16:49:17 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf03.hostedemail.com (Postfix) with ESMTPA id AE89A6000A;
	Wed, 14 Oct 2026 16:49:12 +0000 (UTC)
Date: Wed, 14 Oct 2026 12:49:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Masami Hiramatsu <mhiramat@kernel.org>, Johannes Weiner
 <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin
 <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Andrew
 Morton <akpm@linux-foundation.org>, Dave Chinner <david@fromorbit.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Muchun Song
 <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, David Hildenbrand
 <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Kairui Song
 <kasong@tencent.com>, Barry Song <baohua@kernel.org>, Axel Rasmussen
 <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu
 <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, cgroups@vger.kernel.org (open
 list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
 linux-mm@kvack.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER
 (MEMCG)), bpf@vger.kernel.org (open list:BPF
 [MISC]:Keyword:(?:\b|_)bpf(?:\b|_)), Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH RFC v3 2/7] mm/vmscan: move vmscan tracepoints to a
 local header
Message-ID: <20261014124914.21c21559@gandalf.local.home>
In-Reply-To: <20261013131309.2790253-3-ridong.chen@linux.dev>
References: <20261013131309.2790253-1-ridong.chen@linux.dev>
	<20261013131309.2790253-3-ridong.chen@linux.dev>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+2sabA8ApyQWp0KnP/HFLarVznZroqxp8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=goodmis.org; h=date:from:to:cc:subject:message-id:in-reply-to:references:mime-version:content-type:content-transfer-encoding; s=dkim1; bh=a+jcCItmaVXvg0z3J5thFi2DsdWgCqN1j0EvdcEpj+w=; b=ZDjXae7yuY6daMhM/4jUFORVKfWrh7M3m7I1np8JJtIWO0CX68GmjeT7EEVC1ueFMeDDVtX+N0muCfk5WRWHbSgc3XbOFNIkK4Nj34ba3mrfYqHMKXppwgYEcaSgfHzFG3iN+YEgpe7FhA3ei48+cNoN4yD25t67Ejic1h5NyCw=
X-HE-Meta: U2FsdGVkX19WVIU50DbwQWQ1335aLD0DaAIUgIjNIvQ8PuHEzItAimjZ4jWFcbqXC2uQEeUl7OKKLjZZpqhlsOaTbjlt0g5JFPmtMPCLWd9sgUdQcyxnOwQ9CrJywM/QBRoqk8hbQOdJ5cDAQ38RYSlBz42nBJ9pNyLbe1tCYpApGPKp22Oa2OjUc3CRjYiV0EMElzxmGb+AOBSJE1PpBYmHO62axI0wg8DN/AGB2Fz/pcSXsN9QshQLIDo4IsZLu842OjTboQLK+3/GThFKibADAVexEZE1mMy7lMzdC84/ITa6ABJ7EBW9GFfPexV4kY5mT03a2mPMNhzIeu716uT2F3rGLy6OzmbqiER2EFUx9vVE/uNHHDyOU4TQUvYUCeaVChZwsFA4sPdaMEuwILWLuKMZRRdliS2SdjRcvmM=
X-Rspamd-Queue-Id: 2FD5A180004
X-Stat-Signature: 6kz9db3yhzmgrw4349ydsqrsys6bxenp
X-Rspam-User: 
X-HE-Tag-Orig: 1791996552-398790
X-Rspamd-Server: rspam08
X-HE-Tag: 1791996561-566831
X-HE-Meta: U2FsdGVkX1/SMqjlzECiFMbEGI2hxNUbuJIaRAg8ZV7lg/uOBVzjSCcOOm0e97cTlPwhRVpD/myKbJZkHacdc5K5wEfEtiMTlncZF3ETC+ks3XPatoH2U0S8l+xoU4pvqi2vfTSTIIIlQjeeE5KvObBPsFFPnxiIeFSXzWapfydy2LAhqnw5zhj8cLJ1dcaRYng+3ojr7l9fx46VfFa9n+oYRgtFx7FQYcCy1fHyXpXJ+I0chNfbgh5SyUQMoFnAwm6rjbgNS0E8wYBDrZkoFvpgOJh3s2QD/GSZoBPYyzfxBpGFk/h7bfXXlcD4eCcfcGXqf6jBOpvMKOl2vPreOXxlinYJDkC/G/liDYFtGLH7tfh9YOudCdFn/RZtckHxZmSofiGYd77bnqtrH4xSLljCboyXu4aAIWuowkqZOpzv/rD9IqiHYhUA95R1Vkm46MtOVCJrowIqFVh44eYlFNvFA/04aiiHz1FCzJEIk4DpMS+PJ9fRztgCqCBIKPW4lNfSQjYkMuyEmCWUkyLWROar+2hzHNBmgl2UMzy6N/+5r3/+uE2V6E+w35oXqH0mYIvJxwoG6/KHpyQJLz+/TAFr27X3YicQ7n4vSRVp9W3xOYf4uFRzj2qT5HnQZfqQr/xoJTLQbFeJuwUzYzGKnXPh1Tkl7gzKtlg1OdBF7IdY9zOMzGvj+hmWcHRWX/DW5MPYSqdxkVpXiq6dbTDDV/12MMYtMUTD8GtiASr+5rlZ1VYvTyL0u/zyipG/1bWpnZEb8rPBGOCMXzfHiS9VlMiC5GGV9Sh07tkC9kmwvIGrqNCNc+JXkqzufG5yV/sJTI9ML7/UYjZjz7Vu3yuPh1hdh8pxz/o+0P9XWAIAYepir/lRNMgJqFcosshBeZ1STN8UXmXtYwhSVo4itsr5Mw8CqFkL6W/FmJLUbldj0RBSxZ1ECupB8W4CJ4yMrMVm405HG+aRB89PXP3d6Mu
 WZLhtCfz
 1GWHOtc8IiepMR40Mjv9S88jEG3bxzd1ZfkFrQ25iDoJp92abIR5TbGjJS/DmOA9jNXBlzkdQnCkk+ufWZbRKSc2JTo2i+H7eBhorvt/fJ7/8r0lXotvvVLwvndPKsHrkfZjr1utDLS2ULHd3/Hv0UKxovnUAeD1FwjDzqXhQEMS3vkClRM9+wnVuMLEssJxGV5iJ2l8xS3gqzM/VsKtCLrynC+5rN6oHiyDw0wA+5wfcbVTjeuVBVVdBx+rrZ/SxwGaaskKUvfKFLks/xW0rHF8PjEsx5QiRx8Iuzoez0jPXJZdnuLphRYOIFPInyJlm4SxPJTMoEtXusRqMxaSQtameIWJm6iOtG7FG3KLL6kRQUO+814MBXtc7EmH+wO8RZjIShTRMa8bA+0tC91AtYUtiTXNZ/jUnC4TIBoUJ0KsrbOXBGOrPee/fd+N9mKqw5n0EUDHIL9CLECJ4Wc3pZRF5PqnecAXsd3Ba4eNDxquXtNV1x7o8wh1gQnXSZe+8XC/IUAudmaeGjY9D2slDl+Sy6lcW3f6eufomfmHvkys/gpUdg/7rdkUXhLOPg2/Qn9lp04lQg3TFKRdW5Ytyicyw6r8n6p1pjMEfOBtTvNvxAWPAYC2r0iExKxVuoT7ZsU3+vL4AvxcHjV77xU5EZAIxozupUJ+znka1fxrkHk63ASToY1UC0MQPlO98LJNEDz5CoFR+awAY3+dEG2oUzKilZbjRHCl1hibaW1Nez3bGx8tScu4OCBWW5+iJcyhhEK59sU6M28hHwhmGX2CPOjo6JIvSzd3nkYvbRFAGs3WWkJEoibX/rGfGuF4VVTPZHj1r+pr8WJkJilVJPTi+Aae5pukehtZiCSeK5OifzbABzdUBQPLTBuioPgGgMoWHn8RBUZ5GR3i62bmc1yoHSqLhYadA7Xz5N242
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 13 Oct 2026 21:13:04 +0800
Ridong Chen <ridong.chen@linux.dev> wrote:

> From: Ridong Chen <chenridong@xiaomi.com>
> 
> Move include/trace/events/vmscan.h to mm/trace_vmscan.h so that the
> tracepoints can be extended to reference vmscan-internal structures such
> as struct scan_control, which is not visible outside mm/.  This mirrors
> what several other subsystems already do with their trace headers (e.g.
> arch/x86/kvm/trace.h, drivers/gpu/drm/drm_trace.h, net/xfrm/trace_iptfs.h).
> As they do, use a relative TRACE_INCLUDE_PATH so that no Makefile change
> is needed.
> 
> No functional change.
> 
> Assisted-by: LLM
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---
>  MAINTAINERS                                        | 2 ++
>  mm/shrinker.c                                      | 2 +-
>  include/trace/events/vmscan.h => mm/trace_vmscan.h | 4 ++++
>  mm/vmscan.c                                        | 2 +-
>  4 files changed, 8 insertions(+), 2 deletions(-)
>  rename include/trace/events/vmscan.h => mm/trace_vmscan.h (99%)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index c5519d67b6f4..80d2a9dd0525 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17575,6 +17575,7 @@ F:	Documentation/admin-guide/mm/multigen_lru.rst
>  F:	Documentation/mm/multigen_lru.rst
>  F:	include/linux/mm_inline.h
>  F:	include/linux/mmzone.h
> +F:	mm/trace_vmscan.h
>  F:	mm/vmscan.c
>  F:	mm/workingset.c
>  
> @@ -17722,6 +17723,7 @@ R:	Shakeel Butt <shakeel.butt@linux.dev>
>  R:	Lorenzo Stoakes <ljs@kernel.org>
>  L:	linux-mm@kvack.org
>  S:	Maintained
> +F:	mm/trace_vmscan.h
>  F:	mm/vmscan.c
>  F:	mm/workingset.c
>  
> diff --git a/mm/shrinker.c b/mm/shrinker.c
> index 7ec2a9704f6f..3c3e87c4b61c 100644
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
> index 8a872990b4be..c5d824fef554 100644
> --- a/include/trace/events/vmscan.h
> +++ b/mm/trace_vmscan.h
> @@ -648,4 +648,8 @@ TRACE_EVENT(mm_vmscan_kswapd_clear_hopeless,
>  #endif /* _TRACE_VMSCAN_H */
>  
>  /* This part must be outside protection */
> +#undef TRACE_INCLUDE_FILE
> +#undef TRACE_INCLUDE_PATH
> +#define TRACE_INCLUDE_PATH ../../mm

The proper way to do this is to have:

#define TRACE_INCLUDE_PATH .

And update the Makefile with:

CFLAGS_vmscan.o := -I$(src)

-- Steve



> +#define TRACE_INCLUDE_FILE trace_vmscan
>  #include <trace/define_trace.h>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 29b31446fc11..6207dad9e644 100644
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


