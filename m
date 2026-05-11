Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6C55CD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:30:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18A496B00F1; Mon, 11 May 2026 12:30:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1621D6B00F3; Mon, 11 May 2026 12:30:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09F516B00F4; Mon, 11 May 2026 12:30:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EFFBA6B00F1
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:30:43 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BE2D51A01E4
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:30:43 +0000 (UTC)
X-FDA: 84755677566.03.6A32657
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 35AC5160012
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:30:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rkoB6HJX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778517042; a=rsa-sha256;
	cv=none;
	b=amf8mdmSHAI9qCfrR/PpG9R4/mH3b6IuvfMqEvKofGfi2fGAVzBKVDGGGvZR/o+HALeqKC
	E0D40i9cIjdXlv4xFZ4DuK89ZiStgUgq6q+T5zC6WLPTUDBAU2qcSMuE5tuKDnoyE8CB+q
	WiIAG7cTxXaLicvs5HdsjP/ctDdnyEQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rkoB6HJX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778517042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HFFfd9IKdYjJNFJbhCLSdkwAyiLorAr6VwQEwJELkbU=;
	b=YcqnnewXYr4AgDQEOqYf6QVgaK9rIlMTZOkxvm/bysybahIIM0J4Z37HO3JcRKtwzUSu6O
	d3lQZ39oKikGzs/keNdVvFSGRGBWf0UqvoTvrbRsT4QioaMNEy4cUudoNfeCGUrimsRywM
	1G3N1NTpY365gXZQLdevNjV7cSHRQbs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A73B960126;
	Mon, 11 May 2026 16:30:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59FA0C2BCB0;
	Mon, 11 May 2026 16:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778517041;
	bh=eC4vwpU9vFNcN2z6oLk75iFVUlZ87Tp/bOty1j6wGoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rkoB6HJXCHYtyEG2AUimuPNPvidE3aB0Akv6ICmiAVPx/xDs9UCCMtaHsztLUfCGH
	 OJ6eEg9qw/JhiyxAq2dmEUpeH8eDFKD8gjfJWQe1UxWHABs8OjdphW7RRLCfXZhxOX
	 le01II0hyWlKD76K2BfHYsq8z1fPNitGYxEX8UX1LyMJdMk0F97AnffUD+0b8u4t0H
	 bXaqVOdJdOHN+OFf1KXBWdtaG9Xiy4xk2Oo5fJl6G/9uMXFEkq/HdPFka81Bw1QIVQ
	 AYdjnxzYcW2LFhg7VQw14JBMAu/Xm7nlYidxLgqY1rCxszT/8Mpp4M3PwmAJM9qUcd
	 kHgBV96GkDMNA==
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
Subject: [PATCH v4 17/55] selftests/mm: protection_keys: use kselftest framework
Date: Mon, 11 May 2026 19:28:01 +0300
Message-ID: <20260511162840.375890-18-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511162840.375890-1-rppt@kernel.org>
References: <20260511162840.375890-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: okpjehorfwyj5tpbh11sbqmgryencpti
X-Rspam-User: 
X-Rspamd-Queue-Id: 35AC5160012
X-Rspamd-Server: rspam07
X-HE-Tag: 1778517042-465381
X-HE-Meta: U2FsdGVkX19QOAIpvDXSrD8Tht0MEyE4nMMe5UpqABuw37/We3uP0fWKmDP6RV6XUOcoaPwT1PwW5zcgcRU9HnQs8eY/fEERckmkmrQM5gViibT/eaL2jb5KmS7Z6ylAPee45GHoRpmqYzXi6oNnjMYawbNAWqMddnpMLY8pB6/zWbLBrS/MCgz7aZc1UDqS8xvFtcaQbXHG/hG8Y4Y7fxACaNhQuwsL5R63XmwzuyZKTE5oFgBlZYfe1JHEIMxpLiW8eru9Eg7GHTjuSUPeCq+Xs52eYWwpz5r43UQyYwuJXQUPFkxNXynarvpZtWQDXdh4oDzia8tZXZvTh3rLs+wKokNJ0N7Fh71l3Cq48yHenAKA4KWofvm0fDMuzOOjwBbBVRNJMkLZmg9cDP5WwJ1yJwqi6xvPqf4urFfTdnxz6pzxp7sYUhSa4plcysfwQdnu8LZuO6Y9Lma4uQIjYLAoRrSqvTNm3mTcMU4d0XPUFkH2od9vti0wej+qK06+3+fRhXnxVSUxPG7TcsmWEd2hhDPNIS5AmjbA/h94hCXS6gdHh6s61S771lJu/xImGNG5wUZfND9aqvWGE4FJXgIbXCPwgyT3PZXhxR8VMmvKJDF+5vuBjZ9ufrHkEVVPbmy+Nhp/NvzVWvTV1MS9Z7JpchZvOp/XqCj4nQIeA79Jvb/liUXjlZDs1mz6iqefzAWn2dnhF2s8q1ioVrt0kZie0r7PHh77cz23IyFFjrsN76wTjO2yyCIYFvPuM3XOSYEVntayPwHqvo7yNBz+9F9kSgAYCG7CB3ljUnzXzNVHFXAy9tJo4+2xjAlCQIo0xOFyewTkuvV95K/o7EE1PiZyyFSSeJI6Myj7BCQFcv/9PlYtseUzIi9WoDuxk59LgIORYT/nsJ5aZTgZCtD85MU98aLdwNLzBjDW9FWvWCiggB/d4XP/wROLfEBNwAsd5zBu0rO4mU4GmjKN9rl
 AW2k8K5K
 nJ75s1AxK+jk9ibobV8OifBj6QD/atTDDbgye65JliuM4o+P5A67V/UfeqloHCugZqMFEqQjhVvGQ6YpWqgXEEEkk+WMaYCEEGKvCSy/EK2qHTXKEzMQVeQAZREr2Af9AhqeNF2tQsqBsxXIHe/9awLaWeDhp5FKw/6loeJcDrz5fNjXFS7xi4X1fQipCR07dNkKY5RbESXGW3MHQQzUjOpx4rYhHwYSBz4dsn0BFk5SHfkaYsOBYxA2PBf3b2SMzNgjy8bUjA6CgT+YraqBG4f4jahzEWDpm5MBOtj5jrOBdeTED/BQdS8MG+JBpv/PP+8K3i0Qyal12BsU6zfBX0t7OlvwtI/9AuV+096d2xLSQ0QU=
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

