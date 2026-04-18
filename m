Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3D28F99C79
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 10:58:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12BD36B026E; Sat, 18 Apr 2026 06:58:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B5D76B0270; Sat, 18 Apr 2026 06:58:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0DAD6B0271; Sat, 18 Apr 2026 06:58:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DD3996B026E
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 06:58:49 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A17A1160431
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:58:49 +0000 (UTC)
X-FDA: 84671378778.14.A0F080D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id E7C4940004
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:58:47 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bN1i663m;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776509928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aZEoU0IwQOpsi82G7gijaBWYu7kGWrJYGFpJPct+BF4=;
	b=t6qWLKcZIHcVqiFGVVo7VN1GCaqV1vkaVjHI7DZEgAzoYKd2AYXKfukroqPr4Yyu/lrxSY
	AXua8dbuxzLAfihE4J5+VY8pDCNLQiRDWjtt0Q8/UscEqng6QY385Znk6IV5ETqvWb4yAi
	AWpxS5h1Lr7hzGjWLTJyEFUcXyxQG28=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776509928; a=rsa-sha256;
	cv=none;
	b=CAIQorkRlKj5HUtG7dbtp6nuQax7PFcwb6T7B4A9OUP/I02Q3DeBWJe3u8dVbA6lh2PMjK
	lbebZFkEVTSKYOHBC0Yj1GN4+ypvGrbs0o3ILWT0qhY6ixKF56+lmWqDdGIJ5BV75Jbg8x
	dk5TMX6kjSHrP0b3f5KxlVwZP/akc94=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bN1i663m;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1DD7043B26;
	Sat, 18 Apr 2026 10:58:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 568E4C2BCB6;
	Sat, 18 Apr 2026 10:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776509927;
	bh=t2OQ6d8PPidPjQSh+RBxS6XeDUdzwdvT/+uZ5YR7P1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bN1i663mTsKFcfnOTliwN6bGVzDkg6wWmRaQeFQOYLLypzPpnSK8TyQF4cQ0xx4w+
	 gedyGidMDRRC6KTi8mnCLcDNNVZol5GCY9DktGGM4tTCcBwRI358p89udf3ZAGHWG0
	 ywmVuV8+/9iIfmB/QqN/I+XDD+ZC6r78AHeXnGEJxmVJESByd1c6Yltrkh2iPjaa+P
	 Ci5YgrLikEB2JYdUWEelkk3dapWN+0iQSzUNhSr22nYH+XlXD3q90uhu2hqKMGrG6D
	 ylq6RNar5NacZkLRLN+Drij63JpSkQPmluEkw8gigwCVg7RMbwOI4HrKXR8otD4nvK
	 gPbVGOJBSXH7w==
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
Subject: [PATCH v2 29/53] selftests/mm: compaction_test: use HugeTLB helpers ...
Date: Sat, 18 Apr 2026 13:55:14 +0300
Message-ID: <20260418105539.1261536-30-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260418105539.1261536-1-rppt@kernel.org>
References: <20260418105539.1261536-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E7C4940004
X-Rspamd-Server: rspam07
X-Stat-Signature: bj174g4aknk97pamf8rszdrnnwhghee9
X-Rspam-User: 
X-HE-Tag: 1776509927-508280
X-HE-Meta: U2FsdGVkX19eIAUV7hFikv+eV6DIXlJqe1UUYVvLZg9Yw4gfr03LOHHObEXJSDQH0LfqqhwofkZLA7kjB6UmryuZ1ladj8lK758QZpg1gNYQnf5qB9hnRJMcDzt2A7KRD57az/noP8RsHZK8YHT3zpT5H5mXb82muu2SV8U0ssyybUZiFyiz36sJV2gbvPdSeuSf7fhjpXtb+r1V5JA+mzWmbfvwAp4HdALRSoL7kDCgXxHSZoi2HEXYX/wnKPIc38mSfUSp8YHu9//IRT5MjYy2YfNHFtvayYCefTfN/Ab8Jeo0ZdKYSKk5ONxBz52D4R1waA5bO7a+I2GGaWuyIb57mFNuKtVr9IwDWlfhym81KoRwa3+vuq51PVnY5bo97lOdMacCm1mTrEDoypPX5d0q2z6TUUNEVYzK8pUQnyO97dMrj4K3rWybet/YabqfzY2hHHuzXWh4bRLSxD/yqn+SUEXtZ/p3tKJdk4zsGqU3Tr1df95soMrFy9cztgaAZHOmOnaSL6bpRlsPP0fM2v52ca77b73L9O5IXvfScJUiegeUVub84uIvgWX1vM2AZJl2CWjQh7KylHxWVwAtRQyzUiInCGQHulx4WwiMAfiKsvIZ9TY+KKk300WgPneNxeZ7olzjG6VyDuyLxQaSq38aZa1oO938MnfQaU0k9z0Y7YwRBcmI0QcU5nCP49d0v8KbWZG2n0w8m3uIrkMEdZQYEze2CzCE7sHQWucG6n0Jj2E/K677kThN7Q6EWqNf+zo9D1MRBwKkJHPyE/7juyj4TzIIFoFWE/2JRH5L1hAhEEno/EUoFIStuCgW/7KSjqtSJ0THzvhbgprZnUVW91mJ8WAJ3l2jXTeXnoUmeO09x8pvEBqKOjRciz2pxb378/dM0I6I/kORG30YSSlJ/7C9Hr9tNjLlBXIyOc1JGv1iidH9TFfgEoB0cBMGY1bE4JrqgeFl4D0Bvn1K/dM
 pk8pnsf/
 O0lQof/URzpHs61zc91+jY66PM2lkfs6H0eeryV9DSJk5nUgxWxijwWbJ1Ve1x5C8+bTVLP14HjaZ7OJdVoYd5Tx+R7gwkspbds/yRXxD1e/fdQvGtQ+Dniw+xjpdF7YX6E62bjUrHI3oEObyLPj8nVE3rVshcI0eDyr1Hwkhs/OQJsTraMs4OMgWPsSr4sccIoy8jqvCBCqhNuDW+d4jlB+K8y5zour/BHxMym3m4pHXbcEJqCMq9Rqd8kfLSbln6Aztn6xwrlB+Z2urtKIkxRJaHgUmZIoF2s4k
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

