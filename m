Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CF2EF46C46
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 14:19:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E7496B00B7; Mon,  6 Apr 2026 10:19:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BB3C6B00B9; Mon,  6 Apr 2026 10:19:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F14476B00BA; Mon,  6 Apr 2026 10:19:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DFE516B00B7
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 10:19:33 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8B53313AD4F
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:19:33 +0000 (UTC)
X-FDA: 84628339026.18.8D196CB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8997C40010
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:19:31 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a1ZFD1Rq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775485171; a=rsa-sha256;
	cv=none;
	b=K5TzzYeZM+LHF3U9ksj5PMpSJeKDH759sPAHj8/qvmWBcK1Wj9J/DNjCGIZoGNDHFh8QqU
	Wui+xf7OW4sH4vMuhEnSqjIMbIQds53PAn0zpIdi7v7vU+3v1HS30U9GSZaO+Fjn2TVHhF
	gc0hh84bA3dOLOa1Xiq2syYXJFSN9iY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a1ZFD1Rq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775485171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5AIAjpvdA0fJag17W3b2lnEHupuUO6NwRt2ZnmrAYK0=;
	b=4r/afSbBzPZDbXp9CPkE0JFhGj/CKBEe9TaJ8dBP0ZL5ugiVlPL+hSzkfY8FtRFoaUJvdF
	mpXFLD21XCZWlM5Wi5Z9aRcT/XeLZX0AIMMDFenV9nRWwB/aRKdgzq/uXZp8lWCKEa9lkp
	d3EtohjwWfHpoX6wgxj/NT9bu85VFIY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1213E60123;
	Mon,  6 Apr 2026 14:19:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BAA2C4AF09;
	Mon,  6 Apr 2026 14:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775485170;
	bh=0T8XGF7c4bz/U4v3lIA/VoisDbbIrRHxeXXAjkWdKoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a1ZFD1RqsHLkHrakUsdL3Z+UmZe7qODbptg3tN1udMp/bCBRfqa43JO//7QUKbqBh
	 CBEtSS7KG2BSALrd719qlvCk5BdOLkwQ3aEzkax5vjqRlVhfGXmgvs7VhVXVcznnNf
	 QmaB9lSH6U1Ql/j34oqrXzmBtpHTUkJdhg21wUjd8RtikTnV8A/CFAP1pa5PxmFVvD
	 g7hmygAcHmusDzJlpupW9lWwRdOYrHVy4RDZsya/lBO9dZeszPU4ojHOTqiUlUV06g
	 wzTyGGZg4xz9aHKxY+Chzxs6fzIxQzo8mX8rF8IZnbi5HL7SvVumUweuj4BP4ceXUD
	 U5x2wTIiecT4Q==
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
Subject: [PATCH 18/53] selftests/mm: uffd-unit-tests: use kselftest framework
Date: Mon,  6 Apr 2026 17:17:00 +0300
Message-ID: <20260406141735.2179309-19-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260406141735.2179309-1-rppt@kernel.org>
References: <20260406141735.2179309-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yougmf38z7q3dh3td4ymonar79tbn166
X-Rspamd-Queue-Id: 8997C40010
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775485171-123496
X-HE-Meta: U2FsdGVkX18ccKeaCZ+Hg+dZWqmmK8Gm+htHvgN5n+qVyGLFCtnGlyYTuTfglcwEaXoOjAdrCDcxjacXHOxF2uiSW3R/VQ66wDJDaEDgZFq/9lQOayAci+kk+flWrXluhtEOWKSm5RbrUYuZP55sVcKS4hY8Ex5VQLH/CKLU9rdcK4okfyPe4Uz0ztRIRmcz3eCg3YQnWh4gB9aYutLfKt3u6H+7Ru/v00aDG3yMeOzCDH/yK0/rTjQlOroAqt1zU9Bvrv/n2nkDolIFSP4wcexhTB3aQMNR7WzOhpEUnYrOWCE+H99HPK7Z5BVltgLNAcgpyBtJXa7V3vz2PBYEz+3GoVe6/OhTmJASv6hRTi4Hl+ckZMTXYRYvKG4HFY+d4ZtbhbZaxlzPApy5l9nX/yGbqJtN9X/km30cPQxFsYYdslbiW5Odb6s2SJK8lVIEXA6knA1cdP+eh/NHC4eUwMdD0LpS0ATPB1+vuKbsvtMWykQakKjp5iqvOn5JIEQoutlS1iDRQ5O1zLxADG/KYn+AUc/l96ov/vf3kQOndNHXfYZAu2fLP5U5NR8TPaBwdiuFtj176+tM+KpXKmsfFlGq8Sz7SCIcXR1vNaVybYd0AQzZ5ufxW9qYRzPKAxNasCPGhFLFeoyLZh8t+PKDl3C7hsB3TJP6Ju71EoM/8jPLWTLaAVa9TxxqDpwyLjq0lAPNTqli9OV8xYXCYwWNMkNPgYT1L0NvFS+6or+tasTJYNz1FsUiOTWXBwRzWQxKVbxNLNvDQ8h0N8xEkUZeBB0stkDdlMNAwpLTOd2BbbsuWjqQMM8tdcsgZcVajMRIT1IT+rXzcG//xJLMe7C0bqlOgoC3RvPQBpFFbEZGZaXgrbJ6Oq8SJCMGlUWXMqeUiD7qhJB6GzjuG5UA4+Wd9ESTeDYFkFA+xwXEtz/dxovO21ujqvG2Kk5lztWh139DIm5tAZ6Oi4cKpHwN+yo
 dhDBOdpE
 SPrcn0r0FkTara7pyuzbK2SJBgxPjQWPRCRL7K3th7UU79y68UhlDfB2Tb3MqZSGjy3LUtPpC8iYhP+zGKxWVEWHRRxn3l3bRQgRA9ZRXZSAeuks85r72uuMN8soAumBBuoqqD62a73rewRQ5j4v6W0D1A7kzY1fPLSiXbPkIsJHL/lnj/FoCPwWex0KudNdq7iSvIBgnutF7qsx4Wo+/G4WlIlc+tKEHDuenAcwPOwijGss=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Convert uffd-unit-tests to use kselftest framework for reporting and
tracking successful and failing runs.

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


