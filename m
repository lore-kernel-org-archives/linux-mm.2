Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFBAFCA0EF8
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 11:20:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DB448E003E; Thu, 21 Aug 2025 07:20:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88B098E0013; Thu, 21 Aug 2025 07:20:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A2078E003E; Thu, 21 Aug 2025 07:20:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5D7128E0013
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 07:20:10 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0E656589F0
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:20:10 +0000 (UTC)
X-FDA: 83800520580.05.0E3E26C
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	by imf13.hostedemail.com (Postfix) with ESMTP id ABEA520008
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:20:06 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=oRM5xhR6;
	spf=pass (imf13.hostedemail.com: domain of alok.rathore@samsung.com designates 203.254.224.25 as permitted sender) smtp.mailfrom=alok.rathore@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755775208; a=rsa-sha256;
	cv=none;
	b=8cuppyLGxsfEl6hz8/RTcRrqd9mn2nY1abeuXiP44CytGESoYmnw5O2bEE04jJxWfarIyE
	DWNm6EN1ao4nAGx8N0T8br35j8AT8cAWnNcL3Bz0OpeIXFiPeofAVbc1ILTu78Jp09VPlX
	eiRuAZeB9Bg8EWw0DOSbfltiOTk8SIU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=oRM5xhR6;
	spf=pass (imf13.hostedemail.com: domain of alok.rathore@samsung.com designates 203.254.224.25 as permitted sender) smtp.mailfrom=alok.rathore@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755775208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E71pr0J+9kfAydFmicZVz2YTIR/1pkIFU0AVuNCgp1A=;
	b=ktKOKL06ODy2+If+fm5mCbeVPhhy94AMJORgWlnTX9k6HYzzHa/W0NX/m8HDTejcGf1xOr
	nIwumCjuP1VrqvNnHOymeXxlZXw2gaipHLrZgONoGg2M2T1UZrpfP/nza6JCOgZjZZwb80
	+iIfhkqiNEqq9VcOhWO+HnTjUvBbSSw=
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20250821112002epoutp02f3fa4a47255b1c6f1b0e37ad799d8cb5~dxD6NZEmX3089030890epoutp02P;
	Thu, 21 Aug 2025 11:20:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20250821112002epoutp02f3fa4a47255b1c6f1b0e37ad799d8cb5~dxD6NZEmX3089030890epoutp02P
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1755775202;
	bh=E71pr0J+9kfAydFmicZVz2YTIR/1pkIFU0AVuNCgp1A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=oRM5xhR6vMN7XoxoNwIpjlXtyNlo+JxVFu3cZKjRX6XuPqlsBuASo6+matgByfecr
	 wM6Z58bQEU23A4TC14oUV2xh1L65e3dxxiIIkUs0w3gHv1fYa4Th+u2o/LdOBLAsjs
	 +mcs7pwbWEejmwjHI7YYI7Y56Ufhtq1BVHhyyEQE=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20250821112002epcas5p473a3b7d5182d06a299185f24d9ece15f~dxD55dTg21500815008epcas5p4U;
	Thu, 21 Aug 2025 11:20:02 +0000 (GMT)
