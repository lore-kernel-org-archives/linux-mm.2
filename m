Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1B3DC982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 11:46:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D24B06B00E2; Mon, 21 Sep 2026 07:46:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD5686B00E3; Mon, 21 Sep 2026 07:46:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C12396B00E4; Mon, 21 Sep 2026 07:46:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 949016B00E2
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 07:46:50 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2071340161
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:46:50 +0000 (UTC)
X-FDA: 85237592580.04.C179042
Received: from mta1.migadu.com (out-65.mta1.migadu.com [95.215.58.65])
	by imf05.hostedemail.com (Postfix) with ESMTP id 09EDE100003
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:46:47 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CgvFSGfc;
	spf=pass (imf05.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.65 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789991208;
	b=ahjiuG9q6dEqNA2jLaLUkwRYtARmctKlE8j/ZUy8bqPGdD8q/+eJkHbg/DXhOdDxozUV+m
	fjfW7x5y4iIGkvW65VOoBGjIxvgA7m7VJXelBIYmDS9eeLNxwS+zzbPqulrH7Zo1eD+/k5
	/g+A/q9EvlgXTh2TPhUWTjRBTYtiy+4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CgvFSGfc;
	spf=pass (imf05.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.65 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789991208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kCFhgHwbdJtcM4Gx3avSoD0F/RnEI2/oQi3DgfsdHug=;
	b=TWpUP32xKtwRmTqMeuRhyKeb+ljEfjZ6YkkePBVAmiriTOE+4Kd2OwZnUGnKZG2pzavjPy
	3fZt1Usiw9CEjzLip57/B7wVi66Qw3wxKhmsj490ji23nQar5HJuJfa5c3hiR4vEyp20D9
	g7ddIJa5Wqa4xp10Q58tiXag9ZURSyU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=MtpBUFbzYu1oiksXdT+2b1TI1k9PS5Y6zJeNKYblZfY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789991206; v=1; x=1790596006;
 b=CgvFSGfc0f5mkgkhlKI3hvsEzJAbnIiw+COZbsZQYEmR1ZlbwrsbLB/EC7g/1KwaQzZzeudY
 YsWajDQ5z5xzq/2GEajOC0IQUYKIfd8F6bmOr3882exYnOjWWh9QKfhjZ21vao/wBYYhH89xT42
 B5osjB2vIMC/fBOyOZh+LL6Q=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id a9ffc5cf04c1e7d3;
	Mon, 21 Sep 2026 11:46:46 +0000
X-Mizu-Trace-ID: a9ffc5cf04c1e7d3
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
Subject: [PATCH RFC 2/4] mm/vmscan: move vmscan tracepoints to a local header
Date: Mon, 21 Sep 2026 19:46:04 +0800
Message-Id: <20260921114606.3871820-3-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260921114606.3871820-1-ridong.chen@linux.dev>
References: <20260921114606.3871820-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 09EDE100003
X-Rspam-User: 
X-Stat-Signature: jeqruo89ndb3b1mdwemjeck3bmqmrr3g
X-HE-Tag: 1789991207-997833
X-HE-Meta: U2FsdGVkX18Y2csFTeMXWPIW3e/ve6rfE1myJm2KaG+yd4eS43iDx+wrUG0eOt+pXaar86j5Ozo9iSru7XHmwCzp9fNIsYCh0JReHLbIYE5EDewIrVDrfwuDmRvHqNnfeHj8kL8miQ0vSy9pkAECgF9OSjQMYK306LlZq95aLV/XTUsaDPrdeF/6Vdqzh7+wR7hFzUbWBHq7MU7crqF4U30AyXSd8y61tD8CyNB/Tutz4ADgOfyPvPsUBXpjoEHz67mDYxP73W0QuTt5kwYVS54/ehgSk+vlEhcsz+QAltiyMg30a5nWuvUGhdLf/LYWSnNchou6hcnc8jdBGYeUc6VhEm0Wsw4baubHwCae24FIdoArQXsWAR7+LhNbMmQ/sqCVDpqubWdWVyEU6R9kHAKkdpzwcoo2LByiIL9U+87Dt3l7Xnllvm42imaPDysEsQjgLbAWR+XVDJj2t7G/54e7XyPr1IQiQcckJcKU3tuUlzZ5QKV/x9Ny/NrQvUqTulr5fs4JLNlKSC644StIWn4Xji0/92F307vQN5XUcIdhQasfcHrlxDt7vwtup9muLZr36+0USFf+EWfN08WwZePj1Fn76ULdubj5cJhLL0WaJihrNBIyFZSnAU7tOlzQHZLx/9b4b2GnuLZoa5FY05hnI6DnA87k4gSPa3LkVupBC49pEwbInmM4E7zChhkdwgSj8dIXQjPYMX7p1yLQnWIgrvCfML71UNrCeCuzfYIwujm9Mfo2tHXKvjZM2Y5RKVjCglloCmFW+7CWNetxss+1mBfWhme5HqCEEA1f+67eCifbFHf5XkkAK1XPtzt/CDLxITlUEaOUwOfjXKnAzPpb+R1nup60WhOcTxwmIhBziw+obZBz7yt7OC4KgIbjSOyRZU4L/zxBBlcPzzsvUTV6yZnMV+FNM+EQbD8pXPTCjiff5XeYPgewRsKLyGMahXXzbhXtlr9PuxsCHY7
 YMBOTs/h
 WSYM6Dr9wsDjnW440Qz3W+chcIJzQDzyb1Ox2I1Z2FKFCno5GoZJ6s1If+W2+/xiNcueVoyE/XumD+0iE/s0vA6/k5efKRrJyOr206xCm/ZDZfYsr3EcT5KSPs7VmGMgd3W7tR02UEJxpELgqVJgCyuOEjvRgAHQN32pG9rHysaSURdulT15FLGTg8TBGPzOhrWqiEywAAyArA+wpA+n+IUmLTC5GSOqlY7Bl4KxzI1esyKoHSJbal+qkNHiS/rmpEvSTX512rISGe50NQ/LwJnL2e2FQSIgXI/Qe2vjzUnCKxCZgHtXpAvqNkpyJVBEQh3eBlOBvVinRMcaKN6SvyaKySGmAW6KGnRJiebIjOQJ9GIp884U8phsabc2CgjRw6McnT2yieaTZm6LgNHfYfA8Jm5TRhYoguBogRb5PcxuihbykIwy3/JYy0Y23PAC/chQlgvW9AAWpUQ6V2DIuADFe3mhRQDDmDEGDKTxnlSpSQyjHlc/D9wOgPMEr09nLNbLXBLGnDf9ETU17rY1bkLPAlr2g+r8q7gL8ppM/Yjuj3D/dsCHPtGlvojYxoKRxxtlrfJ8cDT2C4ZrHSKZe6ZfBF1XlmD5vN1ubEqaxocirWfApa0HO2UB9wRdGwqJ2J4VepFQo1MBskLN9gGbrgAx3sCyhQWjfMd174uTDzjP71FbNgyrZAgIqGRv47Z2IOS+EoUN8uRFynujGZflBS0amnhE3h1NrN8YRnPUvHwFgwCoHab3lY5INso2WMyiVtRaAk+xuijf1mppitq6eJSl2JoMPXp3Q3skg5D3YFNtnY+PxQKbcv99zqO7aVXY/9a9q6XSx0YbXz9gU+lYtgp8EimEpq+i3qjZYr5pUb34Yo1WTLdmuW2sLDQxHoV1t1DujmstNotvNjfFDDaMxM53tMfqDaXn+o3VyST7R2M/L7DgFc0RDzR1d1jSN3KjAIs5/T3bA3T045GcrdE3ShySfp0I5
 d1xvKdu5
 nrN/s2AoCCqL//bPHRQD/oeAMBHeqQB9KIy+pAAIM35BMPT9Bw4Yl4j/rawe1NekR0HCNnACZ9xjvHbusKSJa03WuptZe7JHL+SmUV67Kps=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

Move include/trace/events/vmscan.h to mm/trace_vmscan.h so that the
tracepoints can be extended to reference vmscan-internal structures such
as struct scan_control, which is not visible outside mm/.  This mirrors
what several other subsystems already do with their trace headers (e.g.
fs/ext2, kernel/trace/trace_benchmark).

No functional change.

Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 MAINTAINERS                                        | 2 ++
 mm/shrinker.c                                      | 2 +-
 include/trace/events/vmscan.h => mm/trace_vmscan.h | 4 ++++
 mm/vmscan.c                                        | 2 +-
 4 files changed, 8 insertions(+), 2 deletions(-)
 rename include/trace/events/vmscan.h => mm/trace_vmscan.h (99%)

diff --git a/MAINTAINERS b/MAINTAINERS
index e26b963d4001..c1dbb35273c4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17227,6 +17227,7 @@ F:	Documentation/admin-guide/mm/multigen_lru.rst
 F:	Documentation/mm/multigen_lru.rst
 F:	include/linux/mm_inline.h
 F:	include/linux/mmzone.h
+F:	mm/trace_vmscan.h
 F:	mm/vmscan.c
 F:	mm/workingset.c
 
@@ -17374,6 +17375,7 @@ R:	Shakeel Butt <shakeel.butt@linux.dev>
 R:	Lorenzo Stoakes <ljs@kernel.org>
 L:	linux-mm@kvack.org
 S:	Maintained
+F:	mm/trace_vmscan.h
 F:	mm/vmscan.c
 F:	mm/workingset.c
 
diff --git a/mm/shrinker.c b/mm/shrinker.c
index 7ec2a9704f6f..3c3e87c4b61c 100644
--- a/mm/shrinker.c
+++ b/mm/shrinker.c
@@ -3,7 +3,7 @@
 #include <linux/rwsem.h>
 #include <linux/shrinker.h>
 #include <linux/rculist.h>
-#include <trace/events/vmscan.h>
+#include "trace_vmscan.h"
 
 #include "internal.h"
 
diff --git a/include/trace/events/vmscan.h b/mm/trace_vmscan.h
similarity index 99%
rename from include/trace/events/vmscan.h
rename to mm/trace_vmscan.h
index 8a872990b4be..c5d824fef554 100644
--- a/include/trace/events/vmscan.h
+++ b/mm/trace_vmscan.h
@@ -648,4 +648,8 @@ TRACE_EVENT(mm_vmscan_kswapd_clear_hopeless,
 #endif /* _TRACE_VMSCAN_H */
 
 /* This part must be outside protection */
+#undef TRACE_INCLUDE_FILE
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH ../../mm
+#define TRACE_INCLUDE_FILE trace_vmscan
 #include <trace/define_trace.h>
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 91295070ca33..0eb7fa8e1d43 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -71,7 +71,7 @@
 #include "swap.h"
 
 #define CREATE_TRACE_POINTS
-#include <trace/events/vmscan.h>
+#include "trace_vmscan.h"
 
 struct scan_control {
 	/* How many pages shrink_list() should reclaim */
-- 
2.34.1


