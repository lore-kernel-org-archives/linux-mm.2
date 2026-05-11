Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CBD7CD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:31:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A64C66B00F9; Mon, 11 May 2026 12:31:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3CB86B00FB; Mon, 11 May 2026 12:31:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97A126B00FC; Mon, 11 May 2026 12:31:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 885DD6B00F9
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:31:03 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5500E1C00C4
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:31:03 +0000 (UTC)
X-FDA: 84755678406.03.666F01E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id A65D2C000B
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:31:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IRn3vCNd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778517061; a=rsa-sha256;
	cv=none;
	b=sSROmYjax3OPvNoW4waySk3qEBaxh9p0tmiomnGYthE5UdOArwlxR5EqKnCcnrXZI91DAl
	qmU4111sPPKXFUDS+4o+nPvRft7UUiq0F+Z0SCXJo+BIw/XINa1Yivi8XSWKRkNA0B7LTl
	+KjWHvE7F5R1kIpHGqBNGaKJGqCWyow=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IRn3vCNd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778517061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tLEx+YFF5jmJxaWCQa/uL+mBqa5LwCvpdK/avKxIxzA=;
	b=D51dUAKK6IszXJZ1xTkHejsMuz/amKfi/tC4gUCzp2J60dFc7IdiLEKOXc+3fzmkf0/3KM
	2Xv+JrcPsLnWTG/NKBg8feTdaQTorHOpY7YSL46Nw9nvpiSWAfwmOWdF/2jZqv5s9eqxxc
	CR+QIE927ueoqBZc6BVHkYxFb4HiE4Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 38DBC60121;
	Mon, 11 May 2026 16:31:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD8C1C2BCB0;
	Mon, 11 May 2026 16:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778517060;
	bh=SJOiJDMA/vSNA+8ti7tULY2I5EV4K1CG/V/2/5w4uMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IRn3vCNdAsI/Bw7EGGIqZJ5+IdCLw5z7fyqwmjKIlgVIytOqJ6SeBHYZEEbQdzc7J
	 5RBzDpsx2PPOJUCOy8uIdb/2fhphC0lKT7GUTA/0QKt6OZ7jcvieKHODvoAANNVJs6
	 MCu3SEMm3HBgjq/goIXUfC5gHaKNQqGy6apwi/g8UcR9zqj8F3Lcr4WVIhKpJt57iW
	 2Yk2knkiTgrDXdgH1nGiUcmOCZ6LySrZcbvsz+jxkHAO91c+v0p48MkxG+WVxuQKdZ
	 ITbK+q7onYDHRVxT4vOswA3woJe6rxAYyKDLqYRgANqaAUFSkSLyYBmBChScrwHBQX
	 iz1Mt5c6AqSEA==
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
	Li Wang <li.wang@linux.dev>,
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
Subject: [PATCH v4 20/55] selftests/mm: uffd-unit-tests: use kselftest framework
Date: Mon, 11 May 2026 19:28:04 +0300
Message-ID: <20260511162840.375890-21-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511162840.375890-1-rppt@kernel.org>
References: <20260511162840.375890-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: m8hqkoyjikaq8979dznd9wqdycohuxwe
X-Rspam-User: 
X-Rspamd-Queue-Id: A65D2C000B
X-Rspamd-Server: rspam07
X-HE-Tag: 1778517061-429657
X-HE-Meta: U2FsdGVkX19OxTtHb3S5qm9HPEv+2yhKTbPeVPiVFqHxEkjKG7bFpK2oNS0RKpOvNoH1oA/+897THPfhHf6UodPVC7liefApxESxHBB1ZUL5Rao+Q7bz4AT2q3oNWfVnEPJJKTLzng89AU03srhCN8Tq67ckdsObsPcvGrnzJs1ZHug8DD4K/U3mXgYEO5LF4UZhFEfWYdq76NUGFLUUTccf0A5NbguKGlskMI6RrdsrVJ6zsRXN9YiOERRxb0527qMhHus35PvbXta4xs1AlHJ0ZBzvCpLSkX86TGNZa6oEMpp1rlKwMhRtNxJ9jVQJsFc4vsliBujhPIuKlNBvMpqC89KOboPTqW18OpJa1ov5krxsNEUJiZ5UazfQvxisaPPiEM4yoMJAhF/a1f/ks36pWGjvoUIzYyWf8NlyVeNRMZoNl5P5cC4V7B8feAqNrEV+TRen/v1UJlrpDrHi6/vI1xxn2eoFwEojoCoPKElVGbAggh90GT6omYx3M/lEN+hxoO6i4Ykw4rEFUCnmhGCjHDjnblr5xk8hfvBQh3JdqFgAea61aTe2s8Q00/AVgbcHDt92GCSSad0Rz3L50pjlA8wwmvy5Xl3VXVOxmkv1tbbvC8l5bovZy6OlCdjSeXsLXhYlGbZL0K0iM96Js2IP95WyoajeaCUir1Z4d5u7WL2wco6z4kD62MGMREW5UNmYHIhzrMmHl6wRYurvIpKTSWTNOx+sjwi3t8FsJU7HeVxIUtrXMB7BpLWwqt1kLcYckg3XbvkPgUhSwslBZbTus6MvmE26en3eK0Yy8Z6lIXU4gZAxPKYM6DsrlLGPKyxKUyEEgM3EYzGYUbkQkVAV29RGJAcNjCBIbfvS5kEpBDWfz38TaoFQ2X3EdCje5Mhq0BDlTErrci+Xcd7l94AbeIS8RTr6SXg/D7lv15akbA+bRUeQv8KUttHvcKjMk2s91x/5t3xCeLjTitN
 rwBHrL3z
 nCz0Zq6XOakwdvAfvpNeAbmUa9676yfkMg/ocet29CEi88GBONoACemTsVaPQB5fglzhCag50yz/AtTeMaJWh/geWmLh9xtscscC8O1ZDgiZj5VXh8/v5qSfwrSJ9F3idZ6HRHUknCvf+Xz56Mxq8B10c6Dj7WeuK8Ug6I+3IFocRKP8hdeeS9a+/eR1hUnlsf0yQKm1iQiyTZMjoBCxd+pMwROtsftMdD5cH1nAcIybo8ogKUYWFu2dboIgzkN5uQ9T8pIu3phCLRx8rP/0LrI2ptA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Convert uffd-unit-tests to use kselftest framework for reporting and
