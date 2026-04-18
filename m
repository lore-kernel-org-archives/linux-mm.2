Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59A65F99C79
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 10:56:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD7786B020A; Sat, 18 Apr 2026 06:56:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B885F6B020C; Sat, 18 Apr 2026 06:56:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A76DC6B020D; Sat, 18 Apr 2026 06:56:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 927446B020A
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 06:56:46 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 29070E448A
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:56:46 +0000 (UTC)
X-FDA: 84671373612.13.E98753B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 97718A0004
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:56:44 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BEfPSxfC;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776509804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9nZdanyW5oOa7Fn6KSmtBLHR73Jf+3Ad1YwMcLj00Wk=;
	b=ZmD81pbA4fxSj7rHiex+oPZ3HMj4TPlP6nYhXCzJ5pSscz0dXsnVWb081SdcWXt67fHUh/
	NzMAs0vR6H2IsMJlV95OdN21eDyTLFZfObRQJpKCvTzZC3oLPoB/uGWjB4TcuBHCosQRIo
	MVSeq2tKYN4VIjrG8aMDFAOouHTf69U=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BEfPSxfC;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776509804; a=rsa-sha256;
	cv=none;
	b=aQB1B3SClKNM599djxzXliu2wpgHa78eoD78jszNnQW61CLx4TsCPTZjYoC0hBxr9kvKE/
	j1+sBnTI6+VyUCvcS/iOacZb+L9PjdGBw4KfmrCFD0f5hm1cejG0vqlSY3WeFccWr+ZWy3
	VrZPzZr3LibtWI3tzdj4PgGf6nKCqGc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 120BC60138;
	Sat, 18 Apr 2026 10:56:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20033C19424;
	Sat, 18 Apr 2026 10:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776509803;
	bh=RPP2M4jgrgVVbnlv+9qx8Ljc6sfVvUVG+024MkBH3jY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BEfPSxfCvvCLHqSY8U9BWJ2yQiSSXop1PNE8kq+8txPBSc0awe8ptQOId1DG1zGYl
	 PtPCnRP6D08RB0bB2watpFBbojw7/XZu/RPPNDRlPt/qFSMW/55Cj9+GFoXLlOnpHy
	 hVRWhzBtNj6AbQdJHL01WWw9vNXhpWzn7bxDif25xIo0X/cUNn+W5PQ+mrBGPJeMv6
	 k1U5UShDMGPm3bc7HOPq5AlBVpxujHfwSISwv2EW+K4H6kBQPIzjup9OS8BCnb7jl0
	 hpk3ezCKDLDKeUMx2yxKfPg+ZGbvW5zbKI5YMU6csdYpL0q5uwTRNR0j+y36IIoRtM
	 C4q/Kw9sl7O4g==
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
Subject: [PATCH v2 09/53] selftests/mm: hugetlb-madvise: use kselftest framework
Date: Sat, 18 Apr 2026 13:54:54 +0300
Message-ID: <20260418105539.1261536-10-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260418105539.1261536-1-rppt@kernel.org>
References: <20260418105539.1261536-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 97718A0004
X-Stat-Signature: i8ykohiqgnpyrg1a1rq51n8j7s4i53sc
X-Rspam-User: 
X-HE-Tag: 1776509804-607169
X-HE-Meta: U2FsdGVkX1/Kog266GsN3BNLTW9ANxjTxMFzAV75Ub45DjRshI7Ybli71FZFmNJ4JBn1mzXjQKBDYNtdH1SZswkliZckfYJ0695aapqNbdfEK46zdhFPEslZ0iBYPN/TqMz1oslFQ6zpoEQC8CJQa3122KA0pB5hkz7a27amb/15OsQ2nCW/EZtmvetP/VglIZr2hgL2tF3TY9nhX79bwHujhqtWzw0+zvaV2HK21Al/K99FXmbOsh9MfrOenGwOkQM6UloqLWEQFiNCuJziV/M6oHtOtj7vAB5AA6tE8F8VhY88zvqLeg7DIkLL4QkaVWfoirT9XW7sDVusCRQJMxrmdfPHpBYVeXmDa/i/NTZelyARFLQPyx444Ue53KsdHzoBQk59E5fy1Tv9XtuDY1dgi0ujOHYMfkTMMCwoTn4If80cPbfF+lCnEsAN7xfA9FxA5uai7uq10i+fLNEXH9c32nf95FK+Ojw/NAex5qitSbpb9+mOKVj7wI/AYLxxhE7FYukjD1i+qqJ51cGv7hY93Y9KF1ikq60im9kK4i7n54w65I4TMxzlTJ3W5zXmUzy6x5E6yngtqP51XoMeZPIrvLOwTKfvSalu3rKJayEnDTlcOPhoOugbLCFaQsGPfXtjO3M5JZ65tmWD+OGaIZqpd5F5YitNN6FvbGV96W9gWKaNhRsNni/Zdn9Ame4Ffh4lzcnSAM7az+6N27xcXTnf5Y5t+fTVpYClXK/uXo0ztau7MTmmwmjgOxxk7jIhv2hIFWT2TT+8EPfvHXmX1Moq1gMDuICjpR/mbxv3jAAsbMtGooMGdio6SUa2ek/7lzYo1cJiZThqwtnljONYr8R6aMWybLupMb0CExxToHuQFV44tJw4oZrqpBIGeiLob8fHOiQmgOjT+aNdsWO1GfPiviV577l9AlJ5FRm51VYnCK/84fZCxoXiGcf1SXUJ3rQR2qsm7wYbznFTOva
 FbjzPnW9
 IFAadTNCgrgonxwvvZbbqExcIt8V9kh+tLCuxNDEIRTuc72sDRAt/T8JQcXw7W1eEig5GqBL55znM4cq+AidJOgrLsDCSdaBsnYXE5G2Dotn8ui3+jJcKnzj4CZq60jcWwp/1rEiFrZqHk2sbXJzbGvHW43mMqwiYdxpMvM0fl+2Upn2g9qBEsYPVwyCBoZKDLp+zZi63AuWCKrs+evLy/f7IQ0/kqCVRYDbr7bwrKrk1Av2Z+g67IHnRFAKw8pjkwBXF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Convert hugetlb-madvise test to use kselftest framework for reporting
