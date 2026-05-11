Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A675CD4840
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:30:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE3166B00EB; Mon, 11 May 2026 12:30:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D97BE6B00EF; Mon, 11 May 2026 12:30:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAD646B00F0; Mon, 11 May 2026 12:30:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ADD336B00EB
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:30:32 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B77E81C0237
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:30:30 +0000 (UTC)
X-FDA: 84755677020.16.163233C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2CCCA1A000F
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:30:29 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E2ntbFm1;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778517029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aFFEaveNcKwU0mv89CL34WsCl+/TQPTkhocfX1Lzq3A=;
	b=z2w7d5Mtov4VYXwoGlKLjK7xc+KvQCYK8ZN5H+V/i37sWpd75na1RoYsv0Rdi0B8UiuJgl
	RByGnLbzcPhbM2/g8GQ7gOaMG3AkmS3QW3CNKZ+w96+Ykn/MwV6GaJl8kzUs0LhDk+gFzb
	XSU7Modnk19AuDMY9GUeE5U2AJg8QT0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E2ntbFm1;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778517029; a=rsa-sha256;
	cv=none;
	b=lLOEE2gZSD2s9jvKuJBD091jA15nowEd5RgWJnDLK6O5DiUcD86qSLnV3JnRkE+9SfPRM6
	GsuugWdTQS7EuKg1Z//EI81Hv5zAiCXlfNtKmSSTV2Zd3P0FJ5lGsGdav3PLrwlO89vOYL
	h3FmWQYeiepBd0HqE5t2R/SNh9NIEO4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A0FC16111B;
	Mon, 11 May 2026 16:30:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52B56C2BCC9;
	Mon, 11 May 2026 16:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778517028;
	bh=irtJeJ9Xp2tg5Uc9BXYDe3Jhq/TwLOJXZp/PdiOKjq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E2ntbFm1Niaj86ijwOUDwV2Tn1p4LgWv7NQYyVRWROu9uJHyHdS+Um2++M/WolFOg
	 dTV4Tu5oCLKTLIkPDBfU6ZEZWPgkQ2mYRu03grnBI9D4UsprECjK+7m0owtVMyFtM7
	 I0EdDVYR9dEb4g9Pymbc9LewbfcGgvmAevBOQIQsOffLjJqxTSiAF7JTKAEbt7448b
	 hAd+bEPqdlL+3bU6UTOHT7qqD3M/kRhwOHpllW/0QwY5sh9tOrfD19wZrPhiJbpZc4
	 05hr2RdK8KxfhpzJ0ra61eZf0xK2CcUrVhlbNnHHy5kcjHq/AZfq/8UOIPoPtMGw4P
	 40PRJqW6WYNig==
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
Subject: [PATCH v4 15/55] selftests/mm: ksm_tests: use kselftest framework
Date: Mon, 11 May 2026 19:27:59 +0300
Message-ID: <20260511162840.375890-16-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511162840.375890-1-rppt@kernel.org>
References: <20260511162840.375890-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2CCCA1A000F
X-Stat-Signature: p71wsi9yeps7fnk347bcmy49j7y57uj7
X-HE-Tag: 1778517029-205252
X-HE-Meta: U2FsdGVkX19w2X0+VA5DTeuvy3l7AJyVCW+nXW+azVlhR8lQdSVnE/2jCpHwXnMM0HRR91O7t+v3n8QtObR57egzHev3Z8plgTCq+2iPo7LlyFyUhNpCjBgbBU26fIIzZh19OmBQXclel5ScBdNitValavACdE0v4taLCKdSfwRnchudG1uuZ9Ml6d6o7EagU4bBuzPrUF59Eg2kuqDtaYpVDwbxt6cDoMRj+l6S76JqilWliacXAZx5hV9YQk5htOVDUIhhOuTlOfafddh4uQw2PJxRY8IGlBqrwjjAmODSVcMlYoy/XtM3d6jbeyxwFpg7FrfPkZoqPvE4MNVj8xA0VWcQhJy/pCckLWNkoj8qcnCGHgkuyv7cNoWkIG5npdIf+S3vwVnhGbGZzkiBOVjVVb/AC4XfbNsz67ufqvW0jrFM/seBdfxKuyP32TMrxvzdTAiGqfc1qzupg5xzrv2Shj50IkHKJ3i9JaNtwOZnSSmIXO0u9TLKZvgNDTtHkNpKkentVM8p/5HMIk1mB6mvwFmJBIjRM1WXvKX6k20jymX8rHQWk9Ouqyrq2/VXN9eUVA1/mAGRx7tT9enbBt9XxmiUvQEg04fGqk4L+9OKdkDIsxr0RcUGgGi7DTYyp3fGnXPZ4raFyc0zL09A+TkVpnAgTDl1yeN7O7MvJjnYQpwj9gtqJaTqxrwZNaSl8Fx/Sqv2Anjnt2yR2enmhUjrVb1PI6f8AzoCB+/LP4Z8q4Pw8XQgLidsMkpiwRHe5TIsHJ5Ng88BTRb9b5tcizib4ZQ6H+6hI+Rv8n/i0TQmzVlQi15Zidx9CMHGw9knDUoOzrniI7T97bApkHcKsBciZm3CkNb3ZTwjrlSrYEgNDROD959wRqKmZ836WxhVxGKmgGWD9hE2w/2KibV/EtbSMg8M7OMCAKAIiWi2IfOSgYIVxToJEWZvKCwyz+Uuty4g+D1dtkmNMC02UT3
 C3+mx125
 YxvyNCe5G0C7rmk0JYmryMDjy2s/kCtz7T0Y9jpqjOadArn5mQHmYzcShSo7oN7YSG8UF30XHp0LgetcKwUy7ipMRr+UX1TLG83ZA9eJ3Z5ksOmwQfpnovfFK0Dxr7c5HOSY+1tfWd5uuJzvmVxTVyW6U5Gwr24a1seCXNuA5FBr32n3mtmMTkpoiz1y28EQPILccKRZWmQKWfvgPSHD25MfF8VVhxswHsEGSbNdZgqj+Pu9F7P4/hJdEkpDyMseKMKhqc0AiZKweV6BM2DCRQkox/tNiMRJ5rPTU11MQzVWE/GLUXFpCwZEP68LItSD2R6i26HkcdilqEyW7ch5hj8f5x5Aq/Tt5YAOgwWbng5OarQGcPSatqte4+BrZlzWxgC4kaU6Em1Fxe7g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Convert ksm_tests to use kselftest framework for reporting and tracking
