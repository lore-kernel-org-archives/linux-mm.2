Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81F24606A319
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 17:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=BoyshrZt
Received: by kanga.kvack.org (Postfix)
	id 932DC6B030D; Mon, 19 Oct 2026 13:19:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90AD96B030E; Mon, 19 Oct 2026 13:19:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 820196B030F; Mon, 19 Oct 2026 13:19:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5F70B6B030D
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 13:19:46 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0629B120472
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:19:46 +0000 (UTC)
X-FDA: 85340037972.30.FE64263
Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	by imf03.hostedemail.com (Postfix) with ESMTP id 30AB620009
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:19:44 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=BoyshrZt;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 74.125.82.42 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792430384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T2WxJgHgDzroGnytVGNcEvJQJx/gBKIgnv1e37nYxNU=;
	b=qvlg3Qah2tp4O1OUQBA6PPUzs5EzzMCb6mfWqomBN2AoFlQhg8Bu/K/STgBdOlB0rgqcXH
	3rXbztHKhEsXPI/z8aFOzk6UL/YS2WtwfRLzy8SeWUV8xx0sS/V3aSc/lPBTaT+RrOJyAQ
	Spz7KhVgxhqB51gS4cMpj6gcLHxDKQs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=BoyshrZt;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 74.125.82.42 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792430384;
	b=tAEgNKkyMFG+/69hJW/BoqhxTcpTc5LKwTPu44cAsTjLzr9Wmh+nRXHO4V15z8kzxZI+8d
	WI8+iJl0iKpVGVVfHyt4Lx87Lou/wIDxUVp+kzL6+eRDt2osl6I4Ng9YSGM+2WCZsY2tnN
	/cysF0Hb8dgHl0nmNZO+h9geiWAk/2s=
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-15354aa70e8so1876483c88.1
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 10:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792430383; x=1793035183; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=T2WxJgHgDzroGnytVGNcEvJQJx/gBKIgnv1e37nYxNU=;
        b=BoyshrZtNor5mwECfs6KDt3XWoU26u4PZ5d7nRNPxKRN/MrYTW3oOy1iTpGJFc6NGo
         Up4RDnA1cTH4VnKgdYe+mx+yya2scGKUpUsqVsxJcZU5GSXGL+cCvLd0sUd8vq+yEtIp
         UyVALB1HtCpgFICcTxlcNaUXbtaAiPUP4M8C+2eiZCY43gUXnmq+ZwvUQS/ouA3+Gepn
         1ofUNQdGmhOK2XmTN+3QxgNUhUt8jKcohoEZq0MmsREFFIdHtfEClTIMGAiRj/lV7ZoK
         1gH4hW4hThTLJLKUH7j5GpLoMsKlhQ/MMQk1Ksk5+JYI0kMxv8PdkPV8zObHAkSxXhj6
         kYHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792430383; x=1793035183;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=T2WxJgHgDzroGnytVGNcEvJQJx/gBKIgnv1e37nYxNU=;
        b=OmbDXbU2nyfisXFdXkGEjRFcbJ4CmzZXyx9PL5swKqyzoJy780GYAdGbMshYU/Clvx
         R3fX69Nfy0cbd2wkMWYDI12YTcy7xm1TXq75Cwxc4bN/RI5bkedd805vy8lyi/SjoAxe
         CY0wWRAG8hWntT61lSYphVtGsn7zSZUy2L0b22WNZlq4h2mL8oxCAe8l061rjcuvRLw5
         5N2tPjvshDlYMGUI3Ms+TGCXg8f68V5sbf6ofQezVc24C8QpZrHaqXoSqii5+/gDYHza
         82nkPO1MLFyedgAiipZ7iiKfa/I6kIukgQw6q8IqycG/mA3yZSaTnInZ5zQRh+FTTL/D
         VAjg==
X-Gm-Message-State: AFq9FYKTF3AfVY+YX5Z7UmqIgX4UZqshZyVHNhq9gkvZZ297LTu2qaMY
	ZvcoRUUtDFCi0kOA2tCVKf+xsrd/dFtUEAoKs8wZaI2HxFzdPCpuYh2ULbIkzlU5MLLrkMltehB
	fi/eV08I=