and tracking successful and failing runs.

Reviewed by: Donet Tom <donettom@linux.ibm.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/hugetlb-madvise.c | 204 ++++++++-----------
 1 file changed, 82 insertions(+), 122 deletions(-)

diff --git a/tools/testing/selftests/mm/hugetlb-madvise.c b/tools/testing/selftests/mm/hugetlb-madvise.c
index 898cc90b314f..4c6c346a3af5 100644
--- a/tools/testing/selftests/mm/hugetlb-madvise.c
+++ b/tools/testing/selftests/mm/hugetlb-madvise.c
@@ -26,12 +26,11 @@
 
 #define validate_free_pages(exp_free)					\
 	do {								\
-		int fhp = get_free_hugepages();				\
-		if (fhp != (exp_free)) {				\
-			printf("Unexpected number of free huge "	\
-				"pages line %d\n", __LINE__);		\
-			exit(1);					\
-		}							\
+		unsigned long fhp = get_free_hugepages();		\
+		if (fhp != (exp_free))					\
+			ksft_exit_fail_msg("Unexpected number of free "	\
+				"huge pages %ld, expected %ld line %d\n", \
+				fhp, (exp_free), __LINE__);		\
 	} while (0)
 
 unsigned long huge_page_size;
@@ -57,28 +56,24 @@ int main(int argc, char **argv)
 	int fd;
 	int ret;
 
+	ksft_print_header();
+	ksft_set_plan(1);
+
 	huge_page_size = default_huge_page_size();
-	if (!huge_page_size) {
-		printf("Unable to determine huge page size, exiting!\n");
-		exit(1);
-	}
+	if (!huge_page_size)
+		ksft_exit_skip("Unable to determine huge page size\n");
+
 	base_page_size = sysconf(_SC_PAGE_SIZE);
-	if (!huge_page_size) {
-		printf("Unable to determine base page size, exiting!\n");
-		exit(1);
-	}
+	if (!base_page_size)
+		ksft_exit_fail_msg("Unable to determine base page size\n");
 
 	free_hugepages = get_free_hugepages();
-	if (free_hugepages < MIN_FREE_PAGES) {
-		printf("Not enough free huge pages to test, exiting!\n");
-		exit(KSFT_SKIP);
-	}
+	if (free_hugepages < MIN_FREE_PAGES)
+		ksft_exit_skip("Not enough free huge pages (have %lu, need %d)\n", free_hugepages, MIN_FREE_PAGES);
 
 	fd = memfd_create(argv[0], MFD_HUGETLB);
