Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81F3DC9833F
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 11:46:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D2306B008C; Mon, 28 Sep 2026 07:46:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 681E06B0092; Mon, 28 Sep 2026 07:46:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 599196B0093; Mon, 28 Sep 2026 07:46:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 318F66B008C
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 07:46:55 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BA70F1A01A2
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 11:46:54 +0000 (UTC)
X-FDA: 85262994348.27.4BB53BF
Received: from mta0.migadu.com (out-204.mta0.migadu.com [91.218.175.204])
	by imf22.hostedemail.com (Postfix) with ESMTP id AA709C0003
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 11:46:52 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="gjxE1ep/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.204 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790596013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=v+kQPhEEhhsYU/GM9rE5+0TL1qKUI9IRrER8nKOCD+4=;
	b=LlROirNSELKRsBllI3Q+RCEqsznvn/oTjq+77e5hkTgmIt6fjwrWvjtSazIOQ81Itd9qQA
	uS3EnjVI9Zzzr3j0XbxVtw1WYnkp/T10VH/EbGlzq/DjoF9/mel8ZTo8jGuG3ItNqEHKGI
	SKKW9Jl8sVvVvIQV8mLMSi+ofLLi6tM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="gjxE1ep/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.204 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790596013;
	b=4nOtCMhxnvW4d45dwSFIY2kmKPIKu3RhToEFl8eai9wjfn+obIuBg9xc/rTEFYU0JL+SDq
	muX2zM4f+eo9t7IWBYLkY39VjgAb/BpclPqzOnJOEY0dlafwGU5H1spAl7SNLKIyc8f+BD
	OycT2jRYVEhaukkC+JvQs3HiDjyUy0w=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=xFoYoTFmea6JwFgNn0/x7qB+AzppySK65jVPEEVi/4Q=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790596011; v=1; x=1791200811;
 b=gjxE1ep/x/NJCUyfdEEKuEFLbKn+0EDEDuEmX+lPVI8NET2fk5EQKMM/Y0wpt5A4uP052Bmg
 iHGNDXaYioc96iVVC+Mm3T738pkGW3fnL7Xf95Q3T8YvI8s1XsY/gIZSK9fjlyIbarH03iNbbcQ
 f2qHo9yiBrE28pUvdOa4k8P4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id a1c51cc4e3403e67;
	Mon, 28 Sep 2026 11:46:50 +0000
