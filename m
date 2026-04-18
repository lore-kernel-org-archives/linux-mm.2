Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF37BF99C7C
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 10:58:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 412616B0260; Sat, 18 Apr 2026 06:58:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C27E6B0266; Sat, 18 Apr 2026 06:58:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B0DA6B0269; Sat, 18 Apr 2026 06:58:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 15A376B0260
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 06:58:25 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DD60FC1CB6
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:58:24 +0000 (UTC)
X-FDA: 84671377728.20.D462D57
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5283420003
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:58:23 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LI7uCwAA;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776509903; a=rsa-sha256;
	cv=none;
	b=J9DF77lJfK0RsBUpxRp+EDtATQdZFye6DcfhzMqZKW4d/MBHwpDmniz2e8M2nSSIPtIP3x
	HVNSaaDOQh9vcN3R0C5cDTBW5n0UczHEj3AUvSEhnMm5ufNJAPEYk/4aKuxr+BW9fWuPFm
	8c04M7/mWdgP5hnMpYoJ5puiypKi0T0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LI7uCwAA;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776509903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HmaUvHDAKcCRseeJrg1xeCJxe/RzWwwd0KNM+8O6JtY=;
	b=3srrfy4MDcLvEiwyC0RpQ2p5oa9hLx81K2GRcvPrZFzRiXW4z5JTybugjmKrOXtXnEuufi
	Z++VhXH0uJ2EYIGgLYjs46y/CCEYYs3XpNmEvD9PLzBGZl8gHDdDN1nQ9Q8WaoG4tV7o8M
	rFacFzfv/xbtDWOs+WWKx5mWMV+uvd4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B228D60172;
	Sat, 18 Apr 2026 10:58:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0E3CC2BCB3;
	Sat, 18 Apr 2026 10:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776509902;
	bh=jAQxw9MbYkXsl544OFupWFjq2DLx0d+HujNgYQfq/0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LI7uCwAA+U6wF0SqxD8YiuvZxwQTeURo7rF12HrPMx1NwE3aOfDfxx9oyhPSoAjc3
	 R/onu2CB7oBz4xZOm7RaqYMZalGNkst82fTQPHQdnZ+dhFxdY4pDps51x5XhIe4KLb
	 QrO0Ci3UcStJDa9K9z7vEIb+zgSVt7DeF8iLbPegAHbAmzM4+hNqt/MBChHI7uSfx3
	 A5PJ+peGn8YSC73CdvYu4816nfEtf7kv+6yTwJeRTye/ng+PrzuXbx5N085Ize28uq
	 VRnn+/HIqz41LZgJsABs5DphO9Xs9Tnvj6PBrtGTYS3WcoWBFAop2HK5BocY/b5erm
	 tDzGDTh8yHRxg==
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
Subject: [PATCH v2 25/53] selftests/mm: hugepage_settings: rename get_free_hugepages()
Date: Sat, 18 Apr 2026 13:55:10 +0300
Message-ID: <20260418105539.1261536-26-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260418105539.1261536-1-rppt@kernel.org>
References: <20260418105539.1261536-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5283420003
X-Stat-Signature: xo3mkcxepigp5z9sc6qskoujbrxthc5w
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776509903-63214
X-HE-Meta: U2FsdGVkX18dSZwoWalwXa67C5XH/WGfqZIxs5ADvjFYByMJqvq1mx36XdjnhkQ4HhegVXUbhWwqSE2Z2ws/Tx/tzJ97UH7IFEX8KJ5uGSW8GjvGGFX62R7M5HbRLiQkaFsAcdUgMIk9TDbMQ+3C+sSjpEvwSJLxHHI8R582SrJmn7OX1djsXPix0gCwlVe6wxgeKqTvwpQAMb0IT++yxyX/uCz3sQ+4WmpEJu/j6i7ypfN/ZFO6LBX604Ty02/RIoIGmNQotx4RZQZ+TGHbiTs8db3DyaW5jRVY2DMYYChflSynu5omDI9QXhm3VJLPDOkuDRi3B/rhk2UWUWZnTy5Ys66z93mlA3aWLueJfEZRjTjtsNyGVBBXUVplQHr/RFUB9tysaQPR7u1KpkBM7+BRwJzKhMls0JPWMokbpYC0xw1fkB9z/XPv5cHMUyXVS7tspcP/RmDXXEBjhHaKAg9uDW5OkyXU4y1C5JlpqDjKTYPJFHQe/SEygqMWq9JX+no887hb4SOhTeQ4ybziGMznbW/wpeSQEc7Paqfx1irJ9fG/UimO7OnsiKR60pHO+41bQLjurXLQRngwG0/8msz4+56cNsV+/5phsJeqV4oFc9qQI7kDiYnNwzcQap5Hbu/y46o5SXeqLW0LIBz6B138KBf+ZXn9mge6Nex9NS1XiJH81XRbasdMYCJ272rDcEklfNKyXKcDPWMo4cNoZ0gyrok+L7RMc2XRURIXr6mtPYEKbLQCymBt7tGEBsEbvsqbFVT0F1Seiy4GYFnBCyQC2v1bgeRaazC+BUro2vp2Nqrsjq7LG5nqDFAZhHxsvZ2N14eDefbOigCIxRf8JPNJ6eKW0YaIiZaJ9uwNu3u9xQ6fC6qmxPZf3VnCJ494gcUiwm0l3NEzfsCA+nD2OytrYu9YH9x6ZNU0CVoyp741tsWGXYkZRS6wraJjC9sM/EJdA1p7Ml2xuQzDpyO
 zfxOr8bu
 VlF/J0FvvilKs4VjON2ZJWrubtwKN1NnBRWHEegzi9U6DgurcxoHo81eSmTBd8Tb2MiKKqRk650BFWXZZ/eYNywI5jlkp9SMXZphNYyeypLA+pa3RQfqRbKpQ/PlZwfuxfZtPmAF23L+pTVm+NOlN+ScEtaZOL1tgklu1USWyWgoUrbPsWfd6/bs75jlI4ga8qMfaLrHuy8So6JOPM8w21bYHTkKzFHxG6zF9XZNBcUoXuFm0G0hK5wAkGfCt8W8t+cKQZTVRuvN0C0si7+JXnQJXeFICYGIXAdiD
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


