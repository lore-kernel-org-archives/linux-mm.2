Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26612C982DC
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 11:23:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 065546B008C; Fri, 18 Sep 2026 07:23:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03D226B0092; Fri, 18 Sep 2026 07:23:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E95706B0093; Fri, 18 Sep 2026 07:23:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C0A596B008C
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 07:23:00 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D5857C05F6
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 11:22:59 +0000 (UTC)
X-FDA: 85226646078.14.DDAFE0A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id D4733120009
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 11:22:57 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=hZpK6gmp;
	spf=pass (imf29.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789730578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2f6ee2QO+Sa1ZcKFjt//OKdisKLXcftMDcDK0bfFM8E=;
	b=1v1JdMuiviQGL/Ho0Paz0/XGBGy1T8n0tfbcmiUS9thDmVAp18Qtv++DtTRPkzjeeJ6IcJ
	UTML3SdRPjcjUn7SXwsFFAJ9hfNfkIen9Th4PptUNKQHo6SXzO3On6EN3Mjolrq2c1Ezkk
	0kSFJb07v0Xl3n9Q1e5mV1iypILJpy0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=hZpK6gmp;
	spf=pass (imf29.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789730578;
	b=2P96P//PygDwQlhUH9AYQBrG86r0+IV29P/+mOHvPpSq6Fc4Mwwr2F0/TvRU5NYcnq+C6Y
	mJH4ZLRu4mRb8bx3WrWmtwqpLlqjVnytP8aeqxlg8m6ErwB2wCDD7p4gZJW+2pKFGSUYMT
	s7dGtyU4iCgyI7CuPG1teg6Qv80KRNo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7A3091596;
	Fri, 18 Sep 2026 04:22:53 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 36FBB3F882;
	Fri, 18 Sep 2026 04:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789730577; bh=hKA1SxNjuW9vAV8jnUyOq4aXH0ePH/0GOvQ4c1qg2OY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hZpK6gmpFtLHXOrEAUOKBRTt7yTsBX8lQbGWZww+RLS7ueJYNwpKBMkTzL5cAH9yd
	 UitLTEi2CUxkbyHnSArt8aErf4583P6aVSuXHIqpStdf+gX63J5VfuouV2Kx+ts4Id
	 9Cn7Uqy+i4o48cru2+IatRS1kkLTCA5arsu9NdWw=
From: Sarthak Sharma <sarthak.sharma@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Leon Romanovsky <leon@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Mark Brown <broonie@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH v11 1/6] selftests/mm: make file helpers return errors
Date: Fri, 18 Sep 2026 16:52:29 +0530
Message-ID: <20260918112234.195857-2-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260918112234.195857-1-sarthak.sharma@arm.com>
References: <20260918112234.195857-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D4733120009
X-Stat-Signature: gnpsskfhkfkshzkkyesnpqiz5tfnjxbd
X-Rspam-User: 
X-HE-Tag: 1789730577-454996
X-HE-Meta: U2FsdGVkX18WY6ilBDCYPpo+ErXidCUZEzAENLNNYU0ryfeD/UFEkQW2gepKV1WEPE/YSn3Ubf+EPtsaDGCKv1FCc/rDbWuVASqPy7W2TC8YvtFvBvXyKJ4bmxOorOqmXBcOUeNxj/ove7ZJKpJtFPchslW0Tt79EgbDPhZm96XmIX/kepDcuVtKlrHx6XuJLHKYGa+K0QH1m5Ke3bxaEnlNeT3Qfsd47o83EOyOgnSF3wsPOHh8qmO81+RRccz9sY8wqcm6kn6kPOu3E5N/cyrpLIWYD3wvBKO2qFa5Ukw1plMPX18f2o1k79jpRZSZsz6LwWWnwwyEpSFyeoJADih20QEdEYPBjaVmMVTUwolcGNsiPApikX5+xkyVSYdwSiOd1Ahnp8ktXPWi11kOKiq2J7EYAdtzZw2Q/fkXgpYI/FppdCBruhOROfLXiLpgdLaoDWeJcyW8Dy62lrCx8/9CbNR52tqC893OlpEm/AYg7i1JsUObjosYpyDypB3bM3b9Z+TxTj2cW08osdyUBqSCV+s4cBzQqWrNlY7BR77OUdrCreW0pRve/qhKWDrJrEwZYfmlEfh+z+0loFkYLaFqGEwH2ZxADP5b0TXOHe0YoYbIBHhx8d89Md83ZMgUSZEFJjrdXDHFWIVxpIMc3eIv/3kK9b1C4flqUTF8+EuyZKlZEPgeikCOx9p6fntVy0J3qVjwjyGustC9aiE9j30kaCdzT5hoQQomZ6IynKnzCXZn235k6vV4MjMstV3IWGTw6uyO9f4BxcBWKtWEdESPsT15x7MH/ofsu0XuCNoM18UWISGOS920D567dP0LgOQ0RCgN8mYVPKll5dLOTUai7OhTK9QSzbcknkjRH7wpcfgero3ply+iPm4s84JHjShcWeqABILlW7D3bASk5/t3SNHQzGUThKWsU0Y+66pOhZ8XLcEB9a9BCVFC5yWBhC0lPq6mAm4Dxydt3QY
 alo6lZyV
 WcTs4JDLmeL0AocA9teaKKP28uixnawvs2mOqQxxe9w4MKXRAMKGvCs+qXB0AtNyjGlBy/apPpdDMDyl7vFHkVzjheZYTnbYFOQg9o7F5F67lTOBbZjYF0972u4yLbb2ItNfTcaz+y/pMrYNMtaRYUsNtcgZp/ls0u3KGYDqW99Gwe49pOVrKOA+Nch4eJa6Xcl2U3jPdCdpyy8/o2Uh+RxCHnKawvJKFOLexT0pK8B4BRDM2WZ4i0/vQ/WLUqkt1TXaMq9gs1ofvqfY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Change read_file(), write_file(), read_num(), write_num() and
write_num_ignore_einval() in vm_util.c to report failures to callers
instead of exiting from the helper.

Make read_file() return a negative errno on failure and 0 on success, so
callers can distinguish a successful read from an I/O error. Also make
read_num() reject negative and malformed values.

Keep write_num_ignore_einval() silent for -EINVAL while returning other
errors to its caller.

Update callers to print diagnostics and fail wherever required. Modify
a comment which implies write_num() uses ksft_exit_fail_msg(). Also add
a helper print_file_access_error() in hugepage_settings.c to print
TAP-compatible errors without a kselftest dependency. This prepares the
helpers to be moved to tools/lib/mm without a kselftest dependency.

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 .../testing/selftests/mm/hugepage_settings.c  |  98 +++++++++++---
 .../selftests/mm/hugetlb-soft-offline.c       |  16 ++-
 tools/testing/selftests/mm/khugepaged.c       |  14 +-
 .../selftests/mm/split_huge_page_test.c       |   5 +-
 tools/testing/selftests/mm/vm_util.c          | 122 ++++++++++++------
 tools/testing/selftests/mm/vm_util.h          |   8 +-
 6 files changed, 192 insertions(+), 71 deletions(-)

diff --git a/tools/testing/selftests/mm/hugepage_settings.c b/tools/testing/selftests/mm/hugepage_settings.c
index 584054736ce9..9a63420d0744 100644
--- a/tools/testing/selftests/mm/hugepage_settings.c
+++ b/tools/testing/selftests/mm/hugepage_settings.c
@@ -8,6 +8,7 @@
 #include <stdlib.h>
 #include <string.h>
 #include <unistd.h>
+#include <errno.h>
 
 #include "vm_util.h"
 #include "hugepage_settings.h"
@@ -48,6 +49,11 @@ static const char * const shmem_enabled_strings[] = {
 	NULL
 };
 
+static void print_file_access_error(const char *path, int ret)
+{
+	printf("# %s: %s (%d)\n", path, strerror(-ret), -ret);
+}
+
 int thp_read_string(const char *name, const char * const strings[])
 {
 	char path[PATH_MAX];
@@ -61,8 +67,9 @@ int thp_read_string(const char *name, const char * const strings[])
 		exit(EXIT_FAILURE);
 	}
 
-	if (!read_file(path, buf, sizeof(buf))) {
-		perror(path);
+	ret = read_file(path, buf, sizeof(buf));
+	if (ret) {
+		print_file_access_error(path, ret);
 		exit(EXIT_FAILURE);
 	}
 
@@ -103,12 +110,17 @@ void thp_write_string(const char *name, const char *val)
 		printf("%s: Pathname is too long\n", __func__);
 		exit(EXIT_FAILURE);
 	}
-	write_file(path, val, strlen(val) + 1);
+	ret = write_file(path, val, strlen(val) + 1);
+	if (ret) {
+		print_file_access_error(path, ret);
+		exit(EXIT_FAILURE);
+	}
 }
 
 unsigned long thp_read_num(const char *name)
 {
 	char path[PATH_MAX];
+	unsigned long num;
 	int ret;
 
 	ret = snprintf(path, PATH_MAX, THP_SYSFS "%s", name);
@@ -116,7 +128,13 @@ unsigned long thp_read_num(const char *name)
 		printf("%s: Pathname is too long\n", __func__);
 		exit(EXIT_FAILURE);
 	}
