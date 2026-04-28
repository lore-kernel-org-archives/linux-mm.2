Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1EDAFF886D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 20:44:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 472A96B00AA; Tue, 28 Apr 2026 16:44:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44A916B00AC; Tue, 28 Apr 2026 16:44:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 360CC6B00AD; Tue, 28 Apr 2026 16:44:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 243DF6B00AA
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:44:13 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DA7601C01B5
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:44:12 +0000 (UTC)
X-FDA: 84709141944.03.5DF5221
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2BC8E100002
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:44:10 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AcKPucQl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777409051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XADW/nMhumCs9LcJUshXZViSCdG7YfYkAck0kkE4jrQ=;
	b=8LldwttBPSs6cQpC6AADYZuysTZ49VY62e6alrDYkZW7IQTH/px1uhpgmj5y5yPNkqGp2w
	pn1lh+lborY7htdXPbwYkKFTajuzV6VZsM43HpA/HOEqmHug4SRzsaD2W4RBOjHsupuvCq
	5/XsPym6yu8TK56UJr2XGhtQTrUOsp0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777409051; a=rsa-sha256;
	cv=none;
	b=LfCm1sFOitYXGG/QfB2c1y6YRR7Yr1csBYFHWZU4s1aa4ktZ0/0hzK1A78ySR3ZXPWPmjZ
	1Crox5GRUJM5GPcH1IyEo90vTMvJ9GMog1SKXHpMNlb5r/qfKIb8eGnlwkIIyBbXbvBPbV
	x2RqV3tYSlKNBzZre/wzycwIzFiQWaU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AcKPucQl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3FD5540BE1;
	Tue, 28 Apr 2026 20:44:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13318C2BCAF;
	Tue, 28 Apr 2026 20:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777409050;
	bh=9K0SWl11YhYNKR49OO1EUtZ+QamHSW0oabj1cOHKjSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AcKPucQlH/Te28Y/gHhNIo9I6ASVFw3NuZMApHCiaAGiOFW9Q8VJVUnny7tfVumrk
	 xcNJLDeVsdaT6xE4+Yk4QpyeVQpLoA+5oHbMFvF/2ah+mXFpvksVmDYDwuk6JljffX
	 kdQ5Nc04/lEspbHHBuU68vsKeglgYxmLGU97oSc+y0AypwvYsP2UbSPEiOrGC7FZUx
	 YJimCy6SM61QNaqdkom3wzc0kOwdP0SAo9E8L1ySyagbmh3JuW5VPyn1CjgptoAyW+
	 rrgJn7ZI+O5RApzD22l/jzpnUqUpT9NgxjFseBeAWRDPH95dGn5Gnul+63sA6Fa8OH
	 Aq77WymJQeQ+Q==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Donet Tom <donettom@linux.ibm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Luiz Capitulino <luizcap@redhat.com>,
	Mark Brown <broonie@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nico Pache <npache@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 12/54] selftests/mm: hugetlb-read-hwpoison: use kselftest framework
Date: Tue, 28 Apr 2026 23:41:58 +0300
Message-ID: <20260428204240.1924129-13-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428204240.1924129-1-rppt@kernel.org>
References: <20260428204240.1924129-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2BC8E100002
X-Stat-Signature: cjxeyzcynaapzo1prabdfy5kkzc81hj8
X-Rspam-User: 
X-HE-Tag: 1777409050-880400
X-HE-Meta: U2FsdGVkX190T639MEb1kTOZZ8ryimbQIpXPgn1ee2+9rWgGa66kyDUTNj3QC80FmCifS7vPaA96Uwp7v5rpfBcG4xdZxujs/HYyIg5WSceqQMwWFkzW5PmUlN9a30g05c7VmJM7rLE6j9JSlW6PjagFfku8B7N72l/4fsAwz9EJLhMJyFcjUmYcBj1HHbamdBFJjZ7wI5FqzNhVmobXCnaTDJ5rh6g4ZS4CtCTsLFk2bXsyM5W8nxgz53slIIh9x0KZSZt2KXmrOHEQY5GkHZhWI/YXUmAB99yooC8xYGtE9uci0V3X6TntXvKgE1v0/vM3ARRasAw3ssaqE8ZFCiUZh9dKZjgDb9dBfqu2d4lheqRqayDWXm1LyB4v07k9paXbA+1nmUzWNQ3vakXlWcrRcSysImYri6WpgCvfjDpqU/Hv3TP9XnUS+haphfLwHfGsirgCj335zXEN6UBN2E8Tp/daASh3N29w+niX45ZcDvJgkATqWUx+dKnPXgiaSK2gpqmMbkhHWkeVZ+mbvA8VrKxSVDLO/ivHediBEbUqA+g9XEese1lIlopN6lI43xvKFuGFeg27irnpzd5OshGr5pNIkN82fCzTIG+5qQ5bxCcE+1PDg/P4TTLWzepKgS8qqZB0QVM92D+u72mwEf/FPZ2tlbP33EpiVUh89LSR8fCV72jsRGcHTNns+yTiUF0u0K94FY6m2TYRqyScKq+pCoNdzgixVcJ4COxkVigBvbwl9aWcl3URepd25/4+j87xRg77yMvd3e+SF7J5nxJ+sbg8au5ayrbM8xvKifXY4fbONqbK1OYbC35lAEeNiWILFQIViNVTiyvdOYutVwlUlrJpxUobzILGzHNqDacVJvtZO+7S/Jg11zmgdGg6RMOjRhZqUAOwZG0VK2FxZ/7eEk+P8sbDkZAdppWnbdsVQytQDt6JFEuF5UfB/DOS8a/yjOsHlnFX0f9RS9K
 qOdGx7qS
 AC0YXS4Eza+lRTgf/sndva95cwCA50XoPiRlm1/bF+FcsFz1C4bVqk3O46G5OsiQr6rhsCECAR/4sx9rMKHjdRQMHJVM4W2QMhiDrd+hzPy/RZF7cwDICLA6+XLPnWelmVEJgS5Wzj6ClPYm3isADDkLpAlhdqw+zNbDKz/JXb9a+wMYs/4ClLrpWXTN5GVhg/IFaT4wXkXGv1xUGTKM4b1iC4QCGsZpPhnyuIhA3qKZGl5XNswZPlMJQqTUPH4SG+Icg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Convert hugetlb-read-hwpoison test to use kselftest framework for
