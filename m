Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C51BA606A32F
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 13:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=qI+ArD6G
Received: by kanga.kvack.org (Postfix)
	id CFFFA6B05D2; Wed,  4 Nov 2026 08:09:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD68E6B05D3; Wed,  4 Nov 2026 08:09:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C15056B05D4; Wed,  4 Nov 2026 08:09:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A15986B05D2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 08:09:09 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1C81BC0730
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:09:09 +0000 (UTC)
X-FDA: 85397467218.23.729CD0E
Received: from mta0.migadu.com (out-147.mta0.migadu.com [91.218.175.147])
	by imf28.hostedemail.com (Postfix) with ESMTP id 20A34C000A
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:09:06 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qI+ArD6G;
	spf=pass (imf28.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.147 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793797747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mMj9DsaokfZtgsqnV6TFbPevB3nCiHX8pv9BJn7VaUQ=;
	b=Y7RBmkrhYkD06GKopqRm+auFBhOIYpaBWKIAnCqlpwaBYQOsUo25ka2zfVFPo8uazSnz+E
	E0m74HxZUZrzcE7BeoiizVgUlxh55s/HXHxRfYWfAX+BNFFni/8+BzOLqIrxGhWWSTjakG
	ybtLepzyaf5aiTq+bTIna36TMWANd6g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793797747;
	b=2qwEd4kCXtdcQRSmQ1Q8RHnID87bcMn2hAuU0OlQD0tKWPDRUT0VZEzXM/wJEdAMLcp/ki
	ILg5ecerOF2p9qJ5nGC87Puq4lt4s5Y3eM4c6AvwG1KSHm8MvpIo3mtsRf6+AGMbHf//st
	wv6pJtkQHLzxBiV9F4sCPk2BatFH/YQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qI+ArD6G;
	spf=pass (imf28.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.147 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=3mp35FVnC01ZETH9MQAgpB4MjCtcUcbT1L9D0SvFH00=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793797745; v=1; x=1794402545;
 b=qI+ArD6GB3vrgT+gZub3OCA5td7KP2iUh8p2fDpW6hXaaLiTOJNrI74PCTJjG/vCFtEIx5iI
 HsRySXzw+cexcTIOVPOKK+XAHT5DM2fRyIGYO3+QgSLxr0i3B0EUAFuBOaVim/2rrRt5R2YqFk+
 jVmgcvdKaBqrrTxqzIxW5VKc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 2c69226caf1c61eb;
	Wed, 04 Nov 2026 13:09:05 +0000
X-Mizu-Trace-ID: 2c69226caf1c61eb
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Dave Chinner <david@fromorbit.com>
Cc: David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Muchun Song <muchun.song@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	cgroups@vger.kernel.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	bpf@vger.kernel.org (open list:BPF [MISC]:Keyword:(?:\b|_)bpf(?:\b|_)),
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v7 2/7] mm/vmscan: move vmscan tracepoints to a local header
Date: Wed,  4 Nov 2026 21:08:12 +0800
Message-Id: <20261104130817.849089-3-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261104130817.849089-1-ridong.chen@linux.dev>
References: <20261104130817.849089-1-ridong.chen@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 20A34C000A
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: fjkyrzxtsgkm9uk48wwbkcas43ehb43t
X-Rspam-User: 
X-HE-Tag: 1793797746-389869
X-HE-Meta: U2FsdGVkX1/Ketx/oChBL5UJJNBfNYYVsvlqHem492eQDiHWmH4RUSy2CTLKUVLLmGPhqoZIWFL4pE/PXRpKWI9hYPe3xUze2ZJQ9QLdAi0gXCwp+FgdBL7lVMR13fnXxoUbrhKckciWEHac1304qAG4Fw93dIJYRXodUgY3aAnjmLL2QEmSmMdbHsinBJT7PCqlHiT/De1kIBoQkNRjjpz1uXPuxJ7WYBwHfNmAS0N3gupdrSQ88iaj6Uet/YnAYv0P8pi2kEjsiEAuqM62IY0Qcs8ZZlfQmkFz7ZqITXNO+Ac+o9UQFE4NYF39I7OdKeFfTGM3ryo8NYhWALbQPu9auE3flOybcyXToH3Y4DZLrXYDMLSaAeRE6da3gz8vOeWy6shKA5tICFLpMkWn9MLbb0aRb2hsQ019tZrpF1yTJKv8zvdgwWwJWuKJVVRHImpoWNcqGYKa+GKoFsXtgpfg1Ckut2iMjglugU2tkJJ/UrzN0ppvJnoO9DSw0jtvibXPomJBAFEaoFN3nVMQng0Wbbvz/wAXpu6e5JYwHRL+DaYLfEz8yk2w5duEwo51JJ7NB9avDMqiUkZZKAx1oYGMUcJKOCd6Qxb1clsSuAU54poUwRm3uTrL+kbsxcgAATX3CjRlBFF7Hrnqbk9JolcNZ3G0NLPM9naaKmWusLlkExoI/BdY1r1ku/D3gJnwOZtqlc5pySWoGyHaPkYRNx0ZCmhaWzK6+stn5QP4Cwg6KCZk16mk/PLMjYkE4gVWBNoy0EhSg/6Oc/B5EbFs5vFU67HfNaDTUamC2U4RJcQ+I4srJQZ+BZnPI68YYUR8ZkvO+Pmc8a015Vot2+pRWAf6wUh/rzFlQihn4cw1a9KnCkfrL9T61tSq3NLFGXHgLveUy2tw6lJ3EM/S8SyM6XHNJMp2YkExjw56vbU+lhRV9nNBu5jFsLqwjDbgbiRqjj+vAhGt0OARycRmAMy
 WbRe+4cR
 mxXhXAMtCIn3xcLA8cCYHmLt5rhPeIHc5NuBMinxY1AvhYPymlx2nB/agwntcLqsy8hRtaNduK7IiEpFnQUy+Mk8pQr6w5r826DqBDrSZz9JGN41rZcQtQT+OJDvzm+KC4Z9bUbs9ZneyIZpMDB56H9ASYcuhyaqiXcp2XyfdG+jwKiKPI8VAR22fm+33WaLRcVGpwEZ4a8Yhe9C1RNOOk8atMZWxPmO58huIpZ5Zg2+nflHSKkZ9q4D6/Mvvju+h++9BWGD6B81Pi18asAAMAtbeMBpgQZFQNhLlvXYyHGvCZbVvzP9gpCyq1k1zH+1iW6KsLOfNRRDi5DgRMHMYGFPeTw==
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

Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Acked-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 MAINTAINERS                                        | 3 ++-
 mm/Makefile                                        | 1 +
 mm/shrinker.c                                      | 2 +-
 include/trace/events/vmscan.h => mm/trace_vmscan.h | 4 ++++
 mm/vmscan.c                                        | 2 +-
 5 files changed, 9 insertions(+), 3 deletions(-)
 rename include/trace/events/vmscan.h => mm/trace_vmscan.h (99%)

diff --git a/MAINTAINERS b/MAINTAINERS
index d63d8b215277..828e81ea671b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17641,6 +17641,7 @@ F:	Documentation/admin-guide/mm/multigen_lru.rst
 F:	Documentation/mm/multigen_lru.rst
 F:	include/linux/mm_inline.h
 F:	include/linux/mmzone.h
+F:	mm/trace_vmscan.h
 F:	mm/vmscan.c
 F:	mm/workingset.c
 
@@ -17804,7 +17805,7 @@ R:	Shakeel Butt <shakeel.butt@linux.dev>
 R:	Lorenzo Stoakes <ljs@kernel.org>
 L:	linux-mm@kvack.org
 S:	Maintained
-F:	include/trace/events/vmscan.h
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
index 7db6be53f3a9..35d4e912660f 100644
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


