Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BF5DCCFA04
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 07:23:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED6AF8E00F5; Tue,  4 Nov 2025 02:23:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E61598E00E7; Tue,  4 Nov 2025 02:23:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9D848E00F5; Tue,  4 Nov 2025 02:23:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C47B98E00E7
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 02:23:22 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8A137886ED
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 07:23:22 +0000 (UTC)
X-FDA: 84072083844.08.F3D3BB2
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	by imf14.hostedemail.com (Postfix) with ESMTP id 00B1410000C
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 07:23:19 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=xroOrPlT;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf14.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762241000; a=rsa-sha256;
	cv=none;
	b=gePkIIDYAheifjXbnUYt9I3eNOMmqrF1onTGLS9oB3hN21kQ0WMl39MmjZm8K/zcL9FYKq
	5bMc1bovoW0TxdT4WBqhB5JxWFw7xd0ve0rffNmfpaSWkLRIl4wk97JoWzXc4zCK4cN8KQ
	Bbsbu5+c2sX1fJWe0Vz87Qg+FQdSVaE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=xroOrPlT;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf14.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762241000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5ACxLG6dzzDo30S/CHlMc09wITqLQddejtCKmmhm0BQ=;
	b=NNlWAtt2yuA1eM80iFfmyOTwon5ak34LTAurNOVLOL3jfSvzC7GpmKwY/9SIYI29L5mVNB
	VP2MCjRSC8U3TMbAdeZoOEcy9mENxg1wUjTKExVSJMg0Jg/tpZu/Im7MDBP0Gii5rpPMJG
	s5PgtYi5tsWVHjiMemFy5YgQ0E02Mqo=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=5ACxLG6dzzDo30S/CHlMc09wITqLQddejtCKmmhm0BQ=;
	b=xroOrPlTR0uZ9+iLfrqbfubRjRexnA3TBZ399y4grTlz9Flnce/wf9rEsSbMR5Z3Ps0RA0NTS
	EVcGDFAtakWZH2kG6c/Hpf+G9xVkXG8fcV8L6avJItBdLACHEcjs5TY4z8H79s6B2e12l6/l3Wh
	s7IaF6vGqb2v2F8wLNkFxkI=
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4d10J319T3z1cyPR;
	Tue,  4 Nov 2025 15:21:39 +0800 (CST)
Received: from kwepemj100009.china.huawei.com (unknown [7.202.194.3])
	by mail.maildlp.com (Postfix) with ESMTPS id 1009E140158;
	Tue,  4 Nov 2025 15:23:14 +0800 (CST)
