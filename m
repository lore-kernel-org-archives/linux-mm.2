Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF917FF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 20:44:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18C696B00B0; Tue, 28 Apr 2026 16:44:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 165826B00B2; Tue, 28 Apr 2026 16:44:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 053B96B00B3; Tue, 28 Apr 2026 16:44:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E524E6B00B0
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:44:32 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AFF2F1C0692
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:44:32 +0000 (UTC)
X-FDA: 84709142784.02.C3B611A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 030C91C000D
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:44:30 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EaYnb5O4;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777409071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OttZd6LEokjkRam5NJw2XXG359i1yJ+9wVwzPCr4HSg=;
	b=7eCycEdWcGJICfU/e553e/UFx2+PPx5WiT/HBtojFkorOGXq2a7sWW3PYYkVM9tdrKizz2
	0gSus0BPdVJ5bSD36ZzIz5VFeEcIcGWfz/YnBB1OV+Dc9la/z8jv3oyOdPXxCD1F7qVPaJ
	zxNgAJwEZK+YFPWHzyPBM9kAvW43RY0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EaYnb5O4;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777409071; a=rsa-sha256;
	cv=none;
	b=EovX1BB06i1cSl7ZvN7HL6p6Y87hwAbiqmNHsQBUcINtaHFKa7D3Fm5jdm5rRMQl6UXSNJ
	arMpPtH3wqHVc8iM7DQhO8rsZxPWv8ZZB61hnKUkuLM00sV+G30zY4mup7g6s+Z7pmtFwK
	uroamkaxsQhRKn+n+WIfSentRpcsXJU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2C3D14428A;
	Tue, 28 Apr 2026 20:44:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03364C2BCAF;
	Tue, 28 Apr 2026 20:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777409070;
	bh=xsBdrafAcXHUzee2NfWszrgSyC/tQCheWL0+4hzUfOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EaYnb5O4VMdme+q7lnB34iWoI+U1jjtCvLZmRlNIe9TSLc3O48kINCWBsNWr6VnKY
	 7+Cgf/x+DKVMb2vB/DAnj2t1E3RKVlqITaFC+T2iyIbGS8eDLuNcE3qVFl4U2sSbs7
	 wyd+tEI7hPwIQseTZhxLISWhsE7E5kOhvH3UbOuFqXl3ngjMao6Huqz2XmwxfXgaCl
	 Z+oez/xDfmw6SjXEAFJb19avON4QCv49b6/cb2Xr5BQMr/dE+KebJviFIf8tFDIqZm
	 Z0KzMntmS11RyWl7+QLcC98Nx+zZTf5l7/fjBa4g/cDof+eINvrfYXGCCGxC/iqvDl
	 Mhiu2ykZo7oLw==
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
Subject: [PATCH v3 15/54] selftests/mm: ksm_tests: use kselftest framework
Date: Tue, 28 Apr 2026 23:42:01 +0300
Message-ID: <20260428204240.1924129-16-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428204240.1924129-1-rppt@kernel.org>
References: <20260428204240.1924129-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pzw987cgqf459ox3cwmaa3ir869jgb6i
X-Rspamd-Queue-Id: 030C91C000D
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777409070-823371
X-HE-Meta: U2FsdGVkX19GAzIZQgtcA/p8IyGy8E+Cldq4BRuJN0fY91xuoiFIP7PLyBD89qcfkfFbar7pHZr5NoIEAia2VI7pZCz2xMBX8yE1LX5g7wSBxDY91pwNhE3ho7lIAWu6rn7Z0pX7lyVJSWidQ2VzjwSD5R4InhSCEWctKnm8BipIllub7Y0yuHkMKF94AUf28kYmaP6P12EXv40sJSqVYSGHcPmL+cdp/CggrNSVV/E1SosjIvolYTxTTnwruXhD285CJOGxHJkyKLkrXuaPFjqVjTE/ELQDEy1k4SntH6tI1nXxwzf9RRVcZSQVrO1wklAtPii1chlk8WfikFTsDsq0bACj00bPxtE4hgBdJjqxbHGWaNjydRTMjXq0x8d3vSMO/nzRjYKDUsr5ZgSBzGsOhmMTLNYLrTnyDQCMEwja4983vPa1jRu9n0uFHNBJnb1vMILI2r4O44SGmDWWNpiOl3pXx3IGCEKQr7a87OBaFd0fVrASo+4Hbafo+FATSW/EMdVw5J+7p5RPTEiBxrVzZCEOI7s5YgdBh8EscDd1jTBT7hXQhwQOthFDNIs7T/keMwR3J1lRi64sJGoF7LrJ2OCSMK3/Y6SbMvVDF6sau6p8kt3pfbJGbG8rrpw2h8pREHp+N4nJzuOaOgx6JkRa/AZFB4ZvJsyU7NYCyH5B4uf6TAezh1gaJJsFe3oul6IWS811HHkdjO3laSzFyYHcRdC8FjcW85pEwWUqZEKIj5q56/FJeD/Dh30vZAmhdeK1OlgTYBmcxcdcXY/keAIsj+6DzqLP9zW3FBuQxH33a4B6P7l5zmER4eOxP6hUALZCz68dhJmZz+i6sH1Mk4Ag2pWYvsdvBdbNFa8v1tptYBJ7z/sM9rRBwFHNgEC60m300BEdYAsp3zIFPJ+4cl5Tmf9H67RqrmcZbaxU3cduhVM19Q/cVDgjFwru0MJai6Nz80US+1lNpjOVxYs
 AHin4KW0
 autS1828nCEMFx+wBqUCb4XcCWn57gKn72KLYBMhL1HyHYbDqQAK8Hbv4UgF5Af5A1EOqnSbLqeCKRZmNqDJthoBktHQTt/m60fOK6tpyrAH0fARp/PifsPUFAiP38KlYpUnvfwaI0Q47E1RQms10qGhWvB7aw2OPxMFi/5BPEIN9oPMX1h8rPjbduijvZ9awOa6u/25LdU63b6FfppJ5AgWQA9UJ9zJX/rW8NiNgEp+or7HNLEjKRB2k2sMUD3KixzYkT/yAY2VURREaqP2mzvAGx9jUzGgIE6ces3N6E4w6Yfxz4ZUs1FR0Dw==
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

Reviewed-by: Mark Brown <broonie@kernel.org>
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


