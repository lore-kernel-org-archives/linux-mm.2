Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D103CA6018
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 01:27:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB7096B0093; Thu,  8 Oct 2026 21:27:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E906F6B0095; Thu,  8 Oct 2026 21:27:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2F116B0096; Thu,  8 Oct 2026 21:27:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A98D66B0093
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 21:27:53 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ED9C0120209
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 01:27:51 +0000 (UTC)
X-FDA: 85301351142.30.D5DCA4F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1A31A20005
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 01:27:49 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Wv7GE5XA;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf03.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791509270;
	b=KEIqkazc3ZfuBfu9BiqxY2CoF9AAF+QQ7MslwQfGhx7pb8ZUoKNlRDhgq19yL9UiOjezDA
	l8xFma6nnW5nykLcLz0Am8RC0XoDW+Dvn2kE3zeQdqR2j6P9LtbK1LbQ21fnxate+XuOq1
	ddOZhpaz/BjbJBC/kzOjE3qt/6WOHx0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Wv7GE5XA;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf03.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791509270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KtVFB2oDtcc+Lkqxj7zS9PhxZZslOPHgbPQ5gu0CM9k=;
	b=2BsD9FY+Y+SKWE88TXo2ywcU/Fuwls57GoPYrXXv2PzNtVOs6wc1NUToQTuufTs34BE5Bx
	hdQ5DAn29Y8vsJX5ViIbmo6s8L0bCF4udWzeUcMm1tvDEVDN+9mkC6NmCv5Hio9mVnEf+f
	50FpUvbceIHS/fz231l1xRdv9LsJgDQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DF9A01764;
	Thu,  8 Oct 2026 18:27:45 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AA2AC3F8C6;
	Thu,  8 Oct 2026 18:27:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791509269; bh=nQwIbo0sB5nkW3zL62PFheAHaHwgqmAgVwRGOe1/fVM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Wv7GE5XAR8W0TcrH20UGogR7qIh3DcfDiLssgvZJJkpK25nbRNWNIKti03kwuWtot
	 5/cAtwG7pcvwCGaB563NiuFT0EQge74T3epjnHitbIB0dfcicpFa4jn8tOsoaacaoo
	 wbmBvTDYWTr2Y2Js76JBOVtnQQeHTMUrllnJogTs=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Fri, 09 Oct 2026 02:27:33 +0100
