Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 206DBF46C46
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 14:22:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8889A6B00ED; Mon,  6 Apr 2026 10:22:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8605C6B00EF; Mon,  6 Apr 2026 10:22:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79D966B00F0; Mon,  6 Apr 2026 10:22:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 68CB86B00ED
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 10:22:09 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 315F314043C
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:22:09 +0000 (UTC)
X-FDA: 84628345578.25.8A97E36
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 90F131C000D
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:22:07 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cPRuhkU6;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cPRuhkU6;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775485327; a=rsa-sha256;
	cv=none;
	b=zjxL4q/lF9v9KZsAzVzuCHZayBU5GLhUNhzMDJp54V3BBqnhpSYUcB6TybQ3ESV4g5XV1t
	bjxcw0NElfOIWqZ3SwH3XODHhu1/tn8dT895wj2GndS5cZieYO1TkwT+tDiIMeiqoN0rSN
	FbS39u+j2WZl2CzAV+ufL20lHTfwUig=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775485327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d1J+gVdGAsLZYaoTUVkdTb29Yg85TIEdkMYwqNd59nM=;
	b=02/kUctkGrYk2yHgHjKpjW0sHd5RHjkoi7RmThI/kOcBk1AZevvQdz/2X4b2x1PUeDwYfG
	kzKF9EE8a6PXcol1TgSM5YQI0IOlwkPH/hYJGtHN9E7jLkqMDFmwWgBmcBcL4MKrWdjHvu
	8nIace3sFjBx7ygCzQ6wtI/LvHAhrC8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0BA4560127;
	Mon,  6 Apr 2026 14:22:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F79AC4CEF7;
	Mon,  6 Apr 2026 14:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775485326;
	bh=y1/LZCjoyF2qnYsdueFnA+DH0rudzkRE8f0qNrnyHBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cPRuhkU6mDC5MuJezdrELx9YKbcv8uiZS9LaS5xXzknAzK9DcpHRfnTIW1as9LEEK
	 T6pTXeqyRzKGBmeTQWPFcZKe9+1hkjXJcrg+2HO/c+CN78JMa6HnEimxSQPEwAwd1o
	 4lpkALLLJTFPaHyK+Lkk0M6PNHWp1Ibt9ArPxrztdHG0D+cVCue3A9Dkb96b12ZBWf
	 jZr3YUzgU1Lbxdz06fO2taHB34MYGa/I90syKGSvtfJdl3VbuIPbxLzpgS+G9Pnb2w
	 3yQtG8jdl0W9HbnyXSS2CJxY4PStA0ojUB42lWuDWz6gSCxEi14ZHBlWu4lwl+VHEC
	 ehsbHFqEP1J/Q==
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
Subject: [PATCH 45/53] selftests/mm: protection_keys: use library code for HugeTLB setup
Date: Mon,  6 Apr 2026 17:17:27 +0300
Message-ID: <20260406141735.2179309-46-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260406141735.2179309-1-rppt@kernel.org>
References: <20260406141735.2179309-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 90F131C000D
X-Stat-Signature: b1ab1tw7ad7d9hathe7y8to67zycmfzp
X-Rspam-User: 
X-HE-Tag: 1775485327-393564
X-HE-Meta: U2FsdGVkX18XUDfTJSeWCkcy3lnsbI6kfWHJbZUJua9ZLyBbWeeK7f76AXgeV71Lwuexk8VLUw13KLRI3OGQvMOOkmUK+uxlI1J04R6jU1MtgQXWV2pbpVT01IBA6+Xm4Oq3MSTGIhTGq30avuDjUkNOk2Fw+6Yrpd8iFNwz7w2yG7vMo8h/sqKsI6pg0BHpSebqW2RFVwvGXGuVzNI7pbNzTjyh1hDfdMn72/wk+ac+gz5g183vbAV1AjIHaP0+Cc4v+SQ7Aro3sY4mqFVfn7CnFNKM+NrmBKxC3z9BHNjYmllmyNFsPcTvpIteXthnWqX4tpk+Xp4ChwnyUdvNQtLTNA3EZeSrLV30SnET2yEnFTeX+LiESANOLnco1a32LAx+ruTVJWgT0iwDhocHfRwAPzUIiWQSFfN8TJl/POtpqY8N08iFIxlZ4uBdc2ve2fDk20FhzsDEjUfIoJXiOiHdpddxnkeXG+IrHJu5+ouO+pzuHQMVigNet8LXKbcUlTVicMQyMh0PhhCX4DSDT0PAAux2sHim/J0CWzj89lIo/v8d9u5J20dKwRcnI6g6RVaMcw25+iUUnSuA8kt+KWZ+J/+Mj6Tu6sh26KYV1q/xenhuRxFHflgOtOG8LyGUQYRnvbEkfai7zW3D9TWCKwOpcJhvwDhjdDYTwnpxLztCA2+jGSFVui9tACGHMkwuZfl0z/n3wZlZHPXjmTxsJmW19npRj/TGHGNhZow2StzIj9M61wGsWQ/Z1cAhhBhqpCFrhUsPBxHADXseoAVBk1j0Tgf40ISyLPQUsjpWJ3aq8gz7+0ci1f18l8q6cBpIB4V3Uv0Hx+mPip08fMtTAch13IElRaYrYmDfbU5bnr9f/+0uUNzouF789YsUTLmODDQLFESZwqkGpCBQRGKU0ES2EY269eG9k7bZesdxL86EYlhzic71hrxVkJODoQhsMiW3Kro9VXOcN8Rd6Sm
 VUyudcAX
 eQ8sczKakcC5fgQABzbKH6rg3iGvH39JOR/9vjpolwTdY8LrmfCM+7fXiv/1usT5OpXbfhXdHGS4HXtIqs0eC6wxqKWSbpdsNKcXMpRqVMSY6w66H9x2+Csoa3svquNpRF5wjUx1HWbh3AbpElfItOrTo/a5GRfjdAut1TXszq0DPHIlRKvJinMYuzPvcbEEZlB3R5lo7RWmjTlKUaLKG5qi0z0U3H++3oUpvAYIVFZF8U4yicYos76+z5FoGRolfGZ7hGYK3l+spq1ZxeWXo1G9AuQ==
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


