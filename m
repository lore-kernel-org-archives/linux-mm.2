Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0867CC88E6E
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 15:36:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC83E6B0095; Mon, 14 Sep 2026 11:36:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA6C86B009E; Mon, 14 Sep 2026 11:36:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB6406B009F; Mon, 14 Sep 2026 11:36:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 96C606B0095
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:36:32 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1F7EDA01A5
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:36:32 +0000 (UTC)
X-FDA: 85212769824.23.4025AD3
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4])
	by imf25.hostedemail.com (Postfix) with ESMTP id C3960A0007
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:36:27 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=morinfr.org header.s=20170427 header.b=DFevq27h;
	spf=pass (imf25.hostedemail.com: domain of guillaume@morinfr.org designates 212.27.42.4 as permitted sender) smtp.mailfrom=guillaume@morinfr.org;
	dmarc=pass (policy=quarantine) header.from=morinfr.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789400188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=XijXhIvSeP8ZpB+BL+DisRiFWyRHQETu+uNwniewtOw=;
	b=GoLqi8aibDKobhc75y3oxD9BSPCTKsZGTNmvadHMvNsSevRIRhp/Q8nZL/mBBH48Ra9N4t
	GfNALzAuM+0h1qQX3lgmlrbdZ8tGMtq5t4p0ESBamyOqhmT20tFzeCluK55mzLLZTXrEcN
	O3TPANX21aV6w/7+7E0lo+/c3jlSKqQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789400188;
	b=tVCvN1kFirH8626gB1wxAOHn80FtoI9lgWJNNmzRI+kEVQ96r7uStEEpceBuMbMBbswQrn
	hstvIZZ7UAQ48ny6KJHnKXq5tJaK/bHZAmKo8GL4jXK0f6zheBVnQr6/CoMPkENk+CUCqM
	E4PTpHe2uv+j4Efhs3pTSTGPx8ujA50=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=morinfr.org header.s=20170427 header.b=DFevq27h;
	spf=pass (imf25.hostedemail.com: domain of guillaume@morinfr.org designates 212.27.42.4 as permitted sender) smtp.mailfrom=guillaume@morinfr.org;
	dmarc=pass (policy=quarantine) header.from=morinfr.org
Received: from bender.morinfr.org (unknown [82.66.66.112])
	by smtp4-g21.free.fr (Postfix) with ESMTPS id BAC3C19F5B2;
	Mon, 14 Sep 2026 17:36:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=morinfr.org
	; s=20170427; h=Content-Type:MIME-Version:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=XijXhIvSeP8ZpB+BL+DisRiFWyRHQETu+uNwniewtOw=; b=DFevq27hwxd/YVgJbls82NISEH
	68/0JjFfjMYFjbB9BHE6am8/E9ZFYAj4ioeeaujSl0Tf1Lp+n7pRRg1TV3Ke40xGzQqXmg5k7RB+f
	Ma62jula8HxOKC3X1+TnOpSd1HlheQGaWpn8z7N+uzdhlxFqUW+7PcgsQ29izgEH0Fzg=;
Received: from guillaum by bender.morinfr.org with local (Exim 4.98.2)
	(envelope-from <guillaume@morinfr.org>)
	id 1x68jF-00000007zFJ-2vMg;
	Mon, 14 Sep 2026 17:36:21 +0200
