Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 636A9C79F82
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 19:34:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19EFF6B0095; Fri,  4 Sep 2026 15:34:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 150D46B0096; Fri,  4 Sep 2026 15:34:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06A0F6B0098; Fri,  4 Sep 2026 15:34:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C37856B0095
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 15:34:26 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 59C93A3CE1
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 19:34:26 +0000 (UTC)
X-FDA: 85177081332.19.771B844
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6AD0A180009
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 19:34:24 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=morinfr.org header.s=20170427 header.b="RcTvy/8n";
	dmarc=pass (policy=quarantine) header.from=morinfr.org;
	spf=pass (imf24.hostedemail.com: domain of guillaume@morinfr.org designates 212.27.42.4 as permitted sender) smtp.mailfrom=guillaume@morinfr.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788550464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=/k/DigVUZahp+YTSmfVTEyZ10bn5ZiBoZvjQJh0A0Ic=;
	b=fvyWjUc01REkQLTgHb88zPe2LtJks9yO5GdHDSFlzSwCZY3Ea7nBFGN7nagpY4HR4IBewa
	O++L10PRkupmUSWFupyDdWt0k14Yncb3vaw5SJ7Qmr2zpLDvCyFj/mVC1KAm41C/KjsiDf
	ypBLgGcrvPCWpHW8+QYDEPpg8h3/ggk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=morinfr.org header.s=20170427 header.b="RcTvy/8n";
	dmarc=pass (policy=quarantine) header.from=morinfr.org;
	spf=pass (imf24.hostedemail.com: domain of guillaume@morinfr.org designates 212.27.42.4 as permitted sender) smtp.mailfrom=guillaume@morinfr.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788550464;
	b=pkYleevYb0XTmt8uFV/gLM1gfSVqqs3mVIaqIt3OEqLsgz4e7NEYSy4ybEjsAHIAFxCuTJ
	0bdo18NJUhLgoPnPScb+ySRCByc9I+d30dCajZDMJJDtHR8g7sOq9GJrVvTFQXN5hyCFde
	E7l4/t3v9B4p2X9BX0VPERBKnihcyCU=
Received: from bender.morinfr.org (unknown [82.66.66.112])
	by smtp4-g21.free.fr (Postfix) with ESMTPS id 4EBCA19F58A;
	Fri,  4 Sep 2026 21:34:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=morinfr.org
	; s=20170427; h=Content-Type:MIME-Version:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=/k/DigVUZahp+YTSmfVTEyZ10bn5ZiBoZvjQJh0A0Ic=; b=RcTvy/8nIj5DOVdbNqsJBUqeYl
	m+fw/e78kf5y1dMfRYd/igfIJDRdc8kr5x4nfjaQg1fkikEl5kmPWlOrmnY6jITtrWlarSJZrNYDq
	krDpwnbJGpNrufJqyODKSjNVLyMI+VQ+Ur0fmiTKllKDIkrP9xkgkjyJq0C/4euxgGY0=;
Received: from guillaum by bender.morinfr.org with local (Exim 4.98.2)
	(envelope-from <guillaume@morinfr.org>)
	id 1x2Zg3-00000002jwO-0eAH;
	Fri, 04 Sep 2026 21:34:19 +0200
