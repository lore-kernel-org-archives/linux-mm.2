Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A744B606A327
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 02:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ulakeDBY
Received: by kanga.kvack.org (Postfix)
	id CA1DE6B05B2; Mon,  2 Nov 2026 21:56:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C77CA6B05B3; Mon,  2 Nov 2026 21:56:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8E016B05B4; Mon,  2 Nov 2026 21:56:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 90F656B05B2
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 21:56:38 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8EEA91601B8
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 02:56:37 +0000 (UTC)
X-FDA: 85392294834.23.8FFE1AA
Received: from mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5B423140006
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 02:56:35 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ulakeDBY;
	spf=pass (imf09.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793674595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=KYNqJoD8jiVVbVGjViquLsodb0bTWH0Q2lSk5f0SxWk=;
	b=ZWOSlWurqDp+mOvtqw7B6Bbj139tpjb4fWmx5DHaqnwWTKj9mqkVBtKmpFdaM72mW4fQip
	Wijoo50Aa6oQCAb8UevIo75a/C+WPdZVPoFlnIjIs9JqhTfW9EXxFLy3qC5A+rA7X630sf
	U0Kf7X5BhRO+kNsgeoiEUv2EbrTwQNk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793674595;
	b=lQFi9dkKD1+vrlVTvgVBRY4Hce94tDs7l1qRz6Vn1eg0PhonvOt5WlswJVaMOAsUorVPlQ
	Zso29K/VIIaLRrfoXAYh9P4KZpiA8J3zSNAHt6OL9EEBVYhmVNb38RB1zuGEMVN+KpJpvJ
	85qzoouhelN2KRRTbyYEgFsAkTuOBgs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ulakeDBY;
	spf=pass (imf09.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=WJg7BBQIRH/pepd9pdWNt5emlhFaI0LINxhKgnwGpSg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793674592; v=1; x=1794279392;
 b=ulakeDBY++UvLs7xFlPO3zbqz1z2Ru1JVAFJfG6Rh39uujL3CUgLlYWPdZxrjpm7oBOLsrSy
 M5s9+dh2G9dxkd4WspF3jmg+P6KDoVluseY01XSKExYPoVLY95SFS58fuWWAdA487xITVWchfa7
 wW7bk9/UxEfJw7vqPJfUgy8I=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 087df93ef1622e83;
	Tue, 03 Nov 2026 02:56:32 +0000
X-Mizu-Trace-ID: 087df93ef1622e83
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Dave Chinner <david@fromorbit.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	bpf@vger.kernel.org (open list:BPF [MISC]:Keyword:(?:\b|_)bpf(?:\b|_)),
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v6 0/7] mm/vmscan: move tracepoints to mm/ and add MGLRU tracepoints
Date: Tue,  3 Nov 2026 10:56:03 +0800
Message-Id: <20261103025610.3738894-1-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: o9qicmkoq6u3h549ywx46hhopgwbw3jn
X-Rspamd-Queue-Id: 5B423140006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793674595-343534
X-HE-Meta: U2FsdGVkX1/o8N7FdLo51IDHt972mj0AfHYrfM04hnPJvU2Bi3EXhvh4TFPGF8Vbkisfg4rgRRvca67gET+PVbQMnNP6Ikg7tGSWY2ofhct063AzJPbaVQZz8GyQl7e0uHvRlWJt1B2o//jD2bhgm78qkeB/t2oyY4zclASQfJCxypavl/cBE9mAtTqMcZoTfje5BIncUd8NAcqbm5YZwe7WtUgZqcxKQqNqDLK5ll2fpKtDtoYcVnJBXo3LWY4RzyR8FwEYpaseo9v/jm0wC/ZD14fGB2RxKHkk0jxGYtv1Rr78AzrLHGuswKn0+tMRPCLPNbKZDy+ZA93QPtgte4nDftTlU0SJM/9L/XecpIY8NRD3rHP3zwApUJh3yK3wjX2wXZ9QfmtbT5F/1sEcymiNj46yhxdUjcX2M0IbNWguAGPkHyHx+VxmU+aKw6PCklBS9v3LAEA99az8KWfWJMDRs8pQodSWuW6Peq5+LYOdcM0u85afY72E16fW8laaD/kCSAqUJYErHIgkyfamTN1OPAziCWQTbolw1akIwW3tsfT5GjY4s8/2T3C3s2YGYOFgh4KTz1v8jyCkrwlAZom6ROXD/ozZNjP9cINu4pVvUwsKYFuup1cCm2ofrSyI0/D6GlL2/R7T7tFRonMHr6+6hC/zhog0RFoIfQGWDlKnjS/q/zDhDyAtZ+bZRxGYbwILeVPvl9dKhpAdNpPDymhGTIOCD0pSg47LKQmVVQ7RiD7Q7uvHJSiegAJmf2DPhribc+F7As/Rw4Nt7/+NiF/a4rsfXs6ehzvl/2SEIMOvDnud6Cn5I4XgVI3jqaWSHCAby0NHKNZDbf0nyUuaDwA0y58EXFuf9r7JMbaXBfHEPq04tGXG4BLfrlAoEzClnph/dEKgifakrFMmBP6NVrNbfxeRcYeScrlt4e3/9BiKsB82FUq4w8DpXmG/FOqE8IvVWWBRjaeUReJjcl6
 FdXNRmhs
 gF2wACt5i6TUL4TZ/7S5zeUvnzvyR8QBmYfR6DXpapibQTNCy2ESD6bDDO7INVkwZS60ZWAg/Po1o3BpCMV4d6LFq6pg27mkvzyGEqWuEuDuvmSaMs8yQGzXrLn3kWX7dpbbzwpqSXtC2quQ/qoPzdhTk4eaCTj+80wOVey+fqsJixRZVjru7Mp6qRNkA9/EOB/pNnsydu3lV0lWWnQLbYLtrimJfGHfYmjgmFMLkOQYs/W7ElyTEl/RtrG2Dkw0/Y/n68Fr0tSqys7xJNxbwzHxjCA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ridong Chen <chenridong@xiaomi.com>

Background
==========

MGLRU currently has no tracepoints of its own. The scan and evict paths
reuse the classic-LRU tracepoints (trace_mm_vmscan_lru_isolate() and
trace_mm_vmscan_lru_shrink_inactive()), which predate MGLRU and carry no
generation, sequence or memcg context. A trace of a running system
therefore cannot tell which memcg a given scan belongs to, how far
reclaim has progressed through the generations, or when a new generation
is created.

While reviewing an earlier version that added two MGLRU tracepoints,
Steven suggested moving include/trace/events/vmscan.h to
mm/trace_vmscan.h [1], as several other subsystems already do. Once the
header lives under mm/, struct scan_control can be moved there too,
letting the trace events access its fields directly instead of having
each callsite copy the scalars out by hand. This version merges the two
efforts into one series: the restructuring first, then the two new
tracepoints built on top of it.

Implementation
==============

Part 1, restructuring (patches 1-4):

  1) drop the unused vmscan trace include from memcontrol.c;
  2) move include/trace/events/vmscan.h to mm/trace_vmscan.h, setting
     TRACE_INCLUDE_PATH to "." and adding -I$(src) for vmscan.o;
  3) move struct scan_control into a dedicated mm/vmscan.h with an
     ordinary include guard, which trace_vmscan.h pulls in;
  4) pass scan_control to the vmscan tracepoints and pick the fields
     out in TP_fast_assign: the reclaim-begin events, the LRU
     isolate/shrink events, mm_vmscan_reclaim_pages and
     mm_vmscan_balance_pgdat_end.

