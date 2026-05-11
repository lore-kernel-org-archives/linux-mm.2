Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45600CD4840
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:31:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8DD66B0104; Mon, 11 May 2026 12:31:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3DD96B0105; Mon, 11 May 2026 12:31:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97B106B0106; Mon, 11 May 2026 12:31:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 880C16B0104
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:31:49 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4E8B51401E6
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:31:49 +0000 (UTC)
X-FDA: 84755680338.16.3BF295F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 877318000E
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:31:47 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ulkcc9fn;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778517107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xpgn9f7QN4mLjrcRtfqWYx+0xYQI0v0mKJcuP7jetwk=;
	b=jY+hE8YizckShNjhDkCy3Ta6Vq0Yu3zqaxIJ+FkroavRDz+SQiSzHSz0asEzBKup9fphs+
	bnfKsc0jGpGlIMASj7jZCswNOJ3zb1+3TMd0lKYD0RmXNR9xZlKOIiQEbzBVXZCMzr0LCf
	6ESiK+64+rF1RJWGBABG+cz/mRp+wRA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ulkcc9fn;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778517107; a=rsa-sha256;
	cv=none;
	b=q2GgGTPrPPWyz0ZNnrxEs9lYrOVMLW+Rw4Zg4QpPp6MdrYhIubq7dx9AcLSUOT9ioDNUVe
	ld0Muo1YrDg1SoCqf3C0t4hdzYAA9Ft/ywa6/yWSkNJdcKOSYSPvBe/diJS4ZQgCmiDSCg
	cG1uShf58tWUT/gi88EYDzy780Vx4Og=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id ABF3E42E36;
	Mon, 11 May 2026 16:31:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F661C2BCF6;
	Mon, 11 May 2026 16:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778517106;
	bh=Wo6Ea22iz5yeR/kFj0v7wtD3a8d85eAyxnhXtWYsB5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ulkcc9fnZfQ+KyZxvStBSZ11UJcHuCzWet0F9LaNUAdAYDZQEvPARAjf7Xs9m/mR/
	 trVTSjNveGqQWNvQuO3hHIp1Lbagdh9w36PP/9B9G+NLixRSRQ9VSFXykpwURlaKKH
	 m1MlWk7Vrz4vvNAOZeLyeMtAkHXJUzjLG9E/W2dg6KtTLmIg0xMUhHQGY5LheK9MU5
	 9Sg8ZE2ty8DKPm/YbiVy/UpqgMNucsh/9MAIkrfbUn1QsuLcEtQBRYakOzg5/7mH/m
	 eSU7ofxKHhF+gLg74C0ipZ0PDXvaclzsjlUGTbF88TwS/3WGuD47mvhiAtB/2djgb7
	 9fbJBFMSEQavg==
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
Subject: [PATCH v4 27/55] selftests/mm: hugepage_settings: rename and rework get_free_hugepages()
Date: Mon, 11 May 2026 19:28:11 +0300
Message-ID: <20260511162840.375890-28-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511162840.375890-1-rppt@kernel.org>
References: <20260511162840.375890-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 877318000E
X-Stat-Signature: dtipd4p68uwjr1n9dfio71qz3nn9z9ed
X-HE-Tag: 1778517107-936606
X-HE-Meta: U2FsdGVkX19ZzHs98IP8GoDADnmJNpydprgANOfeEMPJfW3BxZNWFtNjla8obr7jVHDtxdfzBNwf3++SQlCE1dMR6VoUK+Xh1QKvs0vdXwwccHZpiopOF2dILsGgDlqYOsHnqr/R7pYRhnAIM50/OETNOg2uKQka2hFIiQhxCUxoWMiteISRSv74911h2/C0glewavBr823LadpJnUbTnN/a4kkv8w8XS3Fyx7kiv81rUNRrQMtdBdLvxcwwsnV6Fr//spTk0wI0d/UtQ5iXZqdUsHHWdPoQbDVy9rbZxHe1x0lJyhxXgHxCm9UJkPBPRApwik6uUrdJHOPn0YO0A9j8eEIaBroVrB9mnCLf1+oq8jC1JRpcR9aBYsH5oRzuOu5ANUN9nEAnJN+XZ3HgPmZPbyKkoFuf4yBALPTic+K+pCIulDargvtickzwWDxnIeZ5Zn/p84Fhj3kbGuM2yE3Q9dZSutjHDzXPmCIJm/Mai241uul2tpr79/yduaQ7ieeT+VIbuCQkTstNvcb7D9SMOgCWU8j1JkBmdJVKC+5V8kT7C9AEUEApboYH+3v8APDMQPITGhgKKDvTNJZv5lEQ2YK1M0IdRytLc6QjcoQ1EZi/sPWS2T3/r8YecpvVz/rKY/ZB144SnYcPbo5g/0MmemoJ/Z5IgeBX8/70OxIkOtvqx9sk2P/bO18lM89ktRNeqZrt9Vun/wURLP1DGYq1hNiaBN4wJX9zUDA97BKvjsdg83rjL+aPmWj7iZo9lrBY6aLZv1lkjBVvVZ58apRgxHEc7aJwOF5NnsL1sZv/wwxwpew6jge97SZgHhOeFJ1F3z2hJVVwWLEGVFiJ6do4/WKS/W4COTHzfw3yHKOG6yg6Geie0V20FPoBUWZ52st5AsIC1+AwfzabmzTTnAKySsZTrAODvOEo9XiPks7rwGGHbDgiNQKA70C41AboDQS6Be9SexDHezk9zQE
 /Y4vPRls
 b1t48wIDYbyPE2P6n9m7vso0V5V92zWI4GKINHBgMopP0iRoc9x4Dzu3riEonZI4h49E9WLeviYBVuuzD3irhSWn3fZbT3qndlNJ5/nV7q/vUYANG/zlLkBDWVSQXJecQIbC37i/n1rXgIGPxnsM+FFwML15/+uaRHDUSCuyhkIPqherkmdjA+uJmNJTDzRC2iYIjXfIo/B2Sptq0uCfLe/RJrS/RVxVMrjSnx5cHI6BTciVwfYKLgCwWNyVCNuKfq+0o4MhKCysAqoIEYN+e3WXP420XEfzagH+CNxAzdUas/Y+SHX20r1WAOxKRNWYMQPaz3+z7T8hGGwsbDaOnYi462FYHafJV8E0Dd7f4EMOoGso=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

