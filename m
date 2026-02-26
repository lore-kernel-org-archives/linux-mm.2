Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CFF4FC5930
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 11:34:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACF6D6B00B3; Thu, 26 Feb 2026 06:34:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A79196B00B5; Thu, 26 Feb 2026 06:34:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9659B6B00B6; Thu, 26 Feb 2026 06:34:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 83D086B00B3
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 06:34:50 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 53A9E1B7946
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:34:50 +0000 (UTC)
X-FDA: 84486400740.14.AA4F438
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8BF8C40002
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:34:48 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ec17NRLq;
	spf=pass (imf01.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772105688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3EBMW5df/kqjxALvGCac5LeXwtQNaqEvULHNZHX+1lo=;
	b=qCDPyKIKb//y0gEkL6zPYiuPFROa3vrwUCYMNOm8TXb6nVsfWnardJDxnPc1THGIQ29r7T
	2T4QLRwW9sKx6bubHuh/m0J9riO2qJq0D8RSgLZdY2kL7favLS8bPxyTvVtHLh6y18FeHP
	QLoc6CDXR0JfiMPVO4f4fJd6DgqGbNA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772105688; a=rsa-sha256;
	cv=none;
	b=mwXeiXjBYENxrWs9u+nYIlVJ/vy5ptjy/3/VmAgpjDixxffgvvgo4W3QbtjTpMi6sqsI4p
	AVFLNRnH9GgapHicau49NmxQ7LdhwRO9gLjrJbTD+Qh5JZL42S9h6avANbeogaZ9LFANz4
	o5v/vepbB4oQnytZIPiUpiVdcZVRmqI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ec17NRLq;
	spf=pass (imf01.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772105686;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3EBMW5df/kqjxALvGCac5LeXwtQNaqEvULHNZHX+1lo=;
	b=Ec17NRLqZdkNOCfYyhxyJmbLXJ3hDN99fyOVr8S7gzesBylU0G5qLKGmWd2mUsNPo4QbCO
	0P46bXf4Y7YpPawzBDCHsB8JH5ZskGMhbudmRHaDZgLl4BF2ofVHpfjC5JFLtZFT9+SWee
	iFTIlNIY6EmRvwy8JGlhh+lWFExdBSw=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	willy@infradead.org,
	linux-mm@kvack.org
Cc: fvdl@google.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	linuxppc-dev@lists.ozlabs.org,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	agordeev@linux.ibm.com,
	borntraeger@linux.ibm.com,
	svens@linux.ibm.com,
	linux-s390@vger.kernel.org,
	Usama Arif <usama.arif@linux.dev>
Subject: [RFC v2 17/21] selftests/mm: add THP PMD split test infrastructure
Date: Thu, 26 Feb 2026 03:23:46 -0800
Message-ID: <20260226113233.3987674-18-usama.arif@linux.dev>
In-Reply-To: <20260226113233.3987674-1-usama.arif@linux.dev>
References: <20260226113233.3987674-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 8BF8C40002
X-Stat-Signature: n31ar9qpeot8k1f4334by4z1p9t7bcr7
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1772105688-29088
X-HE-Meta: U2FsdGVkX19udidSLVV0yY09AnYDXTH4kul+vst2MJbyucBJdpZx0wgM4zSW4Xfl/f1jb4IRnscOC+haOTXjGbJpzCXAe9oSBcyMYbWPJ2rUwU417Y5+CI+IEqhZFpoY8R8vtQajCCvjJs8mbU7Bnb9ZNCDdxTJluld5DfFEK7/MA8K65C1RT2TtfYle/gLgeJjXUUJo41hmqFYYojPEeE54PdMVyg0MhMuS7xWKpqQutWJYsRrf5UN1TnEZ5sjwZo8GpoXo+N2ydKkhbxBZww0qilORHhrv2DKCqN54kdAdrNr9oCH59/hSXH9lrIA5o7PsphsGsvBI/bdDZps6yzgBl9KAn7CajvCCq9YlFHyeqOdPmwNTSFV9KpR4djqdZnXOnqRD4bG2pUCPa+qJM4uUt9klJIVoZXfRAPoBgyVuJJfGFKkEV3ydkG9Av/csffgaiIou2wMmc57N9IWs3uB8XJSdjhyQPYcQGSIqBK1qxhpuQrbeGuEFxRrt9GcMJs18TiP28/65wRMt6B52wMo+wobMMjcYTjwY5pg7dqIH3TdqsAPGh4ozZd6oApbHKE4DNK1VZnmO9A5lwpOhhD8HPeNAorYL7ioce5ffmodfq+gvw4JagnMxly8SguKM2kjinPt36mZLdOsXYjYLjc93gnEtZmAQA72w2z48adCsvRZ8SnLe2pqsAZvr3CYqem9RZqkJs/dWtt24e+edEVtmNbSQdeCeSp0ZhR19eXyA/QQtoDGClraeWSQo6/9852o6VTPYwBq5u43IbvQF5SoSnLooA3MU6Fk5CTHIhJ1NseMD24r9sh0RKpfhfSjbS7y6lRhC2nbdgC/wuTrvHIRUV54QS/DD7C77yB8uRepH1U2rMECfnqRskdJZLB7hSB0v7k7rhMkZ9E328rMxpkT/0en1gc0YMVQbgmzoeRU7ZlazhFUAVDXsRZ1+lW2dgG4ObCKEPo6ZXcpuhMi
 kRjnbgsK
 5QqcgdYLLZUULzsnOF4fqz9do+jsJn1f1IduNdCGmcIqFIY8bW/IdxT5nkgl9fcGUXZTlq5mGWMogPH3LQ+r42DkRgXRUEN3Q0WExcZsIEkppA5dIYeM6+/tVaM1g+tIg2lc+nDjqLv2US9Qx1/FgVp2n3/O9dlob3kGuexdBeTOXuHnLmPwsVL2x3gSIES/ISSbtYrsr5hInxK8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add test infrastructure for verifying THP PMD split behavior with lazy
PTE allocation. This includes:

- Test fixture with PMD-aligned memory allocation
- Helper functions for reading vmstat counters
- log_and_check_pmd_split() macro for logging counters and checking
  if thp_split_pmd has incremented and thp_split_pmd_failed hasn't.
- THP allocation helper with verification

Also add a test to check if partial unmap of a THP splits the PMD.
This exercises zap_pmd_range part of split.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 tools/testing/selftests/mm/Makefile           |   1 +
 .../testing/selftests/mm/thp_pmd_split_test.c | 149 ++++++++++++++++++
 2 files changed, 150 insertions(+)
 create mode 100644 tools/testing/selftests/mm/thp_pmd_split_test.c

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index 7a5de4e9bf520..e80551e76013a 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -95,6 +95,7 @@ TEST_GEN_FILES += uffd-stress
 TEST_GEN_FILES += uffd-unit-tests
 TEST_GEN_FILES += uffd-wp-mremap
 TEST_GEN_FILES += split_huge_page_test
+TEST_GEN_FILES += thp_pmd_split_test
 TEST_GEN_FILES += ksm_tests
 TEST_GEN_FILES += ksm_functional_tests
 TEST_GEN_FILES += mdwe_test
diff --git a/tools/testing/selftests/mm/thp_pmd_split_test.c b/tools/testing/selftests/mm/thp_pmd_split_test.c
new file mode 100644
index 0000000000000..0f54ac04760d5
--- /dev/null
+++ b/tools/testing/selftests/mm/thp_pmd_split_test.c
@@ -0,0 +1,149 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Tests various kernel code paths that handle THP PMD splitting.
+ *
+ * Prerequisites:
+ * - THP enabled (always or madvise mode):
+ *   echo always > /sys/kernel/mm/transparent_hugepage/enabled
+ *   or
+ *   echo madvise > /sys/kernel/mm/transparent_hugepage/enabled
+ */
+
+#define _GNU_SOURCE
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <sys/mman.h>
+#include <sys/wait.h>
+#include <fcntl.h>
+#include <errno.h>
+#include <stdint.h>
+
+#include "kselftest_harness.h"
+#include "thp_settings.h"
+#include "vm_util.h"
+
+/* Read vmstat counter */
+static unsigned long read_vmstat(const char *name)
+{
+	FILE *fp;
+	char line[256];
+	unsigned long value = 0;
+
+	fp = fopen("/proc/vmstat", "r");
+	if (!fp)
+		return 0;
+
+	while (fgets(line, sizeof(line), fp)) {
+		if (strncmp(line, name, strlen(name)) == 0 &&
+		    line[strlen(name)] == ' ') {
+			sscanf(line + strlen(name), " %lu", &value);
+			break;
+		}
+	}
+	fclose(fp);
+	return value;
+}
+
+/*
+ * Log vmstat counters for split_pmd_after/split_pmd_failed_after,
+ * check if split_pmd_after is greater than before and split_pmd_failed_after
+ * hasn't incremented.
+ */
+static void log_and_check_pmd_split(struct __test_metadata *const _metadata,
+	unsigned long split_pmd_before, unsigned long split_pmd_failed_before)
+{
+	unsigned long split_pmd_after = read_vmstat("thp_split_pmd");
+	unsigned long split_pmd_failed_after = read_vmstat("thp_split_pmd_failed");
+
+	TH_LOG("thp_split_pmd: %lu -> %lu", \
+	       split_pmd_before, split_pmd_after);
+	TH_LOG("thp_split_pmd_failed: %lu -> %lu", \
+	       split_pmd_failed_before, split_pmd_failed_after);
+	ASSERT_GT(split_pmd_after, split_pmd_before);
+	ASSERT_EQ(split_pmd_failed_after, split_pmd_failed_before);
+}
+
+/* Allocate a THP at the given aligned address */
+static int allocate_thp(void *aligned, size_t pmdsize)
+{
+	int ret;
+
+	ret = madvise(aligned, pmdsize, MADV_HUGEPAGE);
+	if (ret)
+		return -1;
+
+	/* Touch all pages to allocate the THP */
+	memset(aligned, 0xAA, pmdsize);
+
+	/* Verify we got a THP */
+	if (!check_huge_anon(aligned, 1, pmdsize))
+		return -1;
+
+	return 0;
+}
+
+FIXTURE(thp_pmd_split)
+{
+	void *mem;		/* Base mmap allocation */
+	void *aligned;		/* PMD-aligned pointer within mem */
+	size_t pmdsize;		/* PMD size from sysfs */
+	size_t pagesize;	/* Base page size */
+	size_t mmap_size;	/* Total mmap size for alignment */
+	unsigned long split_pmd_before;
+	unsigned long split_pmd_failed_before;
+};
+
+FIXTURE_SETUP(thp_pmd_split)
+{
+	if (!thp_available())
+		SKIP(return, "THP not available");
+
+	self->pmdsize = read_pmd_pagesize();
+	if (!self->pmdsize)
+		SKIP(return, "Unable to read PMD size");
+
+	self->pagesize = getpagesize();
+	self->mmap_size = 4 * self->pmdsize;
+
+	self->split_pmd_before = read_vmstat("thp_split_pmd");
+	self->split_pmd_failed_before = read_vmstat("thp_split_pmd_failed");
+
+	self->mem = mmap(NULL, self->mmap_size, PROT_READ | PROT_WRITE,
+			 MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	ASSERT_NE(self->mem, MAP_FAILED);
+
+	/* Align to PMD boundary */
+	self->aligned = (void *)(((unsigned long)self->mem + self->pmdsize - 1) &
+				 ~(self->pmdsize - 1));
+}
+
+FIXTURE_TEARDOWN(thp_pmd_split)
+{
+	if (self->mem && self->mem != MAP_FAILED)
+		munmap(self->mem, self->mmap_size);
+}
+
+/*
+ * Partial munmap on THP (zap_pmd_range)
+ *
+ * Tests that partial munmap of a THP correctly splits the PMD.
+ * This exercises zap_pmd_range part of split.
+ */
+TEST_F(thp_pmd_split, partial_munmap)
+{
+	int ret;
+
+	ret = allocate_thp(self->aligned, self->pmdsize);
+	if (ret)
+		SKIP(return, "Failed to allocate THP");
+
+	ret = munmap((char *)self->aligned + self->pagesize, self->pagesize);
+	ASSERT_EQ(ret, 0);
+
+	log_and_check_pmd_split(_metadata, self->split_pmd_before,
+		self->split_pmd_failed_before);
+}
+
+TEST_HARNESS_MAIN
-- 
2.47.3


