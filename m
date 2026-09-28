Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59340C9833F
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 10:06:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72A096B0098; Mon, 28 Sep 2026 06:06:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7024F6B0099; Mon, 28 Sep 2026 06:06:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 618166B009B; Mon, 28 Sep 2026 06:06:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2392A6B0098
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 06:06:45 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 85D3980153
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 10:06:44 +0000 (UTC)
X-FDA: 85262741928.18.5B1F344
Received: from fout-a2-smtp.messagingengine.com (fout-a2-smtp.messagingengine.com [103.168.172.145])
	by imf08.hostedemail.com (Postfix) with ESMTP id 97A42160005
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 10:06:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="l nuQMmt";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="d/1CgYFr";
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.145 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790590002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RKDJi3AfiBhTcWP1qPqCaP4qPVm9DvYRUxuv7WBYOag=;
	b=ylswEbzmPSIFqkTNbTo0ka6KxdC8/FmFEZn+rFWqo6DZAKrFi2WiQCorCqAorqF4pngK4n
	CfO4DDnqxvRJY7IPYfS2CcrLwZ94L2rZ5kcxso4wHqBTRHmfB4oDzp6OM5gVktaTnm31QW
	P3fr60SAZEuiHaGZskJnfuP6aXhjRJ0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="l nuQMmt";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="d/1CgYFr";
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.145 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790590002;
	b=S1oGY1YLBmh0SZYReQxXEtl0toDhLWVeITQgYlCQzZS6lcpP1WtePAEitqdm0y4C41H61P
	Us8nmK/SzPu9CaNDJ3juX+k0dyi2esrFxfd1AKFqmOq94JlSnoi+T9WvYFuvRg3Jipghgq
	cGNA2bh4BbUQhS3ghb0Y4AvqLuE6cao=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.phl.internal (Postfix) with ESMTP id 280ABEC011C;
	Mon, 28 Sep 2026 06:06:42 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Mon, 28 Sep 2026 06:06:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1790590002; x=
	1790676402; bh=RKDJi3AfiBhTcWP1qPqCaP4qPVm9DvYRUxuv7WBYOag=; b=l
	nuQMmtmxKLbSrfKohaz9rWzEqWRT9/tQPY5ls60ZjXUmn0Ev38unvFIpxgITQFIg
	Sxs4Y8vXzyC1ZYvT0Txyo21YsGHRMyCq5A6PWqehrVZ9Bh2eR7p8ZZhTWvygpI4y
	uw80TJ7nZeGeAX7IA4KcG/EBuy1L71MFjtoXyVl/rptBxV+JFLE3uOEXHxvsYbCb
	G40BYTL9u6RNZKXFhicFvtX0+n+inyhqaeSYBcvVq06kDmFXxRo2w5pRsK1kzCjb
	PCxOSuCQaN6Z52eUbIZGVMbuBMxXh9spiEr4At2Jse4aBAdakyC1yogkLFRtAkAn
	j0faF3kwo+z/rWQJLNuag==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1790590002; x=1790676402; bh=R
	KDJi3AfiBhTcWP1qPqCaP4qPVm9DvYRUxuv7WBYOag=; b=d/1CgYFr74tfjxgxF
	oVHh6l4yCjNEUcV0ao5CXF5bh1mbqJDZuWPAzZ4LBVX2a2p/5k6+CzEcBOEJNGUB
	xFSVP/NkBKC026jsSJgaLxFZ8MjcAe+T4j5CkBLe63rSNvdYHKlSd3TpR9Jxo6rR
	gVrn6hsBt05h2CmxWbfS9dAjcpRejWHMIY3UmwMJb3pSB3W7Dv/oIPaX70tgdgbm
	eAxOy5y/dgVoI8V8kqOxvvO+xPJyQh5vm2JVMA/zHsDSpbBsrapCUIXPVYQt5ljg
	8v+O/iSz8+BxMQov3L4k00Mt6ZujfsiHhW3Lbd9kseAq9LFkGyu5m1uCJXah2BvN
	rd8XA==
X-ME-Sender: <xms:MTy6atlBzFmUb6DLznMl62ZqCMIOFL84ZozBFxU643GwjftCxVsQ2w>
    <xme:MTy6aky-ceo4Emawg0KDhww_7TlR0Z1J4iqEMthKVOLR_JNqJM8PuA7Jr5M-eWjFZ
    5Z2vXrxlSudfAy219aUfMV_PmeOylW3m3ZQkPzDW3qW8TS5IzI642ah>
X-ME-Received: <xmr:MTy6apzqVxx6IymPBYRxDOlaGEzd2ESYujaxSK2hsAuslSo6niJZaxdTdbk>
X-ME-Proxy-Cause: dmFkZTF8+FzWl2kPFFw+2+MUnNndpG3Es29zlM3W8MqBD0QW9993JqL27RjsdWHL5iQTuv
    8LHkef+10EFcRNyu6aMfBJblGtUMhigK1wvWUg5pa/T2F4HZOycwBRl+2S+z7tqw2cJfHU
    gdsF/P6BOMqpKS9LZRm0d8oBtyKEEqCXwj8zji6pXjSixGW9yMDmevXCSXRhMug+RBOuj6
    H/TPGEbj0UBxBpkklI8Q2dk1KPN1FfxQ05T6kAzB+fcPQyWzSSafNh6004OlOqdREfhbRG
    BHI+j7BDMASDclZuapGmxVrXolh8JlQnm8Hn+THchpsYHB/1yAmWKg/yew9Ltzw86nEqJB
    +W5WWWJUhKBAb0cqB1M+3TYD0kh4N6peJUcWCChrtZaUdVDUqTH9JF2W0VklpB2LjlKL5k
    DMxeEhSpQpUi8wz2VV79XhL4v62ZC/JlZVumB/w7gXG+Aic51bDgQAOE2kmOOteAX8xoAk
    JiiYDliep80HHdl3FjWOpbkwvNJgL+V2a92DTY4Gwp7kiyuYMXM1oIV8LdBmnwxkSkpC+1
    z4Eh48J+/QOWiJzvvakkPkbQCuxNk42xu8oGdu8aSINBohiSP+AWZQHeQKIt0iIFpAJftp
    Rgs6d1yxDXCAKFNpeJSwUZhyKzGZOwFYN1jkEilzKdvSb1VOg2pZfgmFc1Wg
