Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB278C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 12:03:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 743EA6B00A1; Thu, 10 Sep 2026 08:02:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71BCB6B00A2; Thu, 10 Sep 2026 08:02:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 631F16B00A3; Thu, 10 Sep 2026 08:02:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 34B806B00A1
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 08:02:59 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 973B21A04F2
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:02:58 +0000 (UTC)
X-FDA: 85197716436.16.392F2B7
Received: from fhigh-b4-smtp.messagingengine.com (fhigh-b4-smtp.messagingengine.com [202.12.124.155])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9727F180012
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:02:56 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="T 2xJjUL";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=Y8Ku98M2;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.155 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="T 2xJjUL";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=Y8Ku98M2;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.155 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789041776;
	b=Ti9xJif+97/FOt2V18yhBW2wOSVbGFYA2+W9DRYIaqLK00TEUTdGXb5LZigD4CJBI1yeTd
	EBLCkmtcRu+VIZN0WuRVTyZU5arL6WBkoX1Js/mIHNTlosCGDt9YQtwLp16YM8ldsdqXcj
	E3qQVIRjqxYOPnpKTl9kz4dEd2/zybQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789041776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=avMkfLVeU1+RrFVq7dqGuSLkfIFTUHtIkOYpYaIIbGQ=;
	b=OrsOOkWzP69MiENyKy0SYOSISJ9DlP3SkqSl3Km+051TgimX4+f20ccs8761CbfKu8Wtng
	AmSVqv2SSJIxoHlrj6wfuPeyjH1s8QfbNWZZ8O0eSUrFoAa6YpGR5qS8VqZ9k29KIAFpot
	mf30WH7z2j+19lyfNKhgsBYvFBtWu8s=
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 7B6607A0063;
	Thu, 10 Sep 2026 08:02:55 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-08.internal (MEProxy); Thu, 10 Sep 2026 08:02:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1789041775; x=
	1789128175; bh=avMkfLVeU1+RrFVq7dqGuSLkfIFTUHtIkOYpYaIIbGQ=; b=T
	2xJjUL1ZJCMdxAKPg3uwAZtQTW68SPh1VtoRK4teQNVLihar9mgoJPDh2apslDeA
	1UM2at3b4xJ/2c+9iAKLWFmzd1N6vFSZDxnC4bndyr4q7u/ad++sYlngeR425orY
	D+Ljclm8KB6q0URN/k2NHOfS3/na4MCYfoKeYamG/VZrvp1r0oJ407MuHIry7FdI
	pZAL+n3NnpEKJjwttDohUawq6dnMK36cTRDkroJPLbfPHsi/Db7cCa0C9njJcKQR
	Q1SoW7+Rk/wGjglQSsZ8XmkMWhjKLCrk+o3IpSMfIJH4VimrFQNkRqm7PYM+err0
	nJNDFd70gqONHTDdIruhQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1789041775; x=1789128175; bh=a
	vMkfLVeU1+RrFVq7dqGuSLkfIFTUHtIkOYpYaIIbGQ=; b=Y8Ku98M2fH9TsfHUC
	3J8yJsl2EJkbzK6Gfgh5GCaY7XPesGxNTFJJK8nc5OfGbYrKKitgz8xIKbeWTTZg
	IhIgEbvrjhDaGk5ZRVsrdLnmM1i7XBdjH7uSCDFm2ActUo7TjXZGd1D3Y9RSvmp2
	Uddob6uTDYV0+RhjSj+AyCdNFimQyIBYebGIWnUsb6iWe6Nkzh9hS0/dYVwccugA
	D6NdpvpWiQZO2WSyfj8jWEd7ThveOJC4Sx71oG//Ee/nMTXp8s1FbhBvUDsQpIWy
	NZbFxVbtq2aDzbFSRHBQ/xB9WDP9dr9tsFWT54iV8MXNexIFLXA1PNpN00EhAGvq
	CxEwQ==
