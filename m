Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C2BBCCF2DA
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 06:21:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4661C6B00B6; Mon, 19 Oct 2026 02:21:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 416476B00B8; Mon, 19 Oct 2026 02:21:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32D436B00BA; Mon, 19 Oct 2026 02:21:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EB1FC6B00B6
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 02:21:56 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5CD3B1A021C
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 06:21:54 +0000 (UTC)
X-FDA: 85338380148.21.1C22AEA
Received: from mta1.migadu.com (out-82.mta1.migadu.com [95.215.58.82])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2D4EF40006
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 06:21:51 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PZeCpItu;
	spf=pass (imf17.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.82 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792390912;
	b=ZLe0TOvR2bDqSPviXqwyQY1tZMMDzWN5dClhDof7kReBv457lIH62YZKNfuxsDx23FcZyZ
	t17Gr/GoTo7C8zg6bQtdnXgXcUIB6NynCRi3DAq2oSSOGL5wNSSepDdfPcxVsjZG4OAZZa
	O0IgiH92BzzBnQ/8rHkcgkBnbo4TXxI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PZeCpItu;
	spf=pass (imf17.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.82 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792390912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tb1CVDb/qtCe1N0t8PpStFV2JA8h8qEFpJDkLU3BfdU=;
	b=sTTf3hAFl/gpTVFmUBnEUqNtWEnQYEi6yYlWIJn5QPqjhey8ZlRrVVbtwfXzI0HA/2hv2b
	FAVUIgqj9PWptEyRzwtn2u/puRu/PsDkVyNDcYfWeWX+7jEbPgJwjCD13eRM/R0dFG6XeI
	QARS9NV/61E0W5/T6m0OYeXMNcVXuhk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=I4MPMNFIXchxrDocrBAZUC2FdxNIMi1x4SFGsuGksro=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792390910; v=1; x=1792995710;
 b=PZeCpItuM79ocVG/ZTKd6RwQdP6Tps/2lRzSJ7JAm/RXajDfEmBbX5mBR0tlLaddhCmUpcII
 OaeqLlQjikHo8sJ5ktuQokskT7UgL5xw6Bf3VsI72r63+AKezog8THBAEXn1lyAJCziDW3pdtwC
 JFs3wFclqUiEoZAFKlmzI0mc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ab907ebe85d37efd;
	Mon, 19 Oct 2026 06:21:50 +0000
X-Mizu-Trace-ID: ab907ebe85d37efd
X-Migadu-Flow: FLOW_OUT
Message-ID: <8ed89bac-d9f0-4dba-b733-7d678a4b47ac@linux.dev>
Date: Mon, 19 Oct 2026 14:21:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] mm/mglru: add tracepoints for scan and aging paths
To: Steven Rostedt <rostedt@goodmis.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Baoquan He <baoquan.he@linux.dev>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, David Hildenbrand <david@kernel.org>,
 Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 "open list:MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)" <linux-mm@kvack.org>,
 Ridong Chen <chenridong@xiaomi.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Masami Hiramatsu <mhiramat@kernel.org>
References: <20260911102939.2485750-1-ridong.chen@linux.dev>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260911102939.2485750-1-ridong.chen@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2D4EF40006
X-Rspam-User: 
X-Stat-Signature: mggege3w6pny8xfsmzjcwunhqqk31tu6
X-HE-Tag: 1792390911-427379
X-HE-Meta: U2FsdGVkX1+xrwTRxr9sEs00shxcaTgYZERl0M8AdToePjHD1Fdrj14MKSZWyAAmLlD8RCBduZLwEBf0HJ1QYyT7BqboQdjh4Ck4Am6WSM92po/MHiiWqHfBy+NUJt8mBGZzvSfcxGRmoYGO2xBlNvyVCkUCBjYMEjcoQtitbcGMSMr3P1XNQd8c33wLx/eCng6dvg7HauMvaS5RqWbu4xT/v3IqF3lQrOomcJX8RBFy+gkpmGNWuD7iYxUiaDe+xRWwN9emwSy2/njMqZx5Z2AqXs7cVLJ4q3BRwOob37k9v/rZ65RS3dxomrybpsmgF98cUOj00YsE4eLQ+NuWuQk+ZJpfVEZHtwPM/CFvIK9mJofGpfGpx87etMbORRgN08kbbr7aB0FxuQ9Z2kml9vRSsD83lhcVrsoML7a/oacuF/LnVhzXLPQbOo0vHNGAeWSbymgSDVT3ot9oYpLrw113q7KTYpK7bO1z28WUU58ajsmcmOtU0+spaaHvT9QVvT+hEDemdg/wAD7necOcRg3ybgD0+zLGtMkoTE0q0nYT8dSDj0Dqyi2jCjwgsReqQCR25wPC/lFjC6GZwupC3HSUdl1mlNvw3GoIUe1xCcBFIzH5wSV6KOqAy8bw0rXk8lRZoO6FDQJfniG5eJMlyuOosiWWPw0Vf1lK66AaO9N/rXamO/j984yhs/pcA3I4XGVVNpiqWqaxk9P2xfi6cYH6zG9JI0u4BMuCrrilfMz4SlQo0vD3x0+kgj5jJrZDzL0HaTVDrcs5YRCRl/InV1oZM4SUJ5ns/lND05prxRgYvyMUCa/s/yGkmDpJ1m3/OvxJ3bSc22DPhaSOzm1cfe0toXH4vFLT1A75Q34i7dTjpEvjzDW5NqZAHlBHkcrSry6J/CMeRsnW4tTmmxoACUjhTjjcTbLzTBm03AYrbXk0DYGGZfdYbLn6nXKY8vhxwBM6i47Ms80698IH9fa
 Ckz0U9pJ
 qOG6k64cTsIa9nKygwMbBDhAr1K3wz04WTU54xIIpMRb5hE0T991C3fcYERAVXEutyuo1Pxhp6bKJJxFOz5qmN34iz32nGkn7JibIWs1Fayy8YrOr7R0QiyNx1Htia74qbvxs6Qhja6TtNFs2eGeQ2HK9i+1n73m8c+1untikkccdK5Uojtce11ULEYeiCkjByMn8qBpGAxgd0IZegxP9WymiDYLyVu1JrT6xpIpuHvl75YRJLOBqB9p2tD3mfZYKY2GAmj1uiFPpdL/V6Uc2osa6f24iVojgWLVu0Dp4ic9Z+r7Rdn2iipCaDxwi0xMLsXFtd3MGI4RE+HHoWZC51J9xLeXEqPw5Inn6ITbZzeZLLrFg21P5j/Ed5/XuJ1IY7xnN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/11/2026 6:29 PM, Ridong Chen wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> Background
> ==========
> 
> MGLRU currently has no tracepoints of its own. The scan and evict paths
> reuse the classic-LRU tracepoints (trace_mm_vmscan_lru_isolate() and
> trace_mm_vmscan_lru_shrink_inactive()), which predate MGLRU and carry no
> generation, sequence, memcg or swappiness context. A trace of a running
> system therefore cannot tell which memcg a given scan belongs to, how far
> reclaim has progressed through the generations, or when a new generation
> is created - so how MGLRU actually operates is effectively invisible.
> 
> Implementation
> ==============
> 
> Patch 1 is a cleanup that factors the per-generation page-count
> summation into a helper, lru_gen_seq_nr_pages(), reused by patch 3.
> 
> Patch 2 adds mm_mglru_scan_folios on the scan path, and patch 3 adds
> mm_mglru_inc_max_seq on the aging path. Both carry the memcg id and the
> generation window (min_seq/max_seq), live at MGLRU-specific layers with
> no classic-LRU counterpart, and are guarded so the hot paths stay
> zero-cost when disabled.
> 
> Effect
> ======
> 
> Paired, the two tracepoints make the full aging-to-eviction window
> observable per memcg: aging advances max_seq (the leading edge), scanning
> consumes the oldest generations, and the min_seq/max_seq pair on each
> event shows how the generation window moves over time.
> 
> A sample trace, with the classic-LRU tracepoints left enabled to show
> how they interleave:
> 
>    mm_vmscan_lru_isolate: classzone=4 order=0 nr_requested=36 nr_scanned=31 nr_skipped=0 nr_taken=29 lru=inactive_file
>    mm_mglru_scan_folios: memcg_id=73 classzone=4 order=0 nr_requested=36 nr_scanned=31 nr_sorted=2 nr_skipped=0 nr_taken=29 lru=inactive_file max_seq=3 tier=3 min_seq=0
>    mm_vmscan_lru_shrink_inactive: nid=0 nr_scanned=31 nr_reclaimed=29 nr_dirty=0 nr_writeback=0 nr_congested=0 nr_immediate=0 nr_activate_anon=0 nr_activate_file=0 nr_ref_keep=0 nr_unmap_fail=0 priority=5 flags=RECLAIM_WB_FILE|RECLAIM_WB_ASYNC
>    mm_mglru_inc_max_seq: memcg_id=73 max_seq=4 anon_min_seq=1 file_min_seq=1 nr_anon={0x0,0x0,0x1,0x0} nr_file={0x0,0x427,0x6,0x4a}
>    mm_vmscan_lru_isolate: classzone=4 order=0 nr_requested=5 nr_scanned=5 nr_skipped=0 nr_taken=1 lru=inactive_file
>    mm_mglru_scan_folios: memcg_id=73 classzone=4 order=0 nr_requested=5 nr_scanned=5 nr_sorted=4 nr_skipped=0 nr_taken=1 lru=inactive_file max_seq=4 tier=3 min_seq=1
>    mm_vmscan_lru_shrink_inactive: nid=0 nr_scanned=5 nr_reclaimed=1 nr_dirty=0 nr_writeback=0 nr_congested=0 nr_immediate=0 nr_activate_anon=0 nr_activate_file=0 nr_ref_keep=0 nr_unmap_fail=0 priority=5 flags=RECLAIM_WB_FILE|RECLAIM_WB_ASYNC
> 
> The mm_mglru_scan_folios lines carry the memcg id and the generation
> window (max_seq/min_seq) that the bare mm_vmscan_lru_isolate lines above
> them cannot - those cannot even say which memcg they came from. The
> mm_mglru_inc_max_seq line then shows a new generation being created
> (max_seq 3 -> 4) with the per-generation page counts for both types.
> 
> ---
> v2: address Sashiko AI review [1] - pass struct lruvec * into the tracepoints
>      and do the memcg lookup inside TP_fast_assign.
> 
> [1] https://sashiko.dev/#/patchset/20260911072848.2346073-1-ridong.chen@linux.dev?part=2
> 
> Ridong Chen (3):
>    mm/mglru: factor out lru_gen_seq_nr_pages()
>    mm/mglru: add tracepoint for scan_folios()
>    mm/mglru: add tracepoint for inc_max_seq()
> 
>   include/trace/events/vmscan.h | 101 ++++++++++++++++++++++++++++++++++
>   mm/vmscan.c                   |  53 +++++++++++++++---
>   2 files changed, 146 insertions(+), 8 deletions(-)
> 

Hi Steven, Baolin and Baoquan,

Thanks again for reviewing v2.

Following Steven's suggestion in this thread, I first moved the vmscan
trace header under mm/ and exposed struct scan_control to it in a
separate RFC series. Patches [2/3] and [3/3] of v2 have now been
reworked on top of that and posted together with it as one series:

   [PATCH v4 0/9] mm/vmscan: move tracepoints to mm/ and add MGLRU
   tracepoints
   https://lore.kernel.org/all/20261019034426.2354049-1-ridong.chen@linux.dev/

The two MGLRU tracepoints are [8/9] and [9/9] there. Compared with v2:

- Both events now take only lruvec/sc plus the local counters, and
   derive everything else (memcg id, order, reclaim_idx, lru, max_seq,
   min_seq and the per-generation page counts) in TP_fast_assign()
   (Steven).
- Add nid, derived from lruvec_pgdat(lruvec) (Baoquan).
- Group the int fields at the end of the entry to avoid padding on
   64-bit (Steven).
- Drop v2 [1/3] "mm/mglru: factor out lru_gen_seq_nr_pages()": the
   per-generation page count is now summed inside TP_fast_assign(), so
   the helper has no user left.

Since [8/9] and [9/9] changed substantially, I did not carry over your
Reviewed-by tags. I would really appreciate it if you could take
another look at v4.

-- 
Best regards
Ridong


