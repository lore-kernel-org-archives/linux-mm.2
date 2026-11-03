Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDDEF606D804
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 15:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=D1sFpcEQ
Received: by kanga.kvack.org (Postfix)
	id C2C566B05B3; Tue,  3 Nov 2026 10:54:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C05226B05B4; Tue,  3 Nov 2026 10:54:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1ABA6B05B5; Tue,  3 Nov 2026 10:54:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 839266B05B3
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:54:58 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8B53B40442
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:54:56 +0000 (UTC)
X-FDA: 85394256192.11.5E8E57C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 10A3120003
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:54:54 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D1sFpcEQ;
	spf=pass (imf13.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793721295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=BvQyqJBRMUQMmLwwXufVB9zDYnE+36YFGkL734602ns=;
	b=IPapJ+VuNgnh5mtK1n3RZ8P7h2p9YOHV5F9A/GemOA2ntWh6stCfsVltlJz0NIRIOuL5ZD
	oCg3hUIa+ob3Tg7g4kxw4xzrN4MzM3bHQsFcz5mPSTqbmTsfUaCvUiKCqkNQOFuGHF2HT7
	YdYwixlf/OUd2DWDX9NpCbWPIj02zQQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793721295;
	b=d7dQId50PbIfb3lvn8SrEsQ1ZOiQlHCsntI4PwMJb5qmDp+r4pgMULMhIkseD52gy9byrb
	h57q8NRlpy5JA44t68/6aD8dKdkWv/QgwsYsHZxeKDuOh18eTDRyjZ6ZjiqdVaUZGVTq/H
	0zsWa7ct1v8vX1PiISsclkKcGBTW2vg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D1sFpcEQ;
	spf=pass (imf13.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8E24F60A59;
	Tue,  3 Nov 2026 15:54:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 657761F00919;
	Tue,  3 Nov 2026 15:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793721294;
	bh=BvQyqJBRMUQMmLwwXufVB9zDYnE+36YFGkL734602ns=;
	h=From:To:Cc:Subject:Date;
	b=D1sFpcEQNhoVYWOSICT9zPzY4CoO5EedSVjXdMCH/OGTzS9hYRjJ6f2/9RpVQ+0ub
	 v5ATp0pJcH2/kcBJlVh6f+EXp8M0z/KPl0T6sSLRt/qKCkdLCFTixxzplN6lRfzcpO
	 vvpQFwWh1DMmDJhHRtndpzRvActs6YJ9CoS4kl3gB7au+UbLJwAnanhWLTgjFxI9qo
	 kirnhXkUBbLgmcgtN6M60lt0bOAdolBC0ei2O58prE+waDUJjeVwQ4nWiwdV+TA7pl
	 XBCirAzY2u5jWtcGfuBfkiiWQxlCaFWzP2zvw5riXgxMolJZUGMpQGo8Y4hVT+xJiB
	 dm67nHrpDngdA==
From: Sasha Levin <sashal@kernel.org>
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
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] selftests/mm: fix format warnings on 32-bit architectures
Date: Tue,  3 Nov 2026 10:54:51 -0500
Message-ID: <20261103155451.534587-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 10A3120003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 96p1c7qz8u63qf6q9zk6m6t8tkch8fey
X-Rspam-User: 
X-HE-Tag: 1793721294-589273
X-HE-Meta: U2FsdGVkX18AvnPAoRzMf4iuihPVvMAotLtB0POpx5Dcfll6eKrmLez+Fybs0SKRRFGGFWBMVzOT9b/RGQZNsPFYpxIJUCC2jAQ5orlB9+Q6LwlCeDxJeG2q4GpimEzshDP8AzBBzMKWxstVKTWa1G0h6T+jlmgDAAwYvJs3hfAMUPtI17sV1aPrGmqbXAeuN8isvC2ove+gv71Pj91FUMswHTbR3q8HZRpE5AeLWr+sidrF541ajvJPiYJzU/VooZksx1IPq4/9+VmefWUnfK3KWUM7cE/9NMAcv/mySNbPfHhcVD1vJJBoc0c2/qlarQtLForhWavxUQgW02AFBAOl7JdAQ6vj/brH0TWWfoiV9PzacyTH/6jHkC119bNLjPxbCadoJlQFJnAQ6H1WWNDxgNgJjXJ1nnrjX3lXWTSOFkQ1NdX9KQ8Acdn+hzVHsWpCX+VfRWBnxYOLsKjEr1HjsZb1RDMTRynAXDVRh4qhuUiIjAOprnn3JeBIYsk1PuTvdV967CW4ywTZXhhIhOLf4SUR79sBxeBLi93oTLrmT/Le31YHM7SaORMNYJvJ1UqH7bJNweyj8xWSuQJE7x3GAp812DaJVEkP2wTFHg2wNdG9WCUcEcQ+KZoq2y/aNdDJc3R5eBo2FOcLFyUZT6YrCpKPYysk2V6vtX9JMz31bURYHCvpkWMpLhpxHEHWbk0kqQuNmuaLeRsG/ZaS8JJ0Amdyk12Jbi5UYaR/O5VxI7d0f0kXaX1DxSJBfyxU3HfdpgYtDYZC7ehpthjEzyOjJlsRXC7hK3pH0/8uqCjdmn2y8dTCG0pAny51ErB5lO9qt2qSJOXCozgMus06LNexIUExhFW84AZUTUaHneFSsMqEHM50Si0NHXcjm1LoluaLsM7kDQE0t72GRNBYYCpbdZapdXhFnKPfuZNxcyDIZZqDkty9kJdJa3he3z01sr0Kt78PabZUZ+2K1qH
 hJ8UARZs
 W2C8KhlLvQc8ndv9nRpm80Zszdik5ALGEedXsprs0SeZR7FJ0W6IRiHnFCE9cVVXWN3WQrH9GnOMXMvrBM2ndoSkvhoeISEhuWlxtgm7bmyoZFqe8hjEn5u3mU+AbU7rZUz7RrnOBEoiC6Loh6KCeqTBm7lADCf7UdjSnXSs/fElGb7ll+C+sWVr0ZSJK1M7jisTsmfbpE1RZiM9U4sRFWdOhUdh98G7FTxDGnE4aoywoccU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 32-bit architectures size_t and uintptr_t are unsigned int and
ssize_t is int, and with _FILE_OFFSET_BITS=64 off_t is long long, so
printing them with %ld, %lu or %lx, or scanning /proc/self/maps into
uintptr_t variables with %lx, warns:

  hugetlb-read-hwpoison.c:32:58: warning: format '%lx' expects argument of type 'long unsigned int', but argument 3 has type 'size_t' {aka 'unsigned int'} [-Wformat=]

Print size_t with %zu and %zx, casting the nonnegative ssize_t read
totals to size_t, print off_t as unsigned long long, and scan the
addresses into unsigned long variables.

split_huge_page_test also builds its debugfs commands from uint64_t
addresses with %lx. write_debugfs() has no format attribute, so nothing
warned, but on 32-bit the commands get the wrong addresses. Print them
with PRIx64, add the attribute, and cast the pointers through uintptr_t,
as casting them straight to uint64_t warns on 32-bit too.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
Found with a 32-bit build of the selftests with a 64-bit time_t (gcc 16
and clang 21 with -m32 -D_TIME_BITS=64 -D_FILE_OFFSET_BITS=64);
KernelCI's 32-bit arm builds show the same warnings. The changed files
build without format warnings there now, and the x86_64 builds don't
change. The other selftests get the same kind of fix in separate
patches.

 .../selftests/mm/hugetlb-read-hwpoison.c      | 25 +++++++-------
 .../selftests/mm/hugetlb-soft-offline.c       |  2 +-
 tools/testing/selftests/mm/mseal_test.c       |  2 +-
 .../selftests/mm/split_huge_page_test.c       | 34 +++++++++----------
 4 files changed, 32 insertions(+), 31 deletions(-)

diff --git a/tools/testing/selftests/mm/hugetlb-read-hwpoison.c b/tools/testing/selftests/mm/hugetlb-read-hwpoison.c
index 31748a24448f8..91b954a078483 100644
--- a/tools/testing/selftests/mm/hugetlb-read-hwpoison.c
+++ b/tools/testing/selftests/mm/hugetlb-read-hwpoison.c
@@ -29,15 +29,15 @@ static void report_status(enum test_status status, const char *test_name,
 {
 	switch (status) {
 	case TEST_PASSED:
-		ksft_test_result_pass("%s chunk_size=0x%lx\n",
+		ksft_test_result_pass("%s chunk_size=0x%zx\n",
 				      test_name, chunk_size);
 		break;
 	case TEST_FAILED:
-		ksft_test_result_fail("%s chunk_size=0x%lx\n",
+		ksft_test_result_fail("%s chunk_size=0x%zx\n",
 				      test_name, chunk_size);
 		break;
 	case TEST_SKIPPED:
-		ksft_test_result_skip("%s chunk_size=0x%lx\n",
+		ksft_test_result_skip("%s chunk_size=0x%zx\n",
 				      test_name, chunk_size);
 		break;
 	}
@@ -62,7 +62,7 @@ static bool verify_chunk(char *buf, size_t len, char val)
 
 	for (i = 0; i < len; ++i) {
 		if (buf[i] != val) {
-			ksft_print_msg("check fail: buf[%lu] = %u != %u\n",
+			ksft_print_msg("check fail: buf[%zu] = %u != %u\n",
 				       i, buf[i], val);
 			return false;
 		}
@@ -79,8 +79,9 @@ static bool seek_read_hugepage_filemap(int fd, size_t len, size_t wr_chunk_size,
 	ssize_t total_ret_count = 0;
 	char val = offset / wr_chunk_size + offset % wr_chunk_size;
 
-	ksft_print_msg("init val=%u with offset=0x%lx\n", val, offset);
-	ksft_print_msg("expect to read 0x%lx bytes of data in total\n",
+	ksft_print_msg("init val=%u with offset=0x%llx\n", val,
+		       (unsigned long long)offset);
+	ksft_print_msg("expect to read 0x%zx bytes of data in total\n",
 		       expected);
 	if (lseek(fd, offset, SEEK_SET) < 0) {
 		ksft_perror("seek failed");
@@ -102,8 +103,8 @@ static bool seek_read_hugepage_filemap(int fd, size_t len, size_t wr_chunk_size,
 
 		total_ret_count += ret_count;
 	}
-	ksft_print_msg("actually read 0x%lx bytes of data in total\n",
-		       total_ret_count);
+	ksft_print_msg("actually read 0x%zx bytes of data in total\n",
+		       (size_t)total_ret_count);
 
 	return total_ret_count == expected;
 }
@@ -116,7 +117,7 @@ static bool read_hugepage_filemap(int fd, size_t len,
 	ssize_t total_ret_count = 0;
 	char val = 0;
 
-	ksft_print_msg("expect to read 0x%lx bytes of data in total\n",
+	ksft_print_msg("expect to read 0x%zx bytes of data in total\n",
 		       expected);
 	while (total_ret_count < len) {
 		ret_count = read(fd, buf, wr_chunk_size);
@@ -133,8 +134,8 @@ static bool read_hugepage_filemap(int fd, size_t len,
 
 		total_ret_count += ret_count;
 	}
-	ksft_print_msg("actually read 0x%lx bytes of data in total\n",
-		       total_ret_count);
+	ksft_print_msg("actually read 0x%zx bytes of data in total\n",
+		       (size_t)total_ret_count);
 
 	return total_ret_count == expected;
 }
@@ -293,7 +294,7 @@ int main(void)
 
 	signal(SIGBUS, sigbus_handler);
 	for (i = 0; i < ARRAY_SIZE(wr_chunk_sizes); ++i) {
-		ksft_print_msg("Write/read chunk size=0x%lx\n",
+		ksft_print_msg("Write/read chunk size=0x%zx\n",
 			       wr_chunk_sizes[i]);
 
 		fd = create_hugetlbfs_file(&file_stat);
diff --git a/tools/testing/selftests/mm/hugetlb-soft-offline.c b/tools/testing/selftests/mm/hugetlb-soft-offline.c
index d9565219378aa..9bdd78636dc2a 100644
--- a/tools/testing/selftests/mm/hugetlb-soft-offline.c
+++ b/tools/testing/selftests/mm/hugetlb-soft-offline.c
@@ -56,7 +56,7 @@ static int do_soft_offline(int fd, size_t len, int expect_errno)
 	}
 
 	memset(filemap, 0xab, len);
-	ksft_print_msg("Allocated %#lx bytes of hugetlb pages\n", len);
+	ksft_print_msg("Allocated %#zx bytes of hugetlb pages\n", len);
 
 	hwp_addr = filemap + len / 2;
 	ret = madvise(hwp_addr, pagesize, MADV_SOFT_OFFLINE);
diff --git a/tools/testing/selftests/mm/mseal_test.c b/tools/testing/selftests/mm/mseal_test.c
index 1a05e6921fed7..cea6c47cf5091 100644
--- a/tools/testing/selftests/mm/mseal_test.c
+++ b/tools/testing/selftests/mm/mseal_test.c
@@ -24,7 +24,7 @@ static unsigned long get_vma_size(void *addr, int *prot)
 	FILE *maps;
 	char line[256];
 	int size = 0;
-	uintptr_t  addr_start, addr_end;
+	unsigned long addr_start, addr_end;
 	char protstr[5];
 	*prot = 0;
 
diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index 36a6719ff09a8..f8744b5dbf990 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -32,9 +32,9 @@ int *expected_orders;
 #define SMAP_PATH "/proc/self/smaps"
 #define INPUT_MAX 80
 
-#define PID_FMT "%d,0x%lx,0x%lx,%d"
-#define PID_FMT_OFFSET "%d,0x%lx,0x%lx,%d,%d"
-#define PATH_FMT "%s,0x%lx,0x%lx,%d"
+#define PID_FMT "%d,0x%" PRIx64 ",0x%" PRIx64 ",%d"
+#define PID_FMT_OFFSET "%d,0x%" PRIx64 ",0x%" PRIx64 ",%d,%d"
+#define PATH_FMT "%s,0x%" PRIx64 ",0x%" PRIx64 ",%d"
 
 const char *pagemap_proc = "/proc/self/pagemap";
 const char *kpageflags_proc = "/proc/kpageflags";
@@ -70,7 +70,7 @@ static int check_after_split_folio_orders(char *vaddr_start, size_t len,
 	return status;
 }
 
-static void write_debugfs(const char *fmt, ...)
+static __printf(1, 2) void write_debugfs(const char *fmt, ...)
 {
 	char input[INPUT_MAX];
 	int ret;
@@ -132,12 +132,12 @@ static void verify_rss_anon_split_huge_page_all_zeroes(char *one_page, int nr_hp
 	disable_khugepaged(one_page, len);
 
 	/* split all THPs */
-	write_debugfs(PID_FMT, getpid(), (uint64_t)one_page,
-		      (uint64_t)one_page + len, 0);
+	write_debugfs(PID_FMT, getpid(), (uint64_t)(uintptr_t)one_page,
+		      (uint64_t)(uintptr_t)one_page + len, 0);
 
 	for (i = 0; i < len; i++)
 		if (one_page[i] != (char)0)
-			ksft_exit_fail_msg("%ld byte corrupted\n", i);
+			ksft_exit_fail_msg("%zu byte corrupted\n", i);
 
 	if (!check_huge_anon(one_page, nr_hpages * pmd_pagesize, 0, pmd_pagesize))
 		ksft_exit_fail_msg("Still AnonHugePages not split\n");
@@ -181,12 +181,12 @@ static void split_pmd_thp_to_order(int order)
 	disable_khugepaged(one_page, len);
 
 	/* split all THPs */
-	write_debugfs(PID_FMT, getpid(), (uint64_t)one_page,
-		(uint64_t)one_page + len, order);
+	write_debugfs(PID_FMT, getpid(), (uint64_t)(uintptr_t)one_page,
+		(uint64_t)(uintptr_t)one_page + len, order);
 
 	for (i = 0; i < len; i++)
 		if (one_page[i] != (char)i)
-			ksft_exit_fail_msg("%ld byte corrupted\n", i);
+			ksft_exit_fail_msg("%zu byte corrupted\n", i);
 
 	memset(expected_orders, 0, sizeof(int) * (pmd_order + 1));
 	expected_orders[order] = 4 << (pmd_order - order);
@@ -269,8 +269,8 @@ static void split_pte_mapped_thp(void)
 	}
 
 	/* Split all THPs through the remapped pages. */
-	write_debugfs(PID_FMT, getpid(), (uint64_t)page_area,
-		      (uint64_t)page_area + page_area_size, 0);
+	write_debugfs(PID_FMT, getpid(), (uint64_t)(uintptr_t)page_area,
+		      (uint64_t)(uintptr_t)page_area + page_area_size, 0);
 
 	/* Corruption during mremap or split? */
 	for (i = 0; i < page_area_size; i++) {
@@ -536,16 +536,16 @@ static void split_thp_in_pagecache_to_order_at(size_t fd_size,
 	 */
 	if (offset == -1) {
 		for (split_addr = addr; split_addr < addr + fd_size; split_addr += pmd_pagesize)
-			write_debugfs(PID_FMT, getpid(), (uint64_t)split_addr,
-				      (uint64_t)split_addr + pagesize, order);
+			write_debugfs(PID_FMT, getpid(), (uint64_t)(uintptr_t)split_addr,
+				      (uint64_t)(uintptr_t)split_addr + pagesize, order);
 
 		expected_orders[order] = fd_size / (pagesize << order);
 	} else {
 		int times = fd_size / pmd_pagesize;
 
 		for (split_addr = addr; split_addr < addr + fd_size; split_addr += pmd_pagesize)
-			write_debugfs(PID_FMT_OFFSET, getpid(), (uint64_t)split_addr,
-				      (uint64_t)split_addr + pagesize, order, offset);
+			write_debugfs(PID_FMT_OFFSET, getpid(), (uint64_t)(uintptr_t)split_addr,
+				      (uint64_t)(uintptr_t)split_addr + pagesize, order, offset);
 
 		for (i = order + 1; i < pmd_order; i++)
 			expected_orders[i] = times;
@@ -554,7 +554,7 @@ static void split_thp_in_pagecache_to_order_at(size_t fd_size,
 
 	for (i = 0; i < fd_size; i++)
 		if (*(addr + i) != (char)i) {
-			ksft_print_msg("%lu byte corrupted in the file\n", i);
+			ksft_print_msg("%zu byte corrupted in the file\n", i);
 			err = EXIT_FAILURE;
 			goto out;
 		}
-- 
2.53.0


