Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DC97F46C45
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 14:18:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12F326B0096; Mon,  6 Apr 2026 10:18:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 107366B0098; Mon,  6 Apr 2026 10:18:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01D0C6B0099; Mon,  6 Apr 2026 10:18:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E598A6B0096
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 10:18:17 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8E543E0566
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:18:17 +0000 (UTC)
X-FDA: 84628335834.15.BFEF463
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id F1B8A40014
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:18:15 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dcz6DnPv;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dcz6DnPv;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775485096; a=rsa-sha256;
	cv=none;
	b=xYREypS3nVK/uNkdbC84wClZawrnFVP+HmqUrIWLvJj53L4FE3WT1oMAvkdYjNseZJ3eRe
	3Pl8/tYJlNGeMAwzr8cUNVjZY/QVVQ0nO1q+GqxRlj9BMPcpdv1uwJ5YmOvzDpw3MUaciY
	nwZIvte1zpZ9Fw2EfTu9Qu0yABdqVic=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775485096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UcBJsikZxmzNQ6voxbEm6Bi4QmPE5W8kkzDZxoK0Zsw=;
	b=f4hycDAzm4U1A2s0zBfgN3Py+2fEDbXI7dbsV257+1CvUdx6bNiI23fUKAXbS0Lvq0seCY
	clErhp21Rehy1vN88nSPjpy8bt4+qJT46F/buRTU3u8L8PZONNiLjKVcLiKx6P/7b7K0NT
	JEoooFqTwy0ABNiXsfT0TM5BdDcgQQw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 76C856012A;
	Mon,  6 Apr 2026 14:18:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1CA2C4CEF7;
	Mon,  6 Apr 2026 14:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775485095;
	bh=W4jslfUkZMLaDuTVLz/SpzkNKTO6vwroVT4wzIlVBmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dcz6DnPvxDmJObgi4JjFaQT08p8+iEqAIMRLMoPPZC9zhE8UXZvY1qcWvfkVUcb3K
	 9IC9PmtVcNhbI/WA7FTeDQgxgllG/hZKbwJINcMl/dAEC0PBLmoTXBwLI3VfY0+/De
	 Z1HPakhz109bMWv6i92nCKB5SJKIdN5UqFyw+089wVxXp44wwacuQv+W3ISAI/IUlf
	 iFMIFPH6mDREZYLWpeLS9BD0g5Cyw2T27YLgrmVsyEPudfbFu5BQPpjQxNF19bfaEi
	 0X8X/MKmwMjqzg0NBz3N8tGjlGVWGs4QKVkU3/DQdKQoRc2BuWsG8d+1+uftWfOOpD
	 71E6jHE6waI/Q==
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
Subject: [PATCH 05/53] selftests/mm: merge map_hugetlb into hugepage-mmap
Date: Mon,  6 Apr 2026 17:16:47 +0300
Message-ID: <20260406141735.2179309-6-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260406141735.2179309-1-rppt@kernel.org>
References: <20260406141735.2179309-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: F1B8A40014
X-Stat-Signature: s6qwy5ejfrsg9ygfp5sed4ujjbuq6qym
X-Rspam-User: 
X-HE-Tag: 1775485095-95284
X-HE-Meta: U2FsdGVkX1+1BQqs4qVzcobOykjGunRQfNg0xR3/W25REyg2305k11fJk66v1j89FKVZ1LXNAFIiC9dlf7iyPXRQhWot0xQGiJBKFTOQC38Du1QDaoLi22SpJUNBk541+GI8+4+CSxR/bibV3ziffQa/Q9qjfe0hGyZ1IPZwHBlPUbgAk7hI9eQVTXnrpiZ8PO6MQMyYX12vtKSy1AWw77UgAJoYKyv5gHyzgVz1BIQgsxufqbXxbcsZR0xOyoPcScAnWb4r+gbdAxhCYth6fDmavzrqOrZuuQ+59lUR2EgI+ywOmjEqx7b8IzNDFn8koy9+DYdBBqxBOiYZZl8cM/2QmUIA7wfvc1hDIcqLI5kGRPP4CTugEFkIZtSYsPm52Ahx1eqoRs5doStfcIRFT14zvMoPtcWKEVmZvxhgdKtzpDFVcLlZCg0GlRC0lBxjf9MGlTjgrLq5pHC9aJqJKR+PSik4+6ntXZGLHsMud++kqzi78+8f7HqoZoSWm7G816NiGZ3biEPnCv1gjrBJVQ4pP7zpVg6ejXAE3iYxEAhQNH1sWkqLZo6vmtiHbPx5djDnBxhELSceAHOAdA5KM95+pXnwZJ9a8jcJeLdE69Nuj/SLqrR9pn6NY59dR65ozbgrajIYo15DfR/IeyruwV+R99umONHWpc4Ub0KopuNjc8S1gTrlsNYAAHe1KEoz7i6BiXsEqCBZ1dH/rTAAEia9f9O6HYgdjn37zF5QIqmM8MDEwJ4U6X/UDLznOOaXh3ujs8Jm+QB747kBuLP3eD6PxTjBeKsXeh6bZ1uvMVbWHv85Qkj4mXs7YLaEM4XYDhZijLokuS9QTY116iDwTlf7hhucpF1T3vBeTfceNf/LgpU9BDGSNvmy76YXvikvn3bA+xevuDOpjvCrRDJn9rvrv9yNfQPckVEfreWuw02Atc/Go4UH83+/Bh5uDm0mNUe0EdMJ3xARHwvnOM0
 2JmVghHD
 1xymgcdkgii6S+E/NcKpKTTuhEly0JAmft1DhUbMlg46s8iSRZjqLQL2O1GIBstSv8mviTXsXOlUYQno1pxRD0eUGLI+Vlp6cLXokRKC6JN6ald8FXtobN9vfcy0kZJ5xyh41vZDG4jcbvQJRBPNF1zoCSvdfpaQn1prVElkBUTUQIBqh3YMyCSEpE5/fbWq7eBatUmVa0lB/2u9vtBBqLLqSMfJULRjunDHHN8kbMtQRdMzncH/v1RDvs0rhDqVkps6ZpOiWGDz5psMWu9ftPx1MwAZoJy8Ymb/M
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
 tools/testing/selftests/mm/hugepage-mmap.c | 113 ++++++++++++++++-----
 tools/testing/selftests/mm/map_hugetlb.c   |  88 ----------------
 tools/testing/selftests/mm/run_vmtests.sh  |   1 -
 4 files changed, 86 insertions(+), 117 deletions(-)
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
index d543419de040..de210043045a 100644
--- a/tools/testing/selftests/mm/hugepage-mmap.c
+++ b/tools/testing/selftests/mm/hugepage-mmap.c
@@ -15,6 +15,7 @@
 #include <unistd.h>
 #include <sys/mman.h>
 #include <fcntl.h>