... to hugetlb_free_default_pages() for consistency with
hugetlb_nr_default_pages().

Make hugetlb_free_default_pages() use hugetlb_sysfs_path() helper instead
of parsing /proc/meminfo.

Tested-by: Luiz Capitulino <luizcap@redhat.com>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
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
index 99402cfccb6d..3c944d28d14a 100644
--- a/tools/testing/selftests/mm/hugepage_settings.c
+++ b/tools/testing/selftests/mm/hugepage_settings.c
@@ -445,25 +445,6 @@ unsigned long default_huge_page_size(void)
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
@@ -488,3 +469,12 @@ void hugetlb_set_nr_pages(unsigned long size, unsigned long nr)
 
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
index e66302926377..436f4ce02984 100644
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
 #endif /* __HUGEPAGE_SETTINGS_H__ */
diff --git a/tools/testing/selftests/mm/hugetlb-madvise.c b/tools/testing/selftests/mm/hugetlb-madvise.c
index 5dfa2e0097ef..8adcd91d078d 100644
--- a/tools/testing/selftests/mm/hugetlb-madvise.c
+++ b/tools/testing/selftests/mm/hugetlb-madvise.c
@@ -27,7 +27,7 @@
 
 #define validate_free_pages(exp_free)					\
 	do {								\
-		unsigned long fhp = get_free_hugepages();		\
+		unsigned long fhp = hugetlb_free_default_pages();		\
 		if (fhp != (exp_free))					\
 			ksft_exit_fail_msg("Unexpected number of free "	\
 				"huge pages %lu, expected %lu line %d\n", \
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
index 0ce493dac354..7c719d789249 100644
--- a/tools/testing/selftests/mm/uffd-stress.c
+++ b/tools/testing/selftests/mm/uffd-stress.c
@@ -481,7 +481,7 @@ int main(int argc, char **argv)
 	 * for racy extra reservation of hugepages.
 	 */
 	if (gopts->test_type == TEST_HUGETLB &&
-	   get_free_hugepages() < 2 * (bytes / gopts->page_size) + gopts->nr_parallel - 1)
+	   hugetlb_free_default_pages() < 2 * (bytes / gopts->page_size) + gopts->nr_parallel - 1)
 		ksft_exit_skip("Skipping userfaultfd... not enough hugepages\n");
 
 	gopts->nr_pages_per_cpu = bytes / gopts->page_size / gopts->nr_parallel;
-- 
2.53.0