Subject: [PATCH v5 2/3] kselftest: mm: remove HPAGE_SIZE and HPAGE_SHIFT
 macro
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261009-fix_hpage_macro-v5-2-54378ae45add@arm.com>
References: <20261009-fix_hpage_macro-v5-0-54378ae45add@arm.com>
In-Reply-To: <20261009-fix_hpage_macro-v5-0-54378ae45add@arm.com>
To: Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Peter Xu <peterx@redhat.com>, 
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Shuah Khan <shuah@kernel.org>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
 Sarthak Sharma <sarthak.sharma@arm.com>, Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=13792; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=nQwIbo0sB5nkW3zL62PFheAHaHwgqmAgVwRGOe1/fVM=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqyEMIS3M6YryItsUs/sQm4/jpiV1+H2X9kiLLe
 DzwIrkun6eJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCashDCAAKCRBt1cPRWsUx
 MyWIC/4gSzqu2eM4DpU9KqRmjOcceV0v//XlcwOrep5vYZ9ClM06qIJRAflY3dJ7heFxw1qDzgb
 YEZERAheTljGHY+b3iHBHoXbOq4onTjdiqTxYNnsVLEvhoZEJK+QXVFfqhnIRld2tAe5mlg0Alc
 k4E3ShAG0C3TfJ04+pjhmQfSda8Ku1tTFgPidxh/VEt6wwrPY5wuyDy3uPos56Dt9zpP4dPaOds
 lzFUr/F2QR8haSW0PEqBkXtbkEEKz9rXDv8FOYE4rG+ppMgPv+l3k2i6asr4wvWxx5Gxn1UEMtD
 IOXmGyA5YOCT9ZWX6i/QYZaBuPoZzpwEKpAZ39VW72fhvQ/KjQ6FmSuWMpUD5O/vQCU1JhPLmPO
 elRE3B7ovR51IoXhxKw/puLQU8ZA6R3gXsAcyeirt+eY6LzcxJPozx1w2GgWXKmOR8OpAo8lbHD
 yyZ8O8KYLpppXPrV8p9ZRiwSKbvGCg4EL6wlL7BBcK4l9Gm4skpDKHSxarfcGcDxmuYoY=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Stat-Signature: i3ge43h1h4sjpc9oyj974ojk3ger7uc4
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1A31A20005
X-HE-Tag: 1791509269-121447
X-HE-Meta: U2FsdGVkX1+1fwODLBdu8e61/Vb3v7eWBwNEnLmHQ8HnDgZ6GY2c2LKct8G0q4SJsO8Beq9xxK8mqb0fJ0Fr5okn13QP6JojZTv3yhhWW0SqknK09S/EJCxYiEhRP6RUJadCK8nko29TUsNSRuimKjl4So7ekBW9TXVltAxN3Eh75W1OEE3++Te3/Sry8JwadDf5gaID1CFH3EvvLhHkex7KVsKj4oQo0iXHND4uzMrFLdEVmjSQ24+KDkZn0x2S5YrZBT3qjQzhSGSkAqS3N0YJrxRRh+1gBP+z14KRZUQmaBVmTWCEeoZP0scgEsDij5ZdgsastMB4jM1PTqP0+61THohZNTz+rPVjLpBR9kDwIFofl/x7X3xXK1yDEYcll1pBC3tbV6YDAu5gaXcErrCdTR05bsyonVmeVrf+KddhOnp7ZMCjRUuh2fOsZgQJt93Kce98V3XhgTFoWPQV6JJrsu3iz5qWm94+Q5NRHPoexixgdxzYlyfd52FvKXg73+NilvjSo1xBZdubo+M5XL4YEikzoqmR7HQDmYxIpjY/S0fhpiD0Q2L1lB9JE87fD1AkDcW8QanzC+N9PjMJu9eMPd7H0kE3a54inYooeFJVfMftXONXB3fTt/pVZjfN4SSEHGbxcWp4YnQf8Ejr9HxZySPT+N9YCMsxN656xBI4vpH+oxny4Odyo4bb79KJlfUDGA+nbTYu1yV0ezd2pLjeFbEpFUjXUyO/izQsGfZA+k0X9tw797REdXkJmSzCgpovQf+leM7wIpDA/0MfD5Vz8ujeX9zg+Qo1YrQp6jWRZli3C5TBynk3VXLRSStY9tlEFPuEzOvlAZeRIFagsclSGHWrBXlpECgljp2RxXgu0V9oq3jLkzgnVwKOAXNjeTLrrKZEMz6+nJnvrcNeIdBHNk9/P3fSzjbeDKLFYqq7oMiJsQQxkLXz1ZBKUyQ0UOJGPTc2UlPTOnMObAH
 o1g+2BF9
 wxQDphvSPFmHwNqzZzFWWdKbS/iJoAp7HJojG3omWdZJz+UIuuyZmSZ6JVIaoOVZ9QtT0q11zEsxK5zpi/MJMEhLW/vgumODlNLdE6uctF8kUin2ioJMnUcAdOjGqu3/1fwnz+/ds2Z+AxKrv8enBX+bhYCIrGe88RzBDStH0Oh819X3S21wZGo7h4HYMzj6QZRxBWd+opTzXCn2yIQ0dQktjNNDbchIlQWs3Lq93HU4aeiwLoXFx2jARavI7mGDgRau668/TSOwwg8EHIBa+rxniAuWGcmlFBLRwGXGZ2CT64cXb1jyPa/DBFWpIOBXsRwj/YZYi3TQ2TA6rbFOaidtiRpHbPE0XNCm7
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

Remove the HPAGE_SIZE and HPAGE_SHIFT macro and introduce pmd_pshift()
helper to get the HPAGE_SHIFT properly. For HPAGE_SIZE, use pre-existing
helper, pmd_psize().

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
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 tools/testing/selftests/mm/guard-regions.c    | 11 ++++++--
 tools/testing/selftests/mm/ksm_tests.c        | 16 ++++++-----
 tools/testing/selftests/mm/run_vmtests.sh     |  4 +--
 tools/testing/selftests/mm/transhuge-stress.c | 25 +++++++++++-------
 tools/testing/selftests/mm/vm_util.c          | 38 +++++++++++++++++++++++----
 tools/testing/selftests/mm/vm_util.h          |  9 +++----
 6 files changed, 72 insertions(+), 31 deletions(-)

