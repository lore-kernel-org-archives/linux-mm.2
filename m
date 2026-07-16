Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35160C44515
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 14:59:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 946F76B0116; Thu, 16 Jul 2026 10:59:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F7836B0118; Thu, 16 Jul 2026 10:59:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BF526B0119; Thu, 16 Jul 2026 10:59:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 42E416B0116
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:59:37 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 62C3380157
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 12:33:05 +0000 (UTC)
X-FDA: 84994579530.02.A345E40
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 38D9B1A0003
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 12:33:03 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="H6lwRvq/";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784205183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7utael0SpIRSYUzRmKChOpRmaMD49vDMFdc6t6lX7CI=;
	b=4Kn/eWObQswIHFxkdIt8lzGhUAqnSevmHfTQRxPI2SQiaxESipvZcyqWM4Ud/M5po7C9vS
	OpXxiFrZe7XUijD+1Qy8+11U0gZN27UKNqxPH7Pqyn7Yj0iBrT4v5xpHperOV5C1iW+RDL
	Ek//BG3HPfuSsVSskSXGgES4gNQWw0g=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="H6lwRvq/";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784205183;
	b=xuFLzb/6cvjKbBV+eR7d7yZxzOlqhsclL+2eSfiP2eyLsPo3KDSjdkqrbppX/9AwYt83rK
	4spSWSzmnrNfRUwfxa4gQJsEEEh/c1IWMaMCuYit32Z7svEl30SPn8OTGxP22wAINyuV1e
	wsYjNo+B8/LoHhGF4eS9EICN1vu9iSg=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CABFF1477;
	Thu, 16 Jul 2026 05:32:57 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 9DBBA3F7B4;
	Thu, 16 Jul 2026 05:32:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784205182; bh=f87CXNDxGCFgIK9Mf5ZZ6MiQikxDkpSK3z3WMK02KVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H6lwRvq/fZHMlwwKOoasYfFAyt6obguh6bb/mUETQOeum+0Mn5wDu/lzWB4M4/pny
	 AfwwbKu1YPoPY8FrhQeV0/sMjuGAA3tDzEXLXwYO2xtG9P+hGtrSCP1NOrbCNwnoFN
	 GZJgkVt5wE3PdZlh7ahWgqVncQIhITLDyoTXLnVY=
From: Sarthak Sharma <sarthak.sharma@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
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
	Jonathan Corbet <corbet@lwn.net>,
	Mark Brown <broonie@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH v5 1/5] selftests/mm: make file helpers return errors
Date: Thu, 16 Jul 2026 18:02:22 +0530
Message-ID: <20260716123226.197736-2-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260716123226.197736-1-sarthak.sharma@arm.com>
References: <20260716123226.197736-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hu81npuziz3i41o7tjruzg5qkwz7iyie
X-Rspamd-Queue-Id: 38D9B1A0003
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784205183-40751
X-HE-Meta: U2FsdGVkX1+z66SlF3bW6g5xRB5jE+kBduXKu44gLJ2COqFkNeX2NN+21Pk0g8orS8pZQLlozNIrQfJz4b5x7ALg6PCH6rXa/DrFV+/RSHVc2sI8EZuU3CN7ufpx6b8jxCvcX5ukncKTtbpzIUl50f6S5u0O+MZA/5vhy5K/Kcd8Q8sy+fVooD53QnI1A232my3Fk4bFpu0mdGnKcUxWgUY4xmKDg++/zZbpX5QstupK/8sTU3uDzJsxfTwTz/z84mckj9cPF/ckYphmMGIWrJAo7ykxtuQtrC2arKF2Y8+11CmJyRt4ehH9QGKfUSVUCEiAjEi++6YjPeHFLLFtebEu2g0lV6VAuJ5j5eFaQ7exQeJxNsiWx9XY361XaY8FScja3/p55FHHEKrCqeYTFCltCzJHcvORarczj+r0+RmJpF2MSMTZ1Mc8P03QhB+/apxJoAmuXry8EO2DRteOWj3MpE4hK2dJeXbFSQqaGizVIj3LGc90WDq9mAKRBm/i5SwldARjzkyqZEANaad7vFSzsk8SQ+TPhyqSnNibiU2+k8D7JLRr2xgMcI9AXgFdgYEolzjGzdUdHUoKiqg1XAJh6KG8/qM1sbQ9hmaYejELax8GPplcvK7aCFK7R8UxS1WmHeGbf/znq8FZgMMp05e6rKcOZ40soo6kEEfZrCG7RX1W8JXoGvx+6z0UmOeul+ZcD9UK7OxJN4BA8MY+ppTm2vuewxXEOjonrD6rCKwUgCw7MRkGKiyeeV6N3JvelToP1LbWy0IeIYyzvPzq+kbPElonB8Vj2iXfvI9kCDYwSa10SMx6hZotNNctyILwwLlGbGD+h/N8ZI29yjOwkeeRrfuA5YOJyTUXQlNKdVRs829BuaciO8JqUCrLPul8ed9jjFl7QHpFXFmsH+CUMDBrqM6CzAQzTuEMBKgjoWRjkCx52BSRn5yZrWAPWVci3wVYVLXI4iQtnIA+OQK
 SaBqku4p
 5oOjY81dngk9o+g/WUTO1qCq7IMw5hynmwc/s5YOFf/jLAio+fQBYInUJ4gZ63rEcPKnefYoNNq3fTvLR8x++qxcEyS1Upy9z8TGw3fk3WOn8LNpl41vkTelT+OCKlKaXFTIjpKapZyIEYBZELup14lTqQfJyVoBavAvLJEAGhK5sYtC5Vw15pdi67NVho/JzU0Od/9XQUSi8gUuJHn4Uzmk76ypPWtUEKHHbFxrv2ehQaBBb1f2j9IT6EQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Change read_file(), write_file(), read_num() and write_num() in vm_util.c
