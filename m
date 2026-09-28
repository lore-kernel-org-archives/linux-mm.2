Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72727CA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 11:47:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76E896B0095; Mon, 28 Sep 2026 07:47:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 746346B0096; Mon, 28 Sep 2026 07:47:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6348A6B0098; Mon, 28 Sep 2026 07:47:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3E8DD6B0095
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 07:47:15 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C856BA0191
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 11:47:14 +0000 (UTC)
X-FDA: 85262995188.30.02425E4
Received: from mta1.migadu.com (out-60.mta1.migadu.com [95.215.58.60])
	by imf14.hostedemail.com (Postfix) with ESMTP id BC8D1100003
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 11:47:12 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZMbaXpCY;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.60 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790596033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7dp/NMyp+gVE/5c7a88ZTWnI2Cw/C5yAIipEkuOd18Q=;
	b=A3FOeZ6pWb2/zYgbhZBISKFTvK365z5m7Jy9e87v6HIF8NTOSlmWkwtiWo3eeWOkJUixR1
	vpcqKCPfiUMXA7UtC6kvmgHM3Kaulf+vQZPpOFtCGMZ7TWUmg/ADjPrGwhaVoeH5Qe1YWS
	chpKDIgfEwG/i4uIanSESh2GCr1nlz4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZMbaXpCY;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.60 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790596033;
	b=cX+mR0GFOHQDJL/aqW0qqUjspfARCgaAlal5ITFs7W1XNkLdkg7GreyubX6uEJ8ABZGjzm
	awsjhtFwx6xp+dhbNvzoT4TeefXkI1uuKR/eeQNEwtAyEqFomqj5EI+yeQ3sY6Avx6lQyV
	VbS3qKAnYk/SS0P+mE/Pmvr9Ls2HmBg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=In3E2YlcEKsWsiEGGDj14MO/bAICz5bET5J21kJrRmg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790596031; v=1; x=1791200831;
 b=ZMbaXpCY91O7ATLD8PGBOX1ewnBTb856xPx7YG5FArpB/nkhIMRKzhf3kP6HvD5gIhinRz0r
 b5wAB9/OjTpz+pxVs0aV5wo4IrQsd0T/B2dHXlrP5EMehNaPh1IIt+NBEf7WwnwepeChwZsB6ZV
 aFzutzmu4p3PiZQhfVq/uaXw=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 776b36e2da87496e;
	Mon, 28 Sep 2026 11:47:10 +0000
