Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B4E8F46C45
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 14:18:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2DBC6B00A9; Mon,  6 Apr 2026 10:18:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDE026B00AB; Mon,  6 Apr 2026 10:18:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF3456B00AC; Mon,  6 Apr 2026 10:18:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9E6F36B00A9
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 10:18:52 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6AC79E1550
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:18:52 +0000 (UTC)
X-FDA: 84628337304.07.2D72533
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id C1241100006
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:18:50 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VOBs53ik;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775485130; a=rsa-sha256;
	cv=none;
	b=Perwm+d9ZC0bTBkxEMjpQTuhDoaeVtblEOTksE/vul6tNXtYQogpZJSNq9YV1vnaUwBZ24
	zt2Z794YbMDFEDbN0FJ9OOrVHOJrjDUbHK7rp583pMz25ZMnHl0RO9bmhyTqMaB1tQGj4t
	7Iwvr94T3jdN3TSb1qtWjwGsFXxek8A=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VOBs53ik;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775485130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+JonJrpkLB87zzV0N7t4xpy166Xm1KRT7YlyAmQmdjQ=;
	b=EJc8zMROm6LR0Irv0PR3GKwf20xgO8jXjadFV639ZjYORFsdP8Eh9g1BssMcvPEL5XHBCG
	u5XqyWLMRrXYQ/fBhfY4Rb6JKR9ti+0FVApCJee1T2ZYv6Wsn7P/0lqez4076g33NS9IV8
	KNKYxlxoW0oPc/lf5p3ePIF2qIoLy0M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 165D360123;
	Mon,  6 Apr 2026 14:18:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82E39C4CEF7;
	Mon,  6 Apr 2026 14:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775485129;
	bh=PkEdAGyL9GZv6C343RMX0IGM2zFuHLbvmC+y8ai9FVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VOBs53ikh58KE4aiMuMuwW1gJvgV8aj0SmOrUKtK7OTdHxyZ4SEmHNODwIcONaCct
	 aqmmb7j+nZrmNHKCeJWw/Mob1+hU6m5fVkZ2IloLFoWl6xv7ZidJWCXFpKvCeFF6yI
	 b03tgVWhUYt/4YZlMh9KPHw9Oh1wH/ZnTyV5WTIjLEDjSny4+fxWUbrgOeaoyoirYM
	 2Ais8Akm0dhqTZsQpcxL2QRK+E91pNpkYTT13coPffbu6xWG0xComni7uWnUKp6Zfr
	 PEZg5+x8e598pOjRFQj6MDB6Swho6OFtIDaO5BTmIrDbtYtZzyPdR10M3hoOAJnwpn
	 hzDiz5aCH/5YQ==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nico Pache <npache@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 11/53] selftests/mm: hugetlb-read-hwpoison: use kselftest framework
Date: Mon,  6 Apr 2026 17:16:53 +0300
Message-ID: <20260406141735.2179309-12-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260406141735.2179309-1-rppt@kernel.org>
References: <20260406141735.2179309-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: tcu45z7c7bwg9oc1k93zkuw5ne14emcz
X-Rspamd-Queue-Id: C1241100006
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775485130-187762
X-HE-Meta: U2FsdGVkX1+X2lt7EqTjhut/DJ/UXmYIB67OiMmpzP+5SsUitjVjqeKUkEiy3xwGqzUiOYXp8AEc0BFe0Y8moIuhmPxuNe5v8HOBzFDzLVMUQjrqRU1l2hvnvi/xlsBqEkTi0dBYgoLxSMxq3JrI2SaDxRl+G/gf6Xv3YvWrjeKS+MIXpUaEVRvz889+yj/c9BsUkAoSb+zGsCGWV6eEje0fWdMBWnKvK2XJ960aILYqRjr8oSmYMkXbmnERFvjtwrWU0P3qvSyR2n0EfPNV2I80o+conoOcYRlZeTRRDNNZfr1LIzEgn2A8e39tbZjQ3El+OcNjDzgkiKyOih3SKqB/IV43qSVe20BFQnHwPd+ZdU7alZN1H3klydaJ8giqB1LWL4Kd6vOq9+jdwMYWNoD+xbLhRH3wiWcr6oyr8AW+o9vTGyRM7WEoMs4Knsol96OPQla2eU1oMMzTEtsStDH4i82a1eDIMpK6h8G12UMrQv5oNUxb7flsubjbGC41Uai9d0wtALe8oUHN05EOCzFPtoNcGRSuJU+yzmmUEkS0jacXglwHahLoreb9GTxOHp9wVRczjDZ+ihpv0mxOoaf/Tk6ecnJFL012WeVSI5McZGzL/m1MpyGti+hsaSFAXjoRlQDIKskVgusm/kCI/3lVMQxS4Y36KR9n2UhGG3RUfHpUk6Ym+3EuwATbsuzhCe+XmrAkd61qpJw1J8sG7uAwRdUjua4WCMD5e1usT7XW8YCNEn7TaGoWTsd8j/sLcHPQmfC7IEXONMEf5wDuDt2KdtgxTCA3qvHAEJXLaSgHv8Chjypj1HITJMLmKDrM4zI0QPGeCmEswmFT3aXszaM/vC4rn/PhU7ljkfnvc6ZhSUTr114NpdlGCmwFyi7KjHUNUk5fR0Z5aM3y4qdGxLNkvhxdzPbfTRqscpMYIRZS6jsF8726SoMcc5NqkdxBFEcGt5xPxjDOL9EYQMh
 OywyS8zS
 b5oid0Ma7TE8K6BGb8S4YSemwJ7baS6Zf+rG5P5ORaXGgdaUO4nH0eZulbexqOirthTqAMBESCgb3ilA/4FYkgSQpiYCW2vn4/bAq2/MHd2HDk1vWesdyEXSx6RwEiN8Vt0ibE/ZjYYXhpg/PNueIw2ePgNezjzkpht826dFevpi8fBzlLejiMbE4tUX3EJtfqEm01Qc4+gGFc+fB7lD+BNMTsxthwz9h8RZVD8kKsI1vY6M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Convert hugetlb-read-hwpoison test to use kselftest framework for
reporting and tracking successful and failing runs.

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