successful and failing runs.

Reviewed-by: Donet Tom <donettom@linux.ibm.com>

Reviewed-by: Mark Brown <broonie@kernel.org>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Tested-by: Luiz Capitulino <luizcap@redhat.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/ksm_tests.c | 180 +++++++++++--------------
 1 file changed, 81 insertions(+), 99 deletions(-)

diff --git a/tools/testing/selftests/mm/ksm_tests.c b/tools/testing/selftests/mm/ksm_tests.c
index a0b48b839d54..0a5b38d3281c 100644
--- a/tools/testing/selftests/mm/ksm_tests.c
+++ b/tools/testing/selftests/mm/ksm_tests.c
@@ -175,12 +175,12 @@ static void  *allocate_memory(void *ptr, int prot, int mapping, char data, size_
 	void *map_ptr = mmap(ptr, map_size, PROT_WRITE, mapping, -1, 0);
 
 	if (!map_ptr) {
-		perror("mmap");
+		ksft_perror("mmap");
 		return NULL;
 	}
 	memset(map_ptr, data, map_size);
 	if (mprotect(map_ptr, map_size, prot)) {
-		perror("mprotect");
+		ksft_perror("mprotect");
 		munmap(map_ptr, map_size);
 		return NULL;
 	}
@@ -201,11 +201,11 @@ static int ksm_do_scan(int scan_count, struct timespec start_time, int timeout)
 		if (ksm_read_sysfs(KSM_FP("full_scans"), &cur_scan))
 			return 1;
 		if (clock_gettime(CLOCK_MONOTONIC_RAW, &cur_time)) {
-			perror("clock_gettime");
+			ksft_perror("clock_gettime");
 			return 1;
 		}
 		if ((cur_time.tv_sec - start_time.tv_sec) > timeout) {
-			printf("Scan time limit exceeded\n");
+			ksft_print_msg("Scan time limit exceeded\n");
 			return 1;
 		}
 	}
