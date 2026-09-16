Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C37FDC88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 09:32:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B98A6B00A3; Wed, 16 Sep 2026 05:32:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26CD66B00A4; Wed, 16 Sep 2026 05:32:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BD706B00A5; Wed, 16 Sep 2026 05:32:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D6A0C6B00A3
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 05:32:04 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A9B57A0679
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:32:02 +0000 (UTC)
X-FDA: 85219108884.20.C735092
Received: from fout-b8-smtp.messagingengine.com (fout-b8-smtp.messagingengine.com [202.12.124.151])
	by imf25.hostedemail.com (Postfix) with ESMTP id A3650A000A
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:32:00 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="F ZrwW60";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=djeJHwrz;
	spf=pass (imf25.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.151 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789551120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=avMkfLVeU1+RrFVq7dqGuSLkfIFTUHtIkOYpYaIIbGQ=;
	b=cnXuGENBCsXonywY95vq9TEnNjzeUWnIsi2wAy7yaWtJjshrbpBS3OjKPumRz7rpSGsXZz
	ZoRgiWcodz6LUtXTWtyADAgU6jv1lfwzzZJr6gergFzfOgl2aDPAKq/6SL2Zq87ukqQndW
	b/kZ66FNXnI0dloAVLMrnimygUucNwE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789551120;
	b=tA9QIcucC1+kJ0iC2Fbp4wFkkISOP4umSTHq+herj4mmH5DRgzFd+DcXznJblE+wX5VCvu
	2i90Y0wxDRdZe0i7pBfW3TdRg+hGpUejiuvllehDmNJoiQuvfRakKYF0et260a18AL3Ehw
	4xqJk6K3JhZ+C76hfc1bZho2EWIi9j0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="F ZrwW60";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=djeJHwrz;
	spf=pass (imf25.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.151 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.stl.internal (Postfix) with ESMTP id A1EE61D00084;
	Wed, 16 Sep 2026 05:31:59 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Wed, 16 Sep 2026 05:32:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1789551119; x=
	1789637519; bh=avMkfLVeU1+RrFVq7dqGuSLkfIFTUHtIkOYpYaIIbGQ=; b=F
	ZrwW60a1m5sQGSEnlfYHRzgoLkG3D5P3kbyYZypS4G3D1Y/sjXhpr+7XMk6fPFFc
	CB4jWSRtzSCkTUPHawA5jvvTbt131TRr573B2NaRjDQxcbLXdfsIAhB3E1DefPle
	bngTFW6EQS2zIxkMX6HgVaKLMT6uF4JOlDePTF/tK+W5IjXtNjjAG5FHX/c/Y+MP
	+qKbycwVvjWyhQ3Rw9SR4JwG78QD9Uqa0blpocyFxp6zXe8cx5vHRR/kGKaGYoPf
	ZwjzbG/oFXjNTSDozQ3OpU5DU0dAYIwpaJbr5RGlXlOZ+lj0lRDYz+T0LDczyUP3
	h29BdUPt4biFOn7V9GDtA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1789551119; x=1789637519; bh=a
	vMkfLVeU1+RrFVq7dqGuSLkfIFTUHtIkOYpYaIIbGQ=; b=djeJHwrzEVStD9qyQ
	ZxZOoZpNzwDjC1N9/9C41R68YCIusyuxXLL62GTE3BfGRGQr+3uCX6Z4STy9KQgZ
	v1lnlGMWKyIOq5DNRt0o6NO7AJos5JR6akblkt63RY0m2/jk1fOxdl4uYMapOiMS
	EWpgiMkf5L5wOTAot3xc8PABlHDOn+HNeBCV9fwtC2h+az2Shs6HJTRjkLyWZwtg
	LNuouYC245nIGuua80XJZ+2L+YWJ82WtIWuT25sxY4bAnKLevX+sQOW+0P6TZbWT
	e6bnxQlO0rCrOLdht18tOgpWLzFGgINRMWKJzIwDgzVt6cZmEN190Ope9RS+iBBR
	JTLyg==
X-ME-Sender: <xms:D2KqajxbPVqENbOUiJvivXcnZo6lYSFQdnf80JnJjmZk_TVcSNhc0A>
    <xme:D2KqanN_rPjN7L7FDlQOBEiLc71wrxd_obltgAcTetYQgT5Q0jVor7MR-s5OZdIc_
    SNi6k4BeYg4aES7bXtBcYsq7c69iP0vY_Ikkiu1wvUTHcUg4mAKMhw>
X-ME-Received: <xmr:D2Kqajcy2da2dpJzluFoSDMkJSzmGVmDtd1ugazN67sXnDYhZJTSyMoZTn4>
X-ME-Proxy-Cause: dmFkZTEOpyDQEfQMjLyldXBPAs1OiAaYjuycA/zprc2XA0sZE/gLY53LzRl6wisjmJsNcj
    shXh7L3amtO3W7Dj4gJ1brhV8efHSvbbvvisq8qNCVrU/hVVqWW2fJ8EDoeL9EfJt8J4fa
    r63UA+S0A+UN3c16swmwWrTj5sK0gOy7RYH1CN+xe4D6TTQ1ncSXBFkweWqSBfk0S52Say
    Dntsl8DI3TlZwS0igZd1iO+ltDo9n3qHIbwcYcvcbVUlu6Rxag/XK6s48+7ZTTYlI2aJe4
    hkL/jN/KxntOAh39VLdXeraBW39brB+PkStvfnz0wMlwqVlAhF3nsCCzTv21LQWeSF/iTb
    MYrnHQOmaofpdATEhW+iKqNMndVUsZkNXro4u1ND3HQ+RLuEHTdkLWeBbFKVfegYNYqNlt
    X0JHLDrQLD/yJxqXyO2trj9CcN/tXL6neVs2190GRVKkh/LvWIaouJinauIO1qOlOd9xe3
    jTDXmMnXkyZwXmnXqPrLOnKd/ybmml26i+ErYaHUo20TmQcmlcVzeB+TjmfO9B95GMfhsm
    duaCze2HijSX0CfsyWMswWKk99NTMjR5xQp6haMLPl2xKWlu2BgRSz4hIqt2zAWsJuTo3Q
    asDhRbeixb8zNswBS2kN4z6ROulafxWeWuICeF4opQx4KFDkTKvNGnlsyXYQ
X-ME-Proxy: <xmx:D2Kqaj6k8bzE84wZJ3mt0Fa00S_caLtog2DXfbi51sodcfswnvuheg>
    <xmx:D2KqajJVWsZoDEO4jMuQGqEY9XXnI9EkbEmKB3O9m9ZymDKeaHqGkw>
    <xmx:D2Kqav7NQSAP14nyKodNKdCtl0nkPb73PEKkTf-kvG60JUgicOzDrA>
    <xmx:D2KqaqYI3k-7EsAkx_BjmfR3HzjQX9_e6ZKxzcju068WwDwFjdZQZQ>
    <xmx:D2Kqaphkc_syIJBaS77XiuVOLStIDHHlQKZYuZt0JnC0MkgSfD0vgwjr>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 16 Sep 2026 05:31:58 -0400 (EDT)
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
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: [PATCH v3 04/12] mm/collapse: add collapse.h for the collapse interface
Date: Wed, 16 Sep 2026 10:31:31 +0100
Message-ID: <20260916093145.4022188-5-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916093145.4022188-1-kirill@shutemov.name>
References: <20260916093145.4022188-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: zoa4u57dpbon1znj1bj7q1ahdkupfiaj
X-Rspamd-Queue-Id: A3650A000A
X-HE-Tag: 1789551120-142226
X-HE-Meta: U2FsdGVkX19UmEVf6NFQHlRuQItXsPAEQYVJd6cOFuQOnbv+mietyvxrdLGVvAqry00r6OAZC/cbE2bwqzjPN9BI/B1zBASJ1T98VTQmS7oc1yNlTTNaMIkMaUBPGMuWTUvnoENcU5+XhvZ6Zda7J8TOedIzasD+U0CQglg9sOkEzftbB5Ya7zGsyYW41NYMzlgSERpjclwPtHDBsjReVUcMWPxQgm0LYs6iIU40hLwFdawd1W9Trb7IDHIcSCvktz2flMNa0fT4mQri4eqDw/vw6OZIR304etIQIsqWtXvU3pnV6OLX+zyV7rS8xrGAaW1bQFZKSSrnclAf2Ro6wBX1AlJrH7upmQuUU0lM2E5MzhBeMUdcgEjOWMfRf+yiobXoZXwGbZW2fdGTdVJHF3L1L6e5B/2oUNcasfJ2EbUFAv+XLHD1R1Ek14NkZ0WkGzKCQDDzBG89zv67xqAHMPgbeqs3TQdLUxox3OxDJp6ycohK2CAyZ+ZZ+M+tadXcE5JpyE4Cp7eQMsWByWEoM0c9G4g6TFbzp12NqSas5pucYwN1VVp0+YaYwoXLNWRBizBGUN7s9hc9XqL5nYo9N1ssFObs7AzIkGHpVivwC+cd/gYPgywOlgY2Rdnoat8mi8eWZU7rnslXBFL63JVX3OE0sAWwwj6KAp44fLlsSgKIpPVxb86lZ9ukr9V2AZlCkHjVJ0ooywLRhtr3RZKSDTyxnXLvmhCUKB8AtcxxhbVhYplCSgTdDG/Co1cjbrZYX042fHYtz+h7dEEMfliBQXnTXvfWzs8viB8SNqicfwXN03iWG2kN4HsPd8shHkJ9O97/Dg8zaJReqWigfKfFSoSgkegTVUc5qJug60v8mLj9OXczeXBvZcbkfuN/2fmgLlXiN1/t+2x64x0f099IfmDHa92ks5XSkEYUlkaQfMzLC3bNg1xDO7JfXj38IdD5rJuyXMnmFyuJKytjbH6
 7RokCS4F
 4BfKOM851rC1JvKPiEmLAq0a6jDmrJPbhR3CsxB7PvaySsCunKHH3oYL9rzBuDVZx02HT8ZCId7LyrVU5++Lge7Zj7FCfQGpxOooUtu5sjr8tiRyCxQPrpH0xef7jPTNg1SlgNO6PFvs9VVmu7nez/N5nrG6PIrdMBSj+qTlNvOUumaQKn+NeACTJprUEPe+L5YOX0oaU0e4S90d+mWCq3ogPKr0f9rHQa488kvG0f5qY5ykNtdAe3hH4t6mUKxZzFOOIZp4byFPBCsF4U8gKl4bz3ImqPzAonqYl/D9VJn5Njuua0aavqwLwttp019nFZoGfEfQUS9shGlOQ29yZRVrW7VKiApr4X+h6Qcpw8/LsBvvAPNa7Knis/6t47yZ3oqWXHVrnwXSZN9lwF77Ku0pGOYM+v3xTAsb+w3ftl+3oPg0iMLABpD3UVivDAHu927cBkBXR63hgBEZjdn3fbkL5qdQksoAtgGYCVHCd1pMDR8ci+8Wm8S3spQ==
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


