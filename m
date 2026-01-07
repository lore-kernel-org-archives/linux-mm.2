Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD059D0D143
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 16:49:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67CBE6B0099; Wed,  7 Jan 2026 11:49:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E6346B009B; Wed,  7 Jan 2026 11:49:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 452576B009D; Wed,  7 Jan 2026 11:49:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2EE576B0099
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 11:49:01 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CE927B87F4
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 16:49:00 +0000 (UTC)
X-FDA: 84305752440.02.DF9E4DB
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 364F3100007
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 16:48:59 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767804539; a=rsa-sha256;
	cv=none;
	b=02/kbjfpLCiTMC5Zu7X7EmefIwYcnaTJfaDJA7N4KdLFo8TiuMb7ZU+S3Xj7wjWCw7z+gX
	sOcTXs+9eVv4iFeBT+i4rW/Fns0LjpZbW4oDAGmvmifw2AwbNuyT05HaW4SR/ZB1mBCeG9
	cyUO708SNGxJGV8ynw/vzIq696Tp+Nc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767804539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SkZj0dPY3n8EAH1cWcHwyk27DW9K23otGzxdykp1f6Y=;
	b=owX5FT5IZAWbz4yOkaMAbboQUss7tI1hWIPWQP4cJJTx//EyM/p+QelgiGjUjYujjgGyyD
	nhhbOMBpvTx+bmjByeA1glZXU8Mew68iu60dNQPyFcOr4X3pjpIj164dwZc0B1fA7lXz+D
	oe2tylR23LMu6KNUQP9lFQEZ5LtWevk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 094C11684;
	Wed,  7 Jan 2026 08:48:52 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 986943F5A1;
	Wed,  7 Jan 2026 08:48:57 -0800 (PST)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Mark Brown <broonie@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>
Subject: [PATCH v2 5/8] selftests/mm: introduce helper to read every page in range
Date: Wed,  7 Jan 2026 16:48:39 +0000
Message-ID: <20260107164842.3289559-6-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260107164842.3289559-1-kevin.brodsky@arm.com>
References: <20260107164842.3289559-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 364F3100007
X-Stat-Signature: 9sepcb8u5nwg4sbsycp74ecbre81ixi5
X-Rspam-User: 
X-HE-Tag: 1767804539-685941
X-HE-Meta: U2FsdGVkX1/l7B5U043Jgg2heLAi6LPn4TmidfbfTyPS8Aj1DolPz/BQpHEvPhkU9hULaKsK9cAyz+jk797tMQEqKG+gynWPkINXtJw9a6Y/N92+sWw9ptf6uyIwgL8L07FfsZjAtsZjqzs5oJm8+Sxvo7BGW6Qz/uCwAFlKutzRNNX2j5wnMjxpYwJMH0uduHb2NtJ+iUrg5vyzHrtOYR8Ox1ou9FHtezabHCmnm6yuttctVUrePkGCczRYbg1paXmr9I8iDMq7exP7eJCztd/jmvL6m/v64vGFrtSxxm05AM279VYaG1NMGq3XnuxPjR7zmGnjOIG4oGRGFNxYpJmo+fyTaBdWs4Ydz73Qu01oRFV1uAU2kbiAv0KkcrrCAqiRHTaAqBAyyJXn5PrqI3QFknAawx+VdbTqpXwmU8yH3occE4fMKX5uM+G98vgCd97/RKRx2ZnD8TmiY6/kQ4Q/zYjJ5VVzcdowkzChc+koyViIlHnrKFb5/4IyJKA6fcrIpRIcbcT4HrcYGgoAunyfbEfmY7iIF98YUATpuUDGAtGid1JMH36gIHbnYzJ+ii8y3/tyP9RLFnAg56nFvs8zGIYX3dUVcR4l5GdVWaJ1Yh/OB+eM63AUHnWwxcBBb0Mbybt2mHWi2BufPib5BPSXg5qlzhIEdKBjyE0A2yCbKvNdhTUcI4fOVIUoVqm4uR/WHVK/SSO7H+CCQljpMCsuYVV/8g6FiUxmOONsjcnLmTW1tIz5/E1pLKv5xbtosztAjM3f32Qc9MyYKrKQHngDWTHbwo4QJ91w3DdX78YwMv8w11E/sHDYnVAd4Y7D+7oRJvNGPAoloC4Sa6wn0eS+C3+zcNOCF4SeO0IZd4GyXHdcq9Vaeg3U5L/8IxeUJ89/n32Hp1F3aNsvVniGWwTE1S/t2Evr3CoDI8DhrQ9fFestz6B5ulug5mLqupDAQOzfiUPAWp9XYWm1yIU
 rUWQCg7b
 zg1+SmDBsNAinfnCovyxBiuc5i7Yi0K36L9on1ANunDCXVS9i9uDp0tjsiWmWa3oumi7qs5gUjV7J5O/s0gXfBXM0wb8S5dd5wWCTSVfqUuoAxiXM3HSOkckrEvIZJ0IKK9/2gqupdeKCYROiJ2Lig+XPVQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

