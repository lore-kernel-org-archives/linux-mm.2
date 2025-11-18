Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F5B3CEBF93
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 08:09:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86BD88E0005; Tue, 18 Nov 2025 03:09:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8433D8E0002; Tue, 18 Nov 2025 03:09:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 780588E0005; Tue, 18 Nov 2025 03:09:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6445D8E0002
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 03:09:24 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 075F988B3B
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 08:09:24 +0000 (UTC)
X-FDA: 84123003048.23.041BEB7
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	by imf13.hostedemail.com (Postfix) with ESMTP id 07B9D20019
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 08:09:20 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=FhjutcSH;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf13.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763453362; a=rsa-sha256;
	cv=none;
	b=Wp9dKEot+pigQoWL1fW7kEaDlGe4t97gAOGYGDGxOJqIVk/O2/V7HTzV2m9S+pobeoWCfG
	HoUWvvdSoexoLTH5EEC5h2OYVNXGzY8CJvyh7JcKiM5ioLY/lX3gkGmecdl2Ovswj2LXbi
	OzX9UuepcyuP24xHn6ki1+xKDBYSSSU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=FhjutcSH;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf13.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763453362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VM3CpdBrLvEcqbt2ukVSKGcYUHg4qRv1vBw4aiOt220=;
	b=mitY+VtTpb88Pr+lWzjKkTS4GhcTeEaTV6Kdh1vnIxFvhVDnGdwr6anc00dRExxrhzuySs
	LKhsmgZwM807h6ifX2N0/uLOU1ZUiIbZRpc5coZdDxBIk5bhGWqxrXEGHV4mRKLA5C4BNP
	uRx91l6P6ButaifWpll8E7gXvveaRng=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=VM3CpdBrLvEcqbt2ukVSKGcYUHg4qRv1vBw4aiOt220=;
	b=FhjutcSHCsZYzhDkkGkeXjx6bgKeQlFXTjDevAPUmlNpMa3T45Cdm41HnhIOaNbznmUj1nYYv
	tNOyJ1B0FmGqRsnU4iwlV2M5mnPn8D81neOkCv9U9ax8l9YS3U8WuoDb2w+o3sZA3V18fbrchIG
	x+pQyK5HotXD5erxnPoe/Nk=
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4d9cfY3CSwzRhR1;
	Tue, 18 Nov 2025 16:07:33 +0800 (CST)
Received: from kwepemj100009.china.huawei.com (unknown [7.202.194.3])
	by mail.maildlp.com (Postfix) with ESMTPS id 2F718140137;
	Tue, 18 Nov 2025 16:09:16 +0800 (CST)
