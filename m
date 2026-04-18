Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5E8FF99C7C
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 10:57:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B0696B024E; Sat, 18 Apr 2026 06:57:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 260B36B0250; Sat, 18 Apr 2026 06:57:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 150326B0251; Sat, 18 Apr 2026 06:57:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 003D36B024E
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 06:57:29 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9860913ADB4
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:57:29 +0000 (UTC)
X-FDA: 84671375418.14.8888A94
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id E0BAA20003
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:57:27 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GHvbH0FT;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776509848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wSpTLNc3//Mq743lhj5uKVaI6o83o4FZcpXlEkESkEQ=;
	b=GoQfttzFBlcDgybzfOzVGSfaW5Ep0DKjoRKf7noFPRMV3l8Ph8HuY4+5C60Afn8/+MOUpY
	UJ/I90CkoZNBiz9v/mqn0Poece+A4dx4pNmZRN12cU3/aB7QOe6hjtcg7zfJsknPNiHIlh
	oC/ldjt9IPQP7JXP+QmdoA7EUXIelHk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776509848; a=rsa-sha256;
	cv=none;
	b=VjmF9BXGeP4aM0VyUDOfJIcqibFMUxAHlhKLvQxF/Yn2sBvcYFfblN6Wt+GvRon5yRL63R
	hZdo+AMWj2UYJxJiYuiastjE2rtHgUj2DpBJhyGqP+gSP3hdanFTivmGDmO4pKsswGCSFW
	yDuBfhQdFrolb2Cb2zrFxvxWbeAoxSs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GHvbH0FT;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1A8A540E2A;
	Sat, 18 Apr 2026 10:57:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52277C2BCB3;
	Sat, 18 Apr 2026 10:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776509847;
	bh=ZfbG35JDCFGHcQNJmFQWCxDhKC3iKoBsHHCyZ5Qqs18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GHvbH0FT9P2v+XlP/f6WihV7dNiH+Fd4I7sQ87dJZDgKE7dU6i/FSPYwglQii7Caa
	 /SavICBCXgnsKR4fY04a4p0oiwpMWFV7r85nxfc5tL3QG+PpdTKL8k2jguWl8WuTcw
	 jUI65ilmazW70Pq8m3APw+g2SWvOGOfbrNkULHLZFl1Tzx/mtY2B+x7Ljywe3GCFdt
	 4iMXoaH14FTHE4RWZjotayP2ZnoLvwIVZ0GxfcnL0PQhZ14LU4soIZSP20sD6ZI6wG
	 oS5u8FDlOn3tfOo6RcNR0XG4mBMQ9p4MEZ5qKiq8a6x+vX3zKVAoOWNMpcGLUL8rMT
	 LX07yDhmNl3+g==
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
Subject: [PATCH v2 16/53] selftests/mm: protection_keys: use kselftest framework
Date: Sat, 18 Apr 2026 13:55:01 +0300
Message-ID: <20260418105539.1261536-17-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260418105539.1261536-1-rppt@kernel.org>
References: <20260418105539.1261536-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: tzm5xk4kzsby4bns8o8ors3ysotkxdpd
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E0BAA20003
X-Rspam-User: 
X-HE-Tag: 1776509847-559712
X-HE-Meta: U2FsdGVkX1+dNUGjnUHOfwBCmtHDpFgws93MOOpzSZbVBZXx/lnLYKvxGv1iBr1wl1lhX3h3pUTojNcAGMR4Pec2tZfWjfJa+0dz+u8VY7ccurcgczg0A7FgLl7tEVexNg8SOOc9d8JDrVY33PMjiSP0fuptBvZLkc34+3sqHtFsK7W2M4RUwbeBmrdoMY4gW9t/Wcs3N8MjrkrJ45roehLb/GIkxGzyvPr7pqPKd7T1wRK6Wo0pUCab5ykJ6eEP8LOlwT/cnzTDZ468GVHQ5dIjMGOnWy07XX2vVTTztuSvbG7uPzuWHdqJfLtpI/KpU9xOVhqwoTnXnghIG4FElL9nqZ2eXmVYnJED6UjlBYIGvw8+8YdW4+3y1qbkTjnoVwOf+YcoeuSC97eeS0UQb+BsYTVToXBljdh8DKHCTOYkm3nzVqXoZsrLz1YknUMFUizIXgb/mbSCnNaiC1pSFXPTadeKCG0MbSdstDmXQg0e/6rtHesH4TjzCbflH+U8IOkPV/eK7XBGjUI/n3ClvdlzeUVaXu+6nUlBAVtSMT8NNpE4bxvSQ/QiRW+I7V8Gf2Rn7ey06O1NopWqGv9wXLrquGWOqZyg77h2CI2O8i6W1PRkeFTjXXEm5iZXfcvccw11QRlEvoa93F00bB+XunR4uOcZ+3q+aXLKl9KJwgrqGspEj0WEEi9UTQTaJpvZo/sVSH9pSl47wvlV4kHObwOAyHC78Wyuc8oapiUxHxZaD7DnSljABQxFF7OQMerpPQ30mbEAdbcSESfSgG/afyQbFYD/qSCOD39Zu3I/5HgbkC6GG2BHM8LE1WFRgx+4DMqAhJNrLMe/jvdCtHGGyApNm0nbrCZjVGs40yQI3pXLm00/68HMkzJUvmnOVNkHmDndqdBBT9Jpi+2KSiBLm98oqrsmIWoMQFYoiPyRJPMzyVyJw/J6SIEYtdA7h9YuoP05dx9B1rndeMTBETy
 0fy0uiOG
 2ZZxW6hR/Hn5DqC3uFeaK/Nz9/Y+vYj8xeTiy6Qn73njQodhVY2yOMyA5s6+5faFJtVZeqZ1od7duEOQdHgxud+lZLD8tXvymyvFNAtZky7jpalpUFzHJwzJjiZ32vKKqDaLs5R3D4a+6UXwU/RRa2iZEG8UGMcUVsVwA4tI0gMe6HcQ1PFZwUfnF3sThEoiyir9FiEEWeFG2+M+IY/qbdeLiP25chssECfJX2Nyml/A3CeujJ9Go089LfP9oBzbRnkHwygkEoMggRW4sjdAPKVFToz7DNfj9/Kux
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