FORCE_READ(*addr) ensures that the compiler will emit a load from
addr. Several tests need to trigger such a load for every page in
the range [addr, addr + len), ensuring that every page is faulted
in, if it wasn't already.

Introduce a new helper force_read_pages_in_range() that does exactly
that and replace existing loops with a call to it. Some of those
loops have a different step size, but reading from every page is
appropriate in all cases.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 tools/testing/selftests/mm/hugetlb-madvise.c     |  9 +--------
 tools/testing/selftests/mm/pfnmap.c              | 16 ++++++----------
 .../testing/selftests/mm/split_huge_page_test.c  |  6 +-----
 tools/testing/selftests/mm/vm_util.h             |  6 ++++++
 4 files changed, 14 insertions(+), 23 deletions(-)

diff --git a/tools/testing/selftests/mm/hugetlb-madvise.c b/tools/testing/selftests/mm/hugetlb-madvise.c
index 05d9d2805ae4..1f82568ae262 100644
--- a/tools/testing/selftests/mm/hugetlb-madvise.c
+++ b/tools/testing/selftests/mm/hugetlb-madvise.c
@@ -47,14 +47,7 @@ void write_fault_pages(void *addr, unsigned long nr_pages)
 
 void read_fault_pages(void *addr, unsigned long nr_pages)
 {
-	unsigned long i;
-
-	for (i = 0; i < nr_pages; i++) {
-		unsigned long *addr2 =
-			((unsigned long *)(addr + (i * huge_page_size)));
-		/* Prevent the compiler from optimizing out the entire loop: */
-		FORCE_READ(*addr2);
-	}
+	force_read_pages_in_range(addr, nr_pages * huge_page_size);
 }
 
 int main(int argc, char **argv)
diff --git a/tools/testing/selftests/mm/pfnmap.c b/tools/testing/selftests/mm/pfnmap.c
index f546dfb10cae..35b0e3ed54cd 100644
--- a/tools/testing/selftests/mm/pfnmap.c
+++ b/tools/testing/selftests/mm/pfnmap.c
@@ -33,20 +33,17 @@ static void signal_handler(int sig)
 	siglongjmp(sigjmp_buf_env, -EFAULT);
 }
 
-static int test_read_access(char *addr, size_t size, size_t pagesize)
+static int test_read_access(char *addr, size_t size)
 {
-	size_t offs;
 	int ret;
 
 	if (signal(SIGSEGV, signal_handler) == SIG_ERR)
 		return -EINVAL;
 
 	ret = sigsetjmp(sigjmp_buf_env, 1);
-	if (!ret) {
-		for (offs = 0; offs < size; offs += pagesize)
-			/* Force a read that the compiler cannot optimize out. */
-			*((volatile char *)(addr + offs));
-	}
+	if (!ret)
+		force_read_pages_in_range(addr, size);
+
 	if (signal(SIGSEGV, SIG_DFL) == SIG_ERR)
 		return -EINVAL;
 
@@ -138,7 +135,7 @@ FIXTURE_SETUP(pfnmap)
 		SKIP(return, "Invalid file: '%s'. Not pfnmap'ed\n", file);
 
 	/* ... and want to be able to read from them. */
-	if (test_read_access(self->addr1, self->size1, self->pagesize))
+	if (test_read_access(self->addr1, self->size1))
 		SKIP(return, "Cannot read-access mmap'ed '%s'\n", file);
 
 	self->size2 = 0;
@@ -243,8 +240,7 @@ TEST_F(pfnmap, fork)
 	ASSERT_GE(pid, 0);
 
 	if (!pid) {
-		EXPECT_EQ(test_read_access(self->addr1, self->size1,
-					   self->pagesize), 0);
+		EXPECT_EQ(test_read_access(self->addr1, self->size1), 0);
 		exit(0);
 	}
 
diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index 40799f3f0213..65a89ceca4a5 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -652,11 +652,7 @@ static int create_pagecache_thp_and_fd(const char *testfile, size_t fd_size,
 	}
 	madvise(*addr, fd_size, MADV_HUGEPAGE);
 
-	for (size_t i = 0; i < fd_size; i++) {
-		char *addr2 = *addr + i;
-
-		FORCE_READ(*addr2);
-	}
+	force_read_pages_in_range(*addr, fd_size);
 
 	if (!check_huge_file(*addr, fd_size / pmd_pagesize, pmd_pagesize)) {
 		ksft_print_msg("No large pagecache folio generated, please provide a filesystem supporting large folio\n");
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index 6ad32b1830f1..74bdf96161d7 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -54,6 +54,12 @@ static inline unsigned int pshift(void)
 	return __page_shift;
 }
 
+static inline void force_read_pages_in_range(char *addr, size_t len)
+{
+	for (size_t i = 0; i < len; i += psize())
+		FORCE_READ(addr[i]);
+}
+
 bool detect_huge_zeropage(void);
 
 /*
-- 
2.51.2


