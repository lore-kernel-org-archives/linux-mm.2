Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 310BEF46C46
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 14:18:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 946206B00A5; Mon,  6 Apr 2026 10:18:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F6FF6B00A7; Mon,  6 Apr 2026 10:18:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80CA86B00A8; Mon,  6 Apr 2026 10:18:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 705706B00A5
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 10:18:41 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2DA3616048F
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:18:41 +0000 (UTC)
X-FDA: 84628336842.19.911EDB5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4B78C4001D
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:18:39 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e9b4SvF5;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775485119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IcuFEar4bwj5aNIDUYcijD1oS+rZvJKvvOvQPdD5x44=;
	b=1LtAzg5yQDS43HaHdK8U6ahQ20fIdYfzHpch0aqhbL/lIX5gOVFm7p+pC50uxEmC6Jp1A/
	PQGdwcvoZN3J+T9ELImFqg4Nuea1YyLyoLNDxR1UlXnhy9eZmGplth2TpuRlSmc7o3IgNn
	YQ+I2PG7WXzkGqJlzybXE+eGg1EXfPM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e9b4SvF5;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775485119; a=rsa-sha256;
	cv=none;
	b=mEPUQbWxsxnN4AvUpdx9EJgwMwNdR/gvXn14j4SpTLoVr0Lpr92RZ+ELlkHStS4lBvyPzQ
	TmHf4TOS/X9MR/PuBGO8jNHpFnRtY9Yys+kaB58jnLJ005F/Sm7FG/9om7SXsks5kOs47Z
	cibqwOxtCgeauIAlElqaepgUGfnlkoQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5DA3E41A63;
	Mon,  6 Apr 2026 14:18:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0004C4CEF7;
	Mon,  6 Apr 2026 14:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775485118;
	bh=NlqEN1Up11h0mvo02ZJ0SFo+7mbDu/Hjb+POKuNEMGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e9b4SvF5wG9/Tok+MynNcVbSmUxyEzLCXy++V5IAFW3mhnb1oB1Qrm/Kn/+bbkUtL
	 zsbfSHLTe5fixxg79651bcbhcEC4kEgVIytYbTmvDdvsk+XXETgCOqsP/uvilaFEXZ
	 y49cs3MXwQmTzenKHauCnaIUZSraERo9Mk/LnUTs7Au79fs5SIeDcgksJLf1avRO0+
	 +eSExRC9rl7/i/gPBXFUgmB/v/DBpM7ItHDSNeZto0z4CyS6pjRVQChniAs+3WNgc+
	 IeNW1emXHSVPSBqj0bCsqUOwEzBqyiCxAmL93c+Rn1DP81ahND+Tp5gSPVgj8rCBuy
	 /76HW+nbI8msQ==
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
Subject: [PATCH 09/53] selftests/mm: hugetlb-madvise: use kselftest framework
Date: Mon,  6 Apr 2026 17:16:51 +0300
Message-ID: <20260406141735.2179309-10-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260406141735.2179309-1-rppt@kernel.org>
References: <20260406141735.2179309-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4B78C4001D
X-Stat-Signature: n43o3a3z5f4gjsxr5rqtx8ky7cpzyecz
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775485119-539779
X-HE-Meta: U2FsdGVkX19CWoH1MeVaAR/nI+o4hH2ryTO6/2d5+FSdayUn/HQB/tWbaOHnJmIQRTrH1uNP8gzwA28jv38VDacTKVbhIW/iZotpNRJDTa+1gO4TxeN+TobfT/sodfOUlqa/nZwR0ly4wQkqn05Qkiah5+8tooaY4e3Ae4bLgTYujlPGd/9LwGXFKdViC0QQQ6q8CzZz2AZrizlOpCRP0v+tSgQIwq8IkGhhLq/blvv79587DPUGQvcYhea7WtJVwAShExNJDot9HI3XKREgzxw163HvkZqF8NBiesCYv9qM4Vgn9YI5bZeCWiKt0al1rSUFpPPcrtC5PGozCyPdkm45USdrxsimMxdl7QN8LgbLjjXaaXYsDBo6R3jFdRgQnh7Ie6rR2HumfnsykzBPMgaxf+W3tLTndoDnu1Q/8e5718iXXU1bU6vZBDdhbsF/VGcMifyOwJppzBIsgqbWZGM2/Ag5Dfvebu/qH5+AosGrhc6pXp/WUx1ZEpxtBneGQxedrvqV+mVZAB19JQrOWzCdQofwqzsaYqIsZr9l4EshfhdJoBu2VCjfyIQqceqfiwoEMzFJIoWBx1SWf8K8DugjWoh13/Bl6g9SrEZ0p5O9EM0BoQZFOSnlT+jNpcOZ2NVEspQVCjYRD+TMM07AAeW/OvD8hPr70/rXfdUmVxhuH7tok9vLdSmNqrUGjhD6eEdnBXBXUS4aV07Ctb6xnvfaKleu5nP15uFD/xNm5quaByvn/ewgin16N442tliKvNCxKk7ufFcrqexAw5zWTywSJW3WmeyFbQgmAAvPYSMCLoB9Uxxr1aKRgyA+tV5HQJ0Vb74fEo+Tor5UbyYcwluYGImvU0sEAZgwOd4ZGvDQpQUmSxcevwVqx5FOoMJyoPbfLElR2l2nqPE3PzpwPGP/XBvYpngoeINppeEu5dsxaDFq/6Nzu4iXR/gGitgevImAesQHFPexddeWHlr
 MWEbMgQJ
 DIPAlCF49juyJ+xumuFfwcVsgPw+22npm43IQqm1OCdTEkrZAf/DEdMZbE4SR+wKlsl6f2SqeaAculVeElLndn2eei8cdjQPVMllKW9NibMStfyEV1Ax/PCse4iesnT8eKe5ssYlwQN3qTB/8kIzvOQM7IevS2MRzeX808A3d0BTucD6TNTuXBm5tGkdNhT0pOHaYfO77ed94w6SppPnv+YSIhKIUfm0wHcYsWl/4jPqxGFQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Convert hugetlb-madvise test to use kselftest framework for reporting
and tracking successful and failing runs.

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