X-Gm-Gg: AYBFou0aSd04MCwP9habYtsk5H14VdQ/uTzT01Jp0bAfxPOu9cqq4/yP5bjTkeD8iUK
	LOD6o2NIki3TZqW4kXx7wgn+lbFfmkfP1+EralF5eHA9vCF4Qic+cFUw+QiRPeivC4Bfg8IA88l
	+sbFilQpFKMo+Oyc73v5ogUIFd7DocFU1WExxyU7H3dWpSGRpWOkRSJ6f2Kppn6GG5EEcndIQqX
	AF82viZLRUDC7sV2HGPzMwibUfUv6VpIxoOMfEYyJG7CiP5wJv9TQXrrQUBP702GeRam5axrogA
	fiSnb6wgvvq9+QROW/qGsq/4VQHzIL1LvfGf8fDmGsiysv/xDBACVaJZyTLBHal04oUFYhYYQ2A
	YkAqNCqt8q4aAkCP8m6TuSqmVVeVQB9+TtLbWURmI4uWhFKZi8p3+C+VhYUhLhypCHwOZkbD+mn
	MYkmKiW1S3Mw4BLa6pCe7J5CgVjn110ALk3mubbzQrvZ+jRSqlDOAMxFgB9Gifurac4aBgDIEfS
	Pl5HAlwfzF4wsx7ZkFv+zV8+5wfOvV+HLIrTatkEqNIvHEnWheznRQCGb5h
X-Received: by 2002:a05:6214:53c7:b0:91b:53e5:9263 with SMTP id 6a1803df08f44-91bdf0f40c2mr157703266d6.21.1792429930552;
        Mon, 19 Oct 2026 10:12:10 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c040d4cedsm723116d6.34.2026.10.19.10.12.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 10:12:10 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-kselftest@vger.kernel.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org
Subject: [PATCH v3 1/7] selftests/mm: add MADV_COLD and MADV_PAGEOUT contract tests
Date: Mon, 19 Oct 2026 13:12:00 -0400
Message-ID: <20261019171206.3331374-2-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261019171206.3331374-1-gourry@gourry.net>
References: <20261019171206.3331374-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 30AB620009
X-Stat-Signature: xdjpbmr646yr5j5rjnd5sukcxi4d7a6c
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792430384-607844
X-HE-Meta: U2FsdGVkX1/o0719nMaFaJZxcg2CbdGdgENzCayfHCVG4wgW/AawoyxFz6Ejm0hfdMQsKFOVGtBL72mxcMOu4PVb/kZyN1iv/MP2hvmF5CoIN1mHNpCqrnpH3fo6XxTyViJGKCuq9Wa+PVydd4xnkoGEcgY5GJdwLD/zC9Kr8Q3/UP9fDhpoFAk4vFp4o21YmCkx4KyCIjnDLFZP2U2Kr9vKTD+lqnX0uxYZIT8IMoDVH1eQm/dVfOhZ1JUE7xX91h4m8wq4iGst2RaMRb07u52aPXdqj4sbjdVoSvehqTSxV41/tMcT+OL4Ld29zU/vWdOECZZXwGbThOIGVSXXdIDRMjW5yOvi30lN9u3aGk8BQ1aqfrTT8JBJbvp56oONxcgmnQZu+lAqD8M5JtwqZjIm512Gzjpi6KtgHMDb3aoed6FurgmnXL64yEpwz+61nS2zK8xqKx+ua/hWd8bBQRqTjrj3wzJbvVGanHbAeNcMQqT5bLuUAvQ1WD8FhUNey5wa+Jq24GGbGF27yQJdEAiEe5Ok99ojoNBXspdMe3leRwmaW/+g/DqIDBzNt9B6ObMGrj0cbs2HatKPvOzo8kxoSDZXSgyLLzvPOTNa3fOHwi+dT4zzo4kAsSjbguDEG11DDNOry4GMHFXG7waqCx42Rjut989XMudCoIUlP8bT1WiioOowZceuhrmnxEoxa3AlWgFBlxdcd5ty7XwqYZ+R2TbioRAVBZrHjzJTwUa9VUdH+l0lbbhh0fYQHyZ0oKZr+Ph7Cf9b/AkHuq8wyKN4WFe32sL5U5pkywkknGqHcRb1SUGYyd5NsjH9iniwjYMVrPn/UJ1Tps/i9oG1teojb7+nFleze1tY9lPn9v0I7MOgU9xv7yaZpC1fKQipV/sUyefkUuRz0xD6q5gB5Qd93IE36NPQdsgMj55bPoUVyalqVytTrAhn7Y7y4kO2veW7Qm6YfG8qlRo2im9
 bfPTxmgz
 2yraJy2ilHNSwyITfG/FxUXzY3K/8LcIspAVAe3mZCTGGsMoTkJ0IhEyXIMpw1zYHSV65gDz1zxbbrRnq3d7bStOlRHqB4SvILO/LwGMV5Bs6Ir/NOnT/wCWdyJz+xx4N7/s93/gT9lQyZSw1jUplCaAr6DUyiiYzGmptrIwKdPk6n7sxL3K4Mn8UzPd+3W25JABVfGXcqIaruiWFoUY2PHaktVLfrzYBhzIFrG0KHe61JTmxfd5N3I6Efe6rIf15vwZnYJJjrLaYEk8u8MPGcU1pf1CPZGK82nXnQTjJcs/uXG1ZilBEIqt9kI84tDAoWeR16NNBSsAdsKYNXtcMzseVuatA+J4xu0q1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