-	return read_num(path);
+	ret = read_num(path, &num);
+	if (ret) {
+		print_file_access_error(path, ret);
+		exit(EXIT_FAILURE);
+	}
+
+	return num;
 }
 
 void thp_write_num(const char *name, unsigned long num)
@@ -129,7 +147,11 @@ void thp_write_num(const char *name, unsigned long num)
 		printf("%s: Pathname is too long\n", __func__);
 		exit(EXIT_FAILURE);
 	}
-	write_num(path, num);
+	ret = write_num(path, num);
+	if (ret) {
+		print_file_access_error(path, ret);
+		exit(EXIT_FAILURE);
+	}
 }
 
 void thp_read_settings(struct thp_settings *settings)
@@ -157,8 +179,15 @@ void thp_read_settings(struct thp_settings *settings)
 		.max_ptes_shared = thp_read_num("khugepaged/max_ptes_shared"),
 		.pages_to_scan = thp_read_num("khugepaged/pages_to_scan"),
 	};
-	if (dev_queue_read_ahead_path[0])
-		settings->read_ahead_kb = read_num(dev_queue_read_ahead_path);
+	if (dev_queue_read_ahead_path[0]) {
+		int ret = read_num(dev_queue_read_ahead_path,
+				   &settings->read_ahead_kb);
+
+		if (ret) {
+			print_file_access_error(dev_queue_read_ahead_path, ret);
+			exit(EXIT_FAILURE);
+		}
+	}
 
 	for (i = 0; i < NR_ORDERS; i++) {
 		if (!((1 << i) & orders)) {
@@ -208,8 +237,15 @@ void thp_write_settings(struct thp_settings *settings)
 	thp_write_num("khugepaged/max_ptes_shared", khugepaged->max_ptes_shared);
 	thp_write_num("khugepaged/pages_to_scan", khugepaged->pages_to_scan);
 
-	if (dev_queue_read_ahead_path[0])
-		write_num(dev_queue_read_ahead_path, settings->read_ahead_kb);
+	if (dev_queue_read_ahead_path[0]) {
+		int ret = write_num(dev_queue_read_ahead_path,
+				    settings->read_ahead_kb);
+
+		if (ret) {
+			print_file_access_error(dev_queue_read_ahead_path, ret);
+			exit(EXIT_FAILURE);
+		}
+	}
 
 	for (i = 0; i < NR_ORDERS; i++) {
 		if (!((1 << i) & orders))
@@ -307,8 +343,15 @@ static unsigned long __thp_supported_orders(bool is_shmem)
 		}
 
 		ret = read_file(path, buf, sizeof(buf));
-		if (ret)
-			orders |= 1UL << i;
+		if (ret) {
+			if (ret != -ENOENT) {
+				print_file_access_error(path, ret);
+				exit(EXIT_FAILURE);
+			}
+			continue;
+		}
+
+		orders |= 1UL << i;
 	}
 
 	return orders;
@@ -382,8 +425,7 @@ int detect_hugetlb_page_sizes(unsigned long sizes[], int max)
 		if (sscanf(entry->d_name, "hugepages-%zukB", &kb) != 1)
 			continue;
 		sizes[count++] = kb * 1024;
-		ksft_print_msg("[INFO] detected hugetlb page size: %zu KiB\n",
-			       kb);
+		printf("# [INFO] detected hugetlb page size: %zu KiB\n", kb);
 	}
 	closedir(dir);
 	return count;
