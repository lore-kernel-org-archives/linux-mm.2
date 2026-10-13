Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA441CA9ED2
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 13:12:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B65DB6B008A; Tue, 13 Oct 2026 09:12:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B16196B0092; Tue, 13 Oct 2026 09:12:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A056E6B0095; Tue, 13 Oct 2026 09:12:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7309E6B008A
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:12:49 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 45F2F1A0CAE
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 13:12:48 +0000 (UTC)
X-FDA: 85317642816.06.694556E
Received: from mta1.migadu.com (out-71.mta1.migadu.com [95.215.58.71])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2DBD814000C
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 13:12:45 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kGxcJwju;
	spf=pass (imf09.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.71 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791897166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=LRycXWkXtk2nN7+mWZ8S0gHHUNt/EEHWOSEgcODYjNw=;
	b=vGuaOWnMMqDM8Xj3pDdbBd5rBOblhKFEt91nbzTu5+GYO9M6Z8+ZjBfpsyTvjD4klSHXQH
	iiuF2PMm+qPGVy7vWs9Z3CxbRAGb9jBYPSDB9quget2KTo0CzWdn/Rnwn+K0PW/gi8jope
	qeeYv2nTx8Dt4VNrrtM14RJfQAV0p8A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791897166;
	b=Z1o+gOi7g7/dWNh/fpOZQNWE4QcCZEh01N96kigwgIVNDanpEQZR41JW40oJ/q4uamJ/EA
	4Jha4Liz1YJh3YGdV9eCEyfIGRbSJeZ0Iy/El35Tstx6YOV+3H1NITSo/IFOP+3qs+QXcy
	V7EGmYBPpKRwD2O6WT5cDl6b73psYgI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kGxcJwju;
	spf=pass (imf09.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.71 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=dGFgIE1Ak3qC4ku6H3c6KA+1Zmp1EwOYePHWmr/QoHY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791897163; v=1; x=1792501963;
 b=kGxcJwjuZg+WkKy0F/T3dV72M22Ii83SGegKddzjlRTTpWidQ75IYu6vBeRy6QlZV9pJn1ss
 1RnvEM48gq7JmwwkGPrcFG0tsQHV1nMQeMzkKYIN9C+lgxfuVrpQWTtOfv1RQrN40OYDUVazMvg
 +oR3gWu9rIBgov+toWXwouUo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 4518c51e3d8db235;
	Tue, 13 Oct 2026 13:12:42 +0000
X-Mizu-Trace-ID: 4518c51e3d8db235
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
Date: Tue, 13 Oct 2026 21:12:10 +0800
Message-Id: <20261013131217.2789684-1-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2DBD814000C
X-Rspam-User: 
X-Stat-Signature: g9ecds16f7fotkwhi5uthu18miofot3y
X-HE-Tag: 1791897165-387509
X-HE-Meta: U2FsdGVkX1/hyJ5lSHWStOcGkbQY3ySabH9WDPVe4hiGTIRVPg0UPvXanj2QZLwQvD+lVZMIFuWPgYvSkAYBbyRcwsTVtlYJnvuxtjGqL3K4/FQxB40VqxzhKC2aPgKSKvxGKtD66r+da/pSdMReC+lZ0asVbXv9Q5R74S6ORzFKnYbeLp0+Iuc9+H932SeQZTqu4EoS+MmX3sMFvvq4nIZDqpKP76LXKdy558g/QuliedlWDIaVay3AHJQ2Lm9D+fh86qNwCx1/tJlNE25YAb24rNKn5HrJym8CKwOlScFhTgsHoLr8W/oZU/5MLL0Wy/eEDJ9uKT/ti1UiZPYa1XDKUiD4F4tJBUpf73Fcjbh0qv44270DtxUhsneVPhmI7D2oFyj1aVJP2ScugjR191RMBbDFMOAS1OjWzIxty3dWhDe12cl1jnL/UBBOWH3I97K+bXwqNa6WIjvxGAilQiNOx3Z/ACKVUQ1RGbajYvR249mNMrA1DGAfNm1RpRfeMlPbumLzbNkHMFvXALIQr26y/roBZq6f6hHnYqC7xtmxnJx4n15qVf3f0WaYALRZ1q2nEdsn6pF9Pe6mSFzsL+4O1InkBKXVYyIZG/vrcbURG9QJ+5iHwfpe8P9TNdiabwuTgAgrXkWi9bzDxwIsYuOskmJ7t26sorPiDzGZv1z8NfIK7Dv0ydBdUrdTQbZPYqQudyD7lPxIobpwCcVwRNavuqz7KlOYR3PM/M6kzHuT0TwtoLuv68U1jrHbdmWGRZzbMubKk+tnN0+t60FaLxitwrW/iy9aC8iZskK2eusVKx8/b456i2/AVIPdZ5+Od3m+TihLk1wzSYhXSwbmNbmFkE99c0fw0OVmq19i9iYe3wW9s/lvX2vq7VSY50bIrl2bLuueS5McQqI1YRW7jR4Q3RDZfbAdv7fqJEBhqpB4vq4dZ+K4Li8lU1/qDs6FH3oOMqEUWDCrURLc9Xt
 lic5bs6h
 RI/0gdL3pZs3lEQ82MtEXJqKfikZ6ZAmTxOwGXFjAQBfNjwgvd2+dJu2eLH6ZsvKlW2ZmQ/IR8+wDoHI31HX8C6zreIxIYGbjdKWYlHHMMX275WL4ZP7f2+ePUCIWs/kym3G3wxOqyM43P0YK69shODeVW4foIawmunbsYGtvKkxv8vTO62EpBTcg/nt5UrNBK0hrTXZOBayQfNu2Ogy7IIgYO8rQLqL5RUkB2+t85vystv13UMFIXmIf0ywHnaT8xR8Te8HLVSc21QpZWMq+2LOHRQRKNs4npgb4fLCaSmpBLJMBxm1y599yXqCWi3e2qKDpXjV/Wjd9/t0B5X0x8Kh+WKXK69IzmvXdQzJSHVfkBThauzTfggCvYi0pQbUE/QxLvFXh2UqxF2WBkg/Jd3RwXXH/cAyOMeKF0JeT/BRD1Uz5g9weYRFgMPdM7BTeJHQIuYs/JROXJyUd74XfpkO+Vy+nJ0tv1jLAgoI74WHSD55kXxe3sRnEzfIwUBrdia2F1pntbLjSwNnLvHT1OvaMan3Z4+/AvSsivandk0/FCWrOv9GptYAtLPrQRLQDm0pSBJlZwpd36KV6SHZ+3fELJhISjIdsGyTdHMVBG9vv05O5mVHyAJmDP6LOgAsMaQKvdgXphxKqOyetcXGedoX/LOcJSCmcOqjeotP/Y9VwOoMbPuctZEzdnH68+xjm7LWZ58r3d9q1WMcOxYR7koLNe374GBIc1/xEfxfW75dXXJQxcLBhaEI0nd9Zx+DYuGji9wbQdtg+LGo8u24Z0+iG31MeKOc5PEm0uV0U0cNMtaSYRpszEDCXp1fUwE0FYilleXH917FBP0Kl0L64A2zE3dD2v6z+C246DulseGUQFYwho8fi0GQJ1XyM2lf04r+WC7IlnHbj496pPmmhQnUWXw+lNnD5rYqI6TMWzNJPrEtCM4I5LK+hYw38cWCG6o1kU1+R84CEMqvfWncBqQZxyyWq
 77uBbVIM
 +u64st1p3Rw8DojksreF4ws/B7UDAIusU7zd1r+KhYk=
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


