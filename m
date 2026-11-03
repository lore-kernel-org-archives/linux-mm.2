Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39B9D606A324
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 02:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=eV5V748r
Received: by kanga.kvack.org (Postfix)
	id 303656B05B5; Mon,  2 Nov 2026 21:57:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B9676B05B6; Mon,  2 Nov 2026 21:57:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C7C06B05B7; Mon,  2 Nov 2026 21:57:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E9F4F6B05B5
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 21:57:02 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 49E8F1A02FE
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 02:57:01 +0000 (UTC)
X-FDA: 85392295842.11.2C8A637
Received: from mta0.migadu.com (out-215.mta0.migadu.com [91.218.175.215])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4C504140002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 02:56:59 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eV5V748r;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.215 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793674619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4jYbJGRPUnmyd0m78ShAbCw2vgRacChEEB07WcUFwz8=;
	b=bld22NNc29YHpIc6q7i5ewGiyQDoTFY4Fy+ZxlzI8aTZW3izVsYkRrseMKWFXcvTQwznQ6
	0Y06smaPVeEemQnhomFHLap+05hNKr4AprSlQti5tPmLLltPnHxMwivAGeMmiilpGJuFoV
	waK0JJPRByH/Uz197cO9ogDLiREqk74=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793674619;
	b=zt+3QL6/sHhxiEytdsKRverlPmilZhqA7hD95ND8xz9YL3/AHJJdZ04PlaEssY/6idU0wm
	J13JNEgbMYr/quZ2djxGMrVGyNvTzxzYgLCPGpw05uie1wA7svpEfVVLax/cfOYcnmTIVE
	Fe7Q6csYVRpJpera9m3QfJiomLyjxAA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eV5V748r;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.215 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=mzUIeXXZbh8ECd3XI3JOV8bjDkJFsAQkq+BqyIRE5Gs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793674617; v=1; x=1794279417;
 b=eV5V748rmvTFaOyE89v278E/EqitfCetg5ONqSlDfkIp/YJfOZCSoLToG5C7MwlU8BTdZAdE
 Gu3Rq1ZxJzjOEtPi9hOh74SfU4HcuLkxTUomWVX0OxR08I6na/J8gxdsWacJm8K3GM4kkV+eU+8
 c6trqK/N804O/O6LpxT65Jv8=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id e6cf6c57cf4c7740;
	Tue, 03 Nov 2026 02:56:57 +0000
X-Mizu-Trace-ID: e6cf6c57cf4c7740
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
Subject: [PATCH v6 2/7] mm/vmscan: move vmscan tracepoints to a local header
Date: Tue,  3 Nov 2026 10:56:05 +0800
Message-Id: <20261103025610.3738894-3-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261103025610.3738894-1-ridong.chen@linux.dev>
References: <20261103025610.3738894-1-ridong.chen@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5ondcnjw4w4kydjxu7oby7znwp5qx8jp
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4C504140002
X-HE-Tag: 1793674619-99323
X-HE-Meta: U2FsdGVkX1+Xs0Jtb8BKrB7jqBBIjRR3fLfjvOLQLfaOPK1N5YHepKGsr7mwGvgBMxrMcxetPFTzugxGEIiubJvbgouyPXZIFt3+oCGA0USaDx2eZ6hOZlHPCFa7bpxJTvZF3cjYiG934HQuq0Z5wL4XhltGwJBA+S5+PBWxDGqs3a3wxbiznuayBYTk+DLsjP9izQtA9BSLC/YkYlLLzf5YTS/bSOgC+J0Mnm7hwvRmBFebMIvL47RCutW12wN2CP+SqBXs30ctITyvmm3fBSdtHZ9B8tZMNbNquHscbOvSBbyW7obCWP8Y0LrSx5Ec3/HPusMrMNGQj0VCAp/sD1xR3hRPspOAfQLOW2VgzoIS5JRL5BLLXDTx/xngSTOjGe9+AbltndWNfbocg+3R56UMlAdgyhc00lmPlMgpG6mWFfDalQWboHV9YiUeQ4KNGh4oaMPyK1DEOeeF2D25U10tEHIc7y07HDh88WeVev5N1XyBlafRm8lhhHEqPDvlegVNONxX/VRg1eyxp53FeZD8vrtnlk5u9zyQ4/oeegZ5ZBoRnjxkiq4MaVHyW4XAREbriY6s7x17KNb/mVoPauwSh9fRsYOIHB+m5NY+5MLBwkI+aJG9jE3wIBDamyOqSRsDQf0QuOBycMIngL5LwsJCLgRVmlnXS/s4FdzT4sg4JwhUneY4d+EQlV8xRd+JpfyWu9Vq1o0cumS2dFWao/A5w50xlmRk4h63vlMOPVpuLHYKvxNMFOf97wDtzLW4PM09KFUJEHdcKp3TY3/wmiQ3zjZ1Zc8bi79vriGJAoXrXUA3rQj7jVq+AMH0WmhwvyqxuN6nQsg1DgMVTaugVIChXx/Uv8FxSR+g8iy7HPf7FizvKU2OZn5S1n4B2uCdhG/w0vz5ZyKT7a6+srwD7b4+tSufn+GEl/9WkR2+AfSq7m2sga1PPl3b8IUrFQPLo1RYTqYPNXrdK3sjEBZ
 BzmizvUt
 Ayec6naj/7S8r8SXbi57x+AgkUquYN8CXO7dxoqZx+pQRP5/WJUIr4HGQvuahu1TClxGZB0hHhKJ2tCUNBaEXIbxskk0IxGftg5o27QSsoScupEsXvk4GCY3Jgvbb23hY0P1aBLMt4ip4C0aVbpaOelaVGfl3l+t3hwdh4k/VIQ7N3++ERzbHdrzbqoTJy7gv/Hfqrob8CQ4AHR2urmbb4bBgRok3OUwmHzTqNicOBZWujlnD//6mcJ0b1GTTbW+wnbjpxVwTbus1kN2xrrHA328zul1e2rGkDdh619xgjynHbRdVU6DEqcAAJf1pAQBLB7YEwuEEbi0H1/eEzcsrUij76A==
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
index f4a6b5735794..95ff3743cec8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17708,6 +17708,7 @@ F:	Documentation/admin-guide/mm/multigen_lru.rst
 F:	Documentation/mm/multigen_lru.rst
 F:	include/linux/mm_inline.h
 F:	include/linux/mmzone.h
+F:	mm/trace_vmscan.h
 F:	mm/vmscan.c
 F:	mm/workingset.c
 
@@ -17928,7 +17929,7 @@ R:	Shakeel Butt <shakeel.butt@linux.dev>
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
index 7ddef3b488b3..b51fae79c6ab 100644
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