+#include "vm_util.h"
 #include "kselftest.h"
 
 #define LENGTH (256UL*1024*1024)
@@ -25,54 +26,112 @@ static void check_bytes(char *addr)
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
-		if (*(addr + i) != (char)i) {
-			ksft_print_msg("Error: Mismatch at %lu\n", i);
-			return 1;
-		}
-	return 0;
+	for (i = 0; i < length; i++)
+		if (*(addr + i) != (char)i)
+			return false;
+
+	return true;
 }
 
-int main(void)
+static bool test_mmap(size_t length, int mmap_flags, int fd,
+		      const char *test_name)
 {
+	int flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB;
 	void *addr;
-	int fd, ret;
 
-	ksft_print_header();
-	ksft_set_plan(1);
+	addr = mmap(NULL, length, PROTECTION, flags, -1, 0);
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
+	int mmap_flags = MAP_SHARED;
+	bool passed;
+	int fd;
+
+	if (shift)
+		mmap_flags |= (shift & MAP_HUGE_MASK) << MAP_HUGE_SHIFT;
 
-	fd = memfd_create("hugepage-mmap", MFD_HUGETLB);
+	fd = memfd_create("hugetlb-mmap", MFD_HUGETLB);
 	if (fd < 0)
-		ksft_exit_fail_msg("memfd_create() failed: %s\n", strerror(errno));
+		ksft_exit_fail_perror("memfd_create");
+
+	passed = test_mmap(length, mmap_flags, fd, test_name);
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


