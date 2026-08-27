Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40EEAC61DCB
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 18:00:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D9496B008A; Thu, 27 Aug 2026 14:00:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 389F56B008C; Thu, 27 Aug 2026 14:00:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29FB46B0092; Thu, 27 Aug 2026 14:00:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E3DD46B008A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 14:00:56 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 72657160178
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 18:00:56 +0000 (UTC)
X-FDA: 85147815312.23.A44CBBE
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7523F40010
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 18:00:54 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=morinfr.org header.s=20170427 header.b=e0K5g7Zg;
	spf=pass (imf01.hostedemail.com: domain of guillaume@morinfr.org designates 212.27.42.4 as permitted sender) smtp.mailfrom=guillaume@morinfr.org;
	dmarc=pass (policy=quarantine) header.from=morinfr.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787853655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Aw92pmZXy3D8SuXNYA66dam0lMScetM5A73jIG3j7k8=;
	b=ar5EW0euuyn57GismorI7B/1KpdWD5QU3AxP/z4UDiBblWbjZN6LrVCVpPXuSEL2IwON1f
	2MA9wIh+1/r6hlhB89pVST3pWlNWqvqNNbASsTMxmCODgVxksPjvMcBnTkLcva1xTT2CAi
	ipFhT2pET0I7opm4T1Tp41p6EHdatxQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787853655;
	b=w9LknO3Cnz1wXE2t//sEl2xORzsjxrxmWNkYx0EQrJ092Aa8MNwjhQeFnf4YaWuuo9RKib
	9mATh+w/jgQz5XX9Dl1BakntwtpztGQYNIdk1fcV+VQuzJZkq9AU7NwtZkQvqlPnQ1+o4D
	Hvyt+Fob73XjzryGWY3UiiIMsabSXIk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=morinfr.org header.s=20170427 header.b=e0K5g7Zg;
	spf=pass (imf01.hostedemail.com: domain of guillaume@morinfr.org designates 212.27.42.4 as permitted sender) smtp.mailfrom=guillaume@morinfr.org;
	dmarc=pass (policy=quarantine) header.from=morinfr.org
Received: from bender.morinfr.org (unknown [82.66.66.112])
	by smtp4-g21.free.fr (Postfix) with ESMTPS id A3F6619F72F;
	Thu, 27 Aug 2026 20:00:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=morinfr.org
	; s=20170427; h=Content-Type:MIME-Version:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Aw92pmZXy3D8SuXNYA66dam0lMScetM5A73jIG3j7k8=; b=e0K5g7Zg9xIlKGenzY3OYnLotX
	ztD2Ofi0vtn83Tbc7eJTDG1+ZxJ8zKCy7+wZ6OHbhVBhQvw4TMuaYWHG9etQJvtLXbIfnk2A/JI09
	J0/jfflOrmTEk86Zcrpf6pmdMKU0/j608mUjYYWUEvEdXfVuDk1jveK7IPf158ZcMs5c=;
Received: from guillaum by bender.morinfr.org with local (Exim 4.98.2)
	(envelope-from <guillaume@morinfr.org>)
	id 1wzePB-00000000olk-45Wi;
	Thu, 27 Aug 2026 20:00:50 +0200
