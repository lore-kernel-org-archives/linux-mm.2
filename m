Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32341C88E4A
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 10:30:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A89F6B008A; Fri, 11 Sep 2026 06:30:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2599F6B008C; Fri, 11 Sep 2026 06:30:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16FB96B0093; Fri, 11 Sep 2026 06:30:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DFB8A6B008A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 06:30:07 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1E68C80188
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 10:30:07 +0000 (UTC)
X-FDA: 85201111254.07.9C1DD96
Received: from mta0.migadu.com (out-100.mta0.migadu.com [91.218.175.100])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0E26714000A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 10:30:01 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=auYVOSVU;
	spf=pass (imf26.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.100 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789122605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=BWfZItM/b7e30iSXxd0SAN97QAZ4T57n7WBdzViHl9U=;
	b=EiNZjTMk+SAPf90dBI1vmYpOxaoyPVQbAgAVvCrD+NbfT62o4LXHAePumwucrOMeP+/3FW
	uZEO7BvnqVhVvbRw1Vm0pnMVZg36kLEgLsPbGPOS8OskwLRBDBbDAHxhSMxLrtMiBVz5OW
	FtZHrildQMpSeK2SGRQ4Nbk4vYgTadk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=auYVOSVU;
	spf=pass (imf26.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.100 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789122605;
	b=TrgNaX9Ctl0jIswkzmQmIFlQuwGbbqChpnoU+/5pjmLPaB/XD36sGsHviqsnn2HMals7Q1
	vkgrNGMcWtfCI8nomCSaP98v/d1S/KynzlrUpmvtRyx6Q8o8EedRw52zDa6rtFMDQlsn6/
	Wu3SKR/QJqnIMOuk0Ffvq20vroYky+w=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=eZtumF7gD/yN9q4V8RaI4UNr8jIZL+PASXDDcBgG0Is=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789122598; v=1; x=1789727398;
 b=auYVOSVUiW2Mukc647VZ5OpxMcTiKgVt0DtNLoiy/mN/2WkNswugxI8CRsFHB/ichYjaaPyj
 lrhDKiiVWRQ5LMkzwoJQta9kR+rj+ubiNZbw198zK3XOx3HLpngJjGfC4OY/cuKvX3aK0nIvmfF
 eq/joxy0QqRE74ZZIPu8p/9E=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 482c8db3fc73cf4c;
	Fri, 11 Sep 2026 10:29:58 +0000
X-Mizu-Trace-ID: 482c8db3fc73cf4c
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
Subject: [PATCH v2 0/3] mm/mglru: add tracepoints for scan and aging paths
Date: Fri, 11 Sep 2026 18:29:36 +0800
Message-Id: <20260911102939.2485750-1-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: jhdbubj5ojo9x5mbkqrthxzju5rwf463
X-Rspamd-Queue-Id: 0E26714000A
X-Rspamd-Server: rspam07
X-HE-Tag: 1789122601-897815
X-HE-Meta: U2FsdGVkX1+Yv/lZvcux+z9L5wpBDIx3hy7mK14JO39X41oEukuaNDBtfTWZXmVsfjHBWi8FDF9XT/IG9C3ZE4N5eYr+Buy58GGVZZHUuPOCa91VOmUD5l9OtQGQNnnb7ZSjAaZ8cB89HeWvuUW65rwSkAzoYZlyZYxq7QiX2bk7Ep/KxcE5hBkWnlBgcLLR80Lse0PWipg7IZj7cjpX3ikNnrHzFb1pZSG+8pYukbbUPPb97JQ4Z7EX66faziTl5ZngcI7b/48CvHI+KenmIF7aw3mopvDmwQ1I+w4VtnHZnVaQqwQD8I6w5slRp2fkCNLrrNxlGCTWQGNdwavnSNe4nWnM9o7hFSYQU5/po265PdHJ9aNk8isUcO6BdEhSfRVBsIWD/2k8aibt7vqy+BbovFjut761RYSiIvgppaVetaoODw/f/N9ssbkL5ci0gPunyeUi0Di9Izw03DRImSaWAKgPFx6Gp8QxLJ4vHmknECkh51htJO0C3gfwSPeunbobE28n1mflhG681s9f45T08xfT89Be5hGQvg1oiSgG7SQs8zAubKZF81mqsIJRVwoMU2T9knrDCML4eIQC+H4paRAd3hupPjCWlepwXP1krwKpmM6f5fn3nprtcQIP4rSGj8u+eABtvb7f+GgPVSWhHLd4Zz9ynFmpZ0L5aLA4jjGfDc1AuivITMYOzM87++g3SnnoX78H3DJKYsUxT11EN1QHfXz/KMip6K5XS/+O9G32lgj0uAptlEbsLEhGLwMO22X9jMytkD34+M9spyUzwtYZSIHOLokeZlwJ3aqKrxtEEC2cxuDvLVvN7R5A29dMPjjV61QybDP90W+e+dP9CTEDVzUWePSi+mOEQEthaWnvYA+OZT2OuFR/obV415FWzNKvuB1nhndOtW8u4CQeul3e1WZ4psSQK0rOW6OuqtBRvozvK/b9OqUcCoG7iJAsxn9kAWPoBKmJk5+
 btbb2eyA
 sm1X8PQmNqxk8cR/QHVpRoSLqUJsyV7i2lh8pxqo/lSyroJHIvtgYmzM+B9PPHf1HASgd8EJ+Al2dYWphhYo6ihWGkX3xrHJKHRRbGVhg+Vm+4P1srqDnxYf0TPYQAF3zEqMY6KGgFJlFmF7B22Ufjd5eLX3Fd0TTysZ5XezAvniond/SuU66R9IfZGKr7HBFRL51jJ9UPSxgisjqMwvmZMIfxEOPndGjfTBwzwNN5kjPL2wrldISyT/FGj00b9DJgfIZ0NhAyAn2CGC8AwbucZY3kWRZnzwHlrevqD54G8m+7aOFBPDnQp3nPw==
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

---
v2: address Sashiko AI review [1] - pass struct lruvec * into the tracepoints
    and do the memcg lookup inside TP_fast_assign.

[1] https://sashiko.dev/#/patchset/20260911072848.2346073-1-ridong.chen@linux.dev?part=2

Ridong Chen (3):
  mm/mglru: factor out lru_gen_seq_nr_pages()
  mm/mglru: add tracepoint for scan_folios()
  mm/mglru: add tracepoint for inc_max_seq()

 include/trace/events/vmscan.h | 101 ++++++++++++++++++++++++++++++++++
 mm/vmscan.c                   |  53 +++++++++++++++---
 2 files changed, 146 insertions(+), 8 deletions(-)

-- 
2.34.1


