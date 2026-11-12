Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E44F606A337
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 09:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=r6dYwlmK
Received: by kanga.kvack.org (Postfix)
	id 9ABF46B05B7; Thu, 12 Nov 2026 04:03:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95C096B05B8; Thu, 12 Nov 2026 04:03:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84C3F6B05B9; Thu, 12 Nov 2026 04:03:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6125E6B05B7
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 04:03:19 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EA5EBA80D9
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:03:18 +0000 (UTC)
X-FDA: 85425878076.15.58E9C5A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7E02E8000A
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:03:15 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=r6dYwlmK;
	spf=pass (imf30.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794474197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6xKG2mafUAXk8nSXldq0Ma7KfZtCeG93s827yZnp8+Y=;
	b=L8px1nCfHq8OCakhyE0jNovrMczYutZxUmthHV5D7XZZ72tmpQonZYYX1XRVCu3mlL5Ees
	ukA0xDZqxrU3aOSwL/yQM815fvFAGvUecBy+6Il2sN+9z/Z5IsTkt5IDDHV3j6x1LK5dhU
	O5sZlzwHw7GqSo9GwJ0OEb78LjF14ok=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=r6dYwlmK;
	spf=pass (imf30.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794474197;
	b=x3HbRL6WWARmdoZiweG0tdLYZswEO1n0RkjOGf2aR6HIQFz8Lg+S2LhW+N1yMtR8OCHQzi
	E9Lglq1+fIFlCJJYOrCeVtK4u+ATQbxZcpRtmDV6vY5Yh2qeFl7Jce6Un92wEuxRWp3i0+
	L0XhqCIWEcBB06aevIqYWsufTdXPY7I=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6E4BC339;
	Thu, 12 Nov 2026 01:03:11 -0800 (PST)
Received: from a081061.arm.com (unknown [10.163.169.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id AA2B03F632;
	Thu, 12 Nov 2026 01:03:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794474194; bh=DC5Y/8KunHuhss/wymw9i7JWU1wG2xnD9ghfIKbOJko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r6dYwlmKgLlbUxPCduhg5Oi7b1ylk0pDfdAOTnsZNQFkAlzRB2ObxVqP7OIZtoFQR
	 qS2KH9Hy44FTYT8JTKgHZvy8n3uB3OOtHKYDUXuR38wj5DNAtsYzCasFsnPVbm6wwj
	 Fo6u7lnH9yXE64T7rtAGK2fdeAN/lqwEb150Hsks=
From: Sarthak Sharma <sarthak.sharma@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH 1/4] selftests/mm: remove transhuge-stress
Date: Thu, 12 Nov 2026 14:32:47 +0530
Message-ID: <20261112090250.334344-2-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261112090250.334344-1-sarthak.sharma@arm.com>
References: <20261112090250.334344-1-sarthak.sharma@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: tk11nyis1kbxro4tze6kkqb8zp8ad66r
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 7E02E8000A
X-HE-Tag: 1794474195-683768
X-HE-Meta: U2FsdGVkX195nFmAeMTeMeJVo8zp0HgWXWjqkaNw0g6uc67hwfEFYyW2z2xwxvwKtpj7ylzJBg71swW7b0CVYa21LTjm6E3swbXgBusvD7xPreVa+XXzgaZhGPyAhSU3PmCoAmrvl60WYKEJC+LAf6W8+pq9IXEYExoixSgwODCRJUp0z2gmlM1C4KNcq45WHOIGS+iIm8t/9TACZjTFR3lNESswnN94s1i/wY4MO6TZcoFKWg2SDrKRaWAyb9mtoVNMXClDXg5hLh4frumNJw5TsvHrrheLrSbLCVJxZ5vsH/flDYvSTedxYz51Idxt9iboRWXTrYBFWTtrbYekh6+rqtWqE4f/FR0kXKV+GumOiFGM86dWy41dDNOqe7ULtY9HRB7XfXl8XmuZRRM8/hMxQ/cuCCkL3ojJqTbVNIhXb5nlZ/IuLVNFLuJwaAW1Nnnj0VjSrtGOw6Jq9dXzOR952ZwcKQwjw4DYeER6eiH+/17uyNmVSPzyCGr14wHARDx8SbE3dscd//Q+Xl1gKFYGsKml1UrTudIWCskPmnU0AXZWVu1LZcEp+tsyfG49e6C3YeMAZA31YnaI5VEUeKfFqbROOMiMkKn/I+7Hg2Waaja03c3yXAgeE7ow0Ln2RmLFKEQhHjAYA0vQDGEgcP6u1KbubNmb2I0D7gVjZns+wZ/1hZ3XzEV66jv10CaXtsUYjhtcJT4QzJVwDQeKjPoLtvI/I3Upy2wvi5yjt6ZbfZBajLpSOCgTa8Px4EwKHmgfSHxQTVhHi/6UcCMnm9fQMoVPEgKZLIf0ZJ3yhW4RXyXGrITsveTChTegoi7sZpUwrH1melcr8PtkP0Us8kItmTuX8JK4XVws/dgzee6tKnOACZ04CH/M8FbDRUG7KY3mX0dszG/cNBiYkgFYXxUpo02bXbeFdn1e8pgkxcmXKS9a50gswxOOGs3a2Jmer2ODM3Ui/D5LkFOlC7S
 /h96GCTG
 yMkTMmi8N5a4hvWU1fmz86mFEBkuM5Gx/ilSBCtkYmDVsv1YI7MYcwPTfLCjI2UX7N62sA35Cm+/vgQRfjGPDoePkRF77JmTMI99pZrWH+uZJpdrOdoOkBrxIhA79U6gjUmWCSA5bJVQ8J8JLFYOiePafbM4me+w6yy0McFGX8wH7eDaky4xa4BY+/vVEGbK6i5IoQxM4LXOhHaDM9eQIqjNHTqWQ141y6AVV1DqL8Qe0WZZteY/BiorPV0TMz/+P3oLFcwALSKGgOnAjfbyMjiiZeEAnM0PDzsKG0e9dhIM4/DWNr7Jq1jIuNDFXUzrvca/obzyfN/x9LQNjFfAwAju8dfnfxISpMYsO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

transhuge-stress currently behaves like a stressor which takes arguments
like duration and size. By default, it tries to allocate and split a
THP at every hugepage sized offset in a range equal to RAM. It counts
successful and failed allocations and prints them. The test passes if
the specified duration has elapsed and fails only if a setup or system
call fails.

This is not how a selftest is supposed to behave. Remove
transhuge-stress from selftests/mm and remove its references from
Makefile, run_vmtests.sh and MAINTAINERS. A subsequent patch adds a
selftest for THP compaction.

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 MAINTAINERS                                   |   1 -
 tools/testing/selftests/mm/Makefile           |   1 -
 tools/testing/selftests/mm/run_vmtests.sh     |   2 -
 tools/testing/selftests/mm/transhuge-stress.c | 146 ------------------
 4 files changed, 150 deletions(-)
 delete mode 100644 tools/testing/selftests/mm/transhuge-stress.c

diff --git a/MAINTAINERS b/MAINTAINERS
index ce05a3253baa..4d74ad879ecf 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17946,7 +17946,6 @@ F:	mm/mm_slot.h
 F:	tools/mm/thpmaps
 F:	tools/testing/selftests/mm/khugepaged.c
 F:	tools/testing/selftests/mm/split_huge_page_test.c
-F:	tools/testing/selftests/mm/transhuge-stress.c
 
 MEMORY MANAGEMENT - USERFAULTFD
 M:	Andrew Morton <akpm@linux-foundation.org>
diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index 675ec57d47de..06d3d0350a9a 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -90,7 +90,6 @@ TEST_GEN_FILES += pfnmap
 TEST_GEN_FILES += process_madv
 TEST_GEN_FILES += prctl_thp_disable
 TEST_GEN_FILES += thuge-gen
-TEST_GEN_FILES += transhuge-stress
 TEST_GEN_FILES += uffd-stress
 TEST_GEN_FILES += uffd-unit-tests
 TEST_GEN_FILES += uffd-wp-mremap
diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index 973cb715b326..cb5c7cccb585 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -448,8 +448,6 @@ if [ -n "${MOUNTED_XFS}" ]; then
     rm -f ${XFS_IMG}
 fi
 
-CATEGORY="thp" run_test ./transhuge-stress -d 20
-
 CATEGORY="thp" run_test ./folio_split_race_test
 
 CATEGORY="migration" run_test ./migration
diff --git a/tools/testing/selftests/mm/transhuge-stress.c b/tools/testing/selftests/mm/transhuge-stress.c
deleted file mode 100644
index ad2831c864dc..000000000000
--- a/tools/testing/selftests/mm/transhuge-stress.c
+++ /dev/null
@@ -1,146 +0,0 @@
-/*
- * Stress test for transparent huge pages, memory compaction and migration.
- *
- * Authors: Konstantin Khlebnikov <koct9i@gmail.com>
- *
- * This is free and unencumbered software released into the public domain.
- */
-
-#include <stdlib.h>
-#include <stdio.h>
-#include <stdint.h>
-#include <err.h>
-#include <time.h>
-#include <unistd.h>
-#include <fcntl.h>
-#include <string.h>
-#include <sys/mman.h>
-#include "vm_util.h"
-#include "kselftest.h"
-
-int backing_fd = -1;
-int mmap_flags = MAP_ANONYMOUS | MAP_NORESERVE | MAP_PRIVATE;
-#define PROT_RW (PROT_READ | PROT_WRITE)
-
-int main(int argc, char **argv)
-{
-	size_t ram, len;
-	void *ptr, *p;
-	struct timespec start, a, b;
-	int i = 0;
-	char *name = NULL;
-	double s;
-	uint8_t *map;
-	size_t map_len;
-	int pagemap_fd;
-	int duration = 0;
-	const uint64_t hpage_size = pmd_psize();
-	const uint64_t hpage_shift = pmd_pshift();
-
-	ksft_print_header();
-
-	if (!thp_is_enabled())
-		ksft_exit_skip("Transparent Hugepages not available\n");
-
-	if (!hpage_size || !hpage_shift)
-		ksft_exit_fail_msg("reading hpage_size failed\n");
-
-	ram = sysconf(_SC_PHYS_PAGES);
-	if (ram > SIZE_MAX / psize() / 4)
-		ram = SIZE_MAX / 4;
-	else
-		ram *= psize();
-	len = ram;
-
-	while (++i < argc) {
-		if (!strcmp(argv[i], "-h"))
-			ksft_exit_fail_msg("usage: %s [-f <filename>] [-d <duration>] [size in MiB]\n",
-					   argv[0]);
-		else if (!strcmp(argv[i], "-f"))
-			name = argv[++i];
-		else if (!strcmp(argv[i], "-d"))
-			duration = atoi(argv[++i]);
-		else
-			len = atoll(argv[i]) << 20;
-	}
-
-	ksft_set_plan(1);
-
-	if (name) {
-		backing_fd = open(name, O_RDWR);
-		if (backing_fd == -1)
-			ksft_exit_fail_msg("open %s\n", name);
-		mmap_flags = MAP_SHARED;
-	}
-
-	warnx("allocate %zd transhuge pages, using %zd MiB virtual memory"
-	      " and %zd MiB of ram", len >> hpage_shift, len >> 20,
-	      ram >> (20 + hpage_shift - pshift() - 1));
-
-	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
-	if (pagemap_fd < 0)
-		ksft_exit_fail_msg("open pagemap\n");
-
-	len -= len % hpage_size;
-	ptr = mmap(NULL, len + hpage_size, PROT_RW, mmap_flags, backing_fd, 0);
-	if (ptr == MAP_FAILED)
-		ksft_exit_fail_msg("initial mmap");
-	ptr += hpage_size - (uintptr_t)ptr % hpage_size;
-
-	if (madvise(ptr, len, MADV_HUGEPAGE))
-		ksft_exit_fail_msg("MADV_HUGEPAGE");
-
-	map_len = ram >> (hpage_shift - 1);
-	map = malloc(map_len);
-	if (!map)
-		ksft_exit_fail_msg("map malloc\n");
-
-	clock_gettime(CLOCK_MONOTONIC, &start);
-
-	while (1) {
-		int nr_succeed = 0, nr_failed = 0, nr_pages = 0;
-
-		memset(map, 0, map_len);
-
-		clock_gettime(CLOCK_MONOTONIC, &a);
-		for (p = ptr; p < ptr + len; p += hpage_size) {
-			int64_t pfn;
-
-			pfn = allocate_transhuge(p, pagemap_fd);
-
-			if (pfn < 0) {
-				nr_failed++;
-			} else {
-				size_t idx = pfn >> (hpage_shift - pshift());
-
-				nr_succeed++;
-				if (idx >= map_len) {
-					map = realloc(map, idx + 1);
-					if (!map)
-						ksft_exit_fail_msg("map realloc\n");
-					memset(map + map_len, 0, idx + 1 - map_len);
-					map_len = idx + 1;
-				}
-				if (!map[idx])
-					nr_pages++;
-				map[idx] = 1;
-			}
-
-			/* split transhuge page, keep last page */
-			if (madvise(p, hpage_size - psize(), MADV_DONTNEED))
-				ksft_exit_fail_msg("MADV_DONTNEED");
-		}
-		clock_gettime(CLOCK_MONOTONIC, &b);
-		s = b.tv_sec - a.tv_sec + (b.tv_nsec - a.tv_nsec) / 1000000000.;
-
-		ksft_print_msg("%.3f s/loop, %.3f ms/page, %10.3f MiB/s\t"
-			       "%4d succeed, %4d failed, %4d different pages\n",
-			       s, s * 1000 / (len >> hpage_shift), len / s / (1 << 20),
-			       nr_succeed, nr_failed, nr_pages);
-
-		if (duration > 0 && b.tv_sec - start.tv_sec >= duration) {
-			ksft_test_result_pass("Completed\n");
-			ksft_finished();
-		}
-	}
-}
-- 
2.53.0