-	if (fd < 0) {
-		perror("memfd_create() failed");
-		exit(1);
-	}
+	if (fd < 0)
+		ksft_exit_fail_perror("memfd_create");
 
 	/*
 	 * Test validity of MADV_DONTNEED addr and length arguments.  mmap
@@ -90,16 +85,13 @@ int main(int argc, char **argv)
 			PROT_READ | PROT_WRITE,
 			MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB,
 			-1, 0);
-	if (addr == MAP_FAILED) {
-		perror("mmap");
-		exit(1);
-	}
+	if (addr == MAP_FAILED)
+		ksft_exit_fail_perror("mmap");
+
 	if (munmap(addr, huge_page_size) ||
 			munmap(addr + (NR_HUGE_PAGES + 1) * huge_page_size,
-				huge_page_size)) {
-		perror("munmap");
-		exit(1);
-	}
+				huge_page_size))
+		ksft_exit_fail_perror("munmap");
 	addr = addr + huge_page_size;
 
 	write_fault_pages(addr, NR_HUGE_PAGES);
@@ -108,20 +100,14 @@ int main(int argc, char **argv)
 	/* addr before mapping should fail */
 	ret = madvise(addr - base_page_size, NR_HUGE_PAGES * huge_page_size,
 		MADV_DONTNEED);
-	if (!ret) {
-		printf("Unexpected success of madvise call with invalid addr line %d\n",
-				__LINE__);
-			exit(1);
-	}
+	if (!ret)
+		ksft_exit_fail_msg("madvise with invalid addr unexpectedly succeeded line %d\n", __LINE__);
 
 	/* addr + length after mapping should fail */
 	ret = madvise(addr, (NR_HUGE_PAGES * huge_page_size) + base_page_size,
 		MADV_DONTNEED);
-	if (!ret) {
-		printf("Unexpected success of madvise call with invalid length line %d\n",
-				__LINE__);
-			exit(1);
-	}
+	if (!ret)
+		ksft_exit_fail_msg("madvise with invalid length unexpectedly succeeded line %d\n", __LINE__);
 
 	(void)munmap(addr, NR_HUGE_PAGES * huge_page_size);
 
@@ -132,10 +118,9 @@ int main(int argc, char **argv)
 			PROT_READ | PROT_WRITE,
 			MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB,
 			-1, 0);
-	if (addr == MAP_FAILED) {
-		perror("mmap");
-		exit(1);
-	}
+	if (addr == MAP_FAILED)
+		ksft_exit_fail_perror("mmap");
+
 	write_fault_pages(addr, NR_HUGE_PAGES);
 	validate_free_pages(free_hugepages - NR_HUGE_PAGES);
 
@@ -143,19 +128,14 @@ int main(int argc, char **argv)
 	ret = madvise(addr + base_page_size,
 			NR_HUGE_PAGES * huge_page_size - base_page_size,
 			MADV_DONTNEED);
-	if (!ret) {
-		printf("Unexpected success of madvise call with unaligned start address %d\n",
-				__LINE__);
-			exit(1);
-	}
+	if (!ret)
+		ksft_exit_fail_msg("madvise with unaligned start unexpectedly succeeded line %d\n", __LINE__);
 
 	/* addr + length should be aligned down to huge page size */
 	if (madvise(addr,
 			((NR_HUGE_PAGES - 1) * huge_page_size) + base_page_size,
-			MADV_DONTNEED)) {
-		perror("madvise");
-		exit(1);
-	}
+			MADV_DONTNEED))
+		ksft_exit_fail_perror("madvise");
 
 	/* should free all but last page in mapping */
 	validate_free_pages(free_hugepages - 1);
@@ -170,17 +150,14 @@ int main(int argc, char **argv)
 			PROT_READ | PROT_WRITE,
 			MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB,
 			-1, 0);
-	if (addr == MAP_FAILED) {
-		perror("mmap");
-		exit(1);
-	}
+	if (addr == MAP_FAILED)
+		ksft_exit_fail_perror("mmap");
+
 	write_fault_pages(addr, NR_HUGE_PAGES);
 	validate_free_pages(free_hugepages - NR_HUGE_PAGES);
 
-	if (madvise(addr, NR_HUGE_PAGES * huge_page_size, MADV_DONTNEED)) {
-		perror("madvise");
-		exit(1);
-	}
+	if (madvise(addr, NR_HUGE_PAGES * huge_page_size, MADV_DONTNEED))
+		ksft_exit_fail_perror("madvise");
 
 	/* should free all pages in mapping */
 	validate_free_pages(free_hugepages);