Received: from epcpadp1new (unknown [182.195.40.141]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4c717k29Jnz6B9m7; Thu, 21 Aug
	2025 11:20:02 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20250821111729epcas5p4b57cdfb4a339e8ac7fc1ea803d6baa34~dxBrz9Pgn1526015260epcas5p4E;
	Thu, 21 Aug 2025 11:17:29 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250821111725epsmtip2b14aecef5fb722ef077a1967f7acd3a9~dxBn-GTDd0220802208epsmtip2h;
	Thu, 21 Aug 2025 11:17:25 +0000 (GMT)
Date: Thu, 21 Aug 2025 16:47:19 +0530
From: Alok Rathore <alok.rathore@samsung.com>
To: Bharata B Rao <bharata@amd.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Jonathan.Cameron@huawei.com, dave.hansen@intel.com, gourry@gourry.net,
	hannes@cmpxchg.org, mgorman@techsingularity.net, mingo@redhat.com,
	peterz@infradead.org, raghavendra.kt@amd.com, riel@surriel.com,
	rientjes@google.com, sj@kernel.org, weixugc@google.com, willy@infradead.org,
	ying.huang@linux.alibaba.com, ziy@nvidia.com, dave@stgolabs.net,
	nifan.cxl@gmail.com, xuezhengchu@huawei.com, yiannis@zptcorp.com,
	akpm@linux-foundation.org, david@redhat.com, byungchul@sk.com,
	kinseyho@google.com, joshua.hahnjy@gmail.com, yuanchu@google.com,
	balbirs@nvidia.com, alokrathore20@gmail.com, gost.dev@samsung.com,
	cpgs@samsung.com
Subject: Re: [RFC PATCH v1 3/7] mm: Hot page tracking and promotion
Message-ID: <1983025922.01755775202288.JavaMail.epsvc@epcpadp1new>
MIME-Version: 1.0
In-Reply-To: <20250814134826.154003-4-bharata@amd.com>
X-CMS-MailID: 20250821111729epcas5p4b57cdfb4a339e8ac7fc1ea803d6baa34
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----At96h8_oYHqdM-HzD.Qv-z6Hqrsj5DpI3AOnKMLFsbTdazMP=_b0218_"
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250821111729epcas5p4b57cdfb4a339e8ac7fc1ea803d6baa34
References: <20250814134826.154003-1-bharata@amd.com>
	<20250814134826.154003-4-bharata@amd.com>
	<CGME20250821111729epcas5p4b57cdfb4a339e8ac7fc1ea803d6baa34@epcas5p4.samsung.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: ABEA520008
X-Stat-Signature: rnfofm7cdfojqcwgdbqeujo59yz5k6dq
X-Rspam-User: 
X-HE-Tag: 1755775206-285058
X-HE-Meta: U2FsdGVkX18Smph+CheES/CWs/k6Bfypenk96f4JfAYp2+wZWL9MzhUidKMmvV7fwLbVWd7PobcgVGhZypX6atZTJTjk2P1Ofr92aIgC0q6a+e4Wx7EPRLUu2p5YFpKqb2gsbq0CjPa5Geh8/KWgUny2cz+8DBV9iAuYJAB4JhwTbBpTNKSV+79PYJwWioaaNOMzOMHcbsemvh9SwXZ9kAkCGp/IFQrl7UFj7mcj7jSivpFF6QKN2T1dDTC5ZKxZKQGcLJ2jK0zs+tUVCg5OgxEEFRn8bjrq4dw2BSAMPMnueykv5JbnW7fSlV8J6gxoIW/e11FXirFk9ZwzqfrMeg8mJPfdHCtMFcM/uDzPsjQY7AZ0kmxjJLUsac3jnDyFwrZ9vvdFn3SbyoDlybj93p3T0BnkxhQMCMMANCzDmBM34fGPJH4EEtRq7uqhCeR+YicbwsRsVqsGwzfa+RQj/UN9qJx01IfC/8CQLi3tLYZSMn4WMO4XrECogPL6ewduDlGt3rH4/iPFS1dW1OlhkSiR1iZeDWuJ+/ivj0rDGay99eSVn5xPql31ZQAt8Tlb9eq0coLDaPCikcZC/9/MjfuqgSY2/w5Mzqwu95KFFsHBii2K2zwFIzvmlgE9OHv5OVFw9/iqe+H65XTJY82oCFFLabte0nsQBIhyJhpssWyLr+tR68YfOEca7UZB+3TiuTdk1i/yPl88ozUBL5UU1c6uq6w0sIgN4e1ERjELsB1fuq8AmL2QAtXANou76+2UA80WCKFrGoDsCaOCbZMXvT4FJQ3T6gvGoTHhOTfnejKpf0/4XAzJIqc3ydJm647o55Mg3zU0ABVKe2q+TqX+2PPJQljz8JNveEZmNlop5figv2/Ko/nSwymN0+mwmUpilYNrr0K7UbBKtQbewA4h0guRe5KJBJQHhsrmYXWYLqP4siUqWgQd/2S7pXZmFlwQugNZwqjI5gLb5dQZsPz
 BRKDY5XY
 GdPz/CEBohddQ/dmDGAk9RKcHu5jWBtUdi7Mwvx3fCraUW64UCZ1Ruf0Y/WVeaX0ViubtJ2PHilFcVaUx8lUgcWRSczl8wBdPz1iPcbcWX/0kgBKCCRnAXIIlh6SEmvjWqcg3iCPLOvUpdBRHgGcBwXdIpmywwyao8KIUg8N/iYnxDjtzYEw++z7cYUk3vhgaixU+kKHuJdXyTj1KtFt3ULOK4+ODuCIAefhGOmP30KzMGgE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

------At96h8_oYHqdM-HzD.Qv-z6Hqrsj5DpI3AOnKMLFsbTdazMP=_b0218_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 14/08/25 07:18PM, Bharata B Rao wrote:
>This introduces a sub-system for collecting memory access
>information from different sources. It maintains the hotness
>information based on the access history and time of access.
>
>Additionally, it provides per-lowertier-node kernel threads
>(named kpromoted) that periodically promote the pages that
>are eligible for promotion.
>
>Sub-systems that generate hot page access info can report that
>using this API:
>
>int pghot_record_access(u64 pfn, int nid, int src,
>			unsigned long time)
>
>@pfn: The PFN of the memory accessed
>@nid: The accessing NUMA node ID
>@src: The temperature source (sub-system) that generated the
>      access info
>@time: The access time in jiffies
>
>Some temperature sources may not provide the nid from which
>the page was accessed. This is true for sources that use
>page table scanning for PTE Accessed bit. For such sources,
>the default toptier node to which such pages should be promoted
>is hard coded.
>
>Also, the access time provided some sources may at best be
>considered approximate. This is especially true for hot pages
>detected by PTE A bit scanning.
>
>The hot PFN records are stored in hash lists hashed by PFN value.
>The PFN records that are categorized as hot enough to be promoted
>are maintained in a per-lowertier-node max heap from which
>kpromoted extracts and promotes them.
>
>Each record stores the following info:
>
>struct pghot_info {
>	unsigned long pfn;
>
>	unsigned long last_update; /* Most recent access time */
>	int frequency; /* Number of accesses within current window */
>	int nid; /* Most recent access from this node */
>
>	struct hlist_node hnode;
>	size_t heap_idx; /* Position in max heap for quick retreival */
>};
>
>The way in which a page is categorized as hot enough to be
>promoted is pretty primitive now.
>
>Signed-off-by: Bharata B Rao <bharata@amd.com>
>---
> include/linux/mmzone.h        |  11 +
> include/linux/pghot.h         |  87 ++++++
> include/linux/vm_event_item.h |   9 +
> mm/Kconfig                    |  11 +
> mm/Makefile                   |   1 +
> mm/mm_init.c                  |  10 +
> mm/pghot.c                    | 501 ++++++++++++++++++++++++++++++++++
> mm/vmstat.c                   |   9 +
> 8 files changed, 639 insertions(+)
> create mode 100644 include/linux/pghot.h
> create mode 100644 mm/pghot.c
>
>diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
>index 0c5da9141983..f7094babed10 100644
>--- a/include/linux/mmzone.h
>+++ b/include/linux/mmzone.h
>@@ -1349,6 +1349,10 @@ struct memory_failure_stats {
> };
> #endif
>
>+#ifdef CONFIG_PGHOT
>+#include <linux/pghot.h>
>+#endif
>+
> /*
>  * On NUMA machines, each NUMA node would have a pg_data_t to describe
>  * it's memory layout. On UMA machines there is a single pglist_data which
>@@ -1497,6 +1501,13 @@ typedef struct pglist_data {
> #ifdef CONFIG_MEMORY_FAILURE
> 	struct memory_failure_stats mf_stats;
> #endif
>+#ifdef CONFIG_PGHOT
>+	struct task_struct *kpromoted;
>+	wait_queue_head_t kpromoted_wait;
>+	struct pghot_info **phi_buf;
>+	struct max_heap heap;
>+	spinlock_t heap_lock;
>+#endif
> } pg_data_t;
>
> #define node_present_pages(nid)	(NODE_DATA(nid)->node_present_pages)
>diff --git a/include/linux/pghot.h b/include/linux/pghot.h
>new file mode 100644
>index 000000000000..6b8496944e7f
>--- /dev/null
>+++ b/include/linux/pghot.h
>@@ -0,0 +1,87 @@
>+/* SPDX-License-Identifier: GPL-2.0 */
>+#ifndef _LINUX_KPROMOTED_H
>+#define _LINUX_KPROMOTED_H
>+
>+#include <linux/types.h>
>+#include <linux/init.h>
>+#include <linux/workqueue_types.h>
>+
>+/* Page hotness temperature sources */
>+enum pghot_src {
>+	PGHOT_HW_HINTS,
>+	PGHOT_PGTABLE_SCAN,
>+};
>+
>+#ifdef CONFIG_PGHOT
>+
>+#define KPROMOTED_FREQ_WINDOW	(5 * MSEC_PER_SEC)
>+
>+/* 2 accesses within a window will make the page a promotion candidate */
>+#define KPRMOTED_FREQ_THRESHOLD	2
>+
>+/*
>+ * The following two defines control the number of hash lists
>+ * that are maintained for tracking PFN accesses.
>+ */
>+#define PGHOT_HASH_PCT		50	/* % of lower tier memory pages to track */
>+#define PGHOT_HASH_ENTRIES	1024	/* Number of entries per list, ideal case */
>+
>+/*
>+ * Percentage of hash entries that can reside in heap as migrate-ready
>+ * candidates
>+ */
>+#define PGHOT_HEAP_PCT		25
>+
>+#define KPRMOTED_MIGRATE_BATCH	1024
>+
>+/*
>+ * If target NID isn't available, kpromoted promotes to node 0
>+ * by default.
>+ *
>+ * TODO: Need checks to validate that default node is indeed
>+ * present and is a toptier node.
>+ */
>+#define KPROMOTED_DEFAULT_NODE	0
>+
>+struct pghot_info {
>+	unsigned long pfn;
>+
>+	/*
>+	 * The following are the three fundamental parameters
>+	 * required to track the hotness of page/PFN.
>+	 *
>+	 * TODO:
>+	 * Check if these three can fit into a u32.
>+	 * With 3 bits for frequency (8 most recent accesses),
>+	 * 10 bits for nid (1024 nodes), the remaining 19 bits
>+	 * are available for timestamp.
>+	 */
>+	unsigned long last_update; /* Most recent access time */
>+	int frequency; /* Number of accesses within current window */
>+	int nid; /* Most recent access from this node */
>+
>+	struct hlist_node hnode;
>+	size_t heap_idx; /* Position in max heap for quick retreival */
>+};
>+
>+struct max_heap {
>+	size_t nr;
>+	size_t size;
>+	struct pghot_info **data;
>+	DECLARE_FLEX_ARRAY(struct pghot_info *, preallocated);
>+};
>+
>+/*
>+ * The wakeup interval of kpromoted threads
>+ */
>+#define KPROMOTE_DELAY	20	/* 20ms */
>+
>+int pghot_record_access(u64 pfn, int nid, int src, unsigned long now);
>+#else
>+static inline int pghot_record_access(u64 pfn, int nid, int src,
>+				      unsigned long now)
>+{
>+	return 0;
>+}
>+#endif /* CONFIG_PGHOT */
>+#endif /* _LINUX_KPROMOTED_H */
>diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
>index 9e15a088ba38..9085e5c2d4aa 100644
>--- a/include/linux/vm_event_item.h
>+++ b/include/linux/vm_event_item.h
>@@ -186,6 +186,15 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
> 		KSTACK_REST,
> #endif
> #endif /* CONFIG_DEBUG_STACK_USAGE */
>+		PGHOT_RECORDED_ACCESSES,
>+		PGHOT_RECORD_HWHINTS,
>+		PGHOT_RECORD_PGTSCANS,
>+		PGHOT_RECORDS_HASH,
>+		PGHOT_RECORDS_HEAP,
>+		KPROMOTED_RIGHT_NODE,
>+		KPROMOTED_NON_LRU,
>+		KPROMOTED_COLD_OLD,
>+		KPROMOTED_DROPPED,
> 		NR_VM_EVENT_ITEMS
> };
>
>diff --git a/mm/Kconfig b/mm/Kconfig
>index e443fe8cd6cf..8b236eb874cf 100644
>--- a/mm/Kconfig
>+++ b/mm/Kconfig
>@@ -1381,6 +1381,17 @@ config PT_RECLAIM
>
> 	  Note: now only empty user PTE page table pages will be reclaimed.
>
>+config PGHOT
>+	bool "Hot page tracking and promotion"
>+	def_bool y
>+	depends on NUMA && MIGRATION && MMU
>+	select MIN_HEAP
>+	help
>+	  A sub-system to track page accesses in lower tier memory and
>+	  maintain hot page information. Promotes hot pages from lower
>+	  tiers to top tier by using the memory access information provided
>+	  by various sources. Asynchronous promotion is done by per-node
>+	  kernel threads.
>
> source "mm/damon/Kconfig"
>
>diff --git a/mm/Makefile b/mm/Makefile
>index ef54aa615d9d..8799bd0c68ed 100644
>--- a/mm/Makefile
>+++ b/mm/Makefile
>@@ -147,3 +147,4 @@ obj-$(CONFIG_SHRINKER_DEBUG) += shrinker_debug.o
> obj-$(CONFIG_EXECMEM) += execmem.o
> obj-$(CONFIG_TMPFS_QUOTA) += shmem_quota.o
> obj-$(CONFIG_PT_RECLAIM) += pt_reclaim.o
>+obj-$(CONFIG_PGHOT) += kpromoted.o