Part 2, MGLRU tracepoints (patches 5-7):

  5) add mm_mglru_scan_folios on the scan path, next to the classic
     mm_vmscan_lru_isolate, reporting the same counters plus nr_sorted
     and the nid, memcg id, max_seq, tier and min_seq of the lruvec;
  6) add lruvec_gen_size() to mm/vmscan.h, returning the number of
     pages of one type in the generation of a given seq, and convert
     the two open-coded users in vmscan.c;
  7) add mm_mglru_inc_max_seq on the aging path, reporting the nid,
     memcg id, the new max_seq, the anon/file min_seq and the
     per-generation page counts of both types, from the oldest
     generation to the newest as in the debugfs lru_gen file.

Both new events only take pointers (lruvec, sc) plus the local counters,
and derive everything else in TP_fast_assign(), so the reclaim paths do
no extra work when they are disabled.

Effect
======

Part 1 moves the loads of the tracepoint arguments out of the reclaim
paths and into the trace event callbacks, which only run when the event
is enabled. On x86_64 with gcc 11.4, the callers in mm/vmscan.o shrink
accordingly (bytes), e.g.:

  isolate_lru_folios    4499 -> 4335 (-164)
  __node_reclaim        2402 -> 2220 (-182)
  isolate_folios        8706 -> 8577 (-129)
  shrink_active_list    3669 -> 3544 (-125)
  evict_folios          4858 -> 4769  (-89)

