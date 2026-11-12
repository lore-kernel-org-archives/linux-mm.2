Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD024606A8B4
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 09:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=lH2D+Z8d
Received: by kanga.kvack.org (Postfix)
	id CB9D36B05C4; Thu, 12 Nov 2026 04:03:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6A3C6B05C5; Thu, 12 Nov 2026 04:03:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B34586B05C6; Thu, 12 Nov 2026 04:03:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 83F8F6B05C4
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 04:03:44 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 156E21C3CFF
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:03:44 +0000 (UTC)
X-FDA: 85425879168.16.2068A99
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf31.hostedemail.com (Postfix) with ESMTP id 5EE432000B
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:03:42 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=lH2D+Z8d;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf31.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794474222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bfFED5wr1Gi/u3g1VjyKYj5gqmOAy1fX/7Q8JL8oA44=;
	b=ujVq4NWk9mhDJa0kGAaltR9saKWtaOdICBrzbvH8xbMgBsvjqnSLJIcXYQIU5Ep4pda7Yv
	4h3Bj3PToWODymgKTShx+0OJO28xf5ohU1M0UrRAPNyU7JXAdACIUVKz4wHIiaJSeUjOEv
	iZtdl9CQciPASDc8p9ob5wvNXQO1ydY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=lH2D+Z8d;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf31.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794474222;
	b=ATLCXMu1Cl/dETAnINEGP5okS1Cd80x2EB5QU40v0eCFZhl164zf8A0sgzjLtkWGNgnuk8
	tPaxsE5yLJwU3ECa323n9EHmWEUOpyuZTQFI/N+pnBpruMA+YpmJ3CUBdXFdYKC+7nXguW
	WzDTOTcukhJcJlWG5LsgL2OjWq+s3mQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6F7E1339;
	Thu, 12 Nov 2026 01:03:38 -0800 (PST)
