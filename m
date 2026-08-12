Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1144AC5B572
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 13:24:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD5B36B014B; Wed, 12 Aug 2026 09:23:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B87876B014D; Wed, 12 Aug 2026 09:23:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4E026B014E; Wed, 12 Aug 2026 09:23:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7428D6B014B
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:23:51 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0616D1C102F
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:23:51 +0000 (UTC)
X-FDA: 85092685062.13.9DBFF41
Received: from fhigh-b1-smtp.messagingengine.com (fhigh-b1-smtp.messagingengine.com [202.12.124.152])
	by imf23.hostedemail.com (Postfix) with ESMTP id 11DB5140006
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:23:48 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="R KFRcnU";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=aI1phcga;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.152 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786541029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9oFfQCqKMm/SRuwfBKl+h3wjprs8HFm3Wg7AwMGv1us=;
	b=vqAFlvPtDTxPD1d5LFPrDwv3zFKW7ivdkfcCiWQ8tJxKoW1rBkRlXveSbrc+CwriNbWiXW
	tOver07h1Mr1lJ9YpoY1HwM9Yz2i7Y97TLUqiKwg6QAeKjYLFm6KjsS5I8rHNf+eK5gpjr
	JCy2jqmKv9Uy0NqGSwLfQaLvSJtk0w4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="R KFRcnU";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=aI1phcga;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.152 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786541029;
	b=Ty7wggsNf1lWkBJfASFCcBm+K3tLji2ahZNkxF/gCBqdnHyGYQSqW6A6Jw6E1wmTPMbQEd
	FDkY2MtQWh+QccWAOfAupFtu0AQiOymvb6CyTsOSrlqCRkzAh5dRJNAmUya1H0bPJ7JGh/
	a0UJZkY5ZbIVjzTJbbQzQbkHen/Eu7A=
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfhigh.stl.internal (Postfix) with ESMTP id D900A7A0160;
	Wed, 12 Aug 2026 09:23:47 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-12.internal (MEProxy); Wed, 12 Aug 2026 09:23:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786541027; x=
	1786627427; bh=9oFfQCqKMm/SRuwfBKl+h3wjprs8HFm3Wg7AwMGv1us=; b=R
	KFRcnUi44U2l6boPRdaVVvH6gb2KV+xf0LjuR6A1ffFKLu8nw/fxYxTtSWJSYlie
	FiZ7If8zPxzqQpfr2DUACe8eQpwUTdNtDc7XiN2PzVnc+uw8xgeN8sjcoeYE4N8L
	Y7Dgoj/Iamgob2Kc0F2zXEzypV7aXumc9AWdDcwNBuKLmv1/KwAh/E4yfJZsh9lL
	q0tBT1drLH96YfJDtxqqJ5zc4/gcslYKLibKSlXI6jOSUL3NQEttZIqo60Tb0c1f
	Lo/WedLO7e7YrnJQ6zH/uFTukJ64p8uL20AZEel5b6paepn3o1TsCDfqnZs5kIQV
	YLB7j+eKLRfYZNkGleruA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786541027; x=1786627427; bh=9
	oFfQCqKMm/SRuwfBKl+h3wjprs8HFm3Wg7AwMGv1us=; b=aI1phcgaXMW/AnGfn
	JbQgufLsPj3DeZh6L4SZPJR7c4gDi9Yx4G4/QO1xaGKXM9TkYnWUlnEEjjk/3m87
	Yw0TO6A890J1wRu6KFOhEeTcOhdxRF2h7pcbqE+4s/a4TZ+PYC4KtkrfLqhuWiSw
	PU7ZlPxCXtRk8je2xcdAEtkCGtiy+U8Q2kjmpXPlzNhJKQDZ6UzF+qjwWi+mEbTB
	TVlnjx2peDfn9nLlHicKj8bT3P6RqJcKlNDjcrfJeNwGoJaMyTBFFyTdDseZeezb
	eQRaAP+U4fKNRy8oT5eSSc8eYtDT06nZLUgu1lActaxI8D8yRA+WTW5YxRNHbnZ/
	54I4A==
X-ME-Sender: <xms:43N8agvdX9rRTrh-A25ZNV3LM_DNtPg4x3xkiJs51wJY04rR4YgHCA>
    <xme:43N8ahZHtzk5_IWOatSmIr_psgvU7iAWeyolOEJ5vYFSdgEc6qNr4iuFAmJGevuwQ
    H8YVZR2boIL0ynGJCiV2Gw_26KnBaWvR63QkHIvhAW8DJw52aR_1PU>
