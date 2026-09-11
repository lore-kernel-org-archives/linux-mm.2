Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A090C79FA1
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 07:29:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BD226B008A; Fri, 11 Sep 2026 03:29:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 983D46B008C; Fri, 11 Sep 2026 03:29:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 882566B0092; Fri, 11 Sep 2026 03:29:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 67C8A6B008A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 03:29:16 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AF020A237E
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 07:29:15 +0000 (UTC)
X-FDA: 85200655470.01.8FA735B
Received: from mta0.migadu.com (out-84.mta0.migadu.com [91.218.175.84])
	by imf28.hostedemail.com (Postfix) with ESMTP id D92FAC0002
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 07:29:11 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OBj9RCxo;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.84 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789111754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=55FaPJogk3b5rSuGfjGd50i74bl3MKNfMFEILKUbk0c=;
	b=ptsratlZ7/DbI0e/z87EwkPQz21kr/maafoIwUJpENhV2f+7gQy+eapdmcTSCTBUWbcu7H
	ejwGcSfiav0fCHDoEyYVo1/AdnpuUQNOxUtoQ+qOcwRiOi/NiZG2SISmzb/+9Qi3xAe75E
	8GnLkfuFFHrnPuiREoT7l7b5aNryYbQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789111754;
	b=1Dz4B9boM58WC7SDu9g80vuuPNdmLDk9L3rqvbEE/EDum9f93aPAOxzOWZ+6zC8Bw7X167
	4zfXkUSghCIjh4Q6g7QXDs+jH3xYHZhATH7FqmBexd8BIoRzuwN+jR2inmm5iPOGNS0JPC
	+Z9AJLS1C5S3QSfmql9HgWJDwCt+XEA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OBj9RCxo;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.84 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=dNMvSuQN0N4qCRyjVFInfr2Drz4mm/aQHqOjmNew14U=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789111748; v=1; x=1789716548;
 b=OBj9RCxoqVKw0/w5QkxywDIGP7RszP7PgftdaMu5VQTs+Ii+2a/tZEhAcebHwBlQUqZ4eCfn
 QONfz6O4tJGw3Gr1930RRjQ9kIWI6rK9N1OK0ZtkHAxmFeJXUnyzzpgiEkhg137iRmk0HmYXoOM
 XyZFq8Ez9xQFRx0BZjfc6To8=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 047fe7891b18b0a7;
	Fri, 11 Sep 2026 07:29:08 +0000
X-Mizu-Trace-ID: 047fe7891b18b0a7
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org (open list:MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)),
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH 0/3] mm/mglru: add tracepoints for scan and aging paths
Date: Fri, 11 Sep 2026 15:28:45 +0800
Message-Id: <20260911072848.2346073-1-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D92FAC0002
X-Stat-Signature: cwtxnthd3iw61b3c8ou8trwxhkeozxam
X-HE-Tag: 1789111751-364965
X-HE-Meta: U2FsdGVkX1+NvYPgtWNAcY4KmcZjeHkZ2prI0kWvGshw1A/QtR407Q8pP5/aW3+l0mhjnnzXjZ6SCUqsyGXB8pFFrG8btdDNZ/HgdY0LiiP/3puIvweZjDs2B/LDLqBZw14QXj/U2qCt4H7PFSJVq50s+sOBIX42phwsSgKsx0Ioiz9oWR5sml1FhEwJk4gslTYS+kSf6f8t8lXXqK6xifwq2a82fJWurqeP/CzyE2TNG3xZ0qUkWnOxWi/AWYb1oMheCjsE3QLoHUUTguF8Rg1m1pT2UhH0OCQMkqhbihMRPaiwSQEr7U4mE2BnEZ1S2PHzv6Uxu2n3uS4llz80TRCWUCzG/2znWiP1JfB/wHoBMR89kTutBB9mQ3wWVaLgghC2ICsft5WK/XHu0ljo9CB+bX1sF7TdhzvnPi69FYQ7tuL/kzorF4lRvJ59pfDchUhfo2tj1/IpUm7df1E+UjFPFQMTxRDcBWpxaaCJMpZxDK3b0OJCslRGvpa9L6aHllQMYXgXkhOurY+38Jhp8amgrsluMmw7oPqYVnpVK3ODkJEuJ/XblTdAYzsxkGEa5rt+uOS0eU7kPew5IMgpOAUEnWoCHkthKakeCzurJVORIt+wWm9h6qdg41GKI/4PWzOFegkM3eNxNiSTPDC/CIRLqOQrgyZNLipmr7Wjci0tN2FIUbARl28HVlX+fJHlE6my4TU+3VcOBgJQirqx1UAAKlMZLo0hPwZ3Wm/tPp8A3vuDcPpcgBQmf5rkoKKL2fGrVhdlZmQwq3hswnL0Mu8/8y5US0Vb1ysAagLoBc7VPzKGEqFzcJnxwObCSDix47f9GrdXJzC2XBWR61groK7X8NW3Qgo+U6wf2529ft6HDjeyfoqI8Pme8L7yAup3zbH04h/YVWzjs/SQUkQW3U/AhxKM5JuvA/euJkK7FklQBTPCD+9z62S4OpXptoob5W8LgN7UG3quVXu+3aD
 y78A9rOz
 W6XUu5jdoALp3X8rJ3NdcqQJDwPPtvTn+32b5N7h3JKLM820lhASOZrcql/5vtFASqOMHUey4ihgoFv0Y1Zx0dp/OPwj/UhE9bXfS2lBeV9lNqe5KXa/Z9r1Xo2SyYJYmr61UMP52szAPRY63TSD0RkXtD4tmHtZ1P7/372tl5nhCEq0hO7XzM0fJEIsmkECkuYAjQEx/Nys9qgI39R/Ty8GOUrkaAdzSLslfBl1jo+OCVO4M/ZrryyFzoyAbCNm7CFxK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

