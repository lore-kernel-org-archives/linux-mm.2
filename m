Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86B98FF886D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 20:44:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED3056B00A6; Tue, 28 Apr 2026 16:43:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA9F06B00A8; Tue, 28 Apr 2026 16:43:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC0B26B00A9; Tue, 28 Apr 2026 16:43:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C94906B00A6
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:43:59 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 86C421A042D
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:43:59 +0000 (UTC)
X-FDA: 84709141398.09.FFA2DBE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id DBBAE100003
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:43:57 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ejLhIzq0;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777409037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OnyTDrlTyHNXGxsZ/wzFN6xqFj0ujcYTsm5+dJyqMBI=;
	b=d6kEi/L91SSDFfGUv1odMo32bpPIFYBg9jeezVxbfRK1K5a+ku52jwC1XsKE4TYi/JFM3k
	MhkLFOCYykdH6/6g5EgQ/30ikfjXkPGnU7F4EUzntD7NKAqS3Qmbe2Wblq1iu6s5bFlSKX
	HvvGajHoyMGAoiUbD7+d3n4uwvu+M+Q=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ejLhIzq0;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777409037; a=rsa-sha256;
	cv=none;
	b=FH+yBAOhZ+BgVt2gOppD3b5lvPBKuouInigormEOL9LlDOEEbut/0WiBw83UI9lZdqvinj
	VClWjYP2LdT24q10W84iuNbFgoDCM0yVljpwrHI+rTJTNjegXOnaoXBgdMVPotr4eTDgf6
	1wWHpNiVjLfpYXL74RggIyD0IfPt0Co=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 470D461146;
	Tue, 28 Apr 2026 20:43:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E12BEC2BCB7;
	Tue, 28 Apr 2026 20:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777409037;
	bh=/xRGC6/38cN+oMRwh/sO9zPsnvisaYmcm1vP8FXfFDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ejLhIzq0R2Zqb2ws9Vms/Vj1/lIAyDDed2bjwgikI0TGRfLl6OKj27bS1qudGyKq4
	 OIxqBQJwqwLLGCjO2KxEOzMVQyh6P0H+uNOgZW7lGWsToArUU2WVenoxLayrd2UUaS
	 ypq8DB9BsaVTEtJMOXFqk6Hk3Lfjnr5/ZUkD2KN1sNxaNjuAx6uvaNO9PYBbm0oxdb
	 PAtb6+K2Jn5tYcEIJUJ57gXZoi6pwXh78vj19BOYyx9KZKUbpyluC/Q/G2f6+VMrAn
	 N/IUfVOaLsYHy10qEckp/o5R2xlCU5R6IBHAm7rAi9ddFNZjvgW91MYecGi/U9AsPw
	 xY278yRCFRkEQ==
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
Subject: [PATCH v3 10/54] selftests/mm: hugetlb-madvise: use kselftest framework
Date: Tue, 28 Apr 2026 23:41:56 +0300
Message-ID: <20260428204240.1924129-11-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428204240.1924129-1-rppt@kernel.org>
References: <20260428204240.1924129-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DBBAE100003
X-Stat-Signature: rkwh7ueb6ca77cpwksn98ztynzadyhsq
X-HE-Tag: 1777409037-994666
X-HE-Meta: U2FsdGVkX19MEUZtz6+MMLhLsMXkO7xYXqPIhqx9fpamIZXSyLyvrDJRadfjz5+YcRrPPpOIAQy3SAS+8rgJG4hicBgAv1KYS1/XguJIptOlo+Oqs14A3gZVehafBVtcCxE0Od0Xf7ruO4f/swml9KCGieBTLVgskLag3nWuwyCGP+msLK4bDPSV2ptVJ1PTi2cC+jIPVUjrGdk9rSovlX8+gwxwx4+mD7PRK6lyFiNFCXN1MTI+wOe2u7CjnnZayGb7EYtk2OwAj0b8s4mKnhl/SetsILkioZ617AxQrQMyZSsnOO7rbTQXY8rcSxrMAi+PG4fPtcnh5nitDkTOuStdCB+TqwT+QN73+coCkgebR1QGn5hJqD1bn6K6gXyCt0naMXMKZ678yK/znMPsw+00Wqe6XYF/tV53d27geO6R5sDSLgvTbDIAqbB+9Y7QYEPAaFfuA6kDPqDzdBz4+I5YmGxOkf1LrCSNIkKNkjMzC0MrOu0x/M7pLzzCRw8zZhP7qF6cu99/ZsLqjyatCg4ImOsV7cnnAdfF7Vu7StG0/6fw2O8XGSYhhDENjwdhY6MGyvGiClof31RWjYLFRJC1qDgJiDnMKUee3Y1xwksIp+Z+74qS8Qn1zj7ZFUFRO/XnRw4vXA6bX1P1MLiV9AFp88rBRG21IDeQMK+VvRnFiYTUGqMbYTRbRAIMyZc9JaxxzUv+h4B7hP0W2ejJz0SFBB45sozqtY+n8p1cFOcbgkBhKz4Uhz8IJq67/N+sJvXFyfoWdcWxf+oPvrMBh26HAhDl/pfLl6aN0go4d9IH92/+MB2Zf82NiCnorKmUim36FJCVQEABaOaD01fXd0QbAfTtkf6WJplLK8NFlWbXq15uX7JVjt/ZM9QQ76t0YO6rpRTJGJBx4DV3+/+5IoTXY0tdbL7TglzM3v/RsTW1N1GtEsg41mmf/OQkwVwevgHdImbT54RoZ490s4D
 +FAK173N
 mLmuh0IRgMJdq2pi7GjZTNyACsheUkv0znJ1SfWtrATf7Y0mg8AaoaCUNE1ynT/OQBaQFpukYHOQmQECxuXuQkIitcJaHviTjHPA34afeIEpL42BrCAGkwQrgRE9FX0X5Gxf/Da5eVEY67PPeFb9pZBvLNQyFXIX/OxEoTBAVQwz9baZMMLRBqU8oVPDq4W0nNVX0aGpikn+7d6qQtPl1fbEIkQwKoE/HjkAEyIrCRAVBrDtfCz/uyOVkOJHZsT4fIhn6YasuA1f/D/qNbV/zUTxIqrk/aMNc16RW201ibB6qccAG7z1AOqfF1A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Convert hugetlb-madvise test to use kselftest framework for reporting
and tracking successful and failing runs.

Reviewed-by: Donet Tom <donettom@linux.ibm.com>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
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


