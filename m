Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FFF2F46C46
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 14:20:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E78996B00C5; Mon,  6 Apr 2026 10:20:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E29576B00C7; Mon,  6 Apr 2026 10:20:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D664A6B00C8; Mon,  6 Apr 2026 10:20:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C56136B00C5
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 10:20:13 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9E1208B9CE
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:20:13 +0000 (UTC)
X-FDA: 84628340706.02.589C377
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0BE2AC0009
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:20:11 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f5NigmBK;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775485212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HmaUvHDAKcCRseeJrg1xeCJxe/RzWwwd0KNM+8O6JtY=;
	b=k0PntkbzIAlIr9qm6UrrOE43cqmDvmokmQ6G7mgAj3c5LDO5h3zWWEjoTXGm4CKy6XKYzj
	K5IMbSfAIflR0sKE7s5JQgLDkBe0/WMT2fJsSzznZ1R9hfAIJemPiUPilbqjruK5juJLUY
	INJWRs31769ii83C+9duSKCL8aBLDdE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775485212; a=rsa-sha256;
	cv=none;
	b=Mx24phduWbcI0ZkqbTpRLbcWeZrX9YybKfkIAp73xk2Q0pwtwfkWpn3Shk8AFQzqMox3Li
	7VfrbI1DuhJGDi86YBrca6MnUggMNCeCUe/VcVBpmkqcVaLfPIGNp4aVQJcdy5Yd1BqHi3
	y9ihUyqP/HLHkMFO3AmjRc/R3RxVipU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f5NigmBK;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8B0396012A;
	Mon,  6 Apr 2026 14:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0098DC2BCAF;
	Mon,  6 Apr 2026 14:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775485211;
	bh=jAQxw9MbYkXsl544OFupWFjq2DLx0d+HujNgYQfq/0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f5NigmBK8QIOfJAopcw9vRcnIMffZrXxyBZSo7UgnuIqg8qJ3EeqB6BEAmZnKcOaJ
	 etrVP2Hz2l8un6VhkhrUzhz1de++sY4Qm7criGycPGBbU5QrFF5ebl8906dGI4013I
	 fTdlKe/oUQpS7wLKLisddcmLAKu7KgOLpM8RQBBYhozdeBtejjuaYQeILoYCPfQMxP
	 /cWYme2Mtc6xj8cNJWrisWM8IdfI3o26zSGyVzhYRa8qToK/mDp1rMBMP6+QLvYtS8
	 npzHjmE6BVJI6X+x2khvabMNTmwk6CV8WNOIE53D4JIFY1J1VbaIa51lAXDQhQfseg
	 QtKK/E1dPGCwA==
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
Subject: [PATCH 25/53] selftests/mm: hugepage_settings: rename get_free_hugepages()
Date: Mon,  6 Apr 2026 17:17:07 +0300
Message-ID: <20260406141735.2179309-26-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260406141735.2179309-1-rppt@kernel.org>
References: <20260406141735.2179309-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0BE2AC0009
X-Stat-Signature: 5xwpeige1acmgiq896mfb569wgnerzo8
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775485211-8588
X-HE-Meta: U2FsdGVkX18pH4sFbH1gCwofdScOir7LEZZDfyf3ickDiEhG+OpQcqHqsDUEeeh4Gd5f77L7EJlRbg+uEWSEtaoKnzlQcxZ1XH5HqcYh29Bxvcpy2o4ghvh19QbK6dgmD1kJ1uhHrwsU49lwb+HwdtWXFjcUKPHW0J2o+ywBVL/dd9qxnJazfvAFLLY+Ksj7w660B0DYpEem7B1qp3cnkwPHf/42H2i27GDWaQD6UqMrNTcGpU3/ZNgyVfQ6SNd6Yrn2J33rvNJd3z7gtgOl1zF0VOonQgBVJUhpA8WNoDSaa6oipGBbBUsVMaIwlgd4pIvNYR6RMY7iyh5Uliqiqy8/tKTzm9iSs6C/guUv2Q6MRKOBJHvDTZNGlL73tG9+Rw0Kr3+OsH8ZZN3GYLeLBThbmSuWRFm34gNhK60LAp+Cb3cmP/zbg/C8ngS5UGBrkKyuvTt8TPkhSrMW7tg2PZh0M5703sGA7vBmf+455d68qXWkxF8sfgTrUw4oeO+v2N2K4ye+84aMqgQTs159CyRnkNqRuuBkW4C1sYLDIowT3Qm+ZfJrSxG4i3DZhlnCU2W+R8nHN6OPFBXI60E+4rWUFdIK/nPbLhJooN0I32Kq6aqzitzrx1IL076zJTHEdDCu9wAiXwBFzL00+DeEnMzN08V/uv8fVBgStP+g384Lf+/3aN9tnataBDH55xUrvUHa828k2KtPnVMzbAM480sYdoCD0LCfNMzYA8OzDo9lqOEAKxug5KHk/9/m9x9SyMKAjUPjzlT0VQgLwdwVUaDF/74PLCZJ3ewQtGTiBJhF+NNmSXmL++gGmwok02jLXtjvETgtLahb7aZVjXj3/s6GDs/h2rjhICNd6ClIaw2sdxlAhSlVGaJ2Rxrkfx5YOgUoxzdQiB5nhEmMM1OpFEd5y7wCusfm3bDE9273YGaZOG9nNiNHT542MU2jUDgMidN0kiZrhHGCVVv/WjM
 uD2AbQ0H
 JZXdPl5B3dgKuLPxanx9sngGl7g/tK5vRwg6Sa8l7pChPZUUbl3iyjbnrioccgup6yrBxQnrFAp84stPb5JVvTvk5YOkSsVfLInoTlsO0LzQL4yZ3Vnt/j2WJSoptTA6N6ZfcC+g86798X24O4DZ8txoZCq5/bKa2dpmqhXh39VaVZ8NHvcCnGzkP8zHBRFdgptvkQ/iKP3BzDLb+g6bfI4YAhZ7QYSFbUcKUQHIvbV7AdqeqktuOwEXmRv+xWtJ36NcNE+xKIYxg+TBRQ/S8BWqRWAr1eY3Fu6rl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