X-ME-Sender: <xms:b5yiapGha6zwoMwr2lCkEFLXOBNCHpEtbQesBR-EHtD5u-BLvkJjtA>
    <xme:b5yiaqTP7BVZOTSNMl3HqxXHkfepY9WlUeT9SsGpHh2dKaz6H-yGxL8HMIOgVQ86-
    qasLUN8fhIYdHDx6X7HWIZ_FEI4OMaQB3jA5lf45yOnGgYs2G0KS5au>
X-ME-Received: <xmr:b5yiahRdc373HQZFeMzspmBugzzKJMf9DijQxmVYW2Vvkn7boP4xmUC_o40>
X-ME-Proxy-Cause: dmFkZTGH8GFWwEUBtPxKJ67Rq2x/vdej+Q6nUCGcsDIesBFp0X3hc4jYyZuxmlnDOcFOMj
    pjMT1hhilwwz+XztIrpfsk+jOgPg51Zko9HtX5FOXtwZM/xuJUIPYajGOB/mCLABcXoBUN
    tOK7IZxc0LQBxYWwS3D6Gb3+L6Rzatr9ZhNURjEQibWJdyHQU+pHQvTtQJMa086Ym+yd6R
    IInk1eh8W3seorGmDJU/iV1zGzfJwWvedZT0VKJsUgZ7fACBrQNd9k3L4EzTZNF344phSI
    j6ov0R0Vo2eJRufAS9ocD/WtRYG80u0cUfKpHkiyow/cp96ftI+MA3MvYDL4cDgvN+YPWI
    iSSoN3tZcUvge+vs0OnV2TRyl66gqJJm6yyXdLsCQmmv5R9/2dOzXjaaugeZEOo2bKsdLn
    9Q6IYpu71Hg/t6ms3VhXiJHEQFznSJfCXNaOL5wkZlE2eD9GJm3ckhTUkCo99iaIo8fFZt
    Z3yVb0sfuZaVL2lyCOZ1pLGWh2G2T149WHWYELBYlPm3ikACBgYkR2HIDatKODuiSPcH0C
    rcm8Aj4+jRYJ7o3Sxu+zhnWq7U6r5xV4akeqZzrPPWBQ+8nvmBqEy12KZDbrq45kbjWhWh
    Wjb9o4DEwpayt5ffXVXUbFhQmM9vRL5Hgpv8+bPDKo3xT37tSMdaJ/LtGCxQ
X-ME-Proxy: <xmx:b5yialdy1MXMm41C1uVdYrPVZvtE3Fq_0Tsgbzp6ruk3SfOkk3zAxQ>
    <xmx:b5yiateLIgF3rAoen6JDiIBy3XoGS1q5cZzVjhfDp3RstFFZwLj0sg>
    <xmx:b5yiaj9QtX6OmP8dzTNB7FaVkYFPSWMvLOjYLmchf2KyHHl7XD-gNg>
    <xmx:b5yialPk_r8N0NSS2kwmz6wQxLLJVvbac7gj84YTKkm0e8mOUeQJ5A>
    <xmx:b5yiapZ_2Di_tfezN2jcNqsJKYlO0mXNY9jqcCSwPUXpwajYgG7vbrw4>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 10 Sep 2026 08:02:54 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: [PATCH v2 04/12] mm/collapse: add collapse.h for the collapse interface
