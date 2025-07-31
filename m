Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F13B9C87FCC
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 16:03:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 957806B009A; Thu, 31 Jul 2025 12:03:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92E146B009B; Thu, 31 Jul 2025 12:03:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81D046B009C; Thu, 31 Jul 2025 12:03:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 72E696B009A
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 12:03:21 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1683080A6D
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 16:03:21 +0000 (UTC)
X-FDA: 83725029402.04.FB7AD63
Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	by imf24.hostedemail.com (Postfix) with ESMTP id EA2F0180020
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 16:03:18 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=E6VahAaG;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf24.hostedemail.com: domain of usama.anjum@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=usama.anjum@collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753977799; a=rsa-sha256;
	cv=pass;
	b=Oej66EepIKfOtJUpsF17+hg+5WA6/nagwQCVh/899npQ4rmekGlAZgV36DnOm+z1plhVEU
	rwxdk2oDnsrR0peAxbytzFmDZQJKUlaga+ON/eqGyz/It9YyfUxeysjKp8UdH0qrc6Qcb8
	3Y9fbYamqczwmz5upSRTwvv1r3fkHEo=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=E6VahAaG;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf24.hostedemail.com: domain of usama.anjum@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=usama.anjum@collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753977799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IEdSZK7BVhWiUkrksFPbARcRG5+aotsZi9NQHzMPA1I=;
	b=QIcFgfEzSE2ULiYspXQIkvmpuN9pSWpixFUQsan4KBZiuJVQA9V9GMpymqbWl6mBqFg3M3
	Zf/WFHqemZb7UldFesTSO6gF+HiZyWGZtmdKy7aN4lQIJ+i6pC1x4gEh18Zun4zeetHmvP
	bZIq5YMd3bfyR81WFhe5/pivIk+/iWc=
ARC-Seal: i=1; a=rsa-sha256; t=1753977784; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=XFbIrRynXJTqh255w+Bcv63YcecInwcY/a8pr6RlBQOHb6UO3Zt7PspmhL/1dQePPhLiKW7fMIEpfklxYBt6U6g9/dj2T8u9PEW3/4ihGDit/eIwyAzOZlf9B+44EUbLr9LPVw/FYz8XZIXct/EFMpumfaF15wfGzOqaf2AppsQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1753977784; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=IEdSZK7BVhWiUkrksFPbARcRG5+aotsZi9NQHzMPA1I=; 
	b=i2s0Kv/1hGZC2uDof4YyK9x3ZHxOVOxNAXyg9SwCxXrUV9dVN6mYMPkcnCGEmIWSRR0vYHHoIyTlBwsOHp+O12kEdioIU5/+sfvyRIg8Px1Fn5qRSJ6kLFHoaYqWZ/MV4GzWYSWDs3NvitdXcj19OVxlZvkllDguzkjK6z+Zk34=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=usama.anjum@collabora.com;
	dmarc=pass header.from=<usama.anjum@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1753977784;
	s=zohomail; d=collabora.com; i=usama.anjum@collabora.com;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Reply-To;
	bh=IEdSZK7BVhWiUkrksFPbARcRG5+aotsZi9NQHzMPA1I=;
	b=E6VahAaGRGN23zw7DQhMgvi51C2eLOgNj/v1QFz/TsaA3iKZIhbPVBTjHL7Chews
	Mzef51zH9u8p8oKRuAqQ58ut1RqTMcpuO43eTZPKWtSBLcFK1enDkUpBu/nMYLiQUfK
	vZeV8oswMxQuPsYu1wtYpnckldEvWWN+lS1RbiT0=
Received: by mx.zohomail.com with SMTPS id 1753977781741413.5702658287519;
	Thu, 31 Jul 2025 09:03:01 -0700 (PDT)
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Leon Romanovsky <leon@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	Shuah Khan <shuah@kernel.org>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>,
	kernel@collabora.com
