Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EBD7CD5BD0
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 14:25:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 931736B00F5; Wed, 27 May 2026 10:25:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E1C16B00F7; Wed, 27 May 2026 10:25:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D0406B00F8; Wed, 27 May 2026 10:25:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6485C6B00F5
	for <linux-mm@kvack.org>; Wed, 27 May 2026 10:25:04 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 090C88F5F1
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:25:04 +0000 (UTC)
X-FDA: 84813421728.06.8760565
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id 53A8E20010
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:25:02 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=gUwXZ3mm;
	spf=pass (imf13.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779891902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QTFBRyPq/a5+lrbR43g4qDb2wskL/EwZYP86vzQZ4aA=;
	b=0EIqFJYLopfV+8YR3nLbErrxGn0MnEq7te0yOxud4KzCDU5UzedexOlut03rYAjxXlxC1X
	HrevfrsgoxH95BPhMISZtZef5hvfLxaJZQJjJOhfkFqxyMRFu16HcrEq7mwF0jHvPgPxM7
	FY5Cqe+RVLeBPI/BWsPi1OhX/s2TbOc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=gUwXZ3mm;
	spf=pass (imf13.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779891902; a=rsa-sha256;
	cv=none;
	b=d6itTeZMRMShFFA2tlN7lGB8Or8cNFErQykC6jCKjzaaT/d5ncN4XdxxIDVWl8DMv08vFy
	Y6cmlTRNOA+4Aw8Zydfgn8KC2/fOWSnAmp0vj0LiIa12Nxpta9wbv9CLIvIJKNI4WwyE0p
	tECQ6GRPHo+YK2Br3fKDH7Co1FCnNuc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2100127B5;
	Wed, 27 May 2026 07:24:56 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.82])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id B109A3F905;
	Wed, 27 May 2026 07:24:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779891901; bh=r1N+oOV1OlUKMcFglRUZutswFqoJ0C5j+K1Zp/Mn3c4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gUwXZ3mmCqtJfFefDf/b0Hu3mBdt17yYnA3dkIQnm7xJhiL5034AJPTN0tV+WmjPM
	 3su6wjQTtCvSk+b+feKS4ElvJ/UEBip5R/MisPD/hLK0upNP/pUadFVL3ZyuWK6S0K
	 uVCQsNDHC1mEcewcrbJxAthKvl8VDNEU0p9fW3RQ=