@@ -190,29 +167,25 @@ int main(int argc, char **argv)
 	/*
 	 * Test MADV_DONTNEED on private mapping of hugetlb file
 	 */
-	if (fallocate(fd, 0, 0, NR_HUGE_PAGES * huge_page_size)) {
-		perror("fallocate");
-		exit(1);
-	}
+	if (fallocate(fd, 0, 0, NR_HUGE_PAGES * huge_page_size))
+		ksft_exit_fail_perror("fallocate");
+
 	validate_free_pages(free_hugepages - NR_HUGE_PAGES);
 
 	addr = mmap(NULL, NR_HUGE_PAGES * huge_page_size,
 			PROT_READ | PROT_WRITE,
 			MAP_PRIVATE, fd, 0);
-	if (addr == MAP_FAILED) {
-		perror("mmap");
-		exit(1);
-	}
+	if (addr == MAP_FAILED)
+		ksft_exit_fail_perror("mmap");
 
 	/* read should not consume any pages */
 	read_fault_pages(addr, NR_HUGE_PAGES);
 	validate_free_pages(free_hugepages - NR_HUGE_PAGES);
 
 	/* madvise should not free any pages */
-	if (madvise(addr, NR_HUGE_PAGES * huge_page_size, MADV_DONTNEED)) {
-		perror("madvise");
-		exit(1);
-	}
+	if (madvise(addr, NR_HUGE_PAGES * huge_page_size, MADV_DONTNEED))
+		ksft_exit_fail_perror("madvise");
+
 	validate_free_pages(free_hugepages - NR_HUGE_PAGES);
 
 	/* writes should allocate private pages */
@@ -220,10 +193,9 @@ int main(int argc, char **argv)
 	validate_free_pages(free_hugepages - (2 * NR_HUGE_PAGES));
 
 	/* madvise should free private pages */
-	if (madvise(addr, NR_HUGE_PAGES * huge_page_size, MADV_DONTNEED)) {
-		perror("madvise");
-		exit(1);
-	}
+	if (madvise(addr, NR_HUGE_PAGES * huge_page_size, MADV_DONTNEED))
+		ksft_exit_fail_perror("madvise");
+
 	validate_free_pages(free_hugepages - NR_HUGE_PAGES);
 
 	/* writes should allocate private pages */
@@ -238,10 +210,9 @@ int main(int argc, char **argv)
 	 * implementation.
 	 */
 	if (fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
-					0, NR_HUGE_PAGES * huge_page_size)) {
-		perror("fallocate");
-		exit(1);
-	}
+					0, NR_HUGE_PAGES * huge_page_size))
+		ksft_exit_fail_perror("fallocate");
+
 	validate_free_pages(free_hugepages);
 
 	(void)munmap(addr, NR_HUGE_PAGES * huge_page_size);
@@ -249,29 +220,25 @@ int main(int argc, char **argv)
 	/*
 	 * Test MADV_DONTNEED on shared mapping of hugetlb file
 	 */
-	if (fallocate(fd, 0, 0, NR_HUGE_PAGES * huge_page_size)) {
-		perror("fallocate");
-		exit(1);
-	}
+	if (fallocate(fd, 0, 0, NR_HUGE_PAGES * huge_page_size))
+		ksft_exit_fail_perror("fallocate");
+
 	validate_free_pages(free_hugepages - NR_HUGE_PAGES);
 
 	addr = mmap(NULL, NR_HUGE_PAGES * huge_page_size,
 			PROT_READ | PROT_WRITE,
 			MAP_SHARED, fd, 0);
-	if (addr == MAP_FAILED) {
-		perror("mmap");
-		exit(1);
-	}
+	if (addr == MAP_FAILED)
+		ksft_exit_fail_perror("mmap");
 
 	/* write should not consume any pages */
 	write_fault_pages(addr, NR_HUGE_PAGES);
 	validate_free_pages(free_hugepages - NR_HUGE_PAGES);
 
 	/* madvise should not free any pages */
-	if (madvise(addr, NR_HUGE_PAGES * huge_page_size, MADV_DONTNEED)) {
-		perror("madvise");
-		exit(1);
-	}
+	if (madvise(addr, NR_HUGE_PAGES * huge_page_size, MADV_DONTNEED))
+		ksft_exit_fail_perror("madvise");
+
 	validate_free_pages(free_hugepages - NR_HUGE_PAGES);
 
 	/*
@@ -279,29 +246,25 @@ int main(int argc, char **argv)
 	 *
 	 * madvise is same as hole punch and should free all pages.
 	 */
