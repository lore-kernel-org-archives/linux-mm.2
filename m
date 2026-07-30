Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE8F0C55162
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 14:08:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1C026B0093; Thu, 30 Jul 2026 10:08:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF3856B00A4; Thu, 30 Jul 2026 10:08:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A08E36B00A5; Thu, 30 Jul 2026 10:08:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6F7BE6B0093
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 10:08:50 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 01A6C120172
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 14:08:49 +0000 (UTC)
X-FDA: 85045624020.20.38AF7D9
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2342A4000F
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 14:08:48 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=cFVjPsg7;
	spf=pass (imf11.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785420528;
	b=FRt+a95Qqb3q7PaL5Vl1A9BhCj9tsfEzhyDIko1RFsh4nf4wXRoJDOUi2tlS/gOPFiQpsb
	qq9DaFjzZ3krxjg5o97hS2bJK7P8nWPL/Oa4z63fGOExk7GWOT3WdnyQHhi3Ouj8A0oUN6
	flmqxG14xwV7tVUi4U3QgCCuNfd4T/w=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=cFVjPsg7;
	spf=pass (imf11.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785420528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kXMVbEF/+ua1EovFq5suUZj3BXbCuCqtVCi5CgrcpNY=;
	b=BvPBvki64XRg2ZRaKG7Ni17RlCCtmZ+8I6sRhBMSznZ0KrGVnr6iQlDkv4VVFRNXltGbXy
	e1owdrpc+7HrrYB0xP73eVMtQYV9soNFZJ2AYg8+OHa+tPgIwChehF/1+fS5kBFvtmaeMV
	pY+CPTN0jRbimGQxqLPcm+kQo8CBseU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 106CF1688;
	Thu, 30 Jul 2026 07:08:43 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id B7AF33F86F;
	Thu, 30 Jul 2026 07:08:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785420527; bh=ya0T2A39Krg3ay6PLVBI8vlmxmscRIWVMsbMerVPqN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cFVjPsg7/n88kKO892r8kj1Tlj7lsj2FvrPvhBPAWV9O1TeFPlgCT636USTAkhXti
	 sT+f4nKnpcHfRFGXudtK3UPmR/A7Q8EnlzipcImHLVo+CVqozUTSVezFHFU1HwEjiL
	 py1exg8ccRrxLilaOBU4QDOQmx6iMmdXjz/PxKPo=
From: Sarthak Sharma <sarthak.sharma@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
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
	Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH v6 1/6] selftests/mm: make file helpers return errors
Date: Thu, 30 Jul 2026 19:38:20 +0530
Message-ID: <20260730140825.238130-2-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260730140825.238130-1-sarthak.sharma@arm.com>
References: <20260730140825.238130-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2342A4000F
X-Stat-Signature: 7y4r9t69p131anfx44fqyuyeoqd6dkp6
X-Rspam-User: 
X-HE-Tag: 1785420528-376698
X-HE-Meta: U2FsdGVkX1/5GS10tCpOP4W/z0zyfaIj3bgAOT9uD7umtbUU+8JhsOgnD2EdATaoWwkSiakSfVd6w0s0GArkPFuHzwl3cVWfUyYjJJDkrTDWiWC6UiNzQEuOpBeJvRCVlY5GTxobyoCQuvMSg2+/T/kqL1q3sOZj8cW2mD7tJ1sFAAqyA7l7XSTgskr3pYB3+TL3Z5fRi8ya02kHubG1HouidHwEJnZeF9ST25FnqcfWWYN8qsUGkkYLf0MUkDR30kz52Uf6a87tpm+FQ9WvsHBukvZAOCHXjtdmu1oa/izNIwtCbg5qI7wgQuoR2jKAfpjJqmePpRAwo4zEGfbsxwJODJ5ApiMLLvOFA880nLt3YwneQ/Nx9AuNNHBGMjA/bg/rQWHKC7lduqf88M8tn/KanVu4YKGONGN4KQowchmS5xtGobGFaJursr+EbJickkqW23tGzs3CrBVffK7jRGbZUtU/PRkama0PLjCF3UG2mBdaP9PKPuftoJG8ZCrRrhdsst/XklGHBewx1ioUmfsnAl0rbDsnHMjhdYt/DmIQsRDur+Q65lP3LYhmH3A1sIagX3xKgqjbonoLl6wosLS8QBZaZSf59ryGJwoZoG834GHy4SqRxtiN2Gpv0ceXcohICI4n1dbmuyoVEY/Bjzmivr+kYnZ5RGn5TrH5C7t9fFZvfF0o15AR+R27VnsytsMEFLG8Ia4rsZbPAvxj2TRCLRqzyyjnpvrrmmJwBHCDG7vcTfP3qpYVDpnxhYQu/Wj1lTb6l7oKMF4K7n3fxM/oysOshGUQq3Yr03HKhwM1p6gYfdDClK+WYBJx7OZb8aHznRgm3HV6HyeUiHQW1BRRz+RTEYRXK/QW4RRg5Wk9NCA7+Qy8Q/RBPlSRPyXmPHRIS72MfyeIODBHibVC4q0PzoPoU4zEvpzNRyK0aYwzohUd7xXI0LV7r8WuRoDB74/L7V/HV2+6VvS/Czu
 9CZKylA4
 pJ2GMSmz0bbSJVcOo+TweTOgZvw3s3sS0SB9IwP4e6rEVYwVi27dO7ys+GtGZv7IHQ+yOYYs2Pr1XNAVD0LfM6tUwR++mS/geDM9bzLWgY7yyRHaVohoQf6hYXm5gJkfBllqbvpVeMrybVVtMLhTJWWKssVkTJnHSVWx9dRms1jwldir5VoyMx+9UYJAbmlZb7KY0Of6W7RvumQQP9mt0gdBtkrv5bhEHMkEAQjo0EowuPoOrGH636NvBnQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Change read_file(), write_file(), read_num() and write_num() in vm_util.c
to report failures to callers instead of exiting from the helper.

Make read_file() return a negative errno on failure instead of 0, so
callers can distinguish a successful read from an I/O error. Also make
read_num() reject negative and malformed values.

Update callers to print diagnostics and fail wherever required. This
patch prepares the helpers to be moved to tools/lib/mm without
kselftest dependency.

Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 .../testing/selftests/mm/hugepage_settings.c  |  97 ++++++++++++++---
 tools/testing/selftests/mm/khugepaged.c       |  14 ++-
 .../selftests/mm/split_huge_page_test.c       |   5 +-
 tools/testing/selftests/mm/vm_util.c          | 102 +++++++++++++-----
 tools/testing/selftests/mm/vm_util.h          |   6 +-
 5 files changed, 175 insertions(+), 49 deletions(-)

diff --git a/tools/testing/selftests/mm/hugepage_settings.c b/tools/testing/selftests/mm/hugepage_settings.c
index 2eab2110ac6a..db0db8a3df7c 100644
--- a/tools/testing/selftests/mm/hugepage_settings.c
+++ b/tools/testing/selftests/mm/hugepage_settings.c
@@ -8,6 +8,7 @@
 #include <stdlib.h>
 #include <string.h>
 #include <unistd.h>
+#include <errno.h>
 
 #include "vm_util.h"
 #include "hugepage_settings.h"
@@ -61,8 +62,10 @@ int thp_read_string(const char *name, const char * const strings[])
 		exit(EXIT_FAILURE);
 	}
 