From: Sarthak Sharma <sarthak.sharma@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Leon Romanovsky <leon@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Mark Brown <broonie@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH v4 1/5] selftests/mm: make file helpers return errors
Date: Wed, 27 May 2026 19:54:28 +0530
Message-ID: <20260527142432.230127-2-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260527142432.230127-1-sarthak.sharma@arm.com>
References: <20260527142432.230127-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 53A8E20010
X-Stat-Signature: tgza6n4fcq6ccohxuc8s8woi8fy1ma9x
X-HE-Tag: 1779891902-546541
X-HE-Meta: U2FsdGVkX1+cySnRY8tV/Bs8T6vYA3ZuBtmi3fzdQUijwfsXpBy3OUqZRv1dZVtM4wI88PvueSKJPdNX3ByeVCFFmqlb1hiveGhcMpQRB4/y6oiYR51cm/eaF+lNiItqovItVpl6xomnogVB/05tfVn28oEKO79gdUjIYiY8C3IuZWEpNcsb6XeWULnDdsU2XXAyfafgileIZuzfDfOxvNC0KYOT1roGXreB3/IjPNdUSWbrdSOVT1r5Hm4IJcSffjcN3Reguz1JcEH/nRKhyOvPba8fmCa2VTig0fdcf9ZdP+TfYMvWZB24Ai0VubgbsO+FkVAsaIOwHsVaRT3WfePOtrbGP3f28kyadYV3Y86YFNfik1l2kMy7MiOutPxvVYU+IQibZ3LffYTo/XlAToDipGZpvHHPVV/bhN9jDtbqGgpS2kzV4/inarBsymKHY0Cm3gIgNzBQF+eI1Z9Z3128GXMK6c1Q6PCf/DebP1L/Okue406jeOktjrkOv8qY5sKkLI7Wdo2d8J5+s7q1pU+rPTzjdeMUetTeP4o8SIRzkxE8OmAGeljcAq81LfkoFeywFTaJ8Ohb/+D/n+QbUZLf7g7OMBSZ5Bb28dSgmLZu2M0JT2qR1dNVtAbyzGW8SjNZtpEgcom42GkGcyQ00HrwdojjrP2a/BvfEkjQXTruz9k5sWkk1vbKCkbl9u7g9AYKhio49QD4zOJrxW5TxjOYanEee9c7+iJGpejkQzPvOaOSWK52ahlD6vCgmBIzmAwX3JI9xTUQKNodQDNxJHxLR8xmCkqABEt1xAms6zrcTGu+H9r6zM25lag8vp/cttV6TCEJRclCDknjSNPJfQ/wx8DOCWdJSea+5Drv2eaV9kgyxuB/Q3UnA6s+I1UJDPwMAOeRQXbi9zl5N3srOcm4Ojq9iW4Jr/PrEj5FEN7szV51iQyuvmzH0VJAug0txEBPj3DfHz0yDqFtGzw
 J17IPC4l
 qSKr5rclLmfBlKvZ++mVlgGtJh5i37du6gcrVppxkZeMwOLYxQYej+cxOPHHD3B0p1Yt6A8bfrHnltrO1wmFdthJW7ofcQ++4fqC03xfsOymTN56IaGmJjX+gj77fim6FealekYQVuFp8rL02sHGWI6kM1U5mnjZQXENl1qzF4MGc1kieRulzRKoitcUPrcgyLNqW401+/R4QVRaA5zZqxmMGvY+k0EY0bm34CEshPa57upSA0Hv2Q25CKA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Change read_file(), write_file(), read_num() and write_num() in vm_util.c
to report failures to callers instead of exiting from the helper.

Update the existing mm selftest callers to report failures through
kselftest helpers. This prepares the helpers to be moved to tools/lib/mm
without carrying selftest-specific process-exit behaviour into the shared
implementation.

Also make read_file() return a negative errno on failure instead of 0, so
callers can distinguish a successful read from an I/O error.

Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 .../testing/selftests/mm/hugepage_settings.c  | 85 ++++++++++++++++---
 tools/testing/selftests/mm/khugepaged.c       | 13 ++-
 .../selftests/mm/split_huge_page_test.c       |  5 +-
 tools/testing/selftests/mm/vm_util.c          | 63 +++++++++-----
 tools/testing/selftests/mm/vm_util.h          |  6 +-
 5 files changed, 131 insertions(+), 41 deletions(-)

diff --git a/tools/testing/selftests/mm/hugepage_settings.c b/tools/testing/selftests/mm/hugepage_settings.c
index 2eab2110ac6a..c2f97fe97e58 100644
--- a/tools/testing/selftests/mm/hugepage_settings.c
+++ b/tools/testing/selftests/mm/hugepage_settings.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <dirent.h>
+#include <errno.h>
 #include <fcntl.h>
 #include <limits.h>
 #include <signal.h>
@@ -61,7 +62,9 @@ int thp_read_string(const char *name, const char * const strings[])
 		exit(EXIT_FAILURE);
 	}
 
-	if (!read_file(path, buf, sizeof(buf))) {
+	ret = read_file(path, buf, sizeof(buf));
+	if (ret < 0) {
+		errno = -ret;
 		perror(path);
 		exit(EXIT_FAILURE);
 	}
@@ -103,12 +106,18 @@ void thp_write_string(const char *name, const char *val)
 		printf("%s: Pathname is too long\n", __func__);
 		exit(EXIT_FAILURE);
 	}
-	write_file(path, val, strlen(val) + 1);
+	ret = write_file(path, val, strlen(val) + 1);
+	if (ret < 0) {
+		errno = -ret;
+		perror(path);
+		exit(EXIT_FAILURE);
+	}
 }
 
 unsigned long thp_read_num(const char *name)
 {
 	char path[PATH_MAX];
+	unsigned long num;
 	int ret;
 
 	ret = snprintf(path, PATH_MAX, THP_SYSFS "%s", name);
@@ -116,7 +125,14 @@ unsigned long thp_read_num(const char *name)
 		printf("%s: Pathname is too long\n", __func__);
 		exit(EXIT_FAILURE);
 	}