MADV_COLD and MADV_PAGEOUT share a page-table walker covering ordinary
PTEs, PTE-mapped large folios and huge PMDs. Existing selftests use
MADV_PAGEOUT mostly to swap memory out for other tests, and check only
special mappings (PFNMAP, guard regions, droppable memory), not the
walker's range, folio and permission handling.

Add a kselftest harness test for both hints, starting with the most basic
behavior userspace relies on: neither hint populates a PTE hole or faults
a swapped page back in, and neither may be applied to a locked VMA.

Before running the tests, pin the process to the CPU it starts on,
so that the LRU batch MADV_COLD and MADV_PAGEOUT drain holds the
folios a test faulted in.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
v3: Dropped Sarthak's Reviewed-by from v2 1/8 and 2/8, which are folded
here, since this patch now adds main() with the CPU pinning and the
one-time reclaim check, and the swapped-page tests fail rather than skip.
---
 tools/testing/selftests/mm/Makefile           |   2 +
 .../selftests/mm/ksft_madv_cold_pageout.sh    |   4 +
 .../testing/selftests/mm/madv_cold_pageout.c  | 209 ++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh     |   5 +
 4 files changed, 220 insertions(+)
 create mode 100755 tools/testing/selftests/mm/ksft_madv_cold_pageout.sh
 create mode 100644 tools/testing/selftests/mm/madv_cold_pageout.c

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index beacc0f87304..c7fc20c153b8 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -68,6 +68,7 @@ TEST_GEN_FILES += hugetlb-read-hwpoison
 TEST_GEN_FILES += hugetlb-shm
 TEST_GEN_FILES += hugetlb-soft-offline
 TEST_GEN_FILES += khugepaged
+TEST_GEN_FILES += madv_cold_pageout
 TEST_GEN_FILES += madv_populate
 TEST_GEN_FILES += map_fixed_noreplace
 TEST_GEN_FILES += map_populate
@@ -154,6 +155,7 @@ TEST_PROGS += ksft_kmemleak_confirm.sh
 TEST_PROGS += ksft_kmemleak_dedup.sh
 TEST_PROGS += ksft_ksm.sh
 TEST_PROGS += ksft_ksm_numa.sh
+TEST_PROGS += ksft_madv_cold_pageout.sh
 TEST_PROGS += ksft_madv_guard.sh
 TEST_PROGS += ksft_madv_populate.sh
 TEST_PROGS += ksft_memfd_secret.sh
