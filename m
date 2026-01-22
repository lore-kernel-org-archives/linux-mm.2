Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1B1ED6CFA1
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 18:26:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F195C6B02FA; Thu, 22 Jan 2026 13:26:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE1226B02FC; Thu, 22 Jan 2026 13:26:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E38196B02FD; Thu, 22 Jan 2026 13:26:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D0EEE6B02FA
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 13:26:01 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 65C228BA69
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 18:26:01 +0000 (UTC)
X-FDA: 84360428922.04.E5532DB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8B43B180003
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 18:25:59 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DOsG1sDg;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769106359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K0vA8huMqVVIPgi0LNLE6n5XQ3xN6ZIE5i2JvwAkQXE=;
	b=Z4asS/Z2VoKNjeZqfc3B7yCafvc196R3YnG1OG82okUh5TqN+/NNvjCImdAROvc86cdJ+L
	lv3O3dfsB/g54h1aC6Th7V1ToYicIK5k6CxK17PJGHp7AOSHgINlidm+aMye3gPrVDVy/0
	z4e4aPcKRgKFL5hB2m8pG4aUVZqy19Y=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DOsG1sDg;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769106359; a=rsa-sha256;
	cv=none;
	b=NAtuzx9A/rANq2bIiNKVtvUza2a74iJmD8NOA/FTxq9ihWPI09FyBWOCjBozLsRNLeECrZ
	fRp3PqqqEIh8BPEL9KTCNma3dZTZAj5/KyxaPI/i0r1yNO5AWi7hfn65U9xo8IzAd5nBFK
	j1vkXN7r15HAl/1KCXXyn8t7TEOY65c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7C82243EEF;
	Thu, 22 Jan 2026 18:25:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09F9BC116C6;
	Thu, 22 Jan 2026 18:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769106358;
	bh=aLh8CjwfgGPV7i0+bwwtdSqKhoqStOVsDlLu0vdphXo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=DOsG1sDgSWjT9DPOgMH1zR1BgIEzstzAUeTXSKwKKsfsDyVQ2oWWwVhFLXN+ZFGK3
	 vFI5lpLDlNE6TSg2vEPqDJbmhRzz2AT8XvSnSXmmPL6rOYxpjPyLqrRG5lb8pgFNKX
	 X9viiUZLcF8X7Z2Ma6SQ87A3kxEF/Te2YtKxdFbk=
Date: Thu, 22 Jan 2026 10:25:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, David Hildenbrand <david@kernel.org>, Dev
 Jain <dev.jain@arm.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Mark
 Brown <broonie@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, Shuah Khan
 <shuah@kernel.org>
Subject: Re: [PATCH v3 0/9] Various mm kselftests improvements/fixes
Message-Id: <20260122102557.991604188ed67b59baab60c5@linux-foundation.org>
In-Reply-To: <20260122170224.4056513-1-kevin.brodsky@arm.com>
References: <20260122170224.4056513-1-kevin.brodsky@arm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8B43B180003
X-Stat-Signature: pezkeca186bxfoherreq5f9xw1ygjzrk
X-Rspam-User: 
X-HE-Tag: 1769106359-757250
X-HE-Meta: U2FsdGVkX18nMPTowVMJvnWQe1cPdr6GuHzG1nxzXiWpu0DB1aFnrQUUxJf3Ph1MP7J02jJot55Hu1wN2hqlkwGaOLwFX5qa7NqRNR/wPvgTCskLMkOxk2RBW2iqwaxffUmMJ7qI6EjWp9rqmQiaKqdNHBulpElwi2iCTkQdvutSLKQQfHNRiZzYAyXs6fEQEQCrSs66srbLmb2Z3J/nbR2ysdq4lOmAV7g+AClDnyEnKFRa3NQFy99YcLVNme78kA4YFpNeycshMhcC0QTk/K8WeLbd1t4FD/HFFNhst3VN19nahgAjkF0ZZ72RZyT/UctqwpL/6PEyT/LGuiVgPgWA5lSaF4d+pef5w78jGjfUgc3rKyBtR0N6+iTScu/MJJujwpMYQVkS8krimxQQZ4GXJ2PtG+3QVRB7if2CaH73bNJ3gmaaT4QeXQ4UG8JZSS4Q/LzeBvT4+vGS7SuIM+vtlyoY5SGvVHSCfwcn1byuYy0mkPP2KB/3tO9ucHJWjkzwJsvx/DHjMcmhEB8RodXLBpHhoa4akiNLAQ3JfNz+f5YeiyEia3eyBHahHFVmSWTqChwXXd1tgdNcvdwhxvkvtcvQPq5CaouVdD2UcI06A8RbQC2e1WfaZAw8OyWQzlxuG9LJGa/3KDazP/Q5LsV+gBDcBR8Aoi4Acd3t0ytZ0dVSi/IfbVlbCHIQpoqbOZEGV1VbzOsWmZdn9+HPH99GT4+i0VDuvdhBs23V2TmVCYxN+Blu1U+t2C7+T64XyGJ65AkApwhphopCDmFIhXvPjZ09DqHbNIKUBbnw2Qq3IkL/LMAAEKF90Gslw4ZO05nMqU9v+WmaArAu/zktOssJngy8PEbxB5xVIDqahwUV/o2Qt8oJHb/MO2efSSRF5iumIPsTMXMeh1+UpXidIEwFqCjFKeGHG33SGexQwt8J7zA9U6hHP8GIUOjZ8pkiIPgTmvoLWVL8Biq4UYz
 vxM1ZPw5
 2T9OJXCTuPMEo34+9cYKViSmBh75xNRs8cFdTEmskeevs0HaX+MAboRHcDxGfnpbPiVXkPhvXi7QoSg03RadReLAnlJKoi1SC1AmeeR5cDMNK2328+7PW9g2tx3N/PjQvMNYcUe3tBnLunfh5vFMIW48LGW3Z2f4GkYK0DtFE5t9RzaP9nSJgRP2X2s9Y4jWCoP3XRHO++7nYs3R48+Z+Zn9zk1Gjyh3jKVpWTuu7ANyXYykM/D51pVYlH6O8QRVu1S9M39aEhsxXNwebl3/9VNd7j3faxVQUeE6OaJ4civT6zYtLYrW2/1Gdqw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 22 Jan 2026 17:02:15 +0000 Kevin Brodsky <kevin.brodsky@arm.com> wrote:

> Various improvements/fixes for the mm kselftests:
> 
> - Patch 1-3 extend support for more build configurations: out-of-tree
>   $KDIR, cross-compilation, etc.
> 
> - Patch 4-7 fix issues related to faulting in pages, introducing a new
>   helper for that purpose.
> 
> - Patch 8 fixes the value returned by pagemap_ioctl (PASS was always
>   returned, which explains why the issue fixed in patch 6 went
>   unnoticed).
> 
> - Patch 9 improves the exit code of pfnmap.
> 
> Net results:
> - 1 test no longer fails (patch 7)
> - 3 tests are no longer skipped (patch 4)
> - More accurate return values for whole suites (patch 8, 9)
> - Extra tests are more likely to be built (patch 1-3)

Updated, thanks.

> ---
> v2..v3:
> - Patch 5: new patch [David Hildenbrand]
> - Patch 6: make the helper take a number of pages + pagesize, rename to
>   force_read_pages() [David]
> - Patch 7: improved page count calculation (avoiding floating-point
>   helper)
> - Patch 7: added Fixes tag [David]
> - Patch 9: open the file only once and save the fd [David]
> - Collected R-b/A-b
> 

Below is how v3 altered mm.git:


--- a/tools/testing/selftests/mm/cow.c~b
+++ a/tools/testing/selftests/mm/cow.c
@@ -75,6 +75,18 @@ static bool range_is_swapped(void *addr,
 	return true;
 }
 