-	if (madvise(addr, NR_HUGE_PAGES * huge_page_size, MADV_REMOVE)) {
-		perror("madvise");
-		exit(1);
-	}
+	if (madvise(addr, NR_HUGE_PAGES * huge_page_size, MADV_REMOVE))
+		ksft_exit_fail_perror("madvise");
+
 	validate_free_pages(free_hugepages);
 	(void)munmap(addr, NR_HUGE_PAGES * huge_page_size);
 
 	/*
 	 * Test MADV_REMOVE on shared and private mapping of hugetlb file
 	 */
-	if (fallocate(fd, 0, 0, NR_HUGE_PAGES * huge_page_size)) {
-		perror("fallocate");
-		exit(1);
-	}
+	if (fallocate(fd, 0, 0, NR_HUGE_PAGES * huge_page_size))
+		ksft_exit_fail_perror("fallocate");
+
 	validate_free_pages(free_hugepages - NR_HUGE_PAGES);
 
 	addr = mmap(NULL, NR_HUGE_PAGES * huge_page_size,
 			PROT_READ | PROT_WRITE,
 			MAP_SHARED, fd, 0);
-	if (addr == MAP_FAILED) {
-		perror("mmap");
-		exit(1);
-	}
+	if (addr == MAP_FAILED)
+		ksft_exit_fail_perror("mmap");
 
 	/* shared write should not consume any additional pages */
 	write_fault_pages(addr, NR_HUGE_PAGES);
@@ -310,10 +273,8 @@ int main(int argc, char **argv)
 	addr2 = mmap(NULL, NR_HUGE_PAGES * huge_page_size,
 			PROT_READ | PROT_WRITE,
 			MAP_PRIVATE, fd, 0);
-	if (addr2 == MAP_FAILED) {
-		perror("mmap");
-		exit(1);
-	}
+	if (addr2 == MAP_FAILED)
+		ksft_exit_fail_perror("mmap");
 
 	/* private read should not consume any pages */
 	read_fault_pages(addr2, NR_HUGE_PAGES);
@@ -324,17 +285,15 @@ int main(int argc, char **argv)
 	validate_free_pages(free_hugepages - (2 * NR_HUGE_PAGES));
 
 	/* madvise of shared mapping should not free any pages */
-	if (madvise(addr, NR_HUGE_PAGES * huge_page_size, MADV_DONTNEED)) {
-		perror("madvise");
-		exit(1);
-	}
+	if (madvise(addr, NR_HUGE_PAGES * huge_page_size, MADV_DONTNEED))
+		ksft_exit_fail_perror("madvise");
+
 	validate_free_pages(free_hugepages - (2 * NR_HUGE_PAGES));
 
 	/* madvise of private mapping should free private pages */
-	if (madvise(addr2, NR_HUGE_PAGES * huge_page_size, MADV_DONTNEED)) {
-		perror("madvise");
-		exit(1);
-	}
+	if (madvise(addr2, NR_HUGE_PAGES * huge_page_size, MADV_DONTNEED))
+		ksft_exit_fail_perror("madvise");
+
 	validate_free_pages(free_hugepages - NR_HUGE_PAGES);
 
 	/* private write should consume additional pages again */
@@ -346,15 +305,16 @@ int main(int argc, char **argv)
 	 * not correct.  private pages should not be freed, but this is
 	 * expected.  See comment associated with FALLOC_FL_PUNCH_HOLE call.
 	 */
-	if (madvise(addr, NR_HUGE_PAGES * huge_page_size, MADV_REMOVE)) {
-		perror("madvise");
-		exit(1);
-	}
+	if (madvise(addr, NR_HUGE_PAGES * huge_page_size, MADV_REMOVE))
+		ksft_exit_fail_perror("madvise");
+
 	validate_free_pages(free_hugepages);
 
 	(void)munmap(addr, NR_HUGE_PAGES * huge_page_size);
 	(void)munmap(addr2, NR_HUGE_PAGES * huge_page_size);
 
 	close(fd);
-	return 0;
+
+	ksft_test_result_pass("MADV_DONTNEED and MADV_REMOVE on hugetlb\n");
+	ksft_finished();
 }
-- 
2.53.0


