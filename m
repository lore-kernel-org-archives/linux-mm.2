Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9F27C61DCB
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 14:29:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B77E96B0095; Fri, 28 Aug 2026 10:29:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B29236B0096; Fri, 28 Aug 2026 10:29:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1A6B6B0098; Fri, 28 Aug 2026 10:29:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6EC796B0095
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 10:29:22 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 028B41C1C9E
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 14:29:21 +0000 (UTC)
X-FDA: 85150910964.06.C5162FF
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2731940002
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 14:29:19 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=morinfr.org header.s=20170427 header.b=HjvMyMk1;
	spf=pass (imf01.hostedemail.com: domain of guillaume@morinfr.org designates 212.27.42.4 as permitted sender) smtp.mailfrom=guillaume@morinfr.org;
	dmarc=pass (policy=quarantine) header.from=morinfr.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787927360;
	b=2I+wg+Br/zo8QufNuc2eu4nfA0kn6IQc4W9dKMbMv9uluS1qwto+JkBSzyQYyeniErFbTp
	0WhdmPo5X569RWxcOPx6naQbKeDQe8izqVG2X0h87Z1VgRvOQhzTeEWjYV+GEJeI7hGfBo
	FjzotnN5neIp7CQLtc8gNGea2ot86Go=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787927360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=kErT8w6ahMkgn4ka2w1WDE1w6vOoaaaekm8TOYJyiFI=;
	b=MZH9GdtW7to6pSewr1OwH+6PYTON3E2ysCddCdeM2Y9kI7zlf+9D8W8duSkajvc+U60mMk
	QMLKLOpQn3JXIZUJCLwmG53cQpSETt4PmS2DCjEszL3rlYkD3DRk8HGFzvdg3ZyLpsnm4l
	qy0mmfzqxE8jqv2iS4NUOiZ4d8+/618=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=morinfr.org header.s=20170427 header.b=HjvMyMk1;
	spf=pass (imf01.hostedemail.com: domain of guillaume@morinfr.org designates 212.27.42.4 as permitted sender) smtp.mailfrom=guillaume@morinfr.org;
	dmarc=pass (policy=quarantine) header.from=morinfr.org
Received: from bender.morinfr.org (unknown [82.66.66.112])
	by smtp4-g21.free.fr (Postfix) with ESMTPS id 4102F19F57B;
	Fri, 28 Aug 2026 16:29:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=morinfr.org
	; s=20170427; h=Content-Type:MIME-Version:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=kErT8w6ahMkgn4ka2w1WDE1w6vOoaaaekm8TOYJyiFI=; b=HjvMyMk1d+FFUuheBWhHNMIzla
	H3qqPBpaOaHdlm1mlVXzvyyWSE27WjY/TrabylkMQoEswQhkxmB/pSU+t5pgQeMi4ioFzn06RVZ9F
	q2mxh0hBAbYHlHQhlfZybYR92z0fJt4z5cHqiiSBe9zqqc8Qgfhe4BSIEVQgGKaRq0Uk=;
Received: from guillaum by bender.morinfr.org with local (Exim 4.98.2)
	(envelope-from <guillaume@morinfr.org>)
	id 1wzxZz-00000001E9O-2QOS;
	Fri, 28 Aug 2026 16:29:15 +0200
