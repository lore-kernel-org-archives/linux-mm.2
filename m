Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8ADF6606A337
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 09:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=iAEgSvXe
Received: by kanga.kvack.org (Postfix)
	id A48596B05C3; Thu, 12 Nov 2026 04:03:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F85B6B05C4; Thu, 12 Nov 2026 04:03:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E6FD6B05C5; Thu, 12 Nov 2026 04:03:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 68BCB6B05C3
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 04:03:34 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0AB7D14050D
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:03:34 +0000 (UTC)
X-FDA: 85425878748.03.BC31E8C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3AAAB14000D
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:03:32 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=iAEgSvXe;
	spf=pass (imf09.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794474212;
	b=X/hi5aKrc5pXe1GAAk5wxv9Jyb5xsFPVbJ4ZYYsUlo63iWJTpht+QZT73htuDa9f5FbpFy
	vUuUHNpTEI6IjaFfr7od1fzyVcPuo8RPNBKabFGhkDbjPeFmph8s5xnKcLrQcVXmj3zsCB
	qEq7wWAK9u1qhy2Mkouztwzy4qex9Zo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=iAEgSvXe;
	spf=pass (imf09.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794474212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O88YpmLyBaL0GDW/HqJr/4Rg7GIIxRNNQP9aX2FDqgo=;
	b=sgeZLT24J/tjf2obJSnCljZTLfbJQoeg7oyLteLNb0eD4TbEJNfcLapZVaFGjk0mhQsBYb
	JgXREG5QNAeUkfbWW7K19c6t4ZQQIlnRVMY84N0q0PZcgbAQ5K0tsb3OEXR5adT7Ao+DKX
	SfC8F41maEK0J3HUGd+odSavoVbcqC8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4E09C339;
	Thu, 12 Nov 2026 01:03:28 -0800 (PST)
Received: from a081061.arm.com (unknown [10.163.169.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 910C43F632;
	Thu, 12 Nov 2026 01:03:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794474211; bh=3odyGGmkLwYaY8M4LOJ/DQPeRwp4YOqebnO21NAILuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iAEgSvXe8QbzirTjb+g+yaD+tZMr0kmqLkov4TCo5rn21C1IDZjYwZ8iDq7Fx79aT
	 Hc2/lpw3OwkhHph2Ad7OJ7WNx7flNNRvF4z0F3XGQpaWrszsVQn2+5tjK7X5R0yEmt
	 cLGQ5b733G+r8IKCbf6EubQG40kDRb1Lpf3G9TiY=
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
Subject: [PATCH 3/4] selftests/mm: factor out THP split helpers
Date: Thu, 12 Nov 2026 14:32:49 +0530
Message-ID: <20261112090250.334344-4-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261112090250.334344-1-sarthak.sharma@arm.com>
References: <20261112090250.334344-1-sarthak.sharma@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yzdc7e5h3j79wnhjy9c4gwwey4dobd4a
X-Rspamd-Queue-Id: 3AAAB14000D
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794474212-26237
X-HE-Meta: U2FsdGVkX1/+zCot5QgcaraxkEbfc+bzjN/qQkPiTVzQzfGUWRmCec7Ngtb+H8vmgbtX52JbPPaJWT7piEVvIqWxZjjXKxfSZKeoBnw73c1+izy2SV1PJVzn5x2u0RoxVteBEJB/0LWLncPTb5HxmLrCyfh9naehfVs4RQF31hhvmXrbg4ATh2lzU8jrEYKN7YzTwerqVAnFO5Ka0rL5u+tIeldlHNLTG9wN/KDRoMTKkOMnQ5gLtsic8b4XHdbFHqaLNzHWpLKGI7xmUkcIeFuTLE3HTGfE5c0EVNNFrEO/2Qlht6kacsz5HxQJqM2HQi3bwIH/L4NTtEjUMSsGMpsl40fmY386f4eyPgZymTjWe6FQA9YFaMOXmPwRcKF+JDBsGEVoCXxTWQqtkNV+Al33uY7kpPJDJMUBEUKoA7M8hySdRF54Zg8iZSTfRIy8ed8d4wGnaZiahyOn54oIU84mhd/qCqjGumoCmGMR5kW21kHRZre42lHrI7LvTnCnwn4Msu1LMsaNVSh3Rw63dCnq6PXksbWcx7LRCxLFFluRuuaGi3MlysCpfG48zCaFwpTiNYOMz3UBoIbP6pEQjzWPs3lPvOb8120+6OPzTZozEa876EbJmrijDwhGVqRRiaSszjeatpzikWQOvFyaI9EA+Zwcsgz0Vj5d/5pwC3EGhhSEjIItQIxNOvK0eDLSDxcwJ6fm1wrBYRjzWlD1xO+pWKKYLjiRXAukcT+qjAdDABP0SShedZa8Y6Mk9a9bpZMqzDQe9HYUmAJKtrRDtMYEOUF5zJ8hWxgUd9XOHsXgo3ZywXiE8E71KS/CSQpNFILt7BNZHZBpSQExpZt6Bn8RACol8jqQ+URnUoH6qbt7vTLGC/y8/ACabJ3qmHrmAc68TRdx6PJLHPA5oP3AwHpqRl6YfjgWUyiYtkG30yJaRFaVM0cjdcKQ0pamMmRA2uIXK/Yt7McqHHznkOj
 0Rt/lk3z
 C8eWUtS1R6RuOKtBSIxbhhzJCS+23UfOZEnBHliZq1tKlSqis/qfEPzMfo8jROEHegjK7wIh+sKZthk9gjeTnMHQxMssRkoETySQ79MvnkwRgpKrmCe7VXFnz6XUrGUjqUZnvYP9oNQl2UcxgPxIv0/M7Nz5KPyc2ThK4uqQfETAezgzCrjXbCDJH7AafbnWSEixNWA/KGaJHwBchkgNyPVIhxqLZtMXH1ZxFsqP0sV+B6GXJXn99cf/etA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

split_huge_page_test.c contains helpers to split huge pages using
the split_huge_pages debugfs interface. A later patch adds a THP
compaction selftest and needs the same functionality.

Move write_debugfs() to vm_util.c. Add wrappers for splitting
process mappings, mappings with an offset within folio and file
backed folios. Also add a helper to check if the debugfs interface
is available.

Update split_huge_page_test.c to use the shared helpers and
also remove the unused SMAP_PATH definition.

Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 .../selftests/mm/split_huge_page_test.c       | 45 +++------------
 tools/testing/selftests/mm/vm_util.c          | 56 +++++++++++++++++++
 tools/testing/selftests/mm/vm_util.h          |  6 ++
 3 files changed, 69 insertions(+), 38 deletions(-)

diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index 33a2473327bb..330a453e6402 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -8,7 +8,6 @@
 #include <assert.h>
 #include <stdio.h>
 #include <stdlib.h>
-#include <stdarg.h>
 #include <unistd.h>
 #include <inttypes.h>
 #include <string.h>
@@ -28,14 +27,8 @@ uint64_t pmd_pagesize;
 unsigned int pmd_order;
 int *expected_orders;
 
-#define SPLIT_DEBUGFS "/sys/kernel/debug/split_huge_pages"
-#define SMAP_PATH "/proc/self/smaps"
 #define INPUT_MAX 80
 
-#define PID_FMT "%d,0x%lx,0x%lx,%d"
-#define PID_FMT_OFFSET "%d,0x%lx,0x%lx,%d,%d"
-#define PATH_FMT "%s,0x%lx,0x%lx,%d"
-
 const char *pagemap_proc = "/proc/self/pagemap";
 const char *kpageflags_proc = "/proc/kpageflags";
 int pagemap_fd;
@@ -70,25 +63,6 @@ static int check_after_split_folio_orders(char *vaddr_start, size_t len,
 	return status;
 }
 
-static void write_debugfs(const char *fmt, ...)
-{
-	char input[INPUT_MAX];
-	int ret;
-	va_list argp;
-
-	va_start(argp, fmt);
-	ret = vsnprintf(input, INPUT_MAX, fmt, argp);
-	va_end(argp);
-
-	if (ret >= INPUT_MAX)
-		ksft_exit_fail_msg("%s: Debugfs input is too long\n", __func__);
-
-	ret = write_file(SPLIT_DEBUGFS, input, ret + 1);
-	if (ret)
-		ksft_exit_fail_msg("write_file(%s): %s\n", SPLIT_DEBUGFS,
-				   strerror(-ret));
-}
-
 static char *allocate_zero_filled_hugepage(size_t len)
 {
 	char *result;
@@ -132,8 +106,7 @@ static void verify_rss_anon_split_huge_page_all_zeroes(char *one_page, int nr_hp
 	disable_khugepaged(one_page, len);
 
 	/* split all THPs */
-	write_debugfs(PID_FMT, getpid(), (uint64_t)one_page,
-		      (uint64_t)one_page + len, 0);
+	split_huge_pages(one_page, len, 0);
 
 	for (i = 0; i < len; i++)
 		if (one_page[i] != (char)0)
@@ -181,8 +154,7 @@ static void split_pmd_thp_to_order(int order)
 	disable_khugepaged(one_page, len);
 
 	/* split all THPs */
-	write_debugfs(PID_FMT, getpid(), (uint64_t)one_page,
-		(uint64_t)one_page + len, order);
+	split_huge_pages(one_page, len, order);
 
 	for (i = 0; i < len; i++)
 		if (one_page[i] != (char)i)
@@ -269,8 +241,7 @@ static void split_pte_mapped_thp(void)
 	}
 
 	/* Split all THPs through the remapped pages. */
-	write_debugfs(PID_FMT, getpid(), (uint64_t)page_area,
-		      (uint64_t)page_area + page_area_size, 0);
+	split_huge_pages(page_area, page_area_size, 0);
 
 	/* Corruption during mremap or split? */
 	for (i = 0; i < page_area_size; i++) {
@@ -306,7 +277,7 @@ static void split_file_backed_thp(int order)
 	char opts[64];
 	ssize_t num_written, num_read;
 	char *file_buf1 = NULL, *file_buf2 = NULL;
-	uint64_t pgoff_start = 0, pgoff_end = 1024;
+	unsigned long pgoff_start = 0, pgoff_end = 1024;
 	int i;
 
 	ksft_print_msg("Please enable pr_debug in split_huge_pages_in_file() for more info.\n");
@@ -355,7 +326,7 @@ static void split_file_backed_thp(int order)
 	}
 
 	/* split the file-backed THP */
-	write_debugfs(PATH_FMT, testfile, pgoff_start, pgoff_end, order);
+	split_huge_pages_file(testfile, pgoff_start, pgoff_end, order);
 
 	/* check file content after split */
 	status = lseek(fd, 0, SEEK_SET);
@@ -536,16 +507,14 @@ static void split_thp_in_pagecache_to_order_at(size_t fd_size,
 	 */
 	if (offset == -1) {
 		for (split_addr = addr; split_addr < addr + fd_size; split_addr += pmd_pagesize)
-			write_debugfs(PID_FMT, getpid(), (uint64_t)split_addr,
-				      (uint64_t)split_addr + pagesize, order);
+			split_huge_pages(split_addr, pagesize, order);
 
 		expected_orders[order] = fd_size / (pagesize << order);
 	} else {
 		int times = fd_size / pmd_pagesize;
 
 		for (split_addr = addr; split_addr < addr + fd_size; split_addr += pmd_pagesize)
-			write_debugfs(PID_FMT_OFFSET, getpid(), (uint64_t)split_addr,
-				      (uint64_t)split_addr + pagesize, order, offset);
+			split_huge_pages_with_offset(split_addr, pagesize, order, offset);
 
 		for (i = order + 1; i < pmd_order; i++)
 			expected_orders[i] = times;
diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index 9942bbea7837..b64c651f753e 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -18,6 +18,12 @@
 #define PAGEMAP_PATH "/proc/self/pagemap"
 #define KPAGEFLAGS_PATH "/proc/kpageflags"
 #define MAX_NR_ORDERS 20
+#define SPLIT_DEBUGFS "/sys/kernel/debug/split_huge_pages"
+#define INPUT_MAX 80
+
+#define PID_FMT "%d,0x%lx,0x%lx,%d"
+#define PID_FMT_OFFSET "%d,0x%lx,0x%lx,%d,%d"
+#define PATH_FMT "%s,0x%lx,0x%lx,%d"
 
 unsigned int __page_size;
 unsigned int __page_shift;
@@ -1105,6 +1111,56 @@ int unpoison_memory(unsigned long pfn)
 	return ret > 0 ? 0 : -errno;
 }
 
+static void write_debugfs(const char *fmt, ...)
+{
+	char input[INPUT_MAX];
+	int ret;
+	va_list argp;
+
+	va_start(argp, fmt);
+	ret = vsnprintf(input, INPUT_MAX, fmt, argp);
+	va_end(argp);
+
+	if (ret >= INPUT_MAX)
+		ksft_exit_fail_msg("%s: Debugfs input is too long\n", __func__);
+
+	ret = write_file(SPLIT_DEBUGFS, input, ret + 1);
+	if (ret)
+		ksft_exit_fail_msg("write_file(%s): %s\n", SPLIT_DEBUGFS,
+				   strerror(-ret));
+}
+
+bool split_huge_pages_supported(void)
+{
+	int fd;
+
+	fd = open(SPLIT_DEBUGFS, O_WRONLY);
+	if (fd < 0)
+		return false;
+
+	close(fd);
+	return true;
+}
+
+void split_huge_pages(void *addr, size_t len, int order)
+{
+	write_debugfs(PID_FMT, getpid(), (unsigned long)addr,
+		      (unsigned long)addr + len, order);
+}
+
+void split_huge_pages_with_offset(void *addr, size_t len, int order,
+				  int offset)
+{
+	write_debugfs(PID_FMT_OFFSET, getpid(), (unsigned long)addr,
+		      (unsigned long)addr + len, order, offset);
+}
+
+void split_huge_pages_file(const char *path, unsigned long start,
+			   unsigned long end, int order)
+{
+	write_debugfs(PATH_FMT, path, start, end, order);
+}
+
 static unsigned long shmall, shmmax;
 
 void __shm_limits_restore(void)
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index ef8fe76d4c61..efd3a2be945d 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -118,6 +118,12 @@ bool is_backed_by_folio(char *vaddr, int order, int pagemap_fd,
 			int kpageflags_fd);
 bool is_range_backed_by_order(char *start, size_t len, int order,
 			      int pagemap_fd, int kpageflags_fd);
+bool split_huge_pages_supported(void);
+void split_huge_pages(void *addr, size_t len, int order);
+void split_huge_pages_with_offset(void *addr, size_t len, int order,
+				  int offset);
+void split_huge_pages_file(const char *path, unsigned long start,
+			   unsigned long end, int order);
 
 int uffd_register(int uffd, void *addr, uint64_t len,
 		  bool miss, bool wp, bool minor);
-- 
2.53.0