Looks like by mistake used older file name. It should be pghot.o

Can you please provide base commit. Unable to apply patch cleanly using b4 utility.

Regards,
Alok Rathore


>diff --git a/mm/mm_init.c b/mm/mm_init.c
>index 5c21b3af216b..f7992be3ff7f 100644
>--- a/mm/mm_init.c
>+++ b/mm/mm_init.c
>@@ -1402,6 +1402,15 @@ static void pgdat_init_kcompactd(struct pglist_data *pgdat)
> static void pgdat_init_kcompactd(struct pglist_data *pgdat) {}
> #endif
>
>+#ifdef CONFIG_PGHOT
>+static void pgdat_init_kpromoted(struct pglist_data *pgdat)
>+{
>+	init_waitqueue_head(&pgdat->kpromoted_wait);
>+}
>+#else
>+static void pgdat_init_kpromoted(struct pglist_data *pgdat) {}
>+#endif
>+
> static void __meminit pgdat_init_internals(struct pglist_data *pgdat)
> {
> 	int i;
>@@ -1411,6 +1420,7 @@ static void __meminit pgdat_init_internals(struct pglist_data *pgdat)
>
> 	pgdat_init_split_queue(pgdat);
> 	pgdat_init_kcompactd(pgdat);
>+	pgdat_init_kpromoted(pgdat);
>
> 	init_waitqueue_head(&pgdat->kswapd_wait);
> 	init_waitqueue_head(&pgdat->pfmemalloc_wait);
>diff --git a/mm/pghot.c b/mm/pghot.c
>new file mode 100644
>index 000000000000..eadcf970c3ef
>--- /dev/null
>+++ b/mm/pghot.c
>@@ -0,0 +1,501 @@
>+// SPDX-License-Identifier: GPL-2.0
>+/*
>+ * Maintains information about hot pages from slower tier nodes and
>+ * promotes them.
>+ *
>+ * Info about accessed pages are stored in hash lists indexed by PFN.
>+ * Info about pages that are hot enough to be promoted are stored in
>+ * a per-toptier-node max_heap.
>+ *
>+ * kpromoted is a kernel thread that runs on each toptier node and
>+ * promotes pages from max_heap.
>+ *
>+ * TODO:
>+ * - Compact pghot_info so that nid, time and frequency can fit
>+ * - Scalar hotness value as a function frequency and recency
>+ * - Possibility of moving migration rate limiting to kpromoted
>+ */
>+#include <linux/pghot.h>
>+#include <linux/kthread.h>
>+#include <linux/mmzone.h>
>+#include <linux/migrate.h>
>+#include <linux/memory-tiers.h>
>+#include <linux/slab.h>
>+#include <linux/sched.h>
>+#include <linux/vmalloc.h>
>+#include <linux/hashtable.h>
>+#include <linux/min_heap.h>
>+
>+struct pghot_hash {
>+	struct hlist_head hash;
>+	spinlock_t lock;
>+};
>+
>+static struct pghot_hash *phi_hash;
>+static int phi_hash_order;
>+static int phi_heap_entries;
>+static struct kmem_cache *phi_cache __ro_after_init;
>+static bool kpromoted_started __ro_after_init;
>+
>+static bool phi_heap_less(const void *lhs, const void *rhs, void *args)
>+{
>+	return (*(struct pghot_info **)lhs)->frequency >
>+		(*(struct pghot_info **)rhs)->frequency;
>+}
>+
>+static void phi_heap_swp(void *lhs, void *rhs, void *args)
>+{
>+	struct pghot_info **l = (struct pghot_info **)lhs;
>+	struct pghot_info **r = (struct pghot_info **)rhs;
>+	int lindex = l - (struct pghot_info **)args;
>+	int rindex = r - (struct pghot_info **)args;
>+	struct pghot_info *tmp = *l;
>+
>+	*l = *r;
>+	*r = tmp;
>+
>+	(*l)->heap_idx = lindex;
>+	(*r)->heap_idx = rindex;
>+}
>+
>+static const struct min_heap_callbacks phi_heap_cb = {
>+	.less = phi_heap_less,
>+	.swp = phi_heap_swp,
>+};
>+
>+static void phi_heap_update_entry(struct max_heap *phi_heap, struct pghot_info *phi)
>+{
>+	int orig_idx = phi->heap_idx;
>+
>+	min_heap_sift_up(phi_heap, phi->heap_idx, &phi_heap_cb,
>+			 phi_heap->data);
>+	if (phi_heap->data[phi->heap_idx]->heap_idx == orig_idx)
>+		min_heap_sift_down(phi_heap, phi->heap_idx,
>+				   &phi_heap_cb, phi_heap->data);
>+}
>+
>+static bool phi_heap_insert(struct max_heap *phi_heap, struct pghot_info *phi)
>+{
>+	if (phi_heap->nr >= phi_heap_entries)
>+		return false;
>+
>+	phi->heap_idx = phi_heap->nr;
>+	min_heap_push(phi_heap, &phi, &phi_heap_cb, phi_heap->data);
>+
>+	return true;
>+}
>+
>+static bool phi_is_pfn_hot(struct pghot_info *phi)
>+{
>+	struct page *page = pfn_to_online_page(phi->pfn);
>+	unsigned long now = jiffies;
>+	struct folio *folio;
>+
>+	if (!page || is_zone_device_page(page))
>+		return false;
>+
>+	folio = page_folio(page);
>+	if (!folio_test_lru(folio)) {
>+		count_vm_event(KPROMOTED_NON_LRU);
>+		return false;
>+	}
>+	if (folio_nid(folio) == phi->nid) {
>+		count_vm_event(KPROMOTED_RIGHT_NODE);
>+		return false;
>+	}
>+
>+	/* If the page was hot a while ago, don't promote */
>+	if ((now - phi->last_update) > 2 * msecs_to_jiffies(KPROMOTED_FREQ_WINDOW)) {
>+		count_vm_event(KPROMOTED_COLD_OLD);
>+		return false;
>+	}
>+	return true;
>+}
>+
>+static struct folio *kpromoted_isolate_folio(struct pghot_info *phi)
>+{
>+	struct page *page = pfn_to_page(phi->pfn);
>+	struct folio *folio;
>+
>+	if (!page)
>+		return NULL;
>+
>+	folio = page_folio(page);
>+	if (migrate_misplaced_folio_prepare(folio, NULL, phi->nid))
>+		return NULL;
>+	else
>+		return folio;
>+}
>+
>+static struct pghot_info *phi_alloc(unsigned long pfn)
>+{
>+	struct pghot_info *phi;
>+
>+	phi = kmem_cache_zalloc(phi_cache, GFP_NOWAIT);
>+	if (!phi)
>+		return NULL;
>+
>+	phi->pfn = pfn;
>+	phi->heap_idx = -1;
>+	return phi;
>+}
>+
>+static inline void phi_free(struct pghot_info *phi)
>+{
>+	kmem_cache_free(phi_cache, phi);
>+}
>+
>+static int phi_heap_extract(pg_data_t *pgdat, int batch_count, int freq_th,
>+			    struct list_head *migrate_list, int *count)
>+{
>+	spinlock_t *phi_heap_lock = &pgdat->heap_lock;
>+	struct max_heap *phi_heap = &pgdat->heap;
>+	int max_retries = 10;
>+	int bkt, i = 0;
>+
>+	if (batch_count < 0 || !migrate_list || !count || freq_th < 1 ||
>+	    freq_th > KPRMOTED_FREQ_THRESHOLD)
>+		return -EINVAL;
>+
>+	*count = 0;
>+	for (i = 0; i < batch_count; i++) {
>+		struct pghot_info *top = NULL;
>+		bool should_continue = false;
>+		struct folio *folio;
>+		int retries = 0;
>+
>+		while (retries < max_retries) {
>+			spin_lock(phi_heap_lock);
>+			if (phi_heap->nr > 0 && phi_heap->data[0]->frequency >= freq_th) {
>+				should_continue = true;
>+				bkt = hash_min(phi_heap->data[0]->pfn, phi_hash_order);
>+				top = phi_heap->data[0];
>+			}
>+			spin_unlock(phi_heap_lock);
>+
>+			if (!should_continue)
>+				goto done;
>+
>+			spin_lock(&phi_hash[bkt].lock);
>+			spin_lock(phi_heap_lock);
>+			if (phi_heap->nr == 0 || phi_heap->data[0] != top ||
>+			    phi_heap->data[0]->frequency < freq_th) {
>+				spin_unlock(phi_heap_lock);
>+				spin_unlock(&phi_hash[bkt].lock);
>+				retries++;
>+				continue;
>+			}
>+
>+			top = phi_heap->data[0];
>+			hlist_del_init(&top->hnode);
>+
>+			phi_heap->nr--;
>+			if (phi_heap->nr > 0) {
>+				phi_heap->data[0] = phi_heap->data[phi_heap->nr];
>+				phi_heap->data[0]->heap_idx = 0;
>+				min_heap_sift_down(phi_heap, 0, &phi_heap_cb,
>+						   phi_heap->data);
>+			}
>+
>+			spin_unlock(phi_heap_lock);
>+			spin_unlock(&phi_hash[bkt].lock);
>+
>+			if (!phi_is_pfn_hot(top)) {
>+				count_vm_event(KPROMOTED_DROPPED);
>+				goto skip;
>+			}
>+
>+			folio = kpromoted_isolate_folio(top);
>+			if (folio) {
>+				list_add(&folio->lru, migrate_list);
>+				(*count)++;
>+			}
>+skip:
>+			phi_free(top);
>+			break;
>+		}
>+		if (retries >= max_retries) {
>+			pr_warn("%s: Too many retries\n", __func__);
>+			break;
>+		}
>+
>+	}
>+done:
>+	return 0;
>+}
>+
>+static void phi_heap_add_or_adjust(struct pghot_info *phi)
>+{
>+	pg_data_t *pgdat = NODE_DATA(phi->nid);
>+	struct max_heap *phi_heap = &pgdat->heap;
>+
>+	spin_lock(&pgdat->heap_lock);
>+	if (phi->heap_idx >= 0 && phi->heap_idx < phi_heap->nr &&
>+	    phi_heap->data[phi->heap_idx] == phi) {
>+		/* Entry exists in heap */
>+		if (phi->frequency < KPRMOTED_FREQ_THRESHOLD) {
>+			/* Below threshold, remove from the heap */
>+			phi_heap->nr--;
>+			if (phi->heap_idx < phi_heap->nr) {
>+				phi_heap->data[phi->heap_idx] =
>+					phi_heap->data[phi_heap->nr];
>+				phi_heap->data[phi->heap_idx]->heap_idx =
>+					phi->heap_idx;
>+				min_heap_sift_down(phi_heap, phi->heap_idx,
>+						   &phi_heap_cb, phi_heap->data);
>+			}
>+			phi->heap_idx = -1;
>+
>+		} else {
>+			/* Update position in heap */
>+			phi_heap_update_entry(phi_heap, phi);
>+		}
>+	} else if (phi->frequency >= KPRMOTED_FREQ_THRESHOLD) {
>+		/* Add to the heap */
>+		if (phi_heap_insert(phi_heap, phi))
>+			count_vm_event(PGHOT_RECORDS_HEAP);
>+	}
>+	spin_unlock(&pgdat->heap_lock);
>+}
>+
>+static struct pghot_info *phi_lookup(unsigned long pfn, int bkt)
>+{
>+	struct pghot_info *phi;
>+
>+	hlist_for_each_entry(phi, &phi_hash[bkt].hash, hnode) {
>+		if (phi->pfn == pfn)
>+			return phi;
>+	}
>+	return NULL;
>+}
>+
>+/*
>+ * Called by subsystems that generate page hotness/access information.
>+ *
>+ *  @pfn: The PFN of the memory accessed
>+ *  @nid: The accessing NUMA node ID
>+ *  @src: The temperature source (sub-system) that generated the
>+ *        access info
>+ *  @time: The access time in jiffies
>+ *
>+ * Maintains the access records per PFN, classifies them as
>+ * hot based on subsequent accesses and finally hands over
>+ * them to kpromoted for migration.
>+ */
>+int pghot_record_access(u64 pfn, int nid, int src, unsigned long now)
>+{
>+	struct pghot_info *phi;
>+	struct page *page;
>+	struct folio *folio;
>+	int bkt;
>+	bool new_entry = false, new_window = false;
>+
>+	if (!kpromoted_started)
>+		return -EINVAL;
>+
>+	count_vm_event(PGHOT_RECORDED_ACCESSES);
>+
>+	switch (src) {
>+	case PGHOT_HW_HINTS:
>+		count_vm_event(PGHOT_RECORD_HWHINTS);
>+		break;
>+	case PGHOT_PGTABLE_SCAN:
>+		count_vm_event(PGHOT_RECORD_PGTSCANS);
>+		break;
>+	default:
>+		return -EINVAL;
>+	}
>+
>+	/*
>+	 * Record only accesses from lower tiers.
>+	 */
>+	if (node_is_toptier(pfn_to_nid(pfn)))
>+		return 0;
>+
>+	/*
>+	 * Reject the non-migratable pages right away.
>+	 */
>+	page = pfn_to_online_page(pfn);
>+	if (!page || is_zone_device_page(page))
>+		return 0;
>+
>+	folio = page_folio(page);
>+	if (!folio_test_lru(folio))
>+		return 0;
>+
>+	bkt = hash_min(pfn, phi_hash_order);
>+	spin_lock(&phi_hash[bkt].lock);
>+	phi = phi_lookup(pfn, bkt);
>+	if (!phi) {
>+		phi = phi_alloc(pfn);
>+		if (!phi)
>+			goto out;
>+		new_entry = true;
>+	}
>+
>+	if (((now - phi->last_update) > msecs_to_jiffies(KPROMOTED_FREQ_WINDOW)) ||
>+	    (nid != NUMA_NO_NODE && phi->nid != nid))
>+		new_window = true;
>+
>+	if (new_entry || new_window) {
>+		/* New window */
>+		phi->frequency = 1; /* TODO: Factor in the history */
>+	} else
>+		phi->frequency++;
>+	phi->last_update = now;
>+	phi->nid = (nid == NUMA_NO_NODE) ? KPROMOTED_DEFAULT_NODE : nid;
>+
>+	if (new_entry) {
>+		/* Insert the new entry into hash table */
>+		hlist_add_head(&phi->hnode, &phi_hash[bkt].hash);
>+		count_vm_event(PGHOT_RECORDS_HASH);
>+	} else {
>+		/* Add/update the position in heap */
>+		phi_heap_add_or_adjust(phi);
>+	}
>+out:
>+	spin_unlock(&phi_hash[bkt].lock);
>+	return 0;
>+}
>+
>+/*
>+ * Extract the hot page records and batch-migrate the
>+ * hot pages.
>+ */
>+static void kpromoted_migrate(pg_data_t *pgdat)
>+{
>+	int count, ret;
>+	LIST_HEAD(migrate_list);
>+
>+	/*
>+	 * Extract the top N elements from the heap that match
>+	 * the requested hotness threshold.
>+	 *
>+	 * PFNs ineligible from migration standpoint are removed
>+	 * from the heap and hash.
>+	 *
>+	 * Folios eligible for migration are isolated and returned
>+	 * in @migrate_list.
>+	 */
>+	ret = phi_heap_extract(pgdat, KPRMOTED_MIGRATE_BATCH,
>+			       KPRMOTED_FREQ_THRESHOLD, &migrate_list, &count);
>+	if (ret)
>+		return;
>+
>+	if (!list_empty(&migrate_list))
>+		migrate_misplaced_folios_batch(&migrate_list, pgdat->node_id);
>+}
>+
>+static int kpromoted(void *p)
>+{
>+	pg_data_t *pgdat = (pg_data_t *)p;
>+
>+	while (!kthread_should_stop()) {
>+		wait_event_timeout(pgdat->kpromoted_wait, false,
>+				   msecs_to_jiffies(KPROMOTE_DELAY));
>+		kpromoted_migrate(pgdat);
>+	}
>+	return 0;
>+}
>+
>+static int kpromoted_run(int nid)
>+{
>+	pg_data_t *pgdat = NODE_DATA(nid);
>+	int ret = 0;
>+
>+	if (!node_is_toptier(nid))
>+		return 0;
>+
>+	if (!pgdat->phi_buf) {
>+		pgdat->phi_buf = vzalloc_node(phi_heap_entries * sizeof(struct pghot_info *),
>+					      nid);
>+		if (!pgdat->phi_buf)
>+			return -ENOMEM;
>+
>+		min_heap_init(&pgdat->heap, pgdat->phi_buf, phi_heap_entries);
>+		spin_lock_init(&pgdat->heap_lock);
>+	}
>+
>+	if (!pgdat->kpromoted)
>+		pgdat->kpromoted = kthread_create_on_node(kpromoted, pgdat, nid,
>+							  "kpromoted%d", nid);
>+	if (IS_ERR(pgdat->kpromoted)) {
>+		ret = PTR_ERR(pgdat->kpromoted);
>+		pgdat->kpromoted = NULL;
>+		pr_info("Failed to start kpromoted%d, ret %d\n", nid, ret);
>+	} else {
>+		wake_up_process(pgdat->kpromoted);
>+	}
>+	return ret;
>+}
>+
>+static int __init pghot_init(void)
>+{
>+	unsigned int hash_size;
>+	size_t hash_entries;
>+	size_t nr_pages = 0;
>+	pg_data_t *pgdat;
>+	int i, nid, ret;
>+
>+	/*
>+	 * Arrive at the hash and heap sizes based on the
>+	 * number of pages present in the lower tier nodes.
>+	 */
>+	for_each_node_state(nid, N_MEMORY) {
>+		if (!node_is_toptier(nid))
>+			nr_pages += NODE_DATA(nid)->node_present_pages;
>+	}
>+
>+	if (!nr_pages)
>+		return 0;
>+
>+	hash_entries = nr_pages * PGHOT_HASH_PCT / 100;
>+	hash_size = hash_entries / PGHOT_HASH_ENTRIES;
>+	phi_hash_order = ilog2(hash_size);
>+
>+	phi_hash = vmalloc(sizeof(struct pghot_hash) * hash_size);
>+	if (!phi_hash) {
>+		ret = -ENOMEM;
>+		goto out;
>+	}
>+
>+	for (i = 0; i < hash_size; i++) {
>+		INIT_HLIST_HEAD(&phi_hash[i].hash);
>+		spin_lock_init(&phi_hash[i].lock);
>+	}
>+
>+	phi_cache = KMEM_CACHE(pghot_info, 0);
>+	if (unlikely(!phi_cache)) {
>+		ret = -ENOMEM;
>+		goto out;
>+	}
>+
>+	phi_heap_entries = hash_entries * PGHOT_HEAP_PCT / 100;
>+	for_each_node_state(nid, N_CPU) {
>+		ret = kpromoted_run(nid);
>+		if (ret)
>+			goto out_stop_kthread;
>+	}
>+
>+	kpromoted_started = true;
>+	pr_info("pghot: Started page hotness monitoring and promotion thread\n");
>+	pr_info("pghot: nr_pages %ld hash_size %d hash_entries %ld hash_order %d heap_entries %d\n",
>+	       nr_pages, hash_size, hash_entries, phi_hash_order, phi_heap_entries);
>+	return 0;
>+
>+out_stop_kthread:
>+	for_each_node_state(nid, N_CPU) {
>+		pgdat = NODE_DATA(nid);
>+		if (pgdat->kpromoted) {
>+			kthread_stop(pgdat->kpromoted);
>+			pgdat->kpromoted = NULL;
>+			vfree(pgdat->phi_buf);
>+		}
>+	}
>+out:
>+	kmem_cache_destroy(phi_cache);
>+	vfree(phi_hash);
>+	return ret;
>+}
>+
>+late_initcall(pghot_init)
>diff --git a/mm/vmstat.c b/mm/vmstat.c
>index 71cd1ceba191..9edbdd71c6f7 100644
>--- a/mm/vmstat.c
>+++ b/mm/vmstat.c
>@@ -1496,6 +1496,15 @@ const char * const vmstat_text[] = {
> #endif
> #undef I
> #endif /* CONFIG_VM_EVENT_COUNTERS */
>+	"pghot_recorded_accesses",
>+	"pghot_recorded_hwhints",
>+	"pghot_recorded_pgtscans",
>+	"pghot_records_hash",
>+	"pghot_records_heap",
>+	"kpromoted_right_node",
>+	"kpromoted_non_lru",
>+	"kpromoted_cold_old",
>+	"kpromoted_dropped",
> };
> #endif /* CONFIG_PROC_FS || CONFIG_SYSFS || CONFIG_NUMA || CONFIG_MEMCG */
>
>-- 
>2.34.1
>

------At96h8_oYHqdM-HzD.Qv-z6Hqrsj5DpI3AOnKMLFsbTdazMP=_b0218_
Content-Type: text/plain; charset="utf-8"


------At96h8_oYHqdM-HzD.Qv-z6Hqrsj5DpI3AOnKMLFsbTdazMP=_b0218_--