Received: from DESKTOP-A37P9LK.huawei.com (10.67.109.17) by
 kwepemj100009.china.huawei.com (7.202.194.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 4 Nov 2025 15:23:13 +0800
From: Xie Yuanbin <xieyuanbin1@huawei.com>
To: <david@redhat.com>, <dave.hansen@intel.com>, <bp@alien8.de>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <dave.hansen@linux.intel.com>,
	<hpa@zytor.com>, <akpm@linux-foundation.org>, <lorenzo.stoakes@oracle.com>,
	<Liam.Howlett@oracle.com>, <vbabka@suse.cz>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <linmiaohe@huawei.com>,
	<nao.horiguchi@gmail.com>, <luto@kernel.org>, <peterz@infradead.org>,
	<tony.luck@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-edac@vger.kernel.org>, <will@kernel.org>, <liaohua4@huawei.com>,
	<lilinjie8@huawei.com>, Xie Yuanbin <xieyuanbin1@huawei.com>
Subject: [PATCH v2 2/2] mm/memory-failure: remove the selection of RAS
Date: Tue, 4 Nov 2025 15:23:06 +0800
Message-ID: <20251104072306.100738-3-xieyuanbin1@huawei.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251104072306.100738-1-xieyuanbin1@huawei.com>
References: <20251104072306.100738-1-xieyuanbin1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.67.109.17]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemj100009.china.huawei.com (7.202.194.3)
X-Rspamd-Queue-Id: 00B1410000C
X-Rspamd-Server: rspam07
X-Stat-Signature: zfx7qkxecri1d9sr13w8wwd9rysk1jpx
X-Rspam-User: 
X-HE-Tag: 1762240999-488759
X-HE-Meta: U2FsdGVkX1+nBPBzJ/bJLZKPElZsdJJXPzDkO0bbzHFg/rKulOF8y7vMKTYvgCe04H9LZb72taecorhjTcAL/Yh8wHYktkVZl26RiTtr+4CZGqRTbstQ3X6kRuv6Tcw37lwdvHtcZAFQqFsxsEadGHy30kBeLCQ7bpLzolyZcRv7CDvycOW4vtk53zB06OVbmsc3a4x7SuBhYbyqrI3AF63ygxrqsRvQrEqGjXw4wIF51IsjmkM02S7UpCKY++ZxATUIF8cVav67BmoUAjJ9w8aed7TC5peRU0G5bcEuO8yh9lHHOVsVIONwV0aSGBA8R4qpDXuSqdZPxt4a06xNO6JqBFRpf8h6Dtvrks/UJS5VjUzxEPrhsDgaK760YifxAzVXRNFnR+/ETdQCj4pbrV/9CRmmfKm430JO03wNzItPF+bUEuL3E66PrGPFlBZ6E9qVLfQfi3DX+9/9i+SWfHNgyRyimqEzU0Tm6U7IlGGhFEc8w2Qmk9A5AofyOaPT+WmQEJhJ2xPlsgcw2sjz0DLM550aZqtPhNoUIWEiWp8BMzeEvzfSWfzv4WFHcqZOiIQrDOpL076uo+1AcEOqwDOzeQEn4b/xIgW3ryaE3Lq5vhzMmyRpGdHrfH6s1z+r3udcimxlzxebQFUpfAH4aknitIUPdc4a0Mv2cEnD86+8qXNA5GM2DwI4/zVjyNN+Rkpc0pMokgp1Nb+DO67kzH/15dKjt0ggpzjSEDjhNUmKvaPwTkFECplvwe7jRdJyMcF7r/kOfNKj0nfdbfDaKGB9P1yTArXsxDQXXjjs08koQRzGkv/N57ocpXWrmkdd6oQPE+pl/+KFZaKuJJHKgXDpuEiQxqMh/9tOAKGoedZX2zivlY0CQfjC24LSKojDUOnPx4RJavR/Oj33CwSG4dI526uUjwGsoPChZPWaiI8W9R3XGVtyYV1iDUcPDXmsmcS+bQOmmqUlkTIC21S
 SkVWLsg9
 y8Ay3579hqM56Z0pJB7A/jgyRioxI3d4UfYRL/bRYh+X2aXkIUpLbkxyRJdesfN4vLPB23DtD5jM61hWQQRKTF3aNw413AcZEUwyIlSde6N9VrjTqNvpxy/WWzjKE8DlExvtfVHNblxJQyR2I3tUWLNuV7RNzXEDkBEgXdHFuFFrLaM7B5ov6pR8PRLsjSv7ta1gziZadCIIrWYK+kzn+aGT1FYuI92WGfw01h8aMcrNDm3Uvafc4a6yPDn6ksz4v4ChVabKJsRF2BYsmJcA9LEr9g8IX5d7WU9WbCvQ13GftgjxGK+iqa5U8F7QuP6cOhePPLsv9YAxYVDIdVJN/zZmmr6knspyIfr0qv5r98hj2Li/H+gjr15tHbiYiUgpuH33MvCgG3PUY6l5gnefTa1Kvr1HCHOPfsU5Y
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

Signed-off-by: Xie Yuanbin <xieyuanbin1@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
---
 include/ras/ras_event.h               | 86 ------------------------
 include/trace/events/memory-failure.h | 97 +++++++++++++++++++++++++++
 mm/Kconfig                            |  1 -
 mm/memory-failure.c                   |  5 +-
 4 files changed, 101 insertions(+), 88 deletions(-)
 create mode 100644 include/trace/events/memory-failure.h

diff --git a/include/ras/ras_event.h b/include/ras/ras_event.h
index c8cd0f00c845..1e5e87020eef 100644
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
@@ -337,94 +336,9 @@ TRACE_EVENT(aer_event,
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
index 000000000000..6c88fb624bd7
--- /dev/null
+++ b/include/trace/events/memory-failure.h
@@ -0,0 +1,97 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM ras
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
index a5a90b169435..c3a8e0ba1ac1 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -738,11 +738,10 @@ config ARCH_SUPPORTS_MEMORY_FAILURE
 
 config MEMORY_FAILURE
 	depends on MMU
 	depends on ARCH_SUPPORTS_MEMORY_FAILURE
 	bool "Enable recovery from hardware memory errors"
-	select RAS
 	help
 	  Enables code to recover from some memory failures on systems
 	  with MCA recovery. This allows a system to continue running
 	  even when some of its memory has uncorrected errors. This requires
 	  special hardware support and typically ECC memory.
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index f698df156bf8..a1fe6d760983 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -58,13 +58,16 @@
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
 
 #define SOFT_OFFLINE_ENABLED		BIT(0)
 #define SOFT_OFFLINE_SKIP_HUGETLB	BIT(1)
 
 static int sysctl_memory_failure_early_kill __read_mostly;
-- 
2.51.0


