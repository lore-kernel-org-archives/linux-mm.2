Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C518BF46C46
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 14:22:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A6B96B00EF; Mon,  6 Apr 2026 10:22:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37E356B00F1; Mon,  6 Apr 2026 10:22:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BB856B00F2; Mon,  6 Apr 2026 10:22:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 197C16B00EF
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 10:22:15 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D5BDCE0C91
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:22:14 +0000 (UTC)
X-FDA: 84628345788.26.07FF233
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3C09C4000A
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:22:13 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BYH1bLrW;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775485333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xOBN5bNIfK+IPrN4puPQk3ndADsoOG+Svf1m9y0gKbQ=;
	b=EMUTCbX+wWOPpTfYicdmlJXlYl2h7PmRBim3rmi9bAMDHX4ls1KUdXV2KuXy0s+w7Am5R+
	7ORnRumS1YEPNSwtja/7Ckt/ETou0mADi1dE7E/cQglecTTEi92eYPyiFNfDbu4/AC99rh
	9Nj+T5pVz8sYokGvpsiqMSzjIVBInjU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BYH1bLrW;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775485333; a=rsa-sha256;
	cv=none;
	b=HQ6tGJsMJSADKaSNjdHoAEcnK/S8cEZPajYkKGR3cjuKQnaHMB7VF1trZ7BMynW9SnMAef
	SEp80DdgshP0SMM4biVT1k3S8grt20XdUGyWAxIXvqYy3yB3pag6/yUCtesDyvwymVdFEc
	BLv5scvndHbTg4e4W261dvTBEnZTkCo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C506160133;
	Mon,  6 Apr 2026 14:22:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34247C4CEF7;
	Mon,  6 Apr 2026 14:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775485332;
	bh=pMqT3V7GrLrPKmH8KQ0+ElCx+AnALakW5vIuoVUm4lQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BYH1bLrWN+kqDPqrKkbA/4R+gwbNFK9TBYJJa3XC5o3+nbbQZq/YB07XN+qTrXCBf
	 fa88CC6sECrTZ+O+5xaH46DwoO6jiK8+Hd8+evRAks2PIOzIFS4+VOAQGY25EqjXr4
	 gcdfR7i5izU3e6Zq8MNeyIK/UyEvLgw4rwoKZOE6wCVMNl3GrxX1hWzPdqpeiqkz7m
	 YaPtB/OurDAY0cwg+u7lRJnJeIDEvX9EVncLETO+joHQ0QmB4RaD5HKr2Fa2Ag3/Mc
	 j55mno1SZEFewORkJd+GfGteJYauRJNz2FCogxmmj/5bwnTIg67pWSOsXIVxEWcGsA
	 EbXS0MNwPJUMA==
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
Subject: [PATCH 46/53] selftests/mm: thuge-gen: add setup of HugeTLB pages
Date: Mon,  6 Apr 2026 17:17:28 +0300
Message-ID: <20260406141735.2179309-47-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260406141735.2179309-1-rppt@kernel.org>
References: <20260406141735.2179309-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 3C09C4000A
X-Stat-Signature: e8mkjhqp8pndwkdrh6dntx16ayfrznpi
X-Rspamd-Server: rspam06
X-HE-Tag: 1775485333-722791
X-HE-Meta: U2FsdGVkX19Q9TDovCgweanzWit66zCoSc4ZBpuBn849Ga+GwMTQ+hW85hIO12KrhDcCLQYE0bvwuhCFT6dqbatUcDkG68HYrnIAsnUfrZnLbyezQ4vDghQlp/RSxmY14k9IST975DgWPkLUPkguHE6d4CAvjAkfuujEvMpECyGBSZQjs0ANzLbB4eB/GhuWMgrCFZm/CcLnR7x499Xn5NihQZVVBkAQSk8ZhEmIfTzyq+TUxc5d6X041xoWQ7SC1Zv3ADaJJWlLm78rYfPXMTaE0ih0nqJewBBQxvILJ5LTJc87R4bzCaFZ59Vfbq+es3muuUjJ+IjKvKN3NrV3gMMfDUD5N0s1mpHa4nmyzvbLZiiTZZ4F6QH08xKV69eXOmKlboDTON5PDgJojhRh90JS9Vqf5St2evVsJIqVwiXiuxK6pqZRqtbzOywGumn78UmLtK2asSMAdEA1Aygo2BbEXaMAV1TW5Lp1j9LmuqWpTrwwv92cGRbI8I+wNThrfK+VlGyxrcRp7nwjlC20XZ2KiEqWlfuaAQztmEanGEQCRmfOC+uj26O8zshcG5VgDksgeYanJrvL4+SS1mgvjr74BhKJ16M7/Aa78BN8MSUGQXUUies818EJ4ofqs4m3eb+zSRXDQV5duGQw68pqrxoO9OLm1YTrxZ+juQkBtu883L2e3cotB5H+eLqerzUr3xhn9sTSY96xRb/emR3GhP31iBA52r/2gUDfV1V1brKRorF2czLy3Fm4QShTttw1BjEtF04rXLVW6GDfzVN6Q7ffCYdfB52NOTL1KM5WszuXT2Vb5i9zXw7A8jQUsHFYusYx9how3aH0cYz5lEcRwfxy6zO7yldzsWg3X5x0lO8UujoL0/a3WxbYr4X7yaca7/xbT/7ifT27oZVvJNRlEupxgma5RHCjwHi22wFLG9fDys7MCa3Fbd6BcI9XMIPB5ItrJyhSqFor0iTfK3s
 UtfUvxs7
 VB3n6OTVZiS10ABrVGkYt8a7DybUh3wRKfc5WvR1tYfjzgg4Oqtj5av6hczoFah8xlWh47h05RCW3l/14qIvMOi1eQt7LhVLF390O9ivj4aogIV2HDoIv/KXPq0tNv0L48zNI68yxiKa58XIk3gaaT6DaMDTHKheDKu5NcJLqfmrPqUVPK45HkcQyvz4hnSjugL1pwXu7FsZ5ae9mcG09HbiARJOvIKXrFwVhsM58EDTVdWw=
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


