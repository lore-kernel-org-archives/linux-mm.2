Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 463F4CA9ED2
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 13:13:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28D156B0088; Tue, 13 Oct 2026 09:13:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23EA26B008C; Tue, 13 Oct 2026 09:13:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12DC76B0092; Tue, 13 Oct 2026 09:13:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E33826B0088
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:13:40 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DE43D1A0CAD
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 13:13:39 +0000 (UTC)
X-FDA: 85317644958.01.D199A49
Received: from mta1.migadu.com (out-125.mta1.migadu.com [95.215.58.125])
	by imf22.hostedemail.com (Postfix) with ESMTP id EA9A0C000E
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 13:13:37 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IoePccMq;
	spf=pass (imf22.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.125 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791897218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=LRycXWkXtk2nN7+mWZ8S0gHHUNt/EEHWOSEgcODYjNw=;
	b=u6o6TVVfgdISIhiEJlEUxqDD7R/ywUaiUEGcyxrSzGtgHrIajLDUMTzWAoGdju2Qo4lzNV
	O49li2DSjiGcIoY2KlB/SIOaXBaMWl+FFt/4B8Sp5qfM3wz9zGua1AgnWffzxxRFH2hq4m
	jRhG0yo2jnMhfqNlL49vOyaTdDf1m3A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791897218;
	b=yPKSQEy2ratcx5i/ZrV6PWqBmhF09AJzC1k5+RQqrBOWgIMXJuo0kAdtV1s8oHzuNaZzH1
	hat9HxDtNqpCN6rXLNy9QvCAGcdvtou+eIHWtpTs/su2E1VqRevY3IR4Ruhvb9htCS2MRd
	I5UoroTrYE+h5Of85xJFiZOnGsGzhAM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IoePccMq;
	spf=pass (imf22.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.125 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=dGFgIE1Ak3qC4ku6H3c6KA+1Zmp1EwOYePHWmr/QoHY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791897215; v=1; x=1792502015;
 b=IoePccMq98WWPUGxOA5spFqn0n5YjeW1rdXu8Lgzndq2fu+WEZUW6GFkr0aFi9V4LoRPZedE
 e+L3sTRNz99xi1X5oR9ii2LSLpXGfnbPEg5Kz+6EvkQ82qbh7C9y/bFp8PNvSnU7RCf88pxp4Fi
 jLaZxKIEMkdn5vhiqh6PjUiA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 2dbbb7a0f42226d5;
	Tue, 13 Oct 2026 13:13:32 +0000
X-Mizu-Trace-ID: 2dbbb7a0f42226d5
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
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
	cgroups@vger.kernel.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	linux-mm@kvack.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	bpf@vger.kernel.org (open list:BPF [MISC]:Keyword:(?:\b|_)bpf(?:\b|_)),
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH RFC v3 0/7] mm/vmscan: move vmscan tracepoints to a local header
Date: Tue, 13 Oct 2026 21:13:02 +0800
Message-Id: <20261013131309.2790253-1-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EA9A0C000E
X-Rspam-User: 
X-Stat-Signature: g9ecds16f7fotkwhi5uthu18miofot3y
X-HE-Tag: 1791897217-336668
X-HE-Meta: U2FsdGVkX1+AEXTE+jYje+ciQg8BbgbyfsRxvHjnPETNPTx/pkYXBncqrIMI5CaHQPdy/8A4uzmMUu+z7+uavO3bjr8p/IiG18HBTMmE0YAaszbGEIleh/4/aizQiQ0Gv+I/l2QKFRIqAzQBYPQYqJBJRMXVpuGUvIW1LMcmgcLymLOV+fuqPnXCyHtm2fEZNCisxfzjnfGon351gExy6LgbR3UPrYXs4tq6z2UutRhRHWZyme+QHumpKLVBMvssvPRfTJiofBemvp3xXbLvufnAAXXT3yHd1lRvkHI2QQZeX6nOgz/P5oVFuDDN1aBhEZxyzlZUR9+jf3v0W6Y+iJilxXN38zeELQokJoGscOMYHYgXhlK5ePv51pKbpDLqsysBO4/rGXAn730PhiqrIyYSijgfxnqwQK7yWPg1Wn0ini6t04cqfRC4korjQ8l1sXPXb8fciOoXz50gzWvQ4vK6b9ImawoOqKTKTCHcOLlVY8gEuVe4J9rUDwg/O/YJzoYZNZhNYJwVhoHinleovEriMDdjqlnct36GqdTVf9EmirBt9rZWyLDAMGKSUN30vulLP+52dmrskGyLFu+75CtfHsnl5dcOCZc5RMq1bhgidmJVbLjeE71mMA+034IQs7YB5wgt3PsU59IeFa07+sVSGm3HLToMghQmluqTVs9jae+hd+9/8XtdZg1am3FF6fGgDDey1VRyQkmQ3VIIL6GbVWx/Q+NDq7qkkzDjGftghNjBHN4Z2GA0DttKfT2puoVxz2KFw5+HjaaOoCXu7/apLW4VujE12H0BHQICKrqEVbwfadPWu53QLKtNobRmnePtopsmaf2z8SQrNRs0KfmYRBLN5DUBFlDx704n0y3BroXOEayPCr+sv1r1pLxM4dzQcgqnhnAK8+DeX5sbMx1x/29PeOpvZLru+9h/bogYnfpXNt/t0rhZtb+OvTrqj19PL2mVotXpVH+2UVV
 pAiZNFZS
 9TOcyPaV0QmmK3yA49sJr3FKyRtXq5qoV24nC+pD/YuybYXBc0qpLigx3Wma+AueIQVvGxsqhsZjQ+PwYKZnHVhbCk2hQwCliQRblhiLom0MklyKoYX5nUe9oJ7m8xVSG94kYjvRK4TNleHGhznQ7j5F6Ee2iPFzhgNYqAyIPqgwfAVm0gxHOCDBdZ3TR3csLBqULUGtR7hdxLKZKj2oHU300BDf+v9v2cl8sabpaKarBCw+8CVXhKmQ3hVwkyeRvgdND4OW4cGGLIc7qS1zWEetWILFhSbp3cz/iR5kf3BloRsNCzBF8VpMX6GrrMF/TqGBmLSnh8AtN4sShjBDmE4SZjMASnF0vhJyNPQA2sdooRep5KXACV9lhjmQ8nqezH4Mw4kCAVYhk3jq/Wk0ApI315bQ04CCKn/6iylLsr7yxKRlKGusfw6vESnz6LHYOAhim4+A6Q67wVdpr9NIzPi1HIwYut1UBYH3wWW9Evzi26QKBKII8qLxaQt1Z8bnU5dX5U4PCEdHStusPAVbG5skMxxZMglJ86NGXbNLwQh8ib/5BVgrctmVxMdHbpSyFINW8YBc7XGOR+LQRSgCTpwWa4OYOPaTNpHgttHzUFcCTxEJzGD8IO773zIitqQ4ekEwOsEeOoCmmLku0Xuvrjj/sscHCc9YtUVlsm+nI+A/asta81T5sJnP0bZSgTeSjw0NvRhBKkWUshk94zoCKiycfTzzHFZc2FptnCT2QwdkKB8RvrgRikIFTc4JEfPcIxDkNHP0bXF6ZlX9j8hFU5z6v1GsOD5o9RJyhXzZF5rXAO7h6AAa2nIUzU45M0h9jrUXNKpUK1LrjHqsclvyEJGMuxURjATlvisJ10YJ61wC85BKs30l5pfEHn7R8KaCOcMcgWhHTo9TglVQ60j/tQDfYNeHkjvYB9JW/ohGeNGzfIJ9Hp7o611GzOWmhGkC0hCwvTszd75DfrP/gfYietqpE4XdY
 6X4oI1VZ
 Y0TQaLECNg5DhPK4Dut4ant+9zNrUcA2tIR1cFM+910=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

This series started as an effort to add two tracepoints for MGLRU. In the
discussion, Steven suggested moving include/trace/events/vmscan.h to
mm/trace_vmscan.h [1], as several other subsystems already do. Once the
header lives under mm/, struct scan_control can be moved there too, letting
the trace events access its fields directly instead of having each callsite
copy the scalars out by hand.

The series builds in small steps:

  1) drop the unused vmscan trace include from memcontrol.c;
  2) move include/trace/events/vmscan.h to mm/trace_vmscan.h, using a
     relative TRACE_INCLUDE_PATH so no Makefile change is needed;
  3) move struct scan_control into a dedicated mm/vmscan.h, which
     trace_vmscan.h pulls in, guarded against the multi-read that
     define_trace.h performs;
  4-7) pass scan_control to the vmscan tracepoints and pick the fields
     out in TP_fast_assign, one group at a time: the reclaim-begin
     events, the LRU isolate/shrink events, mm_vmscan_reclaim_pages and
     mm_vmscan_balance_pgdat_end.