Background
==========

MGLRU currently has no tracepoints of its own. The scan and evict paths
reuse the classic-LRU tracepoints (trace_mm_vmscan_lru_isolate() and
trace_mm_vmscan_lru_shrink_inactive()), which predate MGLRU and carry no
generation, sequence, memcg or swappiness context. A trace of a running
system therefore cannot tell which memcg a given scan belongs to, how far
reclaim has progressed through the generations, or when a new generation
is created - so how MGLRU actually operates is effectively invisible.

Implementation
==============

Patch 1 is a cleanup that factors the per-generation page-count
summation into a helper, lru_gen_seq_nr_pages(), reused by patch 3.

Patch 2 adds mm_mglru_scan_folios on the scan path, and patch 3 adds
mm_mglru_inc_max_seq on the aging path. Both carry the memcg id and the
generation window (min_seq/max_seq), live at MGLRU-specific layers with
no classic-LRU counterpart, and are guarded so the hot paths stay
zero-cost when disabled.

Effect
======

Paired, the two tracepoints make the full aging-to-eviction window
observable per memcg: aging advances max_seq (the leading edge), scanning
consumes the oldest generations, and the min_seq/max_seq pair on each
event shows how the generation window moves over time.

A sample trace, with the classic-LRU tracepoints left enabled to show
how they interleave:

  mm_vmscan_lru_isolate: classzone=4 order=0 nr_requested=36 nr_scanned=31 nr_skipped=0 nr_taken=29 lru=inactive_file
  mm_mglru_scan_folios: memcg_id=73 classzone=4 order=0 nr_requested=36 nr_scanned=31 nr_sorted=2 nr_skipped=0 nr_taken=29 lru=inactive_file max_seq=3 tier=3 min_seq=0
  mm_vmscan_lru_shrink_inactive: nid=0 nr_scanned=31 nr_reclaimed=29 nr_dirty=0 nr_writeback=0 nr_congested=0 nr_immediate=0 nr_activate_anon=0 nr_activate_file=0 nr_ref_keep=0 nr_unmap_fail=0 priority=5 flags=RECLAIM_WB_FILE|RECLAIM_WB_ASYNC
  mm_mglru_inc_max_seq: memcg_id=73 max_seq=4 anon_min_seq=1 file_min_seq=1 nr_anon={0x0,0x0,0x1,0x0} nr_file={0x0,0x427,0x6,0x4a}
  mm_vmscan_lru_isolate: classzone=4 order=0 nr_requested=5 nr_scanned=5 nr_skipped=0 nr_taken=1 lru=inactive_file
  mm_mglru_scan_folios: memcg_id=73 classzone=4 order=0 nr_requested=5 nr_scanned=5 nr_sorted=4 nr_skipped=0 nr_taken=1 lru=inactive_file max_seq=4 tier=3 min_seq=1
  mm_vmscan_lru_shrink_inactive: nid=0 nr_scanned=5 nr_reclaimed=1 nr_dirty=0 nr_writeback=0 nr_congested=0 nr_immediate=0 nr_activate_anon=0 nr_activate_file=0 nr_ref_keep=0 nr_unmap_fail=0 priority=5 flags=RECLAIM_WB_FILE|RECLAIM_WB_ASYNC

The mm_mglru_scan_folios lines carry the memcg id and the generation
window (max_seq/min_seq) that the bare mm_vmscan_lru_isolate lines above
them cannot - those cannot even say which memcg they came from. The
mm_mglru_inc_max_seq line then shows a new generation being created
(max_seq 3 -> 4) with the per-generation page counts for both types.


Ridong Chen (3):
  mm/mglru: factor out lru_gen_seq_nr_pages()
  mm/mglru: add tracepoint for scan_folios()
  mm/mglru: add tracepoint for inc_max_seq()

 include/trace/events/vmscan.h | 101 ++++++++++++++++++++++++++++++++++
 mm/vmscan.c                   |  52 ++++++++++++++---
 2 files changed, 145 insertions(+), 8 deletions(-)

-- 
2.34.1


