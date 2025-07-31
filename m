Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDFA2C87FCA
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 16:02:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44C4A6B008A; Thu, 31 Jul 2025 12:02:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4242C6B008C; Thu, 31 Jul 2025 12:02:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3136C6B0092; Thu, 31 Jul 2025 12:02:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1F4726B008A
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 12:02:41 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B598EC06A2
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 16:02:40 +0000 (UTC)
X-FDA: 83725027680.19.580EA01
Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	by imf23.hostedemail.com (Postfix) with ESMTP id DA8ED14001C
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 16:02:38 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=XrTVbySq;
	spf=pass (imf23.hostedemail.com: domain of usama.anjum@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=usama.anjum@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753977759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0rIUsTPjbY2X209n7mDn3VwLafDt4aFcMM5+u+5YCmk=;
	b=6jrLO0c+Y7Y3Q/ezjrUjKeXCcPar706NMcLxGviZ4b5gvO3DbT72LPxCwsTJHK3SKFVAbU
	wy0LyVxu6uSwX1hfGLo5fqyGSSDsJ7GtPaSpLpsvaP9O0zeTrY4hoo+ke+ce//XPgxFM7t
	1BPs9dc1S15lL9BoKlef76SmexVgft4=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=XrTVbySq;
	spf=pass (imf23.hostedemail.com: domain of usama.anjum@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=usama.anjum@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753977759; a=rsa-sha256;
	cv=pass;
	b=NigViKbfNNEVbR7syryX1o8rFO/NA4qpvnCUPQ7OIoXEOXJerIFo3obglYGmaoXfEnFzea
	QM6wKEwZV8mAIamdjBoh3SGFSbyGrc90So90BPLP6IDHGswrhtLpb6u1y7fM6+Wzh/P8Ep
	b2veOjGSgWhxwKd+YDcHHMKeoJNWPmY=
ARC-Seal: i=1; a=rsa-sha256; t=1753977741; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=kZrcr8lGjCQ/uaYK88EneYfN9ao5iMrIBdWosfJasMphAJ+cPsUae+MsXRWpNTJQ2tuMMoGDsQJGfRUlk6ZZ31RYSYDRaPmFnRO97x1qjXvufx2sdQPsUXSfy7CS8HV2xD0sJcH4tywWNZM8rogeXywoqIdoG/S/1TiSGyyRNwI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1753977741; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=0rIUsTPjbY2X209n7mDn3VwLafDt4aFcMM5+u+5YCmk=; 
	b=F5IMe+DOqWDoDKoKKGDgGGaQmw31nvnJ+KztuVci0qh25Ojm+uUW8vJm66LWSJjuAE1wrn2whXV2iEjB42gYvFVPfIVvQ4YIKKdGl5NxztAboLrRE8LDmwf48uhBxhsvEoTLC3CATq3OPWcb/7T4aGdDCgzEtc54jz4WwPOPbQc=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=usama.anjum@collabora.com;
	dmarc=pass header.from=<usama.anjum@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1753977741;
	s=zohomail; d=collabora.com; i=usama.anjum@collabora.com;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Reply-To;
	bh=0rIUsTPjbY2X209n7mDn3VwLafDt4aFcMM5+u+5YCmk=;
	b=XrTVbySq+/g7c2Lj1WWTvNchEk/DPefYFSW+l/DPiM3RTR1jK97eeN6kQWi/uqCn
	4TbpNczuDUhU3hmlpg/ORIfQKY88frscvRFeoHjMi0OKR26mWrB5qGFMGKNajkvOkba
	y3oqaKPZCEbduEF/ife2TlXQ0ee2aLNB2MrSDlsA=
Received: by mx.zohomail.com with SMTPS id 1753977738812600.6316331219836;
	Thu, 31 Jul 2025 09:02:18 -0700 (PDT)
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Leon Romanovsky <leon@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	Shuah Khan <shuah@kernel.org>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>,
	kernel@collabora.com
Subject: [PATCH v2 1/8] selftests/mm: Add -Wunreachable-code and fix warnings
Date: Thu, 31 Jul 2025 21:01:25 +0500
Message-Id: <20250731160132.1795351-2-usama.anjum@collabora.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250731160132.1795351-1-usama.anjum@collabora.com>
References: <20250731160132.1795351-1-usama.anjum@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspam-User: 
X-Rspamd-Queue-Id: DA8ED14001C
X-Rspamd-Server: rspam06
X-Stat-Signature: tupszcans69k9hwnmos9msdnpje61w9q
X-HE-Tag: 1753977758-600704
X-HE-Meta: U2FsdGVkX1/ZpLfKB5YUim0wVklnc/3xgik2AgAKBOd0oB29JvGQ5OLZ+0RqNWfJD535corO1OLO4a2D+vjwsftvlZ8r9/a9MnKmObvAx3PcmQ6e7p2OHgBLvtARBiBV/W/DsQp75aP/HmLmPULDeoLLGaa5KS4d/UqrQYFcCJUSRI8U4nAuGCrLJWq68Klrl42BbYvvgnSAhBYmtHzsG5vsWCSI4XKee65epH7oLCebMzGzXd8kft7vY+8/5y8QGX5qVrv6+mcq8c1ccivOiub/ABlYeYidD0RG3WpDvgXLn6RYaDUcSeNlCjk5ahkRLAX6kO2+2BcKv/eHmgvJ+ANu5YJ83xrIfsAw44IFZGfV+eHPMXOPL7Kmsq+3ubyaClJpLEOk1Nl6CG+WdNuM4pROmiHNX7nQTKvT4YrXhrt8/WUdHL2Jxrj3gc6oRX4QDhxlENesUVIYD+FDj1ykMaddLKzaRm5Q9IyozyI0Xl5ladgKzvJUOcmpUt/grGZjM43s3y6Deb8gBHtA4+E71KtYcqdXZijuT+8D4klGx5QhIohgLGVDgq66Mlvn8/qVDBy6gxVXx4NfM4Aaot3O3jXHDcQzF5XtwRydPX71u6JBYOYCBlw50Q3k/30v+C1Fyp/Di6gmxqH4vQxOZA6n8NSefhTfdd+bvfi2JLCEUkQL+4CLoY6fOjZSCBS5uBIX5d4CMQmrk1w8MbBZEcauMspAOqtf2Ek/ckYNfh6SPG/hnbQ25xGSfQ1erUOoyhx0NERzhncZGFE/2oF3aNSmsXO23NoYDfGpYB5WfGoWlmSehHrO+duE6NQZm2HE4q3yaINT6GyNXtFPVuf9WudfDnO0qmH2dutBRBob37OM+JQ+b1kuFibcwEjxylMZ4TLbiHabmHIDcy0GXXQaG8A7SuLN55ZQsd7tENx0SDDzz+DorPWCZsL//kKT2uGvwupHEP6AYPCjUwZz7QAo0Et
 PMXW2WeN
 JRHfHOVUJDnAP12iN9oredUYWYv91m80P5nvgTISip0c8x/XeXrWRICzTdzjseoZu6Wpjwo0cf9ns1KKhNPtHsyBfOOu7CUXYxUuPbwvw7j+3+Vb/hFvoqcwF7n1XmsK3dUGHAYUJ9u55m0jhWBisb3wkEW8z487736YQUDcgwLxqa8VvnMGyyR+UxgL2/xu+n1tyDRrygD69/t/FYOWjlWEyDUBwc0ZdU0ljbH2U+m3G8Pj74T/b82Vydyf4MPaSkXYpzVRcnNOlim/gibvtVz1LgN1ZwJWqbOHsn7bnu4hrauZeIrjnEMbGmEtJL88REfuocBVdWxPF960301PnXmNM+Cq3gOrNUELoc+EMP4hxJT9NGcKf+MY4itI3k8wk2jZo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Enable -Wunreachable-code flag to catch dead code and fix them.

1. Remove the dead code and write a comment instead:
hmm-tests.c:2033:3: warning: code will never be executed
[-Wunreachable-code]
                perror("Should not reach this\n");
                ^~~~~~

2. ksft_exit_fail_msg() calls exit(). Remove the dead code.
split_huge_page_test.c:301:3: warning: code will never be executed
[-Wunreachable-code]
                goto cleanup;
                ^~~~~~~~~~~~

3. Remove duplicate inline.
pkey_sighandler_tests.c:44:15: warning: duplicate 'inline' declaration
specifier [-Wduplicate-decl-specifier]
static inline __always_inline

Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
---
 tools/testing/selftests/mm/Makefile                | 1 +
 tools/testing/selftests/mm/hmm-tests.c             | 5 ++---
 tools/testing/selftests/mm/pkey_sighandler_tests.c | 2 +-
 tools/testing/selftests/mm/split_huge_page_test.c  | 4 +---
 4 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index d13b3cef2a2b2..23d4bf6215465 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -34,6 +34,7 @@ endif
 MAKEFLAGS += --no-builtin-rules
 
 CFLAGS = -Wall -O2 -I $(top_srcdir) $(EXTRA_CFLAGS) $(KHDR_INCLUDES) $(TOOLS_INCLUDES)
+CFLAGS += -Wunreachable-code
 LDLIBS = -lrt -lpthread -lm
 
 # Some distributions (such as Ubuntu) configure GCC so that _FORTIFY_SOURCE is
diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
index 141bf63cbe05e..15aadaf24a667 100644
--- a/tools/testing/selftests/mm/hmm-tests.c
+++ b/tools/testing/selftests/mm/hmm-tests.c
@@ -2027,11 +2027,10 @@ TEST_F(hmm, hmm_cow_in_device)
 	if (pid == -1)
 		ASSERT_EQ(pid, 0);
 	if (!pid) {
-		/* Child process waitd for SIGTERM from the parent. */
+		/* Child process waits for SIGTERM from the parent. */
 		while (1) {
 		}
-		perror("Should not reach this\n");
-		exit(0);
+		/* Should not reach this */
 	}
 	/* Parent process writes to COW pages(s) and gets a
 	 * new copy in system. In case of device private pages,
diff --git a/tools/testing/selftests/mm/pkey_sighandler_tests.c b/tools/testing/selftests/mm/pkey_sighandler_tests.c
index b5e076a564c95..302fef54049c8 100644
--- a/tools/testing/selftests/mm/pkey_sighandler_tests.c
+++ b/tools/testing/selftests/mm/pkey_sighandler_tests.c
@@ -41,7 +41,7 @@ static siginfo_t siginfo = {0};
  * syscall will attempt to access the PLT in order to call a library function
  * which is protected by MPK 0 which we don't have access to.
  */
-static inline __always_inline
+static __always_inline
 long syscall_raw(long n, long a1, long a2, long a3, long a4, long a5, long a6)
 {
 	unsigned long ret;
diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index 05de1fc0005b7..a85b2e393e4e8 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -296,10 +296,8 @@ void split_file_backed_thp(int order)
 		ksft_exit_fail_msg("Unable to create a tmpfs for testing\n");
 
 	status = snprintf(testfile, INPUT_MAX, "%s/thp_file", tmpfs_loc);
-	if (status >= INPUT_MAX) {
+	if (status >= INPUT_MAX)
 		ksft_exit_fail_msg("Fail to create file-backed THP split testing file\n");
-		goto cleanup;
-	}
 
 	fd = open(testfile, O_CREAT|O_RDWR, 0664);
 	if (fd == -1) {
-- 
2.39.5


