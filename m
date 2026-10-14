Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EE2CC3DA7A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 17:12:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7854C6B009F; Wed, 14 Oct 2026 13:12:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75DC06B00A0; Wed, 14 Oct 2026 13:12:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FEF96B00A1; Wed, 14 Oct 2026 13:12:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3886C6B009F
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:12:12 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9DA49A06D8
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:12:11 +0000 (UTC)
X-FDA: 85321874862.07.2180433
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id A1A374000F
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:12:09 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ViRd0HAK;
	spf=pass (imf01.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791997929;
	b=zyNKXcQKzY2RrFsDmCPJiy2t2S//8WkaEdSuwCf9iOygi+pw/M+uuFz+jL5s/M7NtCY/Ea
	LP6lc+WRD3gCvsbRFzu4r7o0ORLdoZpz8jK0u4D82eoxUfdmP2PhfcvAKtBKfr5nxctWwm
	CXSnN0Hubs6+pASw1VNVQpBFTIlmBkw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ViRd0HAK;
	spf=pass (imf01.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791997929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ShSnl0s4wMl3a7RQPjqaLqC4nuPGmoj03YOG6FYlsOc=;
	b=yvTShPTxM2Z8iHLqHWF4q5XU1vMLSetNb448YgguCQWWV7uPM+ABZ8MMGMO6JmeymSv0cQ
	rT22tMSZS4wExOJ8jKJwOPp3/70MSMvYRaiVlBu0Asux3gH+BdTQOLni8DVqa6zOGOY/tC
	CYx3VbfcBi8sjb9+Jx7oZoPGU/LFJlQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EC62E43F86;
	Wed, 14 Oct 2026 17:12:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C93021F000CA;
	Wed, 14 Oct 2026 17:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791997928;
	bh=ShSnl0s4wMl3a7RQPjqaLqC4nuPGmoj03YOG6FYlsOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ViRd0HAKXY9XpoaxQGoqu4chn69XONNKdAzEpYfoSIJq13WKYFQJeL2Aqvf74nDw6
	 zv03qn3gQuhrlx8HaYqhzdeAhBABAPB14DnD0nkkNVCziv4Rc8W15Mk+deFHk6B/M8
	 Gt2YwCeU8UZ9F/jr8Z+07t25JNc4o/zLJWdT16iFNDC57PfwZBaewWgpjkOf0AsvGX
	 0eiJBfX8Evumx6WGYm4N4nuCxd7RxMZcYe9i3iKqmJ2eiAUJ5YcdUr7RdY4GSVuAgh
	 sbF9UG8voqqoJXGgN88ohJ5eTycQupUUTWcwsdy86RORj7l6gosPvFcTSh+/9rtdGk
	 EsO5v4tGsnF9g==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.ams.internal (Postfix) with ESMTP id 09B10198003A;
	Wed, 14 Oct 2026 13:12:04 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Wed, 14 Oct 2026 13:12:06 -0400
X-ME-Sender: <xms:5LfPastWTqtnrWJmQbNDfEEBqiAdU4dxMrSXNnisIAz4UnqlkXzBdQ>
    <xme:5LfPalYVvqgHrdOhgneVM-yM3wMnOiW9tJO43PY3w52hF1bD3gBczy2grWeLX7iBV
    yPxvWkIwGQ0TFtOZUHYteRKKa-rXqw-BtL4yBJRZiy1Gn_y_g-4ElDh>
X-ME-Received: <xmr:5LfPat71Q6L2F863fmZI8bmhI9Blm4yjCd8LOf-EIhFUXD6LzqM7WO7tsrs>
X-ME-Proxy-Cause: dmFkZTEOl4NfFwPDLSBmMqKx+7N39IeMIni7MK/u+VvxaGQ1bs8GfI9RPH3ayDujSspKBR
    qyKM+cOOmgGIjV1p99esKFBZjBYm+2fZxsu+dp6kV/40GtAwNmLs0lveP2Nu4w+lTJFNGX
    +PHSDDgHqCL4KFJyfY61faoRzA0h8vW6kqyfQ8QWLAhZGC4dGYbGOPKI1Rz1FZYlfQX1qS
    ZyU+Kn8XAf7cjImjIHoCIXuQM1OjXWl7zezG3uHTMAWWFgZp5y0YQrE07Fctth46IOKxOe
    Y9yLqjV8DtTpJEgGM7OnnqWtPPljjv3Jg1+LTtq+j0gFbbCdpQA4+mOsItlGLpSNkwSLUp
    fUIij6+zakCVqiNm56dDXrp+/IUf7QHaMv4Ycu0EcjKS8tcltDboCGyRh+TIMT2Vr2lg4H
    XLkdkHsSuFYWpkhFHXywjNw92gUE3F3MRWl0fV1vcbV66Zad3oq5PGCh2PE9QmjqEFHqEw
    eOaK8WxsLPG9heqZ5dvVEcpMpK90P0c3Zv6UotQbw/tKfBuXbQE/amjdWuIhxOyi1quj1S
    p/yy4/wEoAW0pbDMMr8Pf5IkRbMzdKdCRZZHyJyIPG+Hbt5UdvIf9Svp5GEBg85uoUBeTI
    mUmWbFIWK2AQ4FTZXPg38JWNKVt916i8wdtG7NyOZmTyN4BjRepw5HokwEuA
X-ME-Proxy: <xmx:5LfPaln8InUikG4QjQYjGKQCZgORgEs_C2zDpB3CN67uoA6SgBZVbg>
    <xmx:5LfParEaaSuUJW5R9PuwkzUkwL2oxbz2d7NHqZNdsE_Hv5-G6pQldQ>
    <xmx:5LfPahH_D6AH_Ks27bB82Ll99WgnU4zYUuKxvRYwgvnKY5zWkExXCg>
    <xmx:5LfPar3_Q7LmrPz87pdWDi1MTezBHsW5Ys-PWL4xLVOesIOXGs1rng>
    <xmx:5LfPardIDglei_fQOxThfvo6CNuyo2hV5wM6Q708ji6A369G-szj2daO>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 14 Oct 2026 13:12:03 -0400 (EDT)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: [PATCH v5 4/9] mm/collapse: add collapse.h for the collapse interface
Date: Wed, 14 Oct 2026 18:11:37 +0100
Message-ID: <20261014171145.3292736-5-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261014171145.3292736-1-kas@kernel.org>
References: <20261014171145.3292736-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: tpr66ia4919umoqind1a9zc3jgm1xz1m
X-Rspamd-Queue-Id: A1A374000F
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791997929-765679
X-HE-Meta: U2FsdGVkX196Do1ZsB0448BlhVdnWWBnCsuf97Yhqkx/ZPqG/B0MqvXnIaDGn6u/m8U4xovmWh9XKVejq0P0Olix0CUuxCyhN1um+qwsEiYYw7p696wroug9tk0MPyNC5cuTy9HRWFCoSGMjeX+E0NSorRMH40fJKe7PTEwwXU671ImH/H+1yaC5jeycsLr7HBFx/4LfA2L1JvXJepDtpvgK5YLc6UEB8ZQqOIVy9jmG/sKVsJAKv4TiU8OP9J8djItMNGQYQWb9OxwzoE+L/H+G45k3s4QXJQ6xZQn7p2PX2cy4tnSw7im2eMEzr9chzmL/4hgVf/Rtu+EHK2H96FQ2EjIQNuiK5M3O/Z6g77oWpBKT49smcXPZXAqlCRfLsk+mFMHdEGrf50+c72EH6yCKRvMfj/MSjX9c2/N/uuIutN52CKOdVyJ/4adIz9dfxr0RFxp1FDuwU873FDJ+MuvOUR8JefWCNPniBrT4OS2QOGFq83Zfp6uLTSGvA6PWxsVWa2XSObcvL2lmuwsFq2gDKACk9PCTeSDN9Flpn1oDjDSNzO15v1eUq/D3B8FCdGpAX5uyiWSoRgq5V7/D36h0o7zbusYb0/Xo0kCsKm3Av+N89CL7BkRJd9j0hrjKSXUsx0+qMUPxZUZ+iK/xZdJSz4zre1+VSuEcCoKUy/wTqKDkN9TInf5PUFMsz9UoyQzQauUAcXAxSA0rNcf/o3TEQrBGCfBU9kHEYpnOTtwjlLZXObsbSokc6hBU98jpKFgea4p4wJCmJR298UB7wZIkD7trf5+O7KDLnxlw/NUU8bIWuhjb+5tAwox1N9KGMLCLUCsFNrYF4br8Ic2vHuVBSmA0Oi/I8B1oO+9RFTe+QWsz1WKmXXWLHo0IJP/92ZOZONDkN1nA93nnnrrwBezG6XsqcF8NYvlGAM2BDIkhNBHtQaR3dndt6iWk31LM8BhbVuHFxVul/Rk/E9P
 NRgESCFz
 PhBGjXOvu85rPdNoxfx0vIbj7L1V60jgwvdSOk6Edmj++bk0CcPogNvXfBOaaHkir2LobYMORCC9vfzCfcxOiIBwNgXNKZXcCBQzdJFK+mRRrGqzVpPgWQk2xRXa6cI2LQfdl//p6AUwcPb4x48M7kieGwkIB/vVKqkOhEkmIXyaCu6jtPyCwAotS8HcnPgwdvGD9mO8g1/4m265IcoWNYyvuhwFgdY15oI6op7X/1gYKpjwU0RTPVOzdg30ppHHnlrS1OvhYmIlY5cNuk6EoZs+LJkRCe2rzl6V70qlhF/5SFVn/PTvaSHp82g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
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


