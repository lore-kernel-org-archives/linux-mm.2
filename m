Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94014C982DE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 10:37:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EA896B00CD; Mon, 21 Sep 2026 06:37:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79B066B00E9; Mon, 21 Sep 2026 06:37:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68A496B00EA; Mon, 21 Sep 2026 06:37:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 286986B00CD
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:37:01 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 535738013B
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:37:00 +0000 (UTC)
X-FDA: 85237416600.24.FCE3E52
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7D40240004
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:36:58 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Ei7qTMCy;
	spf=pass (imf12.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789987018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3pnpHLsisum1PADQYO86AzwbWkApMQ1fv0hZUjq/lYc=;
	b=NgKu/ptfrMZn6JcY4FDd+uDVG29VHWNOVizi/MLvI+OwHOWP2m7cvWbDeJlaNF+3m6ULKE
	7HNEY0ak/wMwry9Nkhqai1STjgryI6eOFq7rsQi7hibn45FBQrMN46T7gZxNkfJrg9XIey
	/sEyFmAykcQZ6tB3fFZC6S3bc26SC5g=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Ei7qTMCy;
	spf=pass (imf12.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789987018;
	b=hj4eitvM4JmHqxgby+x6gAn5h9mPZfqkrJ/bpJI8gDmzvn6NVDqnah2pNza7lGxRnh6P3f
	k35lBQAO1WnMM/qrJDPM1DWv+KiNAqbakUQH898VfQKRvPePLWWQ6CsIBhWvA92NEk7rBC
	hQVMfFcAG5fMR5wd2eZtEexsTZxzC8w=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3D9631D13;
	Mon, 21 Sep 2026 03:36:54 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 39F833F86C;
	Mon, 21 Sep 2026 03:36:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789987017; bh=YcmsRwqkmq6DR2vw/t8aIRJTeQ82knJAqyfDSfzeHKk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Ei7qTMCyC7vP03MwVR8bOQRsRLthyyotJhiMZfEUbdJo2KVM3GYScmVUfeLa8iZUx
	 CggZZdXCeZBwGEz5k3Z7qZm+1FHO1Kc7VcaZDQ9bGJJ6xuOiCiOSMuMEmaqj3O9gCz
	 DCXJ2dKs8Bcx8qttaDabAC/I7zn4zKlK/xBj+o2o=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Mon, 21 Sep 2026 11:36:39 +0100
Subject: [PATCH v4 2/3] kselftest: mm: remove HPAGE_SIZE and HPAGE_SHIFT
 macro
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-fix_hpage_macro-v4-2-cdea4fc6ce3f@arm.com>
References: <20260921-fix_hpage_macro-v4-0-cdea4fc6ce3f@arm.com>
In-Reply-To: <20260921-fix_hpage_macro-v4-0-cdea4fc6ce3f@arm.com>
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
 h=from:subject:message-id; bh=YcmsRwqkmq6DR2vw/t8aIRJTeQ82knJAqyfDSfzeHKk=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqsQi9IX3wVRgRopas3NHgcWeAi7I+4ITMIO7IL
 8xF9mSxtp6JAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCarEIvQAKCRBt1cPRWsUx
 M/w2C/9DHyglxpqKtN3D7aOzvJHD45wsRUOLR6NOGwAhGDuaE0HNaHKHZYcevNw8pb82E59dy6r
 549wwUp34Z8KYwGslEI0fNIZHVoZNjS52S3hmxbEUE/m9hEXX/etICsmbmaY3nOOWBRe/6/hobh
 XoF5M8reFfhbhVSrpjt2S1cmH8YosdMPI8oXEppwYLBzClPgcrkcobRKTfK6APjfA+WIba9RFf+
 OnVUB6nljJrOU2dgJxd5QH5qzgFOny7UROOdTeSf8seK9kPS3u312WPj6zIzZCZ0i7kWNNO3pQm
 0AINQ0PVgfhJqr2HtkkpAMWSxyu1i6kZ1UQlgFqa62e0aLeYXM1tydfSJXu+Y6PyYbLSMGUfEIB
 Iobt9ry1S78ZaIUCBF9jYOgXqjGmQLIs+/Par+Zt6DZbnH9LeP9raHiGCGg+ttD58EGz1dSzCH6
 GorZrCNnNkYMV++joM+2CSJdQAzz9JoyEipvd/jJOon1kdKgITslgeu14/2r4jWBolEGM=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7D40240004
X-Stat-Signature: ni8eebqqkryozqayxhnn1937secae9pn
X-Rspam-User: 
X-HE-Tag: 1789987018-840132
X-HE-Meta: U2FsdGVkX1/wDxeGQ7LKM6uWFy7pGLz+QqclGU5uy64iAgqD3wPGOTkaDJHKve4k1sQMuVsLpEdOt2fpdYlkExUGdgzt/PL+0UJy5F8FAVG43zNtz1eQe4kxfI189JUp4o55FMW+2puzFevVWWKUIPxKfuy+7prcRBqzx2LNs3UBXeQalUiHHpmE7SMbP4kyr7a94QzsHtOJl8ipsnqVpKAIGTnNDku8iwvOj/EUQ7mJthDNUCvHYq1ZY+LYgAFqFtyMhyr0HrUQ5sRvXLTxQDFfcpnPdu57RwfHW22fNVXb9Spd0pk0gHrL0ho9k7pDAbKZHCio/YW7iXKJgfVq16GrJ3UltuBjQUV9PR/wf1KY6RKUuVuFreYJOTjsnq8QhPwX8N7Tw0n5YyW1U/gu9K1PwVWvbp4dMG6PEDuuptvvXqEiiNuYU7rCFNCbwWsKzsU+Ac7YGWuA+HMkK9eF7AkPvG0Qq70qG3nESU6YIjK+J+iVwhm4pJXuMVxaEP/ANdlEiHgnjOeCzj9qd3s+iDvMB1mdcqogzQRwsERlT17ZqnsONxqlZPzigHTcO9WQi+RyuhI/9dkUW9+HySzJUsK/gmGi3la8Q8+LWlrqTwb/pDXevEFtYCfepadN1VKV+l4pwITkpWfj1d8H/CHrierxWM75lodvMMcr7P/YwSeosXZHWNvQfqU/ZSbaC/IwgcvcXuTF+mudh5B79QdX4qY+q0Cxi0i2H4QFooLhzn0v3SsQqGM5VQuyZkvhPUPEmcQiQLMr0jTyc/b2Ro3cZLTs5u6vwc/grKCT/9qbjAIMJ6oQQh4SELOPxurfU9XtNe8YDv7rduhcP7r1nUwA37MjwZRrz72mew4yiV5r5JP7XPWFHQbVH8wudkIgMTZ1WMv51uFaWHejShLlRpsBgPJWCkx3FEW5o+EQPWJkeK+9xlaY3c8gemjjGQMOQAtVDi+J17cpvZ4sWEqFYQ4
 ftmqw2QQ
 DM5egdk1NjfX6Cx4Q5ywQKiVXW2gClVG9APVxS+8wexUO9WSLvJBx2x4W6UcY5YQB/W1qSpkVkYKC8OocTcBnF1v+XikW/TGKOBemiRsd0B+Not7PmMrQPeKVsGOgQDqai1H8hE+yRsOC1gbBjx01mkblYAgva2JATy33rInPqlvskglCzJR5K9xWxS5uvdwuqXidYIfhsalbkmVH2dc9yEjjNglRf6DT7o/HwOmzPEhu5AgfLR+RZY+JjL78P95iiGx3umjC3/IYr2bdVn/MxlcZhZC+bhXQrgwW9S7ADhHaJ5P5oJZqT2CMPs9TRzNCwWGzkmyPulkEJYRNyBIR05U6CN/ZC/yctg0t
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
index b724d62d2b755..eee29ef88cb20 100644
--- a/tools/testing/selftests/mm/guard-regions.c
+++ b/tools/testing/selftests/mm/guard-regions.c
@@ -2195,14 +2195,21 @@ TEST_F(guard_regions, pagemap_scan)
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
index 5fd7792a0d479..617e31138af06 100644
--- a/tools/testing/selftests/mm/ksm_tests.c
+++ b/tools/testing/selftests/mm/ksm_tests.c
@@ -521,19 +521,23 @@ static int ksm_merge_hugepages_time(int merge_type, int mapping, int prot,
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
index 19755fb4edb94..345d1a79f07ef 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -378,8 +378,8 @@ fi
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
index 8eb0c5630e7e3..40ca224a61f49 100644
--- a/tools/testing/selftests/mm/transhuge-stress.c
+++ b/tools/testing/selftests/mm/transhuge-stress.c
@@ -35,12 +35,17 @@ int main(int argc, char **argv)
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
index e712a980851c8..8f80e73dc22a5 100644
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
@@ -452,14 +475,19 @@ bool check_huge_shmem(void *addr, size_t len, int nr_hpages, uint64_t hpage_size
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
@@ -471,7 +499,7 @@ int64_t allocate_transhuge(void *ptr, int pagemap_fd)
 
 	if (PAGEMAP_PRESENT(ent[0]) && PAGEMAP_PRESENT(ent[1]) &&
 	    PAGEMAP_PFN(ent[0]) + 1 == PAGEMAP_PFN(ent[1]) &&
-	    !(PAGEMAP_PFN(ent[0]) & ((1 << (HPAGE_SHIFT - pshift())) - 1)))
+	    !(PAGEMAP_PFN(ent[0]) & ((1 << (hpage_shift - pshift())) - 1)))
 		return PAGEMAP_PFN(ent[0]);
 
 	return -1;
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index a40e40c820ef7..71af4804f8f24 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -31,6 +31,8 @@
 
 extern unsigned int __page_size;
 extern unsigned int __page_shift;
+extern uint64_t __pmd_psize;
+extern uint64_t __pmd_pshift;
 
 /*
  * Represents an open fd and PROCMAP_QUERY state for binary (via ioctl)
@@ -89,6 +91,7 @@ unsigned long pagemap_get_pfn(int fd, char *start);
 void clear_softdirty(void);
 bool check_for_pattern(FILE *fp, const char *pattern, char *buf, size_t len);
 uint64_t pmd_psize(void);
+uint64_t pmd_pshift(void);
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
2.43.0