X-Mizu-Trace-ID: 776b36e2da87496e
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
Subject: [PATCH RFC v2 2/7] mm/vmscan: move vmscan tracepoints to a local header
Date: Mon, 28 Sep 2026 19:46:19 +0800
Message-Id: <20260928114625.3609130-3-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260928114625.3609130-1-ridong.chen@linux.dev>
References: <20260928114625.3609130-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: p4fybehhwmrcozy4d69gwj7on4jm8sky
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BC8D1100003
X-HE-Tag: 1790596032-206146
X-HE-Meta: U2FsdGVkX1/wIsMd0rHln4m4qN8eDM/rW2mpF+3fsrFeG3as3YF4lLLIPLUT66rgRPBeDJnettNMMOP8qST1Q+PmezeVt1jxKfGvga6IWzAKlNzkONYeS8+uXS2MgwCKNVt4uQ4hgV5XVBTwXQsW0CB92Y3iuoG2tEV0XmltWb9YHT2WEu4qDSJNxALb2aqMXc+IDcza+yvGtulafhbeA4uzlJJSPVW7cKHFDwOkbZeshYXF8vpFtp43E6n1fNqYY2ZONfsxFqYzNurA7tKe/gYStjl4DC9BKnJLDhGW7zawXUs/Mp2D2iLoBDGQkBNaAsQeNoL4JCnsXLC9vmyFvDub2KLv751djumXZ0etsaADzFZKm+xeYeD+PiEGN5Of8NXufHNjMAjEU2F2X8CTGI9hsc5ii+F6KVuzrrTWL59EAlkfkJXEDwOmWx4c7ndPdiFMdmbeVoCLHr3rXqHiH/CcAf2D5qu9G59guE3R10Gm4QzjyRfz852klxZ0T88OsG2tsUDshzVQiSAwMOxKgh62krcVoZZBDrAQf6/lOIqnhpDQghC9EAiDIpsqXF47mzq35XqdJ0wRKqvgSD/CRkz0Kpk8Uhzc8cbf7yAyvmF1r38YiFPbXnJvsq90TFT8X13JfR+XZDVnSq2QCnR31HNvgzkhsaGMa/OZY0oQmVV2jcmfQNoqbc/ghGDhLbDuMjx1uKBFumAFy19HNo6nZXXOY/Arrf5VQrf/EA8k66hontSd54hlYmaAVe028+RdDxA0ELV8FYOoZ5M7e9dMKloy81UtgmONZEnfTVsjJOEzb73dS96mvv2EDSt8ZwLAv2jtfeJQHuQ29ZCGD++W5VuPvoDtiKpf5rsynI6gkn/Zg1uzur/hOJb7ODokRKfQIBX/H2FAqsJMQnbOWXoekDrCW1WUsxiLzK8lZmQITz/td1YcntfLeLZw/Zc0F8TRPTez0UC7Iqgr6G6j2IR
 XaIrDk3m
 yfmlUI9J15Q78vvVev78Wo3E0AjXhI0b/8133Z2RNyT6bUiY3YVOFqG9EQn8Z4yS/faBPZvr7lb5IJFqQEFw91qg++GVmpyR0RAbTB2tL/G4s2EZG+SAxgrnT2TemvmKmcSwS8aVuSsdvzd0lPqNCB1H62dAVq2VQo0isu/l50CHzA5EiLzi2700A+oSjdLTZTyBZTB0YRQ7srgLF1gxjlRuvKGuFmZUCxqAP+uaGAZvarfkt+b96iQnxwkLLcjAZaDEt5bXbftx74EiRjpfSxdww04q5i98wPrzoTfcXaB8Q04cG7pjHqbG5mBr6JJ7/M0ZCHtkIquD+NwpqrZy0CpVGFya9SYRUCPmDFBePJtrd8XugB9mjeffxbvDp9k6XcPYbZoeM5aRZJWIRlCm1uDGTEHhNYDGHQOGkRJAYcenSJPctvEyUxs4CAPIek7GSdN8NOQdYf9fXOOihm1qlMNdmrHiYXPnBTXs2K6QECFY6YkbRAcPs9y7j1vg5+TpaJ6otYBe9GSAKfOe1JI5kqmFEae2gB0QtSDUhyt29uqB00/W7LSfuTcjFHVMfXe4G0N+bSC7/GUPeEOSUOUKX5mmAHRp3GJNCyhnm6t5AVtQ9D+wdDGGccEL0+CmF+sxsnw1W/0gICAvz9dJO4q3oTiWkuTltMAcIM+eK03S3UzAYzviJE8+7PjN5SdNjc7eSpPu90QZacfP2fHd46yYTFCvORiCbHkLrcAMQ2oxqW9ljwmgnguMXLnpsAoQsmBHcXsvJUK0s9O9iZLVlJRK19LTkZUMfpuaFSoiHgAWzae3syG6B44EQd4o4jESI5eIBv05DrBwG69U2Hq3gUxOeuJx+C1Ne4N1mcGWGqKaXYHxVt1qv52lNZtZRnehcyQKX/PPEIZmvBzeRJDPVJLP27cwBRffmzm8eJVpNOexkatFISbTYquMSfOcBzJ1BcrMt/NbQAKwUTCBBUurCCwf4i44Asl8H
 fhfN0fXZ
 4itNBwNZwx4SLz1VOpQHz3iR0BGT3NLtU7llsVmZ1gvXHllLVwS85wxZiHmOa/HuQeDFcovOITKUnZ65j4zbN86GQg4/HPRhhReY6sSo3xw=
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
index 1fc1cb1d1c49..281a6aca73cc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17229,6 +17229,7 @@ F:	Documentation/admin-guide/mm/multigen_lru.rst
 F:	Documentation/mm/multigen_lru.rst
 F:	include/linux/mm_inline.h
 F:	include/linux/mmzone.h
+F:	mm/trace_vmscan.h
 F:	mm/vmscan.c
 F:	mm/workingset.c
 
@@ -17376,6 +17377,7 @@ R:	Shakeel Butt <shakeel.butt@linux.dev>
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


