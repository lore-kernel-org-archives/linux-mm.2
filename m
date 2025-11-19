Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E4CECF3185
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 10:00:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF2316B0024; Wed, 19 Nov 2025 05:00:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC9A46B002D; Wed, 19 Nov 2025 05:00:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADF716B002E; Wed, 19 Nov 2025 05:00:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 949C66B0024
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 05:00:10 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4219812F580
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 10:00:10 +0000 (UTC)
X-FDA: 84126910980.29.17C7078
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4543A180009
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 10:00:06 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=tVgeMTXm;
	spf=pass (imf06.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763546408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=D4O0opZ/OFA/+IIFkS92viMctiZDX4MAOGWcfGTkr+w=;
	b=12A14P5cPNM0hYCylSyMq2ZUo6gb5IQByGc4byqKIRsN1U/i55a46cmkJjwgY0N7xFt3ym
	CNJWb+5bx4+UIFRpn1nAAMpoKYCSZRnJT+XVNuUNRZp5LZwDuK1bcwKcD/lUyraCpj/etc
	rF3WnDfkW4Dv1LYi9mtHRClXPVM6PGg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763546408; a=rsa-sha256;
	cv=none;
	b=mi0Vp0d0dJ9Nt7UqpSnyymHwpIRu/ec5SCiN/qf/WfQSlCkmoNbrIvuynG4bp9yl/6Ur0P
	iwZi8YYNIcRFuCAduxwyVsvH+gyeOMHaZ58mbQlSD+G6feHLsk7khvfb86vQFVz818NS/z
	lsTKKC85ONk+MtjcD2wKy5SaRuIgkA8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=tVgeMTXm;
	spf=pass (imf06.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=D4O0opZ/OFA/+IIFkS92viMctiZDX4MAOGWcfGTkr+w=;
	b=tVgeMTXmNU0Njc1cg5QPWH5pPTLf2rIOcUS3j8WiU7UV2Z/MxTlhmSb/tTBVPMAWpxGAAowu1
	Qf1SYectQSTFwasuEG5G6HGwV1q3zs7kNTA5I4RF9wncMjX713KyvA6lPKvZ+erz9kD8yclY9CB
	LDn8k4q0lKWlcz5CaF6FRYU=
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dBH4B0JNdznTWH;
	Wed, 19 Nov 2025 17:58:34 +0800 (CST)
Received: from kwepemj100009.china.huawei.com (unknown [7.202.194.3])
	by mail.maildlp.com (Postfix) with ESMTPS id 84908140135;
	Wed, 19 Nov 2025 18:00:01 +0800 (CST)
Received: from DESKTOP-A37P9LK.huawei.com (10.67.109.17) by
 kwepemj100009.china.huawei.com (7.202.194.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 19 Nov 2025 18:00:00 +0800
From: Xie Yuanbin <xieyuanbin1@huawei.com>
To: <david@redhat.com>, <tony.luck@intel.com>, <bp@alien8.de>,
	<linmiaohe@huawei.com>, <nao.horiguchi@gmail.com>, <rostedt@goodmis.org>,
	<mhiramat@kernel.org>, <mathieu.desnoyers@efficios.com>,
	<akpm@linux-foundation.org>, <david@kernel.org>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>
CC: <linux-kernel@vger.kernel.org>, <linux-edac@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-trace-kernel@vger.kernel.org>,
	<will@kernel.org>, <liaohua4@huawei.com>, <lilinjie8@huawei.com>, Xie Yuanbin
	<xieyuanbin1@huawei.com>
Subject: [PATCH v3] mm/memory-failure: remove the selection of RAS
Date: Wed, 19 Nov 2025 17:59:43 +0800
Message-ID: <20251119095943.67125-1-xieyuanbin1@huawei.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.67.109.17]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemj100009.china.huawei.com (7.202.194.3)
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4543A180009
X-Stat-Signature: tfy5o7b88c1srnt3dqiwa1xcwg6dmc6k
X-Rspam-User: 
X-HE-Tag: 1763546406-905935
X-HE-Meta: U2FsdGVkX18rFfc0OeMCxR3Ge2SAySgMWCQt90VKKAxgYGg4wGGh86fqKUcHzD5/LzSMSET24GGFDVrCSKh5vxFLDWUS2FebEjxWN7DQXwtU4dnWEkV3iV4VGpT4t7QK2y9Au3sHmkMaCvIa6ikdlHSUXCa05wpXtZwzw3QIM96y5fu5nYgj1H04bhbXDGjyXTx2jwvwzCtoYHXDjkV2Wm47rAm3wtQOwHO9dDLjRAjjaTeIfc6iv4EFbNykaOxFggHzpX4nyxkRekLI6UtBIHulH43Sxx97ni0xN/uH0OLJuRyyY+AfhoiZN3UsJZAue8hFtEQPqNWU7lw+miWz4ZEtbfCQBz7SS6UVNBivEJ9zvU0975AuV8uPkQDLqrOSyw0c9o94Kwwxr8QHfZRu5F4QVqDI73WoZwsQo9jlJMxpmj4ItyFEOq9nLNKuc0pSgMtdJ+IAVtp6ybN5gdCmz2rAJUSHj3dB8KPtGCVjfV1OWO39DTkQjGKaZSFxKjFi4QsCl/SlmQXzYnU9HT4jxEe96cI1EBVM0jwE9Skl4oHw2aJUORjOGoHiqCQ5WCCNZzDnnPUMPHZhZIdqNUXjGr7MNndQiK9unnnbUaz8BlkTL7sngG13ecs56Yb1/iGRhvlMoJ4/ati/z+/HBjT55LqgCPtDgKDspOXOhDkli82AeeS5Zv/8F9EsUrgA+ill0Rk7Va4rATxUn5uLp5mybDq5CzsrUgGOuAA/5KfdkKsqajkSOSxORpOKdXGx7fjSlEwQzkY9KEDrP3jwvZLHM+ml+59SjAN9LwZmBAGxLdB6u7hies/ut4Td5y7vHkn7MWU8ldHSWJ8vDDQxbOV0OPUEJUrVJ133mnPOCwcte4lqw6+xCckXOp4xQzExD90Hdnk3nSeAmc5jNAZoe8PB8dqwesvW0pszsvO3k+fmY1DtE1CnoWtmCmeDdEkyvfGkKTy8grceD0gMMFApmwq
 KJqcj6aE
 dBtkMIweTvIpl+Dj+pOetyMOvydwGcSIV/v/9IM6xe+vxEjhAVeNrEWnG1zLcFZjSCl+BQe73rl7ZGErdNvMbVQR2u0mTIIKHb4tIbszVdqSNoGEef2OczRd2wA0HKA2TLZSF0q5H1dpgBon6M8yV1BwrbGgnZgEGQM2z7wFlxtu1+JSuN8o9DCXAuhSyt75pPcd1ganD/T23NFHQJxSW0YXTAPdJExFXlLktVr+b/MP8BLSUGX5u4cNAwvfnO85qSlvvTgyz4aKXxOlJFh/Mi94dPhat3U3nhxENdfNqOLpFAsyg/4qvDszxbu2TqaVG95lXqBsCeexyRZN4oAMcZrjcKL8AuAxYB2hgyXUEY8bHxz0CacxMGTaYs1RcZbZZXgbT7YneT0APBk6388saxpJR51ZiLaAtEeSXDuadqKmYMQF7Mgie0medwPvI3y+34QJn5vYfdkyCR2MvlRJnJu6jGsg60JllfElbnW/VnRXoIq5AARPcUACOjqQDG4MjhUNzEPjkGYNesgp8nwYZ1oyvzFC/vDGSM2bCl/YHaqQ2N2VpHHx8C+PQnQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The commit 97f0b13452198290799f ("tracing: add trace event for
memory-failure") introduces the selection of RAS in memory-failure.
This commit is just a tracing feature; in reality, there is no dependency
between memory-failure and RAS. RAS increases the size of the bzImage
image by 8k, which is very valuable for embedded devices.

Move the memory-failure traceing code from ras_event.h to
memory-failure.h and remove the selection of RAS.

v2->v3: https://lore.kernel.org/20251104072306.100738-3-xieyuanbin1@huawei.com
  - Change define TRACE_SYSTEM from ras to memory_failure
  - Add include/trace/events/memory-failure.h to
    "HWPOISON MEMORY FAILURE HANDLING" section in MAINTAINERS
  - Rebase to latest linux-next source

v1->v2: https://lore.kernel.org/20251103033536.52234-2-xieyuanbin1@huawei.com
  - Move the memory-failure traceing code from ras_event.h to
    memory-failure.h

Signed-off-by: Xie Yuanbin <xieyuanbin1@huawei.com>
Cc: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Miaohe Lin <linmiaohe@huawei.com>
---
 MAINTAINERS                           |  1 +
 include/ras/ras_event.h               | 87 ------------------------
 include/trace/events/memory-failure.h | 98 +++++++++++++++++++++++++++
 mm/Kconfig                            |  1 -
 mm/memory-failure.c                   |  5 +-
 5 files changed, 103 insertions(+), 89 deletions(-)
 create mode 100644 include/trace/events/memory-failure.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 7310d9ca0370..43d6eb95fb05 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11631,10 +11631,11 @@ R:	Naoya Horiguchi <nao.horiguchi@gmail.com>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	include/linux/memory-failure.h
 F:	mm/hwpoison-inject.c
 F:	mm/memory-failure.c
+F:	include/trace/events/memory-failure.h
 
 HYCON HY46XX TOUCHSCREEN SUPPORT
 M:	Giulio Benetti <giulio.benetti@benettiengineering.com>
 L:	linux-input@vger.kernel.org
 S:	Maintained
diff --git a/include/ras/ras_event.h b/include/ras/ras_event.h
index fecfeb7c8be7..1e5e87020eef 100644
--- a/include/ras/ras_event.h
+++ b/include/ras/ras_event.h
@@ -10,11 +10,10 @@
 #include <linux/edac.h>
 #include <linux/ktime.h>
 #include <linux/pci.h>
 #include <linux/aer.h>
 #include <linux/cper.h>
-#include <linux/mm.h>
 
 /*
  * MCE Extended Error Log trace event
  *
  * These events are generated when hardware detects a corrected or
@@ -337,95 +336,9 @@ TRACE_EVENT(aer_event,
 		__entry->tlp_header_valid ?
 			__print_array(__entry->tlp_header, PCIE_STD_MAX_TLP_HEADERLOG, 4) :
 			"Not available")
 );
 #endif /* CONFIG_PCIEAER */
-
-/*
- * memory-failure recovery action result event
- *
- * unsigned long pfn -	Page Frame Number of the corrupted page
- * int type	-	Page types of the corrupted page
- * int result	-	Result of recovery action
- */
-
-#ifdef CONFIG_MEMORY_FAILURE
-#define MF_ACTION_RESULT	\
-	EM ( MF_IGNORED, "Ignored" )	\
-	EM ( MF_FAILED,  "Failed" )	\
-	EM ( MF_DELAYED, "Delayed" )	\
-	EMe ( MF_RECOVERED, "Recovered" )
-
-#define MF_PAGE_TYPE		\
-	EM ( MF_MSG_KERNEL, "reserved kernel page" )			\
-	EM ( MF_MSG_KERNEL_HIGH_ORDER, "high-order kernel page" )	\
-	EM ( MF_MSG_HUGE, "huge page" )					\
-	EM ( MF_MSG_FREE_HUGE, "free huge page" )			\
-	EM ( MF_MSG_GET_HWPOISON, "get hwpoison page" )			\
-	EM ( MF_MSG_UNMAP_FAILED, "unmapping failed page" )		\
-	EM ( MF_MSG_DIRTY_SWAPCACHE, "dirty swapcache page" )		\
-	EM ( MF_MSG_CLEAN_SWAPCACHE, "clean swapcache page" )		\
-	EM ( MF_MSG_DIRTY_MLOCKED_LRU, "dirty mlocked LRU page" )	\
-	EM ( MF_MSG_CLEAN_MLOCKED_LRU, "clean mlocked LRU page" )	\
-	EM ( MF_MSG_DIRTY_UNEVICTABLE_LRU, "dirty unevictable LRU page" )	\
-	EM ( MF_MSG_CLEAN_UNEVICTABLE_LRU, "clean unevictable LRU page" )	\
-	EM ( MF_MSG_DIRTY_LRU, "dirty LRU page" )			\
-	EM ( MF_MSG_CLEAN_LRU, "clean LRU page" )			\
-	EM ( MF_MSG_TRUNCATED_LRU, "already truncated LRU page" )	\
-	EM ( MF_MSG_BUDDY, "free buddy page" )				\
-	EM ( MF_MSG_DAX, "dax page" )					\
-	EM ( MF_MSG_UNSPLIT_THP, "unsplit thp" )			\
-	EM ( MF_MSG_ALREADY_POISONED, "already poisoned" )		\
-	EM ( MF_MSG_PFN_MAP, "non struct page pfn" )                    \
-	EMe ( MF_MSG_UNKNOWN, "unknown page" )
-
-/*
- * First define the enums in MM_ACTION_RESULT to be exported to userspace
- * via TRACE_DEFINE_ENUM().
- */
-#undef EM
-#undef EMe
-#define EM(a, b) TRACE_DEFINE_ENUM(a);
-#define EMe(a, b)	TRACE_DEFINE_ENUM(a);
-
-MF_ACTION_RESULT
-MF_PAGE_TYPE
-
-/*
- * Now redefine the EM() and EMe() macros to map the enums to the strings
- * that will be printed in the output.
- */
-#undef EM
-#undef EMe
-#define EM(a, b)		{ a, b },
-#define EMe(a, b)	{ a, b }
-
-TRACE_EVENT(memory_failure_event,
-	TP_PROTO(unsigned long pfn,
-		 int type,
-		 int result),
-
-	TP_ARGS(pfn, type, result),
-
-	TP_STRUCT__entry(
-		__field(unsigned long, pfn)
-		__field(int, type)
-		__field(int, result)
-	),
-
-	TP_fast_assign(
-		__entry->pfn	= pfn;
-		__entry->type	= type;
-		__entry->result	= result;
-	),
-
-	TP_printk("pfn %#lx: recovery action for %s: %s",
-		__entry->pfn,
-		__print_symbolic(__entry->type, MF_PAGE_TYPE),
-		__print_symbolic(__entry->result, MF_ACTION_RESULT)
-	)
-);
-#endif /* CONFIG_MEMORY_FAILURE */
 #endif /* _TRACE_HW_EVENT_MC_H */
 
 /* This part must be outside protection */
 #include <trace/define_trace.h>
diff --git a/include/trace/events/memory-failure.h b/include/trace/events/memory-failure.h
new file mode 100644
index 000000000000..aa57cc8f896b
--- /dev/null
+++ b/include/trace/events/memory-failure.h
@@ -0,0 +1,98 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM memory_failure
+#define TRACE_INCLUDE_FILE memory-failure
+
+#if !defined(_TRACE_MEMORY_FAILURE_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_MEMORY_FAILURE_H
+
+#include <linux/tracepoint.h>
+#include <linux/mm.h>
+
+/*
+ * memory-failure recovery action result event
+ *
+ * unsigned long pfn -	Page Frame Number of the corrupted page
+ * int type	-	Page types of the corrupted page
+ * int result	-	Result of recovery action
+ */
+
+#define MF_ACTION_RESULT	\
+	EM ( MF_IGNORED, "Ignored" )	\
+	EM ( MF_FAILED,  "Failed" )	\
+	EM ( MF_DELAYED, "Delayed" )	\
+	EMe ( MF_RECOVERED, "Recovered" )
+
+#define MF_PAGE_TYPE		\
+	EM ( MF_MSG_KERNEL, "reserved kernel page" )			\
+	EM ( MF_MSG_KERNEL_HIGH_ORDER, "high-order kernel page" )	\
+	EM ( MF_MSG_HUGE, "huge page" )					\
+	EM ( MF_MSG_FREE_HUGE, "free huge page" )			\
+	EM ( MF_MSG_GET_HWPOISON, "get hwpoison page" )			\
+	EM ( MF_MSG_UNMAP_FAILED, "unmapping failed page" )		\
+	EM ( MF_MSG_DIRTY_SWAPCACHE, "dirty swapcache page" )		\
+	EM ( MF_MSG_CLEAN_SWAPCACHE, "clean swapcache page" )		\
+	EM ( MF_MSG_DIRTY_MLOCKED_LRU, "dirty mlocked LRU page" )	\
+	EM ( MF_MSG_CLEAN_MLOCKED_LRU, "clean mlocked LRU page" )	\
+	EM ( MF_MSG_DIRTY_UNEVICTABLE_LRU, "dirty unevictable LRU page" )	\
+	EM ( MF_MSG_CLEAN_UNEVICTABLE_LRU, "clean unevictable LRU page" )	\
+	EM ( MF_MSG_DIRTY_LRU, "dirty LRU page" )			\
+	EM ( MF_MSG_CLEAN_LRU, "clean LRU page" )			\
+	EM ( MF_MSG_TRUNCATED_LRU, "already truncated LRU page" )	\
+	EM ( MF_MSG_BUDDY, "free buddy page" )				\
+	EM ( MF_MSG_DAX, "dax page" )					\
+	EM ( MF_MSG_UNSPLIT_THP, "unsplit thp" )			\
+	EM ( MF_MSG_ALREADY_POISONED, "already poisoned" )		\
+	EM ( MF_MSG_PFN_MAP, "non struct page pfn" )                    \
+	EMe ( MF_MSG_UNKNOWN, "unknown page" )
+
+/*
+ * First define the enums in MM_ACTION_RESULT to be exported to userspace
+ * via TRACE_DEFINE_ENUM().
+ */
+#undef EM
+#undef EMe
+#define EM(a, b) TRACE_DEFINE_ENUM(a);
+#define EMe(a, b)	TRACE_DEFINE_ENUM(a);
+
+MF_ACTION_RESULT
+MF_PAGE_TYPE
+
+/*
+ * Now redefine the EM() and EMe() macros to map the enums to the strings
+ * that will be printed in the output.
+ */
+#undef EM
+#undef EMe
+#define EM(a, b)		{ a, b },
+#define EMe(a, b)	{ a, b }
+
+TRACE_EVENT(memory_failure_event,
+	TP_PROTO(unsigned long pfn,
+		 int type,
+		 int result),
+
+	TP_ARGS(pfn, type, result),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, pfn)
+		__field(int, type)
+		__field(int, result)
+	),
+
+	TP_fast_assign(
+		__entry->pfn	= pfn;
+		__entry->type	= type;
+		__entry->result	= result;
+	),
+
+	TP_printk("pfn %#lx: recovery action for %s: %s",
+		__entry->pfn,
+		__print_symbolic(__entry->type, MF_PAGE_TYPE),
+		__print_symbolic(__entry->result, MF_ACTION_RESULT)
+	)
+);
+#endif /* _TRACE_MEMORY_FAILURE_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/mm/Kconfig b/mm/Kconfig
index d548976d0e0a..bd0ea5454af8 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -738,11 +738,10 @@ config ARCH_SUPPORTS_MEMORY_FAILURE
 
 config MEMORY_FAILURE
 	depends on MMU
 	depends on ARCH_SUPPORTS_MEMORY_FAILURE
 	bool "Enable recovery from hardware memory errors"
-	select RAS
 	select INTERVAL_TREE
 	help
 	  Enables code to recover from some memory failures on systems
 	  with MCA recovery. This allows a system to continue running
 	  even when some of its memory has uncorrected errors. This requires
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 7f908ad795ad..fbc5a01260c8 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -59,13 +59,16 @@
 #include <linux/kfifo.h>
 #include <linux/ratelimit.h>
 #include <linux/pagewalk.h>
 #include <linux/shmem_fs.h>
 #include <linux/sysctl.h>
+
+#define CREATE_TRACE_POINTS
+#include <trace/events/memory-failure.h>
+
 #include "swap.h"
 #include "internal.h"
-#include "ras/ras_event.h"
 
 static int sysctl_memory_failure_early_kill __read_mostly;
 
 static int sysctl_memory_failure_recovery __read_mostly = 1;
 
-- 
2.51.0


