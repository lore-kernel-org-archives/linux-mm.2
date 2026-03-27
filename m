Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 961A410AB83C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 02:16:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 078D96B00C5; Thu, 26 Mar 2026 22:16:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 050736B00C7; Thu, 26 Mar 2026 22:16:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED0E76B00C8; Thu, 26 Mar 2026 22:16:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DC3406B00C5
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:16:11 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A34A013C475
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:16:11 +0000 (UTC)
X-FDA: 84590228142.16.CC55F23
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf03.hostedemail.com (Postfix) with ESMTP id ECB0D20005
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:16:09 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BagS9qBG;
	spf=pass (imf03.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774577770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/WGDRJcAglr5vqEySbz/Q1Ok3+d9N6t6n4ui+xS3iNE=;
	b=eDvYatYy9FHw/7xoCT1Ahv1Zbi3u7NBP3MfukiuhgKSInnvcujpUY6B0FnsxCosjHm8IFf
	2Z/U/KF5tIYOmUhTXZKUmE/DKQXxJoTWcDXkGLDyFGRB2lHc1IEO/qH5PjmhEMKe4wG6nf
	rnYe7foMHbhptFKPG3YHT8P21YJCdZ8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BagS9qBG;
	spf=pass (imf03.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774577770; a=rsa-sha256;
	cv=none;
	b=jLQ7LfbDTHzjdU/7C+nv/DTMXrO5+o7rJOalxom01JU8+w1TT7IxulTvSkKO7UeIruVn5O
	03NguhtA4neXOMrA+9SIx6rNSOWy2+tn+WTRp8PdYnDv9yCy4acZdLA4HjvB2+3lczUcvw
	/FypseJldzVshdcAiPFn1uFtN7oNP5U=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774577768;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/WGDRJcAglr5vqEySbz/Q1Ok3+d9N6t6n4ui+xS3iNE=;
	b=BagS9qBGxnoN00/4kt2N0AtuZZ0wHRFPSolgBLBK2CrXSufkJDyuYyYuIvQyVjVaCsdhJK
	wMV0Y9lJGKZkNTSKhtRR7ZUnol1AuKxUSsHZsq9u78XkEixDlTJT5maiQxf53+lpNUY7rn
	n0Eq0GZTwR6gzj24aFATrdiHFUVLBU0=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	Lorenzo Stoakes <ljs@kernel.org>,
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
Subject: [v3 20/24] selftests/mm: add THP PMD split test infrastructure
Date: Thu, 26 Mar 2026 19:09:02 -0700
Message-ID: <20260327021403.214713-21-usama.arif@linux.dev>
In-Reply-To: <20260327021403.214713-1-usama.arif@linux.dev>
References: <20260327021403.214713-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: kjt1m7tzrtbyrw68sfygdrrydzirks96
X-Rspamd-Queue-Id: ECB0D20005
X-Rspamd-Server: rspam09
X-HE-Tag: 1774577769-405221
X-HE-Meta: U2FsdGVkX1+IHHKVjfBGdYVvIomYdx0UktTYNylJ30a9YnUChGlVL+UQ0hLQQYBaQAozztEwZY9h6d/CKTtf1clMnz/l+2BjkgDpLqhnJ0qcyCt1a8LLWyfRxlpvEZJ88I1Afgh1yKTDo1D+hsCxlGFgiw2sCoS9dsgqgvMLieD47EzAX95+Q9Rwk5aJXjpDBJPLB5w2D6E/mwpC+dpOKIQsF0VxrOdz+KZtD1n5s9fOTdNCoy8mKbbjHR06XJ2Gp3Ytc3amvcrTsZ+EZwrtMEVYy9U2UAA0eJyE2Rx8ZdbijsYl5oDo7HJkvG/CFAwAQfslfnNMMjEZC3AqsaMtQ4Wdye7ZkaLlGwB7rra9KDJThx647M14EfVg4tuG1mxHqR1YBeF13fm0JDdzSuTqn3Vz4Z6JY6Dx71sLLMglGRA/7SMsTL41Ea3GbeoFjfaXQsRCwA14l4OZQl+vqk58J7eWEdQ3eZK5ayAWtMBbDRfUFHgoguv779ZCgtUr0ITvWUzewso2SGicqBd2alAA6M3n7l6+ctrr8YgRU/Hgem90n6HytFdljPr+udVBsp0P+eNp3fdT7oVTzKcc+xptsFrNLhU+ImqIamMzFYP5Ly2M0DAV7V8qwIJuYdWBjXDeV1b7G16tD0PCW2oo7vo96c4id5CB0cHqGlwBnmcnNqnXEkiXX0LimY0V+qXGiK0dyWCsPtRmALYtTwr91DnDEVsFtuLZoJPOvKZP0Bk7j9HXl9fsnuajuYLd8UR7lY4wH39apoejI9r/P+rWdqIxeRKzQqnxASGUMOYLf3E95bMsS/kxVapqS9U+yWmd2XLTp/9a0fkp0TASsxnuJ5ad31oYyvo44aW7Kp2UasXWtLwWTJy6IzlCoWv0DQiBvfvN771ohspHmsY44qSIpZ6Q3vyOi3vCd8yD7s6wZcgcXR04/udZIsGOhVTYAM+MwdaaUGwL5Am3LcfNjeCFp8n
 57cCqE+z
 REt8fM+OHJsSLl7Rc3Kd51hqqOU2E/bLPlufvr7nfqdu2a7rvZAjUZuuXO9EFbuhgDryi1r4eiHmRhpVumtP/SNZAwZ6V225FQKuJu6jHJ+M0NwQ3XcDU5ajnm3Q/9x+xy/2q/AcwS+RH89Cva98W+g1av/059g2C0k6QlmTJW1LPFalZMZr63f8Do5aN80ZndP6q6c9rdNceso8=
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
index cd24596cdd27e..4b4610c9b693d 100644
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
2.52.0


