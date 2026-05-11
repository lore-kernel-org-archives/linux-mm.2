Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AD2CCD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:34:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E61D56B0131; Mon, 11 May 2026 12:34:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E12E06B0132; Mon, 11 May 2026 12:34:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D00E36B0133; Mon, 11 May 2026 12:34:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BAEF56B0131
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:34:06 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7CF828AAE8
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:34:06 +0000 (UTC)
X-FDA: 84755686092.20.3820D50
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id C2A3C10000B
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:34:04 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G2ggixs5;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778517244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cj5Nf4EiAVB4ETZe2n6LKOP44sad3F3iAZpLcSoYE7w=;
	b=vLe8WKhMKo3tJ9HyqhEQV2kGJKr8ihhJIB7R2hyTbPXy7XHhEHwPchV5Kgbc5h5p+WEYC6
	aBt7zeBxekqm8PN1emnfMYZ10omh65XHnSCYy7TgMy6iRZ89QLvL4dHLSPb2vAAU208DU7
	tw990DYI1O5X3u3zPj4QzD8O7ZLMk5o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778517244; a=rsa-sha256;
	cv=none;
	b=VtvrlZiszp1uD5NjeEU3MIq2vitcohBpble5tc2cznGqcaMAxT/7EkNw9NZ6DpqNE0rz4V
	M4uActhqOsMigI6aJ+5UbiD2VGEoFkCRPUGu81hyOncEUp2++stc3LznSif7jVTNjvyINM
	tARzf9SA+i0umNvbMSl8fUGd61K22Uc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G2ggixs5;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 45AFE60103;
	Mon, 11 May 2026 16:34:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0989C4AF0B;
	Mon, 11 May 2026 16:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778517244;
	bh=XGg/LGnzON7r+Tj6h3bYnErudi+BX4tIkC2eIY7FpGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G2ggixs5FOozgYHUSLdK0IxGtv97AHpQj4b6fyghJq+HSCKhnnf97LzWCBte2kVXA
	 4X+psOlHm+tRd4acKnFCuDIM0hQl9s7Tt36Kgj9nKnYVD21SOctefcz/J2MOedBtKS
	 2sUxg5LeQk4kXwnBJUTTqesdTYswYRBWWMFyAOlNkCddUQdn5QElKr13uKTNYMtdAH
	 nVGKcQrtrNed0/u6vJ5zljoROM1zry7A6ceb+gL8trwuRTUxATMZlsYaR0K+kV+g3u
	 jNJnoxEZnAdEgH4pxyrUiZ66yq2Krz3pSa3gORHncXj3ReYbf5Ouzh6Ck5FiC/r8rW
	 FVA2FGLW493Hg==
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
Subject: [PATCH v4 48/55] selftests/mm: thuge-gen: add setup of HugeTLB pages
Date: Mon, 11 May 2026 19:28:32 +0300
Message-ID: <20260511162840.375890-49-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511162840.375890-1-rppt@kernel.org>
References: <20260511162840.375890-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C2A3C10000B
X-Stat-Signature: wy7xqs87u5eoi3ffpcmhe4tjgijuxfm3
X-Rspam-User: 
X-HE-Tag: 1778517244-460189
X-HE-Meta: U2FsdGVkX18s9tblqY2KmqnnKPFcATHhaiFfo4AHw/FFO9wOlyavDqFntb0XRX1p0gMzyQr3Klv7/w5CROnW942rLy+tNKju8o4/2OUznC7sOa3Cygs23V6gBrvroITIoWRjeCOUYIitU7+k+EtmIJPod1+dVvEBO8oD+DW79RmWvZWku13J6+Abh6f+9U9vXEyAbWYHl7/VX8j7++Ti52s84ZCHg6TivDq4h4otvJyUpOEu6SahyyU+1roiA4hb8MDVjB6U6J5jNE8icPROQmwgfGS5sDe8FmXcNhvagSSEg2pVUqPo63IDDV2+XOnzqQvMwzwczsnp0rbC45+7CkVVwxSRsBc3mXtOratba3p2PfGXXhlerdSlHbJsMla4x7cbef1vPlvBK+FrW9f/UyjQaJvb0wI5yucfGoYqW34yEWAVQ2pQ9HIExT3mH6tFVyoudQKJ32S+aHxzrn30u/WTsSHw0tSQlBDWBpL83LHVg8hUtfrPrZaQgTkMO0PSJnmXhDlhHJX78qusNqJGxL7gFq0pao7VLqWkh5eLDaVlooC8tdVImrk58sBUuplC/bze1+YFkG6LsIFyWRrNxrutB+C4dv+y5YNZQJdp5cmrjREe53gaDz5FXntpLfUgy7t0gU0ed+aqj+YKEKeMerEeZVT2XhdPcFgZhMHwgKGhG3/mYMZLmeu1MyWT0DwWq3UZk/1n6cOayrLxf/cQT+UpxhXtZy0/zMyaDzCYBfUyAlJqZlX6HVSutpsIJyjwuwewzqcj7aqTzeivtvhjt0xafTtM8uT+yKjmo/EoLtUXdViafVkAY3Gq7HtOgbGLKtJOMxf8aaXkGKYPtJVjSzI63JHR321o8PKDnOiP1kZejs0K0LgO6y5n+zPhqqRuSaj+tQc0pck1u2EQY4CIDx/rej66zzfYi064edN+vHySo1AXQPm08C0fxtBI6Zcdt7wLrJVh8vJQMaNeWgz
 Gq0UUes2
 rSnpHiOH19bkE5Spao3PWMxjlG/CMJaDs5zKdWzIuqHFiFAzexrzdXbCHsRJEgVV34C+ECEYUvTmYJCKOsYIti+Fl3YbBagpD/aCA104pASH0Q04ua8fEwRfQSG2I5eQ4/POgTuP3kGyP5oMc46bBg0OHDbMxIGR82iySE1EE5FSnnoIZ5N50GY5KractvwE0GvNLgmK0EjR6vEU9EnDCqn6Ba5cqHkseH2LLXpQn3KKJxNUM1sT6C7eYdKtqt27u96UlPYFhfBlpunlIwngWQE+KlaAwt4ilTPfRO82I4zQWXtGWF3bVXTf5WMTHk++9jziY
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

