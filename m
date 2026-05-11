Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EFE2CD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:30:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 979A26B00D5; Mon, 11 May 2026 12:30:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94FF56B00D9; Mon, 11 May 2026 12:30:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88E396B00DD; Mon, 11 May 2026 12:30:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7B1EE6B00D5
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:30:11 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 41DF016020A
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:30:11 +0000 (UTC)
X-FDA: 84755676222.30.2BCD395
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 834FB40012
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:30:09 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XHU+5nAu;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778517009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LWd20Bd1E5Xpb4wqKmnKNotCaxQUhJItNxOL+HL+mCU=;
	b=QZaPeS2Mt0AmU0Ak81reGKaC7I1J3fZCt+QQrdoIwbXjMCCm1lX8kopaNgJyAw649C3/KB
	nYeVz2G0VKBwpdjyknBHjByN366+u8joMd/+4KS73/fjML3qSEy/yntymiDXhhu/bH46W8
	r3FmGAPjrHFYYowE9SAKdof+pLzg71Q=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XHU+5nAu;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778517009; a=rsa-sha256;
	cv=none;
	b=YDjZsn4UxYxUr3st4jS+HtNNTRJRtSUD8eJFCrkB9lLd6j3sGSTUg40GlaaG/9XXYmIuo7
	uquBLsiwjozIAeQuQwJlwLBuSg1K0DVTu66tnS5e3xCYsPPPIoKsN7knSQWOXCEhqecE+Q
	RRpykID9pzpNhMSiqgQEwSZvpsZE0zU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AFFFC4397A;
	Mon, 11 May 2026 16:30:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89687C2BD00;
	Mon, 11 May 2026 16:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778517008;
	bh=pkWayHc5l3npAnyeew0LU5AlZfV7NxEtimp+admn4ik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XHU+5nAurfJc5dG4FmVmlVsxohA85Rz3BBFpa64XVVlQhEifwVCxCQqLG5xvxS1ks
	 RxYr+slqRj95p8xmlRWK7FDENtvS6ieWemKlFWGD2l1l6h6B6OE+VtAwQ1ilW+9o3j
	 IxDpTvO+QZlCbNlUrOtp4Lzdv9Q4CTza/2NONL0xAbbQarQpher3NYNgmEhNtgX3RS
	 H/Vkp9OcDRo5+RIuOOfrnTE2nBJKM7sxr5K7ISoRhsVAJScqaBaldwQf3kcZP/+nKI
	 08wAUqLiTrCIxE/GeT9W/pJOe5mnmRnRjaUyRSgNwjd31siDBt/FFvRYsypxYWoDlN
	 OncTx2vqZhX+w==
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
	Li Wang <li.wang@linux.dev>,
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
Subject: [PATCH v4 12/55] selftests/mm: hugetlb-read-hwpoison: use kselftest framework
Date: Mon, 11 May 2026 19:27:56 +0300
Message-ID: <20260511162840.375890-13-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511162840.375890-1-rppt@kernel.org>
References: <20260511162840.375890-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 834FB40012
X-Rspam-User: 
X-Stat-Signature: kuoc8mtma489sntkkiihpfwfbbphgeeg
X-HE-Tag: 1778517009-346547
X-HE-Meta: U2FsdGVkX1+TzG7Ao0dsqj9J0WbboTt9jJbnQkHyzBMupGFyyQBj7Gg1tcAL6pOcAQe/2b1CLr2DaVLMKQDRoUcT9u83ZKJ0m544X/tmxIxgwvybyvk6jj5lbAnts9im6sGcdsKn3ATcdY17nyDuYlV4Xt+ZShpI61RbKpBlynzWBCIQr6jE0TythKYN7tL8elzVgoOCuV+kaMs17DsQZccn5U6Jpextw3LwWwkDAsiL/mEyPXGU/NgscakJrXs/MxW8OczK+KxLI40iUmng5DZLQPrpz1FjqWzlKqokxvK1MTRSXfSYaUb/BSj3UDGcOwMEeUsgWjW+cKRg1lYT3BdJ8JlsBhkOrKpSqbB2Ln4wTgs3JkJgP7JQ4ynq9uorrj8PExuS2V1hB/Pw2RgMO3AGWM3oCF+7Ip0699DWUtx5Qy0pxlEw0T53UDcuqbiBBhueKyzVF/xkvrTSEeg5BdBbsdOO8xzQZTshmwQ13gteq0OMROryJyhizBlR6TJH5VkiriM9RfhdnpYHoMZ6W7zTrrjU6Cvau9YRsDF38l/eoeQb+6WQ/mEr7om/7raR2dQI2hzTA2nDaJM1M8AXXAaQXcjHCaoqo/vyCJl8flKJRscJOUjY9p8pEavEfgvb3XHut/PagmgJYSToELKnIDIc7+bM7ynKPB6iQWuMCns1C0gR1i528hdS+tnF7MD7lkZ/96ukrNk0PLLxQZE5mmslcsF3DYniXzfYKz7MEaUVJK1VipVk01eFQELLGav8SjqNXmiyShNBysJm0B5CGkmpxoNCSiFCkIdHZ4MoEoaUt99xs8NwjD4gW4bOMi1CwUY35BGH1E1h/hn02D5C9sxbcNXo3OFdxGCeY0/GItyXHeax2GtPrWVdPEdxn2uBT6avsJOB7Lw/3d8t/RIEgVSKlvz4WsPoM9aS5ffZBt2JDUyHiCawwzzS6pEVCeYLwX95uwGEhqJGQcaov3q
 CtyDF5mU
 5PuAm03OnqA3y4MxGVT6J8Q0UCnD38sGqvXSm3BoWudLBwDeOKZl9Ox5hGTtHSFX3qhc9w/cUso9TRp9W1gFOFkHCJYFtDLOaBAtKy8Dsv3g4J5PZqAp9l70ZKOo/QY6JMkV2BHqU1O9+BZXmZe+LErKKBBrD1AqpbIoRwWcchwv0OzG2rvgOQJ3bwQyOHMOk7Yb20K00cNuTWZt4fnaupLaBjoxJ7kmnOIKcM+NiU1zrKEYZfMa5JF1ekvACCaQk59z2OnnGWKX/HShBGFNZXvCC7uXkHg7yY4g38YE5J1nIPts5iyQMqDfFgPT2Vq/lP0hT1QDrgJqWo4bGxJNy38h86Q==
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
Tested-by: Li Wang <li.wang@linux.dev>
Reviewed-by: Li Wang <li.wang@linux.dev>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Tested-by: Luiz Capitulino <luizcap@redhat.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 .../selftests/mm/hugetlb-read-hwpoison.c      | 115 +++++++++---------
 1 file changed, 55 insertions(+), 60 deletions(-)