reporting and tracking successful and failing runs.

Reviewed-by: Donet Tom <donettom@linux.ibm.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 .../selftests/mm/hugetlb-read-hwpoison.c      | 118 +++++++++---------
 1 file changed, 57 insertions(+), 61 deletions(-)

diff --git a/tools/testing/selftests/mm/hugetlb-read-hwpoison.c b/tools/testing/selftests/mm/hugetlb-read-hwpoison.c
index 6bbf15f78061..01cd5465e0f8 100644
--- a/tools/testing/selftests/mm/hugetlb-read-hwpoison.c
+++ b/tools/testing/selftests/mm/hugetlb-read-hwpoison.c
@@ -13,9 +13,7 @@
 #include <signal.h>
 
 #include "kselftest.h"
-
-#define PREFIX " ... "
-#define ERROR_PREFIX " !!! "
+#include "vm_util.h"
 
 #define MAX_WRITE_READ_CHUNK_SIZE (getpagesize() * 16)
 #define MAX(a, b) (((a) > (b)) ? (a) : (b))
@@ -26,17 +24,22 @@ enum test_status {
 	TEST_SKIPPED = 2,
 };
 
-static char *status_to_str(enum test_status status)
+static void report_status(enum test_status status, const char *test_name,
+			  size_t chunk_size)
 {
 	switch (status) {
 	case TEST_PASSED:
-		return "TEST_PASSED";
+		ksft_test_result_pass("%s chunk_size=0x%lx\n",
+				      test_name, chunk_size);
+		break;
 	case TEST_FAILED:
-		return "TEST_FAILED";
+		ksft_test_result_fail("%s chunk_size=0x%lx\n",
+				      test_name, chunk_size);
+		break;
 	case TEST_SKIPPED:
-		return "TEST_SKIPPED";
-	default:
-		return "TEST_???";
+		ksft_test_result_skip("%s chunk_size=0x%lx\n",
+				      test_name, chunk_size);
+		break;
 	}
 }
 
@@ -59,8 +62,8 @@ static bool verify_chunk(char *buf, size_t len, char val)
 
 	for (i = 0; i < len; ++i) {
 		if (buf[i] != val) {
-			printf(PREFIX ERROR_PREFIX "check fail: buf[%lu] = %u != %u\n",
-				i, buf[i], val);
+			ksft_print_msg("check fail: buf[%lu] = %u != %u\n",
+				       i, buf[i], val);
 			return false;
 		}
 	}
