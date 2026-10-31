Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE9DE606A31C
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 09:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=VO9QeCJo
Received: by kanga.kvack.org (Postfix)
	id F39CE6B05B3; Sat, 31 Oct 2026 05:01:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F108E6B05B4; Sat, 31 Oct 2026 05:01:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4DD16B05B5; Sat, 31 Oct 2026 05:01:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C65E16B05B3
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:01:23 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 60BBBA08D1
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:01:23 +0000 (UTC)
X-FDA: 85382327646.23.7F63210
Received: from mta1.migadu.com (out-61.mta1.migadu.com [95.215.58.61])
	by imf20.hostedemail.com (Postfix) with ESMTP id 548681C000A
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:01:21 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VO9QeCJo;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.61 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793437281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8EAs3QvFvaSFhq2cyIL1T9bjNJc6WlnZgmI91srTaNI=;
	b=L9T/EVN/BEVj8ZCw0KbM5pyUL8+CN6Opl62ZRVn/aB5MBeYQ2IxxMn6pXXvl/OEZ6GwOhj
	gdL714idJeZLmknbnTWQfC66Nc4a4ZfhQkJDEGvdaJIKvpo35vfrnoaoGSziuHJjZNp8IE
	g4T4OyPtBkBxA2hY29KcjyZiU5oG7dA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VO9QeCJo;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.61 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793437281;
	b=SDpgIg8mF7tSS4iRQJm+H/oYy/e1GFqRRL4IqTViuGadL4b9f8s8TBD67ZXrZ+8czpYsIb
	bCcc8xEe5Kg+i37gtVCcWdigazIRaXIeorTqZO2rj6t9hhQJyaW7jKGgyNn/MpUxM6+EJA
	JOmBTgOcLLdP0TvjqInfqKoLp8blwjY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=LMPLkNm0J12/2POSpRky5OUFx70cELWQjCjS53X+ghs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793437279; v=1; x=1794042079;
 b=VO9QeCJo6tA9e7R4mzmG/fTi9CKbqJgpnb57ZmPVL7ZdQcZnKby2sChqxWzTDVT969INNbfq
 eUEc5kIPF1WoSH6RgBugN4FIItl69N/Rnjw+/llWfFjw3LVWCWQzzPTfQwb+R6dENF3sp91PmA4
 CbzB2uvjIlqNz77Jlgaaufcc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id d03afa4a643ee410;
	Sat, 31 Oct 2026 09:01:19 +0000
X-Mizu-Trace-ID: d03afa4a643ee410
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
	linux-mm@kvack.org,
	cgroups@vger.kernel.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	bpf@vger.kernel.org (open list:BPF [MISC]:Keyword:(?:\b|_)bpf(?:\b|_)),
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v5 2/6] mm/vmscan: move vmscan tracepoints to a local header
Date: Sat, 31 Oct 2026 17:00:37 +0800
Message-ID: <20261031090041.58574-3-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261031090041.58574-1-ridong.chen@linux.dev>
References: <20261031090041.58574-1-ridong.chen@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 548681C000A
X-Rspam-User: 
X-Stat-Signature: ewhikiwuo48ghisagma716u78s6g8hyb
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793437281-307840
X-HE-Meta: U2FsdGVkX19nN+M4YKJ3fw7tjgLNEuy+bv80h/u0MwOHSz8xEAMdW61xYD/0Bui6s2DvkBAPAUnUvUG7fC/pBlNl7q6kzOKi9+MhIvi8E5pN4RfUCeANiqlZlX6EkQzmXVj63E7alSK+uGqJ6Irx1gdi7Cq9ZAQPU39xgc4lPT3XPR4hWHBbv3wePYgFVZKQ+2+0JutTsL7rZUA08SjppsPV2QqthUd9IYmU5uaTl6UlCdWyUDlpH8LQUKEGcS39CiSHrmIUeO+6rdWXdEpJvhRZn/PU0xlIKzufoMxFgkOwmJ9Rqdi2KqLo+teMHXDl0rnR48LYODMUc1eGdA/By1pPueYARep/nsVWpzxSG9hV4QqY+kI/V63rQCz4lE8dDHycousJZe6Q6kxnw7+TnBm0ozmcOjiAXCrJGvEnbJO1CYUduxcNKwUeHqMa7gFC0IofQ1gMsQ36iV2xQAxu8b4WngeI0OJHtik0nBo0rLfSnN8xGcfZEWogngczArBsouTOyXvS3v5zkO4KUp4oCkUHkmGK66kfugX/KlgbMkOvoqgfHZhYIF0lJXeo/F/rkAFg1PK6qkW7veAJFki9GIh03lSyZyYufVFOZwrlnPDJXrKqsFIAO5q5yexlglTOYrLyKr6jUGAbxG8r4hGTwiFqEE6vMsjl84rbhEuAK9P+pTcvSPYZmO+3CgB2pSXe+YH9TrmQidOS7OpEPJC6F7fQcJ/EikM8pFdi0nR1n+vqZ1GdaDDHC+10qkeaaQ74FXuDYjl0JvOxfC9wPFU128jg+spre5fix7KDQeZDzM2SClqL4aYophZeQ0k7rA91SK80bX3IC9pHk/GITuMJJZQ+daJUlTsPAgRcCmHI0UcBZOj2Hhz6ViXaijA1nKO1qhjMyEdjsn8039noede5/5Kpi44bKTVhitnrtr7KAYI7ygwuuP+LDLVw3hn26MzH00k5NA/Mo9bAGlQ/wa2
 bvOtwhCk
 UAJGEv1046IdwAxvOg5dKXAQ6fxQn9cPi12RdAT6XAg9ouDPAnSWSr5RnOD/1ubdCee+VN5AhhsgP1rXlz1pJwZ6n1NTRbqRHV6Nr0QKR3PRjByxZdJ/VThBtEvly800zRSSNamgLeA3r8cDzKxJPElngmBGYJ07g7aW0VtkeWn/gmpZtzaWXZy96gb4N9suDtNuLBFZJ56KTNTBS7+FBKfE3DgbXH/7Z92q4B+0UTOpMsX1V0opk3C4N27rTsFzQs1SQYDvtGXT5dbAasnn6cKFwNCjr3cwkI7mCJNM95HhJnUmO+D55Mk1jA9A+RmAjj/WdhEuXxulx47U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ridong Chen <chenridong@xiaomi.com>