to report failures to callers instead of exiting from the helper.

Update the helpers to print TAP compatible diagnostics before returning
errors and update their callers to handle those errors. This prepares
the helpers to be moved to tools/lib/mm without carrying selftest-specific
process-exit behaviour into the shared implementation.

Also, make read_file() return a negative errno on failure instead of 0, so
callers can distinguish a successful read from an I/O error. Make
read_num() reject negative and malformed values.

Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 .../testing/selftests/mm/hugepage_settings.c  |  64 +++++++---
 tools/testing/selftests/mm/khugepaged.c       |  13 +-
 .../selftests/mm/split_huge_page_test.c       |   4 +-
 tools/testing/selftests/mm/vm_util.c          | 115 +++++++++++++-----
 tools/testing/selftests/mm/vm_util.h          |   6 +-
 5 files changed, 150 insertions(+), 52 deletions(-)

diff --git a/tools/testing/selftests/mm/hugepage_settings.c b/tools/testing/selftests/mm/hugepage_settings.c
index 2eab2110ac6a..202c8e6b0246 100644
--- a/tools/testing/selftests/mm/hugepage_settings.c
+++ b/tools/testing/selftests/mm/hugepage_settings.c
@@ -61,10 +61,9 @@ int thp_read_string(const char *name, const char * const strings[])
 		exit(EXIT_FAILURE);
 	}
 
-	if (!read_file(path, buf, sizeof(buf))) {
-		perror(path);
+	ret = read_file(path, buf, sizeof(buf));
+	if (ret < 0)
 		exit(EXIT_FAILURE);
-	}
 
 	c = strchr(buf, '[');
 	if (!c) {
@@ -103,12 +102,15 @@ void thp_write_string(const char *name, const char *val)
 		printf("%s: Pathname is too long\n", __func__);
 		exit(EXIT_FAILURE);
 	}
-	write_file(path, val, strlen(val) + 1);
+	ret = write_file(path, val, strlen(val) + 1);
+	if (ret < 0)
+		exit(EXIT_FAILURE);
 }
 
 unsigned long thp_read_num(const char *name)
 {
 	char path[PATH_MAX];
+	unsigned long num;
 	int ret;
 
 	ret = snprintf(path, PATH_MAX, THP_SYSFS "%s", name);
@@ -116,7 +118,11 @@ unsigned long thp_read_num(const char *name)
 		printf("%s: Pathname is too long\n", __func__);
 		exit(EXIT_FAILURE);
 	}
-	return read_num(path);
+	ret = read_num(path, &num);
+	if (ret < 0)
+		exit(EXIT_FAILURE);
+
+	return num;
 }
 
 void thp_write_num(const char *name, unsigned long num)
