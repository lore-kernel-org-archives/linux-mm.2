Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF4A2D3EE92
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 17:02:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E12F6B02C4; Thu, 22 Jan 2026 12:02:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D62C6B02C6; Thu, 22 Jan 2026 12:02:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 098F56B02C7; Thu, 22 Jan 2026 12:02:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E20016B02C4
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 12:02:46 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B169B8BAE7
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 17:02:46 +0000 (UTC)
X-FDA: 84360219132.13.BF5B487
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id 124BDA0027
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 17:02:44 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf15.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769101365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TCHZ8j2ex12Nm8K214qlGHp2dEP9X/oexmEgiv2ymw4=;
	b=reU80BFAh9Ovtbn48367LpTiJkDhHYeps8LUaCgrZFdL2WOj4EbbBIHX+eW3LV2lC6uL9p
	9zljaSy/33V6i6qhh0ycOXLK8XMu9YNF95RcXJZBH+GDCATSG0IQheIIfWYbv4MiBYuGZm
	FMZotFR+0zMXvGt2jKIm/wgpYfHbuoI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf15.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769101365; a=rsa-sha256;
	cv=none;
	b=H7URHzlLDQChOkSPBSQoLCnKO0orzp7rBnmvMsci6bBhm6RRnPZqPJaeKNcVNw5WvisrX2
	CqyT8G8sdNtezl+d8poA4oPRA+jHZefXCsN+8P0zLwvYrpy8DeemVn2dwkdVcfND9pyWrY
	Wnuzrskc4NSFUL8oMjF9RtglOuimZm8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1813D1476;
	Thu, 22 Jan 2026 09:02:38 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4F9203F632;
	Thu, 22 Jan 2026 09:02:43 -0800 (PST)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Mark Brown <broonie@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>
Subject: [PATCH v3 6/9] selftests/mm: introduce helper to read every page
Date: Thu, 22 Jan 2026 17:02:21 +0000
Message-ID: <20260122170224.4056513-7-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260122170224.4056513-1-kevin.brodsky@arm.com>
References: <20260122170224.4056513-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 124BDA0027
X-Stat-Signature: fnne3ctu37a6g5u9stha5eg1hp9sydzh
X-Rspam-User: 
X-HE-Tag: 1769101364-95258
X-HE-Meta: U2FsdGVkX18le0F2C2P3VGKxK+3gUv2Y4bDNKdlIXfqbcdV+jambOYbZEKl7U4F7Q5ua0u5AUZBGjyf/jBY/fv2+7BeAFikLUrqRfUg4P2elvfNfTQPBganwVdA/P8WWPeNJUnfcNA+5tcyKDb4qInG/l37zKvtCQ8oEsjkKAdzT9iZOrOUPUYE6/KutvnmMHp/Ykz5pPRP2gyMEVOHvpjpqwEBh7GHukr3GN1IOw7HzIqFh4Ht995DKwrhJIxLXDVH5sXjiUJlhGS45dIA+4FNwoQHWW+vBfvyCRbW6qnmIUv2gH5Yf/mrp7FkThUP57YdJmp9SmmZ5VjcpX4ltYr028BJTMoU5BX/DoSwZRRpK+id6c3OtIWshNsl6UuRQ2/8aCVCh01S+1FVm8b9HzCGv4+cSjSHIL7ypYRnlqMR1/k9ZHQV7yBg3ioh+XeG17oeXnJPTjM5oWBRTBEw9sPCeRolRWXvXYTVYgoITzGZfIVlqQFBUKETxqapuaaIzJ1dfGV4CwUwNYDDxMibUvw4MtGCUgdlLpY+oDaQ3HMCvdAwp5mhiQJ9cQ+gWIIW+yhe3apwmmmSYlCE1yumPvi8kwLUI00LRrIUZA4hN23f0ZYsnplhkbTERnXKL5YVW1wymG7EuGINsKCThKONE15OEbzvjx28EpD2EWvJFa/iIve/7WqR1qZiD7awCz2IsrRYim+37rmZln9asvU6UV1HZFXbfoi6n2PYyeTmyyHohhQmiQ2vRS8vYBylbgNZlun8a6xiEVtAJ8KnA82S24T204A/1HgcMfZstDp1GUdLZPWIukj8amLu4IEtUC5tla3dlwj/UGXKFEJryj4vnpyCBNfKgYMIFn+aMtqqy/fIuO04YMo7JCY1KF6laFcfeCSyb08rrI+8zYFFHbDBXnco8YzfgM4gDUYOHFoXPNvo/0oj6U/Rs++YbTdQZPBlPIRZElMiKcZzW4y3/Z13
 11bJ2taK
 AyzhDSi0mee/lvhrG26nYOJxj7YRkaSY9RdP9QmSVtVnpoWUw2zo/rMapYFq5h/I/SKtQX7wdlnLWH869Pa/0A2zUdkFzmwsyLkWxi8U6udg5P30mXrWjx1e9NkpPUgn9y+oTojxjXarOr+wcxlIV9gSXoA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

FORCE_READ(*addr) ensures that the compiler will emit a load from
addr. Several tests need to trigger such a load for a range of
pages, ensuring that every page is faulted in, if it wasn't already.

Introduce a new helper force_read_pages() that does exactly that and
replace existing loops with a call to it.

The step size (regular/huge page size) is preserved for all loops,
except in split_huge_page_test. Reading every byte is unnecessary;
we now read every huge page, matching the following call to
check_huge_file().

Reviewed-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 tools/testing/selftests/mm/hugetlb-madvise.c      | 9 +--------
 tools/testing/selftests/mm/pfnmap.c               | 9 +++------
 tools/testing/selftests/mm/split_huge_page_test.c | 6 +-----
 tools/testing/selftests/mm/vm_util.h              | 7 +++++++
 4 files changed, 12 insertions(+), 19 deletions(-)

diff --git a/tools/testing/selftests/mm/hugetlb-madvise.c b/tools/testing/selftests/mm/hugetlb-madvise.c
index 05d9d2805ae4..5b12041fa310 100644
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
+	force_read_pages(addr, nr_pages, huge_page_size);
 }
 
 int main(int argc, char **argv)
diff --git a/tools/testing/selftests/mm/pfnmap.c b/tools/testing/selftests/mm/pfnmap.c
index f546dfb10cae..45b5f1cf6019 100644
--- a/tools/testing/selftests/mm/pfnmap.c
+++ b/tools/testing/selftests/mm/pfnmap.c
@@ -35,18 +35,15 @@ static void signal_handler(int sig)
 
 static int test_read_access(char *addr, size_t size, size_t pagesize)
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
+		force_read_pages(addr, size/pagesize, pagesize);
+
 	if (signal(SIGSEGV, SIG_DFL) == SIG_ERR)
 		return -EINVAL;
 
diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index 40799f3f0213..e0167111bdd1 100644
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
+	force_read_pages(*addr, fd_size / pmd_pagesize, pmd_pagesize);
 
 	if (!check_huge_file(*addr, fd_size / pmd_pagesize, pmd_pagesize)) {
 		ksft_print_msg("No large pagecache folio generated, please provide a filesystem supporting large folio\n");
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index 6ad32b1830f1..522f7f9050f5 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -54,6 +54,13 @@ static inline unsigned int pshift(void)
 	return __page_shift;
 }
 
+static inline void force_read_pages(char *addr, unsigned int nr_pages,
+				    size_t pagesize)
+{
+	for (unsigned int i = 0; i < nr_pages; i++)
+		FORCE_READ(addr[i * pagesize]);
+}
+
 bool detect_huge_zeropage(void);
 
 /*
-- 
2.51.2


