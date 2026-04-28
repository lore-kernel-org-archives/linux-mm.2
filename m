Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77427FF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 20:43:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0EB16B009B; Tue, 28 Apr 2026 16:43:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC03E6B009D; Tue, 28 Apr 2026 16:43:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD5686B009E; Tue, 28 Apr 2026 16:43:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BB8D86B009B
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:43:33 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3A1971B972A
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:43:33 +0000 (UTC)
X-FDA: 84709140306.22.D326C06
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7B4258000C
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:43:31 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sNWHpLes;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777409011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dSE4XRTFupueAG7YCbonlwEmlAse5HTOqKUXsK9ACAk=;
	b=rQr2/v0FhDpdMvw8fgdBWjOPotMQ7y1Q+dWb3GjqxY2ouFMARlK4XH1HsD/TOzpH0OpPzV
	8BdyhL3VgV/D+ibASQI1R/CyYrS1DIGPgBcH7VVhTAEsvrSLGhcx+B1GpOM9WqrIRzR7bU
	OFfqa3uqtRIMEmU0ExkdeZxT1GoBTtU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sNWHpLes;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777409011; a=rsa-sha256;
	cv=none;
	b=W/5390u+CvpIyYVkeSG9btjchDQAhCbPW7H01vo4ZNBN3irgs2I3qKRtQme4nzLJOITnEt
	IIuJYQ6SmAy3Jnu8gybKwVvsycmZhY8GmM5MZzwjOGP/cIB9LQC63M2bSFTo4UBbiHbOG3
	hmlXtA8hp5IXAi45aUrQ6c5MvXkTqFk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F0E246132E;
	Tue, 28 Apr 2026 20:43:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9628DC2BCAF;
	Tue, 28 Apr 2026 20:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777409010;
	bh=0Xw45rszAEbFQUh2ZztIRx13l4Zw/sywyZ9vzo8mOnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sNWHpLesWI7IebZX6J51fywpdE+qz+SJaz661LpdtMcgjf/9rrehQBzVdNPn+QGnh
	 uNN+Gno4IE5iveQdXGOPZ2Kadgq6OM4dgBfK1a4qMxk0Ofqxu2SJhEtBzWMBkZ872Q
	 Qy/NF/3GHAX8ymlEXi3998hvb/H0nj2FnnlcsFEx2hl5fDHnOk7HcevRJScVAIW0F+
	 qGVjTIkjBHxHLkAnSzVLUXHjXtUGA2h9uk06xgOV+7MTBRzHxRGh5RcHz/onqwlfgV
	 9/WGgYPTmEijd+9u7Yh3DNjJmsIq8Q+LQqL8Q1YuJnAJWC8M1Vnn3twsuyzfoAiRfx
	 MQLzJuqthl7HQ==
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
Subject: [PATCH v3 06/54] selftests/mm: merge map_hugetlb into hugepage-mmap
Date: Tue, 28 Apr 2026 23:41:52 +0300
Message-ID: <20260428204240.1924129-7-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428204240.1924129-1-rppt@kernel.org>
References: <20260428204240.1924129-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: msjoscjoizcx3wds9kd1xsmmxozcdxqc
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7B4258000C
X-Rspam-User: 
X-HE-Tag: 1777409011-72945
X-HE-Meta: U2FsdGVkX1/S9VP34M25fomRQfAO3lw3+Gd25q3pihcw4GywVIv3E3K6N5gYdyIclrMrFF73bpflB5tmvKB8iVUAYRL6mep6U676+YYi4tw6DFRJkpOCLTc9wHSHsef25AoU4XXCsW8dpngH+QCOLkHSgUk/Pc+sW4TuDbxMzo2RJkwaGradgEbqKVrwBPxglxQCWImJvuorj2nYMh+8UBVVtGQkbdV58p9vhjlGQZZdHZ/L3JpMSI1o2SweiXyVdfeEZ0epcBST/luWsOm6PVj9KyXfA1WlZK8YyFPf3i2DC2czc1SQjYXT+YkJuCyOjHDQshuC8xunFvG7TsrjcOnXRnd8mUIv3XOUwamp2DIkSJIYqURQZaHgKcykj1wPrYDPjsEGQ9LqraKdend0rOdXeEU3F5GazK97rMSbHtZD+gedGMmLTRlQ1Ap2WyLMvWnotMeLtWH/9QBWkHErwp0Jq30FtYbto4sLLrXnuZKhymD9Pr9hFo+zxetmi477Gjz2l08uckkdLCA6eAOU9CrXUeHlpPNHYLoAy5P8mh8H+aTVOVPwvEEtOw7kAIrJoP6fALLYH8aiiySJgYmJBW6y+WnAjhTO496BRh6wgsZ1s4xuMMyc4/txlmH4DkHCf8/NqlNCRXirzBZrcPo4kfGYEA8TOIKkSFiWBO/l//VwFBKSDfh/5TQjVQ5yvfgOEw2K2yikfBRNkkw1Dgcrw+VWGXkBtZNABUQVH/yC4yJJutzL47vkJ/3UtJCtYVbcbUgsoF9NQIJW0nxiD+iYtPgbrsI1OSsQd25XfnrnSBkm/8d+dNUboCBf9pf71SAO1/lyBz8nhZnzWesfss2gU1Hs5laafthOJhkmsTmAX9lCRdirz08smNVh2QEMU/hICt6IM5U0odbFKNkwtRvLCo5rfTp+7zpdaEolrOg4b7yHVIljIYJjhFlCasOo4tv9luMtWsxYQsab1g1fJMU
 nyJrRgEF
 aglT5sf4PVdOrwG/BodWYblkOhI0WXR1vDkTqefghpyCuth0rhC52KG5ga+b/Fj/nZQ8yfCRGxlVURKaNerqVOzPjZTUEw2QsAxjS5mMTODDTY935dkDvQ4U7zod3suhRevNOgQZ0tMJ6CJ2hx9roOJFsK2thPMz82MG4iRkBAEzENdRJa9lApujqOmIL4r/JpM8w2eajQM5zNW6SmyJuXxqXnjr9bS+OD4mwmD59QL4+k5UtwzPho5aGgLZqB4QrI8mpoPnSSzb0YIuDl4BokkMLYQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Both tests create a hugettlb mapping, fill it with data and verify the