Move include/trace/events/vmscan.h to mm/trace_vmscan.h so that the
tracepoints can be extended to reference vmscan-internal structures such
as struct scan_control, which is not visible outside mm/.  This mirrors
what several other subsystems already do with their trace headers (e.g.
fs/fuse/fuse_trace.h, fs/gfs2/trace_gfs2.h, fs/lockd/trace.h).  As they
do, set TRACE_INCLUDE_PATH to "." and add mm/ to the include path of
vmscan.o, the only user that defines CREATE_TRACE_POINTS.

No functional change.

Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
Reviewed-by: Barry Song <baohua@kernel.org>
---
 MAINTAINERS                                        | 2 ++
 mm/Makefile                                        | 1 +
 mm/shrinker.c                                      | 2 +-
 include/trace/events/vmscan.h => mm/trace_vmscan.h | 4 ++++
 mm/vmscan.c                                        | 2 +-
 5 files changed, 9 insertions(+), 2 deletions(-)
 rename include/trace/events/vmscan.h => mm/trace_vmscan.h (99%)

diff --git a/MAINTAINERS b/MAINTAINERS
index aaf2825ac945..2ad01107fa05 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17653,6 +17653,7 @@ F:	Documentation/admin-guide/mm/multigen_lru.rst
 F:	Documentation/mm/multigen_lru.rst
 F:	include/linux/mm_inline.h
 F:	include/linux/mmzone.h
+F:	mm/trace_vmscan.h
 F:	mm/vmscan.c
 F:	mm/workingset.c
 
@@ -17802,6 +17803,7 @@ R:	Shakeel Butt <shakeel.butt@linux.dev>
 R:	Lorenzo Stoakes <ljs@kernel.org>
 L:	linux-mm@kvack.org
 S:	Maintained
+F:	mm/trace_vmscan.h
 F:	mm/vmscan.c
 F:	mm/workingset.c
 
diff --git a/mm/Makefile b/mm/Makefile
index 2a3ec53d62ee..277b97f7f8d7 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -32,6 +32,7 @@ KCOV_INSTRUMENT_vmstat.o := n
 KCOV_INSTRUMENT_failslab.o := n
 
 CFLAGS_init-mm.o += -Wno-override-init
+CFLAGS_vmscan.o += -I$(src)
 
 mmu-y			:= nommu.o
 mmu-$(CONFIG_MMU)	:= highmem.o memory.o mincore.o \
diff --git a/mm/shrinker.c b/mm/shrinker.c
index 4fb424e721bc..4fbdade6d2f6 100644
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
index 8a872990b4be..ad90f0e9bf2e 100644
--- a/include/trace/events/vmscan.h
+++ b/mm/trace_vmscan.h
@@ -648,4 +648,8 @@ TRACE_EVENT(mm_vmscan_kswapd_clear_hopeless,
 #endif /* _TRACE_VMSCAN_H */
 
 /* This part must be outside protection */
+#undef TRACE_INCLUDE_FILE
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+#define TRACE_INCLUDE_FILE trace_vmscan
 #include <trace/define_trace.h>
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 9959ca158ce8..79d2d614afd0 100644
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
2.43.0