X-Mizu-Trace-ID: a1c51cc4e3403e67
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
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	cgroups@vger.kernel.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	linux-mm@kvack.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH RFC v2 0/7] mm/vmscan: move vmscan tracepoints to a local header
Date: Mon, 28 Sep 2026 19:46:17 +0800
Message-Id: <20260928114625.3609130-1-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AA709C0003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 6fkytg1ahagbsrcxjqiryap31oo41ogg
X-HE-Tag: 1790596012-699687
X-HE-Meta: U2FsdGVkX1/LIIRKjJPIHbvPAR+5rG0Z8jILF8x+eVa11nNZLIXeRVJBwkp+zlXdnTyVyLmnPxrF/gCyuN4ZeqJIEQO3/GBLzsBkVt1k9iPYo0FQGOYxa9g4fJfgHlkreUcVhRMlT93bXrS6/Rf20BqQxjJ4q9QSGUwZYXP6qOE3bxwUla9YHANTaklsn1h7406M7yIy8c8pTCsps/F2k4+2hJj4TUI4TEnb0OfU1XL93b4reifaqVJThq5oUAlEFzNzNN9tTumr+GFwqjGRPFGh2qTysUfq7LvUHfAsfhouusY92klzZV/wYOFWQHT3LQQpJmkZsznjCUGVBqZLal9Z1THsFBfklBv3IJoLF6Mk7BgodKdES2kFtTfQ7Z6adDzLYmiEMN/lbEZJg3VNicAYyG2l2AI6xLapX/Y7AAGC0a8Q++y/j42w5vW1uuAaoYQL5N5FmpqVQttRCH6T1dw4tFkrq8wXl8A/NEt2CQXaar8GZNqJkEW78UhvfcoVi1MIvHsbWbJ4prsXvyPU+3WP+OXdauoY+oONNUEA/9rc4JsIt9aDxMttA2tFo4TkUC/GVaQ8ZE7NoUPbN5WB/Rs/zRn27GMUhZuisP5ic+TRECFJW0GxHMHZLglI4aHuEG1b9gmqjdTqFoYIN8I7vaj7Xz+WrJ0e6JJrWExyQWp1913ELsFbM4TnR7UmF7ftOTrV3PTXwHeZQ+XzIWy7z7NUG+Q1RNCrHkCZsbbUWPlYVQHqFIIVI8SPhY8Uls1p9lk5ZdQNwikzo5SmGxaGt487eYU3fZFBM0R/as+huG9tA+QhVm94FJMvHB6y1GzpqPuHgMoXUWDT96PJND8DGWjM5mxjYDmnmnt72hKHtbrfsU7vle0d0DqryrU1DGtgW7PjuOuM4ci1HZbx9aBdNZC4Qgg1Ew3tjfYKMyczPXX32xljed7wcI7vWK+j0uTIIo97jkCX9fETLRnY0d2
 28JvMLDj
 AxgAXSfGZU+wF+y1IVBshuuMuqoIkR6+o9gH3XgMg/lOhYY0S/ZTYPIiZjXdWefISY1OFB+BfO1UENpkyyKngs+rbDARa6G+EHceGzC1LZkKqKNPePkOdh7VLqtZ/wI0/i954EJDqtK0OA8iPNNaXQXSxX0QyX7vuqAsB2SQ6eoYcRDlo1VO+EXqJ+1G1p/cfJ7n60vUww2ovpxnPD77JLmy69480hx/iHXCTBYpP27UQNGC+HHh2qX0s+ehTatRQQKpTdd4Do755Iv8NPEl2U/nxFxEuRN/K7Atl34WfiFkTUXPt9Ogtbne/dZ1lPBfSPPmrkqZCenvvJMXFfMI77BHwBGUwovHFSqVA3DL7BCUD0FWXEXN2+6QostinIOxma4e/bqSmTGwS1CDycy/AJEmw0cW6FC83EJTlliz0Jnt0AFEAyVACPQFPP3PIMb9Usqef8P0FauT74ZjiXgMS6vpE6VN+w/F47pw90vPybxmQNPOT0UJNZIfi1EjM6yg/HsYqbrnCLFE1MHjCZUOU7QLP6IU5Xs5UKUJDyCNt2bbBwZyqJQv7g0zwwlO6YsSX+K3/kwneMzYeSkzKgOjE5qNoOjhj2VuTufyBr2rjr3Wab1A92NmTvOx1ylrw0RmPxWlh6mo2fz+3h2Emv33yvT21jt38LIgd63cwzHiDGkOONc87MMrWWBBdEZed7WR95HpgM4I8NI2fcX6NQG48qoUk2w6KFFYjuEJnSqFv32JQ9EnxkDRaUlAj5yo9p19BxkQHtJV7NQQcryL0QPl719GQ72P17V0f3BYLz0lOUYkM3tdtkyUlReoPIxAUtB67j/pdphBe5hz8NTwXsiwQtPYryh239NzqP+WkuSbqDaks91ZLptmjrHgX/qxlrIl5Op77hrwSHSqv1/PbtXNF9VM8BNVmyUemJs2renXUiN8a9uIieXslD+qnbbAOyDw2xqnzS5MbEAYVA1O34/UJfgKWPYxQ
 bylvhfKq
 ui3c7pYzBADWup6CamPMxUlROYIP0uWdC/Dlu9YGrQ++m2kWdQx0Fg==
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

  1) drop the now-unused vmscan trace include from memcontrol.c;
  2) move include/trace/events/vmscan.h to mm/trace_vmscan.h, using a
     relative TRACE_INCLUDE_PATH so no Makefile change is needed;
  3) move struct scan_control into a dedicated mm/vmscan.h, which
     trace_vmscan.h pulls in, guarded against the multi-read that
     define_trace.h performs;
  4-7) pass scan_control to the vmscan tracepoints and pick the fields
     out in TP_fast_assign, one group at a time: the reclaim-begin
     events, the LRU isolate/shrink events, mm_vmscan_reclaim_pages and
     mm_vmscan_balance_pgdat_end.

Besides the cleanup, this moves the code that computes the tracepoint
parameters into TP_fast_assign(), which is in a separate text section. It
removes code from the work flow, improving instruction cache.

There is no functional change and no ABI change: TP_STRUCT__entry and
TP_printk are untouched, so the exported event format is identical. This
was confirmed by diffing the tracefs format files before and after, and
by capturing the direct/memcg/node reclaim-begin events under load in a
QEMU guest (order, gfp_flags and memcg_id all match).

Where a value passed to a tracepoint is a local of the caller rather than
a scan_control field (highest_zoneidx for balance_pgdat_end, nr_reclaimed
for reclaim_pages), it stays a separate argument.

[1]: https://lore.kernel.org/linux-mm/20260916095122.50cbb620@robin/

---
Changes since v1:
  - Convert the remaining vmscan tracepoints too, not just reclaim-begin
    (4 -> 7 patches).
  - Put struct scan_control in its own mm/vmscan.h instead of directly in
    trace_vmscan.h suggested by Baoquan.

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

-- 
2.34.1


