Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6747AFF886D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 20:48:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D04BC6B00F1; Tue, 28 Apr 2026 16:48:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDC7B6B00F3; Tue, 28 Apr 2026 16:48:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C18806B00F4; Tue, 28 Apr 2026 16:48:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ACEFB6B00F1
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:48:03 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 74E84120234
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:48:03 +0000 (UTC)
X-FDA: 84709151646.03.D0E6997
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id BADFD80004
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:48:01 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VSulbNh2;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777409281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xOBN5bNIfK+IPrN4puPQk3ndADsoOG+Svf1m9y0gKbQ=;
	b=s0+LbNZBGQmYGzuO8/tVp/X9czZJPCe/dzUp1heEk38spG8pJJnSqBYIjwOQXyjfkz1PZj
	y7CTEfZng6YtKRHDY5ZbTKGo3gjEunTHthoF0fMVmqIVXFeNFLsy+vcWN85Lvk6W+j2Kkk
	Zj+sgeDZMQNDqRArWyWFtI4w+0+747s=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VSulbNh2;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777409281; a=rsa-sha256;
	cv=none;
	b=ZglcE1Piz4UWi1/lO86bACVTbRxJr81HFYVcCWWUfSXNmuxKagh7PvcBhU/JDrwQtd2Hbu
	xayIfZzsnEIxlIuUaGqtlSutCgEtXUywKcnovbkVerZPAaTEXWolB5JPCqt2sFdCwgGroc
	bX1VMDdPyMUIdA/oXgxnE0S102qVsLU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E96CD40A57;
	Tue, 28 Apr 2026 20:48:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC675C2BCAF;
	Tue, 28 Apr 2026 20:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777409280;
	bh=pMqT3V7GrLrPKmH8KQ0+ElCx+AnALakW5vIuoVUm4lQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VSulbNh23OPZdj6S8HoCUp9j+rWArxXYrl8I3L4Mw9cSe8I3xUPfJhuV2OBxKulWJ
	 fdTRYQOVSovFRx+RjTrIGJ7ULDGaQxY2lz4IawLutXLUr3K9GXARZxLCxh4InlTQeO
	 bkkIlHEkS8dQbjgMeGJBqnsjQSHMca9yi2nKXDfMIaD+/nYL+6e1lu3GVhOXyCFbz2
	 1rvd2YozXokylduoR9S3zjGEvb82Y3j+owTcIjX6i8N2H+kjsmCHqBlBOsl+sU67Vd
	 f+xiz1VjZJOC9GMSLCcdaQsBQ4Bksp0GT74wMIrF60RLDHRp9taagW8bZp5a00ExRo
	 4uNxV4dkYQVng==
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
Subject: [PATCH v3 47/54] selftests/mm: thuge-gen: add setup of HugeTLB pages
Date: Tue, 28 Apr 2026 23:42:33 +0300
Message-ID: <20260428204240.1924129-48-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428204240.1924129-1-rppt@kernel.org>
References: <20260428204240.1924129-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BADFD80004
X-Stat-Signature: rucaypqz5a4t73pinbnpfy8frseo4ts3
X-HE-Tag: 1777409281-467875
X-HE-Meta: U2FsdGVkX19dQUUIrbBodNpGlch9oI+LKCIGBSGdyE1OGVIerMG2i/8aw8t5a+PrDTesbALTvl5kvip1UWpwV9SzKQflyhv0GnKPOORJ7/U+mCJeHLPKGIa/7QJNZFSGlOF4pSuvfys7qtMD8YTAmonDltXJiHm2UoMaCAcWPfU2BZR4UmBzfZ2sXbw6YueOiT1eEB3QKnyo2HN47bjE63iPi1CJZgWKM6MJGq+6kwgEyh8ZBn0uSTAMOmcHi924kGBpu1uALEIlFF3tjMdDIEIbB0bOaRn2n26VY6Zqsw6FQnVVtyG+8WgG8Hesh3uDJ88Vq/WNuj9WokYrI6EExxVMwqjADDAciGpF2Lml+ZD4HKyzi/CpO9yT+MLhbObQWsfB02etC8Q1Vv2ZvsVj2riqQJRm1h2gF1If+sSfjf6gRCk4Q1ey+hI3+iN0TpprC+J7rsGmxwrqHdR2hnCZsQWkJcTUitseQ8D5YJ0z4M6ZizP9AUiYrTlI3CQfXuVxb8GVwJ/Sl4cW0KAmQS1XBCADaIO1FirFM69SDJwV9BpnsTecxWZTS1JLar1MSaG3WUkZ6bpbe9Ep8hbxuHbgwu17KAUR5RBIM0Rp9Ilxu9X+x5IfDPQx2tsxwBgagyksdXubYreUS2g7UXc5fqID++abNuxfyMGYKltOVrQfka+bKShxZKD8ZyYTGYu9eC1AsLjkR6HZACVK67wSZS1ndQB/QsIp6jKrm2BFlImDEC1tiZXcxQnBTvmh8t8MjOcAK9Ti5uL9CCzieruZDftIvBGXpfsZlnm5zdWZZiPf5ayqNgKaY3DqRjoGWTn+CFzcoPGwYzXK0chfcJcNKMYEurEU6ntutz76AehC24veNs/fZbiGULqSkf5s3ce++FiGhsAS6WLytEvLWRR5Nk/3KptBMRE+Xs6wJGFI+NkTOuSGxzLmnOXFye0aXVCy+y/VgiV6VQjWWrN4jGRgdu/
 iekfw+/S
 g3frgw3LMu/C82l3IUKO21Xb8cmSl2iXdc7ZR8x0QgBiVq0i4Axy+CLx0DiDVlvggtvnZnDdF+KKOBOAse9X1rTSGqnp20z/xLuxZc5UDdhS5Q7UP4PoXoUygrXEG0JMjjddGn3uZEHht8BVZhgeP2UjACWx7vTW9RBKjiosmnnMNhip6oPw0iRgA6w05WbV7xSX6t/ud0bBQvSEE4usrlruaPqdyL04W0r4bJtP3eeJ3sBI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