Date: Thu, 27 Aug 2026 20:00:49 +0200
From: Guillaume Morin <guillaume@morinfr.org>
To: linux-mm@kvack.org
Cc: leitao@debian.org, rppt@kernel.org
Subject: [PATCH] selftests/mm: hugetlb_madv_vs_map: add underflow test
Message-ID: <apB7UWfLAzCvSCss@bender.morinfr.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7523F40010
X-Stat-Signature: 45mrkyw871ttspx11ogu5aupzmwdrc84
X-HE-Tag: 1787853654-276836
X-HE-Meta: U2FsdGVkX18ygVM8YFDwJbtMkhzbDWHTdNcVOG+UG56bE6HrPq76++84R6FWWb0yFfZm98/rTkZO6xiGeJ8rMSOAvIBQUtcrogmQSyPu4KRxww+//h+8u/OcEXxH7BBCUqdRPnVQaeC2yv1BCZmt9JR6sDaiCVt5ZC61PPtbIfcLw2rLht6oMzvF0XYZpf4pgHE7E12nKCtKHabQm2KofrMtpy8OlB00xuhpLqIgebiUDcbaJ/KLe3+DKMfYgWxq1jABTukCeMBGO59UqgIxsoOLy1QjgRQwuRngH/mycBxLpzA3zF0XjPJbBCv/EFkiBOSY4PIbJZy1MUW+SZhGyMkKvT5pO0aAssM4F9dRZk8AObuxn0tzNwUuaOi+V4B1pRYXN9Ia9g0WG6GF/E+pkl/0v2g4gUOfk8dhQWhnlK5CrMozSahlh9U7dvVJiMWPNhPndV/eYZGrzjv7SxgnR+exM4cGJ/9dHl4S2EII4jb+bdDZP/5pKoLb0qYTuY434QZXN11Q2TAXu3EThIG7Vi4IeKSby1XeD+7X25g1l4Gw3VuN5JNlwLbpAp2RiAHoiBPl5+XpkSicheq8zaCNzDTQvJQdZhYj07rOZiCTZHlPS4DPqlk5uGPYezsQ34IBcfuaBLy9SSCuQwbu1IINbCcZ6NdIfebnC1wZRglia0Vjn0XetIFd8SirqAFO+IEStNqbbOWvj5LdeY9jTpAAgBPowPesCVrFx2e6wYafYv3RfenGlnhZ2GfcQ6cQySTnS/2fFTVAmgdNHI9t9CnA+BelkPxCXAG6mMaWBuL8WeI7EljF7o0oueb9jVdRXaFsOLoG/BT90hm+bk3/hcwwNaCMB+9efeNSguCgi3c1lh61JFL5jLEZiKocoKqfaFy1zaPaKmoAQPxgoaWeaMgshvxsjS69Ti6q3u4stPCt59KC5AlkCY3fdfQ1/CNorb5GBxNek5lNklo1lFDZ2Wd
 FHbt4E4d
 ZH0djah+ao6rFQrqPfB+PdAW9DMB4LvmtztoHufhnb6+9UI7MnA2aL862omYrlgJ/IohMHEkvEY44pMri1mWRXLS7qQbFiYowLwszsVV852Pl2MDbUHfbEFsnJVBN8erO/MMN9Fm1UB+S9feASY8EILn1hGND+5CNWtXUn0NXV3oIWj4fGHoKcMTd9YdFS6uKZwgpfsz2bKArHi5tac0EofeaCrppeQjoDFBvexH7xKUMB5zFuZzKCXVnTrYwjJMFKSEkmzgKcu2MgkeiDbz/IbRRqjXyZdXflokTVlH3rBE9Gqvft/o8VL0+/elpYrXXtSKx9nktbIsaiZqWh6icuFUP+hGWBzmHLhkVDh80pJsPuYXCDzw9KGE9xKM+u89SD+9Gif6BETt7p7hTJJcTT5ya9LiCwiRC0a0s
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
 .../testing/selftests/mm/hugepage_settings.c  |  9 ++
 .../testing/selftests/mm/hugepage_settings.h  |  1 +
 .../selftests/mm/hugetlb_madv_vs_map.c        | 84 ++++++++++++++++++-
 3 files changed, 93 insertions(+), 1 deletion(-)

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
index f94549efcc6f..6aa42f064279 100644
--- a/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
+++ b/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
@@ -15,13 +15,20 @@
  *
  *  Touching the first page after thread3's allocation will raise a SIGBUS
  *