@@ -76,21 +79,21 @@ static bool seek_read_hugepage_filemap(int fd, size_t len, size_t wr_chunk_size,
 	ssize_t total_ret_count = 0;
 	char val = offset / wr_chunk_size + offset % wr_chunk_size;
 
-	printf(PREFIX PREFIX "init val=%u with offset=0x%lx\n", val, offset);
-	printf(PREFIX PREFIX "expect to read 0x%lx bytes of data in total\n",
-	       expected);
+	ksft_print_msg("init val=%u with offset=0x%lx\n", val, offset);
+	ksft_print_msg("expect to read 0x%lx bytes of data in total\n",
+		       expected);
 	if (lseek(fd, offset, SEEK_SET) < 0) {
-		perror(PREFIX ERROR_PREFIX "seek failed");
+		ksft_perror("seek failed");
 		return false;
 	}
 
 	while (offset + total_ret_count < len) {
 		ret_count = read(fd, buf, wr_chunk_size);
 		if (ret_count == 0) {
-			printf(PREFIX PREFIX "read reach end of the file\n");
+			ksft_print_msg("read reach end of the file\n");
 			break;
 		} else if (ret_count < 0) {
-			perror(PREFIX ERROR_PREFIX "read failed");
+			ksft_perror("read failed");
 			break;
 		}
 		++val;
@@ -99,8 +102,8 @@ static bool seek_read_hugepage_filemap(int fd, size_t len, size_t wr_chunk_size,
 
 		total_ret_count += ret_count;
 	}
-	printf(PREFIX PREFIX "actually read 0x%lx bytes of data in total\n",
-	       total_ret_count);
+	ksft_print_msg("actually read 0x%lx bytes of data in total\n",
+		       total_ret_count);
 
 	return total_ret_count == expected;
 }
@@ -113,15 +116,15 @@ static bool read_hugepage_filemap(int fd, size_t len,
 	ssize_t total_ret_count = 0;
 	char val = 0;
 
-	printf(PREFIX PREFIX "expect to read 0x%lx bytes of data in total\n",
-	       expected);
+	ksft_print_msg("expect to read 0x%lx bytes of data in total\n",
+		       expected);
 	while (total_ret_count < len) {
 		ret_count = read(fd, buf, wr_chunk_size);
 		if (ret_count == 0) {
-			printf(PREFIX PREFIX "read reach end of the file\n");
+			ksft_print_msg("read reach end of the file\n");
 			break;
 		} else if (ret_count < 0) {
-			perror(PREFIX ERROR_PREFIX "read failed");
+			ksft_perror("read failed");
 			break;
 		}
 		++val;
@@ -130,8 +133,8 @@ static bool read_hugepage_filemap(int fd, size_t len,
 
 		total_ret_count += ret_count;
 	}
-	printf(PREFIX PREFIX "actually read 0x%lx bytes of data in total\n",
-	       total_ret_count);
+	ksft_print_msg("actually read 0x%lx bytes of data in total\n",
+		       total_ret_count);
 
 	return total_ret_count == expected;
 }
@@ -143,14 +146,14 @@ test_hugetlb_read(int fd, size_t len, size_t wr_chunk_size)
 	char *filemap = NULL;
 
 	if (ftruncate(fd, len) < 0) {
-		perror(PREFIX ERROR_PREFIX "ftruncate failed");
+		ksft_perror("ftruncate failed");
 		return status;
 	}
 
 	filemap = mmap(NULL, len, PROT_READ | PROT_WRITE,
 		       MAP_SHARED | MAP_POPULATE, fd, 0);
 	if (filemap == MAP_FAILED) {
-		perror(PREFIX ERROR_PREFIX "mmap for primary mapping failed");
+		ksft_perror("mmap for primary mapping failed");
 		goto done;
 	}
 
@@ -163,7 +166,7 @@ test_hugetlb_read(int fd, size_t len, size_t wr_chunk_size)
 	munmap(filemap, len);
 done:
 	if (ftruncate(fd, 0) < 0) {
-		perror(PREFIX ERROR_PREFIX "ftruncate back to 0 failed");
+		ksft_perror("ftruncate back to 0 failed");
 		status = TEST_FAILED;
 	}
 
@@ -180,14 +183,14 @@ test_hugetlb_read_hwpoison(int fd, size_t len, size_t wr_chunk_size,
 	const unsigned long pagesize = getpagesize();
 
 	if (ftruncate(fd, len) < 0) {
-		perror(PREFIX ERROR_PREFIX "ftruncate failed");
+		ksft_perror("ftruncate failed");
 		return status;
 	}
 
 	filemap = mmap(NULL, len, PROT_READ | PROT_WRITE,
 		       MAP_SHARED | MAP_POPULATE, fd, 0);
 	if (filemap == MAP_FAILED) {
-		perror(PREFIX ERROR_PREFIX "mmap for primary mapping failed");
+		ksft_perror("mmap for primary mapping failed");
 		goto done;
 	}
 
@@ -202,7 +205,7 @@ test_hugetlb_read_hwpoison(int fd, size_t len, size_t wr_chunk_size,
 	 */
 	hwp_addr = filemap + len / 2 + pagesize;
 	if (madvise(hwp_addr, pagesize, MADV_HWPOISON) < 0) {
-		perror(PREFIX ERROR_PREFIX "MADV_HWPOISON failed");
+		ksft_perror("MADV_HWPOISON failed");
 		goto unmap;
 	}
 
@@ -229,7 +232,7 @@ test_hugetlb_read_hwpoison(int fd, size_t len, size_t wr_chunk_size,
 	munmap(filemap, len);
 done:
 	if (ftruncate(fd, 0) < 0) {
-		perror(PREFIX ERROR_PREFIX "ftruncate back to 0 failed");
+		ksft_perror("ftruncate back to 0 failed");
 		status = TEST_FAILED;
 	}
 
@@ -242,17 +245,17 @@ static int create_hugetlbfs_file(struct statfs *file_stat)
 
 	fd = memfd_create("hugetlb_tmp", MFD_HUGETLB);
 	if (fd < 0) {
-		perror(PREFIX ERROR_PREFIX "could not open hugetlbfs file");
+		ksft_perror("could not open hugetlbfs file");
 		return -1;
 	}
 
 	memset(file_stat, 0, sizeof(*file_stat));
 	if (fstatfs(fd, file_stat)) {
-		perror(PREFIX ERROR_PREFIX "fstatfs failed");
+		ksft_perror("fstatfs failed");
 		goto close;
 	}
 	if (file_stat->f_type != HUGETLBFS_MAGIC) {
-		printf(PREFIX ERROR_PREFIX "not hugetlbfs file\n");
+		ksft_print_msg("not hugetlbfs file\n");
 		goto close;
 	}
 
@@ -264,7 +267,7 @@ static int create_hugetlbfs_file(struct statfs *file_stat)
 
 static void sigbus_handler(int sig)
 {
-	printf(PREFIX "received SIGBUS\n");
+	ksft_print_msg("received SIGBUS\n");
 }
 
 int main(void)
@@ -279,51 +282,44 @@ int main(void)
 	};
 	size_t i;
 
+	ksft_print_header();
+	ksft_set_plan(ARRAY_SIZE(wr_chunk_sizes) * 3);
+
 	signal(SIGBUS, sigbus_handler);
 	for (i = 0; i < ARRAY_SIZE(wr_chunk_sizes); ++i) {
-		printf("Write/read chunk size=0x%lx\n",
-		       wr_chunk_sizes[i]);
+		ksft_print_msg("Write/read chunk size=0x%lx\n",
+			       wr_chunk_sizes[i]);
 
 		fd = create_hugetlbfs_file(&file_stat);
 		if (fd < 0)
-			goto create_failure;
-		printf(PREFIX "HugeTLB read regression test...\n");
+			ksft_exit_fail_msg("Failed to create hugetlbfs file\n");
+
 		status = test_hugetlb_read(fd, file_stat.f_bsize,
 					   wr_chunk_sizes[i]);
-		printf(PREFIX "HugeTLB read regression test...%s\n",
-		       status_to_str(status));
 		close(fd);
-		if (status == TEST_FAILED)
-			return -1;
+		report_status(status, "HugeTLB read regression",
+			      wr_chunk_sizes[i]);
 
 		fd = create_hugetlbfs_file(&file_stat);
 		if (fd < 0)
-			goto create_failure;
-		printf(PREFIX "HugeTLB read HWPOISON test...\n");
+			ksft_exit_fail_msg("Failed to create hugetlbfs file\n");
+
 		status = test_hugetlb_read_hwpoison(fd, file_stat.f_bsize,
 						    wr_chunk_sizes[i], false);
-		printf(PREFIX "HugeTLB read HWPOISON test...%s\n",
-		       status_to_str(status));
 		close(fd);
-		if (status == TEST_FAILED)
-			return -1;
+		report_status(status, "HugeTLB read HWPOISON",
+			      wr_chunk_sizes[i]);
 
 		fd = create_hugetlbfs_file(&file_stat);
 		if (fd < 0)
-			goto create_failure;
-		printf(PREFIX "HugeTLB seek then read HWPOISON test...\n");
+			ksft_exit_fail_msg("Failed to create hugetlbfs file\n");
+
 		status = test_hugetlb_read_hwpoison(fd, file_stat.f_bsize,
 						    wr_chunk_sizes[i], true);
-		printf(PREFIX "HugeTLB seek then read HWPOISON test...%s\n",
-		       status_to_str(status));
 		close(fd);
-		if (status == TEST_FAILED)
-			return -1;
+		report_status(status, "HugeTLB seek then read HWPOISON",
+			      wr_chunk_sizes[i]);
 	}
 
-	return 0;
-
-create_failure:
-	printf(ERROR_PREFIX "Abort test: failed to create hugetlbfs file\n");
-	return -1;
+	ksft_finished();
 }
-- 
2.53.0