@@ -218,12 +218,12 @@ static int ksm_merge_pages(int merge_type, void *addr, size_t size,
 {
 	if (merge_type == KSM_MERGE_MADVISE) {
 		if (madvise(addr, size, MADV_MERGEABLE)) {
-			perror("madvise");
+			ksft_perror("madvise");
 			return 1;
 		}
 	} else if (merge_type == KSM_MERGE_PRCTL) {
 		if (prctl(PR_SET_MEMORY_MERGE, 1, 0, 0, 0)) {
-			perror("prctl");
+			ksft_perror("prctl");
 			return 1;
 		}
 	}
@@ -242,7 +242,7 @@ static int ksm_unmerge_pages(void *addr, size_t size,
 			     struct timespec start_time, int timeout)
 {
 	if (madvise(addr, size, MADV_UNMERGEABLE)) {
-		perror("madvise");
+		ksft_perror("madvise");
 		return 1;
 	}
 	return 0;
@@ -324,7 +324,7 @@ static int check_ksm_merge(int merge_type, int mapping, int prot,
 	struct timespec start_time;
 
 	if (clock_gettime(CLOCK_MONOTONIC_RAW, &start_time)) {
-		perror("clock_gettime");
+		ksft_perror("clock_gettime");
 		return KSFT_FAIL;
 	}
 
@@ -338,7 +338,6 @@ static int check_ksm_merge(int merge_type, int mapping, int prot,
 
 	/* verify that the right number of pages are merged */
 	if (assert_ksm_pages_count(page_count)) {
-		printf("OK\n");
 		munmap(map_ptr, page_size * page_count);
 		if (merge_type == KSM_MERGE_PRCTL)
 			prctl(PR_SET_MEMORY_MERGE, 0, 0, 0, 0);
@@ -346,7 +345,6 @@ static int check_ksm_merge(int merge_type, int mapping, int prot,
 	}
 
 err_out:
-	printf("Not OK\n");
 	munmap(map_ptr, page_size * page_count);
 	return KSFT_FAIL;
 }
@@ -358,7 +356,7 @@ static int check_ksm_unmerge(int merge_type, int mapping, int prot, int timeout,
 	int page_count = 2;
 
 	if (clock_gettime(CLOCK_MONOTONIC_RAW, &start_time)) {
-		perror("clock_gettime");
+		ksft_perror("clock_gettime");
 		return KSFT_FAIL;
 	}
 
@@ -380,13 +378,11 @@ static int check_ksm_unmerge(int merge_type, int mapping, int prot, int timeout,
 
 	/* check that unmerging was successful and 0 pages are currently merged */
 	if (assert_ksm_pages_count(0)) {
-		printf("OK\n");
 		munmap(map_ptr, page_size * page_count);
 		return KSFT_PASS;
 	}
 
 err_out:
-	printf("Not OK\n");
 	munmap(map_ptr, page_size * page_count);
 	return KSFT_FAIL;
 }
@@ -398,7 +394,7 @@ static int check_ksm_zero_page_merge(int merge_type, int mapping, int prot, long
 	struct timespec start_time;
 
 	if (clock_gettime(CLOCK_MONOTONIC_RAW, &start_time)) {
-		perror("clock_gettime");
+		ksft_perror("clock_gettime");
 		return KSFT_FAIL;
 	}
 
@@ -425,12 +421,10 @@ static int check_ksm_zero_page_merge(int merge_type, int mapping, int prot, long
 	else if (!use_zero_pages && !assert_ksm_pages_count(page_count))
 		goto err_out;
 
-	printf("OK\n");
 	munmap(map_ptr, page_size * page_count);
 	return KSFT_PASS;
 
 err_out:
-	printf("Not OK\n");
 	munmap(map_ptr, page_size * page_count);
 	return KSFT_FAIL;
 }
@@ -465,16 +459,16 @@ static int check_ksm_numa_merge(int merge_type, int mapping, int prot, int timeo
 	int first_node;
 
 	if (clock_gettime(CLOCK_MONOTONIC_RAW, &start_time)) {
-		perror("clock_gettime");
+		ksft_perror("clock_gettime");
 		return KSFT_FAIL;
 	}
 
 	if (numa_available() < 0) {
-		perror("NUMA support not enabled");
+		ksft_print_msg("NUMA support not enabled\n");
 		return KSFT_SKIP;
 	}
 	if (numa_num_configured_nodes() <= 1) {
-		printf("At least 2 NUMA nodes must be available\n");
+		ksft_print_msg("At least 2 NUMA nodes must be available\n");
 		return KSFT_SKIP;
 	}
 	if (ksm_write_sysfs(KSM_FP("merge_across_nodes"), merge_across_nodes))
@@ -485,7 +479,7 @@ static int check_ksm_numa_merge(int merge_type, int mapping, int prot, int timeo
 	numa1_map_ptr = numa_alloc_onnode(page_size, first_node);
 	numa2_map_ptr = numa_alloc_onnode(page_size, get_next_mem_node(first_node));
 	if (!numa1_map_ptr || !numa2_map_ptr) {
-		perror("numa_alloc_onnode");
+		ksft_perror("numa_alloc_onnode");
 		return KSFT_FAIL;
 	}
 
@@ -510,13 +504,11 @@ static int check_ksm_numa_merge(int merge_type, int mapping, int prot, int timeo
 
 	numa_free(numa1_map_ptr, page_size);
 	numa_free(numa2_map_ptr, page_size);
-	printf("OK\n");
 	return KSFT_PASS;
 
 err_out:
 	numa_free(numa1_map_ptr, page_size);
 	numa_free(numa2_map_ptr, page_size);
-	printf("Not OK\n");
 	return KSFT_FAIL;
 }
 
@@ -529,7 +521,7 @@ static int ksm_merge_hugepages_time(int merge_type, int mapping, int prot,
 	int pagemap_fd, n_normal_pages, n_huge_pages;
 
 	if (!thp_is_enabled()) {
-		printf("Transparent Hugepages not available\n");
+		ksft_print_msg("Transparent Hugepages not available\n");
 		return KSFT_SKIP;
 	}
 
@@ -559,36 +551,35 @@ static int ksm_merge_hugepages_time(int merge_type, int mapping, int prot,
 		else
 			n_huge_pages++;
 	}
-	printf("Number of normal pages:    %d\n", n_normal_pages);
-	printf("Number of huge pages:    %d\n", n_huge_pages);
+	ksft_print_msg("Number of normal pages:    %d\n", n_normal_pages);
+	ksft_print_msg("Number of huge pages:    %d\n", n_huge_pages);
 
 	memset(map_ptr, '*', len);
 
 	if (clock_gettime(CLOCK_MONOTONIC_RAW, &start_time)) {
-		perror("clock_gettime");
+		ksft_perror("clock_gettime");
 		goto err_out;
 	}
 	if (ksm_merge_pages(merge_type, map_ptr, map_size, start_time, timeout))
 		goto err_out;
 	if (clock_gettime(CLOCK_MONOTONIC_RAW, &end_time)) {
-		perror("clock_gettime");
+		ksft_perror("clock_gettime");
 		goto err_out;
 	}
 
 	scan_time_ns = (end_time.tv_sec - start_time.tv_sec) * NSEC_PER_SEC +
 		       (end_time.tv_nsec - start_time.tv_nsec);
 
-	printf("Total size:    %lu MiB\n", map_size / MB);
-	printf("Total time:    %ld.%09ld s\n", scan_time_ns / NSEC_PER_SEC,
+	ksft_print_msg("Total size:    %lu MiB\n", map_size / MB);
+	ksft_print_msg("Total time:    %ld.%09ld s\n", scan_time_ns / NSEC_PER_SEC,
 	       scan_time_ns % NSEC_PER_SEC);
-	printf("Average speed:  %.3f MiB/s\n", (map_size / MB) /
+	ksft_print_msg("Average speed:  %.3f MiB/s\n", (map_size / MB) /
 					       ((double)scan_time_ns / NSEC_PER_SEC));
 
 	munmap(map_ptr_orig, len + HPAGE_SIZE);
 	return KSFT_PASS;
 
 err_out:
-	printf("Not OK\n");
 	munmap(map_ptr_orig, len + HPAGE_SIZE);
 	return KSFT_FAIL;
 }
@@ -606,30 +597,29 @@ static int ksm_merge_time(int merge_type, int mapping, int prot, int timeout, si
 		return KSFT_FAIL;
 
 	if (clock_gettime(CLOCK_MONOTONIC_RAW, &start_time)) {
-		perror("clock_gettime");
+		ksft_perror("clock_gettime");
 		goto err_out;
 	}
 	if (ksm_merge_pages(merge_type, map_ptr, map_size, start_time, timeout))
 		goto err_out;
 	if (clock_gettime(CLOCK_MONOTONIC_RAW, &end_time)) {
-		perror("clock_gettime");
+		ksft_perror("clock_gettime");
 		goto err_out;
 	}
 
 	scan_time_ns = (end_time.tv_sec - start_time.tv_sec) * NSEC_PER_SEC +
 		       (end_time.tv_nsec - start_time.tv_nsec);
 
-	printf("Total size:    %lu MiB\n", map_size / MB);
-	printf("Total time:    %ld.%09ld s\n", scan_time_ns / NSEC_PER_SEC,
+	ksft_print_msg("Total size:    %lu MiB\n", map_size / MB);
+	ksft_print_msg("Total time:    %ld.%09ld s\n", scan_time_ns / NSEC_PER_SEC,
 	       scan_time_ns % NSEC_PER_SEC);
-	printf("Average speed:  %.3f MiB/s\n", (map_size / MB) /
+	ksft_print_msg("Average speed:  %.3f MiB/s\n", (map_size / MB) /
 					       ((double)scan_time_ns / NSEC_PER_SEC));
 
 	munmap(map_ptr, map_size);
 	return KSFT_PASS;
 
 err_out:
-	printf("Not OK\n");
 	munmap(map_ptr, map_size);
 	return KSFT_FAIL;
 }
@@ -646,37 +636,36 @@ static int ksm_unmerge_time(int merge_type, int mapping, int prot, int timeout,
 	if (!map_ptr)
 		return KSFT_FAIL;
 	if (clock_gettime(CLOCK_MONOTONIC_RAW, &start_time)) {
-		perror("clock_gettime");
+		ksft_perror("clock_gettime");
 		goto err_out;
 	}
 	if (ksm_merge_pages(merge_type, map_ptr, map_size, start_time, timeout))
 		goto err_out;
 
 	if (clock_gettime(CLOCK_MONOTONIC_RAW, &start_time)) {
-		perror("clock_gettime");
+		ksft_perror("clock_gettime");
 		goto err_out;
 	}
 	if (ksm_unmerge_pages(map_ptr, map_size, start_time, timeout))
 		goto err_out;
 	if (clock_gettime(CLOCK_MONOTONIC_RAW, &end_time)) {
-		perror("clock_gettime");
+		ksft_perror("clock_gettime");
 		goto err_out;
 	}
 
 	scan_time_ns = (end_time.tv_sec - start_time.tv_sec) * NSEC_PER_SEC +
 		       (end_time.tv_nsec - start_time.tv_nsec);
 
-	printf("Total size:    %lu MiB\n", map_size / MB);
-	printf("Total time:    %ld.%09ld s\n", scan_time_ns / NSEC_PER_SEC,
+	ksft_print_msg("Total size:    %lu MiB\n", map_size / MB);
+	ksft_print_msg("Total time:    %ld.%09ld s\n", scan_time_ns / NSEC_PER_SEC,
 	       scan_time_ns % NSEC_PER_SEC);
-	printf("Average speed:  %.3f MiB/s\n", (map_size / MB) /
+	ksft_print_msg("Average speed:  %.3f MiB/s\n", (map_size / MB) /
 					       ((double)scan_time_ns / NSEC_PER_SEC));
 
 	munmap(map_ptr, map_size);
 	return KSFT_PASS;
 
 err_out:
-	printf("Not OK\n");
 	munmap(map_ptr, map_size);
 	return KSFT_FAIL;
 }
@@ -695,24 +684,24 @@ static int ksm_cow_time(int merge_type, int mapping, int prot, int timeout, size
 		return KSFT_FAIL;
 
 	if (clock_gettime(CLOCK_MONOTONIC_RAW, &start_time)) {
-		perror("clock_gettime");
+		ksft_perror("clock_gettime");
 		return KSFT_FAIL;
 	}
 	for (size_t i = 0; i < page_count - 1; i = i + 2)
 		memset(map_ptr + page_size * i, '-', 1);
 	if (clock_gettime(CLOCK_MONOTONIC_RAW, &end_time)) {
-		perror("clock_gettime");
+		ksft_perror("clock_gettime");
 		return KSFT_FAIL;
 	}
 
 	cow_time_ns = (end_time.tv_sec - start_time.tv_sec) * NSEC_PER_SEC +
 		       (end_time.tv_nsec - start_time.tv_nsec);
 
-	printf("Total size:    %lu MiB\n\n", (page_size * page_count) / MB);
-	printf("Not merged pages:\n");
-	printf("Total time:     %ld.%09ld s\n", cow_time_ns / NSEC_PER_SEC,
+	ksft_print_msg("Total size:    %lu MiB\n\n", (page_size * page_count) / MB);
+	ksft_print_msg("Not merged pages:\n");
+	ksft_print_msg("Total time:     %ld.%09ld s\n", cow_time_ns / NSEC_PER_SEC,
 	       cow_time_ns % NSEC_PER_SEC);
-	printf("Average speed:  %.3f MiB/s\n\n", ((page_size * (page_count / 2)) / MB) /
+	ksft_print_msg("Average speed:  %.3f MiB/s\n\n", ((page_size * (page_count / 2)) / MB) /
 					       ((double)cow_time_ns / NSEC_PER_SEC));
 
 	/* Create 2000 pairs of duplicate pages */
@@ -724,30 +713,29 @@ static int ksm_cow_time(int merge_type, int mapping, int prot, int timeout, size
 		goto err_out;
 
 	if (clock_gettime(CLOCK_MONOTONIC_RAW, &start_time)) {
-		perror("clock_gettime");
+		ksft_perror("clock_gettime");
 		goto err_out;
 	}
 	for (size_t i = 0; i < page_count - 1; i = i + 2)
 		memset(map_ptr + page_size * i, '-', 1);
 	if (clock_gettime(CLOCK_MONOTONIC_RAW, &end_time)) {
-		perror("clock_gettime");
+		ksft_perror("clock_gettime");
 		goto err_out;
 	}
 
 	cow_time_ns = (end_time.tv_sec - start_time.tv_sec) * NSEC_PER_SEC +
 		       (end_time.tv_nsec - start_time.tv_nsec);
 
-	printf("Merged pages:\n");
-	printf("Total time:     %ld.%09ld s\n", cow_time_ns / NSEC_PER_SEC,
+	ksft_print_msg("Merged pages:\n");
+	ksft_print_msg("Total time:     %ld.%09ld s\n", cow_time_ns / NSEC_PER_SEC,
 	       cow_time_ns % NSEC_PER_SEC);
-	printf("Average speed:  %.3f MiB/s\n", ((page_size * (page_count / 2)) / MB) /
+	ksft_print_msg("Average speed:  %.3f MiB/s\n", ((page_size * (page_count / 2)) / MB) /
 					       ((double)cow_time_ns / NSEC_PER_SEC));
 
 	munmap(map_ptr, page_size * page_count);
 	return KSFT_PASS;
 
 err_out:
-	printf("Not OK\n");
 	munmap(map_ptr, page_size * page_count);
 	return KSFT_FAIL;
 }
@@ -765,6 +753,10 @@ int main(int argc, char *argv[])
 	bool use_zero_pages = KSM_USE_ZERO_PAGES_DEFAULT;
 	bool merge_across_nodes = KSM_MERGE_ACROSS_NODES_DEFAULT;
 	long size_MB = 0;
+	const char *test_descr = "KSM merging";
+
+	ksft_print_header();
+	ksft_set_plan(1);
 
 	while ((opt = getopt(argc, argv, "dha:p:l:z:m:s:t:MUZNPCHD")) != -1) {
 		switch (opt) {
@@ -773,17 +765,13 @@ int main(int argc, char *argv[])
 			break;
 		case 'p':
 			page_count = atol(optarg);
-			if (page_count <= 0) {
-				printf("The number of pages must be greater than 0\n");
-				return KSFT_FAIL;
-			}
+			if (page_count <= 0)
+				ksft_exit_fail_msg("The number of pages must be greater than 0\n");
 			break;
 		case 'l':
 			ksm_scan_limit_sec = atoi(optarg);
-			if (ksm_scan_limit_sec <= 0) {
-				printf("Timeout value must be greater than 0\n");
-				return KSFT_FAIL;
-			}
+			if (ksm_scan_limit_sec <= 0)
+				ksft_exit_fail_msg("Timeout value must be greater than 0\n");
 			break;
 		case 'h':
 			print_help();
@@ -805,19 +793,15 @@ int main(int argc, char *argv[])
 			break;
 		case 's':
 			size_MB = atoi(optarg);
-			if (size_MB <= 0) {
-				printf("Size must be greater than 0\n");
-				return KSFT_FAIL;
-			}
+			if (size_MB <= 0)
+				ksft_exit_fail_msg("Size must be greater than 0\n");
 			break;
 		case 't':
 			{
 				int tmp = atoi(optarg);
 
-				if (tmp < 0 || tmp > KSM_MERGE_LAST) {
-					printf("Invalid merge type\n");
-					return KSFT_FAIL;
-				}
+				if (tmp < 0 || tmp > KSM_MERGE_LAST)
+					ksft_exit_fail_msg("Invalid merge type\n");
 				merge_type = tmp;
 			}
 			break;
@@ -845,82 +829,80 @@ int main(int argc, char *argv[])
 			test_name = KSM_COW_TIME;
 			break;
 		default:
-			return KSFT_FAIL;
+			ksft_exit_fail_msg("Unknown option\n");
 		}
 	}
 
 	if (prot == 0)
 		prot = str_to_prot(KSM_PROT_STR_DEFAULT);
 
-	if (access(KSM_SYSFS_PATH, F_OK)) {
-		printf("Config KSM not enabled\n");
-		return KSFT_SKIP;
-	}
+	if (access(KSM_SYSFS_PATH, F_OK))
+		ksft_exit_skip("Config KSM not enabled\n");
 
-	if (ksm_save_def(&ksm_sysfs_old)) {
-		printf("Cannot save default tunables\n");
-		return KSFT_FAIL;
-	}
+	if (ksm_save_def(&ksm_sysfs_old))
+		ksft_exit_fail_msg("Cannot save default tunables\n");
 
 	if (ksm_write_sysfs(KSM_FP("run"), 2) ||
 	    ksm_write_sysfs(KSM_FP("sleep_millisecs"), 0) ||
 	    numa_available() ? 0 :
 		ksm_write_sysfs(KSM_FP("merge_across_nodes"), 1) ||
 	    ksm_write_sysfs(KSM_FP("pages_to_scan"), page_count))
-		return KSFT_FAIL;
+		ksft_exit_fail_msg("Cannot set up KSM tunables\n");
 
 	switch (test_name) {
 	case CHECK_KSM_MERGE:
+		test_descr = "KSM merging";
 		ret = check_ksm_merge(merge_type, MAP_PRIVATE | MAP_ANONYMOUS, prot, page_count,
 				      ksm_scan_limit_sec, page_size);
 		break;
 	case CHECK_KSM_UNMERGE:
+		test_descr = "KSM unmerging";
 		ret = check_ksm_unmerge(merge_type, MAP_PRIVATE | MAP_ANONYMOUS, prot,
 					ksm_scan_limit_sec, page_size);
 		break;
 	case CHECK_KSM_ZERO_PAGE_MERGE:
+		test_descr = "KSM zero page merging";
 		ret = check_ksm_zero_page_merge(merge_type, MAP_PRIVATE | MAP_ANONYMOUS, prot,
 						page_count, ksm_scan_limit_sec, use_zero_pages,
 						page_size);
 		break;
 	case CHECK_KSM_NUMA_MERGE:
+		test_descr = "KSM NUMA merging";
 		ret = check_ksm_numa_merge(merge_type, MAP_PRIVATE | MAP_ANONYMOUS, prot,
 					ksm_scan_limit_sec, merge_across_nodes, page_size);
 		break;
 	case KSM_MERGE_TIME:
-		if (size_MB == 0) {
-			printf("Option '-s' is required.\n");
-			return KSFT_FAIL;
-		}
+		if (size_MB == 0)
+			ksft_exit_fail_msg("Option '-s' is required\n");
+		test_descr = "KSM merge time";
 		ret = ksm_merge_time(merge_type, MAP_PRIVATE | MAP_ANONYMOUS, prot,
 				ksm_scan_limit_sec, size_MB);
 		break;
 	case KSM_MERGE_TIME_HUGE_PAGES:
-		if (size_MB == 0) {
-			printf("Option '-s' is required.\n");
-			return KSFT_FAIL;
-		}
+		if (size_MB == 0)
+			ksft_exit_fail_msg("Option '-s' is required\n");
+		test_descr = "KSM merge time with huge pages";
 		ret = ksm_merge_hugepages_time(merge_type, MAP_PRIVATE | MAP_ANONYMOUS, prot,
 				ksm_scan_limit_sec, size_MB);
 		break;
 	case KSM_UNMERGE_TIME:
-		if (size_MB == 0) {
-			printf("Option '-s' is required.\n");
-			return KSFT_FAIL;
-		}
+		if (size_MB == 0)
+			ksft_exit_fail_msg("Option '-s' is required\n");
+		test_descr = "KSM unmerge time";
 		ret = ksm_unmerge_time(merge_type, MAP_PRIVATE | MAP_ANONYMOUS, prot,
 				       ksm_scan_limit_sec, size_MB);
 		break;
 	case KSM_COW_TIME:
+		test_descr = "KSM COW time";
 		ret = ksm_cow_time(merge_type, MAP_PRIVATE | MAP_ANONYMOUS, prot,
 				ksm_scan_limit_sec, page_size);
 		break;
 	}
 
-	if (ksm_restore(&ksm_sysfs_old)) {
-		printf("Cannot restore default tunables\n");
-		return KSFT_FAIL;
-	}
+	if (ksm_restore(&ksm_sysfs_old))
+		ksft_print_msg("Cannot restore default tunables\n");
+
+	ksft_test_result_report(ret, "%s\n", test_descr);
 
-	return ret;
+	ksft_finished();
 }
-- 
2.53.0