@@ -129,7 +135,9 @@ void thp_write_num(const char *name, unsigned long num)
 		printf("%s: Pathname is too long\n", __func__);
 		exit(EXIT_FAILURE);
 	}
-	write_num(path, num);
+	ret = write_num(path, num);
+	if (ret < 0)
+		exit(EXIT_FAILURE);
 }
 
 void thp_read_settings(struct thp_settings *settings)
@@ -157,8 +165,13 @@ void thp_read_settings(struct thp_settings *settings)
 		.max_ptes_shared = thp_read_num("khugepaged/max_ptes_shared"),
 		.pages_to_scan = thp_read_num("khugepaged/pages_to_scan"),
 	};
-	if (dev_queue_read_ahead_path[0])
-		settings->read_ahead_kb = read_num(dev_queue_read_ahead_path);
+	if (dev_queue_read_ahead_path[0]) {
+		int ret = read_num(dev_queue_read_ahead_path,
+				   &settings->read_ahead_kb);
+
+		if (ret < 0)
+			exit(EXIT_FAILURE);
+	}
 
 	for (i = 0; i < NR_ORDERS; i++) {
 		if (!((1 << i) & orders)) {
@@ -208,8 +221,13 @@ void thp_write_settings(struct thp_settings *settings)
 	thp_write_num("khugepaged/max_ptes_shared", khugepaged->max_ptes_shared);
 	thp_write_num("khugepaged/pages_to_scan", khugepaged->pages_to_scan);
 
-	if (dev_queue_read_ahead_path[0])
-		write_num(dev_queue_read_ahead_path, settings->read_ahead_kb);
+	if (dev_queue_read_ahead_path[0]) {
+		int ret = write_num(dev_queue_read_ahead_path,
+				    settings->read_ahead_kb);
+
+		if (ret < 0)
+			exit(EXIT_FAILURE);
+	}
 
 	for (i = 0; i < NR_ORDERS; i++) {
 		if (!((1 << i) & orders))
@@ -306,8 +324,11 @@ static unsigned long __thp_supported_orders(bool is_shmem)
 			exit(EXIT_FAILURE);
 		}
 
+		if (access(path, F_OK))
+			continue;
+
 		ret = read_file(path, buf, sizeof(buf));
-		if (ret)
+		if (ret > 0)
 			orders |= 1UL << i;
 	}
 
@@ -425,28 +446,43 @@ static void hugetlb_sysfs_path(char *buf, size_t buflen,
 unsigned long hugetlb_nr_pages(unsigned long size)
 {
 	char path[PATH_MAX];
+	unsigned long nr;
+	int ret;
 
 	hugetlb_sysfs_path(path, sizeof(path), size, "nr_hugepages");
 
-	return read_num(path);
+	ret = read_num(path, &nr);
+	if (ret < 0)
+		exit(EXIT_FAILURE);
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
+	if (ret < 0)
+		exit(EXIT_FAILURE);
 }
 
 unsigned long hugetlb_free_pages(unsigned long size)
 {
 	char path[PATH_MAX];
+	unsigned long nr;
+	int ret;
 
 	hugetlb_sysfs_path(path, sizeof(path), size, "free_hugepages");
 
-	return read_num(path);
+	ret = read_num(path, &nr);
+	if (ret < 0)
+		exit(EXIT_FAILURE);
+
+	return nr;
 }
 
 static bool __hugetlb_setup(unsigned long size, unsigned long nr)
diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 10e8dedcb087..5eac27dd9683 100644
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
+		ksft_exit_fail();
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
+		ksft_exit_fail();
+
 	success("OK");
 	return p;
 }
diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index 32b991472f74..83a75001518b 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -269,7 +269,9 @@ static void write_debugfs(const char *fmt, ...)
 	if (ret >= INPUT_MAX)
 		ksft_exit_fail_msg("%s: Debugfs input is too long\n", __func__);
 
-	write_file(SPLIT_DEBUGFS, input, ret + 1);
+	ret = write_file(SPLIT_DEBUGFS, input, ret + 1);
+	if (ret)
+		ksft_exit_fail();
 }
 
 static char *allocate_zero_filled_hugepage(size_t len)
diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index 311fc5b4513e..bfe0efbe517e 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -704,87 +704,142 @@ int read_file(const char *path, char *buf, size_t buflen)
 	ssize_t numread;
 
 	fd = open(path, O_RDONLY);
-	if (fd == -1)
-		return 0;
+	if (fd == -1) {
+		int err = errno;
+
+		printf("# %s: %s (%d)\n", path, strerror(err), err);
+		return -err;
+	}
 
 	numread = read(fd, buf, buflen - 1);
 	if (numread < 1) {
+		int err = numread ? errno : ENODATA;
 		close(fd);
-		return 0;
+		printf("# %s: %s (%d)\n", path, strerror(err), err);
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
 
-	if (buflen < 2)
-		ksft_exit_fail_msg("Incorrect buffer len: %zu\n", buflen);
+	if (buflen < 2) {
+		printf("# %s: %s (%d)\n", path, strerror(EINVAL), EINVAL);
+		return -EINVAL;
+	}
 
 	fd = open(path, O_WRONLY);
-	if (fd == -1)
-		ksft_exit_fail_msg("%s open failed: %s\n", path, strerror(errno));
+	if (fd == -1) {
+		int err = errno;
+
+		printf("# %s: %s (%d)\n", path, strerror(err), err);
+		return -err;
+	}
 
 	numwritten = write(fd, buf, buflen - 1);
 	saved_errno = errno;
 	close(fd);
-	errno = saved_errno;
-	if (numwritten < 0)
-		ksft_exit_fail_msg("%s write(%.*s) failed: %s\n", path, (int)(buflen - 1),
-				buf, strerror(errno));
-	if (numwritten != buflen - 1)
-		ksft_exit_fail_msg("%s write(%.*s) is truncated, expected %zu bytes, got %zd bytes\n",
-				path, (int)(buflen - 1), buf, buflen - 1, numwritten);
+	if (numwritten < 0) {
+		printf("# %s: %s (%d)\n", path, strerror(saved_errno), saved_errno);
+		return -saved_errno;
+	}
+
+	if (numwritten != (ssize_t)(buflen - 1)) {
+		printf("# %s write(%.*s) is truncated, expected %zu bytes, got %zd bytes\n",
+		       path, (int)(buflen - 1), buf, buflen - 1, numwritten);
+		return -EIO;
+	}
+
+	return 0;
 }
 
-unsigned long read_num(const char *path)
+int read_num(const char *path, unsigned long *num)
 {
+	unsigned long val;
+	int err, ret;
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
+	if (errno) {
+		err = errno;
+		printf("# %s: %s (%d)\n", path, strerror(err), err);
+		return -err;
+	}
+
+	if (end == buf || buf[0] == '-') {
+		printf("# %s: invalid numeric value\n", path);
+		return -EINVAL;
+	}
+
+	if (*end == '\n')
+		end++;
+
+	if (*end != '\0') {
+		printf("# %s: invalid numeric value\n", path);
+		return -EINVAL;
+	}
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
+	if (shmmax && write_num("/proc/sys/kernel/shmmax", shmmax))
+		ksft_exit_fail();
+	if (shmall && write_num("/proc/sys/kernel/shmall", shmall))
+		ksft_exit_fail();
 }
 
 void shm_limits_prepare(unsigned long length)
 {
 	unsigned long nr = length / psize();
 	unsigned long val;
+	int ret;
 
-	val = read_num("/proc/sys/kernel/shmmax");
+	ret = read_num("/proc/sys/kernel/shmmax", &val);
+	if (ret)
+		ksft_exit_fail();
 	if (val < length) {
-		write_num("/proc/sys/kernel/shmmax", length);
+		ret = write_num("/proc/sys/kernel/shmmax", length);
+		if (ret)
+			ksft_exit_fail();
 		shmmax = val;
 	}
 
-	val = read_num("/proc/sys/kernel/shmall");
+	ret = read_num("/proc/sys/kernel/shmall", &val);
+	if (ret)
+		ksft_exit_fail();
 	if (val < nr) {
-		write_num("/proc/sys/kernel/shmall", nr);
+		ret = write_num("/proc/sys/kernel/shmall", nr);
+		if (ret)
+			ksft_exit_fail();
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