+ *  We setup a 2nd test where we create a child process, then unmap the page in
+ *  the parent while the child waits and verify that there is no underflow
+ *  of the reserved count.
+ *
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
@@ -86,7 +93,7 @@ int main(void)
 	int max = 10;
 
 	ksft_print_header();
-	ksft_set_plan(1);
+	ksft_set_plan(3);
 
 	if (!hugetlb_setup_default_exact(1))
 		ksft_exit_skip("This test needs one and only one page to execute. Got %lu\n",
@@ -120,5 +127,80 @@ int main(void)
 	}
 
 	ksft_test_result_pass("No unexpected huge page allocations\n");
+	huge_ptr = mmap(NULL, mmap_size, PROT_READ | PROT_WRITE,
+			MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB, -1, 0);
+
+	if ((unsigned long)huge_ptr == -1)
+		ksft_exit_fail_msg("Failed to allocate huge page\n");
+
+	{
+		pid_t pid;
+		int pipe_fds[2];
+		unsigned long nr_reserved = 0;
+
+		nr_reserved = hugetlb_nr_resv_pages(default_huge_page_size());
+		if (nr_reserved != 1)
+			ksft_exit_fail_msg("Unexpected number of reserved pages: %lu, expected 1\n",
+					   nr_reserved);
+
+		/* Force the fault to ensure the reservation is consumed */
+		*huge_ptr = 0;
+		nr_reserved = hugetlb_nr_resv_pages(default_huge_page_size());
+		if (nr_reserved != 0)
+			ksft_exit_fail_msg("Unexpected number of reserved pages: %lu, expected 0\n",
+					   nr_reserved);
+
+		if (pipe(pipe_fds) != 0)
+			ksft_exit_fail_msg("pipe failed");
+
+		pid = fork();
+		if (pid < 0)
+			ksft_exit_fail_msg("fork failed");
+
+		if (pid == 0) {
+			/* Child: Simply wait for the parent */
+			char b;
+
+			close(pipe_fds[1]);
+			if (read(pipe_fds[0], &b, 1) < 0)
+				ksft_exit_fail_msg("child read failed");
+			return 0;
+		}
+
+		/* Parent */
+		close(pipe_fds[0]);
+
+		/* First unmap, this will close the vma */
+		if (munmap(huge_ptr, mmap_size) != 0) {
+			kill(pid, SIGKILL);
+			ksft_exit_fail_msg("munmap failed");
+		}
+
+		nr_reserved = hugetlb_nr_resv_pages(default_huge_page_size());
+		if (nr_reserved == ULONG_MAX) {
+			ksft_test_result_fail("After the munmap, HugePages_Rsvd underflowed!\n");
+		} else if (nr_reserved == 0) {
+			ksft_test_result_pass("Underflow not present!\n");
+		} else {
+			ksft_exit_fail_msg("Unexpected HugePages_Rsvd=%ld after munmap, should be 0 or -1.  Repeat the test\n",
+					   nr_reserved);
+		}
+		/* Make the child exit, this should restore HugePages_Rsvd to 0 */
+		if (write(pipe_fds[1], &nr_reserved, 1) < 0) {
+			kill(pid, SIGKILL);
+			ksft_exit_fail_msg("write failed");
+		}
+		close(pipe_fds[1]);
+		if (waitpid(pid, NULL, 0) <= 0)
+			ksft_exit_fail_msg("write failed");
+
+		nr_reserved = hugetlb_nr_resv_pages(default_huge_page_size());
+		if (nr_reserved == 0) {
+			ksft_test_result_pass("After the child dies, HugePages_Rsvd is properly set to 0\n");
+		} else {
+			ksft_exit_fail_msg("Unexpected HugePages_Rsvd=%ld after the child termination munmap, should be 0 or -1.  Repeat the test\n",
+					   nr_reserved);
+		}
+	}
 	ksft_finished();
 }
-- 
2.39.1

-- 
Guillaume Morin <guillaume@morinfr.org>