tracking successful and failing runs.

Reviewed-by: Donet Tom <donettom@linux.ibm.com>

Reviewed-by: Mark Brown <broonie@kernel.org>
Tested-by: Luiz Capitulino <luizcap@redhat.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/uffd-unit-tests.c | 105 +++++++++----------
 1 file changed, 52 insertions(+), 53 deletions(-)

diff --git a/tools/testing/selftests/mm/uffd-unit-tests.c b/tools/testing/selftests/mm/uffd-unit-tests.c
index 6f5e404a446c..db7c26835487 100644
--- a/tools/testing/selftests/mm/uffd-unit-tests.c
+++ b/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -86,47 +86,28 @@ typedef struct {
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
 
-#define  uffd_test_fail(...)  do {		\
-		printf("failed [reason: ");	\
-		printf(__VA_ARGS__);		\
-		printf("]\n");			\
-		ksft_inc_fail_cnt();		\
+#define  uffd_test_fail(fmt, ...)  do {					\
+		ksft_print_msg("failed reason: [" fmt "]\n", ##__VA_ARGS__); \
+		ksft_test_result_fail("%s\n", current_test);		\
 	} while (0)
 
 static void uffd_test_skip(const char *message)
 {
-	printf("skipped [reason: %s]\n", message);
-	ksft_inc_xskip_cnt();
+	ksft_test_result_skip("%s (%s)\n", current_test, message);
 }
 
-/*
- * Returns 1 if specific userfaultfd supported, 0 otherwise.  Note, we'll
- * return 1 even if some test failed as long as uffd supported, because in
- * that case we still want to proceed with the rest uffd unit tests.
- */
-static int test_uffd_api(bool use_dev)
+static void test_uffd_api(bool use_dev)
 {
 	struct uffdio_api uffdio_api;
 	int uffd;
@@ -140,7 +121,7 @@ static int test_uffd_api(bool use_dev)
 		uffd = uffd_open_sys(UFFD_FLAGS);
 	if (uffd < 0) {
 		uffd_test_skip("cannot open userfaultfd handle");
-		return 0;
+		return;
 	}
 
 	/* Test wrong UFFD_API */
@@ -177,8 +158,6 @@ static int test_uffd_api(bool use_dev)
 	uffd_test_pass();
 out:
 	close(uffd);
-	/* We have a valid uffd handle */
-	return 1;
 }
 
 
@@ -1701,6 +1680,26 @@ static void usage(const char *prog)
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
@@ -1711,8 +1710,7 @@ int main(int argc, char *argv[])
 	mem_type_t *mem_type;
 	uffd_test_args_t args;
 	const char *errmsg;
-	int has_uffd, opt;
-	int i, j;
+	int i, j, opt;
 
 	while ((opt = getopt(argc, argv, "f:hl")) != -1) {
 		switch (opt) {
@@ -1730,24 +1728,28 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	if (!test_filter && !list_only) {
-		has_uffd = test_uffd_api(false);
-		has_uffd |= test_uffd_api(true);
-
-		if (!has_uffd) {
-			printf("Userfaultfd not supported or unprivileged, skip all tests\n");
-			exit(KSFT_SKIP);
+	if (list_only) {
+		for (i = 0; i < n_tests; i++) {
+			test = &uffd_tests[i];
+			if (test_filter && !strstr(test->name, test_filter))
+				continue;
+			printf("%s\n", test->name);
 		}
+		return KSFT_PASS;
+	}
+
+	ksft_print_header();
+	ksft_set_plan(uffd_count_tests(n_tests, n_mems, test_filter));
+
+	if (!test_filter) {
+		test_uffd_api(false);
+		test_uffd_api(true);
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
 
@@ -1758,6 +1760,10 @@ int main(int argc, char *argv[])
 			uffd_test_ops = mem_type->mem_ops;
 			uffd_test_case_ops = test->test_case_ops;
 
+			if (!(test->mem_targets & mem_type->mem_flag))
+				continue;
+
+			uffd_test_start("%s on %s", test->name, mem_type->name);
 			if (mem_type->mem_flag & (MEM_HUGETLB_PRIVATE | MEM_HUGETLB)) {
 				gopts.page_size = default_huge_page_size();
 				if (gopts.page_size == 0) {
@@ -1777,10 +1783,6 @@ int main(int argc, char *argv[])
 			/* Initialize test arguments */
 			args.mem_type = mem_type;
 
-			if (!(test->mem_targets & mem_type->mem_flag))
-				continue;
-
-			uffd_test_start("%s on %s", test->name, mem_type->name);
 			if (!uffd_feature_supported(test)) {
 				uffd_test_skip("feature missing");
 				continue;
@@ -1794,10 +1796,7 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	if (!list_only)
-		uffd_test_report();
-
-	return ksft_get_fail_cnt() ? KSFT_FAIL : KSFT_PASS;
+	ksft_finished();
 }
 
 #else /* __NR_userfaultfd */
@@ -1806,8 +1805,8 @@ int main(int argc, char *argv[])
 
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