diff --git a/tools/testing/selftests/mm/ksft_madv_cold_pageout.sh b/tools/testing/selftests/mm/ksft_madv_cold_pageout.sh
new file mode 100755
index 000000000000..502d3fb387aa
--- /dev/null
+++ b/tools/testing/selftests/mm/ksft_madv_cold_pageout.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t madv_cold_pageout
diff --git a/tools/testing/selftests/mm/madv_cold_pageout.c b/tools/testing/selftests/mm/madv_cold_pageout.c
new file mode 100644
index 000000000000..5d451d409937
--- /dev/null
+++ b/tools/testing/selftests/mm/madv_cold_pageout.c
@@ -0,0 +1,209 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * MADV_COLD and MADV_PAGEOUT tests.
+ */
+#define _GNU_SOURCE
+#include <errno.h>
+#include <fcntl.h>
+#include <sched.h>
+#include <stdbool.h>
+#include <sys/mman.h>
+#include <unistd.h>
+
+#include "kselftest_harness.h"
+#include "vm_util.h"
+
+/* Reclaim can fail transiently, so retry for up to a second. */
+#define PAGEOUT_RETRIES 100
+
+static size_t page_size;
+/* Whether MADV_PAGEOUT can swap out anonymous memory, see main(). */
+static bool can_swap;
+
+/*
+ * Keep this task on one CPU, so that draining that CPU's LRU batches drains
+ * the folios this task faulted in.
+ */
+static void pin_to_current_cpu(void)
+{
+	int cpu = sched_getcpu();
+	cpu_set_t *mask;
+	size_t size;
+
+	if (cpu < 0)
+		ksft_exit_fail_perror("sched_getcpu");
+	/* CPU numbers can exceed CPU_SETSIZE, so size the mask to fit. */
+	mask = CPU_ALLOC(cpu + 1);
+	if (!mask)
+		ksft_exit_fail_perror("CPU_ALLOC");
+	size = CPU_ALLOC_SIZE(cpu + 1);
+	CPU_ZERO_S(size, mask);
+	CPU_SET_S(cpu, size, mask);
+	if (sched_setaffinity(0, size, mask))
+		ksft_exit_fail_perror("sched_setaffinity");
+	CPU_FREE(mask);
+}
+
+FIXTURE(madv_cold_pageout)
+{
+	int pagemap_fd;
+};
+
+FIXTURE_SETUP(madv_cold_pageout)
+{
+	self->pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
+	ASSERT_GE(self->pagemap_fd, 0);
+}
+
+FIXTURE_TEARDOWN(madv_cold_pageout)
+{
+	close(self->pagemap_fd);
+}
+
+/* Page out the range until its first page is swapped, or madvise() fails. */
+static bool pageout_until_swapped(char *mapping, size_t size, int pagemap_fd)
+{
+	int retry;
+
+	for (retry = 0; retry < PAGEOUT_RETRIES; retry++) {
+		if (madvise(mapping, size, MADV_PAGEOUT))
+			return false;
+		if (pagemap_is_swapped(pagemap_fd, mapping))
+			return true;
+		usleep(10000);
+	}
+
+	return false;
+}
+
+/*
+ * Both hints are best effort, so these tests check what userspace can rely
+ * on: which mappings are accepted, which pages must never be reclaimed, and
+ * that neither hint changes memory contents or populates the range. main()
+ * checks once whether reclaim works at all. A test that needs a page to be
+ * reclaimed skips if it does not, and fails if the page is then not reclaimed.
+ */
+
+/* Neither hint may populate a hole between two populated pages. */
+static void check_skips_pte_hole(struct __test_metadata *_metadata,
+				 int pagemap_fd, int advice)
+{
+	char *mapping;
+
+	mapping = mmap(NULL, 3 * page_size, PROT_READ | PROT_WRITE,
+		       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	ASSERT_NE(mapping, MAP_FAILED);
+	/*
+	 * Keep a large folio from covering the hole. Without THP there are no
+	 * large anonymous folios, and this fails harmlessly.
+	 */
+	madvise(mapping, 3 * page_size, MADV_NOHUGEPAGE);
+	mapping[0] = 1;
+	mapping[2 * page_size] = 1;
+	ASSERT_FALSE(pagemap_is_populated(pagemap_fd, mapping + page_size));
+
+	ASSERT_EQ(madvise(mapping, 3 * page_size, advice), 0);
+	ASSERT_FALSE(pagemap_is_populated(pagemap_fd, mapping + page_size));
+	ASSERT_EQ(mapping[0], 1);
+	ASSERT_EQ(mapping[2 * page_size], 1);
+
+	ASSERT_EQ(munmap(mapping, 3 * page_size), 0);
+}
+
+TEST_F(madv_cold_pageout, cold_skips_pte_hole)
+{
+	check_skips_pte_hole(_metadata, self->pagemap_fd, MADV_COLD);
+}
+
+TEST_F(madv_cold_pageout, pageout_skips_pte_hole)
+{
+	check_skips_pte_hole(_metadata, self->pagemap_fd, MADV_PAGEOUT);
+}
+
+/* Neither hint may be applied to locked memory. */
+TEST_F(madv_cold_pageout, locked_vma_is_rejected)
+{
+	char *mapping;
+
+	mapping = mmap(NULL, page_size, PROT_READ | PROT_WRITE,
+		       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	ASSERT_NE(mapping, MAP_FAILED);
+	mapping[0] = 1;
+	if (mlock(mapping, page_size))
+		SKIP(return, "could not lock a page");
+
+	ASSERT_EQ(madvise(mapping, page_size, MADV_COLD), -1);
+	ASSERT_EQ(errno, EINVAL);
+	ASSERT_EQ(madvise(mapping, page_size, MADV_PAGEOUT), -1);
+	ASSERT_EQ(errno, EINVAL);
+	ASSERT_EQ(mapping[0], 1);
+
+	ASSERT_EQ(munmap(mapping, page_size), 0);
+}
+
+/* Neither hint may fault a swapped page back in. */
+static void check_skips_swapped_pte(struct __test_metadata *_metadata,
+				    int pagemap_fd, int advice)
+{
+	char *mapping;
+
+	if (!can_swap)
+		SKIP(return, "MADV_PAGEOUT cannot swap");
+	mapping = mmap(NULL, page_size, PROT_READ | PROT_WRITE,
+		       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	ASSERT_NE(mapping, MAP_FAILED);
+	mapping[0] = 1;
+	ASSERT_TRUE(pageout_until_swapped(mapping, page_size, pagemap_fd));
+
+	ASSERT_EQ(madvise(mapping, page_size, advice), 0);
+	ASSERT_TRUE(pagemap_is_swapped(pagemap_fd, mapping));
+	ASSERT_EQ(mapping[0], 1);
+
+	ASSERT_EQ(munmap(mapping, page_size), 0);
+}
+
+TEST_F(madv_cold_pageout, cold_skips_swapped_pte)
+{
+	check_skips_swapped_pte(_metadata, self->pagemap_fd, MADV_COLD);
+}
+
+TEST_F(madv_cold_pageout, pageout_skips_swapped_pte)
+{
+	check_skips_swapped_pte(_metadata, self->pagemap_fd, MADV_PAGEOUT);
+}
+
+/* Swap out an anonymous page, to see whether swap works at all. */
+static bool probe_swap(int pagemap_fd)
+{
+	bool swapped;
+	char *page;
+
+	page = mmap(NULL, page_size, PROT_READ | PROT_WRITE,
+		    MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (page == MAP_FAILED)
+		ksft_exit_fail_perror("mmap");
+	page[0] = 1;
+	swapped = pageout_until_swapped(page, page_size, pagemap_fd);
+	munmap(page, page_size);
+
+	return swapped;
+}
+
+int main(int argc, char **argv)
+{
+	int pagemap_fd;
+
+	page_size = getpagesize();
+	/* The harness forks each test, which inherits this. */
+	pin_to_current_cpu();
+
+	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
+	if (pagemap_fd < 0)
+		ksft_exit_fail_perror("open /proc/self/pagemap");
+	can_swap = probe_swap(pagemap_fd);
+	if (!can_swap)
+		ksft_print_msg("MADV_PAGEOUT cannot swap\n");
+	close(pagemap_fd);
+
+	return test_harness_run(argc, argv);
+}
diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index a1b45a3dedae..782b3ae4b2d2 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -53,6 +53,8 @@ separated by spaces:
 	test madvise(2) MADV_GUARD_INSTALL and MADV_GUARD_REMOVE options
 - madv_populate
 	test memadvise(2) MADV_POPULATE_{READ,WRITE} options
+- madv_cold_pageout
+	test madvise(2) MADV_COLD and MADV_PAGEOUT
 - memfd_secret
 	test memfd_secret(2)
 - process_mrelease
@@ -330,6 +332,9 @@ CATEGORY="madv_guard" run_test ./guard-regions
 # MADV_POPULATE_READ and MADV_POPULATE_WRITE tests
 CATEGORY="madv_populate" run_test ./madv_populate
 
+# MADV_COLD and MADV_PAGEOUT tests
+CATEGORY="madv_cold_pageout" run_test ./madv_cold_pageout
+
 # PROCESS_MADV test
 CATEGORY="process_madv" run_test ./process_madv
 
-- 
2.56.0


