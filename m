Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB10AFF886D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 20:44:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FACA6B00B4; Tue, 28 Apr 2026 16:44:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D26B6B00B6; Tue, 28 Apr 2026 16:44:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C1376B00B7; Tue, 28 Apr 2026 16:44:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 38A986B00B4
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:44:46 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 053081B9755
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:44:46 +0000 (UTC)
X-FDA: 84709143372.20.6253BD5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3C4902000D
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:44:43 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Id4M4KXK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777409084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YHmtwRYyvPtKhMO/+lHdKbZDPkkhjXUTRDixNEQHTMs=;
	b=Rq+ClUgvB23dlTdinPsukyEwlsRZi2+e5irMnrFuBDMH9SV9zAFKOMBu75FbCtTfGA3Hp4
	4vy8Y/GHC5LSvdiurceqKJAzlYxN7nwuZMSjuVWjNYcuQOBFOEy7y4JrtzglZgWrwqtzHx
	5fhideFTMhsT0qlJDREn5DFN2QiMKXI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777409084; a=rsa-sha256;
	cv=none;
	b=npIl4CpitoCSNnTyIh8WVfxgkK4figxLah7YC7vdG9ABIgBUU+QhLpY1V55gcZe0W1TU+2
	REhiALc8pwEayklXb7I3B1x5FAOf2Yr04zegmhK1KLTNxnlf88ij+ENLhepvfSObAiJYKM
	9TwLWSXUopYznc2YK7VGCuxCtO+nP04=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Id4M4KXK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 533F64433A;
	Tue, 28 Apr 2026 20:44:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26A77C2BCB3;
	Tue, 28 Apr 2026 20:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777409083;
	bh=FcE7V5Mvmmd2+FOco4bSM+J6XXXcmQOY5rP3hPMkKUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Id4M4KXK8BtwDs6OdHyCqMPWKhqfZvnSgajs8Q3H3UpHX7SSt+GopMiO3xLRE+M4p
	 E+L/cC7StlMzfmUtEpLoXrbIq/3fIPC8TVggZQM8hpfh+YAWUEHEHMW43OCcG4oZQ9
	 O5apk3wWg4Reii+dfXqf2e2tBbiSN+B9H+kXtwfU177WvC9bpT+27XpxLliNpgdFh6
	 OoGtQ7EGGMwCCauDQG43CZhcdGyAJnaU97OXStYmPumHe2LnBwM2zFlmZ/z57FfB9Y
	 sRoOl6EAJauiYdm6d7tt7WMmrm4p2yLq68YKj5Nu3S6gZ3FULrcDyL5v59tXfXLoh/
	 fA9h0KNPe4e6A==
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
Subject: [PATCH v3 17/54] selftests/mm: protection_keys: use kselftest framework
Date: Tue, 28 Apr 2026 23:42:03 +0300
Message-ID: <20260428204240.1924129-18-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428204240.1924129-1-rppt@kernel.org>
References: <20260428204240.1924129-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3C4902000D
X-Stat-Signature: zw9sq6quoqna4wc1qsmqm5f3gyyhgnye
X-Rspam-User: 
X-HE-Tag: 1777409083-381071
X-HE-Meta: U2FsdGVkX1+d7KGRBE6Jpxrt/TEx53xI/hHDIcwcJib+LE9fHvg2URB0yJvOAN4c8hTajeCNGcs0HODGxs98HmW15Mdpi0eqVbUSywOpcfdGxkEJjpH1t1sO/fD3X0qvqeI3J3VGdF5+g5qDnDYchpWWsYoIlRKTi/cyvXBHHVducs+OhUDhof64OCiFIkyy+cEbNCR3/r1UQVlwldz297j4Oy7cCXp+pKNkhdmXPrP6irJepb206N5ABK3RxDIydBKnWXOkPipXUvpychlBRuW9K0uMWE9sheLYxtKFvN42ItVTMzq6jwmu9KiMJd7xADeLY2h64wSegIMlpbJ9OjrQxjRqaMw33g3FGXc4wIbPywJOgPMSi7DlXctVtxwBNz7Lw+yYUFxnKOP/NGQmkHQWrTljJSVi+ZgJCOUQu+1o1ca1flu65+1URIWFWGh6Ba6zPvXCDdtqBa0YAc39dwYSt/jPlfB9x4bwKDB4FeIj1jUOiZvHqcaElQC0KHlMdbP9G8TR16twYtFSPYSkS50sIfwmVk4kFC6Wy6fr82sgEjCOGL97MiNm2rOC659sqfgd8pXxyhsRGmnaG1eTXwFtlnjAvEvo16ci/DixmNjbAq2s+/HQw6ttHF9auWzzMpSXlYZJGW+igjkhO/H+C2wd4O+kJjfhXQzoUJD18X4/7CX8JktWuNxdp7paGCoFq5w/qefD5KbM+WnERubRRt9yAVLkKnFHFcsrBcE7a74tdS1AgACnvLGvczDox04WN9oELi9O1I6bEcGa/GVcu2RywES2Ft3I5EO0L7ZFxh4Vo/9CMVuiNzJGjOhcMXe5xgULT4SpzhJO8jPGYyL8T7QhuJZZkji8Fu0rJBmqwSHavcm2ToZifJAqKZNmUAGKcomhxC3IjvvWkVbA5n8aH+wX+N4XmiSnQC0L2rF1JB4OmMNX+/kcdtKbJjlJY0IlVie3ag356BxyOv4ULPk
 Z8yffaTC
 Y14kG3ygyvgzwheFyouBb6uuktf1k/f56MTBU3wwECBcNgYYlEowb2w7fJP7GIAnfM4gVLdTVqITJh52uYkED+jhTahKxr4FzEDLye5qJy95aA1XbcZdz2ySMQ2rZdj016ztlIROzWKca4ruXdKCheV3ospvC0MUPGbFzpDpuN1eM0KL9U3UN8xQTuarfMM3+h7mAn61h3FMpDatsbSuoJ74LQjh6NrE3ghPpcaK6HZCXAiTWs7bZ9QOYunp2vn1vBHp3h0rQns0mC8JlPZcvQXengLrAVa1I2NFC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Convert protection_keys test to use kselftest framework for reporting