Received: from a081061.arm.com (unknown [10.163.169.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 2FA103F632;
	Thu, 12 Nov 2026 01:03:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794474221; bh=5iAvOQTpt9gk5MMxQSEmlDpVMvlgNN9go7ByTGre++Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lH2D+Z8dlONG/cWPX5ssVxZ8T5K2DcY5baTrSphflvBNku80FH69PmmoTmKhYrrSc
	 HRgzHRFwmboGH3HDJxNTD2+SGG3/85MjQ9yZCQ3AxcXd1Fvn+kQawMfkLxo2zSfIfV
	 H1JYzh/CZ74TK7bK8BFv3SC53pmf04iwfBlEFnu4=
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
Subject: [PATCH 4/4] selftests/mm: add a THP compaction selftest
Date: Thu, 12 Nov 2026 14:32:50 +0530
Message-ID: <20261112090250.334344-5-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261112090250.334344-1-sarthak.sharma@arm.com>
References: <20261112090250.334344-1-sarthak.sharma@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5EE432000B
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: m1btptow6agdxwum586pk3q6u6tkurjd
X-HE-Tag: 1794474222-189684
X-HE-Meta: U2FsdGVkX18cSJzUtnWfCbRXCErN7XvJAueQT7Wuh5oSlXGFjUJBA/TzrvIhZnOF4PYnRDhUcKZHOxxKtMaWYOlY9vmUN7Yyl1PWxY2ueIJtFUje8qHvfmxh/Ky9T8ZiautvS+jMYftCHwBHveejtLZv/s9HeZx+4yZZiY0B969TMHta1IYgoYOWYIeh5TvtlpPIZ3BEiU32xsypMDrSGn4/kqmYI1h1NU42kfSAEgf9xEZqbAB6y2GWTXMK4pSJMaqLQzv0FNUrUK2QbTq4bj0s/aGpnY5yMo0Pew7xmJhDoGq6Et92w3EM3Am2OVys3o9Wz/xvflkfdkyM8usGBkJWoC9oB7jkjYxvop6aa9olaQ0+ta4CkzP3xCpJdoyDeIrN+v1DTlxw1VNTaQU7eMXgp/kgyxYUEhyDhyim5ljlarYOnpYMAjetzT5DOiOpUED/FUx/IocDK2rp5JEJr7vTD14wIJNsvFhtRrsI4u99bwYrMUEnHnjO9gv5AUc7LgKNzBO0Z1hw6PXh9AidmB2GGArLY1INrEoL42Ojth+c1CxWCzckMEcqXSkvZeFzfc9ww3jmY9ZnJ5oYRb0bByjU9S8SEy0cAol3HrvMg4CHIMOwp7vT1X0AEgDresO/xI34Hu6eB4wJJqpdZ2eN/Q9f4A3vZXTpx7OpfyJ7Mq+Gv0aVfRPsQpb5tNQOKxNhMhtdaGWqM7IT6pQmisfQ8hLc00/BJB7i6Zb72nbcMAz75MTOLjltPC9wkzQJM/U+kHPQv45tRR1BGn+/gMU52x40OnIptb8SHD0kqaVUunKS/QkwHYOidRW1AWi048rLCMFrIRoSdvDErhnYrXLzlas2WeYbJDj5gQHgF3di5GD3AWUgcunNAjF8kPQozmkL0JlKjSwQatSGYLUH1tyweL+UmUe4/qpw2sDRq0kYCjLc3VXHf1qFVrChSn+P8fuitotXl5d4Vc58iouAM+W
 Qpk0Z/Gv
 +cQnT62TF72q/otOmj6HqLI3IvPI/psBQZnSWsbrA6upiFCVNBhI+ptaPfwxwt5H/9xgNx4AyeMyfSOHIe4tV+RrJkxL9M7pLx4vEE/9ArZ8dWY8yXDHIdC+an7jTw+DxzIf882ZTaJ0tmYBklwt9B/v792a8fkuD9Zd6fPzXf1S+b6ruM5KNBIxQUD9LO1AB5U79lXHY1T2d8nuH4ovsLHb1cKCcM+SX69o6C+n5igspSjpP+IlNee9zqdquGjKQXFXnRZtna14P8AKf/keoAz1o+gz08AEJIiasTCz7Z+EZGVr+je6i4OGeVu5yFkLV0krzZn0X2m45GYU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add a selftest to check whether THPs can be recovered through
memory compaction after fragmenting memory.

Read the PMD size during runtime. Use a fixed max test size
of 32 GiB and calculate the number of max THPs based on PMD size.

Save existing THP settings and restore them at exit. Configure THP
for MADV_HUGEPAGE mappings, enable only the PMD sized order and set
defrag to madvise so that synchronous compaction is performed for the
test mappings.

Allocate as many THPs as possible, until allocation falls back
to base pages or the max test size is reached. If the max test
size limit is reached, skip the test because retry allocations
could use free memory and not recover memory through compaction.

Record the starting PFN of every allocated THP. Split the allocated
THPs to order 0 using the split_huge_pages debugfs interface and
verify the split using pagemap and kpageflags. Keep the final base
page from each THP mapped and discard the rest.

Retry the same number of successful THP allocations in a new mapping,
while keeping the retained pages mapped. Count a THP as recovered
through compaction if it uses a PFN which was previously used in the
initial THP allocation. After retrying, check if every retained page
is still resident. If not, skip the test since the range could have
been freed through swapping and not through compaction. If more than
half of the initial THP allocations are recovered, pass the test.
Otherwise fail the test.

Skip the test if PMD sized THPs are unavailable, the test is not
running as root, split_huge_pages interface is unavailable,
the pagemap PFNs are masked or the mapping is too large for the
address space.

Add the test to Makefile, run_vmtests.sh and list it in MAINTAINERS.

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 MAINTAINERS                                 |   1 +
 tools/testing/selftests/mm/Makefile         |   1 +
 tools/testing/selftests/mm/run_vmtests.sh   |   2 +
 tools/testing/selftests/mm/thp-compaction.c | 215 ++++++++++++++++++++
 4 files changed, 219 insertions(+)
 create mode 100644 tools/testing/selftests/mm/thp-compaction.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 4d74ad879ecf..eb0b46a361dc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17946,6 +17946,7 @@ F:	mm/mm_slot.h
 F:	tools/mm/thpmaps
 F:	tools/testing/selftests/mm/khugepaged.c
 F:	tools/testing/selftests/mm/split_huge_page_test.c
+F:	tools/testing/selftests/mm/thp-compaction.c
 
 MEMORY MANAGEMENT - USERFAULTFD
 M:	Andrew Morton <akpm@linux-foundation.org>
diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index 06d3d0350a9a..ac39e2afd59f 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -90,6 +90,7 @@ TEST_GEN_FILES += pfnmap
 TEST_GEN_FILES += process_madv
 TEST_GEN_FILES += prctl_thp_disable
 TEST_GEN_FILES += thuge-gen
+TEST_GEN_FILES += thp-compaction
 TEST_GEN_FILES += uffd-stress
 TEST_GEN_FILES += uffd-unit-tests
 TEST_GEN_FILES += uffd-wp-mremap
diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index cb5c7cccb585..a3fdc23c9cfe 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -448,6 +448,8 @@ if [ -n "${MOUNTED_XFS}" ]; then
     rm -f ${XFS_IMG}
 fi
 
+CATEGORY="thp" run_test ./thp-compaction
+
 CATEGORY="thp" run_test ./folio_split_race_test
 
 CATEGORY="migration" run_test ./migration
diff --git a/tools/testing/selftests/mm/thp-compaction.c b/tools/testing/selftests/mm/thp-compaction.c
new file mode 100644
index 000000000000..8935f1968a6d
--- /dev/null
+++ b/tools/testing/selftests/mm/thp-compaction.c
@@ -0,0 +1,215 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <sys/mman.h>
+#include <stdint.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <errno.h>
+#include <mm/hugepage_settings.h>
+#include "vm_util.h"
+#include "kselftest.h"
+
+int mmap_flags = MAP_ANONYMOUS | MAP_NORESERVE | MAP_PRIVATE;
+#define PROT_RW (PROT_READ | PROT_WRITE)
+#define MAX_TEST_SIZE (32ULL << 30)
+#define MAX_THP_RETRIES 3
+
+size_t pmd_size;
+
+static int compare_pfns(const void *a, const void *b)
+{
+	uint64_t pfn_a = *(const uint64_t *)a;
+	uint64_t pfn_b = *(const uint64_t *)b;
+
+	return (pfn_a > pfn_b) - (pfn_a < pfn_b);
+}
+
+static void *mmap_hpage_aligned(size_t len)
+{
+	void *ptr;
+
+	ptr = mmap(NULL, len + pmd_size, PROT_RW, mmap_flags, -1, 0);
+	if (ptr == MAP_FAILED) {
+		if (errno == ENOMEM) {
+			ksft_test_result_skip("Cannot reserve enough virtual address space\n");
+			ksft_finished();
+		}
+		ksft_exit_fail_perror("mmap");
+	}
+	ptr += pmd_size - (uintptr_t)ptr % pmd_size;
+
+	return ptr;
+}
+
+int main(void)
+{
+	size_t len, max_thps, nr_initial = 0;
+	size_t nr_recovered = 0;
+	int pagemap_fd, kpageflags_fd, pmd_order;
+	void *initial, *retry, *p, *last_page;
+	struct thp_settings settings;
+	uint64_t *initial_pfns;
+	int64_t ret;
+
+	ksft_print_header();
+
+	if (!thp_available())
+		ksft_exit_skip("Transparent Hugepages not available\n");
+
+	if (geteuid())
+		ksft_exit_skip("Run this test as root\n");
+
+	pmd_size = pmd_psize();
+	if (!pmd_size)
+		ksft_exit_skip("Reading PMD pagesize failed\n");
+
+	if (SIZE_MAX - pmd_size < MAX_TEST_SIZE)
+		ksft_exit_skip("Required mapping is too large for this architecture\n");
+
+	pmd_order = sz2ord(pmd_size, psize());
+	if (!(thp_supported_orders() & (1UL << pmd_order)))
+		ksft_exit_skip("PMD sized THPs are not supported\n");
+
+	if (!split_huge_pages_supported())
+		ksft_exit_skip("split_huge_pages debugfs interface unavailable\n");
+
+	thp_save_settings();
+	thp_read_settings(&settings);
+
+	settings.thp_enabled = THP_MADVISE;
+	settings.thp_defrag = THP_DEFRAG_MADVISE;
+
+	for (int i = 0; i < NR_ORDERS; i++)
+		settings.hugepages[i].enabled = THP_NEVER;
+
+	settings.hugepages[pmd_order].enabled = THP_INHERIT;
+	thp_push_settings(&settings);
+
+	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
+	if (pagemap_fd < 0)
+		ksft_exit_skip("Unable to open pagemap\n");
+
+	kpageflags_fd = open("/proc/kpageflags", O_RDONLY);
+	if (kpageflags_fd < 0) {
+		close(pagemap_fd);
+		ksft_exit_skip("Unable to open kpageflags\n");
+	}
+
+	ksft_set_plan(1);
+
+	len = (size_t)MAX_TEST_SIZE;
+	max_thps = len / pmd_size;
+	initial = mmap_hpage_aligned(len);
+	initial_pfns = calloc(max_thps, sizeof(*initial_pfns));
+	if (!initial_pfns)
+		ksft_exit_fail_msg("Couldn't allocate initial PFNs array\n");
+
+	/*
+	 * Try to allocate as many THPs as possible and keep them
+	 * allocated
+	 */
+	for (nr_initial = 0; nr_initial < max_thps; nr_initial++) {
+		p = initial + nr_initial * pmd_size;
+
+		for (int i = 0; i < MAX_THP_RETRIES; i++) {
+			ret = allocate_transhuge(p, pagemap_fd);
+			if (ret == -EACCES) {
+				ksft_test_result_skip("Pagemap PFNs are unavailable\n");
+				ksft_finished();
+			}
+			if (ret >= 0)
+				break;
+		}
+		if (ret < 0) {
+			if (madvise(p, pmd_size, MADV_DONTNEED))
+				ksft_exit_fail_perror("MADV_DONTNEED");
+			break;
+		}
+	}
+
+	if (!nr_initial) {
+		ksft_test_result_skip("Failed to allocate any THPs\n");
+		ksft_finished();
+	}
+
+	/*
+	 * If no fallback is observed, retry allocations could use untouched
+	 * free memory instead of recovering memory through compaction.
+	 */
+	if (nr_initial == max_thps) {
+		ksft_test_result_skip("Reached max allocation without failure\n");
+		ksft_finished();
+	}
+
+	/*
+	 * Split all allocated THPs to order 0, keeping only the final base page
+	 * from each THP
+	 */
+	for (size_t i = 0; i < nr_initial; i++) {
+		p = initial + i * pmd_size;
+		last_page = p + pmd_size - psize();
+
+		if (!is_backed_by_folio(p, pmd_order, pagemap_fd, kpageflags_fd)) {
+			ksft_test_result_skip(
+				"Initial range is not backed by a resident PMD sized folio\n");
+			ksft_finished();
+		}
+
+		initial_pfns[i] = pagemap_get_pfn(pagemap_fd, p);
+
+		split_huge_pages(p, psize(), 0);
+		if (!is_backed_by_folio(last_page, 0, pagemap_fd, kpageflags_fd)) {
+			ksft_test_result_fail("Failed to split THP to order 0\n");
+			ksft_finished();
+		}
+		if (madvise(p, pmd_size - psize(), MADV_DONTNEED))
+			ksft_exit_fail_perror("MADV_DONTNEED");
+	}
+
+	qsort(initial_pfns, nr_initial, sizeof(*initial_pfns), compare_pfns);
+
+	/*
+	 * Retry to allocate THPs in a separate mapping
+	 */
+	retry = mmap_hpage_aligned(nr_initial * pmd_size);
+	for (size_t i = 0; i < nr_initial; i++) {
+		p = retry + i * pmd_size;
+
+		ret = allocate_transhuge(p, pagemap_fd);
+		if (ret == -EACCES) {
+			ksft_test_result_skip("Pagemap PFNs are unavailable\n");
+			ksft_finished();
+		}
+		if (ret >= 0) {
+			uint64_t pfn = ret;
+
+			if (bsearch(&pfn, initial_pfns, nr_initial,
+				    sizeof(*initial_pfns), compare_pfns))
+				nr_recovered++;
+		} else if (madvise(p, pmd_size, MADV_DONTNEED)) {
+			ksft_exit_fail_perror("MADV_DONTNEED");
+		}
+	}
+
+	/* Check if the last page left from each initial THP is resident */
+	for (size_t i = 0; i < nr_initial; i++) {
+		uint64_t entry;
+
+		last_page = initial + (i + 1) * pmd_size - psize();
+		entry = pagemap_get_entry(pagemap_fd, last_page);
+
+		if (!PAGEMAP_PRESENT(entry)) {
+			ksft_test_result_skip("Retained page is not resident\n");
+			ksft_finished();
+		}
+	}
+
+	close(pagemap_fd);
+	close(kpageflags_fd);
+	free(initial_pfns);
+	ksft_test_result(nr_recovered > nr_initial / 2,
+			 "Recovered %zu of %zu THP ranges after splitting\n",
+			 nr_recovered, nr_initial);
+	ksft_finished();
+}
-- 
2.53.0


