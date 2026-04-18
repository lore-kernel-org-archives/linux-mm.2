Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2760F99C79
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 10:57:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 150E86B024A; Sat, 18 Apr 2026 06:57:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DA4D6B024C; Sat, 18 Apr 2026 06:57:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0C876B024D; Sat, 18 Apr 2026 06:57:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D9B776B024A
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 06:57:17 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6BED28BA04
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:57:17 +0000 (UTC)
X-FDA: 84671374914.05.E9CBEE8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id D0C07C000F
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:57:15 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YwxfuNys;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776509835; a=rsa-sha256;
	cv=none;
	b=TAU7kDdJAfJoWGWoDNgJm4Ok4sKBaeYw3v9roaOKOBqyRG4pq+f7nvF7eUfK+s4ZpgvIEI
	1X7jzzOIXlK+h+R/K1YtEErLP41dpiww2sAy/Y9YlxhCnYBeUVzPatb+iyU8fQHnVaO052
	gqkARGRCbxw0FQG/dHL4Xdot54kf8kU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YwxfuNys;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776509835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NZbtysvGzpZB6FaE0QnAXbOw7Rx11gasNE2LsW2KxzE=;
	b=V5xYm80rqLcGIFS1lwCp1TNQoG48GwZjGPdbLSCNPnK+96u7hxPxoxXr3wmLaPue37IIKu
	aGjw6keEkaW0jgjMFAUY4cyVbrfh/Dd/Cbp9GJOZSwGQOweFKUsQ/ojOySrOJQoZrehTrR
	cYFlUYR2/YhTilJ8HXiWE+Ekzecd3lY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2966860154;
	Sat, 18 Apr 2026 10:57:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CA82C19424;
	Sat, 18 Apr 2026 10:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776509834;
	bh=s7qCaK8eYyjpC8iMd+nVpGF4CVX3P7RZaFzSjABV29M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YwxfuNysGoONtQZcpU74Lnk/qSgvs0RQ+na3WbwNcs0J2Dy0XLANA6QtwkBZEsWmQ
	 4SQUfbsU0moTaijMmgu+Gyw+1r7GDI5p5h4bIf5Bx9SJNUnYoKjvP/BqxwZECVGbHT
	 INW6dmEq6tnJ8h57wWFe8PFST/5fh9187vboV8UiGmymd072wy93JG9p4NJK6Hrtcm
	 8XsK4qA8OfKwwpEjgh8D8UGEGInmcU+LGgojIuq7CpTGvemjNq3+3AFf0oxGQvhOtt
	 H9F8XGhcwEZeL2bkhj37aAlHcf8dmY0EEWREBXAPVQ+lCRamoAJyf1oJ+xxNA0ezmN
	 lKsEDG67/yxng==
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
Subject: [PATCH v2 14/53] selftests/mm: ksm_tests: use kselftest framework
Date: Sat, 18 Apr 2026 13:54:59 +0300
Message-ID: <20260418105539.1261536-15-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260418105539.1261536-1-rppt@kernel.org>
References: <20260418105539.1261536-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D0C07C000F
X-Stat-Signature: zg1eas9t6sxu9pbcn3x89b3y4exi55wc
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776509835-701976
X-HE-Meta: U2FsdGVkX1/BtcMq56LMAHpP27vJwAeCpO8GcFmNsuS2eR9d85OUi/UyGH3Sd+yCwAI/SZeDU+qoh6dVNezjaoFo91iQr47zreu2ttju/Og8zZQs4bPaGcQobiEe0j1BzY5XythoI6pGzIEkYir42QQMrQE5/KL5c4wO6MKaKKuEEwU1CP8g3bTf3moaI8Q2ZDwytZLP5CHJJlok9ghR2W3BJcZwOYkqvR7wBlHf6q6Ap2UBwYQZWnHCDDfOsh70vznfv1jZVWqTBhWjyg5s+3Mky/afN9OVLv0uCjws8sDDYxOlboO9/PBsE2DNufxInboirAp3JXXlcwwV7DMhD0Riskz3WK7uByMtGyorsCmvT2yE4y7xiiHtChFzwsk32hsFIirGq2HH2CyTAi2jgwCbyVdev5GDlffwjRlnqYYBSdnFhhwoCmcxlPDi514liHZPENf75nGm+XLC5K5E36JNFGRBAhtp4uh0x562nU+W+TwqYbe7jcIy98hOQETs9xJGwNdM4CTbTL6a9+TH3e054dtY/IXtqRlRRm2fCt40bhKOqafw/6LdZBdwpnOgYEBDl8Bze2lIiHmDSEhDI0vu5AWPvKdMH1ZHMv1GfNHBj+aJnzqfcqLVbKDv+crm2S1n6yYj6WXPaQ4Ay2XZkSiSwK6bAG+MHO1WgqbSTQpVfB63s6igSzq/2RKVw+4CfxopDJdhTyHuxayK6i3C6AvVJHPSoULRD+x5o6zmsLOuBjEMR4cD6zlP5f0k+2FRgAxO0VWmyOmEp3C9gjLU5uRaUBZCnzdxIBlcz1zzaOv8+LOLHIC9Uh+f+k732LDSm9ERf2HTeHL00wR038ELeEgTs2lBvjqBZ0Kjyzo/JaSpXEI5nnnUg0sZYO1WhxkVgBuV6t4CZi5joktLKFMKmOHnw7okKARD4qhBe1ymaCDSMB287t5en68rZvG7cO/dC1+AxNcSVWiwZV2nnjB
 r3uCvn6J
 L0f2c5lmAE1FKezkFpFr1X7KXunptkZcMnnQOG7awZUUy6irNBbBZDldbOfY3Bfk17C9zgflOe3VcTxVVtz6TYR+v/NlXKH0iQvCLfx5X1peiv797RxIo+gXkijVFen1KP7JNW70gvz0gmwsl61MWUFpqvOMD67Rs8+bYTmuqhx+pU7NFI6kJx2sAWAvT1mAQoTlfpFrdisWrKWeaD5lASqeBYemTtyP2hZoz0AMOudMmy9Sm3ggyX1gCrxnlLws2oiJbs2HniibHJFKy0JCKFFhWihgecABsg7JZ+w7wULlTliFyQLYcEg9/Pg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Convert ksm_tests to use kselftest framework for reporting and tracking
successful and failing runs.

Reviewed by: Donet Tom <donettom@linux.ibm.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/ksm_tests.c | 180 +++++++++++--------------
 1 file changed, 81 insertions(+), 99 deletions(-)

diff --git a/tools/testing/selftests/mm/ksm_tests.c b/tools/testing/selftests/mm/ksm_tests.c
index a0b48b839d54..752a2c0d06ab 100644
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
+		ksft_perror("NUMA support not enabled");
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


