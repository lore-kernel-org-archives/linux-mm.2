Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDB33F99C79
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 11:00:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DCFA6B0290; Sat, 18 Apr 2026 07:00:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 266C66B0292; Sat, 18 Apr 2026 07:00:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12E446B0293; Sat, 18 Apr 2026 07:00:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0047F6B0290
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 07:00:34 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B62DF13B09B
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 11:00:34 +0000 (UTC)
X-FDA: 84671383188.21.9C59A90
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 16E7AC0017
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 11:00:32 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AF9UZv3X;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776510033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xOBN5bNIfK+IPrN4puPQk3ndADsoOG+Svf1m9y0gKbQ=;
	b=K/T2NG9bRlo231IcixG2JWhnjdWmn/gDJ20hDvl4vzpPtKx2jpFx4M2tEAV7U/cZIBvEVJ
	IUVvG4zJjX7uy+C3I+sXVU0WigVV1CaUngK0BiaJSmnrTGA5WMNexRnEtoWRXNccYyRN+l
	CJ87r7+COkaRGB2Yly+62/ZNVlkmKpY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776510033; a=rsa-sha256;
	cv=none;
	b=KJfkL9WFyvbZzH/rvOPDjtSMUlFozqZRRIyfA+Ov8Q9zPdwmEyXMFQw21BUjxMFunczR/a
	XVPwUnECJJnicv2ur5A97XogoqBdpzs5XjspTVEzw1Ix0EkDR/vj2ZMzn71qBwv2P8B38w
	8D/VwOulzU1akreO66WrCx8XMG7y/lw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AF9UZv3X;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7D2AC6013A;
	Sat, 18 Apr 2026 11:00:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89ECFC2BCB6;
	Sat, 18 Apr 2026 11:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776510032;
	bh=pMqT3V7GrLrPKmH8KQ0+ElCx+AnALakW5vIuoVUm4lQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AF9UZv3XMd4zHWGx71valA+JNXjEu6sWca0/R7uSAyyRp+uIfBXC8uUqm+VTuZNls
	 VeGC2hYnoCh6WWVtD7E4YUsPxSVBHJvzisIwz/+Wc5MuyH6eWW3V02rI8zXg99aEHn
	 L5XWaF2DoUPUVz9XrMxu21P5lTuseV8ErD5nP9iAeRza/x6RhqpQKjpomnDtfHqqeS
	 cU93JQ+xj+qpubHIoxoIMX9TeGa8EQFThnqhjdOLXhF7bWZA4BjSAmDk4PireETjWX
	 L8dUr9Zqpr+wiviVJL/ZRbEKcy5hNKo05uUxLl2oqBtmAf2/qMmpUMrK+1zUv1eRzs
	 IcQUjfX1R7MNQ==
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
Subject: [PATCH v2 46/53] selftests/mm: thuge-gen: add setup of HugeTLB pages
Date: Sat, 18 Apr 2026 13:55:31 +0300
Message-ID: <20260418105539.1261536-47-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260418105539.1261536-1-rppt@kernel.org>
References: <20260418105539.1261536-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rmyto19h6tfswxb67izxgnz83k4dy8j6
X-Rspam-User: 
X-Rspamd-Queue-Id: 16E7AC0017
X-Rspamd-Server: rspam05
X-HE-Tag: 1776510032-881517
X-HE-Meta: U2FsdGVkX18Agthg4qZulbiJgER0FHcF/8LiPvhqmHOtElZQRiFakShefPeP1xy6FsqxznvhhudsMwhASEXlnXdxJZbxRbSRwFS3cIPnMnbY6XTawKs//0JmSGIXKemNAiPYWSbWLhre+Hj2ooCtskhyAnc87QFQ+AwEee39GrG1qvqrsptb71f+E5uK5daGmN1cVUW3/YvxOm4Z4KYcEOR3i1sKE5FfJFQbE2rPD06ZBMv/QCB5/cdYjdaz8KIZNEY+oJ2QqJp2YkOJnQRJ09VTtZtRoIMK/k9QKfbg7d3e9UhyFGuHWPfug4uuVgiirOiItC1U95dbb20IudTSdRS7mdMaUZiG5jUapvMwxuCDbA3bMxXJiSXx3aPfd6XRnIkTX8XR4Qd757p8jIDAz5e2bygjTu8PelqywttSNCu7jHR6FCVWuNM8g58Ig6lbUUn9ztoT05eKhTZCrpT7lR8L7nBsvVfFnGDOhkYSm4UY2ShPBecl6V4DlKJnSBYS4xK2I9RvEPEX4R4EnyBZEIJ+yz+RzGn8PfYWInXZZjo/IGDS4OYwJdg8ReRJMfZ+S56rwJ2VlI8TuYqs4XutDFcRhPQNe/zyJ8MSJVKqDjOpmqZqi8gBnmnS5e/w0Qpx81Qc10Elvb17hjhB11ClLrBJPAqSor1UO2Bl3A21Vusjw8VkKnRwYIWkITNxbd7oGHnsalAdu8ffkNXEeKB7YWufij9Uh1WDCaCVvnHAt8617ePFQLkiT0FT77JSEHbYN02twS0tGyJuyi7qNJQUQqVZHtwKHAuKVhPtPZVSOiWzd69qihucaOSibwvRiFngB1Zg2LZAA83SrXAPVhOEmVHZ4UF2t+/6ni3v5MQorpbTXWeQ8pNyVWn1jctQU0VYZHchqGn11viYCcByfjBoaPrJKWARDgPvoF/LJSuEoNNXEVy1Vy8mjAdV7vLqAGinQCkgEXDo/+0u5NjfjdQ
 iEkRePAP
 6dwlIK69Dwxy9agXrem9FO6BkcZT2Y92ooUWBQqDBHO5cWxzaZFKubwWJYvWFEV4ReWHtuPbShJRltB46caQE4uVJWl5eUpbtMFK5gGYCk2bIWjjqpBmfdnUHoykToEd+8UXKpyynvKrzLbZFX9nFowXcmr1DwkqsPBQFzl/r+T/rPlkT/j5RNoZtd15LY8Oq6FHPWZ0w8jSSMlY2ONJsbZFUv5/iv2vA2BhTfFnnEHvmRdM=
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


