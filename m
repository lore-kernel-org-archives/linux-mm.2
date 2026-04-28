Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8748FF886D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 20:44:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B5C76B00B8; Tue, 28 Apr 2026 16:44:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18CA06B00BA; Tue, 28 Apr 2026 16:44:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A2906B00BB; Tue, 28 Apr 2026 16:44:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EA4AB6B00B8
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:44:58 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B59B2A03F5
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:44:58 +0000 (UTC)
X-FDA: 84709143876.10.251D1C3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2D23C140003
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:44:57 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qwT0gCvv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777409097; a=rsa-sha256;
	cv=none;
	b=u72NqQLAOYw8VKVBAjjr3+1wXlsE+Rkyfp+JEoiK4MriGbrUfF08G9MlY9uF5fBIHgOqvN
	XfuwjTk1aPNUHr8NnOtAE5gJ/DWBNcmTMmL67Doe+nbjHFgvtuzDhgDw9UZIN3862+8iFL
	v9XC1pn7K3MwPsVjDxvkqUmJZv82wTk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qwT0gCvv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777409097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tlYGXpWG+dZ16WBzWZXpQPpCZtdBjN52nfSoxsynEZU=;
	b=IwT2yaiUgRJixTrYkFXSniyT13Gyo7ZPDhzUrUDnTF72OMmHOgMIefmL85CQPqvO6LUPtj
	+kiW036ywQY63ZRhkijRKemlgbUA3hKw2n3uGz1TGp01HOa4H+cQY6Quiikclb5s2RE0D9
	c9TzCwKxwRd34I37V0wkZv3R9WfT4Z4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id ABFF561119;
	Tue, 28 Apr 2026 20:44:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B217C2BCAF;
	Tue, 28 Apr 2026 20:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777409096;
	bh=/VHYsNQ9mu4gXMtGoRr+26k5iHfnClRvZmbB31xolG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qwT0gCvvMjOaBS8YabVlq3OHeNm/YlUpXm0dEeuGiuiSqiAexEePOfSHcvgZ2sBwr
	 DIyQCgiDlQWOhId1P0q85ZdNOyExDIseXnptwi6k7vPuQwqaQFlHUVDdBuTuWdOkrh
	 1CqcHgcz3kEVidEEZ7gQdjGPZxEWIhb562Z3z8NnuXpcRYzBdQ4dvkVBk3SA2KIpjm
	 NW9BnEWKC88l30mDHw6ziArdYDUyIkiGAxOil9cbMxhNbs047Cl/KRhVY+OtYBwjqw
	 aSO4XL6a1YrvtcHMgozdNT9orcoTZHe2Mxl153/c/RSIIvea0H78jznr2wizySp7Op
	 13ab7tzEm6sew==
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
	Luiz Capitulino <luizcap@redhat.com>,
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
Subject: [PATCH v3 19/54] selftests/mm: uffd-unit-tests: use kselftest framework
Date: Tue, 28 Apr 2026 23:42:05 +0300
Message-ID: <20260428204240.1924129-20-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428204240.1924129-1-rppt@kernel.org>
References: <20260428204240.1924129-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6jk1uinc66iqq3nwwcjo76uez957x6bf
X-Rspam-User: 
X-Rspamd-Queue-Id: 2D23C140003
X-Rspamd-Server: rspam07
X-HE-Tag: 1777409097-378857
X-HE-Meta: U2FsdGVkX1/MdakP5QwPI20+PS+HX9pUGTWs3o+wIOMJYslT1Pqd6C/9FzS1mSmqMdm87dJ3l3VhlP6F5SSI9xXYMd6KFPuwVK8hN8oL4SKaVdJrPLxXaH9Ij4+6+dynWsnQ4VcarRChyH3b5dZljqV4RSYpynp8F/L+u/GNZIgrdvVQfZY10uRe5BCpyN61bq3CgUmfrVybExmsn03nUBcP8idqgS1yCInV1g6yAxakLETxMJcvmPXdaWbgxQPBNZMPGMMCsUWHU4sAof/5G184rEBCDKJjPrBgYndn2X5I63AnlHqJ0sn5ZUmGU3ZAccs16dR2czn8A+VqDhdIZMM0GSaYlCiV+vh/bkNVuOIwldrzoWMD7pL93HYeeWk2Q+mzDR9S8wAcgBeQK0tvH9RQumA7hdW43D47BPjWAHa6rYO+tAAPcoZlq5wA6vBunsutBuqup8uuqI1+qzTakJH++4ORznmlxU4U99wMhE8ldgfOCdFbx15CioeoJ7G4FvaI/XjbZGUCgucuNtvuz39upBcsecSgZxSqkf8Mw3WkyP9bWnrLZcPkDWqhfDYZUnwYOHd6J+iK/mHtLZBzgeXD9fw4l1W28zgYKfl9W0zx2I9XiyO4NlRqVKwCNzUZt7kU4UYH59cl4h6+PHufJ91J8oVprfF7q28irMGartXaPY2VjNeyl1COlwWsNS5Sje05PG7RKk7NoKLA/HHDDVL/rQ4t9tqsX/P3zSDD9wvIdTYUvRXmsHA+0NKBUF4wzhXbKkPluwzUrpsn4Yy4VhArq9F22tY8ovhld2Yo0PxnT9zCcWQh8OftPoGWVkp5SGGLPCwAx30ZmbG13nOLU6vCKyfTEO70HuwNNTJywa5Gzm/elGE6DC4R8sVw+IOUdmrwgC+g7QrQvLM7vw/i3+q/XrbjqXT1YN+PhyDXLnHbJIY2RTfPK50Ocnh5PKG2R8zbpoWpa+SpUKTy1jP
 H9BQIBhn
 h6ilfElOEUHJ6eKBYpobpgQnmHWGsMzDvV/yUR4K2O8e9j8/JNS02em1RXBcbbnTr17HxT9hS2VQmxRPM1Cur9fb6PT2fxEcdMMq6BAuq0N2rQbZ/KUNlz9Ad1+lSSPuQuHhkQXQGf/aJi3aed/Sdb18XK96mRRWj6sNkZP/+w9kijFTrbTE/R8P/3WYbIgjYJnKseh3lAQwjpiZT7q2g/qz3E8x1Uw3UgzMN3bjYhhJnzgibpBaUcu9PJMe9pH9z67gO
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

Reviewed-by: Mark Brown <broonie@kernel.org>
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


