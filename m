Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AEB8C982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 11:46:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 758C36B00DD; Mon, 21 Sep 2026 07:46:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72F9B6B00DF; Mon, 21 Sep 2026 07:46:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 645536B00E1; Mon, 21 Sep 2026 07:46:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 47AAF6B00DD
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 07:46:37 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8D38B120110
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:46:36 +0000 (UTC)
X-FDA: 85237591992.19.39086C5
Received: from mta1.migadu.com (out-49.mta1.migadu.com [95.215.58.49])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7940040007
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:46:34 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=emXUwPs5;
	spf=pass (imf07.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.49 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789991195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=9KP2huCVxHdZydKim3RIpwgCaI94zYs3Y2B46uxUTI8=;
	b=BHstEuIvPc2zrRS9857kPexDktRsvCPKzTvGExoad4mpE+/ZvDfRYOJnJ1sAcnIhwyU/jS
	8UeT7/hN7Eml9TGHPgDAVnD0Ma3h09/G6C+0cTVBBNdtrtNYxlwu0U80mj1PVoHXChZ8Xk
	SOxUsMoyNEOYFl6gsvdxXqyQ5tUhaNo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=emXUwPs5;
	spf=pass (imf07.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.49 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789991195;
	b=M0Gn69g0sZ8HddPCz4yMltrdiiGrL6X0gOl4Wa0BC3Q1Yfta6EDXb7z/hFjE9qPuIt1+m5
	2OCB5WEWp2gh/4yg5AYHZ6MLtiLSzSyhfqn7KtZmHbUpBTLom6K69rpqqgIb0hyRSVs5cX
	R9A9AKGv5xqj5VLqQ8aZj3tMiZQgudw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=XH4B96df4h2G4S3OsyZK9oJZKdg1W5OhLImhYcFRtEE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789991192; v=1; x=1790595992;
 b=emXUwPs5q6S7QVPRLZLXHHVgK7UXwx1kTussRakTgwX0sTeuudPod4V/BBSNaKcY9JLhmQ1E
 l+88AvdhcRs70H60X+jlK+X02WfCbBCCoFJhYGq6xjoI5OQYsXwXATo5il59RtxBDzhqDNhn0Hm
 dP04JhF4Vm6IxG7RVsVS9tKY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 9200fe5b77e7be9f;
	Mon, 21 Sep 2026 11:46:32 +0000
X-Mizu-Trace-ID: 9200fe5b77e7be9f
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
Subject: [PATCH RFC 0/4] mm/vmscan: move vmscan tracepoints to a local header
Date: Mon, 21 Sep 2026 19:46:02 +0800
Message-Id: <20260921114606.3871820-1-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7940040007
X-Stat-Signature: wi6pyr8ptkjhyju4ttxmyxdx7ke6iqw1
X-Rspam-User: 
X-HE-Tag: 1789991194-469168
X-HE-Meta: U2FsdGVkX1/YTP2GwqpJzT22IMjheiH+MLobp7c44UBggV7HDyQz7ag44X5hQ5mSZ92NLLio50a83i+JVMhU6+QePOEeR3ebqdZmHix4FPxtlnJHOWGVfxKA0r9cU+XviVRlYwMZybzQPEeKXLcRadJ1n1IjvFjQbtvQT38XfzwQ+kV/dXuWvS5WN5ND03YvKF7EvwNvESPfa12huj/OmGWY5MeHk36yLN/KzKKyEF7Iq8Mg+cg+d2/Vo70bkA/vJsBQZ80CUuGJdFlpYxRydW7uMvXnxIH2KFh+ngwPuqiLhRKhaGMH6ITd9yr9I69j48y/azeiKQDedxx5TK3UBITWrikMF70aXdIpPyrcRP1C5SFbftUxa+GSXiB+VBgzcCliANNx3a53WjCRvQQmBV/HhBu9Fr95TU9HAGA/k00pZjfo06eTKtUVr/FgkJRJhBKPFXi063iwu/5FCZTPAMHRk0EDEUzWOEAuezxU80nrtuY3bvtIeNmKY6aiE4PgVkf81dW0oZPb8MLbJ0R26CsPYAis6ctg/JcaF0EgAyf+P2JoT6rb2SoUoPbtOJTDDrfBzDF3q1Ziqj5mV7QW4JLhJr6Yymn/mvvyQLfw6YbxbNEyb2oOoZ2agYtgqWZEdIbZstGgpHnV8jkkrWrRyqP6gW05xScRPOunuSsW7zWfgxXA6WxPfgk+en3LZe2vkzF6Rm7XnkhcuKrXlSt0LDUR8cVdphTgii/oORIzpXfp0YsfqLniTANhgD5/W73+OZDO9CUR8SRSnBZLmyRFoN8J77DlUHGKPMHFvomvPYerGA+1/aghxwcOmMoOiQ3QZiqcvJUBbtciat6GMQiea0dV+k11dfL7REVaiD9iQoXDnqdo6n2A52DGqTQmwurm0+3fISCfP/D3o/lS+8SCkXecZfFEElG8fATsr6aj0HSRpDlV0M+DdyXKHpeTAovL9C3Iy4OOnMemNlgBgEM
 QThaFdEL
 dARv+CFVFtqAUxlNvaJqABbXbkx0Y8+0AOQitVIhBOA0Mvwg4nPziC8RcvzTwjJk1kInb5BQYlEhTY0TbbbyFO4Ua7lYDgQyxY6lQlNpul2MLbw5+n0O/lpV0/Kdiy6VK5ExWHIYnTgmckXDJqVf7LFTtynhD2CR/FXp7gdja5TQDvQ8P840BLKKJN9U4h8oHEMjDKC8WmByy0CPG+0RloQEWlEosJd+8XVUk8UL8YJ+n3BKAVHCZeJtnlNzG2zvU/1G0Qpdrn3fnNv4WFJ0xnZ6sPuIo5zwIrQAV4bPyxV6V5WH3A/UUh1ZAxea8cI0T04CXuu3qSaHpjv85NKM8nqO484QeyG3hp6bzPap2T8/Ikfl0iuV4cFb5eAvHLcfEfbShNC4R8VQMrqCuc7VmTItjw3pih6ByiRgarFUigzDJ5JkX3vfk3+oXShA+CCeSi1mfjY3Uvgydic2nG7srGNy+A1gav14pxCWTkTc41Rlw9bePNeZW0nqF4vo0gk8W9wZy1UKKzpkuQB0rGVXBLHGhOlE2z9si3IiUtQM224FJFJ5cguKjeSiYaNVraVBaaYTpA9IIsiyVH1ezD0bky5icZBjjv7L86QPH3mgHSYffAWDaAD7PjNCE48sGEryCdcX+XJBt5DMiONDItubzzwUrtxiZUE089el5fcWmfLYQiXaHfuMihmPCgDHUwVphu7mPQxldtfq4+pIjW58hhR8WEyO5kfOJwsVx1swKDqfdHNQT7qeLQ2GzB4xh4Mjk81Mi1ffLqRJmRq82rLby1JGDijRlHXPP2CgbV23t8wbws8q4AFF6Chx+3BDeHfxFXPuYF0QarFF1+5fqN52emKb1cQiz8dPfBG/M3ka6G7UjW7COdB54jhkc8wGvSexuHLm5NlovZTjPBnJzHn5+H5w4Ac75EWYg5FasvD7svsNu9IY2pNCBNeqQpPwuA0Mo1gJfmOheiAtDoyP5JrimJboQMuMs
 VbjWedM9
 aP3Qzt2AqFicOnnUbH2dKzZgp6yY8rIKGeYqYrDe6qg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

Background:

This series started as an effort to add two tracepoints for MGLRU. In the
discussion, Steven suggested moving include/trace/events/vmscan.h to
mm/trace_vmscan.h [1], as several other subsystems already do. Once the
header lives under mm/, struct scan_control can be moved there too, letting
the trace events access its fields directly instead of having each callsite
copy the scalars out by hand.

The series builds in four small steps:

  1) drop the now-unused vmscan trace include from memcontrol.c;
  2) move include/trace/events/vmscan.h to mm/trace_vmscan.h, using a
     relative TRACE_INCLUDE_PATH so no Makefile change is needed;
  3) move struct scan_control into that header, guarded against the
     multi-read that define_trace.h performs;
  4) pass scan_control to the reclaim-begin tracepoints and pick the
     fields out in TP_fast_assign.