There is no functional change in part 1. TP_STRUCT__entry and TP_printk
of the existing events are untouched, so their tracefs format is
identical. This was confirmed by diffing the tracefs format files before
and after, and by capturing the direct/memcg/node reclaim-begin events
under load in a QEMU guest (order, gfp_flags and memcg_id all match).
BPF programs attached via raw_tp/tp_btf do see the new TP_PROTO and need
to be adjusted; tracepoints are not a stable ABI (see
Documentation/bpf/bpf_design_QA.rst).

highest_zoneidx and nr_reclaimed stay separate arguments: the former is
a balance_pgdat() parameter (sc.reclaim_idx may differ from it by the
time the end event fires), and the latter is the return value of
shrink_folio_list(), which does not update sc->nr_reclaimed.

Part 2 makes the full aging-to-eviction window observable per memcg:
aging advances max_seq (the leading edge), scanning consumes the oldest
generations, and the min_seq/max_seq pair on each event shows how the
generation window moves over time. A sample trace, captured under
memory.reclaim of a test memcg, with the classic-LRU tracepoints left
enabled to show how they interleave:

  mm_vmscan_lru_isolate: classzone=4 order=0 nr_requested=64 nr_scanned=36 nr_skipped=0 nr_taken=36 lru=inactive_file
  mm_mglru_scan_folios: nid=0 memcg_id=1833 classzone=4 order=0 nr_requested=64 nr_scanned=36 nr_sorted=0 nr_skipped=0 nr_taken=36 lru=inactive_file max_seq=3 tier=3 min_seq=0
  mm_vmscan_lru_shrink_inactive: nid=0 nr_scanned=36 nr_reclaimed=31 nr_dirty=1 nr_writeback=0 nr_congested=0 nr_immediate=0 nr_activate_anon=0 nr_activate_file=1 nr_ref_keep=4 nr_unmap_fail=0 priority=2 flags=RECLAIM_WB_FILE|RECLAIM_WB_ASYNC
  mm_mglru_inc_max_seq: nid=0 memcg_id=1833 max_seq=4 anon_min_seq=1 file_min_seq=2 nr_anon={0x0,0x802,0x0,0x0} nr_file={0x0,0x357,0x0,0x0}
  mm_vmscan_lru_isolate: classzone=4 order=0 nr_requested=64 nr_scanned=64 nr_skipped=0 nr_taken=64 lru=inactive_file
  mm_mglru_scan_folios: nid=0 memcg_id=1833 classzone=4 order=0 nr_requested=64 nr_scanned=64 nr_sorted=0 nr_skipped=0 nr_taken=64 lru=inactive_file max_seq=4 tier=3 min_seq=2
  mm_vmscan_lru_shrink_inactive: nid=0 nr_scanned=64 nr_reclaimed=64 nr_dirty=0 nr_writeback=0 nr_congested=0 nr_immediate=0 nr_activate_anon=0 nr_activate_file=0 nr_ref_keep=0 nr_unmap_fail=0 priority=2 flags=RECLAIM_WB_FILE|RECLAIM_WB_ASYNC

The mm_mglru_scan_folios lines carry the node, memcg id and the
generation window (max_seq/min_seq) that the bare mm_vmscan_lru_isolate
lines above them cannot - those cannot even say which memcg they came
from. The mm_mglru_inc_max_seq line then shows a new generation being
created (max_seq 3 -> 4) with the per-generation page counts for both
types, listed from the oldest generation (seq 1) to the newest (seq 4),
and the following scan already reports the moved window (max_seq=4
min_seq=2).

Testing
=======

The output of mm_mglru_inc_max_seq matches the debugfs lru_gen file,
e.g. right after aging a test memcg:

  mm_mglru_inc_max_seq: nid=0 memcg_id=1833 max_seq=4 anon_min_seq=1 file_min_seq=1 nr_anon={0x0,0x4002,0x0,0x0} nr_file={0x2412,0x0,0x0,0x0}

  # cat /sys/kernel/debug/lru_gen
  memcg 1833 /tpt
   node     0
            1       4541          0        9234
            2       4541      16386           0
            3       4541          0           0
            4         76          0           0