Received: from DESKTOP-A37P9LK.huawei.com (10.67.109.17) by
 kwepemj100009.china.huawei.com (7.202.194.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 18 Nov 2025 16:09:14 +0800
From: Xie Yuanbin <xieyuanbin1@huawei.com>
To: <david@kernel.org>
CC: <Liam.Howlett@oracle.com>, <akpm@linux-foundation.org>, <bp@alien8.de>,
	<dave.hansen@intel.com>, <dave.hansen@linux.intel.com>, <hpa@zytor.com>,
	<liaohua4@huawei.com>, <lilinjie8@huawei.com>, <linmiaohe@huawei.com>,
	<linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <lorenzo.stoakes@oracle.com>, <luto@kernel.org>,
	<mhocko@suse.com>, <mingo@redhat.com>, <nao.horiguchi@gmail.com>,
	<peterz@infradead.org>, <rppt@kernel.org>, <surenb@google.com>,
	<tglx@linutronix.de>, <tony.luck@intel.com>, <vbabka@suse.cz>,
	<will@kernel.org>, <x86@kernel.org>, <xieyuanbin1@huawei.com>
Subject: Re: [PATCH v2 0/2] x86/mm: support memory-failure on 32-bits with SPARSEMEM
Date: Tue, 18 Nov 2025 16:09:10 +0800
Message-ID: <20251118080910.833858-1-xieyuanbin1@huawei.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <534dfba8-6222-4eea-aeb8-440d47c67f5b@kernel.org>
References: <534dfba8-6222-4eea-aeb8-440d47c67f5b@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.67.109.17]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemj100009.china.huawei.com (7.202.194.3)
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 07B9D20019
X-Stat-Signature: f8ceubniaxxqharbc4s98kthecqzttcp
X-Rspam-User: 
X-HE-Tag: 1763453360-17862
X-HE-Meta: U2FsdGVkX1/oxLMbw6IrViINVZiLY6lhIRgswoCit54LhP9xU1AoTEZEjldhTaYQLrwZ409igSF0jkKNix8ACAJUYeI/PGbcHhq6w7io8vNH0fMscdCnS1RpiuZB+lb/QEP+TptrKIgGOu2jLi1LVGP4SPPemtFFoV9NVH/y1s1qejs6QRFq4Qj6r4Cejs9wNwnxAnvPZ/uOYFigP1zyQ71EJXMKLdMYeGJFEHrm9A38R8lOOtmuZUROvk4Lo6lXR3tkp6pYzXLUhU17Om2JIjHHTTz0MyLC3K8QpqJ8EI9j+t7D3sy5gBSYdlEnwTPa/s5wyqBd01KRQLc/4dMBeMRaEZtn7UEj9EaTitA8qNBQKfibn91WDvu6lpeTM65DnyjWMZffYeu8bR5OyVLn3pTAqOBoudawyOjYIrP99CLluhJ8QmBAOWa9qQZT+IZDy0FdzkqBUKkfE8LjnWApSzazDTJTmyc51jdbktX13zXf+Y/GSlerfbjbUx7i5zt4IzASHzMlwYGr0kYCjj0rOI9PM06Tjvi+cGPyKXvnV+1MRm/UmA3IDwDw2yfPfxRnX4YV9iwP9gLD8HNQ1HBuSLI7BCjJpXiyKOAD2YAOQacxz4UA4U0fHKTzN7Rk3+mWZ+WLpan28tu5gnEXGx3SfxjNMe7hYfzEzEFiaQFPheEeKoKRBxrh7oy2kmJ33HkHnHNFtwyxOXYwPM6E/aA2rFMwgqMbCeji8BCTxd8D55TNQNO64JWGp6uUlQOw6O3dPXE9Cp+L/X0ff7AL93fCIbqR4IiLH4nAcsrJD3B1HoNsNvGdZjIEW0o8UeP5iibE6oCGHXMl4TsL59oqtCeCu3OiyOKT0asXNUwFQPp2bN2Mg2sUuCsGiXdWpBgVdnOfj6efJL+arKHlAFvscKLhAUCzh+uf0jWQ2dKDbn7FiTmzDr6oJhULiMWZphP9XvPCh9kxzH+6ZDPnntLOIT4
 4jqUcZWu
 V0DUCJlzJ6qvpF0Al3wEF0L9o45sVzdT7TWEZZm6g5Hqz/IinqS/uGLOVkqFPZREVZMQQjh2DYYpIMQzrnmiJczXstH/J5GJ8AsYDTh4wF4tVniQVdd4n/WxSZSdXUAX+wjS9KkkVw29ptocjjHD9e0/d+zJpd9EOFkeFYI0KekGkZdApYZ/Nf8pYCO8zVLgJvRK3rog/Vkrr5bpEcbQRKUAham5dhEqPOEpG/qbPRdIi5CSwErab30vbuq2Q1q/0AXoE3ZMlO/zj4rXV6YuV9xYMGkUYLcSGF3BkcQE7NavOE1RpD6OofXKU46i16eMtfLccSOPUYx9+TAK20OVLIbG3YP4MzN4R8QuQ0UHzKgPiiM22pehD4lBx8qWyn8mlvTeE2uRVQi2G2x4WOFaVHz1tMVia1NeElRYXJxImOH5ZvL7FsVYl1lQoV6HWfXyW8M/9yww5AjYD++07kTYJznNvjUYMatByk0sX8vmRa8EpChkqzN7oD6tFlj1oFssDD5pIxvjwozaFihYiSQSK1yLZPNx5dV35gI6hHj1LVNQOsD2QnkSbiRyJ5Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mon, 17 Nov 2025 14:03:46 +0100, David Hildenbrand wrote:
> I'd say, if nobody will really make use of that right now (customer 
> request etc), just leave x86 alone for now.

Okay, thanks, I will only submit patch 2 in the V3 patches.

On Tue, 4 Nov 2025 10:38:54 +0100, David Hildenbrand wrote:
Link: https://lore.kernel.org/01b44e0f-ea2e-406f-9f65-b698b5504f42@kernel.org
> This trace system should not be called "ras". All RAS terminology should 
> be removed here.
>
> #define TRACE_SYSTEM memory_failure
>
> We want to add that new file to the "HWPOISON MEMORY FAILURE HANDLING"
> section in MAINTAINERS.
>
> Nothing else jumped at me.

Can I add an
"Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>"
in the patch 2?

The full patch will be:
```patch
From: Xie Yuanbin <xieyuanbin1@huawei.com>
Subject: [PATCH v3] mm/memory-failure: remove the selection of RAS

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
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
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
```

Thanks very much.

Xie Yuanbin

