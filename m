Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A48DF46C45
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 14:19:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A32826B00B3; Mon,  6 Apr 2026 10:19:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A09D16B00B5; Mon,  6 Apr 2026 10:19:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 946356B00B6; Mon,  6 Apr 2026 10:19:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 845986B00B3
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 10:19:21 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5D9091B7FAC
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:19:21 +0000 (UTC)
X-FDA: 84628338522.20.843E774
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id F031140006
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:19:19 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dPjLSLrL;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775485160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wSpTLNc3//Mq743lhj5uKVaI6o83o4FZcpXlEkESkEQ=;
	b=FiB517/1yfU2BCBN/980dpEY2XKrdH5MJUxtVsLygpUMzbu75wtnHp2jzj8lEDsofoZKxq
	DwFXRpwO+LSrsWRumZKBXCN3G2WU0Cu6IItkIVg9oysgaxs51/AFjgUWj2WYmQD7qh3bzq
	cu56PPjPnMZyT1ScCyoUb3dZYCvCFbE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dPjLSLrL;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775485160; a=rsa-sha256;
	cv=none;
	b=4pLr3AH0bhTmghuSkF+p6mHxT6KHOYH8FaL+zXaZ7Yu96miFtJRE7KHUIiLbPGCHEECF/2
	6roE0pAu0g39ooVw0uUoVqB2ZMMr9BQJSz5p1N7rtdLfi2BlsSc4YI/3z3rhK5o5mK0XgF
	W1IZPRxmKHVMiEj3u6ZsYurewtdTQyg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 83B3060132;
	Mon,  6 Apr 2026 14:19:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E883DC2BC9E;
	Mon,  6 Apr 2026 14:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775485159;
	bh=ZfbG35JDCFGHcQNJmFQWCxDhKC3iKoBsHHCyZ5Qqs18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dPjLSLrLzNtv2x27Qg9/n+cuZi+T5XRaB5fe2R/1CC4nvnhtyO5kaRiI6J4Xamq8q
	 QsCWJrVjRXujo3RVixTBgwh3CNoAkzl0iqNnxdxGGaRUDblj3XGy+6odKaAoaQ2Y2R
	 RbcOTnVyF3qXwRqovJdGdsoQtpv83rZCc4EKLB6/BQXu3mqd+WrS5Ofy7/0zwOMDAi
	 2cB9YbYGZ3Uh0kihLzPqjoPYCj4FUqx5MBsBsRVxEbSTI/xMbH++v1lFFv/RSyHadT
	 4CM7pIptqvbVhKNeJ8EU485g5E9oaSTxzgZ7SluaLj+LYjq4RIuqrYlDiNJmEBBqJE
	 txJz8WV5ak8yA==
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
Subject: [PATCH 16/53] selftests/mm: protection_keys: use kselftest framework
Date: Mon,  6 Apr 2026 17:16:58 +0300
Message-ID: <20260406141735.2179309-17-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260406141735.2179309-1-rppt@kernel.org>
References: <20260406141735.2179309-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F031140006
X-Stat-Signature: 3wnurg6pcg4owyy89g8w933zfmcm3q39
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775485159-554121
X-HE-Meta: U2FsdGVkX18rS/lKZqfXmgz/OHxCLB+Qocxb5Bycg2fsKU1rEcu+BJ3llnufsKHCFxndG+tPt0+hrYfQNIv7afGDduqBBNOqOHQT2AP0RkUl/yCaoEGG1aV83oSKeJgZA9Nahb4Biq7PHXa9qXqTUorLTMBjr2JnM7NE6qDRwqhL7m2/ZbAWfIThI6wsPBgyVORiLnkuLI+DeCXtvgwAI72uiEvhnrJbrpvE0Kd9H7joSOwPmQW7DDq39AGpiKn2wNoPcWvbxwhf9NICRMzztXaqNSePP1naAib+WMXOJC6qYaA/Ausx0s06/uYndTKvbd1oWGmMABAsK94mdjT7uzWXq7cGG+QlBZ3otmiJv/sN8B4mhScwY1B+N5+dBVth2lmd/Uay6TIUyOJYNkVV4ie0MOsC7W/C5tbk3hrcRaaYZ18nGnQ1E/2vvWNNwb7srTFyURhlxNzHgiMaLxDjTTrAlu8neyqG42o3ochJVMnvhX2Zz0vU7Y4IvCcXIqRCShDporsjWJQySii/101wdJQlrG1etuZtjuYmtKyVNyzYiTMBBMqIME1UBb3YMnv59XBj2wH+5iPBu+PoKzhb0iJhyFBkkVmHyhIpovq5eybX/0fuZEcL9YJYp/iJW/D5Lk370fr0NwQzG87e1IIP8rAwYsnOWWnXWfjIIE0YvPCS2Jw86Io3s7C++R/b/O+IO93/0MYMYOp47zgnkLeUpP96/1yuEXTNz+Zbc4Uw2rxr3WcafwTfs6K0A95kNoTVjbHBkhxtP79gdEDvPzWUmOk2LmYX4so6oF4y0j3tbH/2brYyeio8BuqVf6/EWG/sCS8jHgvoQaRKs5vVFO5f6KsowLbAAyDb4Hdo//W09um1awc8t9gMMrmxFBW5Dd0bCVEK5mRuNzyQNq+j2sWJLeVH63CyJcPAK5dOfrNdsL/lFZ9D1PXXAcZidCGa52Ge2ghLbztDPeQSOpWAbzS
 gJku+RkM
 c7GfEInuz+901hco=
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
TAP compatibility and add fflush(stdout) in the end of the test to
ensure all the ksft_print_*() messages are really output.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/pkey-helpers.h    |  6 +++--
 tools/testing/selftests/mm/protection_keys.c | 27 ++++++++++++--------
 2 files changed, 20 insertions(+), 13 deletions(-)

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
index 80c6124e8378..c069250969f5 100644
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
@@ -1773,27 +1774,31 @@ int main(void)
 
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
+	fflush(stdout);
 }
-- 
2.53.0