Tested-by: Luiz Capitulino <luizcap@redhat.com>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/pkey-helpers.h    | 15 +++++------
 tools/testing/selftests/mm/protection_keys.c | 26 +++++++++++---------
 2 files changed, 23 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/mm/pkey-helpers.h b/tools/testing/selftests/mm/pkey-helpers.h
index 7c29f075e40b..2c377f4e9df1 100644
--- a/tools/testing/selftests/mm/pkey-helpers.h
+++ b/tools/testing/selftests/mm/pkey-helpers.h
@@ -71,13 +71,14 @@ static inline void sigsafe_printf(const char *format, ...)
 extern void abort_hooks(void);
 #define pkey_assert(condition) do {		\
 	if (!(condition)) {			\
-		dprintf0("assert() at %s::%d test_nr: %d iteration: %d\n", \
-				__FILE__, __LINE__,	\
-				test_nr, iteration_nr);	\
-		dprintf0("errno at assert: %d", errno);	\
-		abort_hooks();			\
-		exit(__LINE__);			\
-	}					\
+		dprintf0("# assert() at %s::%d test_nr: %d iteration: %d\n", \
+			 __FILE__, __LINE__,				\
+			 test_nr, iteration_nr);			\
+		dprintf0("# errno at assert: %d\n", errno);		\
+		abort_hooks();						\
+		ksft_exit_fail_msg("test %d (iteration %d)\n",		\
+				   test_nr, iteration_nr);		\
+	}								\
 } while (0)
 
 #define barrier() __asm__ __volatile__("": : :"memory")
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


