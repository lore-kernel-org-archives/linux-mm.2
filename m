Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B19C4F99C79
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 11:00:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23FB26B028E; Sat, 18 Apr 2026 07:00:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 217356B0290; Sat, 18 Apr 2026 07:00:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 106B26B0291; Sat, 18 Apr 2026 07:00:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F03716B028E
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 07:00:28 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B1AE01404E3
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 11:00:28 +0000 (UTC)
X-FDA: 84671382936.29.49E5892
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 12B75140019
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 11:00:26 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mkJF6fSX;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776510027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d1J+gVdGAsLZYaoTUVkdTb29Yg85TIEdkMYwqNd59nM=;
	b=0GagIQ+PRejpUeG/0qEwWnvvK194vcDyc4oNQOZTD9wRZZyQVeIOxUWFVQs+XMvX2tNQmj
	QxSmKZ29+uEoWSbj4J528YfOJWQLq6nXvLkrm+lol4Y2UGVvgHg+sjxXzi0nA0Q8yyy0yH
	IjC6Y7Aus8kZpsQmfgaA5yw/rhFAQ40=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mkJF6fSX;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776510027; a=rsa-sha256;
	cv=none;
	b=8WE8h5I7fep/4hnE6wionwPp9PtfrWtlLq/2ZnbAmwAqvTkmNYkHwcv3SMTP29uHO+sEJt
	zZpFgkZfdbI14Ko2Ajji1wjrpN2GpdN+fuL7A0e7eFsX4kiZ3y/liDY6nvV3YJJdPAIRqs
	opaYxovpzBPZg8HKfG6ZUspfny8/kpE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 583BC6013A;
	Sat, 18 Apr 2026 11:00:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66E1AC19424;
	Sat, 18 Apr 2026 11:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776510026;
	bh=y1/LZCjoyF2qnYsdueFnA+DH0rudzkRE8f0qNrnyHBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mkJF6fSXFK9Ix1bEGXpbl5HcxyFd5J2LbGzv6eUHS2PxDlzS6LO3c01xC7HIHK5rp
	 Qv9fVgOHpWI9Tk03NckmITG7FufB16/tyDc/ENfiB7sB8pm9zRV5dWXwrxUyzXX+Em
	 SVgvPN1CO1ZFtaFK1N7ZzfuInp06O9fPKYuLXkxm7D8vw/kR8bmF1FGLDAplQt1gKp
	 CNgM6os9A/axwhVHRjBz5dTkv01Bbp8NcwBMAO85tb2jvATLNkw5gVUiVM1Bz4uLHh
	 nIcZUZYmS+DwVq2QA9rjtklPuWA4GcYG+j2vSYk2jPz9XKcaGkCqcX2lYrbyk/ZYw2
	 wmW4PG4wOYsQQ==
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
Subject: [PATCH v2 45/53] selftests/mm: protection_keys: use library code for HugeTLB setup
Date: Sat, 18 Apr 2026 13:55:30 +0300
Message-ID: <20260418105539.1261536-46-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260418105539.1261536-1-rppt@kernel.org>
References: <20260418105539.1261536-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 12B75140019
X-Stat-Signature: jy1661ardbx43ts5gjkx1ie4ig4kydhd
X-Rspam-User: 
X-HE-Tag: 1776510026-21709
X-HE-Meta: U2FsdGVkX19eow4MnoCsdm1f5GXL3EQmnwpqLuqJBUKU4zoqXZOWUzCyAfICehJsUbmuEB0/Kn8sOQmLTh0Aq+2huPFyigfcvpyf2woSxgBCtzBgFaWwP+4J9XQHZw+1ofBCrTjrEqK/BFluyzZ2ltHuviQgG+T6rgj3azIDtN53V8NLrhzmm1AycmueamdDdW1aIkmoftlpo4rqT1PKvwkUyDMhawP9AKp02U62vZxVlpT/kv1/v7cNsmeCKZ+Mg53bDhB8aadZLV2ITEshuQpymCalrLU1W3KHyQKL4cWOHhnvrBVmxgGzbRwbHZ52IKWa6azsyrqUL3vvMTy9PeZcK8Xm0wnxXBpXBIlPOiRy0a1iBWrVzA5l+N3CH8ILqcoYzNVythGg+FyTR+ZMJBu5UH/Wzj7X4A5L35Jy6/AKBll7En1chUYGFAFVaqGaC8ReMXrc2sZWWkCBIs1Me1a6yqGoeE9YQ54zYfmGZgrmK9fxtGsYYt04B0n+c+0NVmCs/6Dyz5PTcOxHFMp0n5ULx0cQhRdryqeWZpVMNRZ/XSjhyx3KPRQcNYECSUXPhFOjn0q00YaMnZdR5azaRIefx5GPWGfhT4IvC09DSoBqqg0qEPC20xkWoqmkyrFIp6VhqUkmDymsxnOeBo7F5VBvyJPTPGkewo5qqEvkL0qhdgaacrM1E/75lQ1s8pPBcTrkZKFOd9lu/Rl4G+DtqSQ0DErYUwmrBEeEPYmCIIJkl0ctDkZaH1AQHPottJl0dFnZmdkyHHmjmNd9Hni9Q+KZMUu9r/qA+pwVpD2DqR+S8yA4dt0hlzsKqMl/Ns5Fg4IEjw+pQ0HgTI2fqsDOluEvA6NP1KBEuz+Raj9TveuhJfo4pwCCBKEuVAPNsIncEWrMwSXaLOUO7pMSyYbg+NslLpdG2461Gwr/1veMAuZUpWVIivlthordrYxA7q+1UjWdRb0NaQUTChWgJFA
 tjZxKzB0
 Abv/JSpAN7D2jj6HKsWIvJSmcKQYlI1iIrn0Gez2VsFLpHxRprZaJtOa3rZkUzWC19vZdxRP4q2PXqDTNSxevWUuD9VdZNuH0ftZY96nI3RwbJyk7PTFK9x+/CuXKLcHuLyPGR/NaLjSwD8I+D/jP3Jj2h2e0vZcq1miTJugcGvE/jX7QAcIFGAx4KmqXyPawWMHFCrxe70uXZ1FEbDO9bCs/wfRVrLJ2SZlLxcbKOjrJXvJrEH9KjtPNH8gh3bxDoEV3FL8oI4/OShcGG5kKHMQ1yVzO/ngKcy3R
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