There is no functional change and no ABI change: TP_STRUCT__entry and
TP_printk are untouched, so the exported event format is identical. This
was confirmed by diffing the tracefs format files before and after, and
by capturing the direct/memcg/node reclaim-begin events under load in a
QEMU guest (order, gfp_flags and memcg_id all match).

This RFC only converts the three reclaim-begin tracepoints
(direct/memcg/node) to take a scan_control pointer as a first,
self-contained step. Other vmscan tracepoints that currently spell out
individual sc->... fields can be converted the same way once the approach
is agreed upon; 

[1] https://lore.kernel.org/linux-mm/20260916095122.50cbb620@robin/

Ridong Chen (4):
  mm/memcontrol: drop unused vmscan tracepoint include
  mm/vmscan: move vmscan tracepoints to a local header
  mm/vmscan: move struct scan_control to the local trace header
  mm/vmscan: pass scan_control to the reclaim-begin tracepoints

 MAINTAINERS                                   |   2 +
 mm/memcontrol.c                               |   2 -
 mm/shrinker.c                                 |   2 +-
 .../events/vmscan.h => mm/trace_vmscan.h      | 143 ++++++++++++++++--
 mm/vmscan.c                                   | 117 +-------------
 5 files changed, 138 insertions(+), 128 deletions(-)
 rename include/trace/events/vmscan.h => mm/trace_vmscan.h (81%)

-- 
2.34.1