... instead of open coded access of HugeTLB parameters via /proc.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/compaction_test.c | 113 +++----------------
 1 file changed, 17 insertions(+), 96 deletions(-)

diff --git a/tools/testing/selftests/mm/compaction_test.c b/tools/testing/selftests/mm/compaction_test.c
index 30209c40b697..962a50c3d66f 100644
--- a/tools/testing/selftests/mm/compaction_test.c
+++ b/tools/testing/selftests/mm/compaction_test.c
@@ -17,6 +17,7 @@
 #include <string.h>
 
 #include "kselftest.h"
+#include "hugepage_settings.h"
 
 #define MAP_SIZE_MB	100
 #define MAP_SIZE	(MAP_SIZE_MB * 1024 * 1024)
@@ -82,75 +83,33 @@ int prereq(void)
 	return -1;
 }
 
-int check_compaction(unsigned long mem_free, unsigned long hugepage_size,
-		     unsigned long initial_nr_hugepages)
+int check_compaction(unsigned long mem_free, unsigned long hugepage_size)
 {
-	unsigned long nr_hugepages_ul;
-	int fd, ret = -1;
+	unsigned long nr_hugepages;
 	int compaction_index = 0;
-	char nr_hugepages[20] = {0};
-	char init_nr_hugepages[24] = {0};
-	char target_nr_hugepages[24] = {0};
-	int slen;
-
-	snprintf(init_nr_hugepages, sizeof(init_nr_hugepages),
-		 "%lu", initial_nr_hugepages);
+	int ret = -1;
 
 	/* We want to test with 80% of available memory. Else, OOM killer comes
 	   in to play */
 	mem_free = mem_free * 0.8;
 
-	fd = open("/proc/sys/vm/nr_hugepages", O_RDWR | O_NONBLOCK);
-	if (fd < 0) {
-		ksft_print_msg("Failed to open /proc/sys/vm/nr_hugepages: %s\n",
-			       strerror(errno));
-		ret = -1;
-		goto out;
-	}
-
 	/*
 	 * Request huge pages for about half of the free memory. The Kernel
 	 * will allocate as much as it can, and we expect it will get at least 1/3
 	 */
-	nr_hugepages_ul = mem_free / hugepage_size / 2;
-	snprintf(target_nr_hugepages, sizeof(target_nr_hugepages),
-		 "%lu", nr_hugepages_ul);
-
-	slen = strlen(target_nr_hugepages);
-	if (write(fd, target_nr_hugepages, slen) != slen) {
-		ksft_print_msg("Failed to write %lu to /proc/sys/vm/nr_hugepages: %s\n",
-			       nr_hugepages_ul, strerror(errno));
-		goto close_fd;
-	}
-
-	lseek(fd, 0, SEEK_SET);
-
-	if (read(fd, nr_hugepages, sizeof(nr_hugepages)) <= 0) {
-		ksft_print_msg("Failed to re-read from /proc/sys/vm/nr_hugepages: %s\n",
-			       strerror(errno));
-		goto close_fd;
-	}
+	nr_hugepages = mem_free / hugepage_size / 2;
+	hugetlb_set_nr_default_pages(nr_hugepages);
 
 	/* We should have been able to request at least 1/3 rd of the memory in
 	   huge pages */
-	nr_hugepages_ul = strtoul(nr_hugepages, NULL, 10);
-	if (!nr_hugepages_ul) {
+	nr_hugepages = hugetlb_nr_default_pages();
+	if (!nr_hugepages) {
 		ksft_print_msg("ERROR: No memory is available as huge pages\n");
 		goto close_fd;
 	}
-	compaction_index = mem_free/(nr_hugepages_ul * hugepage_size);
-
-	lseek(fd, 0, SEEK_SET);
-
-	if (write(fd, init_nr_hugepages, strlen(init_nr_hugepages))
-	    != strlen(init_nr_hugepages)) {
-		ksft_print_msg("Failed to write value to /proc/sys/vm/nr_hugepages: %s\n",
-			       strerror(errno));
-		goto close_fd;
-	}
+	compaction_index = mem_free/(nr_hugepages * hugepage_size);
 
-	ksft_print_msg("Number of huge pages allocated = %lu\n",
-		       nr_hugepages_ul);
+	ksft_print_msg("Number of huge pages allocated = %lu\n", nr_hugepages);
 
 	if (compaction_index > 3) {
 		ksft_print_msg("ERROR: Less than 1/%d of memory is available\n"
@@ -161,48 +120,10 @@ int check_compaction(unsigned long mem_free, unsigned long hugepage_size,
 	ret = 0;
 
  close_fd:
-	close(fd);
- out:
 	ksft_test_result(ret == 0, "check_compaction\n");
 	return ret;
 }
 
-int set_zero_hugepages(unsigned long *initial_nr_hugepages)
-{
-	int fd, ret = -1;
-	char nr_hugepages[20] = {0};
-
-	fd = open("/proc/sys/vm/nr_hugepages", O_RDWR | O_NONBLOCK);
-	if (fd < 0) {
-		ksft_print_msg("Failed to open /proc/sys/vm/nr_hugepages: %s\n",
-			       strerror(errno));
-		goto out;
-	}
-	if (read(fd, nr_hugepages, sizeof(nr_hugepages)) <= 0) {
-		ksft_print_msg("Failed to read from /proc/sys/vm/nr_hugepages: %s\n",
-			       strerror(errno));
-		goto close_fd;
-	}
-
-	lseek(fd, 0, SEEK_SET);
-
-	/* Start with the initial condition of 0 huge pages */
-	if (write(fd, "0", sizeof(char)) != sizeof(char)) {
-		ksft_print_msg("Failed to write 0 to /proc/sys/vm/nr_hugepages: %s\n",
-			       strerror(errno));
-		goto close_fd;
-	}
-
-	*initial_nr_hugepages = strtoul(nr_hugepages, NULL, 10);
-	ret = 0;
-
- close_fd:
-	close(fd);
-
- out:
-	return ret;
-}
-
 int main(int argc, char **argv)
 {
 	struct rlimit lim;
@@ -212,18 +133,19 @@ int main(int argc, char **argv)
 	unsigned long mem_free = 0;
 	unsigned long hugepage_size = 0;
 	long mem_fragmentable_MB = 0;
-	unsigned long initial_nr_hugepages;
 
 	ksft_print_header();
 
 	if (prereq() || geteuid())
 		ksft_exit_skip("Prerequisites unsatisfied\n");
 
-	ksft_set_plan(1);
-
 	/* Start the test without hugepages reducing mem_free */
-	if (set_zero_hugepages(&initial_nr_hugepages))
-		ksft_exit_fail();
+	hugetlb_save_settings();
+	hugetlb_set_nr_default_pages(0);
+	if (hugetlb_nr_default_pages())
+		ksft_exit_skip("Could not reset nr_hugepages\n");
+
+	ksft_set_plan(1);
 
 	lim.rlim_cur = RLIM_INFINITY;
 	lim.rlim_max = RLIM_INFINITY;
@@ -268,8 +190,7 @@ int main(int argc, char **argv)
 		entry = entry->next;
 	}
 
-	if (check_compaction(mem_free, hugepage_size,
-			     initial_nr_hugepages) == 0)
+	if (check_compaction(mem_free, hugepage_size) == 0)
 		ksft_exit_pass();
 
 	ksft_exit_fail();
-- 
2.53.0