Date: Fri, 4 Sep 2026 21:34:19 +0200
From: Guillaume Morin <guillaume@morinfr.org>
To: linux-mm@kvack.org
Cc: leitao@debian.org, guillaume@morinfr.org, rppt@kernel.org
Subject: [PATCH v4] selftests/mm: hugetlb_madv_vs_map: add underflow test
Message-ID: <apsdO-IK6p-IDb-a@bender.morinfr.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: dstmx95edhx8rbbfm8hqr7bx3toregss
X-Rspamd-Queue-Id: 6AD0A180009
X-HE-Tag: 1788550464-160184
X-HE-Meta: U2FsdGVkX19yTVT8yXPq/SMcLbsnE40otC8A+zsP45KS+ZTCPnxLQ+8LbW8hoRXTVudBU5HF5s5dw24qxgfSb7FwvHzMvwvzmwbTE3vIrZ8QXf+2EMW9NaL+j7gWr0PUoMy0AbFQhoN72U/hdPgnEufZTTD+FqLQCroI3pGkWpoLauBMcuKhTIip//ObAULm6BW3AWkZgTT2s+OMRZi7bmnYSa1Vpftvm9k8a552DRtjsYXR6Rwp3wGAiQDZQopuHAU+jx6f0Ldc4Ba+dXii4NUvLVDJsCEeSVWNm+PtTeTKSYRZvHjWMd0UxX5YL9VohbHlYt1YSyKtCQx+a5hIcRNWyZceed507ysyrPX2Nl0ojxGwGHfGfIPzoS/D7KlGb244NMuwHu7+5GlcQEX0Rebe6SxxFOUiZzxefjS7B6fF4DaUFNFvg0WwIgjxCB9Dm9t/GJTmB1lvhdmkLv9vD9Hl1UcE/0h0jxf3yJ+bmpuXnOKoEH1VzrZTD4PKoTPcSm3CLkfJS+b6Lr4q845ZSQP5vAuQ9plwy95vDMxBlJqDtLTgDqRbZjdmYNO7biYmeZvOf56oP/8XysSPvmPEmnIheAnocb1bjzSFqkzZ/OCU5QpB6PgWrGTjXwbgCc51lrPMGT9I5gvQKSFsJMvscXQD3u1qYAu32o+RVujeCotEVC4Uuy7s+VXQUib+OL30e9u2SG5pHAIpizyWJr/TiOX3aOgX4kcVOvcnu1Xdf5WZB++cYcRYmwzZQ8ZelP+4StkOAMFcLqs3Lv3Cgq9Elug1L6A46ffTq5+S33/8+wjrks1P6Pw5QWmsnhOIN2fyrtM6NYzKmvre30nnWtYbOWUlDfYOIQlFLpz272RjYKv4FL5vwb8yWU/q+LsZ80O32uofzNDXvra/w7+U/5FmbSDl53VbsDosKLU2hzfW3I0HEIPGiUTXiI8uBW8w6KGdrv8VbFnmHrNLm1QW498
 FhXk5K6i
 Qycw7RSva3c3tuOyD+MFFAHm9vF61cvWI6Jbn/KMkfKEfjumxlFUTdWDVfMqfJrqIZUfSdQonIKieoT1uG52/VFnx8zlByOxxdtHuBn6vbewhe83H0jgg00adHg3XtJOOyK9/UJT7OG17oqrnQeQtwdiEGml6wqJXk8TL9nMO+P6Ud1fgxRqKCEfhch86ZiJ96RpiqzEezx4AmukR2j8hvpQgCe5RjouCtcZz/wS3x3v+VdTy/SKovrtmLZSxIUTcfSAmuTjFGk38F4BB4GsOVjjywT1s11T8rHbrEr2to/OlTg9nd9g+7P3B45AAXa1npWKMB2UuFtFDM7lDAbFUFwXaI24DRQ8ih24KUPckb3naelAkwz7eZSaoGJnfIKXP8PyhJurFJb3IsWbU6gmzPevhA6H0gwMOg5ea
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a test that checks for underflows when a parent unmaps the page
first. Also check that when the child exits the reserve count is
correct.

Link: https://lore.kernel.org/all/alEJkwn5VlTTH_ZX@bender.morinfr.org/
Signed-off-by: Guillaume Morin <guillaume@morinfr.org
Cc: Breno Leitao <leitao@debian.org>
Cc: Mike Rapoport <rppt@kernel.org>
---
v4: address Mike's comments
v3: address Mike's comments
v2: refactor tests into 2 functions

 .../testing/selftests/mm/hugepage_settings.c  |   9 ++
 .../testing/selftests/mm/hugepage_settings.h  |   1 +
 .../selftests/mm/hugetlb_madv_vs_map.c        | 145 +++++++++++++++---
 3 files changed, 134 insertions(+), 21 deletions(-)