diff --git a/tools/testing/selftests/mm/guard-regions.c b/tools/testing/selftests/mm/guard-regions.c
index f7d53ea3c2527..3052823b0eff6 100644
--- a/tools/testing/selftests/mm/guard-regions.c
+++ b/tools/testing/selftests/mm/guard-regions.c
@@ -2194,14 +2194,21 @@ TEST_F(guard_regions, pagemap_scan)
 TEST_F(guard_regions, collapse)
 {
 	const unsigned long page_size = self->page_size;
-	const unsigned long size = 2 * HPAGE_SIZE;
-	const unsigned long num_pages = size / page_size;
+	const uint64_t hpage_size = pmd_psize();
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
index 6711f4c613711..9e6e1633d0b53 100644
--- a/tools/testing/selftests/mm/ksm_tests.c
+++ b/tools/testing/selftests/mm/ksm_tests.c
@@ -520,19 +520,23 @@ static int ksm_merge_hugepages_time(int merge_type, int mapping, int prot,
 	struct timespec start_time, end_time;
 	unsigned long scan_time_ns;
 	int pagemap_fd, n_normal_pages, n_huge_pages;
+	const uint64_t hpage_size = pmd_psize();
 
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
@@ -546,7 +550,7 @@ static int ksm_merge_hugepages_time(int merge_type, int mapping, int prot,
 
 	n_normal_pages = 0;
 	n_huge_pages = 0;
-	for (void *p = map_ptr; p < map_ptr + len; p += HPAGE_SIZE) {
+	for (void *p = map_ptr; p < map_ptr + len; p += hpage_size) {
 		if (allocate_transhuge(p, pagemap_fd) < 0)
 			n_normal_pages++;
 		else
@@ -577,11 +581,11 @@ static int ksm_merge_hugepages_time(int merge_type, int mapping, int prot,
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
index a1b45a3dedaee..f3ec767f562b8 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -343,8 +343,8 @@ fi
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
index 96f72898ebe0a..ad2831c864dc3 100644
--- a/tools/testing/selftests/mm/transhuge-stress.c
+++ b/tools/testing/selftests/mm/transhuge-stress.c
@@ -34,12 +34,17 @@ int main(int argc, char **argv)
 	size_t map_len;
 	int pagemap_fd;
 	int duration = 0;
+	const uint64_t hpage_size = pmd_psize();
+	const uint64_t hpage_shift = pmd_pshift();
 
 	ksft_print_header();
 
 	if (!thp_is_enabled())
 		ksft_exit_skip("Transparent Hugepages not available\n");
 
+	if (!hpage_size || !hpage_shift)
+		ksft_exit_fail_msg("reading hpage_size failed\n");
+
 	ram = sysconf(_SC_PHYS_PAGES);
 	if (ram > SIZE_MAX / psize() / 4)
 		ram = SIZE_MAX / 4;
@@ -69,23 +74,23 @@ int main(int argc, char **argv)
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
@@ -98,7 +103,7 @@ int main(int argc, char **argv)
 		memset(map, 0, map_len);
 
 		clock_gettime(CLOCK_MONOTONIC, &a);
-		for (p = ptr; p < ptr + len; p += HPAGE_SIZE) {
+		for (p = ptr; p < ptr + len; p += hpage_size) {
 			int64_t pfn;
 
 			pfn = allocate_transhuge(p, pagemap_fd);
@@ -106,7 +111,7 @@ int main(int argc, char **argv)
 			if (pfn < 0) {
 				nr_failed++;
 			} else {
-				size_t idx = pfn >> (HPAGE_SHIFT - pshift());
+				size_t idx = pfn >> (hpage_shift - pshift());
 
 				nr_succeed++;
 				if (idx >= map_len) {
@@ -122,7 +127,7 @@ int main(int argc, char **argv)
 			}
 
 			/* split transhuge page, keep last page */
-			if (madvise(p, HPAGE_SIZE - psize(), MADV_DONTNEED))
+			if (madvise(p, hpage_size - psize(), MADV_DONTNEED))
 				ksft_exit_fail_msg("MADV_DONTNEED");
 		}
 		clock_gettime(CLOCK_MONOTONIC, &b);
@@ -130,7 +135,7 @@ int main(int argc, char **argv)
 
 		ksft_print_msg("%.3f s/loop, %.3f ms/page, %10.3f MiB/s\t"
 			       "%4d succeed, %4d failed, %4d different pages\n",
-			       s, s * 1000 / (len >> HPAGE_SHIFT), len / s / (1 << 20),
+			       s, s * 1000 / (len >> hpage_shift), len / s / (1 << 20),
 			       nr_succeed, nr_failed, nr_pages);
 
 		if (duration > 0 && b.tv_sec - start.tv_sec >= duration) {
diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index 5f2fb5b819c4a..efd99298be135 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -21,6 +21,8 @@
 
 unsigned int __page_size;
 unsigned int __page_shift;
+uint64_t __pmd_psize = -1ull;
+uint64_t __pmd_pshift = -1ull;
 
 uint64_t pagemap_get_entry(int fd, char *start)
 {
@@ -161,19 +163,40 @@ uint64_t pmd_psize(void)
 	char buf[20];
 	ssize_t num_read;
 
+	if (__pmd_psize != -1ull)
+		return __pmd_psize;
+
 	fd = open(PMD_SIZE_FILE_PATH, O_RDONLY);
-	if (fd == -1)
+	if (fd == -1) {
+		__pmd_psize = 0;
 		return 0;
+	}
 
 	num_read = read(fd, buf, 19);
 	if (num_read < 1) {
+		__pmd_psize = 0;
 		close(fd);
 		return 0;
 	}
 	buf[num_read] = '\0';
 	close(fd);
 
-	return strtoul(buf, NULL, 10);
+	__pmd_psize = strtoul(buf, NULL, 10);
+
+	return __pmd_psize;
+}
+
+uint64_t pmd_pshift(void)
+{
+	if (__pmd_pshift != -1ull)
+		return __pmd_pshift;
+
+	if (__pmd_psize != -1ull)
+		__pmd_psize = pmd_psize();
+
+	__pmd_pshift = (__pmd_psize > 0) ? ffsl(__pmd_psize) - 1 : 0;
+
+	return __pmd_pshift;
 }
 
 unsigned long rss_anon(void)
@@ -489,14 +512,19 @@ bool check_huge_file(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
 int64_t allocate_transhuge(void *ptr, int pagemap_fd)
 {
 	uint64_t ent[2];
+	const uint64_t hpage_size = pmd_psize();
+	const uint64_t hpage_shift = pmd_pshift();
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
@@ -508,7 +536,7 @@ int64_t allocate_transhuge(void *ptr, int pagemap_fd)
 
 	if (PAGEMAP_PRESENT(ent[0]) && PAGEMAP_PRESENT(ent[1]) &&
 	    PAGEMAP_PFN(ent[0]) + 1 == PAGEMAP_PFN(ent[1]) &&
-	    !(PAGEMAP_PFN(ent[0]) & ((1 << (HPAGE_SHIFT - pshift())) - 1)))
+	    !(PAGEMAP_PFN(ent[0]) & ((1 << (hpage_shift - pshift())) - 1)))
 		return PAGEMAP_PFN(ent[0]);
 
 	return -1;
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index 29d34980df36a..ff51c61636505 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -35,6 +35,8 @@
 
 extern unsigned int __page_size;
 extern unsigned int __page_shift;
+extern uint64_t __pmd_psize;
+extern uint64_t __pmd_pshift;
 
 /*
  * Represents an open fd and PROCMAP_QUERY state for binary (via ioctl)
@@ -93,6 +95,7 @@ unsigned long pagemap_get_pfn(int fd, char *start);
 void clear_softdirty(void);
 bool check_for_pattern(FILE *fp, const char *pattern, char *buf, size_t len);
 uint64_t pmd_psize(void);
+uint64_t pmd_pshift(void);
 unsigned long rss_anon(void);
 bool check_huge_anon(void *addr, size_t len, int nr_hpages, uint64_t hpage_size);
 bool check_huge_file(void *addr, size_t len, int nr_hpages, uint64_t hpage_size);
@@ -168,12 +171,6 @@ int ksm_stop(void);
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
2.43.0