@@ -425,28 +467,49 @@ static void hugetlb_sysfs_path(char *buf, size_t buflen,
 unsigned long hugetlb_nr_pages(unsigned long size)
 {
 	char path[PATH_MAX];
+	unsigned long nr;
+	int ret;
 
 	hugetlb_sysfs_path(path, sizeof(path), size, "nr_hugepages");
 
-	return read_num(path);
+	ret = read_num(path, &nr);
+	if (ret) {
+		print_file_access_error(path, ret);
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
 
-	write_num_ignore_einval(path, nr);
+	ret = write_num_ignore_einval(path, nr);
+	if (ret) {
+		print_file_access_error(path, ret);
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
+	if (ret) {
+		print_file_access_error(path, ret);
+		exit(EXIT_FAILURE);
+	}
+
+	return nr;
 }
 
 unsigned long hugetlb_nr_resv_pages(unsigned long size)
@@ -511,7 +574,8 @@ unsigned long hugetlb_setup(unsigned long nr, unsigned long sizes[],
 		return 0;
 
 	if (nr_enabled > max) {
-		ksft_print_msg("detected %d huge page sizes, will only test %d\n", nr_enabled, max);
+		printf("# detected %d huge page sizes, will only test %d\n",
+		       nr_enabled, max);
 		nr_enabled = max;
 	}
 
diff --git a/tools/testing/selftests/mm/hugetlb-soft-offline.c b/tools/testing/selftests/mm/hugetlb-soft-offline.c
index 4af9d3db7b5b..ffc85b958c69 100644
--- a/tools/testing/selftests/mm/hugetlb-soft-offline.c
+++ b/tools/testing/selftests/mm/hugetlb-soft-offline.c
@@ -85,8 +85,7 @@ static unsigned long orig_enable_soft_offline = -1UL;
 
 /*
  * Runs from an atexit handler, so it must not call anything that
- * exits on failure: write_num() would re-enter exit() through
- * ksft_exit_fail_msg().
+ * exits on failure.
  */
 static void restore_enable_soft_offline(void)
 {
@@ -152,7 +151,10 @@ static void test_soft_offline_common(int enable_soft_offline)
 	hugepagesize_kb = file_stat.f_bsize / 1024;
 	ksft_print_msg("Hugepagesize is %ldkB\n", hugepagesize_kb);
 
-	write_num(ENABLE_SOFT_OFFLINE_PATH, enable_soft_offline);
+	ret = write_num(ENABLE_SOFT_OFFLINE_PATH, enable_soft_offline);
+	if (ret)
+		ksft_exit_fail_msg("Failed to write to %s: %s\n",
+				   ENABLE_SOFT_OFFLINE_PATH, strerror(-ret));
 
 	nr_hugepages_before = hugetlb_nr_default_pages();
 
@@ -189,6 +191,8 @@ static void test_soft_offline_common(int enable_soft_offline)
 
 int main(int argc, char **argv)
 {
+	int ret;
+
 	ksft_print_header();
 
 	if (!hugetlb_setup_default(8))
@@ -196,7 +200,11 @@ int main(int argc, char **argv)
 
 	ksft_set_plan(2);
 
-	orig_enable_soft_offline = read_num(ENABLE_SOFT_OFFLINE_PATH);
+	ret = read_num(ENABLE_SOFT_OFFLINE_PATH, &orig_enable_soft_offline);
+	if (ret)
+		ksft_exit_fail_msg("Failed to read %s: %s\n",
+				   ENABLE_SOFT_OFFLINE_PATH, strerror(-ret));
+
 	atexit(restore_enable_soft_offline);
 
 	test_soft_offline_common(1);
diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index f82673f5f6b4..6daa22f6da2f 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -122,6 +122,7 @@ static void get_finfo(const char *dir)
 	char buf[1 << 10];
 	char path[PATH_MAX];
 	char *str, *end;
+	int ret;
 
 	finfo.dir = dir;
 	if (stat(finfo.dir, &path_stat))
@@ -142,8 +143,9 @@ static void get_finfo(const char *dir)
 		     major(path_stat.st_dev), minor(path_stat.st_dev))
 	    >= sizeof(path))
 		ksft_exit_fail_msg("%s: Pathname is too long\n", __func__);
-	if (!read_file(path, buf, sizeof(buf)))
-		ksft_exit_fail_perror("read_file(uevent)");
+	ret = read_file(path, buf, sizeof(buf));
+	if (ret)
+		ksft_exit_fail_msg("read_file(%s): %s\n", path, strerror(-ret));
 	if (strstr(buf, "DEVTYPE=disk")) {
 		/* Found it */
 		if (snprintf(finfo.dev_queue_read_ahead_path,
@@ -324,7 +326,7 @@ static void *file_setup_area_common(int nr_hpages, enum file_setup_ops setup)
 {
 	const int open_opt = setup == FILE_SETUP_READ_ONLY_FS ? O_RDONLY : O_RDWR;
 	const int mmap_prot = setup == FILE_SETUP_READ_ONLY_FS ? PROT_READ : (PROT_READ | PROT_WRITE);
-	int fd;
+	int fd, ret;
 	void *p;
 	unsigned long size;
 
@@ -362,7 +364,11 @@ static void *file_setup_area_common(int nr_hpages, enum file_setup_ops setup)
 		ksft_exit_fail_perror("mmap()");
 
 	/* Drop page cache */
-	write_file("/proc/sys/vm/drop_caches", "3", 2);
+	ret = write_file("/proc/sys/vm/drop_caches", "3", 2);
+	if (ret)
+		ksft_exit_fail_msg("write_file(drop_caches): %s\n",
+				   strerror(-ret));
+
 	success("OK");
 	return p;
 }
diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index c01d227d7fd6..a30927514b4f 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -145,7 +145,10 @@ static void write_debugfs(const char *fmt, ...)
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
index 80bc9f597b52..c1b8d60e519d 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -891,109 +891,149 @@ int unpoison_memory(unsigned long pfn)
 
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
+	return 0;
 }
 
-static void __write_file(const char *path, const char *buf, size_t buflen, bool ignore_einval)
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
-	if (numwritten < 0) {
-		if (ignore_einval && errno == EINVAL)
-			return;
-		ksft_exit_fail_msg("%s write(%.*s) failed: %s\n", path, (int)(buflen - 1),
-				buf, strerror(errno));
-	}
-	if (numwritten != buflen - 1)
-		ksft_exit_fail_msg("%s write(%.*s) is truncated, expected %zu bytes, got %zd bytes\n",
-				path, (int)(buflen - 1), buf, buflen - 1, numwritten);
-}
 
-void write_file(const char *path, const char *buf, size_t buflen)
-{
-	__write_file(path, buf, buflen, /* ignore_einval = */ false);
+	if (numwritten < 0)
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
 
-	if (!read_file(path, buf, sizeof(buf)))
-		ksft_exit_fail_perror("read_file()");
+	if (!num)
+		return -EINVAL;
 
-	return strtoul(buf, NULL, 10);
+	ret = read_file(path, buf, sizeof(buf));
+	if (ret)
+		return ret;
+
+	/* Reject signs and leading whitespace that are accepted by strtoul() */
+	if (buf[0] < '0' || buf[0] > '9')
+		return -EINVAL;
+
+	errno = 0;
+	val = strtoul(buf, &end, 10);
+	if (errno)
+		return -errno;
+
+	/* Only allow a newline after the number */
+	if (*end == '\n')
+		end++;
+
+	if (*end != '\0')
+		return -EINVAL;
+
+	*num = val;
+	return 0;
 }
 
-static void __write_num(const char *path, unsigned long num, bool ignore_einval)
+int write_num(const char *path, unsigned long num)
 {
 	char buf[21];
 
 	sprintf(buf, "%lu", num);
-	__write_file(path, buf, strlen(buf) + 1, ignore_einval);
+	return write_file(path, buf, strlen(buf) + 1);
 }
 
-void write_num(const char *path, unsigned long num)
+int write_num_ignore_einval(const char *path, unsigned long num)
 {
-	return __write_num(path, num, /* ignore_einval = */ false);
-}
+	int ret;
 
-void write_num_ignore_einval(const char *path, unsigned long num)
-{
-	return __write_num(path, num, /* ignore_einval = */ true);
+	ret = write_num(path, num);
+	return ret == -EINVAL ? 0 : ret;
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
index 9a49af88702e..62f6f5b42649 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -166,11 +166,11 @@ int unpoison_memory(unsigned long pfn);
 #define PAGEMAP_PRESENT(ent)	(((ent) & (1ull << 63)) != 0)
 #define PAGEMAP_PFN(ent)	((ent) & ((1ull << 55) - 1))
 
-void write_file(const char *path, const char *buf, size_t buflen);
+int write_file(const char *path, const char *buf, size_t buflen);
 int read_file(const char *path, char *buf, size_t buflen);
-unsigned long read_num(const char *path);
-void write_num(const char *path, unsigned long num);
-void write_num_ignore_einval(const char *path, unsigned long num);
+int read_num(const char *path, unsigned long *num);
+int write_num(const char *path, unsigned long num);
+int write_num_ignore_einval(const char *path, unsigned long num);
 
 void shm_limits_prepare(unsigned long length);
 void __shm_limits_restore(void);
-- 
2.53.0