Tested-by: Luiz Capitulino <luizcap@redhat.com>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/thuge-gen.c | 95 ++++----------------------
 1 file changed, 12 insertions(+), 83 deletions(-)

diff --git a/tools/testing/selftests/mm/thuge-gen.c b/tools/testing/selftests/mm/thuge-gen.c
index 1007bc8aa57c..22b9c2f1c35d 100644
--- a/tools/testing/selftests/mm/thuge-gen.c
+++ b/tools/testing/selftests/mm/thuge-gen.c
@@ -1,17 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Test selecting other page sizes for mmap/shmget.
-
-   Before running this huge pages for each huge page size must have been
-   reserved.
-   For large pages beyond MAX_PAGE_ORDER (like 1GB on x86) boot options must
-   be used. 1GB wouldn't be tested if it isn't available.
-   Also shmmax must be increased.
-   And you need to run as root to work around some weird permissions in shm.
-   And nothing using huge pages should run in parallel.
-   When the program aborts you may need to clean up the shm segments with
-   ipcrm -m by hand, like this
-   sudo ipcs | awk '$1 == "0x00000000" {print $2}' | xargs -n1 sudo ipcrm -m
-   (warning this will remove all if someone else uses them) */
+/* Test selecting other page sizes for mmap/shmget. */
 
 #define _GNU_SOURCE
 #include <sys/mman.h>
@@ -21,8 +9,6 @@
 #include <sys/ipc.h>
 #include <sys/shm.h>
 #include <sys/stat.h>
-#include <glob.h>
-#include <assert.h>
 #include <unistd.h>
 #include <stdarg.h>
 #include <string.h>
@@ -38,15 +24,6 @@
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
@@ -64,32 +41,10 @@ int ilog2(unsigned long v)
 
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
+	ksft_print_msg("%luMB: %lu\n", ps >> 20, hugetlb_free_pages(ps));
 }
 
 void test_mmap(unsigned long size, unsigned flags)
@@ -97,14 +52,14 @@ void test_mmap(unsigned long size, unsigned flags)
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
@@ -121,7 +76,7 @@ void test_shmget(unsigned long size, unsigned flags)
 	struct shm_info i;
 	char *map;
 
-	before = read_free(size);
+	before = hugetlb_free_pages(size);
 	id = shmget(IPC_PRIVATE, size * NUM_PAGES, IPC_CREAT|0600|flags);
 	if (id < 0) {
 		if (errno == EPERM) {
@@ -142,7 +97,7 @@ void test_shmget(unsigned long size, unsigned flags)
 	shmctl(id, IPC_RMID, NULL);
 
 	memset(map, 0xff, size*NUM_PAGES);
-	after = read_free(size);
+	after = hugetlb_free_pages(size);
 
 	show(size);
 	ksft_test_result(size == getpagesize() || (before - after) == NUM_PAGES,
@@ -154,43 +109,15 @@ void test_shmget(unsigned long size, unsigned flags)
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
@@ -233,3 +160,5 @@ int main(void)
 
 	ksft_finished();
 }
+
+SHM_LIMITS_RESTORE()
-- 
2.53.0