diff --git a/tools/testing/selftests/mm/hugetlb-read-hwpoison.c b/tools/testing/selftests/mm/hugetlb-read-hwpoison.c
index ad3198b444ce..70b24e3660c4 100644
--- a/tools/testing/selftests/mm/hugetlb-read-hwpoison.c
+++ b/tools/testing/selftests/mm/hugetlb-read-hwpoison.c
@@ -14,9 +14,6 @@
 
 #include "kselftest.h"
 
-#define PREFIX " ... "
-#define ERROR_PREFIX " !!! "
-
 #define MAX_WRITE_READ_CHUNK_SIZE (getpagesize() * 16)
 #define MAX(a, b) (((a) > (b)) ? (a) : (b))
 
@@ -26,17 +23,22 @@ enum test_status {
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
 
@@ -59,8 +61,8 @@ static bool verify_chunk(char *buf, size_t len, char val)
 
 	for (i = 0; i < len; ++i) {
 		if (buf[i] != val) {
-			printf(PREFIX ERROR_PREFIX "check fail: buf[%lu] = %u != %u\n",
-				i, buf[i], val);
+			ksft_print_msg("check fail: buf[%lu] = %u != %u\n",
+				       i, buf[i], val);
 			return false;
 		}
 	}
@@ -76,21 +78,21 @@ static bool seek_read_hugepage_filemap(int fd, size_t len, size_t wr_chunk_size,
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
@@ -99,8 +101,8 @@ static bool seek_read_hugepage_filemap(int fd, size_t len, size_t wr_chunk_size,
 
 		total_ret_count += ret_count;
 	}
-	printf(PREFIX PREFIX "actually read 0x%lx bytes of data in total\n",
-	       total_ret_count);
+	ksft_print_msg("actually read 0x%lx bytes of data in total\n",
+		       total_ret_count);
 
 	return total_ret_count == expected;
 }
@@ -113,15 +115,15 @@ static bool read_hugepage_filemap(int fd, size_t len,
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
@@ -130,8 +132,8 @@ static bool read_hugepage_filemap(int fd, size_t len,
 
 		total_ret_count += ret_count;
 	}
-	printf(PREFIX PREFIX "actually read 0x%lx bytes of data in total\n",
-	       total_ret_count);
+	ksft_print_msg("actually read 0x%lx bytes of data in total\n",
+		       total_ret_count);
 
 	return total_ret_count == expected;
 }
@@ -143,14 +145,14 @@ test_hugetlb_read(int fd, size_t len, size_t wr_chunk_size)
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
 
@@ -163,7 +165,7 @@ test_hugetlb_read(int fd, size_t len, size_t wr_chunk_size)
 	munmap(filemap, len);
 done:
 	if (ftruncate(fd, 0) < 0) {
-		perror(PREFIX ERROR_PREFIX "ftruncate back to 0 failed");
+		ksft_perror("ftruncate back to 0 failed");
 		status = TEST_FAILED;
 	}
 
@@ -180,14 +182,14 @@ test_hugetlb_read_hwpoison(int fd, size_t len, size_t wr_chunk_size,
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
 
@@ -202,7 +204,7 @@ test_hugetlb_read_hwpoison(int fd, size_t len, size_t wr_chunk_size,
 	 */
 	hwp_addr = filemap + len / 2 + pagesize;
 	if (madvise(hwp_addr, pagesize, MADV_HWPOISON) < 0) {
-		perror(PREFIX ERROR_PREFIX "MADV_HWPOISON failed");
+		ksft_perror("MADV_HWPOISON failed");
 		goto unmap;
 	}
 
@@ -229,7 +231,7 @@ test_hugetlb_read_hwpoison(int fd, size_t len, size_t wr_chunk_size,
 	munmap(filemap, len);
 done:
 	if (ftruncate(fd, 0) < 0) {
-		perror(PREFIX ERROR_PREFIX "ftruncate back to 0 failed");
+		ksft_perror("ftruncate back to 0 failed");
 		status = TEST_FAILED;
 	}
 
@@ -242,17 +244,17 @@ static int create_hugetlbfs_file(struct statfs *file_stat)
 
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
 
@@ -278,51 +280,44 @@ int main(void)
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