Besides the cleanup, this moves the loads of the tracepoint arguments out
of the reclaim paths and into the trace event callbacks, which only run
when the event is enabled. On x86_64 with gcc 11.4, the callers in
mm/vmscan.o shrink accordingly (bytes), e.g.:

  isolate_lru_folios    4060 -> 3896 (-164)
  __node_reclaim        2258 -> 2076 (-182)
  isolate_folios        8706 -> 8577 (-129)
  shrink_active_list    3669 -> 3544 (-125)
  evict_folios          4787 -> 4698  (-89)

There is no functional change. TP_STRUCT__entry and TP_printk are
untouched, so the tracefs event format is identical. This was confirmed
by diffing the tracefs format files before and after, and by capturing
the direct/memcg/node reclaim-begin events under load in a QEMU guest
(order, gfp_flags and memcg_id all match). BPF programs attached via
raw_tp/tp_btf do see the new TP_PROTO and need to be adjusted;
tracepoints are not a stable ABI (see Documentation/bpf/bpf_design_QA.rst).

highest_zoneidx and nr_reclaimed stay separate arguments: the former is
a balance_pgdat() parameter (sc.reclaim_idx may differ from it by the
time the end event fires), and the latter is the return value of
shrink_folio_list(), which does not update sc->nr_reclaimed.

