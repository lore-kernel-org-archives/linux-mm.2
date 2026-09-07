Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E973DC79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 08:15:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 151DC6B00A6; Mon,  7 Sep 2026 04:15:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 101D86B00A7; Mon,  7 Sep 2026 04:15:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F32C66B00A9; Mon,  7 Sep 2026 04:15:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CA4F86B00A6
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 04:15:17 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6E7BE1A0696
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:15:17 +0000 (UTC)
X-FDA: 85186256274.23.F086FCE
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 944BE40007
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:15:15 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=dkKeDEr1;
	spf=pass (imf11.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788768916;
	b=ExsWxSdf2y7aGhVyNPT2izoqXlg31tjsJUD/4wK5JXQiSYwVCmRkdx7yu9X8lWLbBRTecM
	RyVHn+S4/qLsESDnSEQ0XN4FVXhop3IfIz0I6/dMTUwBjXBfsBdiiphowEcik0eipE8t5C
	NLEq8NwuOwrfqdchzetn35tWD74wuwI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=dkKeDEr1;
	spf=pass (imf11.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788768916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=LLGfJ3r/RO7yxP1Py1wKX8auyVOrpLROIb8bSthKBuo=;
	b=4jATtS5uDZdhtxSrCeDVOuBNpoUUmBFGVbp2juE0hfydnbbvytRibL+oURBBPZE0Jg7GEC
	bsi45vxTz65IjqfzytF58q5Qb0glZ+M0/LtXxbY2yHBfH2rFe1gt130thVjmO+nsa160ok
	DjWeLrEu+qH5c8qZv8pDpmPyTopBf2E=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C83211477;
	Mon,  7 Sep 2026 01:15:10 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D08CB3F7D8;
	Mon,  7 Sep 2026 01:15:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788768914; bh=xSqHG/VfMLpainxQY/fzbMIjHfnHWNTmd9eRXxCLOUw=;
	h=From:To:Cc:Subject:Date:From;
	b=dkKeDEr1gAsm9E7R2VbPErY8w3VSzKhFwhdAYv+zqin/kthkMRZY0+ZiQBlFDq/Vu
	 x6stEXTkBjiojGOKtiBnKqj1VORqU0cGYdb+pcwgRaOPn7oqfTdgrjvgM56ow1ujJX
	 wNTfuAHOY0rNu0+GPcCw09L45AdnScxyh0tzlECM=
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	sarthak.sharma@arm.com,
	Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [PATCH v2] kselftest: mm: remove HPAGE_SIZE and HPAGE_SHIFT macro
Date: Mon,  7 Sep 2026 09:15:08 +0100
Message-ID: <20260907081509.924979-1-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: tk3cgmzcwr75xgb8w33a84u6uosm6d7b
X-Rspamd-Queue-Id: 944BE40007
X-Rspamd-Server: rspam06
X-HE-Tag: 1788768915-873933
X-HE-Meta: U2FsdGVkX19hr7QnNDjhko2Jr4nvZ5WEuu+DGlN7lhIVryC544P+nY1Xs6NZf92waV+tRZW8t2jzrymYkIzMvvZ8XJ0LYeqYp2DP8/ARVoQNIFeDkLJS97N1gNriSmanTRVxjb54spov7Ya7G2et7gqywTlYM3AYY/r+fKbymG8A0Rge/rYOSWjvnQrxqUN39GEwTEnLwETogC3+Vbft9PkrmJJIz/nYZQXChm7ImfibVgqKmJPXCi+/qxqAjj1hbkagRd1azc1NpMOQl5zgzmw0ybV2RgvH4GWGUgYKaHZeuxN5dOwrtHQ6I8fKRyTVssnvJTR9t3aMWzKWlCThHlMSzxEmSL0FcDpPdISF5o7R3htbl3PetO5Rx74rMngAcUOaHvBifud/GuFD2aH7QIGNCRgNTGc1vQ+3dj7VJRVnvFhg+PCXcqtKiUdVAyBhYGy78ccA4Ink22B5t9R35o004bmHToAE4Ox5x32b8SZMtYGDxNZ9qJ1axsbLzddrLSbBWyRL0wTt9gWvD7biDpncEbFEwsiQp9mHn16j5psrCK4fddp8l+b3v7V9ZtHutKoLSUVokpMut0qGBOPRxH4+fk6P+c8KXgUqOwDXrN5Q9FkDjwboZDozZ9BEKVvr3JAHpss4n38ljWyCVId4ePllRmsHRXCEIj1JuSCq4Fp9Io+/h1C/EN7YGmYqGsKCULahGVV1scLIgc7vZQY9uR1V6pu3EF8nxnzdx9FMaxa9LmJDsreNkfAhliRsmZXKMqKRSy3C+E9pXimTniCoY3ux3xZUzbaekiqi8Dy0UhWyaZwwvDFlMhqAemhwDyPrZ1p0HPYJgvwhzEU+ixMSBOmW3aRsHDzymlq8zzqP+ArhocKhd36bRO6k7LuOyPvj2EhmvbYfFplaDob3aU9/CtpxlQrB7J95hkyt0dus68wcrpma8CXgsMItD8mJ9pSlod5mePaXeh5wBdtHr/W
 l1vbFrBC
 I/EO0Vtx2cin3qVPLgVBEcLOq6NPTWvvGgHNlNUF3A1Ixlo1hUdpQK6pk483Ij1fsfiG1fy28wm7qmMJuJOZZFXy2+8sgIBeZ8fNGEDXbkV/pOd2ag9upU8oh+IKd1K+MPUfOsR1YvsccoHdg3C78cYvxEzgeKXnW45/u29bukJdp2VemGeGby2tsrIfBpVLGnHaVl1N8FWv3tc89RL+yzRHcOpMiUjAs7OxDzEZM+9Nol6AhgUQdDyEYmN79Y3PeIjDr/xnqU9JZXpXhyqyuW6AMnLngULZhDtDCmuzosdK1/W+6/h0ITh0435dh+SYq66P+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

HPAGE_SIZE and HPAGE_SHIFT macro is written based on the 4KB PAGE_SIZE.
When this macro is used in some test, test result would be strange in
the system where PAGE_SIZE is more then 4KB.

Here is the example with transhuge-stress test with 16KB PAGE_SIZE:

  transhuge-stress: allocate 61073 transhuge pages, using 122146 MiB virtual memory and 1908 MiB of ram
    3.292 s/loop, 0.054 ms/page,  37106.002 MiB/s	2566 succeed, 58507 failed, 2566 different pages
    0.591 s/loop, 0.010 ms/page, 206850.792 MiB/s	   0 succeed, 61073 failed,    0 different pages
    0.527 s/loop, 0.009 ms/page, 231895.107 MiB/s	   0 succeed, 61073 failed,    0 different pages
    0.527 s/loop, 0.009 ms/page, 231839.704 MiB/s	   0 succeed, 61073 failed,    0 different pages
    0.528 s/loop, 0.009 ms/page, 231544.782 MiB/s	   0 succeed, 61073 failed,    0 different pages
    0.528 s/loop, 0.009 ms/page, 231462.074 MiB/s	   0 succeed, 61073 failed,    0 different pages
    0.527 s/loop, 0.009 ms/page, 231770.300 MiB/s	   0 succeed, 61073 failed,    0 different pages
    ...
  ok 1 Completed

Remove the HPAGE_SIZE and HPAGE_SHIFT macros and introduce pmd_page_shift()
helper to get the HPAGE_SHIFT properly. For HPAGE_SIZE, use pre-existing
helper, read_pmd_pagesize().

Also, run the KSM_MERGE_TIME_HUGE_PAGES test with a size of 512 MiB,
which is the least common multiple of the PMD sizes for 4 KiB, 16 KiB,
and 64 KiB base pages. Since allocate_transhuge() allocates mappings in
PMD-sized units, the test may fail with the previous size of 100 MiB,
which is not a multiple of the PMD size when the base page size is
16 KiB or 64 KiB.

After this patch, output of transhuge-stress:

  transhuge-stress: allocate 3817 transhuge pages, using 122146 MiB virtual memory and 119 MiB of ram
    2.558 s/loop, 0.670 ms/page,  47755.759 MiB/s	2585 succeed, 1232 failed, 2585 different pages
    2.640 s/loop, 0.692 ms/page,  46268.432 MiB/s	2585 succeed, 1232 failed, 2585 different pages
    2.635 s/loop, 0.690 ms/page,  46360.298 MiB/s	2585 succeed, 1232 failed, 2585 different pages
    2.782 s/loop, 0.729 ms/page,  43899.795 MiB/s	2616 succeed, 1201 failed, 2616 different pages
    2.692 s/loop, 0.705 ms/page,  45380.876 MiB/s	2627 succeed, 1190 failed, 2627 different pages
    2.612 s/loop, 0.684 ms/page,  46765.812 MiB/s	2628 succeed, 1189 failed, 2628 different pages
    2.683 s/loop, 0.703 ms/page,  45520.990 MiB/s	2630 succeed, 1187 failed, 2630 different pages
    2.727 s/loop, 0.714 ms/page,  44789.321 MiB/s	2631 succeed, 1186 failed, 2631 different pages
    ...
  ok 1 Completed

Suggested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
Chnage in v2:
 - rename hpage_* to pmd_page_*
 - Link to v1: https://lore.kernel.org/all/20260902175611.1241118-1-yeoreum.yun@arm.com/#t

---
 tools/testing/selftests/mm/guard-regions.c    | 11 ++++--
 tools/testing/selftests/mm/ksm_tests.c        | 16 +++++----
 tools/testing/selftests/mm/run_vmtests.sh     |  4 +--
 tools/testing/selftests/mm/transhuge-stress.c | 25 +++++++------
 tools/testing/selftests/mm/vm_util.c          | 36 ++++++++++++++++---
 tools/testing/selftests/mm/vm_util.h          |  9 ++---
 6 files changed, 71 insertions(+), 30 deletions(-)

diff --git a/tools/testing/selftests/mm/guard-regions.c b/tools/testing/selftests/mm/guard-regions.c
index 5c8ec3ca75d7..e57cc7e39e41 100644
--- a/tools/testing/selftests/mm/guard-regions.c
+++ b/tools/testing/selftests/mm/guard-regions.c
@@ -2195,14 +2195,21 @@ TEST_F(guard_regions, pagemap_scan)
 TEST_F(guard_regions, collapse)
 {
 	const unsigned long page_size = self->page_size;
-	const unsigned long size = 2 * HPAGE_SIZE;
-	const unsigned long num_pages = size / page_size;
+	const uint64_t hpage_size = read_pmd_pagesize();
+	unsigned long size;
+	unsigned long num_pages;
 	char *ptr;
 	int i;
 
 	if (!thp_available())
 		SKIP(return, "Transparent Hugepages not available\n");
 
+	if (!hpage_size)
+		ksft_exit_fail_msg("reading hpage_size failed\n");
+
+	size = 2 * hpage_size;
+	num_pages = size / page_size;
+
 	/* Need file to be correct size for tests for non-anon. */
 	if (variant->backing != ANON_BACKED)
 		ASSERT_EQ(ftruncate(self->fd, size), 0);
diff --git a/tools/testing/selftests/mm/ksm_tests.c b/tools/testing/selftests/mm/ksm_tests.c
index 5fd7792a0d47..ef27ce467b8c 100644
--- a/tools/testing/selftests/mm/ksm_tests.c
+++ b/tools/testing/selftests/mm/ksm_tests.c
@@ -521,19 +521,23 @@ static int ksm_merge_hugepages_time(int merge_type, int mapping, int prot,
 	struct timespec start_time, end_time;
 	unsigned long scan_time_ns;
 	int pagemap_fd, n_normal_pages, n_huge_pages;
+	const uint64_t hpage_size = read_pmd_pagesize();
 
 	if (!thp_is_enabled()) {
 		ksft_print_msg("Transparent Hugepages not available\n");
 		return KSFT_SKIP;
 	}
 
+	if (!hpage_size)
+		ksft_exit_fail_msg("reading hpage_size failed\n");
+
 	map_size *= MB;
 	size_t len = map_size;
 
-	len -= len % HPAGE_SIZE;
-	map_ptr_orig = mmap(NULL, len + HPAGE_SIZE, PROT_READ | PROT_WRITE,
+	len -= len % hpage_size;
+	map_ptr_orig = mmap(NULL, len + hpage_size, PROT_READ | PROT_WRITE,
 			MAP_ANONYMOUS | MAP_NORESERVE | MAP_PRIVATE, -1, 0);
-	map_ptr = map_ptr_orig + HPAGE_SIZE - (uintptr_t)map_ptr_orig % HPAGE_SIZE;
+	map_ptr = map_ptr_orig + hpage_size - (uintptr_t)map_ptr_orig % hpage_size;
 
 	if (map_ptr_orig == MAP_FAILED)
 		err(2, "initial mmap");
@@ -547,7 +551,7 @@ static int ksm_merge_hugepages_time(int merge_type, int mapping, int prot,
 
 	n_normal_pages = 0;
 	n_huge_pages = 0;
-	for (void *p = map_ptr; p < map_ptr + len; p += HPAGE_SIZE) {
+	for (void *p = map_ptr; p < map_ptr + len; p += hpage_size) {
 		if (allocate_transhuge(p, pagemap_fd) < 0)
 			n_normal_pages++;
 		else
@@ -578,11 +582,11 @@ static int ksm_merge_hugepages_time(int merge_type, int mapping, int prot,
 	ksft_print_msg("Average speed:  %.3f MiB/s\n", (map_size / MB) /
 					       ((double)scan_time_ns / NSEC_PER_SEC));
 
-	munmap(map_ptr_orig, len + HPAGE_SIZE);
+	munmap(map_ptr_orig, len + hpage_size);
 	return KSFT_PASS;
 
 err_out:
-	munmap(map_ptr_orig, len + HPAGE_SIZE);
+	munmap(map_ptr_orig, len + hpage_size);
 	return KSFT_FAIL;
 }
 
diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index d09f9f6a384e..24aa1de27c25 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -360,8 +360,8 @@ fi
 CATEGORY="memfd_secret" run_test ./memfd_secret
 fi
 
-# KSM KSM_MERGE_TIME_HUGE_PAGES test with size of 100
-CATEGORY="ksm" run_test ./ksm_tests -H -s 100
+# KSM KSM_MERGE_TIME_HUGE_PAGES test with size of 512
+CATEGORY="ksm" run_test ./ksm_tests -H -s 512
 # KSM KSM_MERGE_TIME test with size of 100
 CATEGORY="ksm" run_test ./ksm_tests -P -s 100
 # KSM MADV_MERGEABLE test with 10 identical pages
diff --git a/tools/testing/selftests/mm/transhuge-stress.c b/tools/testing/selftests/mm/transhuge-stress.c
index 8eb0c5630e7e..9cd9790224db 100644
--- a/tools/testing/selftests/mm/transhuge-stress.c
+++ b/tools/testing/selftests/mm/transhuge-stress.c
@@ -35,12 +35,17 @@ int main(int argc, char **argv)
 	size_t map_len;
 	int pagemap_fd;
 	int duration = 0;
+	const uint64_t hpage_size = read_pmd_pagesize();
+	const uint64_t hpage_shift = pmd_page_shift();
 
 	ksft_print_header();
 
 	if (!thp_is_enabled())
 		ksft_exit_skip("Transparent Hugepages not available\n");
 
+	if (!hpage_size || !hpage_shift)
+		ksft_exit_fail_msg("reading hpage_size failed\n");
+
 	ram = sysconf(_SC_PHYS_PAGES);
 	if (ram > SIZE_MAX / psize() / 4)
 		ram = SIZE_MAX / 4;
@@ -70,23 +75,23 @@ int main(int argc, char **argv)
 	}
 
 	warnx("allocate %zd transhuge pages, using %zd MiB virtual memory"
-	      " and %zd MiB of ram", len >> HPAGE_SHIFT, len >> 20,
-	      ram >> (20 + HPAGE_SHIFT - pshift() - 1));
+	      " and %zd MiB of ram", len >> hpage_shift, len >> 20,
+	      ram >> (20 + hpage_shift - pshift() - 1));
 
 	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
 	if (pagemap_fd < 0)
 		ksft_exit_fail_msg("open pagemap\n");
 
-	len -= len % HPAGE_SIZE;
-	ptr = mmap(NULL, len + HPAGE_SIZE, PROT_RW, mmap_flags, backing_fd, 0);
+	len -= len % hpage_size;
+	ptr = mmap(NULL, len + hpage_size, PROT_RW, mmap_flags, backing_fd, 0);
 	if (ptr == MAP_FAILED)
 		ksft_exit_fail_msg("initial mmap");
-	ptr += HPAGE_SIZE - (uintptr_t)ptr % HPAGE_SIZE;
+	ptr += hpage_size - (uintptr_t)ptr % hpage_size;
 
 	if (madvise(ptr, len, MADV_HUGEPAGE))
 		ksft_exit_fail_msg("MADV_HUGEPAGE");
 
-	map_len = ram >> (HPAGE_SHIFT - 1);
+	map_len = ram >> (hpage_shift - 1);
 	map = malloc(map_len);
 	if (!map)
 		ksft_exit_fail_msg("map malloc\n");
@@ -99,7 +104,7 @@ int main(int argc, char **argv)
 		memset(map, 0, map_len);
 
 		clock_gettime(CLOCK_MONOTONIC, &a);
-		for (p = ptr; p < ptr + len; p += HPAGE_SIZE) {
+		for (p = ptr; p < ptr + len; p += hpage_size) {
 			int64_t pfn;
 
 			pfn = allocate_transhuge(p, pagemap_fd);
@@ -107,7 +112,7 @@ int main(int argc, char **argv)
 			if (pfn < 0) {
 				nr_failed++;
 			} else {
-				size_t idx = pfn >> (HPAGE_SHIFT - pshift());
+				size_t idx = pfn >> (hpage_shift - pshift());
 
 				nr_succeed++;
 				if (idx >= map_len) {
@@ -123,7 +128,7 @@ int main(int argc, char **argv)
 			}
 
 			/* split transhuge page, keep last page */
-			if (madvise(p, HPAGE_SIZE - psize(), MADV_DONTNEED))
+			if (madvise(p, hpage_size - psize(), MADV_DONTNEED))
 				ksft_exit_fail_msg("MADV_DONTNEED");
 		}
 		clock_gettime(CLOCK_MONOTONIC, &b);
@@ -131,7 +136,7 @@ int main(int argc, char **argv)
 
 		ksft_print_msg("%.3f s/loop, %.3f ms/page, %10.3f MiB/s\t"
 			       "%4d succeed, %4d failed, %4d different pages\n",
-			       s, s * 1000 / (len >> HPAGE_SHIFT), len / s / (1 << 20),
+			       s, s * 1000 / (len >> hpage_shift), len / s / (1 << 20),
 			       nr_succeed, nr_failed, nr_pages);
 
 		if (duration > 0 && b.tv_sec - start.tv_sec >= duration) {
diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index 4821a3563036..f75bf0bacd18 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -21,6 +21,8 @@
 
 unsigned int __page_size;
 unsigned int __page_shift;
+uint64_t __pmd_page_size;
+uint64_t __pmd_page_shift;
 
 uint64_t pagemap_get_entry(int fd, char *start)
 {
@@ -161,6 +163,9 @@ uint64_t read_pmd_pagesize(void)
 	char buf[20];
 	ssize_t num_read;
 
+	if (__pmd_page_size)
+		return __pmd_page_size;
+
 	fd = open(PMD_SIZE_FILE_PATH, O_RDONLY);
 	if (fd == -1)
 		return 0;
@@ -173,7 +178,25 @@ uint64_t read_pmd_pagesize(void)
 	buf[num_read] = '\0';
 	close(fd);
 
-	return strtoul(buf, NULL, 10);
+	__pmd_page_size = strtoul(buf, NULL, 10);
+
+	return __pmd_page_size;
+}
+
+uint64_t pmd_page_shift(void)
+{
+	if (__pmd_page_shift)
+		return __pmd_page_shift;
+
+	if (!__pmd_page_size)
+		__pmd_page_size = read_pmd_pagesize();
+
+	if (!__pmd_page_size)
+		return 0;
+
+	__pmd_page_shift = (ffsl(__pmd_page_size) - 1);
+
+	return __pmd_page_shift;
 }
 
 unsigned long rss_anon(void)
@@ -452,14 +475,19 @@ bool check_huge_shmem(void *addr, size_t len, int nr_hpages, uint64_t hpage_size
 int64_t allocate_transhuge(void *ptr, int pagemap_fd)
 {
 	uint64_t ent[2];
+	const uint64_t hpage_size = read_pmd_pagesize();
+	const uint64_t hpage_shift = pmd_page_shift();
+
+	if (!hpage_size || !hpage_shift)
+		return -1;
 
 	/* drop pmd */
-	if (mmap(ptr, HPAGE_SIZE, PROT_READ | PROT_WRITE,
+	if (mmap(ptr, hpage_size, PROT_READ | PROT_WRITE,
 		 MAP_FIXED | MAP_ANONYMOUS |
 		 MAP_NORESERVE | MAP_PRIVATE, -1, 0) != ptr)
 		ksft_exit_fail_msg("mmap transhuge\n");
 
-	if (madvise(ptr, HPAGE_SIZE, MADV_HUGEPAGE))
+	if (madvise(ptr, hpage_size, MADV_HUGEPAGE))
 		ksft_exit_fail_msg("MADV_HUGEPAGE\n");
 
 	/* allocate transparent huge page */
@@ -471,7 +499,7 @@ int64_t allocate_transhuge(void *ptr, int pagemap_fd)
 
 	if (PAGEMAP_PRESENT(ent[0]) && PAGEMAP_PRESENT(ent[1]) &&
 	    PAGEMAP_PFN(ent[0]) + 1 == PAGEMAP_PFN(ent[1]) &&
-	    !(PAGEMAP_PFN(ent[0]) & ((1 << (HPAGE_SHIFT - pshift())) - 1)))
+	    !(PAGEMAP_PFN(ent[0]) & ((1 << (hpage_shift - pshift())) - 1)))
 		return PAGEMAP_PFN(ent[0]);
 
 	return -1;
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index 9a49af88702e..1d2608c1ad08 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -31,6 +31,8 @@
 
 extern unsigned int __page_size;
 extern unsigned int __page_shift;
+extern uint64_t __pmd_page_size;
+extern uint64_t __pmd_page_shift;
 
 /*
  * Represents an open fd and PROCMAP_QUERY state for binary (via ioctl)
@@ -89,6 +91,7 @@ unsigned long pagemap_get_pfn(int fd, char *start);
 void clear_softdirty(void);
 bool check_for_pattern(FILE *fp, const char *pattern, char *buf, size_t len);
 uint64_t read_pmd_pagesize(void);
+uint64_t pmd_page_shift(void);
 unsigned long rss_anon(void);
 bool check_huge_anon(void *addr, size_t len, int nr_hpages, uint64_t hpage_size);
 bool check_huge_file(void *addr, size_t len, int nr_hpages, uint64_t hpage_size);
@@ -157,12 +160,6 @@ int ksm_stop(void);
 int get_hardware_corrupted_size(unsigned long *val);
 int unpoison_memory(unsigned long pfn);
 
-/*
- * On ppc64 this will only work with radix 2M hugepage size
- */
-#define HPAGE_SHIFT 21
-#define HPAGE_SIZE (1 << HPAGE_SHIFT)
-
 #define PAGEMAP_PRESENT(ent)	(((ent) & (1ull << 63)) != 0)
 #define PAGEMAP_PFN(ent)	((ent) & ((1ull << 55) - 1))
 
-- 
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


