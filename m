Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA155C79F82
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 15:10:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26C7D6B0098; Fri,  4 Sep 2026 11:10:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21D606B0099; Fri,  4 Sep 2026 11:10:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 134096B009B; Fri,  4 Sep 2026 11:10:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DC3346B0098
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 11:10:40 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6A4C8A0158
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 15:10:40 +0000 (UTC)
X-FDA: 85176416640.07.71B558D
Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	by imf12.hostedemail.com (Postfix) with ESMTP id 652F040006
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 15:10:38 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="B wOt+/m";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=Tcm0kQra;
	spf=pass (imf12.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788534638;
	b=2qwflYL2dCt95JKzRn3cY1/wHox9VibkUABgAA7ASTUedPwfQcVqqhc9HWzrW8+xxhwVk5
	h3ad8KI5KbmltoLWDwhQmpj+euC9H1CYARhYT4FYaCzyk9+8pzW2lsN3QtE9942xhih9uP
	CwbNYieW5ECaQWiLn/tOA1FcrO6rBRc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="B wOt+/m";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=Tcm0kQra;
	spf=pass (imf12.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788534638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nyjSpTkitaIBwBQZFVJW04eBDamEuOqIJHNiEPmdqUM=;
	b=scKOwqMrOjf7y4ICNCvyAF8PtQxZ7P3kVk/QMfy+3473HZ3uZx2ge/bfeuxpKPBlpKRAea
	GR2d6uu2S4xTwH+hveM3sC6e0rU/tBmNE6ECJWQzf5OEsEMSr+fZRl18T+96aVZsXZKya7
	jjMt9ZKyq2ugcyOKVN1leFpMEFOZcxA=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.phl.internal (Postfix) with ESMTP id EAD38EC00AA;
	Fri,  4 Sep 2026 11:10:37 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Fri, 04 Sep 2026 11:10:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1788534637; x=
	1788621037; bh=nyjSpTkitaIBwBQZFVJW04eBDamEuOqIJHNiEPmdqUM=; b=B
	wOt+/mFnt/h/sU+raMZxq/x1lYjxE5boHz0Hy8uREHkZaQbiqeWSGEEFwPzXfZ9h
	qBOpgGexXa8fFndj4lUwdjMX/97SC1FNwJg4r3t7b8gjcLFHckbY4m5xfI9ROWZI
	sAljvXaKv4Mq+L3AqEiQGuML1CabxtZYzP2dek7FYyb9Mxl5y+XUw4Ajzej3NW7i
	zftOnVvczlm5eviZgAjOYIPIaT1wVEF3Yeb4b++ElYDHwfYS00vW6+ygv7yKPj5V
	dVE9ZgPZH2XQmCAeFkZziCiHJRCj5++s4Y3BMMG4My7tajZh+OJFHG3pwKu/YNfD
	/VdwsO6YNaeZAATW66brQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1788534637; x=1788621037; bh=n
	yjSpTkitaIBwBQZFVJW04eBDamEuOqIJHNiEPmdqUM=; b=Tcm0kQratdTRy0Ygm
	P8kL1rZ0CLg9Qv0GrMWpgMEY6iXtoSrrRVbqm5C9u9NNxdBkQrNXr2Ux6f2+PkYr
	DGqQNm264adjxGuRKJ+uEA43oJMBjsBvJX+zS6cdjPTi7Ec6YVImhp5Cz5Oppjki
	gt3NZc2PBG4nSI/tjQYOCzi4bZW/LWIyrhZ8qAnusL3ok9dYhw5H7SA8Cv0jDzK4
	RnKDMiZxrlGHZQNavRrncekq+gfqZxPnmbvN6v5Qu/tNalB3JqyXPK15tATFXo9T
	IHtV5Nhkjw+7WncrfcXxlC3ezOD9F1Ml7jky71kwLy9YLJT90yzw1vcsU5FV3U5H
	VVr8A==
X-ME-Sender: <xms:bd-aauNvc5t1O9JKgJVqYz5GikyPXClz7WmUlFGQ3k3vaJeOS2j7Yw>
    <xme:bd-aaucx0qh_UvRUBLrTsqyvAq1YSY3dDIdNMl-7dXhrm_O9ZvDA8dEPmGisYx320
    QetRdd8eYfDkK8qaBaI_hjgWEI8Wk4_YJJaX_2Gz5k2cvjipXeW80G4>
X-ME-Received: <xmr:bd-aai6i7i-lVuzHB-onSVQNiopwR-KN477rHncJXSSzi8kLpFowwXT2ZjM>
X-ME-Proxy-Cause: dmFkZTFdOocfRN4jOpcQf0AqfSai/YCGo+xlO94MLvzn7lqitof50EENUNEgJzLPt2H+RQ
    DWgrwJL5dg2BaLkWQfjz0w8mX09EzID7A24sM1R0CcrzJ0aCsxP+pgO1accdG5RnvXKoNP
    Qi2+ranCgsFBQlrx3RUM64Xgm9l9zr2TPWbzFNtan3mUwkVlJ/gBEGXolzLuuMZ3CJ6e8L
    gmzum6oDDF3av5ecJE/wINba64+XlYa/U9oL8c0Dkr16eu3wp8w8wOsHTRTsCgO4oV0meO
    0fb7rtZliPO8XPlA3k/rGcTv+01JWMnSe6fG3OACTE4UctUjoP9cM2YnBbUckeF0hhckbq
    Cvz8P0mWGH45WdOwqnu+TKhOr5lwKVKaMaZXfHg9pm/WzuEvez6nqQcMig9ee23pQT31jw
    lmXwJAIgzz8MoxjOko5trLcvXSnI2oKuuqaTJA8txpBkIwZoisx0vYswzoGI0pqomz0FKS
    m5gEJgYwGJd/KDyqT/mCOiTQE3HyM+MgLriFa3c35xwK3aPx3PR6PBmlY2DR++iRoh09E7
    L7tCNNLglqlPCbc406tgC8hCPZQSP/xqDAWKT1xiyKaedO/SI/dc56VVJrkiarMU3nCC+e
    oKsesJWIY0XwAoZMINTbJm7TYwNxM4dPRS0e1rXNI2QuCQn0BPdZKdwmuPVQ
X-ME-Proxy: <xmx:bd-aamIUeEGsQzgA2-z9EhSMHy2aGQIENfYmmjnjA0nrr8-Hu-XMHQ>
    <xmx:bd-aam5V8SUSwA6b4-tsNH80o0Fg20eQwQCg1nwaxkP8eRtZ6CLMvw>
    <xmx:bd-aalZTiWrF4_NUa_UQjFZmtpeHrJ_FxZpYGET5Y_nKUc1K-rmfGw>
    <xmx:bd-aatxWuobouDCAnUsROQHad4hn_mjHCN6LA2kYKdKqthn6nSUyVg>
    <xmx:bd-aam08GwXkH1YRtJ04mazxx9DOwTETJgeQY9sXZQtcCdoXjh5Zd3FJ>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 4 Sep 2026 11:10:37 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH 04/12] mm/collapse: add collapse.h for the collapse interface
Date: Fri,  4 Sep 2026 16:10:18 +0100
Message-ID: <ec5230f43af7153e18aed02c6ee38f010106d8e8.1788533997.git.kas@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1788533997.git.kas@kernel.org>
References: <cover.1788533997.git.kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 46k999mwj7zo8haj8oaqudbztdx9ooq1
X-Rspamd-Queue-Id: 652F040006
X-Rspamd-Server: rspam06
X-HE-Tag: 1788534638-589098
X-HE-Meta: U2FsdGVkX198y0ECNS2K/fgFKdYzJ0NSAcZZ2CAJc0dGI+v7iLfl9d4dtRtPXPzLN6rwVLvEgbSYdNiqhDnSX5kYd4Pxb9Zdsu4PFHkPzmKXYqp5BpqAvwHJ4tBFJdm2hJTXojesZvQmN6gJSR91QDzc8rRC47v8chBntrGSgoYZqjSK0ZGiU9K7YE8XFNJg2lyXHGKAXwsZEtM+H6fPNnqbio4B4pGTV7sHDx+AFeMi2fOV6wp9wXUJ5hecGvvLR5UYoGZmJb3hcuUXJVeVlrKffzcm1gm8+pNOpHMZnylBXBti0CnjOTuImJ+z0bldoqJ1aHib93S08F7CiNNdeCJgHN/wpEhwMu+LOCYgAusm4gaetzIHtEAbZkM3zbZrFpn/0C6w/C/iCJfPNmzyHJ5OCp7Qh7zZtkEGNIKvzpIc7z7zDP02RC+khoNtnjPj0/stwmXffn5kftk3WAgOSPsjJwbO6OSB7xHVfo/fqQPMzAuBzRbZUJHqXOI83k2/EPGedAiIAoa2qyQs5pg7v6ro0Cyiju5hzuBxCKP3spfC0IlwOOQq+y1j5VWIAmcBiJtR39pZ4WTYXJ5BJkeyJX2OKi1uOMKG/Zguen6L479VyeXY2jKO00vHFnMFO0njuOBTHc2RUPbDRSnEaPcGKtpIIJt4C3tYUFie4Rv5TwC19EUt0gXIbBmEjOI1/XYnjjWxmvYH1qBTeYMrip8dVdVVMi6x5USj1/bH+ik82tiHgtGiiYv62I5+AEJ0jyjiw9r54Wud6M36woRzokDL7SCA5/JxuPixlxtHCTZmnxvCjXMngtSnmJBSDEws2Mks/KBNaZ4lqSg+XR1bQXAqXqSkkQE9gqSPF8ahPT730dxqBYSieTuGk/WD4fLaxktybZX8y6t+GXYNiXTuYB2nLTTZNt+vuvU2zbt+T8FCifeFeq8SiT0PJ3Dcu41Hkq9r5abdb80a2m9iq+5TYUg
 cvF1nx4y
 ayLjFvSFcAqxkY5nqDoiCNr+YgVAyr9nAJ5h5P0PkgabHs0VPfuJGcg1WGqypp6RtNXvKw/ApQXmsEpqIIn+x8500OXlbdoJMYFwUkQmgVYzbVOZOdqeP/T3uRh2Mz88eD44IAOPDvdDbPbaUwyg7LWuYvLhkUxGM5RjTCe2zG4lFurqvutKacXwPRHt2A6j8uxDxfZv6GxMn3Kh8bQ1lNUtdKyFF2zQDs2Sh0iV/sx1OHFj6rZPeLPZMuXWhJOYeAOzuXMxRjfGPIMHMGEbIZCZzJwuV2gzVit4b2+TIGnqYpyAhce2IUGOTIqr6A6iF4SaLgtgb+h7bNSNbNa9NGHxwwruXBhf0ateQyrEFiddRroI8uL/5ZpD5999Nxmw7y4qc
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

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 MAINTAINERS     |  1 +
 mm/collapse.h   | 67 +++++++++++++++++++++++++++++++++++++++++
 mm/khugepaged.c | 79 ++++++++-----------------------------------------
 3 files changed, 81 insertions(+), 66 deletions(-)
 create mode 100644 mm/collapse.h

diff --git a/MAINTAINERS b/MAINTAINERS
index a9245d827ddb..4d1ff4c76496 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17433,6 +17433,7 @@ F:	Documentation/admin-guide/mm/transhuge.rst
 F:	include/linux/huge_mm.h
 F:	include/linux/khugepaged.h
 F:	include/trace/events/huge_memory.h
+F:	mm/collapse.h
 F:	mm/huge_memory.c
 F:	mm/khugepaged.c
 F:	mm/mm_slot.h
diff --git a/mm/collapse.h b/mm/collapse.h
new file mode 100644
index 000000000000..1c40229b9554
--- /dev/null
+++ b/mm/collapse.h
@@ -0,0 +1,67 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __MM_COLLAPSE_H
+#define __MM_COLLAPSE_H
+
+#include <linux/mm.h>
+#include <linux/nodemask.h>
+#include <linux/pgtable.h>
+#include <linux/types.h>
+
+/* The most the max_ptes_* tunables accept */
+#define COLLAPSE_MAX_PTES_LIMIT		(HPAGE_PMD_NR - 1)
+
+/* The smallest order a collapse will build */
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
index 6a437d6fe016..972843c45250 100644
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