Date: Thu, 10 Sep 2026 13:02:24 +0100
Message-ID: <20260910120238.2529819-5-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260910120238.2529819-1-kirill@shutemov.name>
References: <20260910120238.2529819-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 9727F180012
X-Stat-Signature: zac3n4iefzzdfc189xog7mtnj7t6b5o6
X-Rspamd-Server: rspam01
X-HE-Tag: 1789041776-312336
X-HE-Meta: U2FsdGVkX1+siqJVuWzRI2wwrN6m/kdsTY+8TsDivNRZaY7oS7WpblMA1lBKOMWuvZvAHbyMzaRbf1Fhj9wmmfZpsmOSN4UqsWYsd99FusZvUqyXLB92VP6F+pRDJId8W5hn7Fsw0fPfwbeNM6EhuJEDHoaNjohAqy9fWaDD3PO+7UN8/TG1gmWxJd8nGABJTVm7E2Y8ZLXdQYeuqQye5ivBflhoSMfukAU7qWfYogcAeLlj2emInWlaH5J0lwq+9hhdbX2Esja0aKgZxxnXqAcxcq4pZVUtUD3+0JnE7rdhGHNVkxddqofF/5+Ic9NowHLllQjAf4SICkp8XmjyTSh9oqTEShJhMVAf3Uvf/ps8j4LNMFqHhwK7cNrxbi9NRFRFIq6O6MVBU8pHzncXy3GHycyNkbXTUcUZX7yyR1BQW6BSD+R1ezYFnYxvHUQBgQ1xKInlhOOC2+JgsA5RTi/5FBSGpJ2c4YkEW6F+gHvwf25TCj+43Wo2FwftHw+G3n8fwXbEqLVxdVRHBSrgWcqgnSKHu9AROyUIF6lbJMGwUA3n/fG3Mokq1ejsUDiA54Vh1AiWeeSejMvxxms5sWHik5U229SFJjRb5NKUeJBN4MEkqHq88BJTuPSKi7JPBrUGnUgH91nlGWR9GnI2y98prapC8t36HMYCe1K8axOZYMWhwt+pRez7PF+SjRDeQ/OZWkjj08sAPhVwkC2RhGIA38zf+/73NekNyVDXOdpMsaRLWl1clDuq+gX5h5n/aa++IqvH1gvZ/w6B6wKtACQ9VyptzR4MnPNvyyyMyzp4qslpU2In7BdEQs0bMolfqMN7j31bFn/77Sorbid90tgwdbxpY6gfsDIe0sTNhcVk17j+7eG56DJZMeRas1ZHdFVPZxp9QH4vFI63vmr8+OVZaA8lp4Upys48D/lL74VsV0gaBDYa7AKUgfW180kt4nYqvolbL3Q27iEY1N1
 7OL4ILZd
 9lU/SxaO5+9bwlRbqlimmHReOy3AcB51Ar7y5Y9bCaBZkeUglpAzLl098sHGfRMNt8cWA4FV4vOVgArFijqLIzbg0bdbwK1vlETxheuMfm+Kr3h1DqS92WihRWcwr1o1OtTR1aWXINswc7DueG0Vmo1lLO0O5yDXssE5JvfojAObQ7Ayr4OoOz0EfOIJFIz9eL/WR4dMxqZTQ3W7poaOgJi6Lx7QsSXo69TzlBkomu4fbsZdbLWXJ7xXAXFxXTOEcTRKokyJ25Snw28PRCX4t9vkRN7XRD+enEDFM2kl6AxTTl1RcBh3SCOZ0P+FPM2fUsKGskxm9u70XAFj3gEFIx8HWWzrRj9EMLDZnY47mro1inGYpebECSLKqCgIjrySbhcPefdbRSVsxzmw8uxIF82pnCIuyqWdCUyC21gSvgu2y588UMTsJhzKf/3eDqYYkOh0ES4f7oC6LP/POut8vFiP95lRyweh3cg++F545aHvNTvCxNsfZKxnQag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

khugepaged.c holds both the users of collapse and the machinery that
performs it.  The daemon's scan loop, the sysfs tunables, MADV_COLLAPSE's
entry point and the collapse itself all sit in one file and reach into
each other freely.  Nothing marks where a user ends and the engine
begins.

Start drawing that line.

Add mm/collapse.h for what the two sides have to agree on:

  - enum scan_result - what the engine hands back;
  - struct collapse_control - the state a request carries.

And two constants move with them:

  - KHUGEPAGED_MAX_PTES_LIMIT -> COLLAPSE_MAX_PTES_LIMIT;
  - KHUGEPAGED_MIN_MTHP_ORDER -> COLLAPSE_MIN_MTHP_ORDER.

