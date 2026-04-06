Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E87F7F46C46
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 14:20:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EEC46B00CD; Mon,  6 Apr 2026 10:20:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C6006B00CF; Mon,  6 Apr 2026 10:20:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 502E96B00D0; Mon,  6 Apr 2026 10:20:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3F7106B00CD
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 10:20:37 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0267DB9675
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:20:36 +0000 (UTC)
X-FDA: 84628341714.04.2D93C39
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 48C7AA000B
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:20:35 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PerRaUmN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775485235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aZEoU0IwQOpsi82G7gijaBWYu7kGWrJYGFpJPct+BF4=;
	b=t4MIRbA/1bPKH5P1gcakdWgXI79/dvr0nxx83JR+LA6leNBDxDOtDR+s+MvO44VYEJNBRM
	6wygM2fgis8r2vjG6KlsBHxjp+knXDvpS9mr6VCjqf3X7lnawBKtr2UcgGts585ghX0zeU
	1tECFGHInOxs5i7MSmObOVtAOBrMcXE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775485235; a=rsa-sha256;
	cv=none;
	b=OzVNa6n1xnWtn0YYnhsiWXYI88J062HovHjjL/IM4eadfx8CtvkLYDIgoDLc1z5f5rYQxF
	8xSxe8JEODGCSm3568nxEThsNLV9pqo0ACfjQGbx/Qn5dVFqfdhnIWXPj/HUZqcBmkAlRX
	OGQT0AwQq1w33pvTSXHE1ZeBvWK5Lvs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PerRaUmN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7114741970;
	Mon,  6 Apr 2026 14:20:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 111AEC4CEF7;
	Mon,  6 Apr 2026 14:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775485234;
	bh=t2OQ6d8PPidPjQSh+RBxS6XeDUdzwdvT/+uZ5YR7P1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PerRaUmNcenVs2kzy22EHE/xFyIZwEzUDa1Zc13pyy/WgJql0Paa5YP/Q1j5H6faf
	 7p7L5ORCcBCSrk88imeHqzTuRlS2vApISz4T1mcUcFPniOhQZ5pncVHH+zQh1mdhah
	 j2MAgPwRTkjMTpLtnKr/yAJmgu4KAghF8m7uEnXsFf/IMNhlK+F7g1flrle1HAdm//
	 dAVvKFzuqni+kvgbbcXABmVRJY7aU0ygebUk55e4N8Zpx+8cFs03shLk/ct43++OhN
	 9SilwDltho/6//gxDNOaWeTjLOvXXjXmcpCrVwlPfhvyN6RgHYREd7BGVKjBtY4WjD
	 X+oW/pOU07o0w==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
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
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 29/53] selftests/mm: compaction_test: use HugeTLB helpers ...
Date: Mon,  6 Apr 2026 17:17:11 +0300
Message-ID: <20260406141735.2179309-30-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260406141735.2179309-1-rppt@kernel.org>
References: <20260406141735.2179309-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 48C7AA000B
X-Stat-Signature: qu9fgeo11n8fbyisxgf8wim9jiiu7w89
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775485235-905968
X-HE-Meta: U2FsdGVkX19kC3LkDsicla5E2wfMLZjIgbRWx/QanEXfTM/g6E13pU/v8iRDsfq9RjNPjXuPgNHB9YVeBTMLC83kqv5fzrLmVWsbxslkArp9jMNBy+5+Lm2mpcmrCetD8Y1fgv2PJA36d0vlOVkfWGN5Zgi4e9Sf/kmpBeUXdqitTRbqCDjnxbOwL3PyoeJBjlmRAdo7G395/Lz42A9KA3jdumZXxoffRP0ON18aRPfAe8aodkRbbEa3aVpQfa4USFX4T97peiITq4EhtKKtghdCGo0rNeBSwAOUd2SURYMS4V4C3U3rKBDiS/RZuLT/e2xnR4r1OjraZzFUoWcFw/yZPGPw8cM2RRMq7aISBjc1mCebBKTZkJ3/7oZA/3R5dnf6oQMnfp6bFOtv0Caa+dlfPhFhAEcyUvb8HTPeYVwA+U9MKLgO8iJ3rACy7ZHnd5xxIJD38Z+SZZK5y5tKcE2xIdtSbZDowrO0dZztuOBPsTjIs0FAoLgZg8lhU0rFKc0oCn7Z/h9Zkb99zOsnivrMCrIJTCeNumsen0hG2S33VY3Wyy9O43ZejZCexm5dTZwz7dpZGrDSAc1+T9orzn8iXPS707cuQoCYZLFnpG/MFJNKSwTJ61DaGtY27+EW39xtdCqOJ8ysGDkz0FDaIckIi9w739bJJd4iWtnPLXPIpW0FTgmGLE0LG3QfNzDzM0bn1cybLcdLhUz4UgEwV9aj9+CCuBybSnaA/qm8j2skoKa3ubJqLLDtflbTOWWu24s808+rV+JZa79FfIfqCNBSyBtsIPpl3lVZln/EfIUihM+8dI86nQ1t6t9yDvlDm0Yrs1wQfIhkbiXoaIa4FL8dEQBK+CvOG+TVrcs7f1DKN5tL/TVnn+j9n56TDvAnPVEOBVAM4UeMuMfE5CEtsKo+JKkyTSwVeXrneTaY+sx2gmqTYAB0I7g1m35OfBdiltl7VLrxcfqJVT3CG0t
 d1I788gW
 YOlsVuGIlohw7ICs1ZwqCX9qqPs4bmzCeB302VMhA1IN8wIDiqr+ZlNUhQGZolmh3fIyHXd9t+yMSbauPiCdKszprkoj5OCDxT8LD4LVa05STxPnu4oCC0GyyOiyBd/vXz7qV9+e5O7Ai2MxmFOoWosiLKuYgXZGKmpac3Hxaqyt57mrviZDHZ33ca8YR1yaT0U1Ao+rs4pFLxlqeYUDx9joA1e5tWgloYekXtEWPgVfZTdY8BskzcmCkuKjub1NMygDVU2q9F0vY26n4FqRjLJUKNcDLhVN/TeJk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