[1]: https://lore.kernel.org/linux-mm/20260916095122.50cbb620@robin/

This series was developed with the assistance of an LLM-based coding
assistant.

---
Changes in v6:
  - Rebase onto mm-new; MAINTAINERS already listed
    include/trace/events/vmscan.h under MEMORY MANAGEMENT - RECLAIM,
    patch 2 now renames that entry.
  - New patch 6: add lruvec_gen_size(), ported from Barry's swappiness
    series [3], in mm/vmscan.h so the tracepoint can use it too, and
    convert lruvec_evictable_size() and the debugfs lru_gen output
    (Barry).
  - Patch 7: order nr_anon/nr_file by seq, from the oldest generation
    to the newest, the same order as the debugfs lru_gen file, instead
    of by generation slot (Barry, Baoquan).
  - Collect Reviewed-by/Acked-by/Tested-by tags from Baoquan, Muchun
    and Barry.
  - Link to v5: https://lore.kernel.org/linux-mm/20261031090041.58574-1-ridong.chen@linux.dev/

Changes in v5:
  - Squash v4 patches 4-7 into a single patch 4 (Barry).
  - Link to v4: https://lore.kernel.org/linux-mm/20261019034426.2354049-1-ridong.chen@linux.dev/

Changes in v4:
  - Merge the MGLRU tracepoint series [2] into this one, on top of the
    restructuring, and drop the RFC tag.
  - Patch 2: use TRACE_INCLUDE_PATH "." with CFLAGS_vmscan.o += -I$(src)
    instead of a relative path (Steven).
  - Patches 8-9: pass lruvec/sc and compute the fields in
    TP_fast_assign() instead of at the call site (Steven).
  - Patches 8-9: add nid, derived from the lruvec (Baoquan).
  - Patch 8: group the int fields at the end of the entry to avoid
    padding on 64-bit (Steven).
  - Drop "mm/mglru: factor out lru_gen_seq_nr_pages()" from [2]: the
    per-generation page count is now summed inside TP_fast_assign(), so
    the helper has no user. The Reviewed-by tags given to [2] are not
    carried over, as patches 8-9 changed substantially.
  - Link to RFC v3: https://lore.kernel.org/all/20261013131309.2790253-1-ridong.chen@linux.dev/

Changes in RFC v3:
  - Use "Assisted-by: LLM" (Muchun).
  - Note the BPF raw_tp/tp_btf impact in the changelogs (Sashiko).
  - Changelog wording fixes and minor indentation fixes.
  - Link to RFC v2: https://lore.kernel.org/all/20260928114625.3609130-1-ridong.chen@linux.dev/

Changes in RFC v2:
  - Convert the remaining vmscan tracepoints too.
  - Move struct scan_control to mm/vmscan.h (Baoquan).

[2]: https://lore.kernel.org/all/20260911102939.2485750-1-ridong.chen@linux.dev/
[3]: https://lore.kernel.org/linux-mm/20261022220203.91911-11-baohua@kernel.org/


Ridong Chen (7):
  mm/memcontrol: drop unused vmscan tracepoint include
  mm/vmscan: move vmscan tracepoints to a local header
  mm/vmscan: move struct scan_control to a dedicated header
  mm/vmscan: pass scan_control to the vmscan tracepoints
  mm/mglru: add tracepoint for scan_folios()
  mm/mglru: add lruvec_gen_size() helper
  mm/mglru: add tracepoint for inc_max_seq()

 MAINTAINERS                                   |   5 +-
 mm/Makefile                                   |   1 +
 mm/memcontrol.c                               |   2 -
 mm/shrinker.c                                 |   2 +-
 .../events/vmscan.h => mm/trace_vmscan.h      | 192 ++++++++++++++----
 mm/vmscan.c                                   | 158 +++-----------
 mm/vmscan.h                                   | 134 ++++++++++++
 7 files changed, 317 insertions(+), 177 deletions(-)
 rename include/trace/events/vmscan.h => mm/trace_vmscan.h (76%)
 create mode 100644 mm/vmscan.h


base-commit: 0e02eb17f263e4a3ae6bf1fe45122c23361f0cf7
-- 
2.34.1