Neither is a fact about the daemon, so both lose the KHUGEPAGED_ prefix.

No functional change.

Assisted-by: LLM
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 MAINTAINERS     |  1 +
 mm/collapse.h   | 64 +++++++++++++++++++++++++++++++++++++++
 mm/khugepaged.c | 79 ++++++++-----------------------------------------
 3 files changed, 78 insertions(+), 66 deletions(-)
 create mode 100644 mm/collapse.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 35262aa3e67e..36315972156b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17434,6 +17434,7 @@ F:	Documentation/admin-guide/mm/transhuge.rst
 F:	include/linux/huge_mm.h
 F:	include/linux/khugepaged.h
 F:	include/trace/events/huge_memory.h
+F:	mm/collapse.h
 F:	mm/huge_memory.c
 F:	mm/khugepaged.c
 F:	mm/mm_slot.h
diff --git a/mm/collapse.h b/mm/collapse.h
new file mode 100644
index 000000000000..b115034d9018
--- /dev/null
+++ b/mm/collapse.h
@@ -0,0 +1,64 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __MM_COLLAPSE_H
+#define __MM_COLLAPSE_H
+
+#include <linux/mm.h>
+#include <linux/nodemask.h>
+#include <linux/pgtable.h>
+#include <linux/types.h>
+
+#define COLLAPSE_MAX_PTES_LIMIT		(HPAGE_PMD_NR - 1)
+#define COLLAPSE_MIN_MTHP_ORDER		2
+
+enum scan_result {
+	SCAN_FAIL,
+	SCAN_SUCCEED,
+	SCAN_NO_PTE_TABLE,
+	SCAN_PMD_MAPPED,
+	SCAN_EXCEED_NONE_PTE,
+	SCAN_EXCEED_SWAP_PTE,
+	SCAN_EXCEED_SHARED_PTE,
+	SCAN_PTE_NON_PRESENT,
+	SCAN_PTE_UFFD,
+	SCAN_PTE_MAPPED_HUGEPAGE,
+	SCAN_LACK_REFERENCED_PAGE,
+	SCAN_PAGE_NULL,
+	SCAN_SCAN_ABORT,
+	SCAN_PAGE_COUNT,
+	SCAN_PAGE_LRU,
+	SCAN_PAGE_LOCK,
+	SCAN_PAGE_ANON,
+	SCAN_PAGE_LAZYFREE,
+	SCAN_PAGE_COMPOUND,
+	SCAN_ANY_PROCESS,
+	SCAN_VMA_NULL,
+	SCAN_VMA_CHECK,
+	SCAN_ADDRESS_RANGE,
+	SCAN_DEL_PAGE_LRU,
+	SCAN_ALLOC_HUGE_PAGE_FAIL,
+	SCAN_CGROUP_CHARGE_FAIL,
+	SCAN_TRUNCATED,
+	SCAN_PAGE_HAS_PRIVATE,
+	SCAN_STORE_FAILED,
+	SCAN_COPY_MC,
+	SCAN_PAGE_FILLED,
+	SCAN_PAGE_DIRTY_OR_WRITEBACK,
+};
+
+struct collapse_control {
+	bool is_khugepaged;
+
+	/* Num pages scanned per node */
+	u32 node_load[MAX_NUMNODES];
+
+	/* Num pages scanned (see khugepaged_pages_to_scan) */
+	unsigned int progress;
+
+	/* nodemask for allocation fallback */
+	nodemask_t alloc_nmask;
+
+	/* Each bit marks a PTE the scan accepted as a collapse source */
+	DECLARE_BITMAP(eligible_ptes, MAX_PTRS_PER_PTE);
+};
+
+#endif	/* __MM_COLLAPSE_H */
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 081f705cfca2..8889f75cf45f 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -26,44 +26,10 @@
 #include <linux/cleanup.h>
 
 #include <asm/tlb.h>
