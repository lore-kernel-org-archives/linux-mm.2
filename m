Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0DCECCF2D4
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 03:53:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23FB76B0102; Sun, 18 Oct 2026 23:53:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EFFB6B0103; Sun, 18 Oct 2026 23:53:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 104A66B0104; Sun, 18 Oct 2026 23:53:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9E8456B0102
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 23:53:22 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F2789C05E1
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 03:53:21 +0000 (UTC)
X-FDA: 85338005802.26.98BFD1C
Received: from mta1.migadu.com (out-149.mta1.migadu.com [95.215.58.149])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0C652A0002
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 03:53:19 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OG2ez1ld;
	spf=pass (imf15.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.149 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792382000;
	b=GIDv7mJzFcMJtaXkBZmbaVaCZFREhagYG+CMyOKqogmOxm84PjGDeTJRl3/l4KlaYmTviF
	AXTfA+mmBkggp/iU0YzjxACmeRUVpDjIgakHb5ehtbFEPKiuK4ZbvxN5lprCukf6wlYTdi
	uBcLTqjDJxj/zen50GjjOUe0mLUdjrQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OG2ez1ld;
	spf=pass (imf15.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.149 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792382000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gcN84E3UjnqxU6eKaog7TRLTEvYA/s1zCGcNydSgCxE=;
	b=YS403qJS8t7oJKX+y8ZcR3kJgbyW+0FUNSq7dCJURWZ1z7p8apPl9KXyc9Oku1439zUFhg
	pC31zIhrKdrtCJdcAaU9pwaPIVRUdtEM+GGm88idRiPcNHISKtjgj0UYnIZvyuPlb1MbpG
	SVTF648UYNqsrHLq56IkSeM4kk7BGHc=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=e8l9i2dqh+WprW025KXQLD9b8ygmrBV8jxkpiu2Ku/4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792381998; v=1; x=1792986798;
 b=OG2ez1ldewROnPxlfncxt8/TOHN9tEzKiN7uD3cx2faiyR8TLC5/jEhreOpzuw92GiQuOznl
 jLdtv+j9PO2ziA+EVI8I50NDIfHtDToBcH8lHP8WChiLQ6+Ygz2gMqm2kQcHitCBP2FY5KHKoqK
 szZl+ggBaDC5GXyMAIbdR+bE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id c32a42bc20d1c051;
	Mon, 19 Oct 2026 03:53:18 +0000
X-Mizu-Trace-ID: c32a42bc20d1c051
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
	bpf@vger.kernel.org,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v4 2/9] mm/vmscan: move vmscan tracepoints to a local header
Date: Mon, 19 Oct 2026 11:52:45 +0800
Message-Id: <20261019035252.2357900-2-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261019034426.2354049-1-ridong.chen@linux.dev>
References: <20261019034426.2354049-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0C652A0002
X-Rspam-User: 
X-Stat-Signature: ksanycdptfdigfyqqhz49owfad4kuhi9
X-HE-Tag: 1792381999-265863
X-HE-Meta: U2FsdGVkX195XlAxyEl82nDSTjmXU7Pd6DdsIC4BjWcA1siDmeX5ZD3mOhAIjo6VBEwDaHwSpe5h9TEDvChKSXE5UqLfuSo+A4hwyd8YX9Vo8D/MifoEohH3nCGefqXzxMZOR1cpI/nOXXgbWKS8vVqPz9QqzLnt1SibavWYVEModU4GswGGfa30UISoOHohUMXJQGmwORZg2yZLcjlk62ludmFCfOsy+u1kRh8j+jggkifM8y4pBSSr8iHOtipgwDwh39mIpW5ptXIPm8K4AlWRxTbd4aSCLZ14e9Qd1S9Cy0qQEYbEnCKyuqlADH5MVGSP7PMoWcszibyOVNWx70GAEewOTuPJoscfWZCUVLVidb62zO158Odv64VUE4G0Qmcwhi+VY3vT44HwGEZKjVjw+gHu3oSoNUftIdA+FjqA103qii1vuHlRYVE0UOWnaYaUiSpu9qO01xILOWzzG0EmpgtWUMgFwsj0yCs4obrb6h3tu666XffXSCfH7rYjrlACezabljO43FPKuXxBTxUpahf+nnP5HwnAeRq0SucbIo095heGEjki//KXNztKsBybUTdAh3lUZodKOK9X9hCL4uZCuAZdltPE+QKkQ/6/6ULtWBMmAe8z6Z9yJnzi6707yeXTzwH89mHB/hqcLyTguW24O4k8Tf5rc2FxkpkIShMcMMVzqCRjZHI3tdU8SDERAKet3URo/wCOOet8pVntZPlIaj8WujqTCjM8MUM6Y3mwIZ6qsxJmxAubatdovTh3JXhXe+vqYGXumSiHehTpdfTtyWsmBkox//0fcOj0Z2CQRVNq44rzgIvgC4tivHsu+02LAJng6s+oI7pi/CAJ0zVRQBwN0MUr6txpU/3euJnJdmyklBhAfPUsZjua8cPUGLsw3vLvTBC1+qpcS/y85HlC7RUox79pbXrejn0r1U3yZj3P7txfT0Hzfj4SHhESPawWk3+I+xX21DC
 9J5LtINw
 35lfw1wc+7UBjHLT9avBP5B3ECjAMBsTiXgyQCOlRiShfaEAmUqC3VEpKtQJHOkSNuYVo0WrwrypTG0t0lodObg/DV7c1zQV662/nDr0HPVk3ZH4GoYkVQxy+rJc2W9/5P1jgV8Ha8QXJKIr02zhvrDQ87AbIUggdeBr4m/imSWMxqda4njGeB3CtdfzZ19qvM5WNX0sUpF+6CxVMG2xiZ4HCkk8eIfH5OOUZCYRCw3enjwctp4hB5Pb5EYVIk8puOxBHHJbgAu3pii38nZieTBYQfeCWiVuJXJMhBq6JTXTkAJYCPwGA48A6JVs3OC5twNmVATtpJVzFMkk=
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
fs/fuse/fuse_trace.h, fs/gfs2/trace_gfs2.h, fs/lockd/trace.h).  As they
do, set TRACE_INCLUDE_PATH to "." and add mm/ to the include path of
vmscan.o, the only user that defines CREATE_TRACE_POINTS.

No functional change.

Assisted-by: LLM
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 MAINTAINERS                                        | 2 ++
 mm/Makefile                                        | 1 +
 mm/shrinker.c                                      | 2 +-
 include/trace/events/vmscan.h => mm/trace_vmscan.h | 4 ++++
 mm/vmscan.c                                        | 2 +-
 5 files changed, 9 insertions(+), 2 deletions(-)
 rename include/trace/events/vmscan.h => mm/trace_vmscan.h (99%)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6f1f35a017a6..c41af07e870e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17231,6 +17231,7 @@ F:	Documentation/admin-guide/mm/multigen_lru.rst
 F:	Documentation/mm/multigen_lru.rst
 F:	include/linux/mm_inline.h
 F:	include/linux/mmzone.h
+F:	mm/trace_vmscan.h
 F:	mm/vmscan.c
 F:	mm/workingset.c
 
@@ -17380,6 +17381,7 @@ R:	Shakeel Butt <shakeel.butt@linux.dev>
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
index e82ba737c028..a3538484f8da 100644
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