... to hugetlb_free_default_hugepages() for consistency with
hugetlb_nr_default_pages().

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 .../testing/selftests/mm/hugepage_settings.c  | 28 ++++++-------------
 .../testing/selftests/mm/hugepage_settings.h  | 12 +++++++-
 tools/testing/selftests/mm/hugetlb-madvise.c  |  4 +--
 tools/testing/selftests/mm/hugetlb_dio.c      |  6 ++--
 .../selftests/mm/hugetlb_fault_after_madv.c   |  2 +-
 .../selftests/mm/hugetlb_madv_vs_map.c        |  2 +-
 tools/testing/selftests/mm/uffd-stress.c      |  2 +-
 7 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/tools/testing/selftests/mm/hugepage_settings.c b/tools/testing/selftests/mm/hugepage_settings.c
index 5961229b9931..4ae7332b5e1b 100644
--- a/tools/testing/selftests/mm/hugepage_settings.c
+++ b/tools/testing/selftests/mm/hugepage_settings.c
@@ -446,25 +446,6 @@ unsigned long default_huge_page_size(void)
 	return hps;
 }
 
-unsigned long get_free_hugepages(void)
-{
-	unsigned long fhp = 0;
-	char *line = NULL;
-	size_t linelen = 0;
-	FILE *f = fopen("/proc/meminfo", "r");
-
-	if (!f)
-		return fhp;
-	while (getline(&line, &linelen, f) > 0) {
-		if (sscanf(line, "HugePages_Free:      %lu", &fhp) == 1)
-			break;
-	}
-
-	free(line);
-	fclose(f);
-	return fhp;
-}
-
 static void hugetlb_sysfs_path(char *buf, size_t buflen,
 			       unsigned long size, const char *attr)
 {
@@ -489,3 +470,12 @@ void hugetlb_set_nr_pages(unsigned long size, unsigned long nr)
 
 	write_num(path, nr);
 }
+
+unsigned long hugetlb_free_pages(unsigned long size)
+{
+	char path[PATH_MAX];
+
+	hugetlb_sysfs_path(path, sizeof(path), size, "free_hugepages");
+
+	return read_num(path);
+}
diff --git a/tools/testing/selftests/mm/hugepage_settings.h b/tools/testing/selftests/mm/hugepage_settings.h
index d6f41a45e8ee..57fbf2f57e13 100644
--- a/tools/testing/selftests/mm/hugepage_settings.h
+++ b/tools/testing/selftests/mm/hugepage_settings.h
@@ -92,10 +92,10 @@ bool thp_is_enabled(void);
 
 int detect_hugetlb_page_sizes(unsigned long sizes[], int max);
 unsigned long default_huge_page_size(void);
-unsigned long get_free_hugepages(void);
 
 unsigned long hugetlb_nr_pages(unsigned long size);
 void hugetlb_set_nr_pages(unsigned long size, unsigned long nr);
+unsigned long hugetlb_free_pages(unsigned long size);
 
 static inline unsigned long hugetlb_nr_default_pages(void)
 {
@@ -117,4 +117,14 @@ static inline void hugetlb_set_nr_default_pages(unsigned long nr)
 	hugetlb_set_nr_pages(size, nr);
 }
 
+static inline unsigned long hugetlb_free_default_pages(void)
+{
+	unsigned long size = default_huge_page_size();
+
+	if (!size)
+		return 0;
+
+	return hugetlb_free_pages(size);
+}
+
 #endif /* __THP_SETTINGS_H__ */
