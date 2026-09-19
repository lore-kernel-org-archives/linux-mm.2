Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A822DC982D8
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 00:26:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B2DD6B00BC; Fri, 18 Sep 2026 20:25:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 864526B00BD; Fri, 18 Sep 2026 20:25:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 758906B00BE; Fri, 18 Sep 2026 20:25:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3F7316B00BC
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:25:31 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7C59BA3B51
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 00:25:30 +0000 (UTC)
X-FDA: 85228618020.01.A204EDD
Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	by imf10.hostedemail.com (Postfix) with ESMTP id 919D2C0008
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 00:25:28 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="C 531B/w";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=EJ2bXYXV;
	spf=pass (imf10.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789777528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fZqVlKB5Ahaa32ahyNh/7jJg4/PpDw7vdO8QuZXsxdw=;
	b=59Ckg7Vm+4tdSdRHIVf1s7Ev+rzS6iihQjrRpywK+H6NSVAEW0UndMnzMGNc20UdvCP0ZW
	vESShxBW9c4APl735VOIPM2JGhtzxkAfm3KwilCZ0SNWlStNL3dwFCBiKi7s/V8jMB//GU
	NpxbHqedPoqXyEwyIJQg5L8ralTjDys=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="C 531B/w";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=EJ2bXYXV;
	spf=pass (imf10.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789777528;
	b=BgWF0UV/by6zVQEjTTbHNyTNU1Ws90PAGAHjB05t3x1dwozBM9dEpu9DhhmdgashWtAy1D
	bZHtqNNBBuDdImT1m6JQJ6kkDi/zbY4tKTdbv6qU4NzDjXwLsWc9XGNh7wY3TZA6+1U3ld
	sjdMQ0ajsOYrIgkz1/pdoX2++Ebv5Xs=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.phl.internal (Postfix) with ESMTP id 22406EC020B;
	Fri, 18 Sep 2026 20:25:28 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Fri, 18 Sep 2026 20:25:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1789777528; x=
	1789863928; bh=fZqVlKB5Ahaa32ahyNh/7jJg4/PpDw7vdO8QuZXsxdw=; b=C
	531B/w9BcMkCVupe0MVCxjVp8V1p3js3+LVE5hMiSWkpZL49wCWQ6GRpNGp0Ufvp
	RVIwuMBCXoqL/Zy66DJl3b1QTKLfbXtZQl9JLjDBI4fSqn8m6c1i7FOt2lZCQ1lA
	xD9ZcbJbje4LduVRKUKF+6x2SMJQ1x3aNx+tp2RdWWcLaZ5mFa/z7zKskRI8Bsyv
	Ou85d3rU3Vv3RKDPA3oUf7Z8wvxHfg+DwqSlfueCWqPCS59xGLIo2Ea+pgZWjAnX
	98KdsjYyGMukzoKbS03KZ43Cr5J0RDOCDt2ver55b7eCJPs+3/JwwynRvjc2JRaP
	HR/wPY2NbsaY+9wU+AL5Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1789777528; x=1789863928; bh=f
	ZqVlKB5Ahaa32ahyNh/7jJg4/PpDw7vdO8QuZXsxdw=; b=EJ2bXYXVN7l76TLd5
	CyNnJwQfIgzQwaeLfnb/nJMAhC9dj8BvaqjblbLsCQjwVomOy0ur7m8StW3/rLRp
	KCXFt2R0M/dPI+sTPmU1qkKWbG+D5CPlE6vpt3edKEzPKoHKa+hKKS1Egw0XKCWT
	XtOWCVRsmLJUfi1OV8e0VHSF2iot+rmsTzEAXa84kiY0v8G1XJsvBsiN7KzHVOx9
	ElpZAJEk+nJMNRpJcwSg7dlb6vu6Pi4ns2NWG36kiZprKKfP3OHzAeSGGGZyK7aD
	Q5iugm9LOucj+7L/qa0JvDN2rE9gXxeSwor/jPEI8grFNJ1jpd7PGyHj5LvHGDju
	7LYgw==
X-ME-Sender: <xms:eNatajpaQXhYTzcfHC9XaL5zPvrxiKVG5JbD9lxZaMeL4YQ1V-TZVA>
    <xme:eNatamAfoM4NLjT51QriRU_IOuXCXa6In99h9YPy-jQMGp7gWFi2RfEXDUdxMrBce
    G1Yci792eDSF3Dq2IZ8MQfnS4OKcezI_Xlb_LS2Kh_6p3PPRPY-Vc-C>
X-ME-Received: <xmr:eNataib0oS0pYiQNIbK2pyeXVbvMm0kVNZ2jivkpTLIBUPeiDTYNIDjQBgY>
X-ME-Proxy-Cause: dmFkZTFdeCslqvGFSSbmnhtdeah2m5aJ+JS0pA7YZcLyjOSl38+BaMD8ToGDiujTmfb1FY
    hwc6MyP6OTrwB9YZ5cf4L42pzgHwmSUyeXVwqH+rQjzPLdOU7n8WI+L1MfkDKNJ/RFAPzh
    NlCaR2Fewfb53OcTxvB5KvIlzV5JISHwTvfMhxp8O5pDxNZaie3hjiM7DwEdIJtFqP5P16
    IJzN4rLPSq8PL3AzI9mCzJTBQz13YM+0hrUjs/JUttTBmoH69TA/2ONguP0NQ8nHQtvIz0
    3uJBRgi18k1Lqi8M3Hll9BkUCzWjsIEVqdaORpYkNdmWXEBvzlr7NFm9TsFftEQV4t5xgo
    RidHLGDjvW809CzufWbBh8c56jDxQwaPfPyxtZWlsijYNl3bkOOM5eUwvbFai/ThW+ptnr
    YbJ5S+6TsCsXeHTrZG2ZQMPfCwKXVJqSPivF1ONpgfjsNTm/x6gK3wMqpB1UMdiwTGIx/j
    2nBDy8MDG48TRX4TTrn8uhMjhfviO3Jwl3TgEzdr/VMawMuQhK3NqIMUHJkRtAl0WwVqDr
    QxVkT+Zs+PS2IKu/rRSp+nEuWDddAT9NxviK1OV+l+vyj02W4wWQw74jvvyCEAdrQBZZiI
    op+gq0MyX9tZbdmoa8Co/VN4XHcRS+SD4lm/F2D2EOwLVsXnLUrjfoC3hbdQ
X-ME-Proxy: <xmx:eNatautJtefjRFNFMmJOU_nOJwMrwUDWq7IdShksniSyMaOv_5B_Ww>
    <xmx:eNatak8ED8FRn8fDJkrwEtac82up-wbr6ff9CfhWAp0aisLcSGpUIA>
    <xmx:eNatauUuJ3Bc4V8q8SGaJdaJzu1UFCz_8NOfxly9fBHtnmLq0Oh_-w>
    <xmx:eNataotf3mn4t3659s5_ciGkjfUJpT8JvUebats7AMTSaPsOUaO29g>
    <xmx:eNatapw094mobiRnX35ZTf-wLOEESoJI9Mt8bY2lSCTR8Lmib-WwWICM>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 18 Sep 2026 20:25:27 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	Usama Arif <usama.arif@linux.dev>,
	"Nico Pache (Red Hat)" <nico.pache@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Hugh Dickins <hughd@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	kernel-team@meta.com
Subject: [PATCH v6 16/19] selftests/mm: add khugepaged race harness
Date: Sat, 19 Sep 2026 01:24:46 +0100
Message-ID: <20260919002451.496763-17-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260919002451.496763-1-kirill@shutemov.name>
References: <20260919002451.496763-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 919D2C0008
X-Stat-Signature: xhmoborqeyymwhrge3nf1166nnnpmxg4
X-Rspam-User: 
X-HE-Tag: 1789777528-439224
X-HE-Meta: U2FsdGVkX19I08keqGeZ6Os170Pqrw1XBbIEibAwIjOuU9Wc9eGFmxoL/Z9sJE9xnu+37dzvAgChfsVqLv2rIVD4tW+ABWz7ATdMf0lvHcDOnzpvK/muQei0Plhb3tZJWUjhb9taeIC2wqt1vB1EbFdSj7o1/VjBedx9urZcwyclJIH0AOFTezHsZagCgxrucr4VtAIEjZckCoe7ipFyAJnxVVpuBZl41ruRLNF7sKYoH3ArSVI/qcnUcYY8Sw+UgCEJywlepMii463bEucpExWrLmMQhQcLYCrpIo5kbj7/h8Zwszrp5gV/tszbwQZGgQvEr2spJecaCZmjCNzb21aprlNib+V1ptlqU98DNG73Q0b51PQRn8lmCMWdDzJmNs3lNr0YIGNhnWH/WY0upQHLvriOTZ5cuqD5wdQ8uQIK6i+8yIa1kYQvkpMSM7a/Y6u1zi13zPFveDx0pEonD5/6gFAqhF3RaNC3IAeG4jLmeJU4z7PpdQGcNrwZWozGamxVzhwMjm2Y80u+ws3KttczLhLYG6nSYrt8o2uCjgEJiJ7DiF/Ziy2TcpoFa/3ElyOUaO/mCABmSBL2ae/7ijFEhkKEc0MtGbts79jSPlIcjEA4gL9E2xkHyoJEkq5S8TFqNOwLOe7+x1J1Qx3n+O2aeaImGSPHAe+bNIdC1q1apQKwGDvPGG8i8/8ek9hPLbOsBOWXu0/mArzSsam4dKHhMishwqjw0dNWIcfs/3EDAGOa9VyX3hJay4JdVnTHzm4REeg3SIq3KLo7+CLRtRvxUA8S5cKJaxhgZZUtJLrcibi0j7E0mn+NlSBCiBsCrf9gLFhkRmmmJg8QBAhRJsWVy9HB/Mzi1xlg7AXYCkvWsNDL7IheP4kH3QPagfdSTus9Gx2lR/0/sNDIl5qB+dZgRfHaYts+/gDqjdXlHeU9XrVPQDJAnkh9gCftgVzdZ3rfRaQ46QMT8sr1K/P
 kBs3y6yT
 5hO6+cD3v0bqpueFP/tn2/jn+LVlamRvPH1QqryXN7HY+GdRWIp1V8Q34qKaAgJ61q6PaxhaiLaEeE4S28zwCE942l6mtvC8vhFhcDmk1UplAwK+bhuc43F5PNq5LVNcK95t46UOAnC6/rARRaF54pVRB8C7BLrdX5EX45CqlwM8x2NLJfbw0Q4DzfOr2sTEBYIA1t3mn35tKMgmXxmrcEw/6ddlOIhYONO+eY2i+C0rtw7eXmOKG4NneEEiKoTMlqo5wyHMrCetv0jlyXgQmKVNUnL32WK+nYxJQ1rbuFvJ1alOsILIoEWVry2/3IEnwpLiA2tB5oWSzdPIP23fHacy7gLEje0x4vmVWpSMGuE1vnrJLqvmKDsKKWXgN4ZsDHOpys1xK48CS/oxFQiqkDN2kyV85ovmtZScUG2pXbt7uPR/nM6WVokog7SwGkXOpgbtjx4Juc24zzhqydsqPd/6Zw9G4e9jexsK8MlXVho4oV59d3AgaHM6Ww0W/AOoDI6rh
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

Add khugepaged_race.  Six racing threads work the same address space:

  - two faulters
  - an MADV_DONTNEED thread
  - a transient FOLL_PIN thread (gup_test)
  - a forker
  - an mremap thread

One of three drivers collapses under them:

  stepped   khugepaged, one full pass at a time via
            khugepaged_full_pass(), so each step covers a known extent;
  free      khugepaged left to run (scan_sleep_millisecs=0), for soak;
  madvise   an MADV_COLLAPSE and MADV_DONTNEED loop.

Every mode runs in turn unless -m names one, five seconds each.  Every
supported anon THP order is set to inherit and max_ptes_none is 0, so a
window collapses only once fully populated and the racing MADV_DONTNEED
steers selection across orders.

The rule is that a racing page reads as its pattern or as zero, never
anything else.  The faulters and fork children check it throughout, and a
final sweep checks it again.  The other half of the check is the kernel's
own assertions, so read dmesg too.

The pin thread goes through gup_test, so the harness skips without
CONFIG_GUP_TEST or root.  The default playground is three shared PMD-sized
areas plus the mremap thread's, over two gigabytes at a 512M PMD; -a
shrinks it.

Assisted-by: LLM
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/Makefile          |   1 +
 tools/testing/selftests/mm/khugepaged_race.c | 415 +++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh    |   2 +
 3 files changed, 418 insertions(+)
 create mode 100644 tools/testing/selftests/mm/khugepaged_race.c

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index 2ed881324911..beacc0f87304 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -107,6 +107,7 @@ TEST_GEN_FILES += rmap
 TEST_GEN_FILES += folio_split_race_test
 TEST_GEN_FILES += folio_order_check
 TEST_GEN_FILES += khugepaged_sync_check
+TEST_GEN_FILES += khugepaged_race
 TEST_GEN_FILES += soft-dirty
 
 ifeq ($(ARCH),x86_64)
diff --git a/tools/testing/selftests/mm/khugepaged_race.c b/tools/testing/selftests/mm/khugepaged_race.c
new file mode 100644
index 000000000000..66c9e2c10f66
--- /dev/null
+++ b/tools/testing/selftests/mm/khugepaged_race.c
@@ -0,0 +1,415 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Race collapse against faults, GUP pins, fork, mremap and MADV_DONTNEED
+ * over the same ranges.  A racing page must read as its pattern or as
+ * zero, never anything else; the kernel's own assertions in dmesg are the
+ * other half of the check.
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
+#include <mm/hugepage_settings.h>
+#include "../../../../mm/gup_test.h"
+
+#ifndef FOLL_WRITE
+#define FOLL_WRITE 0x01
+#endif
+
+#define BASE_ADDR	((void *)(1UL << 30))
+#define PASS_TIMEOUT_S	30
+
+/*
+ * PMD-sized areas the racing threads share, plus one for the mremap
+ * thread.  -a shrinks it where a PMD is 512M.
+ */
+#define DEFAULT_SHARED_AREAS	3
+static int nr_shared_areas;
+static int nr_areas;
+
+static unsigned long hpage_pmd_size;
+static unsigned long page_size;
+/* nr_areas PMD-sized areas; the last one belongs to the mremap thread */
+static char *region;
+static char *mremap_area;
+static char *mremap_scratch;
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
+/* Clamp so a range never reaches the mremap thread's area */
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
+		unsigned long nr = room_from(page_idx, 16);
+
+		gup.addr = (unsigned long)(region + page_idx * page_size);
+		gup.size = nr * page_size;
+		gup.nr_pages_per_call = nr;
+		gup.gup_flags = FOLL_WRITE;
+		/* Racing MADV_DONTNEED makes transient failures expected */
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
+			 * No stdio in the child: a thread may hold stdout's
+			 * lock across the fork, and printing under it hangs.
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
+			/* A child killed on the read counts too */
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
+		/* The move back unmapped the scratch address: claim it again */
+		if (mmap(mremap_scratch, hpage_pmd_size, PROT_NONE,
+			 MAP_ANONYMOUS | MAP_PRIVATE | MAP_FIXED_NOREPLACE,
+			 -1, 0) != (void *)mremap_scratch)
+			ksft_exit_fail_perror("mmap() mremap scratch");
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
+		"Usage: khugepaged_race [-d seconds] [-m stepped|free|madvise] [-a areas] [-t mask]\n"
+		"\tWithout -m, every mode runs in turn.\n"
+		"\t-d: seconds per mode (default 5)\n"
+		"\t-a: number of shared PMD-sized playground areas (default 3)\n"
+		"\t-t: bitmask of racing threads to start, for bisecting a failure\n");
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
+			thread_mask = strtoul(optarg, NULL, 0);
+			break;
+		default:
+			usage();
+		}
+	}
+
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
+	 * MREMAP_FIXED unmaps whatever is in the way without saying so, so
+	 * claim the mremap thread's scratch address up front.
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
+	/* Base of the settings stack; the bottom entry is never popped */
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
+		 * mTHP collapse honours only 0 or HPAGE_PMD_NR - 1 here, and 0
+		 * keeps a step from being spent on PMD allocations that racing
+		 * MADV_DONTNEED will not let succeed.
+		 */
+		settings.khugepaged.max_ptes_none = 0;
+		/* One wake, one pass: the playground plus the forked children's copies */
+		settings.khugepaged.pages_to_scan =
+			nr_areas * (hpage_pmd_size / page_size) * 8;
+		for (i = 0; i < NR_ORDERS; i++) {
+			if (thp_supported_orders() & (1UL << i))
+				settings.hugepages[i].enabled = THP_INHERIT;
+		}
+		thp_push_settings(&settings);
+
+		region = mmap(BASE_ADDR, nr_areas * hpage_pmd_size,
+			      PROT_READ | PROT_WRITE, MAP_ANONYMOUS |
+			      MAP_PRIVATE | MAP_FIXED_NOREPLACE, -1, 0);
+		if (region != BASE_ADDR)
+			ksft_exit_fail_perror("mmap() playground");
+		mremap_area = region + nr_shared_areas * hpage_pmd_size;
+
+		/* Populate so the first pass has something to collapse */
+		for (i = 0; i < nr_shared_areas * hpage_pmd_size / page_size; i++)
+			*(unsigned int *)(region + i * page_size) = pattern(i);
+		memset(mremap_area, 1, hpage_pmd_size);
+		if (madvise(region, nr_areas * hpage_pmd_size, MADV_HUGEPAGE))
+			ksft_exit_fail_perror("madvise(MADV_HUGEPAGE)");
+
+		for (i = 0; i < nr_threads; i++) {
+			if (!(thread_mask & (1UL << i))) {
+				threads[i] = 0;
+				continue;
+			}
+			if (pthread_create(&threads[i], NULL, thread_fns[i],
+					   (void *)(i + 1)))
+				ksft_exit_fail_perror(thread_names[i]);
+		}
+
+		end_ms = now_ms() + duration_s * 1000UL;
+		if (!strcmp(mode, "stepped")) {
+			while (now_ms() < end_ms && !corrupted) {
+				if (!khugepaged_full_pass(PASS_TIMEOUT_S))
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
+		for (i = 0; i < nr_shared_areas * hpage_pmd_size / page_size; i++)
+			check_page(i);
+
+		ksft_test_result(!corrupted,
+				 "%s: %ds, %d steps, no corruption\n",
+				 mode, duration_s, steps);
+
+		/* The next mode maps the same fixed address with its own settings */
+		munmap(region, nr_areas * hpage_pmd_size);
+		thp_pop_settings();
+		stop = 0;
+		steps = 0;
+
+		if (corrupted) {
+			/* Memory is suspect; the rest would prove nothing */
+			while (++m < nr_modes)
+				ksft_test_result_skip("%s: skipped after corruption\n",
+						      modes[m]);
+			break;
+		}
+	}
+
+	ksft_finished();
+}
diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index 612a8c4afc53..6990485b1a9d 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -386,6 +386,8 @@ CATEGORY="thp" run_test ./folio_order_check
 
 CATEGORY="thp" run_test ./khugepaged_sync_check
 
+CATEGORY="thp" run_test ./khugepaged_race
+
 CATEGORY="thp" run_test ./khugepaged
 
 CATEGORY="thp" run_test ./khugepaged -s 2
-- 
2.54.0