data, the only difference is that one uses file-backed memory and another
one uses anonymous memory.

Merge both tests into a single file.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/Makefile        |   1 -
 tools/testing/selftests/mm/hugepage-mmap.c | 111 ++++++++++++++++-----
 tools/testing/selftests/mm/map_hugetlb.c   |  88 ----------------
 tools/testing/selftests/mm/run_vmtests.sh  |   1 -
 4 files changed, 86 insertions(+), 115 deletions(-)
 delete mode 100644 tools/testing/selftests/mm/map_hugetlb.c

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index cd24596cdd27..cbda989f6b6a 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -70,7 +70,6 @@ TEST_GEN_FILES += hugepage-vmemmap
 TEST_GEN_FILES += khugepaged
 TEST_GEN_FILES += madv_populate
 TEST_GEN_FILES += map_fixed_noreplace
-TEST_GEN_FILES += map_hugetlb
 TEST_GEN_FILES += map_populate
 ifneq (,$(filter $(ARCH),arm64 riscv riscv64 x86 x86_64 loongarch32 loongarch64))
 TEST_GEN_FILES += memfd_secret
diff --git a/tools/testing/selftests/mm/hugepage-mmap.c b/tools/testing/selftests/mm/hugepage-mmap.c
index d543419de040..fa886ec148c2 100644
--- a/tools/testing/selftests/mm/hugepage-mmap.c
+++ b/tools/testing/selftests/mm/hugepage-mmap.c
@@ -15,6 +15,8 @@
 #include <unistd.h>
 #include <sys/mman.h>
 #include <fcntl.h>
+#include <linux/memfd.h>
+#include "vm_util.h"
 #include "kselftest.h"
 
 #define LENGTH (256UL*1024*1024)
@@ -25,54 +27,113 @@ static void check_bytes(char *addr)
 	ksft_print_msg("First hex is %x\n", *((unsigned int *)addr));
 }
 
