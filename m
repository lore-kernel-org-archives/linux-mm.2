Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4A93C5B572
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 22:46:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 461196B036B; Sun, 16 Aug 2026 18:46:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 411E76B036D; Sun, 16 Aug 2026 18:46:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 300C06B036E; Sun, 16 Aug 2026 18:46:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D24786B036B
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 18:46:26 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 421E71605D8
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:46:26 +0000 (UTC)
X-FDA: 85108617972.05.36BEFD4
Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	by imf08.hostedemail.com (Postfix) with ESMTP id 49751160002
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:46:24 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="N VMztfI";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=QbF1DrsC;
	spf=pass (imf08.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786920384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dznHIYuQ1ajyQBks66dmRoan+CjULGV0RuvhMnG/G2s=;
	b=4YaYAqu/xEXVqF6SvxzhC6NRBmZG3zQ6uSvT2B64MgdpHaWqu+vK13U9sDVe4Hok1Y4Cb/
	NqEmGP25WsAA6xZnaioAWqz2H7FWl2b9YJxge3yk1kINaKYmNkdcmVHXtk6GLgyus3aaWF
	7McKcXewNUwqcw22+3dvjweRhtc1QBA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="N VMztfI";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=QbF1DrsC;
	spf=pass (imf08.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786920384;
	b=T0MI7dQUft9Zr2kJJLpADj7bk560waCmbWlYB3gR/szhshysaNyroyi3eCKaDsakd51ZOs
	0htcV9rT2J1N+LVZS41LwTFLM7MVbdRHzfKwreZKbYr4EVwmqj8L6AtsM31gqrnXy9ThM6
	VGgBAJaP/DY7tiy36GP9owBzkC1sHlU=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.phl.internal (Postfix) with ESMTP id CBDA2EC0235;
	Sun, 16 Aug 2026 18:46:23 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Sun, 16 Aug 2026 18:46:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786920383; x=
	1787006783; bh=dznHIYuQ1ajyQBks66dmRoan+CjULGV0RuvhMnG/G2s=; b=N
	VMztfIJHgpufE0l08lyVHehrOv6tgNPkbVqrKdNJiWgC1/DN6tCXD+b3K652oQv3
	rUPk1XJdMIWbUlYOHW5t3EAUnp+FeqGPPbqacTy2Kf/iBI1IDjSFUWmtQjSxlBRg
	XeSvsuaPmFGDv6SvP+KBjfBj/089rqB0rSOMpkgmF2LeiyJLK9va1ALJgv36XkoB
	6gaP44OjEOnRPDfKuJUCNIuEwaMcKddLWPdcCrEka7gyg2krDJ1dpp5iEX4k4xJk
	A86uTeE21xObCvG/GHEST4rn+47mfQh0/pT1992r4vmNVe322qu0loavXD9nr01E
	0IVHOl+5M8ILE3psRI79w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786920383; x=1787006783; bh=d
	znHIYuQ1ajyQBks66dmRoan+CjULGV0RuvhMnG/G2s=; b=QbF1DrsCUsaenM/zP
	75ODtb3Wg9zYCtU/3GE/5VL/FqEdTYOoS1GCyO/KrhfRDNMNxdsk79MgNRV61Apt
	sxtmsLkpNSzfLgQFyFFh3d0ssLsB3DmdnbiM5hhuDUYTw9lIaA9hYU8JfNVrIMwX
	G1TUUtCxbkzhATrGpfpoGHET+8UXNUROHIahAwkqdidRDV1g/Hd4QqfMGx9zFdGk
	hWJVF6IgwHjXYwE0ctmGl6nwi36qNtDdFmaupGgyaH8O/ZISHzBARJ+3H/1NDQ7s
	y7pJ6GgWxpg5vqicq0TUe+9I9UY+6MsGmNUZJ9DtJNA3tITwSwZFEuJYxW1yn/AN
	go3kg==
X-ME-Sender: <xms:vz2CauXMdcMOpYdI1eFtQR9tpeC5QPzYUNmwK-VDyOdaSrQIWdVIog>
    <xme:vz2Cav4wzVIllEec5aCrtYyHbPb8m4caqBYI-RJ9JTpCj4YPVMsKYzkKWmk8hZsb9
    wzL1RlBa9jjkpdTt-loBQ-V0Y_h0zyD2-fP4-xc_clyg6rssjRsXLOY>
X-ME-Received: <xmr:vz2CaucHWGZzD70Fnw6WQTSGP1sTA4AyvwX2lPi11LNoZt2LZIJ3YsWS4tU>
X-ME-Proxy-Cause: dmFkZTGQiHMMNOd1xnoN6lXQSIrGAe7MwYo75Qud3VSOh3aIjL1T4IX+wE1i/v23Y8aWnG
    m9SHT5inuXsr6fNeLF7q+XcMZ+pkZJxjpb2XQQyKrFdYKaLz7QDFEiegvQaT+Y5rGxRgjF
    euipinLXiFMtCpFgMqQP9Dwn4SHq3YG285QsMU4KB7YfRQHYWKIG6dJTmdP/7bPKv1qUNe
    3LkhBXaaROXWrLGafj+UVrogU8Abxo2OvgWTBKIlLl3SY5Eb27sggkfdoaZJgpjY1+W5mK
    IYgTH3bmg7umgeRjJmx+WAhyhWPmGn2xLzWKHa3nzXVCTdFk2+6Uh9D41+s+1+4ThvFtow
    zRcsF02Rw/s88ciL+Ju4C2PxiXq8tPwu+8Qdo1MrZebmhpblmIj686SZmknQU+yMUOhU1l
    t9NuITAmqXyZDmpmrtLZj+XoUkG3+0KvG83OUa5Yww/LEDfhZtqn4v9WO3J2AGIB6HEnq5
    VYcp0R+H7kX0WKHf7r87JCH51mvuDSLM8YQEEUE/nxj37Y+vVO2vT3W+DqI+jkRevSJNLo
    DDJIZE4VkgrwzHArnxvHkDSm0mvPCgPYD9SDMYzOR5q3nvaLKSZ/Y1Du6Rf+jn2NkIiJRJ
    lTQ05f2gfc02JHZZ5xdgaNmnLcXtlUmISaBbPVItb11H6yaSx6wrc2XCMBUw
X-ME-Proxy: <xmx:vz2Cah7KFSN0UUCuyqZdvSFAW2Qbs3HljwxAjrEcy59qjJdx8hzIGw>
    <xmx:vz2Cau1D59rrX5ByN_6RJLSUEiYNQJUWzPk_Rw9-JUbF8tbGm-tV1w>
    <xmx:vz2CakD4-y-DNDoMbtQWfsZgjGPGMm_-KUJCBBK0TeyMPVu52RVjmQ>
    <xmx:vz2CavGHGoevX0OaFKsu8vHX9WoZayBiAM8DmOsmhI4k1Al8DgSjRw>
    <xmx:vz2Cahr3Qp6THjSNZRMo_0DEzp5n0AQEHbKZfsK6AiTfcTDZDg58aCoD>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 16 Aug 2026 18:46:23 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	nico.pache@linux.dev
Cc: baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	hughd@google.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	mhocko@suse.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	surenb@google.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	ziy@nvidia.com,
	usama.anjum@arm.com,
	agordeev@linux.ibm.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kas@kernel.org,
	jannh@google.com,
	willy@infradead.org,
	pfalcato@suse.de,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	linux-trace-kernel@vger.kernel.org,
	bpf@vger.kernel.org
Subject: [RFC PATCH 03/57] mm/collapse: add collapse.h for the shared collapse state
Date: Sun, 16 Aug 2026 23:45:15 +0100
Message-ID: <20260816224609.308019-4-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260816224609.308019-1-kirill@shutemov.name>
References: <20260816224609.308019-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 49751160002
X-Stat-Signature: hxfogwwbbzn67343mdtp9pp7b78rjgm6
X-Rspam-User: 
X-HE-Tag: 1786920384-672281
X-HE-Meta: U2FsdGVkX18oCkhTdtTwi+zCy2jdrJb/IAFcu9PQ/9fjBtx0JTSuFJpeZya/jxrvZjy/oO1U5X5BkQF/dZkCn0PSnT/9euY4BD2FdVKTyYP/2pa2etzs/J5yQkEOI8YiQuDx0uXaqf++TEN7BmQ1IxvSZ24jqYleDpVVoucIEI7y+eHIcIO5c3qrbfumeU9ruOjO5SqEt/HhiLUuUrPyTzL0cSrFhBOWyBguNZEQgSQjpBwvxHjJyr/YGWwC08RwgEtPKzBFQe1Blcxb5QpGIUxO0YKD2hCK9SiHq1ujaxPzUMmNZDguBB0+zBh6Xjm3UiAwDg1SzIlpXELgrbyjggOZHYam82wHfzcXNubQJhMb2EDXB7JaNyuNhvW76suxp4yzEM1l+w8KxM/7ZwpZb9met9PMu8RupjpMzLGmIHicVnOC4hhYhzMPGtYJWo8CUv9KQ//h8XnDRu3XOvO6C+P+KNr0apmVDmn2ExgPsdOh/HYHICnjFUABchmgvf2E/j78xUKifBKNVPxLW/eVuKGSGq/E3iU+ll+RmiVo6jcu9ohA/DBbAROJSJp2dJoqdZydrjArwuAKrFqc/M2Nzrbqen/SZNUta2fcIiLIY/gsjfofrXE/0N1a58ZhAh72JmAQl09/3rJMrUB5p08riXYmApSacFtKAWfk9L9bRIUCouHkR+cz+yL2VJpAF5HO78Y8qe9hrkKe6qbBEjkaomgl0J3PCTlfhPuo23i+LyVyZuqFj8d4aWVwm5cchpXIZs9JxYQBs8ZhvypKf8uJiRJ84vrOU51jFcwggPOt7fAL+nO5UXRAhZCayuyO8Xcgabuda9l+vtKnORvzlFOOFBNNR7Hr+BJBBu3VUw4x5yFfyc1K8Nd08dTrEoCp+fkis1RZk8+wM9iFIoE0D6JICOH0e5Ew36fGHTS1smhB8TDhk+6a57pNHHCU3lKUfkL0Nks98KcddXgDL71ANCf
 SyCs/iDf
 z/QJdYWVSlpOnOHoDXj18tAZCL31y4nYvBfYGT+Tev+oW0hKFnaomc8KOecjDMyzCPoc1KL01+VrV/W1JMv9YKJ7I+YPRetMWtud9ZIMamNXoeISmvzASS34nNxKMPlzVFvl3jGsdeNcnGIi33zqtEpr43KP6HNDxNY1dL7UMTLPXdQ/Hdlm2pMaoWLNgqy+xmJQZYoFO/XFlLvkKFe5z+glBeVPH3O+UiqvJa4sgeHw7hUuSEqQuthr5HmYNiNmqQBV1DZdFmXHe7OilGRC0kj0ZY44MAuOMXc7lXIc6QOaFLvG4PcrtlFrdlGpMrsB7rfljbeQ0HOJJRiJGrDPMXPTeerCeJQ20YsCM4pnANFLFcRtW1B6k8hWylNFb409JhvP9/Dq0frqHX8J40YT0BusE9Ymj4BhBIUL79vh+LqlZBHJFfCQPGg4eoo6lKgLj0cBrYodCSQl6zzmDCJeD3rhty9NdsJiDdg047PFM/V4LveU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

Preparation for building the new collapse engine in its own file.  The
engine and khugepaged.c need to agree on what a collapse result is and
what state a scan carries.

Move enum scan_result and struct collapse_control into a new
mm/collapse.h.

No functional change intended.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/collapse.h   | 60 +++++++++++++++++++++++++++++++++++++++++++++++++
 mm/khugepaged.c | 52 +-----------------------------------------
 2 files changed, 61 insertions(+), 51 deletions(-)
 create mode 100644 mm/collapse.h

diff --git a/mm/collapse.h b/mm/collapse.h
new file mode 100644
index 000000000000..26dbac7beddd
--- /dev/null
+++ b/mm/collapse.h
@@ -0,0 +1,60 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __MM_COLLAPSE_H
+#define __MM_COLLAPSE_H
+
+#include <linux/nodemask.h>
+#include <linux/pgtable.h>
+#include <linux/types.h>
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
+	/* Each bit represents a single occupied (!none/zero) page. */
+	DECLARE_BITMAP(mthp_present_ptes, MAX_PTRS_PER_PTE);
+};
+
+#endif	/* __MM_COLLAPSE_H */
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 5f7126cf42f5..804b1d35f52a 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -26,45 +26,11 @@
 #include <linux/cleanup.h>
 
 #include <asm/tlb.h>
+#include "collapse.h"
 #include "internal.h"
 #include "page_alloc.h"
 #include "mm_slot.h"
 
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
-
 #define CREATE_TRACE_POINTS
 #include <trace/events/huge_memory.h>
 
@@ -103,22 +69,6 @@ static struct kmem_cache *mm_slot_cache __ro_after_init;
 
 #define KHUGEPAGED_MIN_MTHP_ORDER	2
 
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
-	/* Each bit represents a single occupied (!none/zero) page. */
-	DECLARE_BITMAP(mthp_present_ptes, MAX_PTRS_PER_PTE);
-};
-
 /**
  * struct khugepaged_scan - cursor for scanning
  * @mm_head: the head of the mm list to scan
-- 
2.54.0