[1]: https://lore.kernel.org/linux-mm/20260916095122.50cbb620@robin/

---
Changes in RFC v3:
  - Use "Assisted-by: LLM" (Muchun).
  - Note the BPF raw_tp/tp_btf impact in the changelogs (Sashiko).
  - Changelog wording fixes and minor indentation fixes.
  - Link to RFC v2: https://lore.kernel.org/all/20260928114625.3609130-1-ridong.chen@linux.dev/

Changes in RFC v2:
  - Convert the remaining vmscan tracepoints too.
  - Move struct scan_control to mm/vmscan.h (Baoquan).

Ridong Chen (7):
  mm/memcontrol: drop unused vmscan tracepoint include
  mm/vmscan: move vmscan tracepoints to a local header
  mm/vmscan: move struct scan_control to a dedicated header
  mm/vmscan: pass scan_control to the reclaim-begin tracepoints
  mm/vmscan: pass scan_control to the LRU isolate/shrink tracepoints
  mm/vmscan: pass scan_control to mm_vmscan_reclaim_pages
  mm/vmscan: pass scan_control to mm_vmscan_balance_pgdat_end

 MAINTAINERS                                   |   4 +
 mm/memcontrol.c                               |   2 -
 mm/shrinker.c                                 |   2 +-
 .../events/vmscan.h => mm/trace_vmscan.h      |  80 ++++++-----
 mm/vmscan.c                                   | 136 ++----------------
 mm/vmscan.h                                   | 118 +++++++++++++++
 6 files changed, 178 insertions(+), 164 deletions(-)
 rename include/trace/events/vmscan.h => mm/trace_vmscan.h (90%)
 create mode 100644 mm/vmscan.h


base-commit: 4eb2586bd40db27d77cc5b724ca9386ed0c71d53
-- 
2.34.1


