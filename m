Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE1CDF99C79
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 10:57:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 289DF6B0252; Sat, 18 Apr 2026 06:57:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23A586B0254; Sat, 18 Apr 2026 06:57:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 129746B0255; Sat, 18 Apr 2026 06:57:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F13BE6B0252
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 06:57:41 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B74C31B7F71
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:57:41 +0000 (UTC)
X-FDA: 84671375922.22.F7FF8AE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0C05E80005
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:57:39 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ufi7M6Q5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776509860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ba2bx1ktvSwNX6SoKIo+X6Rww3EBMJ5DTjg7QtUu3j8=;
	b=SnNtmuAShQHrwDAvymVk8a3QQWkADEOJhTYxtOh57uDcWjzxptYnk2W/yRbxDk+BvrYXk2
	2jMmq0xeMGIvcdZQamWszZhGxk+NwAI0QWqMUSDT7n3+B5IELqfWm2Z1f0chtOARHkxjsS
	U8gElPuUYiW87jkTnEdo6TMWvPl3wJw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ufi7M6Q5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776509860; a=rsa-sha256;
	cv=none;
	b=UHljdYCcNJ+U1zaIZw4QdgDmrSGldGjcxIG5GNTcrouMCbhiBOZjVTpQPSZ9FfXSJQM71r
	gUkSNjsHH1WEEME6aSwJ30qzoaCAD6JTjHZQ/1vCbOKPd1m8pcJmg+52IGZZPKqSHeUfYF
	LeqEbfFZxlROAmd3BvmQkyzLc5t6LxI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8949760139;
	Sat, 18 Apr 2026 10:57:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9816FC19424;
	Sat, 18 Apr 2026 10:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776509859;
	bh=cPpfxgOSD7bZjoMyMc7j1Oq40HSaLE9q0KNGVUUI0uM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ufi7M6Q5UMihEJFvIt9l4vG1j0uSMpYr/u1YvdIcYAYw6o3KleOA99Y5lnRrXs0w3
	 tyKVSVw7hPsg07rXCdfIXbXc5aZZ1OTKot5Nw5gaj34tnBB8ozRu2IFhNZJmOIYy+N
	 wqdd8Z9iSR+X0ecS/+1A9nPZyQLMzSPSP3sBPgH8kRwTyagvo+atcAaJGdeWOMczof
	 KHo3VkjMZc6VgWPgUoU2nJS+D/9OxQkFYCN1IcWvyQ6AL3XWV7/6Ev9+Kt7aExnwua
	 L/66XkCSQHFYuARo3ZNKBGE0T5By++7bmdXRUNiQ3q6b4SEVRiwphhtrAbbqa5bR35
	 lD4mg0ouRm+4w==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Donet Tom <donettom@linux.ibm.com>,
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
	Sarthak Sharma <sarthak.sharma@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 18/53] selftests/mm: uffd-unit-tests: use kselftest framework
Date: Sat, 18 Apr 2026 13:55:03 +0300
Message-ID: <20260418105539.1261536-19-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260418105539.1261536-1-rppt@kernel.org>
References: <20260418105539.1261536-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0C05E80005
X-Stat-Signature: x9t5i9g5obn5wgofac3j5j8mdnhbsamk
X-HE-Tag: 1776509859-46894
X-HE-Meta: U2FsdGVkX1/f50NwelDxWYSRr4YuxNK1HVErGSyfL1FemQO+nCqzpin1/jnGOFy9VDBHOlvLOG1YQiFyWyDR4dKeSDfORxAIFs67FoKm4mDFyKXL754a1obV1SJxrrhNtjybFD7EkZnLkSW5HpFPH7+8n/kncnzOQg+PNmImifJtYCUv7ug5doJzhZowMapKwrwFLjMwQOAr9hFfkqmLPu63QzQenmcIDQqWOHljPO2fz1yVQqH6m3ub/M14s2gz4JwxxqHk7yxOKU/pTcPvxu8uXZlBhuXLUwRTqXm35PN7R6/IV3q3iarToYXTj6S6sDoT0ACSXVwbflqtRr3qYd9I/lH1R5376oG9yQ2qawrxjxJbRGKykunBo82/GKwkR4v2So4EFx3I1gOESbOATqcg4vyP3koWb1vmjtTOfVuSpTInuffO4fN/t0ZLpXv3aW8jZv7EsjZKa7zCoqG1bSs2feby2bFH1j22FCih3aU7CJTf4/dvsIqpYgbjguiusELp3p2LbPItsgbJpBjiXrenTkz+KuWg5e9+OnYBPFMSlB44t00ImjSrXwtmDU2S2dgK5uL2dbMZ9E137cqzaYZtDtdiZQkHt9rw2EbsIB2r7dzoaIBXL0psj4fuqcCo8qraG7zPNyrYVyY+R1V1rYXvVK3xqUtNQ6YGey0vJ0XwmKZT8ELn5PgqgDNX2CsfjU0RQbPcNGECxER4mnXIdXnQtPYHvDlHD4wCEuMggEOCgzqkMs+MC5OXGkfKrXIvotah90clXxstOU9J/0ftVwAqy3PxokkV4iFTzQNBdSJfBRYu8s79EiAnLHUwYG+vpOJHs4dbnEENL/u6tbdkTUofznLdK19U8knJEutq7B4u4x61ex6rbR2U+Qh40qa9ttTWZqYGz77yUrWHJvFy/Kiv7DjmCxUGATbCwSFSOaxP3zrokUHQ5d3oRf9eDXOyrq48yLeQ4TPNk/Fhpyu
 fI/uu2Re
 WSOeE72vA+boHlyQ+cD4Z+HPrU/o6GYGpPs2LGVcFh53Pg7+nyrJdYvq0UD6hpdtQ2bOqqeEWiU1fH8I9pLBAbShq05xKg9NGksmD8jMgMeBmOi4O2cUZIdKSCj9T+CRvdlFSyeq9fZuSxvUrTanaBxfzjtV31TfhBYNvulZpAUGoyMTpLmpJyPuhUTurqeky8orziCcMgfIdtJhKR2mjOxs6RNsrR2HHQXloLg0Mhzi0ZR6GLesqZl8t0TCyrsK0B031
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Convert uffd-unit-tests to use kselftest framework for reporting and
tracking successful and failing runs.