X-ME-Proxy: <xmx:MTy6aj_lrMDwmXzUjEjgj1ih_yj_DX865jGnkhScqkMMfLExtLDUkg>
    <xmx:MTy6ap_oZ2RLq4am-BaMpJu0yHSJ39kvHOWjMFzN3KhhAZLH-7BsIQ>
    <xmx:MTy6ameB-QycCagXpSyF1M0QdX6iVdW4H7Dpg09cT3FShgn-N2iHDQ>
    <xmx:MTy6alvCEZgqVlVWsAP6D4LsGvsZAzB33lvH4osmcRlVmqqgiL2mKw>
    <xmx:Mjy6aqFSSjEcERfKx9MJP6DbeKv0SzJ2sqOiMz0jvp8G_e7RZ0p1S-pz>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Sep 2026 06:06:41 -0400 (EDT)
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
Subject: [PATCH v4 04/13] mm/collapse: add collapse.h for the collapse interface
Date: Mon, 28 Sep 2026 11:06:18 +0100
Message-ID: <20260928100630.21870-5-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260928100630.21870-1-kirill@shutemov.name>
References: <20260928100630.21870-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: inaaoxhbuu8xubuh4ghr98hbyq8z9egk
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 97A42160005
X-HE-Tag: 1790590002-782014
X-HE-Meta: U2FsdGVkX19gA1KBcNNiKp99MX77NbSPoCuNjqDu/hGR9qOJcuui90xsSYUivn2egFiVsi4KRCbu9LIcv4IfRe9G84EFlkaFK2Y98fRnJbyIThe/Da9ClWKrKVnG1kq/vvAka6udqCHFadwMxJKC25ZQnvfIDatMtA8SG9YKm2t+lKYTmGxrAZvkbSi5zMHdeQGKGViKh7HGiPIWauTULglhL7WoRSaKx9kmz0UvQViZGRT+WQUwZspwz7zypIY9ziXoNmx9931NxF5A7vYqt2OxuQjepGweUsxtSrgsSKp1jKrK1mBAyBnQhZaDO22UcyXepzUDhmWvgawz7fRn3l9Jr5k7vR9dGwzDwykM9U4hGep60HZM9NnSzPkhtFd66LvUBUcwJlhsDYOAUzv7a69D1X5s3ykoFvcScXhYl3VS5puJYbnH0hnUkZKWa6vugyFOLJTiGE5XEvSKKr9XEAyLpSF04QzKvLOY8oIg7bynJcxfW/nFdGfyET1d7VY7jwrncTULMENeXRdz6ZeFqHTC5LwJJs6g/3XCr7cQ/4dcvAp1lgkD4KLqn+aw4RpWTGpcGZZM/2YVPUPQvvWN34ovMqvLEhmaPoMQ1rqrdPY0pCroV1sIpKJQG2XmcNEL/drl4JWTculKpF35CuB/iRRwrUFTsPfxbIQLlFyFBME9n6OCNcw5tbeet+4cjRYX64olSzq/2+vfzQDf0cNmCiyb4JMuBo5b2nrCMVyTmLmBpRCVTNd9KUJs8Z+ienKaBRXtcwlafLCZqYR59VQ46gOkj+1tiQz52Mn8kosgACOWPK1xlMiA515fyDC4N6uqtzi96OnXzBxfS+mFw8VWegfP3lusX7GJtDpqP1WHq/UG7EEoJ+lFmkhq0e/bDGkt2vC5u41D/MYBDQ1dk5FyBnV7laO5DsQRCweXh/zAaT8sNTxXhpGGlxrHJONNn4OL0MxQuU6xJviyeBTUBPP
 pzHBh1hM
 W4VwzDP66JcpyKv26+koKLbLsffKcZnM7d1Gx+nJAtTOUy2OzL+W3KiTFRTcolQ5hzB1PwrFlvizKAhPQfs5FAhpkpc0EvVjkeTvkgkJPaFMC/bMtLF4hmSlAw138vQe8O4OPU9C+70yGokoOC7Hs1SBXANqjqJjrM/U6hfycWp6zJ+DK9vixbxFPBzvJQ+1OsiZWRQQF5oJg2pSGMsSlXeELxRyr1pcE2EcbWoEz/FO/nBXXOBIyUMNBoPwC1wiXQ645WVapNIyLnI1kPoTfph/p9e9R1f1YJ85Nqo/yvmLXjMHZ8AS8qmm596Rke1+/0nuwrcWT9AyrYnP65wxTuM5hoHsrebw5ArBPxv2uUS/W1HR3TPMInp1TvOxLzxYurvN74+FnCyL3AL6c8z4CGmkZsYuHMNG2YIcvt/o5prLCyFKwfck4WMHKUWaxOylSfMguKaJzt8Q6UlXnuucDFmXsfDw5RCdtcWJygZDdmvEtffi0LUximtfXdg==
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