thuge-gen skips tests if there are no free huge pages prepared by a wrapper
script and shm liimts in proc are too low.

Replace custom detection of huge pages with the library functions and add
setup of HugeTLB pages and shm limits to the test and make sure that the
original settings are restored on the test exit.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/thuge-gen.c | 79 ++++----------------------
 1 file changed, 11 insertions(+), 68 deletions(-)

diff --git a/tools/testing/selftests/mm/thuge-gen.c b/tools/testing/selftests/mm/thuge-gen.c
index 1007bc8aa57c..b63d87d72a7d 100644
--- a/tools/testing/selftests/mm/thuge-gen.c
+++ b/tools/testing/selftests/mm/thuge-gen.c
@@ -38,15 +38,6 @@
 #ifndef SHM_HUGE_SHIFT
 #define SHM_HUGE_SHIFT  26
 #endif
-#ifndef SHM_HUGE_MASK
-#define SHM_HUGE_MASK   0x3f
-#endif
-#ifndef SHM_HUGE_2MB
-#define SHM_HUGE_2MB    (21 << SHM_HUGE_SHIFT)
-#endif
-#ifndef SHM_HUGE_1GB
-#define SHM_HUGE_1GB    (30 << SHM_HUGE_SHIFT)
-#endif
 
 #define NUM_PAGESIZES   5
 #define NUM_PAGES 4
@@ -64,32 +55,10 @@ int ilog2(unsigned long v)
 
 void show(unsigned long ps)
 {
-	char buf[100];
-
 	if (ps == getpagesize())
 		return;
 
-	ksft_print_msg("%luMB: ", ps >> 20);
-
-	fflush(stdout);
-	snprintf(buf, sizeof buf,
-		"cat /sys/kernel/mm/hugepages/hugepages-%lukB/free_hugepages",
-		ps >> 10);
-	system(buf);
-}
-
-unsigned long read_free(unsigned long ps)
-{
-	unsigned long val = 0;
-	char buf[100];
-
-	snprintf(buf, sizeof(buf),
-		 "/sys/kernel/mm/hugepages/hugepages-%lukB/free_hugepages",
-		 ps >> 10);
-	if (read_sysfs(buf, &val) && ps != getpagesize())
-		ksft_print_msg("missing %s\n", buf);
-
-	return val;
+	ksft_print_msg("%luMB: %ld\n", ps >> 20, hugetlb_free_pages(ps));
 }
 
 void test_mmap(unsigned long size, unsigned flags)
