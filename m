Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08147C624D4
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 16:31:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 064FA6B00CF; Wed,  2 Sep 2026 12:31:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03B3B6B00D0; Wed,  2 Sep 2026 12:31:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBB3A6B00D1; Wed,  2 Sep 2026 12:31:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BFC986B00CF
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 12:31:17 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2D019402B2
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 16:31:17 +0000 (UTC)
X-FDA: 85169362194.17.C1EC76D
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2567A8000E
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 16:31:15 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=morinfr.org header.s=20170427 header.b=jCsT4623;
	spf=pass (imf02.hostedemail.com: domain of guillaume@morinfr.org designates 212.27.42.4 as permitted sender) smtp.mailfrom=guillaume@morinfr.org;
	dmarc=pass (policy=quarantine) header.from=morinfr.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788366675;
	b=03NsxIIWmha2otXOdvtBuVUhBvB1Dm5aOFXip8KLD6tLS+I1P5X6Q0LS/DTJONnR5GZqT3
	+W8FNC6O+6OBZs9xDDBCAZUgkgNxQ02vpoego0gM3c2wy3n769I79k3SDiKONJDWv4SWf4
	4+ioV8yV2Phuob7hL8zMlhi4SxjUUFI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=morinfr.org header.s=20170427 header.b=jCsT4623;
	spf=pass (imf02.hostedemail.com: domain of guillaume@morinfr.org designates 212.27.42.4 as permitted sender) smtp.mailfrom=guillaume@morinfr.org;
	dmarc=pass (policy=quarantine) header.from=morinfr.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788366675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=3Aw2R6r3uNxcbEWNzvudWhz43IRmAz3SmLQH9Xiy/RQ=;
	b=3Ad97qNOp4eInE6gOYWC+o+8sIoIxp/uYUsrS4p4CN1GRbMLUzHxXDwG1vmdF5vv1eE/1a
	Xf1gWcToko/aPC0d7H8ESrngLfommCKv+YXAIk8b+cH5L/sk4qJUOuFSVVwxSb2tav1nVM
	DUhvcTPI9ruH851lhjZa7kbEpTogKsg=
Received: from bender.morinfr.org (unknown [82.66.66.112])
	by smtp4-g21.free.fr (Postfix) with ESMTPS id 37ADE19F5AF;
	Wed,  2 Sep 2026 18:31:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=morinfr.org
	; s=20170427; h=Content-Type:MIME-Version:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=3Aw2R6r3uNxcbEWNzvudWhz43IRmAz3SmLQH9Xiy/RQ=; b=jCsT4623/4mOs71hkPOn0p+0zS
	8OZLf0mYytDhuC21k6xrSFcU8dssCWkoeF1+vi3BbLEzMp2LMi8bIpAGObEBFtqwmdyOP4N1S/Mc5
	hRjwF4U3yp76vlKGHxwMk9OuSkeJe6wWF6Dn4ioUgu7vi4S4pwwyqNTcC+SokKsu6nE0=;
Received: from guillaum by bender.morinfr.org with local (Exim 4.98.2)
	(envelope-from <guillaume@morinfr.org>)
	id 1x1nrg-00000001Rm4-32u2;
	Wed, 02 Sep 2026 18:31:08 +0200
