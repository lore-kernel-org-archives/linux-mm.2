Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12174C624D3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 17:56:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B13C76B008C; Wed,  2 Sep 2026 13:56:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC41A6B00A5; Wed,  2 Sep 2026 13:56:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B2CF6B00B2; Wed,  2 Sep 2026 13:56:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6856D6B008C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:56:19 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E65201C19EA
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 17:56:18 +0000 (UTC)
X-FDA: 85169576436.22.CCC23D9
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1F9EE1C0005
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 17:56:16 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=YYPV8z3k;
	spf=pass (imf20.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788371777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Xvgo+8rjqMYsKTxud1dIQ28nMewW0VWQbI288q0m7Ps=;
	b=hhpYaG6CBYi6t5oALpC9bZLbFafElGHS70Qb0iXFaHf4kTbSXMYVTxPPRYd7KsQ/TCPKqw
	zQHm13cTy8iL7c6FLefxDDEDh0PHuKOykpObB1Ts3f4sYJ0INqMlaEbaerzk7Un3oEXXLg
	1shXUZO9XYTkc0Fa3tK5KrqMdnUsHSI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788371777;
	b=maZ4R4lF66wRqDaL9I5Yyoi61hTtnFue1t736C1oLgGSJjwuqtCS9dcQ2dzJbpvGSs7MZf
	YkKdSDdDBrUW3IzM47a0SRFC2pKw2zEMInYx7OFgNeKej0qmmTzkTNdAPK5lNuRUtLRPXu
	7GE/SAwE2WzKYJqPC1M55bmYiRPVe94=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=YYPV8z3k;
	spf=pass (imf20.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 109511682;
	Wed,  2 Sep 2026 10:56:12 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 3BAAA3F7D8;
	Wed,  2 Sep 2026 10:56:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788371775; bh=LAnTQ69tY5Vli8yxrVCyumF2uSHglLEcIh02wQisKRM=;
	h=From:To:Cc:Subject:Date:From;
	b=YYPV8z3ko7iwxPcRCE27SIaV2TOoGloOeKBhHHBrmkesCpJPCXQGoX/9UPeVf+VIu
	 IUiOD8ry74TdC4k5PhaovPNu8DLZepWfyGpcmJkP2TI8ku3Ec7uMtai4T/p4UIfIyu
	 3a6li5ov6M5XLBkSzDudBdvPq72Eb2uPia0NkpKM=
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
	Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [PATCH] kselftest: mm: remove HPAGE_SIZE and HPAGE_SHIFT macro
Date: Wed,  2 Sep 2026 18:56:11 +0100
Message-ID: <20260902175611.1241118-1-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: po9u7rg9g4gxnmrqdqyjzzp4dh1u8e65
X-Rspamd-Queue-Id: 1F9EE1C0005
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788371776-109737
X-HE-Meta: U2FsdGVkX18PkBfXjxSiCtyskOBP1vxL4fXvoP1wB9GllSOeuPwZReT7vqrYXhbypjSBVqEkfgCKXCeJ9p9Ve6+LWNFiXZsi8ku9opKQrMu7VprD9onXbGZNWp2hZugnEC8eynGfct/c8/H8tGar0klHSIV5bOXn+NWBeWj70Z818c8l2KlHqN2BtHbPKV/aJvwkI/F9Ws/EIZFDP3upPGHkpoouafwaiDx/bdDjErMaz+NIALMz3wy/n6zox9Bs88FCTDdk1N1SpgV+2gL8PflDcNuwbvuBl5O+odbEKDx9oxeeOkivQJ55OL77FVurvba/PIrX27bBufRMKU5vM1o51V3HjG0msw9i6wWEOVqLZ8XAhaKIFOAJTvLxR13lDJFoVkUjnGXdNIh1a6oiuwFFVkr4OBwJQLY0uvkqUzmxbwTOO9TwzVaqwZAm7kIcfHXV4Rqrl+OK7xMY6vbK11v+vCJ89SUBOvYaQF6P0+NRhlS0Hs6EzKMD6MEOOQ5RL6xfgJvWomfIW20kW5/4tb3jemaZoLdohsXhFh0zU2jVVMFu5NRbejUzZe6GYvmAxFmQomXEzy6vvUrX/Bw0AuPfNUYlmt28XoPp/7ZAR+pas1+aM7gG3oQngQOEB01ow6rCjmFb3/0yvpMSzU/CtbL/l60QKuh+skBpSySoMp+ctKKh8M0JidynZtzg60gnOseVlGSMW/2DnsJ93/HMxWSNPUtnZZf5AdDpgtOT2rF/ouvd1/JzahlbFtzELYclDyytn+Jh9dKePmaQy5ChTQXVokcEFmeVHJhuVdkwoL35G8gMeugpYGwxBFuiC1faa6Q6oJKErCDVaB5AxD3QyL7jXpQd8ej9pkJIwBPZd+qaFbVzV4FAyZ6mJUo8ds8rPaasUrw8MGbNi9zrf95TEVMUI3A8OrgkiGPyHBzkm6T8EFBA6GU7DiipHpei71JXigEEM6UmLwRGtsDn6lY
 WBjaDmjs
 S6L7q99NTy6JcWpxkTbaypxvgSQsPm1gFGMmQCvLxs062Fs8M/jyhuj5RyQcigYh9uubu661cn4o4G1aoTaLdYbEfC600t4v4lX6DnKAeKiOEJyBwGv5MMcfOAcN1qKdHMLh2UEfrrxu2+wOW4WAG49BgGpCNRny8fMxf6EYhLzKLu1LVcwCylYDYyE/dWBKjPWQLdS2EHBdhPZ2q9NX496Zyk0t8FrjaI6pR5ja4IzuLDCeSvSr8wC0apYtm/lm7JiqQiPgWgr1K1AnT7TqR+KdcJfzCvuSagOU9pay7GjspS9s4fwfBDmZ9kZMrtI/PeKTs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

HPAGE_SIZE and HPAGE_SHIFT macro is written based on the 4KB PAGE_SIZE.
When this macro is used in some test, test result would be strange in
the system where PAGE_SIZE is more than 4KB.

Here is example with transhuge-stress test with 16KB PAGE_SIZE:

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

Remove the HPAGE_SIZE and HPAGE_SHIFT macro. and introduce hpshift()
helper to get the HPAGE_SHIFT properly. For HPAGE_SIZE, use pre-exist
helper, read_pmd_pagesize().

Also, do KSM_MERGE_TIME_HUGE_PAGES test with size of 512 MiB which
is the LCD pmd_size among 4KB, 16KB and 64KB page_size.

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
 tools/testing/selftests/mm/guard-regions.c    | 12 +++++--
 tools/testing/selftests/mm/ksm_tests.c        | 17 ++++++----
 tools/testing/selftests/mm/run_vmtests.sh     |  4 +--
 tools/testing/selftests/mm/transhuge-stress.c | 22 +++++++------
 tools/testing/selftests/mm/vm_util.c          | 32 ++++++++++++++++---
 tools/testing/selftests/mm/vm_util.h          |  9 ++----
 6 files changed, 66 insertions(+), 30 deletions(-)

diff --git a/tools/testing/selftests/mm/guard-regions.c b/tools/testing/selftests/mm/guard-regions.c
index 5c8ec3ca75d7..d370592b291f 100644
--- a/tools/testing/selftests/mm/guard-regions.c
+++ b/tools/testing/selftests/mm/guard-regions.c
@@ -2195,14 +2195,22 @@ TEST_F(guard_regions, pagemap_scan)
 TEST_F(guard_regions, collapse)
 {
 	const unsigned long page_size = self->page_size;
-	const unsigned long size = 2 * HPAGE_SIZE;
-	const unsigned long num_pages = size / page_size;
+	uint64_t hpage_size;
+	unsigned long size;
+	unsigned long num_pages;
 	char *ptr;
 	int i;
 
 	if (!thp_available())
 		SKIP(return, "Transparent Hugepages not available\n");
 
+	hpage_size = read_pmd_pagesize();
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
index 5fd7792a0d47..278e77055007 100644
--- a/tools/testing/selftests/mm/ksm_tests.c
+++ b/tools/testing/selftests/mm/ksm_tests.c
@@ -521,6 +521,11 @@ static int ksm_merge_hugepages_time(int merge_type, int mapping, int prot,
 	struct timespec start_time, end_time;
 	unsigned long scan_time_ns;
 	int pagemap_fd, n_normal_pages, n_huge_pages;
+	uint64_t hpage_size = read_pmd_pagesize();
+
+	if (!hpage_size) {
+		ksft_exit_fail_msg("reading hpage_size failed\n");
+	}
 
 	if (!thp_is_enabled()) {
 		ksft_print_msg("Transparent Hugepages not available\n");
@@ -530,10 +535,10 @@ static int ksm_merge_hugepages_time(int merge_type, int mapping, int prot,
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
@@ -547,7 +552,7 @@ static int ksm_merge_hugepages_time(int merge_type, int mapping, int prot,
 
 	n_normal_pages = 0;
 	n_huge_pages = 0;
-	for (void *p = map_ptr; p < map_ptr + len; p += HPAGE_SIZE) {
+	for (void *p = map_ptr; p < map_ptr + len; p += hpage_size) {
 		if (allocate_transhuge(p, pagemap_fd) < 0)
 			n_normal_pages++;
 		else
@@ -578,11 +583,11 @@ static int ksm_merge_hugepages_time(int merge_type, int mapping, int prot,
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
index 8eb0c5630e7e..66ae94afaf8d 100644
--- a/tools/testing/selftests/mm/transhuge-stress.c
+++ b/tools/testing/selftests/mm/transhuge-stress.c
@@ -35,6 +35,8 @@ int main(int argc, char **argv)
 	size_t map_len;
 	int pagemap_fd;
 	int duration = 0;
+	uint64_t hpage_size = read_pmd_pagesize();
+	uint64_t hpage_shift = hpshift();
 
 	ksft_print_header();
 
@@ -70,23 +72,23 @@ int main(int argc, char **argv)
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
@@ -99,7 +101,7 @@ int main(int argc, char **argv)
 		memset(map, 0, map_len);
 
 		clock_gettime(CLOCK_MONOTONIC, &a);
-		for (p = ptr; p < ptr + len; p += HPAGE_SIZE) {
+		for (p = ptr; p < ptr + len; p += hpage_size) {
 			int64_t pfn;
 
 			pfn = allocate_transhuge(p, pagemap_fd);
@@ -107,7 +109,7 @@ int main(int argc, char **argv)
 			if (pfn < 0) {
 				nr_failed++;
 			} else {
-				size_t idx = pfn >> (HPAGE_SHIFT - pshift());
+				size_t idx = pfn >> (hpage_shift - pshift());
 
 				nr_succeed++;
 				if (idx >= map_len) {
@@ -123,7 +125,7 @@ int main(int argc, char **argv)
 			}
 
 			/* split transhuge page, keep last page */
-			if (madvise(p, HPAGE_SIZE - psize(), MADV_DONTNEED))
+			if (madvise(p, hpage_size - psize(), MADV_DONTNEED))
 				ksft_exit_fail_msg("MADV_DONTNEED");
 		}
 		clock_gettime(CLOCK_MONOTONIC, &b);
@@ -131,7 +133,7 @@ int main(int argc, char **argv)
 
 		ksft_print_msg("%.3f s/loop, %.3f ms/page, %10.3f MiB/s\t"
 			       "%4d succeed, %4d failed, %4d different pages\n",
-			       s, s * 1000 / (len >> HPAGE_SHIFT), len / s / (1 << 20),
+			       s, s * 1000 / (len >> hpage_shift), len / s / (1 << 20),
 			       nr_succeed, nr_failed, nr_pages);
 
 		if (duration > 0 && b.tv_sec - start.tv_sec >= duration) {
diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index 4821a3563036..4332f8fb2104 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -21,6 +21,8 @@
 
 unsigned int __page_size;
 unsigned int __page_shift;
+uint64_t __hpage_size;
+uint64_t __hpage_shift;
 
 uint64_t pagemap_get_entry(int fd, char *start)
 {
@@ -161,6 +163,9 @@ uint64_t read_pmd_pagesize(void)
 	char buf[20];
 	ssize_t num_read;
 
+	if (__hpage_size)
+		return __hpage_size;
+
 	fd = open(PMD_SIZE_FILE_PATH, O_RDONLY);
 	if (fd == -1)
 		return 0;
@@ -173,7 +178,24 @@ uint64_t read_pmd_pagesize(void)
 	buf[num_read] = '\0';
 	close(fd);
 
-	return strtoul(buf, NULL, 10);
+	__hpage_size = strtoul(buf, NULL, 10);
+
+	return __hpage_size;
+}
+
+uint64_t hpshift(void)
+{
+	if (!__hpage_shift) {
+		if (!__hpage_size) {
+			__hpage_size = read_pmd_pagesize();
+			if (!__hpage_size)
+				ksft_exit_fail_msg("reading __hpage_size failed\n");
+		}
+
+		__hpage_shift = (ffsl(__hpage_size) - 1);
+	}
+
+	return __hpage_shift;
 }
 
 unsigned long rss_anon(void)
@@ -452,14 +474,16 @@ bool check_huge_shmem(void *addr, size_t len, int nr_hpages, uint64_t hpage_size
 int64_t allocate_transhuge(void *ptr, int pagemap_fd)
 {
 	uint64_t ent[2];
+	uint64_t hpage_size = read_pmd_pagesize();
+	uint64_t hpage_shift = hpshift();
 
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
@@ -471,7 +495,7 @@ int64_t allocate_transhuge(void *ptr, int pagemap_fd)
 
 	if (PAGEMAP_PRESENT(ent[0]) && PAGEMAP_PRESENT(ent[1]) &&
 	    PAGEMAP_PFN(ent[0]) + 1 == PAGEMAP_PFN(ent[1]) &&
-	    !(PAGEMAP_PFN(ent[0]) & ((1 << (HPAGE_SHIFT - pshift())) - 1)))
+	    !(PAGEMAP_PFN(ent[0]) & ((1 << (hpage_shift - pshift())) - 1)))
 		return PAGEMAP_PFN(ent[0]);
 
 	return -1;
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index 9a49af88702e..20a6334605c7 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -31,6 +31,8 @@
 
 extern unsigned int __page_size;
 extern unsigned int __page_shift;
+extern uint64_t __hpage_size;
+extern uint64_t __hpage_shift;
 
 /*
  * Represents an open fd and PROCMAP_QUERY state for binary (via ioctl)
@@ -89,6 +91,7 @@ unsigned long pagemap_get_pfn(int fd, char *start);
 void clear_softdirty(void);
 bool check_for_pattern(FILE *fp, const char *pattern, char *buf, size_t len);
 uint64_t read_pmd_pagesize(void);
+uint64_t hpshift(void);
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