and tracking successful and failing runs.

Adjust dprintf0() printouts to use "#" in the beginning of the line for
TAP compatibility.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/pkey-helpers.h    |  6 +++--
 tools/testing/selftests/mm/protection_keys.c | 26 +++++++++++---------
 2 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/mm/pkey-helpers.h b/tools/testing/selftests/mm/pkey-helpers.h
index 7c29f075e40b..ae010b075417 100644
--- a/tools/testing/selftests/mm/pkey-helpers.h
+++ b/tools/testing/selftests/mm/pkey-helpers.h
@@ -71,10 +71,12 @@ static inline void sigsafe_printf(const char *format, ...)
 extern void abort_hooks(void);
 #define pkey_assert(condition) do {		\
 	if (!(condition)) {			\
-		dprintf0("assert() at %s::%d test_nr: %d iteration: %d\n", \
+		dprintf0("# assert() at %s::%d test_nr: %d iteration: %d\n", \
 				__FILE__, __LINE__,	\
 				test_nr, iteration_nr);	\
-		dprintf0("errno at assert: %d", errno);	\
+		dprintf0("# errno at assert: %d\n", errno);	\
+		ksft_test_result_fail("test %d (iteration %d)\n",	\
+				      test_nr, iteration_nr);		\
 		abort_hooks();			\
 		exit(__LINE__);			\
 	}					\
diff --git a/tools/testing/selftests/mm/protection_keys.c b/tools/testing/selftests/mm/protection_keys.c
index 80c6124e8378..d617b41dda6b 100644
--- a/tools/testing/selftests/mm/protection_keys.c
+++ b/tools/testing/selftests/mm/protection_keys.c
@@ -136,6 +136,7 @@ static void tracing_off(void)
 
 void abort_hooks(void)
 {
+	fflush(stdout);
 	fprintf(stderr, "running %s()...\n", __func__);
 	tracing_off();
 #ifdef SLEEP_ON_ABORT
@@ -370,8 +371,8 @@ static void signal_handler(int signum, siginfo_t *si, void *vucontext)
 	if ((si->si_code == SEGV_MAPERR) ||
 	    (si->si_code == SEGV_ACCERR) ||
 	    (si->si_code == SEGV_BNDERR)) {
-		printf("non-PK si_code, exiting...\n");
-		exit(4);
+		dprintf0("# non-PK si_code: %d, exiting...\n", si->si_code);
+		exit(1);
 	}
 
 	si_pkey_ptr = siginfo_get_pkey_ptr(si);
@@ -719,7 +720,7 @@ static void setup_hugetlbfs(void)
 	long hpagesz_mb;
 
 	if (geteuid() != 0) {
-		fprintf(stderr, "WARNING: not run as root, can not do hugetlb test\n");
+		ksft_print_msg("WARNING: not run as root, can not do hugetlb test\n");
 		return;
 	}
 
@@ -855,7 +856,7 @@ void expected_pkey_fault(int pkey)
 
 #define do_not_expect_pkey_fault(msg)	do {			\
 	if (last_pkey_faults != pkey_faults)			\
-		dprintf0("unexpected PKey fault: %s\n", msg);	\
+		dprintf0("# unexpected PKey fault: %s\n", msg);	\
 	pkey_assert(last_pkey_faults == pkey_faults);		\
 } while (0)
 
@@ -1753,7 +1754,7 @@ static void run_tests_once(void)
 		tracing_off();
 		close_test_fds();
 
-		printf("test %s PASSED (iteration %d)\n", pkey_tests[test_nr].name, iteration_nr);
+		ksft_test_result_pass("test %s (iteration %d)\n", pkey_tests[test_nr].name, iteration_nr);
 		dprintf1("======================\n\n");
 	}
 	iteration_nr++;
@@ -1773,27 +1774,30 @@ int main(void)
 
 	setup_handlers();
 
-	printf("has pkeys: %d\n", pkeys_supported);
+	ksft_print_header();
 
 	if (!pkeys_supported) {
 		int size = PAGE_SIZE;
 		int *ptr;
 
-		printf("running PKEY tests for unsupported CPU/OS\n");
+		ksft_set_plan(1);
+		ksft_print_msg("running PKEY tests for unsupported CPU/OS\n");
 
 		ptr  = mmap(NULL, size, PROT_NONE, MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
 		assert(ptr != (void *)-1);
 		test_mprotect_pkey_on_unsupported_cpu(ptr, 1);
-		exit(0);
+		ksft_test_result_pass("pkey on unsupported CPU/OS\n");
+		ksft_finished();
 	}
 
+	ksft_set_plan(ARRAY_SIZE(pkey_tests) * nr_iterations);
+
 	pkey_setup_shadow();
-	printf("startup pkey_reg: %016llx\n", read_pkey_reg());
+	ksft_print_msg("startup pkey_reg: %016llx\n", read_pkey_reg());
 	setup_hugetlbfs();
 
 	while (nr_iterations-- > 0)
 		run_tests_once();
 
-	printf("done (all tests OK)\n");
-	return 0;
+	ksft_finished();
 }
-- 
2.53.0