... instead of open coded access of HugeTLB parameters via /proc.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/compaction_test.c | 113 +++----------------
 1 file changed, 17 insertions(+), 96 deletions(-)

diff --git a/tools/testing/selftests/mm/compaction_test.c b/tools/testing/selftests/mm/compaction_test.c
index 30209c40b697..962a50c3d66f 100644
--- a/tools/testing/selftests/mm/compaction_test.c
+++ b/tools/testing/selftests/mm/compaction_test.c
@@ -17,6 +17,7 @@
 #include <string.h>
 
 #include "kselftest.h"
+#include "hugepage_settings.h"
 
 #define MAP_SIZE_MB	100
 #define MAP_SIZE	(MAP_SIZE_MB * 1024 * 1024)
@@ -82,75 +83,33 @@ int prereq(void)
 	return -1;
 }
 
-int check_compaction(unsigned long mem_free, unsigned long hugepage_size,
-		     unsigned long initial_nr_hugepages)
+int check_compaction(unsigned long mem_free, unsigned long hugepage_size)
 {
-	unsigned long nr_hugepages_ul;
-	int fd, ret = -1;
+	unsigned long nr_hugepages;
 	int compaction_index = 0;
-	char nr_hugepages[20] = {0};
-	char init_nr_hugepages[24] = {0};
-	char target_nr_hugepages[24] = {0};
-	int slen;
-
-	snprintf(init_nr_hugepages, sizeof(init_nr_hugepages),
-		 "%lu", initial_nr_hugepages);
+	int ret = -1;
 
 	/* We want to test with 80% of available memory. Else, OOM killer comes
 	   in to play */
 	mem_free = mem_free * 0.8;
 
-	fd = open("/proc/sys/vm/nr_hugepages", O_RDWR | O_NONBLOCK);
-	if (fd < 0) {
-		ksft_print_msg("Failed to open /proc/sys/vm/nr_hugepages: %s\n",
-			       strerror(errno));
-		ret = -1;
-		goto out;
-	}
-
 	/*
 	 * Request huge pages for about half of the free memory. The Kernel
 	 * will allocate as much as it can, and we expect it will get at least 1/3
 	 */
-	nr_hugepages_ul = mem_free / hugepage_size / 2;
-	snprintf(target_nr_hugepages, sizeof(target_nr_hugepages),
-		 "%lu", nr_hugepages_ul);
-
-	slen = strlen(target_nr_hugepages);
-	if (write(fd, target_nr_hugepages, slen) != slen) {
-		ksft_print_msg("Failed to write %lu to /proc/sys/vm/nr_hugepages: %s\n",
-			       nr_hugepages_ul, strerror(errno));
-		goto close_fd;
-	}
-
-	lseek(fd, 0, SEEK_SET);
-
-	if (read(fd, nr_hugepages, sizeof(nr_hugepages)) <= 0) {
-		ksft_print_msg("Failed to re-read from /proc/sys/vm/nr_hugepages: %s\n",
-			       strerror(errno));
-		goto close_fd;
-	}
+	nr_hugepages = mem_free / hugepage_size / 2;
+	hugetlb_set_nr_default_pages(nr_hugepages);
 
 	/* We should have been able to request at least 1/3 rd of the memory in
 	   huge pages */
-	nr_hugepages_ul = strtoul(nr_hugepages, NULL, 10);
-	if (!nr_hugepages_ul) {
+	nr_hugepages = hugetlb_nr_default_pages();
+	if (!nr_hugepages) {
 		ksft_print_msg("ERROR: No memory is available as huge pages\n");
 		goto close_fd;
 	}
-	compaction_index = mem_free/(nr_hugepages_ul * hugepage_size);
-
-	lseek(fd, 0, SEEK_SET);
-
-	if (write(fd, init_nr_hugepages, strlen(init_nr_hugepages))
-	    != strlen(init_nr_hugepages)) {
-		ksft_print_msg("Failed to write value to /proc/sys/vm/nr_hugepages: %s\n",
-			       strerror(errno));
-		goto close_fd;
-	}
+	compaction_index = mem_free/(nr_hugepages * hugepage_size);
 
-	ksft_print_msg("Number of huge pages allocated = %lu\n",
-		       nr_hugepages_ul);
+	ksft_print_msg("Number of huge pages allocated = %lu\n", nr_hugepages);
 
 	if (compaction_index > 3) {
 		ksft_print_msg("ERROR: Less than 1/%d of memory is available\n"
@@ -161,48 +120,10 @@ int check_compaction(unsigned long mem_free, unsigned long hugepage_size,
 	ret = 0;
 
  close_fd:
-	close(fd);
- out:
 	ksft_test_result(ret == 0, "check_compaction\n");
 	return ret;
 }
 
-int set_zero_hugepages(unsigned long *initial_nr_hugepages)
-{
-	int fd, ret = -1;
-	char nr_hugepages[20] = {0};
-
-	fd = open("/proc/sys/vm/nr_hugepages", O_RDWR | O_NONBLOCK);
-	if (fd < 0) {
-		ksft_print_msg("Failed to open /proc/sys/vm/nr_hugepages: %s\n",
-			       strerror(errno));
-		goto out;
-	}
-	if (read(fd, nr_hugepages, sizeof(nr_hugepages)) <= 0) {
-		ksft_print_msg("Failed to read from /proc/sys/vm/nr_hugepages: %s\n",
-			       strerror(errno));
-		goto close_fd;
-	}
-
-	lseek(fd, 0, SEEK_SET);
-
-	/* Start with the initial condition of 0 huge pages */
-	if (write(fd, "0", sizeof(char)) != sizeof(char)) {
-		ksft_print_msg("Failed to write 0 to /proc/sys/vm/nr_hugepages: %s\n",
-			       strerror(errno));
-		goto close_fd;
-	}
-
-	*initial_nr_hugepages = strtoul(nr_hugepages, NULL, 10);
-	ret = 0;
-
- close_fd:
-	close(fd);
-
- out:
-	return ret;
-}
-
 int main(int argc, char **argv)
 {
 	struct rlimit lim;
@@ -212,18 +133,19 @@ int main(int argc, char **argv)
 	unsigned long mem_free = 0;
 	unsigned long hugepage_size = 0;
 	long mem_fragmentable_MB = 0;
-	unsigned long initial_nr_hugepages;
 
 	ksft_print_header();
 
 	if (prereq() || geteuid())
 		ksft_exit_skip("Prerequisites unsatisfied\n");
 
-	ksft_set_plan(1);
-
 	/* Start the test without hugepages reducing mem_free */
-	if (set_zero_hugepages(&initial_nr_hugepages))
-		ksft_exit_fail();
+	hugetlb_save_settings();
+	hugetlb_set_nr_default_pages(0);
+	if (hugetlb_nr_default_pages())
+		ksft_exit_skip("Could not reset nr_hugepages\n");
+
+	ksft_set_plan(1);
 
 	lim.rlim_cur = RLIM_INFINITY;
 	lim.rlim_max = RLIM_INFINITY;
@@ -268,8 +190,7 @@ int main(int argc, char **argv)
 		entry = entry->next;
 	}
 
-	if (check_compaction(mem_free, hugepage_size,
-			     initial_nr_hugepages) == 0)
+	if (check_compaction(mem_free, hugepage_size) == 0)
 		ksft_exit_pass();
 
 	ksft_exit_fail();
-- 
2.53.0