diff --git a/tools/testing/selftests/mm/hugetlb-madvise.c b/tools/testing/selftests/mm/hugetlb-madvise.c
index 316384d919db..3c08eb6db6a2 100644
--- a/tools/testing/selftests/mm/hugetlb-madvise.c
+++ b/tools/testing/selftests/mm/hugetlb-madvise.c
@@ -27,7 +27,7 @@
 
 #define validate_free_pages(exp_free)					\
 	do {								\
-		unsigned long fhp = get_free_hugepages();		\
+		unsigned long fhp = hugetlb_free_default_pages();		\
 		if (fhp != (exp_free))					\
 			ksft_exit_fail_msg("Unexpected number of free "	\
 				"huge pages %ld, expected %ld line %d\n", \
@@ -68,7 +68,7 @@ int main(int argc, char **argv)
 	if (!base_page_size)
 		ksft_exit_fail_msg("Unable to determine base page size\n");
 
-	free_hugepages = get_free_hugepages();
+	free_hugepages = hugetlb_free_default_pages();
 	if (free_hugepages < MIN_FREE_PAGES)
 		ksft_exit_skip("Not enough free huge pages (have %lu, need %d)\n", free_hugepages, MIN_FREE_PAGES);
 
diff --git a/tools/testing/selftests/mm/hugetlb_dio.c b/tools/testing/selftests/mm/hugetlb_dio.c
index 81e3f7bc8e76..47019433ddaf 100644
--- a/tools/testing/selftests/mm/hugetlb_dio.c
+++ b/tools/testing/selftests/mm/hugetlb_dio.c
@@ -93,7 +93,7 @@ static void run_dio_using_hugetlb(int fd, unsigned int start_off,
 		ksft_exit_fail_perror("lseek failed\n");
 
 	/* Get the free huge pages before allocation */
-	free_hpage_b = get_free_hugepages();
+	free_hpage_b = hugetlb_free_default_pages();
 	if (free_hpage_b == 0) {
 		close(fd);
 		ksft_exit_skip("No free hugepage, exiting!\n");
@@ -121,7 +121,7 @@ static void run_dio_using_hugetlb(int fd, unsigned int start_off,
 	munmap(orig_buffer, h_pagesize);
 
 	/* Get the free huge pages after unmap*/
-	free_hpage_a = get_free_hugepages();
+	free_hpage_a = hugetlb_free_default_pages();
 
 	ksft_print_msg("No. Free pages before allocation : %d\n", free_hpage_b);
 	ksft_print_msg("No. Free pages after munmap : %d\n", free_hpage_a);
@@ -142,7 +142,7 @@ int main(void)
 	ksft_print_header();
 
 	/* Check if huge pages are free */
-	if (!get_free_hugepages())
+	if (!hugetlb_free_default_pages())
 		ksft_exit_skip("No free hugepage, exiting\n");
 
 	fd = open("/tmp", O_TMPFILE | O_RDWR | O_DIRECT, 0664);
diff --git a/tools/testing/selftests/mm/hugetlb_fault_after_madv.c b/tools/testing/selftests/mm/hugetlb_fault_after_madv.c
index abc3904c5268..c718dd065d53 100644
--- a/tools/testing/selftests/mm/hugetlb_fault_after_madv.c
+++ b/tools/testing/selftests/mm/hugetlb_fault_after_madv.c
@@ -78,7 +78,7 @@ int main(void)
 	ksft_print_msg("[INFO] detected default hugetlb page size: %zu KiB\n",
 		       huge_page_size / 1024);
 
-	free_hugepages = get_free_hugepages();
+	free_hugepages = hugetlb_free_default_pages();
 	if (free_hugepages != 1) {
 		ksft_exit_skip("This test needs one and only one page to execute. Got %lu\n",
 			       free_hugepages);
diff --git a/tools/testing/selftests/mm/hugetlb_madv_vs_map.c b/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
index ac60b4f18784..dfbd71a7f709 100644
--- a/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
+++ b/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
@@ -89,7 +89,7 @@ int main(void)
 	ksft_print_header();
 	ksft_set_plan(1);
 
-	free_hugepages = get_free_hugepages();
+	free_hugepages = hugetlb_free_default_pages();
 
 	if (free_hugepages != 1)
 		ksft_exit_skip("This test needs one and only one page to execute. Got %lu\n",
diff --git a/tools/testing/selftests/mm/uffd-stress.c b/tools/testing/selftests/mm/uffd-stress.c
index e92a85463eb1..7e37cf3d27f6 100644
--- a/tools/testing/selftests/mm/uffd-stress.c
+++ b/tools/testing/selftests/mm/uffd-stress.c
@@ -480,7 +480,7 @@ int main(int argc, char **argv)
 	 * for racy extra reservation of hugepages.
 	 */
 	if (gopts->test_type == TEST_HUGETLB &&
-	   get_free_hugepages() < 2 * (bytes / gopts->page_size) + gopts->nr_parallel - 1)
+	   hugetlb_free_default_pages() < 2 * (bytes / gopts->page_size) + gopts->nr_parallel - 1)
 		ksft_exit_skip("Skipping userfaultfd... not enough hugepages\n");
 
 	gopts->nr_pages_per_cpu = bytes / gopts->page_size / gopts->nr_parallel;
-- 
2.53.0