+#include "collapse.h"
 #include "internal.h"
-#include "page_alloc.h"
 #include "mm_slot.h"
-
-enum scan_result {
-	SCAN_FAIL,
-	SCAN_SUCCEED,
-	SCAN_NO_PTE_TABLE,
-	SCAN_PMD_MAPPED,
-	SCAN_EXCEED_NONE_PTE,
-	SCAN_EXCEED_SWAP_PTE,
-	SCAN_EXCEED_SHARED_PTE,
-	SCAN_PTE_NON_PRESENT,
-	SCAN_PTE_UFFD,
-	SCAN_PTE_MAPPED_HUGEPAGE,
-	SCAN_LACK_REFERENCED_PAGE,
-	SCAN_PAGE_NULL,
-	SCAN_SCAN_ABORT,
-	SCAN_PAGE_COUNT,
-	SCAN_PAGE_LRU,
-	SCAN_PAGE_LOCK,
-	SCAN_PAGE_ANON,
-	SCAN_PAGE_LAZYFREE,
-	SCAN_PAGE_COMPOUND,
-	SCAN_ANY_PROCESS,
-	SCAN_VMA_NULL,
-	SCAN_VMA_CHECK,
-	SCAN_ADDRESS_RANGE,
-	SCAN_DEL_PAGE_LRU,
-	SCAN_ALLOC_HUGE_PAGE_FAIL,
-	SCAN_CGROUP_CHARGE_FAIL,
-	SCAN_TRUNCATED,
-	SCAN_PAGE_HAS_PRIVATE,
-	SCAN_STORE_FAILED,
-	SCAN_COPY_MC,
-	SCAN_PAGE_FILLED,
-	SCAN_PAGE_DIRTY_OR_WRITEBACK,
-};
+#include "page_alloc.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/huge_memory.h>
@@ -91,7 +57,6 @@ static DECLARE_WAIT_QUEUE_HEAD(khugepaged_wait);
  *
  * Note that these are only respected if collapse was initiated by khugepaged.
  */
-#define KHUGEPAGED_MAX_PTES_LIMIT (HPAGE_PMD_NR - 1)
 unsigned int khugepaged_max_ptes_none __read_mostly;
 static unsigned int khugepaged_max_ptes_swap __read_mostly;
 static unsigned int khugepaged_max_ptes_shared __read_mostly;
@@ -101,24 +66,6 @@ static DEFINE_READ_MOSTLY_HASHTABLE(mm_slots_hash, MM_SLOTS_HASH_BITS);
 
 static struct kmem_cache *mm_slot_cache __ro_after_init;
 