Date: Wed, 2 Sep 2026 18:31:08 +0200
From: Guillaume Morin <guillaume@morinfr.org>
To: linux-mm@kvack.org
Cc: leitao@debian.org, guillaume@morinfr.org, rppt@kernel.org
Subject: [PATCH v3] selftests/mm: hugetlb_madv_vs_map: add underflow test
Message-ID: <aphPTJ4LK-Ag1C1m@bender.morinfr.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Stat-Signature: wmtf9eeokdnwfk89atpk8mmjwshf1mcw
X-Rspamd-Queue-Id: 2567A8000E
X-Rspamd-Server: rspam06
X-HE-Tag: 1788366675-492631
X-HE-Meta: U2FsdGVkX19+GtdyX3jEmWwzlvNIuNyOS0rYt2yn3hkUNlxsU9tuUd3eOdDMTKdZyvdE9A8pyQUcEEhqUNK3c75repe9TxDOpYEY1BiyNR60gpYy/nUagv4pjLzzz5Oyy7xuTEDxpPkYer6IfM/hvBupYEx8HOAJ3yTJeC5O2bYzi71a0KptxxnqYI+kJmLXWDzrGbsWMhFxLfnrmqi1Qt3J2Ia1tX3wKPYMYOpt1b8FdJBN2miLh9MvwaFgAYXyzkTuy5XbwrqZLF+12yT0zv6HXxQZ+54gvWD8k+wWvfui0AXS9yAyuk6qxiVqtSyUs4++0dtFcN8ok7d/UHpK7e+5Ea/WyWfbZdf2t9coZwPHNK9cFkE0G5Ru18KKBTkEn8qibsreCrqkXEctxmOfv8Fp8B70Gur+2jQdvaHx8ub/cmP/yzFuHkBQnDVljKzzioIP8p8kpCo7b8NGNQubmHjOwLd2cMBg3JXPWDdkZDyrPyCZlD+5CaUkDur+XFqX9OuoJPbUFLvTCWIm6hWdYO4j/SFKkdIzovmolSK3WSMmniI+dJOFc3qkIVTrjKbVwnTPRShSA0k2p4dpIggB8ZXzeKJsckdsGTaES2bpmEi+9f4DtI5soK9xphLfMX8nj796EoGrDi4sZWjW39OU7s46S8qcox9ziavg/QZR1SQqM9Dzc/1YbynCsobUsw/zgpvvus0qvP1U0vBUo/1Qs4jmfpk+TyzD9lFW/Hv0n70G6Eln6KQsKv7ymVu6MeV/TmIkpPs/3c6RzfAtPJB4/iHxG6swLIns/yu7zmEM2BfxlzwfUmBt6kTwSZ97NSpPGNEdkU7j1FuXkxzhB0vu7HQHGc3s7z8PTmOZVC+3NTOHmsQNUDqbpE/Wh3b6UOtYx73xb9Ym0c+ftX3PcQTew21lAbK5qxtGdhCxkVMnzAjym4frRjjNYGZwq8p+v2F1rAWwKYzWltUDdoY4bI2
 XaUZRK1A
 vs1LXMmD1B78BmEvIC3kyW8kPDiidzaJO1F2Ed2tOclpNy8JbGEtXhB89i5bkGuxAwfzqcT7OANI2x+X2Yg11z6OxDeXbdXDgjwsq6aJqDieuks5ap02kRoHe3oFgmlUddoLGsB1rg1NmiKGjrscRmDE2IrDEd5mbDT2iRFUP0598j9RwGYLbsoqS5ZSX0jcsauwIzAS6rGsp+YiefOi5OR/uSSTlPi2pjieFdvWBnILD+ZJpayoYPPfJa3VHhyu4yHaectFQ1UQuuNzborqR9uUkGgRbf6oJ7sem38cj+oCcDDGhbBIjybjndU5nUeMkMyqTOOZUNKN2Jk0zo/E/WrUNSbq5v//M6WUrT5sN0++78cUfkJw7KsqsbSclW0V4InbA26GTZWb+OSRxSfocslwUL4nGWnZpeOUo
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
v3: address Mike's comments
v2: refactor tests into 2 functions

 .../testing/selftests/mm/hugepage_settings.c  |   9 ++
 .../testing/selftests/mm/hugepage_settings.h  |   1 +
 .../selftests/mm/hugetlb_madv_vs_map.c        | 149 +++++++++++++++---
 3 files changed, 138 insertions(+), 21 deletions(-)

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
index f94549efcc6f..c944d99d5523 100644
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
@@ -74,7 +65,22 @@ void *map_extra(void *unused)
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
+
+void test_madv_vs_map(void)
 {
 	pthread_t thread1, thread2, thread3;
 	void *ret;
@@ -85,13 +91,6 @@ int main(void)
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
@@ -100,7 +99,7 @@ int main(void)
 				-1, 0);
 
 		if ((unsigned long)huge_ptr == -1)
-			ksft_exit_fail_msg("Failed to allocate huge page\n");
+			ksft_exit_fail_perror("Failed to allocate huge page\n");
 
 		pthread_create(&thread1, NULL, madv, NULL);
 		pthread_create(&thread2, NULL, touch, NULL);
@@ -120,5 +119,113 @@ int main(void)
 	}
 
 	ksft_test_result_pass("No unexpected huge page allocations\n");
+}
+
+/*  We create a child process, then unmap the page in the parent while the child
+ *  waits and verify that there is no underflow of the reserved count.
+ */
+
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
+	if (nr_reserved == ULONG_MAX) {
+		ksft_test_result_fail("After the munmap, HugePages_Rsvd underflowed!\n");
+		goto err_cleanup;
+	}
+	if (nr_reserved == 0) {
+		ksft_test_result_pass("Underflow not present!\n");
+	} else {
+		ksft_test_result_fail("Unexpected HugePages_Rsvd=%ld after munmap, should be 0 or -1.  Repeat the test\n",
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
+		ksft_exit_fail_msg("waitpid failed");
+	}
+
+	nr_reserved = hugetlb_nr_resv_pages(default_huge_page_size());
+	if (nr_reserved == 0) {
+		ksft_test_result_pass("After the child dies, HugePages_Rsvd is properly set to 0\n");
+	} else {
+		ksft_exit_fail_msg("Unexpected HugePages_Rsvd=%ld after the child termination munmap, should be 0 or -1.  Repeat the test\n",
+				   nr_reserved);
+	}
+	return;
+err_cleanup:
+	if (write(pipe_fds[1], &nr_reserved, 1) < 0) {
+		ksft_exit_fail_perror("write failed");
+	}
+	if (waitpid(pid, NULL, 0) <= 0) {
+		ksft_exit_fail_perror("waitpid failed");
+	}
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