@@ -97,14 +66,14 @@ void test_mmap(unsigned long size, unsigned flags)
 	char *map;
 	unsigned long before, after;
 
-	before = read_free(size);
+	before = hugetlb_free_pages(size);
 	map = mmap(NULL, size*NUM_PAGES, PROT_READ|PROT_WRITE,
 			MAP_PRIVATE|MAP_ANONYMOUS|MAP_HUGETLB|flags, -1, 0);
 	if (map == MAP_FAILED)
 		ksft_exit_fail_msg("mmap: %s\n", strerror(errno));
 
 	memset(map, 0xff, size*NUM_PAGES);
-	after = read_free(size);
+	after = hugetlb_free_pages(size);
 
 	show(size);
 	ksft_test_result(size == getpagesize() || (before - after) == NUM_PAGES,
@@ -121,7 +90,7 @@ void test_shmget(unsigned long size, unsigned flags)
 	struct shm_info i;
 	char *map;
 
-	before = read_free(size);
+	before = hugetlb_free_pages(size);
 	id = shmget(IPC_PRIVATE, size * NUM_PAGES, IPC_CREAT|0600|flags);
 	if (id < 0) {
 		if (errno == EPERM) {
@@ -142,7 +111,7 @@ void test_shmget(unsigned long size, unsigned flags)
 	shmctl(id, IPC_RMID, NULL);
 
 	memset(map, 0xff, size*NUM_PAGES);
-	after = read_free(size);
+	after = hugetlb_free_pages(size);
 
 	show(size);
 	ksft_test_result(size == getpagesize() || (before - after) == NUM_PAGES,
@@ -154,43 +123,15 @@ void test_shmget(unsigned long size, unsigned flags)
 void find_pagesizes(void)
 {
 	unsigned long largest = getpagesize();
-	unsigned long shmmax_val = 0;
 	int i;
-	glob_t g;
 
-	glob("/sys/kernel/mm/hugepages/hugepages-*kB", 0, NULL, &g);
-	assert(g.gl_pathc <= NUM_PAGESIZES);
-	for (i = 0; (i < g.gl_pathc) && (num_page_sizes < NUM_PAGESIZES); i++) {
-		sscanf(g.gl_pathv[i], "/sys/kernel/mm/hugepages/hugepages-%lukB",
-				&page_sizes[num_page_sizes]);
-		page_sizes[num_page_sizes] <<= 10;
-		ksft_print_msg("Found %luMB\n", page_sizes[i] >> 20);
+	num_page_sizes = hugetlb_setup(NUM_PAGES, page_sizes, ARRAY_SIZE(page_sizes));
 
-		if (page_sizes[num_page_sizes] > largest)
+	for (i = 0; i < num_page_sizes; i++)
+		if (page_sizes[i] > largest)
 			largest = page_sizes[i];
 
-		if (read_free(page_sizes[num_page_sizes]) >= NUM_PAGES)
-			num_page_sizes++;
-		else
-			ksft_print_msg("SKIP for size %lu MB as not enough huge pages, need %u\n",
-				       page_sizes[num_page_sizes] >> 20, NUM_PAGES);
-	}
-	globfree(&g);
-
-	read_sysfs("/proc/sys/kernel/shmmax", &shmmax_val);
-	if (shmmax_val < NUM_PAGES * largest) {
-		ksft_print_msg("WARNING: shmmax is too small to run this test.\n");
-		ksft_print_msg("Please run the following command to increase shmmax:\n");
-		ksft_print_msg("echo %lu > /proc/sys/kernel/shmmax\n", largest * NUM_PAGES);
-		ksft_exit_skip("Test skipped due to insufficient shmmax value.\n");
-	}
-
-#if defined(__x86_64__)
-	if (largest != 1U<<30) {
-		ksft_exit_skip("No GB pages available on x86-64\n"
-				   "Please boot with hugepagesz=1G hugepages=%d\n", NUM_PAGES);
-	}
-#endif
+	shm_limits_prepare(NUM_PAGES * largest);
 }
 
 int main(void)
@@ -233,3 +174,5 @@ int main(void)
 
 	ksft_finished();
 }
+
+SHM_LIMITS_RESTORE()
-- 
2.53.0