+static bool populate_page_checked(char *addr)
+{
+	bool ret;
+
+	FORCE_READ(*addr);
+	ret = pagemap_is_populated(pagemap_fd, addr);
+	if (!ret)
+		ksft_print_msg("Failed to populate page\n");
+
+	return ret;
+}
+
 struct comm_pipes {
 	int child_ready[2];
 	int parent_ready[2];
@@ -1549,8 +1561,10 @@ static void run_with_zeropage(non_anon_t
 	}
 
 	/* Read from the page to populate the shared zeropage. */
-	FORCE_READ(*mem);
-	FORCE_READ(*smem);
+	if (!populate_page_checked(mem) || !populate_page_checked(smem)) {
+		log_test_result(KSFT_FAIL);
+		goto munmap;
+	}
 
 	fn(mem, smem, pagesize);
 munmap:
@@ -1612,8 +1626,11 @@ static void run_with_huge_zeropage(non_a
 	 * the first sub-page and test if we get another sub-page populated
 	 * automatically.
 	 */
-	FORCE_READ(*mem);
-	FORCE_READ(*smem);
+	if (!populate_page_checked(mem) || !populate_page_checked(smem)) {
+		log_test_result(KSFT_FAIL);
+		goto munmap;
+	}
+
 	if (!pagemap_is_populated(pagemap_fd, mem + pagesize) ||
 	    !pagemap_is_populated(pagemap_fd, smem + pagesize)) {
 		ksft_test_result_skip("Did not get THPs populated\n");
@@ -1663,8 +1680,10 @@ static void run_with_memfd(non_anon_test
 	}
 
 	/* Fault the page in. */
-	FORCE_READ(*mem);
-	FORCE_READ(*smem);
+	if (!populate_page_checked(mem) || !populate_page_checked(smem)) {
+		log_test_result(KSFT_FAIL);
+		goto munmap;
+	}
 
 	fn(mem, smem, pagesize);
 munmap:
@@ -1719,8 +1738,10 @@ static void run_with_tmpfile(non_anon_te
 	}
 
 	/* Fault the page in. */
-	FORCE_READ(*mem);
-	FORCE_READ(*smem);
+	if (!populate_page_checked(mem) || !populate_page_checked(smem)) {
+		log_test_result(KSFT_FAIL);
+		goto munmap;
+	}
 
 	fn(mem, smem, pagesize);
 munmap:
@@ -1773,8 +1794,10 @@ static void run_with_memfd_hugetlb(non_a
 	}
 
 	/* Fault the page in. */
-	FORCE_READ(*mem);
-	FORCE_READ(*smem);
+	if (!populate_page_checked(mem) || !populate_page_checked(smem)) {
+		log_test_result(KSFT_FAIL);
+		goto munmap;
+	}
 
 	fn(mem, smem, hugetlbsize);
 munmap:
--- a/tools/testing/selftests/mm/hugetlb-madvise.c~b
+++ a/tools/testing/selftests/mm/hugetlb-madvise.c
@@ -47,7 +47,7 @@ void write_fault_pages(void *addr, unsig
 
 void read_fault_pages(void *addr, unsigned long nr_pages)
 {
-	force_read_pages_in_range(addr, nr_pages * huge_page_size);
+	force_read_pages(addr, nr_pages, huge_page_size);
 }
 
 int main(int argc, char **argv)
--- a/tools/testing/selftests/mm/pagemap_ioctl.c~b
+++ a/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -1052,7 +1052,7 @@ static void test_simple(void)
 int sanity_tests(void)
 {
 	unsigned long long mem_size, vec_size;
-	long ret, fd, i, buf_size;
+	long ret, fd, i, buf_size, nr_pages;
 	struct page_region *vec;
 	char *mem, *fmem;
 	struct stat sbuf;
@@ -1166,13 +1166,14 @@ int sanity_tests(void)
 	if (fmem == MAP_FAILED)
 		ksft_exit_fail_msg("error nomem %d %s\n", errno, strerror(errno));
 
-	force_read_pages_in_range(fmem, sbuf.st_size);
+	nr_pages = (sbuf.st_size + page_size - 1) / page_size;
+	force_read_pages(fmem, nr_pages, page_size);
 
 	ret = pagemap_ioctl(fmem, sbuf.st_size, vec, vec_size, 0, 0,
 			    0, PAGEMAP_NON_WRITTEN_BITS, 0, PAGEMAP_NON_WRITTEN_BITS);
 
 	ksft_test_result(ret >= 0 && vec[0].start == (uintptr_t)fmem &&
-			 LEN(vec[0]) == ceilf((float)sbuf.st_size/page_size) &&
+			 LEN(vec[0]) == nr_pages &&
 			 (vec[0].categories & PAGE_IS_FILE),
 			 "%s Memory mapped file\n", __func__);
 
--- a/tools/testing/selftests/mm/pfnmap.c~b
+++ a/tools/testing/selftests/mm/pfnmap.c
@@ -30,13 +30,14 @@
 static sigjmp_buf sigjmp_buf_env;
 static char *file = "/dev/mem";
 static off_t file_offset;
+static int fd;
 
 static void signal_handler(int sig)
 {
 	siglongjmp(sigjmp_buf_env, -EFAULT);
 }
 
-static int test_read_access(char *addr, size_t size)
+static int test_read_access(char *addr, size_t size, size_t pagesize)
 {
 	int ret;
 
@@ -45,7 +46,7 @@ static int test_read_access(char *addr,
 
 	ret = sigsetjmp(sigjmp_buf_env, 1);
 	if (!ret)
-		force_read_pages_in_range(addr, size);
+		force_read_pages(addr, size/pagesize, pagesize);
 
 	if (signal(SIGSEGV, SIG_DFL) == SIG_ERR)
 		return -EINVAL;
@@ -104,7 +105,6 @@ static void pfnmap_init(void)
 {
 	size_t pagesize = getpagesize();
 	size_t size = DEV_MEM_NPAGES * pagesize;
-	int fd;
 	void *addr;
 
 	if (strncmp(file, "/dev/mem", strlen("/dev/mem")) == 0) {
@@ -117,16 +117,16 @@ static void pfnmap_init(void)
 		file_offset = 0;
 	}
 
-	/*
-	 * Make sure we can open and map the file, and perform some basic
-	 * checks; skip the whole suite if anything goes wrong.
-	 * A fresh mapping is then created for every test case by
-	 * FIXTURE_SETUP(pfnmap).
-	 */
 	fd = open(file, O_RDONLY);
 	if (fd < 0)
 		ksft_exit_skip("Cannot open '%s': %s\n", file, strerror(errno));
 
+	/*
+	 * Make sure we can map the file, and perform some basic checks; skip
+	 * the whole suite if anything goes wrong.
+	 * A fresh mapping is then created for every test case by
+	 * FIXTURE_SETUP(pfnmap).
+	 */
 	addr = mmap(NULL, size, PROT_READ, MAP_SHARED, fd, file_offset);
 	if (addr == MAP_FAILED)
 		ksft_exit_skip("Cannot mmap '%s': %s\n", file, strerror(errno));
@@ -134,17 +134,15 @@ static void pfnmap_init(void)
 	if (!check_vmflag_pfnmap(addr))
 		ksft_exit_skip("Invalid file: '%s'. Not pfnmap'ed\n", file);
 
-	if (test_read_access(addr, size))
+	if (test_read_access(addr, size, pagesize))
 		ksft_exit_skip("Cannot read-access mmap'ed '%s'\n", file);
 
 	munmap(addr, size);
-	close(fd);
 }
 
 FIXTURE(pfnmap)
 {
 	size_t pagesize;
-	int dev_mem_fd;
 	char *addr1;
 	size_t size1;
 	char *addr2;
@@ -155,12 +153,9 @@ FIXTURE_SETUP(pfnmap)
 {
 	self->pagesize = getpagesize();
 
-	self->dev_mem_fd = open(file, O_RDONLY);
-	ASSERT_GE(self->dev_mem_fd, 0);
-
 	self->size1 = DEV_MEM_NPAGES * self->pagesize;
 	self->addr1 = mmap(NULL, self->size1, PROT_READ, MAP_SHARED,
-			   self->dev_mem_fd, file_offset);
+			   fd, file_offset);
 	ASSERT_NE(self->addr1, MAP_FAILED);
 
 	self->size2 = 0;
@@ -173,8 +168,6 @@ FIXTURE_TEARDOWN(pfnmap)
 		munmap(self->addr2, self->size2);
 	if (self->addr1 != MAP_FAILED)
 		munmap(self->addr1, self->size1);
-	if (self->dev_mem_fd >= 0)
-		close(self->dev_mem_fd);
 }
 
 TEST_F(pfnmap, madvise_disallowed)
@@ -214,7 +207,7 @@ TEST_F(pfnmap, munmap_split)
 	 */
 	self->size2 = self->pagesize;
 	self->addr2 = mmap(NULL, self->pagesize, PROT_READ, MAP_SHARED,
-			   self->dev_mem_fd, file_offset);
+			   fd, file_offset);
 	ASSERT_NE(self->addr2, MAP_FAILED);
 }
 
@@ -265,7 +258,8 @@ TEST_F(pfnmap, fork)
 	ASSERT_GE(pid, 0);
 
 	if (!pid) {
-		EXPECT_EQ(test_read_access(self->addr1, self->size1), 0);
+		EXPECT_EQ(test_read_access(self->addr1, self->size1,
+					   self->pagesize), 0);
 		exit(0);
 	}
 
--- a/tools/testing/selftests/mm/split_huge_page_test.c~b
+++ a/tools/testing/selftests/mm/split_huge_page_test.c
@@ -652,7 +652,7 @@ static int create_pagecache_thp_and_fd(c
 	}
 	madvise(*addr, fd_size, MADV_HUGEPAGE);
 
-	force_read_pages_in_range(*addr, fd_size);
+	force_read_pages(*addr, fd_size / pmd_pagesize, pmd_pagesize);
 
 	if (!check_huge_file(*addr, fd_size / pmd_pagesize, pmd_pagesize)) {
 		ksft_print_msg("No large pagecache folio generated, please provide a filesystem supporting large folio\n");
--- a/tools/testing/selftests/mm/vm_util.h~b
+++ a/tools/testing/selftests/mm/vm_util.h
@@ -54,10 +54,11 @@ static inline unsigned int pshift(void)
 	return __page_shift;
 }
 
-static inline void force_read_pages_in_range(char *addr, size_t len)
+static inline void force_read_pages(char *addr, unsigned int nr_pages,
+				    size_t pagesize)
 {
-	for (size_t i = 0; i < len; i += psize())
-		FORCE_READ(addr[i]);
+	for (unsigned int i = 0; i < nr_pages; i++)
+		FORCE_READ(addr[i * pagesize]);
 }
 
 bool detect_huge_zeropage(void);
_