-static void write_bytes(char *addr)
+static void write_bytes(char *addr, size_t length)
 {
 	unsigned long i;
 
-	for (i = 0; i < LENGTH; i++)
+	for (i = 0; i < length; i++)
 		*(addr + i) = (char)i;
 }
 
-static int read_bytes(char *addr)
+static bool verify_bytes(char *addr, size_t length)
 {
 	unsigned long i;
 
 	check_bytes(addr);
-	for (i = 0; i < LENGTH; i++)
+	for (i = 0; i < length; i++)
 		if (*(addr + i) != (char)i) {
-			ksft_print_msg("Error: Mismatch at %lu\n", i);
-			return 1;
+			ksft_print_msg("Error: Mismatch at %lu(%p)\n", i, addr);
+			return false;
 		}
-	return 0;
+
+	return true;
 }
 
-int main(void)
+static bool test_mmap(size_t length, int mmap_flags, int fd,
+		      const char *test_name)
 {
 	void *addr;
-	int fd, ret;
 
-	ksft_print_header();
-	ksft_set_plan(1);
+	addr = mmap(NULL, length, PROTECTION, mmap_flags, fd, 0);
+	if (addr == MAP_FAILED)
+		ksft_exit_fail_perror("mmap");
+
+	ksft_print_msg("Returned address is %p\n", addr);
+	check_bytes(addr);
+	write_bytes(addr, length);
+	if (!verify_bytes(addr, length))
+		ksft_exit_fail_msg("%s\n", test_name);
+
+	/* munmap() length of MAP_HUGETLB memory must be hugepage aligned */
+	if (munmap(addr, length))
+		ksft_exit_fail_perror("munmap");
+
+	return true;
+}
+
+static void test_anon_mmap(size_t length, int shift)
+{
+	const char *test_name = "hugetlb anonymous mmap";
+	int mmap_flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB;
+	bool passed;
+
+	if (shift)
+		mmap_flags |= (shift & MAP_HUGE_MASK) << MAP_HUGE_SHIFT;
+
+	passed = test_mmap(length, mmap_flags, -1, test_name);
+	ksft_test_result(passed, "%s\n", test_name);
+}
+
+static void test_file_mmap(size_t length, int shift)
+{
+	const char *test_name = "hugetlb file mmap";
+	int mfd_flags = MFD_HUGETLB;
+	bool passed;
+	int fd;
+
+	if (shift)
+		mfd_flags |= (shift & MFD_HUGE_MASK) << MFD_HUGE_SHIFT;
 
-	fd = memfd_create("hugepage-mmap", MFD_HUGETLB);
+	fd = memfd_create("hugetlb-mmap", mfd_flags);
 	if (fd < 0)
-		ksft_exit_fail_msg("memfd_create() failed: %s\n", strerror(errno));
+		ksft_exit_fail_perror("memfd_create");
+
+	passed = test_mmap(length, MAP_SHARED, fd, test_name);
+
+	close(fd);
+	ksft_test_result(passed, "%s\n", test_name);
+}
+
+int main(int argc, char **argv)
+{
+	size_t hugepage_size;
+	size_t length = LENGTH;
+	int shift = 0;
+
+	ksft_print_header();
+	ksft_set_plan(2);
+
+	if (argc > 1)
+		length = atol(argv[1]) << 20;
+	if (argc > 2)
+		shift = atoi(argv[2]);
 
-	addr = mmap(NULL, LENGTH, PROTECTION, MAP_SHARED, fd, 0);
-	if (addr == MAP_FAILED) {
-		close(fd);
-		ksft_exit_fail_msg("mmap(): %s\n", strerror(errno));
+	if (shift) {
+		hugepage_size = (1 << shift);
+		ksft_print_msg("%u kB hugepages\n", 1 << (shift - 10));
+	} else {
+		hugepage_size = default_huge_page_size();
+		ksft_print_msg("Default size hugepages (%lu Kb)\n", hugepage_size >> 10);
 	}
 
-	ksft_print_msg("Returned address is %p\n", addr);
-	check_bytes(addr);
-	write_bytes(addr);
-	ret = read_bytes(addr);
+	/* munmap with fail if the length is not page aligned */
+	if (hugepage_size > length)
+		length = hugepage_size;
 
-	munmap(addr, LENGTH);
-	close(fd);
+	ksft_print_msg("Mapping %lu Mbytes\n", (unsigned long)length >> 20);
 
-	ksft_test_result(!ret, "Read same data\n");
+	test_anon_mmap(length, shift);
+	test_file_mmap(length, shift);
 
-	ksft_exit(!ret);
+	ksft_finished();
 }
diff --git a/tools/testing/selftests/mm/map_hugetlb.c b/tools/testing/selftests/mm/map_hugetlb.c
deleted file mode 100644
index aa409107611b..000000000000
--- a/tools/testing/selftests/mm/map_hugetlb.c
+++ /dev/null
@@ -1,88 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Example of using hugepage memory in a user application using the mmap
- * system call with MAP_HUGETLB flag.  Before running this program make
- * sure the administrator has allocated enough default sized huge pages
- * to cover the 256 MB allocation.
- */
-#include <stdlib.h>
-#include <stdio.h>
-#include <unistd.h>
-#include <sys/mman.h>
-#include <fcntl.h>
-#include "vm_util.h"
-#include "kselftest.h"
-
-#define LENGTH (256UL*1024*1024)
-#define PROTECTION (PROT_READ | PROT_WRITE)
-
-static void check_bytes(char *addr)
-{
-	ksft_print_msg("First hex is %x\n", *((unsigned int *)addr));
-}
-
-static void write_bytes(char *addr, size_t length)
-{
-	unsigned long i;
-
-	for (i = 0; i < length; i++)
-		*(addr + i) = (char)i;
-}
-
-static void read_bytes(char *addr, size_t length)
-{
-	unsigned long i;
-
-	check_bytes(addr);
-	for (i = 0; i < length; i++)
-		if (*(addr + i) != (char)i)
-			ksft_exit_fail_msg("Mismatch at %lu\n", i);
-
-	ksft_test_result_pass("Read correct data\n");
-}
-
-int main(int argc, char **argv)
-{
-	void *addr;
-	size_t hugepage_size;
-	size_t length = LENGTH;
-	int flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB;
-	int shift = 0;
-
-	hugepage_size = default_huge_page_size();
-	/* munmap with fail if the length is not page aligned */
-	if (hugepage_size > length)
-		length = hugepage_size;
-
-	ksft_print_header();
-	ksft_set_plan(1);
-
-	if (argc > 1)
-		length = atol(argv[1]) << 20;
-	if (argc > 2) {
-		shift = atoi(argv[2]);
-		if (shift)
-			flags |= (shift & MAP_HUGE_MASK) << MAP_HUGE_SHIFT;
-	}
-
-	if (shift)
-		ksft_print_msg("%u kB hugepages\n", 1 << (shift - 10));
-	else
-		ksft_print_msg("Default size hugepages\n");
-	ksft_print_msg("Mapping %lu Mbytes\n", (unsigned long)length >> 20);
-
-	addr = mmap(NULL, length, PROTECTION, flags, -1, 0);
-	if (addr == MAP_FAILED)
-		ksft_exit_fail_msg("mmap: %s\n", strerror(errno));
-
-	ksft_print_msg("Returned address is %p\n", addr);
-	check_bytes(addr);
-	write_bytes(addr, length);
-	read_bytes(addr, length);
-
-	/* munmap() length of MAP_HUGETLB memory must be hugepage aligned */
-	if (munmap(addr, length))
-		ksft_exit_fail_msg("munmap: %s\n", strerror(errno));
-
-	ksft_finished();
-}
diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index e2dc9ac87bfc..61b450032af8 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -292,7 +292,6 @@ CATEGORY="hugetlb" run_test ./hugepage-shm
 echo "$shmmax" > /proc/sys/kernel/shmmax
 echo "$shmall" > /proc/sys/kernel/shmall
 
-CATEGORY="hugetlb" run_test ./map_hugetlb
 CATEGORY="hugetlb" run_test ./hugepage-mremap
 CATEGORY="hugetlb" run_test ./hugepage-vmemmap
 CATEGORY="hugetlb" run_test ./hugetlb-madvise
-- 
2.53.0


