Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C68A3CD4840
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:29:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D3256B00CF; Mon, 11 May 2026 12:29:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AB016B00D2; Mon, 11 May 2026 12:29:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C1096B00D3; Mon, 11 May 2026 12:29:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1D38B6B00CF
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:29:58 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CEBB9140208
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:29:57 +0000 (UTC)
X-FDA: 84755675634.26.67FCB5F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 045F1C0012
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:29:55 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="FiA/IRl6";
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778516996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W7m6pe0675z9sHnyjU9sgcLX41hNs2khv66J1mAZbY8=;
	b=IMRotWXPWP2pVRoYLWh+4MOjoByaze+GVijtv1i9nOQ8fzL7p8jwkeg9rLLadKA9BbG4N8
	khSUhwwOcw+p+q6nZseHk7F3FbAM1VWlZnW4C5LljCO/a50QzwW6AuVQNNgBxE7kn8O68d
	rS8sWv46JU+zIRVSfkQIMKrRfO3u+QY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="FiA/IRl6";
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778516996; a=rsa-sha256;
	cv=none;
	b=k2smDy7dsfcKm7TQjF7QEZZkgB93b1oBzx/i5KvCWVu8Q/YrzffneFdqgZfo/R3oya6qTb
	QsAtgnY9xIX01Cw8OulKndz+N38zDUP/RuKmiAF8oS8uLhgzY0y3oL2sMLYHhrfvg/fneu
	DGT2uFuAwg8xm2kuMV5SQm/AMkwmyfM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3124F40A66;
	Mon, 11 May 2026 16:29:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D6B4C2BCF5;
	Mon, 11 May 2026 16:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778516995;
	bh=BNGrJ1LfWrvHQbUJ7tpEIodXfVFxpeW/hH70ZK5JMfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FiA/IRl6a6IRkt4eYcUx4JL/uIyoOGb5HoZOQdDDgaa0I6zx9rZn68NOaKwacx6rt
	 BO0QZyIHX5qF+1ZKMrA1+X7vhTNwodJd3iEV+2qRew0mez43d51ZBGRMJ6IaFphs8W
	 kk/MzfB1f9PoM8LlD6sS4YMYtB1rCWTJdXnJkpKnN+DbFugjDlo1iMmt/XLzNMMRot
	 NE884ht9D4Xr8a4PSyj5cc7y2z1mFFouZbSEq9wjYGRbhtKRjxhvGlYO5YmvvT+Z3d
	 q34W0XC82tMfs6x0zSyPFzkuYjtIK2/a3sdKQEmPQUavRlFhkDG9Buy1BldtvBMtUp
	 9vAlhjJTpKX0g==
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
Subject: [PATCH v4 10/55] selftests/mm: hugetlb-madvise: use kselftest framework
Date: Mon, 11 May 2026 19:27:54 +0300
Message-ID: <20260511162840.375890-11-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511162840.375890-1-rppt@kernel.org>
References: <20260511162840.375890-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 045F1C0012
X-Stat-Signature: ts473aieuqqsradk6d1f5xan7xmi3aqb
X-HE-Tag: 1778516995-826566
X-HE-Meta: U2FsdGVkX1+ty+/3UXt34dWl3obHhDTxYzoPm5n8MJus4pcNoul2cVpnsnxClpADAvPXBgtYaMWCCZnJo0GnRypKLFcyPRm5uZLB4JzkJ6Sfy7iQHfrKQ7yv/1V49RkLZlTqzq1u+VYBCPfO7gZEBkS7QrgGnyx6zSXn0OPs5PZLG1fBoxpUJLZ2vMNr0GQAVun+Lt4tXMdkVvCOWNqONF27Iq4Z2OmvfOCHn24IzXdPNZlqGco/r42T+PB/5/0hDsjnbtrq3Gf+qyvzZ4Nm0SrtPnzN8M2Vl0KKckyxzHpxZiXaCTCGhHTYVNs4rvmb8q1WDGbIkyrhOtl+OjPO8JSk01+Q1tJdJ3ss6qluvA2tnh9r9w0cuMRleJveBYg3tCIxH2rcjis5jBS7Ak0ls6NFnNLsHOJZMYCCKPTEAb64CKnfb0fRoDo9tHPWtDjuu73WWWllJcUu13D/bN0Oxch5Pln/TOKrtCMUe0oHsF6m/w0FsyGgMaqrEoQGh0P72txyAIIVBodz0exQDDbRxz97ZKby3oKiTsS5Ukka4yZ2x4STxFEj51jBn6bwJvHZ8lR+ggtMMJgTsIxl1KwNXgGNsQbrawxIauZ7Bk+RvoOgXHSYh5XlOlAXP1FqM8dz4jdExOw93p1Tbb2eGrYnedavBoaiWtWUUZBYBlQNJnB0WPVCVwZ2yVOlH2Pzi4kk2CP22FctYtTQEHEmDkgVpNv2f2lTXB8nwhdQAh7brMwbIjoY4o5y+cYF15gOMoRZEQS1N4T6U9JRQwqAco7h2Ho1dkIpE1dr0NQpxi8OZ3Mo6v9YFFo9JU5LGop8J9XW0tpfoG0d/1SNtU9IYYvje/oUtkgajyVgiFAtWI+uX7F8BcYBsKb6UO2HucCB0d4Z/lglBSqNJmvdR3k6nQyYm9cSbnP4GoR8IEi01c1T0X273RAkjGHvCGIgV9Xw6eaY3j1YLwpld19QhIDGyQy
 fcDebYtf
 5BhdjaYayXR8n6xZUaDrq5AD3eq6g223hGqMT9K7MUIwLKX3mkxKflf9ki+l2MNrA1nvLLGRyIm6srInp1RgmlJ2wumuKVoDmWx9G3rWoyn4iaEolp2FhIMf69rTokj/ib9jgYzE4V/tZED/FS5u2HC/xgJ32uf6jGCAcoSleMENX2f6wZ6ndTaHdgr3p68hWMBNGRC8kM59H/fDWvQU4wBdPVKygDDVWoOlxOh5F6aDpEu6daeeiaasPia+PIFi+BgE0cZsw9so4LpooPl4oKbk0fZ813ta1xrnKE6L6FUqcyGc4N2OmtLmJ4R0vacaAQCF44c3dHy5LTUn61t9+ssd3XQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Convert hugetlb-madvise test to use kselftest framework for reporting
and tracking successful and failing runs.

While on it fix the check for base page size detection to actually use
base_page_size.

Reviewed-by: Donet Tom <donettom@linux.ibm.com>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Tested-by: Luiz Capitulino <luizcap@redhat.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/hugetlb-madvise.c | 204 ++++++++-----------
 1 file changed, 82 insertions(+), 122 deletions(-)

diff --git a/tools/testing/selftests/mm/hugetlb-madvise.c b/tools/testing/selftests/mm/hugetlb-madvise.c
index 898cc90b314f..e7dd8d06d986 100644
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
+				"huge pages %lu, expected %lu line %d\n", \
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