X-ME-Received: <xmr:43N8akRI7CG1RR19zoMKoigcWL-OFwejaAoO1RlD3Mj--Dm9vQkvBkSdtEY>
X-ME-Proxy-Cause: dmFkZTEWZPjKBYDoSh3uCuJ0ogiZvSuDj1RAgMuSmimalRft9LCPvZxyrluChLfTbkjo2r
    KkCK8Ttm4mqxi+W2/UjRoyI4gRuaMCGjIyoE2sYafZhhTXl0iIGCKEOr9/WVtZfHPc/pjz
    XsLpzK8U2Xu6F30SrJOujIlp1bmlomKUtpU/iiXSkRy6wwaI7NV8wAm1PQ0lHgRG0nCRKX
    WKIh8TtevEly/nhHwG2deu/klJhGkXN7h/CDYOOyqjOIkeF7MAFsC6fZtQDVeVkgzM4xU1
    Py5NrFUehZdXXi5LHUYxqNjNVNbuxWN2P2YJW6J2IL8s+zlVHHPN2YdKOlFVuMcbnWK9n+
    gMTk4WgLkBkenumpDQFUN9Fx+TeJoxCVG8CZRQgGqQpM7yxSCigP0CZHQrFni2NmMVhFzF
    JwcWfDUaC35gcJW/Ysr7QnWcKi3pdMoQYao4BZjPZ50t0KQOHbOEPsfMSSYHKYo0Fk1MfR
    lE4JRLi0km31O2Lv0PQShhLHynfRCsVV2OLxchoXEc/di5G1kF+MFl4nHBgvX1SwA+k9s+
    GAKiI8swXWbzhXBnl94tJXohsuStdSy8btM1QyPy8yC+AuNWjaN83+OmzMu5d7wlgWnyLs
    tXR/l8tpjQJGRgl1ywR13NuLVtkirnksonjoac6p7DmdB5podVjwJUMMb7tg