Subject: [PATCH v2 5/8] selftests/mm: Remove unused parameters
Date: Thu, 31 Jul 2025 21:01:29 +0500
Message-Id: <20250731160132.1795351-6-usama.anjum@collabora.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250731160132.1795351-1-usama.anjum@collabora.com>
References: <20250731160132.1795351-1-usama.anjum@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EA2F0180020
X-Stat-Signature: 7r8oigpemi7gwsaan79nxfcf4m4r83w1
X-HE-Tag: 1753977798-355403
X-HE-Meta: U2FsdGVkX1+eC9qoIhANBasDm/zcx7Au9RaZt+wwMiCCevZwduyfeJ8faD5xcixZAaq6Gf6aVgCe0ebRI5ded/9tiYsyDO7eDMz7C+WERNmqUrUVB+u89L3aVCuTEsDbVUPlczPKpDbqrh1pxL4bKZ1jSzcBFUFUIOXnMoDr1R5Xx+ukmBkSqVLtLpOJKNTqNMj8hyJco0xVk/vIFogqXYYL2K19oLZ84GEoI02l+vEQCuZKPTHSQoDWEyS9vreRnP3iUq7RQuyH7w49kI4pyY2c/kkz4VgPxyQUAZzEMCmR6j+cNvJM4ooIdtBCAPRlfB1dtlI0UVLSlFH4EONAPuFEYTSvZs+QC+q2CtHDWGFKUwssKLIb/WUrkN1H53dW4FJ7etW6uRyvIYU6dtSfTnmkezBq3a6te0XvAZKCXgnvbiBM95QgnEACPylPtuGiIjkpaizGiFhe55Kwyg8P24EGkcvCR+rPKxnM0il+eAM9A0DnswbAvU1+vDB0xgIjMlMb+sTqdEsjzRWHsj/+JkUfJM8JgrTqe6QvaDKhHiSewLmzeeiI4GVzOdkHbnGOEyOugo/73m7JCDoVdPIzqwK0ZL5ucIJJwXhGrfkyL/JOrW6/rZV0lLZcwUUhLdFnFmmn5K1+9hfioLR4QPGjaOn1ADjzVLgJ2j9p8vyp6ptw9DcInjpcvv3IeI0oetWC6ZlvBq6zvaybQZxDEULHHX6BEG42PAncX0JLNfSUpVioOvo5kKGUIjp14G7YmSCvd1WQt1D9w1Z0qPeQ1s4wxb5WzeHdRJEoSHlf2yxjnJz/su0a+ajvG3RSLJFirox6jvKK72OSDOOldBDumUW3k4pcdml/pCTH8RBJYPaDKZdlAue8zMW7HedqqYEf8RTjh3DNCOiTuIjGHPTX1z6d/Q7eRIsrzRHSS+5Cw85BTEBjABIfos5JBEC3Dfs0LsdHZgmUjicNFW80lHoRYnM
 DIItSQi+
 qU0eO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Cleanup code and remove the unused arguments

Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
---
 tools/testing/selftests/mm/ksm_tests.c          | 17 +++++++----------
 tools/testing/selftests/mm/soft-dirty.c         |  4 ++--
 .../testing/selftests/mm/split_huge_page_test.c |  4 ++--
 tools/testing/selftests/mm/uffd-common.c        |  4 ++--
 tools/testing/selftests/mm/uffd-common.h        |  2 +-
 tools/testing/selftests/mm/uffd-stress.c        |  2 +-
 tools/testing/selftests/mm/uffd-unit-tests.c    |  8 ++++----
 7 files changed, 19 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/mm/ksm_tests.c b/tools/testing/selftests/mm/ksm_tests.c
index b77462b5c240b..f5dabb513ed7f 100644
--- a/tools/testing/selftests/mm/ksm_tests.c
+++ b/tools/testing/selftests/mm/ksm_tests.c
@@ -238,8 +238,7 @@ static int ksm_merge_pages(int merge_type, void *addr, size_t size,
 	return 0;
 }
 