-#define KHUGEPAGED_MIN_MTHP_ORDER	2
-
-struct collapse_control {
-	bool is_khugepaged;
-
-	/* Num pages scanned per node */
-	u32 node_load[MAX_NUMNODES];
-
-	/* Num pages scanned (see khugepaged_pages_to_scan) */
-	unsigned int progress;
-
-	/* nodemask for allocation fallback */
-	nodemask_t alloc_nmask;
-
-	/* Each bit marks a PTE the scan accepted as a collapse source */
-	DECLARE_BITMAP(eligible_ptes, MAX_PTRS_PER_PTE);
-};
-
 /**
  * struct khugepaged_scan - cursor for scanning
  * @mm_head: the head of the mm list to scan
@@ -267,7 +214,7 @@ static ssize_t max_ptes_none_store(struct kobject *kobj,
 	unsigned long max_ptes_none;
 
 	err = kstrtoul(buf, 10, &max_ptes_none);
-	if (err || max_ptes_none > KHUGEPAGED_MAX_PTES_LIMIT)
+	if (err || max_ptes_none > COLLAPSE_MAX_PTES_LIMIT)
 		return -EINVAL;
 
 	khugepaged_max_ptes_none = max_ptes_none;
@@ -292,7 +239,7 @@ static ssize_t max_ptes_swap_store(struct kobject *kobj,
 	unsigned long max_ptes_swap;
 
 	err  = kstrtoul(buf, 10, &max_ptes_swap);
-	if (err || max_ptes_swap > KHUGEPAGED_MAX_PTES_LIMIT)
+	if (err || max_ptes_swap > COLLAPSE_MAX_PTES_LIMIT)
 		return -EINVAL;
 
 	khugepaged_max_ptes_swap = max_ptes_swap;
@@ -318,7 +265,7 @@ static ssize_t max_ptes_shared_store(struct kobject *kobj,
 	unsigned long max_ptes_shared;
 
 	err  = kstrtoul(buf, 10, &max_ptes_shared);
-	if (err || max_ptes_shared > KHUGEPAGED_MAX_PTES_LIMIT)
+	if (err || max_ptes_shared > COLLAPSE_MAX_PTES_LIMIT)
 		return -EINVAL;
 
 	khugepaged_max_ptes_shared = max_ptes_shared;
@@ -378,19 +325,19 @@ static unsigned int collapse_max_ptes_none(struct collapse_control *cc,
 	if (is_pmd_order(order))
 		return max_ptes_none;
 	/*
-	 * for mTHP collapse with the sysctl value set to KHUGEPAGED_MAX_PTES_LIMIT,
+	 * for mTHP collapse with the sysctl value set to COLLAPSE_MAX_PTES_LIMIT,
 	 * scale the maximum number of PTEs to the order of the collapse.
 	 */
-	if (max_ptes_none == KHUGEPAGED_MAX_PTES_LIMIT)
+	if (max_ptes_none == COLLAPSE_MAX_PTES_LIMIT)
 		return (1 << order) - 1;
 	/*
-	 * For mTHP collapse of values other than 0 or KHUGEPAGED_MAX_PTES_LIMIT,
+	 * For mTHP collapse of values other than 0 or COLLAPSE_MAX_PTES_LIMIT,
 	 * emit a warning and return 0.
 	 */
 	if (max_ptes_none)
 		pr_warn_once("mTHP collapse does not support max_ptes_none"
 		     " values other than 0 or %u, defaulting to 0.\n",
-		     KHUGEPAGED_MAX_PTES_LIMIT);
+		     COLLAPSE_MAX_PTES_LIMIT);
 	return 0;
 }
 
@@ -476,7 +423,7 @@ int __init khugepaged_init(void)
 		return -ENOMEM;
 
 	khugepaged_pages_to_scan = HPAGE_PMD_NR * 8;
-	khugepaged_max_ptes_none = KHUGEPAGED_MAX_PTES_LIMIT;
+	khugepaged_max_ptes_none = COLLAPSE_MAX_PTES_LIMIT;
 	khugepaged_max_ptes_swap = HPAGE_PMD_NR / 8;
 	khugepaged_max_ptes_shared = HPAGE_PMD_NR / 2;
 
@@ -1571,8 +1518,8 @@ static enum scan_result mthp_collapse(struct mm_struct *mm,
 		 * any smaller order enabled. When at the smallest order
 		 * we must always move to the next offset.
 		 */
-		if (order > KHUGEPAGED_MIN_MTHP_ORDER &&
-			(enabled_orders & GENMASK(order - 1, 0))) {
+		if (order > COLLAPSE_MIN_MTHP_ORDER &&
+		    (enabled_orders & GENMASK(order - 1, 0))) {
 			order--;
 			continue;
 		}
@@ -1636,7 +1583,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 	 * is then checked again in mthp_collapse() for each attempted order.
 	 */
 	if (enabled_orders != BIT(HPAGE_PMD_ORDER))
-		max_ptes_none = KHUGEPAGED_MAX_PTES_LIMIT;
+		max_ptes_none = COLLAPSE_MAX_PTES_LIMIT;
 
 	pte = pte_offset_map_lock(mm, pmd, start_addr, &ptl);
 	if (!pte) {
-- 
2.54.0