protection_keys open codes setup of HugeTLB pages.

Replace it with the library functions from hugepage_setup.

Replace exit() calls with _exit() to avoid restoring HugeTLB settings in
the middle of test.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/protection_keys.c | 51 ++++++--------------
 1 file changed, 15 insertions(+), 36 deletions(-)

diff --git a/tools/testing/selftests/mm/protection_keys.c b/tools/testing/selftests/mm/protection_keys.c
index c069250969f5..6657f13bc7e7 100644
--- a/tools/testing/selftests/mm/protection_keys.c
+++ b/tools/testing/selftests/mm/protection_keys.c
@@ -47,6 +47,7 @@
 #include <setjmp.h>
 
 #include "pkey-helpers.h"
+#include "hugepage_settings.h"
 
 int iteration_nr = 1;
 int test_nr;
@@ -61,6 +62,7 @@ noinline int read_ptr(int *ptr)
 	return *ptr;
 }
 
+#if CONTROL_TRACING > 0
 static void cat_into_file(char *str, char *file)
 {
 	int fd = open(file, O_RDWR);
@@ -86,7 +88,6 @@ static void cat_into_file(char *str, char *file)
 	close(fd);
 }
 
-#if CONTROL_TRACING > 0
 static int warned_tracing;
 static int tracing_root_ok(void)
 {
@@ -709,50 +710,28 @@ static void *malloc_pkey_anon_huge(long size, int prot, u16 pkey)
 }
 
 static int hugetlb_setup_ok;
-#define SYSFS_FMT_NR_HUGE_PAGES "/sys/kernel/mm/hugepages/hugepages-%ldkB/nr_hugepages"
 #define GET_NR_HUGE_PAGES 10
 static void setup_hugetlbfs(void)
 {
-	int err;
-	int fd;
-	char buf[256];
-	long hpagesz_kb;
-	long hpagesz_mb;
+	long hpagesz_mb = HPAGE_SIZE / 1024 / 1024;
+	unsigned long free_pages;
 
 	if (geteuid() != 0) {
 		ksft_print_msg("WARNING: not run as root, can not do hugetlb test\n");
 		return;
 	}
 
-	cat_into_file(__stringify(GET_NR_HUGE_PAGES), "/proc/sys/vm/nr_hugepages");
-
 	/*
-	 * Now go make sure that we got the pages and that they
+	 * Make sure that we got the pages and that they
 	 * are PMD-level pages. Someone might have made PUD-level
 	 * pages the default.
 	 */
-	hpagesz_kb = HPAGE_SIZE / 1024;
-	hpagesz_mb = hpagesz_kb / 1024;
-	sprintf(buf, SYSFS_FMT_NR_HUGE_PAGES, hpagesz_kb);
-	fd = open(buf, O_RDONLY);
-	if (fd < 0) {
-		fprintf(stderr, "opening sysfs %ldM hugetlb config: %s\n",
-			hpagesz_mb, strerror(errno));
-		return;
-	}
-
-	/* -1 to guarantee leaving the trailing \0 */
-	err = read(fd, buf, sizeof(buf)-1);
-	close(fd);
-	if (err <= 0) {
-		fprintf(stderr, "reading sysfs %ldM hugetlb config: %s\n",
-			hpagesz_mb, strerror(errno));
-		return;
-	}
-
-	if (atoi(buf) != GET_NR_HUGE_PAGES) {
-		fprintf(stderr, "could not confirm %ldM pages, got: '%s' expected %d\n",
-			hpagesz_mb, buf, GET_NR_HUGE_PAGES);
+	hugetlb_save_settings();
+	hugetlb_set_nr_pages(HPAGE_SIZE, GET_NR_HUGE_PAGES);
+	free_pages = hugetlb_free_pages(HPAGE_SIZE);
+	if (free_pages < GET_NR_HUGE_PAGES) {
+		ksft_print_msg("could not confirm %ldM pages, got: '%ld' expected %d\n",
+			       hpagesz_mb, free_pages, GET_NR_HUGE_PAGES);
 		return;
 	}
 
@@ -1129,7 +1108,7 @@ static void become_child(void)
 		/* in the child */
 		return;
 	}
-	exit(0);
+	_exit(0);
 }
 
 /* Assumes that all pkeys other than 'pkey' are unallocated */
@@ -1508,18 +1487,18 @@ static void test_ptrace_modifies_pkru(int *ptr, u16 pkey)
 		 * checking
 		 */
 		if (__read_pkey_reg() != new_pkru)
-			exit(1);
+			_exit(1);
 
 		/* Stop and allow the tracer to clear XSTATE_BV for PKRU */
 		raise(SIGSTOP);
 
 		if (__read_pkey_reg() != 0)
-			exit(1);
+			_exit(1);
 
 		/* Stop and allow the tracer to examine PKRU */
 		raise(SIGSTOP);
 
-		exit(0);
+		_exit(0);
 	}
 
 	pkey_assert(child == waitpid(child, &status, 0));
-- 
2.53.0