Date: Mon, 14 Sep 2026 17:36:21 +0200
From: Guillaume Morin <guillaume@morinfr.org>
To: linux-mm@kvack.org
Cc: leitao@debian.org, guillaume@morinfr.org, rppt@kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v5] selftests/mm: hugetlb_madv_vs_map: add underflow test
Message-ID: <aqgUdbtumaO8RiIb@bender.morinfr.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C3960A0007
X-Stat-Signature: pye3nnhoasftpuwjadmd7xre31mx89ds
X-Rspam-User: 
X-HE-Tag: 1789400187-764131
X-HE-Meta: U2FsdGVkX19oR+DpJLRAEbIJxNA/3vtDKQegZPjtndaJUMMFt6GatnDWXiIC8nDQU+zyynavVLQ7tPkVqanmBnAsCU1jLuuJb14cqxFYRhlRwsrvYWJPMx4AyVcsBMXrkBJTalVsfRHgS/USL0G5OgyATU1XPXbUeyqUU8MH5cqt7W4n0zOk6zZz/7EJzUhUX0DPEfOGN9uWyOKs/llYHB564AWncrc8dMvOwkyinsGLH2WW7LCA+oFo/aqebiRKvF8K86GxLi0tlK/wZlN7S5r9uc2jkzJZUZ7Bde0IkJMtWosPtUdXzAZh8kzNRmnIGoDhbCNO8RCJqLtsq8u8UFHgJSAksUzeo3X9xL+fF4LI+KjWW8ui3zJUjhVHjOrRixyYiuRxlZ2eiIOuhHHezXoISZDhIYsrYugsxV3vAU7EVtoDaMOiixNPJjLh3/DZxhgAoIFrspAASHsAVE7verNB79IPiJ9FJnTiagufrOzKb7G/H8i9gph9GUIjI/cIrsf0rnRk+2oUNfOLAXKSqCust60IOo1+0vHvbUZr8draqnIORp81V3tMwA0OaD4zqZJuoq/MDap4sjaVG/Q3XLZMkLqTKUD01i8MFMYR0+ZbasPgrXzbZ/rwFr3xFbByLJDuzvHB9Q6yTgECwAzkAy2x2dopYmqfo5o9rxaJtRz6vSr70BDL4GEASNLS6OenB5hLgcDfOkfKlP2C6980af/QjJ9Elfq80NG15UIiPBuRM1MXBiAlWShK0p6SgES+g0ykm9FjM4pKsnDs7Mf600ixXS2do23XNtcvyR3sEzlkj6Yz5qbk3GekFuOWC2b4I/0xBa29Q1dGrh1dArkDvY0dxWWxxx3HfOeN6alzZhqdCBuG8sOQRyFsLnepcKq5NBXFAkHNkgFjFyZFCWaL2VlFA22YwesBZc+ksZ4oTXYtmcKnr0GFZOAhZo1TXX3xJmdBNgLJBeav3Yzwrj4
 6Ztz2Uom
 IZ3QqHNTrLx0+7cmOarBfrS/GsLPbZHTHE4B/dvOFAYxAD/oz1xcrODc2a1X1Vku6AcbL0B2nQsuhwtmtURqfDttzf/IgI6LzmzhXo4vXs/dFCAU13aHnIm0dtEn2jZN/j8UkcU1tWGtTMV8GOPwV8fQ4PDHWDWzFx32aGRfJZPwPEqON21kgjT+hLsW8o6aBqJ7GZ2JGBLDSAkSv+R2u2WMmFHMRhoyYOWPbve736mYHemihBFMsuzqqqbfe/WvByaiT5+CC6BrLJsFdilLrX0DC6fBa0BUpjofZ6c+g9e7rLYN+5eq5mifQu2Qi7es1zpmCXP+LLAyUDXqJKpYxEX89ehsNMnCfTlIvz3YsECDK220HpSFdf84Wh9cbI7SB7po/j8glBZN3d0leRXYDkSWhRVMA6ATLmwE2FKTRkyRhQOHTXQi07xNwnvAzdBZHvfQr4ES2n2WDu0cIm+ZCYp4qXw==
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
Signed-off-by: Guillaume Morin <guillaume@morinfr.org>
Reviewed-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Mike Rapoport <rppt@kernel.org>
Cc: Breno Leitao <leitao@debian.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
v5: address Mike and Breno's comments
v4: address Mike's comments
v3: address Mike's comments
v2: refactor tests into 2 functions

 .../testing/selftests/mm/hugepage_settings.c  |   9 ++
 .../testing/selftests/mm/hugepage_settings.h  |   1 +
 .../selftests/mm/hugetlb_madv_vs_map.c        | 141 +++++++++++++++---
 3 files changed, 130 insertions(+), 21 deletions(-)

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
index f94549efcc6f..0f15eff1da04 100644
--- a/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
+++ b/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
@@ -3,18 +3,6 @@
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
 #include <pthread.h>
@@ -22,6 +10,7 @@
 #include <stdlib.h>
 #include <sys/mman.h>
 #include <sys/types.h>
+#include <sys/wait.h>
 #include <unistd.h>
 
 #include "vm_util.h"
@@ -74,7 +63,21 @@ void *map_extra(void *unused)
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
@@ -85,13 +88,6 @@ int main(void)
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
@@ -100,7 +96,7 @@ int main(void)
 				-1, 0);
 
 		if ((unsigned long)huge_ptr == -1)
-			ksft_exit_fail_msg("Failed to allocate huge page\n");
+			ksft_exit_fail_perror("Failed to allocate huge page");
 
 		pthread_create(&thread1, NULL, madv, NULL);
 		pthread_create(&thread2, NULL, touch, NULL);
@@ -120,5 +116,108 @@ int main(void)
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
+		ksft_exit_fail_perror("Failed to allocate huge page");
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
+	if (waitpid(pid, NULL, 0) <= 0)
+		ksft_exit_fail_msg("waitpid failed\n");
+
+	nr_reserved = hugetlb_nr_resv_pages(default_huge_page_size());
+	if (nr_reserved == 0)
+		ksft_test_result_pass("After the child dies, HugePages_Rsvd is properly set to 0\n");
+	else
+		ksft_exit_fail_msg("Unexpected HugePages_Rsvd=%ld after the child termination munmap, should be 0\n", nr_reserved);
+
+	return;
+
+err_cleanup:
+	if (write(pipe_fds[1], &nr_reserved, 1) < 0)
+		ksft_exit_fail_perror("write failed");
+	if (waitpid(pid, NULL, 0) <= 0)
+		ksft_exit_fail_perror("waitpid failed");
+
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