-	if (!read_file(path, buf, sizeof(buf))) {
-		perror(path);
+	ret = read_file(path, buf, sizeof(buf));
+	if (ret < 0) {
+		errno = -ret;
+		ksft_perror(path);
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
+		ksft_perror(path);
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
+		ksft_perror(path);
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
+		ksft_perror(path);
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
+			ksft_perror(dev_queue_read_ahead_path);
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
+			ksft_perror(dev_queue_read_ahead_path);
+			exit(EXIT_FAILURE);
+		}
+	}
 
 	for (i = 0; i < NR_ORDERS; i++) {
 		if (!((1 << i) & orders))
@@ -307,8 +344,16 @@ static unsigned long __thp_supported_orders(bool is_shmem)
 		}
 
 		ret = read_file(path, buf, sizeof(buf));
-		if (ret)
-			orders |= 1UL << i;
+		if (ret < 0) {
+			if (ret != -ENOENT) {
+				errno = -ret;
+				ksft_perror(path);
+				exit(EXIT_FAILURE);
+			}
+			continue;
+		}
+
+		orders |= 1UL << i;
 	}
 
 	return orders;
@@ -425,28 +470,52 @@ static void hugetlb_sysfs_path(char *buf, size_t buflen,
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
+		ksft_perror(path);
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
+		ksft_perror(path);
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
+		ksft_perror(path);
+		exit(EXIT_FAILURE);
+	}
+
+	return nr;
 }
 
 static bool __hugetlb_setup(unsigned long size, unsigned long nr)
diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 10e8dedcb087..6a656bc6b266 100644
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
 
@@ -363,7 +365,11 @@ static void *file_setup_area_common(int nr_hpages, enum file_setup_ops setup)
 		ksft_exit_fail_perror("mmap()");
 
 	/* Drop page cache */
-	write_file("/proc/sys/vm/drop_caches", "3", 2);
+	ret = write_file("/proc/sys/vm/drop_caches", "3", 2);
+	if (ret < 0)
+		ksft_exit_fail_msg("write_file(drop_caches): %s\n",
+				   strerror(-ret));
+
 	success("OK");
 	return p;
 }
diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index 32b991472f74..ef5ab96adc7e 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -269,7 +269,10 @@ static void write_debugfs(const char *fmt, ...)
 	if (ret >= INPUT_MAX)
 		ksft_exit_fail_msg("%s: Debugfs input is too long\n", __func__);
 
-	write_file(SPLIT_DEBUGFS, input, ret + 1);
+	ret = write_file(SPLIT_DEBUGFS, input, ret + 1);
+	if (ret < 0)
+		ksft_exit_fail_msg("write_file(%s): %s\n", SPLIT_DEBUGFS,
+				   strerror(-ret));
 }
 
 static char *allocate_zero_filled_hugepage(size_t len)
diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index 311fc5b4513e..e3ec077cda67 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -700,91 +700,139 @@ int unpoison_memory(unsigned long pfn)
 
 int read_file(const char *path, char *buf, size_t buflen)
 {
-	int fd;
+	int fd, err;
 	ssize_t numread;
 
 	fd = open(path, O_RDONLY);
 	if (fd == -1)
-		return 0;
+		return -errno;
 
 	numread = read(fd, buf, buflen - 1);
 	if (numread < 1) {
+		err = numread ? errno : ENODATA;
 		close(fd);
-		return 0;
+		return -err;
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
+
 	if (numwritten < 0)
-		ksft_exit_fail_msg("%s write(%.*s) failed: %s\n", path, (int)(buflen - 1),
-				buf, strerror(errno));
-	if (numwritten != buflen - 1)
-		ksft_exit_fail_msg("%s write(%.*s) is truncated, expected %zu bytes, got %zd bytes\n",
-				path, (int)(buflen - 1), buf, buflen - 1, numwritten);
+		return -saved_errno;
+
+	if (numwritten != (ssize_t)(buflen - 1))
+		return -EIO;
+
+	return 0;
 }
 
-unsigned long read_num(const char *path)
+int read_num(const char *path, unsigned long *num)
 {
+	unsigned long val;
+	int ret;
 	char buf[21];
+	char *end;
 
-	if (read_file(path, buf, sizeof(buf)) < 0)
-		ksft_exit_fail_perror("read_file()");
+	if (!num)
+		return -EINVAL;
 
-	return strtoul(buf, NULL, 10);
+	ret = read_file(path, buf, sizeof(buf));
+	if (ret < 0)
+		return ret;
+
+	errno = 0;
+	val = strtoul(buf, &end, 10);
+	if (errno)
+		return -errno;
+
+	if (end == buf || buf[0] == '-')
+		return -EINVAL;
+
+	if (*end == '\n')
+		end++;
+
+	if (*end != '\0')
+		return -EINVAL;
+
+	*num = val;
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
 
 void __shm_limits_restore(void)
 {
-	if (shmmax)
-		write_num("/proc/sys/kernel/shmmax", shmmax);
-	if (shmall)
-		write_num("/proc/sys/kernel/shmall", shmall);
+	int ret;
+
+	if (shmmax) {
+		ret = write_num("/proc/sys/kernel/shmmax", shmmax);
+		if (ret < 0)
+			ksft_exit_fail_msg("Failed to restore shmmax: %s\n",
+					   strerror(-ret));
+	}
+	if (shmall) {
+		ret = write_num("/proc/sys/kernel/shmall", shmall);
+		if (ret < 0)
+			ksft_exit_fail_msg("Failed to restore shmall: %s\n",
+					   strerror(-ret));
+	}
 }
 
 void shm_limits_prepare(unsigned long length)
 {
 	unsigned long nr = length / psize();
 	unsigned long val;
+	int ret;
+
+	ret = read_num("/proc/sys/kernel/shmmax", &val);
+	if (ret < 0)
+		ksft_exit_fail_msg("Failed to read /proc/sys/kernel/shmmax: %s\n",
+				   strerror(-ret));
 
-	val = read_num("/proc/sys/kernel/shmmax");
 	if (val < length) {
-		write_num("/proc/sys/kernel/shmmax", length);
+		ret = write_num("/proc/sys/kernel/shmmax", length);
+		if (ret < 0)
+			ksft_exit_fail_msg("Failed to write %lu to /proc/sys/kernel/shmmax: %s\n",
+					   length, strerror(-ret));
 		shmmax = val;
 	}
 
-	val = read_num("/proc/sys/kernel/shmall");
+	ret = read_num("/proc/sys/kernel/shmall", &val);
+	if (ret < 0)
+		ksft_exit_fail_msg("Failed to read /proc/sys/kernel/shmall: %s\n",
+				   strerror(-ret));
 	if (val < nr) {
-		write_num("/proc/sys/kernel/shmall", nr);
+		ret = write_num("/proc/sys/kernel/shmall", nr);
+		if (ret < 0)
+			ksft_exit_fail_msg("Failed to write %lu to /proc/sys/kernel/shmall: %s\n",
+					   nr, strerror(-ret));
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