X-ME-Proxy: <xmx:43N8asztE8M1II1NW12LrjNWwaga0t4BXwa9qoyR1Aalp3K690lF_A>
    <xmx:43N8aofa-eUmki2-ROZlu2IvbmYyg8rPuFLXflfb6opdEbxne4VF7g>
    <xmx:43N8alpndOvMnhc4fK2OQ2v246dYVfNneVj8R1oSb1juul11Vj0oYA>
    <xmx:43N8aoMDVHhD0wGTau-MIyHONjqHsUEQV2J1qiuC_IQ_IhxVb2fz5A>
    <xmx:43N8ahOU66WtJEgp40Qb_VOW_hjQvruvjX74VVEPsL-2klL8Ab_lJKyU>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 12 Aug 2026 09:23:46 -0400 (EDT)
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
Subject: [PATCH v3 15/18] selftests/mm: add khugepaged race harness
Date: Wed, 12 Aug 2026 14:23:01 +0100
Message-ID: <20260812132304.199287-16-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260812132304.199287-1-kirill@shutemov.name>
References: <20260812132304.199287-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: s7gyq5ch6idbpz4i8n9qbkfx8fdduqz3
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 11DB5140006
X-HE-Tag: 1786541028-259376
X-HE-Meta: U2FsdGVkX1/rdjS9+Q+Hiy7oqIj4gExQsUjSJbjV7YYe7TvQKf9FYaeIsVcv05jgT3ezJ/0JDRvZa4N1Xb2cTnTekaPY4A6GtsritTv1NTMj48FqeTRxpuk60IF8tM1zQ1mHsVRl1Lwf8ChlNv2yWytIrS4KoDdXlBPgkv1SE/Gjfy9gmNklN1Gwp9WEmhQ0TbGXKDHpf+/l4oZSU9tpBNdn//sDrOF1gMBSapJA5Evp2u9M7gf4xvT2uZ/0Wm1D5lkAphrjBrcNnpVqT+GSQ6VOaA6eT4ER+L8rojyfEid5XyguE3vTdN75/pmpAzni6Us8JPq2yS9FrEanN2+YBus0SO2+Jiabyap7unrBhkldni3OOotcr+kWxNRsipC9r+KHpIlIcsEA7nZq6NxXftRwnQAThlH4iKlYqk9IPMjO+BK3xMCbukmjW92O8o5FLAOxqSoQDKaH7v9K4eVMNQ7KPwXP2JfGcL/+Qt85twDLZe3U0a6qIC/cHySp7WX6s8cSSHH7XQkHHMZI00w6/pQX1CH0rHDV73wJlDd6KRkG20NE8xxmzmwWtlYo/WdIkUa9xtWXch8vPXl0G4GJjPIVnF87IFBtd6237FckDtqFPLbK5/CvR6MpvINuTrs/YcLD3v2UGNpmebQcn8+WhFdToid+9YCRrUPsIFLWiZd4G+ov+3xYcFVoHHKuJYdOPupeeY2M9SY9z3Rz+i9nt3JsvkrtDFVwpuDfT4h4AH5kYf7mVhbfZvTMCDp9JksrFND5lnQi3VNyvPLd/oxMztR8lnIShiRESD4zX/7UilBx2aZD5smVpYe4yKyrPITpyNMS1LD4JPO66oiek3wfWlq7VHkBhP82FEKH1hfOiJGvMDn8TDC95J6O+BojvMbfb6h7y7NmbtSSHwzQ+8oHq4buzlgfXGcvQ4X8w4L9GSjN2HUSmfDU2pWh8NJPCMsvQt4M2R88eCzaI4bt277
 Yl8l7u1n
 Ozayg+ndXq3WhW0rjct4cR4CsU/z68jSpevXbJmC5VoRoYD+A6KwWHDm+vZh7S2S86MJanSK3bUMEREGvLDJ32Acl8uCI1V4zpjxH7xlLawKsTUtGHidGFRgNUAeOpAY4bUS/zAZU6mF8i94nKSLUeUMlpriMqUQOPUWJtc1BmvCgJNHbGxMI8a9R54oHBVjFBvo6QaHg9YQUCWNguPQVshwXd+qDDgHwhDilgiTufE+RdYIm0XU2A9hhpNEz4cC+zj/gi/9TiSRJ15M1cCGEZFzVncWi/DV+QfZyHqr/IOJ0lU4Ub02JKTaTMPD6k1qSA6wkH/NSid7Xy4vxrnCpw7QbsfzvCSG3Jd8CSJ+D9DjmfM+ohHnK2CQWbMG2W1xYZszOGvHLI9T1ytfVNs3/ICY0NqiRkKtYdzQNuuKntK+dkppjGhByso2q1JildI0YaYIh4WuDxwdEqS2oESm4K5qF8122qfCuxwOkc2E0B2fknGt5/Cf7kf9BIbn/kGkzgYRB
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
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/Makefile          |   1 +
 tools/testing/selftests/mm/khugepaged_race.c | 441 +++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh    |   2 +
 3 files changed, 444 insertions(+)
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
index 000000000000..d9e421ede6de
--- /dev/null
+++ b/tools/testing/selftests/mm/khugepaged_race.c
@@ -0,0 +1,441 @@
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
+/* Zero means never written; anything else must be this page's pattern */
+static bool page_is_corrupt(unsigned long page_idx, unsigned int *val)
+{
+	*val = *(unsigned int *)(region + page_idx * page_size);
+
+	return *val && *val != pattern(page_idx);
+}
+
+static void check_page(unsigned long page_idx)
+{
+	unsigned int val;
+
+	if (page_is_corrupt(page_idx, &val)) {
+		corrupted = 1;
+		ksft_print_msg("Corruption at page %lu: %#x != %#x\n",
+			       page_idx, val, pattern(page_idx));
+	}
+}
+
+static unsigned long shared_pages(void)
+{
+	return nr_shared_areas * hpage_pmd_size / page_size;
+}
+
+static unsigned long rand_page(unsigned int *seed)
+{
+	return (unsigned long)rand_r(seed) % shared_pages();
+}
+
+/* Pages left from @page_idx, so a range never reaches the mremap thread's area */
+static unsigned long room_from(unsigned long page_idx, unsigned long want)
+{
+	unsigned long left = shared_pages() - page_idx;
+
+	return want < left ? want : left;
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
+		madvise(region + page_idx * page_size,
+			room_from(page_idx, nr) * page_size, MADV_DONTNEED);
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
+		unsigned long nr = room_from(page_idx, 16);
+
+		gup.addr = (unsigned long)(region + page_idx * page_size);
+		gup.size = nr * page_size;
+		gup.nr_pages_per_call = nr;
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
+			unsigned int val;
+			int bad = 0;
+
+			/*
+			 * No stdio in the child: a thread may have held
+			 * stdout's lock when we forked, and printing under an
+			 * inherited lock hangs.  The parent reports what the
+			 * exit status says.
+			 */
+			for (int i = 0; i < 16; i++)
+				bad |= page_is_corrupt(rand_page(&seed), &val);
+			_exit(bad);
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