Date: Fri, 28 Aug 2026 16:29:15 +0200
From: Guillaume Morin <guillaume@morinfr.org>
To: linux-mm@kvack.org
Cc: guillaume@morinfr.org, leitao@debian.org, rppt@kernel.org
Subject: [PATCH v2] selftests/mm: hugetlb_madv_vs_map: add underflow test
Message-ID: <apGbO2QM35VZ8d7a@bender.morinfr.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2731940002
X-Stat-Signature: 7qfmuj4nk11aky8hdtksda3uni7467mi
X-HE-Tag: 1787927359-450473
X-HE-Meta: U2FsdGVkX1+ZHyHteFMv/p1K5sYqdmFrOvODd9felpKHAUlOrnxzmA5w+hXKmuVc4MGKQ/mmOssAtWpfW/YIHrFgsB6Y8O7SfhpyXhOTqpzQCYOv+npGyuFkql7FNk2aXVOJTwsZd8J2K7hYHWNjDRVWS3Mybs5OQJNVjB96VfuBtNERdDW7naLl/b+hDi8Ft8Tc+gSTdTQkzATdPnWYI1O2c7Xat+E1tqfKI3nexHs/NxX0mo5wGrh0R2ofAVeWiZT0dhM578JACWhS5N1WsGxDsWY8v+/hcCo5EnWF5tz9nk+zGD2ALTRD1VCG7g9PUagjsdjQhSeIFcBx6EWKlQ85//xpvJWHnhmUrM/4zwDWbs1mC+DNEDhJa/zF3rTeMIWMjInR4HqssSvwzAjpxjD4/Htq59dQfQuzFPup/B2TG8ADTBPw7xLA9NpLEIzOBGX5OB95iHcJTdm+qO4yPIUMh3TOuRgSgQQFf2/QMQMbKQz9jK/r7dtTPr9swCE3GeQqcuOaK02xiOESBxrghVUaDdq3Ncz+2UfMJafkp4ZxmEly8Jx3+TYokhNnUOhWtt0R6IAONcNmrnn3CbNgUIAkNYK/ea4sFj5y1Wf8PUzG72hrKhTarMd0iAKBAk+BFsbfxMcnmRbWZ0Oc+mWP4d+LDQWIwUrmwhAa5wx5xZVWyEsKLvvif1ssjMt3oSK0sPchw3arq/eenFddnhpoH+GfTLSLuDQg1CQve62h5AV16HKwFkdxo+4vg1yjhnMu2r1EMJMSoAZinKuwrPESM/47HL8DlUUsz3H+4KVWDGm9tyECOpOUi44vmNWBttYF4fXaShaR1TP6VBbTxI5ZklzXiM3RcfWilDGa2yt7gCExtCzCEWJ+psKHitQqJ4crdQKz2LpHc4EwNxXqvSPp62TwoqLMtPVSNPGVmB3NFKCuYNtNxeEYQL+y4dhOxkYyRAXgEqwkwl84sta+gNN
 vVMLdV6g
 0P3rtN3YTSTk0CB9SMaKjMWDmyUIMDXD+GUuPEjby+QG/BxZlzM3nGrkGgP25w0f47W2g9cvf3Gh/ycuAWFVIvTnuPAXSssP2AUfbqHJ0MepZFjqonsvKC3hmxHD2WtVWntYkgud6fuLXSFqylqEad0Y2+Ku/xMc+kohbCMNXkYjWa6YFvROIu72Ea0ZLE49evSG+t/I4HdwHMcLtw3pT6s/axfsS9NiiXELxWEdzNvUQPxxzX4uY7WtXgs/VxR1DGXrnJmhzGEvBugKS9u1koWuoVpNnT7xRfQ2VHltBFpgp4YivbZ+EQzpDBrsCNUc6lTJyz0q9Q1iLZFiSNFb6h4kimarF/t9Fg8R1iyaWIY5DC54wDDMRZwZTwCe8xhAIapdZ1XD7hYn9A959sOs0vvvbrsbX5C1w47vq
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
v2: factor out tests

 .../testing/selftests/mm/hugepage_settings.c  |   9 ++
 .../testing/selftests/mm/hugepage_settings.h  |   1 +
 .../selftests/mm/hugetlb_madv_vs_map.c        | 107 ++++++++++++++++--
 3 files changed, 109 insertions(+), 8 deletions(-)

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
index f94549efcc6f..d1f568fed4aa 100644
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
@@ -74,7 +81,7 @@ void *map_extra(void *unused)
 	return NULL;
 }
 
-int main(void)
+void test_madv_vs_map(void)
 {
 	pthread_t thread1, thread2, thread3;
 	void *ret;
@@ -85,13 +92,6 @@ int main(void)
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
@@ -120,5 +120,96 @@ int main(void)
 	}
 
 	ksft_test_result_pass("No unexpected huge page allocations\n");
+}
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
+		ksft_exit_fail_msg("Failed to allocate huge page\n");
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
+		ksft_exit_fail_msg("pipe failed");
+
+	pid = fork();
+	if (pid < 0)
+		ksft_exit_fail_msg("fork failed");
+
+	if (pid == 0) {
+		/* Child: Simply wait for the parent */
+		char b;
+
+		close(pipe_fds[1]);
+		if (read(pipe_fds[0], &b, 1) < 0)
+			ksft_exit_fail_msg("child read failed");
+		return;
+	}
+
+	/* Parent */
+	close(pipe_fds[0]);
+
+	/* First unmap, this will close the vma */
+	if (munmap(huge_ptr, mmap_size) != 0) {
+		kill(pid, SIGKILL);
+		ksft_exit_fail_msg("munmap failed");
+	}
+
+	nr_reserved = hugetlb_nr_resv_pages(default_huge_page_size());
+	if (nr_reserved == ULONG_MAX) {
+		ksft_test_result_fail("After the munmap, HugePages_Rsvd underflowed!\n");
+	} else if (nr_reserved == 0) {
+		ksft_test_result_pass("Underflow not present!\n");
+	} else {
+		ksft_exit_fail_msg("Unexpected HugePages_Rsvd=%ld after munmap, should be 0 or -1.  Repeat the test\n",
+				   nr_reserved);
+	}
+	/* Make the child exit, this should restore HugePages_Rsvd to 0 */
+	if (write(pipe_fds[1], &nr_reserved, 1) < 0) {
+		kill(pid, SIGKILL);
+		ksft_exit_fail_msg("write failed");
+	}
+	close(pipe_fds[1]);
+	if (waitpid(pid, NULL, 0) <= 0)
+		ksft_exit_fail_msg("write failed");
+
+	nr_reserved = hugetlb_nr_resv_pages(default_huge_page_size());
+	if (nr_reserved == 0) {
+		ksft_test_result_pass("After the child dies, HugePages_Rsvd is properly set to 0\n");
+	} else {
+		ksft_exit_fail_msg("Unexpected HugePages_Rsvd=%ld after the child termination munmap, should be 0 or -1.  Repeat the test\n",
+				   nr_reserved);
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