-static int ksm_unmerge_pages(void *addr, size_t size,
-			     struct timespec start_time, int timeout)
+static int ksm_unmerge_pages(void *addr, size_t size)
 {
 	if (madvise(addr, size, MADV_UNMERGEABLE)) {
 		perror("madvise");
@@ -456,7 +455,7 @@ static int get_first_mem_node(void)
 	return get_next_mem_node(numa_max_node());
 }
 
-static int check_ksm_numa_merge(int merge_type, int mapping, int prot, int timeout,
+static int check_ksm_numa_merge(int merge_type, int timeout,
 				bool merge_across_nodes, size_t page_size)
 {
 	void *numa1_map_ptr, *numa2_map_ptr;
@@ -520,8 +519,7 @@ static int check_ksm_numa_merge(int merge_type, int mapping, int prot, int timeo
 	return KSFT_FAIL;
 }
 
-static int ksm_merge_hugepages_time(int merge_type, int mapping, int prot,
-				int timeout, size_t map_size)
+static int ksm_merge_hugepages_time(int merge_type, int timeout, size_t map_size)
 {
 	void *map_ptr, *map_ptr_orig;
 	struct timespec start_time, end_time;
@@ -656,7 +654,7 @@ static int ksm_unmerge_time(int merge_type, int mapping, int prot, int timeout,
 		perror("clock_gettime");
 		goto err_out;
 	}
-	if (ksm_unmerge_pages(map_ptr, map_size, start_time, timeout))
+	if (ksm_unmerge_pages(map_ptr, map_size))
 		goto err_out;
 	if (clock_gettime(CLOCK_MONOTONIC_RAW, &end_time)) {
 		perror("clock_gettime");
@@ -884,8 +882,8 @@ int main(int argc, char *argv[])
 						page_size);
 		break;
 	case CHECK_KSM_NUMA_MERGE:
-		ret = check_ksm_numa_merge(merge_type, MAP_PRIVATE | MAP_ANONYMOUS, prot,
-					ksm_scan_limit_sec, merge_across_nodes, page_size);
+		ret = check_ksm_numa_merge(merge_type, ksm_scan_limit_sec, merge_across_nodes,
+					   page_size);
 		break;
 	case KSM_MERGE_TIME:
 		if (size_MB == 0) {
@@ -900,8 +898,7 @@ int main(int argc, char *argv[])
 			printf("Option '-s' is required.\n");
 			return KSFT_FAIL;
 		}
-		ret = ksm_merge_hugepages_time(merge_type, MAP_PRIVATE | MAP_ANONYMOUS, prot,
-				ksm_scan_limit_sec, size_MB);
+		ret = ksm_merge_hugepages_time(merge_type, ksm_scan_limit_sec, size_MB);
 		break;
 	case KSM_UNMERGE_TIME:
 		if (size_MB == 0) {
diff --git a/tools/testing/selftests/mm/soft-dirty.c b/tools/testing/selftests/mm/soft-dirty.c
index e62be4136f69e..751fbc52857ea 100644
--- a/tools/testing/selftests/mm/soft-dirty.c
+++ b/tools/testing/selftests/mm/soft-dirty.c
@@ -76,7 +76,7 @@ static void test_vma_reuse(int pagemap_fd, int pagesize)
 	munmap(map2, pagesize);
 }
 
-static void test_hugepage(int pagemap_fd, int pagesize)
+static void test_hugepage(int pagemap_fd)
 {
 	char *map;
 	int i, ret;
@@ -210,7 +210,7 @@ int main(void)
 
 	test_simple(pagemap_fd, pagesize);
 	test_vma_reuse(pagemap_fd, pagesize);
-	test_hugepage(pagemap_fd, pagesize);
+	test_hugepage(pagemap_fd);
 	test_mprotect_anon(pagemap_fd, pagesize);
 	test_mprotect_file(pagemap_fd, pagesize);
 
diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index a85b2e393e4e8..2c56ab2d220f7 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -106,7 +106,7 @@ static char *allocate_zero_filled_hugepage(size_t len)
 	return result;
 }
 
-static void verify_rss_anon_split_huge_page_all_zeroes(char *one_page, int nr_hpages, size_t len)
+static void verify_rss_anon_split_huge_page_all_zeroes(char *one_page, size_t len)
 {
 	unsigned long rss_anon_before, rss_anon_after;
 	size_t i;
@@ -142,7 +142,7 @@ void split_pmd_zero_pages(void)
 	size_t len = nr_hpages * pmd_pagesize;
 
 	one_page = allocate_zero_filled_hugepage(len);
-	verify_rss_anon_split_huge_page_all_zeroes(one_page, nr_hpages, len);
+	verify_rss_anon_split_huge_page_all_zeroes(one_page, len);
 	ksft_test_result_pass("Split zero filled huge pages successful\n");
 	free(one_page);
 }
diff --git a/tools/testing/selftests/mm/uffd-common.c b/tools/testing/selftests/mm/uffd-common.c
index a37088a23ffef..815c22114b57e 100644
--- a/tools/testing/selftests/mm/uffd-common.c
+++ b/tools/testing/selftests/mm/uffd-common.c
@@ -416,7 +416,7 @@ static void continue_range(int ufd, __u64 start, __u64 len, bool wp)
 		    ret, (int64_t) req.mapped);
 }
 
-int uffd_read_msg(int ufd, struct uffd_msg *msg)
+int uffd_read_msg(struct uffd_msg *msg)
 {
 	int ret = read(uffd, msg, sizeof(*msg));
 
@@ -537,7 +537,7 @@ void *uffd_poll_thread(void *arg)
 		}
 		if (!(pollfd[0].revents & POLLIN))
 			err("pollfd[0].revents %d", pollfd[0].revents);
-		if (uffd_read_msg(uffd, &msg))
+		if (uffd_read_msg(&msg))
 			continue;
 		switch (msg.event) {
 		default:
diff --git a/tools/testing/selftests/mm/uffd-common.h b/tools/testing/selftests/mm/uffd-common.h
index 7700cbfa39756..2e7066d69103d 100644
--- a/tools/testing/selftests/mm/uffd-common.h
+++ b/tools/testing/selftests/mm/uffd-common.h
@@ -117,7 +117,7 @@ void uffd_stats_report(struct uffd_args *args, int n_cpus);
 int uffd_test_ctx_init(uint64_t features, const char **errmsg);
 void uffd_test_ctx_clear(void);
 int userfaultfd_open(uint64_t *features);
-int uffd_read_msg(int ufd, struct uffd_msg *msg);
+int uffd_read_msg(struct uffd_msg *msg);
 void wp_range(int ufd, __u64 start, __u64 len, bool wp);
 void uffd_handle_page_fault(struct uffd_msg *msg, struct uffd_args *args);
 int __copy_page(int ufd, unsigned long offset, bool retry, bool wp);
diff --git a/tools/testing/selftests/mm/uffd-stress.c b/tools/testing/selftests/mm/uffd-stress.c
index 40af7f67c4074..4a615ab0c0506 100644
--- a/tools/testing/selftests/mm/uffd-stress.c
+++ b/tools/testing/selftests/mm/uffd-stress.c
@@ -137,7 +137,7 @@ static void *uffd_read_thread(void *arg)
 	/* from here cancellation is ok */
 
 	for (;;) {
-		if (uffd_read_msg(uffd, &msg))
+		if (uffd_read_msg(&msg))
 			continue;
 		uffd_handle_page_fault(&msg, args);
 	}
diff --git a/tools/testing/selftests/mm/uffd-unit-tests.c b/tools/testing/selftests/mm/uffd-unit-tests.c
index 50501b38e34e7..df7b82bbebaad 100644
--- a/tools/testing/selftests/mm/uffd-unit-tests.c
+++ b/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -248,7 +248,7 @@ static void *fork_event_consumer(void *data)
 	ready_for_fork = true;
 
 	/* Read until a full msg received */
-	while (uffd_read_msg(args->parent_uffd, &msg));
+	while (uffd_read_msg(&msg));
 
 	if (msg.event != UFFD_EVENT_FORK)
 		err("wrong message: %u\n", msg.event);
@@ -1352,11 +1352,11 @@ static void *uffd_mmap_changing_thread(void *opaque)
 	return NULL;
 }
 
-static void uffd_consume_message(int fd)
+static void uffd_consume_message(void)
 {
 	struct uffd_msg msg = { 0 };
 
-	while (uffd_read_msg(fd, &msg));
+	while (uffd_read_msg(&msg));
 }
 
 static void uffd_mmap_changing_test(uffd_test_args_t *targs)
@@ -1407,7 +1407,7 @@ static void uffd_mmap_changing_test(uffd_test_args_t *targs)
 	 * All succeeded above!  Recycle everything.  Start by reading the
 	 * event so as to kick the thread roll again..
 	 */
-	uffd_consume_message(uffd);
+	uffd_consume_message();
 
 	ret = pthread_join(tid, NULL);
 	assert(ret == 0);
-- 
2.39.5


