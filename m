Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC5EBC5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 11:37:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E69B96B00A6; Fri,  7 Aug 2026 07:37:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1CF56B00A7; Fri,  7 Aug 2026 07:37:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE50A6B00A9; Fri,  7 Aug 2026 07:37:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9DA4F6B00A6
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 07:37:29 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 306B1A1CC5
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 11:37:29 +0000 (UTC)
X-FDA: 85074273018.17.5370C60
Received: from fhigh-b6-smtp.messagingengine.com (fhigh-b6-smtp.messagingengine.com [202.12.124.157])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3599B4000C
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 11:37:27 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="t y6vA8V";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="PWvzBg0/";
	spf=pass (imf12.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.157 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786102647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m+sHgjFARkaaiaNC+/FgRc830KGjOObydI5mFYZxies=;
	b=atylOwjolWdWgqx+Pum+eP+5mWEV3tW8E5GRBxQW9go5VRRaPFbLe8glciaoSTwmtzW2Hy
	bsxNX1KTfKFIhPIMcTys5Q0SYMlq2K/GELPzGpvHaySzsIjOR3FaX1mmMvC/E1FyokFnxT
	WriqKcUzrENHup1SsNJhJ40Mj2pwIiw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="t y6vA8V";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="PWvzBg0/";
	spf=pass (imf12.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.157 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786102647;
	b=yedDpcExXVfXTG4c+mwRV86fwPDVAvJY0UgGk4vN9P3fHK0XIMJBkrIDq67bwYUyBtOud0
	RJ3vFYZir43tsVJNhdAy/h5WzmQ9eNqPhi/FHr4wkgAHejHNgHWVj0dQ6T/n/+xLElaP4U
	40XSkbUZ14CqE9VMGmJ9BbVrzXClZU4=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 0FE8D7A012C;
	Fri,  7 Aug 2026 07:37:26 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Fri, 07 Aug 2026 07:37:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786102645; x=
	1786189045; bh=m+sHgjFARkaaiaNC+/FgRc830KGjOObydI5mFYZxies=; b=t
	y6vA8VDFS6QOc+eJrPUhfldWsDpJS91fBHotWJ4l1dak0o3maLzLBsqcbMhMu58r
	0IeiARbhw83pD1iJw6iDTZK730MJj42SrMt0oHz4DCEUC5M3HEqWzpPItVeG5Pzv
	QfrKfvFc9axSq93ng3r0Pc1n7W0zDYYhsrTHBnI8rkP8pvJkg1SU3tavoyM6pj92
	pH1rpC7F/wEGJqO399rC1oTC/FOLfgkoj8VeYtGJEaxpyRB9Hwhu7CM/ajII9Xuq
	v6ai/cWZu0Bywd7Ktrj8k1MB9TQNLT+w0QVYeVbxIh6HSgTw4bgt/knx6JLGkSsQ
	AboyVDBmQMhB4Sj8ig+Og==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786102645; x=1786189045; bh=m
	+sHgjFARkaaiaNC+/FgRc830KGjOObydI5mFYZxies=; b=PWvzBg0/gbOkxq++W
	3/5sglMVO5ntG6+poVmC1nFckOxxb0DLezopKvB45upcu3ayex4LtxdAFLJ5x2Ka
	Qhc+KNDlXYt2iN4eVXj/mMpOcjKmaghrT/jOnS16Uanhdz9/ssSQ6cBsqPhiG2PJ
	le8MA3u43qknNkNfa6rbGFRsfdxHZOJMB5xik7jmyc+wFBzQS5sWDcu+21mW8w79
	OvL6hhK0fhfWhvdUUWut4WkTkOLDbTWxW/8Hr6boE1kRj88BtApWeZLx/zBs3SIv
	IgODALOISyFV1/ygxEdOW06z4h8yKJSqzR9iPbx60lwK6vE4vKw+NFTsRP20n0t1
	6H/dw==
X-ME-Sender: <xms:dcN1arNvh71wTxr0oTX5wODHSZ5FZrMQxwMp8RsT_YFoj7YCWN7whQ>
    <xme:dcN1ap6oM2J5APcfF-ml7Za1yjYILQ2kNvCwWUSXy_jrTFZUDTtFiUkUIq8bQ5vKw
    LotdAMVvPPR1hNBn0vdmTm4Griho2fCtSUPA7qJVyhza-av9yPOgdyM>
X-ME-Received: <xmr:dcN1aiz_4fcSidVsFG2JtDx6UAGdWmYAXeIauvuYDscqFwlxkeAsg0lTVJY>
X-ME-Proxy-Cause: dmFkZTGUERIwmKnJzNqrmH6VlEmVcWeiClBef7dL76l3JFxgCJIE1wbu/wgjcLR687OyMh
    BQrMCOBv45wH7h3ooBeneK7mWIj7iIytnpxBlgzGmz5SHufCsdgROAqJKtMeokx5eB2AAp
    cXT5mMO8imvID7jHzWhqIClk07P/42mlBI32M882inm3UlyT/GsY3qxbman5/VlsuJS9+T
    F+1+aXRxbMzBOR7RkHQ9dyf5K4OhFzw16ipJCuGwyYR0rlnsi17XpZoH3bdrAT++N0O7xU
    IF8fSnfJTEWFFODGe4CSmBZThmf/6wAYTC6d1nWOkM6O/FhjItWthf5fql0LkcaRcJIWN0
    zXgxNDWNr+qBBvcNySFIYAtkqpKlAEpsXaVD9K+94Q4eM/H+ZpGLcPJrSNFXt8s98plKxS
    6cAxMWEBa0XIWFm1JjsR9Xck7JxcC+fibTtFAhQ2hETnLwDkHSrpTzhvS6jImINCaqeHlt
    B9e14FmI4jURMwOo0jXXbxpVinMn1sI1jxA9LeeVZU1d/tTACZPjVlmlxit2LU/qKHtSZD
    Eb9ED/Lkc3oIlLwAWjEu/WE09T06zxKzNEHiu6aZdl/CsMIUXsZHFbvxgLsnRUCsGml7e1
    /WeS/n8UR8xs9oYcqZKwP8DGANPbM5NYe4yc11DR6kkzVg8ZPTiq+BNAAFbw
X-ME-Proxy: <xmx:dcN1apQ-52w7sOUqwNMY51YKHFyrDLENMsIqEuCSZAoUyNyBZGwJ5g>
    <xmx:dcN1aq_v5vdfDB5K2woYhlgfa3tu9Fh_muxwn9DoyETM6KI0mMNyaA>
    <xmx:dcN1amJZSL-tBfFp21c237_qJCR8GeCS788oyhTT3KKNZek7seK5sA>
    <xmx:dcN1autAZSShy1SvC-wkT9Zm9o5rDg_hF0bglkq9xS7dh6V_pafLsw>
    <xmx:dcN1ajvh6LROaaFMalAizRqnuBq1taKlThj2SV2gzOfmuYedpZ6QBcM5>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 7 Aug 2026 07:37:25 -0400 (EDT)
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
	kas@kernel.org
Subject: [PATCH v2 14/17] selftests/mm: add khugepaged race harness
Date: Fri,  7 Aug 2026 12:36:44 +0100
Message-ID: <20260807113647.3744609-15-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807113647.3744609-1-kirill@shutemov.name>
References: <20260807113647.3744609-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3599B4000C
X-Stat-Signature: urp8dh7esmua91ynres4jna1tuab9tef
X-HE-Tag: 1786102647-50133
X-HE-Meta: U2FsdGVkX1+jybXr9Ig1VcUqXzSNlrUOsGObs+zs2mxl4jXBG0wdNma/LSOuPbnTmAjAS2hzp28dsW78Bto6sHlSAc4UlwMr13XHD1B/c9Afrwk+i+NU7n8czKZeROccZwakwOw1uTCC51aQIp6u+jvcbQ7QOxyv47h1msYNXTAOkX/lEl4FHjKFLeG0C58yYL5heb3SQWbXpjK1pCvxwJ51LfumlPQ2cSXxXXUUyRiJenVQvDW2I3YFBOg1L2gINzBRLYrayB6lt1KDqwL4cCJ72G7aB9WZU2R45D3WXwZJ+E/iseVcbrQHiCCamH7rWXI0CgqYMOHmsEuNRli+61+pTWoBg+VL45VphdwF66jcpGBBEvpZasoTOKvgUbCFu5+hF1H9HImfhoTdwpAkNCaPGdCHD2VZxEIu8tJUQtzUo5X7uIYM2UtNajmJtpVCKVOQZXkyodJJUDVsHWaQCIa3a/kAbhNSIk2gUhIs3IbrNIzeLLZcKLwkB5B6d4twLGyszZYOh9kLw9iMV1Vl+oKp8z1zslryPFJGyaI1PZaIC7nwRL53Q1KEkSJuH4lHOd+NY/BeDNRxw9+h6EQRsXqwqF9SKENiE41IhZFbO71pS9jMcj31W0GEkTpOCjqSB8jesArEVLC+hHwzld2x8fbwAiLoAi/Y4ucucd6NKZYQHm/tKrBfu9iwiHF5tEVmGHIxVHl2sew08sqI2AHh6bKW2KV6W5IoXQJHIkQbIssFBdKFtB2iFtw0Z/3gHYxK59nCcH04+YGPnlq8k/iiO2ksQyE7y8siur9Cq05BzAYd36OldO9sMbAFxW1o5a6zMefz6Q/JsD90exazkiLDhF+wFscMS8Dc8Rm1InSCfKoMHRopwmzSrd9tcpSOi65GhrS2adXixeTga7iFBzBaSXzAjy5cFl33UR7kg5wfP8s39Tikm6yle7Bv1jM8pGKjGfZAXHGXkLTVt+X5I/Z
 tSndEcwC
 sHjE+3Zv297WloVS1UbMAd1+NqZF1NVxn12USrchijpC/f/pmLzWVlOSsO93t21GeRUL+aAYdvonJ0xsoFJBV72qYS+BkK9Y2V15ztaI2osZJzhZtppl01EjTJQfbwXHrzcb0yWAfjWK9Ts0PsCLUcOHjed4z7OVX2wAZNjlt7Y/wtnVpPJw2JD5yCckr4S1MG+/SpU6IoUxpSR3o8iwFu1S2eQMmVqwrGjRxImk1itOJEjV/LFdgRtZQfy3BWU4jQYxSA+T5TiVXXR2bVhsN2ZDQ+W3++bdC85uXL4WpHfQyWjGe2vQlvN48/cV3Dxf/STcW/mbk5a3eH4toLxlbwvw0chQVgx1p3eAs8Gq4ZEmedd0OslayWNrjdg/cn9l6UM2EPMZStQJo++G17kzLVo9TbGSYJcOb/EKNfw8lOWMhZRf/ScMQVxsqxyqeEAM+39c9wxMa4XZEkzQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

Collapse serialises against faults, GUP, fork, mremap and zapping through
a protocol of locks, TLB flushes and refcount checks.  No khugepaged
selftest exercises any of it under contention.

Add khugepaged_race.  Two faulters, an MADV_DONTNEED thread, a transient
FOLL_PIN thread (gup_test), a forker and an mremap thread work the same
ranges while one of three drivers collapses:

  stepped   khugepaged, one full pass at a time via
            khugepaged_full_pass(), so each step covers a known extent;
  free      khugepaged left to run (scan_sleep_millisecs=0), for soak;
  madvise   an MADV_COLLAPSE and MADV_DONTNEED loop.

Every mode runs in turn unless -m names one, five seconds each.  All anon
THP orders are enabled as inherit and max_ptes_none is 0, so a window
collapses only once fully populated and the racing MADV_DONTNEED steers
selection across orders.

The rule is that a racing page reads as its pattern or as zero, never
anything else.  The faulters and fork children check it throughout, and a
final sweep checks it again.  The kernel's own assertions -- DEBUG_VM,
page_table_check, KASAN, lockdep -- are the other half of the oracle, so
read dmesg too.

The threads share three PMD-sized areas plus one for the mremap thread;
-a sets the count, since at a 512M PMD the default is several gigabytes.
-d sets the soak length.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/Makefile          |   1 +
 tools/testing/selftests/mm/khugepaged_race.c | 410 +++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh    |   2 +
 3 files changed, 413 insertions(+)
 create mode 100644 tools/testing/selftests/mm/khugepaged_race.c

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index b2d6e5c12934..308bbad73c11 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -106,6 +106,7 @@ TEST_GEN_FILES += rmap
 TEST_GEN_FILES += folio_split_race_test
 TEST_GEN_FILES += folio_order_check
 TEST_GEN_FILES += khugepaged_sync_check
+TEST_GEN_FILES += khugepaged_race
 
 ifneq ($(ARCH),arm64)
 TEST_GEN_FILES += soft-dirty
diff --git a/tools/testing/selftests/mm/khugepaged_race.c b/tools/testing/selftests/mm/khugepaged_race.c
new file mode 100644
index 000000000000..3dc651dc56b3
--- /dev/null
+++ b/tools/testing/selftests/mm/khugepaged_race.c
@@ -0,0 +1,410 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * khugepaged race harness.
+ *
+ * Runs collapse against concurrent faults, transient GUP pins
+ * (gup_test), fork, mremap and MADV_DONTNEED over the same ranges, in
+ * one of three driver modes:
+ *
+ *   stepped	khugepaged, one full pass at a time through
+ *		khugepaged_full_pass(), so a step covers a known extent;
+ *   free	khugepaged left to run (scan_sleep_millisecs=0), for soak;
+ *   madvise	MADV_COLLAPSE in a loop.
+ *
+ * All anon THP orders are enabled (inherit) and max_ptes_none is 0, so a
+ * window has to be fully populated before khugepaged will collapse it, and
+ * the racing MADV_DONTNEED decides which orders it can still use.
+ *
+ * Correctness signals: every racing page must read as its pattern or
+ * zero (MADV_DONTNEED), never anything else.  The faulters and the fork
+ * children check that continuously, a final sweep checks it once more, plus
+ * whatever DEBUG_VM / page_table_check / KASAN / lockdep report in
+ * dmesg, which the caller is expected to inspect.
+ */
+#define _GNU_SOURCE
+#include <errno.h>
+#include <fcntl.h>
+#include <pthread.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+#include <sys/mman.h>
+#include <sys/time.h>
+#include <sys/wait.h>
+#include <unistd.h>
+
+#include "kselftest.h"
+#include "vm_util.h"
+#include "hugepage_settings.h"
+#include "../../../../mm/gup_test.h"
+
+#define BASE_ADDR	((void *)(1UL << 30))
+
+/*
+ * Shared playground for faults/pins/fork/dontneed: several PMD-sized
+ * areas the racing threads spread across, plus one area owned by the
+ * mremap thread. More areas means more independent regions collapsing
+ * at once; the default suits a normal machine. On a memory-constrained
+ * host -- or under emulation, where a 512M PMD (arm64/64K) makes the
+ * default playground multi-gigabyte -- pass -a to shrink it.
+ */
+#define DEFAULT_SHARED_AREAS	3
+static int nr_shared_areas;
+static int nr_areas;
+
+static unsigned long hpage_pmd_size;
+static unsigned long page_size;
+static char *region;		/* NR_AREAS * hpage_pmd_size */
+static char *mremap_area;	/* region + NR_SHARED_AREAS areas */
+static char *mremap_scratch;	/* well above the region */
+static int gup_fd = -1;
+static volatile int stop;
+static volatile int corrupted;
+
+static unsigned int pattern(unsigned long page_idx)
+{
+	unsigned int val = (unsigned int)page_idx * 2654435761U;
+
+	return val ? val : 1;	/* never collides with the zero-fill */
+}
+
+static void check_page(unsigned long page_idx)
+{
+	unsigned int val = *(unsigned int *)(region + page_idx * page_size);
+
+	if (val && val != pattern(page_idx)) {
+		corrupted = 1;
+		ksft_print_msg("Corruption at page %lu: %#x != %#x\n",
+			       page_idx, val, pattern(page_idx));
+	}
+}
+
+static unsigned long rand_page(unsigned int *seed)
+{
+	return (unsigned long)rand_r(seed) %
+	       (nr_shared_areas * hpage_pmd_size / page_size);
+}
+
+static void *faulter_fn(void *arg)
+{
+	unsigned int seed = (unsigned long)arg;
+
+	while (!stop) {
+		unsigned long page_idx = rand_page(&seed);
+
+		if (rand_r(&seed) & 1)
+			*(unsigned int *)(region + page_idx * page_size) =
+				pattern(page_idx);
+		else
+			check_page(page_idx);
+	}
+	return NULL;
+}
+
+static void *dontneed_fn(void *arg)
+{
+	unsigned int seed = (unsigned long)arg;
+
+	while (!stop) {
+		unsigned long page_idx = rand_page(&seed);
+		unsigned long nr = 1UL << (rand_r(&seed) % 6);	/* 1..32 pages */
+
+		madvise(region + page_idx * page_size, nr * page_size,
+			MADV_DONTNEED);
+		usleep(rand_r(&seed) % 500);
+	}
+	return NULL;
+}
+
+static void *pinner_fn(void *arg)
+{
+	unsigned int seed = (unsigned long)arg;
+
+	while (!stop) {
+		struct gup_test gup = {};
+		unsigned long page_idx = rand_page(&seed);
+
+		gup.addr = (unsigned long)(region + page_idx * page_size);
+		gup.size = 16 * page_size;
+		gup.nr_pages_per_call = 16;
+		gup.gup_flags = 1;	/* FOLL_WRITE */
+		/* Racing MADV_DONTNEED makes transient failures expected. */
+		ioctl(gup_fd, PIN_FAST_BENCHMARK, &gup);
+		usleep(rand_r(&seed) % 200);
+	}
+	return NULL;
+}
+
+static void *forker_fn(void *arg)
+{
+	unsigned int seed = (unsigned long)arg;
+
+	while (!stop) {
+		pid_t pid = fork();
+
+		if (pid == 0) {
+			for (int i = 0; i < 16; i++)
+				check_page(rand_page(&seed));
+			_exit(corrupted);
+		}
+		if (pid > 0) {
+			int wstatus;
+
+			if (waitpid(pid, &wstatus, 0) < 0)
+				ksft_exit_fail_perror("waitpid()");
+			/* A child killed on the read counts too, not just its exit code. */
+			if (!WIFEXITED(wstatus) || WEXITSTATUS(wstatus))
+				corrupted = 1;
+		}
+		usleep(rand_r(&seed) % 2000);
+	}
+	return NULL;
+}
+
+static void *mremapper_fn(void *arg)
+{
+	unsigned int seed = (unsigned long)arg;
+
+	while (!stop) {
+		void *p;
+
+		p = mremap(mremap_area, hpage_pmd_size, hpage_pmd_size,
+			   MREMAP_MAYMOVE | MREMAP_FIXED, mremap_scratch);
+		if (p == MAP_FAILED)
+			ksft_exit_fail_perror("mremap() away");
+		for (int i = 0; i < 8; i++)
+			mremap_scratch[(rand_r(&seed) %
+				(hpage_pmd_size / page_size)) * page_size] = 1;
+		p = mremap(mremap_scratch, hpage_pmd_size, hpage_pmd_size,
+			   MREMAP_MAYMOVE | MREMAP_FIXED, mremap_area);
+		if (p == MAP_FAILED)
+			ksft_exit_fail_perror("mremap() back");
+		usleep(rand_r(&seed) % 2000);
+	}
+	return NULL;
+}
+
+static unsigned long now_ms(void)
+{
+	struct timeval tv;
+
+	gettimeofday(&tv, NULL);
+	return tv.tv_sec * 1000UL + tv.tv_usec / 1000;
+}
+
+static void usage(void)
+{
+	fprintf(stderr,
+		"Usage: khugepaged_race [-d seconds] [-m stepped|free|madvise] [-a areas]\n"
+		"\tWithout -m, every mode runs in turn.\n"
+		"\t-d: seconds per mode (default 5)\n"
+		"\t-a: number of shared PMD-sized playground areas (default 3)\n");
+	exit(1);
+}
+
+int main(int argc, char **argv)
+{
+	static const char * const thread_names[] = {
+		"faulter", "faulter2", "dontneed", "pinner", "forker",
+		"mremapper",
+	};
+	void *(*const thread_fns[])(void *) = {
+		faulter_fn, faulter_fn, dontneed_fn, pinner_fn, forker_fn,
+		mremapper_fn,
+	};
+	const int nr_threads = ARRAY_SIZE(thread_names);
+	pthread_t threads[ARRAY_SIZE(thread_names)];
+	static const char * const all_modes[] = { "stepped", "free", "madvise" };
+	const char *one_mode[1];
+	const char * const *modes = all_modes;
+	int nr_modes = ARRAY_SIZE(all_modes);
+	const char *mode_arg = NULL;
+	struct thp_settings settings;
+	unsigned long end_ms;
+	int duration_s = 5;
+	unsigned long thread_mask = ~0UL;
+	int nr_areas_arg = 0;
+	unsigned long i;
+	int steps = 0;
+	int opt;
+
+	while ((opt = getopt(argc, argv, "a:d:m:t:h")) != -1) {
+		switch (opt) {
+		case 'a':
+			nr_areas_arg = atoi(optarg);
+			break;
+		case 'd':
+			duration_s = atoi(optarg);
+			break;
+		case 'm':
+			mode_arg = optarg;
+			break;
+		case 't':
+			/* debug: bitmask of racing threads to start */
+			thread_mask = strtoul(optarg, NULL, 0);
+			break;
+		default:
+			usage();
+		}
+	}
+	if (mode_arg) {
+		if (strcmp(mode_arg, "stepped") && strcmp(mode_arg, "free") &&
+		    strcmp(mode_arg, "madvise"))
+			usage();
+		one_mode[0] = mode_arg;
+		modes = one_mode;
+		nr_modes = 1;
+	}
+
+	ksft_print_header();
+	if (!thp_available())
+		ksft_exit_skip("Transparent Hugepages not available\n");
+
+	page_size = getpagesize();
+	hpage_pmd_size = read_pmd_pagesize();
+	if (!hpage_pmd_size)
+		ksft_exit_fail_msg("Reading PMD pagesize failed\n");
+
+	gup_fd = open("/sys/kernel/debug/gup_test", O_RDWR);
+	if (gup_fd < 0)
+		ksft_exit_skip("/sys/kernel/debug/gup_test requires CONFIG_GUP_TEST and root\n");
+
+	nr_shared_areas = nr_areas_arg > 0 ? nr_areas_arg : DEFAULT_SHARED_AREAS;
+	nr_areas = nr_shared_areas + 1;
+
+	/*
+	 * The mremap thread moves its area to this address and back, and
+	 * MREMAP_FIXED unmaps whatever is in the way without saying so.  Claim
+	 * the address here, so a layout that does not match this assumption
+	 * fails now instead of losing a mapping later.  Nothing else in the
+	 * process maps this low: thread stacks and malloc arenas come from the
+	 * top-down mmap area, well above.
+	 */
+	mremap_scratch = (char *)BASE_ADDR + 2 * nr_areas * hpage_pmd_size;
+	if (mmap(mremap_scratch, hpage_pmd_size, PROT_NONE,
+		 MAP_ANONYMOUS | MAP_PRIVATE | MAP_FIXED_NOREPLACE,
+		 -1, 0) != (void *)mremap_scratch)
+		ksft_exit_fail_perror("mmap() mremap scratch");
+
+	ksft_set_plan(nr_modes);
+
+	thp_save_settings();
+	thp_read_settings(&settings);
+
+	/*
+	 * A base entry for the stack, so that the pop at the end of a mode
+	 * always has something to write back: thp_pop_settings() on an empty
+	 * stack has no settings to apply and gives up.
+	 */
+	thp_push_settings(&settings);
+
+	for (int m = 0; m < nr_modes; m++) {
+		const char *mode = modes[m];
+
+		thp_read_settings(&settings);
+		settings.thp_enabled = THP_MADVISE;
+		settings.thp_defrag = THP_DEFRAG_ALWAYS;
+		settings.shmem_enabled = SHMEM_NEVER;
+		settings.khugepaged.defrag = 1;
+		settings.khugepaged.scan_sleep_millisecs =
+			strcmp(mode, "free") ? 1000 : 0;
+		settings.khugepaged.alloc_sleep_millisecs = 10;
+		/*
+		 * Strict occupancy: mTHP collapse only supports 0 or
+		 * HPAGE_PMD_NR - 1 and coerces anything else to 0 anyway, and 0
+		 * also keeps khugepaged from burning the whole step in doomed
+		 * PMD-sized allocations on 512M-PMD configs: under racing
+		 * MADV_DONTNEED a fully populated PMD area is rare.
+		 */
+		settings.khugepaged.max_ptes_none = 0;
+		settings.khugepaged.pages_to_scan =
+			nr_areas * (hpage_pmd_size / page_size) * 8;
+		for (i = 0; i < NR_ORDERS; i++) {
+			if (thp_supported_orders() & (1UL << i))
+				settings.hugepages[i].enabled = THP_INHERIT;
+		}
+		/* Popped at the end of this mode, before the next one. */
+		thp_push_settings(&settings);
+
+		region = mmap(BASE_ADDR, nr_areas * hpage_pmd_size,
+			      PROT_READ | PROT_WRITE, MAP_ANONYMOUS |
+			      MAP_PRIVATE | MAP_FIXED_NOREPLACE, -1, 0);
+		if (region != BASE_ADDR)
+			ksft_exit_fail_perror("mmap() playground");
+		mremap_area = region + nr_shared_areas * hpage_pmd_size;
+
+		/* Populate so the first pass has something to collapse. */
+		for (i = 0; i < nr_shared_areas * hpage_pmd_size / page_size; i++)
+			*(unsigned int *)(region + i * page_size) = pattern(i);
+		memset(mremap_area, 1, hpage_pmd_size);
+		madvise(region, nr_areas * hpage_pmd_size, MADV_HUGEPAGE);
+
+		for (i = 0; i < nr_threads; i++) {
+			if (!(thread_mask & (1UL << i))) {
+				threads[i] = 0;
+				continue;
+			}
+			if (pthread_create(&threads[i], NULL, thread_fns[i],
+					   (void *)(i + 1)))
+				ksft_exit_fail_perror("pthread_create()");
+		}
+
+		end_ms = now_ms() + duration_s * 1000UL;
+		if (!strcmp(mode, "stepped")) {
+			while (now_ms() < end_ms && !corrupted) {
+				if (!khugepaged_full_pass(600))
+					ksft_exit_fail_msg("khugepaged pass timed out\n");
+				steps++;
+			}
+		} else if (!strcmp(mode, "free")) {
+			while (now_ms() < end_ms && !corrupted)
+				usleep(100 * 1000);
+		} else {	/* madvise */
+			while (now_ms() < end_ms && !corrupted) {
+				for (i = 0; i < nr_shared_areas; i++) {
+					madvise(region + i * hpage_pmd_size,
+						hpage_pmd_size, MADV_COLLAPSE);
+				}
+				madvise(region, nr_shared_areas * hpage_pmd_size,
+					MADV_DONTNEED);
+				steps++;
+			}
+		}
+
+		stop = 1;
+		for (i = 0; i < nr_threads; i++) {
+			if (threads[i])
+				pthread_join(threads[i], NULL);
+		}
+
+		/* Final integrity sweep. */
+		for (i = 0; i < nr_shared_areas * hpage_pmd_size / page_size; i++)
+			check_page(i);
+
+		ksft_test_result(!corrupted,
+				 "%s: %ds, %d steps, no corruption\n",
+				 mode, duration_s, steps);
+
+		/*
+		 * Hand the address space and the settings back before the
+		 * next mode: it maps the region at the same fixed address,
+		 * and its scan cadence differs.
+		 */
+		munmap(region, nr_areas * hpage_pmd_size);
+		thp_pop_settings();
+		stop = 0;
+		steps = 0;
+
+		if (corrupted) {
+			/* Memory is suspect; the rest would prove nothing. */
+			while (++m < nr_modes)
+				ksft_test_result_skip("%s: skipped after corruption\n",
+						      modes[m]);
+			break;
+		}
+	}
+
+	thp_restore_settings();
+	ksft_finished();
+}
diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index c0f69da3fd3b..fc61907aa3b2 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -406,6 +406,8 @@ CATEGORY="thp" run_test ./folio_order_check
 
 CATEGORY="thp" run_test ./khugepaged_sync_check
 
+CATEGORY="thp" run_test ./khugepaged_race
+
 CATEGORY="thp" run_test ./khugepaged
 
 CATEGORY="thp" run_test ./khugepaged -s 2
-- 
2.54.0