Reviewed by: Donet Tom <donettom@linux.ibm.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/uffd-unit-tests.c | 79 +++++++++++---------
 1 file changed, 44 insertions(+), 35 deletions(-)

diff --git a/tools/testing/selftests/mm/uffd-unit-tests.c b/tools/testing/selftests/mm/uffd-unit-tests.c
index 6f5e404a446c..1a33db281f8a 100644
--- a/tools/testing/selftests/mm/uffd-unit-tests.c
+++ b/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -86,39 +86,24 @@ typedef struct {
 	uffd_test_case_ops_t *test_case_ops;
 } uffd_test_case_t;
 
-static void uffd_test_report(void)
-{
-	printf("Userfaults unit tests: pass=%u, skip=%u, fail=%u (total=%u)\n",
-	       ksft_get_pass_cnt(),
-	       ksft_get_xskip_cnt(),
-	       ksft_get_fail_cnt(),
-	       ksft_test_num());
-}
+static char current_test[256];
 
 static void uffd_test_pass(void)
 {
-	printf("done\n");
-	ksft_inc_pass_cnt();
+	ksft_test_result_pass("%s\n", current_test);
 }
 
 #define  uffd_test_start(...)  do {		\
-		printf("Testing ");		\
-		printf(__VA_ARGS__);		\
-		printf("... ");			\
-		fflush(stdout);			\
+		snprintf(current_test, sizeof(current_test), __VA_ARGS__); \
 	} while (0)
 
 #define  uffd_test_fail(...)  do {		\
-		printf("failed [reason: ");	\
-		printf(__VA_ARGS__);		\
-		printf("]\n");			\
-		ksft_inc_fail_cnt();		\
+		ksft_test_result_fail("%s\n", current_test);	\
 	} while (0)
 
 static void uffd_test_skip(const char *message)
 {
-	printf("skipped [reason: %s]\n", message);
-	ksft_inc_xskip_cnt();
+	ksft_test_result_skip("%s (%s)\n", current_test, message);
 }
 
 /*
@@ -1701,6 +1686,26 @@ static void usage(const char *prog)
 	exit(KSFT_FAIL);
 }
 
+static int uffd_count_tests(int n_tests, int n_mems, const char *test_filter)
+{
+	uffd_test_case_t *test;
+	int i, j, count = 0;
+
+	if (!test_filter)
+		count += 2;	/* test_uffd_api(false) + test_uffd_api(true) */
+
+	for (i = 0; i < n_tests; i++) {
+		test = &uffd_tests[i];
+		if (test_filter && !strstr(test->name, test_filter))
+			continue;
+		for (j = 0; j < n_mems; j++)
+			if (test->mem_targets & mem_types[j].mem_flag)
+				count++;
+	}
+
+	return count;
+}
+
 int main(int argc, char *argv[])
 {
 	int n_tests = sizeof(uffd_tests) / sizeof(uffd_test_case_t);
@@ -1730,24 +1735,31 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	if (!test_filter && !list_only) {
+	if (list_only) {
+		for (i = 0; i < n_tests; i++) {
+			test = &uffd_tests[i];
+			if (test_filter && !strstr(test->name, test_filter))
+				continue;
+			printf("%s\n", test->name);
+		}
+		return KSFT_PASS;
+	}
+
+	ksft_print_header();
+	ksft_set_plan(uffd_count_tests(n_tests, n_mems, test_filter));
+
+	if (!test_filter) {
 		has_uffd = test_uffd_api(false);
 		has_uffd |= test_uffd_api(true);
 
-		if (!has_uffd) {
-			printf("Userfaultfd not supported or unprivileged, skip all tests\n");
-			exit(KSFT_SKIP);
-		}
+		if (!has_uffd)
+			ksft_exit_skip("Userfaultfd not supported or unprivileged\n");
 	}
 
 	for (i = 0; i < n_tests; i++) {
 		test = &uffd_tests[i];
 		if (test_filter && !strstr(test->name, test_filter))
 			continue;
-		if (list_only) {
-			printf("%s\n", test->name);
-			continue;
-		}
 		for (j = 0; j < n_mems; j++) {
 			mem_type = &mem_types[j];
 
@@ -1794,10 +1806,7 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	if (!list_only)
-		uffd_test_report();
-
-	return ksft_get_fail_cnt() ? KSFT_FAIL : KSFT_PASS;
+	ksft_finished();
 }
 
 #else /* __NR_userfaultfd */
@@ -1806,8 +1815,8 @@ int main(int argc, char *argv[])
 
 int main(void)
 {
-	printf("Skipping %s (missing __NR_userfaultfd)\n", __file__);
-	return KSFT_SKIP;
+	ksft_print_header();
+	ksft_exit_skip("missing __NR_userfaultfd definition\n");
 }
 
 #endif /* __NR_userfaultfd */
-- 
2.53.0