-	return read_num(path);
+	ret = read_num(path, &num);
+	if (ret < 0) {
+		errno = -ret;
+		perror(path);
+		exit(EXIT_FAILURE);
+	}
+
+	return num;
 }
 
 void thp_write_num(const char *name, unsigned long num)
@@ -129,7 +145,12 @@ void thp_write_num(const char *name, unsigned long num)
 		printf("%s: Pathname is too long\n", __func__);
 		exit(EXIT_FAILURE);
 	}
-	write_num(path, num);
+	ret = write_num(path, num);
+	if (ret < 0) {
+		errno = -ret;
+		perror(path);
+		exit(EXIT_FAILURE);
+	}
 }
 
 void thp_read_settings(struct thp_settings *settings)
@@ -157,8 +178,16 @@ void thp_read_settings(struct thp_settings *settings)
 		.max_ptes_shared = thp_read_num("khugepaged/max_ptes_shared"),
 		.pages_to_scan = thp_read_num("khugepaged/pages_to_scan"),
 	};
-	if (dev_queue_read_ahead_path[0])
-		settings->read_ahead_kb = read_num(dev_queue_read_ahead_path);
+	if (dev_queue_read_ahead_path[0]) {
+		int ret = read_num(dev_queue_read_ahead_path,
+				   &settings->read_ahead_kb);
+
+		if (ret < 0) {
+			errno = -ret;
+			perror(dev_queue_read_ahead_path);
+			exit(EXIT_FAILURE);
+		}
+	}
 
 	for (i = 0; i < NR_ORDERS; i++) {
 		if (!((1 << i) & orders)) {
@@ -208,8 +237,16 @@ void thp_write_settings(struct thp_settings *settings)
 	thp_write_num("khugepaged/max_ptes_shared", khugepaged->max_ptes_shared);
 	thp_write_num("khugepaged/pages_to_scan", khugepaged->pages_to_scan);
 
-	if (dev_queue_read_ahead_path[0])
-		write_num(dev_queue_read_ahead_path, settings->read_ahead_kb);
+	if (dev_queue_read_ahead_path[0]) {
+		int ret = write_num(dev_queue_read_ahead_path,
+				    settings->read_ahead_kb);
+
+		if (ret < 0) {
+			errno = -ret;
+			perror(dev_queue_read_ahead_path);
+			exit(EXIT_FAILURE);
+		}
+	}
 
 	for (i = 0; i < NR_ORDERS; i++) {
 		if (!((1 << i) & orders))
@@ -307,7 +344,7 @@ static unsigned long __thp_supported_orders(bool is_shmem)
 		}
 
 		ret = read_file(path, buf, sizeof(buf));
-		if (ret)
+		if (ret > 0)
 			orders |= 1UL << i;
 	}
 
@@ -425,28 +462,52 @@ static void hugetlb_sysfs_path(char *buf, size_t buflen,
 unsigned long hugetlb_nr_pages(unsigned long size)
 {
 	char path[PATH_MAX];
+	unsigned long nr;
+	int ret;
 
 	hugetlb_sysfs_path(path, sizeof(path), size, "nr_hugepages");
 
-	return read_num(path);
+	ret = read_num(path, &nr);
+	if (ret < 0) {
+		errno = -ret;
+		perror(path);
+		exit(EXIT_FAILURE);
+	}
+
+	return nr;
 }
 
 void hugetlb_set_nr_pages(unsigned long size, unsigned long nr)
 {
 	char path[PATH_MAX];
+	int ret;
 
 	hugetlb_sysfs_path(path, sizeof(path), size, "nr_hugepages");
 
-	write_num(path, nr);
+	ret = write_num(path, nr);
+	if (ret < 0) {
+		errno = -ret;
+		perror(path);
+		exit(EXIT_FAILURE);
+	}
 }
 
 unsigned long hugetlb_free_pages(unsigned long size)
 {
 	char path[PATH_MAX];
+	unsigned long nr;
+	int ret;
 
 	hugetlb_sysfs_path(path, sizeof(path), size, "free_hugepages");
 
-	return read_num(path);
+	ret = read_num(path, &nr);
+	if (ret < 0) {
+		errno = -ret;
+		perror(path);
+		exit(EXIT_FAILURE);
+	}
+
+	return nr;
 }
 
 static bool __hugetlb_setup(unsigned long size, unsigned long nr)
diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 10e8dedcb087..bc923148e983 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -119,6 +119,7 @@ static void get_finfo(const char *dir)
 	char buf[1 << 10];
 	char path[PATH_MAX];
 	char *str, *end;
+	int ret;
 
 	finfo.dir = dir;
 	stat(finfo.dir, &path_stat);
@@ -138,8 +139,9 @@ static void get_finfo(const char *dir)
 		     major(path_stat.st_dev), minor(path_stat.st_dev))
 	    >= sizeof(path))
 		ksft_exit_fail_msg("%s: Pathname is too long\n", __func__);