diff --git a/tools/testing/selftests/mm/hugepage_settings.c b/tools/testing/selftests/mm/hugepage_settings.c
index d7917dce3aba..584054736ce9 100644
--- a/tools/testing/selftests/mm/hugepage_settings.c
+++ b/tools/testing/selftests/mm/hugepage_settings.c
@@ -449,6 +449,15 @@ unsigned long hugetlb_free_pages(unsigned long size)
 	return read_num(path);
 }
 
+unsigned long hugetlb_nr_resv_pages(unsigned long size)
+{
+	char path[PATH_MAX];
+
+	hugetlb_sysfs_path(path, sizeof(path), size, "resv_hugepages");
+
+	return read_num(path);
+}
+
 static bool __hugetlb_setup(unsigned long size, unsigned long nr)
 {
 	unsigned long free = hugetlb_free_pages(size);
diff --git a/tools/testing/selftests/mm/hugepage_settings.h b/tools/testing/selftests/mm/hugepage_settings.h
index 726c73c43c05..548e9d288d1d 100644
--- a/tools/testing/selftests/mm/hugepage_settings.h
+++ b/tools/testing/selftests/mm/hugepage_settings.h
@@ -98,6 +98,7 @@ unsigned long default_huge_page_size(void);
 unsigned long hugetlb_nr_pages(unsigned long size);
 void hugetlb_set_nr_pages(unsigned long size, unsigned long nr);
 unsigned long hugetlb_free_pages(unsigned long size);
+unsigned long hugetlb_nr_resv_pages(unsigned long size);
 
 static inline void hugetlb_save_settings(void)
 {
diff --git a/tools/testing/selftests/mm/hugetlb_madv_vs_map.c b/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
index f94549efcc6f..d89b2c27c2ae 100644
--- a/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
+++ b/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
@@ -3,25 +3,16 @@
  * A test case that must run on a system with one and only one huge page available.
  *	# echo 1 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
  *
- * During setup, the test allocates the only available page, and starts three threads:
- *  - thread1:
- *	* madvise(MADV_DONTNEED) on the allocated huge page
- *  - thread 2:
- *	* Write to the allocated huge page
- *  - thread 3:
- *	* Try to allocated an extra huge page (which must not available)
- *
- *  The test fails if thread3 is able to allocate a page.
- *
- *  Touching the first page after thread3's allocation will raise a SIGBUS
- *
  *  Author: Breno Leitao <leitao@debian.org>
  */
+#include <limits.h>
 #include <pthread.h>
+#include <signal.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <sys/mman.h>
 #include <sys/types.h>
+#include <sys/wait.h>
 #include <unistd.h>
 
 #include "vm_util.h"
@@ -74,7 +65,21 @@ void *map_extra(void *unused)
 	return NULL;
 }
 
-int main(void)
+/* During setup in main, the only available page was allocated. This test then
+ * starts three threads:
+ *
+ * - thread1:
+ *	* madvise(MADV_DONTNEED) on the allocated huge page
+ *  - thread 2:
+ *	* Write to the allocated huge page
+ *  - thread 3:
+ *	* Try to allocated an extra huge page (which must not available)
+ *
+ *  The test fails if thread3 is able to allocate a page.
+ *
+ *  Touching the first page after thread3's allocation will raise a SIGBUS
+ */
+void test_madv_vs_map(void)
 {
 	pthread_t thread1, thread2, thread3;
 	void *ret;
@@ -85,13 +90,6 @@ int main(void)
 	 */
 	int max = 10;
 
-	ksft_print_header();
-	ksft_set_plan(1);
-
-	if (!hugetlb_setup_default_exact(1))
-		ksft_exit_skip("This test needs one and only one page to execute. Got %lu\n",
-			       hugetlb_free_default_pages());
-
 	mmap_size = default_huge_page_size();
 
 	while (max--) {
@@ -100,7 +98,7 @@ int main(void)
 				-1, 0);
 
 		if ((unsigned long)huge_ptr == -1)
-			ksft_exit_fail_msg("Failed to allocate huge page\n");
+			ksft_exit_fail_perror("Failed to allocate huge page\n");
 
 		pthread_create(&thread1, NULL, madv, NULL);
 		pthread_create(&thread2, NULL, touch, NULL);
@@ -120,5 +118,110 @@ int main(void)
 	}
 
 	ksft_test_result_pass("No unexpected huge page allocations\n");
+}
+
+/*  We create a child process, then unmap the page in the parent while the child
+ *  waits and verify that there is no underflow of the reserved count. We also
+ *  verify that after the child exits, the reserved count is properly restored.
+ */
+void test_underflow(void)
+{
+	pid_t pid;
+	int pipe_fds[2];
+	unsigned long nr_reserved = 0;
+
+	huge_ptr = mmap(NULL, mmap_size, PROT_READ | PROT_WRITE,
+			MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB, -1, 0);
+
+	if ((unsigned long)huge_ptr == -1)
+		ksft_exit_fail_perror("Failed to allocate huge page\n");
+
+	nr_reserved = hugetlb_nr_resv_pages(default_huge_page_size());
+	if (nr_reserved != 1)
+		ksft_exit_fail_msg("Unexpected number of reserved pages: %lu, expected 1\n",
+				   nr_reserved);
+
+	/* Force the fault to ensure the reservation is consumed */
+	*huge_ptr = 0;
+	nr_reserved = hugetlb_nr_resv_pages(default_huge_page_size());
+	if (nr_reserved != 0)
+		ksft_exit_fail_msg("Unexpected number of reserved pages: %lu, expected 0\n",
+				   nr_reserved);
+
+	if (pipe(pipe_fds) != 0)
+		ksft_exit_fail_perror("pipe failed");
+
+	pid = fork();
+	if (pid < 0)
+		ksft_exit_fail_perror("fork failed");
+
+	if (pid == 0) {
+		/* Child: Simply wait for the parent */
+		char b;
+
+		close(pipe_fds[1]);
+		if (read(pipe_fds[0], &b, 1) < 0)
+			ksft_perror("child read failed");
+		/* Let the parent do the cleanup */
+		_exit(0);
+	}
+
+	/* Parent */
+	close(pipe_fds[0]);
+
+	/* First unmap, this will close the vma */
+	if (munmap(huge_ptr, mmap_size) != 0) {
+		ksft_perror("munmap failed");
+		goto err_cleanup;
+	}
+
+	nr_reserved = hugetlb_nr_resv_pages(default_huge_page_size());
+	if (nr_reserved == 0) {
+		ksft_test_result_pass("Underflow not present!\n");
+	} else {
+		ksft_test_result_fail("Unexpected HugePages_Rsvd=%ld after munmap, should be 0\n",
+				      nr_reserved);
+		goto err_cleanup;
+	}
+	/* Make the child exit, this should restore HugePages_Rsvd to 0 */
+	if (write(pipe_fds[1], &nr_reserved, 1) < 0) {
+		/* If write failed, the child is likely already gone */
+		ksft_exit_fail_perror("write failed");
+	}
+	close(pipe_fds[1]);
+	if (waitpid(pid, NULL, 0) <= 0) {
+		ksft_exit_fail_msg("waitpid failed\n");
+	}
+
+	nr_reserved = hugetlb_nr_resv_pages(default_huge_page_size());
+	if (nr_reserved == 0) {
+		ksft_test_result_pass("After the child dies, HugePages_Rsvd is properly set to 0\n");
+	} else {
+		ksft_exit_fail_msg("Unexpected HugePages_Rsvd=%ld after the child termination munmap, should be 0\n", nr_reserved);
+	}
+	return;
+
+err_cleanup:
+	if (write(pipe_fds[1], &nr_reserved, 1) < 0) {
+		ksft_exit_fail_perror("write failed");
+	}
+	if (waitpid(pid, NULL, 0) <= 0) {
+		ksft_exit_fail_perror("waitpid failed");
+	}
+	ksft_exit_fail();
+}
+
+int main(void)
+{
+	ksft_print_header();
+	ksft_set_plan(3);
+
+	if (!hugetlb_setup_default_exact(1))
+		ksft_exit_skip("This test needs one and only one page to execute. Got %lu\n",
+			       hugetlb_free_default_pages());
+
+	test_madv_vs_map();
+	test_underflow();
+
 	ksft_finished();
 }
-- 
2.39.1


-- 
Guillaume Morin <guillaume@morinfr.org>