-	if (read_file(path, buf, sizeof(buf)) < 0)
-		ksft_exit_fail_perror("read_file(read_num)");
+	ret = read_file(path, buf, sizeof(buf));
+	if (ret < 0)
+		ksft_exit_fail_msg("read_file(%s): %s\n", path, strerror(-ret));
 	if (strstr(buf, "DEVTYPE=disk")) {
 		/* Found it */
 		if (snprintf(finfo.dev_queue_read_ahead_path,
@@ -319,7 +321,7 @@ static void *file_setup_area_common(int nr_hpages, enum file_setup_ops setup)
 {
 	const int open_opt = setup == FILE_SETUP_READ_ONLY_FS ? O_RDONLY : O_RDWR;
 	const int mmap_prot = setup == FILE_SETUP_READ_ONLY_FS ? PROT_READ : (PROT_READ | PROT_WRITE);
-	int fd;
+	int fd, ret;
 	void *p;
 	unsigned long size;
 
@@ -363,7 +365,10 @@ static void *file_setup_area_common(int nr_hpages, enum file_setup_ops setup)
 		ksft_exit_fail_perror("mmap()");
 
 	/* Drop page cache */
-	write_file("/proc/sys/vm/drop_caches", "3", 2);
+	ret = write_file("/proc/sys/vm/drop_caches", "3", 2);
+	if (ret)
+		ksft_exit_fail_msg("write_file(drop_caches): %s\n",
+				   strerror(-ret));
 	success("OK");
 	return p;
 }
diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index 32b991472f74..98236db7c813 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -269,7 +269,10 @@ static void write_debugfs(const char *fmt, ...)
 	if (ret >= INPUT_MAX)
 		ksft_exit_fail_msg("%s: Debugfs input is too long\n", __func__);
 
-	write_file(SPLIT_DEBUGFS, input, ret + 1);
+	ret = write_file(SPLIT_DEBUGFS, input, ret + 1);
+	if (ret)
+		ksft_exit_fail_msg("write_file(%s): %s\n", SPLIT_DEBUGFS,
+				   strerror(-ret));
 }
 
 static char *allocate_zero_filled_hugepage(size_t len)
diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index 311fc5b4513e..290e5c29123e 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -703,62 +703,72 @@ int read_file(const char *path, char *buf, size_t buflen)
 	int fd;
 	ssize_t numread;
 
+	if (buflen < 2)
+		return -EINVAL;
+
 	fd = open(path, O_RDONLY);
 	if (fd == -1)
-		return 0;
+		return -errno;
 
 	numread = read(fd, buf, buflen - 1);
 	if (numread < 1) {
+		int err = numread ? -errno : -ENODATA;
+
 		close(fd);
-		return 0;
+		return err;
 	}
 
 	buf[numread] = '\0';
 	close(fd);
 
-	return (unsigned int) numread;
+	return (int)numread;
 }
 
-void write_file(const char *path, const char *buf, size_t buflen)
+int write_file(const char *path, const char *buf, size_t buflen)
 {
 	int fd, saved_errno;
 	ssize_t numwritten;
 
 	if (buflen < 2)
-		ksft_exit_fail_msg("Incorrect buffer len: %zu\n", buflen);
+		return -EINVAL;
 
 	fd = open(path, O_WRONLY);
 	if (fd == -1)
-		ksft_exit_fail_msg("%s open failed: %s\n", path, strerror(errno));
+		return -errno;
 
 	numwritten = write(fd, buf, buflen - 1);
 	saved_errno = errno;
 	close(fd);
-	errno = saved_errno;
 	if (numwritten < 0)
-		ksft_exit_fail_msg("%s write(%.*s) failed: %s\n", path, (int)(buflen - 1),
-				buf, strerror(errno));
+		return -saved_errno;
 	if (numwritten != buflen - 1)
-		ksft_exit_fail_msg("%s write(%.*s) is truncated, expected %zu bytes, got %zd bytes\n",
-				path, (int)(buflen - 1), buf, buflen - 1, numwritten);
+		return -EIO;
+
+	return 0;
 }
 
-unsigned long read_num(const char *path)
+int read_num(const char *path, unsigned long *num)
 {
 	char buf[21];
+	int ret;
 
-	if (read_file(path, buf, sizeof(buf)) < 0)
-		ksft_exit_fail_perror("read_file()");
+	if (!num)
+		return -EINVAL;
 
-	return strtoul(buf, NULL, 10);
+	ret = read_file(path, buf, sizeof(buf));
+	if (ret < 0)
+		return ret;
+
+	*num = strtoul(buf, NULL, 10);
+	return 0;
 }
 
-void write_num(const char *path, unsigned long num)
+int write_num(const char *path, unsigned long num)
 {
 	char buf[21];
 
 	sprintf(buf, "%lu", num);
-	write_file(path, buf, strlen(buf) + 1);
+	return write_file(path, buf, strlen(buf) + 1);
 }
 
 static unsigned long shmall, shmmax;
@@ -775,16 +785,27 @@ void shm_limits_prepare(unsigned long length)
 {
 	unsigned long nr = length / psize();
 	unsigned long val;
+	int ret;
 
-	val = read_num("/proc/sys/kernel/shmmax");
+	ret = read_num("/proc/sys/kernel/shmmax", &val);
+	if (ret)
+		ksft_exit_fail_msg("read_num(shmmax): %s\n", strerror(-ret));
 	if (val < length) {
-		write_num("/proc/sys/kernel/shmmax", length);
+		ret = write_num("/proc/sys/kernel/shmmax", length);
+		if (ret)
+			ksft_exit_fail_msg("write_num(shmmax): %s\n",
+					   strerror(-ret));
 		shmmax = val;
 	}
 
-	val = read_num("/proc/sys/kernel/shmall");
+	ret = read_num("/proc/sys/kernel/shmall", &val);
+	if (ret)
+		ksft_exit_fail_msg("read_num(shmall): %s\n", strerror(-ret));
 	if (val < nr) {
-		write_num("/proc/sys/kernel/shmall", nr);
+		ret = write_num("/proc/sys/kernel/shmall", nr);
+		if (ret)
+			ksft_exit_fail_msg("write_num(shmall): %s\n",
+					   strerror(-ret));
 		shmall = val;
 	}
 }
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index ea8fc8fdf0eb..28c3d7c1faed 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -164,10 +164,10 @@ int unpoison_memory(unsigned long pfn);
 #define PAGEMAP_PRESENT(ent)	(((ent) & (1ull << 63)) != 0)
 #define PAGEMAP_PFN(ent)	((ent) & ((1ull << 55) - 1))
 
-void write_file(const char *path, const char *buf, size_t buflen);
 int read_file(const char *path, char *buf, size_t buflen);
-unsigned long read_num(const char *path);
-void write_num(const char *path, unsigned long num);
+int write_file(const char *path, const char *buf, size_t buflen);
+int read_num(const char *path, unsigned long *num);
+int write_num(const char *path, unsigned long num);
 
 void shm_limits_prepare(unsigned long length);
 void __shm_limits_restore(void);
-- 
2.39.5


